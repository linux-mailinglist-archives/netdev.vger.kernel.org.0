Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581842A1537
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgJaK3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:29:52 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:28640
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726814AbgJaK3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUijkm0gbziZtGJhDlCj069zKqDzVwlR6v5S8PiCyNjAQgCjk3UiN59h6pdkNZF2xDqWYsjwJBj2zN9ROlccvXvqvkP0V2W7sh4kZVy7JwzyX3ABLe64dK8qzy2tqFeXbvyxhpVQ3XEbK5vNbJlUBevxq9Ox6QwkNRmPiSV739zueLT5X4yDGVv9VvH8Eswx5yAdqKOHH3znl8i1EZvO0IkVfXY987vPytsNaBofkt9jV8TXnahy4k0ytjB9Cm65S2yCLe+S6Q4lqXcZDUIhIJx0Gy+cunpevTvIPKDRxjfU0Fa6pVdwubquQOUr7d/n8/dV0Tl9Sfi86xn6bW/vwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2HSsPE8m7xe7Is0PNkYOzDLyYIDZmkh4PtszMvtH3E=;
 b=eFv5I0WiSrk/5Y16MLXBlTt8p9W/MyxtPg6nVC4qobFP8Af2CWzq8xOnytxydDegXydQ+Cq/V92ixuSSUA2H+GDV7c+fEa0qP5LXtdpr53u0QVPwg14sguAW6Qw89qGp2HkQzQNgqHLcTnGC31B0Agn5cpdnyRJXrrbShH1iLBwGZe5qHYKv6WafP97kLY5idqAep8Cid0kgNvsC/mi3RrTEGnCY81LZqIMR6pufkmgdN4FXFCaXK4+5K0SH+WBaGLOsZ1YoSJuGjh7KVqLv/C4DIS52q72a4bQ/W8OZNd8df49DKWGpCnzPPz04QrpYOPwiu6pN22hN5qAd0MPnMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2HSsPE8m7xe7Is0PNkYOzDLyYIDZmkh4PtszMvtH3E=;
 b=ojuf5fKs4xi77HcyVt4u4wsPeNoZ6ymtK6Gzl3XkDrfpf15c1fgS+vPfAXlr8KdzZUALuWgmczmoQPbpP6oxXkzj7RtZhq+GXZ9FKcun+I2FDWd0gEpPAUlcnYmnAi2CDHFXDs1sGociHtpRKHv8u61MehfQQ32TI7ErLHkh7VU=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: mscc: ocelot: deny changing the native VLAN from the prepare phase
Date:   Sat, 31 Oct 2020 12:29:15 +0200
Message-Id: <20201031102916.667619-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201031102916.667619-1-vladimir.oltean@nxp.com>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR08CA0170.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 461c8130-d2a5-4d67-a2ea-08d87d87da73
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB663727F1B009F8625669888DE0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ikbks3Xh0Ov343aqGYR9usEG5tuCybGR1HagGZvHDOR3L6WjWSNVpd8R1JIabeFYEq6SFTonrDhCVSLf7poklnK+La4pKTKqjezyvZdzHoeLAO66TuN4XdMTPP3c87FUAfjkihTYAzIlKrRzvO/dZA+TilanDNWtd+thRrA/vMace6t0cLLnG3qCvgdok1GthmHkZVLLBF/A7oqApZvSCz9z3ZYWSM9SC6eLJ+Tk9fwFYfxSNeZUrtVWg262N1zfZoOdx+kv0Y7xbNlMy8i4WMz/X/Nxzk+PFBWVKYX/h6PYKkInZfI5PV4EcYInetmyNJhZn6sXKCrguBsvPW/4mLACFCpORTD5GhtCKXh0vfBni/foh0hdscNbVs7oUNwfnTfoJ4gh6dhZGH/QwdEK/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WX8a72XfUoo41ChoOnESu7HHD87V110rUf9ANh0gcmcVm+BOqaTaeyZ1n3/XE/G/jFKeOXn66uTGZPDgUp/0CunZ7ScJecLqENy1gqfOI+gYXtecQDaBJPt62Rzu0LfWlpfd2EIAN2HgbdRybWLlx4OP7VHzpUDHl6ikQUYiFHei+wQhNv06MUhPVlJmWDNmDlqjXWqO/BQnj1/h6rKwCglyi7tHli86i5Jn7mWHwAwMIyG7xr390Jytnl0mUagCUB6m4ugelgJrj5Hotls7HbBaMRqkNcZ47CyoHTmWXJzqihyCe78YdpuYJRVhA9coxAVH7WoYa4Rw3UUGGHdLGmwGVYG8QQZ9R3rYdg14CPIA7Hz/Q5RIXx8/Znwya3wCjZXfKWBL5sv6VOtcR173+Fn6AFgUeZnEUGSMxzMSrnPUCx4qLYSgeeifnwwoQg/XgWXJO0mL/N54B8WEhH7DTwRNfBYqRFxxHHDAD85B1ikSg2+JNBY6/hJU0/N3WC/NwZgg9eO9x3QVK4EL56DlAyD++ul/wqjVTWklRcAx/Uy40gWDi67/TGzy/mwkLMXPsheNBEBi54sSXhlegYu/eLlkPacFAXl6EF9NP0W6ctMgvCA6YhsuYVLy1PxN09Wtk+WgDEDBLRIHYDR2flX02w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461c8130-d2a5-4d67-a2ea-08d87d87da73
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:31.3752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GYM4wClC3xQRuph7RSmE4354pepDvAbA6GCfP4rC+YypfVTDe4b92lkPaGdS4n67oRHXUmkfkzeiWLT4pnnpmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put the preparation phase of switchdev VLAN objects to some good use,
and move the check we already had, for preventing the existence of more
than one egress-untagged VLAN per port, to the preparation phase of the
addition.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 13 +++++++-
 drivers/net/ethernet/mscc/ocelot.c     | 41 +++++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_net.c | 22 ++++++++++++--
 include/soc/mscc/ocelot.h              |  2 ++
 4 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f791860d495f..3848f6bc922b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -112,10 +112,21 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 	ocelot_port_bridge_leave(ocelot, port, br);
 }
 
-/* This callback needs to be present */
 static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
+	struct ocelot *ocelot = ds->priv;
+	u16 vid, flags = vlan->flags;
+	int err;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		err = ocelot_vlan_prepare(ocelot, port, vid,
+					  flags & BRIDGE_VLAN_INFO_PVID,
+					  flags & BRIDGE_VLAN_INFO_UNTAGGED);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 60186fc99280..2632fe2d2448 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -147,21 +147,12 @@ static int ocelot_vlant_set_mask(struct ocelot *ocelot, u16 vid, u32 mask)
 	return ocelot_vlant_wait_for_completion(ocelot);
 }
 
-static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
-				       struct ocelot_vlan native_vlan)
+static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
+					struct ocelot_vlan native_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val = 0;
 
-	/* Deny changing the native VLAN, but always permit deleting it */
-	if (ocelot_port->native_vlan.vid != native_vlan.vid &&
-	    ocelot_port->native_vlan.valid && native_vlan.valid) {
-		dev_err(ocelot->dev,
-			"Port already has a native VLAN: %d\n",
-			ocelot_port->native_vlan.vid);
-		return -EBUSY;
-	}
-
 	ocelot_port->native_vlan = native_vlan;
 
 	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(native_vlan.vid),
@@ -182,8 +173,6 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 	ocelot_rmw_gix(ocelot, val,
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
-
-	return 0;
 }
 
 /* Default vlan to clasify for untagged frames (may be zero) */
@@ -259,6 +248,24 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
+int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
+			bool untagged)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	/* Deny changing the native VLAN, but always permit deleting it */
+	if (untagged && ocelot_port->native_vlan.vid != vid &&
+	    ocelot_port->native_vlan.valid) {
+		dev_err(ocelot->dev,
+			"Port already has a native VLAN: %d\n",
+			ocelot_port->native_vlan.vid);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_vlan_prepare);
+
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged)
 {
@@ -285,9 +292,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 
 		native_vlan.vid = vid;
 		native_vlan.valid = true;
-		ret = ocelot_port_set_native_vlan(ocelot, port, native_vlan);
-		if (ret)
-			return ret;
+		ocelot_port_set_native_vlan(ocelot, port, native_vlan);
 	}
 
 	return 0;
@@ -1193,7 +1198,9 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 		return ret;
 
 	ocelot_port_set_pvid(ocelot, port, pvid);
-	return ocelot_port_set_native_vlan(ocelot, port, native_vlan);
+	ocelot_port_set_native_vlan(ocelot, port, native_vlan);
+
+	return 0;
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index cf5c2a0ddfc0..c65ae6f75a16 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -206,6 +206,17 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 	ocelot_adjust_link(ocelot, port, dev->phydev);
 }
 
+static int ocelot_vlan_vid_prepare(struct net_device *dev, u16 vid, bool pvid,
+				   bool untagged)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_vlan_prepare(ocelot, port, vid, pvid, untagged);
+}
+
 static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 			       bool untagged)
 {
@@ -812,9 +823,14 @@ static int ocelot_port_obj_add_vlan(struct net_device *dev,
 	u16 vid;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ret = ocelot_vlan_vid_add(dev, vid,
-					  vlan->flags & BRIDGE_VLAN_INFO_PVID,
-					  vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+		bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+		bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+
+		if (switchdev_trans_ph_prepare(trans))
+			ret = ocelot_vlan_vid_prepare(dev, vid, pvid,
+						      untagged);
+		else
+			ret = ocelot_vlan_vid_add(dev, vid, pvid, untagged);
 		if (ret)
 			return ret;
 	}
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 67c2af1c4c5c..ea1de185f2e4 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -747,6 +747,8 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
+int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
+			bool untagged);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
-- 
2.25.1

