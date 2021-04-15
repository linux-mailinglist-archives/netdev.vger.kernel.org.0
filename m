Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB85136115B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhDORr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbhDORr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 13:47:28 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E99EC061574;
        Thu, 15 Apr 2021 10:47:05 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id y12so18832098qtx.11;
        Thu, 15 Apr 2021 10:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2KDicF4vU5U8a2+t0WntuEZwxtFuuCTnJ7ZA8aTTe24=;
        b=btkxABbGuN7jzLQcL7FMXWy3+i7+nFpuemycBElio+UswcawgxUR7WaHhAbH3x+0aq
         l2LE6aBvsLEKIN+ApsG22CkfRMzhDEi9okusEjXAxAOkAfeJxTXd3GXeuTABMJo9ErpV
         oOZY8Dk69nAJfWL7onBOYp1F7JXfg9Y7xGXZgMNll9ZD0HJie97NZuiBmieowcvPSiLI
         nXNZ8Q16IDRFnsVUsupmH9Fd1DFRhInuYytkBvQlANgJGnOETF/bMSwvrLToYub8drx3
         ce5Ls10CRWSKEi/5+8xGk0ixkSrTCqTeSoW4ani/et1zjCFET+duu7qaao8iwNMnQ1BD
         /fQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2KDicF4vU5U8a2+t0WntuEZwxtFuuCTnJ7ZA8aTTe24=;
        b=QZqzY9+ej/txrERQcVWrV2+JJFMD3jVEOOEDpnddPp6bgcPSecLYKjzXA2SJMccHcj
         TOoDj87RJ/8y34XjG6LYFBjWEWHBow/SCHp4Y0S7eoFLx7TBfAjf1XKYMv84Vv4G97JP
         Q4DE6xtNeQrRI3Uvn3QUCbRrZH9MZd2B8p6cCTtfeurZ7vLifH8CVi96c4M1/EcZyVNU
         H7fDhT4nwr1fW/a6EIy7c4nGvMm9V+1mrNDeevxSIJKbiwuKC41MHZPxZ/H5lwCesudP
         9gOkXewAmDC3LDNbanY+JeXNHoHJGhAEGl+Xh5u9XtVmtp3JoFlCPvZFH41mDL4k83z3
         o0wQ==
X-Gm-Message-State: AOAM531BjDL58KrL/cGj0fIN+mN3i4Bz/nKAn9MUKGv+EVcMAgBHRuBB
        BRYM0AgscYopU/RgN6NLdNA=
X-Google-Smtp-Source: ABdhPJzNRDia6y+NeLnt/CqAOBk7x8TKPdCdDniYklAUn7nMfN7jnLDSH0O04BQsO9O8chSZMOzHhQ==
X-Received: by 2002:a05:622a:d5:: with SMTP id p21mr3965044qtw.235.1618508824288;
        Thu, 15 Apr 2021 10:47:04 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id a4sm2186800qta.19.2021.04.15.10.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 10:47:04 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 2/3] bpf: selftests: remove percpu macros from bpf_util.h
Date:   Thu, 15 Apr 2021 14:46:18 -0300
Message-Id: <20210415174619.51229-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415174619.51229-1-pctammela@mojatatu.com>
References: <20210415174619.51229-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii suggested to remove this abstraction layer and have the percpu
handling more explicit[1].

This patch also updates the tests that relied on the macros.

[1] https://lore.kernel.org/bpf/CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com/

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tools/testing/selftests/bpf/bpf_util.h        |  7 --
 .../bpf/map_tests/htab_map_batch_ops.c        | 87 +++++++++----------
 .../selftests/bpf/prog_tests/map_init.c       |  9 +-
 tools/testing/selftests/bpf/test_maps.c       | 84 +++++++++++-------
 4 files changed, 96 insertions(+), 91 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
index a3352a64c067..105db3120ab4 100644
--- a/tools/testing/selftests/bpf/bpf_util.h
+++ b/tools/testing/selftests/bpf/bpf_util.h
@@ -20,13 +20,6 @@ static inline unsigned int bpf_num_possible_cpus(void)
 	return possible_cpus;
 }
 
-#define __bpf_percpu_val_align	__attribute__((__aligned__(8)))
-
-#define BPF_DECLARE_PERCPU(type, name)				\
-	struct { type v; /* padding */ } __bpf_percpu_val_align	\
-		name[bpf_num_possible_cpus()]
-#define bpf_percpu(name, cpu) name[(cpu)].v
-
 #ifndef ARRAY_SIZE
 # define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #endif
diff --git a/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
index 976bf415fbdd..8562600ad1df 100644
--- a/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
@@ -7,65 +7,60 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include <bpf_util.h>
 #include <test_maps.h>
 
+static int nr_cpus;
+
 static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
-			     void *values, bool is_pcpu)
+			     __s64 *values, bool is_pcpu)
 {
-	typedef BPF_DECLARE_PERCPU(int, value);
-	value *v = NULL;
 	int i, j, err;
+	int cpu_offset = 0;
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
 		.elem_flags = 0,
 		.flags = 0,
 	);
 
-	if (is_pcpu)
-		v = (value *)values;
-
 	for (i = 0; i < max_entries; i++) {
 		keys[i] = i + 1;
-		if (is_pcpu)
-			for (j = 0; j < bpf_num_possible_cpus(); j++)
-				bpf_percpu(v[i], j) = i + 2 + j;
-		else
-			((int *)values)[i] = i + 2;
+		if (is_pcpu) {
+			cpu_offset = i * nr_cpus;
+			for (j = 0; j < nr_cpus; j++)
+				(values + cpu_offset)[j] = i + 2 + j;
+
+		} else {
+			values[i] = i + 2;
+		}
 	}
 
 	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
 	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
 }
 
-static void map_batch_verify(int *visited, __u32 max_entries,
-			     int *keys, void *values, bool is_pcpu)
+static void map_batch_verify(int *visited, __u32 max_entries, int *keys,
+			     __s64 *values, bool is_pcpu)
 {
-	typedef BPF_DECLARE_PERCPU(int, value);
-	value *v = NULL;
 	int i, j;
-
-	if (is_pcpu)
-		v = (value *)values;
+	int cpu_offset = 0;
 
 	memset(visited, 0, max_entries * sizeof(*visited));
 	for (i = 0; i < max_entries; i++) {
-
 		if (is_pcpu) {
-			for (j = 0; j < bpf_num_possible_cpus(); j++) {
-				CHECK(keys[i] + 1 + j != bpf_percpu(v[i], j),
+			cpu_offset = i * nr_cpus;
+			for (j = 0; j < nr_cpus; j++) {
+				__s64 value = (values + cpu_offset)[j];
+				CHECK(keys[i] + 1 + j != value,
 				      "key/value checking",
-				      "error: i %d j %d key %d value %d\n",
-				      i, j, keys[i], bpf_percpu(v[i],  j));
+				      "error: i %d j %d key %d value %lld\n", i,
+				      j, keys[i], value);
 			}
+
 		} else {
-			CHECK(keys[i] + 1 != ((int *)values)[i],
-			      "key/value checking",
-			      "error: i %d key %d value %d\n", i, keys[i],
-			      ((int *)values)[i]);
+			CHECK(keys[i] + 1 != values[i], "key/value checking",
+			      "error: i %d key %d value %lld\n", i, keys[i],
+			      values[i]);
 		}
-
 		visited[i] = 1;
-
 	}
 	for (i = 0; i < max_entries; i++) {
 		CHECK(visited[i] != 1, "visited checking",
@@ -73,13 +68,11 @@ static void map_batch_verify(int *visited, __u32 max_entries,
 	}
 }
 
-void __test_map_lookup_and_delete_batch(bool is_pcpu)
+static void __test_map_lookup_and_delete_batch(bool is_pcpu)
 {
 	__u32 batch, count, total, total_success;
-	typedef BPF_DECLARE_PERCPU(int, value);
 	int map_fd, *keys, *visited, key;
 	const __u32 max_entries = 10;
-	value pcpu_values[max_entries];
 	int err, step, value_size;
 	bool nospace_err;
 	void *values;
@@ -88,7 +81,7 @@ void __test_map_lookup_and_delete_batch(bool is_pcpu)
 		.map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_HASH :
 			    BPF_MAP_TYPE_HASH,
 		.key_size = sizeof(int),
-		.value_size = sizeof(int),
+		.value_size = sizeof(__s64),
 	};
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
 		.elem_flags = 0,
@@ -100,13 +93,13 @@ void __test_map_lookup_and_delete_batch(bool is_pcpu)
 	CHECK(map_fd == -1,
 	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
 
-	value_size = is_pcpu ? sizeof(value) : sizeof(int);
-	keys = malloc(max_entries * sizeof(int));
+	value_size = sizeof(__s64);
 	if (is_pcpu)
-		values = pcpu_values;
-	else
-		values = malloc(max_entries * sizeof(int));
-	visited = malloc(max_entries * sizeof(int));
+		value_size *= nr_cpus;
+
+	keys = calloc(max_entries, sizeof(int));
+	values = calloc(max_entries, value_size);
+	visited = calloc(max_entries, sizeof(int));
 	CHECK(!keys || !values || !visited, "malloc()",
 	      "error:%s\n", strerror(errno));
 
@@ -203,7 +196,7 @@ void __test_map_lookup_and_delete_batch(bool is_pcpu)
 		CHECK(total != max_entries, "delete with steps",
 		      "total = %u, max_entries = %u\n", total, max_entries);
 
-		/* check map is empty, errono == ENOENT */
+		/* check map is empty, errno == ENOENT */
 		err = bpf_map_get_next_key(map_fd, NULL, &key);
 		CHECK(!err || errno != ENOENT, "bpf_map_get_next_key()",
 		      "error: %s\n", strerror(errno));
@@ -260,17 +253,16 @@ void __test_map_lookup_and_delete_batch(bool is_pcpu)
 	      "unexpected failure\n");
 	free(keys);
 	free(visited);
-	if (!is_pcpu)
-		free(values);
+	free(values);
 }
 
-void htab_map_batch_ops(void)
+static void htab_map_batch_ops(void)
 {
 	__test_map_lookup_and_delete_batch(false);
 	printf("test_%s:PASS\n", __func__);
 }
 
-void htab_percpu_map_batch_ops(void)
+static void htab_percpu_map_batch_ops(void)
 {
 	__test_map_lookup_and_delete_batch(true);
 	printf("test_%s:PASS\n", __func__);
@@ -278,6 +270,11 @@ void htab_percpu_map_batch_ops(void)
 
 void test_htab_map_batch_ops(void)
 {
+	nr_cpus = libbpf_num_possible_cpus();
+
+	CHECK(nr_cpus < 0, "nr_cpus checking",
+	      "error: get possible cpus failed");
+
 	htab_map_batch_ops();
 	htab_percpu_map_batch_ops();
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/map_init.c b/tools/testing/selftests/bpf/prog_tests/map_init.c
index 14a31109dd0e..49386d0aa684 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_init.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_init.c
@@ -12,10 +12,7 @@ static int duration;
 
 typedef unsigned long long map_key_t;
 typedef unsigned long long map_value_t;
-typedef struct {
-	map_value_t v; /* padding */
-} __bpf_percpu_val_align pcpu_map_value_t;
-
+typedef __s64 pcpu_map_value_t;
 
 static int map_populate(int map_fd, int num)
 {
@@ -24,7 +21,7 @@ static int map_populate(int map_fd, int num)
 	map_key_t key;
 
 	for (i = 0; i < nr_cpus; i++)
-		bpf_percpu(value, i) = FILL_VALUE;
+		value[i] = FILL_VALUE;
 
 	for (key = 1; key <= num; key++) {
 		err = bpf_map_update_elem(map_fd, &key, value, BPF_NOEXIST);
@@ -103,7 +100,7 @@ static int check_values_one_cpu(pcpu_map_value_t *value, map_value_t expected)
 	map_value_t val;
 
 	for (i = 0; i < nr_cpus; i++) {
-		val = bpf_percpu(value, i);
+		val = value[i];
 		if (val) {
 			if (CHECK(val != expected, "map value",
 				  "unexpected for cpu %d: 0x%llx\n", i, val))
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 51adc42b2b40..b8ce837a7ada 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -146,63 +146,69 @@ static void test_hashmap_sizes(unsigned int task, void *data)
 
 static void test_hashmap_percpu(unsigned int task, void *data)
 {
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	BPF_DECLARE_PERCPU(long, value);
+	int nr_cpus = libbpf_num_possible_cpus();
+	__s64 *values;
 	long long key, next_key, first_key;
 	int expected_key_mask = 0;
 	int fd, i;
 
+	if (nr_cpus < 0) {
+		printf("Failed get possible cpus\n");
+		exit(1);
+	}
+
+	values = alloca(nr_cpus * sizeof(__s64));
+
 	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_HASH, sizeof(key),
-			    sizeof(bpf_percpu(value, 0)), 2, map_flags);
+			    sizeof(*values), 2, map_flags);
 	if (fd < 0) {
 		printf("Failed to create hashmap '%s'!\n", strerror(errno));
 		exit(1);
 	}
 
 	for (i = 0; i < nr_cpus; i++)
-		bpf_percpu(value, i) = i + 100;
+		values[i] = i + 100;
 
 	key = 1;
 	/* Insert key=1 element. */
 	assert(!(expected_key_mask & key));
-	assert(bpf_map_update_elem(fd, &key, value, BPF_ANY) == 0);
+	assert(bpf_map_update_elem(fd, &key, values, BPF_ANY) == 0);
 	expected_key_mask |= key;
 
 	/* BPF_NOEXIST means add new element if it doesn't exist. */
-	assert(bpf_map_update_elem(fd, &key, value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, values, BPF_NOEXIST) == -1 &&
 	       /* key=1 already exists. */
 	       errno == EEXIST);
 
 	/* -1 is an invalid flag. */
-	assert(bpf_map_update_elem(fd, &key, value, -1) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, values, -1) == -1 &&
 	       errno == EINVAL);
 
 	/* Check that key=1 can be found. Value could be 0 if the lookup
 	 * was run from a different CPU.
 	 */
-	bpf_percpu(value, 0) = 1;
-	assert(bpf_map_lookup_elem(fd, &key, value) == 0 &&
-	       bpf_percpu(value, 0) == 100);
+	values[0] = 1;
+	assert(bpf_map_lookup_elem(fd, &key, values) == 0 && values[0] == 100);
 
 	key = 2;
 	/* Check that key=2 is not found. */
-	assert(bpf_map_lookup_elem(fd, &key, value) == -1 && errno == ENOENT);
+	assert(bpf_map_lookup_elem(fd, &key, values) == -1 && errno == ENOENT);
 
 	/* BPF_EXIST means update existing element. */
-	assert(bpf_map_update_elem(fd, &key, value, BPF_EXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, values, BPF_EXIST) == -1 &&
 	       /* key=2 is not there. */
 	       errno == ENOENT);
 
 	/* Insert key=2 element. */
 	assert(!(expected_key_mask & key));
-	assert(bpf_map_update_elem(fd, &key, value, BPF_NOEXIST) == 0);
+	assert(bpf_map_update_elem(fd, &key, values, BPF_NOEXIST) == 0);
 	expected_key_mask |= key;
 
 	/* key=1 and key=2 were inserted, check that key=0 cannot be
 	 * inserted due to max_entries limit.
 	 */
 	key = 0;
-	assert(bpf_map_update_elem(fd, &key, value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, values, BPF_NOEXIST) == -1 &&
 	       errno == E2BIG);
 
 	/* Check that key = 0 doesn't exist. */
@@ -219,10 +225,10 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 		assert((expected_key_mask & next_key) == next_key);
 		expected_key_mask &= ~next_key;
 
-		assert(bpf_map_lookup_elem(fd, &next_key, value) == 0);
+		assert(bpf_map_lookup_elem(fd, &next_key, values) == 0);
 
 		for (i = 0; i < nr_cpus; i++)
-			assert(bpf_percpu(value, i) == i + 100);
+			assert(values[i] == i + 100);
 
 		key = next_key;
 	}
@@ -230,7 +236,7 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 
 	/* Update with BPF_EXIST. */
 	key = 1;
-	assert(bpf_map_update_elem(fd, &key, value, BPF_EXIST) == 0);
+	assert(bpf_map_update_elem(fd, &key, values, BPF_EXIST) == 0);
 
 	/* Delete both elements. */
 	key = 1;
@@ -399,37 +405,42 @@ static void test_arraymap(unsigned int task, void *data)
 
 static void test_arraymap_percpu(unsigned int task, void *data)
 {
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	BPF_DECLARE_PERCPU(long, values);
+	int nr_cpus = libbpf_num_possible_cpus();
+	__s64 *values;
 	int key, next_key, fd, i;
 
+	if (nr_cpus < 0) {
+		printf("Failed get possible cpus\n");
+		exit(1);
+	}
+
+	values = alloca(nr_cpus * sizeof(__s64));
+
 	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
-			    sizeof(bpf_percpu(values, 0)), 2, 0);
+			    sizeof(*values), 2, 0);
 	if (fd < 0) {
 		printf("Failed to create arraymap '%s'!\n", strerror(errno));
 		exit(1);
 	}
 
 	for (i = 0; i < nr_cpus; i++)
-		bpf_percpu(values, i) = i + 100;
+		values[i] = i + 100;
 
 	key = 1;
 	/* Insert key=1 element. */
 	assert(bpf_map_update_elem(fd, &key, values, BPF_ANY) == 0);
 
-	bpf_percpu(values, 0) = 0;
+	values[0] = 0;
 	assert(bpf_map_update_elem(fd, &key, values, BPF_NOEXIST) == -1 &&
 	       errno == EEXIST);
 
 	/* Check that key=1 can be found. */
-	assert(bpf_map_lookup_elem(fd, &key, values) == 0 &&
-	       bpf_percpu(values, 0) == 100);
+	assert(bpf_map_lookup_elem(fd, &key, values) == 0 && values[0] == 100);
 
 	key = 0;
 	/* Check that key=0 is also found and zero initialized. */
-	assert(bpf_map_lookup_elem(fd, &key, values) == 0 &&
-	       bpf_percpu(values, 0) == 0 &&
-	       bpf_percpu(values, nr_cpus - 1) == 0);
+	assert(bpf_map_lookup_elem(fd, &key, values) == 0 && values[0] == 0 &&
+	       values[nr_cpus - 1] == 0);
 
 	/* Check that key=2 cannot be inserted due to max_entries limit. */
 	key = 2;
@@ -458,16 +469,23 @@ static void test_arraymap_percpu(unsigned int task, void *data)
 
 static void test_arraymap_percpu_many_keys(void)
 {
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	BPF_DECLARE_PERCPU(long, values);
+	unsigned int nr_cpus = libbpf_num_possible_cpus();
+	__s64 *values;
 	/* nr_keys is not too large otherwise the test stresses percpu
 	 * allocator more than anything else
 	 */
 	unsigned int nr_keys = 2000;
 	int key, fd, i;
 
+	if (nr_cpus < 0) {
+		printf("Failed get possible cpus\n");
+		exit(1);
+	}
+
+	values = alloca(nr_cpus * sizeof(__s64));
+
 	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
-			    sizeof(bpf_percpu(values, 0)), nr_keys, 0);
+			    sizeof(*values), nr_keys, 0);
 	if (fd < 0) {
 		printf("Failed to create per-cpu arraymap '%s'!\n",
 		       strerror(errno));
@@ -475,19 +493,19 @@ static void test_arraymap_percpu_many_keys(void)
 	}
 
 	for (i = 0; i < nr_cpus; i++)
-		bpf_percpu(values, i) = i + 10;
+		values[i] = i + 10;
 
 	for (key = 0; key < nr_keys; key++)
 		assert(bpf_map_update_elem(fd, &key, values, BPF_ANY) == 0);
 
 	for (key = 0; key < nr_keys; key++) {
 		for (i = 0; i < nr_cpus; i++)
-			bpf_percpu(values, i) = 0;
+			values[i] = 0;
 
 		assert(bpf_map_lookup_elem(fd, &key, values) == 0);
 
 		for (i = 0; i < nr_cpus; i++)
-			assert(bpf_percpu(values, i) == i + 10);
+			assert(values[i] == i + 10);
 	}
 
 	close(fd);
-- 
2.25.1

