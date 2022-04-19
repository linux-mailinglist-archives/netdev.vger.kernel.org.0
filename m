Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C261D506AEA
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351735AbiDSLjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351648AbiDSLjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:13 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0809338AC;
        Tue, 19 Apr 2022 04:35:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8zJgS1vEeX8Kl5NzrNxlTw/QK+7oF4smemTHXpdX0ZKEfmn6y8owewHUVlB/NRdPP9sTsylw5vlstZxjEe7IxWJdKPRyo+WsI67u3FyHPzl8uyUb0+w5kh6gVUS2RKd4S3azH/zCjuqBYsugyM+cjuTgHRJt3zSUIlwFeMNqC1hY86hXvx8DdhEd0WYVc8rd2hV1G9Er5ntpQnqc7HV0TYP8jqs7vpWYFipf5TSjE5vfCdc0k+uZGG4wwmQl6649OlxrdeOk5sAwgEQM4neKA9U0pfhRZWlh+mNI3frq9Y/ZBRC5RKMmOlmWe+Az9H77uPNkyRxT73pUSZdYms6Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fC/nV0MG0NTbLa1AiQ9fkKfoD8CVRJeyZh32v6xKE+E=;
 b=feJ6O+xwn2xIYm/ZW/gmR2MWaOYtbhjddkh8VmGM/MuZzgPfNVyrWLtRz+j2peFGEJ3TZ1E0wNYqxOrtys9CpbVtB+AswArS/XCkR9BXSfCYFJDqF9jO6zLTRq/Rhh42n5wbmqsUS+gXa2ZfnfyqTYKXVDzpa8dxiyg5oFwMhSWS0MSqP12WHIYisK1iDuuMi77o6pZxKKXXTwURs6G4zjfl/h6+nalUxCuORpnMAOuWXRgM2nLKrvjsbay7dGoZvZhn0Zm/jezXs6inTT+z2jc9y3MiBTBcJdJklxjmQa+JQVnqeBows9HiWlKYg5XJSDTIerbfJvQzvbZK+3V24g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fC/nV0MG0NTbLa1AiQ9fkKfoD8CVRJeyZh32v6xKE+E=;
 b=FPhCzlQZ/ertwa5zVvEgFcPlodrEhpw4/EOnZX85y3zotr6uhfJoCw6KOmkJYzkRu7gInzluyJ0vc6dxeGDuDgQkmU0WFiQDCxVfH0jUTrI2BTGPKOIap+hXuOt3D0iiMSh4Eoggw9y/aVyYPXpTaV5rOMwOof46Oh6mKyJOjU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 11:35:34 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:34 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v8 04/13] arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
Date:   Tue, 19 Apr 2022 14:35:07 +0300
Message-Id: <20220419113516.1827863-5-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419113516.1827863-1-abel.vesa@nxp.com>
References: <20220419113516.1827863-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:803:118::15) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21d203f5-65ef-4696-a2ff-08da21f8b777
X-MS-TrafficTypeDiagnostic: VI1PR04MB3054:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB30545ABFDE504B355BDAA0E6F6F29@VI1PR04MB3054.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62QTHOZZGZqSGdxcULFGPWf0tltDZH7fGLi8Ra2gCg2HF4AMkyk3K1Ep3jqbMIN8tggrOLBZyeZTRfOOP//DSTviXlunQ6R41+NIjw61O3zrkPXdpx2JUdhkxeJgNln1yVT+9C4/+Sx2N7I2JlAXBS3BSrYd+PEl+HrfdYtj5ffBGwi6hMeJIZA3o95BINK1qVvRc0punEUVJqTU+3E7j2wUQbgExEn+ykK5HiUacd7kB/7u9U+tONTU6HZ5qNePo+hbCsdAvxnSHFI/Mc8Y4a+EVra2JyNlgKCqCIETTybVjqQG9g6Etc9Bb1679yQR8BBF2IoEjIvk2c6/kPhoVGN27acgdcfvRbJzIFdenJJnrnQDVIauxNgijuaVwz4a95AeiMb9jzAlnsdx/m/HJk0FsthvB7puaPiv3MDDGrJXnBF+/lttVRTGixsEGQp3AuC9OXZ7OpJ6cE09KTj5twS/HCj9ZLJyvL4j/h030Etp0uTW3QsJ/jMXrco106HxMddROSg5Q+phzMPR/sCbH3HNF8d3XfW3iVUvkQO9+zYfq6COlOR3R/f+zOQKugZIubZv+p1ddIpUg+XUkJzkTZSiuYBGyYr0MDmo/ka170oMAryESpzOn45F9JusGAGqJFH2nStCZaMpK0Glkwtx4jY0j8/8/KIM5whWlIO9BbIrV0t08cvPBR/dQgfY4/FAdP+4q7jB0eYaljAAJ/3yZir15sR5mvlA+2CGFVe6bWw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(38350700002)(38100700002)(54906003)(186003)(7416002)(26005)(8676002)(316002)(110136005)(6512007)(5660300002)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(508600001)(6486002)(8936002)(2616005)(44832011)(6666004)(1076003)(86362001)(52116002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iMcN/Z63aIIfDROhahkJ9SJGVD17nPLZsMLeoi/pkQMNpV0/ep4N2udU53+i?=
 =?us-ascii?Q?4RVO2aO1Ed46adpP3nZ5dpEwLKFELHuaugMfeOmwU/Lh/gsFhvUJxI2dCper?=
 =?us-ascii?Q?uckUItxCzrRpVFhdMZHbBZsvN8qrwjjGxCYlPwYnIm8tKU6sBCRVeKwSrIi2?=
 =?us-ascii?Q?CI2vPmulRviG9rmZQYvCdF+fAsqFtJJdb6Xkt30yczRHIz7ZRX4QWHLxPhlA?=
 =?us-ascii?Q?QVD5cVVJQ5X/BZ6Iu2k5FeVRdXs14TKGgRzC3P4L2Miv988ki2xnU0vnGTsQ?=
 =?us-ascii?Q?12XnoJfmxbW9R+eWyLbzQNG5XSt/xBYXY2R6uM1sbSbhVijbCewrIrnaGTmq?=
 =?us-ascii?Q?DDuFjIl+dTNlgPWEtv/NCDJuby9duSnVswVKgtG65IW7qIJT1XZGGYZseN9v?=
 =?us-ascii?Q?kN2SR+fD5Mz2AZjuqJjPhevntaBtzJyVzzs0m/gxJgn2vS0Eacx8c6lZkyIH?=
 =?us-ascii?Q?bQm/BrfFb7O0oWLc0t6r8R++3VcYGMlS5x3f/xU0bXCUmWRuiLuNZdSzs13t?=
 =?us-ascii?Q?zM5ay17INPzXhsP5FEN0tG0lOeuZXksLcxftRXVYnJNnfVl5ztldK6uET2jO?=
 =?us-ascii?Q?9r4QNENyGfHZPLJBDx82qdTCtjqxX6M3ARh0sFGLqQrAfhhpH/RvlfS2a/nB?=
 =?us-ascii?Q?Yj5NtvQ1uRPym1Mpvh2Tza2ERZ61KJK33fu0r7OzgUYCgbDoosMlyrBGbPc9?=
 =?us-ascii?Q?x4FJgDREzQ1sDQ/hI+HjJMubblGQXF0bpuPGtFWOnY8H5zG4NPI4NINRat3+?=
 =?us-ascii?Q?OiLPyCt4Gd9dm0rAmDXbPwLIVJRJzCQLBjJ5Tam+6muz98yUVxwBgoYyiTH/?=
 =?us-ascii?Q?J6RSOJah4pNwwNJ/QHUow33QeEDrecQGO0TY2kvamEmy8ByFQQ8vkWh2qK2x?=
 =?us-ascii?Q?xoyprfIj2IA2zsPMcX041IDaaW0pKX6gaanwrATuBZllUf92ATAqcCJAB0FW?=
 =?us-ascii?Q?1G229yj1l0CqaAt1kMaJPKaor35AFDrUMaMGpqyTuaYQIAbd9kIdaluwYZFq?=
 =?us-ascii?Q?aqMVzTwT2EKJGobW3pGWGqtTQ3qJVLiWgEyzoaP9Z90O3Hul0y7mO3eTYmCo?=
 =?us-ascii?Q?T1pssc4zMED2h3Bp0KMQdlgGS+pKzpqArJs6D35giJQA4J0j1rf9C/lhsFML?=
 =?us-ascii?Q?SKMlXkV96y9fiihTA8T8/3LEm0SoC6SJGj+vVeNkAxe6qeLFl5rQy0PInGiq?=
 =?us-ascii?Q?Vd6RVq8fEVenyRm32cwkPMPCi6BWJvlw/fRPKxUy8vQM9B8i1IzVnwAiARqm?=
 =?us-ascii?Q?d22DmdUJmQZf66SlBRN6iYOkJ9pkR3bUNpXDg0SAjqjYBI+ztm2ZtVX9CsEL?=
 =?us-ascii?Q?Y44d24zUseWrE7b+c2H6e5ukWiC8LOSzhfArGne486hAruBvok8GIZUNVMun?=
 =?us-ascii?Q?fHYW0hrgsKaw3orE5FgjyXZOafBSnyU4dCHbNHxt5/+V2/QzDBnIL10W6l2Y?=
 =?us-ascii?Q?Y88Lnw8VHqyR3n4/L615wjlD5NeaJxWIXBu4SdpwBHHBTbPmyG21xWfThG/P?=
 =?us-ascii?Q?Sk5WMqv88aVfHkYmJk8bXSLaQcniLN+tPsF7INd9mSB2E1Ud9uEqpPzsICH+?=
 =?us-ascii?Q?/TC4nfSVR5W2bmcwuWT4O/hvDAwWshwyrIu0nnbmAa2B/zajV1ofxxiiMSOf?=
 =?us-ascii?Q?9tmDXWR6kdU9X0MZIE/N+zxH5dNKoaCvnNDZ0Efyz3ra4znKuNqQjsPbZloM?=
 =?us-ascii?Q?CC+eGf13nSdkK194x9alavXw42eFX1+FZ+FKyv54+EjU2TJi8ipM70vuYfXt?=
 =?us-ascii?Q?EFPQ4Y/ClQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d203f5-65ef-4696-a2ff-08da21f8b777
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:34.1273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQApOV9UXnwH+HS8mc1DA7xW21uPXWQRkYF5gzPEvZOCLCJjgBWl9hyHRX5PfmGMTp9b+3mbZRDdZbNPZnsdxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3054
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
2.34.1

