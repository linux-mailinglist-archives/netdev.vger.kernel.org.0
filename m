Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5052600EAB
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiJQMON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiJQMOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:14:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D5B5F12F;
        Mon, 17 Oct 2022 05:13:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEZc/8jJzNzifmvSZqdhCe0Idgl4aWtWPnpg7/LHlZpbEECKM+z51eM4XhtlefROsS18QyPWrLKX/+diyBruBC42Nm2nRpA7pBvZ8pxwvoKTE7H5cOqZtySL3200aJrVM0a3JMMsqhBzS+hHUWzigwEv5cJ5fc80CvG9iqGtojnG6upSL2Lvb5Ejd70nWMnL1t1SBfpkTULNVFVwsCvU9iDLN4sjC5qr+feLfd4EUx4VKq1whnX/OU+vm4hXPIrxY7eIFROjOriTDxjmP0nTborPxr2tfDE1mcePm4Pb3wFW7vMruatycpL6xPZ/5BGONAaloMeFV9S0E4nLDt5myw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwId1J15c1hZBHXG6yKzjqkYWAraBlf3PpvoSqI68t0=;
 b=Pb97qqNgfRhN8flA0BJcEoVuRWJgzFvF9gOIVwKw7++dKGxv17DIq0OpBY03+3oSAbvvLVKBsGUbu2DU1EM1rdL/8tp5j0aYwVeWRmrzlj/ctmoGPz1tJQZO9x4SlUeGWT6pMeRVEvc9F64ikbzt0azE83QQSjMtXuwz/myduzN+jCM28kP/REQnB46+K1TGbTPjg44akfZL7mgBuE35vxkXtIE8zRzZ/SKOIWf5qH41B37dXWKTVGHPFAGU/+uZ/4wEVqYGzwCGauhTi/f+g0f/uYclkyGknpE2KaeN5gS4Nizf1hVl9sGXPXiVGnvCyqjZopk6KxzPDl4H1mey+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwId1J15c1hZBHXG6yKzjqkYWAraBlf3PpvoSqI68t0=;
 b=osBm0NTQsopOKEAa+5DH6QWzAI0pMxaTLNWkmRPXYxmJl/sr8NB4YiylMxyfr0v4yZ3qVQt1cI1mycHwYOdxJdDBZLsdp23YDzfjGTN1D8cv+9HKdOYlJlM2KZU4I8U8u3VVHLn1xCZw9eY39BrE6JrNDaOCOnVWf4jUTwviBVA=
Received: from CY5P221CA0117.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:1f::11)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 12:13:53 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:930:1f:cafe::c5) by CY5P221CA0117.outlook.office365.com
 (2603:10b6:930:1f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31 via Frontend
 Transport; Mon, 17 Oct 2022 12:13:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Mon, 17 Oct 2022 12:13:52 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 07:13:48 -0500
Received: from xhdlakshmis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 17 Oct 2022 07:13:25 -0500
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <sanju.mehta@amd.com>,
        <chin-ting_kuo@aspeedtech.com>, <clg@kaod.org>,
        <kdasu.kdev@gmail.com>, <f.fainelli@gmail.com>,
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
        <kvalo@kernel.org>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>
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
        <akumarma@amd.com>, <amitrkcian2002@gmail.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Subject: [PATCH 01/10] spi: Add stacked memories support in SPI core
Date:   Mon, 17 Oct 2022 17:42:40 +0530
Message-ID: <20221017121249.19061-2-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
References: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|DS7PR12MB6008:EE_
X-MS-Office365-Filtering-Correlation-Id: 345be05d-2aac-465e-40f9-08dab0390ea9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xdSgCTQLbXmd8dFdQly8JOWii92tpvGOrJPxICvXEsnek460hrTFNDysSq/pn3O191qlDbQ5mm1QJ8ogN5IhdUeyYW3WGNX+WCDhVurLaNFuSXm5j8CNIhJCxVHPhQItLVkm6O47zR9SLHQ5icBLQAMkf9D3V/ZbjQxdDrQjUQcenGoTmymokqR67hsbsULLGAsLOInMEH7XRwEhLkKKud/f+Hs+Ox8qzpt3nrpiC1nqLtYmERcgx3tfU/VKIXPNslZ9WrfJ/xQhyLTFBGX2NL/18jlU70lRtVCyfe/morUEjaHxeEpB3O2B3NuJZTMjqHo1VvYUxr7N1dTBqFmDow2lrmfrlTBVi+7ovRej7eaM+bH/poPLwWQHxizS18kRfeSHDry/PT7r+rfYDRHqr8UxusykTBtrpwYSKSBkqKLhQ1qy8qvtUtFJKLYXky5aLgmZabVa/JlKSmLqd0+tRCBcdbwEZStw2XVKOQENaxTsjem1RJ3o9uCV6a9kPatkDuaa4RWs9bRWhrj6H9etqUsI6qulAxY3mmEOwqBU9aw/8zu/D1EaUdreOOplwkiOy6sMww9l6AWhOXmzxdWYWIv12byoLLAOlLNVRfGEfV9VFra63Ul9yeqiDjYLcDX16lf5H1hT2YAHCpq0dB55/QpAhvO2Hos5UZhD9XhfKasn0LcvoAErBf4lZ32VOawU0gebbhwCfRAHSNroPobuAQeFa/2A7TVT7Eeczqs9gqI8mFn90I5Z5GCN/B+YH2pqR3Qi2zVdz+t6vLx5JewxKBKDdI1jrleHjMkueCNDgn6DHhiBcB+bIXSvmf4cvsbKSmOpVMeMyDWsklnfEwc5LGIeQXriUByq2MgH0It6vvQgxPCS9xUhOQ2K3JPV19LMaA8AgL3JbG+1yVtI+7OukA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199015)(46966006)(36840700001)(40470700004)(86362001)(36756003)(36860700001)(921005)(40460700003)(82740400003)(356005)(81166007)(40480700001)(316002)(4326008)(70586007)(70206006)(8676002)(110136005)(54906003)(2906002)(41300700001)(426003)(7406005)(30864003)(7366002)(7336002)(8936002)(7416002)(5660300002)(47076005)(2616005)(336012)(1076003)(186003)(83380400001)(82310400005)(478600001)(6666004)(26005)(83996005)(41080700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 12:13:52.8662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 345be05d-2aac-465e-40f9-08dab0390ea9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For supporting multiple CS the SPI device need to be aware of all the CS
values. So, the "chip_select" member in the spi_device structure is now an
array that holds all the CS values.

spi_device structure now has a "cs_index_mask" member. This acts as an
index to the chip_select array. If nth bit of spi->cs_index_mask is set
then the driver would assert spi->chip_select[n].

For supporting multiple CS via GPIO the cs_gpiod member of the spi_device
structure is now an array that holds the gpio descriptor for each
chipselect.

Multi CS support using GPIO is not tested due to unavailability of
necessary hardware setup.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/spi/spi.c       | 86 ++++++++++++++++++++++++-----------------
 include/linux/spi/spi.h | 16 +++++++-
 2 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8f97a3eacdea..1b1a891f4ccc 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -592,7 +592,7 @@ static void spi_dev_set_name(struct spi_device *spi)
 	}
 
 	dev_set_name(&spi->dev, "%s.%u", dev_name(&spi->controller->dev),
-		     spi->chip_select);
+		     spi->chip_select[0]);
 }
 
 static int spi_dev_check(struct device *dev, void *data)
@@ -601,7 +601,8 @@ static int spi_dev_check(struct device *dev, void *data)
 	struct spi_device *new_spi = data;
 
 	if (spi->controller == new_spi->controller &&
-	    spi->chip_select == new_spi->chip_select)
+	    spi->chip_select[0] == new_spi->chip_select[0] &&
+	    spi->chip_select[1] == new_spi->chip_select[1])
 		return -EBUSY;
 	return 0;
 }
@@ -616,7 +617,7 @@ static int __spi_add_device(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
-	int status;
+	int status, idx;
 
 	/*
 	 * We need to make sure there's no other device with this
@@ -626,7 +627,7 @@ static int __spi_add_device(struct spi_device *spi)
 	status = bus_for_each_dev(&spi_bus_type, NULL, spi, spi_dev_check);
 	if (status) {
 		dev_err(dev, "chipselect %d already in use\n",
-				spi->chip_select);
+				spi->chip_select[0]);
 		return status;
 	}
 
@@ -636,8 +637,10 @@ static int __spi_add_device(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	if (ctlr->cs_gpiods)
-		spi->cs_gpiod = ctlr->cs_gpiods[spi->chip_select];
+	if (ctlr->cs_gpiods) {
+		for (idx = 0; idx < SPI_CS_CNT_MAX; idx++)
+			spi->cs_gpiod[idx] = ctlr->cs_gpiods[spi->chip_select[idx]];
+	}
 
 	/*
 	 * Drivers may modify this initial i/o setup, but will
@@ -677,13 +680,15 @@ int spi_add_device(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
-	int status;
+	int status, idx;
 
-	/* Chipselects are numbered 0..max; validate. */
-	if (spi->chip_select >= ctlr->num_chipselect) {
-		dev_err(dev, "cs%d >= max %d\n", spi->chip_select,
-			ctlr->num_chipselect);
-		return -EINVAL;
+	for (idx = 0; idx < SPI_CS_CNT_MAX; idx++) {
+		/* Chipselects are numbered 0..max; validate. */
+		if (spi->chip_select[idx] >= ctlr->num_chipselect) {
+			dev_err(dev, "cs%d >= max %d\n", spi->chip_select[idx],
+				ctlr->num_chipselect);
+			return -EINVAL;
+		}
 	}
 
 	/* Set the bus ID string */
@@ -700,12 +705,15 @@ static int spi_add_device_locked(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
+	int idx;
 
-	/* Chipselects are numbered 0..max; validate. */
-	if (spi->chip_select >= ctlr->num_chipselect) {
-		dev_err(dev, "cs%d >= max %d\n", spi->chip_select,
-			ctlr->num_chipselect);
-		return -EINVAL;
+	for (idx = 0; idx < SPI_CS_CNT_MAX; idx++) {
+		/* Chipselects are numbered 0..max; validate. */
+		if (spi->chip_select[idx] >= ctlr->num_chipselect) {
+			dev_err(dev, "cs%d >= max %d\n", spi->chip_select[idx],
+				ctlr->num_chipselect);
+			return -EINVAL;
+		}
 	}
 
 	/* Set the bus ID string */
@@ -749,7 +757,7 @@ struct spi_device *spi_new_device(struct spi_controller *ctlr,
 
 	WARN_ON(strlen(chip->modalias) >= sizeof(proxy->modalias));
 
-	proxy->chip_select = chip->chip_select;
+	proxy->chip_select[0] = chip->chip_select;
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
@@ -953,29 +961,32 @@ static void spi_res_release(struct spi_controller *ctlr, struct spi_message *mes
 static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 {
 	bool activate = enable;
+	u32 cs_num = __ffs(spi->cs_index_mask);
+	int idx;
 
 	/*
 	 * Avoid calling into the driver (or doing delays) if the chip select
 	 * isn't actually changing from the last time this was called.
 	 */
-	if (!force && ((enable && spi->controller->last_cs == spi->chip_select) ||
-				(!enable && spi->controller->last_cs != spi->chip_select)) &&
+	if (!force && ((enable &&
+			spi->controller->last_cs == spi->chip_select[cs_num]) ||
+		       (!enable &&
+			spi->controller->last_cs != spi->chip_select[cs_num])) &&
 	    (spi->controller->last_cs_mode_high == (spi->mode & SPI_CS_HIGH)))
 		return;
 
 	trace_spi_set_cs(spi, activate);
 
-	spi->controller->last_cs = enable ? spi->chip_select : -1;
+	spi->controller->last_cs = enable ? spi->chip_select[cs_num] : -1;
 	spi->controller->last_cs_mode_high = spi->mode & SPI_CS_HIGH;
 
-	if ((spi->cs_gpiod || !spi->controller->set_cs_timing) && !activate) {
+	if ((spi->cs_gpiod[cs_num] || !spi->controller->set_cs_timing) && !activate)
 		spi_delay_exec(&spi->cs_hold, NULL);
-	}
 
 	if (spi->mode & SPI_CS_HIGH)
 		enable = !enable;
 
-	if (spi->cs_gpiod) {
+	if (spi->cs_gpiod[cs_num]) {
 		if (!(spi->mode & SPI_NO_CS)) {
 			/*
 			 * Historically ACPI has no means of the GPIO polarity and
@@ -988,10 +999,10 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 			 * into account.
 			 */
 			if (has_acpi_companion(&spi->dev))
-				gpiod_set_value_cansleep(spi->cs_gpiod, !enable);
+				gpiod_set_value_cansleep(spi->cs_gpiod[cs_num], !enable);
 			else
 				/* Polarity handled by GPIO library */
-				gpiod_set_value_cansleep(spi->cs_gpiod, activate);
+				gpiod_set_value_cansleep(spi->cs_gpiod[cs_num], activate);
 		}
 		/* Some SPI masters need both GPIO CS & slave_select */
 		if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&
@@ -1001,7 +1012,7 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 		spi->controller->set_cs(spi, !enable);
 	}
 
-	if (spi->cs_gpiod || !spi->controller->set_cs_timing) {
+	if (spi->cs_gpiod[cs_num] || !spi->controller->set_cs_timing) {
 		if (activate)
 			spi_delay_exec(&spi->cs_setup, NULL);
 		else
@@ -2139,8 +2150,8 @@ void spi_flush_queue(struct spi_controller *ctlr)
 static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 			   struct device_node *nc)
 {
-	u32 value;
-	int rc;
+	u32 value, cs[SPI_CS_CNT_MAX] = {0};
+	int rc, idx;
 
 	/* Mode (clock phase/polarity/etc.) */
 	if (of_property_read_bool(nc, "spi-cpha"))
@@ -2213,13 +2224,17 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 	}
 
 	/* Device address */
-	rc = of_property_read_u32(nc, "reg", &value);
-	if (rc) {
+	rc = of_property_read_variable_u32_array(nc, "reg", &cs[0], 1,
+						 SPI_CS_CNT_MAX);
+	if (rc < 0 || rc > ctlr->num_chipselect) {
 		dev_err(&ctlr->dev, "%pOF has no valid 'reg' property (%d)\n",
 			nc, rc);
 		return rc;
 	}
-	spi->chip_select = value;
+	for (idx = 0; idx < rc; idx++)
+		spi->chip_select[idx] = cs[idx];
+	/* By default set the spi->cs_index_mask as 1 */
+	spi->cs_index_mask = 0x01;
 
 	/* Device speed */
 	if (!of_property_read_u32(nc, "spi-max-frequency", &value))
@@ -2333,7 +2348,7 @@ struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
 	strlcpy(ancillary->modalias, "dummy", sizeof(ancillary->modalias));
 
 	/* Use provided chip-select for ancillary device */
-	ancillary->chip_select = chip_select;
+	ancillary->chip_select[0] = chip_select;
 
 	/* Take over SPI mode/speed from SPI main device */
 	ancillary->max_speed_hz = spi->max_speed_hz;
@@ -2580,7 +2595,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	spi->mode		|= lookup.mode;
 	spi->irq		= lookup.irq;
 	spi->bits_per_word	= lookup.bits_per_word;
-	spi->chip_select	= lookup.chip_select;
+	spi->chip_select[0]	= lookup.chip_select;
 
 	return spi;
 }
@@ -3687,6 +3702,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 	struct spi_controller *ctlr = spi->controller;
 	struct spi_transfer *xfer;
 	int w_size;
+	u32 cs_num = __ffs(spi->cs_index_mask);
 
 	if (list_empty(&message->transfers))
 		return -EINVAL;
@@ -3699,7 +3715,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 	 * cs_change is set for each transfer.
 	 */
 	if ((spi->mode & SPI_CS_WORD) && (!(ctlr->mode_bits & SPI_CS_WORD) ||
-					  spi->cs_gpiod)) {
+					  spi->cs_gpiod[cs_num])) {
 		size_t maxsize;
 		int ret;
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index e6c73d5ff1a8..a7c2efedcc4c 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -19,6 +19,9 @@
 #include <linux/acpi.h>
 #include <linux/u64_stats_sync.h>
 
+/* Max no. of CS supported per spi device */
+#define SPI_CS_CNT_MAX 2
+
 struct dma_chan;
 struct software_node;
 struct ptp_system_timestamp;
@@ -163,6 +166,7 @@ extern int spi_delay_exec(struct spi_delay *_delay, struct spi_transfer *xfer);
  *	deasserted. If @cs_change_delay is used from @spi_transfer, then the
  *	two delays will be added up.
  * @pcpu_statistics: statistics for the spi_device
+ * @cs_index_mask: Bit mask of the active chipselect(s) in the chipselect array
  *
  * A @spi_device is used to interchange data between an SPI slave
  * (usually a discrete chip) and CPU memory.
@@ -178,7 +182,7 @@ struct spi_device {
 	struct spi_controller	*controller;
 	struct spi_controller	*master;	/* Compatibility layer */
 	u32			max_speed_hz;
-	u8			chip_select;
+	u8			chip_select[SPI_CS_CNT_MAX];
 	u8			bits_per_word;
 	bool			rt;
 #define SPI_NO_TX	BIT(31)		/* No transmit wire */
@@ -199,7 +203,7 @@ struct spi_device {
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
 	const char		*driver_override;
-	struct gpio_desc	*cs_gpiod;	/* Chip select gpio desc */
+	struct gpio_desc	*cs_gpiod[SPI_CS_CNT_MAX];	/* Chip select gpio desc */
 	struct spi_delay	word_delay; /* Inter-word delay */
 	/* CS delays */
 	struct spi_delay	cs_setup;
@@ -209,6 +213,14 @@ struct spi_device {
 	/* The statistics */
 	struct spi_statistics __percpu	*pcpu_statistics;
 
+	/*
+	 * Bit mask of the chipselect(s) that the driver need to use from
+	 * the chipselect array.When the controller is capable to handle
+	 * multiple chip selects & memories are connected in parallel
+	 * then more than one bit need to be set in cs_index_mask.
+	 */
+	u32			cs_index_mask : 2;
+
 	/*
 	 * likely need more hooks for more protocol options affecting how
 	 * the controller talks to each chip, like:
-- 
2.17.1

