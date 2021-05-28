Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4582239494F
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhE1Xzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhE1Xze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC22C061574;
        Fri, 28 May 2021 16:53:57 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q15so3684096pgg.12;
        Fri, 28 May 2021 16:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=px1IWmk2mPYAMtxfJLLuZNJj0lwhMZ8hOJ0HTI06GFw=;
        b=XoYCREa6tqH4IoQdawMymXihkMP5gS1LNWyq1WDeOl2DHJqClNxbv9MTxfedc1QBvc
         c5MznTaJ7ezUQ98IPL0dP5dsDMFIDz2XzAZYOzGUrpEGmrGyGsqvSACTiqwki7AeYZAw
         BjmtKaiAdR+CJgXp/xhSD1Guxx5ykYzc92+4wEj9XXDX0dr8QuYlR5Fr5GnZtU+zuO6U
         qhHLgTfrH+NIS7Bj/W3DjP3MwtkXVHtCtmMHCn+mAC0gUyBq2IrqeSeTgyQf8i7KRAqa
         NQKJ1kP6rCBYIJhw8zYA7vrCV8MheiyEeAT0jllnoWIxGgpgl+uQmnm1zmxchdyJxqeJ
         Ir6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=px1IWmk2mPYAMtxfJLLuZNJj0lwhMZ8hOJ0HTI06GFw=;
        b=smqNqF0fKo0iKWNrruufXK2nxforccejWvq3Vi7CGhIzT+0noeQTvRAjoKS1zMWM7F
         2UNcyNferON1+PxTjcVi8uToG39HB4bEl8dKcWNWTLOXjFcF2ARBoktpUBrW31Wcyjfv
         ahSUKRmK+6NnYEkI6IX+iMSWAsI9iIMVNBwLSTQJj8++SioTqhvQ9tWldYpa9wnW8joy
         htvdTotFE8kSqISiLXDvkDV0i/yyId8XSDc7q30IQe+Q2SfI8yayyAF7VhTFR//TaTc1
         cx8H5yZrp+2izf1GLxQGkoq7ozhRkFBXtTi+1uGS9238g8NYuJoIR8+qKwDaQ1khkFtD
         afTA==
X-Gm-Message-State: AOAM533Wjt391u5reqyuObxym/2MxWgXDQEeOxCA2KgCmbemdkvd2hEX
        X42B1t8I/0QmUsqE2XQ+JeQrVeO92dg=
X-Google-Smtp-Source: ABdhPJx6Vnj0Om+IoWmPvbqiXQ6tNORMEASxygIOFdEs02Wrr7domJZ2XZKDcyD8N4bGDrtdSuCr1g==
X-Received: by 2002:a63:8c55:: with SMTP id q21mr11257178pgn.96.1622246037087;
        Fri, 28 May 2021 16:53:57 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id i8sm5067698pgt.58.2021.05.28.16.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:53:56 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 06/15] samples: bpf: prepare devmap_xmit support in xdp_sample
Date:   Sat, 29 May 2021 05:22:41 +0530
Message-Id: <20210528235250.2635167-7-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used to convert xdp_monitor to xdp_sample reorg in the next
patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_redirect_map_user.c |  3 +-
 samples/bpf/xdp_sample_kern.h       | 51 +++++++++++++++++++++-
 samples/bpf/xdp_sample_user.c       | 68 +++++++++++++++++++++++++++++
 samples/bpf/xdp_sample_user.h       | 10 ++++-
 4 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 42893385ba96..b2c7adad99ec 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -76,7 +76,7 @@ static void usage(const char *prog)
 int main(int argc, char **argv)
 {
 	int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_CNT |
-		   SAMPLE_EXCEPTION_CNT;
+		   SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT;
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
@@ -148,6 +148,7 @@ int main(int argc, char **argv)
 	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
 		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_general");
 		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_general");
+		mask &= ~SAMPLE_DEVMAP_XMIT_CNT;
 	} else {
 		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_native");
 		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_native");
diff --git a/samples/bpf/xdp_sample_kern.h b/samples/bpf/xdp_sample_kern.h
index bb809542ac20..3b85d71434d3 100644
--- a/samples/bpf/xdp_sample_kern.h
+++ b/samples/bpf/xdp_sample_kern.h
@@ -12,7 +12,10 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
-	__u64 xdp_pass;
+	union {
+		__u64 xdp_pass;
+		__u64 info;
+	};
 	__u64 xdp_drop;
 	__u64 xdp_redirect;
 };
@@ -60,6 +63,13 @@ struct {
 	__uint(max_entries, 1);
 } exception_cnt SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} devmap_xmit_cnt SEC(".maps");
+
 /*** Trace point code ***/
 
 /* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
@@ -218,3 +228,42 @@ int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
 
 	return 0;
 }
+
+/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_devmap_xmit/format
+ * Code in:         kernel/include/trace/events/xdp.h
+ */
+struct devmap_xmit_ctx {
+	u64 __pad;		// First 8 bytes are not accessible by bpf code
+	int from_ifindex;	//	offset:8;  size:4; signed:1;
+	u32 act;		//	offset:12; size:4; signed:0;
+	int to_ifindex;		//	offset:16; size:4; signed:1;
+	int drops;		//	offset:20; size:4; signed:1;
+	int sent;		//	offset:24; size:4; signed:1;
+	int err;		//	offset:28; size:4; signed:1;
+};
+
+SEC("tracepoint/xdp/xdp_devmap_xmit")
+int trace_xdp_devmap_xmit(struct devmap_xmit_ctx *ctx)
+{
+	struct datarec *rec;
+	u32 key = 0;
+
+	rec = bpf_map_lookup_elem(&devmap_xmit_cnt, &key);
+	if (!rec)
+		return 0;
+	rec->processed += ctx->sent;
+	rec->dropped   += ctx->drops;
+
+	/* Record bulk events, then userspace can calc average bulk size */
+	rec->info += 1;
+
+	/* Record error cases, where no frame were sent */
+	if (ctx->err)
+		rec->issue++;
+
+	/* Catch API error of drv ndo_xdp_xmit sent more than count */
+	if (ctx->drops < 0)
+		rec->issue++;
+
+	return 1;
+}
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index be60fbddd8c7..56cd79ba303a 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -124,6 +124,7 @@ struct stats_record *alloc_stats_record(void)
 	rec->redir_err.cpu = alloc_record_per_cpu();
 	rec->kthread.cpu   = alloc_record_per_cpu();
 	rec->exception.cpu = alloc_record_per_cpu();
+	rec->devmap_xmit.cpu = alloc_record_per_cpu();
 	for (i = 0; i < n_cpus; i++)
 		rec->enq[i].cpu = alloc_record_per_cpu();
 
@@ -136,6 +137,7 @@ void free_stats_record(struct stats_record *r)
 
 	for (i = 0; i < n_cpus; i++)
 		free(r->enq[i].cpu);
+	free(r->devmap_xmit.cpu);
 	free(r->exception.cpu);
 	free(r->kthread.cpu);
 	free(r->redir_err.cpu);
@@ -192,6 +194,19 @@ static __u64 calc_errs_pps(struct datarec *r,
 	return pps;
 }
 
+static __u64 calc_info_pps(struct datarec *r,
+			   struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->info - p->info;
+		pps = packets / period_;
+	}
+	return pps;
+}
+
 static void calc_xdp_pps(struct datarec *r, struct datarec *p,
 			 double *xdp_pass, double *xdp_drop,
 			 double *xdp_redirect, double period_)
@@ -404,6 +419,53 @@ void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
 	       xdp_redirect);
 }
 
+static void stats_print_devmap_xmit(struct stats_record *stats_rec,
+				    struct stats_record *stats_prev,
+				    unsigned int nr_cpus)
+{
+	char *fmt1 = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s %s\n";
+	char *fmt2 = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s %s\n";
+	double pps, drop, info, err;
+	struct record *rec, *prev;
+	char *err_str = "";
+	char *i_str = "";
+	double t;
+	int i;
+
+	rec = &stats_rec->devmap_xmit;
+	prev = &stats_prev->devmap_xmit;
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+
+		pps = calc_pps(r, p, t);
+		drop = calc_drop_pps(r, p, t);
+		info = calc_info_pps(r, p, t);
+		err = calc_errs_pps(r, p, t);
+		if (info > 0) {
+			i_str = "bulk-average";
+			info = (pps + drop) / info; /* calc avg bulk */
+		}
+		if (err > 0)
+			err_str = "drv-err";
+		if (pps > 0 || drop > 0)
+			printf(fmt1, "devmap-xmit", i, pps, drop, info, i_str,
+			       err_str);
+	}
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	info = calc_info_pps(&rec->total, &prev->total, t);
+	err = calc_errs_pps(&rec->total, &prev->total, t);
+	if (info > 0) {
+		i_str = "bulk-average";
+		info = (pps + drop) / info; /* calc avg bulk */
+	}
+	if (err > 0)
+		err_str = "drv-err";
+	printf(fmt2, "devmap-xmit", "total", pps, drop, info, i_str, err_str);
+}
+
 static int init_tracepoints(struct bpf_object *obj)
 {
 	struct bpf_program *prog;
@@ -472,6 +534,9 @@ void sample_stats_collect(int mask, struct stats_record *rec)
 
 	if (mask & SAMPLE_EXCEPTION_CNT)
 		map_collect_percpu(map_fds[EXCEPTION_CNT], 0, &rec->exception);
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
+		map_collect_percpu(map_fds[DEVMAP_XMIT_CNT], 0, &rec->devmap_xmit);
 }
 
 void sample_stats_print(int mask, struct stats_record *cur,
@@ -497,6 +562,9 @@ void sample_stats_print(int mask, struct stats_record *cur,
 
 	if (mask & SAMPLE_EXCEPTION_CNT)
 		stats_print_exception_cnt(cur, prev, nr_cpus);
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
+		stats_print_devmap_xmit(cur, prev, nr_cpus);
 }
 
 void sample_stats_poll(int interval, int mask, char *prog_name, int use_separators)
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index 3427baf70fc0..75a4ea4b55ad 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -9,6 +9,7 @@ enum map_type {
 	CPUMAP_ENQUEUE_CNT,
 	CPUMAP_KTHREAD_CNT,
 	EXCEPTION_CNT,
+	DEVMAP_XMIT_CNT,
 	NUM_MAP,
 };
 
@@ -18,6 +19,7 @@ enum tp_type {
 	TP_CPUMAP_ENQUEUE_CNT,
 	TP_CPUMAP_KTHREAD_CNT,
 	TP_EXCEPTION_CNT,
+	TP_DEVMAP_XMIT_CNT,
 	NUM_TP,
 };
 
@@ -27,6 +29,7 @@ enum stats_mask {
 	SAMPLE_CPUMAP_ENQUEUE_CNT  = 1U << 3,
 	SAMPLE_CPUMAP_KTHREAD_CNT  = 1U << 4,
 	SAMPLE_EXCEPTION_CNT	= 1U << 5,
+	SAMPLE_DEVMAP_XMIT_CNT  = 1U << 6,
 };
 
 static const char *const map_type_strings[] = {
@@ -35,6 +38,7 @@ static const char *const map_type_strings[] = {
 	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
 	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
 	[EXCEPTION_CNT] = "exception_cnt",
+	[DEVMAP_XMIT_CNT] = "devmap_xmit_cnt",
 };
 
 extern struct bpf_link *tp_links[NUM_TP];
@@ -55,7 +59,10 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
-	__u64 xdp_pass;
+	union {
+		__u64 xdp_pass;
+		__u64 info;
+	};
 	__u64 xdp_drop;
 	__u64 xdp_redirect;
 };
@@ -71,6 +78,7 @@ struct stats_record {
 	struct record redir_err;
 	struct record kthread;
 	struct record exception;
+	struct record devmap_xmit;
 	struct record enq[];
 };
 
-- 
2.31.1

