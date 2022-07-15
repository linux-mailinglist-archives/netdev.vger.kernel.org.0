Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF94657693F
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiGOWAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiGOWAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:00:17 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50072.outbound.protection.outlook.com [40.107.5.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973594B0F6;
        Fri, 15 Jul 2022 15:00:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrN3+jmLLf+aK59JLk57Gb+6YUNYpT11OebTnyEXBl/yz1KJicmYN2xU/Uu6SLk/91i5B4wB5wATk/s3DhyNcqcASKlyojCy1VMAN2UJtMbKMpOVYUEEZtnKh39GNrHWbXq6OHOpsW2t5OyOiVpCX02/hA4vsS3Uh/7MrxFCleHPzlVoY5RCOA6bOLJ0KMusywjs3EN41Wep/f0pQaNbwd98Ka2u7yGAHYHmDHhjJXFpMIbb3Pztx3MwT9/IXY9U85kcMXXy32OqbdhNVrkfIdPXILk0uROBDsv+jMaPk4B7xHVz6DRIc0usrAucv14CAhH35xY3xuGsd7nAGXPMfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCzvSIjAXVlk3sLFepddlgQ0IBi4IBbUWuscQXbiyiw=;
 b=ST2mRCO8rnKDchpDptIMFfz0wVSOfsuOUPTI3jmqQnYFHrbxgH278bL9PY+XbLaATzS3N1NWLhx+t9PmRIjAk3kbw/sUVWNOkNjjdwy6E0RqiQBbqjCNNWfcSdSf9dB9C/CjVrxFtexyb82WAtsqDpETWCP7tu0qheg4dMg8Zig8AzzeJt3C/0XwFEqNr/KuVlD5z9aHoCkkL24JXWwMHeHaWtoBtaG66ruygi6+9wqD21LdzI20UPQIwnXiSnqYy66LuwXpcYGSlWl72QTdIxlNJ3FNFosBeYgEZzBLIKmslhEuDezyoJ8CK5XDA6FqOXQYWwg/+jm77MfAy/1IYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCzvSIjAXVlk3sLFepddlgQ0IBi4IBbUWuscQXbiyiw=;
 b=qfOAtxZWvIXeR6efoBix3WLa5WYtSartYftItbbhaaErqiadk6ERFY2AI/t0PlmfbD2TqZyf9ywGA3Jw+5bIFuV5Y6IU2RxJyypfbs4NYlZOJYvhNjy8wkIIGXBVNidCZIz63+p8bZQ+Gz9utUZnHPaY5qe5dWwyHcbQRVtBZQlfJ9TppGXaBrjDHZk4Cidd8qxv0pjUCTOwGqnQLFIXCd+HtIgfR2hG6SpOmJoAlRGAz7pTBfbvVHaeTdyH9R5ZibT3rkiajX/p0DK51zkmKSIuSOCXS670XcmWQiYjKH/fNs1LJwJ5jFqVJKvnuk3oJmZNx/uouQWImjTwMiWiEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:10 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:10 +0000
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
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-phy@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v3 00/47] [RFT] net: dpaa: Convert to phylink
Date:   Fri, 15 Jul 2022 17:59:07 -0400
Message-Id: <20220715215954.1449214-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e655270c-5f8e-4229-13b9-08da66ad6293
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TKuJkx1aqDCGPhmiiMld3enN7NlALIqMPUGeFHJBruaU7yGmanprHM/y/R7wsF5BrnQHb4u4lmJgS1+1oC3Jpn61fRfPDGC64ub9N7eWwgD+Y+nDwn+AbYm/SFhunOl70IOWPmCFGkdkl8DQ0kV+YBNIHk5wP1DPhFZzlhNLgw7GsEAKmQaYKImVlbZeEGDsYSko2IK8hdVmXysoUvNv0VafWOhUDL5lV+RkZa0xW8EN7vM4Ou3bnRPcd9r8SvPkKH4vWjPkEi9JTs+gjs72+lEVLNwG36ERYPpJFKFyjKt38M4Ri+3FPgnE1kXSNQwe1mXEnyVwQcvj+A5tEozElfOTLq30wWj6zVibcJEQO0XLym74xfa4NPXjekiv/2Vkf9W/VvbZvLEOFg6PuuuVEGMjyLRUB+GW0IL+cPTTtzE/rXNUozo+O2UreuxVL9Tqfu9F2cNp7WJNPYIuqd3JcrdsNzzKQKiFnLGqpAeXp3lT5tazWx6AW3KKgzJKC3gLDYEby8vGslPBs+gLtdmsMHTR8EVA4oUShg80y2y0eIblc5jClX4wqvFF4W5r27HCAv4P7KTEYPKj5Cm3fvNSTZ1o3HX5I09/BXrHudA/OC4uiQWN8QrMgEBpWRoBUpeSr/08/smDP27qHM/EWjscwdnffCALWJF+kXrusRVtw4ephrgNAJK9DCUyu+h+wz+Q1pLl0qy0NzfI2hxURdILdYIjm5aRQ9okE3omR+cxTTKbqh/tC52L0TR0uy+jZClQBOnbQsYlrNs8CcQ4LFaBA3mTgrjUCLEdYhOJ0fE5mbYSBZMxciQEHbMfYoE7bzBDq+ds/9ntYYeMBe5NS3tUhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(30864003)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(966005)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RLr4+4OVih4ZJ2B9E3WIQ/WTfGpqbNyZghNFfwGxw7xSvz+zaqv7nH7Uv30o?=
 =?us-ascii?Q?2FlrrGocqFp2TMFWGQZrnGsoXfSw+AAAHXEdQWIHO/f1ZLhhO+tnfjwEHzEV?=
 =?us-ascii?Q?dKYQ+PMBqs5WglY8m7rYmUeAmrt0ab1aZBJryxOcX2e/fLNDa2+eD3MZ3hZC?=
 =?us-ascii?Q?phAaU040bqg/KmZnTka/zV+hpuXD9yRL8xcwRt86qBMIOkI22m/Sryv6h1s0?=
 =?us-ascii?Q?Spw4kTWw9jYbp8nKNUc37yKRvHo6HxugER/OSFczeXal6CihwjQeeDKnWMsa?=
 =?us-ascii?Q?N9FOWjx4oI3B89tR6Qnt3Ivytxu7rUaODy2dQMvmKmuAAihTe/TMmRUbgfvW?=
 =?us-ascii?Q?KL4I8gB8QLrl6bABK1G2T9RdOuDC7SYD8M9NxGOqNlMHtexZIc5sv9MQ5Tgv?=
 =?us-ascii?Q?7xkrD2hROmQF/17rYhlSKXfLQ4c+oO6KNb4cG+zOoa5Xk112Lg7Z7GPYZIOW?=
 =?us-ascii?Q?9GJByL6ZwGfnNS32XLBzc7KBrjvXSQjCL77i5myKpIuEVaQsd3HvU02hDwnr?=
 =?us-ascii?Q?dgD0kG2xtV60kpZnoS6hVvREnH1OkyQ+UfvQcQo4sKqaAVLsiB+v6D3srvQk?=
 =?us-ascii?Q?Zxh2eTy00bmJmlDoFo6O0BeLREzAd71G54i7mJ/jZK2PjCLfkiuV8MfC0/PW?=
 =?us-ascii?Q?MStoD5DqEBZAsq4uA8fRqmdmtUUocp7YwalarWdL4lxa4lUImveBtT+RP5fy?=
 =?us-ascii?Q?RoCfayD5QqDPrPW/VkoOQZ/NuBIE7GciTuo4dzFvaD/k2a/mjSoGyF/9tuSc?=
 =?us-ascii?Q?DI7OntdaAhpPq+GjDGPQXlWRJfxhgqMfX6nPib50iRN84H5V5XdhQ/+EAVOx?=
 =?us-ascii?Q?qacRR8eyU5togIj24/TSdnYTvnzcvkERoufiXo6IDhrjCmL43e4VXUpAe/K5?=
 =?us-ascii?Q?UnAHAkj5qFOeJqjK4oX0HQ+1S5wrSBVp8syy9A/BuU1AD7BPa2LwkPEVDme/?=
 =?us-ascii?Q?2l7CdMBz2g2RvUFylGmepctVXorsqZT4w9qlLSj76nHjd9vx68L9kW8dfPjr?=
 =?us-ascii?Q?D2FqignXSrNNLTaKQpxG3YaYxwEm66n5MQoIJybSniP9mEibMDwuO0nElmGx?=
 =?us-ascii?Q?z4N3El4zZCE8bcbk9LSrUeU7NL/qXroW9ht/C+FP61bj5h/BrvAjG+6nudLc?=
 =?us-ascii?Q?FpRweNIDKl94Z7pheUIrKDYFBjQaWHZvExlHsfnumM18RWcYmJKsFYsYlMMj?=
 =?us-ascii?Q?j/y/a83P4mAb1xUqm3iJkOPeQUy5z+iXwqvJeovv6VHp8T9rfBPjJd3XtUG3?=
 =?us-ascii?Q?shx+wNQAomg+To3Mhd2q18vGWx3OU4NfJFBZank47cx9ucefhzX1D8jqZHZb?=
 =?us-ascii?Q?mRu0hUC/+PI21cpRQuTXnkCWlixgKcGS3CDVFCvx4KxLeHZQqyVtWmKoSk8F?=
 =?us-ascii?Q?7IxruHswB6eQR5GNKfxILapYHHa4yEMWB2wSIaFPRvlwzs3qNEXc6JovAQt3?=
 =?us-ascii?Q?jM4e8EMTwlY1fDrduKrQBMu/FnlObb6oJKjWfu9TaR3xPltXObT14FgkU1nr?=
 =?us-ascii?Q?Gmyo5GYyJseBJaiUGa/I0WcdZP09elcBydus3Tc88Da8Dj4xNP2Ab2KuhIYx?=
 =?us-ascii?Q?DUbIfbgCFEPDSU7l93PpwQsmUSvdMNOinAGLAOxSXNyN/jsb02vGyq5+bS0p?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e655270c-5f8e-4229-13b9-08da66ad6293
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:09.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7OW0xgZOeg8yhK4jDIBAAzGf64r3t4tYVhSp3ic/FXl8CbprqoKCzokYGsDrYmT/38F20czDzqwCuKi9SPWVxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts the DPAA driver to phylink. Additionally,
it also adds a serdes driver to allow for dynamic reconfiguration
between 1g and 10g interfaces (such as in an SFP+ slot). These changes
are submitted together for this RFT, but they will eventually be
submitted separately to the appropriate subsystem maintainers.

I have tried to maintain backwards compatibility with existing device
trees whereever possible. However, one area where I was unable to
achieve this was with QSGMII. Please refer to patch 4 for details.

All mac drivers have now been converted. I would greatly appreciate if
anyone has QorIQ boards they can test/debug this series on. I only have an
LS1046ARDB. Everything but QSGMII should work without breakage; QSGMII
needs patches 42 and 43.

The serdes driver is mostly functional (except for XFI). This series
only adds support for the LS1046ARDB SerDes (and untested LS1088ARDB),
but it should be fairly straightforward to add support for other SoCs
and boards (see Documentation/driver-api/phy/qoriq.rst).

This is the last spin of this series with all patches included. After next
week (depending on feedback) I will resend the patches broken up as
follows:
- 5: 1000BASE-KX support
- 1, 6, 44, 45: Lynx 10G support
- 7-10, 12-14: Phy rate adaptation support
- 2-4, 15-43, 46, 47: DPAA phylink conversion

Patches 15-19 were first submitted as [1].

[1] https://lore.kernel.org/netdev/20220531195851.1592220-1-sean.anderson@seco.com/

Changes in v3:
- Manually expand yaml references
- Add mode configuration to device tree
- Expand pcs-handle to an array
- Incorperate some minor changes into the first FMan binding commit
- Add vendor prefix 'fsl,' to rgmii and mii properties.
- Set maxItems for pcs-names
- Remove phy-* properties from example because dt-schema complains and I
  can't be bothered to figure out how to make it work.
- Add pcs-handle as a preferred version of pcsphy-handle
- Deprecate pcsphy-handle
- Remove mii/rmii properties
- Add 1000BASE-KX interface mode
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
- Add support for phy rate adaptation
- Support differing link speeds and interface speeds
- Adjust advertisement based on rate adaptation
- Adjust link settings based on rate adaptation
- Add support for CRS-based rate adaptation
- Add support for AQR115
- Add some additional phy interfaces
- Add support for aquantia rate adaptation
- Put the PCS mdiodev only after we are done with it (since the PCS
  does not perform a get itself).
- Remove _return label from memac_initialization in favor of returning
  directly
- Fix grabbing the default PCS not checking for -ENODATA from
  of_property_match_string
- Set DTSEC_ECNTRL_R100M in dtsec_link_up instead of dtsec_mac_config
- Remove rmii/mii properties
- Replace 1000Base... with 1000BASE... to match IEEE capitalization
- Add compatibles for QSGMII PCSs
- Split arm and powerpcs dts updates
- Describe modes in device tree
- ls1088a: Add serdes bindings

Changes in v2:
- Rename to fsl,lynx-10g.yaml
- Refer to the device in the documentation, rather than the binding
- Move compatible first
- Document phy cells in the description
- Allow a value of 1 for phy-cells. This allows for compatibility with
  the similar (but according to Ioana Ciornei different enough) lynx-28g
  binding.
- Remove minItems
- Use list for clock-names
- Fix example binding having too many cells in regs
- Add #clock-cells. This will allow using assigned-clocks* to configure
  the PLLs.
- Document the structure of the compatible strings
- Convert FMan MAC bindings to yaml
- Better document how we select which PCS to use in the default case
- Rename driver to Lynx 10G (etc.)
- Fix not clearing group->pll after disabling it
- Support 1 and 2 phy-cells
- Power off lanes during probe
- Clear SGMIIaCR1_PCS_EN during probe
- Rename LYNX_PROTO_UNKNOWN to LYNX_PROTO_NONE
- Handle 1000BASE-KX in lynx_proto_mode_prep
- Remove some unused variables
- Fix prototype for dtsec_initialization
- Fix warning if sizeof(void *) != sizeof(resource_size_t)
- Specify type of mac_dev for exception_cb
- Add helper for sanity checking cgr ops
- Add CGR update function
- Adjust queue depth on rate change
- Move PCS_LYNX dependency to fman Kconfig
- Remove unused variable slow_10g_if
- Restrict valid link modes based on the phy interface. This is easier
  to set up, and mostly captures what I intended to do the first time.
  We now have a custom validate which restricts half-duplex for some SoCs
  for RGMII, but generally just uses the default phylink validate.
- Configure the SerDes in enable/disable
- Properly implement all ethtool ops and ioctls. These were mostly
  stubbed out just enough to compile last time.
- Convert 10GEC and dTSEC as well
- Fix capitalization of mEMAC in commit messages
- Add nodes for QSGMII PCSs
- Add nodes for QSGMII PCSs
- Use one phy cell for SerDes1, since no lanes can be grouped
- Disable SerDes by default to prevent breaking boards inadvertently.

Sean Anderson (47):
  dt-bindings: phy: Add Lynx 10G phy binding
  dt-bindings: net: Expand pcs-handle to an array
  dt-bindings: net: Convert FMan MAC bindings to yaml
  dt-bindings: net: fman: Add additional interface properties
  net: phy: Add 1000BASE-KX interface mode
  [RFT] phy: fsl: Add Lynx 10G SerDes driver
  net: phy: Add support for rate adaptation
  net: phylink: Support differing link speeds and interface speeds
  net: phylink: Adjust advertisement based on rate adaptation
  net: phylink: Adjust link settings based on rate adaptation
  [RFC] net: phylink: Add support for CRS-based rate adaptation
  net: phy: aquantia: Add support for AQR115
  net: phy: aquantia: Add some additional phy interfaces
  net: phy: aquantia: Add support for rate adaptation
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
  powerpc: dts: qoriq: Add nodes for QSGMII PCSs
  arm64: dts: layerscape: Add nodes for QSGMII PCSs
  arm64: dts: ls1046a: Add serdes bindings
  arm64: dts: ls1088a: Add serdes bindings
  arm64: dts: ls1046ardb: Add serdes bindings
  [WIP] arm64: dts: ls1088ardb: Add serdes bindings

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |    1 +
 .../bindings/net/ethernet-controller.yaml     |   10 +-
 .../bindings/net/fsl,fman-dtsec.yaml          |  172 +++
 .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |    2 +-
 .../devicetree/bindings/net/fsl-fman.txt      |  133 +-
 .../devicetree/bindings/phy/fsl,lynx-10g.yaml |  311 ++++
 Documentation/driver-api/phy/index.rst        |    1 +
 Documentation/driver-api/phy/lynx_10g.rst     |   73 +
 MAINTAINERS                                   |    6 +
 .../boot/dts/freescale/fsl-ls1043-post.dtsi   |   24 +
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   |   25 +
 .../boot/dts/freescale/fsl-ls1046a-rdb.dts    |   34 +
 .../arm64/boot/dts/freescale/fsl-ls1046a.dtsi |  179 +++
 .../boot/dts/freescale/fsl-ls1088a-rdb.dts    |   87 ++
 .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |   96 ++
 .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |    3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |   10 +-
 .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |   10 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |   10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |   10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |   10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |   10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |   10 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |   10 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |   10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |   10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |   10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |   10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |    3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |   10 +-
 drivers/net/ethernet/freescale/dpaa/Kconfig   |    4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  132 +-
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |    2 +-
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |   90 +-
 drivers/net/ethernet/freescale/fman/Kconfig   |    4 +-
 drivers/net/ethernet/freescale/fman/fman.c    |   31 +-
 drivers/net/ethernet/freescale/fman/fman.h    |   31 +-
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  674 ++++-----
 .../net/ethernet/freescale/fman/fman_dtsec.h  |   58 +-
 .../net/ethernet/freescale/fman/fman_keygen.c |   29 +-
 .../net/ethernet/freescale/fman/fman_keygen.h |   29 +-
 .../net/ethernet/freescale/fman/fman_mac.h    |   34 +-
 .../net/ethernet/freescale/fman/fman_memac.c  |  864 +++++------
 .../net/ethernet/freescale/fman/fman_memac.h  |   57 +-
 .../net/ethernet/freescale/fman/fman_muram.c  |   31 +-
 .../net/ethernet/freescale/fman/fman_muram.h  |   32 +-
 .../net/ethernet/freescale/fman/fman_port.c   |   29 +-
 .../net/ethernet/freescale/fman/fman_port.h   |   29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.c |   29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.h |   28 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  274 ++--
 .../net/ethernet/freescale/fman/fman_tgec.h   |   54 +-
 drivers/net/ethernet/freescale/fman/mac.c     |  653 +--------
 drivers/net/ethernet/freescale/fman/mac.h     |   66 +-
 drivers/net/phy/aquantia_main.c               |   86 +-
 drivers/net/phy/phy.c                         |   21 +
 drivers/net/phy/phylink.c                     |  161 +-
 drivers/phy/freescale/Kconfig                 |   20 +
 drivers/phy/freescale/Makefile                |    3 +
 drivers/phy/freescale/lynx-10g.h              |   36 +
 drivers/phy/freescale/phy-fsl-lynx-10g-clk.c  |  438 ++++++
 drivers/phy/freescale/phy-fsl-lynx-10g.c      | 1297 +++++++++++++++++
 drivers/soc/fsl/qbman/qman.c                  |   76 +-
 include/linux/phy.h                           |   42 +
 include/linux/phylink.h                       |   12 +-
 include/soc/fsl/qman.h                        |    9 +
 69 files changed, 4408 insertions(+), 2356 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
 create mode 100644 Documentation/driver-api/phy/lynx_10g.rst
 create mode 100644 drivers/phy/freescale/lynx-10g.h
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g-clk.c
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g.c

-- 
2.35.1.1320.gc452695387.dirty

