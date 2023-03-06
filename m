Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E308D6ACA30
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCFR2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCFR17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:27:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D380D67800;
        Mon,  6 Mar 2023 09:27:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkKs7MFJ6lLn3QS1d7HcYF3xT9c19SXAloM+N2jjtepkDOLObJ4nwIIfbYD2bWDOQkzQHA+igntMSj5ad73IeEBIwX4rSC9/BVEuEQoC776MsCMB56IsBvAFL7inFR5sd4UR/sUb1z+DPTNqCcFv73pheXqGpsCqIz1LdmYxLiZty6u5OPpeKn9t2+nev6sv8ncFkPe4HDbi7o5DsApZ/kSj+Z1m5m42btzcfsKKONKZCTfBVYQ/KGtSNTF2du+5qVNctUSEa7iQNc6dLbIufeRRGOUBs3iucF3q+1te/h+a/0USVpDsrkX+wZc7Nt4+lcO3+f8f/TUdggPIbav9VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNYJPkJ8aaPK5awYxnsnKWkYB0u9T5qlqGRNHD3pdtg=;
 b=OL17X8W0R+rStOrB683dD+fR2ZVe2cak/gEIj+ZyaRtbL5Gk265oaHWKlfADpLSJY+/W1g9GKCEyGamzXVg3LCaczV04wct7BANboOiOZrTodkRztSInLvv+hz/hzMv0Wynnct+pUMHizdJRF4TpETIArcC1Wr3/w3nozSjWHYOprS1gtKkZ8K+UaGwcYoBUWGFlWX4ryaX7EG8PFZ8woCnbiuYNobm+UQvCJrRP/LL3XByYyeCNRYTw7VjbFOkgRYXd4uPoVtL+3eDhXLs6vHrwDQjqCtSSetKcaAF8W5X+79I18q7+JaJ/tIRx50GBrX3BYiQYEGZwT/6nRg+LCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNYJPkJ8aaPK5awYxnsnKWkYB0u9T5qlqGRNHD3pdtg=;
 b=LBfJ4yQdcwQhpyR2SBTZLifq71GvqQlqkJWjDVggCDk4hsH5ECG1ZBzTNOLXOxYtegK/ayLXRwEpEOBdy1qKdhxplFLrEh0JdzA4wwMya05XF26/YDm9SYU78GEeZFTqVP0+dTVkZ4/EmvMWbT0WpzI9Odvtzva8tiifPZ+52JQ=
Received: from DM6PR18CA0019.namprd18.prod.outlook.com (2603:10b6:5:15b::32)
 by IA1PR12MB6236.namprd12.prod.outlook.com (2603:10b6:208:3e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 17:26:50 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:5:15b:cafe::12) by DM6PR18CA0019.outlook.office365.com
 (2603:10b6:5:15b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 17:26:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.4 via Frontend Transport; Mon, 6 Mar 2023 17:26:50 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:26:26 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 09:26:26 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 6 Mar 2023 11:25:12 -0600
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
        <amit.kumar-mahapatra@amd.com>
Subject: [PATCH V5 08/15] ALSA: hda: cs35l41: Replace all spi->chip_select references with function call
Date:   Mon, 6 Mar 2023 22:51:02 +0530
Message-ID: <20230306172109.595464-9-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|IA1PR12MB6236:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5d14a7-9df0-4573-c683-08db1e67f8b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mi+5nM/+f2DSJc+eHNVwefPOhh2OqhereBaPkZzNI/RQIduxpMT/FLX42UYDSwIhUfLsH/0fOVLEESCyzu4HUvSqNsbhCzO9peHK5BOOqFrQB4wPsIHcJc7I3uX49eNbht+QfZFohvAvy4Al/KR75H7etwAXJnKO9lQXShUaha5onxJw2Oqan3e/ol+KcW+uqK1Lpard1qa8cu9ssT4oSZa/dIyMxWxyEAY1HTtbqSJTaMiwaq7Mor3JTDWb1CVDHHJBjt+i+JqpcqCtnVRPxYngBOyuLFF34hNcqg7RQlGdTTVUgdDjBcBjn3KhhPq5s/uOFV6NiEzDZpSxFbjywZy24ZgBqPkFwRwsUhWHSEC9fTrTm4CnfhxjjGJNonjkD+YvfpHYYniJXTcCGoCWRcdkeOaaEcQKrxogk/nYmxzCGOSxR0jRC8GqScu4lrOdIfuviignc+9VsPDQPhg6BumoeBANuPYnZF2KwDWGCcjdfrB/dGsZHRiW+HNlR9YdPMdBXhgyFtqeK8kMvuifmSYwLt4vo2fA+Y/lRVR1dC7a9n1gGkOFXAmCvavfXsmQIxWE9W3pYFba16e78owWFeq8zehpK2UIgd0KKZk224G3Hl31hut/2TSIblqfuLTlLEKL1cUfLyLtu16cIT4y3FoyR+1W8vakLvqOsSoAy7NfQk9gSAwZJEmXvg6schpFvh55ttEe7G4EC7/XK2SsvmNeQlLNcyAluyXtOT9kli9IQdMNivqF8efBjY8bWGVdOyYZb74QGUxDus4VF3dbYeK1BiU3wSHeMoSJIYZ+uwuAHUYigrkLSTwO6MYKF3AGUwoIU3e8aYhMlXFg6UrtD+x9mbVD37CnA1PB/ryaDuo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199018)(40470700004)(46966006)(36840700001)(7336002)(7276002)(7406005)(7416002)(5660300002)(8936002)(7366002)(41300700001)(70206006)(2906002)(70586007)(4326008)(8676002)(110136005)(54906003)(316002)(478600001)(36860700001)(36756003)(47076005)(426003)(6666004)(1076003)(336012)(2616005)(26005)(1191002)(86362001)(356005)(82740400003)(83380400001)(40460700003)(82310400005)(921005)(40480700001)(81166007)(186003)(83996005)(84006005)(41080700001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:26:50.2056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5d14a7-9df0-4573-c683-08db1e67f8b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6236
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
---
 sound/pci/hda/cs35l41_hda_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/cs35l41_hda_spi.c b/sound/pci/hda/cs35l41_hda_spi.c
index 71979cfb4d7e..eb287aa5f782 100644
--- a/sound/pci/hda/cs35l41_hda_spi.c
+++ b/sound/pci/hda/cs35l41_hda_spi.c
@@ -25,7 +25,7 @@ static int cs35l41_hda_spi_probe(struct spi_device *spi)
 	else
 		return -ENODEV;
 
-	return cs35l41_hda_probe(&spi->dev, device_name, spi->chip_select, spi->irq,
+	return cs35l41_hda_probe(&spi->dev, device_name, spi_get_chipselect(spi, 0), spi->irq,
 				 devm_regmap_init_spi(spi, &cs35l41_regmap_spi));
 }
 
-- 
2.25.1

