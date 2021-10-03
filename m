Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A5D4203A4
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhJCTYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhJCTYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 15:24:12 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF75C061783
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 12:22:24 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r4-20020a7bc084000000b0030d6fc48bd2so32459wmh.1
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 12:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XgUYWJZuL/HwVLt6ttv8qOWLvVmOfG/Qt/Uz50IHV30=;
        b=OBnuWV6Bpvbn29ACjdTx7kRLWzSefsJ+OmeF8IcplYnercHWTzkrDGxPez7fXJxpDm
         WuIX7UFo7z/gRpdkt6InD/HL17wrnkndmoocWIjCWc1iuTdTettzBLaPUo2Du8LxLRrW
         eT1XZPJoYJK4COzSRrXkC4twKNJWwwnBCYEYIXTiRapeCMGlVs241bjk/Bqw83flvb+i
         QuHNMIfuyXvG+8AE9U8+PYbBFKQsIxLECr2aEcyCd1Xc0fn6XU4rP8hYXWQ5FVRILfqB
         qWDpJslMNZdNjH5jF4gqXPrHaz4yBizP+g7OuL7ZWe0PvJaMpo+3fxmmFjDQhqaeiikw
         WIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XgUYWJZuL/HwVLt6ttv8qOWLvVmOfG/Qt/Uz50IHV30=;
        b=FfRDoQWfA71cg/s2mtDEX1eDMRphhOgPkzxTBusrXrJiemFRhW6VZKcq4MrPmpk9v6
         UbJUognMBgnCzUz1b26wacVg3sHd5AW24t/g38vtUZz2YHiUwzusNU7lugS8KtbL2L9w
         WLhx1tKx70srpFA83htsyT5XuJeKI9xPIbOamcUS+sAmWVcad2vPdKM8dsxpmjiWTLpV
         8x4fA8sQ1E6zWz/5Efeu1qQvsHUgHP7LDTv1aWIG/1RswFBHG7LZ5IjAVs3TGNvk/g8U
         deGFhRNNvj8WrAq/y+OsC3bwS3IhHis389Izr5capDKrPOQ6uj45Lb5LF41FVPNlih9q
         lHPQ==
X-Gm-Message-State: AOAM531KZJbohf9OLDpGCO25sqI0kMiBP1jY9hMkzSmVyzZo7jC8iTyG
        Pl45R46W5kJrJLemYRoXi11ELw==
X-Google-Smtp-Source: ABdhPJz4YtIVsH13i44+O1OyJSIZRf2C2PE1ZjEvQqN+iHRhouHY6B44Glk+Hx2BYFdNJRvFVGHLHw==
X-Received: by 2002:a1c:1fd5:: with SMTP id f204mr4686629wmf.73.1633288942712;
        Sun, 03 Oct 2021 12:22:22 -0700 (PDT)
Received: from localhost.localdomain ([149.86.88.77])
        by smtp.gmail.com with ESMTPSA id d3sm14124642wrb.36.2021.10.03.12.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 12:22:22 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 04/10] tools: runqslower: install libbpf headers when building
Date:   Sun,  3 Oct 2021 20:22:02 +0100
Message-Id: <20211003192208.6297-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003192208.6297-1-quentin@isovalent.com>
References: <20211003192208.6297-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that runqslower installs the
headers properly when building.

We use a libbpf_hdrs target to mark the logical dependency on libbpf's
headers export for a number of object files, even though the headers
should have been exported at this time (since bpftool needs them, and is
required to generate the skeleton or the vmlinux.h).

When descending from a parent Makefile, the specific output directories
for building the library and exporting the headers are configurable with
BPFOBJ_OUTPUT and BPF_DESTDIR, respectively. This is in addition to
OUTPUT, on top of which those variables are constructed by default.

Also adjust the Makefile for the BPF selftests. We pass a number of
variables to the "make" invocation, because we want to point runqslower
to the (target) libbpf shared with other tools, instead of building its
own version. In addition, runqslower relies on (target) bpftool, and we
also want to pass the proper variables to its Makefile so that bpftool
itself reuses the same libbpf.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/runqslower/Makefile        | 22 +++++++++++++---------
 tools/testing/selftests/bpf/Makefile | 15 +++++++++------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index 3818ec511fd2..049aef7e9a4c 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -9,9 +9,9 @@ BPFTOOL ?= $(DEFAULT_BPFTOOL)
 LIBBPF_SRC := $(abspath ../../lib/bpf)
 BPFOBJ_OUTPUT := $(OUTPUT)libbpf/
 BPFOBJ := $(BPFOBJ_OUTPUT)libbpf.a
-BPF_INCLUDE := $(BPFOBJ_OUTPUT)
-INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../lib)        \
-       -I$(abspath ../../include/uapi)
+BPF_DESTDIR := $(BPFOBJ_OUTPUT)
+BPF_INCLUDE := $(BPF_DESTDIR)/include
+INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../include/uapi)
 CFLAGS := -g -Wall
 
 # Try to detect best kernel BTF source
@@ -33,7 +33,7 @@ endif
 
 .DELETE_ON_ERROR:
 
-.PHONY: all clean runqslower
+.PHONY: all clean runqslower libbpf_hdrs
 all: runqslower
 
 runqslower: $(OUTPUT)/runqslower
@@ -46,13 +46,15 @@ clean:
 	$(Q)$(RM) $(OUTPUT)runqslower
 	$(Q)$(RM) -r .output
 
+libbpf_hdrs: $(BPFOBJ)
+
 $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
 
 $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h	      \
-			$(OUTPUT)/runqslower.bpf.o
+			$(OUTPUT)/runqslower.bpf.o libbpf_hdrs
 
-$(OUTPUT)/runqslower.bpf.o: $(OUTPUT)/vmlinux.h runqslower.h
+$(OUTPUT)/runqslower.bpf.o: $(OUTPUT)/vmlinux.h runqslower.h libbpf_hdrs
 
 $(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
 	$(QUIET_GEN)$(BPFTOOL) gen skeleton $< > $@
@@ -81,8 +83,10 @@ else
 endif
 
 $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(BPFOBJ_OUTPUT)
-	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) $@
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) \
+		    DESTDIR=$(BPFOBJ_OUTPUT) prefix= $(abspath $@) install_headers
 
-$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
+$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT)   \
-		    CC=$(HOSTCC) LD=$(HOSTLD)
+		    LIBBPF_OUTPUT=$(BPFOBJ_OUTPUT)			       \
+		    LIBBPF_DESTDIR=$(BPF_DESTDIR) CC=$(HOSTCC) LD=$(HOSTLD)
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 9c6045261806..ffe48b40d8fa 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -130,6 +130,7 @@ HOST_INCLUDE_DIR	:= $(INCLUDE_DIR)
 endif
 HOST_BPFOBJ := $(HOST_BUILD_DIR)/libbpf/libbpf.a
 RESOLVE_BTFIDS := $(HOST_BUILD_DIR)/resolve_btfids/resolve_btfids
+RUNQSLOWER_OUTPUT := $(BUILD_DIR)/runqslower/
 
 VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
@@ -154,7 +155,7 @@ $(notdir $(TEST_GEN_PROGS)						\
 # sort removes libbpf duplicates when not cross-building
 MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf	       \
 	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids      \
-	       $(INCLUDE_DIR))
+	       $(RUNQSLOWER_OUTPUT) $(INCLUDE_DIR))
 $(MAKE_DIRS):
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $@
@@ -183,11 +184,13 @@ $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 
 DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
 
-$(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
-	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
-		    OUTPUT=$(SCRATCH_DIR)/ VMLINUX_BTF=$(VMLINUX_BTF)   \
-		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR) &&	\
-		    cp $(SCRATCH_DIR)/runqslower $@
+$(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL) $(RUNQSLOWER_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	       \
+		    OUTPUT=$(RUNQSLOWER_OUTPUT) VMLINUX_BTF=$(VMLINUX_BTF)     \
+		    BPFTOOL_OUTPUT=$(BUILD_DIR)/bpftool/		       \
+		    BPFOBJ_OUTPUT=$(BUILD_DIR)/libbpf			       \
+		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR) &&	       \
+		    cp $(RUNQSLOWER_OUTPUT)runqslower $@
 
 TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
 
-- 
2.30.2

