Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063D4123BF4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfLRAv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:51:29 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32999 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLRAv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:27 -0500
Received: by mail-pf1-f194.google.com with SMTP id z16so223671pfk.0;
        Tue, 17 Dec 2019 16:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DP99ZbPmc6NjQOnjlJkOUhqOZNp0C1aPqy3Uar/d9j8=;
        b=lOd31FcjVQxqLYIJCxWpjVAHgiHhWWi7EPgkOjD0Q/v7vCusjnIAeXhy72iiYOB5VQ
         1xc+8quNrNEw59Bpyxx2NjbXHOSGAqOamxpu1vY3THPnAYa3GVn5Hw2/+/OoXDpPeEwD
         MFo43FqdjcgBX+H1PtbIMbokPZNT2OgFkQ/NHap61kmwVyVHGrnZWjTjCYIXFArY60Ix
         sE/1/PubeAqQh/y1hpwdMZWzf0KhXLet7dqwi7F6TDqTPlcX8tLnM/88j2nV93Z16HzY
         OUrGVFs//bXZsxorQg1ki5JfvqF9zQJQ2/qojTQSZBoUNty3T4r9HrXV+ThTwPsLoumG
         D+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DP99ZbPmc6NjQOnjlJkOUhqOZNp0C1aPqy3Uar/d9j8=;
        b=YEKl3gBw55PPureeHEnm4hF/fETnfwtll4ZeQ8pCNQhm7WaRY6OvadctLqVjeQiCw7
         DP1hgLgg9TijUp1Iq6UHd3WuXKuFTaZplTa1S6I7MLBCgUT+zdNIhQGgCaVygFbhIQly
         HOVbq9NDrooF+Aon1IgTkn5zBCVZD8nzXR2h9vRydzV+yvk5dzLOVEgGVksgjpfDX8cn
         2cVVvhveCObkiA7JXirHz0mx/i9qac86Gq9ulqzs+O80BeShS2dB5GzbbqRW4UiSeQk1
         jvgwYO+NQ84Yx1ByNFhyk8CFTe+DN46M1NgWGcaPdylIyskPV+L0/LpC2JuG33ITYig4
         VotQ==
X-Gm-Message-State: APjAAAVnPSIThmn4YdWplf14KeQXaxxP2Cgby72TrVkHj4d1kEPIreA9
        qmxcB9q9CUGa9ab15x+CBZU=
X-Google-Smtp-Source: APXvYqxGhUNx7aHd9ZYdOBbXkD7QDQTmLnkR8Ieq2WiprmEikGJ5sFVkfMtSAEJFfRiFp3SBzsNtpQ==
X-Received: by 2002:aa7:9556:: with SMTP id w22mr716065pfq.198.1576630287332;
        Tue, 17 Dec 2019 16:51:27 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:26 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 1/8] net: bcmgenet: enable NETIF_F_HIGHDMA flag
Date:   Tue, 17 Dec 2019 16:51:08 -0800
Message-Id: <1576630275-17591-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
References: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit configures the DMA masks for the GENET driver and
sets the NETIF_F_HIGHDMA flag to report support of the feature.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 32f1245a69e2..d9defb8b1e5f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2,7 +2,7 @@
 /*
  * Broadcom GENET (Gigabit Ethernet) controller driver
  *
- * Copyright (c) 2014-2017 Broadcom
+ * Copyright (c) 2014-2019 Broadcom
  */
 
 #define pr_fmt(fmt)				"bcmgenet: " fmt
@@ -3537,7 +3537,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	/* Set hardware features */
 	dev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-		NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
+		NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA | NETIF_F_RXCSUM;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
@@ -3574,6 +3574,14 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	bcmgenet_set_hw_params(priv);
 
+	err = -EIO;
+	if (priv->hw_params->flags & GENET_HAS_40BITS)
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
+	if (err)
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (err)
+		goto err;
+
 	/* Mii wait queue */
 	init_waitqueue_head(&priv->wq);
 	/* Always use RX_BUF_LENGTH (2KB) buffer for all chips */
-- 
2.7.4

