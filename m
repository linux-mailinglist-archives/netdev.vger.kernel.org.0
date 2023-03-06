Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D86ACEC5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjCFUBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCFUBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:01:14 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3EC67024;
        Mon,  6 Mar 2023 12:00:56 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so14280355pjb.3;
        Mon, 06 Mar 2023 12:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678132856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uXR1hBuNmG/TwC91AeVvsW1UVH/MwkAfhUSEnuvNaoY=;
        b=o6hZefnQYEnFw3COvoTdyyoXo9Zv4P0LTShB301lkw0/gGr+x1ou0XeYCSdcXXLXoz
         Ie/lwSIsRhh9vBh4c56fFPeCbh1Mg/u0f+SLHuOsNnA01L3iQxuD6tKvCodPDyUeqcUA
         ipzyAtvRXWR1nR5U0W8m7xh6fPIYtpAYIZVYRkCJb0GTxixFtDSEeec8W6O4TIR9SFvb
         8TyLwk+heXtYmzhntJcZ54SphmylZPrikYFa1PRdJ8V5j+VefclzJKcG1hcN/EBRiJ2z
         A5LjdstbOHhVHAVRXA7o2dTcBNuVBc27QoVtU1tjX+Yepbtmilj428R4Os2Xd6WiLWnA
         Of4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678132856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uXR1hBuNmG/TwC91AeVvsW1UVH/MwkAfhUSEnuvNaoY=;
        b=aXlIsS33Jjsuul+qMNL2sbI/Xqukq2wbEWP7Zdwtlj7bv64XyL7zxFEoY23RZ0YQor
         Bqbh5zVr8LntGonP2exW1FvIEe3AwE9XlYZmNS8BKWTAWJs46K5D88Cz1tVysYW6l+vP
         FlMoMohxRfMxV4J+TUf+f7Bz1HpG6jA9mHubAYpMaJGTADnDWXZk6nHVD+RgpSfy8wnl
         /+/YGrN5IjCieKDYZ32gkewHxI34PwOi60E7Fm7h+ZsDbXdaNQooMMjB7VEGiEr6rL0+
         lQojxCgDm1YNLkaokb9PWqj3WmVVVML7lZp7/PlVkSmU5avaYieldMHSE8tJs0W+SvaY
         B+Qw==
X-Gm-Message-State: AO0yUKXAbIFP23mAPtL3C28xLpxvoISrBRzI+Kq+PG803rUuLclFekw1
        m8OB/pmYca24tx4TYBNZYeUG77vaa6Wk3reLCVE=
X-Google-Smtp-Source: AK7set/DxZtiZhO+z+A0Is7yokDniYYkETavBEcleYa7IPSvIEQBIV7zty9Y+UWe1CWFM73JZ5CBgh34wQSFC4iK+eg=
X-Received: by 2002:a17:90a:5993:b0:233:b520:1544 with SMTP id
 l19-20020a17090a599300b00233b5201544mr6625621pji.0.1678132856231; Mon, 06 Mar
 2023 12:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com> <20230306172109.595464-10-amit.kumar-mahapatra@amd.com>
In-Reply-To: <20230306172109.595464-10-amit.kumar-mahapatra@amd.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Mon, 6 Mar 2023 21:00:44 +0100
Message-ID: <CAOiHx=nmsAh3ADL3s0eZKpEZJqCB_POi=8YjfxrHYLEbjRfwHg@mail.gmail.com>
Subject: Re: [PATCH V5 09/15] spi: Add stacked and parallel memories support
 in SPI core
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     broonie@kernel.org, miquel.raynal@bootlin.com, richard@nod.at,
        vigneshr@ti.com, jic23@kernel.org, tudor.ambarus@microchip.com,
        pratyush@kernel.org, Sanju.Mehta@amd.com,
        chin-ting_kuo@aspeedtech.com, clg@kaod.org, kdasu.kdev@gmail.com,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        eajames@linux.ibm.com, olteanv@gmail.com, han.xu@nxp.com,
        john.garry@huawei.com, shawnguo@kernel.org, s.hauer@pengutronix.de,
        narmstrong@baylibre.com, khilman@baylibre.com,
        matthias.bgg@gmail.com, haibo.chen@nxp.com,
        linus.walleij@linaro.org, daniel@zonque.org,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        agross@kernel.org, bjorn.andersson@linaro.org, heiko@sntech.de,
        krzysztof.kozlowski@linaro.org, andi@etezian.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        wens@csie.org, jernej.skrabec@gmail.com, samuel@sholland.org,
        masahisa.kojima@linaro.org, jaswinder.singh@linaro.org,
        rostedt@goodmis.org, mingo@redhat.com, l.stelmach@samsung.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.aring@gmail.com, stefan@datenfreihafen.org,
        kvalo@kernel.org, james.schulman@cirrus.com,
        david.rhodes@cirrus.com, tanureal@opensource.cirrus.com,
        rf@opensource.cirrus.com, perex@perex.cz, tiwai@suse.com,
        npiggin@gmail.com, christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        oss@buserror.net, windhl@126.com, yangyingliang@huawei.com,
        william.zhang@broadcom.com, kursad.oney@broadcom.com,
        anand.gore@broadcom.com, rafal@milecki.pl, git@amd.com,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, andrew@aj.id.au, radu_nicolae.pirea@upb.ro,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.beznea@microchip.com,
        bcm-kernel-feedback-list@broadcom.com, fancer.lancer@gmail.com,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        venture@google.com, yuenn@google.com, benjaminfair@google.com,
        yogeshgaur.83@gmail.com, konrad.dybcio@somainline.org,
        alim.akhtar@samsung.com, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        michal.simek@amd.com, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-mtd@lists.infradead.org, lars@metafoo.de,
        Michael.Hennerich@analog.com, linux-iio@vger.kernel.org,
        michael@walle.cc, palmer@dabbelt.com,
        linux-riscv@lists.infradead.org, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com, linuxppc-dev@lists.ozlabs.org,
        amitrkcian2002@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 6 Mar 2023 at 18:26, Amit Kumar Mahapatra
<amit.kumar-mahapatra@amd.com> wrote:
>
> For supporting multiple CS the SPI device need to be aware of all the CS
> values. So, the "chip_select" member in the spi_device structure is now an
> array that holds all the CS values.
>
> spi_device structure now has a "cs_index_mask" member. This acts as an
> index to the chip_select array. If nth bit of spi->cs_index_mask is set
> then the driver would assert spi->chip_select[n].
>
> In parallel mode all the chip selects are asserted/de-asserted
> simultaneously and each byte of data is stored in both devices, the even
> bits in one, the odd bits in the other. The split is automatically handled
> by the GQSPI controller. The GQSPI controller supports a maximum of two
> flashes connected in parallel mode. A "multi-cs-cap" flag is added in the
> spi controntroller data, through ctlr->multi-cs-cap the spi core will make
> sure that the controller is capable of handling multiple chip selects at
> once.
>
> For supporting multiple CS via GPIO the cs_gpiod member of the spi_device
> structure is now an array that holds the gpio descriptor for each
> chipselect.
>
> Multi CS support using GPIO is not tested due to unavailability of
> necessary hardware setup.
>
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> ---
>  drivers/spi/spi.c       | 213 +++++++++++++++++++++++++++-------------
>  include/linux/spi/spi.h |  34 +++++--
>  2 files changed, 173 insertions(+), 74 deletions(-)
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 5866bf5813a4..8ec7f58fa111 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -613,7 +613,8 @@ static int spi_dev_check(struct device *dev, void *data)
>         struct spi_device *new_spi = data;
>
>         if (spi->controller == new_spi->controller &&
> -           spi_get_chipselect(spi, 0) == spi_get_chipselect(new_spi, 0))
> +           spi_get_chipselect(spi, 0) == spi_get_chipselect(new_spi, 0) &&
> +           spi_get_chipselect(spi, 1) == spi_get_chipselect(new_spi, 1))
>                 return -EBUSY;

This will only reject new devices if both chip selects are identical,
but not if they only share one, e.g. CS 1 + 2 vs 1 + 3, or 1 + 2 vs
only 2, or if the order is different (1 + 2 vs 2 + 1 - haven't read
the code too close to know if this is allowed/possible).

Regards,
Jonas
