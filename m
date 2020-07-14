Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144BD21FF95
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGNVH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgGNVH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:07:27 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39EAC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:07:27 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s26so8155007pfm.4
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVMO5KBHGGhqDzJcbdQBFLhTU1xLJKZArW/60463rAg=;
        b=IpC68lapwmmvVZqV9SrzWt9eRwNsykwjygM4cdVmAlSQF2CQ7teJIf1JUpQC6qKe7R
         0sYY9vf0z46LLGhAPj6av4AZJVhEoyr6lumGaGnKulWjEkDWjGQ5W99A7G+ZMtDwsRSF
         Y/DOA2hKPpsXUArRK1SD9wx9/EtIdwU6Z2s5xnbaXEDpH6Wm3h+4krsEEjNHi3A5/6NF
         jHtvaiEBl021IaQB0drdokZxRCvUR0t68lgVdViB1p+tXZZQwmpJNSYEvvOtEquTDJ7h
         iks1koon3xIPDerbkqso+CgZhe+MSmHeaKsBHxc41sLK3p08gloRHi7G5rcwGgn7SHxa
         mSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVMO5KBHGGhqDzJcbdQBFLhTU1xLJKZArW/60463rAg=;
        b=dPxjR7OjX5h3r3IvMtZH6m8vKv3ab3UtMDENsCv6B7aC5oMaTJRGaGMTTR7CkJ6uqW
         LTsIfJHs0Vf8ZLhZFGD3DLU3X5j7FDFwGpX30QHkpJzyVNGHSRacIVRNFlSX2/rtTugo
         QCT5Zb9IqzIpBZO1lEAvREOrRxBCIBolscm3CUwnA+6imA0I4IFgjCUVRi46HLV/JolK
         4ARtfTWz/z5SiqfTFISF5Ppj0jWuwnbEa2BWqVhljWwxg4LBviKLGJcy8+IP5ia5khO0
         czdKp3J5vxr4Tu/O9dX1Olvshg9onRAkOB97NfneinskaeecpCnqNhDhTidbUBfyPha8
         8mgA==
X-Gm-Message-State: AOAM530ScjyTiWC99p2gg458C/IhlMFgF0EmIvjUZKdIh/QI/fRcac3W
        Lz7YSXFPaYoV6Auvz4i5LeM=
X-Google-Smtp-Source: ABdhPJwh4a2jyZduvz4TF548OdwPCgyFw/0wlDvGfzoTz9bjD+wzATg/uiOtx5VWEKV8zAZ9NX9Ctw==
X-Received: by 2002:a62:f202:: with SMTP id m2mr6076415pfh.157.1594760847268;
        Tue, 14 Jul 2020 14:07:27 -0700 (PDT)
Received: from nebula.hsd1.or.comcast.net ([2601:1c0:5400:27ec:2e10:20b2:1406:9ce8])
        by smtp.gmail.com with ESMTPSA id n14sm46483pgd.78.2020.07.14.14.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 14:07:26 -0700 (PDT)
From:   Briana Oursler <briana.oursler@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>, Shuah Khan <shuah@kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        Briana Oursler <briana.oursler@gmail.com>
Subject: [RFC net-next] tc-testing: Add tdc to kselftests
Date:   Tue, 14 Jul 2020 14:07:17 -0700
Message-Id: <20200714210717.319353-1-briana.oursler@gmail.com>
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
index be5a5e542804..8316bf3ea5f2 100644
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
+TEST_FILES := tdc*.py Tdc*.py config plugins plugin-lib tc-tests
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

