Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4065A6CAB5D
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbjC0RDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjC0RCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E96B5263
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ONe/geY5xk481ruev3CaP1FDi3uEGE3p28kPEjHezFk=; b=YCq2GbESuKUO839SxOTvdzbaLT
        uxzKdQr55a+9NEgFdX4aNoQYga8nGTccIWqrew8nB1kOCEoMUUd+o+bNXvU6v0DNnETh8p5I+LfLZ
        CYD14jLfc5Iywn6im/tOFt6FTbDiCzaHwJ6GWj4P0BHLZ0YQZE0jeIRC0rI47M3aTFLM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEV-008XsU-9H; Mon, 27 Mar 2023 19:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 16/23] net: phylink: Remove unused phylink_init_eee()
Date:   Mon, 27 Mar 2023 19:01:54 +0200
Message-Id: <20230327170201.2036708-17-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not used in tree, and the phylib equivalent phy_init_eee() is
about to be removed.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phylink.c | 18 ------------------
 include/linux/phylink.h   |  1 -
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2d1e1cda9f42..2e9ce6862042 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2507,24 +2507,6 @@ int phylink_get_eee_err(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_get_eee_err);
 
-/**
- * phylink_init_eee() - init and check the EEE features
- * @pl: a pointer to a &struct phylink returned from phylink_create()
- * @clk_stop_enable: allow PHY to stop receive clock
- *
- * Must be called either with RTNL held or within mac_link_up()
- */
-int phylink_init_eee(struct phylink *pl, bool clk_stop_enable)
-{
-	int ret = -EOPNOTSUPP;
-
-	if (pl->phydev)
-		ret = phy_init_eee(pl->phydev, clk_stop_enable);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(phylink_init_eee);
-
 /**
  * phylink_ethtool_get_eee() - read the energy efficient ethernet parameters
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index ef09b3b7e471..6eee6194b5ab 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -604,7 +604,6 @@ void phylink_ethtool_get_pauseparam(struct phylink *,
 int phylink_ethtool_set_pauseparam(struct phylink *,
 				   struct ethtool_pauseparam *);
 int phylink_get_eee_err(struct phylink *);
-int phylink_init_eee(struct phylink *, bool);
 int phylink_ethtool_get_eee(struct phylink *, struct ethtool_eee *);
 int phylink_ethtool_set_eee(struct phylink *, struct ethtool_eee *);
 int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
-- 
2.39.2

