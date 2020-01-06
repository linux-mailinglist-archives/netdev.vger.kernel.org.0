Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8881130BB4
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgAFBeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:34:44 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44031 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgAFBem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id d16so47988488wre.10
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wqTHPgjo+1YXsyZU1ZlpjARKDpGiS1+RTyZS6v5aYg0=;
        b=hyQ9zJEgare5dOryIvEt2YQR/CBY7x6wibzoN/IP+B92t9hsAUZM3vR62n55+vx2tl
         ewgyZVFKBbWlfrLbyvhhxEdBSeTz97tFE8SoAIZBCKo9KrgORu2lN4a6Twns5LYzhnSj
         DOIHVWinAR9EhVCs1hZBXCoVDQedhfe0pxcqEZl9PsD/lKhjBufjIAf9QdJ+luHJVlno
         q8EhbxmXHOin51ms0YphGbpUe3oOtl8laysIAZoMZBHy9P9W+xfH0SsFgsl2067D6CeH
         xwWsBT/jn+s29/jc4kMVut8h95B+vFSDFjQ2M+mszgIVxQdM9HwSDv1tONqrLpIhrogY
         hGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wqTHPgjo+1YXsyZU1ZlpjARKDpGiS1+RTyZS6v5aYg0=;
        b=VDWs/fWGhxrS/EaARqPx1Vft+HIcIj76s3vfeEwHMAksfsFPs8ZHHX55ZBtPWqgMQz
         CzBYO/S9ESE4VB1aLvxGIcoivOoCTo9FkDAMjeN0R0YVJVdfk2G2y42jHv804kigdeOH
         2BRnuN1yehPdGK4gOkKKkB1sg9IGZ5IFW1Lw0S4DOf5/Evymf9A6fIcT85BFMk/n2/cu
         eFSekW9ga8p8TMnVRON9J5nAmOF2qFMuoX9/mOeaY7cP7q0z0pmjuu9MytwwSea6HsgK
         e9tG3w+CNE05T5EfkXdtzfOtxp7Pzm/ZPzHaz/pZtaEpnSrZCuOW4m7jPOUAqCv4zUtT
         Ellg==
X-Gm-Message-State: APjAAAXe7ETlOjj1xe/cPFO/hB928udCvwkT6fzUc2ILqG7vPQzzj5Cc
        WX1pfW3A57x66y1uQsqAYYc=
X-Google-Smtp-Source: APXvYqxtAXPwurPotwWhr5i3e7zc1cM6ui4RHh+yWTiK0n/bcA0UQM0JSdeC7Jxr9pCCJcjbZ7T79A==
X-Received: by 2002:adf:e641:: with SMTP id b1mr99546075wrn.34.1578274480479;
        Sun, 05 Jan 2020 17:34:40 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 7/9] net: mscc: ocelot: make phy_mode a member of the common struct ocelot_port
Date:   Mon,  6 Jan 2020 03:34:15 +0200
Message-Id: <20200106013417.12154-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106013417.12154-1-olteanv@gmail.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
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
Changes in v5:
- None.

Changes in v4:
- None.

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

