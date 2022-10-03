Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA05F2E35
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiJCJej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJCJcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:32:07 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FE3419BD
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:28:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id a3so3521479wrt.0
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Bvo7EJO01qiFSqaGbT4JiAGDEh8uk0vvz3ltgjeJ4xY=;
        b=W8ReuKq7jMw2pEnUxARbGJlF66wfoQjg77hHrUh6nC3tjrBDcuDBiUJBkLHLHKhJer
         mpIne0abBol1bAOH7i+luGK7um7d+qNm0/chXUcthIDDARkvmvzuIew1TTTxnTqFBE+r
         ECQO2cLGey9/bgIKD1WRr4joW/DotdD2wSkmlnN+JpJv6vyt9oGmnARpJJMQ4D2wcYpY
         ni7W/TXqbROKufTlSeo3OMrqkazbe34ydWVtz0TXbU9+X4WXvWf8ZWJdOgy80DbVmvlY
         pDT6uXObL2BoQ4a4Ofqgq2n+lNH2XZtiCsdGDuN0ZPymWCD+o0GcMcSDnmMlwe9R6+fp
         plIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Bvo7EJO01qiFSqaGbT4JiAGDEh8uk0vvz3ltgjeJ4xY=;
        b=nSMMfhWwLhWuJXOcwBgOKR3LfW5w3EVF0wTMz9m9YKcw7DrnGO2kptpE6DjfoDUESv
         wt3RuuMM8HyYgJsD7NE3IzLQ5QrEDAQY1mfjikOQOVPmYDTyCvGpMJfEWsR65RxpOM3B
         Yjrxaelznzpku0rny7raDdzR8Rktj8yzVLGP4oWKn6CZxvtnWAb4sdMufQdRBnStaiqb
         ku9vuwEqd8rEWisq+RUgPj1ay4aIO49C4Bfj89fjAmSOQOXyjrpqvAdKK//vzVJY8SWn
         hSA8iENBYfiSYvY+pCCIjaaG/1YyqCdBKslnv1SD8i06DCNazpw33OvyR2kB5SZTII0T
         Jz1Q==
X-Gm-Message-State: ACrzQf1I4U43sHyAyw4X7YX6wbUYJgkJhKlMz9IktwedXE6MpmkjjE7y
        Bm3nk2xmALC0RPOHo+MibQqLXQ==
X-Google-Smtp-Source: AMsMyM6ELzLHVK4/BCcPbpIkgCQlGCCs9OZGnaeVi3u5I4MTLMi0XYiBPGTqyEgDtCUZssOE4JC0UQ==
X-Received: by 2002:a5d:6da1:0:b0:22b:774:52c3 with SMTP id u1-20020a5d6da1000000b0022b077452c3mr12601883wrs.172.1664789261097;
        Mon, 03 Oct 2022 02:27:41 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.gmail.com with ESMTPSA id ay3-20020a5d6f03000000b0022cc157bf26sm9707520wrb.85.2022.10.03.02.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:27:40 -0700 (PDT)
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
Subject: [PATCH v8 26/29] thermal/drivers/acerhdf: Use generic thermal_zone_get_trip() function
Date:   Mon,  3 Oct 2022 11:25:59 +0200
Message-Id: <20221003092602.1323944-27-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
References: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Peter Kästle <peter@piie.net>
---
 drivers/platform/x86/acerhdf.c | 73 ++++++++++++----------------------
 1 file changed, 26 insertions(+), 47 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 3463629f8764..a7407aa032ba 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -46,6 +46,8 @@
  * measured by the on-die thermal monitor are within 0 <= Tj <= 90. So,
  * assume 89°C is critical temperature.
  */
+#define ACERHDF_DEFAULT_TEMP_FANON 60000
+#define ACERHDF_DEFAULT_TEMP_FANOFF 53000
 #define ACERHDF_TEMP_CRIT 89000
 #define ACERHDF_FAN_OFF 0
 #define ACERHDF_FAN_AUTO 1
@@ -70,8 +72,8 @@ static int kernelmode;
 #endif
 
 static unsigned int interval = 10;
-static unsigned int fanon = 60000;
-static unsigned int fanoff = 53000;
+static unsigned int fanon = ACERHDF_DEFAULT_TEMP_FANON;
+static unsigned int fanoff = ACERHDF_DEFAULT_TEMP_FANOFF;
 static unsigned int verbose;
 static unsigned int list_supported;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
@@ -137,6 +139,15 @@ struct ctrl_settings {
 	int mcmd_enable;
 };
 
+static struct thermal_trip trips[] = {
+	[0] = { .temperature = ACERHDF_DEFAULT_TEMP_FANON,
+		.hysteresis = ACERHDF_DEFAULT_TEMP_FANON - ACERHDF_DEFAULT_TEMP_FANOFF,
+		.type = THERMAL_TRIP_ACTIVE },
+
+	[1] = { .temperature = ACERHDF_TEMP_CRIT,
+		.type = THERMAL_TRIP_CRITICAL }
+};
+
 static struct ctrl_settings ctrl_cfg __read_mostly;
 
 /* Register addresses and values for different BIOS versions */
@@ -326,6 +337,15 @@ static void acerhdf_check_param(struct thermal_zone_device *thermal)
 		fanon = ACERHDF_MAX_FANON;
 	}
 
+	if (fanon < fanoff) {
+		pr_err("fanoff temperature (%d) is above fanon temperature (%d), clamping to %d\n",
+		       fanoff, fanon, fanon);
+		fanoff = fanon;
+	};
+
+	trips[0].temperature = fanon;
+	trips[0].hysteresis  = fanon - fanoff;
+
 	if (kernelmode && prev_interval != interval) {
 		if (interval > ACERHDF_MAX_INTERVAL) {
 			pr_err("interval too high, set to %d\n",
@@ -424,43 +444,6 @@ static int acerhdf_change_mode(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
-				 enum thermal_trip_type *type)
-{
-	if (trip == 0)
-		*type = THERMAL_TRIP_ACTIVE;
-	else if (trip == 1)
-		*type = THERMAL_TRIP_CRITICAL;
-	else
-		return -EINVAL;
-
-	return 0;
-}
-
-static int acerhdf_get_trip_hyst(struct thermal_zone_device *thermal, int trip,
-				 int *temp)
-{
-	if (trip != 0)
-		return -EINVAL;
-
-	*temp = fanon - fanoff;
-
-	return 0;
-}
-
-static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
-				 int *temp)
-{
-	if (trip == 0)
-		*temp = fanon;
-	else if (trip == 1)
-		*temp = ACERHDF_TEMP_CRIT;
-	else
-		return -EINVAL;
-
-	return 0;
-}
-
 static int acerhdf_get_crit_temp(struct thermal_zone_device *thermal,
 				 int *temperature)
 {
@@ -474,13 +457,9 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
 	.unbind = acerhdf_unbind,
 	.get_temp = acerhdf_get_ec_temp,
 	.change_mode = acerhdf_change_mode,
-	.get_trip_type = acerhdf_get_trip_type,
-	.get_trip_hyst = acerhdf_get_trip_hyst,
-	.get_trip_temp = acerhdf_get_trip_temp,
 	.get_crit_temp = acerhdf_get_crit_temp,
 };
 
-
 /*
  * cooling device callback functions
  * get maximal fan cooling state
@@ -710,10 +689,10 @@ static int __init acerhdf_register_thermal(void)
 	if (IS_ERR(cl_dev))
 		return -EINVAL;
 
-	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
-					      &acerhdf_dev_ops,
-					      &acerhdf_zone_params, 0,
-					      (kernelmode) ? interval*1000 : 0);
+	thz_dev = thermal_zone_device_register_with_trips("acerhdf", trips, ARRAY_SIZE(trips),
+							  0, NULL, &acerhdf_dev_ops,
+							  &acerhdf_zone_params, 0,
+							  (kernelmode) ? interval*1000 : 0);
 	if (IS_ERR(thz_dev))
 		return -EINVAL;
 
-- 
2.34.1

