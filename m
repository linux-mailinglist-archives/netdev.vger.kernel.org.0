Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884B541EB8B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353777AbhJALPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353770AbhJALLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:13 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901D8C06177E
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:29 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l18-20020a05600c4f1200b002f8cf606262so10934042wmq.1
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RpjwrVd2fRDSeptVCei7DoM+TRRc5Wynujd2MS0EFUo=;
        b=OqOImDOtI4DDSRl+4PIAo1tHd8w2W1iB9cGQmeUc3S+t4y2S6QDqGG1MbMExG4ACn8
         V62IIoE1HSm29XHrwhNZHhb1jbAQssR5KvF4n8O1skxTUXX5lDYTeKLjDFv/X9t6iK9F
         0cs2XNmI6v2Wa3ZuU3f8ruRmnz7IaX2H7W5zPfPMMsOY2sjQbxb0ZYsn7AIScBSStiRW
         hnkF4g6teX1yiwit285qbtC7d6DPmIV3lLsbbsR7sxF3dZ5sWSORmxcCC/0zAjIWY06y
         KyPcIVZ9ry94PL4xm8LWFrGyGt4uytnL/xdKpjpoz7aZu/70rNG6+/Vk7LIi/oFPNGfK
         VZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RpjwrVd2fRDSeptVCei7DoM+TRRc5Wynujd2MS0EFUo=;
        b=iSJ9MZyhWCsvMBAhS3UzfNa2XV8wq72/G2MZs7ePrmSYvQhwFwuRplcU8VFCKePHvb
         g8SNMVOscqyatd+zCBMiaW54T8FMb6IEznL6pVn3mzdexycI93AkDf9HaGeSbWXFQWgg
         tAPhez2P0iWEY5mMJFc2O08QG52QV1TnR+NIP8/zdpAK/s5dphKODKRHdMFaGYgbMiPt
         Q7veLPzy34pzOsl9llYX7Qq2sCrirzUnOCKZsu1YVO9XZH+qnO+w5JivAD8e7BiEi1KQ
         UpOjc0PQvWMa5zVzU+a9nygb37VNwUDHjBobH0MrpzFENcTFDR/T6WSA5nay/f3CpCa7
         2dlQ==
X-Gm-Message-State: AOAM532l6bXGsi0Xjzpl0BZjTdjqnNWdydLaCkg6uwkz0DbEhpLvmQje
        L/g/L+3+oRmqj8MaxGh+dmoBHvX2XoTU/3sq
X-Google-Smtp-Source: ABdhPJyHbLVPxeCHmUZH4hIbe7h7G69gmZR9BZKlybxKixsGC8lSs3YSwFFJd9hEccLYHvBB+vwGfg==
X-Received: by 2002:a05:600c:4e93:: with SMTP id f19mr3808416wmq.185.1633086568140;
        Fri, 01 Oct 2021 04:09:28 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:27 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 7/9] samples/bpf: install libbpf headers when building
Date:   Fri,  1 Oct 2021 12:08:54 +0100
Message-Id: <20211001110856.14730-8-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
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

