Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D725C9F1
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgICUFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:05:35 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:20906 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728304AbgICUFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:05:32 -0400
Received: from localhost.localdomain ([93.22.39.180])
        by mwinf5d73 with ME
        id PY5Q2300C3tCsMp03Y5Rrf; Thu, 03 Sep 2020 22:05:29 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 03 Sep 2020 22:05:29 +0200
X-ME-IP: 93.22.39.180
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        mkubecek@suse.cz, snelson@pensando.io, vaibhavgupta40@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH RESEND] epic100: switch from 'pci_' to 'dma_' API
Date:   Thu,  3 Sep 2020 22:05:09 +0200
Message-Id: <20200903200509.296149-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'epic_init_one()', GFP_KERNEL can be used
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

RESEND because it was previously sent when the branch was closed
---
 drivers/net/ethernet/smsc/epic100.c | 71 +++++++++++++++++------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index d950b312c418..51cd7dca91cd 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -374,13 +374,15 @@ static int epic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ep->mii.phy_id_mask = 0x1f;
 	ep->mii.reg_num_mask = 0x1f;
 
-	ring_space = pci_alloc_consistent(pdev, TX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_iounmap;
 	ep->tx_ring = ring_space;
 	ep->tx_ring_dma = ring_dma;
 
-	ring_space = pci_alloc_consistent(pdev, RX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, RX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_unmap_tx;
 	ep->rx_ring = ring_space;
@@ -493,9 +495,11 @@ static int epic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 err_out_unmap_rx:
-	pci_free_consistent(pdev, RX_TOTAL_SIZE, ep->rx_ring, ep->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, ep->rx_ring,
+			  ep->rx_ring_dma);
 err_out_unmap_tx:
-	pci_free_consistent(pdev, TX_TOTAL_SIZE, ep->tx_ring, ep->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, ep->tx_ring,
+			  ep->tx_ring_dma);
 err_out_iounmap:
 	pci_iounmap(pdev, ioaddr);
 err_out_free_netdev:
@@ -918,8 +922,10 @@ static void epic_init_ring(struct net_device *dev)
 		if (skb == NULL)
 			break;
 		skb_reserve(skb, 2);	/* 16 byte align the IP header. */
-		ep->rx_ring[i].bufaddr = pci_map_single(ep->pci_dev,
-			skb->data, ep->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		ep->rx_ring[i].bufaddr = dma_map_single(&ep->pci_dev->dev,
+							skb->data,
+							ep->rx_buf_sz,
+							DMA_FROM_DEVICE);
 		ep->rx_ring[i].rxstatus = DescOwn;
 	}
 	ep->dirty_rx = (unsigned int)(i - RX_RING_SIZE);
@@ -955,8 +961,9 @@ static netdev_tx_t epic_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	entry = ep->cur_tx % TX_RING_SIZE;
 
 	ep->tx_skbuff[entry] = skb;
-	ep->tx_ring[entry].bufaddr = pci_map_single(ep->pci_dev, skb->data,
-		 			            skb->len, PCI_DMA_TODEVICE);
+	ep->tx_ring[entry].bufaddr = dma_map_single(&ep->pci_dev->dev,
+						    skb->data, skb->len,
+						    DMA_TO_DEVICE);
 	if (free_count < TX_QUEUE_LEN/2) {/* Typical path */
 		ctrl_word = 0x100000; /* No interrupt */
 	} else if (free_count == TX_QUEUE_LEN/2) {
@@ -1036,8 +1043,9 @@ static void epic_tx(struct net_device *dev, struct epic_private *ep)
 
 		/* Free the original skb. */
 		skb = ep->tx_skbuff[entry];
-		pci_unmap_single(ep->pci_dev, ep->tx_ring[entry].bufaddr,
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&ep->pci_dev->dev,
+				 ep->tx_ring[entry].bufaddr, skb->len,
+				 DMA_TO_DEVICE);
 		dev_consume_skb_irq(skb);
 		ep->tx_skbuff[entry] = NULL;
 	}
@@ -1178,20 +1186,21 @@ static int epic_rx(struct net_device *dev, int budget)
 			if (pkt_len < rx_copybreak &&
 			    (skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {
 				skb_reserve(skb, 2);	/* 16 byte align the IP header */
-				pci_dma_sync_single_for_cpu(ep->pci_dev,
-							    ep->rx_ring[entry].bufaddr,
-							    ep->rx_buf_sz,
-							    PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&ep->pci_dev->dev,
+							ep->rx_ring[entry].bufaddr,
+							ep->rx_buf_sz,
+							DMA_FROM_DEVICE);
 				skb_copy_to_linear_data(skb, ep->rx_skbuff[entry]->data, pkt_len);
 				skb_put(skb, pkt_len);
-				pci_dma_sync_single_for_device(ep->pci_dev,
-							       ep->rx_ring[entry].bufaddr,
-							       ep->rx_buf_sz,
-							       PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&ep->pci_dev->dev,
+							   ep->rx_ring[entry].bufaddr,
+							   ep->rx_buf_sz,
+							   DMA_FROM_DEVICE);
 			} else {
-				pci_unmap_single(ep->pci_dev,
-					ep->rx_ring[entry].bufaddr,
-					ep->rx_buf_sz, PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&ep->pci_dev->dev,
+						 ep->rx_ring[entry].bufaddr,
+						 ep->rx_buf_sz,
+						 DMA_FROM_DEVICE);
 				skb_put(skb = ep->rx_skbuff[entry], pkt_len);
 				ep->rx_skbuff[entry] = NULL;
 			}
@@ -1213,8 +1222,10 @@ static int epic_rx(struct net_device *dev, int budget)
 			if (skb == NULL)
 				break;
 			skb_reserve(skb, 2);	/* Align IP on 16 byte boundaries */
-			ep->rx_ring[entry].bufaddr = pci_map_single(ep->pci_dev,
-				skb->data, ep->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			ep->rx_ring[entry].bufaddr = dma_map_single(&ep->pci_dev->dev,
+								    skb->data,
+								    ep->rx_buf_sz,
+								    DMA_FROM_DEVICE);
 			work_done++;
 		}
 		/* AV: shouldn't we add a barrier here? */
@@ -1294,8 +1305,8 @@ static int epic_close(struct net_device *dev)
 		ep->rx_ring[i].rxstatus = 0;		/* Not owned by Epic chip. */
 		ep->rx_ring[i].buflength = 0;
 		if (skb) {
-			pci_unmap_single(pdev, ep->rx_ring[i].bufaddr,
-					 ep->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&pdev->dev, ep->rx_ring[i].bufaddr,
+					 ep->rx_buf_sz, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 		}
 		ep->rx_ring[i].bufaddr = 0xBADF00D0; /* An invalid address. */
@@ -1305,8 +1316,8 @@ static int epic_close(struct net_device *dev)
 		ep->tx_skbuff[i] = NULL;
 		if (!skb)
 			continue;
-		pci_unmap_single(pdev, ep->tx_ring[i].bufaddr, skb->len,
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&pdev->dev, ep->tx_ring[i].bufaddr, skb->len,
+				 DMA_TO_DEVICE);
 		dev_kfree_skb(skb);
 	}
 
@@ -1502,8 +1513,10 @@ static void epic_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct epic_private *ep = netdev_priv(dev);
 
-	pci_free_consistent(pdev, TX_TOTAL_SIZE, ep->tx_ring, ep->tx_ring_dma);
-	pci_free_consistent(pdev, RX_TOTAL_SIZE, ep->rx_ring, ep->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, ep->tx_ring,
+			  ep->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, ep->rx_ring,
+			  ep->rx_ring_dma);
 	unregister_netdev(dev);
 	pci_iounmap(pdev, ep->ioaddr);
 	pci_release_regions(pdev);
-- 
2.25.1

