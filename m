Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE9B21F98C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgGNSff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:35:35 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:32212 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGNSff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:35:35 -0400
Received: from localhost.localdomain ([93.23.14.36])
        by mwinf5d77 with ME
        id 36bS2300P0mgUh1036bTVi; Tue, 14 Jul 2020 20:35:32 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Jul 2020 20:35:32 +0200
X-ME-IP: 93.23.14.36
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sumit.semwal@linaro.org, davem@davemloft.net, kuba@kernel.org,
        christian.koenig@amd.com, mhabets@solarflare.com,
        jwi@linux.ibm.com, zhongjiang@huawei.com, weiyongjun1@huawei.com,
        vaibhavgupta40@gmail.com
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ksz884x: switch from 'pci_' to 'dma_' API
Date:   Tue, 14 Jul 2020 20:35:01 +0200
Message-Id: <20200714183501.310949-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'ksz_alloc_desc()', GFP_KERNEL can be used
because a few lines below, GFP_KERNEL is also used in the
'ksz_alloc_soft_desc()' calls.


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
 drivers/net/ethernet/micrel/ksz884x.c | 68 ++++++++++++---------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 2ce7304d3753..bb646b65cc95 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -4390,9 +4390,9 @@ static int ksz_alloc_desc(struct dev_info *adapter)
 		DESC_ALIGNMENT;
 
 	adapter->desc_pool.alloc_virt =
-		pci_zalloc_consistent(adapter->pdev,
-				      adapter->desc_pool.alloc_size,
-				      &adapter->desc_pool.dma_addr);
+		dma_alloc_coherent(&adapter->pdev->dev,
+				   adapter->desc_pool.alloc_size,
+				   &adapter->desc_pool.dma_addr, GFP_KERNEL);
 	if (adapter->desc_pool.alloc_virt == NULL) {
 		adapter->desc_pool.alloc_size = 0;
 		return 1;
@@ -4431,7 +4431,8 @@ static int ksz_alloc_desc(struct dev_info *adapter)
 static void free_dma_buf(struct dev_info *adapter, struct ksz_dma_buf *dma_buf,
 	int direction)
 {
-	pci_unmap_single(adapter->pdev, dma_buf->dma, dma_buf->len, direction);
+	dma_unmap_single(&adapter->pdev->dev, dma_buf->dma, dma_buf->len,
+			 direction);
 	dev_kfree_skb(dma_buf->skb);
 	dma_buf->skb = NULL;
 	dma_buf->dma = 0;
@@ -4456,16 +4457,15 @@ static void ksz_init_rx_buffers(struct dev_info *adapter)
 
 		dma_buf = DMA_BUFFER(desc);
 		if (dma_buf->skb && dma_buf->len != adapter->mtu)
-			free_dma_buf(adapter, dma_buf, PCI_DMA_FROMDEVICE);
+			free_dma_buf(adapter, dma_buf, DMA_FROM_DEVICE);
 		dma_buf->len = adapter->mtu;
 		if (!dma_buf->skb)
 			dma_buf->skb = alloc_skb(dma_buf->len, GFP_ATOMIC);
 		if (dma_buf->skb && !dma_buf->dma)
-			dma_buf->dma = pci_map_single(
-				adapter->pdev,
-				skb_tail_pointer(dma_buf->skb),
-				dma_buf->len,
-				PCI_DMA_FROMDEVICE);
+			dma_buf->dma = dma_map_single(&adapter->pdev->dev,
+						skb_tail_pointer(dma_buf->skb),
+						dma_buf->len,
+						DMA_FROM_DEVICE);
 
 		/* Set descriptor. */
 		set_rx_buf(desc, dma_buf->dma);
@@ -4543,11 +4543,10 @@ static void ksz_free_desc(struct dev_info *adapter)
 
 	/* Free memory. */
 	if (adapter->desc_pool.alloc_virt)
-		pci_free_consistent(
-			adapter->pdev,
-			adapter->desc_pool.alloc_size,
-			adapter->desc_pool.alloc_virt,
-			adapter->desc_pool.dma_addr);
+		dma_free_coherent(&adapter->pdev->dev,
+				  adapter->desc_pool.alloc_size,
+				  adapter->desc_pool.alloc_virt,
+				  adapter->desc_pool.dma_addr);
 
 	/* Reset resource pool. */
 	adapter->desc_pool.alloc_size = 0;
@@ -4590,12 +4589,10 @@ static void ksz_free_buffers(struct dev_info *adapter,
 static void ksz_free_mem(struct dev_info *adapter)
 {
 	/* Free transmit buffers. */
-	ksz_free_buffers(adapter, &adapter->hw.tx_desc_info,
-		PCI_DMA_TODEVICE);
+	ksz_free_buffers(adapter, &adapter->hw.tx_desc_info, DMA_TO_DEVICE);
 
 	/* Free receive buffers. */
-	ksz_free_buffers(adapter, &adapter->hw.rx_desc_info,
-		PCI_DMA_FROMDEVICE);
+	ksz_free_buffers(adapter, &adapter->hw.rx_desc_info, DMA_FROM_DEVICE);
 
 	/* Free descriptors. */
 	ksz_free_desc(adapter);
@@ -4657,9 +4654,8 @@ static void send_packet(struct sk_buff *skb, struct net_device *dev)
 
 		dma_buf->len = skb_headlen(skb);
 
-		dma_buf->dma = pci_map_single(
-			hw_priv->pdev, skb->data, dma_buf->len,
-			PCI_DMA_TODEVICE);
+		dma_buf->dma = dma_map_single(&hw_priv->pdev->dev, skb->data,
+					      dma_buf->len, DMA_TO_DEVICE);
 		set_tx_buf(desc, dma_buf->dma);
 		set_tx_len(desc, dma_buf->len);
 
@@ -4676,11 +4672,10 @@ static void send_packet(struct sk_buff *skb, struct net_device *dev)
 			dma_buf = DMA_BUFFER(desc);
 			dma_buf->len = skb_frag_size(this_frag);
 
-			dma_buf->dma = pci_map_single(
-				hw_priv->pdev,
-				skb_frag_address(this_frag),
-				dma_buf->len,
-				PCI_DMA_TODEVICE);
+			dma_buf->dma = dma_map_single(&hw_priv->pdev->dev,
+						      skb_frag_address(this_frag),
+						      dma_buf->len,
+						      DMA_TO_DEVICE);
 			set_tx_buf(desc, dma_buf->dma);
 			set_tx_len(desc, dma_buf->len);
 
@@ -4700,9 +4695,8 @@ static void send_packet(struct sk_buff *skb, struct net_device *dev)
 	} else {
 		dma_buf->len = len;
 
-		dma_buf->dma = pci_map_single(
-			hw_priv->pdev, skb->data, dma_buf->len,
-			PCI_DMA_TODEVICE);
+		dma_buf->dma = dma_map_single(&hw_priv->pdev->dev, skb->data,
+					      dma_buf->len, DMA_TO_DEVICE);
 		set_tx_buf(desc, dma_buf->dma);
 		set_tx_len(desc, dma_buf->len);
 	}
@@ -4756,9 +4750,8 @@ static void transmit_cleanup(struct dev_info *hw_priv, int normal)
 		}
 
 		dma_buf = DMA_BUFFER(desc);
-		pci_unmap_single(
-			hw_priv->pdev, dma_buf->dma, dma_buf->len,
-			PCI_DMA_TODEVICE);
+		dma_unmap_single(&hw_priv->pdev->dev, dma_buf->dma,
+				 dma_buf->len, DMA_TO_DEVICE);
 
 		/* This descriptor contains the last buffer in the packet. */
 		if (dma_buf->skb) {
@@ -4991,9 +4984,8 @@ static inline int rx_proc(struct net_device *dev, struct ksz_hw* hw,
 	packet_len = status.rx.frame_len - 4;
 
 	dma_buf = DMA_BUFFER(desc);
-	pci_dma_sync_single_for_cpu(
-		hw_priv->pdev, dma_buf->dma, packet_len + 4,
-		PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_cpu(&hw_priv->pdev->dev, dma_buf->dma,
+				packet_len + 4, DMA_FROM_DEVICE);
 
 	do {
 		/* skb->data != skb->head */
@@ -6935,8 +6927,8 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	result = -ENODEV;
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) ||
+	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)))
 		return result;
 
 	reg_base = pci_resource_start(pdev, 0);
-- 
2.25.1

