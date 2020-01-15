Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC28313C5D5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgAOOWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:22:44 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24073 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgAOOWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 09:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579098162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NTNGvfTh/TQRgyPay3OkucTbSfnDcleHs3FaiPpC3OQ=;
        b=dl2BeXNNYPML2+Md9V6MDI9VJ51d+UQ3qE3sPYqkskIbwLOKq8DfgFQfjbc+2Fwm0U2e6v
        pPwnpHUNaDX2wikimMAkWhY7a3rsh7hdFama85KqA9UAYGaLz7DRl38HiZgSiiLwhbJyN1
        yvUzyOGyBcN3V5lYSVFuEGIvFEknm6s=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-4H80SS-sNMWyDRO7c_y7hA-1; Wed, 15 Jan 2020 09:22:40 -0500
X-MC-Unique: 4H80SS-sNMWyDRO7c_y7hA-1
Received: by mail-lj1-f197.google.com with SMTP id w6so4202530ljo.20
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 06:22:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NTNGvfTh/TQRgyPay3OkucTbSfnDcleHs3FaiPpC3OQ=;
        b=LGNL6MQpmHPOTLECBmrNNxU32zG/QKvJBKvf8PS17lRk9FywNoswBpGAoBhOLYZ+DS
         Mm9dyEJBP8RoDmCJrQ1OlYoPcjhCfRjdBmgMOFD1Q816x0ZdymmwmCJlC4Cxw7bYA4jG
         rfQCIofK/y782n9wL+BWRz5jb2K8gDEFjhxS9DlR0F9oRUEE2hHE1wP29yuxitF/pQd3
         bMyFFYrHcFKD7QKAQ9+hcf+9AXLVhBxeKJgW6M/vf+z6YlbvSfLIJkl63TjIamgLwooR
         0syRrrKSyFpmX9a9NjVw7JuMspV0lgY+6BTitNdgMh+sQpJ3cyoVYHUJkzLF0ebOJP3p
         MAZg==
X-Gm-Message-State: APjAAAWkkBxZL5R69Y5ls5+HoeDTeB081bgpmPN8wrFI1WVCtp+a67+X
        kRbHYagYzhs0ZT3xjnWmV/3b2szoJE0DEQ71e4I2ad+cC9UUeN+8wneOEiEGsI2P7nqr0Vap8Qw
        oIwFdOilBeIuZ1lf2
X-Received: by 2002:a2e:9cca:: with SMTP id g10mr1950114ljj.258.1579098158833;
        Wed, 15 Jan 2020 06:22:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxq21cDovyEtIxSJxwLEYgC7RdVZUl7hTrg1BtOPdF2OGFTxuNjNsiJJXOIMzaqU4BdPxuPRA==
X-Received: by 2002:a2e:9cca:: with SMTP id g10mr1950061ljj.258.1579098158008;
        Wed, 15 Jan 2020 06:22:38 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g27sm8927568lfh.57.2020.01.15.06.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 06:22:37 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7CB1E1804D7; Wed, 15 Jan 2020 15:12:56 +0100 (CET)
Subject: [PATCH bpf-next v2 07/10] samples/bpf: Use consistent include paths
 for libbpf
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Wed, 15 Jan 2020 15:12:56 +0100
Message-ID: <157909757639.1192265.16930011370158657444.stgit@toke.dk>
In-Reply-To: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Fix all files in samples/bpf to include libbpf header files with the bpf/
prefix, to be consistent with external users of the library. Also ensure
that all includes of exported libbpf header files (those that are exported
on 'make install' of the library) use bracketed includes instead of quoted.

To make sure no new files are introduced that doesn't include the bpf/
prefix in its include, remove tools/lib/bpf from the include path entirely,
and use tools/lib instead.

Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken from selftests dir")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/Makefile                              |    3 +--
 samples/bpf/cpustat_kern.c                        |    2 +-
 samples/bpf/fds_example.c                         |    2 +-
 samples/bpf/hbm.c                                 |    4 ++--
 samples/bpf/hbm_kern.h                            |    4 ++--
 samples/bpf/ibumad_kern.c                         |    2 +-
 samples/bpf/ibumad_user.c                         |    2 +-
 samples/bpf/lathist_kern.c                        |    2 +-
 samples/bpf/lwt_len_hist_kern.c                   |    2 +-
 samples/bpf/map_perf_test_kern.c                  |    4 ++--
 samples/bpf/offwaketime_kern.c                    |    4 ++--
 samples/bpf/offwaketime_user.c                    |    2 +-
 samples/bpf/parse_ldabs.c                         |    2 +-
 samples/bpf/parse_simple.c                        |    2 +-
 samples/bpf/parse_varlen.c                        |    2 +-
 samples/bpf/sampleip_kern.c                       |    4 ++--
 samples/bpf/sampleip_user.c                       |    2 +-
 samples/bpf/sock_flags_kern.c                     |    2 +-
 samples/bpf/sockex1_kern.c                        |    2 +-
 samples/bpf/sockex1_user.c                        |    2 +-
 samples/bpf/sockex2_kern.c                        |    2 +-
 samples/bpf/sockex2_user.c                        |    2 +-
 samples/bpf/sockex3_kern.c                        |    2 +-
 samples/bpf/spintest_kern.c                       |    4 ++--
 samples/bpf/spintest_user.c                       |    2 +-
 samples/bpf/syscall_tp_kern.c                     |    2 +-
 samples/bpf/task_fd_query_kern.c                  |    2 +-
 samples/bpf/task_fd_query_user.c                  |    2 +-
 samples/bpf/tc_l2_redirect_kern.c                 |    2 +-
 samples/bpf/tcbpf1_kern.c                         |    2 +-
 samples/bpf/tcp_basertt_kern.c                    |    4 ++--
 samples/bpf/tcp_bufs_kern.c                       |    4 ++--
 samples/bpf/tcp_clamp_kern.c                      |    4 ++--
 samples/bpf/tcp_cong_kern.c                       |    4 ++--
 samples/bpf/tcp_dumpstats_kern.c                  |    4 ++--
 samples/bpf/tcp_iw_kern.c                         |    4 ++--
 samples/bpf/tcp_rwnd_kern.c                       |    4 ++--
 samples/bpf/tcp_synrto_kern.c                     |    4 ++--
 samples/bpf/tcp_tos_reflect_kern.c                |    4 ++--
 samples/bpf/test_cgrp2_tc_kern.c                  |    2 +-
 samples/bpf/test_current_task_under_cgroup_kern.c |    2 +-
 samples/bpf/test_lwt_bpf.c                        |    2 +-
 samples/bpf/test_map_in_map_kern.c                |    4 ++--
 samples/bpf/test_overhead_kprobe_kern.c           |    4 ++--
 samples/bpf/test_overhead_raw_tp_kern.c           |    2 +-
 samples/bpf/test_overhead_tp_kern.c               |    2 +-
 samples/bpf/test_probe_write_user_kern.c          |    4 ++--
 samples/bpf/trace_event_kern.c                    |    4 ++--
 samples/bpf/trace_event_user.c                    |    2 +-
 samples/bpf/trace_output_kern.c                   |    2 +-
 samples/bpf/trace_output_user.c                   |    2 +-
 samples/bpf/tracex1_kern.c                        |    4 ++--
 samples/bpf/tracex2_kern.c                        |    4 ++--
 samples/bpf/tracex3_kern.c                        |    4 ++--
 samples/bpf/tracex4_kern.c                        |    4 ++--
 samples/bpf/tracex5_kern.c                        |    4 ++--
 samples/bpf/tracex6_kern.c                        |    2 +-
 samples/bpf/tracex7_kern.c                        |    2 +-
 samples/bpf/xdp1_kern.c                           |    2 +-
 samples/bpf/xdp1_user.c                           |    4 ++--
 samples/bpf/xdp2_kern.c                           |    2 +-
 samples/bpf/xdp2skb_meta_kern.c                   |    2 +-
 samples/bpf/xdp_adjust_tail_kern.c                |    2 +-
 samples/bpf/xdp_adjust_tail_user.c                |    4 ++--
 samples/bpf/xdp_fwd_kern.c                        |    2 +-
 samples/bpf/xdp_fwd_user.c                        |    2 +-
 samples/bpf/xdp_monitor_kern.c                    |    2 +-
 samples/bpf/xdp_redirect_cpu_kern.c               |    2 +-
 samples/bpf/xdp_redirect_cpu_user.c               |    2 +-
 samples/bpf/xdp_redirect_kern.c                   |    2 +-
 samples/bpf/xdp_redirect_map_kern.c               |    2 +-
 samples/bpf/xdp_redirect_map_user.c               |    2 +-
 samples/bpf/xdp_redirect_user.c                   |    2 +-
 samples/bpf/xdp_router_ipv4_kern.c                |    2 +-
 samples/bpf/xdp_router_ipv4_user.c                |    2 +-
 samples/bpf/xdp_rxq_info_kern.c                   |    2 +-
 samples/bpf/xdp_rxq_info_user.c                   |    4 ++--
 samples/bpf/xdp_sample_pkts_kern.c                |    2 +-
 samples/bpf/xdp_sample_pkts_user.c                |    2 +-
 samples/bpf/xdp_tx_iptunnel_kern.c                |    2 +-
 samples/bpf/xdp_tx_iptunnel_user.c                |    2 +-
 samples/bpf/xdpsock_kern.c                        |    2 +-
 samples/bpf/xdpsock_user.c                        |    6 +++---
 83 files changed, 112 insertions(+), 113 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index f86d713a17a5..b0e8adf7eb01 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -184,7 +184,6 @@ TPROGS_CFLAGS += -Wmissing-prototypes
 TPROGS_CFLAGS += -Wstrict-prototypes
 
 TPROGS_CFLAGS += -I$(objtree)/usr/include
-TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf/
 TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 TPROGS_CFLAGS += -I$(srctree)/tools/lib/
 TPROGS_CFLAGS += -I$(srctree)/tools/include
@@ -305,7 +304,7 @@ $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
 	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(BPF_EXTRA_CFLAGS) \
 		-I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
-		-I$(srctree)/tools/lib/bpf/ \
+		-I$(srctree)/tools/lib/ \
 		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
 		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
 		-Wno-gnu-variable-sized-type-not-at-end \
diff --git a/samples/bpf/cpustat_kern.c b/samples/bpf/cpustat_kern.c
index 68c84da065b1..a86a19d5f033 100644
--- a/samples/bpf/cpustat_kern.c
+++ b/samples/bpf/cpustat_kern.c
@@ -3,7 +3,7 @@
 #include <linux/version.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 /*
  * The CPU number, cstate number and pstate number are based
diff --git a/samples/bpf/fds_example.c b/samples/bpf/fds_example.c
index 2d4b717726b6..d5992f787232 100644
--- a/samples/bpf/fds_example.c
+++ b/samples/bpf/fds_example.c
@@ -14,7 +14,7 @@
 
 #include <bpf/bpf.h>
 
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "bpf_insn.h"
 #include "sock_example.h"
 
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 829b68d87687..7d7153777678 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -50,8 +50,8 @@
 #include "cgroup_helpers.h"
 #include "hbm.h"
 #include "bpf_util.h"
-#include "bpf.h"
-#include "libbpf.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 
 bool outFlag = true;
 int minRate = 1000;		/* cgroup rate limit in Mbps */
diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index 4edaf47876ca..e00f26f6afba 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -22,8 +22,8 @@
 #include <uapi/linux/pkt_cls.h>
 #include <net/ipv6.h>
 #include <net/inet_ecn.h>
-#include "bpf_endian.h"
-#include "bpf_helpers.h"
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_helpers.h>
 #include "hbm.h"
 
 #define DROP_PKT	0
diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
index f281df7e0089..3a91b4c1989a 100644
--- a/samples/bpf/ibumad_kern.c
+++ b/samples/bpf/ibumad_kern.c
@@ -13,7 +13,7 @@
 #define KBUILD_MODNAME "ibumad_count_pkts_by_class"
 #include <uapi/linux/bpf.h>
 
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 
 struct bpf_map_def SEC("maps") read_count = {
diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
index cb5a8f994849..fa06eef31a84 100644
--- a/samples/bpf/ibumad_user.c
+++ b/samples/bpf/ibumad_user.c
@@ -25,7 +25,7 @@
 
 #include "bpf_load.h"
 #include "bpf_util.h"
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 
 static void dump_counts(int fd)
 {
diff --git a/samples/bpf/lathist_kern.c b/samples/bpf/lathist_kern.c
index 18fa088473cd..ca9c2e4e69aa 100644
--- a/samples/bpf/lathist_kern.c
+++ b/samples/bpf/lathist_kern.c
@@ -8,7 +8,7 @@
 #include <linux/version.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 #define MAX_ENTRIES	20
 #define MAX_CPU		4
diff --git a/samples/bpf/lwt_len_hist_kern.c b/samples/bpf/lwt_len_hist_kern.c
index df75383280f9..9ed63e10e170 100644
--- a/samples/bpf/lwt_len_hist_kern.c
+++ b/samples/bpf/lwt_len_hist_kern.c
@@ -14,7 +14,7 @@
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/ip.h>
 #include <uapi/linux/in.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 # define printk(fmt, ...)						\
 		({							\
diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 281bcdaee58e..12e91ae64d4d 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -8,9 +8,9 @@
 #include <linux/netdevice.h>
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_tracing.h>
 
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
index 9cb5207a692f..c4ec10dbfc3b 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -5,8 +5,8 @@
  * License as published by the Free Software Foundation.
  */
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 #include <uapi/linux/ptrace.h>
 #include <uapi/linux/perf_event.h>
 #include <linux/version.h>
diff --git a/samples/bpf/offwaketime_user.c b/samples/bpf/offwaketime_user.c
index fc8767d001f6..51c7da5341cc 100644
--- a/samples/bpf/offwaketime_user.c
+++ b/samples/bpf/offwaketime_user.c
@@ -12,7 +12,7 @@
 #include <assert.h>
 #include <stdbool.h>
 #include <sys/resource.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "bpf_load.h"
 #include "trace_helpers.h"
 
diff --git a/samples/bpf/parse_ldabs.c b/samples/bpf/parse_ldabs.c
index ef5892377beb..c6f65f90a097 100644
--- a/samples/bpf/parse_ldabs.c
+++ b/samples/bpf/parse_ldabs.c
@@ -11,7 +11,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 
 #define DEFAULT_PKTGEN_UDP_PORT	9
diff --git a/samples/bpf/parse_simple.c b/samples/bpf/parse_simple.c
index 10af53d33cc2..4a486cb1e0df 100644
--- a/samples/bpf/parse_simple.c
+++ b/samples/bpf/parse_simple.c
@@ -12,7 +12,7 @@
 #include <linux/udp.h>
 #include <uapi/linux/bpf.h>
 #include <net/ip.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 #define DEFAULT_PKTGEN_UDP_PORT 9
 
diff --git a/samples/bpf/parse_varlen.c b/samples/bpf/parse_varlen.c
index 0b6f22feb2c9..d8623846e810 100644
--- a/samples/bpf/parse_varlen.c
+++ b/samples/bpf/parse_varlen.c
@@ -14,7 +14,7 @@
 #include <linux/udp.h>
 #include <uapi/linux/bpf.h>
 #include <net/ip.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 #define DEFAULT_PKTGEN_UDP_PORT 9
 #define DEBUG 0
diff --git a/samples/bpf/sampleip_kern.c b/samples/bpf/sampleip_kern.c
index 4a190893894f..e504dc308371 100644
--- a/samples/bpf/sampleip_kern.c
+++ b/samples/bpf/sampleip_kern.c
@@ -8,8 +8,8 @@
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_perf_event.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 #define MAX_IPS		8192
 
diff --git a/samples/bpf/sampleip_user.c b/samples/bpf/sampleip_user.c
index 6b5dc26d9701..b0f115f938bc 100644
--- a/samples/bpf/sampleip_user.c
+++ b/samples/bpf/sampleip_user.c
@@ -15,7 +15,7 @@
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
 #include <sys/ioctl.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "bpf_load.h"
 #include "perf-sys.h"
 #include "trace_helpers.h"
diff --git a/samples/bpf/sock_flags_kern.c b/samples/bpf/sock_flags_kern.c
index 05dcdf8a4baa..6d0ac7569d6f 100644
--- a/samples/bpf/sock_flags_kern.c
+++ b/samples/bpf/sock_flags_kern.c
@@ -3,7 +3,7 @@
 #include <linux/net.h>
 #include <uapi/linux/in.h>
 #include <uapi/linux/in6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 SEC("cgroup/sock1")
 int bpf_prog1(struct bpf_sock *sk)
diff --git a/samples/bpf/sockex1_kern.c b/samples/bpf/sockex1_kern.c
index 2408dbfb7a21..431c956460ad 100644
--- a/samples/bpf/sockex1_kern.c
+++ b/samples/bpf/sockex1_kern.c
@@ -2,7 +2,7 @@
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 
 struct {
diff --git a/samples/bpf/sockex1_user.c b/samples/bpf/sockex1_user.c
index a219442afbee..3c83722877dc 100644
--- a/samples/bpf/sockex1_user.c
+++ b/samples/bpf/sockex1_user.c
@@ -3,7 +3,7 @@
 #include <assert.h>
 #include <linux/bpf.h>
 #include <bpf/bpf.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "sock_example.h"
 #include <unistd.h>
 #include <arpa/inet.h>
diff --git a/samples/bpf/sockex2_kern.c b/samples/bpf/sockex2_kern.c
index a7bcd03bf529..a41dd520bc53 100644
--- a/samples/bpf/sockex2_kern.c
+++ b/samples/bpf/sockex2_kern.c
@@ -1,5 +1,5 @@
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 #include <uapi/linux/in.h>
 #include <uapi/linux/if.h>
diff --git a/samples/bpf/sockex2_user.c b/samples/bpf/sockex2_user.c
index 6de383ddd08b..af925a5afd1d 100644
--- a/samples/bpf/sockex2_user.c
+++ b/samples/bpf/sockex2_user.c
@@ -3,7 +3,7 @@
 #include <assert.h>
 #include <linux/bpf.h>
 #include <bpf/bpf.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "sock_example.h"
 #include <unistd.h>
 #include <arpa/inet.h>
diff --git a/samples/bpf/sockex3_kern.c b/samples/bpf/sockex3_kern.c
index 151dd842ecc0..36d4dac23549 100644
--- a/samples/bpf/sockex3_kern.c
+++ b/samples/bpf/sockex3_kern.c
@@ -5,7 +5,7 @@
  * License as published by the Free Software Foundation.
  */
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 #include <uapi/linux/in.h>
 #include <uapi/linux/if.h>
diff --git a/samples/bpf/spintest_kern.c b/samples/bpf/spintest_kern.c
index 6e9478aa2938..f508af357251 100644
--- a/samples/bpf/spintest_kern.c
+++ b/samples/bpf/spintest_kern.c
@@ -9,8 +9,8 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/perf_event.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/spintest_user.c b/samples/bpf/spintest_user.c
index 2556af2d9b3e..fb430ea2ef51 100644
--- a/samples/bpf/spintest_user.c
+++ b/samples/bpf/spintest_user.c
@@ -5,7 +5,7 @@
 #include <string.h>
 #include <assert.h>
 #include <sys/resource.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "bpf_load.h"
 #include "trace_helpers.h"
 
diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
index 630ce8c4d5a2..5a62b03b1f88 100644
--- a/samples/bpf/syscall_tp_kern.c
+++ b/samples/bpf/syscall_tp_kern.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2017 Facebook
  */
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct syscalls_enter_open_args {
 	unsigned long long unused;
diff --git a/samples/bpf/task_fd_query_kern.c b/samples/bpf/task_fd_query_kern.c
index fb56fc2a3e5d..278ade5427c8 100644
--- a/samples/bpf/task_fd_query_kern.c
+++ b/samples/bpf/task_fd_query_kern.c
@@ -2,7 +2,7 @@
 #include <linux/version.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 SEC("kprobe/blk_mq_start_request")
 int bpf_prog1(struct pt_regs *ctx)
diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index 4c31b305e6ef..ff2e9c1c7266 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -15,7 +15,7 @@
 #include <sys/stat.h>
 #include <linux/perf_event.h>
 
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "bpf_load.h"
 #include "bpf_util.h"
 #include "perf-sys.h"
diff --git a/samples/bpf/tc_l2_redirect_kern.c b/samples/bpf/tc_l2_redirect_kern.c
index 7ef2a12b25b2..fd2fa0004330 100644
--- a/samples/bpf/tc_l2_redirect_kern.c
+++ b/samples/bpf/tc_l2_redirect_kern.c
@@ -15,7 +15,7 @@
 #include <uapi/linux/filter.h>
 #include <uapi/linux/pkt_cls.h>
 #include <net/ipv6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 #define _htonl __builtin_bswap32
 
diff --git a/samples/bpf/tcbpf1_kern.c b/samples/bpf/tcbpf1_kern.c
index ff43341bdfce..e9356130f84e 100644
--- a/samples/bpf/tcbpf1_kern.c
+++ b/samples/bpf/tcbpf1_kern.c
@@ -7,7 +7,7 @@
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/filter.h>
 #include <uapi/linux/pkt_cls.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 
 /* compiler workaround */
diff --git a/samples/bpf/tcp_basertt_kern.c b/samples/bpf/tcp_basertt_kern.c
index 9dba48c2b920..8dfe09a92fec 100644
--- a/samples/bpf/tcp_basertt_kern.c
+++ b/samples/bpf/tcp_basertt_kern.c
@@ -16,8 +16,8 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/tcp_bufs_kern.c b/samples/bpf/tcp_bufs_kern.c
index af8486f33771..6a80d08952ad 100644
--- a/samples/bpf/tcp_bufs_kern.c
+++ b/samples/bpf/tcp_bufs_kern.c
@@ -17,8 +17,8 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/tcp_clamp_kern.c b/samples/bpf/tcp_clamp_kern.c
index 26c0fd091f3c..e88bd9ab0695 100644
--- a/samples/bpf/tcp_clamp_kern.c
+++ b/samples/bpf/tcp_clamp_kern.c
@@ -17,8 +17,8 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/tcp_cong_kern.c b/samples/bpf/tcp_cong_kern.c
index 6d4dc4c7dd1e..2311fc9dde85 100644
--- a/samples/bpf/tcp_cong_kern.c
+++ b/samples/bpf/tcp_cong_kern.c
@@ -16,8 +16,8 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/tcp_dumpstats_kern.c b/samples/bpf/tcp_dumpstats_kern.c
index 8557913106a0..e80d3afd24bd 100644
--- a/samples/bpf/tcp_dumpstats_kern.c
+++ b/samples/bpf/tcp_dumpstats_kern.c
@@ -4,8 +4,8 @@
  */
 #include <linux/bpf.h>
 
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define INTERVAL			1000000000ULL
 
diff --git a/samples/bpf/tcp_iw_kern.c b/samples/bpf/tcp_iw_kern.c
index da61d53378b3..d1444557358e 100644
--- a/samples/bpf/tcp_iw_kern.c
+++ b/samples/bpf/tcp_iw_kern.c
@@ -17,8 +17,8 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/tcp_rwnd_kern.c b/samples/bpf/tcp_rwnd_kern.c
index d011e38b80d2..223d9c23b10c 100644
--- a/samples/bpf/tcp_rwnd_kern.c
+++ b/samples/bpf/tcp_rwnd_kern.c
@@ -16,8 +16,8 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/tcp_synrto_kern.c b/samples/bpf/tcp_synrto_kern.c
index 720d1950322d..d58004eef124 100644
--- a/samples/bpf/tcp_synrto_kern.c
+++ b/samples/bpf/tcp_synrto_kern.c
@@ -16,8 +16,8 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/tcp_tos_reflect_kern.c b/samples/bpf/tcp_tos_reflect_kern.c
index 369faca70a15..953fedc79ce1 100644
--- a/samples/bpf/tcp_tos_reflect_kern.c
+++ b/samples/bpf/tcp_tos_reflect_kern.c
@@ -15,8 +15,8 @@
 #include <uapi/linux/ipv6.h>
 #include <uapi/linux/in.h>
 #include <linux/socket.h>
-#include "bpf_helpers.h"
-#include "bpf_endian.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 
 #define DEBUG 1
 
diff --git a/samples/bpf/test_cgrp2_tc_kern.c b/samples/bpf/test_cgrp2_tc_kern.c
index 1547b36a7b7b..4dd532a312b9 100644
--- a/samples/bpf/test_cgrp2_tc_kern.c
+++ b/samples/bpf/test_cgrp2_tc_kern.c
@@ -10,7 +10,7 @@
 #include <uapi/linux/ipv6.h>
 #include <uapi/linux/pkt_cls.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 /* copy of 'struct ethhdr' without __packed */
 struct eth_hdr {
diff --git a/samples/bpf/test_current_task_under_cgroup_kern.c b/samples/bpf/test_current_task_under_cgroup_kern.c
index 86b28d7d6c99..6dc4f41bb6cb 100644
--- a/samples/bpf/test_current_task_under_cgroup_kern.c
+++ b/samples/bpf/test_current_task_under_cgroup_kern.c
@@ -8,7 +8,7 @@
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
 #include <linux/version.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include <uapi/linux/utsname.h>
 
 struct bpf_map_def SEC("maps") cgroup_map = {
diff --git a/samples/bpf/test_lwt_bpf.c b/samples/bpf/test_lwt_bpf.c
index bacc8013436b..1b568575ad11 100644
--- a/samples/bpf/test_lwt_bpf.c
+++ b/samples/bpf/test_lwt_bpf.c
@@ -20,7 +20,7 @@
 #include <linux/udp.h>
 #include <linux/icmpv6.h>
 #include <linux/if_ether.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include <string.h>
 
 # define printk(fmt, ...)						\
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 32ee752f19df..6cee61e8ce9b 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -10,9 +10,9 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/in6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_tracing.h>
 
 #define MAX_NR_PORTS 65536
 
diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe_kern.c
index 8d2518e68db9..8b811c29dc79 100644
--- a/samples/bpf/test_overhead_kprobe_kern.c
+++ b/samples/bpf/test_overhead_kprobe_kern.c
@@ -7,8 +7,8 @@
 #include <linux/version.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 #define _(P) ({typeof(P) val = 0; bpf_probe_read(&val, sizeof(val), &P); val;})
 
diff --git a/samples/bpf/test_overhead_raw_tp_kern.c b/samples/bpf/test_overhead_raw_tp_kern.c
index d2af8bc1c805..8763181a32f3 100644
--- a/samples/bpf/test_overhead_raw_tp_kern.c
+++ b/samples/bpf/test_overhead_raw_tp_kern.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018 Facebook */
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 SEC("raw_tracepoint/task_rename")
 int prog(struct bpf_raw_tracepoint_args *ctx)
diff --git a/samples/bpf/test_overhead_tp_kern.c b/samples/bpf/test_overhead_tp_kern.c
index 38f5c0b9da9f..eaa32693f8fc 100644
--- a/samples/bpf/test_overhead_tp_kern.c
+++ b/samples/bpf/test_overhead_tp_kern.c
@@ -5,7 +5,7 @@
  * License as published by the Free Software Foundation.
  */
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 /* from /sys/kernel/debug/tracing/events/task/task_rename/format */
 struct task_rename {
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index b7c48f37132c..f033f36a13a3 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -8,8 +8,8 @@
 #include <linux/netdevice.h>
 #include <uapi/linux/bpf.h>
 #include <linux/version.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 struct bpf_map_def SEC("maps") dnat_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/trace_event_kern.c b/samples/bpf/trace_event_kern.c
index 8dc18d233a27..da1d69e20645 100644
--- a/samples/bpf/trace_event_kern.c
+++ b/samples/bpf/trace_event_kern.c
@@ -9,8 +9,8 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_perf_event.h>
 #include <uapi/linux/perf_event.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 struct key_t {
 	char comm[TASK_COMM_LEN];
diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index 749a50f2f9f3..356171bc392b 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -15,7 +15,7 @@
 #include <assert.h>
 #include <errno.h>
 #include <sys/resource.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include "bpf_load.h"
 #include "perf-sys.h"
 #include "trace_helpers.h"
diff --git a/samples/bpf/trace_output_kern.c b/samples/bpf/trace_output_kern.c
index 9b96f4fb8cea..1d7d422cae6f 100644
--- a/samples/bpf/trace_output_kern.c
+++ b/samples/bpf/trace_output_kern.c
@@ -1,7 +1,7 @@
 #include <linux/ptrace.h>
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
diff --git a/samples/bpf/trace_output_user.c b/samples/bpf/trace_output_user.c
index 8ee47699a870..60a17dd05345 100644
--- a/samples/bpf/trace_output_user.c
+++ b/samples/bpf/trace_output_user.c
@@ -15,7 +15,7 @@
 #include <sys/mman.h>
 #include <time.h>
 #include <signal.h>
-#include <libbpf.h>
+#include <bpf/libbpf.h>
 #include "bpf_load.h"
 #include "perf-sys.h"
 
diff --git a/samples/bpf/tracex1_kern.c b/samples/bpf/tracex1_kern.c
index 1a15f6605129..8e2610e14475 100644
--- a/samples/bpf/tracex1_kern.c
+++ b/samples/bpf/tracex1_kern.c
@@ -8,8 +8,8 @@
 #include <linux/netdevice.h>
 #include <uapi/linux/bpf.h>
 #include <linux/version.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 #define _(P) ({typeof(P) val = 0; bpf_probe_read(&val, sizeof(val), &P); val;})
 
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index d70b3ea79ea7..d865bb309bcb 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -8,8 +8,8 @@
 #include <linux/netdevice.h>
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/tracex3_kern.c b/samples/bpf/tracex3_kern.c
index 9af546bebfa9..fe21c14feb8d 100644
--- a/samples/bpf/tracex3_kern.c
+++ b/samples/bpf/tracex3_kern.c
@@ -8,8 +8,8 @@
 #include <linux/netdevice.h>
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/tracex4_kern.c b/samples/bpf/tracex4_kern.c
index 2a02cbe9d9a1..b1bb9df88f8e 100644
--- a/samples/bpf/tracex4_kern.c
+++ b/samples/bpf/tracex4_kern.c
@@ -7,8 +7,8 @@
 #include <linux/ptrace.h>
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 struct pair {
 	u64 val;
diff --git a/samples/bpf/tracex5_kern.c b/samples/bpf/tracex5_kern.c
index b3557b21a8fe..481790fde864 100644
--- a/samples/bpf/tracex5_kern.c
+++ b/samples/bpf/tracex5_kern.c
@@ -10,8 +10,8 @@
 #include <uapi/linux/seccomp.h>
 #include <uapi/linux/unistd.h>
 #include "syscall_nrs.h"
-#include "bpf_helpers.h"
-#include "bpf_tracing.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 #define PROG(F) SEC("kprobe/"__stringify(F)) int bpf_func_##F
 
diff --git a/samples/bpf/tracex6_kern.c b/samples/bpf/tracex6_kern.c
index 46c557afac73..96c234efa852 100644
--- a/samples/bpf/tracex6_kern.c
+++ b/samples/bpf/tracex6_kern.c
@@ -1,7 +1,7 @@
 #include <linux/ptrace.h>
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct bpf_map_def SEC("maps") counters = {
 	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
diff --git a/samples/bpf/tracex7_kern.c b/samples/bpf/tracex7_kern.c
index 1ab308a43e0f..c5a92df8ac31 100644
--- a/samples/bpf/tracex7_kern.c
+++ b/samples/bpf/tracex7_kern.c
@@ -1,7 +1,7 @@
 #include <uapi/linux/ptrace.h>
 #include <uapi/linux/bpf.h>
 #include <linux/version.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 SEC("kprobe/open_ctree")
 int bpf_prog1(struct pt_regs *ctx)
diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
index db6870aee42c..34b64394ed9c 100644
--- a/samples/bpf/xdp1_kern.c
+++ b/samples/bpf/xdp1_kern.c
@@ -12,7 +12,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index 38a8852cb57f..c447ad9e3a1d 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -15,8 +15,8 @@
 #include <net/if.h>
 
 #include "bpf_util.h"
-#include "bpf.h"
-#include "libbpf.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 
 static int ifindex;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index c74b52c6d945..c787f4b49646 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -12,7 +12,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
diff --git a/samples/bpf/xdp2skb_meta_kern.c b/samples/bpf/xdp2skb_meta_kern.c
index 0c12048ac79f..9b783316e860 100644
--- a/samples/bpf/xdp2skb_meta_kern.c
+++ b/samples/bpf/xdp2skb_meta_kern.c
@@ -12,7 +12,7 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/pkt_cls.h>
 
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 /*
  * This struct is stored in the XDP 'data_meta' area, which is located
diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
index 0f707e0fb375..ffdd548627f0 100644
--- a/samples/bpf/xdp_adjust_tail_kern.c
+++ b/samples/bpf/xdp_adjust_tail_kern.c
@@ -18,7 +18,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/icmp.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 #define DEFAULT_TTL 64
 #define MAX_PCKT_SIZE 600
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index 008789eb6ada..ba482dc3da33 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -19,8 +19,8 @@
 #include <netinet/ether.h>
 #include <unistd.h>
 #include <time.h>
-#include "bpf.h"
-#include "libbpf.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 
 #define STATS_INTERVAL_S 2U
 #define MAX_PCKT_SIZE 600
diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index d013029aeaa2..54c099cbd639 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -19,7 +19,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
 
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index c30f9acfdb84..74a4583d0d86 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -24,7 +24,7 @@
 #include <fcntl.h>
 #include <libgen.h>
 
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
diff --git a/samples/bpf/xdp_monitor_kern.c b/samples/bpf/xdp_monitor_kern.c
index ad10fe700d7d..59926c59ff4a 100644
--- a/samples/bpf/xdp_monitor_kern.c
+++ b/samples/bpf/xdp_monitor_kern.c
@@ -4,7 +4,7 @@
  * XDP monitor tool, based on tracepoints
  */
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct bpf_map_def SEC("maps") redirect_err_cnt = {
 	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
index cfcc31e51197..313a8fe6d125 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -12,7 +12,7 @@
 #include <uapi/linux/udp.h>
 
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "hash_func01.h"
 
 #define MAX_CPUS 64 /* WARNING - sync with _user.c */
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 79a2fb7d16cb..15bdf047a222 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -30,7 +30,7 @@ static const char *__doc__ =
 #define MAX_PROG 6
 
 #include <bpf/bpf.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 
 #include "bpf_util.h"
 
diff --git a/samples/bpf/xdp_redirect_kern.c b/samples/bpf/xdp_redirect_kern.c
index 1f0b7d05abb2..d26ec3aa215e 100644
--- a/samples/bpf/xdp_redirect_kern.c
+++ b/samples/bpf/xdp_redirect_kern.c
@@ -17,7 +17,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
index 4631b484c432..6489352ab7a4 100644
--- a/samples/bpf/xdp_redirect_map_kern.c
+++ b/samples/bpf/xdp_redirect_map_kern.c
@@ -17,7 +17,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index cc840661faab..35e16dee613e 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -17,7 +17,7 @@
 
 #include "bpf_util.h"
 #include <bpf/bpf.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 
 static int ifindex_in;
 static int ifindex_out;
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 71dff8e3382a..9ca2bf457cda 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -17,7 +17,7 @@
 
 #include "bpf_util.h"
 #include <bpf/bpf.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 
 static int ifindex_in;
 static int ifindex_out;
diff --git a/samples/bpf/xdp_router_ipv4_kern.c b/samples/bpf/xdp_router_ipv4_kern.c
index bf11efc8e949..b37ca2b13063 100644
--- a/samples/bpf/xdp_router_ipv4_kern.c
+++ b/samples/bpf/xdp_router_ipv4_kern.c
@@ -12,7 +12,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include <linux/slab.h>
 #include <net/ip_fib.h>
 
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index fef286c5add2..c2da1b51ff95 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -21,7 +21,7 @@
 #include <sys/ioctl.h>
 #include <sys/syscall.h>
 #include "bpf_util.h"
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include <sys/resource.h>
 #include <libgen.h>
 
diff --git a/samples/bpf/xdp_rxq_info_kern.c b/samples/bpf/xdp_rxq_info_kern.c
index 272d0f82a6b5..5e7459f9bf3e 100644
--- a/samples/bpf/xdp_rxq_info_kern.c
+++ b/samples/bpf/xdp_rxq_info_kern.c
@@ -6,7 +6,7 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/in.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 /* Config setup from with userspace
  *
diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index fc4983fd6959..4fe47502ebed 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -22,8 +22,8 @@ static const char *__doc__ = " XDP RX-queue info extract example\n\n"
 #include <arpa/inet.h>
 #include <linux/if_link.h>
 
-#include "bpf.h"
-#include "libbpf.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 #include "bpf_util.h"
 
 static int ifindex = -1;
diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
index 6c7c7e0aaeda..33377289e2a8 100644
--- a/samples/bpf/xdp_sample_pkts_kern.c
+++ b/samples/bpf/xdp_sample_pkts_kern.c
@@ -2,7 +2,7 @@
 #include <linux/ptrace.h>
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 
 #define SAMPLE_SIZE 64ul
 #define MAX_CPUS 128
diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
index 8c1af1b7372d..991ef6f0880b 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -10,7 +10,7 @@
 #include <sys/sysinfo.h>
 #include <sys/ioctl.h>
 #include <signal.h>
-#include <libbpf.h>
+#include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 #include <sys/resource.h>
 #include <libgen.h>
diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
index 6db450a5c1ca..575d57e4b8d6 100644
--- a/samples/bpf/xdp_tx_iptunnel_kern.c
+++ b/samples/bpf/xdp_tx_iptunnel_kern.c
@@ -16,7 +16,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "xdp_tx_iptunnel_common.h"
 
 struct {
diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptunnel_user.c
index 5f33b5530032..a419bee151a8 100644
--- a/samples/bpf/xdp_tx_iptunnel_user.c
+++ b/samples/bpf/xdp_tx_iptunnel_user.c
@@ -15,7 +15,7 @@
 #include <netinet/ether.h>
 #include <unistd.h>
 #include <time.h>
-#include "libbpf.h"
+#include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 #include "bpf_util.h"
 #include "xdp_tx_iptunnel_common.h"
diff --git a/samples/bpf/xdpsock_kern.c b/samples/bpf/xdpsock_kern.c
index a06177c262cd..05430484375c 100644
--- a/samples/bpf/xdpsock_kern.c
+++ b/samples/bpf/xdpsock_kern.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/bpf.h>
-#include "bpf_helpers.h"
+#include <bpf/bpf_helpers.h>
 #include "xdpsock.h"
 
 /* This XDP program is only needed for the XDP_SHARED_UMEM mode.
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index d74c4c83fc93..0b5acd722306 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -30,10 +30,10 @@
 #include <time.h>
 #include <unistd.h>
 
-#include "libbpf.h"
-#include "xsk.h"
-#include "xdpsock.h"
+#include <bpf/libbpf.h>
+#include <bpf/xsk.h>
 #include <bpf/bpf.h>
+#include "xdpsock.h"
 
 #ifndef SOL_XDP
 #define SOL_XDP 283

