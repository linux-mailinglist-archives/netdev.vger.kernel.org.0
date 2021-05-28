Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B2394957
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhE1Xzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhE1Xzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:48 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9721CC061761;
        Fri, 28 May 2021 16:54:12 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t193so3711672pgb.4;
        Fri, 28 May 2021 16:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8amNBLbzUuPKwP3i6AuNQrdaqZbY4zH/YLcQB8X1ykQ=;
        b=C9dn9RdFf+3hSOeDO49rtb5SDmsS3lCq51FNwh6YDBusMB0WslSzq0ZSKkJFPLONJG
         U8g8Ckc70qEJj4onNosZUOUtYXorZGN1iD4Fw3bCP175RPEnqr4dKG8MPAgmHBHjcpoh
         q+hdbQrndUl/Oro+Cw/qrdzC/EkiW0Y14UHD5nepGuBG39sRLWP2dIsluJ6WnButkq18
         /NkoCDWwFJrhq1D9MblUQq7f2vgXDOetL+RiAvraib1y/qW9OZqL/IZusZhYniNxeFdY
         dEfiqg2G4qrtXKKzaDbWOn1bprJd0+h/I+TEB/7SDUs6CljD7olZw/NKO+0sfnGeoEt8
         /Csw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8amNBLbzUuPKwP3i6AuNQrdaqZbY4zH/YLcQB8X1ykQ=;
        b=KHYGDEbEXyF4pBGc01rS4YkP+OyyMDw9I6PjKJyexiqa0J/athiNItnU1aulbcYLPJ
         wmv7NkYybkl7g4+PS4ivgwyE1LKi7vYSEexYa7iRZHeAqjWl6BqQej6aRFcAhrpLVFuI
         eI+c9b1hpK6gMi34cv4tSW53zYaTtLMDwEklcgP1kSTOfKhJs4JAsK/m16ix4VZj8IyH
         EmJ32nV4SbL5alfd3XKEs9DGexE7WcWdxGo9o9rfbXLAXoG0Y4x3zxz0kRw8j0eJiRZj
         4+0FjW+BVwMqd/I8zvCLls8DJLfONSLGALMrAYoCxCnjp2CKJYuR3vk9UqnyiqN3bqmr
         +JBQ==
X-Gm-Message-State: AOAM530KmyEqUw0vLY/997gv+ukOMH1ocl7JJeUKkhZOIVLjgrkmdOMu
        6q1mZzgtYTnSFVEYz//O3QTxfpXkNBc=
X-Google-Smtp-Source: ABdhPJx7jUyUVHPl71g2uL+QGWbyemvCfztS7p9WZjq0cpst4ChYka/+ZWbcY0TRhF9ybGm8hhNINA==
X-Received: by 2002:a65:584d:: with SMTP id s13mr11542511pgr.97.1622246051443;
        Fri, 28 May 2021 16:54:11 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id c17sm5343412pgm.3.2021.05.28.16.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:11 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 10/15] samples: bpf: implement terse output mode and make it default
Date:   Sat, 29 May 2021 05:22:45 +0530
Message-Id: <20210528235250.2635167-11-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also allow an easy way to go back to the verbose output using Ctrl+\
(SIGQUIT).

One change we make to exception printing is that we skip the per CPU per
action exception count printing (not collection), as it isn't too useful
in general.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                |   2 +-
 samples/bpf/xdp_monitor_user.c      |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c |   6 +-
 samples/bpf/xdp_sample_user.c       | 522 +++++++++++++++++++---------
 samples/bpf/xdp_sample_user.h       |  36 ++
 5 files changed, 402 insertions(+), 166 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 8750233dcf07..d1977fe56dce 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -194,7 +194,7 @@ BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
 endif
 endif
 
-TPROGS_CFLAGS += -Wall -O2
+TPROGS_CFLAGS += -Wall -O2 -lm
 TPROGS_CFLAGS += -Wmissing-prototypes
 TPROGS_CFLAGS += -Wstrict-prototypes
 
diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index babb9fcc1a17..73d6d35f0c65 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -184,7 +184,7 @@ int main(int argc, char **argv)
 		mask |= SAMPLE_REDIRECT_CNT;
 	}
 
-	sample_stats_poll(interval, mask, "xdp_monitor", true);
+	sample_stats_poll(interval, mask, NULL, true);
 
 cleanup:
 	bpf_object__close(obj);
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 6dbed962a2e2..3983ed71d879 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -216,16 +216,18 @@ static void __stats_poll(int interval, bool use_separators, char *prog_name,
 	for (;;) {
 		swap(&prev, &record);
 		sample_stats_collect(mask, record);
-		sample_stats_print(mask, record, prev, prog_name);
+		sample_stats_print(mask, record, prev, NULL);
 		/* Depends on SAMPLE_CPUMAP_KTHREAD_CNT */
 		sample_stats_print_cpumap_remote(record, prev,
 						 bpf_num_possible_cpus(),
 						 mprog_name);
-		printf("\n");
+		if (sample_log_level & LL_DEFAULT)
+			printf("\n");
 		fflush(stdout);
 		sleep(interval);
 		if (stress_mode)
 			stress_cpumap(value);
+		sample_reset_mode();
 	}
 
 	free_stats_record(record);
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 446668edf8d8..d0b26023f1db 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -9,7 +9,9 @@
 #include <stdbool.h>
 #include <string.h>
 #include <unistd.h>
+#include <math.h>
 #include <locale.h>
+#include <sys/signalfd.h>
 #include <sys/resource.h>
 #include <sys/sysinfo.h>
 #include <getopt.h>
@@ -35,6 +37,39 @@
 
 struct bpf_link *tp_links[NUM_TP] = {};
 int map_fds[NUM_MAP], tp_cnt, n_cpus;
+static int sample_sig_fd;
+enum log_level sample_log_level = LL_SIMPLE;
+static bool err_exp;
+
+#define __sample_print(fmt, cond, printer, ...)                                \
+	({                                                                     \
+		if (cond)                                                      \
+			printer(fmt, ##__VA_ARGS__);                           \
+	})
+
+#define print_always(fmt, ...) __sample_print(fmt, 1, printf, ##__VA_ARGS__)
+#define print_default(fmt, ...)                                                \
+	__sample_print(fmt, sample_log_level & LL_DEFAULT, printf, ##__VA_ARGS__)
+#define __print_err(err, fmt, printer, ...)                                    \
+	({                                                                     \
+		__sample_print(fmt, err > 0 || sample_log_level & LL_DEFAULT,  \
+			       printer, ##__VA_ARGS__);                        \
+		err_exp = err_exp ? true : err > 0;                            \
+	})
+#define print_err(err, fmt, ...) __print_err(err, fmt, printf, ##__VA_ARGS__)
+
+#define __COLUMN(x) "%'10" x " %-13s"
+#define FMT_COLUMNf __COLUMN(".0f")
+#define FMT_COLUMNd __COLUMN("d")
+#define FMT_COLUMNl __COLUMN("llu")
+#define RX(rx) rx, "rx/s"
+#define PPS(pps) pps, "pkt/s"
+#define DROP(drop) drop, "drop/s"
+#define ERR(err) err, "error/s"
+#define HITS(hits) hits, "hit/s"
+#define XMIT(xmit) xmit, "xmit/s"
+#define PASS(pass) pass, "pass/s"
+#define REDIR(redir) redir, "redir/s"
 
 #define NANOSEC_PER_SEC 1000000000 /* 10^9 */
 static __u64 gettime(void)
@@ -121,8 +156,8 @@ struct stats_record *alloc_stats_record(void)
 	}
 	memset(rec, 0, size);
 	rec->rx_cnt.cpu    = alloc_record_per_cpu();
-	rec->redir_err[0].cpu = alloc_record_per_cpu();
-	rec->redir_err[1].cpu = alloc_record_per_cpu();
+	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
+		rec->redir_err[i].cpu = alloc_record_per_cpu();
 	rec->kthread.cpu   = alloc_record_per_cpu();
 	for (i = 0; i < XDP_ACTION_MAX; i++)
 		rec->exception[i].cpu = alloc_record_per_cpu();
@@ -143,8 +178,8 @@ void free_stats_record(struct stats_record *r)
 	for (i = 0; i < XDP_ACTION_MAX; i++)
 		free(r->exception[i].cpu);
 	free(r->kthread.cpu);
-	free(r->redir_err[1].cpu);
-	free(r->redir_err[0].cpu);
+	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
+		free(r->redir_err[i].cpu);
 	free(r->rx_cnt.cpu);
 	free(r);
 }
@@ -161,6 +196,13 @@ static double calc_period(struct record *r, struct record *p)
 	return period_;
 }
 
+static double sample_round(double val)
+{
+	if (val - floor(val) < 0.5)
+		return floor(val);
+	return ceil(val);
+}
+
 static __u64 calc_pps(struct datarec *r, struct datarec *p, double period_)
 {
 	__u64 packets = 0;
@@ -168,7 +210,7 @@ static __u64 calc_pps(struct datarec *r, struct datarec *p, double period_)
 
 	if (period_ > 0) {
 		packets = r->processed - p->processed;
-		pps = packets / period_;
+		pps = sample_round(packets / period_);
 	}
 	return pps;
 }
@@ -180,7 +222,7 @@ static __u64 calc_drop_pps(struct datarec *r, struct datarec *p, double period_)
 
 	if (period_ > 0) {
 		packets = r->dropped - p->dropped;
-		pps = packets / period_;
+		pps = sample_round(packets / period_);
 	}
 	return pps;
 }
@@ -193,7 +235,7 @@ static __u64 calc_errs_pps(struct datarec *r,
 
 	if (period_ > 0) {
 		packets = r->issue - p->issue;
-		pps = packets / period_;
+		pps = sample_round(packets / period_);
 	}
 	return pps;
 }
@@ -206,7 +248,7 @@ static __u64 calc_info_pps(struct datarec *r,
 
 	if (period_ > 0) {
 		packets = r->info - p->info;
-		pps = packets / period_;
+		pps = sample_round(packets / period_);
 	}
 	return pps;
 }
@@ -223,41 +265,52 @@ static void calc_xdp_pps(struct datarec *r, struct datarec *p,
 	}
 }
 
-static void stats_print_rx_cnt(struct stats_record *stats_rec,
-			       struct stats_record *stats_prev,
-			       unsigned int nr_cpus)
+static void stats_get_rx_cnt(struct stats_record *stats_rec,
+			     struct stats_record *stats_prev,
+			     unsigned int nr_cpus, struct sample_output *out)
 {
-	char *fmt_rx = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-	char *fm2_rx = "%-15s %-7s %'-14.0f %'-11.0f\n";
 	struct record *rec, *prev;
 	double t, pps, drop, err;
-	char *errstr = "";
 	int i;
 
 	rec = &stats_rec->rx_cnt;
 	prev = &stats_prev->rx_cnt;
 	t = calc_period(rec, prev);
+
 	for (i = 0; i < nr_cpus; i++) {
 		struct datarec *r = &rec->cpu[i];
 		struct datarec *p = &prev->cpu[i];
+		char str[256];
 
 		pps = calc_pps(r, p, t);
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+
 		drop = calc_drop_pps(r, p, t);
 		err = calc_errs_pps(r, p, t);
-		if (err > 0)
-			errstr = "cpu-dest/err";
-		if (pps > 0)
-			printf(fmt_rx, "XDP-RX", i, pps, drop, err, errstr);
+		print_default("          %-12s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			      str, PPS(pps), DROP(drop), ERR(err));
+	}
+
+	if (out) {
+		pps = calc_pps(&rec->total, &prev->total, t);
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		err = calc_errs_pps(&rec->total, &prev->total, t);
+
+		out->rx_cnt.pps = pps;
+		out->rx_cnt.drop = drop;
+		out->rx_cnt.err = err;
+		out->totals.rx += pps;
+		out->totals.drop += drop;
+		out->totals.err += err;
 	}
-	pps = calc_pps(&rec->total, &prev->total, t);
-	drop = calc_drop_pps(&rec->total, &prev->total, t);
-	err = calc_errs_pps(&rec->total, &prev->total, t);
-	printf(fm2_rx, "XDP-RX", "total", pps, drop);
 }
 
-static void stats_print_cpumap_enqueue(struct stats_record *stats_rec,
-				       struct stats_record *stats_prev,
-				       unsigned int nr_cpus)
+static void stats_get_cpumap_enqueue(struct stats_record *stats_rec,
+				     struct stats_record *stats_prev,
+				     unsigned int nr_cpus)
 {
 	struct record *rec, *prev;
 	double t, pps, drop, err;
@@ -265,83 +318,88 @@ static void stats_print_cpumap_enqueue(struct stats_record *stats_rec,
 
 	/* cpumap enqueue stats */
 	for (to_cpu = 0; to_cpu < n_cpus; to_cpu++) {
-		char *fmt = "%-15s %3d:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *fm2 = "%-15s %3s:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *errstr = "";
-
 		rec  =  &stats_rec->enq[to_cpu];
 		prev = &stats_prev->enq[to_cpu];
 		t = calc_period(rec, prev);
+
+		pps = calc_pps(&rec->total, &prev->total, t);
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		err = calc_errs_pps(&rec->total, &prev->total, t);
+
+		if (pps > 0) {
+			char str[256];
+
+			snprintf(str, sizeof(str), "enqueue to cpu %d", to_cpu);
+
+			if (err > 0)
+				err = pps / err; /* calc average bulk size */
+			print_default("  %-20s " FMT_COLUMNf FMT_COLUMNf __COLUMN(".2f") "\n",
+				      str, PPS(pps), DROP(drop), err, "bulk_avg");
+		}
+
 		for (i = 0; i < nr_cpus; i++) {
 			struct datarec *r = &rec->cpu[i];
 			struct datarec *p = &prev->cpu[i];
+			char str[256];
 
 			pps  = calc_pps(r, p, t);
+			if (!pps)
+				continue;
+
+			snprintf(str, sizeof(str), "cpu:%d->%d", i, to_cpu);
+
 			drop = calc_drop_pps(r, p, t);
 			err  = calc_errs_pps(r, p, t);
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
+			if (err > 0)
 				err = pps / err; /* calc average bulk size */
-			}
-			printf(fm2, "cpumap-enqueue",
-			       "sum", to_cpu, pps, drop, err, errstr);
+			print_default("          %-12s " FMT_COLUMNf FMT_COLUMNf
+				      __COLUMN(".2f") "\n", str, PPS(pps), DROP(drop),
+				      err, "bulk_avg");
 		}
 	}
 }
 
-static void stats_print_cpumap_kthread(struct stats_record *stats_rec,
-				       struct stats_record *stats_prev,
-				       unsigned int nr_cpus)
+static void stats_get_cpumap_kthread(struct stats_record *stats_rec,
+				     struct stats_record *stats_prev,
+				     unsigned int nr_cpus)
 {
-	char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-	char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s\n";
 	struct record *rec, *prev;
 	double t, pps, drop, err;
-	char *e_str = "";
 	int i;
 
 	rec = &stats_rec->kthread;
 	prev = &stats_prev->kthread;
 	t = calc_period(rec, prev);
+
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	err = calc_errs_pps(&rec->total, &prev->total, t);
+
+	print_default("  %-20s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n", "kthread total",
+		      PPS(pps), DROP(drop), err, "sched");
+
 	for (i = 0; i < nr_cpus; i++) {
 		struct datarec *r = &rec->cpu[i];
 		struct datarec *p = &prev->cpu[i];
+		char str[256];
 
 		pps = calc_pps(r, p, t);
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+
 		drop = calc_drop_pps(r, p, t);
 		err = calc_errs_pps(r, p, t);
-		if (err > 0)
-			e_str = "sched";
-		if (pps > 0)
-			printf(fmt_k, "cpumap_kthread", i, pps, drop, err,
-			       e_str);
+		print_default("          %-12s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			      str, PPS(pps), DROP(drop), err, "sched");
 	}
-	pps = calc_pps(&rec->total, &prev->total, t);
-	drop = calc_drop_pps(&rec->total, &prev->total, t);
-	err = calc_errs_pps(&rec->total, &prev->total, t);
-	if (err > 0)
-		e_str = "sched-sum";
-	printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
 }
 
-static void stats_print_redirect_cnt(struct stats_record *stats_rec,
-				     struct stats_record *stats_prev,
-				     unsigned int nr_cpus)
+static void stats_get_redirect_cnt(struct stats_record *stats_rec,
+				   struct stats_record *stats_prev,
+				   unsigned int nr_cpus, struct sample_output *out)
 {
-	char *fmt1 = "%-15s %-7d %'-14.0f %'-11.0f %s\n";
-	char *fmt2 = "%-15s %-7s %'-14.0f %'-11.0f %s\n";
 	struct record *rec, *prev;
 	double t, pps;
 	int i;
@@ -352,68 +410,106 @@ static void stats_print_redirect_cnt(struct stats_record *stats_rec,
 	for (i = 0; i < nr_cpus; i++) {
 		struct datarec *r = &rec->cpu[i];
 		struct datarec *p = &prev->cpu[i];
+		char str[256];
 
 		pps = calc_pps(r, p, t);
-		if (pps > 0)
-			printf(fmt1, "redirect", i, pps, 0.0, "Success");
-	}
-	pps = calc_pps(&rec->total, &prev->total, t);
-	printf(fmt2, "redirect", "total", pps, 0.0, "Success");
-}
+		if (!pps)
+			continue;
 
-static void stats_print_redirect_err_cnt(struct stats_record *stats_rec,
-					 struct stats_record *stats_prev,
-					 unsigned int nr_cpus)
-{
-	char *fmt1 = "%-15s %-7d %'-14.0f %'-11.0f %s\n";
-	char *fmt2 = "%-15s %-7s %'-14.0f %'-11.0f %s\n";
-	struct record *rec, *prev;
-	double t, drop;
-	int i;
+		snprintf(str, sizeof(str), "cpu:%d", i);
 
-	rec = &stats_rec->redir_err[1];
-	prev = &stats_prev->redir_err[1];
-	t = calc_period(rec, prev);
-	for (i = 0; i < nr_cpus; i++) {
-		struct datarec *r = &rec->cpu[i];
-		struct datarec *p = &prev->cpu[i];
+		print_default("           %-11s " FMT_COLUMNf "\n", str, REDIR(pps));
+	}
 
-		drop = calc_drop_pps(r, p, t);
-		if (drop > 0)
-			printf(fmt1, "redirect", i, 0.0, drop, "Error");
+	if (out) {
+		pps = calc_pps(&rec->total, &prev->total, t);
+		out->redir_cnt.suc = pps;
+		out->totals.redir += pps;
 	}
-	drop = calc_drop_pps(&rec->total, &prev->total, t);
-	printf(fmt2, "redirect", "total", 0.0, drop, "Error");
+
 }
 
-static void stats_print_exception_cnt(struct stats_record *stats_rec,
-				      struct stats_record *stats_prev,
-				      unsigned int nr_cpus)
+static void stats_get_redirect_err_cnt(struct stats_record *stats_rec,
+				       struct stats_record *stats_prev,
+				       unsigned int nr_cpus, struct sample_output *out)
 {
-	char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %s\n";
-	char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %s\n";
 	struct record *rec, *prev;
-	double t, drop;
+	double t, drop, sum = 0;
 	int rec_i, i;
 
-	for (rec_i = 0; rec_i < XDP_ACTION_MAX; rec_i++) {
-		rec  = &stats_rec->exception[rec_i];
-		prev = &stats_prev->exception[rec_i];
+	for (rec_i = 1; rec_i < XDP_REDIRECT_ERR_MAX; rec_i++) {
+		char str[256];
+		int l = 0;
+
+		rec = &stats_rec->redir_err[rec_i];
+		prev = &stats_prev->redir_err[rec_i];
 		t = calc_period(rec, prev);
 
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		if (drop > 0 && !out) {
+			l = snprintf(str, sizeof(str),
+				     sample_log_level & LL_DEFAULT ?
+						   "%s total" :
+						   "%s",
+				     xdp_redirect_err_names[rec_i]);
+			l = l >= sizeof(str) ? sizeof(str) - 1 : l;
+			print_err(drop, "    %-18s " FMT_COLUMNf "\n", str,
+				      ERR(drop));
+		}
+
 		for (i = 0; i < nr_cpus; i++) {
 			struct datarec *r = &rec->cpu[i];
 			struct datarec *p = &prev->cpu[i];
+			double drop;
+			int sp, ll;
 
 			drop = calc_drop_pps(r, p, t);
-			if (drop > 0)
-				printf(fmt1, "xdp_exception", i,
-				       0.0, drop, action2str(rec_i));
+			if (!drop)
+				continue;
+
+			ll = snprintf(str, sizeof(str), "cpu:%d", i);
+			ll = ll >= sizeof(str) ? sizeof(str) - 1 : ll;
+
+			sp = l - ll > 0 ? l - ll : 0;
+			ll = 19 - sp > 0 ? 19 - sp : 0;
+
+			/* Align dynamically under error string */
+			print_default("    %*c%-*s" FMT_COLUMNf "\n", sp, ' ', ll, str, ERR(drop));
 		}
+
+		sum += drop;
+	}
+
+	if (out) {
+		out->redir_cnt.err = sum;
+		out->totals.err += sum;
+	}
+}
+
+static void stats_get_exception_cnt(struct stats_record *stats_rec,
+				    struct stats_record *stats_prev,
+				    unsigned int nr_cpus, struct sample_output *out)
+{
+	double t, drop, sum = 0;
+	struct record *rec, *prev;
+	int rec_i;
+
+
+	for (rec_i = 0; rec_i < XDP_ACTION_MAX; rec_i++) {
+		rec  = &stats_rec->exception[rec_i];
+		prev = &stats_prev->exception[rec_i];
+		t = calc_period(rec, prev);
+
 		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		if (drop > 0)
-			printf(fmt2, "xdp_exception", "total",
-			       0.0, drop, action2str(rec_i));
+		/* Fold out errors after heading */
+		if (drop > 0 && !out)
+			print_always("    %-18s " FMT_COLUMNf "\n", action2str(rec_i), ERR(drop));
+		sum += drop;
+	}
+
+	if (out) {
+		out->except_cnt.hits = sum;
+		out->totals.err += sum;
 	}
 }
 
@@ -421,16 +517,12 @@ void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
 				      struct stats_record *stats_prev,
 				      unsigned int nr_cpus, char *mprog_name)
 {
-	char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f\n";
-	char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f\n";
 	double xdp_pass, xdp_drop, xdp_redirect;
 	struct record *rec, *prev;
 	double t;
 	int i;
 
-	printf("\n2nd remote XDP/eBPF prog_name: %s\n", mprog_name ?: "(none)");
-	printf("%-15s %-7s %-14s %-11s %-9s\n", "XDP-cpumap", "CPU:to",
-	       "xdp-pass", "xdp-drop", "xdp-redir");
+	print_default("\n2nd remote XDP/eBPF prog_name: %s\n", mprog_name ?: "(none)");
 
 	rec = &stats_rec->kthread;
 	prev = &stats_prev->kthread;
@@ -438,28 +530,28 @@ void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
 	for (i = 0; i < nr_cpus; i++) {
 		struct datarec *r = &rec->cpu[i];
 		struct datarec *p = &prev->cpu[i];
+		char str[256];
 
 		calc_xdp_pps(r, p, &xdp_pass, &xdp_drop, &xdp_redirect, t);
-		if (xdp_pass > 0 || xdp_drop > 0 || xdp_redirect > 0)
-			printf(fmt_k, "xdp-in-kthread", i, xdp_pass, xdp_drop,
-			       xdp_redirect);
+		if (!xdp_pass || !xdp_drop || !xdp_redirect)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		print_default("                 %-5s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			      str, PASS(xdp_pass), DROP(xdp_drop), REDIR(xdp_redirect));
 	}
 	calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
 		     &xdp_redirect, t);
-	printf(fm2_k, "xdp-in-kthread", "total", xdp_pass, xdp_drop,
-	       xdp_redirect);
+	print_default("  %-20s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+		      "xdp_in_kthread total", PASS(xdp_pass), DROP(xdp_drop), REDIR(xdp_redirect));
 }
 
-static void stats_print_devmap_xmit(struct stats_record *stats_rec,
-				    struct stats_record *stats_prev,
-				    unsigned int nr_cpus)
+static void stats_get_devmap_xmit(struct stats_record *stats_rec,
+				  struct stats_record *stats_prev,
+				  unsigned int nr_cpus, struct sample_output *out)
 {
-	char *fmt1 = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s %s\n";
-	char *fmt2 = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s %s\n";
 	double pps, drop, info, err;
 	struct record *rec, *prev;
-	char *err_str = "";
-	char *i_str = "";
 	double t;
 	int i;
 
@@ -469,32 +561,114 @@ static void stats_print_devmap_xmit(struct stats_record *stats_rec,
 	for (i = 0; i < nr_cpus; i++) {
 		struct datarec *r = &rec->cpu[i];
 		struct datarec *p = &prev->cpu[i];
+		char str[256];
 
 		pps = calc_pps(r, p, t);
 		drop = calc_drop_pps(r, p, t);
+
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+
 		info = calc_info_pps(r, p, t);
 		err = calc_errs_pps(r, p, t);
-		if (info > 0) {
-			i_str = "bulk-average";
+		if (info > 0)
 			info = (pps + drop) / info; /* calc avg bulk */
-		}
-		if (err > 0)
-			err_str = "drv-err";
-		if (pps > 0 || drop > 0)
-			printf(fmt1, "devmap-xmit", i, pps, drop, info, i_str,
-			       err_str);
+		print_default("              %-9s" FMT_COLUMNf FMT_COLUMNf
+			      FMT_COLUMNf __COLUMN(".2f") "\n",
+			      str, XMIT(pps), DROP(drop), err, "drv_err/s",
+			      info, "bulk_avg");
 	}
-	pps = calc_pps(&rec->total, &prev->total, t);
-	drop = calc_drop_pps(&rec->total, &prev->total, t);
-	info = calc_info_pps(&rec->total, &prev->total, t);
-	err = calc_errs_pps(&rec->total, &prev->total, t);
-	if (info > 0) {
-		i_str = "bulk-average";
-		info = (pps + drop) / info; /* calc avg bulk */
+	if (out) {
+		pps = calc_pps(&rec->total, &prev->total, t);
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		info = calc_info_pps(&rec->total, &prev->total, t);
+		if (info > 0)
+			info = (pps + drop) / info; /* calc avg bulk */
+		err = calc_errs_pps(&rec->total, &prev->total, t);
+
+		out->xmit_cnt.pps = pps;
+		out->xmit_cnt.drop = drop;
+		out->xmit_cnt.bavg = info;
+		out->xmit_cnt.err = err;
+		out->totals.xmit += pps;
+		out->totals.err += err;
+	}
+}
+
+static void stats_print(const char *prefix, int mask, struct stats_record *r,
+			struct stats_record *p, struct sample_output *out)
+{
+	int nr_cpus = bpf_num_possible_cpus();
+	const char *str;
+
+	print_always("%-23s", prefix ?: "Summary");
+	if (mask & SAMPLE_RX_CNT)
+		print_always(FMT_COLUMNl, RX(out->totals.rx));
+	if (mask & SAMPLE_REDIRECT_CNT)
+		print_always(FMT_COLUMNl, REDIR(out->totals.redir));
+	printf(FMT_COLUMNl, ERR(out->totals.err + out->totals.drop));
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
+		printf(FMT_COLUMNl, XMIT(out->totals.xmit));
+	printf("\n");
+
+	if (mask & SAMPLE_RX_CNT) {
+		str = (sample_log_level & LL_DEFAULT) && out->rx_cnt.pps ?
+			"receive total" : "receive";
+		print_err(
+			(out->rx_cnt.err || out->rx_cnt.drop),
+			"  %-20s " FMT_COLUMNl FMT_COLUMNl FMT_COLUMNl "\n",
+			str, PPS(out->rx_cnt.pps), DROP(out->rx_cnt.drop),
+			ERR(out->rx_cnt.err));
+
+		stats_get_rx_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
+		stats_get_cpumap_enqueue(r, p, nr_cpus);
+	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT)
+		stats_get_cpumap_kthread(r, p, nr_cpus);
+
+	if (mask & SAMPLE_REDIRECT_CNT) {
+		str = out->redir_cnt.suc ? "redirect total" : "redirect";
+		print_default("  %-20s " FMT_COLUMNl "\n", str, REDIR(out->redir_cnt.suc));
+
+		stats_get_redirect_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_REDIRECT_ERR_CNT) {
+		str = (sample_log_level & LL_DEFAULT) && out->redir_cnt.err ?
+			"redirect_err total" : "redirect_err";
+		print_err(out->redir_cnt.err, "  %-20s " FMT_COLUMNl "\n", str,
+			  ERR(out->redir_cnt.err));
+
+		stats_get_redirect_err_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_EXCEPTION_CNT) {
+		str = out->except_cnt.hits ? "xdp_exception total" : "xdp_exception";
+		print_err(out->except_cnt.hits, "  %-20s " FMT_COLUMNl "\n",
+			  str, HITS(out->except_cnt.hits));
+
+		stats_get_exception_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT) {
+		str = (sample_log_level & LL_DEFAULT) && out->xmit_cnt.pps ?
+			"devmap_xmit total" : "devmap_xmit";
+		print_err(out->xmit_cnt.err,
+			  "  %-20s " FMT_COLUMNl FMT_COLUMNl FMT_COLUMNl __COLUMN(".2f") "\n",
+			  str, XMIT(out->xmit_cnt.pps), DROP(out->xmit_cnt.drop),
+			  out->xmit_cnt.err, "drv_err/s", out->xmit_cnt.bavg, "bulk_avg");
+
+		stats_get_devmap_xmit(r, p, nr_cpus, NULL);
+	}
+
+	if (sample_log_level & LL_DEFAULT || ((sample_log_level & LL_SIMPLE) && err_exp)) {
+		err_exp = false;
+		printf("\n");
 	}
-	if (err > 0)
-		err_str = "drv-err";
-	printf(fmt2, "devmap-xmit", "total", pps, drop, info, i_str, err_str);
 }
 
 static int init_tracepoints(struct bpf_object *obj)
@@ -534,15 +708,47 @@ static int init_map_fds(struct bpf_object *obj)
 
 int sample_init(struct bpf_object *obj)
 {
+	sigset_t st;
+
 	n_cpus = get_nprocs_conf();
+
+	sigemptyset(&st);
+	sigaddset(&st, SIGQUIT);
+
+	if (sigprocmask(SIG_BLOCK, &st, NULL) < 0)
+		return -errno;
+
+	sample_sig_fd = signalfd(-1, &st, SFD_CLOEXEC|SFD_NONBLOCK);
+	if (sample_sig_fd < 0)
+		return -errno;
+
 	return init_tracepoints(obj) ? : init_map_fds(obj);
 }
 
+void sample_reset_mode(void)
+{
+	struct signalfd_siginfo si;
+	int r;
+
+	r = read(sample_sig_fd, &si, sizeof(si));
+	if (r < 0) {
+		if (errno == EAGAIN)
+			return;
+		return;
+	}
+
+	if (si.ssi_signo == SIGQUIT) {
+		sample_log_level ^= LL_DEBUG - 1;
+		printf("\n");
+	}
+}
+
 void sample_exit(int status)
 {
 	while (tp_cnt)
 		bpf_link__destroy(tp_links[--tp_cnt]);
 
+	close(sample_sig_fd);
 	exit(status);
 }
 
@@ -580,32 +786,24 @@ void sample_stats_collect(int mask, struct stats_record *rec)
 void sample_stats_print(int mask, struct stats_record *cur,
 			struct stats_record *prev, char *prog_name)
 {
-	int nr_cpus = bpf_num_possible_cpus();
-
-	printf("Running XDP/eBPF prog_name:%s\n", prog_name ?: "(none)");
-	printf("%-15s %-7s %-14s %-11s %-9s\n",
-	       "XDP-event", "CPU:to", "pps", "drop-pps", "extra-info");
+	struct sample_output out = {};
 
 	if (mask & SAMPLE_RX_CNT)
-		stats_print_rx_cnt(cur, prev, nr_cpus);
+		stats_get_rx_cnt(cur, prev, 0, &out);
 
 	if (mask & SAMPLE_REDIRECT_CNT)
-		stats_print_redirect_cnt(cur, prev, nr_cpus);
+		stats_get_redirect_cnt(cur, prev, 0, &out);
 
 	if (mask & SAMPLE_REDIRECT_ERR_CNT)
-		stats_print_redirect_err_cnt(cur, prev, nr_cpus);
-
-	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
-		stats_print_cpumap_enqueue(cur, prev, nr_cpus);
-
-	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT)
-		stats_print_cpumap_kthread(cur, prev, nr_cpus);
+		stats_get_redirect_err_cnt(cur, prev, 0, &out);
 
 	if (mask & SAMPLE_EXCEPTION_CNT)
-		stats_print_exception_cnt(cur, prev, nr_cpus);
+		stats_get_exception_cnt(cur, prev, 0, &out);
 
 	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
-		stats_print_devmap_xmit(cur, prev, nr_cpus);
+		stats_get_devmap_xmit(cur, prev, 0, &out);
+
+	stats_print(prog_name, mask, cur, prev, &out);
 }
 
 void sample_stats_poll(int interval, int mask, char *prog_name, int use_separators)
@@ -623,10 +821,10 @@ void sample_stats_poll(int interval, int mask, char *prog_name, int use_separato
 	for (;;) {
 		swap(&prev, &record);
 		sample_stats_collect(mask, record);
-		sample_stats_print(mask, record, prev, NULL);
-		printf("\n");
+		sample_stats_print(mask, record, prev, prog_name);
 		fflush(stdout);
 		sleep(interval);
+		sample_reset_mode();
 	}
 
 	free_stats_record(record);
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index bc0362575d4b..6ca934b346ef 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -44,10 +44,17 @@ static const char *const map_type_strings[] = {
 	[DEVMAP_XMIT_CNT] = "devmap_xmit_cnt",
 };
 
+enum log_level {
+	LL_DEFAULT = 1U << 0,
+	LL_SIMPLE  = 1U << 1,
+	LL_DEBUG   = 1U << 2,
+};
+
 extern struct bpf_link *tp_links[NUM_TP];
 extern int map_fds[NUM_MAP];
 extern int n_cpus;
 extern int tp_cnt;
+extern enum log_level sample_log_level;
 
 /* Exit return codes */
 #define EXIT_OK			0
@@ -113,6 +120,34 @@ struct stats_record {
 	struct record enq[];
 };
 
+struct sample_output {
+	struct {
+		__u64 rx;
+		__u64 redir;
+		__u64 drop;
+		__u64 err;
+		__u64 xmit;
+	} totals;
+	struct {
+		__u64 pps;
+		__u64 drop;
+		__u64 err;
+	} rx_cnt;
+	struct {
+		__u64 suc;
+		__u64 err;
+	} redir_cnt;
+	struct {
+		__u64 hits;
+	} except_cnt;
+	struct {
+		__u64 pps;
+		__u64 drop;
+		__u64 err;
+		double bavg;
+	} xmit_cnt;
+};
+
 int sample_init(struct bpf_object *obj);
 void sample_exit(int status);
 struct stats_record *alloc_stats_record(void);
@@ -125,6 +160,7 @@ void sample_stats_poll(int interval, int mask, char *prog_name,
 void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
 				      struct stats_record *stats_prev,
 				      unsigned int nr_cpus, char *mprog_name);
+void sample_reset_mode(void);
 
 const char *get_driver_name(int ifindex);
 int get_mac_addr(int ifindex, void *mac_addr);
-- 
2.31.1

