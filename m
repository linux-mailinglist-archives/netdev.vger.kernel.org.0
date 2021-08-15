Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEC33EC65D
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 02:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhHOA5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 20:57:24 -0400
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:4858
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhHOA5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 20:57:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cR0/+Fc/WNlYxhetBFJ/9Ld5SL1YHmogCLMHJbihoASzclOw/g/OvUqHqYX8PdZw0Xp9vv6u3y9JrrKPNaXUNnuf44/mk+c+3vuid+e9lt1RlY2tsr2aVtqwodSlLz5ZDRx03lPggAsn3SnqkxYA2uWzU2ci5gg8aFaLAe8PNJ3FrsVTyVZ3qXvtOn8dcJWgNnSlilqYDoDFT30v3hYGcMDMaUqBVVkcNaN2KlRNH/gTJduNJ7u2fZM9W4IVMayTHR/x9WUeNFsXrC43VOvzoiuQESi/9YhYNSRT0XI9pJIdRXdhmVjTpEtXNZGyJKC5s7Q5pRRBVWKfwC6fcSjtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQc+rV3aabcWMDwg8Q2tiAe16Rx6HapvnSefo3iUYco=;
 b=BUZTvACSpsTYQEEgQS3H7XoZxHesXifJEsUhu/QwtucUBCHsughmWP5pLHn7oZr4H9SwgL2qRGhll1Fgbhx7LEg9qFfp85cv6813yTFZXOWZLq74lUXXubFD1zbARG4R1ysdPdUkqahOblhJLuskXJ+8kcI+HYQsj5cGI5kQB/0km/dOK0zlw9FT6xLlGVszPENPc4JVYpKbMGmIymWaHp+6wXGDefBt1R2FdOPdSdxYHdpwzM7fuUvZtexkMspLvP75Xdboe96fUClDxSjmGLlu6mXLRD9LPpKhOFB0RefDMRYJ1TinKqisBY0TtAg7WbZlFxigOCA4nKF5J5Qt6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQc+rV3aabcWMDwg8Q2tiAe16Rx6HapvnSefo3iUYco=;
 b=rIsPqN9any5cIGJ2Pbz2e25EyVOuoseoX0Or8JVtO559jn2j7P2W8jDGpyon+QSXhwYOS5PlxkN6BfY0btHse0DG/Hnu+I7RAtsHneATGJnEQUq/tE5//WjajsMMR5FkEBu3XmY6tdeCrFQRS/FFXLcrAvZBsYl89Wpct8MMLPQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Sun, 15 Aug
 2021 00:56:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 00:56:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/2] net: dsa: felix: stop calling ocelot_port_{enable,disable}
Date:   Sun, 15 Aug 2021 03:56:21 +0300
Message-Id: <20210815005622.1215653-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210815005622.1215653-1-vladimir.oltean@nxp.com>
References: <20210815005622.1215653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0192.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR0P264CA0192.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Sun, 15 Aug 2021 00:56:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c36c672-875e-43ec-ce05-08d95f878f9e
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301AFF4320B255B1AFE8008E0FC9@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FUReLsuMVnFbFUkhyfrzD5HpwbjV28DOTW0AJ9Ia3npfF49iJLxw1oFFo76j1DgiD23ak/6su30MCsVPZow9MEVkA2B1ZCuUBNB4qog+ASJqBcZ5rfCGYrnqIZfxhSWBWBfigwQHVXhQMghGm5LtrwM446BuStuzMxoTt6uD4nTAE3bzYqxjTDDYwVJiIBGH4macQIeELprgg2Aj/hlQdXW01ilDNqogKz8cQ+S92NQfQeioTUjX3xz6U71sLTzNUTmvxTFKBgulYhkHRfSPg2sbM0SxXTHIouf9MzgUf1oojCT3OVbyj8Qh/HXyTKTHMVkf+TmsVx//QIRsSUI61wFhkC0g10SibkysPgKZkpCzJPRXlAJ3haQpqUSrUhfytEKJ2/LrN6gaWzO5AYTgn8Ai7Zuhxuj/Gs/WiF3PnbpKf3di2d7mnED7JYtUYbbQ6GVReBQ4c1N57Z5hUb9ZjbDn1exH2yshkWn26vvCNlDUDt1KWu+3VnTRQ2OE4J4k9eFBI2E8erv14S7LJ6GZnboHhZeZeDX+FOLCfeNQ1Rv1XIwoXkVOL7b5psGxEslDcu0EW5Mh7HFUEs3tsoN4J7QnfB20mbsVp4q6IRbxElqHfL6QnmlM4lNvjJQy2CBZAqdq/43h7VrajISEc93L9kdT4PK476A5AmHPTTI+Y1hgs+0YQbp0ksUi554VY+aTmP0Uw6QMSuTx99d7pWGRCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(508600001)(8936002)(186003)(6512007)(6666004)(1076003)(52116002)(86362001)(5660300002)(36756003)(2906002)(6506007)(38100700002)(38350700002)(66946007)(83380400001)(44832011)(7416002)(66476007)(66556008)(54906003)(6486002)(110136005)(956004)(26005)(8676002)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OILw33uYQj3nBo8YgFKynL0kf/9+XiYoAamSOasyxWfd00wutRpqY6ctxPcg?=
 =?us-ascii?Q?oe+li08IS5+AM+u9ozhQm8Oy01NuPPFnP7rOmbS+jhJZKEYcJU/Ls5ADfDPU?=
 =?us-ascii?Q?30RMg7BzpPk/iK1QwknRtC0i0NWA9r39XFl+CX/X0+j6OYLpE65Lo7U20kjC?=
 =?us-ascii?Q?F0FLV1D+CLdVSd4PXT1pAYYOjX/xZOhaXPlTEjjSdfjXShM3jFyADKlxdUwh?=
 =?us-ascii?Q?pjQ+qW5/ptBcTcMJqxIBNKb2nhOtQ66fdVIEdyxI/HZz1nEmpp2SR5Vb/GCF?=
 =?us-ascii?Q?Q3MtCjiDRuGR6FPfq4eCWmoW5Xf1C4VHM9dO/5rngH4jGz+CgVvIw83Njtvc?=
 =?us-ascii?Q?PH+0VDHZtMEccrqkkrt+yX+JfRtEQOX7nYX4x+LvJ9vOtw5osttFI6e4WBjO?=
 =?us-ascii?Q?Ca80AAmDhKaAJ5yEp/TFnPECdj+11irAOTyRXRNx9UDbVWFkkpUJpxKe48Gz?=
 =?us-ascii?Q?2nLWw6IGFTBpPkAg/C//AE8b+s5hn8Q0hTg4nJ2lqFD1XxiSd2sIlISbL2wY?=
 =?us-ascii?Q?7DZExEb12jdJfvc+Q4zfygy3b6WXIhIPpzkW3bc2j4cqbEfeLgRKex3FWHgc?=
 =?us-ascii?Q?Hi32Nk2dIgGsUdZhH+aG4wYMJJlb+8P/uOu4Vj6xA8qdTFR3YLvC5pTzZFsM?=
 =?us-ascii?Q?26CohSA98ZEduYkv2seWJSUMd9WFze0KAHNzeg2bVAEtetLnq/DGfVnIaUEM?=
 =?us-ascii?Q?hHJdvhugfcej+5ilUUP8hB+GeC26nXc0DknFSnKbf7oEe4kNZe5r5dwR58gZ?=
 =?us-ascii?Q?4N4q57ZXE7jFD/KkRmErhyRIMDyzXR5Zhu8E4brr6P8gKOa6kl0JwDxa8goL?=
 =?us-ascii?Q?n7VHveEPUKZtiUx72Ko8P1sII7zmvpkp0C/1cH2/uxMuEDz/HY2k5Lm66YKX?=
 =?us-ascii?Q?L1WvDs59wSChWdruLZUjEWc0qxp/Cr0CYnjnAlSAYkFY96YXB947WfRbrF7s?=
 =?us-ascii?Q?vAQzjwNKTTafJgnL8DdKKi1Zx1K0In6iI+tTQMx78WNo9As+5juITqpqivmd?=
 =?us-ascii?Q?XXAt+D6RheMfFcMlNku1MhqAzKMKIR0YCslfua4HijNPlBFCMP0ywhLSGmV1?=
 =?us-ascii?Q?UTbKFGu1wlk08RL05/9TzQawZqO/c2B3kZLQn5gWW1gUTcflkK1ycmMO8THq?=
 =?us-ascii?Q?JbrSObwwV7eheDr1m/i4XoaGtx5hRxvXLQljy8WzVyqeS1LrfWkUlKBQJvkq?=
 =?us-ascii?Q?9iWZfUyPQ6iQS/mYjROFmxjdDqcF9VMQstZqWnv8y/52JFcaMu1CQIDBzhdj?=
 =?us-ascii?Q?kgEtHSKFEdCFrWd+PsmoWq50lt67LdngJK0ETJlw9sDooI+u4SzSnas0fncE?=
 =?us-ascii?Q?B0HeZ1ojSE4JSG+1bG8xRNx5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c36c672-875e-43ec-ce05-08d95f878f9e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 00:56:48.6687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vCNiU4lBx5g+dgekWYhz2ggQNNKLCnGh+yUSiRMQ7mCTFNfPh7rowGNYd4UcfTiNqfGAYGVxwuqRQLlwHQpwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_port_enable touches ANA_PORT_PORT_CFG, which has the following
fields:

- LOCKED_PORTMOVE_CPU, LEARNDROP, LEARNCPU, LEARNAUTO, RECV_ENA, all of
  which are written with their hardware default values, also runtime
  invariants. So it makes no sense to write these during every .ndo_open.

- PORTID_VAL: this field has an out-of-reset value of zero for all ports
  and must be initialized by software. Additionally, the
  ocelot_setup_logical_port_ids() code path sets up different logical
  port IDs for the ports in a hardware LAG, and we absolutely don't want
  .ndo_open to interfere there and reset those values.

So in fact the write from ocelot_port_enable can better be moved to
ocelot_init_port, and the .ndo_open hook deleted.

ocelot_port_disable touches DEV_MAC_ENA_CFG and QSYS_SWITCH_PORT_MODE_PORT_ENA,
in an attempt to undo what ocelot_adjust_link did. But since .ndo_stop
does not get called each time the link falls (i.e. this isn't a
substitute for .phylink_mac_link_down), felix already does better at
this by writing those registers already in felix_phylink_mac_link_down.

So keep ocelot_port_disable (for now, until ocelot is converted to
phylink too), and just delete the felix call to it, which is not
necessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 19 -------------------
 drivers/net/ethernet/mscc/ocelot.c     | 22 +++++++++-------------
 drivers/net/ethernet/mscc/ocelot_net.c |  2 --
 include/soc/mscc/ocelot.h              |  2 --
 4 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 583a22d901b3..0050bb5b10aa 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -796,23 +796,6 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 	return ocelot_vlan_del(ocelot, port, vlan->vid);
 }
 
-static int felix_port_enable(struct dsa_switch *ds, int port,
-			     struct phy_device *phy)
-{
-	struct ocelot *ocelot = ds->priv;
-
-	ocelot_port_enable(ocelot, port, phy);
-
-	return 0;
-}
-
-static void felix_port_disable(struct dsa_switch *ds, int port)
-{
-	struct ocelot *ocelot = ds->priv;
-
-	return ocelot_port_disable(ocelot, port);
-}
-
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
@@ -1615,8 +1598,6 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.phylink_mac_config		= felix_phylink_mac_config,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
-	.port_enable			= felix_port_enable,
-	.port_disable			= felix_port_disable,
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
 	.port_fdb_del			= felix_fdb_del,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index adfb9781799e..a948c807349d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -514,19 +514,6 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_adjust_link);
 
-void ocelot_port_enable(struct ocelot *ocelot, int port,
-			struct phy_device *phy)
-{
-	/* Enable receiving frames on the port, and activate auto-learning of
-	 * MAC addresses.
-	 */
-	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_LEARNAUTO |
-			 ANA_PORT_PORT_CFG_RECV_ENA |
-			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
-			 ANA_PORT_PORT_CFG, port);
-}
-EXPORT_SYMBOL(ocelot_port_enable);
-
 void ocelot_port_disable(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -1956,6 +1943,15 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	/* Disable source address learning for standalone mode */
 	ocelot_port_set_learning(ocelot, port, false);
 
+	/* Set the port's initial logical port ID value, enable receiving
+	 * frames on it, and configure the MAC address learning type to
+	 * automatic.
+	 */
+	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_LEARNAUTO |
+			 ANA_PORT_PORT_CFG_RECV_ENA |
+			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
+			 ANA_PORT_PORT_CFG, port);
+
 	/* Enable vcap lookups */
 	ocelot_vcap_enable(ocelot, port);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index de900ea70fd4..97162e63d8e9 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -474,8 +474,6 @@ static int ocelot_port_open(struct net_device *dev)
 	phy_attached_info(priv->phy);
 	phy_start(priv->phy);
 
-	ocelot_port_enable(ocelot, port, priv->phy);
-
 	return 0;
 }
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f5ce4d4fdbf..2c2dcb954f23 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -798,8 +798,6 @@ void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
 /* DSA callbacks */
-void ocelot_port_enable(struct ocelot *ocelot, int port,
-			struct phy_device *phy);
 void ocelot_port_disable(struct ocelot *ocelot, int port);
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

