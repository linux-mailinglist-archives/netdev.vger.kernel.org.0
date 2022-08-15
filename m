Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30580592C2C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241916AbiHOJLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 05:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiHOJLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 05:11:13 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B69221E1B
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 02:11:12 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l4so8330393wrm.13
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 02:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=8ewKaBruBG4Wdy+dVaWLH7mTF4mGASpuGqd2KHdz1ds=;
        b=HRqElRtk4xqVVcIyId3sDC0J06+n05mI5ThgsrfkfJzohWULUO3CaSqGd+bPWL+/jO
         b1ub3RF7RG4HrV4zAK7fKnhZNF8rzIdi+F/zIzsbhZ+AYuYha8SiTFpDvWRcgA+HyC4j
         WXtR7cOuOhz2l9keTa0xu9OSO0Tvz7oyx4PhEFWfzOlTsYnUabPKpnr3hmhUntGFWue9
         xpiicS6YOzzhDL7JnBxOwYAs5ZMUOdHDnA8/ADM9Nu8nEOHXsBLPjP0+vVeYduz3AnlS
         fbG6yr+0AQQSlsQRtrWjB1CfOioxvxrJ7VLM0xkfjYuxsg6xUH5W4iCV4dBKQVvie5Sf
         UCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=8ewKaBruBG4Wdy+dVaWLH7mTF4mGASpuGqd2KHdz1ds=;
        b=TyidCMWpJb4hx6sbdSfj+SJOYocPrjL2cJnm+6wLd2BRQZohvYzsldkaK4KXhaHn9x
         V95khUYvXf+wrco5gOOiZ9BlFw68YQWw2882GNx6ACJ+HfNij9pYxxm4z0Yc565lYrMM
         AqYKuqN1J139woBSyFQjxNMNycjIvq3pL8iIJcJ6mlXA6xp46JuzVAOd+S1OuUbCiNI1
         DXgyh2+UgoUYf9vVOY3TkOqo2RzqaU9fgl9Wa9yG1IaHpVsZQnzqJM8xFL32C5AaglUD
         fYPypFyhsHpZQnIEXtwnN99GVgoCuNvnQxnv9Z0sOO7lp8TrpRJLc4MaBXrTqZtemBxA
         1+XQ==
X-Gm-Message-State: ACgBeo1O5blEtIhKpONN9gG1KCRjUAwjgOJQ7RzexbcaVkFEkMBGVn0f
        rP/y/0KeKoQmUZnuMijvPMaZ7GFxFNP18g==
X-Google-Smtp-Source: AA6agR5i699F3qJPaSoA5z+f1kejy3xRqjp3Dqv2rmN6AuznfeJLO6Q2adYx42+Fj4/Beo5ornmKHw==
X-Received: by 2002:a5d:6da8:0:b0:223:60ee:6c33 with SMTP id u8-20020a5d6da8000000b0022360ee6c33mr8192498wrs.700.1660554670871;
        Mon, 15 Aug 2022 02:11:10 -0700 (PDT)
Received: from localhost.localdomain (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id n15-20020a7bcbcf000000b003a5ce167a68sm9025115wmi.7.2022.08.15.02.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 02:11:10 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     vadimp@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 1/2] Revert "mlxsw: core: Use different get_trend() callbacks for different thermal zones"
Date:   Mon, 15 Aug 2022 11:10:31 +0200
Message-Id: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
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

This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c.

As discussed in the thread:

https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org/

the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
actually already handled by the thermal framework via the cooling
device state aggregation, thus all this code is pointless.

No conflict happened when reverting the patch.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Vadim Pasternak <vadimp@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 23 ++++---------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 05f54bd982c0..f5751242653b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -345,7 +345,8 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
 				   int trip, enum thermal_trend *trend)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal *thermal = tz->parent;
 
 	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
 		return -EINVAL;
@@ -537,22 +538,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
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
@@ -562,7 +547,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_module_trend_get,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -599,7 +584,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_module_trend_get,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
-- 
2.34.1

