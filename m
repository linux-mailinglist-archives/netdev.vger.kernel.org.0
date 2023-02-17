Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138BA69A47D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjBQDnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjBQDm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5531AC14D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ygthPH9f2ZFlJ6/YxFm7wCGgCwcPeizw5FS8cv8McVo=; b=QYTl23jPy7bjdWVzIvjaXHcB4e
        etzKWj+KDctoevCVIkKBe4kwm/DQc0AlMBA4zSpH4pNSEPlA91J/9BOolkUZbzK5lH6uyjxm8B51K
        hZlmCTWWAJM2hKph/Ne3yrXFkrVWfCMvr4qE5PJMOEez4yypgQjsAg51HiysFWFPJoEk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F75-Hl; Fri, 17 Feb 2023 04:42:44 +0100
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
Subject: [PATCH RFC 17/18] net: phy: remove unused phy_init_eee()
Date:   Fri, 17 Feb 2023 04:42:29 +0100
Message-Id: <20230217034230.1249661-18-andrew@lunn.ch>
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

There are no users left of phy_init_eee(), and it is often wrongly
used. So remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 34 ----------------------------------
 include/linux/phy.h   |  1 -
 2 files changed, 35 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index b25e0946405b..135f30d576b2 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1494,40 +1494,6 @@ int phy_eee_clk_stop_enable(struct phy_device *phydev)
 	return ret;
 }
 
-/**
- * phy_init_eee - init and check the EEE feature
- * @phydev: target phy_device struct
- * @clk_stop_enable: PHY may stop the clock during LPI
- *
- * Description: it checks if the Energy-Efficient Ethernet (EEE)
- * is supported by looking at the MMD registers 3.20 and 7.60/61
- * and it programs the MMD register 3.0 setting the "Clock stop enable"
- * bit if required.
- */
-int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
-{
-	int ret;
-
-	if (!phydev->drv)
-		return -EIO;
-
-	ret = genphy_c45_eee_is_active(phydev, NULL, NULL, NULL);
-	if (ret < 0)
-		return ret;
-	if (!ret)
-		return -EPROTONOSUPPORT;
-
-	if (clk_stop_enable)
-		/* Configure the PHY to stop receiving xMII
-		 * clock while it is signaling LPI.
-		 */
-		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
-				       MDIO_PCS_CTRL1_CLKSTOP_EN);
-
-	return ret < 0 ? ret : 0;
-}
-EXPORT_SYMBOL(phy_init_eee);
-
 /**
  * phy_get_eee_err - report the EEE wake error count
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 4f72ffcb8b02..593a80d43454 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1839,7 +1839,6 @@ int phy_unregister_fixup(const char *bus_id, u32 phy_uid, u32 phy_uid_mask);
 int phy_unregister_fixup_for_id(const char *bus_id);
 int phy_unregister_fixup_for_uid(u32 phy_uid, u32 phy_uid_mask);
 
-int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable);
 int phy_eee_clk_stop_enable(struct phy_device *phydev);
 int phy_get_eee_err(struct phy_device *phydev);
 int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data);
-- 
2.39.1

