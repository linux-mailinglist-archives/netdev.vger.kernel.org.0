Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4594A585277
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbiG2PYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiG2PYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:24:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B69863C2;
        Fri, 29 Jul 2022 08:23:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso8716217pjr.2;
        Fri, 29 Jul 2022 08:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y6e0+BfhzTEhaMIObPp/tIKhd/5AtWlTaOTlEQZf2GY=;
        b=SJW46zqW4liJjC9RNghwcRe0UqCgDmtGwf0+wgFVhsSYnDwkrwQvucNeZDu6lBJst/
         SBdVYgeE1jdq62I4rQUd9bo1swjbyOvDVX/52WFozqx5IJPiN+iwGaUfIMxVbkIEsC8d
         fNgaNPPA5dVUY8bVep4mBvFq2UuSXnstMV+DNS1befoCuzaKYx3ikh9dqTaNRfePWsVR
         28AfNQyzFgbONkq/KwkafQ0TDjTyh6Uzao1VSo8jAk+AWQhyg/RyPkYjwYm+RS7yyqVp
         ukZk3zQ+oGwr6mebFVTAn0Y4hPEomr7WsfwllOyUPFRHs0NCeiSgwTbGLoUL9DwYhREI
         ti7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6e0+BfhzTEhaMIObPp/tIKhd/5AtWlTaOTlEQZf2GY=;
        b=i4WtPOdl8f6DdSUqd177evspgcHhh+9x44MWMxakvHM4IMo8RWiaJg5b5bbjKiMvlq
         KpTg+pnQucWe4Zi6VcN5mnvxqDe+bpn8dmkaWPoNB6LEMLDtjbs3hkLzBVdhR4ORrFZg
         y6OGwKcZ88EHKwo/XLKI3Q28jxIyYR8rCyKAr5JA8iSIQMG5f0J+8BREhqIAtNp1oqzu
         X+ZE4OiMLBsiNzCrEU6weGYy9cqEXXbBNAJaPhqQhytBjal3VcRwKuW4T+/CfQq0AvGo
         iLRshQ/IM9XIGwDrflWN/Xuil0Ia4MJ6nE4jPTAHa8/BCZYcaSl2l+7IicVd0AIIfD5p
         w25A==
X-Gm-Message-State: ACgBeo3VmMjwMv+uUg7r8vv7maJvHuV62o1IL71VpTPw082nF5s43HJA
        12Wi4TJFQCWqDYpEr4Eg030=
X-Google-Smtp-Source: AA6agR6T+aMpQScA3MSKZ91rVos74j/v0J7O4lrbrTzSPJ+SJjFr9+lQ5CwAO6uGkd9QeUEsZZ73KA==
X-Received: by 2002:a17:902:c40a:b0:16d:2dcb:9b8c with SMTP id k10-20020a170902c40a00b0016d2dcb9b8cmr4267480plk.61.1659108228525;
        Fri, 29 Jul 2022 08:23:48 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:47 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 13/15] bpf: Add new parameter into bpf_map_container_alloc
Date:   Fri, 29 Jul 2022 15:23:14 +0000
Message-Id: <20220729152316.58205-14-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729152316.58205-1-laoar.shao@gmail.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf attr into bpf_map_container_alloc(), then we can get map
creation related attributes in these function.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  6 +++---
 kernel/bpf/arraymap.c          | 15 ++++++++-------
 kernel/bpf/bloom_filter.c      |  7 ++++---
 kernel/bpf/bpf_local_storage.c |  6 +++---
 kernel/bpf/bpf_struct_ops.c    |  6 +++---
 kernel/bpf/cpumap.c            |  6 +++---
 kernel/bpf/devmap.c            |  6 +++---
 kernel/bpf/hashtab.c           |  6 +++---
 kernel/bpf/local_storage.c     |  6 +++---
 kernel/bpf/lpm_trie.c          |  6 +++---
 kernel/bpf/offload.c           |  6 +++---
 kernel/bpf/queue_stack_maps.c  |  6 +++---
 kernel/bpf/reuseport_array.c   |  7 ++++---
 kernel/bpf/ringbuf.c           |  6 +++---
 kernel/bpf/stackmap.c          |  6 +++---
 kernel/bpf/syscall.c           | 10 +++++-----
 net/core/sock_map.c            | 12 ++++++------
 net/xdp/xskmap.c               |  6 +++---
 18 files changed, 66 insertions(+), 63 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 605214fedd6d..2bd941279e6c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1634,9 +1634,9 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
 struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
-void *bpf_map_container_alloc(u64 size, int numa_node);
-void *bpf_map_container_mmapable_alloc(u64 size, int numa_node,
-				       u32 align, u32 offset);
+void *bpf_map_container_alloc(union bpf_attr *attr, u64 size, int numa_node);
+void *bpf_map_container_mmapable_alloc(union bpf_attr *attr, u64 size,
+				       int numa_node, u32 align, u32 offset);
 void *bpf_map_area_alloc(struct bpf_map *map, u64 size, int numa_node);
 void *bpf_map_pages_alloc(struct bpf_map *map, struct page **pages,
 			  int nr_meta_pages, int nr_data_pages, int nid,
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index bfcfc5df9983..883905c6c845 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -131,16 +131,17 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 		void *data;
 
 		/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
-		data = bpf_map_container_mmapable_alloc(array_size, numa_node,
-							align, offset);
-		if (!data)
-			return ERR_PTR(-ENOMEM);
+		data = bpf_map_container_mmapable_alloc(attr, array_size,
+							numa_node, align,
+							offset);
+		if (IS_ERR(data))
+			return data;
 		array = data + align - offset;
 	} else {
-		array = bpf_map_container_alloc(array_size, numa_node);
+		array = bpf_map_container_alloc(attr, array_size, numa_node);
 	}
-	if (!array)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(array))
+		return ERR_CAST(array);
 	array->index_mask = index_mask;
 	array->map.bypass_spec_v1 = bypass_spec_v1;
 
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index 8b3194903b52..9fe3c6774c40 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -142,10 +142,11 @@ static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 	}
 
 	bitset_bytes = roundup(bitset_bytes, sizeof(unsigned long));
-	bloom = bpf_map_container_alloc(sizeof(*bloom) + bitset_bytes, numa_node);
+	bloom = bpf_map_container_alloc(attr, sizeof(*bloom) + bitset_bytes,
+					numa_node);
 
-	if (!bloom)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(bloom))
+		return ERR_CAST(bloom);
 
 	bpf_map_init_from_attr(&bloom->map, attr);
 
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 3440135c3612..e12891dcf2a9 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -610,9 +610,9 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	unsigned int i;
 	u32 nbuckets;
 
-	smap = bpf_map_container_alloc(sizeof(*smap), NUMA_NO_NODE);
-	if (!smap)
-		return ERR_PTR(-ENOMEM);
+	smap = bpf_map_container_alloc(attr, sizeof(*smap), NUMA_NO_NODE);
+	if (IS_ERR(smap))
+		return ERR_CAST(smap);
 	bpf_map_init_from_attr(&smap->map, attr);
 
 	nbuckets = roundup_pow_of_two(num_possible_cpus());
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 874fda7e2b8b..51b7ce9902a8 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -618,9 +618,9 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 		 */
 		(vt->size - sizeof(struct bpf_struct_ops_value));
 
-	st_map = bpf_map_container_alloc(st_map_size, NUMA_NO_NODE);
-	if (!st_map)
-		return ERR_PTR(-ENOMEM);
+	st_map = bpf_map_container_alloc(attr, st_map_size, NUMA_NO_NODE);
+	if (IS_ERR(st_map))
+		return ERR_CAST(st_map);
 
 	st_map->st_ops = st_ops;
 	map = &st_map->map;
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 95c1642deaf6..1e915a3bd1a2 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -97,9 +97,9 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
-	cmap = bpf_map_container_alloc(sizeof(*cmap), NUMA_NO_NODE);
-	if (!cmap)
-		return ERR_PTR(-ENOMEM);
+	cmap = bpf_map_container_alloc(attr, sizeof(*cmap), NUMA_NO_NODE);
+	if (IS_ERR(cmap))
+		return ERR_CAST(cmap);
 
 	bpf_map_init_from_attr(&cmap->map, attr);
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index b625d578bc93..11c7b8411b03 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -167,9 +167,9 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	dtab = bpf_map_container_alloc(sizeof(*dtab), NUMA_NO_NODE);
-	if (!dtab)
-		return ERR_PTR(-ENOMEM);
+	dtab = bpf_map_container_alloc(attr, sizeof(*dtab), NUMA_NO_NODE);
+	if (IS_ERR(dtab))
+		return ERR_CAST(dtab);
 
 	err = dev_map_init_map(dtab, attr);
 	if (err) {
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 2a34a115e14f..3cb9486eb313 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -496,9 +496,9 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	struct bpf_htab *htab;
 	int err, i;
 
-	htab = bpf_map_container_alloc(sizeof(*htab), NUMA_NO_NODE);
-	if (!htab)
-		return ERR_PTR(-ENOMEM);
+	htab = bpf_map_container_alloc(attr, sizeof(*htab), NUMA_NO_NODE);
+	if (IS_ERR(htab))
+		return ERR_CAST(htab);
 
 	lockdep_register_key(&htab->lockdep_key);
 
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 963dc82e3c50..b2bd031aba79 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -313,9 +313,9 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
 
-	map = bpf_map_container_alloc(sizeof(struct bpf_cgroup_storage_map), numa_node);
-	if (!map)
-		return ERR_PTR(-ENOMEM);
+	map = bpf_map_container_alloc(attr, sizeof(*map), numa_node);
+	if (IS_ERR(map))
+		return ERR_CAST(map);
 
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&map->map, attr);
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 15ccef2f10a3..e55327ad9c3a 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -558,9 +558,9 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	    attr->value_size > LPM_VAL_SIZE_MAX)
 		return ERR_PTR(-EINVAL);
 
-	trie = bpf_map_container_alloc(sizeof(*trie), NUMA_NO_NODE);
-	if (!trie)
-		return ERR_PTR(-ENOMEM);
+	trie = bpf_map_container_alloc(attr, sizeof(*trie), NUMA_NO_NODE);
+	if (IS_ERR(trie))
+		return ERR_CAST(trie);
 
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&trie->map, attr);
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 02e3f4ef19f5..34fb5261ff95 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -372,9 +372,9 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	    attr->map_type != BPF_MAP_TYPE_HASH)
 		return ERR_PTR(-EINVAL);
 
-	offmap = bpf_map_container_alloc(sizeof(*offmap), NUMA_NO_NODE);
-	if (!offmap)
-		return ERR_PTR(-ENOMEM);
+	offmap = bpf_map_container_alloc(attr, sizeof(*offmap), NUMA_NO_NODE);
+	if (IS_ERR(offmap))
+		return ERR_CAST(offmap);
 
 	bpf_map_init_from_attr(&offmap->map, attr);
 
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index d4c0284c9089..9425df0695ac 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -74,9 +74,9 @@ static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 	size = (u64) attr->max_entries + 1;
 	queue_size = sizeof(*qs) + size * attr->value_size;
 
-	qs = bpf_map_container_alloc(queue_size, numa_node);
-	if (!qs)
-		return ERR_PTR(-ENOMEM);
+	qs = bpf_map_container_alloc(attr, queue_size, numa_node);
+	if (IS_ERR(qs))
+		return ERR_CAST(qs);
 
 	bpf_map_init_from_attr(&qs->map, attr);
 
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index d36a60ca68f4..0d3091866e1d 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -153,14 +153,15 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 {
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct reuseport_array *array;
+	size_t size = struct_size(array, ptrs, attr->max_entries);
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	/* allocate all map elements and zero-initialize them */
-	array = bpf_map_container_alloc(struct_size(array, ptrs, attr->max_entries), numa_node);
-	if (!array)
-		return ERR_PTR(-ENOMEM);
+	array = bpf_map_container_alloc(attr, size, numa_node);
+	if (IS_ERR(array))
+		return ERR_CAST(array);
 
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&array->map, attr);
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 25973cab251d..3be472fd55da 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -159,9 +159,9 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
 
-	rb_map = bpf_map_container_alloc(sizeof(*rb_map), NUMA_NO_NODE);
-	if (!rb_map)
-		return ERR_PTR(-ENOMEM);
+	rb_map = bpf_map_container_alloc(attr, sizeof(*rb_map), NUMA_NO_NODE);
+	if (IS_ERR(rb_map))
+		return ERR_CAST(rb_map);
 
 	bpf_map_init_from_attr(&rb_map->map, attr);
 
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index c9a91ca05a03..c952c7547279 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -101,9 +101,9 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	smap = bpf_map_container_alloc(cost, bpf_map_attr_numa_node(attr));
-	if (!smap)
-		return ERR_PTR(-ENOMEM);
+	smap = bpf_map_container_alloc(attr, cost, bpf_map_attr_numa_node(attr));
+	if (IS_ERR(smap))
+		return ERR_CAST(smap);
 
 	bpf_map_init_from_attr(&smap->map, attr);
 	smap->n_buckets = n_buckets;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f7210fa8c3be..6401cc417fa9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -526,14 +526,14 @@ void bpf_map_area_free(void *area)
  *
  * It is used in map creation path.
  */
-void *bpf_map_container_alloc(u64 size, int numa_node)
+void *bpf_map_container_alloc(union bpf_attr *attr, u64 size, int numa_node)
 {
 	struct bpf_map *map;
 	void *container;
 
 	container = __bpf_map_area_alloc(size, numa_node, false);
 	if (!container)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	map = (struct bpf_map *)container;
 	bpf_map_save_memcg(map);
@@ -541,8 +541,8 @@ void *bpf_map_container_alloc(u64 size, int numa_node)
 	return container;
 }
 
-void *bpf_map_container_mmapable_alloc(u64 size, int numa_node, u32 align,
-				       u32 offset)
+void *bpf_map_container_mmapable_alloc(union bpf_attr *attr, u64 size,
+				       int numa_node, u32 align, u32 offset)
 {
 	struct bpf_map *map;
 	void *container;
@@ -551,7 +551,7 @@ void *bpf_map_container_mmapable_alloc(u64 size, int numa_node, u32 align,
 	/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
 	ptr = __bpf_map_area_alloc(size, numa_node, true);
 	if (!ptr)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	container = ptr + align - offset;
 	map = (struct bpf_map *)container;
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1f49dc89822c..4d9b730aa27f 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -41,9 +41,9 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	stab = bpf_map_container_alloc(sizeof(*stab), NUMA_NO_NODE);
-	if (!stab)
-		return ERR_PTR(-ENOMEM);
+	stab = bpf_map_container_alloc(attr, sizeof(*stab), NUMA_NO_NODE);
+	if (IS_ERR(stab))
+		return ERR_CAST(stab);
 
 	bpf_map_init_from_attr(&stab->map, attr);
 	raw_spin_lock_init(&stab->lock);
@@ -1077,9 +1077,9 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 	if (attr->key_size > MAX_BPF_STACK)
 		return ERR_PTR(-E2BIG);
 
-	htab = bpf_map_container_alloc(sizeof(*htab), NUMA_NO_NODE);
-	if (!htab)
-		return ERR_PTR(-ENOMEM);
+	htab = bpf_map_container_alloc(attr, sizeof(*htab), NUMA_NO_NODE);
+	if (IS_ERR(htab))
+		return ERR_CAST(htab);
 
 	bpf_map_init_from_attr(&htab->map, attr);
 
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 6cf98f1c621a..161fc569ed88 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -75,9 +75,9 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	numa_node = bpf_map_attr_numa_node(attr);
 	size = struct_size(m, xsk_map, attr->max_entries);
 
-	m = bpf_map_container_alloc(size, numa_node);
-	if (!m)
-		return ERR_PTR(-ENOMEM);
+	m = bpf_map_container_alloc(attr, size, numa_node);
+	if (IS_ERR(m))
+		return ERR_CAST(m);
 
 	bpf_map_init_from_attr(&m->map, attr);
 	spin_lock_init(&m->lock);
-- 
2.17.1

