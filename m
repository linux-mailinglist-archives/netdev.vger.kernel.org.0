Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1034F1674
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359332AbiDDNtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358676AbiDDNtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:49:04 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40040.outbound.protection.outlook.com [40.107.4.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60551255BD;
        Mon,  4 Apr 2022 06:46:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EH0UI52faVKH7jLEo2mCLohfVWWhztTDGtcGEdq6U5Z8eGNIKal44ABEtakF7v7gzVvl/k+fldCwkGmnuWD30rHr/3jwLOLyeTJRO5Q8IoO5NZ+GpYIf5G1pjZdKknDufw0qbdk5jrYk96ARzKOrWaCfm9KtPNAQflpqHObtyVVZZui/CTPshcOxtLBEptsucvvc5tpjIoZU5TGYB/4JXpM1+ewDN3rzGsFNwWvl1ufBSz/4UcFIWr4uU92xvEYkZtlkuhL1/YfXSLK7QH+FN4nxlOB9i2PmpkLlbxU1QBCdGYuq2AMqv4p7RmapKFbhED0fyMgfP/2hU+EBxBUG2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29MwMLyVa6BQohSVPla6TZEn2KKYstzoJyjXeV/Xr1U=;
 b=Mth7AjFnsRYLlmI0SOkuDh1nivTtwEptwF0OT/jWxjeRz4CmFAwdtP/kON/npN5EZKV283YYz7MoqAHv2CDD1VZ81FNYWgg2Md/1MZbqoMXx5qn96G6ad+wQ0znRjtYOJApB+O/czC0uNc82qFNmIKwUxd99KE+yTHWjdv3U6DgD0PA3Bw8sI9ybRDoR4MhWtTO/it9ptY6kkcrCsz2w8M6aKmz3aWcUQkV9D5AQKFaWZvu9BBPc0cwIo710Pqnk31xETbeGoo60NFVVxN//8lGDQ0tjN/vRZpuNjBcPQRQGeifw9LQVYcD92jFZM6SYndYFwTBlhbXU6XLoB6JeUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29MwMLyVa6BQohSVPla6TZEn2KKYstzoJyjXeV/Xr1U=;
 b=Q92BUELwkZzEiCln+CQmP4W7Aq2bL4/rhgUQywrXAHmCNYd4ruqQQJf0hzbM3EG66Ti2TZj+H2j5OKnsFDT/No3Sqb6OFf0SSQ1rM11yp7d1CQJlfcwfcm7HIwGxn85W4Ii8WE4aMM5wS3tSWfpnB/4Q1VFzt98Vou1lkLTdA5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by PAXPR04MB9218.eurprd04.prod.outlook.com (2603:10a6:102:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:41 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:41 +0000
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
        <netdev@vger.kernel.org>, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v5 4/8] arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
Date:   Mon,  4 Apr 2022 16:46:05 +0300
Message-Id: <20220404134609.2676793-5-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: bc5a0902-7389-4f26-621a-08da16418c3f
X-MS-TrafficTypeDiagnostic: PAXPR04MB9218:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB92186A9466D4610A9F0A55B7F6E59@PAXPR04MB9218.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7h+MniPbMT8VGrKpaz8JkfiWpVoQEVK9J0pWsbJHj1Xlk+yDGTV7mUmbgWUU6sQFaPb+1t50mGPSsIm4jP1INs/atBvtb1tUZmuSc9458VqQ/fKL24qGw5hhBq4DZ9uQJcDgmzJRE8XKKygNY7nfTeuBDzqaxfp/9LsVX8vuOOonuUgYjWwHdiyvPqtdYIuDfp4T9tSnRl965QF+TYMTRiBJ6CHG07/M0MIyF/yNHFrgg+LS+yTZ2cd8UAiYSt61BhiliLi7IwlzO5JNLKaBCLT1CthHvvq+2ug46muCg2EeT7vQNtwPX+KKbYD0bLvADLvV7jI5JcR+4WrF6EABv3eJtPiJ2dn7onaubLD7vede5uGTeDHgcY2cCLAD55APXnMLpA9qhwomKbLNLDb8pdVvv/e32Ei8mVcNW7dPDKdb/IgLrLwpsL/rjoOVzO/tiS6kZ9ucmFX0fmxM3TKYTAO9yET6Gollv9QYk1Gju0YB23YI0+5Q83UEJL68XUR5uzIH24I4Ir61CebSCf8rQwvgcmASQBVX1Y/R1QmxUCasFuCdgmbw0UayL8pljAUknbCMZILiYmeY/rJ/7LEE7JYwZeclJe81Q60rEaBvsd7h9o6nPaUIvmYsJaE1y1Aph9F4uzGAOmu/pCHTwkEr78q6iwN6J8D7nilie0JVi/R/hDNzwBOmLtoX6i19mHylett8ean4daQGk0eVWE7Cij1QeE/rSSRtqAL+54bWlg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(52116002)(86362001)(6486002)(2906002)(36756003)(6506007)(6512007)(316002)(66556008)(66946007)(186003)(66476007)(6666004)(5660300002)(44832011)(8676002)(508600001)(110136005)(4326008)(38350700002)(54906003)(8936002)(2616005)(7416002)(1076003)(83380400001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nBrny81Tj/tyB1ePg3hjde8OiOcZDqeooQzwdz7O2P+NU4itrE5pDGJ6vfrZ?=
 =?us-ascii?Q?e0se77hQUpyZf4WAb6IlvTN0L/6AyTushIblMEbyNFySZ6jLYLtGQcTFOful?=
 =?us-ascii?Q?jhT1fr4OJSK6dfxI/0N8ZcvxZ1jbQVXKZCDhf8dZvD+FosgoQHYgNcSTkk/B?=
 =?us-ascii?Q?FrUdq+XhUWvrFgdYQ++FWl6/XgBo2J3ALjaupPSD02dLA4UikGK6mHxpx7Or?=
 =?us-ascii?Q?2aa2VpyaWwc2us8l/2o086hd3Wjs5H5YAin+2EgmkGyy/wUJWzk9HkVVUsIH?=
 =?us-ascii?Q?EVRPj0tLsd0iPVDvOEJCfwB2QdMpTCG7JBiyprqb7jSnC4mxuIyyZesWj2jT?=
 =?us-ascii?Q?FXLxDTUZ4LnAQWlM88i9UVYp3sybZfdmXyLGr3Ci0CwT0uX2qKJJbSkpHeWX?=
 =?us-ascii?Q?UTXkR22bi0UGpmdLLcs6EtTNBW0Q40bC4Dz74orHdWnLZONPNb1hjBaLPAnz?=
 =?us-ascii?Q?CChlV1+PD8VEwMPsE0VgYyh5lnjVcapSNqrBi6KhFdpGRY+EtCceHgW5ZPXP?=
 =?us-ascii?Q?KZfVchfwjtky/re1ofgp1qiDABcqYW74ToERHk2/w62wuJTpRA6Php4cI0N/?=
 =?us-ascii?Q?yPzg8MVbYh1CqXQ5Cs1zv93L85IXSTyhcpouIssC/8Vuxf0XBwGpUgU4rgww?=
 =?us-ascii?Q?8Js1tVfJQzRR3Mr2CMuXcnn5M9iB8ulXqS+oufZ42O0rAQ/L/VEGONqpZwzj?=
 =?us-ascii?Q?4nfWUmxebwvHbfqnovE+egs6u+me8pfdOfMeFXw+voMCOYuF/cPbwSKCRDnH?=
 =?us-ascii?Q?eZYd7Id40jbM1G+pReYSgBwxP9iBdbX1cB7G6Q7wU4AEbSnj7OsrZ5DX0NLp?=
 =?us-ascii?Q?XH+pzm8VcQGYWjOET3aBM5KSXRkQJs/4ZLQVJobVHp3xIykoN6A1v4g828y4?=
 =?us-ascii?Q?742k8R8oa3VbllwI/cNaqy+mpdzhj2L/Kk6ytCgYY4hqWOcVZRlLKUEbUvTZ?=
 =?us-ascii?Q?vIHcxdFY+T3BdTjp39xvoilSozBDzrrGXaSJlCShu48MlnxytkOUEQHnzxVX?=
 =?us-ascii?Q?SD07lAxKIxM7eG6/9bpxWpLn0PH/JhV4wOHkjp4gxDxTfwNEmDpoO5kM/ppi?=
 =?us-ascii?Q?PD8RKWuvI5tsGvk38/yXZZSdtSWOsUEBs1a5W5cYLwmC43GMP+gp4ApRfJDp?=
 =?us-ascii?Q?aXsodXU/XA1KJIH2JG5lk5J5esyO947Fq5FQMpuabCfO+gK7mVwBug/0h2ga?=
 =?us-ascii?Q?gida9bHsJ4dLste8WuyDqFAjL72/VV7W52gq/u+4xVqkC+EdM/wsRC7oKSyd?=
 =?us-ascii?Q?xos2Sj2a4WqKxEbMD1oRuf5cpFGUkCaukv2W3aNtVnFvpYOOVIszCCyVGS7F?=
 =?us-ascii?Q?OM5bPG3mNclXu2dN2lFrJmpp8KBXh9F5mfqwaly23+t4E+YInwYftYWTjVUF?=
 =?us-ascii?Q?2vYY/HIy87b6RKIbOYXfNMLx3qbLnxUL1zc9qOfSTWwIMR2Jv4q8nipKF56S?=
 =?us-ascii?Q?YpNETG2HRZxa77YmR0H8AGu0sTrPtgC9/teHGDaWM6UGyogpwr2cyO3v3gK5?=
 =?us-ascii?Q?RoDRHY1xBcI8WrTCevfm4a5AeXNqRGArihd0677TXDNX9D/2hw9f+XQ2n5dA?=
 =?us-ascii?Q?hMY5Y9aKrMwXILJDA12OunFITW8pQrJ5nA9iSiwOCSmqfQWU/n8Img+4JxOt?=
 =?us-ascii?Q?3MCDcjbekMHPOlZ7akCZ48xdYIEVis9t3lFTTEgNGhoU1Cl2N6IRvetiDYGr?=
 =?us-ascii?Q?tqXI7VOam1tGPvcqM3wfKqgiMlQq5aO4LYyF8RK2LOBCVk78RCswqEq/9wcV?=
 =?us-ascii?Q?kq7Paa10pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5a0902-7389-4f26-621a-08da16418c3f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:40.9714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caPd826xbPNZZxyqTq4NaAFBp53IwqiHt9LkSEZlkYk180FdD6lImqq2wHWpw/ftLvDluOy8W+6sx4GUF7JL/w==
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

From: Jacky Bai <ping.bai@nxp.com>

Add the ddr subsys dtsi for i.MX8DXL. Additional db pmu is added
compared to i.MX8QXP.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
new file mode 100644
index 000000000000..75b482966d94
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2021 NXP
+ */
+
+&ddr_subsys {
+	db_ipg_clk: clock-db-ipg {
+		compatible = "fixed-clock";
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

