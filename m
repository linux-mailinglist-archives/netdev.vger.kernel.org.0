Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9611692743
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjBJTpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbjBJTo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:44:56 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D801EBF1;
        Fri, 10 Feb 2023 11:44:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj3Cd00s/INzgp3ZcS5H6iuX1NWv0FQSvJnRTbdg7mCeI4vqrZKkDOgE3p5SS6BR3zeNrMS9z2GJ6LvLiE5KnckY84xZ+d6TvU+k8F4tyjIXdNyGbc8JaB0xCU3vXtyplqMCMjN7Hc2SkuW6I9dY4sLeiuu4WyubSpe/+zTZE114LRUDmhk1bk0oxVCsd+ZPTO/yOTUheRe7PFcKo5J3oyLIqb83oVwf4BrDVPtf75fwOXcAyImMXkF++9uMGAWdtoXvkUJn5NBpNIf45smgU96hd3EXd+QrStQbfiNRyLpsjQSmwjLFeFCouDgTDkmLK4r20cJKof6Tle+vqbuGXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAhIOHKu4HJGlav21Dv/GMi46fbF1Mnp5ITBekjHuvY=;
 b=i/RiXFcNAanB5VEZFo4YaneB9zxVsx+2aRtC8kG/PV2hJgjLx657gI2zib7cZe7oiVJaEeuNezYfESfV/5VU97EGP1FS1vgqWLnqEAWPgobhQpHtbH2fG1X1a7g2GiSlev2x+plYCQtOy4e0WBlTYxc2z3+XfYQoKexbOfsKmx5aJiK4MXHGijMVA6E+iAONDN/JwDAXJg1RnuxzGOSXyftC0yVm8IdD7GmDbsBT0sku/d2AXaq9qV3P9CD8fn+iMjevXL+WucXGa+kslwSta4vXRUcM8QEe+PDMdnLQgqpX4KfW6IYgphgOVa2XJoWiEnbj1Bo8utBNwE/oG7X/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAhIOHKu4HJGlav21Dv/GMi46fbF1Mnp5ITBekjHuvY=;
 b=3oHrgSg0X9MPp43eWv9V4n7dGtga83tkY1ioxxIOc7o57qDlczDuq7HblUtqkV3ZokCRnLJJq/Z6FuP/w1AEChIiHOMHVzfJWhyrHpS4z58IamaHuUhVeH6aPPt6+qMEZxJAxdOCAMQHbDfPcqTsc6hjzPgne0F3hLi833ILGSc=
Received: from MW4PR03CA0119.namprd03.prod.outlook.com (2603:10b6:303:b7::34)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 19:43:02 +0000
Received: from CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::fa) by MW4PR03CA0119.outlook.office365.com
 (2603:10b6:303:b7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 19:43:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT093.mail.protection.outlook.com (10.13.175.59) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 19:43:01 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 13:43:00 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 13:42:34 -0600
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <sanju.mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
        <clg@kaod.org>, <kdasu.kdev@gmail.com>, <f.fainelli@gmail.com>,
        <rjui@broadcom.com>, <sbranden@broadcom.com>,
        <eajames@linux.ibm.com>, <olteanv@gmail.com>, <han.xu@nxp.com>,
        <john.garry@huawei.com>, <shawnguo@kernel.org>,
        <s.hauer@pengutronix.de>, <narmstrong@baylibre.com>,
        <khilman@baylibre.com>, <matthias.bgg@gmail.com>,
        <haibo.chen@nxp.com>, <linus.walleij@linaro.org>,
        <daniel@zonque.org>, <haojian.zhuang@gmail.com>,
        <robert.jarzmik@free.fr>, <agross@kernel.org>,
        <bjorn.andersson@linaro.org>, <heiko@sntech.de>,
        <krzysztof.kozlowski@linaro.org>, <andi@etezian.org>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <masahisa.kojima@linaro.org>, <jaswinder.singh@linaro.org>,
        <rostedt@goodmis.org>, <mingo@redhat.com>,
        <l.stelmach@samsung.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <alex.aring@gmail.com>, <stefan@datenfreihafen.org>,
        <kvalo@kernel.org>, <james.schulman@cirrus.com>,
        <david.rhodes@cirrus.com>, <tanureal@opensource.cirrus.com>,
        <rf@opensource.cirrus.com>, <perex@perex.cz>, <tiwai@suse.com>,
        <npiggin@gmail.com>, <christophe.leroy@csgroup.eu>,
        <mpe@ellerman.id.au>, <oss@buserror.net>, <windhl@126.com>,
        <yangyingliang@huawei.com>
CC:     <git@amd.com>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <joel@jms.id.au>,
        <andrew@aj.id.au>, <radu_nicolae.pirea@upb.ro>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.beznea@microchip.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <fancer.lancer@gmail.com>,
        <kernel@pengutronix.de>, <festevam@gmail.com>, <linux-imx@nxp.com>,
        <jbrunet@baylibre.com>, <martin.blumenstingl@googlemail.com>,
        <avifishman70@gmail.com>, <tmaimon77@gmail.com>,
        <tali.perry1@gmail.com>, <venture@google.com>, <yuenn@google.com>,
        <benjaminfair@google.com>, <yogeshgaur.83@gmail.com>,
        <konrad.dybcio@somainline.org>, <alim.akhtar@samsung.com>,
        <ldewangan@nvidia.com>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <michal.simek@amd.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-amlogic@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wpan@vger.kernel.org>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <lars@metafoo.de>, <Michael.Hennerich@analog.com>,
        <linux-iio@vger.kernel.org>, <michael@walle.cc>,
        <palmer@dabbelt.com>, <linux-riscv@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <patches@opensource.cirrus.com>,
        <linuxppc-dev@lists.ozlabs.org>, <amitrkcian2002@gmail.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Subject: [PATCH v4 13/15] spi: spi-zynqmp-gqspi: Add stacked memories support in GQSPI driver
Date:   Sat, 11 Feb 2023 01:06:44 +0530
Message-ID: <20230210193647.4159467-14-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
References: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT093:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: f558be0e-726f-4f70-2ccf-08db0b9f0541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7fdiMPu6bMRMnyZj6QLAOEi8NKNx1jcTc5n1ViIbFI7ikCnHpHNSaI/cwEep43BvoFfY9PaSIeVMcEmVVfTr9zCHlLsyFydmFd4Cimo3kGSQPA7f10fP5YHMSgvDNQp2gFwIrjydE7glrUZXSI62gjPbKr0RCunMC2koReDDrxo2mqO3nTM+LazEL3N7PNX64qMYNldDQMxUkcZx753CkT774uQ7ue1LTWPMnmohW0+TBAiofQ823Ato4CJxyp8BUG+a9EYW3PVcwjI0z8t+Zc4R4gVRQcUtMlNsKWrgPowstD9P2aJKKddNYGr1G1mV32rYZaI4aoSDPb3BOciSrmwzq1X1zccZCajiECCEQiekZmVBp2UhsrNQf7PdeM6UN+SiK5uea158ajnnTAymSOiDHFX3rgipotlTUrzze7ItRVgmxg/oqjafx1czVZ/NSyZusS6EwpqExKh/7/6ayfmj/r5ba1hGGpExyvNx9R0fNwC7n32aHZYFmCKeVr3wZN5IN1QaClOBJKUDrZrZ3uSi6eX0RPrHPQc8+Qk4jbhTKirx6D5tjlTCwZ08rvbgLCMbEOv0lesPKeQGLKMpAg3DBcpysfR5cAFDR70FwgiR0adowf301zQOVyy5/LFnAkFFdv8oZTCNcXaIEZkxYzLljtMvRZxLvilwc6mNgY+KYiU+nahTIuLCqh6mcVaD7X3b5h7DWaN/ab8DiypX8o0GNBOy9PCN3SXTQrcBD1pQxLIFJJjn6uZFHvj261+yecWfl/sewZZ1q6aW3Y8+ps80SJo2o0WiR0q1BhOUYNqbIsdRCqVt2WbBWLbfi2+HfB05qFKpUr+KUvux9r4XLSrxsTkqropv+fEj43XaPJg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(1191002)(82310400005)(110136005)(36860700001)(2616005)(83380400001)(36756003)(2906002)(54906003)(356005)(921005)(70586007)(336012)(4326008)(70206006)(26005)(8676002)(478600001)(1076003)(186003)(40460700003)(6666004)(41300700001)(8936002)(47076005)(82740400003)(81166007)(316002)(426003)(7416002)(40480700001)(7366002)(7276002)(5660300002)(7406005)(86362001)(7336002)(83996005)(36900700001)(84006005)(2101003)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:43:01.7045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f558be0e-726f-4f70-2ccf-08db0b9f0541
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GQSPI supports two chip select CS0 & CS1. Update the driver to
assert/de-assert the appropriate chip select as per the bits set in
qspi->cs_index_mask.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/spi/spi-zynqmp-gqspi.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 319cdd5a0bdc..4759f704bf5c 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -156,6 +156,9 @@
 #define GQSPI_FREQ_100MHZ	100000000
 #define GQSPI_FREQ_150MHZ	150000000
 
+#define GQSPI_SELECT_LOWER_CS  BIT(0)
+#define GQSPI_SELECT_UPPER_CS  BIT(1)
+
 #define SPI_AUTOSUSPEND_TIMEOUT		3000
 enum mode_type {GQSPI_MODE_IO, GQSPI_MODE_DMA};
 
@@ -467,15 +470,17 @@ static void zynqmp_qspi_chipselect(struct spi_device *qspi, bool is_high)
 
 	genfifoentry |= GQSPI_GENFIFO_MODE_SPI;
 
+	if (qspi->cs_index_mask & GQSPI_SELECT_UPPER_CS) {
+		zynqmp_gqspi_selectslave(xqspi,
+					 GQSPI_SELECT_FLASH_CS_UPPER,
+					 GQSPI_SELECT_FLASH_BUS_LOWER);
+	} else if (qspi->cs_index_mask & GQSPI_SELECT_LOWER_CS) {
+		zynqmp_gqspi_selectslave(xqspi,
+					 GQSPI_SELECT_FLASH_CS_LOWER,
+					 GQSPI_SELECT_FLASH_BUS_LOWER);
+	}
+	genfifoentry |= xqspi->genfifobus;
 	if (!is_high) {
-		if (!spi_get_chipselect(qspi, 0)) {
-			xqspi->genfifobus = GQSPI_GENFIFO_BUS_LOWER;
-			xqspi->genfifocs = GQSPI_GENFIFO_CS_LOWER;
-		} else {
-			xqspi->genfifobus = GQSPI_GENFIFO_BUS_UPPER;
-			xqspi->genfifocs = GQSPI_GENFIFO_CS_UPPER;
-		}
-		genfifoentry |= xqspi->genfifobus;
 		genfifoentry |= xqspi->genfifocs;
 		genfifoentry |= GQSPI_GENFIFO_CS_SETUP;
 	} else {
-- 
2.25.1

