Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BB0355BDB
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbhDFSzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbhDFSzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:55:12 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB10C061756;
        Tue,  6 Apr 2021 11:55:01 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id f12so7416786qtf.2;
        Tue, 06 Apr 2021 11:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vK2ONWswjWuqMY4wp7Bc0epbP51m2rqXmIJq9jTsfts=;
        b=lwiLpk9KB0y8pxVF9Y1ikiWp6CqtsCPlxP20Cl19dUwUvzzzUHaV/TOTnQtTG7eRcm
         cSkAe+PZDBMr1wyPV939YQDFj2qS6aw7mUF1irTUKOeO0HdWLAb6MQ6BqYWy+5nxQgEY
         c9HiQtQb+GkPH17Rv9hgQHen1VuF8FnOIHeqd1tqOAknvNEKl1RCGSwWNLsJ3nAFisMw
         OFdXNi1AlbFAMT48hsMF5e7wnXiCh15QrNsoJHv3gwidnktww4OB86MasLFGoFiK5atz
         on4FkOKw0by2vZHJm99w+4zFgcPFrt+und1afzoeel0xT5RxWa/rbDAW0HZUvtQadd/p
         lEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vK2ONWswjWuqMY4wp7Bc0epbP51m2rqXmIJq9jTsfts=;
        b=WgiqzhogpYOamRTKWJ6BTmhFithjXg5uY4KFlLrOxgwCe0jq6O9HWAHKs7QbCTUowx
         BXYyGGLGCga/Mcu53eIeU6ocF2AmfqK2TdFvlOUFuWHb/1KSwqN3M3ek5xH1dVKBbJ2Q
         3udCQT9K07n7QII2aYjrnC+xt6XEUdyu5eprO80a9EcC4b4iiwgugY4GfQXnOKSJxu+N
         9Gj5veSf0m/Mu1vHw/OH36DAfU1q2YJV3btxWh2Y+WvUnzvMXky/h+aq2yJY1Y344V94
         9bxoRrEEBC4/dimI860w2/ZtzCkrZ6ZxVgwJ2s/YKbPBsUI//n1306De25ijESeeMYBB
         KfkA==
X-Gm-Message-State: AOAM532pr2fO7ni5CkCQf2F75Q4oYwd+1HHfAcyKTqB6D8RHxWHDuzln
        8UM7OKm4dgt3+ebt/oGzdNQ=
X-Google-Smtp-Source: ABdhPJyJvq4N526jocypPGk9+xC0eivTJLXLZ+Ai95ji1lvKOOuE2fgTbJvWTpD7+Wu/RE9Xjqekhw==
X-Received: by 2002:ac8:425a:: with SMTP id r26mr27885386qtm.328.1617735301179;
        Tue, 06 Apr 2021 11:55:01 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id a19sm16581652qkl.126.2021.04.06.11.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 11:55:00 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 2/3] libbpf: selftests: refactor 'BPF_PERCPU_TYPE()' and 'bpf_percpu()' macros
Date:   Tue,  6 Apr 2021 15:53:53 -0300
Message-Id: <20210406185400.377293-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406185400.377293-1-pctammela@mojatatu.com>
References: <20210406185400.377293-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This macro was refactored out of the bpf selftests.

Since percpu values are rounded up to '8' in the kernel, a careless
user in userspace might encounter unexpected values when parsing the
output of the batched operations.

Now that both array and hash maps have support for batched ops in the
percpu variant, let's provide a convenient macro to declare percpu map
value types.

Updates the tests to a "reference" usage of the new macro.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tools/lib/bpf/bpf.h                           | 10 ++++
 tools/testing/selftests/bpf/bpf_util.h        |  7 ---
 .../bpf/map_tests/htab_map_batch_ops.c        | 48 ++++++++++---------
 .../selftests/bpf/prog_tests/map_init.c       |  5 +-
 tools/testing/selftests/bpf/test_maps.c       | 16 ++++---
 5 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 875dde20d56e..5feace6960e3 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -128,6 +128,16 @@ LIBBPF_API int bpf_map_delete_elem(int fd, const void *key);
 LIBBPF_API int bpf_map_get_next_key(int fd, const void *key, void *next_key);
 LIBBPF_API int bpf_map_freeze(int fd);
 
+#define __bpf_percpu_align __attribute__((__aligned__(8)))
+
+#define BPF_PERCPU_TYPE(type)		\
+	struct {			\
+		type v;			\
+		/* padding */		\
+	} __bpf_percpu_align
+
+#define bpf_percpu(name, cpu) ((name)[(cpu)].v)
+
 struct bpf_map_batch_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
 	__u64 elem_flags;
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
index 976bf415fbdd..3909e3980094 100644
--- a/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
@@ -10,27 +10,31 @@
 #include <bpf_util.h>
 #include <test_maps.h>
 
+typedef BPF_PERCPU_TYPE(int) pcpu_map_value_t;
+
 static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
 			     void *values, bool is_pcpu)
 {
-	typedef BPF_DECLARE_PERCPU(int, value);
-	value *v = NULL;
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	pcpu_map_value_t *v;
 	int i, j, err;
+	int offset = 0;
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
 		.elem_flags = 0,
 		.flags = 0,
 	);
 
 	if (is_pcpu)
-		v = (value *)values;
+		v = values;
 
 	for (i = 0; i < max_entries; i++) {
 		keys[i] = i + 1;
 		if (is_pcpu)
-			for (j = 0; j < bpf_num_possible_cpus(); j++)
-				bpf_percpu(v[i], j) = i + 2 + j;
+			for (j = 0; j < nr_cpus; j++)
+				bpf_percpu(v + offset, j) = i + 2 + j;
 		else
 			((int *)values)[i] = i + 2;
+		offset += nr_cpus;
 	}
 
 	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
@@ -40,22 +44,23 @@ static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
 static void map_batch_verify(int *visited, __u32 max_entries,
 			     int *keys, void *values, bool is_pcpu)
 {
-	typedef BPF_DECLARE_PERCPU(int, value);
-	value *v = NULL;
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	pcpu_map_value_t *v;
 	int i, j;
+	int offset = 0;
 
 	if (is_pcpu)
-		v = (value *)values;
+		v = values;
 
 	memset(visited, 0, max_entries * sizeof(*visited));
 	for (i = 0; i < max_entries; i++) {
-
 		if (is_pcpu) {
-			for (j = 0; j < bpf_num_possible_cpus(); j++) {
-				CHECK(keys[i] + 1 + j != bpf_percpu(v[i], j),
+			for (j = 0; j < nr_cpus; j++) {
+				int value = bpf_percpu(v + offset, j);
+				CHECK(keys[i] + 1 + j != value,
 				      "key/value checking",
-				      "error: i %d j %d key %d value %d\n",
-				      i, j, keys[i], bpf_percpu(v[i],  j));
+				      "error: i %d j %d key %d value %d\n", i,
+				      j, keys[i], value);
 			}
 		} else {
 			CHECK(keys[i] + 1 != ((int *)values)[i],
@@ -63,9 +68,8 @@ static void map_batch_verify(int *visited, __u32 max_entries,
 			      "error: i %d key %d value %d\n", i, keys[i],
 			      ((int *)values)[i]);
 		}
-
+		offset += nr_cpus;
 		visited[i] = 1;
-
 	}
 	for (i = 0; i < max_entries; i++) {
 		CHECK(visited[i] != 1, "visited checking",
@@ -75,11 +79,10 @@ static void map_batch_verify(int *visited, __u32 max_entries,
 
 void __test_map_lookup_and_delete_batch(bool is_pcpu)
 {
+	unsigned int nr_cpus = bpf_num_possible_cpus();
 	__u32 batch, count, total, total_success;
-	typedef BPF_DECLARE_PERCPU(int, value);
 	int map_fd, *keys, *visited, key;
 	const __u32 max_entries = 10;
-	value pcpu_values[max_entries];
 	int err, step, value_size;
 	bool nospace_err;
 	void *values;
@@ -100,12 +103,13 @@ void __test_map_lookup_and_delete_batch(bool is_pcpu)
 	CHECK(map_fd == -1,
 	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
 
-	value_size = is_pcpu ? sizeof(value) : sizeof(int);
-	keys = malloc(max_entries * sizeof(int));
 	if (is_pcpu)
-		values = pcpu_values;
+		value_size = sizeof(pcpu_map_value_t) * nr_cpus;
 	else
-		values = malloc(max_entries * sizeof(int));
+		value_size = sizeof(int);
+
+	keys = malloc(max_entries * sizeof(int));
+	values = calloc(max_entries, value_size);
 	visited = malloc(max_entries * sizeof(int));
 	CHECK(!keys || !values || !visited, "malloc()",
 	      "error:%s\n", strerror(errno));
@@ -203,7 +207,7 @@ void __test_map_lookup_and_delete_batch(bool is_pcpu)
 		CHECK(total != max_entries, "delete with steps",
 		      "total = %u, max_entries = %u\n", total, max_entries);
 
-		/* check map is empty, errono == ENOENT */
+		/* check map is empty, errno == ENOENT */
 		err = bpf_map_get_next_key(map_fd, NULL, &key);
 		CHECK(!err || errno != ENOENT, "bpf_map_get_next_key()",
 		      "error: %s\n", strerror(errno));
diff --git a/tools/testing/selftests/bpf/prog_tests/map_init.c b/tools/testing/selftests/bpf/prog_tests/map_init.c
index 14a31109dd0e..ec3d010319cc 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_init.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_init.c
@@ -12,10 +12,7 @@ static int duration;
 
 typedef unsigned long long map_key_t;
 typedef unsigned long long map_value_t;
-typedef struct {
-	map_value_t v; /* padding */
-} __bpf_percpu_val_align pcpu_map_value_t;
-
+typedef BPF_PERCPU_TYPE(map_value_t) pcpu_map_value_t;
 
 static int map_populate(int map_fd, int num)
 {
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 51adc42b2b40..6acbebef5f90 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -30,6 +30,8 @@
 #define ENOTSUPP 524
 #endif
 
+typedef BPF_PERCPU_TYPE(long) pcpu_map_value_t;
+
 static int skips;
 
 static int map_flags;
@@ -147,13 +149,13 @@ static void test_hashmap_sizes(unsigned int task, void *data)
 static void test_hashmap_percpu(unsigned int task, void *data)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
-	BPF_DECLARE_PERCPU(long, value);
+	pcpu_map_value_t value[nr_cpus];
 	long long key, next_key, first_key;
 	int expected_key_mask = 0;
 	int fd, i;
 
-	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_HASH, sizeof(key),
-			    sizeof(bpf_percpu(value, 0)), 2, map_flags);
+	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_HASH, sizeof(key), sizeof(long),
+			    2, map_flags);
 	if (fd < 0) {
 		printf("Failed to create hashmap '%s'!\n", strerror(errno));
 		exit(1);
@@ -400,11 +402,11 @@ static void test_arraymap(unsigned int task, void *data)
 static void test_arraymap_percpu(unsigned int task, void *data)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
-	BPF_DECLARE_PERCPU(long, values);
+	pcpu_map_value_t values[nr_cpus];
 	int key, next_key, fd, i;
 
 	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
-			    sizeof(bpf_percpu(values, 0)), 2, 0);
+			    sizeof(long), 2, 0);
 	if (fd < 0) {
 		printf("Failed to create arraymap '%s'!\n", strerror(errno));
 		exit(1);
@@ -459,7 +461,7 @@ static void test_arraymap_percpu(unsigned int task, void *data)
 static void test_arraymap_percpu_many_keys(void)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
-	BPF_DECLARE_PERCPU(long, values);
+	pcpu_map_value_t values[nr_cpus];
 	/* nr_keys is not too large otherwise the test stresses percpu
 	 * allocator more than anything else
 	 */
@@ -467,7 +469,7 @@ static void test_arraymap_percpu_many_keys(void)
 	int key, fd, i;
 
 	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
-			    sizeof(bpf_percpu(values, 0)), nr_keys, 0);
+			    sizeof(long), nr_keys, 0);
 	if (fd < 0) {
 		printf("Failed to create per-cpu arraymap '%s'!\n",
 		       strerror(errno));
-- 
2.25.1

