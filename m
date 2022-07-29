Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24BB585263
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiG2PXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237352AbiG2PXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:33 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC5F83F02;
        Fri, 29 Jul 2022 08:23:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so5587559pjk.1;
        Fri, 29 Jul 2022 08:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BtVcQdl416qb7s4IbcOizRRojtBfwQY2q+CMmuUPEsI=;
        b=XW6cOXyyNkMTotHKjdFP0DcxFQ2UjvM99NgoZMsgCARdHiVWMjXAgB9+D0I3DfmNC/
         OK4mdImWQJvoejmWzAvyCadaGsz9hgmxWu5esmuaaP4YzxOFLdS+3a04L2XM5sBdDX1X
         gKRnp+iMeJ6kuopt1d4Z9eUpRDoBqf9DhS0lJn1dww7XHUIc9mV4G0Gf1qvZn8OxvciQ
         pBTlAyuHVCt1bsUT/cBTLXb4kCB7pqjgU6+GlsGEdtVHiJ69Qr/OdRUiLyeXbLp6j+XV
         sUgG6fjvvqGPCdEwG2wp0M9ne0UTvfPUiidYuoNCjsXlB6pardwUDC3duHBpTfXgD9mv
         CUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BtVcQdl416qb7s4IbcOizRRojtBfwQY2q+CMmuUPEsI=;
        b=K3x+wdMH880U661QZ1GM/D+qacInvV3uvKk+he5SyxDmmFwBJE5td8FZUCZG20q0b8
         de0wS7kvJzEcl0L9MT4xWH5B4Ee7djXzYGJFd3bTaxKjmx7XWh4hk+pkZHZ6u6Cvzkeh
         l0OJSekpsiSmzdd/A/1oWjyRkG1qg/WzCvkkl3jUceMp2c1X123GitVe8dKWPggfgm4Y
         LtlcC5rLc+Uk1MlksijxvfiDyaWlTAVlrkNZOWp+Q3Rfm04VgIO0PkNNA3Y3JoEZIvwi
         SDaYFuhTqK7QdFdx4K0lzrOWIE8W2z7rjQnLuh7SyIcAU3ehvC0yNNDT5hWpWbC601u8
         Dd8w==
X-Gm-Message-State: ACgBeo2M2bcexZ6Q8hd4CSnZdRWEgSX7syNRZkaudOzU2njWOXN28lhK
        UIgZ5hw/oDOIB1zZDgg9EYk=
X-Google-Smtp-Source: AA6agR44dwd4X5Qy6BOUE7eqSaAT3e8U7sExSR2x3MgA4wDrFfGwNePT26JF4dRQ+knUPvS4ya1gLw==
X-Received: by 2002:a17:90a:ea90:b0:1f2:81cd:1948 with SMTP id h16-20020a17090aea9000b001f281cd1948mr4879296pjz.172.1659108209481;
        Fri, 29 Jul 2022 08:23:29 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:28 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 04/15] bpf: Use bpf_map_area_alloc consistently on bpf map creation
Date:   Fri, 29 Jul 2022 15:23:05 +0000
Message-Id: <20220729152316.58205-5-laoar.shao@gmail.com>
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

Let's use the generic helper bpf_map_area_alloc() instead of the
open-coded kzalloc helpers in bpf maps creation path.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/bpf_local_storage.c |  6 +++---
 kernel/bpf/cpumap.c            |  6 +++---
 kernel/bpf/devmap.c            |  6 +++---
 kernel/bpf/hashtab.c           |  6 +++---
 kernel/bpf/local_storage.c     |  5 ++---
 kernel/bpf/lpm_trie.c          |  4 ++--
 kernel/bpf/ringbuf.c           |  6 +++---
 net/core/sock_map.c            | 12 ++++++------
 8 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 8ce40fd869f6..4ee2e7286c23 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -582,7 +582,7 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 	synchronize_rcu();
 
 	kvfree(smap->buckets);
-	kfree(smap);
+	bpf_map_area_free(smap);
 }
 
 int bpf_local_storage_map_alloc_check(union bpf_attr *attr)
@@ -610,7 +610,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	unsigned int i;
 	u32 nbuckets;
 
-	smap = kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
@@ -623,7 +623,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
 				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
-		kfree(smap);
+		bpf_map_area_free(smap);
 		return ERR_PTR(-ENOMEM);
 	}
 
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b25ca9d603a6..b5ba34ddd4b6 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -97,7 +97,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
-	cmap = kzalloc(sizeof(*cmap), GFP_USER | __GFP_NOWARN |  __GFP_ACCOUNT);
+	cmap = bpf_map_area_alloc(sizeof(*cmap), NUMA_NO_NODE);
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
 
@@ -118,7 +118,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	return &cmap->map;
 free_cmap:
-	kfree(cmap);
+	bpf_map_area_free(cmap);
 	return ERR_PTR(err);
 }
 
@@ -623,7 +623,7 @@ static void cpu_map_free(struct bpf_map *map)
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
 	bpf_map_area_free(cmap->cpu_map);
-	kfree(cmap);
+	bpf_map_area_free(cmap);
 }
 
 /* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 88feaa094de8..f9a87dcc5535 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -163,13 +163,13 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	dtab = kzalloc(sizeof(*dtab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	dtab = bpf_map_area_alloc(sizeof(*dtab), NUMA_NO_NODE);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
 	err = dev_map_init_map(dtab, attr);
 	if (err) {
-		kfree(dtab);
+		bpf_map_area_free(dtab);
 		return ERR_PTR(err);
 	}
 
@@ -240,7 +240,7 @@ static void dev_map_free(struct bpf_map *map)
 		bpf_map_area_free(dtab->netdev_map);
 	}
 
-	kfree(dtab);
+	bpf_map_area_free(dtab);
 }
 
 static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index f1e5303fe26e..8392f7f8a8ac 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -495,7 +495,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	struct bpf_htab *htab;
 	int err, i;
 
-	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -579,7 +579,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	bpf_map_area_free(htab->buckets);
 free_htab:
 	lockdep_unregister_key(&htab->lockdep_key);
-	kfree(htab);
+	bpf_map_area_free(htab);
 	return ERR_PTR(err);
 }
 
@@ -1496,7 +1496,7 @@ static void htab_map_free(struct bpf_map *map)
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
 	lockdep_unregister_key(&htab->lockdep_key);
-	kfree(htab);
+	bpf_map_area_free(htab);
 }
 
 static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index a64255e20f87..098cf336fae6 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -313,8 +313,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
 
-	map = kzalloc_node(sizeof(struct bpf_cgroup_storage_map),
-			   GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT, numa_node);
+	map = bpf_map_area_alloc(sizeof(struct bpf_cgroup_storage_map), numa_node);
 	if (!map)
 		return ERR_PTR(-ENOMEM);
 
@@ -346,7 +345,7 @@ static void cgroup_storage_map_free(struct bpf_map *_map)
 	WARN_ON(!RB_EMPTY_ROOT(&map->root));
 	WARN_ON(!list_empty(&map->list));
 
-	kfree(map);
+	bpf_map_area_free(map);
 }
 
 static int cgroup_storage_delete_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index d789e3b831ad..d833496e9e42 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -558,7 +558,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	    attr->value_size > LPM_VAL_SIZE_MAX)
 		return ERR_PTR(-EINVAL);
 
-	trie = kzalloc(sizeof(*trie), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	trie = bpf_map_area_alloc(sizeof(*trie), NUMA_NO_NODE);
 	if (!trie)
 		return ERR_PTR(-ENOMEM);
 
@@ -609,7 +609,7 @@ static void trie_free(struct bpf_map *map)
 	}
 
 out:
-	kfree(trie);
+	bpf_map_area_free(trie);
 }
 
 static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index df8062cb258c..b483aea35f41 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -164,7 +164,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
 
-	rb_map = kzalloc(sizeof(*rb_map), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	rb_map = bpf_map_area_alloc(sizeof(*rb_map), NUMA_NO_NODE);
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
 
@@ -172,7 +172,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
 	if (!rb_map->rb) {
-		kfree(rb_map);
+		bpf_map_area_free(rb_map);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -199,7 +199,7 @@ static void ringbuf_map_free(struct bpf_map *map)
 
 	rb_map = container_of(map, struct bpf_ringbuf_map, map);
 	bpf_ringbuf_free(rb_map->rb);
-	kfree(rb_map);
+	bpf_map_area_free(rb_map);
 }
 
 static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 763d77162d0c..d0c43384d8bf 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -41,7 +41,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	stab = kzalloc(sizeof(*stab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	stab = bpf_map_area_alloc(sizeof(*stab), NUMA_NO_NODE);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
@@ -52,7 +52,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
-		kfree(stab);
+		bpf_map_area_free(stab);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -361,7 +361,7 @@ static void sock_map_free(struct bpf_map *map)
 	synchronize_rcu();
 
 	bpf_map_area_free(stab->sks);
-	kfree(stab);
+	bpf_map_area_free(stab);
 }
 
 static void sock_map_release_progs(struct bpf_map *map)
@@ -1076,7 +1076,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 	if (attr->key_size > MAX_BPF_STACK)
 		return ERR_PTR(-E2BIG);
 
-	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -1106,7 +1106,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 
 	return &htab->map;
 free_htab:
-	kfree(htab);
+	bpf_map_area_free(htab);
 	return ERR_PTR(err);
 }
 
@@ -1159,7 +1159,7 @@ static void sock_hash_free(struct bpf_map *map)
 	synchronize_rcu();
 
 	bpf_map_area_free(htab->buckets);
-	kfree(htab);
+	bpf_map_area_free(htab);
 }
 
 static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
-- 
2.17.1

