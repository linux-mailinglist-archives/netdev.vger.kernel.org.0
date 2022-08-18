Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8818E5985F1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245640AbiHROcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343543AbiHROcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:32:22 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7B6BA9D0;
        Thu, 18 Aug 2022 07:32:13 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s206so1439434pgs.3;
        Thu, 18 Aug 2022 07:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Vt3B1B2xA9UnavRf/lLTg9rVQPFR8dNDUq2oJHhoN6w=;
        b=n3Innaui3HRKiBQRFol3saxsQBriZpyrVHcrf3ZaokVPTDqaCPmdRetYE3fsOEwFOH
         /XcLDSud/O5Qj2YCIl0COAWJOUeDis98JL6Rfa5GvtmHVCLEd+CAzRjQze2UH0OoSGZx
         pCAJEjdtM0GU6Zcjaa+gy4wARXquYBGwEJo+Sh2iRjUQ9TTwr7hIZDYg8f5gOGukVco9
         SVAGlsVkK1bSFAoraBEK90o3jel3oLMoX4z3yf5lElgiCUZu4VAwZC4CFDkEpO+qYWAG
         ovYrU07xdFn1NT6gODYEYxjeeofRq0zDDA0tMSAf4nLStNI1/CIduH6TlsBFhW0Bu4Do
         9cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Vt3B1B2xA9UnavRf/lLTg9rVQPFR8dNDUq2oJHhoN6w=;
        b=nRqKyDHJsH5h/nqrt/ieVZTr1PQ0jWBx5+vFWxhg8N29ffAaRMLztlVUeLiP0leCoE
         Vzw0SX3mx54Cqu3ubbo0r/8oVE0E7tiQHwzURtH43E1RFv9QfxvKUSnLn5o5mJtGdcOz
         FRd1Ayy70n8nkJqwdigkdkkiKUS/UQYr2bPDbB5KV4xAb22srSef6nTxXJtqR1ZtmU5O
         2GONvzCgBwSj0d7y8SKpq69R+1byi1pZpNjMjLjFVPrb/Xi04N7Oc55YeL5Bqp4tkMUN
         rb46GF5pWiGsMcQ9RUlMJRG+uqJnL3XcOwBqg9vA+DIic65cCyFzZIIIK9KxwRV7NKbQ
         TrrA==
X-Gm-Message-State: ACgBeo1907bGB8ozzE5IE4KTfAEUZRZg8uIgwyl8ueM7i4NuuFdSQOrg
        lWT1Kg1Jl9uaIuL9STiQ9cQ=
X-Google-Smtp-Source: AA6agR5EXaH76tMFhRJJyEMzhXf/v1unPqYtNdNO+cnXN0MCFFOHCNFLxZi6nmgpeRkORqwHo5ZvVg==
X-Received: by 2002:a05:6a00:2a05:b0:52e:6c05:9b84 with SMTP id ce5-20020a056a002a0500b0052e6c059b84mr3183685pfb.77.1660833132805;
        Thu, 18 Aug 2022 07:32:12 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:32:11 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 11/12] bpf: Add return value for bpf_map_init_from_attr
Date:   Thu, 18 Aug 2022 14:31:17 +0000
Message-Id: <20220818143118.17733-12-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
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

Add return value for bpf_map_init_from_attr() to indicate whether it
init successfully. This is a preparation of the followup patch.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            | 2 +-
 kernel/bpf/arraymap.c          | 8 +++++++-
 kernel/bpf/bloom_filter.c      | 7 ++++++-
 kernel/bpf/bpf_local_storage.c | 7 ++++++-
 kernel/bpf/bpf_struct_ops.c    | 7 ++++++-
 kernel/bpf/cpumap.c            | 6 +++++-
 kernel/bpf/devmap.c            | 6 +++++-
 kernel/bpf/hashtab.c           | 6 +++++-
 kernel/bpf/local_storage.c     | 7 ++++++-
 kernel/bpf/lpm_trie.c          | 8 +++++++-
 kernel/bpf/offload.c           | 6 +++++-
 kernel/bpf/queue_stack_maps.c  | 7 ++++++-
 kernel/bpf/reuseport_array.c   | 7 ++++++-
 kernel/bpf/ringbuf.c           | 7 ++++++-
 kernel/bpf/syscall.c           | 4 +++-
 net/core/sock_map.c            | 8 +++++++-
 net/xdp/xskmap.c               | 8 +++++++-
 17 files changed, 94 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f95a2df..0c3534c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1639,7 +1639,7 @@ struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base, struct bpf_map *map);
 bool bpf_map_write_active(const struct bpf_map *map);
-void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
+int bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 int  generic_map_lookup_batch(struct bpf_map *map,
 			      const union bpf_attr *attr,
 			      union bpf_attr __user *uattr);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 3039832..28d0310 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -85,6 +85,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	bool bypass_spec_v1 = bpf_bypass_spec_v1();
 	u64 array_size, mask64;
 	struct bpf_array *array;
+	int err;
 
 	elem_size = round_up(attr->value_size, 8);
 
@@ -143,7 +144,12 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	array->map.bypass_spec_v1 = bypass_spec_v1;
 
 	/* copy mandatory map attributes */
-	bpf_map_init_from_attr(&array->map, attr);
+	err = bpf_map_init_from_attr(&array->map, attr);
+	if (err) {
+		bpf_map_area_free(array, NULL);
+		return ERR_PTR(err);
+	}
+
 	array->elem_size = elem_size;
 
 	if (percpu && bpf_array_alloc_percpu(array)) {
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index 6691f79..be64227 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -93,6 +93,7 @@ static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct bpf_bloom_filter *bloom;
+	int err;
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -147,7 +148,11 @@ static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 	if (!bloom)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&bloom->map, attr);
+	err = bpf_map_init_from_attr(&bloom->map, attr);
+	if (err) {
+		bpf_map_area_free(bloom, NULL);
+		return ERR_PTR(err);
+	}
 
 	bloom->nr_hash_funcs = nr_hash_funcs;
 	bloom->bitset_mask = bitset_mask;
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 71d5bf1..b82d124 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -609,11 +609,16 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	struct bpf_local_storage_map *smap;
 	unsigned int i;
 	u32 nbuckets;
+	int err;
 
 	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE, NULL);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
-	bpf_map_init_from_attr(&smap->map, attr);
+	err = bpf_map_init_from_attr(&smap->map, attr);
+	if (err) {
+		bpf_map_area_free(&smap->map, NULL);
+		return ERR_PTR(err);
+	}
 
 	nbuckets = roundup_pow_of_two(num_possible_cpus());
 	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 37ba5c0..7cfbabc 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -598,6 +598,7 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 	struct bpf_struct_ops_map *st_map;
 	const struct btf_type *t, *vt;
 	struct bpf_map *map;
+	int err;
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -624,7 +625,11 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 
 	st_map->st_ops = st_ops;
 	map = &st_map->map;
-	bpf_map_init_from_attr(map, attr);
+	err = bpf_map_init_from_attr(map, attr);
+	if (err) {
+		bpf_map_area_free(st_map, NULL);
+		return ERR_PTR(err);
+	}
 
 	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE, map);
 	st_map->links =
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b593157..e672e62 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -101,7 +101,11 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&cmap->map, attr);
+	err = bpf_map_init_from_attr(&cmap->map, attr);
+	if (err) {
+		bpf_map_area_free(cmap, NULL);
+		return ERR_PTR(err);
+	}
 
 	/* Pre-limit array size based on NR_CPUS, not final CPU check */
 	if (cmap->map.max_entries > NR_CPUS) {
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 807a4cd..10f038d 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -167,7 +167,11 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&dtab->map, attr);
+	err = bpf_map_init_from_attr(&dtab->map, attr);
+	if (err) {
+		bpf_map_area_free(dtab, NULL);
+		return ERR_PTR(err);
+	}
 
 	err = dev_map_init_map(dtab, attr);
 	if (err) {
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index e9a6d2c4..f059ae0 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -500,7 +500,11 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&htab->map, attr);
+	err = bpf_map_init_from_attr(&htab->map, attr);
+	if (err) {
+		bpf_map_area_free(htab, NULL);
+		return ERR_PTR(err);
+	}
 
 	lockdep_register_key(&htab->lockdep_key);
 
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index fcc7ece..1901195 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -287,6 +287,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 	__u32 max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct bpf_cgroup_storage_map *map;
+	int err;
 
 	/* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
 	 * is the same as other local storages.
@@ -318,7 +319,11 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 
 	/* copy mandatory map attributes */
-	bpf_map_init_from_attr(&map->map, attr);
+	err = bpf_map_init_from_attr(&map->map, attr);
+	if (err) {
+		bpf_map_area_free(map, NULL);
+		return ERR_PTR(err);
+	}
 
 	spin_lock_init(&map->lock);
 	map->root = RB_ROOT;
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 3d329ae..38d7b00 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -543,6 +543,7 @@ static int trie_delete_elem(struct bpf_map *map, void *_key)
 static struct bpf_map *trie_alloc(union bpf_attr *attr)
 {
 	struct lpm_trie *trie;
+	int err;
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -563,7 +564,12 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 
 	/* copy mandatory map attributes */
-	bpf_map_init_from_attr(&trie->map, attr);
+	err = bpf_map_init_from_attr(&trie->map, attr);
+	if (err) {
+		bpf_map_area_free(trie, NULL);
+		return ERR_PTR(err);
+	}
+
 	trie->data_size = attr->key_size -
 			  offsetof(struct bpf_lpm_trie_key, data);
 	trie->max_prefixlen = trie->data_size * 8;
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 87c59da..dba7ed2 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -376,7 +376,11 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	if (!offmap)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&offmap->map, attr);
+	err = bpf_map_init_from_attr(&offmap->map, attr);
+	if (err) {
+		bpf_map_area_free(offmap, NULL);
+		return ERR_PTR(err);
+	}
 
 	rtnl_lock();
 	down_write(&bpf_devs_lock);
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index bf57e45..f231897 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -70,6 +70,7 @@ static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct bpf_queue_stack *qs;
 	u64 size, queue_size;
+	int err;
 
 	size = (u64) attr->max_entries + 1;
 	queue_size = sizeof(*qs) + size * attr->value_size;
@@ -78,7 +79,11 @@ static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 	if (!qs)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&qs->map, attr);
+	err = bpf_map_init_from_attr(&qs->map, attr);
+	if (err) {
+		bpf_map_area_free(qs, NULL);
+		return ERR_PTR(err);
+	}
 
 	qs->size = size;
 
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 52c7e77..4da969b 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -153,6 +153,7 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 {
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct reuseport_array *array;
+	int err;
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -163,7 +164,11 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 
 	/* copy mandatory map attributes */
-	bpf_map_init_from_attr(&array->map, attr);
+	err = bpf_map_init_from_attr(&array->map, attr);
+	if (err) {
+		bpf_map_area_free(array, NULL);
+		return ERR_PTR(err);
+	}
 
 	return &array->map;
 }
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 1e7284c..3edefd3 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -185,6 +185,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node,
 static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_ringbuf_map *rb_map;
+	int err;
 
 	if (attr->map_flags & ~RINGBUF_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
@@ -204,7 +205,11 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&rb_map->map, attr);
+	err = bpf_map_init_from_attr(&rb_map->map, attr);
+	if (err) {
+		bpf_map_area_free(rb_map, NULL);
+		return ERR_PTR(err);
+	}
 
 	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node,
 				       &rb_map->map);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2bd3bcf..5f5cade4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -403,7 +403,7 @@ static u32 bpf_map_flags_retain_permanent(u32 flags)
 	return flags & ~(BPF_F_RDONLY | BPF_F_WRONLY);
 }
 
-void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)
+int bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)
 {
 	bpf_map_save_memcg(map);
 	map->map_type = attr->map_type;
@@ -413,6 +413,8 @@ void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)
 	map->map_flags = bpf_map_flags_retain_permanent(attr->map_flags);
 	map->numa_node = bpf_map_attr_numa_node(attr);
 	map->map_extra = attr->map_extra;
+
+	return 0;
 }
 
 static int bpf_map_alloc_id(struct bpf_map *map)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2b3b24e..766a260 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -31,6 +31,7 @@ static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_stab *stab;
+	int err;
 
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -45,7 +46,12 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&stab->map, attr);
+	err = bpf_map_init_from_attr(&stab->map, attr);
+	if (err) {
+		bpf_map_area_free(stab, NULL);
+		return ERR_PTR(err);
+	}
+
 	raw_spin_lock_init(&stab->lock);
 
 	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index beb11fd..8e7a5a6 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -63,6 +63,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	struct xsk_map *m;
 	int numa_node;
 	u64 size;
+	int err;
 
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -79,7 +80,12 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	if (!m)
 		return ERR_PTR(-ENOMEM);
 
-	bpf_map_init_from_attr(&m->map, attr);
+	err = bpf_map_init_from_attr(&m->map, attr);
+	if (err) {
+		bpf_map_area_free(m, NULL);
+		return ERR_PTR(err);
+	}
+
 	spin_lock_init(&m->lock);
 
 	return &m->map;
-- 
1.8.3.1

