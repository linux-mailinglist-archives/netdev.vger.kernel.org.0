Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572EB6B4E97
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 18:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjCJRek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 12:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCJReb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 12:34:31 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75190120EAB;
        Fri, 10 Mar 2023 09:34:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtIb/v/UGk5nJL+pzs0c0LWa5+sO5iASGHR9GWviUERfUy/cnFl1ddq5Kb2lQx7aGjJA1si2qNt9PZ1onwofLLceGnCkUv1b2zG9VD2OUwOOs34kWB+2nRw+A5VMMVuqj6UxUslo9disxFAoegRfFyCZuwQyQDsWotsqyphFJOS+b4Sn7tql2uFzwjCflP6ZDBb278I+9t1hos2bfX1IUnqOsFOfeRH8pWbOfqPXUPFwGfBQywyYO/aYrbuKiWVM3vDPw60bpWydo605S37LqEl9vcX61iurJgiZ4lwu35wf75GqXQeRebj83plmbsdE9IaQjqfplaYLbPgC9pE/zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/FkuphY6bwHQcB7w+5PPDqXWPlYdqqVovHuVQJsw7k=;
 b=Iv1/pDGo4GXYzjAmT2VF4NeQpKDiDE/sSztb/iUTrmiFjTNoKMWlKOC6lOJKlLVtX6TLg873C0D918TsL3bBCjfs8zJr5f9L8UrxhLHt5yYrF5YJenCIyKSQMO2jGiS2wwfJUaz02zLnYnL/nRulM8U3bK6tNUFvgB9/5ooas4K6sytKKFrRT1ua/hBodc0g9sp2SAKSKtUWdMLo2tmtmtkECz4w+couohVVpIrRN7+wCRc5EfPz8RBt2clbLrXbxAPWPLxM3SpQPNnW7n2fQcFSB1nZON/R7iBCh1lZN4N4mvHR0aitfCiEERYF/PPFCIuduvukekjsFHotBEXDZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/FkuphY6bwHQcB7w+5PPDqXWPlYdqqVovHuVQJsw7k=;
 b=fNlQ27ojAUnwzazpZkc5Sy7HriL3XHmfr255qShQs50mckcLZEHU1p4zJzgQxHCE4crrz0sJk66vlZmBL3IGZzmGee5TDsDssmRvHINsWpAOoOfpc++Ve7doV2oRwkePLzbg0a5J3W1v0f8Msg2a3pylmnJ/TK/gRDVjYTJrlaY=
Received: from DS7PR03CA0176.namprd03.prod.outlook.com (2603:10b6:5:3b2::31)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 17:34:10 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::f5) by DS7PR03CA0176.outlook.office365.com
 (2603:10b6:5:3b2::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Fri, 10 Mar 2023 17:34:10 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.20 via Frontend Transport; Fri, 10 Mar 2023 17:34:09 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:34:06 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:34:06 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Mar 2023 11:33:39 -0600
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
Subject: [PATCH V6 02/15] net: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Fri, 10 Mar 2023 23:02:04 +0530
Message-ID: <20230310173217.3429788-3-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
References: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT032:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a99c183-284c-4367-e132-08db218da7d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gV7hkcCGuLYxXSo0U11n5Vczs1ZH3w8xV52NCmVJsdgDIn7/rnnYxjg2CGY1wL8SP1ZJ0F/suTZw49HmDTiYT2jWlJ+2b1vip0RxKAcgIcqesohPTBvlhEAb+7YRGpjUs+02bgealk0387aYH0CGhPBpf0nFUyP//W0UjaKkraovJLuQ7dmaU053zgXNjkJoCTUsvV6G4sZeD3WDTGHcVVJ3e8V3Cp199kBgb83nne/fKV5hFzOVqMmqjOCDu7v4uleMXLFkOd7Q95415IznqcNhtyYCBiwez86vRPmEGp+AvoLysWcSo8ucxbbKeQ8yy/SqwkmhUoxQHnPwK6sITS6R2+/4v40vdtTLzAT0Y4DLYpVZsNxX/56iTgYsKn72ctpKU6GYw9EP9b2CfugyIyC9tqHVS6ODEURtcFFIsQlja7YKfU9ZHUTwbDJ0PQ4OjFhxJWTBcB79HZrngTeeE+jwgjId/NhnHV6z4KyWn6mk5YpWz3HuzcWTmPko7gKTNfKnAJtmgGlMiyatEFAZT5du6z35Non804lpPw7GhIuiptsiK58agUBghcAeNbo37rDkvUsRbUEwcS+jRaIz6A+dIHlLgTl7LDKCkSYQb70UwMGKnsL85phrZuSWui0+9kJ8dM94pieg/ASZjJJ7c9gflBeWQXunjrZ0cogOK59pyY8yO1kBEIUs0ZC+nxh/S3vUwzVwRl8FZ5CYgzT+Jf4NwxEr/5dbzeepIQcZU1iCwmjYReUPW4811UvzqKQBsq5GqqY2Pwfe7PzWB/TB9yqwQqSvyBoI7bzBEf+8hWS3S/5+bEFB75ONN2iWKlFKGtHsqR1Swp6Evln48ckpfendPW0KdUc0e3LLyDVr0R0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(36756003)(2616005)(186003)(54906003)(110136005)(478600001)(7276002)(2906002)(7366002)(316002)(7416002)(5660300002)(70586007)(70206006)(8676002)(7336002)(4326008)(41300700001)(8936002)(7406005)(26005)(1191002)(81166007)(356005)(921005)(86362001)(36860700001)(6666004)(40480700001)(82740400003)(1076003)(63370400001)(82310400005)(63350400001)(83380400001)(336012)(47076005)(426003)(36900700001)(84006005)(83996005)(2101003)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:34:09.1411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a99c183-284c-4367-e132-08db218da7d5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 3f316a0f4158..f5c2d7a9abc1 100644
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

