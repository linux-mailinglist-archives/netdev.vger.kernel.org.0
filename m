Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B15E3AB395
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhFQMbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhFQMbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 08:31:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D8C06175F
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:26 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w21so3769093edv.3
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/uckF/Bl64mhOfR3QqgjGiPdOBL9/ISd4vyXTGnhc8g=;
        b=ZD8M5KNrNEGxRDB6Vam0yhb3pIXnBd9MSGdM6iwj/+933f0ddouOGeu0Mms6ze72Sk
         MZ/rVeD+Bgi2M45hiA+u4gwdCw8d4bF2OkwJgmUeChOIMvRgFh47qR8mJ4sfLuxUNjyG
         KtHKJh61/4rUJu5Rsp9pZUASSP1m3Ae4YoJba4bZPN6+JgYdNld+3qtRRoql7gY4yrS7
         O5CzTuwL46oxXQz/PE4Akzcos9fOQnrIQJrv5tMf0g/f9gUDw/MUMlsorXAQYhyRKRb1
         y74FABO4TzNM7kZZBkQlXQCPHlgHh0arv+2DS9s2eqb0WTd1+ZN0MlON/abWrpfFTird
         zIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uckF/Bl64mhOfR3QqgjGiPdOBL9/ISd4vyXTGnhc8g=;
        b=HAsb8zmHYzKvUDr5g85KLYGJhFsMnQvFCna0y0yCOtl3z7tjz7F/ZuSI8ztCpIj+Wg
         CzBtK24LBT6bylRZZ9eWBcggfP1Wy4+Ua8t8z3NtIdmRxrVpT0klNUqhaQp9cYvHg+/9
         kSnuCTzQ+9FWqMrUomoOlv0D+nIZeq9kifHVbAbcnVjIX1KaXkV7MNZkKqugsntFVjbM
         EEPU8ycihVNxn7oRZiFBlioqEf8SByTYv50U7Ik6gUd5VHMuoUTwM/yG52Hrfag+rCDn
         5SK1wYedGwz31Osm9y+dZ/6B38EWmSPaszmo7Ip19ykNarfLkBfOmN9MqRW89V/13iyR
         Ue6g==
X-Gm-Message-State: AOAM531GeKnqYl7d5sKyu7qvxhEu/7r+0q1388Xeor3bRtbg9R5oyg+3
        5PBwL9hrdMq92WNqT43Nwbs=
X-Google-Smtp-Source: ABdhPJw0QSE2ULltWR+mWkDTL1EQ9xxAAqEJUgmpI2tOOxm30GZoNWjuqZjMJkWpTNtsz8CIcHseHQ==
X-Received: by 2002:a05:6402:754:: with SMTP id p20mr5930875edy.311.1623932965337;
        Thu, 17 Jun 2021 05:29:25 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id de10sm3706179ejc.65.2021.06.17.05.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 05:29:24 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        grant.likely@arm.com, calvin.johnson@oss.nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 3/3] net: mdio: use device_set_node() to setup both fwnode and of
Date:   Thu, 17 Jun 2021 15:29:05 +0300
Message-Id: <20210617122905.1735330-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617122905.1735330-1-ciorneiioana@gmail.com>
References: <20210617122905.1735330-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Use the newly introduced helper to setup both the of_node and the
fwnode for a given device.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch

 drivers/net/mdio/fwnode_mdio.c | 3 +--
 drivers/net/mdio/of_mdio.c     | 9 ++++-----
 drivers/net/phy/mdio_bus.c     | 3 +--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 283ddb1185bd..1becb1a731f6 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -65,8 +65,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	 * can be looked up later
 	 */
 	fwnode_handle_get(child);
-	phy->mdio.dev.of_node = to_of_node(child);
-	phy->mdio.dev.fwnode = child;
+	device_set_node(&phy->mdio.dev, child);
 
 	/* All data is now stored in the phy struct;
 	 * register it
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 8744b1e1c2b1..9e3c815a070f 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -51,6 +51,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 static int of_mdiobus_register_device(struct mii_bus *mdio,
 				      struct device_node *child, u32 addr)
 {
+	struct fwnode_handle *fwnode = of_fwnode_handle(child);
 	struct mdio_device *mdiodev;
 	int rc;
 
@@ -61,9 +62,8 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	/* Associate the OF node with the device structure so it
 	 * can be looked up later.
 	 */
-	of_node_get(child);
-	mdiodev->dev.of_node = child;
-	mdiodev->dev.fwnode = of_fwnode_handle(child);
+	fwnode_handle_get(fwnode);
+	device_set_node(&mdiodev->dev, fwnode);
 
 	/* All data is now stored in the mdiodev struct; register it. */
 	rc = mdio_device_register(mdiodev);
@@ -162,8 +162,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	 * the device tree are populated after the bus has been registered */
 	mdio->phy_mask = ~0;
 
-	mdio->dev.of_node = np;
-	mdio->dev.fwnode = of_fwnode_handle(np);
+	device_set_node(&mdio->dev, of_fwnode_handle(np));
 
 	/* Get bus level PHY reset GPIO details */
 	mdio->reset_delay_us = DEFAULT_GPIO_RESET_DELAY;
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 24665670a89a..53f034fc2ef7 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -459,8 +459,7 @@ static void of_mdiobus_link_mdiodev(struct mii_bus *bus,
 			continue;
 
 		if (addr == mdiodev->addr) {
-			dev->of_node = child;
-			dev->fwnode = of_fwnode_handle(child);
+			device_set_node(dev, of_fwnode_handle(child));
 			return;
 		}
 	}
-- 
2.31.1

