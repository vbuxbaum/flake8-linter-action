#!/bin/bash

apt-get install python3-dev default-libmysqlclient-dev build-essential

# Run flake8 over the student source and generate a log report
python3 -m venv ".venv/$INPUT_PR_NUMBER" --system-site-packages
source ".venv/$INPUT_PR_NUMBER/bin/activate"
if test -f "dev-requirements.txt" ; then
  python3 -m pip install -r dev-requirements.txt --no-cache-dir
else
  python3 -m pip install -r requirements.txt --no-cache-dir
fi
python3 -m flake8 --append-config=setup.cfg --append-config=/home/report.cfg > /tmp/flake8.log

python3 -m venv ".venv/$INPUT_PR_NUMBER-linter" --system-site-packages
source ".venv/$INPUT_PR_NUMBER-linter/bin/activate"
python3 -m pip install -r "$EVALUATOR_REQUIREMENTS"
python3 "$EVALUATOR_SRC/main.py" /tmp/flake8.log
