Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB372B6800
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731185AbgKQO5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbgKQO5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:57:36 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3141C0613CF;
        Tue, 17 Nov 2020 06:57:36 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d17so8832448plr.5;
        Tue, 17 Nov 2020 06:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=whqLTiOXSiTxVm81S9+0Mebq60JgZ9OOnlPKkIYpqQ0=;
        b=FENhk4veldaEP7++Xa/wNpaBxJH0TdDyPs9HNa6qoEfFpk/s1CsRQaL5NYwvmixb1k
         qvk/qwWbc/uN6I2uXaYiuqMGVtMmwWoSotiJlhwVlcg7LNRrSfSOGtWdUIX6Oce5Pc96
         GbBZe6gpsqgJIcoxUURcl41hg4FqW5mi+pAhqF5lpUiy/7FiBkN/EqshVEFIR0+aDNAV
         dY7D5IqNB0F08TVRWMYsh5dKVv4zj1mKbBQ3NkPsX7hnSmFI49B76GKmXOYwjWPO55Au
         d5KQLrB5el95+QR1mGLZjNvrFH0xxt7ERGwf+8TM8oBsQfB+h9fqHbipjfUwzgyPdgE3
         ouGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whqLTiOXSiTxVm81S9+0Mebq60JgZ9OOnlPKkIYpqQ0=;
        b=F050bGK7QbjhtyLjIcoO5PpEzf+xXYVWFeMgWBMzU/Vl5gRzsz3c4Q+IGFW9WeFlaW
         EljWBMstqFBuBAC+WxPo7NgkiCsiU+wxmboMjVrtKWTlK7mrEkZx13TGEdNw9jnGh/qr
         cP+owwwqjK5ln5V+OFHQHWfreyQyBGKDAZwKXsEhpWXVp8sUT/Miw1Tx1d/PCRHtM0bN
         FapGMe16nJfpwORY/Zll6MZlcwBkG3kKRxwSGspigR708L+0wSyFUqsnPF7E4lcsk06j
         yGaSsFJfy7Y1L1RKMUm/URRreZnHbYY6oNViAxqjn+3gouUkRa8citqn3BKVJw+EgEa4
         ITCg==
X-Gm-Message-State: AOAM533Hf+PM7aizZQL/pMIvxdJ40EpTktIu6ji54vqYScY13TVyk5FN
        e4uZQkkjAnfaTbaEgb7c9g==
X-Google-Smtp-Source: ABdhPJyFKJPa6bdH492x9vEgyenIZ0AGLCIhjlvt16ds2I+N69sbkkncoND3AJuIGUj9+VuLA4ObyQ==
X-Received: by 2002:a17:90b:100f:: with SMTP id gm15mr4613938pjb.63.1605625056392;
        Tue, 17 Nov 2020 06:57:36 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:57:35 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next 2/9] samples: bpf: refactor hbm program with libbpf
Date:   Tue, 17 Nov 2020 14:56:37 +0000
Message-Id: <20201117145644.1166255-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117145644.1166255-1-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit refactors the existing cgroup programs with libbpf
bpf loader. Since bpf_program__attach doesn't support cgroup program
attachment, this explicitly attaches cgroup bpf program with
bpf_program__attach_cgroup(bpf_prog, cg1).

Also, to change attach_type of bpf program, this uses libbpf's
bpf_program__set_expected_attach_type helper to switch EGRESS to
INGRESS.

Besides, this program was broken due to the typo of BPF MAP definition.
But this commit solves the problem by fixing this from 'queue_stats' map
struct hvm_queue_stats -> hbm_queue_stats.

Fixes: 36b5d471135c ("selftests/bpf: samples/bpf: Split off legacy stuff from bpf_helpers.h")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/.gitignore |  3 ++
 samples/bpf/Makefile   |  2 +-
 samples/bpf/hbm.c      | 96 +++++++++++++++++++++---------------------
 samples/bpf/hbm_kern.h |  2 +-
 4 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index b2f29bc8dc43..0b9548ea8477 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -52,3 +52,6 @@ xdp_tx_iptunnel
 xdpsock
 xsk_fwd
 testfile.img
+hbm_out.log
+iperf.*
+*.out
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 3e83cd5ca1c2..01449d767122 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -110,7 +110,7 @@ xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
-hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
+hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index b9f9f771dd81..008bc635ad9b 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -46,7 +46,6 @@
 #include <bpf/bpf.h>
 #include <getopt.h>
 
-#include "bpf_load.h"
 #include "bpf_rlimit.h"
 #include "trace_helpers.h"
 #include "cgroup_helpers.h"
@@ -68,9 +67,10 @@ bool edt_flag;
 static void Usage(void);
 static void do_error(char *msg, bool errno_flag);
 
+struct bpf_program *bpf_prog;
 struct bpf_object *obj;
-int bpfprog_fd;
 int cgroup_storage_fd;
+int queue_stats_fd;
 
 static void do_error(char *msg, bool errno_flag)
 {
@@ -83,56 +83,54 @@ static void do_error(char *msg, bool errno_flag)
 
 static int prog_load(char *prog)
 {
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
-		.file = prog,
-		.expected_attach_type = BPF_CGROUP_INET_EGRESS,
-	};
-	int map_fd;
-	struct bpf_map *map;
+	int rc = 1;
 
-	int ret = 0;
+	obj = bpf_object__open_file(prog, NULL);
+	if (libbpf_get_error(obj)) {
+		printf("ERROR: opening BPF object file failed\n");
+		return rc;
+	}
 
-	if (access(prog, O_RDONLY) < 0) {
-		printf("Error accessing file %s: %s\n", prog, strerror(errno));
-		return 1;
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		printf("ERROR: loading BPF object file failed\n");
+		goto cleanup;
 	}
-	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &bpfprog_fd))
-		ret = 1;
-	if (!ret) {
-		map = bpf_object__find_map_by_name(obj, "queue_stats");
-		map_fd = bpf_map__fd(map);
-		if (map_fd < 0) {
-			printf("Map not found: %s\n", strerror(map_fd));
-			ret = 1;
-		}
+
+	bpf_prog = bpf_object__find_program_by_title(obj, "cgroup_skb/egress");
+	if (!bpf_prog) {
+		printf("ERROR: finding a prog in obj file failed\n");
+		goto cleanup;
 	}
 
-	if (ret) {
-		printf("ERROR: bpf_prog_load_xattr failed for: %s\n", prog);
-		printf("  Output from verifier:\n%s\n------\n", bpf_log_buf);
-		ret = -1;
-	} else {
-		ret = map_fd;
+	queue_stats_fd = bpf_object__find_map_fd_by_name(obj, "queue_stats");
+	if (queue_stats_fd < 0) {
+		printf("ERROR: finding a map in obj file failed\n");
+		goto cleanup;
 	}
 
-	return ret;
+	rc = 0;
+
+cleanup:
+	if (rc != 0)
+		bpf_object__close(obj);
+
+	return rc;
 }
 
 static int run_bpf_prog(char *prog, int cg_id)
 {
-	int map_fd;
-	int rc = 0;
+	struct hbm_queue_stats qstats = {0};
+	struct bpf_link *link = NULL;
+	char cg_dir[100];
 	int key = 0;
 	int cg1 = 0;
-	int type = BPF_CGROUP_INET_EGRESS;
-	char cg_dir[100];
-	struct hbm_queue_stats qstats = {0};
+	int rc = 0;
 
 	sprintf(cg_dir, "/hbm%d", cg_id);
-	map_fd = prog_load(prog);
-	if (map_fd  == -1)
-		return 1;
+	rc = prog_load(prog);
+	if (rc != 0)
+		return rc;
 
 	if (setup_cgroup_environment()) {
 		printf("ERROR: setting cgroup environment\n");
@@ -152,16 +150,18 @@ static int run_bpf_prog(char *prog, int cg_id)
 	qstats.stats = stats_flag ? 1 : 0;
 	qstats.loopback = loopback_flag ? 1 : 0;
 	qstats.no_cn = no_cn_flag ? 1 : 0;
-	if (bpf_map_update_elem(map_fd, &key, &qstats, BPF_ANY)) {
+	if (bpf_map_update_elem(queue_stats_fd, &key, &qstats, BPF_ANY)) {
 		printf("ERROR: Could not update map element\n");
 		goto err;
 	}
 
 	if (!outFlag)
-		type = BPF_CGROUP_INET_INGRESS;
-	if (bpf_prog_attach(bpfprog_fd, cg1, type, 0)) {
-		printf("ERROR: bpf_prog_attach fails!\n");
-		log_err("Attaching prog");
+		bpf_program__set_expected_attach_type(bpf_prog, BPF_CGROUP_INET_INGRESS);
+
+	link = bpf_program__attach_cgroup(bpf_prog, cg1);
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach_cgroup failed\n");
+		link = NULL;
 		goto err;
 	}
 
@@ -175,7 +175,7 @@ static int run_bpf_prog(char *prog, int cg_id)
 #define DELTA_RATE_CHECK 10000		/* in us */
 #define RATE_THRESHOLD 9500000000	/* 9.5 Gbps */
 
-		bpf_map_lookup_elem(map_fd, &key, &qstats);
+		bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
 		if (gettimeofday(&t0, NULL) < 0)
 			do_error("gettimeofday failed", true);
 		t_last = t0;
@@ -204,7 +204,7 @@ static int run_bpf_prog(char *prog, int cg_id)
 			fclose(fin);
 			printf("  new_eth_tx_bytes:%llu\n",
 			       new_eth_tx_bytes);
-			bpf_map_lookup_elem(map_fd, &key, &qstats);
+			bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
 			new_cg_tx_bytes = qstats.bytes_total;
 			delta_bytes = new_eth_tx_bytes - last_eth_tx_bytes;
 			last_eth_tx_bytes = new_eth_tx_bytes;
@@ -251,14 +251,14 @@ static int run_bpf_prog(char *prog, int cg_id)
 					rate = minRate;
 				qstats.rate = rate;
 			}
-			if (bpf_map_update_elem(map_fd, &key, &qstats, BPF_ANY))
+			if (bpf_map_update_elem(queue_stats_fd, &key, &qstats, BPF_ANY))
 				do_error("update map element fails", false);
 		}
 	} else {
 		sleep(dur);
 	}
 	// Get stats!
-	if (stats_flag && bpf_map_lookup_elem(map_fd, &key, &qstats)) {
+	if (stats_flag && bpf_map_lookup_elem(queue_stats_fd, &key, &qstats)) {
 		char fname[100];
 		FILE *fout;
 
@@ -367,10 +367,12 @@ static int run_bpf_prog(char *prog, int cg_id)
 err:
 	rc = 1;
 
+	bpf_link__destroy(link);
+
 	if (cg1)
 		close(cg1);
 	cleanup_cgroup_environment();
-
+	bpf_object__close(obj);
 	return rc;
 }
 
diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index e00f26f6afba..722b3fadb467 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -69,7 +69,7 @@ struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 1);
 	__type(key, u32);
-	__type(value, struct hvm_queue_stats);
+	__type(value, struct hbm_queue_stats);
 } queue_stats SEC(".maps");
 
 struct hbm_pkt_info {
-- 
2.25.1

