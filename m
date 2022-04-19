Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEDE506A67
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351334AbiDSLcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244434AbiDSLcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:32:05 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00079.outbound.protection.outlook.com [40.107.0.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623B726138;
        Tue, 19 Apr 2022 04:29:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=do/lzpz79Q0ZUNB3gXuyPdkPuBvVYf2rEEmGr5lJCGA0Go4Cm82pM8gW4V6B1jknJDX0goANhkwQei+pWLEI5xBZRtPG9hr+7tn/tzVs7XlesQR6mHIhAIYfF8VwOjt1w34aEbTycepD92yvSWhdvpDPfjsABP8lKEmYsQdKMgIN3BdX+mA0J90qlztU2axUpzFpSXfvbPUwrUm3eT/5gRYiji/QYF722xTDcfoTL8A0rVXL/D3Sqnf3wv6TqzkmVjEG1ippIiHmA34eOexInKZ0ADIGaT6qqC5BIAdRzrfeB9c1MC0GVxgvV0L1zNbQqKAlN4tSDl5r11fmHWDyGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdisVf88XaiIFjsJzDAJ0HQMj7106DaKuWnU58TgI68=;
 b=jZVMTnjcJAPr4T0PyvI4d5FQYuFe4xUAAJYtQ6WqqIHb/lZaj5PmwtrZZDpECPJxzF3aYPyJHIFmeZmlZPNyQyEYgXZ45Ln1Az+pV0yLA3pxUhrR9Xb/1IIUdgDPKa3taO6HsJ4gDyElafyjFKEE+4JN2Y8ngNHyFDNeBQp59vMln4NU7sYkmGnQsKlA+ofF8kRj8Xpy8GU4uu3KHWxoNlveGsJVcXak/RIJrT29rIa50vRHNTpEAmMKtvh3wIjFX7ofdzC7lu4VVN6LIXMYCO1/vZRxswJAri0Cs4iDgfZQjWIm704SQRl4DV9th1ZcenrlVrMO+DEYe2DFxWzoLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdisVf88XaiIFjsJzDAJ0HQMj7106DaKuWnU58TgI68=;
 b=HEIF7ZNhYYJYSQL0aRoBu1XjdZxCwG3GWjQpnctSDWK8/NqSpieW3ZyTLZV7D4wCXz3XKPYWx3rqd+kji3I97QoiRxzK60CCjqkb2HIw+EKymxV4mw9zY1qWJHGA58Ph/RwHoC4eMKSYkYQjKrduL1k4kNk63HRcbKjpJQQ0B7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM6PR0402MB3944.eurprd04.prod.outlook.com (2603:10a6:209:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:29:20 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:29:20 +0000
Date:   Tue, 19 Apr 2022 14:29:19 +0300
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
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 00/13] arm64: dts: Add i.MX8DXL initial support
Message-ID: <Yl6dDx8VIILZn+1L@abelvesa>
References: <20220419112056.1808009-1-abel.vesa@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419112056.1808009-1-abel.vesa@nxp.com>
X-ClientProxiedBy: VI1PR09CA0100.eurprd09.prod.outlook.com
 (2603:10a6:803:78::23) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c88292bc-6a87-4c13-0819-08da21f7d8ce
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3944:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3944DFA15A685CABDC07B350F6F29@AM6PR0402MB3944.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jgCpwD9qDFb4ceLO2mhfSh3uWAxoSnA7LASrD1CdV+Zpe3eKNYbbcqyyN1q6e7BCLMrtFxkHbeAZ1JwDul/e3o7PxwlRtTdSw+BaS5DRLL7hlB49Pirmzx9MZBLVjvLCFOE2N5r9/APJadm4nd/AriAWm3wstMQxS+L9GBTuone1JTO9CgmrYXTTc48FcJngv9Yki3NZTp6KLJ8jBAs9qBiwdPY9/xYthuAECLRaGErU8E7Wm8D52QzF1qGhVsZT0MN4aH/A9PvID/3aohF1mWeoWNutBb5Sn0M+PvhUY/D9UUvI/26/Uhoxz7N295yaS+GFoff+7QiZbX00FoX+0RMYOUItUaqoDh+TZ0PpOqUt4MOHwMHHTKmdH8nlG8lHVVuhA3+l/hkb2fhOzXk0HdgEISfZjysqDr0JGR/mUsvBBV8dKEewjgIpagmI4qKMcAjpBcSmNrKWn1U4DxqumaTVL9oqhn5q89Q/8ebh3Z7U5Vu2QxY/cblwwxnGFbzyS1OxiwxGfhBVwdDGT7tf33crQubzUU7yN8x96/66sExutYp9XmLQZYik4XNLAP/egFJx2Gmr6lYbotNAwoIuaW0saK64nbQwRTKEcZ6ad0w5P7wbEf07Lq2ju5FeeOS+JkOzMJqM5aPS6ehqpv9JcS7D/DTkKdN1UyNtIFW2HWESWL3taXoDwZ9HKYjAyieYpHRpm4mmJKg84LXYIWi8EH8SRW2rty6sGIstbcuDsGQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(66476007)(6486002)(508600001)(38100700002)(4326008)(66946007)(8676002)(52116002)(26005)(83380400001)(316002)(54906003)(110136005)(38350700002)(66556008)(6512007)(9686003)(6506007)(53546011)(186003)(8936002)(5660300002)(2906002)(7416002)(44832011)(33716001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5CfBBsW+QYcvWTSjOY0DmFzz0imMHiYRlQZKtgEZ7ZueVjmcmRoVDFK3qDS0?=
 =?us-ascii?Q?qacJkz/OtJUfHWSQYpiYd/w1/4oRTkDYrvF/QFqHz+ns+FyMRxDIjmQo805y?=
 =?us-ascii?Q?g9jGVwEKX8HFXQikq3I0o9auyGyUgJwDE4NMKKU/BS6g+EzEM3ANwaAdO+Sk?=
 =?us-ascii?Q?Vi/jDNjPHBcQM0WGxJXcOIxRM6WFl9HL0teoQl9p20kYjAN4V4kH+rtHUVI6?=
 =?us-ascii?Q?XpGbRYudKzq5axi1+ngTQOTIc0NNL5cWaNfSDhm5I06t9zdWMMImTrgjlzZ5?=
 =?us-ascii?Q?VL1rFON8qBeKpfgvkOhk68qH7ZmLJE36aRIgIxkSghdGFhtewy2BXvjiVuIf?=
 =?us-ascii?Q?SV8JMPD8Y2SOmEn0vKfJLo4IJOaA2GZmQz5HZ4HigR1T3IkLEpEP0UFxXPHf?=
 =?us-ascii?Q?FcZ2xP54RfsbktbGWs3SBtBoM1H09Hv7OkbxfhEhQLn/h8WIY/mnzqYejwjg?=
 =?us-ascii?Q?V7mIjSYG8DEk3AIqE347QrxvIsBSJEJqSQLxs5vfml0c5ifz1KCaE1yS3a+j?=
 =?us-ascii?Q?GjVG0OlR50oPavtbfkNF2S58KnEloCW3eXUG5KZIIfALh7Mg6kZ+V5ceQNxZ?=
 =?us-ascii?Q?7jQs71rbM5B+a44+zstNPOQY3WVunTT6pPViIouZtBL+WDBBjFW7tYTY7MBP?=
 =?us-ascii?Q?9NfhVP8oh+FM4OrtYRIpZ3Zjk4+NcJbu9XuxHy9Kcv57dpl+p7QbXOzLtRiY?=
 =?us-ascii?Q?LloFAflma2rKzvt+SrX2VhQ37EwR6tepkbzptkX7BDPmJigJDxD3MSISBqNV?=
 =?us-ascii?Q?yWUJuL9LTdRDoD0BJ17lLgJSoigh5YwiIJ5m/PGJXBqzXL19MTrsaKm0f9Mc?=
 =?us-ascii?Q?2SBWi2SNyojsEETPxqF/aXQZbjqNVUMGxNTNZ+t0pi8ziuP4bgKxgzNTZIpH?=
 =?us-ascii?Q?eUggTmfJcS/DxLynNyg5rgMiQnB4dD4xraFuC9ExlKtJ9Z8bC7rtIp2EfOF1?=
 =?us-ascii?Q?NUipuf1ZLUVc+AL3TCYAcL2fznf8X6nuBFimn/3r1S64vA+7BIJXG34gI1G7?=
 =?us-ascii?Q?YJ9Wm9uq/Wx7E+oCjHGV9wiLInuNf5Ppt8Tf8IPTVmaNnKMjFrqBAJ83uvMM?=
 =?us-ascii?Q?NLYG//YG+MNB5Ka3AFBOJB3OLBp/pyIM7TrcKFPe9N4nWGsXcqROdIeripP2?=
 =?us-ascii?Q?nJ6O3iI38tY6JXdmQ7w16uIcHa+wfeXdZLlEJ0op16QmqqOMaHSpF9a6EVSY?=
 =?us-ascii?Q?sbHc2RmrV4xRIea32hl+INffMalm34PT5XE1t43b4NgRQcY0bHnpQ34p9XVq?=
 =?us-ascii?Q?7dwcqkaEfgQYR/no7n+Em8PmeZ92oYstBa+9M0R4QiAcvDBkHEGihDG4O6qZ?=
 =?us-ascii?Q?vj0kt1sfrSj6SIBll9V2/beQgTlFIn1NHxQPp4vk2MeBDgIZp8FFKP2/ITGk?=
 =?us-ascii?Q?gDLI8bttqLLi2GRMZcKSMXO2ItBYORlcHn+vukZg+edTKFNp94uYAm58fnpE?=
 =?us-ascii?Q?9gsxaukZlxGwoUHmhyGLyMbTwRi/AC0n0pZO0ULj3kffOQzse/lFvX/RkGs5?=
 =?us-ascii?Q?YR9dfjbF5g8NAtzldQicg+jKuiVcfYcYgJ0Rc1uSL+IS3WqHSBRt/37hzP3r?=
 =?us-ascii?Q?h2BnfRNAwcNres5IJ22Csb397nTH9qt9XsNZ/2rrlLEAHMsF4+HKWf3Lm+Tm?=
 =?us-ascii?Q?jX/kVkZLd1A7y4MQKs0TZ0hr9EkVaWRIswe+6BsX2hrZ29YJxHk/7nAUjAiG?=
 =?us-ascii?Q?hLrISAiPk5rKyjlhQX7wb5kju4Gko7xPoWOyC6c73iY1KNI5ry7yXmaqX+pS?=
 =?us-ascii?Q?Csn46mrfRA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c88292bc-6a87-4c13-0819-08da21f7d8ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:29:20.5928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDwUMzaJfO65fIXS9L1aIzWiajS6RFyVOPkPSmvsas+8a63nqA9fesxDGu+uJ3aAgIOjQuY1Vo6AWfH1KXSlBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3944
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22-04-19 14:20:43, Abel Vesa wrote:

Ignore this version.

Missed adding the newlines and fixing the indentations Shawn suggested.

> Changes since v6:
>  * fixed dts warnings reported by Shawn
>  * removed extra blank line reported by Rob
>
> Abel Vesa (8):
>   arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
>   dt-bindings: fsl: scu: Add i.MX8DXL ocotp and scu-pd binding
>   dt-bindings: arm: Document i.MX8DXL EVK board binding
>   dt-bindings: mmc: imx-esdhc: Add i.MX8DXL compatible string
>   dt-bindings: net: fec: Add i.MX8DXL compatible string
>   dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
>   dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
>   dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string
>
> Jacky Bai (5):
>   arm64: dts: freescale: Add the top level dtsi support for imx8dxl
>   arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
>   arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
>   arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
>   arm64: dts: freescale: Add i.MX8DXL evk board support
>
>  .../bindings/arm/freescale/fsl,scu.txt        |   4 +-
>  .../devicetree/bindings/arm/fsl.yaml          |   6 +
>  .../bindings/mmc/fsl-imx-esdhc.yaml           |   1 +
>  .../devicetree/bindings/net/fsl,fec.yaml      |   4 +
>  .../devicetree/bindings/phy/mxs-usb-phy.txt   |   1 +
>  .../devicetree/bindings/usb/ci-hdrc-usb2.txt  |   1 +
>  .../devicetree/bindings/usb/usbmisc-imx.txt   |   1 +
>  arch/arm64/boot/dts/freescale/Makefile        |   1 +
>  arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
>  .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   |  52 ++++
>  .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 134 +++++++++
>  .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    |  37 +++
>  .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   |  78 +++++
>  arch/arm64/boot/dts/freescale/imx8dxl.dtsi    | 241 ++++++++++++++++
>  14 files changed, 826 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi
>
> --
> 2.34.1
>
