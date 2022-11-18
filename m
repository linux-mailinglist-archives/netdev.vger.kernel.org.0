Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DFD62E9F5
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiKRACH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiKRACF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:05 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2046.outbound.protection.outlook.com [40.107.21.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05AC742F2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xty9FfcMtmrybwMh38kSR/VdE9sWsWrXuOm+la0vzDaaH0LcTCmSko85+4xB7oUKPB3rE9F2kuYZNPimQ84pU/zTJ2gJhFZ9OF5EEyzbTG8qkXL6B74i4KOGIA/967qGKanOphXa421hZYs96OwuzlooZpZWgLhsXD6s0akOugw17IXH5wsnm7eDk4gy6+LWIuotBx53TKrk89gY+YTHKY2UR9M9pNPBytaixFVqLysVZGfBRaIR4CTOksu34qq/3WcxlN5IC8edgALBwc1p36IWpSxN/RYgT/PGSwXt9uwC0wkAS2Kh7/8LTqarJJMlbPBEU0XeEWoFfWl/r/ljVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CfdXhByadzkG+YuICVWoIpYDnuJ0x/h0W15q7YWd1E=;
 b=GJuy9qhlAosDOuEdtYVkVBa94LsAiEdvgwWRbZyF0vy2UTBolcnfQnvjNY1ofzSP71K2p6o05X9wd8Ka3yAPQ2rrs9OOmKfVU45yu5H3yvk7RS0vSe5axHhBJshRDKGzrkoeD05WXysJLi6AEDBtfP2b912rgO6Hf/sPS1VFE1Z9PwR/fe/8jx8+uSc/tu5ERtszNOK0NmYGO5IdeMWDAQPoP7fUK/AA8Q9MTcjJHyJFY7QiIij4imbNZp05v90liWbIgTViXGZvM/177fTXBM8OLNnllYUmMx452S7sJJ1ZYZ3yLtPWXoCm6c18/Ghf/E+m9n7XU7s1LwVYfeoS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CfdXhByadzkG+YuICVWoIpYDnuJ0x/h0W15q7YWd1E=;
 b=O8dF9Ulzp3McNW+DBL/GpUH3fzF6Wj4fiBPGDex3/w8o6xBZHmORu3w682p4L0u36Dd8kFx9Efnq7rTAYz4yb+d9N50eOzKswKQZJ5eRhoNyDxX2RvF/UNFXQ+xNqzaGoKDVVHMD7G/MR3cDkUf/YQWCBC13/kw5IJEEJPt7+Zo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Date:   Fri, 18 Nov 2022 02:01:16 +0200
Message-Id: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 130696b6-98f6-460d-5d0f-08dac8f81ebb
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bq5CHBItybJ9QYu599L7Ka3sVhRqhQm9I5xlUWCTqbJcLEdfokEFs6TssoqPx/tIH0MVkBiyFwr1t9E4BwUgwgaE5OKjhznbiAswOupUQcxbC/6PElCAFH+txkm56JoD8hrmBQxysku/994YxRZfL/SzvLTgVIW7ReyQ99wqbZaawyyAlB4AzmusA4fCbnqHdD6N7eEXdwiETrEXYuZ4QmCXES6zUQ8V58hHVlJg0BcESYSrCdIKbp4KWaac6xP4kAt+rsKRDovjwB6IY0BSU4L1OvEdba+ValUvgIDFhwlgNBwFQpJZlyeEXYHHvC8kvbbhAFjS7CxV3URg41DVD/qHBlpygLfkjMT5w5wxJD8aFgzROFGbUw4m8BRZPgkzYhmzbGQjfpgY0jtcews61pIHwczlYRr3IAeMw+G0RyWLpFcw0pbhA/avc6eZEdUbkmT/6rTXF68XFDPaFqY2Ape3aOIREVXcAUwl9JwqHb5yloFh6Mhe12q6tFmHao9MjKN4FXhd7UEcwA3N4P1cPd0Cv7mK/E7wWqUROqXE3vPZP2WQQqYYUQvQy3GSzdZgHgDx+TSvT/QqdYev+vsQjBMFNnbdZlX9W6gtUQbVvpJngCNTb5dxmeaXpCqXlwFNL/gjX6y91TO2nt1VI1nSLeDw/eVfqrZfRJ8RhT0izLKbu7gZTNS56d8fa4/pTvSVSET2Xyra1aeneBJbYj+lJCeAqAF6OCWSlk+RPGUZzMfDla1I5zsOfV2sxGecMSh59hGsXY1dLcLfbsM41ictmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(966005)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YfzKNt5tOTxEvzd/cSaM/+kEiNg1126AqjvkBlNKVyaUNHOzDRSDVc083vnh?=
 =?us-ascii?Q?F0Y48+VTRVe/vQiOfLgIk7omUxI/ps0mutNpcJm8V4Oomiw/6Ssib8a1U9hX?=
 =?us-ascii?Q?uLm/MPvsgfegKnRQfDW3LOfEzQuxqeFTWisqdm25vOmlHOmn0FzHUQAXLKrz?=
 =?us-ascii?Q?4ZToW5PT+q330qwiunlTKaqOT8bvfauS0SJt4Nipk8iEtnoCbuMO+7sIp0Eo?=
 =?us-ascii?Q?FRMjqs6OOzIRCEHOILZ+m6aUDx7jMmIH7f5SdEig/BiOHM7MpYypeuEKIgjp?=
 =?us-ascii?Q?p1CCRuGpaUVMv6n/j5YZxYd2ntbjTVHbGkbuVRXnV/xU46oVxxwzbVy1U/oZ?=
 =?us-ascii?Q?3gHrpAOkr7c5osJuNdtw8TQ8szA77u+oLk/bhPR8Pp0Gkjw000RXLpNjeuAU?=
 =?us-ascii?Q?bpdfze0MffBNmyaA076AfUnNx+lkA62iwsxtgZkBCCdTaIY/A77er753VmuW?=
 =?us-ascii?Q?z/cbZy+mjVm2SxaouwM/KevRfoeWUJ2PngqKyslWutCoHfJl9RJSs4QwtDj6?=
 =?us-ascii?Q?2clq8czpWmrR+C/ws4U6MXsiH7MdudZF+GQ8MloZUNSLqoQuovw0lzn0ozTR?=
 =?us-ascii?Q?rfOqNC70ttqYBlDUf/4ClQwKuwf0nzAb72MmvmZvsVgVTjOzNMM3LegQ+suO?=
 =?us-ascii?Q?jlkt4tCEQFUp78K7cXSDzOcw3D0fMiQh2BXmb9LQ328Mw2jgDTVPjtbNxnje?=
 =?us-ascii?Q?eFreLMBxWL0UbQ7a8Ta1h6x/Hne+akJzBGcYXnm/aeSaYHhyIk4zyR6WgmLW?=
 =?us-ascii?Q?1v48CLXVLT0hO1uC5G1ggIhsqGFeTjKVVOoeKCLKg/LjVQE5Xj9Thk8C6yC2?=
 =?us-ascii?Q?gQOKVwmHy+0JJ8N4FlZNV5/LNmhA59nQgXHZY/p6//ih6/cevwi/LGMvRZ4j?=
 =?us-ascii?Q?mWgzihOjqwcBw7sdMg3vUA/v5ucB+L0EQ9NvRHdwEZhONnghCa83bqCe6oPM?=
 =?us-ascii?Q?hJLpR9ebT0HDyy8bOWq6w6b5NkKiWt7cMvo+Gw9ZbhGEBjtYQXyEwbUllZZD?=
 =?us-ascii?Q?eUJTzvWHQhqSGZGclTi9BZn3s1ZTLkLnG8ytxkacEZWc4zwL8nLP4tOCnHM1?=
 =?us-ascii?Q?UehUnqWUaUnslMfZXRGn6xjprkiiHMHh2A1NGuyMx4PgcCneOotuHUagF7jj?=
 =?us-ascii?Q?f3Ap5hB9NqST5AesVS3/pSlIc/lkTDjoiFcs2QJbyJ8okPKQnGJXM9G5lrz6?=
 =?us-ascii?Q?g3yKBbaQQpuHCZNsU3V3gXTDrtbsduWDigRZz2rc6r03Wk6WyvxH/nvq3vna?=
 =?us-ascii?Q?FLvMabYXL0AWRaqiWS5/OyMnF6IgWlotUcUbFLxBqg93KCvKVfUWuw5JLiAJ?=
 =?us-ascii?Q?AI5oTjZCPvk+SUvEGHZY1hs8QsEUK1jEgNIKoqPeq13ZnaoddHT0Ow2FLhhk?=
 =?us-ascii?Q?AY2ITjWDT7HGZOxrZzljoWQ5pjO08OhM/f/aTuhYwF17rUKMuPj6Q3CNzLNI?=
 =?us-ascii?Q?7j5olimC4ZOWMbVLrK0OMlREzldR8VN4psJJAVXkxYniOWVyVA8LDHugzFMS?=
 =?us-ascii?Q?1tlB3VoQYwUfY1yETWa0gJMZRe+lz5b5F+gw+KWVmeRP5TKE5eNMWgJMidKo?=
 =?us-ascii?Q?RZttGBVVL5pER57YbFDSG7z6r6N2NAVaWgXYYaNFUf/0QqWo3x9OXYPxl+9/?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 130696b6-98f6-460d-5d0f-08dac8f81ebb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:02.2198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12fYK2tCWRMxMIu40LLQ9t0AZXA28X7wILjLCTS1m59zyvjnD2cCCKn5AbCAvVJvgiFRLcSGoOVIIIZ9wMU8JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Problem statement
~~~~~~~~~~~~~~~~~

The on-board SERDES link between an NXP (Lynx) PCS and a PHY may not
work, depending on whether U-Boot networking was used on that port or not.

There is no mechanism in Linux (with phylib/phylink, at least) to ensure
that the MAC driver and the PHY driver have synchronized settings for
in-band autoneg. It all depends on the 'managed = "in-band-status"'
device tree property, which does not reflect a stable and unchanging
reality, and furthermore, some (older) device trees may have this
property missing when they shouldn't.

Proposed solution
~~~~~~~~~~~~~~~~~

Extend the phy_device API with 2 new methods:
- phy_validate_an_inband()
- phy_config_an_inband()

Extend phylink with an opt-in bool sync_an_inband which makes sure that
the configured "unsigned int mode" (MLO_AN_PHY/MLO_AN_INBAND) is both
supported by the PHY, and actually applied to the PHY.

Make NXP drivers which use phylink and the Lynx PCS driver opt into the
new behavior. Other drivers can trivially do this as well, by setting
struct phylink_config :: sync_an_inband to true.

Compared to other solutions
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sean Anderson, in commit 5d93cfcf7360 ("net: dpaa: Convert to phylink"),
sets phylink_config :: ovr_an_inband to true. This doesn't quite solve
all problems, because we don't *know* that the PHY is set for in-band
autoneg. For example with the VSC8514, it all depends on what the
bootloader has/has not done. This solution eliminates the bootloader
dependency by actually programming in-band autoneg in the VSC8514 PHY.

Change log
~~~~~~~~~~

Changes in v4:
Make all new behavior opt-in.
Fix bug when Generic PHY driver is used.
Dropped support for PHY_AN_INBAND_OFF in at803x.

Changes in v3:
Added patch for the Atheros PHY family.
v3 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20210922181446.2677089-1-vladimir.oltean@nxp.com/

Changes in v2:
Incorporated feedback from Russell, which was to consider PHYs on SFP
modules too, and unify phylink's detection of PHYs with broken in-band
autoneg with the newly introduced PHY driver methods.
v2 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20210212172341.3489046-1-olteanv@gmail.com/

Vladimir Oltean (8):
  net: phylink: let phylink_sfp_config_phy() determine the MLO_AN_* mode
    to use
  net: phylink: introduce generic method to query PHY in-band autoneg
    capability
  net: phy: bcm84881: move the in-band capability check where it belongs
  net: phylink: add option to sync in-band autoneg setting between PCS
    and PHY
  net: phylink: explicitly configure in-band autoneg for on-board PHYs
  net: phy: mscc: configure in-band auto-negotiation for VSC8514
  net: phy: at803x: validate in-band autoneg for AT8031/AT8033
  net: opt MAC drivers which use Lynx PCS into phylink sync_an_inband

 drivers/net/dsa/ocelot/felix.c                |  2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  1 +
 .../net/ethernet/freescale/fman/fman_memac.c  | 16 +--
 drivers/net/phy/at803x.c                      | 10 ++
 drivers/net/phy/bcm84881.c                    | 10 ++
 drivers/net/phy/mscc/mscc.h                   |  2 +
 drivers/net/phy/mscc/mscc_main.c              | 21 ++++
 drivers/net/phy/phy.c                         | 51 ++++++++++
 drivers/net/phy/phylink.c                     | 97 +++++++++++++++----
 include/linux/phy.h                           | 27 ++++++
 include/linux/phylink.h                       |  7 ++
 12 files changed, 212 insertions(+), 33 deletions(-)

-- 
2.34.1

