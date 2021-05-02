Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ECA370FA5
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhEBXIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhEBXIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:23 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D94EC06174A;
        Sun,  2 May 2021 16:07:30 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b25so5208124eju.5;
        Sun, 02 May 2021 16:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6S33qsxdfzNRrx5uD8qxn/D0pG+Cha3VUrhtZ9or8eA=;
        b=GMSR8+IT91Jetc9jxJURyS2Y1Pi+DiRUCKLIv/RIKiopbaBxWxJnyptWU7mxkXsxFq
         FrAJPAQlrQxqBl7u5oVE9H3dGC2mRlngx+NtgMOgFgbHRb1WuH9oUUbWBSOP+lBYCExE
         iy4Zwka0zFPUwu7eZB5RXcmIAS1hKfv28U3eI+cTYOOZ1Cz8uc11eoasg1pny9d9DW8f
         UHYphsL8RdWcS+VxDgZpdOvt1LFRAfdk6Xu5SmsSyp7lQTG+rjlBfIOmiCpuA39ldnoM
         Qv46NdGn0trY954ptxAoTWQa5TIsmdeh+o1leLp87cYTZj7u94jaXCUNWkKOSvd+EiS9
         4Nsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6S33qsxdfzNRrx5uD8qxn/D0pG+Cha3VUrhtZ9or8eA=;
        b=SyvswEbv/UqiN4zTfreiCCuyb87bK6FVaLVocyhvbexo5fHoFaFBSb0J6aKJ3smFyL
         yRmNTmGpZNKjmBBKQKnlWcLtFmmEFRZEyK/chnDZSb1T7G/9vi+tNRH9suO6i+J0tthr
         TGYYVnF1YMcneYAvJlSU/1vaXkR46T8pZl/S+yKPzrTuqs5jK84dRnA9PLNskvTCsgfP
         8bB7JJm8PbaGZ4OsIwwhg+xzcd6vH2h3FjHe0rgD7VqHSNXDk9txtBEuYHGaTeB9kNmV
         HANrXIIa62oq5GVxzBm3M95rxLhkHeqSkhGEVoWkMnPwu4cskogTi69ahbTE/7jRkZRj
         9q2w==
X-Gm-Message-State: AOAM531BxJ95Qw6UdRNygmq7FJczOheBq6jo5rB9fUDg6JW/9XhSL5s0
        itmePJ9cJKq35uG6G8Ji40E=
X-Google-Smtp-Source: ABdhPJx9KOBGhGLbtuv3/swOFbNxuNnCdUmC/zZOPQWFwhcwpiAZV4wYqcVzl5GN6v1KJUPQtEjJ7w==
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr14070974ejf.145.1619996849203;
        Sun, 02 May 2021 16:07:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:28 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH net-next v2 14/17] net: phy: phylink: permit to pass dev_flags to phylink_connect_phy
Date:   Mon,  3 May 2021 01:07:06 +0200
Message-Id: <20210502230710.30676-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for phylink_connect_phy to pass dev_flags to the PHY driver.
Change any user of phylink_connect_phy to pass 0 as dev_flags by
default.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c          |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/phy/phylink.c                         | 12 +++++++-----
 include/linux/phylink.h                           |  2 +-
 net/dsa/slave.c                                   |  2 +-
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 0f6a6cb7e98d..459243c08b0c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -834,7 +834,7 @@ static int macb_phylink_connect(struct macb *bp)
 		}
 
 		/* attach the mac to the phy */
-		ret = phylink_connect_phy(bp->phylink, phydev);
+		ret = phylink_connect_phy(bp->phylink, phydev, 0);
 	}
 
 	if (ret) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4749bd0af160..ece84bb64b37 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1099,7 +1099,7 @@ static int stmmac_init_phy(struct net_device *dev)
 			return -ENODEV;
 		}
 
-		ret = phylink_connect_phy(priv->phylink, phydev);
+		ret = phylink_connect_phy(priv->phylink, phydev, 0);
 	}
 
 	phylink_ethtool_get_wol(priv->phylink, &wol);
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index dc2800beacc3..95f6a10e90ef 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1018,7 +1018,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 }
 
 static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
-			      phy_interface_t interface)
+			      phy_interface_t interface, u32 flags)
 {
 	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
 		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
@@ -1028,13 +1028,14 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 	if (pl->phydev)
 		return -EBUSY;
 
-	return phy_attach_direct(pl->netdev, phy, 0, interface);
+	return phy_attach_direct(pl->netdev, phy, flags, interface);
 }
 
 /**
  * phylink_connect_phy() - connect a PHY to the phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
  * @phy: a pointer to a &struct phy_device.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
  *
  * Connect @phy to the phylink instance specified by @pl by calling
  * phy_attach_direct(). Configure the @phy according to the MAC driver's
@@ -1046,7 +1047,8 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
  *
  * Returns 0 on success or a negative errno.
  */
-int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
+int phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
+			u32 flags)
 {
 	int ret;
 
@@ -1056,7 +1058,7 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 		pl->link_config.interface = pl->link_interface;
 	}
 
-	ret = phylink_attach_phy(pl, phy, pl->link_interface);
+	ret = phylink_attach_phy(pl, phy, pl->link_interface, flags);
 	if (ret < 0)
 		return ret;
 
@@ -2207,7 +2209,7 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 		return ret;
 
 	interface = pl->link_config.interface;
-	ret = phylink_attach_phy(pl, phy, interface);
+	ret = phylink_attach_phy(pl, phy, interface, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index d81a714cfbbd..cd563ba67ca0 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -437,7 +437,7 @@ struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 void phylink_set_pcs(struct phylink *, struct phylink_pcs *pcs);
 void phylink_destroy(struct phylink *);
 
-int phylink_connect_phy(struct phylink *, struct phy_device *);
+int phylink_connect_phy(struct phylink *, struct phy_device *, u32 flags);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..8ecfcb553ac1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1718,7 +1718,7 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
 		return -ENODEV;
 	}
 
-	return phylink_connect_phy(dp->pl, slave_dev->phydev);
+	return phylink_connect_phy(dp->pl, slave_dev->phydev, 0);
 }
 
 static int dsa_slave_phy_setup(struct net_device *slave_dev)
-- 
2.30.2

