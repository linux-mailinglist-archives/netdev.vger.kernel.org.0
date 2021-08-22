Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52803F3E53
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 09:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhHVHox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 03:44:53 -0400
Received: from out02.smtpout.orange.fr ([193.252.22.211]:31812 "EHLO
        out.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbhHVHow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 03:44:52 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d59 with ME
        id kXkA250053riaq203XkAok; Sun, 22 Aug 2021 09:44:11 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Aug 2021 09:44:11 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     imitsyanko@quantenna.com, geomatsi@gmail.com, davem@davemloft.net,
        kvalo@codeaurora.org, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] qtnfmac: switch from 'pci_' to 'dma_' API
Date:   Sun, 22 Aug 2021 09:44:07 +0200
Message-Id: <de7727a8aec3a3e3fae2218a05bdf3c5949b8150.1629618169.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.

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
 .../quantenna/qtnfmac/pcie/pearl_pcie.c       | 28 +++++++++----------
 .../quantenna/qtnfmac/pcie/topaz_pcie.c       | 28 +++++++++----------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 0003df577cb3..840728ed57b2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -295,9 +295,9 @@ static int pearl_skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
 	priv->rx_skb[index] = skb;
 	rxbd = &ps->rx_bd_vbase[index];
 
-	paddr = pci_map_single(priv->pdev, skb->data,
-			       SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(priv->pdev, paddr)) {
+	paddr = dma_map_single(&priv->pdev->dev, skb->data, SKB_BUF_SIZE,
+			       DMA_FROM_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, paddr)) {
 		pr_err("skb DMA mapping error: %pad\n", &paddr);
 		return -ENOMEM;
 	}
@@ -357,8 +357,8 @@ static void qtnf_pearl_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
 			skb = priv->rx_skb[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
 					      le32_to_cpu(rxbd->addr));
-			pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, paddr,
+					 SKB_BUF_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
 			priv->rx_skb[i] = NULL;
 		}
@@ -371,8 +371,8 @@ static void qtnf_pearl_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
 			skb = priv->tx_skb[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
 					      le32_to_cpu(txbd->addr));
-			pci_unmap_single(priv->pdev, paddr, skb->len,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pdev->dev, paddr, skb->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			priv->tx_skb[i] = NULL;
 		}
@@ -485,8 +485,8 @@ static void qtnf_pearl_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
 			txbd = &ps->tx_bd_vbase[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
 					      le32_to_cpu(txbd->addr));
-			pci_unmap_single(priv->pdev, paddr, skb->len,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pdev->dev, paddr, skb->len,
+					 DMA_TO_DEVICE);
 
 			if (skb->dev) {
 				dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
@@ -559,9 +559,9 @@ static int qtnf_pcie_skb_send(struct qtnf_bus *bus, struct sk_buff *skb)
 	priv->tx_skb[i] = skb;
 	len = skb->len;
 
-	skb_paddr = pci_map_single(priv->pdev, skb->data,
-				   skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(priv->pdev, skb_paddr)) {
+	skb_paddr = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
+				   DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, skb_paddr)) {
 		pr_err("skb DMA mapping error: %pad\n", &skb_paddr);
 		ret = -ENOMEM;
 		goto tx_done;
@@ -748,8 +748,8 @@ static int qtnf_pcie_pearl_rx_poll(struct napi_struct *napi, int budget)
 		if (skb) {
 			skb_paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
 						  le32_to_cpu(rxbd->addr));
-			pci_unmap_single(priv->pdev, skb_paddr, SKB_BUF_SIZE,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, skb_paddr,
+					 SKB_BUF_SIZE, DMA_FROM_DEVICE);
 		}
 
 		if (consume) {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index 24f1be8ddcef..9534e1b33780 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -255,9 +255,9 @@ topaz_skb2rbd_attach(struct qtnf_pcie_topaz_state *ts, u16 index, u32 wrap)
 
 	ts->base.rx_skb[index] = skb;
 
-	paddr = pci_map_single(ts->base.pdev, skb->data,
-			       SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(ts->base.pdev, paddr)) {
+	paddr = dma_map_single(&ts->base.pdev->dev, skb->data, SKB_BUF_SIZE,
+			       DMA_FROM_DEVICE);
+	if (dma_mapping_error(&ts->base.pdev->dev, paddr)) {
 		pr_err("skb mapping error: %pad\n", &paddr);
 		return -ENOMEM;
 	}
@@ -306,8 +306,8 @@ static void qtnf_topaz_free_xfer_buffers(struct qtnf_pcie_topaz_state *ts)
 			rxbd = &ts->rx_bd_vbase[i];
 			skb = priv->rx_skb[i];
 			paddr = QTN_HOST_ADDR(0x0, le32_to_cpu(rxbd->addr));
-			pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, paddr,
+					 SKB_BUF_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
 			priv->rx_skb[i] = NULL;
 			rxbd->addr = 0;
@@ -321,8 +321,8 @@ static void qtnf_topaz_free_xfer_buffers(struct qtnf_pcie_topaz_state *ts)
 			txbd = &ts->tx_bd_vbase[i];
 			skb = priv->tx_skb[i];
 			paddr = QTN_HOST_ADDR(0x0, le32_to_cpu(txbd->addr));
-			pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pdev->dev, paddr,
+					 SKB_BUF_SIZE, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			priv->tx_skb[i] = NULL;
 			txbd->addr = 0;
@@ -414,8 +414,8 @@ static void qtnf_topaz_data_tx_reclaim(struct qtnf_pcie_topaz_state *ts)
 		if (likely(skb)) {
 			txbd = &ts->tx_bd_vbase[i];
 			paddr = QTN_HOST_ADDR(0x0, le32_to_cpu(txbd->addr));
-			pci_unmap_single(priv->pdev, paddr, skb->len,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pdev->dev, paddr, skb->len,
+					 DMA_TO_DEVICE);
 
 			if (skb->dev) {
 				dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
@@ -522,9 +522,9 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb,
 	priv->tx_skb[i] = skb;
 	len = skb->len;
 
-	skb_paddr = pci_map_single(priv->pdev, skb->data,
-				   skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(priv->pdev, skb_paddr)) {
+	skb_paddr = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
+				   DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, skb_paddr)) {
 		ret = -ENOMEM;
 		goto tx_done;
 	}
@@ -653,8 +653,8 @@ static int qtnf_topaz_rx_poll(struct napi_struct *napi, int budget)
 
 		if (skb) {
 			skb_paddr = QTN_HOST_ADDR(0x0, le32_to_cpu(rxbd->addr));
-			pci_unmap_single(priv->pdev, skb_paddr, SKB_BUF_SIZE,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, skb_paddr,
+					 SKB_BUF_SIZE, DMA_FROM_DEVICE);
 		}
 
 		if (consume) {
-- 
2.30.2

