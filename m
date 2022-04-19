Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FEB5069DF
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351186AbiDSLYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351141AbiDSLYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:07 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF079140CB;
        Tue, 19 Apr 2022 04:21:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSMigpN+t/Yh5aBnyvh9OlR3KQNZsD5D1jLiFkwAUQ2SjTyDZebNXKhu8P8Edy1LkddiS9Hti4BUbnFQXEW0X9mh4ljp2UZD9RFP132rMjsaew4yxuqbNde+THUkYJCqWdb3TggwPwfaMh+t294UQEkUnZ6TmsOI/FqfFDEv4sOuamRROE1J1KtLjbEdr+vEJtVw1ArhJSanfSXrdqanwq0ZA+XT0PiQMwntsGPRSWh9TSgDhLeWqUb7BQOSowpMwbpkvjofZgUG4u9de9pcpJgoszGfe+JEam5PsbTBZ6HknHWClCsgIOGLefOTWhyKZ+nFZvRbmYsC8vYkf1AAKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fC/nV0MG0NTbLa1AiQ9fkKfoD8CVRJeyZh32v6xKE+E=;
 b=dh7eXQe6SH/ewlfc9pSxhg1Cod/Xs9J8tQJmZfmTqJhCM6nFmRz/XbTwE9dIwsK4sKXNQqVqEq63t3BJrmb6Omv7bfxQYELC2VpMNZ4VG4AzSBwY52puBhznOtpg6U5KEqtVY2QqsCT/ScURJxfjJ+ffyk7nP9A5UwPPlmnKkDB3T9kIgls58t9foGAcqFJ7O1xBm8XKSlSoASkPHicuGf/1ZDK9+l0bk7qkMspY6Kf9FHEOyFiigjlVmN1ibwXgi31JjZDccrkUwexEcuoirA0+wwCFOlZPeILtoV4rw+t1yN7rH1bUOxwFu0buNjt+bfsM6qDLJOKuRJqIz6OghA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fC/nV0MG0NTbLa1AiQ9fkKfoD8CVRJeyZh32v6xKE+E=;
 b=ma210DsSQcoZilYMZlugoRkCpC6UUOyX1yfT5L9ZzoypWn9WkJ2gNCghDxfKBc2Zya92Nnkv+sSidde7IdfOY1w1ckI9Lh7JzLrqg0gbc/4nkoBeaq/CNJvBH1BGgla7uajT1zBhw+vKSCnWCVmdRT4n/twghdJvBZkeWJNqyRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:21 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:21 +0000
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
Subject: [PATCH v7 04/13] arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
Date:   Tue, 19 Apr 2022 14:20:47 +0300
Message-Id: <20220419112056.1808009-5-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e1a25b6-e111-4fcf-b371-08da21f6baf9
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB7538796AA85E7E78CB0FF674F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWaXTxVHdFh+tzUkTE0xrCgRNVUZxB+AJhngVs5nhC0WL8gpEHz9+HT/Zj8ogUu0DH70s43fhZjZ6VmaB7bCllV4WNklOkbrZhCPT/X0XrtPfAyOKLUWQAUWWUlgSvRA2fjxsCa2jPD5ph4VC4LfdP7jVLuULUBH7tJgvgJpyvl0d20UA4Tew3oIdQIoxKs1qFcOIoMF2viv0FhMWYRh4ATQqqQFD+S/AaXVv8IKdnFZl3Tw0JS1lkadLVsH7andUIIUHmDECLIusa/CRAdtWAR+dcNdJcH7EqT9mNIL4HnV5q8SZakd3HC04Ixl1rn5cJEhDJ1gxT+N/hLk0qkbWWCpFd/Yf1GlefFjxV8wFNRXtG53lUr0sWx/xAdJ/FHeus3RmSY4n3HWhlXdo9ivnM77OA1axgdinhqgRhzqdqvRay4z7EIqANoxbz9Oq7hp6667GbMa46QgMfiWPh1/KUhlpZLHVdkoCbeprJOn7U0bNVwse4WvmKxaz4EkKhISk5UFoPH0SGA0atM2Ea6y+fhqUe81Q1r+eK3bXek7xJPHu/Yqmok0MuUgJQ0eI/WGSI3/fNpFgtlB0EIX3xRvctPKA8ny4AA3hMqycLSCOwkXrWQo8k8ynTmoxMReLyvK5t79Mzpx8X3LM360L+FdGIYKRt9ZNYnPGBCT7OPX+LtoW7uAAp2mfU0cgVnflTXrH4I/PvO6vV4NGt1gr6ssFV6gh7fvOLYei9/vkzfQc78=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(83380400001)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9AeaGh0Z6rHxNTQgn5mgkfEZrcatIzzHdtad+oWTZS9tB6ZRgC8C7hoZqVJ7?=
 =?us-ascii?Q?67KV/yLYJAYGsmVEpOtNsa9xDbp2E4wZS99vRyEU+D/Mrf8KypppErsWWPzp?=
 =?us-ascii?Q?pKo8q9u4dieqoCzulugvhdCPPFBK3dLeAnA+Cy+wteELvOhy4j3F/oRGYmin?=
 =?us-ascii?Q?E2heD9xX5a35Xt1iFba7s6xPNdOumiv9up4RZQ48onDGaCgESLp9Va1CxpIw?=
 =?us-ascii?Q?cnfyrsXdJS+301g39EAG0v55V08yXJAPtd++rwdJV0WbThPs+Ra96fCTStW4?=
 =?us-ascii?Q?OLvJJV5wArwKJ0yZNyae1c4TuyA8am2ZZWsONQ7/XVEnJpMAOL4VOBidSYjd?=
 =?us-ascii?Q?0WV/74aHiwvVfrOfA3DDt5eV8vAEdj6/S6HhscsJzHqEeVKfxXSGbugQWktl?=
 =?us-ascii?Q?Kb3k8GnUXd8oUgn4z8eyrzyGRfuF7dcFh/LVLu56QrKIBbdXJ18j+NogOsXO?=
 =?us-ascii?Q?02s0jQapcu8dq3MS6ecyppZcRTi3x/jyuh/mHL5sPk1j8ClQWysTmPCJgZgk?=
 =?us-ascii?Q?krwIvNihpOOkaMJ7y8PcnPXKZQQECp2U9Rd46dzSmyyJ1LhDlaPfBW5F74me?=
 =?us-ascii?Q?eQsYWo2IzwxlpRwr1fiRA+PyUMMiCkk6ku1JkgMtLR0kWygDxkWel62l/4y8?=
 =?us-ascii?Q?3suuekb7xvnvmgPZaHs/HSlfJyM7aiszgOdgcjpgff1ZdwlPa84+LebFA6S6?=
 =?us-ascii?Q?o8bJE2DZ4ofYHT2E7Zgmewl5PAb8UETtUlDGz2sXIQdNprFyxBYS7LtHTfAF?=
 =?us-ascii?Q?Y0+d/7ggpLfie1uTsghre3/AVP+G9gq9/uaHblClu+VgMqIDEF5dQ39Pq00l?=
 =?us-ascii?Q?rZrEEGYATqtiHNB7SiToMU4IzfUjB4du2TvtaFz1747KENYQMu9NvIVdj4if?=
 =?us-ascii?Q?eh74Cq2pSJs5JEb2CmtzcXI/hhvSgWfFpsi5aWWTIeGNmZ5X7kLq3Q+CoBb0?=
 =?us-ascii?Q?kM5FfvY4OB7yv8VMGA9sI/fp2hImdXtB6Voprh0D6OEQ3VFyxnlPdsAbn1Bl?=
 =?us-ascii?Q?8JBDr5s0pbjQNRzKK1IRdmxDQv930ELprgFmBU/0daZkgI3++J2l5+8ryj/m?=
 =?us-ascii?Q?m+QwAQY0uXshxNJAarHsOvB4C/KsNDYlHOn+uVrK1hxezxsnzAAdV9Z7Bna0?=
 =?us-ascii?Q?xHU6nJWmAL0NDxZikJnbgFq4uDOB3LqUMm5k80dCeOuzNNXM5V+7Zl0DjG4j?=
 =?us-ascii?Q?XMnc+o7GR2ssluQiL7JLKl/gK8fUYIFVL3lL2k5D6EHovf5d6SLz/+erMDWN?=
 =?us-ascii?Q?hoXwWpVydG09T1J81DtLQWmTiLQPIVSnrabHxLuTCMataI367rDfBHxX2Gnz?=
 =?us-ascii?Q?wVkUO/XiQsGruRqPoOfKolLGg16VFxHFuJ/B4ZKybIRVEWF3Rc72gOOr/f4D?=
 =?us-ascii?Q?P6GSQGP4+Cb/bYN14xpHD3eI85pGKmUdQ9TLywUWqq6LZ8nA2axHUfAtwSP/?=
 =?us-ascii?Q?RCb4wPbcD8hFVkXMp9V86jKxDSiv96w70eKLhuvR3zgkLOKlW4hNg2hWQ+HD?=
 =?us-ascii?Q?SjO/RvWQMMmghCMEDQ3CttpWZr2tbmG1vOogURlacMLG2Ae+SlIOrczfOcg9?=
 =?us-ascii?Q?zH5lfiA0cJayo4hTW3XtsFo8NGvhmCJpFU1NwwVRGumYQTDRKDeIxguF6EDM?=
 =?us-ascii?Q?y9D+8uxM5FmXqMpCsaHmej9DtF3x59HSpAqZhyV76ncaCP7Z15SpIYUkvu5m?=
 =?us-ascii?Q?uz9fC57x420ROphznhwmTT1ck8LudXgeT1C5vSphQC0UqAXgNoq73xjRbTGr?=
 =?us-ascii?Q?A3eG0CctHg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e1a25b6-e111-4fcf-b371-08da21f6baf9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:21.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xM8XIST1D/i+Wqx6IwPdYzytau+/DHtH7PtlPV5XPj/YmneiwExDCwdR+KhqI/Ye1xx1Mgh9W+5QTsT8zFVnHA==
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

