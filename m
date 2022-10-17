Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D66600EA1
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiJQMNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiJQMNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:13:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287631A811;
        Mon, 17 Oct 2022 05:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScEZXGXZLAngpuP1JrDNhbakDpergk/kWHVBXJ6yaQ22eA2t99M7QGJtIFw+xMrwZV573LWxIF71/o5XMmCjICe5dhGHesVuMVwocmV8PtFhZJv/btdGkGVeq2IXXfXbAHpc9iH1/oQtB9F0SE3pNSKvyWnU7qkC5vCKcX46SSQXqujysfvsgW3Go/piie0kucVnuR8ok+zfWs0nsV48JsSmZ+zXMAKgs0bZ4ZAAvsXBtgitQtO937ALcovycCuavGYCiwc0+XmasSmUVwEY8eyN86cf1c8mQd0tkS8Vo8wtjFl6MfF3zfzvMZ7QCoM2RHlpgmYpsm5zBIXHRhYPLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+OOhvf9vm68JdIg/K/RPVtUl+JCMYNMMnVHKJocI20=;
 b=gTG/mCTOoVQHlx0wJbC5Bh2GKtSKHJWkI0OAlWUzqQHCa/x6Q2HpKJMS3XIxe9VjP3bPEq7zRnYwy4ybj0Oe3COGhYVOc/uIR4Lia8oEib/0TRc+t6Ehar10UkTdp4V+thGpyo0ZBV/GtCPCIvEXVrvhry8paNUA2rD/3F8vhabuHDxrB4BNxq467czibCGQXdJPxK5o2qNqYoDxPugkDNq5w2Ys1XSdq2d9Q+zX1x9y6X0Makkey2yzzHxYH3Vj7LAURS5+uW3dW8otSrWZh45xaF6JHFJKjRebSlx+G0j4wYSIC9oXPss73ZdAdlm7hm/PGAyMW6Xrbd+gdXIz3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+OOhvf9vm68JdIg/K/RPVtUl+JCMYNMMnVHKJocI20=;
 b=KioMigmazqjCrqKkwj2qLW/B9Acljup9Z+j1zC/g9tJrEXCGKBCoLH/vYZNFjDmEFul8wYmHVwJrY+ibEE4vBNHDhEPbDqWDpsQtYuE9uDpUWaxZyL0AW4HpIQvsLVEd1NNP44ZHru9rILS5zpT8sl0EFb0P/0eEflVpfpe8PFc=
Received: from MW4PR04CA0200.namprd04.prod.outlook.com (2603:10b6:303:86::25)
 by CY5PR12MB6034.namprd12.prod.outlook.com (2603:10b6:930:2e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 12:13:29 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::44) by MW4PR04CA0200.outlook.office365.com
 (2603:10b6:303:86::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32 via Frontend
 Transport; Mon, 17 Oct 2022 12:13:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Mon, 17 Oct 2022 12:13:28 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 07:13:25 -0500
Received: from xhdlakshmis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 17 Oct 2022 07:13:02 -0500
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
Subject: [PATCH 00/10] spi: Add support for stacked/parallel memories
Date:   Mon, 17 Oct 2022 17:42:39 +0530
Message-ID: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT015:EE_|CY5PR12MB6034:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e949b9e-c633-4f4f-2b2b-08dab0390049
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UnjauWc33IchfFOhin/lfEzUnE4DnDDJfEwMJ26C6WmRnDOkf/Qwb4aMoN2RI5Eqq+2tiAbeo0KAJmarLWEM9tDs/x2BzokkMnAXUv6up8Ix0NH/DlI1ut5rgrTngBQV6Hfssa/EdpTxribN0zuoxpfJZeuK7z0CaBuBoVc5XqWldKdXPvBkMsDH7IwmdxeA/a8g6rMulbR3mDbdAKVl9tIuDZJr+utXEQ3Q6rbREhuhlwrDZKmiUwMyAnbhDYtUSvXKGPEUgKOYVkJgH0qNncBH4x2BdZWXvIT5dKotnRayE/epH8pMusQvg/Tn1nt0lNuN9EFoZnrIcuvFsuyWqY7eLpxMOwhOynTfQ/Dz6Nt0t6ZqktneaCFKNqKvHG6dODmLyco7sdMAwf+4pkj+U1cFyM+9BaVmnFqCo/UEZ0iIpk6u8KWzEKN9m9kIlQTMbA5bSoxZEe22kZSvbl+isNi6cyeUkGTPxn1ZG5woGnvEy4Fxmaki3GDp0WJLIX2w5tJfbZ7LCI7tmt2bEmNX0Vz5sCakByIvJ6RWSBpz1GGfinTaNQyenEMP9l6EnVQ65Lz/Kn1g7/i3NP6m7lD/94Ct+P5zalTz7EsGJOj6g4KmRqcGyCMzsKzB4MrL1zIRzlhXGONNKZ+MhFHI/F1WwYDHcTqz1cxtAQ3Ygs9GeZ6d7ZWvFmN11gGRzxnp30yHCy494nBI0tKwHEhwokR+Oq4xaUKYy1cfcVpu/kq0rv3PytPTBFLio64ERZc4WzsvGUu3SA49lJE4CSNpH6VMrnESjFNwxHjDIoodNmXKJ+eRUaj+h7OrDQ9DgiDCqSSd/WaygIXvk9sW1nf6aAwRmrn3TP3fV2O33M/5fm1t2Et8T/gIBD2JVxHzfGI0uFv0ptTlGPAbm1I3B91Lr2PxnQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(40470700004)(36840700001)(46966006)(6666004)(478600001)(41300700001)(316002)(4326008)(54906003)(110136005)(8676002)(36756003)(70586007)(70206006)(921005)(81166007)(356005)(40460700003)(1076003)(82310400005)(2616005)(336012)(36860700001)(186003)(82740400003)(26005)(47076005)(426003)(83380400001)(86362001)(40480700001)(7416002)(7406005)(7366002)(2906002)(7336002)(5660300002)(8936002)(36900700001)(2101003)(41080700001)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 12:13:28.8109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e949b9e-c633-4f4f-2b2b-08dab0390049
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6034
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is in the continuation to the discussions which happened on
'commit f89504300e94 ("spi: Stacked/parallel memories bindings")' for
adding dtbinding support for stacked/parallel memories.

This patch series updated the spi-nor, spi core and the spi drivers
to add stacked and parallel memories support.
---
BRANCH: mtd/next
---
Amit Kumar Mahapatra (10):
  spi: Add stacked memories support in SPI core
  spi: Replace all spi->chip_select & spi->cs_gpiod references with
    array
  net: Replace spi->chip_select references to spi->chip_select[0]
  mtd: devices: Replace spi->chip_select references to
    spi->chip_select[0]
  iio: imu: Replace spi->chip_select references to spi->chip_select[0]
  mtd: spi-nor: Add stacked memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add stacked memories support in GQSPI driver
  spi: Add parallel memories support in SPI core
  mtd: spi-nor: Add parallel memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add parallel memories support in GQSPI driver

 drivers/iio/imu/adis16400.c                   |   2 +-
 drivers/mtd/devices/mtd_dataflash.c           |   2 +-
 drivers/mtd/spi-nor/atmel.c                   |  10 +-
 drivers/mtd/spi-nor/core.c                    | 569 +++++++++++++++---
 drivers/mtd/spi-nor/core.h                    |   8 +
 drivers/mtd/spi-nor/debugfs.c                 |   4 +-
 drivers/mtd/spi-nor/gigadevice.c              |   2 +-
 drivers/mtd/spi-nor/issi.c                    |   6 +-
 drivers/mtd/spi-nor/macronix.c                |   4 +-
 drivers/mtd/spi-nor/micron-st.c               |  27 +-
 drivers/mtd/spi-nor/otp.c                     |  18 +-
 drivers/mtd/spi-nor/sfdp.c                    |  20 +-
 drivers/mtd/spi-nor/spansion.c                |  32 +-
 drivers/mtd/spi-nor/sst.c                     |   4 +-
 drivers/mtd/spi-nor/swp.c                     |  12 +-
 drivers/mtd/spi-nor/winbond.c                 |   6 +-
 drivers/mtd/spi-nor/xilinx.c                  |  14 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |   2 +-
 drivers/net/ethernet/davicom/dm9051.c         |   2 +-
 drivers/net/ieee802154/ca8210.c               |   2 +-
 drivers/net/wan/slic_ds26522.c                |   2 +-
 .../net/wireless/marvell/libertas/if_spi.c    |   2 +-
 drivers/spi/spi-altera-core.c                 |   2 +-
 drivers/spi/spi-amd.c                         |   4 +-
 drivers/spi/spi-ar934x.c                      |   2 +-
 drivers/spi/spi-armada-3700.c                 |   4 +-
 drivers/spi/spi-aspeed-smc.c                  |  12 +-
 drivers/spi/spi-at91-usart.c                  |   2 +-
 drivers/spi/spi-ath79.c                       |   4 +-
 drivers/spi/spi-atmel.c                       |  26 +-
 drivers/spi/spi-au1550.c                      |   4 +-
 drivers/spi/spi-axi-spi-engine.c              |   2 +-
 drivers/spi/spi-bcm-qspi.c                    |   6 +-
 drivers/spi/spi-bcm2835.c                     |   6 +-
 drivers/spi/spi-bcm2835aux.c                  |   2 +-
 drivers/spi/spi-bcm63xx-hsspi.c               |  22 +-
 drivers/spi/spi-bcm63xx.c                     |   2 +-
 drivers/spi/spi-cadence-quadspi.c             |   4 +-
 drivers/spi/spi-cadence-xspi.c                |   4 +-
 drivers/spi/spi-cadence.c                     |   4 +-
 drivers/spi/spi-cavium.c                      |   8 +-
 drivers/spi/spi-coldfire-qspi.c               |   8 +-
 drivers/spi/spi-davinci.c                     |  18 +-
 drivers/spi/spi-dln2.c                        |   6 +-
 drivers/spi/spi-dw-core.c                     |   2 +-
 drivers/spi/spi-dw-mmio.c                     |   4 +-
 drivers/spi/spi-falcon.c                      |   2 +-
 drivers/spi/spi-fsi.c                         |   2 +-
 drivers/spi/spi-fsl-dspi.c                    |   4 +-
 drivers/spi/spi-fsl-espi.c                    |   6 +-
 drivers/spi/spi-fsl-lpspi.c                   |   2 +-
 drivers/spi/spi-fsl-qspi.c                    |   6 +-
 drivers/spi/spi-fsl-spi.c                     |  10 +-
 drivers/spi/spi-gpio.c                        |   4 +-
 drivers/spi/spi-hisi-sfc-v3xx.c               |   2 +-
 drivers/spi/spi-img-spfi.c                    |  14 +-
 drivers/spi/spi-imx.c                         |  30 +-
 drivers/spi/spi-ingenic.c                     |   4 +-
 drivers/spi/spi-jcore.c                       |   4 +-
 drivers/spi/spi-mem.c                         |   4 +-
 drivers/spi/spi-meson-spicc.c                 |   2 +-
 drivers/spi/spi-mpc512x-psc.c                 |   8 +-
 drivers/spi/spi-mpc52xx.c                     |   2 +-
 drivers/spi/spi-mt65xx.c                      |   6 +-
 drivers/spi/spi-mt7621.c                      |   2 +-
 drivers/spi/spi-mux.c                         |   8 +-
 drivers/spi/spi-mxs.c                         |   2 +-
 drivers/spi/spi-npcm-fiu.c                    |  20 +-
 drivers/spi/spi-nxp-fspi.c                    |  10 +-
 drivers/spi/spi-omap-100k.c                   |   2 +-
 drivers/spi/spi-omap-uwire.c                  |   8 +-
 drivers/spi/spi-omap2-mcspi.c                 |  24 +-
 drivers/spi/spi-orion.c                       |   4 +-
 drivers/spi/spi-pic32-sqi.c                   |   2 +-
 drivers/spi/spi-pic32.c                       |   4 +-
 drivers/spi/spi-pl022.c                       |   2 +-
 drivers/spi/spi-pxa2xx.c                      |   6 +-
 drivers/spi/spi-qcom-qspi.c                   |   2 +-
 drivers/spi/spi-rb4xx.c                       |   2 +-
 drivers/spi/spi-rockchip-sfc.c                |   2 +-
 drivers/spi/spi-rockchip.c                    |  28 +-
 drivers/spi/spi-rspi.c                        |  10 +-
 drivers/spi/spi-s3c64xx.c                     |   2 +-
 drivers/spi/spi-sc18is602.c                   |   4 +-
 drivers/spi/spi-sh-msiof.c                    |   6 +-
 drivers/spi/spi-st-ssc4.c                     |   2 +-
 drivers/spi/spi-stm32-qspi.c                  |   6 +-
 drivers/spi/spi-sun4i.c                       |   2 +-
 drivers/spi/spi-sun6i.c                       |   2 +-
 drivers/spi/spi-synquacer.c                   |   6 +-
 drivers/spi/spi-tegra114.c                    |  28 +-
 drivers/spi/spi-tegra20-sflash.c              |   2 +-
 drivers/spi/spi-tegra20-slink.c               |   6 +-
 drivers/spi/spi-ti-qspi.c                     |  16 +-
 drivers/spi/spi-topcliff-pch.c                |   2 +-
 drivers/spi/spi-xcomm.c                       |   2 +-
 drivers/spi/spi-xilinx.c                      |   6 +-
 drivers/spi/spi-xlp.c                         |   4 +-
 drivers/spi/spi-zynq-qspi.c                   |   2 +-
 drivers/spi/spi-zynqmp-gqspi.c                |  58 +-
 drivers/spi/spi.c                             | 219 ++++---
 drivers/spi/spidev.c                          |   4 +-
 include/linux/mtd/spi-nor.h                   |   8 +-
 include/linux/spi/spi.h                       |  28 +-
 include/trace/events/spi.h                    |  10 +-
 105 files changed, 1062 insertions(+), 521 deletions(-)

-- 
2.17.1

