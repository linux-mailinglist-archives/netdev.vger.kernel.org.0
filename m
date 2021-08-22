Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E6E3F4118
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhHVTN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:13:27 -0400
Received: from out02.smtpout.orange.fr ([193.252.22.211]:47035 "EHLO
        out.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhHVTNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 15:13:25 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d51 with ME
        id kjCi250013riaq203jCiV0; Sun, 22 Aug 2021 21:12:42 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Aug 2021 21:12:42 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        saeedm@nvidia.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/mellanox: switch from 'pci_' to 'dma_' API
Date:   Sun, 22 Aug 2021 21:12:41 +0200
Message-Id: <33167c57d1aaec10f130fe7604d6db3a43cfa381.1629659490.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c     | 14 +++++++-------
 drivers/net/ethernet/mellanox/mlx4/main.c      | 13 ++-----------
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 16 ++--------------
 4 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 442991d91c15..7f6d3b82c29b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -991,7 +991,7 @@ void mlx4_en_calc_rx_buf(struct net_device *dev)
 		 * expense of more costly truesize accounting
 		 */
 		priv->frag_info[0].frag_stride = PAGE_SIZE;
-		priv->dma_dir = PCI_DMA_BIDIRECTIONAL;
+		priv->dma_dir = DMA_BIDIRECTIONAL;
 		priv->rx_headroom = XDP_PACKET_HEADROOM;
 		i = 1;
 	} else {
@@ -1021,7 +1021,7 @@ void mlx4_en_calc_rx_buf(struct net_device *dev)
 			buf_size += frag_size;
 			i++;
 		}
-		priv->dma_dir = PCI_DMA_FROMDEVICE;
+		priv->dma_dir = DMA_FROM_DEVICE;
 		priv->rx_headroom = 0;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 31b74bddb7cd..c56b9dba4c71 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -297,12 +297,12 @@ u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
 			dma_unmap_single(priv->ddev,
 					 tx_info->map0_dma,
 					 tx_info->map0_byte_count,
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 		else
 			dma_unmap_page(priv->ddev,
 				       tx_info->map0_dma,
 				       tx_info->map0_byte_count,
-				       PCI_DMA_TODEVICE);
+				       DMA_TO_DEVICE);
 		/* Optimize the common case when there are no wraparounds */
 		if (likely((void *)tx_desc +
 			   (tx_info->nr_txbb << LOG_TXBB_SIZE) <= end)) {
@@ -311,7 +311,7 @@ u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
 				dma_unmap_page(priv->ddev,
 					(dma_addr_t)be64_to_cpu(data->addr),
 					be32_to_cpu(data->byte_count),
-					PCI_DMA_TODEVICE);
+					DMA_TO_DEVICE);
 			}
 		} else {
 			if ((void *)data >= end)
@@ -325,7 +325,7 @@ u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
 				dma_unmap_page(priv->ddev,
 					(dma_addr_t)be64_to_cpu(data->addr),
 					be32_to_cpu(data->byte_count),
-					PCI_DMA_TODEVICE);
+					DMA_TO_DEVICE);
 			}
 		}
 	}
@@ -831,7 +831,7 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
 
 		dma = dma_map_single(ddev, skb->data +
 				     lso_header_size, byte_count,
-				     PCI_DMA_TODEVICE);
+				     DMA_TO_DEVICE);
 		if (dma_mapping_error(ddev, dma))
 			goto tx_drop_unmap;
 
@@ -853,7 +853,7 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
 		++data;
 		dma_unmap_page(ddev, (dma_addr_t)be64_to_cpu(data->addr),
 			       be32_to_cpu(data->byte_count),
-			       PCI_DMA_TODEVICE);
+			       DMA_TO_DEVICE);
 	}
 
 	return false;
@@ -1170,7 +1170,7 @@ netdev_tx_t mlx4_en_xmit_frame(struct mlx4_en_rx_ring *rx_ring,
 	tx_info->nr_bytes = max_t(unsigned int, length, ETH_ZLEN);
 
 	dma_sync_single_range_for_device(priv->ddev, dma, frame->page_offset,
-					 length, PCI_DMA_TODEVICE);
+					 length, DMA_TO_DEVICE);
 
 	data->addr = cpu_to_be64(dma + frame->page_offset);
 	dma_wmb();
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 7267c6c6d2e2..5a6b0fcaf7f8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3806,24 +3806,15 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask\n");
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
 			goto err_release_regions;
 		}
 	}
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (err) {
-		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit consistent PCI DMA mask\n");
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, aborting\n");
-			goto err_release_regions;
-		}
-	}
 
 	/* Allow large DMA segments, up to the firmware limit of 1 GB */
 	dma_set_max_seg_size(&pdev->dev, 1024 * 1024 * 1024);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 80cabf9b1787..79482824c64f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -252,28 +252,16 @@ static int set_dma_caps(struct pci_dev *pdev)
 {
 	int err;
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask\n");
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
 			return err;
 		}
 	}
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (err) {
-		dev_warn(&pdev->dev,
-			 "Warning: couldn't set 64-bit consistent PCI DMA mask\n");
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"Can't set consistent PCI DMA mask, aborting\n");
-			return err;
-		}
-	}
-
 	dma_set_max_seg_size(&pdev->dev, 2u * 1024 * 1024 * 1024);
 	return err;
 }
-- 
2.30.2

