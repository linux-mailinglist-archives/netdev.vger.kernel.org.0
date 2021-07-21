Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF873D141E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhGUPpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:45:34 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:52896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234950AbhGUPpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:45:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n66FgwCIkA6nujflNLHNKEfe8i5O6ZW8sW64Jqsth5UTGEnlWZeh3j9raG9fNCMsY2yieqV1UdaythheUlfBVutaP848w3ylA6sL9s8iEgCdKOuPA8gMrRFVa2kMkuDz3c0aAWYaDMOqv2x1an2z+kJTYmpCD0SyhJxCqCy604M/XoUY8zy5BdTxCR86Jma5niNMCEQr8nqgKZp6v4gfJX7W5XYkSfe48DiudnAJZg7LkMhKK5NUBxFrJ+Ld3SLH5KaD+fYAdRuozkHQ5pOA4IccaijHrJwB0QWAFzS/+M2LMDs0iOfFsPSz9T/SCBLJYnoXHsath3Bd+N+VJtJV+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qF2zDscd9PTyvC3mCQtTqIjDiIE3ugVsnh5pw8UkXEs=;
 b=Smk8SUzhRlm0ltfmZzsap8UZJbz9BMPA8/W51oBDfgbz3Gsd7O/t/RQTDoMBBqidQOOknvk4FJXAX2o+KjsVO9xspgDaMmd7qSW7Z+kyAm3WT+8hS94FC+ESQxBeGdHcvMU/Hh8BUofwCErBMbBDjOvODkTEeUwAhAzROvKm6514m8I7682yGpheIaZPiPBIzYscy+5qigjw6RhRE3IpKo4b6UsFT6iIwgrGXDWXZKfC82x17SgobWvJNiUOnnhQCuT/5cE08Puxv4nTVuCBXRe/W+ynLp5Z3/zSjtph1HvYohWL7MQlfZIP558D2KTzedcdeQziKOeDKrLpTpB6tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qF2zDscd9PTyvC3mCQtTqIjDiIE3ugVsnh5pw8UkXEs=;
 b=c7v8jPeqBLKqgT1U0/gfe3jlVu6ZIALKsQ6ZSEJmJl2QI0BkPoIuso2DzMpu/8Gfc5pQbBrp2Q4Pg98cgIB5B93AK8SYeOSUeHO104JF0pPyL94grkdP0ix3Y7GeYtjiEhfA9RRezn9G7f9M2pMcNE9SEG8n/kHp+C8RPTOnmGo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3197.eurprd04.prod.outlook.com (2603:10a6:802:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 16:25:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 16:25:30 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH v6 net-next 7/7] net: bridge: move the switchdev object replay helpers to "push" mode
Date:   Wed, 21 Jul 2021 19:24:03 +0300
Message-Id: <20210721162403.1988814-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 16:25:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27832c41-2386-4306-27fb-08d94c6427ba
X-MS-TrafficTypeDiagnostic: VI1PR04MB3197:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB319738F515D8122EF6A78484E0E39@VI1PR04MB3197.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FpQ6L6O4Q73IDk03qp7hn5Bo7Q4I4kBczYXICWtHJAIRuJVxNeyyPIHVxSsz1B0brApT4HqaqVK5jw3tKgooj1wpxqUdt3/Gs26+/JX3gDM6d2jX6OHvTLxfDBwFR2qn/Yy8Hn9PlxUarVhMURpUHQMDKEiU6s9F3SAcFZGIM1N/Z4BO7NqCDPvwMA16kKkobtC4RxnSm0fJmKshKFzucgqtehe/pa+4ghkRLXgTGQa3RyDTWXnd4VSJFSm8KHwQjLe2HZLjGUDdlqIuCfQ72AUPigRDtw182eD7TyUx/ZpBClARADP7wSJTqQ1QDIhAxXDyGKQMZtHjP2PNJ/KX2MlHetFMaYmWHlClWTc3pj1DtcjQqwR4ZpHV3vL8NWBJnsVXlkINDrnAktmxmnDnGdbSeYP/St4rdQhQwNWvisD1AkHKoA2Vey8wcGLdNgvaxsdvDUwESo6oQtClZoMBdvUQaD31NuPOIoj3Z4yQuSA8KQ6fCkc/vmd8zLt4xuNrBT1NQQyWdFPrrZIoa1V9p1zV5meM7+aqN1BP4GIvKaaaWpWiWI8ZJ4PFYQUS04DB8GmS/kWqodhjCP0EnBzt0uOuKDgsZdEioJjSOCBRhVutj8uRRxupzTJ15QYgDn2VYyOtwfn7GDjFDxrZTVA61G6Sl+dugISawtO4S3opFLJHoro2SANyeFR5fctYAgg8ZNW3nsxc6cktuMz6Y+ufrx7IflBXyEIRPZHqjoagAd8GgJUCxM5EYnuch55CNlyq0M8PX2tN9+ahGCSTDqFSng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(366004)(346002)(966005)(8936002)(44832011)(38100700002)(2906002)(26005)(66574015)(66946007)(6666004)(186003)(83380400001)(6512007)(8676002)(478600001)(6506007)(86362001)(36756003)(38350700002)(1076003)(5660300002)(30864003)(316002)(7416002)(4326008)(66556008)(66476007)(52116002)(2616005)(110136005)(54906003)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7EKKyvPHeMYXYRO5sC5XzozhfP7JdSh06yLWbhSEXjwphFuq4i0PE5eYxRNS?=
 =?us-ascii?Q?9x9xhcFLI5rMX6GOhYL82SjEwWATDpq07SWF1oL5wupUW2Ul7/rqq3gX3WYy?=
 =?us-ascii?Q?06nvQr9VYWkJf+ZpXFvFwNTV28HjKrF+es3I881iPTQN7AuiywiNKNhexCu2?=
 =?us-ascii?Q?QckxkkyiHIfkkdR+YH6jmyOnMxc4uxhJIDHCcUyu+fA+BPZvo3YS+aM+iNrr?=
 =?us-ascii?Q?4OzlEhv0tJ0cUqOw5tLnkMK14gkJqlpkf7aArlhDqvrZ2kLtWb1z0w+4SApf?=
 =?us-ascii?Q?jVIMjldv6vhJ2SKLD+3TbAu61yODV0qCNM5SEq+XMcvR0DNOmwPzV19jfT1T?=
 =?us-ascii?Q?+pvnZElad2GFweOznMpglQGmHSffslXXLsO/mIVuEGhK987iqqqXPB0WJbRr?=
 =?us-ascii?Q?ZGOOgyDaNB3pzZ6ojsI6n8NftGB8RuLx3R2btWD2yiTepYQFL5z0Lf1zRvS4?=
 =?us-ascii?Q?+pVLIeTbNo50b5fQapoGL8EXz2CFVCdYZMG82aJNxeONE3Lfvi1JyielynoP?=
 =?us-ascii?Q?GyNBNBSwrgtxk54sg2ptRcyFlloeSW0WXjFRTbSkf5jRzMMV42VvdclVSe0c?=
 =?us-ascii?Q?ahoEfaZyVAPUvlZyZc3zTXmUfHjN3odXvWg+uoBPcqt709YEqKlh5in/0D2F?=
 =?us-ascii?Q?ABLZD8KXOFDH1TlbGo4hxXERc+cNnz8CRZSi3XyvGGOJ19yOjyL/zCErbGN0?=
 =?us-ascii?Q?pZlNkEKGfzjGqmLZTEIV1mk7kfBtVDYIVx/9BRWaeDIdXGLsGPoPYUxI6WER?=
 =?us-ascii?Q?dVF9G2rmKTVAR2aTwxUQOnU8w1NCywR+w9FQisMCTV8dLwr+qjUEr8wy31bp?=
 =?us-ascii?Q?K03Tj74DKYhffsE8QSK9O9GL+kSA+mTOS7x0I9TVH5X7utp4YVn4dqoVus+f?=
 =?us-ascii?Q?ePKTKKJQ+IWHjrxiV9u2wdYSd1ZXHEcpfOhyxnny+QXtOddtvPfhHQlTsfvh?=
 =?us-ascii?Q?UutMSat3kRKTwRzwhiYgfApRoQvhTc4pSSa3W0WiDd/HKYmn9yqILs/GGi0I?=
 =?us-ascii?Q?Is+eYSpNH/KYqeB3sw06X9+i1S7NdkZjmQ1NRTqUDw6r0xBhMAKqFWoN8St0?=
 =?us-ascii?Q?WYYd5CGsHMDumMwQJ+SU45iCGbmJ5aMDIQ66KcKwLyBWV9mS7noe1nIpryiK?=
 =?us-ascii?Q?lIZckifIMHa4WjvqU6AGnZQdMOjOrDurlUGyhcr3i1bUMeYlDNGOoP8jygxE?=
 =?us-ascii?Q?VnqTg86qOj0jfr92Sza+68ia4PFsEhuLh3CAxFSgL4W2qcuXDir1eJyFHj5q?=
 =?us-ascii?Q?UNh/tBVf5ToyTk6OEIxuQWp/wQRX8oFPAiLqqUZwLhQEDsqkiapFBercvPP3?=
 =?us-ascii?Q?MAxwPTwRDDLF+xu+iq/E/WRj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27832c41-2386-4306-27fb-08d94c6427ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:25:29.8576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+hPCM8socVLhTdjWj8VZOqpi79buYCcTILxzZ4eVNsJzFc+dHKcedVPuD31fXkZrjFjgXIbes1UB/jPMLrf+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3197
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
Therefore, now that DSA has experimented with the bridge replay helpers
for a little bit, we can move the code to the bridge driver where it is
more readily available to all switchdev drivers.

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

Extend the above 2 functions with:
- pointers to the switchdev atomic notifier (for FDB replays) and the
  blocking notifier (for MDB and VLAN replays).
- the "const void *ctx" argument required for drivers to be able to
  disambiguate between which port is targeted, when multiple ports are
  lowers of the same LAG that is a bridge port. Most of the drivers pass
  NULL to this argument, except the ones that support LAG offload and have
  the proper context check already in place in the switchdev blocking
  notifier handler.

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

We make the replay helpers opt-in for drivers, because they might not
bring immediate benefits for them:

- nbp_vlan_init() is called _after_ netdev_master_upper_dev_link(),
  so br_vlan_replay() should not do anything for the new drivers on
  which we call it. The existing drivers where there was even a slight
  possibility for there to exist a VLAN on a bridge port before they
  join it are already guarded against this: mlxsw and prestera deny
  joining LAG interfaces that are members of a bridge.

- br_fdb_replay() should now notify of local FDB entries, but I patched
  all drivers except DSA to ignore these new entries in commit
  2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB
  notifications"). Driver authors can lift this restriction as they
  wish, and when they do, they can also opt into the FDB replay
  functionality.

- br_mdb_replay() should fix a real issue which is described in commit
  4f2673b3a2b6 ("net: bridge: add helper to replay port and host-joined
  mdb entries"). However most drivers do not offload the
  SWITCHDEV_OBJ_ID_HOST_MDB to see this issue: only cpsw and am65_cpsw
  offload this switchdev object, and I don't completely understand the
  way in which they offload this switchdev object anyway. So I'll leave
  it up to these drivers' respective maintainers to opt into
  br_mdb_replay().

So most of the drivers pass NULL notifier blocks for the replay helpers,
except:
- dpaa2-switch which was already acked/regression-tested with the
  helpers enabled (and there isn't much of a downside in having them)
- ocelot which already had replay logic in "pull" mode
- DSA which already had replay logic in "pull" mode

An important observation is that the drivers which don't currently
request bridge event replays don't even have the
switchdev_bridge_port_{offload,unoffload} calls placed in proper places
right now. This was done to avoid unnecessary rework for drivers which
might never even add support for this. For driver writers who wish to
add replay support, this can be used as a tentative placement guide:
https://patchwork.kernel.org/project/netdevbpf/patch/20210720134655.892334-11-vladimir.oltean@nxp.com/

Cc: Vadym Kochan <vkochan@marvell.com>
Cc: Taras Chornyi <tchornyi@marvell.com>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com> # dpaa2-switch
---
v2->v3: patch is new
v3->v4: passing the switchdev notifier blocks as argument to
        switchdev_bridge_port_offload()
v4->v5: fixed the reference to the proper br_mdb_replay() patch in the
        commit message
v5->v6:
- make the event replay optional
- opt out of replays for mlxsw, rocker, prestera, sparx5, cpsw,
  am65-cpsw

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 12 ++-
 .../marvell/prestera/prestera_switchdev.c     |  7 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  4 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  5 +-
 drivers/net/ethernet/mscc/ocelot_net.c        | 45 ++++------
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  5 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  5 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  5 +-
 include/linux/if_bridge.h                     | 54 ++++--------
 net/bridge/br_fdb.c                           |  1 -
 net/bridge/br_mdb.c                           |  1 -
 net/bridge/br_private.h                       | 25 ++++++
 net/bridge/br_switchdev.c                     | 75 ++++++++++++++++-
 net/bridge/br_vlan.c                          |  1 -
 net/dsa/dsa_priv.h                            |  6 +-
 net/dsa/port.c                                | 84 ++++---------------
 net/dsa/slave.c                               | 10 +--
 17 files changed, 182 insertions(+), 163 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 9b090da3e460..2138239facfd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1889,6 +1889,9 @@ static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
 	return notifier_from_errno(err);
 }
 
+static struct notifier_block dpaa2_switch_port_switchdev_nb;
+static struct notifier_block dpaa2_switch_port_switchdev_blocking_nb;
+
 static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 					 struct net_device *upper_dev,
 					 struct netlink_ext_ack *extack)
@@ -1930,7 +1933,10 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	if (err)
 		goto err_egress_flood;
 
-	err = switchdev_bridge_port_offload(netdev, netdev, extack);
+	err = switchdev_bridge_port_offload(netdev, netdev, NULL,
+					    &dpaa2_switch_port_switchdev_nb,
+					    &dpaa2_switch_port_switchdev_blocking_nb,
+					    extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -1964,7 +1970,9 @@ static int dpaa2_switch_port_restore_rxvlan(struct net_device *vdev, int vid, vo
 
 static void dpaa2_switch_port_pre_bridge_leave(struct net_device *netdev)
 {
-	switchdev_bridge_port_unoffload(netdev);
+	switchdev_bridge_port_unoffload(netdev, NULL,
+					&dpaa2_switch_port_switchdev_nb,
+					&dpaa2_switch_port_switchdev_blocking_nb);
 }
 
 static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 8cf3fe3b7e58..7fe1287228e5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -501,7 +501,8 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 		goto err_brport_create;
 	}
 
-	err = switchdev_bridge_port_offload(br_port->dev, port->dev, extack);
+	err = switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,
+					    NULL, NULL, extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -515,7 +516,7 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	return 0;
 
 err_port_join:
-	switchdev_bridge_port_unoffload(br_port->dev);
+	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 err_switchdev_offload:
 	prestera_bridge_port_put(br_port);
 err_brport_create:
@@ -591,7 +592,7 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 	else
 		prestera_bridge_1d_port_leave(br_port);
 
-	switchdev_bridge_port_unoffload(br_port->dev);
+	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
 	prestera_hw_port_learning_set(port, false);
 	prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index c52317de1f35..0a53f1d8e7e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -362,7 +362,7 @@ mlxsw_sp_bridge_port_create(struct mlxsw_sp_bridge_device *bridge_device,
 	bridge_port->ref_count = 1;
 
 	err = switchdev_bridge_port_offload(brport_dev, mlxsw_sp_port->dev,
-					    extack);
+					    NULL, NULL, NULL, extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -377,7 +377,7 @@ mlxsw_sp_bridge_port_create(struct mlxsw_sp_bridge_device *bridge_device,
 static void
 mlxsw_sp_bridge_port_destroy(struct mlxsw_sp_bridge_port *bridge_port)
 {
-	switchdev_bridge_port_unoffload(bridge_port->dev);
+	switchdev_bridge_port_unoffload(bridge_port->dev, NULL, NULL, NULL);
 	list_del(&bridge_port->list);
 	WARN_ON(!list_empty(&bridge_port->vlans_list));
 	kfree(bridge_port);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index e4fb573563d0..807dc45cfae4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -112,7 +112,8 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 
 	set_bit(port->portno, sparx5->bridge_mask);
 
-	err = switchdev_bridge_port_offload(ndev, ndev, extack);
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
+					    extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -133,7 +134,7 @@ static void sparx5_port_bridge_leave(struct sparx5_port *port,
 {
 	struct sparx5 *sparx5 = port->sparx5;
 
-	switchdev_bridge_port_unoffload(port->ndev);
+	switchdev_bridge_port_unoffload(port->ndev, NULL, NULL, NULL);
 
 	clear_bit(port->portno, sparx5->bridge_mask);
 	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 76b7b9536bf7..3558ee8d9212 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1154,38 +1154,19 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
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
 
-	err = br_mdb_replay(bridge_dev, brport_dev, priv, true,
-			    &ocelot_switchdev_blocking_nb, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	err = br_vlan_replay(bridge_dev, brport_dev, priv, true,
-			     &ocelot_switchdev_blocking_nb, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	return 0;
+	return ocelot_port_vlan_filtering(ocelot, port,
+					  br_vlan_enabled(bridge_dev));
 }
 
 static int ocelot_switchdev_unsync(struct ocelot *ocelot, int port)
@@ -1216,7 +1197,10 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 
 	ocelot_port_bridge_join(ocelot, port, bridge);
 
-	err = switchdev_bridge_port_offload(brport_dev, dev, extack);
+	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
+					    &ocelot_netdevice_nb,
+					    &ocelot_switchdev_blocking_nb,
+					    extack);
 	if (err)
 		goto err_switchdev_offload;
 
@@ -1227,15 +1211,22 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	return 0;
 
 err_switchdev_sync:
-	switchdev_bridge_port_unoffload(brport_dev);
+	switchdev_bridge_port_unoffload(brport_dev, priv,
+					&ocelot_netdevice_nb,
+					&ocelot_switchdev_blocking_nb);
 err_switchdev_offload:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
 	return err;
 }
 
-static void ocelot_netdevice_pre_bridge_leave(struct net_device *brport_dev)
+static void ocelot_netdevice_pre_bridge_leave(struct net_device *dev,
+					      struct net_device *brport_dev)
 {
-	switchdev_bridge_port_unoffload(brport_dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+
+	switchdev_bridge_port_unoffload(brport_dev, priv,
+					&ocelot_netdevice_nb,
+					&ocelot_switchdev_blocking_nb);
 }
 
 static int ocelot_netdevice_bridge_leave(struct net_device *dev,
@@ -1299,7 +1290,7 @@ static void ocelot_netdevice_pre_lag_leave(struct net_device *dev,
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return;
 
-	ocelot_netdevice_pre_bridge_leave(bond);
+	ocelot_netdevice_pre_bridge_leave(dev, bond);
 }
 
 static int ocelot_netdevice_lag_leave(struct net_device *dev,
@@ -1384,7 +1375,7 @@ ocelot_netdevice_prechangeupper(struct net_device *dev,
 				struct netdev_notifier_changeupper_info *info)
 {
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
-		ocelot_netdevice_pre_bridge_leave(brport_dev);
+		ocelot_netdevice_pre_bridge_leave(dev, brport_dev);
 
 	if (netif_is_lag_master(info->upper_dev) && !info->linking)
 		ocelot_netdevice_pre_lag_leave(dev, info->upper_dev);
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 84dcaf8687a0..03df6a24d0ba 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2598,7 +2598,8 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 	if (err)
 		return err;
 
-	return switchdev_bridge_port_offload(dev, dev, extack);
+	return switchdev_bridge_port_offload(dev, dev, NULL, NULL, NULL,
+					     extack);
 }
 
 static int ofdpa_port_bridge_leave(struct ofdpa_port *ofdpa_port)
@@ -2606,7 +2607,7 @@ static int ofdpa_port_bridge_leave(struct ofdpa_port *ofdpa_port)
 	struct net_device *dev = ofdpa_port->dev;
 	int err;
 
-	switchdev_bridge_port_unoffload(dev);
+	switchdev_bridge_port_unoffload(dev, NULL, NULL, NULL);
 
 	err = ofdpa_port_vlan_del(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
 	if (err)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8b9596eb808e..b285606f963d 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2096,7 +2096,8 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, extack);
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
+					    extack);
 	if (err)
 		return err;
 
@@ -2112,7 +2113,7 @@ static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
 
-	switchdev_bridge_port_unoffload(ndev);
+	switchdev_bridge_port_unoffload(ndev, NULL, NULL, NULL);
 
 	common->br_members &= ~BIT(priv->port->port_id);
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index bf9cadfb11b5..31030f73840d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1517,7 +1517,8 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, extack);
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
+					    extack);
 	if (err)
 		return err;
 
@@ -1533,7 +1534,7 @@ static void cpsw_netdevice_port_unlink(struct net_device *ndev)
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
 
-	switchdev_bridge_port_unoffload(ndev);
+	switchdev_bridge_port_unoffload(ndev, NULL, NULL, NULL);
 
 	cpsw->br_members &= ~BIT(priv->emac_port);
 
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index ce413eca527e..bbf680093823 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -70,9 +70,6 @@ bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
 bool br_multicast_has_router_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
-int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb,
-		  struct netlink_ext_ack *extack);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
 					     struct list_head *br_ip_list)
@@ -104,13 +101,6 @@ static inline bool br_multicast_router(const struct net_device *dev)
 {
 	return false;
 }
-static inline int br_mdb_replay(const struct net_device *br_dev,
-				const struct net_device *dev, const void *ctx,
-				bool adding, struct notifier_block *nb,
-				struct netlink_ext_ack *extack)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
@@ -120,9 +110,6 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
 int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
-int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, bool adding, struct notifier_block *nb,
-		   struct netlink_ext_ack *extack);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -149,14 +136,6 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 {
 	return -EINVAL;
 }
-
-static inline int br_vlan_replay(struct net_device *br_dev,
-				 struct net_device *dev, const void *ctx,
-				 bool adding, struct notifier_block *nb,
-				 struct netlink_ext_ack *extack)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
@@ -167,8 +146,6 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
-int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -197,32 +174,37 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 {
 	return 0;
 }
-
-static inline int br_fdb_replay(const struct net_device *br_dev,
-				const struct net_device *dev, const void *ctx,
-				bool adding, struct notifier_block *nb)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_NET_SWITCHDEV)
 
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev,
+				  struct net_device *dev, const void *ctx,
+				  struct notifier_block *atomic_nb,
+				  struct notifier_block *blocking_nb,
 				  struct netlink_ext_ack *extack);
-void switchdev_bridge_port_unoffload(struct net_device *brport_dev);
+void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				     const void *ctx,
+				     struct notifier_block *atomic_nb,
+				     struct notifier_block *blocking_nb);
 
 #else
 
-static inline int switchdev_bridge_port_offload(struct net_device *brport_dev,
-						struct net_device *dev,
-						struct netlink_ext_ack *extack)
+static inline int
+switchdev_bridge_port_offload(struct net_device *brport_dev,
+			      struct net_device *dev, const void *ctx,
+			      struct notifier_block *atomic_nb,
+			      struct notifier_block *blocking_nb,
+			      struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
 }
 
-static inline void switchdev_bridge_port_unoffload(struct net_device *brport_dev)
+static inline void
+switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				const void *ctx,
+				struct notifier_block *atomic_nb,
+				struct notifier_block *blocking_nb)
 {
 }
 #endif
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 47f190b6bfa3..7747442e6572 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -795,7 +795,6 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(br_fdb_replay);
 
 static void fdb_notify(struct net_bridge *br,
 		       const struct net_bridge_fdb_entry *fdb, int type,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 09358c475787..b8ddd6b6c7fe 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -689,7 +689,6 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(br_mdb_replay);
 
 static void br_mdb_switchdev_host_port(struct net_device *dev,
 				       struct net_device *lower_dev,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 8d2e4d807808..978405cc1a91 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -769,6 +769,8 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 			  const unsigned char *addr, u16 vid, bool offloaded);
+int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
+		  const void *ctx, bool adding, struct notifier_block *nb);
 
 /* br_forward.c */
 enum br_pkt_type {
@@ -928,6 +930,10 @@ int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 				      struct netlink_ext_ack *extack);
 bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan, bool on);
 
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  const void *ctx, bool adding, struct notifier_block *nb,
+		  struct netlink_ext_ack *extack);
+
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
 	return group->proto == 0;
@@ -1306,6 +1312,14 @@ static inline bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan,
 {
 	return false;
 }
+
+static inline int br_mdb_replay(struct net_device *br_dev,
+				struct net_device *dev, const void *ctx,
+				bool adding, struct notifier_block *nb,
+				struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /* br_vlan.c */
@@ -1357,6 +1371,9 @@ void br_vlan_notify(const struct net_bridge *br,
 		    const struct net_bridge_port *p,
 		    u16 vid, u16 vid_range,
 		    int cmd);
+int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
+		   const void *ctx, bool adding, struct notifier_block *nb,
+		   struct netlink_ext_ack *extack);
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end);
 
@@ -1602,6 +1619,14 @@ static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 {
 	return true;
 }
+
+static inline int br_vlan_replay(struct net_device *br_dev,
+				 struct net_device *dev, const void *ctx,
+				 bool adding, struct notifier_block *nb,
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /* br_vlan_options.c */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 39f0787fde01..6bfff28ede23 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -206,11 +206,62 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 		nbp_switchdev_hwdom_put(p);
 }
 
+static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
+				   struct notifier_block *atomic_nb,
+				   struct notifier_block *blocking_nb,
+				   struct netlink_ext_ack *extack)
+{
+	struct net_device *br_dev = p->br->dev;
+	struct net_device *dev = p->dev;
+	int err;
+
+	err = br_vlan_replay(br_dev, dev, ctx, true, blocking_nb, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_mdb_replay(br_dev, dev, ctx, true, blocking_nb, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	/* Forwarding and termination FDB entries on the port */
+	err = br_fdb_replay(br_dev, dev, ctx, true, atomic_nb);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	/* Termination FDB entries on the bridge itself */
+	err = br_fdb_replay(br_dev, br_dev, ctx, true, atomic_nb);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
+				      const void *ctx,
+				      struct notifier_block *atomic_nb,
+				      struct notifier_block *blocking_nb)
+{
+	struct net_device *br_dev = p->br->dev;
+	struct net_device *dev = p->dev;
+
+	br_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+
+	br_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+
+	/* Forwarding and termination FDB entries on the port */
+	br_fdb_replay(br_dev, dev, ctx, false, atomic_nb);
+
+	/* Termination FDB entries on the bridge itself */
+	br_fdb_replay(br_dev, br_dev, ctx, false, atomic_nb);
+}
+
 /* Let the bridge know that this port is offloaded, so that it can assign a
  * switchdev hardware domain to it.
  */
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev,
+				  struct net_device *dev, const void *ctx,
+				  struct notifier_block *atomic_nb,
+				  struct notifier_block *blocking_nb,
 				  struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
@@ -227,11 +278,27 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 	if (err)
 		return err;
 
-	return nbp_switchdev_add(p, ppid, extack);
+	err = nbp_switchdev_add(p, ppid, extack);
+	if (err)
+		return err;
+
+	err = nbp_switchdev_sync_objs(p, ctx, atomic_nb, blocking_nb, extack);
+	if (err)
+		goto out_switchdev_del;
+
+	return 0;
+
+out_switchdev_del:
+	nbp_switchdev_del(p);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
 
-void switchdev_bridge_port_unoffload(struct net_device *brport_dev)
+void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				     const void *ctx,
+				     struct notifier_block *atomic_nb,
+				     struct notifier_block *blocking_nb)
 {
 	struct net_bridge_port *p;
 
@@ -241,6 +308,8 @@ void switchdev_bridge_port_unoffload(struct net_device *brport_dev)
 	if (!p)
 		return;
 
+	nbp_switchdev_unsync_objs(p, ctx, atomic_nb, blocking_nb);
+
 	nbp_switchdev_del(p);
 }
 EXPORT_SYMBOL_GPL(switchdev_bridge_port_unoffload);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 45ef07f682f1..382ab992badf 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1905,7 +1905,6 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(br_vlan_replay);
 
 /* check if v_curr can enter a range ending in range_end */
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4d3ab9e6183a..78c70f5bdab5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -204,16 +204,14 @@ void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack);
-int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
-			      struct netlink_ext_ack *extack);
+void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo);
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack);
-int dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev,
-			   struct netlink_ext_ack *extack);
+void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 7accda066149..d81c283b7358 100644
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
@@ -194,59 +194,6 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_mdb_replay(br, brport_dev, dp, true,
-			    &dsa_slave_switchdev_blocking_notifier, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, dp, true,
-			    &dsa_slave_switchdev_notifier);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, dp, true, &dsa_slave_switchdev_notifier);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	err = br_vlan_replay(br, brport_dev, dp, true,
-			     &dsa_slave_switchdev_blocking_notifier, extack);
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
-	err = br_mdb_replay(br, brport_dev, dp, false,
-			    &dsa_slave_switchdev_blocking_notifier, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, dp, false,
-			    &dsa_slave_switchdev_notifier);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, dp, false, &dsa_slave_switchdev_notifier);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	err = br_vlan_replay(br, brport_dev, dp, false,
-			     &dsa_slave_switchdev_blocking_notifier, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
 	return 0;
 }
 
@@ -307,18 +254,23 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	err = switchdev_bridge_port_offload(brport_dev, dev, extack);
+	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
+					    &dsa_slave_switchdev_notifier,
+					    &dsa_slave_switchdev_blocking_notifier,
+					    extack);
 	if (err)
 		goto out_rollback_unbridge;
 
-	err = dsa_port_switchdev_sync(dp, extack);
+	err = dsa_port_switchdev_sync_attrs(dp, extack);
 	if (err)
 		goto out_rollback_unoffload;
 
 	return 0;
 
 out_rollback_unoffload:
-	switchdev_bridge_port_unoffload(brport_dev);
+	switchdev_bridge_port_unoffload(brport_dev, dp,
+					&dsa_slave_switchdev_notifier,
+					&dsa_slave_switchdev_blocking_notifier);
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 out_rollback:
@@ -326,14 +278,13 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	return err;
 }
 
-int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
-			      struct netlink_ext_ack *extack)
+void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 
-	switchdev_bridge_port_unoffload(brport_dev);
-
-	return dsa_port_switchdev_unsync_objs(dp, br, extack);
+	switchdev_bridge_port_unoffload(brport_dev, dp,
+					&dsa_slave_switchdev_notifier,
+					&dsa_slave_switchdev_blocking_notifier);
 }
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
@@ -423,13 +374,10 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	return err;
 }
 
-int dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag,
-			   struct netlink_ext_ack *extack)
+void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
 {
 	if (dp->bridge_dev)
-		return dsa_port_pre_bridge_leave(dp, dp->bridge_dev, extack);
-
-	return 0;
+		dsa_port_pre_bridge_leave(dp, dp->bridge_dev);
 }
 
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 22ce11cd770e..8105f642572b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2052,20 +2052,16 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
 				    struct netdev_notifier_changeupper_info *info)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct netlink_ext_ack *extack;
-	int err = 0;
-
-	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
-		err = dsa_port_pre_bridge_leave(dp, info->upper_dev, extack);
+		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
-		err = dsa_port_pre_lag_leave(dp, info->upper_dev, extack);
+		dsa_port_pre_lag_leave(dp, info->upper_dev);
 	/* dsa_port_pre_hsr_leave is not yet necessary since hsr cannot be
 	 * meaningfully enslaved to a bridge yet
 	 */
 
-	return notifier_from_errno(err);
+	return NOTIFY_DONE;
 }
 
 static int
-- 
2.25.1

