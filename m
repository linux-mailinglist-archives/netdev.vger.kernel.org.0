Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48EA5F2DFE
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiJCJcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJCJaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:30:17 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECB85303F
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:27:49 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n35-20020a05600c502300b003b4924c6868so6790299wmr.1
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=pY49ET3ZIgq2w00tEafAmFrW/5GVD2UTvB8HzlNbQv0=;
        b=T04C7dRhVMFUXZEHbcu1Ig9kQmAl4Nzl38oyHyFyc093xBPNgIPOlKKihhcCBNkTrs
         1B8CRcagNT7TWPrW/A7UYzeM+1gjCEDZoSnsiMOyw/M5DZtb3Z7xPpn4eCbDR6RwlSP7
         x7eD8svZ5XQ69poVJGCYZ8bNppFX7pU9889zOzwYZPDX6Q5f1XhPNlvhU0Jk9xWdYQdD
         dkH4Za+9qiS6MH+biLaEK2KURQa2QEkayz5bFmhhulNgboJKB0sY4ng7Gt3sKaTUu9z/
         dpy2ow+F+eugbrfUPzFdvuqYBp4ObWNBJYA705i+faYSC5OYujSs3B9EZcy5g8UfBfXY
         zjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pY49ET3ZIgq2w00tEafAmFrW/5GVD2UTvB8HzlNbQv0=;
        b=PhRMIPT1ltCV3I58P9nnBNW2KIVLCYUM0kgn16PFNXodJoYISOqtM24cNBeldSqIBa
         OJcwwDMBug6zr7XYr8RrJ/rmaB2PeNULSUDKRnxID5jcNG23opxxzk1Supmo6UQ5bhGG
         vPAusNif7hWOBJrYH+nZBvl08iVrzAVKhVNktZsdDiZUHNAzS/x31oG/np6QkxGd8CHl
         AvwhOSYgo1ECnXvVF0vhgMzAqbkQso9AwGaZ5KNDlBAi1YfakfxrFsjZLlvkXAYBRVZb
         d2byUj5Mr+xPkl3rv4BHu5fKKKpWwVtAi63G4R6OkBcNKGNHsaqAv+6nOlx/Z2ndr0q1
         UYRQ==
X-Gm-Message-State: ACrzQf19S640KPooJyel0fOw+rPu09QlMsqwbNa6gG1x5qXlxYFSK0P7
        UZ90ErpzXiGxc4bsjmiRIWpVfw==
X-Google-Smtp-Source: AMsMyM5+zJt6jybBFwi4vBGgi3BYQ43vjAGd6pfWFjwY6B6j+KbBhB00RfAYpBqJiXWLWm6a076F9Q==
X-Received: by 2002:a05:600c:4211:b0:3b4:6334:9940 with SMTP id x17-20020a05600c421100b003b463349940mr6378922wmh.166.1664789269392;
        Mon, 03 Oct 2022 02:27:49 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.gmail.com with ESMTPSA id ay3-20020a5d6f03000000b0022cc157bf26sm9707520wrb.85.2022.10.03.02.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:27:48 -0700 (PDT)
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
Subject: [PATCH v8 28/29] thermal/intel/int340x: Replace parameter to simplify
Date:   Mon,  3 Oct 2022 11:26:01 +0200
Message-Id: <20221003092602.1323944-29-daniel.lezcano@linaro.org>
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

In the process of replacing the get_trip_* ops by the generic trip
points, the current code has an 'override' property to add another
indirection to a different ops.

Rework this approach to prevent this indirection and make the code
ready for the generic trip points conversion.

Actually the get_temp() is different regarding the platform, so it is
pointless to add a new set of ops but just create dynamically the ops
at init time.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 .../int340x_thermal/int340x_thermal_zone.c    | 33 +++++++++----------
 .../int340x_thermal/int340x_thermal_zone.h    |  4 +--
 .../processor_thermal_device.c                | 10 ++----
 3 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index 62c0aa5d0783..66cd50e0b50a 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -18,9 +18,6 @@ static int int340x_thermal_get_zone_temp(struct thermal_zone_device *zone,
 	unsigned long long tmp;
 	acpi_status status;
 
-	if (d->override_ops && d->override_ops->get_temp)
-		return d->override_ops->get_temp(zone, temp);
-
 	status = acpi_evaluate_integer(d->adev->handle, "_TMP", NULL, &tmp);
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -46,9 +43,6 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
 	struct int34x_thermal_zone *d = zone->devdata;
 	int i;
 
-	if (d->override_ops && d->override_ops->get_trip_temp)
-		return d->override_ops->get_trip_temp(zone, trip, temp);
-
 	if (trip < d->aux_trip_nr)
 		*temp = d->aux_trips[trip];
 	else if (trip == d->crt_trip_id)
@@ -79,9 +73,6 @@ static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
 	struct int34x_thermal_zone *d = zone->devdata;
 	int i;
 
-	if (d->override_ops && d->override_ops->get_trip_type)
-		return d->override_ops->get_trip_type(zone, trip, type);
-
 	if (trip < d->aux_trip_nr)
 		*type = THERMAL_TRIP_PASSIVE;
 	else if (trip == d->crt_trip_id)
@@ -112,9 +103,6 @@ static int int340x_thermal_set_trip_temp(struct thermal_zone_device *zone,
 	acpi_status status;
 	char name[10];
 
-	if (d->override_ops && d->override_ops->set_trip_temp)
-		return d->override_ops->set_trip_temp(zone, trip, temp);
-
 	snprintf(name, sizeof(name), "PAT%d", trip);
 	status = acpi_execute_simple_method(d->adev->handle, name,
 			millicelsius_to_deci_kelvin(temp));
@@ -134,9 +122,6 @@ static int int340x_thermal_get_trip_hyst(struct thermal_zone_device *zone,
 	acpi_status status;
 	unsigned long long hyst;
 
-	if (d->override_ops && d->override_ops->get_trip_hyst)
-		return d->override_ops->get_trip_hyst(zone, trip, temp);
-
 	status = acpi_evaluate_integer(d->adev->handle, "GTSH", NULL, &hyst);
 	if (ACPI_FAILURE(status))
 		*temp = 0;
@@ -217,7 +202,7 @@ static struct thermal_zone_params int340x_thermal_params = {
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
-				struct thermal_zone_device_ops *override_ops)
+						     int (*get_temp) (struct thermal_zone_device *, int *))
 {
 	struct int34x_thermal_zone *int34x_thermal_zone;
 	acpi_status status;
@@ -231,8 +216,17 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 		return ERR_PTR(-ENOMEM);
 
 	int34x_thermal_zone->adev = adev;
-	int34x_thermal_zone->override_ops = override_ops;
 
+	int34x_thermal_zone->ops = kmemdup(&int340x_thermal_zone_ops,
+					   sizeof(int340x_thermal_zone_ops), GFP_KERNEL);
+	if (!int34x_thermal_zone->ops) {
+		ret = -ENOMEM;
+		goto err_ops_alloc;
+	}
+
+	if (get_temp)
+		int34x_thermal_zone->ops->get_temp = get_temp;
+	
 	status = acpi_evaluate_integer(adev->handle, "PATC", NULL, &trip_cnt);
 	if (ACPI_FAILURE(status))
 		trip_cnt = 0;
@@ -262,7 +256,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 						acpi_device_bid(adev),
 						trip_cnt,
 						trip_mask, int34x_thermal_zone,
-						&int340x_thermal_zone_ops,
+						int34x_thermal_zone->ops,
 						&int340x_thermal_params,
 						0, 0);
 	if (IS_ERR(int34x_thermal_zone->zone)) {
@@ -281,6 +275,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
 err_trip_alloc:
+	kfree(int34x_thermal_zone->ops);
+err_ops_alloc:
 	kfree(int34x_thermal_zone);
 	return ERR_PTR(ret);
 }
@@ -292,6 +288,7 @@ void int340x_thermal_zone_remove(struct int34x_thermal_zone
 	thermal_zone_device_unregister(int34x_thermal_zone->zone);
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
+	kfree(int34x_thermal_zone->ops);
 	kfree(int34x_thermal_zone);
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
index 3b4971df1b33..e28ab1ba5e06 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
@@ -29,13 +29,13 @@ struct int34x_thermal_zone {
 	int hot_temp;
 	int hot_trip_id;
 	struct thermal_zone_device *zone;
-	struct thermal_zone_device_ops *override_ops;
+	struct thermal_zone_device_ops *ops;
 	void *priv_data;
 	struct acpi_lpat_conversion_table *lpat_table;
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,
-				struct thermal_zone_device_ops *override_ops);
+				int (*get_temp) (struct thermal_zone_device *, int *));
 void int340x_thermal_zone_remove(struct int34x_thermal_zone *);
 int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone);
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index a8d98f1bd6c6..317703027ce9 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -207,10 +207,6 @@ static int proc_thermal_get_zone_temp(struct thermal_zone_device *zone,
 	return ret;
 }
 
-static struct thermal_zone_device_ops proc_thermal_local_ops = {
-	.get_temp       = proc_thermal_get_zone_temp,
-};
-
 static int proc_thermal_read_ppcc(struct proc_thermal_device *proc_priv)
 {
 	int i;
@@ -285,7 +281,7 @@ int proc_thermal_add(struct device *dev, struct proc_thermal_device *proc_priv)
 	struct acpi_device *adev;
 	acpi_status status;
 	unsigned long long tmp;
-	struct thermal_zone_device_ops *ops = NULL;
+	int (*get_temp) (struct thermal_zone_device *, int *) = NULL;
 	int ret;
 
 	adev = ACPI_COMPANION(dev);
@@ -304,10 +300,10 @@ int proc_thermal_add(struct device *dev, struct proc_thermal_device *proc_priv)
 		/* there is no _TMP method, add local method */
 		stored_tjmax = get_tjmax();
 		if (stored_tjmax > 0)
-			ops = &proc_thermal_local_ops;
+			get_temp = proc_thermal_get_zone_temp;
 	}
 
-	proc_priv->int340x_zone = int340x_thermal_zone_add(adev, ops);
+	proc_priv->int340x_zone = int340x_thermal_zone_add(adev, get_temp);
 	if (IS_ERR(proc_priv->int340x_zone)) {
 		return PTR_ERR(proc_priv->int340x_zone);
 	} else
-- 
2.34.1

