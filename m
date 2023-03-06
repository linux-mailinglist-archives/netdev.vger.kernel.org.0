Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C90C6ACA54
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCFR3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjCFR3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:29:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061A9305DA;
        Mon,  6 Mar 2023 09:29:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6YGpgHBDHvRycEB6+KUIAsGfroKCfjWvzpvaPavdr7jA55qpmht8GkPuMeFMVSXyRqpk5ZChnyQzAoH/gHp+0ZLkiTfeBZFqpQK1wq6Pw38v+w5gMALkg1M8DdoWbYFiAIYR+sFB6UoFyZeEiSwgDweIecMyipcJZGZu+6Wah171nuEoUcFFhK71LUf3TYGR/s5PsSI4jA9Azc8/rtvQhsioxR4DhXefDE7QY3CkPfPpV4UqUDbZPaKy7Ds2f1cBXzl3yDjCWbNaHshrZ5kw+KP61IaXaBDmDEYZc9xBfloohE2XdDFE1RejP15bbsbqp0rTxfIMx9sSAsy1ZgGnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGTDv9j62eqAAUbZYCqOwhh6o6pzCwATcSrO/Vzqvog=;
 b=EYbdS+z+4q5kbPWSvct1DGTpyEbAHudrOCPMI6RV8pasSVlKUTPXSCLPwLAyNrkXIqLcmBPTwplq7P6gnTCSnKhJfpRi4R/xx+A2HUthlN4MpaA/lwX06feIQvtZfr9NuKY+iy5aOSX8cejJ9/SgIQzjHw3lBsnXmbshuxoOilIGHTqJV3APxS+6TLuuB3pfzTtlIBb7zPm32cqbJ0RwAFxuxSnc+c1XJ1cbKmh+48Jv3PlGvMb3dbAmTJombKoYi4pCExaFnab9wWtDWiQwS9dZOCcaqYr1N90Aqdsg2TWHsJdShTuucmDMvZTHgxFyXBS/N0gKIdVdFB/cAQ5CVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGTDv9j62eqAAUbZYCqOwhh6o6pzCwATcSrO/Vzqvog=;
 b=gyb72RDfK3PZLmQj8NAkUr5dmIQ4w0H43FbOrw4j19dLKuQD3KAl6yb9cmQE1MmVvyS+yZ4TpY49BrobgzKAfmDxolBjwppp8cuRQDen2hC3D7LABqgaUr4elf5qV0nsblJWEzxzmTeeNFmjKZqdCSNdP0BL+VQXP0y25OKahc8=
Received: from DM6PR13CA0002.namprd13.prod.outlook.com (2603:10b6:5:bc::15) by
 SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:23:24 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::1a) by DM6PR13CA0002.outlook.office365.com
 (2603:10b6:5:bc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.15 via Frontend
 Transport; Mon, 6 Mar 2023 17:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 17:23:23 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:23:22 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 09:23:22 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 6 Mar 2023 11:22:55 -0600
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <Sanju.Mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
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
        <yangyingliang@huawei.com>, <william.zhang@broadcom.com>,
        <kursad.oney@broadcom.com>, <jonas.gorski@gmail.com>,
        <anand.gore@broadcom.com>, <rafal@milecki.pl>
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
        <amit.kumar-mahapatra@amd.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH V5 03/15] iio: imu: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Mon, 6 Mar 2023 22:50:57 +0530
Message-ID: <20230306172109.595464-4-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT101:EE_|SN7PR12MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: 954b412e-aeb1-4463-5242-08db1e677d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hAxI5cOLO6UatMmskGIBY8ep3ogPcooC+TYmckB7fs7obYaL93mX+40jRxComK0TS9MmaBzxrEgGiZEjb+aEX/Qyz5NrQ3zloPXEzn5uqX97nqxV/VAY5fV8jKjH2ync2vr1uZ4jR7v8bNX09/OAoF9n46w2RCkltEsHjS2201q1cpUKVMOhjV/dQ1fS3fYc7Ln55hk18+Rhla2AEry3V02HoCNXonv493P0teU95c+O8wvd7e9IOO3h2GLG113c2Ek7xHCcvktIIJUdx8GA0VqHHDvOXcgfBG+4R832k18Kj5tU5sIi8730ZY8lsWpMjqpKW0phb7gGQiMOufdl31Ycydwcdr3xX7eKyRJOZi5rm/NBsAx4cTC+RxEm9Npd/tnVDdQKXupiUvhI3TTnnWhEytMQBty5A7fm3L346cCoEhGr/qTp0N+Uj74d5Rg+fi4TSdxBpRfKSU8iWMz5/I+q17B+8zAAncCHlJHiWhG3PdXr61B+cDRjMrjsChJIuKRZ3LNF49yH+ZFWs448Rgx7jn38R+/VTSLeMfYdrHaVyvwOZ9n++ANBlYml0T/ezY8t7wX2Ecx+xSRcvhK60gZ8O7We+QuMAE01KTzlUEx7Ob+bEOmkO6tiajtB89LXHIOwEjogrCWiaGNDU6f8G6ftX0LQMqK6jP10aVgbBO/N+s4ZILrOyJ1KGjgXF2Ii+EaQAl85IUtMg9M/ip/h1QJYWB4ysdTQj3RB5pRF+qDxrU5vvw65M/VSGQwBT59hsI1D+8/UMTD5y5YvSCo55mki3HTRkRDtLE5M/Dk0aZkuWTETaqBYzGsQi8GVi6wTl6xPlMef0G2WKZCDjPGoI9AM5sxlJ1RKnIAYE06Re2g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(8936002)(7366002)(7276002)(7336002)(5660300002)(7416002)(7406005)(70586007)(70206006)(2906002)(8676002)(4326008)(54906003)(110136005)(316002)(478600001)(36756003)(426003)(47076005)(36860700001)(1076003)(26005)(2616005)(41300700001)(40480700001)(81166007)(1191002)(82740400003)(83380400001)(82310400005)(921005)(356005)(86362001)(40460700003)(186003)(336012)(84006005)(83996005)(36900700001)(41080700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:23:23.9159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 954b412e-aeb1-4463-5242-08db1e677d99
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supporting multi-cs in spi drivers would require the chip_select & cs_gpiod
members of struct spi_device to be an array. But changing the type of these
members to array would break the spi driver functionality. To make the
transition smoother introduced four new APIs to get/set the
spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
spi->cs_gpiod references with get or set API calls.
While adding multi-cs support in further patches the chip_select & cs_gpiod
members of the spi_device structure would be converted to arrays & the
"idx" parameter of the APIs would be used as array index i.e.,
spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
---
 drivers/iio/imu/adis16400.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index c02fc35dceb4..3eda32e12a53 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -466,7 +466,7 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 
 		dev_info(&indio_dev->dev, "%s: prod_id 0x%04x at CS%d (irq %d)\n",
 			indio_dev->name, prod_id,
-			st->adis.spi->chip_select, st->adis.spi->irq);
+			spi_get_chipselect(st->adis.spi, 0), st->adis.spi->irq);
 	}
 	/* use high spi speed if possible */
 	if (st->variant->flags & ADIS16400_HAS_SLOW_MODE) {
-- 
2.25.1

