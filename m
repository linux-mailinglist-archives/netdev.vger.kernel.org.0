Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211423D69E1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 01:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhGZWUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhGZWUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 18:20:07 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88644C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 16:00:35 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id l12-20020a05622a050cb029025ca4fbcc12so5277900qtx.18
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 16:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=L3pAwjcMFRXcdVjthQnCyjLTd9WgOFBY4UOr2GPYdXI=;
        b=COCQ31j2em3/72CarDjzVM0z/ySdB3mKa67wH/7O1kiASvyNmAilChmWOPEZ5NAJVq
         DHLhi0yx5zxGQbTCk8Wx+APXNkqPKJiIyRVeIupSd/tRGxWUEs7M6Ru9NiqWiGVt/qEC
         p2qH9f93tAF8927WxV+tpp7xgKPP6OAeNIr5WW6Wea118A9SpK6l9CPJpbnI5+kelUnU
         VZs7xtVOAIlMbX2P/f9+Q7RAZOiMLBvm0s70Gkedj9QddmDv9tsA/rUUrBm7A4Rzl5Su
         PveUCz8FRnIUKnMgcnfdzhcidm5/hZU1lF8LcYiTQMo10gIUcayTjf7AXz3bQRYLn0+R
         Ohpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=L3pAwjcMFRXcdVjthQnCyjLTd9WgOFBY4UOr2GPYdXI=;
        b=VquCgUWE2Y11vFTFF2OG1IhbwHRwVv91EMbpphdhesbA16A7I2tXyfHV7tK4mvFPFZ
         nKRGu5+jAK2vLACvK6YkMuKysAxutihyHtg0tO2GKxfp13aH28iJ5Pr9ef1bBc+FpVd+
         dRLdXS+8m0GR6QdYTC80GKutRFDM+RGVPZ9be6wIQKGQnEH5Y3a2DIq0inbUIy//4jTx
         LetKmUsqSsENOM0mrZvz/2B/md4P73iUjVHWEfR+6asb4y5Q6PBHRtsVr+nW2+w4zmf7
         u/w0u5h3IjZTlGa4RUqaQ9RTwd+d/3TN2ztbjX/kBac3QjoIQvwP1X1LSqbVEN4o08+y
         KNog==
X-Gm-Message-State: AOAM532PhGex5xnGVb+N9QhQj04yYBFzgfzgb5TZc6pA+CVfoBUT7SiL
        ykjb9IAJZy1zSuO8+vXiJtofgvWo5l1jyN7hIMRKySsDsENZTxLD5474kmH2eY4E+UHCzzEcvep
        umiB5By5np3klwWTug4cAG/oiuLO9X3vdj7N4KseJFZXLXg3SDwNDVw==
X-Google-Smtp-Source: ABdhPJwe07s3Rm/zq3d32a4dwQsKUK8rZc5y54tmrFJ8X6Kyg7Yir6+saHjV4t8vA1hqFdfauXpc+Bg=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a5d:54af:459d:a9f5])
 (user=sdf job=sendgmr) by 2002:a05:6214:e4c:: with SMTP id
 o12mr20293801qvc.18.1627340434547; Mon, 26 Jul 2021 16:00:34 -0700 (PDT)
Date:   Mon, 26 Jul 2021 16:00:32 -0700
Message-Id: <20210726230032.1806348-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH bpf-next v3] bpf: increase supported cgroup storage value size
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

v3:
* refine SIZEOF_BPF_LOCAL_STORAGE_ELEM comment (Yonghong Song)
* anonymous struct in percpu_net_cnt & net_cnt (Yonghong Song)
* reorder free (Yonghong Song)

v2:
* cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/local_storage.c                  | 11 +++++-
 tools/testing/selftests/bpf/netcnt_common.h | 38 +++++++++++++++++----
 tools/testing/selftests/bpf/test_netcnt.c   | 17 ++++++---
 3 files changed, 53 insertions(+), 13 deletions(-)

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
index 81084c1c2c23..87f5b97e1932 100644
--- a/tools/testing/selftests/bpf/netcnt_common.h
+++ b/tools/testing/selftests/bpf/netcnt_common.h
@@ -6,19 +6,43 @@
 
 #define MAX_PERCPU_PACKETS 32
 
+/* sizeof(struct bpf_local_storage_elem):
+ *
+ * It really is about 128 bytes on x86_64, but allocate more to account for
+ * possible layout changes, different architectures, etc.
+ * The kernel will wrap up to PAGE_SIZE internally anyway.
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
+		};
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
+		};
+		__u8 data[BPF_LOCAL_STORAGE_MAX_VALUE_SIZE];
+	};
 };
 
 #endif
diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/selftests/bpf/test_netcnt.c
index a7b9a69f4fd5..372afccf2d17 100644
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
@@ -109,8 +115,8 @@ int main(int argc, char **argv)
 	/* Some packets can be still in per-cpu cache, but not more than
 	 * MAX_PERCPU_PACKETS.
 	 */
-	packets = netcnt.packets;
-	bytes = netcnt.bytes;
+	packets = netcnt->packets;
+	bytes = netcnt->bytes;
 	for (cpu = 0; cpu < nproc; cpu++) {
 		if (percpu_netcnt[cpu].packets > MAX_PERCPU_PACKETS) {
 			printf("Unexpected percpu value: %llu\n",
@@ -141,6 +147,7 @@ int main(int argc, char **argv)
 
 err:
 	cleanup_cgroup_environment();
+	free(netcnt);
 	free(percpu_netcnt);
 
 out:
-- 
2.32.0.432.gabb21c7263-goog

