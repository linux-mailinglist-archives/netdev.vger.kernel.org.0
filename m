Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890825BFB88
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiIUJpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiIUJoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:44:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF6E9320E
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:44:03 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id e18so4010827wmq.3
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=qkEQMAFlFrUq6t0pAagx8mtMZ2aPJX8cpHX423TQAwM=;
        b=ogHqoEENLPo5SoQ9S2Vi25qoB7gOOZ7+XSWy/Dw+YQUbu9gjo1fQvdRGCGzO8xBaEC
         cUf80Vt9k4k1Exyo34PXuipr7TvCKnBY1Wloo5hQdoa6x6ImrAAhw1Viii4Pmx+ZcG29
         W0VgIBLgI9XNUDQQ+qVSaz0aje/VH9ezpZuV3ivcdnclZOFalH1UE0d3vBNioLO+KJCF
         PYP0tHowrPBXKpICwXGCBuLzurxmqQTh1OpSp0MgaKAVBSDL8Vwe/VeIDq4jptrLDa0m
         KigVNq0LUJqqlXiJqopQPCYWEw889Doji96nrPtTeLZNHJ5iyUor2LWZO2u0HeI4omW1
         P2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qkEQMAFlFrUq6t0pAagx8mtMZ2aPJX8cpHX423TQAwM=;
        b=rAx5IwmOTRwPBG0hlTgceM+xU4MLnKSiI0InJ958B+/yheUlBSquJAa0zODd12AABc
         eWy6IqCKtW7I4ghVSPp5HF6cWaN9uIcWCZA0kSQwBfmJS0cZbHH3a0NmHyI5uk3DXJQm
         X4jC8H0JieQqEMJo8tKUJgxTN4DTk+9dHwoxHSorKT90ZLkSs09Mc9eLc7ssP5d+uogi
         jTfMGxQTbPNh4+CC+DFuQImHcbPFGE0CJw1L/Oioslq1H4+7kL7sqmBlC11OqMCx8A1h
         ekk13en8mgepqwxFxC5SbHQmy1Ld8sObISlXjMpJBUDOpO28QxkvYtcCzc58jDSKsjvn
         CY8w==
X-Gm-Message-State: ACrzQf3E2QUbaAXO7LzkSPpFinYLiY0yNmcXngSAJ9wfqxIglWwHeg4/
        P6ah/ObDawrpvlmtqrdfLKCmNQ==
X-Google-Smtp-Source: AMsMyM58Z8/99S2gEqNRt3pt4wFPxXB4uXZRW1kZiffVxq+pcNC/TDo9mB2ziCv56t7Ctox7Gt7QqA==
X-Received: by 2002:a05:600c:1c19:b0:3b4:c1cb:d46d with SMTP id j25-20020a05600c1c1900b003b4c1cbd46dmr5226287wms.172.1663753441506;
        Wed, 21 Sep 2022 02:44:01 -0700 (PDT)
Received: from mai.. (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id r123-20020a1c2b81000000b003a62052053csm2763917wmr.18.2022.09.21.02.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 02:44:01 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org (open list:CXGB4 ETHERNET DRIVER (CXGB4))
Subject: [PATCH v4 28/30] thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
Date:   Wed, 21 Sep 2022 11:42:41 +0200
Message-Id: <20220921094244.606948-29-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220921094244.606948-1-daniel.lezcano@linaro.org>
References: <20220921094244.606948-1-daniel.lezcano@linaro.org>
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

The thermal framework gives the possibility to register the trip
points with the thermal zone. When that is done, no get_trip_* ops are
needed and they can be removed.

Convert ops content logic into generic trip points and register them with the
thermal zone.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Jakub Kicinski <kuba@kernel.org>
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
2.34.1

