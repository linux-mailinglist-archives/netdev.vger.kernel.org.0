Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D125069D4
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351206AbiDSLYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351090AbiDSLYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:09 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C44024F37;
        Tue, 19 Apr 2022 04:21:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dG//0KAIi73xxj1K/wKHgntmHsLSR+i6MRpG0LnSnKUaOpUyS97gXpe9tAvPiXUN5jcm8l/Ltr8TBFnXrI+WSiiZFzRiGepVKn+U2AALq96vh0/LShG0fc1FGX7PgeaFqB8kQzHkU2h+YkltJgx65DvuUAVlN5Lzf16kP3Udk1SfC90TW44RnN2qSkb2XTR9+m9h4TjoXO5CHLjGbquZki7YiocICB7mB28VFFVUEjRSgJGkNCGNL9bfKfebEQrJs8IhB0WX52cMkIEeKuYytyE/sQpGRYo7u9lO2fL41t+AD8g6ayX9omKsznQ4m6fydNPAHhQgdjmNfw4wLoQdMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJ1zyprXyaDqs2f/1Gpp6qOrzuHRbM+I4B5BwmIUfgE=;
 b=I4SvigKWPC8YVo6DCbuHS0NMU+TuIE0ZksoewEYNkaJyXXgtY4acd1V59+7yXiozyUQTxOh6dI5Zpa3hIuVvdj+q1MSxprt5zQxQZnHtgkigXCL6QLMrWsGdhqnugr0mpIy/oIsSYxu1timuH+1DMT8Q7IU2RWS4RboqztpscznJw5Gvc//ffb/7uVBsbbmhM5xDUDUN1/6eLffpQ3CaggAq0/mNKF0PsKIMZ7c6ZWPL5OUgkIdd1x4gN/NkMG7ZxUTsAQltp/zOUumKyS2Ro2hlXgPfvflnbygaVoBdQJGDJnZS61VyzyadIaPb+D000t7cOFXpCsBs6zDCewE2GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJ1zyprXyaDqs2f/1Gpp6qOrzuHRbM+I4B5BwmIUfgE=;
 b=CZ6r7y368hiZ6PEzPZeWTygZ/+CKAtB+hhRxTZ93vZooqbZQmOqGKcKXgSlD4MVAwPel9uulUO7K51WrqoERebQm64M4ozku7S3MledilO3J5E5ABkaJJjoju7UbQ2kVu9rFCzXK4yHCPiaM048OhVZNdR+n2VE6K9JH5Tws8rU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:22 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:22 +0000
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
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v7 05/13] arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
Date:   Tue, 19 Apr 2022 14:20:48 +0300
Message-Id: <20220419112056.1808009-6-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419112056.1808009-1-abel.vesa@nxp.com>
References: <20220419112056.1808009-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::21) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8393132-c342-45a1-d250-08da21f6bb7c
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB75382E7E0ED33DED9C7432E5F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JE2jtNYwVB2Gusain9DQeMmm80JrraNQ0WspSvvu3dRVTlrCJZg2v24e0oZUKicLLFX5NEfZvupaokeItrle4gcL3+mMEdvIXMS9javErL/YuuzNut7/hnmv3Ug9U2q6i3gBLYGd38lQ4SeFJvCv+Egf5Ck1RsWdBIABflfIVGqn0bOuNAjsvdaqoy0fQqXqk6+2MN25DQQqrTelY9zMBnpKvNCavTPpzr9u3IOYjkIOCFXMPYYB9gkZohAZyz94+KMHWTGTM0P3Dhx+KjqltZ2QZOV64+p2NbBXi83/duPfxDphoFGAy/KpqOPt6zfysCVgYpVoXOLewoFlEXfPhEhNXkbo5D7hWcOGS6IbV18m1t0jtBGq9K3eA0d6OH9NjvdFXsk8DIpsVMKcQDJbkldbWRBLbzlMhcM6H2RzGYv+gXOfKPxQEbw9XtLB29xKmV/VzwY7naLJMNvag1q+ay4Z+6uDToLE3Wu4FybxAVmzBb2Y0/reB4LK0LnKexAJCAaV7qW14v6Khbi0j8zjxLTYJSjiXP1qAJ6mblJ8SnpHGwMCVmEJhkbz9/U9X88e+DBmM+KHq+b18lcAUwNhYgMLzQNZVqRreID+hwuAZVMpFwh1mRuthxlstv5fsIgPZCG9sCSjflifz04IX+MI0fLlHvcnGKxCgXIQtuwBp70+cj4Lm2RDP4zW6mMgOJxH51NpvAE8P0DVMnEpMzDsRZdpXigJHrgGtb9vpcrUDc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(83380400001)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3VaGFa+WZDMGo4B8zDQiUVouPME5ZgIQval0tQBn5/D/YzgHrBaE91LCz6wP?=
 =?us-ascii?Q?gh+VftBAkreZx6dW8raEF26k+f640RO0wb6df9RmyCb4t7Txis2HcbwvJFnw?=
 =?us-ascii?Q?yhwmTS+WQ82mB85VXW3oRj06PBZIl+zHFCIHpgruRgTPySG9QunSFc/vDLhk?=
 =?us-ascii?Q?vWGrIeeMg6uRKSLIQyjexckDiUAvDKJzOqHRjRWGa4pj3o8FZR092sahXpZx?=
 =?us-ascii?Q?cmJTDfKRlEYyO8PnKTeA2O5GosBGEKiJ6e+jH3IrfPQmj6ujcDNXRTRtbjD9?=
 =?us-ascii?Q?SxrywVO54jwhDXFwFP0k82pZU6iB9i0dPZtd3UiceOjlLGCN5pPBuT40DyHP?=
 =?us-ascii?Q?0YiXDSphsH1KTHGmibSpbpnALmF+B3rVP+afsKXbO3vkWlGHFv9nX4Zu8Dtx?=
 =?us-ascii?Q?sIkCszRyRcX24e5VMAS4ii206Op8MxJo51nTjA6gqDLHo/MtEZv9xhKKRNyP?=
 =?us-ascii?Q?jeFMPzNd66rNg7iva95SqqBHuHoEqDqvzdpXGFNlS0chcvL8UP0uQn0vHO8D?=
 =?us-ascii?Q?s+LQLyGGIxfVYAQJWNKp6pD+vm4GcmQXey1xkmEtBRdSIwMv+xN1mNoLpa79?=
 =?us-ascii?Q?m4UzQylHnKogUiqDEvdbHdz1ur++clfEpAiQlqZ5wIyQipMSD7ew0BEVCnPo?=
 =?us-ascii?Q?y37yK/wfuzXmLEGzUsPdMLY2LkM5S17qoKsPLHue9/WLft2qDqXt33B8PN5T?=
 =?us-ascii?Q?JvHgmgWYVbSTr/mGEkXUVeWZH8fYlLQp+7QHP73Sh/BNPhdYkJoBHsgipAfG?=
 =?us-ascii?Q?dK+09WZghsNfQR0C6+FioWZ7DdygUAoTuXnQ3R23Qggowz5Hn82Ea+7y7ULC?=
 =?us-ascii?Q?Tfr7pufsjk4b++AQ6K5qwGDH9JqtqIGEr7MEMoxIG2zIX4kzqb3k+Z06JpxP?=
 =?us-ascii?Q?LH0C64M58S9s00l/PfROT5n7P30pUl4u9wwU86i+ft6+aZrcN+onc/Z+1jRB?=
 =?us-ascii?Q?B59gzqZtyjnudA/7U34ViM+QYOCvDqL68rf734Z5sLba6xNGrQzCojoldHgV?=
 =?us-ascii?Q?wEs5P1LjRgm3bhFn/N8Glut6cVFQ85ZkE5Wln6/wqEwmCjKUMQQO8U5GMQXW?=
 =?us-ascii?Q?ma6wmvXLhGUvyEiJz25IpQDFg7jqeYDvcViQ1OnZWlnVsYKuJ1y9snLgBmJT?=
 =?us-ascii?Q?StIJ5A7Epne2Y2oipqtcJWUNxUV4AKbKdxWSEBhKcyjMzPf0qzCgXxFTemnb?=
 =?us-ascii?Q?Uak3t897OoEMjsCWhfPCQ61LbHAFtwpu1/Dy/hcDTl8LrnXEiJu2ihsuyFKY?=
 =?us-ascii?Q?Fgdvs6xYF9eULFM4xWDDjo7IifdUHjWEFjmRndKrOXwTSc47TPq+GQrirnx+?=
 =?us-ascii?Q?WFnrUGMihGRP5GEEAnAtX/Djzy6u7HxWFSiN9J97dmhhYpGRJysolqbSQJVn?=
 =?us-ascii?Q?CDG+xN1Wc0AfWlkOIBrgNTtTEcInSlB7eY9QBy57KhdKByU9Cs/d5q6g+9Vv?=
 =?us-ascii?Q?yl2xUvBtFYVbJ/+Gz9JR8O1tac94NSvYv2aFo6RM41QNi3ADY5ZFAgWtLf5x?=
 =?us-ascii?Q?u8hmUgTPvckhZw0if+pXMVJYZz48xdxvBeZPvV0Xj9UNAEfufHg75ICL7va0?=
 =?us-ascii?Q?MFuJsTxP3dMu1HzEAs3Cmavo5MX0nlD7Xd0IIWwqvQhgXco4DGsKOYpapQs/?=
 =?us-ascii?Q?cSwFx9T2RgCZ7EphxMFt1RcdeQuaTKlZXcZVgTkqT1Hpnf9tATRix3wPgpU4?=
 =?us-ascii?Q?nV4g9CbRHEKmpngZIvS76wvzJTQwQnfXe3N/Ch+RnniOKwOhtsdR7KsxIY+A?=
 =?us-ascii?Q?S4DA1zLp8w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8393132-c342-45a1-d250-08da21f6bb7c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:22.0662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0d6aul/8U78+t+I9wT8IPBmVe2EOiVoTWB8MiP0Yb7/0Gu4CcwfWjdsuEHbVEFywAArBwCDsP4X4R2jnmRM0aA==
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

From: Jacky Bai <ping.bai@nxp.com>

On i.MX8DXL, the LSIO subsystem includes below devices:

1x Inline Encryption Engine (IEE)
1x FlexSPI
4x Pulse Width Modulator (PWM)
5x General Purpose Timer (GPT)
8x GPIO
14x Message Unit (MU)
256KB On-Chip Memory (OCRAM)

compared to the common imx8-ss-lsio dtsi, some nodes' interrupt
property need to be updated.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
new file mode 100644
index 000000000000..6aec2ec3a848
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+&lsio_gpio0 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio1 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio2 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio3 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio4 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio5 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio6 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio7 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu0 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu1 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu2 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu3 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu4 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu5 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu13 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.34.1

