Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C52B506B09
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351669AbiDSLjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351656AbiDSLjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:14 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC20255BB;
        Tue, 19 Apr 2022 04:35:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYudbDNjblpaU3AJI3PnLcWE9DrfHO+RAD3bBI19WzBb+qwCKhxZxzLGtjkohfzuVJ+MTFCIQRcWAMH5DwiFO5i64uNoBNNix80YvmKXgWvyD7Qf+F61xmIVpNolQJ8/1+NwLqdOR56hUsUcHxPq+PbrhVUypMqT3BtAa2EA0S6vDL7Y/I1lsmBJO2W6luPmppvasXAcMCaw4AWfgUnea1ncbI9hbFaaocNp5i5gta4Bh002ImhL8RE2ZxAQiE8uyjPt35oNKJ3CJxe6wIDwvI0u4abP7bmLbYBb0iG8TzP0o2kM3bXkoQ7G4+47jM4LcJgieuivbfoYl7za2gU7Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJ1zyprXyaDqs2f/1Gpp6qOrzuHRbM+I4B5BwmIUfgE=;
 b=RIf7PDqjoe3yVKNSiTvt6qRnjaCuZYit7UAHPAGvUAyNL+e3hZsHMH1vhYzizDjhmJhwoRjFTBaOfizCc+2KvEvYi0nZmRVAYNQSo2nqnWs1YGcC+Zr/uJtSqQEsh56BMOx+HIDpeKxWGbS8Q0hnO9gMkk6Pcg/afyoWP7db14ugKpGwNfqZBgTrp2PLReH4y7dnu/F1EBWl8dm8IrSEfni4p+oOqrnYapXs62hGWfAGRhyvuw9FegNMvqTvCod6bUz/3fYD8xqMnKFWGb3YkeG7uViyFUPTt8OGVMii6utVKBNRwJjbn+z2vI56QKwdlc9xJ9aa/uwTUgTfSNf9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJ1zyprXyaDqs2f/1Gpp6qOrzuHRbM+I4B5BwmIUfgE=;
 b=JRhGT/pH2IL8q5JU2D72lIgGC9dxxOcluIFFdOPx4nTmptIESvAgtEM9sd7Bapp3mpTF4a1VnT/pbD/WGs9nXxt0ls8wg7BGOzN5npz59KwY/5XGwk15Mkh6qFV65gGbW/hU3OMtKBDdojswlByGJFspemo/SvWAPAvgYhSjm1s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 11:35:35 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:35 +0000
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
Subject: [PATCH v8 05/13] arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
Date:   Tue, 19 Apr 2022 14:35:08 +0300
Message-Id: <20220419113516.1827863-6-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: bc4286eb-20e2-4202-11a9-08da21f8b7ea
X-MS-TrafficTypeDiagnostic: VI1PR04MB3054:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3054388D2C0F2DA0E295C796F6F29@VI1PR04MB3054.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVjPaXvoP/Ks3V4qBYFos1cuw3Xa7VOFDBO1qLE45sBhb5bUNV+BXTHQbLmxkzh0uQFKltjC4whMJgGYbSQuRWGmlXafiutmd37BkTP6VzkERipNLQ9g1Z9I6TVS4bdbAIFcLCKe5dlqDVU9rqE0uxYDvkXDXqCRBJfQvuGScTF/x/rLJ4F/ZU3wirMJxekLPjoeLh6DTxCOpaa7TbNqHNfzmcFyzwTeOsMZzyB3iIEJO+n11A95bd6gdHRX4rZONyQ9qMC+CF+03WixlOcRPmGQB+shIFDvJWZsSXfb+bXr+JJmkfiOkObqFsq2cqFa72Ky/7I6E3lWqSaLNgYjRuEBHgfS9uI6Z9uUJk60b1YhM3qppefN0SXNZPNLpABmfnBY/u+jrg5cTihoT7kVVRFnMQ7KfBbMfJUP8g0gyrIBojiu/vAAvPEO2LWBnwIRLg3pCu6NXd4I67a2qhgHWiKrRU7B53m17u4Xgr3ddgS+aDAA5ULFPQczK1zRQQqfwCJ5hGRXiu2/sOEKctQIgpi+aFiyK0nfec+/tMmGI0OgmtD4eJey7YjrYaXDKicoWeJpZwqBWknV6qKMn1bvllqgH+cue1bKaabid7Tc+gT3u9KvMNovPBT3XY/N2AgJvZiXz16PckqP/qTQghiercvAGqAXGaqZqz9SjUFapNYgN6GURp84HR+3O6whA2AZPjkC01d97QaKUVRX9sAnKjVf/154WzGlYxgMQLozcaM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(38350700002)(38100700002)(54906003)(186003)(7416002)(26005)(8676002)(316002)(110136005)(6512007)(5660300002)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(508600001)(6486002)(8936002)(2616005)(44832011)(6666004)(1076003)(86362001)(52116002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S7IIGxLv4K650gysgLcL5E0uWJyUGV3WqmeUA1zWtToNgOk0O3hqHH3s/epJ?=
 =?us-ascii?Q?GVWNTsUw21qL6g9vj9N65oQqSRAT5hRAB/dDTpxgkQXSZyR6+DkU3nV4h8z+?=
 =?us-ascii?Q?x69VzrfimQ/saJPPhU0Av2TbEwHxBrkajUvrfb2GF0qF+4mySuciJUan1V/R?=
 =?us-ascii?Q?5TNVnRUjeDeVkqKfWT2mik9T6FS9N8u6kBOv6aki4do8f2pO5gG048f+lGmx?=
 =?us-ascii?Q?CMbr/RUeBnWu28Tfz8G5pYg3b6PmbMKySrByqX5GBQe3NvLizQjXBAxUx73r?=
 =?us-ascii?Q?qQUATD/zeMibCKrHKUzTTbc2eNX93mbtQVFItedCYOUvPWGJj624jH0O2Blp?=
 =?us-ascii?Q?nDSQ4WR8a08+yMEfIp0uCEApjpvWsLGbhRk7Zji/HmExDKKM7dp2EJIWJJbP?=
 =?us-ascii?Q?5rz33iB7myz2R+fh3BfPh2c+wYmDoF61lp6QdDdfQptOP5XEiVkZKCCA8fCF?=
 =?us-ascii?Q?QWiqBLJiH1ulrwGWcG4juJdU0Q8y4iYwcpOMt4OLa2Ss16oX5uLR4mIro59G?=
 =?us-ascii?Q?y/FmLZya8Pg2goG8y0MWUULhjMq7Ty1jkSMreP8AQg/xud4BuEQXUhd1hPW2?=
 =?us-ascii?Q?GYFtpXSC+UPDN9HT5EDrjXWyYTeop2JW9i6YkHM/1StRt6Q7OOJbfeqxD/cB?=
 =?us-ascii?Q?YQHqYz5giPwhgfef6fq7vqKFa9pvSHEn345hHvMKY1gmlyywghGDOh7GHbcC?=
 =?us-ascii?Q?eQzWiBW/kZm0SwkBlyA0f3GRkPzUCSoL2K/h+xyia1p/NuoK3ft6ivMr08tH?=
 =?us-ascii?Q?Nldc1qqjdEvnKVFOIw66CnYTED4LN8sB4gS1hnyGD1/dAuC08nQDOIbK2S2N?=
 =?us-ascii?Q?xLdWr+lzv36wSF7ZhCyjFJ+DSCYumrbN4UL/hN/E1qNs9R9ilnH8jnkR+u4z?=
 =?us-ascii?Q?B2KBRL+mojKUMcED2sn+JtUTSFN65FWX1F9+mXzR/tBs/W5Ieyx2vQI6HOtL?=
 =?us-ascii?Q?YGggEn/u43hW4cxJor2p5PBnca4895CFA6nc0FBRvYrxCzABn267crMKJiBk?=
 =?us-ascii?Q?6HF4k8FmmEBUqf/q+jR0mFT6igk1LDdqqsxiOZtEfBtL2kiB8YUnfZTq73W3?=
 =?us-ascii?Q?TR5ohhvRbIli//Txlb0rn+VWVXQRrdteKVXjUFLLylf2P2bfeVqiE0tE2Pnn?=
 =?us-ascii?Q?CkJBDJFMF2frgnuITZfr8LyVpDRcj8zvRRtXkY/Gq+0H1m2zVgGirygojJRu?=
 =?us-ascii?Q?4/2qfIREHCHXcBphsOzgi3P03jaP9kiUtvAN/RNcFJm/GtN+KfoGqJD7/ZaO?=
 =?us-ascii?Q?+5I303A4Si0VqY6PUBbh0eUgthJA63SiscnW1N0AdFSU1ZWW2SR/dulHlgP+?=
 =?us-ascii?Q?QeRcUeDNL4AjJ/uW8KmPde5tlz+Fl0oG96dOGLIy9cY/ocZhom2gSsRJbkq0?=
 =?us-ascii?Q?MHLiwCOvAS1QS8c4lw6Pv/dtpjxpgYVM3EvzV/4BwOnUrpAIj56mVTLI1Pvx?=
 =?us-ascii?Q?NyY7tKoQmjrnrw6QcQWyrIJ6zrsiD/F5LGV7PJDsYxuNnt47ET6ZDSAS+D55?=
 =?us-ascii?Q?nTf/MHKehSgwqXNnavVLVBsXtE9jGuxwt3bHwEGPxt5KgiOtKEy5gnz23RzT?=
 =?us-ascii?Q?BkESvTuq2Ey2HYpM2HX5pwIsDEZG91Bz14OLlY5KHFaOmt39Qt+lzkgrRYs+?=
 =?us-ascii?Q?YdjCR3/jpZIGbXZfGSNZxxYffeDns66K0KVd6Ah7zvTw5a18kRkOz4IYmLUU?=
 =?us-ascii?Q?EMLo8DcD1FIkDxPHPccU7goYZ1BMbTjZPO+jOfIv3M5g5Z4BS9zKwcXe+w0K?=
 =?us-ascii?Q?Skpzkg2jHA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4286eb-20e2-4202-11a9-08da21f8b7ea
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:34.9085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SLts/x8VAKGNxza4pu0drueouOLexOKamcFrCmLxQx4k3QHszCrWziPB4Ti8CaeVlRh461LqL/Y7TwycFCXeuA==
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

