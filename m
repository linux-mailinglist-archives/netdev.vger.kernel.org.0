Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324E035D140
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245309AbhDLTk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243025AbhDLTkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:40:51 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54389C061574;
        Mon, 12 Apr 2021 12:40:32 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id o5so15557073qkb.0;
        Mon, 12 Apr 2021 12:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G9l4aiKJM4go7FzAfgupa7+4yXIb0n+i6BsEUOdnQ3s=;
        b=krv/jDks++/lqrmK/R+qy04YU1krDr4DtotLWy0e1RrCNLw7JK9FknbJN2nywtiQkH
         0bFh28cJg9MdBt38eseA0K/7RDyepNKKJOnBjNdrKppYJ8unjTZ5nMqNuimNmxzOPWAz
         LkoS7xc7l5F5KhopaP3UkuAD9ibAn/t1VcAbmd8mtl1DnJEEqztO+IQjBKKIHaxaBfWg
         MG2vMSiY7WqSul6URzReSN3ysnzfhkoWZL/L8kd6S3iar/ber+n3uzmMzarb6p65yluA
         peNEhTt8ud3gbO8WrV1fDWimH8cs1ilACeCmL4wndXSuQyjqozq0OcCAnbiGsdw9h2ID
         1VKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G9l4aiKJM4go7FzAfgupa7+4yXIb0n+i6BsEUOdnQ3s=;
        b=VzPDxV5ost4JJeGtimR2NEKr+C8VRCB8QPb+HPDsIVGHjXYca+isbeY+xHSqNppx+v
         c9C+WnD9yhiDXacjlIF5n16Bw8LMs+o4e8NZYu28o4ljPeyysm7BS2FpMvX2fldY+BXE
         OwQh9/Hi57XOlE5wVEDYUfzR/oJ4e2bSkcEfMD8MOUAMDs1KVn6JlsvG3ldX60ANzrUY
         m4L3wmdpyK1D6AkI6LRg2WkQq85E8TdFCnPfvbk4UeMaRUzGzWlrYh+7SieeJW1Nyh7z
         sQgOSZz74a5iAcIgeqgxJe8CuSTelakv9h/POp1x27b1mm14a7thBw3kvkLQrCFt9iKu
         f1og==
X-Gm-Message-State: AOAM530hJVHnbhb1zEjNZj5DD5Acdsfko0c+CiWwGegwPgq1EMElJay9
        UHDgSviiKyCr/4W1CbcghZI=
X-Google-Smtp-Source: ABdhPJysd7n2jeV6h3HzQdLMPsBWj6M9XJqr7HyVS41pfGqG+gcQ+puHo1Btior3d/rpJQPL5g1FTA==
X-Received: by 2002:a05:620a:3c1:: with SMTP id r1mr28188181qkm.339.1618256431595;
        Mon, 12 Apr 2021 12:40:31 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id j30sm8407911qka.57.2021.04.12.12.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 12:40:31 -0700 (PDT)
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
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Verbeiren <david.verbeiren@tessares.net>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next v3 3/3] bpf: selftests: update array map tests for per-cpu batched ops
Date:   Mon, 12 Apr 2021 16:40:01 -0300
Message-Id: <20210412194001.946213-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412194001.946213-1-pctammela@mojatatu.com>
References: <20210412194001.946213-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the same logic as the hashtable tests.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 .../bpf/map_tests/array_map_batch_ops.c       | 110 +++++++++++++-----
 1 file changed, 80 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
index e42ea1195d18..707d17414dee 100644
--- a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
@@ -10,32 +10,59 @@
 #include <test_maps.h>
 
 static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
-			     int *values)
+			     __s64 *values, bool is_pcpu)
 {
-	int i, err;
+	int nr_cpus = libbpf_num_possible_cpus();
+	int i, j, err;
+	int offset = 0;
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
 		.elem_flags = 0,
 		.flags = 0,
 	);
 
+	CHECK(nr_cpus < 0, "nr_cpus checking",
+	      "error: get possible cpus failed");
+
 	for (i = 0; i < max_entries; i++) {
 		keys[i] = i;
-		values[i] = i + 1;
+		if (is_pcpu)
+			for (j = 0; j < nr_cpus; j++)
+				(values + offset)[j] = i + 1 + j;
+		else
+			values[i] = i + 1;
+		offset += nr_cpus;
 	}
 
 	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
 	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
 }
 
-static void map_batch_verify(int *visited, __u32 max_entries,
-			     int *keys, int *values)
+static void map_batch_verify(int *visited, __u32 max_entries, int *keys,
+			     __s64 *values, bool is_pcpu)
 {
-	int i;
+	int nr_cpus = libbpf_num_possible_cpus();
+	int i, j;
+	int offset = 0;
+
+	CHECK(nr_cpus < 0, "nr_cpus checking",
+	      "error: get possible cpus failed");
 
 	memset(visited, 0, max_entries * sizeof(*visited));
 	for (i = 0; i < max_entries; i++) {
-		CHECK(keys[i] + 1 != values[i], "key/value checking",
-		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+		if (is_pcpu) {
+			for (j = 0; j < nr_cpus; j++) {
+				__s64 value = (values + offset)[j];
+				CHECK(keys[i] + j + 1 != value,
+				      "key/value checking",
+				      "error: i %d j %d key %d value %d\n", i,
+				      j, keys[i], value);
+			}
+		} else {
+			CHECK(keys[i] + 1 != values[i], "key/value checking",
+			      "error: i %d key %d value %d\n", i, keys[i],
+			      values[i]);
+		}
+		offset += nr_cpus;
 		visited[i] = 1;
 	}
 	for (i = 0; i < max_entries; i++) {
@@ -44,45 +71,52 @@ static void map_batch_verify(int *visited, __u32 max_entries,
 	}
 }
 
-void test_array_map_batch_ops(void)
+void __test_map_lookup_and_update_batch(bool is_pcpu)
 {
+	int nr_cpus = libbpf_num_possible_cpus();
 	struct bpf_create_map_attr xattr = {
 		.name = "array_map",
-		.map_type = BPF_MAP_TYPE_ARRAY,
+		.map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_ARRAY :
+				      BPF_MAP_TYPE_ARRAY,
 		.key_size = sizeof(int),
-		.value_size = sizeof(int),
+		.value_size = sizeof(__s64),
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
 	);
 
+	CHECK(nr_cpus < 0, "nr_cpus checking",
+	      "error: get possible cpus failed");
+
 	xattr.max_entries = max_entries;
 	map_fd = bpf_create_map_xattr(&xattr);
 	CHECK(map_fd == -1,
 	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
 
-	keys = malloc(max_entries * sizeof(int));
-	values = malloc(max_entries * sizeof(int));
-	visited = malloc(max_entries * sizeof(int));
+	value_size = sizeof(__s64);
+	if (is_pcpu)
+		value_size *= nr_cpus;
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
@@ -91,10 +125,10 @@ void test_array_map_batch_ops(void)
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
@@ -108,7 +142,7 @@ void test_array_map_batch_ops(void)
 		CHECK(total != max_entries, "lookup with steps",
 		      "total = %u, max_entries = %u\n", total, max_entries);
 
-		map_batch_verify(visited, max_entries, keys, values);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
 
 		total_success++;
 	}
@@ -116,9 +150,25 @@ void test_array_map_batch_ops(void)
 	CHECK(total_success == 0, "check total_success",
 	      "unexpected failure\n");
 
-	printf("%s:PASS\n", __func__);
-
 	free(keys);
-	free(values);
 	free(visited);
+	free(values);
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

