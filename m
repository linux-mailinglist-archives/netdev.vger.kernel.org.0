Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A00F4378EC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhJVOU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:26 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233073AbhJVOUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTo3iPtpYjJr212k2f+RDno2XflqrNLUJMjUT9LHdBT1/HEp/ks4tJKLTqlSOPES5Tr7CPacoegOTnibPWJMfZ16lRlWh/cVYqAjSPsy3/yxR6v+NcxKhAH035mACGjBntDY0CiAaj6kagtcLEi0JPCchtkxW1c008wZGuR1e3FBvSun1AreX4DgXwEgsJ7equ8zLyLcsP8+Zv88AZkdXjI5xTLSi7ZvXddEIrvCyyDY47i5rdR1Bp0hEl1lrkBvfqHrZvIGUdtKtmoEYgjIMgRyLh2KanA7a2smO4X8wfmGCFAUH6rpzYuXPbe5DMXIvjvyQqZ9zh5BA6ZbkQIldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFX1e49Woske/T2LLLmiux09MkF08b4pSiRYnyL86ic=;
 b=iHMtEG9XqXyJeVG/8SUG31GFmzufhg/1dbMYXzr6yKy3GuU6v9StPsDoZyRNA33uVLYsHszMsZ26ceFFR9qmI0yjjlDZvWr7f7XBWJtg6wv+hZwPTf/Gl0ECblcdnwj91YWg23oP5EPax6C/fMJpKQq7Uj0wCEHI8fRmMQgL4kRPstqfTGSWVbw3WQZu/cmfeU+QVndDB8n13HMg1DIz58Fs6Hle0A/AZswgtj3if6ur+r5Ci6A7hoBPhooOQx9GYOef4cz4RTiUTilIes/wRdsDCqAjtRqy/HbVUgTffA5p+V5Ml+QHuQrNuGOqe0rvSUxTMIfcG5N+LV1A/Ua6uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFX1e49Woske/T2LLLmiux09MkF08b4pSiRYnyL86ic=;
 b=Jig1yUFwp2ApaHksy2HoihxKgpjhOFs9q7lwz6V70/reCxFLGlz5+oEMd5EYtHaMhbzVBZ/xEFc0XkA33diF7tIkdtRNwxxiB91WoMnKmnUc/b76nftHi2ZHAb2OixjIVmrzNL331cMXqETIKG4tcxPDp0mVrhJrUTAXpm1qchg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 6/9] net: dsa: introduce locking for the address lists on CPU and DSA ports
Date:   Fri, 22 Oct 2021 17:16:13 +0300
Message-Id: <20211022141616.2088304-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50aafaaa-7bec-45f6-3512-08d99566bf3b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34064AF71D46E1ADE64CA123E0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izXZ1nzlIFxMAessCwRDbIJaQkhYYQfzQyyPHEVUT+xCWo8fYx3astnIoLRmOYyXw4KRU2UvPv2UE3b6+9sjCA1f+qgMkvOsGasNXad1pzfadDJTSeguD3ZeHwwpjjolIV2DjyyxCIImZhGBVfrzMBgM3Mf9Pvaw0pSHztWyqb2QoXnP7C04LF/QqeLwslsEfXgmCLa2eBD0v/Cdu5LJUZxNLqX42TplIen4udJQDJe733wuYp9zFj3YuMFRAnD6MBfYwTbAUaekPcpLlS9oiDUqqnmSFJ/8UwoOxXZz9AMfGgXSykD7A6IPSHFpJ3LgS1rMlGPnKjbZu+7nlZ7w6Q7FMf3W1kWrHBHaYrc75LK8SCXhl3sXMwDpKACfOvsEGyS4Xbu0dGEjkMmfJV076DFmWpjlMIDyMO3ThbcRicZAwmBpWEMVpk6q8mDfrPdoEcwbuWJB9ljCYqhTPAO8Mj13GilGMlLUi6Lx+TgZ7Ijk7ondhvLnE5XS49t0/txzx3iEDP91lMEWwgJtWN69MFnVwvfBcWf1QPS4gHKcoq+M4bu5TJtaEscl1oOdNzrruPqJtqfumUlZpFpY3n7YLo8Xj92JDxnO03XTSGhBHojRorhUiBk9vMjUU/ndpq5q/5iYnRSZOROdx+39YwH1pnHkPST5nAPBJ11CYORZ/0KRH38zgKst0wR9jyP4RvrwhK2aidpuWZDYUAquZnjWXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tKC/SJt/zDSg3F1g/hKSczbtSnCWBs+LlqwGb792MzOGesEIQr3WPxqDAjAA?=
 =?us-ascii?Q?x3tEuhiYA92Br6/hvXYFANsFbIK7M2xdlVlY7ECqH43OwzLiqEyEsmBDpOgo?=
 =?us-ascii?Q?5jIfpi4KwIQUIx0qqdS1qVz9kObMipCcjZe8QALrqzoiRHSgKww2gP8VqQgD?=
 =?us-ascii?Q?ZbRN8chxXppUfH9ke46K2louVPvX4AJ1DpDbvZAswZu2DHITmYJJoIvV46DR?=
 =?us-ascii?Q?FE7zOBtqcVhzPHyn2y3v41V7aSH3T/FtgrPEAiEc+VDK8YJvvlXjlG01UPbx?=
 =?us-ascii?Q?4dZ4t5JRbefb6JlDRGo3C8IHMQj+X++jgSpPb2LInH1RUFJ1Ndhj3Ep6Uvrr?=
 =?us-ascii?Q?JzfJxyMprPi9c34ZbNIDX2wS/UwO5YJQlCHrGrCQkXOhQIFCJ7Z7QxJtyoyn?=
 =?us-ascii?Q?mIursCnMPkevhyrLUVOuxUiDCn4QdDaBwid1+8Wokf+TpLmkdYQxnuFYQ28u?=
 =?us-ascii?Q?y2+9sOY9P0dH+b8XbxffVGv5BPL1ghu9cxTtw4Hi9fMlpwVxIscJvbCSVhgO?=
 =?us-ascii?Q?ldqPRxT+eG1bYcUmzAWhcHg6sXrEKzfWaKiCMFkCYhE6ehqRfuUvbHOL16Wg?=
 =?us-ascii?Q?MrE66Pt57acwvMf/Mllbw5GKe3ZcUkEMvoHbz/RBGZWbzk8UANDll38tDPAL?=
 =?us-ascii?Q?TltDSDEfcnD5T0QvK4AmZSxisqGgzWH+KbqNk1dlBNnAnfpHQFZ6Qe3pnPbH?=
 =?us-ascii?Q?NW4zMpx96MqT9cKtUy+LFF/m0LqiJtYu5DNcFU4EOgw5j0F9DI2SN+9DCBzS?=
 =?us-ascii?Q?CBZj7YePtJZ9L0M11yM5dPdBFwe3LuAOzJGwxeejmFwOvft0vYeIVRZu0z9g?=
 =?us-ascii?Q?ZxllqAkvvrSD+PlkY5grh03IcsjIUDoykpLrED4H82w+esBKkjcbrX8rxAIx?=
 =?us-ascii?Q?1DABnK0oks8iYIr1xiSBINEGAwBzS4pAGEiYIni2O+7fDUQBYSvoFK3tKOsf?=
 =?us-ascii?Q?TtDdDSOeUgIpkNJs6MzKAXCUioYkDkiKjjmfxOdngY6bkruVdwneCAHWoLvi?=
 =?us-ascii?Q?Gb30g8Kr0kLjiPkNKk6kKpQiAmuAkYl8bWUuD7QoJEoBhDgixPXauFjDS4rk?=
 =?us-ascii?Q?xiqcvDbZ9smCvdgll0nJTcr1mh4BvhcmYub9twwwLSg9Z9ivj9+w8CNscHP/?=
 =?us-ascii?Q?FtpHs2g9/k0X89m/XpxBQb3Z1qYMKOZ6d3jxCvWe0TRWVeN7bOO7f3/lwlFJ?=
 =?us-ascii?Q?0WxwIt/ysWx2yS/tNUzoJqQDndRD0OF7/cy74aBnYTYIMhQBLCBMaYaXJ5mF?=
 =?us-ascii?Q?BcNLMnMITxQabUiyw9ULQq+nIZBxTL+CfQsrp1/DlJYShWugRFCRSgGYFxUP?=
 =?us-ascii?Q?QRx9SxpYcqM4hYJvEZD12djTd2EKzgFUpJwTQB0bP/xKYXlExWQ0VBBvqEvX?=
 =?us-ascii?Q?JIxTV7rxi6GVJnjADpwHubHSrX8BNJqDZVRsPC5OnJaySgZ3zrvRljb8kHiN?=
 =?us-ascii?Q?PcMy36JXoio7DexD7dLzGSarpcpgzOsE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50aafaaa-7bec-45f6-3512-08d99566bf3b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:57.8506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
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
---
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
index 2a339fb09f4e..04cc2aa3186d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -433,6 +433,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	mutex_init(&dp->addr_lists_lock);
 	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 2b1b21bde830..6871e5f9b597 100644
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
 		refcount_inc(&a->refcount);
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
 		refcount_inc(&a->refcount);
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

