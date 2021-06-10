Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289403A32E1
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFJSSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:18:11 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:35639 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhFJSSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:18:05 -0400
Received: by mail-ed1-f46.google.com with SMTP id ba2so32391030edb.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SucwMnq9NJLV1ff/Z+/DSiytMZwr1VyFk3b3FwGhQRg=;
        b=hx94KNHTsdogXEP9flLYsQCDChzXjwNfj98flakoWVT20um90ULvpjl7FjZ43YR2J3
         v0GV/1nB8irsbHUXBIWFZh1BlIsCgzZN0Aw0mrwdc9f6G2oqnrMU9tXiYFxC2G3yfO1l
         lKrUXNNqWPzFsOdiW2zr+6eIuO8emiTpZfCddDqRevbkfdT7gdwg0As4M5R0nOhCFYWj
         CVfpHw3BSSuOlpofJNp5D/cKpSAHFxepH07fId7IqXHi5r/9foPcwlrUW+rIMsmds31c
         O80QCIYkh72ixZ9z0HDL/7P0kozfYIa/nyxLawhMoeHtpIoSvobBZQm/GwiAVgdtc2/v
         CJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SucwMnq9NJLV1ff/Z+/DSiytMZwr1VyFk3b3FwGhQRg=;
        b=OY5rhPpz+B/Njv4aexVBzQ8JcoAr0jTz6D2ueIeHsLQ0a5DR0edB908EOkmiPwxkBG
         4hCCnhGPXA5k8s1OdgyZJMlsclyxYvOYK+YVuPNY07wlFf65J0TbqEjFIeq1tqNKE814
         Dh3tJRE83WXC+nvN8aSnFjrpS9DBxIwd0thuOZHdCQDjYaYl/AQBhmuXQ0qduDao45Q+
         WcuGQaSp6evcgxmaJKdYG8KvsT8ZwrtodpBXS6JCYinysxqjNN0PeyAdk2VjurazrJfi
         lM0TKALysl6EGFLD5vXhVaF5nnV3VgWRXIUC/0hU+A9hcAlcxf2H7M7s3RSDAkGfVuVS
         AyPA==
X-Gm-Message-State: AOAM530pjAfVtnX45aQY9ohwi/jDcWYo045TqZcOM89fSYAc/JAZrThV
        c3JLsw9w6KKQXfeR2ZITfgU=
X-Google-Smtp-Source: ABdhPJx0SpSRS9nxlVMDo/lPdUAVH/whwoVSwHPKtR33Y2dO6Ijatmo5+CFCLWvpvsDxxnVFFfk85Q==
X-Received: by 2002:a05:6402:2317:: with SMTP id l23mr753162eda.265.1623348897286;
        Thu, 10 Jun 2021 11:14:57 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 13/13] net: dsa: sja1105: plug in support for 2500base-x
Date:   Thu, 10 Jun 2021 21:14:10 +0300
Message-Id: <20210610181410.1886658-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The MAC treats 2500base-x same as SGMII (yay for that) except that it
must be set to a different speed.

Extend all places that check for SGMII to also check for 2500base-x.

Also add the missing 2500base-x compatibility matrix entry for SJA1110D.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- add the 2500base-x check in one place where it was missing (before
  mdio_device_create)
- remove it from a few places where it is no longer necessary now that
  we check more generically for the presence of priv->xpcs[port]

 drivers/net/dsa/sja1105/sja1105_main.c | 13 ++++++++++++-
 drivers/net/dsa/sja1105/sja1105_mdio.c |  3 ++-
 drivers/net/dsa/sja1105/sja1105_spi.c  |  2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4392ffcfa8a0..9881ef134666 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1045,6 +1045,9 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	case SPEED_1000:
 		speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
 		break;
+	case SPEED_2500:
+		speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
+		break;
 	default:
 		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
 		return -EINVAL;
@@ -1059,6 +1062,8 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 */
 	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
 		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
+	else if (priv->phy_mode[port] == PHY_INTERFACE_MODE_2500BASEX)
+		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
 	else
 		mac[port].speed = speed;
 
@@ -1171,6 +1176,10 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
 	    mii->xmii_mode[port] == XMII_MODE_SGMII)
 		phylink_set(mask, 1000baseT_Full);
+	if (priv->info->supports_2500basex[port]) {
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+	}
 
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
@@ -1931,7 +1940,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		if (!phylink_autoneg_inband(mode)) {
 			int speed = SPEED_UNKNOWN;
 
-			if (bmcr[i] & BMCR_SPEED1000)
+			if (priv->phy_mode[i] == PHY_INTERFACE_MODE_2500BASEX)
+				speed = SPEED_2500;
+			else if (bmcr[i] & BMCR_SPEED1000)
 				speed = SPEED_1000;
 			else if (bmcr[i] & BMCR_SPEED100)
 				speed = SPEED_100;
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 9f894efa6604..b59a1bb63d65 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -427,7 +427,8 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
-		if (priv->phy_mode[port] != PHY_INTERFACE_MODE_SGMII)
+		if (priv->phy_mode[port] != PHY_INTERFACE_MODE_SGMII &&
+		    priv->phy_mode[port] != PHY_INTERFACE_MODE_2500BASEX)
 			continue;
 
 		mdiodev = mdio_device_create(bus, port);
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index e6c2cb68fcc4..53c2213660a3 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -939,6 +939,8 @@ const struct sja1105_info sja1110d_info = {
 				   false, false, false, false, false, false},
 	.supports_sgmii		= {false, true, true, true, true,
 				   false, false, false, false, false, false},
+	.supports_2500basex     = {false, false, false, true, true,
+				   false, false, false, false, false, false},
 	.internal_phy		= {SJA1105_NO_PHY, SJA1105_NO_PHY,
 				   SJA1105_NO_PHY, SJA1105_NO_PHY,
 				   SJA1105_NO_PHY, SJA1105_PHY_BASE_T1,
-- 
2.25.1

