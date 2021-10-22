Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A63C437BEC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhJVRcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:45 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:23297
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233727AbhJVRcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaRMs2bpowbXlOpSm5GIqaTuExgzSf9DNVMziyDbelKw6Y9asr0I2KkE+S1x5Jqa+r7h+XSMfTf6q5aXR4APRLiG1v+aS95hIDTmbQ307vJy5dbCOV7UTlSJ1HSPpbTKF6rSx/WT0CVpR2k/GGL3N1K9r73hc520RbYhOhoUGy2Tvme9nHU9UUV3r/9yU71oWr7g38Ki+bts2fJB74fZ9q9nUHw4Heh8bmBg9FSQvMpVO7K8I25FK842JPZUmUKHnDMxxEexSvtyz/auXjsw0ZJD8Meln3wDBw8aAOkeKoyap46gBPd8jsjXkl4Ek41KfoMtwpMiNVkSdgb6EbndeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LqUxvHH8jhKbq0wfVTqCFzwykjcAaEd887tllubKy+0=;
 b=M5Ozx2XTqzDhYIu+9RMRF9+O7hUlvT/9B+0AMsOXIs2Tfd5XfbQ+s+9qa1IqlSOQQkEQx4SHSD3x2+zoEX3fVkoFUz3OMH5WfC0XGZAGvpjTxekOeqKvmTTvXhUVgEZp28nFoLpgtj1OKH+HWEvOxCydrQ5rYBBFM087WfFKVC5T1lKVO8VNzTKpHZpGKUCGjScu3W+NkmLbzDPG2mBh6CVoZuj8/ViEXXLKDD+iS83pNdh4JMfiRnN43aAXWGhYasd0L0jbkGMPV9yAxDMQWE34GtK5AHv74/96tGrHOlH9gtBrlteQJsgkxwOmD/nnxtnRd/kCdWNKrttrwk4IcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqUxvHH8jhKbq0wfVTqCFzwykjcAaEd887tllubKy+0=;
 b=cSbJ9hbKsUoSjdNnexumwmoI8k6ZughpHJgGXVqULj7kVR7EoHLaOwnTzsJqGZhs7/8OSfI3Bd7hl6zK3IOTsxNgfmDqTeYr6wKaD1hoToRixwPM7rtknpA951pjk39KnW5svkPhm/pvuv/tYQSZz7Q3pQPNbKCkbZQLpNKcuoQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:18 +0000
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
Subject: [PATCH v3 net-next 6/9] net: dsa: introduce locking for the address lists on CPU and DSA ports
Date:   Fri, 22 Oct 2021 20:27:25 +0300
Message-Id: <20211022172728.2379321-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a1a6a00-f8f6-45dc-ac99-08d995819db9
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504B09B155D65A0AB9099FFE0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7w82Sbzz//Isy/IzjChJDlHVU0mXvT8FINf+kXWHpskSPXbvhZ4iZXpkAND2VsQxSa0NlsQ4k0oVezhu5sG5AMCVnQ8Jft/WwuA1KILZjxd7QATJR5bHofKSNKMp/6Io4m/1wQg+ZwOc36IuESGY/D0b+AtyauM3vktGKQBo3FYjC7ptk1jmt/MMNfCeqvrkKqcuMl7ekULc6QqE/8FuAF9kcj16pTEGzYSAUiIZEQPy1wWYqmw+Ix+O1/VQmKd587S9CflETyq3S9sWodWGool8qEmWlGj086DEbyMFL0LZyrDHXazI78bJjxq4I6owwEfSjSuTZ7zghLRhibV3frEBOmN76+XWIw/PkhZEF4byfno2L/S0v8WMKtalrK8cv1T46aqCl/jDWcgzI7588lx2uZfF54pqBYTGVbVs+zXMxn6EJrVMMOiy96zWRqwfEHwzwf0qZ+eJUMWr3L3OkFg0fVJWaddT1CK5iBiAlt0wrlv5cESrtK2F8vsy1DLAyZce8V5y3AxsZGBuCH5Z9Hz7bPM/w91mj+rzD9TxV8ue/kb/dxsA3q4Y9QzFucXsj/mKTmNgduOwkBHGpQVDAV8MjxCgKJRQ9X3vwuV/xf6XImpr8VMV5nwTHuP19rSO6Adetjwmg7fuJT2xmzb0XgN3OXICD020q2FyXjVFP+DUg5xQhh9wB4AIl5a6I/qMv0uNu3J9NDyyM1xYbxJR1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9/2OvplUvwOorS/T0UNCd3jqv/ybukUq2frP3+H03VGBUEepqfGi1AnLQ7JU?=
 =?us-ascii?Q?7n4YLmugfqDpT7fClktHS1r+CJUmg1IUhugP+6po8NuB8NxRnRZ6al5WbN+/?=
 =?us-ascii?Q?JaLz5v2vrTpu/SNunowAkaDwwNJqdKMNcYEFe7+xpTbaSA3sl0n2TFt7G2zC?=
 =?us-ascii?Q?GJ5UgpExDwmlRtZvcYMyWj9Ab8o4oyBG6RzaZdXOeESueVYAIzMvFzEABwnQ?=
 =?us-ascii?Q?9aKQrywv5TkfPjDf+FyYXKsMK1kXWZe2Hxk0L1saohuJ2LeOFM/Tul9qXIP5?=
 =?us-ascii?Q?4iQZ5PJctT73sCOoY7VWcgERfK1oBsNyFBkSixDxC5+kft0U8gOZvGlMMVt8?=
 =?us-ascii?Q?K7W6jvjMeI/At4Ovq0GVv7IWQ6CL+62L5f9DvAjJzeOquFh7aYDsuKshQnmw?=
 =?us-ascii?Q?wWTq+nirXtlVOysiWwIYqndWsMz96UzPvwH0Atp69dwdH713BcFpNPBh/crA?=
 =?us-ascii?Q?sLnVUpzSEpU8NeXMw/ClHtDwRJKzDpKufx7YXa8vDTFSriRgdeCBiIrJPziF?=
 =?us-ascii?Q?4AvxEiVbllaLJu4ymwjWjBtL+BdcXL1YLcinokenLR4DvP10z6N4ojtxP6V1?=
 =?us-ascii?Q?occDK7mO521fJS4ktSkQxol0Fn5QE+5tto9btBhcl46ZNxxkXQtPf5OymTQF?=
 =?us-ascii?Q?/po/QXZYGxEZFg3TYgY5AUJA8sj24Led432/mjWMeG9qV6cCbO7lfH/+FTka?=
 =?us-ascii?Q?R6VN8AGZxqeqZVOI9uWmMizJCm/CsBiEIY9LmXCr/u4efhhLInnw7Fl0wgIc?=
 =?us-ascii?Q?Li5Y3QBoV6DOM9yG9V0rjYlNy1ZCitkzIs52anpSx0srIheoqMw8U7maQDCc?=
 =?us-ascii?Q?QWumgKaIcCR8yuyScV+YEEM3stsh0GaZpIVmBGcUVQ+TIYhoZGy7c+kY4tUF?=
 =?us-ascii?Q?+H11fmiHASRc1ilPDbjZEV1SVhV7JdH6fahi99ibNY8tGRnGlHoyj2dio+Tb?=
 =?us-ascii?Q?7uEmR+OWKq90rOs/g5zl5bgDAPZ54Bd5A82YbN56Dg3OUUK+aYWnTGu54IKf?=
 =?us-ascii?Q?JyCyT/sgLwM94aYFq25WzhGvr0a55PPtspS8iWyKXWEbOALphBoujim5V3nb?=
 =?us-ascii?Q?ZnvK0r91oDjludgDjZp75C8Cldd+miZrnJKA4crO/01FRfp+2jKOMQ7N/iC4?=
 =?us-ascii?Q?9k0G7rsPtpCXXhk1dzVwwhQJXn0j1/rUmnBZjfeSbJEsl9ZScNcLMQ3uMpIv?=
 =?us-ascii?Q?uYzV3d5NYImBMWx/5kqNCAi+LNIWAB1TnhX3j9A1JtV90bmP3jkHmObsXU/B?=
 =?us-ascii?Q?TMIwC/8ulaf8iQJlSU/3NPKI3j/IJxgh6zcgP7Peti9vohu463Cfq2E1eMez?=
 =?us-ascii?Q?2ii8VK5Y60D4TMGloUy+RMR3I3UnYjDAUXVeXr+OWegLCIMv0/Wxx5nhtdGG?=
 =?us-ascii?Q?A6zrwdZU+vC5m9kyDhwGmYN/2K3Gsiwc0i/byvZFH9fD7PeZ2tzoC5RwOmvA?=
 =?us-ascii?Q?hOU9ybBrsuxjslcEeRCGczKhttLBE5l8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1a6a00-f8f6-45dc-ac99-08d995819db9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:18.0905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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

