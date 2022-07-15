Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E29575E0B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiGOIv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiGOIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:51:31 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD2682479
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:50 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bp17so6791757lfb.3
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2odXpn4NqvflBREYUYmO1+1RxmW+GuL0cfDw3Dw0WVQ=;
        b=ImNEmSIVG+pNkIsz2aTPBuxUuaC/pO8aBnsJWK9rfm7pbBcaR27//qg5RCEzAbNDad
         S1farQUpHWFmRKlYdTewVcHblLJZsyLjhUFxjBKXDESyiVWiMJqVFTALSpa0fETFiT+n
         Nn1AbnFyznYE6sRgalKiXNNKNw9TAXfj9HJ2ag21bLUEbk9l8zrRTNa65VuCnsLNyS/I
         ICUKcpg0agE2QvxiNxYGTOEaf1eZsLFwDqFqi+1GLkTIy/OzVmmxwTinShUiKJMIP7cF
         xT75jQKRcHob/L1T22U+SHMi7IQw0PUp6yvHjUFOguoeBdmDmrhPTIvpE6/TmahluGbR
         rMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2odXpn4NqvflBREYUYmO1+1RxmW+GuL0cfDw3Dw0WVQ=;
        b=cEwooFW5pF9tpmL6ecMF1ODN49xgakFGCPClY+AwyUga5cWUxPr4f0UDrgDBV5AoY5
         flGj+7YaCFywWz2JIhUfEfF4jJigMIPpusMId5H5bFTFQUbMhhkyXb4XsWIx5qaQs5nS
         FU1g6enttlzNjWtzJWNeybdP+ySzzITGYgewCJh+hguDwBnrazQOchooUYK0haYPU3Ds
         ySY53kNe9Iu48pYLLoULITRHrR+uXKZ+ytLEKUwRlvj8imxL9vR84icEfT/jYoZdP6xv
         uce96TpUrBAKxTXY2f0yyqojJnywOFR95Wq1/4HkeIrnY8rzoQ8eVnAvGaixMAAwNEOE
         VPUQ==
X-Gm-Message-State: AJIora90Bny7DmP68T7AkSfCho7Dp6AcLa6XTdIqhxTgJjRxNuZBrY5B
        P0RNm4NiuciZgxWHq3LjMbqHbw==
X-Google-Smtp-Source: AGRyM1uyZcbZnX6NZ8r2m2MZSyoYfzeZnbd1TFzCXcQDB72dxRLrr1PKS6VFQgc9KMlW9UbO1rGc1w==
X-Received: by 2002:a05:6512:3081:b0:481:1691:e7ad with SMTP id z1-20020a056512308100b004811691e7admr8098247lfd.396.1657875049523;
        Fri, 15 Jul 2022 01:50:49 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e4-20020a2e9e04000000b0025d773448basm667846ljk.23.2022.07.15.01.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 01:50:49 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v2 7/8] net: mdio: introduce fwnode_mdiobus_register_device()
Date:   Fri, 15 Jul 2022 10:50:11 +0200
Message-Id: <20220715085012.2630214-8-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220715085012.2630214-1-mw@semihalf.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation patch to extend MDIO capabilities in the ACPI world,
introduce fwnode_mdiobus_register_device() to register non-PHY
devices on the mdiobus.

Use the newly introduced routine instead of of_mdiobus_register_device().

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/fwnode_mdio.h    |  3 ++
 drivers/net/mdio/fwnode_mdio.c | 29 ++++++++++++++++++
 drivers/net/mdio/of_mdio.c     | 32 +-------------------
 3 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index 98755b8c6c8a..39d74c5d1bb0 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -16,6 +16,9 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
+int fwnode_mdiobus_register_device(struct mii_bus *mdio,
+				   struct fwnode_handle *child, u32 addr);
+
 int fwnode_phy_register_fixed_link(struct fwnode_handle *fwnode);
 
 void fwnode_phy_deregister_fixed_link(struct fwnode_handle *fwnode);
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 454fdae24150..3743f34e7c2d 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -149,6 +149,35 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
 
+int fwnode_mdiobus_register_device(struct mii_bus *mdio,
+				   struct fwnode_handle *child, u32 addr)
+{
+	struct mdio_device *mdiodev;
+	int rc;
+
+	mdiodev = mdio_device_create(mdio, addr);
+	if (IS_ERR(mdiodev))
+		return PTR_ERR(mdiodev);
+
+	/* Associate the fwnode with the device structure so it
+	 * can be looked up later.
+	 */
+	device_set_node(&mdiodev->dev, child);
+
+	/* All data is now stored in the mdiodev struct; register it. */
+	rc = mdio_device_register(mdiodev);
+	if (rc) {
+		mdio_device_free(mdiodev);
+		fwnode_handle_put(child);
+		return rc;
+	}
+
+	dev_dbg(&mdio->dev, "registered mdio device %p fwnode at address %i\n",
+		child, addr);
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_device);
+
 /*
  * fwnode_phy_is_fixed_link() and fwnode_phy_register_fixed_link() must
  * support two bindings:
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 409da6e92f7d..bd941da030bb 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -48,36 +48,6 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
-static int of_mdiobus_register_device(struct mii_bus *mdio,
-				      struct device_node *child, u32 addr)
-{
-	struct fwnode_handle *fwnode = of_fwnode_handle(child);
-	struct mdio_device *mdiodev;
-	int rc;
-
-	mdiodev = mdio_device_create(mdio, addr);
-	if (IS_ERR(mdiodev))
-		return PTR_ERR(mdiodev);
-
-	/* Associate the OF node with the device structure so it
-	 * can be looked up later.
-	 */
-	fwnode_handle_get(fwnode);
-	device_set_node(&mdiodev->dev, fwnode);
-
-	/* All data is now stored in the mdiodev struct; register it. */
-	rc = mdio_device_register(mdiodev);
-	if (rc) {
-		mdio_device_free(mdiodev);
-		of_node_put(child);
-		return rc;
-	}
-
-	dev_dbg(&mdio->dev, "registered mdio device %pOFn at address %i\n",
-		child, addr);
-	return 0;
-}
-
 /* The following is a list of PHY compatible strings which appear in
  * some DTBs. The compatible string is never matched against a PHY
  * driver, so is pointless. We only expect devices which are not PHYs
@@ -186,7 +156,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 		if (of_mdiobus_child_is_phy(child))
 			rc = of_mdiobus_register_phy(mdio, child, addr);
 		else
-			rc = of_mdiobus_register_device(mdio, child, addr);
+			rc = fwnode_mdiobus_register_device(mdio, of_fwnode_handle(child), addr);
 
 		if (rc == -ENODEV)
 			dev_err(&mdio->dev,
-- 
2.29.0

