Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1388D41373D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhIUQS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbhIUQS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:29 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17085C061757;
        Tue, 21 Sep 2021 09:17:00 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id co2so29797493edb.8;
        Tue, 21 Sep 2021 09:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pvjovdmDUdp4zPrJ2B/xrAzrYj6YQrDNCw62XXqkzzs=;
        b=PWXkxbnNsfhU7VVymCc1dTqaqotQkeZTLoiU2VuufhHUNLxl3qFNjrhe6BqsUzCZxa
         GqJxxHipwwTDZpf2lMd3wm4EKY6GvKlBjlNbGLi7tglSywIHkjDsR3vRuWD72NV9xB57
         lBDCnZ/avxqh0m+CZVZiN4dNLJXUTWlm5yceOtu4zZn+yQhdTdPonGhiK6B0TTuKtXTL
         I2DuNWPbFOLZBmTG1u8b0fUzyhAKO+4sTcO0hCY0nHAlMRGIczqqWRH/nnCsQ44wRyF/
         2L5GynyH9pGZ7O6yHv+7h14zM2SAfYegKZ8lPNit96L1+dL41ZSFY/r6j62riPJKAPGG
         KBvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pvjovdmDUdp4zPrJ2B/xrAzrYj6YQrDNCw62XXqkzzs=;
        b=uhPqKCR+E2XHMF/31kXKSdY8AFr8z99PkcEfC24YaolBB29KWFclDrp50fpLo9gbbs
         pMi3ly7ON9a9EDQJH9y3Y0yS6hKmJQlXoZ9eJw0KaBmzcjL4Vydnh2PIaY71XD2Rqs91
         te+FuCUW4cpakD+B9+dD0cpXIllbhzPgC3X8IeuiHsE+rCBzSrLuBV/RQDvQ+R5N1p6c
         9c35XerWCFD9hDhBLYu4sA2PyIRYwWyNqLee04a5+BqSdR4r0hyOwDaNQigp32bPJzWX
         PC06oXN71zetl02HinGbAJ4LWQYXY5q/lhgy6F9bSjeU+DaKBmTxw8KFWyCyoak3aTr1
         ALog==
X-Gm-Message-State: AOAM533cyWcMufm8a7cz0uzR+QDaENyM5q76PbAhgt4CapAPn4qnm97f
        5I1StC2gmRxLCOHU7iPM0Og=
X-Google-Smtp-Source: ABdhPJzmGhxUxkYtY5sWwuqlRBvyrcXJwCQ0EauQmG6L/P9shHvy+gefKtTiYgZmvQoUJ0RXMM0etQ==
X-Received: by 2002:a17:906:f0d4:: with SMTP id dk20mr36279570ejb.199.1632240920503;
        Tue, 21 Sep 2021 09:15:20 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:20 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] selftests: Initial tcp_authopt test module
Date:   Tue, 21 Sep 2021 19:14:46 +0300
Message-Id: <d3ccd0293fca61d5e6b12b375135057cde189c14.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test suite is written as a standalone python3 package using
dependencies such as scapy.

The run.sh script wrapper called from kselftest infrastructure uses
"tox" to generate an isolated virtual environment just for running these
tests. The run.sh wrapper can be called from anywhere and does not rely
on kselftest infrastructure.

The python3 and tox packages be installed manually but not any other
dependencies

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/tcp_authopt/Makefile  |  5 +++
 .../testing/selftests/tcp_authopt/README.rst  | 15 +++++++
 tools/testing/selftests/tcp_authopt/config    |  6 +++
 .../selftests/tcp_authopt/requirements.txt    | 40 +++++++++++++++++++
 tools/testing/selftests/tcp_authopt/run.sh    | 15 +++++++
 tools/testing/selftests/tcp_authopt/setup.cfg | 17 ++++++++
 tools/testing/selftests/tcp_authopt/setup.py  |  5 +++
 .../tcp_authopt/tcp_authopt_test/__init__.py  |  0
 8 files changed, 103 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/Makefile
 create mode 100644 tools/testing/selftests/tcp_authopt/README.rst
 create mode 100644 tools/testing/selftests/tcp_authopt/config
 create mode 100644 tools/testing/selftests/tcp_authopt/requirements.txt
 create mode 100755 tools/testing/selftests/tcp_authopt/run.sh
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.cfg
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py

diff --git a/tools/testing/selftests/tcp_authopt/Makefile b/tools/testing/selftests/tcp_authopt/Makefile
new file mode 100644
index 000000000000..391412071875
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../lib.mk
+
+TEST_PROGS += ./run.sh
+TEST_FILES := setup.py setup.cfg tcp_authopt_test
diff --git a/tools/testing/selftests/tcp_authopt/README.rst b/tools/testing/selftests/tcp_authopt/README.rst
new file mode 100644
index 000000000000..e9e4acc0a22a
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/README.rst
@@ -0,0 +1,15 @@
+=========================================
+Tests for linux TCP Authentication Option
+=========================================
+
+Test suite is written in python3 using pytest and scapy. The test suite is
+mostly self-contained as a python package.
+
+The recommended way to run this is the included `run.sh` script as root, this
+will automatically create a virtual environment with the correct dependencies
+using `tox`.
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
index 000000000000..e30c8d12cf2e
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/requirements.txt
@@ -0,0 +1,40 @@
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
+cffi==1.14.6
+    # via cryptography
+contextlib2==21.6.0
+    # via nsenter
+cryptography==3.4.8
+    # via tcp-authopt-test (setup.py)
+iniconfig==1.1.1
+    # via pytest
+nsenter==0.2
+    # via tcp-authopt-test (setup.py)
+packaging==21.0
+    # via pytest
+pathlib==1.0.1
+    # via nsenter
+pluggy==0.13.1
+    # via pytest
+py==1.10.0
+    # via pytest
+pycparser==2.20
+    # via cffi
+pyparsing==2.4.7
+    # via packaging
+pytest==6.2.4
+    # via tcp-authopt-test (setup.py)
+scapy==2.4.5
+    # via tcp-authopt-test (setup.py)
+toml==0.10.2
+    # via pytest
+waiting==1.4.1
+    # via tcp-authopt-test (setup.py)
diff --git a/tools/testing/selftests/tcp_authopt/run.sh b/tools/testing/selftests/tcp_authopt/run.sh
new file mode 100755
index 000000000000..b3448d678aa2
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/run.sh
@@ -0,0 +1,15 @@
+#! /bin/bash
+#
+# Create virtualenv using tox and run pytest
+# Accepts all args that pytest does
+#
+
+if ! command -v tox >/dev/null; then
+	echo >&2 "error: please install the python tox package"
+	exit 1
+fi
+if [[ $(id -u) -ne 0 ]]; then
+	echo >&2 "warning: running as non-root user is unlikely to work"
+fi
+cd "$(dirname "${BASH_SOURCE[0]}")"
+exec tox -- -s --log-cli-level=DEBUG "$@"
diff --git a/tools/testing/selftests/tcp_authopt/setup.cfg b/tools/testing/selftests/tcp_authopt/setup.cfg
new file mode 100644
index 000000000000..258dfffab9a3
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/setup.cfg
@@ -0,0 +1,17 @@
+[options]
+install_requires=
+    cryptography
+    nsenter
+    pytest
+    scapy
+    waiting
+
+[tox:tox]
+envlist = py3
+
+[testenv]
+commands = pytest {posargs}
+
+[metadata]
+name = tcp-authopt-test
+version = 0.1
diff --git a/tools/testing/selftests/tcp_authopt/setup.py b/tools/testing/selftests/tcp_authopt/setup.py
new file mode 100644
index 000000000000..d5e50aa1ca5e
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/setup.py
@@ -0,0 +1,5 @@
+#! /usr/bin/env python3
+
+from setuptools import setup
+
+setup()
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.25.1

