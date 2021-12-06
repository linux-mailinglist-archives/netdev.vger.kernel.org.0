Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7C46A206
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhLFRIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:18 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:53123
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348567AbhLFRB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aR6uu6EjGTIa21CPj2++rFlasYOkh2G/GmHwCJjOOgvA8OapkbRzdqufR5K9YW4/W+fSj2/IX29e3svCudAHvygqvRhIQGn8Kf1j5lrSgX7rQ/uK3gXdaezipypxofrMsqpc+gmsoWD/8Zb/P3hIDqYD1SW2o8YXCRNS25k8JfuGB14vIkeagDI6kUoTZ9x3TEb6S/2+sA2LHQ/tT6HgloFlgWdv8vgSPvibi6+B1avQ/hXsCoG5iHk44twvTfdeG0dt2KWKHBWLzSlS5U82o84zKV2sxZaLElwwF61YOQF3tJfW+uHC/P48AOueeBCrtfJ5rIkkwBNuxQWP/9ij9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3E/PoHw3XrPj2iwtpRf17Zw2UvIi5vOe9tDG4ypudU=;
 b=bjmNKnZTx10bJCtrGdfIvUmYeZ7DGDYT3KmVeFXLKelNJqZIJUNEE+kMpGBJejk9+onQRLoJr7dELqbVl9eFLZE7E+zjGmxYx99Aq7vJRJAWQxdY8Hd36h4UlTR0/VRPybNP0xrYeQ+P0f2r9FBO4h+TBHRKbduf9wbNl4IJ3y4ZtLwNQkYVGNE16a1j7bL32Uv4Q9Cy1l0gueYjvfoAO2bOLcxlmo5Ehv0j2kQAfWd4N7hNnoN/4CD4hdRxXzWHKbifzsqq7WQXoP3b7fy3mX5xetjdq8+YfKgtLHQecR3WgEM0aItvRaRGWjdEyUQCXmoo0/ZJGUYYYADgqcuGjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3E/PoHw3XrPj2iwtpRf17Zw2UvIi5vOe9tDG4ypudU=;
 b=oMBBpHGQ3OvjcAaVaBGvYgx/MJngWGUtMNMyPoe21Otvr2QaJASS6E3oEyy1CKL4OpR6Ysl4x2zAJGpfg1Cxcdd8aBiXnK7aUNkLOsRPIUT2wuTwdWfrr9mdGmVjguStj5jcSyfLuT38NnLyvBMH683AhtP/fBd4ZN9l4fGbrbk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:27 +0000
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
Subject: [PATCH v3 net-next 07/12] net: dsa: hide dp->bridge_dev and dp->bridge_num in drivers behind helpers
Date:   Mon,  6 Dec 2021 18:57:53 +0200
Message-Id: <20211206165758.1553882-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f744b92c-91f2-4692-422d-08d9b8d99f53
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB49126008954E856C074B20EBE06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6xed70crC+zxIPxOI9H3IuBZku4mORAf2/bpnlwq7zthu6ByKqFBmByRIJLZG5xb/6bEsmZc67b1gk38EaATGNaXu1yWZPLp1E9OQH8txd1wdhA10zJz7joOuU8h9lkOFCGbEEZeWiPVT22pfuqJdVrAfixHQOwdAqVyoW/9MGIX0tt/ku840TC9hQ+akCiI3YW8MjbleUiIs40jNC7DslTMpV8iSjibkexEaXMCV6r1WObOvfloosd2XlnH1A97Ng5PHPA0mvbBGqCfdKNx01otK55ZH0NHD3cKcUdg4KifJDL4HTFas/8cUJuGOJ5lwIWdS+1HNITs6rKNLHnT5c3wDm4oheZj4/7ZWaukw2Q2C4w7EXFStEigyvhlptwbCrZXGHL1Dzkqe6EjMICDbpeohfe7dbnJDlQI5maXzOVq1U30gcFlqr9qKyNc3okiVcnaTOHN62ETmsIlyKogbxUp7sJ57dY7JkaGUDVGdR9RHEjA2JzJQcq5fdrP1gi0rDCe2i0lflIqbJiIne/RowSUP2BJLAvRZWmrt7gPc29ZqooYNk8gq19fGkSdYWqaKn0+R952O1q6YTUaQKfxL1BVFyQfksoTUcqb041IrFj5zlzXDnGBOaGkjMugIJB8nWaKUy6YlRQHkHijQsxAf6gUfuibgiK/Ap5q318WTtMEQe0OiSnz/hjbBumTYfPQ0hbx1v5hRYObpIh5hn6Wxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(30864003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HEYG728q04JIl0yaA+K2HzxeRHfIaMTxJrli8hc9tyf7/DhxTD41slM9VQzf?=
 =?us-ascii?Q?aB0wT3u9YJS+t4Zl3m2gepbVF7L5nEOI4VHqaWexC4NkJBtzgoJbtdPpMbz8?=
 =?us-ascii?Q?4XYfmuba+mIqtyfQIk2IaWk1qdD1b+U1w4X71+qUjJ6Nqzh8anqeLNyxWMHg?=
 =?us-ascii?Q?jH0raJqCqlQOudl02yvR7N9GlzaN7G1Vd/SCfYrYtJGfqW50My9r/dzg3TK7?=
 =?us-ascii?Q?27b12y1bDmvftUBzaAscPk8CheDCemIcebcsO75yFPRecKtHoVylQzNobhQ7?=
 =?us-ascii?Q?FC2ZhxJunyzFse2/tLHcGdrtLFjXYfD87jOS0tiZ4mLp24YOwc4zIkjgqfxS?=
 =?us-ascii?Q?pR6WXaShj2o8n7Mqt2fLlnawFLhSDOAJ8to/kmWeX4fhhNEUNSazwHxJrkH2?=
 =?us-ascii?Q?0lu9vc2GCjtRClDm+/6YaRL5KOSkOSFLOLBQKmV/wQNwef/LMvwLi0GHr6Mv?=
 =?us-ascii?Q?gqbfabvWFTPbmnVvIE/sJL0kDokT7evDN2ep4jcZpknBLK6gYtx+0EirMKF/?=
 =?us-ascii?Q?f1rUHT6j0dJC2jZEH49r/7UFAaiD3hDDBL4UQ3TGSYI8sJzDRMeIZ9KQzqJT?=
 =?us-ascii?Q?0132IXj/ldz6inC0P2zTqazrohW/n50a6I8CQKgSeFSXAQlePB/Hz82SWFcM?=
 =?us-ascii?Q?dfRAsG8zA244ZDTKnspAGx927DuaSQu4byU5wXsgRMybP5ProxJwuftSaoO4?=
 =?us-ascii?Q?qSYZfftcI2ZkT3Kb+fx6v0bc1rw8nJSYHbj/PyisrADTD6UZjYEY0VIRWuTj?=
 =?us-ascii?Q?6EpawjrYloJ2rs/Ak92g1Bt9g6ZzhB2nmE9vLY5k8lM6YDADUfzPU608iyBH?=
 =?us-ascii?Q?lVCWWoYhpOPNi6IPWiqzjnyYSEU4mRsI5gYoFe5ZIf+Itlf9MKvdAv1l3CcC?=
 =?us-ascii?Q?jKzRCTnJy0Z0u5ArXCVYYGeO8xmlbjDZexEwhTM6eTKe9PhJ4iNf8QKZmyAs?=
 =?us-ascii?Q?NsPE/s7GkQfwVr1qOFlKtoSfyIHHyHVBBVMZLF77f9BD9Qb26+D78hi7yDhA?=
 =?us-ascii?Q?ys1vPY9shSoQobdhrONJnzTfZnA0cJw7yrrlPopZGh9suypCzPcXdGv15ok/?=
 =?us-ascii?Q?8E7LHkxsV8c1h97rHrc+cNJGRUt7B1wEqvc7d+uZsM68gSFEbLPToBaT/Qwo?=
 =?us-ascii?Q?f879w7No0xf3kfWu5VJf+JewjUkRqgydm4XlgbyDNTBkent9YhnbMKimKlOh?=
 =?us-ascii?Q?KKd3ya9AOIkTYflJw7b8ciNfiH/4UVfJx8j8vSOv2Phi/VyadQ8xvDWXcZ1V?=
 =?us-ascii?Q?Y8q7igUEDuBY5tKyuHuGWEarS6qPL+9JzIQZhaAMUBJmJyhOXPGMCKaUQxWU?=
 =?us-ascii?Q?2XwupyisL+VdtWwf+7EwlO8Xby6pV1SR+fzjevu1dU9giQ3dCeXYQb+C80Pe?=
 =?us-ascii?Q?UOQOY3VztYD5cYqR4B3y/wV+e2Tj4m9IsUuzB43ToHnMwbuer3NyeoLvL65z?=
 =?us-ascii?Q?3qxojrVtJUc7s7wb0C/kcsX1I2BkhYeUJsgri3PQLWFeSZm2yOn1tkxI8Q81?=
 =?us-ascii?Q?qtmBIM2Y7dNLURIczP/Nw3vYhcAm0aveD1R19LSA72tlKeg74GkpqnLHubhO?=
 =?us-ascii?Q?BBJbnWQrbRoFQ57mySU7nHM4U3cg4pehgXgEnTwJ6pG4faSKpnVbP80fUGs/?=
 =?us-ascii?Q?YnzL4wgto/0GU6TUvLEk+9Q=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f744b92c-91f2-4692-422d-08d9b8d99f53
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:27.2114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUv3pPpZVL39vHyYnB6LdoOHnEqzd+5oejcPJ03l7iLZQ+QHTu7AihxSopDynqhVgZ+FD419CmihNbwddk7tgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The location of the bridge device pointer and number is going to change.
It is not going to be kept individually per port, but in a common
structure allocated dynamically and which will have lockdep validation.

Use the helpers to access these elements so that we have a migration
path to the new organization.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- removed as many non-trivial changes as possible (split into other
  changes)
v1->v2:
- convert ksz_common.c too, after Oleksij's commit b3612ccdf284
  ("net: dsa: microchip: implement multi-bridge support").

 drivers/net/dsa/b53/b53_common.c       |  4 ++--
 drivers/net/dsa/lan9303-core.c         |  2 +-
 drivers/net/dsa/lantiq_gswip.c         | 10 +++++-----
 drivers/net/dsa/microchip/ksz_common.c |  2 +-
 drivers/net/dsa/mt7530.c               |  6 +++---
 drivers/net/dsa/mv88e6xxx/chip.c       | 25 +++++++++++++++----------
 drivers/net/dsa/qca8k.c                |  4 ++--
 drivers/net/dsa/rtl8366rb.c            |  4 ++--
 drivers/net/dsa/sja1105/sja1105_main.c | 10 ++++++----
 drivers/net/dsa/xrs700x/xrs700x.c      |  4 ++--
 10 files changed, 39 insertions(+), 32 deletions(-)

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
index f7238f09d395..73c9f79f9e9f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1204,7 +1204,7 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 		 * same bridge. If the port is disabled, port matrix is kept
 		 * and not being setup until the port becomes enabled.
 		 */
-		if (other_dp->bridge_dev != bridge)
+		if (dsa_port_bridge_dev_get(other_dp) != bridge)
 			continue;
 
 		if (priv->ports[other_port].enable)
@@ -1240,7 +1240,7 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	/* This is called after .port_bridge_leave when leaving a VLAN-aware
 	 * bridge. Don't set standalone ports to fallback mode.
 	 */
-	if (dsa_to_port(ds, port)->bridge_dev)
+	if (dsa_port_bridge_dev_get(dsa_to_port(ds, port)))
 		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 			   MT7530_PORT_FALLBACK_MODE);
 
@@ -1320,7 +1320,7 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
 		 */
-		if (other_dp->bridge_dev != bridge)
+		if (dsa_port_bridge_dev_get(other_dp) != bridge)
 			continue;
 
 		if (priv->ports[other_port].enable)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 341b62398d83..5afc7a1c0dbb 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1247,10 +1247,12 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
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
 
 			found = true;
@@ -1274,7 +1276,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	dsa_switch_for_each_port(other_dp, ds)
 		if (other_dp->type == DSA_PORT_TYPE_CPU ||
 		    other_dp->type == DSA_PORT_TYPE_DSA ||
-		    (dp->bridge_dev && dp->bridge_dev == other_dp->bridge_dev))
+		    dsa_port_bridge_same(dp, other_dp))
 			pvlan |= BIT(other_dp->index);
 
 	return pvlan;
@@ -1659,19 +1661,21 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 		return 0;
 
 	dsa_switch_for_each_user_port(other_dp, ds) {
+		struct net_device *other_br;
+
 		if (vlan.member[other_dp->index] ==
 		    MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
 			continue;
 
-		if (dp->bridge_dev == other_dp->bridge_dev)
+		if (dsa_port_bridge_same(dp, other_dp))
 			break; /* same bridge, check next VLAN */
 
-		if (!other_dp->bridge_dev)
+		other_br = dsa_port_bridge_dev_get(other_dp);
+		if (!other_br)
 			continue;
 
 		dev_err(ds->dev, "p%d: hw VLAN %d already used by port %d in %s\n",
-			port, vlan.vid, other_dp->index,
-			netdev_name(other_dp->bridge_dev));
+			port, vlan.vid, other_dp->index, netdev_name(other_br));
 		return -EOPNOTSUPP;
 	}
 
@@ -1681,13 +1685,14 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
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
@@ -2413,7 +2418,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
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
-- 
2.25.1

