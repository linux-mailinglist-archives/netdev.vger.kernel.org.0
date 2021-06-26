Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2748A3B4F33
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFZP1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 11:27:40 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:45782 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhFZP1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 11:27:37 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d78 with ME
        id MrR62500921Fzsu03rR6lY; Sat, 26 Jun 2021 17:25:11 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 26 Jun 2021 17:25:11 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        jirislaby@kernel.org, mickflemm@gmail.com, mcgrof@kernel.org
Cc:     ath9k-devel@qca.qualcomm.com, ath10k@lists.infradead.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ath: switch from 'pci_' to 'dma_' API
Date:   Sat, 26 Jun 2021 17:25:04 +0200
Message-Id: <9150bd6cde9ad592aff8ee3ad94dffa90b004e89.1624720959.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.

While at it, some 'dma_set_mask()/dma_set_coherent_mask()' have been
updated to a much less verbose 'dma_set_mask_and_coherent()'.

@@ @@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@ @@
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
 drivers/net/wireless/ath/ath10k/pci.c |  9 +--------
 drivers/net/wireless/ath/ath11k/pci.c | 10 ++--------
 drivers/net/wireless/ath/ath5k/pci.c  |  2 +-
 drivers/net/wireless/ath/ath9k/pci.c  |  8 +-------
 4 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 71878ab35b93..4d4e2f91e15c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3393,19 +3393,12 @@ static int ath10k_pci_claim(struct ath10k *ar)
 	}
 
 	/* Target expects 32 bit DMA. Enforce it. */
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
 		ath10k_err(ar, "failed to set dma mask to 32-bit: %d\n", ret);
 		goto err_region;
 	}
 
-	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-	if (ret) {
-		ath10k_err(ar, "failed to set consistent dma mask to 32-bit: %d\n",
-			   ret);
-		goto err_region;
-	}
-
 	pci_set_master(pdev);
 
 	/* Arrange for access to Target SoC registers. */
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 646ad79f309c..5abb38cc3b55 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -933,20 +933,14 @@ static int ath11k_pci_claim(struct ath11k_pci *ab_pci, struct pci_dev *pdev)
 		goto disable_device;
 	}
 
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(ATH11K_PCI_DMA_MASK));
+	ret = dma_set_mask_and_coherent(&pdev->dev,
+					DMA_BIT_MASK(ATH11K_PCI_DMA_MASK));
 	if (ret) {
 		ath11k_err(ab, "failed to set pci dma mask to %d: %d\n",
 			   ATH11K_PCI_DMA_MASK, ret);
 		goto release_region;
 	}
 
-	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ATH11K_PCI_DMA_MASK));
-	if (ret) {
-		ath11k_err(ab, "failed to set pci consistent dma mask to %d: %d\n",
-			   ATH11K_PCI_DMA_MASK, ret);
-		goto release_region;
-	}
-
 	pci_set_master(pdev);
 
 	ab->mem_len = pci_resource_len(pdev, ATH11K_PCI_BAR_NUM);
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 43b4ae86e5fb..86b8cb975b1a 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -191,7 +191,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* XXX 32-bit addressing only */
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(&pdev->dev, "32-bit DMA not available\n");
 		goto err_dis;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index cff9af3af38d..a074e23013c5 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -896,18 +896,12 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pcim_enable_device(pdev))
 		return -EIO;
 
-	ret =  pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
 		pr_err("32-bit DMA not available\n");
 		return ret;
 	}
 
-	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-	if (ret) {
-		pr_err("32-bit DMA consistent DMA enable failed\n");
-		return ret;
-	}
-
 	/*
 	 * Cache line size is used to size and align various
 	 * structures used to communicate with the hardware.
-- 
2.30.2

