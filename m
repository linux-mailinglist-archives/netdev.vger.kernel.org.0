Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D466B4EDF
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 18:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjCJRhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 12:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjCJRhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 12:37:51 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20602.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DB8128027;
        Fri, 10 Mar 2023 09:37:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDRNQfAeBMsXvxLpEyufBkTljpAjB62YDYa9RYwlK0YKPvuapqQ17AIDfTzJ2kcSUA+FZZdrQKUEtWqloHO67hQlyNlUdiO2YShmb9aKyNJhlrkCkLQj85fDPUIia8wrjlC7PLLF2GuHnel8QwIn9qUpLJaOzP6TtbiMjZBDVLXVF+IRuBGjZMG7YZRzv+/BwwUM4ymeDFtXsc1hrwyg/vcRh2VI54D8+THIPovfrhhV6dEQeJ7l8+VWCeQe60/m4vZHgbVY8la3TJS1bOhDOMPFCA7ayRkZEGUsXO/SYjR04DRE+VAe5ffmDiu6HBaPXCW9VlLT8seFGhijin4y9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNYJPkJ8aaPK5awYxnsnKWkYB0u9T5qlqGRNHD3pdtg=;
 b=e947nPG59j9p0X4xa/4COFk6qswBkYRsXUuNWBp6av8fkTAU/p3j3OCOAJmDlbDnLFttMj8WkUtrxRZaG0V9QC/llHn3OSoW/GHzHk1nOatbE0h/Mqe0i3PVyi0fXpH6nq/MGLmvn/uXwaxKVPrC357YjAuF1/0hasMGidgsIvkVTq2sEnEWF5TUS4Jf+PjlYgwfCcgi46wDjj/Am8k9tUMFdmSMIRgHFujBpD+KK5ZMWLtD1DwrAM4D7xQcEWoyZWlRyjBraOSO/awXdDiN4CirQwhldwAK2Xu8riYBeRac+Na/gp+4swUmwaS3nKrNyuUGKWMwlV6JFeH3DCB5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNYJPkJ8aaPK5awYxnsnKWkYB0u9T5qlqGRNHD3pdtg=;
 b=UMmMZbcBWItbrIBaBOta5O/k2bX3+xyUZrN07VP0ZW4Ks53SYj2K5Q+O5daGC5AZmW/Qq3MzqoMBa0VPOBwF9U5CN+UCZpSFb/IR3tiAmwHq3rhG+es5e4OpqDVJXU5mXlwXN0P97UWuP5b45mTm/3zAVD3VgdyzbKBNEF8Ek7s=
Received: from BN8PR04CA0023.namprd04.prod.outlook.com (2603:10b6:408:70::36)
 by BN9PR12MB5290.namprd12.prod.outlook.com (2603:10b6:408:103::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 17:36:52 +0000
Received: from BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::c6) by BN8PR04CA0023.outlook.office365.com
 (2603:10b6:408:70::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 17:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT082.mail.protection.outlook.com (10.13.176.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.20 via Frontend Transport; Fri, 10 Mar 2023 17:36:52 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:36:51 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 09:36:51 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Mar 2023 11:36:24 -0600
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
Subject: [PATCH V6 08/15] ALSA: hda: cs35l41: Replace all spi->chip_select references with function call
Date:   Fri, 10 Mar 2023 23:02:10 +0530
Message-ID: <20230310173217.3429788-9-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
References: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT082:EE_|BN9PR12MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: a9861984-9939-4d87-1435-08db218e0955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdnGfZoG9qzd2wnQn8OFchhoKOS+sgoSCITP3ZeO4aNDSx44PjwjLeJYnAPLo3ZEVtW3N6LCJ+veH6LPWomsyGBuYgEdbAMAuMq6fuCIM49t8Bm247zTDNIYJNNfoCLHQkpxa3amxxZC5k9FTgU8tKSni9DMdQuXpt7kv6dTkMbtl/sd5XvhX3v2w/clW3/wQcveHEEPGF13YrDFq792cwDj6OavXgd2CFdEiSHRky4YizeS9ylEe+m2amd60i7+h6vPBGpXGCH2aRoHfraNbnXWtBfjGbTzUqksUsoaoFWCZB7ynIYwbguT9Ju4LjIXlN4fRBQFPyNin7w/bAe25+LQGhq7CYr87+GUYKWEyDfTw79+zuyIBAhErzAtGjQjOlhzKLBG58ECb04uhdlz1IQnImSc2nDFy1DEm/Z9tL71oHSE8ehZlsjuKQ27KcVPbBIZ2YEZKXY2lr6L+vnQpAPWY6E/thYSwn1+n5W1Leb8AdNwm1Bu38o9nJcr5qBHIyVqA6cWo8iGmsrO4g8a+KBrNJaYmXtOJFMzymB75oTQIoEAxIN9zi0gcCG1/maSfoK0JV8MahRIq1agAGa+bp5zBm13IshtUmxPuqFnEAr1Lagm4qX9rDT8OWu7v2U1aE4TpSuHTPKYmkIlZ3iJv/LhLng9vjtEgQLsergEeDmAEs2qEBNWQ3hB8ctRTrvkdBHUymDj24KGCjphaDHVL9U8SgNpiMNtn87dNLVYO10iCD5oFKgvQ85/NHeN6NZWuHTG5Ixa3phUqCqFiNvZ+SJkPJRtdH+JwNaAIp10eWVuDhSsom4xe95LTh2hp7bFl1y8AfpoBGkGQTs0vx63oR3MPMgTjC26gcIMwCanaAA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(36756003)(82740400003)(36860700001)(186003)(40460700003)(26005)(426003)(2616005)(6666004)(41300700001)(83380400001)(110136005)(47076005)(8676002)(70586007)(8936002)(2906002)(70206006)(4326008)(1076003)(40480700001)(7336002)(7416002)(7276002)(5660300002)(7366002)(7406005)(316002)(54906003)(356005)(86362001)(336012)(478600001)(81166007)(82310400005)(921005)(1191002)(2101003)(41080700001)(83996005)(84006005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:36:52.7138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9861984-9939-4d87-1435-08db218e0955
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5290
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

