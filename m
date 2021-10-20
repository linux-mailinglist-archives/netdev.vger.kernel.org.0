Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BC143522E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhJTSB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:01:29 -0400
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:33959
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230245AbhJTSB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0hS/hy4rdqIqs0N/7fRm2DJKARohPhhmdWpx9KgWQlONicTd6XpSfUdXE0+q9qy413t+d/WE3MBZvQgCXpqgHVYqGapHYvGS3WjzXhlkSj5fqIeQRj6PY3BeTavd0fQM7Mrc6ROTp4d/pY3Ksr3rW9t/8GaFeOw6qHVRs4TBsxHSBS9yLzX49Bj9TkQyRc4mv7J6ObvbnjazLf0Qn3o8LN+UO8eIlcZ4DELbgp4cDUhU7AFrn2nI0AaC9hZs3YbzxVL7hhxT/1kpuA9zjikLzGZj2a8DgWEvI3xT1hIu7mA0rYIIaxWokSqQwWiSJqn7u4qSQ4uAyz0wCm50LjyyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SF44pqe4U8nNtdrfrqfdPJFRwcAdUjK8lA4rZbeaDRQ=;
 b=NAGTvRfK4gDK1wjqUxLjDPzYP2cL+K9bYM0aCDy7qQdhkk9UcUVqePtR82SOczUjsOxiEw6z/LG4MMbNedFQf9+JIixvvk+G1wcCHowX34QO9V8NYjZ1q09fqYxGPeh/bZBYbR9x2RZuarda5/UjS8HqzsCsyn96Reu290v3HWeV9E+BzljOabAsIT4u1BQaEQoEv7/LvBkyHTOYl1Da4VozL3W6NNxrVTInc0zUHo+/DARaJS95gFFgfiukW3kdMx7JOTURjhBqVSJI6ywfVwLBKgyee1f8Bdjp8G6iTHH5+HWCD29uyx6mSosvcnYUrXG2XM/HHVINZTZ1oo/d1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SF44pqe4U8nNtdrfrqfdPJFRwcAdUjK8lA4rZbeaDRQ=;
 b=PYPxR2wkSGnzLi51m789JCLyTpjFlpnZCm9BSqn4yK/XnoQQpCgzelCxIqWyeMjcnNHfzj8lIrWgPRRUQqwOBC3yPp61er2O0T+AgsiPaJlmsi03lfyJ1tKv5rflsw0iQVqsj9hXsrKU+4ha1rL88HZnepl+tVhzeXP/aMi9Y3s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:59:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:59:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 0/5] Ocelot switch: support a config where all VLANs are egress-untagged
Date:   Wed, 20 Oct 2021 20:58:47 +0300
Message-Id: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0019.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0019.eurprd08.prod.outlook.com (2603:10a6:208:d2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:59:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29ddc22a-64f5-46f9-a3d5-08d993f351dd
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286164E11C565C8911780A4FE0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhxQJUWqdMVlnhvgtju88EQ+Dzym01r3/auYDwWBpup01tr3FgY/Y8i6gfq9LomGBG/NxHcJYzgUYuwyXOTmFu3lamK7g2nr+WaHfnsX/mf5awUtTDbqyFYcPDkzhZ1m+GeIsTF4G6lo7aVfDaI6dcweONNWXQiB+E4Dn8sgXuxHPT2BzSoUJyifK7vvYzQj4lYYagcwXb2edkp+6X3aQid2lANupxZ/0nRPXOzeyMIojupPAIqZkCF+O8euCMWf/RUoNF5X40+MJgrmPRq9SwUwXbfQlrGd5ZNpU9EoQJcNlazvRcR2m71rlrjhPbgpi9OI4IenNBAG6png5otRuE9m7dXIj/LUdQy6VwRXBccvv8+uxxa2Ko3xFMG2YjWYR7ReTEIsxml8bfAgqYM0S6zI1rlGfEHDUtS1IyN+h7igXiCfzLvDbruPkpEi/JuEcsziA+5/HAXQ2unN8gTG1jEjkNA7SxNIndXzOSRIFsFZ8LIlB0lEdiU6qNSdz4a/gAetWPqwhdypp1SYVC4besXlMZ089Zv4sD4fR5GHVfr/49vz3uZtzRj/r5YyUoGlFmQWUv0/qLSSE6mtGURaK4PQxexrNekbbQ91csMlFPXF6xygbSDkTAkpDMyddTKEIPNilUQJI/rHN8urTZahKEf620bAp6NwL+5DjLRZf1NcGueAKFk2FMa47Uy60+kNWiDHmlIyj/eRfIMap9E6zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6636002)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(83380400001)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a/KAkttuVYgizm2voox0o66dRaKrA2LQbCef71xBXnCA2vMgsoNtbWbxVPNQ?=
 =?us-ascii?Q?Oh2j20XimUU7NrqORuIf1CdPnkRGgET7Yn5VSSddv900ILMMpLvX/ZCb56q0?=
 =?us-ascii?Q?otwgz2ycSlMN68yesvUjJPw89OFhi9nbsXXH6X5/qjUPf/TYJcbSYpL9rjqt?=
 =?us-ascii?Q?yTTqDoLVrXh1Q++Tv+7RMP6cMDVRhUt5M0eUoDprzR/3bLMMyyEHL1qXiOUj?=
 =?us-ascii?Q?NNk07Bc56uea4vwrNIam1gekk+NXV8yFTAeOq1fZs4OGatYzSK9Eewr5aJ2G?=
 =?us-ascii?Q?QEW5CwGyLwtmvxD5CH1dkCfBprdwhZSnEgfyuwRju8kRDaGN77KYyEslP6NI?=
 =?us-ascii?Q?XMBnK5Ka6Nc/lNPZDDp5+otO+L0lQBP5kB4wAiKwC4RYEVXnJZWqMQn1/NLq?=
 =?us-ascii?Q?KrHS0Nm5zdzxvZCSkNo+2/cvW1ReLNDPbgq5tKrZsiYlkr+ViRSHZiOiO0+D?=
 =?us-ascii?Q?iGX6fopYHcP8LnKizt8akgpcMFYs6axtNadsXYMTjNYrPhfdbodTSpLA7MbC?=
 =?us-ascii?Q?gpBDD5/+BkiuZkDDUK4esr5bPQXQ+Wm8+I674FzNBsxHQPGxin4Dx51FODu4?=
 =?us-ascii?Q?nkRjIiu4SOo+cWh+0aK+/AbCPHgtIL5eJvMpqDzN2VUtQtuNAmHL4GARfhmk?=
 =?us-ascii?Q?s+//LRQBH4yJmhvKA2QJ9x46fQ94N5eqFhIox60ai02YDH/pvrS77AhCpYSM?=
 =?us-ascii?Q?I0VKqQO7BzwW8JSw5AK/uo6sgsEUynDpU7odkVB0EZ6/GKoiyGO378wcA1ap?=
 =?us-ascii?Q?UBzpZiQ8x2/21ggtAcWKquoLcWo4XWzPbLqQ2LOPGPej/U7lOW37+PcuCq4o?=
 =?us-ascii?Q?MoRyt3y7wWs2HsT07P2TpqhXx8NCXqPb4u6Kod3PtPUQVVC4qRFH7mZh4sba?=
 =?us-ascii?Q?mI3m0Mo6eg+rGauZFJK/aewilBAxCCPrqPDfErev1IWG7Xmol19P9dogqOr+?=
 =?us-ascii?Q?xF0adO/mCJVEPPy2WA6sceCmIPs/UO6ZXqbb63QvB0wIbLGMxz7n1sdpfX3o?=
 =?us-ascii?Q?O17Xia3yOUwaiGEaYyBlU6aQrfGcqU6GBrhBWMuDl30NcIpU/1emnp9nTarH?=
 =?us-ascii?Q?8CQxtm5D/cFsrDOnlZ8eYiVz7EoxhpU28q/LC0megPlUkmWAfurPpRO1kRFA?=
 =?us-ascii?Q?H4MQfHKRD8Ncz3C7sqLyZMOEGQRE5on/BoV07Effoch6p+cMBwiD67X8gDIB?=
 =?us-ascii?Q?zeEhD2f+GyxoS1UV9Udv7+q8+YwxxOWQxk685tP/FY6Yh8U9ClQHHucT2BJR?=
 =?us-ascii?Q?ETnWzef12wsvU8wawOYhZU8mZCjJIWb9R4VegVBeF7rNjhhtAVvFhIXXQVfe?=
 =?us-ascii?Q?DzrXrS+d0vloj9S524H+oUjW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ddc22a-64f5-46f9-a3d5-08d993f351dd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:59:11.1520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+0oeF1dqpMs9f0ms5FYLwbMxNS3Le/c/7PR3W87xy5fDgcrvJfVz6NmbRKzq+N5XyjnFTDLtJLCvLZAGsirRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
Fixed build with CONFIG_BRIDGE_MRP=y.

Po Liu is working on a use case where a station attached to the Felix
DSA switch from NXP LS1028A must see traffic which is coming from
multiple sources, in multiple VLANs, as VLAN-untagged. This is currently
impossible with the driver.

The ocelot switch family have restricted functionality in terms of
stripping bridging service VLANs on the egress of a port.

Where the 'bridge vlan add' command can have the 'untagged' flag for
each VLAN entry, the ocelot hardware can have no more than one untagged
VLAN per port, or all of them.

The driver currently only supports the first option (at most one
untagged VLAN). So while one bridge VLAN tag can be stripped at egress
towards this external station, not all of them can. This series adds
support for the second option.

Vladimir Oltean (5):
  net: mscc: ocelot: add a type definition for REW_TAG_CFG_TAG_CFG
  net: mscc: ocelot: convert the VLAN masks to a list
  net: mscc: ocelot: allow a config where all bridge VLANs are
    egress-untagged
  net: mscc: ocelot: add the local station MAC addresses in VID 0
  net: mscc: ocelot: track the port pvid using a pointer

 drivers/net/ethernet/mscc/ocelot.c     | 272 ++++++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot.h     |   1 +
 drivers/net/ethernet/mscc/ocelot_mrp.c |   8 +-
 drivers/net/ethernet/mscc/ocelot_net.c |  12 +-
 include/soc/mscc/ocelot.h              |  24 ++-
 5 files changed, 223 insertions(+), 94 deletions(-)

-- 
2.25.1

