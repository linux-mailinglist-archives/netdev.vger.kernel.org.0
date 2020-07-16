Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F40222BE5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgGPT2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:28:32 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:43263 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729551AbgGPT2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:28:31 -0400
Received: from localhost.localdomain ([93.22.39.121])
        by mwinf5d33 with ME
        id 3vUS2300U2cqCS503vUTT8; Thu, 16 Jul 2020 21:28:28 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 16 Jul 2020 21:28:28 +0200
X-ME-IP: 93.22.39.121
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        mst@redhat.com, vaibhavgupta40@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: sungem: switch from 'pci_' to 'dma_' API
Date:   Thu, 16 Jul 2020 21:28:21 +0200
Message-Id: <20200716192821.321233-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'gem_init_one()', GFP_KERNEL can be used
because it is a probe function and no lock is acquired.


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
 drivers/net/ethernet/sun/sungem.c | 53 ++++++++++++++++---------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 0e9d2cf7979b..eeb8518c8a84 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -670,7 +670,8 @@ static __inline__ void gem_tx(struct net_device *dev, struct gem *gp, u32 gem_st
 			dma_addr = le64_to_cpu(txd->buffer);
 			dma_len = le64_to_cpu(txd->control_word) & TXDCTRL_BUFSZ;
 
-			pci_unmap_page(gp->pdev, dma_addr, dma_len, PCI_DMA_TODEVICE);
+			dma_unmap_page(&gp->pdev->dev, dma_addr, dma_len,
+				       DMA_TO_DEVICE);
 			entry = NEXT_TX(entry);
 		}
 
@@ -809,16 +810,15 @@ static int gem_rx(struct gem *gp, int work_to_do)
 				drops++;
 				goto drop_it;
 			}
-			pci_unmap_page(gp->pdev, dma_addr,
-				       RX_BUF_ALLOC_SIZE(gp),
-				       PCI_DMA_FROMDEVICE);
+			dma_unmap_page(&gp->pdev->dev, dma_addr,
+				       RX_BUF_ALLOC_SIZE(gp), DMA_FROM_DEVICE);
 			gp->rx_skbs[entry] = new_skb;
 			skb_put(new_skb, (gp->rx_buf_sz + RX_OFFSET));
-			rxd->buffer = cpu_to_le64(pci_map_page(gp->pdev,
+			rxd->buffer = cpu_to_le64(dma_map_page(&gp->pdev->dev,
 							       virt_to_page(new_skb->data),
 							       offset_in_page(new_skb->data),
 							       RX_BUF_ALLOC_SIZE(gp),
-							       PCI_DMA_FROMDEVICE));
+							       DMA_FROM_DEVICE));
 			skb_reserve(new_skb, RX_OFFSET);
 
 			/* Trim the original skb for the netif. */
@@ -833,9 +833,11 @@ static int gem_rx(struct gem *gp, int work_to_do)
 
 			skb_reserve(copy_skb, 2);
 			skb_put(copy_skb, len);
-			pci_dma_sync_single_for_cpu(gp->pdev, dma_addr, len, PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&gp->pdev->dev, dma_addr, len,
+						DMA_FROM_DEVICE);
 			skb_copy_from_linear_data(skb, copy_skb->data, len);
-			pci_dma_sync_single_for_device(gp->pdev, dma_addr, len, PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&gp->pdev->dev, dma_addr,
+						   len, DMA_FROM_DEVICE);
 
 			/* We'll reuse the original ring buffer. */
 			skb = copy_skb;
@@ -1020,10 +1022,10 @@ static netdev_tx_t gem_start_xmit(struct sk_buff *skb,
 		u32 len;
 
 		len = skb->len;
-		mapping = pci_map_page(gp->pdev,
+		mapping = dma_map_page(&gp->pdev->dev,
 				       virt_to_page(skb->data),
 				       offset_in_page(skb->data),
-				       len, PCI_DMA_TODEVICE);
+				       len, DMA_TO_DEVICE);
 		ctrl |= TXDCTRL_SOF | TXDCTRL_EOF | len;
 		if (gem_intme(entry))
 			ctrl |= TXDCTRL_INTME;
@@ -1046,9 +1048,10 @@ static netdev_tx_t gem_start_xmit(struct sk_buff *skb,
 		 * Otherwise we could race with the device.
 		 */
 		first_len = skb_headlen(skb);
-		first_mapping = pci_map_page(gp->pdev, virt_to_page(skb->data),
+		first_mapping = dma_map_page(&gp->pdev->dev,
+					     virt_to_page(skb->data),
 					     offset_in_page(skb->data),
-					     first_len, PCI_DMA_TODEVICE);
+					     first_len, DMA_TO_DEVICE);
 		entry = NEXT_TX(entry);
 
 		for (frag = 0; frag < skb_shinfo(skb)->nr_frags; frag++) {
@@ -1574,9 +1577,9 @@ static void gem_clean_rings(struct gem *gp)
 		if (gp->rx_skbs[i] != NULL) {
 			skb = gp->rx_skbs[i];
 			dma_addr = le64_to_cpu(rxd->buffer);
-			pci_unmap_page(gp->pdev, dma_addr,
+			dma_unmap_page(&gp->pdev->dev, dma_addr,
 				       RX_BUF_ALLOC_SIZE(gp),
-				       PCI_DMA_FROMDEVICE);
+				       DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
 			gp->rx_skbs[i] = NULL;
 		}
@@ -1598,9 +1601,9 @@ static void gem_clean_rings(struct gem *gp)
 
 				txd = &gb->txd[ent];
 				dma_addr = le64_to_cpu(txd->buffer);
-				pci_unmap_page(gp->pdev, dma_addr,
+				dma_unmap_page(&gp->pdev->dev, dma_addr,
 					       le64_to_cpu(txd->control_word) &
-					       TXDCTRL_BUFSZ, PCI_DMA_TODEVICE);
+					       TXDCTRL_BUFSZ, DMA_TO_DEVICE);
 
 				if (frag != skb_shinfo(skb)->nr_frags)
 					i++;
@@ -1637,11 +1640,11 @@ static void gem_init_rings(struct gem *gp)
 
 		gp->rx_skbs[i] = skb;
 		skb_put(skb, (gp->rx_buf_sz + RX_OFFSET));
-		dma_addr = pci_map_page(gp->pdev,
+		dma_addr = dma_map_page(&gp->pdev->dev,
 					virt_to_page(skb->data),
 					offset_in_page(skb->data),
 					RX_BUF_ALLOC_SIZE(gp),
-					PCI_DMA_FROMDEVICE);
+					DMA_FROM_DEVICE);
 		rxd->buffer = cpu_to_le64(dma_addr);
 		dma_wmb();
 		rxd->status_word = cpu_to_le64(RXDCTRL_FRESH(gp));
@@ -2814,10 +2817,8 @@ static void gem_remove_one(struct pci_dev *pdev)
 		cancel_work_sync(&gp->reset_task);
 
 		/* Free resources */
-		pci_free_consistent(pdev,
-				    sizeof(struct gem_init_block),
-				    gp->init_block,
-				    gp->gblock_dvma);
+		dma_free_coherent(&pdev->dev, sizeof(struct gem_init_block),
+				  gp->init_block, gp->gblock_dvma);
 		iounmap(gp->regs);
 		pci_release_regions(pdev);
 		free_netdev(dev);
@@ -2873,10 +2874,10 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (pdev->vendor == PCI_VENDOR_ID_SUN &&
 	    pdev->device == PCI_DEVICE_ID_SUN_GEM &&
-	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	    !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			pr_err("No usable DMA configuration, aborting\n");
 			goto err_disable_device;
@@ -2965,8 +2966,8 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * PAGE_SIZE aligned.
 	 */
 	gp->init_block = (struct gem_init_block *)
-		pci_alloc_consistent(pdev, sizeof(struct gem_init_block),
-				     &gp->gblock_dvma);
+		dma_alloc_coherent(&pdev->dev, sizeof(struct gem_init_block),
+				   &gp->gblock_dvma, GFP_KERNEL);
 	if (!gp->init_block) {
 		pr_err("Cannot allocate init block, aborting\n");
 		err = -ENOMEM;
-- 
2.25.1

