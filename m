Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94B651E711
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 14:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384913AbiEGM7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 08:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384924AbiEGM6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 08:58:52 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3453C46B07
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 05:55:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e2so13427635wrh.7
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 05:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linexp-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qW7EpFg+nLG6Nywn0ltS3weZ1OcAg1+DN7VidSEha4=;
        b=DUgal0hI6q/dV/vG4Qm/Ui5A8Mtdt9gHo3wbPLyIDcqkGYnvMVJ0UI0r/bO0x52Cf+
         AZbcdXpWQGdkPGxCzr1i/kE6xCfbqDxLnN7r9sqTbk1pjcBPONhJVImQIZaGgmDENd6j
         9BcRbzaKvT5SRCP2H9ba5LfRcn6YmhygHJGSJx878/oodYo3p2lBLXWMUmdpUSQYpXiK
         B490eUBYNgAARlm8lHZZDBtIPYBjIbGZ5gIal3JGgPVAk5JtgPQrght2BYseMcKm7qtY
         y+1nmYOxXB2kik66K9XRR9HCE1MJxgDyN/EjZQYB9wWPSxNOaSlR3bJ6F7eO3T8e6Tco
         5ncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qW7EpFg+nLG6Nywn0ltS3weZ1OcAg1+DN7VidSEha4=;
        b=NqeOJF/W2MV3Y9PoTrpjueEnvAedT7Li3g7WceDE69o/UyjpUgtcmMzs/NREIA+Tny
         j5NezaesmQbl8j2ClqrfovuIfIYuHx9LYYr+tfZikphqfXxG9/YLrMEsJfO4tlsC/80q
         Wca0QO/SRETWCOXV81kMgHz7g6g77ejIzT26LyxzjbyWncqO1AQXVSIZgYFqqm94+8Fy
         xP1Jenn4lGIKquKZOsnBzItI4PMcLZLwWGYr3yXt7V8iT9lVEOjgQ/tp8GlR+xtzLj0R
         FmLVPdQ6cgRZRNayUFNg9kX5pDHcyt3nCW+IV9Rtt2eEiX/Kuhaf06KM3kqgq9lXvVXr
         1BzQ==
X-Gm-Message-State: AOAM530NMAd1nx8VsaKQ6Ipac9+PQ5WiJphnq5tqDwwnnMOnaOBEFu9D
        s6trRCxlti73cpDsEmVXsNOsNg==
X-Google-Smtp-Source: ABdhPJz/8tc/51OAGSilxkiFqQAhLdZ8kqmZrfD/tldFiK7A2hCP1/g9uGjkQXY7m6O0cy51a7o0EA==
X-Received: by 2002:a5d:5986:0:b0:20c:5844:820d with SMTP id n6-20020a5d5986000000b0020c5844820dmr6393841wri.192.1651928101605;
        Sat, 07 May 2022 05:55:01 -0700 (PDT)
Received: from localhost.localdomain (static-176-182-171-101.ncc.abo.bbox.fr. [176.182.171.101])
        by smtp.gmail.com with ESMTPSA id e9-20020a05600c218900b0039453fe55a7sm10470345wme.35.2022.05.07.05.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 05:55:01 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linexp.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     khilman@baylibre.com, abailon@baylibre.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Len Brown <lenb@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Antoine Tenart <atenart@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-acpi@vger.kernel.org (open list:ACPI THERMAL DRIVER),
        netdev@vger.kernel.org (open list:CXGB4 ETHERNET DRIVER (CXGB4)),
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)),
        platform-driver-x86@vger.kernel.org (open list:ACER ASPIRE ONE
        TEMPERATURE AND FAN DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/FREESCALE IMX
        / MXC ARM ARCHITECTURE),
        linux-renesas-soc@vger.kernel.org (open list:RENESAS R-CAR THERMAL
        DRIVERS)
Subject: [PATCH v2 01/14] thermal/core: Change thermal_zone_ops to thermal_sensor_ops
Date:   Sat,  7 May 2022 14:54:29 +0200
Message-Id: <20220507125443.2766939-2-daniel.lezcano@linexp.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507125443.2766939-1-daniel.lezcano@linexp.org>
References: <20220507125443.2766939-1-daniel.lezcano@linexp.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A thermal zone is software abstraction of a sensor associated with
properties and cooling devices if any.

The fact that we have thermal_zone and thermal_zone_ops mixed is
confusing and does not clearly identify the different components
entering in the thermal management process. A thermal zone appears to
be a sensor while it is not.

In order to set the scene for multiple thermal sensors aggregated into
a single thermal zone. Rename the thermal_zone_ops to
thermal_sensor_ops, that will appear clearyl the thermal zone is not a
sensor but an abstraction of one [or multiple] sensor(s).

Cc: Alexandre Bailon <abailon@baylibre.com>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc; Eduardo Valentin <eduval@amazon.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linexp.org>
---
 Documentation/driver-api/thermal/sysfs-api.rst            | 2 +-
 drivers/acpi/thermal.c                                    | 6 +++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c        | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c        | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c               | 2 +-
 drivers/platform/x86/acerhdf.c                            | 2 +-
 drivers/power/supply/power_supply_core.c                  | 2 +-
 drivers/thermal/armada_thermal.c                          | 2 +-
 drivers/thermal/da9062-thermal.c                          | 2 +-
 drivers/thermal/dove_thermal.c                            | 2 +-
 drivers/thermal/imx_thermal.c                             | 2 +-
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c   | 2 +-
 .../thermal/intel/int340x_thermal/int340x_thermal_zone.c  | 6 +++---
 .../thermal/intel/int340x_thermal/int340x_thermal_zone.h  | 4 ++--
 .../intel/int340x_thermal/processor_thermal_device.c      | 4 ++--
 .../intel/int340x_thermal/processor_thermal_device_pci.c  | 2 +-
 drivers/thermal/intel/intel_pch_thermal.c                 | 2 +-
 drivers/thermal/intel/intel_quark_dts_thermal.c           | 2 +-
 drivers/thermal/intel/intel_soc_dts_iosf.c                | 2 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c              | 2 +-
 drivers/thermal/kirkwood_thermal.c                        | 2 +-
 drivers/thermal/rcar_thermal.c                            | 4 ++--
 drivers/thermal/spear_thermal.c                           | 2 +-
 drivers/thermal/st/st_thermal.c                           | 2 +-
 drivers/thermal/thermal_core.c                            | 2 +-
 drivers/thermal/thermal_of.c                              | 4 ++--
 include/linux/thermal.h                                   | 8 ++++----
 27 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/Documentation/driver-api/thermal/sysfs-api.rst b/Documentation/driver-api/thermal/sysfs-api.rst
index 2e0f79a9e2ee..6dff5e6e1166 100644
--- a/Documentation/driver-api/thermal/sysfs-api.rst
+++ b/Documentation/driver-api/thermal/sysfs-api.rst
@@ -41,7 +41,7 @@ temperature) and throttle appropriate devices.
 	struct thermal_zone_device
 	*thermal_zone_device_register(char *type,
 				      int trips, int mask, void *devdata,
-				      struct thermal_zone_device_ops *ops,
+				      struct thermal_sensor_ops *ops,
 				      const struct thermal_zone_params *tzp,
 				      int passive_delay, int polling_delay))
 
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 539660ef93c7..c2b8100f9cd8 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -774,7 +774,7 @@ acpi_thermal_unbind_cooling_device(struct thermal_zone_device *thermal,
 	return acpi_thermal_cooling_device_cb(thermal, cdev, false);
 }
 
-static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
+static struct thermal_sensor_ops acpi_thermal_sensor_ops = {
 	.bind = acpi_thermal_bind_cooling_device,
 	.unbind	= acpi_thermal_unbind_cooling_device,
 	.get_temp = thermal_get_temp,
@@ -808,13 +808,13 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 	if (tz->trips.passive.flags.valid)
 		tz->thermal_zone =
 			thermal_zone_device_register("acpitz", trips, 0, tz,
-						&acpi_thermal_zone_ops, NULL,
+						&acpi_thermal_sensor_ops, NULL,
 						     tz->trips.passive.tsp*100,
 						     tz->polling_frequency*100);
 	else
 		tz->thermal_zone =
 			thermal_zone_device_register("acpitz", trips, 0, tz,
-						&acpi_thermal_zone_ops, NULL,
+						&acpi_thermal_sensor_ops, NULL,
 						0, tz->polling_frequency*100);
 	if (IS_ERR(tz->thermal_zone))
 		return -ENODEV;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
index 9a6d65243334..239824e90fbe 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
@@ -53,7 +53,7 @@ static int cxgb4_thermal_get_trip_temp(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static struct thermal_zone_device_ops cxgb4_thermal_ops = {
+static struct thermal_sensor_ops cxgb4_thermal_ops = {
 	.get_temp = cxgb4_thermal_get_temp,
 	.get_trip_type = cxgb4_thermal_get_trip_type,
 	.get_trip_temp = cxgb4_thermal_get_trip_temp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 05f54bd982c0..cf609dc39acd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -361,7 +361,7 @@ static struct thermal_zone_params mlxsw_thermal_params = {
 	.no_hwmon = true,
 };
 
-static struct thermal_zone_device_ops mlxsw_thermal_ops = {
+static struct thermal_sensor_ops mlxsw_thermal_ops = {
 	.bind = mlxsw_thermal_bind,
 	.unbind = mlxsw_thermal_unbind,
 	.get_temp = mlxsw_thermal_get_temp,
@@ -553,7 +553,7 @@ static int mlxsw_thermal_module_trend_get(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
+static struct thermal_sensor_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
 	.get_temp	= mlxsw_thermal_module_temp_get,
@@ -590,7 +590,7 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
+static struct thermal_sensor_ops mlxsw_thermal_gearbox_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
 	.get_temp	= mlxsw_thermal_gearbox_temp_get,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 69cf3a372759..74109a7d329f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -718,7 +718,7 @@ static int iwl_mvm_tzone_set_trip_temp(struct thermal_zone_device *device,
 	return ret;
 }
 
-static  struct thermal_zone_device_ops tzone_ops = {
+static  struct thermal_sensor_ops tzone_ops = {
 	.get_temp = iwl_mvm_tzone_get_temp,
 	.get_trip_temp = iwl_mvm_tzone_get_trip_temp,
 	.get_trip_type = iwl_mvm_tzone_get_trip_type,
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 3463629f8764..b9e8f6c60714 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -469,7 +469,7 @@ static int acerhdf_get_crit_temp(struct thermal_zone_device *thermal,
 }
 
 /* bind callback functions to thermalzone */
-static struct thermal_zone_device_ops acerhdf_dev_ops = {
+static struct thermal_sensor_ops acerhdf_dev_ops = {
 	.bind = acerhdf_bind,
 	.unbind = acerhdf_unbind,
 	.get_temp = acerhdf_get_ec_temp,
diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index d925cb137e12..5ada4a94b4e3 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1149,7 +1149,7 @@ static int power_supply_read_temp(struct thermal_zone_device *tzd,
 	return ret;
 }
 
-static struct thermal_zone_device_ops psy_tzd_ops = {
+static struct thermal_sensor_ops psy_tzd_ops = {
 	.get_temp = power_supply_read_temp,
 };
 
diff --git a/drivers/thermal/armada_thermal.c b/drivers/thermal/armada_thermal.c
index c2ebfb5be4b3..703ace32a217 100644
--- a/drivers/thermal/armada_thermal.c
+++ b/drivers/thermal/armada_thermal.c
@@ -416,7 +416,7 @@ static int armada_get_temp_legacy(struct thermal_zone_device *thermal,
 	return ret;
 }
 
-static struct thermal_zone_device_ops legacy_ops = {
+static struct thermal_sensor_ops legacy_ops = {
 	.get_temp = armada_get_temp_legacy,
 };
 
diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
index 180edec34e07..d29953eee39f 100644
--- a/drivers/thermal/da9062-thermal.c
+++ b/drivers/thermal/da9062-thermal.c
@@ -170,7 +170,7 @@ static int da9062_thermal_get_temp(struct thermal_zone_device *z,
 	return 0;
 }
 
-static struct thermal_zone_device_ops da9062_thermal_ops = {
+static struct thermal_sensor_ops da9062_thermal_ops = {
 	.get_temp	= da9062_thermal_get_temp,
 	.get_trip_type	= da9062_thermal_get_trip_type,
 	.get_trip_temp	= da9062_thermal_get_trip_temp,
diff --git a/drivers/thermal/dove_thermal.c b/drivers/thermal/dove_thermal.c
index 73182eb94bc0..170a1168ae38 100644
--- a/drivers/thermal/dove_thermal.c
+++ b/drivers/thermal/dove_thermal.c
@@ -109,7 +109,7 @@ static int dove_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static struct thermal_zone_device_ops ops = {
+static struct thermal_sensor_ops ops = {
 	.get_temp = dove_get_temp,
 };
 
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 16663373b682..c57fa2029ee0 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -418,7 +418,7 @@ static int imx_unbind(struct thermal_zone_device *tz,
 	return 0;
 }
 
-static struct thermal_zone_device_ops imx_tz_ops = {
+static struct thermal_sensor_ops imx_tz_ops = {
 	.bind = imx_bind,
 	.unbind = imx_unbind,
 	.get_temp = imx_get_temp,
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 4954800b9850..cad48a886888 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -485,7 +485,7 @@ static int int3400_thermal_change_mode(struct thermal_zone_device *thermal,
 	return result;
 }
 
-static struct thermal_zone_device_ops int3400_thermal_ops = {
+static struct thermal_sensor_ops int3400_thermal_ops = {
 	.get_temp = int3400_thermal_get_temp,
 	.change_mode = int3400_thermal_change_mode,
 };
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index 62c0aa5d0783..d78f29208352 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -151,7 +151,7 @@ static void int340x_thermal_critical(struct thermal_zone_device *zone)
 	dev_dbg(&zone->device, "%s: critical temperature reached\n", zone->type);
 }
 
-static struct thermal_zone_device_ops int340x_thermal_zone_ops = {
+static struct thermal_sensor_ops int340x_thermal_sensor_ops = {
 	.get_temp       = int340x_thermal_get_zone_temp,
 	.get_trip_temp	= int340x_thermal_get_trip_temp,
 	.get_trip_type	= int340x_thermal_get_trip_type,
@@ -217,7 +217,7 @@ static struct thermal_zone_params int340x_thermal_params = {
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
-				struct thermal_zone_device_ops *override_ops)
+				struct thermal_sensor_ops *override_ops)
 {
 	struct int34x_thermal_zone *int34x_thermal_zone;
 	acpi_status status;
@@ -262,7 +262,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 						acpi_device_bid(adev),
 						trip_cnt,
 						trip_mask, int34x_thermal_zone,
-						&int340x_thermal_zone_ops,
+						&int340x_thermal_sensor_ops,
 						&int340x_thermal_params,
 						0, 0);
 	if (IS_ERR(int34x_thermal_zone->zone)) {
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
index 3b4971df1b33..a25c45e2eb66 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
@@ -29,13 +29,13 @@ struct int34x_thermal_zone {
 	int hot_temp;
 	int hot_trip_id;
 	struct thermal_zone_device *zone;
-	struct thermal_zone_device_ops *override_ops;
+	struct thermal_sensor_ops *override_ops;
 	void *priv_data;
 	struct acpi_lpat_conversion_table *lpat_table;
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,
-				struct thermal_zone_device_ops *override_ops);
+				struct thermal_sensor_ops *override_ops);
 void int340x_thermal_zone_remove(struct int34x_thermal_zone *);
 int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone);
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index a8d98f1bd6c6..4b8544f72a23 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -207,7 +207,7 @@ static int proc_thermal_get_zone_temp(struct thermal_zone_device *zone,
 	return ret;
 }
 
-static struct thermal_zone_device_ops proc_thermal_local_ops = {
+static struct thermal_sensor_ops proc_thermal_local_ops = {
 	.get_temp       = proc_thermal_get_zone_temp,
 };
 
@@ -285,7 +285,7 @@ int proc_thermal_add(struct device *dev, struct proc_thermal_device *proc_priv)
 	struct acpi_device *adev;
 	acpi_status status;
 	unsigned long long tmp;
-	struct thermal_zone_device_ops *ops = NULL;
+	struct thermal_sensor_ops *ops = NULL;
 	int ret;
 
 	adev = ACPI_COMPANION(dev);
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index ca40b0967cdd..5316143b09b2 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -200,7 +200,7 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip, int temp
 	return 0;
 }
 
-static struct thermal_zone_device_ops tzone_ops = {
+static struct thermal_sensor_ops tzone_ops = {
 	.get_temp = sys_get_curr_temp,
 	.get_trip_temp = sys_get_trip_temp,
 	.get_trip_type = sys_get_trip_type,
diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
index 527c91f5960b..e2161ab647b0 100644
--- a/drivers/thermal/intel/intel_pch_thermal.c
+++ b/drivers/thermal/intel/intel_pch_thermal.c
@@ -331,7 +331,7 @@ static void pch_critical(struct thermal_zone_device *tzd)
 	dev_dbg(&tzd->device, "%s: critical temperature reached\n", tzd->type);
 }
 
-static struct thermal_zone_device_ops tzd_ops = {
+static struct thermal_sensor_ops tzd_ops = {
 	.get_temp = pch_thermal_get_temp,
 	.get_trip_type = pch_get_trip_type,
 	.get_trip_temp = pch_get_trip_temp,
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 3eafc6b0e6c3..636286dc90fc 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -313,7 +313,7 @@ static int sys_change_mode(struct thermal_zone_device *tzd,
 	return ret;
 }
 
-static struct thermal_zone_device_ops tzone_ops = {
+static struct thermal_sensor_ops tzone_ops = {
 	.get_temp = sys_get_curr_temp,
 	.get_trip_temp = sys_get_trip_temp,
 	.get_trip_type = sys_get_trip_type,
diff --git a/drivers/thermal/intel/intel_soc_dts_iosf.c b/drivers/thermal/intel/intel_soc_dts_iosf.c
index 342b0bb5a56d..38ce8426fc35 100644
--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -243,7 +243,7 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
 	return 0;
 }
 
-static struct thermal_zone_device_ops tzone_ops = {
+static struct thermal_sensor_ops tzone_ops = {
 	.get_temp = sys_get_curr_temp,
 	.get_trip_temp = sys_get_trip_temp,
 	.get_trip_type = sys_get_trip_type,
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 4d8edc61a78b..047e27db72fe 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -220,7 +220,7 @@ static int sys_get_trip_type(struct thermal_zone_device *thermal, int trip,
 }
 
 /* Thermal zone callback registry */
-static struct thermal_zone_device_ops tzone_ops = {
+static struct thermal_sensor_ops tzone_ops = {
 	.get_temp = sys_get_curr_temp,
 	.get_trip_temp = sys_get_trip_temp,
 	.get_trip_type = sys_get_trip_type,
diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
index 7fb6e476c82a..d8e24549428d 100644
--- a/drivers/thermal/kirkwood_thermal.c
+++ b/drivers/thermal/kirkwood_thermal.c
@@ -51,7 +51,7 @@ static int kirkwood_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static struct thermal_zone_device_ops ops = {
+static struct thermal_sensor_ops ops = {
 	.get_temp = kirkwood_get_temp,
 };
 
diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index b49f04daaf47..a7c22e85adc6 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -327,7 +327,7 @@ static const struct thermal_zone_of_device_ops rcar_thermal_zone_of_ops = {
 	.get_temp	= rcar_thermal_of_get_temp,
 };
 
-static struct thermal_zone_device_ops rcar_thermal_zone_ops = {
+static struct thermal_sensor_ops rcar_thermal_sensor_ops = {
 	.get_temp	= rcar_thermal_get_temp,
 	.get_trip_type	= rcar_thermal_get_trip_type,
 	.get_trip_temp	= rcar_thermal_get_trip_temp,
@@ -534,7 +534,7 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 			priv->zone = thermal_zone_device_register(
 						"rcar_thermal",
 						1, 0, priv,
-						&rcar_thermal_zone_ops, NULL, 0,
+						&rcar_thermal_sensor_ops, NULL, 0,
 						idle);
 
 			ret = thermal_zone_device_enable(priv->zone);
diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index ee33ed692e4f..462a8d4bd1c8 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -41,7 +41,7 @@ static inline int thermal_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static struct thermal_zone_device_ops ops = {
+static struct thermal_sensor_ops ops = {
 	.get_temp = thermal_get_temp,
 };
 
diff --git a/drivers/thermal/st/st_thermal.c b/drivers/thermal/st/st_thermal.c
index 1276b95604fe..c42d9cae5e52 100644
--- a/drivers/thermal/st/st_thermal.c
+++ b/drivers/thermal/st/st_thermal.c
@@ -170,7 +170,7 @@ static int st_thermal_get_trip_temp(struct thermal_zone_device *th,
 	return 0;
 }
 
-static struct thermal_zone_device_ops st_tz_ops = {
+static struct thermal_sensor_ops st_tz_ops = {
 	.get_temp	= st_thermal_get_temp,
 	.get_trip_type	= st_thermal_get_trip_type,
 	.get_trip_temp	= st_thermal_get_trip_temp,
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 82654dc8382b..065dfc179e53 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1184,7 +1184,7 @@ static void bind_tz(struct thermal_zone_device *tz)
  */
 struct thermal_zone_device *
 thermal_zone_device_register(const char *type, int trips, int mask,
-			     void *devdata, struct thermal_zone_device_ops *ops,
+			     void *devdata, struct thermal_sensor_ops *ops,
 			     struct thermal_zone_params *tzp, int passive_delay,
 			     int polling_delay)
 {
diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 9233f7e74454..ef953cba3504 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -360,7 +360,7 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
 	return -EINVAL;
 }
 
-static struct thermal_zone_device_ops of_thermal_ops = {
+static struct thermal_sensor_ops of_thermal_ops = {
 	.get_trip_type = of_thermal_get_trip_type,
 	.get_trip_temp = of_thermal_get_trip_temp,
 	.set_trip_temp = of_thermal_set_trip_temp,
@@ -1046,7 +1046,7 @@ int __init of_parse_thermal_zones(void)
 {
 	struct device_node *np, *child;
 	struct __thermal_zone *tz;
-	struct thermal_zone_device_ops *ops;
+	struct thermal_sensor_ops *ops;
 
 	np = of_find_node_by_name(NULL, "thermal-zones");
 	if (!np) {
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index c314893970b3..991f7bc02d51 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -57,7 +57,7 @@ enum thermal_notify_event {
 	THERMAL_EVENT_KEEP_ALIVE, /* Request for user space handler to respond */
 };
 
-struct thermal_zone_device_ops {
+struct thermal_sensor_ops {
 	int (*bind) (struct thermal_zone_device *,
 		     struct thermal_cooling_device *);
 	int (*unbind) (struct thermal_zone_device *,
@@ -164,7 +164,7 @@ struct thermal_zone_device {
 	int prev_low_trip;
 	int prev_high_trip;
 	atomic_t need_update;
-	struct thermal_zone_device_ops *ops;
+	struct thermal_sensor_ops *ops;
 	struct thermal_zone_params *tzp;
 	struct thermal_governor *governor;
 	void *governor_data;
@@ -361,7 +361,7 @@ void devm_thermal_zone_of_sensor_unregister(struct device *dev,
 
 #ifdef CONFIG_THERMAL
 struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
-		void *, struct thermal_zone_device_ops *,
+		void *, struct thermal_sensor_ops *,
 		struct thermal_zone_params *, int, int);
 void thermal_zone_device_unregister(struct thermal_zone_device *);
 
@@ -396,7 +396,7 @@ void thermal_zone_device_critical(struct thermal_zone_device *tz);
 #else
 static inline struct thermal_zone_device *thermal_zone_device_register(
 	const char *type, int trips, int mask, void *devdata,
-	struct thermal_zone_device_ops *ops,
+	struct thermal_sensor_ops *ops,
 	struct thermal_zone_params *tzp,
 	int passive_delay, int polling_delay)
 { return ERR_PTR(-ENODEV); }
-- 
2.25.1

