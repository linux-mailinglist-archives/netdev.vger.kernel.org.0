Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B83D5377F9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiE3JOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbiE3JOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:14:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F83B7A461
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:14:07 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so3877339pjo.0
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B9vwKfbKHzDOEY1WrU024PdJUi8+ydTG61v0lkvD1q4=;
        b=3CVTEMHe5u8PnWdpoi2iCxc8bv6kuPc09y9WU15ndr1za+Iad4T+G5PNWH4XwcwgCL
         jPKFwE8NR+XU1GgadI/BDU/gR3Etnmw2QI90EQuuDOpRB/fDbkDCrMviKLer5CIy9gbQ
         jM2ELm8cv1ez6RFoSL/PAavPJLzkbLXQJ8cJpEqo+e3LAbigfu9jRpz0Xht99lbNJRec
         efhmI4TsgMfcHS4Ovs2PqpS9/t5FPelss9yvvepDUvQknOn5sHjYwb70xpcQZ3bXQJxl
         m83HZPq/68T2+0MgULpHhse7Ob/SeUE83N36oBb2s2XMbRN/EGJ97iJyV+hL5qXMuC7e
         lf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B9vwKfbKHzDOEY1WrU024PdJUi8+ydTG61v0lkvD1q4=;
        b=rAz6XlZbuw4GKKsPWzm11qz1YvJ0d7FhlOrF+wsNeU+aQ2M6O3a0YK43vtlaQd8gRU
         RBIDuu4lYqow01fdWkZRk5hKTlshpfUnNcF61S+LEj7B4PXnpd3wsrcS+qc4Av7Nj2vt
         tddrbRqMUr6yIcGiImB+PymG24Un+WF7IIOw88F5UbwiwY5x02ej982gLSo/RaW8ap01
         ebAWgy+LoBRnrynb2Fj1NqD8SoXPFf1fOAlX6LsB7/3ocyHh7erOMpw02Sf/DgM0fZss
         44t2IcCAU6YTm8K7y8ULu9UXDCWJ6qgbYKVi40dIWxFuU7S6SJ5j6kkNCrgqs7vUhQOO
         oIxw==
X-Gm-Message-State: AOAM532L8aHOu/io+DSSLM+VWtOpbx+633BKZztB1POCEVmLIhnLdv5M
        08DRakbMPF3ZJZT366vO2Kvs2Q==
X-Google-Smtp-Source: ABdhPJxej8okzLLPhKbjWHGOYrjxyaHMYkzqfwAkHgSu+0zudUGwcu3bx61LnfVoShiJQHT1nGoemQ==
X-Received: by 2002:a17:902:6b03:b0:161:51d6:61b with SMTP id o3-20020a1709026b0300b0016151d6061bmr31413370plk.23.1653902047063;
        Mon, 30 May 2022 02:14:07 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902ebc200b0015e8d4eb20dsm8640644plg.87.2022.05.30.02.14.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 May 2022 02:14:06 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v3 2/2] selftest/bpf/benchs: Add bpf_map benchmark
Date:   Mon, 30 May 2022 17:13:40 +0800
Message-Id: <20220530091340.53443-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220530091340.53443-1-zhoufeng.zf@bytedance.com>
References: <20220530091340.53443-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add benchmark for hash_map to reproduce the worst case
that non-stop update when map's free is zero.

before patch:
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
1:hash_map_full_perf 107796 events per sec
2:hash_map_full_perf 108072 events per sec
3:hash_map_full_perf 112169 events per sec
4:hash_map_full_perf 111423 events per sec
5:hash_map_full_perf 110778 events per sec
6:hash_map_full_perf 121336 events per sec
7:hash_map_full_perf 98676 events per sec
8:hash_map_full_perf 105860 events per sec
9:hash_map_full_perf 109930 events per sec
10:hash_map_full_perf 123434 events per sec
11:hash_map_full_perf 125374 events per sec
12:hash_map_full_perf 121979 events per sec
13:hash_map_full_perf 123014 events per sec
14:hash_map_full_perf 126219 events per sec
15:hash_map_full_perf 104793 events per sec

after patch:
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
0:hash_map_full_perf 1219230 events per sec
1:hash_map_full_perf 1320256 events per sec
2:hash_map_full_perf 1196550 events per sec
3:hash_map_full_perf 1375684 events per sec
4:hash_map_full_perf 1365551 events per sec
5:hash_map_full_perf 1318432 events per sec
6:hash_map_full_perf 1222007 events per sec
7:hash_map_full_perf 1240786 events per sec
8:hash_map_full_perf 1190005 events per sec
9:hash_map_full_perf 1562336 events per sec
10:hash_map_full_perf 1385241 events per sec
11:hash_map_full_perf 1387909 events per sec
12:hash_map_full_perf 1371877 events per sec
13:hash_map_full_perf 1561836 events per sec
14:hash_map_full_perf 1388895 events per sec
15:hash_map_full_perf 1579054 events per sec

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 tools/testing/selftests/bpf/Makefile          |  4 +-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../benchs/bench_bpf_hashmap_full_update.c    | 96 +++++++++++++++++++
 .../run_bench_bpf_hashmap_full_update.sh      | 11 +++
 .../bpf/progs/bpf_hashmap_full_update_bench.c | 40 ++++++++
 5 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3820608faf57..b968649c7aa1 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -549,6 +549,7 @@ $(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
 $(OUTPUT)/bench_bloom_filter_map.o: $(OUTPUT)/bloom_filter_bench.skel.h
 $(OUTPUT)/bench_bpf_loop.o: $(OUTPUT)/bpf_loop_bench.skel.h
 $(OUTPUT)/bench_strncmp.o: $(OUTPUT)/strncmp_bench.skel.h
+$(OUTPUT)/bench_bpf_hashmap_full_update.o: $(OUTPUT)/bpf_hashmap_full_update_bench.skel.h
 $(OUTPUT)/bench.o: bench.h testing_helpers.h $(BPFOBJ)
 $(OUTPUT)/bench: LDLIBS += -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o \
@@ -560,7 +561,8 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 		 $(OUTPUT)/bench_ringbufs.o \
 		 $(OUTPUT)/bench_bloom_filter_map.o \
 		 $(OUTPUT)/bench_bpf_loop.o \
-		 $(OUTPUT)/bench_strncmp.o
+		 $(OUTPUT)/bench_strncmp.o \
+		 $(OUTPUT)/bench_bpf_hashmap_full_update.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index f973320e6dbf..35de886d9a05 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -397,6 +397,7 @@ extern const struct bench bench_hashmap_with_bloom;
 extern const struct bench bench_bpf_loop;
 extern const struct bench bench_strncmp_no_helper;
 extern const struct bench bench_strncmp_helper;
+extern const struct bench bench_bpf_hashmap_full_update;
 
 static const struct bench *benchs[] = {
 	&bench_count_global,
@@ -431,6 +432,7 @@ static const struct bench *benchs[] = {
 	&bench_bpf_loop,
 	&bench_strncmp_no_helper,
 	&bench_strncmp_helper,
+	&bench_bpf_hashmap_full_update,
 };
 
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c b/tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c
new file mode 100644
index 000000000000..cec51e0ff4b8
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Bytedance */
+
+#include <argp.h>
+#include "bench.h"
+#include "bpf_hashmap_full_update_bench.skel.h"
+#include "bpf_util.h"
+
+/* BPF triggering benchmarks */
+static struct ctx {
+	struct bpf_hashmap_full_update_bench *skel;
+} ctx;
+
+#define MAX_LOOP_NUM 10000
+
+static void validate(void)
+{
+	if (env.consumer_cnt != 1) {
+		fprintf(stderr, "benchmark doesn't support multi-consumer!\n");
+		exit(1);
+	}
+}
+
+static void *producer(void *input)
+{
+	while (true) {
+		/* trigger the bpf program */
+		syscall(__NR_getpgid);
+	}
+
+	return NULL;
+}
+
+static void *consumer(void *input)
+{
+	return NULL;
+}
+
+static void measure(struct bench_res *res)
+{
+}
+
+static void setup(void)
+{
+	struct bpf_link *link;
+	int map_fd, i, max_entries;
+
+	setup_libbpf();
+
+	ctx.skel = bpf_hashmap_full_update_bench__open_and_load();
+	if (!ctx.skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	ctx.skel->bss->nr_loops = MAX_LOOP_NUM;
+
+	link = bpf_program__attach(ctx.skel->progs.benchmark);
+	if (!link) {
+		fprintf(stderr, "failed to attach program!\n");
+		exit(1);
+	}
+
+	/* fill hash_map */
+	map_fd = bpf_map__fd(ctx.skel->maps.hash_map_bench);
+	max_entries = bpf_map__max_entries(ctx.skel->maps.hash_map_bench);
+	for (i = 0; i < max_entries; i++)
+		bpf_map_update_elem(map_fd, &i, &i, BPF_ANY);
+}
+
+void hashmap_report_final(struct bench_res res[], int res_cnt)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	int i;
+
+	for (i = 0; i < nr_cpus; i++) {
+		u64 time = ctx.skel->bss->percpu_time[i];
+
+		if (!time)
+			continue;
+
+		printf("%d:hash_map_full_perf %lld events per sec\n",
+		       i, ctx.skel->bss->nr_loops * 1000000000ll / time);
+	}
+}
+
+const struct bench bench_bpf_hashmap_full_update = {
+	.name = "bpf-hashmap-ful-update",
+	.validate = validate,
+	.setup = setup,
+	.producer_thread = producer,
+	.consumer_thread = consumer,
+	.measure = measure,
+	.report_progress = NULL,
+	.report_final = hashmap_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh b/tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh
new file mode 100755
index 000000000000..1e2de838f9fa
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source ./benchs/run_common.sh
+
+set -eufo pipefail
+
+nr_threads=`expr $(cat /proc/cpuinfo | grep "processor"| wc -l) - 1`
+summary=$($RUN_BENCH -p $nr_threads bpf-hashmap-ful-update)
+printf "$summary"
+printf "\n"
diff --git a/tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c b/tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c
new file mode 100644
index 000000000000..aa93a03f961d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Bytedance */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+#define MAX_ENTRIES 1000
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, MAX_ENTRIES);
+} hash_map_bench SEC(".maps");
+
+u64 __attribute__((__aligned__(256))) percpu_time[256];
+u64 nr_loops;
+
+static int loop_update_callback(__u32 index, u32 *key)
+{
+	u64 init_val = 1;
+
+	bpf_map_update_elem(&hash_map_bench, key, &init_val, BPF_ANY);
+	return 0;
+}
+
+SEC("fentry/" SYS_PREFIX "sys_getpgid")
+int benchmark(void *ctx)
+{
+	u32 key = bpf_get_prandom_u32() % MAX_ENTRIES + MAX_ENTRIES;
+	u32 cpu = bpf_get_smp_processor_id();
+	u64 start_time = bpf_ktime_get_ns();
+
+	bpf_loop(nr_loops, loop_update_callback, &key, 0);
+	percpu_time[cpu & 255] = bpf_ktime_get_ns() - start_time;
+	return 0;
+}
-- 
2.20.1

