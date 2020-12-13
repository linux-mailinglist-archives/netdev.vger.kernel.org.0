Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788E32D8AF6
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391873AbgLMCm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:42:58 -0500
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:44269
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728747AbgLMCml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 21:42:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BH3IdE3maiIYjhfejVZyT5fUTqgpHZvJJy5v58YMCSMi6xElUU4jS+8bfhlKnSlnYJRyV9gElk+mouA+kGwfw/rta1ZzacyuaQILVfZDApUIAJIRxh/imFrJko+1IfS3uP3dKbIfXaw2rIgbP+AnlRojmHaEmFQMeWp3JahWTPG2a4dchFtb55/zBYpDxGozytwGWX6Pqg+ia3MgqE06xu/ekxWXkeD/+jHzio9jdK6ih32w0TFzufj2inQkLM//cZNWr8NDSbIzv5nfSvv/FIvpt4+aIRaauAkbfdKcjtWSIS3AVVhYInWopZqwJaaOdajgqsXKu578HG0tYjKIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iVbJth++RiqFR/ne0OzC7zcEznCBPTO72S3pkHxvlU=;
 b=iNc1KLny0K+fRdzeLsVRF2u0EbckqjzCr6blEHgL4NlM8EKdFt50sz2sQElf9B+zBTs91ZSKn0mAREnpTe3Dlx2abNhManWyqKGsPbgicRVI+TaPJpRLyTveOfsRPWgcLltRLaGoKHJZoh0jSZwfOtupWM2/egOTnfhe0xQAGDLsJryAXYSGHd5wajebDNxwA5wdpF0+t9LCjq74qXJY0Z9Su7VuF7AiUvIzrdyGlbcaSDXdJa7JHase3l+GsUCxnd8PQr/pCfZn3C0i1sjJrFWL7iClJ4+5tiCNWQGm453vluJds+ADXg7UIMYo2HieCyVJ6IvFxwLe4zlwIdVmtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iVbJth++RiqFR/ne0OzC7zcEznCBPTO72S3pkHxvlU=;
 b=kMlMm5R3TuDEY7zHYO1cawMsDrkxcsWNOOwrRjsgeSXLK1+P/IvoXr5OSMAwnsziHe2zjgdtj4apMk6QPy8QgRD+fzRQfQ33vhdhDX1zqEjp99Q50hbM4/5se2TP9vNOSyAS9vbC22481uV6lYLOpgRPRpsAAIYgpvc46VlbOXk=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 02:41:16 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 02:41:16 +0000
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
Subject: [PATCH v2 net-next 5/6] net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Date:   Sun, 13 Dec 2020 04:40:17 +0200
Message-Id: <20201213024018.772586-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0141.eurprd08.prod.outlook.com (2603:10a6:800:d5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 02:41:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3adbf9b7-4f6e-4bf6-6288-08d89f10905e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34071DC7D452EA6137AAB968E0C80@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92ed5zatGtiKAiSKEQztaf53ajYn0CLm3qsOa/zWAR2xct+ycnHXg73QsKG6yOo2LTTTpEOn1gkLEFlqOi3OvLDznrQxaI4g0g0/WOg53vtLnYDLC9ExUhWkZoLdGzAHTqgGeXOGtI+DW6q1Xl99AS+KY7xP6z84Hs+cePHojroQt94LWax7uE9tnKKhQBj6/PJDCR8SVzuUDDJ/SnLnwKDdoC4WGVdF7dErldhMj4ei76InQPthLGGK/LAG6VAXXxV3BF8G9flLnfPFwNp8pqhzT268WjtaBYx4d5h9OZImH+yEsaD04fBzrK/fxJE+gqtM8iEmjA4J6VHe5Vk7cvcgdYDo5yv+I5IC/yroKmXtSD++MaAIwccx69+eJ6PUyVB8SCBTXfjC6ssOQ6Dqww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(52116002)(6512007)(66556008)(8676002)(316002)(478600001)(16526019)(44832011)(5660300002)(6506007)(6486002)(1076003)(7416002)(110136005)(26005)(921005)(2616005)(86362001)(54906003)(66946007)(2906002)(36756003)(8936002)(186003)(66476007)(4326008)(83380400001)(956004)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PAkNtOWE0rCZFELSJPfeiBUPQkPJBcvxn15e8ZEJLgwcNmw9RdTiH1kWomtq?=
 =?us-ascii?Q?YQuwmq/+BZBBJHLVy93nHYaimw/X2/xEGcLv03pgKb/55sEzy/sIxiHV/aRn?=
 =?us-ascii?Q?dvSK66GCzWIRO7+uAqeqd4uGsetnJGpVsnnIw2/je5x3g5QPgxhzCoKy1kSL?=
 =?us-ascii?Q?6JY+FydsDJ17FIyCOWOVxbaS0eDt+uW/jwGr24vCTMyJ+cGranPY4zm7dS8m?=
 =?us-ascii?Q?D4PHt9J0MiA47vxhuzh6DghnATWzjysHWKaJFMK2UxqyvvYH7psqX6agFixm?=
 =?us-ascii?Q?MAUd6ont3lZRnqecKhvQkkrmh5jsEf0ItdxrFytd5BmzLPdkE5Mpy7KagKBe?=
 =?us-ascii?Q?r+NKAEO9sMgHhh3K2vge4pFw3k40kdADCvwDYsByKEgyDOAqLWI8NN5njqf1?=
 =?us-ascii?Q?dx2mSChYFUA2C0mD59S6DPAAQcCFH8AOuyJR+H0wQY2A0KCiDyor5YCwc6bQ?=
 =?us-ascii?Q?vZiuTceCSS7NA4CEFDUROe1HqzTrzzbR4hXzYXuRpGcj7ztZYDzbh8qQp1Xw?=
 =?us-ascii?Q?kcM5ZBEOAuWaklHPsfo8AmmACTJY965Xscpw4Vgl6ewmUGZNKNXHwRsGbO0h?=
 =?us-ascii?Q?iiI4wmwawGu01rPxQ7HjXOiyG9u6mW2L68/TLgMGg63f7LznA1OBOyYUh0fN?=
 =?us-ascii?Q?bU48/9lJMTEn/P76aPI9jsH8NMOMcmR2R2EsxQGHckwsuB5Bh2saM7l0cG+r?=
 =?us-ascii?Q?9JJYyxhJttWAuNiukDtoVtQuOlLTli2CO8wSqimAArq/XRP1L32mL40BOK7e?=
 =?us-ascii?Q?RoON1e79VXjwzfJKxyGmADMgnXmjnymEDcPD6S7EmsVAoP8m5jRSQ7KC5fY8?=
 =?us-ascii?Q?vQxXWJUqmanKagrx0u2nAC2QQk0HxTLxU08xmc23vf5Dx0qMpFDEHdbDySA6?=
 =?us-ascii?Q?IPt8OCoG1IMF9WtIkix0g4UlTJ06/kmWYKTd9pjJN5YYdY7BfiXVWIDHmSVe?=
 =?us-ascii?Q?nKXZ+msZ42wHSxy2AJ2xnUra53v0AM57aBrcUUuWC4GPNjtNZ96aT8L6Dsl3?=
 =?us-ascii?Q?KxrG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 02:41:16.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 3adbf9b7-4f6e-4bf6-6288-08d89f10905e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9ij1wT+5DlRsd2xOyBiepNJZjLyQsstSwOY0AFOo46JbIgKbbcrRcnKeg9FxeBCk2DmcIGfX0k7V47s+LMi9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DSA switches (and not only) cannot learn source MAC addresses from
packets injected from the CPU. They only perform hardware address
learning from inbound traffic.

This can be problematic when we have a bridge spanning some DSA switch
ports and some non-DSA ports (which we'll call "foreign interfaces" from
DSA's perspective).

There are 2 classes of problems created by the lack of learning on
CPU-injected traffic:
- excessive flooding, due to the fact that DSA treats those addresses as
  unknown
- the risk of stale routes, which can lead to temporary packet loss

To illustrate the second class, consider the following situation, which
is common in production equipment (wireless access points, where there
is a WLAN interface and an Ethernet switch, and these form a single
bridging domain).

 AP 1:
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
       |                                                       ^        ^
       |                                                       |        |
       |                                                       |        |
       |                                                    Client A  Client B
       |
       |
       |
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 AP 2

- br0 of AP 1 will know that Clients A and B are reachable via wlan0
- the hardware fdb of a DSA switch driver today is not kept in sync with
  the software entries on other bridge ports, so it will not know that
  clients A and B are reachable via the CPU port UNLESS the hardware
  switch itself performs SA learning from traffic injected from the CPU.
  Nonetheless, a substantial number of switches don't.
- the hardware fdb of the DSA switch on AP 2 may autonomously learn that
  Client A and B are reachable through swp0. Therefore, the software br0
  of AP 2 also may or may not learn this. In the example we're
  illustrating, some Ethernet traffic has been going on, and br0 from AP
  2 has indeed learnt that it can reach Client B through swp0.

One of the wireless clients, say Client B, disconnects from AP 1 and
roams to AP 2. The topology now looks like this:

 AP 1:
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
       |                                                            ^
       |                                                            |
       |                                                         Client A
       |
       |
       |                                                         Client B
       |                                                            |
       |                                                            v
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 AP 2

- br0 of AP 1 still knows that Client A is reachable via wlan0 (no change)
- br0 of AP 1 will (possibly) know that Client B has left wlan0. There
  are cases where it might never find out though. Either way, DSA today
  does not process that notification in any way.
- the hardware FDB of the DSA switch on AP 1 may learn autonomously that
  Client B can be reached via swp0, if it receives any packet with
  Client 1's source MAC address over Ethernet.
- the hardware FDB of the DSA switch on AP 2 still thinks that Client B
  can be reached via swp0. It does not know that it has roamed to wlan0,
  because it doesn't perform SA learning from the CPU port.

Now Client A contacts Client B.
AP 1 routes the packet fine towards swp0 and delivers it on the Ethernet
segment.
AP 2 sees a frame on swp0 and its fdb says that the destination is swp0.
Hairpinning is disabled => drop.

This problem comes from the fact that these switches have a 'blind spot'
for addresses coming from software bridging. The generic solution is not
to assume that hardware learning can be enabled somehow, but to listen
to more bridge learning events. It turns out that the bridge driver does
learn in software from all inbound frames, in __br_handle_local_finish.
A proper SWITCHDEV_FDB_ADD_TO_DEVICE notification is emitted for the
addresses serviced by the bridge on 'foreign' interfaces. The software
bridge also does the right thing on migration, by notifying that the old
entry is deleted, so that does not need to be special-cased in DSA. When
it is deleted, we just need to delete our static FDB entry towards the
CPU too, and wait.

The problem is that DSA currently only cares about SWITCHDEV_FDB_ADD_TO_DEVICE
events received on its own interfaces, such as static FDB entries.

Luckily we can change that, and DSA can listen to all switchdev FDB
add/del events in the system and figure out if those events were emitted
by a bridge that spans at least one of DSA's own ports. In case that is
true, DSA will also offload that address towards its own CPU port, in
the eventuality that there might be bridge clients attached to the DSA
switch who want to talk to the station connected to the foreign
interface.

In terms of implementation, we need to keep the fdb_info->added_by_user
check for the case where the switchdev event was targeted directly at a
DSA switch port. But we don't need to look at that flag for snooped
events. So the check is currently too late, we need to move it earlier.
This also simplifies the code a bit, since we avoid uselessly allocating
and freeing switchdev_work.

We could probably do some improvements in the future. For example,
multi-bridge support is rudimentary at the moment. If there are two
bridges spanning a DSA switch's ports, and both of them need to service
the same MAC address, then what will happen is that the migration of one
of those stations will trigger the deletion of the FDB entry from the
CPU port while it is still used by other bridge. That could be improved
with reference counting but is left for another time.

This behavior needs to be enabled at driver level by setting
ds->learning_broken_on_cpu_port = true. This is because we don't want to
inflict a potential performance penalty (accesses through MDIO/I2C/SPI
are expensive) to hardware that really doesn't need it because address
learning on the CPU port works there.

Reported-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Made the behavior conditional.

 include/net/dsa.h |  5 ++++
 net/dsa/slave.c   | 62 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..d02851854c76 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -319,6 +319,11 @@ struct dsa_switch {
 	 */
 	bool			untag_bridge_pvid;
 
+	/* Let DSA manage the FDB entries towards the CPU, based on the
+	 * software bridge database.
+	 */
+	bool			learning_broken_on_cpu_port;
+
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 53d9d2ea9369..d1a3d717f5af 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2106,6 +2106,28 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		dev_put(dp->slave);
 }
 
+static int dsa_lower_dev_walk(struct net_device *lower_dev,
+			      struct netdev_nested_priv *priv)
+{
+	if (dsa_slave_dev_check(lower_dev)) {
+		priv->data = (void *)netdev_priv(lower_dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+static struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
+{
+	struct netdev_nested_priv priv = {
+		.data = NULL,
+	};
+
+	netdev_walk_all_lower_dev_rcu(dev, dsa_lower_dev_walk, &priv);
+
+	return (struct dsa_slave_priv *)priv.data;
+}
+
 /* Called under rcu_read_lock() */
 static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
@@ -2124,10 +2146,37 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (!dsa_slave_dev_check(dev))
-			return NOTIFY_DONE;
+		fdb_info = ptr;
 
-		dp = dsa_slave_to_port(dev);
+		if (dsa_slave_dev_check(dev)) {
+			if (!fdb_info->added_by_user)
+				return NOTIFY_OK;
+
+			dp = dsa_slave_to_port(dev);
+		} else {
+			/* Snoop addresses learnt on foreign interfaces
+			 * bridged with us, for switches that don't
+			 * automatically learn SA from CPU-injected traffic
+			 */
+			struct net_device *br_dev;
+			struct dsa_slave_priv *p;
+
+			br_dev = netdev_master_upper_dev_get_rcu(dev);
+			if (!br_dev)
+				return NOTIFY_DONE;
+
+			if (!netif_is_bridge_master(br_dev))
+				return NOTIFY_DONE;
+
+			p = dsa_slave_dev_lower_find(br_dev);
+			if (!p)
+				return NOTIFY_DONE;
+
+			dp = p->dp->cpu_dp;
+
+			if (!dp->ds->learning_broken_on_cpu_port)
+				return NOTIFY_DONE;
+		}
 
 		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
 			return NOTIFY_DONE;
@@ -2142,13 +2191,6 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		switchdev_work->port = dp->index;
 		switchdev_work->event = event;
 
-		fdb_info = ptr;
-
-		if (!fdb_info->added_by_user) {
-			kfree(switchdev_work);
-			return NOTIFY_OK;
-		}
-
 		ether_addr_copy(switchdev_work->addr,
 				fdb_info->addr);
 		switchdev_work->vid = fdb_info->vid;
-- 
2.25.1

