Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491003F2BA3
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbhHTL6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:58:55 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:31328
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238179AbhHTL6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:58:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiI3m/nMCn7UKjBw5rb+3VtenLEOyV5TrYBFTjRsGbehQXnI42R+G0HuLBa1NV9VIbdFIJtbY+eJIFPuPRY0t7zC/OnjN7pyxW0r82OkqY3BNhanSbRJDKwsqs7CbuoZzR+XnCN4rYafFa0ok50Jn4+nEOB9oY2IZOWQYu2yXUTgHWeE6+QmoxDO+mv1QOytyq2ahVWLJPiYcXTxS2g8j9sbRG/RVPanYbItGOXi8N905gh49F3S68x6MQI20o9c4MJPKoHoNkB0OjgY0uyfjJDP1veHZ976eg6Ddrzy50BDduIUKq8g9USNHRoWe+UZKg7U4E2QxANPTuQ3qWIH/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVs6kfSZV/g+gXyBm44P3bIRSU9FdLqcXcvH1uhhtzw=;
 b=jO/dTLIFZXPgcpeyD+9OAHP7T0P905gQVW0pB9R5PnTIHL9lJEbtpIKFV9azrE/nUmGtDX2+6n6Fhw+ZGCORJ7A8QeUvpa6382UjqVpuaE4Us8VLW0UdzeXh+UlLcpepCMV8g17lfvGWvleVrntYanlv4nUEk/zfYcm3zpdgPdYcB5BLqbEbzCEfFGteOFpzMO8xlgssFBe079C7W8p/eQs5XYrYZm/G6/7zYvWpdXaTS4AXPQm2cgC5Ryv767hNk7UKc51MnLWgRKjjW0+254+l9qDsQWb4/p2iVwf57m8vMuyfg3m1lQQyt3MF9oe1dXfh14bSgakfyLQgDka+YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVs6kfSZV/g+gXyBm44P3bIRSU9FdLqcXcvH1uhhtzw=;
 b=YA28ZTnJvpTUAoq08CSAu+pXDVBC/8B43qoV600XzBmyI3YO7YVGczENWgGhXqwHFKgP2gDsZA1f0+tr+fq0SOVT35CkYdYlha8fiI5KuxxFh4ypFPP88M1atfELlWOoAn+L5SGK2ubZ4rTAOVGmppCeDYZ4JNFgMioA+NkqgTY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:58:12 +0000
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
Subject: [PATCH v3 net-next 4/7] net: bridge: switchdev: make br_fdb_replay offer sleepable context to consumers
Date:   Fri, 20 Aug 2021 14:57:43 +0300
Message-Id: <20210820115746.3701811-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:58:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a18f6002-8129-4a8b-50fb-08d963d1c920
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839958A01E0D9621EB0B710E0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDFQFm5Sq6slaODIxESZYucq4fy8vSTj5qTy6Spjl5pEUXKkke3oW+i4+MpLnICA+nac1S96GGfTBjL2ZuRHlNaSbKBNCEYg2i7FkQrT36WPVSOHvKf49kWAGzq/KrioY9QBgW/MMELXfD7HRUwymDgfix4vDmA9LoC6qOi1mq4Tg9+JyXEnO1E5hEJDWM48Zer92JnLnQxo4UT1F4QRgyXFjsBr7+Kbs2o/Or34cLNMten+HjI2nZCmBmRQCMhAAVIGwhzIbSuZTpKyJ8wG+8cmwv1qJw1oejS0/T8/jQTw2RYNibyPNZNuDj+1agOPVeCnwgVfUNqk8T/tNUrIEGcY/7j2d8EDRDndvLz0PSTlYFP1i3gmPFmIMux669h/C5CW1g7+PqjKD9nTDgePW7CF8TxejBhWZydMGY4EJxST1GEu7FGPI4o0xnVuYKlTNnbKRB0eA6Z/1UcN9CCuDX9sODOzOyjBsjuoqI94FgEE5cFQ6JaNwUaWFsprVZz2SXXVunOurZMq2g9kbvP86Df3jNN3YB78qpKVqmdbkKsytqZEaFb2zlsfy3uQOs+A+SWP9fz3uhUofxzAIvjB00cOVbSoWsEHttwpAfAKSEJEXDzBoHH5K3JuGnmlneBtcdx2IyFIbKNEH9DuHb8WbrdiB4Tfgpg6qstoCjZ/y1+jrhQUYdDhVtpYzHVS+HGWbsujquqZKDyRkFqhk6qUow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qVdEAEngStD84rBG445PYKffnnQrXNsbHs/UFhl75IWzsbbTz00WXcz1h1mL?=
 =?us-ascii?Q?0LelrwKidWLgOe0H9lAbe6jr+hs7Am88vNPXkcEEEcGfFpaqvrs0KTqI/w3F?=
 =?us-ascii?Q?zWZ4YL3bnJiIRnzGkduNDurjAYndHyiDx6wXsXJOI4qUBTlCRjXuyWrm6vxN?=
 =?us-ascii?Q?cgUzczb+m0CUR7EYc9zlp/vp6EVmniiPoQGEOCakhb9jSenalk5QyqtkoGvU?=
 =?us-ascii?Q?EIX91qYURmZ+rjGKMJTdIkYKm1aK2r8QXwFVrkI+MAESWWW2Imn4FD8HP1Qs?=
 =?us-ascii?Q?Nu3gCMtKWdkdsdA85XY8qeeK5pQjuWjt2WdkxI+A72nktjnWVatWHOLZGKPr?=
 =?us-ascii?Q?QoRmCUzMGyuT7kXIDuH2wxDfE8QnLulLFzZzcPwK9q28P04CH3JciMy7ssUS?=
 =?us-ascii?Q?Ca1nUAweYJ7Cq1x3p5/Zns/K0ghndF8ozsq2R2ShA0FrsLbnkiwabt8nThGZ?=
 =?us-ascii?Q?PXkB+Som9Bg93RxPMa/sXYdSZ5KDf5ozmcwT+uiY5sj4Exbsk3N6yRFejHLa?=
 =?us-ascii?Q?f9HK+z8i8cZ1r2B8pB6jB47qP5hyYHN8zt6qEixFwkkAflZM9Akgo+r62zWT?=
 =?us-ascii?Q?/Cp4UQ4FmHkJSvSGwpuwO9gBscKINbj/06UfLgjeX/OTaixc/tgRJaMTSMoa?=
 =?us-ascii?Q?pow9+/+h96hDp834FIncwqtKuIw95FrL3qYJH8J5h/OIixfzhhPPyTx1lvf5?=
 =?us-ascii?Q?tV4WiI/SmD2unEehFnVPyiKOaXpUWxBeRNXRulZ/pRI1aZJ6+viHnJ91gQ/R?=
 =?us-ascii?Q?0ujP8ySrsUhbewduIjXC98HgncOV3Cta3rvlkZloLrmav2ZPN5bG/CsYG/lj?=
 =?us-ascii?Q?lX0LxzADRTifa/q83zFDqdKWqJsPKfBtGRdEDROk9wsXJnALn+PsjrvEflmy?=
 =?us-ascii?Q?lkPSBuLPabYa6z3kPmG/PCOTprYV0VBvw0/DJagPBbZXLEuVvQMQtQ4omyun?=
 =?us-ascii?Q?zep8q7nYPAPbpyXuAilKT8r9qTGRXq9yLZ7w9nruwbyTUwYepi4CJDCMYgnS?=
 =?us-ascii?Q?nf3aoEFryX27kMuVE55JLk7JXwHFMdkieENXea0IaZK9rRzf92AP53B+sZmE?=
 =?us-ascii?Q?DkOuN4rbv82fAljuhhTnLSvu6y0vNxQU5rlbvzwTe+RmOni28OyO/slQ7xEl?=
 =?us-ascii?Q?Px6l5K+avwO8VgRDIy1EKWLvrWu+N5WQqbNWOSqftWcEjB86h7TqeFqeyjmy?=
 =?us-ascii?Q?x8sIwmwNnWfmVBBWgl6SGv+jxbhOEtQDtKpCGPtpaIltNcHF/qr8aCaJr+oB?=
 =?us-ascii?Q?SXSx1xGgUsUuybkR84e9BfaMaddPcUXdZ72eJhv/TJrHAw3/8Vy5Jq6fwDxa?=
 =?us-ascii?Q?hsQDsdYXeob8kasq5u1Fg9CL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18f6002-8129-4a8b-50fb-08d963d1c920
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:58:12.6437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SoiU1Qx5MNuQPL6j3kv/Y3Bz71mQVLzgOKQ3PqxuvC5SeCMYD+NCjq7moyu+m3RdFzqMYfHxwh746jPGqkZKnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events are notified on
the blocking chain, it would be nice if we could also drop the
rcu_read_lock() atomic context from br_fdb_replay() so that drivers can
actually benefit from the blocking context and simplify their logic.

Do something similar to what is done in br_mdb_queue_one/br_mdb_replay_one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
since we want to drop the RCU protection early, we need to copy the
fdb->addr from the bridge FDB entries early too. So we need to queue the
FDB entries as switchdev objects and not bridge objects (those still
have an "addr" pointer and not array) and keep them in a list. So add a
list element to the switchdev FDB structure, like we have in struct
switchdev_obj too.

 include/net/switchdev.h   |  1 +
 net/bridge/br_switchdev.c | 88 +++++++++++++++++++++++++++------------
 2 files changed, 62 insertions(+), 27 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index e27da5bd665f..5570df4d9b76 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -218,6 +218,7 @@ struct switchdev_notifier_info {
 
 struct switchdev_notifier_fdb_info {
 	struct switchdev_notifier_info info; /* must be first */
+	struct list_head list;
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	u8 added_by_user:1,
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index c7c8e23c2147..f2cb066e3ebb 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -122,21 +122,30 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
+static void br_switchdev_fdb_populate(struct net_bridge *br,
+				      struct switchdev_notifier_fdb_info *info,
+				      struct net_device **dev,
+				      const struct net_bridge_fdb_entry *fdb)
+{
+	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
+
+	ether_addr_copy(info->addr, fdb->key.addr.addr);
+	info->vid = fdb->key.vlan_id;
+	info->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	info->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	info->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+
+	*dev = (!dst || info->is_local) ? br->dev : dst->dev;
+}
+
 void
 br_switchdev_fdb_notify(struct net_bridge *br,
 			const struct net_bridge_fdb_entry *fdb, int type)
 {
-	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
 	struct switchdev_notifier_fdb_info info = {};
 	struct net_device *dev;
 
-	ether_addr_copy(info.addr, fdb->key.addr.addr);
-	info.vid = fdb->key.vlan_id;
-	info.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	info.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	info.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-
-	dev = (!dst || info.is_local) ? br->dev : dst->dev;
+	br_switchdev_fdb_populate(br, &info, &dev, fdb);
 
 	switch (type) {
 	case RTM_DELNEIGH:
@@ -270,32 +279,43 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 	}
 }
 
-static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
-			     const struct net_bridge_fdb_entry *fdb,
-			     unsigned long action, const void *ctx)
+static int br_fdb_replay_one(struct notifier_block *nb,
+			     struct switchdev_notifier_fdb_info *info,
+			     unsigned long action)
 {
-	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
-	struct switchdev_notifier_fdb_info item;
 	int err;
 
-	ether_addr_copy(item.addr, fdb->key.addr.addr);
-	item.vid = fdb->key.vlan_id;
-	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
-	item.info.ctx = ctx;
-
-	err = nb->notifier_call(nb, action, &item);
+	err = nb->notifier_call(nb, action, info);
 	return notifier_to_errno(err);
 }
 
+static int br_fdb_queue_one(struct net_bridge *br, struct list_head *fdb_list,
+			    const struct net_bridge_fdb_entry *fdb,
+			    const void *ctx)
+{
+	struct switchdev_notifier_fdb_info *info;
+	struct net_device *dev;
+
+	info = kzalloc(sizeof(*info), GFP_ATOMIC);
+	if (!info)
+		return -ENOMEM;
+
+	br_switchdev_fdb_populate(br, info, &dev, fdb);
+	info->info.dev = dev;
+	info->info.ctx = ctx;
+	list_add_tail(&info->list, fdb_list);
+
+	return 0;
+}
+
 static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
 			 bool adding, struct notifier_block *nb)
 {
+	struct switchdev_notifier_fdb_info *info, *tmp;
 	struct net_bridge_fdb_entry *fdb;
 	struct net_bridge *br;
 	unsigned long action;
+	LIST_HEAD(fdb_list);
 	int err = 0;
 
 	if (!nb)
@@ -308,20 +328,34 @@ static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
 
 	br = netdev_priv(br_dev);
 
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		err = br_fdb_queue_one(br, &fdb_list, fdb, ctx);
+		if (err) {
+			rcu_read_unlock();
+			goto out_free_fdb;
+		}
+	}
+
+	rcu_read_unlock();
+
 	if (adding)
 		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
 	else
 		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
 
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
+	list_for_each_entry(info, &fdb_list, list) {
+		err = br_fdb_replay_one(nb, info, action);
 		if (err)
 			break;
 	}
 
-	rcu_read_unlock();
+out_free_fdb:
+	list_for_each_entry_safe(info, tmp, &fdb_list, list) {
+		list_del(&info->list);
+		kfree(info);
+	}
 
 	return err;
 }
-- 
2.25.1

