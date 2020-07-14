Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F7621EC71
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgGNJOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:14:21 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:29977 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgGNJOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:14:20 -0400
Received: from localhost.localdomain ([93.22.39.234])
        by mwinf5d69 with ME
        id 2xEE23004537AcD03xEEPM; Tue, 14 Jul 2020 11:14:17 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Jul 2020 11:14:17 +0200
X-ME-IP: 93.22.39.234
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, jdmason@kudzu.us, kuba@kernel.org,
        mhabets@solarflare.com, snelson@pensando.io, mst@redhat.com,
        vaibhavgupta40@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: neterion: vxge: switch from 'pci_' to 'dma_' API
Date:   Tue, 14 Jul 2020 11:14:12 +0200
Message-Id: <20200714091412.300211-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below. No GFP_
flag needs to be corrected.
It has been compile tested.


@@
@@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@
@@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@
@@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
@@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 .../net/ethernet/neterion/vxge/vxge-config.c  | 42 ++++++------
 .../net/ethernet/neterion/vxge/vxge-main.c    | 64 +++++++++----------
 2 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index 51cd57ab3d95..4f1f90f5e178 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -1102,10 +1102,10 @@ static void __vxge_hw_blockpool_destroy(struct __vxge_hw_blockpool *blockpool)
 	hldev = blockpool->hldev;
 
 	list_for_each_safe(p, n, &blockpool->free_block_list) {
-		pci_unmap_single(hldev->pdev,
-			((struct __vxge_hw_blockpool_entry *)p)->dma_addr,
-			((struct __vxge_hw_blockpool_entry *)p)->length,
-			PCI_DMA_BIDIRECTIONAL);
+		dma_unmap_single(&hldev->pdev->dev,
+				 ((struct __vxge_hw_blockpool_entry *)p)->dma_addr,
+				 ((struct __vxge_hw_blockpool_entry *)p)->length,
+				 DMA_BIDIRECTIONAL);
 
 		vxge_os_dma_free(hldev->pdev,
 			((struct __vxge_hw_blockpool_entry *)p)->memblock,
@@ -1178,10 +1178,10 @@ __vxge_hw_blockpool_create(struct __vxge_hw_device *hldev,
 			goto blockpool_create_exit;
 		}
 
-		dma_addr = pci_map_single(hldev->pdev, memblock,
-				VXGE_HW_BLOCK_SIZE, PCI_DMA_BIDIRECTIONAL);
-		if (unlikely(pci_dma_mapping_error(hldev->pdev,
-				dma_addr))) {
+		dma_addr = dma_map_single(&hldev->pdev->dev, memblock,
+					  VXGE_HW_BLOCK_SIZE,
+					  DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(&hldev->pdev->dev, dma_addr))) {
 			vxge_os_dma_free(hldev->pdev, memblock, &acc_handle);
 			__vxge_hw_blockpool_destroy(blockpool);
 			status = VXGE_HW_ERR_OUT_OF_MEMORY;
@@ -2264,10 +2264,10 @@ static void vxge_hw_blockpool_block_add(struct __vxge_hw_device *devh,
 		goto exit;
 	}
 
-	dma_addr = pci_map_single(devh->pdev, block_addr, length,
-				PCI_DMA_BIDIRECTIONAL);
+	dma_addr = dma_map_single(&devh->pdev->dev, block_addr, length,
+				  DMA_BIDIRECTIONAL);
 
-	if (unlikely(pci_dma_mapping_error(devh->pdev, dma_addr))) {
+	if (unlikely(dma_mapping_error(&devh->pdev->dev, dma_addr))) {
 		vxge_os_dma_free(devh->pdev, block_addr, &acc_handle);
 		blockpool->req_out--;
 		goto exit;
@@ -2359,11 +2359,10 @@ static void *__vxge_hw_blockpool_malloc(struct __vxge_hw_device *devh, u32 size,
 		if (!memblock)
 			goto exit;
 
-		dma_object->addr = pci_map_single(devh->pdev, memblock, size,
-					PCI_DMA_BIDIRECTIONAL);
+		dma_object->addr = dma_map_single(&devh->pdev->dev, memblock,
+						  size, DMA_BIDIRECTIONAL);
 
-		if (unlikely(pci_dma_mapping_error(devh->pdev,
-				dma_object->addr))) {
+		if (unlikely(dma_mapping_error(&devh->pdev->dev, dma_object->addr))) {
 			vxge_os_dma_free(devh->pdev, memblock,
 				&dma_object->acc_handle);
 			memblock = NULL;
@@ -2410,11 +2409,10 @@ __vxge_hw_blockpool_blocks_remove(struct __vxge_hw_blockpool *blockpool)
 		if (blockpool->pool_size < blockpool->pool_max)
 			break;
 
-		pci_unmap_single(
-			(blockpool->hldev)->pdev,
-			((struct __vxge_hw_blockpool_entry *)p)->dma_addr,
-			((struct __vxge_hw_blockpool_entry *)p)->length,
-			PCI_DMA_BIDIRECTIONAL);
+		dma_unmap_single(&(blockpool->hldev)->pdev->dev,
+				 ((struct __vxge_hw_blockpool_entry *)p)->dma_addr,
+				 ((struct __vxge_hw_blockpool_entry *)p)->length,
+				 DMA_BIDIRECTIONAL);
 
 		vxge_os_dma_free(
 			(blockpool->hldev)->pdev,
@@ -2445,8 +2443,8 @@ static void __vxge_hw_blockpool_free(struct __vxge_hw_device *devh,
 	blockpool = &devh->block_pool;
 
 	if (size != blockpool->block_size) {
-		pci_unmap_single(devh->pdev, dma_object->addr, size,
-			PCI_DMA_BIDIRECTIONAL);
+		dma_unmap_single(&devh->pdev->dev, dma_object->addr, size,
+				 DMA_BIDIRECTIONAL);
 		vxge_os_dma_free(devh->pdev, memblock, &dma_object->acc_handle);
 	} else {
 
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 5de85b9e9e35..b0faa737b817 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -241,10 +241,10 @@ static int vxge_rx_map(void *dtrh, struct vxge_ring *ring)
 	rx_priv = vxge_hw_ring_rxd_private_get(dtrh);
 
 	rx_priv->skb_data = rx_priv->skb->data;
-	dma_addr = pci_map_single(ring->pdev, rx_priv->skb_data,
-				rx_priv->data_size, PCI_DMA_FROMDEVICE);
+	dma_addr = dma_map_single(&ring->pdev->dev, rx_priv->skb_data,
+				  rx_priv->data_size, DMA_FROM_DEVICE);
 
-	if (unlikely(pci_dma_mapping_error(ring->pdev, dma_addr))) {
+	if (unlikely(dma_mapping_error(&ring->pdev->dev, dma_addr))) {
 		ring->stats.pci_map_fail++;
 		return -EIO;
 	}
@@ -323,8 +323,8 @@ vxge_rx_complete(struct vxge_ring *ring, struct sk_buff *skb, u16 vlan,
 static inline void vxge_re_pre_post(void *dtr, struct vxge_ring *ring,
 				    struct vxge_rx_priv *rx_priv)
 {
-	pci_dma_sync_single_for_device(ring->pdev,
-		rx_priv->data_dma, rx_priv->data_size, PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_device(&ring->pdev->dev, rx_priv->data_dma,
+				   rx_priv->data_size, DMA_FROM_DEVICE);
 
 	vxge_hw_ring_rxd_1b_set(dtr, rx_priv->data_dma, rx_priv->data_size);
 	vxge_hw_ring_rxd_pre_post(ring->handle, dtr);
@@ -425,8 +425,9 @@ vxge_rx_1b_compl(struct __vxge_hw_ring *ringh, void *dtr,
 				if (!vxge_rx_map(dtr, ring)) {
 					skb_put(skb, pkt_length);
 
-					pci_unmap_single(ring->pdev, data_dma,
-						data_size, PCI_DMA_FROMDEVICE);
+					dma_unmap_single(&ring->pdev->dev,
+							 data_dma, data_size,
+							 DMA_FROM_DEVICE);
 
 					vxge_hw_ring_rxd_pre_post(ringh, dtr);
 					vxge_post(&dtr_cnt, &first_dtr, dtr,
@@ -458,9 +459,9 @@ vxge_rx_1b_compl(struct __vxge_hw_ring *ringh, void *dtr,
 				skb_reserve(skb_up,
 				    VXGE_HW_HEADER_ETHERNET_II_802_3_ALIGN);
 
-				pci_dma_sync_single_for_cpu(ring->pdev,
-					data_dma, data_size,
-					PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&ring->pdev->dev,
+							data_dma, data_size,
+							DMA_FROM_DEVICE);
 
 				vxge_debug_mem(VXGE_TRACE,
 					"%s: %s:%d  skb_up = %p",
@@ -585,13 +586,13 @@ vxge_xmit_compl(struct __vxge_hw_fifo *fifo_hw, void *dtr,
 		}
 
 		/*  for unfragmented skb */
-		pci_unmap_single(fifo->pdev, txd_priv->dma_buffers[i++],
-				skb_headlen(skb), PCI_DMA_TODEVICE);
+		dma_unmap_single(&fifo->pdev->dev, txd_priv->dma_buffers[i++],
+				 skb_headlen(skb), DMA_TO_DEVICE);
 
 		for (j = 0; j < frg_cnt; j++) {
-			pci_unmap_page(fifo->pdev,
-					txd_priv->dma_buffers[i++],
-					skb_frag_size(frag), PCI_DMA_TODEVICE);
+			dma_unmap_page(&fifo->pdev->dev,
+				       txd_priv->dma_buffers[i++],
+				       skb_frag_size(frag), DMA_TO_DEVICE);
 			frag += 1;
 		}
 
@@ -897,10 +898,10 @@ vxge_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	first_frg_len = skb_headlen(skb);
 
-	dma_pointer = pci_map_single(fifo->pdev, skb->data, first_frg_len,
-				PCI_DMA_TODEVICE);
+	dma_pointer = dma_map_single(&fifo->pdev->dev, skb->data,
+				     first_frg_len, DMA_TO_DEVICE);
 
-	if (unlikely(pci_dma_mapping_error(fifo->pdev, dma_pointer))) {
+	if (unlikely(dma_mapping_error(&fifo->pdev->dev, dma_pointer))) {
 		vxge_hw_fifo_txdl_free(fifo_hw, dtr);
 		fifo->stats.pci_map_fail++;
 		goto _exit0;
@@ -977,12 +978,12 @@ vxge_xmit(struct sk_buff *skb, struct net_device *dev)
 	j = 0;
 	frag = &skb_shinfo(skb)->frags[0];
 
-	pci_unmap_single(fifo->pdev, txdl_priv->dma_buffers[j++],
-			skb_headlen(skb), PCI_DMA_TODEVICE);
+	dma_unmap_single(&fifo->pdev->dev, txdl_priv->dma_buffers[j++],
+			 skb_headlen(skb), DMA_TO_DEVICE);
 
 	for (; j < i; j++) {
-		pci_unmap_page(fifo->pdev, txdl_priv->dma_buffers[j],
-			skb_frag_size(frag), PCI_DMA_TODEVICE);
+		dma_unmap_page(&fifo->pdev->dev, txdl_priv->dma_buffers[j],
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		frag += 1;
 	}
 
@@ -1012,8 +1013,8 @@ vxge_rx_term(void *dtrh, enum vxge_hw_rxd_state state, void *userdata)
 	if (state != VXGE_HW_RXD_STATE_POSTED)
 		return;
 
-	pci_unmap_single(ring->pdev, rx_priv->data_dma,
-		rx_priv->data_size, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&ring->pdev->dev, rx_priv->data_dma,
+			 rx_priv->data_size, DMA_FROM_DEVICE);
 
 	dev_kfree_skb(rx_priv->skb);
 	rx_priv->skb_data = NULL;
@@ -1048,12 +1049,12 @@ vxge_tx_term(void *dtrh, enum vxge_hw_txdl_state state, void *userdata)
 	frag = &skb_shinfo(skb)->frags[0];
 
 	/*  for unfragmented skb */
-	pci_unmap_single(fifo->pdev, txd_priv->dma_buffers[i++],
-		skb_headlen(skb), PCI_DMA_TODEVICE);
+	dma_unmap_single(&fifo->pdev->dev, txd_priv->dma_buffers[i++],
+			 skb_headlen(skb), DMA_TO_DEVICE);
 
 	for (j = 0; j < frg_cnt; j++) {
-		pci_unmap_page(fifo->pdev, txd_priv->dma_buffers[i++],
-			       skb_frag_size(frag), PCI_DMA_TODEVICE);
+		dma_unmap_page(&fifo->pdev->dev, txd_priv->dma_buffers[i++],
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		frag += 1;
 	}
 
@@ -4387,21 +4388,20 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 		goto _exit0;
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		vxge_debug_ll_config(VXGE_TRACE,
 			"%s : using 64bit DMA", __func__);
 
 		high_dma = 1;
 
-		if (pci_set_consistent_dma_mask(pdev,
-						DMA_BIT_MASK(64))) {
+		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 			vxge_debug_init(VXGE_ERR,
 				"%s : unable to obtain 64bit DMA for "
 				"consistent allocations", __func__);
 			ret = -ENOMEM;
 			goto _exit1;
 		}
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		vxge_debug_ll_config(VXGE_TRACE,
 			"%s : using 32bit DMA", __func__);
 	} else {
-- 
2.25.1

