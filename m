Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB604394951
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhE1Xzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhE1Xzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F58C061574;
        Fri, 28 May 2021 16:54:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y15so456234pfl.4;
        Fri, 28 May 2021 16:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffTMzd8u6S5X9o61xEi2TOtbJBb+RT7uqEVsFVrSITM=;
        b=EVHmeksSerOZ3RDks7djP07ktmrDnrXvXrhWdZ3vgF+XtJ1A1xG1OR1HI1KhpCam7n
         vXM7T7b0/RVaUnvz15V5k8GUgPsnhNk5DUxxHmLn7hDscc/ewiQ5pYjfEFuiEhFyPXNP
         ZY650eV525HfB38d1zQxO1Ny+vNEjuE18WhVuQsawNNxiYYc4yXEXrMotTSyw/I4WJIi
         f04CozEDE7M3L9P0aDBzKhnBlO42appEFmCOf8u2bg740KB2+ONRjycJCZqbLDeoy52Z
         RLeJUaecckcy9WwAjuYsE27BrdLoKDz4vyS/Bw3BREcvyw7JH+KupU287pDIjIISS3nI
         CV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffTMzd8u6S5X9o61xEi2TOtbJBb+RT7uqEVsFVrSITM=;
        b=kPu4wlFNFXfF8HpG5hZa4l1qqSLcTBWokeqwxRefnvElXRa3Liqeoy8jTd3N6gVccA
         CeIhR1Nw6yNFKYZ9EVbNhnny99dQWzUevNGOY6EcS8DbRF66ZUQiQuENzaJ4SY6Jy8uM
         XPdz6CHsg8ela34EQXiovIavT6Rn1kzE+onb7VR+vpDtOhP1xejm2NJUYJdgwkSmz/pS
         1wHP8OFqwFtkFCkUQZP3xz3NJL5YaWuEdcD7SM9ozMRkMKL3RbaFkEiHk1Ec4oyomIOU
         fKPN2EL4mo47Gh814iYuynbu6NVv9de6+LRhMOmEy00hrgu8OaBXjPwKVZehUf4wBsWN
         9biA==
X-Gm-Message-State: AOAM533lX9pbSRiOk80uY8nJ22q22heLkXpVhDQTsFYeM/NG5y0mAcw4
        /PPcPa99wYFHAN0Q73tuxm1yQap3BnU=
X-Google-Smtp-Source: ABdhPJyC40qqjmaMQPPBdA8WE1U87cC79s2+H5K+ZSG1FlNxZrepSPfM0754nqHWRCIhR244If3f+g==
X-Received: by 2002:a63:561d:: with SMTP id k29mr11402563pgb.335.1622246040605;
        Fri, 28 May 2021 16:54:00 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id o134sm5261417pfd.58.2021.05.28.16.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:00 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 07/15] samples: bpf: add extended reporting for xdp redirect error
Date:   Sat, 29 May 2021 05:22:42 +0530
Message-Id: <20210528235250.2635167-8-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This again is needed for xdp_monitor support. We also record the most
common errnos, but don't report for now. A future commit that modifies
output format will arrange for printing it properly.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample_kern.h | 53 +++++++++++++++++++++++++++---
 samples/bpf/xdp_sample_user.c | 62 +++++++++++++++++++++++++++--------
 samples/bpf/xdp_sample_user.h | 13 +++++++-
 3 files changed, 108 insertions(+), 20 deletions(-)

diff --git a/samples/bpf/xdp_sample_kern.h b/samples/bpf/xdp_sample_kern.h
index 3b85d71434d3..4131b9cb1ec4 100644
--- a/samples/bpf/xdp_sample_kern.h
+++ b/samples/bpf/xdp_sample_kern.h
@@ -7,6 +7,11 @@
 
 #define MAX_CPUS 64
 
+#define EINVAL 22
+#define ENETDOWN 100
+#define EMSGSIZE 90
+#define EOPNOTSUPP 95
+
 /* Common stats data record to keep userspace more simple */
 struct datarec {
 	__u64 processed;
@@ -35,8 +40,11 @@ struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__type(key, u32);
 	__type(value, struct datarec);
-	__uint(max_entries, 2);
-	/* TODO: have entries for all possible errno's */
+	__uint(max_entries, 2
+			    + 1 /* EINVAL */
+			    + 1 /* ENETDOWN */
+			    + 1 /* EMSGSIZE */
+			    + 1 /* EOPNOTSUPP */);
 } redirect_err_cnt SEC(".maps");
 
 /* Used by trace point */
@@ -91,6 +99,25 @@ enum {
 	XDP_REDIRECT_ERROR = 1
 };
 
+static __always_inline
+__u32 xdp_get_err_key(int err)
+{
+	switch (err) {
+	case 0:
+		return 0;
+	case -EINVAL:
+		return 2;
+	case -ENETDOWN:
+		return 3;
+	case -EMSGSIZE:
+		return 4;
+	case -EOPNOTSUPP:
+		return 5;
+	default:
+		return 1;
+	}
+}
+
 static __always_inline
 int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
 {
@@ -98,13 +125,15 @@ int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
 	struct datarec *rec;
 	int err = ctx->err;
 
-	if (!err)
-		key = XDP_REDIRECT_SUCCESS;
+	key = xdp_get_err_key(err);
 
 	rec = bpf_map_lookup_elem(&redirect_err_cnt, &key);
 	if (!rec)
 		return 0;
-	rec->dropped += 1;
+	if (key)
+		rec->dropped++;
+	else
+		rec->processed++;
 
 	return 0; /* Indicate event was filtered (no further processing)*/
 	/*
@@ -127,6 +156,20 @@ int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
 	return xdp_redirect_collect_stat(ctx);
 }
 
+/* Likely unloaded when prog starts */
+SEC("tracepoint/xdp/xdp_redirect")
+int trace_xdp_redirect(struct xdp_redirect_ctx *ctx)
+{
+	return xdp_redirect_collect_stat(ctx);
+}
+
+/* Likely unloaded when prog starts */
+SEC("tracepoint/xdp/xdp_redirect_map")
+int trace_xdp_redirect_map(struct xdp_redirect_ctx *ctx)
+{
+	return xdp_redirect_collect_stat(ctx);
+}
+
 /* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_exception/format
  * Code in:                kernel/include/trace/events/xdp.h
  */
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 56cd79ba303a..29410d551574 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -121,7 +121,8 @@ struct stats_record *alloc_stats_record(void)
 	}
 	memset(rec, 0, size);
 	rec->rx_cnt.cpu    = alloc_record_per_cpu();
-	rec->redir_err.cpu = alloc_record_per_cpu();
+	rec->redir_err[0].cpu = alloc_record_per_cpu();
+	rec->redir_err[1].cpu = alloc_record_per_cpu();
 	rec->kthread.cpu   = alloc_record_per_cpu();
 	rec->exception.cpu = alloc_record_per_cpu();
 	rec->devmap_xmit.cpu = alloc_record_per_cpu();
@@ -140,7 +141,8 @@ void free_stats_record(struct stats_record *r)
 	free(r->devmap_xmit.cpu);
 	free(r->exception.cpu);
 	free(r->kthread.cpu);
-	free(r->redir_err.cpu);
+	free(r->redir_err[1].cpu);
+	free(r->redir_err[0].cpu);
 	free(r->rx_cnt.cpu);
 	free(r);
 }
@@ -332,31 +334,54 @@ static void stats_print_cpumap_kthread(struct stats_record *stats_rec,
 	printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
 }
 
+static void stats_print_redirect_cnt(struct stats_record *stats_rec,
+				     struct stats_record *stats_prev,
+				     unsigned int nr_cpus)
+{
+	char *fmt1 = "%-15s %-7d %'-14.0f %'-11.0f %s\n";
+	char *fmt2 = "%-15s %-7s %'-14.0f %'-11.0f %s\n";
+	struct record *rec, *prev;
+	double t, pps;
+	int i;
+
+	rec = &stats_rec->redir_err[0];
+	prev = &stats_prev->redir_err[0];
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+
+		pps = calc_pps(r, p, t);
+		if (pps > 0)
+			printf(fmt1, "redirect", i, pps, 0.0, "Success");
+	}
+	pps = calc_pps(&rec->total, &prev->total, t);
+	printf(fmt2, "redirect", "total", pps, 0.0, "Success");
+}
+
 static void stats_print_redirect_err_cnt(struct stats_record *stats_rec,
 					 struct stats_record *stats_prev,
 					 unsigned int nr_cpus)
 {
-	char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-	char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
+	char *fmt1 = "%-15s %-7d %'-14.0f %'-11.0f %s\n";
+	char *fmt2 = "%-15s %-7s %'-14.0f %'-11.0f %s\n";
 	struct record *rec, *prev;
-	double t, pps, drop;
+	double t, drop;
 	int i;
 
-	rec = &stats_rec->redir_err;
-	prev = &stats_prev->redir_err;
+	rec = &stats_rec->redir_err[1];
+	prev = &stats_prev->redir_err[1];
 	t = calc_period(rec, prev);
 	for (i = 0; i < nr_cpus; i++) {
 		struct datarec *r = &rec->cpu[i];
 		struct datarec *p = &prev->cpu[i];
 
-		pps = calc_pps(r, p, t);
 		drop = calc_drop_pps(r, p, t);
-		if (pps > 0)
-			printf(fmt_err, "redirect_err", i, pps, drop);
+		if (drop > 0)
+			printf(fmt1, "redirect", i, 0.0, drop, "Error");
 	}
-	pps = calc_pps(&rec->total, &prev->total, t);
 	drop = calc_drop_pps(&rec->total, &prev->total, t);
-	printf(fm2_err, "redirect_err", "total", pps, drop);
+	printf(fmt2, "redirect", "total", 0.0, drop, "Error");
 }
 
 static void stats_print_exception_cnt(struct stats_record *stats_rec,
@@ -522,8 +547,14 @@ void sample_stats_collect(int mask, struct stats_record *rec)
 	if (mask & SAMPLE_RX_CNT)
 		map_collect_percpu(map_fds[RX_CNT], 0, &rec->rx_cnt);
 
-	if (mask & SAMPLE_REDIRECT_ERR_CNT)
-		map_collect_percpu(map_fds[REDIRECT_ERR_CNT], 1, &rec->redir_err);
+	/* Success case */
+	if (mask & SAMPLE_REDIRECT_CNT)
+		map_collect_percpu(map_fds[REDIRECT_ERR_CNT], 0, &rec->redir_err[0]);
+
+	if (mask & SAMPLE_REDIRECT_ERR_CNT) {
+		for (i = 1; i < XDP_REDIRECT_ERR_MAX; i++)
+			map_collect_percpu(map_fds[REDIRECT_ERR_CNT], i, &rec->redir_err[i]);
+	}
 
 	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
 		for (i = 0; i < n_cpus; i++)
@@ -551,6 +582,9 @@ void sample_stats_print(int mask, struct stats_record *cur,
 	if (mask & SAMPLE_RX_CNT)
 		stats_print_rx_cnt(cur, prev, nr_cpus);
 
+	if (mask & SAMPLE_REDIRECT_CNT)
+		stats_print_redirect_cnt(cur, prev, nr_cpus);
+
 	if (mask & SAMPLE_REDIRECT_ERR_CNT)
 		stats_print_redirect_err_cnt(cur, prev, nr_cpus);
 
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index 75a4ea4b55ad..a3a3c746e73e 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -14,6 +14,8 @@ enum map_type {
 };
 
 enum tp_type {
+	TP_REDIRECT_CNT,
+	TP_REDIRECT_MAP_CNT,
 	TP_REDIRECT_ERR_CNT,
 	TP_REDIRECT_MAP_ERR_CNT,
 	TP_CPUMAP_ENQUEUE_CNT,
@@ -30,6 +32,7 @@ enum stats_mask {
 	SAMPLE_CPUMAP_KTHREAD_CNT  = 1U << 4,
 	SAMPLE_EXCEPTION_CNT	= 1U << 5,
 	SAMPLE_DEVMAP_XMIT_CNT  = 1U << 6,
+	SAMPLE_REDIRECT_CNT	= 1U << 7,
 };
 
 static const char *const map_type_strings[] = {
@@ -54,6 +57,14 @@ extern int tp_cnt;
 #define EXIT_FAIL_BPF		4
 #define EXIT_FAIL_MEM		5
 
+#define XDP_REDIRECT_ERR_MAX 6
+
+static const char *xdp_redirect_err_names[XDP_REDIRECT_ERR_MAX] = {
+	/* Key=1 keeps unknown errors */
+	"Success", "Unknown", "EINVAL", "ENETDOWN", "EMSGSIZE",
+	"EOPNOTSUPP",
+};
+
 /* Common stats data record shared with _kern.c */
 struct datarec {
 	__u64 processed;
@@ -75,7 +86,7 @@ struct record {
 
 struct stats_record {
 	struct record rx_cnt;
-	struct record redir_err;
+	struct record redir_err[XDP_REDIRECT_ERR_MAX];
 	struct record kthread;
 	struct record exception;
 	struct record devmap_xmit;
-- 
2.31.1

