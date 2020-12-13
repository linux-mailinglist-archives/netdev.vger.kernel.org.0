Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C96D2D8AFF
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394056AbgLMCob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:44:31 -0500
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:11598
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728753AbgLMCmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 21:42:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQCDsk/Tqjm65VUki0JzjnISEpikMQ2BSrdSHsqFCg428BqYCzUDyDGga/9fbU+yi6yJqgom962Qc4GqVchDJaMVcjOa/vbOjKvRp28iaTaDh/pykt5iN2ajn7332gVzkmDL71qr8Gfit6GEv6OaSOKKOOgI2YI3HHv++uuqixXhaqGKsCFfsmRe83SG5ojnHl723gxw6r7TOSQXZ2rN78NmHmuKPsunzBlpkknpnqq2nVBD/Id9HKXbvAhiAmdhi4f7xJY2SiaNI0BWIaQHQDhWBRmR3eryjRjpN5C70zfKzO4K0IaIdH9EuKV7XtwNoO6N2O+8ZOzWzGLZrSxM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFLX2wiBxLYOce+LWhMIewb2eWFh9MXAxVnj+ARxHho=;
 b=WaDgR2zU+tfRBpiwYA1ErUmgehoRS5IjL4ONT2lGM9NNGKt7iCLtlCfIAUI8ouP63quPVNZG55pByVhS+hppJ5DraxD01b8HrI+PD2Jp+ob9QuRf7EpWXb1SU2klQplf0JpXMTgzFNaxbzezhrJJAfFBtFLybBle4YGdmdCxcOzxptsWNtRxvX25PqHnIXnGPAJUyb3KJv/nz8b2qvv7dKeBfMiu9U/KnWwfIE9ldNr8loCXQ+Gwdssev+/zipMuWChwXdFdjWERqCxnuEzim1lEDKJ7+gsDD9eQp3G5Uu09Tg3WzoY+pAG4W+2dCWd53hqnZIlrmMjBMlQGO6QmOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFLX2wiBxLYOce+LWhMIewb2eWFh9MXAxVnj+ARxHho=;
 b=fMleEhAPzUtw6k75cjBGDlT0rlgf3ZsA7B9vHxgrQdZC0JunDUUgYG1di2UPYsTf5wNsO9aIG4uknDO9gGXzNk2vLO9BkgJggSAQdFQyEUMtlsE5o7eW+Wdn62anFcvtK/dwnV0S3AUp2SniFiO2R2UQEt5i2UBOC6ApZ4JTq2k=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 02:41:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 02:41:09 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v2 net-next 2/6] net: dsa: don't use switchdev_notifier_fdb_info in dsa_switchdev_event_work
Date:   Sun, 13 Dec 2020 04:40:14 +0200
Message-Id: <20201213024018.772586-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213024018.772586-1-vladimir.oltean@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0141.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0141.eurprd08.prod.outlook.com (2603:10a6:800:d5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 02:41:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5336c876-233a-4222-dbc3-08d89f108c4f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34072AAAE298C730344CABC4E0C80@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdT1u5SeVPTNTpPU+SDfyBBl2Ej/MdyJqQssU2zJh5fhvdUuYKHkG5Seaw2z5/1WwxqUG6l4w0wcj5TDG3lIfcjzDYrlIjUd0oXxgXvnDmEHm/lEKnUqZT6udy9laUOeTP2UfHvTEvxjL2+pXG9vJRL+evoL2D6BHx8JsuK+PZYnqHNu4cbM9phZptCEygNl3qKeBxKTJwkT+kyw4mK0YcllBGyFnrBYoLh+IcSpXGpqoUhnHrawGxBGj6nKGpsccW1X0MMCP0kz9NWqraTXy3mB22IwDEDa5iFBpJ5k28NU9huydJj/a/V8TN5kTlKNg/BUGyYy7QOREt2QRHyIVd5JayyeA5McrZeH++ZxOe7ZZdynDfb4s9QqgX+PlHp3Syn5/pZBZUl+L6+CRNmV/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(52116002)(6512007)(66556008)(8676002)(316002)(478600001)(16526019)(44832011)(5660300002)(6506007)(6486002)(1076003)(7416002)(110136005)(26005)(921005)(2616005)(86362001)(54906003)(66946007)(2906002)(36756003)(8936002)(186003)(66476007)(4326008)(83380400001)(956004)(69590400008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/aXW2C0hyUGJUDEvVQCj1GUwNW9x21iAiIqbAkUMZ1iapteoTPC6DiQt3ESU?=
 =?us-ascii?Q?IUypxjGzMc1975HqJ6w1At/yLZXoR6BermHI4yqxM2AFpbejAJOs6vu+YN/n?=
 =?us-ascii?Q?JipSNPu0LlWJxgf6RVPTdh37ccBSW8+2t6Igb+VzM/pqOeBSVyPpLKhwWSgV?=
 =?us-ascii?Q?cSqEe3oVNd0vWzV3qcp5Y0pc86Ti1VC3zwL7+OJG20i5HO5z15MqoRK2r7mI?=
 =?us-ascii?Q?GTQqJ7YW9PZ06jXlQSYV6D3/c0gjIvno6eybady5SF3RGxB7h2qYgGdnC41w?=
 =?us-ascii?Q?6b3e/lqhVKI0QNiX53+Njwgp8d+yDy0xgF5LOlGfmJ7TcUtf8yBavxXQtREc?=
 =?us-ascii?Q?6Bo3ZNodGMzLtLK8Q48/9IPlKVupC4fMfF3SXwr6gwVkzTnbhbhAGbfXOXiF?=
 =?us-ascii?Q?MGTudDL4IoCF8GiyjL2lkPaTNSGs0zxyBtNNa/Oaf7YYQV6Kj0gNqRNi0dzj?=
 =?us-ascii?Q?Rs+/ZYwpw56IfP7Ux2poQvsWno9PxznB5dlysYO8P51hxx0c5/CGJLe50l/k?=
 =?us-ascii?Q?BndYRQDPZp05TtsOM02Tzk+baBube4KO5uMZ13qu3J0gL+VWfSI9QYlccyiJ?=
 =?us-ascii?Q?lWOl22WxE438YonGuzS4oi7859il+0W5EWwQ2dYHj7++/DzF6muAC8t/+iWZ?=
 =?us-ascii?Q?g5jmeih0vCEN25gOd/nVGPwRLNp6BNxrqRdaVBuE2GpZa2B2C5HShcj0Vig3?=
 =?us-ascii?Q?JC5YYYS8y4QqcXWAu+0Khw72MA0EY3XSa8p9Gaym1LLH5MMfweKUdMlPEyIH?=
 =?us-ascii?Q?97rxv2xnQQ6wy+RRJlB9s8R5ESWN4dZQO45bb7BoYrbT+xjFh6R56D/pWZXq?=
 =?us-ascii?Q?MC/v5EzCFGyU+SbcJRjf0ZOqqvLAT1prXN24YUZJ5oYWXgDEnIFQvLepnNK5?=
 =?us-ascii?Q?O5OyUPTK7KTaHE2wWtmO6mretS2E1Dq8u1e1pWE39VZsXUTiH/6eEnRnnmy2?=
 =?us-ascii?Q?IDSyn87emLNzp2djFWa9aAX7qTAl1qfWUQ7Lq4FB8uMT6aSQ6JV1KPIjbyfs?=
 =?us-ascii?Q?794e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 02:41:09.4072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 5336c876-233a-4222-dbc3-08d89f108c4f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YH2hIENEt3LLHuWHRwzoj1DOST2EMGxDyjUwMaRi2W84rSIMxOoNizFBCVZ26Kv3iTzXqdQo8ygf01bBPyFHdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
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
---
Changes in v2:
Small cosmetic changes (reverse Christmas notation)

 net/dsa/dsa_priv.h |  12 ++++++
 net/dsa/slave.c    | 101 +++++++++++++++++++++++----------------------
 2 files changed, 63 insertions(+), 50 deletions(-)

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
index 4a0498bf6c65..5079308a0206 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2047,72 +2047,63 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
-			netdev_dbg(dev, "fdb add failed err=%d\n", err);
+			dev_dbg(ds->dev, "port %d fdb add failed err=%d\n",
+				dp->index, err);
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
-			netdev_dbg(dev, "fdb del failed err=%d\n", err);
-			dev_close(dev);
+			dev_dbg(ds->dev, "port %d fdb del failed err=%d\n",
+				dp->index, err);
+			if (dsa_is_user_port(ds, dp->index))
+				dev_close(dp->slave);
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
@@ -2120,7 +2111,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	const struct switchdev_notifier_fdb_info *fdb_info;
 	struct dsa_switchdev_event_work *switchdev_work;
+	struct dsa_port *dp;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -2133,20 +2126,32 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
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
@@ -2156,10 +2161,6 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
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

