Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85163F2B9D
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbhHTL6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:58:46 -0400
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:42303
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238099AbhHTL6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:58:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0k+dhEsFu1/SDDiWRuJIyQRUiVAj6biJrIkV9bJojj67F8qWdf5avFPRUFaVg7B4Th/2mm2vDjd3M3diWYTkB9dDHgsaNIb7vGU6RtOH5su/hD24TUp0/mhe2XMrjIWg+ZznxTww5MXw57J4z5tyvVD8WS+dlYWUzxKS50kFWbM/J+B8ehseqBqAl7vcnuR0St5lbBTvFvaNFi+N/lEMCDHgu4uAk9KIGIWJRwo/118NbSIZBXx2hvq6Nu8K/XI0i7x3MLeJ5JztfmDcsAJNKCdvvzWJbRniLEpgTrHkQVpFbzd+takTBRpI8rTIUb2NlwOA2o279aaf+VEdnHBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Rhfy9Vmf2/2QzcvnqXC0SU84qWd5kqBquHYJ1jEOho=;
 b=FgSJ2OSSsA/YkHZziiPL4A1oizdf1bQNjTZl6Omp5bNAFYcSuLOyTC7dKYhrnhhDOmfuv2jX0AOw4McmbzuNhX8m66OBkVaODpqaTJ1ng9Nk7uMeqo9VOoJbMUyGIpw2Bkb1Rn8qKNR9a6yFXXQjPjk/u0MIZGyTJHV3VHT5Ei4NTVTh9drEc8h+SnTrJ/IgioWpy34mnCC+TedEHLqTe0uQVY4k9SpQCM3a7M3GV8Ong9Fzdchbei4vh/0FQqHgm0LrI3omTuB9cAcNSNKho65bWNCVkyurG6YbUV02Pex5FW0dlDqKKo9lqtVjyhRaQ891WSqrLnPFr/gGreyHtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Rhfy9Vmf2/2QzcvnqXC0SU84qWd5kqBquHYJ1jEOho=;
 b=Al/SS9IHRuvaE0Kd04LPtVk8Wua4qOUJTx5CNDrUtes5No7XJ7iR1CgA4CNmOLdHObCvcBN531MOv6e9yeym5vdolhwcLx7JoJyIgrKQbpwT7G13W0i0AtGOLVsdTNgPNdxEZWFGx3sT1jN4JW4EsQQihOl/rhfIeiUsu1hPVC0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:58:03 +0000
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
Subject: [PATCH v3 net-next 1/7] net: bridge: move br_fdb_replay inside br_switchdev.c
Date:   Fri, 20 Aug 2021 14:57:40 +0300
Message-Id: <20210820115746.3701811-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:57:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acd89728-a121-4d53-c227-08d963d1c358
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839F52B6EAD4AC6A9D0A2EFE0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6KOUNlIwubgrGcd26R5R0nppTRQKxe9pcM5Ay11HgAqazcG2lZKPM2+x5GvD8sC0nX4WYBuLFXi2QN+MlqJf7WbaqoulqeTTQKHLrJ4pmvMib8R+8aqTwTMny4p63XWKvzcz26zfO0Jxn1o4wzEMqzYL15mhQ+wf9Y0wE9AnvEx087SxGPE2VFinC9FOQdwJY8vjscKlvSDoTiCl7SfP7kn3EITSdDIrwNRThJFppAuEeV1ByddkheDO2p8/0STdzLSE0hEbm4ySBSHi14JOz/g8IuNWtHCsRT7stw91zEcfMbEqWxMko65KcmdtT2CrgfNFGhnQNeMmtrlXucIwQIBClA9u9JaokupFahHauGX2XxbMZSpFrDBbqHfv7lNOyk9vZ5vZKzk0N+I/vRkEMWc6pz57pNZyLHA+nuql21mAA11gzXvX5pR23gFPaoeSEaXUHL8tetzJ8W1sc5KX6SkJK7cl5XmMyebmXWANvHY8AAx9XnycNI9/2Zqf/L/FU+LHsAH1e1Dc7UHzZd/9XmyEKbKVNqMaAvR6zoghdAYshSKCIg3vjTN36X9Wb9Y/pA5N9GQY0ECj5QYjhmjm028FeM8SfvD4sS5K8+83fvpp0BXtkimv765+0epD27PozsKj5LXLYZw3o2IpxLZjHkMtGXwIUwcyCApYq2blpSVOONW2I8luofdFbgJrFm3bVIv9rlMxVz+Ed8jsOVTWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYnuraXQdVpgT2oEJAs0fQp/TOppRG3hWUWton+ebbpUv73uPKDuEsJ3FzkM?=
 =?us-ascii?Q?ZPIu1/66t6BYVO7oDH/dcDwqjoREqm3aCGw+67kMomp/7pjUGXCcCM8LvHTH?=
 =?us-ascii?Q?CZEzjtNsUkUc27nxO4Ybnjyyrx9IO4eZ+9vKBtjg7eqOaj9IM4/ROQZEp7zJ?=
 =?us-ascii?Q?MrFYMeDDPQsTWVhyI7owGQynwS9qoXAYLG1XUajJsk+eYkpLyCJsqRi5RyPs?=
 =?us-ascii?Q?/vswd0Ek3EhmmTdFluJhI8V2JnXgd42f60MxvVW6aHsPU+as2yESKD4mw8CB?=
 =?us-ascii?Q?V35ZPUF504TjJt9CAp6qUg3zwmXBMM9Kydh/nPldEAoc1TFxeiD/0DOKYG+V?=
 =?us-ascii?Q?NUduVYgc7QhGo01UZ0PF9wVvfr4rgz0PuA2xhla78kHEOnXjMyRMyuvFWWAg?=
 =?us-ascii?Q?g+U6c+pL825iIgTDCbkDk+vVp5ohJHxsjdXWmW1b1x2xdxfP/XMkYDp44ivT?=
 =?us-ascii?Q?UNshJuKOrhA++9T/RKYXnedqVXtPnFV9bpREDufqL77Y4ZUgN1IFo8wJ7oSe?=
 =?us-ascii?Q?oik0dIQV36Kzczgt8cTkXg6GQVQanqEHfyey/urUBNhzZ4Q73sbFdqPuH+pO?=
 =?us-ascii?Q?Osuivsb9U9cAcGTYf/JGf5GW5dos/JJ6L30mv4+/Gd6g4QqbuBYfziG7246T?=
 =?us-ascii?Q?kFeUGvwdPeqjmaXJuw6bRWblH0TFZM4VmOnJ4y/ANDHPkceaUsiX4sm4oT+K?=
 =?us-ascii?Q?fN2SbpVuA7GsFPonKphiKhs4MgfQ6iueFdOiLqtHoJ3i09C+1Hx22yUzVmvP?=
 =?us-ascii?Q?DMZqC4K0wW32f5/pt2KSKdRh1G/q6riZd8lqMhMdsonHH+njnb+v6qpGFqV4?=
 =?us-ascii?Q?Fgc6t4JOrOrqq6HpYApFtgDDrzHXjHntG+YMmSaUgq7Rj5oDRRVCxhmSNfSW?=
 =?us-ascii?Q?PNs0uqAYesjwTDaDzaRSjGubxYvUoHXXOQfydHQpJUQn4NkYFV3It3QRe54q?=
 =?us-ascii?Q?HjUsw1rngp/octESLyMqGQtnJIiK9LWueZs8yr3h37wTa302Ij4xJTjpRzmD?=
 =?us-ascii?Q?x40vD2tL0pFjsYLcFo0kSG5O6DzQP+M29s1/eLY2Q10JWzX5XOi30WNmS4gw?=
 =?us-ascii?Q?qQPp/apXO5VFvMDNVP2pIvqSRnQYSAKaQk/e7dhHPeySniFALQDoP7OSYN4n?=
 =?us-ascii?Q?daMVg7DeGz0oQDokHjujPqb/H/QkZrXpiKzizaoVXjy/e0DZNQTWuUyJNwiZ?=
 =?us-ascii?Q?NcI4C+enTiuljfiAhbJzK7gV/3FWK7w1621qcxdanMYW2UhRkHjmOSkzHgH3?=
 =?us-ascii?Q?SlDUgYALE7n46DwoOkjgaf8ba9wf3VIUSl0Xalev98Y+U7FlS5NGCWavxIcO?=
 =?us-ascii?Q?U+8+1xiaXHkjOg76wn9IFcui?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd89728-a121-4d53-c227-08d963d1c358
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:58:02.8783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpnxFukSgOU+DkfZbrXaMg8GW0DX+I3j+/YiXG35p2aqOYqre6qTMxh561zReJWwcwPxl5Af63e7/Mq3HaOtmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_fdb_replay is only called from switchdev code paths, so it makes
sense to be disabled if switchdev is not enabled in the first place.

As opposed to br_mdb_replay and br_vlan_replay which might be turned off
depending on bridge support for multicast and VLANs, FDB support is
always on. So moving br_mdb_replay and br_vlan_replay inside
br_switchdev.c would mean adding some #ifdef's in br_switchdev.c, so we
keep those where they are.

The reason for the movement is that in future changes there will be some
code reuse between br_switchdev_fdb_notify and br_fdb_replay.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 net/bridge/br_fdb.c       | 54 ---------------------------------------
 net/bridge/br_private.h   |  2 --
 net/bridge/br_switchdev.c | 54 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 46812b659710..c6e51701bc37 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -732,60 +732,6 @@ static inline size_t fdb_nlmsg_size(void)
 		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
 }
 
-static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
-			     const struct net_bridge_fdb_entry *fdb,
-			     unsigned long action, const void *ctx)
-{
-	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
-	struct switchdev_notifier_fdb_info item;
-	int err;
-
-	item.addr = fdb->key.addr.addr;
-	item.vid = fdb->key.vlan_id;
-	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
-	item.info.ctx = ctx;
-
-	err = nb->notifier_call(nb, action, &item);
-	return notifier_to_errno(err);
-}
-
-int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
-		  struct notifier_block *nb)
-{
-	struct net_bridge_fdb_entry *fdb;
-	struct net_bridge *br;
-	unsigned long action;
-	int err = 0;
-
-	if (!nb)
-		return 0;
-
-	if (!netif_is_bridge_master(br_dev))
-		return -EINVAL;
-
-	br = netdev_priv(br_dev);
-
-	if (adding)
-		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
-	else
-		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
-
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
-		if (err)
-			break;
-	}
-
-	rcu_read_unlock();
-
-	return err;
-}
-
 static void fdb_notify(struct net_bridge *br,
 		       const struct net_bridge_fdb_entry *fdb, int type,
 		       bool swdev_notify)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 21b292eb2b3e..390c807d1c7c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -778,8 +778,6 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 			  const unsigned char *addr, u16 vid, bool offloaded);
-int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
-		  struct notifier_block *nb);
 
 /* br_forward.c */
 enum br_pkt_type {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bf518d78f02..8a45b1cfe06f 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -270,6 +270,60 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 	}
 }
 
+static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
+			     const struct net_bridge_fdb_entry *fdb,
+			     unsigned long action, const void *ctx)
+{
+	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
+	struct switchdev_notifier_fdb_info item;
+	int err;
+
+	item.addr = fdb->key.addr.addr;
+	item.vid = fdb->key.vlan_id;
+	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
+	item.info.ctx = ctx;
+
+	err = nb->notifier_call(nb, action, &item);
+	return notifier_to_errno(err);
+}
+
+static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
+			 bool adding, struct notifier_block *nb)
+{
+	struct net_bridge_fdb_entry *fdb;
+	struct net_bridge *br;
+	unsigned long action;
+	int err = 0;
+
+	if (!nb)
+		return 0;
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	if (adding)
+		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
+	else
+		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
+		if (err)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return err;
+}
+
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 				   struct notifier_block *atomic_nb,
 				   struct notifier_block *blocking_nb,
-- 
2.25.1

