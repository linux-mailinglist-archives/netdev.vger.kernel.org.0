Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3F7438AF0
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhJXRVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:21:40 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:57952
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231757AbhJXRVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:21:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pqeq5CzltkNc5xIlL9wWuuT1JtAhD7omNesLw76OEMwtoyVOY0YMYWpt/SglSBg0PNmZvDkhJZdS5ZLTLMqW3eETfvBzsgpHAzNfFZ6qP4Rqfy3tuypYWFKpBFGmUw90MGv89Qo/vKkciNE2pn/k0rttX+7kDv2p0uA8aGkX6/zVhkdYiG5QvOQMqN1mfExPOCcW+Srg6EUZdVstKgMWMO5VfzBFaMDfcrD2gmp1S9VY73uEhFVcxj/nuyV8orH2XhFF93vFu6AKIwulj5bNTAAzNSNCTTKlpUjesvs2vm7AVdt5EkKo7emDGNHYSQPIEHCZdYh8YcRb65oHq2+r5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=230hBZAYnrtPlET8NYvN0IvxYRdbMZOfo02GgFOSeg0=;
 b=gibcyHNHyNfWaHv3m8FXTf8+PzzcLI6YYHRUI3V0snWDXHx31thlABvSYox6qhJNuaEYKMxYAkYD42cH6Fcq2Fo4POt/4mEYc1GV7o80MTBt/n2g4XoNa/3FiOIpw4NHl00T0AZq2B2HxV9CdfH2Vp/kUXCEkN3f+KJyV2hcyNgB2EnfyDsj1dsAWtvfInwU6rgaig82m7dbg22m1zIcnl3KnzSoyIyTlP0FHdT9flRnOHq2faidiGdi8DQ7Hbt7aPTEGnCgbz0i+t9B4qKJT0D/NEmCZuPjr/oiTE7MHphicpvD/0wZhGCbJJAo6pvfDGh7xyUb4fI2NYcrsY1EYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=230hBZAYnrtPlET8NYvN0IvxYRdbMZOfo02GgFOSeg0=;
 b=M4DkTAy8/Zz7gh4oW6Nfa3YmulQTrOU1BQh5Gu8ek1QQEUeiwIEvHj6fOodgYHzdFWGri6sS5D/99HOBsXqoxccchsh1yWdbue5taJfhut251r9Vqn8M80KH3qZFUaCpXn3qVUDwhU1Zgo6aJSZh1qiNA6aMEZetVaaYRJSgQQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v5 net-next 07/10] net: dsa: introduce locking for the address lists on CPU and DSA ports
Date:   Sun, 24 Oct 2021 20:17:54 +0300
Message-Id: <20211024171757.3753288-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b8281f5-4974-4d40-6027-08d997125185
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3552AB14B98EEBE740B636A7E0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AOsZUUNTynJM4iaCvYK7qUeWRzmV14M0KnvxRu100fdZdfgj4eiZqZrEquKJfQW+vSnMnX6NV7lMaD4eNufbruJtIgq3Mdo+psrD8RukAfe0NycTfDIyfKEB7dhVP+dgYrkfF4jc7W8hINzfWg6qHWsv0PXa+1rgB7QByrc9p4YdzJ0xF3q0Ygy4hm0cVA0BTuEu/hqArIS2Nw/GQqGQmP4CKnFKjEuAEJDpvCCPBWCJDsTEAhMKIboCo4QUs0BOLzP/UuvZE299eaEn7VGMb52NFSemFsjTOwTPdHZc95E7pwczMc4NRN7hcBuaGVqVI9AXTv6t02WW0hPzRYUz5Wzl+aaqbkCokqPB4OyWbwUX4F89yVbuoWM+4djND++emVXTAF+pvSTaNgGA9iDyLVPtXy5SN56NIlBMYOtMt2XP93hyEz2PGmNCUZ7VutLGgx1g9/HsbkbRRhdP8P5smeh60TCQuGxrgcQl3DKeBIXqSpPvqO23CrNMJyANk8LDrLzxn1aXzzpELGGEmmKHC3RYJqSNmyfUeG/qp/yQmreCHp2uhF8TOwa4xU/FSkf7mmmzX6P8Fd0nRSv2/myc/f7XC1lFaw76U46GWdjVlrp+wuUnmRsc9QRiQRnVWeAMwoMKDxCx2TqZT468Md7M9NYmCx0JdHxQBg6fN7/vB7os9nveWAkQTWSItGfnBQbg6QpO32Se1R1PjJqpsgbg9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8fTls2eTpts0HV+yEcSx4WkxgiNR8jCzi0H+9NFk5W1ecYcntKB6qeFNCWMx?=
 =?us-ascii?Q?nJVUab93fD2ZeavzKKGXE/qfru732449NEQCJNrvYZP00CLiltV2XCFUCCHA?=
 =?us-ascii?Q?jG7VrJXfxhazGLtRbU+iM20RIrxp94pI3mVeWVJ6GzCnx9I8FSR2XxcbfFbK?=
 =?us-ascii?Q?nsjm4goVS+2yZba8zVM0l2aZqlTDZASlIG4aEPTcv/Qpt6qjCQVNBCJMM3zE?=
 =?us-ascii?Q?MeJISdpe3V9pN8rImJ0KGKKpjzqgGLEP3KH3NDvDOfM3ab5ZNt0EzHC2z6Zz?=
 =?us-ascii?Q?TGnLTckbmX4AcettqEJ4MgEhFG2QUhWGnbnHBvtwuZ+cEH9gk31n/DJO5oKj?=
 =?us-ascii?Q?bRfAsIksxknSnjXncEI4R347T3lclysKPkqthfEUGocEfJhgAIxDIsURUwdp?=
 =?us-ascii?Q?OkLOTNW3oL/oMU+OCOcJzzbulBPX6fdf9QFKG5BRvhBzjye0vRTkEAG3kxZb?=
 =?us-ascii?Q?l17z12aTAikxTasfNe5XiclEDg0uQcot4hkBhUH1bkRzE/+rpGeuILX1GsYx?=
 =?us-ascii?Q?8zd7URfWSnezk5Wi3LnUnfF2TFso+0uvLAqoBzKy/PcIskmksnjHBef2p773?=
 =?us-ascii?Q?66Cb2cfDJ6IGnmv97oMEobVEsUWAcWm3UlA5FJ7nG/C5i8WabkUT3MNn1u7D?=
 =?us-ascii?Q?bFGauV/lCMOA49Qp1YmlYHSCYROCxQ+1eOdfXYYqTiZIDIw1RpOBgR6maDJv?=
 =?us-ascii?Q?XYRNmx5P89BHcXkO8r70Oly5uuqrQIiqnqAa6t4xR67AWP21xpTD42jQb+Sf?=
 =?us-ascii?Q?KIAn8LUDwCW/8xE0Lpin0Qnn0c1rv8gb9OxPmfbJ90cslpaEh1e9pejxvuqU?=
 =?us-ascii?Q?dLe77E9G5mtrpBZm3WetynbLf3yEJnofrgNnhKQg0+fPN7qQPxDQNw7BwDcH?=
 =?us-ascii?Q?TuAaCWU6IZICuv1xLdVHXR/qhw9jdE2h/7HUhoHXke0iOKo4yefIZUGOiJm0?=
 =?us-ascii?Q?0CBniGWI80X4E5Bpg7S4JlmiLmOKfOIxyBRMS5OVVJwYV3/UiiXpTR7gK4Kl?=
 =?us-ascii?Q?CCQePshh6GPmg8BWX9wTK9jw2ttd4Y6/dQp7lobB0JgSrSeEvvI86aqR+eeI?=
 =?us-ascii?Q?3/jBRHTuEkVy99Qm8wiZV9P6FO//1Id/P7Kk95y0tuUvIjVZEUNiO8wFrl/8?=
 =?us-ascii?Q?UO9/wQsPjH9qTZ7jqdJ+stIMbS1RajPVpVEBYR6Fep9G+54MNYCCF3Nr2jHW?=
 =?us-ascii?Q?ZsLJNgNsbzTsdJ/leLZ3n1qLiR9oulm+jznTNYfr+cewiVaGrmZwe3PvyPba?=
 =?us-ascii?Q?+FzTaW6ml+HmjGTl3J5CgV6R8lAAJreAPhbUjmT38MLp3p9DxXQXgJJC2spR?=
 =?us-ascii?Q?P4dlr+gkFY/DOBujPywIp0NfdZ2C/PybLPwVuPgjXKKkZT7WgfxTCeMSuoX9?=
 =?us-ascii?Q?rHUu1bRFePmA1Xamwhv+iY9HDS0fbCk9DgSWV1Zkb2pywqO4LVrGJS9SlcQp?=
 =?us-ascii?Q?d+iluW0/rSyTVbDMMLQ/LdPhA+06u3lflSZIQtOOI+f18xJ852X6ImndvCxY?=
 =?us-ascii?Q?HYptJDkmmNobgFcMOIT+pDHuIbFCZavwIZnCWVPOQBtXC8umzpwDk7kvNAY6?=
 =?us-ascii?Q?Wsd//gy86FgtyWbtUigl6IoC/IXAus/uY4gn7Lh2Y/w2FXt/cH3GZgx469ib?=
 =?us-ascii?Q?q1fqyKbAazNOvy8Yc1VFXO0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8281f5-4974-4d40-6027-08d997125185
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:38.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0KNIDmKKlXoW2HS2Hg2Zjhs4Fuw3/e5Wlb3T40N3QC/QWnM4arhZ+K/qqnCN/kfq4JNJs3g3qTw8E+E+qdVFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the rtnl_mutex is going away for dsa_port_{host_,}fdb_{add,del},
no one is serializing access to the address lists that DSA keeps for the
purpose of reference counting on shared ports (CPU and cascade ports).

It can happen for one dsa_switch_do_fdb_del to do list_del on a dp->fdbs
element while another dsa_switch_do_fdb_{add,del} is traversing dp->fdbs.
We need to avoid that.

Currently dp->mdbs is not at risk, because dsa_switch_do_mdb_{add,del}
still runs under the rtnl_mutex. But it would be nice if it would not
depend on that being the case. So let's introduce a mutex per port (the
address lists are per port too) and share it between dp->mdbs and
dp->fdbs.

The place where we put the locking is interesting. It could be tempting
to put a DSA-level lock which still serializes calls to
.port_fdb_{add,del}, but it would still not avoid concurrency with other
driver code paths that are currently under rtnl_mutex (.port_fdb_dump,
.port_fast_age). So it would add a very false sense of security (and
adding a global switch-wide lock in DSA to resynchronize with the
rtnl_lock is also counterproductive and hard).

So the locking is intentionally done only where the dp->fdbs and dp->mdbs
lists are traversed. That means, from a driver perspective, that
.port_fdb_add will be called with the dp->addr_lists_lock mutex held on
the CPU port, but not held on user ports. This is done so that driver
writers are not encouraged to rely on any guarantee offered by
dp->addr_lists_lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v4: none
v4->v5: rebase over new patch 01/10.

 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    |  1 +
 net/dsa/switch.c  | 76 ++++++++++++++++++++++++++++++++---------------
 3 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1cd9c2461f0d..badd214f7470 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -287,6 +287,7 @@ struct dsa_port {
 	/* List of MAC addresses that must be forwarded on this port.
 	 * These are only valid on CPU ports and DSA links.
 	 */
+	struct mutex		addr_lists_lock;
 	struct list_head	fdbs;
 	struct list_head	mdbs;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f5270114dcb8..826957b6442b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -433,6 +433,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	mutex_init(&dp->addr_lists_lock);
 	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 8f8ed8248c2c..bb155a16d454 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -215,26 +215,30 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_mdb_add(ds, port, mdb);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
 	if (a) {
 		refcount_inc(&a->refcount);
-		return 0;
+		goto out;
 	}
 
 	a = kzalloc(sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return -ENOMEM;
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = ds->ops->port_mdb_add(ds, port, mdb);
 	if (err) {
 		kfree(a);
-		return err;
+		goto out;
 	}
 
 	ether_addr_copy(a->addr, mdb->addr);
@@ -242,7 +246,10 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->mdbs);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_port_do_mdb_del(struct dsa_port *dp,
@@ -251,29 +258,36 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_mdb_del(ds, port, mdb);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
-	if (!a)
-		return -ENOENT;
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	if (!refcount_dec_and_test(&a->refcount))
-		return 0;
+		goto out;
 
 	err = ds->ops->port_mdb_del(ds, port, mdb);
 	if (err) {
 		refcount_set(&a->refcount, 1);
-		return err;
+		goto out;
 	}
 
 	list_del(&a->list);
 	kfree(a);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
@@ -282,26 +296,30 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_fdb_add(ds, port, addr, vid);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
 	if (a) {
 		refcount_inc(&a->refcount);
-		return 0;
+		goto out;
 	}
 
 	a = kzalloc(sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return -ENOMEM;
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = ds->ops->port_fdb_add(ds, port, addr, vid);
 	if (err) {
 		kfree(a);
-		return err;
+		goto out;
 	}
 
 	ether_addr_copy(a->addr, addr);
@@ -309,7 +327,10 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->fdbs);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
@@ -318,29 +339,36 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_fdb_del(ds, port, addr, vid);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
-	if (!a)
-		return -ENOENT;
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	if (!refcount_dec_and_test(&a->refcount))
-		return 0;
+		goto out;
 
 	err = ds->ops->port_fdb_del(ds, port, addr, vid);
 	if (err) {
 		refcount_set(&a->refcount, 1);
-		return err;
+		goto out;
 	}
 
 	list_del(&a->list);
 	kfree(a);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
-- 
2.25.1

