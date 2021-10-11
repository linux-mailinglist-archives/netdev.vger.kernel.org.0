Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEC64298D5
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhJKV2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:35 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16861
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235262AbhJKV2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3OwoLuAbY9DLu3Ymi3XxN5K7WUolg17OktsNv7jFrZ9yPEcwn5L1OTowHiHC6nX0/sIXfL5TkpCr7hUG8RPCydKWyKM/lprnerIM3+WgZ47JYR/GmEtKWFCVStd9pl+LMaYQZhFD5D32we5QBNs5vbpTKVcIz8Ru5ShQL1zD4UJ8TJrruV+FvoEPEzsT4Wg7xyW7nwYMbrM1uNEYpq/NAHKhs0EULCBNoxGyPByMDmvcVoQvWzh3DlepzAZIH4phvMaPL5ltgHmy99x7FOHmQ+WcfWxM6cDWrnt8rsWoMBYOaK26EFnI5Nj9b8Q1mJJgrKOrGYvdrQIqxFEvYqQ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GISfi0D56yck5O+TyhWwqCF3ptoro8W+Td06YCcZfq4=;
 b=bdGLxUfgURYVlC84NkdttWSmTzXg8ynxv39U6hRakRDbeDpQdqzb1VpX+DvmDyO3DQccHVYvZa07BxJLPc4r3FQc2cYRlw7sOwUdXI4X74EOjX/oMsml0I+CbQZ2/NmrVaqRGgkuWfgmpBLUXhXEoflWSJ50EmdZxdcMAP8zrngl3AN+AvQgceZQFPsewKgqETta1U+K/oqnvYNw58APjr6CCbnSOCtED0sWsYjdYBibWJdvoDQKXvY3ZzoQx9+bsAKYZ82W+pjOwZq/a8OryHYsfilRlsh5hew58E7aEuZmwdTlAz0fBkVRTfEUQRL5mj/zC9JuNVoswN7BjzP2MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GISfi0D56yck5O+TyhWwqCF3ptoro8W+Td06YCcZfq4=;
 b=PM5spo7JB+M9k5lexksWL+S8A/lQzfanUlLNkcjvHXvGu6On/StEJj4DbBd4YOTSnQ2xOiTGk6ANIaPd05NMUXKvYj0l1qUmYOKon8oSnivvLqVv61Qg88R6IKU4/mI19HfLKLZP3cDXK9hHr1WkjSldFcCIGMcMhz6/erIbeGk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 VE1PR04MB6703.eurprd04.prod.outlook.com (10.255.118.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 11 Oct 2021 21:26:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 00/10] Felix DSA driver fixes
Date:   Tue, 12 Oct 2021 00:26:06 +0300
Message-Id: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f18762-ac35-4193-3cf2-08d98cfdcadd
X-MS-TrafficTypeDiagnostic: VE1PR04MB6703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB67036D8ABCBBBDEF365C3AFFE0B59@VE1PR04MB6703.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IAXCPW5BiHOHDTtXqCgLPF39LVubOs0wPXC2mJw17XUEQHqS3BdIzybr37Gu8roJTZ679Lq3IAO6T9hoMWhINAyRoKgnwS4g2aYQeaiQ8bAoIwhsfIlQnBTfYvxp+BXCbYRrfk4RY4ItvPEUYXsi6vc0qlFL9OwPnrp5Pv480Wh0AfL8EXAoq/G6/mYvrfqDzFZB6TMS68zaqC44sHL2itiwIoMxp7AeqrLHnvDYmwWpluGBp1UOtQHqq+JLPTWW1OxDbN6bvbWMJSdBIJKHl02RlvshIBmb+4z2DK8S9vKmQmE66c0IRG1qeWsxWwzsJzmf1teXAe6bNmLxAIu8gB221UksXXSdyl8YxHCWVGlUvrgdh/FPZL3FwGXg0HNF07zKf4DLyjgJ+YkTxWM837R2/w9GWP0zZa78sNtrTNn9cf8f/WoKlscwC79w9L4xibIMByuZcCbJ78IPHjlJ5uPmdEBa2tGNs5TfpLe8mTp1pv+FdJ48x+Fdv7vLlwX6MoKj4XzpuHLTWz/qvV3f18wXIy84tMQVfiMZKOZhavLh1lm5oJsWMASxH+1VagDhBCBehPaBHcMU/RhSHaDdzjWmeLGlslwvUsLGT3urgTSLJisHcwc6u3sNSqwvD/BAnXi7Cp2cX9faGLaX9lacAIe+X6LmjhbMIjWL0WxL0wyJiVx5PGJyI7kVZePTricGS0yYiucSuZjjDa9WNehP8utRgPHgTPZxupIVKEMR+41h6Ri0k1OpDjzFxb79Y2bRg/fF9RfS/VTYHF6vql9gD9XLj6xulbjFmvGe1IJgqtQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(36756003)(1076003)(2906002)(6636002)(86362001)(66476007)(66556008)(8936002)(7416002)(6506007)(966005)(6486002)(66946007)(6512007)(508600001)(6666004)(2616005)(8676002)(5660300002)(38100700002)(38350700002)(4326008)(316002)(956004)(26005)(54906003)(110136005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?brfbW4RCEzBBcLtl8SiWTLKRJuzPAgYK7TQXM1uq63ReMzwmIgXq3ReB6qgn?=
 =?us-ascii?Q?2bM7sF2go5oV3smoyBiP9EwLUDCbzYCJfYF4kdTbzYCUImYYmfQiKg/b4PL/?=
 =?us-ascii?Q?apgfYIs7j3RfrpDMp303aFej8/BM9ys/cDp7Fkl12T3Gq0MwlxPgrFVtokT0?=
 =?us-ascii?Q?IoTyMpaCevdERdQaCuIW2uqc/oDSMqVx5Cmkj7cl/DjXceh6CctMwKmY3c2v?=
 =?us-ascii?Q?2pTynN64SbtteruO4ae5hmPkANBWmK6Z+QE7jGQ8ql7QwB+G5W2VOw/8TSWP?=
 =?us-ascii?Q?Djl2XCFztaEkZCWUmrcL5hMC8QpzH5qiCHBym6hDvpS2NbYr+yr3xu8rQ2fS?=
 =?us-ascii?Q?9LUZ8cVRLShCoy1czLFUvH2cRi/+IayBaVRv5Ok7jyfORYwCQ8JvZ8BTCuss?=
 =?us-ascii?Q?D80ESIwpp5LswjvBj1YSSfW5tDGCULYcH0ExTwfeOPIuDlxj+CaeKjGhXRu2?=
 =?us-ascii?Q?Popq4nLJeMJS7tHM8xf0RQGeB+UjiK4KaLTaAkgY9H7f6JeEIjVO4GN9Q1Qa?=
 =?us-ascii?Q?AgRx+Cd4QDDw+CXwQ4YEXG1F8P1xoYvcGH4y+O6PBR1awPAm9WI+Q2V3OHr1?=
 =?us-ascii?Q?49fDqLSCSwgeKQ1EbVO2RqQIuVyS1Y3u6JzHqtwRGRv6uQPXm0afaEaymWmM?=
 =?us-ascii?Q?d5fD2vQAW1uyvMc02WniMzBa/jspj9PR3D4JK2QzFLzgdvVpLth4TJdUeBUU?=
 =?us-ascii?Q?LnIZOfolgvNM4UzxHAcjnGugfoEhHDpDkc8iQ48w3bD87hCT+IqsxlG/g1QT?=
 =?us-ascii?Q?BaWHyrUvNmIQavjcnbfkgI23p1pJwHlBX4ZU6an94arjU+40GVVaDQHTEZDs?=
 =?us-ascii?Q?POrlvASiZCcyE8aGOh6CnscZqEi+PqphBWGf1tD1tTUJ9oVOdAtXThLJlzyn?=
 =?us-ascii?Q?/EQT2rn859r6YH6NGCuuW/tdnbB0kgwUxCKhfe68mrERD7B8ECvs2P+VI0DO?=
 =?us-ascii?Q?HnJXiyYisj4RW5oA4aCphmaJNJb2uJReeiF4dnCc0unua3uvOFxrbQNGhNZW?=
 =?us-ascii?Q?/YMKs67vGFXPtzgaGuLMANZleO8x0veh7ElR73y1mXILw9qMj8YbCylErNi3?=
 =?us-ascii?Q?biBBoCllDPnLilA2S4WAbzvz/ooa6S/hhEf494f8OoniQwTvzvXpnv0N6WPV?=
 =?us-ascii?Q?WUY/hQSQU/+9c7LkuF7Jm77K5qYfyHiiJw5YPUXzdHvVWfQ8haSmfhu/Kunr?=
 =?us-ascii?Q?E9cfUjY/nWuXF3u4AUDrIleQxUnUKdADfqrzZf+CnGC2QvXfQ4x1KZHdOndR?=
 =?us-ascii?Q?qD1k7c5TZ+eDJHs3VINT9yd9jIeYT5594rWGKSToNxjt8bTItJwB+U00g7BX?=
 =?us-ascii?Q?mH/mS07O8z9vedHvPjOJBhdx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f18762-ac35-4193-3cf2-08d98cfdcadd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:31.0025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LP/81vv0nOTSHsITzhrMYjm0p2hI8nIL+TMLFkRvrtf5v+WlkmVxLNshjvgKQbBfrSxXvh6j9LO2fm8a1DzVEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an assorted collection of fixes for issues seen on the NXP
LS1028A switch.

- PTP packet drops due to switch congestion result in catastrophic
  damage to the driver's state
- loops are not blocked by STP if using the ocelot-8021q tagger
- driver uses the wrong CPU port when two of them are defined in DT
- module autoloading is broken* with both tagging protocol drivers
  (ocelot and ocelot-8021q)

*I did notice that a similar fix but for a different driver did get
applied to "net-next" instead of "net" despite my deliberate targeting
of the branch that goes towards "stable". I don't know why, it is an
issue that is really bothering some people.
https://patchwork.kernel.org/project/netdevbpf/cover/20210922143726.2431036-1-vladimir.oltean@nxp.com/

Vladimir Oltean (10):
  net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
  net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
  net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
  net: mscc: ocelot: deny TX timestamping of non-PTP packets
  net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO
    with the skb PTP header
  net: dsa: tag_ocelot: break circular dependency with ocelot switch lib
    driver
  net: dsa: tag_ocelot_8021q: break circular dependency with ocelot
    switch lib
  net: dsa: felix: purge skb from TX timestamping queue if it cannot be
    sent
  net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs into
    BLOCKING ports
  net: dsa: felix: break at first CPU port during init and teardown

 drivers/net/dsa/ocelot/felix.c         | 150 +++++++++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h         |   1 +
 drivers/net/ethernet/mscc/ocelot.c     |  99 ++++++++++------
 drivers/net/ethernet/mscc/ocelot_net.c |   1 +
 include/linux/dsa/ocelot.h             |  49 ++++++++
 include/soc/mscc/ocelot.h              |  55 +--------
 include/soc/mscc/ocelot_ptp.h          |   3 +
 net/dsa/Kconfig                        |   4 -
 net/dsa/tag_ocelot.c                   |   1 -
 net/dsa/tag_ocelot_8021q.c             |  40 ++++---
 10 files changed, 288 insertions(+), 115 deletions(-)

-- 
2.25.1

