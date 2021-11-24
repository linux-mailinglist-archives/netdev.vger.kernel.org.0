Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56045C88B
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhKXPYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:24:32 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4159 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhKXPY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 10:24:29 -0500
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Hzl7x66WJz67x9G;
        Wed, 24 Nov 2021 23:20:45 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 16:21:16 +0100
Received: from localhost (10.52.122.252) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 24 Nov
 2021 15:21:14 +0000
Date:   Wed, 24 Nov 2021 15:21:12 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        "Jonathan Cameron" <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Lorenzo Bianconi" <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Amit Kucheria" <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-clk@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-aspeed@lists.ozlabs.org>,
        <openbmc@lists.ozlabs.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: Re: [PATCH/RFC 08/17] iio: humidity: hts221: Use bitfield helpers
Message-ID: <20211124152112.000078bf@Huawei.com>
In-Reply-To: <c906f7449c0210cefba53eab2c2d87105d5c8599.1637592133.git.geert+renesas@glider.be>
References: <cover.1637592133.git.geert+renesas@glider.be>
        <c906f7449c0210cefba53eab2c2d87105d5c8599.1637592133.git.geert+renesas@glider.be>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.122.252]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 16:54:01 +0100
Geert Uytterhoeven <geert+renesas@glider.be> wrote:

> Use the field_prep() helper, instead of open-coding the same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Hi Geert,

If this should got forwards, looks like a nice cleanup for the two IIO
ones, so I'll be happy to pick them up once infrastructure in place
(ideally have the infrastructure an immutable branch to save having
to revisit in 3+ months time!)

Jonathan

> ---
> Compile-tested only.
> Marked RFC, as this depends on [PATCH 01/17], but follows a different
> path to upstream.
> ---
>  drivers/iio/humidity/hts221_core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iio/humidity/hts221_core.c b/drivers/iio/humidity/hts221_core.c
> index 6a39615b696114cd..749aedc469ede5c1 100644
> --- a/drivers/iio/humidity/hts221_core.c
> +++ b/drivers/iio/humidity/hts221_core.c
> @@ -7,6 +7,7 @@
>   * Lorenzo Bianconi <lorenzo.bianconi@st.com>
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
> @@ -171,7 +172,7 @@ static int hts221_update_avg(struct hts221_hw *hw,
>  			     u16 val)
>  {
>  	const struct hts221_avg *avg = &hts221_avg_list[type];
> -	int i, err, data;
> +	int i, err;
>  
>  	for (i = 0; i < HTS221_AVG_DEPTH; i++)
>  		if (avg->avg_avl[i] == val)
> @@ -180,9 +181,8 @@ static int hts221_update_avg(struct hts221_hw *hw,
>  	if (i == HTS221_AVG_DEPTH)
>  		return -EINVAL;
>  
> -	data = ((i << __ffs(avg->mask)) & avg->mask);
> -	err = regmap_update_bits(hw->regmap, avg->addr,
> -				 avg->mask, data);
> +	err = regmap_update_bits(hw->regmap, avg->addr, avg->mask,
> +				 field_prep(avg->mask, i));
>  	if (err < 0)
>  		return err;
>  

