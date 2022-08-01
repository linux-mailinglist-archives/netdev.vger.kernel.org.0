Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6258672C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 11:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiHAJ4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 05:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiHAJ4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 05:56:37 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA492E690
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 02:56:35 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q30so9025700wra.11
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 02:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=R82Ekk6GkhDeFP4tmPwA+ve3Y0BCgHxH0T/URohOi0U=;
        b=Cl8IN7LB26GHTAFkpm01le4swt/zC2sHKTYkZMES/Rd+EyLHrpAKXKYLLuXhRa/lyo
         xdWgfulM5Fd8QEFLgp0+T4CMgG31diYWj9BfpSXmYCUsWiLLt0Zwu0F2QWTuTuHQvUYV
         zgo9oaMiuVGjLo/tBhY5QkJI3WQUSFGT+uxuI2BfADscZ+JW+rjAMLcTgYcAWD8n56CN
         URNkoChWaYGcNER8dUhPC1D4EV+cJl1jhtburj32ncfGsmd+/rvIYR3UlC7Mera3zwXh
         +o1rFl9N7GUImfaFMA3u9rJlQsvdydMd7euwtN5UDiAIkpkvz/8/9Ol0CzwrtXJZJSwj
         YYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=R82Ekk6GkhDeFP4tmPwA+ve3Y0BCgHxH0T/URohOi0U=;
        b=I0lrVLo0kREyywzCpzYJVoX6MtEu6lnW3wmlKUvpywYxzz0ZGOvCMJZ3l/ylyvZHCM
         oEKoe6B0fsxbW15v5wrKxTYqkuV9zm3pqAVXMwjYfP8qN+IpEBWgxQk6Wmn+8Sr1xQUE
         fBFAC2AkjVQD+/4utOqK3ARVig9q0VswhFgkmk59qqzvcP7/tQgALTGn41wXQOi0SJRH
         Hs1Grzha+X2ItSeAa2wJdOIR7QIXkQEHvkPlJ1dZrDYshE7uVDI8xnEi3PeNbsD77EsZ
         9AduVAPHEU96jLVJGnond6S0WzAqUSn53WLVnpLiJUGz5YdnIazOmEtooM9bEYMAxi9M
         r2iQ==
X-Gm-Message-State: ACgBeo11oC0tpAvqEgWkTfIKNnhZfLbs+kT4B9xVaN96PRIGvgIPGTXY
        fgA6sHsS4IDtrDYhsiH80CD93A==
X-Google-Smtp-Source: AA6agR5MmCJQK1GfTrynb6ynLBFMwcsnhYPlDCb1bhxtqy4GR5I/ha4dA48uvwQ/YGQzbunWbkXvDg==
X-Received: by 2002:adf:e283:0:b0:21e:26fe:14f3 with SMTP id v3-20020adfe283000000b0021e26fe14f3mr9648547wri.98.1659347793548;
        Mon, 01 Aug 2022 02:56:33 -0700 (PDT)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:b04a:b59f:f2d8:e65c])
        by smtp.gmail.com with ESMTPSA id d14-20020adfef8e000000b0021d6dad334bsm11430204wro.4.2022.08.01.02.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 02:56:33 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     vadimp@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone detection"
Date:   Mon,  1 Aug 2022 11:56:22 +0200
Message-Id: <20220801095622.949079-2-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220801095622.949079-1-daniel.lezcano@linaro.org>
References: <20220801095622.949079-1-daniel.lezcano@linaro.org>
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
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 59 +------------------
 1 file changed, 2 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index f5751242653b..373a77c3da02 100644
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
@@ -473,8 +423,6 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	/* Update trip points. */
 	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz,
 						crit_temp, emerg_temp);
-	if (!err && temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	return 0;
 }
@@ -547,7 +495,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -568,8 +515,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 		return err;
 
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
-	if (temp > 0)
-		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	*p_temp = temp;
 	return 0;
@@ -584,7 +529,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
@@ -667,6 +611,7 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
 							&mlxsw_thermal_module_ops,
+
 							&mlxsw_thermal_params,
 							0,
 							module_tz->parent->polling_delay);
-- 
2.25.1

