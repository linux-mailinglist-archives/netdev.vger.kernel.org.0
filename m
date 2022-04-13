Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC04FF4B6
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiDMKhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiDMKhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:04 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C558BCAC;
        Wed, 13 Apr 2022 03:34:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdBip6rtID6XrMlV1vSOP0mweh5eCi4vPPffFFg5nt21y73pHaridSmrvv5ocVCI9/pa7yTvl0r/Hm2tQJGugD5aBzC6XHJ1c9LgIOnsBILYrO9KOoE0V4GUo2ksOK4mGO5Mu7BeSe0CFZH6wVKXz3wz+8QdP/fwpOD0LBi7ClmCvDGbqJx3zWyefJFVE+fA71Y/1GyyDq10ID2JGWqnAjEZ6jXjV12OW7i+iC2E+Sg5GeQc9dtm7jssa1Zx1ttlZATx5fWEoVY7TazYPPSL99nDRQNaF0+gj3RijKULy03Ac5Vgc0Uz2Q4YqLoXl6TOqVZ0ByVRW4lrOMZts0YWqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=XNFZlSQcNizUErUDHnw9LeImfzKcmd8JWeWY9M6HHyYXSbG9dP/5vtfDZdbnAEZrkBnRP3DT7p/xu7E8/PEFPzs3Jr1yDYxl8Pjntbncj/Gk1YE35qTCq/uHL3ljSzmcEWRNmkWw/65Sn8lHFLcZSxCLD9um9Ms7pv8RdDF8vCowgiydhX8hU/SpO2B+oRZOnrZDfbcdJHKXyflKcJ4jPf6eiimBpywb9BgDsWnLzVtD8aGAYs57Xchycpjgnq3iK3LTO+fMFkVi13W8vr6JSRrHX3JjA5fpxerphdtyIXUKKoZ2dfRx4akdtapZSbOOkPvD2qbD6sVbkweBwQxXeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=Rl1nuiC1nTD70ultBz6ooeHPyLVvb4cYSDqfqdXDP3k6iNowK1t9dRndhH4fOqQyfsWYnmFN9wqLMH0vM7mYzyKZ7xFHIx0PwhV1I/mfx2wog0XjQ4VmVUdO5P7OldLTW8DvsU7ok6/uCZlMzi0eAExb2/RMF3/oQvmzfAisMm8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:39 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:39 +0000
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
        linux-arm-kernel@lists.infradead.org,
        Clark Wang <xiaoning.wang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v6 02/13] arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
Date:   Wed, 13 Apr 2022 13:33:45 +0300
Message-Id: <20220413103356.3433637-3-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb309e0d-699a-45dd-ebe8-08da1d3936a2
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8691343CD463200B59BC86A3F6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YrO+cb8eLw8WcWEMNMXKhMOAehtsczfhmY6Te7icyU2Z0MgaUcxCYsTkrlH5J4ufya15OtPJuYkugLPKOd6C+05/ESQFZcrkN5nnecOrUtzJm/ZedAP+uwGjYd2d/9lCNpgmsQwsMKVzF0eT0OjvzCFDkLhoHUKHpag43couDeod30tMXYmHtsYLYALgNNp4FFoGRrlzAGnTiSlce7eJsnxHyT4F29r26E2AQn1UkG7F7JHN/dqWDtpp8qXFTS0SBB32r3iJOLA8guhKtdAiNS3ToCKWJneHUcbkP7nWEF0vYMv13OFL8B/C4B5Kxsn5R+FAnAlye53xvOHwmgYSLxQGRUHMiDzK0bbeUkEzikhX28WTS2deXyY8FlaD3GUwYrJ7pFY+QY+UJ1WkAoyaAJLK87yc4YxJJaSHSNTIeLcO3iVYv1g5XuQclyYLN1t7NcPfiCwcHf+cO1IVnqqqQHNr4FWiRxyW7C0z52bSX8X/MxH89QKU0FzX3FOudAwmUo6PQDdYJg7hWKPhln6lF45xdiCQmCYX66AN2KsQGNjhWp0JlGW82xpwC7ExX0XSfsK7PxMKDXKtkFVaLHCD1HBBrUukIvqMGV9tk6oZSEROCG4sccr4V8bT+5SJ5aao7WNqcF36kMTJl3NLNvcTrsyCVSqQamsabmwLRgS8Vqrh4IfRz3ryjDMoGB9KG80zpoP2uRX2TS7laGtDUQRNWWG/qhijHe8qoVYSq7sbqxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(6666004)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M86DNufLPxA4xhJUWdP6HthtuoRWc6xO3Gq9H1KdhlMuWGz0wAF7e9IVKnIM?=
 =?us-ascii?Q?TpwUTdNTjbQ2QKQSQ570l3hI4iPJc1F7LVX9V532OBqkN5nqOjFK6eXc6YNM?=
 =?us-ascii?Q?QFXlVZuGQhsPCidbfSYLpxOvX9W7Yd3VBvaNkSRhQOD2riiMMGsXC27lqqm0?=
 =?us-ascii?Q?V18UqMIVbrl6ywShaMFAaPZ3qdYB+dqQ3NJfiLMHorEzFkFfOMHwLBItYUy/?=
 =?us-ascii?Q?nIp0iKWYry68BSP2hh7Qdphanxq0Dxu8bmGBLgfvGjTgTgWAaDRsmaU9bgfD?=
 =?us-ascii?Q?d89ouollr/1Nl8cVwXIIuTeyq8AJWpTR+9Q9ZFBTstAR5U1kLoCRRpeYSkrJ?=
 =?us-ascii?Q?7QSu2fcfNnQxYSTWZ1zq6QcIyuuhj+ouWCrGgtV/PUcim2oc9x5ytwVXylev?=
 =?us-ascii?Q?X8Z8HJKKdSFle+gNZ2e6oETSPjho60uYPDoHBFrP2AP7asimdjp1+J/e5Lrw?=
 =?us-ascii?Q?sWaSOxRR5vMPKLm5hc1qk3kWh3QDFXsjqsLVqGFT5cTzJ9Jw7lIOAJDFlafr?=
 =?us-ascii?Q?2xUp8HurPvw1fbVJ0sBEmt0jNWNvZVklQw4SWYh6Ux+WkOKKGD33PuDlZjKf?=
 =?us-ascii?Q?vuSc0C9ytqgHlq10sq+Ny8LfKA9hAKyMV8irQeLn/KGQVKxcMLOVajrhBVRd?=
 =?us-ascii?Q?awJ80aepGI4mgrdJfuSXqjd4p4sp1Mk0cvQVDyqsGDAvygtmHRiFXxfmiT/A?=
 =?us-ascii?Q?RWAWnwTY4ngGFe5MyTgvHtHz5eWOWd0SdDxQqZB7tjlsYEsRy9qb4uHMwj+x?=
 =?us-ascii?Q?UAbd2NsDec1WJWCaNZLGGWdUVolF9tTdarYP1MrK53yGlqAjxdpb8rngvpxm?=
 =?us-ascii?Q?LaoB2N+t7W2EfGz4WbUFwOoA5UQEoGuyYnSczPKcqb6wx9p/TMCaTfoy8e9K?=
 =?us-ascii?Q?4stiQqZvFbzsjg3gQV+8dYd3AAJ2Y2i6mhsbB8FZWBX86pU1ylHgH3Sf3zRv?=
 =?us-ascii?Q?IBKSff8GEFCuCYSWbg7b9yR13g/xaiPmz0MOAJdsqy3y3X37/4zOCGy0i7F5?=
 =?us-ascii?Q?dJXWSNf4jQ5qoLLesKrSCwZltSsdK2u/g6KNxOD0kdFgCn1VFOHGVAM6nGXe?=
 =?us-ascii?Q?7mB6RfsCB+7N2FhfiD0w4OaxRhyfCmPQWcaHVuZuok5LwyGBKbJ98UB+90vF?=
 =?us-ascii?Q?faXflcWt5B8FuzmrSW3DG7JTLmK3LqoQR3qoHUh6C+BB4ZkbSRwHyXI31grD?=
 =?us-ascii?Q?LQ9it0Zyp/whdIeFlgGfe9rgc2GgMjr/9/QWvQF9VSTGLpjv05Re9QXNonsC?=
 =?us-ascii?Q?JDBaPHWK1G+HF7BDvqxcbL0Hkoe2J/rq7OdxHtiz8u6+mggdKtsvJDOH9NGJ?=
 =?us-ascii?Q?OPPueccnD6FYQrFIy3SHM7MokkBA0nfSMMO/LQQCg94FUplBdrX9mBALb9Og?=
 =?us-ascii?Q?wpikjPMgXRALOCafh1sv05SqccEQyApaWqizPmFMjJLRTVYRIhVPAGprqNqv?=
 =?us-ascii?Q?mAo1yLkmj2CpdPECOTLPeCbiJz6iXBXhxWyn5m7z0k2TNqGptGg/k8knJaPN?=
 =?us-ascii?Q?C4TlCqndpvbhRtfw8ox5pJMkB1fEV4Wy5XwrxkGE3/xz0GqAUBsLSRFrUy6H?=
 =?us-ascii?Q?Mn2xu+DQ9WrOXcrfcLGcWUfjr7lqWZgh+MS6hxTDRkfz0+8qlvpLx6hnXG8x?=
 =?us-ascii?Q?9hpHq4hjwn0ZakXFfxOfgox5KJpG17IfklBZvViQ/HVe52hzuvCPPMSryDHl?=
 =?us-ascii?Q?NgnjASloKDmwkEsESC9mEcKW91WGZO1+o811B0C6lLexBqCWT4dmTSgtvOlr?=
 =?us-ascii?Q?dmCUnP7LVw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb309e0d-699a-45dd-ebe8-08da1d3936a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:39.5365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lW7KZXlPGrVqdCYE+dc36thEr7Mu3Q8onknld/fTxjh5Gnv9Gfv8KOsF927z8mdIjpHVahWA3AhZxneMoPdP6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Override the I2Cs, LPUARTs, audio_ipg_clk and dma_ipg_clk with
the i.MX8DXL specific properties.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
new file mode 100644
index 000000000000..4d0c75bad74c
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+
+&audio_ipg_clk {
+	clock-frequency = <160000000>;
+};
+
+&dma_ipg_clk {
+	clock-frequency = <160000000>;
+};
+
+&i2c0 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 222 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c1 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c2 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c3 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 225 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart0 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 228 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart1 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart2 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 230 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart3 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.34.1

