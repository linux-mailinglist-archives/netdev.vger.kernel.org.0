Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BC241D8DF
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350543AbhI3Lfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350519AbhI3Lfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:35:51 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFBBC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s21so9485532wra.7
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RpjwrVd2fRDSeptVCei7DoM+TRRc5Wynujd2MS0EFUo=;
        b=Kq2WSrQLVxGal8tY+haI+piz4KUU5c7ERynLxtWPBvIfhiNab/dZpC02IJ+aF32HJ8
         KA+Ge6ts2s6nVALyqVN0gOujaE3dR/Lasg3lUbkstaC3xhtRIWV3/l/YNtz5bEU4e0pe
         NdBQRDryVuRnEYlhr3PBKc4gvobWUblPPewQB+3CEhZDgenRhdNfBRvaPPYA3a0v3crC
         D4tfUvOTKW6gfTZa7PWFqJgmt7Yi/UglzkFgJuc88uHnYmbRDhLFwrayMJzjEwCTbyBz
         5UnzMzMAhM4J4OQueHXcG30loWJ2ITnXnlQbnGl072vaRIxvhka2tAIdm0soaFkaE4X+
         zCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RpjwrVd2fRDSeptVCei7DoM+TRRc5Wynujd2MS0EFUo=;
        b=iAJmplSbIpTN3pK5nW+LfwYehwMdHlqIrEMrJXs8auKZ63FO9CgoOMqM/+sKS95Z0+
         dBreJaaPafrLNrdviolpTEfhZlozk5xuZH4xNeSCYTazHrKCxraO7WRIWYvC6zmYWrAc
         Ey4ihUDk4TTPOyYBl7FUArFK7yhNXjOvOQIMgxt8St3VZ/b3h7de/5d5SGfkTgW5edV+
         WDBziHxiPpmFJYdaFyTKqKWI8ygMIURp/KF+wLmZ54v6o9AnARY4kt4qn/EOek7DmwxD
         MVRFZC5JcBK5uEocWpUqc707J9VBfONnisKwEdUrbxmlCgsoj2waT2kxmpEbUL267skn
         BBmg==
X-Gm-Message-State: AOAM532nls09pOqyJCrKEsavE1YP90euCfBF8IacZXL6wLEbeF7adtQ8
        3AhA7ziIUPT0UUwLELnj5KioOg==
X-Google-Smtp-Source: ABdhPJx0vwfuRohg6SW51M23f+6XKI6ynuPzCrRXr5VWMpEqUZdWJUlyIDdnB/XdYCnlXjzx5DfAKg==
X-Received: by 2002:a05:6000:2c2:: with SMTP id o2mr5399261wry.311.1633001647331;
        Thu, 30 Sep 2021 04:34:07 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.95])
        by smtp.gmail.com with ESMTPSA id v10sm2904660wrm.71.2021.09.30.04.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:34:06 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 7/9] samples/bpf: install libbpf headers when building
Date:   Thu, 30 Sep 2021 12:33:04 +0100
Message-Id: <20210930113306.14950-8-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930113306.14950-1-quentin@isovalent.com>
References: <20210930113306.14950-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the source
directory. Instead, they should be exported with "make install_headers".
Make sure that samples/bpf/Makefile installs the headers properly when
building.

The object compiled from and exported by libbpf are now placed into a
subdirectory of sample/bpf/ instead of remaining in tools/lib/bpf/. We
attempt to remove this directory on "make clean". However, the "clean"
target re-enters the samples/bpf/ directory from the root of the
repository ("$(MAKE) -C ../../ M=$(CURDIR) clean"), in such a way that
$(srctree) and $(src) are not defined, making it impossible to use
$(LIBBPF_OUTPUT) and $(LIBBPF_DESTDIR) in the recipe. So we only attempt
to clean $(CURDIR)/libbpf, which is the default value.

We also change the output directory for bpftool, to place the generated
objects under samples/bpf/bpftool/ instead of building in bpftool's
directory directly. Doing so, we make sure bpftool reuses the libbpf
library previously compiled and installed.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 samples/bpf/Makefile | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4dc20be5fb96..7de602c2c705 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -59,7 +59,11 @@ tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
 # Libbpf dependencies
-LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
+LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
+LIBBPF_OUTPUT = $(abspath $(BPF_SAMPLES_PATH))/libbpf
+LIBBPF_DESTDIR = $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
+LIBBPF = $(LIBBPF_OUTPUT)/libbpf.a
 
 CGROUP_HELPERS := ../../tools/testing/selftests/bpf/cgroup_helpers.o
 TRACE_HELPERS := ../../tools/testing/selftests/bpf/trace_helpers.o
@@ -198,7 +202,7 @@ TPROGS_CFLAGS += -Wstrict-prototypes
 
 TPROGS_CFLAGS += -I$(objtree)/usr/include
 TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
-TPROGS_CFLAGS += -I$(srctree)/tools/lib/
+TPROGS_CFLAGS += -I$(LIBBPF_INCLUDE)
 TPROGS_CFLAGS += -I$(srctree)/tools/include
 TPROGS_CFLAGS += -I$(srctree)/tools/perf
 TPROGS_CFLAGS += -DHAVE_ATTR_TEST=0
@@ -268,16 +272,28 @@ all:
 clean:
 	$(MAKE) -C ../../ M=$(CURDIR) clean
 	@find $(CURDIR) -type f -name '*~' -delete
+	@/bin/rm -rf $(CURDIR)/libbpf $(CURDIR)/bpftool
 
-$(LIBBPF): FORCE
+$(LIBBPF): FORCE | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
 # Fix up variables inherited from Kbuild that tools/ build system won't like
-	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
-		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
+	$(MAKE) -C $(LIBBPF_SRC) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
+		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ \
+		O= OUTPUT=$(LIBBPF_OUTPUT)/ DESTDIR=$(LIBBPF_DESTDIR) prefix= \
+		$@ install_headers
 
 BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
-BPFTOOL := $(BPFTOOLDIR)/bpftool
-$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)
-	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../
+BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
+BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
+$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
+	    | $(BPFTOOL_OUTPUT)
+	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
+		OUTPUT=$(BPFTOOL_OUTPUT)/ \
+		LIBBPF_OUTPUT=$(LIBBPF_OUTPUT) \
+		LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)
+
+$(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE) $(BPFTOOL_OUTPUT):
+	$(call msg,MKDIR,$@)
+	$(Q)mkdir -p $@
 
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
@@ -367,7 +383,7 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 	$(Q)$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(SRCARCH) \
 		-Wno-compare-distinct-pointer-types -I$(srctree)/include \
 		-I$(srctree)/samples/bpf -I$(srctree)/tools/include \
-		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
+		-I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
 LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
@@ -404,7 +420,7 @@ $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
 	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(BPF_EXTRA_CFLAGS) \
 		-I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
-		-I$(srctree)/tools/lib/ \
+		-I$(LIBBPF_INCLUDE) \
 		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
 		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
 		-Wno-gnu-variable-sized-type-not-at-end \
-- 
2.30.2

