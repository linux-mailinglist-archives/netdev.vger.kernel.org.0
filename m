Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0AE6C0499
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCST6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCST61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:58:27 -0400
Received: from mail-wm1-x362.google.com (mail-wm1-x362.google.com [IPv6:2a00:1450:4864:20::362])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D647517CE7
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:58:23 -0700 (PDT)
Received: by mail-wm1-x362.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso6307005wmo.0
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1679255902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abRcz3XMi0GgKPQl9NoVpoEpO1DCAm+/vastKVGPdUM=;
        b=jUeGxuoKEis7X6tM3d2k70zt8CX2tQeCjh/bigA346Ii1D2JB3y2LuXRZTjXAn17gq
         BO2zqG8SA+yMFtrZyEPQ3oWK6qWa5z+5K7g5BPpMppOyXtTtGSBqJME8DQ02dth+LqKw
         1LS+ZHrXZb0wL5eJxXFktjU7m/7wlYu9IAQy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679255902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=abRcz3XMi0GgKPQl9NoVpoEpO1DCAm+/vastKVGPdUM=;
        b=DThaav1l/59ogFTGlUi6YjD4gzSYExQUSMx9P9bBJnE3A/XPBEHHOt8WeWDViTt9bn
         uGo91HE7GI1EcKtYkjYtJMUqlNDAv3mRs8mWay7pW4UfOtQ7eRZgz8J2PjxOkO6jsDkt
         kHpGvKrpYRuCztUewx1XjPZEpQghrrv67Pl7HZwYT7ea8a4nnMtGgta/vuFh+cMj4Fg8
         Bq9MQIWDqNOQFBiybwTknEo3f+1c5GA3w449ZFzouttv8Gkv+50jSN8wVadQQ+WwdrSw
         mdDycmdEGffWjkJBzMNotKUwR2lvGZUFMXsherGxlO5l9ij14AoB2jGNJFTDlLHEz3Od
         1VTQ==
X-Gm-Message-State: AO0yUKVfbG1JoQ1R21o4UVdiAytXr+Yovu976s1SYdwzIEeg22uMCRly
        lURq+L9dVeLkht3IHtXLcflotvFuKN1JVp8jGxEiXCKx+Fdz
X-Google-Smtp-Source: AK7set/DN9xxUEx5wEgzB7dwur7/S25REoP2WaWGDAHuCDp+6bZ/rEzWCMCwSgPpfv13XqVbadwWRr+ebyoO
X-Received: by 2002:a05:600c:a49:b0:3ed:2dc4:c6cb with SMTP id c9-20020a05600c0a4900b003ed2dc4c6cbmr18877086wmq.6.1679255902150;
        Sun, 19 Mar 2023 12:58:22 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id m26-20020a7bca5a000000b003b499f88f52sm2728807wml.7.2023.03.19.12.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:58:22 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Sun, 19 Mar 2023 20:56:54 +0100
Message-Id: <20230319195656.326701-2-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319195656.326701-1-kal.conley@dectris.com>
References: <20230319195656.326701-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
enables sending/receiving jumbo ethernet frames up to the theoretical
maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
XDP_COPY mode is usuable pending future driver work.

For consistency, check for HugeTLB pages during UMEM registration. This
implies that hugepages are required for XDP_COPY mode despite DMA not
being used. This restriction is desirable since it ensures user software
can take advantage of future driver support.

Even in HugeTLB mode, continue to do page accounting using order-0
(4 KiB) pages. This minimizes the size of this change and reduces the
risk of impacting driver code. Taking full advantage of hugepages for
accounting should improve XDP performance in the general case.

No significant change in RX/TX performance was observed with this patch.
A few data points are reproduced below:

Machine : Dell PowerEdge R940
CPU     : Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GHz
NIC     : MT27700 Family [ConnectX-4]

+-----+------------+-------------+---------------+
|     | frame size | packet size | rxdrop (Mpps) |
+-----+------------+-------------+---------------+
| old |       4000 |         320 |          15.7 |
| new |       4000 |         320 |          15.8 |
+-----+------------+-------------+---------------+
| old |       4096 |         320 |          16.4 |
| new |       4096 |         320 |          16.3 |
+-----+------------+-------------+---------------+
| new |       9000 |         320 |           6.3 |
| new |      10240 |        9000 |           0.4 |
+-----+------------+-------------+---------------+

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 include/net/xdp_sock.h      |  1 +
 include/net/xdp_sock_drv.h  |  6 +++++
 include/net/xsk_buff_pool.h |  4 +++-
 net/xdp/xdp_umem.c          | 46 +++++++++++++++++++++++++++++--------
 net/xdp/xsk.c               |  3 +++
 net/xdp/xsk_buff_pool.c     | 16 +++++++++----
 6 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 3057e1a4a11c..e562ac3f5295 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -28,6 +28,7 @@ struct xdp_umem {
 	struct user_struct *user;
 	refcount_t users;
 	u8 flags;
+	bool hugetlb;
 	bool zc;
 	struct page **pgs;
 	int id;
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 9c0d860609ba..eb630d17f994 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -12,6 +12,12 @@
 #define XDP_UMEM_MIN_CHUNK_SHIFT 11
 #define XDP_UMEM_MIN_CHUNK_SIZE (1 << XDP_UMEM_MIN_CHUNK_SHIFT)
 
+/* Allow chunk sizes up to the maximum size of an ethernet frame (64 KiB).
+ * Larger chunks are not guaranteed to fit in a single SKB.
+ */
+#define XDP_UMEM_MAX_CHUNK_SHIFT 16
+#define XDP_UMEM_MAX_CHUNK_SIZE (1 << XDP_UMEM_MAX_CHUNK_SHIFT)
+
 #ifdef CONFIG_XDP_SOCKETS
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 3e952e569418..69e3970da092 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -78,6 +78,7 @@ struct xsk_buff_pool {
 	u8 cached_need_wakeup;
 	bool uses_need_wakeup;
 	bool dma_need_sync;
+	bool hugetlb;
 	bool unaligned;
 	void *addrs;
 	/* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
@@ -175,7 +176,8 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
 static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 						 u64 addr, u32 len)
 {
-	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
+	bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
+					(addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
 
 	if (likely(!cross_pg))
 		return false;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 02207e852d79..c96eefb9f5ae 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -10,6 +10,7 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/bpf.h>
+#include <linux/hugetlb_inline.h>
 #include <linux/mm.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
@@ -19,6 +20,9 @@
 #include "xdp_umem.h"
 #include "xsk_queue.h"
 
+_Static_assert(XDP_UMEM_MIN_CHUNK_SIZE <= PAGE_SIZE);
+_Static_assert(XDP_UMEM_MAX_CHUNK_SIZE <= HPAGE_SIZE);
+
 static DEFINE_IDA(umem_ida);
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
@@ -91,7 +95,26 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
 	}
 }
 
-static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
+/* Returns true if the UMEM contains HugeTLB pages exclusively, false otherwise.
+ *
+ * The mmap_lock must be held by the caller.
+ */
+static bool xdp_umem_is_hugetlb(struct xdp_umem *umem, unsigned long address)
+{
+	unsigned long end = address + umem->npgs * PAGE_SIZE;
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	vma_iter_init(&vmi, current->mm, address);
+	for_each_vma_range(vmi, vma, end) {
+		if (!is_vm_hugetlb_page(vma))
+			return false;
+	}
+
+	return true;
+}
+
+static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address, bool hugetlb)
 {
 	unsigned int gup_flags = FOLL_WRITE;
 	long npgs;
@@ -102,8 +125,17 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 		return -ENOMEM;
 
 	mmap_read_lock(current->mm);
+
+	umem->hugetlb = IS_ALIGNED(address, HPAGE_SIZE) && xdp_umem_is_hugetlb(umem, address);
+	if (hugetlb && !umem->hugetlb) {
+		mmap_read_unlock(current->mm);
+		err = -EINVAL;
+		goto out_pgs;
+	}
+
 	npgs = pin_user_pages(address, umem->npgs,
 			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
+
 	mmap_read_unlock(current->mm);
 
 	if (npgs != umem->npgs) {
@@ -152,20 +184,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
 	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
+	bool hugetlb = chunk_size > PAGE_SIZE;
 	u64 addr = mr->addr, size = mr->len;
 	u32 chunks_rem, npgs_rem;
 	u64 chunks, npgs;
 	int err;
 
-	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
-		/* Strictly speaking we could support this, if:
-		 * - huge pages, or*
-		 * - using an IOMMU, or
-		 * - making sure the memory area is consecutive
-		 * but for now, we simply say "computer says no".
-		 */
+	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > XDP_UMEM_MAX_CHUNK_SIZE)
 		return -EINVAL;
-	}
 
 	if (mr->flags & ~XDP_UMEM_UNALIGNED_CHUNK_FLAG)
 		return -EINVAL;
@@ -215,7 +241,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (err)
 		return err;
 
-	err = xdp_umem_pin_pages(umem, (unsigned long)addr);
+	err = xdp_umem_pin_pages(umem, (unsigned long)addr, hugetlb);
 	if (err)
 		goto out_account;
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2ac58b282b5e..3899a2d235bb 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -421,6 +421,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
+/* Chunks must fit in the SKB `frags` array. */
+_Static_assert(XDP_UMEM_MAX_CHUNK_SIZE / PAGE_SIZE <= MAX_SKB_FRAGS);
+
 static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 					      struct xdp_desc *desc)
 {
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index b2df1e0f8153..777e8a38a232 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -80,6 +80,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	pool->headroom = umem->headroom;
 	pool->chunk_size = umem->chunk_size;
 	pool->chunk_shift = ffs(umem->chunk_size) - 1;
+	pool->hugetlb = umem->hugetlb;
 	pool->unaligned = unaligned;
 	pool->frame_len = umem->chunk_size - umem->headroom -
 		XDP_PACKET_HEADROOM;
@@ -369,16 +370,23 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 }
 EXPORT_SYMBOL(xp_dma_unmap);
 
-static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
+/* HugeTLB pools consider contiguity at hugepage granularity only. Hence, all
+ * order-0 pages within a hugepage have the same contiguity value.
+ */
+static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, bool hugetlb)
 {
+	u32 page_size = hugetlb ? HPAGE_SIZE : PAGE_SIZE;
+	u32 n = page_size >> PAGE_SHIFT;
 	u32 i;
 
-	for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
-		if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
+	for (i = 0; i + n < dma_map->dma_pages_cnt; i++) {
+		if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + n])
 			dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
 		else
 			dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
 	}
+	for (; i < dma_map->dma_pages_cnt; i++)
+		dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
 }
 
 static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
@@ -441,7 +449,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	}
 
 	if (pool->unaligned)
-		xp_check_dma_contiguity(dma_map);
+		xp_check_dma_contiguity(dma_map, pool->hugetlb);
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {
-- 
2.39.2

