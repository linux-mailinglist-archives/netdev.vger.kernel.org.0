Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E70F69A478
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjBQDnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBQDm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ACD6191
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tEXjK3L41ZR/mWy7vbTDLRFWyvjUPm6tTNkixyNaKEU=; b=eNLxn/HiyWfLn2ymvj5IKgZRcY
        TtA1ZtgdDgOuEpWurcOTqN21cmJYnsmxzC8VSxzCQX7RXNpvpimjbHmjhqhI1m4iA2nzXnepQsF42
        g8VIuYiwHelqt2FDqzApEAn7Q8Ie7NL+DHJiRFBplluyhEKGuv8EI84kGGR33eSpgfcw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6x-FJ; Fri, 17 Feb 2023 04:42:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 15/18] net: phylink: Remove unused phylink_init_eee()
Date:   Fri, 17 Feb 2023 04:42:27 +0100
Message-Id: <20230217034230.1249661-16-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230217034230.1249661-1-andrew@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not used in tree, and the phylib equivalent phy_init_eee() is
about to be removed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phylink.c | 18 ------------------
 include/linux/phylink.h   |  1 -
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1a2f074685fa..f84d92230806 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2501,24 +2501,6 @@ int phylink_get_eee_err(struct phylink *pl)
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
index c492c26202b5..d9ea4651426d 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -603,7 +603,6 @@ void phylink_ethtool_get_pauseparam(struct phylink *,
 int phylink_ethtool_set_pauseparam(struct phylink *,
 				   struct ethtool_pauseparam *);
 int phylink_get_eee_err(struct phylink *);
-int phylink_init_eee(struct phylink *, bool);
 int phylink_ethtool_get_eee(struct phylink *, struct ethtool_eee *);
 int phylink_ethtool_set_eee(struct phylink *, struct ethtool_eee *);
 int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
-- 
2.39.1

