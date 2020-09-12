Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E582A267A10
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 13:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgILLob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 07:44:31 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:27470 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgILLoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 07:44:25 -0400
Received: from localhost.localdomain ([93.22.150.101])
        by mwinf5d26 with ME
        id SzkL230082BWSNM03zkMqK; Sat, 12 Sep 2020 13:44:21 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Sep 2020 13:44:21 +0200
X-ME-IP: 93.22.150.101
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rocker: switch from 'pci_' to 'dma_' API
Date:   Sat, 12 Sep 2020 13:44:18 +0200
Message-Id: <20200912114418.340728-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'rocker_dma_ring_create()' GFP_KERNEL can be
used because it is already used in the same function just a few lines
above.


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
 drivers/net/ethernet/rocker/rocker_main.c | 83 ++++++++++++-----------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 42458a46ffaf..b35b27720175 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -200,9 +200,9 @@ static int rocker_dma_test_offset(const struct rocker *rocker,
 	buf = alloc + offset;
 	expect = buf + ROCKER_TEST_DMA_BUF_SIZE;
 
-	dma_handle = pci_map_single(pdev, buf, ROCKER_TEST_DMA_BUF_SIZE,
-				    PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(pdev, dma_handle)) {
+	dma_handle = dma_map_single(&pdev->dev, buf, ROCKER_TEST_DMA_BUF_SIZE,
+				    DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, dma_handle)) {
 		err = -EIO;
 		goto free_alloc;
 	}
@@ -234,8 +234,8 @@ static int rocker_dma_test_offset(const struct rocker *rocker,
 		goto unmap;
 
 unmap:
-	pci_unmap_single(pdev, dma_handle, ROCKER_TEST_DMA_BUF_SIZE,
-			 PCI_DMA_BIDIRECTIONAL);
+	dma_unmap_single(&pdev->dev, dma_handle, ROCKER_TEST_DMA_BUF_SIZE,
+			 DMA_BIDIRECTIONAL);
 free_alloc:
 	kfree(alloc);
 
@@ -441,9 +441,9 @@ static int rocker_dma_ring_create(const struct rocker *rocker,
 	if (!info->desc_info)
 		return -ENOMEM;
 
-	info->desc = pci_alloc_consistent(rocker->pdev,
-					  info->size * sizeof(*info->desc),
-					  &info->mapaddr);
+	info->desc = dma_alloc_coherent(&rocker->pdev->dev,
+					info->size * sizeof(*info->desc),
+					&info->mapaddr, GFP_KERNEL);
 	if (!info->desc) {
 		kfree(info->desc_info);
 		return -ENOMEM;
@@ -465,9 +465,9 @@ static void rocker_dma_ring_destroy(const struct rocker *rocker,
 {
 	rocker_write64(rocker, DMA_DESC_ADDR(info->type), 0);
 
-	pci_free_consistent(rocker->pdev,
-			    info->size * sizeof(struct rocker_desc),
-			    info->desc, info->mapaddr);
+	dma_free_coherent(&rocker->pdev->dev,
+			  info->size * sizeof(struct rocker_desc), info->desc,
+			  info->mapaddr);
 	kfree(info->desc_info);
 }
 
@@ -506,8 +506,9 @@ static int rocker_dma_ring_bufs_alloc(const struct rocker *rocker,
 			goto rollback;
 		}
 
-		dma_handle = pci_map_single(pdev, buf, buf_size, direction);
-		if (pci_dma_mapping_error(pdev, dma_handle)) {
+		dma_handle = dma_map_single(&pdev->dev, buf, buf_size,
+					    direction);
+		if (dma_mapping_error(&pdev->dev, dma_handle)) {
 			kfree(buf);
 			err = -EIO;
 			goto rollback;
@@ -526,7 +527,8 @@ static int rocker_dma_ring_bufs_alloc(const struct rocker *rocker,
 	for (i--; i >= 0; i--) {
 		const struct rocker_desc_info *desc_info = &info->desc_info[i];
 
-		pci_unmap_single(pdev, dma_unmap_addr(desc_info, mapaddr),
+		dma_unmap_single(&pdev->dev,
+				 dma_unmap_addr(desc_info, mapaddr),
 				 desc_info->data_size, direction);
 		kfree(desc_info->data);
 	}
@@ -546,7 +548,8 @@ static void rocker_dma_ring_bufs_free(const struct rocker *rocker,
 
 		desc->buf_addr = 0;
 		desc->buf_size = 0;
-		pci_unmap_single(pdev, dma_unmap_addr(desc_info, mapaddr),
+		dma_unmap_single(&pdev->dev,
+				 dma_unmap_addr(desc_info, mapaddr),
 				 desc_info->data_size, direction);
 		kfree(desc_info->data);
 	}
@@ -615,7 +618,7 @@ static int rocker_dma_rings_init(struct rocker *rocker)
 	spin_lock_init(&rocker->cmd_ring_lock);
 
 	err = rocker_dma_ring_bufs_alloc(rocker, &rocker->cmd_ring,
-					 PCI_DMA_BIDIRECTIONAL, PAGE_SIZE);
+					 DMA_BIDIRECTIONAL, PAGE_SIZE);
 	if (err) {
 		dev_err(&pdev->dev, "failed to alloc command dma ring buffers\n");
 		goto err_dma_cmd_ring_bufs_alloc;
@@ -636,7 +639,7 @@ static int rocker_dma_rings_init(struct rocker *rocker)
 	}
 
 	err = rocker_dma_ring_bufs_alloc(rocker, &rocker->event_ring,
-					 PCI_DMA_FROMDEVICE, PAGE_SIZE);
+					 DMA_FROM_DEVICE, PAGE_SIZE);
 	if (err) {
 		dev_err(&pdev->dev, "failed to alloc event dma ring buffers\n");
 		goto err_dma_event_ring_bufs_alloc;
@@ -650,7 +653,7 @@ static int rocker_dma_rings_init(struct rocker *rocker)
 	rocker_dma_cmd_ring_waits_free(rocker);
 err_dma_cmd_ring_waits_alloc:
 	rocker_dma_ring_bufs_free(rocker, &rocker->cmd_ring,
-				  PCI_DMA_BIDIRECTIONAL);
+				  DMA_BIDIRECTIONAL);
 err_dma_cmd_ring_bufs_alloc:
 	rocker_dma_ring_destroy(rocker, &rocker->cmd_ring);
 	return err;
@@ -659,11 +662,11 @@ static int rocker_dma_rings_init(struct rocker *rocker)
 static void rocker_dma_rings_fini(struct rocker *rocker)
 {
 	rocker_dma_ring_bufs_free(rocker, &rocker->event_ring,
-				  PCI_DMA_BIDIRECTIONAL);
+				  DMA_BIDIRECTIONAL);
 	rocker_dma_ring_destroy(rocker, &rocker->event_ring);
 	rocker_dma_cmd_ring_waits_free(rocker);
 	rocker_dma_ring_bufs_free(rocker, &rocker->cmd_ring,
-				  PCI_DMA_BIDIRECTIONAL);
+				  DMA_BIDIRECTIONAL);
 	rocker_dma_ring_destroy(rocker, &rocker->cmd_ring);
 }
 
@@ -675,9 +678,9 @@ static int rocker_dma_rx_ring_skb_map(const struct rocker_port *rocker_port,
 	struct pci_dev *pdev = rocker->pdev;
 	dma_addr_t dma_handle;
 
-	dma_handle = pci_map_single(pdev, skb->data, buf_len,
-				    PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(pdev, dma_handle))
+	dma_handle = dma_map_single(&pdev->dev, skb->data, buf_len,
+				    DMA_FROM_DEVICE);
+	if (dma_mapping_error(&pdev->dev, dma_handle))
 		return -EIO;
 	if (rocker_tlv_put_u64(desc_info, ROCKER_TLV_RX_FRAG_ADDR, dma_handle))
 		goto tlv_put_failure;
@@ -686,7 +689,7 @@ static int rocker_dma_rx_ring_skb_map(const struct rocker_port *rocker_port,
 	return 0;
 
 tlv_put_failure:
-	pci_unmap_single(pdev, dma_handle, buf_len, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pdev->dev, dma_handle, buf_len, DMA_FROM_DEVICE);
 	desc_info->tlv_size = 0;
 	return -EMSGSIZE;
 }
@@ -734,7 +737,7 @@ static void rocker_dma_rx_ring_skb_unmap(const struct rocker *rocker,
 		return;
 	dma_handle = rocker_tlv_get_u64(attrs[ROCKER_TLV_RX_FRAG_ADDR]);
 	len = rocker_tlv_get_u16(attrs[ROCKER_TLV_RX_FRAG_MAX_LEN]);
-	pci_unmap_single(pdev, dma_handle, len, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pdev->dev, dma_handle, len, DMA_FROM_DEVICE);
 }
 
 static void rocker_dma_rx_ring_skb_free(const struct rocker *rocker,
@@ -796,7 +799,7 @@ static int rocker_port_dma_rings_init(struct rocker_port *rocker_port)
 	}
 
 	err = rocker_dma_ring_bufs_alloc(rocker, &rocker_port->tx_ring,
-					 PCI_DMA_TODEVICE,
+					 DMA_TO_DEVICE,
 					 ROCKER_DMA_TX_DESC_SIZE);
 	if (err) {
 		netdev_err(rocker_port->dev, "failed to alloc tx dma ring buffers\n");
@@ -813,7 +816,7 @@ static int rocker_port_dma_rings_init(struct rocker_port *rocker_port)
 	}
 
 	err = rocker_dma_ring_bufs_alloc(rocker, &rocker_port->rx_ring,
-					 PCI_DMA_BIDIRECTIONAL,
+					 DMA_BIDIRECTIONAL,
 					 ROCKER_DMA_RX_DESC_SIZE);
 	if (err) {
 		netdev_err(rocker_port->dev, "failed to alloc rx dma ring buffers\n");
@@ -831,12 +834,12 @@ static int rocker_port_dma_rings_init(struct rocker_port *rocker_port)
 
 err_dma_rx_ring_skbs_alloc:
 	rocker_dma_ring_bufs_free(rocker, &rocker_port->rx_ring,
-				  PCI_DMA_BIDIRECTIONAL);
+				  DMA_BIDIRECTIONAL);
 err_dma_rx_ring_bufs_alloc:
 	rocker_dma_ring_destroy(rocker, &rocker_port->rx_ring);
 err_dma_rx_ring_create:
 	rocker_dma_ring_bufs_free(rocker, &rocker_port->tx_ring,
-				  PCI_DMA_TODEVICE);
+				  DMA_TO_DEVICE);
 err_dma_tx_ring_bufs_alloc:
 	rocker_dma_ring_destroy(rocker, &rocker_port->tx_ring);
 	return err;
@@ -848,10 +851,10 @@ static void rocker_port_dma_rings_fini(struct rocker_port *rocker_port)
 
 	rocker_dma_rx_ring_skbs_free(rocker_port);
 	rocker_dma_ring_bufs_free(rocker, &rocker_port->rx_ring,
-				  PCI_DMA_BIDIRECTIONAL);
+				  DMA_BIDIRECTIONAL);
 	rocker_dma_ring_destroy(rocker, &rocker_port->rx_ring);
 	rocker_dma_ring_bufs_free(rocker, &rocker_port->tx_ring,
-				  PCI_DMA_TODEVICE);
+				  DMA_TO_DEVICE);
 	rocker_dma_ring_destroy(rocker, &rocker_port->tx_ring);
 }
 
@@ -1858,7 +1861,7 @@ static void rocker_tx_desc_frags_unmap(const struct rocker_port *rocker_port,
 			continue;
 		dma_handle = rocker_tlv_get_u64(frag_attrs[ROCKER_TLV_TX_FRAG_ATTR_ADDR]);
 		len = rocker_tlv_get_u16(frag_attrs[ROCKER_TLV_TX_FRAG_ATTR_LEN]);
-		pci_unmap_single(pdev, dma_handle, len, DMA_TO_DEVICE);
+		dma_unmap_single(&pdev->dev, dma_handle, len, DMA_TO_DEVICE);
 	}
 }
 
@@ -1871,8 +1874,8 @@ static int rocker_tx_desc_frag_map_put(const struct rocker_port *rocker_port,
 	dma_addr_t dma_handle;
 	struct rocker_tlv *frag;
 
-	dma_handle = pci_map_single(pdev, buf, buf_len, DMA_TO_DEVICE);
-	if (unlikely(pci_dma_mapping_error(pdev, dma_handle))) {
+	dma_handle = dma_map_single(&pdev->dev, buf, buf_len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(&pdev->dev, dma_handle))) {
 		if (net_ratelimit())
 			netdev_err(rocker_port->dev, "failed to dma map tx frag\n");
 		return -EIO;
@@ -1892,7 +1895,7 @@ static int rocker_tx_desc_frag_map_put(const struct rocker_port *rocker_port,
 nest_cancel:
 	rocker_tlv_nest_cancel(desc_info, frag);
 unmap_frag:
-	pci_unmap_single(pdev, dma_handle, buf_len, DMA_TO_DEVICE);
+	dma_unmap_single(&pdev->dev, dma_handle, buf_len, DMA_TO_DEVICE);
 	return -EMSGSIZE;
 }
 
@@ -2905,17 +2908,17 @@ static int rocker_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_pci_request_regions;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (!err) {
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (err) {
-			dev_err(&pdev->dev, "pci_set_consistent_dma_mask failed\n");
+			dev_err(&pdev->dev, "dma_set_coherent_mask failed\n");
 			goto err_pci_set_dma_mask;
 		}
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
-			dev_err(&pdev->dev, "pci_set_dma_mask failed\n");
+			dev_err(&pdev->dev, "dma_set_mask failed\n");
 			goto err_pci_set_dma_mask;
 		}
 	}
-- 
2.25.1

