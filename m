Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E640394959
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE1Xzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhE1Xzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:52 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD21C061574;
        Fri, 28 May 2021 16:54:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j12so3699436pgh.7;
        Fri, 28 May 2021 16:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HOsaKyuguNk7X64KL0+mdKcQaE9q+46io+EdBwhI/HE=;
        b=bPylqBLWgQa8zPT+3Zvf4SfE73L9k3zd2769uiQpzz7BIBvZr2oL6MaqXTWUhrh72S
         +hjIom7pR2KC0BnSo7CrGGOKKN2r0vSkSBRBFBap7jVh3e8RtGKcodmOuA8okd3dN3Uq
         wjG2oRVNUcTZGigpsG+DKRg7vP1ZWeIzS1H2mEqD862yHgUZgxdX5A5Ml2SeXuzm1T7W
         0LxhfTWX0wMSsPvkEJx9KioJ06njDiQRRhLOAGliMDI4Ak9zx64Yp+DUAEWMDHSJShsw
         0gPE2ZgnNKgSc/4AjBvcizqmfS+CQ7PlDhJmQt0kz9cSrktoGzGz/XZAfZp1BWw4LQwh
         Y+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HOsaKyuguNk7X64KL0+mdKcQaE9q+46io+EdBwhI/HE=;
        b=dZ6V3JVLc6phTk4aS3Uccec0Tg7kR8zN+uGov4TACRUrjQNeZgCe4yQnOC/fGCnaM9
         HTBMSMfaAKqcU12wE09nQIK0GK/hvMkrWM0sGuMaHhEJbbRkeuZE3Li4havXd5LycnSS
         euN6Xdl5sBPu0WCeOWDrbPhmNnNCVGyUyE7CzdVi3r7psLmzOBkwlBOaAwdoXBVF7UlV
         Omqa5zNp2HR7zbl6rvqjdP6tdyeMQU6KSQsrJezn65ZaxYA2wyaH0UTD+/sFnUO3MQGW
         /Tz4kFEGDlZz9dmEacAVi41CskdzCnrUeXqm/sEgerVdi/tHNIvyZrwkLVeQ2KilSEDQ
         ffJw==
X-Gm-Message-State: AOAM530nme0HixRGEvvMMDqsoUOnt2xIZ9GZw1XW/AO10UGkxNmpa/30
        hS57CbHj84ms9+FpVI7xXIqf0VmVFWA=
X-Google-Smtp-Source: ABdhPJwYf/eKOjmugknMYst3VHTlQU0LjqYyBRW4jUNFwsFyRrCpWn8sCuQlvtYksh2RcchgoqyV5Q==
X-Received: by 2002:aa7:9a8e:0:b029:2e7:e3fd:4fa4 with SMTP id w14-20020aa79a8e0000b02902e7e3fd4fa4mr6358497pfi.63.1622246054931;
        Fri, 28 May 2021 16:54:14 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id y66sm4986604pgb.14.2021.05.28.16.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:14 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 11/15] samples: bpf: print summary of session on exit
Date:   Sat, 29 May 2021 05:22:46 +0530
Message-Id: <20210528235250.2635167-12-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This collects total statistics and prints the totals and averages for
main attributes when exiting. These are collected on each polling
interval.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_redirect_cpu_user.c |   2 +-
 samples/bpf/xdp_redirect_map_user.c |   2 +-
 samples/bpf/xdp_sample_user.c       | 141 +++++++++++++++++++++++++---
 samples/bpf/xdp_sample_user.h       |  22 +++--
 4 files changed, 145 insertions(+), 22 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 3983ed71d879..4c9f32229508 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -216,7 +216,7 @@ static void __stats_poll(int interval, bool use_separators, char *prog_name,
 	for (;;) {
 		swap(&prev, &record);
 		sample_stats_collect(mask, record);
-		sample_stats_print(mask, record, prev, NULL);
+		sample_stats_print(mask, record, prev, NULL, interval);
 		/* Depends on SAMPLE_CPUMAP_KTHREAD_CNT */
 		sample_stats_print_cpumap_remote(record, prev,
 						 bpf_num_possible_cpus(),
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index b2c7adad99ec..ed53dd2cd93a 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -75,7 +75,7 @@ static void usage(const char *prog)
 
 int main(int argc, char **argv)
 {
-	int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_CNT |
+	int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
 		   SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT;
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index d0b26023f1db..909257ffe54c 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -26,8 +26,10 @@
 #define SIOCETHTOOL 0x8946
 #endif
 
+#include <fcntl.h>
 #include <arpa/inet.h>
 #include <linux/if_link.h>
+#include <sys/utsname.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -39,6 +41,7 @@ struct bpf_link *tp_links[NUM_TP] = {};
 int map_fds[NUM_MAP], tp_cnt, n_cpus;
 static int sample_sig_fd;
 enum log_level sample_log_level = LL_SIMPLE;
+static struct sample_output sum_out;
 static bool err_exp;
 
 #define __sample_print(fmt, cond, printer, ...)                                \
@@ -58,6 +61,9 @@ static bool err_exp;
 	})
 #define print_err(err, fmt, ...) __print_err(err, fmt, printf, ##__VA_ARGS__)
 
+#define print_link_err(err, str, width, type)                                  \
+	__print_err(err, str, print_link, width, type)
+
 #define __COLUMN(x) "%'10" x " %-13s"
 #define FMT_COLUMNf __COLUMN(".0f")
 #define FMT_COLUMNd __COLUMN("d")
@@ -71,6 +77,66 @@ static bool err_exp;
 #define PASS(pass) pass, "pass/s"
 #define REDIR(redir) redir, "redir/s"
 
+static const char *elixir_search[NUM_TP] = {
+	[TP_REDIRECT_CNT] = "_trace_xdp_redirect",
+	[TP_REDIRECT_MAP_CNT] = "_trace_xdp_redirect_map",
+	[TP_REDIRECT_ERR_CNT] = "_trace_xdp_redirect_err",
+	[TP_REDIRECT_MAP_ERR_CNT] = "_trace_xdp_redirect_map_err",
+	[TP_CPUMAP_ENQUEUE_CNT] = "trace_xdp_cpumap_enqueue",
+	[TP_CPUMAP_KTHREAD_CNT] = "trace_xdp_cpumap_kthread",
+	[TP_EXCEPTION_CNT] = "trace_xdp_exception",
+	[TP_DEVMAP_XMIT_CNT] = "trace_xdp_devmap_xmit",
+};
+
+static const char *make_url(enum tp_type i)
+{
+	const char *key = elixir_search[i];
+	static struct utsname uts = {};
+	static char url[128];
+	static bool uts_init;
+	int maj, min;
+	char c[2];
+
+	if (!uts_init) {
+		if (uname(&uts) < 0)
+			return NULL;
+		uts_init = true;
+	}
+
+	if (!key || sscanf(uts.release, "%d.%d%1s", &maj, &min, c) != 3)
+		return NULL;
+
+	snprintf(url, sizeof(url), "https://elixir.bootlin.com/linux/v%d.%d/C/ident/%s",
+		 maj, min, key);
+
+	return url;
+}
+
+static void print_link(const char *str, int width, enum tp_type i)
+{
+	static int t = -1;
+	const char *s;
+	int fd, l;
+
+	if (t < 0) {
+		fd = open("/proc/self/fd/1", O_RDONLY);
+		if (fd < 0)
+			return;
+		t = isatty(fd);
+		close(fd);
+	}
+
+	s = make_url(i);
+	if (!s || !t) {
+		printf("  %-*s", width, str);
+		return;
+	}
+
+	l = strlen(str);
+	width = width - l > 0 ? width - l : 0;
+	printf("  \x1B]8;;%s\a%s\x1B]8;;\a%*c", s, str, width, ' ');
+}
+
 #define NANOSEC_PER_SEC 1000000000 /* 10^9 */
 static __u64 gettime(void)
 {
@@ -333,8 +399,11 @@ static void stats_get_cpumap_enqueue(struct stats_record *stats_rec,
 
 			if (err > 0)
 				err = pps / err; /* calc average bulk size */
-			print_default("  %-20s " FMT_COLUMNf FMT_COLUMNf __COLUMN(".2f") "\n",
-				      str, PPS(pps), DROP(drop), err, "bulk_avg");
+
+			print_link_err(drop, str, 20, TP_CPUMAP_ENQUEUE_CNT);
+			print_err(drop,
+				  " " FMT_COLUMNf FMT_COLUMNf __COLUMN(".2f") "\n",
+				  PPS(pps), DROP(drop), err, "bulk_avg");
 		}
 
 		for (i = 0; i < nr_cpus; i++) {
@@ -375,8 +444,9 @@ static void stats_get_cpumap_kthread(struct stats_record *stats_rec,
 	drop = calc_drop_pps(&rec->total, &prev->total, t);
 	err = calc_errs_pps(&rec->total, &prev->total, t);
 
-	print_default("  %-20s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n", "kthread total",
-		      PPS(pps), DROP(drop), err, "sched");
+	print_link_err(drop, pps ? "kthread total" : "kthread", 20, TP_CPUMAP_KTHREAD_CNT);
+	print_err(drop, " " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			  PPS(pps), DROP(drop), err, "sched");
 
 	for (i = 0; i < nr_cpus; i++) {
 		struct datarec *r = &rec->cpu[i];
@@ -632,7 +702,9 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 
 	if (mask & SAMPLE_REDIRECT_CNT) {
 		str = out->redir_cnt.suc ? "redirect total" : "redirect";
-		print_default("  %-20s " FMT_COLUMNl "\n", str, REDIR(out->redir_cnt.suc));
+		print_link_err(0, str, 20, mask & _SAMPLE_REDIRECT_MAP ?
+				TP_REDIRECT_MAP_CNT : TP_REDIRECT_CNT);
+		print_default(" " FMT_COLUMNl "\n", REDIR(out->redir_cnt.suc));
 
 		stats_get_redirect_cnt(r, p, nr_cpus, NULL);
 	}
@@ -640,6 +712,8 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 	if (mask & SAMPLE_REDIRECT_ERR_CNT) {
 		str = (sample_log_level & LL_DEFAULT) && out->redir_cnt.err ?
 			"redirect_err total" : "redirect_err";
+		print_link_err(out->redir_cnt.err, str, 20, mask & _SAMPLE_REDIRECT_MAP ?
+			       TP_REDIRECT_MAP_ERR_CNT : TP_REDIRECT_ERR_CNT);
 		print_err(out->redir_cnt.err, "  %-20s " FMT_COLUMNl "\n", str,
 			  ERR(out->redir_cnt.err));
 
@@ -648,8 +722,9 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 
 	if (mask & SAMPLE_EXCEPTION_CNT) {
 		str = out->except_cnt.hits ? "xdp_exception total" : "xdp_exception";
-		print_err(out->except_cnt.hits, "  %-20s " FMT_COLUMNl "\n",
-			  str, HITS(out->except_cnt.hits));
+
+		print_link_err(out->except_cnt.hits, str, 20, TP_EXCEPTION_CNT);
+		print_err(out->except_cnt.hits, " " FMT_COLUMNl "\n", HITS(out->except_cnt.hits));
 
 		stats_get_exception_cnt(r, p, nr_cpus, NULL);
 	}
@@ -657,9 +732,11 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 	if (mask & SAMPLE_DEVMAP_XMIT_CNT) {
 		str = (sample_log_level & LL_DEFAULT) && out->xmit_cnt.pps ?
 			"devmap_xmit total" : "devmap_xmit";
+
+		print_link_err(out->xmit_cnt.err, str, 20, TP_DEVMAP_XMIT_CNT);
 		print_err(out->xmit_cnt.err,
-			  "  %-20s " FMT_COLUMNl FMT_COLUMNl FMT_COLUMNl __COLUMN(".2f") "\n",
-			  str, XMIT(out->xmit_cnt.pps), DROP(out->xmit_cnt.drop),
+			  " " FMT_COLUMNl FMT_COLUMNl FMT_COLUMNl __COLUMN(".2f") "\n",
+			  XMIT(out->xmit_cnt.pps), DROP(out->xmit_cnt.drop),
 			  out->xmit_cnt.err, "drv_err/s", out->xmit_cnt.bavg, "bulk_avg");
 
 		stats_get_devmap_xmit(r, p, nr_cpus, NULL);
@@ -747,7 +824,7 @@ void sample_exit(int status)
 {
 	while (tp_cnt)
 		bpf_link__destroy(tp_links[--tp_cnt]);
-
+	sample_summary_print();
 	close(sample_sig_fd);
 	exit(status);
 }
@@ -783,8 +860,46 @@ void sample_stats_collect(int mask, struct stats_record *rec)
 		map_collect_percpu(map_fds[DEVMAP_XMIT_CNT], 0, &rec->devmap_xmit);
 }
 
+void sample_summary_update(struct sample_output *out, int interval)
+{
+	sum_out.totals.rx += out->totals.rx;
+	sum_out.totals.redir += out->totals.redir;
+	sum_out.totals.drop += out->totals.drop;
+	sum_out.totals.err += out->totals.err;
+	sum_out.totals.xmit += out->totals.xmit;
+	sum_out.rx_cnt.pps += interval;
+}
+
+void sample_summary_print(void)
+{
+	double period = sum_out.rx_cnt.pps;
+
+	print_always("\nTotals\n");
+	if (sum_out.totals.rx) {
+		double pkts = sum_out.totals.rx;
+
+		print_always("  Packets received    : %'-10llu\n", sum_out.totals.rx);
+		print_always("  Average packets/s   : %'-10.0f\n", sample_round(pkts/period));
+	}
+	if (sum_out.totals.redir) {
+		double pkts = sum_out.totals.redir;
+
+		print_always("  Packets redirected  : %'-10llu\n", sum_out.totals.redir);
+		print_always("  Average redir/s     : %'-10.0f\n", sample_round(pkts/period));
+	}
+	print_always("  Packets dropped     : %'-10llu\n", sum_out.totals.drop);
+	print_always("  Errors recorded     : %'-10llu\n", sum_out.totals.err);
+	if (sum_out.totals.xmit) {
+		double pkts = sum_out.totals.xmit;
+
+		print_always("  Packets transmitted : %'-10llu\n", sum_out.totals.xmit);
+		print_always("  Average transmit/s  : %'-10.0f\n", sample_round(pkts/period));
+	}
+}
+
 void sample_stats_print(int mask, struct stats_record *cur,
-			struct stats_record *prev, char *prog_name)
+			struct stats_record *prev, char *prog_name,
+			int interval)
 {
 	struct sample_output out = {};
 
@@ -803,6 +918,8 @@ void sample_stats_print(int mask, struct stats_record *cur,
 	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
 		stats_get_devmap_xmit(cur, prev, 0, &out);
 
+	sample_summary_update(&out, interval);
+
 	stats_print(prog_name, mask, cur, prev, &out);
 }
 
@@ -821,7 +938,7 @@ void sample_stats_poll(int interval, int mask, char *prog_name, int use_separato
 	for (;;) {
 		swap(&prev, &record);
 		sample_stats_collect(mask, record);
-		sample_stats_print(mask, record, prev, prog_name);
+		sample_stats_print(mask, record, prev, prog_name, interval);
 		fflush(stdout);
 		sleep(interval);
 		sample_reset_mode();
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index 6ca934b346ef..abe4ec25c310 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -26,13 +26,16 @@ enum tp_type {
 };
 
 enum stats_mask {
-	SAMPLE_RX_CNT	        = 1U << 1,
-	SAMPLE_REDIRECT_ERR_CNT	= 1U << 2,
-	SAMPLE_CPUMAP_ENQUEUE_CNT  = 1U << 3,
-	SAMPLE_CPUMAP_KTHREAD_CNT  = 1U << 4,
-	SAMPLE_EXCEPTION_CNT	= 1U << 5,
-	SAMPLE_DEVMAP_XMIT_CNT  = 1U << 6,
-	SAMPLE_REDIRECT_CNT	= 1U << 7,
+	_SAMPLE_REDIRECT_MAP        = 1U << 0,
+	SAMPLE_RX_CNT               = 1U << 1,
+	SAMPLE_REDIRECT_ERR_CNT     = 1U << 2,
+	SAMPLE_CPUMAP_ENQUEUE_CNT   = 1U << 3,
+	SAMPLE_CPUMAP_KTHREAD_CNT   = 1U << 4,
+	SAMPLE_EXCEPTION_CNT        = 1U << 5,
+	SAMPLE_DEVMAP_XMIT_CNT      = 1U << 6,
+	SAMPLE_REDIRECT_CNT         = 1U << 7,
+	SAMPLE_REDIRECT_MAP_CNT     = SAMPLE_REDIRECT_CNT | _SAMPLE_REDIRECT_MAP,
+	SAMPLE_REDIRECT_ERR_MAP_CNT = SAMPLE_REDIRECT_ERR_CNT | _SAMPLE_REDIRECT_MAP,
 };
 
 static const char *const map_type_strings[] = {
@@ -153,8 +156,11 @@ void sample_exit(int status);
 struct stats_record *alloc_stats_record(void);
 void free_stats_record(struct stats_record *rec);
 void sample_stats_print(int mask, struct stats_record *cur,
-			struct stats_record *prev, char *prog_name);
+			struct stats_record *prev, char *prog_name,
+			int interval);
 void sample_stats_collect(int mask, struct stats_record *rec);
+void sample_summary_update(struct sample_output *out, int interval);
+void sample_summary_print(void);
 void sample_stats_poll(int interval, int mask, char *prog_name,
 		       int use_separators);
 void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
-- 
2.31.1

