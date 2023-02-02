Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A9A68823D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjBBP3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjBBP2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:28:53 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF536EDCE;
        Thu,  2 Feb 2023 07:28:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxBoND4wDpZ8CXFzjbuQDcPJ5ZxZL32B5/ZmejQJtmQBVMX0Fr3ZHxLfOsgOFgJTwJwDnBjW5ieSCvJFsVedhlnSQ/9z1FBCAJQsNywsC8dLGCYEA591AdYNmkNfCX0Sega43aJMApWmqipgJdDKDr1tM6jdYwc7daFv4wG7tDjNUzC2O2vtQ8oLj5LtxWfweDOPaBTuUIlk6DOK/zeHNIzSN5yiba/RU1nFk1FsBseBoe0hckObxM8T0Mtjsigb5Rvg/Y4FmycibPBYL7xPID2vKKTgIjl302tZ8AYNH0L3SUPTJQQC06EPcNBIvEV+v02ljZSAi3pn6q9DkFQoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAhIOHKu4HJGlav21Dv/GMi46fbF1Mnp5ITBekjHuvY=;
 b=PP47LNRJe7uO5KvQcfD1Gi+tBAvuzW/REcR+5BgwyKzaclFl90dIrZxccyXKtbrA+9pytR712E7EtE+kyPrL0ftrh99VLnHjsnB1BjBD5RkWLOqc/Sq6md7Ubc7RrejeCpd12C3FP6Y5pDVQvZFxSgjPfTX7RL+H0gJ0/9b3ejSDMSGVwjolNF9hahbC2R9O63CDy/JrEhICaTeiRfNfaaUCt39m3f+l4OX+aW+xGGOyGI0NZAHX9p6Ga4XME1YtwzUDzsG5noEsssQzxd/hvet5lkTJyBwnBYFlgycqBcjT6qmSfA7BN4v6uxLCSEa5pk3uucbTYJQJdOKK23ED4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAhIOHKu4HJGlav21Dv/GMi46fbF1Mnp5ITBekjHuvY=;
 b=5m0YnV2Me+bBJlLnFcJ6LKuaD/3EmfWg7fjn47/ben0H5a5KOONoTnh1HQKth1obWWGu3+EaOQ7sMaVQ3sx2UU45ZZbf5lKil2Za9+seEjUnh6sQnf0wLqCSaA5B8SINA/n8RAms3gzMewcwYaMRR/YkAiO+qsBcBv6G8nGRjTA=
Received: from BN9PR03CA0963.namprd03.prod.outlook.com (2603:10b6:408:109::8)
 by LV2PR12MB6014.namprd12.prod.outlook.com (2603:10b6:408:170::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 15:27:42 +0000
Received: from BL02EPF000108EB.namprd05.prod.outlook.com
 (2603:10b6:408:109:cafe::48) by BN9PR03CA0963.outlook.office365.com
 (2603:10b6:408:109::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 15:27:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EB.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 15:27:42 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:27:41 -0600
Received: from xhdsgoud40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 2 Feb 2023 09:27:18 -0600
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
        <kvalo@kernel.org>
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
        <amitrkcian2002@gmail.com>,
        "Amit Kumar Mahapatra" <amit.kumar-mahapatra@amd.com>
Subject: [PATCH v3 11/13] spi: spi-zynqmp-gqspi: Add stacked memories support in GQSPI driver
Date:   Thu, 2 Feb 2023 20:52:56 +0530
Message-ID: <20230202152258.512973-12-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
References: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EB:EE_|LV2PR12MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 5755075f-c6cb-419b-b21e-08db053206dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KoM10hG09f9b7tEjxd0eMibieSwgJNqgFCcrChc+l46WGH9wZrR4XoOzRVt4YUU2abOHjKTT3NrX+eAR/i2p0YGIADpe1nvcdW98xgumDYI7zd77jSRQCj5G5OaVDhd6CnnRPicA1yb6LTr55ay9hoku8YpHit30jUayjtt8NO/sa0S9i9lNkYwjUZqQY/IXSw3KXjt2hOhthZ1i+ZFmtToP/6O5rCoTWaTtrQmtPAT2KGOyN04h4MWXTjh8T5v0EYABN70GXPlZzFS/1uY1dibCOhxoCkxCujUjU7N0Aj3D0q4ghEICSBIt+LmlKABco2TTQZNJ/OV/7XyOKpylneN1D04125i5XF2q2uC8QRql2uHwqh5tJuDKTK5ZGp/qPD9dU3u1zQSNWo3VIBSfwr/NRGHDdIw9ZewxvSwdn7+JjTSmslicsr/GEdlOzY97Evonu4IyiMqz59KpsrDFksE+mJA/mLn5LOv2NfjLa2y+8XRqbejaDMuFPTWV9HCGpikr7r1SoPdnOOggeZZm9HMEqa8linP3e9yLSRvZtx1mV8bSCCP6mUEknDwhk2hAlCMBjXPND+2o7O8qSoA6UEcrH5mk5hTrWNcwX5LG4DxE9J06u5KOs80ehRDXkcprjR9RXmELDwSSzvMDJ/N/Ppu2lcyvrCo8+Jbc6EtDLAoUyuk12YSXbRIRihJsj70U5Rpd1s9GdGIHUb/TAYBJmrqT5gHh3lKd/eanmUUsfHad8GAgs9KjlEwawws8NI+4oRWP9sQjEoU7y0Myn6Y/iaLMKNtPFtslOCdmaYjE6cQNBacRF/YTvOMvw1N/tpZOC72KYuiI3XRt7tQqIQVrXg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(2906002)(316002)(36756003)(426003)(47076005)(82310400005)(54906003)(8676002)(6666004)(336012)(83380400001)(478600001)(186003)(40480700001)(41300700001)(40460700003)(70586007)(70206006)(26005)(921005)(1076003)(7416002)(8936002)(7336002)(7366002)(5660300002)(7406005)(356005)(4326008)(86362001)(7276002)(81166007)(36860700001)(82740400003)(2616005)(110136005)(83996005)(36900700001)(2101003)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:27:42.1784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5755075f-c6cb-419b-b21e-08db053206dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6014
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

