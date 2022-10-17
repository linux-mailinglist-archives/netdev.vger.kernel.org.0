Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15B5600EB4
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiJQMOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiJQMOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:14:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8689F6243;
        Mon, 17 Oct 2022 05:14:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEjj4eiPBLKmREgifyx/SZKhtgllWZY0RhQPIjCvbRW9tqXO/CW7PUM1ZiyYKoLCnv4dacg0hhQJcQ/04AutKKcZsJ3mU+EYbUveFGEob+FVcrPULeT/PEnzqULGsPTP4Y7pphevZkcoRmYdPQ2/JratRV9jg35GEmK+fD+ZxFeu4nHYQXOHYLxS744rEUGFcyTSDbNq6fNt7RLRoTTiGy7+PLsEB/E04UJXrxE7mpx3a6z/75tTTVuZTnZ50Lf/u4cTDsZxq8BVMmq/SChzqecjeXTOc4TkgPbict5g/eI4BMcIwe6eyZQPsw9GfI22LS4D2HgadmNuYuXTthqNHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cgh4G9gYmQyi6PjKuj1YRxi4p0rybOr+T0ci967d9k=;
 b=A/IK2xmABIjbuaXvCZtgryzVyXo1nd6O3UeoNxhjDwmpvZnHYmXoQBWKfro2UPw1LjQ6yIPZ8Bnxzl2gCdFMI+uUalNIawQzZgZYTAgAxO7iPvnCoW5Zkp2XmkNdun4ABxbQn7IUisNmPGD5S2Qi2UjgVr+wXUQdgZJ9WAKWrIvWFNXhx2ZyVXi+rff9XNRYOI3FMM7KwmUb9n2SMQlKF7qhyXTMiGw6NJzShTOrUulTo3iamO4RxHs46eSlth2uLW4pN1Q8DPH/24DSY11ZGb+K5wCPP7dVehia6FW9+MK4QWfwYMZE0j6n2zY+7K3PBMPQq/C3/B9UuUPF7kTQ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cgh4G9gYmQyi6PjKuj1YRxi4p0rybOr+T0ci967d9k=;
 b=n4YGlKIszufvGj4wdqxMfzPybFnu8b8IZNw9XYqpa9mO75npR3vfQ7x4vhgR7ASeR8p4H1d3yEQqbH42bkCuMgOK3IVRRSpqUOei+wfvYQdFCmkxXG1y/6l82QJqzurMVT2ZjVSzO6Wa2ZIZbxPSvvE0h06F9iCbWyUVNYGQDfY=
Received: from DS7PR03CA0178.namprd03.prod.outlook.com (2603:10b6:5:3b2::33)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 12:14:15 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:5:3b2:cafe::a5) by DS7PR03CA0178.outlook.office365.com
 (2603:10b6:5:3b2::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32 via Frontend
 Transport; Mon, 17 Oct 2022 12:14:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Mon, 17 Oct 2022 12:14:15 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 07:14:12 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 07:14:11 -0500
Received: from xhdlakshmis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 17 Oct 2022 07:13:48 -0500
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
Subject: [PATCH 02/10] spi: Replace all spi->chip_select & spi->cs_gpiod references with array
Date:   Mon, 17 Oct 2022 17:42:41 +0530
Message-ID: <20221017121249.19061-3-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
References: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f98f55f-bc38-4ab8-33f0-08dab0391bff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mEZj8F52lYlYMlSRCLPs3EkyWlVg0pNzY5JunIhKRqyrPRlobkMtCG8VPmhknkMWTncFSMvQz0yEbTaAAx6NJwLm/hEWFFqJeBt8lGrAxi3fUNMHerAvxxWiXK3iGkEpG04I7StHNiktEcQ1SfHuDuj/RsLwZirOQymWhrGjPVy+LthjCQT72mJOw9PJEHAtcR7wEP9WBpM48np7YWi8MvTJgaarJy1wTuLKHy1zW3vyS6EMiaBnoa7eOSKodoE0rOEU6m2DfAQ0Uf0cceNyFVscZeFgDDvpq2x2N7R0jQjAJ3fCknse28HGLHHUEoZt2jA1BW/y0kb1Ldbwd0orBcTax9HGckdFcIL2RPAqcvZr1n6Non2dEAFoX7rKevfNHTf18Er9NJVdH8QuIYSxfb74tYBAzAhmckEZI4wXaASkzp/3E17mOaO7KvCPdvJ+JRqWJ2p4fMhYa0lTk1LIT6ek0kZPHnVHkEZy7AcLSjK2l/awnj9UzhkU353I+wcHOjhdvRTiCbK+JHsamf8pB1mtidsX/6rZmQmq/xrYfVwSQ12yZf8/sCPI/VEw3Ajh7qLXatY02k5nuHQvtr6yjOCdJy5Xhtnx1mElvPBMYbAHLQaJqCvNQl1LE6UZcsy38Lzom2imXsU2KtVxeWpCrRnLi6qX/q27LxP+igMDfLBBySqVA0U1O5gGx/bJv1hN9AU47WLlakz+xQA5GADvofcq8bfq/KutLHkunhgEZDF8A3Ki/c0qPmidTaXtdqesHz30Mhvv3gXprGVhpxqDM1/zBs0z7LEw6XEm0Yfcl21fXdhMe3URrQPmXzNs7xPx5HcyxBzdaZM3o1IC35TqZMKApIL4bFfZrG2U36soedhR2WqRmlv9RfwV+xO+0J9iSWSiFtoQU8+2rnAlGbsmWw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(316002)(83380400001)(921005)(110136005)(54906003)(8936002)(6666004)(336012)(26005)(1076003)(186003)(2906002)(40460700003)(2616005)(7406005)(7366002)(7336002)(7416002)(36860700001)(5660300002)(30864003)(86362001)(70586007)(70206006)(8676002)(47076005)(426003)(82310400005)(41300700001)(4326008)(40480700001)(82740400003)(36756003)(66899015)(81166007)(478600001)(356005)(36900700001)(2101003)(41080700001)(83996005)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 12:14:15.1930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f98f55f-bc38-4ab8-33f0-08dab0391bff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For adding multi CS support in spi core the "chip_select" & "cs_gpiod"
members of the spi_device structure are now arrays. So, the
spi->chip_select[0] & spi->cs_gpiod[0] will hold the CSO value and gpio
descriptor of CS0 respectively. To prevent any existing spi driver from
breaking, replaced all spi->chip_select and spi->cs_gpiod references to
spi->chip_select[0] & spi->cs_gpiod[0] respectively.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/spi/spi-altera-core.c     |  2 +-
 drivers/spi/spi-amd.c             |  4 ++--
 drivers/spi/spi-ar934x.c          |  2 +-
 drivers/spi/spi-armada-3700.c     |  4 ++--
 drivers/spi/spi-aspeed-smc.c      | 12 ++++++------
 drivers/spi/spi-at91-usart.c      |  2 +-
 drivers/spi/spi-ath79.c           |  4 ++--
 drivers/spi/spi-atmel.c           | 26 +++++++++++++-------------
 drivers/spi/spi-au1550.c          |  4 ++--
 drivers/spi/spi-axi-spi-engine.c  |  2 +-
 drivers/spi/spi-bcm-qspi.c        |  6 +++---
 drivers/spi/spi-bcm2835.c         |  6 +++---
 drivers/spi/spi-bcm2835aux.c      |  2 +-
 drivers/spi/spi-bcm63xx-hsspi.c   | 22 +++++++++++-----------
 drivers/spi/spi-bcm63xx.c         |  2 +-
 drivers/spi/spi-cadence-quadspi.c |  4 ++--
 drivers/spi/spi-cadence-xspi.c    |  4 ++--
 drivers/spi/spi-cadence.c         |  4 ++--
 drivers/spi/spi-cavium.c          |  8 ++++----
 drivers/spi/spi-coldfire-qspi.c   |  8 ++++----
 drivers/spi/spi-davinci.c         | 18 +++++++++---------
 drivers/spi/spi-dln2.c            |  6 +++---
 drivers/spi/spi-dw-core.c         |  2 +-
 drivers/spi/spi-dw-mmio.c         |  4 ++--
 drivers/spi/spi-falcon.c          |  2 +-
 drivers/spi/spi-fsi.c             |  2 +-
 drivers/spi/spi-fsl-dspi.c        |  4 ++--
 drivers/spi/spi-fsl-espi.c        |  6 +++---
 drivers/spi/spi-fsl-lpspi.c       |  2 +-
 drivers/spi/spi-fsl-qspi.c        |  6 +++---
 drivers/spi/spi-fsl-spi.c         | 10 +++++-----
 drivers/spi/spi-gpio.c            |  4 ++--
 drivers/spi/spi-hisi-sfc-v3xx.c   |  2 +-
 drivers/spi/spi-img-spfi.c        | 14 +++++++-------
 drivers/spi/spi-imx.c             | 30 +++++++++++++++---------------
 drivers/spi/spi-ingenic.c         |  4 ++--
 drivers/spi/spi-jcore.c           |  4 ++--
 drivers/spi/spi-mem.c             |  4 ++--
 drivers/spi/spi-meson-spicc.c     |  2 +-
 drivers/spi/spi-mpc512x-psc.c     |  8 ++++----
 drivers/spi/spi-mpc52xx.c         |  2 +-
 drivers/spi/spi-mt65xx.c          |  6 +++---
 drivers/spi/spi-mt7621.c          |  2 +-
 drivers/spi/spi-mux.c             |  8 ++++----
 drivers/spi/spi-mxs.c             |  2 +-
 drivers/spi/spi-npcm-fiu.c        | 20 ++++++++++----------
 drivers/spi/spi-nxp-fspi.c        | 10 +++++-----
 drivers/spi/spi-omap-100k.c       |  2 +-
 drivers/spi/spi-omap-uwire.c      |  8 ++++----
 drivers/spi/spi-omap2-mcspi.c     | 24 ++++++++++++------------
 drivers/spi/spi-orion.c           |  4 ++--
 drivers/spi/spi-pic32-sqi.c       |  2 +-
 drivers/spi/spi-pic32.c           |  4 ++--
 drivers/spi/spi-pl022.c           |  2 +-
 drivers/spi/spi-pxa2xx.c          |  6 +++---
 drivers/spi/spi-qcom-qspi.c       |  2 +-
 drivers/spi/spi-rb4xx.c           |  2 +-
 drivers/spi/spi-rockchip-sfc.c    |  2 +-
 drivers/spi/spi-rockchip.c        | 28 ++++++++++++++++------------
 drivers/spi/spi-rspi.c            | 10 +++++-----
 drivers/spi/spi-s3c64xx.c         |  2 +-
 drivers/spi/spi-sc18is602.c       |  4 ++--
 drivers/spi/spi-sh-msiof.c        |  6 +++---
 drivers/spi/spi-st-ssc4.c         |  2 +-
 drivers/spi/spi-stm32-qspi.c      |  6 +++---
 drivers/spi/spi-sun4i.c           |  2 +-
 drivers/spi/spi-sun6i.c           |  2 +-
 drivers/spi/spi-synquacer.c       |  6 +++---
 drivers/spi/spi-tegra114.c        | 28 ++++++++++++++--------------
 drivers/spi/spi-tegra20-sflash.c  |  2 +-
 drivers/spi/spi-tegra20-slink.c   |  6 +++---
 drivers/spi/spi-ti-qspi.c         | 16 ++++++++--------
 drivers/spi/spi-topcliff-pch.c    |  2 +-
 drivers/spi/spi-xcomm.c           |  2 +-
 drivers/spi/spi-xilinx.c          |  6 +++---
 drivers/spi/spi-xlp.c             |  4 ++--
 drivers/spi/spi-zynq-qspi.c       |  2 +-
 drivers/spi/spi-zynqmp-gqspi.c    |  2 +-
 drivers/spi/spidev.c              |  4 ++--
 include/trace/events/spi.h        | 10 +++++-----
 80 files changed, 263 insertions(+), 259 deletions(-)

diff --git a/drivers/spi/spi-altera-core.c b/drivers/spi/spi-altera-core.c
index de4d31c530d9..3631d4926efa 100644
--- a/drivers/spi/spi-altera-core.c
+++ b/drivers/spi/spi-altera-core.c
@@ -80,7 +80,7 @@ static void altera_spi_set_cs(struct spi_device *spi, bool is_high)
 		altr_spi_writel(hw, ALTERA_SPI_SLAVE_SEL, 0);
 	} else {
 		altr_spi_writel(hw, ALTERA_SPI_SLAVE_SEL,
-				BIT(spi->chip_select));
+				BIT(spi->chip_select[0]));
 		hw->imr |= ALTERA_SPI_CONTROL_SSO_MSK;
 		altr_spi_writel(hw, ALTERA_SPI_CONTROL, hw->imr);
 	}
diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index 08df4f8d0531..46d83edc75dc 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -252,7 +252,7 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 	case AMD_SPI_V1:
 		break;
 	case AMD_SPI_V2:
-		amd_spi_clear_chip(amd_spi, message->spi->chip_select);
+		amd_spi_clear_chip(amd_spi, message->spi->chip_select[0]);
 		break;
 	default:
 		return -ENODEV;
@@ -269,7 +269,7 @@ static int amd_spi_master_transfer(struct spi_master *master,
 	struct amd_spi *amd_spi = spi_master_get_devdata(master);
 	struct spi_device *spi = msg->spi;
 
-	amd_spi_select_chip(amd_spi, spi->chip_select);
+	amd_spi_select_chip(amd_spi, spi->chip_select[0]);
 
 	/*
 	 * Extract spi_transfers from the spi message and
diff --git a/drivers/spi/spi-ar934x.c b/drivers/spi/spi-ar934x.c
index ec7250c4c810..ad0f9b9dd1f9 100644
--- a/drivers/spi/spi-ar934x.c
+++ b/drivers/spi/spi-ar934x.c
@@ -125,7 +125,7 @@ static int ar934x_spi_transfer_one_message(struct spi_controller *master,
 				iowrite32(reg, sp->base + AR934X_SPI_DATAOUT);
 			}
 
-			reg = AR934X_SPI_SHIFT_VAL(spi->chip_select, term,
+			reg = AR934X_SPI_SHIFT_VAL(spi->chip_select[0], term,
 						   trx_cur * 8);
 			iowrite32(reg, sp->base + AR934X_SPI_REG_SHIFT_CTRL);
 			stat = readl_poll_timeout(
diff --git a/drivers/spi/spi-armada-3700.c b/drivers/spi/spi-armada-3700.c
index 9df9fc40b783..dd5c7d552dc1 100644
--- a/drivers/spi/spi-armada-3700.c
+++ b/drivers/spi/spi-armada-3700.c
@@ -437,9 +437,9 @@ static void a3700_spi_set_cs(struct spi_device *spi, bool enable)
 	struct a3700_spi *a3700_spi = spi_master_get_devdata(spi->master);
 
 	if (!enable)
-		a3700_spi_activate_cs(a3700_spi, spi->chip_select);
+		a3700_spi_activate_cs(a3700_spi, spi->chip_select[0]);
 	else
-		a3700_spi_deactivate_cs(a3700_spi, spi->chip_select);
+		a3700_spi_deactivate_cs(a3700_spi, spi->chip_select[0]);
 }
 
 static void a3700_spi_header_set(struct a3700_spi *a3700_spi)
diff --git a/drivers/spi/spi-aspeed-smc.c b/drivers/spi/spi-aspeed-smc.c
index 3e891bf22470..ee86d5218ae6 100644
--- a/drivers/spi/spi-aspeed-smc.c
+++ b/drivers/spi/spi-aspeed-smc.c
@@ -296,7 +296,7 @@ static const struct aspeed_spi_data ast2400_spi_data;
 static int do_aspeed_spi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
 	struct aspeed_spi *aspi = spi_controller_get_devdata(mem->spi->master);
-	struct aspeed_spi_chip *chip = &aspi->chips[mem->spi->chip_select];
+	struct aspeed_spi_chip *chip = &aspi->chips[mem->spi->chip_select[0]];
 	u32 addr_mode, addr_mode_backup;
 	u32 ctl_val;
 	int ret = 0;
@@ -377,7 +377,7 @@ static const char *aspeed_spi_get_name(struct spi_mem *mem)
 	struct aspeed_spi *aspi = spi_controller_get_devdata(mem->spi->master);
 	struct device *dev = aspi->dev;
 
-	return devm_kasprintf(dev, GFP_KERNEL, "%s.%d", dev_name(dev), mem->spi->chip_select);
+	return devm_kasprintf(dev, GFP_KERNEL, "%s.%d", dev_name(dev), mem->spi->chip_select[0]);
 }
 
 struct aspeed_spi_window {
@@ -553,7 +553,7 @@ static int aspeed_spi_do_calibration(struct aspeed_spi_chip *chip);
 static int aspeed_spi_dirmap_create(struct spi_mem_dirmap_desc *desc)
 {
 	struct aspeed_spi *aspi = spi_controller_get_devdata(desc->mem->spi->master);
-	struct aspeed_spi_chip *chip = &aspi->chips[desc->mem->spi->chip_select];
+	struct aspeed_spi_chip *chip = &aspi->chips[desc->mem->spi->chip_select[0]];
 	struct spi_mem_op *op = &desc->info.op_tmpl;
 	u32 ctl_val;
 	int ret = 0;
@@ -620,7 +620,7 @@ static ssize_t aspeed_spi_dirmap_read(struct spi_mem_dirmap_desc *desc,
 				      u64 offset, size_t len, void *buf)
 {
 	struct aspeed_spi *aspi = spi_controller_get_devdata(desc->mem->spi->master);
-	struct aspeed_spi_chip *chip = &aspi->chips[desc->mem->spi->chip_select];
+	struct aspeed_spi_chip *chip = &aspi->chips[desc->mem->spi->chip_select[0]];
 
 	/* Switch to USER command mode if mapping window is too small */
 	if (chip->ahb_window_size < offset + len) {
@@ -670,7 +670,7 @@ static int aspeed_spi_setup(struct spi_device *spi)
 {
 	struct aspeed_spi *aspi = spi_controller_get_devdata(spi->master);
 	const struct aspeed_spi_data *data = aspi->data;
-	unsigned int cs = spi->chip_select;
+	unsigned int cs = spi->chip_select[0];
 	struct aspeed_spi_chip *chip = &aspi->chips[cs];
 
 	chip->aspi = aspi;
@@ -697,7 +697,7 @@ static int aspeed_spi_setup(struct spi_device *spi)
 static void aspeed_spi_cleanup(struct spi_device *spi)
 {
 	struct aspeed_spi *aspi = spi_controller_get_devdata(spi->master);
-	unsigned int cs = spi->chip_select;
+	unsigned int cs = spi->chip_select[0];
 
 	aspeed_spi_chip_enable(aspi, cs, false);
 
diff --git a/drivers/spi/spi-at91-usart.c b/drivers/spi/spi-at91-usart.c
index 9cd738682aab..eb38bf926684 100644
--- a/drivers/spi/spi-at91-usart.c
+++ b/drivers/spi/spi-at91-usart.c
@@ -390,7 +390,7 @@ static int at91_usart_spi_setup(struct spi_device *spi)
 
 	dev_dbg(&spi->dev,
 		"setup: bpw %u mode 0x%x -> mr %d %08x\n",
-		spi->bits_per_word, spi->mode, spi->chip_select, mr);
+		spi->bits_per_word, spi->mode, spi->chip_select[0], mr);
 
 	return 0;
 }
diff --git a/drivers/spi/spi-ath79.c b/drivers/spi/spi-ath79.c
index 607e7a49fb89..56c182a350ff 100644
--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -71,7 +71,7 @@ static void ath79_spi_chipselect(struct spi_device *spi, int is_active)
 {
 	struct ath79_spi *sp = ath79_spidev_to_sp(spi);
 	int cs_high = (spi->mode & SPI_CS_HIGH) ? is_active : !is_active;
-	u32 cs_bit = AR71XX_SPI_IOC_CS(spi->chip_select);
+	u32 cs_bit = AR71XX_SPI_IOC_CS(spi->chip_select[0]);
 
 	if (cs_high)
 		sp->ioc_base |= cs_bit;
@@ -140,7 +140,7 @@ static int ath79_exec_mem_op(struct spi_mem *mem,
 	struct ath79_spi *sp = ath79_spidev_to_sp(mem->spi);
 
 	/* Ensures that reading is performed on device connected to hardware cs0 */
-	if (mem->spi->chip_select || mem->spi->cs_gpiod)
+	if (mem->spi->chip_select[0] || mem->spi->cs_gpiod[0])
 		return -ENOTSUPP;
 
 	/* Only use for fast-read op. */
diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index c4f22d50dba5..63dbfa94cedf 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -327,10 +327,10 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 	int chip_select;
 	u32 mr;
 
-	if (spi->cs_gpiod)
+	if (spi->cs_gpiod[0])
 		chip_select = as->native_cs_for_gpio;
 	else
-		chip_select = spi->chip_select;
+		chip_select = spi->chip_select[0];
 
 	if (atmel_spi_is_v2(as)) {
 		spi_writel(as, CSR0 + 4 * chip_select, asd->csr);
@@ -378,10 +378,10 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 	int chip_select;
 	u32 mr;
 
-	if (spi->cs_gpiod)
+	if (spi->cs_gpiod[0])
 		chip_select = as->native_cs_for_gpio;
 	else
-		chip_select = spi->chip_select;
+		chip_select = spi->chip_select[0];
 
 	/* only deactivate *this* device; sometimes transfers to
 	 * another device may be active when this routine is called.
@@ -394,7 +394,7 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 
 	dev_dbg(&spi->dev, "DEactivate NPCS, mr %08x\n", mr);
 
-	if (!spi->cs_gpiod)
+	if (!spi->cs_gpiod[0])
 		spi_writel(as, CR, SPI_BIT(LASTXFER));
 }
 
@@ -800,10 +800,10 @@ static int atmel_spi_set_xfer_speed(struct atmel_spi *as,
 	unsigned long		bus_hz;
 	int chip_select;
 
-	if (spi->cs_gpiod)
+	if (spi->cs_gpiod[0])
 		chip_select = as->native_cs_for_gpio;
 	else
-		chip_select = spi->chip_select;
+		chip_select = spi->chip_select[0];
 
 	/* v1 chips start out at half the peripheral bus speed. */
 	bus_hz = as->spi_clk;
@@ -1189,7 +1189,7 @@ static int atmel_spi_setup(struct spi_device *spi)
 	as = spi_master_get_devdata(spi->master);
 
 	/* see notes above re chipselect */
-	if (!spi->cs_gpiod && (spi->mode & SPI_CS_HIGH)) {
+	if (!spi->cs_gpiod[0] && (spi->mode & SPI_CS_HIGH)) {
 		dev_warn(&spi->dev, "setup: non GPIO CS can't be active-high\n");
 		return -EINVAL;
 	}
@@ -1201,16 +1201,16 @@ static int atmel_spi_setup(struct spi_device *spi)
 	 */
 	initialize_native_cs_for_gpio(as);
 
-	if (spi->cs_gpiod && as->native_cs_free) {
+	if (spi->cs_gpiod[0] && as->native_cs_free) {
 		dev_err(&spi->dev,
 			"No native CS available to support this GPIO CS\n");
 		return -EBUSY;
 	}
 
-	if (spi->cs_gpiod)
+	if (spi->cs_gpiod[0])
 		chip_select = as->native_cs_for_gpio;
 	else
-		chip_select = spi->chip_select;
+		chip_select = spi->chip_select[0];
 
 	csr = SPI_BF(BITS, bits - 8);
 	if (spi->mode & SPI_CPOL)
@@ -1218,7 +1218,7 @@ static int atmel_spi_setup(struct spi_device *spi)
 	if (!(spi->mode & SPI_CPHA))
 		csr |= SPI_BIT(NCPHA);
 
-	if (!spi->cs_gpiod)
+	if (!spi->cs_gpiod[0])
 		csr |= SPI_BIT(CSAAT);
 	csr |= SPI_BF(DLYBS, 0);
 
@@ -1244,7 +1244,7 @@ static int atmel_spi_setup(struct spi_device *spi)
 
 	dev_dbg(&spi->dev,
 		"setup: bpw %u mode 0x%x -> csr%d %08x\n",
-		bits, spi->mode, spi->chip_select, csr);
+		bits, spi->mode, spi->chip_select[0], csr);
 
 	if (!atmel_spi_is_v2(as))
 		spi_writel(as, CSR0 + 4 * chip_select, csr);
diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index e008761298da..5b62188f3811 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -166,7 +166,7 @@ static void au1550_spi_chipsel(struct spi_device *spi, int value)
 	switch (value) {
 	case BITBANG_CS_INACTIVE:
 		if (hw->pdata->deactivate_cs)
-			hw->pdata->deactivate_cs(hw->pdata, spi->chip_select,
+			hw->pdata->deactivate_cs(hw->pdata, spi->chip_select[0],
 					cspol);
 		break;
 
@@ -211,7 +211,7 @@ static void au1550_spi_chipsel(struct spi_device *spi, int value)
 		} while ((stat & PSC_SPISTAT_DR) == 0);
 
 		if (hw->pdata->activate_cs)
-			hw->pdata->activate_cs(hw->pdata, spi->chip_select,
+			hw->pdata->activate_cs(hw->pdata, spi->chip_select[0],
 					cspol);
 		break;
 	}
diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index 80c3e38f5c1b..a67238f5c11c 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -193,7 +193,7 @@ static void spi_engine_gen_cs(struct spi_engine_program *p, bool dry,
 	unsigned int mask = 0xff;
 
 	if (assert)
-		mask ^= BIT(spi->chip_select);
+		mask ^= BIT(spi->chip_select[0]);
 
 	spi_engine_program_add_cmd(p, dry, SPI_ENGINE_CMD_ASSERT(1, mask));
 }
diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index cad2d55dcd3d..413dced83d44 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -986,7 +986,7 @@ static int write_to_hw(struct bcm_qspi *qspi, struct spi_device *spi)
 		if (has_bspi(qspi))
 			mspi_cdram &= ~1;
 		else
-			mspi_cdram |= (~(1 << spi->chip_select) &
+			mspi_cdram |= (~(1 << spi->chip_select[0]) &
 				       MSPI_CDRAM_PCS);
 
 		write_cdram_slot(qspi, slot, mspi_cdram);
@@ -1047,7 +1047,7 @@ static int bcm_qspi_bspi_exec_mem_op(struct spi_device *spi,
 
 	from = op->addr.val;
 	if (!spi->cs_gpiod)
-		bcm_qspi_chip_select(qspi, spi->chip_select);
+		bcm_qspi_chip_select(qspi, spi->chip_select[0]);
 	bcm_qspi_write(qspi, MSPI, MSPI_WRITE_LOCK, 0);
 
 	/*
@@ -1127,7 +1127,7 @@ static int bcm_qspi_transfer_one(struct spi_master *master,
 	unsigned long timeo = msecs_to_jiffies(100);
 
 	if (!spi->cs_gpiod)
-		bcm_qspi_chip_select(qspi, spi->chip_select);
+		bcm_qspi_chip_select(qspi, spi->chip_select[0]);
 	qspi->trans_pos.trans = trans;
 	qspi->trans_pos.byte = 0;
 
diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 747e03228c48..1a9cb7b8d32b 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1276,7 +1276,7 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 	 */
 	if (spi->cs_gpiod)
 		return 0;
-	if (spi->chip_select > 1) {
+	if (spi->chip_select[0] > 1) {
 		/* error in the case of native CS requested with CS > 1
 		 * officially there is a CS2, but it is not documented
 		 * which GPIO is connected with that...
@@ -1301,7 +1301,7 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 	if (!chip)
 		return 0;
 
-	spi->cs_gpiod = gpiochip_request_own_desc(chip, 8 - spi->chip_select,
+	spi->cs_gpiod = gpiochip_request_own_desc(chip, 8 - spi->chip_select[0],
 						  DRV_NAME,
 						  GPIO_LOOKUP_FLAGS_DEFAULT,
 						  GPIOD_OUT_LOW);
@@ -1312,7 +1312,7 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 
 	/* and set up the "mode" and level */
 	dev_info(&spi->dev, "setting up native-CS%i to use GPIO\n",
-		 spi->chip_select);
+		 spi->chip_select[0]);
 
 	return 0;
 
diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index e28521922330..582a4f5e3744 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -465,7 +465,7 @@ static int bcm2835aux_spi_setup(struct spi_device *spi)
 	dev_warn(&spi->dev,
 		 "Native CS is not supported - please configure cs-gpio in device-tree\n");
 
-	if (spi->chip_select == 0)
+	if (spi->chip_select[0] == 0)
 		return 0;
 
 	dev_warn(&spi->dev, "Native CS is not working for cs > 0\n");
diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index b871fd810d80..3b215740150a 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -130,7 +130,7 @@ static void bcm63xx_hsspi_set_cs(struct bcm63xx_hsspi *bs, unsigned int cs,
 static void bcm63xx_hsspi_set_clk(struct bcm63xx_hsspi *bs,
 				  struct spi_device *spi, int hz)
 {
-	unsigned int profile = spi->chip_select;
+	unsigned int profile = spi->chip_select[0];
 	u32 reg;
 
 	reg = DIV_ROUND_UP(2048, DIV_ROUND_UP(bs->speed_hz, hz));
@@ -157,7 +157,7 @@ static void bcm63xx_hsspi_set_clk(struct bcm63xx_hsspi *bs,
 static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 {
 	struct bcm63xx_hsspi *bs = spi_master_get_devdata(spi->master);
-	unsigned int chip_select = spi->chip_select;
+	unsigned int chip_select = spi->chip_select[0];
 	u16 opcode = 0;
 	int pending = t->len;
 	int step_size = HSSPI_BUFFER_LEN;
@@ -165,7 +165,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 	u8 *rx = t->rx_buf;
 
 	bcm63xx_hsspi_set_clk(bs, spi, t->speed_hz);
-	bcm63xx_hsspi_set_cs(bs, spi->chip_select, true);
+	bcm63xx_hsspi_set_cs(bs, spi->chip_select[0], true);
 
 	if (tx && rx)
 		opcode = HSSPI_OP_READ_WRITE;
@@ -228,14 +228,14 @@ static int bcm63xx_hsspi_setup(struct spi_device *spi)
 	u32 reg;
 
 	reg = __raw_readl(bs->regs +
-			  HSSPI_PROFILE_SIGNAL_CTRL_REG(spi->chip_select));
+			  HSSPI_PROFILE_SIGNAL_CTRL_REG(spi->chip_select[0]));
 	reg &= ~(SIGNAL_CTRL_LAUNCH_RISING | SIGNAL_CTRL_LATCH_RISING);
 	if (spi->mode & SPI_CPHA)
 		reg |= SIGNAL_CTRL_LAUNCH_RISING;
 	else
 		reg |= SIGNAL_CTRL_LATCH_RISING;
 	__raw_writel(reg, bs->regs +
-		     HSSPI_PROFILE_SIGNAL_CTRL_REG(spi->chip_select));
+		     HSSPI_PROFILE_SIGNAL_CTRL_REG(spi->chip_select[0]));
 
 	mutex_lock(&bs->bus_mutex);
 	reg = __raw_readl(bs->regs + HSSPI_GLOBAL_CTRL_REG);
@@ -243,16 +243,16 @@ static int bcm63xx_hsspi_setup(struct spi_device *spi)
 	/* only change actual polarities if there is no transfer */
 	if ((reg & GLOBAL_CTRL_CS_POLARITY_MASK) == bs->cs_polarity) {
 		if (spi->mode & SPI_CS_HIGH)
-			reg |= BIT(spi->chip_select);
+			reg |= BIT(spi->chip_select[0]);
 		else
-			reg &= ~BIT(spi->chip_select);
+			reg &= ~BIT(spi->chip_select[0]);
 		__raw_writel(reg, bs->regs + HSSPI_GLOBAL_CTRL_REG);
 	}
 
 	if (spi->mode & SPI_CS_HIGH)
-		bs->cs_polarity |= BIT(spi->chip_select);
+		bs->cs_polarity |= BIT(spi->chip_select[0]);
 	else
-		bs->cs_polarity &= ~BIT(spi->chip_select);
+		bs->cs_polarity &= ~BIT(spi->chip_select[0]);
 
 	mutex_unlock(&bs->bus_mutex);
 
@@ -283,7 +283,7 @@ static int bcm63xx_hsspi_transfer_one(struct spi_master *master,
 	 * e. At the end restore the polarities again to their default values.
 	 */
 
-	dummy_cs = !spi->chip_select;
+	dummy_cs = !spi->chip_select[0];
 	bcm63xx_hsspi_set_cs(bs, dummy_cs, true);
 
 	list_for_each_entry(t, &msg->transfers, transfer_list) {
@@ -296,7 +296,7 @@ static int bcm63xx_hsspi_transfer_one(struct spi_master *master,
 		spi_transfer_delay_exec(t);
 
 		if (t->cs_change)
-			bcm63xx_hsspi_set_cs(bs, spi->chip_select, false);
+			bcm63xx_hsspi_set_cs(bs, spi->chip_select[0], false);
 	}
 
 	mutex_lock(&bs->bus_mutex);
diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 80fa0ef8909c..bb3571e74231 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -292,7 +292,7 @@ static int bcm63xx_txrx_bufs(struct spi_device *spi, struct spi_transfer *first,
 	/* Issue the transfer */
 	cmd = SPI_CMD_START_IMMEDIATE;
 	cmd |= (prepend_len << SPI_CMD_PREPEND_BYTE_CNT_SHIFT);
-	cmd |= (spi->chip_select << SPI_CMD_DEVICE_ID_SHIFT);
+	cmd |= (spi->chip_select[0] << SPI_CMD_DEVICE_ID_SHIFT);
 	bcm_spi_writew(bs, cmd, SPI_CMD);
 
 	/* Enable the CMD_DONE interrupt */
diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 72b1a5a2298c..32553b7fddb1 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1295,7 +1295,7 @@ static int cqspi_mem_process(struct spi_mem *mem, const struct spi_mem_op *op)
 	struct cqspi_st *cqspi = spi_master_get_devdata(mem->spi->master);
 	struct cqspi_flash_pdata *f_pdata;
 
-	f_pdata = &cqspi->f_pdata[mem->spi->chip_select];
+	f_pdata = &cqspi->f_pdata[mem->spi->chip_select[0]];
 	cqspi_configure(f_pdata, mem->spi->max_speed_hz);
 
 	if (op->data.dir == SPI_MEM_DATA_IN && op->data.buf.in) {
@@ -1495,7 +1495,7 @@ static const char *cqspi_get_name(struct spi_mem *mem)
 	struct cqspi_st *cqspi = spi_master_get_devdata(mem->spi->master);
 	struct device *dev = &cqspi->pdev->dev;
 
-	return devm_kasprintf(dev, GFP_KERNEL, "%s.%d", dev_name(dev), mem->spi->chip_select);
+	return devm_kasprintf(dev, GFP_KERNEL, "%s.%d", dev_name(dev), mem->spi->chip_select[0]);
 }
 
 static const struct spi_controller_mem_ops cqspi_mem_ops = {
diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index 3ab19be83095..6e0bf57afcd2 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -406,8 +406,8 @@ static int cdns_xspi_mem_op(struct cdns_xspi_dev *cdns_xspi,
 {
 	enum spi_mem_data_dir dir = op->data.dir;
 
-	if (cdns_xspi->cur_cs != mem->spi->chip_select)
-		cdns_xspi->cur_cs = mem->spi->chip_select;
+	if (cdns_xspi->cur_cs != mem->spi->chip_select[0])
+		cdns_xspi->cur_cs = mem->spi->chip_select[0];
 
 	return cdns_xspi_send_stig_command(cdns_xspi, op,
 					   (dir != SPI_MEM_NO_DATA));
diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 6a7f7df1e776..2cc909ca62c2 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -185,11 +185,11 @@ static void cdns_spi_chipselect(struct spi_device *spi, bool is_high)
 		/* Select the slave */
 		ctrl_reg &= ~CDNS_SPI_CR_SSCTRL;
 		if (!(xspi->is_decoded_cs))
-			ctrl_reg |= ((~(CDNS_SPI_SS0 << spi->chip_select)) <<
+			ctrl_reg |= ((~(CDNS_SPI_SS0 << spi->chip_select[0])) <<
 				     CDNS_SPI_SS_SHIFT) &
 				     CDNS_SPI_CR_SSCTRL;
 		else
-			ctrl_reg |= (spi->chip_select << CDNS_SPI_SS_SHIFT) &
+			ctrl_reg |= (spi->chip_select[0] << CDNS_SPI_SS_SHIFT) &
 				     CDNS_SPI_CR_SSCTRL;
 	}
 
diff --git a/drivers/spi/spi-cavium.c b/drivers/spi/spi-cavium.c
index 6854c3ce423b..6f309eb29119 100644
--- a/drivers/spi/spi-cavium.c
+++ b/drivers/spi/spi-cavium.c
@@ -57,8 +57,8 @@ static int octeon_spi_do_transfer(struct octeon_spi *p,
 	mpi_cfg.s.cslate = cpha ? 1 : 0;
 	mpi_cfg.s.enable = 1;
 
-	if (spi->chip_select < 4)
-		p->cs_enax |= 1ull << (12 + spi->chip_select);
+	if (spi->chip_select[0] < 4)
+		p->cs_enax |= 1ull << (12 + spi->chip_select[0]);
 	mpi_cfg.u64 |= p->cs_enax;
 
 	if (mpi_cfg.u64 != p->last_cfg) {
@@ -78,7 +78,7 @@ static int octeon_spi_do_transfer(struct octeon_spi *p,
 			writeq(d, p->register_base + OCTEON_SPI_DAT0(p) + (8 * i));
 		}
 		mpi_tx.u64 = 0;
-		mpi_tx.s.csid = spi->chip_select;
+		mpi_tx.s.csid = spi->chip_select[0];
 		mpi_tx.s.leavecs = 1;
 		mpi_tx.s.txnum = tx_buf ? OCTEON_SPI_MAX_BYTES : 0;
 		mpi_tx.s.totnum = OCTEON_SPI_MAX_BYTES;
@@ -103,7 +103,7 @@ static int octeon_spi_do_transfer(struct octeon_spi *p,
 	}
 
 	mpi_tx.u64 = 0;
-	mpi_tx.s.csid = spi->chip_select;
+	mpi_tx.s.csid = spi->chip_select[0];
 	if (last_xfer)
 		mpi_tx.s.leavecs = xfer->cs_change;
 	else
diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index 263ce9047327..02cbcb562311 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -290,9 +290,9 @@ static void mcfqspi_set_cs(struct spi_device *spi, bool enable)
 	bool cs_high = spi->mode & SPI_CS_HIGH;
 
 	if (enable)
-		mcfqspi_cs_select(mcfqspi, spi->chip_select, cs_high);
+		mcfqspi_cs_select(mcfqspi, spi->chip_select[0], cs_high);
 	else
-		mcfqspi_cs_deselect(mcfqspi, spi->chip_select, cs_high);
+		mcfqspi_cs_deselect(mcfqspi, spi->chip_select[0], cs_high);
 }
 
 static int mcfqspi_transfer_one(struct spi_master *master,
@@ -324,11 +324,11 @@ static int mcfqspi_transfer_one(struct spi_master *master,
 static int mcfqspi_setup(struct spi_device *spi)
 {
 	mcfqspi_cs_deselect(spi_master_get_devdata(spi->master),
-			    spi->chip_select, spi->mode & SPI_CS_HIGH);
+			    spi->chip_select[0], spi->mode & SPI_CS_HIGH);
 
 	dev_dbg(&spi->dev,
 			"bits per word %d, chip select %d, speed %d KHz\n",
-			spi->bits_per_word, spi->chip_select,
+			spi->bits_per_word, spi->chip_select[0],
 			(MCFQSPI_BUSCLK / mcfqspi_qmr_baud(spi->max_speed_hz))
 			/ 1000);
 
diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index d112c2cac042..f0e339c4c77e 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -199,7 +199,7 @@ static void davinci_spi_chipselect(struct spi_device *spi, int value)
 {
 	struct davinci_spi *dspi;
 	struct davinci_spi_config *spicfg = spi->controller_data;
-	u8 chip_sel = spi->chip_select;
+	u8 chip_sel = spi->chip_select[0];
 	u16 spidat1 = CS_DEFAULT;
 
 	dspi = spi_master_get_devdata(spi->master);
@@ -212,11 +212,11 @@ static void davinci_spi_chipselect(struct spi_device *spi, int value)
 	 * Board specific chip select logic decides the polarity and cs
 	 * line for the controller
 	 */
-	if (spi->cs_gpiod) {
+	if (spi->cs_gpiod[0]) {
 		if (value == BITBANG_CS_ACTIVE)
-			gpiod_set_value(spi->cs_gpiod, 1);
+			gpiod_set_value(spi->cs_gpiod[0], 1);
 		else
-			gpiod_set_value(spi->cs_gpiod, 0);
+			gpiod_set_value(spi->cs_gpiod[0], 0);
 	} else {
 		if (value == BITBANG_CS_ACTIVE) {
 			if (!(spi->mode & SPI_CS_WORD))
@@ -293,11 +293,11 @@ static int davinci_spi_setup_transfer(struct spi_device *spi,
 	if (bits_per_word <= 8) {
 		dspi->get_rx = davinci_spi_rx_buf_u8;
 		dspi->get_tx = davinci_spi_tx_buf_u8;
-		dspi->bytes_per_word[spi->chip_select] = 1;
+		dspi->bytes_per_word[spi->chip_select[0]] = 1;
 	} else {
 		dspi->get_rx = davinci_spi_rx_buf_u16;
 		dspi->get_tx = davinci_spi_tx_buf_u16;
-		dspi->bytes_per_word[spi->chip_select] = 2;
+		dspi->bytes_per_word[spi->chip_select[0]] = 2;
 	}
 
 	if (!hz)
@@ -415,11 +415,11 @@ static int davinci_spi_setup(struct spi_device *spi)
 	dspi = spi_master_get_devdata(spi->master);
 
 	if (!(spi->mode & SPI_NO_CS)) {
-		if (np && spi->cs_gpiod)
+		if (np && spi->cs_gpiod[0])
 			internal_cs = false;
 
 		if (internal_cs)
-			set_io_bits(dspi->base + SPIPC0, 1 << spi->chip_select);
+			set_io_bits(dspi->base + SPIPC0, 1 << spi->chip_select[0]);
 	}
 
 	if (spi->mode & SPI_READY)
@@ -579,7 +579,7 @@ static int davinci_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
 		spicfg = &davinci_spi_default_cfg;
 
 	/* convert len to words based on bits_per_word */
-	data_type = dspi->bytes_per_word[spi->chip_select];
+	data_type = dspi->bytes_per_word[spi->chip_select[0]];
 
 	dspi->tx = t->tx_buf;
 	dspi->rx = t->rx_buf;
diff --git a/drivers/spi/spi-dln2.c b/drivers/spi/spi-dln2.c
index 0a1fb2bc9e54..c7610cd8bf77 100644
--- a/drivers/spi/spi-dln2.c
+++ b/drivers/spi/spi-dln2.c
@@ -596,12 +596,12 @@ static int dln2_spi_prepare_message(struct spi_master *master,
 	struct dln2_spi *dln2 = spi_master_get_devdata(master);
 	struct spi_device *spi = message->spi;
 
-	if (dln2->cs != spi->chip_select) {
-		ret = dln2_spi_cs_set_one(dln2, spi->chip_select);
+	if (dln2->cs != spi->chip_select[0]) {
+		ret = dln2_spi_cs_set_one(dln2, spi->chip_select[0]);
 		if (ret < 0)
 			return ret;
 
-		dln2->cs = spi->chip_select;
+		dln2->cs = spi->chip_select[0];
 	}
 
 	return 0;
diff --git a/drivers/spi/spi-dw-core.c b/drivers/spi/spi-dw-core.c
index f87d97ccd2d6..5484ff733995 100644
--- a/drivers/spi/spi-dw-core.c
+++ b/drivers/spi/spi-dw-core.c
@@ -103,7 +103,7 @@ void dw_spi_set_cs(struct spi_device *spi, bool enable)
 	 * support active-high or active-low CS level.
 	 */
 	if (cs_high == enable)
-		dw_writel(dws, DW_SPI_SER, BIT(spi->chip_select));
+		dw_writel(dws, DW_SPI_SER, BIT(spi->chip_select[0]));
 	else
 		dw_writel(dws, DW_SPI_SER, 0);
 }
diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 26c40ea6dd12..ffe7c9241078 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -65,7 +65,7 @@ static void dw_spi_mscc_set_cs(struct spi_device *spi, bool enable)
 	struct dw_spi *dws = spi_master_get_devdata(spi->master);
 	struct dw_spi_mmio *dwsmmio = container_of(dws, struct dw_spi_mmio, dws);
 	struct dw_spi_mscc *dwsmscc = dwsmmio->priv;
-	u32 cs = spi->chip_select;
+	u32 cs = spi->chip_select[0];
 
 	if (cs < 4) {
 		u32 sw_mode = MSCC_SPI_MST_SW_MODE_SW_PIN_CTRL_MODE;
@@ -138,7 +138,7 @@ static void dw_spi_sparx5_set_cs(struct spi_device *spi, bool enable)
 	struct dw_spi *dws = spi_master_get_devdata(spi->master);
 	struct dw_spi_mmio *dwsmmio = container_of(dws, struct dw_spi_mmio, dws);
 	struct dw_spi_mscc *dwsmscc = dwsmmio->priv;
-	u8 cs = spi->chip_select;
+	u8 cs = spi->chip_select[0];
 
 	if (!enable) {
 		/* CS override drive enable */
diff --git a/drivers/spi/spi-falcon.c b/drivers/spi/spi-falcon.c
index a7d4dffac66b..1181cf7509d3 100644
--- a/drivers/spi/spi-falcon.c
+++ b/drivers/spi/spi-falcon.c
@@ -131,7 +131,7 @@ int falcon_sflash_xfer(struct spi_device *spi, struct spi_transfer *t,
 				 * especially alen and dumlen.
 				 */
 
-				priv->sfcmd = ((spi->chip_select
+				priv->sfcmd = ((spi->chip_select[0]
 						<< SFCMD_CS_OFFSET)
 					       & SFCMD_CS_MASK);
 				priv->sfcmd |= SFCMD_KEEP_CS_KEEP_SELECTED;
diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index cf1e4f9ebd72..93bd3fb35031 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -425,7 +425,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 					struct spi_message *mesg)
 {
 	int rc;
-	u8 seq_slave = SPI_FSI_SEQUENCE_SEL_SLAVE(mesg->spi->chip_select + 1);
+	u8 seq_slave = SPI_FSI_SEQUENCE_SEL_SLAVE(mesg->spi->chip_select[0] + 1);
 	unsigned int len;
 	struct spi_transfer *transfer;
 	struct fsi_spi *ctx = spi_controller_get_devdata(ctlr);
diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index fd004c9db9dc..2335b7536ff7 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -916,7 +916,7 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 		dspi->cur_chip = spi_get_ctldata(spi);
 		/* Prepare command word for CMD FIFO */
 		dspi->tx_cmd = SPI_PUSHR_CMD_CTAS(0) |
-			       SPI_PUSHR_CMD_PCS(spi->chip_select);
+			       SPI_PUSHR_CMD_PCS(spi->chip_select[0]);
 		if (list_is_last(&dspi->cur_transfer->transfer_list,
 				 &dspi->cur_msg->transfers)) {
 			/* Leave PCS activated after last transfer when
@@ -1040,7 +1040,7 @@ static void dspi_cleanup(struct spi_device *spi)
 	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
 
 	dev_dbg(&spi->dev, "spi_device %u.%u cleanup\n",
-		spi->controller->bus_num, spi->chip_select);
+		spi->controller->bus_num, spi->chip_select[0]);
 
 	kfree(chip);
 }
diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index f7066bef7b06..ea74a5d4c4d9 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -345,7 +345,7 @@ static void fsl_espi_setup_transfer(struct spi_device *spi,
 
 	/* don't write the mode register if the mode doesn't change */
 	if (cs->hw_mode != hw_mode_old)
-		fsl_espi_write_reg(espi, ESPI_SPMODEx(spi->chip_select),
+		fsl_espi_write_reg(espi, ESPI_SPMODEx(spi->chip_select[0]),
 				   cs->hw_mode);
 }
 
@@ -359,7 +359,7 @@ static int fsl_espi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	reinit_completion(&espi->done);
 
 	/* Set SPCOM[CS] and SPCOM[TRANLEN] field */
-	spcom = SPCOM_CS(spi->chip_select);
+	spcom = SPCOM_CS(spi->chip_select[0]);
 	spcom |= SPCOM_TRANLEN(t->len - 1);
 
 	/* configure RXSKIP mode */
@@ -492,7 +492,7 @@ static int fsl_espi_setup(struct spi_device *spi)
 
 	pm_runtime_get_sync(espi->dev);
 
-	cs->hw_mode = fsl_espi_read_reg(espi, ESPI_SPMODEx(spi->chip_select));
+	cs->hw_mode = fsl_espi_read_reg(espi, ESPI_SPMODEx(spi->chip_select[0]));
 	/* mask out bits we are going to set */
 	cs->hw_mode &= ~(CSMODE_CP_BEGIN_EDGECLK | CSMODE_CI_INACTIVEHIGH
 			 | CSMODE_REV);
diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 19b1f3d881b0..af8f59e9d9da 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -424,7 +424,7 @@ static int fsl_lpspi_setup_transfer(struct spi_controller *controller,
 	if (fsl_lpspi->is_only_cs1)
 		fsl_lpspi->config.chip_select = 1;
 	else
-		fsl_lpspi->config.chip_select = spi->chip_select;
+		fsl_lpspi->config.chip_select = spi->chip_select[0];
 
 	if (!fsl_lpspi->config.speed_hz)
 		fsl_lpspi->config.speed_hz = spi->max_speed_hz;
diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index 46ae46a944c5..57f9b9ecaa0d 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -528,7 +528,7 @@ static void fsl_qspi_select_mem(struct fsl_qspi *q, struct spi_device *spi)
 	unsigned long rate = spi->max_speed_hz;
 	int ret;
 
-	if (q->selected == spi->chip_select)
+	if (q->selected == spi->chip_select[0])
 		return;
 
 	if (needs_4x_clock(q))
@@ -544,7 +544,7 @@ static void fsl_qspi_select_mem(struct fsl_qspi *q, struct spi_device *spi)
 	if (ret)
 		return;
 
-	q->selected = spi->chip_select;
+	q->selected = spi->chip_select[0];
 
 	fsl_qspi_invalidate(q);
 }
@@ -823,7 +823,7 @@ static const char *fsl_qspi_get_name(struct spi_mem *mem)
 
 	name = devm_kasprintf(dev, GFP_KERNEL,
 			      "%s-%d", dev_name(q->dev),
-			      mem->spi->chip_select);
+			      mem->spi->chip_select[0]);
 
 	if (!name) {
 		dev_err(dev, "failed to get memory for custom flash name\n");
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index bdf94cc7be1a..a5c2ebefd521 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -555,10 +555,10 @@ static void fsl_spi_grlib_cs_control(struct spi_device *spi, bool on)
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
 	struct fsl_spi_reg __iomem *reg_base = mpc8xxx_spi->reg_base;
 	u32 slvsel;
-	u16 cs = spi->chip_select;
+	u16 cs = spi->chip_select[0];
 
-	if (spi->cs_gpiod) {
-		gpiod_set_value(spi->cs_gpiod, on);
+	if (spi->cs_gpiod[0]) {
+		gpiod_set_value(spi->cs_gpiod[0], on);
 	} else if (cs < mpc8xxx_spi->native_chipselects) {
 		slvsel = mpc8xxx_spi_read_reg(&reg_base->slvsel);
 		slvsel = on ? (slvsel | (1 << cs)) : (slvsel & ~(1 << cs));
@@ -690,8 +690,8 @@ static struct spi_master *fsl_spi_probe(struct device *dev,
 
 static void fsl_spi_cs_control(struct spi_device *spi, bool on)
 {
-	if (spi->cs_gpiod) {
-		gpiod_set_value(spi->cs_gpiod, on);
+	if (spi->cs_gpiod[0]) {
+		gpiod_set_value(spi->cs_gpiod[0], on);
 	} else {
 		struct device *dev = spi->dev.parent->parent;
 		struct fsl_spi_platform_data *pdata = dev_get_platdata(dev);
diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 4b12c4964a66..53e009d38d9e 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -230,7 +230,7 @@ static void spi_gpio_chipselect(struct spi_device *spi, int is_active)
 
 	/* Drive chip select line, if we have one */
 	if (spi_gpio->cs_gpios) {
-		struct gpio_desc *cs = spi_gpio->cs_gpios[spi->chip_select];
+		struct gpio_desc *cs = spi_gpio->cs_gpios[spi->chip_select[0]];
 
 		/* SPI chip selects are normally active-low */
 		gpiod_set_value_cansleep(cs, (spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
@@ -248,7 +248,7 @@ static int spi_gpio_setup(struct spi_device *spi)
 	 * initialized from the descriptor lookup.
 	 */
 	if (spi_gpio->cs_gpios) {
-		cs = spi_gpio->cs_gpios[spi->chip_select];
+		cs = spi_gpio->cs_gpios[spi->chip_select[0]];
 		if (!spi->controller_state && cs)
 			status = gpiod_direction_output(cs,
 						  !(spi->mode & SPI_CS_HIGH));
diff --git a/drivers/spi/spi-hisi-sfc-v3xx.c b/drivers/spi/spi-hisi-sfc-v3xx.c
index d3a23b1c2a4c..9b701081670f 100644
--- a/drivers/spi/spi-hisi-sfc-v3xx.c
+++ b/drivers/spi/spi-hisi-sfc-v3xx.c
@@ -361,7 +361,7 @@ static int hisi_sfc_v3xx_exec_op(struct spi_mem *mem,
 {
 	struct hisi_sfc_v3xx_host *host;
 	struct spi_device *spi = mem->spi;
-	u8 chip_select = spi->chip_select;
+	u8 chip_select = spi->chip_select[0];
 
 	host = spi_controller_get_devdata(spi->master);
 
diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index 71376b6df89d..d79542e16664 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -413,15 +413,15 @@ static int img_spfi_prepare(struct spi_master *master, struct spi_message *msg)
 	val = spfi_readl(spfi, SPFI_PORT_STATE);
 	val &= ~(SPFI_PORT_STATE_DEV_SEL_MASK <<
 		 SPFI_PORT_STATE_DEV_SEL_SHIFT);
-	val |= msg->spi->chip_select << SPFI_PORT_STATE_DEV_SEL_SHIFT;
+	val |= msg->spi->chip_select[0] << SPFI_PORT_STATE_DEV_SEL_SHIFT;
 	if (msg->spi->mode & SPI_CPHA)
-		val |= SPFI_PORT_STATE_CK_PHASE(msg->spi->chip_select);
+		val |= SPFI_PORT_STATE_CK_PHASE(msg->spi->chip_select[0]);
 	else
-		val &= ~SPFI_PORT_STATE_CK_PHASE(msg->spi->chip_select);
+		val &= ~SPFI_PORT_STATE_CK_PHASE(msg->spi->chip_select[0]);
 	if (msg->spi->mode & SPI_CPOL)
-		val |= SPFI_PORT_STATE_CK_POL(msg->spi->chip_select);
+		val |= SPFI_PORT_STATE_CK_POL(msg->spi->chip_select[0]);
 	else
-		val &= ~SPFI_PORT_STATE_CK_POL(msg->spi->chip_select);
+		val &= ~SPFI_PORT_STATE_CK_POL(msg->spi->chip_select[0]);
 	spfi_writel(spfi, val, SPFI_PORT_STATE);
 
 	return 0;
@@ -450,11 +450,11 @@ static void img_spfi_config(struct spi_master *master, struct spi_device *spi,
 	div = DIV_ROUND_UP(clk_get_rate(spfi->spfi_clk), xfer->speed_hz);
 	div = clamp(512 / (1 << get_count_order(div)), 1, 128);
 
-	val = spfi_readl(spfi, SPFI_DEVICE_PARAMETER(spi->chip_select));
+	val = spfi_readl(spfi, SPFI_DEVICE_PARAMETER(spi->chip_select[0]));
 	val &= ~(SPFI_DEVICE_PARAMETER_BITCLK_MASK <<
 		 SPFI_DEVICE_PARAMETER_BITCLK_SHIFT);
 	val |= div << SPFI_DEVICE_PARAMETER_BITCLK_SHIFT;
-	spfi_writel(spfi, val, SPFI_DEVICE_PARAMETER(spi->chip_select));
+	spfi_writel(spfi, val, SPFI_DEVICE_PARAMETER(spi->chip_select[0]));
 
 	spfi_writel(spfi, xfer->len << SPFI_TRANSACTION_TSIZE_SHIFT,
 		    SPFI_TRANSACTION);
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 30d82cc7300b..e82b059d9e01 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -535,7 +535,7 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 		ctrl |= MX51_ECSPI_CTRL_DRCTL(spi_imx->spi_drctl);
 
 	/* set chip select to use */
-	ctrl |= MX51_ECSPI_CTRL_CS(spi->chip_select);
+	ctrl |= MX51_ECSPI_CTRL_CS(spi->chip_select[0]);
 
 	/*
 	 * The ctrl register must be written first, with the EN bit set other
@@ -556,22 +556,22 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 	 * BURST_LENGTH + 1 bits are received
 	 */
 	if (spi_imx->slave_mode && is_imx53_ecspi(spi_imx))
-		cfg &= ~MX51_ECSPI_CONFIG_SBBCTRL(spi->chip_select);
+		cfg &= ~MX51_ECSPI_CONFIG_SBBCTRL(spi->chip_select[0]);
 	else
-		cfg |= MX51_ECSPI_CONFIG_SBBCTRL(spi->chip_select);
+		cfg |= MX51_ECSPI_CONFIG_SBBCTRL(spi->chip_select[0]);
 
 	if (spi->mode & SPI_CPOL) {
-		cfg |= MX51_ECSPI_CONFIG_SCLKPOL(spi->chip_select);
-		cfg |= MX51_ECSPI_CONFIG_SCLKCTL(spi->chip_select);
+		cfg |= MX51_ECSPI_CONFIG_SCLKPOL(spi->chip_select[0]);
+		cfg |= MX51_ECSPI_CONFIG_SCLKCTL(spi->chip_select[0]);
 	} else {
-		cfg &= ~MX51_ECSPI_CONFIG_SCLKPOL(spi->chip_select);
-		cfg &= ~MX51_ECSPI_CONFIG_SCLKCTL(spi->chip_select);
+		cfg &= ~MX51_ECSPI_CONFIG_SCLKPOL(spi->chip_select[0]);
+		cfg &= ~MX51_ECSPI_CONFIG_SCLKCTL(spi->chip_select[0]);
 	}
 
 	if (spi->mode & SPI_CS_HIGH)
-		cfg |= MX51_ECSPI_CONFIG_SSBPOL(spi->chip_select);
+		cfg |= MX51_ECSPI_CONFIG_SSBPOL(spi->chip_select[0]);
 	else
-		cfg &= ~MX51_ECSPI_CONFIG_SSBPOL(spi->chip_select);
+		cfg &= ~MX51_ECSPI_CONFIG_SSBPOL(spi->chip_select[0]);
 
 	if (cfg == current_cfg)
 		return 0;
@@ -621,9 +621,9 @@ static void mx51_configure_cpha(struct spi_imx_data *spi_imx,
 	cpha ^= flip_cpha;
 
 	if (cpha)
-		cfg |= MX51_ECSPI_CONFIG_SCLKPHA(spi->chip_select);
+		cfg |= MX51_ECSPI_CONFIG_SCLKPHA(spi->chip_select[0]);
 	else
-		cfg &= ~MX51_ECSPI_CONFIG_SCLKPHA(spi->chip_select);
+		cfg &= ~MX51_ECSPI_CONFIG_SCLKPHA(spi->chip_select[0]);
 
 	writel(cfg, spi_imx->base + MX51_ECSPI_CONFIG);
 }
@@ -775,8 +775,8 @@ static int mx31_prepare_transfer(struct spi_imx_data *spi_imx,
 		reg |= MX31_CSPICTRL_POL;
 	if (spi->mode & SPI_CS_HIGH)
 		reg |= MX31_CSPICTRL_SSPOL;
-	if (!spi->cs_gpiod)
-		reg |= (spi->chip_select) <<
+	if (!spi->cs_gpiod[0])
+		reg |= (spi->chip_select[0]) <<
 			(is_imx35_cspi(spi_imx) ? MX35_CSPICTRL_CS_SHIFT :
 						  MX31_CSPICTRL_CS_SHIFT);
 
@@ -875,8 +875,8 @@ static int mx21_prepare_transfer(struct spi_imx_data *spi_imx,
 		reg |= MX21_CSPICTRL_POL;
 	if (spi->mode & SPI_CS_HIGH)
 		reg |= MX21_CSPICTRL_SSPOL;
-	if (!spi->cs_gpiod)
-		reg |= spi->chip_select << MX21_CSPICTRL_CS_SHIFT;
+	if (!spi->cs_gpiod[0])
+		reg |= spi->chip_select[0] << MX21_CSPICTRL_CS_SHIFT;
 
 	writel(reg, spi_imx->base + MXC_CSPICTRL);
 
diff --git a/drivers/spi/spi-ingenic.c b/drivers/spi/spi-ingenic.c
index 713a238bee63..f327004b2f4a 100644
--- a/drivers/spi/spi-ingenic.c
+++ b/drivers/spi/spi-ingenic.c
@@ -263,7 +263,7 @@ static int spi_ingenic_prepare_message(struct spi_controller *ctlr,
 {
 	struct ingenic_spi *priv = spi_controller_get_devdata(ctlr);
 	struct spi_device *spi = message->spi;
-	unsigned int cs = REG_SSICR1_FRMHL << spi->chip_select;
+	unsigned int cs = REG_SSICR1_FRMHL << spi->chip_select[0];
 	unsigned int ssicr0_mask = REG_SSICR0_LOOP | REG_SSICR0_FSEL;
 	unsigned int ssicr1_mask = REG_SSICR1_PHA | REG_SSICR1_POL | cs;
 	unsigned int ssicr0 = 0, ssicr1 = 0;
@@ -282,7 +282,7 @@ static int spi_ingenic_prepare_message(struct spi_controller *ctlr,
 
 	if (spi->mode & SPI_LOOP)
 		ssicr0 |= REG_SSICR0_LOOP;
-	if (spi->chip_select)
+	if (spi->chip_select[0])
 		ssicr0 |= REG_SSICR0_FSEL;
 
 	if (spi->mode & SPI_CPHA)
diff --git a/drivers/spi/spi-jcore.c b/drivers/spi/spi-jcore.c
index 74c8319c29f1..370892a27ac4 100644
--- a/drivers/spi/spi-jcore.c
+++ b/drivers/spi/spi-jcore.c
@@ -68,9 +68,9 @@ static void jcore_spi_program(struct jcore_spi *hw)
 static void jcore_spi_chipsel(struct spi_device *spi, bool value)
 {
 	struct jcore_spi *hw = spi_master_get_devdata(spi->master);
-	u32 csbit = 1U << (2 * spi->chip_select);
+	u32 csbit = 1U << (2 * spi->chip_select[0]);
 
-	dev_dbg(hw->master->dev.parent, "chipselect %d\n", spi->chip_select);
+	dev_dbg(hw->master->dev.parent, "chipselect %d\n", spi->chip_select[0]);
 
 	if (value)
 		hw->cs_reg |= csbit;
diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 0c79193d9697..441f00d1d928 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -325,7 +325,7 @@ int spi_mem_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 	if (!spi_mem_internal_supports_op(mem, op))
 		return -ENOTSUPP;
 
-	if (ctlr->mem_ops && !mem->spi->cs_gpiod) {
+	if (ctlr->mem_ops && !mem->spi->cs_gpiod[0]) {
 		ret = spi_mem_access_start(mem);
 		if (ret)
 			return ret;
@@ -808,7 +808,7 @@ int spi_mem_poll_status(struct spi_mem *mem,
 	    op->data.dir != SPI_MEM_DATA_IN)
 		return -EINVAL;
 
-	if (ctlr->mem_ops && ctlr->mem_ops->poll_status && !mem->spi->cs_gpiod) {
+	if (ctlr->mem_ops && ctlr->mem_ops->poll_status && !mem->spi->cs_gpiod[0]) {
 		ret = spi_mem_access_start(mem);
 		if (ret)
 			return ret;
diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 0bc7daa7afc8..9136910c441c 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -456,7 +456,7 @@ static int meson_spicc_prepare_message(struct spi_master *master,
 		conf |= FIELD_PREP(SPICC_DRCTL_MASK, SPICC_DRCTL_IGNORE);
 
 	/* Select CS */
-	conf |= FIELD_PREP(SPICC_CS_MASK, spi->chip_select);
+	conf |= FIELD_PREP(SPICC_CS_MASK, spi->chip_select[0]);
 
 	/* Default Clock rate core/4 */
 
diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 03630359ce70..394c7e71a42c 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -127,13 +127,13 @@ static void mpc512x_psc_spi_activate_cs(struct spi_device *spi)
 	out_be32(psc_addr(mps, ccr), ccr);
 	mps->bits_per_word = cs->bits_per_word;
 
-	if (spi->cs_gpiod) {
+	if (spi->cs_gpiod[0]) {
 		if (mps->cs_control)
 			/* boardfile override */
 			mps->cs_control(spi, (spi->mode & SPI_CS_HIGH) ? 1 : 0);
 		else
 			/* gpiolib will deal with the inversion */
-			gpiod_set_value(spi->cs_gpiod, 1);
+			gpiod_set_value(spi->cs_gpiod[0], 1);
 	}
 }
 
@@ -141,13 +141,13 @@ static void mpc512x_psc_spi_deactivate_cs(struct spi_device *spi)
 {
 	struct mpc512x_psc_spi *mps = spi_master_get_devdata(spi->master);
 
-	if (spi->cs_gpiod) {
+	if (spi->cs_gpiod[0]) {
 		if (mps->cs_control)
 			/* boardfile override */
 			mps->cs_control(spi, (spi->mode & SPI_CS_HIGH) ? 0 : 1);
 		else
 			/* gpiolib will deal with the inversion */
-			gpiod_set_value(spi->cs_gpiod, 0);
+			gpiod_set_value(spi->cs_gpiod[0], 0);
 	}
 }
 
diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index bc5e36fd4288..f08edff14c7f 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -100,7 +100,7 @@ static void mpc52xx_spi_chipsel(struct mpc52xx_spi *ms, int value)
 	int cs;
 
 	if (ms->gpio_cs_count > 0) {
-		cs = ms->message->spi->chip_select;
+		cs = ms->message->spi->chip_select[0];
 		gpio_set_value(ms->gpio_cs[cs], value ? 0 : 1);
 	} else
 		out_8(ms->regs + SPI_PORTDATA, value ? 0 : 0x08);
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 0a3b9f7eed30..3facec1a03b3 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -421,7 +421,7 @@ static int mtk_spi_hw_init(struct spi_master *master,
 
 	/* pad select */
 	if (mdata->dev_comp->need_pad_sel)
-		writel(mdata->pad_sel[spi->chip_select],
+		writel(mdata->pad_sel[spi->chip_select[0]],
 		       mdata->base + SPI_PAD_SEL_REG);
 
 	/* tick delay */
@@ -732,9 +732,9 @@ static int mtk_spi_setup(struct spi_device *spi)
 	if (!spi->controller_data)
 		spi->controller_data = (void *)&mtk_default_chip_info;
 
-	if (mdata->dev_comp->need_pad_sel && spi->cs_gpiod)
+	if (mdata->dev_comp->need_pad_sel && spi->cs_gpiod[0])
 		/* CS de-asserted, gpiolib will handle inversion */
-		gpiod_direction_output(spi->cs_gpiod, 0);
+		gpiod_direction_output(spi->cs_gpiod[0], 0);
 
 	return 0;
 }
diff --git a/drivers/spi/spi-mt7621.c b/drivers/spi/spi-mt7621.c
index b4b9b7309b5e..a55011ea707e 100644
--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -77,7 +77,7 @@ static inline void mt7621_spi_write(struct mt7621_spi *rs, u32 reg, u32 val)
 static void mt7621_spi_set_cs(struct spi_device *spi, int enable)
 {
 	struct mt7621_spi *rs = spidev_to_mt7621_spi(spi);
-	int cs = spi->chip_select;
+	int cs = spi->chip_select[0];
 	u32 polar = 0;
 	u32 master;
 
diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index f5d32ec4634e..87c0375bd3ce 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -51,22 +51,22 @@ static int spi_mux_select(struct spi_device *spi)
 	struct spi_mux_priv *priv = spi_controller_get_devdata(spi->controller);
 	int ret;
 
-	ret = mux_control_select(priv->mux, spi->chip_select);
+	ret = mux_control_select(priv->mux, spi->chip_select[0]);
 	if (ret)
 		return ret;
 
-	if (priv->current_cs == spi->chip_select)
+	if (priv->current_cs == spi->chip_select[0])
 		return 0;
 
 	dev_dbg(&priv->spi->dev, "setting up the mux for cs %d\n",
-		spi->chip_select);
+		spi->chip_select[0]);
 
 	/* copy the child device's settings except for the cs */
 	priv->spi->max_speed_hz = spi->max_speed_hz;
 	priv->spi->mode = spi->mode;
 	priv->spi->bits_per_word = spi->bits_per_word;
 
-	priv->current_cs = spi->chip_select;
+	priv->current_cs = spi->chip_select[0];
 
 	return 0;
 }
diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 55178579f3c6..41f4fb38cf96 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -369,7 +369,7 @@ static int mxs_spi_transfer_one(struct spi_master *master,
 	/* Program CS register bits here, it will be used for all transfers. */
 	writel(BM_SSP_CTRL0_WAIT_FOR_CMD | BM_SSP_CTRL0_WAIT_FOR_IRQ,
 	       ssp->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_CLR);
-	writel(mxs_spi_cs_to_reg(m->spi->chip_select),
+	writel(mxs_spi_cs_to_reg(m->spi->chip_select[0]),
 	       ssp->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_SET);
 
 	list_for_each_entry(t, &m->transfers, transfer_list) {
diff --git a/drivers/spi/spi-npcm-fiu.c b/drivers/spi/spi-npcm-fiu.c
index 49f6424e35af..2d60f13b6880 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -288,7 +288,7 @@ static ssize_t npcm_fiu_direct_read(struct spi_mem_dirmap_desc *desc,
 {
 	struct npcm_fiu_spi *fiu =
 		spi_controller_get_devdata(desc->mem->spi->master);
-	struct npcm_fiu_chip *chip = &fiu->chip[desc->mem->spi->chip_select];
+	struct npcm_fiu_chip *chip = &fiu->chip[desc->mem->spi->chip_select[0]];
 	void __iomem *src = (void __iomem *)(chip->flash_region_mapped_ptr +
 					     offs);
 	u8 *buf_rx = buf;
@@ -315,7 +315,7 @@ static ssize_t npcm_fiu_direct_write(struct spi_mem_dirmap_desc *desc,
 {
 	struct npcm_fiu_spi *fiu =
 		spi_controller_get_devdata(desc->mem->spi->master);
-	struct npcm_fiu_chip *chip = &fiu->chip[desc->mem->spi->chip_select];
+	struct npcm_fiu_chip *chip = &fiu->chip[desc->mem->spi->chip_select[0]];
 	void __iomem *dst = (void __iomem *)(chip->flash_region_mapped_ptr +
 					     offs);
 	const u8 *buf_tx = buf;
@@ -344,7 +344,7 @@ static int npcm_fiu_uma_read(struct spi_mem *mem,
 
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
-			   (mem->spi->chip_select <<
+			   (mem->spi->chip_select[0] <<
 			    NPCM_FIU_UMA_CTS_DEV_NUM_SHIFT));
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CMD,
 			   NPCM_FIU_UMA_CMD_CMD, op->cmd.opcode);
@@ -398,7 +398,7 @@ static int npcm_fiu_uma_write(struct spi_mem *mem,
 
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
-			   (mem->spi->chip_select <<
+			   (mem->spi->chip_select[0] <<
 			    NPCM_FIU_UMA_CTS_DEV_NUM_SHIFT));
 
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CMD,
@@ -451,7 +451,7 @@ static int npcm_fiu_manualwrite(struct spi_mem *mem,
 
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
-			   (mem->spi->chip_select <<
+			   (mem->spi->chip_select[0] <<
 			    NPCM_FIU_UMA_CTS_DEV_NUM_SHIFT));
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_SW_CS, 0);
@@ -545,7 +545,7 @@ static int npcm_fiu_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
 	struct npcm_fiu_spi *fiu =
 		spi_controller_get_devdata(mem->spi->master);
-	struct npcm_fiu_chip *chip = &fiu->chip[mem->spi->chip_select];
+	struct npcm_fiu_chip *chip = &fiu->chip[mem->spi->chip_select[0]];
 	int ret = 0;
 	u8 *buf;
 
@@ -605,7 +605,7 @@ static int npcm_fiu_dirmap_create(struct spi_mem_dirmap_desc *desc)
 {
 	struct npcm_fiu_spi *fiu =
 		spi_controller_get_devdata(desc->mem->spi->master);
-	struct npcm_fiu_chip *chip = &fiu->chip[desc->mem->spi->chip_select];
+	struct npcm_fiu_chip *chip = &fiu->chip[desc->mem->spi->chip_select[0]];
 	struct regmap *gcr_regmap;
 
 	if (!fiu->res_mem) {
@@ -624,7 +624,7 @@ static int npcm_fiu_dirmap_create(struct spi_mem_dirmap_desc *desc)
 		chip->flash_region_mapped_ptr =
 			devm_ioremap(fiu->dev, (fiu->res_mem->start +
 							(fiu->info->max_map_size *
-						    desc->mem->spi->chip_select)),
+						    desc->mem->spi->chip_select[0])),
 					     (u32)desc->info.length);
 		if (!chip->flash_region_mapped_ptr) {
 			dev_warn(fiu->dev, "Error mapping memory region, direct read disabled\n");
@@ -669,9 +669,9 @@ static int npcm_fiu_setup(struct spi_device *spi)
 	struct npcm_fiu_spi *fiu = spi_controller_get_devdata(ctrl);
 	struct npcm_fiu_chip *chip;
 
-	chip = &fiu->chip[spi->chip_select];
+	chip = &fiu->chip[spi->chip_select[0]];
 	chip->fiu = fiu;
-	chip->chipselect = spi->chip_select;
+	chip->chipselect = spi->chip_select[0];
 	chip->clkrate = spi->max_speed_hz;
 
 	fiu->clkrate = clk_get_rate(fiu->clk);
diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 2b0301fc971c..8a182aa78b83 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -663,7 +663,7 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi)
 	 * Return, if previously selected slave device is same as current
 	 * requested slave device.
 	 */
-	if (f->selected == spi->chip_select)
+	if (f->selected == spi->chip_select[0])
 		return;
 
 	/* Reset FLSHxxCR0 registers */
@@ -676,9 +676,9 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi)
 	size_kb = FSPI_FLSHXCR0_SZ(f->memmap_phy_size);
 
 	fspi_writel(f, size_kb, f->iobase + FSPI_FLSHA1CR0 +
-		    4 * spi->chip_select);
+		    4 * spi->chip_select[0]);
 
-	dev_dbg(f->dev, "Slave device [CS:%x] selected\n", spi->chip_select);
+	dev_dbg(f->dev, "Slave device [CS:%x] selected\n", spi->chip_select[0]);
 
 	nxp_fspi_clk_disable_unprep(f);
 
@@ -690,7 +690,7 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi)
 	if (ret)
 		return;
 
-	f->selected = spi->chip_select;
+	f->selected = spi->chip_select[0];
 }
 
 static int nxp_fspi_read_ahb(struct nxp_fspi *f, const struct spi_mem_op *op)
@@ -1055,7 +1055,7 @@ static const char *nxp_fspi_get_name(struct spi_mem *mem)
 
 	name = devm_kasprintf(dev, GFP_KERNEL,
 			      "%s-%d", dev_name(f->dev),
-			      mem->spi->chip_select);
+			      mem->spi->chip_select[0]);
 
 	if (!name) {
 		dev_err(dev, "failed to get memory for custom flash name\n");
diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 20b047172965..731563c98ac6 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -268,7 +268,7 @@ static int omap1_spi100k_setup(struct spi_device *spi)
 		cs = devm_kzalloc(&spi->dev, sizeof(*cs), GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
-		cs->base = spi100k->base + spi->chip_select * 0x14;
+		cs->base = spi100k->base + spi->chip_select[0] * 0x14;
 		spi->controller_state = cs;
 	}
 
diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 29198e6815b2..865e65cfa633 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -179,7 +179,7 @@ static void uwire_chipselect(struct spi_device *spi, int value)
 
 	w = uwire_read_reg(UWIRE_CSR);
 	old_cs = (w >> 10) & 0x03;
-	if (value == BITBANG_CS_INACTIVE || old_cs != spi->chip_select) {
+	if (value == BITBANG_CS_INACTIVE || old_cs != spi->chip_select[0]) {
 		/* Deselect this CS, or the previous CS */
 		w &= ~CS_CMD;
 		uwire_write_reg(UWIRE_CSR, w);
@@ -193,7 +193,7 @@ static void uwire_chipselect(struct spi_device *spi, int value)
 		else
 			uwire_write_reg(UWIRE_SR4, 0);
 
-		w = spi->chip_select << 10;
+		w = spi->chip_select[0] << 10;
 		w |= CS_CMD;
 		uwire_write_reg(UWIRE_CSR, w);
 	}
@@ -210,7 +210,7 @@ static int uwire_txrx(struct spi_device *spi, struct spi_transfer *t)
 	if (!t->tx_buf && !t->rx_buf)
 		return 0;
 
-	w = spi->chip_select << 10;
+	w = spi->chip_select[0] << 10;
 	w |= CS_CMD;
 
 	if (t->tx_buf) {
@@ -408,7 +408,7 @@ static int uwire_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 		rate /= 8;
 		break;
 	}
-	omap_uwire_configure_mode(spi->chip_select, flags);
+	omap_uwire_configure_mode(spi->chip_select[0], flags);
 	pr_debug("%s: uwire flags %02x, armxor %lu KHz, SCK %lu KHz\n",
 			__func__, flags,
 			clk_get_rate(uwire->ck) / 1000,
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index c42e59df38fe..6fdd7f446341 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -379,7 +379,7 @@ static void omap2_mcspi_rx_callback(void *data)
 {
 	struct spi_device *spi = data;
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
-	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select];
+	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select[0]];
 
 	/* We must disable the DMA RX request */
 	omap2_mcspi_set_dma_req(spi, 1, 0);
@@ -391,7 +391,7 @@ static void omap2_mcspi_tx_callback(void *data)
 {
 	struct spi_device *spi = data;
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
-	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select];
+	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select[0]];
 
 	/* We must disable the DMA TX request */
 	omap2_mcspi_set_dma_req(spi, 0, 0);
@@ -408,7 +408,7 @@ static void omap2_mcspi_tx_dma(struct spi_device *spi,
 	struct dma_async_tx_descriptor *tx;
 
 	mcspi = spi_master_get_devdata(spi->master);
-	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
+	mcspi_dma = &mcspi->dma_channels[spi->chip_select[0]];
 
 	dmaengine_slave_config(mcspi_dma->dma_tx, &cfg);
 
@@ -446,7 +446,7 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	struct dma_async_tx_descriptor *tx;
 
 	mcspi = spi_master_get_devdata(spi->master);
-	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
+	mcspi_dma = &mcspi->dma_channels[spi->chip_select[0]];
 	count = xfer->len;
 
 	/*
@@ -591,7 +591,7 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 	int			wait_res;
 
 	mcspi = spi_master_get_devdata(spi->master);
-	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
+	mcspi_dma = &mcspi->dma_channels[spi->chip_select[0]];
 
 	if (cs->word_len <= 8) {
 		width = DMA_SLAVE_BUSWIDTH_1_BYTE;
@@ -1062,8 +1062,8 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 		cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
-		cs->base = mcspi->base + spi->chip_select * 0x14;
-		cs->phys = mcspi->phys + spi->chip_select * 0x14;
+		cs->base = mcspi->base + spi->chip_select[0] * 0x14;
+		cs->phys = mcspi->phys + spi->chip_select[0] * 0x14;
 		cs->mode = 0;
 		cs->chconf0 = 0;
 		cs->chctrl0 = 0;
@@ -1142,7 +1142,7 @@ static int omap2_mcspi_transfer_one(struct spi_master *master,
 	u32				chconf;
 
 	mcspi = spi_master_get_devdata(master);
-	mcspi_dma = mcspi->dma_channels + spi->chip_select;
+	mcspi_dma = mcspi->dma_channels + spi->chip_select[0];
 	cs = spi->controller_state;
 	cd = spi->controller_data;
 
@@ -1158,7 +1158,7 @@ static int omap2_mcspi_transfer_one(struct spi_master *master,
 
 	omap2_mcspi_set_enable(spi, 0);
 
-	if (spi->cs_gpiod)
+	if (spi->cs_gpiod[0])
 		omap2_mcspi_set_cs(spi, spi->mode & SPI_CS_HIGH);
 
 	if (par_override ||
@@ -1247,7 +1247,7 @@ static int omap2_mcspi_transfer_one(struct spi_master *master,
 
 	omap2_mcspi_set_enable(spi, 0);
 
-	if (spi->cs_gpiod)
+	if (spi->cs_gpiod[0])
 		omap2_mcspi_set_cs(spi, !(spi->mode & SPI_CS_HIGH));
 
 	if (mcspi->fifo_depth > 0 && t)
@@ -1289,7 +1289,7 @@ static bool omap2_mcspi_can_dma(struct spi_master *master,
 {
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
 	struct omap2_mcspi_dma *mcspi_dma =
-		&mcspi->dma_channels[spi->chip_select];
+		&mcspi->dma_channels[spi->chip_select[0]];
 
 	if (!mcspi_dma->dma_rx || !mcspi_dma->dma_tx)
 		return false;
@@ -1307,7 +1307,7 @@ static size_t omap2_mcspi_max_xfer_size(struct spi_device *spi)
 {
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
 	struct omap2_mcspi_dma *mcspi_dma =
-		&mcspi->dma_channels[spi->chip_select];
+		&mcspi->dma_channels[spi->chip_select[0]];
 
 	if (mcspi->max_xfer_len && mcspi_dma->dma_rx)
 		return mcspi->max_xfer_len;
diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index 565cd4c48d7b..f2eb2283083a 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -346,7 +346,7 @@ static void orion_spi_set_cs(struct spi_device *spi, bool enable)
 	 * as it is handled by a GPIO, but that doesn't matter. What we need
 	 * is to deassert the old chip select and assert some other chip select.
 	 */
-	val |= ORION_SPI_CS(spi->chip_select);
+	val |= ORION_SPI_CS(spi->chip_select[0]);
 
 	/*
 	 * Chip select logic is inverted from spi_set_cs(). For lines using a
@@ -470,7 +470,7 @@ orion_spi_write_read(struct spi_device *spi, struct spi_transfer *xfer)
 	unsigned int count;
 	int word_len;
 	struct orion_spi *orion_spi;
-	int cs = spi->chip_select;
+	int cs = spi->chip_select[0];
 	void __iomem *vaddr;
 
 	word_len = spi->bits_per_word;
diff --git a/drivers/spi/spi-pic32-sqi.c b/drivers/spi/spi-pic32-sqi.c
index 86ad17597f5f..1432f03d1bc1 100644
--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -267,7 +267,7 @@ static int pic32_sqi_one_transfer(struct pic32_sqi *sqi,
 	u32 nbits;
 
 	/* Device selection */
-	bd_ctrl = spi->chip_select << BD_DEVSEL_SHIFT;
+	bd_ctrl = spi->chip_select[0] << BD_DEVSEL_SHIFT;
 
 	/* half-duplex: select transfer buffer, direction and lane */
 	if (xfer->rx_buf) {
diff --git a/drivers/spi/spi-pic32.c b/drivers/spi/spi-pic32.c
index 7e5c09a7d489..052b29f9f173 100644
--- a/drivers/spi/spi-pic32.c
+++ b/drivers/spi/spi-pic32.c
@@ -591,7 +591,7 @@ static int pic32_spi_setup(struct spi_device *spi)
 	 * unreliable/erroneous SPI transactions.
 	 * To avoid that we will always handle /CS by toggling GPIO.
 	 */
-	if (!spi->cs_gpiod)
+	if (!spi->cs_gpiod[0])
 		return -EINVAL;
 
 	return 0;
@@ -600,7 +600,7 @@ static int pic32_spi_setup(struct spi_device *spi)
 static void pic32_spi_cleanup(struct spi_device *spi)
 {
 	/* de-activate cs-gpio, gpiolib will handle inversion */
-	gpiod_direction_output(spi->cs_gpiod, 0);
+	gpiod_direction_output(spi->cs_gpiod[0], 0);
 }
 
 static int pic32_spi_dma_prep(struct pic32_spi *pic32s, struct device *dev)
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index e4484ace584e..0c876e2210d7 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1587,7 +1587,7 @@ static int pl022_transfer_one_message(struct spi_master *master,
 
 	/* Setup the SPI using the per chip configuration */
 	pl022->cur_chip = spi_get_ctldata(msg->spi);
-	pl022->cur_cs = msg->spi->chip_select;
+	pl022->cur_cs = msg->spi->chip_select[0];
 	/* This is always available but may be set to -ENOENT */
 	pl022->cur_gpiod = msg->spi->cs_gpiod;
 
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 838d12e65144..57840e8ee1b7 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -369,7 +369,7 @@ static void lpss_ssp_select_cs(struct spi_device *spi,
 
 	value = __lpss_ssp_read_priv(drv_data, config->reg_cs_ctrl);
 
-	cs = spi->chip_select;
+	cs = spi->chip_select[0];
 	cs <<= config->cs_sel_shift;
 	if (cs != (value & config->cs_sel_mask)) {
 		/*
@@ -430,7 +430,7 @@ static void cs_assert(struct spi_device *spi)
 		spi_controller_get_devdata(spi->controller);
 
 	if (drv_data->ssp_type == CE4100_SSP) {
-		pxa2xx_spi_write(drv_data, SSSR, spi->chip_select);
+		pxa2xx_spi_write(drv_data, SSSR, spi->chip_select[0]);
 		return;
 	}
 
@@ -1218,7 +1218,7 @@ static int setup(struct spi_device *spi)
 			return -ENOMEM;
 
 		if (drv_data->ssp_type == CE4100_SSP) {
-			if (spi->chip_select > 4) {
+			if (spi->chip_select[0] > 4) {
 				dev_err(&spi->dev,
 					"failed setup: cs number must not be > 4.\n");
 				kfree(chip);
diff --git a/drivers/spi/spi-qcom-qspi.c b/drivers/spi/spi-qcom-qspi.c
index c334dfec4117..684b066a793b 100644
--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -311,7 +311,7 @@ static int qcom_qspi_prepare_message(struct spi_master *master,
 
 	mstr_cfg = readl(ctrl->base + MSTR_CONFIG);
 	mstr_cfg &= ~CHIP_SELECT_NUM;
-	if (message->spi->chip_select)
+	if (message->spi->chip_select[0])
 		mstr_cfg |= CHIP_SELECT_NUM;
 
 	mstr_cfg |= FB_CLK_EN | PIN_WPN | PIN_HOLDN | SBL_EN | FULL_CYCLE_MODE;
diff --git a/drivers/spi/spi-rb4xx.c b/drivers/spi/spi-rb4xx.c
index 9f97d18a05c1..15ba4de19ea1 100644
--- a/drivers/spi/spi-rb4xx.c
+++ b/drivers/spi/spi-rb4xx.c
@@ -107,7 +107,7 @@ static int rb4xx_transfer_one(struct spi_master *master,
 	 * command set was designed to almost not clash with that of the
 	 * boot flash.
 	 */
-	if (spi->chip_select == 2)
+	if (spi->chip_select[0] == 2)
 		/* MMC */
 		spi_ioc = AR71XX_SPI_IOC_CS0;
 	else
diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index bd87d3c92dd3..6cd8a9565887 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -346,7 +346,7 @@ static int rockchip_sfc_xfer_setup(struct rockchip_sfc *sfc,
 
 	/* set the Controller */
 	ctrl |= SFC_CTRL_PHASE_SEL_NEGETIVE;
-	cmd |= mem->spi->chip_select << SFC_CMD_CS_SHIFT;
+	cmd |= mem->spi->chip_select[0] << SFC_CMD_CS_SHIFT;
 
 	dev_dbg(sfc->dev, "sfc addr.nbytes=%x(x%d) dummy.nbytes=%x(x%d)\n",
 		op->addr.nbytes, op->addr.buswidth,
diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 79242dc5272d..851b71f9fbf3 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -246,28 +246,32 @@ static void rockchip_spi_set_cs(struct spi_device *spi, bool enable)
 	bool cs_asserted = spi->mode & SPI_CS_HIGH ? enable : !enable;
 
 	/* Return immediately for no-op */
-	if (cs_asserted == rs->cs_asserted[spi->chip_select])
+	if (cs_asserted == rs->cs_asserted[spi->chip_select[0]])
 		return;
 
 	if (cs_asserted) {
 		/* Keep things powered as long as CS is asserted */
 		pm_runtime_get_sync(rs->dev);
 
-		if (spi->cs_gpiod)
+		if (spi->cs_gpiod[0])
 			ROCKCHIP_SPI_SET_BITS(rs->regs + ROCKCHIP_SPI_SER, 1);
 		else
-			ROCKCHIP_SPI_SET_BITS(rs->regs + ROCKCHIP_SPI_SER, BIT(spi->chip_select));
+			ROCKCHIP_SPI_SET_BITS(rs->regs +
+					      ROCKCHIP_SPI_SER,
+					      BIT(spi->chip_select[0]));
 	} else {
-		if (spi->cs_gpiod)
+		if (spi->cs_gpiod[0])
 			ROCKCHIP_SPI_CLR_BITS(rs->regs + ROCKCHIP_SPI_SER, 1);
 		else
-			ROCKCHIP_SPI_CLR_BITS(rs->regs + ROCKCHIP_SPI_SER, BIT(spi->chip_select));
+			ROCKCHIP_SPI_CLR_BITS(rs->regs +
+					      ROCKCHIP_SPI_SER,
+					      BIT(spi->chip_select[0]));
 
 		/* Drop reference from when we first asserted CS */
 		pm_runtime_put(rs->dev);
 	}
 
-	rs->cs_asserted[spi->chip_select] = cs_asserted;
+	rs->cs_asserted[spi->chip_select[0]] = cs_asserted;
 }
 
 static void rockchip_spi_handle_err(struct spi_controller *ctlr,
@@ -541,7 +545,7 @@ static int rockchip_spi_config(struct rockchip_spi *rs,
 	if (spi->mode & SPI_LSB_FIRST)
 		cr0 |= CR0_FBM_LSB << CR0_FBM_OFFSET;
 	if (spi->mode & SPI_CS_HIGH)
-		cr0 |= BIT(spi->chip_select) << CR0_SOI_OFFSET;
+		cr0 |= BIT(spi->chip_select[0]) << CR0_SOI_OFFSET;
 
 	if (xfer->rx_buf && xfer->tx_buf)
 		cr0 |= CR0_XFM_TR << CR0_XFM_OFFSET;
@@ -724,7 +728,7 @@ static int rockchip_spi_setup(struct spi_device *spi)
 	struct rockchip_spi *rs = spi_controller_get_devdata(spi->controller);
 	u32 cr0;
 
-	if (!spi->cs_gpiod && (spi->mode & SPI_CS_HIGH) && !rs->cs_high_supported) {
+	if (!spi->cs_gpiod[0] && (spi->mode & SPI_CS_HIGH) && !rs->cs_high_supported) {
 		dev_warn(&spi->dev, "setup: non GPIO CS can't be active-high\n");
 		return -EINVAL;
 	}
@@ -735,10 +739,10 @@ static int rockchip_spi_setup(struct spi_device *spi)
 
 	cr0 &= ~(0x3 << CR0_SCPH_OFFSET);
 	cr0 |= ((spi->mode & 0x3) << CR0_SCPH_OFFSET);
-	if (spi->mode & SPI_CS_HIGH && spi->chip_select <= 1)
-		cr0 |= BIT(spi->chip_select) << CR0_SOI_OFFSET;
-	else if (spi->chip_select <= 1)
-		cr0 &= ~(BIT(spi->chip_select) << CR0_SOI_OFFSET);
+	if (spi->mode & SPI_CS_HIGH && spi->chip_select[0] <= 1)
+		cr0 |= BIT(spi->chip_select[0]) << CR0_SOI_OFFSET;
+	else if (spi->chip_select[0] <= 1)
+		cr0 &= ~(BIT(spi->chip_select[0]) << CR0_SOI_OFFSET);
 
 	writel_relaxed(cr0, rs->regs + ROCKCHIP_SPI_CTRLR0);
 
diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 411b1307b7fd..9d56d32316a2 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -950,7 +950,7 @@ static int rspi_setup(struct spi_device *spi)
 	struct rspi_data *rspi = spi_controller_get_devdata(spi->controller);
 	u8 sslp;
 
-	if (spi->cs_gpiod)
+	if (spi->cs_gpiod[0])
 		return 0;
 
 	pm_runtime_get_sync(&rspi->pdev->dev);
@@ -958,9 +958,9 @@ static int rspi_setup(struct spi_device *spi)
 
 	sslp = rspi_read8(rspi, RSPI_SSLP);
 	if (spi->mode & SPI_CS_HIGH)
-		sslp |= SSLP_SSLP(spi->chip_select);
+		sslp |= SSLP_SSLP(spi->chip_select[0]);
 	else
-		sslp &= ~SSLP_SSLP(spi->chip_select);
+		sslp &= ~SSLP_SSLP(spi->chip_select[0]);
 	rspi_write8(rspi, sslp, RSPI_SSLP);
 
 	spin_unlock_irq(&rspi->lock);
@@ -1001,8 +1001,8 @@ static int rspi_prepare_message(struct spi_controller *ctlr,
 		rspi->spcmd |= SPCMD_LSBF;
 
 	/* Configure slave signal to assert */
-	rspi->spcmd |= SPCMD_SSLA(spi->cs_gpiod ? rspi->ctlr->unused_native_cs
-						: spi->chip_select);
+	rspi->spcmd |= SPCMD_SSLA(spi->cs_gpiod[0] ? rspi->ctlr->unused_native_cs
+						: spi->chip_select[0]);
 
 	/* CMOS output mode and MOSI signal from previous transfer */
 	rspi->sppcr = 0;
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 7f346866614a..8bcec7f1a88f 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -883,7 +883,7 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 
 	/* NULL is fine, we just avoid using the FB delay (=0) */
 	if (IS_ERR(cs)) {
-		dev_err(&spi->dev, "No CS for SPI(%d)\n", spi->chip_select);
+		dev_err(&spi->dev, "No CS for SPI(%d)\n", spi->chip_select[0]);
 		return -ENODEV;
 	}
 
diff --git a/drivers/spi/spi-sc18is602.c b/drivers/spi/spi-sc18is602.c
index 5d27ee482237..a8ef33b2aa5d 100644
--- a/drivers/spi/spi-sc18is602.c
+++ b/drivers/spi/spi-sc18is602.c
@@ -70,7 +70,7 @@ static int sc18is602_txrx(struct sc18is602 *hw, struct spi_message *msg,
 
 	if (hw->tlen == 0) {
 		/* First byte (I2C command) is chip select */
-		hw->buffer[0] = 1 << msg->spi->chip_select;
+		hw->buffer[0] = 1 << msg->spi->chip_select[0];
 		hw->tlen = 1;
 		hw->rindex = 0;
 	}
@@ -229,7 +229,7 @@ static int sc18is602_setup(struct spi_device *spi)
 	struct sc18is602 *hw = spi_master_get_devdata(spi->master);
 
 	/* SC18IS602 does not support CS2 */
-	if (hw->id == sc18is602 && spi->chip_select == 2)
+	if (hw->id == sc18is602 && spi->chip_select[0] == 2)
 		return -ENXIO;
 
 	return 0;
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index d0012b30410c..6c869cd49149 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -554,7 +554,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 		spi_controller_get_devdata(spi->controller);
 	u32 clr, set, tmp;
 
-	if (spi->cs_gpiod || spi_controller_is_slave(p->ctlr))
+	if (spi->cs_gpiod[0] || spi_controller_is_slave(p->ctlr))
 		return 0;
 
 	if (p->native_cs_inited &&
@@ -587,11 +587,11 @@ static int sh_msiof_prepare_message(struct spi_controller *ctlr,
 	u32 ss, cs_high;
 
 	/* Configure pins before asserting CS */
-	if (spi->cs_gpiod) {
+	if (spi->cs_gpiod[0]) {
 		ss = ctlr->unused_native_cs;
 		cs_high = p->native_cs_high;
 	} else {
-		ss = spi->chip_select;
+		ss = spi->chip_select[0];
 		cs_high = !!(spi->mode & SPI_CS_HIGH);
 	}
 	sh_msiof_spi_set_pin_regs(p, ss, !!(spi->mode & SPI_CPOL),
diff --git a/drivers/spi/spi-st-ssc4.c b/drivers/spi/spi-st-ssc4.c
index 843be803696b..b441613e9211 100644
--- a/drivers/spi/spi-st-ssc4.c
+++ b/drivers/spi/spi-st-ssc4.c
@@ -183,7 +183,7 @@ static int spi_st_setup(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	if (!spi->cs_gpiod) {
+	if (!spi->cs_gpiod[0]) {
 		dev_err(&spi->dev, "no valid gpio assigned\n");
 		return -EINVAL;
 	}
diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index f3fe92300639..de1d467f2f7e 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -358,7 +358,7 @@ static int stm32_qspi_get_mode(u8 buswidth)
 static int stm32_qspi_send(struct spi_mem *mem, const struct spi_mem_op *op)
 {
 	struct stm32_qspi *qspi = spi_controller_get_devdata(mem->spi->master);
-	struct stm32_qspi_flash *flash = &qspi->flash[mem->spi->chip_select];
+	struct stm32_qspi_flash *flash = &qspi->flash[mem->spi->chip_select[0]];
 	u32 ccr, cr;
 	int timeout, err = 0, err_poll_status = 0;
 
@@ -574,8 +574,8 @@ static int stm32_qspi_setup(struct spi_device *spi)
 
 	presc = DIV_ROUND_UP(qspi->clk_rate, spi->max_speed_hz) - 1;
 
-	flash = &qspi->flash[spi->chip_select];
-	flash->cs = spi->chip_select;
+	flash = &qspi->flash[spi->chip_select[0]];
+	flash->cs = spi->chip_select[0];
 	flash->presc = presc;
 
 	mutex_lock(&qspi->lock);
diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 6000d0761206..778071273dce 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -167,7 +167,7 @@ static void sun4i_spi_set_cs(struct spi_device *spi, bool enable)
 	reg = sun4i_spi_read(sspi, SUN4I_CTL_REG);
 
 	reg &= ~SUN4I_CTL_CS_MASK;
-	reg |= SUN4I_CTL_CS(spi->chip_select);
+	reg |= SUN4I_CTL_CS(spi->chip_select[0]);
 
 	/* We want to control the chip select manually */
 	reg |= SUN4I_CTL_CS_MANUAL;
diff --git a/drivers/spi/spi-sun6i.c b/drivers/spi/spi-sun6i.c
index 23ad052528db..67e04fc3b17e 100644
--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -174,7 +174,7 @@ static void sun6i_spi_set_cs(struct spi_device *spi, bool enable)
 
 	reg = sun6i_spi_read(sspi, SUN6I_TFR_CTL_REG);
 	reg &= ~SUN6I_TFR_CTL_CS_MASK;
-	reg |= SUN6I_TFR_CTL_CS(spi->chip_select);
+	reg |= SUN6I_TFR_CTL_CS(spi->chip_select[0]);
 
 	if (enable)
 		reg |= SUN6I_TFR_CTL_CS_LEVEL;
diff --git a/drivers/spi/spi-synquacer.c b/drivers/spi/spi-synquacer.c
index 47cbe73137c2..fe434d278a70 100644
--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -250,7 +250,7 @@ static int synquacer_spi_config(struct spi_master *master,
 	}
 
 	mode = spi->mode;
-	cs = spi->chip_select;
+	cs = spi->chip_select[0];
 	speed = xfer->speed_hz;
 	bpw = xfer->bits_per_word;
 
@@ -344,7 +344,7 @@ static int synquacer_spi_config(struct spi_master *master,
 	sspi->bpw = bpw;
 	sspi->mode = mode;
 	sspi->speed = speed;
-	sspi->cs = spi->chip_select;
+	sspi->cs = spi->chip_select[0];
 	sspi->bus_width = bus_width;
 
 	return 0;
@@ -489,7 +489,7 @@ static void synquacer_spi_set_cs(struct spi_device *spi, bool enable)
 	val = readl(sspi->regs + SYNQUACER_HSSPI_REG_DMSTART);
 	val &= ~(SYNQUACER_HSSPI_DMPSEL_CS_MASK <<
 		 SYNQUACER_HSSPI_DMPSEL_CS_SHIFT);
-	val |= spi->chip_select << SYNQUACER_HSSPI_DMPSEL_CS_SHIFT;
+	val |= spi->chip_select[0] << SYNQUACER_HSSPI_DMPSEL_CS_SHIFT;
 
 	if (!enable)
 		val |= SYNQUACER_HSSPI_DMSTOP_STOP;
diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index d9be80e3e1bc..7e4f7d5a950c 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -747,7 +747,7 @@ static int tegra_spi_set_hw_cs_timing(struct spi_device *spi)
 	if (setup_dly && hold_dly) {
 		setup_hold = SPI_SETUP_HOLD(setup_dly - 1, hold_dly - 1);
 		spi_cs_timing = SPI_CS_SETUP_HOLD(tspi->spi_cs_timing1,
-						  spi->chip_select,
+						  spi->chip_select[0],
 						  setup_hold);
 		if (tspi->spi_cs_timing1 != spi_cs_timing) {
 			tspi->spi_cs_timing1 = spi_cs_timing;
@@ -760,9 +760,9 @@ static int tegra_spi_set_hw_cs_timing(struct spi_device *spi)
 		inactive_cycles--;
 	cs_state = inactive_cycles ? 0 : 1;
 	spi_cs_timing = tspi->spi_cs_timing2;
-	SPI_SET_CS_ACTIVE_BETWEEN_PACKETS(spi_cs_timing, spi->chip_select,
+	SPI_SET_CS_ACTIVE_BETWEEN_PACKETS(spi_cs_timing, spi->chip_select[0],
 					  cs_state);
-	SPI_SET_CYCLES_BETWEEN_PACKETS(spi_cs_timing, spi->chip_select,
+	SPI_SET_CYCLES_BETWEEN_PACKETS(spi_cs_timing, spi->chip_select[0],
 				       inactive_cycles);
 	if (tspi->spi_cs_timing2 != spi_cs_timing) {
 		tspi->spi_cs_timing2 = spi_cs_timing;
@@ -831,8 +831,8 @@ static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
 			tegra_spi_writel(tspi, command1, SPI_COMMAND1);
 
 		/* GPIO based chip select control */
-		if (spi->cs_gpiod)
-			gpiod_set_value(spi->cs_gpiod, 1);
+		if (spi->cs_gpiod[0])
+			gpiod_set_value(spi->cs_gpiod[0], 1);
 
 		if (is_single_xfer && !(t->cs_change)) {
 			tspi->use_hw_based_cs = true;
@@ -846,7 +846,7 @@ static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
 				command1 &= ~SPI_CS_SW_VAL;
 		}
 
-		if (tspi->last_used_cs != spi->chip_select) {
+		if (tspi->last_used_cs != spi->chip_select[0]) {
 			if (cdata && cdata->tx_clk_tap_delay)
 				tx_tap = cdata->tx_clk_tap_delay;
 			if (cdata && cdata->rx_clk_tap_delay)
@@ -855,7 +855,7 @@ static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
 				   SPI_RX_TAP_DELAY(rx_tap);
 			if (command2 != tspi->def_command2_reg)
 				tegra_spi_writel(tspi, command2, SPI_COMMAND2);
-			tspi->last_used_cs = spi->chip_select;
+			tspi->last_used_cs = spi->chip_select[0];
 		}
 
 	} else {
@@ -896,7 +896,7 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 		command1 |= SPI_TX_EN;
 		tspi->cur_direction |= DATA_DIR_TX;
 	}
-	command1 |= SPI_CS_SEL(spi->chip_select);
+	command1 |= SPI_CS_SEL(spi->chip_select[0]);
 	tegra_spi_writel(tspi, command1, SPI_COMMAND1);
 	tspi->command1_reg = command1;
 
@@ -980,14 +980,14 @@ static int tegra_spi_setup(struct spi_device *spi)
 
 	spin_lock_irqsave(&tspi->lock, flags);
 	/* GPIO based chip select control */
-	if (spi->cs_gpiod)
-		gpiod_set_value(spi->cs_gpiod, 0);
+	if (spi->cs_gpiod[0])
+		gpiod_set_value(spi->cs_gpiod[0], 0);
 
 	val = tspi->def_command1_reg;
 	if (spi->mode & SPI_CS_HIGH)
-		val &= ~SPI_CS_POL_INACTIVE(spi->chip_select);
+		val &= ~SPI_CS_POL_INACTIVE(spi->chip_select[0]);
 	else
-		val |= SPI_CS_POL_INACTIVE(spi->chip_select);
+		val |= SPI_CS_POL_INACTIVE(spi->chip_select[0]);
 	tspi->def_command1_reg = val;
 	tegra_spi_writel(tspi, tspi->def_command1_reg, SPI_COMMAND1);
 	spin_unlock_irqrestore(&tspi->lock, flags);
@@ -1002,8 +1002,8 @@ static void tegra_spi_transfer_end(struct spi_device *spi)
 	int cs_val = (spi->mode & SPI_CS_HIGH) ? 0 : 1;
 
 	/* GPIO based chip select control */
-	if (spi->cs_gpiod)
-		gpiod_set_value(spi->cs_gpiod, 0);
+	if (spi->cs_gpiod[0])
+		gpiod_set_value(spi->cs_gpiod[0], 0);
 
 	if (!tspi->use_hw_based_cs) {
 		if (cs_val)
diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index 220ee08c4a06..ade91e1b8c17 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -280,7 +280,7 @@ static int tegra_sflash_start_transfer_one(struct spi_device *spi,
 			command |= SPI_ACTIVE_SCLK_DRIVE_HIGH;
 		else
 			command |= SPI_ACTIVE_SCLK_DRIVE_LOW;
-		command |= SPI_CS0_EN << spi->chip_select;
+		command |= SPI_CS0_EN << spi->chip_select[0];
 	} else {
 		command = tsd->command_reg;
 		command &= ~SPI_BIT_LENGTH(~0);
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 148043d0c2b8..a5a26ebf1f17 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -758,9 +758,9 @@ static int tegra_slink_setup(struct spi_device *spi)
 	spin_lock_irqsave(&tspi->lock, flags);
 	val = tspi->def_command_reg;
 	if (spi->mode & SPI_CS_HIGH)
-		val |= cs_pol_bit[spi->chip_select];
+		val |= cs_pol_bit[spi->chip_select[0]];
 	else
-		val &= ~cs_pol_bit[spi->chip_select];
+		val &= ~cs_pol_bit[spi->chip_select[0]];
 	tspi->def_command_reg = val;
 	tegra_slink_writel(tspi, tspi->def_command_reg, SLINK_COMMAND);
 	spin_unlock_irqrestore(&tspi->lock, flags);
@@ -781,7 +781,7 @@ static int tegra_slink_prepare_message(struct spi_master *master,
 	tspi->command_reg |= SLINK_CS_SW | SLINK_CS_VALUE;
 
 	tspi->command2_reg = tspi->def_command2_reg;
-	tspi->command2_reg |= SLINK_SS_EN_CS(spi->chip_select);
+	tspi->command2_reg |= SLINK_SS_EN_CS(spi->chip_select[0]);
 
 	tspi->command_reg &= ~SLINK_MODES;
 	if (spi->mode & SPI_CPHA)
diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index 60086869bcae..cfdd6166da8d 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -533,10 +533,10 @@ static void ti_qspi_enable_memory_map(struct spi_device *spi)
 	if (qspi->ctrl_base) {
 		regmap_update_bits(qspi->ctrl_base, qspi->ctrl_reg,
 				   MEM_CS_MASK,
-				   MEM_CS_EN(spi->chip_select));
+				   MEM_CS_EN(spi->chip_select[0]));
 	}
 	qspi->mmap_enabled = true;
-	qspi->current_cs = spi->chip_select;
+	qspi->current_cs = spi->chip_select[0];
 }
 
 static void ti_qspi_disable_memory_map(struct spi_device *spi)
@@ -572,7 +572,7 @@ static void ti_qspi_setup_mmap_read(struct spi_device *spi, u8 opcode,
 	memval |= ((addr_width - 1) << QSPI_SETUP_ADDR_SHIFT |
 		   dummy_bytes << QSPI_SETUP_DUMMY_SHIFT);
 	ti_qspi_write(qspi, memval,
-		      QSPI_SPI_SETUP_REG(spi->chip_select));
+		      QSPI_SPI_SETUP_REG(spi->chip_select[0]));
 }
 
 static int ti_qspi_adjust_op_size(struct spi_mem *mem, struct spi_mem_op *op)
@@ -623,7 +623,7 @@ static int ti_qspi_exec_mem_op(struct spi_mem *mem,
 
 	mutex_lock(&qspi->list_lock);
 
-	if (!qspi->mmap_enabled || qspi->current_cs != mem->spi->chip_select) {
+	if (!qspi->mmap_enabled || qspi->current_cs != mem->spi->chip_select[0]) {
 		ti_qspi_setup_clk(qspi, mem->spi->max_speed_hz);
 		ti_qspi_enable_memory_map(mem->spi);
 	}
@@ -673,11 +673,11 @@ static int ti_qspi_start_transfer_one(struct spi_master *master,
 	qspi->dc = 0;
 
 	if (spi->mode & SPI_CPHA)
-		qspi->dc |= QSPI_CKPHA(spi->chip_select);
+		qspi->dc |= QSPI_CKPHA(spi->chip_select[0]);
 	if (spi->mode & SPI_CPOL)
-		qspi->dc |= QSPI_CKPOL(spi->chip_select);
+		qspi->dc |= QSPI_CKPOL(spi->chip_select[0]);
 	if (spi->mode & SPI_CS_HIGH)
-		qspi->dc |= QSPI_CSPOL(spi->chip_select);
+		qspi->dc |= QSPI_CSPOL(spi->chip_select[0]);
 
 	frame_len_words = 0;
 	list_for_each_entry(t, &m->transfers, transfer_list)
@@ -686,7 +686,7 @@ static int ti_qspi_start_transfer_one(struct spi_master *master,
 
 	/* setup command reg */
 	qspi->cmd = 0;
-	qspi->cmd |= QSPI_EN_CS(spi->chip_select);
+	qspi->cmd |= QSPI_EN_CS(spi->chip_select[0]);
 	qspi->cmd |= QSPI_FLEN(frame_len_words);
 
 	ti_qspi_write(qspi, qspi->dc, QSPI_SPI_DC_REG);
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index cbb60198a7f0..3623bdca1e67 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -499,7 +499,7 @@ static inline void pch_spi_select_chip(struct pch_spi_data *data,
 				       struct spi_device *pspi)
 {
 	if (data->current_chip != NULL) {
-		if (pspi->chip_select != data->n_curnt_chip) {
+		if (pspi->chip_select[0] != data->n_curnt_chip) {
 			dev_dbg(&pspi->dev, "%s : different slave\n", __func__);
 			data->current_chip = NULL;
 		}
diff --git a/drivers/spi/spi-xcomm.c b/drivers/spi/spi-xcomm.c
index 1d9b3f03d986..43afff154df2 100644
--- a/drivers/spi/spi-xcomm.c
+++ b/drivers/spi/spi-xcomm.c
@@ -58,7 +58,7 @@ static int spi_xcomm_sync_config(struct spi_xcomm *spi_xcomm, unsigned int len)
 static void spi_xcomm_chipselect(struct spi_xcomm *spi_xcomm,
 	struct spi_device *spi, int is_active)
 {
-	unsigned long cs = spi->chip_select;
+	unsigned long cs = spi->chip_select[0];
 	uint16_t chipselect = spi_xcomm->chipselect;
 
 	if (is_active)
diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 523edfdf5dcd..25406b3e2b10 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -213,7 +213,7 @@ static void xilinx_spi_chipselect(struct spi_device *spi, int is_on)
 	 */
 
 	cs = xspi->cs_inactive;
-	cs ^= BIT(spi->chip_select);
+	cs ^= BIT(spi->chip_select[0]);
 
 	/* Activate the chip select */
 	xspi->write_fn(cs, xspi->regs + XSPI_SSR_OFFSET);
@@ -228,9 +228,9 @@ static int xilinx_spi_setup_transfer(struct spi_device *spi,
 	struct xilinx_spi *xspi = spi_master_get_devdata(spi->master);
 
 	if (spi->mode & SPI_CS_HIGH)
-		xspi->cs_inactive &= ~BIT(spi->chip_select);
+		xspi->cs_inactive &= ~BIT(spi->chip_select[0]);
 	else
-		xspi->cs_inactive |= BIT(spi->chip_select);
+		xspi->cs_inactive |= BIT(spi->chip_select[0]);
 
 	return 0;
 }
diff --git a/drivers/spi/spi-xlp.c b/drivers/spi/spi-xlp.c
index e5707fe5c8f1..50bd3318ad32 100644
--- a/drivers/spi/spi-xlp.c
+++ b/drivers/spi/spi-xlp.c
@@ -139,7 +139,7 @@ static int xlp_spi_setup(struct spi_device *spi)
 	int cs;
 
 	xspi = spi_master_get_devdata(spi->master);
-	cs = spi->chip_select;
+	cs = spi->chip_selecti[0];
 	/*
 	 * The value of fdiv must be between 4 and 65535.
 	 */
@@ -350,7 +350,7 @@ static int xlp_spi_transfer_one(struct spi_master *master,
 	struct xlp_spi_priv *xspi = spi_master_get_devdata(master);
 	int ret = 0;
 
-	xspi->cs = spi->chip_select;
+	xspi->cs = spi->chip_select[0];
 	xspi->dev = spi->dev;
 
 	if (spi_transfer_is_last(master, t))
diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 78f31b61a2aa..d82e0775602c 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -296,7 +296,7 @@ static void zynq_qspi_chipselect(struct spi_device *spi, bool assert)
 	/* Select the lower (CS0) or upper (CS1) memory */
 	if (ctlr->num_chipselect > 1) {
 		config_reg = zynq_qspi_read(xqspi, ZYNQ_QSPI_LINEAR_CFG_OFFSET);
-		if (!spi->chip_select)
+		if (!spi->chip_select[0])
 			config_reg &= ~ZYNQ_QSPI_LCFG_U_PAGE;
 		else
 			config_reg |= ZYNQ_QSPI_LCFG_U_PAGE;
diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 95ff15665d44..35ff734fb82d 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -468,7 +468,7 @@ static void zynqmp_qspi_chipselect(struct spi_device *qspi, bool is_high)
 	genfifoentry |= GQSPI_GENFIFO_MODE_SPI;
 
 	if (!is_high) {
-		if (!qspi->chip_select) {
+		if (!qspi->chip_select[0]) {
 			xqspi->genfifobus = GQSPI_GENFIFO_BUS_LOWER;
 			xqspi->genfifocs = GQSPI_GENFIFO_CS_LOWER;
 		} else {
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index b2775d82d2d7..e7bb59296ea8 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -412,7 +412,7 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 
 			if (ctlr->use_gpio_descriptors && ctlr->cs_gpiods &&
-			    ctlr->cs_gpiods[spi->chip_select])
+			    ctlr->cs_gpiods[spi->chip_select[0]])
 				tmp |= SPI_CS_HIGH;
 
 			tmp |= spi->mode & ~SPI_MODE_MASK;
@@ -781,7 +781,7 @@ static int spidev_probe(struct spi_device *spi)
 		spidev->devt = MKDEV(SPIDEV_MAJOR, minor);
 		dev = device_create(spidev_class, &spi->dev, spidev->devt,
 				    spidev, "spidev%d.%d",
-				    spi->master->bus_num, spi->chip_select);
+				    spi->master->bus_num, spi->chip_select[0]);
 		status = PTR_ERR_OR_ZERO(dev);
 	} else {
 		dev_dbg(&spi->dev, "no minor number available!\n");
diff --git a/include/trace/events/spi.h b/include/trace/events/spi.h
index c0d9844befd7..464a342c52ea 100644
--- a/include/trace/events/spi.h
+++ b/include/trace/events/spi.h
@@ -57,7 +57,7 @@ TRACE_EVENT(spi_setup,
 
 	TP_fast_assign(
 		__entry->bus_num = spi->controller->bus_num;
-		__entry->chip_select = spi->chip_select;
+		__entry->chip_select = spi->chip_select[0];
 		__entry->mode = spi->mode;
 		__entry->bits_per_word = spi->bits_per_word;
 		__entry->max_speed_hz = spi->max_speed_hz;
@@ -88,7 +88,7 @@ TRACE_EVENT(spi_set_cs,
 
 	TP_fast_assign(
 		__entry->bus_num = spi->controller->bus_num;
-		__entry->chip_select = spi->chip_select;
+		__entry->chip_select = spi->chip_select[0];
 		__entry->mode = spi->mode;
 		__entry->enable = enable;
 	),
@@ -113,7 +113,7 @@ DECLARE_EVENT_CLASS(spi_message,
 
 	TP_fast_assign(
 		__entry->bus_num = msg->spi->controller->bus_num;
-		__entry->chip_select = msg->spi->chip_select;
+		__entry->chip_select = msg->spi->chip_select[0];
 		__entry->msg = msg;
 	),
 
@@ -154,7 +154,7 @@ TRACE_EVENT(spi_message_done,
 
 	TP_fast_assign(
 		__entry->bus_num = msg->spi->controller->bus_num;
-		__entry->chip_select = msg->spi->chip_select;
+		__entry->chip_select = msg->spi->chip_select[0];
 		__entry->msg = msg;
 		__entry->frame = msg->frame_length;
 		__entry->actual = msg->actual_length;
@@ -197,7 +197,7 @@ DECLARE_EVENT_CLASS(spi_transfer,
 
 	TP_fast_assign(
 		__entry->bus_num = msg->spi->controller->bus_num;
-		__entry->chip_select = msg->spi->chip_select;
+		__entry->chip_select = msg->spi->chip_select[0];
 		__entry->xfer = xfer;
 		__entry->len = xfer->len;
 
-- 
2.17.1

