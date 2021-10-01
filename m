Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E97141EB83
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353766AbhJALLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353744AbhJALLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:10 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDBEC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:25 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 205-20020a1c01d6000000b0030cd17ffcf8so10927380wmb.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVRI1vsPtM4IE1gmBFSEqqg+MaNx9NW4FiCNSSzSPSc=;
        b=5Es7emPq+0laRBO5uDzkD8Q1ljWSj2bwL05SObPMhL4EYMMkvOmdNwLH7d9cKbJlut
         2dxiniOaDKPIKT6jOQtavHLJIMeH3IHWAFCQYilccDKq8MRVT5T6kg4IS2Pu17gjof9m
         g6fTvneXmBmWUqizxf7YuW9ajtIxSdK2m1A/PReonepuWzTP5OoT4TszJ6jRfCFeTRmJ
         fC7M9wiAofdpHHc4ZB158kRQdWYlT6mm6mQ4AZ96l/Ia0Naq7RsxtZ+Zf9flZBmYfY83
         lBtKIPEVNSyShpb0B0zJbMdu4s9gQgcwHVW9w1DPJzGsmljDMuSzk6Xl2H2usWzAYzBC
         RHtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVRI1vsPtM4IE1gmBFSEqqg+MaNx9NW4FiCNSSzSPSc=;
        b=SLg8WTpjW5em2egQcikTTWjQU54enhkw3vcZw4u747J2TQWBCdXSpjx6mo3SifLUxN
         dcaZGqaQ1lXPj5skPGNsUxYTCAZZCj3dNClM09Amzl1mj1cWnDqDnXudDn9kn6/pC5eD
         SrfMXvov8bkFkMdTfJU8l0lZDIpRdedJvkLAzjI+XYtGlRAG8Cc5Lgs4NeHwIiLhnMRc
         9XT42O6eDZ3SiXU6xOO1zhw5hqFZi/7x01Jg3iH6PHxM7IEpSXC4EtOwuNFO2ETN813c
         LH17Ct2DdPB+vyGDJ9OkeuR4fR2dplgK5tE3AeGnZm8tRzEhr93h+RlLbbHR5RS9G1xs
         jm0A==
X-Gm-Message-State: AOAM531eHSxkgasbuJMbE8oVdlBQDPDibM/KCa1RK5fLC0SJoxlS0oQF
        LTPhWD2U+1CqdZEqr9ZtWgWRZg==
X-Google-Smtp-Source: ABdhPJyGVxS4mNx72eWkCSKrpq9JxA3Rwd8DY0W3LOL8+VeFk9gj8wfaqmeR9EVbvXl+LX3Loztu5g==
X-Received: by 2002:a1c:94:: with SMTP id 142mr3916697wma.87.1633086564314;
        Fri, 01 Oct 2021 04:09:24 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:23 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 3/9] tools: resolve_btfids: install libbpf headers when building
Date:   Fri,  1 Oct 2021 12:08:50 +0100
Message-Id: <20211001110856.14730-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
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
specific to resolve_btfids.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/resolve_btfids/Makefile    | 17 ++++++++++++-----
 tools/bpf/resolve_btfids/main.c      |  4 ++--
 tools/testing/selftests/bpf/Makefile |  7 +++++--
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 08b75e314ae7..89a46d4d0768 100644
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
+$(OUTPUT) $(OUTPUT)/libsubcmd $(LIBBPF_OUT) $(LIBBPF_INCLUDE):
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $(@)
 
 $(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
 	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(LIBBPF_OUT) $(abspath $@)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)	       \
+	   | $(LIBBPF_OUT) $(LIBBPF_INCLUDE)
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
index de6365b53c9c..91af785e6de5 100644
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
index 5432bfc99740..0167514ccaa2 100644
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
@@ -152,7 +154,7 @@ $(notdir $(TEST_GEN_PROGS)						\
 # sort removes libbpf duplicates when not cross-building
 MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf	       \
 	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids      \
-	       $(INCLUDE_DIR))
+	       $(INCLUDE_DIR) $(HOST_INCLUDE_DIR))
 $(MAKE_DIRS):
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $@
@@ -235,7 +237,7 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
 $(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)                \
 	   ../../../include/uapi/linux/bpf.h                                   \
-	   | $(INCLUDE_DIR) $(HOST_BUILD_DIR)/libbpf
+	   | $(HOST_INCLUDE_DIR) $(HOST_BUILD_DIR)/libbpf
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

