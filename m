Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7780F32778D
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 07:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhCAG0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 01:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhCAGZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 01:25:53 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405C0C0617A9
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:25:05 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l18so11041676pji.3
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ScywHubPCL6mfstg+EZNBBsmr5n/XLhbKlBOnoSWD+4=;
        b=UvFK2RYFvMGJVieWRz6EEiAEkFFy1AuuU+HfcqWKDo+F6EiwDPNX+770wZRay8HF2w
         2lGPh1WGEsUC3TyiVsBDqFFXbIUktipAYtsUx0ZTj4MapTihLiryU3bDNQmzXl3ArW2G
         7j2f10KmaRnl/I1zahSdLOswaH40DSKTjOYWYT+6G7fEHXdGfnKUSF62wAYMTc5Jiy2Y
         2wcW4cv3U8VRbUpLmQukb2zk6Jg/hwXE8GN+Y78qjbuP86wLz18jHBXtV9qVyYBUhi+7
         QmZodSw52kDaeZ8NGtVZBjn5x6VxbKX64g4xjlsdD5PI1ppKS3ot+9uA2/o+Bm77Ja3C
         wh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ScywHubPCL6mfstg+EZNBBsmr5n/XLhbKlBOnoSWD+4=;
        b=T+VKS4JFPQBliKyxqYFGQg6ldo2lFILFTs6/3qMuhVst2MrjsfqyrnIgDSIpvPzp6H
         +i8nBxs70TuNehTMIJDcEMgCWyeG1p+APKzFVvdD0Qfa1nVw7YiZgM98jBYqS2OBwRn9
         FCBaTImjFH8YH1JAt/eW9B6LUKDa5Ko3BLMxofbxKpKiEaeICH3R2/MviIK5XeqGvXBA
         KWbfTO55mAGJwneFUxm6ws7Cidq37ijsxX6dFb+ihfGgaMl9Lyuhp7FvUDWa3pfLbF5k
         xjY/hKmOCr8GFU31IP12uKsSSBacXo5/8IP1f376d8zf116ZLdmv3s0+RbpU+pT+1SU0
         Yy6g==
X-Gm-Message-State: AOAM531GkGab1Y9BDMDxCerrF4i8fw7I7NrNh7OeeLThQ4hHIH88AnFr
        RKWPuecFEJIMuza+JJtwyecyhQ==
X-Google-Smtp-Source: ABdhPJzl0qMjxF8cjfvOsSElT8t+wiNNqf2AIAekXqR7esLsVA1FS5nXOo9w3dsZVIA37VchS9oTtA==
X-Received: by 2002:a17:902:c94f:b029:e4:59a3:2915 with SMTP id i15-20020a170902c94fb02900e459a32915mr14080565pla.9.1614579904758;
        Sun, 28 Feb 2021 22:25:04 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id x6sm14304626pfd.12.2021.02.28.22.24.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2021 22:25:04 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     viro@zeniv.linux.org.uk, jack@suse.cz, amir73il@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        shakeelb@google.com, guro@fb.com, songmuchun@bytedance.com,
        alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        chris@chrisdown.name, richard.weiyang@gmail.com, vbabka@suse.cz,
        mathieu.desnoyers@efficios.com, posk@google.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, daniel.vetter@ffwll.ch, longman@redhat.com,
        walken@google.com, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, keescook@chromium.org,
        krisman@collabora.com, esyr@redhat.com, surenb@google.com,
        elver@google.com
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        duanxiongchun@bytedance.com
Subject: [PATCH 2/5] mm: memcontrol: make page_memcg{_rcu} only applicable for non-kmem page
Date:   Mon,  1 Mar 2021 14:22:24 +0800
Message-Id: <20210301062227.59292-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210301062227.59292-1-songmuchun@bytedance.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to reuse the obj_cgroup APIs to reparent the kmem pages when
the memcg offlined. If we do this, we should store an object cgroup
pointer to page->memcg_data for the kmem pages.

Finally, page->memcg_data can have 3 different meanings.

  1) For the slab pages, page->memcg_data points to an object cgroups
     vector.

  2) For the kmem pages (exclude the slab pages), page->memcg_data
     points to an object cgroup.

  3) For the user pages (e.g. the LRU pages), page->memcg_data points
     to a memory cgroup.

Currently we always get the memcg associated with a page via page_memcg
or page_memcg_rcu. page_memcg_check is special, it has to be used in
cases when it's not known if a page has an associated memory cgroup
pointer or an object cgroups vector. Because the page->memcg_data of
the kmem page is not pointing to a memory cgroup in the later patch,
the page_memcg and page_memcg_rcu cannot be applicable for the kmem
pages. In this patch, we introduce page_memcg_kmem to get the memcg
associated with the kmem pages. And make page_memcg and page_memcg_rcu
no longer apply to the kmem pages.

In the end, there are 4 helpers to get the memcg associated with a
page. The usage is as follows.

  1) Get the memory cgroup associated with a non-kmem page (e.g. the LRU
     pages).

     - page_memcg()
     - page_memcg_rcu()

  2) Get the memory cgroup associated with a kmem page (exclude the slab
     pages).

     - page_memcg_kmem()

  3) Get the memory cgroup associated with a page. It has to be used in
     cases when it's not known if a page has an associated memory cgroup
     pointer or an object cgroups vector. Returns NULL for slab pages or
     uncharged pages, otherwise, returns memory cgroup for charged pages
     (e.g. kmem pages, LRU pages).

     - page_memcg_check()

In some place, we use page_memcg to check whether the page is charged.
Now we introduce page_memcg_charged helper to do this.

This is a preparation for reparenting the kmem pages. To support reparent
kmem pages, we just need to adjust page_memcg_kmem and page_memcg_check in
the later patch.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memcontrol.h | 56 +++++++++++++++++++++++++++++++++++++++-------
 mm/memcontrol.c            | 23 ++++++++++---------
 mm/page_alloc.c            |  4 ++--
 3 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e6dc793d587d..1d2c82464c8c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -358,14 +358,46 @@ enum page_memcg_data_flags {
 
 #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
 
+/* Return true for charged page, otherwise false. */
+static inline bool page_memcg_charged(struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+
+	return !!memcg_data;
+}
+
 /*
- * page_memcg - get the memory cgroup associated with a page
+ * page_memcg_kmem - get the memory cgroup associated with a kmem page.
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the kmem page,
+ * or NULL. This function assumes that the page is known to have a proper
+ * memory cgroup pointer. It is only suitable for kmem pages which means
+ * PageMemcgKmem() returns true for this page.
+ */
+static inline struct mem_cgroup *page_memcg_kmem(struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+	VM_BUG_ON_PAGE(!(memcg_data & MEMCG_DATA_KMEM), page);
+
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
+
+/*
+ * page_memcg - get the memory cgroup associated with a non-kmem page
  * @page: a pointer to the page struct
  *
  * Returns a pointer to the memory cgroup associated with the page,
  * or NULL. This function assumes that the page is known to have a
  * proper memory cgroup pointer. It's not safe to call this function
- * against some type of pages, e.g. slab pages or ex-slab pages.
+ * against some type of pages, e.g. slab pages, kmem pages or ex-slab
+ * pages.
  *
  * Any of the following ensures page and memcg binding stability:
  * - the page lock
@@ -378,27 +410,30 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
 	unsigned long memcg_data = page->memcg_data;
 
 	VM_BUG_ON_PAGE(PageSlab(page), page);
-	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_FLAGS_MASK, page);
 
-	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	return (struct mem_cgroup *)memcg_data;
 }
 
 /*
- * page_memcg_rcu - locklessly get the memory cgroup associated with a page
+ * page_memcg_rcu - locklessly get the memory cgroup associated with a non-kmem page
  * @page: a pointer to the page struct
  *
  * Returns a pointer to the memory cgroup associated with the page,
  * or NULL. This function assumes that the page is known to have a
  * proper memory cgroup pointer. It's not safe to call this function
- * against some type of pages, e.g. slab pages or ex-slab pages.
+ * against some type of pages, e.g. slab pages, kmem pages or ex-slab
+ * pages.
  */
 static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
 {
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
 	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_FLAGS_MASK, page);
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	return (struct mem_cgroup *)(READ_ONCE(page->memcg_data) &
-				     ~MEMCG_DATA_FLAGS_MASK);
+	return (struct mem_cgroup *)memcg_data;
 }
 
 /*
@@ -1072,6 +1107,11 @@ void mem_cgroup_split_huge_fixup(struct page *head);
 
 struct mem_cgroup;
 
+static inline bool page_memcg_charged(struct page *page)
+{
+	return false;
+}
+
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return NULL;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2eafbae504ac..bfd6efe1e196 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -855,10 +855,11 @@ void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
 			     int val)
 {
 	struct page *head = compound_head(page); /* rmap on tail pages */
-	struct mem_cgroup *memcg = page_memcg(head);
+	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
+	memcg = PageMemcgKmem(head) ? page_memcg_kmem(head) : page_memcg(head);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
@@ -3170,12 +3171,13 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct mem_cgroup *memcg = page_memcg(page);
+	struct mem_cgroup *memcg;
 	unsigned int nr_pages = 1 << order;
 
-	if (!memcg)
+	if (!page_memcg_charged(page))
 		return;
 
+	memcg = page_memcg_kmem(page);
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 	__memcg_kmem_uncharge(memcg, nr_pages);
 	page->memcg_data = 0;
@@ -6831,24 +6833,25 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 {
 	unsigned long nr_pages;
+	struct mem_cgroup *memcg;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	if (!page_memcg(page))
+	if (!page_memcg_charged(page))
 		return;
 
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * page_memcg(page) at this point, we have fully
-	 * exclusive access to the page.
+	 * page memcg at this point, we have fully exclusive
+	 * access to the page.
 	 */
-
-	if (ug->memcg != page_memcg(page)) {
+	memcg = PageMemcgKmem(page) ? page_memcg_kmem(page) : page_memcg(page);
+	if (ug->memcg != memcg) {
 		if (ug->memcg) {
 			uncharge_batch(ug);
 			uncharge_gather_clear(ug);
 		}
-		ug->memcg = page_memcg(page);
+		ug->memcg = memcg;
 
 		/* pairs with css_put in uncharge_batch */
 		css_get(&ug->memcg->css);
@@ -6881,7 +6884,7 @@ void mem_cgroup_uncharge(struct page *page)
 		return;
 
 	/* Don't touch page->lru of any random page, pre-check: */
-	if (!page_memcg(page))
+	if (!page_memcg_charged(page))
 		return;
 
 	uncharge_gather_clear(&ug);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f10966e3b4a5..bcb58ae15e24 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1124,7 +1124,7 @@ static inline bool page_expected_state(struct page *page,
 	if (unlikely((unsigned long)page->mapping |
 			page_ref_count(page) |
 #ifdef CONFIG_MEMCG
-			(unsigned long)page_memcg(page) |
+			page_memcg_charged(page) |
 #endif
 			(page->flags & check_flags)))
 		return false;
@@ -1149,7 +1149,7 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 			bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 	}
 #ifdef CONFIG_MEMCG
-	if (unlikely(page_memcg(page)))
+	if (unlikely(page_memcg_charged(page)))
 		bad_reason = "page still charged to cgroup";
 #endif
 	return bad_reason;
-- 
2.11.0

