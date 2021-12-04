Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E12468765
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbhLDUPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:15:31 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231561AbhLDUPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9eyKs7jGlYPyk7cgUDZW6gEXh6KMw1yf8IAKzwVABch1Vi36RIvOgbBFERpPjw/ypBqLZwn0wcaCXq6vy2C/KdNJivSg1caiwinLy9t9Sum7Ous0rymk+3ZC4Z+drPJpzaeCZAqjlE9Y/8xmZ2UVuR3XISkiA5ejOMQDDKjFbFyIuxfpORe517A8WzeaMdQt4ajgfSuVH8G6S1WpZTmYJIymxI5Fchz7OD+ZVRZ1EQoYRkCQGmkZakkxzEYoWhgk0Wq7FjJxNXfNUkIz2bm6RvUU73AvpDJzd/EW2+coJh0J0kQTqQRbS+c7uzjTVwxwf0LmwTja8BKferKl8JbIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkdnDqkZvBSAy6u8ojgcdP69xjPW3/++ZqmyduFMumg=;
 b=AhwjuFtWLQmY4TGysijj7CGgFfab8ogampSrC8Atntc7qjXwBi7Z6lSZ9TqfZZRrvL3sUKM1/87OW9KKmFOjzKbYYrtWfU8mV6s3ml/hjOvxvGjko4tytNBPBJ7LqsB5WHbsRF+dOArSYEpQJXHSepsxSB+hW8L6oyWmMJNL4AmfqWtyhYZOC21q5FRYB9r/akVyHCNyZqDm4aiFE8XBMZXdWjvGFq62pBfDVEl8h9jR57bEC8LbDuOz4NzQWx6TlTdKGGxVI7U+uEBQVf6o560/EqnVKoYd/yv1uMiYHoE/Xpc88WznQ1t4VvYfR7I6hNur0vfc2taRB2vZcbFUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkdnDqkZvBSAy6u8ojgcdP69xjPW3/++ZqmyduFMumg=;
 b=k6A4j3zXeliiYllvmA1EXKe1rAL0uwmduO49KsKGLOPdZMGxhvc9CwvsVE3/1OFghFsRBisA0nOUDbCCSM3VnYL+oI1tZoqXLnjuLMddAgpKyZVme2mQyKkxY7080+yu8NXbTMYaE2Rh9E7pyxDatPzNvBaj/Ceio4kcDuoVx1k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:12:02 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:12:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 3/7] net: dsa: hide dp->bridge_dev and dp->bridge_num behind helpers
Date:   Sat,  4 Dec 2021 22:11:42 +0200
Message-Id: <20211204201146.4088103-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:12:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c749e33-7fc8-4bac-e640-08d9b762556f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB365128BCEB544829EDC4D582E06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n39vOEfu1Ij8F/yIGrXINFF2cKS/QXmvmjmTD89vDk0Ug6xY4uwu1Ag+bMF+z5FXqg4D7InIw/KW1CyhF0op0hvuh/u7OGwnxHrfck5WJuoRsyZ84z9IspqNUuzVIxKUh0gVvKY1pxxee2jISCbiU95vJVC0MzZMRK2K+uOGqeZ0esc9VhkEwbFfD+jlJ8o2hfri2gLbfwLXLGGASYm/zjfZO5tcjvBCSvnRaKgIP2hXvMfMnRI/Cw2xiFywQ7xfHHyNgGYMb7efc2/HhSTaj8wgdbpj1Z8ab5IPLUS5CqComrp8+mdaTdmM9OlB/xBjCrFG9IgXMaZx+ZorTGy2FUYc28KMTv56HKUaapEtLY84UnzlRmUC/pG4C1NecddahU9PJ4KpkS3Nj44l/CtEPrrCvZfDJndHfqmf1/ajbzSmX8EJTi8o5+VimHH3Z/oBHhO7QIts8n5ErxJm1eheNDBzUfccy9OyqDc2CuZklWAISUdxeLbKiJdBnyldSxCBolzKyEIeVxJIc3BEpTpE9GLa2+1TJsUUFxCjseckvtbCNans7lzoJiXixlTwf8L3D3wP8EtXSgDDGnrKLyU0+8OTMiJBjj2rxfUhM7Wlv43/+lbBq/POkLlRgQm1PYb6ugEGo/tmrcyaMRM4sF+oZs8iTFFjq2vWt9M+LDzfRRUT9bgQW6h6wxA2g5VcfCp5+MUPuicOWvDT29WOWhuUZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(30864003)(38100700002)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MfoQpUl3FwG3SpeL8aUVx4omskFjcqGWAPaMKQ3I+Z3nyKZPscrsqnRPn7qS?=
 =?us-ascii?Q?/eaWsQi+pVZs4PZ9cCZjXE8hU1kldZGlp+gJcqCx0d6R9Uj7G4QNnYoWtG4Z?=
 =?us-ascii?Q?tgfZ4g9WVHzBXuwf1sGffRICrqzH+iCBjiiG+Fp8XX/Lk4jTvvZXW/VtYLEN?=
 =?us-ascii?Q?sGF3fV05Tjj7mxRqaWKJnZ9wJwYBWvWm0VwxacqYn28Y7t8+t3UlwsS/RNHm?=
 =?us-ascii?Q?WGY+UlJiAMV0eXdmQzA3p+YY6ItTzkGJ3bKskYn7vHuXSCj82Lgn4bpS6m6I?=
 =?us-ascii?Q?Wn/5DlZrbIU/tcVuf5U1iNRiYMqUO09NnFdnV2oODM9yfxxsYFfkvls+AJSD?=
 =?us-ascii?Q?uoXefn8DBh+zYWecuEyVSdwxiqXTqL0uiXL+5efH+0rCnV2rgxVMykQj7hBV?=
 =?us-ascii?Q?bdH1kvF1SewK6b6NDD50dIBJtUFyPclWyvqoMWHbII4EPGJAg53JmWEuXHCB?=
 =?us-ascii?Q?eo8KeZcQXeS70f9QMsQY976ux6RS594ilXRFghTu4XExhNiuk9d0TA9u5qdh?=
 =?us-ascii?Q?ymOSse7RphRCIAOufDTHrh7rcaNgcVI0VSdmf+VdP2gWW+oZCevFLTaJHeSi?=
 =?us-ascii?Q?Cq+8gWEvxdIykQP09SVIKFHuHTxzK8hYzOZzskd4WiFhqojUta6bt3HhRuFJ?=
 =?us-ascii?Q?eiHQd7LgrZwTOX9Wwhi/4cA+CRX2i1MvTOmww4zaQJuWyke3LADFuYvLzAOY?=
 =?us-ascii?Q?nz8FNNakgH8tjczGUTAL3s+uOOWjTbuu3nsErFSrNfSHA/spyELQdjqNlZAg?=
 =?us-ascii?Q?AZOxUOit5ziSkCS4q9g3Se9uBfB7HI5fmhxQRBTPK+02cgapbXAUwWu0glKY?=
 =?us-ascii?Q?n0Lxz/u41piBxr1AqtXVHppg/41cTUol9e0XcyKBQEbjB1mPovwKmSb1FKfj?=
 =?us-ascii?Q?nEvq8OTwqDvii7PNp3uj+X8qCOdCxahEK0SyXLshULDq+RYqK5XhJof8+xl7?=
 =?us-ascii?Q?QvqPKw9stQFyTfIHzQYF5bO5TRW2EsmTVWsarvfHs4v7a7flSSUgNOuu9l5Y?=
 =?us-ascii?Q?3Hjn8aRUVVmGIH6sP7mXEETYnvH2q4hk5WvFWsVE0VUoLXialP8bDszVRInY?=
 =?us-ascii?Q?hrbhIz5leb14Wr4dKvZWGHNof9O+qZvpEIG1x/aI/ruIHDZ1mwo35ZwcZiTf?=
 =?us-ascii?Q?geVWvoVJWRxLuHsWSiSHPQH7vpEkkIj3NL9S17IEh+XmqB6H1d0MNBJypiGT?=
 =?us-ascii?Q?kASpPAcnSFJuVfGn3bY5ev/4E42zgf4HVs7TkNIP6FyDaPNWvWWG2hI8W+FY?=
 =?us-ascii?Q?qDkSqyB1S/7JTrv22EPJJ0cG3zYYyemsQsvFSIiVWTIpMQbWXyQ7EPKzv5r3?=
 =?us-ascii?Q?YMjKf1EZh2MGBqVChy+u3kOYo2A5UCvaWzUCIxapifNqsWqyDkp43mKwCQz1?=
 =?us-ascii?Q?uiKwzXrpQiq3h5AGUNHnRNxUUq6vk+1HdGsP/iQiOiR8c865ks1AO8jpto8/?=
 =?us-ascii?Q?0hwnkUzIg/PVQmy5NKowc2D69A1JESXx15tHEQNm04k46ih3LhLBlHoCbKtJ?=
 =?us-ascii?Q?Nf1UU4BvSp4Mosj/gCEMVW2fxMrp6+NvcuzXWM6oJxxDEn/Jh73f1WvZpipb?=
 =?us-ascii?Q?HTyLws9V9ZRiYMk42wAGwtNoAy5+Mml/55B4GCat1VcSZcc6FyYTJvPbsk+T?=
 =?us-ascii?Q?jTIjnt3AI8h872Y+F+lj7i4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c749e33-7fc8-4bac-e640-08d9b762556f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:12:02.0349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQmDHyAGFRjROGtadtnBkEK2QohGKirGlwvIK3etikwXEJ/PjzT9Zupgpv+CW4pnkdtbkVElq90JsYIZHtmrsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The location of the bridge device pointer and number is going to change.
It is not going to be kept individually per port, but in a common
structure allocated dynamically and which will have lockdep validation.

Create helpers to access these elements so that we have a migration path
to the new organization.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- convert ksz_common.c too, after Oleksij's commit b3612ccdf284
  ("net: dsa: microchip: implement multi-bridge support").
- make dsa_port_bridge_dev_get take const struct dsa_port * arguments.
- make dsa_port_bridge_same return false for two standalone ports.

 drivers/net/dsa/b53/b53_common.c       |  4 +-
 drivers/net/dsa/lan9303-core.c         |  2 +-
 drivers/net/dsa/lantiq_gswip.c         | 10 ++---
 drivers/net/dsa/microchip/ksz_common.c |  2 +-
 drivers/net/dsa/mt7530.c               | 14 ++++---
 drivers/net/dsa/mv88e6xxx/chip.c       | 56 ++++++++++++++------------
 drivers/net/dsa/qca8k.c                |  4 +-
 drivers/net/dsa/rtl8366rb.c            |  4 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 10 +++--
 drivers/net/dsa/xrs700x/xrs700x.c      |  4 +-
 include/net/dsa.h                      | 21 ++++++++++
 net/dsa/dsa_priv.h                     |  4 +-
 net/dsa/port.c                         | 35 ++++++++--------
 net/dsa/slave.c                        | 14 ++++---
 net/dsa/switch.c                       |  6 +--
 net/dsa/tag_8021q.c                    |  2 +-
 net/dsa/tag_dsa.c                      |  5 ++-
 net/dsa/tag_ocelot.c                   |  2 +-
 net/dsa/tag_sja1105.c                  | 11 +++--
 19 files changed, 123 insertions(+), 87 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index af4761968733..d5e78f51f42d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1887,7 +1887,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
 	b53_for_each_port(dev, i) {
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
 			continue;
 
 		/* Add this local port to the remote port VLAN control
@@ -1923,7 +1923,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 
 	b53_for_each_port(dev, i) {
 		/* Don't touch the remaining ports */
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
 			continue;
 
 		b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(i), &reg);
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 89f920289ae2..1c2bdcde6979 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1108,7 +1108,7 @@ static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
 	struct lan9303 *chip = ds->priv;
 
 	dev_dbg(chip->dev, "%s(port %d)\n", __func__, port);
-	if (dsa_to_port(ds, 1)->bridge_dev == dsa_to_port(ds, 2)->bridge_dev) {
+	if (dsa_port_bridge_same(dsa_to_port(ds, 1), dsa_to_port(ds, 2))) {
 		lan9303_bridge_ports(chip);
 		chip->is_bridged = true;  /* unleash stp_state_set() */
 	}
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 583af774e1bd..6317d0ae42d0 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -759,7 +759,7 @@ static int gswip_port_vlan_filtering(struct dsa_switch *ds, int port,
 				     bool vlan_filtering,
 				     struct netlink_ext_ack *extack)
 {
-	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
+	struct net_device *bridge = dsa_port_bridge_dev_get(dsa_to_port(ds, port));
 	struct gswip_priv *priv = ds->priv;
 
 	/* Do not allow changing the VLAN filtering options while in bridge */
@@ -1183,8 +1183,8 @@ static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
 				   const struct switchdev_obj_port_vlan *vlan,
 				   struct netlink_ext_ack *extack)
 {
+	struct net_device *bridge = dsa_port_bridge_dev_get(dsa_to_port(ds, port));
 	struct gswip_priv *priv = ds->priv;
-	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	unsigned int max_ports = priv->hw_info->max_ports;
 	int pos = max_ports;
 	int i, idx = -1;
@@ -1229,8 +1229,8 @@ static int gswip_port_vlan_add(struct dsa_switch *ds, int port,
 			       const struct switchdev_obj_port_vlan *vlan,
 			       struct netlink_ext_ack *extack)
 {
+	struct net_device *bridge = dsa_port_bridge_dev_get(dsa_to_port(ds, port));
 	struct gswip_priv *priv = ds->priv;
-	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	int err;
@@ -1254,8 +1254,8 @@ static int gswip_port_vlan_add(struct dsa_switch *ds, int port,
 static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
 			       const struct switchdev_obj_port_vlan *vlan)
 {
+	struct net_device *bridge = dsa_port_bridge_dev_get(dsa_to_port(ds, port));
 	struct gswip_priv *priv = ds->priv;
-	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 
 	/* We have to receive all packets on the CPU port and should not
@@ -1340,8 +1340,8 @@ static void gswip_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 static int gswip_port_fdb(struct dsa_switch *ds, int port,
 			  const unsigned char *addr, u16 vid, bool add)
 {
+	struct net_device *bridge = dsa_port_bridge_dev_get(dsa_to_port(ds, port));
 	struct gswip_priv *priv = ds->priv;
-	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	struct gswip_pce_table_entry mac_bridge = {0,};
 	unsigned int cpu_port = priv->hw_info->cpu_port;
 	int fid = -1;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8a04302018dc..cebcb73cda76 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -43,7 +43,7 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
 			continue;
 		if (port == i)
 			continue;
-		if (!dp->bridge_dev || dp->bridge_dev != other_dp->bridge_dev)
+		if (!dsa_port_bridge_same(dp, other_dp))
 			continue;
 
 		if (other_p->stp_state == BR_STATE_FORWARDING &&
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9890672a206d..79bde263b06f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1195,12 +1195,14 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 	mutex_lock(&priv->reg_mutex);
 
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+		struct dsa_port *other_dp = dsa_to_port(ds, port);
+
 		/* Add this port to the port matrix of the other ports in the
 		 * same bridge. If the port is disabled, port matrix is kept
 		 * and not being setup until the port becomes enabled.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port) {
-			if (dsa_to_port(ds, i)->bridge_dev != bridge)
+		if (dsa_port_is_user(other_dp) && i != port) {
+			if (dsa_port_bridge_dev_get(other_dp) != bridge)
 				continue;
 			if (priv->ports[i].enable)
 				mt7530_set(priv, MT7530_PCR_P(i),
@@ -1236,7 +1238,7 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	/* This is called after .port_bridge_leave when leaving a VLAN-aware
 	 * bridge. Don't set standalone ports to fallback mode.
 	 */
-	if (dsa_to_port(ds, port)->bridge_dev)
+	if (dsa_port_bridge_dev_get(dsa_to_port(ds, port)))
 		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 			   MT7530_PORT_FALLBACK_MODE);
 
@@ -1307,12 +1309,14 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 	mutex_lock(&priv->reg_mutex);
 
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+		struct dsa_port *other_dp = dsa_to_port(ds, i);
+
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port) {
-			if (dsa_to_port(ds, i)->bridge_dev != bridge)
+		if (dsa_port_is_user(other_dp) && i != port) {
+			if (dsa_port_bridge_dev_get(other_dp) != bridge)
 				continue;
 			if (priv->ports[i].enable)
 				mt7530_clear(priv, MT7530_PCR_P(i),
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index a818df35b239..c583ece83b24 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1228,8 +1228,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	struct net_device *br;
-	struct dsa_port *dp;
+	struct dsa_port *dp, *other_dp;
 	bool found = false;
 	u16 pvlan;
 
@@ -1238,11 +1237,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 		list_for_each_entry(dp, &dst->ports, list) {
 			if (dp->ds->index == dev && dp->index == port) {
 				/* dp might be a DSA link or a user port, so it
-				 * might or might not have a bridge_dev
-				 * pointer. Use the "found" variable for both
-				 * cases.
+				 * might or might not have a bridge.
+				 * Use the "found" variable for both cases.
 				 */
-				br = dp->bridge_dev;
 				found = true;
 				break;
 			}
@@ -1250,13 +1247,14 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	/* dev is a virtual bridge */
 	} else {
 		list_for_each_entry(dp, &dst->ports, list) {
-			if (!dp->bridge_num)
+			unsigned int bridge_num = dsa_port_bridge_num_get(dp);
+
+			if (!bridge_num)
 				continue;
 
-			if (dp->bridge_num + dst->last_switch != dev)
+			if (bridge_num + dst->last_switch != dev)
 				continue;
 
-			br = dp->bridge_dev;
 			found = true;
 			break;
 		}
@@ -1275,12 +1273,12 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	/* Frames from user ports can egress any local DSA links and CPU ports,
 	 * as well as any local member of their bridge group.
 	 */
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->ds == ds &&
-		    (dp->type == DSA_PORT_TYPE_CPU ||
-		     dp->type == DSA_PORT_TYPE_DSA ||
-		     (br && dp->bridge_dev == br)))
-			pvlan |= BIT(dp->index);
+	list_for_each_entry(other_dp, &dst->ports, list)
+		if (other_dp->ds == ds &&
+		    (other_dp->type == DSA_PORT_TYPE_CPU ||
+		     other_dp->type == DSA_PORT_TYPE_DSA ||
+		     dsa_port_bridge_same(dp, other_dp)))
+			pvlan |= BIT(other_dp->index);
 
 	return pvlan;
 }
@@ -1647,8 +1645,10 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_vtu_entry vlan;
+	struct net_device *other_br;
 	int i, err;
 
 	/* DSA and CPU ports have to be members of multiple vlans */
@@ -1662,27 +1662,30 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (!vlan.valid)
 		return 0;
 
-	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
-		if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
+	list_for_each_entry(other_dp, &ds->dst->ports, list) {
+		if (other_dp->ds != ds)
 			continue;
 
-		if (!dsa_to_port(ds, i)->slave)
+		if (dsa_port_is_dsa(other_dp) || dsa_port_is_cpu(other_dp))
+			continue;
+
+		if (!other_dp->slave)
 			continue;
 
 		if (vlan.member[i] ==
 		    MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
 			continue;
 
-		if (dsa_to_port(ds, i)->bridge_dev ==
-		    dsa_to_port(ds, port)->bridge_dev)
+		other_br = dsa_port_bridge_dev_get(other_dp);
+
+		if (dsa_port_bridge_same(dp, other_dp))
 			break; /* same bridge, check next VLAN */
 
-		if (!dsa_to_port(ds, i)->bridge_dev)
+		if (!other_br)
 			continue;
 
 		dev_err(ds->dev, "p%d: hw VLAN %d already used by port %d in %s\n",
-			port, vlan.vid, i,
-			netdev_name(dsa_to_port(ds, i)->bridge_dev));
+			port, vlan.vid, i, netdev_name(other_br));
 		return -EOPNOTSUPP;
 	}
 
@@ -1692,13 +1695,14 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 static int mv88e6xxx_port_commit_pvid(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_port *dp = dsa_to_port(chip->ds, port);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct mv88e6xxx_port *p = &chip->ports[port];
 	u16 pvid = MV88E6XXX_VID_STANDALONE;
 	bool drop_untagged = false;
 	int err;
 
-	if (dp->bridge_dev) {
-		if (br_vlan_enabled(dp->bridge_dev)) {
+	if (br) {
+		if (br_vlan_enabled(br)) {
 			pvid = p->bridge_pvid.vid;
 			drop_untagged = !p->bridge_pvid.valid;
 		} else {
@@ -2424,7 +2428,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 	int err;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (dp->bridge_dev == br) {
+		if (dsa_port_bridge_dev_get(dp) == br) {
 			if (dp->ds == ds) {
 				/* This is a local bridge group member,
 				 * remap its Port VLAN Map.
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 96a7fbf8700c..7053a3510d71 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1823,7 +1823,7 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_is_cpu_port(ds, i))
 			continue;
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
 			continue;
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
@@ -1855,7 +1855,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_is_cpu_port(ds, i))
 			continue;
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
 			continue;
 		/* Remove this port to the portvlan mask of the other ports
 		 * in the bridge
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 03deacd83e61..b6f277a04989 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1198,7 +1198,7 @@ rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 		if (i == port)
 			continue;
 		/* Not on this bridge */
-		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
 			continue;
 		/* Join this port to each other port on the bridge */
 		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
@@ -1230,7 +1230,7 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 		if (i == port)
 			continue;
 		/* Not on this bridge */
-		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
 			continue;
 		/* Remove this port from any other port on the bridge */
 		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 355b56cf94d8..5e03eda4c16f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -118,13 +118,14 @@ static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
 static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_vlan_lookup_entry *vlan;
 	bool drop_untagged = false;
 	int match, rc;
 	u16 pvid;
 
-	if (dp->bridge_dev && br_vlan_enabled(dp->bridge_dev))
+	if (br && br_vlan_enabled(br))
 		pvid = priv->bridge_pvid[port];
 	else
 		pvid = priv->tag_8021q_pvid[port];
@@ -2004,7 +2005,7 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 		 */
 		if (i == port)
 			continue;
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
 			continue;
 		sja1105_port_allow_traffic(l2_fwd, i, port, member);
 		sja1105_port_allow_traffic(l2_fwd, port, i, member);
@@ -2587,8 +2588,9 @@ static int sja1105_prechangeupper(struct dsa_switch *ds, int port,
 
 	if (netif_is_bridge_master(upper)) {
 		list_for_each_entry(dp, &dst->ports, list) {
-			if (dp->bridge_dev && dp->bridge_dev != upper &&
-			    br_vlan_enabled(dp->bridge_dev)) {
+			struct net_device *br = dsa_port_bridge_dev_get(dp);
+
+			if (br && br != upper && br_vlan_enabled(br)) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "Only one VLAN-aware bridge is supported");
 				return -EBUSY;
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 910fcb3b252b..7c2b6c32242d 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -513,14 +513,14 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 
 		cpu_mask |= BIT(i);
 
-		if (dsa_to_port(ds, i)->bridge_dev == bridge)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) == bridge)
 			continue;
 
 		mask |= BIT(i);
 	}
 
 	for (i = 0; i < ds->num_ports; i++) {
-		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
 			continue;
 
 		/* 1 = Disable forwarding to the port */
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 00fbd87ae4ff..18bce0383267 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -599,6 +599,27 @@ struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 	return dp->slave;
 }
 
+static inline struct net_device *
+dsa_port_bridge_dev_get(const struct dsa_port *dp)
+{
+	return dp->bridge_dev;
+}
+
+static inline unsigned int dsa_port_bridge_num_get(struct dsa_port *dp)
+{
+	return dp->bridge_num;
+}
+
+static inline bool dsa_port_bridge_same(const struct dsa_port *a,
+					const struct dsa_port *b)
+{
+	struct net_device *br_a = dsa_port_bridge_dev_get(a);
+	struct net_device *br_b = dsa_port_bridge_dev_get(b);
+
+	/* Standalone ports are not in the same bridge with one another */
+	return (!br_a || !br_b) ? false : (br_a == br_b);
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 70c4a5b36a8b..46a0adfb03cd 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -278,7 +278,7 @@ static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
 	/* DSA ports connected to a bridge, and event was emitted
 	 * for the bridge.
 	 */
-	return dp->bridge_dev == bridge_dev;
+	return dsa_port_bridge_dev_get(dp) == bridge_dev;
 }
 
 /* Returns true if any port of this tree offloads the given net_device */
@@ -345,7 +345,7 @@ dsa_slave_to_master(const struct net_device *dev)
 static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 {
 	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-	struct net_device *br = dp->bridge_dev;
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct net_device *dev = skb->dev;
 	struct net_device *upper_dev;
 	u16 vid, pvid, proto;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 199a56faf460..f6ea41cbcdd5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -221,7 +221,7 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
-	struct net_device *br = dp->bridge_dev;
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	int err;
 
 	err = dsa_port_inherit_brport_flags(dp, extack);
@@ -372,7 +372,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 		goto out_rollback;
 
 	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br,
-							dp->bridge_num);
+							dsa_port_bridge_num_get(dp));
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
@@ -415,13 +415,13 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
+	unsigned int bridge_num = dsa_port_bridge_num_get(dp);
 	struct dsa_notifier_bridge_info info = {
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.br = br,
 	};
-	int bridge_num = dp->bridge_num;
 	int err;
 
 	/* Here the port is already unbridged. Reflect the current configuration
@@ -507,12 +507,15 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 
 void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
 {
-	if (dp->bridge_dev)
-		dsa_port_pre_bridge_leave(dp, dp->bridge_dev);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
+
+	if (br)
+		dsa_port_pre_bridge_leave(dp, br);
 }
 
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 {
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
@@ -526,8 +529,8 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 	/* Port might have been part of a LAG that in turn was
 	 * attached to a bridge.
 	 */
-	if (dp->bridge_dev)
-		dsa_port_bridge_leave(dp, dp->bridge_dev);
+	if (br)
+		dsa_port_bridge_leave(dp, br);
 
 	dp->lag_tx_enabled = false;
 	dp->lag_dev = NULL;
@@ -556,8 +559,8 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * as long as we have 8021q uppers.
 	 */
 	if (vlan_filtering && dsa_port_is_user(dp)) {
+		struct net_device *br = dsa_port_bridge_dev_get(dp);
 		struct net_device *upper_dev, *slave = dp->slave;
-		struct net_device *br = dp->bridge_dev;
 		struct list_head *iter;
 
 		netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
@@ -591,17 +594,15 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * different setting than what is being requested.
 	 */
 	dsa_switch_for_each_port(other_dp, ds) {
-		struct net_device *other_bridge;
+		struct net_device *other_br = dsa_port_bridge_dev_get(other_dp);
 
-		other_bridge = other_dp->bridge_dev;
-		if (!other_bridge)
-			continue;
 		/* If it's the same bridge, it also has same
 		 * vlan_filtering setting => no need to check
 		 */
-		if (other_bridge == dp->bridge_dev)
+		if (!other_br || other_br == dsa_port_bridge_dev_get(dp))
 			continue;
-		if (br_vlan_enabled(other_bridge) != vlan_filtering) {
+
+		if (br_vlan_enabled(other_br) != vlan_filtering) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "VLAN filtering is a global setting");
 			return false;
@@ -685,13 +686,13 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
  */
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp)
 {
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_switch *ds = dp->ds;
 
-	if (!dp->bridge_dev)
+	if (!br)
 		return false;
 
-	return (!ds->configure_vlan_while_not_filtering &&
-		!br_vlan_enabled(dp->bridge_dev));
+	return !ds->configure_vlan_while_not_filtering && !br_vlan_enabled(br);
 }
 
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 33b54eadc641..283029ba70b3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -363,7 +363,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
 	 * the same VID.
 	 */
-	if (br_vlan_enabled(dp->bridge_dev)) {
+	if (br_vlan_enabled(dsa_port_bridge_dev_get(dp))) {
 		rcu_read_lock();
 		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
 		rcu_read_unlock();
@@ -1580,7 +1580,8 @@ static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 			if (other_dp->type != DSA_PORT_TYPE_USER)
 				continue;
 
-			if (other_dp->bridge_dev != dp->bridge_dev)
+			if (dsa_port_bridge_dev_get(other_dp) !=
+			    dsa_port_bridge_dev_get(dp))
 				continue;
 
 			if (!other_dp->ds->mtu_enforcement_ingress)
@@ -2220,7 +2221,7 @@ dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
 	struct netlink_ext_ack *ext_ack;
-	struct net_device *slave;
+	struct net_device *slave, *br;
 	struct dsa_port *dp;
 
 	ext_ack = netdev_notifier_info_to_extack(&info->info);
@@ -2233,11 +2234,12 @@ dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 		return NOTIFY_DONE;
 
 	dp = dsa_slave_to_port(slave);
-	if (!dp->bridge_dev)
+	br = dsa_port_bridge_dev_get(dp);
+	if (!br)
 		return NOTIFY_DONE;
 
 	/* Deny enslaving a VLAN device into a VLAN-aware bridge */
-	if (br_vlan_enabled(dp->bridge_dev) &&
+	if (br_vlan_enabled(br) &&
 	    netif_is_bridge_master(info->upper_dev) && info->linking) {
 		NL_SET_ERR_MSG_MOD(ext_ack,
 				   "Cannot enslave VLAN device into VLAN aware bridge");
@@ -2252,7 +2254,7 @@ dsa_slave_check_8021q_upper(struct net_device *dev,
 			    struct netdev_notifier_changeupper_info *info)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct net_device *br = dp->bridge_dev;
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct bridge_vlan_info br_info;
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index bb155a16d454..7993192fe769 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -151,11 +151,9 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 */
 	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
 		dsa_switch_for_each_port(dp, ds) {
-			struct net_device *bridge_dev;
+			struct net_device *br = dsa_port_bridge_dev_get(dp);
 
-			bridge_dev = dp->bridge_dev;
-
-			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
+			if (br && br_vlan_enabled(br)) {
 				change_vlan_filtering = false;
 				break;
 			}
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index df59f16436a5..e9d5e566973c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -337,7 +337,7 @@ dsa_port_tag_8021q_bridge_match(struct dsa_port *dp,
 		return false;
 
 	if (dsa_port_is_user(dp))
-		return dp->bridge_dev == info->br;
+		return dsa_port_bridge_dev_get(dp) == info->br;
 
 	return false;
 }
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index a7d70ae7cc97..8abf39dcac64 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -132,6 +132,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 	u8 *dsa_header;
 
 	if (skb->offload_fwd_mark) {
+		unsigned int bridge_num = dsa_port_bridge_num_get(dp);
 		struct dsa_switch_tree *dst = dp->ds->dst;
 
 		cmd = DSA_CMD_FORWARD;
@@ -140,7 +141,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 * packets on behalf of a virtual switch device with an index
 		 * past the physical switches.
 		 */
-		tag_dev = dst->last_switch + dp->bridge_num;
+		tag_dev = dst->last_switch + bridge_num;
 		tag_port = 0;
 	} else {
 		cmd = DSA_CMD_FROM_CPU;
@@ -165,7 +166,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		struct net_device *br = dp->bridge_dev;
+		struct net_device *br = dsa_port_bridge_dev_get(dp);
 		u16 vid;
 
 		vid = br ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index de1c849a0a70..4ba460c5a880 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -12,7 +12,7 @@
 static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 				      u64 *vlan_tci, u64 *tag_type)
 {
-	struct net_device *br = READ_ONCE(dp->bridge_dev);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct vlan_ethhdr *hdr;
 	u16 proto, tci;
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 262c8833a910..6c293c2a3008 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -159,14 +159,16 @@ static u16 sja1105_xmit_tpid(struct dsa_port *dp)
 	 * need to find it.
 	 */
 	dsa_switch_for_each_port(other_dp, ds) {
-		if (!other_dp->bridge_dev)
+		struct net_device *br = dsa_port_bridge_dev_get(other_dp);
+
+		if (!br)
 			continue;
 
 		/* Error is returned only if CONFIG_BRIDGE_VLAN_FILTERING,
 		 * which seems pointless to handle, as our port cannot become
 		 * VLAN-aware in that case.
 		 */
-		br_vlan_get_proto(other_dp->bridge_dev, &proto);
+		br_vlan_get_proto(br, &proto);
 
 		return proto;
 	}
@@ -180,7 +182,8 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 					      struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	struct net_device *br = dp->bridge_dev;
+	unsigned int bridge_num = dsa_port_bridge_num_get(dp);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	u16 tx_vid;
 
 	/* If the port is under a VLAN-aware bridge, just slide the
@@ -196,7 +199,7 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 	 * TX VLAN that targets the bridge's entire broadcast domain,
 	 * instead of just the specific port.
 	 */
-	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(dp->bridge_num);
+	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp), tx_vid);
 }
-- 
2.25.1

