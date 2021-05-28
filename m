Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C156239494B
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhE1Xz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhE1Xz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:26 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A40C061574;
        Fri, 28 May 2021 16:53:51 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q6so3439746pjj.2;
        Fri, 28 May 2021 16:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RXhVruWbOeNtku5rCwmtjRr9+FG/vhtYR9nyp4K1kC8=;
        b=K1T/Kri8XuHRsPho3xjuDQH8rijjRfDHlJUxAJf/A/F6JLK9y4SeIiL260kFAlVj4o
         dFzU1UTqTrRnUv6R7u5prpdb9ec/JOYQOT4ocoBwuzuMsdXpusKwiiQK2WS8BeAa5biM
         nvnbSvGJI6ptO0/3rhjf23jHVPbs9HQySscq44IPvIJ3vA92j7MfsWnnI5x26G5kd8qY
         OhcdjPT4eGhIl7rztLcCd+KM05LS2mAGSGaOsCwFQ9jRwAvdQ+dHAPZ3K6sEkPQ4D7E0
         0TXWVZ2C91U9CrVmwMDrfDWkXLR0Mdkz284KPIXvHTTroPv65qPOZ7C9P2+OWyBR8y9I
         YdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RXhVruWbOeNtku5rCwmtjRr9+FG/vhtYR9nyp4K1kC8=;
        b=LF3gSbv/ky5G0AnqvFt/SprshaH1otSt2Wb4+8UZJLxgsIkZ/e6mk0OyDaov24LRv3
         f5qq97AwC8TShhTlYLBylJbZbs0cSQBrbFj1hhSZNtWD0y9aK6bg7QW0a9ZVxmq3eaXZ
         U1ZVuec3b9mBKR0MtaC537ZA17MgnorgL1foeUske6GEJF9kt4asm3q+BBK+MxFdSUFc
         BixYeu5IbtwnYlg/IeLzuEk1LB2e5o6ueRIcRa7GcLhPsxGHQNG9LZaRj6i265d5qndN
         C9LOXU7jPyhCpMcn2YSvlTGXUpmHWzriRzn0IFt9QRMMH2NDnSJj1ZblEs0BD2P5qWf3
         sjwg==
X-Gm-Message-State: AOAM531CnPsx5t9EHpS6RfEmARfjedrgOsI8laeGFoXSnMocprcOuxqU
        WOVoU/4HMpbWllLyM45j0INkVUttwsc=
X-Google-Smtp-Source: ABdhPJwXnjPmXqj+SvmEpggqbk0WhGlChuhvM+iB9rpWu1WPIuKhb08Bq2x8wzYW4Yf775jbeajj2A==
X-Received: by 2002:a17:90a:db51:: with SMTP id u17mr7071539pjx.222.1622246030060;
        Fri, 28 May 2021 16:53:50 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id g72sm5092724pfb.33.2021.05.28.16.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:53:49 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 04/15] samples: bpf: refactor generic parts out of xdp_redirect_cpu_user
Date:   Sat, 29 May 2021 05:22:39 +0530
Message-Id: <20210528235250.2635167-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used as a common core for multiple samples.

Also add a couple of helpers:
get_driver_name - Used to print the driver name for ifindex
get_mac_addr - Used to get the mac address for ifindex

This change also converts xdp_redirect_cpu to use the new xdp_sample
helpers.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                |   2 +-
 samples/bpf/xdp_redirect_cpu_kern.c | 213 +---------
 samples/bpf/xdp_redirect_cpu_user.c | 560 ++------------------------
 samples/bpf/xdp_sample_user.c       | 588 ++++++++++++++++++++++++++++
 samples/bpf/xdp_sample_user.h       | 101 +++++
 5 files changed, 730 insertions(+), 734 deletions(-)
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 520434ea966f..c0c02e12e28b 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -101,7 +101,7 @@ per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
-xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
+xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o xdp_sample_user.o
 xdp_monitor-objs := xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
index 8255025dea97..06cc37f0289c 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -14,6 +14,7 @@
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include "hash_func01.h"
+#include "xdp_sample_kern.h"
 
 #define MAX_CPUS NR_CPUS
 
@@ -25,51 +26,6 @@ struct {
 	__uint(max_entries, MAX_CPUS);
 } cpu_map SEC(".maps");
 
-/* Common stats data record to keep userspace more simple */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 issue;
-	__u64 xdp_pass;
-	__u64 xdp_drop;
-	__u64 xdp_redirect;
-};
-
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} rx_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 2);
-	/* TODO: have entries for all possible errno's */
-} redirect_err_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, MAX_CPUS);
-} cpumap_enqueue_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} cpumap_kthread_cnt SEC(".maps");
-
 /* Set of maps controlling available CPU, and for iterating through
  * selectable redirect CPUs.
  */
@@ -92,14 +48,6 @@ struct {
 	__uint(max_entries, 1);
 } cpus_iterator SEC(".maps");
 
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} exception_cnt SEC(".maps");
-
 /* Helper parse functions */
 
 /* Parse Ethernet layer 2, extract network layer 3 offset and protocol
@@ -569,162 +517,3 @@ int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
 }
 
 char _license[] SEC("license") = "GPL";
-
-/*** Trace point code ***/
-
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_redirect_ctx {
-	u64 __pad;	// First 8 bytes are not accessible by bpf code
-	int prog_id;	//	offset:8;  size:4; signed:1;
-	u32 act;	//	offset:12  size:4; signed:0;
-	int ifindex;	//	offset:16  size:4; signed:1;
-	int err;	//	offset:20  size:4; signed:1;
-	int to_ifindex;	//	offset:24  size:4; signed:1;
-	u32 map_id;	//	offset:28  size:4; signed:0;
-	int map_index;	//	offset:32  size:4; signed:1;
-};			//	offset:36
-
-enum {
-	XDP_REDIRECT_SUCCESS = 0,
-	XDP_REDIRECT_ERROR = 1
-};
-
-static __always_inline
-int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
-{
-	u32 key = XDP_REDIRECT_ERROR;
-	struct datarec *rec;
-	int err = ctx->err;
-
-	if (!err)
-		key = XDP_REDIRECT_SUCCESS;
-
-	rec = bpf_map_lookup_elem(&redirect_err_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->dropped += 1;
-
-	return 0; /* Indicate event was filtered (no further processing)*/
-	/*
-	 * Returning 1 here would allow e.g. a perf-record tracepoint
-	 * to see and record these events, but it doesn't work well
-	 * in-practice as stopping perf-record also unload this
-	 * bpf_prog.  Plus, there is additional overhead of doing so.
-	 */
-}
-
-SEC("tracepoint/xdp/xdp_redirect_err")
-int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-SEC("tracepoint/xdp/xdp_redirect_map_err")
-int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_exception/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_exception_ctx {
-	u64 __pad;	// First 8 bytes are not accessible by bpf code
-	int prog_id;	//	offset:8;  size:4; signed:1;
-	u32 act;	//	offset:12; size:4; signed:0;
-	int ifindex;	//	offset:16; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_exception")
-int trace_xdp_exception(struct xdp_exception_ctx *ctx)
-{
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&exception_cnt, &key);
-	if (!rec)
-		return 1;
-	rec->dropped += 1;
-
-	return 0;
-}
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_enqueue/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_enqueue_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int map_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int cpu;		//	offset:16; size:4; signed:1;
-	unsigned int drops;	//	offset:20; size:4; signed:0;
-	unsigned int processed;	//	offset:24; size:4; signed:0;
-	int to_cpu;		//	offset:28; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_cpumap_enqueue")
-int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
-{
-	u32 to_cpu = ctx->to_cpu;
-	struct datarec *rec;
-
-	if (to_cpu >= MAX_CPUS)
-		return 1;
-
-	rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &to_cpu);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-
-	/* Record bulk events, then userspace can calc average bulk size */
-	if (ctx->processed > 0)
-		rec->issue += 1;
-
-	/* Inception: It's possible to detect overload situations, via
-	 * this tracepoint.  This can be used for creating a feedback
-	 * loop to XDP, which can take appropriate actions to mitigate
-	 * this overload situation.
-	 */
-	return 0;
-}
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_kthread/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_kthread_ctx {
-	u64 __pad;			// First 8 bytes are not accessible
-	int map_id;			//	offset:8;  size:4; signed:1;
-	u32 act;			//	offset:12; size:4; signed:0;
-	int cpu;			//	offset:16; size:4; signed:1;
-	unsigned int drops;		//	offset:20; size:4; signed:0;
-	unsigned int processed;		//	offset:24; size:4; signed:0;
-	int sched;			//	offset:28; size:4; signed:1;
-	unsigned int xdp_pass;		//	offset:32; size:4; signed:0;
-	unsigned int xdp_drop;		//	offset:36; size:4; signed:0;
-	unsigned int xdp_redirect;	//	offset:40; size:4; signed:0;
-};
-
-SEC("tracepoint/xdp/xdp_cpumap_kthread")
-int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
-{
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&cpumap_kthread_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-	rec->xdp_pass  += ctx->xdp_pass;
-	rec->xdp_drop  += ctx->xdp_drop;
-	rec->xdp_redirect  += ctx->xdp_redirect;
-
-	/* Count times kthread yielded CPU via schedule call */
-	if (ctx->sched)
-		rec->issue++;
-
-	return 0;
-}
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 576411612523..6dbed962a2e2 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -22,59 +22,21 @@ static const char *__doc__ =
 #include <arpa/inet.h>
 #include <linux/if_link.h>
 
-/* How many xdp_progs are defined in _kern.c */
-#define MAX_PROG 6
-
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
 #include "bpf_util.h"
+#include "xdp_sample_user.h"
 
 static int ifindex = -1;
 static char ifname_buf[IF_NAMESIZE];
 static char *ifname;
 static __u32 prog_id;
+static int map_fd;
+static int avail_fd;
+static int count_fd;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-static int n_cpus;
-
-enum map_type {
-	CPU_MAP,
-	RX_CNT,
-	REDIRECT_ERR_CNT,
-	CPUMAP_ENQUEUE_CNT,
-	CPUMAP_KTHREAD_CNT,
-	CPUS_AVAILABLE,
-	CPUS_COUNT,
-	CPUS_ITERATOR,
-	EXCEPTION_CNT,
-};
-
-static const char *const map_type_strings[] = {
-	[CPU_MAP] = "cpu_map",
-	[RX_CNT] = "rx_cnt",
-	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
-	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
-	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
-	[CPUS_AVAILABLE] = "cpus_available",
-	[CPUS_COUNT] = "cpus_count",
-	[CPUS_ITERATOR] = "cpus_iterator",
-	[EXCEPTION_CNT] = "exception_cnt",
-};
-
-#define NUM_TP 5
-#define NUM_MAP 9
-struct bpf_link *tp_links[NUM_TP] = {};
-static int map_fds[NUM_MAP];
-static int tp_cnt = 0;
-
-/* Exit return codes */
-#define EXIT_OK		0
-#define EXIT_FAIL		1
-#define EXIT_FAIL_OPTION	2
-#define EXIT_FAIL_XDP		3
-#define EXIT_FAIL_BPF		4
-#define EXIT_FAIL_MEM		5
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -115,11 +77,8 @@ static void int_exit(int sig)
 			printf("program on interface changed, not removing\n");
 		}
 	}
-	/* Detach tracepoints */
-	while (tp_cnt)
-		bpf_link__destroy(tp_links[--tp_cnt]);
 
-	exit(EXIT_OK);
+	sample_exit(EXIT_OK);
 }
 
 static void print_avail_progs(struct bpf_object *obj)
@@ -155,423 +114,6 @@ static void usage(char *argv[], struct bpf_object *obj)
 	printf("\n");
 }
 
-/* gettime returns the current time of day in nanoseconds.
- * Cost: clock_gettime (ns) => 26ns (CLOCK_MONOTONIC)
- *       clock_gettime (ns) =>  9ns (CLOCK_MONOTONIC_COARSE)
- */
-#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
-static __u64 gettime(void)
-{
-	struct timespec t;
-	int res;
-
-	res = clock_gettime(CLOCK_MONOTONIC, &t);
-	if (res < 0) {
-		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
-		exit(EXIT_FAIL);
-	}
-	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
-}
-
-/* Common stats data record shared with _kern.c */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 issue;
-	__u64 xdp_pass;
-	__u64 xdp_drop;
-	__u64 xdp_redirect;
-};
-struct record {
-	__u64 timestamp;
-	struct datarec total;
-	struct datarec *cpu;
-};
-struct stats_record {
-	struct record rx_cnt;
-	struct record redir_err;
-	struct record kthread;
-	struct record exception;
-	struct record enq[];
-};
-
-static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
-{
-	/* For percpu maps, userspace gets a value per possible CPU */
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec values[nr_cpus];
-	__u64 sum_xdp_redirect = 0;
-	__u64 sum_xdp_pass = 0;
-	__u64 sum_xdp_drop = 0;
-	__u64 sum_processed = 0;
-	__u64 sum_dropped = 0;
-	__u64 sum_issue = 0;
-	int i;
-
-	if ((bpf_map_lookup_elem(fd, &key, values)) != 0) {
-		fprintf(stderr,
-			"ERR: bpf_map_lookup_elem failed key:0x%X\n", key);
-		return false;
-	}
-	/* Get time as close as possible to reading map contents */
-	rec->timestamp = gettime();
-
-	/* Record and sum values from each CPU */
-	for (i = 0; i < nr_cpus; i++) {
-		rec->cpu[i].processed = values[i].processed;
-		sum_processed        += values[i].processed;
-		rec->cpu[i].dropped = values[i].dropped;
-		sum_dropped        += values[i].dropped;
-		rec->cpu[i].issue = values[i].issue;
-		sum_issue        += values[i].issue;
-		rec->cpu[i].xdp_pass = values[i].xdp_pass;
-		sum_xdp_pass += values[i].xdp_pass;
-		rec->cpu[i].xdp_drop = values[i].xdp_drop;
-		sum_xdp_drop += values[i].xdp_drop;
-		rec->cpu[i].xdp_redirect = values[i].xdp_redirect;
-		sum_xdp_redirect += values[i].xdp_redirect;
-	}
-	rec->total.processed = sum_processed;
-	rec->total.dropped   = sum_dropped;
-	rec->total.issue     = sum_issue;
-	rec->total.xdp_pass  = sum_xdp_pass;
-	rec->total.xdp_drop  = sum_xdp_drop;
-	rec->total.xdp_redirect = sum_xdp_redirect;
-	return true;
-}
-
-static struct datarec *alloc_record_per_cpu(void)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec *array;
-
-	array = calloc(nr_cpus, sizeof(struct datarec));
-	if (!array) {
-		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
-		exit(EXIT_FAIL_MEM);
-	}
-	return array;
-}
-
-static struct stats_record *alloc_stats_record(void)
-{
-	struct stats_record *rec;
-	int i, size;
-
-	size = sizeof(*rec) + n_cpus * sizeof(struct record);
-	rec = malloc(size);
-	if (!rec) {
-		fprintf(stderr, "Mem alloc error\n");
-		exit(EXIT_FAIL_MEM);
-	}
-	memset(rec, 0, size);
-	rec->rx_cnt.cpu    = alloc_record_per_cpu();
-	rec->redir_err.cpu = alloc_record_per_cpu();
-	rec->kthread.cpu   = alloc_record_per_cpu();
-	rec->exception.cpu = alloc_record_per_cpu();
-	for (i = 0; i < n_cpus; i++)
-		rec->enq[i].cpu = alloc_record_per_cpu();
-
-	return rec;
-}
-
-static void free_stats_record(struct stats_record *r)
-{
-	int i;
-
-	for (i = 0; i < n_cpus; i++)
-		free(r->enq[i].cpu);
-	free(r->exception.cpu);
-	free(r->kthread.cpu);
-	free(r->redir_err.cpu);
-	free(r->rx_cnt.cpu);
-	free(r);
-}
-
-static double calc_period(struct record *r, struct record *p)
-{
-	double period_ = 0;
-	__u64 period = 0;
-
-	period = r->timestamp - p->timestamp;
-	if (period > 0)
-		period_ = ((double) period / NANOSEC_PER_SEC);
-
-	return period_;
-}
-
-static __u64 calc_pps(struct datarec *r, struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->processed - p->processed;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static __u64 calc_drop_pps(struct datarec *r, struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->dropped - p->dropped;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static __u64 calc_errs_pps(struct datarec *r,
-			    struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->issue - p->issue;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static void calc_xdp_pps(struct datarec *r, struct datarec *p,
-			 double *xdp_pass, double *xdp_drop,
-			 double *xdp_redirect, double period_)
-{
-	*xdp_pass = 0, *xdp_drop = 0, *xdp_redirect = 0;
-	if (period_ > 0) {
-		*xdp_redirect = (r->xdp_redirect - p->xdp_redirect) / period_;
-		*xdp_pass = (r->xdp_pass - p->xdp_pass) / period_;
-		*xdp_drop = (r->xdp_drop - p->xdp_drop) / period_;
-	}
-}
-
-static void stats_print(struct stats_record *stats_rec,
-			struct stats_record *stats_prev,
-			char *prog_name, char *mprog_name, int mprog_fd)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	double pps = 0, drop = 0, err = 0;
-	bool mprog_enabled = false;
-	struct record *rec, *prev;
-	int to_cpu;
-	double t;
-	int i;
-
-	if (mprog_fd > 0)
-		mprog_enabled = true;
-
-	/* Header */
-	printf("Running XDP/eBPF prog_name:%s\n", prog_name);
-	printf("%-15s %-7s %-14s %-11s %-9s\n",
-	       "XDP-cpumap", "CPU:to", "pps", "drop-pps", "extra-info");
-
-	/* XDP rx_cnt */
-	{
-		char *fmt_rx = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *fm2_rx = "%-15s %-7s %'-14.0f %'-11.0f\n";
-		char *errstr = "";
-
-		rec  = &stats_rec->rx_cnt;
-		prev = &stats_prev->rx_cnt;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0)
-				errstr = "cpu-dest/err";
-			if (pps > 0)
-				printf(fmt_rx, "XDP-RX",
-					i, pps, drop, err, errstr);
-		}
-		pps  = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		err  = calc_errs_pps(&rec->total, &prev->total, t);
-		printf(fm2_rx, "XDP-RX", "total", pps, drop);
-	}
-
-	/* cpumap enqueue stats */
-	for (to_cpu = 0; to_cpu < n_cpus; to_cpu++) {
-		char *fmt = "%-15s %3d:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *fm2 = "%-15s %3s:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *errstr = "";
-
-		rec  =  &stats_rec->enq[to_cpu];
-		prev = &stats_prev->enq[to_cpu];
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0) {
-				errstr = "bulk-average";
-				err = pps / err; /* calc average bulk size */
-			}
-			if (pps > 0)
-				printf(fmt, "cpumap-enqueue",
-				       i, to_cpu, pps, drop, err, errstr);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		if (pps > 0) {
-			drop = calc_drop_pps(&rec->total, &prev->total, t);
-			err  = calc_errs_pps(&rec->total, &prev->total, t);
-			if (err > 0) {
-				errstr = "bulk-average";
-				err = pps / err; /* calc average bulk size */
-			}
-			printf(fm2, "cpumap-enqueue",
-			       "sum", to_cpu, pps, drop, err, errstr);
-		}
-	}
-
-	/* cpumap kthread stats */
-	{
-		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *e_str = "";
-
-		rec  = &stats_rec->kthread;
-		prev = &stats_prev->kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0)
-				e_str = "sched";
-			if (pps > 0)
-				printf(fmt_k, "cpumap_kthread",
-				       i, pps, drop, err, e_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		err  = calc_errs_pps(&rec->total, &prev->total, t);
-		if (err > 0)
-			e_str = "sched-sum";
-		printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
-	}
-
-	/* XDP redirect err tracepoints (very unlikely) */
-	{
-		char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-		char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
-
-		rec  = &stats_rec->redir_err;
-		prev = &stats_prev->redir_err;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			if (pps > 0)
-				printf(fmt_err, "redirect_err", i, pps, drop);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		printf(fm2_err, "redirect_err", "total", pps, drop);
-	}
-
-	/* XDP general exception tracepoints */
-	{
-		char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-		char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
-
-		rec  = &stats_rec->exception;
-		prev = &stats_prev->exception;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			if (pps > 0)
-				printf(fmt_err, "xdp_exception", i, pps, drop);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		printf(fm2_err, "xdp_exception", "total", pps, drop);
-	}
-
-	/* CPUMAP attached XDP program that runs on remote/destination CPU */
-	if (mprog_enabled) {
-		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f\n";
-		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f\n";
-		double xdp_pass, xdp_drop, xdp_redirect;
-
-		printf("\n2nd remote XDP/eBPF prog_name: %s\n", mprog_name);
-		printf("%-15s %-7s %-14s %-11s %-9s\n",
-		       "XDP-cpumap", "CPU:to", "xdp-pass", "xdp-drop", "xdp-redir");
-
-		rec  = &stats_rec->kthread;
-		prev = &stats_prev->kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			calc_xdp_pps(r, p, &xdp_pass, &xdp_drop,
-				     &xdp_redirect, t);
-			if (xdp_pass > 0 || xdp_drop > 0 || xdp_redirect > 0)
-				printf(fmt_k, "xdp-in-kthread", i, xdp_pass, xdp_drop,
-				       xdp_redirect);
-		}
-		calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
-			     &xdp_redirect, t);
-		printf(fm2_k, "xdp-in-kthread", "total", xdp_pass, xdp_drop, xdp_redirect);
-	}
-
-	printf("\n");
-	fflush(stdout);
-}
-
-static void stats_collect(struct stats_record *rec)
-{
-	int fd, i;
-
-	fd = map_fds[RX_CNT];
-	map_collect_percpu(fd, 0, &rec->rx_cnt);
-
-	fd = map_fds[REDIRECT_ERR_CNT];
-	map_collect_percpu(fd, 1, &rec->redir_err);
-
-	fd = map_fds[CPUMAP_ENQUEUE_CNT];
-	for (i = 0; i < n_cpus; i++)
-		map_collect_percpu(fd, i, &rec->enq[i]);
-
-	fd = map_fds[CPUMAP_KTHREAD_CNT];
-	map_collect_percpu(fd, 0, &rec->kthread);
-
-	fd = map_fds[EXCEPTION_CNT];
-	map_collect_percpu(fd, 0, &rec->exception);
-}
-
-
-/* Pointer swap trick */
-static inline void swap(struct stats_record **a, struct stats_record **b)
-{
-	struct stats_record *tmp;
-
-	tmp = *a;
-	*a = *b;
-	*b = tmp;
-}
-
 static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 			    __u32 avail_idx, bool new)
 {
@@ -579,10 +121,11 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 	__u32 key = 0;
 	int ret;
 
+	/* Update to bpf_skel */
 	/* Add a CPU entry to cpumap, as this allocate a cpu entry in
 	 * the kernel for the cpu.
 	 */
-	ret = bpf_map_update_elem(map_fds[CPU_MAP], &cpu, value, 0);
+	ret = bpf_map_update_elem(map_fd, &cpu, value, 0);
 	if (ret) {
 		fprintf(stderr, "Create CPU entry failed (err:%d)\n", ret);
 		exit(EXIT_FAIL_BPF);
@@ -591,21 +134,21 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 	/* Inform bpf_prog's that a new CPU is available to select
 	 * from via some control maps.
 	 */
-	ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &avail_idx, &cpu, 0);
+	ret = bpf_map_update_elem(avail_fd, &avail_idx, &cpu, 0);
 	if (ret) {
 		fprintf(stderr, "Add to avail CPUs failed\n");
 		exit(EXIT_FAIL_BPF);
 	}
 
 	/* When not replacing/updating existing entry, bump the count */
-	ret = bpf_map_lookup_elem(map_fds[CPUS_COUNT], &key, &curr_cpus_count);
+	ret = bpf_map_lookup_elem(count_fd, &key, &curr_cpus_count);
 	if (ret) {
 		fprintf(stderr, "Failed reading curr cpus_count\n");
 		exit(EXIT_FAIL_BPF);
 	}
 	if (new) {
 		curr_cpus_count++;
-		ret = bpf_map_update_elem(map_fds[CPUS_COUNT], &key,
+		ret = bpf_map_update_elem(count_fd, &key,
 					  &curr_cpus_count, 0);
 		if (ret) {
 			fprintf(stderr, "Failed write curr cpus_count\n");
@@ -629,7 +172,7 @@ static void mark_cpus_unavailable(void)
 	int ret, i;
 
 	for (i = 0; i < n_cpus; i++) {
-		ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &i,
+		ret = bpf_map_update_elem(avail_fd, &i,
 					  &invalid_cpu, 0);
 		if (ret) {
 			fprintf(stderr, "Failed marking CPU unavailable\n");
@@ -653,26 +196,33 @@ static void stress_cpumap(struct bpf_cpumap_val *value)
 	create_cpu_entry(1, value, 0, false);
 }
 
-static void stats_poll(int interval, bool use_separators, char *prog_name,
-		       char *mprog_name, struct bpf_cpumap_val *value,
-		       bool stress_mode)
+static void __stats_poll(int interval, bool use_separators, char *prog_name,
+			 char *mprog_name, struct bpf_cpumap_val *value,
+			 bool stress_mode)
 {
+	int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_CNT |
+		   SAMPLE_CPUMAP_ENQUEUE_CNT | SAMPLE_CPUMAP_KTHREAD_CNT |
+		   SAMPLE_EXCEPTION_CNT;
 	struct stats_record *record, *prev;
-	int mprog_fd;
 
 	record = alloc_stats_record();
 	prev   = alloc_stats_record();
-	stats_collect(record);
+	sample_stats_collect(mask, record);
 
 	/* Trick to pretty printf with thousands separators use %' */
 	if (use_separators)
 		setlocale(LC_NUMERIC, "en_US");
 
-	while (1) {
+	for (;;) {
 		swap(&prev, &record);
-		mprog_fd = value->bpf_prog.fd;
-		stats_collect(record);
-		stats_print(record, prev, prog_name, mprog_name, mprog_fd);
+		sample_stats_collect(mask, record);
+		sample_stats_print(mask, record, prev, prog_name);
+		/* Depends on SAMPLE_CPUMAP_KTHREAD_CNT */
+		sample_stats_print_cpumap_remote(record, prev,
+						 bpf_num_possible_cpus(),
+						 mprog_name);
+		printf("\n");
+		fflush(stdout);
 		sleep(interval);
 		if (stress_mode)
 			stress_cpumap(value);
@@ -682,41 +232,6 @@ static void stats_poll(int interval, bool use_separators, char *prog_name,
 	free_stats_record(prev);
 }
 
-static int init_tracepoints(struct bpf_object *obj)
-{
-	struct bpf_program *prog;
-
-	bpf_object__for_each_program(prog, obj) {
-		if (bpf_program__is_tracepoint(prog) != true)
-			continue;
-
-		tp_links[tp_cnt] = bpf_program__attach(prog);
-		if (libbpf_get_error(tp_links[tp_cnt])) {
-			tp_links[tp_cnt] = NULL;
-			return -EINVAL;
-		}
-		tp_cnt++;
-	}
-
-	return 0;
-}
-
-static int init_map_fds(struct bpf_object *obj)
-{
-	enum map_type type;
-
-	for (type = 0; type < NUM_MAP; type++) {
-		map_fds[type] =
-			bpf_object__find_map_fd_by_name(obj,
-							map_type_strings[type]);
-
-		if (map_fds[type] < 0)
-			return -ENOENT;
-	}
-
-	return 0;
-}
-
 static int load_cpumap_prog(char *file_name, char *prog_name,
 			    char *redir_interface, char *redir_map)
 {
@@ -790,8 +305,6 @@ int main(int argc, char **argv)
 	int *cpu, i;
 	__u32 qsize;
 
-	n_cpus = get_nprocs_conf();
-
 	/* Notice: choosing he queue size is very important with the
 	 * ixgbe driver, because it's driver page recycling trick is
 	 * dependend on pages being returned quickly.  The number of
@@ -812,15 +325,20 @@ int main(int argc, char **argv)
 		return err;
 	}
 
-	if (init_tracepoints(obj) < 0) {
-		fprintf(stderr, "ERR: bpf_program__attach failed\n");
+	if (sample_init(obj) < 0) {
+		fprintf(stderr, "ERR: Failed to initialize sample\n");
 		return err;
 	}
 
-	if (init_map_fds(obj) < 0) {
-		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
-		return err;
+	map_fd = bpf_object__find_map_fd_by_name(obj, "cpu_map");
+	avail_fd = bpf_object__find_map_fd_by_name(obj, "cpus_available");
+	count_fd = bpf_object__find_map_fd_by_name(obj, "cpus_count");
+
+	if (map_fd < 0 || avail_fd < 0 || count_fd < 0) {
+		fprintf(stderr, "failed to find map\n");
+		return EXIT_FAIL;
 	}
+
 	mark_cpus_unavailable();
 
 	cpu = malloc(n_cpus * sizeof(int));
@@ -967,8 +485,8 @@ int main(int argc, char **argv)
 	}
 	prog_id = info.id;
 
-	stats_poll(interval, use_separators, prog_name, mprog_name,
-		   &value, stress_mode);
+	__stats_poll(interval, use_separators, prog_name, mprog_name,
+		     &value, stress_mode);
 
 	err = EXIT_OK;
 out:
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
new file mode 100644
index 000000000000..be60fbddd8c7
--- /dev/null
+++ b/samples/bpf/xdp_sample_user.c
@@ -0,0 +1,588 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
+ */
+
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <locale.h>
+#include <sys/resource.h>
+#include <sys/sysinfo.h>
+#include <getopt.h>
+#include <net/if.h>
+#include <time.h>
+#include <linux/limits.h>
+#include <sys/ioctl.h>
+#include <net/if.h>
+#include <linux/ethtool.h>
+#include <linux/sockios.h>
+#ifndef SIOCETHTOOL
+#define SIOCETHTOOL 0x8946
+#endif
+
+#include <arpa/inet.h>
+#include <linux/if_link.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_util.h"
+#include "xdp_sample_user.h"
+
+struct bpf_link *tp_links[NUM_TP] = {};
+int map_fds[NUM_MAP], tp_cnt, n_cpus;
+
+#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
+static __u64 gettime(void)
+{
+	struct timespec t;
+	int res;
+
+	res = clock_gettime(CLOCK_MONOTONIC, &t);
+	if (res < 0) {
+		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
+		exit(EXIT_FAIL);
+	}
+	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
+}
+
+static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
+{
+	/* For percpu maps, userspace gets a value per possible CPU */
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	struct datarec values[nr_cpus];
+	__u64 sum_xdp_redirect = 0;
+	__u64 sum_xdp_pass = 0;
+	__u64 sum_xdp_drop = 0;
+	__u64 sum_processed = 0;
+	__u64 sum_dropped = 0;
+	__u64 sum_issue = 0;
+	int i;
+
+	if ((bpf_map_lookup_elem(fd, &key, values)) != 0) {
+		fprintf(stderr,
+			"ERR: bpf_map_lookup_elem failed key:0x%X\n", key);
+		return false;
+	}
+	/* Get time as close as possible to reading map contents */
+	rec->timestamp = gettime();
+
+	/* Record and sum values from each CPU */
+	for (i = 0; i < nr_cpus; i++) {
+		rec->cpu[i].processed = values[i].processed;
+		sum_processed        += values[i].processed;
+		rec->cpu[i].dropped = values[i].dropped;
+		sum_dropped        += values[i].dropped;
+		rec->cpu[i].issue = values[i].issue;
+		sum_issue        += values[i].issue;
+		rec->cpu[i].xdp_pass = values[i].xdp_pass;
+		sum_xdp_pass += values[i].xdp_pass;
+		rec->cpu[i].xdp_drop = values[i].xdp_drop;
+		sum_xdp_drop += values[i].xdp_drop;
+		rec->cpu[i].xdp_redirect = values[i].xdp_redirect;
+		sum_xdp_redirect += values[i].xdp_redirect;
+	}
+	rec->total.processed = sum_processed;
+	rec->total.dropped   = sum_dropped;
+	rec->total.issue     = sum_issue;
+	rec->total.xdp_pass  = sum_xdp_pass;
+	rec->total.xdp_drop  = sum_xdp_drop;
+	rec->total.xdp_redirect = sum_xdp_redirect;
+	return true;
+}
+
+static struct datarec *alloc_record_per_cpu(void)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	struct datarec *array;
+
+	array = calloc(nr_cpus, sizeof(struct datarec));
+	if (!array) {
+		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
+		exit(EXIT_FAIL_MEM);
+	}
+	return array;
+}
+
+struct stats_record *alloc_stats_record(void)
+{
+	struct stats_record *rec;
+	int i, size;
+
+	size = sizeof(*rec) + n_cpus * sizeof(struct record);
+	rec = malloc(size);
+	if (!rec) {
+		fprintf(stderr, "Mem alloc error\n");
+		exit(EXIT_FAIL_MEM);
+	}
+	memset(rec, 0, size);
+	rec->rx_cnt.cpu    = alloc_record_per_cpu();
+	rec->redir_err.cpu = alloc_record_per_cpu();
+	rec->kthread.cpu   = alloc_record_per_cpu();
+	rec->exception.cpu = alloc_record_per_cpu();
+	for (i = 0; i < n_cpus; i++)
+		rec->enq[i].cpu = alloc_record_per_cpu();
+
+	return rec;
+}
+
+void free_stats_record(struct stats_record *r)
+{
+	int i;
+
+	for (i = 0; i < n_cpus; i++)
+		free(r->enq[i].cpu);
+	free(r->exception.cpu);
+	free(r->kthread.cpu);
+	free(r->redir_err.cpu);
+	free(r->rx_cnt.cpu);
+	free(r);
+}
+
+static double calc_period(struct record *r, struct record *p)
+{
+	double period_ = 0;
+	__u64 period = 0;
+
+	period = r->timestamp - p->timestamp;
+	if (period > 0)
+		period_ = ((double) period / NANOSEC_PER_SEC);
+
+	return period_;
+}
+
+static __u64 calc_pps(struct datarec *r, struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->processed - p->processed;
+		pps = packets / period_;
+	}
+	return pps;
+}
+
+static __u64 calc_drop_pps(struct datarec *r, struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->dropped - p->dropped;
+		pps = packets / period_;
+	}
+	return pps;
+}
+
+static __u64 calc_errs_pps(struct datarec *r,
+			    struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->issue - p->issue;
+		pps = packets / period_;
+	}
+	return pps;
+}
+
+static void calc_xdp_pps(struct datarec *r, struct datarec *p,
+			 double *xdp_pass, double *xdp_drop,
+			 double *xdp_redirect, double period_)
+{
+	*xdp_pass = 0, *xdp_drop = 0, *xdp_redirect = 0;
+	if (period_ > 0) {
+		*xdp_redirect = (r->xdp_redirect - p->xdp_redirect) / period_;
+		*xdp_pass = (r->xdp_pass - p->xdp_pass) / period_;
+		*xdp_drop = (r->xdp_drop - p->xdp_drop) / period_;
+	}
+}
+
+static void stats_print_rx_cnt(struct stats_record *stats_rec,
+			       struct stats_record *stats_prev,
+			       unsigned int nr_cpus)
+{
+	char *fmt_rx = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
+	char *fm2_rx = "%-15s %-7s %'-14.0f %'-11.0f\n";
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	char *errstr = "";
+	int i;
+
+	rec = &stats_rec->rx_cnt;
+	prev = &stats_prev->rx_cnt;
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+
+		pps = calc_pps(r, p, t);
+		drop = calc_drop_pps(r, p, t);
+		err = calc_errs_pps(r, p, t);
+		if (err > 0)
+			errstr = "cpu-dest/err";
+		if (pps > 0)
+			printf(fmt_rx, "XDP-RX", i, pps, drop, err, errstr);
+	}
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	err = calc_errs_pps(&rec->total, &prev->total, t);
+	printf(fm2_rx, "XDP-RX", "total", pps, drop);
+}
+
+static void stats_print_cpumap_enqueue(struct stats_record *stats_rec,
+				       struct stats_record *stats_prev,
+				       unsigned int nr_cpus)
+{
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	int i, to_cpu;
+
+	/* cpumap enqueue stats */
+	for (to_cpu = 0; to_cpu < n_cpus; to_cpu++) {
+		char *fmt = "%-15s %3d:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
+		char *fm2 = "%-15s %3s:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
+		char *errstr = "";
+
+		rec  =  &stats_rec->enq[to_cpu];
+		prev = &stats_prev->enq[to_cpu];
+		t = calc_period(rec, prev);
+		for (i = 0; i < nr_cpus; i++) {
+			struct datarec *r = &rec->cpu[i];
+			struct datarec *p = &prev->cpu[i];
+
+			pps  = calc_pps(r, p, t);
+			drop = calc_drop_pps(r, p, t);
+			err  = calc_errs_pps(r, p, t);
+			if (err > 0) {
+				errstr = "bulk-average";
+				err = pps / err; /* calc average bulk size */
+			}
+			if (pps > 0)
+				printf(fmt, "cpumap-enqueue",
+				       i, to_cpu, pps, drop, err, errstr);
+		}
+		pps = calc_pps(&rec->total, &prev->total, t);
+		if (pps > 0) {
+			drop = calc_drop_pps(&rec->total, &prev->total, t);
+			err  = calc_errs_pps(&rec->total, &prev->total, t);
+			if (err > 0) {
+				errstr = "bulk-average";
+				err = pps / err; /* calc average bulk size */
+			}
+			printf(fm2, "cpumap-enqueue",
+			       "sum", to_cpu, pps, drop, err, errstr);
+		}
+	}
+}
+
+static void stats_print_cpumap_kthread(struct stats_record *stats_rec,
+				       struct stats_record *stats_prev,
+				       unsigned int nr_cpus)
+{
+	char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
+	char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s\n";
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	char *e_str = "";
+	int i;
+
+	rec = &stats_rec->kthread;
+	prev = &stats_prev->kthread;
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+
+		pps = calc_pps(r, p, t);
+		drop = calc_drop_pps(r, p, t);
+		err = calc_errs_pps(r, p, t);
+		if (err > 0)
+			e_str = "sched";
+		if (pps > 0)
+			printf(fmt_k, "cpumap_kthread", i, pps, drop, err,
+			       e_str);
+	}
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	err = calc_errs_pps(&rec->total, &prev->total, t);
+	if (err > 0)
+		e_str = "sched-sum";
+	printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
+}
+
+static void stats_print_redirect_err_cnt(struct stats_record *stats_rec,
+					 struct stats_record *stats_prev,
+					 unsigned int nr_cpus)
+{
+	char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
+	char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
+	struct record *rec, *prev;
+	double t, pps, drop;
+	int i;
+
+	rec = &stats_rec->redir_err;
+	prev = &stats_prev->redir_err;
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+
+		pps = calc_pps(r, p, t);
+		drop = calc_drop_pps(r, p, t);
+		if (pps > 0)
+			printf(fmt_err, "redirect_err", i, pps, drop);
+	}
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	printf(fm2_err, "redirect_err", "total", pps, drop);
+}
+
+static void stats_print_exception_cnt(struct stats_record *stats_rec,
+				      struct stats_record *stats_prev,
+				      unsigned int nr_cpus)
+{
+	char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
+	char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
+	struct record *rec, *prev;
+	double t, pps, drop;
+	int i;
+
+	rec = &stats_rec->exception;
+	prev = &stats_prev->exception;
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+
+		pps = calc_pps(r, p, t);
+		drop = calc_drop_pps(r, p, t);
+		if (pps > 0)
+			printf(fmt_err, "xdp_exception", i, pps, drop);
+	}
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	printf(fm2_err, "xdp_exception", "total", pps, drop);
+}
+
+void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
+				      struct stats_record *stats_prev,
+				      unsigned int nr_cpus, char *mprog_name)
+{
+	char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f\n";
+	char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f\n";
+	double xdp_pass, xdp_drop, xdp_redirect;
+	struct record *rec, *prev;
+	double t;
+	int i;
+
+	printf("\n2nd remote XDP/eBPF prog_name: %s\n", mprog_name ?: "(none)");
+	printf("%-15s %-7s %-14s %-11s %-9s\n", "XDP-cpumap", "CPU:to",
+	       "xdp-pass", "xdp-drop", "xdp-redir");
+
+	rec = &stats_rec->kthread;
+	prev = &stats_prev->kthread;
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+
+		calc_xdp_pps(r, p, &xdp_pass, &xdp_drop, &xdp_redirect, t);
+		if (xdp_pass > 0 || xdp_drop > 0 || xdp_redirect > 0)
+			printf(fmt_k, "xdp-in-kthread", i, xdp_pass, xdp_drop,
+			       xdp_redirect);
+	}
+	calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
+		     &xdp_redirect, t);
+	printf(fm2_k, "xdp-in-kthread", "total", xdp_pass, xdp_drop,
+	       xdp_redirect);
+}
+
+static int init_tracepoints(struct bpf_object *obj)
+{
+	struct bpf_program *prog;
+
+	bpf_object__for_each_program(prog, obj) {
+		if (bpf_program__is_tracepoint(prog) != true)
+			continue;
+
+		tp_links[tp_cnt] = bpf_program__attach(prog);
+		if (libbpf_get_error(tp_links[tp_cnt])) {
+			tp_links[tp_cnt] = NULL;
+			return -EINVAL;
+		}
+		tp_cnt++;
+	}
+
+	return 0;
+}
+
+static int init_map_fds(struct bpf_object *obj)
+{
+	enum map_type type;
+
+	for (type = 0; type < NUM_MAP; type++) {
+		map_fds[type] =
+			bpf_object__find_map_fd_by_name(obj,
+							map_type_strings[type]);
+
+		if (map_fds[type] < 0)
+			return -ENOENT;
+	}
+
+	return 0;
+}
+
+int sample_init(struct bpf_object *obj)
+{
+	n_cpus = get_nprocs_conf();
+	return init_tracepoints(obj) ? : init_map_fds(obj);
+}
+
+void sample_exit(int status)
+{
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
+	exit(status);
+}
+
+void sample_stats_collect(int mask, struct stats_record *rec)
+{
+	int i;
+
+	if (mask & SAMPLE_RX_CNT)
+		map_collect_percpu(map_fds[RX_CNT], 0, &rec->rx_cnt);
+
+	if (mask & SAMPLE_REDIRECT_ERR_CNT)
+		map_collect_percpu(map_fds[REDIRECT_ERR_CNT], 1, &rec->redir_err);
+
+	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
+		for (i = 0; i < n_cpus; i++)
+			map_collect_percpu(map_fds[CPUMAP_ENQUEUE_CNT], i, &rec->enq[i]);
+
+	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT)
+		map_collect_percpu(map_fds[CPUMAP_KTHREAD_CNT], 0, &rec->kthread);
+
+	if (mask & SAMPLE_EXCEPTION_CNT)
+		map_collect_percpu(map_fds[EXCEPTION_CNT], 0, &rec->exception);
+}
+
+void sample_stats_print(int mask, struct stats_record *cur,
+			struct stats_record *prev, char *prog_name)
+{
+	int nr_cpus = bpf_num_possible_cpus();
+
+	printf("Running XDP/eBPF prog_name:%s\n", prog_name ?: "(none)");
+	printf("%-15s %-7s %-14s %-11s %-9s\n",
+	       "XDP-event", "CPU:to", "pps", "drop-pps", "extra-info");
+
+	if (mask & SAMPLE_RX_CNT)
+		stats_print_rx_cnt(cur, prev, nr_cpus);
+
+	if (mask & SAMPLE_REDIRECT_ERR_CNT)
+		stats_print_redirect_err_cnt(cur, prev, nr_cpus);
+
+	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
+		stats_print_cpumap_enqueue(cur, prev, nr_cpus);
+
+	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT)
+		stats_print_cpumap_kthread(cur, prev, nr_cpus);
+
+	if (mask & SAMPLE_EXCEPTION_CNT)
+		stats_print_exception_cnt(cur, prev, nr_cpus);
+}
+
+void sample_stats_poll(int interval, int mask, char *prog_name, int use_separators)
+{
+	struct stats_record *record, *prev;
+
+	record = alloc_stats_record();
+	prev   = alloc_stats_record();
+	sample_stats_collect(mask, record);
+
+	/* Trick to pretty printf with thousands separators use %' */
+	if (use_separators)
+		setlocale(LC_NUMERIC, "en_US");
+
+	for (;;) {
+		swap(&prev, &record);
+		sample_stats_collect(mask, record);
+		sample_stats_print(mask, record, prev, NULL);
+		printf("\n");
+		fflush(stdout);
+		sleep(interval);
+	}
+
+	free_stats_record(record);
+	free_stats_record(prev);
+}
+
+const char *get_driver_name(int ifindex)
+{
+	struct ethtool_drvinfo drv = {};
+	char ifname[IF_NAMESIZE];
+	static char drvname[32];
+	struct ifreq ifr = {};
+	int fd, r;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (fd < 0)
+		return NULL;
+
+	if (!if_indextoname(ifindex, ifname))
+		goto end;
+
+	drv.cmd = ETHTOOL_GDRVINFO;
+	strncpy(ifr.ifr_name, ifname, IF_NAMESIZE);
+	ifr.ifr_data = (void *)&drv;
+
+	r = ioctl(fd, SIOCETHTOOL, &ifr);
+	if (r)
+		goto end;
+
+	strncpy(drvname, drv.driver, sizeof(drvname));
+
+	close(fd);
+	return drvname;
+
+end:
+	close(fd);
+	return NULL;
+}
+
+int get_mac_addr(int ifindex, void *mac_addr)
+{
+	char ifname[IF_NAMESIZE];
+	struct ifreq ifr = {};
+	int fd, r;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (fd < 0)
+		return -errno;
+
+	if (!if_indextoname(ifindex, ifname)) {
+		r = -errno;
+		goto end;
+	}
+
+	strncpy(ifr.ifr_name, ifname, IF_NAMESIZE);
+
+	r = ioctl(fd, SIOCGIFHWADDR, &ifr);
+	if (r) {
+		r = -errno;
+		goto end;
+	}
+
+	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
+
+end:
+	close(fd);
+	return r;
+}
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
new file mode 100644
index 000000000000..3427baf70fc0
--- /dev/null
+++ b/samples/bpf/xdp_sample_user.h
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#pragma once
+
+#include <bpf/libbpf.h>
+
+enum map_type {
+	RX_CNT,
+	REDIRECT_ERR_CNT,
+	CPUMAP_ENQUEUE_CNT,
+	CPUMAP_KTHREAD_CNT,
+	EXCEPTION_CNT,
+	NUM_MAP,
+};
+
+enum tp_type {
+	TP_REDIRECT_ERR_CNT,
+	TP_REDIRECT_MAP_ERR_CNT,
+	TP_CPUMAP_ENQUEUE_CNT,
+	TP_CPUMAP_KTHREAD_CNT,
+	TP_EXCEPTION_CNT,
+	NUM_TP,
+};
+
+enum stats_mask {
+	SAMPLE_RX_CNT	        = 1U << 1,
+	SAMPLE_REDIRECT_ERR_CNT	= 1U << 2,
+	SAMPLE_CPUMAP_ENQUEUE_CNT  = 1U << 3,
+	SAMPLE_CPUMAP_KTHREAD_CNT  = 1U << 4,
+	SAMPLE_EXCEPTION_CNT	= 1U << 5,
+};
+
+static const char *const map_type_strings[] = {
+	[RX_CNT] = "rx_cnt",
+	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
+	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
+	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
+	[EXCEPTION_CNT] = "exception_cnt",
+};
+
+extern struct bpf_link *tp_links[NUM_TP];
+extern int map_fds[NUM_MAP];
+extern int n_cpus;
+extern int tp_cnt;
+
+/* Exit return codes */
+#define EXIT_OK			0
+#define EXIT_FAIL		1
+#define EXIT_FAIL_OPTION	2
+#define EXIT_FAIL_XDP		3
+#define EXIT_FAIL_BPF		4
+#define EXIT_FAIL_MEM		5
+
+/* Common stats data record shared with _kern.c */
+struct datarec {
+	__u64 processed;
+	__u64 dropped;
+	__u64 issue;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
+	__u64 xdp_redirect;
+};
+
+struct record {
+	__u64 timestamp;
+	struct datarec total;
+	struct datarec *cpu;
+};
+
+struct stats_record {
+	struct record rx_cnt;
+	struct record redir_err;
+	struct record kthread;
+	struct record exception;
+	struct record enq[];
+};
+
+int sample_init(struct bpf_object *obj);
+void sample_exit(int status);
+struct stats_record *alloc_stats_record(void);
+void free_stats_record(struct stats_record *rec);
+void sample_stats_print(int mask, struct stats_record *cur,
+			struct stats_record *prev, char *prog_name);
+void sample_stats_collect(int mask, struct stats_record *rec);
+void sample_stats_poll(int interval, int mask, char *prog_name,
+		       int use_separators);
+void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
+				      struct stats_record *stats_prev,
+				      unsigned int nr_cpus, char *mprog_name);
+
+const char *get_driver_name(int ifindex);
+int get_mac_addr(int ifindex, void *mac_addr);
+
+/* Pointer swap trick */
+static inline void swap(struct stats_record **a, struct stats_record **b)
+{
+	struct stats_record *tmp;
+
+	tmp = *a;
+	*a = *b;
+	*b = tmp;
+}
-- 
2.31.1

