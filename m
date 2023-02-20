Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7552569CAAD
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjBTMTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjBTMSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:18:54 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A586C65C;
        Mon, 20 Feb 2023 04:18:53 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id v19so512904qtx.1;
        Mon, 20 Feb 2023 04:18:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Re6NLj3mYWi/PS1iVcG93D07BAspc2CGyOXyoSaH5I=;
        b=Hv2om3mMlad73jLiyOltGX+vU7tUvhpeLSqRu6RuGSxvU/6x6QiVoYcmYWlkhgsBdK
         4v6WofJLjv3eRjiD9MVM5P7eRZn6uZgpQbt5ZfDUnY9lfmes9kyhLyP/HXzd6yU4cxbx
         rVapytEKP2P8uCG9w7HUZZXaGboBsSi1xQn3Mk7WtqVA4JUmwOP2J+Qq6m07ybqrEvZK
         /r6OpiCgVa+7jER2nyIclqmHD6UIk42vZWOTLYHI4GR8/Vd8/xu+HDqNOAYftQPBiLui
         GEHLWV45MJGdyyO/+aC+7W2y6Ab5ib63NNHayaC6Jex/Z6Ssfr6aOuarBnV/Iz616up2
         ZAcw==
X-Gm-Message-State: AO0yUKVpaNpYof5LDpPmDQuboV5Bl83O2dNy7WirqLYWpshvE2VoyF/0
        Hc0q71GJvRGaw61VIGmZo/giDvfmACzzJ02U
X-Google-Smtp-Source: AK7set+Nd09WGAMk7rH/9anu8D73O6lfdhS4LT5/yzwDDc9S8njlIVGCAwuqGENvmr71hLP61eee9Q==
X-Received: by 2002:a05:622a:1213:b0:3b9:b6c8:6d5b with SMTP id y19-20020a05622a121300b003b9b6c86d5bmr2150244qtx.35.1676895531806;
        Mon, 20 Feb 2023 04:18:51 -0800 (PST)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id m4-20020a37bc04000000b0074028d8a795sm1210904qkf.125.2023.02.20.04.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 04:18:50 -0800 (PST)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-536b7ffdd34so11523257b3.6;
        Mon, 20 Feb 2023 04:18:49 -0800 (PST)
X-Received: by 2002:a81:8606:0:b0:52e:e6ed:308e with SMTP id
 w6-20020a818606000000b0052ee6ed308emr1847623ywf.526.1676895529736; Mon, 20
 Feb 2023 04:18:49 -0800 (PST)
MIME-Version: 1.0
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
 <20230219143657.241542-2-daniel.lezcano@linaro.org> <OS3PR01MB8460E7C2D1F9EEEDDC579FFEC2A49@OS3PR01MB8460.jpnprd01.prod.outlook.com>
In-Reply-To: <OS3PR01MB8460E7C2D1F9EEEDDC579FFEC2A49@OS3PR01MB8460.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Feb 2023 13:18:38 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWFn+LbKE=77mRBfGqSu3x5qsk3X-pQVeu3uZXEejyRRg@mail.gmail.com>
Message-ID: <CAMuHMdWFn+LbKE=77mRBfGqSu3x5qsk3X-pQVeu3uZXEejyRRg@mail.gmail.com>
Subject: Re: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata' accessor
To:     DLG Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
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
        Sebastian Reichel <sre@kernel.org>,
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
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Mon, Feb 20, 2023 at 12:14 PM DLG Adam Ward
<DLG-Adam.Ward.opensource@dm.renesas.com> wrote:
> On 19/02/23 14:37, Daniel Lezcano wrote:
> >The thermal zone device structure is exposed to the different drivers and obviously they access the internals while that should be restricted to the core thermal code.
> >
> >In order to self-encapsulate the thermal core code, we need to prevent the drivers accessing directly the thermal zone structure and provide accessor functions to deal with.
> >
> >Provide an accessor to the 'devdata' structure and make use of it in the different drivers.
> >No functional changes intended.
> >
> >Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >---
>
> >drivers/thermal/da9062-thermal.c                 |  2 +-
>
> For da9062:
>
> Reviewed-by: Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>

Looks like Daniel has found the new Dialog maintainer he was looking
for? Time to update MAINTAINERS?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
