Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8468A5C0500
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiIURAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiIURAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:32 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4F53B5;
        Wed, 21 Sep 2022 10:00:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j6-20020a17090a694600b00200bba67dadso6526082pjm.5;
        Wed, 21 Sep 2022 10:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gba3u0+gd94mB6GmfPdadjDps/EFMbhme8baw/BzKk0=;
        b=eWDIZ3rFab2okkRLajKM5mxi8K6wMkkS84fi9NRdZCYncHKadFI1wpoWOZHwSuU0SK
         p+iaWwWdjR/bQtukKkpUcmpO9XbTRmNduklhIpBL40Kxs9yMpkE0pBcKSCR1amGLvOpq
         9egmfQUOrGMJQ29NSGMv1RrH46RO3w+aFQvFs0wv62z90Yr0WlesxS5tEMkH7/VyIMmw
         Wo04CFfnI+a+iYXt5W8MgC6gcw8sV2FmjQ2Ub7/DXPixGt/6GKHtRExemrlo9RbObcml
         RkcTaTt7hy83mKnbvK/XHsXEwgkk5i+125gADjKkLhjT0MjRqyIg2IBayiGHLOOx6m4B
         eaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=gba3u0+gd94mB6GmfPdadjDps/EFMbhme8baw/BzKk0=;
        b=i0FrOPjEjJKKoWbZSVBImfDBMvsG2mBd87XLyFxjNtgi4Sn5BdVy8Qbdx7GzETBrP4
         uklXAZrMjS6I7SUNck7a/iF7IYUJi9BytgWGRE3GB7gyxT3yfMoszNlG+0NM18AqyoM6
         t1P6Q8tnl84T42btiQkPUmbWaRUa6PsAWleKJGnH1KdvmTpuWnjEKhepBr53gGWUtGF8
         gYKt8bFpU7r/4MNxMcYBGzues6vpqic+bZ2k2KMzlvGxn/fGIwrS/w7PdkXTWAJbeFfc
         N/vCHRRADMW2twnYyJW6yq7rRpwMR3y3lNKKtT8jKgh9DWhiIJ1eEDIYvBunoPAWWDxZ
         QBaQ==
X-Gm-Message-State: ACrzQf3ZVygWryCOpXBTPURfcXLIIXTb6TtDF55w80rLQnljzIXcMbcf
        usHyY4SSe9vx8kRMhFCsiOc=
X-Google-Smtp-Source: AMsMyM5UUh5UGXfBN7hdQyZZoZIfKCCpq9e3N25yua41v8owfxVZSErG70KBKf17D7b1lz68CI8HQg==
X-Received: by 2002:a17:90a:1b0a:b0:203:6731:4c98 with SMTP id q10-20020a17090a1b0a00b0020367314c98mr10340586pjq.10.1663779627393;
        Wed, 21 Sep 2022 10:00:27 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:26 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 09/10] bpf: Add bpf map free helpers
Date:   Wed, 21 Sep 2022 17:00:01 +0000
Message-Id: <20220921170002.29557-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220921170002.29557-1-laoar.shao@gmail.com>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
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

Some new helpers are introduced to allocate memory, instead of using the
general free helpers. Then we can do something in these new helpers to
track the free of bpf memory in the future.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            | 24 ++++++++++++++++++++++++
 kernel/bpf/arraymap.c          |  4 ++--
 kernel/bpf/bpf_local_storage.c | 10 +++++-----
 kernel/bpf/cpumap.c            | 13 ++++++-------
 kernel/bpf/devmap.c            | 10 ++++++----
 kernel/bpf/hashtab.c           |  2 +-
 kernel/bpf/helpers.c           |  2 +-
 kernel/bpf/local_storage.c     | 10 +++++-----
 kernel/bpf/lpm_trie.c          |  2 +-
 kernel/bpf/ringbuf.c           |  7 ++++++-
 kernel/bpf/syscall.c           | 14 ++++++++++++++
 net/xdp/xskmap.c               |  2 +-
 12 files changed, 72 insertions(+), 28 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e1e5ada..f7a4cfc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1721,6 +1721,12 @@ void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
 		       gfp_t flags);
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
+void bpf_map_kfree(const void *ptr);
+void bpf_map_kvfree(const void *ptr);
+void bpf_map_free_percpu(void __percpu *ptr);
+
+#define bpf_map_kfree_rcu(ptr, rhf...) kvfree_rcu(ptr, ## rhf)
+
 #else
 static inline void *
 bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
@@ -1747,6 +1753,24 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 {
 	return __alloc_percpu_gfp(size, align, flags);
 }
+
+static inline void bpf_map_kfree(const void *ptr)
+{
+	kfree(ptr);
+}
+
+static inline void bpf_map_kvfree(const void *ptr)
+{
+	kvfree(ptr);
+}
+
+static inline void bpf_map_free_percpu(void __percpu *ptr)
+{
+	free_percpu(ptr);
+}
+
+#define bpf_map_kfree_rcu(ptr, rhf...) kvfree_rcu(ptr, ## rhf)
+
 #endif
 
 extern int sysctl_unprivileged_bpf_disabled;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 7f1766c..9bdb99d 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -24,7 +24,7 @@ static void bpf_array_free_percpu(struct bpf_array *array)
 	int i;
 
 	for (i = 0; i < array->map.max_entries; i++) {
-		free_percpu(array->pptrs[i]);
+		bpf_map_free_percpu(array->pptrs[i]);
 		cond_resched();
 	}
 }
@@ -1141,7 +1141,7 @@ static void prog_array_map_free(struct bpf_map *map)
 		list_del_init(&elem->list);
 		kfree(elem);
 	}
-	kfree(aux);
+	bpf_map_kfree(aux);
 	fd_array_map_free(map);
 }
 
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 8a24828..6ef49aa 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -89,7 +89,7 @@ void bpf_local_storage_free_rcu(struct rcu_head *rcu)
 	struct bpf_local_storage *local_storage;
 
 	local_storage = container_of(rcu, struct bpf_local_storage, rcu);
-	kfree_rcu(local_storage, rcu);
+	bpf_map_kfree_rcu(local_storage, rcu);
 }
 
 static void bpf_selem_free_rcu(struct rcu_head *rcu)
@@ -97,7 +97,7 @@ static void bpf_selem_free_rcu(struct rcu_head *rcu)
 	struct bpf_local_storage_elem *selem;
 
 	selem = container_of(rcu, struct bpf_local_storage_elem, rcu);
-	kfree_rcu(selem, rcu);
+	bpf_map_kfree_rcu(selem, rcu);
 }
 
 /* local_storage->lock must be held and selem->local_storage == local_storage.
@@ -153,7 +153,7 @@ bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
 	if (use_trace_rcu)
 		call_rcu_tasks_trace(&selem->rcu, bpf_selem_free_rcu);
 	else
-		kfree_rcu(selem, rcu);
+		bpf_map_kfree_rcu(selem, rcu);
 
 	return free_local_storage;
 }
@@ -348,7 +348,7 @@ int bpf_local_storage_alloc(void *owner,
 	return 0;
 
 uncharge:
-	kfree(storage);
+	bpf_map_kfree(storage);
 	mem_uncharge(smap, owner, sizeof(*storage));
 	return err;
 }
@@ -581,7 +581,7 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 	 */
 	synchronize_rcu();
 
-	kvfree(smap->buckets);
+	bpf_map_kvfree(smap->buckets);
 	bpf_map_area_free(smap, &smap->map);
 }
 
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b593157..5ee774e 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -166,8 +166,8 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
 		/* The queue should be empty at this point */
 		__cpu_map_ring_cleanup(rcpu->queue);
 		ptr_ring_cleanup(rcpu->queue, NULL);
-		kfree(rcpu->queue);
-		kfree(rcpu);
+		bpf_map_kfree(rcpu->queue);
+		bpf_map_kfree(rcpu);
 	}
 }
 
@@ -486,11 +486,11 @@ static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu,
 free_ptr_ring:
 	ptr_ring_cleanup(rcpu->queue, NULL);
 free_queue:
-	kfree(rcpu->queue);
+	bpf_map_kfree(rcpu->queue);
 free_bulkq:
-	free_percpu(rcpu->bulkq);
+	bpf_map_free_percpu(rcpu->bulkq);
 free_rcu:
-	kfree(rcpu);
+	bpf_map_kfree(rcpu);
 	return NULL;
 }
 
@@ -504,8 +504,7 @@ static void __cpu_map_entry_free(struct rcu_head *rcu)
 	 * find this entry.
 	 */
 	rcpu = container_of(rcu, struct bpf_cpu_map_entry, rcu);
-
-	free_percpu(rcpu->bulkq);
+	bpf_map_free_percpu(rcpu->bulkq);
 	/* Cannot kthread_stop() here, last put free rcpu resources */
 	put_cpu_map_entry(rcpu);
 }
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 807a4cd..38bd7be 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -220,7 +220,7 @@ static void dev_map_free(struct bpf_map *map)
 				if (dev->xdp_prog)
 					bpf_prog_put(dev->xdp_prog);
 				dev_put(dev->dev);
-				kfree(dev);
+				bpf_map_kfree(dev);
 			}
 		}
 
@@ -236,7 +236,7 @@ static void dev_map_free(struct bpf_map *map)
 			if (dev->xdp_prog)
 				bpf_prog_put(dev->xdp_prog);
 			dev_put(dev->dev);
-			kfree(dev);
+			bpf_map_kfree(dev);
 		}
 
 		bpf_map_area_free(dtab->netdev_map, NULL);
@@ -793,12 +793,14 @@ static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key)
 static void __dev_map_entry_free(struct rcu_head *rcu)
 {
 	struct bpf_dtab_netdev *dev;
+	struct bpf_dtab *dtab;
 
 	dev = container_of(rcu, struct bpf_dtab_netdev, rcu);
 	if (dev->xdp_prog)
 		bpf_prog_put(dev->xdp_prog);
 	dev_put(dev->dev);
-	kfree(dev);
+	dtab = dev->dtab;
+	bpf_map_kfree(dev);
 }
 
 static int dev_map_delete_elem(struct bpf_map *map, void *key)
@@ -883,7 +885,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 err_put_dev:
 	dev_put(dev->dev);
 err_out:
-	kfree(dev);
+	bpf_map_kfree(dev);
 	return ERR_PTR(-EINVAL);
 }
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 89887df..7f43371 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1562,7 +1562,7 @@ static void htab_map_free(struct bpf_map *map)
 	}
 
 	bpf_map_free_kptr_off_tab(map);
-	free_percpu(htab->extra_elems);
+	bpf_map_free_percpu(htab->extra_elems);
 	bpf_map_area_free(htab->buckets, NULL);
 	bpf_mem_alloc_destroy(&htab->pcpu_ma);
 	bpf_mem_alloc_destroy(&htab->ma);
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 41aeaf3..fd0549b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1366,7 +1366,7 @@ void bpf_timer_cancel_and_free(void *val)
 	 */
 	if (this_cpu_read(hrtimer_running) != t)
 		hrtimer_cancel(&t->timer);
-	kfree(t);
+	bpf_map_kfree(t);
 }
 
 BPF_CALL_2(bpf_kptr_xchg, void *, map_value, void *, ptr)
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index fcc7ece..035ef9e 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -174,7 +174,7 @@ static int cgroup_storage_update_elem(struct bpf_map *map, void *key,
 	check_and_init_map_value(map, new->data);
 
 	new = xchg(&storage->buf, new);
-	kfree_rcu(new, rcu);
+	bpf_map_kfree_rcu(new, rcu);
 
 	return 0;
 }
@@ -526,7 +526,7 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(struct bpf_prog *prog,
 	return storage;
 
 enomem:
-	kfree(storage);
+	bpf_map_kfree(storage);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -535,8 +535,8 @@ static void free_shared_cgroup_storage_rcu(struct rcu_head *rcu)
 	struct bpf_cgroup_storage *storage =
 		container_of(rcu, struct bpf_cgroup_storage, rcu);
 
-	kfree(storage->buf);
-	kfree(storage);
+	bpf_map_kfree(storage->buf);
+	bpf_map_kfree(storage);
 }
 
 static void free_percpu_cgroup_storage_rcu(struct rcu_head *rcu)
@@ -545,7 +545,7 @@ static void free_percpu_cgroup_storage_rcu(struct rcu_head *rcu)
 		container_of(rcu, struct bpf_cgroup_storage, rcu);
 
 	free_percpu(storage->percpu_buf);
-	kfree(storage);
+	bpf_map_kfree(storage);
 }
 
 void bpf_cgroup_storage_free(struct bpf_cgroup_storage *storage)
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 3d329ae..815e5d4 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -602,7 +602,7 @@ static void trie_free(struct bpf_map *map)
 				continue;
 			}
 
-			kfree(node);
+			bpf_map_kfree(node);
 			RCU_INIT_POINTER(*slot, NULL);
 			break;
 		}
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 1e7284c..535e440 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -59,12 +59,17 @@ struct bpf_ringbuf_hdr {
 	u32 pg_off;
 };
 
+static inline void bpf_map_free_page(struct page *page)
+{
+	__free_page(page);
+}
+
 static void bpf_ringbuf_pages_free(struct page **pages, int nr_pages)
 {
 	int i;
 
 	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
+		bpf_map_free_page(pages[i]);
 	bpf_map_area_free(pages, NULL);
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6123c71..b9250c8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -519,6 +519,20 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	return ptr;
 }
 
+void bpf_map_kfree(const void *ptr)
+{
+	kfree(ptr);
+}
+
+void bpf_map_kvfree(const void *ptr)
+{
+	kvfree(ptr);
+}
+
+void bpf_map_free_percpu(void __percpu *ptr)
+{
+	free_percpu(ptr);
+}
 #endif
 
 static int bpf_map_kptr_off_cmp(const void *a, const void *b)
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index beb11fd..e9d93b8 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -33,7 +33,7 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
 static void xsk_map_node_free(struct xsk_map_node *node)
 {
 	bpf_map_put(&node->map->map);
-	kfree(node);
+	bpf_map_kfree(node);
 }
 
 static void xsk_map_sock_add(struct xdp_sock *xs, struct xsk_map_node *node)
-- 
1.8.3.1

