Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434AE53FD3B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbiFGLRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242771AbiFGLR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:29 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F05F69293;
        Tue,  7 Jun 2022 04:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpxT2sXgHED6UQgBvSb9CiwaQHKSIAnpWzEEhNZPEiq+aJ73pJk5FqWPsTJBGQfZwUBgjaFP/dV6NcXLXoi4ZE/PR89P2qTEYgfYn9rkXu6eejUzcBMZICi0wHJGI5WZq4zhDz9x/9BCFtsCRZlCIoZVVZ6IKrWLO9d3PlW2b5p9wnAbmz3rbYBTLJE1e8PVTZDuPXaEO5SCKm2Kf+aeBle4Jvo6dRA5DxCSTcCOLRIccTwxMFHCmfanjQHcBFCKJ3xuWqH7SHzew8PHdDDUs6daQ/B8nwTOJIrbQThP2SZLRPdUxc3vN17ZDuhaJ0WA+J5i6PL9r6yiqfss2rdtmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wq+Qu0dXI/hZvjc9ug403ECQXPvXWblun0hh9vKXSxY=;
 b=U/V6YR80drkQsWiDodr7BNu3FehkiTJNkUHIJJpYbz9uS/YLN7FpNCPlzWDqZIjXU6GTaa0/NNckNedbQPR5Y74EIlKxWEAOnhu1Bq3H6O9xEirmlt81tUD3Aqk23rKVnv8tl4fDNAps4QmKdATXhFRy4vyoxJ6q/QK65PIkeFSDkjv0lURr2RaqOC9SCWOCCzVwLvs0eo0ozeiqLEJBxqc4wR28LqQifVXxFZcl+dWfhRdYuvVg6+u/+hs0z3ChX84LPA2VZV07UNC8tBMRL1WXVITw7SGaAlgCVfjNKq9GNpSvCivuOnSKXsYiBIl9Cnp48oUzOG1SBRPJExfRTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wq+Qu0dXI/hZvjc9ug403ECQXPvXWblun0hh9vKXSxY=;
 b=RLe6YRj1sRkVBg5efZEgRrq+SgeDLAniOxQ3KwZL745oe8HeiW07PAifslZgq1RB1Yi37q2wY57Fqetg6Eg7fHWf5JxQRxw3UFBiuC6K9cikb4uVepov3+d0wbWekcUfq/TXChsY3MmsIS+Mvjiije2XoIWMhcqjf7LkJTiDy7k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB5084.eurprd04.prod.outlook.com (2603:10a6:10:1c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:05 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:05 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v9 03/12] arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
Date:   Tue,  7 Jun 2022 14:16:16 +0300
Message-Id: <20220607111625.1845393-4-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5065b3b4-09cc-4431-1334-08da48773ad0
X-MS-TrafficTypeDiagnostic: DB7PR04MB5084:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5084056EBA124827CD90F65EF6A59@DB7PR04MB5084.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1cdrN44Q9UvBw21ijJV8qWWwAb5BZBKnLlnnD33LPkT/Yi90yy7yNWTLl9JNZuQWilCD7iQjTBhQvzjWEbdJ4kZS8glmSIjq+9TvjVEV1ZI1m1wHfYEAZrDlA3MfnNVZCYNcw+1f4lBYYqT7CRPGy8yjsiVdzKvVZwFqDEWyQx6d8JseHuN8+n2MW+JX//b3J49GyNzQa64FlHRe+EEDALskpO16GgXuQiZlTH9XJqmCxAPdpjtKl1CWzOyfO0ZU2NN6uUH+bWz6MAJ6yXhG632IVakQ++mhd6KrWlMcQs7tADTCZ07LcAQBzmc0B7ZQVkgwksTmfsa7VvVMC7BBg3UdD05FgmevwagEcmTYw0homnWPEor8ni8oIvUC5DoXRGAeSnRoYpCMo9+skKgCUsW2FftzzU5s5uec7k276BY8QWe3NrJj6R/ymOmb0/oNvdSV+Upbf3oc6ejxDhebI17jMoZJNUeiXSu+PWy91NlUjgDZI6kZjlFZUgy2yhi3S38UWH4n6ptMHf1hCxvX97WOgiFjqyP0KUZhSyEsse36HZwppYEPTJKrQn1u3WqZU662weMlVCkgLY8ugKqtEu15zSlsQdQ7GgNYGhWFuXFYG8TovZWD/y2bs+7FAtlAplt5xR5F7QO5Lv6NFs/ftZfCFafdr1g0ISyX2dPjUyAucWv6by3ygx8NJDDPHyldv5oA2Y0jDCGl/1bs7jvGSFLlBUUHEnVn4yhR5Dx+BSPCoKgfIZUxwUs6IS/K0SU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(508600001)(186003)(86362001)(8936002)(6666004)(921005)(26005)(6512007)(6506007)(2906002)(52116002)(5660300002)(44832011)(1076003)(4326008)(38100700002)(316002)(36756003)(8676002)(7416002)(2616005)(83380400001)(110136005)(54906003)(6636002)(66946007)(66476007)(66556008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FOWmfuAi9e19ACrDv71WpQvVfrXSPoO9UVYFl/ZpiadE4f9/w9j3JQE1lPay?=
 =?us-ascii?Q?s71yrI0JYNmRlYG/ZsQYpm3ac/+eAy2768q3VsvmG523oEi3Tia2vhJnOoIg?=
 =?us-ascii?Q?INn+ivE20h0Kj0bDxGz/2PXZ7w9axDmwJyMyv9rMWyQW9GXhCokPcOfnUlnQ?=
 =?us-ascii?Q?VP+D/4pPV2l/nhLNtuBMAwWKjtOvQpVNppn1wLIH7dCzJytFFOOJT6CI52Gr?=
 =?us-ascii?Q?Lv9R6+4xFawGhku4swiL3FNj3NDjwV1nl7GBVqHeAwJa9w1Ag3QarlestyvT?=
 =?us-ascii?Q?q4WldAfEk8tbfkYqaMmnu83l/TF+akR/d8/BlPM9eSFcGvIzKcDP3AuOltvE?=
 =?us-ascii?Q?Vwuwn2JjYUFVAp/CUtCLQp6d+XeBwrifhYNSqrg4RjfMgFF5CyPHmI8Umwqv?=
 =?us-ascii?Q?i6DBJzi1DASzEZmuaQSTSbM336gWZYAAyFcEtOvgou0FGs3bKxnBRU5M9y1j?=
 =?us-ascii?Q?ZcQyIVcFu/38hbb8ctWQibdQlUcFuxKV5z1DLktJxoD5fc82mmm/+U9T3ubo?=
 =?us-ascii?Q?/eK9tEhOIJ4EHEiiKCClx7q9jO5uJrbMpCGgtGVamLtuuVNxryOSMTuvzHOH?=
 =?us-ascii?Q?7HcwvdCNDWmEDlOjOsYTBgAW0SOMYRvQK+d3S/TTtiLOH5UbePNSfQeMNV9M?=
 =?us-ascii?Q?t+i1CLxIZ/B6inhFS5lWgjgRu4IQKnwi/mMxEg/g/tPgiInpuRIGpD9RkDhn?=
 =?us-ascii?Q?k5cz/TIGSA9VsqbhsiN4zbemQiTJa/9AAFZUZ2a9UtowUNcWIN94eIX1SPol?=
 =?us-ascii?Q?6AIbQZm5jkg5PbreC2SfRtRTfw3g2z1DN3SGcReiIuFGlxEqvwzId+Qvocc8?=
 =?us-ascii?Q?c8Uj9Y72Xl2p60da3qi/j15JraP1pfz2i6YFw/rSWLRb959kSVbks6L86A12?=
 =?us-ascii?Q?3oUmVWv4j6EvCMVuH4i/MxsIfHpScVPkGlIAu9YtA9NcJno/pIiD/BhYBmx3?=
 =?us-ascii?Q?hBFCvCbKSCrYkCFRJ+sAWekJ+M+jEKJFCTSLN0f9K8i4Ag3io8q5q32W849y?=
 =?us-ascii?Q?0bC59NeanSDA3dNtvBOUxOlVxsOqFnU3FFPdnK0xIXWk2KfFxyk3HdlDHchb?=
 =?us-ascii?Q?wG6UKkUoPABf7M1k4hoUHTYYTSRhbEkN+dlppqEVL6wFnZQklo/ozLXAVe+M?=
 =?us-ascii?Q?FHnUJ47E/F5gO0T5oRJ/L6cPIshlAC4aiI6wJCOKKpBaBOi8JfqJ0ZWdmUvJ?=
 =?us-ascii?Q?3OgtL9TdQWadIHNBbVc8SL8BAuz+e+DeZD0VaPweiTPfKFSSH5dvghlZvd/r?=
 =?us-ascii?Q?qgYlJclyaFiq3ohlfxaOkKnwxUhRrFQJJTt87Sb+UxrUi524l9KUBHgKVwcw?=
 =?us-ascii?Q?wN1Zp50IHArEPmg6hR6Gi+q9Im8Zx0ZpK4Q1klRpacxL5BBIhfoD4FU03lnO?=
 =?us-ascii?Q?x2QYkUVVngNVjG0qMfR6SKLMZvpmWNoFj/oqUZq9G8ErnzilybbOAOuhWUL9?=
 =?us-ascii?Q?jwAGvMD0tuGPOuLQMZkytpPsy8bze7U9DG0DaSfgUieMH4ZcJ0NA0G6dpn+Q?=
 =?us-ascii?Q?yzUdBCSl2xPuoiHJKTt7Y7NzTJ+t/edd1Jiev/TagTyXHzX/ivOlEtGESZIx?=
 =?us-ascii?Q?cLgqzZ9nDG2DvrcVPF4jzfHPpVwX9yjyZzd7yOHWJNEBp0TeXzpFs1vZiX7y?=
 =?us-ascii?Q?XEVuY+5jnrgZAXRiICQvSfcc4iSrMEBK0lJX/CJ/vLddRW9IVa/ZDCJqQD8I?=
 =?us-ascii?Q?i0T+yCevlTC7Ef8P4Gsy/3djJsg/1kwCNTcHHbGvbDNtO9xxSxp1Hy4HM2wb?=
 =?us-ascii?Q?+cdVnIdgxQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5065b3b4-09cc-4431-1334-08da48773ad0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:05.1830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+xdpXJt5oRBM8fucQcN9gZWVJqVs0Ld5M3FJJpOUT+/BQanPbEpBnkZiKC6LYqHp1rjt+QIh/GloCGW05cg+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5084
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

Add the ddr subsys dtsi for i.MX8DXL. Additional db pmu is added
compared to i.MX8QXP.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
new file mode 100644
index 000000000000..8a91eb33b4ef
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2021 NXP
+ */
+
+&ddr_subsys {
+	db_ipg_clk: clock-db-ipg@0 {
+		compatible = "fixed-clock";
+		reg = <0 0>;
+		#clock-cells = <0>;
+		clock-frequency = <456000000>;
+		clock-output-names = "db_ipg_clk";
+	};
+
+	db_pmu0: db-pmu@5ca40000 {
+		compatible = "fsl,imx8dxl-db-pmu";
+		reg = <0x5ca40000 0x10000>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 338 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&db_pmu0_lpcg IMX_LPCG_CLK_0>,
+			 <&db_pmu0_lpcg IMX_LPCG_CLK_1>;
+		clock-names = "ipg", "cnt";
+		power-domains = <&pd IMX_SC_R_PERF>;
+	};
+
+	db_pmu0_lpcg: clock-controller@5cae0000 {
+		compatible = "fsl,imx8qxp-lpcg";
+		reg = <0x5cae0000 0x10000>;
+		#clock-cells = <1>;
+		clocks = <&db_ipg_clk>, <&db_ipg_clk>;
+		clock-indices = <IMX_LPCG_CLK_0>,
+				<IMX_LPCG_CLK_1>;
+		clock-output-names = "perf_lpcg_cnt_clk",
+				     "perf_lpcg_ipg_clk";
+		power-domains = <&pd IMX_SC_R_PERF>;
+	};
+};
-- 
2.34.3

