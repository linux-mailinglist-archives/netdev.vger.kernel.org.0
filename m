Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F09D677C3E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjAWNSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjAWNSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:18:00 -0500
Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F2A126E4;
        Mon, 23 Jan 2023 05:17:56 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.167])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 731DB2B568;
        Mon, 23 Jan 2023 13:10:17 +0000 (UTC)
Received: from kaod.org (37.59.142.109) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Mon, 23 Jan
 2023 14:10:10 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-109S0035e8cf7e5-490b-4306-97b9-26c7bcdb01f8,
                    A67B952EB2D8D9A0A9F9E7F867E869D975DF4B5D) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <d1743abc-3d9f-cdf4-dfbe-67aac4b1b8cd@kaod.org>
Date:   Mon, 23 Jan 2023 14:10:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 02/13] spi: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Content-Language: en-US
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <sanju.mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
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
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
 <20230119185342.2093323-3-amit.kumar-mahapatra@amd.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230119185342.2093323-3-amit.kumar-mahapatra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.109]
X-ClientProxiedBy: DAG6EX2.mxp5.local (172.16.2.52) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: d8c081e3-7749-496f-b92b-664d73f13c17
X-Ovh-Tracer-Id: 9743537793859029808
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedruddukedgfeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeffudefleeiudejfeffhfejffeigffhhffhvdekieejheelvdeufffhjedtheeggeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtoheprghmihhtrdhkuhhmrghrqdhmrghhrghprghtrhgrsegrmhgurdgtohhmpdhkohhnrhgrugdrugihsggtihhosehsohhmrghinhhlihhnvgdrohhrghdphihoghgvshhhghgruhhrrdekfeesghhmrghilhdrtghomhdpsggvnhhjrghmihhnfhgrihhrsehgohhoghhlvgdrtghomhdphihuvghnnhesghhoohhglhgvrdgtohhmpdhvvghnthhurhgvsehgohhoghhlvgdrtghomhdpthgrlhhirdhpvghrrhihudesghhmrghilhdrtghomhdpthhmrghimhhonhejjeesghhmrghilhdrtg
 homhdprghvihhfihhshhhmrghnjedtsehgmhgrihhlrdgtohhmpdhmrghrthhinhdrsghluhhmvghnshhtihhnghhlsehgohhoghhlvghmrghilhdrtghomhdplhhinhhugidqihhmgiesnhigphdrtghomhdpfhgvshhtvghvrghmsehgmhgrihhlrdgtohhmpdgrlhhimhdrrghkhhhtrghrsehsrghmshhunhhgrdgtohhmpdhkvghrnhgvlhesphgvnhhguhhtrhhonhhigidruggvpdgstghmqdhkvghrnhgvlhdqfhgvvggusggrtghkqdhlihhsthessghrohgruggtohhmrdgtohhmpdgtlhgruhguihhurdgsvgiinhgvrgesmhhitghrohgthhhiphdrtghomhdprghlvgigrghnughrvgdrsggvlhhlohhnihessghoohhtlhhinhdrtghomhdpnhhitgholhgrshdrfhgvrhhrvgesmhhitghrohgthhhiphdrtghomhdprhgrughupghnihgtohhlrggvrdhpihhrvggrsehuphgsrdhrohdprghnughrvgifsegrjhdrihgurdgruhdpjhhovghlsehjmhhsrdhiugdrrghupdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhinhhugidqshhpihesvhhgvghrrdhkvghrnhgvlhdrohhrghdpghhithesrghmugdrtghomhdpghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhfrghntggvrhdrlhgrnhgtvghrsehgmhgrihhlrdgtohhmpdhluggvfigrnhhgrghnsehnvhhiughirgdrtghomhdpmhhitghhrghlrdhsihhmvghksegrmhgurdgtohhmpdhlihhnuhigqdgrshhpvggvuge
 slhhishhtshdrohiilhgrsghsrdhorhhgpdhgrhgvhigsuhhsqdguvghvsehlihhsthhsrdhlihhnrghrohdrohhrghdpughrihdquggvvhgvlheslhhishhtshdrfhhrvggvuggvshhkthhophdrohhrghdplhhinhhugidqmhgvughirgesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhinhhugidqrhhishgtvheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdpphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhmihgthhgrvghlseifrghllhgvrdgttgdplhhinhhugidqihhiohesvhhgvghrrdhkvghrnhgvlhdrohhrghdpofhitghhrggvlhdrjfgvnhhnvghrihgthhesrghnrghlohhgrdgtohhmpdhlrghrshesmhgvthgrfhhoohdruggvpdhlihhnuhigqdhmthgusehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhlihhnuhigqdifihhrvghlvghsshesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhisggvrhhtrghsqdguvghvsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhlihhnuhigqdifphgrnhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhtvghgrhgrsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhsuhhngihisehlihhsthhsrdhlihhnuhigrdguvghvpdhlihhnuhigqdhsthhmfedvsehsthdqmhguqdhmrghilhhmrghnrdhsthhorhhmrhgvphhlhidrtghomhdplhhinhhugidqshgrmhhsuhhn
 ghdqshhotgesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhinhhugidqrhhotghktghhihhpsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhlihhnuhigqdgrrhhmqdhmshhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhmvgguihgrthgvkheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdplhhinhhugidqrghmlhhoghhitgeslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdplhhinhhugidqrhhpihdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdpohhpvghnsghmtgeslhhishhtshdrohiilhgrsghsrdhorhhgpdgvlhguvghrsehkvghrnhgvlhdrohhrghdplhhinhhugidqshhtrghgihhngheslhhishhtshdrlhhinhhugidruggvvhdpjhhohhgrnheskhgvrhhnvghlrdhorhhgpdhvihhrvghshhhksehkvghrnhgvlhdrohhrghdphhgrohhjihgrnhdriihhuhgrnhhgsehgmhgrihhlrdgtohhmpdgurghnihgvlhesiihonhhquhgvrdhorhhgpdhlihhnuhhsrdifrghllhgvihhjsehlihhnrghrohdrohhrghdphhgrihgsohdrtghhvghnsehngihprdgtohhmpdhmrghtthhhihgrshdrsghgghesghhmrghilhdrtghomhdpshdrhhgruhgvrhesphgvnhhguhhtrhhonhhigidruggvpdhshhgrfihnghhuoheskhgvrhhnvghlrdhorhhgpdhjohhhnhdrghgrr
 hhrhieshhhurgifvghirdgtohhmpdhhrghnrdiguhesnhigphdrtghomhdpohhlthgvrghnvhesghhmrghilhdrtghomhdpvggrjhgrmhgvsheslhhinhhugidrihgsmhdrtghomhdprhhosggvrhhtrdhjrghriihmihhksehfrhgvvgdrfhhrpdhssghrrghnuggvnhessghrohgruggtohhmrdgtohhmpdhfrdhfrghinhgvlhhlihesghhmrghilhdrtghomhdpkhgurghsuhdrkhguvghvsehgmhgrihhlrdgtohhmpdgthhhinhdqthhinhhgpghkuhhosegrshhpvggvughtvggthhdrtghomhdpshgrnhhjuhdrmhgvhhhtrgesrghmugdrtghomhdpphhrrghthihushhhsehkvghrnhgvlhdrohhrghdpthhuughorhdrrghmsggrrhhushesmhhitghrohgthhhiphdrtghomhdpjhhitgdvfeeskhgvrhhnvghlrdhorhhgpdhvihhgnhgvshhhrhesthhirdgtohhmpdhrihgthhgrrhgusehnohgurdgrthdpmhhiqhhuvghlrdhrrgihnhgrlhessghoohhtlhhinhdrtghomhdpsghrohhonhhivgeskhgvrhhnvghlrdhorhhgpdhrjhhuihessghrohgruggtohhmrdgtohhmpdgrghhrohhssheskhgvrhhnvghlrdhorhhgpdgsjhhorhhnrdgrnhguvghrshhsohhnsehlihhnrghrohdrohhrghdphhgvihhkohesshhnthgvtghhrdguvgdpjhdrnhgvuhhstghhrggvfhgvrhesghhmgidrnhgvthdptghhrhhishhtihgrnhdrkhhovghnihhgsegrmhgurdgtohhmpdhsuhhmihhtrdhsvghmfigrlheslhhinhgrrhhordhorhhgpdhskh
 homhgrthhinhgvnhhisehnvhhiughirgdrtghomhdpjhhonhgrthhhrghnhhesnhhvihguihgrrdgtohhmpdhthhhivghrrhihrdhrvgguihhnghesghhmrghilhdrtghomhdpkhhvrghloheskhgvrhhnvghlrdhorhhgpdhsthgvfhgrnhesuggrthgvnhhfrhgvihhhrghfvghnrdhorhhgpdgrlhgvgidrrghrihhnghesghhmrghilhdrtghomhdpphgrsggvnhhisehrvgguhhgrthdrtghomhdpkhhusggrsehkvghrnhgvlhdrohhrghdpvgguuhhmrgiivghtsehgohhoghhlvgdrtghomhdpuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdplhdrshhtvghlmhgrtghhsehsrghmshhunhhgrdgtohhmpdhmihhnghhosehrvgguhhgrthdrtghomhdprhhoshhtvgguthesghhoohgumhhishdrohhrghdpjhgrshifihhnuggvrhdrshhinhhghheslhhinhgrrhhordhorhhgpdhmrghsrghhihhsrgdrkhhojhhimhgrsehlihhnrghrohdrohhrghdpshgrmhhuvghlsehshhholhhlrghnugdrohhrghdpjhgvrhhnvghjrdhskhhrrggsvggtsehgmhgrihhlrdgtohhmpdifvghnshestghsihgvrdhorhhgpdgrlhgvgigrnhgurhgvrdhtohhrghhuvgesfhhoshhsrdhsthdrtghomhdpmhgtohhquhgvlhhinhdrshhtmhefvdesghhmrghilhdrtghomhdprghnughisegvthgviihirghnrdhorhhgpdhkrhiihihsiihtohhfrdhkohiilhhofihskhhisehlihhnrghrohdrohhrghdprhhmfhhrfhhssehgmhgrihhlrdgtohhmpdg
 rmhhithhrkhgtihgrnhdvtddtvdesghhmrghilhdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/23 19:53, Amit Kumar Mahapatra wrote:
> diff --git a/drivers/spi/spi-aspeed-smc.c b/drivers/spi/spi-aspeed-smc.c
> index 873ff2cf72c9..b7a9ec550ba1 100644
> --- a/drivers/spi/spi-aspeed-smc.c
> +++ b/drivers/spi/spi-aspeed-smc.c
> @@ -296,7 +296,7 @@ static const struct aspeed_spi_data ast2400_spi_data;
>   static int do_aspeed_spi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
>   {
>   	struct aspeed_spi *aspi = spi_controller_get_devdata(mem->spi->master);
> -	struct aspeed_spi_chip *chip = &aspi->chips[mem->spi->chip_select];
> +	struct aspeed_spi_chip *chip = &aspi->chips[spi_get_chipselect(mem->spi, 0)];
>   	u32 addr_mode, addr_mode_backup;
>   	u32 ctl_val;
>   	int ret = 0;
> @@ -377,7 +377,8 @@ static const char *aspeed_spi_get_name(struct spi_mem *mem)
>   	struct aspeed_spi *aspi = spi_controller_get_devdata(mem->spi->master);
>   	struct device *dev = aspi->dev;
>   
> -	return devm_kasprintf(dev, GFP_KERNEL, "%s.%d", dev_name(dev), mem->spi->chip_select);
> +	return devm_kasprintf(dev, GFP_KERNEL, "%s.%d", dev_name(dev),
> +			      spi_get_chipselect(mem->spi, 0));
>   }
>   
>   struct aspeed_spi_window {
> @@ -553,7 +554,7 @@ static int aspeed_spi_do_calibration(struct aspeed_spi_chip *chip);
>   static int aspeed_spi_dirmap_create(struct spi_mem_dirmap_desc *desc)
>   {
>   	struct aspeed_spi *aspi = spi_controller_get_devdata(desc->mem->spi->master);
> -	struct aspeed_spi_chip *chip = &aspi->chips[desc->mem->spi->chip_select];
> +	struct aspeed_spi_chip *chip = &aspi->chips[spi_get_chipselect(desc->mem->spi, 0)];
>   	struct spi_mem_op *op = &desc->info.op_tmpl;
>   	u32 ctl_val;
>   	int ret = 0;
> @@ -620,7 +621,7 @@ static ssize_t aspeed_spi_dirmap_read(struct spi_mem_dirmap_desc *desc,
>   				      u64 offset, size_t len, void *buf)
>   {
>   	struct aspeed_spi *aspi = spi_controller_get_devdata(desc->mem->spi->master);
> -	struct aspeed_spi_chip *chip = &aspi->chips[desc->mem->spi->chip_select];
> +	struct aspeed_spi_chip *chip = &aspi->chips[spi_get_chipselect(desc->mem->spi, 0)];
>   
>   	/* Switch to USER command mode if mapping window is too small */
>   	if (chip->ahb_window_size < offset + len) {
> @@ -670,7 +671,7 @@ static int aspeed_spi_setup(struct spi_device *spi)
>   {
>   	struct aspeed_spi *aspi = spi_controller_get_devdata(spi->master);
>   	const struct aspeed_spi_data *data = aspi->data;
> -	unsigned int cs = spi->chip_select;
> +	unsigned int cs = spi_get_chipselect(spi, 0);
>   	struct aspeed_spi_chip *chip = &aspi->chips[cs];
>   
>   	chip->aspi = aspi;
> @@ -697,7 +698,7 @@ static int aspeed_spi_setup(struct spi_device *spi)
>   static void aspeed_spi_cleanup(struct spi_device *spi)
>   {
>   	struct aspeed_spi *aspi = spi_controller_get_devdata(spi->master);
> -	unsigned int cs = spi->chip_select;
> +	unsigned int cs = spi_get_chipselect(spi, 0);
>   
>   	aspeed_spi_chip_enable(aspi, cs, false);
>   

For the Aspeed driver,

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.
