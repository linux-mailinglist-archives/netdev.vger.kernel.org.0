Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A4B445DB5
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhKECBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhKECBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 22:01:01 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A29C061205
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 18:58:22 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so5509973wme.4
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 18:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Ov9WNcUS7VnCpB+C4+JiV+oY3dJctzolS44UUkDjME=;
        b=Jews42ylp46dhX/NQ9J0y43txE+GTZFxNE6nAT5vFWmZpWydV3ySCbDMNelaAEdpif
         0ruQzRZnPM7RCt8yAbq5rKle/5bi053EaG88eQHznpuWhR5AOweZhc9598H91CLFLqK7
         BkcQLHZW4rWCLy1B1p/+nBOOmZ0frKap4wGD6RjnecaRRzYMbHrt3LY4Pq3QLDP0qguF
         PVwZc6AZ7ZmrvaCPNdyJsRuVtRS+jzszB/z7qAifSiBa8gkEv9cW4aIu/rgSqYJcHFR4
         1pQ8HfpGSAI3oBlFKjK4+Wu0nUJ68Nvlp4/nMJqzQedoYQ1yBPM+myIwalDeRxMYwlF/
         JK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Ov9WNcUS7VnCpB+C4+JiV+oY3dJctzolS44UUkDjME=;
        b=2cGlqOCT3xtTLp9Z5kU73cpklsAprdyOfdZmGqbYk+SOFaee5b6yBn5UPdc94D4RLs
         FjBlCIs2RXaDpBGUT+s/a3qxFPbNtDHol9DyVAUq78ODGMK+HoHFCfEeC0W40BzJ+fgE
         8kOwwBE5FWOLmxDgiEkyR1UEdCRJqV2mOuZiNPW9nqrWuioCDegS7lI+bnILXmn/SZrP
         Fd+W5kGUGzGEeEnqXokWsf/pNJEUgsxX3ChDI0FoK/ePY1xPW0l6I0X3o+r6ISN6B6pp
         TC6w4f2RaI+Sy64src+Yx33+wzaA8/qqNZSof5iB1Qz42vH1RsufIQUKmfXfGfIVr4jg
         Qs0A==
X-Gm-Message-State: AOAM533MnLPJiqTbMUXNSkGhBl+Rb3MGGYTuQK0yL4sHx8ZxM58aQYAS
        AqyYFPns9jD+vtdmq4kfJ1VjwDANrMb10A==
X-Google-Smtp-Source: ABdhPJzRaA8e/IQ6iWqcLn2YiwGFbqutJDPQugbseCcKGIuQZoYilXoJLn0QHGKEFR1pL1jfI5uD3Q==
X-Received: by 2002:a1c:98ca:: with SMTP id a193mr27600896wme.162.1636077501130;
        Thu, 04 Nov 2021 18:58:21 -0700 (PDT)
Received: from localhost.localdomain ([149.86.66.250])
        by smtp.gmail.com with ESMTPSA id z15sm6628850wrr.65.2021.11.04.18.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:58:20 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf] bpftool: Install libbpf headers for the bootstrap version, too
Date:   Fri,  5 Nov 2021 01:58:13 +0000
Message-Id: <20211105015813.6171-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently changed bpftool's Makefile to make it install libbpf's
headers locally instead of pulling them from the source directory of the
library. Although bpftool needs two versions of libbpf, a "regular" one
and a "bootstrap" version, we would only install headers for the regular
libbpf build. Given that this build always occurs before the bootstrap
build when building bpftool, this is enough to ensure that the bootstrap
bpftool will have access to the headers exported through the regular
libbpf build.

However, this did not account for the case when we only want the
bootstrap version of bpftool, through the "bootstrap" target. For
example, perf needs the bootstrap version only, to generate BPF
skeletons. In that case, when are the headers installed? For some time,
the issue has been masked, because we had a step (the installation of
headers internal to libbpf) which would depend on the regular build of
libbpf and hence trigger the export of the headers, just for the sake of
creating a directory. But this changed with commit 8b6c46241c77
("bpftool: Remove Makefile dep. on $(LIBBPF) for
$(LIBBPF_INTERNAL_HDRS)"), where we cleaned up that stage and removed
the dependency on the regular libbpf build. As a result, when we only
want the bootstrap bpftool version, the regular libbpf is no longer
built. The bootstrap libbpf version is built, but headers are not
exported, and the bootstrap bpftool build fails because of the missing
headers.

To fix this, we also install the library headers for the bootstrap
version of libbpf, to use them for the bootstrap bpftool and for
generating the skeletons.

Fixes: f012ade10b34 ("bpftool: Install libbpf headers instead of including the dir")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index c0c30e56988f..7cfba11c3014 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -22,24 +22,29 @@ else
   _OUTPUT := $(CURDIR)
 endif
 BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
+
 LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
 LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
 LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
 LIBBPF_HDRS_DIR := $(LIBBPF_INCLUDE)/bpf
+LIBBPF := $(LIBBPF_OUTPUT)libbpf.a
 
-LIBBPF = $(LIBBPF_OUTPUT)libbpf.a
-LIBBPF_BOOTSTRAP_OUTPUT = $(BOOTSTRAP_OUTPUT)libbpf/
-LIBBPF_BOOTSTRAP = $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
+LIBBPF_BOOTSTRAP_OUTPUT := $(BOOTSTRAP_OUTPUT)libbpf/
+LIBBPF_BOOTSTRAP_DESTDIR := $(LIBBPF_BOOTSTRAP_OUTPUT)
+LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)/include
+LIBBPF_BOOTSTRAP_HDRS_DIR := $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
+LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 
 # We need to copy hashmap.h and nlattr.h which is not otherwise exported by
 # libbpf, but still required by bpftool.
 LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
+LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
 
 ifeq ($(BPFTOOL_VERSION),)
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 endif
 
-$(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR):
+$(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
 	$(QUIET_MKDIR)mkdir -p $@
 
 $(LIBBPF): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_OUTPUT)
@@ -52,7 +57,12 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_
 
 $(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
-		ARCH= CC=$(HOSTCC) LD=$(HOSTLD) $@
+		DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR) prefix= \
+		ARCH= CC=$(HOSTCC) LD=$(HOSTLD) $@ install_headers
+
+$(LIBBPF_BOOTSTRAP_INTERNAL_HDRS): $(LIBBPF_BOOTSTRAP_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_BOOTSTRAP_HDRS_DIR)
+	$(call QUIET_INSTALL, $@)
+	$(Q)install -m 644 -t $(LIBBPF_BOOTSTRAP_HDRS_DIR) $<
 
 $(LIBBPF)-clean: FORCE | $(LIBBPF_OUTPUT)
 	$(call QUIET_CLEAN, libbpf)
@@ -172,11 +182,11 @@ else
 	$(Q)cp "$(VMLINUX_H)" $@
 endif
 
-$(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
+$(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF_BOOTSTRAP)
 	$(QUIET_CLANG)$(CLANG) \
 		-I$(if $(OUTPUT),$(OUTPUT),.) \
 		-I$(srctree)/tools/include/uapi/ \
-		-I$(LIBBPF_INCLUDE) \
+		-I$(LIBBPF_BOOTSTRAP_INCLUDE) \
 		-g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
 
 $(OUTPUT)%.skel.h: $(OUTPUT)%.bpf.o $(BPFTOOL_BOOTSTRAP)
@@ -209,8 +219,10 @@ $(BPFTOOL_BOOTSTRAP): $(BOOTSTRAP_OBJS) $(LIBBPF_BOOTSTRAP)
 $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
 
-$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
-	$(QUIET_CC)$(HOSTCC) $(CFLAGS) -c -MMD -o $@ $<
+$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
+	$(QUIET_CC)$(HOSTCC) \
+		$(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),$(CFLAGS)) \
+		-c -MMD -o $@ $<
 
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -c -MMD -o $@ $<
@@ -257,6 +269,6 @@ doc-uninstall:
 FORCE:
 
 .SECONDARY:
-.PHONY: all FORCE clean install-bin install uninstall
+.PHONY: all FORCE bootstrap clean install-bin install uninstall
 .PHONY: doc doc-clean doc-install doc-uninstall
 .DEFAULT_GOAL := all
-- 
2.32.0

