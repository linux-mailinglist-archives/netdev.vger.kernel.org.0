Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45284361160
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhDORrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbhDORrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 13:47:32 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F89CC061574;
        Thu, 15 Apr 2021 10:47:09 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id o17so17600778qkl.13;
        Thu, 15 Apr 2021 10:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=uvNOfoTuzB56ceqkmKY+oWGvxVel5zO/sDE0EqYhDjY=;
        b=R+pmEA1Hy+rIJ/KnSufJ9+sStWSjYP9+CzYroyzU3lLCpETEaa1K0y+sTZfFkXviJe
         vt3ZPOVt9gXZoFePBP5sS+rq3BiYjr6XQ2ysjtK960CCYD0hd0FFUUYFp7GSKT5lg50j
         YUji9g2vQxZ6qOe6kvxbuAIRWlnkTS/kXi0D198g+DkZfhr9R61G4oJhuLF7OI9PWLPE
         zfqKoCaBFrrjMw72k1s7mXKQRKYR2v4IlMtnISi4Jbf8D5WjdxZNzX4UhL5w+TtLcCki
         XUZmbQgySmUE47CT9YcrxyOQ942bus5XrvnUnR54qRPDvWvl1yWp/BBP9PP+u6Sm+es9
         69cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvNOfoTuzB56ceqkmKY+oWGvxVel5zO/sDE0EqYhDjY=;
        b=iIDxkNg4S8qjcVJtkfNsbUsB+Ijcl1a4+83w7fzaeRphBHw4hmArYIA4HoyAtPQokv
         6GcU6AOW+aTmOOdHWWFM5omScO8C+h3z+gSY11cEMRHfO1cY8NZ3vVcQCC5cF2m+omUS
         NC9IgZl0UOCrQkihcviqeNEky0iFDeWpGlIasANL7Heo4307631W/ipNyPzDjpgAi1si
         h1ZoNgx0hd45sc/fyj9+ML8OPUzeLzLzcOyjaG4f+sYUhlAw3wClN5luKlmzxngWtqVd
         H22B4rtM8p+i5UB/SgKRrl8KeCTBNBC9E7YQkEwgivOepQiKB02pXWSw1caW5c+EqhJM
         M3Vw==
X-Gm-Message-State: AOAM531RFm3hxGO9g84zMqzlC8oqwgWBBFOZz7iFCQTwz1vRbZayAOIm
        HJqmLmO3FpQ6xbCwiCl5l9c=
X-Google-Smtp-Source: ABdhPJz0lQwGmc8J/JtVKCRlIuXLS1zpW74V9oV8175TOJ+QzzfdRHzDhdpsfRg8cU8N1oFGRYtTnQ==
X-Received: by 2002:a05:620a:4096:: with SMTP id f22mr4626222qko.76.1618508828643;
        Thu, 15 Apr 2021 10:47:08 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id a4sm2186800qta.19.2021.04.15.10.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 10:47:08 -0700 (PDT)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v4 3/3] bpf: selftests: update array map tests for per-cpu batched ops
Date:   Thu, 15 Apr 2021 14:46:19 -0300
Message-Id: <20210415174619.51229-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415174619.51229-1-pctammela@mojatatu.com>
References: <20210415174619.51229-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the same logic as the hashtable tests.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 .../bpf/map_tests/array_map_batch_ops.c       | 104 +++++++++++++-----
 1 file changed, 75 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
index e42ea1195d18..f4d870da7684 100644
--- a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
@@ -9,10 +9,13 @@
 
 #include <test_maps.h>
 
+static int nr_cpus;
+
 static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
-			     int *values)
+			     __s64 *values, bool is_pcpu)
 {
-	int i, err;
+	int i, j, err;
+	int cpu_offset = 0;
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
 		.elem_flags = 0,
 		.flags = 0,
@@ -20,22 +23,41 @@ static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
 
 	for (i = 0; i < max_entries; i++) {
 		keys[i] = i;
-		values[i] = i + 1;
+		if (is_pcpu) {
+			cpu_offset = i * nr_cpus;
+			for (j = 0; j < nr_cpus; j++)
+				(values + cpu_offset)[j] = i + 1 + j;
+		} else {
+			values[i] = i + 1;
+		}
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
+	int i, j;
+	int cpu_offset = 0;
 
 	memset(visited, 0, max_entries * sizeof(*visited));
 	for (i = 0; i < max_entries; i++) {
-		CHECK(keys[i] + 1 != values[i], "key/value checking",
-		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+		if (is_pcpu) {
+			cpu_offset = i * nr_cpus;
+			for (j = 0; j < nr_cpus; j++) {
+				__s64 value = (values + cpu_offset)[j];
+				CHECK(keys[i] + j + 1 != value,
+				      "key/value checking",
+				      "error: i %d j %d key %d value %lld\n", i,
+				      j, keys[i], value);
+			}
+		} else {
+			CHECK(keys[i] + 1 != values[i], "key/value checking",
+			      "error: i %d key %d value %lld\n", i, keys[i],
+			      values[i]);
+		}
 		visited[i] = 1;
 	}
 	for (i = 0; i < max_entries; i++) {
@@ -44,19 +66,21 @@ static void map_batch_verify(int *visited, __u32 max_entries,
 	}
 }
 
-void test_array_map_batch_ops(void)
+static void __test_map_lookup_and_update_batch(bool is_pcpu)
 {
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
@@ -67,22 +91,23 @@ void test_array_map_batch_ops(void)
 	CHECK(map_fd == -1,
 	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
 
-	keys = malloc(max_entries * sizeof(int));
-	values = malloc(max_entries * sizeof(int));
-	visited = malloc(max_entries * sizeof(int));
+	value_size = sizeof(__s64);
+	if (is_pcpu)
+		value_size *= nr_cpus;
+
+	keys = calloc(max_entries, sizeof(*keys));
+	values = calloc(max_entries, value_size);
+	visited = calloc(max_entries, sizeof(*visited));
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
@@ -91,10 +116,10 @@ void test_array_map_batch_ops(void)
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
@@ -108,7 +133,7 @@ void test_array_map_batch_ops(void)
 		CHECK(total != max_entries, "lookup with steps",
 		      "total = %u, max_entries = %u\n", total, max_entries);
 
-		map_batch_verify(visited, max_entries, keys, values);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
 
 		total_success++;
 	}
@@ -116,9 +141,30 @@ void test_array_map_batch_ops(void)
 	CHECK(total_success == 0, "check total_success",
 	      "unexpected failure\n");
 
-	printf("%s:PASS\n", __func__);
-
 	free(keys);
 	free(values);
 	free(visited);
 }
+
+static void array_map_batch_ops(void)
+{
+	__test_map_lookup_and_update_batch(false);
+	printf("test_%s:PASS\n", __func__);
+}
+
+static void array_percpu_map_batch_ops(void)
+{
+	__test_map_lookup_and_update_batch(true);
+	printf("test_%s:PASS\n", __func__);
+}
+
+void test_array_map_batch_ops(void)
+{
+	nr_cpus = libbpf_num_possible_cpus();
+
+	CHECK(nr_cpus < 0, "nr_cpus checking",
+	      "error: get possible cpus failed");
+
+	array_map_batch_ops();
+	array_percpu_map_batch_ops();
+}
-- 
2.25.1

