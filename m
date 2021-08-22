Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753443F4108
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhHVTDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:03:08 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:41951 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhHVTDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 15:03:08 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d51 with ME
        id kj2Q250063riaq203j2Q48; Sun, 22 Aug 2021 21:02:25 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Aug 2021 21:02:25 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: 8139cp: switch from 'pci_' to 'dma_' API
Date:   Sun, 22 Aug 2021 21:02:23 +0200
Message-Id: <7d235ccb64d5713b2eec38f10e75d425c15ceef7.1629658846.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/ethernet/realtek/8139cp.c | 31 +++++++++++----------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index edc61906694f..2b84b4565e64 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -514,7 +514,7 @@ static int cp_rx_poll(struct napi_struct *napi, int budget)
 		}
 
 		new_mapping = dma_map_single(&cp->pdev->dev, new_skb->data, buflen,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
 			dev->stats.rx_dropped++;
 			kfree_skb(new_skb);
@@ -522,7 +522,7 @@ static int cp_rx_poll(struct napi_struct *napi, int budget)
 		}
 
 		dma_unmap_single(&cp->pdev->dev, mapping,
-				 buflen, PCI_DMA_FROMDEVICE);
+				 buflen, DMA_FROM_DEVICE);
 
 		/* Handle checksum offloading for incoming packets. */
 		if (cp_rx_csum_ok(status))
@@ -666,7 +666,7 @@ static void cp_tx (struct cp_private *cp)
 
 		dma_unmap_single(&cp->pdev->dev, le64_to_cpu(txd->addr),
 				 cp->tx_opts[tx_tail] & 0xffff,
-				 PCI_DMA_TODEVICE);
+				 DMA_TO_DEVICE);
 
 		if (status & LastFrag) {
 			if (status & (TxError | TxFIFOUnder)) {
@@ -724,7 +724,7 @@ static void unwind_tx_frag_mapping(struct cp_private *cp, struct sk_buff *skb,
 		txd = &cp->tx_ring[index];
 		this_frag = &skb_shinfo(skb)->frags[frag];
 		dma_unmap_single(&cp->pdev->dev, le64_to_cpu(txd->addr),
-				 skb_frag_size(this_frag), PCI_DMA_TODEVICE);
+				 skb_frag_size(this_frag), DMA_TO_DEVICE);
 	}
 }
 
@@ -781,7 +781,7 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 		dma_addr_t mapping;
 
 		len = skb->len;
-		mapping = dma_map_single(&cp->pdev->dev, skb->data, len, PCI_DMA_TODEVICE);
+		mapping = dma_map_single(&cp->pdev->dev, skb->data, len, DMA_TO_DEVICE);
 		if (dma_mapping_error(&cp->pdev->dev, mapping))
 			goto out_dma_error;
 
@@ -810,7 +810,7 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 		first_eor = eor;
 		first_len = skb_headlen(skb);
 		first_mapping = dma_map_single(&cp->pdev->dev, skb->data,
-					       first_len, PCI_DMA_TODEVICE);
+					       first_len, DMA_TO_DEVICE);
 		if (dma_mapping_error(&cp->pdev->dev, first_mapping))
 			goto out_dma_error;
 
@@ -826,7 +826,7 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 			len = skb_frag_size(this_frag);
 			mapping = dma_map_single(&cp->pdev->dev,
 						 skb_frag_address(this_frag),
-						 len, PCI_DMA_TODEVICE);
+						 len, DMA_TO_DEVICE);
 			if (dma_mapping_error(&cp->pdev->dev, mapping)) {
 				unwind_tx_frag_mapping(cp, skb, first_entry, entry);
 				goto out_dma_error;
@@ -1069,7 +1069,7 @@ static int cp_refill_rx(struct cp_private *cp)
 			goto err_out;
 
 		mapping = dma_map_single(&cp->pdev->dev, skb->data,
-					 cp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+					 cp->rx_buf_sz, DMA_FROM_DEVICE);
 		if (dma_mapping_error(&cp->pdev->dev, mapping)) {
 			kfree_skb(skb);
 			goto err_out;
@@ -1139,7 +1139,7 @@ static void cp_clean_rings (struct cp_private *cp)
 		if (cp->rx_skb[i]) {
 			desc = cp->rx_ring + i;
 			dma_unmap_single(&cp->pdev->dev,le64_to_cpu(desc->addr),
-					 cp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+					 cp->rx_buf_sz, DMA_FROM_DEVICE);
 			dev_kfree_skb_any(cp->rx_skb[i]);
 		}
 	}
@@ -1151,7 +1151,7 @@ static void cp_clean_rings (struct cp_private *cp)
 			desc = cp->tx_ring + i;
 			dma_unmap_single(&cp->pdev->dev,le64_to_cpu(desc->addr),
 					 le32_to_cpu(desc->opts1) & 0xffff,
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 			if (le32_to_cpu(desc->opts1) & LastFrag)
 				dev_kfree_skb_any(skb);
 			cp->dev->stats.tx_dropped++;
@@ -1945,24 +1945,17 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Configure DMA attributes. */
 	if ((sizeof(dma_addr_t) > 4) &&
-	    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) &&
-	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
 		pci_using_dac = 0;
 
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_err(&pdev->dev,
 				"No usable DMA configuration, aborting\n");
 			goto err_out_res;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (rc) {
-			dev_err(&pdev->dev,
-				"No usable consistent DMA configuration, aborting\n");
-			goto err_out_res;
-		}
 	}
 
 	cp->cpcmd = (pci_using_dac ? PCIDAC : 0) |
-- 
2.30.2

