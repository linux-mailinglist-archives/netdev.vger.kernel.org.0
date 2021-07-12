Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804203C5F2C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbhGLPZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:43 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235496AbhGLPZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oL67/bv9Cd+N3oyjFkz+lbAGgeFVeeD0yRSapwkyq38pBLJOJZp3QNHJBJzICMGU70NM6hQfi5Mw/k7bhzLF4wl79W8KfkDIaRS/ghbtFgmS/FtRd0Guoz7ez42JGqaNV/5lmuqkc9e0kkSIP3Y5ipOVZLBrqgOkDyxo194qG5BFgE7ukCGKLFHLYZlxQ8XfEmnY1i6gnetrvTq+XYBfjA5vnlTXYTL6cRzc3Boe9ZuUDv/uzsNt//lBYEE7XpCRAYAWMuUffF9gRgQEO2QxJ1TN/ZH1Spos2WTqQ4QYpMYcesUlmIx8ppXhgk/WtAe1anVkbfRM+tP6SmjYiPggpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cjoPJicAY2Mvqd4VqOCEQx7uQOeuz9gVkjFbgVkVj8=;
 b=LjWfUDMkeA7he2D0p7QhYk0yI0A+rDYfDVTnJj3QEnuDB3cS9EiV+Gtvu0ZeSEoTDJ5qC1vcMVHSswxW6B7qPVzpXDZzYlsfnTLlF04HWgnXV2uciSC2ZP/oR2SdqyWPWBmbEu8ZuIWIhmVGUAzLrmVFDqogdh83fLAf5Bp1nUVJoJ3VgUmLjEKrRtIdjvnohI8yljnJpiPN4bzRxWUe5TVkF+0bNWFTtPIjwwr2C3lLpvDzvmgA3TJQ1rGLB7Kqcu8knLQfWf9U4Fse0UVodOlp9lIK7U69tRVVxIKxEfj+OOBIP9/lX9qgQSHsbKap8qLOx5sElKhCudMe08auBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cjoPJicAY2Mvqd4VqOCEQx7uQOeuz9gVkjFbgVkVj8=;
 b=C+xIAZwL1xYycVZv10QSF/N5idRHyiUD3SUZ0ITVCCTgGYELfqVXunupBj8zsXisSWNyHtatGLQOlcoCOYjU0kAVT3EeG489KUHYPfyBqWYU1C4Nf/asfdxM3yxkG7m1ZG9qVB5qg4Wb70L2T9Vkd72oil9iGAoqFDnGi+abzj0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 19/24] net: bridge: switchdev object replay helpers for everybody
Date:   Mon, 12 Jul 2021 18:21:37 +0300
Message-Id: <20210712152142.800651-20-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d4782af-b3f4-4059-1b3a-08d94548df38
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62717798DD0A7C6424A690A0E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaCNhBrvYaLnTIFw7OoRYqOF4OgM/biwu/y2dw81p4x8SDshVJk6x97jO7uF8p5FF87g/7zl6uG0mQsV+PTnD4fvm21UrynB4nchZRqeAI7/AgsYC4nO0luk7FSnh4R2UBSF/+RSAVxSXfcl1KNPv8Eu0Q9VAy6b8F20IuSmABbBWOZJHgaUISMxINfZi42SXMJE4OR5jar3McL+cknWKSmnLQnmQu29U3/Jd7pW7+dRoRbTOIzpu66aTuWCa5MAulULYfJP/Wtqcl1Jl6v63rx/66JmQyyCgVS0cmh9yKTc3edep0m0f7JUJjJgeJfgp1SVQc43CmLSP4YU8rnPC9qOPRkcTlsn6NiMf9AySJGH+jsRbM9aVxHl1nflKZEP3548MDqHt/QpDdIV/Dx3xQu463HOXz2fVj+7lFLQ3Ejqfvhs+E7G7/ZBmGwitT4JiQ3Uy/sR7Q5BnoolQJUU3hg0kXRbXV4ZpqsRrLoFkDvDQUjxA7yau8WQLshZ2p/jxyrRvBtjjHRvajLbxBLj5VWcqMXV7raMCHtnSRmWaGRswwxf25EpewzpV0i4HCB5P65erLqcxyP5QHl2ZExP+aAXXkEwKfjP2Bfehd+1SxIyH2V4iyBYyscg99HrE+dZt41eL5XXc+fQBvqMGT3tf3Euhzgk4TBchTNHsJdhzsxejOxGWBot2MAtIz9SMKySJYYmqOyJ38UudDQa/6FR3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(66574015)(83380400001)(66556008)(38100700002)(8676002)(30864003)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l2zxgVby5jmM7zRQMevCVqYfM6Pri6eQQoTOR70ivqeXiETPjrqaQcf8xBtO?=
 =?us-ascii?Q?gNmnnTLuuEQfvygNYvtyZODBNqwrSqt4UNL3/gAHbGozziZ8z7NUWbrDZdDW?=
 =?us-ascii?Q?SYdeuSJF80yy8B+tFSIw6P7NKXwjmlylWR2WjM8eum1Jh2o9dy7vdOVhEvep?=
 =?us-ascii?Q?rzdjBBEl/Raqmm6o5OW8zTF+qHMM/8gP9OJW9RSlLJ6jGoxZKGDJXf749RwU?=
 =?us-ascii?Q?dj0LRi4hso66Yb2zqrOeevQJBN8p2yUt128Wfmr9Z2S1telddnVEDETXSuxH?=
 =?us-ascii?Q?cMEkoNkN3olck08lJ4L/pPfXjUxSVafulnHI+MIZLpU9rpl1I9R3tXYUu93Y?=
 =?us-ascii?Q?HGg7I9zLPdi2wH1XcHM1If+Jgv4bdcecGIK71fgxG8nz0fMtIY0uBK8Rtm28?=
 =?us-ascii?Q?q+BVcpIEmHTDejjJJE/RoZfgaBScBkdoeItQvB1/kSThQSp7iREGqh3ZqvOH?=
 =?us-ascii?Q?u0cDLAi2GQZQrV6JIniPA60MzEbJKXlnhMmC8ZPNap5ofLZ1uISU2qszR6lk?=
 =?us-ascii?Q?7UtfRecGfaR8sqszDVwTOOvftIxBfMEW//GZ9yy1uspeVJOJabZJJ9tH8yFp?=
 =?us-ascii?Q?aDGpDjyNkpy+ojelSAig3I4FkX5nFT99SSNkCKR9hMEsWINmmAv/CVdfWn9F?=
 =?us-ascii?Q?697oEmsoMN65Rf2u70pidXVsDU5tKx8AXB5fOqzsjmmnw1ObPUyfPjUYU7+k?=
 =?us-ascii?Q?sLrMn5HiBFcrJrAgfV71meKiz/gwSlCVkklOnZ2GFW4Qw9Osq9fApM5Tkdtj?=
 =?us-ascii?Q?RwqfYLj2C8dvmjjPk77vgc/SDkfeVKSVsU0Vw9JdAw6q++AsC+lchaAjfoLp?=
 =?us-ascii?Q?yblBIoMhufSb63ItG60+EHPx4h3Kh2IS9bSGbHurPP4U3gi5vEJTiKYeUXSc?=
 =?us-ascii?Q?TWZcNR+UcVMPkB5fo9xdR596OydMgJwHqaoYRpQsVrvd76bQ8ZCjGDRNvEx2?=
 =?us-ascii?Q?XeH0P7tT/c+qRnM6vnJl+cUhDUlg5vhQJHxhep2domI/yr7EBEML/4tai8gB?=
 =?us-ascii?Q?vybUO2ZdvctX/etQimIkWhTN2+LMPpk3tGx+3Pn1KucU7TtFpUVVF8HCDh62?=
 =?us-ascii?Q?wcsRmLwHVmNf6M9V9pCYt5XYC53xxKIQMwXVSQzbeH8sMXs8kui+5ghAFHDF?=
 =?us-ascii?Q?SkBohjbUKx1CZ0s77JcRmZ3qPUt7BroL0OydG2Pq1TKiWQt/xiZu3xxBTzXr?=
 =?us-ascii?Q?Db0c2i6aa9Qbzw/qZ9omdFST/7dQ7Urk+pLB9iOVZpqr5zOHEENjDxpbfVQf?=
 =?us-ascii?Q?fn2jvv4F6VV9xw+qLpD2Hn92x2gxYaRd45AaJCF8ktlaWWI57dp6mkAHGYJl?=
 =?us-ascii?Q?VjFQt69fwaW5z0f6FHiUIUCM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4782af-b3f4-4059-1b3a-08d94548df38
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:33.6512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+LTOY2C4xb/dXUKWiQws4BsYMvwtWNnWiyQUDBIC/SQQBuZMhVeMagH0TuX9B3yV714dCbz1W/OE+t23agsaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with commit 4f2673b3a2b6 ("net: bridge: add helper to replay
port and host-joined mdb entries"), DSA has introduced some bridge
helpers that replay switchdev events (FDB/MDB/VLAN additions and
deletions) that can be lost by the switchdev drivers in a variety of
circumstances:

- an IP multicast group was host-joined on the bridge itself before any
  switchdev port joined the bridge, leading to the host MDB entries
  missing in the hardware database.
- during the bridge creation process, the MAC address of the bridge was
  added to the FDB as an entry pointing towards the bridge device
  itself, but with no switchdev ports being part of the bridge yet, this
  local FDB entry would remain unknown to the switchdev hardware
  database.
- a VLAN/FDB/MDB was added to a bridge port that is a LAG interface,
  before any switchdev port joined that LAG, leading to the hardware
  database missing those entries.
- a switchdev port left a LAG that is a bridge port, while the LAG
  remained part of the bridge, and all FDB/MDB/VLAN entries remained
  installed in the hardware database of the switchdev port.

Also, since commit 0d2cfbd41c4a ("net: bridge: ignore switchdev events
for LAG ports which didn't request replay"), DSA introduced a method,
based on a const void *ctx, to ensure that two switchdev ports under the
same LAG that is a bridge port do not see the same MDB/VLAN entry being
replayed twice by the bridge, once for every bridge port that joins the
LAG.

With so many ordering corner cases being possible, it seems unreasonable
to expect a switchdev driver writer to get it right from the first try.
Therefore, now that we are past the beta testing period for the bridge
replay helpers used in DSA only, it is time to roll them out to all
switchdev drivers.

To convert the switchdev object replay helpers from "pull mode" (where
the driver asks for them) to a "push mode" (where the bridge offers them
automatically), the biggest problem is that the bridge needs to be aware
when a switchdev port joins and leaves, even when the switchdev is only
indirectly a bridge port (for example when the bridge port is a LAG
upper of the switchdev).

Luckily, we already have a hook for that, in the form of the newly
introduced switchdev_bridge_port_offload() and
switchdev_bridge_port_unoffload() calls. These offer a natural place for
hooking the object addition and deletion replays.

Extend the above 2 functions with the "const void *ctx" argument
required for drivers to be able to disambiguate between which port is
targeted, when multiple ports are lowers of the same LAG that is a
bridge port. Most of the drivers pass NULL to this argument, except the
ones that support LAG offload and have the proper context check already
in place in the switchdev blocking notifier handler.

Also unexport the replay helpers, since nobody except the bridge calls
them directly now.

Note that:
(a) we abuse the terminology slightly, because FDB entries are not
    "switchdev objects", but we count them as objects nonetheless.
    With no direct way to prove it, I think they are not modeled as
    switchdev objects because those can only be installed by the bridge
    to the hardware (as opposed to FDB entries which can be propagated
    in the other direction too). This is merely an abuse of terms, FDB
    entries are replayed too, despite not being objects.
(b) the bridge does not attempt to sync port attributes to newly joined
    ports, just the countable stuff (the objects). The reason for this
    is simple: no universal and symmetric way to sync and unsync them is
    known. For example, VLAN filtering: what to do on unsync, disable or
    leave it enabled? Similarly, STP state, ageing timer, etc etc. What
    a switchdev port does when it becomes standalone again is not really
    up to the bridge's competence, and the driver should deal with it.
    On the other hand, replaying deletions of switchdev objects can be
    seen a matter of cleanup and therefore be treated by the bridge,
    hence this patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  4 +-
 .../marvell/prestera/prestera_switchdev.c     |  7 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  6 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  4 +-
 drivers/net/ethernet/mscc/ocelot_net.c        | 29 ++-----
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  4 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  4 +-
 include/linux/if_bridge.h                     | 32 +-------
 net/bridge/br_fdb.c                           |  1 -
 net/bridge/br_mdb.c                           |  1 -
 net/bridge/br_private.h                       | 21 ++++++
 net/bridge/br_switchdev.c                     | 75 ++++++++++++++++++-
 net/bridge/br_vlan.c                          |  1 -
 net/dsa/port.c                                | 64 ++--------------
 15 files changed, 128 insertions(+), 129 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 927502043910..94f5d47bb400 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1930,7 +1930,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	if (err)
 		goto err_egress_flood;
 
-	return switchdev_bridge_port_offload(netdev, netdev, extack);
+	return switchdev_bridge_port_offload(netdev, netdev, NULL, extack);
 
 err_egress_flood:
 	dpaa2_switch_port_set_fdb(port_priv, NULL);
@@ -1961,7 +1961,7 @@ static int dpaa2_switch_port_pre_bridge_leave(struct net_device *netdev,
 					      struct net_device *upper_dev,
 					      struct netlink_ext_ack *extack)
 {
-	return switchdev_bridge_port_unoffload(netdev, netdev, extack);
+	return switchdev_bridge_port_unoffload(netdev, netdev, NULL, extack);
 }
 
 static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 4be82c043991..37df803f93a3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -501,7 +501,8 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 		goto err_brport_create;
 	}
 
-	err = switchdev_bridge_port_offload(br_port->dev, port->dev, extack);
+	err = switchdev_bridge_port_offload(br_port->dev, port->dev, port,
+					    extack);
 	if (err)
 		goto err_brport_offload;
 
@@ -515,7 +516,7 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	return 0;
 
 err_port_join:
-	switchdev_bridge_port_unoffload(br_port->dev, port->dev, extack);
+	switchdev_bridge_port_unoffload(br_port->dev, port->dev, port, extack);
 err_brport_offload:
 	prestera_bridge_port_put(br_port);
 err_brport_create:
@@ -539,7 +540,7 @@ int prestera_pre_bridge_port_leave(struct net_device *br_dev,
 	if (!br_port)
 		return -ENODEV;
 
-	return switchdev_bridge_port_unoffload(br_port->dev, port->dev,
+	return switchdev_bridge_port_unoffload(br_port->dev, port->dev, port,
 					       extack);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 9f72912e4982..e4c4774dbc2b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2384,7 +2384,8 @@ int mlxsw_sp_port_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		goto err_port_join;
 
-	return switchdev_bridge_port_offload(brport_dev, dev, extack);
+	return switchdev_bridge_port_offload(brport_dev, dev, mlxsw_sp_port,
+					     extack);
 
 err_port_join:
 	mlxsw_sp_bridge_port_put(mlxsw_sp->bridge, bridge_port);
@@ -2398,7 +2399,8 @@ int mlxsw_sp_port_pre_bridge_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct net_device *dev = mlxsw_sp_port->dev;
 
-	return switchdev_bridge_port_unoffload(brport_dev, dev, extack);
+	return switchdev_bridge_port_unoffload(brport_dev, dev, mlxsw_sp_port,
+					       extack);
 }
 
 void mlxsw_sp_port_bridge_leave(struct mlxsw_sp_port *mlxsw_sp_port,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 270b9fabce91..51ac1c1ba546 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -116,7 +116,7 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 	 */
 	__dev_mc_unsync(ndev, sparx5_mc_unsync);
 
-	return switchdev_bridge_port_offload(ndev, ndev, extack);
+	return switchdev_bridge_port_offload(ndev, ndev, NULL, extack);
 }
 
 static int sparx5_port_pre_bridge_leave(struct sparx5_port *port,
@@ -124,7 +124,7 @@ static int sparx5_port_pre_bridge_leave(struct sparx5_port *port,
 {
 	struct net_device *ndev = port->ndev;
 
-	return switchdev_bridge_port_unoffload(ndev, ndev, extack);
+	return switchdev_bridge_port_unoffload(ndev, ndev, NULL, extack);
 }
 
 static void sparx5_port_bridge_leave(struct sparx5_port *port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 981adbf21200..7b0e38bfc240 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1154,36 +1154,19 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 				 struct net_device *bridge_dev,
 				 struct netlink_ext_ack *extack)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_port_private *priv;
 	clock_t ageing_time;
 	u8 stp_state;
-	int err;
-
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
 
 	ocelot_inherit_brport_flags(ocelot, port, brport_dev);
 
 	stp_state = br_port_get_stp_state(brport_dev);
 	ocelot_bridge_stp_state_set(ocelot, port, stp_state);
 
-	err = ocelot_port_vlan_filtering(ocelot, port,
-					 br_vlan_enabled(bridge_dev));
-	if (err)
-		return err;
-
 	ageing_time = br_get_ageing_time(bridge_dev);
 	ocelot_port_attr_ageing_set(ocelot, port, ageing_time);
 
-	err = br_mdb_replay(bridge_dev, brport_dev, priv, true, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	err = br_vlan_replay(bridge_dev, brport_dev, priv, true, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	return 0;
+	return ocelot_port_vlan_filtering(ocelot, port,
+					  br_vlan_enabled(bridge_dev));
 }
 
 static int ocelot_switchdev_unsync(struct ocelot *ocelot, int port)
@@ -1214,7 +1197,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 
 	ocelot_port_bridge_join(ocelot, port, bridge);
 
-	err = switchdev_bridge_port_offload(brport_dev, dev, extack);
+	err = switchdev_bridge_port_offload(brport_dev, dev, priv, extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -1225,7 +1208,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	return 0;
 
 err_switchdev_sync:
-	switchdev_bridge_port_unoffload(brport_dev, dev, extack);
+	switchdev_bridge_port_unoffload(brport_dev, dev, priv, extack);
 err_switchdev_offload:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
 	return err;
@@ -1235,7 +1218,9 @@ static int ocelot_netdevice_pre_bridge_leave(struct net_device *dev,
 					     struct net_device *brport_dev,
 					     struct netlink_ext_ack *extack)
 {
-	return switchdev_bridge_port_unoffload(brport_dev, dev, extack);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+
+	return switchdev_bridge_port_unoffload(brport_dev, dev, priv, extack);
 }
 
 static int ocelot_netdevice_bridge_leave(struct net_device *dev,
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 3569227e3a72..e629c58fed66 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2598,7 +2598,7 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 	if (err)
 		return err;
 
-	return switchdev_bridge_port_offload(dev, dev, extack);
+	return switchdev_bridge_port_offload(dev, dev, NULL, extack);
 }
 
 static int ofdpa_port_pre_bridge_leave(struct ofdpa_port *ofdpa_port,
@@ -2606,7 +2606,7 @@ static int ofdpa_port_pre_bridge_leave(struct ofdpa_port *ofdpa_port,
 {
 	struct net_device *dev = ofdpa_port->dev;
 
-	return switchdev_bridge_port_unoffload(dev, dev, extack);
+	return switchdev_bridge_port_unoffload(dev, dev, NULL, extack);
 }
 
 static int ofdpa_port_bridge_leave(struct ofdpa_port *ofdpa_port)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 30e8b21dc6db..b342a0dcf55e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2096,7 +2096,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, extack);
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, extack);
 	if (err)
 		return err;
 
@@ -2110,7 +2110,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
 static int am65_cpsw_netdevice_port_pre_unlink(struct net_device *ndev,
 					       struct netlink_ext_ack *extack)
 {
-	return switchdev_bridge_port_unoffload(ndev, ndev, extack);
+	return switchdev_bridge_port_unoffload(ndev, ndev, NULL, extack);
 }
 
 static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 8c586d1ff7d7..6ae0a7785089 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1517,7 +1517,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, extack);
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, extack);
 	if (err)
 		return err;
 
@@ -1531,7 +1531,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 static int cpsw_netdevice_port_pre_unlink(struct net_device *ndev,
 					  struct netlink_ext_ack *extack)
 {
-	return switchdev_bridge_port_unoffload(ndev, ndev, extack);
+	return switchdev_bridge_port_unoffload(ndev, ndev, NULL, extack);
 }
 
 static void cpsw_netdevice_port_unlink(struct net_device *ndev)
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 58624f393248..d3b8d00c43af 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -70,8 +70,6 @@ bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
 bool br_multicast_has_router_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
-int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, bool adding, struct netlink_ext_ack *extack);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
 					     struct list_head *br_ip_list)
@@ -103,12 +101,6 @@ static inline bool br_multicast_router(const struct net_device *dev)
 {
 	return false;
 }
-static inline int br_mdb_replay(const struct net_device *br_dev,
-				const struct net_device *dev, const void *ctx,
-				bool adding, struct netlink_ext_ack *extack)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
@@ -118,8 +110,6 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
 int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
-int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, bool adding, struct netlink_ext_ack *extack);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -146,13 +136,6 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 {
 	return -EINVAL;
 }
-
-static inline int br_vlan_replay(struct net_device *br_dev,
-				 struct net_device *dev, const void *ctx,
-				 bool adding, struct netlink_ext_ack *extack)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
@@ -163,8 +146,6 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
-int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  bool adding);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -193,28 +174,22 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 {
 	return 0;
 }
-
-static inline int br_fdb_replay(const struct net_device *br_dev,
-				const struct net_device *dev,
-				bool adding)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_NET_SWITCHDEV)
 
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev,
+				  struct net_device *dev, const void *ctx,
 				  struct netlink_ext_ack *extack);
 int switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				    struct net_device *dev,
+				    struct net_device *dev, const void *ctx,
 				    struct netlink_ext_ack *extack);
 
 #else
 
 static inline int switchdev_bridge_port_offload(struct net_device *brport_dev,
 						struct net_device *dev,
+						const void *ctx,
 						struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
@@ -222,6 +197,7 @@ static inline int switchdev_bridge_port_offload(struct net_device *brport_dev,
 
 static inline int switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 						  struct net_device *dev,
+						  const void *ctx,
 						  struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 4434aee4cfbc..da70bdd27692 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -761,7 +761,6 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(br_fdb_replay);
 
 static void fdb_notify(struct net_bridge *br,
 		       const struct net_bridge_fdb_entry *fdb, int type,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7753510a2099..35d0de24805a 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -686,7 +686,6 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(br_mdb_replay);
 
 static void br_mdb_switchdev_host_port(struct net_device *dev,
 				       struct net_device *lower_dev,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 763de4a503d9..3db745d49f4f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -735,6 +735,8 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 			  const unsigned char *addr, u16 vid, bool offloaded);
+int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
+		  bool adding);
 
 /* br_forward.c */
 enum br_pkt_type {
@@ -877,6 +879,9 @@ br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip);
 void br_multicast_del_group_src(struct net_bridge_group_src *src,
 				bool fastleave);
 
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  const void *ctx, bool adding, struct netlink_ext_ack *extack);
+
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
 	return group->proto == 0;
@@ -1135,6 +1140,13 @@ static inline int br_multicast_igmp_type(const struct sk_buff *skb)
 {
 	return 0;
 }
+
+static inline int br_mdb_replay(const struct net_device *br_dev,
+				const struct net_device *dev, const void *ctx,
+				bool adding, struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /* br_vlan.c */
@@ -1185,6 +1197,8 @@ void br_vlan_notify(const struct net_bridge *br,
 		    const struct net_bridge_port *p,
 		    u16 vid, u16 vid_range,
 		    int cmd);
+int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
+		   const void *ctx, bool adding, struct netlink_ext_ack *extack);
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end);
 
@@ -1427,6 +1441,13 @@ static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 {
 	return true;
 }
+
+static inline int br_vlan_replay(struct net_device *br_dev,
+				 struct net_device *dev, const void *ctx,
+				 bool adding, struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /* br_vlan_options.c */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 90aad6a4c32c..70d8e30f6155 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -214,11 +214,65 @@ static void nbp_switchdev_del(struct net_bridge_port *p,
 		nbp_switchdev_hwdom_put(p);
 }
 
+static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
+				   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = br_mdb_replay(p->br->dev, p->dev, ctx, true, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	/* Forwarding and termination FDB entries on the port */
+	err = br_fdb_replay(p->br->dev, p->dev, true);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	/* Termination FDB entries on the bridge itself */
+	err = br_fdb_replay(p->br->dev, p->br->dev, true);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_vlan_replay(p->br->dev, p->dev, ctx, true, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+static int nbp_switchdev_unsync_objs(struct net_bridge_port *p,
+				     const void *ctx,
+				     struct netlink_ext_ack *extack)
+{
+	int err;
+
+	/* Delete the switchdev objects left on this port */
+	err = br_mdb_replay(p->br->dev, p->dev, ctx, false, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	/* Forwarding and termination FDB entries on the port */
+	err = br_fdb_replay(p->br->dev, p->dev, false);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	/* Termination FDB entries on the bridge itself */
+	err = br_fdb_replay(p->br->dev, p->br->dev, false);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_vlan_replay(p->br->dev, p->dev, ctx, false, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
 /* Let the bridge know that this port is offloaded, so that it can assign a
  * switchdev hardware domain to it.
  */
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev,
+				  struct net_device *dev, const void *ctx,
 				  struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
@@ -235,12 +289,25 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 	if (err)
 		return err;
 
-	return nbp_switchdev_add(p, ppid, extack);
+	err = nbp_switchdev_add(p, ppid, extack);
+	if (err)
+		return err;
+
+	err = nbp_switchdev_sync_objs(p, ctx, extack);
+	if (err)
+		goto out_switchdev_del;
+
+	return 0;
+
+out_switchdev_del:
+	nbp_switchdev_del(p, ppid);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
 
 int switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				    struct net_device *dev,
+				    struct net_device *dev, const void *ctx,
 				    struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
@@ -257,6 +324,8 @@ int switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 	if (err)
 		return err;
 
+	nbp_switchdev_unsync_objs(p, ctx, extack);
+
 	nbp_switchdev_del(p, ppid);
 
 	return 0;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index ad2d1e56c6e4..0bde36da0e69 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1875,7 +1875,6 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(br_vlan_replay);
 
 /* check if v_curr can enter a range ending in range_end */
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 63a244858e2b..c109c358b0bd 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -167,8 +167,8 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 	}
 }
 
-static int dsa_port_switchdev_sync(struct dsa_port *dp,
-				   struct netlink_ext_ack *extack)
+static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
+					 struct netlink_ext_ack *extack)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct net_device *br = dp->bridge_dev;
@@ -194,53 +194,6 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_mdb_replay(br, brport_dev, dp, true, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, true);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, true);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	err = br_vlan_replay(br, brport_dev, dp, true, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	return 0;
-}
-
-static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
-					  struct net_device *br,
-					  struct netlink_ext_ack *extack)
-{
-	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
-	int err;
-
-	/* Delete the switchdev objects left on this port */
-	err = br_mdb_replay(br, brport_dev, dp, false, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, false);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, false);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	err = br_vlan_replay(br, brport_dev, dp, false, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
 	return 0;
 }
 
@@ -301,18 +254,18 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	err = switchdev_bridge_port_offload(brport_dev, dev, extack);
+	err = switchdev_bridge_port_offload(brport_dev, dev, dp, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
-	err = dsa_port_switchdev_sync(dp, extack);
+	err = dsa_port_switchdev_sync_attrs(dp, extack);
 	if (err)
 		goto out_rollback_unoffload;
 
 	return 0;
 
 out_rollback_unoffload:
-	switchdev_bridge_port_unoffload(brport_dev, dev, extack);
+	switchdev_bridge_port_unoffload(brport_dev, dev, dp, extack);
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 out_rollback:
@@ -325,13 +278,8 @@ int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct net_device *dev = dp->slave;
-	int err;
-
-	err = switchdev_bridge_port_unoffload(brport_dev, dev, extack);
-	if (err)
-		return err;
 
-	return dsa_port_switchdev_unsync_objs(dp, br, extack);
+	return switchdev_bridge_port_unoffload(brport_dev, dev, dp, extack);
 }
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
-- 
2.25.1

