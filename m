Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55E2394953
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhE1Xzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhE1Xzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:40 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB81BC061574;
        Fri, 28 May 2021 16:54:04 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ot16so3427772pjb.3;
        Fri, 28 May 2021 16:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NLJmgoALRRKu0OLvtlrqv7GEJkir/uMI8l7e7jcjPug=;
        b=ZTn7EZOKM+0tHAMnyXB6+9B4CueKKpMGnP0Su4xGDTuGtMCxlxsAMyTH3889prI+o8
         i0Ms8RTRf2QsSXTYuV/Gww0YxiGH5K871idDZKv+AeegAVvD8bFG2tfyoWQKjDpmyWDj
         peTg4eJx1tcc77+dT4jy8cYGdTZDc0r3UaZXtfJ+4HV+MObZ3oH7kwjdre8E9XPlCNI3
         a1f9u6/tb3whbIn15g3eXF8e38vTjt5PIGoE0HDxAXwtUu7gyUkdcFTSy2069Oxex8r5
         pQ5jQnU+ClgHJVBheMDmvMVX/z6rAzKhgHdIDWGh18lQ8z+zJWn12MXd31KwtjPHURxe
         Ourg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NLJmgoALRRKu0OLvtlrqv7GEJkir/uMI8l7e7jcjPug=;
        b=tx73X5UCwSMx77M92uQnfCPBWWcKYLOKQdHD47DWO3kkPza4KnMgTtbNuBVHNnDFcd
         8B0rZR6JmV15Qeks714OUEf1LxX/RgM76ONlmBF17UCIaWHuZTe84sNtwABneQeyVN87
         x+xl2AookhpqI2+ISWd7UsC8eQ410WYZQLKSQ7yXCJ4s8rBGiF++j0o8OERn6fv4I2Vp
         EVTG+BqU33s+yuCkhaS/R/b0BvBu0l3l95Rvphx7Tx2N0Jm4mFcp/pTi1bvQYRhaLnq/
         odNz0T62cjDn9b3gdCjm7GUEHHB9P4xY1ftksun8bShM1Ctv2lYVpCOEPJt/9+eC+Oi/
         S4Kw==
X-Gm-Message-State: AOAM5325lR6Il/8wri9G9oSAsQjdi3wgT/KWtQxgnP3unNVF00hHgWU8
        6wX0DgFxp/Y5K5lcPuquyUjXDcvHv7U=
X-Google-Smtp-Source: ABdhPJxMI6OpZQNe78gAQyppO29vkSMQnmCU5KZ5vvF88xlXMmaZsJTwQUVRoWR6RcZ1HCgyimIDlw==
X-Received: by 2002:a17:90a:5649:: with SMTP id d9mr6998959pji.163.1622246044037;
        Fri, 28 May 2021 16:54:04 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id n23sm5297911pff.93.2021.05.28.16.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:03 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 08/15] samples: bpf: add per exception reporting for xdp_exception
Date:   Sat, 29 May 2021 05:22:43 +0530
Message-Id: <20210528235250.2635167-9-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is taken from xdp_monitor, in preparation for the conversion in a
subsequent patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample_kern.h |  8 ++++--
 samples/bpf/xdp_sample_user.c | 47 ++++++++++++++++++++---------------
 samples/bpf/xdp_sample_user.h | 24 ++++++++++++++++--
 3 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/samples/bpf/xdp_sample_kern.h b/samples/bpf/xdp_sample_kern.h
index 4131b9cb1ec4..ec36e7b4a3ba 100644
--- a/samples/bpf/xdp_sample_kern.h
+++ b/samples/bpf/xdp_sample_kern.h
@@ -63,12 +63,13 @@ struct {
 	__uint(max_entries, 1);
 } cpumap_kthread_cnt SEC(".maps");
 
+#define XDP_UNKNOWN (XDP_REDIRECT + 1)
 /* Used by trace point */
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__type(key, u32);
 	__type(value, struct datarec);
-	__uint(max_entries, 1);
+	__uint(max_entries, XDP_UNKNOWN + 1);
 } exception_cnt SEC(".maps");
 
 struct {
@@ -184,7 +185,10 @@ SEC("tracepoint/xdp/xdp_exception")
 int trace_xdp_exception(struct xdp_exception_ctx *ctx)
 {
 	struct datarec *rec;
-	u32 key = 0;
+	u32 key = ctx->act;
+
+	if (key > XDP_REDIRECT)
+		key = XDP_UNKNOWN;
 
 	rec = bpf_map_lookup_elem(&exception_cnt, &key);
 	if (!rec)
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 29410d551574..446668edf8d8 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -124,7 +124,8 @@ struct stats_record *alloc_stats_record(void)
 	rec->redir_err[0].cpu = alloc_record_per_cpu();
 	rec->redir_err[1].cpu = alloc_record_per_cpu();
 	rec->kthread.cpu   = alloc_record_per_cpu();
-	rec->exception.cpu = alloc_record_per_cpu();
+	for (i = 0; i < XDP_ACTION_MAX; i++)
+		rec->exception[i].cpu = alloc_record_per_cpu();
 	rec->devmap_xmit.cpu = alloc_record_per_cpu();
 	for (i = 0; i < n_cpus; i++)
 		rec->enq[i].cpu = alloc_record_per_cpu();
@@ -139,7 +140,8 @@ void free_stats_record(struct stats_record *r)
 	for (i = 0; i < n_cpus; i++)
 		free(r->enq[i].cpu);
 	free(r->devmap_xmit.cpu);
-	free(r->exception.cpu);
+	for (i = 0; i < XDP_ACTION_MAX; i++)
+		free(r->exception[i].cpu);
 	free(r->kthread.cpu);
 	free(r->redir_err[1].cpu);
 	free(r->redir_err[0].cpu);
@@ -388,27 +390,31 @@ static void stats_print_exception_cnt(struct stats_record *stats_rec,
 				      struct stats_record *stats_prev,
 				      unsigned int nr_cpus)
 {
-	char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-	char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
+	char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %s\n";
+	char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %s\n";
 	struct record *rec, *prev;
-	double t, pps, drop;
-	int i;
+	double t, drop;
+	int rec_i, i;
 
-	rec = &stats_rec->exception;
-	prev = &stats_prev->exception;
-	t = calc_period(rec, prev);
-	for (i = 0; i < nr_cpus; i++) {
-		struct datarec *r = &rec->cpu[i];
-		struct datarec *p = &prev->cpu[i];
+	for (rec_i = 0; rec_i < XDP_ACTION_MAX; rec_i++) {
+		rec  = &stats_rec->exception[rec_i];
+		prev = &stats_prev->exception[rec_i];
+		t = calc_period(rec, prev);
 
-		pps = calc_pps(r, p, t);
-		drop = calc_drop_pps(r, p, t);
-		if (pps > 0)
-			printf(fmt_err, "xdp_exception", i, pps, drop);
+		for (i = 0; i < nr_cpus; i++) {
+			struct datarec *r = &rec->cpu[i];
+			struct datarec *p = &prev->cpu[i];
+
+			drop = calc_drop_pps(r, p, t);
+			if (drop > 0)
+				printf(fmt1, "xdp_exception", i,
+				       0.0, drop, action2str(rec_i));
+		}
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		if (drop > 0)
+			printf(fmt2, "xdp_exception", "total",
+			       0.0, drop, action2str(rec_i));
 	}
-	pps = calc_pps(&rec->total, &prev->total, t);
-	drop = calc_drop_pps(&rec->total, &prev->total, t);
-	printf(fm2_err, "xdp_exception", "total", pps, drop);
 }
 
 void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
@@ -564,7 +570,8 @@ void sample_stats_collect(int mask, struct stats_record *rec)
 		map_collect_percpu(map_fds[CPUMAP_KTHREAD_CNT], 0, &rec->kthread);
 
 	if (mask & SAMPLE_EXCEPTION_CNT)
-		map_collect_percpu(map_fds[EXCEPTION_CNT], 0, &rec->exception);
+		for (i = 0; i < XDP_ACTION_MAX; i++)
+			map_collect_percpu(map_fds[EXCEPTION_CNT], i, &rec->exception[i]);
 
 	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
 		map_collect_percpu(map_fds[DEVMAP_XMIT_CNT], 0, &rec->devmap_xmit);
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index a3a3c746e73e..bc0362575d4b 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -59,12 +59,32 @@ extern int tp_cnt;
 
 #define XDP_REDIRECT_ERR_MAX 6
 
-static const char *xdp_redirect_err_names[XDP_REDIRECT_ERR_MAX] = {
+__attribute__((unused)) static const char *xdp_redirect_err_names[XDP_REDIRECT_ERR_MAX] = {
 	/* Key=1 keeps unknown errors */
 	"Success", "Unknown", "EINVAL", "ENETDOWN", "EMSGSIZE",
 	"EOPNOTSUPP",
 };
 
+/* enum xdp_action */
+#define XDP_UNKNOWN (XDP_REDIRECT + 1)
+#define XDP_ACTION_MAX (XDP_UNKNOWN + 1)
+
+static const char *xdp_action_names[XDP_ACTION_MAX] = {
+	[XDP_ABORTED]	= "XDP_ABORTED",
+	[XDP_DROP]	= "XDP_DROP",
+	[XDP_PASS]	= "XDP_PASS",
+	[XDP_TX]	= "XDP_TX",
+	[XDP_REDIRECT]	= "XDP_REDIRECT",
+	[XDP_UNKNOWN]	= "XDP_UNKNOWN",
+};
+
+__attribute__((unused)) static inline const char *action2str(int action)
+{
+	if (action < XDP_ACTION_MAX)
+		return xdp_action_names[action];
+	return NULL;
+}
+
 /* Common stats data record shared with _kern.c */
 struct datarec {
 	__u64 processed;
@@ -88,7 +108,7 @@ struct stats_record {
 	struct record rx_cnt;
 	struct record redir_err[XDP_REDIRECT_ERR_MAX];
 	struct record kthread;
-	struct record exception;
+	struct record exception[XDP_ACTION_MAX];
 	struct record devmap_xmit;
 	struct record enq[];
 };
-- 
2.31.1

