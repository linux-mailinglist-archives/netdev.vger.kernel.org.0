Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C963F032D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhHRMEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:06 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:39586
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235777AbhHRMDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:03:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dsv5FQ+98jAjm1ktTocAIrxFX4gcRBYfi+DQurP9G+aQpqgkJ89w39XLvFz4y50Cs+Te0v6mWRhU424rZBU5vywGfXZxl/slXW4pypAoYCDyUUrhZcxarLsfKYlH4riRCiInoLqA9kT4RXAua3iSt3AU+EErCSp2sMj4lLkJZTLZo+wVe8nDisRyD8OHs8WMuc9lJ+L0WMThaqWlYZQ3edu5au2icFnUJbCOhu0/mU9LXzHpZR3wru/rPVGYkXRGUxwOMItjWPSo2NNwqtehv33/TSBCvQFuqvr+FYT1G+VMvXGumTjRpfAudfpaVG/LSDQh8jSG16+D5//D7q464A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2C0LH09hsXzxGRxuaytrvCmbbtpof6I8gmWjDQZVuE=;
 b=fSTPIzWtnxVvIqS9yfcGCbqTRTLVTeinFY5HPMra/4EtLkEejK1C6wZbhfwBSEV5IuMSkmANCN/vIzc6B0CP3/QW07Slz4TAJ9EWrEvDqBjoF0tBmgdbIsbBreTBQ4BjYDEbTYzEZ0VXv6HlvoJvUeSuuUbkq6K+rHxU/TJS0Ge8rJ0mxiSTmlCKcPXcuF45AAP9IakDUKK1eqXaHgw/m89jYO8mAHjCCDg9AsMIMCrnnr4ddPTamaRTRLdeWAMR9INYPQhG/aIb2c2kneXgdw4/sqsgwdACKCklTsAFcJLlY4rm5XCIesovb3JOR9JqhmSiUhewaibRsEqYs6QlUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2C0LH09hsXzxGRxuaytrvCmbbtpof6I8gmWjDQZVuE=;
 b=fjdu9UktEzktXoPs0vDN9onwuetT1Y6SlWUtMGBaK+23hYmOqXFZwjf0ZGtsK3T/KnkF9tpTsYyK6H63B8sU+TIAUCJM4TBNfw72nW4RcyDjVbbNpaMlR+KZbU2UlYoA/UrDjxDqy9YF7CGvxVCbBA2lWsLFpHnsk2n9UlsqXHI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:02:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:02:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 02/20] net: dsa: assign a bridge number even without TX forwarding offload
Date:   Wed, 18 Aug 2021 15:01:32 +0300
Message-Id: <20210818120150.892647-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:02:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc12eadb-e423-4bcc-1a8d-08d962401b74
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839BE6BF8CE075CCED56C30E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIq4AwQqu8bpZP0cT/UXaqL5DkuvoRncO4SRqDcBSE/cqeRtynpcBtQPkHb//vsSCNBy0ZnNiTVtcZ6v5EwXgpppPalsi4b47maAcZOShxdQBh7zMCPIUnySL/KcXrN3vOZLBEvVp1QezknhWtjF/EELYgt0yII0fNA1ioYucvmQul1GvFpjanbr/3t4SDoqP8N53NfnOQqwpyShkiZqbi6fDwnKXRu6w5lRKfHdVG8702cxEhazmC9kQ1heKHq6NOOlkpxW/NH/x4/jU0t3xGUK3MgjrXAd8KJPq1MLFcTdHbdZS4mJNgoXxKVMlpJ8do3n44JOtpTJmjDLjlSDzOvS0dYE2XgqS+MViiOXPSEyC6JDukFqpkUOZDM5An5GFQKumEYxDUjn5dNkljNCNWfZp0AiAgnj/MdP1b0ekBNjJQGSvq3M411Dl0GPI7J5+U8xFZAGBOUlze3xv0TBDiNqTR8c3d4RNz5YoXssYYn1cLC9jbWTGLDmiVq0bVE4bxQTZyiiLSbD31CW9YzrqP6LW5CZUA0HPM7D1FK124aSmKsVKS68E+3Fb288kb/Kac+FWUWx5AkOvDPtQpTOys/CdrRtCNHHqTK7726GyQp3D5/4KOOMpqPPupp3VaiGKVU6+MLG02UVijqV1MjMOsMO2ShD9+gzq0hQTQGX17XeXIu7b5bb2YvGexXI1wTx3NqM3g83aQCgqQsfR3UiJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?az1i81GXDQ/ebqA9zmXQnkcfYCtE2we7kJBqn4MfTDOnegdXzvROujBbNydv?=
 =?us-ascii?Q?jFniNmtTibPhaq8gbcTsOlRkiYwKqu4Vz0HAEe7gFgJ2VENV25jEUd+m/IiY?=
 =?us-ascii?Q?xvyNjV3ozq8YtDAzm+BhjGtFSsLk126JZxTBeqXUCv/E6F2I+Tl3VtGTW56c?=
 =?us-ascii?Q?HVHpHfJ0QIUFKVuOawUIDDxtD9SDe1LYpJ+kPN1gIibC6j0RjXTo+Eh49T13?=
 =?us-ascii?Q?ZUBAF85HuH3u4vxb72j0OfmhrvNiUouliXNbyLlU/jOuFwCWa5g4WVjztoEM?=
 =?us-ascii?Q?q2LMeGW++rnlhSTk5oK6MhegvGtNWP5A//f/mxaoMSCulm94Rc3128xt+kYW?=
 =?us-ascii?Q?ErA1lYtf0Rz8zbdoh58CPHeNrKgwtjqKM2ePDNSQkctxokGpcjoDCl9yotlH?=
 =?us-ascii?Q?d/zWnK5O6u0gZCbHwwbFy0RMgpSaNGB1jqqKfiyL0uM10AQkgYeJRq4j7MBp?=
 =?us-ascii?Q?51y7+KTV3j+oSVhXZMlKRh+evLKfP4fUap7N4iaqS5ETTW5M1uMGa55qyEDr?=
 =?us-ascii?Q?XLmLI+FCCdEhcCPaS0RjOn1SPQP7NTvi1r9cOKWTOO7ldw29Y6zDojM+HyLG?=
 =?us-ascii?Q?DdiG1FKSDoOanyfibLNF+MQjUtPe7CtG3NV4gt9aQirFqbXoe8fVrHLNR+co?=
 =?us-ascii?Q?0sZM2vFGLfKyFdRGxd+gpDgXLxHj2jXOO4su9woAWfezke60Z2OZYsc+YEho?=
 =?us-ascii?Q?7nCdqqO8aD6O8VVBQEW7TjvPUl9WBgDAS4k0e0JYIl/jOg0FWu7EUncO/o2y?=
 =?us-ascii?Q?N/Tq0npPnUOnzVji1GO6UmDi7psvdTFmtBERieI5Hkjh6xXdc8SwuTn+ERUW?=
 =?us-ascii?Q?oJ0damWiwFF+kgwhlUbX8QTHtSptYsY31yc86l9myjz3vjWrAlXmSYcwUqD8?=
 =?us-ascii?Q?E6voFue513lGHuAg7vsHDzOz/uE7p+2K7QHZrAfB+8O61CcB2eqLeS+cE3Id?=
 =?us-ascii?Q?6oHVcE6kBC4YGbfjdQpwQBqpErrtKw0lFZJKJaoRNzcFPBLTjjaxRJ3DhS0+?=
 =?us-ascii?Q?1+unjRHag5QhKNUhxBIYYzogDhQFo93wCN2ZDR+J4YOkh4oHc/hR6ELvzIYw?=
 =?us-ascii?Q?MRMl7DViULf46dG7iVejZNJXtTYy3HBvMdhEjltshf/GyXwEeya5bDhN2J3/?=
 =?us-ascii?Q?L94FRAGCysgnKhYELVnA+KYGf+QWv9ifaE1xK017qW1ZJKVkGNGakmbYUYPB?=
 =?us-ascii?Q?jbsXUv7AEqW17dmXjQ/7eEw9BBH/SS4LLppqLBa6R+1lKw8yYN/UwbgsBbWx?=
 =?us-ascii?Q?jSg+MXwSWckq3pJCSq/BnckRqeN2d31ylDEgwvMK119/tmGpXHk6q/I2ng4g?=
 =?us-ascii?Q?kalC1p4J8L7VMwIKs8pJy6Hz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc12eadb-e423-4bcc-1a8d-08d962401b74
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:02:53.0457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wx2ZGjxp3GFpCCJLDjZNfKxDSQFZso8/CPHqAcSF24s8m/n0sb3/oKLZ0ryJSc7DVTx1+co2X1CcG039iyq1+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The service where DSA assigns a unique bridge number for each forwarding
domain is useful even for drivers which do not implement the TX
forwarding offload feature.

For example, drivers might use the dp->bridge_num for FDB isolation.

So rename ds->num_fwd_offloading_bridges to ds->max_num_bridges, and
calculate a unique bridge_num for all drivers that set this value.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c       |  4 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  2 +-
 include/net/dsa.h                      | 10 ++--
 net/dsa/port.c                         | 81 ++++++++++++++++++--------
 4 files changed, 65 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c45ca2473743..32fd657a325a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3090,8 +3090,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	 * time.
 	 */
 	if (mv88e6xxx_has_pvt(chip))
-		ds->num_fwd_offloading_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
-						 ds->dst->last_switch - 1;
+		ds->max_num_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
+				      ds->dst->last_switch - 1;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 05ba65042b5f..715557c20cb5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3055,7 +3055,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->vlan_filtering_is_global = true;
 	ds->untag_bridge_pvid = true;
 	/* tag_8021q has 3 bits for the VBID, and the value 0 is reserved */
-	ds->num_fwd_offloading_bridges = 7;
+	ds->max_num_bridges = 7;
 
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SJA1105_NUM_TC;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index c7ea0f61056f..62820bd1d00d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -407,12 +407,12 @@ struct dsa_switch {
 	 */
 	unsigned int		num_lag_ids;
 
-	/* Drivers that support bridge forwarding offload should set this to
-	 * the maximum number of bridges spanning the same switch tree (or all
-	 * trees, in the case of cross-tree bridging support) that can be
-	 * offloaded.
+	/* Drivers that support bridge forwarding offload or FDB isolation
+	 * should set this to the maximum number of bridges spanning the same
+	 * switch tree (or all trees, in the case of cross-tree bridging
+	 * support) that can be offloaded.
 	 */
-	unsigned int		num_fwd_offloading_bridges;
+	unsigned int		max_num_bridges;
 
 	size_t num_ports;
 };
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4fbe81ffb1ce..605c6890e53b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -271,19 +271,15 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 }
 
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
-					     struct net_device *bridge_dev)
+					     struct net_device *bridge_dev,
+					     int bridge_num)
 {
-	int bridge_num = dp->bridge_num;
 	struct dsa_switch *ds = dp->ds;
 
 	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || dp->bridge_num == -1)
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || bridge_num == -1)
 		return;
 
-	dp->bridge_num = -1;
-
-	dsa_bridge_num_put(bridge_dev, bridge_num);
-
 	/* Notify the chips only once the offload has been deactivated, so
 	 * that they can update their configuration accordingly.
 	 */
@@ -292,32 +288,65 @@ static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 }
 
 static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
-					   struct net_device *bridge_dev)
+					   struct net_device *bridge_dev,
+					   int bridge_num)
 {
 	struct dsa_switch *ds = dp->ds;
-	int bridge_num, err;
-
-	if (!ds->ops->port_bridge_tx_fwd_offload)
-		return false;
+	int err;
 
-	bridge_num = dsa_bridge_num_get(bridge_dev,
-					ds->num_fwd_offloading_bridges);
-	if (bridge_num < 0)
+	/* FDB isolation is required for TX forwarding offload */
+	if (!ds->ops->port_bridge_tx_fwd_offload || bridge_num == -1)
 		return false;
 
-	dp->bridge_num = bridge_num;
-
 	/* Notify the driver */
 	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge_dev,
 						  bridge_num);
-	if (err) {
-		dsa_port_bridge_tx_fwd_unoffload(dp, bridge_dev);
+	if (err)
 		return false;
-	}
 
 	return true;
 }
 
+static int dsa_port_assign_bridge(struct dsa_port *dp,
+				  struct net_device *br,
+				  struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dp->ds;
+	int bridge_num;
+
+	dp->bridge_dev = br;
+
+	if (!ds->max_num_bridges)
+		return 0;
+
+	bridge_num = dsa_bridge_num_get(br, ds->max_num_bridges);
+
+	if (bridge_num < 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Range of offloadable bridges exceeded");
+		return -EOPNOTSUPP;
+	}
+
+	dp->bridge_num = bridge_num;
+
+	return 0;
+}
+
+static void dsa_port_unassign_bridge(struct dsa_port *dp,
+				     const struct net_device *br)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	dp->bridge_dev = NULL;
+
+	if (ds->max_num_bridges) {
+		int bridge_num = dp->bridge_num;
+
+		dp->bridge_num = -1;
+		dsa_bridge_num_put(br, bridge_num);
+	}
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack)
 {
@@ -335,7 +364,9 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
 	 */
-	dp->bridge_dev = br;
+	err = dsa_port_assign_bridge(dp, br, extack);
+	if (err)
+		return err;
 
 	brport_dev = dsa_port_to_bridge_port(dp);
 
@@ -343,7 +374,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br);
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br,
+							dp->bridge_num);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
@@ -386,14 +418,15 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 		.port = dp->index,
 		.br = br,
 	};
+	int bridge_num = dp->bridge_num;
 	int err;
 
 	/* Here the port is already unbridged. Reflect the current configuration
 	 * so that drivers can program their chips accordingly.
 	 */
-	dp->bridge_dev = NULL;
+	dsa_port_unassign_bridge(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, br);
+	dsa_port_bridge_tx_fwd_unoffload(dp, br, bridge_num);
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
-- 
2.25.1

