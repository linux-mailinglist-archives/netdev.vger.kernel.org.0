Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A58C3A49E4
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhFKUJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:09:20 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:44892 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhFKUJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:09:18 -0400
Received: by mail-ed1-f53.google.com with SMTP id u24so38428740edy.11
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jcd9ZhW9isRv7J3YGglkgaUD0FaC/eFCh9HeonDJwkI=;
        b=GeGkcqQ3m8oGz+kkSTZkm4+J8ZGhht4JwymPdga8IkLF8wejrOp/Kvo1gwV8PYye6x
         D9DrfPXjqI7H4j23+oc5Z1fnxV+DGVIgtJ8gokOaKA6RYw2Q46ASdqak8lkSzwZVmXnF
         4CRwKtMNzsvk7u5jlJzMaEepAIy89LJygOq1f+eDltQTOmOfpD7Yc1MZ/zqY5MlALysS
         TaVMtxvuW0X730Hj88A3QEgE2cJAvmplttBNua4YJNgibAi+OH0cduv5jy9eF0DGedUJ
         7WeLiiJzoTKn3wMnfV3vA6d8K4vsRdcz4cjmDwGjjSFZRRUlPoa5mLsUkRArjfIn4H5n
         CVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jcd9ZhW9isRv7J3YGglkgaUD0FaC/eFCh9HeonDJwkI=;
        b=ZZkq+A48Egb12FVXNw/WteTJNLMPELlxeAz4UI0c5AXjFu9rDOgUAgbVvZaf+aaH8R
         FI8PY2ljg0JikUuS4U1NQgwkWNd1yXVDMmo5TIh4sOE+FqbhTP1QF/8Yz5hBXNS3OtKn
         84yvWjtQBdbaQW16n2+AjgEdKXwfJ7IwZSFUtlpQ55IKj7G7l90sycgoTXNpU/dRG9tK
         ZFs0lw0ME6EJQxVmF0SGqXJh3398ifhF75YYN/l1fUF3g5shbZPSDuhSTq7XwyOzahG3
         SU/IbiilDCPQ+wkAFKLdTqCvNOy2u0mutEigLcaQz+VpG4VNR2ECzVSXrnsdk5YldnfI
         lt3A==
X-Gm-Message-State: AOAM530h9sym43JN1fWTnyheRy2dETD1lfugBKzNkoRsA6dBBOssY4sU
        9z8zEUHqQCmhrOCSdzN9z5U=
X-Google-Smtp-Source: ABdhPJx1/rRabPdbstjHAYqg48IU+u3vo7eAHsgteeQAf+c1GOG5Az+u6lVkkTNt8eHJsGb1ZBE3Ug==
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr5520991edf.86.1623441965754;
        Fri, 11 Jun 2021 13:06:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:06:05 -0700 (PDT)
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
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 13/13] net: dsa: sja1105: plug in support for 2500base-x
Date:   Fri, 11 Jun 2021 23:05:31 +0300
Message-Id: <20210611200531.2384819-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
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
v2->v3: none
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
index 3e32b8676fa7..8e5cdf93c23b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1056,6 +1056,9 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	case SPEED_1000:
 		speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
 		break;
+	case SPEED_2500:
+		speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
+		break;
 	default:
 		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
 		return -EINVAL;
@@ -1070,6 +1073,8 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 */
 	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
 		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
+	else if (priv->phy_mode[port] == PHY_INTERFACE_MODE_2500BASEX)
+		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
 	else
 		mac[port].speed = speed;
 
@@ -1182,6 +1187,10 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
 	    mii->xmii_mode[port] == XMII_MODE_SGMII)
 		phylink_set(mask, 1000baseT_Full);
+	if (priv->info->supports_2500basex[port]) {
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+	}
 
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
@@ -1942,7 +1951,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
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
index 41468e51a38e..19aea8fb76f6 100644
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
index 96768af4c6a8..7c493c6a839d 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -967,6 +967,8 @@ const struct sja1105_info sja1110d_info = {
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

