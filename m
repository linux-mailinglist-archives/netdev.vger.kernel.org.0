Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A333C69C0BA
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 15:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjBSOhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 09:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBSOhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 09:37:32 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30FD11159
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 06:37:26 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id b10so386833wrx.11
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 06:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pnsqbAY13Isy9Q4vAmb7bu7Jt4464vvs/IoNIYDr6xU=;
        b=hSKy+u5AgwaR/pjI3BVInARul9SXO0sQyw0n7yjY6yRDSg8BEuFLd5I5qrTlEpimNM
         Xjpl9UAbCCo9nok1y4IpVJ9MLE2XeHXG98wOfKu2d3NCxoPBH32UMAye1vooyYx1ErnD
         ricWKv9mPs3ba1qo4onNdonbsz4f+fGKOjQzVkGBoYVRHfTNp0sTV4wutDcxSYtnm8CH
         pxpYUDxS0coiNJcCa7tzwePTrwb9jeloVabBqo+ddLL3pZ7VUpIfX0IhEiKOfXtx1d/8
         1rUFK2J6S7yGqO9Iwiv++xzaS+2n7XjMuTbyAivc3fVQKvuBI/RXADB6caPXI29TjPRh
         O0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnsqbAY13Isy9Q4vAmb7bu7Jt4464vvs/IoNIYDr6xU=;
        b=jt04zLpnx5SOSTWumbFD7gNU3QCahQYyGBcEYR/1wC3gf+s+cLdJ9b/YwGZQNckZ9j
         Id9/t8O7z9ne+aMsFGKYie9033eNZq2Nd3hRVNEnc8Q8jS/OhveI13BsWeilIkZh6lTY
         g+m+sDS7dS6XP4DsoD+op1EJdJt31oWXkptrcSNv/HDYnhdRyK9KP2bW+/tfSa8CzBpf
         KlhS4a6YQ+/+LpzrqiBsdKm6iuwkJn46i2xzuXpQ9xKyBra/D1vy4e559Op+RWcbCmrD
         wEuPi0GKPhwYT+2OYiv9x0SnlUrRY5AKWzMRjC1PlwnfHmy57BEccLOHTfEkztRvKRxC
         W+hg==
X-Gm-Message-State: AO0yUKVNgu37D7ANuJLZ9xZ1BreY8vmLR743CsTHGx3dhue2c6G5xgea
        h7awGbxhYrUuL/7y/+Kkl18ghA==
X-Google-Smtp-Source: AK7set9gXafURZgOj1Yem7EqSUruiomk29jrLU507lTzAdGLNHnFcqKBP+ki22tLjJJTUzMVG5WPYw==
X-Received: by 2002:adf:f84e:0:b0:2c5:5048:8a6a with SMTP id d14-20020adff84e000000b002c550488a6amr1432164wrq.60.1676817444373;
        Sun, 19 Feb 2023 06:37:24 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:6f43:b92:7670:463])
        by smtp.gmail.com with ESMTPSA id a18-20020adfe5d2000000b002be505ab59asm86176wrn.97.2023.02.19.06.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 06:37:23 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     rafael@kernel.org, daniel.lezcano@linaro.org
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
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
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
Subject: [PATCH v1 00/17] Self-encapsulate the thermal zone device structure
Date:   Sun, 19 Feb 2023 15:36:40 +0100
Message-Id: <20230219143657.241542-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The exported thermal headers expose the thermal core structure while those
should be private to the framework. The initial idea was the thermal sensor
drivers use the thermal zone device structure pointer to pass it around from
the ops to the thermal framework API like a handler.

Unfortunately, different drivers are using and abusing the internals of this
structure to hook the associated struct device, read the internals values, take
the lock, etc ...

rn order to fix this situation, let's encapsulate the structure leaking the
more in the different drivers: the thermal_zone_device structure.

This series revisit the existing drivers using the thermal zone private
structure internals to change the access to something else. For instance, the
get_temp() ops is using the tz->dev to write a debug trace. Despite the trace
is not helpful, we can check the return value for the get_temp() ops in the
call site and show the message in this place.

With this set of changes, the thermal_zone_device is almost self-encapsulated.
As usual, the acpi driver needs a more complex changes, so that will come in a
separate series along with the structure moved the private core headers.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Petr Machata <petrm@nvidia.com>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amitk@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Markus Mayer <mmayer@broadcom.com>
Cc: Support Opensource <support.opensource@diasemi.com>
Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>
Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Orson Zhai <orsonzhai@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Yangtao Li <tiny.windzz@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Talel Shenhar <talel@amazon.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Zheng Yongjun <zhengyongjun3@huawei.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Balsam CHIHI <bchihi@baylibre.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-hwmon@vger.kernel.org
Cc: linux-iio@vger.kernel.org
Cc: linux-sunxi@lists.linux.dev
Cc: linux-input@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org


Daniel Lezcano (17):
  thermal/core: Add a thermal zone 'devdata' accessor
  thermal/core: Show a debug message when get_temp() fails
  thermal: Remove debug or error messages in get_temp() ops
  thermal/hwmon: Do not set no_hwmon before calling
    thermal_add_hwmon_sysfs()
  thermal/hwmon: Use the right device for devm_thermal_add_hwmon_sysfs()
  thermal: Don't use 'device' internal thermal zone structure field
  thermal/hwmon: Use the thermal API instead tampering the internals
  thermal/drivers/spear: Don't use tz->device but pdev->dev
  thermal: Add a thermal zone id accessor
  thermal: Do not access 'type' field, use the tz id instead
  thermal/drivers/da9062: Don't access the thermal zone device fields
  thermal/hwmon: Use the thermal_core.h header
  thermal/drivers/tegra: Remove unneeded lock when setting a trip point
  thermal/tegra: Do not enable the thermal zone, it is already enabled
  thermal/drivers/acerhdf: Make interval setting only at module load
    time
  thermal/drivers/acerhdf: Remove pointless governor test
  thermal/traces: Replace the thermal zone structure parameter with the
    field value

 drivers/acpi/thermal.c                        | 18 +++----
 drivers/ata/ahci_imx.c                        |  2 +-
 drivers/hwmon/hwmon.c                         |  4 +-
 drivers/hwmon/pmbus/pmbus_core.c              |  2 +-
 drivers/hwmon/scmi-hwmon.c                    |  4 +-
 drivers/hwmon/scpi-hwmon.c                    |  2 +-
 drivers/iio/adc/sun4i-gpadc-iio.c             |  2 +-
 drivers/input/touchscreen/sun4i-ts.c          |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_thermal.c    |  2 +-
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 18 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c   |  4 +-
 drivers/platform/x86/acerhdf.c                | 19 ++------
 drivers/power/supply/power_supply_core.c      |  2 +-
 drivers/regulator/max8973-regulator.c         |  2 +-
 drivers/thermal/amlogic_thermal.c             |  2 +-
 drivers/thermal/armada_thermal.c              | 14 ++----
 drivers/thermal/broadcom/bcm2711_thermal.c    |  3 +-
 drivers/thermal/broadcom/bcm2835_thermal.c    |  3 +-
 drivers/thermal/broadcom/brcmstb_thermal.c    |  8 ++--
 drivers/thermal/broadcom/ns-thermal.c         |  2 +-
 drivers/thermal/broadcom/sr-thermal.c         |  2 +-
 drivers/thermal/da9062-thermal.c              | 13 +++--
 drivers/thermal/dove_thermal.c                |  7 +--
 drivers/thermal/gov_fair_share.c              |  2 +-
 drivers/thermal/gov_power_allocator.c         |  4 +-
 drivers/thermal/gov_step_wise.c               |  2 +-
 drivers/thermal/hisi_thermal.c                |  5 +-
 drivers/thermal/imx8mm_thermal.c              |  4 +-
 drivers/thermal/imx_sc_thermal.c              |  9 ++--
 drivers/thermal/imx_thermal.c                 | 47 +++++--------------
 drivers/thermal/intel/intel_pch_thermal.c     |  2 +-
 drivers/thermal/intel/intel_soc_dts_iosf.c    | 13 ++---
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |  4 +-
 drivers/thermal/k3_bandgap.c                  |  4 +-
 drivers/thermal/k3_j72xx_bandgap.c            |  2 +-
 drivers/thermal/kirkwood_thermal.c            |  7 +--
 drivers/thermal/max77620_thermal.c            |  6 +--
 drivers/thermal/mediatek/auxadc_thermal.c     |  4 +-
 drivers/thermal/mediatek/lvts_thermal.c       |  9 ++--
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c      |  6 +--
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c   |  6 +--
 drivers/thermal/qcom/tsens.c                  |  4 +-
 drivers/thermal/qoriq_thermal.c               |  4 +-
 drivers/thermal/rcar_gen3_thermal.c           |  5 +-
 drivers/thermal/rcar_thermal.c                |  8 +---
 drivers/thermal/rockchip_thermal.c            |  8 +---
 drivers/thermal/rzg2l_thermal.c               |  3 +-
 drivers/thermal/samsung/exynos_tmu.c          |  4 +-
 drivers/thermal/spear_thermal.c               | 10 ++--
 drivers/thermal/sprd_thermal.c                |  2 +-
 drivers/thermal/st/st_thermal.c               |  2 -
 drivers/thermal/sun8i_thermal.c               |  4 +-
 drivers/thermal/tegra/tegra-bpmp-thermal.c    |  6 ++-
 drivers/thermal/tegra/tegra30-tsensor.c       | 31 ++++++------
 drivers/thermal/thermal-generic-adc.c         |  7 ++-
 drivers/thermal/thermal_core.c                | 17 ++++++-
 drivers/thermal/thermal_helpers.c             |  3 ++
 drivers/thermal/thermal_hwmon.c               | 19 +++-----
 drivers/thermal/thermal_hwmon.h               |  4 +-
 drivers/thermal/thermal_mmio.c                |  2 +-
 .../ti-soc-thermal/ti-thermal-common.c        | 10 ++--
 drivers/thermal/uniphier_thermal.c            |  2 +-
 include/linux/thermal.h                       |  4 ++
 include/trace/events/thermal.h                | 24 +++++-----
 .../trace/events/thermal_power_allocator.h    | 12 ++---
 65 files changed, 203 insertions(+), 265 deletions(-)

-- 
2.34.1

