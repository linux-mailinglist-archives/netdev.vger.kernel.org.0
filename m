Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23CB5C0504
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiIURA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiIURAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:33 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D5350731;
        Wed, 21 Sep 2022 10:00:30 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p18so6270031plr.8;
        Wed, 21 Sep 2022 10:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rEuCWbdgrwwGiHAb+CkeCueJvfR5xkIo+Y2V08UZ+0Q=;
        b=C4bm40YB8V9wdtklRrCCiR3gKKqr4vT5mv+UmGw/unek0Cdvuigja/P7Dp+MQyi3bU
         gfKt7ChIFsbYGzX5ZdSVeqZZVSQ7PTVpBH69eT2f4oTlkFr/rRL5wWCz03IITuIIYVDw
         p7zkKTB/REpasj9icnRE32zK+VZ0/7UwK89KL1Hl9OGSmIvQox7MHLRt7kIuexgcOsrK
         GF4ehGltq1jy1DXXRAumQoCHZ4mKYidr13NRBPxtpKdKZR2isS6nNpRqNvRlGtPErT6G
         cMsoSA0CBK9xcE1ug+J5uZCXVB6uQQN2165ppcDwMTtweS2RbDZH+emKAgKy2KdF98Yo
         cLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rEuCWbdgrwwGiHAb+CkeCueJvfR5xkIo+Y2V08UZ+0Q=;
        b=EPB5K61u6C2hB/iddb3a/vyFAgkx1C2q9eilDGQ5nDavcdRsXymwwJBVwXmmAlCyYa
         yRbb8D6P5c904FWr7eph4n/O/zpRcC9coJ+wKWWdhv3peCw1VS/aTxD3p/0adD0tPDoD
         zTZcWxJGRE86iHk10togcY0Rsdz7d5ni84P4n+zGEH+lDoizgGXnw7Or9CXKJYaqOUZ5
         2EXAS7tVbQFD84Dc+jqJjwvGZmZzyJXZjenxG/hmwZ4uu5KBTlqP2Zw8w0ZmLcCDpuca
         WgSU6qnQFeSgMeJR6nJhwsYrqAxGi8JPlPm7RUWNq6QBGFEnfb5p1Pr2buaRLnxZGpFW
         9t9Q==
X-Gm-Message-State: ACrzQf1GM4alGcBh1hoHHjW+WkjnxnQ8JHWlSSqPh8BJ4hkeM8fGBAYq
        fV86AY5qLRtfu9CA7bgmUcw=
X-Google-Smtp-Source: AMsMyM68wv7b1uQ8Tbun+mu+bNwKV5sJPRgpzJPJbjzgAjhhr9RWZmRnD6jART9e8Z6VQ+pZZnmQtg==
X-Received: by 2002:a17:90b:3b92:b0:203:a4c6:383c with SMTP id pc18-20020a17090b3b9200b00203a4c6383cmr10353340pjb.92.1663779629464;
        Wed, 21 Sep 2022 10:00:29 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:28 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 10/10] bpf, memcg: Add new item bpf into memory.stat
Date:   Wed, 21 Sep 2022 17:00:02 +0000
Message-Id: <20220921170002.29557-11-laoar.shao@gmail.com>
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

A new item 'bpf' is introduced into memory.stat, then we can get the memory
consumed by bpf. Currently only the memory of bpf-map is accounted.
The accouting of this new item is implemented with scope-based accouting,
which is similar to set_active_memcg(). In this scope, the memory allocated
will be accounted or unaccounted to a specific item, which is specified by
set_active_memcg_item().

The result in cgroup v1 as follows,
	$ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
	bpf 109056000
	total_bpf 109056000
After the map is removed, the counter will become zero again.
        $ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
        bpf 0
        total_bpf 0

The 'bpf' may not be 0 after the bpf-map is destroyed, because there may be
cached objects.

Note that there's no kmemcg in root memory cgroup, so the item 'bpf' will
be always 0 in root memory cgroup. If a bpf-map is charged into root memcg
directly, its memory size will not be accounted, so the 'total_bpf' can't
be used to monitor system-wide bpf memory consumption yet.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h        | 10 ++++++++--
 include/linux/memcontrol.h |  1 +
 include/linux/sched.h      |  1 +
 include/linux/sched/mm.h   | 24 ++++++++++++++++++++++++
 kernel/bpf/memalloc.c      | 10 ++++++++++
 kernel/bpf/ringbuf.c       |  4 ++++
 kernel/bpf/syscall.c       | 40 ++++++++++++++++++++++++++++++++++++++--
 kernel/fork.c              |  1 +
 mm/memcontrol.c            | 20 ++++++++++++++++++++
 9 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f7a4cfc..9eda143 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1725,7 +1725,13 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 void bpf_map_kvfree(const void *ptr);
 void bpf_map_free_percpu(void __percpu *ptr);
 
-#define bpf_map_kfree_rcu(ptr, rhf...) kvfree_rcu(ptr, ## rhf)
+#define bpf_map_kfree_rcu(ptr, rhf...)	{		\
+	int old_item;					\
+							\
+	old_item = set_active_memcg_item(MEMCG_BPF);	\
+	kvfree_rcu(ptr, ## rhf);			\
+	set_active_memcg_item(old_item);		\
+}
 
 #else
 static inline void *
@@ -1771,7 +1777,7 @@ static inline void bpf_map_free_percpu(void __percpu *ptr)
 
 #define bpf_map_kfree_rcu(ptr, rhf...) kvfree_rcu(ptr, ## rhf)
 
-#endif
+#endif /* CONFIG_MEMCG_KMEM */
 
 extern int sysctl_unprivileged_bpf_disabled;
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d4a0ad3..f345467 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -37,6 +37,7 @@ enum memcg_stat_item {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_BPF,
 	MEMCG_NR_STAT,
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e7b2f8a..79362da 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1423,6 +1423,7 @@ struct task_struct {
 
 	/* Used by memcontrol for targeted memcg charge: */
 	struct mem_cgroup		*active_memcg;
+	int						active_item;
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 2a24361..3a334c7 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -363,6 +363,7 @@ static inline void memalloc_pin_restore(unsigned int flags)
 
 #ifdef CONFIG_MEMCG
 DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
+DECLARE_PER_CPU(int, int_active_item);
 /**
  * set_active_memcg - Starts the remote memcg charging scope.
  * @memcg: memcg to charge.
@@ -389,12 +390,35 @@ static inline void memalloc_pin_restore(unsigned int flags)
 
 	return old;
 }
+
+static inline int
+set_active_memcg_item(int item)
+{
+	int old_item;
+
+	if (!in_task()) {
+		old_item = this_cpu_read(int_active_item);
+		this_cpu_write(int_active_item, item);
+	} else {
+		old_item = current->active_item;
+		current->active_item = item;
+	}
+
+	return old_item;
+}
+
 #else
 static inline struct mem_cgroup *
 set_active_memcg(struct mem_cgroup *memcg)
 {
 	return NULL;
 }
+
+static inline int
+set_active_memcg_item(int item)
+{
+	return MEMCG_NR_STAT;
+}
 #endif
 
 #ifdef CONFIG_MEMBARRIER
diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 5f83be1..51d59d4 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -165,11 +165,14 @@ static void alloc_bulk(struct bpf_mem_cache *c, int cnt, int node)
 {
 	struct mem_cgroup *memcg = NULL, *old_memcg;
 	unsigned long flags;
+	int old_item;
 	void *obj;
 	int i;
 
 	memcg = get_memcg(c);
 	old_memcg = set_active_memcg(memcg);
+	old_item = set_active_memcg_item(MEMCG_BPF);
+
 	for (i = 0; i < cnt; i++) {
 		obj = __alloc(c, node);
 		if (!obj)
@@ -194,19 +197,26 @@ static void alloc_bulk(struct bpf_mem_cache *c, int cnt, int node)
 		if (IS_ENABLED(CONFIG_PREEMPT_RT))
 			local_irq_restore(flags);
 	}
+
+	set_active_memcg_item(old_item);
 	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);
 }
 
 static void free_one(struct bpf_mem_cache *c, void *obj)
 {
+	int old_item;
+
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	if (c->percpu_size) {
 		free_percpu(((void **)obj)[1]);
 		kfree(obj);
+		set_active_memcg_item(old_item);
 		return;
 	}
 
 	kfree(obj);
+	set_active_memcg_item(old_item);
 }
 
 static void __free_rcu(struct rcu_head *head)
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 535e440..72435bd 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -61,7 +61,11 @@ struct bpf_ringbuf_hdr {
 
 static inline void bpf_map_free_page(struct page *page)
 {
+	int old_item;
+
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	__free_page(page);
+	set_active_memcg_item(old_item);
 }
 
 static void bpf_ringbuf_pages_free(struct page **pages, int nr_pages)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b9250c8..703aa6a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -340,11 +340,14 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 	const gfp_t gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
 	unsigned int flags = 0;
 	unsigned long align = 1;
+	int old_item;
 	void *area;
+	void *ptr;
 
 	if (size >= SIZE_MAX)
 		return NULL;
 
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	/* kmalloc()'ed memory can't be mmap()'ed */
 	if (mmapable) {
 		BUG_ON(!PAGE_ALIGNED(size));
@@ -353,13 +356,18 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 	} else if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
 		area = kmalloc_node(size, gfp | GFP_USER | __GFP_NORETRY,
 				    numa_node);
-		if (area != NULL)
+		if (area != NULL) {
+			set_active_memcg_item(old_item);
 			return area;
+		}
 	}
 
-	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
+	ptr = __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
 			gfp | GFP_KERNEL | __GFP_RETRY_MAYFAIL, PAGE_KERNEL,
 			flags, numa_node, __builtin_return_address(0));
+
+	set_active_memcg_item(old_item);
+	return ptr;
 }
 
 void *bpf_map_area_alloc(u64 size, int numa_node, struct bpf_map *map)
@@ -386,9 +394,13 @@ void *bpf_map_area_mmapable_alloc(u64 size, int numa_node)
 
 void bpf_map_area_free(void *area, struct bpf_map *map)
 {
+	int old_item;
+
 	if (map)
 		bpf_map_release_memcg(map);
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	kvfree(area);
+	set_active_memcg_item(old_item);
 }
 
 static u32 bpf_map_flags_retain_permanent(u32 flags)
@@ -464,11 +476,14 @@ void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
 	struct mem_cgroup *memcg, *old_memcg;
+	int old_item;
 	void *ptr;
 
 	memcg = bpf_map_get_memcg(map);
 	old_memcg = set_active_memcg(memcg);
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	ptr = kmalloc_node(size, flags | __GFP_ACCOUNT, node);
+	set_active_memcg_item(old_item);
 	set_active_memcg(old_memcg);
 	bpf_map_put_memcg(memcg);
 
@@ -479,10 +494,13 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 {
 	struct mem_cgroup *memcg, *old_memcg;
 	void *ptr;
+	int old_item;
 
 	memcg = bpf_map_get_memcg(map);
 	old_memcg = set_active_memcg(memcg);
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	ptr = kzalloc(size, flags | __GFP_ACCOUNT);
+	set_active_memcg_item(old_item);
 	set_active_memcg(old_memcg);
 	bpf_map_put_memcg(memcg);
 
@@ -494,11 +512,14 @@ void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
 {
 	struct mem_cgroup *memcg, *old_memcg;
 	void *ptr;
+	int old_item;
 
 	memcg = bpf_map_get_memcg(map);
 	old_memcg = set_active_memcg(memcg);
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	ptr = kvcalloc(n, size, flags | __GFP_ACCOUNT);
 	set_active_memcg(old_memcg);
+	set_active_memcg_item(old_item);
 	bpf_map_put_memcg(memcg);
 
 	return ptr;
@@ -509,10 +530,13 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 {
 	struct mem_cgroup *memcg, *old_memcg;
 	void __percpu *ptr;
+	int old_item;
 
 	memcg = bpf_map_get_memcg(map);
 	old_memcg = set_active_memcg(memcg);
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	ptr = __alloc_percpu_gfp(size, align, flags | __GFP_ACCOUNT);
+	set_active_memcg_item(old_item);
 	set_active_memcg(old_memcg);
 	bpf_map_put_memcg(memcg);
 
@@ -521,17 +545,29 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 
 void bpf_map_kfree(const void *ptr)
 {
+	int old_item;
+
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	kfree(ptr);
+	set_active_memcg_item(old_item);
 }
 
 void bpf_map_kvfree(const void *ptr)
 {
+	int old_item;
+
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	kvfree(ptr);
+	set_active_memcg_item(old_item);
 }
 
 void bpf_map_free_percpu(void __percpu *ptr)
 {
+	int old_item;
+
+	old_item = set_active_memcg_item(MEMCG_BPF);
 	free_percpu(ptr);
+	set_active_memcg_item(old_item);
 }
 #endif
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 90c85b1..dac2429 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1043,6 +1043,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 
 #ifdef CONFIG_MEMCG
 	tsk->active_memcg = NULL;
+	tsk->active_item = 0;
 #endif
 
 #ifdef CONFIG_CPU_SUP_INTEL
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c..9008417 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -82,6 +82,10 @@
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
 
+/* Active memory cgroup to use from an interrupt context */
+DEFINE_PER_CPU(int, int_active_item);
+EXPORT_PER_CPU_SYMBOL_GPL(int_active_item);
+
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket __ro_after_init;
 
@@ -923,6 +927,14 @@ static __always_inline struct mem_cgroup *active_memcg(void)
 		return current->active_memcg;
 }
 
+static __always_inline int active_memcg_item(void)
+{
+	if (!in_task())
+		return this_cpu_read(int_active_item);
+
+	return current->active_item;
+}
+
 /**
  * get_mem_cgroup_from_mm: Obtain a reference on given mm_struct's memcg.
  * @mm: mm from which memcg should be extracted. It can be NULL.
@@ -1436,6 +1448,7 @@ struct memory_stat {
 	{ "workingset_restore_anon",	WORKINGSET_RESTORE_ANON		},
 	{ "workingset_restore_file",	WORKINGSET_RESTORE_FILE		},
 	{ "workingset_nodereclaim",	WORKINGSET_NODERECLAIM		},
+	{ "bpf",					MEMCG_BPF			},
 };
 
 /* Translate stat items to the correct unit for memory.stat output */
@@ -2993,6 +3006,11 @@ struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
 
 static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
 {
+	int item = active_memcg_item();
+
+	WARN_ON_ONCE(item != 0 && (item < MEMCG_SWAP || item >= MEMCG_NR_STAT));
+	if (item)
+		mod_memcg_state(memcg, item, nr_pages);
 	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		if (nr_pages > 0)
@@ -3976,6 +3994,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
 	MEMCG_SWAP,
+	MEMCG_BPF,
 };
 
 static const char *const memcg1_stat_names[] = {
@@ -3989,6 +4008,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	"dirty",
 	"writeback",
 	"swap",
+	"bpf",
 };
 
 /* Universal VM events cgroup1 shows, original sort order */
-- 
1.8.3.1

