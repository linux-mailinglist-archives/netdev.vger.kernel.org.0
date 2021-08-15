Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5B3EC6AA
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 03:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbhHOBsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 21:48:36 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:33792
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhHOBsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 21:48:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTsU/skZkU3WfrxP16dn+VzFGqCxllbd9Dbw9/1fCltKEnh5XxhNxHSBLojfkq2kSL028Vr+ufsCLnyn7/Ri+NyWGimczEBM9MsMAoUzGSTnsLoJOJ7vTGtbMDdTUa7e4GQ0KA8/gVTGgwNUUMb3Ao35Gy3MHFPBc88Xoy1tPb5T4GXbKbrEVtiN0theZwWK8nkOXhH8IIClUkMmZRjJ8z2uzm7U7s3JjAsfCZMVAAoYthxnYIXMVk0FR+MVjs8M+/Nd5Z5Qa3fbF5VM9ub1VdLvtgAmXXiWe/FIEqr+I1MTkmoUWJNVV7F5fVt3L4qXDbUyp1/61fTPPaRND87+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7BC5i9IeX1z0HX5a0XZH2/G1BVwAyRlwDkBEdQcuuY=;
 b=ky/z0wtQVhzm4ktoHBndCFGrR9/ipIY+dnztGQqujnglQT08B5v0iivRdbneVRzRJ+G0MI3b9RfUudjHCyK7OVl/tPORP3E86cB77VJJxN4Fz5tQUJ3VIxHy+lVTE8x/BNEPOqaYB1F99nDCEA86OpqI1eXcM2cetFrcdtISW1KzYQ5BHF5JYu/20gw296BTve9eyI9JkOUSQAH//RxQCaCA4BkbTIsK+ckEzIVaFv+HiRqVLMk7bMA+74k1O9cEXafE4o5KmuWJdxicsur7z6jKEHaou6ZrUCp6VFMbr7Rf+tss1p9xVi4eeklMHGv9cefYnNids/CGTsom3OFyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7BC5i9IeX1z0HX5a0XZH2/G1BVwAyRlwDkBEdQcuuY=;
 b=BWPBiDeRaqR7ynxfqUKyUUj8t5oC/lF6f3onjxNtxTLRpHxsgjdjmNgOfytyWZ5qlO5CBPXlZ9yu3NaYQaEXDvdpclybSgKtawqn6hLaEmX8MPkrEXl9t5tZeefor6aS9/Z3Zr2EZXUNyMReLIUUTR5AKy1XvNfuHnLBqtfOGgE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Sun, 15 Aug
 2021 01:48:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 01:48:01 +0000
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
Subject: [PATCH v2 net-next 1/2] net: dsa: felix: stop calling ocelot_port_{enable,disable}
Date:   Sun, 15 Aug 2021 04:47:47 +0300
Message-Id: <20210815014748.1262458-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210815014748.1262458-1-vladimir.oltean@nxp.com>
References: <20210815014748.1262458-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0087.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR0P264CA0087.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Sun, 15 Aug 2021 01:48:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ab76f12-f6e4-4fd4-2e08-08d95f8eb732
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3069091AFF9E97A8D53F282FE0FC9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ja+uSSZ+nVVjOm6CfI3rN1CXK3tWfWFMkW8SKL/idlNmTQ4mtV2yt/kQCJpU2hK/OwW7AfbwY7vVVLKBCYf/GBtYWiN6CprEVix19GIAwYOsikeTCKNQ4/8cguSjIXFql7myjfgfeEzJBRiElvyR6OoFxAaI4jXEAhxbDqTsG1AQKYrnavAxkc5KX2lhghGCwgRZfFbn0g+OAUBDTwY/rEf+TS/E7Vf9dyhIRVl85h1BALcOFSvW1dYKOiCFlPoQN9j8lMESDsfRohZjtAG+yQ+R1cuXD6EjRDVYPa8qSUfuQ6hkcr636XNlLbGzRYmRkEGme6l44oidJU9x0mrafVTsrM2oMY+MW955+s7Miy6v0vesuME2Sg759jBFKzwQq1fRty6hpSnAmBrlQKA4zlHma+ytIXWePpvLSuGqFp2e32DRbbXZujRGSqEKy8lznumFFD30UP4QmVxSSahjBbY4AL2kHw82TGxbkhpo7ceQhiipBL2PXbg7R9UVJt6s26Es/H3i73BECZUNyAtk5fACBXuX1sHs5POd4IkjC8egLEhf66ejtWEe1CvLIKOfWetXwsq0iBPPv4basc1Ien3ujv8CgfiEU3hf1JVXqWjvo82opwHTG5s5OH3IL8JFXraUEvsxDzASaxg8b5Xnw2Xfk2zry9RWe2xEhJB3wyT8W0CmOeZNGCF6QVC3FCLncUw1ex+ICiuAd3waTl+cYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(396003)(346002)(376002)(186003)(86362001)(6666004)(1076003)(26005)(66556008)(38100700002)(38350700002)(66476007)(8936002)(8676002)(83380400001)(66946007)(956004)(2616005)(110136005)(52116002)(44832011)(4326008)(478600001)(6512007)(5660300002)(2906002)(36756003)(6486002)(6506007)(54906003)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DjYbwJJZg+8cr32RDAJ5OWNYNXCJuyziwwE65IB7l9KrU/pEdDYk6O647ag?=
 =?us-ascii?Q?ziVyIK7PCZpJYSPle2K4NLHYLJS4bnyLJnKqhT/+vNxJflR4qTn1rMBKWFq2?=
 =?us-ascii?Q?nTUAH10cKzcW1kHcXzvujJdSZrEKonFIodX85nf0btrPRGYjA8XQ16W8FTxZ?=
 =?us-ascii?Q?U5ZS1jBulZx4YQae3SnYNMqVD5SNI3wkIN8iwYCh3QKqRhBKDU8m8BgFMHu1?=
 =?us-ascii?Q?LfPBlh6T50Uevi0wP9WFSjhJpOkNL9nzNdb/M1xkJ9ziZTJ51e0SjKlpjSz0?=
 =?us-ascii?Q?6v/VYXJdvORQSdpjJe0C/8fg8RQZx/6hXeHGMoknmAmMaPCf0mUTRCEzOkK9?=
 =?us-ascii?Q?twt+mIuVJPueQ88h9xFeT41oTuEmq2mcXl12jv5ZNMef1RttqApukfRw2+yX?=
 =?us-ascii?Q?tQt9FwnvT1O2sLE/qjVofNzcjiopuFfYPP/Hxroic0N7R7Aed5b7s3wdjJDg?=
 =?us-ascii?Q?rBMPt/raDPo4unPqwGQENBZALkrwzK24fkAaGffIZbqOSfXwLEdIwQ5CfJ0n?=
 =?us-ascii?Q?rtMH0uOqt++7iTkW3RMGXHHROfbbHPm7wxsMTYV8uOqSZNEX0r6Co7Ixmhde?=
 =?us-ascii?Q?zI/qp+JQnzlJRGUQQ61FeVV1PNDU+7/zMDN3eIsojus7IoBQna4ad/A1EgwL?=
 =?us-ascii?Q?6l3wYMU7FYeAdxtepO1E+z65uKs/z46XMgDf+QMPpM+pyclJrrPdIoEsXE3A?=
 =?us-ascii?Q?rCPdH0P9R8iqijlUS0QbTa++6RBHQ1YY27qVpEUUyKh2/jjQ2Z76R4kTktcl?=
 =?us-ascii?Q?VdnGWre0tdnCbuQ1bvzEPSTc5a4k5P/v9I4oLgzQs/E1uxVCbw3KQRujNMeU?=
 =?us-ascii?Q?AlX5ftInRXdC+png9HDaRC7WrVNJMksJ7fzoNcZwQfDZkFtydFATaa+HW+Kc?=
 =?us-ascii?Q?G0mcnbYmfpkiSbiu+XxZqYRFJuLS2wI8DXttFjpVKv96jZtqB+iuOksteXKv?=
 =?us-ascii?Q?oXbUXqKFVEc9T4RagkCL9b/YYOko+g25Hmw1MU1SfZ3nvqbPa/flrfy8Sxw8?=
 =?us-ascii?Q?M/y6y3II3stqNnnOePt9PqeggwChlumHSfw2tk4nr+fm200yExiEbha69Xj4?=
 =?us-ascii?Q?ttSudFijlLMXYkXTxdcK1qhLZQfkByNviQkyrDRlpxfEffEnkFXzDO2YLWeQ?=
 =?us-ascii?Q?Z/VhLeiXerk+ECfS1jsd+5hmD7Rft+E7cjZAyFWQThF0AFWChfxrFhPspb8A?=
 =?us-ascii?Q?R0i18FMmMWMIlBmRyukVNjkbs9Npi0JMnTp+WBsC8Djb7ny0TWSQPVzjFPsz?=
 =?us-ascii?Q?ZzIZ98UARh9aU4LHGmSVhSBLeBt6e2AwfGdN90jXf25HDzgX1SeAJz38P1Y/?=
 =?us-ascii?Q?RuUb1004kYOCs0Qoh+Lb5DoF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab76f12-f6e4-4fd4-2e08-08d95f8eb732
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 01:48:01.4868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sONs3JNVdSIBcAxe5taqgIMj+NpLS369lvZAEivuAd8ampKUSBVJiOxCHbqLdpPvjTFECOtNA/X1+VrTllLYhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
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
v1->v2: delete in this patch, and not the next, the stray unused
        variables "ocelot" and "port" from ocelot_port_open after
        no longer calling ocelot_port_enable

 drivers/net/dsa/ocelot/felix.c         | 19 -------------------
 drivers/net/ethernet/mscc/ocelot.c     | 22 +++++++++-------------
 drivers/net/ethernet/mscc/ocelot_net.c |  4 ----
 include/soc/mscc/ocelot.h              |  2 --
 4 files changed, 9 insertions(+), 38 deletions(-)

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
index de900ea70fd4..6a196cd6a61a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -449,8 +449,6 @@ static int ocelot_port_open(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
 	int err;
 
 	if (priv->serdes) {
@@ -474,8 +472,6 @@ static int ocelot_port_open(struct net_device *dev)
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

