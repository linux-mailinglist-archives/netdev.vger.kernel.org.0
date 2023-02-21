Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A00269E754
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 19:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjBUSVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 13:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBUSVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 13:21:00 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205FC2D146;
        Tue, 21 Feb 2023 10:20:58 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id ck15so22106159edb.0;
        Tue, 21 Feb 2023 10:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEx60aGsOPq7IkDOpzyHIUcwhrl0mz7YlLyNt97/zzk=;
        b=Vkiaa+8m8yu4NTxbblvl9Xy6xRY9QvaCJQQZbhyYuTZn8LBqKKDe7jY7cLga8bqrcE
         YaFq3y0C2R5gLoZ44PHVCrMAdGGatzNgi+EosQ56cNauhD/qzPxPu9eWtArP/kQYf6rx
         36GQyJWdRypl3dP6LvmlQomgaS1x7ac8qIOxKBv4iPYah7/H4U4h/V6DJktLKCDLkCNt
         zam9FAexUE4ScIdFjriD/ldLT/qH7DYDTEMJw7I5irpI67gcvfxo0PhE5WzARIJUnSPa
         wlya8h0DyOjyph7LZJFK7Rnd+iEZ0//cF85WuFwOA5cl7PpXtV4f/127McL5fndnVkaK
         p+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NEx60aGsOPq7IkDOpzyHIUcwhrl0mz7YlLyNt97/zzk=;
        b=EIveVhgabSP6qeor31DrF/UzwIQhNyjPrFBL0M+F+KtQKk3W6nhN0QXlKc3AfU6bLD
         Nm4w7kerBxYUue9WnCh9vAupwZoeflQJK9SX2t4cbNu4xfGAggM8H53zqZBs0+Ddc1XF
         8mNLsINIXwUHTZ8rfKQq0OLBMpfNJoFoa8SaQWUsGpDMrKzeV6j7mCftbyeyEgcOobXS
         f7soEG6SQKQk2eaa6edZDfdFPDWw4b93HadSi2sr25NC1ZOA4M6yczfRUGQV9BvGt3b3
         whGie6dj/egPaZmyDHC0M9VEjFfoI69QvYrVk9W0eHlV7S9ywUjn2z/7LJ2DASBl5OBH
         DGrg==
X-Gm-Message-State: AO0yUKWDnCkBf4BiTf1tmSCjzRTtmHA26Vz6qN6bTq8fyAUadoqDXnxR
        sf3ibJai6iaRxPfNCvG9vvA=
X-Google-Smtp-Source: AK7set/77DXP7YfI8zufkfadXlbWVnpTCpeUBy9C/lrv0XbiKTxHiGSVqDS5SHlnDvtOC7YRM2po7A==
X-Received: by 2002:a17:906:3e43:b0:88a:2e57:9813 with SMTP id t3-20020a1709063e4300b0088a2e579813mr13728718eji.33.1677003656530;
        Tue, 21 Feb 2023 10:20:56 -0800 (PST)
Received: from jernej-laptop.localnet (82-149-1-233.dynamic.telemach.net. [82.149.1.233])
        by smtp.gmail.com with ESMTPSA id p20-20020a1709060dd400b008be5b97ca49sm4790892eji.150.2023.02.21.10.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 10:20:55 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     rafael@kernel.org, daniel.lezcano@linaro.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Mark Brown <broonie@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Balsam CHIHI <bchihi@baylibre.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>, Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Heiko Stuebner <heiko@sntech.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Orson Zhai <orsonzhai@gmail.com>,
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
        Stefan Wahren <stefan.wahren@i2se.com>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Tim Zimmermann <tim@linux4.de>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
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
        "open list:QUALCOMM TSENS THERMAL DRIVER" 
        <linux-arm-msm@vger.kernel.org>,
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
Subject: Re: [PATCH v2 01/16] thermal/core: Add a thermal zone 'devdata' accessor
Date:   Tue, 21 Feb 2023 19:20:51 +0100
Message-ID: <5907084.lOV4Wx5bFT@jernej-laptop>
In-Reply-To: <20230221180710.2781027-2-daniel.lezcano@linaro.org>
References: <20230221180710.2781027-1-daniel.lezcano@linaro.org>
 <20230221180710.2781027-2-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne torek, 21. februar 2023 ob 19:06:55 CET je Daniel Lezcano napisal(a):
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
> Acked-by: Guenter Roeck <linux@roeck-us.net> #hwmon
> Reviewed-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se> #=
R-Car
> Acked-by: Mark Brown <broonie@kernel.org>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com> #mlxsw
> Reviewed-by: AngeloGioacchino Del Regno
> <angelogioacchino.delregno@collabora.com> #MediaTek auxadc and lvts
> Reviewed-by: Balsam CHIHI <bchihi@baylibre.com> #Mediatek lvts
> Acked-by: Gregory Greenman <gregory.greenman@intel.com> #iwlwifi
> Reviewed-by: Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com> #da9062
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>  #spread
> Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com> #power_supp=
ly
> ---
>  drivers/acpi/thermal.c                           | 16 ++++++++--------
>  drivers/ata/ahci_imx.c                           |  2 +-
>  drivers/hwmon/hwmon.c                            |  4 ++--
>  drivers/hwmon/pmbus/pmbus_core.c                 |  2 +-
>  drivers/hwmon/scmi-hwmon.c                       |  2 +-
>  drivers/hwmon/scpi-hwmon.c                       |  2 +-
>  drivers/iio/adc/sun4i-gpadc-iio.c                |  2 +-
>  drivers/input/touchscreen/sun4i-ts.c             |  2 +-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_thermal.c   |  2 +-
>  .../net/ethernet/mellanox/mlxsw/core_thermal.c   | 14 +++++++-------
>  drivers/net/wireless/intel/iwlwifi/mvm/tt.c      |  4 ++--
>  drivers/power/supply/power_supply_core.c         |  2 +-
>  drivers/regulator/max8973-regulator.c            |  2 +-
>  drivers/thermal/armada_thermal.c                 |  4 ++--
>  drivers/thermal/broadcom/bcm2711_thermal.c       |  2 +-
>  drivers/thermal/broadcom/bcm2835_thermal.c       |  2 +-
>  drivers/thermal/broadcom/brcmstb_thermal.c       |  4 ++--
>  drivers/thermal/broadcom/ns-thermal.c            |  2 +-
>  drivers/thermal/broadcom/sr-thermal.c            |  2 +-
>  drivers/thermal/da9062-thermal.c                 |  2 +-
>  drivers/thermal/dove_thermal.c                   |  2 +-
>  drivers/thermal/hisi_thermal.c                   |  2 +-
>  drivers/thermal/imx8mm_thermal.c                 |  2 +-
>  drivers/thermal/imx_sc_thermal.c                 |  2 +-
>  drivers/thermal/imx_thermal.c                    |  6 +++---
>  drivers/thermal/intel/intel_pch_thermal.c        |  2 +-
>  drivers/thermal/intel/intel_soc_dts_iosf.c       | 13 +++++--------
>  drivers/thermal/intel/x86_pkg_temp_thermal.c     |  4 ++--
>  drivers/thermal/k3_bandgap.c                     |  2 +-
>  drivers/thermal/k3_j72xx_bandgap.c               |  2 +-
>  drivers/thermal/kirkwood_thermal.c               |  2 +-
>  drivers/thermal/max77620_thermal.c               |  2 +-
>  drivers/thermal/mediatek/auxadc_thermal.c        |  2 +-
>  drivers/thermal/mediatek/lvts_thermal.c          |  4 ++--
>  drivers/thermal/qcom/qcom-spmi-adc-tm5.c         |  4 ++--
>  drivers/thermal/qcom/qcom-spmi-temp-alarm.c      |  4 ++--
>  drivers/thermal/qoriq_thermal.c                  |  2 +-
>  drivers/thermal/rcar_gen3_thermal.c              |  4 ++--
>  drivers/thermal/rcar_thermal.c                   |  3 +--
>  drivers/thermal/rockchip_thermal.c               |  4 ++--
>  drivers/thermal/rzg2l_thermal.c                  |  2 +-
>  drivers/thermal/samsung/exynos_tmu.c             |  4 ++--
>  drivers/thermal/spear_thermal.c                  |  8 ++++----
>  drivers/thermal/sprd_thermal.c                   |  2 +-
>  drivers/thermal/sun8i_thermal.c                  |  2 +-

=46or sun8i_thermal:
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej

>  drivers/thermal/tegra/tegra-bpmp-thermal.c       |  6 ++++--
>  drivers/thermal/tegra/tegra30-tsensor.c          |  4 ++--
>  drivers/thermal/thermal-generic-adc.c            |  2 +-
>  drivers/thermal/thermal_core.c                   |  6 ++++++
>  drivers/thermal/thermal_mmio.c                   |  2 +-
>  .../thermal/ti-soc-thermal/ti-thermal-common.c   |  4 ++--
>  drivers/thermal/uniphier_thermal.c               |  2 +-
>  include/linux/thermal.h                          |  7 +++++++
>  53 files changed, 102 insertions(+), 91 deletions(-)



