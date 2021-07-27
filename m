Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06933D8274
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 00:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhG0WXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 18:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbhG0WXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 18:23:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2755EC061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:23:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e145-20020a2550970000b029056eb288352cso458258ybb.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QVWq3SaQiaNdIT/nkNEqA1oFWtYX1AkXqRDkyOxzH88=;
        b=KZmw3I6Z1qwpiJTZR69Mv2/aj+kEU0XUqIiT8Nq0CEk1bsc1+b9vnzb/uOipacXkkl
         HrXLOp4rejmQ4ninM0EoN+Ua/yp53sJlJ9gzVV7Gm8rNSY/1zeRU5Z+Ei8VsUrEBJc5w
         8OzCYl6n6nOEgMbByey4NY+MQhUbJfRlkq38ZQfMk2ixHfppJezwjLEVx5PNQ7uoQ+tA
         pdyuaU528SKnfCsBUWI97icmRQT9yEUavQELRvHKtX9R3kXGCYvgAUbwbB0wuI/Y0el1
         Vcx31trd/tlqlzGTyBHXQEFmKz8klmLd9PVZcJ50Kx7ZZSC5VZXcB6/220AzUFj2Y+Pm
         tAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QVWq3SaQiaNdIT/nkNEqA1oFWtYX1AkXqRDkyOxzH88=;
        b=YnXkfRenH2os3oZn4dlPqx4korktB0kSzV3DqsBQjWaaC85wDqVYseHu4DNri/aWeU
         l3y4k+jBsjKCjtixZzbyWYE3DcWUUU7JdLxSXMxIjzod1ylrBCyUvc/NFN2kW3UL8jHi
         VPX1F7XUioQi6F9YVnzy4nJlJbOWWycAnQpr8YPWowbedzvPoFWjBfMABUHoMA5XTACO
         7dEofTvdkkA+lHk9SJU6tGH/g3ayEJ39c01HaBvkU6PrDa+sOD51naTk119yKPIA7PKh
         xtdyNm2iand3mQf06yM5MzcpR4epVwwX+xA8Xpktm0uy6ueP8c5VXq4BhCRvs9zxiCZc
         Hhww==
X-Gm-Message-State: AOAM5316EZAAF7oIi8COKJuzXmWFE4AwUUzfFAbNbc7PAzOL67c210Sk
        xtqYB5stBs6d31i5iUG7K6zkFf989dyRrgYPKqlkQc0T5QymC9rkkhZ/sdbNB+Iu0rR0nBd213N
        CnfLoN5OWT+bEhhhIoAJOBDOdiQvlG/ZhPkMCcJAnQhBVi+ZLlhqcHw==
X-Google-Smtp-Source: ABdhPJzBTrFPoi6zQkwKgn8ldaG9pa5Ki53DMUYeegQDsipYCjROGdjJIQBZp8nrD5nUxY9dkgfocGA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:d295:8a87:15f8:cb7])
 (user=sdf job=sendgmr) by 2002:a25:7d45:: with SMTP id y66mr18275812ybc.302.1627424617214;
 Tue, 27 Jul 2021 15:23:37 -0700 (PDT)
Date:   Tue, 27 Jul 2021 15:23:35 -0700
Message-Id: <20210727222335.4029096-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH bpf-next v4] bpf: increase supported cgroup storage value size
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's align
max cgroup value size with the other storages.

For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
allocator is not happy about larger values.

netcnt test is extended to exercise those maximum values
(non-percpu max size is close to, but not real max).

v4:
* remove inner union (Andrii Nakryiko)
* keep net_cnt on the stack (Andrii Nakryiko)

v3:
* refine SIZEOF_BPF_LOCAL_STORAGE_ELEM comment (Yonghong Song)
* anonymous struct in percpu_net_cnt & net_cnt (Yonghong Song)
* reorder free (Yonghong Song)

v2:
* cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/local_storage.c                    | 11 +++++-
 tools/testing/selftests/bpf/netcnt_common.h   | 38 ++++++++++++++-----
 .../testing/selftests/bpf/progs/netcnt_prog.c |  8 ++--
 tools/testing/selftests/bpf/test_netcnt.c     |  4 +-
 4 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 7ed2a14dc0de..035e9e3a7132 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -1,6 +1,7 @@
 //SPDX-License-Identifier: GPL-2.0
 #include <linux/bpf-cgroup.h>
 #include <linux/bpf.h>
+#include <linux/bpf_local_storage.h>
 #include <linux/btf.h>
 #include <linux/bug.h>
 #include <linux/filter.h>
@@ -283,9 +284,17 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
 
 static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 {
+	__u32 max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct bpf_cgroup_storage_map *map;
 
+	/* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
+	 * is the same as other local storages.
+	 */
+	if (attr->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
+		max_value_size = min_t(__u32, max_value_size,
+				       PCPU_MIN_UNIT_SIZE);
+
 	if (attr->key_size != sizeof(struct bpf_cgroup_storage_key) &&
 	    attr->key_size != sizeof(__u64))
 		return ERR_PTR(-EINVAL);
@@ -293,7 +302,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 	if (attr->value_size == 0)
 		return ERR_PTR(-EINVAL);
 
-	if (attr->value_size > PAGE_SIZE)
+	if (attr->value_size > max_value_size)
 		return ERR_PTR(-E2BIG);
 
 	if (attr->map_flags & ~LOCAL_STORAGE_CREATE_FLAG_MASK ||
diff --git a/tools/testing/selftests/bpf/netcnt_common.h b/tools/testing/selftests/bpf/netcnt_common.h
index 81084c1c2c23..0ab1c88041cd 100644
--- a/tools/testing/selftests/bpf/netcnt_common.h
+++ b/tools/testing/selftests/bpf/netcnt_common.h
@@ -6,19 +6,39 @@
 
 #define MAX_PERCPU_PACKETS 32
 
-struct percpu_net_cnt {
-	__u64 packets;
-	__u64 bytes;
+/* sizeof(struct bpf_local_storage_elem):
+ *
+ * It really is about 128 bytes on x86_64, but allocate more to account for
+ * possible layout changes, different architectures, etc.
+ * The kernel will wrap up to PAGE_SIZE internally anyway.
+ */
+#define SIZEOF_BPF_LOCAL_STORAGE_ELEM		256
 
-	__u64 prev_ts;
+/* Try to estimate kernel's BPF_LOCAL_STORAGE_MAX_VALUE_SIZE: */
+#define BPF_LOCAL_STORAGE_MAX_VALUE_SIZE	(0xFFFF - \
+						 SIZEOF_BPF_LOCAL_STORAGE_ELEM)
 
-	__u64 prev_packets;
-	__u64 prev_bytes;
+#define PCPU_MIN_UNIT_SIZE			32768
+
+union percpu_net_cnt {
+	struct {
+		__u64 packets;
+		__u64 bytes;
+
+		__u64 prev_ts;
+
+		__u64 prev_packets;
+		__u64 prev_bytes;
+	};
+	__u8 data[PCPU_MIN_UNIT_SIZE];
 };
 
-struct net_cnt {
-	__u64 packets;
-	__u64 bytes;
+union net_cnt {
+	struct {
+		__u64 packets;
+		__u64 bytes;
+	};
+	__u8 data[BPF_LOCAL_STORAGE_MAX_VALUE_SIZE];
 };
 
 #endif
diff --git a/tools/testing/selftests/bpf/progs/netcnt_prog.c b/tools/testing/selftests/bpf/progs/netcnt_prog.c
index d071adf178bd..43649bce4c54 100644
--- a/tools/testing/selftests/bpf/progs/netcnt_prog.c
+++ b/tools/testing/selftests/bpf/progs/netcnt_prog.c
@@ -13,21 +13,21 @@
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE);
 	__type(key, struct bpf_cgroup_storage_key);
-	__type(value, struct percpu_net_cnt);
+	__type(value, union percpu_net_cnt);
 } percpu_netcnt SEC(".maps");
 
 struct {
 	__uint(type, BPF_MAP_TYPE_CGROUP_STORAGE);
 	__type(key, struct bpf_cgroup_storage_key);
-	__type(value, struct net_cnt);
+	__type(value, union net_cnt);
 } netcnt SEC(".maps");
 
 SEC("cgroup/skb")
 int bpf_nextcnt(struct __sk_buff *skb)
 {
-	struct percpu_net_cnt *percpu_cnt;
+	union percpu_net_cnt *percpu_cnt;
 	char fmt[] = "%d %llu %llu\n";
-	struct net_cnt *cnt;
+	union net_cnt *cnt;
 	__u64 ts, dt;
 	int ret;
 
diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/selftests/bpf/test_netcnt.c
index a7b9a69f4fd5..4990a99e7381 100644
--- a/tools/testing/selftests/bpf/test_netcnt.c
+++ b/tools/testing/selftests/bpf/test_netcnt.c
@@ -33,14 +33,14 @@ static int bpf_find_map(const char *test, struct bpf_object *obj,
 
 int main(int argc, char **argv)
 {
-	struct percpu_net_cnt *percpu_netcnt;
+	union percpu_net_cnt *percpu_netcnt;
 	struct bpf_cgroup_storage_key key;
 	int map_fd, percpu_map_fd;
 	int error = EXIT_FAILURE;
-	struct net_cnt netcnt;
 	struct bpf_object *obj;
 	int prog_fd, cgroup_fd;
 	unsigned long packets;
+	union net_cnt netcnt;
 	unsigned long bytes;
 	int cpu, nproc;
 	__u32 prog_cnt;
-- 
2.32.0.554.ge1b32706d8-goog

