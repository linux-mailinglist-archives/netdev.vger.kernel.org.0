Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B033F2B9F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbhHTL6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:58:47 -0400
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:42303
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239788AbhHTL6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=By2s46jSpTJHyjUtVPQDaNtvgcbwWTc169qnL0jk3NfI7KK12C/TiHN1vMceG8c3B2Pb9wldWHRJQGoYhcNKm2/Nyq9RSbuaNggrQ9oAZ9EQcUOVWYMG37zGrd9KWryLhJtQjMcJK9Na4yJyudvMVA1k8l9dFf8Jf4Qmrx6qJL51KDVYnkd9GD1kAeeJkZ4NB3QMQpr0sLXpcX3G6ECueZRIqcP9ZUCy6VvOv+iN3DF/6qHciXJvFrCTdjmA4c9EXDElykDLP71Q3LNINb4RvAMdV4Rh99jyroFDqWx0SiTj0osG/kmPGxsh4ohmPud8+Y0XQ+JaYUJFzww5+4nUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hknICP/4kM0MdHjKGNTdn4xVTyVklC+JPx7kPHNmQR4=;
 b=X0HML2eHMq9i2yCnKTJprt5dp/4fCwi3LhtxXxKcltYgrQLz9bwvEdnvCxc9nC5L4eGLw6IaYrXHj9z5pd6Dp44OWnG59vjYJLx2MPVGu5q7S1DRVT4J03gHemrc90OteuC8HPO9VX7UDVzLosQn5lxRqN0mXlVCPZFvHBMcDmHSmofR0UR4/v1b8xRbs9JtT5462DJZ0rgXew6mfktExqUVFFN9Kj8mcQx90HC1WBSr/wTjzMXZrzyPKJNcMkJrblaBM9GholFl7nDA2X/9oCmh4Cle2vZom6FcYh+aRehGMYWSXtVt+qq97hHxfc9kgwcnpVbMEPYiTzYy1SetNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hknICP/4kM0MdHjKGNTdn4xVTyVklC+JPx7kPHNmQR4=;
 b=kGjyjyVjAj8nnpM6oT3hp8XNZPmYgNjFMikbJREpHq0afwtQRC8SF32lLkKM+8oQM6QAV+tNVOGZ1cErgQtXiTZ5MZNol71FcDuCyqNd5a6twJxyllUBPun29EuteSCxN/5sRreZXvrN8pYMyoflUJvsydoMh7NYccPtBYNK7BM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:58:06 +0000
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
Subject: [PATCH v3 net-next 2/7] net: switchdev: keep the MAC address by value in struct switchdev_notifier_fdb_info
Date:   Fri, 20 Aug 2021 14:57:41 +0300
Message-Id: <20210820115746.3701811-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:58:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45aed52b-2c92-4cba-b11d-08d963d1c53f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839A7630676AA0D056A2522E0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NsYqXsgAs4CBhxLb5ArGqstfsQoDik28YAnZLOfPKX6HQ3ajQW1/jDkHfjBnw213F0LnAjZRJJG4/ht3NcC0SfiLJkWAojFaWaSt3EeUJMV/plUveGrbdhJQkTXN0YdhDPo0aLJZZjiAI0I00oIaCtxdXOo3dCO9FrI08HNrqBvoykyhLfBw/KCumzTUce74lTBPhsO88vxpJ1TDitKmHEQuZ4zWTlOCtQbtHRcOmr3j26oerGAZQOV2hQ++ARXIntqw9p8IzbD82ucr8ubJcNGC5dHjUchcJi9hSS3mOed+PjffGp2JZ8oDk9Rfgbji/GtXy9OAB7B98UYxaIwqFK4BgshLYatg2W30/9ciEsoigp/1q09meYwqOpX7WGkE7RywRvk4gRUg/bvPsG+Uj8LWSxiDnbxPPGWjQwxLZ3XKzEplgwJWuSaE0+lTxYv/zuadeMhceXJYkkaPYB63wHZlPbTTCLLWH4X0wt422J2FAU1ZAvp2bksrYCHKJTRK84dyGYoTZLrEt/oBR9luNST/tY4D9F6wBF2/usxVrwzNv8dRQ5BDseg+eS0RxcdN7LfnXJ3Gbenrtb+xsaxqV44fmgBlth9OGQXVId33MoLsoYvrqs6XKru4yXriSQPD2Zs3XgKgPp1OF1J1yVf75ybV57b4+tzTGmqWAiTK1sTwLyE9COKo8DMnd/DrnchzuvaZN75jdM3PFSOMEw3okQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(30864003)(38350700002)(38100700002)(5660300002)(66574015)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NL+nxax/sKJE8IeU3JvX8/S3a8BaFJj8izBpQ3zZbl7vdVmbTXnEbiXran18?=
 =?us-ascii?Q?76r+XYlvec0YS7kawjnhekhtXEFnQYZSREKXVoVs1R40evNh8ZqLzzMQv6y2?=
 =?us-ascii?Q?E1nt027bG/wjRESQShw6c689N5/K+Z3sMpX/jW8b61ol/hLbTPuYY+KiODby?=
 =?us-ascii?Q?d+Hz8Jz8uydl94k0W7bNs1IioFZCCTE//X1OVf7CBjqf4YBqXz8UsOBUIKoJ?=
 =?us-ascii?Q?XGDsShVtmOUFpH9VEtIJjriXh5OXZ2+aY8HY4EhK44o/1clCrGVp04Z1ZJIU?=
 =?us-ascii?Q?4I3Mkw5iRbaYGNevSj5nPxLRe/e5FXzS92MPvjRxkdJKXli8kACvW3DkkivN?=
 =?us-ascii?Q?WdyKKGfyn3AHJlyCicibbGqVch8ywB89cxnKtImac2bGB/fAKtF2JL086Put?=
 =?us-ascii?Q?RjAEK2wcSXqC/Zc7Wb1J4d1hK8V9nh5jn/KUKTX+OVLSFjmj7tQcTQ7ru814?=
 =?us-ascii?Q?E6o7agOU/UX+hdte+iwkLnRy3bpogiFAB+753DfI/MtGn2dC8xUPFLAVotOZ?=
 =?us-ascii?Q?33aI6joRXBhgmB6Hxf4MtbnhstfYaqwDHoGR+FjbTu2TbCyrOZnahxaBEgd4?=
 =?us-ascii?Q?k/pUZ8s6HMvl0ECJKtZKU5O/IcuUDXJcl6BWDw5lVkV6wxEVlAf3kiiQYdtT?=
 =?us-ascii?Q?yZH1OMR+XL7Lj71IJtDT6s+tUUuGxv163GfL+acBHdW4c7Rpj7bm1xpyWbpa?=
 =?us-ascii?Q?Kei6PjQ6AIDj6TOH6PsHamwBTD7UyDt7mm8sLTHWkCcFZo8gLSww+p6LcqC1?=
 =?us-ascii?Q?yxui36mhavEhI9R5IBkOQ/9ARx9OW7pCk6xiyqBwvljbc2A3XbiU+XEJ2IJl?=
 =?us-ascii?Q?jZROs0+i6b0FL4wsMrCFvLufSsfK4apXh1s5KMw1Iabl1kQ5Ga5NPPeUr4tM?=
 =?us-ascii?Q?bMhsTaIr/tFL2MdZwz3yicWhI3VlW/KSURUZ84yJSx4YF1u1+uQmVk8AveE8?=
 =?us-ascii?Q?Vw5DXrFRNWDGhspjypQDdKgsRdtju8m2kCY3dY9ezCfG8tS1KIs+iM7JFPRg?=
 =?us-ascii?Q?eEdlGMcMCATsukEUbEL9K0cDJlU+3E7BPY6bC5ictRDup0HnQIv8vfpNyRe8?=
 =?us-ascii?Q?keob+jAqNI9TW1+l1lzqJln/lWFH8kZt6eZV7YcaF5tNW7C9yCOdJO+68+ES?=
 =?us-ascii?Q?UjsZ5gDF8O/l9yejE0YR0OLSg9sHDFn4YuZeAyQyc0mSzi89bHTSHWcaUHEf?=
 =?us-ascii?Q?c6pNppdPh+B1ZDKsYHLqtrw7ZTrFS11UZuKoNSY3ALtEA9O/V7HThEbvXps+?=
 =?us-ascii?Q?spSN1Wyc9dI68ehutgRNwJOLlnXSSzzUnfOlspV6zVGqGxCw4nCjN2xM8pE0?=
 =?us-ascii?Q?q9e7txZJTufg8NSzrnb8Kee7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45aed52b-2c92-4cba-b11d-08d963d1c53f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:58:06.0914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGaPPsHhMF1D1gdBSchWQZ7/rIm9wYYpXXEG14k6M3krf/a3DzTmeAeC3iNlbsW3/Vc7m0RI6EMAYkAOUEr/mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETH_ALEN is 6 bytes, which is 2 bytes more than a pointer on a 32-bit
machine, and 2 bytes less than a pointer on a 64-bit machine. So in
terms of memory usage, when you consider that the variant with the
pointer needs memory for the pointer _and_ the address, we would rather
embed the address within the structure directly. Not a huge difference
either way though.

But with the upcoming conversion of the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
notifiers from the atomic call chain to the blocking call chain, where
switchdev_deferred_enqueue is used to copy the FDB entry created by the
bridge, we can see that only a shallow copy is performed (with memcpy),
leaving behind the fdb_info->addr to point to bridge memory.

When switchdev hands out a shallow fdb_info copy to drivers where the
addr still points to bridge memory, the RCU read-side critical section
is dropped quickly, much quicker than the driver might act upon the
fdb_info copy. So the address might be freed by the bridge after an RCU
grace period expiration. This does currently not happen, because RCU
watches for the entire period during which br_switchdev_fdb_notify runs.

We want to avoid that, but we don't want to patch switchdev_deferred_enqueue
to perform a deep copy, and we don't want to create a deep copy ourselves
which we pass to switchdev_deferred_enqueue for it to make a shallow one.
Who frees the fdb_info->addr? Do we really bother to do it under RCU?

Instead we can notice that switchdev_deferred_enqueue works just fine
with struct switchdev_obj_port_mdb, because the addr is embedded inside
the structure there, and does not reference bridge memory.

So we do the same with struct switchdev_notifier_fdb_info. Making that
change means we also need to touch all drivers that operate on
fdb_info->addr.

For the most part, the change is for the better: the shallow memcpy that
most drivers do in the bridge -> driver direction is now good enough to
also copy the MAC address. So we delete a bunch of code that used to
allocate an ETH_ALEN unsigned char array, and the ether_addr_copy that
goes with it.

As for notifiers in the reverse direction (driver -> bridge), it is true
that drivers now do an extra memcpy where they previously did not, but I
have heard it is desirable for SWITCHDEV_FDB_{ADD,DEL}_TO_BRIDGE to be
converted to switchdev_deferred_enqueue in the future too, and this
change will only make that easier.

Some drivers perform a type cast from the void *ptr to a struct
switchdev_notifier_info *, then use container_of to get from info to
fdb_info, even though this is not necessary as fdb_info is guaranteed to
be the first element of info. Anyway, type safety is good to have..

Except these same drivers then proceed to memcpy into their fdb_info
structure directly from the ptr variable, and only copy from the
fdb_info pointer the MAC address... So much for type safety...

I didn't really want to touch that in this patch too, but with the
elimination of the ether_addr_copy from fdb_info, the fdb_info pointer
is really no longer used. So let's really use it for something.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 14 +------------
 .../marvell/prestera/prestera_switchdev.c     | 18 +++--------------
 .../mellanox/mlx5/core/en/rep/bridge.c        | 10 ----------
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  4 ++--
 .../mellanox/mlxsw/spectrum_switchdev.c       | 11 ++--------
 .../microchip/sparx5/sparx5_mactable.c        |  2 +-
 .../microchip/sparx5/sparx5_switchdev.c       | 12 +----------
 drivers/net/ethernet/rocker/rocker_main.c     | 13 ++----------
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 14 ++-----------
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 14 ++-----------
 drivers/s390/net/qeth_l2_main.c               | 11 ++++------
 include/net/switchdev.h                       |  2 +-
 net/bridge/br_switchdev.c                     | 20 ++++++++++---------
 net/dsa/slave.c                               |  2 +-
 16 files changed, 35 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d260993ab2dc..dd0096cc3221 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2244,7 +2244,6 @@ static void dpaa2_switch_event_work(struct work_struct *work)
 	}
 
 	rtnl_unlock();
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(dev);
 }
@@ -2276,15 +2275,8 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
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
@@ -2296,10 +2288,6 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
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
index 0c38c2e319be..3e11420d8057 100644
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
index 7e221038df8d..38beef330b94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -71,7 +71,7 @@ mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *
 {
 	struct switchdev_notifier_fdb_info send_info = {};
 
-	send_info.addr = addr;
+	ether_addr_copy(send_info.addr, addr);
 	send_info.vid = vid;
 	send_info.offloaded = true;
 	call_switchdev_notifiers(val, dev, &send_info.info, NULL);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f69cbb3852d5..9e129c93581b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9086,7 +9086,7 @@ static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 	if (!dev)
 		return;
 
-	info.addr = mac;
+	ether_addr_copy(info.addr, mac);
 	info.vid = 0;
 	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
 				 NULL);
@@ -9137,7 +9137,7 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 	if (!dev)
 		return;
 
-	info.addr = mac;
+	ether_addr_copy(info.addr, mac);
 	info.vid = vid;
 	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
 				 NULL);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 22fede5cb32c..78e5059beafa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2522,7 +2522,7 @@ mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
 {
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = mac;
+	ether_addr_copy(info.addr, mac);
 	info.vid = vid;
 	info.offloaded = offloaded;
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
@@ -3013,7 +3013,6 @@ static void mlxsw_sp_switchdev_bridge_fdb_event_work(struct work_struct *work)
 
 out:
 	rtnl_unlock();
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(dev);
 }
@@ -3256,13 +3255,8 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
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
@@ -3289,7 +3283,6 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
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
index 3364b6a56bd1..d490d006cc98 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2718,7 +2718,7 @@ rocker_fdb_offload_notify(struct rocker_port *rocker_port,
 {
 	struct switchdev_notifier_fdb_info info = {};
 
-	info.addr = recv_info->addr;
+	ether_addr_copy(info.addr, recv_info->addr);
 	info.vid = recv_info->vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
@@ -2757,7 +2757,6 @@ static void rocker_switchdev_event_work(struct work_struct *work)
 	}
 	rtnl_unlock();
 
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
 	dev_put(rocker_port->dev);
 }
@@ -2789,16 +2788,8 @@ static int rocker_switchdev_event(struct notifier_block *unused,
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
index 72e84ff9fea5..de98f79c11ab 100644
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
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012lx", ether_addr_to_u64(info.addr));
 	} else {
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "anaddmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012lx", ether_addr_to_u64(info.addr));
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
index 8a45b1cfe06f..7e62904089c8 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -127,14 +127,16 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 			const struct net_bridge_fdb_entry *fdb, int type)
 {
 	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
-	struct switchdev_notifier_fdb_info info = {
-		.addr = fdb->key.addr.addr,
-		.vid = fdb->key.vlan_id,
-		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
-		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
-		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
-	};
-	struct net_device *dev = (!dst || info.is_local) ? br->dev : dst->dev;
+	struct switchdev_notifier_fdb_info info = {};
+	struct net_device *dev;
+
+	ether_addr_copy(info.addr, fdb->key.addr.addr);
+	info.vid = fdb->key.vlan_id;
+	info.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	info.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	info.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+
+	dev = (!dst || info.is_local) ? br->dev : dst->dev;
 
 	switch (type) {
 	case RTM_DELNEIGH:
@@ -278,7 +280,7 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 	struct switchdev_notifier_fdb_info item;
 	int err;
 
-	item.addr = fdb->key.addr.addr;
+	ether_addr_copy(item.addr, fdb->key.addr.addr);
 	item.vid = fdb->key.vlan_id;
 	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index eb9d9e53c536..7bc88767db9d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2288,7 +2288,7 @@ dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 	if (!dsa_is_user_port(ds, switchdev_work->port))
 		return;
 
-	info.addr = switchdev_work->addr;
+	ether_addr_copy(info.addr, switchdev_work->addr);
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
 	dp = dsa_to_port(ds, switchdev_work->port);
-- 
2.25.1

