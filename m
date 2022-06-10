Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38757545A23
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 04:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242290AbiFJCdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 22:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344650AbiFJCdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 22:33:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC58016537C
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 19:33:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j7so22900755pjn.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 19:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h5wjvAfvmc3hQDHOJgTAUHot2+LF/XxihF052IFv5TI=;
        b=3VaZpqIvI/J1A3re8Htg7EDIVwMo6MeNwaxFNAqEj4v6OHRj8ES9oG9J5XtMQYG496
         7fuaJxYoKdl+tN792AhGFiOy7Fpfc8Lr+haRviqE7FGOit3QVBh9Zmzl+k9zQNQMP2pi
         by/ZedpyoWU9HJSGy5YnZ3Zm/+U0Y85AFknQf7O8ttv1PicS3Qlz5/R1y3Nh9CZ6Npu2
         BYZVTuHV28eow0HBJEnEmJHn/2hwO1XxtFIu0qxE4DmRKFSLUzK4rOjI+Ocd8Z+WDk0+
         /pSV8ekFC2sP2zflSDn/kWpDXejSvoZsVzCq8tP8lHnzSYZiBUmRrM0y4GxkVl8c9Htt
         mQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h5wjvAfvmc3hQDHOJgTAUHot2+LF/XxihF052IFv5TI=;
        b=XgxHgAtqES3YAzN2Jz1EfcKuKGGI7WZJZh4AnoohCzyitAClbwkhlhWLtOw4J0l357
         GcNziHfJx19tiFfbZp1XPZP054Bdpp53Y7QGCH1dUMASpeh0PL/Z1XbcXfSNmxFOw925
         KYnqhg2p8N+eBUnEK8P4RBtGti8K5t3eJ46r68lHW20thiRArxaByFGry8o0VwNxhhSt
         qQl9YRKrGO4P0V8FVqzEeckRJcv6HAQ4ADJBrhh/kIJvYo/3P1PucbPE9aioCYwFQkKu
         X1NGBIN2SmrBjrMf75UdKIuxQf2ak5g7dlxlWKJVbYvP5fIzkBLzTnkwaFC5vGRwUO54
         /PFQ==
X-Gm-Message-State: AOAM5339+d/6GohGDd/sGhLg5VFIEUcerkXspVgE/0n0wruw66W51LMj
        X1k2iZxVL/2D6yi8tga8al1bmg==
X-Google-Smtp-Source: ABdhPJwvi9kLXUS59J0d4sPwKM8mXEyRW0q+S6pGLzLrfPy+fr86kvrWBwDqb1tD8jUxoeJEn3wyww==
X-Received: by 2002:a17:90b:3c4e:b0:1e3:36c8:8496 with SMTP id pm14-20020a17090b3c4e00b001e336c88496mr6322932pjb.82.1654828411413;
        Thu, 09 Jun 2022 19:33:31 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id o19-20020a170903009300b001620db30cd6sm17432481pld.201.2022.06.09.19.33.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jun 2022 19:33:31 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v6 2/2] selftest/bpf/benchs: Add bpf_map benchmark
Date:   Fri, 10 Jun 2022 10:33:08 +0800
Message-Id: <20220610023308.93798-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220610023308.93798-1-zhoufeng.zf@bytedance.com>
References: <20220610023308.93798-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add benchmark for hash_map to reproduce the worst case
that non-stop update when map's free is zero.

Just like this:
./run_bench_bpf_hashmap_full_update.sh
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
1:hash_map_full_perf 555830 events per sec
...

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
index 2d3c8c8f558a..8ad7a733a505 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -560,6 +560,7 @@ $(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
 $(OUTPUT)/bench_bloom_filter_map.o: $(OUTPUT)/bloom_filter_bench.skel.h
 $(OUTPUT)/bench_bpf_loop.o: $(OUTPUT)/bpf_loop_bench.skel.h
 $(OUTPUT)/bench_strncmp.o: $(OUTPUT)/strncmp_bench.skel.h
+$(OUTPUT)/bench_bpf_hashmap_full_update.o: $(OUTPUT)/bpf_hashmap_full_update_bench.skel.h
 $(OUTPUT)/bench.o: bench.h testing_helpers.h $(BPFOBJ)
 $(OUTPUT)/bench: LDLIBS += -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o \
@@ -571,7 +572,8 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 		 $(OUTPUT)/bench_ringbufs.o \
 		 $(OUTPUT)/bench_bloom_filter_map.o \
 		 $(OUTPUT)/bench_bpf_loop.o \
-		 $(OUTPUT)/bench_strncmp.o
+		 $(OUTPUT)/bench_strncmp.o \
+		 $(OUTPUT)/bench_bpf_hashmap_full_update.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index f061cc20e776..d8aa62be996b 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -396,6 +396,7 @@ extern const struct bench bench_hashmap_with_bloom;
 extern const struct bench bench_bpf_loop;
 extern const struct bench bench_strncmp_no_helper;
 extern const struct bench bench_strncmp_helper;
+extern const struct bench bench_bpf_hashmap_full_update;
 
 static const struct bench *benchs[] = {
 	&bench_count_global,
@@ -430,6 +431,7 @@ static const struct bench *benchs[] = {
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
index 000000000000..56957557e3e1
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
+	u32 cpu = bpf_get_smp_processor_id();
+	u32 key = cpu + MAX_ENTRIES;
+	u64 start_time = bpf_ktime_get_ns();
+
+	bpf_loop(nr_loops, loop_update_callback, &key, 0);
+	percpu_time[cpu & 255] = bpf_ktime_get_ns() - start_time;
+	return 0;
+}
-- 
2.20.1

