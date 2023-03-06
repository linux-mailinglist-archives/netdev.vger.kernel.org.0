Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551EC6AC9C5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCFRWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCFRWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:22:50 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCDC67013;
        Mon,  6 Mar 2023 09:22:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jY2PydATWKroHUtsnh7dV/adbQnaiRtF/udqJE1oFCKcmXL1oODifv1X7K2QterKCXphFK1CoK6GXcVg/MABLaCyFdVyxzgEQRvMoLS10vGc6xGebkcUkyCQ7A5gzp7Ahbvd82N18dnQcb9rbcDm2w5DSGL0PyX9OrZ0PEhrRAkZrBmf/eut0dB/gOgZ9Gpv5HoO4IJxzyPBgS/pXYNHo30y9GrZHJeTjYAgPU5axawv+xTU24u5i+m0jxaKljckVaD/j+QL1y7cwHw7BjVkhYLbrBXdejogH/kf0JXowafi/2RrGFWwNRMpd/CQJ91UOWfn0I81/LVn4vqsdZDZpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WL6q/Hbj7ODGetRka5dhCXZOmTu0EJfGTSTj5c9H5Fk=;
 b=BDmMt6U0BDG3Zinx8whZcyC4DlPpL/4EEFRoDmNSdsWm9y+gpdy2RJPaO1uQ3FrVFL49DgUCKaw2a7+lhhKQRlPljGjUXbGiQ/aew864K4xijGxUGCKQlJbZzfCTOlMozH6xFEII33jflSjMp6rsTkKtfnHROJ7qRjT7FXT5KXYpOWhcOEs+c9pew43zQRwx9ypCKJQwP3hcFKpOHp6FFtkl6sk2d8+fwrcCgIl1AgHH0kutGQSNLuKbi7njZf+QG7fXyoYmWN/bnJvSYy+mRYOH7CUSjMJ9jgBDo7Y5fH2j09YzeL5wvHxennGQM2GolVeJINNF0Gjpgjc88xBUSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WL6q/Hbj7ODGetRka5dhCXZOmTu0EJfGTSTj5c9H5Fk=;
 b=I9nUyRoUmAh5s4nWk+UZOPPGuO79FGVEETh3P7Cyr4e5XCHD/dQtRkUxR2OjP7wen40bhEXpeXSJgPcVURyExJpe9R6R+2PdrtzWT34hS42RqCudxk2JH+tZqeg2gdHPPPi30SSo9drecuDC53mm0LZ8cAWizKb0f2lQE5T+bq8=
Received: from DS7PR03CA0321.namprd03.prod.outlook.com (2603:10b6:8:2b::6) by
 MN2PR12MB4238.namprd12.prod.outlook.com (2603:10b6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:22:00 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::e0) by DS7PR03CA0321.outlook.office365.com
 (2603:10b6:8:2b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 17:22:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 17:21:59 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:21:59 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:21:58 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 6 Mar 2023 11:21:31 -0600
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
Subject: [PATCH V5 00/15] spi: Add support for stacked/parallel memories
Date:   Mon, 6 Mar 2023 22:50:54 +0530
Message-ID: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|MN2PR12MB4238:EE_
X-MS-Office365-Filtering-Correlation-Id: 560d4183-aede-4c83-2c38-08db1e674b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DmDpM5mG3V6XtD3zUXc3xq43Vu3NGgZN7YMettROOX1qgBVaqv/18CNLLz1CQXN41j5mFRQDslQTB24mUO0jSqBl3u3aOaJ2LXTmZNTV/1ekp/SnwVDlk7DO08VdzFKkqWS1VPT41IunenhMCMhoqRNIdPrYN35OI53yNdo2G3IbQMmgbpHwKC/UQS6dZaW6sJYPvJBUTz0ZJzRdG+CB+6mnzPHj2Sj/Z1OFvPloiT3MgyqHLKEGPR+V0SEyyrxJIpuLHVUQ4ZyZNDQ2AuJtMAEdN5wE9ch05wuu3Mz/eyF5y0xb1hLEMeOSZL50+SctavdwrWwv7yKQTC0UE5yVsKYyUopqJ20cVPn7oFylxx3crWItzMfMQMTcKtLXxlllfQkGVCFlN76Bqneylc08e96+YQHk72qQYLMW225PCy73iJTstdFGelyqkPMQUoyrrdGYBjUMWjv6LeWk4mwpsrftCZsa3R7V0Rp7KDPi4jeVx8n/bj941j0f+CcFEr9rv5ZrwPA7VVk1k0X100+SvT5bQ/qRApkuOy0Ml1UofmzDppMy5rsE+NmjiiCpTuzIAaEsyjrWaJjA2OVaTywAbwZZ1XaxJQH6bMFfJsE1MWu0LXEHciAfbRaqx5+bXBCqyYuze+Dc37XlTyE1W+T/ekgRH8mNQskxydJJ756FYFixUUxaiCDKoZGQaV2f/8OEPoQVv3uScRLZogoMQpiqEkhyOyxCGlViYywm7k0UENZtZYQR60jLnb+RS641cBL+vLhD/Ld1hoktTjthTrCmt1kuPT7r97YxAEtkvKUpGWm6cgjmoVwUaf7GALePolthowkZxs0fTsgKRwDwnFkmBax1aob5Z8HH5ovZUjI3dSheutZHFoCoRGYcYMZgwpMZ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199018)(40470700004)(46966006)(36840700001)(1076003)(966005)(6666004)(36756003)(36860700001)(47076005)(426003)(82310400005)(83380400001)(921005)(40460700003)(86362001)(81166007)(40480700001)(356005)(82740400003)(1191002)(336012)(186003)(26005)(2616005)(41300700001)(70206006)(70586007)(8676002)(4326008)(2906002)(8936002)(7276002)(7336002)(7406005)(7416002)(5660300002)(7366002)(478600001)(316002)(54906003)(110136005)(41080700001)(84006005)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:21:59.8388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 560d4183-aede-4c83-2c38-08db1e674b7c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

The first patch
https://lore.kernel.org/all/20230119185342.2093323-1-amit.kumar-mahapatra@amd.com/
of the previous series got applied to
https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next
But the rest of the patches in the series did not get applied due to merge
conflict, so send the remaining patches in the series after rebasing it
on top of for-next branch.
---
BRANCH: for-next

Changes in v5:
- Rebased the patches on top of v6.3-rc1 and fixed the merge conflicts.
- Fixed compilation warnings in spi-sh-msiof.c with shmobile_defconfig  

Changes in v4:
- Fixed build error in spi-pl022.c file - reported by Mark.
- Fixed build error in spi-sn-f-ospi.c file.
- Added Reviewed-by: Serge Semin <fancer.lancer@gmail.com> tag.
- Added two more patches to replace spi->chip_select with API calls in
  mpc832x_rdb.c & cs35l41_hda_spi.c files.

Changes in v3:
- Rebased the patches on top of
  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next
- Added a patch to convert spi_nor_otp_region_len(nor) &
  spi_nor_otp_n_regions(nor) macros into inline functions
- Added Reviewed-by & Acked-by tags

Changes in v2:
- Rebased the patches on top of v6.2-rc1
- Created separate patch to add get & set APIs for spi->chip_select &
  spi->cs_gpiod, and replaced all spi->chip_select and spi->cs_gpiod
  references with the API calls.
- Created separate patch to add get & set APIs for nor->params.
---
Amit Kumar Mahapatra (15):
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
  powerpc/83xx/mpc832x_rdb: Replace all spi->chip_select references with
    function call
  ALSA: hda: cs35l41: Replace all spi->chip_select references with
    function call
  spi: Add stacked and parallel memories support in SPI core
  mtd: spi-nor: Convert macros with inline functions
  mtd: spi-nor: Add APIs to set/get nor->params
  mtd: spi-nor: Add stacked memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add stacked memories support in GQSPI driver
  mtd: spi-nor: Add parallel memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add parallel memories support in GQSPI driver

 arch/powerpc/platforms/83xx/mpc832x_rdb.c     |   2 +-
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
 drivers/mtd/spi-nor/otp.c                     |  48 +-
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
 drivers/spi/spi-bcm63xx-hsspi.c               |  30 +-
 drivers/spi/spi-bcm63xx.c                     |   2 +-
 drivers/spi/spi-bcmbca-hsspi.c                |  30 +-
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
 drivers/spi/spi.c                             | 213 ++++--
 drivers/spi/spidev.c                          |   6 +-
 drivers/staging/fbtft/fbtft-core.c            |   2 +-
 drivers/staging/greybus/spilib.c              |   2 +-
 include/linux/mtd/spi-nor.h                   |  18 +-
 include/linux/spi/spi.h                       |  34 +-
 include/trace/events/spi.h                    |  10 +-
 sound/pci/hda/cs35l41_hda_spi.c               |   2 +-
 127 files changed, 1342 insertions(+), 613 deletions(-)

-- 
2.25.1

