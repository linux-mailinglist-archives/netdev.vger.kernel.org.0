Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53C5069CD
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351138AbiDSLYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351064AbiDSLYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:04 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD43F18F;
        Tue, 19 Apr 2022 04:21:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qk2JrrasH9YTz6BLGGjNEdEbXhK3Qi21o5YRy7lJN2SMGGZENTA5VOXXIonOtUYCw8kb1/Jip3KA1HStmmvCHDQkGnGyS2/Lb7y9XUrOPSfWSn6APn7v60w1BTNouWruG7j1aek0QwZiTETcf+xKTzqPrMy2oVrXmF5+UMCa90Gd2hg1/suPCQ02wfS4ed4AZ4P42tcbK8o3qn094xhQbkcQ6OHP+mlL8/XjIufHHjpWL7u1dTp6BP4XhUZ7BvyHgmaxl7zTIWVxh9veZsiuA67cwUvwdGi1UaxPo/2HfyRpwjv4Wwq8B0e/3NZZ39ukScrejalNqAfDW5b8RDAy+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=YdAKJ+iH+OUJUEmr9/zzRMmakcsbRDoHc5CMh9tKjVBaHUfYwURXX6orIhn+Ns7JaZrDfbfHyv+FySQCYmXniAcSGm7yxVA/ecYEcr5BuBBEWWwVY2H0owLZS4y69bOmEdXvesA94RdoRnG7RzPGuAYK/f2bxrXjHxo+/vznrXUHWmQsXKQvxsSK6rGqVEAGB7iEt4dmm50Xm4mfQqih8bINUz5Z92WGxfTg6yJBgynPaXf7Gw/1JhQWWom3yBrlaLkzchqapwvBBmJNYQWK4GLWndfpZg0d5tMJmZpNW7Ygw5tsUskQzlpmeJopxZEomT+C9t0k0AVeAKv9fy6p2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=PISKtzV90SjJXhKfBa8iKRfGBpdWIZkkyuBoPRdlDxhykTp9IOkpZ4gobnJslt6gle3eYmme9EmytZRJZ+oH8CRpakfCF905a9G1iBU+/nSYAxdh/zLygBu37QBgyV21Xqx6UmIEeaVvzCJY1Zb93j2ES3NL/mSaK9nkhIiai5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB8PR04MB5931.eurprd04.prod.outlook.com (2603:10a6:10:ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:19 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:18 +0000
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
Subject: [PATCH v7 02/13] arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
Date:   Tue, 19 Apr 2022 14:20:45 +0300
Message-Id: <20220419112056.1808009-3-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: af14d50a-e47d-47a4-c9b2-08da21f6b9a4
X-MS-TrafficTypeDiagnostic: DB8PR04MB5931:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB5931813D3173CF6D2F0B1F35F6F29@DB8PR04MB5931.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bywFQgJm4eA4ohA1XBKPv9pgsYkmMSOIVbDd9Io+eodJiZ1BhoVw5m0vLTVqSCL69akqpORrRznduV663jCcg5hR52e4xn7TDjzH8g+fuUxjynAx19KjMG07+b/EqDAQSKiJ5Y+yIJk4fGconl9FAsLcesKfPfq6rQROKXs4LUvuhYZiMIiIVtpFP7RrxOYHx9a/gsJsDARwZvOgiuYKRU/LUUP3SHI2+mlmDLdnaG5ZP+ysf9PjX7+/WZHpRbDfkJ/+iO7oJlQcVfWsNdVXd1XLlN/+fx8c9IfKVC+UCYQs6ty9ozbWGD1+xygpDnjNHhjzHkUqWMiRT94wfL6OPg6JvspD3sjRneUDEQ5NoiUhYRI3odcmrtFaQ6iq3gsXstn7x3+Zrc0Xx88kqb3sgRkQJberp1hjx94hNlprfWS+nr3J0+xt8Tyy/6k0ahmgQ+Ib5ZoU3YiJrOOwrNnTMB4OXTBj3+7elIYQuVeH0n+R2dG0g2bNhWC6NgYH/xmFZPcimDK3HIhnvFNHvDlvII3URonwGxP0qShgqZT/9yvMu/lzOtILq7RCWxu5XsAUimKTAVdxBhDw2KH9Zixo5mKAWZez2n5LqlebbMQJzQCcBA5W+EazzX8nideioF2bi35phglEktVSryN6qrLXlrz+JG9qnhRvTximM9d6pVUn2qo/fCNSVV7mfXX46vV9qc9uMatr3QNkNHOf8CCr2qJix4Jtx/fYhu07F3edzrU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(26005)(6512007)(6666004)(8936002)(8676002)(110136005)(186003)(52116002)(38350700002)(38100700002)(6506007)(2616005)(86362001)(44832011)(5660300002)(7416002)(83380400001)(4326008)(66946007)(66476007)(66556008)(36756003)(2906002)(316002)(54906003)(508600001)(6486002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5j1JxGKKk2mPnbDrop3RTGSo02rc1SocDok11w8+IHx/V5E4hOSHECQ08hbL?=
 =?us-ascii?Q?In0PBdRm2HRKnq8Ou/pYdNxRa+QRXz3cK4coUQxtsTypULaPLJRNix0acDJO?=
 =?us-ascii?Q?T4N/YKBZyQZOjAkS/tQNm8fHPUib2gn9WPMVoMtcDPc+2YqsZJj0t8+AW4Mj?=
 =?us-ascii?Q?77u8mymIXvqyeKCE2yYwCKSremrUEF+8JdYcN0oXMUvzjX1JVXD+93geWaf2?=
 =?us-ascii?Q?ubxRJVponKRmLRwpOaCenr+ibn/1UUzr/I4aaaIgwnpoVXNMtCRO634MIcPf?=
 =?us-ascii?Q?APSO/XiJUgWvyFM7lXDe00RdlsPGDxQia8jcrAzeMhr00fBlIr4KmkH7S5B0?=
 =?us-ascii?Q?IJS6CdvLRWmPSoA6cPct9l4nDCgXjD19idHxXxl4vb8Cfoj4AK2BZZG9FX+k?=
 =?us-ascii?Q?B+b/JkRnjzz7J9woE8hCre5Gceg5b2mlNXwLJFhtz8lEvYKeM9Vhvp81t4BV?=
 =?us-ascii?Q?dCgbSIv1F3+qgT9YrPg2rS1eMyUoEgc6cYHHYNWG/9nJD+j6kwWyU/FKapkz?=
 =?us-ascii?Q?Y5SPB6p9r85UH/m/YVEhgiDVPl/ztafRCCznN7KcEJYEqrXt7IReP+PsVu0l?=
 =?us-ascii?Q?wyqyUqatMAirlnx5s8gBhbLKczVFCd+9MLkPXGZnz1/guG4qN1hT6LxL4rPQ?=
 =?us-ascii?Q?zl4ecvcpMxi+oj71LTfVETF4u5jhutXSf60SVtKfY2m2xWmQje0fBfUEdJg0?=
 =?us-ascii?Q?t5a51F8P/++MN8bAPYhtmr+UEjuBU3BYxvWdvK6suvLoX0ikagg6ZZBv25UI?=
 =?us-ascii?Q?aTSPa85kO9C1DMMSrg1NwX1TNEx7lwztdt6y21OrrMcxZ+W8zDiybj3Yi+KO?=
 =?us-ascii?Q?bPpyF8rrVlN5X8AjBiWj9Sh2NakM9amGj5nQkP5Kw4bIopE2eSDmiKn1pDzN?=
 =?us-ascii?Q?w6n3ka31SPAQsYNhH0/uN40pSX31R7QX/L8c6GDkg7gata5QCp398aiB997c?=
 =?us-ascii?Q?sV6W+LXtAbJfbrtTR6bZOPThngnzcWqIiplE6BrWzQqsUqu+fbMKYPAyp0tT?=
 =?us-ascii?Q?/BSHU7Tad9AeaKwJNob0cmdQN4hPB2X1kL6wfi3Ht6ZuBeUR/+O9T4gBf4Qf?=
 =?us-ascii?Q?M0eQrEBCj9dNYGLmaUmxWPGbfulfaQjKgLReB5bQRSNy15WU4r070w0VFj7M?=
 =?us-ascii?Q?5I7QWhzaWqT4jr6/ju4RHixtguS3JY3yDTZIkyctwRklfyAlQs4fpxCucFCn?=
 =?us-ascii?Q?M/UjX+J+sVkbznFq/VbyxAmrzUFdqxE0CpJWciiSK6wUl4cWiH+9hzKP+I08?=
 =?us-ascii?Q?v3lmHqnYI40tcCA/vjVJZIY97/cYINGfKYWTHa0mOH/ytPbT3ef/XR9dIkpE?=
 =?us-ascii?Q?DrEINCQGOhPqSpMN/gJWlBb2AREgT7oG10YFVnqqJSFiAs3jb2Ow0siEAxNz?=
 =?us-ascii?Q?IPQ2RSKO+J6JPPo8sS6vd6RY5D8ocHWxPtzeq8smO+eNrBNts+crpxqmZ1sF?=
 =?us-ascii?Q?T1VsE0p1/1XDU42veipI/1339MtMzWG/tVwPcYMfp128zvtKG8MOQbmFuam0?=
 =?us-ascii?Q?XF6Mg+JEOzFdrOqQRycD0OyVkh91JICNnYsv64hbv7VhMvMyQmF15KC4L4Yh?=
 =?us-ascii?Q?+aO7G2mUEHqQUOiezuAhq6ojr/NpP900bdUpklZyS1+5rj84TSBvHRVzQZpD?=
 =?us-ascii?Q?R6nDZy8cBdu+mxc34ODJhbGGOkDSOmMJUNrT1tqhj3+zSOEfK8DSIF7GEpyl?=
 =?us-ascii?Q?g1m7Z0ZfaKroljfgQlkHkQVSrQG9oDjLRTOJY4EVRiAGAPKx7TEfixFyb4dN?=
 =?us-ascii?Q?4xfrr/i7uA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af14d50a-e47d-47a4-c9b2-08da21f6b9a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:18.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tknTR3rxToZ/ofirDr0dUeGHRUlQR2jxakJAvaL1uPaqAdOkOQrFjRv1f6OOxUjZ6LhMevtBWUF13SpB+ubz7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5931
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

