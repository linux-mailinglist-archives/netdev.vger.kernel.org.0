Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B015EB0D0
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiIZTEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiIZTDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FF38C01F;
        Mon, 26 Sep 2022 12:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaaQZzxwu93M6dewM5q0mS2bwXSjzOrZeVY++ROqHR0xiiUra3ydcheHTxsyZL4pvDUbMXNHWdpNugQkLNSmx3Cacpd0+hHqNG+bcf0hXLraXzMgNgKTKKfp+Qwoejrd6Uci1JuyQgzZt/RjTwhtoxJgf2P3l+RpnWwWWhrPpjtSjSJ6y+4T3+fVBUBHvLfwtLrcw8HJQTVQxj76QlAFod7bdZe6NZP/pqtt8G7cJP5VqbPu0MiX5tV469SgmBFmlZdM1NL4QEtWJ8TeixFbdsEMqpmVsbnXHaD9Xq8SDoQL3V74FKBHVYQ6Xv9EmjpXWwIs94P1B6oAe0AIXZzAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gA5yQTC7ukjGTj/kXU5vOE7P46JCeTyJjtqlXQ+W0dk=;
 b=A0tnLTrH/ePAZN11jSGRFXuCcafid2NkGVagJrcSxokmS4GXPeP3fVUk1NhoMAgiZkr1wwob5CU/5+oL/jft5kxQQmlSzbGax1t78UUEXWpWDx//EOGhi8yskdrZyxCjbAiGuAbUfzAg2OCASWubiLjzGxGLFp8f2kLZebHINo5po6Feo9jPvrZanwM8JvCVlM0Ze84K7tl7utlSix0X8/3jrR4V2aC3HzZNOe6cP/VsM9PM+o8NHKKwfX9fFnu2O3WO9zEOhvjbYl05n5fexAlM3rYej4OizYjMcxiK0SL9u5nQl/jX1zH9GW26iTAtt4VIRbUAahYZkZs3O0iO1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA5yQTC7ukjGTj/kXU5vOE7P46JCeTyJjtqlXQ+W0dk=;
 b=lnJ/aqNSd1mOlFAA00RKdJ2tnTqSE1z1rCLyDfRjSgfvL+egrpNE2fM9IVQjHmXTSTNmjQ8yVsOeL4UbycdM77DfB9ImPL9V+Eu7GAZzB5JIRG5zpXnFLTm9/zQ2XhHuFJDuYmcqIW1Hc9gk3crBrxigkMZrS30el/6m8Kunj7T8lh0zvd+gsAjhhu2tlnnfU1/MNeUju39FNCLuVrspH5AVeNhKz21880BjHKg3iLhEOcumXW2weHwLnvyp+LbozxFlbggSvhIGqpPCEFd2ZPre/+JuCyJN9H4CBmoDoDgBEKpnQjThvWfp8Z8UPNtsRBdSLnsXva35gpvaf6vRoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:32 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:32 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v5 0/9] [RFT] net: dpaa: Convert to phylink
Date:   Mon, 26 Sep 2022 15:03:12 -0400
Message-Id: <20220926190322.2889342-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: ad1e1957-0a0f-4931-dc96-08da9ff1ce46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isWP4CLpiIFh5Apdftrt5AKxEAuAtGd8js3M+GBDG5kupPEBoglAwMd6duOYnqK/MFjyOjyQWJKntKOB+XsjwtW5NthhrVGB6mWY/V9t1V9Hw++ChoRlwDQfgIkIo0kSnmIuQRseqBXjnfiip2YVa1iQcv0uSEhXB61251pTiB0htOQSe43+rvH+gb/lJkd1zJLyO4VvWvUCrd+BGxRCEkGKwhslWbnkPzuq+BxV8AXpUNvbihH7iW3b/x1zQx+Z9n/FzLGqP/kxZN0PGRSINnqady8I1j6IxgDAVc0UzMm4iqSFJ0JkM8WRPkHKoX3zVMn4Kh41HdHJUR0BZ0wFTcCoobGo6BsZYjPZyJ34vzmLNAmXtyJzo4HWLAcnWMm9/0HIaLnZIMOVyKh2nzTvs0AFsg+TRKMJZ7xg1YdGCoAuGD5EWtevZPQ857sGOCYM6ObDdJ3eQc2jA91HKqzvpdK/fBlS8/csTPY3DLOcAeOzbmYhhuwNueu1oOZll5YlQM4ETupzjkydEAUNkItKPGrgZOQF06j81GknBwwefpEhbMQl5HsXxIk805qfyHFabRplgxrsLt+hSl5kwOOJj+O1kis0aJImV72Z5ZqFC2XO1wCzxUHf+lhPZsgm24eNlTLYdkIBw0oBLkAGgL+GcMCOU6G8G8HPhzWtwAhv1b73lkKRO+U31wVQg9+RieAG+xXOiI8p0OIztK+6JSMdVQs9hBJdtI1hPpXg8XKgPBkJJs4VdZK7q516dK4OYuEK8dCZp1aVmub147rB1KlvBmPeQMAxI9L2pP98jYsJ4IY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(966005)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F7v3G4XFrVyeOeEgZFYSDX6FUdzia7/8JB46cmkgLyYjU7recVpsPcEYyNtD?=
 =?us-ascii?Q?fZ4qkU9UUX5ixBvSEeaPBKFQexizLgLLDhgweyiDyO8QFcJhW9VM+46PWWWL?=
 =?us-ascii?Q?DxbVsr2aIEjctgvmRhnGnSMTt5xOLP21WQrvpwG5eE5S2sjkSggO+7AsKl0b?=
 =?us-ascii?Q?5JfCDakfdcYaZaKszG0eYf4i76oQQCKJFAlXHkIeqYJx/vVfi3vVEv9VjhNG?=
 =?us-ascii?Q?r6kcN0nmAIJDbaQneWVeYuCgvY5jWf2GGYT3GNcduNVDJAuv+rwnnUMzvl+1?=
 =?us-ascii?Q?50tlzuZcIvRJXT05tpIJLOVaHoXEZsVT1KJ22chVSkQpyDcDlPqWNTSPOlW6?=
 =?us-ascii?Q?u3VGiBzLxYCkJunwrV/XO89o0ui1nsApxMOLnheDFVJe3AnVT9NJJON2lQfJ?=
 =?us-ascii?Q?9IscA6tD5QKtMjrxQgqoa81hlnMpc12yGql3sv8jbz+ASVo5BqfEhbxNQpeE?=
 =?us-ascii?Q?KeEqMrL21CQTKwVjXLyYMPRdnHowd1QbBzuafMnjMhefpgt10dX9/W/NpQr4?=
 =?us-ascii?Q?VM562ha/bqri1XcuLpyLy6+Py3LjcQjamzJ3qUBuowHTBVL9r8nhou9fyvug?=
 =?us-ascii?Q?g3BGKed4rYiAfHDSNd3s1IOVAk/HkzCK6XUjtjxK/y19Li8GbXbi5ImNhrYw?=
 =?us-ascii?Q?c8E1jcH3iSICPLsSbLoRMwdhvmGa0VVTb74pfD/YhZDdN8bV0+VOonOFShzA?=
 =?us-ascii?Q?hkgTYuaxFaoLjZ1haINfZagILw9XhOES5HbVtOJLqOqp9R3kQJtzsuxf0BVA?=
 =?us-ascii?Q?SfoGq0/rU8yhPLRYEGZx20cNc6wvcBylNqhIDqXl8HsvxvZXPKk3IK0Z/dhV?=
 =?us-ascii?Q?Nr6Oa/e1S6vEXKYTH1bMaiHYzJ9wTFbj3cS97t1w2PmLx8eIBdZesVVeioBx?=
 =?us-ascii?Q?IQyZzPxEO9EhQoTi0Vdv+Ri80uOpRBHL5wNUB3dGPrSw3ZtiD4eLrF3KmE8q?=
 =?us-ascii?Q?rXaWh/Z07e2hLTMDzp4JKnEWLBkDcFMygWca0ikk0hRy2Qb5SXdeNT93Kdy5?=
 =?us-ascii?Q?XCnJP9vMkge+xCN06DyPz0WBM/HrfciZEj1y0OpI+bxTSaPAzY0nL8LqNMb1?=
 =?us-ascii?Q?WmRS/Gm6Jb2giRQGlgV5k/dQtTvW2qLGErxjdvOKIEuKK68tIjmiyroZng4W?=
 =?us-ascii?Q?QHdPvCHKjwq55+mTk9nkUQVygozvFydFb9c9LA5xFfMEGUqv+VZk/PcVc3lI?=
 =?us-ascii?Q?xXCn30o3yngHnhcC5BJVvojrE+gt1ODUTo6dvax3YpACxcLFYUngez7QLkXu?=
 =?us-ascii?Q?VyLFCmKt49d0mCAsby5R3bwNNQAFBaijw6Zw63hWJ8q5fnNiF+RJGB5ORBjI?=
 =?us-ascii?Q?Et+/AHt9i5lOKM4/sCvGRTDVwrNjN8B7ry7HdQrAR5ZmsRnSEHr5p/vgLvaS?=
 =?us-ascii?Q?U+Ru9jVWeLinHoSecHBE54YtoajcI7Gjp/cQQF60WTXOHdeOTEq5i+5jNuOg?=
 =?us-ascii?Q?qpKN57B8fs0VXw0259o94aO4/SbMdpoDl6MeGX1c5nGo4F0Pmr9JxkeHi9rn?=
 =?us-ascii?Q?MTc1uFRc5C+U+seVIcyb5q0uvLtqJfGZ4VO0VOb5Q0l5SxBqrmCabbutRum6?=
 =?us-ascii?Q?1PaMcfglz/4NgXi9VrujiE1V+Ru9Wyy832rgqthMxwMVtUqI2TZf7kX+dTHs?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1e1957-0a0f-4931-dc96-08da9ff1ce46
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:32.4437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KoIi4ub2/0hq/wB1ouesYHSZIdfxCSL/PlPQc6XYxajIhsxVzAgzkqVM2r/XJEqfRStOjVzJw9M3t9m2dFJ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts the DPAA driver to phylink.

I have tried to maintain backwards compatibility with existing device
trees whereever possible. However, one area where I was unable to
achieve this was with QSGMII. Please refer to patch 2 for details.

All mac drivers have now been converted. I would greatly appreciate if
anyone has T-series or P-series boards they can test/debug this series
on. I only have an LS1046ARDB. Everything but QSGMII should work without
breakage; QSGMII needs patches 7 and 8. For this reason, the last 4
patches in this series should be applied together (and should not go
through separate trees).

This series depends on [1] and [2].

[1] https://lore.kernel.org/netdev/20220725153730.2604096-1-sean.anderson@seco.com/
[2] https://lore.kernel.org/netdev/20220725151039.2581576-1-sean.anderson@seco.com/

Changes in v5:
- Add Lynx PCS binding

Changes in v4:
- Use pcs-handle-names instead of pcs-names, as discussed
- Don't fail if phy support was not compiled in
- Split off rate adaptation series
- Split off DPAA "preparation" series
- Split off Lynx 10G support
- t208x: Mark MAC1 and MAC2 as 10G
- Add XFI PCS for t208x MAC1/MAC2

Changes in v3:
- Expand pcs-handle to an array
- Add vendor prefix 'fsl,' to rgmii and mii properties.
- Set maxItems for pcs-names
- Remove phy-* properties from example because dt-schema complains and I
  can't be bothered to figure out how to make it work.
- Add pcs-handle as a preferred version of pcsphy-handle
- Deprecate pcsphy-handle
- Remove mii/rmii properties
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

Changes in v2:
- Better document how we select which PCS to use in the default case
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

Sean Anderson (9):
  dt-bindings: net: Expand pcs-handle to an array
  dt-bindings: net: Add Lynx PCS binding
  dt-bindings: net: fman: Add additional interface properties
  net: fman: memac: Add serdes support
  net: fman: memac: Use lynx pcs driver
  net: dpaa: Convert to phylink
  powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
  powerpc: dts: qoriq: Add nodes for QSGMII PCSs
  arm64: dts: layerscape: Add nodes for QSGMII PCSs

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |   1 +
 .../bindings/net/ethernet-controller.yaml     |  10 +-
 .../bindings/net/fsl,fman-dtsec.yaml          |  53 +-
 .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |   2 +-
 .../devicetree/bindings/net/fsl-fman.txt      |   5 +-
 .../bindings/net/pcs/fsl,lynx-pcs.yaml        |  40 +
 .../boot/dts/freescale/fsl-ls1043-post.dtsi   |  24 +
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   |  25 +
 .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |  10 +-
 .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     |  45 ++
 .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     |  45 ++
 .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |  10 +-
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |   4 +-
 drivers/net/ethernet/freescale/dpaa/Kconfig   |   4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  89 +--
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |  90 +--
 drivers/net/ethernet/freescale/fman/Kconfig   |   4 +-
 .../net/ethernet/freescale/fman/fman_dtsec.c  | 459 +++++------
 .../net/ethernet/freescale/fman/fman_mac.h    |  10 -
 .../net/ethernet/freescale/fman/fman_memac.c  | 746 +++++++++---------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 131 ++-
 drivers/net/ethernet/freescale/fman/mac.c     | 168 +---
 drivers/net/ethernet/freescale/fman/mac.h     |  23 +-
 39 files changed, 1073 insertions(+), 1050 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

-- 
2.35.1.1320.gc452695387.dirty

