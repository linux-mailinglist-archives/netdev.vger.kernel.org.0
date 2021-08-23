Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9BA3F52AD
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhHWVSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:18:39 -0400
Received: from out07.smtpout.orange.fr ([193.252.22.91]:29102 "EHLO
        out.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229531AbhHWVSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 17:18:38 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d73 with ME
        id l9Hr250043riaq2039HrVh; Mon, 23 Aug 2021 23:17:52 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 23 Aug 2021 23:17:52 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] s390/ism: switch from 'pci_' to 'dma_' API
Date:   Mon, 23 Aug 2021 23:17:50 +0200
Message-Id: <04d96a44cad009f15334876321aa236dc169b24c.1629753393.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4

This has *NOT* been compile tested because I don't have the needed
configuration.
---
 drivers/s390/net/ism_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 26cc943d2034..5f7e28de8b15 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -555,7 +555,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_disable;
 
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (ret)
 		goto err_resource;
 
-- 
2.30.2

