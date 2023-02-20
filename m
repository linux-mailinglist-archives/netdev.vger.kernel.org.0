Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9519269C8A2
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjBTKey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjBTKep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:34:45 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9646318B06
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 02:34:43 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id i31so8115224eda.12
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 02:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hgK+pzbgsRct7v66y7EeW9btlFAMDnGp7qA3LyQeueA=;
        b=ShobCGbFij7tUT+5/n7fnEr53C2/0jxVBdNu1dHkJSG6s4KAO6LFFnRrmCnoBOmXJy
         0eCMJfuG7fVPmFNODgUHbM40obtDqhrtM9XX2Juj5n1FM0jJup7zwFDOwvN80x/f+G+5
         Yl68/2isRSQpRcyoGePuKEaWY3YuN6aJC01OUipDJhlG1zqPwve0pSSkBASZ7sIT08TB
         TCAIkz7ilnchLiNBIRyP4IMso6UIuFCLo1fgD8Z/3NAwzdjQwuahaJfkwOMpIpIT3Fv8
         n2kqIPCEHS3nHF8puaQ1L/g8SEMkTntwpiPPdL/eZ9au/HMGX8ITkAyqrnnvOcCi5ePm
         d8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hgK+pzbgsRct7v66y7EeW9btlFAMDnGp7qA3LyQeueA=;
        b=6cE/KkILiAQ1fhER+zmoU0LvheJparqP5yAkt5eWFLLbgGP3wGOxwD502ogee5dWxk
         xcD87BlUG7onXdccR+EoHJv4m+tW/X6radERnsPJAqPiXMzdouWzyi1xjbd0fROaUiTT
         Td6hc4hbbg98X3jWGyHlwZDT3TxsCpt2SGguybMUFFA3BNx5KpuoviNEof0bXTdEeNpc
         5maAOxklGAuNEk7CRO86MqWEMkgXep8maC14jM70iB64WxyZ05fYv0UuB/FwaGeIK5a5
         kfPjf/BOItWxdRL5tV7+YCzTZEx3ifTZakJSbWhT4o5MzP3bfbJt96UDauNhIoUU3aAU
         w4HA==
X-Gm-Message-State: AO0yUKXZDK6y86wqiml9e+ocj5BWTuaEulbyoT7KELfykwNeKHwelE3q
        EhopQghiY1dh1+3n3DsXVx0gX4wvb98sP2rL8585Bw==
X-Google-Smtp-Source: AK7set9kOckIby41ckXXZd5uq/qQcyFAoci84eoqUFhxhM0EZ569btim73i+tZ6vLNTWM1FX3dsvXtMctilu1VP6iHI=
X-Received: by 2002:a17:906:fcad:b0:8b1:3d0d:5333 with SMTP id
 qw13-20020a170906fcad00b008b13d0d5333mr3882123ejb.13.1676889282013; Mon, 20
 Feb 2023 02:34:42 -0800 (PST)
MIME-Version: 1.0
References: <20230219143657.241542-1-daniel.lezcano@linaro.org> <20230219143657.241542-2-daniel.lezcano@linaro.org>
In-Reply-To: <20230219143657.241542-2-daniel.lezcano@linaro.org>
From:   Balsam CHIHI <bchihi@baylibre.com>
Date:   Mon, 20 Feb 2023 11:34:05 +0100
Message-ID: <CAGuA+oonRP3s4kfzU2-yfMSy4uB+Hea4OhVTXt_A3zpB8aziZg@mail.gmail.com>
Subject: Re: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata' accessor
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 3:37 PM Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>
> The thermal zone device structure is exposed to the different drivers
> and obviously they access the internals while that should be
> restricted to the core thermal code.
>
> In order to self-encapsulate the thermal core code, we need to prevent
> the drivers accessing directly the thermal zone structure and provide
> accessor functions to deal with.
>
> Provide an accessor to the 'devdata' structure and make use of it in
> the different drivers.
>
> No functional changes intended.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
[...]
>  drivers/thermal/mediatek/lvts_thermal.c          |  4 ++--
[...]
> diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
> index 84ba65a27acf..86d280187c83 100644
> --- a/drivers/thermal/mediatek/lvts_thermal.c
> +++ b/drivers/thermal/mediatek/lvts_thermal.c
> @@ -252,7 +252,7 @@ static u32 lvts_temp_to_raw(int temperature)
>
>  static int lvts_get_temp(struct thermal_zone_device *tz, int *temp)
>  {
> -       struct lvts_sensor *lvts_sensor = tz->devdata;
> +       struct lvts_sensor *lvts_sensor = thermal_zone_device_get_data(tz);
>         void __iomem *msr = lvts_sensor->msr;
>         u32 value;
>
> @@ -290,7 +290,7 @@ static int lvts_get_temp(struct thermal_zone_device *tz, int *temp)
>
>  static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
>  {
> -       struct lvts_sensor *lvts_sensor = tz->devdata;
> +       struct lvts_sensor *lvts_sensor = thermal_zone_device_get_data(tz);
>         void __iomem *base = lvts_sensor->base;
>         u32 raw_low = lvts_temp_to_raw(low);
>         u32 raw_high = lvts_temp_to_raw(high);

for MediaTek LVTS :

Reviewed-by: Balsam CHIHI <bchihi@baylibre.com>
