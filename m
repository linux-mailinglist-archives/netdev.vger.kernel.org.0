Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDFD3D141B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbhGUPpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:45:14 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:1893
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231239AbhGUPon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:44:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lL9MWp3Xb+Yd+obMqbNG5y46pq3Elt9yB3QfRYRk4x60ytA+LrNBGExvyH+ZS88oenO4e2qmTMgJDSgL5op4V/+fSl6G2a1OlJHzsJz2HPXRDsvd6y2QnLwIaq4CyMFZ76E+fCRvXXXSP0vviJX9iF9mLbi4qFrXzX+zlWRbx5jvmAjecRrDejFV7rTxrQbSN9j7Z9Jjk0mFUG/OHwZJEbG6dVgEdnShIPPLMRea8hyL8NRJ3eIvSqL5BsiDCTCH3HjIVQ3I2L/ZD5rcnnnT9p4LIgk2N+wIvIfnjT6fxxWEwexBgKW/xeZ0BTrqf+IrrkEpZkFt04yRTreRx/Uw1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE4sGgsllyzwAuG1O9mFoiAbwcYNL7jfENvlFvgAICo=;
 b=ah41+eW107bmnfqMlc0+mGJkQpMqAElqIinaJp/WBSQa5CwnAzflnXMYSprZaLV03n6Lx21b+i7vNhecA5PwRS0St47YxE36AHjxI6Q+KsiPNb3WiinRLfJpZRzoxMV75c/NRyl9kdVHiAvN5jfGiRcPNkIX35nUh9oNn3DQzmWp8M1xtR3SNq0VFdW+pRXI1PgvP1UKDfrzWfnJgHYq+mcpTE6uiOUeuJpDUG7Xf57Id+GjtHdCHzTvfAYNPj6i00C39e+XR0R4s0PfqJSJwdm32ELQ3Q58eQ2SuN2ynIWqI21zmfxYbuCJdsO+2j5kSJpCGJiLqiR728oHjdQz5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE4sGgsllyzwAuG1O9mFoiAbwcYNL7jfENvlFvgAICo=;
 b=gCsr4nNf4vw93EDtP/0tpLP3LSSb5PtDhN+ZkdUO+N/9kKPReL3dO3F3gFzXqaVryMbSsCRg+GDeMSyBy3FPQSBsqgBYcjkgsRxUaZrHIeAUBski+ILfddKH9tnB624TFzbDzPyG1NbMdzpffF59PJYdLUj3gnbQlSW3vdgj6Fg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:25:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 16:25:17 +0000
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
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v6 net-next 0/7] Let switchdev drivers offload and unoffload bridge ports at their own convenience
Date:   Wed, 21 Jul 2021 19:23:56 +0300
Message-Id: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 16:25:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90303a53-4ea4-40fd-941d-08d94c64206b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB734326EAB6057741C4A68E11E0E39@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzNwkuXurif6b6yCXezsaB8Bk9gVXWXx1DOZRRolGPqa2NZzjP4GPKnAJsfjtADz9FN1HbP5qZCw9LTSevnWrmvQNxLCD6BHQguozG3ANtb1XI2E6svlO/VStQDWUafnfROijkVjY0bzxyYiJOnY62PkhIrB3qwrp6lKfb2FYv9GUS3RDDG/uQY150GNWz1bl029gRmza9/8MTVbN0Ny3fzBVw0T9THeUR+q/iKiBVqAXze+YB/3ILQVExBJHSEvig46iCOwVF56HmTBdqqII/iNlJ73MrqBHozb9u1lD2woIsvEorTqdx+cmwFlmPixiRQXayOEQbx+KQcO6zc5Ybn4pWr9cEWs3NOCSklj7XDsNxsxZFro4t8KlMMT3kpafK8IF366vEMsidSLiLpSrLc7Gqbi8kg6DHy0FmiCDyX/K3XCK+ZdZKX+S5y1NN3Qh6C8pPVAzakOJhSqWU05u9mMnsjcYnkEUZLID4ZXi90FBBzsu7pTW8GgcI3iu25C9jKYXzidBpKMCxWpFZ/+zK1yI2oYXrySRD+6TlYWb3PPxV9eTfo2dTtMM81lWAPvT6ikPHIsY2QVCwF+rAf3Ka0pNRce6IPIilmJP+swbaLC1NntnEzBVXdqgAs/SvIJfUfN/Spoxi0ldU/Lxhl6R0DC4Dvf06o0B4onqO6TI8h6RnCosnyC7PwTNRdVEjqW9Zys8sqBncUxui7PBimr0QsvcquHiEKHcA9eQk95o8v+tkK1EJcrWFNgfs+5h88w/5//hMNua8oDrxYds9fS8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(186003)(110136005)(956004)(4326008)(44832011)(316002)(2616005)(54906003)(8676002)(8936002)(478600001)(83380400001)(36756003)(7416002)(2906002)(6486002)(966005)(6512007)(52116002)(1076003)(5660300002)(66946007)(66476007)(6666004)(38100700002)(6506007)(66556008)(38350700002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?urbNYEBOBDjCGVMQqG+0tWXHV+Vz53kiJnQlEBJorm7N0gGBKWYvNnt7lpdf?=
 =?us-ascii?Q?7n7ZRW9MY/BguGxDhkeAy7gUiDfkhG4pQX0u/ukCclnat/V8rhTY5ucHmFMk?=
 =?us-ascii?Q?Ut1S5EU6HE3j2NdOFlfTn1aSaik7pcR++OkH8lmxdYCzTLq+SMrROZ0jMOla?=
 =?us-ascii?Q?X6qUEgnuLdvFoMXjyeXHCJvrJVhR8nucaKfqL49dVtLtU41vfk8WO3huFveJ?=
 =?us-ascii?Q?igL+ZI7RIg0YRj/mxIbHNf1Oe6G6xeUIorddW2NFXUJDJ21ycN+Uvc/pA8lP?=
 =?us-ascii?Q?cekf8m2b8CJDQEd7R3FN0w7j+qwTJL89pS8BwR92IRbdWnTS/yR304VDd3Pr?=
 =?us-ascii?Q?EZAwgmZ+iWrtyxStdShdysbr3EB99ijylbC3fFLLibmPpGwKBYnN/XOR1CLS?=
 =?us-ascii?Q?SnvRNLWdqIAQvGfxcHB8sfoKAAoPyjt5Eo8ABDu2q2J9lHKndsTCbl0i9ZKD?=
 =?us-ascii?Q?rEcxGpWDZL3x+pUqwmFq9O6RDbmzl/bqHcSKyCceBc9WdQa/taa0KXHbcSDA?=
 =?us-ascii?Q?bou6CkU5Us9wbnDeRE0MENodVBRgTj4/Bh6QK0pqysjAKT3ghZvephoEPhiE?=
 =?us-ascii?Q?Xd9l/yAzGjcDLVQw7QHlg9dk2Ckg5BEZ9ewGBT5JuvygcJYiL8o4+osrH+2O?=
 =?us-ascii?Q?yfpnhXq6rLP/CauxbYtELiPXehl64wW8JJShhnUEDROrgbPbmhSqpf2xh91c?=
 =?us-ascii?Q?0TNsUkNJuXjEzwROWdYuYAiARavvYNSbIh4i0VPs11O5CQD3CtdUEml8J2vJ?=
 =?us-ascii?Q?mCMQlumPEy5y3gsyEEJ73I7a7DUvIBo4LI2GgWALVxJRSkvt3ZmwXqfeq4HL?=
 =?us-ascii?Q?ZzfF9s3O7Gacn+NkATe4zUETOD+HwZhQZ02PpCptOOFv2E0PEtjFZ3LGLHnd?=
 =?us-ascii?Q?ULRoZKt2r+yAHOKscmV0Y/obwpQVj6IR9XJRVdnll8xIV5bSsqdg3NueD9Mx?=
 =?us-ascii?Q?jz8kNXwbBRQqSw5TK+vAnVoH3u4f0bVysCs8U93oMnpfyoFpdRm43cQ0hTjX?=
 =?us-ascii?Q?iif/g53OzXoRatyjFRnjPAg9adYHonR5rPxa21G+CSjhwCx8/moUccJTMTBB?=
 =?us-ascii?Q?cXciujJv0Y6nUNtLQyJP+iyk6BNB4Rp3pc/dx41PiDPFa5O+u08m4B6gc9or?=
 =?us-ascii?Q?+UdWX8kk88AWg2PuZteTvWsbjGxHwBwWBwXFQ50hQ43gVOQLE6NwI434fr3f?=
 =?us-ascii?Q?sHCM7vRvwjhlxNrcsft0UYqPviTjCy2VJDpEIzbZM+1xjIr8JVkMf8T4Ucdg?=
 =?us-ascii?Q?Bz9RNNue42WZkUck+4NYY2ombQFdEJnCKEXqoZkECgK8uH2xAsSXX+MlLi7R?=
 =?us-ascii?Q?6uGy3+VSfugWXCuZkfZa0uMi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90303a53-4ea4-40fd-941d-08d94c64206b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:25:17.5406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkBjwbW+uBgdZFLrb9Xgfo5/Ckqh9opQ/VKvl9Tz9DgzBDuuVdWnfGr5UAUJEXTiiY4v95exf6z7z0n/AoxJig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces an explicit API through which switchdev drivers
mark a bridge port as offloaded or not:
- switchdev_bridge_port_offload()
- switchdev_bridge_port_unoffload()

Currently, the bridge assumes that a port is offloaded if
dev_get_port_parent_id(dev, &ppid, recurse=true) returns something, but
that is just an assumption that breaks some use cases (like a
non-offloaded LAG interface on top of a switchdev port, bridged with
other switchdev ports).

Along with some consolidation of the bridge logic to assign a "switchdev
offloading mark" to a port (now better called a "hardware domain"), this
series allows the bridge driver side to no longer impose restrictions on
that configuration.

Right now, all switchdev drivers must be modified to use the explicit
API, but more and more logic can then be placed centrally in the bridge
and therefore ease the job of a switchdev driver writer in the future.

For example, the first thing we can hook into the explicit switchdev
offloading API calls are the switchdev object and FDB replay helpers.
So far, these have only been used by DSA in "pull" mode (where the
driver must ask for them). Adding the replay helpers to other drivers
involves a lot of repetition. But by moving the helpers inside the
bridge port offload/unoffload hook points, we can move the entire replay
process to "push" mode (where the bridge provides them automatically).

The explicit switchdev offloading API will see further extensions in the
future.

The patches were split from a larger series for easier review:
https://patchwork.kernel.org/project/netdevbpf/cover/20210718214434.3938850-1-vladimir.oltean@nxp.com/

Changes in v6:
- Make the switchdev replay helpers opt-in
- Opt out of the replay helpers for mlxsw, rocker, prestera, sparx5,
  cpsw, am65-cpsw

Tobias Waldekranz (2):
  net: bridge: disambiguate offload_fwd_mark
  net: bridge: switchdev: recycle unused hwdoms

Vladimir Oltean (5):
  net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
  net: dpaa2-switch: refactor prechangeupper sanity checks
  net: bridge: switchdev: let drivers inform which bridge ports are
    offloaded
  net: bridge: guard the switchdev replay helpers against a NULL
    notifier block
  net: bridge: move the switchdev object replay helpers to "push" mode

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  67 ++++--
 .../ethernet/marvell/prestera/prestera_main.c |   3 +-
 .../marvell/prestera/prestera_switchdev.c     |  12 +-
 .../marvell/prestera/prestera_switchdev.h     |   3 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  24 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  24 +-
 drivers/net/ethernet/mscc/ocelot_net.c        | 104 ++++++--
 drivers/net/ethernet/rocker/rocker.h          |   3 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   9 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  19 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  18 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  16 +-
 include/linux/if_bridge.h                     |  57 ++---
 net/bridge/br_fdb.c                           |   4 +-
 net/bridge/br_if.c                            |  11 +-
 net/bridge/br_mdb.c                           |   4 +-
 net/bridge/br_private.h                       |  60 ++++-
 net/bridge/br_switchdev.c                     | 227 +++++++++++++++---
 net/bridge/br_vlan.c                          |   4 +-
 net/dsa/dsa_priv.h                            |   6 +-
 net/dsa/port.c                                |  90 ++-----
 net/dsa/slave.c                               |  10 +-
 22 files changed, 560 insertions(+), 215 deletions(-)

-- 
2.25.1

