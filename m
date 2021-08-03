Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6189A3DF66C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhHCUel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:34:41 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:60396
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229739AbhHCUej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 16:34:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SygdKg1z8VXhTVKsjHkFiXzFlegN5T9/B/h6qj+1ESzt/EMteDsN/gXA4DAAyv6wOfmCO1YNg+pjtU4G4/4UgXHd4WRl1JZrdX5J8qVol/w+k0T/w7vcREg1nXw9XkTGPod3BKMT9dA658tax+ny+XHOBf1iU1e4F+61yGIHx9SoaIv2SkyQuSbkDK9m8k5TVF8Dpj5icM2DgbvCiGEgq3+dxIAYxM64v4VCg5RPtTMt3tuaPFJ/Rl4XK9huKFiSKhLSndVqsGzPjCeFLs8OzUZFIKxP5Ud8451YD3Gu6S+4jzDeEQj2hcj/PoT1tbyNn2BJn/Sk878xzk0LlpWqug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRlV9fd0Y7YHd0BNjX4SJ6AGS+9EqJ5phau29q9V+64=;
 b=To/VuQjUsMHF0bfJAmaEREUHXZtI6yF64nK7Tdct8H10RvDjiqMMCtUOf01k84cYBXxtFTP9g+gqrVqPAbVHWNpB37rg1uonUXH4rN2NQSHW7xaQRULH/rM7Xgeh4CqYNctZXIAkYAS579MrHygEDQv9kMd9JJ+UlhdppUtd/filXvVk9ozT34JU5GRPTgJwN2+AMG1mnG+6jC+ffbkcQxIwtdHzIpLP+jzDkTL1YmdNX3r/qahCEtADGNYPchPDE4TD55bmJK7auL1UyJEiSkCm4eiMgsULCjKUeEPgMdO5iXvp4xIpO3IgjJ+eCRNyK8rkKmWLTOD646w8ovYRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRlV9fd0Y7YHd0BNjX4SJ6AGS+9EqJ5phau29q9V+64=;
 b=XiitS2OzlszOJc6bjD/skwqodQ03rvDKPJ/K3KbDN0aZDDcK0AXVGmiiEFkFVuaWmM4/rTwoi/q/5C5PTP6hNMMUQhRiF5O7RvRCK1N0RJV0CZ5kNWur746rTe/fchdythG6d3A38A+Tlby7Xj2Mw9tTb6v4dKMq0rUD/tpsIJE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6465.eurprd04.prod.outlook.com (2603:10a6:208:16e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 20:34:25 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 20:34:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v2 net-next 1/2] net: make switchdev_bridge_port_{,unoffload} loosely coupled with the bridge
Date:   Tue,  3 Aug 2021 23:34:08 +0300
Message-Id: <20210803203409.1274807-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
References: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::18) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P251CA0013.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Tue, 3 Aug 2021 20:34:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19bb2c89-f07b-4a77-592e-08d956be153c
X-MS-TrafficTypeDiagnostic: AM0PR04MB6465:
X-Microsoft-Antispam-PRVS: <AM0PR04MB646526E32A57239E412D4583E0F09@AM0PR04MB6465.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KC+LHlXpJTUlEzUVVVoCxYkA5MRSzhX3TQffhJMshsv21wMwkiHVyRrGGnCEo4jDNQXpi/hiXNGfAgmG1E78zmJcwt2Am2lGEdL6R9Mf7jcdbFBHTACbqdNjKz/1gCbaQJiS1KDLlsqtXfwtvy+Kb7803fhra3I/CMwWNPpww1L6OvNi33ZNn7yXNH3ve/pPQluXo+xvHxle6jICu42ZyD4uh0YWiDnrSv5DPO2HpV7Q7IMygGogzaY8cHm94WPXEW1OfHTt+IOcTC0XhBf/s7NOLkeebjVIN6GL5pHd2zDjysSd9/rzBDgTHn/xU4dLORGthi+ig4LTyPcLPskwnNGlK3i0BIk/d0pLqgRYVTFMjrCTxKLgkAvIoIpMcavPp1jH98RBWGzzTne6eiq3+N36dwovMnRi4lxHq6dii5yguhiM3rLHxvOfDe9TOQlrowqgYCJnAYUvf1PKdq6g+V9lzCRP8KcoaVU23fvaOLilFVL5UR1qTvbyG75zBNoIo+EiR+rywFdUQvTGisx7vnEbgTH5VV5AsCRvnJyLaNsktX5C8fFSUmIdaEST8aYfGzTeo9pFzHcRZdbyyn+OOWiZflpubQORxT9MY5JiRl3UErrWu8kJK1EFplGjF/iOr5CAUiYqLcLU57r9ol0eHNb4+Md0iwnAXlROkETZNYWs9ex33BsIUtS29uNuU3/pLt577YYnanBlE9quBmFJa7bY+0GCocQtnCZV0JIjXh6SnuipF0HE4aH/t1ADPQ2ska7ORc5elGtUNr+xGXM+og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(376002)(136003)(44832011)(956004)(83380400001)(66556008)(1076003)(8936002)(6506007)(52116002)(186003)(110136005)(54906003)(2616005)(7416002)(478600001)(8676002)(5660300002)(966005)(30864003)(26005)(66476007)(6512007)(38350700002)(6666004)(6486002)(4326008)(2906002)(86362001)(316002)(66946007)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jasc/LrIUgfoO4KLjxitOjLSFp2zC0RUSqjC6ViKDHnjJMHUUl0dKrt71bMW?=
 =?us-ascii?Q?sE3/3TiGgdIt1YJQmkuTT/TyMUWkwa0PBonXQ2ybLwOqszI4Y5FqX7N1yaSb?=
 =?us-ascii?Q?mXLr1bP584gmD2q8E+hWge5yJeFxuSKbT3Gnbf0dfSbQ0Y5+1854vAoiGIif?=
 =?us-ascii?Q?wYb9xltrwoLfjhjwiRqC5Ur7N05XhzMfjNDLi+uQJjNppFzktfT1L7drXyWg?=
 =?us-ascii?Q?dCgfvSa1QWTc8b7/BE8Nlvq+LAywQ9ZObT5dB2GHJUaUxRXFJc40QxruBigY?=
 =?us-ascii?Q?wGeowU7chGitTfX+/h4ggqw2m7ro6VJz9Lp/abyc8UeT7SGN5ZshiEbFrfFf?=
 =?us-ascii?Q?TqERmIWbMdLlae4JshHnHSfMOnrQS4vR2TWEhcvpykRmRvgSzMWI66lB1kgo?=
 =?us-ascii?Q?mgzr7rsv8Gh9xikU3iZ/pZN6IuOPxZDvIfH5QwUP/13J4F4AcwsI1VExj4b4?=
 =?us-ascii?Q?qiPfkoWEraeGoCSFhQ64yN1j9liC0icDRi+8mcOlIHuvyvDcQE9nRVWR5aOM?=
 =?us-ascii?Q?Mrdz/dmm2HUHkROpR8ZRHACUZKHAC3bIeXiAE8a+sFVbS+9WaIxbsdq6yCy8?=
 =?us-ascii?Q?YiwLZ9KyMjTzRy3jNlYg4QJdR+82JUgZbhucgB+ogqPuINUep8fE1qYjqTME?=
 =?us-ascii?Q?KnP7XwFFfLJIBmKQHvgYgkp0sbge2F5iMYndZ5//ugwAchT+/8fKJsUeGsbB?=
 =?us-ascii?Q?KD3QvuLtuQWLN1s3wGHGYymE7vt2D9hfiqEQ20WbpLysZUxFlnGZ3qegT6my?=
 =?us-ascii?Q?Sw8tiSxBXRdkx58CU4pNbi+QBs5D8f9ys4xfLzZuHBNFW+cCGQfH0174xm1P?=
 =?us-ascii?Q?NOhc5bZFn1eqqGuqSjUrpZGaVYO6H7BMNjKveVqKZoeqZJKORjJXyqzZHOPq?=
 =?us-ascii?Q?OOJYopgnVpKs+CLUZOs6AgIOVtQzrIGHfvB5BPnv3/RR2EtsdJOngSwsI9GR?=
 =?us-ascii?Q?quQxD3DHBV1Xa5ui+rORxbY+PBnA3GI/h/7YxtWPuvJjGt9tjNucsAfL7aG6?=
 =?us-ascii?Q?UPVLI19c/g/l3co86/XKW0ndCEVs2qrK+IErdcZFxEQNakMITR3TgYLyINOq?=
 =?us-ascii?Q?8UK3+loAHAYUw+mAnbwod5V7nBBM56dLzu+/c2HR9rrvvJfjN82A5L8G6mM+?=
 =?us-ascii?Q?5bJKXnMxaL6ClVas2UpMJ1Ijr/lE1ID8CcX2J6zg0pgpwSR4GeWh9srFpOx7?=
 =?us-ascii?Q?OZukCT4upA9uNHH2HyImCvw2JjOHaaVmAgXSWreFgtHju958LcDJ9pywUk1w?=
 =?us-ascii?Q?ZNalhvCH0fFfYm4bSXunGZLsU0PcdxJ+8oRdvK9WCXaLEzM6DFP6f2BK2Wvl?=
 =?us-ascii?Q?JMbn+rQvRMDout8UeglP+IYB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19bb2c89-f07b-4a77-592e-08d956be153c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 20:34:25.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5n7Tug0b0XUE+aEBY7KiZd7S2mwPbfN/XEcgQ9YRzpmLF0ULj0lz8RKFr0L5cVDFD5FumUNOz0vUgC3Zf8zPvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of explicit offloading API in switchdev in commit
2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge
ports are offloaded"), we started having Ethernet switch drivers calling
directly into a function exported by net/bridge/br_switchdev.c, which is
a function exported by the bridge driver.

This means that drivers that did not have an explicit dependency on the
bridge before, like cpsw and am65-cpsw, now do - otherwise it is not
possible to call a symbol exported by a driver that can be built as
module unless you are a module too.

There was an attempt to solve the dependency issue in the form of commit
b0e81817629a ("net: build all switchdev drivers as modules when the
bridge is a module"). Grygorii Strashko, however, says about it:

| In my opinion, the problem is a bit bigger here than just fixing the
| build :(
|
| In case, of ^cpsw the switchdev mode is kinda optional and in many
| cases (especially for testing purposes, NFS) the multi-mac mode is
| still preferable mode.
|
| There were no such tight dependency between switchdev drivers and
| bridge core before and switchdev serviced as independent, notification
| based layer between them, so ^cpsw still can be "Y" and bridge can be
| "M". Now for mostly every kernel build configuration the CONFIG_BRIDGE
| will need to be set as "Y", or we will have to update drivers to
| support build with BRIDGE=n and maintain separate builds for
| networking vs non-networking testing.  But is this enough?  Wouldn't
| it cause 'chain reaction' required to add more and more "Y" options
| (like CONFIG_VLAN_8021Q)?
|
| PS. Just to be sure we on the same page - ARM builds will be forced
| (with this patch) to have CONFIG_TI_CPSW_SWITCHDEV=m and so all our
| automation testing will just fail with omap2plus_defconfig.

In the light of this, it would be desirable for some configurations to
avoid dependencies between switchdev drivers and the bridge, and have
the switchdev mode as completely optional within the driver.

Arnd Bergmann also tried to write a patch which better expressed the
build time dependency for Ethernet switch drivers where the switchdev
support is optional, like cpsw/am65-cpsw, and this made the drivers
follow the bridge (compile as module if the bridge is a module) only if
the optional switchdev support in the driver was enabled in the first
place:
https://patchwork.kernel.org/project/netdevbpf/patch/20210802144813.1152762-1-arnd@kernel.org/

but this still did not solve the fact that cpsw and am65-cpsw now must
be built as modules when the bridge is a module - it just expressed
correctly that optional dependency. But the new behavior is an apparent
regression from Grygorii's perspective.

So to support the use case where the Ethernet driver is built-in,
NET_SWITCHDEV (a bool option) is enabled, and the bridge is a module, we
need a framework that can handle the possible absence of the bridge from
the running system, i.e. runtime bloatware as opposed to build-time
bloatware.

Luckily we already have this framework, since switchdev has been using
it extensively. Events from the bridge side are transmitted to the
driver side using notifier chains - this was originally done so that
unrelated drivers could snoop for events emitted by the bridge towards
ports that are implemented by other drivers (think of a switch driver
with LAG offload that listens for switchdev events on a bonding/team
interface that it offloads).

There are also events which are transmitted from the driver side to the
bridge side, which again are modeled using notifiers.
SWITCHDEV_FDB_ADD_TO_BRIDGE is an example of this, and deals with
notifying the bridge that a MAC address has been dynamically learned.
So there is a precedent we can use for modeling the new framework.

The difference compared to SWITCHDEV_FDB_ADD_TO_BRIDGE is that the work
that the bridge needs to do when a port becomes offloaded is blocking in
its nature: replay VLANs, MDBs etc. The calling context is indeed
blocking (we are under rtnl_mutex), but the existing switchdev
notification chain that the bridge is subscribed to is only the atomic
one. So we need to subscribe the bridge to the blocking switchdev
notification chain too.

This patch:
- keeps the driver-side perception of the switchdev_bridge_port_{,un}offload
  unchanged
- moves the implementation of switchdev_bridge_port_{,un}offload from
  the bridge module into the switchdev module.
- makes everybody that is subscribed to the switchdev blocking notifier
  chain "hear" offload & unoffload events
- makes the bridge driver subscribe and handle those events
- moves the bridge driver's handling of those events into 2 new
  functions called br_switchdev_port_{,un}offload. These functions
  contain in fact the core of the logic that was previously in
  switchdev_bridge_port_{,un}offload, just that now we go through an
  extra indirection layer to reach them.

Unlike all the other switchdev notification structures, the structure
used to carry the bridge port information, struct
switchdev_notifier_brport_info, does not contain a "bool handled".
This is because in the current usage pattern, we always know that a
switchdev bridge port offloading event will be handled by the bridge,
because the switchdev_bridge_port_offload() call was initiated by a
NETDEV_CHANGEUPPER event in the first place, where info->upper_dev is a
bridge. So if the bridge wasn't loaded, then the CHANGEUPPER event
couldn't have happened.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
v1->v2: removed a bogus return value from a void function (the stub
        definition of br_switchdev_port_unoffload)

 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c       |  2 +-
 include/linux/if_bridge.h                | 35 ----------------
 include/net/switchdev.h                  | 46 +++++++++++++++++++++
 net/bridge/br.c                          | 51 +++++++++++++++++++++++-
 net/bridge/br_private.h                  | 29 ++++++++++++++
 net/bridge/br_switchdev.c                | 36 +++++------------
 net/switchdev/switchdev.c                | 48 ++++++++++++++++++++++
 8 files changed, 184 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4f67d1a98c0d..fb5d2ac3f0d2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -7,7 +7,6 @@
 
 #include <linux/clk.h>
 #include <linux/etherdevice.h>
-#include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -28,6 +27,7 @@
 #include <linux/sys_soc.h>
 #include <linux/dma/ti-cppi5.h>
 #include <linux/dma/k3-udma-glue.h>
+#include <net/switchdev.h>
 
 #include "cpsw_ale.h"
 #include "cpsw_sl.h"
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index b4f55ff4e84f..ae167223e87f 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/irqreturn.h>
 #include <linux/interrupt.h>
-#include <linux/if_bridge.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 #include <linux/net_tstamp.h>
@@ -29,6 +28,7 @@
 #include <linux/kmemleak.h>
 #include <linux/sys_soc.h>
 
+#include <net/switchdev.h>
 #include <net/page_pool.h>
 #include <net/pkt_cls.h>
 #include <net/devlink.h>
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 21daed10322e..509e18c7e740 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -190,39 +190,4 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_NET_SWITCHDEV)
-
-int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev, const void *ctx,
-				  struct notifier_block *atomic_nb,
-				  struct notifier_block *blocking_nb,
-				  bool tx_fwd_offload,
-				  struct netlink_ext_ack *extack);
-void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				     const void *ctx,
-				     struct notifier_block *atomic_nb,
-				     struct notifier_block *blocking_nb);
-
-#else
-
-static inline int
-switchdev_bridge_port_offload(struct net_device *brport_dev,
-			      struct net_device *dev, const void *ctx,
-			      struct notifier_block *atomic_nb,
-			      struct notifier_block *blocking_nb,
-			      bool tx_fwd_offload,
-			      struct netlink_ext_ack *extack)
-{
-	return -EINVAL;
-}
-
-static inline void
-switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				const void *ctx,
-				struct notifier_block *atomic_nb,
-				struct notifier_block *blocking_nb)
-{
-}
-#endif
-
 #endif
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 66468ff8cc0a..60d806b6a5ae 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -180,6 +180,14 @@ struct switchdev_obj_in_state_mrp {
 
 typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
 
+struct switchdev_brport {
+	struct net_device *dev;
+	const void *ctx;
+	struct notifier_block *atomic_nb;
+	struct notifier_block *blocking_nb;
+	bool tx_fwd_offload;
+};
+
 enum switchdev_notifier_type {
 	SWITCHDEV_FDB_ADD_TO_BRIDGE = 1,
 	SWITCHDEV_FDB_DEL_TO_BRIDGE,
@@ -197,6 +205,9 @@ enum switchdev_notifier_type {
 	SWITCHDEV_VXLAN_FDB_ADD_TO_DEVICE,
 	SWITCHDEV_VXLAN_FDB_DEL_TO_DEVICE,
 	SWITCHDEV_VXLAN_FDB_OFFLOADED,
+
+	SWITCHDEV_BRPORT_OFFLOADED,
+	SWITCHDEV_BRPORT_UNOFFLOADED,
 };
 
 struct switchdev_notifier_info {
@@ -226,6 +237,11 @@ struct switchdev_notifier_port_attr_info {
 	bool handled;
 };
 
+struct switchdev_notifier_brport_info {
+	struct switchdev_notifier_info info; /* must be first */
+	const struct switchdev_brport brport;
+};
+
 static inline struct net_device *
 switchdev_notifier_info_to_dev(const struct switchdev_notifier_info *info)
 {
@@ -246,6 +262,17 @@ switchdev_fdb_is_dynamically_learned(const struct switchdev_notifier_fdb_info *f
 
 #ifdef CONFIG_NET_SWITCHDEV
 
+int switchdev_bridge_port_offload(struct net_device *brport_dev,
+				  struct net_device *dev, const void *ctx,
+				  struct notifier_block *atomic_nb,
+				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
+				  struct netlink_ext_ack *extack);
+void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				     const void *ctx,
+				     struct notifier_block *atomic_nb,
+				     struct notifier_block *blocking_nb);
+
 void switchdev_deferred_process(void);
 int switchdev_port_attr_set(struct net_device *dev,
 			    const struct switchdev_attr *attr,
@@ -316,6 +343,25 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 				      struct netlink_ext_ack *extack));
 #else
 
+static inline int
+switchdev_bridge_port_offload(struct net_device *brport_dev,
+			      struct net_device *dev, const void *ctx,
+			      struct notifier_block *atomic_nb,
+			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
+			      struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void
+switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				const void *ctx,
+				struct notifier_block *atomic_nb,
+				struct notifier_block *blocking_nb)
+{
+}
+
 static inline void switchdev_deferred_process(void)
 {
 }
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 8fb5dca5f8e0..d3a32c6813e0 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -201,6 +201,48 @@ static struct notifier_block br_switchdev_notifier = {
 	.notifier_call = br_switchdev_event,
 };
 
+/* called under rtnl_mutex */
+static int br_switchdev_blocking_event(struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_brport_info *brport_info;
+	const struct switchdev_brport *b;
+	struct net_bridge_port *p;
+	int err = NOTIFY_DONE;
+
+	p = br_port_get_rtnl(dev);
+	if (!p)
+		goto out;
+
+	switch (event) {
+	case SWITCHDEV_BRPORT_OFFLOADED:
+		brport_info = ptr;
+		b = &brport_info->brport;
+
+		err = br_switchdev_port_offload(p, b->dev, b->ctx,
+						b->atomic_nb, b->blocking_nb,
+						b->tx_fwd_offload, extack);
+		err = notifier_from_errno(err);
+		break;
+	case SWITCHDEV_BRPORT_UNOFFLOADED:
+		brport_info = ptr;
+		b = &brport_info->brport;
+
+		br_switchdev_port_unoffload(p, b->ctx, b->atomic_nb,
+					    b->blocking_nb);
+		break;
+	}
+
+out:
+	return err;
+}
+
+static struct notifier_block br_switchdev_blocking_notifier = {
+	.notifier_call = br_switchdev_blocking_event,
+};
+
 /* br_boolopt_toggle - change user-controlled boolean option
  *
  * @br: bridge device
@@ -355,10 +397,14 @@ static int __init br_init(void)
 	if (err)
 		goto err_out4;
 
-	err = br_netlink_init();
+	err = register_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
 	if (err)
 		goto err_out5;
 
+	err = br_netlink_init();
+	if (err)
+		goto err_out6;
+
 	brioctl_set(br_ioctl_stub);
 
 #if IS_ENABLED(CONFIG_ATM_LANE)
@@ -373,6 +419,8 @@ static int __init br_init(void)
 
 	return 0;
 
+err_out6:
+	unregister_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
 err_out5:
 	unregister_switchdev_notifier(&br_switchdev_notifier);
 err_out4:
@@ -392,6 +440,7 @@ static void __exit br_deinit(void)
 {
 	stp_proto_unregister(&br_stp_proto);
 	br_netlink_fini();
+	unregister_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
 	unregister_switchdev_notifier(&br_switchdev_notifier);
 	unregister_netdevice_notifier(&br_device_notifier);
 	brioctl_set(NULL);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c939631428b9..10d43bf4bb80 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1880,6 +1880,17 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
+int br_switchdev_port_offload(struct net_bridge_port *p,
+			      struct net_device *dev, const void *ctx,
+			      struct notifier_block *atomic_nb,
+			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
+			      struct netlink_ext_ack *extack);
+
+void br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
+				 struct notifier_block *atomic_nb,
+				 struct notifier_block *blocking_nb);
+
 bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb);
 
 void br_switchdev_frame_set_offload_fwd_mark(struct sk_buff *skb);
@@ -1908,6 +1919,24 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
+static inline int
+br_switchdev_port_offload(struct net_bridge_port *p,
+			  struct net_device *dev, const void *ctx,
+			  struct notifier_block *atomic_nb,
+			  struct notifier_block *blocking_nb,
+			  bool tx_fwd_offload,
+			  struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void
+br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
+			    struct notifier_block *atomic_nb,
+			    struct notifier_block *blocking_nb)
+{
+}
+
 static inline bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb)
 {
 	return false;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a3cd79e3e81c..97129f09a5bf 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -315,23 +315,16 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 /* Let the bridge know that this port is offloaded, so that it can assign a
  * switchdev hardware domain to it.
  */
-int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev, const void *ctx,
-				  struct notifier_block *atomic_nb,
-				  struct notifier_block *blocking_nb,
-				  bool tx_fwd_offload,
-				  struct netlink_ext_ack *extack)
+int br_switchdev_port_offload(struct net_bridge_port *p,
+			      struct net_device *dev, const void *ctx,
+			      struct notifier_block *atomic_nb,
+			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
+			      struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
-	struct net_bridge_port *p;
 	int err;
 
-	ASSERT_RTNL();
-
-	p = br_port_get_rtnl(brport_dev);
-	if (!p)
-		return -ENODEV;
-
 	err = dev_get_port_parent_id(dev, &ppid, false);
 	if (err)
 		return err;
@@ -351,23 +344,12 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
 
-void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				     const void *ctx,
-				     struct notifier_block *atomic_nb,
-				     struct notifier_block *blocking_nb)
+void br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
+				 struct notifier_block *atomic_nb,
+				 struct notifier_block *blocking_nb)
 {
-	struct net_bridge_port *p;
-
-	ASSERT_RTNL();
-
-	p = br_port_get_rtnl(brport_dev);
-	if (!p)
-		return;
-
 	nbp_switchdev_unsync_objs(p, ctx, atomic_nb, blocking_nb);
 
 	nbp_switchdev_del(p);
 }
-EXPORT_SYMBOL_GPL(switchdev_bridge_port_unoffload);
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 0ae3478561f4..0b2c18efc079 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -809,3 +809,51 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 	return err;
 }
 EXPORT_SYMBOL_GPL(switchdev_handle_port_attr_set);
+
+int switchdev_bridge_port_offload(struct net_device *brport_dev,
+				  struct net_device *dev, const void *ctx,
+				  struct notifier_block *atomic_nb,
+				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
+				  struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_brport_info brport_info = {
+		.brport = {
+			.dev = dev,
+			.ctx = ctx,
+			.atomic_nb = atomic_nb,
+			.blocking_nb = blocking_nb,
+			.tx_fwd_offload = tx_fwd_offload,
+		},
+	};
+	int err;
+
+	ASSERT_RTNL();
+
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_BRPORT_OFFLOADED,
+						brport_dev, &brport_info.info,
+						extack);
+	return notifier_to_errno(err);
+}
+EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
+
+void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				     const void *ctx,
+				     struct notifier_block *atomic_nb,
+				     struct notifier_block *blocking_nb)
+{
+	struct switchdev_notifier_brport_info brport_info = {
+		.brport = {
+			.ctx = ctx,
+			.atomic_nb = atomic_nb,
+			.blocking_nb = blocking_nb,
+		},
+	};
+
+	ASSERT_RTNL();
+
+	call_switchdev_blocking_notifiers(SWITCHDEV_BRPORT_UNOFFLOADED,
+					  brport_dev, &brport_info.info,
+					  NULL);
+}
+EXPORT_SYMBOL_GPL(switchdev_bridge_port_unoffload);
-- 
2.25.1

