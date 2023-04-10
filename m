Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E49F6DC68C
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjDJMIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjDJMIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:08:01 -0400
Received: from mail-ej1-x661.google.com (mail-ej1-x661.google.com [IPv6:2a00:1450:4864:20::661])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40F31B9
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:57 -0700 (PDT)
Received: by mail-ej1-x661.google.com with SMTP id jg21so11666469ejc.2
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681128476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDAF8WMn0EHau/Mrm2W/kgQFuy2qo2bCncqXZQ/aUqU=;
        b=XPsHHqjU/TR5cXAaaOGwiyxb7GkfOPiNtdqpF/SjXxrYrqGIRfvZm9gNKrpzz+W6ac
         lLCBIcLij/cUVBcBdCeS6QQPFYWF4dOEIgDGp3XE1ztj0rLQwvzTNA1sYbA32A/5DdGt
         uEWZMvv5kYIvwvSmTe1sN53Vsyq+fiYsWZb2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681128476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jDAF8WMn0EHau/Mrm2W/kgQFuy2qo2bCncqXZQ/aUqU=;
        b=moLIfvi+JWLRAAstfKyCEsuoP8EOfGZT5pajfBL4ReQk7l7eTJJKa135dpiwDTLrYf
         3cPR+MUmxqK8hljK3kZZYagdebRzekNfSKCyNd8PQ3qTDSLSS0Q/nbZxWh0kriVzTvU/
         4LwPWJWZkbIxSAp+kTk5JB+DG/IpvjDYr5+vnUIPrWI8vkq/+R7O2sqZ+DB74OBBHq/b
         TesJRkbnnz/Le2YHaq/EQ+yGqvZ2h3zTvTdIldMH/owaF1kajwRIkNmswdeBsAH1HMrt
         h1y5sMQ7HlBNk59dQhhMcrcLncWLaKznmrI7KpzR4AJ8tGIgjAOIAjQmI4vBRbV+UQgQ
         J9fQ==
X-Gm-Message-State: AAQBX9ddo5Mi4AY6ep7BeMsX5uZBd8QsQbmeEuwQ0cRmbg/fuU0BlksG
        lknaKhbnkYdG4gsrhTiXrMH5UJUTmnpY2pkhwAgGClNFavox
X-Google-Smtp-Source: AKy350Ygry15jXKw8wZG3UgpEA3qvKXhkNoqufhYjR+gaI6mXQZU1er9/kiixHCFNJTMju1sD6xxuQ3JK+zK
X-Received: by 2002:a17:906:7196:b0:94c:25f7:7324 with SMTP id h22-20020a170906719600b0094c25f77324mr640860ejk.44.1681128476290;
        Mon, 10 Apr 2023 05:07:56 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id nb39-20020a1709071ca700b008b1fc5abd08sm2089769ejc.56.2023.04.10.05.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 05:07:56 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 2/4] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Mon, 10 Apr 2023 14:06:27 +0200
Message-Id: <20230410120629.642955-3-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230410120629.642955-1-kal.conley@dectris.com>
References: <20230410120629.642955-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
enables sending/receiving jumbo ethernet frames up to the theoretical
maximum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
SKB mode is usable pending future driver work.

For consistency, check for HugeTLB pages during UMEM registration. This
implies that hugepages are required for XDP_COPY mode despite DMA not
being used. This restriction is desirable since it ensures user software
can take advantage of future driver support.

Despite this change, always store order-0 pages in the umem->pgs array
since this is what is returned by pin_user_pages(). Conversely, XSK
pools bound to HugeTLB UMEMs do DMA page accounting at hugepage
granularity (HPAGE_SIZE).

No significant change in RX/TX performance was observed with this patch.
A few data points are reproduced below:

Machine : Dell PowerEdge R940
CPU     : Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GHz
NIC     : MT27700 Family [ConnectX-4]

+-----+------+------+-------+--------+--------+--------+
|     |      |      | chunk | packet | rxdrop | rxdrop |
|     | mode |  mtu |  size |   size | (Mpps) | (Gbps) |
+-----+------+------+-------+--------+--------+--------+
| old |   -z | 3498 |  4000 |    320 |   15.9 |   40.8 |
| new |   -z | 3498 |  4000 |    320 |   15.9 |   40.8 |
+-----+------+------+-------+--------+--------+--------+
| old |   -z | 3498 |  4096 |    320 |   16.5 |   42.2 |
| new |   -z | 3498 |  4096 |    320 |   16.5 |   42.3 |
+-----+------+------+-------+--------+--------+--------+
| new |   -c | 3498 | 10240 |    320 |    6.1 |   15.7 |
+-----+------+------+-------+--------+--------+--------+
| new |   -S | 9000 | 10240 |   9000 |   0.37 |   26.4 |
+-----+------+------+-------+--------+--------+--------+

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 Documentation/networking/af_xdp.rst | 36 +++++++++++--------
 include/net/xdp_sock.h              |  2 ++
 include/net/xdp_sock_drv.h          | 12 +++++++
 include/net/xsk_buff_pool.h         | 10 +++---
 net/xdp/xdp_umem.c                  | 55 +++++++++++++++++++++++------
 net/xdp/xsk_buff_pool.c             | 36 +++++++++++--------
 6 files changed, 109 insertions(+), 42 deletions(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 247c6c4127e9..ea65cd882af6 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -105,12 +105,13 @@ with AF_XDP". It can be found at https://lwn.net/Articles/750845/.
 UMEM
 ----
 
-UMEM is a region of virtual contiguous memory, divided into
-equal-sized frames. An UMEM is associated to a netdev and a specific
-queue id of that netdev. It is created and configured (chunk size,
-headroom, start address and size) by using the XDP_UMEM_REG setsockopt
-system call. A UMEM is bound to a netdev and queue id, via the bind()
-system call.
+UMEM is a region of virtual contiguous memory divided into equal-sized
+frames. This is the area that contains all the buffers that packets can
+reside in. A UMEM is associated with a netdev and a specific queue id of
+that netdev. It is created and configured (start address, size,
+chunk size, and headroom) by using the XDP_UMEM_REG setsockopt system
+call. A UMEM is bound to a netdev and queue id via the bind() system
+call.
 
 An AF_XDP is socket linked to a single UMEM, but one UMEM can have
 multiple AF_XDP sockets. To share an UMEM created via one socket A,
@@ -418,14 +419,21 @@ negatively impact performance.
 XDP_UMEM_REG setsockopt
 -----------------------
 
-This setsockopt registers a UMEM to a socket. This is the area that
-contain all the buffers that packet can reside in. The call takes a
-pointer to the beginning of this area and the size of it. Moreover, it
-also has parameter called chunk_size that is the size that the UMEM is
-divided into. It can only be 2K or 4K at the moment. If you have an
-UMEM area that is 128K and a chunk size of 2K, this means that you
-will be able to hold a maximum of 128K / 2K = 64 packets in your UMEM
-area and that your largest packet size can be 2K.
+This setsockopt registers a UMEM to a socket. The call takes a pointer
+to the beginning of this area and the size of it. Moreover, there is a
+parameter called chunk_size that is the size that the UMEM is divided
+into. The chunk size limits the maximum packet size that can be sent or
+received. For example, if you have a UMEM area that is 128K and a chunk
+size of 2K, then you will be able to hold a maximum of 128K / 2K = 64
+packets in your UMEM. In this case, the maximum packet size will be 2K.
+
+Valid chunk sizes range from 2K to 64K. However, in aligned mode, the
+chunk size must also be a power of two. Additionally, the chunk size
+must not exceed the size of a page (usually 4K). This limitation is
+relaxed for UMEM areas allocated with HugeTLB pages, in which case
+chunk sizes up to 64K are allowed. Note, this only works with hugepages
+allocated from the kernel's persistent pool. Using Transparent Huge
+Pages (THP) has no effect on the maximum chunk size.
 
 There is also an option to set the headroom of each single buffer in
 the UMEM. If you set this to N bytes, it means that the packet will
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e96a1151ec75..a71589539c38 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -25,6 +25,8 @@ struct xdp_umem {
 	u32 chunk_size;
 	u32 chunks;
 	u32 npgs;
+	u32 page_shift;
+	u32 page_size;
 	struct user_struct *user;
 	refcount_t users;
 	u8 flags;
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 9c0d860609ba..83fba3060c9a 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -12,6 +12,18 @@
 #define XDP_UMEM_MIN_CHUNK_SHIFT 11
 #define XDP_UMEM_MIN_CHUNK_SIZE (1 << XDP_UMEM_MIN_CHUNK_SHIFT)
 
+static_assert(XDP_UMEM_MIN_CHUNK_SIZE <= PAGE_SIZE);
+
+/* Allow chunk sizes up to the maximum size of an ethernet frame (64 KiB).
+ * Larger chunks are not guaranteed to fit in a single SKB.
+ */
+#ifdef CONFIG_HUGETLB_PAGE
+#define XDP_UMEM_MAX_CHUNK_SHIFT min(16, HPAGE_SHIFT)
+#else
+#define XDP_UMEM_MAX_CHUNK_SHIFT min(16, PAGE_SHIFT)
+#endif
+#define XDP_UMEM_MAX_CHUNK_SIZE (1 << XDP_UMEM_MAX_CHUNK_SHIFT)
+
 #ifdef CONFIG_XDP_SOCKETS
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index a8d7b8a3688a..af822b322d89 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -68,6 +68,8 @@ struct xsk_buff_pool {
 	struct xdp_desc *tx_descs;
 	u64 chunk_mask;
 	u64 addrs_cnt;
+	u32 page_shift;
+	u32 page_size;
 	u32 free_list_cnt;
 	u32 dma_pages_cnt;
 	u32 free_heads_cnt;
@@ -123,8 +125,8 @@ static inline void xp_init_xskb_addr(struct xdp_buff_xsk *xskb, struct xsk_buff_
 static inline void xp_init_xskb_dma(struct xdp_buff_xsk *xskb, struct xsk_buff_pool *pool,
 				    dma_addr_t *dma_pages, u64 addr)
 {
-	xskb->frame_dma = (dma_pages[addr >> PAGE_SHIFT] & ~XSK_NEXT_PG_CONTIG_MASK) +
-		(addr & ~PAGE_MASK);
+	xskb->frame_dma = (dma_pages[addr >> pool->page_shift] & ~XSK_NEXT_PG_CONTIG_MASK) +
+			  (addr & (pool->page_size - 1));
 	xskb->dma = xskb->frame_dma + pool->headroom + XDP_PACKET_HEADROOM;
 }
 
@@ -175,13 +177,13 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
 static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 						 u64 addr, u32 len)
 {
-	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
+	bool cross_pg = (addr & (pool->page_size - 1)) + len > pool->page_size;
 
 	if (likely(!cross_pg))
 		return false;
 
 	return pool->dma_pages &&
-	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
+	       !(pool->dma_pages[addr >> pool->page_shift] & XSK_NEXT_PG_CONTIG_MASK);
 }
 
 static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 4681e8e8ad94..6fb984be8f40 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -10,6 +10,8 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/bpf.h>
+#include <linux/hugetlb.h>
+#include <linux/hugetlb_inline.h>
 #include <linux/mm.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
@@ -91,9 +93,39 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
 	}
 }
 
+/* NOTE: The mmap_lock must be held by the caller. */
+static void xdp_umem_init_page_size(struct xdp_umem *umem, unsigned long address)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+	unsigned long end;
+
+	if (!IS_ALIGNED(address, HPAGE_SIZE))
+		goto no_hugetlb;
+
+	vma_iter_init(&vmi, current->mm, address);
+	end = address + umem->size;
+
+	for_each_vma_range(vmi, vma, end) {
+		if (!is_vm_hugetlb_page(vma))
+			goto no_hugetlb;
+		/* Hugepage sizes smaller than the default are not supported. */
+		if (huge_page_size(hstate_vma(vma)) < HPAGE_SIZE)
+			goto no_hugetlb;
+	}
+
+	umem->page_shift = HPAGE_SHIFT;
+	umem->page_size = HPAGE_SIZE;
+	return;
+no_hugetlb:
+#endif
+	umem->page_shift = PAGE_SHIFT;
+	umem->page_size = PAGE_SIZE;
+}
+
 static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 {
-	unsigned int gup_flags = FOLL_WRITE;
 	long npgs;
 	int err;
 
@@ -102,8 +134,18 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 		return -ENOMEM;
 
 	mmap_read_lock(current->mm);
+
+	xdp_umem_init_page_size(umem, address);
+
+	if (umem->chunk_size > umem->page_size) {
+		mmap_read_unlock(current->mm);
+		err = -EINVAL;
+		goto out_pgs;
+	}
+
 	npgs = pin_user_pages(address, umem->npgs,
-			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
+			      FOLL_WRITE | FOLL_LONGTERM, &umem->pgs[0], NULL);
+
 	mmap_read_unlock(current->mm);
 
 	if (npgs != umem->npgs) {
@@ -156,15 +198,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	unsigned int chunks, chunks_rem;
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
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 26f6d304451e..85b36c31b505 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -75,14 +75,16 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
 	pool->addrs_cnt = umem->size;
+	pool->page_shift = umem->page_shift;
+	pool->page_size = umem->page_size;
 	pool->heads_cnt = umem->chunks;
 	pool->free_heads_cnt = umem->chunks;
 	pool->headroom = umem->headroom;
 	pool->chunk_size = umem->chunk_size;
 	pool->chunk_shift = ffs(umem->chunk_size) - 1;
-	pool->unaligned = unaligned;
 	pool->frame_len = umem->chunk_size - umem->headroom -
 		XDP_PACKET_HEADROOM;
+	pool->unaligned = unaligned;
 	pool->umem = umem;
 	pool->addrs = umem->addrs;
 	INIT_LIST_HEAD(&pool->free_list);
@@ -328,7 +330,8 @@ static void xp_destroy_dma_map(struct xsk_dma_map *dma_map)
 	kfree(dma_map);
 }
 
-static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
+static void __xp_dma_unmap(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map,
+			   unsigned long attrs)
 {
 	dma_addr_t *dma;
 	u32 i;
@@ -337,7 +340,7 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
 		dma = &dma_map->dma_pages[i];
 		if (*dma) {
 			*dma &= ~XSK_NEXT_PG_CONTIG_MASK;
-			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
+			dma_unmap_page_attrs(dma_map->dev, *dma, pool->page_size,
 					     DMA_BIDIRECTIONAL, attrs);
 			*dma = 0;
 		}
@@ -362,7 +365,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 	if (!refcount_dec_and_test(&dma_map->users))
 		return;
 
-	__xp_dma_unmap(dma_map, attrs);
+	__xp_dma_unmap(pool, dma_map, attrs);
 	kvfree(pool->dma_pages);
 	pool->dma_pages = NULL;
 	pool->dma_pages_cnt = 0;
@@ -370,16 +373,17 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 }
 EXPORT_SYMBOL(xp_dma_unmap);
 
-static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
+static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, u32 page_size)
 {
 	u32 i;
 
-	for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
-		if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
+	for (i = 0; i + 1 < dma_map->dma_pages_cnt; i++) {
+		if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + 1])
 			dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
 		else
 			dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
 	}
+	dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
 }
 
 static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
@@ -412,6 +416,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 {
 	struct xsk_dma_map *dma_map;
 	dma_addr_t dma;
+	u32 stride;
 	int err;
 	u32 i;
 
@@ -425,15 +430,19 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 		return 0;
 	}
 
+	/* dma_pages use pool->page_size whereas `pages` are always order-0. */
+	stride = pool->page_size >> PAGE_SHIFT; /* in order-0 pages */
+	nr_pages = (nr_pages + stride - 1) >> (pool->page_shift - PAGE_SHIFT);
+
 	dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
 	if (!dma_map)
 		return -ENOMEM;
 
 	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
-		dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
+		dma = dma_map_page_attrs(dev, pages[i * stride], 0, pool->page_size,
 					 DMA_BIDIRECTIONAL, attrs);
 		if (dma_mapping_error(dev, dma)) {
-			__xp_dma_unmap(dma_map, attrs);
+			__xp_dma_unmap(pool, dma_map, attrs);
 			return -ENOMEM;
 		}
 		if (dma_need_sync(dev, dma))
@@ -442,11 +451,11 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	}
 
 	if (pool->unaligned)
-		xp_check_dma_contiguity(dma_map);
+		xp_check_dma_contiguity(dma_map, pool->page_size);
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {
-		__xp_dma_unmap(dma_map, attrs);
+		__xp_dma_unmap(pool, dma_map, attrs);
 		return err;
 	}
 
@@ -663,9 +672,8 @@ EXPORT_SYMBOL(xp_raw_get_data);
 dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr)
 {
 	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
-	return (pool->dma_pages[addr >> PAGE_SHIFT] &
-		~XSK_NEXT_PG_CONTIG_MASK) +
-		(addr & ~PAGE_MASK);
+	return (pool->dma_pages[addr >> pool->page_shift] & ~XSK_NEXT_PG_CONTIG_MASK) +
+	       (addr & (pool->page_size - 1));
 }
 EXPORT_SYMBOL(xp_raw_get_dma);
 
-- 
2.39.2

