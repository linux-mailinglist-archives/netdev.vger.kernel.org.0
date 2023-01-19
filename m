Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D18C67415B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjASSyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjASSyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:54:22 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0290694C8A;
        Thu, 19 Jan 2023 10:54:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XI4A8Q8VbnUZx7yap4wx18lmLRCUOCTnWTI8omh0h1rPcSSGRfH2FXulNiADKtzbdMY3Bochpl+UyPCaMTyxaoO/qVVno93v3FkQYCfJYwbIkaD6R4O7PzmHjfT/PKMXURCV0KML9v6N8AL1TFo185fCGNo00rnZ2fiBNaUKbf9IhWrCysQVcc+R67X9SDXda6BKAmrRsQomCPaGkpIFV4LKebdB+ymoNB9TAroBhqL+vku10Z7b/USyO7gRojr2V/SfU3oMYy0eEfyy5jitokKY0Szs6+JjYwtzbi6PckaA1NW2Is/pV2G5LU2sik5nQ4gEpEacvAI3eN+QBDI2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1b8ygK4l4t9D1VUmNx5SCNMOort3UV1hUcI4VTpZAvs=;
 b=SuLVdS0mgOeJGmpkaUxhUzd/jnjSvWA8OSMmzi9iizfIsPcjmuRXGsZY4DljIWpGn2oZZYzJ3C/pWhkSvIpq7FqyVuVU+goAwNhEL5FPRSPXgtehSNgQDO5VmVvH7tB3DXv+WeNQWgprcXJGhMF3Exq5jGdvDPlnuIu5NDMoyEwqoRrUrVxElDht/Zlm7faecFSCfSQfVMopTzzWJaJO0ZHu3iislJmw+laFaGWpgReBIf+EsNvqxEmDQuraN0hc+WUJzSVUGNU5X2iOufzCo3pBx3Mj+PT+VCDT7CmavQUA2aAyhygxnWcySot0L/sLPvZ7KcDWeQOs+iwFm5gO9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1b8ygK4l4t9D1VUmNx5SCNMOort3UV1hUcI4VTpZAvs=;
 b=f+GL3+VyYV9gl5oLGwNzGT3/GTaxesOefL1+VtGAPaop9d5JWPsmdQvXZtbPescvr8OIocxf9L7BbC51grVUmIVt4FBXlz/HdMl08tAB8/MQ4H+yQ/p5rT8U63WQ8O+XvLMXcGQfuCBi1uPkZOeMsdCo4MnQZSajHAEq3BO3oqg=
Received: from SJ0PR13CA0113.namprd13.prod.outlook.com (2603:10b6:a03:2c5::28)
 by IA1PR12MB6483.namprd12.prod.outlook.com (2603:10b6:208:3a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 18:54:14 +0000
Received: from CO1PEPF00001A5E.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::16) by SJ0PR13CA0113.outlook.office365.com
 (2603:10b6:a03:2c5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.16 via Frontend
 Transport; Thu, 19 Jan 2023 18:54:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF00001A5E.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Thu, 19 Jan 2023 18:54:12 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:54:09 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 10:54:08 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 12:53:43 -0600
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
Subject: [PATCH v2 00/13] spi: Add support for stacked/parallel memories
Date:   Fri, 20 Jan 2023 00:23:29 +0530
Message-ID: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5E:EE_|IA1PR12MB6483:EE_
X-MS-Office365-Filtering-Correlation-Id: 77f1653e-d41a-46eb-9623-08dafa4e8e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZDBpCSjbv/cRfsFYckWfcw1Z4CytZfw/jR+0nWB/4pW//twXGEJkmy8CRkAsXJi0lT/cYNYlWPxVYBKj0S2fIu1yVqJSYng2+66kg1E4wmEW1OrLGlIRtBlHPVdHBv6AXwpV+Br+K1Khlbi9z2VUEQfOOHAdTK27pvwNWwC7jkFMdrsq7nmYvAy9BtdCxPpLTwVPNB1Wq7rTatpfNOirKmYLhVo3hxQcxU5rBFf6fK1Ip9cXymRZJbfsALQ2Av8GONJNNbSsMPiaEWXa0jpTq2qy6wsdDeaZ+98CB1uzVI5++7K6QbwzabKCwRU6kab5c+zOEl2AbHdtkNACxeKlZMsAup9+2MTKbT7dwsSANlkge5BGPOJXCmo8b1GoZKsmrQLILWGxzjEdbhYo+QrIVDXH1upsQ74MljxaJ34OcHyXmUo6NVOjna1EjAW7To9QzyVgoClN6s9K0j0NjdnmZNlnPBfFcq+d7htFn8DuuwAdxXaBW++B/hh1qbQhVxsho8HxVf2BczpEDEm2Qy13GgQKzxgcnTu+ImZDRsygMsB/LXG3eH9LIX3pN0zPq/lIvg2bsa0mTOtXV3ZhXafaP5U4LZxyKf8F/oasjplokXxf5Rw4B+kDZM8iZKsmTn6kRQQ7yX6vOFNqvdvBDAfTQQS42+1f6ekK5+pArUvoo4hrrQOzM/cZCfGu64QdupIlTkg+UEvkfLInCcQBPYDwfpzyGy0D87tbtou4OaF7mlI8/rvwXnCAMuktFe9aIeikJST27/4UgxtB4ji6/qpdltnwiFkUbmrVriDZMsfrpDXxcc32yy8cF+RK1vDPwyTD5Pk277ckkva50D3r+sRuzZH6Jx1WSHNhWzdmsl0StoA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(86362001)(40460700003)(36756003)(6666004)(478600001)(8936002)(316002)(5660300002)(40480700001)(82740400003)(7406005)(70586007)(70206006)(4326008)(7276002)(7336002)(7366002)(8676002)(7416002)(41300700001)(36860700001)(921005)(26005)(356005)(186003)(2616005)(82310400005)(1191002)(83380400001)(2906002)(81166007)(54906003)(110136005)(47076005)(426003)(336012)(1076003)(83996005)(84006005)(2101003)(41080700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:54:12.3778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f1653e-d41a-46eb-9623-08dafa4e8e37
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6483
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
adding dt-binding support for stacked/parallel memories.

This patch series updated the spi-nor, spi core and the spi drivers
to add stacked and parallel memories support.
---
BRANCH: mtd/next

Changes in v2:
- Rebased the patches on top of v6.2-rc1 
- Created separate patch to add get & set APIs for spi->chip_select & 
  spi->cs_gpiod, and replaced all spi->chip_select and spi->cs_gpiod 
  references with the API calls.
- Created separate patch to add get & set APIs for nor->params.
---
Amit Kumar Mahapatra (13):
  spi: Add APIs in spi core to set/get spi->chip_select and
    spi->cs_gpiod
  spi: Replace all spi->chip_select and spi->cs_gpiod references with
    function call
  net: Replace all spi->chip_select and spi->cs_gpiod references with
    function call
  iio: imu: Replace all spi->chip_select and spi->cs_gpiod references
    with function call
  mtd: devices: Replace all spi->chip_select and spi->cs_gpiod
    references with function call
  staging: Replace all spi->chip_select and spi->cs_gpiod references
    with function call
  platform/x86: serial-multi-instantiate: Replace all spi->chip_select
    and spi->cs_gpiod references with function call
  spi: Add stacked and parallel memories support in SPI core
  mtd: spi-nor: Add APIs to set/get nor->params
  mtd: spi-nor: Add stacked memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add stacked memories support in GQSPI driver
  mtd: spi-nor: Add parallel memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add parallel memories support in GQSPI driver

 drivers/iio/imu/adis16400.c                   |   2 +-
 drivers/mtd/devices/mtd_dataflash.c           |   2 +-
 drivers/mtd/spi-nor/atmel.c                   |  17 +-
 drivers/mtd/spi-nor/core.c                    | 665 +++++++++++++++---
 drivers/mtd/spi-nor/core.h                    |   8 +
 drivers/mtd/spi-nor/debugfs.c                 |   4 +-
 drivers/mtd/spi-nor/gigadevice.c              |   4 +-
 drivers/mtd/spi-nor/issi.c                    |  11 +-
 drivers/mtd/spi-nor/macronix.c                |   6 +-
 drivers/mtd/spi-nor/micron-st.c               |  39 +-
 drivers/mtd/spi-nor/otp.c                     |  25 +-
 drivers/mtd/spi-nor/sfdp.c                    |  29 +-
 drivers/mtd/spi-nor/spansion.c                |  50 +-
 drivers/mtd/spi-nor/sst.c                     |   7 +-
 drivers/mtd/spi-nor/swp.c                     |  22 +-
 drivers/mtd/spi-nor/winbond.c                 |  10 +-
 drivers/mtd/spi-nor/xilinx.c                  |  18 +-
 drivers/net/ethernet/adi/adin1110.c           |   2 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |   2 +-
 drivers/net/ethernet/davicom/dm9051.c         |   2 +-
 drivers/net/ethernet/qualcomm/qca_debug.c     |   2 +-
 drivers/net/ieee802154/ca8210.c               |   2 +-
 drivers/net/wan/slic_ds26522.c                |   2 +-
 .../net/wireless/marvell/libertas/if_spi.c    |   2 +-
 drivers/net/wireless/silabs/wfx/bus_spi.c     |   2 +-
 drivers/net/wireless/st/cw1200/cw1200_spi.c   |   2 +-
 .../platform/x86/serial-multi-instantiate.c   |   3 +-
 drivers/spi/spi-altera-core.c                 |   2 +-
 drivers/spi/spi-amd.c                         |   4 +-
 drivers/spi/spi-ar934x.c                      |   2 +-
 drivers/spi/spi-armada-3700.c                 |   4 +-
 drivers/spi/spi-aspeed-smc.c                  |  13 +-
 drivers/spi/spi-at91-usart.c                  |   2 +-
 drivers/spi/spi-ath79.c                       |   4 +-
 drivers/spi/spi-atmel.c                       |  26 +-
 drivers/spi/spi-au1550.c                      |   4 +-
 drivers/spi/spi-axi-spi-engine.c              |   2 +-
 drivers/spi/spi-bcm-qspi.c                    |  10 +-
 drivers/spi/spi-bcm2835.c                     |  19 +-
 drivers/spi/spi-bcm2835aux.c                  |   4 +-
 drivers/spi/spi-bcm63xx-hsspi.c               |  22 +-
 drivers/spi/spi-bcm63xx.c                     |   2 +-
 drivers/spi/spi-cadence-quadspi.c             |   5 +-
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
 drivers/spi/spi-fsl-dspi.c                    |  16 +-
 drivers/spi/spi-fsl-espi.c                    |   6 +-
 drivers/spi/spi-fsl-lpspi.c                   |   2 +-
 drivers/spi/spi-fsl-qspi.c                    |   6 +-
 drivers/spi/spi-fsl-spi.c                     |   2 +-
 drivers/spi/spi-geni-qcom.c                   |   6 +-
 drivers/spi/spi-gpio.c                        |   4 +-
 drivers/spi/spi-gxp.c                         |   4 +-
 drivers/spi/spi-hisi-sfc-v3xx.c               |   2 +-
 drivers/spi/spi-img-spfi.c                    |  14 +-
 drivers/spi/spi-imx.c                         |  30 +-
 drivers/spi/spi-ingenic.c                     |   4 +-
 drivers/spi/spi-intel.c                       |   2 +-
 drivers/spi/spi-jcore.c                       |   4 +-
 drivers/spi/spi-lantiq-ssc.c                  |   6 +-
 drivers/spi/spi-mem.c                         |   4 +-
 drivers/spi/spi-meson-spicc.c                 |   2 +-
 drivers/spi/spi-microchip-core.c              |   6 +-
 drivers/spi/spi-mpc512x-psc.c                 |   8 +-
 drivers/spi/spi-mpc52xx.c                     |   2 +-
 drivers/spi/spi-mt65xx.c                      |   6 +-
 drivers/spi/spi-mt7621.c                      |   2 +-
 drivers/spi/spi-mux.c                         |   8 +-
 drivers/spi/spi-mxic.c                        |  10 +-
 drivers/spi/spi-mxs.c                         |   2 +-
 drivers/spi/spi-npcm-fiu.c                    |  20 +-
 drivers/spi/spi-nxp-fspi.c                    |  10 +-
 drivers/spi/spi-omap-100k.c                   |   2 +-
 drivers/spi/spi-omap-uwire.c                  |   8 +-
 drivers/spi/spi-omap2-mcspi.c                 |  24 +-
 drivers/spi/spi-orion.c                       |   4 +-
 drivers/spi/spi-pci1xxxx.c                    |   4 +-
 drivers/spi/spi-pic32-sqi.c                   |   2 +-
 drivers/spi/spi-pic32.c                       |   4 +-
 drivers/spi/spi-pl022.c                       |   4 +-
 drivers/spi/spi-pxa2xx.c                      |   6 +-
 drivers/spi/spi-qcom-qspi.c                   |   2 +-
 drivers/spi/spi-rb4xx.c                       |   2 +-
 drivers/spi/spi-rockchip-sfc.c                |   2 +-
 drivers/spi/spi-rockchip.c                    |  26 +-
 drivers/spi/spi-rspi.c                        |  10 +-
 drivers/spi/spi-s3c64xx.c                     |   2 +-
 drivers/spi/spi-sc18is602.c                   |   4 +-
 drivers/spi/spi-sh-msiof.c                    |   6 +-
 drivers/spi/spi-sh-sci.c                      |   2 +-
 drivers/spi/spi-sifive.c                      |   6 +-
 drivers/spi/spi-sn-f-ospi.c                   |   2 +-
 drivers/spi/spi-st-ssc4.c                     |   2 +-
 drivers/spi/spi-stm32-qspi.c                  |  12 +-
 drivers/spi/spi-sun4i.c                       |   2 +-
 drivers/spi/spi-sun6i.c                       |   2 +-
 drivers/spi/spi-synquacer.c                   |   6 +-
 drivers/spi/spi-tegra114.c                    |  28 +-
 drivers/spi/spi-tegra20-sflash.c              |   2 +-
 drivers/spi/spi-tegra20-slink.c               |   6 +-
 drivers/spi/spi-tegra210-quad.c               |   8 +-
 drivers/spi/spi-ti-qspi.c                     |  16 +-
 drivers/spi/spi-topcliff-pch.c                |   4 +-
 drivers/spi/spi-wpcm-fiu.c                    |  12 +-
 drivers/spi/spi-xcomm.c                       |   2 +-
 drivers/spi/spi-xilinx.c                      |   6 +-
 drivers/spi/spi-xlp.c                         |   4 +-
 drivers/spi/spi-zynq-qspi.c                   |   2 +-
 drivers/spi/spi-zynqmp-gqspi.c                |  58 +-
 drivers/spi/spi.c                             | 224 ++++--
 drivers/spi/spidev.c                          |   6 +-
 drivers/staging/fbtft/fbtft-core.c            |   2 +-
 drivers/staging/greybus/spilib.c              |   2 +-
 include/linux/mtd/spi-nor.h                   |  18 +-
 include/linux/spi/spi.h                       |  46 +-
 include/trace/events/spi.h                    |  10 +-
 124 files changed, 1319 insertions(+), 594 deletions(-)

-- 
2.17.1

