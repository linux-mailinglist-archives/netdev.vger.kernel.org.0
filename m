Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C39129C4A
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 02:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLXBBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 20:01:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57785 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726907AbfLXBBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 20:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577149290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYlAd2YZ+olFh/PS5fD2Ur9yzhJ1vXI9a6RqNJYLp74=;
        b=fa+2aYKBWSoRYYBt11IvSG5nAoNY6a1E6RZGjUUIGHRocqvFAzMbE9Q8VdH3QteGP6R+cy
        7wNuuC0zTILxMN0CFBgZSzA02hCsURajbQapInoCkyRffRIwXKCfVg8iqHMyS7aD+Tg3eY
        e/8+iiqXINIdYskkdiqPpjKfPiGysbc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-D50_NCrPOkKISz4Iw2bKuA-1; Mon, 23 Dec 2019 20:01:28 -0500
X-MC-Unique: D50_NCrPOkKISz4Iw2bKuA-1
Received: by mail-wr1-f69.google.com with SMTP id y7so8835116wrm.3
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 17:01:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DYlAd2YZ+olFh/PS5fD2Ur9yzhJ1vXI9a6RqNJYLp74=;
        b=tIXcYMUrdopMiuEkqlRxFeGD+byburwwsb00V916+OCNnV29HwtTdVq6TvZSSu1n+3
         7A19GMPsFIxovb9bV5aoANCnAiEH2ZkclzdjIoUxHYg6pVMEGFFcv8wGzDmUdvmtEiB1
         m44fi8H5jG7pEf7CiMqjlOzeMASY52xI+7mPT/afZKrPF6IXuii06JyuQ4JxBDtEictT
         Z38V4X2GdkQEBnWbNrWwSnVCWDHk3FlmiuYxo7fe6oOyNkhGBWBKIjtF3urEt76ECzaY
         UpZvVVa84cTuXtLuweElBxojAwbc1U7jMVmRFUfORhoEvPacDPcn5R9C8H/eYYWH6nc5
         ohyg==
X-Gm-Message-State: APjAAAWOOMKPjae/6kEvxfMsN2IgP5/MzpN9IFD9+dLP8trsjq2MXM1/
        ZPbXwtjHYEFwZNfeFI5bx3ha6Vb5M/wSihKcOHC19OHx6+2eh9lq9Tb+2ANzoEZqnmvBUNR3KXj
        TldFCUJUf9mEnR7SD
X-Received: by 2002:a1c:5444:: with SMTP id p4mr1276523wmi.33.1577149287162;
        Mon, 23 Dec 2019 17:01:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqzf/KSuf0x3D+CKyqMFi1Tp2f3Zj1Cyl/AW39jWV2kL1AR8LaEyKsVSEpj8LK7GRJiMsf8CHg==
X-Received: by 2002:a1c:5444:: with SMTP id p4mr1276490wmi.33.1577149286834;
        Mon, 23 Dec 2019 17:01:26 -0800 (PST)
Received: from mcroce-redhat.homenet.telecomitalia.it (host213-32-dynamic.19-79-r.retail.telecomitalia.it. [79.19.32.213])
        by smtp.gmail.com with ESMTPSA id e18sm22330532wrw.70.2019.12.23.17.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 17:01:26 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tomislav Tomasic <tomislav.tomasic@sartura.hr>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Nadav Haklai <nadavh@marvell.com>
Subject: [RFC net-next 1/2] mvpp2: use page_pool allocator
Date:   Tue, 24 Dec 2019 02:01:02 +0100
Message-Id: <20191224010103.56407-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191224010103.56407-1-mcroce@redhat.com>
References: <20191224010103.56407-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the page_pool API for memory management. This is a prerequisite for
native XDP support.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   4 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 111 ++++++++++++++----
 3 files changed, 92 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index 3d5caea096fb..e2612cc4920d 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -87,6 +87,7 @@ config MVPP2
 	depends on ARCH_MVEBU || COMPILE_TEST
 	select MVMDIO
 	select PHYLINK
+	select PAGE_POOL
 	---help---
 	  This driver supports the network interface units in the
 	  Marvell ARMADA 375, 7K and 8K SoCs.
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 543a310ec102..67b3bf0d3c8b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -15,6 +15,7 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <net/flow_offload.h>
+#include <net/page_pool.h>
 
 /* Fifo Registers */
 #define MVPP2_RX_DATA_FIFO_SIZE_REG(port)	(0x00 + 4 * (port))
@@ -820,6 +821,9 @@ struct mvpp2 {
 
 	/* RSS Indirection tables */
 	struct mvpp2_rss_table *rss_tables[MVPP22_N_RSS_TABLES];
+
+	/* page_pool allocator */
+	struct page_pool *page_pool[MVPP2_PORT_MAX_RXQ];
 };
 
 struct mvpp2_pcpu_stats {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 14e372cda7f4..4edb81c8941f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -92,6 +92,21 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
 	return cpu % priv->nthreads;
 }
 
+static struct page_pool *
+mvpp2_create_page_pool(struct device *dev, int num)
+{
+	struct page_pool_params pp_params = {
+		/* internal DMA mapping in page_pool */
+		.flags = PP_FLAG_DMA_MAP,
+		.pool_size = num,
+		.nid = NUMA_NO_NODE,
+		.dev = dev,
+		.dma_dir = DMA_FROM_DEVICE,
+	};
+
+	return page_pool_create(&pp_params);
+}
+
 /* These accessors should be used to access:
  *
  * - per-thread registers, where each thread has its own copy of the
@@ -324,17 +339,26 @@ static inline int mvpp2_txq_phys(int port, int txq)
 	return (MVPP2_MAX_TCONT + port) * MVPP2_MAX_TXQ + txq;
 }
 
-static void *mvpp2_frag_alloc(const struct mvpp2_bm_pool *pool)
+/* Returns a struct page if page_pool is set, otherwise a buffer */
+static void *mvpp2_frag_alloc(const struct mvpp2_bm_pool *pool,
+			      struct page_pool *page_pool)
 {
+	if (page_pool)
+		return page_pool_alloc_pages(page_pool,
+					     GFP_ATOMIC | __GFP_NOWARN);
+
 	if (likely(pool->frag_size <= PAGE_SIZE))
 		return netdev_alloc_frag(pool->frag_size);
-	else
-		return kmalloc(pool->frag_size, GFP_ATOMIC);
+
+	return kmalloc(pool->frag_size, GFP_ATOMIC);
 }
 
-static void mvpp2_frag_free(const struct mvpp2_bm_pool *pool, void *data)
+static void mvpp2_frag_free(const struct mvpp2_bm_pool *pool,
+			    struct page_pool *page_pool, void *data)
 {
-	if (likely(pool->frag_size <= PAGE_SIZE))
+	if (page_pool)
+		page_pool_put_page(page_pool, virt_to_page(data), false);
+	else if (likely(pool->frag_size <= PAGE_SIZE))
 		skb_free_frag(data);
 	else
 		kfree(data);
@@ -439,6 +463,7 @@ static void mvpp2_bm_bufs_get_addrs(struct device *dev, struct mvpp2 *priv,
 static void mvpp2_bm_bufs_free(struct device *dev, struct mvpp2 *priv,
 			       struct mvpp2_bm_pool *bm_pool, int buf_num)
 {
+	struct page_pool *pp = NULL;
 	int i;
 
 	if (buf_num > bm_pool->buf_num) {
@@ -447,6 +472,9 @@ static void mvpp2_bm_bufs_free(struct device *dev, struct mvpp2 *priv,
 		buf_num = bm_pool->buf_num;
 	}
 
+	if (priv->percpu_pools)
+		pp = priv->page_pool[bm_pool->id];
+
 	for (i = 0; i < buf_num; i++) {
 		dma_addr_t buf_dma_addr;
 		phys_addr_t buf_phys_addr;
@@ -455,14 +483,15 @@ static void mvpp2_bm_bufs_free(struct device *dev, struct mvpp2 *priv,
 		mvpp2_bm_bufs_get_addrs(dev, priv, bm_pool,
 					&buf_dma_addr, &buf_phys_addr);
 
-		dma_unmap_single(dev, buf_dma_addr,
-				 bm_pool->buf_size, DMA_FROM_DEVICE);
+		if (!pp)
+			dma_unmap_single(dev, buf_dma_addr,
+					 bm_pool->buf_size, DMA_FROM_DEVICE);
 
 		data = (void *)phys_to_virt(buf_phys_addr);
 		if (!data)
 			break;
 
-		mvpp2_frag_free(bm_pool, data);
+		mvpp2_frag_free(bm_pool, pp, data);
 	}
 
 	/* Update BM driver with number of buffers removed from pool */
@@ -493,6 +522,9 @@ static int mvpp2_bm_pool_destroy(struct device *dev, struct mvpp2 *priv,
 	int buf_num;
 	u32 val;
 
+	if (priv->percpu_pools)
+		page_pool_destroy(priv->page_pool[bm_pool->id]);
+
 	buf_num = mvpp2_check_hw_buf_num(priv, bm_pool);
 	mvpp2_bm_bufs_free(dev, priv, bm_pool, buf_num);
 
@@ -545,8 +577,16 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 {
 	int i, err, poolnum = MVPP2_BM_POOLS_NUM;
 
-	if (priv->percpu_pools)
+	if (priv->percpu_pools) {
 		poolnum = mvpp2_get_nrxqs(priv) * 2;
+		for (i = 0; i < poolnum; i++) {
+			priv->page_pool[i] =
+				mvpp2_create_page_pool(dev,
+						       mvpp2_pools[i / (poolnum / 2)].buf_num);
+			if (IS_ERR(priv->page_pool[i]))
+				return PTR_ERR(priv->page_pool[i]);
+		}
+	}
 
 	dev_info(dev, "using %d %s buffers\n", poolnum,
 		 priv->percpu_pools ? "per-cpu" : "shared");
@@ -629,23 +669,35 @@ static void mvpp2_rxq_short_pool_set(struct mvpp2_port *port,
 
 static void *mvpp2_buf_alloc(struct mvpp2_port *port,
 			     struct mvpp2_bm_pool *bm_pool,
+			     struct page_pool *page_pool,
 			     dma_addr_t *buf_dma_addr,
 			     phys_addr_t *buf_phys_addr,
 			     gfp_t gfp_mask)
 {
 	dma_addr_t dma_addr;
+	struct page *page;
 	void *data;
 
-	data = mvpp2_frag_alloc(bm_pool);
+	data = mvpp2_frag_alloc(bm_pool, page_pool);
 	if (!data)
 		return NULL;
 
-	dma_addr = dma_map_single(port->dev->dev.parent, data,
-				  MVPP2_RX_BUF_SIZE(bm_pool->pkt_size),
-				  DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(port->dev->dev.parent, dma_addr))) {
-		mvpp2_frag_free(bm_pool, data);
-		return NULL;
+	if (page_pool) {
+		page = (struct page *)data;
+		dma_addr = page_pool_get_dma_addr(page);
+		data = page_to_virt(page);
+		dma_sync_single_for_device(port->dev->dev.parent,
+					   virt_to_phys(data),
+					   bm_pool->buf_size,
+					   DMA_FROM_DEVICE);
+	} else {
+		dma_addr = dma_map_single(port->dev->dev.parent, data,
+					  MVPP2_RX_BUF_SIZE(bm_pool->pkt_size),
+					  DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(port->dev->dev.parent, dma_addr))) {
+			mvpp2_frag_free(bm_pool, NULL, data);
+			return NULL;
+		}
 	}
 	*buf_dma_addr = dma_addr;
 	*buf_phys_addr = virt_to_phys(data);
@@ -703,6 +755,7 @@ static int mvpp2_bm_bufs_add(struct mvpp2_port *port,
 	int i, buf_size, total_size;
 	dma_addr_t dma_addr;
 	phys_addr_t phys_addr;
+	struct page_pool *pp = NULL;
 	void *buf;
 
 	if (port->priv->percpu_pools &&
@@ -723,8 +776,10 @@ static int mvpp2_bm_bufs_add(struct mvpp2_port *port,
 		return 0;
 	}
 
+	if (port->priv->percpu_pools)
+		pp = port->priv->page_pool[bm_pool->id];
 	for (i = 0; i < buf_num; i++) {
-		buf = mvpp2_buf_alloc(port, bm_pool, &dma_addr,
+		buf = mvpp2_buf_alloc(port, bm_pool, pp, &dma_addr,
 				      &phys_addr, GFP_KERNEL);
 		if (!buf)
 			break;
@@ -2865,14 +2920,15 @@ static void mvpp2_rx_csum(struct mvpp2_port *port, u32 status,
 
 /* Allocate a new skb and add it to BM pool */
 static int mvpp2_rx_refill(struct mvpp2_port *port,
-			   struct mvpp2_bm_pool *bm_pool, int pool)
+			   struct mvpp2_bm_pool *bm_pool,
+			   struct page_pool *page_pool, int pool)
 {
 	dma_addr_t dma_addr;
 	phys_addr_t phys_addr;
 	void *buf;
 
-	buf = mvpp2_buf_alloc(port, bm_pool, &dma_addr, &phys_addr,
-			      GFP_ATOMIC);
+	buf = mvpp2_buf_alloc(port, bm_pool, page_pool,
+			      &dma_addr, &phys_addr, GFP_ATOMIC);
 	if (!buf)
 		return -ENOMEM;
 
@@ -2931,6 +2987,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 	while (rx_done < rx_todo) {
 		struct mvpp2_rx_desc *rx_desc = mvpp2_rxq_next_desc_get(rxq);
 		struct mvpp2_bm_pool *bm_pool;
+		struct page_pool *pp = NULL;
 		struct sk_buff *skb;
 		unsigned int frag_size;
 		dma_addr_t dma_addr;
@@ -2975,15 +3032,21 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			goto err_drop_frame;
 		}
 
-		err = mvpp2_rx_refill(port, bm_pool, pool);
+		if (port->priv->percpu_pools)
+			pp = port->priv->page_pool[pool];
+
+		err = mvpp2_rx_refill(port, bm_pool, pp, pool);
 		if (err) {
 			netdev_err(port->dev, "failed to refill BM pools\n");
 			goto err_drop_frame;
 		}
 
-		dma_unmap_single_attrs(dev->dev.parent, dma_addr,
-				       bm_pool->buf_size, DMA_FROM_DEVICE,
-				       DMA_ATTR_SKIP_CPU_SYNC);
+		if (pp)
+			page_pool_release_page(pp, virt_to_page(data));
+		else
+			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
+					       bm_pool->buf_size, DMA_FROM_DEVICE,
+					       DMA_ATTR_SKIP_CPU_SYNC);
 
 		rcvd_pkts++;
 		rcvd_bytes += rx_bytes;
-- 
2.24.1

