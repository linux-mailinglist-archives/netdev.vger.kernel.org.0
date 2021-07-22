Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE5E3D271D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhGVPPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:15:31 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:15456
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230343AbhGVPPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:15:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZlDuWQMTdQBLqYJlU+Ct8obkWk8IaEovR+5B/sEZNFdP3JkljzL1pVvolwjZVjjdpBdRF+retPDu/GAOjvyjgUOHa46qQgPVN858glT1ctNCVvjN1oo4PT8kUcVSvcLPW26ynrn5kFKNNuPy05vSLVaZ5HYsjRqj/N9etPwH5YXBRt6057s+QxdkliM9nVBgb6iiKWlepaMzPNV02Nq8XnxzEs8koA80NkNd+1yKU+Mgc+DJr7EPWZUs905gHEoUqhTRjPE61FG3EyGVIvajiWQJKSnvOUI6S/bvlRgCp+yryCmZfTmnriRTGIQi8p7WspH4Y4TvP1iG319vI7BJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG5DNaes5yll3Ujhl93ZAxWZcRBX/Nqq9KUv/zURod0=;
 b=DM4dS+XAaoAUI6DLJ2QrZWd26TS7fxfL58CBv1tgg9YdEllf+J/8a4XDWYgNQiwi9S719IubtlKqN2C7KnulbNZNNrQgml8FE6Cx0p5HxYJ61rOadmmpxtEffJnCZSoKUSGjxlOyMrD0hAq4GYxnoxtV8B3K3QK56mguZStbx6m3TwuzYcFbL8upIm37GXDOAv3ddKk7+srEKRWgowgzHEpRp8VFQUHgOIBX8ONI3e9PHQ0FBjRlSJjFjXJ1WNB2ZEUXE40v4ob6Cn9tZCA0SEGH+j91R8N4i2ERHilvSfXeB5JK7gyJR8Zy3RL0W9p63Y34lhr0F+MOVkL92f0v1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG5DNaes5yll3Ujhl93ZAxWZcRBX/Nqq9KUv/zURod0=;
 b=UOfYWiCl6ICByqsb3MG4MIsCDyP13Htw+gFS/jwrFa7amxLE/3qu0O11IfQAI3CLdduDBgRFP0CwW5JnSRdcZAIzl5rDIVOlM2hcJb1IHcMjgs0/9GPgc5oxOFmW7kXCHkEL1PG7feUY1mFxC3TnBqpgH4BPd25qKbuegUYEHQE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2303.eurprd04.prod.outlook.com (2603:10a6:800:28::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.31; Thu, 22 Jul
 2021 15:56:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 15:56:02 +0000
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
Subject: [PATCH v5 net-next 0/5] Allow TX forwarding for the software bridge data path to be offloaded to capable devices
Date:   Thu, 22 Jul 2021 18:55:37 +0300
Message-Id: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0099.eurprd07.prod.outlook.com
 (2603:10a6:207:6::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0099.eurprd07.prod.outlook.com (2603:10a6:207:6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 22 Jul 2021 15:55:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47d5051c-bef5-4628-0962-08d94d293450
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2303907CAB72B84461EEA53DE0E49@VI1PR0401MB2303.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qogLls2NUMkvD8wk7A48MJArxaTSqVKnQgVjlT/8v9JJg4zus2BxxorCqm9OAoiiiyKDE5HK69f0/L6E/HOoVYUBvFAmrzJC84AUW7LkVFkPESNSy+7zXTL4jTX+0+Zgi4CcXpDwYr3/CCYU03SY5xcfAC4PIb9Ey8RKMJyO7VxY8+EoYlwRNdYT312+X2KHi3HSqFPgIpeujYBh+nzBnvP0ZkllFbL4J8qsqSedjTn0BSs9IWFtT4C0JsyA7FzakNDVOjqlwd0Txe2/MKAkXJU4RalYuo0OpQ8sqhCdvXTgSAyrPriJmj5VA5dIkmyq9NV3qgp0K2AOZOtLeZHYYK8XVqOpoXWE3xwNKbu+Msw4N6ZEqz9a3QYy2/V0eTFfGvzhAwULcVVZvAt/TLyKgV+XiXBXGXVy16pDO7CoAjJOz+XChfewxH6C/VKQ3sQAwupYzVMnMt3Pgri0on/r0MmwYLbH/+TarTfO7HjNHxvYCPLRk4CgqrrRhsQNTLfkG9455Hpgn8+FezmfboY84580YKsozuuTn1HYrkG9Vex50payOyRsCrXq7APEQTALL/mfhF82ag/YHZ/iUtp7YAVe63jPvKhvOQQIfSBh7dGZGnMpJqY7Vj68HlA+ecjT9iMljkDDoaEtwRXmsNAGEFsnfbrimxPrtELHvTjYGiIQ7yuogX9tzzn7gHGqQZktQ8OtXVmfz4QentYuJGcUg/Cri2YXAA8I7OAHKyV/Q7Ajycwcxo6DqIR14HGoYO2HfWy5SgV2DMQi6WLWSvJJQmvig33sQhO+9pHCt12KIlib2FldCBOvvgXuECcexP0O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(8936002)(83380400001)(66946007)(1076003)(66476007)(110136005)(8676002)(36756003)(6666004)(52116002)(38350700002)(5660300002)(6506007)(186003)(4326008)(316002)(38100700002)(86362001)(2616005)(54906003)(6512007)(6486002)(2906002)(44832011)(66556008)(966005)(956004)(478600001)(7416002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sk0tvE+wItoZ4ND8o3SYbFyq1F9/n0MPCivfM7Dgn/APXIC9+5CO/jOr0bro?=
 =?us-ascii?Q?r9T9SgaoQ0mQrYLrT2sbgOLA1x4TTd04TWdSwmZoWn0XeHUVI7C8mgv6i3Iu?=
 =?us-ascii?Q?HsFXjWY5zKfpyVihDSXVtAzzrf9eSs6RvqHDz2uYb8YVuRqMQgkF6gyhUuWy?=
 =?us-ascii?Q?BdsM09gULWRl9TjH74mO+fQY6oXGj2aj0U4PSsn9+Y0q36h2gTlCCKOic6Rv?=
 =?us-ascii?Q?qLPBEDsIpmtfH5x6rWvNVuwXliw0rxmF+IC+GIhvgx/d1lOkcWuUfEFObP7b?=
 =?us-ascii?Q?mf7pZposU5RbBd08xKsam+jueYsrHU/JmaPyQvkMYtNnwWSVp12yyRaCwhfV?=
 =?us-ascii?Q?HTXfRruk4/MfiX23xOC5BrtK1s2YfZrF9kBBgy+1F3QCSzYbYaGgP7p11/EI?=
 =?us-ascii?Q?G0RThuaDjgbxjqUzJVR0NiiyqynXKmcK4EqvLm6ft8vowu6T39/MwSxLt8u6?=
 =?us-ascii?Q?j3aKCO4SmxumRG3vaCMgjR0PskpboFQBBAZgr62saM2UpO7aH57lsRhQLr7O?=
 =?us-ascii?Q?kfYf9kzYIr8/YotzKtjFub913KfeZvWEDWLTolBsufU//rcNXvdu6Ebhcqt5?=
 =?us-ascii?Q?rELgDBPrUZQu6zoa+e8ydX7kBp71oRPOetYqoPb8XSFZ9to3PUuZ3qDlCorY?=
 =?us-ascii?Q?R60bDa5aY6LsiWyRtriXohd31ohSict0U+QHiGl9jbDo61BSBoSUoDTgp8f1?=
 =?us-ascii?Q?cbQ8iWlJ82hDvOoDg3+yeELdHLbSK5ap+iYXxrENx+jRNzaf8JSbMYFUxI/d?=
 =?us-ascii?Q?k223wI1yCrmFC64C0F2g6imLUp9mDv4271JnximYAteobXDBWJ52C+CphDWW?=
 =?us-ascii?Q?jsFzFpRO9byaNqXbzp5UWdhVGBJt0ObkTCgz8DFwotY3dKfE/O3wf2OKnMsW?=
 =?us-ascii?Q?qcV7f9ilppBQhWwwi968/rn9sFY3A0dm1+gzkv+3eis2+EqOa93bNdTk9JFV?=
 =?us-ascii?Q?9RJ2U6PQ4IidG5iims6pnA4nanc21wHDzHr0IMuwI7cPKrWksnKWZMxG4QV6?=
 =?us-ascii?Q?X3WffT78Ac+Yqj7Tk+2q+xgU7Re3VhQe5jVLA0W4xE3JfMXH1pL5MtCfokKJ?=
 =?us-ascii?Q?w8nnMelWbkUzEiOHz5wJnNMu1UUfrcjrPELT4CxXmglYt0gch+j+ocISo+vt?=
 =?us-ascii?Q?RBuNG6vpYwbDGtsAixMC+Kjlra4aIhX9s8oJhYlf58eihm2GbtVLCVwY1qRy?=
 =?us-ascii?Q?z6jaWp40vBSjPoXKCZImfxEQM99zFEom60pL8Kz6y5upVE/QPdkLyxvyBgJG?=
 =?us-ascii?Q?Yy0Enm76eSnGtfNbf7xdP7vCmJtDSX5yPtk322aufJsLSb/wu3BABSlPaH8S?=
 =?us-ascii?Q?VKnpr0GPehVFdMREIRG7Jujo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d5051c-bef5-4628-0962-08d94d293450
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:56:01.9042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJ0+8zsL7JtwH/IILtbxJibZX9JAm2SG5tn7LunIVuL74JSX7H3YLwrHm4ekVIeF8Jn3eHI+1hKZpvdYEaEpkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RX, switchdev drivers have the ability to mark packets for the
software bridge as "already forwarded in hardware" via
skb->offload_fwd_mark. This instructs the nbp_switchdev_allowed_egress()
function to perform software forwarding of that packet only to the bridge
ports that are not in the same hardware domain as the source packet.

This series expands the concept for TX, in the sense that we can trust
the accelerator to:
(a) look up its FDB (which is more or less in sync with the software
    bridge FDB) for selecting the destination ports for a packet
(b) replicate the frame in hardware in case it's a multicast/broadcast,
    instead of the software bridge having to clone it and send the
    clones to each net device one at a time. This reduces the bandwidth
    needed between the CPU and the accelerator, as well as the CPU time
    spent.

This is done by augmenting nbp_switchdev_allowed_egress() to also
exclude the bridge ports which have the tx_fwd_offload capability if the
skb has already been transmitted to one port from their hardware domain.

Even though in reality, the software bridge still technically looks up
the FDB/MDB for every frame, but all skb clones are suppressed, this
offload specifically requires that the switchdev accelerator looks up
its FDB/MDB again. It is intended to be used to inject "data plane
packets" into the hardware as opposed to "control plane packets" which
target a precise destination port.

Towards that goal, the bridge always provides the TX packets with
skb->offload_fwd_mark = true with the VLAN tag always present, so that
the accelerator can forward according to that VLAN broadcast domain.

This work is not intended to cater to switches which can inject control
plane packets to a bit mask of destination ports. I see that as a more
difficult task to accomplish with potentially less benefits (it provides
only replication offload). The reason it is more difficult is that
struct skb_buff would probably need to be extended to contain a list of
struct net_devices that the packet must be replicated to. Sending data
plane packets avoids that issue by keeping the hardware and software FDB
more or less in sync and looking it up twice.

Additionally, the ability for the software bridge to request data plane
packets to be sent brings the opportunity for "dumb switches" to support
traffic termination to/from the bridge. Such switches (DSA or otherwise)
typically only use control packets for link-local traps, and sending or
receiving a control packet is an expensive operation.

For this class of switches, this patch series makes the difference
between supporting and not supporting local IP termination through a
VLAN-aware bridge, bridging with a foreign interface, bridging with
software upper interfaces like LAG, etc. So instead of telling them
"oh, what a dumb switch you are!", we can now tell them "oh, what a
stark contrast you have between the control and data plane!".

Patches 1-3 tested on Turris MOX (3 mv88e6xxx switches in a daisy chain
topology) and a second DSA driver to be added soon. Patches 4-5 tested
only on Turris MOX.

===========================================================

Changes in v5:
- make sure the static key is decremented on bridge port unoffload
- rename functions and variables so that the "tx_fwd_offload" string is
  easy to grep across the git tree
- simplify DSA core bookkeeping of the bridge_num

===========================================================

Changes in v4:

The biggest change compared to the previous series is not present in the
patches, but is rather a lack of them. Previously we were replaying
switchdev objects on the public notifier chain, but that was a mistake
in my reasoning and it was reverted for v4. Therefore, we are now
passing the notifier blocks as arguments to switchdev_bridge_port_offload()
for all drivers. This alone gets rid of 7 patches compared to v3.

Other changes are:
- Take more care for the case where mlxsw leaves a VLAN or LAG upper
  that is a bridge port, make sure that switchdev_bridge_port_unoffload()
  gets called for that case
- A couple of DSA bug fixes
- Add change logs for all patches
- Copy all switchdev driver maintainers on the changes relevant to them

===========================================================

Message for v3:
https://patchwork.kernel.org/project/netdevbpf/cover/20210712152142.800651-1-vladimir.oltean@nxp.com/

In this submission I have introduced a "native switchdev" driver API to
signal whether the TX forwarding offload is supported or not. This comes
after a third person has said that the macvlan offload framework used
for v2 and v1 was simply too convoluted.

This large patch set is submitted for discussion purposes (it is
provided in its entirety so it can be applied & tested on net-next).
It is only minimally tested, and yet I will not copy all switchdev
driver maintainers until we agree on the viability of this approach.

The major changes compared to v2:
- The introduction of switchdev_bridge_port_offload() and
  switchdev_bridge_port_unoffload() as two major API changes from the
  perspective of a switchdev driver. All drivers were converted to call
  these.
- Augment switchdev_bridge_port_{,un}offload to also handle the
  switchdev object replays on port join/leave.
- Augment switchdev_bridge_port_offload to also signal whether the TX
  forwarding offload is supported.

===========================================================

Message for v2:
https://patchwork.kernel.org/project/netdevbpf/cover/20210703115705.1034112-1-vladimir.oltean@nxp.com/

For this series I have taken Tobias' work from here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/
and made the following changes:
- I collected and integrated (hopefully all of) Nikolay's, Ido's and my
  feedback on the bridge driver changes. Otherwise, the structure of the
  bridge changes is pretty much the same as Tobias left it.
- I basically rewrote the DSA infrastructure for the data plane
  forwarding offload, based on the commonalities with another switch
  driver for which I implemented this feature (not submitted here)
- I adapted mv88e6xxx to use the new infrastructure, hopefully it still
  works but I didn't test that

===========================================================

Cc: Vadym Kochan <vkochan@marvell.com>
Cc: Taras Chornyi <tchornyi@marvell.com>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>

Tobias Waldekranz (2):
  net: bridge: switchdev: allow the TX data plane forwarding to be
    offloaded
  net: dsa: tag_dsa: offload the bridge forwarding process

Vladimir Oltean (3):
  net: dsa: track the number of switches in a tree
  net: dsa: add support for bridge TX forwarding offload
  net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in
    the PVT

 drivers/net/dsa/mv88e6xxx/chip.c              | 78 ++++++++++++++++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  2 +-
 .../marvell/prestera/prestera_switchdev.c     |  2 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  2 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 include/linux/if_bridge.h                     |  3 +
 include/net/dsa.h                             | 21 +++++
 net/bridge/br_forward.c                       |  9 ++
 net/bridge/br_private.h                       | 31 +++++++
 net/bridge/br_switchdev.c                     | 68 ++++++++++++++-
 net/bridge/br_vlan.c                          | 10 ++-
 net/dsa/dsa2.c                                |  4 +
 net/dsa/dsa_priv.h                            |  2 +
 net/dsa/port.c                                | 84 ++++++++++++++++++-
 net/dsa/tag_dsa.c                             | 52 ++++++++++--
 19 files changed, 352 insertions(+), 26 deletions(-)

-- 
2.25.1

