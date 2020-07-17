Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05196224607
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGQVy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgGQVy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:54:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0CBC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 14:54:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u185so6025812pfu.1
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JTyjExaw6P/tqETi7r0tmPvrCD5SjN45qinOD7h6p64=;
        b=qtbJF5qFqqjH5OHyc3v/2lJAmL71Ki1AHGOleqjI3HgWepjQD5Nvg2AhGm9nK8mjDO
         R4q3uIpVqYtP8VH1lycbUBlf3XVrixGQZ3IVmPcMPDy6XoRYDSOsqBJD7OL/Rag+Etwm
         4RfuCaiLvdySrZlsTwQrlxayR9aiSfbP3S/KO+W+quoBJo5H8YQXk4Kr66fuAs+Ckc9+
         9wRYsy0gTx1cBj3UHtCTWpZywe8eoQpSz9pzOblUfJlDXpfsQ4Moo8QQRN/lnlOE6jwR
         krXy+36HwC1n4twYXXwfCYfMSg6TDCHDW5BUrz9WGgOI9+E3wSOWeEYe9mxaEWUkBZ9h
         xvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JTyjExaw6P/tqETi7r0tmPvrCD5SjN45qinOD7h6p64=;
        b=MWkAgovdhjNswND/m4sbpxmRsmjUu8CWaelbpkMe6ewgPvYQ46F4JFhD+ObgsOAY85
         A+J1ON0jEgrnJgSGnCeXMG4+eJe0PEq2Zctb5fiLE4WuOrTr9R4AmckdxnteIUJJoG8G
         CUw0AX6/heoWSB5AAF7rFPCcg5brScn03Ujwq6NN8eRsYcCa3ewkcf6WtR3N5jgGS7ci
         /atunsl4MCO14GKIwobacsnTFDdnDDXiJTsqP6BmXjJsbYu3YNwnx9jtHiGe4x4Z2Jlw
         BF5uSXpwYqL1mBUN5FTHABlrWW2O17J04yygA5mALUjQ0aW29MC2Y8Q8CUVjET8ZnZXJ
         ybsw==
X-Gm-Message-State: AOAM531e8AYR3ywy3MIwZIuGELwKFIpMmG9Y/0rrWroH3ab4LCz42qRc
        9o3iCNUluzK83IkrRzErIjM=
X-Google-Smtp-Source: ABdhPJwXB3Ui3ZXRX/XBhO2ag0w7qNXkgyjv9pXWTXkfc8CHJhgl1nArtcURXwxTvT1m0jDJSwZjFQ==
X-Received: by 2002:a65:418b:: with SMTP id a11mr10088787pgq.399.1595022895658;
        Fri, 17 Jul 2020 14:54:55 -0700 (PDT)
Received: from nebula.hsd1.or.comcast.net ([2601:1c0:5400:27ec:2e10:20b2:1406:9ce8])
        by smtp.gmail.com with ESMTPSA id f93sm3713275pjk.56.2020.07.17.14.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 14:54:55 -0700 (PDT)
From:   Briana Oursler <briana.oursler@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>, Shuah Khan <shuah@kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        Briana Oursler <briana.oursler@gmail.com>
Subject: [PATCH net-next] tc-testing: Add tdc to kselftests
Date:   Fri, 17 Jul 2020 14:54:39 -0700
Message-Id: <20200717215439.51672-1-briana.oursler@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tdc to existing kselftest infrastructure so that it can be run with
existing kselftests. TDC now generates objects in objdir/kselftest
without cluttering main objdir, leaves source directory clean, and
installs correctly in kselftest_install, properly adding itself to
run_kselftest.sh script.

Add tc-testing as a target of selftests/Makefile. Create tdc.sh to run
tdc.py targets with correct arguments. To support single target from
selftest/Makefile, combine tc-testing/bpf/Makefile and
tc-testing/Makefile. Move action.c up a directory to tc-testing/.

Tested with:
 make O=/tmp/{objdir} TARGETS="tc-testing" kselftest
 cd /tmp/{objdir}
 cd kselftest
 cd tc-testing
 ./tdc.sh

 make -C tools/testing/selftests/ TARGETS=tc-testing run_tests

 make TARGETS="tc-testing" kselftest
 cd tools/testing/selftests
 ./kselftest_install.sh /tmp/exampledir
 My VM doesn't run all the kselftests so I commented out all except my
 target and net/pmtu.sh then:
 cd /tmp/exampledir && ./run_kselftest.sh

Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
---
 tools/testing/selftests/Makefile                      | 1 +
 tools/testing/selftests/tc-testing/{bpf => }/Makefile | 9 ++++++---
 tools/testing/selftests/tc-testing/{bpf => }/action.c | 0
 tools/testing/selftests/tc-testing/tdc.sh             | 6 ++++++
 tools/testing/selftests/tc-testing/tdc_config.py      | 2 +-
 5 files changed, 14 insertions(+), 4 deletions(-)
 rename tools/testing/selftests/tc-testing/{bpf => }/Makefile (79%)
 rename tools/testing/selftests/tc-testing/{bpf => }/action.c (100%)
 create mode 100755 tools/testing/selftests/tc-testing/tdc.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 1195bd85af38..f4522e0a2cab 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -54,6 +54,7 @@ TARGETS += splice
 TARGETS += static_keys
 TARGETS += sync
 TARGETS += sysctl
+TARGETS += tc-testing
 TARGETS += timens
 ifneq (1, $(quicktest))
 TARGETS += timers
diff --git a/tools/testing/selftests/tc-testing/bpf/Makefile b/tools/testing/selftests/tc-testing/Makefile
similarity index 79%
rename from tools/testing/selftests/tc-testing/bpf/Makefile
rename to tools/testing/selftests/tc-testing/Makefile
index be5a5e542804..91fee5c43274 100644
--- a/tools/testing/selftests/tc-testing/bpf/Makefile
+++ b/tools/testing/selftests/tc-testing/Makefile
@@ -1,11 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
-APIDIR := ../../../../include/uapi
+top_srcdir = $(abspath ../../../..)
+APIDIR := $(top_scrdir)/include/uapi
 TEST_GEN_FILES = action.o
 
-top_srcdir = ../../../../..
 KSFT_KHDR_INSTALL := 1
-include ../../lib.mk
+include ../lib.mk
 
 CLANG ?= clang
 LLC   ?= llc
@@ -28,3 +28,6 @@ $(OUTPUT)/%.o: %.c
 	$(CLANG) $(CLANG_FLAGS) \
 		 -O2 -target bpf -emit-llvm -c $< -o - |      \
 	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
+
+TEST_PROGS += ./tdc.sh
+TEST_FILES := tdc*.py Tdc*.py plugins plugin-lib tc-tests
diff --git a/tools/testing/selftests/tc-testing/bpf/action.c b/tools/testing/selftests/tc-testing/action.c
similarity index 100%
rename from tools/testing/selftests/tc-testing/bpf/action.c
rename to tools/testing/selftests/tc-testing/action.c
diff --git a/tools/testing/selftests/tc-testing/tdc.sh b/tools/testing/selftests/tc-testing/tdc.sh
new file mode 100755
index 000000000000..e5d2c0e97bda
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tdc.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+./tdc.py -c actions --nobuildebpf
+./tdc.py -c qdisc
+
diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index 080709cc4297..cd4a27ee1466 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -24,7 +24,7 @@ NAMES = {
           # Name of the namespace to use
           'NS': 'tcut',
           # Directory containing eBPF test programs
-          'EBPFDIR': './bpf'
+          'EBPFDIR': './'
         }
 
 
-- 
2.27.0

