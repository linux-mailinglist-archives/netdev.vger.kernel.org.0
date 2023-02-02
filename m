Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779626881D2
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbjBBPYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbjBBPY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:24:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25696719B4;
        Thu,  2 Feb 2023 07:24:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CanUCElvbd2G9Qp51uOvH1POHRSqlXoaKh2mRrCzYM6K7hnvnqbyNaQDnmZU1xfmanw04zwb6Rgexhb9TM7i9UlBZhUE7sX6fkS0bgUYyfiNo2D5I7nf9WEpOLinMcw1QHhH5sfTmgo3Xc0mKW4X1HQoYytD5kS0CwvEnI3Sh5aSurj3EkUE21V0ivejXhyz0+1VSWYyL4G1m2V7LkZVKyCMhzMqUTJ55Z7Nrmlb1UD/ePd/k1CD252FVNw3v5XryzHu4rFJkyNppGiFek3UUxKKDD+C9KieNxN+OcPsO7V7jIHKP0rEvl/Xi5gCTpU65B9OrsVAnZPiixZ60AGgww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdrkNOVN6eoC1Yo3IPRQEfXByN0pZoIOt54GZowv0CA=;
 b=L7G+rkOXXmeRYjnTiTgC/donhixInK0bXSZbOYbrBFgEJEXE14TWGXZUH77e5kbRdy09ry94W9k3nUnM6X+oMb9quMBGjH4glZg8mRfkE1UGf1zMgZ5oeJvsFNvKWOurIM5LHUSvLlxDsdtW/8ZiJu2mvBqsGFaImkBKlITIp1IDjdLfgYhT0pUgnkrzfx65JlTCE3jmVFNhGvnvAaP3Unz+0S6KUh+xG6Um6Bpc9I0SkYNhAt0T57rRlZ2QbYrC48YMUfK31ohuKK1buGtC+wmVO8T8aHPDgA5u26evvMnymEZODCHQTlhqfg1ELDq7rLfsQB1rzaDzOYUCkx00Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdrkNOVN6eoC1Yo3IPRQEfXByN0pZoIOt54GZowv0CA=;
 b=VgWiZsDwDbYvE+B7TG00YySNK+vB94TXmdkT079YB/z3VnvWnWJOf38mR1zFcunvfL5Fe3s53IcEiIeEy4EYN8Mou+AOvObNsFJ2aEFCggC6W1ejyFzCsEL5n9m2TEB0VW/RqbU68sNfZ4gpwRL/bLKw2mSmLXt4mTDFJt73Zxo=
Received: from MW4PR03CA0341.namprd03.prod.outlook.com (2603:10b6:303:dc::16)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 15:24:13 +0000
Received: from CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::f5) by MW4PR03CA0341.outlook.office365.com
 (2603:10b6:303:dc::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 15:24:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT079.mail.protection.outlook.com (10.13.175.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.25 via Frontend Transport; Thu, 2 Feb 2023 15:24:12 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:24:11 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:24:11 -0600
Received: from xhdsgoud40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 2 Feb 2023 09:23:48 -0600
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
Subject: [PATCH v3 02/13] net: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Thu, 2 Feb 2023 20:52:47 +0530
Message-ID: <20230202152258.512973-3-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
References: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT079:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c35297b-4dcc-4621-438b-08db053189ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YH0091k//Mj3jtiUuMaH7N9tDWQf503Oa8UuMeFcmHVcfydLxlzCgUWkzmL+7ufVNbvLLYyE1G0EEQkSE/HDYaCRE4JTMhRwJGW5USylOBvfV00Y8bCCrba1n1+yy1cCd1/46feVbn7ukqpW+U/IpMia8meVFOwwfm1zx55g3CMkmrPAeD27giN+8ih6fMj22co359oABDearErdroI9IpxgSi5lKumAP+G6KsqtHSTpvLntGvmD9g9W4/Wr2olm+rWgTctVU8snFAMpGg6HQhZFj+hXt6KtljJL/fzwMRt5M4rFMLCot6kjczuEf0MsNHQDozXez8psAxNAzbR9A8cqS0+5ZKD84f/wfn52cO3tXlGv1IkuMhtq5G6/eQ2HXIS6p+fsT1JGxgq+54y2xMngD27K1n9Ng5/XEzsZRvFBDuq7deWa9SID/O6Mr4yZh69XeofwEAx5IBAM2MINDjgdZjhxwZhp5qvwfwwDR9jjTxQeuZ1YuuwpuN27pFcU1t9R6FWF7DFnePfghdj8cets6kCr9O5ZPipBMgrVz9ygUs4PsqHlKPu5qWnh5yaCLJG2zWBfw4mIEqOsb86gA798do+qxAscLgW2LhEpV+FyY7ft3uN4cmNXEuwycRLqTptZmGuf6llkQfaIfSX9/lNhLAF3E0trsfEUVHFyreASjvQFAz3ioLj/J+1seaFlWCSkU/tUmdPLGSNM3wiRJveMBa9VLCvFlD1d+CBdu+Lmm2y89+XkcNVA7Ld23X1NkwNQP7ABFaavMfgQ330C3vV32joHQF9Y0yX505rUZwpKf36EXh4Q87YGk22vmsWnD56DshG6PgZanHam4IfiMg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(2906002)(478600001)(36756003)(7276002)(7336002)(7366002)(7406005)(7416002)(1076003)(26005)(186003)(2616005)(70206006)(40460700003)(8936002)(336012)(86362001)(40480700001)(356005)(426003)(5660300002)(47076005)(921005)(41300700001)(8676002)(83380400001)(82310400005)(4326008)(81166007)(70586007)(316002)(82740400003)(36860700001)(110136005)(54906003)(36900700001)(41080700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:24:12.6902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c35297b-4dcc-4621-438b-08db053189ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
Reviewed-by: Michal Simek <michal.simek@amd.com>
---
 drivers/net/ethernet/adi/adin1110.c            | 2 +-
 drivers/net/ethernet/asix/ax88796c_main.c      | 2 +-
 drivers/net/ethernet/davicom/dm9051.c          | 2 +-
 drivers/net/ethernet/qualcomm/qca_debug.c      | 2 +-
 drivers/net/ieee802154/ca8210.c                | 2 +-
 drivers/net/wan/slic_ds26522.c                 | 2 +-
 drivers/net/wireless/marvell/libertas/if_spi.c | 2 +-
 drivers/net/wireless/silabs/wfx/bus_spi.c      | 2 +-
 drivers/net/wireless/st/cw1200/cw1200_spi.c    | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 0805f249fff2..aee7a98725ba 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -515,7 +515,7 @@ static int adin1110_register_mdiobus(struct adin1110_priv *priv,
 		return -ENOMEM;
 
 	snprintf(priv->mii_bus_name, MII_BUS_ID_SIZE, "%s-%u",
-		 priv->cfg->name, priv->spidev->chip_select);
+		 priv->cfg->name, spi_get_chipselect(priv->spidev, 0));
 
 	mii_bus->name = priv->mii_bus_name;
 	mii_bus->read = adin1110_mdio_read;
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 21376c79f671..e551ffaed20d 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -1006,7 +1006,7 @@ static int ax88796c_probe(struct spi_device *spi)
 	ax_local->mdiobus->parent = &spi->dev;
 
 	snprintf(ax_local->mdiobus->id, MII_BUS_ID_SIZE,
-		 "ax88796c-%s.%u", dev_name(&spi->dev), spi->chip_select);
+		 "ax88796c-%s.%u", dev_name(&spi->dev), spi_get_chipselect(spi, 0));
 
 	ret = devm_mdiobus_register(&spi->dev, ax_local->mdiobus);
 	if (ret < 0) {
diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index de7105a84747..70728b2e5f18 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -1123,7 +1123,7 @@ static int dm9051_mdio_register(struct board_info *db)
 	db->mdiobus->phy_mask = (u32)~BIT(1);
 	db->mdiobus->parent = &spi->dev;
 	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
-		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
+		 "dm9051-%s.%u", dev_name(&spi->dev), spi_get_chipselect(spi, 0));
 
 	ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
 	if (ret)
diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index f62c39544e08..6f2fa2a42770 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -119,7 +119,7 @@ qcaspi_info_show(struct seq_file *s, void *what)
 	seq_printf(s, "SPI mode         : %x\n",
 		   qca->spi_dev->mode);
 	seq_printf(s, "SPI chip select  : %u\n",
-		   (unsigned int)qca->spi_dev->chip_select);
+		   (unsigned int)spi_get_chipselect(qca->spi_dev, 0));
 	seq_printf(s, "SPI legacy mode  : %u\n",
 		   (unsigned int)qca->legacy_mode);
 	seq_printf(s, "SPI burst length : %u\n",
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index e1a569b99e4a..7093a07141bb 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2967,7 +2967,7 @@ static int ca8210_test_interface_init(struct ca8210_priv *priv)
 		sizeof(node_name),
 		"ca8210@%d_%d",
 		priv->spi->master->bus_num,
-		priv->spi->chip_select
+		spi_get_chipselect(priv->spi, 0)
 	);
 
 	test->ca8210_dfs_spi_int = debugfs_create_file(
diff --git a/drivers/net/wan/slic_ds26522.c b/drivers/net/wan/slic_ds26522.c
index 6063552cea9b..8a51cfcff99e 100644
--- a/drivers/net/wan/slic_ds26522.c
+++ b/drivers/net/wan/slic_ds26522.c
@@ -211,7 +211,7 @@ static int slic_ds26522_probe(struct spi_device *spi)
 
 	ret = slic_ds26522_init_configure(spi);
 	if (ret == 0)
-		pr_info("DS26522 cs%d configured\n", spi->chip_select);
+		pr_info("DS26522 cs%d configured\n", spi_get_chipselect(spi, 0));
 
 	return ret;
 }
diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net/wireless/marvell/libertas/if_spi.c
index ff1c7ec8c450..1225fc0e3352 100644
--- a/drivers/net/wireless/marvell/libertas/if_spi.c
+++ b/drivers/net/wireless/marvell/libertas/if_spi.c
@@ -1051,7 +1051,7 @@ static int if_spi_init_card(struct if_spi_card *card)
 				"spi->max_speed_hz=%d\n",
 				card->card_id, card->card_rev,
 				card->spi->master->bus_num,
-				card->spi->chip_select,
+				spi_get_chipselect(card->spi, 0),
 				card->spi->max_speed_hz);
 		err = if_spi_prog_helper_firmware(card, helper);
 		if (err)
diff --git a/drivers/net/wireless/silabs/wfx/bus_spi.c b/drivers/net/wireless/silabs/wfx/bus_spi.c
index 7fb1afb8ed31..160b90114aad 100644
--- a/drivers/net/wireless/silabs/wfx/bus_spi.c
+++ b/drivers/net/wireless/silabs/wfx/bus_spi.c
@@ -208,7 +208,7 @@ static int wfx_spi_probe(struct spi_device *func)
 
 	/* Trace below is also displayed by spi_setup() if compiled with DEBUG */
 	dev_dbg(&func->dev, "SPI params: CS=%d, mode=%d bits/word=%d speed=%d\n",
-		func->chip_select, func->mode, func->bits_per_word, func->max_speed_hz);
+		spi_get_chipselect(func, 0), func->mode, func->bits_per_word, func->max_speed_hz);
 	if (func->bits_per_word != 16 && func->bits_per_word != 8)
 		dev_warn(&func->dev, "unusual bits/word value: %d\n", func->bits_per_word);
 	if (func->max_speed_hz > 50000000)
diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wireless/st/cw1200/cw1200_spi.c
index fe0d220da44d..c82c0688b549 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
@@ -378,7 +378,7 @@ static int cw1200_spi_probe(struct spi_device *func)
 	func->mode = SPI_MODE_0;
 
 	pr_info("cw1200_wlan_spi: Probe called (CS %d M %d BPW %d CLK %d)\n",
-		func->chip_select, func->mode, func->bits_per_word,
+		spi_get_chipselect(func, 0), func->mode, func->bits_per_word,
 		func->max_speed_hz);
 
 	if (cw1200_spi_on(plat_data)) {
-- 
2.25.1

