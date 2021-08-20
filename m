Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265E13F2BA5
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbhHTL7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:59:00 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:24941
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239997AbhHTL6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:58:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8N02FXOzByW9XsVYjE240vhqhN4vrXUQt5wwsFcKqkJOg0WDVxdMP6/BQ1qUqwRW9IlPUNmmndygxXYT9wxMsGTXajFTFfpN0D0YwXCbuBaDtOGkg5a/RK195yP6JdcCYLjNjCL9YnKvPU6jXSxKpu80b+9UYDWxjiSiDR/M8H86OxqRYV/aBrdj+a3UEFSVN3cah4tD5ZIiTvp4N5btj5x9XsIoaRHmd6X9zJRCsuWYHg+Scr3TOFbP6/ifU62GGozTkWjbphlTg1EJM+hdKo5/TKeDlNR/apabWeXJ9VEiXh4GW1Oh3KKwXpQ81lJAUnYq0JfTbnQCCXLNlT/Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aJqu6u/UZewrkImwycUMT8plxn8G27ySqfvO+skJ0g=;
 b=lrO+0lYegJMz+zG+aQby6haImnD1HGvWnDAWdgpJkBmLFLDfNcz4aE416dlBl2VSQwnQ/cQAcg9OwLHMSabOjCJ/pw8jqWFL94YiJwVOAYplgRkz8Nfa6EtdL4ErZQgHG7nmKgPNGp7OFVihdWXRUPGDmY10C4/BT3SxlBlzDWlsVezXWxdRCrBMXVGj7oiuahlVv5/76eVuArtkqM3j7z00aqpQosRWlF6b1yu4M4kqeW0/yHOOvmFCSQ6JXzO9ak7Cny3RVORnl82Zq4b9XXHyJm5PlRI4uXZTxVR3lNqO9YUaKeK0eDrz7ROp7yJkAvYTk/r7ZwzRtPvHmo/3OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aJqu6u/UZewrkImwycUMT8plxn8G27ySqfvO+skJ0g=;
 b=HYpdSS7lVqLP7xlFd4eROIEQYIUtKRGc1f1A2e3SsdMlpPJs3eRnyfID0AKK+ED0YKbPwDVZSCVpFqWB8tMuzI3NNHWTdCiHAlDRQDsKmwYp50DHjNsPnPaKMyuXLkt/ZHBmRlylC6WTMAnB28oa7g2E4CFyB3inNvLeO1bRYNY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:58:16 +0000
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
        Alexandra Winter <wintera@linux.ibm.com>,
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
        linux-s390@vger.kernel.org
Subject: [PATCH v3 net-next 5/7] net: switchdev: drop the atomic notifier block from switchdev_bridge_port_{,un}offload
Date:   Fri, 20 Aug 2021 14:57:44 +0300
Message-Id: <20210820115746.3701811-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0010.eurprd04.prod.outlook.com
 (2603:10a6:208:122::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:58:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18ed7d0f-c81e-45ae-4c22-08d963d1cb13
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839342BC3EA65B74C66A90BE0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJD3ZWhm7uFpYevGD9VXz0ys4hZAv/V7oqu8hnLyq2Y1ts2f3qzV6bwXvVEeSAxR2vnUyxwae+EjuseYJE2HjbIwaDTI2ked5jhSiUpR3zNiHOMExtRCft70kkQ8hZY7UQywfvYgndLcFiOjDLybNZ3GoD5dQcm9pz4eWlYG4LlibGTjPL/vK+PUmh0c0nCoYSrResv5Y0fbGNzQ728TkQk0L1lxUSyM97WWZL6SJz6yrdi2KUw8FAok9GTbLqfkKjCQTdLhMAeu7R+ay0Zh4oInLFBZvXz+8YH6XF+POlqJqUf0RyaTvb5zLY3RrKOOw/HvYrxx/bD0aC+qOe0qzMLULhikvzw9PV80yKZ4PTJw5k1Um/WXmz0D06YPiV/NpFiz13B2YvTF/geBhW4UIr5BULjtY0dKnftuXd/1k2EXzhPICfG5L6tiKCw1iiB+om6l84wiZwHz3MjHwfDrBDJLtB0AzdHwJD+N7JHoLQExsEQ0aHNQ5t5jLv4yobvAukpPk9cmzHufYaOZEJtYvirtlRaQ9OXHd7TRxhvw6sY3h51uV6dX1zDjkijnzQPMMUAKKOdBCNqD0oIVzMtMduVU1PzER+os9MGb1Tqf4SFa6UwmObZucnNSsFyensrcxkqXOF2eBtN4Q61TJ27Ze8aqvempmVXeL0FsPbWhZdeSiXhYJy3qRzKXj1ETz5iPBJK2hyLmeh4vjv7wJc8HlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(30864003)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?znJsrbpiDzTINWTzQ6w9He0RKwe+usjuRSHHhUequmFJWdtIf2NIIJ/JTn/c?=
 =?us-ascii?Q?Ab+XNEbrHCfdvlCEaBhlNIFC9ZEEQUVcMaS4khXwWn2MwDuTbSzAF90qfcMY?=
 =?us-ascii?Q?GjfPgcWFns2h1cACTyeJoNN38oV7PwUMuodVOMyG99nMAaCXxJS0p9sZo9Ed?=
 =?us-ascii?Q?vchjD3eBxDaMh5/NXH8ozPPCngvoboEpkUxZEB3KtwXMKvQQ7NbjVIIVN6t5?=
 =?us-ascii?Q?RGLQKWEB/Ta7qNTmCu2hdYvrJb8kuK8w++A1kUd/ABWA+qA85zf/8H6neLAX?=
 =?us-ascii?Q?0339s49hjxGOeSZZIuvspx8vUpTxmfVUj+TmfTuNPQVdhnBTMwu0XmaQvW1d?=
 =?us-ascii?Q?/q7XgpsC3fdPjI0szGKjSUyvVjYmn5WzKDsgnRKTrwKuchzV4jx2WmySvV2i?=
 =?us-ascii?Q?ru9MjmCzNLXvdwa0RIUgC5dKHLPGC07Y0ORMBzoAPi1cf3wGOqXOnHcFGndk?=
 =?us-ascii?Q?HIvrSogp19IN7cd4+NDOrjAEQA373SJ+NSYyAsJKOZ7T+8cFdDosiWLAbY9M?=
 =?us-ascii?Q?P535oKEczHDq3SWQmU+YFOvWeeOXuNnqs9qpm5v0GVgnMELz2qFOv4Nw7xx+?=
 =?us-ascii?Q?XfJFUt016CKpuZNxRZVL1SVEoO7X9p/f3CxMiH3DJnHhkZdJWo8vQHIQkIiY?=
 =?us-ascii?Q?hNOBZGYdbjruPPwm430DxqFMPtXIeJDrHmA/1wc8gdKW9BO7U/Mbrtlo0Zyn?=
 =?us-ascii?Q?iF9n3JSNUgw05RVWD6GbKIUj7KpHjpEns8ax+9Dhget3I2YHrJQm+O+vaEZ2?=
 =?us-ascii?Q?6oJvl3xF653xzl/84h6oG6Or6GNzPIyPstyzLKzBEuzQ2Rx5BFq/IaZgzpO5?=
 =?us-ascii?Q?cYd/9/S94Rix8pBkRPQ/r1xLXqDxIR/qgg3udmBGKeYnuqmWHsFQ/UJilS/Z?=
 =?us-ascii?Q?fKe3X5/Ak2OsleJ/mhrJi6FTKHkxdJUoqSZQauyoq1rTn+RdPD0K5FXEAN+x?=
 =?us-ascii?Q?bmO55zmMU846nwoKWd/pJylbQfwNN6mn0JTGf4XG2q2asYDONDMFaOAdM8l/?=
 =?us-ascii?Q?j+UtEBN7nFZ3IJuUc4iwDySyGZjdNDFzocg+Mq9d9D0TWfFPMHx+rlh5PDvW?=
 =?us-ascii?Q?8g0RtVU5n/4p+s6JJ9e6YmhKaqVYutkhUBoqxh/RE4amE5e8VKsQN0B3hosI?=
 =?us-ascii?Q?vATTeYOUdCjMfR0PauwVHT7uhjzULiqhdMrKYULaKxYb1ZDri159ZM61D4G5?=
 =?us-ascii?Q?/ddRj1bIALO9grTvpcfocUW66kJWocs/Tq0+DZTBxTdGzq9pzzgxvaYHwKPI?=
 =?us-ascii?Q?GvMbFFK3DMbnsNjUzatcSAZJ14bqrLRm+iVWojScZjuyJl3O0jsvsxNDlG1R?=
 =?us-ascii?Q?0HUyIJzjNjTQSUK3k8YJ7qkE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ed7d0f-c81e-45ae-4c22-08d963d1cb13
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:58:15.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3nlSHr22MN+hlJnMfvLp31DzrHyTuwFW0RjLl1QGposXmvA/n8yD24FcX225YfDgKRuajVZMIscjhqR7p+mrxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that br_fdb_replay() uses the blocking_nb, there is no point in
passing the atomic nb anymore.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none

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
index d0d63da7f01f..f6fec0e7590c 100644
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
index a89cda394685..5a9f26d5ddd6 100644
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
index fbaed9de3929..589563a93cf2 100644
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
index 0d19f2be0895..dbc2a5560004 100644
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
index abdb4b49add1..5790180fee07 100644
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
index 5570df4d9b76..f6f200b77986 100644
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
@@ -265,13 +264,11 @@ switchdev_fdb_is_dynamically_learned(const struct switchdev_notifier_fdb_info *f
 
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
@@ -354,7 +351,6 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 static inline int
 switchdev_bridge_port_offload(struct net_device *brport_dev,
 			      struct net_device *dev, const void *ctx,
-			      struct notifier_block *atomic_nb,
 			      struct notifier_block *blocking_nb,
 			      bool tx_fwd_offload,
 			      struct netlink_ext_ack *extack)
@@ -365,7 +361,6 @@ switchdev_bridge_port_offload(struct net_device *brport_dev,
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
index 390c807d1c7c..0320fe816a97 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1946,13 +1946,11 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
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
@@ -1986,7 +1984,6 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 static inline int
 br_switchdev_port_offload(struct net_bridge_port *p,
 			  struct net_device *dev, const void *ctx,
-			  struct notifier_block *atomic_nb,
 			  struct notifier_block *blocking_nb,
 			  bool tx_fwd_offload,
 			  struct netlink_ext_ack *extack)
@@ -1996,7 +1993,6 @@ br_switchdev_port_offload(struct net_bridge_port *p,
 
 static inline void
 br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
-			    struct notifier_block *atomic_nb,
 			    struct notifier_block *blocking_nb)
 {
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f2cb066e3ebb..659793fcb4ed 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -361,7 +361,6 @@ static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
 }
 
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
-				   struct notifier_block *atomic_nb,
 				   struct notifier_block *blocking_nb,
 				   struct netlink_ext_ack *extack)
 {
@@ -386,7 +385,6 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 
 static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 				      const void *ctx,
-				      struct notifier_block *atomic_nb,
 				      struct notifier_block *blocking_nb)
 {
 	struct net_device *br_dev = p->br->dev;
@@ -404,7 +402,6 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
  */
 int br_switchdev_port_offload(struct net_bridge_port *p,
 			      struct net_device *dev, const void *ctx,
-			      struct notifier_block *atomic_nb,
 			      struct notifier_block *blocking_nb,
 			      bool tx_fwd_offload,
 			      struct netlink_ext_ack *extack)
@@ -420,7 +417,7 @@ int br_switchdev_port_offload(struct net_bridge_port *p,
 	if (err)
 		return err;
 
-	err = nbp_switchdev_sync_objs(p, ctx, atomic_nb, blocking_nb, extack);
+	err = nbp_switchdev_sync_objs(p, ctx, blocking_nb, extack);
 	if (err)
 		goto out_switchdev_del;
 
@@ -433,10 +430,9 @@ int br_switchdev_port_offload(struct net_bridge_port *p,
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

