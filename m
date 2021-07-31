Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2AF3DC44E
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 09:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhGaHKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 03:10:16 -0400
Received: from out06.smtpout.orange.fr ([193.252.22.215]:27555 "EHLO
        out.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhGaHKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 03:10:15 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d21 with ME
        id bjA02500g21Fzsu03jA1bv; Sat, 31 Jul 2021 09:10:06 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 31 Jul 2021 09:10:06 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] cavium: switch from 'pci_' to 'dma_' API
Date:   Sat, 31 Jul 2021 09:10:00 +0200
Message-Id: <27c2b1a5152add2b3ecdfded40f562c5e4abed14.1627714392.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below. It has been
hand modified to use 'dma_set_mask_and_coherent()' instead of
'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.

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
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 4 ++--
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c | 4 ++--
 drivers/net/ethernet/cavium/thunder/nic_main.c     | 8 +-------
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   | 8 +-------
 4 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index a4a5209a9386..af116ef83bad 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1457,7 +1457,7 @@ static void free_netsgbuf(void *buf)
 	while (frags--) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
-		pci_unmap_page((lio->oct_dev)->pci_dev,
+		dma_unmap_page(&lio->oct_dev->pci_dev->dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
 			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
@@ -1500,7 +1500,7 @@ static void free_netsgbuf_with_resp(void *buf)
 	while (frags--) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
-		pci_unmap_page((lio->oct_dev)->pci_dev,
+		dma_unmap_page(&lio->oct_dev->pci_dev->dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
 			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 3085dd455a17..c6fe0f2a4d0e 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -843,7 +843,7 @@ static void free_netsgbuf(void *buf)
 	while (frags--) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
-		pci_unmap_page((lio->oct_dev)->pci_dev,
+		dma_unmap_page(&lio->oct_dev->pci_dev->dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
 			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
@@ -887,7 +887,7 @@ static void free_netsgbuf_with_resp(void *buf)
 	while (frags--) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
-		pci_unmap_page((lio->oct_dev)->pci_dev,
+		dma_unmap_page(&lio->oct_dev->pci_dev->dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
 			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
diff --git a/drivers/net/ethernet/cavium/thunder/nic_main.c b/drivers/net/ethernet/cavium/thunder/nic_main.c
index 9361f964bb9b..691e1475d55e 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1322,18 +1322,12 @@ static int nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_disable_device;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (err) {
 		dev_err(dev, "Unable to get usable DMA configuration\n");
 		goto err_release_regions;
 	}
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
-	if (err) {
-		dev_err(dev, "Unable to get 48-bit DMA for consistent allocations\n");
-		goto err_release_regions;
-	}
-
 	/* MAP PF's configuration registers */
 	nic->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
 	if (!nic->reg_base) {
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index efaaa57d4ed5..d1667b759522 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2130,18 +2130,12 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_disable_device;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(48));
 	if (err) {
 		dev_err(dev, "Unable to get usable DMA configuration\n");
 		goto err_release_regions;
 	}
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
-	if (err) {
-		dev_err(dev, "unable to get 48-bit DMA for consistent allocations\n");
-		goto err_release_regions;
-	}
-
 	qcount = netif_get_num_default_rss_queues();
 
 	/* Restrict multiqset support only for host bound VFs */
-- 
2.30.2

