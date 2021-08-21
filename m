Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C213F378F
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbhHUAVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240643AbhHUAVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:08 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4ABC061575;
        Fri, 20 Aug 2021 17:20:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso14932990pjh.5;
        Fri, 20 Aug 2021 17:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BGV30f9MCuHvJJtoBnOiQfknQvRub3QyxEXDZjAzwvU=;
        b=BVWKua8rY9avvM2ODO0fE9u8KofW2GPG4P8qWto9J4T/2Fqw3T+NirQZ+FVkIH5+Z6
         nneAb2NU1peIEEdH6cENp5PXZHm9424fQjxQR8VMpnLzMwZXB3v0ELnZosEssL7BsK2F
         Q5BnnScxGsxnEilXMj21EVeXxWY3PSO3hOV8XLRGBjnILDjihKqgaYmOOd9iCE9CJy5S
         JY3FGndNfvoUE9ndwejavJlSds9UuIOyoLUMvGtfMD1D8rg8PO9U8CPR19iB1WUAuAWL
         VNz70qYpa+Yt8HASksrjzsGl9IWfQ3iHnHZKtGcNzCuhrG9BJTOzr1LQuEnz/GakRy5D
         elww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BGV30f9MCuHvJJtoBnOiQfknQvRub3QyxEXDZjAzwvU=;
        b=MZNLBoOpDC0p0UWwm0yYdBV9NOoq0QycPsezdTgfydc1XTZIEgjaJaKEdBynbdF03w
         ovfh243iUQ0oT2XsmxZbvN9cKV6+APmrXWLHCnpfnOCSiEUynwS4/pBw1EDqS7x/49nz
         6JcIeXm7J2yNDOvhaMAh/anVoSTXhLxxqh0aHqDvE4R3i6iOt4kn+ohHzd2sc9XqNggu
         HQvv0BSWPnfyI29m1vu0m1oxZBDELTh8e4Pbm3iHeaw+OMqAupmWHIyi/xwwYonw8AGk
         tkWINeuIivelJlU84HG2Lgeae6aryikxNo/XdKr8SdBlXNPmES7pT4sfxG64p5yAWvbd
         hYhQ==
X-Gm-Message-State: AOAM530yyV6kDCEJx0DW3MoFKRtgP5aP0NLt2Xqx4Qkym+IwXKM+qXXZ
        ASHwjEwKLICu5JS21PnUlUx+Pc/t+Aw=
X-Google-Smtp-Source: ABdhPJwTxajDgJVIBlHl9PjeNHTrcwU4WFBpN6fC2Hqt/uY8Zc0Xj/hwUGDxW9J9ymfD9Rg/+jni0Q==
X-Received: by 2002:a17:902:bd81:b029:12c:b6fb:feef with SMTP id q1-20020a170902bd81b029012cb6fbfeefmr18624563pls.84.1629505229128;
        Fri, 20 Aug 2021 17:20:29 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id l12sm9648313pgc.41.2021.08.20.17.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:28 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 05/22] samples: bpf: Add redirect tracepoint statistics support
Date:   Sat, 21 Aug 2021 05:49:53 +0530
Message-Id: <20210821002010.845777-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements per-errno reporting (for the ones we explicitly
recognize), adds some help output, and implements the stats retrieval
and printing functions.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample_user.c | 194 ++++++++++++++++++++++++++++++++++
 samples/bpf/xdp_sample_user.h |  21 ++++
 2 files changed, 215 insertions(+)

diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 073aa3424e4b..c34592566825 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -73,6 +73,7 @@
 
 enum map_type {
 	MAP_RX,
+	MAP_REDIRECT_ERR,
 	NUM_MAP,
 };
 
@@ -96,17 +97,24 @@ struct map_entry {
 
 struct stats_record {
 	struct record rx_cnt;
+	struct record redir_err[XDP_REDIRECT_ERR_MAX];
 };
 
 struct sample_output {
 	struct {
 		__u64 rx;
+		__u64 redir;
+		__u64 err;
 	} totals;
 	struct {
 		__u64 pps;
 		__u64 drop;
 		__u64 err;
 	} rx_cnt;
+	struct {
+		__u64 suc;
+		__u64 err;
+	} redir_cnt;
 };
 
 struct xdp_desc {
@@ -127,6 +135,27 @@ int sample_n_cpus;
 int sample_sig_fd;
 int sample_mask;
 
+static const char *xdp_redirect_err_names[XDP_REDIRECT_ERR_MAX] = {
+	/* Key=1 keeps unknown errors */
+	"Success",
+	"Unknown",
+	"EINVAL",
+	"ENETDOWN",
+	"EMSGSIZE",
+	"EOPNOTSUPP",
+	"ENOSPC",
+};
+
+/* Keyed from Unknown */
+static const char *xdp_redirect_err_help[XDP_REDIRECT_ERR_MAX - 1] = {
+	"Unknown error",
+	"Invalid redirection",
+	"Device being redirected to is down",
+	"Packet length too large for device",
+	"Operation not supported",
+	"No space in ptr_ring of cpumap kthread",
+};
+
 static __u64 gettime(void)
 {
 	struct timespec t;
@@ -162,6 +191,21 @@ static void sample_print_help(int mask)
 		       " \t\t\t\tdrop/s    - Packets dropped per second\n"
 		       " \t\t\t\terror/s   - Errors encountered per second\n\n");
 	}
+	if (mask & (SAMPLE_REDIRECT_CNT | SAMPLE_REDIRECT_ERR_CNT)) {
+		printf("  redirect\t\tDisplays the number of packets successfully redirected\n"
+		       "  \t\t\tErrors encountered are expanded under redirect_err field\n"
+		       "  \t\t\tNote that passing -s to enable it has a per packet overhead\n"
+		       "  \t\t\t\tredir/s   - Packets redirected successfully per second\n\n"
+		       "  redirect_err\t\tDisplays the number of packets that failed redirection\n"
+		       "  \t\t\tThe errno is expanded under this field with per CPU count\n"
+		       "  \t\t\tThe recognized errors are:\n");
+
+		for (int i = 2; i < XDP_REDIRECT_ERR_MAX; i++)
+			printf("\t\t\t  %s: %s\n", xdp_redirect_err_names[i],
+			       xdp_redirect_err_help[i - 1]);
+
+		printf("  \n\t\t\t\terror/s   - Packets that failed redirection per second\n\n");
+	}
 }
 
 void sample_usage(char *argv[], const struct option *long_options,
@@ -269,8 +313,25 @@ static struct stats_record *alloc_stats_record(void)
 			goto end_rec;
 		}
 	}
+	if (sample_mask & (SAMPLE_REDIRECT_CNT | SAMPLE_REDIRECT_ERR_CNT)) {
+		for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++) {
+			rec->redir_err[i].cpu = alloc_record_per_cpu();
+			if (!rec->redir_err[i].cpu) {
+				fprintf(stderr,
+					"Failed to allocate redir_err per-CPU array for "
+					"\"%s\" case\n",
+					xdp_redirect_err_names[i]);
+				while (i--)
+					free(rec->redir_err[i].cpu);
+				goto end_rx_cnt;
+			}
+		}
+	}
 
 	return rec;
+
+end_rx_cnt:
+	free(rec->rx_cnt.cpu);
 end_rec:
 	free(rec);
 	return NULL;
@@ -282,6 +343,8 @@ static void free_stats_record(struct stats_record *r)
 	struct map_entry *e;
 	int i;
 
+	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
+		free(r->redir_err[i].cpu);
 	free(r->rx_cnt.cpu);
 	free(r);
 }
@@ -407,6 +470,87 @@ static void stats_get_rx_cnt(struct stats_record *stats_rec,
 	}
 }
 
+static void stats_get_redirect_cnt(struct stats_record *stats_rec,
+				   struct stats_record *stats_prev,
+				   unsigned int nr_cpus,
+				   struct sample_output *out)
+{
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
+		char str[64];
+
+		pps = calc_pps(r, p, t);
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		print_default("    %-18s " FMT_COLUMNf "\n", str, REDIR(pps));
+	}
+
+	if (out) {
+		pps = calc_pps(&rec->total, &prev->total, t);
+		out->redir_cnt.suc = pps;
+		out->totals.redir += pps;
+	}
+}
+
+static void stats_get_redirect_err_cnt(struct stats_record *stats_rec,
+				       struct stats_record *stats_prev,
+				       unsigned int nr_cpus,
+				       struct sample_output *out)
+{
+	struct record *rec, *prev;
+	double t, drop, sum = 0;
+	int rec_i, i;
+
+	for (rec_i = 1; rec_i < XDP_REDIRECT_ERR_MAX; rec_i++) {
+		char str[64];
+
+		rec = &stats_rec->redir_err[rec_i];
+		prev = &stats_prev->redir_err[rec_i];
+		t = calc_period(rec, prev);
+
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		if (drop > 0 && !out) {
+			snprintf(str, sizeof(str),
+				 sample_log_level & LL_DEFAULT ? "%s total" :
+								       "%s",
+				 xdp_redirect_err_names[rec_i]);
+			print_err(drop, "    %-18s " FMT_COLUMNf "\n", str,
+				  ERR(drop));
+		}
+
+		for (i = 0; i < nr_cpus; i++) {
+			struct datarec *r = &rec->cpu[i];
+			struct datarec *p = &prev->cpu[i];
+			double drop;
+
+			drop = calc_drop_pps(r, p, t);
+			if (!drop)
+				continue;
+
+			snprintf(str, sizeof(str), "cpu:%d", i);
+			print_default("       %-16s" FMT_COLUMNf "\n", str,
+				      ERR(drop));
+		}
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
 
 static void stats_print(const char *prefix, int mask, struct stats_record *r,
 			struct stats_record *p, struct sample_output *out)
@@ -417,6 +561,8 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 	print_always("%-23s", prefix ?: "Summary");
 	if (mask & SAMPLE_RX_CNT)
 		print_always(FMT_COLUMNl, RX(out->totals.rx));
+	if (mask & SAMPLE_REDIRECT_CNT)
+		print_always(FMT_COLUMNl, REDIR(out->totals.redir));
 	printf("\n");
 
 	if (mask & SAMPLE_RX_CNT) {
@@ -431,6 +577,24 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 		stats_get_rx_cnt(r, p, nr_cpus, NULL);
 	}
 
+	if (mask & SAMPLE_REDIRECT_CNT) {
+		str = out->redir_cnt.suc ? "redirect total" : "redirect";
+		print_default("  %-20s " FMT_COLUMNl "\n", str,
+			      REDIR(out->redir_cnt.suc));
+
+		stats_get_redirect_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_REDIRECT_ERR_CNT) {
+		str = (sample_log_level & LL_DEFAULT) && out->redir_cnt.err ?
+				    "redirect_err total" :
+				    "redirect_err";
+		print_err(out->redir_cnt.err, "  %-20s " FMT_COLUMNl "\n", str,
+			  ERR(out->redir_cnt.err));
+
+		stats_get_redirect_err_cnt(r, p, nr_cpus, NULL);
+	}
+
 	if (sample_log_level & LL_DEFAULT ||
 	    ((sample_log_level & LL_SIMPLE) && sample_err_exp)) {
 		sample_err_exp = false;
@@ -449,6 +613,10 @@ int sample_setup_maps(struct bpf_map **maps)
 		case MAP_RX:
 			sample_map_count[i] = sample_n_cpus;
 			break;
+		case MAP_REDIRECT_ERR:
+			sample_map_count[i] =
+				XDP_REDIRECT_ERR_MAX * sample_n_cpus;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -568,6 +736,17 @@ static void sample_summary_print(void)
 		print_always("  Average packets/s   : %'-10.0f\n",
 			     sample_round(pkts / period));
 	}
+	if (sample_out.totals.redir) {
+		double pkts = sample_out.totals.redir;
+
+		print_always("  Packets redirected  : %'-10llu\n",
+			     sample_out.totals.redir);
+		print_always("  Average redir/s     : %'-10.0f\n",
+			     sample_round(pkts / period));
+	}
+	if (sample_out.totals.err)
+		print_always("  Errors recorded     : %'-10llu\n",
+			     sample_out.totals.err);
 }
 
 void sample_exit(int status)
@@ -600,12 +779,23 @@ static int sample_stats_collect(struct stats_record *rec)
 	if (sample_mask & SAMPLE_RX_CNT)
 		map_collect_percpu(sample_mmap[MAP_RX], &rec->rx_cnt);
 
+	if (sample_mask & SAMPLE_REDIRECT_CNT)
+		map_collect_percpu(sample_mmap[MAP_REDIRECT_ERR], &rec->redir_err[0]);
+
+	if (sample_mask & SAMPLE_REDIRECT_ERR_CNT) {
+		for (i = 1; i < XDP_REDIRECT_ERR_MAX; i++)
+			map_collect_percpu(&sample_mmap[MAP_REDIRECT_ERR][i * sample_n_cpus],
+					   &rec->redir_err[i]);
+	}
+
 	return 0;
 }
 
 static void sample_summary_update(struct sample_output *out, int interval)
 {
 	sample_out.totals.rx += out->totals.rx;
+	sample_out.totals.redir += out->totals.redir;
+	sample_out.totals.err += out->totals.err;
 	sample_out.rx_cnt.pps += interval;
 }
 
@@ -617,6 +807,10 @@ static void sample_stats_print(int mask, struct stats_record *cur,
 
 	if (mask & SAMPLE_RX_CNT)
 		stats_get_rx_cnt(cur, prev, 0, &out);
+	if (mask & SAMPLE_REDIRECT_CNT)
+		stats_get_redirect_cnt(cur, prev, 0, &out);
+	if (mask & SAMPLE_REDIRECT_ERR_CNT)
+		stats_get_redirect_err_cnt(cur, prev, 0, &out);
 	sample_summary_update(&out, interval);
 
 	stats_print(prog_name, mask, cur, prev, &out);
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index d630998df547..1935a0e2f85b 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -10,6 +10,10 @@
 enum stats_mask {
 	_SAMPLE_REDIRECT_MAP        = 1U << 0,
 	SAMPLE_RX_CNT               = 1U << 1,
+	SAMPLE_REDIRECT_ERR_CNT     = 1U << 2,
+	SAMPLE_REDIRECT_CNT         = 1U << 7,
+	SAMPLE_REDIRECT_MAP_CNT     = SAMPLE_REDIRECT_CNT | _SAMPLE_REDIRECT_MAP,
+	SAMPLE_REDIRECT_ERR_MAP_CNT = SAMPLE_REDIRECT_ERR_CNT | _SAMPLE_REDIRECT_MAP,
 };
 
 /* Exit return codes */
@@ -47,6 +51,15 @@ static inline char *safe_strncpy(char *dst, const char *src, size_t size)
 }
 #pragma GCC diagnostic pop
 
+#define __attach_tp(name)                                                      \
+	({                                                                     \
+		if (!bpf_program__is_tracing(skel->progs.name))                \
+			return -EINVAL;                                        \
+		skel->links.name = bpf_program__attach(skel->progs.name);      \
+		if (!skel->links.name)                                         \
+			return -errno;                                         \
+	})
+
 #define DEFINE_SAMPLE_INIT(name)                                               \
 	static int sample_init(struct name *skel, int mask)                    \
 	{                                                                      \
@@ -54,6 +67,14 @@ static inline char *safe_strncpy(char *dst, const char *src, size_t size)
 		ret = __sample_init(mask);                                     \
 		if (ret < 0)                                                   \
 			return ret;                                            \
+		if (mask & SAMPLE_REDIRECT_MAP_CNT)                            \
+			__attach_tp(tp_xdp_redirect_map);                      \
+		if (mask & SAMPLE_REDIRECT_CNT)                                \
+			__attach_tp(tp_xdp_redirect);                          \
+		if (mask & SAMPLE_REDIRECT_ERR_MAP_CNT)                        \
+			__attach_tp(tp_xdp_redirect_map_err);                  \
+		if (mask & SAMPLE_REDIRECT_ERR_CNT)                            \
+			__attach_tp(tp_xdp_redirect_err);                      \
 		return 0;                                                      \
 	}
 
-- 
2.33.0

