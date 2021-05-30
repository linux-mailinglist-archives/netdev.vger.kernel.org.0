Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6E5395352
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 01:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhE3XBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 19:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhE3XBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 19:01:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9B8C061760
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:54 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id h24so9860791ejy.2
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QfIHLlLNZ+hFFNsxPJufDql6uMwrVSIp/uF4WYIshSc=;
        b=oYF8Da7pGKAqkXsqmYp9aw3JZtLHwl6otDNpmqWmGLcbv4/xFKhHs/5BNiLzNtK4Je
         5HSjDt85YIo5I6tyG6taiYn12gV1m6mKT6iETD7HspHRGBKnjJAYYoDWfKHj6eW7MYZX
         cK2B2xkdiegUzVqeD5VVr2gL0YPs0Adnqn+hJari+r5xj2HA2Zi16GZgMCZcJaz9qNoQ
         GMdeb6Lhk71d6XWdu4ifC2dYNUXBktNtXUjFw7haH94VF9Oi5HgLXRoOF/3VVhDPVSIW
         5QElybui0w0+4w7HuFoBNeqNNVwQzNLdb7v+s+DBHVpQRNFLCjWiYVFrFK3iHBnm4s5T
         IFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QfIHLlLNZ+hFFNsxPJufDql6uMwrVSIp/uF4WYIshSc=;
        b=PACBBT2MSwrRMR8g7RIlASZk2mIkqfbyliOLTlr3AfF38NMM9oxGjqzZqhitN2J/Qk
         gWZK3Qw7DUspKDILYHxSZv7tdJpmikz+tNqnhyHvNIkoL9Xj/EurxhbRaDkBOqmXIa2I
         6L5FsaR6KLrqfh66U0euKFbW38kocL+N74cH6itorKJGTcC3h6FcOSk7tMkCEA+V7YOk
         RMRV5StZSTUZmfSX7Xa+Ep0PolJVTVT+BkYcAlXtLO9ijzShdWtqyxApooaRCR6o4MvX
         ialcB98WclMrWbPfXvhBoRn28kTmpp++Hxng5UwbwjjWdjeK4I7hwbp/jSETypeD47PP
         d5gw==
X-Gm-Message-State: AOAM533wkHIuzuP13nwbGidfn2zY9kpie2NB8uwI53CtlxQBbZTMUkAQ
        GK6b08YuGoS50G9CCMCu4rk=
X-Google-Smtp-Source: ABdhPJyQt5aHxcZfXl3LS/X8hqXOc3wtZVAw5HFjV0fP0f8CKimEGZLGrmw6lO/0JKb0FpLuktUCSw==
X-Received: by 2002:a17:906:2da1:: with SMTP id g1mr19425350eji.47.1622415592630;
        Sun, 30 May 2021 15:59:52 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c6sm5135120eje.9.2021.05.30.15.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 15:59:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 5/8] net: dsa: sja1105: add a PHY interface type compatibility matrix
Date:   Mon, 31 May 2021 01:59:36 +0300
Message-Id: <20210530225939.772553-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530225939.772553-1-olteanv@gmail.com>
References: <20210530225939.772553-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On the SJA1105, all ports support the parallel "xMII" protocols (MII,
RMII, RGMII) except for port 4 on SJA1105R/S which supports only SGMII.
This was relatively easy to model, by special-casing the SGMII port.

On the SJA1110, certain ports can be pinmuxed between SGMII and xMII, or
between SGMII and an internal 100base-TX PHY. This creates problems,
because the driver's assumption so far was that if a port supports
SGMII, it uses SGMII.

We allow the device tree to tell us how the port pinmuxing is done, and
check that against a PHY interface type compatibility matrix for
plausibility.

The other big change is that instead of doing SGMII configuration based
on what the port supports, we do it based on what is the configured
phy_mode of the port.

The 2500base-x support added in this patch is not complete.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h      |  5 +++
 drivers/net/dsa/sja1105/sja1105_main.c | 59 +++++++++++++-------------
 drivers/net/dsa/sja1105/sja1105_spi.c  | 20 +++++++++
 3 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d5c0217b1f65..a27841642693 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -111,6 +111,11 @@ struct sja1105_info {
 				enum packing_op op);
 	int (*clocking_setup)(struct sja1105_private *priv);
 	const char *name;
+	bool supports_mii[SJA1105_MAX_NUM_PORTS];
+	bool supports_rmii[SJA1105_MAX_NUM_PORTS];
+	bool supports_rgmii[SJA1105_MAX_NUM_PORTS];
+	bool supports_sgmii[SJA1105_MAX_NUM_PORTS];
+	bool supports_2500basex[SJA1105_MAX_NUM_PORTS];
 };
 
 enum sja1105_key_type {
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index e4932243d0d3..3682b04d37cb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -143,21 +143,6 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 	return 0;
 }
 
-static bool sja1105_supports_sgmii(struct sja1105_private *priv, int port)
-{
-	if (priv->info->part_no != SJA1105R_PART_NO &&
-	    priv->info->part_no != SJA1105S_PART_NO)
-		return false;
-
-	if (port != SJA1105_SGMII_PORT)
-		return false;
-
-	if (dsa_is_unused_port(priv->ds, port))
-		return false;
-
-	return true;
-}
-
 static int sja1105_init_mii_settings(struct sja1105_private *priv,
 				     struct sja1105_dt_port *ports)
 {
@@ -191,25 +176,42 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 
 		switch (ports[i].phy_mode) {
 		case PHY_INTERFACE_MODE_MII:
+			if (!priv->info->supports_mii[i])
+				goto unsupported;
+
 			mii->xmii_mode[i] = XMII_MODE_MII;
 			break;
 		case PHY_INTERFACE_MODE_RMII:
+			if (!priv->info->supports_rmii[i])
+				goto unsupported;
+
 			mii->xmii_mode[i] = XMII_MODE_RMII;
 			break;
 		case PHY_INTERFACE_MODE_RGMII:
 		case PHY_INTERFACE_MODE_RGMII_ID:
 		case PHY_INTERFACE_MODE_RGMII_RXID:
 		case PHY_INTERFACE_MODE_RGMII_TXID:
+			if (!priv->info->supports_rgmii[i])
+				goto unsupported;
+
 			mii->xmii_mode[i] = XMII_MODE_RGMII;
 			break;
 		case PHY_INTERFACE_MODE_SGMII:
-			if (!sja1105_supports_sgmii(priv, i))
-				return -EINVAL;
+			if (!priv->info->supports_sgmii[i])
+				goto unsupported;
+
+			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			break;
+		case PHY_INTERFACE_MODE_2500BASEX:
+			if (!priv->info->supports_2500basex[i])
+				goto unsupported;
+
 			mii->xmii_mode[i] = XMII_MODE_SGMII;
 			break;
+unsupported:
 		default:
-			dev_err(dev, "Unsupported PHY mode %s!\n",
-				phy_modes(ports[i].phy_mode));
+			dev_err(dev, "Unsupported PHY mode %s on port %d!\n",
+				phy_modes(ports[i].phy_mode), i);
 			return -EINVAL;
 		}
 
@@ -999,10 +1001,8 @@ static int sja1105_speed[] = {
 static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 				      int speed_mbps)
 {
-	struct sja1105_xmii_params_entry *mii;
 	struct sja1105_mac_config_entry *mac;
 	struct device *dev = priv->ds->dev;
-	sja1105_phy_interface_t phy_mode;
 	sja1105_speed_t speed;
 	int rc;
 
@@ -1013,7 +1013,6 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * reasonable approximation for both E/T and P/Q/R/S.
 	 */
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
-	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 
 	switch (speed_mbps) {
 	case SPEED_UNKNOWN:
@@ -1047,7 +1046,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * Actually for the SGMII port, the MAC is fixed at 1 Gbps and
 	 * we need to configure the PCS only (if even that).
 	 */
-	if (sja1105_supports_sgmii(priv, port))
+	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
 		mac[port].speed = SJA1105_SPEED_1000MBPS;
 	else
 		mac[port].speed = speed;
@@ -1066,8 +1065,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * the clock setup does interrupt the clock signal for a certain time
 	 * which causes trouble for all PHYs relying on this signal.
 	 */
-	phy_mode = mii->xmii_mode[port];
-	if (phy_mode != XMII_MODE_RGMII)
+	if (!phy_interface_mode_is_rgmii(priv->phy_mode[port]))
 		return 0;
 
 	return sja1105_clocking_setup_port(priv, port);
@@ -1091,7 +1089,9 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 			       const struct phylink_link_state *state)
 {
 	struct sja1105_private *priv = ds->priv;
-	bool is_sgmii = sja1105_supports_sgmii(priv, port);
+	bool is_sgmii;
+
+	is_sgmii = (state->interface == PHY_INTERFACE_MODE_SGMII);
 
 	if (sja1105_phy_mode_mismatch(priv, port, state->interface)) {
 		dev_err(ds->dev, "Changing PHY mode to %s not supported!\n",
@@ -1128,7 +1128,8 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 
 	sja1105_adjust_port_config(priv, port, speed);
 
-	if (sja1105_supports_sgmii(priv, port) && !phylink_autoneg_inband(mode))
+	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII &&
+	    !phylink_autoneg_inband(mode))
 		sja1105_sgmii_pcs_force_speed(priv, port, speed);
 
 	sja1105_inhibit_tx(priv, BIT(port), false);
@@ -1885,7 +1886,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		speed_mbps[i] = sja1105_speed[mac[i].speed];
 		mac[i].speed = SJA1105_SPEED_AUTO;
 
-		if (sja1105_supports_sgmii(priv, i))
+		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII)
 			bmcr[i] = sja1105_sgmii_read(priv, i,
 						     MDIO_MMD_VEND2,
 						     MDIO_CTRL1);
@@ -1942,7 +1943,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		if (rc < 0)
 			goto out;
 
-		if (!sja1105_supports_sgmii(priv, i))
+		if (priv->phy_mode[i] != PHY_INTERFACE_MODE_SGMII)
 			continue;
 
 		an_enabled = !!(bmcr[i] & BMCR_ANENABLE);
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 615e0906b1fa..565b594efa7d 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -482,6 +482,9 @@ const struct sja1105_info sja1105e_info = {
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
+	.supports_mii		= {true, true, true, true, true},
+	.supports_rmii		= {true, true, true, true, true},
+	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105E",
 };
 
@@ -502,6 +505,9 @@ const struct sja1105_info sja1105t_info = {
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
+	.supports_mii		= {true, true, true, true, true},
+	.supports_rmii		= {true, true, true, true, true},
+	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105T",
 };
 
@@ -523,6 +529,9 @@ const struct sja1105_info sja1105p_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
+	.supports_mii		= {true, true, true, true, true},
+	.supports_rmii		= {true, true, true, true, true},
+	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105P",
 };
 
@@ -544,6 +553,9 @@ const struct sja1105_info sja1105q_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
+	.supports_mii		= {true, true, true, true, true},
+	.supports_rmii		= {true, true, true, true, true},
+	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105Q",
 };
 
@@ -565,6 +577,10 @@ const struct sja1105_info sja1105r_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
+	.supports_mii		= {true, true, true, true, true},
+	.supports_rmii		= {true, true, true, true, true},
+	.supports_rgmii		= {true, true, true, true, true},
+	.supports_sgmii		= {false, false, false, false, true},
 	.name			= "SJA1105R",
 };
 
@@ -586,5 +602,9 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
+	.supports_mii		= {true, true, true, true, true},
+	.supports_rmii		= {true, true, true, true, true},
+	.supports_rgmii		= {true, true, true, true, true},
+	.supports_sgmii		= {false, false, false, false, true},
 	.name			= "SJA1105S",
 };
-- 
2.25.1

