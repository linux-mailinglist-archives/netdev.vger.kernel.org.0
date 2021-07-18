Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998853CCB28
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhGRVtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:47 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:53472
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233530AbhGRVtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlX3R76h5qQqVHokQDasoGmX0I2sx6n8n7XlexChmdwRk/tJPnJmTdGdEXiSLsnkhxvbD/k1TUC3018gGWJD+jqgqp8OEhg4fpSJoJxz9h9WJvMHiGjGyJ/hc+fRZQr8n2LKPga2rO6VuqbtjJf9NbzQkjHng2/5e7VYJYdOFyGOPkO/jKdcODOog/RSpFOqqUgXQy5XKOUxtOnuuR5gnSiYv5YiLu3n7e7QgJRJcd/BBlX74hwShYLkuk+KKGwtwbRay+WzP5RgH7zLboTj/bS482i8Q7mGWpCfiMc0H03MFvOqsewUsX6lI18fRtAeAF5ShhQQn9vtOoF+/rQafw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7qn/9oiAQNFSlfhnVt5FrXTImK8XLdXzXSvSXrNHKQ=;
 b=C4wQyyXuw+rsiRVrde1BcgQlsgo1017jP/ZEOaSRBKJ0JtzjMzXWpCndiQMWbFEy4z2Y+zTAn3vdPaOfeSRQvkk6aLwp2ic4ttx+H6r5CgciEow+tN52HkN/YvY2RFDkLjjcBdw9PlDUZCPdJk5n034vgJTFmA2/QwDpUYK9gzC5o3oIqbJHkDH3X7PQP60Cifzxu+T9zXngYF/7V/FEFk4qg8EpACGk7l6vRbB624z+49e2ttCRFC99Sl1f6kldlhykUgGm3OTn5v0HFVfrhWiZMpqEnj3wyq0nWjCfijh/DT0sfxpN6VFT4RJT+oY0CdHE83j1wQMyM1pmHGbmtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7qn/9oiAQNFSlfhnVt5FrXTImK8XLdXzXSvSXrNHKQ=;
 b=RULkiwAShoVgG34VVMmlKXzsJdngv8JaI5PNV8NckAZTDbWEeynA+Whw3DMGrgyROE4b7jnQRlS5aB7BRvfH6MixVGd4dzWeVAtG4chXOn81dppQJHJpIpOVO93l+YAB0lRg48tiXQVLzTSESJ8BrJXM0U6Sszx9DFkSR27GIbo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Sun, 18 Jul
 2021 21:46:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v4 net-next 14/15] net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT
Date:   Mon, 19 Jul 2021 00:44:33 +0300
Message-Id: <20210718214434.3938850-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a167777-aaac-4cb2-1413-08d94a357b4e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5502AF5D85B6D5F4CEB84E89E0E09@VI1PR04MB5502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkpkNwsg9o0syviW5lytR9EFHMuSD2UeRXfOh1D/io5L1bdjeR10OeMp6RhUiNdJhNvBrpdKCrOzOpMJYbiSnDXUjsCLmZ1S1GaxF7s0Immbsuvb02AHg/gafTQMuzy9jj87clD8b2xFF+HnFrruUUOXBEK+hwxPHOs7hWSJ1B2OJRfw7vSTiHZtk+qield+1Rzg46iCkRVPlQLV46q77yWny8bmCP4FZU6NchLoII3YZruNdNa8uRTNl52tp1Y0VYmdlElPXp/Jf0aEigc6Av15YTt3kavxBoWZSbepV6Z50WjhFx7N69FtB3vEjQP2VL/T30QF21NBWqqtzfNBgRwnkf6PrzLvUv42lYLzLBFPzqR0pZ8erNJ/Gflor6+5kVMT9k2eEloyd7659Ie1M8d8negMJbLKlwmOUeulyu32bFXdP2sZCYUqob4IWGKGyTu9GbiTQBYopTmBmoT1ctxgDSngaM3GmzR54DZYQ7iVYlmLx0t9ILHWi4erMlRrpzak6eUJcu3XG5dFHnslPTw021V4d4CMBn8T09+M7B+qoiL3+2Et3IzvOW5vw2d9UFuqb/yaFRaFVxoi4k14pydtu72nURuQEOa30mieZenSK/33GdwAPFUoMwokPHRlQQhVNxtsL2F8MU3LxOgrUcorvBYTUITHq5R5/sOC0Tj98rv6vPAECgRASwaOGq8G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(38100700002)(44832011)(52116002)(38350700002)(6486002)(956004)(508600001)(36756003)(2616005)(6512007)(1076003)(66476007)(66556008)(316002)(66946007)(26005)(6506007)(54906003)(186003)(2906002)(86362001)(110136005)(7416002)(4326008)(83380400001)(6666004)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cWI82ZqgeblUGZWCMM6TtcoSVGmnkx1ZWtjL2L+S6TBZ9rTNu4Tfxb8YaSdc?=
 =?us-ascii?Q?QYCz6wppiw+/davw9MfKeek9ooCXnXdbXHhVzeTvLmwSusdAlt2WSTKHQdyC?=
 =?us-ascii?Q?wrtTm0+7ALL0VpNbQ77mhDX/MCWhJK7rvS8xKmRoL56ZUS9jRoXq9msbbUf2?=
 =?us-ascii?Q?YkrU1+vEI4JksCTppOhUYJ4A5V6P4a6HWsy1Qqg9fnoV5NwUr6T2zV1CflmG?=
 =?us-ascii?Q?CBZ3rvJI4ZKW5FUZ/yKJqSITgeRREMydvUMExjcdgEx+PijuX2uUPuWZvBne?=
 =?us-ascii?Q?bbIKrVz0ui77KTntE7tGr1JCa43sK/wFYCpGAmkYTyR4pQH2dUnzIcTFnTz4?=
 =?us-ascii?Q?kVH3CtdsBrecS3YEMd/NcLL010sfkAHui2X3rU5WOrCtu+4uu5YSnA2Yy3rB?=
 =?us-ascii?Q?laJX1itrF2+qfS8Tv/Yybuom9TfP/QdPFCG/T4IPW7cwWiQ5rGkkl89JPqAS?=
 =?us-ascii?Q?mVi9FoqyjTUWtGtLW6XZ8IzNzm4sw7HZx22dZxBdYuHz4JJ3DXcr9Dnn/k8v?=
 =?us-ascii?Q?WRPD3D3p8Bdv4+Dm0FH+dLubAlBfYAtbFTQf3t/bXOsVZ5K+8NqAKcRFdvMN?=
 =?us-ascii?Q?l85a5zj8Huv5nHi6/awTW+pkyeCRYL3uIy1iXW/u12XjfU0HlFfbvbaIdy9A?=
 =?us-ascii?Q?BRwkNYyLvZhLN+xW2VH0/5jSlReqZQF8GfPbo+ZPZ0D8eLJrgulTeqF30NYb?=
 =?us-ascii?Q?r5TbRvQZSXzNBnhKbGWYK9iZ0s7USFPcq0PEXu7OcuJncb4eksDCMbtWf/b7?=
 =?us-ascii?Q?MI6r/rvwS2WpLJRTSFNiwy4a3JGgU8xNo107mrIUZSASw25TeGuw4f6oNa62?=
 =?us-ascii?Q?gQgOnKtw1CMJ42cyIMGiJauncKMqFj6+HF6qbkyV0HfvUWg6ONf3yOMaCwQM?=
 =?us-ascii?Q?TWpBhPLfO8/+QrKUpaHLtfaArrmDWzyIwWAcRp3/qoQNicIHqSxSjxW1DH9z?=
 =?us-ascii?Q?8f/09ty03CyIc/1yu/NjMA8GehXZfDSuftdF2o9U5Ksg7lo2N75rShbz/PAx?=
 =?us-ascii?Q?o3lkiGaLKCa/ddkcayiS7e9wP7bLCoENs/7HgSVQVqtjJE1M6nSdJy2V7WlE?=
 =?us-ascii?Q?DbGu8UCIfyECMaNUwM8AhfxlBuAB7JdNtzfjsB/BDzCFeTsbkMGxUpVybs3+?=
 =?us-ascii?Q?2NB317rMZNWQpPb5Go8VzcoB8NEBqjwprwT0OEFUTPNP+Ae7luaj3qKp92K3?=
 =?us-ascii?Q?xhW8GceuQcnzPuHjgpKebDt7uEXnEqElwcRhosdPOZtfV4nsZb0+atYI8bYe?=
 =?us-ascii?Q?BKBV6fHftMs7JHDRY88caRsg+B38XRT3tEfzqDpqsTDmQ/ewdCeJG9rhswMw?=
 =?us-ascii?Q?PCJcpyVhnI+sEpJIPg9WnSsS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a167777-aaac-4cb2-1413-08d94a357b4e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:21.3581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FRqgRj6WGrZKRpq2ixYCrQ+ggu70DdDuZyDngyjbJRUp41oOf2ppYWrLb5PyeW89K4HOo3dkrcAuI3Wu9ysLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx switches have the ability to receive FORWARD (data plane)
frames from the CPU port and route them according to the FDB. We can use
this to offload the forwarding process of packets sent by the software
bridge.

Because DSA supports bridge domain isolation between user ports, just
sending FORWARD frames is not enough, as they might leak the intended
broadcast domain of the bridge on behalf of which the packets are sent.

It should be noted that FORWARD frames are also (and typically) used to
forward data plane packets on DSA links in cross-chip topologies. The
FORWARD frame header contains the source port and switch ID, and
switches receiving this frame header forward the packet according to
their cross-chip port-based VLAN table (PVT).

To address the bridging domain isolation in the context of offloading
the forwarding on TX, the idea is that we can reuse the parts of the PVT
that don't have any physical switch mapped to them, one entry for each
software bridge. The switches will therefore think that behind their
upstream port lie many switches, all in fact backed up by software
bridges through tag_dsa.c, which constructs FORWARD packets with the
right switch ID corresponding to each bridge.

The mapping we use is absolutely trivial: DSA gives us a unique bridge
number, and we add the number of the physical switches in the DSA switch
tree to that, to obtain a unique virtual bridge device number to use in
the PVT.

Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: keep Tobias' idea, reimplement using just dp->bridge_num instead
        of hooking a dst->priv pointer and cooking the same thing within
        mv88e6xxx, drop his authorship since patch is basically
        rewritten.
v2->v4: none

 drivers/net/dsa/mv88e6xxx/chip.c | 78 ++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index beb41572d04e..061271480e8a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1221,14 +1221,36 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	bool found = false;
 	u16 pvlan;
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dp->ds->index == dev && dp->index == port) {
+	/* dev is a physical switch */
+	if (dev <= dst->last_switch) {
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (dp->ds->index == dev && dp->index == port) {
+				/* dp might be a DSA link or a user port, so it
+				 * might or might not have a bridge_dev
+				 * pointer. Use the "found" variable for both
+				 * cases.
+				 */
+				br = dp->bridge_dev;
+				found = true;
+				break;
+			}
+		}
+	/* dev is a virtual bridge */
+	} else {
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (dp->bridge_num < 0)
+				continue;
+
+			if (dp->bridge_num + 1 + dst->last_switch != dev)
+				continue;
+
+			br = dp->bridge_dev;
 			found = true;
 			break;
 		}
 	}
 
-	/* Prevent frames from unknown switch or port */
+	/* Prevent frames from unknown switch or virtual bridge */
 	if (!found)
 		return 0;
 
@@ -1236,7 +1258,6 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA)
 		return mv88e6xxx_port_mask(chip);
 
-	br = dp->bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
@@ -2422,6 +2443,44 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 	mv88e6xxx_reg_unlock(chip);
 }
 
+/* Treat the software bridge as a virtual single-port switch behind the
+ * CPU and map in the PVT. First dst->last_switch elements are taken by
+ * physical switches, so start from beyond that range.
+ */
+static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
+					       int bridge_num)
+{
+	u8 dev = bridge_num + ds->dst->last_switch + 1;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_pvt_map(chip, dev, 0);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_bridge_fwd_offload_add(struct dsa_switch *ds, int port,
+					    struct net_device *br,
+					    int bridge_num)
+{
+	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+}
+
+static void mv88e6xxx_bridge_fwd_offload_del(struct dsa_switch *ds, int port,
+					     struct net_device *br,
+					     int bridge_num)
+{
+	int err;
+
+	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+	if (err) {
+		dev_err(ds->dev, "failed to remap cross-chip Port VLAN: %pe\n",
+			ERR_PTR(err));
+	}
+}
+
 static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->reset)
@@ -3025,6 +3084,15 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
 
+	/* Since virtual bridges are mapped in the PVT, the number we support
+	 * depends on the physical switch topology. We need to let DSA figure
+	 * that out and therefore we cannot set this at dsa_register_switch()
+	 * time.
+	 */
+	if (mv88e6xxx_has_pvt(chip))
+		ds->num_fwd_offloading_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
+						 ds->dst->last_switch - 1;
+
 	mv88e6xxx_reg_lock(chip);
 
 	if (chip->info->ops->setup_errata) {
@@ -6128,6 +6196,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
+	.port_bridge_fwd_offload_add = mv88e6xxx_bridge_fwd_offload_add,
+	.port_bridge_fwd_offload_del = mv88e6xxx_bridge_fwd_offload_del,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
-- 
2.25.1

