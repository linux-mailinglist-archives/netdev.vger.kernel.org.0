Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AEA1C386F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgEDLiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728398AbgEDLiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:38:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AFCC061A0E;
        Mon,  4 May 2020 04:38:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so5347445pfc.12;
        Mon, 04 May 2020 04:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NObtDmkZmRVaHchvf7FI7TcG59qtBqwh7AlsWcWBPIs=;
        b=TJ2x0ucHB42BmxSswZbBlQKGa+Pfjs03/5F0/FiqR3kQHpJLL0yKhCs5U6J3izvJxQ
         I9BKOOaEXk1z2QsuTMo4C8W4Nb0CPcOvLCpC+7Cgk2Imdecx+zpcxXWcqsVJK4OrI4ms
         wIZyMFAai2mUL4JvtiiPbURREeRkrfgOhZdFUe79LlbsABWjt+LgfTA3mL255jp1oiHf
         GHLDrFQSQ89kb9qtgk2D0rO7zFwzFS9XLuVjGeF15LerO6/dBZVAgPmG/RSP8zXAFYes
         GdYqxp1tIrTb99pO83D8XEY3rAotKfYHK77enI2xJmuJY6MoQkj110rhQ++q582WqXoi
         G3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NObtDmkZmRVaHchvf7FI7TcG59qtBqwh7AlsWcWBPIs=;
        b=sF/xI9OL0nklFEis5LRsqbJXBRkf2YeI6oBciFUb7ev8hXrpoZyzMFuWLOldn6ZRsd
         NDBEHMTFtO+LVfp76KzVxffFyyye+mxKwYd4Xdo2v6mV1nEDfKmHGQgtJfMAxh/YCDzW
         NEpnRO+O+XKcBsLLqpXrIrqfvMSkbNOY3O7d25XRVFpoAmpxo2bY0+x2FGTkrWtfVssK
         /raTB2JYHLhqpNDOlBqr7ZsdwCxZzHzXBav6H8LwPK0UWOuq/spAuSwS0klLRZd2NtE5
         aApi1Gxj07JE/iP0UwaYVplLAI/wdrC/FVH4rzsmJZ2SI30Rj35JQg7sk9GxdMudbY5J
         WpmA==
X-Gm-Message-State: AGi0Pua3QiEqm8gfzqlTHFib+UFzCk+uvAMcyecmaINEN1TsasjrAxSv
        NoawQUsD3ZtouHudLrnVArI=
X-Google-Smtp-Source: APiQypJ+jZvQ6zVW/kQQahJCh420LVVROcAajp1zXwQE7x2o9e6fTaUK4myt+hNO8wDTD/x+JsRXoQ==
X-Received: by 2002:a62:5ac2:: with SMTP id o185mr16831593pfb.148.1588592329995;
        Mon, 04 May 2020 04:38:49 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id x185sm8650789pfx.155.2020.05.04.04.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:38:49 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next 12/13] xsk: explicitly inline functions and move definitions
Date:   Mon,  4 May 2020 13:37:14 +0200
Message-Id: <20200504113716.7930-13-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200504113716.7930-1-bjorn.topel@gmail.com>
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
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
xp_get_dma(), xp_dma_sync_for_cpu() and xp_dma_sync_for_device() are
explicitly inlined.

Further, move xp_get_handle() and xp_release() to xsk.c, to allow for
the compiler to perform inlining.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xsk_buff_pool.h | 50 ++++++++++++++++++++++++++++----
 net/xdp/xsk.c               | 15 ++++++++++
 net/xdp/xsk_buff_pool.c     | 58 ++++---------------------------------
 3 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 9abef166441d..5c8e357b2678 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -24,6 +24,27 @@ struct xdp_buff_xsk {
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
@@ -31,7 +52,6 @@ struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
 void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
-u64 xp_get_handle(struct xdp_buff_xsk *xskb);
 bool xp_validate_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
 
 /* AF_XDP, and XDP core. */
@@ -46,9 +66,29 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool);
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
 
 #endif /* XSK_BUFF_POOL_H_ */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index bcd5faf82788..46136828e0e9 100644
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
index 30537220e8f2..bf3c48ba1467 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -14,27 +14,6 @@
 #define XSK_NEXT_PG_CONTIG_SHIFT 0
 #define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
 
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
@@ -234,11 +213,6 @@ static bool xp_addr_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 	return xp_desc_crosses_non_contig_pg(pool, addr, pool->chunk_size);
 }
 
-void xp_release(struct xdp_buff_xsk *xskb)
-{
-	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
-}
-
 static u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
 {
 	return addr & pool->chunk_mask;
@@ -401,16 +375,6 @@ bool xp_validate_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 		xp_aligned_validate_desc(pool, desc);
 }
 
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
@@ -427,32 +391,20 @@ dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr)
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
-- 
2.25.1

