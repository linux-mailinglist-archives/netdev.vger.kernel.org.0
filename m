Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F164DE994
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbiCSRcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243028AbiCSRcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DAA45506;
        Sat, 19 Mar 2022 10:30:45 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso6908966pjb.5;
        Sat, 19 Mar 2022 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=59FYyOnE/ZfEE+/nWxi+Uw2ttiMNAftCWsX5hGEEb68=;
        b=K5CK3XbPteaXT9NC/Kt7ZweGODe0q1YbJP/or7LyRRCogBUhlcCxGunIOv4Rr42z0/
         aLYZeU9LGqsD2ly1kCsXG2KH/njEAXgvUo7OFEPCN54Tt0Zr5+PJWhLCcfHxmHllqrbo
         OvYkhSz1Zt9vq3YSTHiOwkQ+EPq4fEUQpo+YzQi5mecwY3YEuY9svC4mQzse8AUJ73MC
         mXOYHHRQuA6b3X8nUzE29jOe5XMxu9boxYVfyxrwYQD1vREplesaUPQzaYD1RG7KKVh+
         jgdbaOZG6hi18NmezjFFyTBr/gl3vOquUADRvmeQ2/zIUxidC0vgBglFYGGwP7jKC30A
         AekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=59FYyOnE/ZfEE+/nWxi+Uw2ttiMNAftCWsX5hGEEb68=;
        b=DLS5R3pOCn/7yPgZ+UUybAO3WD3467kTpMpO1/4wbCieZjZ9Oi0pQGx7hWQyxtdAaK
         sW0vhM4zLIiVGP3WZ4JMO2Y0JEsv7IG3hUMHkAtLcUI4gv7CRhYwDguui2R2hkMHZPM4
         4cnRnSm79XN3acuqlrjxRypLvp3PZxZR1D1PCsSGsIm8/xp2BODoCFPVFzG2xp3Cpyf9
         +rr4ny8o5tKToGF/oSTnxNmrJyG2NfPbh6/jcf/IjHxF5yOFuY76CudmsbosyfvgUwQm
         CJSSIdyhzoRpZrXUBfSRs+4CfaSscdL5tNb7c3Qq42N4ZhaeEbLexgS0H5EUZhSFSgbe
         fNGA==
X-Gm-Message-State: AOAM530ZMQLNiLTE/HXL/kbKxIF9ENvsflutpHhageYuHSMWjHQCDLOk
        4A+bNRRPhqphWc8SSeUBb3E=
X-Google-Smtp-Source: ABdhPJwfmnqCjaYsNruPjkN8VzGPjXY5rVHbzV6iD/dhuKWThJxTIsUb4037rl7jXLCT9K9X1zDU9Q==
X-Received: by 2002:a17:902:db0c:b0:154:1b36:6a6b with SMTP id m12-20020a170902db0c00b001541b366a6bmr5091539plx.7.1647711045029;
        Sat, 19 Mar 2022 10:30:45 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:44 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 04/14] bpf: Introduce new parameter bpf_attr in bpf_map_area_alloc
Date:   Sat, 19 Mar 2022 17:30:26 +0000
Message-Id: <20220319173036.23352-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
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

Add a new parameter bpf_attr in bpf_map_area_alloc(), then we can get no
charge flag from it. Currently there're two parameters, one of which is
also got from bpf_attr, so we can remove it after this change.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h           |  4 ++--
 kernel/bpf/arraymap.c         |  5 ++---
 kernel/bpf/bloom_filter.c     |  3 +--
 kernel/bpf/bpf_struct_ops.c   |  8 ++++----
 kernel/bpf/cpumap.c           |  3 +--
 kernel/bpf/devmap.c           | 10 ++++------
 kernel/bpf/hashtab.c          | 10 ++++------
 kernel/bpf/queue_stack_maps.c |  3 +--
 kernel/bpf/reuseport_array.c  |  3 +--
 kernel/bpf/ringbuf.c          | 11 ++++++-----
 kernel/bpf/stackmap.c         | 11 ++++++-----
 kernel/bpf/syscall.c          | 13 +++++++------
 net/core/sock_map.c           |  6 ++----
 net/xdp/xskmap.c              |  4 +---
 14 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 07c6603a6c81..90a542d5a411 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1518,8 +1518,8 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
 struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
-void *bpf_map_area_alloc(u64 size, int numa_node);
-void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
+void *bpf_map_area_alloc(u64 size, union bpf_attr *attr);
+void *bpf_map_area_mmapable_alloc(u64 size, union bpf_attr *attr);
 void bpf_map_area_free(void *base);
 bool bpf_map_write_active(const struct bpf_map *map);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index ac123747303c..e26aef906392 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -81,7 +81,6 @@ int array_map_alloc_check(union bpf_attr *attr)
 static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 {
 	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
-	int numa_node = bpf_map_attr_numa_node(attr);
 	u32 elem_size, index_mask, max_entries;
 	bool bypass_spec_v1 = bpf_bypass_spec_v1();
 	u64 array_size, mask64;
@@ -130,13 +129,13 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 		void *data;
 
 		/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
-		data = bpf_map_area_mmapable_alloc(array_size, numa_node);
+		data = bpf_map_area_mmapable_alloc(array_size, attr);
 		if (!data)
 			return ERR_PTR(-ENOMEM);
 		array = data + PAGE_ALIGN(sizeof(struct bpf_array))
 			- offsetof(struct bpf_array, value);
 	} else {
-		array = bpf_map_area_alloc(array_size, numa_node);
+		array = bpf_map_area_alloc(array_size, attr);
 	}
 	if (!array)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index f8ebfb4831e5..a35c664b4a02 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -90,7 +90,6 @@ static int bloom_map_get_next_key(struct bpf_map *map, void *key, void *next_key
 static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 {
 	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
-	int numa_node = bpf_map_attr_numa_node(attr);
 	struct bpf_bloom_filter *bloom;
 
 	if (!bpf_capable())
@@ -141,7 +140,7 @@ static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 	}
 
 	bitset_bytes = roundup(bitset_bytes, sizeof(unsigned long));
-	bloom = bpf_map_area_alloc(sizeof(*bloom) + bitset_bytes, numa_node);
+	bloom = bpf_map_area_alloc(sizeof(*bloom) + bitset_bytes, attr);
 
 	if (!bloom)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 09eb848e6d12..1ca1407ae5e6 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -591,17 +591,17 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 		 */
 		(vt->size - sizeof(struct bpf_struct_ops_value));
 
-	st_map = bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
+	attr->map_flags &= ~BPF_F_NUMA_NODE;
+	st_map = bpf_map_area_alloc(st_map_size, attr);
 	if (!st_map)
 		return ERR_PTR(-ENOMEM);
 
 	st_map->st_ops = st_ops;
 	map = &st_map->map;
 
-	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
+	st_map->uvalue = bpf_map_area_alloc(vt->size, attr);
 	st_map->progs =
-		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_prog *),
-				   NUMA_NO_NODE);
+		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_prog *), attr);
 	st_map->image = bpf_jit_alloc_exec(PAGE_SIZE);
 	if (!st_map->uvalue || !st_map->progs || !st_map->image) {
 		bpf_struct_ops_map_free(map);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 201226fc652b..5a5b40e986ff 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -113,8 +113,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	/* Alloc array for possible remote "destination" CPUs */
 	cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
-					   sizeof(struct bpf_cpu_map_entry *),
-					   cmap->map.numa_node);
+					   sizeof(struct bpf_cpu_map_entry *), attr);
 	if (!cmap->cpu_map)
 		goto free_cmap;
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 39bf8b521f27..2857176c82bb 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -88,12 +88,12 @@ static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
 static struct hlist_head *dev_map_create_hash(unsigned int entries,
-					      int numa_node)
+							union bpf_attr *attr)
 {
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), attr);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -137,16 +137,14 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	}
 
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets,
-							   dtab->map.numa_node);
+		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets, attr);
 		if (!dtab->dev_index_head)
 			return -ENOMEM;
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
 		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
-						      sizeof(struct bpf_dtab_netdev *),
-						      dtab->map.numa_node);
+						      sizeof(struct bpf_dtab_netdev *), attr);
 		if (!dtab->netdev_map)
 			return -ENOMEM;
 	}
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 5c6ec8780b09..2c84045ff8e1 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -303,7 +303,7 @@ static struct htab_elem *prealloc_lru_pop(struct bpf_htab *htab, void *key,
 	return NULL;
 }
 
-static int prealloc_init(struct bpf_htab *htab)
+static int prealloc_init(union bpf_attr *attr, struct bpf_htab *htab)
 {
 	u32 num_entries = htab->map.max_entries;
 	int err = -ENOMEM, i;
@@ -311,8 +311,7 @@ static int prealloc_init(struct bpf_htab *htab)
 	if (htab_has_extra_elems(htab))
 		num_entries += num_possible_cpus();
 
-	htab->elems = bpf_map_area_alloc((u64)htab->elem_size * num_entries,
-					 htab->map.numa_node);
+	htab->elems = bpf_map_area_alloc((u64)htab->elem_size * num_entries, attr);
 	if (!htab->elems)
 		return -ENOMEM;
 
@@ -513,8 +512,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 
 	err = -ENOMEM;
 	htab->buckets = bpf_map_area_alloc(htab->n_buckets *
-					   sizeof(struct bucket),
-					   htab->map.numa_node);
+					   sizeof(struct bucket), attr);
 	if (!htab->buckets)
 		goto free_htab;
 
@@ -535,7 +533,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	htab_init_buckets(htab);
 
 	if (prealloc) {
-		err = prealloc_init(htab);
+		err = prealloc_init(attr, htab);
 		if (err)
 			goto free_map_locked;
 
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index c78eed4659ce..0ff93c5bc184 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -66,14 +66,13 @@ static int queue_stack_map_alloc_check(union bpf_attr *attr)
 
 static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 {
-	int numa_node = bpf_map_attr_numa_node(attr);
 	struct bpf_queue_stack *qs;
 	u64 size, queue_size;
 
 	size = (u64) attr->max_entries + 1;
 	queue_size = sizeof(*qs) + size * attr->value_size;
 
-	qs = bpf_map_area_alloc(queue_size, numa_node);
+	qs = bpf_map_area_alloc(queue_size, attr);
 	if (!qs)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 8251243022a2..b19fb70118a4 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -150,14 +150,13 @@ static void reuseport_array_free(struct bpf_map *map)
 
 static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 {
-	int numa_node = bpf_map_attr_numa_node(attr);
 	struct reuseport_array *array;
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	/* allocate all map elements and zero-initialize them */
-	array = bpf_map_area_alloc(struct_size(array, ptrs, attr->max_entries), numa_node);
+	array = bpf_map_area_alloc(struct_size(array, ptrs, attr->max_entries), attr);
 	if (!array)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 88779f688679..a3b4d2a0a2c7 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -58,13 +58,14 @@ struct bpf_ringbuf_hdr {
 	u32 pg_off;
 };
 
-static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
+static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, union bpf_attr *attr)
 {
 	const gfp_t flags = GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL |
 			    __GFP_NOWARN | __GFP_ZERO;
 	int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
 	int nr_data_pages = data_sz >> PAGE_SHIFT;
 	int nr_pages = nr_meta_pages + nr_data_pages;
+	int numa_node = bpf_map_attr_numa_node(attr);
 	struct page **pages, *page;
 	struct bpf_ringbuf *rb;
 	size_t array_size;
@@ -88,7 +89,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	 * user-space implementations significantly.
 	 */
 	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
-	pages = bpf_map_area_alloc(array_size, numa_node);
+	pages = bpf_map_area_alloc(array_size, attr);
 	if (!pages)
 		return NULL;
 
@@ -126,11 +127,11 @@ static void bpf_ringbuf_notify(struct irq_work *work)
 	wake_up_all(&rb->waitq);
 }
 
-static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
+static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, union bpf_attr *attr)
 {
 	struct bpf_ringbuf *rb;
 
-	rb = bpf_ringbuf_area_alloc(data_sz, numa_node);
+	rb = bpf_ringbuf_area_alloc(data_sz, attr);
 	if (!rb)
 		return NULL;
 
@@ -169,7 +170,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 	bpf_map_init_from_attr(&rb_map->map, attr);
 
-	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
+	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, attr);
 	if (!rb_map->rb) {
 		kfree(rb_map);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index b2e7dc1d9f5a..ed6bebef0132 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -42,14 +42,15 @@ static inline int stack_map_data_size(struct bpf_map *map)
 		sizeof(struct bpf_stack_build_id) : sizeof(u64);
 }
 
-static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
+static int prealloc_elems_and_freelist(union bpf_attr *attr,
+				struct bpf_stack_map *smap)
 {
 	u64 elem_size = sizeof(struct stack_map_bucket) +
 			(u64)smap->map.value_size;
 	int err;
 
-	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
-					 smap->map.numa_node);
+	smap->elems = bpf_map_area_alloc(elem_size *
+					smap->map.max_entries, attr);
 	if (!smap->elems)
 		return -ENOMEM;
 
@@ -101,7 +102,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
 	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
-	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
+	smap = bpf_map_area_alloc(cost, attr);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 
@@ -113,7 +114,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 	if (err)
 		goto free_smap;
 
-	err = prealloc_elems_and_freelist(smap);
+	err = prealloc_elems_and_freelist(attr, smap);
 	if (err)
 		goto put_buffers;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0cca3d7d0d84..f70a7067ef4a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -295,7 +295,7 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
  * (e.g. in map update path) without taking care of setting the active
  * memory cgroup (see at bpf_map_kmalloc_node() for example).
  */
-static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
+static void *__bpf_map_area_alloc(u64 size, union bpf_attr *attr, bool mmapable)
 {
 	/* We really just want to fail instead of triggering OOM killer
 	 * under memory pressure, therefore we set __GFP_NORETRY to kmalloc,
@@ -308,8 +308,9 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 	 */
 
 	const gfp_t gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
-	unsigned int flags = 0;
+	int numa_node = bpf_map_attr_numa_node(attr);
 	unsigned long align = 1;
+	unsigned int flags = 0;
 	void *area;
 
 	if (size >= SIZE_MAX)
@@ -332,14 +333,14 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 			flags, numa_node, __builtin_return_address(0));
 }
 
-void *bpf_map_area_alloc(u64 size, int numa_node)
+void *bpf_map_area_alloc(u64 size, union bpf_attr *attr)
 {
-	return __bpf_map_area_alloc(size, numa_node, false);
+	return __bpf_map_area_alloc(size, attr, false);
 }
 
-void *bpf_map_area_mmapable_alloc(u64 size, int numa_node)
+void *bpf_map_area_mmapable_alloc(u64 size, union bpf_attr *attr)
 {
-	return __bpf_map_area_alloc(size, numa_node, true);
+	return __bpf_map_area_alloc(size, attr, true);
 }
 
 void bpf_map_area_free(void *area)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 7b0215bea413..26b89d37944d 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -49,8 +49,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	raw_spin_lock_init(&stab->lock);
 
 	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
-				       sizeof(struct sock *),
-				       stab->map.numa_node);
+					sizeof(struct sock *), attr);
 	if (!stab->sks) {
 		kfree(stab);
 		return ERR_PTR(-ENOMEM);
@@ -1093,8 +1092,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 	}
 
 	htab->buckets = bpf_map_area_alloc(htab->buckets_num *
-					   sizeof(struct bpf_shtab_bucket),
-					   htab->map.numa_node);
+					   sizeof(struct bpf_shtab_bucket), attr);
 	if (!htab->buckets) {
 		err = -ENOMEM;
 		goto free_htab;
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 10a5ae727bd5..50795c0c9b81 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -63,7 +63,6 @@ static void xsk_map_sock_delete(struct xdp_sock *xs,
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
 	struct xsk_map *m;
-	int numa_node;
 	u64 size;
 
 	if (!capable(CAP_NET_ADMIN))
@@ -74,10 +73,9 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~XSK_MAP_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	numa_node = bpf_map_attr_numa_node(attr);
 	size = struct_size(m, xsk_map, attr->max_entries);
 
-	m = bpf_map_area_alloc(size, numa_node);
+	m = bpf_map_area_alloc(size, attr);
 	if (!m)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.17.1

