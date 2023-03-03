Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC696A93DF
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 10:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCCJZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 04:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjCCJZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 04:25:01 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F025C106
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 01:24:44 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id h14so1599636wru.4
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 01:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677835482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qZW13a6M4CbKDv+/tbaLjH07R3EIPpeX9wuis9iCl0M=;
        b=RfgXVuHmkLq5H7QR1aoNvvv2IALanaH0P/POcAYoDGfK0laJjSXiUXMG2kCc40DmBV
         5ao/QP6HdIAaN6hNk1zsTzmBzkjlvVSzfFS32NfO47ganlGU74uAoAc1ONN+fKkDAW9x
         PX+j4q4yKvu2RAejYMPqtDX+48X9mtQ1/g9Vf3iteKlk+hgIhFTUB5g2QFY/UIh+osJ0
         fL6DK+KImynrpdP8OB9rryz08dmc6/+BcNgfGSBVfXMAbbsUaNG2kjFjD85Q95edAEuw
         Uzo33thMuESwFCv9ZVOxFgln7WLK59Zrhky23WQocCu9bvPQsGwITh3daE7wri7PgkXk
         2ABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677835482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qZW13a6M4CbKDv+/tbaLjH07R3EIPpeX9wuis9iCl0M=;
        b=AFjeyDKtfvIQ/I+6eBiW7hnzVIl+V/EWtYXGI1Vs3Zy9j/cDzCyPkpY92UP9ePdeGD
         hVmBZDqAWiFBAUFGk1nzzovSBxkwRoENBrNa74OG+uYkOKnG9wKY30C2R2NO+3j/ZwJc
         zpeLMO3RR240Hvfq01sEu6UhmswDqAeJH/p/H+3bEtHBXxqJifT84DlkHVbwnqJP7SiR
         Jcn6aA7GFmig5Medg6m7Z4Q/HTHMsvM4CZKXtL6UPAnT2Nh+xiPwvzGog4P3/lwpcs1x
         RDSYoVynilsLq5FDINdxaR4vtobq+/Nl55Y+5M+YdZw9+W8Z9D8taXToFujgMycMm+77
         NmFQ==
X-Gm-Message-State: AO0yUKWpnOg5b5FJo8XWz97ExElETi+krQ7fjPik5UI/zH8WkJusuONj
        mo0Q/bGZvNfhEyY50bt7x7PULg==
X-Google-Smtp-Source: AK7set/TivsVLpZgfVwr7zBuzY0idsigW/sKtrB0Gs+T0bp+j2ltmNPJktyEla4UqtSRdklCLprlWw==
X-Received: by 2002:adf:e60b:0:b0:2ca:9950:718 with SMTP id p11-20020adfe60b000000b002ca99500718mr890693wrm.52.1677835482554;
        Fri, 03 Mar 2023 01:24:42 -0800 (PST)
Received: from ?IPV6:2a05:6e02:1041:c10:e474:bda6:c260:d90b? ([2a05:6e02:1041:c10:e474:bda6:c260:d90b])
        by smtp.googlemail.com with ESMTPSA id p7-20020a5d48c7000000b002c71d206329sm1631219wrs.55.2023.03.03.01.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:24:41 -0800 (PST)
Message-ID: <1d3da42e-2499-7ff6-50fa-048a720e855f@linaro.org>
Date:   Fri, 3 Mar 2023 10:24:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 00/18] Self-encapsulate the thermal zone device
 structure
Content-Language: en-US
To:     rafael@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
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
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
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
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Balsam CHIHI <bchihi@baylibre.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <20230301201446.3713334-1-daniel.lezcano@linaro.org>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20230301201446.3713334-1-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Rafael,

Do we have enough ack to apply this series, is it for you ?

Thanks

   -- Daniel


On 01/03/2023 21:14, Daniel Lezcano wrote:
> The exported thermal headers expose the thermal core structure while those
> should be private to the framework. The initial idea was the thermal sensor
> drivers use the thermal zone device structure pointer to pass it around from
> the ops to the thermal framework API like a handler.
> 
> Unfortunately, different drivers are using and abusing the internals of this
> structure to hook the associated struct device, read the internals values, take
> the lock, etc ...
> 
> In order to fix this situation, let's encapsulate the structure leaking the
> more in the different drivers: the thermal_zone_device structure.
> 
> This series revisit the existing drivers using the thermal zone private
> structure internals to change the access to something else. For instance, the
> get_temp() ops is using the tz->dev to write a debug trace. Despite the trace
> is not helpful, we can check the return value for the get_temp() ops in the
> call site and show the message in this place.
> 
> With this set of changes, the thermal_zone_device is almost self-encapsulated.
> As usual, the acpi driver needs a more complex changes, so that will come in a
> separate series along with the structure moved the private core headers.
> 
> Changelog:
> 	- V5:
> 	   - Dropped patch 19 : "thermal/tegra: Do not enable ... is already enabled"
> 	   - Changed the init sequence of the hw channels on tegra3 to close
> 	     the race window
> 	   - Collected more tags
> 	- V4:
> 	   - Collected more tags
> 	   - Fixed a typo therma_zone_device_priv() for db8500
> 	   - Remove traces patch [20/20] to be submitted separetely
> 	- V3:
> 	   - Split the first patch into three to reduce the number of
> 	     recipients per change
> 	   - Collected more tags
> 	   - Added missing changes for ->devdata in some drivers
> 	   - Added a 'type' accessor
> 	   - Replaced the 'type' to 'id' changes by the 'type' accessor
> 	   - Used the 'type' accessor in the drivers
> 	- V2:
> 	   - Collected tags
> 	   - Added missing changes for ->devdata for the tsens driver
> 	   - Renamed thermal_zone_device_get_data() to thermal_zone_priv()
> 	   - Added stubs when CONFIG_THERMAL is not set
> 	   - Dropped hwmon change where we remove the tz->lock usage
> 
> Thank you all for your comments
> 
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
> Cc: Samuel Holland <samuel@sholland.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: Gregory Greenman <gregory.greenman@intel.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Amit Kucheria <amitk@kernel.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
> Cc: Ray Jui <rjui@broadcom.com>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: Markus Mayer <mmayer@broadcom.com>
> Cc: Support Opensource <support.opensource@diasemi.com>
> Cc: Andy Gross <agross@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
> Cc: Thara Gopinath <thara.gopinath@gmail.com>
> Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Orson Zhai <orsonzhai@gmail.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Chunyan Zhang <zhang.lyra@gmail.com>
> Cc: Vasily Khoruzhick <anarsoul@gmail.com>
> Cc: Yangtao Li <tiny.windzz@gmail.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Talel Shenhar <talel@amazon.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Keerthy <j-keerthy@ti.com>
> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Zheng Yongjun <zhengyongjun3@huawei.com>
> Cc: Yang Li <yang.lee@linux.alibaba.com>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: Daniel Golle <daniel@makrotopia.org>
> Cc: Balsam CHIHI <bchihi@baylibre.com>
> Cc: Mikko Perttunen <mperttunen@nvidia.com>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-ide@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-hwmon@vger.kernel.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-sunxi@lists.linux.dev
> Cc: linux-input@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: linux-renesas-soc@vger.kernel.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Cc: linux-mediatek@lists.infradead.org
> 
> Daniel Lezcano (18):
>    thermal/core: Add a thermal zone 'devdata' accessor
>    thermal/core: Use the thermal zone 'devdata' accessor in thermal
>      located drivers
>    thermal/core: Use the thermal zone 'devdata' accessor in hwmon located
>      drivers
>    thermal/core: Use the thermal zone 'devdata' accessor in remaining
>      drivers
>    thermal/core: Show a debug message when get_temp() fails
>    thermal: Remove debug or error messages in get_temp() ops
>    thermal/hwmon: Do not set no_hwmon before calling
>      thermal_add_hwmon_sysfs()
>    thermal/hwmon: Use the right device for devm_thermal_add_hwmon_sysfs()
>    thermal: Don't use 'device' internal thermal zone structure field
>    thermal/core: Add thermal_zone_device structure 'type' accessor
>    thermal/drivers/spear: Don't use tz->device but pdev->dev
>    thermal: Add a thermal zone id accessor
>    thermal: Use thermal_zone_device_type() accessor
>    thermal/drivers/da9062: Don't access the thermal zone device fields
>    thermal/hwmon: Use the thermal_core.h header
>    thermal/drivers/tegra: Remove unneeded lock when setting a trip point
>    thermal/drivers/acerhdf: Make interval setting only at module load
>      time
>    thermal/drivers/acerhdf: Remove pointless governor test
> 
>   drivers/acpi/thermal.c                        | 18 +++----
>   drivers/ata/ahci_imx.c                        |  2 +-
>   drivers/hwmon/hwmon.c                         |  4 +-
>   drivers/hwmon/pmbus/pmbus_core.c              |  2 +-
>   drivers/hwmon/scmi-hwmon.c                    |  4 +-
>   drivers/hwmon/scpi-hwmon.c                    |  2 +-
>   drivers/iio/adc/sun4i-gpadc-iio.c             |  2 +-
>   drivers/input/touchscreen/sun4i-ts.c          |  2 +-
>   .../ethernet/chelsio/cxgb4/cxgb4_thermal.c    |  2 +-
>   .../ethernet/mellanox/mlxsw/core_thermal.c    | 16 +++----
>   drivers/net/wireless/intel/iwlwifi/mvm/tt.c   |  4 +-
>   drivers/platform/x86/acerhdf.c                | 19 ++------
>   drivers/power/supply/power_supply_core.c      |  2 +-
>   drivers/regulator/max8973-regulator.c         |  2 +-
>   drivers/thermal/amlogic_thermal.c             |  4 +-
>   drivers/thermal/armada_thermal.c              | 14 ++----
>   drivers/thermal/broadcom/bcm2711_thermal.c    |  3 +-
>   drivers/thermal/broadcom/bcm2835_thermal.c    |  3 +-
>   drivers/thermal/broadcom/brcmstb_thermal.c    |  8 ++--
>   drivers/thermal/broadcom/ns-thermal.c         |  2 +-
>   drivers/thermal/broadcom/sr-thermal.c         |  2 +-
>   drivers/thermal/da9062-thermal.c              | 13 +++--
>   drivers/thermal/db8500_thermal.c              |  2 +-
>   drivers/thermal/dove_thermal.c                |  7 +--
>   drivers/thermal/hisi_thermal.c                |  5 +-
>   drivers/thermal/imx8mm_thermal.c              |  4 +-
>   drivers/thermal/imx_sc_thermal.c              |  9 ++--
>   drivers/thermal/imx_thermal.c                 | 47 +++++--------------
>   .../intel/int340x_thermal/int3400_thermal.c   |  2 +-
>   .../int340x_thermal/int340x_thermal_zone.c    |  4 +-
>   .../processor_thermal_device_pci.c            |  4 +-
>   drivers/thermal/intel/intel_pch_thermal.c     |  2 +-
>   .../thermal/intel/intel_quark_dts_thermal.c   |  6 +--
>   drivers/thermal/intel/intel_soc_dts_iosf.c    | 13 ++---
>   drivers/thermal/intel/x86_pkg_temp_thermal.c  |  4 +-
>   drivers/thermal/k3_bandgap.c                  |  4 +-
>   drivers/thermal/k3_j72xx_bandgap.c            |  2 +-
>   drivers/thermal/kirkwood_thermal.c            |  7 +--
>   drivers/thermal/max77620_thermal.c            |  6 +--
>   drivers/thermal/mediatek/auxadc_thermal.c     |  4 +-
>   drivers/thermal/mediatek/lvts_thermal.c       | 10 ++--
>   drivers/thermal/qcom/qcom-spmi-adc-tm5.c      |  6 +--
>   drivers/thermal/qcom/qcom-spmi-temp-alarm.c   |  6 +--
>   drivers/thermal/qcom/tsens.c                  |  6 +--
>   drivers/thermal/qoriq_thermal.c               |  4 +-
>   drivers/thermal/rcar_gen3_thermal.c           |  5 +-
>   drivers/thermal/rcar_thermal.c                |  8 +---
>   drivers/thermal/rockchip_thermal.c            |  8 +---
>   drivers/thermal/rzg2l_thermal.c               |  3 +-
>   drivers/thermal/samsung/exynos_tmu.c          |  4 +-
>   drivers/thermal/spear_thermal.c               | 10 ++--
>   drivers/thermal/sprd_thermal.c                |  2 +-
>   drivers/thermal/st/st_thermal.c               |  5 +-
>   drivers/thermal/st/stm_thermal.c              |  4 +-
>   drivers/thermal/sun8i_thermal.c               |  4 +-
>   drivers/thermal/tegra/soctherm.c              |  6 +--
>   drivers/thermal/tegra/tegra-bpmp-thermal.c    |  6 ++-
>   drivers/thermal/tegra/tegra30-tsensor.c       | 31 ++++++------
>   drivers/thermal/thermal-generic-adc.c         |  7 ++-
>   drivers/thermal/thermal_core.c                | 18 +++++++
>   drivers/thermal/thermal_helpers.c             |  3 ++
>   drivers/thermal/thermal_hwmon.c               |  9 ++--
>   drivers/thermal/thermal_hwmon.h               |  4 +-
>   drivers/thermal/thermal_mmio.c                |  2 +-
>   .../ti-soc-thermal/ti-thermal-common.c        | 10 ++--
>   drivers/thermal/uniphier_thermal.c            |  2 +-
>   include/linux/thermal.h                       | 19 ++++++++
>   67 files changed, 218 insertions(+), 246 deletions(-)
> 

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

