Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AF2425C7C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbhJGTqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240989AbhJGTqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:45 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F22C061755
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:51 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o20so22399084wro.3
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Ze5fDtcRvx+SdsXWnHucRcHaXs5CZugQdR4lFHb2n4=;
        b=CUDW2q1UqHE+tRZl1IbYwtkk3Ba4tMLrZmZ4II8hK5bYSua51x5zxFdh/2BzLTRX2+
         z7Xd+hChi3Wvi534VwdaAi+7cKlxZj9CxQ8YRoEyftQiG44j4trU4SuvC4qZJudCv8RG
         nNFX3acUZQrZGCykOFm7xeaf7Kn+4zVjMdQoqpU25Rti6ICe2CCJ7Ku7Sm6kMGWNpWW9
         WTuGHTq1VtR5KnHxNKJVMPxqJVc6vzch3z/vgkoWa+LabWsGEF5IZti8N/WLuHSlyVeU
         G5YKdvQpa3DWwhjlPekwTY/QBbOfVMibBVghjiOfLx4ScH33+ZsA8OvfJB0Fj9mXSyrW
         YMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Ze5fDtcRvx+SdsXWnHucRcHaXs5CZugQdR4lFHb2n4=;
        b=j9AzGlQEE57WbVDGQw37kc5N9dronzKcDTf/dl7m3GWehWnxFeaNbbZCQor2+zItvr
         RDDyeNhn5YMKf9qjrtVHtIN11q/mCPkBtqSSSkRG10vzSPwxOUkgBp65H/qFYsBEkKMp
         pDxpW1JPOgQYByeW6a3r3JIj/sgV9AsEhxc+CXNqzdZjL/5BcyjHNFP0O0oD1HKO7WY4
         gztc3dOJIdUN/sPm/gddNjX6+6Z6ozlRf8akOEOIYzhUvq7BSsmIb7rGZPJPZRNQuIfX
         Np0tn+nyk5JZY8JhBzsDXIyQjf+DYKV7ypgjoqsqn/5LxhMCepIGl1vaoFqG7MHdmIPg
         pN1A==
X-Gm-Message-State: AOAM530ckRxj2WdTTvKCxWKCBN+qZ1gE6ifGzGCDw+oIrLxp4LXEClAW
        wFIKwKD5Kyx03SO5+FaDgxv3AQ==
X-Google-Smtp-Source: ABdhPJzC5BKeslX14o7s9SJhBjLl0HQFkCTtoB7J2mPpG5ICK8FmWNZqN6AVchQon9ltqBAv+4Kx1g==
X-Received: by 2002:a7b:cf07:: with SMTP id l7mr4781196wmg.10.1633635889770;
        Thu, 07 Oct 2021 12:44:49 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:49 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 04/12] tools/resolve_btfids: install libbpf headers when building
Date:   Thu,  7 Oct 2021 20:44:30 +0100
Message-Id: <20211007194438.34443-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that resolve_btfids installs the
headers properly when building.

When descending from a parent Makefile, the specific output directories
for building the library and exporting the headers are configurable with
LIBBPF_OUT and LIBBPF_DESTDIR, respectively. This is in addition to
OUTPUT, on top of which those variables are constructed by default.

Also adjust the Makefile for the BPF selftests in order to point to the
(target) libbpf shared with other tools, instead of building a version
specific to resolve_btfids. Remove libbpf's order-only dependencies on
the include directories (they are created by libbpf and don't need to
exist beforehand).

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile    | 17 ++++++++++++-----
 tools/bpf/resolve_btfids/main.c      |  4 ++--
 tools/testing/selftests/bpf/Makefile |  7 +++++--
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 08b75e314ae7..4eb74c7e65c4 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -29,25 +29,31 @@ BPFOBJ     := $(OUTPUT)/libbpf/libbpf.a
 LIBBPF_OUT := $(abspath $(dir $(BPFOBJ)))/
 SUBCMDOBJ  := $(OUTPUT)/libsubcmd/libsubcmd.a
 
+LIBBPF_DESTDIR := $(LIBBPF_OUT)
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)include
+
 BINARY     := $(OUTPUT)/resolve_btfids
 BINARY_IN  := $(BINARY)-in.o
 
 all: $(BINARY)
 
-$(OUTPUT) $(OUTPUT)/libbpf $(OUTPUT)/libsubcmd:
+$(OUTPUT) $(OUTPUT)/libsubcmd $(LIBBPF_OUT):
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $(@)
 
 $(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
 	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(LIBBPF_OUT) $(abspath $@)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)	       \
+	   | $(LIBBPF_OUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(LIBBPF_OUT)    \
+		    DESTDIR=$(LIBBPF_DESTDIR) prefix=			       \
+		    $(abspath $@) install_headers
 
 CFLAGS := -g \
           -I$(srctree)/tools/include \
           -I$(srctree)/tools/include/uapi \
-          -I$(LIBBPF_SRC) \
+          -I$(LIBBPF_INCLUDE) \
           -I$(SUBCMD_SRC)
 
 LIBS = -lelf -lz
@@ -65,7 +71,8 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 clean_objects := $(wildcard $(OUTPUT)/*.o                \
                             $(OUTPUT)/.*.o.cmd           \
                             $(OUTPUT)/.*.o.d             \
-                            $(OUTPUT)/libbpf             \
+                            $(LIBBPF_OUT)                \
+                            $(LIBBPF_DESTDIR)            \
                             $(OUTPUT)/libsubcmd          \
                             $(OUTPUT)/resolve_btfids)
 
diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index c6c3e613858a..716e6ad1864b 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -60,8 +60,8 @@
 #include <linux/rbtree.h>
 #include <linux/zalloc.h>
 #include <linux/err.h>
-#include <btf.h>
-#include <libbpf.h>
+#include <bpf/btf.h>
+#include <bpf/libbpf.h>
 #include <parse-options.h>
 
 #define BTF_IDS_SECTION	".BTF_ids"
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 849a4637f59d..090f424ac5e1 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -122,9 +122,11 @@ BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
 ifneq ($(CROSS_COMPILE),)
 HOST_BUILD_DIR		:= $(BUILD_DIR)/host
 HOST_SCRATCH_DIR	:= $(OUTPUT)/host-tools
+HOST_INCLUDE_DIR	:= $(HOST_SCRATCH_DIR)/include
 else
 HOST_BUILD_DIR		:= $(BUILD_DIR)
 HOST_SCRATCH_DIR	:= $(SCRATCH_DIR)
+HOST_INCLUDE_DIR	:= $(INCLUDE_DIR)
 endif
 HOST_BPFOBJ := $(HOST_BUILD_DIR)/libbpf/libbpf.a
 RESOLVE_BTFIDS := $(HOST_BUILD_DIR)/resolve_btfids/resolve_btfids
@@ -227,7 +229,7 @@ docs-clean:
 
 $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 	   ../../../include/uapi/linux/bpf.h                                   \
-	   | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
+	   | $(BUILD_DIR)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
 		    EXTRA_CFLAGS='-g -O0'				       \
 		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
@@ -235,7 +237,7 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
 $(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)                \
 	   ../../../include/uapi/linux/bpf.h                                   \
-	   | $(INCLUDE_DIR) $(HOST_BUILD_DIR)/libbpf
+	   | $(HOST_BUILD_DIR)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                             \
 		    EXTRA_CFLAGS='-g -O0'				       \
 		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
@@ -260,6 +262,7 @@ $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
 		       $(TOOLSDIR)/lib/str_error_r.c
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids	\
 		CC=$(HOSTCC) LD=$(HOSTLD) AR=$(HOSTAR) \
+		LIBBPF_INCLUDE=$(HOST_INCLUDE_DIR) \
 		OUTPUT=$(HOST_BUILD_DIR)/resolve_btfids/ BPFOBJ=$(HOST_BPFOBJ)
 
 # Get Clang's default includes on this system, as opposed to those seen by
-- 
2.30.2

