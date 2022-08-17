Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7192B596F1D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbiHQNC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbiHQNCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:02:55 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E76F52E58
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:02:54 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m10-20020a05600c3b0a00b003a603fc3f81so930114wms.0
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=cevyYAZt+dxQcHlPC3XN0GuOe1QkXMz82sZwwqq5w6E=;
        b=wy4h554NSrItIUYkhyPJvyc8SB0Gne1UM0/mv6oEZWGmmn0JEst2Z3WFgZQySKmuG0
         EdgcGv/fDTEWjcrXpeKZ35mufrqkGBlMc73/2JxtteMFUywO1WQPTMlxSDGsr824gBL5
         BlhvBEj2odYhwi7n2/B+EAp5JsUXcbZ1ZhFjc+cujXbgJpfvs6ZfWP/SfWNMgpBYTQHA
         Pd7EawC77rpES/6Y/5so932i1kGuBsCr/Rf8MiN/LjPM0ZcDsk9dF3TyRKdBQA0CveAn
         D60TtOqknyagcux3nMVUOUP+36iXzAEyIxZj1tua0jg1yUV09IPz/UbLuDgVUHeEREpL
         71/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=cevyYAZt+dxQcHlPC3XN0GuOe1QkXMz82sZwwqq5w6E=;
        b=Q1vFV4iR7BKAwdBOLFXe6vHDNyctodlBYvisrzJPhChhku6iM8sKBKUR9AGlVnB5N1
         7mVmoFd3kQ+syycpb1gH8jK3GWtzrV85OaBKKfsUZAO3TdOW8n6KgyJivRX9Izd3KTqE
         ykOU1hEClUkLIKDN/Cz/YYumvig//tf9btjkx37f7G3YFTxFPtEr7mRgayhMGC3x0Wml
         7hV3g5dx8abouS/yTphmPUhBANaUKPuMnHUfZv0k0MHVC2QLUeFjOrX6HtkeHbXF0YWn
         m1+SZwwYEQD8FxEfJJVI5ghwJuoZ9MP4Tm9Uo5FwdD6CRoqTqypZ+Da8u44K5UrOWiY8
         f0Tw==
X-Gm-Message-State: ACgBeo2KtpHRrMhFBmw20qJyae8sW3sRCejNmY+b2MJXIjDsjukErOWd
        +i7qwuKLZWYMXzPuF9jU4Z+dsQ==
X-Google-Smtp-Source: AA6agR7I0BDNinl5wiSYEQ7K6IZtttPxoDtJ4jjXlBafsSHJ3G6MbtepMNnWL71mFhMdgw5iWqHF2A==
X-Received: by 2002:a05:600c:384c:b0:3a3:744d:8dd2 with SMTP id s12-20020a05600c384c00b003a3744d8dd2mr2117743wmr.117.1660741372883;
        Wed, 17 Aug 2022 06:02:52 -0700 (PDT)
Received: from localhost.localdomain (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id y11-20020a5d620b000000b00222cf973e8csm12878862wru.69.2022.08.17.06.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 06:02:52 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org, vadimp@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v3 1/2] Revert "mlxsw: core: Use different get_trend() callbacks for different thermal zones"
Date:   Wed, 17 Aug 2022 15:02:26 +0200
Message-Id: <20220817130227.2268127-1-daniel.lezcano@linaro.org>
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
index 3548fe1df7c8..0eb52665b994 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -352,7 +352,8 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
 				   int trip, enum thermal_trend *trend)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal *thermal = tz->parent;
 
 	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
 		return -EINVAL;
@@ -546,22 +547,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
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
@@ -571,7 +556,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_module_trend_get,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -608,7 +593,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_module_trend_get,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
-- 
2.34.1

