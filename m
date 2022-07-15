Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D657694F
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiGOWBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiGOWBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:01 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7CC4F197;
        Fri, 15 Jul 2022 15:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyDEpGnYh6yHoHVJ//NLrocYW04NVGGBqHTU3px8qUkBfKYDdcVZ0DCtXqTXL19bhwZEFKGFgHXS3VcuqLlFZZB/XyFxbwRc27XI/nFdPt96fGCIZmacZUK4IN3OzyfRNtLpchQ+D/3PEyvzMCgoyQ1QE3i32lf29iEakMUgJHYmZsQfAP8PJMbRqkjUB5Y8FMJSCopI89wGlbzN+R2zE2hQy3dIG8tmODcvRsSEjvaSyhUuD+o3Tg2IWBK5Jnp27XJN48aUusUfLUsgpIs2R1k2r6zRX+5r49e7r4R/CaCoWqPCgAzxLrA6C8DLCD5+IhO93gXhJrv3rAqxW5PGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhXYKzwGmvPyofrMP2vBV1cm1Pa0dwO5x068v8/itII=;
 b=jQvqHMufqlVHdCaLvNXFJ1TMH7NmtU4xGl9Z84tUkCjObOjZ62swbKk2g/Ni+blBGVhPFIwMP8Pu00HoktrBwoEoG6qoMwRCalzGBhQfjiHNfWy/0EfXfwWeKYYNihVLYC81fQpUAMiL+LXifOgy3zsssVtzmp1WRmJjF79Xju3DL7J9nUiiC4yF8mo2HoL4AkRk9JFr269LLWulekapgIUhZAj2tEwT66QSd029UTnvyxnk27Ym7hfSo+YlHFihU/CreCYqPRxrjrDINQhQG684/tyVpOQ+c075/1zGqcGzKr1TO5B5NCI685aBWKv7UTFI+8LK/uInpnoTw77dZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhXYKzwGmvPyofrMP2vBV1cm1Pa0dwO5x068v8/itII=;
 b=LzKWQYfBVVHWdHYIYI/eVOUGS4h0Gq3xgSCzFjSsARH+rrzCsO12Y/sc63/BMhxU/IrQHMBaKEgatE6o1ljcVz89zgjo3g+idb7MqIGKqTtbi4m2xxtbyL/HUpp2PhVU2B2n7KOb3FOZxvkGwSUWE0u6fFV69wh7yWBgxoB9v+GC2N9xOE4vXsoqMaya3dGpcMJnVGuNHOSSBs2ZGJtqgQ+enjgSfYVcEHthNU+UUTIOqleB8mF17dvWyM2J67MddleT2CABl965NexeLc53nr4kW9wQuwynhZB9fs5vql0QClehqIK4PrxFXMTv0bjAITOxWYlXxegl2amiMo1vIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBBPR03MB5302.eurprd03.prod.outlook.com (2603:10a6:10:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 22:00:26 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-phy@lists.infradead.org
Subject: [PATCH net-next v3 06/47] [RFT] phy: fsl: Add Lynx 10G SerDes driver
Date:   Fri, 15 Jul 2022 17:59:13 -0400
Message-Id: <20220715215954.1449214-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 688c4eb6-72e6-4c8d-12ac-08da66ad6c2d
X-MS-TrafficTypeDiagnostic: DBBPR03MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uLL+kWA25QbsWEfqwT6SyiziYX6eEL5BeCrgJ4cWPj+ZiU4f6oEdhdnKCaoyvenH6wFJKnbPiO2FKJQ+VJfPFhP4D/5p0VDX3WuA4mH6cbzsAR9L5eEWn4Fu7xKzYQK4l/JeANr1GeGOxqWV6M3EBzxbat1Rc/JmVucfMS0/CQ1sgLP9sR2hWKMZNSZ21NT3zi3gdXzwBvJaZ6aVowVcinn0qE00CM+3aQ5n9PZVDBnSHfaX04U1QVPYmfb9YTyMbF5cX000tWPCQa4XkgKwnE3bP5g+5WR0sGaJDmZXX2H8TuLn3zCb9+ByYdEFvsCzEM8JfZu/gMGZT8iBUHggdFkH3qKIMcIlKJqMCH5bV8PSACg1BQNKzqa0I2tBFiS8qPdb0c4Pw2DiTFQI6zsGkskl1n4tk5UmHeNyf13LFeE50kM1ylE1Y1kM/wu9oS8LdRvoOJuatbNy6ebqQ6EoHGBq9Fh+Is3mfgCegl3+THDQN+uKi1b9M8PDbpSNaRtF67M8iw2rFMVS/EDKexmXHUP6n9POyxNpsV8W9CAghYN2UCzBWPHYVl4ksUM6iZmH/jpGnWJDeFLJd82MeZW3AVIFZQNUQ03orSN4guJvLZMU0zkmVXhtwl49reRtHTEM0b1d/nezaPZ5UTN6aqzfg9hmaqnoF7jbWQ49fm6SpFmbCyCMBm8FqhAzUTScsjXNAWu7erp8Q8tplMH1kvh3zXSyu7PGSsDy3tdT2hOMCWmD44hSYtjicciMTRNS/mmrKMMNDD6ugqmT+GaDFVqDznA7b81kVXICFaxWP+Ec734O8RCZlYO0litwb2VUnNKRK1woS93pfqcN+3RD89W3d8aGDaXYJ2Jkr97RjaOZ0EQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39850400004)(346002)(478600001)(66556008)(41300700001)(66476007)(52116002)(966005)(6506007)(6486002)(6512007)(26005)(8676002)(6666004)(54906003)(86362001)(66946007)(316002)(8936002)(4326008)(83380400001)(38350700002)(2616005)(30864003)(1076003)(186003)(7416002)(36756003)(110136005)(38100700002)(2906002)(44832011)(5660300002)(21314003)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rj7EDFLsSyMvtwqKmxf+TpozdJxNk0k4mVAf+ytETDaKgav+e+NSZ21caqWF?=
 =?us-ascii?Q?T4u5nBYjNmT7Cg8F1nmeMy0LRadCgBrLxjFeCI5rPSF9n1yuKcVKl6HKe6n1?=
 =?us-ascii?Q?r8zxXF2eKzpo9pyOydvzkl1LAOrEM9Me0USZIr/zJ7HXoUmmBgYvX9UhxM0/?=
 =?us-ascii?Q?U13ETJPrUkg44OjIiFxJJFSenJ8l1OUKecnlcO9T9PmGqPpR1dEHsjOtG2p5?=
 =?us-ascii?Q?LcZhSvJ6qhw/QnEx/uXyWWXA0TmXrx7x0JZiML28iJ+Ak9lb2znP2ex/VzEB?=
 =?us-ascii?Q?Y+jYYwg523W9VRhm7slhRprzRYotD4t9PwuRMjVDAokuUWl1C/ZhQSc8ekhw?=
 =?us-ascii?Q?Kzn8Ev8C+lFaMw+vgVzOtrH1dVuylk/OQzHD2Pn7IC1Vp1xvv6e2amVxMoxT?=
 =?us-ascii?Q?0l9ZK3P5JHdET6hqIeCjQAZ05Sdx6jraW11jv4fwuhcQJWWaCw/EkGXxlzXE?=
 =?us-ascii?Q?MXLxfjS2I/S0T7SdYI5xmnzRdN29H/dCVE5NKVHGnUfwwOU51b5Bn9/vfSc+?=
 =?us-ascii?Q?xg23gQV7rk0o5UQ4exPX1hTv9cLddeMhWgUsoEO29HpY15emUNfyvVQprs3u?=
 =?us-ascii?Q?GUQdcrlAQWaRqeP0Y1T0taIQbYboAVPBM/nAtcaDmZTTmDtufN7phpbhULdU?=
 =?us-ascii?Q?9cZYDVvdn06ZrGK1nuQcDd/NXbt3WnZ3nL2A2DaSU71Wb6UxhsPdxsyHmIUg?=
 =?us-ascii?Q?vrkn8O4f0LYW+9mokmJkGzqETGRYAGKxwcxkh/MdTp4uKRAXKNgn9TXiSlC5?=
 =?us-ascii?Q?rmJ27ePTYnGXrvSmzTCcZogQSfIbSFJNDf5utZeVQPgXDGVxAHc520bntmt9?=
 =?us-ascii?Q?ChuDpnn43XdpnerERlK2SnEmD8buYu1+UVo8O4dTSs8WhjrK5U3lg2k9nnou?=
 =?us-ascii?Q?jmlfh42fD5mFf+ZCtQwQBLVWuLa8EuciaHoQL97FkzV80MeA8Y47BlcwoxEQ?=
 =?us-ascii?Q?Sy2lyAYY/8gHhmZSqwqPkjNgcSyLQtWG1Pnnmdjt17Wsj1uEcUVh5D0Tas1V?=
 =?us-ascii?Q?m/e6vati1Ut0kDMGQPjoFOYTIxwTcujthsz2u02Qtnrvkccw1tkXz+TgcnMw?=
 =?us-ascii?Q?EUYWuc6CWF+CWC2clsueFeiT6GlkgJDzu3ObHV4UZ6w9BxdzPKGS0DrhXfhY?=
 =?us-ascii?Q?2aONRcUzL9tLnK+jaYLxjh0SfGHR4Pri+zJ02oKXvOghBNAvD7kq66OU6jHT?=
 =?us-ascii?Q?J3gmKwZq5meoVQNq0HeKJ5ZemoSaLOxmRrhCCLfO6/cf9w/0du93hYp6/Q8K?=
 =?us-ascii?Q?72OpubRfUVdOytX0lxJ4DAVuyjTsmqYlztQIob3TSOZj5a3fHUCIQakJ5OW+?=
 =?us-ascii?Q?krXBng0lPnAf+nosaZ4OU13oDXe6lou5TpdE4lcd9ADcf+YEqCZh8qkf2Hi8?=
 =?us-ascii?Q?2M/59ODj9KQUY15MEfEj7DDeWeyRBbioGZk7Xnsd3G8+gRpd5Br85n8xuKIQ?=
 =?us-ascii?Q?sNgwkWsgXszqGtM24l44kVdu3S6BSbYW6Owvv1W6k2vgRtSnpokyCq9X1y3e?=
 =?us-ascii?Q?FCPw0rChdfkdocfHsmv68FX0elk4BecYE95leeRi6DGGKGD2YhBwmwoopnJK?=
 =?us-ascii?Q?QIbBwXO71fbKjoEXBb1tXRql2tJcSpFXh8CwQPaqr//I3K9UbTHCnsrnwogX?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688c4eb6-72e6-4c8d-12ac-08da66ad6c2d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:26.0364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJLkyzZcv4s6YALCdSJ+HDnZ50UnoKJ+AR9U44ZwD6Q7e2AbkuszMsSyxE5X+EFSHHX38ObddQJKlScGbkEhMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the Lynx 10G "SerDes" devices found on various NXP
QorIQ SoCs. There may be up to four SerDes devices on each SoC, each
supporting up to eight lanes. Protocol support for each SerDes is highly
heterogeneous, with each SoC typically having a totally different
selection of supported protocols for each lane. Additionally, the SerDes
devices on each SoC also have differing support. One SerDes will
typically support Ethernet on most lanes, while the other will typically
support PCIe on most lanes.

There is wide hardware support for this SerDes. I have not done
extensive digging, but it seems to be used on almost every QorIQ device,
including the AMP and Layerscape series. Because each SoC typically has
specific instructions and exceptions for its SerDes, I have limited the
initial scope of this module to just the LS1046A and LS1088A.
Additionally, I have only added support for Ethernet protocols. There is
not a great need for dynamic reconfiguration for other protocols (SATA
and PCIe handle rate changes in hardware), so support for them may never
be added.

Nevertheless, I have tried to provide an obvious path for adding support
for other SoCs as well as other protocols. SATA just needs support for
configuring LNmSSCR0. PCIe may need to configure the equalization
registers. It also uses multiple lanes. I have tried to write the driver
with multi-lane support in mind, so there should not need to be any large
changes. Although there are 6 protocols supported, I have only tested SGMII
and XFI. The rest have been implemented as described in the datasheet.
Most of these protocols should work "as-is", but 10GBASE-KR will need
PCS support for link training.

The PLLs are modeled as clocks proper. This lets us take advantage of the
existing clock infrastructure. I have not given the same treatment to the
lane "clocks" (dividers) because they need to be programmed in-concert with
the rest of the lane settings. One tricky thing is that the VCO (pll) rate
exceeds 2^32 (maxing out at around 5GHz). This will be a problem on 32-bit
platforms, since clock rates are stored as unsigned longs. To work around
this, the pll clock rate is generally treated in units of kHz.

The PLLs are configured rather interestingly. Instead of the usual direct
programming of the appropriate divisors, the input and output clock rates
are selected directly. Generally, the only restriction is that the input
and output must be integer multiples of each other. This suggests some kind
of internal look-up table. The datasheets generally list out the supported
combinations explicitly, and not all input/output combinations are
documented. I'm not sure if this is due to lack of support, or due to an
oversight. If this becomes an issue, then some combinations can be
blacklisted (or whitelisted). This may also be necessary for other SoCs
which have more stringent clock requirements.

The general API call list for this PHY is documented under the driver-api
docs. I think this is rather standard, except that most drivers configure
the mode (protocol) at xlate-time. Unlike some other phys where e.g. PCIe
x4 will use 4 separate phys all configured for PCIe, this driver uses one
phy configured to use 4 lanes. This is because while the individual lanes
may be configured individually, the protocol selection acts on all lanes at
once. Additionally, the order which lanes should be configured in is
specified by the datasheet.  To coordinate this, lanes are reserved in
phy_init, and released in phy_exit.

When getting a phy (backed by struct lynx_group), if a phy already
exists for those lanes, it is reused.  This is to make things like
QSGMII work. Four MACs will all want to ensure that the lane is
configured properly, and we need to ensure they can all call phy_init,
etc. There is refcounting for phy_init and phy_power_on, so the phy will
only be powered on once. However, there is no refcounting for
phy_set_mode. A "rogue" MAC could set the mode to something non-QSGMII
and break the other MACs. Perhaps there is an opportunity for future
enhancement here.

This driver was written with reference to the LS1046A reference manual.
However, it was informed by reference manuals for all processors with
mEMACs, especially the T4240 (which appears to have a "maxed-out"
configuration). The earlier PXXX processors appear to be similar, but
have a different overall register layout (using "banks" instead of
separate SerDes).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
XFI does not work when not selected in the RCW. This will not break any
existing boards (since they all select it if they use it).

Changes in v3:
- Rename remaining references to QorIQ SerDes to Lynx 10G
- Fix PLL enable sequence by waiting for our reset request to be cleared
  before continuing. Do the same for the lock, even though it isn't as
  critical. Because we will delay for 1.5ms on average, use prepare
  instead of enable so we can sleep.
- Document the status of each protocol
- Fix offset of several bitfields in RECR0
- Take into account PLLRST_B, SDRST_B, and SDEN when considering whether
  a PLL is "enabled."
- Only power off unused lanes.
- Split mode lane mask into first/last lane (like group)
- Read modes from device tree
- Use caps to determine whether KX/KR are supported
- Move modes to lynx_priv
- Ensure that the protocol controller is not already in-use when we try
  to configure a new mode. This should only occur if the device tree is
  misconfigured (e.g. when QSGMII is selected on two lanes but there is
  only one QSGMII controller).
- Split PLL drivers off into their own file
- Add clock for "ext_dly" instead of writing the bit directly (and
  racing with any clock code).
- Use kasprintf instead of open-coding the snprintf dance
- Support 1000BASE-KX in lynx_lookup_proto. This still requires PCS
  support, so nothing is truly "enabled" yet.

Changes in v2:
- Rename driver to Lynx 10G (etc.)
- Fix not clearing group->pll after disabling it
- Support 1 and 2 phy-cells
- Power off lanes during probe
- Clear SGMIIaCR1_PCS_EN during probe
- Rename LYNX_PROTO_UNKNOWN to LYNX_PROTO_NONE
- Handle 1000BASE-KX in lynx_proto_mode_prep

 Documentation/driver-api/phy/index.rst       |    1 +
 Documentation/driver-api/phy/lynx_10g.rst    |   73 +
 MAINTAINERS                                  |    6 +
 drivers/phy/freescale/Kconfig                |   19 +
 drivers/phy/freescale/Makefile               |    3 +
 drivers/phy/freescale/lynx-10g.h             |   36 +
 drivers/phy/freescale/phy-fsl-lynx-10g-clk.c |  438 ++++++
 drivers/phy/freescale/phy-fsl-lynx-10g.c     | 1297 ++++++++++++++++++
 8 files changed, 1873 insertions(+)
 create mode 100644 Documentation/driver-api/phy/lynx_10g.rst
 create mode 100644 drivers/phy/freescale/lynx-10g.h
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g-clk.c
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g.c

diff --git a/Documentation/driver-api/phy/index.rst b/Documentation/driver-api/phy/index.rst
index 69ba1216de72..c9b7a4698dab 100644
--- a/Documentation/driver-api/phy/index.rst
+++ b/Documentation/driver-api/phy/index.rst
@@ -7,6 +7,7 @@ Generic PHY Framework
 .. toctree::
 
    phy
+   lynx_10g
    samsung-usb2
 
 .. only::  subproject and html
diff --git a/Documentation/driver-api/phy/lynx_10g.rst b/Documentation/driver-api/phy/lynx_10g.rst
new file mode 100644
index 000000000000..aa445911d77d
--- /dev/null
+++ b/Documentation/driver-api/phy/lynx_10g.rst
@@ -0,0 +1,73 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+Lynx 10G Phy (QorIQ SerDes)
+===========================
+
+Using this phy
+--------------
+
+The general order of calls should be::
+
+    [devm_][of_]phy_get()
+    phy_init()
+    phy_power_on()
+    phy_set_mode[_ext]()
+    ...
+    phy_power_off()
+    phy_exit()
+    [[of_]phy_put()]
+
+:c:func:`phy_get` just gets (or creates) a new :c:type:`phy` with the lanes
+described in the phandle. :c:func:`phy_init` is what actually reserves the
+lanes for use. Unlike some other drivers, when the phy is created, there is no
+default protocol. :c:func:`phy_set_mode <phy_set_mode_ext>` must be called in
+order to set the protocol.
+
+Supporting SoCs
+---------------
+
+Each new SoC needs a :c:type:`struct lynx_conf <lynx_conf>`, containing the
+number of lanes in each device, the endianness of the device, and a bitmask of
+capabilities ("caps"). For example, the configuration for the LS1046A is::
+
+    static const struct lynx_conf ls1046a_conf = {
+        .lanes = 4,
+        .caps = BIT(LYNX_HAS_1000BASEKX) | BIT(LYNX_HAS_10GKR),
+        .endian = REGMAP_ENDIAN_BIG,
+    };
+
+In addition, you will need to add a device node as documented in
+``Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml``. It is important
+that the list of modes is complete, even if not all protocols are supported.
+This lets the driver know which lanes are available, and which have been
+configured by the RCW.
+
+If a protocol is missing, add it to :c:type:`enum lynx_protocol
+<lynx_protocol>`, and to ``UNSUPPORTED_PROTOS``. If the PCCR shifts/masks for
+your protocol are missing, you will need to add them to
+:c:func:`lynx_proto_mode_mask` and :c:func:`lynx_proto_mode_shift`. Lastly, you
+will also need to add the mode to :c:func:`lynx_parse_pccrs`.
+
+Supporting Protocols
+--------------------
+
+Each protocol is a combination of values which must be programmed into the lane
+registers. To add a new protocol, first add it to :c:type:`enum lynx_protocol
+<lynx_protocol>`. If it is in ``UNSUPPORTED_PROTOS``, remove it. Add a new
+entry to `lynx_proto_params`, and populate the appropriate fields. You may need
+to add some new members to support new fields. Modify `lynx_lookup_proto` to
+map the :c:type:`enum phy_mode <phy_mode>` to :c:type:`enum lynx_protocol
+<lynx_protocol>`. Ensure that :c:func:`lynx_proto_mode_mask` and
+:c:func:`lynx_proto_mode_shift` have been updated with support for your
+protocol.
+
+You may need to modify :c:func:`lynx_set_mode` in order to support your
+protocol. This can happen when you have added members to :c:type:`struct
+lynx_proto_params <lynx_proto_params>`. It can also happen if you have specific
+clocking requirements, or protocol-specific registers to program.
+
+Internal API Reference
+----------------------
+
+.. kernel-doc:: drivers/phy/freescale/phy-fsl-lynx-10g.c
diff --git a/MAINTAINERS b/MAINTAINERS
index 66738c8330db..085e110da079 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11799,6 +11799,12 @@ S:	Maintained
 W:	http://linux-test-project.github.io/
 T:	git git://github.com/linux-test-project/ltp.git
 
+LYNX 10G SERDES DRIVER
+M:	Sean Anderson <sean.anderson@seco.com>
+S:	Maintained
+F:	Documentation/driver-api/phy/lynx_10g.rst
+F:	drivers/phy/freescale/phy-fsl-lynx-10g.c
+
 LYNX 28G SERDES PHY DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
diff --git a/drivers/phy/freescale/Kconfig b/drivers/phy/freescale/Kconfig
index f9c54cd02036..fe2a3efe0ba4 100644
--- a/drivers/phy/freescale/Kconfig
+++ b/drivers/phy/freescale/Kconfig
@@ -38,3 +38,22 @@ config PHY_FSL_LYNX_28G
 	  found on NXP's Layerscape platforms such as LX2160A.
 	  Used to change the protocol running on SerDes lanes at runtime.
 	  Only useful for a restricted set of Ethernet protocols.
+
+config PHY_FSL_LYNX_10G
+	tristate "Freescale Layerscale Lynx 10G SerDes support"
+	select GENERIC_PHY
+	select REGMAP_MMIO
+	help
+	  This adds support for the Lynx "SerDes" devices found on various QorIQ
+	  SoCs. There may be up to four SerDes devices on each SoC, and each
+	  device supports up to eight lanes. The SerDes is configured by default
+	  by the RCW, but this module is necessary in order to support dynamic
+	  reconfiguration (such as to support 1G and 10G ethernet on the same
+	  interface). The hardware supports a variety of protocols, including
+	  Ethernet, SATA, PCIe, and more exotic links such as Interlaken and
+	  Aurora. This driver only supports Ethernet, but it will try not to
+	  touch lanes configured for other protocols.
+
+	  If you have a QorIQ processor and want to dynamically reconfigure your
+	  SerDes, say Y. If this driver is compiled as a module, it will be
+	  named phy-fsl-lynx-10g-drv.
diff --git a/drivers/phy/freescale/Makefile b/drivers/phy/freescale/Makefile
index 3518d5dbe8a7..bd54ecef8b48 100644
--- a/drivers/phy/freescale/Makefile
+++ b/drivers/phy/freescale/Makefile
@@ -2,4 +2,7 @@
 obj-$(CONFIG_PHY_FSL_IMX8MQ_USB)	+= phy-fsl-imx8mq-usb.o
 obj-$(CONFIG_PHY_MIXEL_MIPI_DPHY)	+= phy-fsl-imx8-mipi-dphy.o
 obj-$(CONFIG_PHY_FSL_IMX8M_PCIE)	+= phy-fsl-imx8m-pcie.o
+phy-fsl-lynx-10g-drv-y			+= phy-fsl-lynx-10g.o
+phy-fsl-lynx-10g-drv-y			+= phy-fsl-lynx-10g-clk.o
+obj-$(CONFIG_PHY_FSL_LYNX_10G)		+= phy-fsl-lynx-10g-drv.o
 obj-$(CONFIG_PHY_FSL_LYNX_28G)		+= phy-fsl-lynx-28g.o
diff --git a/drivers/phy/freescale/lynx-10g.h b/drivers/phy/freescale/lynx-10g.h
new file mode 100644
index 000000000000..882ab9da00bd
--- /dev/null
+++ b/drivers/phy/freescale/lynx-10g.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ */
+
+#ifndef LYNX_10G
+#define LYNX_10G
+
+struct device;
+struct regmap;
+
+#include <linux/clk-provider.h>
+
+/**
+ * struct lynx_clk - Driver data for the PLLs
+ * @pll: The PLL clock
+ * @ex_dly: The "PLLa_ex_dly_clk" clock
+ * @ref: Our reference clock
+ * @dev: The serdes device
+ * @regmap: Our registers
+ * @idx: Which PLL this clock is for
+ */
+struct lynx_clk {
+	struct clk_hw pll, ex_dly;
+	struct clk *ref;
+	struct device *dev;
+	struct regmap *regmap;
+	unsigned int idx;
+};
+
+void lynx_pll_disable(struct clk_hw *hw);
+
+int lynx_clks_init(struct lynx_clk clks[2], struct device *dev,
+		   struct regmap *regmap);
+
+#endif /* LYNX 10G */
diff --git a/drivers/phy/freescale/phy-fsl-lynx-10g-clk.c b/drivers/phy/freescale/phy-fsl-lynx-10g-clk.c
new file mode 100644
index 000000000000..dac5d2872a27
--- /dev/null
+++ b/drivers/phy/freescale/phy-fsl-lynx-10g-clk.c
@@ -0,0 +1,438 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ *
+ * This file contains the implementation for the PLLs found on Lynx 10G phys.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/device.h>
+#include <linux/math64.h>
+#include <linux/regmap.h>
+#include <linux/units.h>
+
+#include "lynx-10g.h"
+
+#define PLL_STRIDE	0x20
+#define PLLa(a, off)	((a) * PLL_STRIDE + (off))
+#define PLLaRSTCTL(a)	PLLa(a, 0x00)
+#define PLLaCR0(a)	PLLa(a, 0x04)
+
+#define PLLaRSTCTL_RSTREQ	BIT(31)
+#define PLLaRSTCTL_RST_DONE	BIT(30)
+#define PLLaRSTCTL_RST_ERR	BIT(29)
+#define PLLaRSTCTL_PLLRST_B	BIT(7)
+#define PLLaRSTCTL_SDRST_B	BIT(6)
+#define PLLaRSTCTL_SDEN		BIT(5)
+
+#define PLLaRSTCTL_ENABLE_SET	(PLLaRSTCTL_RST_DONE | PLLaRSTCTL_PLLRST_B | \
+				 PLLaRSTCTL_SDRST_B | PLLaRSTCTL_SDEN)
+#define PLLaRSTCTL_ENABLE_MASK	(PLLaRSTCTL_ENABLE_SET | PLLaRSTCTL_RST_ERR)
+
+#define PLLaCR0_POFF		BIT(31)
+#define PLLaCR0_RFCLK_SEL	GENMASK(30, 28)
+#define PLLaCR0_PLL_LCK		BIT(23)
+#define PLLaCR0_FRATE_SEL	GENMASK(19, 16)
+#define PLLaCR0_DLYDIV_SEL	GENMASK(1, 0)
+
+#define PLLaCR0_DLYDIV_SEL_16		0b01
+
+static u32 lynx_read(struct lynx_clk *clk, u32 reg)
+{
+	unsigned int ret = 0;
+
+	WARN_ON_ONCE(regmap_read(clk->regmap, reg, &ret));
+	return ret;
+}
+
+static void lynx_write(struct lynx_clk *clk, u32 val, u32 reg)
+{
+	WARN_ON_ONCE(regmap_write(clk->regmap, reg, val));
+}
+
+static struct lynx_clk *lynx_pll_to_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct lynx_clk, pll);
+}
+
+static struct lynx_clk *lynx_ex_dly_to_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct lynx_clk, ex_dly);
+}
+
+/* XXX: The output rate is in kHz to avoid overflow on 32-bit arches */
+
+void lynx_pll_disable(struct clk_hw *hw)
+{
+	struct lynx_clk *clk = lynx_pll_to_clk(hw);
+	u32 rstctl = lynx_read(clk, PLLaRSTCTL(clk->idx));
+
+	dev_dbg(clk->dev, "%s(pll%d)\n", __func__, clk->idx);
+
+	rstctl &= ~PLLaRSTCTL_SDRST_B;
+	lynx_write(clk, rstctl, PLLaRSTCTL(clk->idx));
+	ndelay(50);
+	rstctl &= ~(PLLaRSTCTL_SDEN | PLLaRSTCTL_PLLRST_B);
+	lynx_write(clk, rstctl, PLLaRSTCTL(clk->idx));
+	ndelay(100);
+}
+
+static int lynx_pll_prepare(struct clk_hw *hw)
+{
+	int ret;
+	struct lynx_clk *clk = lynx_pll_to_clk(hw);
+	u32 rstctl = lynx_read(clk, PLLaRSTCTL(clk->idx));
+
+	dev_dbg(clk->dev, "%s(pll%d) %.8x\n", __func__, clk->idx, rstctl);
+
+	/*
+	 * "Enabling" the PLL involves resetting it (and all attached lanes).
+	 * Avoid doing this if we are already enabled.
+	 */
+	if (clk_hw_is_enabled(hw))
+		return 0;
+
+	rstctl |= PLLaRSTCTL_RSTREQ;
+	lynx_write(clk, rstctl, PLLaRSTCTL(clk->idx));
+	/* Wait for the reset request to clear */
+	ret = read_poll_timeout(lynx_read, rstctl,
+				!(rstctl & PLLaRSTCTL_RSTREQ), 10, 1000, true,
+				clk, PLLaRSTCTL(clk->idx));
+	if (ret) {
+		dev_err(clk->dev,
+			"timed out waiting for reset request to clear\n");
+		return ret;
+	}
+
+	rstctl &= ~PLLaRSTCTL_RSTREQ;
+	rstctl |= PLLaRSTCTL_SDEN | PLLaRSTCTL_PLLRST_B | PLLaRSTCTL_SDRST_B;
+	lynx_write(clk, rstctl, PLLaRSTCTL(clk->idx));
+	ret = read_poll_timeout(lynx_read, rstctl,
+				rstctl & (PLLaRSTCTL_RST_DONE | PLLaRSTCTL_RST_ERR),
+				100, 5000, true, clk, PLLaRSTCTL(clk->idx));
+	if (ret) {
+		dev_err(clk->dev, "timed out waiting for lock\n");
+		return ret;
+	}
+	return rstctl & PLLaRSTCTL_RST_ERR ? -EIO : 0;
+}
+
+static int lynx_pll_is_enabled(struct clk_hw *hw)
+{
+	struct lynx_clk *clk = lynx_pll_to_clk(hw);
+	u32 rstctl = lynx_read(clk, PLLaRSTCTL(clk->idx));
+
+	dev_dbg(clk->dev, "%s(pll%d)\n", __func__, clk->idx);
+
+	return (rstctl & PLLaRSTCTL_ENABLE_MASK) == PLLaRSTCTL_ENABLE_SET;
+}
+
+static const u32 rfclk_sel_map[8] = {
+	[0b000] = 100000000,
+	[0b001] = 125000000,
+	[0b010] = 156250000,
+	[0b011] = 150000000,
+};
+
+/**
+ * lynx_rfclk_to_sel() - Convert a reference clock rate to a selector
+ * @rate: The reference clock rate
+ *
+ * To allow for some variation in the reference clock rate, up to 100ppm of
+ * error is allowed.
+ *
+ * Return: An appropriate selector for @rate, or -%EINVAL.
+ */
+static int lynx_rfclk_to_sel(u32 rate)
+{
+	int ret;
+
+	for (ret = 0; ret < ARRAY_SIZE(rfclk_sel_map); ret++) {
+		u32 rfclk_rate = rfclk_sel_map[ret];
+		/* Allow an error of 100ppm */
+		u32 error = rfclk_rate / 10000;
+
+		if (rate > rfclk_rate - error && rate < rfclk_rate + error)
+			return ret;
+	}
+
+	return -EINVAL;
+}
+
+static const u32 frate_sel_map[16] = {
+	[0b0000] = 5000000,
+	[0b0101] = 3750000,
+	[0b0110] = 5156250,
+	[0b0111] = 4000000,
+	[0b1001] = 3125000,
+	[0b1010] = 3000000,
+};
+
+/**
+ * lynx_frate_to_sel() - Convert a VCO clock rate to a selector
+ * @rate_khz: The VCO frequency, in kHz
+ *
+ * Return: An appropriate selector for @rate_khz, or -%EINVAL.
+ */
+static int lynx_frate_to_sel(u32 rate_khz)
+{
+	int ret;
+
+	for (ret = 0; ret < ARRAY_SIZE(frate_sel_map); ret++)
+		if (frate_sel_map[ret] == rate_khz)
+			return ret;
+
+	return -EINVAL;
+}
+
+static u32 lynx_pll_ratio(u32 frate_sel, u32 rfclk_sel)
+{
+	u64 frate;
+	u32 rfclk, error, ratio;
+
+	frate = frate_sel_map[frate_sel] * (u64)HZ_PER_KHZ;
+	rfclk = rfclk_sel_map[rfclk_sel];
+
+	if (!frate || !rfclk)
+		return 0;
+
+	ratio = div_u64_rem(frate, rfclk, &error);
+	if (!error)
+		return ratio;
+	return 0;
+}
+
+static unsigned long lynx_pll_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	struct lynx_clk *clk = lynx_pll_to_clk(hw);
+	u32 cr0 = lynx_read(clk, PLLaCR0(clk->idx));
+	u32 frate_sel = FIELD_GET(PLLaCR0_FRATE_SEL, cr0);
+	u32 rfclk_sel = FIELD_GET(PLLaCR0_RFCLK_SEL, cr0);
+	unsigned long ret;
+
+	dev_dbg(clk->dev, "%s(pll%d, %lu)\n", __func__,
+		clk->idx, parent_rate);
+
+	ret = mult_frac(parent_rate, lynx_pll_ratio(frate_sel, rfclk_sel),
+			 HZ_PER_KHZ);
+	return ret;
+}
+
+static long lynx_pll_round_rate(struct clk_hw *hw, unsigned long rate_khz,
+			      unsigned long *parent_rate)
+{
+	int frate_sel, rfclk_sel;
+	struct lynx_clk *clk = lynx_pll_to_clk(hw);
+	u32 ratio;
+
+	dev_dbg(clk->dev, "%s(pll%d, %lu, %lu)\n", __func__,
+		clk->idx, rate_khz, *parent_rate);
+
+	frate_sel = lynx_frate_to_sel(rate_khz);
+	if (frate_sel < 0)
+		return frate_sel;
+
+	rfclk_sel = lynx_rfclk_to_sel(*parent_rate);
+	if (rfclk_sel >= 0) {
+		ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio)
+			return mult_frac(*parent_rate, ratio, HZ_PER_KHZ);
+	}
+
+	for (rfclk_sel = 0;
+	     rfclk_sel < ARRAY_SIZE(rfclk_sel_map);
+	     rfclk_sel++) {
+		ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio) {
+			*parent_rate = rfclk_sel_map[rfclk_sel];
+			return mult_frac(*parent_rate, ratio, HZ_PER_KHZ);
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int lynx_pll_set_rate(struct clk_hw *hw, unsigned long rate_khz,
+			   unsigned long parent_rate)
+{
+	int frate_sel, rfclk_sel, ret;
+	struct lynx_clk *clk = lynx_pll_to_clk(hw);
+	u32 ratio, cr0 = lynx_read(clk, PLLaCR0(clk->idx));
+
+	dev_dbg(clk->dev, "%s(pll%d, %lu, %lu)\n", __func__,
+		clk->idx, rate_khz, parent_rate);
+
+	frate_sel = lynx_frate_to_sel(rate_khz);
+	if (frate_sel < 0)
+		return frate_sel;
+
+	/* First try the existing rate */
+	rfclk_sel = lynx_rfclk_to_sel(parent_rate);
+	if (rfclk_sel >= 0) {
+		ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio)
+			goto got_rfclk;
+	}
+
+	for (rfclk_sel = 0;
+	     rfclk_sel < ARRAY_SIZE(rfclk_sel_map);
+	     rfclk_sel++) {
+		ratio = lynx_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio) {
+			ret = clk_set_rate(clk->ref, rfclk_sel_map[rfclk_sel]);
+			if (!ret)
+				goto got_rfclk;
+		}
+	}
+
+	return ret;
+
+got_rfclk:
+	cr0 &= ~(PLLaCR0_RFCLK_SEL | PLLaCR0_FRATE_SEL);
+	cr0 |= FIELD_PREP(PLLaCR0_RFCLK_SEL, rfclk_sel);
+	cr0 |= FIELD_PREP(PLLaCR0_FRATE_SEL, frate_sel);
+	lynx_write(clk, cr0, PLLaCR0(clk->idx));
+	return 0;
+}
+
+static const struct clk_ops lynx_pll_clk_ops = {
+	.prepare = lynx_pll_prepare,
+	.disable = lynx_pll_disable,
+	.is_enabled = lynx_pll_is_enabled,
+	.recalc_rate = lynx_pll_recalc_rate,
+	.round_rate = lynx_pll_round_rate,
+	.set_rate = lynx_pll_set_rate,
+};
+
+static void lynx_ex_dly_disable(struct clk_hw *hw)
+{
+	struct lynx_clk *clk = lynx_ex_dly_to_clk(hw);
+	u32 cr0 = lynx_read(clk, PLLaCR0(clk->idx));
+
+	cr0 &= ~PLLaCR0_DLYDIV_SEL;
+	lynx_write(clk, PLLaCR0(clk->idx), cr0);
+}
+
+static int lynx_ex_dly_enable(struct clk_hw *hw)
+{
+	struct lynx_clk *clk = lynx_ex_dly_to_clk(hw);
+	u32 cr0 = lynx_read(clk, PLLaCR0(clk->idx));
+
+	cr0 &= ~PLLaCR0_DLYDIV_SEL;
+	cr0 |= FIELD_PREP(PLLaCR0_DLYDIV_SEL, PLLaCR0_DLYDIV_SEL_16);
+	lynx_write(clk, PLLaCR0(clk->idx), cr0);
+	return 0;
+}
+
+static int lynx_ex_dly_is_enabled(struct clk_hw *hw)
+{
+	struct lynx_clk *clk = lynx_ex_dly_to_clk(hw);
+
+	return lynx_read(clk, PLLaCR0(clk->idx)) & PLLaCR0_DLYDIV_SEL;
+}
+
+static unsigned long lynx_ex_dly_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	return parent_rate / 16;
+}
+
+static const struct clk_ops lynx_ex_dly_clk_ops = {
+	.enable = lynx_ex_dly_enable,
+	.disable = lynx_ex_dly_disable,
+	.is_enabled = lynx_ex_dly_is_enabled,
+	.recalc_rate = lynx_ex_dly_recalc_rate,
+};
+
+static int lynx_clk_init(struct lynx_clk *clk, struct device *dev,
+			 struct regmap *regmap, unsigned int index)
+{
+	const struct clk_hw *pll_parents, *ex_dly_parents;
+	struct clk_init_data pll_init = {
+		.ops = &lynx_pll_clk_ops,
+		.parent_hws = &pll_parents,
+		.num_parents = 1,
+		.flags = CLK_SET_RATE_GATE | CLK_GET_RATE_NOCACHE |
+			 CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
+	};
+	struct clk_init_data ex_dly_init = {
+		.ops = &lynx_ex_dly_clk_ops,
+		.parent_hws = &ex_dly_parents,
+		.num_parents = 1,
+	};
+	char *ref_name;
+	int ret;
+
+	clk->dev = dev;
+	clk->regmap = regmap;
+	clk->idx = index;
+
+	ref_name = kasprintf(GFP_KERNEL, "ref%d", index);
+	pll_init.name = kasprintf(GFP_KERNEL, "%s.pll%d", dev_name(dev), index);
+	ex_dly_init.name = kasprintf(GFP_KERNEL, "%s_ex_dly", pll_init.name);
+	if (!ref_name || !pll_init.name || !ex_dly_init.name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	clk->ref = devm_clk_get(dev, ref_name);
+	if (IS_ERR(clk->ref)) {
+		ret = PTR_ERR(clk->ref);
+		dev_err_probe(dev, ret, "could not get %s\n", ref_name);
+		goto out;
+	}
+
+	pll_parents = __clk_get_hw(clk->ref);
+	clk->pll.init = &pll_init;
+	ret = devm_clk_hw_register(dev, &clk->pll);
+	if (ret) {
+		dev_err_probe(dev, ret, "could not register %s\n",
+			      pll_init.name);
+		goto out;
+	}
+
+	ex_dly_parents = &clk->pll;
+	clk->ex_dly.init = &ex_dly_init;
+	ret = devm_clk_hw_register(dev, &clk->ex_dly);
+	if (ret)
+		dev_err_probe(dev, ret, "could not register %s\n",
+			      ex_dly_init.name);
+
+out:
+	kfree(ref_name);
+	kfree(pll_init.name);
+	kfree(ex_dly_init.name);
+	return ret;
+}
+
+static struct clk_hw *lynx_clk_get(struct of_phandle_args *clkspec, void *data)
+{
+	struct lynx_clk *clks = data;
+
+	if (clkspec->args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	if (clkspec->args[0] > 1)
+		return ERR_PTR(-EINVAL);
+
+	return &clks[clkspec->args[0]].pll;
+}
+
+int lynx_clks_init(struct lynx_clk clks[2], struct device *dev,
+		   struct regmap *regmap)
+{
+	int ret, i;
+
+	for (i = 0; i < 2; i++) {
+		ret = lynx_clk_init(&clks[i], dev, regmap, i);
+		if (ret)
+			return ret;
+	}
+
+	ret = devm_of_clk_add_hw_provider(dev, lynx_clk_get, clks);
+	if (ret)
+		dev_err_probe(dev, ret, "could not register clock provider\n");
+	return ret;
+}
diff --git a/drivers/phy/freescale/phy-fsl-lynx-10g.c b/drivers/phy/freescale/phy-fsl-lynx-10g.c
new file mode 100644
index 000000000000..675f919092f1
--- /dev/null
+++ b/drivers/phy/freescale/phy-fsl-lynx-10g.c
@@ -0,0 +1,1297 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ *
+ * This driver is for the Lynx 10G phys found on many QorIQ devices, including
+ * the Layerscape series.
+ */
+
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/phy.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+
+#include "lynx-10g.h"
+
+#define PCCR_BASE	0x200
+#define PCCR_STRIDE	0x4
+#define PCCRn(n)	(PCCR_BASE + n * PCCR_STRIDE)
+
+#define PCCR0_PEXa_MASK		GENMASK(2, 0)
+#define PCCR0_PEXa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCR2_SATAa_MASK	GENMASK(2, 0)
+#define PCCR2_SATAa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCR8_SGMIIa_KX		BIT(3)
+#define PCCR8_SGMIIa_MASK	GENMASK(3, 0)
+#define PCCR8_SGMIIa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCR9_QSGMIIa_MASK	GENMASK(2, 0)
+#define PCCR9_QSGMIIa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCRB_XFIa_MASK		GENMASK(2, 0)
+#define PCCRB_XFIa_SHIFT(a)	(28 - (a) * 4)
+
+#define LANE_BASE	0x800
+#define LANE_STRIDE	0x40
+#define LNm(m, off)	(LANE_BASE + (m) * LANE_STRIDE + (off))
+#define LNmGCR0(m)	LNm(m, 0x00)
+#define LNmGCR1(m)	LNm(m, 0x04)
+#define LNmSSCR0(m)	LNm(m, 0x0C)
+#define LNmRECR0(m)	LNm(m, 0x10)
+#define LNmRECR1(m)	LNm(m, 0x14)
+#define LNmTECR0(m)	LNm(m, 0x18)
+#define LNmSSCR1(m)	LNm(m, 0x1C)
+#define LNmTTLCR0(m)	LNm(m, 0x20)
+
+#define LNmGCR0_RPLL_LES	BIT(31)
+#define LNmGCR0_RRAT_SEL	GENMASK(29, 28)
+#define LNmGCR0_TPLL_LES	BIT(27)
+#define LNmGCR0_TRAT_SEL	GENMASK(25, 24)
+#define LNmGCR0_RRST_B		BIT(22)
+#define LNmGCR0_TRST_B		BIT(21)
+#define LNmGCR0_RX_PD		BIT(20)
+#define LNmGCR0_TX_PD		BIT(19)
+#define LNmGCR0_IF20BIT_EN	BIT(18)
+#define LNmGCR0_FIRST_LANE	BIT(16)
+#define LNmGCR0_TTRM_VM_SEL	GENMASK(13, 12)
+#define LNmGCR0_PROTS		GENMASK(11, 7)
+
+#define LNmGCR0_RAT_SEL_SAME		0b00
+#define LNmGCR0_RAT_SEL_HALF		0b01
+#define LNmGCR0_RAT_SEL_QUARTER		0b10
+#define LNmGCR0_RAT_SEL_DOUBLE		0b11
+
+#define LNmGCR0_PROTS_PCIE		0b00000
+#define LNmGCR0_PROTS_SGMII		0b00001
+#define LNmGCR0_PROTS_SATA		0b00010
+#define LNmGCR0_PROTS_XFI		0b01010
+
+#define LNmGCR1_RDAT_INV	BIT(31)
+#define LNmGCR1_TDAT_INV	BIT(30)
+#define LNmGCR1_OPAD_CTL	BIT(26)
+#define LNmGCR1_REIDL_TH	GENMASK(22, 20)
+#define LNmGCR1_REIDL_EX_SEL	GENMASK(19, 18)
+#define LNmGCR1_REIDL_ET_SEL	GENMASK(17, 16)
+#define LNmGCR1_REIDL_EX_MSB	BIT(15)
+#define LNmGCR1_REIDL_ET_MSB	BIT(14)
+#define LNmGCR1_REQ_CTL_SNP	BIT(13)
+#define LNmGCR1_REQ_CDR_SNP	BIT(12)
+#define LNmGCR1_TRSTDIR		BIT(7)
+#define LNmGCR1_REQ_BIN_SNP	BIT(6)
+#define LNmGCR1_ISLEW_RCTL	GENMASK(5, 4)
+#define LNmGCR1_OSLEW_RCTL	GENMASK(1, 0)
+
+#define LNmRECR0_RXEQ_BST	BIT(28)
+#define LNmRECR0_GK2OVD		GENMASK(27, 24)
+#define LNmRECR0_GK3OVD		GENMASK(19, 16)
+#define LNmRECR0_GK2OVD_EN	BIT(15)
+#define LNmRECR0_GK3OVD_EN	BIT(14)
+#define LNmRECR0_OSETOVD_EN	BIT(13)
+#define LNmRECR0_BASE_WAND	GENMASK(11, 10)
+#define LNmRECR0_OSETOVD	GENMASK(6, 0)
+
+#define LNmRECR0_BASE_WAND_OFF		0b00
+#define LNmRECR0_BASE_WAND_DEFAULT	0b01
+#define LNmRECR0_BASE_WAND_ALTERNATE	0b10
+#define LNmRECR0_BASE_WAND_OSETOVD	0b11
+
+#define LNmTECR0_TEQ_TYPE	GENMASK(29, 28)
+#define LNmTECR0_SGN_PREQ	BIT(26)
+#define LNmTECR0_RATIO_PREQ	GENMASK(25, 22)
+#define LNmTECR0_SGN_POST1Q	BIT(21)
+#define LNmTECR0_RATIO_PST1Q	GENMASK(20, 16)
+#define LNmTECR0_ADPT_EQ	GENMASK(13, 8)
+#define LNmTECR0_AMP_RED	GENMASK(5, 0)
+
+#define LNmTECR0_TEQ_TYPE_NONE		0b00
+#define LNmTECR0_TEQ_TYPE_PRE		0b01
+#define LNmTECR0_TEQ_TYPE_BOTH		0b10
+
+#define LNmTTLCR0_FLT_SEL	GENMASK(29, 24)
+
+#define PCS_STRIDE	0x10
+#define CR_STRIDE	0x4
+#define PCSa(a, base, cr)	(base + (a) * PCS_STRIDE + (cr) * CR_STRIDE)
+
+#define PCSaCR1_MDEV_PORT	GENMASK(31, 27)
+
+#define SGMII_BASE	0x1800
+#define SGMIIaCR1(a)	PCSa(a, SGMII_BASE, 1)
+
+#define SGMIIaCR1_SGPCS_EN	BIT(11)
+
+#define QSGMII_OFFSET	0x1880
+#define QSGMIIaCR1(a)	PCSa(a, QSGMII_BASE, 1)
+
+#define XFI_OFFSET	0x1980
+#define XFIaCR1(a)	PCSa(a, XFI_BASE, 1)
+
+enum lynx_protocol {
+	LYNX_PROTO_NONE = 0,
+	LYNX_PROTO_SGMII,
+	LYNX_PROTO_SGMII25, /* Not tested */
+	LYNX_PROTO_1000BASEKX, /* Not tested */
+	LYNX_PROTO_QSGMII, /* Not tested */
+	LYNX_PROTO_XFI,
+	LYNX_PROTO_10GKR, /* Link training unimplemented */
+	LYNX_PROTO_PCIE, /* Not implemented */
+	LYNX_PROTO_SATA, /* Not implemented */
+	LYNX_PROTO_LAST,
+};
+
+static const char lynx_proto_str[][16] = {
+	[LYNX_PROTO_NONE] = "unknown",
+	[LYNX_PROTO_SGMII] = "SGMII",
+	[LYNX_PROTO_SGMII25] = "2.5G SGMII",
+	[LYNX_PROTO_1000BASEKX] = "1000BASE-KX",
+	[LYNX_PROTO_QSGMII] = "QSGMII",
+	[LYNX_PROTO_XFI] = "XFI",
+	[LYNX_PROTO_10GKR] = "10GBASE-KR",
+	[LYNX_PROTO_PCIE] = "PCIe",
+	[LYNX_PROTO_SATA] = "SATA",
+};
+
+#define PROTO_MASK(proto) BIT(LYNX_PROTO_##proto)
+#define UNSUPPORTED_PROTOS (PROTO_MASK(SATA) | PROTO_MASK(PCIE))
+
+/**
+ * struct lynx_proto_params - Parameters for configuring a protocol
+ * @frate_khz: The PLL rate, in kHz
+ * @rat_sel: The divider to get the line rate
+ * @if20bit: Whether the proto is 20 bits or 10 bits
+ * @prots: Lane protocol select
+ * @reidl_th: Receiver electrical idle detection threshold
+ * @reidl_ex: Exit electrical idle filter
+ * @reidl_et: Enter idle filter
+ * @slew: Slew control
+ * @baseline_wander: Enable baseline wander correction
+ * @gain: Adaptive equalization gain override
+ * @offset_override: Adaptive equalization offset override
+ * @teq: Transmit equalization type (none, precursor, or precursor and
+ *       postcursor). The next few values are only used for appropriate
+ *       equalization types.
+ * @preq_ratio: Ratio of full swing transition bit to pre-cursor
+ * @postq_ratio: Ratio of full swing transition bit to first post-cursor.
+ * @adpt_eq: Transmitter Adjustments for 8G/10G
+ * @amp_red: Overall TX Amplitude Reduction
+ * @flt_sel: TTL configuration selector
+ */
+struct lynx_proto_params {
+	u32 frate_khz;
+	u8 rat_sel;
+	u8 prots;
+	u8 reidl_th;
+	u8 reidl_ex;
+	u8 reidl_et;
+	u8 slew;
+	u8 gain;
+	u8 baseline_wander;
+	u8 offset_override;
+	u8 teq;
+	u8 preq_ratio;
+	u8 postq_ratio;
+	u8 adpt_eq;
+	u8 amp_red;
+	u8 flt_sel;
+	bool if20bit;
+};
+
+static const struct lynx_proto_params lynx_proto_params[] = {
+	[LYNX_PROTO_SGMII] = {
+		.frate_khz = 5000000,
+		.rat_sel = LNmGCR0_RAT_SEL_QUARTER,
+		.if20bit = false,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.reidl_th = 0b001,
+		.reidl_ex = 0b011,
+		.reidl_et = 0b100,
+		.slew = 0b01,
+		.gain = 0b1111,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_NONE,
+		.adpt_eq = 0b110000,
+		.amp_red = 0b000110,
+		.flt_sel = 0b111001,
+	},
+	[LYNX_PROTO_1000BASEKX] = {
+		.frate_khz = 5000000,
+		.rat_sel = LNmGCR0_RAT_SEL_QUARTER,
+		.if20bit = false,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.slew = 0b01,
+		.gain = 0b1111,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_NONE,
+		.adpt_eq = 0b110000,
+		.flt_sel = 0b111001,
+	},
+	[LYNX_PROTO_SGMII25] = {
+		.frate_khz = 3125000,
+		.rat_sel = LNmGCR0_RAT_SEL_SAME,
+		.if20bit = false,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.slew = 0b10,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_PRE,
+		.postq_ratio = 0b00110,
+		.adpt_eq = 0b110000,
+	},
+	[LYNX_PROTO_QSGMII] = {
+		.frate_khz = 5000000,
+		.rat_sel = LNmGCR0_RAT_SEL_SAME,
+		.if20bit = true,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.slew = 0b01,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_PRE,
+		.postq_ratio = 0b00110,
+		.adpt_eq = 0b110000,
+		.amp_red = 0b000010,
+	},
+	[LYNX_PROTO_XFI] = {
+		.frate_khz = 5156250,
+		.rat_sel = LNmGCR0_RAT_SEL_DOUBLE,
+		.if20bit = true,
+		.prots = LNmGCR0_PROTS_XFI,
+		.slew = 0b01,
+		.baseline_wander = LNmRECR0_BASE_WAND_DEFAULT,
+		.offset_override = 0b1011111,
+		.teq = LNmTECR0_TEQ_TYPE_PRE,
+		.postq_ratio = 0b00011,
+		.adpt_eq = 0b110000,
+		.amp_red = 0b000111,
+	},
+	[LYNX_PROTO_10GKR] = {
+		.frate_khz = 5156250,
+		.rat_sel = LNmGCR0_RAT_SEL_DOUBLE,
+		.prots = LNmGCR0_PROTS_XFI,
+		.slew = 0b01,
+		.baseline_wander = LNmRECR0_BASE_WAND_DEFAULT,
+		.offset_override = 0b1011111,
+		.teq = LNmTECR0_TEQ_TYPE_BOTH,
+		.preq_ratio = 0b0011,
+		.postq_ratio = 0b01100,
+		.adpt_eq = 0b110000,
+	},
+};
+
+/**
+ * struct lynx_mode - A single configuration of a protocol controller
+ * @protos: A bitmask of the &enum lynx_protocol this mode supports
+ * @first_lane: the first lane which will be used when this config is selected
+ * @last_lane: the last lane which will be used when this config is selected
+ * @pccr: The number of the PCCR which contains this mode
+ * @idx: The index of the protocol controller. For example, SGMIIB would have
+ *       index 1.
+ * @cfg: The value to program into the controller to select this mode
+ *
+ * The serdes has multiple protocol controllers which can be each be selected
+ * independently. Depending on their configuration, they may use multiple lanes
+ * at once (e.g. AUI or PCIe x4). Additionally, multiple protocols may be
+ * supported by a single mode (XFI and 10GKR differ only in their protocol
+ * parameters).
+ */
+struct lynx_mode {
+	u16 protos;
+	u8 first_lane;
+	u8 last_lane;
+	u8 pccr;
+	u8 idx;
+	u8 cfg;
+};
+
+static_assert(LYNX_PROTO_LAST - 1 <=
+	      sizeof_field(struct lynx_mode, protos) * BITS_PER_BYTE);
+
+/**
+ * enum lynx_caps - serdes hardware capabilities
+ * @LYNX_HAS_1000BASEKX: 1000BASE-KX supported
+ * @LYNX_HAS_10GKR: 10GBASE-KR supported
+ */
+enum lynx_caps {
+	LYNX_HAS_1000BASEKX,
+	LYNX_HAS_10GKR,
+};
+
+/**
+ * struct lynx_conf - Configuration for a particular serdes
+ * @lanes: Number of lanes
+ * @caps: A bitmask of &enum lynx_caps
+ * @endian: Endianness of the registers
+ */
+struct lynx_conf {
+	unsigned int lanes;
+	unsigned int caps;
+	enum regmap_endian endian;
+};
+
+struct lynx_priv;
+
+/**
+ * struct lynx_priv - Driver data for the serdes
+ * @lock: A lock protecting "common" registers in @regmap, as well as the
+ *        members of this struct. Lane-specific registers are protected by the
+ *        phy's lock. PLL registers are protected by the clock's lock.
+ * @clks: The PLL clocks
+ * @dev: The serdes device
+ * @regmap: The backing regmap
+ * @conf: The configuration for this serdes
+ * @modes: Valid protocol controller configurations
+ * @mode_count: Number of modes in @modes
+ * @used_lanes: Bitmap of the lanes currently used by phys
+ * @groups: List of the created groups
+ */
+struct lynx_priv {
+	struct mutex lock;
+	struct lynx_clk clks[2];
+	struct device *dev;
+	struct regmap *regmap;
+	const struct lynx_conf *conf;
+	const struct lynx_mode *modes;
+	size_t mode_count;
+	unsigned int used_lanes;
+	struct list_head groups;
+};
+
+/**
+ * struct lynx_group - Driver data for a group of lanes
+ * @groups: List of other groups; protected by @serdes->lock.
+ * @phy: The associated phy
+ * @serdes: The parent serdes
+ * @pll: The currently-used pll
+ * @ex_dly: The ex_dly clock, if used
+ * @first_lane: The first lane in the group
+ * @last_lane: The last lane in the group
+ * @proto: The currently-configured protocol
+ * @users: Number of current users; protected by @serdes->lock.
+ */
+struct lynx_group {
+	struct list_head groups;
+	struct phy *phy;
+	struct lynx_priv *serdes;
+	struct clk *pll;
+	struct clk *ex_dly;
+	unsigned int first_lane;
+	unsigned int last_lane;
+	enum lynx_protocol proto;
+	unsigned int users;
+};
+
+static u32 lynx_read(struct lynx_priv *serdes, u32 reg)
+{
+	unsigned int ret = 0;
+
+	WARN_ON_ONCE(regmap_read(serdes->regmap, reg, &ret));
+	return ret;
+}
+
+static void lynx_write(struct lynx_priv *serdes, u32 val, u32 reg)
+{
+	WARN_ON_ONCE(regmap_write(serdes->regmap, reg, val));
+}
+
+/**
+ * lynx_lane_bitmap() - Get a bitmap for a group of lanes
+ * @group: The group of lanes
+ *
+ * Return: A mask containing all bits between @group->first and @group->last
+ */
+static unsigned int lynx_lane_bitmap(struct lynx_group *group)
+{
+	if (group->first_lane > group->last_lane)
+		return GENMASK(group->first_lane, group->last_lane);
+	else
+		return GENMASK(group->last_lane, group->first_lane);
+}
+
+static int lynx_init(struct phy *phy)
+{
+	int ret = 0;
+	struct lynx_group *group = phy_get_drvdata(phy);
+	struct lynx_priv *serdes = group->serdes;
+	unsigned int lane_mask = lynx_lane_bitmap(group);
+
+	mutex_lock(&serdes->lock);
+	if (serdes->used_lanes & lane_mask)
+		ret = -EBUSY;
+	else
+		serdes->used_lanes |= lane_mask;
+	mutex_unlock(&serdes->lock);
+	return ret;
+}
+
+static int lynx_exit(struct phy *phy)
+{
+	struct lynx_group *group = phy_get_drvdata(phy);
+	struct lynx_priv *serdes = group->serdes;
+
+	clk_disable_unprepare(group->ex_dly);
+	group->ex_dly = NULL;
+
+	clk_disable_unprepare(group->pll);
+	clk_rate_exclusive_put(group->pll);
+	group->pll = NULL;
+
+	mutex_lock(&serdes->lock);
+	serdes->used_lanes &= ~lynx_lane_bitmap(group);
+	mutex_unlock(&serdes->lock);
+	return 0;
+}
+
+/*
+ * This is tricky. If first_lane=1 and last_lane=0, the condition will see 2,
+ * 1, 0. But the loop body will see 1, 0. We do this to avoid underflow. We
+ * can't pull the same trick when incrementing, because then we might have to
+ * start at -1 if (e.g.) first_lane = 0.
+ */
+#define for_range(val, start, end) \
+	for (val = start < end ? start : start + 1; \
+	     start < end ? val <= end : val-- > end; \
+	     start < end ? val++ : 0)
+#define for_each_lane(lane, group) \
+	for_range(lane, group->first_lane, group->last_lane)
+#define for_each_lane_reverse(lane, group) \
+	for_range(lane, group->last_lane, group->first_lane)
+
+static int lynx_power_on(struct phy *phy)
+{
+	int i;
+	struct lynx_group *group = phy_get_drvdata(phy);
+	u32 gcr0;
+
+	for_each_lane(i, group) {
+		gcr0 = lynx_read(group->serdes, LNmGCR0(i));
+		gcr0 &= ~(LNmGCR0_RX_PD | LNmGCR0_TX_PD);
+		lynx_write(group->serdes, gcr0, LNmGCR0(i));
+
+		usleep_range(15, 30);
+		gcr0 |= LNmGCR0_RRST_B | LNmGCR0_TRST_B;
+		lynx_write(group->serdes, gcr0, LNmGCR0(i));
+	}
+
+	return 0;
+}
+
+static void lynx_power_off_lane(struct lynx_priv *serdes, unsigned int lane)
+{
+	u32 gcr0 = lynx_read(serdes, LNmGCR0(lane));
+
+	gcr0 |= LNmGCR0_RX_PD | LNmGCR0_TX_PD;
+	gcr0 &= ~(LNmGCR0_RRST_B | LNmGCR0_TRST_B);
+	lynx_write(serdes, gcr0, LNmGCR0(lane));
+}
+
+static int lynx_power_off(struct phy *phy)
+{
+	unsigned int i;
+	struct lynx_group *group = phy_get_drvdata(phy);
+
+	for_each_lane_reverse(i, group)
+		lynx_power_off_lane(group->serdes, i);
+
+	return 0;
+}
+
+/**
+ * lynx_lookup_proto() - Convert a phy-subsystem mode to a protocol
+ * @mode: The mode to convert
+ * @submode: The submode of @mode
+ *
+ * Return: A corresponding serdes-specific mode
+ */
+static enum lynx_protocol lynx_lookup_proto(enum phy_mode mode, int submode)
+{
+	switch (mode) {
+	case PHY_MODE_ETHERNET:
+		switch (submode) {
+		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_1000BASEX:
+			return LYNX_PROTO_SGMII;
+		case PHY_INTERFACE_MODE_1000BASEKX:
+			return LYNX_PROTO_1000BASEKX;
+		case PHY_INTERFACE_MODE_2500BASEX:
+			return LYNX_PROTO_SGMII25;
+		case PHY_INTERFACE_MODE_QSGMII:
+			return LYNX_PROTO_QSGMII;
+		case PHY_INTERFACE_MODE_XGMII:
+		case PHY_INTERFACE_MODE_10GBASER:
+			return LYNX_PROTO_XFI;
+		case PHY_INTERFACE_MODE_10GKR:
+			return LYNX_PROTO_10GKR;
+		default:
+			return LYNX_PROTO_NONE;
+		}
+	/* Not implemented (yet) */
+	case PHY_MODE_PCIE:
+	case PHY_MODE_SATA:
+	default:
+		return LYNX_PROTO_NONE;
+	}
+}
+
+/**
+ * lynx_lookup_mode() - Get the mode for a group/protocol combination
+ * @group: The group of lanes to use
+ * @proto: The protocol to use
+ *
+ * Return: An appropriate mode to use, or %NULL if none match.
+ */
+static const struct lynx_mode *lynx_lookup_mode(struct lynx_group *group,
+					    enum lynx_protocol proto)
+{
+	int i;
+	const struct lynx_priv *serdes = group->serdes;
+
+	for (i = 0; i < serdes->mode_count; i++) {
+		const struct lynx_mode *mode = &serdes->modes[i];
+
+		if (BIT(proto) & mode->protos &&
+		    group->first_lane == mode->first_lane &&
+		    group->last_lane == mode->last_lane)
+			return mode;
+	}
+
+	return NULL;
+}
+
+static int lynx_validate(struct phy *phy, enum phy_mode phy_mode, int submode,
+		       union phy_configure_opts *opts)
+{
+	enum lynx_protocol proto;
+	struct lynx_group *group = phy_get_drvdata(phy);
+	const struct lynx_mode *mode;
+
+	proto = lynx_lookup_proto(phy_mode, submode);
+	if (proto == LYNX_PROTO_NONE)
+		return -EINVAL;
+
+	/* Nothing to do */
+	if (proto == group->proto)
+		return 0;
+
+	mode = lynx_lookup_mode(group, proto);
+	if (!mode)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * lynx_proto_mode_mask() - Get the mask for a PCCR config
+ * @mode: The mode to use
+ *
+ * Return: The mask, shifted down to the lsb.
+ */
+static u32 lynx_proto_mode_mask(const struct lynx_mode *mode)
+{
+	switch (mode->pccr) {
+	case 0x0:
+		if (mode->protos & PROTO_MASK(PCIE))
+			return PCCR0_PEXa_MASK;
+		break;
+	case 0x2:
+		if (mode->protos & PROTO_MASK(SATA))
+			return PCCR2_SATAa_MASK;
+		break;
+	case 0x8:
+		if (mode->protos & PROTO_MASK(SGMII))
+			return PCCR8_SGMIIa_MASK;
+		break;
+	case 0x9:
+		if (mode->protos & PROTO_MASK(QSGMII))
+			return PCCR9_QSGMIIa_MASK;
+		break;
+	case 0xB:
+		if (mode->protos & PROTO_MASK(XFI))
+			return PCCRB_XFIa_MASK;
+		break;
+	}
+	pr_err("unknown mode PCCR%X %s%c\n", mode->pccr,
+	       lynx_proto_str[mode->protos], 'A' + mode->idx);
+	return 0;
+}
+
+/**
+ * lynx_proto_mode_shift() - Get the shift for a PCCR config
+ * @mode: The mode to use
+ *
+ * Return: The amount of bits to shift the mask.
+ */
+static u32 lynx_proto_mode_shift(const struct lynx_mode *mode)
+{
+	switch (mode->pccr) {
+	case 0x0:
+		if (mode->protos & PROTO_MASK(PCIE))
+			return PCCR0_PEXa_SHIFT(mode->idx);
+		break;
+	case 0x2:
+		if (mode->protos & PROTO_MASK(SATA))
+			return PCCR2_SATAa_SHIFT(mode->idx);
+		break;
+	case 0x8:
+		if (mode->protos & PROTO_MASK(SGMII))
+			return PCCR8_SGMIIa_SHIFT(mode->idx);
+		break;
+	case 0x9:
+		if (mode->protos & PROTO_MASK(QSGMII))
+			return PCCR9_QSGMIIa_SHIFT(mode->idx);
+		break;
+	case 0xB:
+		if (mode->protos & PROTO_MASK(XFI))
+			return PCCRB_XFIa_SHIFT(mode->idx);
+		break;
+	}
+	pr_err("unknown mode PCCR%X %s%c\n", mode->pccr,
+	       lynx_proto_str[mode->protos], 'A' + mode->idx);
+	return 0;
+}
+
+/**
+ * lynx_proto_mode_get() - Get the current config for a PCCR mode
+ * @mode: The mode to use
+ * @pccr: The current value of the PCCR
+ *
+ * Return: The current value of the PCCR config for this mode
+ */
+static u32 lynx_proto_mode_get(const struct lynx_mode *mode, u32 pccr)
+{
+	return (pccr >> lynx_proto_mode_shift(mode)) &
+	       lynx_proto_mode_mask(mode);
+}
+
+/**
+ * lynx_proto_mode_prep() - Configure a PCCR for a protocol
+ * @mode: The mode to use
+ * @pccr: The current value of the PCCR
+ * @proto: The protocol to configure
+ *
+ * This configures a PCCR for a mode and protocol. To disable a mode, pass
+ * %LYNX_PROTO_NONE as @proto. If @proto is 1000BASE-KX, then the KX bit
+ * will be set.
+ *
+ * Return: The new value for the PCCR
+ */
+static u32 lynx_proto_mode_prep(const struct lynx_mode *mode, u32 pccr,
+				enum lynx_protocol proto)
+{
+	u32 shift = lynx_proto_mode_shift(mode);
+
+	pccr &= ~(lynx_proto_mode_mask(mode) << shift);
+	if (proto != LYNX_PROTO_NONE)
+		pccr |= mode->cfg << shift;
+
+	if (proto == LYNX_PROTO_1000BASEKX) {
+		if (mode->pccr == 8)
+			pccr |= PCCR8_SGMIIa_KX << shift;
+		else
+			pr_err("PCCR%X doesn't have a KX bit\n", mode->pccr);
+	}
+
+	return pccr;
+}
+
+#define abs_diff(a, b) ({ \
+	typeof(a) _a = (a); \
+	typeof(b) _b = (b); \
+	_a > _b ? _a - _b : _b - _a; \
+})
+
+static int lynx_set_mode(struct phy *phy, enum phy_mode phy_mode, int submode)
+{
+	enum lynx_protocol proto;
+	const struct lynx_proto_params *params;
+	const struct lynx_mode *old_mode = NULL, *new_mode;
+	int i, pll, ret;
+	struct lynx_group *group = phy_get_drvdata(phy);
+	struct lynx_priv *serdes = group->serdes;
+	u32 tmp;
+	u32 gcr0 = 0, gcr1 = 0, recr0 = 0, tecr0 = 0;
+	u32 gcr0_mask = 0, gcr1_mask = 0, recr0_mask = 0, tecr0_mask = 0;
+
+	proto = lynx_lookup_proto(phy_mode, submode);
+	if (proto == LYNX_PROTO_NONE) {
+		dev_dbg(&phy->dev, "unknown mode/submode %d/%d\n",
+			phy_mode, submode);
+		return -EINVAL;
+	}
+
+	/* Nothing to do */
+	if (proto == group->proto)
+		return 0;
+
+	new_mode = lynx_lookup_mode(group, proto);
+	if (!new_mode) {
+		dev_dbg(&phy->dev, "could not find mode for %s on lanes %u to %u\n",
+			lynx_proto_str[proto], group->first_lane,
+			group->last_lane);
+		return -EINVAL;
+	}
+
+	if (group->proto != LYNX_PROTO_NONE) {
+		old_mode = lynx_lookup_mode(group, group->proto);
+		if (!old_mode) {
+			dev_err(&phy->dev, "could not find mode for %s\n",
+				lynx_proto_str[group->proto]);
+			return -EBUSY;
+		}
+	}
+
+	mutex_lock(&serdes->lock);
+
+	tmp = lynx_read(serdes, PCCRn(new_mode->pccr));
+	if (lynx_proto_mode_get(new_mode, tmp)) {
+		mutex_unlock(&serdes->lock);
+		dev_dbg(&phy->dev, "%s%c already in use\n",
+			lynx_proto_str[new_mode->protos], 'A' + new_mode->idx);
+		return -EBUSY;
+	}
+
+	/* Disable the old controller */
+	if (old_mode) {
+		tmp = lynx_read(serdes, PCCRn(old_mode->pccr));
+		tmp = lynx_proto_mode_prep(old_mode, tmp, LYNX_PROTO_NONE);
+		lynx_write(serdes, tmp, PCCRn(old_mode->pccr));
+
+		if (old_mode->protos & PROTO_MASK(SGMII)) {
+			tmp = lynx_read(serdes, SGMIIaCR1(old_mode->idx));
+			tmp &= SGMIIaCR1_SGPCS_EN;
+			lynx_write(serdes, tmp, SGMIIaCR1(old_mode->idx));
+		}
+	}
+	group->proto = LYNX_PROTO_NONE;
+
+	clk_disable_unprepare(group->ex_dly);
+	group->ex_dly = NULL;
+
+	clk_disable_unprepare(group->pll);
+	clk_rate_exclusive_put(group->pll);
+	group->pll = NULL;
+
+	/* First, try to use a PLL which already has the correct rate */
+	params = &lynx_proto_params[proto];
+	for (pll = 0; pll < ARRAY_SIZE(serdes->clks); pll++) {
+		struct clk *clk = serdes->clks[pll].pll.clk;
+		unsigned long rate = clk_get_rate(clk);
+		unsigned long error = abs_diff(rate, params->frate_khz);
+
+		dev_dbg(&phy->dev, "pll%d has rate %lu\n", pll, rate);
+		/* Accept up to 100ppm deviation */
+		if ((!error || params->frate_khz / error > 10000) &&
+		    !clk_set_rate_exclusive(clk, rate))
+			goto got_pll;
+		/* Someone else got a different rate first */
+	}
+
+	/* If neither PLL has the right rate, try setting it */
+	for (pll = 0; pll < 2; pll++) {
+		ret = clk_set_rate_exclusive(serdes->clks[pll].pll.clk,
+					     params->frate_khz);
+		if (!ret)
+			goto got_pll;
+	}
+
+	dev_dbg(&phy->dev, "could not get a pll at %ukHz\n",
+		params->frate_khz);
+	return ret;
+
+got_pll:
+	group->pll = serdes->clks[pll].pll.clk;
+	clk_prepare_enable(group->pll);
+
+	gcr0_mask |= LNmGCR0_RRAT_SEL | LNmGCR0_TRAT_SEL;
+	gcr0_mask |= LNmGCR0_RPLL_LES | LNmGCR0_TPLL_LES;
+	gcr0_mask |= LNmGCR0_RRST_B | LNmGCR0_TRST_B;
+	gcr0_mask |= LNmGCR0_RX_PD | LNmGCR0_TX_PD;
+	gcr0_mask |= LNmGCR0_IF20BIT_EN | LNmGCR0_PROTS;
+	gcr0 |= FIELD_PREP(LNmGCR0_RPLL_LES, !pll);
+	gcr0 |= FIELD_PREP(LNmGCR0_TPLL_LES, !pll);
+	gcr0 |= FIELD_PREP(LNmGCR0_RRAT_SEL, params->rat_sel);
+	gcr0 |= FIELD_PREP(LNmGCR0_TRAT_SEL, params->rat_sel);
+	gcr0 |= FIELD_PREP(LNmGCR0_IF20BIT_EN, params->if20bit);
+	gcr0 |= FIELD_PREP(LNmGCR0_PROTS, params->prots);
+
+	gcr1_mask |= LNmGCR1_RDAT_INV | LNmGCR1_TDAT_INV;
+	gcr1_mask |= LNmGCR1_OPAD_CTL | LNmGCR1_REIDL_TH;
+	gcr1_mask |= LNmGCR1_REIDL_EX_SEL | LNmGCR1_REIDL_ET_SEL;
+	gcr1_mask |= LNmGCR1_REIDL_EX_MSB | LNmGCR1_REIDL_ET_MSB;
+	gcr1_mask |= LNmGCR1_REQ_CTL_SNP | LNmGCR1_REQ_CDR_SNP;
+	gcr1_mask |= LNmGCR1_TRSTDIR | LNmGCR1_REQ_BIN_SNP;
+	gcr1_mask |= LNmGCR1_ISLEW_RCTL | LNmGCR1_OSLEW_RCTL;
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_TH, params->reidl_th);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_EX_SEL, params->reidl_ex & 3);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_ET_SEL, params->reidl_et & 3);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_EX_MSB, params->reidl_ex >> 2);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_ET_MSB, params->reidl_et >> 2);
+	gcr1 |= FIELD_PREP(LNmGCR1_TRSTDIR,
+			   group->first_lane > group->last_lane);
+	gcr1 |= FIELD_PREP(LNmGCR1_ISLEW_RCTL, params->slew);
+	gcr1 |= FIELD_PREP(LNmGCR1_OSLEW_RCTL, params->slew);
+
+	recr0_mask |= LNmRECR0_RXEQ_BST | LNmRECR0_BASE_WAND;
+	recr0_mask |= LNmRECR0_GK2OVD | LNmRECR0_GK3OVD;
+	recr0_mask |= LNmRECR0_GK2OVD_EN | LNmRECR0_GK3OVD_EN;
+	recr0_mask |= LNmRECR0_OSETOVD_EN | LNmRECR0_OSETOVD;
+	if (params->gain) {
+		recr0 |= FIELD_PREP(LNmRECR0_GK2OVD, params->gain);
+		recr0 |= FIELD_PREP(LNmRECR0_GK3OVD, params->gain);
+		recr0 |= LNmRECR0_GK2OVD_EN | LNmRECR0_GK3OVD_EN;
+	}
+	recr0 |= FIELD_PREP(LNmRECR0_BASE_WAND, params->baseline_wander);
+	recr0 |= FIELD_PREP(LNmRECR0_OSETOVD, params->offset_override);
+
+	tecr0_mask |= LNmTECR0_TEQ_TYPE;
+	tecr0_mask |= LNmTECR0_SGN_PREQ | LNmTECR0_RATIO_PREQ;
+	tecr0_mask |= LNmTECR0_SGN_POST1Q | LNmTECR0_RATIO_PST1Q;
+	tecr0_mask |= LNmTECR0_ADPT_EQ | LNmTECR0_AMP_RED;
+	tecr0 |= FIELD_PREP(LNmTECR0_TEQ_TYPE, params->teq);
+	if (params->preq_ratio) {
+		tecr0 |= FIELD_PREP(LNmTECR0_SGN_PREQ, 1);
+		tecr0 |= FIELD_PREP(LNmTECR0_RATIO_PREQ, params->preq_ratio);
+	}
+	if (params->postq_ratio) {
+		tecr0 |= FIELD_PREP(LNmTECR0_SGN_POST1Q, 1);
+		tecr0 |= FIELD_PREP(LNmTECR0_RATIO_PST1Q, params->postq_ratio);
+	}
+	tecr0 |= FIELD_PREP(LNmTECR0_ADPT_EQ, params->adpt_eq);
+	tecr0 |= FIELD_PREP(LNmTECR0_AMP_RED, params->amp_red);
+
+	for_each_lane_reverse(i, group) {
+		tmp = lynx_read(serdes, LNmGCR0(i));
+		tmp &= ~(LNmGCR0_RRST_B | LNmGCR0_TRST_B);
+		lynx_write(serdes, tmp, LNmGCR0(i));
+		ndelay(50);
+
+		tmp &= ~gcr0_mask;
+		tmp |= gcr0;
+		tmp |= FIELD_PREP(LNmGCR0_FIRST_LANE, i == group->first_lane);
+		lynx_write(serdes, tmp, LNmGCR0(i));
+
+		tmp = lynx_read(serdes, LNmGCR1(i));
+		tmp &= ~gcr1_mask;
+		tmp |= gcr1;
+		lynx_write(serdes, tmp, LNmGCR1(i));
+
+		tmp = lynx_read(serdes, LNmRECR0(i));
+		tmp &= ~recr0_mask;
+		tmp |= recr0;
+		lynx_write(serdes, tmp, LNmRECR0(i));
+
+		tmp = lynx_read(serdes, LNmTECR0(i));
+		tmp &= ~tecr0_mask;
+		tmp |= tecr0;
+		lynx_write(serdes, tmp, LNmTECR0(i));
+
+		tmp = lynx_read(serdes, LNmTTLCR0(i));
+		tmp &= ~LNmTTLCR0_FLT_SEL;
+		tmp |= FIELD_PREP(LNmTTLCR0_FLT_SEL, params->flt_sel);
+		lynx_write(serdes, tmp, LNmTTLCR0(i));
+
+		ndelay(120);
+		tmp = lynx_read(serdes, LNmGCR0(i));
+		tmp |= LNmGCR0_RRST_B | LNmGCR0_TRST_B;
+		lynx_write(serdes, tmp, LNmGCR0(i));
+	}
+
+	/* Enable the new controller */
+	tmp = lynx_read(serdes, PCCRn(new_mode->pccr));
+	tmp = lynx_proto_mode_prep(new_mode, tmp, proto);
+	lynx_write(serdes, tmp, PCCRn(new_mode->pccr));
+
+	if (proto == LYNX_PROTO_1000BASEKX) {
+		group->ex_dly = serdes->clks[pll].ex_dly.clk;
+		/* This should never fail since it's from our internal driver */
+		WARN_ON_ONCE(clk_prepare_enable(group->ex_dly));
+	}
+
+	if (new_mode->protos & PROTO_MASK(SGMII)) {
+		tmp = lynx_read(serdes, SGMIIaCR1(new_mode->idx));
+		tmp |= SGMIIaCR1_SGPCS_EN;
+		lynx_write(serdes, tmp, SGMIIaCR1(new_mode->idx));
+	}
+
+	mutex_unlock(&serdes->lock);
+
+	group->proto = proto;
+	dev_dbg(&phy->dev, "set mode to %s on lanes %u to %u\n",
+		lynx_proto_str[proto], group->first_lane, group->last_lane);
+	return 0;
+}
+
+static void lynx_release(struct phy *phy)
+{
+	struct lynx_group *group = phy_get_drvdata(phy);
+	struct lynx_priv *serdes = group->serdes;
+
+	mutex_lock(&serdes->lock);
+	if (--group->users) {
+		mutex_unlock(&serdes->lock);
+		return;
+	}
+	list_del(&group->groups);
+	mutex_unlock(&serdes->lock);
+
+	phy_destroy(phy);
+	kfree(group);
+}
+
+static const struct phy_ops lynx_phy_ops = {
+	.init = lynx_init,
+	.exit = lynx_exit,
+	.power_on = lynx_power_on,
+	.power_off = lynx_power_off,
+	.set_mode = lynx_set_mode,
+	.validate = lynx_validate,
+	.release = lynx_release,
+	.owner = THIS_MODULE,
+};
+
+static struct phy *lynx_xlate(struct device *dev, struct of_phandle_args *args)
+{
+	struct phy *phy;
+	struct list_head *head;
+	struct lynx_group *group;
+	struct lynx_priv *serdes = dev_get_drvdata(dev);
+	unsigned int last_lane;
+
+	if (args->args_count == 1)
+		last_lane = args->args[0];
+	else if (args->args_count == 2)
+		last_lane = args->args[1];
+	else
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&serdes->lock);
+
+	/* Look for an existing group */
+	list_for_each(head, &serdes->groups) {
+		group = container_of(head, struct lynx_group, groups);
+		if (group->first_lane == args->args[0] &&
+		    group->last_lane == last_lane) {
+			group->users++;
+			phy = group->phy;
+			goto out;
+		}
+	}
+
+	/* None found, create our own */
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group) {
+		phy = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	group->serdes = serdes;
+	group->first_lane = args->args[0];
+	group->last_lane = last_lane;
+	group->users = 1;
+	phy = phy_create(dev, NULL, &lynx_phy_ops);
+	if (IS_ERR(phy)) {
+		kfree(group);
+	} else {
+		group->phy = phy;
+		phy_set_drvdata(phy, group);
+		list_add(&group->groups, &serdes->groups);
+	}
+
+out:
+	mutex_unlock(&serdes->lock);
+	return phy;
+}
+
+static int lynx_read_u32(struct device *dev, struct fwnode_handle *fwnode,
+			 const char *prop, u32 *val)
+{
+	int ret;
+
+	ret = fwnode_property_read_u32(fwnode, prop, val);
+	if (ret)
+		dev_err(dev, "could not read %s from %pfwP: %d\n", prop,
+			fwnode, ret);
+	return ret;
+}
+
+static int lynx_parse_mode(struct lynx_priv *serdes, struct fwnode_handle *fwnode,
+			   struct lynx_mode *mode, u16 protos, u8 pccr, u8 idx)
+{
+	struct device *dev = serdes->dev;
+	int ret;
+	u32 val;
+
+	ret = lynx_read_u32(dev, fwnode, "fsl,cfg", &val);
+	if (ret)
+		return ret;
+	mode->cfg = val;
+
+	ret = lynx_read_u32(dev, fwnode, "fsl,first-lane", &val);
+	if (ret)
+		return ret;
+	mode->first_lane = val;
+
+	ret = fwnode_property_read_u32(fwnode, "fsl,last-lane", &val);
+	if (ret && ret != -EINVAL) {
+		dev_err(dev, "could not read %s from %pfwP: %d\n",
+			"fsl,last-lane", fwnode, ret);
+		return ret;
+	}
+	mode->last_lane = val;
+
+	if (mode->first_lane >= serdes->conf->lanes) {
+		dev_err(dev,
+			"value of %s (%u) in %pfwP exceeds lane count (%u)\n",
+			"fsl,first-lane", mode->first_lane, fwnode,
+			serdes->conf->lanes);
+		return -EINVAL;
+	} else if (mode->last_lane >= serdes->conf->lanes) {
+		dev_err(dev,
+			"value of %s (%u) in %pfwP exceeds lane count (%u)\n",
+			"fsl,last-lane", mode->last_lane, fwnode,
+			serdes->conf->lanes);
+		return -EINVAL;
+	}
+
+	mode->protos = protos;
+	mode->pccr = pccr;
+	mode->idx = idx;
+	return 0;
+}
+
+static int lynx_parse_pccrs(struct lynx_priv *serdes)
+{
+	struct fwnode_handle *pccr_node, *proto_node, *config_node;
+	struct device *dev = serdes->dev;
+	size_t mode = 0, mode_total = 0;
+	struct lynx_mode *modes;
+	int ret;
+
+	/* To ease memory management, calculate our allocation up-front */
+	device_for_each_child_node(dev, pccr_node) {
+		fwnode_for_each_child_node(pccr_node, proto_node) {
+			size_t mode_subtotal = 0;
+
+			fwnode_for_each_child_node(proto_node, config_node)
+				mode_subtotal++;
+			mode_total += mode_subtotal ?: 1;
+		}
+	}
+
+	modes = devm_kcalloc(dev, mode_total, sizeof(*modes),
+				     GFP_KERNEL);
+	if (!modes)
+		return -ENOMEM;
+
+	device_for_each_child_node(dev, pccr_node) {
+		u32 pccr;
+
+		lynx_read_u32(dev, pccr_node, "fsl,pccr", &pccr);
+		if (ret)
+			return ret;
+
+		fwnode_for_each_child_node(pccr_node, proto_node) {
+			const char *proto_str;
+			bool children = false;
+			u16 protos;
+			u32 index;
+
+			lynx_read_u32(dev, proto_node, "fsl,index", &index);
+			if (ret)
+				return ret;
+
+			ret = fwnode_property_read_string(proto_node,
+							  "fsl,proto",
+							  &proto_str);
+			if (ret) {
+				dev_err(dev,
+					"could not read %s from %pfwP: %d\n",
+					"fsl,proto", proto_node, ret);
+				return ret;
+			}
+
+			if (strstarts(proto_str, "sgmii")) {
+				protos = PROTO_MASK(SGMII);
+				if (serdes->conf->caps &
+				    BIT(LYNX_HAS_1000BASEKX))
+					protos |= PROTO_MASK(1000BASEKX);
+				if (!strcmp(proto_str, "sgmii25"))
+					protos |= PROTO_MASK(SGMII25);
+			} else if (!strcmp(proto_str, "qsgmii")) {
+				protos = PROTO_MASK(QSGMII);
+			} else if (!strcmp(proto_str, "xfi")) {
+				protos = PROTO_MASK(XFI);
+				if (serdes->conf->caps & BIT(LYNX_HAS_10GKR))
+					protos |= PROTO_MASK(10GKR);
+			} else if (!strcmp(proto_str, "pcie")) {
+				protos = PROTO_MASK(PCIE);
+			} else if (!strcmp(proto_str, "sata")) {
+				protos = PROTO_MASK(SATA);
+			} else {
+				dev_warn(dev,
+					 "unknown protocol %s for fsl,proto in %pfwP\n",
+					 proto_str, proto_node);
+				continue;
+			}
+
+			fwnode_for_each_child_node(proto_node, config_node) {
+				children = true;
+				ret = lynx_parse_mode(serdes, config_node,
+						      &modes[mode++],
+						      protos, pccr, index);
+				if (ret)
+					return ret;
+			}
+
+			if (!children) {
+				ret = lynx_parse_mode(serdes, proto_node,
+						      &modes[mode++],
+						      protos, pccr, index);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
+	serdes->modes = modes;
+	WARN_ON(mode != mode_total);
+	serdes->mode_count = mode;
+	return 0;
+}
+
+static int lynx_probe(struct platform_device *pdev)
+{
+	bool grabbed_clocks = false;
+	int i, ret;
+	struct device *dev = &pdev->dev;
+	struct lynx_priv *serdes;
+	struct regmap_config regmap_config = {
+		.reg_bits = 32,
+		.reg_stride = 4,
+		.val_bits = 32,
+		.disable_locking = true,
+	};
+	struct resource *res;
+	void __iomem *base;
+
+	serdes = devm_kzalloc(dev, sizeof(*serdes), GFP_KERNEL);
+	if (!serdes)
+		return -ENOMEM;
+
+	serdes->dev = dev;
+	platform_set_drvdata(pdev, serdes);
+	mutex_init(&serdes->lock);
+	INIT_LIST_HEAD(&serdes->groups);
+	serdes->conf = device_get_match_data(dev);
+
+	ret = lynx_parse_pccrs(serdes);
+	if (ret)
+		return ret;
+
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
+		dev_err_probe(dev, ret, "could not get/map registers\n");
+		return ret;
+	}
+
+	regmap_config.val_format_endian = serdes->conf->endian;
+	regmap_config.max_register = res->end - res->start;
+	serdes->regmap = devm_regmap_init_mmio(dev, base, &regmap_config);
+	if (IS_ERR(serdes->regmap)) {
+		ret = PTR_ERR(serdes->regmap);
+		dev_err_probe(dev, ret, "could not create regmap\n");
+		return ret;
+	}
+
+	ret = lynx_clks_init(serdes->clks, dev, serdes->regmap);
+	if (ret)
+		return ret;
+
+	/* Deselect anything configured by the RCW/bootloader */
+	for (i = 0; i < serdes->mode_count; i++) {
+		const struct lynx_mode *mode = &serdes->modes[i];
+		u32 pccr = lynx_read(serdes, PCCRn(mode->pccr));
+
+		if (lynx_proto_mode_get(mode, pccr) == mode->cfg) {
+			if (mode->protos & UNSUPPORTED_PROTOS) {
+				/* Don't mess with modes we don't support */
+				if (mode->first_lane > mode->last_lane)
+					serdes->used_lanes |=
+						GENMASK(mode->first_lane,
+							mode->last_lane);
+				else
+					serdes->used_lanes |=
+						GENMASK(mode->last_lane,
+							mode->first_lane);
+				if (grabbed_clocks)
+					continue;
+
+				grabbed_clocks = true;
+				clk_prepare_enable(serdes->clks[0].pll.clk);
+				clk_prepare_enable(serdes->clks[1].pll.clk);
+				clk_rate_exclusive_get(serdes->clks[0].pll.clk);
+				clk_rate_exclusive_get(serdes->clks[1].pll.clk);
+			} else {
+				/* Otherwise, clear out the existing config */
+				pccr = lynx_proto_mode_prep(mode, pccr,
+							    LYNX_PROTO_NONE);
+				lynx_write(serdes, pccr, PCCRn(mode->pccr));
+			}
+
+			/* Disable the SGMII PCS until we're ready for it */
+			if (mode->protos & LYNX_PROTO_SGMII) {
+				u32 cr1;
+
+				cr1 = lynx_read(serdes, SGMIIaCR1(mode->idx));
+				cr1 &= ~SGMIIaCR1_SGPCS_EN;
+				lynx_write(serdes, cr1, SGMIIaCR1(mode->idx));
+			}
+		}
+	}
+
+	/* Power off non-used lanes */
+	for (i = 0; i < serdes->conf->lanes; i++) {
+		if (serdes->used_lanes & BIT(i))
+			continue;
+		lynx_power_off_lane(serdes, i);
+	}
+
+	ret = PTR_ERR_OR_ZERO(devm_of_phy_provider_register(dev, lynx_xlate));
+	if (ret)
+		dev_err_probe(dev, ret, "could not register phy provider\n");
+	else
+		dev_info(dev, "probed with %d lanes\n", serdes->conf->lanes);
+	return ret;
+}
+
+static const struct lynx_conf ls1046a_conf = {
+	.lanes = 4,
+	.caps = BIT(LYNX_HAS_1000BASEKX) | BIT(LYNX_HAS_10GKR),
+	.endian = REGMAP_ENDIAN_BIG,
+};
+
+static const struct lynx_conf ls1088a_conf = {
+	.lanes = 4,
+	.caps = BIT(LYNX_HAS_1000BASEKX) | BIT(LYNX_HAS_10GKR),
+	.endian = REGMAP_ENDIAN_LITTLE,
+};
+
+static const struct of_device_id lynx_of_match[] = {
+	{ .compatible = "fsl,ls1046a-serdes", .data = &ls1046a_conf },
+	{ .compatible = "fsl,ls1088a-serdes", .data = &ls1088a_conf },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, lynx_of_match);
+
+static struct platform_driver lynx_driver = {
+	.probe = lynx_probe,
+	.driver = {
+		.name = "lynx_10g",
+		.of_match_table = lynx_of_match,
+	},
+};
+module_platform_driver(lynx_driver);
+
+MODULE_AUTHOR("Sean Anderson <sean.anderson@seco.com>");
+MODULE_DESCRIPTION("Lynx 10G SerDes driver");
+MODULE_LICENSE("GPL");
-- 
2.35.1.1320.gc452695387.dirty

