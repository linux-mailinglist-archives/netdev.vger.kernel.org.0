Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DAD46DCA3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhLHUJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:31 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239963AbhLHUJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miFL9Nafkw4rvgi6w9olqF5vySZZBXSLUr1ZDYXvqH4GEGC5VtuARNBM3LKvc5b0OuFMEehncAAgMVJdPf+mlyAONzI1DNsRkjqs34CZEXqBTxvBP4TuCSeHC2EMtk/tqPUTjJA+CoPGl6XGCjvwoH6FjDpNpZ9J6hlQBBmdXWo3vkPILCCoYnk9hEYBOLM4c+PHanWx0sb7dj88MMJ3bYKNjQRJn/xp8ATimhIGxE6jPuCE/qcMIE30y2YC5GzWK+AWPGlYG+bcxOsVPTgr4SqTmKQSrU8zbV0X7C4vdRnuROLOux8K0m7aE01EXI/IK2jK0y3gF0oyZBxf89iwnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ih8FKid2V3lrLEKwbHs7Kd/C/cVavmDTpxDAhUxKt8=;
 b=f8L5nNtlOHviJjh9jNlN7qZotPwj0ndss1wqmnzcIGtFoUD5+pMbEqGGYo+2Nsk9b+FSYLxpGAI6m2ZOWBCKDaXmH7pAQRAbPNvu2QrWsI6xtCwd03QyhI9grp+hLElKTwnlCB0nK/CSYu3cICVRXa47GjE8AB9jMbhrT3RPcWjWc9YCMrm+Lmp/17yn4GVo1ipXzbLvnur6kG4oHkLDLkmvqT7hJnrL+7JojddXIKKzJXN/4paroTGvrcYpK/ahGhyy6EIVv55XlPoZHTaUiYKTWSAQMGuBxW8kwS1HyB0dnnC8VmKG0E4NxFcbrU7fFYEB119SqI/6Pnl2YFZWkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ih8FKid2V3lrLEKwbHs7Kd/C/cVavmDTpxDAhUxKt8=;
 b=EOKweF8cTjFFVMJgJTnXsSOXRmuym6e12VVmq5FzF3RaNDUSLCxjgJ+RuQMXiQMoic8QwZqRk1L9TfYaDGZEAKwxzTrfpWMkobkxfT8XtZjjSg1dO+aMII3MNc0f0lrU6YWg5VCkKEtOfDmvHJAboOBTzH27OLNHLcJfuVUCP9w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 02/11] net: dsa: tag_ocelot: convert to tagger-owned data
Date:   Wed,  8 Dec 2021 22:04:55 +0200
Message-Id: <20211208200504.3136642-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b06a61a-ce6a-4214-8141-08d9ba862043
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB6638538AB1DC2FCDD2D06227E06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+49n/fUOOAREJ4Ri2OuoxLRm9f3DurKeNtYiA5f4+KRNG4b8mr1kiKbS/hMkOnMCiDb3IKvj2j0u3V73/MiIx3XsJS8MUl55vXXDtFzc2DY0vqhGDb2PYrCjGnjKPvmuiWh3vfjmV8gQmgDK6pHoweS8m41e56sIQKcDorQl1Edk9PslIqi1iNiLCJ0Di5aKY2tYHZNsfKvrz8jM3+oDbwedu1AW0vRgFE/5xY5V0w0V6iJpkx48CWPKSx8Fcx1gxq86/dWz0ngD7LeKTiIg1+akScv95A9kyGhpiHtL7zbWFdCByom95vrGfe9cR4LGH1srd/aYYciFRJ5gJaNR0EkLvWHxcse8aAiBYOxYZjMpg2CBClRFzmBhdeukUvHQkuNgz8hgAGVhmP6TeErHNNPl9pJ4V8iIszR53+5j7CuplYlJIKCn73eZPTCWnyPG4zXiQkMIlMSIvHyFvQerhHsxyQMPo5ayK3aC1RfVGw77pwb86C5Kmnd5+umlTRXZbzt91RxnKDHGz5x1cWz+5aNMYFwAtlmeDPsqvkObUTMZoY4LhvGtO1vdiXXAqbrvXqzFi2x4Tq2g6X2zOZrNDLKRIzEXBDXvUa45xpKQmnatkB/4SfD7xxrlLVcjfdP8tkWiak8bMcKuIaqnQdVua230SP926k6pZgBElnnO6HzAHHneHw2GtLr8dSpxWhUSeQQGcWVzK2iXlvHdNHNnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(6666004)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+c8Go6jrvehz8UE+i8OscF5HdWWDNgLHP9X1An1SEKigZWurJIbzSYUVSOvk?=
 =?us-ascii?Q?EhT5qyAbdybDROVnu6b3liOdB/aeG5EjNbiZGouqMWO4+qNac/LhPyx7by7y?=
 =?us-ascii?Q?6pHyneILRvFJPXudvUGdnqw4+DeyGY5ARwCxiUz858Fijg9KE7lCMhRU0ZBm?=
 =?us-ascii?Q?+BVp9cejNRB2D0O9w21D1LH073lPCLu611EIuhDp1Fi0MIrmx3pzXzHT+/72?=
 =?us-ascii?Q?YIbSlgOSccDRqQS3SNh+U9MjfM1rYbvR51Q1h/w63ddZKtBgzMbT8oFpdbZL?=
 =?us-ascii?Q?DRFUsH3wEF0rfbuEspv9Mh3FGdIwGac+l4x52b1vy3T+aEnvJBh+0821LQ0d?=
 =?us-ascii?Q?ydepB1M5kBpJEF64Oz92orazbVe3kw+S+fQv3shLoop75d/8u5MqKYUa05eo?=
 =?us-ascii?Q?FBJ4LADAKiglOY1z82oYzCcZMb8nG6r8SqPIONEZjm7vvXSDg862gJC2q6l6?=
 =?us-ascii?Q?iQ3Cjt6TIfxX2YbNgjeof6JS9mIu+Tqt0WXlvaX8GCZ1gWYtxB0FapXZC7EJ?=
 =?us-ascii?Q?u5NFr9jobqcTGGr33M4AcwVzAD/YiSO9NZF8Ol/Nghw9r7qPZpzpPrPdiCu0?=
 =?us-ascii?Q?/53JmEJbWw1b6zpss/iff0QjEBfEt0VC7BBHgMJGaPiFXJi5G5pbP0x8hhH4?=
 =?us-ascii?Q?arj9bDA+LNfgG2oxpRpytySzQg1c8j78nG69nw+GhuQQV8kyH4a89d+EoiBd?=
 =?us-ascii?Q?0nvMULGED4WSP+fP0FgkWOiMWTuZTP36jtTwyL9SAyltHaVI9ndiWtawjc40?=
 =?us-ascii?Q?9y3qmoY5sbWC9Ihs8whvlbqBJqxr3/zi6I1tF+uNRmuLmcew0gJ0Av+en2R4?=
 =?us-ascii?Q?mmUXb6ZquI6lsorFoLHbKluMKT5UwiWud9rhTQDg2ugGtXS0nimYlC1l9wYS?=
 =?us-ascii?Q?vq5GM6Mj9ldM7m51jFJVWtFpDOoB+iHZBzfprr6JXe6M7jR49+c6bP6XxDBK?=
 =?us-ascii?Q?NA4N3U6zalwMvxWeW47prfbROYlxMtg0OPPqWObZR0SFnSKgEFKiE1n36KF5?=
 =?us-ascii?Q?YyRIu+SYRa0CWi6px017AYtlasjiKdlYui6w6wXqiqxGzPhFqu21PD7qglpA?=
 =?us-ascii?Q?ioGpLPXyAvy77y+yC4/d2g1rnGpKN+s4qPZ/dxxNUCjnbM6W3NyIXKoT2IKJ?=
 =?us-ascii?Q?a9G4Y+MCe7QEWzARo0s6jlj0C/K+J4Jy4gN1+mb04bFQYYHYivahMLWjqdk8?=
 =?us-ascii?Q?BHGsl15Q8uJXRJRu//NoDLFpzl3wA7lMNqHf+T8RUgykrzz5Rws7SSxrJ8DL?=
 =?us-ascii?Q?EpYJ2XdpkZ9dT/QY8ZqSwgeRB//0+HKfyeCOYxCAAV5uTsvz64YcL65zKGbq?=
 =?us-ascii?Q?94wIvsYMdAIAS9JPYXi1x2l1tcDd7DktY5iRbKGW40nLskEzjWTW3OjYXJHA?=
 =?us-ascii?Q?CFBUqYe1630SJUQe8v8WyjlpzpS0DbN+ogVhJCcyIsa7cgvLu+IQwvEpt4P5?=
 =?us-ascii?Q?plISQDybeq3X9YgW5j19chG3rT0q1q3iJZdNU8XS6YOeAaKOqrM8m9Dakwhe?=
 =?us-ascii?Q?TSVIRfMFN5S9LB0dlUD+NKdbxzSb/y2qjcP+lfFlYgA2PbJKlpAAgr1oERkb?=
 =?us-ascii?Q?k/OYVai17VrwMUPXMZF0lXf1HyuYDx5/uh7a9IerTwWMJtraTANR/5u+mU4Y?=
 =?us-ascii?Q?RUyAWUCPqufesJzw5QVKZV0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b06a61a-ce6a-4214-8141-08d9ba862043
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:48.1033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WjKvhH0vWKdltByorvW2sDwp9kybNYCcVnotWpeEW4N1VXR/sfxIUyJa5vFCUhATrf+hnLh1+6MpCK9YTXYQEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The felix driver makes very light use of dp->priv, and the tagger is
effectively stateless. dp->priv is practically only needed to set up a
callback to perform deferred xmit of PTP and STP packets using the
ocelot-8021q tagging protocol (the main ocelot tagging protocol makes no
use of dp->priv, although this driver sets up dp->priv irrespective of
actual tagging protocol in use).

struct felix_port (what used to be pointed to by dp->priv) is removed
and replaced with a two-sided structure. The public side of this
structure, visible to the switch driver, is ocelot_8021q_tagger_data.
The private side is ocelot_8021q_tagger_private, and the latter
structure physically encapsulates the former. The public half of the
tagger data structure can be accessed through a helper of the same name
(ocelot_8021q_tagger_data) which also sanity-checks the protocol
currently in use by the switch. The public/private split was requested
by Andrew Lunn.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 64 +++++++----------------------
 include/linux/dsa/ocelot.h     | 12 +++++-
 net/dsa/tag_ocelot_8021q.c     | 73 ++++++++++++++++++++++++++++++++--
 3 files changed, 94 insertions(+), 55 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f76dcf0d369f..a52d0809619e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1152,38 +1152,22 @@ static void felix_port_deferred_xmit(struct kthread_work *work)
 	kfree(xmit_work);
 }
 
-static int felix_port_setup_tagger_data(struct dsa_switch *ds, int port)
+static int felix_connect_tag_protocol(struct dsa_switch *ds,
+				      enum dsa_tag_protocol proto)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
-	struct felix_port *felix_port;
+	struct ocelot_8021q_tagger_data *tagger_data;
 
-	if (!dsa_port_is_user(dp))
+	switch (proto) {
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		tagger_data = ocelot_8021q_tagger_data(ds);
+		tagger_data->xmit_work_fn = felix_port_deferred_xmit;
 		return 0;
-
-	felix_port = kzalloc(sizeof(*felix_port), GFP_KERNEL);
-	if (!felix_port)
-		return -ENOMEM;
-
-	felix_port->xmit_worker = felix->xmit_worker;
-	felix_port->xmit_work_fn = felix_port_deferred_xmit;
-
-	dp->priv = felix_port;
-
-	return 0;
-}
-
-static void felix_port_teardown_tagger_data(struct dsa_switch *ds, int port)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct felix_port *felix_port = dp->priv;
-
-	if (!felix_port)
-		return;
-
-	dp->priv = NULL;
-	kfree(felix_port);
+	case DSA_TAG_PROTO_OCELOT:
+	case DSA_TAG_PROTO_SEVILLE:
+		return 0;
+	default:
+		return -EPROTONOSUPPORT;
+	}
 }
 
 /* Hardware initialization done here so that we can allocate structures with
@@ -1214,12 +1198,6 @@ static int felix_setup(struct dsa_switch *ds)
 		}
 	}
 
-	felix->xmit_worker = kthread_create_worker(0, "felix_xmit");
-	if (IS_ERR(felix->xmit_worker)) {
-		err = PTR_ERR(felix->xmit_worker);
-		goto out_deinit_timestamp;
-	}
-
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
@@ -1230,14 +1208,6 @@ static int felix_setup(struct dsa_switch *ds)
 		 * bits of vlan tag.
 		 */
 		felix_port_qos_map_init(ocelot, port);
-
-		err = felix_port_setup_tagger_data(ds, port);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to set up tagger data: %pe\n",
-				port, ERR_PTR(err));
-			goto out_deinit_ports;
-		}
 	}
 
 	err = ocelot_devlink_sb_register(ocelot);
@@ -1265,13 +1235,9 @@ static int felix_setup(struct dsa_switch *ds)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
-		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
-	kthread_destroy_worker(felix->xmit_worker);
-
-out_deinit_timestamp:
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
@@ -1300,12 +1266,9 @@ static void felix_teardown(struct dsa_switch *ds)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
-		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
-	kthread_destroy_worker(felix->xmit_worker);
-
 	ocelot_devlink_sb_unregister(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
@@ -1645,6 +1608,7 @@ felix_mrp_del_ring_role(struct dsa_switch *ds, int port,
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
 	.change_tag_protocol		= felix_change_tag_protocol,
+	.connect_tag_protocol		= felix_connect_tag_protocol,
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 7ee708ad7df2..dca2969015d8 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -8,6 +8,7 @@
 #include <linux/kthread.h>
 #include <linux/packing.h>
 #include <linux/skbuff.h>
+#include <net/dsa.h>
 
 struct ocelot_skb_cb {
 	struct sk_buff *clone;
@@ -168,11 +169,18 @@ struct felix_deferred_xmit_work {
 	struct kthread_work work;
 };
 
-struct felix_port {
+struct ocelot_8021q_tagger_data {
 	void (*xmit_work_fn)(struct kthread_work *work);
-	struct kthread_worker *xmit_worker;
 };
 
+static inline struct ocelot_8021q_tagger_data *
+ocelot_8021q_tagger_data(struct dsa_switch *ds)
+{
+	BUG_ON(ds->dst->tag_ops->proto != DSA_TAG_PROTO_OCELOT_8021Q);
+
+	return ds->tagger_data;
+}
+
 static inline void ocelot_xfh_get_rew_val(void *extraction, u64 *rew_val)
 {
 	packing(extraction, rew_val, 116, 85, OCELOT_TAG_LEN, UNPACK, 0);
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index a1919ea5e828..fe451f4de7ba 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -12,25 +12,39 @@
 #include <linux/dsa/ocelot.h>
 #include "dsa_priv.h"
 
+struct ocelot_8021q_tagger_private {
+	struct ocelot_8021q_tagger_data data; /* Must be first */
+	struct kthread_worker *xmit_worker;
+};
+
 static struct sk_buff *ocelot_defer_xmit(struct dsa_port *dp,
 					 struct sk_buff *skb)
 {
+	struct ocelot_8021q_tagger_private *priv = dp->ds->tagger_data;
+	struct ocelot_8021q_tagger_data *data = &priv->data;
+	void (*xmit_work_fn)(struct kthread_work *work);
 	struct felix_deferred_xmit_work *xmit_work;
-	struct felix_port *felix_port = dp->priv;
+	struct kthread_worker *xmit_worker;
+
+	xmit_work_fn = data->xmit_work_fn;
+	xmit_worker = priv->xmit_worker;
+
+	if (!xmit_work_fn || !xmit_worker)
+		return NULL;
 
 	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
 	if (!xmit_work)
 		return NULL;
 
 	/* Calls felix_port_deferred_xmit in felix.c */
-	kthread_init_work(&xmit_work->work, felix_port->xmit_work_fn);
+	kthread_init_work(&xmit_work->work, xmit_work_fn);
 	/* Increase refcount so the kfree_skb in dsa_slave_xmit
 	 * won't really free the packet.
 	 */
 	xmit_work->dp = dp;
 	xmit_work->skb = skb_get(skb);
 
-	kthread_queue_work(felix_port->xmit_worker, &xmit_work->work);
+	kthread_queue_work(xmit_worker, &xmit_work->work);
 
 	return NULL;
 }
@@ -67,11 +81,64 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	return skb;
 }
 
+static void ocelot_disconnect(struct dsa_switch_tree *dst)
+{
+	struct ocelot_8021q_tagger_private *priv;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		priv = dp->ds->tagger_data;
+
+		if (!priv)
+			continue;
+
+		if (priv->xmit_worker)
+			kthread_destroy_worker(priv->xmit_worker);
+
+		kfree(priv);
+		dp->ds->tagger_data = NULL;
+	}
+}
+
+static int ocelot_connect(struct dsa_switch_tree *dst)
+{
+	struct ocelot_8021q_tagger_private *priv;
+	struct dsa_port *dp;
+	int err;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		priv->xmit_worker = kthread_create_worker(0, "felix_xmit");
+		if (IS_ERR(priv->xmit_worker)) {
+			err = PTR_ERR(priv->xmit_worker);
+			goto out;
+		}
+
+		dp->ds->tagger_data = priv;
+	}
+
+	return 0;
+
+out:
+	ocelot_disconnect(dst);
+	return err;
+}
+
 static const struct dsa_device_ops ocelot_8021q_netdev_ops = {
 	.name			= "ocelot-8021q",
 	.proto			= DSA_TAG_PROTO_OCELOT_8021Q,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
+	.connect		= ocelot_connect,
+	.disconnect		= ocelot_disconnect,
 	.needed_headroom	= VLAN_HLEN,
 	.promisc_on_master	= true,
 };
-- 
2.25.1

