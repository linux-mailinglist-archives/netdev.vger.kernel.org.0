Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3875394955
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhE1Xzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhE1Xzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:45 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2708C061574;
        Fri, 28 May 2021 16:54:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v13so2338625ple.9;
        Fri, 28 May 2021 16:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iRj+jj4JHScG7zHlnmdQCZKLe5g9HZ0AbhyTur65Bto=;
        b=UievWkFLn4zDg6FyifgEzywdbvF2y0ls4pbeATErK5cVWZ8yISu5OBKrz76R5wWHyq
         odFMfRy82naslinfeMcVVAaxjyUyFCuQS+/qZuIX2gPMnbAsY1LIuUSACnAAWl6/pH4K
         HMg66aqFtOzvZI4nN8KVfpvJbV+17+UoM6l+BhWj/ECyeGiwuLo96H0ya+VRYWPuvyH5
         AuqRw/fXpVALqp7vOm9P7L0XZizzxLl2iOu490fE7PlS6CcXMc9PdMC/l/PK1WREPA5T
         JpK1Lnz3I2/MGuCy4qJKUpwJ3Vr8YSmOZgx3duKR5jUCNxKfmBEPmPN+jnKtXjxBVgCc
         MJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iRj+jj4JHScG7zHlnmdQCZKLe5g9HZ0AbhyTur65Bto=;
        b=Z+8k+3/V/PaNa8nsGTP1FOUnJS2M6e8NWqRW1SiP5S6jz5V1ZLKeXbmnwt+DGBbAUe
         7v4BQ+Bj+a4nHzMqWkLXvqBgX/SFRL6zbu35j/P3joQk1jSDrrotU8Sv1A+e7NXnST4e
         MqxbqsopLAMFf63QMNXQt5fOaG5A9qCVxJGMmuxvE1yqricg+7Ov1mWl5KIkU99cGL/1
         LBzhfOBz14G07Hj+blBMZ3Dmd9Q8Ohc8+kIxF4QQkTp8DQztaxigrZNKpPGaWdLf4NTb
         hNSDVZasRK1bam9dYwLZ41ySnGkwzTXYq4yywJRdFFa5aiwxYzG83dhwauQ6CBjeWPWA
         HESQ==
X-Gm-Message-State: AOAM533ftrEoYGDb3rCOPCIHkwrO5OwmiHqpQlEvEwSyX42N+cZUORG2
        +JDEwR4lixnb/Bgzq/tvW32k3Lfkl8k=
X-Google-Smtp-Source: ABdhPJyZ1ubF5RXYhRzVpUqIw15mzUbFe4lMSuyH9zP5A1qj4s40FDAJtgLBikpYxpaFWxzmkTnGsg==
X-Received: by 2002:a17:90a:288:: with SMTP id w8mr7074092pja.111.1622246047857;
        Fri, 28 May 2021 16:54:07 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id 6sm5321155pjm.21.2021.05.28.16.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:07 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 09/15] samples: bpf: convert xdp_monitor to use xdp_samples
Date:   Sat, 29 May 2021 05:22:44 +0530
Message-Id: <20210528235250.2635167-10-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reuses the samples support added so far.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile           |   2 +-
 samples/bpf/xdp_monitor_kern.c | 253 +------------
 samples/bpf/xdp_monitor_user.c | 625 +--------------------------------
 samples/bpf/xdp_sample_kern.h  |   6 +-
 4 files changed, 23 insertions(+), 863 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index ea7100c8b760..8750233dcf07 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -102,7 +102,7 @@ xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o xdp_sample_user.o
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o xdp_sample_user.o
-xdp_monitor-objs := xdp_monitor_user.o
+xdp_monitor-objs := xdp_monitor_user.o xdp_sample_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
diff --git a/samples/bpf/xdp_monitor_kern.c b/samples/bpf/xdp_monitor_kern.c
index 5c955b812c47..46c4fe4d7878 100644
--- a/samples/bpf/xdp_monitor_kern.c
+++ b/samples/bpf/xdp_monitor_kern.c
@@ -3,255 +3,6 @@
  *
  * XDP monitor tool, based on tracepoints
  */
-#include <uapi/linux/bpf.h>
-#include <bpf/bpf_helpers.h>
+#include "xdp_sample_kern.h"
 
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, u64);
-	__uint(max_entries, 2);
-	/* TODO: have entries for all possible errno's */
-} redirect_err_cnt SEC(".maps");
-
-#define XDP_UNKNOWN	XDP_REDIRECT + 1
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, u64);
-	__uint(max_entries, XDP_UNKNOWN + 1);
-} exception_cnt SEC(".maps");
-
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_redirect_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int prog_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12  size:4; signed:0;
-	int ifindex;		//	offset:16  size:4; signed:1;
-	int err;		//	offset:20  size:4; signed:1;
-	int to_ifindex;		//	offset:24  size:4; signed:1;
-	u32 map_id;		//	offset:28  size:4; signed:0;
-	int map_index;		//	offset:32  size:4; signed:1;
-};				//	offset:36
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
-	int err = ctx->err;
-	u64 *cnt;
-
-	if (!err)
-		key = XDP_REDIRECT_SUCCESS;
-
-	cnt  = bpf_map_lookup_elem(&redirect_err_cnt, &key);
-	if (!cnt)
-		return 1;
-	*cnt += 1;
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
-
-SEC("tracepoint/xdp/xdp_redirect_map_err")
-int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-/* Likely unloaded when prog starts */
-SEC("tracepoint/xdp/xdp_redirect")
-int trace_xdp_redirect(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-/* Likely unloaded when prog starts */
-SEC("tracepoint/xdp/xdp_redirect_map")
-int trace_xdp_redirect_map(struct xdp_redirect_ctx *ctx)
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
-	u64 *cnt;
-	u32 key;
-
-	key = ctx->act;
-	if (key > XDP_REDIRECT)
-		key = XDP_UNKNOWN;
-
-	cnt = bpf_map_lookup_elem(&exception_cnt, &key);
-	if (!cnt)
-		return 1;
-	*cnt += 1;
-
-	return 0;
-}
-
-/* Common stats data record shared with _user.c */
-struct datarec {
-	u64 processed;
-	u64 dropped;
-	u64 info;
-	u64 err;
-};
-#define MAX_CPUS 64
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, MAX_CPUS);
-} cpumap_enqueue_cnt SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} cpumap_kthread_cnt SEC(".maps");
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
-		rec->info += 1;
-
-	return 0;
-}
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_kthread/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_kthread_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int map_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int cpu;		//	offset:16; size:4; signed:1;
-	unsigned int drops;	//	offset:20; size:4; signed:0;
-	unsigned int processed;	//	offset:24; size:4; signed:0;
-	int sched;		//	offset:28; size:4; signed:1;
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
-
-	/* Count times kthread yielded CPU via schedule call */
-	if (ctx->sched)
-		rec->info++;
-
-	return 0;
-}
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} devmap_xmit_cnt SEC(".maps");
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_devmap_xmit/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct devmap_xmit_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int from_ifindex;	//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int to_ifindex; 	//	offset:16; size:4; signed:1;
-	int drops;		//	offset:20; size:4; signed:1;
-	int sent;		//	offset:24; size:4; signed:1;
-	int err;		//	offset:28; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_devmap_xmit")
-int trace_xdp_devmap_xmit(struct devmap_xmit_ctx *ctx)
-{
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&devmap_xmit_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->sent;
-	rec->dropped   += ctx->drops;
-
-	/* Record bulk events, then userspace can calc average bulk size */
-	rec->info += 1;
-
-	/* Record error cases, where no frame were sent */
-	if (ctx->err)
-		rec->err++;
-
-	/* Catch API error of drv ndo_xdp_xmit sent more than count */
-	if (ctx->drops < 0)
-		rec->err++;
-
-	return 1;
-}
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index 49ebc49aefc3..babb9fcc1a17 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -30,32 +30,9 @@ static const char *__doc_err_only__=
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 #include "bpf_util.h"
+#include "xdp_sample_user.h"
 
-enum map_type {
-	REDIRECT_ERR_CNT,
-	EXCEPTION_CNT,
-	CPUMAP_ENQUEUE_CNT,
-	CPUMAP_KTHREAD_CNT,
-	DEVMAP_XMIT_CNT,
-};
-
-static const char *const map_type_strings[] = {
-	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
-	[EXCEPTION_CNT] = "exception_cnt",
-	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
-	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
-	[DEVMAP_XMIT_CNT] = "devmap_xmit_cnt",
-};
-
-#define NUM_MAP 5
-#define NUM_TP 8
-
-static int tp_cnt;
-static int map_cnt;
-static int verbose = 1;
 static bool debug = false;
-struct bpf_map *map_data[NUM_MAP] = {};
-struct bpf_link *tp_links[NUM_TP] = {};
 struct bpf_object *obj;
 
 static const struct option long_options[] = {
@@ -68,12 +45,8 @@ static const struct option long_options[] = {
 
 static void int_exit(int sig)
 {
-	/* Detach tracepoints */
-	while (tp_cnt)
-		bpf_link__destroy(tp_links[--tp_cnt]);
-
 	bpf_object__close(obj);
-	exit(0);
+	sample_exit(EXIT_OK);
 }
 
 /* C standard specifies two constants, EXIT_SUCCESS(0) and EXIT_FAILURE(1) */
@@ -100,557 +73,6 @@ static void usage(char *argv[])
 	printf("\n");
 }
 
-#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
-static __u64 gettime(void)
-{
-	struct timespec t;
-	int res;
-
-	res = clock_gettime(CLOCK_MONOTONIC, &t);
-	if (res < 0) {
-		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
-		exit(EXIT_FAILURE);
-	}
-	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
-}
-
-enum {
-	REDIR_SUCCESS = 0,
-	REDIR_ERROR = 1,
-};
-#define REDIR_RES_MAX 2
-static const char *redir_names[REDIR_RES_MAX] = {
-	[REDIR_SUCCESS]	= "Success",
-	[REDIR_ERROR]	= "Error",
-};
-static const char *err2str(int err)
-{
-	if (err < REDIR_RES_MAX)
-		return redir_names[err];
-	return NULL;
-}
-/* enum xdp_action */
-#define XDP_UNKNOWN	XDP_REDIRECT + 1
-#define XDP_ACTION_MAX (XDP_UNKNOWN + 1)
-static const char *xdp_action_names[XDP_ACTION_MAX] = {
-	[XDP_ABORTED]	= "XDP_ABORTED",
-	[XDP_DROP]	= "XDP_DROP",
-	[XDP_PASS]	= "XDP_PASS",
-	[XDP_TX]	= "XDP_TX",
-	[XDP_REDIRECT]	= "XDP_REDIRECT",
-	[XDP_UNKNOWN]	= "XDP_UNKNOWN",
-};
-static const char *action2str(int action)
-{
-	if (action < XDP_ACTION_MAX)
-		return xdp_action_names[action];
-	return NULL;
-}
-
-/* Common stats data record shared with _kern.c */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 info;
-	__u64 err;
-};
-#define MAX_CPUS 64
-
-/* Userspace structs for collection of stats from maps */
-struct record {
-	__u64 timestamp;
-	struct datarec total;
-	struct datarec *cpu;
-};
-struct u64rec {
-	__u64 processed;
-};
-struct record_u64 {
-	/* record for _kern side __u64 values */
-	__u64 timestamp;
-	struct u64rec total;
-	struct u64rec *cpu;
-};
-
-struct stats_record {
-	struct record_u64 xdp_redirect[REDIR_RES_MAX];
-	struct record_u64 xdp_exception[XDP_ACTION_MAX];
-	struct record xdp_cpumap_kthread;
-	struct record xdp_cpumap_enqueue[MAX_CPUS];
-	struct record xdp_devmap_xmit;
-};
-
-static bool map_collect_record(int fd, __u32 key, struct record *rec)
-{
-	/* For percpu maps, userspace gets a value per possible CPU */
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec values[nr_cpus];
-	__u64 sum_processed = 0;
-	__u64 sum_dropped = 0;
-	__u64 sum_info = 0;
-	__u64 sum_err = 0;
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
-		rec->cpu[i].info = values[i].info;
-		sum_info        += values[i].info;
-		rec->cpu[i].err = values[i].err;
-		sum_err        += values[i].err;
-	}
-	rec->total.processed = sum_processed;
-	rec->total.dropped   = sum_dropped;
-	rec->total.info      = sum_info;
-	rec->total.err       = sum_err;
-	return true;
-}
-
-static bool map_collect_record_u64(int fd, __u32 key, struct record_u64 *rec)
-{
-	/* For percpu maps, userspace gets a value per possible CPU */
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct u64rec values[nr_cpus];
-	__u64 sum_total = 0;
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
-		sum_total            += values[i].processed;
-	}
-	rec->total.processed = sum_total;
-	return true;
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
-static double calc_period_u64(struct record_u64 *r, struct record_u64 *p)
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
-static double calc_pps(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->processed - p->processed;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_pps_u64(struct u64rec *r, struct u64rec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->processed - p->processed;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_drop(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->dropped - p->dropped;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_info(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->info - p->info;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_err(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->err - p->err;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static void stats_print(struct stats_record *stats_rec,
-			struct stats_record *stats_prev,
-			bool err_only)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	int rec_i = 0, i, to_cpu;
-	double t = 0, pps = 0;
-
-	/* Header */
-	printf("%-15s %-7s %-12s %-12s %-9s\n",
-	       "XDP-event", "CPU:to", "pps", "drop-pps", "extra-info");
-
-	/* tracepoint: xdp:xdp_redirect_* */
-	if (err_only)
-		rec_i = REDIR_ERROR;
-
-	for (; rec_i < REDIR_RES_MAX; rec_i++) {
-		struct record_u64 *rec, *prev;
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %s\n";
-
-		rec  =  &stats_rec->xdp_redirect[rec_i];
-		prev = &stats_prev->xdp_redirect[rec_i];
-		t = calc_period_u64(rec, prev);
-
-		for (i = 0; i < nr_cpus; i++) {
-			struct u64rec *r = &rec->cpu[i];
-			struct u64rec *p = &prev->cpu[i];
-
-			pps = calc_pps_u64(r, p, t);
-			if (pps > 0)
-				printf(fmt1, "XDP_REDIRECT", i,
-				       rec_i ? 0.0: pps, rec_i ? pps : 0.0,
-				       err2str(rec_i));
-		}
-		pps = calc_pps_u64(&rec->total, &prev->total, t);
-		printf(fmt2, "XDP_REDIRECT", "total",
-		       rec_i ? 0.0: pps, rec_i ? pps : 0.0, err2str(rec_i));
-	}
-
-	/* tracepoint: xdp:xdp_exception */
-	for (rec_i = 0; rec_i < XDP_ACTION_MAX; rec_i++) {
-		struct record_u64 *rec, *prev;
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %s\n";
-
-		rec  =  &stats_rec->xdp_exception[rec_i];
-		prev = &stats_prev->xdp_exception[rec_i];
-		t = calc_period_u64(rec, prev);
-
-		for (i = 0; i < nr_cpus; i++) {
-			struct u64rec *r = &rec->cpu[i];
-			struct u64rec *p = &prev->cpu[i];
-
-			pps = calc_pps_u64(r, p, t);
-			if (pps > 0)
-				printf(fmt1, "Exception", i,
-				       0.0, pps, action2str(rec_i));
-		}
-		pps = calc_pps_u64(&rec->total, &prev->total, t);
-		if (pps > 0)
-			printf(fmt2, "Exception", "total",
-			       0.0, pps, action2str(rec_i));
-	}
-
-	/* cpumap enqueue stats */
-	for (to_cpu = 0; to_cpu < MAX_CPUS; to_cpu++) {
-		char *fmt1 = "%-15s %3d:%-3d %'-12.0f %'-12.0f %'-10.2f %s\n";
-		char *fmt2 = "%-15s %3s:%-3d %'-12.0f %'-12.0f %'-10.2f %s\n";
-		struct record *rec, *prev;
-		char *info_str = "";
-		double drop, info;
-
-		rec  =  &stats_rec->xdp_cpumap_enqueue[to_cpu];
-		prev = &stats_prev->xdp_cpumap_enqueue[to_cpu];
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop(r, p, t);
-			info = calc_info(r, p, t);
-			if (info > 0) {
-				info_str = "bulk-average";
-				info = pps / info; /* calc average bulk size */
-			}
-			if (pps > 0)
-				printf(fmt1, "cpumap-enqueue",
-				       i, to_cpu, pps, drop, info, info_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		if (pps > 0) {
-			drop = calc_drop(&rec->total, &prev->total, t);
-			info = calc_info(&rec->total, &prev->total, t);
-			if (info > 0) {
-				info_str = "bulk-average";
-				info = pps / info; /* calc average bulk size */
-			}
-			printf(fmt2, "cpumap-enqueue",
-			       "sum", to_cpu, pps, drop, info, info_str);
-		}
-	}
-
-	/* cpumap kthread stats */
-	{
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %'-10.0f %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %'-10.0f %s\n";
-		struct record *rec, *prev;
-		double drop, info;
-		char *i_str = "";
-
-		rec  =  &stats_rec->xdp_cpumap_kthread;
-		prev = &stats_prev->xdp_cpumap_kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop(r, p, t);
-			info = calc_info(r, p, t);
-			if (info > 0)
-				i_str = "sched";
-			if (pps > 0 || drop > 0)
-				printf(fmt1, "cpumap-kthread",
-				       i, pps, drop, info, i_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop(&rec->total, &prev->total, t);
-		info = calc_info(&rec->total, &prev->total, t);
-		if (info > 0)
-			i_str = "sched-sum";
-		printf(fmt2, "cpumap-kthread", "total", pps, drop, info, i_str);
-	}
-
-	/* devmap ndo_xdp_xmit stats */
-	{
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %'-10.2f %s %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %'-10.2f %s %s\n";
-		struct record *rec, *prev;
-		double drop, info, err;
-		char *i_str = "";
-		char *err_str = "";
-
-		rec  =  &stats_rec->xdp_devmap_xmit;
-		prev = &stats_prev->xdp_devmap_xmit;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop(r, p, t);
-			info = calc_info(r, p, t);
-			err  = calc_err(r, p, t);
-			if (info > 0) {
-				i_str = "bulk-average";
-				info = (pps+drop) / info; /* calc avg bulk */
-			}
-			if (err > 0)
-				err_str = "drv-err";
-			if (pps > 0 || drop > 0)
-				printf(fmt1, "devmap-xmit",
-				       i, pps, drop, info, i_str, err_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop(&rec->total, &prev->total, t);
-		info = calc_info(&rec->total, &prev->total, t);
-		err  = calc_err(&rec->total, &prev->total, t);
-		if (info > 0) {
-			i_str = "bulk-average";
-			info = (pps+drop) / info; /* calc avg bulk */
-		}
-		if (err > 0)
-			err_str = "drv-err";
-		printf(fmt2, "devmap-xmit", "total", pps, drop,
-		       info, i_str, err_str);
-	}
-
-	printf("\n");
-}
-
-static bool stats_collect(struct stats_record *rec)
-{
-	int fd;
-	int i;
-
-	/* TODO: Detect if someone unloaded the perf event_fd's, as
-	 * this can happen by someone running perf-record -e
-	 */
-
-	fd = bpf_map__fd(map_data[REDIRECT_ERR_CNT]);
-	for (i = 0; i < REDIR_RES_MAX; i++)
-		map_collect_record_u64(fd, i, &rec->xdp_redirect[i]);
-
-	fd = bpf_map__fd(map_data[EXCEPTION_CNT]);
-	for (i = 0; i < XDP_ACTION_MAX; i++) {
-		map_collect_record_u64(fd, i, &rec->xdp_exception[i]);
-	}
-
-	fd = bpf_map__fd(map_data[CPUMAP_ENQUEUE_CNT]);
-	for (i = 0; i < MAX_CPUS; i++)
-		map_collect_record(fd, i, &rec->xdp_cpumap_enqueue[i]);
-
-	fd = bpf_map__fd(map_data[CPUMAP_KTHREAD_CNT]);
-	map_collect_record(fd, 0, &rec->xdp_cpumap_kthread);
-
-	fd = bpf_map__fd(map_data[DEVMAP_XMIT_CNT]);
-	map_collect_record(fd, 0, &rec->xdp_devmap_xmit);
-
-	return true;
-}
-
-static void *alloc_rec_per_cpu(int record_size)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	void *array;
-
-	array = calloc(nr_cpus, record_size);
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
-	int rec_sz;
-	int i;
-
-	/* Alloc main stats_record structure */
-	rec = calloc(1, sizeof(*rec));
-	if (!rec) {
-		fprintf(stderr, "Mem alloc error\n");
-		exit(EXIT_FAIL_MEM);
-	}
-
-	/* Alloc stats stored per CPU for each record */
-	rec_sz = sizeof(struct u64rec);
-	for (i = 0; i < REDIR_RES_MAX; i++)
-		rec->xdp_redirect[i].cpu = alloc_rec_per_cpu(rec_sz);
-
-	for (i = 0; i < XDP_ACTION_MAX; i++)
-		rec->xdp_exception[i].cpu = alloc_rec_per_cpu(rec_sz);
-
-	rec_sz = sizeof(struct datarec);
-	rec->xdp_cpumap_kthread.cpu = alloc_rec_per_cpu(rec_sz);
-	rec->xdp_devmap_xmit.cpu    = alloc_rec_per_cpu(rec_sz);
-
-	for (i = 0; i < MAX_CPUS; i++)
-		rec->xdp_cpumap_enqueue[i].cpu = alloc_rec_per_cpu(rec_sz);
-
-	return rec;
-}
-
-static void free_stats_record(struct stats_record *r)
-{
-	int i;
-
-	for (i = 0; i < REDIR_RES_MAX; i++)
-		free(r->xdp_redirect[i].cpu);
-
-	for (i = 0; i < XDP_ACTION_MAX; i++)
-		free(r->xdp_exception[i].cpu);
-
-	free(r->xdp_cpumap_kthread.cpu);
-	free(r->xdp_devmap_xmit.cpu);
-
-	for (i = 0; i < MAX_CPUS; i++)
-		free(r->xdp_cpumap_enqueue[i].cpu);
-
-	free(r);
-}
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
-static void stats_poll(int interval, bool err_only)
-{
-	struct stats_record *rec, *prev;
-
-	rec  = alloc_stats_record();
-	prev = alloc_stats_record();
-	stats_collect(rec);
-
-	if (err_only)
-		printf("\n%s\n", __doc_err_only__);
-
-	/* Trick to pretty printf with thousands separators use %' */
-	setlocale(LC_NUMERIC, "en_US");
-
-	/* Header */
-	if (verbose)
-		printf("\n%s", __doc__);
-
-	/* TODO Need more advanced stats on error types */
-	if (verbose) {
-		printf(" - Stats map0: %s\n", bpf_map__name(map_data[0]));
-		printf(" - Stats map1: %s\n", bpf_map__name(map_data[1]));
-		printf("\n");
-	}
-	fflush(stdout);
-
-	while (1) {
-		swap(&prev, &rec);
-		stats_collect(rec);
-		stats_print(rec, prev, err_only);
-		fflush(stdout);
-		sleep(interval);
-	}
-
-	free_stats_record(rec);
-	free_stats_record(prev);
-}
-
 static void print_bpf_prog_info(void)
 {
 	struct bpf_program *prog;
@@ -666,7 +88,7 @@ static void print_bpf_prog_info(void)
 
 	i = 0;
 	/* Maps info */
-	printf("Loaded BPF prog have %d map(s)\n", map_cnt);
+	printf("Loaded BPF prog have %d map(s)\n", NUM_MAP);
 	bpf_object__for_each_map(map, obj) {
 		const char *name = bpf_map__name(map);
 		int fd		 = bpf_map__fd(map);
@@ -687,10 +109,11 @@ static void print_bpf_prog_info(void)
 
 int main(int argc, char **argv)
 {
-	struct bpf_program *prog;
+	int mask = SAMPLE_REDIRECT_ERR_CNT | SAMPLE_CPUMAP_ENQUEUE_CNT |
+		   SAMPLE_CPUMAP_KTHREAD_CNT | SAMPLE_EXCEPTION_CNT |
+		   SAMPLE_DEVMAP_XMIT_CNT;
 	int longindex = 0, opt;
 	int ret = EXIT_FAILURE;
-	enum map_type type;
 	char filename[256];
 
 	/* Default settings: */
@@ -736,25 +159,9 @@ int main(int argc, char **argv)
 		goto cleanup;
 	}
 
-	for (type = 0; type < NUM_MAP; type++) {
-		map_data[type] =
-			bpf_object__find_map_by_name(obj, map_type_strings[type]);
-
-		if (libbpf_get_error(map_data[type])) {
-			printf("ERROR: finding a map in obj file failed\n");
-			goto cleanup;
-		}
-		map_cnt++;
-	}
-
-	bpf_object__for_each_program(prog, obj) {
-		tp_links[tp_cnt] = bpf_program__attach(prog);
-		if (libbpf_get_error(tp_links[tp_cnt])) {
-			printf("ERROR: bpf_program__attach failed\n");
-			tp_links[tp_cnt] = NULL;
-			goto cleanup;
-		}
-		tp_cnt++;
+	if (sample_init(obj) < 0) {
+		fprintf(stderr, "Failed to initialize sample\n");
+		goto cleanup;
 	}
 
 	if (debug) {
@@ -763,6 +170,8 @@ int main(int argc, char **argv)
 
 	/* Unload/stop tracepoint event by closing bpf_link's */
 	if (errors_only) {
+		printf("%s", __doc_err_only__);
+
 		/* The bpf_link[i] depend on the order of
 		 * the functions was defined in _kern.c
 		 */
@@ -771,17 +180,13 @@ int main(int argc, char **argv)
 
 		bpf_link__destroy(tp_links[3]);	/* tracepoint/xdp/xdp_redirect_map */
 		tp_links[3] = NULL;
+	} else {
+		mask |= SAMPLE_REDIRECT_CNT;
 	}
 
-	stats_poll(interval, errors_only);
-
-	ret = EXIT_SUCCESS;
+	sample_stats_poll(interval, mask, "xdp_monitor", true);
 
 cleanup:
-	/* Detach tracepoints */
-	while (tp_cnt)
-		bpf_link__destroy(tp_links[--tp_cnt]);
-
 	bpf_object__close(obj);
-	return ret;
+	sample_exit(EXIT_OK);
 }
diff --git a/samples/bpf/xdp_sample_kern.h b/samples/bpf/xdp_sample_kern.h
index ec36e7b4a3ba..dd7f7ea63166 100644
--- a/samples/bpf/xdp_sample_kern.h
+++ b/samples/bpf/xdp_sample_kern.h
@@ -5,7 +5,11 @@
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-#define MAX_CPUS 64
+#ifndef NR_CPUS
+#define NR_CPUS 64
+#endif
+
+#define MAX_CPUS NR_CPUS
 
 #define EINVAL 22
 #define ENETDOWN 100
-- 
2.31.1

