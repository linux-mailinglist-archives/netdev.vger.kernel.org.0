Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8FB2D8DCB
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395337AbgLMOJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:09:49 -0500
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:10034
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395437AbgLMOJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:09:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bb6LLGFusdX+2iPQp81Hfm3HBunW6KRPdZjnwthEUt8H5xKixVGU+X/ZstSsoVqg7/fnuoxSByWb80MqH7f2kKly+/IMPGxugQdsVRA555hR1fsNxFNAerhRnYcg9MHN9SuWdD+y/lUeoK+SIPms/sMz1YM83a+SLbc5qmY8vOkxPxQUThd+bLyAjh3OFyUh4UzBlfc8IowNmMQ4CTC5lUJ5aw3wC302h3AC5CRSNT95CncgNUzkIKJ+BpnquEvlbQ7QGxrsNVtPXtPiAMHqsOgakdkbw1KnVth3Np7IZ6gQ+VzHOjk3uj3PZBI71DMyd+S1cXAS3cOQQ318uS3Z0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kqx5kkoU3w/rJEMD08teRsTlHKpapMIVEIsnIze7Njw=;
 b=imwbNmt59v4g0yBRTORXa9cHkqq1xTmXodaq/uuFFHQWzrXwMm8xQ6L4IpA5M6luFo/ASj6B993WJZ3g/ah8rkmg476vHU6xku4aBjmUFFZ9kuV/QpOCMmeKeF0Ht0tRR7l9okrk+q3foekJxJ52ds/uCOoWhLa8tGziGTxHqhH+nxHOALNg6NUCS1eZyXf92K1XHIf92SHSpESNpcKkYoXKooob5FDPOKTjnDqiIxOCRLeWS72Y00wsIYU++wXvU2xpuQkXILBQP/ZhMf+DAQKV9S3u3Y7n2Oq9AF8itZlVd0+1hejiIXA4rjeWm6CGZz9TRpO0lSmFNuRUl+gFvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kqx5kkoU3w/rJEMD08teRsTlHKpapMIVEIsnIze7Njw=;
 b=FxTQ26MNhlolR1kH5/sJuX/xoLNvVSifTPfz9icPtBux5ewN9C7sRHPbK8HXgapa6eaeEKqhzkp5dkLHM7EJtcnEcK718g8aZGLxbMye22tzctx0/GaexQxUI+gi/swdP/W7VLJqApF9fV9pm7UG2Dy3SGShHpQFjpF+tWBv9m4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:41 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:41 +0000
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
Subject: [PATCH v3 net-next 6/7] net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Date:   Sun, 13 Dec 2020 16:07:09 +0200
Message-Id: <20201213140710.1198050-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f3ff13a-e01a-4bcb-1ae7-08d89f70747f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341BE64EB7D2D3E154BD6C2E0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ed5OHNmWgCHtfGWypNGiWS+blaRGOCPQAEf1fOcxauvHDiGUEbgjpXZUzN7bxnR1FoLCmClkj0GKv9Z7vT0aazifem/7K6qQrZU8V2wjoHc6SuzHZeXxL2hSzIgevyQBnYNor+95xuv5ujEbZ63eB4MzV4Z4sgm/3avHjk2tgTFMBp1py77ETJiutqW1rCcfAZsPezOR89VaMSgS3qdX+kx+eIs11X808IotfFOAbY+FaSF8QrM0mly23qtkeLGJ7Yg6fStH2JRtUl8stKSn9HNy0tXiZ4TNp/T7ObM9NMs7uHe5ilfePwnTtrHULWiZQqRJhS+5MrwlYW6o6w4u1lNHbdmt9tdwhdhu3Abze62adRAIk5Zb/DN6xFzUf7s7sWtDFOH27ApwmRcgIUxqMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ODF06xMcneK5yPjymUWghCYoiApD28wqZSuNdTGf93Ml51de1u0uudH/t40O?=
 =?us-ascii?Q?iVvKgNWa/pOEH+dlPt2ToYp8vGCTPiXK+HeNFjtu4VqKhsDcWW0j6gsLMy2y?=
 =?us-ascii?Q?knSggAVS+a/BlGQWgtgskzT5YWxP8C7/ahDxaDdto78s1QBMPyRF8TokhLzG?=
 =?us-ascii?Q?ugtGVufCDPs0CebU789YartLykmnhU/OrRY4dMk/gml7QKwjt1qTiOPQTwpV?=
 =?us-ascii?Q?oENvBBmiyqGYJDFkyJIlxg9b5D+6x4GOh+OZAB4JGHqfusOOq2uiyWZOvqxn?=
 =?us-ascii?Q?t7WAjzNcXZFhLa62RuErfP8whRUfXD5OF0F1Wtne6CyfZesumXvfb8JDGyTV?=
 =?us-ascii?Q?m53xXhqmYMZTC9vUWlGzoF3sxHsPM49KZ6tBndzSOQHoa9t6o/UDNPPADJbG?=
 =?us-ascii?Q?niCCky0dr7BFeKcm9Wd4EtyQog7BFyRU4rK52EQ5gC4qYSB0XfEWxRcJoOEW?=
 =?us-ascii?Q?CqkoWa7fF5eEAk2KUdfF96lsgfcrMtT/0pNyXwgoZonGR4HIGbztr+JjEiUI?=
 =?us-ascii?Q?YiGd83ue60RDBRHHfCo13TlI4YXCAyfcv4hdO4b9xWPjIfFquHpowq44RNoG?=
 =?us-ascii?Q?Wnb+LkQcIL0J8a2ChCL1ppImp3H1mEfJk/yrEGcc6vOp4WPD776ss7gf97qw?=
 =?us-ascii?Q?9OHFIncqTKMSKO+l/wEXO5xKz7Z4xA9IC2AbSuA4FWPgXCJSytcqoCi/zNwT?=
 =?us-ascii?Q?BOFn9T7zE+mNBcqZ8fNMAiQNyuCbmA0r2L3oMe7w2dW9QxO/r/nRGywUnmsQ?=
 =?us-ascii?Q?lbsxkAQO7nUCU5KWpDBJVKPG+6zllgoq8Gj6+Cdu+v9JB6Mhsjb9NWCMsfOL?=
 =?us-ascii?Q?sfxTq68H7uKpgvOZs66lJWRAi11QPxZc4qXa5X1WhUDGHIz2zydYLuS8rl4u?=
 =?us-ascii?Q?tnkqPc5ovNRJ5lngtbcasVpQcc50SbS8wYliulKtn7XLrnBE+DULa/hVTDc4?=
 =?us-ascii?Q?bU+NKF33iTKtj58e2zcETCi0ryZvnJ9xTvY68qwFRqkiF/h0cX/j7d32pdmJ?=
 =?us-ascii?Q?b6Hr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:41.1686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3ff13a-e01a-4bcb-1ae7-08d89f70747f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /judV4ibc7Nc01OvDWnBP7AYp3LjK/Ewceh+UM2UIBPcMf5DSA3b7VsdF3N/r2GVD+/ZGqnYBMHwinDN1JM7Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
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
ds->assisted_learning_on_cpu_port = true. This is because we don't want
to inflict a potential performance penalty (accesses through
MDIO/I2C/SPI are expensive) to hardware that really doesn't need it
because address learning on the CPU port works there.

Reported-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
- s/learning_broken/assisted_learning/
- don't call dev_hold unless it's a DSA slave interface, to avoid broken
  refcounting

Changes in v2:
Made the behavior conditional.

 include/net/dsa.h |  5 ++++
 net/dsa/slave.c   | 66 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..6b74690bd8d4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -319,6 +319,11 @@ struct dsa_switch {
 	 */
 	bool			untag_bridge_pvid;
 
+	/* Let DSA manage the FDB entries towards the CPU, based on the
+	 * software bridge database.
+	 */
+	bool			assisted_learning_on_cpu_port;
+
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 37dffe5bc46f..456576f75a50 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2109,6 +2109,28 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
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
@@ -2127,10 +2149,37 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
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
+			if (!dp->ds->assisted_learning_on_cpu_port)
+				return NOTIFY_DONE;
+		}
 
 		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
 			return NOTIFY_DONE;
@@ -2145,18 +2194,13 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
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
 
-		dev_hold(dev);
+		/* Hold a reference on the slave for dsa_fdb_offload_notify */
+		if (dsa_is_user_port(dp->ds, dp->index))
+			dev_hold(dev);
 		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
-- 
2.25.1

