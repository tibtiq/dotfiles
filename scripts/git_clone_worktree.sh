#!/bin/bash
# This script clones a repo so its setup for git worktrees
# ./script.sh https://github.com/example/repo.git
# repo.worktree/
# └── repo@main/                 # Worktree for the default branch
#    ├── .git/                   # Worktree-specific Git data
#    ├── README.md               # Example repo files
#    └── src/                    # Example source files

# Check if the repo URL is provided
if [ -z "$1" ]; then
  echo "Usage: gcw <repo-url>"
  return
fi

REPO_URL=$1
REPO_NAME=$(basename -s .git "$REPO_URL")

# Clone the repo as a bare repository to determine the default branch
git clone --bare "$REPO_URL" "$REPO_NAME.git"
cd "$REPO_NAME.git" || exit 1
DEFAULT_BRANCH=$(git ls-remote --symref "$REPO_URL" HEAD | awk '/^ref/ {sub("refs/heads/", "", $2); print $2}')
cd ..
echo "cleaning up bare repo"
rm -rf "$REPO_NAME.git"

# Create the destination directory
DEST_DIR="$REPO_NAME.worktree/$REPO_NAME@$DEFAULT_BRANCH"
mkdir -p "$DEST_DIR"

# clone repo
git clone $REPO_URL $DEST_DIR

# Provide a success message
echo "Repository cloned to $DEST_DIR using branch $DEFAULT_BRANCH"

