Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957A13F032E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhHRMER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:17 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:52143
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235738AbhHRMEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/CFkVg+6MqidlD2uvQK2Uow5IP6jSRB1ae1vkFkfgkHCtjkvz9d3Dy1yrnxoKe8HP4zkx7wAdeFB6Zf0wRuDtzyF2ikoKgVAexApX8PHAgbI+bHObrLm9CaudfQuJYJYuxXDdn7LTBJR65WVRLlXz5RLS0OI7uoZOMS1c6cN3zqdj3b+nTNdYwb4O9SlXYC96fNob8mz8Nit0+0kGUvYYkNjNIEUJ5LKQ/CiWOXIK3am4+Em9ckSOBNJEzxn0HXQZGXJU6r2iOkblMqw5jjisCwGl772NvF0Yrfmd7/byWVr0b/mKdNgB4K7D+P7hwJUGSWgyeDuNV1BKoFPREc8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN+qd67Skj3T1WnSi5unbqEgKdX6/OG2sCxeO8TB/xM=;
 b=GcsPbDLvQvSunasc2d57UAhQPYMRCcO0umD1hW3VXjuVhBgNkk1DOBedySMbo9f3jYNlaDvngs0GNxJKmOJPgGcjTjHwI8jKTJ1EK3oMjeZkra9o4OJwq22xgYFon87/ll8E1IOro1av3q0AfHAqV0iQ02SddMtZwgVCZdGYjGW3RfupoiDByA2ixfC1lj8uVqeT6hYbm4CAX+oExZI1Opqdd/BPN3PB1xFrZIKUEN7M4hv0vZyas3FL7c5V75KROUaWRbU/dTnssO3RhIfw408bLy8O4qX+9+vhs+cPUZJ5afPdSaB6xmqXSP7U3c+LPUxDkNTMDo/ci/CVEkL3GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN+qd67Skj3T1WnSi5unbqEgKdX6/OG2sCxeO8TB/xM=;
 b=ZMa8iCjKexg2z7TZDAQHWrJPkOAIUTieMP3pvG2HbvWoGCBXjURd39bOau/NXbLoXBTwu2PPjEGLGqczAfCAq1d4Is+Jch3jjcN92dYIKBlNzO/J1R3TzjEJ1wMD+TI1UQt6Melkbdw9JXZUQrKoPUhI6tzQ6Dj0GslN7312qhA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:02:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:02:58 +0000
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
Subject: [RFC PATCH net-next 06/20] net: switchdev: drop the atomic notifier block from switchdev_bridge_port_{,un}offload
Date:   Wed, 18 Aug 2021 15:01:36 +0300
Message-Id: <20210818120150.892647-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:02:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e5b8cda-d6de-42dd-4811-08d962401ed1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB38397B68A4A1380F1DE1ADA5E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhROQpPvzDYk4G9T/ZkHp/lRxrG1PSdE5wFLU6PCkvW9cujWW+Teo39MAvt/kGH5INMIKU3YnV1zDSLov5F+PUv6iVHl09CVOnKUGwrLwFnDTGmmAzhzKCX+2itOvj1MPaL575Kr6OroWFN/EA9Bj43Py9Pptrz5vsgUsewr8g0vCmX33fYUKYA3jhU8lhWeaS430eVvQJqlz1h4gcYdF+GA3GDirCQHt8gt2i49Eh13vV7eTHXTY9QTw/gF7wS7vzP8VwI+ulm1p2YHmiDdDINcPhMF2C+l6D2zeuYgFLwKEMtd7Q+U8QpPRt5NvK2VPqIkreRO9TUwrDLlf+oZOoNEOOK/+8kFZa2UaZyhDvoN/O718EzNsVFrVcVvLARu9KU5c8qxgDsQSKV+7B6SzkXRK+UtZFE/WvWUPWnqIAX5JMjUcaSXpaFIgeSiY1Yi2Exg1Q2yg5gFsYurCrcUlrGatHwTmr7IejIfgm1Fnbe6YVAvV46/avsZbu0jCD3g+yAj+Mxvzg2Mk6aHOZ3Jjm7mZuYuDb4CXfY0MlnymhzbHTxVr5dAjgSUPDoZTidN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(30864003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?njbbwQhTO5/TxMpjsUvyynWqoY9bPggnymcyuyermTaN7D6TRzeJ+EBdgP08?=
 =?us-ascii?Q?FOU9KCVODESWyF492ohSOADw3M2iV8FS3TojgJkPWfJIgtSF+A60//yP+yP+?=
 =?us-ascii?Q?zfaElmTDEzI/H2BeypXBAw24ZHfT0Z8tNcxGEDzRDKSPBxo/kr+K7FPDjwAd?=
 =?us-ascii?Q?sCaFoirOQ5L12UfmCiuk7KSq5jhsh8c8eJSxfWOZcdLne36T/3xyTzT+xmP3?=
 =?us-ascii?Q?EP6+2OKpBNjkwqKiF+TNV0uesK0aR/z5x7J345yqCaT4IurVigbb1LJ0Nq02?=
 =?us-ascii?Q?XXYyWERVdpYzA44FFW82Oo/HhLk4YqYzsKdhvvoB0prLEUh/dNIn/niK1u7Z?=
 =?us-ascii?Q?D8A0PQfP9wG0C4H9eROVSYopZSv/MX0fbrDj6lQ2n6UMOcAp8J6LXA9QVUYn?=
 =?us-ascii?Q?SlzX3WA1kje2iAwKH3J3vY6gX/yTieZgW6rJcyo5rbizkU/TpDh6vhghBfsE?=
 =?us-ascii?Q?cA/ZLV3T6hwK/GDiSDxmrKkSgCwxKtnFgXvgqv7mmXFV0xXq0VfYeAxxhh0L?=
 =?us-ascii?Q?ronGiO4umkdaYmCU6sSm4GNQDBnytdkSb18nmmZiDdWS9kv2kFPXJltCbIDR?=
 =?us-ascii?Q?PPpkKSc6Q2fjUQJ/AKKTO8IP7qsQREgrxf+l0Vp6QEXdb9DIZN+Flj4LzQz2?=
 =?us-ascii?Q?pNEsWk16NGZzRMmRTVQY4tLJ2VYU8DpIkSpmqJsYydAaFB6RJ5hbWEiSXLcL?=
 =?us-ascii?Q?Tkt2Dp46Y6Ho56phx+GCiyZyIT8PrsoDbFULcp8sCx8alFCb7iucsC9Esv4n?=
 =?us-ascii?Q?iyA8y+jNroYmqUg5crd3bAi702anUz1XUJoY8dZJOoYHVQVWmob/Vdvf/aNp?=
 =?us-ascii?Q?/e3C8VtF9a74LCagwBiAphhqgGWwtnu+uYSbd10yH7B2LLHFKZdygNp7DlRp?=
 =?us-ascii?Q?9W2NSnYNyTbiSN2Mp2fgjczyL8iRNC7INQJvHPUsBNMexYXnac5BeOH7qiHA?=
 =?us-ascii?Q?w0tQy8Iu/xOGso/zctRN3lOTJJaKsHXjJH1zsMOmrxnSwqzzW7+JQAQkIHmj?=
 =?us-ascii?Q?JzYab87mi90NY96WqRTgcVpTHUaviwtf3dmtWxqtjC6jr2SA+mdVEdUsixOK?=
 =?us-ascii?Q?epXa1ROrmcVnw269LXwea04HlZsRX4OxLVLCZZ62FdMwh+7Iu5n53+IJZYAZ?=
 =?us-ascii?Q?5l1D6NzFPsYXsMOyabGHpoGHuHGf1WsCX8hsMbgSrmvGb/L02HBvjyD673Lz?=
 =?us-ascii?Q?kjO2seqHz8TWqSzW/LTKkppB4p9wW5UnxvPZc/+z/HhzgO1YxpfpGFLt6kUa?=
 =?us-ascii?Q?2CGLEd6pm0tNQR7miJTMFKO6Napu53t/NoExBZm5Kr8SDUiLHsudOWwSZqeh?=
 =?us-ascii?Q?ybPGNYC8eAHzK6SQu+AUQZDf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5b8cda-d6de-42dd-4811-08d962401ed1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:02:58.6115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGfKUX2ZYDqTmwHnRF7bTAgockFZYfceI+zvkUnjfRkT7uGNsbaZkLBHv/XroS/I2GAuGBoyUtIGKcWAs1ZFsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that br_fdb_replay() uses the blocking_nb, there is no point in
passing the atomic nb anymore.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c       | 2 --
 .../net/ethernet/marvell/prestera/prestera_switchdev.c    | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c  | 4 ++--
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c  | 4 ++--
 drivers/net/ethernet/mscc/ocelot_net.c                    | 3 ---
 drivers/net/ethernet/rocker/rocker_ofdpa.c                | 4 ++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                  | 4 ++--
 drivers/net/ethernet/ti/cpsw_new.c                        | 4 ++--
 include/net/switchdev.h                                   | 5 -----
 net/bridge/br.c                                           | 5 ++---
 net/bridge/br_private.h                                   | 4 ----
 net/bridge/br_switchdev.c                                 | 8 ++------
 net/dsa/port.c                                            | 3 ---
 net/switchdev/switchdev.c                                 | 4 ----
 14 files changed, 17 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 5de475927958..82f31e9f41a9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2016,7 +2016,6 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 		goto err_egress_flood;
 
 	err = switchdev_bridge_port_offload(netdev, netdev, NULL,
-					    &dpaa2_switch_port_switchdev_nb,
 					    &dpaa2_switch_port_switchdev_blocking_nb,
 					    false, extack);
 	if (err)
@@ -2053,7 +2052,6 @@ static int dpaa2_switch_port_restore_rxvlan(struct net_device *vdev, int vid, vo
 static void dpaa2_switch_port_pre_bridge_leave(struct net_device *netdev)
 {
 	switchdev_bridge_port_unoffload(netdev, NULL,
-					&dpaa2_switch_port_switchdev_nb,
 					&dpaa2_switch_port_switchdev_blocking_nb);
 }
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3f574a69c244..a1c51656eb42 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -502,7 +502,7 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	}
 
 	err = switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,
-					    NULL, NULL, false, extack);
+					    NULL, false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -516,7 +516,7 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	return 0;
 
 err_port_join:
-	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
+	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL);
 err_switchdev_offload:
 	prestera_bridge_port_put(br_port);
 err_brport_create:
@@ -592,7 +592,7 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 	else
 		prestera_bridge_1d_port_leave(br_port);
 
-	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
+	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL);
 
 	prestera_hw_port_learning_set(port, false);
 	prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 791a165fe3aa..1a2fa8b2fa58 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -362,7 +362,7 @@ mlxsw_sp_bridge_port_create(struct mlxsw_sp_bridge_device *bridge_device,
 	bridge_port->ref_count = 1;
 
 	err = switchdev_bridge_port_offload(brport_dev, mlxsw_sp_port->dev,
-					    NULL, NULL, NULL, false, extack);
+					    NULL, NULL, false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -377,7 +377,7 @@ mlxsw_sp_bridge_port_create(struct mlxsw_sp_bridge_device *bridge_device,
 static void
 mlxsw_sp_bridge_port_destroy(struct mlxsw_sp_bridge_port *bridge_port)
 {
-	switchdev_bridge_port_unoffload(bridge_port->dev, NULL, NULL, NULL);
+	switchdev_bridge_port_unoffload(bridge_port->dev, NULL, NULL);
 	list_del(&bridge_port->list);
 	WARN_ON(!list_empty(&bridge_port->vlans_list));
 	kfree(bridge_port);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 7fb9f59d43e0..eb957c323669 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -112,7 +112,7 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 
 	set_bit(port->portno, sparx5->bridge_mask);
 
-	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL,
 					    false, extack);
 	if (err)
 		goto err_switchdev_offload;
@@ -134,7 +134,7 @@ static void sparx5_port_bridge_leave(struct sparx5_port *port,
 {
 	struct sparx5 *sparx5 = port->sparx5;
 
-	switchdev_bridge_port_unoffload(port->ndev, NULL, NULL, NULL);
+	switchdev_bridge_port_unoffload(port->ndev, NULL, NULL);
 
 	clear_bit(port->portno, sparx5->bridge_mask);
 	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 5e8965be968a..04ca55ff0fd0 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1162,7 +1162,6 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	ocelot_port_bridge_join(ocelot, port, bridge);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
-					    &ocelot_netdevice_nb,
 					    &ocelot_switchdev_blocking_nb,
 					    false, extack);
 	if (err)
@@ -1176,7 +1175,6 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 
 err_switchdev_sync:
 	switchdev_bridge_port_unoffload(brport_dev, priv,
-					&ocelot_netdevice_nb,
 					&ocelot_switchdev_blocking_nb);
 err_switchdev_offload:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
@@ -1189,7 +1187,6 @@ static void ocelot_netdevice_pre_bridge_leave(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 
 	switchdev_bridge_port_unoffload(brport_dev, priv,
-					&ocelot_netdevice_nb,
 					&ocelot_switchdev_blocking_nb);
 }
 
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 3e1ca7a8d029..c09f2a93337c 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2598,7 +2598,7 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 	if (err)
 		return err;
 
-	return switchdev_bridge_port_offload(dev, dev, NULL, NULL, NULL,
+	return switchdev_bridge_port_offload(dev, dev, NULL, NULL,
 					     false, extack);
 }
 
@@ -2607,7 +2607,7 @@ static int ofdpa_port_bridge_leave(struct ofdpa_port *ofdpa_port)
 	struct net_device *dev = ofdpa_port->dev;
 	int err;
 
-	switchdev_bridge_port_unoffload(dev, NULL, NULL, NULL);
+	switchdev_bridge_port_unoffload(dev, NULL, NULL);
 
 	err = ofdpa_port_vlan_del(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
 	if (err)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 130346f74ee8..3a7fde2bf861 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2109,7 +2109,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL,
 					    false, extack);
 	if (err)
 		return err;
@@ -2126,7 +2126,7 @@ static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
 
-	switchdev_bridge_port_unoffload(ndev, NULL, NULL, NULL);
+	switchdev_bridge_port_unoffload(ndev, NULL, NULL);
 
 	common->br_members &= ~BIT(priv->port->port_id);
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 85d05b9be2b8..239ccdd6bc48 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1518,7 +1518,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL,
 					    false, extack);
 	if (err)
 		return err;
@@ -1535,7 +1535,7 @@ static void cpsw_netdevice_port_unlink(struct net_device *ndev)
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
 
-	switchdev_bridge_port_unoffload(ndev, NULL, NULL, NULL);
+	switchdev_bridge_port_unoffload(ndev, NULL, NULL);
 
 	cpsw->br_members &= ~BIT(priv->emac_port);
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index ff61df255142..210a6786229f 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -183,7 +183,6 @@ typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
 struct switchdev_brport {
 	struct net_device *dev;
 	const void *ctx;
-	struct notifier_block *atomic_nb;
 	struct notifier_block *blocking_nb;
 	bool tx_fwd_offload;
 };
@@ -264,13 +263,11 @@ switchdev_fdb_is_dynamically_learned(const struct switchdev_notifier_fdb_info *f
 
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
-				  struct notifier_block *atomic_nb,
 				  struct notifier_block *blocking_nb,
 				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack);
 void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 				     const void *ctx,
-				     struct notifier_block *atomic_nb,
 				     struct notifier_block *blocking_nb);
 
 void switchdev_deferred_process(void);
@@ -353,7 +350,6 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 static inline int
 switchdev_bridge_port_offload(struct net_device *brport_dev,
 			      struct net_device *dev, const void *ctx,
-			      struct notifier_block *atomic_nb,
 			      struct notifier_block *blocking_nb,
 			      bool tx_fwd_offload,
 			      struct netlink_ext_ack *extack)
@@ -364,7 +360,6 @@ switchdev_bridge_port_offload(struct net_device *brport_dev,
 static inline void
 switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 				const void *ctx,
-				struct notifier_block *atomic_nb,
 				struct notifier_block *blocking_nb)
 {
 }
diff --git a/net/bridge/br.c b/net/bridge/br.c
index d3a32c6813e0..ef92f57b14e6 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -222,7 +222,7 @@ static int br_switchdev_blocking_event(struct notifier_block *nb,
 		b = &brport_info->brport;
 
 		err = br_switchdev_port_offload(p, b->dev, b->ctx,
-						b->atomic_nb, b->blocking_nb,
+						b->blocking_nb,
 						b->tx_fwd_offload, extack);
 		err = notifier_from_errno(err);
 		break;
@@ -230,8 +230,7 @@ static int br_switchdev_blocking_event(struct notifier_block *nb,
 		brport_info = ptr;
 		b = &brport_info->brport;
 
-		br_switchdev_port_unoffload(p, b->ctx, b->atomic_nb,
-					    b->blocking_nb);
+		br_switchdev_port_unoffload(p, b->ctx, b->blocking_nb);
 		break;
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 21b292eb2b3e..a7ea4ef0d9e3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1948,13 +1948,11 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 #ifdef CONFIG_NET_SWITCHDEV
 int br_switchdev_port_offload(struct net_bridge_port *p,
 			      struct net_device *dev, const void *ctx,
-			      struct notifier_block *atomic_nb,
 			      struct notifier_block *blocking_nb,
 			      bool tx_fwd_offload,
 			      struct netlink_ext_ack *extack);
 
 void br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
-				 struct notifier_block *atomic_nb,
 				 struct notifier_block *blocking_nb);
 
 bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb);
@@ -1988,7 +1986,6 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 static inline int
 br_switchdev_port_offload(struct net_bridge_port *p,
 			  struct net_device *dev, const void *ctx,
-			  struct notifier_block *atomic_nb,
 			  struct notifier_block *blocking_nb,
 			  bool tx_fwd_offload,
 			  struct netlink_ext_ack *extack)
@@ -1998,7 +1995,6 @@ br_switchdev_port_offload(struct net_bridge_port *p,
 
 static inline void
 br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
-			    struct notifier_block *atomic_nb,
 			    struct notifier_block *blocking_nb)
 {
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index cd413b010567..8ff0d2d341d7 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -269,7 +269,6 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 }
 
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
-				   struct notifier_block *atomic_nb,
 				   struct notifier_block *blocking_nb,
 				   struct netlink_ext_ack *extack)
 {
@@ -294,7 +293,6 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 
 static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 				      const void *ctx,
-				      struct notifier_block *atomic_nb,
 				      struct notifier_block *blocking_nb)
 {
 	struct net_device *br_dev = p->br->dev;
@@ -312,7 +310,6 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
  */
 int br_switchdev_port_offload(struct net_bridge_port *p,
 			      struct net_device *dev, const void *ctx,
-			      struct notifier_block *atomic_nb,
 			      struct notifier_block *blocking_nb,
 			      bool tx_fwd_offload,
 			      struct netlink_ext_ack *extack)
@@ -328,7 +325,7 @@ int br_switchdev_port_offload(struct net_bridge_port *p,
 	if (err)
 		return err;
 
-	err = nbp_switchdev_sync_objs(p, ctx, atomic_nb, blocking_nb, extack);
+	err = nbp_switchdev_sync_objs(p, ctx, blocking_nb, extack);
 	if (err)
 		goto out_switchdev_del;
 
@@ -341,10 +338,9 @@ int br_switchdev_port_offload(struct net_bridge_port *p,
 }
 
 void br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
-				 struct notifier_block *atomic_nb,
 				 struct notifier_block *blocking_nb)
 {
-	nbp_switchdev_unsync_objs(p, ctx, atomic_nb, blocking_nb);
+	nbp_switchdev_unsync_objs(p, ctx, blocking_nb);
 
 	nbp_switchdev_del(p);
 }
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3ef55bd6eb40..270624e88358 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -380,7 +380,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 							dp->bridge_num);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
-					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
 					    tx_fwd_offload, extack);
 	if (err)
@@ -394,7 +393,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 
 out_rollback_unoffload:
 	switchdev_bridge_port_unoffload(brport_dev, dp,
-					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
@@ -408,7 +406,6 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 
 	switchdev_bridge_port_unoffload(brport_dev, dp,
-					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
 }
 
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index c34c6abceec6..d09e8e9df5b6 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -859,7 +859,6 @@ EXPORT_SYMBOL_GPL(switchdev_handle_port_attr_set);
 
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
-				  struct notifier_block *atomic_nb,
 				  struct notifier_block *blocking_nb,
 				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack)
@@ -868,7 +867,6 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 		.brport = {
 			.dev = dev,
 			.ctx = ctx,
-			.atomic_nb = atomic_nb,
 			.blocking_nb = blocking_nb,
 			.tx_fwd_offload = tx_fwd_offload,
 		},
@@ -886,13 +884,11 @@ EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
 
 void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 				     const void *ctx,
-				     struct notifier_block *atomic_nb,
 				     struct notifier_block *blocking_nb)
 {
 	struct switchdev_notifier_brport_info brport_info = {
 		.brport = {
 			.ctx = ctx,
-			.atomic_nb = atomic_nb,
 			.blocking_nb = blocking_nb,
 		},
 	};
-- 
2.25.1

