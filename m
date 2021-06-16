Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EC43AA3E7
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhFPTKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbhFPTKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:10:32 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580EAC061767
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:25 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bp38so6132648lfb.0
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K5P7GmjosC3MgbYE/xm5G4Qol43n9LTj/Mhz9+iNrjc=;
        b=U1605JjjcQmDGrAuBThNPQluvavbH322D1xuaGE4rjKUDy0zTgNbR/jAbGxgrIOlHu
         8GKTrP2Yx8n5LioP5X7YVOdZlwJt/GiiB6UQ25vxLHr+mkbGFBJtvlzq5bj5vfpTNude
         fgy6yBEqmiB+2ylNQ5E1ZpXpBP+5vZBX2leF/TO7Zc4tTIHiZq/Ns/tZAi0sU/1FP2pK
         b0I8EerYhUbe/MgP5fHPv1rhVFNYqkE/1MkL86ZiaU/fYYkQ6nvxrMuYjhCiCF66pTz2
         EpOHUyYikjqB63Cczu6AWaedd7wNdoYhlxr5MqFxJupm982mI2z/ZmOXdiHXOs3CoFTr
         Tr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K5P7GmjosC3MgbYE/xm5G4Qol43n9LTj/Mhz9+iNrjc=;
        b=V490tOxey5U/MjrCzqGERUSEVn4vHdhWGWGduA6K/XoBZH7VJypKGE8iFkia/9q2Yp
         JF4cZSG67eyM1VylG13oqDMcSSGC8UGdTAWqhkFULtyoa88RKEFzbWaE9OrCfCZQlSQm
         GKKqlLVS3kjF27YR5Rhb/PApCMXkGZOwwexMwaUvd2+j2NBZCUWZOGPh2Bc2QxAD4YrS
         oil3PL3/+dQMKzk27kEt8B/AjiuK5M2kRRwRj6XtDHi66NlXMoze9uoUyuZSVGuj0Nxd
         EBJuzB2+neYCl/8jUiWkX7YY7aUgUPlWJMeE0WkcoofFajMUUhnKLMeJeNh9mPQC/X1/
         ifgQ==
X-Gm-Message-State: AOAM532ScQdMA0ZRijMmKQnSaJXRaUVA532zej//GVzf5Zbryg9zyGah
        vU4NfGRKQ544rfuAjiGtQDkVAg==
X-Google-Smtp-Source: ABdhPJxvG3uAp4TDduJHhr2jNyXUu0EsF4Ae8/5Ngj30LJaRctdQy09WiJJhSFhc7RRy/sOH+ouD/g==
X-Received: by 2002:a19:8682:: with SMTP id i124mr869889lfd.107.1623870503666;
        Wed, 16 Jun 2021 12:08:23 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id h22sm406939ljl.126.2021.06.16.12.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:08:23 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v2 3/7] net/fsl: switch to fwnode_mdiobus_register
Date:   Wed, 16 Jun 2021 21:07:55 +0200
Message-Id: <20210616190759.2832033-4-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210616190759.2832033-1-mw@semihalf.com>
References: <20210616190759.2832033-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the newly added helper routine
for registering the MDIO bus via fwnode_
interface.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 0b68852379da..2d99edc8a647 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/acpi_mdio.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mdio.h>
@@ -246,7 +246,6 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct fwnode_handle *fwnode;
 	struct mdio_fsl_priv *priv;
 	struct resource *res;
 	struct mii_bus *bus;
@@ -291,13 +290,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	fwnode = pdev->dev.fwnode;
-	if (is_of_node(fwnode))
-		ret = of_mdiobus_register(bus, to_of_node(fwnode));
-	else if (is_acpi_node(fwnode))
-		ret = acpi_mdiobus_register(bus, fwnode);
-	else
-		ret = -EINVAL;
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.29.0

