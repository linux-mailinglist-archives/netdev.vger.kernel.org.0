Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4AD27C216
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgI2KLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:46 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:58854
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728292AbgI2KLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLIPbe+t1AR8FX+129hFgJY0TixX0spE6Xx8ctE/4FDW61ZEqW09RZq358JD6HsgoSVnxsbIhgnFShm2LdRKF7+FeAPQaqwDSZt9Um36BB/NP5peAPOhrQQGLLU0tEPtr9P2D1G8hyxMUbWYkJoLGyyGg4eDXeDUoRmM2+OOPcFOrrPr5LnTOyZUDGTgCLQnhTNzr2SZRUHIBhe+L9kH1Q3YL0iuxguxXAc6A5lWV5hEk/F2Bq5/sQCxPOHJ3UVx0hFjtgjDQW0CGRuKN3SnxpKRZdS7p6DP9AioypaL5YLjYORuBforbV7UtCPh0ltJOGVqOUhcCka/eV3dwAuTaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBDy3vZNjhXsNvip0ZxVpWDFq8n8tAVPbIeoaPmgYvk=;
 b=R/ay5mN2pGSRO627ZWBkiQqf08GTPR1KhfhZTauy/5F94nnYtaIkHgfnVm93LbWyfChoinU2jAGAE5yL6QcfmZoCiBDmMu4Qlwwh+ZvNj9susPdEsNscYgZkPNjTcjx6YWCIKqtUIsvf5TYBi1orEfxsu+y8c30+6XNGrrl6KVjEJKjbml+UlK6CNebJlVCrFjmY0Txwtj4Cybr32p0at3hn5Y0WzeLG9r8wdHgFp9nXVS8eeM3ea8OST7Yet8x8BVAHOIx9Y50UViGrl0EVlr4ueSNdysM5gdAo+5cYOt9IPngR6v0KbaMVg6CEX5iuwIhkBdus5U3OaWg0oO8zow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBDy3vZNjhXsNvip0ZxVpWDFq8n8tAVPbIeoaPmgYvk=;
 b=FAMas5GLOg9h5Ex4t0U8461trOlHx7PcOKDRcWr9OOr5BjOOHptz/cQHcRJSkhzfPa6ugf4nTxk1G+2rVD9f2fuRxEyIvBuGYdWGyRseLfaCErlS0lpI1zVAigkCLizbEwhCr2cuMDpqCyXarAGaxC747hOsWQ8e07eOOhvZKJQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:46 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 14/21] net: mscc: ocelot: introduce conversion helpers between port and netdev
Date:   Tue, 29 Sep 2020 13:10:09 +0300
Message-Id: <20200929101016.3743530-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed76418d-aadd-4f27-f84e-08d8645fee6e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295DB6CF872845BD328D74EE0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hx910EnKZ9oV8WCoL/EUeVr35nUwX3p2WB1pjNlktrlZi3MPKVqikSaErxllNmCrslfeTnygo3sv1Ny13eqlrwJVftYo3y0XgkOydWpb6lEBFNfAbbCDnA21hm0x8aeU9PGvtDCVA4OwMS4LYty3gYeX+7Gc/XFJecNiHaeAk5Vw3GcvN5q8xWw8dHU249CEARadrnw7/rtKzxsYQaVS3wgHG0Thu0IYc9vfsiyeINOC1Xb6wTw1cOMlxQObFpUaZl2PDrFkjkzgHNd1LOVJJhaIUkMyACBoi9M0woQFqFS/md6u6QzK2mQyXZXvi2+J5NW9+dWCDDljIth8Vey5SeE1x7loxFQeMf/s/piLTjl81Ihodr1JF8wz1V3o+dVdc+oS/sD4GdKet4KrXu1jNspz5iXDrKBrYOw/47z+wluz2QiEEDEXf3oeormLlysV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: y/XEoJLTkeSx8TtVpfwZpj4JhDzqGHz/sJ/ECjfYa1iRf3mE672RBJcVAgrWq6PoRR+I6FT9nVJGb9WWEt7zm0MqOJJv5qub461gpXx22LBsLIlAZlprFxsgUzS/gLpJ3o71gKX3UL/0Jfa3bk+bjf3GIuqp5PjCWw5x+q22dqlxya82/KEiQh8fNwvDklFl4bzntoYjxlimagFunXnNrhbREQVWaaq5kN6C9anRnGArrIzxYq8rUW6piM+gXlkW9Bkt7E1wi3RkYlZzprHPj6MXoMv7NGcbZyOJ58RUtJXEg3DzZFxMbnfio3EEaAvubXfXDl0wvsA8FjYiQ3QlasgJKtwaDCzKoyahdfXy3B9+DkkObKAJV6zKJF1OgWeKJt2xO73QVaWp3KtGxTa/YGMOTdA2raXsazwBfrQr8calzvPGlrAUFW3pH+Iv2DSni2RwqKH5c+GjKjbh+ZmtOCWGzM+NfI9XgwM7/uhh8fX/WkGjnKclGM5gEOssnBV/4HcojnGf+sZiHi573WRjqSmjXRinzqM0m3hdoxnJeQ/ApheT48nm5gtEoAeoePt0rDwYERiTtnizPJLF41vlBdh3UQRqQn4Bzj9tTHXvdYaXf5UYkWmI1Q3HABYJLo3NnQ42JIxLe6bltBNSS0EZaw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed76418d-aadd-4f27-f84e-08d8645fee6e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:46.0124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEE68b2qgEHCn+JspwZOte3uKJQy63DwRWSTuJp5BfyGo4NDBgvS6vkpt9OCYepq/9ybdm3JuZ7B6rF38zUGkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the mscc_ocelot_switch_lib is common between a pure switchdev and
a DSA driver, the procedure of retrieving a net_device for a certain
port index differs, as those are registered by their individual
front-ends.

Up to now that has been dealt with by always passing the port index to
the switch library, but now, we're going to need to work with net_device
pointers from the tc-flower offload, for things like indev, or mirred.
It is not desirable to refactor that, so let's make sure that the flower
offload core has the ability to translate between a net_device and a
port index properly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c             | 22 ++++++++++++++++
 drivers/net/dsa/ocelot/felix.h             |  3 +++
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 ++
 drivers/net/ethernet/mscc/ocelot.h         |  2 ++
 drivers/net/ethernet/mscc/ocelot_net.c     | 30 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 ++
 include/soc/mscc/ocelot.h                  |  2 ++
 8 files changed, 65 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9c81be370114..2039aa705b35 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -809,3 +809,25 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_stats	= felix_cls_flower_stats,
 	.port_setup_tc		= felix_port_setup_tc,
 };
+
+struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+
+	if (!dsa_is_user_port(ds, port))
+		return NULL;
+
+	return dsa_to_port(ds, port)->slave;
+}
+
+int felix_netdev_to_port(struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	dp = dsa_port_from_netdev(dev);
+	if (IS_ERR(dp))
+		return -EINVAL;
+
+	return dp->index;
+}
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 295c3e9cad54..5434fe278d2c 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -51,4 +51,7 @@ struct felix {
 	resource_size_t			imdio_base;
 };
 
+struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
+int felix_netdev_to_port(struct net_device *dev);
+
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index de18e106edd3..01d0e698b77a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1006,6 +1006,8 @@ static u16 vsc9959_wm_enc(u16 value)
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
+	.port_to_netdev		= felix_port_to_netdev,
+	.netdev_to_port		= felix_netdev_to_port,
 };
 
 static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 8ed7354ba98b..a3265220fcc4 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1058,6 +1058,8 @@ static u16 vsc9953_wm_enc(u16 value)
 static const struct ocelot_ops vsc9953_ops = {
 	.reset			= vsc9953_reset,
 	.wm_enc			= vsc9953_wm_enc,
+	.port_to_netdev		= felix_port_to_netdev,
+	.netdev_to_port		= felix_netdev_to_port,
 };
 
 static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index dc29e05103a1..abb407dff93c 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -98,6 +98,8 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
+struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
+int ocelot_netdev_to_port(struct net_device *dev);
 
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 028a0150f97d..64e619f0f5b2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -656,6 +656,36 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_do_ioctl			= ocelot_ioctl,
 };
 
+struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port_private *priv;
+
+	if (!ocelot_port)
+		return NULL;
+
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+
+	return priv->dev;
+}
+
+static bool ocelot_port_dev_check(const struct net_device *dev)
+{
+	return dev->netdev_ops == &ocelot_port_netdev_ops;
+}
+
+int ocelot_netdev_to_port(struct net_device *dev)
+{
+	struct ocelot_port_private *priv;
+
+	if (!dev || !ocelot_port_dev_check(dev))
+		return -EINVAL;
+
+	priv = netdev_priv(dev);
+
+	return priv->chip_port;
+}
+
 static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
 				    u8 *data)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index b66416f55d84..c33356d9dd0d 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -762,6 +762,8 @@ static u16 ocelot_wm_enc(u16 value)
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
+	.port_to_netdev		= ocelot_port_to_netdev,
+	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
 static struct vcap_field vsc7514_vcap_es0_keys[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 17a72954f3e7..2c636d361021 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -559,6 +559,8 @@ enum ocelot_tag_prefix {
 struct ocelot;
 
 struct ocelot_ops {
+	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
+	int (*netdev_to_port)(struct net_device *dev);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
 };
-- 
2.25.1

