Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532DE2C20C4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbgKXJDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730985AbgKXJD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:03:26 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028E0C0613D6;
        Tue, 24 Nov 2020 01:03:26 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id l17so6431437pgk.1;
        Tue, 24 Nov 2020 01:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1RlQBvNUBqN4aST0c2OFdhYn+zASxvI+ck+MqTjJ/IA=;
        b=RMekAZyFkyk5qZRyUQ+yo7yoqDPVQI9rff7FjKe+hMAL3MyuL5DCe9Ft2sldqcmi54
         YtDe3j12/ttoxyP3vxLwiJDXyyZzKkChhIUT+A6cJoU1YhYoN53dFlMBXkFkIyrlGxcY
         2+B3NcLwJr6r5Nnz1BZumOA88SNVx4oUYGtYssgGva/biTgV/B8hVW6jOTn2yOGltP0C
         L/dpx4N2o74RqKUqhj5BG3hrDREW+mnCqHJFenkoOFM/mvfy1hwE9s1RhjVWckfdwxQm
         Mmk5dMkR9HtzEg8xL/O+yRc8QgBes/nZ36PNTipmfAY6BYYX8lJAE4Fr85KCnbgZyiKv
         zDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RlQBvNUBqN4aST0c2OFdhYn+zASxvI+ck+MqTjJ/IA=;
        b=E4ZSSkrMs/IgjWZ67ZzWG3C6bmlW9PhJfw02xkph8l4ATd/FpryWhHG1UrUNdTuR4D
         0YqWVxWM5N1+KXlQtzB4Yc1Ik8j6WbPWAVxHcJXgrv8H+CK67MBoLwRRlvrhgLL81QoX
         hAsa6dkYilI3U6FbnNCPgIK4QWTn0KXpPu/sad/usAyth4Y+MSwaUnB0X8BI/X6z/dpS
         tkKY3kBeHVeRW9gfltkHRAGgs5BqMkp7cW0rqpOS5S8kCTKuUplz5CLfgheNTCbFhMgQ
         Qw1C5bzxwm8TQEzgsYhFxnpIySrOwZihMADFWplKB3OKP7HBbd/ek2h5zC4ycBAx2ChL
         pE0A==
X-Gm-Message-State: AOAM531Fv/RUAI5CRCb1DzKxJw+X1qdnDimfqfTpast+oviATsHuMkHV
        2lcclKIBSpwPjqn/cl0g8A==
X-Google-Smtp-Source: ABdhPJxwZ4K2+npwD6Op7VNTkgLZWxU4ZsZuVSLf4+8EmeYFqlJc+dwdjvmrMMu+9waIPyjPK28HcQ==
X-Received: by 2002:a62:77c3:0:b029:18b:b3df:8c6c with SMTP id s186-20020a6277c30000b029018bb3df8c6cmr3241552pfc.17.1606208605469;
        Tue, 24 Nov 2020 01:03:25 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n68sm14084345pfn.161.2020.11.24.01.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 01:03:24 -0800 (PST)
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
Subject: [PATCH bpf-next v3 1/7] samples: bpf: refactor hbm program with libbpf
Date:   Tue, 24 Nov 2020 09:03:04 +0000
Message-Id: <20201124090310.24374-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201124090310.24374-1-danieltimlee@gmail.com>
References: <20201124090310.24374-1-danieltimlee@gmail.com>
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
INGRESS. To keep bpf program attached to the cgroup hierarchy even
after the exit, this commit uses the BPF_LINK_PINNING to pin the link
attachment even after it is closed.

Besides, this program was broken due to the typo of BPF MAP definition.
But this commit solves the problem by fixing this from 'queue_stats' map
struct hvm_queue_stats -> hbm_queue_stats.

Fixes: 36b5d471135c ("selftests/bpf: samples/bpf: Split off legacy stuff from bpf_helpers.h")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in v2:
 - restore read_trace_pipe2
 - remove unnecessary return code and cgroup fd compare
 - add static at global variable and remove unused variable
 - change cgroup path with unified controller (/unified/)
 - add link pinning to prevent cleaning up on process exit

Changes in v3:
 - cleanup bpf_link, bpf_object and cgroup fd both on success and error
 - remove link NULL cleanup since __destroy() can handle
 - fix cgroup test on cgroup fd cleanup
 
 samples/bpf/.gitignore     |   3 +
 samples/bpf/Makefile       |   2 +-
 samples/bpf/do_hbm_test.sh |  32 +++++------
 samples/bpf/hbm.c          | 111 ++++++++++++++++++++-----------------
 samples/bpf/hbm_kern.h     |   2 +-
 5 files changed, 78 insertions(+), 72 deletions(-)

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
index aeebf5d12f32..7c61118525f7 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -110,7 +110,7 @@ xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
-hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+hbm-objs := hbm.o $(CGROUP_HELPERS)
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
diff --git a/samples/bpf/do_hbm_test.sh b/samples/bpf/do_hbm_test.sh
index ffe4c0607341..21790ea5c460 100755
--- a/samples/bpf/do_hbm_test.sh
+++ b/samples/bpf/do_hbm_test.sh
@@ -91,6 +91,16 @@ qdisc=""
 flags=""
 do_stats=0
 
+BPFFS=/sys/fs/bpf
+function config_bpffs () {
+	if mount | grep $BPFFS > /dev/null; then
+		echo "bpffs already mounted"
+	else
+		echo "bpffs not mounted. Mounting..."
+		mount -t bpf none $BPFFS
+	fi
+}
+
 function start_hbm () {
   rm -f hbm.out
   echo "./hbm $dir -n $id -r $rate -t $dur $flags $dbg $prog" > hbm.out
@@ -192,6 +202,7 @@ processArgs () {
 }
 
 processArgs
+config_bpffs
 
 if [ $debug_flag -eq 1 ] ; then
   rm -f hbm_out.log
@@ -201,7 +212,7 @@ hbm_pid=$(start_hbm)
 usleep 100000
 
 host=`hostname`
-cg_base_dir=/sys/fs/cgroup
+cg_base_dir=/sys/fs/cgroup/unified
 cg_dir="$cg_base_dir/cgroup-test-work-dir/hbm$id"
 
 echo $$ >> $cg_dir/cgroup.procs
@@ -411,23 +422,8 @@ fi
 
 sleep 1
 
-# Detach any BPF programs that may have lingered
-ttx=`bpftool cgroup tree | grep hbm`
-v=2
-for x in $ttx ; do
-    if [ "${x:0:36}" == "/sys/fs/cgroup/cgroup-test-work-dir/" ] ; then
-	cg=$x ; v=0
-    else
-	if [ $v -eq 0 ] ; then
-	    id=$x ; v=1
-	else
-	    if [ $v -eq 1 ] ; then
-		type=$x ; bpftool cgroup detach $cg $type id $id
-		v=0
-	    fi
-	fi
-    fi
-done
+# Detach any pinned BPF programs that may have lingered
+rm -rf $BPFFS/hbm*
 
 if [ $use_netperf -ne 0 ] ; then
   if [ "$server" == "" ] ; then
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 400e741a56eb..b0c18efe7928 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -46,7 +46,6 @@
 #include <bpf/bpf.h>
 #include <getopt.h>
 
-#include "bpf_load.h"
 #include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 #include "hbm.h"
@@ -70,9 +69,9 @@ static void do_error(char *msg, bool errno_flag);
 
 #define DEBUGFS "/sys/kernel/debug/tracing/"
 
-struct bpf_object *obj;
-int bpfprog_fd;
-int cgroup_storage_fd;
+static struct bpf_program *bpf_prog;
+static struct bpf_object *obj;
+static int queue_stats_fd;
 
 static void read_trace_pipe2(void)
 {
@@ -121,56 +120,50 @@ static void do_error(char *msg, bool errno_flag)
 
 static int prog_load(char *prog)
 {
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
-		.file = prog,
-		.expected_attach_type = BPF_CGROUP_INET_EGRESS,
-	};
-	int map_fd;
-	struct bpf_map *map;
-
-	int ret = 0;
-
-	if (access(prog, O_RDONLY) < 0) {
-		printf("Error accessing file %s: %s\n", prog, strerror(errno));
+	obj = bpf_object__open_file(prog, NULL);
+	if (libbpf_get_error(obj)) {
+		printf("ERROR: opening BPF object file failed\n");
 		return 1;
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
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		printf("ERROR: loading BPF object file failed\n");
+		goto err;
 	}
 
-	if (ret) {
-		printf("ERROR: bpf_prog_load_xattr failed for: %s\n", prog);
-		printf("  Output from verifier:\n%s\n------\n", bpf_log_buf);
-		ret = -1;
-	} else {
-		ret = map_fd;
+	bpf_prog = bpf_object__find_program_by_title(obj, "cgroup_skb/egress");
+	if (!bpf_prog) {
+		printf("ERROR: finding a prog in obj file failed\n");
+		goto err;
+	}
+
+	queue_stats_fd = bpf_object__find_map_fd_by_name(obj, "queue_stats");
+	if (queue_stats_fd < 0) {
+		printf("ERROR: finding a map in obj file failed\n");
+		goto err;
 	}
 
-	return ret;
+	return 0;
+
+err:
+	bpf_object__close(obj);
+	return 1;
 }
 
 static int run_bpf_prog(char *prog, int cg_id)
 {
-	int map_fd;
-	int rc = 0;
+	struct hbm_queue_stats qstats = {0};
+	char cg_dir[100], cg_pin_path[100];
+	struct bpf_link *link = NULL;
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
@@ -190,16 +183,24 @@ static int run_bpf_prog(char *prog, int cg_id)
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
+		goto err;
+	}
+
+	sprintf(cg_pin_path, "/sys/fs/bpf/hbm%d", cg_id);
+	rc = bpf_link__pin(link, cg_pin_path);
+	if (rc < 0) {
+		printf("ERROR: bpf_link__pin failed: %d\n", rc);
 		goto err;
 	}
 
@@ -213,7 +214,7 @@ static int run_bpf_prog(char *prog, int cg_id)
 #define DELTA_RATE_CHECK 10000		/* in us */
 #define RATE_THRESHOLD 9500000000	/* 9.5 Gbps */
 
-		bpf_map_lookup_elem(map_fd, &key, &qstats);
+		bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
 		if (gettimeofday(&t0, NULL) < 0)
 			do_error("gettimeofday failed", true);
 		t_last = t0;
@@ -242,7 +243,7 @@ static int run_bpf_prog(char *prog, int cg_id)
 			fclose(fin);
 			printf("  new_eth_tx_bytes:%llu\n",
 			       new_eth_tx_bytes);
-			bpf_map_lookup_elem(map_fd, &key, &qstats);
+			bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
 			new_cg_tx_bytes = qstats.bytes_total;
 			delta_bytes = new_eth_tx_bytes - last_eth_tx_bytes;
 			last_eth_tx_bytes = new_eth_tx_bytes;
@@ -289,14 +290,14 @@ static int run_bpf_prog(char *prog, int cg_id)
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
 
@@ -394,14 +395,20 @@ static int run_bpf_prog(char *prog, int cg_id)
 
 	if (debugFlag)
 		read_trace_pipe2();
-	return rc;
+	goto cleanup;
+
 err:
 	rc = 1;
 
-	if (cg1)
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
+
+	if (cg1 != -1)
 		close(cg1);
-	cleanup_cgroup_environment();
 
+	if (rc != 0)
+		cleanup_cgroup_environment();
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

