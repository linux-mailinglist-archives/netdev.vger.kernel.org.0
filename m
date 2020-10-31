Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98452A1532
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgJaK3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:29:41 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:21857
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbgJaK3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1rWljyBDC15ZH1pbW+tsNS1uuQE1beua0UkvG3NdHz7jtuA4J/gJV+AraQK2Mk8ji9RBXTlsjplK6p4rrLBHuPiIZ0QXzUPUvWnWJc9d6U9/Wm08rtUzEwdD7XAQeY3SPFx9Mj1r4ShBD7SavsRTAKPYFT/DH/D3JXq6gIS9GBakXUcrotJFkfwJ1/ZyBrAp4cGN0l0+WwH93nOyisM9E9ndXJ6TSIVUrMH8FQg3W+qKtD0ICEqZBgKQ7Fi5iR6e2LzbTYW16yi5LXkq2vYdOapKkAr8IkFFVf16YfwuA7QnVwxeG+aQC+SUuFK0mwMCIEDaHlhaYvUYRu58uvHDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xd6ih55KrPLYG4KtiKilnIFIY0Ql2D/RhfY8EE70Z4=;
 b=Du7sXYI2xCSbTcGYWv2BZwPifXd3RQJ8oSGMP/+LVA8Xv6k7q7/J8+RIWtdYflqATKOrMaBdQ7bplRwNvEjQcswZAB6OVS5aB+7lyy9qfExQruND8MJZPXXs1R0PsZKpE6ywSmVvAUIk7/R56RUB4aW3jnz/Dxy6xn4zldiViUlEwWKn9QmCuWxQHoDey6dSrUAeqLTljyViT5nYuLrklUCx2a3ICwqNgLTLxUtLPASBbw5pdZtdVcHwbhMKG+ucoFyq2vUIZYi378xgj8Rq0gzrh6LH/wqmC3blvE3r/fW/lgtOoveCvVU6lSSITqXUMrphPF6se+wYcJUNYfeMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xd6ih55KrPLYG4KtiKilnIFIY0Ql2D/RhfY8EE70Z4=;
 b=XfQiH5uNwp4s4Kz09Bh33m607KaoiJvIBFZQaAA1VcD1lji/bpBJUmpEBOpKaGTA+98KYFxgxUz5RLsJnw4GKvI54WGuby26gEIxSUkeN9wh14E14nyxlr3/KKY34oM0uAHmRgXXB+uJxLNbGsUuE/Ek1rboydsCNpFan3sa0P8=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:29 +0000
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
Subject: [PATCH net-next 3/7] net: mscc: ocelot: transform the pvid and native vlan values into a structure
Date:   Sat, 31 Oct 2020 12:29:12 +0200
Message-Id: <20201031102916.667619-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85f8660b-8bf7-4394-d92b-08d87d87d931
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB663776FA9E0373098F280E83E0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MSj3MeDGyeyHE90uEvtW3jDe3XNg/SYBPfR3WSpfXws4Eg9sNF8k2g7ZI6Y3pZGn6u1hqweQZAQ4Kef8lE2ze1nMUmjSKtv9gl4lKj3Ga2xgvxUtjGUc/obE8qUz5RCK1s+AaOsBq4T3zqPEzSMfPtlrcuX4HFX044oHj/uiEXgicR05yA8A3bDWdnJ5R9wV5iJ+AzoVdtkY7aqAY/THmD9xOoe1EtKRxfbUGzNWRlOThL9aar1eQfQ/psXAxepEJjCGnDLd5ZSYuagieHFkXE6cyiw+YZNyM57/JYpBuUiM+wb++YgO1eUO1+oZZv+T8Z1/R+UVyroln6aalWZ/6bbkZZEapsfu90RqKjEhg4RWvjKwFtPj2olenAZdQOdzxiXF2QNwP8yRvwS7rqlMrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B/8EtUsBmhM0kzId1CVhqunZv7PcaslRngpQjq/krpejbQkCNgSFyjLIRbbSHy62+bGwKfqJ+cm1lzzdsubM1v2c27zv2L48DX+TQ4GGosbvFn+SwlNY0+sT84KRbkG9zvlv8VOeNBZ2yY70QvLdVA9tuuxoE6yO8gXCAk3odvgn5druNNdjAcZeL5WP8sJpo/oj9iDQVSUcJPQRT+ptqbuGr4Tf8dW/NOX23n/KXyjQ3Qi0QtXS0GOJAw9EBMOy9FDhcKYZZCAlsiarZrJTcW9bVpQZ1OgX3qlXoeBnJhHYo8UnnuBKH93pNV525Dh1XguCFZdxTdozJ197gE1p92MO/bAl6uET868jr2lmTcJxWD7XbJ1kOnhrNJ1NUtaOeCsQ8NBP10VMhHoNZ6EigzBNFWVofkg+urMQxoFgJPlUqO7sGvCMMCvtFDEbIUkhZtikFQKOLiWtncxk/7KtmjtZ1Wwl9uJjba28lmvoqMeReeTfIXizlPQQAe9NReQJmmRQEJQX1oH2RV39XbeQmsaelQV9eQU1Pu9R16xlMEu/SFjF3ULPcK6HTQBT5o7EI3+gL0qP/fD2xp+7rDy7iqrTa7yUKgfdYEAAz6ktv1QidVRGdrQUCPQRfqjscayX6vimxgkNaVgQeyoB8Xnyng==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f8660b-8bf7-4394-d92b-08d87d87d931
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:29.2573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WteTcCy+dAkP/cc9XQmskxg7fXB1WUt1E5Bs7MltHX6Rd4OsoZxC/WZYyDt8+AphZ9s4k1gY0iQTjoF7HbEDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a mechanical patch only.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 55 ++++++++++++++++----------
 drivers/net/ethernet/mscc/ocelot_net.c | 16 ++++----
 include/soc/mscc/ocelot.h              | 14 ++++---
 3 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ae25a79bf907..a7e724ae01f7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -148,27 +148,27 @@ static int ocelot_vlant_set_mask(struct ocelot *ocelot, u16 vid, u32 mask)
 }
 
 static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
-				       u16 vid)
+				       struct ocelot_vlan native_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val = 0;
 
-	if (ocelot_port->vid != vid) {
+	if (ocelot_port->native_vlan.vid != native_vlan.vid) {
 		/* Always permit deleting the native VLAN (vid = 0) */
-		if (ocelot_port->vid && vid) {
+		if (ocelot_port->native_vlan.vid && native_vlan.vid) {
 			dev_err(ocelot->dev,
 				"Port already has a native VLAN: %d\n",
-				ocelot_port->vid);
+				ocelot_port->native_vlan.vid);
 			return -EBUSY;
 		}
-		ocelot_port->vid = vid;
+		ocelot_port->native_vlan = native_vlan;
 	}
 
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
+	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(native_vlan.vid),
 		       REW_PORT_VLAN_CFG_PORT_VID_M,
 		       REW_PORT_VLAN_CFG, port);
 
-	if (ocelot_port->vlan_aware && !ocelot_port->vid)
+	if (ocelot_port->vlan_aware && !ocelot_port->native_vlan.vid)
 		/* If port is vlan-aware and tagged, drop untagged and priority
 		 * tagged frames.
 		 */
@@ -182,7 +182,7 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		       ANA_PORT_DROP_CFG, port);
 
 	if (ocelot_port->vlan_aware) {
-		if (ocelot_port->vid)
+		if (ocelot_port->native_vlan.vid)
 			/* Tag all frames except when VID == DEFAULT_VLAN */
 			val = REW_TAG_CFG_TAG_CFG(1);
 		else
@@ -200,17 +200,18 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 }
 
 /* Default vlan to clasify for untagged frames (may be zero) */
-static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
+static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
+				 struct ocelot_vlan pvid_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	ocelot_port->pvid = pvid;
+	ocelot_port->pvid_vlan = pvid_vlan;
 
 	if (!ocelot_port->vlan_aware)
-		pvid = 0;
+		pvid_vlan.vid = 0;
 
 	ocelot_rmw_gix(ocelot,
-		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid_vlan.vid),
 		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
 		       ANA_PORT_VLAN_CFG, port);
 }
@@ -249,8 +250,8 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
 		       ANA_PORT_VLAN_CFG, port);
 
-	ocelot_port_set_pvid(ocelot, port, ocelot_port->pvid);
-	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->vid);
+	ocelot_port_set_pvid(ocelot, port, ocelot_port->pvid_vlan);
+	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->native_vlan);
 
 	return 0;
 }
@@ -268,12 +269,19 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		return ret;
 
 	/* Default ingress vlan classification */
-	if (pvid)
-		ocelot_port_set_pvid(ocelot, port, vid);
+	if (pvid) {
+		struct ocelot_vlan pvid_vlan;
+
+		pvid_vlan.vid = vid;
+		ocelot_port_set_pvid(ocelot, port, pvid_vlan);
+	}
 
 	/* Untagged egress vlan clasification */
 	if (untagged) {
-		ret = ocelot_port_set_native_vlan(ocelot, port, vid);
+		struct ocelot_vlan native_vlan;
+
+		native_vlan.vid = vid;
+		ret = ocelot_port_set_native_vlan(ocelot, port, native_vlan);
 		if (ret)
 			return ret;
 	}
@@ -294,8 +302,12 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 		return ret;
 
 	/* Egress */
-	if (ocelot_port->vid == vid)
-		ocelot_port_set_native_vlan(ocelot, port, 0);
+	if (ocelot_port->native_vlan.vid == vid) {
+		struct ocelot_vlan native_vlan;
+
+		native_vlan.vid = 0;
+		ocelot_port_set_native_vlan(ocelot, port, native_vlan);
+	}
 
 	return 0;
 }
@@ -1151,6 +1163,7 @@ EXPORT_SYMBOL(ocelot_port_bridge_join);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			     struct net_device *bridge)
 {
+	struct ocelot_vlan pvid = {0}, native_vlan = {0};
 	struct switchdev_trans trans;
 	int ret;
 
@@ -1169,8 +1182,8 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 	if (ret)
 		return ret;
 
-	ocelot_port_set_pvid(ocelot, port, 0);
-	return ocelot_port_set_native_vlan(ocelot, port, 0);
+	ocelot_port_set_pvid(ocelot, port, pvid);
+	return ocelot_port_set_native_vlan(ocelot, port, native_vlan);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index b34da11acf65..cf5c2a0ddfc0 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -409,7 +409,7 @@ static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 
-	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid);
+	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid_vlan.vid);
 }
 
 static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
@@ -418,8 +418,8 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 
-	return ocelot_mact_learn(ocelot, PGID_CPU, addr, ocelot_port->pvid,
-				 ENTRYTYPE_LOCKED);
+	return ocelot_mact_learn(ocelot, PGID_CPU, addr,
+				 ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
 }
 
 static void ocelot_set_rx_mode(struct net_device *dev)
@@ -462,10 +462,10 @@ static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 	const struct sockaddr *addr = p;
 
 	/* Learn the new net device MAC address in the mac table. */
-	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data, ocelot_port->pvid,
-			  ENTRYTYPE_LOCKED);
+	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data,
+			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
 	/* Then forget the previous one. */
-	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid);
+	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid_vlan.vid);
 
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
 	return 0;
@@ -1074,8 +1074,8 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 
 	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
 	dev->dev_addr[ETH_ALEN - 1] += port;
-	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, ocelot_port->pvid,
-			  ENTRYTYPE_LOCKED);
+	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
+			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
 
 	ocelot_init_port(ocelot, port);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cc126d1796be..baf6a498f7d1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -571,18 +571,20 @@ struct ocelot_vcap_block {
 	int pol_lpr;
 };
 
+struct ocelot_vlan {
+	u16 vid;
+};
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
 	struct regmap			*target;
 
 	bool				vlan_aware;
-
-	/* Ingress default VLAN (pvid) */
-	u16				pvid;
-
-	/* Egress default VLAN (vid) */
-	u16				vid;
+	/* VLAN that untagged frames are classified to, on ingress */
+	struct ocelot_vlan		pvid_vlan;
+	/* The VLAN ID that will be transmitted as untagged, on egress */
+	struct ocelot_vlan		native_vlan;
 
 	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
-- 
2.25.1

