Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0EE3D437E
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 01:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhGWXOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 19:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbhGWXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 19:13:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9925DC061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:54:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v71-20020a252f4a0000b029055b51419c7dso3978534ybv.23
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PhK53SQqrV3rzr+/LoYcL+zgwtAHvCE1OThI8j/AWKc=;
        b=gBbyy4Y9lFGc+9Oiq77s19pEiVl4TAMkZI/MASTkDLaeBw50ae8+UO+8xnrL5ETheM
         GOlVLe9lrT5p+31oqM9yt59MHkb4eWRICABWyM15LqWDz51NB97Q31JBQcYM+QhL5K07
         9bn3SN//erWDasbiNeKCuMHT0R/frR62tyy6G5ZSuZB53YE63b9po4raE+MoQ4yqrSTG
         oQFoqEaZMWQavMwW8Fp/qXCePtO1/2/6yiL8RO8Ma22Nx2NWl0nRO5h2M0wuiN6909m/
         opwa08t4XLkNPiOhNatrndQ/gKFfPHnhsi44bpyNfpZFC94MwM/Usuj76Lw09HoP+9mf
         /g6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PhK53SQqrV3rzr+/LoYcL+zgwtAHvCE1OThI8j/AWKc=;
        b=boUoHPae1rWfGVtKdgxtd2bfDcyDO6/n/kBjPi7DO5onrFInNORD/VGgx+KIQ8jLxG
         257foBvVn2EvrOA4qYm1knC/VgISJidtjwQblNUNxE8ntbEigDJo55xAG3CN0c5QKO4l
         cgyQYXjtYjHI04cWFZtHv71WIUc/N0/v7p6v4atgIjNWY6aXCtOOU+EnQfPBCif5W0kX
         q0h4n2FXTYXHQ6ql7DGnONXTqS3c/kKmyKGvXFZE84cJqyOpUobzD7rndK5SCLW8P2w/
         +TJjB25NHHeiI1ZurkCMRBztIiAtTMououvgKM14pE2Cui5v5wFn5ssLL7dL2sCeMsNq
         TFWg==
X-Gm-Message-State: AOAM530RKdv8qNn+SbfXVats8FkGWsMqgGzHWs3+kaZp4tnrDdhUCWpA
        LfInPzup2ievBdT/yxP8GTKvJtca4X6loy6pcE22eC97Ft8bbJa4wzHTS/yZGVmJuD+V6xoeuTU
        kHtdNOeQfJF3/88L4K5lOlQV63aGRBvCQvL9IowxT5r6d7lEQIrIG8w==
X-Google-Smtp-Source: ABdhPJyFVGfqWOyw60F4IHcN3zTbGwhzUk9KDQIEIy4Hkgm1wVtScJdVdVvM4OsbIqYo9TtORqsxW5E=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:627f:b1f:13ac:723b])
 (user=sdf job=sendgmr) by 2002:a25:df87:: with SMTP id w129mr5599580ybg.172.1627084471796;
 Fri, 23 Jul 2021 16:54:31 -0700 (PDT)
Date:   Fri, 23 Jul 2021 16:54:29 -0700
Message-Id: <20210723235429.339744-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH bpf-next v2] bpf: increase supported cgroup storage value size
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
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

v2:
* cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)

Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/local_storage.c                    | 11 +++++-
 tools/testing/selftests/bpf/netcnt_common.h   | 38 +++++++++++++++----
 .../testing/selftests/bpf/progs/netcnt_prog.c | 29 +++++++-------
 tools/testing/selftests/bpf/test_netcnt.c     | 25 +++++++-----
 4 files changed, 72 insertions(+), 31 deletions(-)

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

