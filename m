Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191C13F6B1E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbhHXVge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbhHXVgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35131C0613D9;
        Tue, 24 Aug 2021 14:35:30 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lc21so14801895ejc.7;
        Tue, 24 Aug 2021 14:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ct0HD70NBHwAB9BiqsIbwqqYlCQQO3kZsUrrZx21vQA=;
        b=q1LyY04Q+z09IYx+Tt23jG4iId5YHMG3BWfG4/Eq71DIk86YFduy6ib3UMhiK1zuTB
         kqTNAUWArg93o6D0MmWBPv+X011ncyL6nCxwpTltAt+wL1B11SGVkmOrU8kGI4GI5nIB
         P5a0cp1+1yJql4VP6/g/NdlsdgGMJlDajNgAFE4jEioMPWW3fffugVR6+64zVjF5bNyo
         4cpScRM13Y8hJZmn9adPw8XTpHrgX2ds4U9nCOawnuipizbGRUaUFEkh3UD4YdZKsTfl
         hA4PT5LTQ5vlg6EiyvjgskzIALXO4bOykiPvctL+jCaAqgaLrViTiIlz2bSRqTRwX7MA
         KMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ct0HD70NBHwAB9BiqsIbwqqYlCQQO3kZsUrrZx21vQA=;
        b=T5uAMtEmdlZqm07PFEo1jI6WsWVAaBft96VSVEJyHc9zgeYDm5n4YJwS1q+QfOuxOy
         6kraAxwJg8QJ/LKjMCEDb/8bx59k8EYr1wAgtW/ON8RRHtv7yXxtmee4Nqk6J/Lte7k7
         lwsEqfTyOv981tDifRoTmtOMYNUVCUMqy4wSEPBZoSqIUXhl8fyuYvT2Kdh2kn1F7pbh
         Nwt+3FTnCSzDl91HkxmUXEgxgXZBXYrOIJLoGVJwPNa3/tm4Pn+UGAc54SziZmWXwLb8
         qqa+cvMjKLaRaTiAtpGqh7Sud4fNlElCDUY6aissDSlkc/B3EP1BXD9XiAwxjQ1OCmbf
         H7XA==
X-Gm-Message-State: AOAM531E1KrM0uixNvSiW3ZcnGFI/Oe+g3WHIHAnNMG0CLZbifakQEn1
        reXw0DrCanZopHe+3sySGAg=
X-Google-Smtp-Source: ABdhPJy0FLTX6qq23VzmxQi4NC6NiWluW3KbxIUj/+0H13gA6vYVMtMXNA8SyBEzE0S3bjSDbMY7CQ==
X-Received: by 2002:a17:906:1dd6:: with SMTP id v22mr36555630ejh.226.1629840928821;
        Tue, 24 Aug 2021 14:35:28 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:28 -0700 (PDT)
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
Subject: [RFCv3 03/15] selftests: Initial tcp_authopt test module
Date:   Wed, 25 Aug 2021 00:34:36 +0300
Message-Id: <4ea197b5370cbdaac0086f1d94af8a5f4e27a901.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
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
 tools/testing/selftests/tcp_authopt/Makefile    |  5 +++++
 tools/testing/selftests/tcp_authopt/README.rst  | 15 +++++++++++++++
 tools/testing/selftests/tcp_authopt/config      |  6 ++++++
 tools/testing/selftests/tcp_authopt/run.sh      | 11 +++++++++++
 tools/testing/selftests/tcp_authopt/setup.cfg   | 17 +++++++++++++++++
 tools/testing/selftests/tcp_authopt/setup.py    |  5 +++++
 .../tcp_authopt/tcp_authopt_test/__init__.py    |  0
 7 files changed, 59 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/Makefile
 create mode 100644 tools/testing/selftests/tcp_authopt/README.rst
 create mode 100644 tools/testing/selftests/tcp_authopt/config
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
diff --git a/tools/testing/selftests/tcp_authopt/run.sh b/tools/testing/selftests/tcp_authopt/run.sh
new file mode 100755
index 000000000000..192ae094e3be
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/run.sh
@@ -0,0 +1,11 @@
+#! /bin/bash
+
+if ! command -v tox >/dev/null; then
+	echo >&2 "error: please install the python tox package"
+	exit 1
+fi
+if [[ $(id -u) -ne 0 ]]; then
+	echo >&2 "warning: running as non-root user is unlikely to work"
+fi
+cd "$(dirname "${BASH_SOURCE[0]}")"
+exec tox "$@"
diff --git a/tools/testing/selftests/tcp_authopt/setup.cfg b/tools/testing/selftests/tcp_authopt/setup.cfg
new file mode 100644
index 000000000000..373c5632b0a2
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/setup.cfg
@@ -0,0 +1,17 @@
+[options]
+install_requires=
+    cryptography
+    nsenter
+    pre-commit
+    pytest
+    scapy
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

