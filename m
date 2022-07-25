Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616E75801FB
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiGYPhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbiGYPht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:37:49 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D538CDED9;
        Mon, 25 Jul 2022 08:37:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvITZUj3nBiC1zwBMzFAamjinUtOZWkhmVCaVQwPAb5JOHRpro3ZioMBdytpmcZH0PAdsI4QniYzB4VoKhXpqQiHlOJdm2R64dmS31AKH/+PyBDp78RwYXAnaxkjvNCDqsb91wJT3Wn8VdkqbBk190zem5XJeZMD9OAeZShmrWAFgoXXPzdXongAZ2wdaK6sU0FkV4aXUFoeY3sZ+cyQ8TIIH7GAxRZLy0njcqJ1X9FIukRi3O+4V4t83WOreGIWHgq4lw9hBji6FZW0YlvBqvvIpGx88ODjDay/ZG49NghiKhI0/kDoylCP5F7kbXJOqqqPa5ZsGrTuggPcQ2hA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fcvnr46J0UeNfy0ek1FNBLrU/3NZL7dsjZH97DCB8K4=;
 b=lHp6+IxcO4k1szCHp7cg5PykQX1IY5RBlzvXAI7V836CNUT4rrWAyq/GpSuHHb1kuMu2lD47CONT2PZebQXkvst2r7e6u4mDanhsS5HmMqoE1tKDgeToew3ipUG+4CjNbq4EMpA4p/kR59WUEdPF+SedSMPpEEt5XxhFi/YklFzSGZQlUW8uF0CYvAbAQITGROeCSNItZReIC1hjWhuXMNfF3tLvM6JCaPFCBrYstX3l2EU0zUszt2ft5XDlmj95pTFv7uPL6F7qM0jGFxAwnHkV/HvpOHnbl6vKTX8qsqk8i+vRMmGca3YE35h1W7q/PS0rzHODpje/LVpIyqfcjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fcvnr46J0UeNfy0ek1FNBLrU/3NZL7dsjZH97DCB8K4=;
 b=UjQAQnxqyvtzHf0LFkHgPy68IvhGZfi7KqhLKLZq13OfYiEsNNJnWExxQLSdpCVLOwqEm/csUXWpcG+rt1pzaX+dOzeuanbcUurpgvp5jlEynIrK9bYqyioN3O618/31Y1LZNpjl9wN0si7Ns/VUgyqYAyWDuQWa89eV2nVp9ax3PEJZwCs+i3mXsqCu1bA4dcziGVqxockVDvMG4fADrWa5Z+jNHpJCHrkMHHFi7nbzDFeBM6riQCD3SNAjsAatWohe/sqZM4CmLi0rC2YDh6zZAxy1Q3bPmPf9a1nJ+nrH8hlgdR0x0ZaZbcJqX+CR0OZPEg/tZI+0t4EfTUycDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4394.eurprd03.prod.outlook.com (2603:10a6:10:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 15:37:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:43 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 00/11] net: phy: Add support for rate adaptation
Date:   Mon, 25 Jul 2022 11:37:18 -0400
Message-Id: <20220725153730.2604096-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da72b7db-f13e-4b15-5f80-08da6e539d8e
X-MS-TrafficTypeDiagnostic: DB7PR03MB4394:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwWnsj3LHbCPFbC/bJe+1Drysfh8yxEkQ6VYHaJ/leeXfuh3vswiLBmrRVZvKRbewrg6YllhdMYaQNj1YaAR+isf72lqL9gpi8fX+LhjAhpMcP3r7pO12uNbhB2nQIl+s007Vi72dYbRxLha7jKyksOWIMU5lW6CsyLYIaOIRYU/pWMrmuQ+8VvjU2zL7jfWavUcqrhKrE1f0OtVHCVJ6S534MFv2qL2C7uES9RDi2UA6oLEDInnMDILhTjhlhYMy8EtNz/6vzSDspnsZc83fKCoffOSt4tlQtIJJCGxHXeBg86vdSQIXty9fXKcnzOML23DVXSkJS7CNNrFbQVQZ7rDMpT9ztK1QeFM1cyvjZv9w0FH1oDueAs0R245RmTlW3EOPb1qjZCL+FNXQ5kQMiiDKgfaB7aJYTA6kuGuuSFU8Ku714E7aUVzTngf6AlkunSCFVR1DwHShzmcocKca7Sr7QssruDxMPMKODnD23ZWTsICpspjdUswh/tLkcbRTXFkqHnnfzooLVAGMFZa8Zq51k016+GzdB8nmGxVBz2rkeOOddBu9GKpgU/LUrigd/bhGbStEcwV152lB2lLYw8MVM/2MQXbgO5lvy9YS/1pI9Z2oTBhl6ZRRiRoc17amBNE6e6MEmQI98Jdo4i214fP0OUTMwui/kn0d9fyQfyxW9qs5J9In1rkP+nLYvs+D7tAEJGQyXzoz8tOX/rDp1uxUJV2lUx4yqH0qT38r2jK4usFap7+OZV0JwQnIXQQ/dUKgCL18mIcOpgyN1SGsomf7REM+elEile0RK/rMRnzu4fCuB4VfIbsD3ibgqSG1exZeUVgUleryOEPX5gaTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(39850400004)(346002)(54906003)(110136005)(6486002)(966005)(4326008)(6506007)(83380400001)(41300700001)(2906002)(86362001)(478600001)(7416002)(52116002)(36756003)(6666004)(38350700002)(26005)(2616005)(38100700002)(6512007)(66946007)(1076003)(66476007)(8936002)(44832011)(5660300002)(66556008)(186003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fboNE8loOfGgAPAt/S3oFxA12dtw4lfDkO/c96eKxWg8hGtuyI8Ln/qpVKfz?=
 =?us-ascii?Q?xbxqIXauTFWwJ/DAJCPljyFdN+1gPEhxkfzcjMg8QKUaByoEHQeE68s2zs8y?=
 =?us-ascii?Q?TJ/WiHaCllBV6OVDq9K1d1bjqLmB3mdXGcrUhKvJuOfCpPcRqDGEI1J44Bkd?=
 =?us-ascii?Q?RNhJ5b6S/l55Codm6NCbJlSQ1T19uRq6vI08PTQtNrT1L8VXAp/7V/qjWlZC?=
 =?us-ascii?Q?vfMAGmnMZ5Z+1+iTVjpG4bvPqtTnrJP15Y7Jf1ocwgEcFefgX0kOfoNn/0N4?=
 =?us-ascii?Q?Za0p0QwYZ4AZ9AkjMBqpc5C2FhucjEUdfSdSh+PNtQrTb79MWWmjPn9Yubeo?=
 =?us-ascii?Q?wYbetUwkcZHT/F2JNKh8Y0pgTT1XH7Ox2wPfqMI6uJVIY8E0AjTCoH5bjG8c?=
 =?us-ascii?Q?fXiZ+f67Kdf0HNZI3MRYnMyA75c/jvmTTl5BNyrfWmVz33I2gAKht6PEKZoZ?=
 =?us-ascii?Q?SXf2tVD4IZvyhiOrg1RTZHPHLau64vf+B/0paXSXIjxdNhVERl6I1gk8OFQp?=
 =?us-ascii?Q?fnMe4BxWwFOG6TP37buVYrSmeFcnvxyojuTBZRfuHPoA+hL+pflmV4Urgm5V?=
 =?us-ascii?Q?+Op+1neIuhV6/IAmKpfHb/Lsgz/nWkPWg93WuhfrrkgCue4EqjS7ioSiqyCm?=
 =?us-ascii?Q?hfOTYFU3SFHXSacdq/ogvhbfefpVd4sIuFe+8k4mM0AiY09xmZ65tKYE+d6W?=
 =?us-ascii?Q?9VmjAyniAjNLhzY3CogHSvzMABnmwVJnUT3wQbSZS4Uur9eQWkN4Es5DSJzS?=
 =?us-ascii?Q?yHbjV3EPYttVtv29En0sOEvFbzJ4q6oy5G/YRsh7MF81MTMWI64GWwB8S/WG?=
 =?us-ascii?Q?feIaPCa/U6XeM3yWLrtMbISpFTnzrk9z4DnKZFbCPTvF01blxDeV1bb7s/aV?=
 =?us-ascii?Q?+fw3ItS32HviK6MPZpYee3U+MUGz6WtmnEuncwvoNVyklgLcee1777NhVpW+?=
 =?us-ascii?Q?YkyfAiQzfVshFAg68Q/q+RSXKomQFl6I6uX/bUOS2LYFRUPt1KGfHwtsA0Tx?=
 =?us-ascii?Q?SQBIscXbRVIgZllHVAaqStZPIGwsD8OPix+rQnDYofof1SAs9iJrOlwcRqHK?=
 =?us-ascii?Q?A8DFVs6s0TBM6OpjN+TkTSY4oLBJXvMSk/iwMsXPrwx9tmBr11EsYNGxylyA?=
 =?us-ascii?Q?mpqPCXtEBxoiXWQ+ts0cF9pXlLDWCVlBYNkimQQ4S1NhhCN45eO2D1ErL6Rr?=
 =?us-ascii?Q?VMCp+nGoNCR3sW4zEBiYWpMEq31/0T8d3lku9t9Z9s0XEy/nEdEhc9tuueKY?=
 =?us-ascii?Q?zbBBamQQJrFS5896w0UiM4aO60lxHwnT+t60upxhRnSa6wPBuG/160Rpt0WE?=
 =?us-ascii?Q?SWF95bwTuwIZg5+zQVfREkmzozB4Wckda0HAQG6NDi69k87QCbUTs4hRfj/v?=
 =?us-ascii?Q?QJwYLYLnBN+itW5lz8OeJIKOhgClTweiFs0jzAy68OTWGIvZnqiSCsrSMhWr?=
 =?us-ascii?Q?3m2NaH7Z2qigydCGKOBPRjGQ+61qtSJhRNXUeNsv1dms5mo81XnM2dmPebyQ?=
 =?us-ascii?Q?+Biwme7s8Mqmq7/UpZbJIyhNyWmSnfKGBiC5i6xABtivPL3q5b8EsfmbSFPy?=
 =?us-ascii?Q?LR5mQi+M1S0juUwyyqdgYVUu/uD7YaWtCJB6LjCIt35pw550LIxkleqV0eRJ?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da72b7db-f13e-4b15-5f80-08da6e539d8e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:43.2915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMpni8C9G0tjaClAK4vJMawaJBVP9u0TBItWTOt2J0cJOt1VqpXYqTM1/k4fPdTAfKClZvAI/TVUDukNd5MQCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for phy rate adaptation: when a phy adapts between
differing phy interface and link speeds. It was originally submitted as
part of [1], which is considered "v1" of this series.

We need support for rate adaptation for two reasons. First, the phy
consumer needs to know if the phy will perform rate adaptation in order to
program the correct advertising. An unaware consumer will only program
support for link modes at the phy interface mode's native speed. This
will cause autonegotiation to fail if the link partner only advertises
support for lower speed link modes. Second, to reduce packet loss it may
be desirable to throttle packet throughput.

There have been several past discussions [2-4] around adding rate
adaptation support. One point is that we must be certain that rate
adaptation is possible before enabling it. It is the opinion of some
developers that it is the responsibility of the system integrator or end
user to set the link settings appropriately for rate adaptation. In
particular, it was argued that (due to differing firmware) it might not
be clear if a particular phy has rate adaptation enabled. Additionally,
upper-layer protocols must already be tolerant of packet loss caused by
differing rates. Packet loss may happen anyway, such as if a faster link
is used with a slower switch or repeater. So adjusting pause settings
for rate adaptation is not strictly necessary.

I believe that our current approach is limiting, especially when
considering that rate adaptation (in two forms) has made it into IEEE
standards. In general, when we have appropriate information we should
set sensible defaults. To consider use a contrasting example, we enable
pause frames by default for link partners which autonegotiate for them.
When it's the phy itself generating these frames, we don't even have to
autonegotiate to know that we should enable pause frames.

Our current approach also encourages workarounds, such as commit
73a21fa817f0 ("dpaa_eth: support all modes with rate adapting PHYs").
These workarounds are fine for phylib drivers, but phylink drivers cannot
use this approach (since there is no direct access to the phy).

Although in earlier versions of this series, userspace could disable
rate adaptation, now it is only possible to determine the current rate
adaptation type. Disabling or otherwise configuring rate adaptation has
been left for future work. However, because currently only
RATE_ADAPT_PAUSE is implemented, it is possible to disable rate
adaptation by modifying the advertisement appropriately.

[1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com/T/#t
[2] https://lore.kernel.org/netdev/1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com/
[3] https://lore.kernel.org/netdev/1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com/
[4] https://lore.kernel.org/netdev/20200116181933.32765-1-olteanv@gmail.com/

Changes in v3:
- Document MAC_(A)SYM_PAUSE
- Add some helpers for working with mac caps
- Modify link settings directly in phylink_link_up, instead of doing
  things more indirectly via link_*.
- Add phylink_cap_from_speed_duplex to look up the mac capability
  corresponding to the interface's speed.
- Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.
- Move unused defines to next commit (where they will be used)
- Remove "Support differing link/interface speed/duplex". It has been
  rendered unnecessary due to simplification of the rate adaptation
  patches. Thanks Russell!
- Rewrite cover letter to better reflect the opinions of the developers
  involved

Changes in v2:
- Use int/defines instead of enum to allow for use in ioctls/netlink
- Add locking to phy_get_rate_adaptation
- Add (read-only) ethtool support for rate adaptation
- Move part of commit message to cover letter, as it gives a good
  overview of the whole series, and allows this patch to focus more on
  the specifics.
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.
- Add comments clarifying the register defines
- Reorder variables in aqr107_read_rate

Sean Anderson (11):
  net: dpaa: Fix <1G ethernet on LS1046ARDB
  net: phy: Add 1000BASE-KX interface mode
  net: phylink: Document MAC_(A)SYM_PAUSE
  net: phylink: Export phylink_caps_to_linkmodes
  net: phylink: Generate caps and convert to linkmodes separately
  net: phylink: Add some helpers for working with mac caps
  net: phy: Add support for rate adaptation
  net: phylink: Adjust link settings based on rate adaptation
  net: phylink: Adjust advertisement based on rate adaptation
  net: phy: aquantia: Add some additional phy interfaces
  net: phy: aquantia: Add support for rate adaptation

 Documentation/networking/ethtool-netlink.rst  |   2 +
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   6 +-
 drivers/net/phy/aquantia_main.c               |  68 +++-
 drivers/net/phy/phy-core.c                    |  15 +
 drivers/net/phy/phy.c                         |  28 ++
 drivers/net/phy/phylink.c                     | 302 ++++++++++++++++--
 include/linux/phy.h                           |  26 +-
 include/linux/phylink.h                       |  29 +-
 include/uapi/linux/ethtool.h                  |  18 +-
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/ioctl.c                           |   1 +
 net/ethtool/linkmodes.c                       |   5 +
 12 files changed, 466 insertions(+), 35 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

