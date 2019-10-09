Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216BCD19D9
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbfJIUlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:41:53 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43615 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732028AbfJIUlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:53 -0400
Received: by mail-lj1-f196.google.com with SMTP id n14so3849319ljj.10
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M7M9P1nOh5u0u0U5RBRymVMGVBKZgCwkvUp/NKJyprc=;
        b=u/Xk9pOwu+pXtdnZq4EGmi0cTQNHqYuWaDKxLVH6S/ZPCh9X28D9YZyft9l8Jx45tp
         gxgyGp0erhsT0nx5vQ3QPll9ga2XF4vNTonHLIvMx8MX3IkBwvd7pkCq57RiHE3uz8CZ
         uE1A41hnuUvTdijw0TVr0Fj6QJEmZMwojRd3aM+8XXrOauFFwNNlPMkL8hCbHXkDdPbn
         rhYkV8snpca1Qq3DIqiXbwqdLfz9pS7WDDeEhDKDh1QWTe0eq9dFVDx6W/IxMjgt86Jj
         6lGuiYWHhs01b1q6vYZhgcFSh/4ZJ3lwwI2RS1VuIaAEdsF1eT4VW55WQUxTlHcDjHRH
         PbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M7M9P1nOh5u0u0U5RBRymVMGVBKZgCwkvUp/NKJyprc=;
        b=GQ6r1od5/hJf6maXUbW941amyOKlw77c4t9BVf0/U2GcICsgwdxoABt1BwBw3wq4NI
         RerZ8M+mIv64VyXDH9RRfAoJTWU9jiKRKHW1C4BUEdiokON3dVKTJohblF1naQDuEKE3
         CsE7A8fwxczOS5QRaR5kJVikkpK87WWVEFkG6PmJd4Dv2lgkTmVroQtKv2jKtrN4qwdr
         7Iig6xLdT2/Cy3bh6jODiZUOm5eM56h4GLjgj62mNwH2UpWnmblp9v0mAaCrCsVLxK3p
         ScLtoPGyao5be95SDy+z0qQAQBt90B/R9n+K/GQII/lvuXDjXFUVS9vt4HNspN1GsKZ0
         n3aA==
X-Gm-Message-State: APjAAAV9MoB9kCIUprGlhrvD4oxOhws0ZqZa/M/A8d0eVAcS7kWo6opH
        BUzHyycPLRZOUJTGE2h5onlgjw==
X-Google-Smtp-Source: APXvYqyH6gIJi8k32oYlly0v9/LdJnwIUsRChDEjsrMbt3UtCH1KQMFGbdHD7kOFPMQUci9cC3KgGA==
X-Received: by 2002:a2e:9816:: with SMTP id a22mr225505ljj.102.1570653710828;
        Wed, 09 Oct 2019 13:41:50 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:50 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 08/15] samples/bpf: base target programs rules on Makefile.target
Date:   Wed,  9 Oct 2019 23:41:27 +0300
Message-Id: <20191009204134.26960-9-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main reason for that - HOSTCC and CC have different aims.
HOSTCC is used to build programs running on host, that can
cross-comple target programs with CC. It was tested for arm and arm64
cross compilation, based on linaro toolchain, but should work for
others.

So, in order to split cross compilation (CC) with host build (HOSTCC),
lets base samples on Makefile.target. It allows to cross-compile
samples/bpf programs with CC while auxialry tools running on host
built with HOSTCC.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 135 ++++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 66 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index bb2d976e824e..91bfb421c278 100644
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
+tprogs-y := test_lru_dist
+tprogs-y += sock_example
+tprogs-y += fds_example
+tprogs-y += sockex1
+tprogs-y += sockex2
+tprogs-y += sockex3
+tprogs-y += tracex1
+tprogs-y += tracex2
+tprogs-y += tracex3
+tprogs-y += tracex4
+tprogs-y += tracex5
+tprogs-y += tracex6
+tprogs-y += tracex7
+tprogs-y += test_probe_write_user
+tprogs-y += trace_output
+tprogs-y += lathist
+tprogs-y += offwaketime
+tprogs-y += spintest
+tprogs-y += map_perf_test
+tprogs-y += test_overhead
+tprogs-y += test_cgrp2_array_pin
+tprogs-y += test_cgrp2_attach
+tprogs-y += test_cgrp2_sock
+tprogs-y += test_cgrp2_sock2
+tprogs-y += xdp1
+tprogs-y += xdp2
+tprogs-y += xdp_router_ipv4
+tprogs-y += test_current_task_under_cgroup
+tprogs-y += trace_event
+tprogs-y += sampleip
+tprogs-y += tc_l2_redirect
+tprogs-y += lwt_len_hist
+tprogs-y += xdp_tx_iptunnel
+tprogs-y += test_map_in_map
+tprogs-y += xdp_redirect_map
+tprogs-y += xdp_redirect_cpu
+tprogs-y += xdp_monitor
+tprogs-y += xdp_rxq_info
+tprogs-y += syscall_tp
+tprogs-y += cpustat
+tprogs-y += xdp_adjust_tail
+tprogs-y += xdpsock
+tprogs-y += xdp_fwd
+tprogs-y += task_fd_query
+tprogs-y += xdp_sample_pkts
+tprogs-y += ibumad
+tprogs-y += hbm
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -111,7 +109,7 @@ ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
 
 # Tell kbuild to always build the programs
-always := $(hostprogs-y)
+always := $(tprogs-y)
 always += sockex1_kern.o
 always += sockex2_kern.o
 always += sockex3_kern.o
@@ -170,29 +168,32 @@ always += ibumad_kern.o
 always += hbm_out_kern.o
 always += hbm_edt_kern.o
 
-KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
-
-HOSTCFLAGS_bpf_load.o += -Wno-unused-variable
-
-KBUILD_HOSTLDLIBS		+= $(LIBBPF) -lelf
-HOSTLDLIBS_tracex4		+= -lrt
-HOSTLDLIBS_trace_output	+= -lrt
-HOSTLDLIBS_map_perf_test	+= -lrt
-HOSTLDLIBS_test_overhead	+= -lrt
-HOSTLDLIBS_xdpsock		+= -pthread
-
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
 # headers when arm instruction set identification is requested.
 ARM_ARCH_SELECTOR := $(filter -D__LINUX_ARM_ARCH__%, $(KBUILD_CFLAGS))
 BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
-KBUILD_HOSTCFLAGS += $(ARM_ARCH_SELECTOR)
+TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
 endif
 
+TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
+TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
+TPROGS_CFLAGS += -I$(objtree)/usr/include
+TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf/
+TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
+TPROGS_CFLAGS += -I$(srctree)/tools/lib/
+TPROGS_CFLAGS += -I$(srctree)/tools/include
+TPROGS_CFLAGS += -I$(srctree)/tools/perf
+
+TPROGCFLAGS_bpf_load.o += -Wno-unused-variable
+
+TPROGS_LDLIBS			+= $(LIBBPF) -lelf
+TPROGLDLIBS_tracex4		+= -lrt
+TPROGLDLIBS_trace_output	+= -lrt
+TPROGLDLIBS_map_perf_test	+= -lrt
+TPROGLDLIBS_test_overhead	+= -lrt
+TPROGLDLIBS_xdpsock		+= -pthread
+
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
 #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
 LLC ?= llc
@@ -283,6 +284,8 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/hbm.o: $(src)/hbm.h
 $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
+-include $(BPF_SAMPLES_PATH)/Makefile.target
+
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
-- 
2.17.1

