Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508CA12FD62
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgACUB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:01:59 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42721 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbgACUBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:01:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so43388363wro.9
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 12:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=533HndW8yiheJA6L+7iVNxbvS14a9dEIxpWE3iVywkw=;
        b=iAr5gEJJEbcIOjxjgdllSQ81vaD1T50E68CB5sBp1cOBGsmFu64fD4b1UZXo2ustwV
         nJuueFZirt1vINkDgLyvGGkQZyIAd9k1Yx0wUuiKZAlJEiDu8bNGdwQAYiAfs5PDWmU+
         L5//Pcuke7R0nS5BYiiv3tXoD2VGcijaRcQzaCix/gLN76m16X7v3NOpEHuCGC35oKLh
         3wzKP+nTRopkzYdAcbtTM8P1G20lqizdEmEa/74sekR9xiAv/t3mmGY0DLbpPE1M1LHG
         JulYPClxUM5vwrO+IZqu+cafafOgGPoIJpb1pI3JJvu88xuaiANF/iCmrLi08GdDQBQF
         oiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=533HndW8yiheJA6L+7iVNxbvS14a9dEIxpWE3iVywkw=;
        b=CnvxOMeWsxjPnR4aNNJT5VI8YSRUgBS6GlIZqBUUiIxBpIACUsak3MhXMJX9lbfqFR
         u8Cxcx1+mgicQz842CrcLKy5nw86SjAw+JxEC6F1R02nNgYOWQL7Fi0bMj3Tggc+6zZh
         t6xF3bUtiXylHX07P+/XxCXLwSA4qtQnldqGDk4XAePrdOhEiABZJm8ieEKdkV4gvyt8
         vK6xapkvpkniVkqi1JVu6VqFBj3f4b7vDinnV5hP1DGGRVbDoFP8r8UsyM/fbI2n9AVj
         78f0P2TBK1qPq5DcuRi5UPq8U9UN/Y7/ykDCik9DF2/Clqx+8cbXVyJN8zGXnVp3AJC8
         kJ5A==
X-Gm-Message-State: APjAAAUvR/nVx6vGVFPvvKQwzkM/fSldZoXyf9FPoLkHHW5qOuUpzZGb
        EZAHGm3M7tS9OZpcvINec5U=
X-Google-Smtp-Source: APXvYqwaOCsBtSPtoIHeXACCDjCwhSGcwDD2cjgUhqClcZAXc+82cSEa2IF52m+dsQBvHTvbie0eCQ==
X-Received: by 2002:adf:ec83:: with SMTP id z3mr88365337wrn.133.1578081714380;
        Fri, 03 Jan 2020 12:01:54 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e12sm60998154wrn.56.2020.01.03.12.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:01:53 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 7/9] net: mscc: ocelot: make phy_mode a member of the common struct ocelot_port
Date:   Fri,  3 Jan 2020 22:01:25 +0200
Message-Id: <20200103200127.6331-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
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

