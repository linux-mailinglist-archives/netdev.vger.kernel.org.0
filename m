Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1E93F3794
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240935AbhHUAVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240816AbhHUAVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7D4C06175F;
        Fri, 20 Aug 2021 17:20:35 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id n5so8391355pjt.4;
        Fri, 20 Aug 2021 17:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BzWPu//G77CM2eXZR+pf9bS658iA8afBH1AyZLxbmYc=;
        b=JR6lJMw6Gv32rGkJ6Gf9kuqNUHSNMFAblKY38VNaIZAlxPV3xeydTgyYh2qesZln8k
         1P6sR/M3bknEQAEgB/6JVZFrbkH9yOpmc+nt6+qR6/RdWpc7YZ2LU7g+9cqm+tAKOpfY
         /kR1BMbc85z76wngLtVpdtx2SkhvM2s3eW2shBzMTj7QIv/rwEmzLVumRMWrWVxAcOpN
         DmsRBz59rw2V0AMLP3KLd99rNaasPXlnFj44MCHl6zcZzMBOaguOskiIYzPPsOa+bM5K
         U5bTpkNvrg8Nct+IlPYKlJmzKpv+SUOfBjehPwQrx8SMuawSqJT3va5SUyZf+f02JJkI
         G2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BzWPu//G77CM2eXZR+pf9bS658iA8afBH1AyZLxbmYc=;
        b=COHjuf0cBhTYX7ZqMpEMjOeUpuMN3bMYDgMVfqUFvz3BuCNVNUinxtu8gAaIkXgbj9
         FG7+gXAT7G+n79F0gs8w4WXrxrLIFPf/Abq3Mg0SR1ojSgFtXiD4uB3XzNcwyE1qF0AN
         dVLv7owv1BoyHIqbq33wv3sUAER4zG0Ol5WuIp1104ZCD7vnpsEnYIwCVVwdjWwpdtmM
         SM3iWFADyNlnH0hbtTMp2OKQZzJJyzayxrhF4nW2AAR2NhcplXAvkKRIqCNHAeEJeAYg
         pUV7P2kq3NLVWJ3Y6az+ZUyFW4dUZv/q9CjheRNWmD6UEGxpOOcvmY4NTgBOKsgKFgJN
         KxdA==
X-Gm-Message-State: AOAM533LGmaS+fFnIBwWGIBKdkdzuqZs+u+ZFoCcggywhpfwNxfdS5NT
        1aZ1d9CqxM3YvlqqNIg3YH5VKkdhTa4=
X-Google-Smtp-Source: ABdhPJxXAVUb/ocP5w0uEkbSc04wqjTreqWHN2N9/wtuD6+OyNUACO216JIjeYn5/zPSlKdQxlsDJQ==
X-Received: by 2002:a17:902:c245:b029:12d:2063:345d with SMTP id 5-20020a170902c245b029012d2063345dmr18661412plg.43.1629505235002;
        Fri, 20 Aug 2021 17:20:35 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id r14sm8389135pff.106.2021.08.20.17.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:34 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 07/22] samples: bpf: Add xdp_exception tracepoint statistics support
Date:   Sat, 21 Aug 2021 05:49:55 +0530
Message-Id: <20210821002010.845777-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements the retrieval and printing, as well the help output.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample_user.c | 113 ++++++++++++++++++++++++++++++++++
 samples/bpf/xdp_sample_user.h |   3 +
 2 files changed, 116 insertions(+)

diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index c34592566825..52a30fd1f2a3 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -74,6 +74,7 @@
 enum map_type {
 	MAP_RX,
 	MAP_REDIRECT_ERR,
+	MAP_EXCEPTION,
 	NUM_MAP,
 };
 
@@ -98,6 +99,7 @@ struct map_entry {
 struct stats_record {
 	struct record rx_cnt;
 	struct record redir_err[XDP_REDIRECT_ERR_MAX];
+	struct record exception[XDP_ACTION_MAX];
 };
 
 struct sample_output {
@@ -115,6 +117,9 @@ struct sample_output {
 		__u64 suc;
 		__u64 err;
 	} redir_cnt;
+	struct {
+		__u64 hits;
+	} except_cnt;
 };
 
 struct xdp_desc {
@@ -156,6 +161,15 @@ static const char *xdp_redirect_err_help[XDP_REDIRECT_ERR_MAX - 1] = {
 	"No space in ptr_ring of cpumap kthread",
 };
 
+static const char *xdp_action_names[XDP_ACTION_MAX] = {
+	[XDP_ABORTED]  = "XDP_ABORTED",
+	[XDP_DROP]     = "XDP_DROP",
+	[XDP_PASS]     = "XDP_PASS",
+	[XDP_TX]       = "XDP_TX",
+	[XDP_REDIRECT] = "XDP_REDIRECT",
+	[XDP_UNKNOWN]  = "XDP_UNKNOWN",
+};
+
 static __u64 gettime(void)
 {
 	struct timespec t;
@@ -169,6 +183,13 @@ static __u64 gettime(void)
 	return (__u64)t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
 }
 
+static const char *action2str(int action)
+{
+	if (action < XDP_ACTION_MAX)
+		return xdp_action_names[action];
+	return NULL;
+}
+
 static void sample_print_help(int mask)
 {
 	printf("Output format description\n\n"
@@ -206,6 +227,15 @@ static void sample_print_help(int mask)
 
 		printf("  \n\t\t\t\terror/s   - Packets that failed redirection per second\n\n");
 	}
+
+	if (mask & SAMPLE_EXCEPTION_CNT) {
+		printf("  xdp_exception\t\tDisplays xdp_exception tracepoint events\n"
+		       "  \t\t\tThis can occur due to internal driver errors, unrecognized\n"
+		       "  \t\t\tXDP actions and due to explicit user trigger by use of XDP_ABORTED\n"
+		       "  \t\t\tEach action is expanded below this field with its count\n"
+		       "  \t\t\t\thit/s     - Number of times the tracepoint was hit per second\n\n");
+	}
+
 }
 
 void sample_usage(char *argv[], const struct option *long_options,
@@ -327,9 +357,26 @@ static struct stats_record *alloc_stats_record(void)
 			}
 		}
 	}
+	if (sample_mask & SAMPLE_EXCEPTION_CNT) {
+		for (i = 0; i < XDP_ACTION_MAX; i++) {
+			rec->exception[i].cpu = alloc_record_per_cpu();
+			if (!rec->exception[i].cpu) {
+				fprintf(stderr,
+					"Failed to allocate exception per-CPU array for "
+					"\"%s\" case\n",
+					action2str(i));
+				while (i--)
+					free(rec->exception[i].cpu);
+				goto end_redir;
+			}
+		}
+	}
 
 	return rec;
 
+end_redir:
+	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
+		free(rec->redir_err[i].cpu);
 end_rx_cnt:
 	free(rec->rx_cnt.cpu);
 end_rec:
@@ -343,6 +390,8 @@ static void free_stats_record(struct stats_record *r)
 	struct map_entry *e;
 	int i;
 
+	for (i = 0; i < XDP_ACTION_MAX; i++)
+		free(r->exception[i].cpu);
 	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
 		free(r->redir_err[i].cpu);
 	free(r->rx_cnt.cpu);
@@ -551,6 +600,50 @@ static void stats_get_redirect_err_cnt(struct stats_record *stats_rec,
 	}
 }
 
+static void stats_get_exception_cnt(struct stats_record *stats_rec,
+				    struct stats_record *stats_prev,
+				    unsigned int nr_cpus,
+				    struct sample_output *out)
+{
+	double t, drop, sum = 0;
+	struct record *rec, *prev;
+	int rec_i, i;
+
+	for (rec_i = 0; rec_i < XDP_ACTION_MAX; rec_i++) {
+		rec = &stats_rec->exception[rec_i];
+		prev = &stats_prev->exception[rec_i];
+		t = calc_period(rec, prev);
+
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		/* Fold out errors after heading */
+		sum += drop;
+
+		if (drop > 0 && !out) {
+			print_always("    %-18s " FMT_COLUMNf "\n",
+				     action2str(rec_i), ERR(drop));
+
+			for (i = 0; i < nr_cpus; i++) {
+				struct datarec *r = &rec->cpu[i];
+				struct datarec *p = &prev->cpu[i];
+				char str[64];
+				double drop;
+
+				drop = calc_drop_pps(r, p, t);
+				if (!drop)
+					continue;
+
+				snprintf(str, sizeof(str), "cpu:%d", i);
+				print_default("       %-16s" FMT_COLUMNf "\n",
+					      str, ERR(drop));
+			}
+		}
+	}
+
+	if (out) {
+		out->except_cnt.hits = sum;
+		out->totals.err += sum;
+	}
+}
 
 static void stats_print(const char *prefix, int mask, struct stats_record *r,
 			struct stats_record *p, struct sample_output *out)
@@ -595,6 +688,16 @@ static void stats_print(const char *prefix, int mask, struct stats_record *r,
 		stats_get_redirect_err_cnt(r, p, nr_cpus, NULL);
 	}
 
+	if (mask & SAMPLE_EXCEPTION_CNT) {
+		str = out->except_cnt.hits ? "xdp_exception total" :
+						   "xdp_exception";
+
+		print_err(out->except_cnt.hits, "  %-20s " FMT_COLUMNl "\n", str,
+			  HITS(out->except_cnt.hits));
+
+		stats_get_exception_cnt(r, p, nr_cpus, NULL);
+	}
+
 	if (sample_log_level & LL_DEFAULT ||
 	    ((sample_log_level & LL_SIMPLE) && sample_err_exp)) {
 		sample_err_exp = false;
@@ -617,6 +720,9 @@ int sample_setup_maps(struct bpf_map **maps)
 			sample_map_count[i] =
 				XDP_REDIRECT_ERR_MAX * sample_n_cpus;
 			break;
+		case MAP_EXCEPTION:
+			sample_map_count[i] = XDP_ACTION_MAX * sample_n_cpus;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -788,6 +894,11 @@ static int sample_stats_collect(struct stats_record *rec)
 					   &rec->redir_err[i]);
 	}
 
+	if (sample_mask & SAMPLE_EXCEPTION_CNT)
+		for (i = 0; i < XDP_ACTION_MAX; i++)
+			map_collect_percpu(&sample_mmap[MAP_EXCEPTION][i * sample_n_cpus],
+					   &rec->exception[i]);
+
 	return 0;
 }
 
@@ -811,6 +922,8 @@ static void sample_stats_print(int mask, struct stats_record *cur,
 		stats_get_redirect_cnt(cur, prev, 0, &out);
 	if (mask & SAMPLE_REDIRECT_ERR_CNT)
 		stats_get_redirect_err_cnt(cur, prev, 0, &out);
+	if (mask & SAMPLE_EXCEPTION_CNT)
+		stats_get_exception_cnt(cur, prev, 0, &out);
 	sample_summary_update(&out, interval);
 
 	stats_print(prog_name, mask, cur, prev, &out);
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index 1935a0e2f85b..aa28e4bdd628 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -11,6 +11,7 @@ enum stats_mask {
 	_SAMPLE_REDIRECT_MAP        = 1U << 0,
 	SAMPLE_RX_CNT               = 1U << 1,
 	SAMPLE_REDIRECT_ERR_CNT     = 1U << 2,
+	SAMPLE_EXCEPTION_CNT        = 1U << 5,
 	SAMPLE_REDIRECT_CNT         = 1U << 7,
 	SAMPLE_REDIRECT_MAP_CNT     = SAMPLE_REDIRECT_CNT | _SAMPLE_REDIRECT_MAP,
 	SAMPLE_REDIRECT_ERR_MAP_CNT = SAMPLE_REDIRECT_ERR_CNT | _SAMPLE_REDIRECT_MAP,
@@ -75,6 +76,8 @@ static inline char *safe_strncpy(char *dst, const char *src, size_t size)
 			__attach_tp(tp_xdp_redirect_map_err);                  \
 		if (mask & SAMPLE_REDIRECT_ERR_CNT)                            \
 			__attach_tp(tp_xdp_redirect_err);                      \
+		if (mask & SAMPLE_EXCEPTION_CNT)                               \
+			__attach_tp(tp_xdp_exception);                         \
 		return 0;                                                      \
 	}
 
-- 
2.33.0

