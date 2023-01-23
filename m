Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C5D677B88
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjAWMr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjAWMrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:47:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963CE23C43;
        Mon, 23 Jan 2023 04:47:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDgvl3Kxp05N0umxc/FcdrfnEbd/tufajAOQoJoZXY1pUEi0R13zjYwivlfUEPioZFKWEafNpCjV/p/h0UiMNAEK4DoZw9n64PzqRJg6h+qxqNxuabwtScHSML0d2F1LW2JlDLPHHG3uKHM4Fe/VtCDXeQUVW1TaSpcuzTLIQfNiB+V2WqABPUNUGmRizeKVFSUC/igMBGKbQ4FNMUxs2Gmzybsj7BOqHlY/1JnO97oef0J1iGVW3hbcq7KAG/JeGTxdxg1zm9X+uln0M8Q3aiE53MB9OPBD/dmEnhFUCROWsGsxwJ1EGs2K0CSUjTG9oSdxH5D7I9f9f+D5NLP6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlECbNlllRJ+XvDtVY0Dsh30znVieqgvK6Xlg+acIeI=;
 b=UqE7p4SXZklKkwlHrl5wlo3466uygQTNl16VZhVNgoW/nJGNuzieLnczgRuYoNfmOE0yNaisWfh5i9GXnulyVjlyG/gbYVaQSYXhsYkKKVwG0c9CtG+jK+spDSwMEK+rRwYl6w2vIce6rFPvVFjsVFdvYsu2Shy+eUzcSpnKZ2tYE51SO4LR4ewQmcM1glxws+rOzjxSivC6QJSZQpU7d4t6SlzAj+I87SWoSx8rC0qwXsnNbThZmnE1ak72c/yOMstZo1kx/E+a+PFax0QYAZCu5sZEE2NiPfLEqwztDbOzdwoRQy1EkFND5I9Bp9lS1Rmo27qPSRLqKDDl0r4U/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tlECbNlllRJ+XvDtVY0Dsh30znVieqgvK6Xlg+acIeI=;
 b=R5YEuw0Q/X6MdZ/vQIv7pZuLCOB4rCxxlp0RuAh6e9HznKeL6IOTdhsEWijvNgwXP4pghl1WTP0ttBLAjh/XL464BBAGtKTw1rvFlzqODdtGSqmAYs4dWTnBJgkw/B0ofCWvfDA855Y2DfarBBWWqtxw57/DALy/rHtGJ2tjQhU=
Received: from BN8PR04CA0041.namprd04.prod.outlook.com (2603:10b6:408:d4::15)
 by SN7PR12MB7370.namprd12.prod.outlook.com (2603:10b6:806:299::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:47:38 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::36) by BN8PR04CA0041.outlook.office365.com
 (2603:10b6:408:d4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 12:47:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 12:47:37 +0000
Received: from [10.254.241.50] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 06:47:06 -0600
Message-ID: <ad9a794d-e736-f209-d31b-ae79cdd8b127@amd.com>
Date:   Mon, 23 Jan 2023 13:47:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 04/13] iio: imu: Replace all spi->chip_select and
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
 <20230119185342.2093323-5-amit.kumar-mahapatra@amd.com>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <20230119185342.2093323-5-amit.kumar-mahapatra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT060:EE_|SN7PR12MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: a0377c2d-c910-4298-8bda-08dafd4001d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utUlO6sbAnIW/MVdjOsDKDZqfn37ajaXZZ83HARgjc9bF0FLcHPC8U4YKeO6Xh0SqmOyL2i8jk/bijGXismvggdZkenTougZF71JDHFZJ0V6A/EF32FfTb2lPCrbf5FhAz7f7V5UdVJN+Nya9TPxUw+mbQXsmfCOB/zW3y3eMAjSZV1ScXI9GA7ESS4xFFQf8EE7I0G0rcxNu+ZS4Ivqy070F04S/lWRbgKVZSBMXv39lRA7xtiBCDzzTEzoCwspWp+GezK7pvDKj2OLs33OiW/SNMr4mi0HqwUhKt9RQ98f6wUfsF+PDbsw7N4EjG966vSSgeX161yjCQ2xcByWObxakl0fa/KnLjJ7mLgwLnE4vnVjVrxrCTBGhXdk4WvMmMfy632fHVBHTMTigH+OQxfr9j6e3SGHHELQloV0ccdTYUPQTQi9xEy5p8/k74Y4nxhjy9bA6EVAyo1Fd3n0Z6G4kSyiNa579xJegFvzgZm/Kd4kVU5fFipg5Jfc4BCMw3D4dj6wiq1vRGBnDch4BB/irtuSjOfNqnh4aIx+aPbKRCWgSocMl5wVc1K9jGAPrFHOCdF+RPTmGRZME1cfPVDxtFHk80vN2d7EgLn241Qkxx3DKsx8BrKg5yUcYO8/qvR8FvCJLAHzPxEXHVoDT2XsgfzWzqA8tRwUlqRAjvRhvlw0Dk/xgIgP/F1r8atDDMkwMXP8HAxO5tUuobk7rx9rLmhwvRkWtunEtFuXi/XFLBjBrI2QJQIYfJFoqNEvgE2ZAeCbrOQD1q4YFoZugo4Bmg40kVZjb70lzHtRjfdI5LQ1UEcG8Ts46LKnZ0pRpqLOmP7qApcU111hRy/Q77rnr9nvf0OIzIHwnr+bGicd5Re66v4q9GIIC3AQ4hi0+2Z4pH5F4ohQIoJ3pLfSMQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(36860700001)(83380400001)(31696002)(82740400003)(2906002)(5660300002)(7416002)(921005)(86362001)(7276002)(81166007)(44832011)(41300700001)(7366002)(356005)(7336002)(7406005)(4326008)(8936002)(82310400005)(40480700001)(40460700003)(1191002)(8676002)(26005)(53546011)(16526019)(186003)(336012)(47076005)(426003)(316002)(16576012)(70206006)(2616005)(70586007)(54906003)(478600001)(110136005)(31686004)(36756003)(2101003)(83996005)(84006005)(36900700001)(41080700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:47:37.5708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0377c2d-c910-4298-8bda-08dafd4001d9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7370
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
>   drivers/iio/imu/adis16400.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
> index c02fc35dceb4..3eda32e12a53 100644
> --- a/drivers/iio/imu/adis16400.c
> +++ b/drivers/iio/imu/adis16400.c
> @@ -466,7 +466,7 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
>   
>   		dev_info(&indio_dev->dev, "%s: prod_id 0x%04x at CS%d (irq %d)\n",
>   			indio_dev->name, prod_id,
> -			st->adis.spi->chip_select, st->adis.spi->irq);
> +			spi_get_chipselect(st->adis.spi, 0), st->adis.spi->irq);
>   	}
>   	/* use high spi speed if possible */
>   	if (st->variant->flags & ADIS16400_HAS_SLOW_MODE) {

Reviewed-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal
