Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4C1596F0C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiHQNC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbiHQNC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:02:57 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4588B5141B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:02:56 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so909321wmb.4
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4qpb20jFwXVK/uhCzEummrh/yZBd9xo3kQkre1/oSPg=;
        b=y+4NstrXdvbqSHuB1IpRIQE3SkpmT3Y0THFE8REeuBdVZHtzQTqsyLmfU5gN4GGo8J
         1oTh6Y3P6ApA8obKxhOYM8uGg8qUXF5Y++dWcuaU1f6kFnSo0MGiRUzuWHu6AsPS6rRO
         rtI0+hmSKoiCkEJqtHfDAMUfNAxuUvOPU40hgoN/O42kECk0NifKUUB2IHd3IGf7VT6t
         LCsxqmSUM9Ux4XUWhCmxeVYIueHNZ2Ywt2qs+LotSuK2OXpfEwlIP975p0iUiUVtoGlZ
         y0mSJLF8Xaw/5UWwFrh/psbIRFZ1McqVlEHD8uHnSGmTU0G3Sa/23xUdD0hINDN6G+Kq
         5W9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4qpb20jFwXVK/uhCzEummrh/yZBd9xo3kQkre1/oSPg=;
        b=HnTWC49ygAl52nlVfmUwJBsc3vBo+4YlTky3GAIDUBZJWKtc8HZFeN9Db3uYMeL/49
         cB0d3jKhh64vLxm/IIMZ1Jdq1IptdhH8ZhZJyiq1DoPpQLUFb3aWIS1tuFOeECX4Ap4s
         zIff0KlaHleXrtapP8OeT2O33a2HX/UvRKiiEiWeZaIViAI7DOQIMqLHlEJwYk3TyMfN
         moqq0O7HpziPMf15C8gtnVXrieHI79AODQlYOvR0rCuxXHzAJoDBBQjiRRkKJazfgvpI
         ybfRzYEoB4FbXsJGu1Au/KTc+1nURtPZeADncIj8pXkTfPC2L0PpDqQdprvp0H26tZ2c
         c/fw==
X-Gm-Message-State: ACgBeo1t5m5cRsvuoT8YFYkNlBEKc/kIplISF9Qoaxkdv3YSYq3Knc6F
        21srQJJFGsk5R2Yk1lsMwTn6KA==
X-Google-Smtp-Source: AA6agR6duHdR757GJRSAbJ4+qqsmU0SzdsKnv6n6E9lIQNilTPTsXE3ZiE/oc+hLot2t8yOaodwbQA==
X-Received: by 2002:a05:600c:1c0f:b0:3a5:4d6b:a883 with SMTP id j15-20020a05600c1c0f00b003a54d6ba883mr2125042wms.45.1660741374477;
        Wed, 17 Aug 2022 06:02:54 -0700 (PDT)
Received: from localhost.localdomain (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id y11-20020a5d620b000000b00222cf973e8csm12878862wru.69.2022.08.17.06.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 06:02:53 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org, vadimp@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v3 2/2] Revert "mlxsw: core: Add the hottest thermal zone detection"
Date:   Wed, 17 Aug 2022 15:02:27 +0200
Message-Id: <20220817130227.2268127-2-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220817130227.2268127-1-daniel.lezcano@linaro.org>
References: <20220817130227.2268127-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 6f73862fabd93213de157d9cc6ef76084311c628.

As discussed in the thread:

https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org/

the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
actually already handled by the thermal framework via the cooling
device state aggregation, thus all this code is pointless.

The revert conflicts with the following changes:
 - 7f4957be0d5b8: thermal: Use mode helpers in drivers
 - 6a79507cfe94c: mlxsw: core: Extend thermal module with per QSFP module thermal zones

These conflicts were fixed and the resulting changes are in this patch.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Vadim Pasternak <vadimp@nvidia.com>
---
  -v3:
   - Respin against v6.0-rc1
  -v2
   - Fix 'err' not used as reported by kbuild test:
   https://lore.kernel.org/all/202208150708.fk6sfd8u-lkp@intel.com/
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 64 ++-----------------
 1 file changed, 4 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 0eb52665b994..2ec3b162dc6c 100644
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
@@ -285,10 +254,8 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 		dev_err(dev, "Failed to query temp sensor\n");
 		return err;
 	}
+
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
-	if (temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal->trips,
-					      temp);
 
 	*p_temp = temp;
 	return 0;
@@ -349,22 +316,6 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
-				   int trip, enum thermal_trend *trend)
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
 static struct thermal_zone_params mlxsw_thermal_params = {
 	.no_hwmon = true,
 };
@@ -378,7 +329,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.set_trip_temp	= mlxsw_thermal_set_trip_temp,
 	.get_trip_hyst	= mlxsw_thermal_get_trip_hyst,
 	.set_trip_hyst	= mlxsw_thermal_set_trip_hyst,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
@@ -464,7 +414,6 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	int temp, crit_temp, emerg_temp;
 	struct device *dev;
 	u16 sensor_index;
-	int err;
 
 	dev = thermal->bus_info->dev;
 	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + tz->module;
@@ -480,10 +429,8 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
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
@@ -556,7 +503,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -577,8 +523,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 		return err;
 
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
-	if (temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	*p_temp = temp;
 	return 0;
@@ -593,7 +537,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
@@ -680,6 +623,7 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
 							&mlxsw_thermal_module_ops,
+
 							&mlxsw_thermal_params,
 							0,
 							module_tz->parent->polling_delay);
-- 
2.34.1

