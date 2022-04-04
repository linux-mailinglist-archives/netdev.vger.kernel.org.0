Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD44F165F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358444AbiDDNsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358273AbiDDNsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:48:38 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40040.outbound.protection.outlook.com [40.107.4.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFAD3DDCA;
        Mon,  4 Apr 2022 06:46:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKX93UWl6yb6GbgANi8n57vcltc5LST/nszBtMCFelQYr9ohK8MwV1kOMgFVkoagJ8tScLh7Y9tej4KGtCHf6TStCDLio8xXxg64n2dRYf2SgVjtoS/gT0kst4WwC7azpWrL71+VqPio28uyBSw2yw1LOWEi6c72aULhzKCNrsiRgoS2QaGwYaDVrOdOGYhULuZyfDuJ1gO0TIw7XDceOfshKmT5NHYctfus1pblVKrgsKAuwDm1f3l8ZxGuZ3pL/7E6hMKN42M4t++wkhByFl4kcwzYMRTeHtw508vinBgH//clpJVy9PflrsYsS7QOOrQqHDrKsdkwb0rD8HuRUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=Qco4ia55QZXkE2E2OM25qT7OaW3LM6rssLCM21xbMOBn+SiQvey+8ymuFz7SUr4di6fSsP3a852VOEcmIdhCx83ayXVbaOmoKab8FiYVKLYoZ45aoeANI7BdmAv71jCW1TrCTnSGlfbOfmf7I2oXNxKr21EYtdvW1Ux38979SDJlDSnMwRHEbgIDfmOMBM/n6oxatDkRmZaVd0VzJwAAgZVrGcZWLQPb9cBPXNAv5JSTTbWCNbIsAhVhIQwv3JEctGkmPj9PR5Di+PPkaiP6AdL+qhRlIyu5SedgL3xQdByyezo75TUrdxvLvl1AfmdIbS3ISp+/4tsLUYnqieMa2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=OQC83ZUvGAp7Bar9FhTtNUbE/zy2SRgUuDGCfMulY7WrM5GMstmcbILWVhzydhI7vS4Rq1xxts5vimR1iq0xTDM1U1Ik4YOGg7rt9MZWfd0G2s7DhSNSjzQDKDpOsr8Y5UEALEwO+mqVGd1Tu3Bq6hCzxVeUHxNqBloKMrQyVbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by PAXPR04MB9218.eurprd04.prod.outlook.com (2603:10a6:102:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:39 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:39 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>, Dong Aisheng <aisheng.dong@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Clark Wang <xiaoning.wang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v5 2/8] arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
Date:   Mon,  4 Apr 2022 16:46:03 +0300
Message-Id: <20220404134609.2676793-3-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404134609.2676793-1-abel.vesa@nxp.com>
References: <20220404134609.2676793-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::34) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0346fa09-84f2-4fa9-9943-08da16418b4e
X-MS-TrafficTypeDiagnostic: PAXPR04MB9218:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB92184FD27FF5805ED36F8F2AF6E59@PAXPR04MB9218.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6fQe4c0tRQagFrMzxeLmTMmVE5BYHUdlov+Myd0GkMui5t2V9rS1gXEOArQ+p4jEkQgzfy3ime8+dftC73IX5qon3O5NAPfc2pLHSLnMSr71wcfoYcKBE91nmwiBG7oJ4R7Rltt8/BEmsF3lJxjK/l+XywXbZ0W2uG02Qm1/JnK2Hs9uT/TWnIMFhhy2SjF5O3WdHLjPV96YxuTkutyLaNZnBitgp3mKbl4AMGT2lN3szAWbUBmeCXMb6a/hP0vxLeFblTNMLW+0Is0XWvOoxHab7VbWi25sC8Pcbr2IPXkZba3DwV7y0sg9+zZMv5ij9f44gqQ72xt0CIjWSspLacyLITxbgpoet1/hanIGmW7CvWUus4YP+x1o8iwAWmDOx8LNzoR1xmhYSkU7prGIfXk9CWfURjsmBYFbV+nEVdg/jHJAg/4ZN3zUHPVl8w3O0flZkYQvUQ4INBSOC3mqjLISrmv0mk7w2CaEUmWAKON7MaljmKebADExAQShmnyMj0IAmI46adCJosfCUTzsFRwHiM2dsSXJHxMK60plsdf/hpQTMtWsJ47HDmbXTvqVPQpKjTs4wd7DJjUN7pCczrfZzmhvLubi/XCz/heErl0DDOBfsnL87I8/c5cWMv4mN8fsv108E7VnMlE0bYHc6HhYjGM+hkxw6ylpNuW8hghRzQ+jL0GkQYHQMqopyakpITEMwRgkGGAmjiHnuK9U6iTzWQqnnu4BuIDU1+mOPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(52116002)(86362001)(6486002)(2906002)(36756003)(6506007)(6512007)(316002)(66556008)(66946007)(186003)(66476007)(6666004)(5660300002)(44832011)(8676002)(508600001)(110136005)(4326008)(38350700002)(54906003)(8936002)(2616005)(7416002)(1076003)(83380400001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aRyRz0jgy3Lbv+mOkUotbfJ//v8RnW80cEtzNIZnDqpYnpX9R15STvOI+xdT?=
 =?us-ascii?Q?zcFqL0LE9ygdl/nMFbS64mLtwFOtQpyI+BjSVu0vJ0HLzPXoNeuI2LZRp8mu?=
 =?us-ascii?Q?eAUxwPaDNMTNnH6cd3XOIumhwzHgY6cZvhZNxUxk6ce2wkzfzyra5rfgbf9V?=
 =?us-ascii?Q?4hcVT3xBOiTGRl2AoLN/oEZDy95Wv7ls4CwJ3ZnjEegeB732wb7LD1t/ezv5?=
 =?us-ascii?Q?XlYH6QdGVS8NsTM1wncaM3BMxcDRxAXwogPu5Y8s048E9MZgoJ+acfcSLXsX?=
 =?us-ascii?Q?Qvn0nS+2p+JPVKj16IMs70I3xM7Rw1AQOPFftkdLAzQ8X1vtERbMEi63c/1x?=
 =?us-ascii?Q?aLrYdcwtyNXAJRtbuhrDJZBLQohXg+xwJI8ziaoH1Bavd+cW94XGgNbnbMYf?=
 =?us-ascii?Q?s9SKDRMA0+TChQ6hez0lSQkEX2HHW2gId9JfzNcuNVHwA1Viu3bUw+gF9hg6?=
 =?us-ascii?Q?1Iv5SV8i4GS7o7VEawgbmHd/sNyBtjJHbmrHvtImrmk7VivHEI6UOJz06+ix?=
 =?us-ascii?Q?uYYB7uwma2kuhwsmgAwlMCxzehYrFbYTXPTN+5/AktK++YGdnlwDhgkyAqkZ?=
 =?us-ascii?Q?1W8XLYRet5793mDtvM7g60tDo40wjQw+Z///glJJOa7hmrvSpnsaASo+dcKu?=
 =?us-ascii?Q?KQJtzFdzTGb4NnqX/y01J/9WsKsPUZWyAwLsN+pH3JNyK1uEyrJ0+TmD+3v6?=
 =?us-ascii?Q?rECLT0MVQTYfVFuQgdd59nb7hy13V5xBUyQN/dgE3SvAFnyKeibT/elmVtE+?=
 =?us-ascii?Q?L7HJHrT8qzOsCfDOQpVVajjnaUOrJE3pRAoE0dpVBlGUeLBpAgg7Y+33tSiD?=
 =?us-ascii?Q?xK1fvcgcLWryBP0u7j8n4gz/yhdQQ9wmpt/Tt78o9x1FeVscOg0TsJDyURJU?=
 =?us-ascii?Q?Niel/6TqxKd6PyjLfyNhyTQ1bzcyryMOOBq0hp0DAXyVWQ2igEB5/f/GZCJW?=
 =?us-ascii?Q?aAweV/O1lr2ohw7LljeZPnHPGhyOA+T9HsdmrmpJprABF6bUQ2v9zBZC3AmO?=
 =?us-ascii?Q?Bks3aTC4zt4pFY4Q+JsXtVmm2SKDtwMWMOx3aX479WL7g9NdI6xuebZhkaT4?=
 =?us-ascii?Q?HxUdm1VAJU3pe9UKNrV0Ig7S4oSQisltq+WiIg+XCOiqSXWRXeHBEj6g5BhR?=
 =?us-ascii?Q?fJ0tOSjlx06pDOvKlCgTG0kDm58uqKM6/oLtGC+Y5tp5CHvyu4nt3Bg1V4Eo?=
 =?us-ascii?Q?vN/iypcTvv3ShsoxIooFZW+PwgcNHLCpz99fcGsyj9lwqmfDG/8KgOPApGTO?=
 =?us-ascii?Q?pmoCCIKXsEV1GqWb27o80JjF4lGuzNtYcXBlRXY9anijgaXaCq6DC1qJCfct?=
 =?us-ascii?Q?hOlGgwpY9Er37C2wqvKng3STiqrgnp76KYS1Q2DAZGA04YR36VhvibyMGYBk?=
 =?us-ascii?Q?ZJJLt8drvAPdpcv8Q0FJA9MaMxOA5abtTq19/5qG94FuCyjFT3UJoA+Qc5yN?=
 =?us-ascii?Q?QbDkD/LxW/sahFeTykyH0rFF1SmKIhcPX/Hf/xeCJ7btBjN5pUkKIM5L43WW?=
 =?us-ascii?Q?x73n4FCmH3f8FrqcwZf0w8kTwG/zCGzKyh1uKcGTbxMWGx24y7tOey/onFFw?=
 =?us-ascii?Q?0AnE+AHibu5qSHb6nWe4nAdJF9ocdbwPU1TLPXgbhAM9HaiqeA19l2siPbeo?=
 =?us-ascii?Q?yDLsq/WWIPhJhw8Sjgz+hGc7qsJYi4wUsnbeItvUkO4xdA7d5Th7Ape7feDn?=
 =?us-ascii?Q?OsXLtb4zLt7IL29xp9290M6a7iePTIyWGf9MVKCHfuFPZtebWciLk9JKHtaj?=
 =?us-ascii?Q?/REjc+9Bew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0346fa09-84f2-4fa9-9943-08da16418b4e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:39.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kl6Y3KJa7NZfWL7CihwneUlIEV5kNbEtfUqtLsC420lZ+xVmwPVUNhvEtVLNeqLzbBqioF6wh5i2qFv7jqapXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9218
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

