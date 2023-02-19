Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C446069C128
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 16:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjBSPHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 10:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjBSPH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 10:07:28 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56684113D2
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 07:07:24 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id d2so719269ljq.8
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 07:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vfvHBPjFD3fnJEXsEdcPBmeh9w1ZDPtCXMtTzNwUMP4=;
        b=2MT453GERnVCOXc+pZDXjhNske3WayAQFfKvKJjkTaSXaH9ypTF1xoFmHts7lcs6Tu
         8awMK4Po/ABZ5dh9w4kEV1FldjJxMrBZVoiOQuoO90QinuTnKOP01zHiWmaOtrj+nQvd
         F+ZaO4uYXLhJM+VztPHntmkaf7c2ZT1Q0aPQ00s5xppJj7swa9G6CIbKQNlCxZ/w13pb
         K749pLo5Tg+B9AZJIM2QgMhbSb1PATOb59v0crPXiX4ae6edrBvt+0E1yX/NUh/mJvXP
         jtQvKiAA2OdtGon53LBFrgDiJMJWAudwD546mUhHoHUTb6TiVX8ddk95TiBrWGbr05LD
         zGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfvHBPjFD3fnJEXsEdcPBmeh9w1ZDPtCXMtTzNwUMP4=;
        b=cP+KYHPm5FOg9PNjNGYQosrIXCYd0bLtwefG/DVp0SNdmvZchyvxtn07h26vQAaQ2s
         AwQYR5IXpmt9Ky2vXXMd3PJN++TgdbjqDOw4F2pr4Tyx43B2QpeXlh8lPIHxW+gEYQga
         La+oTs0Tr/jdOcFE+LqEEX0b3BgcjnHRm+KsZk/X7KbV9FMEfw8Lz7T6n719qcVMuT7W
         elBHlMgrq11xUaKljnkv/BnI5Q/47hqzBBNkZFtpXquxVdUkcYxrnm1h2sBh/EaoH57f
         P01KO7Dc+GmtReRdoI6dNx4P4wNCYdH2vCmnY66t5IlcH6gbM49p+pvmP5w8ugdgEPJ3
         yV6A==
X-Gm-Message-State: AO0yUKWMcN+Du4KVhJvc9W9bXRmp4iaHOgGeEssXk0KYGOTLHj9AH4Km
        7uc1oYT0DAIu72C0sHL1QK77XQ==
X-Google-Smtp-Source: AK7set9/3IywPw1ycXkXfjTE1BOHzIfMRekgiKErVRCZRj2jjMurZbyZpbHyyTOgbRvkntf1piSbOg==
X-Received: by 2002:a05:651c:1541:b0:293:14c8:f588 with SMTP id y1-20020a05651c154100b0029314c8f588mr403194ljp.27.1676819242130;
        Sun, 19 Feb 2023 07:07:22 -0800 (PST)
Received: from localhost (h-46-59-89-207.A463.priv.bahnhof.se. [46.59.89.207])
        by smtp.gmail.com with ESMTPSA id f23-20020a2e9517000000b0029355185926sm1245807ljh.137.2023.02.19.07.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 07:07:21 -0800 (PST)
Date:   Sun, 19 Feb 2023 16:07:20 +0100
From:   Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
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
Message-ID: <Y/I7KA2Uqqk7ib6L@oden.dyn.berto.se>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
 <20230219143657.241542-2-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230219143657.241542-2-daniel.lezcano@linaro.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thanks for your work.

On 2023-02-19 15:36:41 +0100, Daniel Lezcano wrote:
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

...

>  drivers/thermal/rcar_gen3_thermal.c              |  4 ++--
>  drivers/thermal/rcar_thermal.c                   |  3 +--

For R-Car,

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

...


> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 2bb4bf33f4f3..724b95662da9 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -365,6 +365,8 @@ thermal_zone_device_register_with_trips(const char *, struct thermal_trip *, int
>  					void *, struct thermal_zone_device_ops *,
>  					struct thermal_zone_params *, int, int);
>  
> +void *thermal_zone_device_get_data(struct thermal_zone_device *tzd);
> +

bikeshedding:

Would it make sens to name this thermal_zone_device_get_priv_data(), 
thermal_zone_device_get_priv() or something like that? To make it more 
explicitly when reading the driver code this fetches the drivers private 
data, and not some data belonging to the zone itself.

>  int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
>  				     struct thermal_cooling_device *,

-- 
Kind Regards,
Niklas Söderlund
