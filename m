Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D2728A3CE
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389877AbgJJWzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbgJJTxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:53:13 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B3EC0613E0
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 03:39:20 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id i2so9451539pgh.7
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 03:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u0rkVm7C5Ne19ttZslnktIRDYT2Kn1UpPsAG5EcqOzk=;
        b=nldkqHE8cd6nALAOIPmeXXa4lxSehpssrliInfwNUW6Hb+5AQUJqdY1lIPTMQ6GhSC
         bNzY2yFALQ55yAPmV5/4OpkoS7Qxwcj/YUT5Oj5i9lNzl9jecn4rrsC7JXX9l2e74ImO
         cJrwW3fD48Oz0BKuJkv+BX5P4MtW/5+lC59ohp8iD3SZuNoyFMebf73oGrnKCE0Yvu3A
         XOgUEFfxab3XYcCK8qOUOXalHYT5GixnEluc7WjZJUD1eYMRtoTU89QqQsf9E0GIIZ9q
         qB9nij5cQMCDcDus00QS4NHfq/KCsRWHwombRIrYkQPhxQSNvOqD8XT1glRLgL7P399O
         Eq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u0rkVm7C5Ne19ttZslnktIRDYT2Kn1UpPsAG5EcqOzk=;
        b=trNuwDQ9ujGFGkui1y8Waay/gl8VOPfAw3/fMRNlkfzDPFWDUl1AzhrS+1WASLdknF
         bdLm+Jam0UNiLeNnqqp8sUT8pgu2SDefqpy+E5A9eytG1sK6lai4z4D0RmOISQD5NMwj
         cSEukIqeX6oBxBtqtB7TXfPsyffVwmmDvopu+qdUVIh9/ZawVqwmz0pEhjK5NhDgYp+w
         8X/g5kQu78WRMFvwRhWUoTYTWYMxIwPePiIhNFYVum0oGBxe5iSlU3dKdUXbuiu8S8k3
         gMmU2vc12l/XXBJjH5s2arvqR31jyTYedSCET/pEBdabOc9cEvafZ/LURwwafCXTVDMK
         bT0g==
X-Gm-Message-State: AOAM531u3ZAUGzdPl9nw5d+5i8eQ40KjeX+7OLqswVshz7ZcsnN4sL/K
        TI56ALlt6j/74Sk1ar7DVsGM2Q==
X-Google-Smtp-Source: ABdhPJxZnwM7IyP5/gKorplHLzpJGDDwce8ks6RVhogeGwaAYPaE9QFMriDfyYZjDuze5VAmX/L0QA==
X-Received: by 2002:a63:e:: with SMTP id 14mr6928456pga.426.1602326359642;
        Sat, 10 Oct 2020 03:39:19 -0700 (PDT)
Received: from Smcdef-MBP.local.net ([103.136.220.73])
        by smtp.gmail.com with ESMTPSA id v3sm1450830pfu.165.2020.10.10.03.39.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Oct 2020 03:39:18 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     gregkh@linuxfoundation.org, rafael@kernel.org, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        adobriyan@gmail.com, akpm@linux-foundation.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        shakeelb@google.com, will@kernel.org, mhocko@suse.com, guro@fb.com,
        neilb@suse.de, rppt@kernel.org, songmuchun@bytedance.com,
        samitolvanen@google.com, kirill.shutemov@linux.intel.com,
        feng.tang@intel.com, pabeni@redhat.com, willemb@google.com,
        rdunlap@infradead.org, fw@strlen.de, gustavoars@kernel.org,
        pablo@netfilter.org, decui@microsoft.com, jakub@cloudflare.com,
        peterz@infradead.org, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, tglx@linutronix.de, dave@stgolabs.net,
        walken@google.com, jannh@google.com, chenqiwu@xiaomi.com,
        christophe.leroy@c-s.fr, minchan@kernel.org, kafai@fb.com,
        ast@kernel.org, daniel@iogearbox.net, linmiaohe@huawei.com,
        keescook@chromium.org
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: proc: add Sock to /proc/meminfo
Date:   Sat, 10 Oct 2020 18:38:54 +0800
Message-Id: <20201010103854.66746-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The amount of memory allocated to sockets buffer can become significant.
However, we do not display the amount of memory consumed by sockets
buffer. In this case, knowing where the memory is consumed by the kernel
is very difficult. On our server with 500GB RAM, sometimes we can see
25GB disappear through /proc/meminfo. After our analysis, we found the
following memory allocation path which consumes the memory with page_owner
enabled.

  849698 times:
  Page allocated via order 3, mask 0x4052c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP)
   __alloc_pages_nodemask+0x11d/0x290
   skb_page_frag_refill+0x68/0xf0
   sk_page_frag_refill+0x19/0x70
   tcp_sendmsg_locked+0x2f4/0xd10
   tcp_sendmsg+0x29/0xa0
   sock_sendmsg+0x30/0x40
   sock_write_iter+0x8f/0x100
   __vfs_write+0x10b/0x190
   vfs_write+0xb0/0x190
   ksys_write+0x5a/0xd0
   do_syscall_64+0x5d/0x110
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/base/node.c      |  2 ++
 drivers/net/virtio_net.c |  3 +--
 fs/proc/meminfo.c        |  1 +
 include/linux/mmzone.h   |  1 +
 include/linux/skbuff.h   | 43 ++++++++++++++++++++++++++++++++++++++--
 kernel/exit.c            |  3 +--
 mm/page_alloc.c          |  7 +++++--
 mm/vmstat.c              |  1 +
 net/core/sock.c          |  8 ++++----
 net/ipv4/tcp.c           |  3 +--
 net/xfrm/xfrm_state.c    |  3 +--
 11 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 508b80f6329b..6f92775da85c 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -418,6 +418,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 #ifdef CONFIG_SHADOW_CALL_STACK
 		       "Node %d ShadowCallStack:%8lu kB\n"
 #endif
+		       "Node %d Sock:           %8lu kB\n"
 		       "Node %d PageTables:     %8lu kB\n"
 		       "Node %d NFS_Unstable:   %8lu kB\n"
 		       "Node %d Bounce:         %8lu kB\n"
@@ -441,6 +442,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
 		       nid, K(i.sharedram),
 		       nid, node_page_state(pgdat, NR_KERNEL_STACK_KB),
+		       nid, K(node_page_state(pgdat, NR_SOCK)),
 #ifdef CONFIG_SHADOW_CALL_STACK
 		       nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 263b005981bd..e7183f67ae4a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2646,8 +2646,7 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 {
 	int i;
 	for (i = 0; i < vi->max_queue_pairs; i++)
-		if (vi->rq[i].alloc_frag.page)
-			put_page(vi->rq[i].alloc_frag.page);
+		put_page_frag(&vi->rq[i].alloc_frag);
 }
 
 static void free_unused_bufs(struct virtnet_info *vi)
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 887a5532e449..1dcf3120d831 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -106,6 +106,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "ShadowCallStack:%8lu kB\n",
 		   global_node_page_state(NR_KERNEL_SCS_KB));
 #endif
+	show_val_kb(m, "Sock:           ", global_node_page_state(NR_SOCK));
 	show_val_kb(m, "PageTables:     ",
 		    global_zone_page_state(NR_PAGETABLE));
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 31712bb61f7f..1996713d2c6b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -207,6 +207,7 @@ enum node_stat_item {
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
+	NR_SOCK,                /* Count of socket buffer pages */
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fcd53f97c186..7e5108da4d84 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -19,7 +19,8 @@
 #include <linux/rbtree.h>
 #include <linux/socket.h>
 #include <linux/refcount.h>
-
+#include <linux/memcontrol.h>
+#include <linux/mm.h>
 #include <linux/atomic.h>
 #include <asm/types.h>
 #include <linux/spinlock.h>
@@ -3003,6 +3004,25 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 	__skb_frag_ref(&skb_shinfo(skb)->frags[f]);
 }
 
+static inline void inc_sock_node_page_state(struct page *page)
+{
+	mod_node_page_state(page_pgdat(page), NR_SOCK, compound_nr(page));
+	/*
+	 * Indicate that we need to decrease the Sock page state when
+	 * the page freed.
+	 */
+	SetPagePrivate(page);
+}
+
+static inline void dec_sock_node_page_state(struct page *page)
+{
+	if (PagePrivate(page)) {
+		ClearPagePrivate(page);
+		mod_node_page_state(page_pgdat(page), NR_SOCK,
+				    -compound_nr(page));
+	}
+}
+
 /**
  * __skb_frag_unref - release a reference on a paged fragment.
  * @frag: the paged fragment
@@ -3011,7 +3031,12 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
  */
 static inline void __skb_frag_unref(skb_frag_t *frag)
 {
-	put_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+	if (put_page_testzero(page)) {
+		dec_sock_node_page_state(page);
+		__put_page(page);
+	}
 }
 
 /**
@@ -3091,6 +3116,20 @@ static inline void skb_frag_set_page(struct sk_buff *skb, int f,
 	__skb_frag_set_page(&skb_shinfo(skb)->frags[f], page);
 }
 
+static inline bool put_page_frag(struct page_frag *pfrag)
+{
+	struct page *page = pfrag->page;
+
+	if (page) {
+		if (put_page_testzero(page)) {
+			dec_sock_node_page_state(page);
+			__put_page(page);
+		}
+		return true;
+	}
+	return false;
+}
+
 bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio);
 
 /**
diff --git a/kernel/exit.c b/kernel/exit.c
index 62912406d74a..58d373767d16 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -841,8 +841,7 @@ void __noreturn do_exit(long code)
 	if (tsk->splice_pipe)
 		free_pipe_info(tsk->splice_pipe);
 
-	if (tsk->task_frag.page)
-		put_page(tsk->task_frag.page);
+	put_page_frag(&tsk->task_frag);
 
 	validate_creds_for_do_exit(tsk);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cefbef32bf4a..6c543158aa06 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5379,7 +5379,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		" unevictable:%lu dirty:%lu writeback:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
-		" free:%lu free_pcp:%lu free_cma:%lu\n",
+		" free:%lu free_pcp:%lu free_cma:%lu sock:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
 		global_node_page_state(NR_INACTIVE_ANON),
 		global_node_page_state(NR_ISOLATED_ANON),
@@ -5397,7 +5397,8 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		global_zone_page_state(NR_BOUNCE),
 		global_zone_page_state(NR_FREE_PAGES),
 		free_pcp,
-		global_zone_page_state(NR_FREE_CMA_PAGES));
+		global_zone_page_state(NR_FREE_CMA_PAGES),
+		global_node_page_state(NR_SOCK));
 
 	for_each_online_pgdat(pgdat) {
 		if (show_mem_node_skip(filter, pgdat->node_id, nodemask))
@@ -5425,6 +5426,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 #ifdef CONFIG_SHADOW_CALL_STACK
 			" shadow_call_stack:%lukB"
 #endif
+			" sock:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -5450,6 +5452,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 #ifdef CONFIG_SHADOW_CALL_STACK
 			node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
+			K(node_page_state(pgdat, NR_SOCK)),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b05dec387557..ceaf6f85c155 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1220,6 +1220,7 @@ const char * const vmstat_text[] = {
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	"nr_shadow_call_stack",
 #endif
+	"nr_sock",
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
diff --git a/net/core/sock.c b/net/core/sock.c
index 5972d26f03ae..1661b423802b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1780,10 +1780,8 @@ static void __sk_destruct(struct rcu_head *head)
 		pr_debug("%s: optmem leakage (%d bytes) detected\n",
 			 __func__, atomic_read(&sk->sk_omem_alloc));
 
-	if (sk->sk_frag.page) {
-		put_page(sk->sk_frag.page);
+	if (put_page_frag(&sk->sk_frag))
 		sk->sk_frag.page = NULL;
-	}
 
 	if (sk->sk_peer_cred)
 		put_cred(sk->sk_peer_cred);
@@ -2456,7 +2454,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 		}
 		if (pfrag->offset + sz <= pfrag->size)
 			return true;
-		put_page(pfrag->page);
+		put_page_frag(pfrag);
 	}
 
 	pfrag->offset = 0;
@@ -2469,12 +2467,14 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 					  SKB_FRAG_PAGE_ORDER);
 		if (likely(pfrag->page)) {
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
+			inc_sock_node_page_state(pfrag->page);
 			return true;
 		}
 	}
 	pfrag->page = alloc_page(gfp);
 	if (likely(pfrag->page)) {
 		pfrag->size = PAGE_SIZE;
+		inc_sock_node_page_state(pfrag->page);
 		return true;
 	}
 	return false;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 57a568875539..583761844b4f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2751,8 +2751,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 	WARN_ON(inet->inet_num && !icsk->icsk_bind_hash);
 
-	if (sk->sk_frag.page) {
-		put_page(sk->sk_frag.page);
+	if (put_page_frag(&sk->sk_frag)) {
 		sk->sk_frag.page = NULL;
 		sk->sk_frag.offset = 0;
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 69520ad3d83b..0f7c16679e49 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -495,8 +495,7 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
 	}
-	if (x->xfrag.page)
-		put_page(x->xfrag.page);
+	put_page_frag(&x->xfrag);
 	xfrm_dev_state_free(x);
 	security_xfrm_state_free(x);
 	xfrm_state_free(x);
-- 
2.20.1

