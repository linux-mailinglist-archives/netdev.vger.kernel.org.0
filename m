Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921473D2721
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhGVPPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:15:45 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:4577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232729AbhGVPPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:15:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUNK6+o+2Nvt/v7KrJEHRAaZfrtk7Dt8HB39LY2G3SLzPg3Pv9TPNnAfOGWYieVjnXeHo0+R6Jm4H0auhSVMqXmUn4uk04LD2DX1XLK69wtrSs2iFGjBzz6p3NyM/ZGiFUdzFQIvsMWMAK7IER7y3GmKZmu+VfiHjHtAUJkiHuCo6oig92mzgkyUHk08oPqi9hCoNy1MTE5Kp9YU1mAZAg4EJCmxeS9gNlyeHF7ErJ0DhQyuzcikH5gw4bWaCSKcDMnjsg297nrQn1oY513Kq/LlM2vIyawJbbEfHWXQDghYsUjogSfTVKZkupNfJ4MJUvMuqWekjG+Vwg8xfv6oAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bT++v7JIFEgiUTptbNQ1BXpNA0iMewfhGYU1bgX7trE=;
 b=GGtuX5jfwpT8CsbRE2kNoEHw0Ub5jFy2NJ1/zXDoGq013ApMCLs25Uf+GMe25B04Deo8AQWv/R6qZD188nRaYiKL4J4+iOuKW/r8kyjgK/pGR7pF87cQA5XXj5zGsre+6dYpSWN+W0R+hnBo8tK1ilFhGVK1a1LQsmJCkqI7TAkPBnxxUzBEjha1zgwUhP2ApPSAlUhT/M31XT8RY+t5jeGKGcAkmCPthjVMLJQYLomLQ7VqQWxIFhUv8b3xKCYkMsu4ea9VnlQX6jMkXZdV8+ICekKbOJK37ajbC2AdN+zIit/6pAOS/i+Q8efzimHS9REW5iQ9+6cei2FPooyQwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bT++v7JIFEgiUTptbNQ1BXpNA0iMewfhGYU1bgX7trE=;
 b=GolA3UTacK2bJaq+NmouKbX+snDzuIYGmAPc+aVKgZNo53x9tuH1QfsUHvL/kOQUy8VnTm/8Es/pvX6DNaaUVkT2RYuGlhxL9/gzeYoaiYkrj9imFFdcHBZ2GchDGYRovY8mGxCz6lwMFR4w1wTkisgY2+nzpZqRiBEfOtXDeAA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3966.eurprd04.prod.outlook.com (2603:10a6:803:4e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 15:56:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 15:56:08 +0000
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
Subject: [PATCH v5 net-next 4/5] net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT
Date:   Thu, 22 Jul 2021 18:55:41 +0300
Message-Id: <20210722155542.2897921-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
References: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0099.eurprd07.prod.outlook.com
 (2603:10a6:207:6::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0099.eurprd07.prod.outlook.com (2603:10a6:207:6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 22 Jul 2021 15:56:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa8e1a93-500e-4e7b-571a-08d94d293829
X-MS-TrafficTypeDiagnostic: VI1PR04MB3966:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39669A33331D5462F4FAF8FFE0E49@VI1PR04MB3966.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCdCxqnusLvZ2nzTgS9ok4E0kM9MV8luR8djJ3rTsqSAOXoaOodPlAVuSHcrqG1x0s7XbCmQV7tYupdNayTlTyqVk/RsNTRzLUi5g8TR26eUabjDbp5/VAgbglXgegeWAFPoBvoNSxrNRepQ2k1TKCmBE4n06H/uWa7cRM/RYQNpUYGhkNKjeB26ky6AYs4cJ1+nhX+tkK6fnhHkxZ+UX7REsgXrLr6LI2rMErYTj87yoCCIWmWtBK420S9H6AEGwltxAZM8xXJMDOzySuZbOhGOiKbi2tUq1GDs67tuaAtdr3jHldLwoUE6VaUMGI92oThRwIpyS69iq/sJiRvWZ20g8uN6aA16JnyzB2NCZa7aPgZLd2n2c3Mj892seTspIJyrJdgc6xyxMuGyvJu70iK4nt0g21HDgjiox7MQnuglzqozdE8ou/6t9vNKPXBg5CcNg4JLiJzbzdZKs9HMuTNuEAEGg4hI3LdKUZxgOUYeaMwBsqbLt1k52FuOrcDgfA87KhL5WNlRUVndiJ7TXRULSAq3EPZsv54oLK3VQekuxgQLRz5YpnShUrTCJVfHLAAoRlcrUYatmRskEf3kjbqauuzfGSZ9EVoMxbyJg4fODpGm/MHMD46j+RmXyYcQRyWgiSZZ1bVcrpEywiz9Mf29B/wvxJdvG602h8sue6bn2XF+6RRn2vDG+sPGLtVX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(38350700002)(2616005)(7416002)(316002)(508600001)(86362001)(44832011)(66946007)(110136005)(6506007)(8936002)(4326008)(5660300002)(6512007)(8676002)(54906003)(186003)(66556008)(36756003)(1076003)(6486002)(6666004)(66476007)(52116002)(26005)(2906002)(38100700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NKLGSSp/Tzf+vMXfxBQ+VmsUHa3jFUy+F/dZAm3LNoNLy7UDkle8p8Vxh3yK?=
 =?us-ascii?Q?s9/QhfiPDAI6w66ldMxgUHnO4J92RDpmwp9dFnyF94WbY1uKimxlaZv6x26T?=
 =?us-ascii?Q?txAphD2dnLHg8lCs3L2zVfuBM+SNMDxVCyqrwTSizdj3leJ8ZlfYU5Hyi21T?=
 =?us-ascii?Q?z3s+PuC/hEPmxDJ3DUIdMdOceu0K3cQr1wwBT9FunqffY99WvLBY1fcAHrux?=
 =?us-ascii?Q?Q8T96/rZB9G+7II6E7SUn+fMz2WgNd4+3tFVSSqKWtCbVyVR+PijiKtddweJ?=
 =?us-ascii?Q?7oU/Y7/M7e8N1IPP2ocg3zseZ/V1ermuBMg2SIuzIPYJpDJo3ymsnwBPyVQt?=
 =?us-ascii?Q?wUy2+tzY5QTU8PithRh6Zed+RH3VngjcUFzxB23hKXpMJ7M1hRYQOG/6oS3K?=
 =?us-ascii?Q?znmmwUwHZntEWZP+1hu4y43aQ6l9fOojTJGLBQ7r3YSePxYc6ms3QMxWKA5M?=
 =?us-ascii?Q?0PZq2oaI3ymai/1QxQmRl0XLBjwKEWyeJBn+HYD0cpgMTvxEAaVIET/37/bk?=
 =?us-ascii?Q?UIebCCdUIEXO8D4zPrr+1cRNJHV5nAAhuwBgcrCumQVZdCBJ7J2Ewt/sLQGZ?=
 =?us-ascii?Q?KKKM01oU51MVJyxnocbS7DDshZSE7JTcrvh4G/h3+pajYS3KMJYdq3gvxBhC?=
 =?us-ascii?Q?vlitzQPmEXZkOiSh9s5I7E+JwDonXzOjgZZvdx39Qz7PiR72MhBuSyuxfc7x?=
 =?us-ascii?Q?PbO3qTSfxy6CplaczQbH52kTZl5HBld5Kj5oGEWL1219imfdOz0cfZKeqCmN?=
 =?us-ascii?Q?mH7rxn9ONP63o0lLiDtoGKvb+Ti4BPCvePVTd5ggppBQD/XpA5X7JRmFkaEV?=
 =?us-ascii?Q?A5RHPJZ0M7S8LRotXDu8a85VbDIfiPt2jl//hfw58IGv9OUOetboIKBuqYC5?=
 =?us-ascii?Q?bpcSRQBE01taRHOddXZtKVITMjW2ARtHaRwb+sMacQZIy8I2JBS/a/H223FD?=
 =?us-ascii?Q?YOhFBHcB/dZMHcV2sU3V+GXRsVnyu0eVkqKiDS8ei7beNZezU6SpySb+tEi9?=
 =?us-ascii?Q?nPkXGj/15GlVTaWnw906R6zkvbPYvHcjIQXFnjc3ywL53LKgiJvQWN75FOYd?=
 =?us-ascii?Q?WUMHwHt8f3ancTy52Lula/8lC0/l3ajLeIIwjh7Wx5TvatazXD3Y53X69y2B?=
 =?us-ascii?Q?A3amT15qTGf0fV+1/s20n+E8U0yiNLJ/E5sOsbaGfgDEKGN2XDqqsnKmAegl?=
 =?us-ascii?Q?AMNU65rfQ58TWLoDH5zOnwB7J3SxexLXPtmNZjsPONZiC3hLa9u+/iWjR2mK?=
 =?us-ascii?Q?I0L+O4yFqpKrO3oyae/ZYkU58qg72V3cwLaDmFK9vfKzTdaGgwn6yvSVdYFF?=
 =?us-ascii?Q?RnxerrWqxIiwaqTeLlyay16o?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8e1a93-500e-4e7b-571a-08d94d293829
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:56:08.2476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlx5tQ5hTnl7dSOKIvlERxBmzBpVaAtxC2jsCdBl3NyRWd9Zatteat7592XjAlETWLwBVrjofj37dKNsxVOhag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3966
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: keep Tobias' idea, reimplement using just dp->bridge_num instead
        of hooking a dst->priv pointer and cooking the same thing within
        mv88e6xxx, drop his authorship since patch is basically
        rewritten.
v2->v4: none
v4->v5: rename functions for naming consistency

 drivers/net/dsa/mv88e6xxx/chip.c | 78 ++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index beb41572d04e..af764b8445b7 100644
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
+static int mv88e6xxx_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
+					   struct net_device *br,
+					   int bridge_num)
+{
+	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+}
+
+static void mv88e6xxx_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
+					      struct net_device *br,
+					      int bridge_num)
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
+	.port_bridge_tx_fwd_offload = mv88e6xxx_bridge_tx_fwd_offload,
+	.port_bridge_tx_fwd_unoffload = mv88e6xxx_bridge_tx_fwd_unoffload,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
-- 
2.25.1

