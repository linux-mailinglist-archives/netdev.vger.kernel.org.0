Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8573441189C
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbhITPu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhITPuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:50:50 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17B2C061574;
        Mon, 20 Sep 2021 08:49:22 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q68so17760003pga.9;
        Mon, 20 Sep 2021 08:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLEY0q0GQ36ytZataO/Ltnrmp+MHaUX8/R4Sa9g1JnU=;
        b=bI6+7GFFOdcVQbFBj2offTrqroyvmna9AkgtJx6uw9alggXu+oyxncTYw4dWXcVcqh
         Stlgtiz8A5+DtN0dOEhTORTi6iC7pz8i+WUp3YlmPa8Ie444eQahBgNRuyIKgTHDJzpn
         qRe5xvgAsC+09wgCO97qHMMDsEC5ckKNUauJ4miD3j3eQy4ECC2rY8UhBTTtpyngRYIn
         iDzZtUX/oPub82DJSZZqNaKav6IM2m/5HEL5BpAMJDnvi+dJ8UuFdTUhqcSNEvh6do95
         VO7PUrE/bweL+RTXVMkM0/Spny6oZX8ujBcySfVjyZ9aas6bGMLFCoWEdz3uWfp/UHDg
         jDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLEY0q0GQ36ytZataO/Ltnrmp+MHaUX8/R4Sa9g1JnU=;
        b=ykUKecw/MHqcXYxaCuqMSfov0mt7YcVFaqCQ0kgBO0EX13RCsVabjRsh0kK9vfYwZt
         yR466fh9eGEe41CDjxiLAgmslkC4F8iwOkHJuGPTMqoaorgAdu79AScfOiYIUPDoJrt2
         mcfc2d5w4UDebWGrzIiDrtEP26Di8OGdpqioBy0fXuakdIgvtrGtqfv0VJIvhpx25QEI
         0nG5Bx6ujLmJG6VsxgbQGh6VbgcOZTv682gTutRhZthXY6yi616ewTnit3eKnnfrscxK
         Aab5TL5/YfzR7pB/dfHZSUYEImFyKRH1wYLZQdESJwf3wfebZaSIN19+3GUD83iIGK27
         3AHw==
X-Gm-Message-State: AOAM533jQQQp1vbkHv9c5l7HwKi38ZAxHGtcyWgPQB6zY86nMc3Kuzec
        xl8JX1kLev9kPbPyaeJW/yA=
X-Google-Smtp-Source: ABdhPJy3URQnASeV8LURZeBCnwluXPeiiCH1e30n7vOPDzmBAO77aPYVqExHafravrxNaBP0/SebuQ==
X-Received: by 2002:a05:6a00:a8a:b029:30c:a10b:3e3f with SMTP id b10-20020a056a000a8ab029030ca10b3e3fmr25357425pfl.40.1632152962500;
        Mon, 20 Sep 2021 08:49:22 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id t6sm2391564pfh.63.2021.09.20.08.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 08:49:22 -0700 (PDT)
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     linux-mm@kvack.org
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
Date:   Mon, 20 Sep 2021 15:48:16 +0000
Message-Id: <20210920154816.31832-1-42.hyeyoo@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is RFC v2 of lockless cache on slab, for situation like IO Polling.
It is untested, and just simple proof of concept yet.

So there will be things to improve or erroneous code. (I'm sure of it)
Any opinions or suggestions will be appreciated a lot!

v1 is here:
        https://lore.kernel.org/linux-mm/20210919164239.49905-1-42.hyeyoo@gmail.com/

Changes since v1:
        - It was implemented as separate layer from slab,
                but it is now in slab.
        - Changed linked list to array

Things to think about, or things to work on:
        - Applying limit, batchcount like SLAB
        - I suspect if it does make sence to implment it in SLOB/SLAB.
        - Can we improve it's mechanism depending on SL[AOU]B?
        - Test needed
        - Finding and fixing erroneous code :(
---
 include/linux/slab.h     | 23 ++++++++++++++
 include/linux/slab_def.h |  2 ++
 include/linux/slub_def.h |  1 +
 mm/slab_common.c         | 66 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 083f3ce550bc..091f514dc8e0 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -120,6 +120,9 @@
 /* Slab deactivation flag */
 #define SLAB_DEACTIVATED	((slab_flags_t __force)0x10000000U)
 
+/* use percpu lockless cache */
+#define SLAB_LOCKLESS_CACHE	((slab_flags_t __force)0x20000000U)
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
@@ -327,6 +330,13 @@ enum kmalloc_cache_type {
 	NR_KMALLOC_TYPES
 };
 
+#define KMEM_LOCKLESS_CACHE_QUEUE_SIZE 64
+
+struct kmem_lockless_cache {
+	void *queue[KMEM_LOCKLESS_CACHE_QUEUE_SIZE];
+	unsigned int size;
+};
+
 #ifndef CONFIG_SLOB
 extern struct kmem_cache *
 kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
@@ -429,6 +439,19 @@ void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags) __assume_slab_alignment __malloc;
 void kmem_cache_free(struct kmem_cache *, void *);
 
+#ifndef CONFIG_SLOB
+
+void *kmem_cache_alloc_cached(struct kmem_cache *s, gfp_t gfpflags);
+void kmem_cache_free_cached(struct kmem_cache *s, void *p);
+
+#else
+
+#define kmem_cache_alloc_cached kmem_cache_alloc
+#define kmem_cache_free_cached kmem_cache_free
+
+#endif /* CONFIG_SLOB */
+
+
 /*
  * Bulk allocation and freeing operations. These are accelerated in an
  * allocator specific way to avoid taking locks repeatedly or building
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 3aa5e1e73ab6..9f3161f38a8a 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -85,6 +85,8 @@ struct kmem_cache {
 	unsigned int usersize;		/* Usercopy region size */
 
 	struct kmem_cache_node *node[MAX_NUMNODES];
+
+	struct kmem_lockless_cache __percpu *cache; /* percpu lockless cache */
 };
 
 static inline void *nearest_obj(struct kmem_cache *cache, struct page *page,
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 85499f0586b0..1dc3527efba8 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -96,6 +96,7 @@ struct kmem_cache {
 	unsigned int object_size;/* The size of an object without metadata */
 	struct reciprocal_value reciprocal_size;
 	unsigned int offset;	/* Free pointer offset */
+	struct kmem_lockless_cache __percpu *cache; /* percpu lockless cache */
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	/* Number of per cpu partial objects to keep around */
 	unsigned int cpu_partial;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index ec2bb0beed75..5b8e4d5a644d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -262,6 +262,13 @@ static struct kmem_cache *create_cache(const char *name,
 	s->useroffset = useroffset;
 	s->usersize = usersize;
 
+	if (flags & SLAB_LOCKLESS_CACHE) {
+		s->cache = alloc_percpu(struct kmem_lockless_cache);
+		if (!s->cache)
+			goto out_free_cache;
+		s->cache->size = 0;
+	}
+
 	err = __kmem_cache_create(s, flags);
 	if (err)
 		goto out_free_cache;
@@ -424,6 +431,57 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
+/**
+ * kmem_cache_alloc_cached - try to allocate from cache without lock
+ * @s: slab cache
+ * @flags: SLAB flags
+ *
+ * Try to allocate from cache without lock. If fails, fill the lockless cache
+ * using bulk alloc API
+ *
+ * Be sure that there's no race condition.
+ * Must create slab cache with SLAB_LOCKLESS_CACHE flag to use this function.
+ *
+ * Return: a pointer to free object on allocation success, NULL on failure.
+ */
+void *kmem_cache_alloc_cached(struct kmem_cache *s, gfp_t gfpflags)
+{
+	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
+
+	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
+
+	if (cache->size) /* fastpath without lock */
+		return cache->queue[--cache->size];
+
+	/* slowpath */
+	cache->size = kmem_cache_alloc_bulk(s, gfpflags,
+			KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);
+	if (cache->size)
+		return cache->queue[--cache->size];
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(kmem_cache_alloc_cached);
+
+/**
+ * kmem_cache_free_cached - return object to cache
+ * @s: slab cache
+ * @p: pointer to free
+ */
+void kmem_cache_free_cached(struct kmem_cache *s, void *p)
+{
+	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
+
+	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
+
+	/* Is there better way to do this? */
+	if (cache->size == KMEM_LOCKLESS_CACHE_QUEUE_SIZE)
+		kmem_cache_free(s, cache->queue[--cache->size]);
+
+	cache->queue[cache->size++] = p;
+}
+EXPORT_SYMBOL(kmem_cache_free_cached);
+
 static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
 {
 	LIST_HEAD(to_destroy);
@@ -460,6 +518,8 @@ static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
 
 static int shutdown_cache(struct kmem_cache *s)
 {
+	struct kmem_lockless_cache *cache;
+
 	/* free asan quarantined objects */
 	kasan_cache_shutdown(s);
 
@@ -468,6 +528,12 @@ static int shutdown_cache(struct kmem_cache *s)
 
 	list_del(&s->list);
 
+	if (s->flags & SLAB_LOCKLESS_CACHE) {
+		cache = this_cpu_ptr(s->cache);
+		kmem_cache_free_bulk(s, cache->size, cache->queue);
+		free_percpu(s->cache);
+	}
+
 	if (s->flags & SLAB_TYPESAFE_BY_RCU) {
 #ifdef SLAB_SUPPORTS_SYSFS
 		sysfs_slab_unlink(s);
-- 
2.27.0

