Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D33394961
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhE1X4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhE1X4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:56:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5B9C06138A;
        Fri, 28 May 2021 16:54:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso5477487pjb.0;
        Fri, 28 May 2021 16:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mQVWnl5kD4VZJGsvupF6sFLlOwXDd/uH9jRxPkLWhRE=;
        b=DCKCEUaXO3M7SuyK3CFkRo4p0+FRQ8EOSfNdca7pm87L4NPtZaF3AjrdIXTmAhD7aR
         cqQFfxT5QlETKevwgEcueirhu5sjGFhGV7PXHqP5ITCoEYYr3oUoqmmKKjtc3iwnJvMc
         6IndgMeFw3+0VQhr0xqajANXhONBbIYqPumRRgwRy5wHJ/nEJINn2a5tUM5QaGB0AZvt
         k8tXjEJuEF/qXrq6YmwPjyrxwddu0jCur2UTo3KZ1IhDGuEEpxOOUQgoiD2dFxPxVxPN
         K+QCSJJyngS31TFALN2jBeb6+B5bT4MIrIMQ6zAVqf5HshlTZT4ps7xx2GfyP1aAfFKf
         6zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQVWnl5kD4VZJGsvupF6sFLlOwXDd/uH9jRxPkLWhRE=;
        b=VX/K18Qh1PV0HUKnysnqpMkwQ2xjXuX6LtG6OWUPFMr8qgKL5nwuhB+/aZT6bXgk0c
         4J3AsZs4sv//GIzwWsLz9aTZzkM+mr03HYemCF9pmCRnTKJDyTsFWG19VdYeLeVZiwiJ
         0FyuwLoKJgcWR2nLKi1Lp8JmTwr/3vmcjeQDgYjfZ3wVTioeT3Q/z+2ViFpgiwAFkIT4
         f9hLWu8y4xpiwtuUQlaZrOskAJpPIz++lptHYfFoYvXxRslMT36YmbG2+br3sZExn/9P
         AX+1XZW8fmWsHAP7ND4UKsh4qIYHDVESNPxMcoJCU/DrzZKiNju5yeUja3lHgsrzmzLj
         dFrg==
X-Gm-Message-State: AOAM532qFLeEmLoUTtnSFgATb4SYwbPq5Y8iviMVI/bQihlLWAUwjIv/
        LSPFZUPLVKa0fMixbBkjrNCQcgzbAuY=
X-Google-Smtp-Source: ABdhPJz4Pa7mqTfr3xzapFUEmmX1JtoVd4K49xhXmYURDfEzACYU80QgQhSwpzYwqjfpHj9a2khXHQ==
X-Received: by 2002:a17:903:228a:b029:f7:9f7e:aa2c with SMTP id b10-20020a170903228ab02900f79f7eaa2cmr10167345plh.71.1622246068663;
        Fri, 28 May 2021 16:54:28 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id f186sm5382410pfb.36.2021.05.28.16.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:28 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 15/15] samples: bpf: convert xdp_samples to use raw_tracepoints
Date:   Sat, 29 May 2021 05:22:50 +0530
Message-Id: <20210528235250.2635167-16-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are faster, and hence speeds up cases where user passes --stats to
enable success case redirect accounting. We can extend this to all other
tracepoints as well, so make that part of this change.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample_kern.h | 145 +++++++++++-----------------------
 samples/bpf/xdp_sample_user.c |   2 +-
 2 files changed, 45 insertions(+), 102 deletions(-)

diff --git a/samples/bpf/xdp_sample_kern.h b/samples/bpf/xdp_sample_kern.h
index dd7f7ea63166..08fbc55df3fd 100644
--- a/samples/bpf/xdp_sample_kern.h
+++ b/samples/bpf/xdp_sample_kern.h
@@ -3,6 +3,9 @@
 #pragma once
 
 #include <uapi/linux/bpf.h>
+#include <net/xdp.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_tracing.h>
 #include <bpf/bpf_helpers.h>
 
 #ifndef NR_CPUS
@@ -85,20 +88,6 @@ struct {
 
 /*** Trace point code ***/
 
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
 enum {
 	XDP_REDIRECT_SUCCESS = 0,
 	XDP_REDIRECT_ERROR = 1
@@ -124,11 +113,11 @@ __u32 xdp_get_err_key(int err)
 }
 
 static __always_inline
-int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
+int xdp_redirect_collect_stat(struct bpf_raw_tracepoint_args *ctx)
 {
 	u32 key = XDP_REDIRECT_ERROR;
+	int err = ctx->args[3];
 	struct datarec *rec;
-	int err = ctx->err;
 
 	key = xdp_get_err_key(err);
 
@@ -149,47 +138,35 @@ int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
 	 */
 }
 
-SEC("tracepoint/xdp/xdp_redirect_err")
-int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
+SEC("raw_tracepoint/xdp_redirect_err")
+int trace_xdp_redirect_err(struct bpf_raw_tracepoint_args *ctx)
 {
 	return xdp_redirect_collect_stat(ctx);
 }
 
-SEC("tracepoint/xdp/xdp_redirect_map_err")
-int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
+SEC("raw_tracepoint/xdp_redirect_map_err")
+int trace_xdp_redirect_map_err(struct bpf_raw_tracepoint_args *ctx)
 {
 	return xdp_redirect_collect_stat(ctx);
 }
 
-/* Likely unloaded when prog starts */
-SEC("tracepoint/xdp/xdp_redirect")
-int trace_xdp_redirect(struct xdp_redirect_ctx *ctx)
+SEC("raw_tracepoint/xdp_redirect")
+int trace_xdp_redirect(struct bpf_raw_tracepoint_args *ctx)
 {
 	return xdp_redirect_collect_stat(ctx);
 }
 
-/* Likely unloaded when prog starts */
-SEC("tracepoint/xdp/xdp_redirect_map")
-int trace_xdp_redirect_map(struct xdp_redirect_ctx *ctx)
+SEC("raw_tracepoint/xdp_redirect_map")
+int trace_xdp_redirect_map(struct bpf_raw_tracepoint_args *ctx)
 {
 	return xdp_redirect_collect_stat(ctx);
 }
 
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
+SEC("raw_tracepoint/xdp_exception")
+int trace_xdp_exception(struct bpf_raw_tracepoint_args *ctx)
 {
+	u32 key = ctx->args[2];
 	struct datarec *rec;
-	u32 key = ctx->act;
 
 	if (key > XDP_REDIRECT)
 		key = XDP_UNKNOWN;
@@ -202,23 +179,10 @@ int trace_xdp_exception(struct xdp_exception_ctx *ctx)
 	return 0;
 }
 
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
+SEC("raw_tracepoint/xdp_cpumap_enqueue")
+int trace_xdp_cpumap_enqueue(struct bpf_raw_tracepoint_args *ctx)
 {
-	u32 to_cpu = ctx->to_cpu;
+	u32 to_cpu = ctx->args[3];
 	struct datarec *rec;
 
 	if (to_cpu >= MAX_CPUS)
@@ -227,11 +191,11 @@ int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
 	rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &to_cpu);
 	if (!rec)
 		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
+	rec->processed += ctx->args[1];
+	rec->dropped   += ctx->args[2];
 
 	/* Record bulk events, then userspace can calc average bulk size */
-	if (ctx->processed > 0)
+	if (ctx->args[1] > 0)
 		rec->issue += 1;
 
 	/* Inception: It's possible to detect overload situations, via
@@ -242,78 +206,57 @@ int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
 	return 0;
 }
 
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
+SEC("raw_tracepoint/xdp_cpumap_kthread")
+int trace_xdp_cpumap_kthread(struct bpf_raw_tracepoint_args *ctx)
 {
+	struct xdp_cpumap_stats *stats;
 	struct datarec *rec;
 	u32 key = 0;
 
+	stats = (struct xdp_cpumap_stats *) ctx->args[4];
+	if (!stats)
+		return 0;
+
 	rec = bpf_map_lookup_elem(&cpumap_kthread_cnt, &key);
 	if (!rec)
 		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-	rec->xdp_pass  += ctx->xdp_pass;
-	rec->xdp_drop  += ctx->xdp_drop;
-	rec->xdp_redirect  += ctx->xdp_redirect;
+	rec->processed += ctx->args[1];
+	rec->dropped   += ctx->args[2];
+
+	rec->xdp_pass  += BPF_CORE_READ(stats, pass);
+	rec->xdp_drop  += BPF_CORE_READ(stats, drop);
+	rec->xdp_redirect  += BPF_CORE_READ(stats, redirect);
 
 	/* Count times kthread yielded CPU via schedule call */
-	if (ctx->sched)
+	if (ctx->args[3])
 		rec->issue++;
 
 	return 0;
 }
 
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_devmap_xmit/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct devmap_xmit_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int from_ifindex;	//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int to_ifindex;		//	offset:16; size:4; signed:1;
-	int drops;		//	offset:20; size:4; signed:1;
-	int sent;		//	offset:24; size:4; signed:1;
-	int err;		//	offset:28; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_devmap_xmit")
-int trace_xdp_devmap_xmit(struct devmap_xmit_ctx *ctx)
+SEC("raw_tracepoint/xdp_devmap_xmit")
+int trace_xdp_devmap_xmit(struct bpf_raw_tracepoint_args *ctx)
 {
 	struct datarec *rec;
 	u32 key = 0;
+	int drops;
 
 	rec = bpf_map_lookup_elem(&devmap_xmit_cnt, &key);
 	if (!rec)
 		return 0;
-	rec->processed += ctx->sent;
-	rec->dropped   += ctx->drops;
+	rec->processed += ctx->args[2];
+	rec->dropped   += ctx->args[3];
 
 	/* Record bulk events, then userspace can calc average bulk size */
 	rec->info += 1;
 
 	/* Record error cases, where no frame were sent */
-	if (ctx->err)
+	if (ctx->args[4])
 		rec->issue++;
 
+	drops = ctx->args[3];
 	/* Catch API error of drv ndo_xdp_xmit sent more than count */
-	if (ctx->drops < 0)
+	if (drops < 0)
 		rec->issue++;
 
 	return 1;
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index aa02d9bbea6c..539c0c78fcb0 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -805,7 +805,7 @@ static int init_tracepoints(struct bpf_object *obj)
 	struct bpf_program *prog;
 
 	bpf_object__for_each_program(prog, obj) {
-		if (bpf_program__is_tracepoint(prog) != true)
+		if (!bpf_program__is_raw_tracepoint(prog))
 			continue;
 
 		tp_links[tp_cnt] = bpf_program__attach(prog);
-- 
2.31.1

