Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8A63D30E4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhGVXrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 19:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhGVXrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 19:47:16 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00A8C061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 17:27:50 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id t18-20020a0cd4120000b02902fbda5d4988so705783qvh.11
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 17:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KaaKO6JSuYlU48c7gu61DViYcF3DfebwjsMEkD6F6Do=;
        b=k7Yq2lZyuqV5/XONJUNkIw7Lh4tA19200eZsXHrqLyn1+ZW2DO77ZcweTrfUrVyC61
         wCuqg9KXPNnp43tvuhXZZeozNiaF8tB+6omRfVtOPaK3jtjP56S+1uNjjiRV1DiTQjUi
         EuWWKZyw3vnmTc8qzI1myXA++aYhyq+LSRqppB4qLbSFb+H+0tcum8XvkQo7lf4qdh/D
         0b/lsaLhqhQH0/SgCs18sTyiMv5asP6qc1/nNIYSCQ3GtjOt77pAw92/lT5z01Tmhbbv
         A/28yEBjcNX2Zf76Kh4uGlAviaeM0lu3JBqyF5z88J5+hDl4rxm3dUjr/r7qIV8Fo7ia
         UY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KaaKO6JSuYlU48c7gu61DViYcF3DfebwjsMEkD6F6Do=;
        b=BPnUswcCUbIq9Dqz0RvNcZXf+cRomHoQVt+QWrhZ11uFqa0OmuSp6EbqJwdGxf8kI5
         wYaZTKCS5svCEeXE8StPmMHdPpbWAL+c2/T8rpa1bm4phqazegP0yygQFfFMfMy5DH56
         uFzrQ5lrYKPO7xl0QCf2nYCV6f8dF50cWc+3qpcm26jtHII2KX8naPPddj6xv9NizJsJ
         srrZKgn7Qo2+2hT0AhE52XIUvTr88MKHRUsybZETHCrJGH5cY1TQ7VxF6DPulQgGiO4W
         b249j2oEkZOuE2PmYi5sHuIDKRYLabekWTmXy2JTStJXiwC6imhZL/FHd+ZeT3Q2alC9
         4LYg==
X-Gm-Message-State: AOAM530LnB4H4GycHm186dxfF88sCsBCS6tNggwKHYRsWOyj/MNW//tI
        7E2lgHkUQKvi0sUwmUuRZll3wkidKfQDbz7CIqxCZ0J19tvOZ/4BU5kd3e8SvZLeNbm1vS0MDXv
        61WEyBRVG6yImRd6UzbTtkpAvhVnqYCx4F8d9eToFhaj7qNDHIrT/UQ==
X-Google-Smtp-Source: ABdhPJzVY2paVqN56+UYMkJ6kbNfAcD978jAXGSvhBUZzdBpGCo+lzgcLXTWmGXytQxwowAhU/74byc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:2a74:6a64:2627:e4ab])
 (user=sdf job=sendgmr) by 2002:a05:6214:1021:: with SMTP id
 k1mr2640636qvr.4.1627000069825; Thu, 22 Jul 2021 17:27:49 -0700 (PDT)
Date:   Thu, 22 Jul 2021 17:27:47 -0700
Message-Id: <20210723002747.3668098-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH bpf-next] bpf: increase supported cgroup storage value size
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/local_storage.c                    | 12 +++++-
 tools/testing/selftests/bpf/netcnt_common.h   | 38 +++++++++++++++----
 .../testing/selftests/bpf/progs/netcnt_prog.c | 29 +++++++-------
 tools/testing/selftests/bpf/test_netcnt.c     | 25 +++++++-----
 4 files changed, 73 insertions(+), 31 deletions(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 7ed2a14dc0de..a276da74c20a 100644
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
@@ -284,8 +285,17 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
 static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 {
 	int numa_node = bpf_map_attr_numa_node(attr);
+	__u32 max_value_size = PCPU_MIN_UNIT_SIZE;
 	struct bpf_cgroup_storage_map *map;
 
+	/* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
+	 * is the same as other local storages.
+	 */
+	if (attr->map_type == BPF_MAP_TYPE_CGROUP_STORAGE)
+		max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
+
+	BUILD_BUG_ON(PCPU_MIN_UNIT_SIZE > BPF_LOCAL_STORAGE_MAX_VALUE_SIZE);
+
 	if (attr->key_size != sizeof(struct bpf_cgroup_storage_key) &&
 	    attr->key_size != sizeof(__u64))
 		return ERR_PTR(-EINVAL);
@@ -293,7 +303,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 	if (attr->value_size == 0)
 		return ERR_PTR(-EINVAL);
 
-	if (attr->value_size > PAGE_SIZE)
+	if (attr->value_size > max_value_size)
 		return ERR_PTR(-E2BIG);
 
 	if (attr->map_flags & ~LOCAL_STORAGE_CREATE_FLAG_MASK ||
diff --git a/tools/testing/selftests/bpf/netcnt_common.h b/tools/testing/selftests/bpf/netcnt_common.h
index 81084c1c2c23..dfcf184ff713 100644
--- a/tools/testing/selftests/bpf/netcnt_common.h
+++ b/tools/testing/selftests/bpf/netcnt_common.h
@@ -6,19 +6,43 @@
 
 #define MAX_PERCPU_PACKETS 32
 
+/* sizeof(struct bpf_local_storage_elem):
+ *
+ * It really is about 128 bytes, but allocate more to account for possible
+ * layout changes, different architectures, etc.
+ * It will wrap up to PAGE_SIZE internally anyway.
+ */
+#define SIZEOF_BPF_LOCAL_STORAGE_ELEM		256
+
+/* Try to estimate kernel's BPF_LOCAL_STORAGE_MAX_VALUE_SIZE: */
+#define BPF_LOCAL_STORAGE_MAX_VALUE_SIZE	(0xFFFF - \
+						 SIZEOF_BPF_LOCAL_STORAGE_ELEM)
+
+#define PCPU_MIN_UNIT_SIZE			32768
+
 struct percpu_net_cnt {
-	__u64 packets;
-	__u64 bytes;
+	union {
+		struct {
+			__u64 packets;
+			__u64 bytes;
 
-	__u64 prev_ts;
+			__u64 prev_ts;
 
-	__u64 prev_packets;
-	__u64 prev_bytes;
+			__u64 prev_packets;
+			__u64 prev_bytes;
+		} val;
+		__u8 data[PCPU_MIN_UNIT_SIZE];
+	};
 };
 
 struct net_cnt {
-	__u64 packets;
-	__u64 bytes;
+	union {
+		struct {
+			__u64 packets;
+			__u64 bytes;
+		} val;
+		__u8 data[BPF_LOCAL_STORAGE_MAX_VALUE_SIZE];
+	};
 };
 
 #endif
diff --git a/tools/testing/selftests/bpf/progs/netcnt_prog.c b/tools/testing/selftests/bpf/progs/netcnt_prog.c
index d071adf178bd..4b0884239892 100644
--- a/tools/testing/selftests/bpf/progs/netcnt_prog.c
+++ b/tools/testing/selftests/bpf/progs/netcnt_prog.c
@@ -34,34 +34,35 @@ int bpf_nextcnt(struct __sk_buff *skb)
 	cnt = bpf_get_local_storage(&netcnt, 0);
 	percpu_cnt = bpf_get_local_storage(&percpu_netcnt, 0);
 
-	percpu_cnt->packets++;
-	percpu_cnt->bytes += skb->len;
+	percpu_cnt->val.packets++;
+	percpu_cnt->val.bytes += skb->len;
 
-	if (percpu_cnt->packets > MAX_PERCPU_PACKETS) {
-		__sync_fetch_and_add(&cnt->packets,
-				     percpu_cnt->packets);
-		percpu_cnt->packets = 0;
+	if (percpu_cnt->val.packets > MAX_PERCPU_PACKETS) {
+		__sync_fetch_and_add(&cnt->val.packets,
+				     percpu_cnt->val.packets);
+		percpu_cnt->val.packets = 0;
 
-		__sync_fetch_and_add(&cnt->bytes,
-				     percpu_cnt->bytes);
-		percpu_cnt->bytes = 0;
+		__sync_fetch_and_add(&cnt->val.bytes,
+				     percpu_cnt->val.bytes);
+		percpu_cnt->val.bytes = 0;
 	}
 
 	ts = bpf_ktime_get_ns();
-	dt = ts - percpu_cnt->prev_ts;
+	dt = ts - percpu_cnt->val.prev_ts;
 
 	dt *= MAX_BPS;
 	dt /= NS_PER_SEC;
 
-	if (cnt->bytes + percpu_cnt->bytes - percpu_cnt->prev_bytes < dt)
+	if (cnt->val.bytes + percpu_cnt->val.bytes -
+	    percpu_cnt->val.prev_bytes < dt)
 		ret = 1;
 	else
 		ret = 0;
 
 	if (dt > REFRESH_TIME_NS) {
-		percpu_cnt->prev_ts = ts;
-		percpu_cnt->prev_packets = cnt->packets;
-		percpu_cnt->prev_bytes = cnt->bytes;
+		percpu_cnt->val.prev_ts = ts;
+		percpu_cnt->val.prev_packets = cnt->val.packets;
+		percpu_cnt->val.prev_bytes = cnt->val.bytes;
 	}
 
 	return !!ret;
diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/selftests/bpf/test_netcnt.c
index a7b9a69f4fd5..1138765406a5 100644
--- a/tools/testing/selftests/bpf/test_netcnt.c
+++ b/tools/testing/selftests/bpf/test_netcnt.c
@@ -33,11 +33,11 @@ static int bpf_find_map(const char *test, struct bpf_object *obj,
 
 int main(int argc, char **argv)
 {
-	struct percpu_net_cnt *percpu_netcnt;
+	struct percpu_net_cnt *percpu_netcnt = NULL;
 	struct bpf_cgroup_storage_key key;
+	struct net_cnt *netcnt = NULL;
 	int map_fd, percpu_map_fd;
 	int error = EXIT_FAILURE;
-	struct net_cnt netcnt;
 	struct bpf_object *obj;
 	int prog_fd, cgroup_fd;
 	unsigned long packets;
@@ -52,6 +52,12 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
+	netcnt = malloc(sizeof(*netcnt));
+	if (!netcnt) {
+		printf("Not enough memory for non-per-cpu area\n");
+		goto err;
+	}
+
 	if (bpf_prog_load(BPF_PROG, BPF_PROG_TYPE_CGROUP_SKB,
 			  &obj, &prog_fd)) {
 		printf("Failed to load bpf program\n");
@@ -96,7 +102,7 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
-	if (bpf_map_lookup_elem(map_fd, &key, &netcnt)) {
+	if (bpf_map_lookup_elem(map_fd, &key, netcnt)) {
 		printf("Failed to lookup cgroup storage\n");
 		goto err;
 	}
@@ -109,17 +115,17 @@ int main(int argc, char **argv)
 	/* Some packets can be still in per-cpu cache, but not more than
 	 * MAX_PERCPU_PACKETS.
 	 */
-	packets = netcnt.packets;
-	bytes = netcnt.bytes;
+	packets = netcnt->val.packets;
+	bytes = netcnt->val.bytes;
 	for (cpu = 0; cpu < nproc; cpu++) {
-		if (percpu_netcnt[cpu].packets > MAX_PERCPU_PACKETS) {
+		if (percpu_netcnt[cpu].val.packets > MAX_PERCPU_PACKETS) {
 			printf("Unexpected percpu value: %llu\n",
-			       percpu_netcnt[cpu].packets);
+			       percpu_netcnt[cpu].val.packets);
 			goto err;
 		}
 
-		packets += percpu_netcnt[cpu].packets;
-		bytes += percpu_netcnt[cpu].bytes;
+		packets += percpu_netcnt[cpu].val.packets;
+		bytes += percpu_netcnt[cpu].val.bytes;
 	}
 
 	/* No packets should be lost */
@@ -142,6 +148,7 @@ int main(int argc, char **argv)
 err:
 	cleanup_cgroup_environment();
 	free(percpu_netcnt);
+	free(netcnt);
 
 out:
 	return error;
-- 
2.32.0.432.gabb21c7263-goog

