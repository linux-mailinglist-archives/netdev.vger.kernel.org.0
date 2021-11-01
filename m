Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40C5441E54
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhKAQiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhKAQiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1CEC061766;
        Mon,  1 Nov 2021 09:35:34 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g10so65996959edj.1;
        Mon, 01 Nov 2021 09:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g4EqKuFdlFIRgCywKtA7dqrj71IuKq9X1salITTz8+o=;
        b=fGDVJKTat38LhVQGLmAuz4yUqB0nnvKfQsaJmOV9qfGRxii8hCunD+NLNpOGijYNYn
         rb2HwgEDMQgsBJUBJFKC5H+3y9mI55azg7pF51HKvDEYCMHeLNVx8DQymj1gXtzEE8sH
         uAxCVuLtu+oazhzC/jL+gtGkDWj1uI3UTQVxk8Uo56pjAb7H+jOTM8JwrwCeRYn1zGNf
         yoB3UBHXev4TAJsnY0Lw8yODR5fPy+RDnCWPI354ewk1D/ioUSxwuJ+hU2EBjvMQtSpF
         JgZV1PGl8/P0UxfxyzgcHogeFatwTo8fKFj3Pk7kZ75N7eVde+td7i2XPsS0NhFAtqwT
         PRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g4EqKuFdlFIRgCywKtA7dqrj71IuKq9X1salITTz8+o=;
        b=I+CCz5AkBIgCTzbSChUOfGzRpkmw5Enl1SN0s/Zmoo/u2P1VEAUK8iLDR19l1t0t89
         8g5eUyGPy0qb5T9z/lMhvMpkN8rMK6FOUjjWlJu9XWzzk8HFxwFOIFkHYN6Ra1e6qBDH
         xJtpsKdhA1DG7mmYSnAA7JzUH9FcXY6RYD1YE0Z026Qo2MO7476JbB+PGgAWgaTU31a4
         e/o33Rq4pXJ4D/RoGFDkIg+BLQ1kjUrAIamOD2RwfTIwZ2FlkNMjDT8Lm9+a+PBaLBdC
         mPrWrl7PIVHKT48kbKzWWa3XQh1IDim+xUuDmZJsd66GEJti58F4uiW3CIgCcKOugsR6
         wGNA==
X-Gm-Message-State: AOAM531C/5xcMGqfm+JoA6tYVh10QulXdy9CydV4sILYaCx1WbjJu8XL
        /wjgBkCucer78rF49uYE3VQ=
X-Google-Smtp-Source: ABdhPJyG7H3dZRAoedGAwQ4oWk5T617oNNU4/4CoOjbfykwi6C7sRsKF5CaOgSctesgLbITfi06M5A==
X-Received: by 2002:a17:907:9495:: with SMTP id dm21mr36715011ejc.561.1635784533308;
        Mon, 01 Nov 2021 09:35:33 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:32 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/25] selftests: Initial tcp_authopt test module
Date:   Mon,  1 Nov 2021 18:34:38 +0200
Message-Id: <6db3afba64c7562412ca1f8fb2ccbc45d66aca21.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test suite is written as a standalone python3 package using
dependencies such as scapy.

The run.sh script wrapper called from kselftest infrastructure uses
"pip" to generate an isolated virtual environment just for running these
tests. The run.sh wrapper can be called from anywhere and does not rely
on kselftest infrastructure.

Default output is in TAP format.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/tcp_authopt/Makefile  | 10 ++++
 .../testing/selftests/tcp_authopt/README.rst  | 18 ++++++++
 tools/testing/selftests/tcp_authopt/config    |  6 +++
 .../selftests/tcp_authopt/requirements.txt    | 46 +++++++++++++++++++
 tools/testing/selftests/tcp_authopt/run.sh    | 31 +++++++++++++
 tools/testing/selftests/tcp_authopt/settings  |  1 +
 tools/testing/selftests/tcp_authopt/setup.cfg | 35 ++++++++++++++
 tools/testing/selftests/tcp_authopt/setup.py  |  6 +++
 .../tcp_authopt/tcp_authopt_test/__init__.py  |  0
 9 files changed, 153 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/Makefile
 create mode 100644 tools/testing/selftests/tcp_authopt/README.rst
 create mode 100644 tools/testing/selftests/tcp_authopt/config
 create mode 100644 tools/testing/selftests/tcp_authopt/requirements.txt
 create mode 100755 tools/testing/selftests/tcp_authopt/run.sh
 create mode 100644 tools/testing/selftests/tcp_authopt/settings
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.cfg
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py

diff --git a/tools/testing/selftests/tcp_authopt/Makefile b/tools/testing/selftests/tcp_authopt/Makefile
new file mode 100644
index 000000000000..256ae2c16013
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../lib.mk
+
+TEST_PROGS += ./run.sh
+TEST_FILES := \
+	requirements.txt \
+	settings \
+	setup.cfg \
+	setup.py \
+	tcp_authopt_test
diff --git a/tools/testing/selftests/tcp_authopt/README.rst b/tools/testing/selftests/tcp_authopt/README.rst
new file mode 100644
index 000000000000..e9548469c827
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/README.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================
+Tests for linux TCP Authentication Option
+=========================================
+
+Test suite is written in python3 using pytest and scapy. The test suite is
+mostly self-contained as a python package.
+
+The recommended way to run this is the included `run.sh` script as root, this
+will automatically create a virtual environment with the correct dependencies
+using `pip`. If not running under root it will automatically attempt to elevate
+using `sudo` after the virtualenv is created.
+
+An old separate version can be found here: https://github.com/cdleonard/tcp-authopt-test
+
+Integration with kselftest infrastructure is minimal: when in doubt just run
+this separately.
diff --git a/tools/testing/selftests/tcp_authopt/config b/tools/testing/selftests/tcp_authopt/config
new file mode 100644
index 000000000000..0d4e5d47fa72
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/config
@@ -0,0 +1,6 @@
+# RFC5925 TCP Authentication Option and all algorithms
+CONFIG_TCP_AUTHOPT=y
+CONFIG_CRYPTO_SHA1=M
+CONFIG_CRYPTO_HMAC=M
+CONFIG_CRYPTO_AES=M
+CONFIG_CRYPTO_CMAC=M
diff --git a/tools/testing/selftests/tcp_authopt/requirements.txt b/tools/testing/selftests/tcp_authopt/requirements.txt
new file mode 100644
index 000000000000..713d4d1b7a55
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/requirements.txt
@@ -0,0 +1,46 @@
+#
+# This file is autogenerated by pip-compile with python 3.8
+# To update, run:
+#
+#    pip-compile
+#
+argparse==1.4.0
+    # via nsenter
+attrs==21.2.0
+    # via pytest
+cffi==1.15.0
+    # via cryptography
+contextlib2==21.6.0
+    # via nsenter
+cryptography==35.0.0
+    # via tcp-authopt-test (setup.py)
+iniconfig==1.1.1
+    # via pytest
+nsenter==0.2
+    # via tcp-authopt-test (setup.py)
+packaging==21.0
+    # via pytest
+pathlib==1.0.1
+    # via nsenter
+pluggy==1.0.0
+    # via pytest
+py==1.10.0
+    # via pytest
+pycparser==2.20
+    # via cffi
+pyparsing==3.0.1
+    # via packaging
+pytest==6.2.5
+    # via
+    #   pytest-tap
+    #   tcp-authopt-test (setup.py)
+pytest-tap==3.3
+    # via tcp-authopt-test (setup.py)
+scapy==2.4.5
+    # via tcp-authopt-test (setup.py)
+tap.py==3.0
+    # via pytest-tap
+toml==0.10.2
+    # via pytest
+waiting==1.4.1
+    # via tcp-authopt-test (setup.py)
diff --git a/tools/testing/selftests/tcp_authopt/run.sh b/tools/testing/selftests/tcp_authopt/run.sh
new file mode 100755
index 000000000000..7aeb125706a4
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/run.sh
@@ -0,0 +1,31 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Create virtualenv using pip and run pytest
+# Accepts all args that pytest does
+#
+set -e
+cd "$(dirname "${BASH_SOURCE[0]}")"
+
+if [[ -d venv ]]; then
+	echo >&2 "Using existing $(readlink -f venv)"
+else
+	echo >&2 "Creating $(readlink -f venv)"
+	python3 -m venv venv
+	(
+		. venv/bin/activate
+		pip install wheel
+		pip install -r requirements.txt
+	)
+fi
+
+cmd=(pytest -s --log-cli-level=DEBUG --tap-stream "$@")
+if [[ $(id -u) -ne 0 ]]; then
+	echo >&2 "warning: running as non-root user, attempting sudo"
+	# sudo -E to use the virtualenv:
+	cmd=(sudo bash -c ". venv/bin/activate;$(printf " %q" "${cmd[@]}")")
+	exec "${cmd[@]}"
+else
+	. venv/bin/activate
+	exec "${cmd[@]}"
+fi
diff --git a/tools/testing/selftests/tcp_authopt/settings b/tools/testing/selftests/tcp_authopt/settings
new file mode 100644
index 000000000000..6091b45d226b
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/settings
@@ -0,0 +1 @@
+timeout=120
diff --git a/tools/testing/selftests/tcp_authopt/setup.cfg b/tools/testing/selftests/tcp_authopt/setup.cfg
new file mode 100644
index 000000000000..452083fec64b
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/setup.cfg
@@ -0,0 +1,35 @@
+[options]
+install_requires=
+    cryptography
+    nsenter
+    pytest
+    pytest-tap
+    scapy
+    waiting
+
+[options.extras_require]
+dev =
+    black
+    isort
+    mypy
+    pip-tools
+    pre-commit
+    tox
+
+[tox:tox]
+envlist = py3
+
+[testenv]
+commands = pytest {posargs}
+deps = -rrequirements.txt
+
+[metadata]
+name = tcp-authopt-test
+version = 0.1
+
+[mypy]
+ignore_missing_imports = true
+files = .
+
+[isort]
+profile = black
diff --git a/tools/testing/selftests/tcp_authopt/setup.py b/tools/testing/selftests/tcp_authopt/setup.py
new file mode 100644
index 000000000000..055b98132e26
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/setup.py
@@ -0,0 +1,6 @@
+#! /usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+from setuptools import setup
+
+setup()
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.25.1

