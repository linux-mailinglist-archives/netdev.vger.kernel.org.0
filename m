Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E22B677B70
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjAWMqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjAWMqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:46:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E798718A9B;
        Mon, 23 Jan 2023 04:46:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJe7gqrmeTiRxZjaZxjCZDg1jkAI3WaqyD7h5QhtMbqLXfEtOOIlBqTuhYQ+RjEqhvQkMou8NjUoCdby4l2Ij1+L6Omela2FsYsjRTOXKW6PQ6Ze74IXYlfO3+0As8L7Wbeatzw4WaP6vaIPHAJftcxbhRE2biMXnIpJlGlhtKJVlqrgTXWmOO8UsRgv5vlcXhp5kjmscGcmuZVw+koAf/uSHAJPuyNcQrb4epbODS73OXEGfNm7ifF2Oy+kHOlPMf6eNjJo1zltpetlwrny/7S4IMp0bT4OMA5gibJFfWe7doAuRJ1RYBoD3/Ypweoz6gJU8vslA0T4VDsjascSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKznWLT39MzCYZG7pjGwdPHFBxT5u5VGNZx4Odd5/AQ=;
 b=TIzFtqvpn/duCFZRHN8JfDF+OZmbmi5lS6xrTiTIS4Htqr4LRGlFt83jGI61PQrwd/l4TromiDgP6RWCM20LrbIE75aaB2od2pa0Vp8vzWzfCDHnLt7Mmw52ZUBo5b0fwGdnkbpq00qBhDc6mQjNPclIJo6w429KlqkseXelipEPEntOWsjFesP4k5uU1p0o0mG8/IDLg/WAbUyKNScGJRgBL7luK7wNgW3Fnq8ywfkb0qy+3dabT0oX4nMEty2JfwoVjFKU7xtXfPHQCI1H26gAxeJX8sqL5WOsJ9F0sXGfI44zqZSJEutLO694NxN2C2W1qYYrJ6IJ0XElpg6S3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKznWLT39MzCYZG7pjGwdPHFBxT5u5VGNZx4Odd5/AQ=;
 b=IGjawmbphouTYebyuJc9g7SQsSh4gAQsc19l0AO8QXJaeIoIdMo/xGMd0lwDy//LHiNXxyBuYZSHoqJS6FktCWZnoGIrKoFK3DPbQ8dqtKQK8Ad1PMX02+gg5wEQB4Rbiry7zb9PPTgS0iNm8rXxFdKydZZsQYBvbtX4Pq9Ey9k=
Received: from BN9PR03CA0779.namprd03.prod.outlook.com (2603:10b6:408:13a::34)
 by CH3PR12MB8257.namprd12.prod.outlook.com (2603:10b6:610:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:46:44 +0000
Received: from BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::ab) by BN9PR03CA0779.outlook.office365.com
 (2603:10b6:408:13a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 12:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT097.mail.protection.outlook.com (10.13.176.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 12:46:44 +0000
Received: from [10.254.241.50] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 06:46:13 -0600
Message-ID: <8c57c789-5388-b88c-2c63-051d0074d5ad@amd.com>
Date:   Mon, 23 Jan 2023 13:46:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 02/13] spi: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Content-Language: en-US
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
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
        <ldewangan@nvidia.com>, <linux-aspeed@lists.ozlabs.org>,
        <openbmc@lists.ozlabs.org>, <linux-arm-kernel@lists.infradead.org>,
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
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
 <20230119185342.2093323-3-amit.kumar-mahapatra@amd.com>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <20230119185342.2093323-3-amit.kumar-mahapatra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT097:EE_|CH3PR12MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: e27cad1f-2f76-4e95-f68a-08dafd3fe222
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MUYWj/ZQHiFn7gH+LMpRRA4tvuboqKDKio+V77GAfpAKK/xfgJYXLiPgkWJAsoANpJ6/2tYUlZGB9HGeh1humYeVmLCE12/XH4RfWNyt/JdTNVnoB9ZjTJoV2b//Z+UBkioJZNFdTEur3mkQt7MPis9Fq3TgQySz1xziiQh5tUXte7GlEvGeeh/sIsuVayrMsy08mprt3PoZYzONnUhtmwjz2Gbt2nNoCVSl9ocsj6tVmZSIqJejkhw+iRGaY42WpZnbCpsoAgNjIt1MkURFgHYvItYKHiLM4kV5buWcJyQVLE+eTlKtUtl5g4iYrRX61FmMAxZU4tqY7jHkmV26SyknIABwJJLIgPBAK2DgpEn6dr/iG+G+h+8W4OFr0H81ObRyyuZVqxYn27W8Y49M2nDOpoZuH7AHE+BHv0QEHTIGJS5PlhgCqKGRPI7mrEOb3cvU3ncJc8mxEfHOK7+1H9TaKLphKt9UrMPCmvjaXaxCkvtIGVvfta/8xFgKzMoBDJTrS7seQeJzlJ/wA7oWlZR/3MRa1fE5EGyKH7WYLFDmXrGYhIjUbrcVNK9Xjozj0eu9RloULaihIhks3did9j6Xv+rFmS0lZ8Eut05At2WT7HL205R5qSWOmQoG9hgt5ugmx+E/+wvj72922a9O/Z4V+rOl0tKJmT2wzmOTLBZK2P9E8vZsg4tYW+udhMh++1a52Idm51on2mMhEn7HhgwD28qOnL6hCqCMOBoNzgacxb4T4e5Mdessgp2UGbABmd8wHmoXo7xJJIIB/fitSblXBPJ9f8iEhDoSHMPUPXXKLDR/JmmIgWYsRbft7i6GbERUT4/CGk++I5MOCubL1Hs6fBQk5xUnsvno8jj9y5MPCP1AARjM78xstplrX1z
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(31696002)(41300700001)(86362001)(356005)(921005)(81166007)(82740400003)(7416002)(5660300002)(7406005)(7336002)(8936002)(82310400005)(4326008)(2906002)(44832011)(7366002)(7276002)(83380400001)(36860700001)(110136005)(478600001)(31686004)(16526019)(8676002)(26005)(53546011)(186003)(1191002)(40460700003)(40480700001)(70586007)(16576012)(70206006)(316002)(2616005)(54906003)(336012)(426003)(47076005)(36900700001)(2101003)(41080700001)(83996005)(43740500002)(84006005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:46:44.3649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e27cad1f-2f76-4e95-f68a-08dafd3fe222
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8257
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/23 19:53, Amit Kumar Mahapatra wrote:
> Supporting multi-cs in spi drivers would require the chip_select & cs_gpiod
> members of struct spi_device to be an array. But changing the type of these
> members to array would break the spi driver functionality. To make the
> transition smoother introduced four new APIs to get/set the
> spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
> spi->cs_gpiod references with get or set API calls.
> While adding multi-cs support in further patches the chip_select & cs_gpiod
> members of the spi_device structure would be converted to arrays & the
> "idx" parameter of the APIs would be used as array index i.e.,
> spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> ---
>   drivers/spi/spi-altera-core.c     |  2 +-
>   drivers/spi/spi-amd.c             |  4 ++--
>   drivers/spi/spi-ar934x.c          |  2 +-
>   drivers/spi/spi-armada-3700.c     |  4 ++--
>   drivers/spi/spi-aspeed-smc.c      | 13 +++++++------
>   drivers/spi/spi-at91-usart.c      |  2 +-
>   drivers/spi/spi-ath79.c           |  4 ++--
>   drivers/spi/spi-atmel.c           | 26 +++++++++++++-------------
>   drivers/spi/spi-au1550.c          |  4 ++--
>   drivers/spi/spi-axi-spi-engine.c  |  2 +-
>   drivers/spi/spi-bcm-qspi.c        | 10 +++++-----
>   drivers/spi/spi-bcm2835.c         | 19 ++++++++++---------
>   drivers/spi/spi-bcm2835aux.c      |  4 ++--
>   drivers/spi/spi-bcm63xx-hsspi.c   | 22 +++++++++++-----------
>   drivers/spi/spi-bcm63xx.c         |  2 +-
>   drivers/spi/spi-cadence-quadspi.c |  5 +++--
>   drivers/spi/spi-cadence-xspi.c    |  4 ++--
>   drivers/spi/spi-cadence.c         |  4 ++--
>   drivers/spi/spi-cavium.c          |  8 ++++----
>   drivers/spi/spi-coldfire-qspi.c   |  8 ++++----
>   drivers/spi/spi-davinci.c         | 18 +++++++++---------
>   drivers/spi/spi-dln2.c            |  6 +++---
>   drivers/spi/spi-dw-core.c         |  2 +-
>   drivers/spi/spi-dw-mmio.c         |  4 ++--
>   drivers/spi/spi-falcon.c          |  2 +-
>   drivers/spi/spi-fsi.c             |  2 +-
>   drivers/spi/spi-fsl-dspi.c        | 16 ++++++++--------
>   drivers/spi/spi-fsl-espi.c        |  6 +++---
>   drivers/spi/spi-fsl-lpspi.c       |  2 +-
>   drivers/spi/spi-fsl-qspi.c        |  6 +++---
>   drivers/spi/spi-fsl-spi.c         |  2 +-
>   drivers/spi/spi-geni-qcom.c       |  6 +++---
>   drivers/spi/spi-gpio.c            |  4 ++--
>   drivers/spi/spi-gxp.c             |  4 ++--
>   drivers/spi/spi-hisi-sfc-v3xx.c   |  2 +-
>   drivers/spi/spi-img-spfi.c        | 14 +++++++-------
>   drivers/spi/spi-imx.c             | 30 +++++++++++++++---------------
>   drivers/spi/spi-ingenic.c         |  4 ++--
>   drivers/spi/spi-intel.c           |  2 +-
>   drivers/spi/spi-jcore.c           |  4 ++--
>   drivers/spi/spi-lantiq-ssc.c      |  6 +++---
>   drivers/spi/spi-mem.c             |  4 ++--
>   drivers/spi/spi-meson-spicc.c     |  2 +-
>   drivers/spi/spi-microchip-core.c  |  6 +++---
>   drivers/spi/spi-mpc512x-psc.c     |  8 ++++----
>   drivers/spi/spi-mpc52xx.c         |  2 +-
>   drivers/spi/spi-mt65xx.c          |  6 +++---
>   drivers/spi/spi-mt7621.c          |  2 +-
>   drivers/spi/spi-mux.c             |  8 ++++----
>   drivers/spi/spi-mxic.c            | 10 +++++-----
>   drivers/spi/spi-mxs.c             |  2 +-
>   drivers/spi/spi-npcm-fiu.c        | 20 ++++++++++----------
>   drivers/spi/spi-nxp-fspi.c        | 10 +++++-----
>   drivers/spi/spi-omap-100k.c       |  2 +-
>   drivers/spi/spi-omap-uwire.c      |  8 ++++----
>   drivers/spi/spi-omap2-mcspi.c     | 24 ++++++++++++------------
>   drivers/spi/spi-orion.c           |  4 ++--
>   drivers/spi/spi-pci1xxxx.c        |  4 ++--
>   drivers/spi/spi-pic32-sqi.c       |  2 +-
>   drivers/spi/spi-pic32.c           |  4 ++--
>   drivers/spi/spi-pl022.c           |  4 ++--
>   drivers/spi/spi-pxa2xx.c          |  6 +++---
>   drivers/spi/spi-qcom-qspi.c       |  2 +-
>   drivers/spi/spi-rb4xx.c           |  2 +-
>   drivers/spi/spi-rockchip-sfc.c    |  2 +-
>   drivers/spi/spi-rockchip.c        | 26 ++++++++++++++------------
>   drivers/spi/spi-rspi.c            | 10 +++++-----
>   drivers/spi/spi-s3c64xx.c         |  2 +-
>   drivers/spi/spi-sc18is602.c       |  4 ++--
>   drivers/spi/spi-sh-msiof.c        |  6 +++---
>   drivers/spi/spi-sh-sci.c          |  2 +-
>   drivers/spi/spi-sifive.c          |  6 +++---
>   drivers/spi/spi-sn-f-ospi.c       |  2 +-
>   drivers/spi/spi-st-ssc4.c         |  2 +-
>   drivers/spi/spi-stm32-qspi.c      | 12 ++++++------
>   drivers/spi/spi-sun4i.c           |  2 +-
>   drivers/spi/spi-sun6i.c           |  2 +-
>   drivers/spi/spi-synquacer.c       |  6 +++---
>   drivers/spi/spi-tegra114.c        | 28 ++++++++++++++--------------
>   drivers/spi/spi-tegra20-sflash.c  |  2 +-
>   drivers/spi/spi-tegra20-slink.c   |  6 +++---
>   drivers/spi/spi-tegra210-quad.c   |  8 ++++----
>   drivers/spi/spi-ti-qspi.c         | 16 ++++++++--------
>   drivers/spi/spi-topcliff-pch.c    |  4 ++--
>   drivers/spi/spi-wpcm-fiu.c        | 12 ++++++------
>   drivers/spi/spi-xcomm.c           |  2 +-
>   drivers/spi/spi-xilinx.c          |  6 +++---
>   drivers/spi/spi-xlp.c             |  4 ++--
>   drivers/spi/spi-zynq-qspi.c       |  2 +-
>   drivers/spi/spi-zynqmp-gqspi.c    |  2 +-
>   drivers/spi/spidev.c              |  6 +++---
>   include/trace/events/spi.h        | 10 +++++-----
>   92 files changed, 315 insertions(+), 310 deletions(-)

Reviewed-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal

