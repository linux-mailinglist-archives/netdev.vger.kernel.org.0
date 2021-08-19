Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FD63F1D78
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhHSQIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:08:44 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:63108
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233935AbhHSQIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:08:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCm/MvOL0v4WceD4ZIIGfUHZVqLWGg8h8RJF6RfP6lxIBOzaObGTCWB3e7b1NN+apVUcbD+2xA29UjgZ41ILT5lBJq33VvVyq4JXtt4uUENIGLD4FFfCCDqWcDh5wPdt4TQdVbgbMnyqptOzIqJDbboeyAHj6kulRdtKCzvP7k986pUUZO+PcW/Pyr6RW74Coc907elFLa0fI/SiOG0ee/FK/ZzNV2CYiu4KsBdmSdtBEjyL4i0zsoNeLxQBWwo9/7IZwW1DGF+81FDPFBkUPQpI4nQn2trKkE+JB7zlGxsFBXOe+kJxYWAyPNYC+H1mx2BMACyApcO7CsZsDVcDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9AznfdhQEAPGf+0tViJjiFQFMYmqSm7XmD/DoIL8Mg=;
 b=LW+oiXJ0+oYr/ev7Pl+wfG3EukwkujFB1yTIYnFFs8KscnxrKTSEgD37bdSiI4bJ7EWkFgRjmhmfQEUUdR2vnPmfuU+igtFlcQ+Uy9ZHCUaSduzO8rZEgZYCc7ewoBKf1hV56BwOs0FN9XOQs9EfUJHkUadi0NZ3yMO5dnTLKpUwrHE6KRPUILDSF+A2mDx+X6T0hyWBdDb7XIjV5r94X92bYC+YjA3UeowW9v7273rJVEMQnCspsHmR4fWC0+SUw1AN5qPkuBn2BimW/1zaU7cU3/9DPDJRFCjJ0LvWmPYLAeH+UrXVWCTLUxMfqq3ZZMotlyV6mndN3abr+TMupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9AznfdhQEAPGf+0tViJjiFQFMYmqSm7XmD/DoIL8Mg=;
 b=EY2PKT8O6JU3kTWxkSIX9698DvwgAgKHyNWKm/v2Enx2SLKAuhAmPOcrBOxMqYUa7cFFnnSRZA+rcLGgIn0Va8ev2atI1orCv/bbHXBSaCM1rmAJ5yLhsldI1x5z9YlM2YL/fibp4XqfxHNiTFha8dmdH3GUbAi1rlX9oJYmm/A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Thu, 19 Aug
 2021 16:07:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:07:59 +0000
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net-next 3/5] net: switchdev: drop the atomic notifier block from switchdev_bridge_port_{,un}offload
Date:   Thu, 19 Aug 2021 19:07:21 +0300
Message-Id: <20210819160723.2186424-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P189CA0004.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:07:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee24cdb6-f9a2-4293-83d6-08d9632b8399
X-MS-TrafficTypeDiagnostic: VI1PR04MB6944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69440900869E686BDBCF174CE0C09@VI1PR04MB6944.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRzX2gaL4ubDDqtpfiwGZfPP2V0+E4arLd7x+KS7mqLNc1g+LKBmZXKEbYpehvBak6EdUN2T0EdisxmmhEgXrwpAD+DNtht9OlkwKNVaKiPlKLOYzpLYaP4CYJIeSEa+yX4w7RBv7r9ZdXMztFy5v98juZAi6z8tobYdEhXn71IKB5SVshrqKiZW5WrH1KoTR4LOnPFcAiKQ3zoqbpdF8hILI6eXmFRU6lIQBI6t0Mi8TokprN8lUH+Mwj05HdycrL3xw7chJgjp7qV3HakN4Tgm2RUDswF5oYBgb/6VMpett7mf0wl5552IkoPLHMZSbk+aTW/cN99ykXJeVK45qo7UZFWZKpDGvngQtQ2j4oZrhMeauCoHuJ6ozBjna9AWNLQpBBwM+Ds8IYtoP/4aR1C3fTfVDb2zdQy4ADrFn0s1gsmoMAwblaUl8pFS6svtL28DuQbCHZJKGZxf3dDq/AMlUowu/0eYQ/jIsGtldTPZPowwe0Wam8WI3bsuBaekg3zbhvNYJ9l6ynZJfK9CpXRNXTWaIpRuhCTlsOB1VwcUyGGiTHZFEp0kswS3njMIddKKaS0K0vGwwL/qvWcYtohCd+DSojsdc5g/dbfqvEF3LYhZQAAEUA2Y3rhvBXSeq0G28F3dqV9uvvS8trZUMc7h85kIuDWafwNrscpx7+Ax3OlJehP7o3Tt9rz0e2OU/AUvgnXMUdFHmWfTgvBd8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(346002)(396003)(366004)(136003)(6486002)(66556008)(44832011)(1076003)(66476007)(6512007)(86362001)(66946007)(2616005)(5660300002)(6666004)(6506007)(186003)(36756003)(26005)(38100700002)(38350700002)(316002)(7406005)(83380400001)(7416002)(54906003)(8676002)(478600001)(30864003)(52116002)(4326008)(8936002)(2906002)(956004)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3fbuSqIUuqY7EZ1vnxOaE9IItD4PiHIefBBHkzO+UqHzInchzkon4BmIH5j6?=
 =?us-ascii?Q?ozpaEiSxAfncuNqcoYaI+mzMxloc5wpUom4SzzILah2FmQ7g7CDLZbSP7oUK?=
 =?us-ascii?Q?g4LaWRzw29rn6wDleRyFKcziYzExjLJ9yBXjyPu6lW51CWF55IPR2y1ts4mj?=
 =?us-ascii?Q?JiLOl83nCKtPWSCSZL+6IZSDc0+4vK4zxNSF9elJu94h/jC3fwLtbO6T8hR3?=
 =?us-ascii?Q?IE4hPu7G/OwYR9Ww7rxientBPqjU6Otv8rLk8VtytVF4gFRpmLP6F2mw1iA5?=
 =?us-ascii?Q?ZMUQht5OuJG+arivOQ+ywEU/Z1yq0Q6om6svC14wNTmb+IfvRmEGDkBsUC71?=
 =?us-ascii?Q?Lvfmnm5K0Dcy/oVUKAZoSg04EmWN0acxaBx1FW/Z1s/NzKrQQvHp0hVSa+le?=
 =?us-ascii?Q?sHXbyqpXUn+8Kmop5OSPwMe5Um+VqJ9+C7xXDLK2Nwfxqz3osEJ+tSR8JslX?=
 =?us-ascii?Q?LE/QBOVeQwxuB7yZZgVl1aSdlKu6zyCCURa49EjxxqECQMD1FRc0miC8pmVX?=
 =?us-ascii?Q?2c2p3jiOFsbvKez4394pMVMwhaYinONlp6+JW64UndEr4umxIe4yWd5zq12E?=
 =?us-ascii?Q?edKyThev9wq2v9FR3lyoz6V+Kd/+duHW+FcgjV2pA0HLLEjHUesCt+rEPfd8?=
 =?us-ascii?Q?pzCaTaUNyO4jGIVkDrSSnJ0+WCLS32a+ovcli5M6Sjk4M8Rd6PXoqj2pJOOa?=
 =?us-ascii?Q?5AjgCkC5ApKjFf+IW2r3qqnvQz7iDUf5PmWVjjaJ33MvukbzKJPhrG/ocjjJ?=
 =?us-ascii?Q?Rg6Q+yX8pY5YYVxW+jUsBeiSQksme9dKQHEJedtNK0JoLogwKf3ZGtgQ0d8Q?=
 =?us-ascii?Q?y27l1HAeiWaW01cHEtKgQ8enhk2mPVEUs8xRK55a8EqrQoRNM4yRbr/vZK+f?=
 =?us-ascii?Q?LQifZUeN+cJ/wfqz1EvaA93pavcwzj4u9wU6UrjGmdufm1jdfr+UUXhFHys1?=
 =?us-ascii?Q?JEt9rfav61VKa31nrJHnNg9GC8NRW4B69w9dQQvwumbsyUmhy2dAaXUc5pNU?=
 =?us-ascii?Q?vkNxpmxxHPotfXZbPVgO+ElWnRUQRctAL3iaaqqmUGL9gF9TtULWyhqU2DhB?=
 =?us-ascii?Q?l+lvnHLp9ZpJCsjhhLY9oMKsInV/noVymirrpAdPKZ1iYB5t91Ce/bKZGuXY?=
 =?us-ascii?Q?NBNzWN/VZK0OqC6nm+Yr0ZijkKswvxjG1RiOk90TogW3e+2vU6IneAQwnbuB?=
 =?us-ascii?Q?KTxfIs8jkv/JD8jx4qHDLB0NL7eC/aZDkFSA6fUC73E3thxmRP4L8/LHCrpE?=
 =?us-ascii?Q?yjzo/Aoe/qQ01c0taGqBHGh/NDsExD1LjHYT69hsj1Ve+iXhiHoA1KuAyXhC?=
 =?us-ascii?Q?S++/KFxyeKF+EpiD6Vyk9dBP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee24cdb6-f9a2-4293-83d6-08d9632b8399
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:07:59.6503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEUQgmB8+ZiAGt5MBnCRenDpuiRM1wt+ADkTGOdRTOil1u+mUo8QL1Br/llO7nf2prLDASMaSSAwonc8suot4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
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
index 9b8847aa3b92..fb0fa782a5ff 100644
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
index 5d9ae1ec85b3..b433432c4ef8 100644
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
index 979042a64d1a..30071da45403 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -375,7 +375,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
-					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
 					    tx_fwd_offload, extack);
 	if (err)
@@ -389,7 +388,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 
 out_rollback_unoffload:
 	switchdev_bridge_port_unoffload(brport_dev, dp,
-					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
@@ -403,7 +401,6 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
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

