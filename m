Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68DC69C0C6
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 15:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBSOi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 09:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjBSOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 09:38:00 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AFE11EBB
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 06:37:45 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id e2so658642wri.12
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 06:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+N523DtRIKKcMxEOWF7Xp597YFQu0I7H1QHTM+dJ87Y=;
        b=zoI4AczXwtkNEOIFMl2oWk0sfwHGUIOKbwJ7fxs9HBT1kYlKyNxDAVtcxnuPL7HZAp
         aeGd45T+A5eSgm/YMeoBgVNkP/wyvF9ZnW8/u4iMMy6TQWfbcvndVU5soyXr6OBCSR46
         RZ59G74q82Ff/AaCnR3f28ZJMUZADKCyiR3FLYK+1RY6lqIDFyLs4YFEpGT5r3jRIjPQ
         Wf89lMkC148L6syx+bYrRScekQtrRo1JmsHppFSFNlTP5QMqmTm1o7LgLiK2uKzITeBZ
         OLe0+7/K2iWX2jNPx699wzunQnWJEAe0t4c6IJXueluq1Ft3ispSCeM+QdbXLgIW5mAf
         9J1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+N523DtRIKKcMxEOWF7Xp597YFQu0I7H1QHTM+dJ87Y=;
        b=RZDNsuh6onwQujb9CsZBJ1NOJVvBp/HYXYgBjzMOdgwd48Ychb1tNdcWHjO8U+GyzT
         MbYhSEDavEyW/ro9zftrb/Pocs23m4gCrY/Z5RZ3yhAZyLoy+VXt2wekf3uD2NGcsu9t
         IM/iRljPHgqd709ITdBM5WaDmorzxNSs7tvIfzD8SETlATyFCc+OQhONw5rn4POhPvh3
         d+YomonZ4CZJMXmbiYxnSm36MQ7L9JvKSWc9KCyAHuiDFpKiz66qh8ZLD4d1rydtujdL
         APQHAlV8iAdTi/56g9J4pJMcH97z9jg4DEgfaBA+rmbZHEMiY32ubhoJUnjTvGI4fnz+
         b/Hg==
X-Gm-Message-State: AO0yUKXbrn6J36uNExa/Y9Wj5fHTmvyVrBtMylnJmbYoo25lNLHKqDsV
        jTrMkSc1ooOjkGXsBvn61PhH6Q==
X-Google-Smtp-Source: AK7set8/ARAo2mVqPni3Z48Cd9X8pVAhnwoeFMwIQIpYB8CWtiLwCY9ebYk8SLCeLLePa3xixPYaxw==
X-Received: by 2002:adf:ea43:0:b0:2c5:6180:516e with SMTP id j3-20020adfea43000000b002c56180516emr147449wrn.39.1676817463812;
        Sun, 19 Feb 2023 06:37:43 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:6f43:b92:7670:463])
        by smtp.gmail.com with ESMTPSA id a18-20020adfe5d2000000b002be505ab59asm86176wrn.97.2023.02.19.06.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 06:37:43 -0800 (PST)
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
        linux-acpi@vger.kernel.org (open list:ACPI THERMAL DRIVER),
        linux-ide@vger.kernel.org (open list:LIBATA SUBSYSTEM (Serial and
        Parallel ATA drivers)),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/FREESCALE IMX
        / MXC ARM ARCHITECTURE),
        linux-hwmon@vger.kernel.org (open list:HARDWARE MONITORING),
        linux-iio@vger.kernel.org (open list:IIO SUBSYSTEM AND DRIVERS),
        linux-sunxi@lists.linux.dev (open list:ARM/Allwinner sunXi SoC support),
        linux-input@vger.kernel.org (open list:INPUT (KEYBOARD, MOUSE, JOYSTICK
        , TOUCHSCREEN)...),
        netdev@vger.kernel.org (open list:CXGB4 ETHERNET DRIVER (CXGB4)),
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)),
        linux-rpi-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE),
        linux-arm-msm@vger.kernel.org (open list:ARM/QUALCOMM SUPPORT),
        linux-renesas-soc@vger.kernel.org (open list:RENESAS R-CAR THERMAL
        DRIVERS),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC support),
        linux-samsung-soc@vger.kernel.org (open list:SAMSUNG THERMAL DRIVER),
        linux-tegra@vger.kernel.org (open list:TEGRA ARCHITECTURE SUPPORT),
        linux-omap@vger.kernel.org (open list:TI BANDGAP AND THERMAL DRIVER),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata' accessor
Date:   Sun, 19 Feb 2023 15:36:41 +0100
Message-Id: <20230219143657.241542-2-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219143657.241542-1-daniel.lezcano@linaro.org>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
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

The thermal zone device structure is exposed to the different drivers
and obviously they access the internals while that should be
restricted to the core thermal code.

In order to self-encapsulate the thermal core code, we need to prevent
the drivers accessing directly the thermal zone structure and provide
accessor functions to deal with.

Provide an accessor to the 'devdata' structure and make use of it in
the different drivers.

No functional changes intended.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/acpi/thermal.c                           | 16 ++++++++--------
 drivers/ata/ahci_imx.c                           |  2 +-
 drivers/hwmon/hwmon.c                            |  4 ++--
 drivers/hwmon/pmbus/pmbus_core.c                 |  2 +-
 drivers/hwmon/scmi-hwmon.c                       |  2 +-
 drivers/hwmon/scpi-hwmon.c                       |  2 +-
 drivers/iio/adc/sun4i-gpadc-iio.c                |  2 +-
 drivers/input/touchscreen/sun4i-ts.c             |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_thermal.c   |  2 +-
 .../net/ethernet/mellanox/mlxsw/core_thermal.c   | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c      |  4 ++--
 drivers/power/supply/power_supply_core.c         |  2 +-
 drivers/regulator/max8973-regulator.c            |  2 +-
 drivers/thermal/armada_thermal.c                 |  4 ++--
 drivers/thermal/broadcom/bcm2711_thermal.c       |  2 +-
 drivers/thermal/broadcom/bcm2835_thermal.c       |  2 +-
 drivers/thermal/broadcom/brcmstb_thermal.c       |  4 ++--
 drivers/thermal/broadcom/ns-thermal.c            |  2 +-
 drivers/thermal/broadcom/sr-thermal.c            |  2 +-
 drivers/thermal/da9062-thermal.c                 |  2 +-
 drivers/thermal/dove_thermal.c                   |  2 +-
 drivers/thermal/hisi_thermal.c                   |  2 +-
 drivers/thermal/imx8mm_thermal.c                 |  2 +-
 drivers/thermal/imx_sc_thermal.c                 |  2 +-
 drivers/thermal/imx_thermal.c                    |  6 +++---
 drivers/thermal/intel/intel_pch_thermal.c        |  2 +-
 drivers/thermal/intel/intel_soc_dts_iosf.c       | 13 +++++--------
 drivers/thermal/intel/x86_pkg_temp_thermal.c     |  4 ++--
 drivers/thermal/k3_bandgap.c                     |  2 +-
 drivers/thermal/k3_j72xx_bandgap.c               |  2 +-
 drivers/thermal/kirkwood_thermal.c               |  2 +-
 drivers/thermal/max77620_thermal.c               |  2 +-
 drivers/thermal/mediatek/auxadc_thermal.c        |  2 +-
 drivers/thermal/mediatek/lvts_thermal.c          |  4 ++--
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c         |  4 ++--
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c      |  4 ++--
 drivers/thermal/qoriq_thermal.c                  |  2 +-
 drivers/thermal/rcar_gen3_thermal.c              |  4 ++--
 drivers/thermal/rcar_thermal.c                   |  3 +--
 drivers/thermal/rockchip_thermal.c               |  4 ++--
 drivers/thermal/rzg2l_thermal.c                  |  2 +-
 drivers/thermal/samsung/exynos_tmu.c             |  4 ++--
 drivers/thermal/spear_thermal.c                  |  8 ++++----
 drivers/thermal/sprd_thermal.c                   |  2 +-
 drivers/thermal/sun8i_thermal.c                  |  2 +-
 drivers/thermal/tegra/tegra-bpmp-thermal.c       |  6 ++++--
 drivers/thermal/tegra/tegra30-tsensor.c          |  4 ++--
 drivers/thermal/thermal-generic-adc.c            |  2 +-
 drivers/thermal/thermal_core.c                   |  6 ++++++
 drivers/thermal/thermal_mmio.c                   |  2 +-
 .../thermal/ti-soc-thermal/ti-thermal-common.c   |  4 ++--
 drivers/thermal/uniphier_thermal.c               |  2 +-
 include/linux/thermal.h                          |  2 ++
 53 files changed, 97 insertions(+), 91 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 0b4b844f9d4c..69d0da6456d5 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -498,7 +498,7 @@ static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 
 static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 	int result;
 
 	if (!tz)
@@ -516,7 +516,7 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
 static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 				 int trip, enum thermal_trip_type *type)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 	int i;
 
 	if (!tz || trip < 0)
@@ -560,7 +560,7 @@ static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
 				 int trip, int *temp)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 	int i;
 
 	if (!tz || trip < 0)
@@ -613,7 +613,7 @@ static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
 static int thermal_get_crit_temp(struct thermal_zone_device *thermal,
 				int *temperature)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 
 	if (tz->trips.critical.flags.valid) {
 		*temperature = deci_kelvin_to_millicelsius_with_offset(
@@ -628,7 +628,7 @@ static int thermal_get_crit_temp(struct thermal_zone_device *thermal,
 static int thermal_get_trend(struct thermal_zone_device *thermal,
 			     int trip, enum thermal_trend *trend)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 	enum thermal_trip_type type;
 	int i;
 
@@ -670,7 +670,7 @@ static int thermal_get_trend(struct thermal_zone_device *thermal,
 
 static void acpi_thermal_zone_device_hot(struct thermal_zone_device *thermal)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 
 	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
 					dev_name(&tz->device->dev),
@@ -679,7 +679,7 @@ static void acpi_thermal_zone_device_hot(struct thermal_zone_device *thermal)
 
 static void acpi_thermal_zone_device_critical(struct thermal_zone_device *thermal)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 
 	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
 					dev_name(&tz->device->dev),
@@ -693,7 +693,7 @@ static int acpi_thermal_cooling_device_cb(struct thermal_zone_device *thermal,
 					  bool bind)
 {
 	struct acpi_device *device = cdev->devdata;
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_get_data(thermal);
 	struct acpi_device *dev;
 	acpi_handle handle;
 	int i;
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index a950767f7948..0ef928528aec 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -418,7 +418,7 @@ static int __sata_ahci_read_temperature(void *dev, int *temp)
 
 static int sata_ahci_read_temperature(struct thermal_zone_device *tz, int *temp)
 {
-	return __sata_ahci_read_temperature(tz->devdata, temp);
+	return __sata_ahci_read_temperature(thermal_zone_device_get_data(tz), temp);
 }
 
 static ssize_t sata_ahci_show_temp(struct device *dev,
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 33edb5c02f7d..b33477d04c2b 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -154,7 +154,7 @@ static DEFINE_IDA(hwmon_ida);
 #ifdef CONFIG_THERMAL_OF
 static int hwmon_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct hwmon_thermal_data *tdata = tz->devdata;
+	struct hwmon_thermal_data *tdata = thermal_zone_device_get_data(tz);
 	struct hwmon_device *hwdev = to_hwmon_device(tdata->dev);
 	int ret;
 	long t;
@@ -171,7 +171,7 @@ static int hwmon_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 
 static int hwmon_thermal_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	struct hwmon_thermal_data *tdata = tz->devdata;
+	struct hwmon_thermal_data *tdata = thermal_zone_device_get_data(tz);
 	struct hwmon_device *hwdev = to_hwmon_device(tdata->dev);
 	const struct hwmon_chip_info *chip = hwdev->chip;
 	const struct hwmon_channel_info **info = chip->info;
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 95e95783972a..159a88af6277 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1272,7 +1272,7 @@ struct pmbus_thermal_data {
 
 static int pmbus_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct pmbus_thermal_data *tdata = tz->devdata;
+	struct pmbus_thermal_data *tdata = thermal_zone_device_get_data(tz);
 	struct pmbus_sensor *sensor = tdata->sensor;
 	struct pmbus_data *pmbus_data = tdata->pmbus_data;
 	struct i2c_client *client = to_i2c_client(pmbus_data->dev);
diff --git a/drivers/hwmon/scmi-hwmon.c b/drivers/hwmon/scmi-hwmon.c
index e192f0c67146..7951b6026f48 100644
--- a/drivers/hwmon/scmi-hwmon.c
+++ b/drivers/hwmon/scmi-hwmon.c
@@ -141,7 +141,7 @@ static int scmi_hwmon_thermal_get_temp(struct thermal_zone_device *tz,
 {
 	int ret;
 	long value;
-	struct scmi_thermal_sensor *th_sensor = tz->devdata;
+	struct scmi_thermal_sensor *th_sensor = thermal_zone_device_get_data(tz);
 
 	ret = scmi_hwmon_read_scaled_value(th_sensor->ph, th_sensor->info,
 					   &value);
diff --git a/drivers/hwmon/scpi-hwmon.c b/drivers/hwmon/scpi-hwmon.c
index 4d75385f7d5e..efe0ddbc5293 100644
--- a/drivers/hwmon/scpi-hwmon.c
+++ b/drivers/hwmon/scpi-hwmon.c
@@ -64,7 +64,7 @@ static void scpi_scale_reading(u64 *value, struct sensor_data *sensor)
 
 static int scpi_read_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct scpi_thermal_zone *zone = tz->devdata;
+	struct scpi_thermal_zone *zone = thermal_zone_device_get_data(tz);
 	struct scpi_sensors *scpi_sensors = zone->scpi_sensors;
 	struct scpi_ops *scpi_ops = scpi_sensors->scpi_ops;
 	struct sensor_data *sensor = &scpi_sensors->data[zone->sensor_id];
diff --git a/drivers/iio/adc/sun4i-gpadc-iio.c b/drivers/iio/adc/sun4i-gpadc-iio.c
index a6ade70dedf8..e24ac3ee8a35 100644
--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -414,7 +414,7 @@ static int sun4i_gpadc_runtime_resume(struct device *dev)
 
 static int sun4i_gpadc_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct sun4i_gpadc_iio *info = tz->devdata;
+	struct sun4i_gpadc_iio *info = thermal_zone_device_get_data(tz);
 	int val, scale, offset;
 
 	if (sun4i_gpadc_temp_read(info->indio_dev, &val))
diff --git a/drivers/input/touchscreen/sun4i-ts.c b/drivers/input/touchscreen/sun4i-ts.c
index 73eb8f80be6e..5e5434ffe397 100644
--- a/drivers/input/touchscreen/sun4i-ts.c
+++ b/drivers/input/touchscreen/sun4i-ts.c
@@ -194,7 +194,7 @@ static int sun4i_get_temp(const struct sun4i_ts_data *ts, int *temp)
 
 static int sun4i_get_tz_temp(struct thermal_zone_device *tz, int *temp)
 {
-	return sun4i_get_temp(tz->devdata, temp);
+	return sun4i_get_temp(thermal_zone_device_get_data(tz), temp);
 }
 
 static const struct thermal_zone_device_ops sun4i_ts_tz_ops = {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
index 95e1b415ba13..8b0d318feef4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
@@ -12,7 +12,7 @@
 static int cxgb4_thermal_get_temp(struct thermal_zone_device *tzdev,
 				  int *temp)
 {
-	struct adapter *adap = tzdev->devdata;
+	struct adapter *adap = thermal_zone_device_get_data(tzdev);
 	u32 param, val;
 	int ret;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index c5240d38c9db..228b6ffaef98 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -201,7 +201,7 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 			      struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal *thermal = thermal_zone_device_get_data(tzdev);
 	struct device *dev = thermal->bus_info->dev;
 	int i, err;
 
@@ -227,7 +227,7 @@ static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
 				struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal *thermal = thermal_zone_device_get_data(tzdev);
 	struct device *dev = thermal->bus_info->dev;
 	int i;
 	int err;
@@ -249,7 +249,7 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 				  int *p_temp)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal *thermal = thermal_zone_device_get_data(tzdev);
 	struct device *dev = thermal->bus_info->dev;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int temp;
@@ -281,7 +281,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
 				     struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_get_data(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	int i, j, err;
 
@@ -310,7 +310,7 @@ static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
 				       struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_get_data(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	int i;
 	int err;
@@ -356,7 +356,7 @@ mlxsw_thermal_module_temp_and_thresholds_get(struct mlxsw_core *core,
 static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 					 int *p_temp)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_get_data(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	int temp, crit_temp, emerg_temp;
 	struct device *dev;
@@ -391,7 +391,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 					  int *p_temp)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_get_data(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	u16 index;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 232c200af38f..ee8fee29107f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -615,7 +615,7 @@ int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm)
 static int iwl_mvm_tzone_get_temp(struct thermal_zone_device *device,
 				  int *temperature)
 {
-	struct iwl_mvm *mvm = (struct iwl_mvm *)device->devdata;
+	struct iwl_mvm *mvm = thermal_zone_device_get_data(device);
 	int ret;
 	int temp;
 
@@ -641,7 +641,7 @@ static int iwl_mvm_tzone_get_temp(struct thermal_zone_device *device,
 static int iwl_mvm_tzone_set_trip_temp(struct thermal_zone_device *device,
 				       int trip, int temp)
 {
-	struct iwl_mvm *mvm = (struct iwl_mvm *)device->devdata;
+	struct iwl_mvm *mvm = thermal_zone_device_get_data(device);
 	struct iwl_mvm_thermal_device *tzone;
 	int ret;
 
diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 7c790c41e2fe..166f0aacc797 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1142,7 +1142,7 @@ static int power_supply_read_temp(struct thermal_zone_device *tzd,
 	int ret;
 
 	WARN_ON(tzd == NULL);
-	psy = tzd->devdata;
+	psy = thermal_zone_device_get_data(tzd);
 	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_TEMP, &val);
 	if (ret)
 		return ret;
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 7e00a45db26a..ccacba66d367 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -436,7 +436,7 @@ static int max8973_init_dcdc(struct max8973_chip *max,
 
 static int max8973_thermal_read_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct max8973_chip *mchip = tz->devdata;
+	struct max8973_chip *mchip = thermal_zone_device_get_data(tz);
 	unsigned int val;
 	int ret;
 
diff --git a/drivers/thermal/armada_thermal.c b/drivers/thermal/armada_thermal.c
index 2efc222a379b..82d3e15d51f6 100644
--- a/drivers/thermal/armada_thermal.c
+++ b/drivers/thermal/armada_thermal.c
@@ -398,7 +398,7 @@ static int armada_read_sensor(struct armada_thermal_priv *priv, int *temp)
 static int armada_get_temp_legacy(struct thermal_zone_device *thermal,
 				  int *temp)
 {
-	struct armada_thermal_priv *priv = thermal->devdata;
+	struct armada_thermal_priv *priv = thermal_zone_device_get_data(thermal);
 	int ret;
 
 	/* Valid check */
@@ -420,7 +420,7 @@ static struct thermal_zone_device_ops legacy_ops = {
 
 static int armada_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct armada_thermal_sensor *sensor = tz->devdata;
+	struct armada_thermal_sensor *sensor = thermal_zone_device_get_data(tz);
 	struct armada_thermal_priv *priv = sensor->priv;
 	int ret;
 
diff --git a/drivers/thermal/broadcom/bcm2711_thermal.c b/drivers/thermal/broadcom/bcm2711_thermal.c
index 1f8651d15160..18b1a4d9ecc7 100644
--- a/drivers/thermal/broadcom/bcm2711_thermal.c
+++ b/drivers/thermal/broadcom/bcm2711_thermal.c
@@ -33,7 +33,7 @@ struct bcm2711_thermal_priv {
 
 static int bcm2711_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct bcm2711_thermal_priv *priv = tz->devdata;
+	struct bcm2711_thermal_priv *priv = thermal_zone_device_get_data(tz);
 	int slope = thermal_zone_get_slope(tz);
 	int offset = thermal_zone_get_offset(tz);
 	u32 val;
diff --git a/drivers/thermal/broadcom/bcm2835_thermal.c b/drivers/thermal/broadcom/bcm2835_thermal.c
index 23918bb76ae6..de2f573863da 100644
--- a/drivers/thermal/broadcom/bcm2835_thermal.c
+++ b/drivers/thermal/broadcom/bcm2835_thermal.c
@@ -90,7 +90,7 @@ static int bcm2835_thermal_temp2adc(int temp, int offset, int slope)
 
 static int bcm2835_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct bcm2835_thermal_data *data = tz->devdata;
+	struct bcm2835_thermal_data *data = thermal_zone_device_get_data(tz);
 	u32 val = readl(data->regs + BCM2835_TS_TSENSSTAT);
 
 	if (!(val & BCM2835_TS_TSENSSTAT_VALID))
diff --git a/drivers/thermal/broadcom/brcmstb_thermal.c b/drivers/thermal/broadcom/brcmstb_thermal.c
index 4d02c28331e3..668cdc16b108 100644
--- a/drivers/thermal/broadcom/brcmstb_thermal.c
+++ b/drivers/thermal/broadcom/brcmstb_thermal.c
@@ -152,7 +152,7 @@ static inline u32 avs_tmon_temp_to_code(struct brcmstb_thermal_priv *priv,
 
 static int brcmstb_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct brcmstb_thermal_priv *priv = tz->devdata;
+	struct brcmstb_thermal_priv *priv = thermal_zone_device_get_data(tz);
 	u32 val;
 	long t;
 
@@ -262,7 +262,7 @@ static irqreturn_t brcmstb_tmon_irq_thread(int irq, void *data)
 
 static int brcmstb_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	struct brcmstb_thermal_priv *priv = tz->devdata;
+	struct brcmstb_thermal_priv *priv = thermal_zone_device_get_data(tz);
 
 	dev_dbg(priv->dev, "set trips %d <--> %d\n", low, high);
 
diff --git a/drivers/thermal/broadcom/ns-thermal.c b/drivers/thermal/broadcom/ns-thermal.c
index 07a8a3f49bd0..98296019ad4c 100644
--- a/drivers/thermal/broadcom/ns-thermal.c
+++ b/drivers/thermal/broadcom/ns-thermal.c
@@ -16,7 +16,7 @@
 
 static int ns_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	void __iomem *pvtmon = tz->devdata;
+	void __iomem *pvtmon = thermal_zone_device_get_data(tz);
 	int offset = thermal_zone_get_offset(tz);
 	int slope = thermal_zone_get_slope(tz);
 	u32 val;
diff --git a/drivers/thermal/broadcom/sr-thermal.c b/drivers/thermal/broadcom/sr-thermal.c
index 2b93502543ff..42b46125f409 100644
--- a/drivers/thermal/broadcom/sr-thermal.c
+++ b/drivers/thermal/broadcom/sr-thermal.c
@@ -32,7 +32,7 @@ struct sr_thermal {
 
 static int sr_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct sr_tmon *tmon = tz->devdata;
+	struct sr_tmon *tmon = thermal_zone_device_get_data(tz);
 	struct sr_thermal *sr_thermal = tmon->priv;
 
 	*temp = readl(sr_thermal->regs + SR_TMON_TEMP_BASE(tmon->tmon_id));
diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
index a805a6666c44..3d937f701e0b 100644
--- a/drivers/thermal/da9062-thermal.c
+++ b/drivers/thermal/da9062-thermal.c
@@ -123,7 +123,7 @@ static irqreturn_t da9062_thermal_irq_handler(int irq, void *data)
 static int da9062_thermal_get_temp(struct thermal_zone_device *z,
 				   int *temp)
 {
-	struct da9062_thermal *thermal = z->devdata;
+	struct da9062_thermal *thermal = thermal_zone_device_get_data(z);
 
 	mutex_lock(&thermal->lock);
 	*temp = thermal->temperature;
diff --git a/drivers/thermal/dove_thermal.c b/drivers/thermal/dove_thermal.c
index 056622a58d00..ed7d1173d9fd 100644
--- a/drivers/thermal/dove_thermal.c
+++ b/drivers/thermal/dove_thermal.c
@@ -87,7 +87,7 @@ static int dove_get_temp(struct thermal_zone_device *thermal,
 			  int *temp)
 {
 	unsigned long reg;
-	struct dove_thermal_priv *priv = thermal->devdata;
+	struct dove_thermal_priv *priv = thermal_zone_device_get_data(thermal);
 
 	/* Valid check */
 	reg = readl_relaxed(priv->control + PMU_TEMP_DIOD_CTRL1_REG);
diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
index 32a7c3cf073d..043751e6a31d 100644
--- a/drivers/thermal/hisi_thermal.c
+++ b/drivers/thermal/hisi_thermal.c
@@ -431,7 +431,7 @@ static int hi3660_thermal_probe(struct hisi_thermal_data *data)
 
 static int hisi_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct hisi_thermal_sensor *sensor = tz->devdata;
+	struct hisi_thermal_sensor *sensor = thermal_zone_device_get_data(tz);
 	struct hisi_thermal_data *data = sensor->data;
 
 	*temp = data->ops->get_temp(sensor);
diff --git a/drivers/thermal/imx8mm_thermal.c b/drivers/thermal/imx8mm_thermal.c
index 72b5d6f319c1..750240f4fa32 100644
--- a/drivers/thermal/imx8mm_thermal.c
+++ b/drivers/thermal/imx8mm_thermal.c
@@ -141,7 +141,7 @@ static int imx8mp_tmu_get_temp(void *data, int *temp)
 
 static int tmu_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct tmu_sensor *sensor = tz->devdata;
+	struct tmu_sensor *sensor = thermal_zone_device_get_data(tz);
 	struct imx8mm_tmu *tmu = sensor->priv;
 
 	return tmu->socdata->get_temp(sensor, temp);
diff --git a/drivers/thermal/imx_sc_thermal.c b/drivers/thermal/imx_sc_thermal.c
index f32e59e74623..ca10d6a68f0f 100644
--- a/drivers/thermal/imx_sc_thermal.c
+++ b/drivers/thermal/imx_sc_thermal.c
@@ -46,7 +46,7 @@ static int imx_sc_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
 	struct imx_sc_msg_misc_get_temp msg;
 	struct imx_sc_rpc_msg *hdr = &msg.hdr;
-	struct imx_sc_sensor *sensor = tz->devdata;
+	struct imx_sc_sensor *sensor = thermal_zone_device_get_data(tz);
 	int ret;
 
 	msg.data.req.resource_id = sensor->resource_id;
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index fb0d5cab70af..c3c14cd26aee 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -252,7 +252,7 @@ static void imx_set_alarm_temp(struct imx_thermal_data *data,
 
 static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct imx_thermal_data *data = tz->devdata;
+	struct imx_thermal_data *data = thermal_zone_device_get_data(tz);
 	const struct thermal_soc_data *soc_data = data->socdata;
 	struct regmap *map = data->tempmon;
 	unsigned int n_meas;
@@ -311,7 +311,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 static int imx_change_mode(struct thermal_zone_device *tz,
 			   enum thermal_device_mode mode)
 {
-	struct imx_thermal_data *data = tz->devdata;
+	struct imx_thermal_data *data = thermal_zone_device_get_data(tz);
 
 	if (mode == THERMAL_DEVICE_ENABLED) {
 		pm_runtime_get(data->dev);
@@ -342,7 +342,7 @@ static int imx_get_crit_temp(struct thermal_zone_device *tz, int *temp)
 static int imx_set_trip_temp(struct thermal_zone_device *tz, int trip,
 			     int temp)
 {
-	struct imx_thermal_data *data = tz->devdata;
+	struct imx_thermal_data *data = thermal_zone_device_get_data(tz);
 	int ret;
 
 	ret = pm_runtime_resume_and_get(data->dev);
diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
index b855d031a855..e53f8a8c06e5 100644
--- a/drivers/thermal/intel/intel_pch_thermal.c
+++ b/drivers/thermal/intel/intel_pch_thermal.c
@@ -119,7 +119,7 @@ static int pch_wpt_add_acpi_psv_trip(struct pch_thermal_device *ptd, int trip)
 
 static int pch_thermal_get_temp(struct thermal_zone_device *tzd, int *temp)
 {
-	struct pch_thermal_device *ptd = tzd->devdata;
+	struct pch_thermal_device *ptd = thermal_zone_device_get_data(tzd);
 
 	*temp = GET_WPT_TEMP(WPT_TEMP_TSR & readw(ptd->hw_base + WPT_TEMP));
 	return 0;
diff --git a/drivers/thermal/intel/intel_soc_dts_iosf.c b/drivers/thermal/intel/intel_soc_dts_iosf.c
index 8c26f7b2316b..f7d995722e04 100644
--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -54,7 +54,7 @@ static int sys_get_trip_temp(struct thermal_zone_device *tzd, int trip,
 	struct intel_soc_dts_sensor_entry *dts;
 	struct intel_soc_dts_sensors *sensors;
 
-	dts = tzd->devdata;
+	dts = thermal_zone_device_get_data(tzd);
 	sensors = dts->sensors;
 	mutex_lock(&sensors->dts_update_lock);
 	status = iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ,
@@ -168,7 +168,7 @@ static int update_trip_temp(struct intel_soc_dts_sensor_entry *dts,
 static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
 			     int temp)
 {
-	struct intel_soc_dts_sensor_entry *dts = tzd->devdata;
+	struct intel_soc_dts_sensor_entry *dts = thermal_zone_device_get_data(tzd);
 	struct intel_soc_dts_sensors *sensors = dts->sensors;
 	int status;
 
@@ -176,7 +176,7 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
 		return -EINVAL;
 
 	mutex_lock(&sensors->dts_update_lock);
-	status = update_trip_temp(tzd->devdata, trip, temp,
+	status = update_trip_temp(dts, trip, temp,
 				  dts->trip_types[trip]);
 	mutex_unlock(&sensors->dts_update_lock);
 
@@ -186,9 +186,7 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
 static int sys_get_trip_type(struct thermal_zone_device *tzd,
 			     int trip, enum thermal_trip_type *type)
 {
-	struct intel_soc_dts_sensor_entry *dts;
-
-	dts = tzd->devdata;
+	struct intel_soc_dts_sensor_entry *dts = thermal_zone_device_get_data(tzd);
 
 	*type = dts->trip_types[trip];
 
@@ -200,11 +198,10 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
 {
 	int status;
 	u32 out;
-	struct intel_soc_dts_sensor_entry *dts;
+	struct intel_soc_dts_sensor_entry *dts = thermal_zone_device_get_data(tzd);
 	struct intel_soc_dts_sensors *sensors;
 	unsigned long raw;
 
-	dts = tzd->devdata;
 	sensors = dts->sensors;
 	status = iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ,
 			       SOC_DTS_OFFSET_TEMP, &out);
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 1c2de84742df..22f0f206d8f2 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -107,7 +107,7 @@ static struct zone_device *pkg_temp_thermal_get_dev(unsigned int cpu)
 
 static int sys_get_curr_temp(struct thermal_zone_device *tzd, int *temp)
 {
-	struct zone_device *zonedev = tzd->devdata;
+	struct zone_device *zonedev = thermal_zone_device_get_data(tzd);
 	int val;
 
 	val = intel_tcc_get_temp(zonedev->cpu, true);
@@ -122,7 +122,7 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd, int *temp)
 static int
 sys_set_trip_temp(struct thermal_zone_device *tzd, int trip, int temp)
 {
-	struct zone_device *zonedev = tzd->devdata;
+	struct zone_device *zonedev = thermal_zone_device_get_data(tzd);
 	u32 l, h, mask, shift, intr;
 	int tj_max, ret;
 
diff --git a/drivers/thermal/k3_bandgap.c b/drivers/thermal/k3_bandgap.c
index 22c9bcb899c3..8cbd7361b492 100644
--- a/drivers/thermal/k3_bandgap.c
+++ b/drivers/thermal/k3_bandgap.c
@@ -141,7 +141,7 @@ static int k3_bgp_read_temp(struct k3_thermal_data *devdata,
 
 static int k3_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct k3_thermal_data *data = tz->devdata;
+	struct k3_thermal_data *data = thermal_zone_device_get_data(tz);
 	int ret = 0;
 
 	ret = k3_bgp_read_temp(data, temp);
diff --git a/drivers/thermal/k3_j72xx_bandgap.c b/drivers/thermal/k3_j72xx_bandgap.c
index 031ea1091909..300a3f985776 100644
--- a/drivers/thermal/k3_j72xx_bandgap.c
+++ b/drivers/thermal/k3_j72xx_bandgap.c
@@ -248,7 +248,7 @@ static inline int k3_bgp_read_temp(struct k3_thermal_data *devdata,
 /* Get temperature callback function for thermal zone */
 static int k3_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	return k3_bgp_read_temp(tz->devdata, temp);
+	return k3_bgp_read_temp(thermal_zone_device_get_data(tz), temp);
 }
 
 static const struct thermal_zone_device_ops k3_of_thermal_ops = {
diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
index bec7ec20e79d..8e39c875ba58 100644
--- a/drivers/thermal/kirkwood_thermal.c
+++ b/drivers/thermal/kirkwood_thermal.c
@@ -27,7 +27,7 @@ static int kirkwood_get_temp(struct thermal_zone_device *thermal,
 			  int *temp)
 {
 	unsigned long reg;
-	struct kirkwood_thermal_priv *priv = thermal->devdata;
+	struct kirkwood_thermal_priv *priv = thermal_zone_device_get_data(thermal);
 
 	reg = readl_relaxed(priv->sensor);
 
diff --git a/drivers/thermal/max77620_thermal.c b/drivers/thermal/max77620_thermal.c
index 6451a55eb582..05b6e9a2a283 100644
--- a/drivers/thermal/max77620_thermal.c
+++ b/drivers/thermal/max77620_thermal.c
@@ -46,7 +46,7 @@ struct max77620_therm_info {
 
 static int max77620_thermal_read_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct max77620_therm_info *mtherm = tz->devdata;
+	struct max77620_therm_info *mtherm = thermal_zone_device_get_data(tz);
 	unsigned int val;
 	int ret;
 
diff --git a/drivers/thermal/mediatek/auxadc_thermal.c b/drivers/thermal/mediatek/auxadc_thermal.c
index ab730f9552d0..d7bf725d224b 100644
--- a/drivers/thermal/mediatek/auxadc_thermal.c
+++ b/drivers/thermal/mediatek/auxadc_thermal.c
@@ -763,7 +763,7 @@ static int mtk_thermal_bank_temperature(struct mtk_thermal_bank *bank)
 
 static int mtk_read_temp(struct thermal_zone_device *tz, int *temperature)
 {
-	struct mtk_thermal *mt = tz->devdata;
+	struct mtk_thermal *mt = thermal_zone_device_get_data(tz);
 	int i;
 	int tempmax = INT_MIN;
 
diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 84ba65a27acf..86d280187c83 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -252,7 +252,7 @@ static u32 lvts_temp_to_raw(int temperature)
 
 static int lvts_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct lvts_sensor *lvts_sensor = tz->devdata;
+	struct lvts_sensor *lvts_sensor = thermal_zone_device_get_data(tz);
 	void __iomem *msr = lvts_sensor->msr;
 	u32 value;
 
@@ -290,7 +290,7 @@ static int lvts_get_temp(struct thermal_zone_device *tz, int *temp)
 
 static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	struct lvts_sensor *lvts_sensor = tz->devdata;
+	struct lvts_sensor *lvts_sensor = thermal_zone_device_get_data(tz);
 	void __iomem *base = lvts_sensor->base;
 	u32 raw_low = lvts_temp_to_raw(low);
 	u32 raw_high = lvts_temp_to_raw(high);
diff --git a/drivers/thermal/qcom/qcom-spmi-adc-tm5.c b/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
index 31164ade2dd1..b0269daf128a 100644
--- a/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
+++ b/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
@@ -360,7 +360,7 @@ static irqreturn_t adc_tm5_gen2_isr(int irq, void *data)
 
 static int adc_tm5_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct adc_tm5_channel *channel = tz->devdata;
+	struct adc_tm5_channel *channel = thermal_zone_device_get_data(tz);
 	int ret;
 
 	if (!channel || !channel->iio)
@@ -642,7 +642,7 @@ static int adc_tm5_gen2_configure(struct adc_tm5_channel *channel, int low, int
 
 static int adc_tm5_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	struct adc_tm5_channel *channel = tz->devdata;
+	struct adc_tm5_channel *channel = thermal_zone_device_get_data(tz);
 	struct adc_tm5_chip *chip;
 	int ret;
 
diff --git a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
index 101c75d0e13f..c817b03deb00 100644
--- a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
+++ b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
@@ -187,7 +187,7 @@ static int qpnp_tm_update_temp_no_adc(struct qpnp_tm_chip *chip)
 
 static int qpnp_tm_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct qpnp_tm_chip *chip = tz->devdata;
+	struct qpnp_tm_chip *chip = thermal_zone_device_get_data(tz);
 	int ret, mili_celsius;
 
 	if (!temp)
@@ -265,7 +265,7 @@ static int qpnp_tm_update_critical_trip_temp(struct qpnp_tm_chip *chip,
 
 static int qpnp_tm_set_trip_temp(struct thermal_zone_device *tz, int trip_id, int temp)
 {
-	struct qpnp_tm_chip *chip = tz->devdata;
+	struct qpnp_tm_chip *chip = thermal_zone_device_get_data(tz);
 	struct thermal_trip trip;
 	int ret;
 
diff --git a/drivers/thermal/qoriq_thermal.c b/drivers/thermal/qoriq_thermal.c
index 431c29c0898a..8b6fe0c9ade2 100644
--- a/drivers/thermal/qoriq_thermal.c
+++ b/drivers/thermal/qoriq_thermal.c
@@ -83,7 +83,7 @@ static struct qoriq_tmu_data *qoriq_sensor_to_data(struct qoriq_sensor *s)
 
 static int tmu_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct qoriq_sensor *qsensor = tz->devdata;
+	struct qoriq_sensor *qsensor = thermal_zone_device_get_data(tz);
 	struct qoriq_tmu_data *qdata = qoriq_sensor_to_data(qsensor);
 	u32 val;
 	/*
diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index d6b5b59c5c53..8ad713cb4bf7 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -167,7 +167,7 @@ static int rcar_gen3_thermal_round(int temp)
 
 static int rcar_gen3_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct rcar_gen3_thermal_tsc *tsc = tz->devdata;
+	struct rcar_gen3_thermal_tsc *tsc = thermal_zone_device_get_data(tz);
 	int mcelsius, val;
 	int reg;
 
@@ -206,7 +206,7 @@ static int rcar_gen3_thermal_mcelsius_to_temp(struct rcar_gen3_thermal_tsc *tsc,
 
 static int rcar_gen3_thermal_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	struct rcar_gen3_thermal_tsc *tsc = tz->devdata;
+	struct rcar_gen3_thermal_tsc *tsc = thermal_zone_device_get_data(tz);
 	u32 irqmsk = 0;
 
 	if (low != -INT_MAX) {
diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 436f5f9cf729..538ed6731589 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -101,7 +101,6 @@ struct rcar_thermal_priv {
 	list_for_each_entry(pos, &common->head, list)
 
 #define MCELSIUS(temp)			((temp) * 1000)
-#define rcar_zone_to_priv(zone)		((zone)->devdata)
 #define rcar_priv_to_dev(priv)		((priv)->common->dev)
 #define rcar_has_irq_support(priv)	((priv)->common->base)
 #define rcar_id_to_shift(priv)		((priv)->id * 8)
@@ -273,7 +272,7 @@ static int rcar_thermal_get_current_temp(struct rcar_thermal_priv *priv,
 
 static int rcar_thermal_get_temp(struct thermal_zone_device *zone, int *temp)
 {
-	struct rcar_thermal_priv *priv = rcar_zone_to_priv(zone);
+	struct rcar_thermal_priv *priv = thermal_zone_device_get_data(zone);
 
 	return rcar_thermal_get_current_temp(priv, temp);
 }
diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
index 4b7c43f34d1a..dafbdbb7c0c0 100644
--- a/drivers/thermal/rockchip_thermal.c
+++ b/drivers/thermal/rockchip_thermal.c
@@ -1213,7 +1213,7 @@ static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
 
 static int rockchip_thermal_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	struct rockchip_thermal_sensor *sensor = tz->devdata;
+	struct rockchip_thermal_sensor *sensor = thermal_zone_device_get_data(tz);
 	struct rockchip_thermal_data *thermal = sensor->thermal;
 	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
 
@@ -1226,7 +1226,7 @@ static int rockchip_thermal_set_trips(struct thermal_zone_device *tz, int low, i
 
 static int rockchip_thermal_get_temp(struct thermal_zone_device *tz, int *out_temp)
 {
-	struct rockchip_thermal_sensor *sensor = tz->devdata;
+	struct rockchip_thermal_sensor *sensor = thermal_zone_device_get_data(tz);
 	struct rockchip_thermal_data *thermal = sensor->thermal;
 	const struct rockchip_tsadc_chip *tsadc = sensor->thermal->chip;
 	int retval;
diff --git a/drivers/thermal/rzg2l_thermal.c b/drivers/thermal/rzg2l_thermal.c
index 2e0649f38506..d3ba2a74e42d 100644
--- a/drivers/thermal/rzg2l_thermal.c
+++ b/drivers/thermal/rzg2l_thermal.c
@@ -75,7 +75,7 @@ static inline void rzg2l_thermal_write(struct rzg2l_thermal_priv *priv, u32 reg,
 
 static int rzg2l_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct rzg2l_thermal_priv *priv = tz->devdata;
+	struct rzg2l_thermal_priv *priv = thermal_zone_device_get_data(tz);
 	u32 result = 0, dsensor, ts_code_ave;
 	int val, i;
 
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 527d1eb0663a..a2301e235a2b 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -645,7 +645,7 @@ static void exynos7_tmu_control(struct platform_device *pdev, bool on)
 
 static int exynos_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct exynos_tmu_data *data = tz->devdata;
+	struct exynos_tmu_data *data = thermal_zone_device_get_data(tz);
 	int value, ret = 0;
 
 	if (!data || !data->tmu_read)
@@ -723,7 +723,7 @@ static void exynos4412_tmu_set_emulation(struct exynos_tmu_data *data,
 
 static int exynos_tmu_set_emulation(struct thermal_zone_device *tz, int temp)
 {
-	struct exynos_tmu_data *data = tz->devdata;
+	struct exynos_tmu_data *data = thermal_zone_device_get_data(tz);
 	int ret = -EINVAL;
 
 	if (data->soc == SOC_ARCH_EXYNOS4210)
diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index 6a722b10d738..62cd9305eb9c 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -31,7 +31,7 @@ struct spear_thermal_dev {
 static inline int thermal_get_temp(struct thermal_zone_device *thermal,
 				int *temp)
 {
-	struct spear_thermal_dev *stdev = thermal->devdata;
+	struct spear_thermal_dev *stdev = thermal_zone_device_get_data(thermal);
 
 	/*
 	 * Data are ready to be read after 628 usec from POWERDOWN signal
@@ -48,7 +48,7 @@ static struct thermal_zone_device_ops ops = {
 static int __maybe_unused spear_thermal_suspend(struct device *dev)
 {
 	struct thermal_zone_device *spear_thermal = dev_get_drvdata(dev);
-	struct spear_thermal_dev *stdev = spear_thermal->devdata;
+	struct spear_thermal_dev *stdev = thermal_zone_device_get_data(spear_thermal);
 	unsigned int actual_mask = 0;
 
 	/* Disable SPEAr Thermal Sensor */
@@ -64,7 +64,7 @@ static int __maybe_unused spear_thermal_suspend(struct device *dev)
 static int __maybe_unused spear_thermal_resume(struct device *dev)
 {
 	struct thermal_zone_device *spear_thermal = dev_get_drvdata(dev);
-	struct spear_thermal_dev *stdev = spear_thermal->devdata;
+	struct spear_thermal_dev *stdev = thermal_zone_device_get_data(spear_thermal);
 	unsigned int actual_mask = 0;
 	int ret = 0;
 
@@ -154,7 +154,7 @@ static int spear_thermal_exit(struct platform_device *pdev)
 {
 	unsigned int actual_mask = 0;
 	struct thermal_zone_device *spear_thermal = platform_get_drvdata(pdev);
-	struct spear_thermal_dev *stdev = spear_thermal->devdata;
+	struct spear_thermal_dev *stdev = thermal_zone_device_get_data(spear_thermal);
 
 	thermal_zone_device_unregister(spear_thermal);
 
diff --git a/drivers/thermal/sprd_thermal.c b/drivers/thermal/sprd_thermal.c
index ac884514f116..69078a55dc0c 100644
--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -206,7 +206,7 @@ static int sprd_thm_temp_to_rawdata(int temp, struct sprd_thermal_sensor *sen)
 
 static int sprd_thm_read_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct sprd_thermal_sensor *sen = tz->devdata;
+	struct sprd_thermal_sensor *sen = thermal_zone_device_get_data(tz);
 	u32 data;
 
 	data = readl(sen->data->base + SPRD_THM_TEMP(sen->id)) &
diff --git a/drivers/thermal/sun8i_thermal.c b/drivers/thermal/sun8i_thermal.c
index 497beac63e5d..085b7b0b7c72 100644
--- a/drivers/thermal/sun8i_thermal.c
+++ b/drivers/thermal/sun8i_thermal.c
@@ -110,7 +110,7 @@ static int sun50i_h5_calc_temp(struct ths_device *tmdev,
 
 static int sun8i_ths_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct tsensor *s = tz->devdata;
+	struct tsensor *s = thermal_zone_device_get_data(tz);
 	struct ths_device *tmdev = s->tmdev;
 	int val = 0;
 
diff --git a/drivers/thermal/tegra/tegra-bpmp-thermal.c b/drivers/thermal/tegra/tegra-bpmp-thermal.c
index 0b7a1a1948cb..31a660b009fc 100644
--- a/drivers/thermal/tegra/tegra-bpmp-thermal.c
+++ b/drivers/thermal/tegra/tegra-bpmp-thermal.c
@@ -62,12 +62,14 @@ static int __tegra_bpmp_thermal_get_temp(struct tegra_bpmp_thermal_zone *zone,
 
 static int tegra_bpmp_thermal_get_temp(struct thermal_zone_device *tz, int *out_temp)
 {
-	return __tegra_bpmp_thermal_get_temp(tz->devdata, out_temp);
+	struct tegra_bpmp_thermal_zone *zone = thermal_zone_device_get_data(tz);
+	
+	return __tegra_bpmp_thermal_get_temp(zone, out_temp);
 }
 
 static int tegra_bpmp_thermal_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	struct tegra_bpmp_thermal_zone *zone = tz->devdata;
+	struct tegra_bpmp_thermal_zone *zone = thermal_zone_device_get_data(tz);
 	struct mrq_thermal_host_to_bpmp_request req;
 	struct tegra_bpmp_message msg;
 	int err;
diff --git a/drivers/thermal/tegra/tegra30-tsensor.c b/drivers/thermal/tegra/tegra30-tsensor.c
index b3218b71b6d9..537413acc6d2 100644
--- a/drivers/thermal/tegra/tegra30-tsensor.c
+++ b/drivers/thermal/tegra/tegra30-tsensor.c
@@ -160,7 +160,7 @@ static void devm_tegra_tsensor_hw_disable(void *data)
 
 static int tegra_tsensor_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	const struct tegra_tsensor_channel *tsc = tz->devdata;
+	const struct tegra_tsensor_channel *tsc = thermal_zone_device_get_data(tz);
 	const struct tegra_tsensor *ts = tsc->ts;
 	int err, c1, c2, c3, c4, counter;
 	u32 val;
@@ -218,7 +218,7 @@ static int tegra_tsensor_temp_to_counter(const struct tegra_tsensor *ts, int tem
 
 static int tegra_tsensor_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
-	const struct tegra_tsensor_channel *tsc = tz->devdata;
+	const struct tegra_tsensor_channel *tsc = thermal_zone_device_get_data(tz);
 	const struct tegra_tsensor *ts = tsc->ts;
 	u32 val;
 
diff --git a/drivers/thermal/thermal-generic-adc.c b/drivers/thermal/thermal-generic-adc.c
index 323e273e3298..8e2ff0df7e64 100644
--- a/drivers/thermal/thermal-generic-adc.c
+++ b/drivers/thermal/thermal-generic-adc.c
@@ -54,7 +54,7 @@ static int gadc_thermal_adc_to_temp(struct gadc_thermal_info *gti, int val)
 
 static int gadc_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct gadc_thermal_info *gti = tz->devdata;
+	struct gadc_thermal_info *gti = thermal_zone_device_get_data(tz);
 	int val;
 	int ret;
 
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 0675df54c8e6..05e5a6bda695 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1378,6 +1378,12 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type, int n
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
+void *thermal_zone_device_get_data(struct thermal_zone_device *tzd)
+{
+	return tzd->devdata;
+}
+EXPORT_SYMBOL_GPL(thermal_zone_device_get_data);
+
 /**
  * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
diff --git a/drivers/thermal/thermal_mmio.c b/drivers/thermal/thermal_mmio.c
index ea616731066c..05a70205f86f 100644
--- a/drivers/thermal/thermal_mmio.c
+++ b/drivers/thermal/thermal_mmio.c
@@ -23,7 +23,7 @@ static u32 thermal_mmio_readb(void __iomem *mmio_base)
 static int thermal_mmio_get_temperature(struct thermal_zone_device *tz, int *temp)
 {
 	int t;
-	struct thermal_mmio *sensor = tz->devdata;
+	struct thermal_mmio *sensor = thermal_zone_device_get_data(tz);
 
 	t = sensor->read_mmio(sensor->mmio_base) & sensor->mask;
 	t *= sensor->factor;
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 8a9055bd376e..7f6b71d11eed 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -68,7 +68,7 @@ static inline int ti_thermal_hotspot_temperature(int t, int s, int c)
 static inline int __ti_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 {
 	struct thermal_zone_device *pcb_tz = NULL;
-	struct ti_thermal_data *data = tz->devdata;
+	struct ti_thermal_data *data = thermal_zone_device_get_data(tz);
 	struct ti_bandgap *bgp;
 	const struct ti_temp_sensor *s;
 	int ret, tmp, slope, constant;
@@ -109,7 +109,7 @@ static inline int __ti_thermal_get_temp(struct thermal_zone_device *tz, int *tem
 
 static int __ti_thermal_get_trend(struct thermal_zone_device *tz, int trip, enum thermal_trend *trend)
 {
-	struct ti_thermal_data *data = tz->devdata;
+	struct ti_thermal_data *data = thermal_zone_device_get_data(tz);
 	struct ti_bandgap *bgp;
 	int id, tr, ret = 0;
 
diff --git a/drivers/thermal/uniphier_thermal.c b/drivers/thermal/uniphier_thermal.c
index 47801841b3f5..25247de7780c 100644
--- a/drivers/thermal/uniphier_thermal.c
+++ b/drivers/thermal/uniphier_thermal.c
@@ -187,7 +187,7 @@ static void uniphier_tm_disable_sensor(struct uniphier_tm_dev *tdev)
 
 static int uniphier_tm_get_temp(struct thermal_zone_device *tz, int *out_temp)
 {
-	struct uniphier_tm_dev *tdev = tz->devdata;
+	struct uniphier_tm_dev *tdev = thermal_zone_device_get_data(tz);
 	struct regmap *map = tdev->regmap;
 	int ret;
 	u32 temp;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 2bb4bf33f4f3..724b95662da9 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -365,6 +365,8 @@ thermal_zone_device_register_with_trips(const char *, struct thermal_trip *, int
 					void *, struct thermal_zone_device_ops *,
 					struct thermal_zone_params *, int, int);
 
+void *thermal_zone_device_get_data(struct thermal_zone_device *tzd);
+
 int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
 				     struct thermal_cooling_device *,
 				     unsigned long, unsigned long,
-- 
2.34.1

