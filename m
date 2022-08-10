Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C866158EF34
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiHJPT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiHJPTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:19:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BC978BFC;
        Wed, 10 Aug 2022 08:19:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x23so14523326pll.7;
        Wed, 10 Aug 2022 08:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=LSKn9EI6EEnZFa2cfczgY3SUVwQTryiMyelz91Pffy4=;
        b=PN2pGwpdHxlb6yB5Yp5TxvpbSVZBz+GlgHanyE0vM5zFB4vn5e+6ac+M8a+98ai6m1
         ZNGLHKA0/LgIx0zBqxxguzGa7AbOBdkXzRx6w4rokOio316MobYA5RlDRt08BXar8vG1
         zTV3wru95o/9NOREx99SHCX9+QPmtT1SiLzgxFgM6lsekcLi7GGPGnHZm2eDQM6BnQtQ
         bJfssLS56sSqQnYEwAkDZ+V3QlCaxMo4s5NK+/vA/qrTJJ5Nf6KITtoFs8zYFWH8KYXR
         5jy5oXGdGlSXy9fyhFL+b2x1ato+URFcybDeip3pLv5s6UPbC8AfNiQIotVqZoUKdDgu
         Iidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=LSKn9EI6EEnZFa2cfczgY3SUVwQTryiMyelz91Pffy4=;
        b=KIt4dK9b2PJWNFPtwUoS+8XCvvhlgNCfK4Re8hI7WCcVghy6ulxZIKM0NrJb2neJjo
         x8wChbm5SJZjvMilc+nlr9zo6FIDNuTDr4UrZOjuJQ8uiw5iyBZcbYZjajSnEdNraqLc
         XSeB0JA3FEbPpezCKQimGyBvrL/37sQfFoANLN6dQyWnjulFY+Uz/TY618JoduoVsiAq
         fT/a0lSl6zyTtom5aE1uS7Kxl7xqKhtVzl7V9uj5h1xTBZLkOuFTNyJsaVoAJ5nIwJG9
         uBpsJIOyYlZoFIvKLyZjWcqsvbKFUq+PyEbNCZlY9RkrkRGRcn79vJJw2eLjeCLJ5aC6
         GxJQ==
X-Gm-Message-State: ACgBeo3N/YvHlBATDZTsctAU0VPtcZ3ennRvn45Q8LpWJ9fO4lB1XlNA
        AsYLWL2RLEm/mXt8of5TzhM=
X-Google-Smtp-Source: AA6agR5gel1asRtrz0hDm33HYMmdHPEeeNLkKS/zcYxXY+zSnn3ot6p8qUQVUW8uOclZEm8cl6AVyw==
X-Received: by 2002:a17:90b:1b0c:b0:1f5:1041:a4f3 with SMTP id nu12-20020a17090b1b0c00b001f51041a4f3mr4359739pjb.234.1660144741883;
        Wed, 10 Aug 2022 08:19:01 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:19:01 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 09/15] bpf: Use scoped-based charge in bpf_map_area_alloc
Date:   Wed, 10 Aug 2022 15:18:34 +0000
Message-Id: <20220810151840.16394-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220810151840.16394-1-laoar.shao@gmail.com>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bpf_map_area_alloc() is used to allocate a container of struct
bpf_map or members in this container.  To distinguish the map creation
and the other case, a new parameter struct bpf_map is added into
bpf_map_area_alloc(). Then for the non-map-creation case, we could get
the memcg from the map instead of using the current memcg.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  2 +-
 kernel/bpf/arraymap.c          |  2 +-
 kernel/bpf/bloom_filter.c      |  2 +-
 kernel/bpf/bpf_local_storage.c |  2 +-
 kernel/bpf/bpf_struct_ops.c    |  6 +++---
 kernel/bpf/cpumap.c            |  5 +++--
 kernel/bpf/devmap.c            | 13 ++++++++-----
 kernel/bpf/hashtab.c           |  8 +++++---
 kernel/bpf/local_storage.c     |  2 +-
 kernel/bpf/lpm_trie.c          |  2 +-
 kernel/bpf/offload.c           |  2 +-
 kernel/bpf/queue_stack_maps.c  |  2 +-
 kernel/bpf/reuseport_array.c   |  2 +-
 kernel/bpf/ringbuf.c           | 15 +++++++++------
 kernel/bpf/stackmap.c          |  5 +++--
 kernel/bpf/syscall.c           | 16 ++++++++++++++--
 net/core/sock_map.c            | 10 ++++++----
 net/xdp/xskmap.c               |  2 +-
 18 files changed, 61 insertions(+), 37 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 414f8b7..d7485b7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1635,7 +1635,7 @@ struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
-void *bpf_map_area_alloc(u64 size, int numa_node);
+void *bpf_map_area_alloc(u64 size, int numa_node, struct bpf_map *map);
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base, struct bpf_map *map);
 bool bpf_map_write_active(const struct bpf_map *map);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 9ce4d1b..80974c5 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -135,7 +135,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 		array = data + PAGE_ALIGN(sizeof(struct bpf_array))
 			- offsetof(struct bpf_array, value);
 	} else {
-		array = bpf_map_area_alloc(array_size, numa_node);
+		array = bpf_map_area_alloc(array_size, numa_node, NULL);
 	}
 	if (!array)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index e59064d..6691f79 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -142,7 +142,7 @@ static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 	}
 
 	bitset_bytes = roundup(bitset_bytes, sizeof(unsigned long));
-	bloom = bpf_map_area_alloc(sizeof(*bloom) + bitset_bytes, numa_node);
+	bloom = bpf_map_area_alloc(sizeof(*bloom) + bitset_bytes, numa_node, NULL);
 
 	if (!bloom)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 77e075b..67ab249 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -610,7 +610,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	unsigned int i;
 	u32 nbuckets;
 
-	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE);
+	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE, NULL);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 9fb8ad1..37ba5c0 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -618,7 +618,7 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 		 */
 		(vt->size - sizeof(struct bpf_struct_ops_value));
 
-	st_map = bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
+	st_map = bpf_map_area_alloc(st_map_size, NUMA_NO_NODE, NULL);
 	if (!st_map)
 		return ERR_PTR(-ENOMEM);
 
@@ -626,10 +626,10 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 	map = &st_map->map;
 	bpf_map_init_from_attr(map, attr);
 
-	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
+	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE, map);
 	st_map->links =
 		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_links *),
-				   NUMA_NO_NODE);
+				   NUMA_NO_NODE, map);
 	st_map->image = bpf_jit_alloc_exec(PAGE_SIZE);
 	if (!st_map->uvalue || !st_map->links || !st_map->image) {
 		bpf_struct_ops_map_free(map);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 7de2ae6..b593157 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -97,7 +97,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
-	cmap = bpf_map_area_alloc(sizeof(*cmap), NUMA_NO_NODE);
+	cmap = bpf_map_area_alloc(sizeof(*cmap), NUMA_NO_NODE, NULL);
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
 
@@ -112,7 +112,8 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	/* Alloc array for possible remote "destination" CPUs */
 	cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
 					   sizeof(struct bpf_cpu_map_entry *),
-					   cmap->map.numa_node);
+					   cmap->map.numa_node,
+					   &cmap->map);
 	if (!cmap->cpu_map)
 		goto free_cmap;
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3268ce7..807a4cd 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -89,12 +89,13 @@ struct bpf_dtab {
 static LIST_HEAD(dev_map_list);
 
 static struct hlist_head *dev_map_create_hash(unsigned int entries,
-					      int numa_node)
+					      int numa_node,
+					      struct bpf_map *map)
 {
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node, map);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -136,7 +137,8 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets,
-							   dtab->map.numa_node);
+							   dtab->map.numa_node,
+							   &dtab->map);
 		if (!dtab->dev_index_head)
 			return -ENOMEM;
 
@@ -144,7 +146,8 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	} else {
 		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
 						      sizeof(struct bpf_dtab_netdev *),
-						      dtab->map.numa_node);
+						      dtab->map.numa_node,
+						      &dtab->map);
 		if (!dtab->netdev_map)
 			return -ENOMEM;
 	}
@@ -160,7 +163,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	dtab = bpf_map_area_alloc(sizeof(*dtab), NUMA_NO_NODE);
+	dtab = bpf_map_area_alloc(sizeof(*dtab), NUMA_NO_NODE, NULL);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 1b3653d..e9a6d2c4 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -332,7 +332,8 @@ static int prealloc_init(struct bpf_htab *htab)
 		num_entries += num_possible_cpus();
 
 	htab->elems = bpf_map_area_alloc((u64)htab->elem_size * num_entries,
-					 htab->map.numa_node);
+					 htab->map.numa_node,
+					 &htab->map);
 	if (!htab->elems)
 		return -ENOMEM;
 
@@ -495,7 +496,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	struct bpf_htab *htab;
 	int err, i;
 
-	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
+	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE, NULL);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -534,7 +535,8 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	err = -ENOMEM;
 	htab->buckets = bpf_map_area_alloc(htab->n_buckets *
 					   sizeof(struct bucket),
-					   htab->map.numa_node);
+					   htab->map.numa_node,
+					   &htab->map);
 	if (!htab->buckets)
 		goto free_htab;
 
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index c705d66..fcc7ece 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -313,7 +313,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
 
-	map = bpf_map_area_alloc(sizeof(struct bpf_cgroup_storage_map), numa_node);
+	map = bpf_map_area_alloc(sizeof(struct bpf_cgroup_storage_map), numa_node, NULL);
 	if (!map)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index fd99360..3d329ae 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -558,7 +558,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	    attr->value_size > LPM_VAL_SIZE_MAX)
 		return ERR_PTR(-EINVAL);
 
-	trie = bpf_map_area_alloc(sizeof(*trie), NUMA_NO_NODE);
+	trie = bpf_map_area_alloc(sizeof(*trie), NUMA_NO_NODE, NULL);
 	if (!trie)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index c9941a9..87c59da 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -372,7 +372,7 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	    attr->map_type != BPF_MAP_TYPE_HASH)
 		return ERR_PTR(-EINVAL);
 
-	offmap = bpf_map_area_alloc(sizeof(*offmap), NUMA_NO_NODE);
+	offmap = bpf_map_area_alloc(sizeof(*offmap), NUMA_NO_NODE, NULL);
 	if (!offmap)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f2ec0c4..bf57e45 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -74,7 +74,7 @@ static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 	size = (u64) attr->max_entries + 1;
 	queue_size = sizeof(*qs) + size * attr->value_size;
 
-	qs = bpf_map_area_alloc(queue_size, numa_node);
+	qs = bpf_map_area_alloc(queue_size, numa_node, NULL);
 	if (!qs)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 594cdb0..52c7e77 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -158,7 +158,7 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 		return ERR_PTR(-EPERM);
 
 	/* allocate all map elements and zero-initialize them */
-	array = bpf_map_area_alloc(struct_size(array, ptrs, attr->max_entries), numa_node);
+	array = bpf_map_area_alloc(struct_size(array, ptrs, attr->max_entries), numa_node, NULL);
 	if (!array)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 74dd8dc..5eb7820 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -59,7 +59,8 @@ struct bpf_ringbuf_hdr {
 	u32 pg_off;
 };
 
-static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
+static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
+						  struct bpf_map *map)
 {
 	const gfp_t flags = GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL |
 			    __GFP_NOWARN | __GFP_ZERO;
@@ -89,7 +90,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	 * user-space implementations significantly.
 	 */
 	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
-	pages = bpf_map_area_alloc(array_size, numa_node);
+	pages = bpf_map_area_alloc(array_size, numa_node, map);
 	if (!pages)
 		return NULL;
 
@@ -127,11 +128,12 @@ static void bpf_ringbuf_notify(struct irq_work *work)
 	wake_up_all(&rb->waitq);
 }
 
-static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
+static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node,
+					     struct bpf_map *map)
 {
 	struct bpf_ringbuf *rb;
 
-	rb = bpf_ringbuf_area_alloc(data_sz, numa_node);
+	rb = bpf_ringbuf_area_alloc(data_sz, numa_node, map);
 	if (!rb)
 		return NULL;
 
@@ -164,13 +166,14 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
 
-	rb_map = bpf_map_area_alloc(sizeof(*rb_map), NUMA_NO_NODE);
+	rb_map = bpf_map_area_alloc(sizeof(*rb_map), NUMA_NO_NODE, NULL);
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
 
 	bpf_map_init_from_attr(&rb_map->map, attr);
 
-	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
+	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node,
+				       &rb_map->map);
 	if (!rb_map->rb) {
 		bpf_map_area_free(rb_map, &rb_map->map);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 042b7d2..9440fab 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -49,7 +49,8 @@ static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 	int err;
 
 	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
-					 smap->map.numa_node);
+					 smap->map.numa_node,
+					 &smap->map);
 	if (!smap->elems)
 		return -ENOMEM;
 
@@ -100,7 +101,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
+	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr), NULL);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 01d8d4a..02ce7e9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -362,9 +362,21 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 			flags, numa_node, __builtin_return_address(0));
 }
 
-void *bpf_map_area_alloc(u64 size, int numa_node)
+void *bpf_map_area_alloc(u64 size, int numa_node, struct bpf_map *map)
 {
-	return __bpf_map_area_alloc(size, numa_node, false);
+	struct mem_cgroup *memcg, *old_memcg;
+	void *ptr;
+
+	if (!map)
+		return __bpf_map_area_alloc(size, numa_node, false);
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	ptr = __bpf_map_area_alloc(size, numa_node, false);
+	set_active_memcg(old_memcg);
+	bpf_map_put_memcg(memcg);
+
+	return ptr;
 }
 
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e8f414a..2b3b24e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -41,7 +41,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	stab = bpf_map_area_alloc(sizeof(*stab), NUMA_NO_NODE);
+	stab = bpf_map_area_alloc(sizeof(*stab), NUMA_NO_NODE, NULL);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
@@ -50,7 +50,8 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 
 	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
 				       sizeof(struct sock *),
-				       stab->map.numa_node);
+				       stab->map.numa_node,
+				       &stab->map);
 	if (!stab->sks) {
 		bpf_map_area_free(stab, &stab->map);
 		return ERR_PTR(-ENOMEM);
@@ -1076,7 +1077,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 	if (attr->key_size > MAX_BPF_STACK)
 		return ERR_PTR(-E2BIG);
 
-	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
+	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE, NULL);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -1093,7 +1094,8 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 
 	htab->buckets = bpf_map_area_alloc(htab->buckets_num *
 					   sizeof(struct bpf_shtab_bucket),
-					   htab->map.numa_node);
+					   htab->map.numa_node,
+					   &htab->map);
 	if (!htab->buckets) {
 		err = -ENOMEM;
 		goto free_htab;
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 5abb87e..beb11fd 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -75,7 +75,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	numa_node = bpf_map_attr_numa_node(attr);
 	size = struct_size(m, xsk_map, attr->max_entries);
 
-	m = bpf_map_area_alloc(size, numa_node);
+	m = bpf_map_area_alloc(size, numa_node, NULL);
 	if (!m)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.8.3.1

