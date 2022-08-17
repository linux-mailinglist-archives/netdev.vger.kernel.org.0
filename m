Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C44597328
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbiHQPbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239153AbiHQPbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:31:43 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE989D665
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:31:41 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so1881729wmk.1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=x/8xM9ld9yrSaRR9pDeYKmRNvDsAFYo8/I49PiB0Ceo=;
        b=ccOl9EvZk+s+6ZxGWVd80a/mQypWz20imbB4Q0Hv2rztkoFOKCvGXBegixRftkpheM
         MqgQz/9PcTRh1mG+mfw56lmXtCXESaWgufZ+CMdvWb1GBujZzp8CKq+rQmObr93k6G39
         cYYNFfphmlBvADyQ6J8/nPLjl/xDpNtPWMBtjjEAj4xGKqrywn9Q+RhU9q3/hbpo5+Cp
         oFmRXqbyWcPHnYhhjkVeNzvZKUVMMPfBP+e8wcjZ/tMiVgvdT9Eyn3mjN2evlM7gr2WL
         b39zwKebTo/1sI5apvAcudpfA1kPvP9BxxIPcWHuw5j9FcgE+EgheOS5B9RaX9+wXUbt
         SxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=x/8xM9ld9yrSaRR9pDeYKmRNvDsAFYo8/I49PiB0Ceo=;
        b=PRwnhhed1/yZ1s7CshsGx3/Jvfc0z2g0Qn+GyYc7cwsOuyJ3K7ShcXRGCAOa1j4nWD
         QpcGAjvIgwCwuQwMPLjr1KfOhSxjYTdMvlLgdohZ2AvQ5nzN4xk48h/wTXbHngH+J0X0
         5pTrljWm3ZfUkBp+jt//FjBZcFvGLLjARRcmNV4JIf1p0aIWeg2pjsR22nRRqRGu0JeM
         K/oG1SSY2aAKGjs3fGWxdQnL2N+RhIbw9LeIHoKkMxC05lac+de8w/mRiWe3LXmK5WWT
         /cO68KMYRW2Os+m9QaiC/NW/n1TkAOkakA/JQurvwzKIHGe1gY6puww4OfewWgWQOc92
         FgCA==
X-Gm-Message-State: ACgBeo3GoyOiS58h4KLjXBjptDAF6ErZdm14Xr3CerBz5FL8xu8L/WYS
        IhehF564R486So9hYX8E8WuYnQ==
X-Google-Smtp-Source: AA6agR4cNmGCf8XKin9xGyp8cT0b0iQPYD3hPoSzK7Lcas7XgCjIkGJwabbksuMGV19Oi3gnr2sccA==
X-Received: by 2002:a7b:c848:0:b0:3a5:41f6:4d37 with SMTP id c8-20020a7bc848000000b003a541f64d37mr2634311wml.23.1660750299682;
        Wed, 17 Aug 2022 08:31:39 -0700 (PDT)
Received: from localhost.localdomain (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id t5-20020adfeb85000000b002216d6f8ad6sm13229633wrn.2.2022.08.17.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 08:31:38 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org, vadimp@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com
Subject: [PATCH v4] Revert "mlxsw: core: Add the hottest thermal zone detection"
Date:   Wed, 17 Aug 2022 17:30:40 +0200
Message-Id: <20220817153040.2464245-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c and
commit 6f73862fabd93213de157d9cc6ef76084311c628.

As discussed in the thread:

https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org/

the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
actually already handled by the thermal framework via the cooling
device state aggregation, thus all this code is pointless.

The revert conflicts with the following changes:
 - 7f4957be0d5b8: thermal: Use mode helpers in drivers
 - 6a79507cfe94c: mlxsw: core: Extend thermal module with per QSFP module thermal zones

These conflicts were fixed and the resulting changes are in this patch.

Both reverts are in the same change as requested by Ido Schimmel:

https://lore.kernel.org/all/Yvz7+RUsmVco3Xpj@shredder/

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Vadim Pasternak <vadimp@nvidia.com>
---
  -v4:
   - Squash patch #1 and #2 as requested by Ido Schimmel
   - Remove blank lines
  -v3:
   - Respin against v6.0-rc1
  -v2
   - Fix 'err' not used as reported by kbuild test:
   https://lore.kernel.org/all/202208150708.fk6sfd8u-lkp@intel.com/

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 77 +------------------
 1 file changed, 2 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 3548fe1df7c8..987fe5c9d5a3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -21,7 +21,6 @@
 #define MLXSW_THERMAL_ASIC_TEMP_HOT	105000	/* 105C */
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
-#define MLXSW_THERMAL_TEMP_SCORE_MAX	GENMASK(31, 0)
 #define MLXSW_THERMAL_MAX_STATE	10
 #define MLXSW_THERMAL_MIN_STATE	2
 #define MLXSW_THERMAL_MAX_DUTY	255
@@ -101,8 +100,6 @@ struct mlxsw_thermal {
 	struct thermal_cooling_device *cdevs[MLXSW_MFCR_PWMS_MAX];
 	u8 cooling_levels[MLXSW_THERMAL_MAX_STATE + 1];
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
-	unsigned int tz_highest_score;
-	struct thermal_zone_device *tz_highest_dev;
 	struct mlxsw_thermal_area line_cards[];
 };
 
@@ -193,34 +190,6 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	return 0;
 }
 
-static void mlxsw_thermal_tz_score_update(struct mlxsw_thermal *thermal,
-					  struct thermal_zone_device *tzdev,
-					  struct mlxsw_thermal_trip *trips,
-					  int temp)
-{
-	struct mlxsw_thermal_trip *trip = trips;
-	unsigned int score, delta, i, shift = 1;
-
-	/* Calculate thermal zone score, if temperature is above the hot
-	 * threshold score is set to MLXSW_THERMAL_TEMP_SCORE_MAX.
-	 */
-	score = MLXSW_THERMAL_TEMP_SCORE_MAX;
-	for (i = MLXSW_THERMAL_TEMP_TRIP_NORM; i < MLXSW_THERMAL_NUM_TRIPS;
-	     i++, trip++) {
-		if (temp < trip->temp) {
-			delta = DIV_ROUND_CLOSEST(temp, trip->temp - temp);
-			score = delta * shift;
-			break;
-		}
-		shift *= 256;
-	}
-
-	if (score > thermal->tz_highest_score) {
-		thermal->tz_highest_score = score;
-		thermal->tz_highest_dev = tzdev;
-	}
-}
-
 static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 			      struct thermal_cooling_device *cdev)
 {
@@ -286,9 +255,6 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 		return err;
 	}
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
-	if (temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal->trips,
-					      temp);
 
 	*p_temp = temp;
 	return 0;
@@ -349,21 +315,6 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
-				   int trip, enum thermal_trend *trend)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	if (tzdev == thermal->tz_highest_dev)
-		return 1;
-
-	*trend = THERMAL_TREND_STABLE;
-	return 0;
-}
-
 static struct thermal_zone_params mlxsw_thermal_params = {
 	.no_hwmon = true,
 };
@@ -377,7 +328,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.set_trip_temp	= mlxsw_thermal_set_trip_temp,
 	.get_trip_hyst	= mlxsw_thermal_get_trip_hyst,
 	.set_trip_hyst	= mlxsw_thermal_set_trip_hyst,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
@@ -463,7 +413,6 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	int temp, crit_temp, emerg_temp;
 	struct device *dev;
 	u16 sensor_index;
-	int err;
 
 	dev = thermal->bus_info->dev;
 	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + tz->module;
@@ -479,10 +428,8 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 		return 0;
 
 	/* Update trip points. */
-	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz,
-						crit_temp, emerg_temp);
-	if (!err && temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
+	mlxsw_thermal_module_trips_update(dev, thermal->core, tz,
+					  crit_temp, emerg_temp);
 
 	return 0;
 }
@@ -546,22 +493,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
 	return 0;
 }
 
-static int mlxsw_thermal_module_trend_get(struct thermal_zone_device *tzdev,
-					  int trip, enum thermal_trend *trend)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-	struct mlxsw_thermal *thermal = tz->parent;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	if (tzdev == thermal->tz_highest_dev)
-		return 1;
-
-	*trend = THERMAL_TREND_STABLE;
-	return 0;
-}
-
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
@@ -571,7 +502,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_module_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -592,8 +522,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 		return err;
 
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
-	if (temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	*p_temp = temp;
 	return 0;
@@ -608,7 +536,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_module_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
-- 
2.34.1

