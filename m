Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3772E0B09
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgLVNpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:45:44 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:47547
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727062AbgLVNpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:45:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heh5VNhK+6AKBKcmUQdsf6sTPKjkoYvYnPyuDIOG4JNLakpHWCiF3oTKhLzg7YxCIJMXSXeaiulLRazs/p5x4Ew/bvy77klRSPA7yBTT1HygIhefJxx4z5Wu4bdSbMlQ9gdH90JhJz8xH2Qa9bEcNV/qh0p8AX2zpzjDOGm1uKxpMSfdMNCKCJH7DFkOCdYLKE0kTS68utVIlKHzuWPsJqyQ+uxnGdtMcnjFQE9QZyz6ENo2dERKp5T6jfDlyr94HZleoWH/6zDcLnMOsRMi45XD0adBIkf3HcIqjyxrBewraJKRVMQWklE6NL2+saYrC/1Prpv3QyCHPpcfjSBI4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SL7L+GB8Mq43TE+c3u3aUz7g8Gz6vSBeTnKnTm0vdc=;
 b=oHvQjNeUtbdDMCki+3JzGFFdtdN14YN5LSE4JSMgRnwgXdU03ih+BPG8ROUEW5lQB3GvA2YmbFzpp/rOHgpsSMC8hxP/Nt/CBf3QFEz9l1BCE9DSAtRmlTJRCXEfSINTzw6LKAaynBm+RzZm2rrKy3+NHmJcSwjTu7M6io5QMTHEv5yjTThetj9Jm3GjUhSkfCluTSsiBShnVyvbKrM+vcKaUpS7iIIC4O9zGnDzcs9c66Dlf4r3tAwiM3qmbapqPBKI0ZeAXwUQEpjWCZiIN371CBllG4wWn55UivWLHBUFZ1yeMlMvTRuFv5Cmt83wKuEG1x3ZrJ9yk8uMvnTcyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SL7L+GB8Mq43TE+c3u3aUz7g8Gz6vSBeTnKnTm0vdc=;
 b=ShhAQm7LUHuEZEwBVSOXMtcAJe4LO/8c5Fh/qVAy8pVD7xvGXPqHR3GShbIg7fC8h3GKWbw+fdHeuoiWLdgn/CWYCvcXLnAEppRO2xoC8mLUXIp7778bvacxQuE9D4vUx1ctu0qKRDwiQ90dEogHBQoOzwWQRsVYKhMG30fjdrQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:44:53 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:44:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 00/15] tag_8021q for Ocelot switches
Date:   Tue, 22 Dec 2020 15:44:24 +0200
Message-Id: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4522e3d-35b5-43f9-8de4-08d8a67fc2da
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408307148D8C167F16634EFE0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mdiij694Z+RaWMfi/60pvbJIXLgetZjIRgQyGivABf94KlP+F+qrxKFRXkWq4UM4JgTvIMt1pPdZ5GuPh8Lh6Bw/hdEaUwvDvcoD5JuVkq899bBltSukH2JniArcWxMQ0ehWgYq4WNXpG1yCk872ffruB8A75kCVOoIdnhd/jX3RUNUDn703iYorRHxwjff9+a1Xv4PA3d0k06xhYJA+4DxMEQokooFPiTjkNKlnqnv+CEEyKQrgjiHq22mW2/0zU6Gk79PvY20m4iNjwWUsBVtVpDQL5m3ckcjpanY2MgleiMRyOitaH86ypcDyFO7s75r1DUe+jrvKuI5jaNQp7DtBp+3IJBEVCWJDVY36STT3zj9SC93hjySTXS9p2RISCqYLp6fYrgP9TpWUwIV3vDA6MMJGjfyfKCvoK/Oe8bfbcp5f/NgZd8Etg+dzI05C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ahfoYEmYHfXz2p6rf1um9vY61jwvq0NwETgyNO//XEPv534TZub1TSk+ilqk?=
 =?us-ascii?Q?6KWBB7aK4XEveDVrWA0PaMrk94NsutYTn9OK+Au8KTPtUYOZJ8iQMlLpPO7m?=
 =?us-ascii?Q?fDSaA63iQqtSg2PF61WoeoROIRFlkTNkmse/psIHiigyFauPTHK2PWA1uy2z?=
 =?us-ascii?Q?M1s7GopLL/sP7SHIuczgZxm8EWqqyTUkishn+1E07xJ76oXshJ4i9CYwpxx0?=
 =?us-ascii?Q?YUIHpXGqrkWZcu3R4SzSZCzw7YPzvf6HPyaLIx4xbw61QgsrMcpe9Q8NP0yg?=
 =?us-ascii?Q?sVep/TRSp31mX4rE19O296pJcf+Z0QCH6VFXNp/Ed083QErOwaxJt3sQtGJN?=
 =?us-ascii?Q?c0WrcMkmwJ3j+RRg12BymC8IqWYKonkE9jaAINEbfzDkc6G6SbxnEH9VS10H?=
 =?us-ascii?Q?OZGhcdADnqCvkADYUOVO438n+HAMvLbo4idABtPm3Zdc/tqyfG3rFzBbJEjI?=
 =?us-ascii?Q?h0WbJFD9upo107zehQiTXqJjLDd+PaoSvYb46RjAdz6GGFKOKewmUP8m3hGh?=
 =?us-ascii?Q?l+TiXa7MeUi0wEOE3zfHiF/5g9qc9S0j2rkDZChHYxQ4UvHPOJYcDw77TIVm?=
 =?us-ascii?Q?6dngQHO+Fa8LE9kcXWwNYiPiAPlzUWtb42gh+tQzxgWQBnFZNjaa1SF6HaDC?=
 =?us-ascii?Q?uqhUBIb0S1+WLFqIXcmh0snHSFfKI7Kjh8vpx2UTbwq2zKc3+4qxoJaoTskP?=
 =?us-ascii?Q?JHagk6zeJSmftyYKsy/GsZBk1D96u+4r60Pnh75/ZsYP1ANnYn8tPvu3/V1D?=
 =?us-ascii?Q?Y99+SJGrHN1nscOpYRARmvW+/rksWYGidRKZoyTCADHvPMacj/+CJ8hDw5bg?=
 =?us-ascii?Q?EskwtOZq6+r2TwxLJBvrPNCruEZeuAT5zX2Pr5UoWPuihu3asuNLgf/l5lxF?=
 =?us-ascii?Q?I5PFQPs16J0J719N30gH6Soh+vAsphAm/6f5kMS3KyuYfX2ZNNZg1Wjfs4T6?=
 =?us-ascii?Q?h1CQFGtzqDKEhXFsG4RoJXSF5SFkJLt+cIc8fQ6yqbSvQPMlJ0xVN4vgxWvN?=
 =?us-ascii?Q?XDkY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:53.1756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: b4522e3d-35b5-43f9-8de4-08d8a67fc2da
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3miruMoLnL9rt9dUBKm3V7YitclbljozzsYauX3s4t2ofqW0Nffh1sgytOHfw++oJC0pROp78RO5XgbpSB5Msw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix switch inside LS1028A has an issue. It has a 2.5G CPU port,
and the external ports, in the majority of use cases, run at 1G. This
means that, when the CPU injects traffic into the switch, it is very
easy to run into congestion. This is not to say that it is impossible to
enter congestion even with all ports running at the same speed, just
that the default configuration is already very prone to that by design.

Normally, the way to deal with that is using Ethernet flow control
(PAUSE frames).

However, this functionality is not working today with the ENETC - Felix
switch pair. The hardware issue is undergoing documentation right now as
an erratum within NXP, but several customers have been requesting a
reasonable workaround for it.

In truth, the LS1028A has 2 internal port pairs. The lack of flow control
is an issue only when NPI mode (Node Processor Interface, aka the mode
where the "CPU port module", which carries DSA-style tagged packets, is
connected to a regular Ethernet port) is used, and NPI mode is supported
by Felix on a single port.

In past BSPs, we have had setups where both internal port pairs were
enabled. We were advertising the following setup:

"data port"     "control port"
  (2.5G)            (1G)

   eno2             eno3
    ^                ^
    |                |
    | regular        | DSA-tagged
    | frames         | frames
    |                |
    v                v
   swp4             swp5

This works but is highly unpractical, due to NXP shifting the task of
designing a functional system (choosing which port to use, depending on
type of traffic required) up to the end user. The swpN interfaces would
have to be bridged with swp4, in order for the eno2 "data port" to have
access to the outside network. And the swpN interfaces would still be
capable of IP networking. So running a DHCP client would give us two IP
interfaces from the same subnet, one assigned to eno2, and the other to
swpN (0, 1, 2, 3).

Also, the dual port design doesn't scale. When attaching another DSA
switch to a Felix port, the end result is that the "data port" cannot
carry any meaningful data to the external world, since it lacks the DSA
tags required to traverse the sja1105 switches below. All that traffic
needs to go through the "control port".

So in newer BSPs there was a desire to simplify that setup, and only
have one internal port pair:

   eno2            eno3
    ^
    |
    | DSA-tagged    x disabled
    | frames
    |
    v
   swp4            swp5

However, this setup only exacerbates the issue of not having flow
control on the NPI port, since that is the only port now. Also, there
are use cases that still require the "data port", such as IEEE 802.1CB
(TSN stream identification doesn't work over an NPI port), source
MAC address learning over NPI, etc.

Again, there is a desire to keep the simplicity of the single internal
port setup, while regaining the benefits of having a dedicated data port
as well. And this series attempts to deliver just that.

So the NPI functionality is disabled conditionally. Its purpose was:
- To ensure individually addressable ports on TX. This can be replaced
  by using some designated VLAN tags which are pushed by the DSA tagger
  code, then removed by the switch (so they are invisible to the outside
  world and to the user).
- To ensure source port identification on RX. Again, this can be
  replaced by using some designated VLAN tags to encapsulate all RX
  traffic (each VLAN uniquely identifies a source port). The DSA tagger
  determines which port it was based on the VLAN number, then removes
  that header.
- To deliver PTP timestamps. This cannot be obtained through VLAN
  headers, so we need to take a step back and see how else we can do
  that. The Microchip Ocelot-1 (VSC7514 MIPS) driver performs manual
  injection/extraction from the CPU port module using register-based
  MMIO, and not over Ethernet. We will need to do the same from DSA,
  which makes this tagger a sort of hybrid between DSA and pure
  switchdev.

I determined that a Kconfig option would be a sufficiently good
configuration interface for selecting between the existing NPI-based
tagged and the tag_8021q software-defined tagger. However, this is one
of the things that is up for debate today.

Changes in v2:
Posted the entire rework necessary for PTP support using tag_8021q.c.
Added a larger audience to the series.

Vladimir Oltean (15):
  net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or
    TX VLAN
  net: mscc: ocelot: export VCAP structures to include/soc/mscc
  net: mscc: ocelot: store a namespaced VCAP filter ID
  net: dsa: felix: add new VLAN-based tagger
  net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
  net: mscc: ocelot: only drain extraction queue on error
  net: mscc: ocelot: just flush the CPU extraction group on error
  net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
  net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
  net: mscc: ocelot: refactor ocelot_port_inject_frame out of
    ocelot_port_xmit
  net: mscc: ocelot: export struct ocelot_frame_info
  net: mscc: ocelot: refactor ocelot_xtr_irq_handler into
    ocelot_xtr_poll
  net: dsa: felix: setup MMIO filtering rules for PTP when using
    tag_8021q
  net: dsa: felix: use promisc on master for PTP with tag_8021q
  net: dsa: tag_ocelot_8021q: add support for PTP timestamping

 MAINTAINERS                                |   1 +
 drivers/net/dsa/ocelot/Kconfig             |   4 +-
 drivers/net/dsa/ocelot/Makefile            |   5 +
 drivers/net/dsa/ocelot/felix.c             | 120 +++++++-
 drivers/net/dsa/ocelot/felix.h             |  14 +
 drivers/net/dsa/ocelot/felix_tag_8021q.c   | 308 +++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_tag_8021q.h   |  27 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
 drivers/net/ethernet/mscc/ocelot.c         | 262 +++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.h         |  11 +-
 drivers/net/ethernet/mscc/ocelot_flower.c  |   7 +-
 drivers/net/ethernet/mscc/ocelot_net.c     |  82 +-----
 drivers/net/ethernet/mscc/ocelot_vcap.c    |  16 +-
 drivers/net/ethernet/mscc/ocelot_vcap.h    | 296 +-------------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 170 ++----------
 include/linux/dsa/8021q.h                  |  14 +
 include/soc/mscc/ocelot.h                  |  19 ++
 include/soc/mscc/ocelot_vcap.h             | 294 ++++++++++++++++++++
 net/dsa/Kconfig                            |  34 +++
 net/dsa/Makefile                           |   3 +-
 net/dsa/tag_8021q.c                        |  15 +-
 net/dsa/tag_ocelot_8021q.c                 |  86 ++++++
 22 files changed, 1228 insertions(+), 561 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.c
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.h
 create mode 100644 net/dsa/tag_ocelot_8021q.c

-- 
2.25.1

