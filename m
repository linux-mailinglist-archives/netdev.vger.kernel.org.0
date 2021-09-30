Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3289D41D8DD
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350537AbhI3Lfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350453AbhI3Lfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:35:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76713C06176E
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id u18so9519016wrg.5
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vDMYaD1JQIEcaKLhoWMfZURyxvr/UbAgBoCgqHBl9W4=;
        b=pZk0/Pftt1lwwaRxixwcDnCmjcnFP8REDJPTeLzR4jx8e4oRTBIAStCQwN6zUs4FM5
         hNJhpLj116YdrSmkAc7LUgdAwwBydvSf611IijTaqljlKg07wc+KQOwaks0My4xvLbjJ
         ne5N+/3n0IXN5TaxBmL5BRjmcJfVWzyK3xOa+7B8dfzv7e7HQMeEpGHnSnjYAqQAzcpY
         BPikHVFXfa0uzmRdb7F0Sr/a+NAo39s44LDNFuZp6whh7SIs6jEkwhszPRVMJH/ytuv7
         WBLXm9GNQDoExk6traB6VF1RfYcLsnpW7IUdK9CowxVQ8eFy5nNdj30BZbdrt1tXpQ2R
         qlog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vDMYaD1JQIEcaKLhoWMfZURyxvr/UbAgBoCgqHBl9W4=;
        b=JY3Jn4VNAMlOCxOSO6e7qEM7JI18wdLywWX78a2SMO9beJiyOuIvVqRgNPNAplmN/H
         r0qQ5bkSDijl83rBMqZ9kVQmLzOhxhjUsVO+IedFWtZMhX0HrqQFdhOF7AwFbXWtkUj9
         OmL32ih9nj5KaSfvL7/xB58SJj6QxhBRR0F1rMvfBFfnaXrBNBV2H+V+XwgUdtGGmnZw
         b4VIb8+4LE8z5DjgpLZDr4pLsK7Aynd2Yq3/e2NaMZfo2Q3/GpSbuilGR300+Nc1tU1m
         DfxK0MtkkD3+8vzvOeH4x+AI3YZiJp4xiUAKKzm2/G6pZgYISVSDYOHHnj3R3CV0nF7O
         6pUg==
X-Gm-Message-State: AOAM531gTPd+iyUUXIIWaUvTd36op3hl9kc/tbjF3O0oM46DlTYe9KoE
        XYMP2cSXWaa+Gy9oZKYF+rt6Ww==
X-Google-Smtp-Source: ABdhPJynECUvj04F01uCoEB8FiUXwgBjOSB4folmPRsl2QwXJfP0O6MUyC/DlibiSzEHnTyA+L409g==
X-Received: by 2002:a5d:4a46:: with SMTP id v6mr5553380wrs.262.1633001644066;
        Thu, 30 Sep 2021 04:34:04 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.95])
        by smtp.gmail.com with ESMTPSA id v10sm2904660wrm.71.2021.09.30.04.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:34:03 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 4/9] tools: runqslower: install libbpf headers when building
Date:   Thu, 30 Sep 2021 12:33:01 +0100
Message-Id: <20210930113306.14950-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930113306.14950-1-quentin@isovalent.com>
References: <20210930113306.14950-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that runqslower installs the
headers properly when building.

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
 tools/bpf/runqslower/Makefile        | 12 +++++++-----
 tools/testing/selftests/bpf/Makefile | 15 +++++++++------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index 3818ec511fd2..73ae8569878d 100644
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
@@ -81,8 +81,10 @@ else
 endif
 
 $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(BPFOBJ_OUTPUT)
-	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) $@
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) \
+		    DESTDIR=$(BPFOBJ_OUTPUT) prefix= $(abspath $@) install_headers
 
 $(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT)   \
-		    CC=$(HOSTCC) LD=$(HOSTLD)
+		    LIBBPF_OUTPUT=$(BPFOBJ_OUTPUT)			       \
+		    LIBBPF_DESTDIR=$(BPF_DESTDIR) CC=$(HOSTCC) LD=$(HOSTLD)
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 0167514ccaa2..6e7be0a0d79a 100644
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
-	       $(INCLUDE_DIR) $(HOST_INCLUDE_DIR))
+	       $(RUNQSLOWER_OUTPUT) $(INCLUDE_DIR) $(HOST_INCLUDE_DIR))
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

