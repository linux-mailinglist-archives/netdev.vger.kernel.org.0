Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9D458A16F
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiHDTrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiHDTrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:47:32 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB3D6BD53;
        Thu,  4 Aug 2022 12:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drcJis1A8rhoNlDKUT200t/WumLWDXp5QiKFCtsEQpaVcm1BBa403DEins35tY3z0DlgZCqjO2TRoiwRSsfHcSQpkT0tK6oJmT3N8m+fg0eO0Eg3YawEPjE3imtumuKtcxi0+bvcIdWTJlEzw3GlwUtYRBTwtNhSWTPAuZ/qsKfp7KV9wbEi5GXsU9j5Kkm2zf7XhxhxRpH8gY+vzB00RN477aubn8BjLFNE/sW5Ip9MXTf2gC9LlIUqKWXHFscRsaxCVfqzbjTjLCwsYJ9hbYYsPW53Xm/WNTUdaaAvniFC3A+v0AJSojqAmzlY970bEKm1+BPCE7KzBB9J/kmJ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWtcyb16todd5BUAmtbdM+clRLLL8A7cQ0XyyurB1OY=;
 b=XU/USYEKe3m5w1zql7zUgj2c+/I6nm+lgeufbqEkqSCpn2IaXTtw4kmeVmflyW9rr6AsbEMc2I1g7RnoEobJrug0EISvil+EkZCkQ282P4jcJvKkWeNiyfUNVZGt4LJsrR92FkfbdjLE+jiuF7PuOyU0rRO/qBh0pWDkeJvy9HnMGmvLXZs88uYvSyK+DMlBDwiilXnXd6aSPQB0IHLj+WI0MUnibwj4FfAW+o+uW5jgPzbdGcVPS6DGHt08O9bf/1TV0Xk4cLrM4Xol1ULHFQhJiJgu4alAxvnAJMd8ppBb2Odp2Hey3JtZXzQJsJMxHeVn1EYKFTNcIlW2ezWxew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWtcyb16todd5BUAmtbdM+clRLLL8A7cQ0XyyurB1OY=;
 b=HC5TRkhLS4w0HBhux3ucGJNEyRvJ7ReCxymGw1RQ8PySlnLSB0/Ords6fAHMjNkPayY1ZjTE8NqTR3UBg4CjsL6yEG/WAwP8gGYWmT3I8m8Xm1/mvxsW2uX/51MwDZynxUmLl0n51RW+BKS4Lk/uHgpdtwRL7Arp+QuJScXW6fGpoWs9tIoZpiFdUp+keDXPIkzlLfrOOHS/2jnW0li84QycnBw/yCuHsrjnfWnjnmgEfN/XEDAquDJYqtljxm4ZiEXOXklOgo2ymH5MO4coeTu7Ey9H0GqUJw2NQ09nIwvQN6IUFaXuwoP0+yfiJ/ldJrLiRPcsHaqu2x5x0LL9Gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:25 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:24 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v4 0/8] [RFT] net: dpaa: Convert to phylink
Date:   Thu,  4 Aug 2022 15:46:57 -0400
Message-Id: <20220804194705.459670-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fc50688-33f7-40c5-df86-08da7652276b
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elbGVIz+0hsKH8xNubygsCgEw03FNXikrnbXIEPjiRYT0fdxP5uzOyoDgOEXWI1JARs7vOqNBYXRXiWMs5MN0fvgK8wWQoisfRQTCBWy2LFmesOilmpLQn5x2SyCgXxT4gwo9a9NS9xGwfNcaVG8AG2alAzceFMdM+R3tfwQxrD2GFxLAQYLXg8RQBXxT0pn2VFANRkoIt5Ei2uD1EZDo2gUTijdzpuSaruxf2vFt159jGDRb7gZtMfdp6l1oFgZogilswnEjbx3aHSnq7HTlwMlaAdhTKsBYmiH4myY1bI0TgOo+/14zIatYu5SnoV6sqRLOf3VuaqNT9VneyyeHYbQTSikQ7kIFFSBiupgcoAY/C0hTfguhCiyPHw2MKDF3KA2m6oEOzQDSYiQadZOP3R2LIsFGrFcVLrhnOrh4vd2ORx2NIqInl+WIhbqXYm9vxni+BBjHO4v/eqk31+dK5whPXUiaFQ6UTzMivX9vvV/+61eefQYK3OxrjGjtR2nAqF+enOOy5kYrsw2BaRR1kqckIjthkjOCr/dSwZQNAc3GMfzamsC4j8SS63WcvWAJRHNOUtnn0r48lgeDXbLOh2bIUizcEO/3dZ9HS5SAn06y3zeHyowE+ck4ZrreFB1W028uxoj461tzV4tzpimA5qnSNpoipKMJE/rKiz2yg6PX1bMpFOBZmbTZP1hNI9sn5NtU3egLY4f9ly+LKoie7j8Bm6FJMHyssENfs/s1N7xDdOBQo6TbNRsGIFQukxBma0lrP7lFaMGDT7BzLjGr3Q+ibiV6upPliwXoqgWIj1bAEUCp5IhZVnUGppOJ8Tn48VVTN0aV1r9TQ4xAvpozw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(966005)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(83380400001)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FKnqtfKzbm8AQm98ICrDbSp431K6pXyF5WOQMD9o3kLxd03gycNMEVCv5vVU?=
 =?us-ascii?Q?6odnka+O2NoA6n+N4RZ0xJHRVUCKWh5Ce4bQjD1P+uNQatlqthgsmUY7ce5w?=
 =?us-ascii?Q?j0hLBf/euDo7HxwEqSMkMy4AegZ519HlgCagLAc/lCdJQU1DR0ua1MAOVQ1B?=
 =?us-ascii?Q?pgThr7lby3ahtE4Ri+5f6DH739/M5UVJDYS02+XixYjMNSHzq9ZJhKmRPPfZ?=
 =?us-ascii?Q?nj4s8mVZV+eCRrcTPoif0IBrvbP3g+AVcg8WhBY/Zl/9zcjncHWp783m6fFb?=
 =?us-ascii?Q?+AGHAbkDyhHBX82e3k42p2C4tV+uGX+G80w0yYoD9hzvlZea6dU04DpEGXEm?=
 =?us-ascii?Q?LzhTBISQKyDw9VRKWJc1M2RFPze3T6J6kph170paZ+X+Bkhvzu0Z6vci6GZy?=
 =?us-ascii?Q?w6oYhDi6Fr8V8rrLx7w5gh6Iyxl3RrHHYaK2GQzzsJMyIDSwcAZtkzIKMgcy?=
 =?us-ascii?Q?cGDIFkJLBHu5JEsrpR2pt8ghTxnjKWUMerKhHJq/FkSL/vaQybtYkZpR1Qkd?=
 =?us-ascii?Q?321UGuQNzA2jIvimmBLc2p39vqRj0unDPxMZBA8w4S2GuW6nSBz6JNdSMrPp?=
 =?us-ascii?Q?lVcTZvpz7BWVSdaGUM2P1ioJ1Q0w/gMBCJnaJS0KrfRf6FiIF8ENPqJRHWuZ?=
 =?us-ascii?Q?vYPzdcfif7+WWA0tTbYwSNUO9Z79cO8MlAu5T7/u4gq9z4oYlWodzt4rNgF9?=
 =?us-ascii?Q?V2ll/gd1VWvb+tuIr5A7238IKCtwjYpXW2zpzKMGr0JXgv68yYGKcOljzZS1?=
 =?us-ascii?Q?N9twL5mz6X1/uLIydNg1GuTjYpCPvAGlbY7EbuBLdRXUVmfyH7gMyBUI87ZH?=
 =?us-ascii?Q?rYvrwGxZ0/x131GAp1rP40KO85LcMt6iqs7fQ+1tu0Qo+vK8KB+oPW7KcjUC?=
 =?us-ascii?Q?jFhaAa0BDGVCRm/Jc8EGcH2nt3egx+XZBUdVHRJ42vhMcPRO791Wq8c8W21Y?=
 =?us-ascii?Q?TeFOUBtTzmz53+/osLbgbKH7+dqrdJIxiA/QjEULYbUjaSPo4Q42nOE3jh4U?=
 =?us-ascii?Q?h1NEPvBX3qyMOY/57L0XDb5MqMh+etk8umPqE4DiTZ4XqXOVB0xVfM11H9+Z?=
 =?us-ascii?Q?i3hQvOKS1b2gB6pwoo3THfOz7udVm2KqIrdxi/3zdd04+fqr9eAV2vIqSe4P?=
 =?us-ascii?Q?2Fjz/LjQ70gPR8ThDm4XucxNMHnXvSz4xTtYtdPeM0x4p9DSm+aot8xfPr+X?=
 =?us-ascii?Q?FVfxv97dhEYWovAnoFzVi64ET9sE4lkqKWpK8gNrcH+zBKBrZG992U8PL+qY?=
 =?us-ascii?Q?le8I0Jz/8+0+KwR/SHSp2vpc4adZdpXdkBlmHv69A6PIVfJNjAdwSRePKd89?=
 =?us-ascii?Q?QzCcH8ZaUPioBjyk5C6MuJz5VadwiqXeiNhAuemRiV3vkmfAFfw5PnZdcfS7?=
 =?us-ascii?Q?ogA/HGm1NKIchCkVLhuAHZai+QLBLOGQpJZy1gxv/UgStxtWMXxM3oJM3t41?=
 =?us-ascii?Q?F/8DFOJOq/Vh3mtciSCrHF6pldWnGY+5IU6IkgqTcKVCU2PExau4vh+pvtzj?=
 =?us-ascii?Q?mEeld6DWnKqMuUXYTtX+zu5oX3YjZInnAuaZxv2jdAInhKtRA/EECX1jiBpe?=
 =?us-ascii?Q?sEEy1hKaDs8N6rf9pwTSC4TlIz0xWkxdLqBAk551TtzgX4VwUqgsPNyuedE1?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc50688-33f7-40c5-df86-08da7652276b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:24.9310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Je9Bcx+pKP4TZN4jonCcEvoJqh9UxccK8djp/NRxT8PPQVUqCBBtJ2R/chKaw10H+oQy1IYPG+TJpTXyQ24tzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
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

Sean Anderson (8):
  dt-bindings: net: Expand pcs-handle to an array
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
 38 files changed, 1033 insertions(+), 1050 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

-- 
2.35.1.1320.gc452695387.dirty

