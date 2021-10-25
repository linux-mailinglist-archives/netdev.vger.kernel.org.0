Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA343A679
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhJYW1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:19 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233759AbhJYW1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPTqMmmYa0Ofm69V1YnLMTKTpPgYmR99dYNh2+0lRkxltY0rtk6JC1PtZPNOVgTfpLLrpjTUZ3EEMLLDaUDLJ7OhWAjDxHpKUILZfjgnw0CvzBAA51pAjMgfjoTLy40gVT+BQfpJ3wo133ezY3ZpSAhUf72pHwFJYUwQ2IFCnk4smibpaPavY25v7kbUw156zX3O3CqmwrjGgdl9l5yqyXQI9V9gMA1gM1FKxpPWcf4brzj94+yKO++NbpL5lcYoMB2BFHPfROWGyp56pECWvz+6Kg2Gx0LBIBO1nKYzbiDmBaDuoAsHYQ2p7whDDGLJJeW9ff/DCJ3vBD6DPNYHeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeNpS8eyZD+/vmQm61bG+M1KOH5zupVCvOrHfaqByiM=;
 b=kf8ivVeycKgdq3mhpuJ0fcmeP2IcRT6stFwCX6Ac44/bkYo728Xcd1Ag770Cx5tK8aqunDqLyJMhynroVdperYy1NoS06TuLIjoQoYEAirhhCXvBHxR+Gas5HrCdg0zNBz+HSxnqGD+/Fzjno9ZqPx7nqTG9MX37gBAGV5yayIRtcMYQJSNnpRv+YVdqHYulTWJN7XMfVQNY3C99a9rw0C/zyXL1ogRHsAcY8M/caedLPRNAFRvYkL2+ax5Eq72CB09Pz+v0NIUQIoIBEfk82xb2uK1NgehwCw7677xJ/Wae/LpgvmS5f4HH9naukMBIEGqDPgD8hapSBhFIaR8Yjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeNpS8eyZD+/vmQm61bG+M1KOH5zupVCvOrHfaqByiM=;
 b=CCYBVtXX47PfvnBYCySvBygXf3dl3UBXO0YGldISz9M2wAf8tXiQT4Q5PuC3XJJ06n85T1nhuRpadfvjutdXOg3wHcSUXfZYBie0GC4FE22/caWqK2p7ADMgijsOe6im25MJP9Xo+3PX0g0Fv1SSJKMLcd2LSbc9Dz1On+rnmkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 07/15] net: switchdev: keep the MAC address by value in struct switchdev_notifier_fdb_info
Date:   Tue, 26 Oct 2021 01:24:07 +0300
Message-Id: <20211025222415.983883-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 212ae59c-0207-44ac-4fd2-08d998063b35
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2304FBB44BFC853C282A9F0EE0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T6NlQbBtRLHnhekoq2kRgElwvIWxIAw/BcNyfgqBpsiMq5fYE20wROm5YLT7EpzFhMD0n8H2NGFNH1wK+SSe7uAh9RdhgzTDQQebtNN8I1iJCErNzsaxQE3s3gQuIQpr1jjpKrxtqh0vK3S87J0wXn/XI/baUExVwwGkCIqgmXEWrA29dj8dYgR/MtRaq79PLdoygcSDfRyzRa3webhGiUz3wW0xEpXIIoisZLT+4lHmSWXMU2tw3rBDNHEpzphkn8sUpAofsfUJ9ogeCv/4Xecy8PRXRh9tKxs8Jp82Un/2YlE+xJdi/zC3ctV3MpDL5qbJSpX63DkupLk+IZd9oTIdclT0nbUXOEdH0/G7Yf9fVTKgpPJtn7tOdtTQA3S2QxfGj5tE2QBlXq2aN0lR7X7W3HhH+N9HDP+1JZ4sVvBYY7OdkDwXOn1pSer/SvcK+2WXkbvpdXRm0nyVSsyw5tzLb2QJsHHyEhtrxQvdoLbeMQ/XzOXXOYY7xPfS/wGIXJrTl/jjAyLu/rqDplf3x8YxKW1ahpCf2SX23UScdHzePVaFCnJ9MnEo3s3L32e7oy2B51Qywmbgb6mZKuABHJBKKcip0AjBi5abQWUFEI7ANJ3fJhhKwxatcwXUW55TT7g6vlif1as0zvMv7+i0cBvGp1HVB3sXms24bg2xS9Q2BcfYhH+KGOYXkmIDrfACpZJDu1Z9AMwQUd7ALsq0Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(66574015)(30864003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2TKvzwuQ01SmgpNe9ckhLDyu7hHsHisOl8o+Bp+RkVBgiaq4x52RyT0/oryH?=
 =?us-ascii?Q?5M5dC464GQD6yTpzEhMxesGDSG+y0dXp4EcMt19AYFrUybP1UO7Kwn/ToUxk?=
 =?us-ascii?Q?ruWcCULkgS6Yo/QTAA4uytcHmDh0jg9lW7IfhpeGhzORMiv8NKz58b+nnvLG?=
 =?us-ascii?Q?SfSZNnmeelWEfnZ2/hp6KqSmyb66yV4PF8o5sle7FA/OIQxpKWE9ypynMsNL?=
 =?us-ascii?Q?xLpvs/x0lnfS0zjQ5sNiREm5UXCPNckJfddLGNBwbf9WpAluZBEdLiaCXE49?=
 =?us-ascii?Q?ROm856T+L88kSr6qKVh7+c3HyOEZqp4Z5wWK14ZU6Br8YQKatNT0vgaCu/rv?=
 =?us-ascii?Q?8sV8G9JWn4sqCZquRblmIEj9L4zcE7KXTBmgztDrXVbRG1AhiPKgcBTum3kZ?=
 =?us-ascii?Q?AMOTc/Ks4k4lRh6o2xjtGqV6ec7Vgr1dw9NFjnv+xbcvzBxWvvLBNwvgvVyj?=
 =?us-ascii?Q?ukS3N+Qp3xI6EdtLtYEF6mMGnW6xvXKbEqLF0qcpgmo2GBV7Cinyy8RYpLGL?=
 =?us-ascii?Q?l0GUsLjua6rBkak+vbkLozyd7AXGJRQUqd4HAKbBq979ms/AADstoVZk3tva?=
 =?us-ascii?Q?RkAvhYiLy5Ygz1ktR0w78xnlCYMyKDSkHuRwIZU0pgZelQ+vZagTXhuE87e1?=
 =?us-ascii?Q?qyrgND1k3w7bmzTeAxQkYzfhEdV+Vyz0bjthBijYzC7Ix28TW5CVyElSwZt2?=
 =?us-ascii?Q?ROGcxCm4J5rOai0uDtDYqYNsBgYfZmYJAEdEUtAJfUwUDXhq1iB9GakJV0Fi?=
 =?us-ascii?Q?W4gJ9qxpkTuERWro4Lpk2t2b2gpYW0TP5Nh+gp6M0UuqTFoi6i9ANSj3vAr4?=
 =?us-ascii?Q?uJNv/vh4xAePosei4nA0/3Gwf0I9wf234yDnOi38L1enC3PSd3ryj4D31Jg+?=
 =?us-ascii?Q?tkmnNR9b7LEDDt6AcaWEF+2r0svLnhWUx2Qe2U71pQycjbDGQGhb6rHCHjth?=
 =?us-ascii?Q?/xvf53Z0FmKxzThPf5yNgNv1EQ8O8P3NjFnem2WHkQ+FwGv1QRoctTqOJzlg?=
 =?us-ascii?Q?BsK65aoZJBNWWdwIcHGsY72FxhTuNzxMpLz1BANh0blvWse3ts3eLaw9sCFW?=
 =?us-ascii?Q?7Q4ZKDtMK8Un2POLiYuWXdjBasMzXX/bM4VeR3uravZPB4DzSq8Kp5oz6TJy?=
 =?us-ascii?Q?JqwCpXbO1QWV6mSVnZKV7eDuIt2nTM2uDdROM+2OTvOTUpQ4AikpDDFZsO8Z?=
 =?us-ascii?Q?l4i/R3vOAQ7ej99YPSD35o9DO9Qvj18VzM8zuvFq+ymfHvc54km4qoAWE3Ej?=
 =?us-ascii?Q?dTr0EG9u3yblBbzsX6vhKpCSziVDvbYtGZ0gxlTQ8bX2Uzd7JpT0vX8Zv24p?=
 =?us-ascii?Q?b2XFMDdYQHFynScKyqcGcAfkjV12rZ9LSWulYdCS1w/r9KxsusLhmzmVZsKl?=
 =?us-ascii?Q?wc5tfofEDYSSdU4Y7ygyXukRwxEbEwiHZbGQOzo78zmVfyVTrgO/yLATnMHE?=
 =?us-ascii?Q?tUyBzn2PiIa2w76KYdz5pRtDOtCl57YBMXdOlvws/aFiFjTEhVGAcsfmsAV/?=
 =?us-ascii?Q?0IjM3Gq0PBQcqLfebSG/Tb98McZ6HCwzQrPl9mYdOym3iZ7GpTByyJ6Fy/oZ?=
 =?us-ascii?Q?I3mAi4tsOShmMDZIfDBzvmQp6EWUkXYqVTT6+ik7WmaOu/3J759WbcnhZKWa?=
 =?us-ascii?Q?SyZO9aSbOHf9lrMNYpvsKOI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212ae59c-0207-44ac-4fd2-08d998063b35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:38.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwFsaJwdexQiOUXW7JBR5eVBvmFSP7wmIpaaEoAB8YNNvMnf1XmjqMw6FepIlxXKEJwT2G1iIQrKQxDL2l5Uxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, shallow copies of struct switchdev_notifier_fdb_info cannot
be carried around, since the "addr" member points to bridge memory.
This complicates driver implementations because they need to explicitly
allocate a separate piece of memory for the address.

Replace the pointer with a 6-byte size array and simplify driver
handling. This makes the structure safely copyable, which in turn eases
some of the future changes (having a similar API between
switchdev_fdb_mark_pending and switchdev_fdb_mark_done).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c    | 14 +-------------
 .../marvell/prestera/prestera_switchdev.c      | 18 +++---------------
 .../mellanox/mlx5/core/en/rep/bridge.c         | 10 ----------
 .../ethernet/mellanox/mlx5/core/esw/bridge.c   |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c  |  4 ++--
 .../mellanox/mlxsw/spectrum_switchdev.c        | 11 ++---------
 .../microchip/sparx5/sparx5_mactable.c         |  2 +-
 .../microchip/sparx5/sparx5_switchdev.c        | 12 +-----------
 drivers/net/ethernet/rocker/rocker_main.c      | 13 ++-----------
 drivers/net/ethernet/rocker/rocker_ofdpa.c     |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c  | 14 ++------------
 drivers/net/ethernet/ti/cpsw_switchdev.c       | 14 ++------------
 drivers/s390/net/qeth_l2_main.c                | 11 ++++-------
 include/net/switchdev.h                        |  2 +-
 net/bridge/br_switchdev.c                      |  2 +-
 net/dsa/slave.c                                |  2 +-
 16 files changed, 25 insertions(+), 108 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d039457928b0..6190feb44219 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2246,7 +2246,6 @@ static void dpaa2_switch_event_work(struct work_struct *work)
 	}
 
 	rtnl_unlock();
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(dev);
 }
@@ -2278,15 +2277,8 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
+		memcpy(&switchdev_work->fdb_info, fdb_info,
 		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
-
 		/* Take a reference on the device to avoid being freed. */
 		dev_hold(dev);
 		break;
@@ -2298,10 +2290,6 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
 	queue_work(ethsw->workqueue, &switchdev_work->work);
 
 	return NOTIFY_DONE;
-
-err_addr_alloc:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static int dpaa2_switch_port_obj_event(unsigned long event,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3ce6ccd0f539..236b07c42df0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -760,7 +760,7 @@ prestera_fdb_offload_notify(struct prestera_port *port,
 {
 	struct switchdev_notifier_fdb_info send_info = {};
 
-	send_info.addr = info->addr;
+	ether_addr_copy(send_info.addr, info->addr);
 	send_info.vid = info->vid;
 	send_info.offloaded = true;
 
@@ -836,7 +836,6 @@ static void prestera_fdb_event_work(struct work_struct *work)
 out_unlock:
 	rtnl_unlock();
 
-	kfree(swdev_work->fdb_info.addr);
 	kfree(swdev_work);
 	dev_put(dev);
 }
@@ -883,15 +882,8 @@ static int prestera_switchdev_event(struct notifier_block *unused,
 					info);
 
 		INIT_WORK(&swdev_work->work, prestera_fdb_event_work);
-		memcpy(&swdev_work->fdb_info, ptr,
+		memcpy(&swdev_work->fdb_info, fdb_info,
 		       sizeof(swdev_work->fdb_info));
-
-		swdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!swdev_work->fdb_info.addr)
-			goto out_bad;
-
-		ether_addr_copy((u8 *)swdev_work->fdb_info.addr,
-				fdb_info->addr);
 		dev_hold(dev);
 		break;
 
@@ -902,10 +894,6 @@ static int prestera_switchdev_event(struct notifier_block *unused,
 
 	queue_work(swdev_wq, &swdev_work->work);
 	return NOTIFY_DONE;
-
-out_bad:
-	kfree(swdev_work);
-	return NOTIFY_BAD;
 }
 
 static int
@@ -1156,7 +1144,7 @@ static void prestera_fdb_event(struct prestera_switch *sw,
 	if (!dev)
 		return;
 
-	info.addr = evt->fdb_evt.data.mac;
+	ether_addr_copy(info.addr, evt->fdb_evt.data.mac);
 	info.vid = evt->fdb_evt.vid;
 	info.offloaded = true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index c6d2f8c78db7..d9735d817073 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -306,7 +306,6 @@ static void
 mlx5_esw_bridge_cleanup_switchdev_fdb_work(struct mlx5_bridge_switchdev_fdb_work *fdb_work)
 {
 	dev_put(fdb_work->dev);
-	kfree(fdb_work->fdb_info.addr);
 	kfree(fdb_work);
 }
 
@@ -345,7 +344,6 @@ mlx5_esw_bridge_init_switchdev_fdb_work(struct net_device *dev, bool add,
 					struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_bridge_switchdev_fdb_work *work;
-	u8 *addr;
 
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work)
@@ -354,14 +352,6 @@ mlx5_esw_bridge_init_switchdev_fdb_work(struct net_device *dev, bool add,
 	INIT_WORK(&work->work, mlx5_esw_bridge_switchdev_fdb_event_work);
 	memcpy(&work->fdb_info, fdb_info, sizeof(work->fdb_info));
 
-	addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-	if (!addr) {
-		kfree(work);
-		return ERR_PTR(-ENOMEM);
-	}
-	ether_addr_copy(addr, fdb_info->addr);
-	work->fdb_info.addr = addr;
-
 	dev_hold(dev);
 	work->dev = dev;
 	work->br_offloads = br_offloads;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 588622ba38c1..30584aad3021 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -77,7 +77,7 @@ mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *
 {
 	struct switchdev_notifier_fdb_info send_info = {};
 
-	send_info.addr = addr;
+	ether_addr_copy(send_info.addr, addr);
 	send_info.vid = vid;
 	send_info.offloaded = true;
 	call_switchdev_notifiers(val, dev, &send_info.info, NULL);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1e141b5944cd..54bd2b30eb8c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9216,7 +9216,7 @@ static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 	if (!dev)
 		return;
 
-	info.addr = mac;
+	ether_addr_copy(info.addr, mac);
 	info.vid = 0;
 	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
 				 NULL);
@@ -9267,7 +9267,7 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 	if (!dev)
 		return;
 
-	info.addr = mac;
+	ether_addr_copy(info.addr, mac);
 	info.vid = vid;
 	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
 				 NULL);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 81c7e8a7fcf5..2b66a6d8d8a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2519,7 +2519,7 @@ mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
 {
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = mac;
+	ether_addr_copy(info.addr, mac);
 	info.vid = vid;
 	info.offloaded = offloaded;
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
@@ -3010,7 +3010,6 @@ static void mlxsw_sp_switchdev_bridge_fdb_event_work(struct work_struct *work)
 
 out:
 	rtnl_unlock();
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(dev);
 }
@@ -3253,13 +3252,8 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
 					info);
 		INIT_WORK(&switchdev_work->work,
 			  mlxsw_sp_switchdev_bridge_fdb_event_work);
-		memcpy(&switchdev_work->fdb_info, ptr,
+		memcpy(&switchdev_work->fdb_info, fdb_info,
 		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
 		/* Take a reference on the device. This can be either
 		 * upper device containig mlxsw_sp_port or just a
 		 * mlxsw_sp_port
@@ -3286,7 +3280,6 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
 	return NOTIFY_DONE;
 
 err_vxlan_work_prepare:
-err_addr_alloc:
 	kfree(switchdev_work);
 	return NOTIFY_BAD;
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index 9a8e4f201eb1..3dcb6a887ea5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -279,7 +279,7 @@ static void sparx5_fdb_call_notifiers(enum switchdev_notifier_type type,
 {
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = mac;
+	ether_addr_copy(info.addr, mac);
 	info.vid = vid;
 	info.offloaded = offloaded;
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 649ca609884a..5c5eb557a19c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -254,7 +254,6 @@ static void sparx5_switchdev_bridge_fdb_event_work(struct work_struct *work)
 
 out:
 	rtnl_unlock();
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(dev);
 }
@@ -294,14 +293,8 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
 					info);
 		INIT_WORK(&switchdev_work->work,
 			  sparx5_switchdev_bridge_fdb_event_work);
-		memcpy(&switchdev_work->fdb_info, ptr,
+		memcpy(&switchdev_work->fdb_info, fdb_info,
 		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
 		dev_hold(dev);
 
 		sparx5_schedule_work(&switchdev_work->work);
@@ -309,9 +302,6 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
 	}
 
 	return NOTIFY_DONE;
-err_addr_alloc:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static void sparx5_sync_port_dev_addr(struct sparx5 *sparx5,
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index ba4062881eed..e5ab9f577808 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2720,7 +2720,7 @@ rocker_fdb_offload_notify(struct rocker_port *rocker_port,
 {
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = recv_info->addr;
+	ether_addr_copy(info.addr, recv_info->addr);
 	info.vid = recv_info->vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
@@ -2759,7 +2759,6 @@ static void rocker_switchdev_event_work(struct work_struct *work)
 	}
 	rtnl_unlock();
 
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(rocker_port->dev);
 }
@@ -2791,16 +2790,8 @@ static int rocker_switchdev_event(struct notifier_block *unused,
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
+		memcpy(&switchdev_work->fdb_info, fdb_info,
 		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (unlikely(!switchdev_work->fdb_info.addr)) {
-			kfree(switchdev_work);
-			return NOTIFY_BAD;
-		}
-
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
 		/* Take a reference on the rocker device */
 		dev_hold(dev);
 		break;
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 3e1ca7a8d029..abdb4b49add1 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1824,7 +1824,7 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
 	bool learned = (lw->flags & OFDPA_OP_FLAG_LEARNED);
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = lw->addr;
+	ether_addr_copy(info.addr, lw->addr);
 	info.vid = lw->vid;
 
 	rtnl_lock();
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 599708a3e81d..860214e1a8ca 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -360,7 +360,7 @@ static void am65_cpsw_fdb_offload_notify(struct net_device *ndev,
 {
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = rcv->addr;
+	ether_addr_copy(info.addr, rcv->addr);
 	info.vid = rcv->vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
@@ -414,7 +414,6 @@ static void am65_cpsw_switchdev_event_work(struct work_struct *work)
 	}
 	rtnl_unlock();
 
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(port->ndev);
 }
@@ -450,13 +449,8 @@ static int am65_cpsw_switchdev_event(struct notifier_block *unused,
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
+		memcpy(&switchdev_work->fdb_info, fdb_info,
 		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
 		dev_hold(ndev);
 		break;
 	default:
@@ -467,10 +461,6 @@ static int am65_cpsw_switchdev_event(struct notifier_block *unused,
 	queue_work(system_long_wq, &switchdev_work->work);
 
 	return NOTIFY_DONE;
-
-err_addr_alloc:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static struct notifier_block cpsw_switchdev_notifier = {
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index a7d97d429e06..786bb848ddeb 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -370,7 +370,7 @@ static void cpsw_fdb_offload_notify(struct net_device *ndev,
 {
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = rcv->addr;
+	ether_addr_copy(info.addr, rcv->addr);
 	info.vid = rcv->vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
@@ -424,7 +424,6 @@ static void cpsw_switchdev_event_work(struct work_struct *work)
 	}
 	rtnl_unlock();
 
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(priv->ndev);
 }
@@ -460,13 +459,8 @@ static int cpsw_switchdev_event(struct notifier_block *unused,
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
+		memcpy(&switchdev_work->fdb_info, fdb_info,
 		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
 		dev_hold(ndev);
 		break;
 	default:
@@ -477,10 +471,6 @@ static int cpsw_switchdev_event(struct notifier_block *unused,
 	queue_work(system_long_wq, &switchdev_work->work);
 
 	return NOTIFY_DONE;
-
-err_addr_alloc:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static struct notifier_block cpsw_switchdev_notifier = {
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 0347fc184786..deb8e3889f7e 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -283,7 +283,6 @@ static void qeth_l2_dev2br_fdb_flush(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "fdbflush");
 
-	info.addr = NULL;
 	/* flush all VLANs: */
 	info.vid = 0;
 	info.added_by_user = false;
@@ -637,20 +636,18 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 				      struct mac_addr_lnid *addr_lnid)
 {
 	struct switchdev_notifier_fdb_info info = {};
-	u8 ntfy_mac[ETH_ALEN];
 
-	ether_addr_copy(ntfy_mac, addr_lnid->mac);
 	/* Ignore VLAN only changes */
 	if (!(code & IPA_ADDR_CHANGE_CODE_MACADDR))
 		return;
 	/* Ignore mcast entries */
-	if (is_multicast_ether_addr(ntfy_mac))
+	if (is_multicast_ether_addr(addr_lnid->mac))
 		return;
 	/* Ignore my own addresses */
 	if (qeth_is_my_net_if_token(card, token))
 		return;
 
-	info.addr = ntfy_mac;
+	ether_addr_copy(info.addr, addr_lnid->mac);
 	/* don't report VLAN IDs */
 	info.vid = 0;
 	info.added_by_user = false;
@@ -661,13 +658,13 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "andelmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012llx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(info.addr));
 	} else {
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "anaddmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012llx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(info.addr));
 	}
 }
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 60d806b6a5ae..6764fb7692e2 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -218,7 +218,7 @@ struct switchdev_notifier_info {
 
 struct switchdev_notifier_fdb_info {
 	struct switchdev_notifier_info info; /* must be first */
-	const unsigned char *addr;
+	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	u8 added_by_user:1,
 	   is_local:1,
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 2fbe881cdfe2..f58fb06ae641 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -129,7 +129,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
 {
 	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
 
-	item->addr = fdb->key.addr.addr;
+	ether_addr_copy(item->addr, fdb->key.addr.addr);
 	item->vid = fdb->key.vlan_id;
 	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index adcfb2cb4e61..54d53e18a211 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2395,7 +2395,7 @@ dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 	if (!dsa_is_user_port(ds, switchdev_work->port))
 		return;
 
-	info.addr = switchdev_work->addr;
+	ether_addr_copy(info.addr, switchdev_work->addr);
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
 	dp = dsa_to_port(ds, switchdev_work->port);
-- 
2.25.1

