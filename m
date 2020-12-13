Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D672D8DC7
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395355AbgLMOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:09:02 -0500
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:11936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395308AbgLMOIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:08:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bam/ivUqwGwPpgszYUFanqukUmJC5zz38iRGhkr3T+57vgWN+5shS2sBabziiEmHw8N0RR1EPUwqVe86w4fFV5cn3Lweh6Wevh3+ceQqbug0myMSopgQD5O1doWh5AEfh+Zm429ightjKwzNczAlbeh1bJ3ovkglA0EfKDRz/8+smNpXrDDqVIuvfUkHbiYICAmXCOonZ4jbu3pdUX4As53ANZ3Kbn3m3ZxcPqFSDBmqksaGeKfP1OkJAKrGSEgXGwNats+bgWRByvQiYNDBVhMDf+0HRhR9wM4W43eU159NewNvHtPqJMhqRlYvmYHmwpCQ6vPQq6cO4qIapXksGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFJ2F2SqWd6Ad9BOGo+vZKjbtma93kif/ZXBlDu+9zk=;
 b=Msuxxr4rzJRYX5myIlnvvGCljciw/uFcuvsexDjhg61met7PBzKDBkhCP0jtheFr4/gxijs/WsktIP5IfpnPl5mtVVlwWcCKS+gmXQvbtPKNvvvz2wAgOQXk9I27K9z8q2I3kgr11/7CVwW8zxw2I/lCTBBREVJtvpU1Si9mXO8fiUSsZHzouERfgBTMyX+Xia3zUFFWM6PHvAlTmOeDQ0xSBe1M5KBg0ckBVuGG5QQMPuQfrxDbtDlH3rF3qmmPtLaPpxDmXdbMIhEPH0sem21AHBsOZg8D8OUh9k0jeZS1mPy+lfT+G0qHWHunxkoBMFli7Ys4DuaxsX8/Lif2Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFJ2F2SqWd6Ad9BOGo+vZKjbtma93kif/ZXBlDu+9zk=;
 b=RLpSQ84ymlidZ39Xfsh/kEWJs5+n62gRr4sSh1Lt0I4K95kb+73omCaACESrr6O2gacehTe/0RPknQp9Kzm38paBevws8hbYHKxCf7gso3NcF3MU0Z8/IDTxnSwKj3omEqhblEW+qx8b2+GMFx3D5RzhPNvHzxRrPiyB0Hq7ZLw=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 3/7] net: dsa: don't use switchdev_notifier_fdb_info in dsa_switchdev_event_work
Date:   Sun, 13 Dec 2020 16:07:06 +0200
Message-Id: <20201213140710.1198050-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0235.eurprd08.prod.outlook.com
 (2603:10a6:802:15::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8db55726-b693-4177-eb87-08d89f7072f9
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB734140CC97091430FB236BDCE0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 245nLSN3BGKJduCiHDJNunRdm9v0S5dZGyFgOKxH82Vmz3cre8CQVO2q6etE6J4SAKlwqOwUYB0sQF18+yUHaZjG7hgdoRjLH8spqRxFnpP2vq5bRtGnTloVz3D1caocKJb6T4fBIQ1GOwB0Pod9E3OtlDtUS/Ya6bFBX+e/kdAGUAVerHULwhcTFwQusDTtk8BiUio1tCFFqo+gSgO5a2yXJhcecJ74rSxo+1WM4WYfTrrGPyvbrhSdGSmHlswt8oWcjSm6FgRxLKbzX645Rq7zSffwtOD6qxEA6/bmnPgIfE+G1WMfI8ThT4fHmdZrcKyqFR36ZdxZwpYAoaZUDJN7zktTM1ydYDgVSHlDv0PZDTZbrQE+5I/1syyCKxZpbhI4AUXD7H02AuF0R1TIWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xRdg9DIxwPzBDPBCHCnoPbgZ4qjymg7j8+pHqVLpW9Pm7b+/Nuc9gpmqxnAq?=
 =?us-ascii?Q?sWnwiXbvynZrqC1tth3mIOrXSANRbRIGVNrqSJ+zsboVGA0sYmGpxRcHw3Nt?=
 =?us-ascii?Q?zzsW+JPrHMwgFMKVJPx71wlfBzGfTx42OpGSNNWuHoEi+plI8EEQOV8sHwgK?=
 =?us-ascii?Q?rg+7RmU8MNrAKZamvx/s7WtwqUYQcj3PIalGUz6n28XBmFk49o4s0afayZyc?=
 =?us-ascii?Q?WcJu0ZtQEEIvU/RhcR3AJ/LQ4CGUjqDWj9r9OCLQUnm8oMrTmja3C3eVh9ab?=
 =?us-ascii?Q?JZbogOOHnqMjpfe0HDVuhLbjCaD8FXEn1X+BxglUMBywHUbvlYkFli64qkoC?=
 =?us-ascii?Q?/v+4KGSP91nYwFDbaxUoQ4uMuRwWrfEr+IKemieOlzZnKqemPyVSd80QATeQ?=
 =?us-ascii?Q?50N/VnSDthlhRTmJNlanAs3DDAZ1uAO6d5tXSKG5ef20wlav1w/bxRyCFYc9?=
 =?us-ascii?Q?AKBGcgccQ+xIPY+SyX/wBQASruHm/erV6fA8k86ryaIOLHICbh3KYnU02e4I?=
 =?us-ascii?Q?A9him1PteHQMGVhcix6kEObLUc5v1tjuyFwwl957LJ3fc9XuOo+HwP9Ouxf3?=
 =?us-ascii?Q?YJlEBbovAR/Lg3zqnADMp7TiQTBz1Pjo4mu0uhr7N8CtxlrCYP3+7D0WbeAU?=
 =?us-ascii?Q?QN5vXTyYj2AiBJGgmtmbjMr0pPerG0psG2vflHOP338I+Q8yjk8BBWePDMyV?=
 =?us-ascii?Q?miYfko16p5fRy21i1SqmshB9HPs7zP3jtWefvfPnrHfhkEEyL91aIvvKoZHn?=
 =?us-ascii?Q?x7G2T372SND8P2SzyB89KQmSS7Y3g8ELQOnIz4TbAh9ZNYvi2lpLnRpFvC59?=
 =?us-ascii?Q?7jvUF83h+IhjUuX+q/XbPpAd5FKDLJjjzpHgkAty3QudeKqWpICTfdQAnDGQ?=
 =?us-ascii?Q?t1WCuUIKZh881Iy2Cs7jdf57MF71nZl9QMUMWEHyd9AJg9Y7DkEz63ApnPhh?=
 =?us-ascii?Q?LQlA1UuF3N8mQbGSjJc0gmUPJ1N//GuOIMRPZ+RdeAjZx9GHerksnVpUs32a?=
 =?us-ascii?Q?EsZp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:38.6790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db55726-b693-4177-eb87-08d89f7072f9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9ALrobDFCmWr/XDJntiEL0spqFwNzmvQmq9KBPqvQ7cG8rLDL7qNAq4CZ0Dve+ecknJ+dFUb8OEkRhO2zO/vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSA doesn't add FDB entries on the CPU port, because it only
does so through switchdev, which is associated with a net_device, and
there are none of those for the CPU port.

But actually FDB addresses on the CPU port have some use cases of their
own, if the switchdev operations are initiated from within the DSA
layer. There is just one problem with the existing code: it passes a
structure in dsa_switchdev_event_work which was retrieved directly from
switchdev, so it contains a net_device. We need to generalize the
contents to something that covers the CPU port as well: the "ds, port"
tuple is fine for that.

Note that the new procedure for notifying the successful FDB offload is
inspired from the rocker model.

Also, nothing was being done if added_by_user was false. Let's check for
that a lot earlier, and don't actually bother to schedule the worker
for nothing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
Small cosmetic changes (reverse Christmas notation)

 net/dsa/dsa_priv.h |  12 +++++
 net/dsa/slave.c    | 106 ++++++++++++++++++++++-----------------------
 2 files changed, 65 insertions(+), 53 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..c04225f74929 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -73,6 +73,18 @@ struct dsa_notifier_mtu_info {
 	int mtu;
 };
 
+struct dsa_switchdev_event_work {
+	struct dsa_switch *ds;
+	int port;
+	struct work_struct work;
+	unsigned long event;
+	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
+	 * SWITCHDEV_FDB_DEL_TO_DEVICE
+	 */
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d5d389300124..5e4fb44c2820 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2047,76 +2047,66 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-struct dsa_switchdev_event_work {
-	struct work_struct work;
-	struct switchdev_notifier_fdb_info fdb_info;
-	struct net_device *dev;
-	unsigned long event;
-};
+static void
+dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+{
+	struct dsa_switch *ds = switchdev_work->ds;
+	struct switchdev_notifier_fdb_info info;
+	struct dsa_port *dp;
+
+	if (!dsa_is_user_port(ds, switchdev_work->port))
+		return;
+
+	info.addr = switchdev_work->addr;
+	info.vid = switchdev_work->vid;
+	info.offloaded = true;
+	dp = dsa_to_port(ds, switchdev_work->port);
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
+				 dp->slave, &info.info, NULL);
+}
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
 {
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
-	struct net_device *dev = switchdev_work->dev;
-	struct switchdev_notifier_fdb_info *fdb_info;
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = switchdev_work->ds;
+	struct dsa_port *dp;
 	int err;
 
+	dp = dsa_to_port(ds, switchdev_work->port);
+
 	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
-			break;
-
-		err = dsa_port_fdb_add(dp, fdb_info->addr, fdb_info->vid);
+		err = dsa_port_fdb_add(dp, switchdev_work->addr,
+				       switchdev_work->vid);
 		if (err) {
-			netdev_err(dev,
-				   "failed to add %pM vid %d to fdb: %d\n",
-				   fdb_info->addr, fdb_info->vid, err);
+			dev_err(ds->dev,
+				"port %d failed to add %pM vid %d to fdb: %d\n",
+				dp->index, switchdev_work->addr,
+				switchdev_work->vid, err);
 			break;
 		}
-		fdb_info->offloaded = true;
-		call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev,
-					 &fdb_info->info, NULL);
+		dsa_fdb_offload_notify(switchdev_work);
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
-			break;
-
-		err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
+		err = dsa_port_fdb_del(dp, switchdev_work->addr,
+				       switchdev_work->vid);
 		if (err) {
-			netdev_err(dev,
-				   "failed to delete %pM vid %d from fdb: %d\n",
-				   fdb_info->addr, fdb_info->vid, err);
+			dev_err(ds->dev,
+				"port %d failed to delete %pM vid %d from fdb: %d\n",
+				dp->index, switchdev_work->addr,
+				switchdev_work->vid, err);
 		}
 
 		break;
 	}
 	rtnl_unlock();
 
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
-	dev_put(dev);
-}
-
-static int
-dsa_slave_switchdev_fdb_work_init(struct dsa_switchdev_event_work *
-				  switchdev_work,
-				  const struct switchdev_notifier_fdb_info *
-				  fdb_info)
-{
-	memcpy(&switchdev_work->fdb_info, fdb_info,
-	       sizeof(switchdev_work->fdb_info));
-	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-	if (!switchdev_work->fdb_info.addr)
-		return -ENOMEM;
-	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-			fdb_info->addr);
-	return 0;
+	if (dsa_is_user_port(ds, dp->index))
+		dev_put(dp->slave);
 }
 
 /* Called under rcu_read_lock() */
@@ -2124,7 +2114,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	const struct switchdev_notifier_fdb_info *fdb_info;
 	struct dsa_switchdev_event_work *switchdev_work;
+	struct dsa_port *dp;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -2137,20 +2129,32 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	if (!dsa_slave_dev_check(dev))
 		return NOTIFY_DONE;
 
+	dp = dsa_slave_to_port(dev);
+
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return NOTIFY_BAD;
 
 	INIT_WORK(&switchdev_work->work,
 		  dsa_slave_switchdev_event_work);
-	switchdev_work->dev = dev;
+	switchdev_work->ds = dp->ds;
+	switchdev_work->port = dp->index;
 	switchdev_work->event = event;
 
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (dsa_slave_switchdev_fdb_work_init(switchdev_work, ptr))
-			goto err_fdb_work_init;
+		fdb_info = ptr;
+
+		if (!fdb_info->added_by_user) {
+			kfree(switchdev_work);
+			return NOTIFY_OK;
+		}
+
+		ether_addr_copy(switchdev_work->addr,
+				fdb_info->addr);
+		switchdev_work->vid = fdb_info->vid;
+
 		dev_hold(dev);
 		break;
 	default:
@@ -2160,10 +2164,6 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 	dsa_schedule_work(&switchdev_work->work);
 	return NOTIFY_OK;
-
-err_fdb_work_init:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
-- 
2.25.1

