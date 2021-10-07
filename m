Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73845425C85
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241552AbhJGTrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241532AbhJGTqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518FFC061765
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:55 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id o20so22399520wro.3
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9cz6nPMtBtsfcFpig2Xytl+9xRW0QoX2HA2zE+W42Y0=;
        b=zgwrTXf40k2vg0VGDAGcSJaP8UCngBAu+RxJ4MV5lci8m6+Rm70ypULsA0pRsvkX6+
         z6YOOSE4jG9mJb7NWcPK8zNjZUddhBnwW4d3n6cLNchT7p5O9xrVBnLW1kgtD2zzaBNo
         fKZ0kXbqG35uZDlDOhYaq2+l+i/pXmrcttbwwJalS1u0D42NNPkwCPuEEYbb1OdnJzsp
         nwuGeNT6n8MNkbNEK5GzAXZTfNVPiYyhZCqhXjTopGAz6uMTL/lfeBUEowr+y53mZi31
         HLsPgQdrGalTZo+vj7EEwGbl6n9pdoLpm4dGHaf51CVqXEluMjuX9eUDkUWquWWz5yEd
         wmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9cz6nPMtBtsfcFpig2Xytl+9xRW0QoX2HA2zE+W42Y0=;
        b=1RyIU3zjnIAG72TS8ASzkiI5y/5FVmo2hGp9MDJlYvMwyJEDWvtnYWvlzx+OOHdl3k
         R/NwHIDMW0/NbBkbbmVXkps/PkdkbqNlyW7uu1a5IuIFsfSvqoZV76XR/UMdouOC+vDr
         COUV663gR5b8Uy9kT9NQnL7TDcX4C6lo6fA8x0b5+V79WgOlhLWy4FxUgmwKPRFLZIXo
         nh9oodiOjmMRM5ZC3B2xifRd40Sa837n++DvTEdbIX7b5VixLQrOAjxHZmtxr0JZooMB
         nqV3+xtc4shsvz1lAEwfogQxBjQVSKbX9KMlW8mxP1sNBHabuIKAj5vNdDVZgaWmzjoj
         vJaw==
X-Gm-Message-State: AOAM530fpcG6Fjl+sUf5MiRmBAZd0bRxNEyeEJbW/4XhU6W7Dqko19wz
        ymWwlDqKabIZ0jxsu7wdwucNpw==
X-Google-Smtp-Source: ABdhPJxBx8zy7uAu4tL3TguB3d8gJlOn9rM5HAw7ALQz4TrIt+dxc3M3kqzmMlV2Z6MfAJ751xnslA==
X-Received: by 2002:adf:b7c1:: with SMTP id t1mr7734992wre.387.1633635893895;
        Thu, 07 Oct 2021 12:44:53 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:53 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 09/12] samples/bpf: install libbpf headers when building
Date:   Thu,  7 Oct 2021 20:44:35 +0100
Message-Id: <20211007194438.34443-10-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
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
index a5783749ec15..cb72198f6b48 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -61,7 +61,11 @@ tprogs-y += xdp_redirect
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
@@ -200,7 +204,7 @@ TPROGS_CFLAGS += -Wstrict-prototypes
 
 TPROGS_CFLAGS += -I$(objtree)/usr/include
 TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
-TPROGS_CFLAGS += -I$(srctree)/tools/lib/
+TPROGS_CFLAGS += -I$(LIBBPF_INCLUDE)
 TPROGS_CFLAGS += -I$(srctree)/tools/include
 TPROGS_CFLAGS += -I$(srctree)/tools/perf
 TPROGS_CFLAGS += -DHAVE_ATTR_TEST=0
@@ -270,16 +274,28 @@ all:
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
@@ -311,6 +327,11 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+libbpf_hdrs: $(LIBBPF)
+$(obj)/$(TRACE_HELPERS): | libbpf_hdrs
+
+.PHONY: libbpf_hdrs
+
 $(obj)/xdp_redirect_cpu_user.o: $(obj)/xdp_redirect_cpu.skel.h
 $(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
 $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
@@ -369,7 +390,7 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 	$(Q)$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(SRCARCH) \
 		-Wno-compare-distinct-pointer-types -I$(srctree)/include \
 		-I$(srctree)/samples/bpf -I$(srctree)/tools/include \
-		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
+		-I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
 LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
@@ -406,7 +427,7 @@ $(obj)/%.o: $(src)/%.c
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

