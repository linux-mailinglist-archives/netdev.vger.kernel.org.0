Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F113558672A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 11:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiHAJ4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 05:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiHAJ4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 05:56:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B25832BA2
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 02:56:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l4so13456413wrm.13
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 02:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=2FuACtaCS0L8dCebZDq4RRCEXB3kt6E3Inml0wlV6gg=;
        b=KDTn7Mup8NyF9qvcEMDqDfbVO2sbgiHPBc4jBKd8h+ncGfBZcDWsKsW90yNAOA4i9F
         1X7g37grnvEnO3ePr5Oa22V1G3p/1UsB+mrONfDsfgZ3ZjlTy7a3GbYpdyFNryYBAS6J
         OsRXwDfl4bwzlqZBA+SuugJZh8vcHlKagX063SlJsRcEs8coyUJJVdxRR/CmOpa5FFW4
         MondDpwWVbhyQB2qYJZYLi9YrXXsxdGjT712KyGd2UaQwVLqkrRAe//rpkVXkGUxg1wd
         Sw9NGXwPl+AOddashnMdhi43W8EJa9yAXudzKqndtaoxz88nXHDghoYExfIHh4k4va2H
         FZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=2FuACtaCS0L8dCebZDq4RRCEXB3kt6E3Inml0wlV6gg=;
        b=aFHoTcju+bhgauKxwDYzvPb2VeS8OhSIR/Uyh4U/34wv3CJznAtfuDXYSM7P4pqzeZ
         rkIHIVAxpmJl3dspaNLnzRLF0vDTs6FjTFlo94Q7czpwRVryUMhbIdzXb4rvkqGx5suL
         QgjLg08i38dkvhcwX0YJmut507NGblgoxuzlcL1odyga6HiIuEqnf9Iab4jJThxQlsik
         c7oSsJF4f2EOjGXqlOVv5Y4IrYuIx0DZF3mzi6XH64TTJbirWc+0dDslrCPWXYIxJ6fp
         nD8eLdYfc9Qb87ZyRPmNOYdT82cNdiOYvGZ7St7T5G5I1MVOMSJkulEeCNQvuojbcz0G
         uuDw==
X-Gm-Message-State: ACgBeo2NAldhofo4ZNMAIra6yo4R5iiS08xGusYdt/i8IgVTReRftk5O
        rpbQ6LuDScNaiD1KgNG1Iqj7fw==
X-Google-Smtp-Source: AA6agR6Vju81GPvCd056EAYe+Qntgu2/heORygcItwiYQvkGp7kpXFKHykQIDzVmzYL7aR+ExGYGTw==
X-Received: by 2002:a05:6000:2a8:b0:220:6893:4ff6 with SMTP id l8-20020a05600002a800b0022068934ff6mr1108386wry.170.1659347792321;
        Mon, 01 Aug 2022 02:56:32 -0700 (PDT)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:b04a:b59f:f2d8:e65c])
        by smtp.gmail.com with ESMTPSA id d14-20020adfef8e000000b0021d6dad334bsm11430204wro.4.2022.08.01.02.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 02:56:32 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     vadimp@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend() callbacks for different thermal zones"
Date:   Mon,  1 Aug 2022 11:56:21 +0200
Message-Id: <20220801095622.949079-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
2.25.1

