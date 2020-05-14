Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84261D2A5D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgENIi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726197AbgENIi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:38:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1157AC061A0C;
        Thu, 14 May 2020 01:38:26 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id z15so2771261pjb.0;
        Thu, 14 May 2020 01:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xaI+dxdkWV4VACAfg0MAccpixvtxpKG2nAQ8/ucBdvg=;
        b=jFs8tjoOYIKTXbv2J9A+zPbIkw61GdVm9rgW4T0oMTMa/O7nSQ4sAXKj5BM4KynjxD
         Lo7OAiEPjQVuj1mFjFSF+dJLTEr2j7wa9atCStESjv+9yH9o2rm7o67Mil23BK3Nkt+j
         Ur5uwy+0HWfuo85F+0S0MZK+W0D1NHVfYOB0aFo23NDJL9oOy+5oyiAeRXCuurTsVfjR
         o2X784kc6Ra5AO4/esfRGfoKmcXzerRYG6bym+EnR+AWxEnLq1G6Bgini4p2WHyVYH75
         A9H7TSPZxmpD6Ne89hCd4jahwmkUYql2A3uTgWUX3nsTqi6QPb8IGWi0VhSRgfDus0aH
         J6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xaI+dxdkWV4VACAfg0MAccpixvtxpKG2nAQ8/ucBdvg=;
        b=RfrhOElsvsGlsf8tij12pBzJIlPfhKuCOlQiXPADyy6JmQGp5W6NjHi/TaRlj0PMBn
         veqhs42yPJp/gLgjgz2osB3v2sX3RD/UM+FZLtEYemodCdE/TVRR7kTJ/DHPMDe1RkYz
         2viXMkZLRRgADLTDJbID2tS6dVv0o9VEFC9d8+gEMoZgMyHXFRJ6n425G8nluJw0UYmP
         9giwUagnUf0iDdRgrPdX+epVohJ7e/gKk1L84SV4ktdxTx1JwblpX1gN5kg9JoXf1WW3
         ZZ20b+a6MRPPy6/7R+Ijsl8QkGOH3TLTwFJtu0+NZMmpkq8N4fx/5Mx14P5ubAQ1NbVD
         Vyuw==
X-Gm-Message-State: AGi0PubY73SD+F77aRJ6HyUTXl+OBl5KEI/FLFflhRE+0rENxupSBvYV
        d+jFAPte9FaIDx+R6+GCoU0=
X-Google-Smtp-Source: APiQypIYM0TysVcUTRSrHcaqKUn1u1WxZDSlpXGZ3s9OvzONVAT/HCs1ydjtCG+RZ6CbHxRiYnRmjw==
X-Received: by 2002:a17:90a:3568:: with SMTP id q95mr40758677pjb.47.1589445505568;
        Thu, 14 May 2020 01:38:25 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k4sm1608058pgg.88.2020.05.14.01.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:38:24 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v2 13/14] xsk: explicitly inline functions and move definitions
Date:   Thu, 14 May 2020 10:37:09 +0200
Message-Id: <20200514083710.143394-14-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514083710.143394-1-bjorn.topel@gmail.com>
References: <20200514083710.143394-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

In order to reduce the number of function calls, the struct
xsk_buff_pool definition is moved to xsk_buff_pool.h. The functions
xp_get_dma(), xp_dma_sync_for_cpu(), xp_dma_sync_for_device(),
xp_validate_desc() and various helper functions are explicitly
inlined.

Further, move xp_get_handle() and xp_release() to xsk.c, to allow for
the compiler to perform inlining.

rfc->v1: Make sure xp_validate_desc() is inlined for Tx perf. (Maxim)

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xsk_buff_pool.h |  92 +++++++++++++++++++++--
 net/xdp/xsk.c               |  15 ++++
 net/xdp/xsk_buff_pool.c     | 142 ++----------------------------------
 net/xdp/xsk_queue.h         |  45 ++++++++++++
 4 files changed, 151 insertions(+), 143 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 9abef166441d..029522696ccb 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -4,6 +4,7 @@
 #ifndef XSK_BUFF_POOL_H_
 #define XSK_BUFF_POOL_H_
 
+#include <linux/if_xdp.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 #include <net/xdp.h>
@@ -24,6 +25,27 @@ struct xdp_buff_xsk {
 	struct list_head free_list_node;
 };
 
+struct xsk_buff_pool {
+	struct xsk_queue *fq;
+	struct list_head free_list;
+	dma_addr_t *dma_pages;
+	struct xdp_buff_xsk *heads;
+	u64 chunk_mask;
+	u64 addrs_cnt;
+	u32 free_list_cnt;
+	u32 dma_pages_cnt;
+	u32 heads_cnt;
+	u32 free_heads_cnt;
+	u32 headroom;
+	u32 chunk_size;
+	u32 frame_len;
+	bool cheap_dma;
+	bool unaligned;
+	void *addrs;
+	struct device *dev;
+	struct xdp_buff_xsk *free_heads[];
+};
+
 /* AF_XDP core. */
 struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
 				u32 chunk_size, u32 headroom, u64 size,
@@ -31,8 +53,6 @@ struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
 void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
-u64 xp_get_handle(struct xdp_buff_xsk *xskb);
-bool xp_validate_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
 
 /* AF_XDP, and XDP core. */
 void xp_free(struct xdp_buff_xsk *xskb);
@@ -46,9 +66,69 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool);
 bool xp_can_alloc(struct xsk_buff_pool *pool, u32 count);
 void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr);
 dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr);
-dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb);
-void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb);
-void xp_dma_sync_for_device(struct xsk_buff_pool *pool, dma_addr_t dma,
-			    size_t size);
+static inline dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)
+{
+	return xskb->dma;
+}
+
+void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb);
+static inline void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
+{
+	if (xskb->pool->cheap_dma)
+		return;
+
+	xp_dma_sync_for_cpu_slow(xskb);
+}
+
+void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
+				 size_t size);
+static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
+					  dma_addr_t dma, size_t size)
+{
+	if (pool->cheap_dma)
+		return;
+
+	xp_dma_sync_for_device_slow(pool, dma, size);
+}
+
+/* Masks for xdp_umem_page flags.
+ * The low 12-bits of the addr will be 0 since this is the page address, so we
+ * can use them for flags.
+ */
+#define XSK_NEXT_PG_CONTIG_SHIFT 0
+#define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
+
+static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
+						 u64 addr, u32 len)
+{
+	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
+
+	if (pool->dma_pages_cnt && cross_pg) {
+		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
+			 XSK_NEXT_PG_CONTIG_MASK);
+	}
+	return false;
+}
+
+static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
+{
+	return addr & pool->chunk_mask;
+}
+
+static inline u64 xp_unaligned_extract_addr(u64 addr)
+{
+	return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
+}
+
+static inline u64 xp_unaligned_extract_offset(u64 addr)
+{
+	return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+}
+
+static inline u64 xp_unaligned_add_offset_to_addr(u64 addr)
+{
+	return xp_unaligned_extract_addr(addr) +
+		xp_unaligned_extract_offset(addr);
+}
 
 #endif /* XSK_BUFF_POOL_H_ */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3f2ab732ab8b..b6c0f08bd80d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -99,6 +99,21 @@ bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_umem_uses_need_wakeup);
 
+void xp_release(struct xdp_buff_xsk *xskb)
+{
+	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
+}
+
+static u64 xp_get_handle(struct xdp_buff_xsk *xskb)
+{
+	u64 offset = xskb->xdp.data - xskb->xdp.data_hard_start;
+
+	offset += xskb->pool->headroom;
+	if (!xskb->pool->unaligned)
+		return xskb->orig_addr + offset;
+	return xskb->orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+}
+
 static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 365bdb5749cc..20ea583133de 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -8,34 +8,6 @@
 
 #include "xsk_queue.h"
 
-/* Masks for xdp_umem_page flags.
- * The low 12-bits of the addr will be 0 since this is the page address, so we
- * can use them for flags.
- */
-#define XSK_NEXT_PG_CONTIG_SHIFT 0
-#define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
-
-struct xsk_buff_pool {
-	struct xsk_queue *fq;
-	struct list_head free_list;
-	dma_addr_t *dma_pages;
-	struct xdp_buff_xsk *heads;
-	u64 chunk_mask;
-	u64 addrs_cnt;
-	u32 free_list_cnt;
-	u32 dma_pages_cnt;
-	u32 heads_cnt;
-	u32 free_heads_cnt;
-	u32 headroom;
-	u32 chunk_size;
-	u32 frame_len;
-	bool cheap_dma;
-	bool unaligned;
-	void *addrs;
-	struct device *dev;
-	struct xdp_buff_xsk *free_heads[];
-};
-
 static void xp_addr_unmap(struct xsk_buff_pool *pool)
 {
 	vunmap(pool->addrs);
@@ -227,50 +199,12 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 }
 EXPORT_SYMBOL(xp_dma_map);
 
-static bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
-					  u64 addr, u32 len)
-{
-	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
-
-	if (pool->dma_pages_cnt && cross_pg) {
-		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
-			 XSK_NEXT_PG_CONTIG_MASK);
-	}
-	return false;
-}
-
 static bool xp_addr_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 					  u64 addr)
 {
 	return xp_desc_crosses_non_contig_pg(pool, addr, pool->chunk_size);
 }
 
-void xp_release(struct xdp_buff_xsk *xskb)
-{
-	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
-}
-
-static u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
-{
-	return addr & pool->chunk_mask;
-}
-
-static u64 xp_unaligned_extract_addr(u64 addr)
-{
-	return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
-}
-
-static u64 xp_unaligned_extract_offset(u64 addr)
-{
-	return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
-}
-
-static u64 xp_unaligned_add_offset_to_addr(u64 addr)
-{
-	return xp_unaligned_extract_addr(addr) +
-		xp_unaligned_extract_offset(addr);
-}
-
 static bool xp_check_unaligned(struct xsk_buff_pool *pool, u64 *addr)
 {
 	*addr = xp_unaligned_extract_addr(*addr);
@@ -368,60 +302,6 @@ void xp_free(struct xdp_buff_xsk *xskb)
 }
 EXPORT_SYMBOL(xp_free);
 
-static bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
-				     struct xdp_desc *desc)
-{
-	u64 chunk, chunk_end;
-
-	chunk = xp_aligned_extract_addr(pool, desc->addr);
-	chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len);
-	if (chunk != chunk_end)
-		return false;
-
-	if (chunk >= pool->addrs_cnt)
-		return false;
-
-	if (desc->options)
-		return false;
-	return true;
-}
-
-static bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
-				       struct xdp_desc *desc)
-{
-	u64 addr, base_addr;
-
-	base_addr = xp_unaligned_extract_addr(desc->addr);
-	addr = xp_unaligned_add_offset_to_addr(desc->addr);
-
-	if (desc->len > pool->chunk_size)
-		return false;
-
-	if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
-	    xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
-		return false;
-
-	if (desc->options)
-		return false;
-	return true;
-}
-
-bool xp_validate_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
-{
-	return pool->unaligned ? xp_unaligned_validate_desc(pool, desc) :
-		xp_aligned_validate_desc(pool, desc);
-}
-
-u64 xp_get_handle(struct xdp_buff_xsk *xskb)
-{
-	u64 offset = xskb->xdp.data - xskb->xdp.data_hard_start;
-
-	offset += xskb->pool->headroom;
-	if (!xskb->pool->unaligned)
-		return xskb->orig_addr + offset;
-	return xskb->orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
-}
-
 void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 {
 	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
@@ -438,32 +318,20 @@ dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr)
 }
 EXPORT_SYMBOL(xp_raw_get_dma);
 
-dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)
-{
-	return xskb->dma;
-}
-EXPORT_SYMBOL(xp_get_dma);
-
-void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
+void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb)
 {
 	size_t size;
 
-	if (xskb->pool->cheap_dma)
-		return;
-
 	size = xskb->xdp.data_end - xskb->xdp.data;
 	dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
 				      size, DMA_BIDIRECTIONAL);
 }
-EXPORT_SYMBOL(xp_dma_sync_for_cpu);
+EXPORT_SYMBOL(xp_dma_sync_for_cpu_slow);
 
-void xp_dma_sync_for_device(struct xsk_buff_pool *pool, dma_addr_t dma,
-			    size_t size)
+void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
+				 size_t size)
 {
-	if (pool->cheap_dma)
-		return;
-
 	dma_sync_single_range_for_device(pool->dev, dma, 0,
 					 size, DMA_BIDIRECTIONAL);
 }
-EXPORT_SYMBOL(xp_dma_sync_for_device);
+EXPORT_SYMBOL(xp_dma_sync_for_device_slow);
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 16bf15864788..5b5d24d2dd37 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -118,6 +118,51 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
 	return false;
 }
 
+static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
+					    struct xdp_desc *desc)
+{
+	u64 chunk, chunk_end;
+
+	chunk = xp_aligned_extract_addr(pool, desc->addr);
+	chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len);
+	if (chunk != chunk_end)
+		return false;
+
+	if (chunk >= pool->addrs_cnt)
+		return false;
+
+	if (desc->options)
+		return false;
+	return true;
+}
+
+static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
+					      struct xdp_desc *desc)
+{
+	u64 addr, base_addr;
+
+	base_addr = xp_unaligned_extract_addr(desc->addr);
+	addr = xp_unaligned_add_offset_to_addr(desc->addr);
+
+	if (desc->len > pool->chunk_size)
+		return false;
+
+	if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
+	    xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
+		return false;
+
+	if (desc->options)
+		return false;
+	return true;
+}
+
+static inline bool xp_validate_desc(struct xsk_buff_pool *pool,
+				    struct xdp_desc *desc)
+{
+	return pool->unaligned ? xp_unaligned_validate_desc(pool, desc) :
+		xp_aligned_validate_desc(pool, desc);
+}
+
 static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
 					   struct xdp_desc *d,
 					   struct xdp_umem *umem)
-- 
2.25.1

