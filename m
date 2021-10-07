Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57E6425C7D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241569AbhJGTqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhJGTqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01FCC061767
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:51 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i12so9838333wrb.7
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8/6d9debazwsXGBQDrs8zYEoIfRSE6g8+8klPy00wPk=;
        b=0dbWiXPUheDp3Qc6lQZqxxUp0z7YH5l0fqJIXQFSlrLZmZ5B+iCQV27ubNvKO2cKuC
         K3uvLV3XRG6+7i1QWSJyTXgth9ABOAbGvjlQ6kKzAAJ7AuoSnKxIadZ2QNMAHP3Y3L8N
         bjEZ6MI5OSduuUUAsk8jTGLsNtkHLjBWhYBWHUkhHKwVqy5Uu/zr09a2XoZV3Thw6C+T
         M/K5T6r8cDzg/mW4QBcFYxnh5sEYXnGSXgVXzsP5wQR1XWze2wQ+aGdLT9YG0+QEo8VC
         jJYLBSERdGrWzMTllp6Hd2f0eHdq8fyaV7vBO3RnF1XPWO4VtRed2pOBP+xOkt5AqC0A
         SfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8/6d9debazwsXGBQDrs8zYEoIfRSE6g8+8klPy00wPk=;
        b=c1lgmGPUBuVXWt1RfSHpS5fmalwZduATCFskoaZbRRaQYsrAystIVNS7YBqV9ZzOiD
         jTLQ6eA/K174/2lWJ6nuvvcHV+uvAuuiGKW9NAnVnUM5YEbJ5lEOPy38XR5JQUTe/J6v
         QYV0yl8PfxKzaw2DvZMNc6Kx6+A5R1TWvTLcKvlkV7/LwDAFJ6L69LNhZLC8EzYBreiC
         NadDKnKk1HKGG8J9W5rOV2G8FhUvUfpd8IF8zmex4vJYL+pvqr7bUoAxIoCb+A9k0JUL
         Muui5O/r/n9XHS1h7A5vnNCUodeOlaZsMXedTz5djAo2atYZhocJ+/lJOFPXVfc4oDzF
         ocCg==
X-Gm-Message-State: AOAM533U8BQHFX0HOJ6ahr5sdRSXu8vNF7DYHm0dMqPc/HB22+1UCQtc
        K4+0Y9evE2fF4vyGWacF/ospPA==
X-Google-Smtp-Source: ABdhPJxfb7GnPrbsCgBL7cIbCiK4cisFatRKQfPI249dvUGUe4RsBUkz5eQiDTDHTWgax1RC3d6GUA==
X-Received: by 2002:a1c:a9d3:: with SMTP id s202mr18439451wme.128.1633635890501;
        Thu, 07 Oct 2021 12:44:50 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:50 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 05/12] tools/runqslower: install libbpf headers when building
Date:   Thu,  7 Oct 2021 20:44:31 +0100
Message-Id: <20211007194438.34443-6-quentin@isovalent.com>
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
index 3818ec511fd2..bbd1150578f7 100644
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
+			$(OUTPUT)/runqslower.bpf.o | libbpf_hdrs
 
-$(OUTPUT)/runqslower.bpf.o: $(OUTPUT)/vmlinux.h runqslower.h
+$(OUTPUT)/runqslower.bpf.o: $(OUTPUT)/vmlinux.h runqslower.h | libbpf_hdrs
 
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
index 090f424ac5e1..e023d734f7b0 100644
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

