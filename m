Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532C9677B7D
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjAWMrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjAWMrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:47:40 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC2193DC;
        Mon, 23 Jan 2023 04:47:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyb7A8Xj0HIsgLLUec5ensnmdbqmI9nn/l2GNoOIlkcZuWuovM7doLOe3O6L1WajbWZgZBwoN36iuEAWgOFlnwzFypBPkSa90BQVvAmgSPazNh7RAoG2DwQMDBK2ymxJfdz2mr9ZKMK0Xnelwc1F5olXhGPMhwzLR0QzQK+OFVS0yqK3GtOWf1W8hJGSw9URcMtAoEr3/VzJ7P+jroDMpNkRwlzvfWIjLdFlP71satfaJRB/TajONm3JLTNQyEfJZWNzR3rMEpMXDEJtPNhSACvume9UWhnByRbtqgPrMBqigD+ztLMAJkUj7bXi0lMwUnb3tFP9IHxE8HRYX93rXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/XbvYKhMn1GQQO16hguq9qQJfCGckFggfjDngpJ57aE=;
 b=FftuxB6Qkj5NhuR0R1CeyIjy5+12nOhU93mcc8z4ulYbXH271n3FQZ7tuzkfN58HA0rpOvVU8pVaTPkyyMca9muqtso2U9q2fj24zHo/1nz9M3T3ZDlNR3QsZhGNT/yqjLBsWc7XcD2YDWQ2R2+89h3O4VoVtJ+2W7uJPDQEcL35mD0vuhESH6RP0HVfJDFUhuZ+SZZYqHLAPqWAXZZEvl63GyE2YKap26gVHbjhIicaLOtSKkawpltSp9kWqxb0XMAk2F704tC3a3L3KArWaUhaeiiO27kW1tLtJDoMph6rJ/LGFeh/zGEkCFfpDz7/vT/EGWG6r4m8EifGwS+yig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XbvYKhMn1GQQO16hguq9qQJfCGckFggfjDngpJ57aE=;
 b=v4Z725Nl+XiUwwNOHqzGnwRkd7PcchgvnP022qMPM4nojGaYYwF+tA9ZadpdPHWrWO1JmHOXXahKh+t7KRfOK42gSx/65SYFFre1Ntag4elYpBDfxc/1x0vI47i+hZ6xCMH862tBrf95BukqXEq0nIBFuOSIKRnnwXLkEQeueWM=
Received: from BN1PR12CA0003.namprd12.prod.outlook.com (2603:10b6:408:e1::8)
 by SA1PR12MB7412.namprd12.prod.outlook.com (2603:10b6:806:2b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:47:26 +0000
Received: from BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::50) by BN1PR12CA0003.outlook.office365.com
 (2603:10b6:408:e1::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 12:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT093.mail.protection.outlook.com (10.13.177.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 12:47:25 +0000
Received: from [10.254.241.50] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 06:46:54 -0600
Message-ID: <5eaa0e63-74c1-df79-58aa-f24da9b05566@amd.com>
Date:   Mon, 23 Jan 2023 13:46:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 03/13] net: Replace all spi->chip_select and
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
 <20230119185342.2093323-4-amit.kumar-mahapatra@amd.com>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <20230119185342.2093323-4-amit.kumar-mahapatra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT093:EE_|SA1PR12MB7412:EE_
X-MS-Office365-Filtering-Correlation-Id: 248878b4-40fc-4fea-01c4-08dafd3ffac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7DszFor7hMqbTV8rM/3tReKJdfA5PS+fjQBZHEKqRE4slYDu2qDNGJxiHppk1MsQDdJJsRBQEbEtrqEoHYHv2TULfRwPqUKuxT/BJFPmI/Tnl65+ZBqANEGXhlVXx06+Pk/SPUZTaYA+zWbEZG8I0yFUKXHoWy8nvIXXPpExDvrxhyvDY33VOoJGRKbmdnaSKOLcAJM94jI4I3l4l8iyyVTVah/dA5nGly1ZqzMarsOTtLJKA7AKYcm1keL5zA9eSndG9Zqm/htjfANDZqpvoiwpEmbFPyU/WE78ZCBFLk4p2uZ1UPwZDDqoHUZMrHH+zKB/Ut9pYD4HBzXAK9LkA3nSraZSC9sFV7ybb3LEI5BJOwEvK+JAm+B6AftT7WnmbGNkeuNKNso6bmLW+W+drFfPPz4dM7dl9rtqCbEPxEyrbGVIXkMEwqd3KJrTTwMV4D8Osm7zrJT2FFnr3FvLR9lFeJqxEjGhllJBSTQcH/OVT0ZzvxgYIj95XIllFrjQMPqrT7Tk+xQ9ipkEnMqBNDN+b1RztBWNqF1X5i6U6wmomX5g3eTAgu9oxT8WjiAgrv5Yb942vsCXtjnou4OguzM2H339HfzaXmGsMxJ80VB9xx/ERK2paKcLuwd2l61nD9ftNXJpofX3mdge1WCsDwmdnTr+25OLLvGAT8rfRO6SLE/FNK/B3gnoJvgoARhJD6Va7BWsL8y739jQXaWnm+4xYLuxbyrTHdztYL4v+tMjevjEtUJqtbRMwmtlCupwl8mKY2PSceI49Hhzbv3sImF93J9CBSoI5MoACQDiq6e52ui6E7tE2aQ0eNzjPKl0C1h9/Bf8As/+q6tCFI4FLp56nSRwkUq3hsZ5LGXwldq6toTKXysV1L50/ESKbuTDAk1HJURzBzeZ12uKs18eQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(31686004)(81166007)(2616005)(336012)(2906002)(82740400003)(426003)(41300700001)(31696002)(82310400005)(5660300002)(7416002)(7366002)(7406005)(7276002)(7336002)(40460700003)(8936002)(44832011)(47076005)(4326008)(316002)(110136005)(70206006)(54906003)(16576012)(36756003)(26005)(16526019)(186003)(8676002)(1191002)(36860700001)(70586007)(86362001)(921005)(356005)(478600001)(83380400001)(40480700001)(6666004)(53546011)(41080700001)(83996005)(84006005)(2101003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:47:25.7118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 248878b4-40fc-4fea-01c4-08dafd3ffac8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7412
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
>   drivers/net/ethernet/adi/adin1110.c            | 2 +-
>   drivers/net/ethernet/asix/ax88796c_main.c      | 2 +-
>   drivers/net/ethernet/davicom/dm9051.c          | 2 +-
>   drivers/net/ethernet/qualcomm/qca_debug.c      | 2 +-
>   drivers/net/ieee802154/ca8210.c                | 2 +-
>   drivers/net/wan/slic_ds26522.c                 | 2 +-
>   drivers/net/wireless/marvell/libertas/if_spi.c | 2 +-
>   drivers/net/wireless/silabs/wfx/bus_spi.c      | 2 +-
>   drivers/net/wireless/st/cw1200/cw1200_spi.c    | 2 +-
>   9 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
> index 0805f249fff2..aee7a98725ba 100644
> --- a/drivers/net/ethernet/adi/adin1110.c
> +++ b/drivers/net/ethernet/adi/adin1110.c
> @@ -515,7 +515,7 @@ static int adin1110_register_mdiobus(struct adin1110_priv *priv,
>   		return -ENOMEM;
>   
>   	snprintf(priv->mii_bus_name, MII_BUS_ID_SIZE, "%s-%u",
> -		 priv->cfg->name, priv->spidev->chip_select);
> +		 priv->cfg->name, spi_get_chipselect(priv->spidev, 0));
>   
>   	mii_bus->name = priv->mii_bus_name;
>   	mii_bus->read = adin1110_mdio_read;
> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
> index 21376c79f671..e551ffaed20d 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -1006,7 +1006,7 @@ static int ax88796c_probe(struct spi_device *spi)
>   	ax_local->mdiobus->parent = &spi->dev;
>   
>   	snprintf(ax_local->mdiobus->id, MII_BUS_ID_SIZE,
> -		 "ax88796c-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +		 "ax88796c-%s.%u", dev_name(&spi->dev), spi_get_chipselect(spi, 0));
>   
>   	ret = devm_mdiobus_register(&spi->dev, ax_local->mdiobus);
>   	if (ret < 0) {
> diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
> index de7105a84747..70728b2e5f18 100644
> --- a/drivers/net/ethernet/davicom/dm9051.c
> +++ b/drivers/net/ethernet/davicom/dm9051.c
> @@ -1123,7 +1123,7 @@ static int dm9051_mdio_register(struct board_info *db)
>   	db->mdiobus->phy_mask = (u32)~BIT(1);
>   	db->mdiobus->parent = &spi->dev;
>   	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
> -		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +		 "dm9051-%s.%u", dev_name(&spi->dev), spi_get_chipselect(spi, 0));
>   
>   	ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
>   	if (ret)
> diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
> index f62c39544e08..6f2fa2a42770 100644
> --- a/drivers/net/ethernet/qualcomm/qca_debug.c
> +++ b/drivers/net/ethernet/qualcomm/qca_debug.c
> @@ -119,7 +119,7 @@ qcaspi_info_show(struct seq_file *s, void *what)
>   	seq_printf(s, "SPI mode         : %x\n",
>   		   qca->spi_dev->mode);
>   	seq_printf(s, "SPI chip select  : %u\n",
> -		   (unsigned int)qca->spi_dev->chip_select);
> +		   (unsigned int)spi_get_chipselect(qca->spi_dev, 0));
>   	seq_printf(s, "SPI legacy mode  : %u\n",
>   		   (unsigned int)qca->legacy_mode);
>   	seq_printf(s, "SPI burst length : %u\n",
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index e1a569b99e4a..7093a07141bb 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2967,7 +2967,7 @@ static int ca8210_test_interface_init(struct ca8210_priv *priv)
>   		sizeof(node_name),
>   		"ca8210@%d_%d",
>   		priv->spi->master->bus_num,
> -		priv->spi->chip_select
> +		spi_get_chipselect(priv->spi, 0)
>   	);
>   
>   	test->ca8210_dfs_spi_int = debugfs_create_file(
> diff --git a/drivers/net/wan/slic_ds26522.c b/drivers/net/wan/slic_ds26522.c
> index 6063552cea9b..8a51cfcff99e 100644
> --- a/drivers/net/wan/slic_ds26522.c
> +++ b/drivers/net/wan/slic_ds26522.c
> @@ -211,7 +211,7 @@ static int slic_ds26522_probe(struct spi_device *spi)
>   
>   	ret = slic_ds26522_init_configure(spi);
>   	if (ret == 0)
> -		pr_info("DS26522 cs%d configured\n", spi->chip_select);
> +		pr_info("DS26522 cs%d configured\n", spi_get_chipselect(spi, 0));
>   
>   	return ret;
>   }
> diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net/wireless/marvell/libertas/if_spi.c
> index ff1c7ec8c450..1225fc0e3352 100644
> --- a/drivers/net/wireless/marvell/libertas/if_spi.c
> +++ b/drivers/net/wireless/marvell/libertas/if_spi.c
> @@ -1051,7 +1051,7 @@ static int if_spi_init_card(struct if_spi_card *card)
>   				"spi->max_speed_hz=%d\n",
>   				card->card_id, card->card_rev,
>   				card->spi->master->bus_num,
> -				card->spi->chip_select,
> +				spi_get_chipselect(card->spi, 0),
>   				card->spi->max_speed_hz);
>   		err = if_spi_prog_helper_firmware(card, helper);
>   		if (err)
> diff --git a/drivers/net/wireless/silabs/wfx/bus_spi.c b/drivers/net/wireless/silabs/wfx/bus_spi.c
> index 7fb1afb8ed31..160b90114aad 100644
> --- a/drivers/net/wireless/silabs/wfx/bus_spi.c
> +++ b/drivers/net/wireless/silabs/wfx/bus_spi.c
> @@ -208,7 +208,7 @@ static int wfx_spi_probe(struct spi_device *func)
>   
>   	/* Trace below is also displayed by spi_setup() if compiled with DEBUG */
>   	dev_dbg(&func->dev, "SPI params: CS=%d, mode=%d bits/word=%d speed=%d\n",
> -		func->chip_select, func->mode, func->bits_per_word, func->max_speed_hz);
> +		spi_get_chipselect(func, 0), func->mode, func->bits_per_word, func->max_speed_hz);
>   	if (func->bits_per_word != 16 && func->bits_per_word != 8)
>   		dev_warn(&func->dev, "unusual bits/word value: %d\n", func->bits_per_word);
>   	if (func->max_speed_hz > 50000000)
> diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wireless/st/cw1200/cw1200_spi.c
> index fe0d220da44d..c82c0688b549 100644
> --- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
> +++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
> @@ -378,7 +378,7 @@ static int cw1200_spi_probe(struct spi_device *func)
>   	func->mode = SPI_MODE_0;
>   
>   	pr_info("cw1200_wlan_spi: Probe called (CS %d M %d BPW %d CLK %d)\n",
> -		func->chip_select, func->mode, func->bits_per_word,
> +		spi_get_chipselect(func, 0), func->mode, func->bits_per_word,
>   		func->max_speed_hz);
>   
>   	if (cw1200_spi_on(plat_data)) {


Reviewed-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal

