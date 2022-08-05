Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F83E58ACDC
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 16:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbiHEO7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 10:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241027AbiHEO7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 10:59:12 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394E96E885
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 07:58:20 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h13so3545518wrf.6
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 07:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=l3fRfb6BSvk17nYo2OZ/MJX0g9ONEvlXMuKYYAVUpVc=;
        b=bOcTdtgw0QnUbozX/U7W+Xnnmq8BvelHhbzO904NPqYZ51+PUbDzOzLiliYJlhcplt
         M012X6B3rZiwiJ4Db1NjJBsy3AcrKvg8hLWM3tJV2A2zbh8UIPS6fbhWZop9wVW6s0xT
         GquJjGofHZRtAUhDXrA5HZkx/mz2NXfVE9GaY8lFNiW9mN4XhH1+KAirIKH+mxGB8vSQ
         s7bYHbly1gQKyuhCMncUJxTHJrUlZSK4LWlnz8vb0FWXV+yLzaUbi/paXvtl8/ahKB2z
         yhU4echgJ9+OQlRjCcV9JnOC1SpmUDDm8fl6lnQ8IhmjLXrpztbyz7XIrkVAwwDlkwBB
         d/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=l3fRfb6BSvk17nYo2OZ/MJX0g9ONEvlXMuKYYAVUpVc=;
        b=5F2hFsjTYrs8eEJvdnmt48d1jqCGp7Oz5hLe9kc8mIE+bTPEgk+b4HTWw1/YLDmmnp
         PzSosNfpGryPQL7UXTXCAiLZXW3Z5HKGYihceWfpEyLfczinNlbGO0yQTOcI3GTcDF2P
         Aa7kQtbEQJ07sA6E0AlvLzxMaFbAqcCLjgsR6og1aguHHTbsfykzFkjBmjcnyQOE/lG4
         EjT/MXu2xoehL8lmce2UfYBLs6pjaCHW4M2+ZpVeE5i5Qs54cMngEzgtYRQ+7IE4DS8m
         je9lTwCEZjsHx0fiOpcORXg94O4uHFGRj6dJDanx1s4sJecCX5NZ6SAV8fxVAu9K0TBm
         7VCQ==
X-Gm-Message-State: ACgBeo2s1SCTF4x1MDq6eZXR4YnT+hOUHIYR3sc2YZFI/alqdYD25hwD
        x6CpJqUVBTSXwToNSdxeeXFriQ==
X-Google-Smtp-Source: AA6agR6OhC4s23ZUxa+t8aBsW/O166/9Ow+naaCg256tXgw0tCVEuGl/ihB6jpQQCePKrLhy/yS9zw==
X-Received: by 2002:a05:6000:2c6:b0:21e:6efd:1f05 with SMTP id o6-20020a05600002c600b0021e6efd1f05mr4792679wry.339.1659711498238;
        Fri, 05 Aug 2022 07:58:18 -0700 (PDT)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:aef0:8606:da6b:79ef])
        by smtp.gmail.com with ESMTPSA id y1-20020adfd081000000b0022159d92004sm3102448wrh.82.2022.08.05.07.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 07:58:17 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org (open list:CXGB4 ETHERNET DRIVER (CXGB4))
Subject: [PATCH v1 24/26] thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
Date:   Fri,  5 Aug 2022 16:57:27 +0200
Message-Id: <20220805145729.2491611-25-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220805145729.2491611-1-daniel.lezcano@linaro.org>
References: <20220805145729.2491611-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The thermal framework gives the possibility to register the trip
points with the thermal zone. When that is done, no get_trip_* ops are
needed and they can be removed.

Convert ops content logic into generic trip points and register them with the
thermal zone.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  2 -
 .../ethernet/chelsio/cxgb4/cxgb4_thermal.c    | 41 ++++---------------
 2 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 5657ac8cfca0..fca9533bc011 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1079,8 +1079,6 @@ struct mbox_list {
 #if IS_ENABLED(CONFIG_THERMAL)
 struct ch_thermal {
 	struct thermal_zone_device *tzdev;
-	int trip_temp;
-	int trip_type;
 };
 #endif
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
index 9a6d65243334..1d49cfe3e2ab 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
@@ -29,36 +29,12 @@ static int cxgb4_thermal_get_temp(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static int cxgb4_thermal_get_trip_type(struct thermal_zone_device *tzdev,
-				       int trip, enum thermal_trip_type *type)
-{
-	struct adapter *adap = tzdev->devdata;
-
-	if (!adap->ch_thermal.trip_temp)
-		return -EINVAL;
-
-	*type = adap->ch_thermal.trip_type;
-	return 0;
-}
-
-static int cxgb4_thermal_get_trip_temp(struct thermal_zone_device *tzdev,
-				       int trip, int *temp)
-{
-	struct adapter *adap = tzdev->devdata;
-
-	if (!adap->ch_thermal.trip_temp)
-		return -EINVAL;
-
-	*temp = adap->ch_thermal.trip_temp;
-	return 0;
-}
-
 static struct thermal_zone_device_ops cxgb4_thermal_ops = {
 	.get_temp = cxgb4_thermal_get_temp,
-	.get_trip_type = cxgb4_thermal_get_trip_type,
-	.get_trip_temp = cxgb4_thermal_get_trip_temp,
 };
 
+static struct thermal_trip trip = { .type = THERMAL_TRIP_CRITICAL } ;
+
 int cxgb4_thermal_init(struct adapter *adap)
 {
 	struct ch_thermal *ch_thermal = &adap->ch_thermal;
@@ -79,15 +55,14 @@ int cxgb4_thermal_init(struct adapter *adap)
 	if (ret < 0) {
 		num_trip = 0; /* could not get trip temperature */
 	} else {
-		ch_thermal->trip_temp = val * 1000;
-		ch_thermal->trip_type = THERMAL_TRIP_CRITICAL;
+		trip.temperature = val * 1000;
 	}
-
+	
 	snprintf(ch_tz_name, sizeof(ch_tz_name), "cxgb4_%s", adap->name);
-	ch_thermal->tzdev = thermal_zone_device_register(ch_tz_name, num_trip,
-							 0, adap,
-							 &cxgb4_thermal_ops,
-							 NULL, 0, 0);
+	ch_thermal->tzdev = thermal_zone_device_register_with_trips(ch_tz_name, &trip, num_trip,
+								    0, adap,
+								    &cxgb4_thermal_ops,
+								    NULL, 0, 0);
 	if (IS_ERR(ch_thermal->tzdev)) {
 		ret = PTR_ERR(ch_thermal->tzdev);
 		dev_err(adap->pdev_dev, "Failed to register thermal zone\n");
-- 
2.25.1

