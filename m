Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB47867417F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjASS4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjASSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:55:58 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F9695160;
        Thu, 19 Jan 2023 10:55:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apztk2ifeyuGMyP/IRy3Vrcw4AtzTzrVtvt4K688GWNy2ZRwOb/xZfPzLDaeeKsXzTfMERIZO2PmH+05ifj3rvDUe+nJdWek4bwp0R38mtt2h0wB+fAsGyUvWksn9i08KGCLfPuPV2pJ3tAOASU6eei8aUPIPNnxtxkb1OGtpQWiXfvJf8zMJK01UL3qeS4Tml6LdJ0oKl5yEeU8e7hwzqIZt/k7pKfO6+vVc3J9MEbork1BSeVx2V9/uPzBHSYYryQiBWp3hP7ZBhBiMGCg4DoteWtxBHFkAu9YB1HfWEH5LK0Vep70gx8NimQiFkVTYRuMMgTBF5tGhCpvc/Molg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFHms4K5Cy6aUNWv87wGZIlJV1SNhNSmBs7juCbK6Ns=;
 b=EU6waCbEn2As1J2VSkREEuzk49SmX1MitubijvA6+dWJMQ9boWN1HxQx49GBZ6OXnt3vzSkM8DggNOMqTr1qOJKnH5wx/67oTvu0FSMYh1NE7iLaOLREADFBzlfBnG3NqlUGO4TXmRyfRix31EZz7jnO+uMXnuL7EsRFuXiMebGHNHp+r+ua+zSyE8MVx+9cycd0lDwCRn2v4eN/RlrNxn+cVLPbl+Sqz7iKaGNXva+F6U/yAC2koAk65TYp+j31xZYQAUJAY1qFOMHJQ/oVxWJJmUDCcCkGoM5tJFSU89wmgj3YE+tUpJ6EGgD+XAfBR/PdmPqf/naCezF5/5i0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFHms4K5Cy6aUNWv87wGZIlJV1SNhNSmBs7juCbK6Ns=;
 b=vyvGqoFuFYCyCnHl9W9Am3tS8l1406yqbLlrcn2SPYSnt5bzbzG7I39USsjyrT/7U8eHwHryheIFfYKzDFtDKSEROzV++RcEnplfOhV0BDH+to1/8/cz79QI3E2781Ner6oG4BpUOetPYWGtfLuj/Z7vWNbWKM35palLJUTIw8A=
Received: from SJ0PR13CA0098.namprd13.prod.outlook.com (2603:10b6:a03:2c5::13)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 18:55:29 +0000
Received: from CO1PEPF00001A5E.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::db) by SJ0PR13CA0098.outlook.office365.com
 (2603:10b6:a03:2c5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.16 via Frontend
 Transport; Thu, 19 Jan 2023 18:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF00001A5E.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Thu, 19 Jan 2023 18:55:29 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:55:27 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:55:26 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 12:55:01 -0600
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
        <kvalo@kernel.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>,
        <sumit.semwal@linaro.org>, <christian.koenig@amd.com>,
        <j.neuschaefer@gmx.net>, <vireshk@kernel.org>, <rmfrfs@gmail.com>,
        <johan@kernel.org>, <elder@kernel.org>,
        <gregkh@linuxfoundation.org>
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
        <ldewangan@nvidia.com>, <michal.simek@amd.com>,
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
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <greybus-dev@lists.linaro.org>, <linux-staging@lists.linux.dev>,
        <amitrkcian2002@gmail.com>
Subject: [PATCH v2 03/13] net: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Fri, 20 Jan 2023 00:23:32 +0530
Message-ID: <20230119185342.2093323-4-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5E:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aca4ef3-8256-4657-afa8-08dafa4ebc0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eSTmTyVf+1XOjkU4+KaPDlmjUCIS2xZDF1bD/vSncP/r+bUGwo0HYK9Is+SiRAxKLJ5pMaOynjC55UnUgNvhKuyVoPE0z6cySGAZCkbrIuunVdGp9bgaMmsyJ4MD7CTeCQCXoMwMMDEl20shfRjXjr4Nb3tvZrZK9zSEGhIa8JI/OoCJDJ9BZFrUN6PdcTD0H+Q6h84qPOyBj6aoUcxosbsrG2nhyRYC0dH46HBBAvWpjNkf76nIHocYMnbYLYdgZH7cUXLOufWhmgmaPNvgGrB1OW3Iz7IK9/F+HJbm7y2Ohqe96n59DLXBc1WhRpMOR84pQSMxXxUn5lSyjelVorJ5KK+yCJ1koEzRoZclXerR5pLYw1ghSOvg0lsMMaXramv0fvUEJv+8ysrCMwYXv04nMIGp+YXz6MkTv0w5WTiviKMxvQ4O3idm4WifsavI70zUojQN0eDnByhhZ+w7NpJJnHG4M6mt4dhbXVSNLVS9XQjrqRa2qVwpEOLhM+pb5n55qly7MGuPHTZB6XYBPCfnYTv/6XMKEctecwhHHM13aRacjtMyqHHsJaYxwTjIZGOxYJNZnu4IHYY4gXjph7Bh6trR5Q1SUed89ZZYE7LCvC6aMlo+PyZMAl0JXHvij77YWy0c6oYco5sWd3dF8/qTd89fj/RRZ6H11EgZx15JAE0dxv+U+AS26a1yQQDLNoeuc2XjJ9XYcdfgpcKfZCIjyrZ0M9VEs7UIji3cneE9lYi66WaVy8q07Rogi+6oSMVla5FzB7Rtn5rvT2jEl944IgvFOv6uhEQnYM6GKOyB/UAnqHDQxZZy4+j6/8uEFAtNiAxsUBccRNvL8lxfb85Vwk+S3M9fWWXqnB2cxRE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(40460700003)(82310400005)(921005)(356005)(81166007)(36756003)(1191002)(40480700001)(86362001)(82740400003)(2616005)(6666004)(478600001)(186003)(26005)(8936002)(7366002)(1076003)(7406005)(7276002)(7336002)(36860700001)(2906002)(7416002)(5660300002)(4326008)(70206006)(8676002)(70586007)(110136005)(336012)(54906003)(426003)(316002)(83380400001)(41300700001)(47076005)(41080700001)(83996005)(84006005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:55:29.2693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aca4ef3-8256-4657-afa8-08dafa4ebc0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
2.17.1

