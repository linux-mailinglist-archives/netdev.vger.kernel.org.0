Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E090592C61
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbiHOJLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 05:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241885AbiHOJLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 05:11:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D0821E21
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 02:11:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v3so8393780wrp.0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 02:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4rKwZNDYI+83FraB3sI3WNiPbee1XL85BdUCCn3vWeU=;
        b=slO4MlkpU5Q+Lso1PKCzK/Q9UJIjYqobmzDMUV2vytdp+wvtzRgf0zO+S2AWHAqhhi
         BdZMftNH3L4SchZQiNMorZ1yG6Frl75mEcwb1SrW5V6/krmtMbQ9oL1pFXKZiSQXQqwY
         I4m3wfkcJC9N9tFvtjSlCv3BCkLrM4NPajpO/nF/VNXn0VV+pnJFDknAWelkBBvuHlZR
         vi0IoOWU6REQQO3+RGONJG0JJiVDPH3m1uHt1QP7lzfxqprboheAyF7/yFxDORHkxfP9
         bPi/kVVMMjO1nTRnGZrhErK1SFjUEJ07vhAF8B8cC015af40QtCl1rRTWZx5f2Q71Oy1
         Zweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4rKwZNDYI+83FraB3sI3WNiPbee1XL85BdUCCn3vWeU=;
        b=zN/AYEKxhk9LQTT67Kpd2g8QTqaeOQOcemnPGeg0lAh2wjbUYf9Ll0nnybvn3PgNuE
         cSQ/N+TmXThmp+vTJaik0wgzoDYrg10Du+r4+E+sqwFQU8SF+jcq1jN/eREnsyVWJC7o
         CSdGOb7XDF12YPt2vgXO4nW94Mp6aHIeHwCeBSbfgVB7qtiGEDc8ph6Aj2CllMU5rua3
         Uw8qm2LhFclS6FOEHRRZ51cPhImjKby9PuDm7ZH+HEzxB2buG6xq5hNngjbY0idoJIW3
         +VNkIy0yEpPNnqK9fD7OzYtk/vmATGe8vuIY5lpiCtkoEaBCeb4KTi2PeU7PzVRdkEE6
         c1aw==
X-Gm-Message-State: ACgBeo1EVv7CTpIj9aWqrkBYN/9Oq5f2VGXj0xcgF55prluQGNvgs0Zl
        0U0QSc3c0fWIrQr7HwRj7MymCg==
X-Google-Smtp-Source: AA6agR7OeFtsHADloYcvhVEBbiz8XvPVZqItIzVWcXeVD5mu1U41gZknwaEsmyPQM4XxS1i+BinJEw==
X-Received: by 2002:a05:6000:1c11:b0:21f:5abc:e777 with SMTP id ba17-20020a0560001c1100b0021f5abce777mr7821112wrb.221.1660554672179;
        Mon, 15 Aug 2022 02:11:12 -0700 (PDT)
Received: from localhost.localdomain (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id n15-20020a7bcbcf000000b003a5ce167a68sm9025115wmi.7.2022.08.15.02.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 02:11:11 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     vadimp@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 2/2] Revert "mlxsw: core: Add the hottest thermal zone detection"
Date:   Mon, 15 Aug 2022 11:10:32 +0200
Message-Id: <20220815091032.1731268-2-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
References: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 v2:
   - Fix 'err' not used as reported by kbuild test:
   https://lore.kernel.org/all/202208150708.fk6sfd8u-lkp@intel.com/
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 64 ++-----------------
 1 file changed, 4 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index f5751242653b..237a813fbb52 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -22,7 +22,6 @@
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
 #define MLXSW_THERMAL_ZONE_MAX_NAME	16
-#define MLXSW_THERMAL_TEMP_SCORE_MAX	GENMASK(31, 0)
 #define MLXSW_THERMAL_MAX_STATE	10
 #define MLXSW_THERMAL_MIN_STATE	2
 #define MLXSW_THERMAL_MAX_DUTY	255
@@ -96,8 +95,6 @@ struct mlxsw_thermal {
 	u8 tz_module_num;
 	struct mlxsw_thermal_module *tz_gearbox_arr;
 	u8 tz_gearbox_num;
-	unsigned int tz_highest_score;
-	struct thermal_zone_device *tz_highest_dev;
 };
 
 static inline u8 mlxsw_state_to_duty(int state)
@@ -186,34 +183,6 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
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
@@ -278,10 +247,8 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
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
@@ -342,22 +309,6 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
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
@@ -371,7 +322,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.set_trip_temp	= mlxsw_thermal_set_trip_temp,
 	.get_trip_hyst	= mlxsw_thermal_get_trip_hyst,
 	.set_trip_hyst	= mlxsw_thermal_set_trip_hyst,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
@@ -456,7 +406,6 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	int temp, crit_temp, emerg_temp;
 	struct device *dev;
 	u16 sensor_index;
-	int err;
 
 	dev = thermal->bus_info->dev;
 	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + tz->module;
@@ -471,10 +420,8 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
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
@@ -547,7 +494,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -568,8 +514,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 		return err;
 
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
-	if (temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	*p_temp = temp;
 	return 0;
@@ -584,7 +528,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
@@ -667,6 +610,7 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
 							&mlxsw_thermal_module_ops,
+
 							&mlxsw_thermal_params,
 							0,
 							module_tz->parent->polling_delay);
-- 
2.34.1

