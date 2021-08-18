Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE03F032F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHRMEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:25 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:39586
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235754AbhHRMEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDqFpnm2S2dlSltG3oLYYxas8+3gLe36YeidnLYoBsR0D+Ka7LPhbOUHAB8f4xDfo32txtJvTqcHk2qzsIddPxRTsAfh8JigocymMvYS70bm0dU7rpfhEOptN3NvO5levg+TyVzS6/nzxasDGQOJ8Yi43WDeK8AKMAPFpNkFcI1lKlokvlBHYRW+Vab119W69D7GYP7l3nZkRKQyEgvRP5ET8JFUot3c21FKe6Ej6XWsUWmHbl3hqulIF0pJxXwBI+zJMn/BS+Z8viuHohDVqiQ1CPEPh14BXS2fQIj3iPMmC8WTyXOeB2ZIxE3pbYEb3PbsTgnslXoV88oLfgUpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCpUQUmQgGpNqgld2DAKPLAKwjHwH5ZZhkv0wV6lR0Y=;
 b=Y9Dk7wSfr40JLXmM00htvd+VEW22h4L8ULY5tS+iihB6g13gnjLSXHemO1EVooA3L4shiocxrKuwCMAutTRqABZ4RSPtjdenBssNFcW573qMZOYOvFJSvxrHWR4LixltbnA6s0pjbdL6/C1INucnFwicd1LgvgdA6BtP0BjoaV8mgYao+TWqTRU1bKTaVSYvx/Gh0hDjsGqSy/FcSYSNGxcJj1X1BF9lABZC59B9nSrnWnO68dErfkJ4DpmQrLgzE2nfhqjY81LTC7/2rVE4SrauIfsKZcvb4gMfnPrh90o5kwItX0i+EKQ46hmDFLqUWcerNjQRap2oadFI16nfLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCpUQUmQgGpNqgld2DAKPLAKwjHwH5ZZhkv0wV6lR0Y=;
 b=JW934LK9BssrcH3pwxHxjrIPj+QyQClyNPcLet6paF7W9+ka5he4x0GwlTl5RsXc51sWPu/o/zkL3cCFA2N0b8HRr5DeB+C+Ssg5qmnFmRynL988YW7wELgBwKoUnx8H2vZSb+H/2SICZY0BEjt9cCSCllH4zwim+iCCMfPgxoI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:01 +0000
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
Subject: [RFC PATCH net-next 08/20] net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously
Date:   Wed, 18 Aug 2021 15:01:38 +0300
Message-Id: <20210818120150.892647-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b57fb7b8-c7c0-4fc9-4572-08d962402075
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839A70C1F63ABBA591249F9E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1PM1m9Q8pgftAAG+z0ZZetNT5nIilCwA5WTSzNT8JdF0rDSo9Z15IjbMAiZRaW3KOgBX/wfYprSmP1NpQO8RlzqNVAxuRsZ29/5ffJz1Ln11cpQ3mt5qfxfPiY0AgFwxZVL3Fa+n5ObLOKkg4TwZ14ySyhdbLZ7WCsDfAv5FtopyLs6KkXSH8TJMzc74EhXDPDDVHO3DVpBeJNFtxg/NhysTD1JHfq/D9EwinrYi/UpOOVj7H61sZUXlgrlEI3C7VF18DSOJEb7SKH6rYk+3yO8nJpdey/U1QzNuvqz5PigkOcOYb6vB4vP5X0tHzbN/mZOXNtiSKN0QM3PQVesClj48KBIGDdy9melD947Un4gOlD2BQ1Xx5NgKy8nqOJ9UYF8swq91UnJnmDv5+K7/KohbZA6WxgVvM6irBFqJbuZNB7p12EAqniP2OLeGqihuAEmYee6B5iqPWe2DvgakXmvJJd1WmmDVzJS00q5RpllxPt8v9xTTbiSKOckiQLeNu4Lctme9PfnCeJCqnR3iFqzemzmHx6/QPNgqk8VT5nZcxKJu/aYO0aqn6U0NVW//2GxHB+B9/JHhUbfA0IvV1slCwKUPQVOBLtvFbRRlb3eASiUUjrFif+QiNi5aR2Q1srJn7RHiBIHuylEYTl+zZsLhITxd7AQApij2yTI+9zc7WG1X8fSvyzEzRIjvZtqXSezCMy5G7wevUI9yG67p9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l2HB76Z3TSzLPRyaBoxqLPZKyx7ZNpkBoHcdVb5ytsOtld6sESlam7V75J1X?=
 =?us-ascii?Q?PYUSDrUwwQPeuURvtGp5h5Qtrs1bNHj4SYCJDaOR+U4JZbfsti2N7WZeqomh?=
 =?us-ascii?Q?dLDtQHX6J021822G2sU79jbYg+I88V+fiX7aG3LQCUdHypMsxiBRnJ8JLrrs?=
 =?us-ascii?Q?NcafDHrU23cj2xq6E4wXCB3J+JxJAfU8baWma2BztLhLDho1pTrRjMuWTBi3?=
 =?us-ascii?Q?H8r6IbNX+D/hZkzDhHFVAvZG90Iytoy3ss2bJ5ri4cuhfG726YVj0Y3tFVRu?=
 =?us-ascii?Q?WKXkZcWrHAC33eFj8PBt7A/yTaSb+mSnhQL5cusyFMW1woM55lwtyYzV/2B+?=
 =?us-ascii?Q?t5PhsdBuTyDn3n9D+0hjUJmk+PmHU5g7I4or0atpyZ+U4sCdCqg1vyIY+ZlK?=
 =?us-ascii?Q?fTw97oEU2xYmgxFSPchSGUrzTamk+nDGP2IrvZnknCr7azSv9+jrhBeUpQFu?=
 =?us-ascii?Q?VZN7U6W6Foz48n3kY1wFHbkMgaeM6v1JSyahxyrnMhKs2791TnQAjdUBYjfa?=
 =?us-ascii?Q?h3A0oqqLloDl1g6aqexxldtw+G2GTLGqgitRLuow26Z9qkttgmvoL153ooNp?=
 =?us-ascii?Q?jNIoH0ihmeAtqFZz+nIFUvBZMyYFcmuzQrCrDvroEW0G3qwUkq6ANu5ZOGRQ?=
 =?us-ascii?Q?u0OgpnN2xkMofhmCLTNfLqxAeYZHhSpgvTHGIzhvaDGKgohmc7p28P/yIFzL?=
 =?us-ascii?Q?LEZgwyJTvXPjtoIC066hbDaiW+lJSHAX/p9IXK5bG44LIgr1hq6wdeYrd56R?=
 =?us-ascii?Q?ZflmoG/goowe/JF5J4gBWsscv8E9ke2gAgVLeF55YO70SYk66r0rPCpjATWg?=
 =?us-ascii?Q?h4lZckPHYpQm1UErvGgTQbYR0HZ7Cr3axr/GONkBvApwKui8ilpjohgvnY6p?=
 =?us-ascii?Q?f9FRBLmxR7vuv7++/MAx9tTDqCvHns1ol3cdToadIPgabwW9E8488oq7jg55?=
 =?us-ascii?Q?M4YqUz+OWZTKEGi2TFtRFBMKhnTKaPDGeaKK23aDS2u1RinqJGc5ofuSaNvF?=
 =?us-ascii?Q?gdCSBngUO0ir6cI0WjT8le4QSPDqsI9SfTRyfjyI23t7bS5Sp+EFcTVSGJMX?=
 =?us-ascii?Q?fjEC/JK45+9GjqEe61KhS+2bO9n7Ze38M+632AVWOEAo4gQgT0AIWF0dlrGx?=
 =?us-ascii?Q?abJO6uni/ZdTQqn/vS11Nj3kwoCQEPj0/Iha9j/92Br5fIQAZ28RnzuEadNw?=
 =?us-ascii?Q?5ITp0evqEZ99FzyQzZbom55XB5vPfLgky7QOYgc9h2SHTFYsJq+lEOvZJ8/t?=
 =?us-ascii?Q?y96yWof7bGsIVc+6OFNofz+dzJsuZbJL33npjB6NKPsrbsdPlacU/5R+9sRv?=
 =?us-ascii?Q?j4jA+mC9uJ50Oyt7QaxzZDf7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b57fb7b8-c7c0-4fc9-4572-08d962402075
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:01.4069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xn2FPhkq72Zmyqrl2VPv/dSvFY+72b0vRbqScfBKg2I2Hd2G46zNDTJP1L/bXtK8E8J+bmH2YVQFZkSRpEWDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the switchdev FDB entry notifications are now blocking and
deferred by switchdev and not by us, switchdev will also wait for us to
finish, which means we can proceed with our FDB isolation mechanism
based on dp->bridge_num.

It also means that the ordered workqueue is no longer needed, drop it
and simply call the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa.c      |  15 -------
 net/dsa/dsa_priv.h |  15 -------
 net/dsa/slave.c    | 110 ++++++++++++---------------------------------
 3 files changed, 28 insertions(+), 112 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1dc45e40f961..b2126334387f 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -338,13 +338,6 @@ static struct packet_type dsa_pack_type __read_mostly = {
 	.func	= dsa_switch_rcv,
 };
 
-static struct workqueue_struct *dsa_owq;
-
-bool dsa_schedule_work(struct work_struct *work)
-{
-	return queue_work(dsa_owq, work);
-}
-
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
@@ -465,11 +458,6 @@ static int __init dsa_init_module(void)
 {
 	int rc;
 
-	dsa_owq = alloc_ordered_workqueue("dsa_ordered",
-					  WQ_MEM_RECLAIM);
-	if (!dsa_owq)
-		return -ENOMEM;
-
 	rc = dsa_slave_register_notifier();
 	if (rc)
 		goto register_notifier_fail;
@@ -482,8 +470,6 @@ static int __init dsa_init_module(void)
 	return 0;
 
 register_notifier_fail:
-	destroy_workqueue(dsa_owq);
-
 	return rc;
 }
 module_init(dsa_init_module);
@@ -494,7 +480,6 @@ static void __exit dsa_cleanup_module(void)
 
 	dsa_slave_unregister_notifier();
 	dev_remove_pack(&dsa_pack_type);
-	destroy_workqueue(dsa_owq);
 }
 module_exit(dsa_cleanup_module);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c5caa2d975d2..55b908f588ac 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -126,20 +126,6 @@ struct dsa_notifier_tag_8021q_vlan_info {
 	u16 vid;
 };
 
-struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
-	struct net_device *dev;
-	struct work_struct work;
-	unsigned long event;
-	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
-	 * SWITCHDEV_FDB_DEL_TO_DEVICE
-	 */
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
-	bool host_addr;
-};
-
 /* DSA_NOTIFIER_HSR_* */
 struct dsa_notifier_hsr_info {
 	struct net_device *hsr;
@@ -170,7 +156,6 @@ const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
-bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b6a94861cddd..faa08e6d8651 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2278,73 +2278,18 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void
-dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+static void dsa_fdb_offload_notify(struct net_device *dev,
+				   const unsigned char *addr,
+				   u16 vid)
 {
 	struct switchdev_notifier_fdb_info info = {};
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-
-	if (!dsa_is_user_port(ds, switchdev_work->port))
-		return;
 
-	info.addr = switchdev_work->addr;
-	info.vid = switchdev_work->vid;
+	info.addr = addr;
+	info.vid = vid;
 	info.offloaded = true;
-	dp = dsa_to_port(ds, switchdev_work->port);
-	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
-}
-
-static void dsa_slave_switchdev_event_work(struct work_struct *work)
-{
-	struct dsa_switchdev_event_work *switchdev_work =
-		container_of(work, struct dsa_switchdev_event_work, work);
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-	int err;
-
-	dp = dsa_to_port(ds, switchdev_work->port);
-
-	rtnl_lock();
-	switch (switchdev_work->event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
-						    switchdev_work->vid);
-		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-			break;
-		}
-		dsa_fdb_offload_notify(switchdev_work);
-		break;
-
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
-						    switchdev_work->vid);
-		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-		}
-
-		break;
-	}
-	rtnl_unlock();
 
-	dev_put(switchdev_work->dev);
-	kfree(switchdev_work);
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev, &info.info,
+				 NULL);
 }
 
 static bool dsa_foreign_dev_check(const struct net_device *dev,
@@ -2369,10 +2314,12 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 			       const struct switchdev_notifier_fdb_info *fdb_info,
 			       unsigned long event)
 {
-	struct dsa_switchdev_event_work *switchdev_work;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	const unsigned char *addr = fdb_info->addr;
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
+	u16 vid = fdb_info->vid;
+	int err;
 
 	if (ctx && ctx != dp)
 		return 0;
@@ -2397,30 +2344,29 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (dsa_foreign_dev_check(dev, orig_dev))
 		host_addr = true;
 
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return -ENOMEM;
-
 	netdev_dbg(dev, "%s FDB entry towards %s, addr %pM vid %d%s\n",
 		   event == SWITCHDEV_FDB_ADD_TO_DEVICE ? "Adding" : "Deleting",
-		   orig_dev->name, fdb_info->addr, fdb_info->vid,
-		   host_addr ? " as host address" : "");
-
-	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
-	switchdev_work->event = event;
-	switchdev_work->dev = dev;
+		   orig_dev->name, addr, vid, host_addr ? " as host address" : "");
 
-	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
-	switchdev_work->vid = fdb_info->vid;
-	switchdev_work->host_addr = host_addr;
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		if (host_addr)
+			err = dsa_port_host_fdb_add(dp, addr, vid);
+		else
+			err = dsa_port_fdb_add(dp, addr, vid);
+		if (!err)
+			dsa_fdb_offload_notify(dev, addr, vid);
+		break;
 
-	/* Hold a reference for dsa_fdb_offload_notify */
-	dev_hold(dev);
-	dsa_schedule_work(&switchdev_work->work);
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (host_addr)
+			err = dsa_port_host_fdb_del(dp, addr, vid);
+		else
+			err = dsa_port_fdb_del(dp, addr, vid);
+		break;
+	}
 
-	return 0;
+	return err;
 }
 
 static int
-- 
2.25.1

