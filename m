Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA823575F
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 16:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgHBOP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 10:15:28 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:24010 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgHBOP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 10:15:28 -0400
Received: from localhost.localdomain ([93.22.148.198])
        by mwinf5d42 with ME
        id AeFQ2300A4H42jh03eFRvj; Sun, 02 Aug 2020 16:15:26 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 02 Aug 2020 16:15:26 +0200
X-ME-IP: 93.22.148.198
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, lrizzo@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] gve: Fix the size used in a 'dma_free_coherent()' call
Date:   Sun,  2 Aug 2020 16:15:23 +0200
Message-Id: <20200802141523.691565-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()'.

Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index c3ba7baf0107..883e173f5ca0 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -322,7 +322,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
 
 free_device_descriptor:
-	dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
+	dma_free_coherent(&priv->pdev->dev, PAGE_SIZE, descriptor,
 			  descriptor_bus);
 	return err;
 }
-- 
2.25.1

