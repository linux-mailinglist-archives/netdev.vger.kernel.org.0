Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FAD4203AB
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhJCTY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhJCTYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 15:24:17 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CA2C06178A
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 12:22:27 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m14-20020a05600c3b0e00b0030d4dffd04fso5834658wms.3
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 12:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PA0i/EWwJwh7+reEqVeD2J7wmdkqQ95NhaVeS0zBeog=;
        b=0R6Iuol4Fwq/n1XZasMMQyznY0SFEY8VkqquoZCK0wjsLs/mG92kd3100/N8+4TpBV
         WWjgsgaDwJ5uPr9Du/ouJzN1cqvSjLAHpVjRGYJtrZ4UF9yUo+hssAIOgMppxVkvhprE
         bcg3BhKoFWcSoy2tuI5qsa3XaILWy8KtKiiajV5cSs0R/snc7yo7EcvGzAhB0hR/K/JD
         obUjS5HUeaWgw+gbNTpXmTLQ5EF4/8S3dV+reTbf+OaG8vYW7kCIFI9kdvQsqHXYPoZl
         36lHMBmGOHV5bYsQCZaAjziA9wB9FoT9wecDl3ZszAVKl/psxLZLpjqOKyznn6iQqf6F
         vWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PA0i/EWwJwh7+reEqVeD2J7wmdkqQ95NhaVeS0zBeog=;
        b=WiLL+BZ+vWSj7DlEFZDvesJYIV+waBNf1fziSLwq2qQeI5kGYp384fa3Eft06atFzA
         Wo1uAieXePvU8WmLAzBYQOSjevS6f5YSLnJ1WgC2bTVvBHWjKueBTpVqhFnVe9CR95v6
         WkqV/W2uf67/A+IyaWk2RB/udL6jWmKSzM5zZdlh/tO13MAKIb9BjIAhe1+afA+BqHJ3
         sNecUI8nF+bdb2GkOOzZKhIwtiGphRSJ5jmvsTrWJdYf4MwmM0xnAezEj9hZ6Kjf2/Et
         OVjBeqBNbtb217H6otgjrEIeJLu2LpUSdVsbFMDuZ7NbGNohFRxCXcv4LIKE69gTUxu1
         NFLQ==
X-Gm-Message-State: AOAM531xk1U9O8HKJkYNwuQkHXUkACleEWb4FhVn7GM5b6y9ytuv6g+x
        9aRMQJuwgFECZzfJGIHhtNkQyQ==
X-Google-Smtp-Source: ABdhPJw9WVzu/MVXgYizR19j/KlOGlVbUDgPvTF07y19xxZUN4PcyRR/SxBBBJjJ3anl0lV2ACkbLg==
X-Received: by 2002:a05:600c:2193:: with SMTP id e19mr15219521wme.38.1633288945690;
        Sun, 03 Oct 2021 12:22:25 -0700 (PDT)
Received: from localhost.localdomain ([149.86.88.77])
        by smtp.gmail.com with ESMTPSA id d3sm14124642wrb.36.2021.10.03.12.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 12:22:25 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 07/10] samples/bpf: install libbpf headers when building
Date:   Sun,  3 Oct 2021 20:22:05 +0100
Message-Id: <20211003192208.6297-8-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003192208.6297-1-quentin@isovalent.com>
References: <20211003192208.6297-1-quentin@isovalent.com>
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

Add a dependency on libbpf's headers for the $(TRACE_HELPERS).

We also change the output directory for bpftool, to place the generated
objects under samples/bpf/bpftool/ instead of building in bpftool's
directory directly. Doing so, we make sure bpftool reuses the libbpf
library previously compiled and installed.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 samples/bpf/Makefile | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4dc20be5fb96..d5566c9e0c69 100644
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
+	@$(RM) -r $(CURDIR)/libbpf $(CURDIR)/bpftool
 
-$(LIBBPF): FORCE
+$(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
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
+$(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
+	    | $(BPFTOOL_OUTPUT)
+	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
+		OUTPUT=$(BPFTOOL_OUTPUT)/ \
+		LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
+		LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
+
+$(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
+	$(call msg,MKDIR,$@)
+	$(Q)mkdir -p $@
 
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
@@ -309,6 +325,11 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+libbpf_hdrs: $(LIBBPF)
+$(obj)/$(TRACE_HELPERS): libbpf_hdrs
+
+.PHONY: libbpf_hdrs
+
 $(obj)/xdp_redirect_cpu_user.o: $(obj)/xdp_redirect_cpu.skel.h
 $(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
 $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
@@ -367,7 +388,7 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 	$(Q)$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(SRCARCH) \
 		-Wno-compare-distinct-pointer-types -I$(srctree)/include \
 		-I$(srctree)/samples/bpf -I$(srctree)/tools/include \
-		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
+		-I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
 LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
@@ -404,7 +425,7 @@ $(obj)/%.o: $(src)/%.c
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

