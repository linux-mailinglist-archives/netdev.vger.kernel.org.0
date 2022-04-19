Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E011C5069C6
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbiDSLYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241315AbiDSLYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:01 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60071.outbound.protection.outlook.com [40.107.6.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD1BB9A;
        Tue, 19 Apr 2022 04:21:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECMzXxVN9ZW5y7Us/vGY/q3aDjvlr75h5gCKGZv05j9zffyd4BhagC8Ckzf+Vj6O+bwuWCDyP+AEfcLyMM9SwSawsyzHQONrCChXzxXRm7nFmQ6Ay1xXaFAZfDAiIWCzxEzTEfIDS5Kz2kwh2gUxGW0EwfQZEbKmSsApmA+uvNkcrz+hpA1PwLOjiAmpteu2n/eumiEILnGFoRvzRL+xL9S+qnvyL2aQE/0Z0bCWCKhO3A0KHAY1GHEO01EHBb7jmY07JecsyUMz5mkJhCINYq968YO/MdHbAA7U5B2IuXOhlJDMMmpOc78pIQgt9T6xd3HsIRcrjJZK9KPQQLw0eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNy76uROItMrulmag0gLNpCpM2i1cFBvEdX/II9iSxg=;
 b=ekA5TRL4T0GzFrIk03DBl6YOLgUa8hssmn7I2ms5d1G2x/zDVtaS21KjMBAJ+VSNZD4fCMmVN+hHunCjpYCO/z+3MXm+cZMxv7BImI3U8OL7SveppH8av4uikcrlNFA92nnrVlI4LLEvBQsSpI03ttwvBrskuuzAR/7I7ZZAd+e4n//KO9vGrZ/4mBQYR3FcPLQ/npHxEX94rG86Ry+JPvS/1iS01llYGK1NfrLSitMp+r1WLs/321xtsl2lKZYybcgkHR2AS32WQ62CzaMo0BPt+80lZAcRiPT5GYGNaeylwaNz+ggPLXKsYy+6ej2hVID4qqBPRSh5B6Q2aMFdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNy76uROItMrulmag0gLNpCpM2i1cFBvEdX/II9iSxg=;
 b=JrKZaIdiRdtseu2D+f+RV5woHHnRv28ikjO1qJ2Ivn9ISGBnk02pqbKxgYW1SKoB5gxwmalryWVFiu8uznZN2WDSxDuaLTuBc8Jy2XhxhslRCTMCKaoaViDLPPchEsXzqGa6ukGsH2gVQs+KkOeQT033nV5RG5bwzc2QcQXmjJo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:17 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:17 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 00/13] arm64: dts: Add i.MX8DXL initial support
Date:   Tue, 19 Apr 2022 14:20:43 +0300
Message-Id: <20220419112056.1808009-1-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::21) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd5718d3-2e57-4b62-2bda-08da21f6b87d
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB75380D0C04A12843970E5C45F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: of50z1vDmBwNzMFdYzoqzBFkaEKYg/lHV2ZLJzKAbSpwrV5qujgFN6IRNvTVfUC6RaY2pEBRtICdYO58a5aedmkxnRE85j03hYcGuBjvvoCsMDLdUbUh2uEl4gwqxgTWYjpHuOToIaj5tTcZL0i1YDQlBvArWqDrFNWZFtzXwRLJoKEQF1cstlmifhfP83Vy1mvH/KwO8sQiP/embhxgo+ZZHChhTwpEExQsRectenfZVW6hF6UHMZ1PpL878rs4igWu13yTTQN3qfmiE3gnHI3e84WtCMSthCrUZ8HZk53A+h+yOh/8FJQV9AMiYI3Gqgg1yZTl1JQSfgL8F2jrJM0Ow6ne0o1EC7q2tbMKK9F2p7FBVVwb6SaDzgoe1Ed3pQAfJifBtAVX6XL8LcCzQCoh64nWeOTedqF3u8Zr0Lppe3CtZ7wj0Kc3fDKMwKz/ideE/pKrNn4gbm+6RT2L7SrAAYlE04kxyCCKvWppwlsaWYk0ZhiRhMrlJd6Ib1v1fP/i6TraHQ2xfxX9CdQ9ArNCsb0EtCDmdBtFh0XpKEmWOkS8oyzbr4PXQBfJMc1OhyrY4Mg0hNtYfOfaC7fsJRi2KmmOy1XvnIjcE8/BzH2l6qCq1JOGwTocT1QumobUlg1sokRU188v1v/J8NERe2uXM+QYPVjXTS1dWKJDYBAP/LjmwFNwdrPv/2TiEDzJefAzAElxHfcwANzxcttz4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(83380400001)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lfwKOT2UBSw+Ih172gZrMCZlF6MNn37fp0Xx0wUQvNK/cL2ARwud61WhgEI9?=
 =?us-ascii?Q?YkEJMxZlRf6XyKNSYZBWEg0bl6Y6FszKTCnJe4TMUPQzaPGcOdc55ChI+7JY?=
 =?us-ascii?Q?TGusfS/hoM8aBmOWhSUQSGCLo3eJKGHdH7aqVMFpUd3c3HrYYnv1DDoRCQyJ?=
 =?us-ascii?Q?3hsPaHVulImSpvCzF9AtkJuzBlmQfUaLdUiCZl0LItfhvvqgOb5OoG4TbXdu?=
 =?us-ascii?Q?NrAakjFATSQ0WGCP/E7ACNu4s656xQ08LZqd4FJtEjYh5+rMLq3ONPV2W2R/?=
 =?us-ascii?Q?ar7nYaU0RomatVCrK+VexQfm/vUftzjymf44DfEmqKqD30oyiu1f9fgUkC0l?=
 =?us-ascii?Q?toY5AkIaHKQH8pJOW36jD9/hi9ezxlrA4QMnqnS7ChDBDC1fblvoIiUDmCOP?=
 =?us-ascii?Q?UDTGUqPy/XGnphrkmybUszA8hHYH2YV2f5nWHu14zYygFd1eRnpmTZx7aZcl?=
 =?us-ascii?Q?IFUVRFJBrhjuQcEbUroycWYAoZ6OmV3JzZxwOPEurg75DHjOpXfsDeaBQRj8?=
 =?us-ascii?Q?Ib15TCP7g2/Iz+hbs32Yb3gVl7YU0im7EiTQOsU3295v2D+GSPOk4rKWfAeR?=
 =?us-ascii?Q?DOvERqexdoQhSKsYQ1Fhs+gbePFt369OTNPzq9/8+dv983YhOllqmi8mUL3I?=
 =?us-ascii?Q?xqhqLGeYvr1q5JOhb/kgJRly+OexE3qFS6RzK8Q4Qm8rQ04GqbsHVjV2Gaj8?=
 =?us-ascii?Q?1a85CvC/yvGTjIVOTy1IbKX8RjAtze7/TNSb2X6QlmH1hmiI0RyY8LCwx2UC?=
 =?us-ascii?Q?IV7dbU5KTpYFEGaw2LZl4U+8qoTGLSGuIHIaWHD41v4cy3fmK20omP4UBbqA?=
 =?us-ascii?Q?ry31zsuYrQwGIndGkGUDMyWBr2oJiLet4rZ7yBekO2fNBubDr12qfQKO+SSr?=
 =?us-ascii?Q?RCxyA5u/rKCXqGz/0kY4tjciWNIxf/6iX11V/uZJXJwT9q1eN7CSS57rjLr2?=
 =?us-ascii?Q?/8blIusj6+gEdeqDMwTRHbp/9mMvAPNWA8MbG15wITsSBv3V+l3tT1QhdVO+?=
 =?us-ascii?Q?cxDQHNiW4UyCjZ/ZV3Cta94NmjqJ6OJ8GmKlOWNyuAS3v1/fN+2RolYOGYKI?=
 =?us-ascii?Q?5xTwnNzku5vHAwV9o2/mJptaW5HhBHhazvGfqaRE3zvNTSkhPqILjuvmsL4x?=
 =?us-ascii?Q?cvDVFp5OWc3DzasEql/m/N0Wd4/ZNN2RMday+GNQkZkdiZm1AiWUFa3+05BZ?=
 =?us-ascii?Q?1mEKOYHLf/IHksBq/UyyVnCof7A6hbEylOBuWOCeTsr0UkbqoMuLsm2bxfvk?=
 =?us-ascii?Q?bTdnXJCGLvPsfaCeegLOIEaeQeIadFSBXFSGDh9/s8bR4636KEDvl5s8uY5j?=
 =?us-ascii?Q?RXywMJRaNGF4IcyohPbTIPz+j+Jd3J2DfxrvD0x+z7IqrtypJ7LX2UVx2V94?=
 =?us-ascii?Q?CH5nOCPU5l/rrwKBnvmQq9frjd9sdltW+NWs4M4PT5gVEbDFuaBFEo+Ybbgy?=
 =?us-ascii?Q?WRKIf1UsEOE6XJ7q4/uYFBFAFvFQmOvu8426oGBU4vmdigXExPl0kpjZgYiX?=
 =?us-ascii?Q?kKj/3y8SNCSvUNj2r8y8EUvY933/EmKjK3Pjc3jiMippSLfIqi4F2FbAs840?=
 =?us-ascii?Q?ldPVduQKsRwPFQ4SCR0nsVQZLOnxtOP94aWYq3XcbbELxIomQ0Obv2O9fcWx?=
 =?us-ascii?Q?G4Hp09VBM2KudNLebJtDjp3sbPTUvFZHrIrzy4+wPKPZHpPMZAk1R3HXcHcI?=
 =?us-ascii?Q?NAsNg/1A3/iwIOKlB64WzgHyAQU4HCNNfrZSJP2aX3hcp8/hlyQtQIi2dEwm?=
 =?us-ascii?Q?/+qH3p33IQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5718d3-2e57-4b62-2bda-08da21f6b87d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:16.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xz3Ngydv/NL7uXNw2NKgb+17GLhzn4MZgEpxclRlb3t4b4VOW03cxswxlGeUTlfV77Xt588HEzfwuRpUJ9hKKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v6:
 * fixed dts warnings reported by Shawn
 * removed extra blank line reported by Rob

Abel Vesa (8):
  arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
  dt-bindings: fsl: scu: Add i.MX8DXL ocotp and scu-pd binding
  dt-bindings: arm: Document i.MX8DXL EVK board binding
  dt-bindings: mmc: imx-esdhc: Add i.MX8DXL compatible string
  dt-bindings: net: fec: Add i.MX8DXL compatible string
  dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
  dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
  dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string

Jacky Bai (5):
  arm64: dts: freescale: Add the top level dtsi support for imx8dxl
  arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
  arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
  arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
  arm64: dts: freescale: Add i.MX8DXL evk board support

 .../bindings/arm/freescale/fsl,scu.txt        |   4 +-
 .../devicetree/bindings/arm/fsl.yaml          |   6 +
 .../bindings/mmc/fsl-imx-esdhc.yaml           |   1 +
 .../devicetree/bindings/net/fsl,fec.yaml      |   4 +
 .../devicetree/bindings/phy/mxs-usb-phy.txt   |   1 +
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt  |   1 +
 .../devicetree/bindings/usb/usbmisc-imx.txt   |   1 +
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   |  52 ++++
 .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 134 +++++++++
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    |  37 +++
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   |  78 +++++
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi    | 241 ++++++++++++++++
 14 files changed, 826 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

--
2.34.1

