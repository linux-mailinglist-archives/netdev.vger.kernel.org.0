Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06ADA2FC500
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbhASXie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392231AbhASOI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 09:08:57 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C307C061794
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 06:05:47 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 22so21867972qkf.9
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 06:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M04lwPBiKAp4mMR41FNkA1iddXx0RaVuGp7LGXqlLnc=;
        b=vRZx1zk5ZzkqnOGAk1YZbw/HJOKDieZ5fUjU36V8D48viBYKcOXQmzrUdtKmVB69iy
         I3ii4aCSQPTvyuVIYyuKa5DpOAjjKxjXrxNfFh44a8xHOmvJOBrj6k+6qtgntxla8hvv
         /c1hNOgCVTgdW61wMxlUeDpNApd/sKqJi2ZavLhRnppGBfZ/VEh262Okoih1nOixTvZe
         nmJE4CJjWRfCOUub6dU35mgULHEbg4EFu4cEKSfkjC3+6NAbY7NxCV+M6xkJLYlsZthA
         A+JeCw81ZHCprriiqORv/1TgbUSa6rr/jYGo7+B9+QK6Eg63wTY/+BUiLLN7iV63K8mg
         uk+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M04lwPBiKAp4mMR41FNkA1iddXx0RaVuGp7LGXqlLnc=;
        b=WIdN+/6lTYhyK3XfX3c9Xq5KXtxmnDyDWdB0flaEbBE4QAq+F/AOaJRmU1ND7W2A7z
         w+inwegmTeIy2scu9FGfpiB5CfzFUOVR7qJ3nn6Wcc2bns84ut8QIS5O++aKWdJ6lEMB
         FEWy69cS2M8Vn2OAwi+xAVzkT4etQtZYPCjdCeQA8gk2WtwFfYlwudhYBIfu3AXe3+oo
         PWb2XYFmmGnS05Ck8AdDxmhKz00VsjF0/baqGPVjuohvgtzeq8V5l5vWaM7RejmHfX2b
         IjwjG+C4jcxITXpaRWM8fQEO1C8Mn8i0s5KXsjzYDtnwjUxiXQc8v9jsb3W8KeRMzXH2
         r0Lg==
X-Gm-Message-State: AOAM533vX+pBd9kXa+9j613k6dEGM8kM8xjfTs5QAjcjxANynfJwEq06
        Gu6nTJ+rFFBjGA69e9SQDwKdvw==
X-Google-Smtp-Source: ABdhPJxkMgNsxv/FnUpr31IFztG5mZka9Hx6TS03QKovH9wucBXpiFBodKgyA+hws8NjwupZRAz+UQ==
X-Received: by 2002:a37:3d1:: with SMTP id 200mr4456095qkd.30.1611065146305;
        Tue, 19 Jan 2021 06:05:46 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id f134sm12910308qke.85.2021.01.19.06.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 06:05:45 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        luciano.coelho@intel.com
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org, amitk@kernel.org,
        nathan.errera@intel.com
Subject: [PATCH 2/2] drivers: thermal: Remove thermal_notify_framework
Date:   Tue, 19 Jan 2021 09:05:41 -0500
Message-Id: <20210119140541.2453490-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119140541.2453490-1-thara.gopinath@linaro.org>
References: <20210119140541.2453490-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thermal_notify_framework just updates for a single trip point where as
thermal_zone_device_update does other bookkeeping like updating the
temperature of the thermal zone and setting the next trip point. The only
driver that was using thermal_notify_framework was updated in the previous
patch to use thermal_zone_device_update instead. Since there are no users
for thermal_notify_framework remove it.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/thermal/thermal_core.c | 18 ------------------
 include/linux/thermal.h        |  4 ----
 2 files changed, 22 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 4a291d205d5c..04f7581b70c5 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -575,24 +575,6 @@ void thermal_zone_device_update(struct thermal_zone_device *tz,
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_update);
 
-/**
- * thermal_notify_framework - Sensor drivers use this API to notify framework
- * @tz:		thermal zone device
- * @trip:	indicates which trip point has been crossed
- *
- * This function handles the trip events from sensor drivers. It starts
- * throttling the cooling devices according to the policy configured.
- * For CRITICAL and HOT trip points, this notifies the respective drivers,
- * and does actual throttling for other trip points i.e ACTIVE and PASSIVE.
- * The throttling policy is based on the configured platform data; if no
- * platform data is provided, this uses the step_wise throttling policy.
- */
-void thermal_notify_framework(struct thermal_zone_device *tz, int trip)
-{
-	handle_thermal_trip(tz, trip);
-}
-EXPORT_SYMBOL_GPL(thermal_notify_framework);
-
 static void thermal_zone_device_check(struct work_struct *work)
 {
 	struct thermal_zone_device *tz = container_of(work, struct
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 31b84404f047..77a0b8d060a5 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -398,7 +398,6 @@ int thermal_zone_get_slope(struct thermal_zone_device *tz);
 int thermal_zone_get_offset(struct thermal_zone_device *tz);
 
 void thermal_cdev_update(struct thermal_cooling_device *);
-void thermal_notify_framework(struct thermal_zone_device *, int);
 int thermal_zone_device_enable(struct thermal_zone_device *tz);
 int thermal_zone_device_disable(struct thermal_zone_device *tz);
 void thermal_zone_device_critical(struct thermal_zone_device *tz);
@@ -446,9 +445,6 @@ static inline int thermal_zone_get_offset(
 
 static inline void thermal_cdev_update(struct thermal_cooling_device *cdev)
 { }
-static inline void thermal_notify_framework(struct thermal_zone_device *tz,
-	int trip)
-{ }
 
 static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
 { return -ENODEV; }
-- 
2.25.1

