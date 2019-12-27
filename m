Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F23B12BB54
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfL0VhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:37:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40552 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfL0VhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:37:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so27252856wrn.7
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eY6ZMTsDwezDW4jo5zoA1I50kL17vbuuaabkHmF3h90=;
        b=gPuGbfY8bccNc22WB9EBMTp5ffJZWnQ0KPcMc+D4Z7o6iqrzsniVXqX1qeKe+AojKd
         i8pFwXujTiCDwtFRgNekaeOL2PHvAEKcE2t9VEOZMlMXoU1qbMkztpycnUmADrEz33rT
         BVuvNaLAITRs13Va7KkIZn5SguB4oq8hqTaWYMyuTTZJkbmKy2AxJFHHrf6Sp5S6gRWg
         p1S7oU7vTU7tb/e09ekXscMI521eyxdCAwrZznMm46h4xbZBF4g8BmXux22X0Kgjg4VJ
         DTKm7uEBsrSrM/sKDunUmWuTKy2XSs5+Mta/okEpsExCMBH3W57PD/TKIRNuwkyPs+Im
         aQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eY6ZMTsDwezDW4jo5zoA1I50kL17vbuuaabkHmF3h90=;
        b=bcreWP0FUu0sQFVh5oy9MwJfkPzaq2NGaNpEPvX9J2PgdG+9hFTaRsuIrj+Ij+vK0K
         odaMI3ZVSFZWkprcHwdORShjG3FmKIT9dLC5G8UWY9R1M9uTpvYrj044JkUGs3cLV7qg
         73nZrbGLyCV/ALwcFRW1CtwgRc3q2ARFhwjDGwSDzAd+5itsitrH20Q/zwxwtdOmZays
         9HnVpLwqVRwP2GjpKg4diKLMqfTtXnamC5FyVrF3vx/c5Nc/DcEWUH8qmTpxB3BN3Pql
         aPzPXCYBZ/EVWjFxBcda2P7y04SFYtT/JE6GGUt6KLgqNRzn/xOD1oNyHqufyKWsV+nv
         5RaA==
X-Gm-Message-State: APjAAAUhFoXWnWqU6VLhL1jVYba9kra+l+X5cGm7ZLI5G2LvbfTM1iER
        B9GZ6PhXhsU+IkCj5sgBN8E=
X-Google-Smtp-Source: APXvYqy4OG85aHopFnJ8KUQtOcyfVnanAsD3uk1NHQ0oasEAg85Ew2EzR7CcSEtl6o1gqjon5Obquw==
X-Received: by 2002:adf:9c8a:: with SMTP id d10mr51714394wre.156.1577482620859;
        Fri, 27 Dec 2019 13:37:00 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:37:00 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 09/11] net: mscc: ocelot: make phy_mode a member of the common struct ocelot_port
Date:   Fri, 27 Dec 2019 23:36:24 +0200
Message-Id: <20191227213626.4404-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Ocelot switchdev driver and the Felix DSA one need it for different
reasons. Felix (or at least the VSC9959 instantiation in NXP LS1028A) is
integrated with the traditional NXP Layerscape PCS design which does not
support runtime configuration of SerDes protocol. So it needs to
pre-validate the phy-mode from the device tree and prevent PHYLINK from
attempting to change it. For this, it needs to cache it in a private
variable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- None.

 drivers/net/ethernet/mscc/ocelot.c       | 7 ++++---
 drivers/net/ethernet/mscc/ocelot.h       | 1 -
 drivers/net/ethernet/mscc/ocelot_board.c | 4 ++--
 include/soc/mscc/ocelot.h                | 2 ++
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 985b46d7e3d1..86d543ab1ab9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -500,13 +500,14 @@ EXPORT_SYMBOL(ocelot_port_enable);
 static int ocelot_port_open(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 	int err;
 
 	if (priv->serdes) {
 		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
-				       priv->phy_mode);
+				       ocelot_port->phy_mode);
 		if (err) {
 			netdev_err(dev, "Could not set mode of SerDes\n");
 			return err;
@@ -514,7 +515,7 @@ static int ocelot_port_open(struct net_device *dev)
 	}
 
 	err = phy_connect_direct(dev, priv->phy, &ocelot_port_adjust_link,
-				 priv->phy_mode);
+				 ocelot_port->phy_mode);
 	if (err) {
 		netdev_err(dev, "Could not attach to PHY\n");
 		return err;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index c259114c48fd..7b77d44ed7cf 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -68,7 +68,6 @@ struct ocelot_port_private {
 
 	u8 vlan_aware;
 
-	phy_interface_t phy_mode;
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 2da8eee27e98..b38820849faa 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -402,9 +402,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 		of_get_phy_mode(portnp, &phy_mode);
 
-		priv->phy_mode = phy_mode;
+		ocelot_port->phy_mode = phy_mode;
 
-		switch (priv->phy_mode) {
+		switch (ocelot_port->phy_mode) {
 		case PHY_INTERFACE_MODE_NA:
 			continue;
 		case PHY_INTERFACE_MODE_SGMII:
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 64cbbbe74a36..068f96b1a83e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -420,6 +420,8 @@ struct ocelot_port {
 	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
 	u8				ts_id;
+
+	phy_interface_t			phy_mode;
 };
 
 struct ocelot {
-- 
2.17.1

