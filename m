Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0228D281E07
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgJBWHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:07:14 -0400
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:7143
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgJBWHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 18:07:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acIxOZQzGCJdEJNYSNOB14dcPGkjKhpt3+3HF4x5IRwaoadQR0YjYZ3Sd8u5+49GVfzBvNVH6oPejuKmlA88w/gNKF5uLky8roLf5cOggmPMUa51wBEaed4AtiV92IltbCYPFPzFZo47o2V+k+7yi52kftHtBrQ6nzEs5HPL+phJqNe2gl2Z3G/Lq2zacBoydaWmMQ3zesdVBwfbgeaqPdu8jK2uMofUGbviY2qemgMI68P5kjR6nrbh4SOJZz9Dnw9Lb013qnvoJy2wInb7SB63WFSoagCGtdwVrxxejMesQqpPm7Qs1UFS16DNsEu+mYt5xT7kVrU3pJOw1HaE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3VIv9WhmzsFVx+7T5z7xBKAWJl1+O8hy71H2zsVdxY=;
 b=mYHtvmnRRw5fbGT+flYp9a9UJcggu6DEvqUgsbk2lbopyzFpx3yTJrKx5OlVrTYYfqagKlAhkMlouvWKmwoeOFt8QbafLqgPPeIkz/sg/I18wYGyVSiI99aRqv1TX7Bp46qL0xl/RQz6I4W81MwzeOOINNSElcKpuimGTPXQcO53t/F4ieGfj0kR28lCriUiVwHzQ5+p8wNSmi49aA+6YanvNLfHfkwB2phN7fgUgDXHWrHbh7IYNm9IlKrfD5slqDbWHXLjEBG49A8gJe9EtQClfsbg8sxmQdPCgtdUbYWffm1b05MBjsuSiH5Khybq663AlMyYs0Ff90rPvvG2mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3VIv9WhmzsFVx+7T5z7xBKAWJl1+O8hy71H2zsVdxY=;
 b=YHvkJcRvCnsf5EIAleJnRFqEm17VqxjUwobqWbzvrnv1nb6AMsla2xyxO51B4nYEMOlY6e8eH0iWHYDu8a9AyuLsOLs6WsROeBErr6ColiJ1LNgC0ugm8I24oTY67eLp7jRrwUkKk3zWMW6Ng4JIuSI95JpXLeq1bx6xsdNgSZ0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5503.eurprd04.prod.outlook.com (2603:10a6:803:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 2 Oct
 2020 22:07:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 22:07:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next] net: dsa: propagate switchdev vlan_filtering prepare phase to drivers
Date:   Sat,  3 Oct 2020 01:06:46 +0300
Message-Id: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::40) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Fri, 2 Oct 2020 22:07:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a0c21735-0713-4a49-27f5-08d8671f7f8c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB55031A9C5B4395D1579EC1B6E0310@VI1PR04MB5503.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+ODsOeoqbyo8OFtBvnP3eD8sf3r7wTyHkA6w0dVg6L+6gVQj94IFrRmyjAM9QOIXmiwMgL2hc6cDQb8+urqr/DpvkpxBX9Se98Rk0giqaequ4x54AR5iHNGWobqpiNLZntYL1dO9yy9aMDmgQK+U5W5sbC72HwP6Vd5YcKl8hbDlurbIOHaNdS4IWyj2A8nTDtKgJKefCCW7P++fr9g30vbdiCHUavby36H65MeuU66zJlQyHZzG1NRSBtrHu3RpefXgFvY3uRES/39pXP7H7O41z/xLEll23BsailbaBdHloh6Ts5y6yy6Bte58RdrvX8VPDCgkXUUeco/NFLlDHBr1Q1jAa44X+6Kcv4kMEDSnjniDhH3jZ8aI2cafQ33
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(956004)(2616005)(186003)(7416002)(26005)(83380400001)(36756003)(478600001)(69590400008)(54906003)(316002)(16526019)(2906002)(6512007)(86362001)(4326008)(44832011)(6506007)(66476007)(8676002)(1076003)(6666004)(30864003)(52116002)(66946007)(6486002)(8936002)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p7MED9f+cg0IIvdUoGYqZicapcUQO0yGq4o+BeJtNvlyKMu9myjY1jOYwMxkQbCzBhRAXATI2mrWL85Gxsx2z/uZF7tfVgZyas2D2BRz/8Q/6AUtdO1fSXWxDjYVVfi941ZEKmZMyLoEPAQCY4ZZKMb+uG2phJ0IdZWe4W3EcUEazy3wqm69VrNefWUbeVzEztYwKZCMIRs4yuen0+ayOWWNFziBv4YcYy/dvPxd4WoLzzXm9ulNC3HIXVy9I50vQfTqIeiQATEHPkjLmyCR5f1a6yL1f/3E0tOq4/Nq71Tzgp14oWRN98Vu/oaxyi2z9j8VdUn/PJBQIWtQjjGV5fodcGBTBzq+FH3lJPtoNeenEZdz11Rcu6bvbwhKlSvIa7Ek05mUVEKUO4uzP40cXicwpLUNVMDgdY1yl4sHGkr8kSZQ0UDzg/OfgVSptzNqt92w4atU9HdpSUbUQzx/J7/K7ByrOFybGQqasTTQI1j2yfkXaRcwQjlqVkWOE+BQbLj06Z+Jo6WxGG4dDTaHw6GgKp/mmYaB9rfJ+ytqxQvrERIwxazewhHlxdzqxHeIJX79fAFIQtrf3rsyreBq1lqSVSEV3O9UE1QY/dwr9h8Ktf4RHPApbZBsRLzTQD5q/d6fGaIddJlUbJQqcq6hZw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c21735-0713-4a49-27f5-08d8671f7f8c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 22:07:06.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCwF/tiKZ3E8EJV1hTJne/ry2L6Dpdgw3XfcKWiBryQFSJXpj45721bhw74uEYNP2cwy9ccM9+Au5sx9ZvzjWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A driver may refuse to enable VLAN filtering for any reason beyond what
the DSA framework cares about, such as:
- having tc-flower rules that rely on the switch being VLAN-aware
- the particular switch does not support VLAN, even if the driver does
  (the DSA framework just checks for the presence of the .port_vlan_add
  and .port_vlan_del pointers)
- simply not supporting this configuration to be toggled at runtime

Currently, when a driver rejects a configuration it cannot support, it
does this from the commit phase, which triggers various warnings in
switchdev.

So propagate the prepare phase to drivers, to give them the ability to
refuse invalid configurations cleanly and avoid the warnings.

Since we need to modify all function prototypes and check for the
prepare phase from within the drivers, take that opportunity and move
the existing driver restrictions within the prepare phase where that is
possible and easy.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: Landen Chao <Landen.Chao@mediatek.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Jonathan McDowell <noodles@earth.li>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
The API for this one was chosen to be different than the one for
.port_vlan_add and .port_vlan_prepare because
(a) the list of dsa_switch_ops is growing bigger but in this case there
    is no justification for it. For example there are some drivers that
    don't do anything in .port_vlan_prepare, and likewise, they may not
    need to do anything in .port_vlan_filtering_prepare either
(b) the DSA API should be as close as possible to the switchdev API
    except when there's a strong reason for that not to be the case. In
    this situation, I don't see why it would be different.

 drivers/net/dsa/b53/b53_common.c          |  6 +++++-
 drivers/net/dsa/b53/b53_priv.h            |  3 ++-
 drivers/net/dsa/dsa_loop.c                |  3 ++-
 drivers/net/dsa/lantiq_gswip.c            | 26 ++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz8795.c       |  6 +++++-
 drivers/net/dsa/microchip/ksz9477.c       |  6 +++++-
 drivers/net/dsa/mt7530.c                  |  6 +++++-
 drivers/net/dsa/mv88e6xxx/chip.c          |  7 +++---
 drivers/net/dsa/ocelot/felix.c            |  7 +++---
 drivers/net/dsa/qca8k.c                   |  6 +++++-
 drivers/net/dsa/realtek-smi-core.h        |  3 ++-
 drivers/net/dsa/rtl8366.c                 | 11 +++++++---
 drivers/net/dsa/sja1105/sja1105.h         |  3 ++-
 drivers/net/dsa/sja1105/sja1105_devlink.c |  9 +++++++-
 drivers/net/dsa/sja1105/sja1105_main.c    | 17 +++++++++------
 drivers/net/ethernet/mscc/ocelot.c        | 23 +++++++++++++++++---
 drivers/net/ethernet/mscc/ocelot_net.c    |  2 +-
 include/net/dsa.h                         |  3 ++-
 include/soc/mscc/ocelot.h                 |  4 ++--
 net/dsa/port.c                            | 17 ++++++++-------
 net/dsa/switch.c                          |  9 +++++++-
 21 files changed, 130 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 73507cff3bc4..c3dec63b7610 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1374,10 +1374,14 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_phylink_mac_link_up);
 
-int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
+int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+		       struct switchdev_trans *trans)
 {
 	struct b53_device *dev = ds->priv;
 
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
 	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
 
 	return 0;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 24893b592216..7c67409bb186 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -347,7 +347,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     struct phy_device *phydev,
 			     int speed, int duplex,
 			     bool tx_pause, bool rx_pause);
-int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering);
+int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+		       struct switchdev_trans *trans);
 int b53_vlan_prepare(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan);
 void b53_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index b588614d1e5e..e38906ae8f23 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -190,7 +190,8 @@ static void dsa_loop_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_vlan_filtering(struct dsa_switch *ds, int port,
-					bool vlan_filtering)
+					bool vlan_filtering,
+					struct switchdev_trans *trans)
 {
 	dev_dbg(ds->dev, "%s: port: %d, vlan_filtering: %d\n",
 		__func__, port, vlan_filtering);
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 521ebc072903..74db81dafee3 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -736,14 +736,23 @@ static int gswip_pce_load_microcode(struct gswip_priv *priv)
 }
 
 static int gswip_port_vlan_filtering(struct dsa_switch *ds, int port,
-				     bool vlan_filtering)
+				     bool vlan_filtering,
+				     struct switchdev_trans *trans)
 {
 	struct gswip_priv *priv = ds->priv;
-	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 
 	/* Do not allow changing the VLAN filtering options while in bridge */
-	if (!!(priv->port_vlan_filter & BIT(port)) != vlan_filtering && bridge)
-		return -EIO;
+	if (switchdev_trans_ph_prepare(trans)) {
+		struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
+
+		if (!bridge)
+			return 0;
+
+		if (!!(priv->port_vlan_filter & BIT(port)) != vlan_filtering)
+			return -EIO;
+
+		return 0;
+	}
 
 	if (vlan_filtering) {
 		/* Use port based VLAN tag */
@@ -781,8 +790,15 @@ static int gswip_setup(struct dsa_switch *ds)
 
 	/* disable port fetch/store dma on all ports */
 	for (i = 0; i < priv->hw_info->max_ports; i++) {
+		struct switchdev_trans trans;
+
+		/* Skip the prepare phase, this shouldn't return an error
+		 * during setup.
+		 */
+		trans.ph_prepare = false;
+
 		gswip_port_disable(ds, i);
-		gswip_port_vlan_filtering(ds, i, false);
+		gswip_port_vlan_filtering(ds, i, false, &trans);
 	}
 
 	/* enable Switch */
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f5779e152377..1e101ab56cea 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -782,10 +782,14 @@ static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 }
 
 static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag)
+				       bool flag,
+				       struct switchdev_trans *trans)
 {
 	struct ksz_device *dev = ds->priv;
 
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_VLAN_ENABLE, flag);
 
 	return 0;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 153664bf0e20..abfd3802bb51 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -493,10 +493,14 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 }
 
 static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag)
+				       bool flag,
+				       struct switchdev_trans *trans)
 {
 	struct ksz_device *dev = ds->priv;
 
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
 	if (flag) {
 		ksz_port_cfg(dev, port, REG_PORT_LUE_CTRL,
 			     PORT_VLAN_LOOKUP_VID_0, true);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index cb3efa7de7a8..de7692b763d8 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1289,8 +1289,12 @@ mt7530_vlan_cmd(struct mt7530_priv *priv, enum mt7530_vlan_cmd cmd, u16 vid)
 
 static int
 mt7530_port_vlan_filtering(struct dsa_switch *ds, int port,
-			   bool vlan_filtering)
+			   bool vlan_filtering,
+			   struct switchdev_trans *trans)
 {
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
 	if (vlan_filtering) {
 		/* The port is being kept as VLAN-unaware port when bridge is
 		 * set up with vlan_filtering not being set, Otherwise, the
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9417412e5fce..bd297ae7cf9e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1578,15 +1578,16 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
-					 bool vlan_filtering)
+					 bool vlan_filtering,
+					 struct switchdev_trans *trans)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	u16 mode = vlan_filtering ? MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE :
 		MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED;
 	int err;
 
-	if (!chip->info->max_vid)
-		return -EOPNOTSUPP;
+	if (switchdev_trans_ph_prepare(trans))
+		return chip->info->max_vid ? 0 : -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_set_8021q_mode(chip, port, mode);
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 552b1f7bde17..f791860d495f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -119,13 +119,12 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
+static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
+				struct switchdev_trans *trans)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_vlan_filtering(ocelot, port, enabled);
-
-	return 0;
+	return ocelot_port_vlan_filtering(ocelot, port, enabled, trans);
 }
 
 static void felix_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f1e484477e35..53064e0e1618 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1294,10 +1294,14 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int
-qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
+qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			  struct switchdev_trans *trans)
 {
 	struct qca8k_priv *priv = ds->priv;
 
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
 	if (vlan_filtering) {
 		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
 			  QCA8K_PORT_LOOKUP_VLAN_MODE,
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 6f2dab7e33d6..5e2e11a26da3 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -129,7 +129,8 @@ int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
 int rtl8366_reset_vlan(struct realtek_smi *smi);
 int rtl8366_init_vlan(struct realtek_smi *smi);
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port,
-			   bool vlan_filtering);
+			   bool vlan_filtering,
+			   struct switchdev_trans *trans);
 int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_vlan *vlan);
 void rtl8366_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index c58ca324a4b2..307466b90489 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -340,15 +340,20 @@ int rtl8366_init_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_init_vlan);
 
-int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
+int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			   struct switchdev_trans *trans)
 {
 	struct realtek_smi *smi = ds->priv;
 	struct rtl8366_vlan_4k vlan4k;
 	int ret;
 
 	/* Use VLAN nr port + 1 since VLAN0 is not valid */
-	if (!smi->ops->is_vlan_valid(smi, port + 1))
-		return -EINVAL;
+	if (switchdev_trans_ph_prepare(trans)) {
+		if (!smi->ops->is_vlan_valid(smi, port + 1))
+			return -EINVAL;
+
+		return 0;
+	}
 
 	dev_info(smi->dev, "%s filtering on port %d\n",
 		 vlan_filtering ? "enable" : "disable",
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d582308c2401..4ebc4a5a7b35 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -245,7 +245,8 @@ enum sja1105_reset_reason {
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
 				 enum sja1105_reset_reason reason);
-int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled);
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
+			   struct switchdev_trans *trans);
 void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
 
 /* From sja1105_devlink.c */
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index b4bf1b10e66c..4a2ec395bcb0 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -135,6 +135,7 @@ static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
 
 	rtnl_lock();
 	for (port = 0; port < ds->num_ports; port++) {
+		struct switchdev_trans trans;
 		struct dsa_port *dp;
 
 		if (!dsa_is_user_port(ds, port))
@@ -143,7 +144,13 @@ static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
 		dp = dsa_to_port(ds, port);
 		vlan_filtering = dsa_port_is_vlan_filtering(dp);
 
-		rc = sja1105_vlan_filtering(ds, port, vlan_filtering);
+		trans.ph_prepare = true;
+		rc = sja1105_vlan_filtering(ds, port, vlan_filtering, &trans);
+		if (rc)
+			break;
+
+		trans.ph_prepare = false;
+		rc = sja1105_vlan_filtering(ds, port, vlan_filtering, &trans);
 		if (rc)
 			break;
 	}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 547487c535df..4ca029650993 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2634,7 +2634,8 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
  * which can only be partially reconfigured at runtime (and not the TPID).
  * So a switch reset is required.
  */
-int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
+			   struct switchdev_trans *trans)
 {
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
@@ -2646,12 +2647,16 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	u16 tpid, tpid2;
 	int rc;
 
-	list_for_each_entry(rule, &priv->flow_block.rules, list) {
-		if (rule->type == SJA1105_RULE_VL) {
-			dev_err(ds->dev,
-				"Cannot change VLAN filtering state while VL rules are active\n");
-			return -EBUSY;
+	if (switchdev_trans_ph_prepare(trans)) {
+		list_for_each_entry(rule, &priv->flow_block.rules, list) {
+			if (rule->type == SJA1105_RULE_VL) {
+				dev_err(ds->dev,
+					"Cannot change VLAN filtering with active VL rules\n");
+				return -EBUSY;
+			}
 		}
+
+		return 0;
 	}
 
 	if (enabled) {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e026617d6133..a965a554ff8b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -199,12 +199,15 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 	return 0;
 }
 
-void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-				bool vlan_aware)
+int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
+			       bool vlan_aware, struct switchdev_trans *trans)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val;
 
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
 	ocelot_port->vlan_aware = vlan_aware;
 
 	if (vlan_aware)
@@ -218,6 +221,8 @@ void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		       ANA_PORT_VLAN_CFG, port);
 
 	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->vid);
+
+	return 0;
 }
 EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
@@ -1102,12 +1107,24 @@ EXPORT_SYMBOL(ocelot_port_bridge_join);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			     struct net_device *bridge)
 {
+	struct switchdev_trans trans;
+	int ret;
+
 	ocelot->bridge_mask &= ~BIT(port);
 
 	if (!ocelot->bridge_mask)
 		ocelot->hw_bridge_dev = NULL;
 
-	ocelot_port_vlan_filtering(ocelot, port, 0);
+	trans.ph_prepare = true;
+	ret = ocelot_port_vlan_filtering(ocelot, port, false, &trans);
+	if (ret)
+		return ret;
+
+	trans.ph_prepare = false;
+	ret = ocelot_port_vlan_filtering(ocelot, port, false, &trans);
+	if (ret)
+		return ret;
+
 	ocelot_port_set_pvid(ocelot, port, 0);
 	return ocelot_port_set_native_vlan(ocelot, port, 0);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 64e619f0f5b2..d3c03942546d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -790,7 +790,7 @@ static int ocelot_port_attr_set(struct net_device *dev,
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
 		ocelot_port_vlan_filtering(ocelot, port,
-					   attr->u.vlan_filtering);
+					   attr->u.vlan_filtering, trans);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b502a63d196e..e8ca00678cbd 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -543,7 +543,8 @@ struct dsa_switch_ops {
 	 * VLAN support
 	 */
 	int	(*port_vlan_filtering)(struct dsa_switch *ds, int port,
-				       bool vlan_filtering);
+				       bool vlan_filtering,
+				       struct switchdev_trans *trans);
 	int (*port_vlan_prepare)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
 	void (*port_vlan_add)(struct dsa_switch *ds, int port,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 46608494616f..1e9db9577441 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -730,8 +730,8 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev);
-void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-				bool vlan_aware);
+int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
+			       struct switchdev_trans *trans);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9a4fb80d2731..73569c9af3cc 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -280,22 +280,23 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 		rcu_read_unlock();
 		if (!apply)
 			return -EINVAL;
-
-		return 0;
 	}
 
 	if (dsa_port_is_vlan_filtering(dp) == vlan_filtering)
 		return 0;
 
-	err = ds->ops->port_vlan_filtering(ds, dp->index,
-					   vlan_filtering);
+	err = ds->ops->port_vlan_filtering(ds, dp->index, vlan_filtering,
+					   trans);
 	if (err)
 		return err;
 
-	if (ds->vlan_filtering_is_global)
-		ds->vlan_filtering = vlan_filtering;
-	else
-		dp->vlan_filtering = vlan_filtering;
+	if (switchdev_trans_ph_commit(trans)) {
+		if (ds->vlan_filtering_is_global)
+			ds->vlan_filtering = vlan_filtering;
+		else
+			dp->vlan_filtering = vlan_filtering;
+	}
+
 	return 0;
 }
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9afef6f0f9df..3fb362b6874e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -139,8 +139,15 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 		}
 	}
 	if (unset_vlan_filtering) {
-		struct switchdev_trans trans = {0};
+		struct switchdev_trans trans;
 
+		trans.ph_prepare = true;
+		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
+					      false, &trans);
+		if (err && err != EOPNOTSUPP)
+			return err;
+
+		trans.ph_prepare = false;
 		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
 					      false, &trans);
 		if (err && err != EOPNOTSUPP)
-- 
2.25.1

