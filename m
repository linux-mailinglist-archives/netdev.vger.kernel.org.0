Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E712295F1
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbgGVK1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:27:16 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:19717 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgGVK1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:27:15 -0400
Received: from localhost.localdomain ([93.23.199.134])
        by mwinf5d52 with ME
        id 6AT9230072uUVcV03AT9GJ; Wed, 22 Jul 2020 12:27:11 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 22 Jul 2020 12:27:11 +0200
X-ME-IP: 93.23.199.134
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     chunkeey@googlemail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] p54: switch from 'pci_' to 'dma_' API
Date:   Wed, 22 Jul 2020 12:27:07 +0200
Message-Id: <20200722102707.27486-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'p54p_probe()', GFP_KERNEL can be used because
it is the probe function and no spin_lock is taken in the between.


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
 drivers/net/wireless/intersil/p54/p54pci.c | 65 ++++++++++++----------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
index 80ad0b7eaef4..9d96c8b8409d 100644
--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -153,12 +153,12 @@ static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
 			if (!skb)
 				break;
 
-			mapping = pci_map_single(priv->pdev,
+			mapping = dma_map_single(&priv->pdev->dev,
 						 skb_tail_pointer(skb),
 						 priv->common.rx_mtu + 32,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 
-			if (pci_dma_mapping_error(priv->pdev, mapping)) {
+			if (dma_mapping_error(&priv->pdev->dev, mapping)) {
 				dev_kfree_skb_any(skb);
 				dev_err(&priv->pdev->dev,
 					"RX DMA Mapping error\n");
@@ -215,19 +215,22 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
 			len = priv->common.rx_mtu;
 		}
 		dma_addr = le32_to_cpu(desc->host_addr);
-		pci_dma_sync_single_for_cpu(priv->pdev, dma_addr,
-			priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&priv->pdev->dev, dma_addr,
+					priv->common.rx_mtu + 32,
+					DMA_FROM_DEVICE);
 		skb_put(skb, len);
 
 		if (p54_rx(dev, skb)) {
-			pci_unmap_single(priv->pdev, dma_addr,
-				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, dma_addr,
+					 priv->common.rx_mtu + 32,
+					 DMA_FROM_DEVICE);
 			rx_buf[i] = NULL;
 			desc->host_addr = cpu_to_le32(0);
 		} else {
 			skb_trim(skb, 0);
-			pci_dma_sync_single_for_device(priv->pdev, dma_addr,
-				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&priv->pdev->dev, dma_addr,
+						   priv->common.rx_mtu + 32,
+						   DMA_FROM_DEVICE);
 			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
 		}
 
@@ -258,8 +261,9 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 		skb = tx_buf[i];
 		tx_buf[i] = NULL;
 
-		pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
-				 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pdev->dev,
+				 le32_to_cpu(desc->host_addr),
+				 le16_to_cpu(desc->len), DMA_TO_DEVICE);
 
 		desc->host_addr = 0;
 		desc->device_addr = 0;
@@ -334,9 +338,9 @@ static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
 
-	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
-				 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(priv->pdev, mapping)) {
+	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, mapping)) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		p54_free_skb(dev, skb);
 		dev_err(&priv->pdev->dev, "TX DMA mapping error\n");
@@ -378,10 +382,10 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	for (i = 0; i < ARRAY_SIZE(priv->rx_buf_data); i++) {
 		desc = &ring_control->rx_data[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 le32_to_cpu(desc->host_addr),
 					 priv->common.rx_mtu + 32,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 		kfree_skb(priv->rx_buf_data[i]);
 		priv->rx_buf_data[i] = NULL;
 	}
@@ -389,10 +393,10 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	for (i = 0; i < ARRAY_SIZE(priv->rx_buf_mgmt); i++) {
 		desc = &ring_control->rx_mgmt[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 le32_to_cpu(desc->host_addr),
 					 priv->common.rx_mtu + 32,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 		kfree_skb(priv->rx_buf_mgmt[i]);
 		priv->rx_buf_mgmt[i] = NULL;
 	}
@@ -400,10 +404,10 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	for (i = 0; i < ARRAY_SIZE(priv->tx_buf_data); i++) {
 		desc = &ring_control->tx_data[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 le32_to_cpu(desc->host_addr),
 					 le16_to_cpu(desc->len),
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 
 		p54_free_skb(dev, priv->tx_buf_data[i]);
 		priv->tx_buf_data[i] = NULL;
@@ -412,10 +416,10 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	for (i = 0; i < ARRAY_SIZE(priv->tx_buf_mgmt); i++) {
 		desc = &ring_control->tx_mgmt[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 le32_to_cpu(desc->host_addr),
 					 le16_to_cpu(desc->len),
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 
 		p54_free_skb(dev, priv->tx_buf_mgmt[i]);
 		priv->tx_buf_mgmt[i] = NULL;
@@ -568,9 +572,9 @@ static int p54p_probe(struct pci_dev *pdev,
 		goto err_disable_dev;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_err(&pdev->dev, "No suitable DMA available\n");
 		goto err_free_reg;
@@ -603,8 +607,9 @@ static int p54p_probe(struct pci_dev *pdev,
 		goto err_free_dev;
 	}
 
-	priv->ring_control = pci_alloc_consistent(pdev, sizeof(*priv->ring_control),
-						  &priv->ring_control_dma);
+	priv->ring_control = dma_alloc_coherent(&pdev->dev,
+						sizeof(*priv->ring_control),
+						&priv->ring_control_dma, GFP_KERNEL);
 	if (!priv->ring_control) {
 		dev_err(&pdev->dev, "Cannot allocate rings\n");
 		err = -ENOMEM;
@@ -623,8 +628,8 @@ static int p54p_probe(struct pci_dev *pdev,
 	if (!err)
 		return 0;
 
-	pci_free_consistent(pdev, sizeof(*priv->ring_control),
-			    priv->ring_control, priv->ring_control_dma);
+	dma_free_coherent(&pdev->dev, sizeof(*priv->ring_control),
+			  priv->ring_control, priv->ring_control_dma);
 
  err_iounmap:
 	iounmap(priv->map);
@@ -653,8 +658,8 @@ static void p54p_remove(struct pci_dev *pdev)
 	wait_for_completion(&priv->fw_loaded);
 	p54_unregister_common(dev);
 	release_firmware(priv->firmware);
-	pci_free_consistent(pdev, sizeof(*priv->ring_control),
-			    priv->ring_control, priv->ring_control_dma);
+	dma_free_coherent(&pdev->dev, sizeof(*priv->ring_control),
+			  priv->ring_control, priv->ring_control_dma);
 	iounmap(priv->map);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.25.1

