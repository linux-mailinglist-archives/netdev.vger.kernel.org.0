Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4524D5F2D38
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiJCJ1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiJCJ0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:26:50 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F2336DCD
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:26:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l8so6614475wmi.2
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=x5YnRpxQlPTxi3ib1GcmFVKg7aq0OaYheolOuxRT8AU=;
        b=NEuw9ALzlbh0Ugwj0RJ5qGD4F0uuBJ48wpE3HF/O9a2wcxKFEnYRWE2PvytS55RaFW
         50nQEgJFXpk/HrzGvAlIacEsWszbT9vG0yFd9ODCkNUkwnOpV56kXKmEWQk8XzikZkQO
         9vcwRXBSj9suVCyQWfx3gCzIpC9hxnH9mzHaw/95V6n/Hgmmvorac98TDEEQAyaZQLLM
         /1vSIfSa6WWoCxrrd58sQX9w06Z0iUQH8APaIlWBZkGDlDqbYBzf2+wzXFZf0j/R3Qwh
         1eE71IzXGhebaUVFO9sxcLxF7Lytd9L9lPBxBmCDDJ5bN9jk9R9bc/5xD+B6N578LeR7
         e53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=x5YnRpxQlPTxi3ib1GcmFVKg7aq0OaYheolOuxRT8AU=;
        b=dbeUXJVtGaB0hF61DSra+O4X8bkvKI9iybI2rQUci0cNbO8nlqvd/NAENbNgLEjZi2
         i7ljTJfmYc32XFFiyXXJyQCrg2bLIu4rdnfKHn3nnTyHMBSAgXNYQYqTB/ln8ipOZLZN
         /lgLwx7Me40AMfa+ywwId8OywiAf4PFaHLxFJBeIKBGnqoC9lgS8Xb94GjbmSrj8ZA+y
         vVn7t155reZHSZDrmFO4kOlCimeG6jsta7CoPhMPAyAySGVeL9zn/Jw/L3NxiHdMkN5B
         +YJB/1SxavQBWdR4h1da2+R8XJzFjM3h8ksYMMn24lw1Pwy3LsJL2r6syfsjfNB7ov4r
         L1jg==
X-Gm-Message-State: ACrzQf3tRNem/eiU4dSGk+axbRqEJE3udv4t4Mjy9v6rRJyixkQhmxg+
        RpzJqKNDmR7rqBoswcr3HlN5Yg==
X-Google-Smtp-Source: AMsMyM4LNjt/iP6OuuRI/C5YvZ5IPIjTgpAqKQnrnrPmOTHPM7URNpAWoYjCHNIntV/K3JnJae544w==
X-Received: by 2002:a05:600c:19cd:b0:3b9:af1f:1b3b with SMTP id u13-20020a05600c19cd00b003b9af1f1b3bmr2343088wmq.37.1664789183890;
        Mon, 03 Oct 2022 02:26:23 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.gmail.com with ESMTPSA id ay3-20020a5d6f03000000b0022cc157bf26sm9707520wrb.85.2022.10.03.02.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:26:23 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dmitry Osipenko <digetx@gmail.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v8 03/29] thermal/core: Add a generic thermal_zone_set_trip() function
Date:   Mon,  3 Oct 2022 11:25:36 +0200
Message-Id: <20221003092602.1323944-4-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
References: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
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

The thermal zone ops defines a set_trip callback where we can invoke
the backend driver to set an interrupt for the next trip point
temperature being crossed the way up or down, or setting the low level
with the hysteresis.

The ops is only called from the thermal sysfs code where the userspace
has the ability to modify a trip point characteristic.

With the effort of encapsulating the thermal framework core code,
let's create a thermal_zone_set_trip() which is the writable side of
the thermal_zone_get_trip() and put there all the ops encapsulation.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 V8:
   - pretty one line condition and parenthesis removal (Rafael J. Wysocki)
---
 drivers/thermal/thermal_core.c  | 46 +++++++++++++++++++++++++++++
 drivers/thermal/thermal_sysfs.c | 52 +++++++++++----------------------
 include/linux/thermal.h         |  3 ++
 3 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 16ef91dc102f..3a9915824e67 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1211,6 +1211,52 @@ int thermal_zone_get_trip(struct thermal_zone_device *tz, int trip_id,
 }
 EXPORT_SYMBOL_GPL(thermal_zone_get_trip);
 
+int thermal_zone_set_trip(struct thermal_zone_device *tz, int trip_id,
+			  const struct thermal_trip *trip)
+{
+	struct thermal_trip t;
+	int ret = -EINVAL;
+
+	mutex_lock(&tz->lock);
+
+	if (!tz->ops->set_trip_temp && !tz->ops->set_trip_hyst && !tz->trips)
+		goto out;
+
+	ret = __thermal_zone_get_trip(tz, trip_id, &t);
+	if (ret)
+		goto out;
+
+	if (t.type != trip->type) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (t.temperature != trip->temperature && tz->ops->set_trip_temp) {
+		ret = tz->ops->set_trip_temp(tz, trip_id, trip->temperature);
+		if (ret)
+			goto out;
+	}
+
+	if (t.hysteresis != trip->hysteresis && tz->ops->set_trip_hyst) {
+		ret = tz->ops->set_trip_hyst(tz, trip_id, trip->hysteresis);
+		if (ret)
+			goto out;
+	}
+
+	if (tz->trips && (t.temperature != trip->temperature || t.hysteresis != trip->hysteresis))
+		tz->trips[trip_id] = *trip;
+out:
+	mutex_unlock(&tz->lock);
+
+	if (!ret) {
+		thermal_notify_tz_trip_change(tz->id, trip_id, trip->type,
+					      trip->temperature, trip->hysteresis);
+		thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
+	}
+
+	return ret;
+}
+
 /**
  * thermal_zone_device_register_with_trips() - register a new thermal zone device
  * @type:	the thermal zone device type
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 6c45194aaabb..8d7b25ab67c2 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -115,32 +115,19 @@ trip_point_temp_store(struct device *dev, struct device_attribute *attr,
 	struct thermal_trip trip;
 	int trip_id, ret;
 
-	if (!tz->ops->set_trip_temp && !tz->trips)
-		return -EPERM;
-
 	if (sscanf(attr->attr.name, "trip_point_%d_temp", &trip_id) != 1)
 		return -EINVAL;
 
-	if (kstrtoint(buf, 10, &trip.temperature))
-		return -EINVAL;
-
-	if (tz->ops->set_trip_temp) {
-		ret = tz->ops->set_trip_temp(tz, trip_id, trip.temperature);
-		if (ret)
-			return ret;
-	}
-
-	if (tz->trips)
-		tz->trips[trip_id].temperature = trip.temperature;
-
 	ret = thermal_zone_get_trip(tz, trip_id, &trip);
 	if (ret)
 		return ret;
 
-	thermal_notify_tz_trip_change(tz->id, trip_id, trip.type,
-				      trip.temperature, trip.hysteresis);
+	if (kstrtoint(buf, 10, &trip.temperature))
+		return -EINVAL;
 
-	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
+	ret = thermal_zone_set_trip(tz, trip_id, &trip);
+	if (ret)
+		return ret;
 
 	return count;
 }
@@ -168,29 +155,24 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
 		      const char *buf, size_t count)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	int trip, ret;
-	int temperature;
-
-	if (!tz->ops->set_trip_hyst)
-		return -EPERM;
+	struct thermal_trip trip;
+	int trip_id, ret;
 
-	if (sscanf(attr->attr.name, "trip_point_%d_hyst", &trip) != 1)
+	if (sscanf(attr->attr.name, "trip_point_%d_hyst", &trip_id) != 1)
 		return -EINVAL;
 
-	if (kstrtoint(buf, 10, &temperature))
-		return -EINVAL;
+	ret = thermal_zone_get_trip(tz, trip_id, &trip);
+	if (ret)
+		return ret;
 
-	/*
-	 * We are not doing any check on the 'temperature' value
-	 * here. The driver implementing 'set_trip_hyst' has to
-	 * take care of this.
-	 */
-	ret = tz->ops->set_trip_hyst(tz, trip, temperature);
+	if (kstrtoint(buf, 10, &trip.hysteresis))
+		return -EINVAL;
 
-	if (!ret)
-		thermal_zone_set_trips(tz);
+	ret = thermal_zone_set_trip(tz, trip_id, &trip);
+	if (ret)
+		return ret;
 
-	return ret ? ret : count;
+	return count;
 }
 
 static ssize_t
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index feb8b61df746..66373f872237 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -338,6 +338,9 @@ static inline void devm_thermal_of_zone_unregister(struct device *dev,
 int thermal_zone_get_trip(struct thermal_zone_device *tz, int trip_id,
 			  struct thermal_trip *trip);
 
+int thermal_zone_set_trip(struct thermal_zone_device *tz, int trip_id,
+			  const struct thermal_trip *trip);
+
 int thermal_zone_get_num_trips(struct thermal_zone_device *tz);
 
 int thermal_zone_get_crit_temp(struct thermal_zone_device *tz, int *temp);
-- 
2.34.1

