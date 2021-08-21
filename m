Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7093F3F3799
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240979AbhHUAV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240760AbhHUAVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:20 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5706C061575;
        Fri, 20 Aug 2021 17:20:41 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so8395996pjb.3;
        Fri, 20 Aug 2021 17:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+/PIuBmrsrndNjCRiNCKF7Wn/jFbLc8xmF1lEQZjtnU=;
        b=EsTGm9AFQ73w1FiJS556yuy3XQl3G0QjoK00u/2EnSYw6/B+eeGqLHy4Quq9qFJFR4
         jOSNDPxMlywb4WIe+pJD20yIH2G63O6+gup/npxxUAt+72W83/4iICeDRicJ61rjda6w
         pppkdMEtlwrUOIxQ/l+nJDWpAUIVXC1DSKI8SeC2ka9vb57QLlm/s0tgGLItAvKDn8Tg
         lGxn1+OmXtREctpbZhDNJfs7YCyRHWDOG+I+McKExktaLuaV4uKVjIUZPD0oAkhVQkhP
         oRaPogn/WscFCH7cMiCOXao3yFperQlfIu0akEj74Xb+8B+ShZeQEL9IeHiK+h++uCI+
         k0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+/PIuBmrsrndNjCRiNCKF7Wn/jFbLc8xmF1lEQZjtnU=;
        b=fPPpBVBjx5MdoiKCbfLKB0Cj/XqhFcnh5eZ7JRJvmepTPZzB7EkJAD4jmd78NkzIeP
         avs8qQCkSJAgJ1oObHr2IHlzFIU71+p6pw0bejztEaVnhopkdu4eZEKjOwbNVYUBQfmA
         bvdZIFbpR6W6g7r4gzAK7qJFJT0dR8MfbM+P0aYfwR0s81UqbccpsDh+eadzcyTzItgc
         NyBE4pveciIPLD4dJfsbnM7pB8j4jStFMHFq0QjOssaU8UKlkigkP1f/9JzgRGMZYGqg
         Qq+Zpm6YGR8Z+Ahsk98XYNfrN6qPT+T3kmO3xmj2nwGZOgbEr9jTmAkMKlXyjkFKpK4m
         0BxA==
X-Gm-Message-State: AOAM531bU+c1CwRAqaWCxzv+stVKecTMLoPFV0mhD0yk/oCm5eFOkl9+
        ln9YgN8stYmFrF7b6bAME0mqbEPpu6k=
X-Google-Smtp-Source: ABdhPJwr7V6kQ3kGO0P7PQciyszqtHKGW9EPPItI4RPAfvURdQ/OLO2/OUiph7rWN5n24Ce6EYgsFA==
X-Received: by 2002:a17:902:8309:b0:12d:d1f2:6a95 with SMTP id bd9-20020a170902830900b0012dd1f26a95mr18546106plb.29.1629505241062;
        Fri, 20 Aug 2021 17:20:41 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id r13sm9865780pgl.90.2021.08.20.17.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:40 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 09/22] samples: bpf: Add cpumap tracepoint statistics support
Date:   Sat, 21 Aug 2021 05:49:57 +0530
Message-Id: <20210821002010.845777-10-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This consolidates retrieval and printing into the XDP sample helper. For
the kthread stats, it expands xdp_stats separately with its own per-CPU
stats. For cpumap enqueue, we display FROM->TO stats also with its
per-CPU stats.

The help out explains in detail the various aspects of the output.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample_user.c | 219 +++++++++++++++++++++++++++++++++-
 samples/bpf/xdp_sample_user.h |   6 +
 2 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 52a30fd1f2a3..e2692dee1dbb 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -74,6 +74,8 @@
 enum map_type {
 	MAP_RX,
 	MAP_REDIRECT_ERR,
+	MAP_CPUMAP_ENQUEUE,
+	MAP_CPUMAP_KTHREAD,
 	MAP_EXCEPTION,
 	NUM_MAP,
 };
@@ -99,13 +101,16 @@ struct map_entry {
 struct stats_record {
 	struct record rx_cnt;
 	struct record redir_err[XDP_REDIRECT_ERR_MAX];
+	struct record kthread;
 	struct record exception[XDP_ACTION_MAX];
+	struct record enq[];
 };
 
 struct sample_output {
 	struct {
 		__u64 rx;
 		__u64 redir;
+		__u64 drop;
 		__u64 err;
 	} totals;
 	struct {
@@ -228,6 +233,30 @@ static void sample_print_help(int mask)
 		printf("  \n\t\t\t\terror/s   - Packets that failed redirection per second\n\n");
 	}
 
+	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT) {
+		printf("  enqueue to cpu N\tDisplays the number of packets enqueued to bulk queue of CPU N\n"
+		       "  \t\t\tExpands to cpu:FROM->N to display enqueue stats for each CPU enqueuing to CPU N\n"
+		       "  \t\t\tReceived packets can be associated with the CPU redirect program is enqueuing \n"
+		       "  \t\t\tpackets to.\n"
+		       "  \t\t\t\tpkt/s    - Packets enqueued per second from other CPU to CPU N\n"
+		       "  \t\t\t\tdrop/s   - Packets dropped when trying to enqueue to CPU N\n"
+		       "  \t\t\t\tbulk-avg - Average number of packets processed for each event\n\n");
+	}
+
+	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT) {
+		printf("  kthread\t\tDisplays the number of packets processed in CPUMAP kthread for each CPU\n"
+		       "  \t\t\tPackets consumed from ptr_ring in kthread, and its xdp_stats (after calling \n"
+		       "  \t\t\tCPUMAP bpf prog) are expanded below this. xdp_stats are expanded as a total and\n"
+		       "  \t\t\tthen per-CPU to associate it to each CPU's pinned CPUMAP kthread.\n"
+		       "  \t\t\t\tpkt/s    - Packets consumed per second from ptr_ring\n"
+		       "  \t\t\t\tdrop/s   - Packets dropped per second in kthread\n"
+		       "  \t\t\t\tsched    - Number of times kthread called schedule()\n\n"
+		       "  \t\t\txdp_stats (also expands to per-CPU counts)\n"
+		       "  \t\t\t\tpass/s  - XDP_PASS count for CPUMAP program execution\n"
+		       "  \t\t\t\tdrop/s  - XDP_DROP count for CPUMAP program execution\n"
+		       "  \t\t\t\tredir/s - XDP_REDIRECT count for CPUMAP program execution\n\n");
+	}
+
 	if (mask & SAMPLE_EXCEPTION_CNT) {
 		printf("  xdp_exception\t\tDisplays xdp_exception tracepoint events\n"
 		       "  \t\t\tThis can occur due to internal driver errors, unrecognized\n"
@@ -357,6 +386,14 @@ static struct stats_record *alloc_stats_record(void)
 			}
 		}
 	}
+	if (sample_mask & SAMPLE_CPUMAP_KTHREAD_CNT) {
+		rec->kthread.cpu = alloc_record_per_cpu();
+		if (!rec->kthread.cpu) {
+			fprintf(stderr,
+				"Failed to allocate kthread per-CPU array\n");
+			goto end_redir;
+		}
+	}
 	if (sample_mask & SAMPLE_EXCEPTION_CNT) {
 		for (i = 0; i < XDP_ACTION_MAX; i++) {
 			rec->exception[i].cpu = alloc_record_per_cpu();
@@ -367,13 +404,32 @@ static struct stats_record *alloc_stats_record(void)
 					action2str(i));
 				while (i--)
 					free(rec->exception[i].cpu);
-				goto end_redir;
+				goto end_kthread;
+			}
+		}
+	}
+	if (sample_mask & SAMPLE_CPUMAP_ENQUEUE_CNT) {
+		for (i = 0; i < sample_n_cpus; i++) {
+			rec->enq[i].cpu = alloc_record_per_cpu();
+			if (!rec->enq[i].cpu) {
+				fprintf(stderr,
+					"Failed to allocate enqueue per-CPU array for "
+					"CPU %d\n",
+					i);
+				while (i--)
+					free(rec->enq[i].cpu);
+				goto end_exception;
 			}
 		}
 	}
 
 	return rec;
 
+end_exception:
+	for (i = 0; i < XDP_ACTION_MAX; i++)
+		free(rec->exception[i].cpu);
+end_kthread:
+	free(rec->kthread.cpu);
 end_redir:
 	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
 		free(rec->redir_err[i].cpu);
@@ -390,8 +446,11 @@ static void free_stats_record(struct stats_record *r)
 	struct map_entry *e;
 	int i;
 
+	for (i = 0; i < sample_n_cpus; i++)
+		free(r->enq[i].cpu);
 	for (i = 0; i < XDP_ACTION_MAX; i++)
 		free(r->exception[i].cpu);
+	free(r->kthread.cpu);
 	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
 		free(r->redir_err[i].cpu);
 	free(r->rx_cnt.cpu);
@@ -519,6 +578,137 @@ static void stats_get_rx_cnt(struct stats_record *stats_rec,
 	}
 }
 
+static void stats_get_cpumap_enqueue(struct stats_record *stats_rec,
+				     struct stats_record *stats_prev,
+				     unsigned int nr_cpus)
+{
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	int i, to_cpu;
+
+	/* cpumap enqueue stats */
+	for (to_cpu = 0; to_cpu < sample_n_cpus; to_cpu++) {
+		rec = &stats_rec->enq[to_cpu];
+		prev = &stats_prev->enq[to_cpu];
+		t = calc_period(rec, prev);
+
+		pps = calc_pps(&rec->total, &prev->total, t);
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		err = calc_errs_pps(&rec->total, &prev->total, t);
+
+		if (pps > 0 || drop > 0) {
+			char str[64];
+
+			snprintf(str, sizeof(str), "enqueue to cpu %d", to_cpu);
+
+			if (err > 0)
+				err = pps / err; /* calc average bulk size */
+
+			print_err(drop,
+				  "  %-20s " FMT_COLUMNf FMT_COLUMNf __COLUMN(
+					  ".2f") "\n",
+				  str, PPS(pps), DROP(drop), err, "bulk-avg");
+		}
+
+		for (i = 0; i < nr_cpus; i++) {
+			struct datarec *r = &rec->cpu[i];
+			struct datarec *p = &prev->cpu[i];
+			char str[64];
+
+			pps = calc_pps(r, p, t);
+			drop = calc_drop_pps(r, p, t);
+			err = calc_errs_pps(r, p, t);
+			if (!pps && !drop && !err)
+				continue;
+
+			snprintf(str, sizeof(str), "cpu:%d->%d", i, to_cpu);
+			if (err > 0)
+				err = pps / err; /* calc average bulk size */
+			print_default(
+				"    %-18s " FMT_COLUMNf FMT_COLUMNf __COLUMN(
+					".2f") "\n",
+				str, PPS(pps), DROP(drop), err, "bulk-avg");
+		}
+	}
+}
+
+static void stats_get_cpumap_remote(struct stats_record *stats_rec,
+				    struct stats_record *stats_prev,
+				    unsigned int nr_cpus)
+{
+	double xdp_pass, xdp_drop, xdp_redirect;
+	struct record *rec, *prev;
+	double t;
+	int i;
+
+	rec = &stats_rec->kthread;
+	prev = &stats_prev->kthread;
+	t = calc_period(rec, prev);
+
+	calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
+		     &xdp_redirect, t);
+	if (xdp_pass || xdp_drop || xdp_redirect) {
+		print_err(xdp_drop,
+			  "    %-18s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			  "xdp_stats", PASS(xdp_pass), DROP(xdp_drop),
+			  REDIR(xdp_redirect));
+	}
+
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+		char str[64];
+
+		calc_xdp_pps(r, p, &xdp_pass, &xdp_drop, &xdp_redirect, t);
+		if (!xdp_pass && !xdp_drop && !xdp_redirect)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		print_default("      %-16s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf
+			      "\n",
+			      str, PASS(xdp_pass), DROP(xdp_drop),
+			      REDIR(xdp_redirect));
+	}
+}
+
+static void stats_get_cpumap_kthread(struct stats_record *stats_rec,
+				     struct stats_record *stats_prev,
+				     unsigned int nr_cpus)
+{
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	int i;
+
+	rec = &stats_rec->kthread;
+	prev = &stats_prev->kthread;
+	t = calc_period(rec, prev);
+
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	err = calc_errs_pps(&rec->total, &prev->total, t);
+
+	print_err(drop, "  %-20s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+		  pps ? "kthread total" : "kthread", PPS(pps), DROP(drop), err,
+		  "sched");
+
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+		char str[64];
+
+		pps = calc_pps(r, p, t);
+		drop = calc_drop_pps(r, p, t);
+		err = calc_errs_pps(r, p, t);
+		if (!pps && !drop && !err)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		print_default("    %-18s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf
+			      "\n",
+			      str, PPS(pps), DROP(drop), err, "sched");
+	}
+}
+
 static void stats_get_redirect_cnt(struct stats_record *stats_rec,
 				   struct stats_record *stats_prev,
 				   unsigned int nr_cpus,
@@ -656,6 +846,9 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 		print_always(FMT_COLUMNl, RX(out->totals.rx));
 	if (mask & SAMPLE_REDIRECT_CNT)
 		print_always(FMT_COLUMNl, REDIR(out->totals.redir));
+	printf(FMT_COLUMNl,
+	       out->totals.err + out->totals.drop + out->totals.drop_xmit,
+	       "err,drop/s");
 	printf("\n");
 
 	if (mask & SAMPLE_RX_CNT) {
@@ -670,6 +863,14 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 		stats_get_rx_cnt(r, p, nr_cpus, NULL);
 	}
 
+	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
+		stats_get_cpumap_enqueue(r, p, nr_cpus);
+
+	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT) {
+		stats_get_cpumap_kthread(r, p, nr_cpus);
+		stats_get_cpumap_remote(r, p, nr_cpus);
+	}
+
 	if (mask & SAMPLE_REDIRECT_CNT) {
 		str = out->redir_cnt.suc ? "redirect total" : "redirect";
 		print_default("  %-20s " FMT_COLUMNl "\n", str,
@@ -714,6 +915,7 @@ int sample_setup_maps(struct bpf_map **maps)
 
 		switch (i) {
 		case MAP_RX:
+		case MAP_CPUMAP_KTHREAD:
 			sample_map_count[i] = sample_n_cpus;
 			break;
 		case MAP_REDIRECT_ERR:
@@ -722,6 +924,8 @@ int sample_setup_maps(struct bpf_map **maps)
 			break;
 		case MAP_EXCEPTION:
 			sample_map_count[i] = XDP_ACTION_MAX * sample_n_cpus;
+		case MAP_CPUMAP_ENQUEUE:
+			sample_map_count[i] = sample_n_cpus * sample_n_cpus;
 			break;
 		default:
 			return -EINVAL;
@@ -850,6 +1054,9 @@ static void sample_summary_print(void)
 		print_always("  Average redir/s     : %'-10.0f\n",
 			     sample_round(pkts / period));
 	}
+	if (sample_out.totals.drop)
+		print_always("  Rx dropped          : %'-10llu\n",
+			     sample_out.totals.drop);
 	if (sample_out.totals.err)
 		print_always("  Errors recorded     : %'-10llu\n",
 			     sample_out.totals.err);
@@ -894,6 +1101,15 @@ static int sample_stats_collect(struct stats_record *rec)
 					   &rec->redir_err[i]);
 	}
 
+	if (sample_mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
+		for (i = 0; i < sample_n_cpus; i++)
+			map_collect_percpu(&sample_mmap[MAP_CPUMAP_ENQUEUE][i * sample_n_cpus],
+					   &rec->enq[i]);
+
+	if (sample_mask & SAMPLE_CPUMAP_KTHREAD_CNT)
+		map_collect_percpu(sample_mmap[MAP_CPUMAP_KTHREAD],
+				   &rec->kthread);
+
 	if (sample_mask & SAMPLE_EXCEPTION_CNT)
 		for (i = 0; i < XDP_ACTION_MAX; i++)
 			map_collect_percpu(&sample_mmap[MAP_EXCEPTION][i * sample_n_cpus],
@@ -906,6 +1122,7 @@ static void sample_summary_update(struct sample_output *out, int interval)
 {
 	sample_out.totals.rx += out->totals.rx;
 	sample_out.totals.redir += out->totals.redir;
+	sample_out.totals.drop += out->totals.drop;
 	sample_out.totals.err += out->totals.err;
 	sample_out.rx_cnt.pps += interval;
 }
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index aa28e4bdd628..203732615fee 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -11,6 +11,8 @@ enum stats_mask {
 	_SAMPLE_REDIRECT_MAP        = 1U << 0,
 	SAMPLE_RX_CNT               = 1U << 1,
 	SAMPLE_REDIRECT_ERR_CNT     = 1U << 2,
+	SAMPLE_CPUMAP_ENQUEUE_CNT   = 1U << 3,
+	SAMPLE_CPUMAP_KTHREAD_CNT   = 1U << 4,
 	SAMPLE_EXCEPTION_CNT        = 1U << 5,
 	SAMPLE_REDIRECT_CNT         = 1U << 7,
 	SAMPLE_REDIRECT_MAP_CNT     = SAMPLE_REDIRECT_CNT | _SAMPLE_REDIRECT_MAP,
@@ -76,6 +78,10 @@ static inline char *safe_strncpy(char *dst, const char *src, size_t size)
 			__attach_tp(tp_xdp_redirect_map_err);                  \
 		if (mask & SAMPLE_REDIRECT_ERR_CNT)                            \
 			__attach_tp(tp_xdp_redirect_err);                      \
+		if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)                          \
+			__attach_tp(tp_xdp_cpumap_enqueue);                    \
+		if (mask & SAMPLE_CPUMAP_KTHREAD_CNT)                          \
+			__attach_tp(tp_xdp_cpumap_kthread);                    \
 		if (mask & SAMPLE_EXCEPTION_CNT)                               \
 			__attach_tp(tp_xdp_exception);                         \
 		return 0;                                                      \
-- 
2.33.0

