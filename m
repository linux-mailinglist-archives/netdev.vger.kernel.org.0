Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1340394949
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhE1XzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhE1XzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E200FC061574;
        Fri, 28 May 2021 16:53:46 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y202so4413747pfc.6;
        Fri, 28 May 2021 16:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V86Ql8jRAGbtURMVGsSlMfJC5php4p6tg5O5Rdj4NKQ=;
        b=pwcPA+yr8DFpkZnV3Jpk/aFTrind6HeRc1oAmrApBtCe1S2fCKHewqnIDFEwke/JUY
         R4fmxM+OKydOs9FOd3TKvZLS8WzNgdIj8Dw5mxnQF3ufPS2lAAWc4vNxHcEiuVcE/sg/
         eSWkd104++t8SpxecSzodBJfuRmxPBRm86DS4Nw9a5A+JUkFBkLM69YGsiZcHJxCDpX1
         BDGXDrnvs72h5uMaj6IZS81KoafZEaVpScbIv2fahfeFN0KXs29HAOkP0JILX4bq1ZP4
         dJFBdH5bf75FubBJnvRrv0R8lmYilUGNfbPdIT4bgjnbApZBpCtDFfxcCtxNfUZROYo9
         NEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V86Ql8jRAGbtURMVGsSlMfJC5php4p6tg5O5Rdj4NKQ=;
        b=EVRm9q1y0xZQMEd0vyQbSyYCFy8TYluWueR9cFxwYyYJx9cEQT5mM0fS/PTQFsWiv3
         a46MLzF9CEXilxrabcP4xdksfAORru1dycfoqMvjCafGkmMQeo7rNVWT+Rj5K4cIsTEu
         Hf2C7McKijwPN2S5t0KsOayCEkbmLyTCcXtx43pVP2AS+11/MKfGSmyrDDgrvjLemzP1
         gVHolSW5M5b1vzUio651A9JRgigakOxeRla/tDfURyqu2e6nxT6qP4yAyFsF8E5p/DGk
         5ZG9QMikl0pI9pmh5eK0QXaPvsvcOlC8QmQQlCQ4uSOgIja5EPUmlga8kBN3c+0wfssP
         G/BA==
X-Gm-Message-State: AOAM531mHXInDlRZ4exCG8phY0L2G8e0o8RqPnEGcC4VvyDxokr1VhmQ
        bmbVRdI2pozaVrydNC4omgCW2D7yCqo=
X-Google-Smtp-Source: ABdhPJyb+GcZNHkIqE/azlo0NNh7bNlCdqYJ4o4eufOxMvJ+YSqfQs+FYZKJfvc5HoDEuyyvu05z9Q==
X-Received: by 2002:a62:1481:0:b029:2c1:1e90:c54 with SMTP id 123-20020a6214810000b02902c11e900c54mr6168441pfu.55.1622246026196;
        Fri, 28 May 2021 16:53:46 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id x125sm1191860pfx.201.2021.05.28.16.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:53:45 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 03/15] samples: bpf: split out common bpf progs to its own file
Date:   Sat, 29 May 2021 05:22:38 +0530
Message-Id: <20210528235250.2635167-4-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is done to later reuse these in a way that can be shared
among multiple samples.

We are using xdp_redirect_cpu_kern.c as a base to build further support on
top (mostly adding a few other things missing that xdp_monitor does in
subsequent patches).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample_kern.h | 220 ++++++++++++++++++++++++++++++++++
 1 file changed, 220 insertions(+)
 create mode 100644 samples/bpf/xdp_sample_kern.h

diff --git a/samples/bpf/xdp_sample_kern.h b/samples/bpf/xdp_sample_kern.h
new file mode 100644
index 000000000000..bb809542ac20
--- /dev/null
+++ b/samples/bpf/xdp_sample_kern.h
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc. */
+#pragma once
+
+#include <uapi/linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define MAX_CPUS 64
+
+/* Common stats data record to keep userspace more simple */
+struct datarec {
+	__u64 processed;
+	__u64 dropped;
+	__u64 issue;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
+	__u64 xdp_redirect;
+};
+
+/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
+ * feedback.  Redirect TX errors can be caught via a tracepoint.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} rx_cnt SEC(".maps");
+
+/* Used by trace point */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 2);
+	/* TODO: have entries for all possible errno's */
+} redirect_err_cnt SEC(".maps");
+
+/* Used by trace point */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, MAX_CPUS);
+} cpumap_enqueue_cnt SEC(".maps");
+
+/* Used by trace point */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} cpumap_kthread_cnt SEC(".maps");
+
+/* Used by trace point */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} exception_cnt SEC(".maps");
+
+/*** Trace point code ***/
+
+/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
+ * Code in:                kernel/include/trace/events/xdp.h
+ */
+struct xdp_redirect_ctx {
+	u64 __pad;	// First 8 bytes are not accessible by bpf code
+	int prog_id;	//	offset:8;  size:4; signed:1;
+	u32 act;	//	offset:12  size:4; signed:0;
+	int ifindex;	//	offset:16  size:4; signed:1;
+	int err;	//	offset:20  size:4; signed:1;
+	int to_ifindex;	//	offset:24  size:4; signed:1;
+	u32 map_id;	//	offset:28  size:4; signed:0;
+	int map_index;	//	offset:32  size:4; signed:1;
+};			//	offset:36
+
+enum {
+	XDP_REDIRECT_SUCCESS = 0,
+	XDP_REDIRECT_ERROR = 1
+};
+
+static __always_inline
+int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
+{
+	u32 key = XDP_REDIRECT_ERROR;
+	struct datarec *rec;
+	int err = ctx->err;
+
+	if (!err)
+		key = XDP_REDIRECT_SUCCESS;
+
+	rec = bpf_map_lookup_elem(&redirect_err_cnt, &key);
+	if (!rec)
+		return 0;
+	rec->dropped += 1;
+
+	return 0; /* Indicate event was filtered (no further processing)*/
+	/*
+	 * Returning 1 here would allow e.g. a perf-record tracepoint
+	 * to see and record these events, but it doesn't work well
+	 * in-practice as stopping perf-record also unload this
+	 * bpf_prog.  Plus, there is additional overhead of doing so.
+	 */
+}
+
+SEC("tracepoint/xdp/xdp_redirect_err")
+int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
+{
+	return xdp_redirect_collect_stat(ctx);
+}
+
+SEC("tracepoint/xdp/xdp_redirect_map_err")
+int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
+{
+	return xdp_redirect_collect_stat(ctx);
+}
+
+/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_exception/format
+ * Code in:                kernel/include/trace/events/xdp.h
+ */
+struct xdp_exception_ctx {
+	u64 __pad;	// First 8 bytes are not accessible by bpf code
+	int prog_id;	//	offset:8;  size:4; signed:1;
+	u32 act;	//	offset:12; size:4; signed:0;
+	int ifindex;	//	offset:16; size:4; signed:1;
+};
+
+SEC("tracepoint/xdp/xdp_exception")
+int trace_xdp_exception(struct xdp_exception_ctx *ctx)
+{
+	struct datarec *rec;
+	u32 key = 0;
+
+	rec = bpf_map_lookup_elem(&exception_cnt, &key);
+	if (!rec)
+		return 1;
+	rec->dropped += 1;
+
+	return 0;
+}
+
+/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_enqueue/format
+ * Code in:         kernel/include/trace/events/xdp.h
+ */
+struct cpumap_enqueue_ctx {
+	u64 __pad;		// First 8 bytes are not accessible by bpf code
+	int map_id;		//	offset:8;  size:4; signed:1;
+	u32 act;		//	offset:12; size:4; signed:0;
+	int cpu;		//	offset:16; size:4; signed:1;
+	unsigned int drops;	//	offset:20; size:4; signed:0;
+	unsigned int processed;	//	offset:24; size:4; signed:0;
+	int to_cpu;		//	offset:28; size:4; signed:1;
+};
+
+SEC("tracepoint/xdp/xdp_cpumap_enqueue")
+int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
+{
+	u32 to_cpu = ctx->to_cpu;
+	struct datarec *rec;
+
+	if (to_cpu >= MAX_CPUS)
+		return 1;
+
+	rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &to_cpu);
+	if (!rec)
+		return 0;
+	rec->processed += ctx->processed;
+	rec->dropped   += ctx->drops;
+
+	/* Record bulk events, then userspace can calc average bulk size */
+	if (ctx->processed > 0)
+		rec->issue += 1;
+
+	/* Inception: It's possible to detect overload situations, via
+	 * this tracepoint.  This can be used for creating a feedback
+	 * loop to XDP, which can take appropriate actions to mitigate
+	 * this overload situation.
+	 */
+	return 0;
+}
+
+/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_kthread/format
+ * Code in:         kernel/include/trace/events/xdp.h
+ */
+struct cpumap_kthread_ctx {
+	u64 __pad;			// First 8 bytes are not accessible
+	int map_id;			//	offset:8;  size:4; signed:1;
+	u32 act;			//	offset:12; size:4; signed:0;
+	int cpu;			//	offset:16; size:4; signed:1;
+	unsigned int drops;		//	offset:20; size:4; signed:0;
+	unsigned int processed;		//	offset:24; size:4; signed:0;
+	int sched;			//	offset:28; size:4; signed:1;
+	unsigned int xdp_pass;		//	offset:32; size:4; signed:0;
+	unsigned int xdp_drop;		//	offset:36; size:4; signed:0;
+	unsigned int xdp_redirect;	//	offset:40; size:4; signed:0;
+};
+
+SEC("tracepoint/xdp/xdp_cpumap_kthread")
+int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
+{
+	struct datarec *rec;
+	u32 key = 0;
+
+	rec = bpf_map_lookup_elem(&cpumap_kthread_cnt, &key);
+	if (!rec)
+		return 0;
+	rec->processed += ctx->processed;
+	rec->dropped   += ctx->drops;
+	rec->xdp_pass  += ctx->xdp_pass;
+	rec->xdp_drop  += ctx->xdp_drop;
+	rec->xdp_redirect  += ctx->xdp_redirect;
+
+	/* Count times kthread yielded CPU via schedule call */
+	if (ctx->sched)
+		rec->issue++;
+
+	return 0;
+}
-- 
2.31.1

