Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C455769CC01
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 14:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjBTNXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 08:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBTNXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 08:23:32 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230097EC6;
        Mon, 20 Feb 2023 05:23:30 -0800 (PST)
Received: from mercury (dyndsl-095-033-158-068.ewe-ip-backbone.de [95.33.158.68])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id DCA126602161;
        Mon, 20 Feb 2023 13:23:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676899408;
        bh=EpofNz6MD/mPoCdRuSgO8/RJyETCbQR5Uv8NTsFxb3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iBi51yqn4jM/lciw1DbbnBma1n0Mje98qEA4nparqS0AovBX2Z312SVd0ATM8aMoK
         NHcPWSIEJYTfa1uIldlewrSL01WfA0qFizBwyDJbW5zvgYjBMxZEKA2YQA0iMEx+nP
         G7703Hja/yfjXuVbXFRvp9Q+F7MPRSQvMmCRyb8hZVUuSwYzyX/Ix9X5IiwvpBDzSi
         vwyUvQ7OXQ2r3AxmokbSeSMxi18CQ+wb0CE+bvjXceTu82JgfAAEmxDh5eKE9tDNoP
         mngHYZtCTl8JjVegYl8wsW5VvB40j1AYZAP6fYk5zYdf4CvfnaXOgpTXbf2f63JkZN
         PPU+qn9bBJv6w==
Received: by mercury (Postfix, from userid 1000)
        id C04E310603FE; Mon, 20 Feb 2023 14:23:25 +0100 (CET)
Date:   Mon, 20 Feb 2023 14:23:25 +0100
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Talel Shenhar <talel@amazon.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Tim Zimmermann <tim@linux4.de>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Jiang Jian <jiangjian@cdjrlc.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Balsam CHIHI <bchihi@baylibre.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "open list:ACPI THERMAL DRIVER" <linux-acpi@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE MONITORING" <linux-hwmon@vger.kernel.org>,
        "open list:IIO SUBSYSTEM AND DRIVERS" <linux-iio@vger.kernel.org>,
        "open list:ARM/Allwinner sunXi SoC support" 
        <linux-sunxi@lists.linux.dev>,
        "open list:INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN)..." 
        <linux-input@vger.kernel.org>,
        "open list:CXGB4 ETHERNET DRIVER (CXGB4)" <netdev@vger.kernel.org>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "moderated list:BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE" 
        <linux-rpi-kernel@lists.infradead.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        "open list:RENESAS R-CAR THERMAL DRIVERS" 
        <linux-renesas-soc@vger.kernel.org>,
        "open list:ARM/Rockchip SoC support" 
        <linux-rockchip@lists.infradead.org>,
        "open list:SAMSUNG THERMAL DRIVER" 
        <linux-samsung-soc@vger.kernel.org>,
        "open list:TEGRA ARCHITECTURE SUPPORT" <linux-tegra@vger.kernel.org>,
        "open list:TI BANDGAP AND THERMAL DRIVER" 
        <linux-omap@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata'
 accessor
Message-ID: <20230220132325.ksmho3p54zr2hm4a@mercury.elektranox.org>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
 <20230219143657.241542-2-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="amobsqjguregida6"
Content-Disposition: inline
In-Reply-To: <20230219143657.241542-2-daniel.lezcano@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--amobsqjguregida6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Feb 19, 2023 at 03:36:41PM +0100, Daniel Lezcano wrote:
> The thermal zone device structure is exposed to the different drivers
> and obviously they access the internals while that should be
> restricted to the core thermal code.
>=20
> In order to self-encapsulate the thermal core code, we need to prevent
> the drivers accessing directly the thermal zone structure and provide
> accessor functions to deal with.
>=20
> Provide an accessor to the 'devdata' structure and make use of it in
> the different drivers.
>=20
> No functional changes intended.
>=20
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---

=2E..

>  drivers/power/supply/power_supply_core.c         |  2 +-

=2E..

> diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/sup=
ply/power_supply_core.c
> index 7c790c41e2fe..166f0aacc797 100644
> --- a/drivers/power/supply/power_supply_core.c
> +++ b/drivers/power/supply/power_supply_core.c
> @@ -1142,7 +1142,7 @@ static int power_supply_read_temp(struct thermal_zo=
ne_device *tzd,
>  	int ret;
> =20
>  	WARN_ON(tzd =3D=3D NULL);
> -	psy =3D tzd->devdata;
> +	psy =3D thermal_zone_device_get_data(tzd);
>  	ret =3D power_supply_get_property(psy, POWER_SUPPLY_PROP_TEMP, &val);
>  	if (ret)
>  		return ret;

Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>

-- Sebastian

--amobsqjguregida6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmPzdEUACgkQ2O7X88g7
+pqrPhAAkn4PMww+rZzWWUIzn70JDaIM3pB6g/TwmnMJQSvxVt5bbeRkHs1Hr5p1
wJGp1GJhv3odUIaoBVctwLzVrbnN6+o9V1WGAb73ZzZF86thow7pq49z46JaGsVU
lmYF3cu7le+yv8hs1kdRFs8NQ8C3dJ5dodlCZMJIsIelJhyQciziF5Mkq395HKtm
6xu/xCNssRmZhqy3yJYazBjGrqAneN9LelyMQQ4/MqeK64xdYgcz4tJ4kZ8WYrmz
SC0Jc2aCHnm8YCTIgZHNdpRMeLAiMfQm/htrcXbwMzdfmu+K2eAb8TzI6cOS/4dF
usYhuvr3S8YXKhyzxrZC/E1p0s0QdDQsZFBq9+2Dc84uKmAXfaGCr1IEWnXW2X39
eqskyqWCteRO6EDM30xlV4joURLzlk5mb4f76dW9tfr7poEn+I99L+zkL/ghvStP
sJ7cISSMIbfAHqBUaICaiZ0A51GyhTlfwdvVBxbZKRuDLYOhO4YKlI57Cl+qiMEp
lVUJ1jcN0HiyOHfDkchkbPC1XYBfoPkxeQxAIJy5WCSg4vMs8Moa2PTuZHaovfUr
Q8iJpfdk10e7gSUWSFPAogdiUi5gFlJs4ZiJ9Nim7l9FY7txWceX3pBzB3AbaVOn
Sl1m3OJVy+tYn/RDEZa3Ofwu/HPOwxWEO/X0pZb/q/yk9/4c/Xs=
=Z9fm
-----END PGP SIGNATURE-----

--amobsqjguregida6--
