Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A81585271
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbiG2PYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbiG2PX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815B185F99;
        Fri, 29 Jul 2022 08:23:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so5622198pjl.0;
        Fri, 29 Jul 2022 08:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yY5QSV/StxaGhIVU47wKOjMZAWLb0lpndrHiTZxnvTs=;
        b=PVhPRrUg7ts2cUfPBRcTovmnlKW7Z5k7eaG8OzXLVvnfJOvHgyu+i8x7VKhygLtv0r
         YD3O8X/bmJOLVfIibZhs2g0Oh4Q0u2gPzYtb3CSldJZBSI8bltEPv3oYgBT3wohii4aN
         GA6Bh2xyG7YoSAZxnPRssoav9dUyYFHVEnwsc6mvYjBl6RHluaYd/yGYx5DrUGrSku4w
         LO++RYVwgK4A+0X8GEFqU4G6yNqq2xuDDdvLgO5TITKmKvXoOB6g95Mo1gwnhGFV15uE
         gLHS+9YqT2h0PbERhHCnS4uDsW/Fe9QWBsQyUwADGKdNaegJFma3lcge7hyCC9a5khQZ
         3Buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yY5QSV/StxaGhIVU47wKOjMZAWLb0lpndrHiTZxnvTs=;
        b=lDKZuAnONGNhTWmp6OI/Ony7+MLmKodBxrsd0iVrVkjF9Ok0DnCRCN6UBkYzSHBYOd
         7uH841oq5CWycN07urXpVaGBKJfwTkOAbrnlmv78vNtjwG7BX8OwyKhTI2dczEO4Y6Na
         Smqbc56ib71ZjZMRLlPfwM0ubBzwPMzxwNbC2ZYFG6dJBKJIy3pj/P9E4Ecw0lx1OjlH
         N3qkR8Ml0lnKxz9VtT6a1L0s+0Cnzw4l1mCyU3ON5mH/wMWESjhAHRhstc/qOMVEk9PL
         cnectWmhl5h+xvfNjyL+PpI+qbsGM8Hwr5sL9g30Rjk8T4h9RDEhKu6HyT2Ia27wymnG
         e/EQ==
X-Gm-Message-State: ACgBeo0/CgSSJb7bWmDDTM7M9UHfkzETMdguRxGUyLvzyJXmAibpEyfo
        bpK74tJqVOE6Vm76dfMaono=
X-Google-Smtp-Source: AA6agR6a0ENsUe9oe9ps5/wlhZJjT9cX4gsopZOaAdU3UCGEo0KTZUOFx9XY0Hyud2hzLvkqfJ6qwg==
X-Received: by 2002:a17:902:e791:b0:16d:7f5d:d29e with SMTP id cp17-20020a170902e79100b0016d7f5dd29emr4344400plb.14.1659108217878;
        Fri, 29 Jul 2022 08:23:37 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:36 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 08/15] bpf: Use scope-based charge for bpf_map_area_alloc
Date:   Fri, 29 Jul 2022 15:23:09 +0000
Message-Id: <20220729152316.58205-9-laoar.shao@gmail.com>
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

Let's also get memcg from the bpf map in bpf_map_area_alloc() instead of
using the current memcg.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h         |  2 +-
 kernel/bpf/bpf_struct_ops.c |  4 ++--
 kernel/bpf/cpumap.c         |  2 +-
 kernel/bpf/devmap.c         | 12 ++++++++----
 kernel/bpf/hashtab.c        |  5 +++--
 kernel/bpf/ringbuf.c        | 14 +++++++++-----
 kernel/bpf/stackmap.c       |  3 ++-
 kernel/bpf/syscall.c        | 28 ++++++++++++++++++----------
 net/core/sock_map.c         |  7 ++++---
 9 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3f9893e14124..711d9b1829d4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1637,7 +1637,7 @@ void bpf_map_put(struct bpf_map *map);
 void *bpf_map_container_alloc(u64 size, int numa_node);
 void *bpf_map_container_mmapable_alloc(u64 size, int numa_node,
 				       u32 align, u32 offset);
-void *bpf_map_area_alloc(u64 size, int numa_node);
+void *bpf_map_area_alloc(struct bpf_map *map, u64 size, int numa_node);
 void bpf_map_area_free(void *base);
 void bpf_map_container_free(void *base);
 bool bpf_map_write_active(const struct bpf_map *map);
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 66df3059a3fe..874fda7e2b8b 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -625,9 +625,9 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 	st_map->st_ops = st_ops;
 	map = &st_map->map;
 
-	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
+	st_map->uvalue = bpf_map_area_alloc(map, vt->size, NUMA_NO_NODE);
 	st_map->links =
-		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_links *),
+		bpf_map_area_alloc(map, btf_type_vlen(t) * sizeof(struct bpf_links *),
 				   NUMA_NO_NODE);
 	st_map->image = bpf_jit_alloc_exec(PAGE_SIZE);
 	if (!st_map->uvalue || !st_map->links || !st_map->image) {
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 23e941826eec..95c1642deaf6 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -110,7 +110,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	}
 
 	/* Alloc array for possible remote "destination" CPUs */
-	cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
+	cmap->cpu_map = bpf_map_area_alloc(&cmap->map, cmap->map.max_entries *
 					   sizeof(struct bpf_cpu_map_entry *),
 					   cmap->map.numa_node);
 	if (!cmap->cpu_map)
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3e99c10f1729..b625d578bc93 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -88,13 +88,15 @@ static DEFINE_PER_CPU(struct list_head, dev_flush_list);
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
-static struct hlist_head *dev_map_create_hash(unsigned int entries,
+static struct hlist_head *dev_map_create_hash(struct bpf_map *map,
+					      unsigned int entries,
 					      int numa_node)
 {
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc(map, (u64) entries * sizeof(*hash),
+				  numa_node);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -138,14 +140,16 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	}
 
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets,
+		dtab->dev_index_head = dev_map_create_hash(&dtab->map,
+							   dtab->n_buckets,
 							   dtab->map.numa_node);
 		if (!dtab->dev_index_head)
 			return -ENOMEM;
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
-		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
+		dtab->netdev_map = bpf_map_area_alloc(&dtab->map,
+						      (u64) dtab->map.max_entries *
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d2fb144276ab..2a34a115e14f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -331,7 +331,8 @@ static int prealloc_init(struct bpf_htab *htab)
 	if (htab_has_extra_elems(htab))
 		num_entries += num_possible_cpus();
 
-	htab->elems = bpf_map_area_alloc((u64)htab->elem_size * num_entries,
+	htab->elems = bpf_map_area_alloc(&htab->map,
+					 (u64)htab->elem_size * num_entries,
 					 htab->map.numa_node);
 	if (!htab->elems)
 		return -ENOMEM;
@@ -532,7 +533,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 		goto free_htab;
 
 	err = -ENOMEM;
-	htab->buckets = bpf_map_area_alloc(htab->n_buckets *
+	htab->buckets = bpf_map_area_alloc(&htab->map, htab->n_buckets *
 					   sizeof(struct bucket),
 					   htab->map.numa_node);
 	if (!htab->buckets)
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 35258aa45236..7c875d4d5b2f 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -59,7 +59,9 @@ struct bpf_ringbuf_hdr {
 	u32 pg_off;
 };
 
-static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
+static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
+						  size_t data_sz,
+						  int numa_node)
 {
 	const gfp_t flags = GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL |
 			    __GFP_NOWARN | __GFP_ZERO;
@@ -89,7 +91,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	 * user-space implementations significantly.
 	 */
 	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
-	pages = bpf_map_area_alloc(array_size, numa_node);
+	pages = bpf_map_area_alloc(map, array_size, numa_node);
 	if (!pages)
 		return NULL;
 
@@ -127,11 +129,12 @@ static void bpf_ringbuf_notify(struct irq_work *work)
 	wake_up_all(&rb->waitq);
 }
 
-static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
+static struct bpf_ringbuf *bpf_ringbuf_alloc(struct bpf_map *map,
+					     size_t data_sz, int numa_node)
 {
 	struct bpf_ringbuf *rb;
 
-	rb = bpf_ringbuf_area_alloc(data_sz, numa_node);
+	rb = bpf_ringbuf_area_alloc(map, data_sz, numa_node);
 	if (!rb)
 		return NULL;
 
@@ -170,7 +173,8 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 	bpf_map_init_from_attr(&rb_map->map, attr);
 
-	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
+	rb_map->rb = bpf_ringbuf_alloc(&rb_map->map, attr->max_entries,
+				       rb_map->map.numa_node);
 	if (!rb_map->rb) {
 		bpf_map_container_free(rb_map);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 0c3185406f56..c9a91ca05a03 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -48,7 +48,8 @@ static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 			(u64)smap->map.value_size;
 	int err;
 
-	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
+	smap->elems = bpf_map_area_alloc(&smap->map,
+					 elem_size * smap->map.max_entries,
 					 smap->map.numa_node);
 	if (!smap->elems)
 		return -ENOMEM;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7289ee1a300a..4f893d2ac4fd 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -334,16 +334,6 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 			flags, numa_node, __builtin_return_address(0));
 }
 
-void *bpf_map_area_alloc(u64 size, int numa_node)
-{
-	return __bpf_map_area_alloc(size, numa_node, false);
-}
-
-void bpf_map_area_free(void *area)
-{
-	kvfree(area);
-}
-
 static u32 bpf_map_flags_retain_permanent(u32 flags)
 {
 	/* Some map creation flags are not tied to the map object but
@@ -495,6 +485,24 @@ static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
 }
 #endif
 
+void *bpf_map_area_alloc(struct bpf_map *map, u64 size, int numa_node)
+{
+	struct mem_cgroup *memcg, *old_memcg;
+	void *ptr;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	ptr = __bpf_map_area_alloc(size, numa_node, false);
+	set_active_memcg(old_memcg);
+
+	return ptr;
+}
+
+void bpf_map_area_free(void *area)
+{
+	kvfree(area);
+}
+
 /*
  * The return pointer is a bpf_map container, as follow,
  *   struct bpf_map_container {
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 4b5876c4a47d..1f49dc89822c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -48,8 +48,9 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	bpf_map_init_from_attr(&stab->map, attr);
 	raw_spin_lock_init(&stab->lock);
 
-	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
-				       sizeof(struct sock *),
+	stab->sks = bpf_map_area_alloc(&stab->map,
+				       (u64)stab->map.max_entries *
+					sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
 		bpf_map_container_free(stab);
@@ -1091,7 +1092,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 		goto free_htab;
 	}
 
-	htab->buckets = bpf_map_area_alloc(htab->buckets_num *
+	htab->buckets = bpf_map_area_alloc(&htab->map, htab->buckets_num *
 					   sizeof(struct bpf_shtab_bucket),
 					   htab->map.numa_node);
 	if (!htab->buckets) {
-- 
2.17.1

