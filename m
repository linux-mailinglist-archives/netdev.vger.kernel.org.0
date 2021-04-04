Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5093539A7
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 22:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhDDUEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 16:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhDDUEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 16:04:40 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9947BC061756;
        Sun,  4 Apr 2021 13:04:33 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id q26so9855974qkm.6;
        Sun, 04 Apr 2021 13:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HlGPj7kENQWAqZAKMcG5RxVYRrzRUc0vMrF8iaMnLfo=;
        b=foUak0moVfnX1jh/tPE2Kp2o575GleB5RoWRsdJJAdWsk4nZo04BOl/+AJo5d5eqPU
         3dlO2r7CplDCwa/xtt8EGOB8G7Biyn9ZDYcGSjIO32BHBJ2sbm+lvvl0q14P5J0UJvQQ
         /9T0Ky50k6laQRhqw9DASNeRRA4zgMszuckRU9cFEFzIPI6SIRVbAGTq9hh3ciMNo6KC
         w1NRGtZHt7H/33PDLZ1OtvjUDKgKiNIv3iqMPaHczvE4Vc7XlmebHm/P9ydpKG27RlOl
         KgFJCwksP2qmcITUya3dT+hHcYBROD+sp9WLUCkzOBD81PjIWUD/dmY1qpt0gLzs787N
         T3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HlGPj7kENQWAqZAKMcG5RxVYRrzRUc0vMrF8iaMnLfo=;
        b=Ww6SWNgp/TpyRVlN5rO52gKknXE+PnuR0cLnmq/Z/rnfJ5G5Rpb5o3zWHpDl+OY/qP
         fpwTQUbOWcF7ErUvBaoGyfLIlx8/zIcj0Rb16EdkMNVtfN0K5woibED9KHm50LLweye6
         7N6CoIFqV7JZPB2TjXuF7xg4en4M+xc0I0HDpVaR8/gD8YQ5/8hnXd34Xf1gGDRrlkZV
         AbiwreWDo0tElxuackELS3lEBltAHyIYzbAA4cg24pWXWZGLIle91F29oL0GH3Ku+mlW
         raRW5Cck7i3HTfqkUp1oIhH7tRdhly6Eb1/zGSr8acnsVoHdQO+qIK9befINWn4qdAFt
         wjTg==
X-Gm-Message-State: AOAM5309vYPPbkT1H/j9BA5smiV12ZRwipSeuTQ8IETMWWBcNkjHKlkL
        MRy904sXADfA/C9WzAuq+/I=
X-Google-Smtp-Source: ABdhPJwzBRs9KvwduFiMGOw+7eqDxgqQRSpu6SiAW2+HyblAXlmQRz02KPfKIy2dtdEV1k41NTLQdg==
X-Received: by 2002:a05:620a:4116:: with SMTP id j22mr21509049qko.446.1617566672856;
        Sun, 04 Apr 2021 13:04:32 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id d24sm12163480qkl.49.2021.04.04.13.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 13:04:32 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next 3/3] bpf: selftests: update array map tests for per-cpu batched ops
Date:   Sun,  4 Apr 2021 17:02:48 -0300
Message-Id: <20210404200256.300532-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210404200256.300532-1-pctammela@mojatatu.com>
References: <20210404200256.300532-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the same logic as the hashtable tests.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 .../bpf/map_tests/array_map_batch_ops.c       | 114 +++++++++++++-----
 1 file changed, 85 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
index e42ea1195d18..e71b5fbf41b4 100644
--- a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
@@ -7,35 +7,68 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
+#include <bpf_util.h>
 #include <test_maps.h>
 
+typedef BPF_PERCPU_TYPE(int) pcpu_map_value_t;
+
 static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
-			     int *values)
+			     void *values, bool is_pcpu)
 {
-	int i, err;
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	pcpu_map_value_t *v;
+	int i, j, err;
+	int offset = 0;
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
 		.elem_flags = 0,
 		.flags = 0,
 	);
 
+	if (is_pcpu)
+		v = values;
+
 	for (i = 0; i < max_entries; i++) {
 		keys[i] = i;
-		values[i] = i + 1;
+		if (is_pcpu)
+			for (j = 0; j < nr_cpus; j++)
+				bpf_percpu(v + offset, j) = i + 1 + j;
+		else
+			((int *)values)[i] = i + 1;
+		offset += nr_cpus;
 	}
 
 	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
 	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
 }
 
-static void map_batch_verify(int *visited, __u32 max_entries,
-			     int *keys, int *values)
+static void map_batch_verify(int *visited, __u32 max_entries, int *keys,
+			     void *values, bool is_pcpu)
 {
-	int i;
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	pcpu_map_value_t *v;
+	int i, j;
+	int offset = 0;
+
+	if (is_pcpu)
+		v = values;
 
 	memset(visited, 0, max_entries * sizeof(*visited));
 	for (i = 0; i < max_entries; i++) {
-		CHECK(keys[i] + 1 != values[i], "key/value checking",
-		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+		if (is_pcpu) {
+			for (j = 0; j < nr_cpus; j++) {
+				int value = bpf_percpu(v + offset, j);
+				CHECK(keys[i] + j + 1 != value,
+				      "key/value checking",
+				      "error: i %d j %d key %d value %d\n", i,
+				      j, keys[i], value);
+			}
+		} else {
+			CHECK(keys[i] + 1 != ((int *)values)[i],
+			      "key/value checking",
+			      "error: i %d key %d value %d\n", i, keys[i],
+			      ((int *)values)[i]);
+		}
+		offset += nr_cpus;
 		visited[i] = 1;
 	}
 	for (i = 0; i < max_entries; i++) {
@@ -44,19 +77,22 @@ static void map_batch_verify(int *visited, __u32 max_entries,
 	}
 }
 
-void test_array_map_batch_ops(void)
+void __test_map_lookup_and_update_batch(bool is_pcpu)
 {
+	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct bpf_create_map_attr xattr = {
 		.name = "array_map",
-		.map_type = BPF_MAP_TYPE_ARRAY,
+		.map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_ARRAY :
+				      BPF_MAP_TYPE_ARRAY,
 		.key_size = sizeof(int),
 		.value_size = sizeof(int),
 	};
-	int map_fd, *keys, *values, *visited;
+	int map_fd, *keys, *visited;
 	__u32 count, total, total_success;
 	const __u32 max_entries = 10;
 	__u64 batch = 0;
-	int err, step;
+	int err, step, value_size;
+	void *values;
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
 		.elem_flags = 0,
 		.flags = 0,
@@ -67,22 +103,24 @@ void test_array_map_batch_ops(void)
 	CHECK(map_fd == -1,
 	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
 
-	keys = malloc(max_entries * sizeof(int));
-	values = malloc(max_entries * sizeof(int));
-	visited = malloc(max_entries * sizeof(int));
+	if (is_pcpu)
+		value_size = sizeof(pcpu_map_value_t) * nr_cpus;
+	else
+		value_size = sizeof(int);
+
+	keys = malloc(max_entries * sizeof(*keys));
+	values = calloc(max_entries, value_size);
+	visited = malloc(max_entries * sizeof(*visited));
 	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n",
 	      strerror(errno));
 
-	/* populate elements to the map */
-	map_batch_update(map_fd, max_entries, keys, values);
-
 	/* test 1: lookup in a loop with various steps. */
 	total_success = 0;
 	for (step = 1; step < max_entries; step++) {
-		map_batch_update(map_fd, max_entries, keys, values);
-		map_batch_verify(visited, max_entries, keys, values);
+		map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
 		memset(keys, 0, max_entries * sizeof(*keys));
-		memset(values, 0, max_entries * sizeof(*values));
+		memset(values, 0, max_entries * value_size);
 		batch = 0;
 		total = 0;
 		/* iteratively lookup/delete elements with 'step'
@@ -91,10 +129,10 @@ void test_array_map_batch_ops(void)
 		count = step;
 		while (true) {
 			err = bpf_map_lookup_batch(map_fd,
-						total ? &batch : NULL, &batch,
-						keys + total,
-						values + total,
-						&count, &opts);
+						   total ? &batch : NULL,
+						   &batch, keys + total,
+						   values + total * value_size,
+						   &count, &opts);
 
 			CHECK((err && errno != ENOENT), "lookup with steps",
 			      "error: %s\n", strerror(errno));
@@ -108,7 +146,7 @@ void test_array_map_batch_ops(void)
 		CHECK(total != max_entries, "lookup with steps",
 		      "total = %u, max_entries = %u\n", total, max_entries);
 
-		map_batch_verify(visited, max_entries, keys, values);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
 
 		total_success++;
 	}
@@ -116,9 +154,27 @@ void test_array_map_batch_ops(void)
 	CHECK(total_success == 0, "check total_success",
 	      "unexpected failure\n");
 
-	printf("%s:PASS\n", __func__);
-
 	free(keys);
-	free(values);
 	free(visited);
+
+	if (!is_pcpu)
+		free(values);
+}
+
+void array_map_batch_ops(void)
+{
+	__test_map_lookup_and_update_batch(false);
+	printf("test_%s:PASS\n", __func__);
+}
+
+void array_percpu_map_batch_ops(void)
+{
+	__test_map_lookup_and_update_batch(true);
+	printf("test_%s:PASS\n", __func__);
+}
+
+void test_array_map_batch_ops(void)
+{
+	array_map_batch_ops();
+	array_percpu_map_batch_ops();
 }
-- 
2.25.1

