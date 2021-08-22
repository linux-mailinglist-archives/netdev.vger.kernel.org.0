Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FA93F3E33
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 09:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhHVGt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 02:49:26 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:17373 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhHVGtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 02:49:25 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d59 with ME
        id kWoi250013riaq203WoizA; Sun, 22 Aug 2021 08:48:43 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Aug 2021 08:48:43 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     cooldavid@cooldavid.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: jme: switch from 'pci_' to 'dma_' API
Date:   Sun, 22 Aug 2021 08:48:40 +0200
Message-Id: <861b51bebe380db8765890c0c1412a484de6163f.1629614888.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/ethernet/jme.c | 70 ++++++++++++++------------------------
 1 file changed, 26 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 1251b74fe0e2..438c5602fbc5 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -734,17 +734,17 @@ jme_make_new_rx_buf(struct jme_adapter *jme, int i)
 	if (unlikely(!skb))
 		return -ENOMEM;
 
-	mapping = pci_map_page(jme->pdev, virt_to_page(skb->data),
+	mapping = dma_map_page(&jme->pdev->dev, virt_to_page(skb->data),
 			       offset_in_page(skb->data), skb_tailroom(skb),
-			       PCI_DMA_FROMDEVICE);
-	if (unlikely(pci_dma_mapping_error(jme->pdev, mapping))) {
+			       DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(&jme->pdev->dev, mapping))) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
 	}
 
 	if (likely(rxbi->mapping))
-		pci_unmap_page(jme->pdev, rxbi->mapping,
-			       rxbi->len, PCI_DMA_FROMDEVICE);
+		dma_unmap_page(&jme->pdev->dev, rxbi->mapping, rxbi->len,
+			       DMA_FROM_DEVICE);
 
 	rxbi->skb = skb;
 	rxbi->len = skb_tailroom(skb);
@@ -760,10 +760,8 @@ jme_free_rx_buf(struct jme_adapter *jme, int i)
 	rxbi += i;
 
 	if (rxbi->skb) {
-		pci_unmap_page(jme->pdev,
-				 rxbi->mapping,
-				 rxbi->len,
-				 PCI_DMA_FROMDEVICE);
+		dma_unmap_page(&jme->pdev->dev, rxbi->mapping, rxbi->len,
+			       DMA_FROM_DEVICE);
 		dev_kfree_skb(rxbi->skb);
 		rxbi->skb = NULL;
 		rxbi->mapping = 0;
@@ -1005,16 +1003,12 @@ jme_alloc_and_feed_skb(struct jme_adapter *jme, int idx)
 	rxbi += idx;
 
 	skb = rxbi->skb;
-	pci_dma_sync_single_for_cpu(jme->pdev,
-					rxbi->mapping,
-					rxbi->len,
-					PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_cpu(&jme->pdev->dev, rxbi->mapping, rxbi->len,
+				DMA_FROM_DEVICE);
 
 	if (unlikely(jme_make_new_rx_buf(jme, idx))) {
-		pci_dma_sync_single_for_device(jme->pdev,
-						rxbi->mapping,
-						rxbi->len,
-						PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&jme->pdev->dev, rxbi->mapping,
+					   rxbi->len, DMA_FROM_DEVICE);
 
 		++(NET_STAT(jme).rx_dropped);
 	} else {
@@ -1453,10 +1447,9 @@ static void jme_tx_clean_tasklet(struct tasklet_struct *t)
 				ttxbi = txbi + ((i + j) & (mask));
 				txdesc[(i + j) & (mask)].dw[0] = 0;
 
-				pci_unmap_page(jme->pdev,
-						 ttxbi->mapping,
-						 ttxbi->len,
-						 PCI_DMA_TODEVICE);
+				dma_unmap_page(&jme->pdev->dev,
+					       ttxbi->mapping, ttxbi->len,
+					       DMA_TO_DEVICE);
 
 				ttxbi->mapping = 0;
 				ttxbi->len = 0;
@@ -1966,19 +1959,13 @@ jme_fill_tx_map(struct pci_dev *pdev,
 {
 	dma_addr_t dmaaddr;
 
-	dmaaddr = pci_map_page(pdev,
-				page,
-				page_offset,
-				len,
-				PCI_DMA_TODEVICE);
+	dmaaddr = dma_map_page(&pdev->dev, page, page_offset, len,
+			       DMA_TO_DEVICE);
 
-	if (unlikely(pci_dma_mapping_error(pdev, dmaaddr)))
+	if (unlikely(dma_mapping_error(&pdev->dev, dmaaddr)))
 		return -EINVAL;
 
-	pci_dma_sync_single_for_device(pdev,
-				       dmaaddr,
-				       len,
-				       PCI_DMA_TODEVICE);
+	dma_sync_single_for_device(&pdev->dev, dmaaddr, len, DMA_TO_DEVICE);
 
 	txdesc->dw[0] = 0;
 	txdesc->dw[1] = 0;
@@ -2003,10 +1990,8 @@ static void jme_drop_tx_map(struct jme_adapter *jme, int startidx, int count)
 
 	for (j = 0 ; j < count ; j++) {
 		ctxbi = txbi + ((startidx + j + 2) & (mask));
-		pci_unmap_page(jme->pdev,
-				ctxbi->mapping,
-				ctxbi->len,
-				PCI_DMA_TODEVICE);
+		dma_unmap_page(&jme->pdev->dev, ctxbi->mapping, ctxbi->len,
+			       DMA_TO_DEVICE);
 
 		ctxbi->mapping = 0;
 		ctxbi->len = 0;
@@ -2859,18 +2844,15 @@ static int
 jme_pci_dma64(struct pci_dev *pdev)
 {
 	if (pdev->device == PCI_DEVICE_ID_JMICRON_JMC250 &&
-	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
-			return 1;
+	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
+		return 1;
 
 	if (pdev->device == PCI_DEVICE_ID_JMICRON_JMC250 &&
-	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(40)))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40)))
-			return 1;
+	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40)))
+		return 1;
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
-			return 0;
+	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+		return 0;
 
 	return -1;
 }
-- 
2.30.2

