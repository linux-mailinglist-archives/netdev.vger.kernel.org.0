Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015163F3FB9
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhHVOYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:24:43 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:27017 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232471AbhHVOYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:24:43 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d74 with ME
        id kePy2500F3riaq203ePzXA; Sun, 22 Aug 2021 16:24:00 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Aug 2021 16:24:00 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] myri10ge: switch from 'pci_' to 'dma_' API
Date:   Sun, 22 Aug 2021 16:23:57 +0200
Message-Id: <e5265136abae64c5e763d30ef8ec34607967c7dc.1629642164.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.

It has been hand modified to use 'dma_set_mask_and_coherent()' instead of
'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
This is less verbose.

A message split on 2 lines has been merged.

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
 .../net/ethernet/myricom/myri10ge/myri10ge.c  | 59 +++++++++----------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index fc99ad8e4a38..7359a8b768e9 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -850,9 +850,9 @@ static int myri10ge_dma_test(struct myri10ge_priv *mgp, int test_type)
 	dmatest_page = alloc_page(GFP_KERNEL);
 	if (!dmatest_page)
 		return -ENOMEM;
-	dmatest_bus = pci_map_page(mgp->pdev, dmatest_page, 0, PAGE_SIZE,
-				   DMA_BIDIRECTIONAL);
-	if (unlikely(pci_dma_mapping_error(mgp->pdev, dmatest_bus))) {
+	dmatest_bus = dma_map_page(&mgp->pdev->dev, dmatest_page, 0,
+				   PAGE_SIZE, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&mgp->pdev->dev, dmatest_bus))) {
 		__free_page(dmatest_page);
 		return -ENOMEM;
 	}
@@ -899,7 +899,8 @@ static int myri10ge_dma_test(struct myri10ge_priv *mgp, int test_type)
 	    (cmd.data0 & 0xffff);
 
 abort:
-	pci_unmap_page(mgp->pdev, dmatest_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	dma_unmap_page(&mgp->pdev->dev, dmatest_bus, PAGE_SIZE,
+		       DMA_BIDIRECTIONAL);
 	put_page(dmatest_page);
 
 	if (status != 0 && test_type != MXGEFW_CMD_UNALIGNED_TEST)
@@ -1205,10 +1206,10 @@ myri10ge_alloc_rx_pages(struct myri10ge_priv *mgp, struct myri10ge_rx_buf *rx,
 				return;
 			}
 
-			bus = pci_map_page(mgp->pdev, page, 0,
+			bus = dma_map_page(&mgp->pdev->dev, page, 0,
 					   MYRI10GE_ALLOC_SIZE,
-					   PCI_DMA_FROMDEVICE);
-			if (unlikely(pci_dma_mapping_error(mgp->pdev, bus))) {
+					   DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(&mgp->pdev->dev, bus))) {
 				__free_pages(page, MYRI10GE_ALLOC_ORDER);
 				if (rx->fill_cnt - rx->cnt < 16)
 					rx->watchdog_needed = 1;
@@ -1256,9 +1257,9 @@ myri10ge_unmap_rx_page(struct pci_dev *pdev,
 	/* unmap the recvd page if we're the only or last user of it */
 	if (bytes >= MYRI10GE_ALLOC_SIZE / 2 ||
 	    (info->page_offset + 2 * bytes) > MYRI10GE_ALLOC_SIZE) {
-		pci_unmap_page(pdev, (dma_unmap_addr(info, bus)
-				      & ~(MYRI10GE_ALLOC_SIZE - 1)),
-			       MYRI10GE_ALLOC_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_page(&pdev->dev, (dma_unmap_addr(info, bus)
+					    & ~(MYRI10GE_ALLOC_SIZE - 1)),
+			       MYRI10GE_ALLOC_SIZE, DMA_FROM_DEVICE);
 	}
 }
 
@@ -1398,16 +1399,16 @@ myri10ge_tx_done(struct myri10ge_slice_state *ss, int mcp_index)
 			ss->stats.tx_packets++;
 			dev_consume_skb_irq(skb);
 			if (len)
-				pci_unmap_single(pdev,
+				dma_unmap_single(&pdev->dev,
 						 dma_unmap_addr(&tx->info[idx],
 								bus), len,
-						 PCI_DMA_TODEVICE);
+						 DMA_TO_DEVICE);
 		} else {
 			if (len)
-				pci_unmap_page(pdev,
+				dma_unmap_page(&pdev->dev,
 					       dma_unmap_addr(&tx->info[idx],
 							      bus), len,
-					       PCI_DMA_TODEVICE);
+					       DMA_TO_DEVICE);
 		}
 	}
 
@@ -2110,16 +2111,16 @@ static void myri10ge_free_rings(struct myri10ge_slice_state *ss)
 			ss->stats.tx_dropped++;
 			dev_kfree_skb_any(skb);
 			if (len)
-				pci_unmap_single(mgp->pdev,
+				dma_unmap_single(&mgp->pdev->dev,
 						 dma_unmap_addr(&tx->info[idx],
 								bus), len,
-						 PCI_DMA_TODEVICE);
+						 DMA_TO_DEVICE);
 		} else {
 			if (len)
-				pci_unmap_page(mgp->pdev,
+				dma_unmap_page(&mgp->pdev->dev,
 					       dma_unmap_addr(&tx->info[idx],
 							      bus), len,
-					       PCI_DMA_TODEVICE);
+					       DMA_TO_DEVICE);
 		}
 	}
 	kfree(ss->rx_big.info);
@@ -2584,15 +2585,15 @@ static void myri10ge_unmap_tx_dma(struct myri10ge_priv *mgp,
 		len = dma_unmap_len(&tx->info[idx], len);
 		if (len) {
 			if (tx->info[idx].skb != NULL)
-				pci_unmap_single(mgp->pdev,
+				dma_unmap_single(&mgp->pdev->dev,
 						 dma_unmap_addr(&tx->info[idx],
 								bus), len,
-						 PCI_DMA_TODEVICE);
+						 DMA_TO_DEVICE);
 			else
-				pci_unmap_page(mgp->pdev,
+				dma_unmap_page(&mgp->pdev->dev,
 					       dma_unmap_addr(&tx->info[idx],
 							      bus), len,
-					       PCI_DMA_TODEVICE);
+					       DMA_TO_DEVICE);
 			dma_unmap_len_set(&tx->info[idx], len, 0);
 			tx->info[idx].skb = NULL;
 		}
@@ -2715,8 +2716,8 @@ static netdev_tx_t myri10ge_xmit(struct sk_buff *skb,
 
 	/* map the skb for DMA */
 	len = skb_headlen(skb);
-	bus = pci_map_single(mgp->pdev, skb->data, len, PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(mgp->pdev, bus)))
+	bus = dma_map_single(&mgp->pdev->dev, skb->data, len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(&mgp->pdev->dev, bus)))
 		goto drop;
 
 	idx = tx->req & tx->mask;
@@ -2824,7 +2825,7 @@ static netdev_tx_t myri10ge_xmit(struct sk_buff *skb,
 		len = skb_frag_size(frag);
 		bus = skb_frag_dma_map(&mgp->pdev->dev, frag, 0, len,
 				       DMA_TO_DEVICE);
-		if (unlikely(pci_dma_mapping_error(mgp->pdev, bus))) {
+		if (unlikely(dma_mapping_error(&mgp->pdev->dev, bus))) {
 			myri10ge_unmap_tx_dma(mgp, tx, idx);
 			goto drop;
 		}
@@ -3776,19 +3777,17 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	myri10ge_mask_surprise_down(pdev);
 	pci_set_master(pdev);
 	dac_enabled = 1;
-	status = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (status != 0) {
 		dac_enabled = 0;
 		dev_err(&pdev->dev,
-			"64-bit pci address mask was refused, "
-			"trying 32-bit\n");
-		status = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+			"64-bit pci address mask was refused, trying 32-bit\n");
+		status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	}
 	if (status != 0) {
 		dev_err(&pdev->dev, "Error %d setting DMA mask\n", status);
 		goto abort_with_enabled;
 	}
-	(void)pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	mgp->cmd = dma_alloc_coherent(&pdev->dev, sizeof(*mgp->cmd),
 				      &mgp->cmd_bus, GFP_KERNEL);
 	if (!mgp->cmd) {
-- 
2.30.2

