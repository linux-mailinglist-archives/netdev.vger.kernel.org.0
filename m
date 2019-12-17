Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF79012382F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfLQVDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:03:22 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51131 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbfLQVDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so4343382wmb.0;
        Tue, 17 Dec 2019 13:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/AYGnaY52D8sTJ8v+M32HjD/4/ljP+HptYpvJ6gRoJU=;
        b=aKTNLfD9uwFAkheMuc9ovj1lYQUuOvhFPZevrml+hj7ggZKitkuIwzMRzA3jGBUpo1
         qTyVnYfH71ZMM6iXv5tJ/gvBXp6+4gUQS9wRAZi4O2EzcxFAFQcCnwaSRPUEjL5FXPHg
         KYXil54Duq34UWHM7Bn6rYleJjNci7FYXOGmeq4VUHcSSR7KbKjUx7ndk3Tut2pZz2ab
         JUkehBnVZ7NHnTdvnPojkuowYUf9dnBkhK8ieCfLQbO4vNV3Q/aTU9gSJ2RuZjU9Cmr8
         lZSCX305RxMClP49lo1Sq1X+I4LnQgGm+ALQwM7XWHUQlEFFpQzNia9r0iQ9MlKCaBxq
         sSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/AYGnaY52D8sTJ8v+M32HjD/4/ljP+HptYpvJ6gRoJU=;
        b=R/kWxXcMfaodDl/ZrpJ/dB8vgf3TIY2VJo8aF/wZM2dQlnMlQIuaM29TVDrAi9zE+7
         cuQteoZWXxdlVPlmcZ5TcbyEEOEim30pcYs2Uimho1Scv2k6O6WoWIgxDdrx7KDyhKdA
         VUjfieHWi4O9U7rQX2EiWonblsBHn8lR3BNa/x3McqukYNfFjwJW8cZXxmfMEgiMiCdP
         ia8dM/vO6Y7x1Ephbz7KBJgdJN+MOiO2Y3N/omEHdCYSCNopBQ2d2PoIAlQC2kzUUXoz
         exY89N+0bB1Szrh2W+Z07pmXylZfvD5s16rW0sIlzbxJre2eLukv3noBlYWdC1cUvchS
         Fhvw==
X-Gm-Message-State: APjAAAXV2S87Y8fwKib7/WIKtMkIsAW9EDqoBr7cr3jLBT49Xz9o4eJ4
        b6OO9kbazeQP6lzQm5Cnfno=
X-Google-Smtp-Source: APXvYqyKOCqC8XbXj81TCEPdrfxwBY/JaIp3Idhsc6HbGPDp4KdSuA6Bh1fwKeDTqZ7Eqj0KgZhCTA==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr7443172wmc.129.1576616598729;
        Tue, 17 Dec 2019 13:03:18 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:18 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 1/8] net: bcmgenet: enable NETIF_F_HIGHDMA flag
Date:   Tue, 17 Dec 2019 13:02:22 -0800
Message-Id: <1576616549-39097-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit configures the DMA masks for the GENET driver and
sets the NETIF_F_HIGHDMA flag to report support of the feature.

Signed-off-by: Doug Berger <opendmb@gmail.com>
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

