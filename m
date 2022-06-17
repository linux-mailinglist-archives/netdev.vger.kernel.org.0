Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9706B54FE56
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349872AbiFQUdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241902AbiFQUdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:33:39 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5986D4B41A;
        Fri, 17 Jun 2022 13:33:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I67kdhRCv4UdsnYKO1HZbqWcFAhkjpDFHBsuX/JCctRwjBR0LVtV2cqWl3nZuCQ0IT5Bjhh/1HvdhbFvG90J1X2rutzc5KPaosm4cJD43vj7x7aPxahMHAR8Poj5RsgriEr0Lx5nRjVEg6/Mva3BdUCQq5nm3hMaQONOwoUsE1631KT8uqnEZAYFRp6EInbmjB0Fu54ECFL36S2KSvibHpkQ0G/20C8QUENt1DjbIYuvVW1s44Knk0qAgQatsAZy+17xaizIiPyP75odcmtFowXaM8uF7P1U00A5wd5Ku8y1BvVGXTqsFpLQa4fv/4fgYu4NNoOXnhs39aMMBdEAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exxPIDij8pQnXWicTtvmtpGREwxmq154pOsXwralCyg=;
 b=RDykyiFHACh1ly4JLZ4BqFtSfzTvsBrNOPtulM2i0qxcXCn2Sigd8u2IqgfQR3R1HgXDuZRUoEdk4Xhmxq39FJSY8K09sz1T8YhDare35WZfWqk63BYkpFvsaZiYyZhMufAwm64NanCJ/w6wDtZ5xlAJh46v+Y/ETvwD47JTONSPeYg5Tc9lMd/YOpgOhZ2S3z4Zjvjf3ST92rBPEZATJinwlgbRHjV9wvp6ZE2l8/+3sksoJYmuIOTfKHM4No0iG2gBudDtG2aj/9eMYsyECFRHuMp6CF7cm3mRrdjkTltuDetyx8McIEPvltK6Ln6383mdKz0m0pk2AdpFx8R0kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exxPIDij8pQnXWicTtvmtpGREwxmq154pOsXwralCyg=;
 b=TfCfjenj3ootCgZrQ0ObhpXjz/gP5yQLO9c3jYf6SosUh+Uo5B3J3dHuMNsCq7LdODaKpjCuF/ZsEIl3yXSPQy/T9sKe1MZ4SR2JKwIOOMu4UC6umqfAB90vdrNgX1ltfmEsSvHGyeLPY++V9nyC1T9tgizR7xqd2G01QL8zRqLvYs5kytPFDSDG8BMu73tAe/7S8fJeLMgBw2d53FfOjKesFSkCvv/FNL1G2L3a6d+Oma9MyutloraLPheqptpDvaA7hpWAtKy3OoK8liHIkt98meVyBuZNNM+LNR9nuGuqE9xXq9s91daVFPV4Z44eBUDSeSBO4NDPaBEckgxDOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:33 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:33 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org, linux-phy@lists.infradead.org
Subject: [PATCH net-next 00/28] [RFC] net: dpaa: Convert to phylink
Date:   Fri, 17 Jun 2022 16:32:44 -0400
Message-Id: <20220617203312.3799646-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cef61822-ab56-4d9f-84fa-08da50a0a5d3
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438A13B71F108822CE1A18C96AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GALMvQso6jhkBZbALwDrUt0nHjeeXeIf6uuo4Ytdp91ANbLzIPAqurLHH0UqXdrZKq33URQN8VGwa1Zrw4R8P+gCtkU3ClURJYr8IZsWhxR9e1rhQiCTRNL1fJHV3MHHq4w/DHfsBgX5QJFAwqX2TBYbtlJlDR+aThwP4Ked1MTZ25eZEJ6uOaSYzOftskFxVuC+9pCOesP8iiQmLDnunNfXoQcwuPKTmfKYBbgkioSOV6Es6DzfJiYxFoU+YABHJWwdR0YMWnto8CPwfV9osxB4xw4kTf/FTNPX2RQrdFTVu9Dgzdwhw9VuGyFV0zpaZ4uXaF7Hz13izEU+ltmO4rDWaEb/M4SAlnUNj+63LlouZmUKNbWOF+Bxn9+Zeyru1axnJt1gEzkj4p7uimE0JMjDj6ZZ4zIXRPVTvKPyNNDET16y41VhgPDBK9ptnaPjj6BYifP+rbUrKfDPM8Si3wh45JWzKTV0zes6sIF4/5OhEoJJb+aloTO4tJzKSdOObU/lWkxd4q35vl4WYLIY3TdaRxoRE34QoevU7ZpVKHRzwDOa0i1faw/qgzTYQjjAUh//KoQsvcsqxVrYSAPueZY3pBj/yWmJPFFfQCON7B/oGCu2dBqfRE11LM/sw9sylR3YtarHoMTUVcnUTNfHqBrrOnnrWXxiR/lrISiQ0MKp6Dk5F4fzzZJwcJTyPkKn0FhiublXLBt3Yt+nZw9lXGZ1teyXIm4LddpixAL9Fo32uL79neP5lNc3by4GrUDHW18F6YdFbwQS4xbZ6s/aCB2FJYJ6GLT0781xDHJmhuc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(38350700002)(86362001)(7416002)(38100700002)(186003)(2616005)(5660300002)(6512007)(966005)(6486002)(52116002)(2906002)(6506007)(110136005)(8936002)(54906003)(498600001)(316002)(1076003)(66946007)(6666004)(36756003)(8676002)(26005)(83380400001)(4326008)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YgtOg/KlCT8MEbkhc09n61EbQ3EmluUbzb/fv4GP3SIxFWgiLn3LimE4YzKV?=
 =?us-ascii?Q?CcPfZoHA+IHjuwVthE3v2627I6JUZ6zdPGPZbHU4yjfS8UCBPVd4/qPpCnKN?=
 =?us-ascii?Q?HdPnjhqZGDbEia6y5FDarBIpOxTECRnhr9YODYmg6lpv0yeEit5262hNAQxP?=
 =?us-ascii?Q?QNfnd9QC6LJy0Y2zeOeYrLijHeYjBQ4V2RF7HQ+fCIFcGHbvriI/n7PCPtIC?=
 =?us-ascii?Q?g0198+C0GSJ1HdxWZNoWwMuihe4n6+sfbNtjuVlnU/jo1Ssw5K3Hfu8wwOF9?=
 =?us-ascii?Q?cbUOaKT4ctsN2iqdilz4eDr4yEVONM7OIhju6nX1MdoRwd6auUe89OwegYNg?=
 =?us-ascii?Q?KcaM+hORVduSej6S73WUSsx6tXWIWmwEoBWAOE+V6KbRx0NdyvgnerGl0GKn?=
 =?us-ascii?Q?BSwri1/1KjXI+xf6zo9Hzt3WPHwMb8PVCtIhRFBqOFYZ1cxfIPevNkguepZF?=
 =?us-ascii?Q?hdqCXMZktz2OdWv18pb760YzdwDrWqCqmTARmQmN/JREwsXYXMOop5+hHP4x?=
 =?us-ascii?Q?VfF5LVxEpeTV9H54hG5rW/UDy8/EoPTTZdojfwJa2w3SRsA5sht1vriR9rtq?=
 =?us-ascii?Q?RgMd8kIIt6n4y39u5mSoKgtEISIdi11Defpa49MqzAHC/0a+2s18NFbUgNvA?=
 =?us-ascii?Q?3xCA85/sSk4u18AAzbmYMNQcJh9Gz/XJlPOtoeoVtxZcF2NOt187nkiBoMeM?=
 =?us-ascii?Q?2w8vsqeH9Q6/4wa6lgUJlbMDesOQlfavSNCcicgXqY8QGwQxIZMtQ5YO35aH?=
 =?us-ascii?Q?hgx3zCWXlej0dTKmPl6pIma1ocW+bZ2OWMG2vZG7+XjYjElBpY4WeSE3Wkba?=
 =?us-ascii?Q?y669k4FJ7y/V01I5n9KIWw4E9pdiKUVNwgUT0XReGMsUAhK8OSWcQtvteXDv?=
 =?us-ascii?Q?8yjXsE6D74lKZOk6K836uwiQVDhex0LGh7pxWHIFVA+kelnoqOY2puoZQBiX?=
 =?us-ascii?Q?HaGodb5qZ8DOXeWCoU6i5dYzIPu5PaXgjNV/4lHhfiKVu6THwOxIRdORDTS9?=
 =?us-ascii?Q?j1Vd88ljXuE2d/G986h7tWnhXGjUNF3tTe9X845A1jFAPd2qiCo2WlpYz6ql?=
 =?us-ascii?Q?N32tKJbCvgYnSJop4KiMN7cpZ35iidbSFmXMkCpJ7bC9IhleB/0rIJ5UbNFQ?=
 =?us-ascii?Q?DxwLMi9fhPANpDvzzzgHeI5vy94cUiSAHxT4eZgjAB8Bef2xzUlj/hLdGuu7?=
 =?us-ascii?Q?iihec6ZjxeHJX3XMvsKJqZA7YX+Q0Rp4bFW5JG+rSDPHympeCJ19lfYHaWn9?=
 =?us-ascii?Q?m+7CjBMV6mwxgvil44VtTUsnusx6zA+d/0amERC2BXOXkdSmNVu8eIEr4smW?=
 =?us-ascii?Q?1oiTP1fLL1ooR4VZIPZGvKfWB1Mnwl21M8W7mDTSBGnNjPuj3NoBnHrCXXR/?=
 =?us-ascii?Q?SbK95+Nl3oN7hDuBKugOpIorjEYMRfGrpAx/x2y87zMOs8B9Cy6MFBQzkUQq?=
 =?us-ascii?Q?8kyVzgAOlOF7Yqz07kQaDRyeA3up6oAqwU65acK9osHqnnJYG5CatylCfWNH?=
 =?us-ascii?Q?m/eulvUcH8c4Y+mmsZpMEjYte1+HpMlrJ8jf4x0uDI/jg/RQnuhIBVX9ou1X?=
 =?us-ascii?Q?NlCSn2B7livxyRfHMd/Fo1SH9PKBeRtqbmVSqVYmgezZliMcByh82paw6/dS?=
 =?us-ascii?Q?aJgwx1V5YWfzfDr931+XHX8qKMy3GZMUfCei1sGCnNmjaEN0hp8MGSgtwB/P?=
 =?us-ascii?Q?kiK5CJjRTJkHZ3JrcS5it7capBkmDs8tKHFqssUac7ITfMOMPLuqxlP5dQeB?=
 =?us-ascii?Q?IgHUrUFvq7Lt1KlPkS8PuLEH0sFa9cY=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef61822-ab56-4d9f-84fa-08da50a0a5d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:33.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wEXk2mQN8GLiXYeMHEzk94FviE7Uqv6wW6q2pdlB4sDtn/YCq35lzfFjsRb8EAMsUXFz43RBqaB0wD53asTGKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts the DPAA driver to phylink. Additionally,
it also adds a serdes driver to allow for dynamic reconfiguration
between 1g and 10g interfaces (such as in an SFP+ slot). These changes
are submitted together for this RFC, but they will eventually be
submitted separately to the appropriate subsystem maintainers.

Only the mEMAC driver has gotten the phylink treatment for this RFC. I
would appreciate any help towards converting/testing the 10GEC and dTSEC
drivers. I don't have any boards with those MACs, so a large conversion
like this has a high risk of breakage.

I have tried to maintain backwards compatibility with existing device
trees whereever possible. However, one area where I was unable to
achieve this was with QSGMII. Please refer to patch 2 for details.

The serdes driver is mostly functional (but not quite, see patch 25).
However, I am not quite sure about the implementation details. I have made
a fairly extensive commentary on the driver in patch 1, so hopefully that
can provide some context. This series only adds support for the
LS1046ARDB SerDes, but it should be fairly straightforward to add
support for other SoCs and boards. Patches 26-27 should show the typical
steps.

Most of this series can be applied as-is. In particular, patches 4-21
are essentially cleanups which stand on their own merits.

Patches 4-8 were first submitted as [1].

[1] https://lore.kernel.org/netdev/20220531195851.1592220-1-sean.anderson@seco.com/


Sean Anderson (28):
  dt-bindings: phy: Add QorIQ SerDes binding
  dt-bindings: net: fman: Add additional interface properties
  phy: fsl: Add QorIQ SerDes driver
  net: fman: Convert to SPDX identifiers
  net: fman: Don't pass comm_mode to enable/disable
  net: fman: Store en/disable in mac_device instead of mac_priv_s
  net: fman: dtsec: Always gracefully stop/start
  net: fman: Get PCS node in per-mac init
  net: fman: Store initialization function in match data
  net: fman: Move struct dev to mac_device
  net: fman: Configure fixed link in memac_initialization
  net: fman: Export/rename some common functions
  net: fman: memac: Use params instead of priv for max_speed
  net: fman: Move initialization to mac-specific files
  net: fman: Mark mac methods static
  net: fman: Inline several functions into initialization
  net: fman: Remove internal_phy_node from params
  net: fman: Map the base address once
  net: fman: Pass params directly to mac init
  net: fman: Use mac_dev for some params
  net: fman: Clean up error handling
  net: fman: memac: Add serdes support
  net: fman: memac: Use lynx pcs driver
  net: dpaa: Use mac_dev variable in dpaa_netdev_init
  [RFC] net: dpaa: Convert to phylink
  arm64: dts: ls1046ardb: Add serdes bindings
  arm64: dts: ls1046a: Add SerDes bindings
  arm64: dts: ls1046a: Specify which MACs support RGMII

 .../devicetree/bindings/net/fsl-fman.txt      |   49 +-
 .../bindings/phy/fsl,qoriq-serdes.yaml        |   78 +
 Documentation/driver-api/phy/index.rst        |    1 +
 Documentation/driver-api/phy/qoriq.rst        |   91 ++
 MAINTAINERS                                   |    6 +
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   |    8 +
 .../boot/dts/freescale/fsl-ls1046a-rdb.dts    |   32 +
 .../arm64/boot/dts/freescale/fsl-ls1046a.dtsi |   12 +
 drivers/net/ethernet/freescale/dpaa/Kconfig   |    4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  100 +-
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |    2 +-
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |   82 +-
 drivers/net/ethernet/freescale/fman/Makefile  |    3 +-
 drivers/net/ethernet/freescale/fman/fman.c    |   31 +-
 drivers/net/ethernet/freescale/fman/fman.h    |   31 +-
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  319 ++--
 .../net/ethernet/freescale/fman/fman_dtsec.h  |   58 +-
 .../net/ethernet/freescale/fman/fman_keygen.c |   29 +-
 .../net/ethernet/freescale/fman/fman_keygen.h |   29 +-
 .../net/ethernet/freescale/fman/fman_mac.h    |   29 -
 .../net/ethernet/freescale/fman/fman_memac.c  |  864 +++++-----
 .../net/ethernet/freescale/fman/fman_memac.h  |   57 +-
 .../net/ethernet/freescale/fman/fman_muram.c  |   31 +-
 .../net/ethernet/freescale/fman/fman_muram.h  |   32 +-
 .../net/ethernet/freescale/fman/fman_port.c   |   29 +-
 .../net/ethernet/freescale/fman/fman_port.h   |   29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.c |   29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.h |   28 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  155 +-
 .../net/ethernet/freescale/fman/fman_tgec.h   |   54 +-
 drivers/net/ethernet/freescale/fman/mac.c     |  645 +-------
 drivers/net/ethernet/freescale/fman/mac.h     |   62 +-
 drivers/phy/freescale/Kconfig                 |   19 +
 drivers/phy/freescale/Makefile                |    1 +
 drivers/phy/freescale/phy-qoriq.c             | 1441 +++++++++++++++++
 35 files changed, 2562 insertions(+), 1908 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
 create mode 100644 Documentation/driver-api/phy/qoriq.rst
 create mode 100644 drivers/phy/freescale/phy-qoriq.c

-- 
2.35.1.1320.gc452695387.dirty

