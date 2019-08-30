Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697C4A2BC6
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfH3AvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:51:08 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38013 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbfH3Auz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:50:55 -0400
Received: by mail-lj1-f193.google.com with SMTP id x3so4817820lji.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eRu74lcVO6wVz56irfReRFgKKrKVWSF8s29xnt/RZAY=;
        b=aGgIzR5sxMevxwKrFIyIUyDYL1+Nx/1OC8zAJhAo/8dNBndVj2YmCvfj4i/zxgGBQ5
         9edGcAC+kLpfo+7btqyQXLrPsDRjsU5GiMXrZ3F1bTwelUYM704o4c4HOhlb9i4g2T2G
         46UcPIwAy05XmYLGl6WZEm82+FLAfxfQddpq5RM57C+zoFIgNj/WnvAj9M3P90P8JtVK
         fUQhcgTmih1w2KzIBZh2ceq9oweGUIxFdv9byIZH8yosJuMVvajEvIs+cuV9WSxGmoKX
         yK2E/F55R48zySZ4XYDK0bxU0szO5ISOj0W65i2/9aLaZho9b6vP+D9pYH9vnnHPIIXd
         /sVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eRu74lcVO6wVz56irfReRFgKKrKVWSF8s29xnt/RZAY=;
        b=qB5r/qn1qTXxW1jbUab+5bQevNrUKXGcG77C3LYN+umzuDko02gSTMC90ajcvD3OCh
         YQUhv33F9LS8lokpG7zA/qv3c59P/ZuESeiOq0hz8C7CoVEr74GSTBrtHBSDtThnCZDt
         BIgMWtz6xCkMjuk8KGo6FS/WTS0wA3aqRGO5ymrIi3Dy1fG6c7tUTe8RwxOipuXrKy5f
         kebC7/2y/oXjd8TiaoI4X/i8AW7xdxA3rqL7j+WqMBRAsUksd8Km+9MTEJAMGlEYLSHS
         R6cIxQNLuMkf9P9SQrjXfvcy1wNxzR1KWxmiC+2zV0mDiJzi7YuL441kUOswPKMTTSax
         zkiQ==
X-Gm-Message-State: APjAAAW+pbRqavM91grHuouxrbyEkqvF743XRLsUsT/iH1KgeUn26+GC
        siPfTN+mlrW7J2wGCLFKw222GTGq6Q0=
X-Google-Smtp-Source: APXvYqy6rek51YkaTV1nUhUOyqQ0yD+SP7FpICbjOhyO7EA98MykAeJdl6ufwnoeFlJrYhw0v9K3OA==
X-Received: by 2002:a2e:9f02:: with SMTP id u2mr7121058ljk.4.1567126251915;
        Thu, 29 Aug 2019 17:50:51 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id f19sm628149lfk.43.2019.08.29.17.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:50:51 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH RFC bpf-next 08/10] samples: bpf: Makefile: base progs build on Makefile.progs
Date:   Fri, 30 Aug 2019 03:50:35 +0300
Message-Id: <20190830005037.24004-9-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
References: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main reason for that - HOSTCC and CC have different aims.
It was tested for arm cross compilation, based on linaro toolchain,
but should work for others.

In order to split cross compilation with host build, base bpf samples
on Makefile.progs. I've verified it on arm with adding SYSROOT.
It's also convenient when debug is with NFC.
To cross-compile I've used:

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make -j4 samples/bpf/ SYSROOT="path/to/sysroot"

Sysroot contains correct headers installed ofc.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile   | 164 ++++++++++++++++++++++++-----------------
 samples/bpf/README.rst |   7 ++
 2 files changed, 102 insertions(+), 69 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 043f9cc14cdd..ed7131851172 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -4,55 +4,53 @@ BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
 TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
 
 # List of programs to build
-hostprogs-y := test_lru_dist
-hostprogs-y += sock_example
-hostprogs-y += fds_example
-hostprogs-y += sockex1
-hostprogs-y += sockex2
-hostprogs-y += sockex3
-hostprogs-y += tracex1
-hostprogs-y += tracex2
-hostprogs-y += tracex3
-hostprogs-y += tracex4
-hostprogs-y += tracex5
-hostprogs-y += tracex6
-hostprogs-y += tracex7
-hostprogs-y += test_probe_write_user
-hostprogs-y += trace_output
-hostprogs-y += lathist
-hostprogs-y += offwaketime
-hostprogs-y += spintest
-hostprogs-y += map_perf_test
-hostprogs-y += test_overhead
-hostprogs-y += test_cgrp2_array_pin
-hostprogs-y += test_cgrp2_attach
-hostprogs-y += test_cgrp2_sock
-hostprogs-y += test_cgrp2_sock2
-hostprogs-y += xdp1
-hostprogs-y += xdp2
-hostprogs-y += xdp_router_ipv4
-hostprogs-y += test_current_task_under_cgroup
-hostprogs-y += trace_event
-hostprogs-y += sampleip
-hostprogs-y += tc_l2_redirect
-hostprogs-y += lwt_len_hist
-hostprogs-y += xdp_tx_iptunnel
-hostprogs-y += test_map_in_map
-hostprogs-y += per_socket_stats_example
-hostprogs-y += xdp_redirect
-hostprogs-y += xdp_redirect_map
-hostprogs-y += xdp_redirect_cpu
-hostprogs-y += xdp_monitor
-hostprogs-y += xdp_rxq_info
-hostprogs-y += syscall_tp
-hostprogs-y += cpustat
-hostprogs-y += xdp_adjust_tail
-hostprogs-y += xdpsock
-hostprogs-y += xdp_fwd
-hostprogs-y += task_fd_query
-hostprogs-y += xdp_sample_pkts
-hostprogs-y += ibumad
-hostprogs-y += hbm
+progs-y := test_lru_dist
+progs-y += sock_example
+progs-y += fds_example
+progs-y += sockex1
+progs-y += sockex2
+progs-y += sockex3
+progs-y += tracex1
+progs-y += tracex2
+progs-y += tracex3
+progs-y += tracex4
+progs-y += tracex5
+progs-y += tracex6
+progs-y += tracex7
+progs-y += test_probe_write_user
+progs-y += trace_output
+progs-y += lathist
+progs-y += offwaketime
+progs-y += spintest
+progs-y += map_perf_test
+progs-y += test_overhead
+progs-y += test_cgrp2_array_pin
+progs-y += test_cgrp2_attach
+progs-y += test_cgrp2_sock
+progs-y += test_cgrp2_sock2
+progs-y += xdp1
+progs-y += xdp2
+progs-y += xdp_router_ipv4
+progs-y += test_current_task_under_cgroup
+progs-y += trace_event
+progs-y += sampleip
+progs-y += tc_l2_redirect
+progs-y += lwt_len_hist
+progs-y += xdp_tx_iptunnel
+progs-y += test_map_in_map
+progs-y += xdp_redirect_map
+progs-y += xdp_redirect_cpu
+progs-y += xdp_monitor
+progs-y += xdp_rxq_info
+progs-y += syscall_tp
+progs-y += cpustat
+progs-y += xdp_adjust_tail
+progs-y += xdpsock
+progs-y += xdp_fwd
+progs-y += task_fd_query
+progs-y += xdp_sample_pkts
+progs-y += ibumad
+progs-y += hbm
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -111,7 +109,7 @@ ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
 
 # Tell kbuild to always build the programs
-always := $(hostprogs-y)
+always := $(progs-y)
 always += sockex1_kern.o
 always += sockex2_kern.o
 always += sockex3_kern.o
@@ -171,26 +169,51 @@ always += ibumad_kern.o
 always += hbm_out_kern.o
 always += hbm_edt_kern.o
 
-KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
-
-HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
-
-KBUILD_HOSTLDLIBS		+= $(LIBBPF) -lelf
-HOSTLDLIBS_tracex4		+= -lrt
-HOSTLDLIBS_trace_output	+= -lrt
-HOSTLDLIBS_map_perf_test	+= -lrt
-HOSTLDLIBS_test_overhead	+= -lrt
-HOSTLDLIBS_xdpsock		+= -pthread
-
 # Strip all expet -D options needed to handle linux headers
 # for arm it's __LINUX_ARM_ARCH__ and potentially others fork vars
 D_OPTIONS = $(shell echo "$(KBUILD_CFLAGS) " | sed 's/[[:blank:]]/\n/g' | \
 	sed '/^-D/!d' | tr '\n' ' ')
 
+ifdef SYSROOT
+ccflags-y += --sysroot=${SYSROOT}
+ccflags-y += -I${SYSROOT}/usr/include
+CLANG_EXTRA_CFLAGS := $(ccflags-y)
+PROGS_LDFLAGS := -L${SYSROOT}/usr/lib
+endif
+
+ccflags-y += -I$(srctree)/tools/lib/bpf/
+ccflags-y += -I$(srctree)/tools/testing/selftests/bpf/
+ccflags-y += -I$(srctree)/tools/lib/
+ccflags-y += -I$(srctree)/tools/perf
+
+ccflags-y += $(D_OPTIONS)
+ccflags-y += -Wall
+ccflags-y += -Wmissing-prototypes
+ccflags-y += -Wstrict-prototypes
+ccflags-y += -fomit-frame-pointer
+
+PROGS_CFLAGS := $(ccflags-y)
+
+ccflags-y += -I$(objtree)/usr/include
+ccflags-y += -I$(srctree)/tools/include
+
+PROGCFLAGS_bpf_load.o += -I$(objtree)/usr/include -I$(srctree)/tools/include \
+			 -Wno-unused-variable
+PROGCFLAGS_sampleip_user.o += -I$(srctree)/tools/include
+PROGCFLAGS_task_fd_query_user.o += -I$(srctree)/tools/include
+PROGCFLAGS_trace_event_user.o += -I$(srctree)/tools/include
+PROGCFLAGS_trace_output_user.o += -I$(srctree)/tools/include
+PROGCFLAGS_tracex6_user.o += -I$(srctree)/tools/include
+PROGCFLAGS_xdp_sample_pkts_user.o += -I$(srctree)/tools/include
+PROGCFLAGS_xdpsock_user.o += -I$(srctree)/tools/include
+
+PROGS_LDLIBS			:= $(LIBBPF) -lelf
+PROGLDLIBS_tracex4		+= -lrt
+PROGLDLIBS_trace_output		+= -lrt
+PROGLDLIBS_map_perf_test	+= -lrt
+PROGLDLIBS_test_overhead	+= -lrt
+PROGLDLIBS_xdpsock		+= -pthread
+
 CLANG_EXTRA_CFLAGS += $(D_OPTIONS)
 
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
@@ -202,15 +225,14 @@ BTF_PAHOLE ?= pahole
 
 # Detect that we're cross compiling and use the cross compiler
 ifdef CROSS_COMPILE
-HOSTCC = $(CROSS_COMPILE)gcc
 CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
 endif
 
 # Don't evaluate probes and warnings if we need to run make recursively
 ifneq ($(src),)
 HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
-	$(HOSTCC) $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
-	echo okay)
+	$(CC) $(PROGS_CFLAGS) $(PROGS_LDFLAGS) -x c - -o /dev/null \
+	2>/dev/null && echo okay)
 
 ifeq ($(HDR_PROBE),)
 $(warning WARNING: Detected possible issues with include path.)
@@ -246,7 +268,9 @@ clean:
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like
-	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(BPF_SAMPLES_PATH)/../../ O=
+	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(ccflags-y)" \
+		EXTRA_CXXFLAGS="$(ccflags-y)" LDFLAGS=$(PROGS_LDFLAGS) \
+		srctree=$(BPF_SAMPLES_PATH)/../../ O=
 
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
@@ -283,6 +307,8 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/hbm.o: $(src)/hbm.h
 $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
+-include $(BPF_SAMPLES_PATH)/Makefile.prog
+
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index 5f27e4faca50..6b5e4eace977 100644
--- a/samples/bpf/README.rst
+++ b/samples/bpf/README.rst
@@ -74,3 +74,10 @@ samples for the cross target.
 export ARCH=arm64
 export CROSS_COMPILE="aarch64-linux-gnu-"
 make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
+
+If need to use environment of target board, the SYSROOT also can be set,
+pointing on FS of target board:
+
+make samples/bpf/ LLC=~/git/llvm/build/bin/llc \
+     CLANG=~/git/llvm/build/bin/clang \
+     SYSROOT=~/some_sdk/linux-devkit/sysroots/aarch64-linux-gnu
-- 
2.17.1

