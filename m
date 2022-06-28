Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534B555F0EF
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiF1WO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiF1WOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:24 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092B532ED4;
        Tue, 28 Jun 2022 15:14:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BT3Ah8k/W9LheeEy0Up8XcBzg9zA3n6mVsNWaRNAriUe3N7BejrKBlas7hp22KCGjyOTESUDklQteBxFgFfD+TVxco6SBVcwMTl15EndnE/H/J+6HmJi+9F2Xp6DE4WtiXqKR1RB3OiEMsUwf3mMBiExrSviAaXc10xjQxQ9DlMFc3ELSp45e5p9JvO5epzd8i+b+AS9zjU9Y0wH1U6356wBpaZboxLuw8ftG8dwRhNL8qzqpMb5oXg45uh5K4qWnmstcWriIUXsHDCEanuZpLFYegEyJMVL6fNffjoFP1JB9EVzGUTJnRyUrJE40ZHOYme7uWO6dw2GZuzywZF94A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrvyUWHMCkhgvuU9+YUfWlr08W8r2G2CVsOm1VThNCk=;
 b=DMXVs25VKBrJxSf9Iura+ettFmbSXi2nPGXExsxkCZvkAQdwLs3H0HYYXDctrFZwNhGYkPyw+cgL/UARzw5DrDQghwANxolmx6mBDLA1X27cX5W4UTT5xNZ2qkM1YA8PO/spe91QETkzIosetS8NzTWs/wtOcDIcbEf7TjwT4Jf7Zksqpf9iaM/FlgFuxQp+CeQsqA54/v6krEzIvsVr1l5Ue5q8sedoPmFEDpEX+mTV1XKI+iCmRC+Hvib/HS2ou6LThI1/1v9WmfYDfkwXD4zgIslJLpSlBU99xAQ7s1df32LdfXudBq1BJqQAR/Ip2RYs2n7ij48V7g2/Oj+/9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrvyUWHMCkhgvuU9+YUfWlr08W8r2G2CVsOm1VThNCk=;
 b=yTEtQkSAnjGUhwRQgA6Prj3wUdpzn60sAwe4Ce1UF1xybxAGHN2wrXOB3B8+BBi9CiW3PskJJ0wsy1im2lTbZbHsyQZ97FtJpwocmuYaT4bg3N8W/7esJddQhYcM4Zsv1o6zZhsFstBpFn0AjkShcKIV6ScIZIXrMMDIT97+GbZOABP04XxB7ld8r2ONGkReKKUfe3KdOuKhf7NtfcqOVtGZuJdguZJ4D/tOe3aZfAWqCX+oxv2pSsNGm8CiFjK7Pxu+jjBBIeS584wGge1RquF+OC/v3Zx+bTqtVwtiZ6QwpNsoUZdHjnT8u2tzM1+oDikSC7IP6Mw24LRNAec/Ig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:18 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:18 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-phy@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v2 00/35] [RFT] net: dpaa: Convert to phylink
Date:   Tue, 28 Jun 2022 18:13:29 -0400
Message-Id: <20220628221404.1444200-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 247593d4-caae-49a3-8301-08da59538b76
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAASA71JfKnt6mCqDYdbBLfMEy5nqPq2lMN1FeBw2TFxymI4T2rsFlRWJMXKdTj+3JN6r2BybwJEGB1pP2iZTTtjmnGofVOc0bJXdCX3KyzCzyBZlDnyV9YWVM4FH5xmS8XYAdPzp3OxsxnX2/+Yhv5FvxgZ6XIdq88J4vvLrQV2T3NUSfCZRYfaEEMbuDH0JMZgRoPXlje4bEzrKJiTkM5pcXH7tHBbz/mkIh1II5FMciM8wrsJcX8AT520r90VqwbnpEsfh84tRpRpqJp/dnKJ1LwlSjv8VvrY3EHAwiwrvRg+rtv7Gg5qrRo0A5YHHkCHq8phIB0tAfwof9sxqT4ZVs1TeD1GE9qG6lMUJd2W3W7/t/cUX/pnFe0NUhMfUPDJ0kV3EpUtudR7olq2P4Xi2/ZE7hZaEi+VGNm1ip8j7dl/TQGoNYo3vnAlcO7eDqCgG25h64NSCB4uIcmYFWYCiL0CBN/czMJaL8pPoxEM60UiPVaRN4LO1Wa9DpJq6hC+x6sTkgctuCcuxfNDd0chLOwoCAeLVgA9jjFCZU3zeRUi6wi45W5FnfL5TsdTTUQglUNLAjr1spTRlC8cZMCcRk2Uf1oz2V7xIilMp7N6jhWjr5DP7QJy1pCmHRwWlo075KA/dYDJsRZ+N0gw0nT+i7hRhnY4hDKRP2NKhGBAPpwwibzK1rzjo833tpBB7RpNlL3paeNT0zLZe88h0cr5kZQ/imdjp+a1DDfx0SRehre7uBrG3CMsW/09ZRRoRtYJyZCYUEBsE6GvPMMEg2SHBJmcqMtJc6IujL20/4Xtx5cUOhD0Ro8pa01jlVQS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(1076003)(966005)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(7416002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ada8JaLNo9tTcHP9FwPEqvTNVxlnEavqbbHmM53XC2xolu1kWH2ds4gd8b1U?=
 =?us-ascii?Q?RJHsqNHsGoXwSzg1r+UoFvobSt0KKkdsm8GLgr/buSsBZICssdTVTKfg2atd?=
 =?us-ascii?Q?+ATAhlkfYMefHuhSWVZvZSAcSvxgPjDQKICq0tS5Q4gHUnDT7+T9n/II/USI?=
 =?us-ascii?Q?UqCA0552pbMGhd2fQYA7RhlSNM49/6Z5J4NMjiN7m3YCsAUfEO2M71k4anQB?=
 =?us-ascii?Q?+TnMYqhCLHVVop0DjWaAAYNU9QocSH9dQ+jbj7viTEojb/YBp2Jt6jlmYFLw?=
 =?us-ascii?Q?6Ow+v+/pZhqBOrQo4qsvjHl5MU5ZArsVaG5+PWoEubwlKBG2PmCnG3URqXQN?=
 =?us-ascii?Q?rJHt7cqNi+Q2jX/Io64/004Fj7O/8p31VGLVQl95GObcoJ1StuZ7JI47f9PU?=
 =?us-ascii?Q?hyZDOZ9Kvat9eZ8qvZ5bqeSbUT22ir0CI8FrBfeXhL68deLqTRNTqmPyCoIi?=
 =?us-ascii?Q?27wJobQt7yaUcCOxGCFI/AJdCXeubEOo9vAmXTNucw5L29YEKpmbFeX9epdC?=
 =?us-ascii?Q?4b3OjgMCdR6/wdl8Q1K7wA7njR8TwFJONOiC5LFjoTLn6AoQ79kQoFSGhwRr?=
 =?us-ascii?Q?1FQ0YyzIbutGjdR+dwJSTwkNnR7vkOrbDKKF1ZCOe0m4jkm5ITPXiKkvtMUy?=
 =?us-ascii?Q?fpI3+EeJE7npHFHtxIErbel8NumtVrSNxezJc+WQuiJyh1v/QANiARFCBOxH?=
 =?us-ascii?Q?0iRa6tt2Mkz1UgirMsvG9JohBNeWA2Guw7SgobYZAhNAZw4buUO9ehJsQN/I?=
 =?us-ascii?Q?YnEzZGVwJBccjI/1rnk4tEGRgv+Ly3YENdy5UzCPlYGLD0ogyaRC4BQ1xE86?=
 =?us-ascii?Q?mqUZ6aOeijjWqtDtb24aUjI9ul6E4G78W0mOQxj1ALO2TKZUDII/6SKjKCEw?=
 =?us-ascii?Q?oFDUk/M9Q07lpqBE7uiRXX2lAtUS3yD9CKlcYG1uc76vnbNOCBS6z537jh8M?=
 =?us-ascii?Q?Epie6wxSnEZQpZYJuLl28In5uIWfLnw6sK3jY8FyRm3ouveyZYO0XFStZl3p?=
 =?us-ascii?Q?8xlxHZ65LrTzOFIL+3xyFQbQPjPEECwqFo0NJkObALPUeboI9gi2lxKoCKCq?=
 =?us-ascii?Q?nB0t+jnoB1mPHb6unJMNALxCMNkkl0KcyPldiwb4pdXbj9Q85HaJIiNZo3iK?=
 =?us-ascii?Q?5tUHMGXTELOPFta2u1fIr+65EJCB9gliGVBQlsJ/do8A+4kSalSHI8+Owwr/?=
 =?us-ascii?Q?EdDVyNBIaBgxwS6jY4NaIn1HmXjW4Fa/2wqjKTBAI9HvEbDVQOgKh1q435Lh?=
 =?us-ascii?Q?zs+f2ifRILxjv/Ox49sEED59rBxZz6dUywZZF0zNMVcFhc25/YPlFfEhTgCY?=
 =?us-ascii?Q?7T50obZCxm+RVq8OYAVq5RvRwCmLOd9J+AbpbRE9M+y3qciPxDxYH8t13IBG?=
 =?us-ascii?Q?EsBt2i+KYwhzJkArQ/rmplUyUUTw7b+XbUSYVmv9OwHL2gFw6d08gVFlIoEU?=
 =?us-ascii?Q?rNeWTrdYb6Os+BYThAdvhQmaIRU/wUZzcioO3fsTYnhggiFvWrld+8dbZDj6?=
 =?us-ascii?Q?o6i97Pgwc2nmJVJBfRX781QKUTRFTqfd07hgYOWAjd8WZA1wI5XSlz9Xdy5Q?=
 =?us-ascii?Q?b83qcRPUxfl5RriiM5mVp0IvG7IJXHpptxP1XqtEmzqaZPat0eaxu1o2nobs?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247593d4-caae-49a3-8301-08da59538b76
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:18.6116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSmtGMrfcutI373YjsVhyJLKMHMDLj6rqUCX9dPnsQr1hW9mtzXmyup8fC3BRUztjiNI//wwI6CjL9qQmoj3IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
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

I have tried to maintain backwards compatibility with existing device
trees whereever possible. However, one area where I was unable to
achieve this was with QSGMII. Please refer to patch 3 for details.

All mac drivers have now been converted. I would greatly appreciate if
anyone has QorIQ boards they can test/debug this series on. I only have an
LS1046ARDB. Everything but QSGMII should work without breakage; QSGMII
needs patch 33.

The serdes driver is mostly functional (but not quite, see patches 5 and
31).  This series only adds support for the LS1046ARDB SerDes, but it
should be fairly straightforward to add support for other SoCs and
boards (see Documentation/driver-api/phy/qoriq.rst). Patches 34 and 25
should show the typical steps.

This patches in this series can be logically categorized as follows:
- 1, 4, 29, 34-35: SerDes support
- 2, 5-25: Cleanups. These can be applied as-is.
- 3, 26-28, 30-33: Phylink conversion

Patches 5-9 were first submitted as [1].

[1] https://lore.kernel.org/netdev/20220531195851.1592220-1-sean.anderson@seco.com/

Changes in v2:
- Add #clock-cells. This will allow using assigned-clocks* to configure
  the PLLs.
- Add CGR update function
- Add helper for sanity checking cgr ops
- Add nodes for QSGMII PCSs
- Add rgmii property to all DPAA MACs
- Adjust queue depth on rate change
- Allow a value of 1 for phy-cells. This allows for compatibility with
  the similar (but according to Ioana Ciornei different enough) lynx-28g
  binding.
- Better document how we select which PCS to use in the default case
- Clear SGMIIaCR1_PCS_EN during probe
- Configure the SerDes in enable/disable
- Convert 10GEC and dTSEC as well
- Convert FMan MAC bindings to yaml
- Disable SerDes by default to prevent breaking boards inadvertently.
- Document phy cells in the description
- Document the structure of the compatible strings
- Fix capitalization of mEMAC in commit messages
- Fix example binding having too many cells in regs
- Fix not clearing group->pll after disabling it
- Fix prototype for dtsec_initialization
- Fix warning if sizeof(void *) != sizeof(resource_size_t)
- Handle 1000Base-KX in lynx_proto_mode_prep
- Move PCS_LYNX dependency to fman Kconfig
- Move compatible first
- Power off lanes during probe
- Properly implement all ethtool ops and ioctls. These were mostly
  stubbed out just enough to compile last time.
- Refer to the device in the documentation, rather than the binding
- Remove minItems
- Remove some unused variables
- Remove unused variable slow_10g_if
- Rename LYNX_PROTO_UNKNOWN to LYNX_PROTO_NONE
- Rename driver to Lynx 10G (etc.)
- Rename to fsl,lynx-10g.yaml
- Restrict valid link modes based on the phy interface. This is easier
  to set up, and mostly captures what I intended to do the first time.
  We now have a custom validate which restricts half-duplex for some SoCs
  for RGMII, but generally just uses the default phylink validate.
- Specify type of mac_dev for exception_cb
- Support 1 and 2 phy-cells
- Use list for clock-names
- Use one phy cell for SerDes1, since no lanes can be grouped

Sean Anderson (35):
  dt-bindings: phy: Add QorIQ SerDes binding
  dt-bindings: net: Convert FMan MAC bindings to yaml
  dt-bindings: net: fman: Add additional interface properties
  [RFC] phy: fsl: Add Lynx 10G SerDes driver
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
  net: fman: Specify type of mac_dev for exception_cb
  net: fman: Clean up error handling
  net: fman: Change return type of disable to void
  net: dpaa: Use mac_dev variable in dpaa_netdev_init
  soc: fsl: qbman: Add helper for sanity checking cgr ops
  soc: fsl: qbman: Add CGR update function
  net: dpaa: Adjust queue depth on rate change
  net: fman: memac: Add serdes support
  net: fman: memac: Use lynx pcs driver
  [RFT] net: dpaa: Convert to phylink
  qoriq: Specify which MACs support RGMII
  qoriq: Add nodes for QSGMII PCSs
  arm64: dts: ls1046a: Add serdes bindings
  arm64: dts: ls1046ardb: Add serdes bindings

 .../bindings/net/fsl,fman-dtsec.yaml          |  188 +++
 .../devicetree/bindings/net/fsl-fman.txt      |  133 +-
 .../devicetree/bindings/phy/fsl,lynx-10g.yaml |   93 ++
 Documentation/driver-api/phy/index.rst        |    1 +
 Documentation/driver-api/phy/qoriq.rst        |   93 ++
 MAINTAINERS                                   |    6 +
 .../boot/dts/freescale/fsl-ls1043-post.dtsi   |   28 +
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   |   33 +
 .../boot/dts/freescale/fsl-ls1046a-rdb.dts    |   34 +
 .../arm64/boot/dts/freescale/fsl-ls1046a.dtsi |   16 +
 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi   |    4 +
 arch/powerpc/boot/dts/fsl/b4si-post.dtsi      |    4 +
 .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |    3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |    9 +-
 .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |    9 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |    9 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |    9 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |    9 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |    9 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |    9 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |    9 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |    9 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |    9 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |    9 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |    9 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |    9 +-
 arch/powerpc/boot/dts/fsl/t1023si-post.dtsi   |    4 +
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi   |    7 +
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |    8 +
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi   |   16 +
 drivers/net/ethernet/freescale/dpaa/Kconfig   |    4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  132 +-
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |    2 +-
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |   90 +-
 drivers/net/ethernet/freescale/fman/Kconfig   |    3 +-
 drivers/net/ethernet/freescale/fman/fman.c    |   31 +-
 drivers/net/ethernet/freescale/fman/fman.h    |   31 +-
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  670 ++++----
 .../net/ethernet/freescale/fman/fman_dtsec.h  |   58 +-
 .../net/ethernet/freescale/fman/fman_keygen.c |   29 +-
 .../net/ethernet/freescale/fman/fman_keygen.h |   29 +-
 .../net/ethernet/freescale/fman/fman_mac.h    |   34 +-
 .../net/ethernet/freescale/fman/fman_memac.c  |  877 +++++-----
 .../net/ethernet/freescale/fman/fman_memac.h  |   57 +-
 .../net/ethernet/freescale/fman/fman_muram.c  |   31 +-
 .../net/ethernet/freescale/fman/fman_muram.h  |   32 +-
 .../net/ethernet/freescale/fman/fman_port.c   |   29 +-
 .../net/ethernet/freescale/fman/fman_port.h   |   29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.c |   29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.h |   28 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  274 ++-
 .../net/ethernet/freescale/fman/fman_tgec.h   |   54 +-
 drivers/net/ethernet/freescale/fman/mac.c     |  653 +-------
 drivers/net/ethernet/freescale/fman/mac.h     |   66 +-
 drivers/phy/freescale/Kconfig                 |   20 +
 drivers/phy/freescale/Makefile                |    1 +
 drivers/phy/freescale/phy-fsl-lynx-10g.c      | 1483 +++++++++++++++++
 drivers/soc/fsl/qbman/qman.c                  |   76 +-
 include/soc/fsl/qman.h                        |    9 +
 63 files changed, 3330 insertions(+), 2331 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
 create mode 100644 Documentation/driver-api/phy/qoriq.rst
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g.c

-- 
2.35.1.1320.gc452695387.dirty

