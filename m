Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717395F2D3F
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiJCJ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJCJ0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:26:50 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7ABD40E1A
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:26:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id iv17so6614748wmb.4
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=aNmMz3cRMj5kxPfKCvTpL8Ywx++ZqyPMyM5lgZsCem0=;
        b=qnvtx8EtxVFStYsXPpjraGOnXJJ6ndRjl07EioymTILSNoK1K5TRU5Y/xGGlvc9cge
         2QwQC7mC1LO6XmlDYgGXMq4S1MoH2BVQY7YGKiFQqRro7Zzpx20tvDdCbTy73uaGMbEW
         Hfp+/I0lOqqw9JuGU/E2ycG9OiS20g3eG5k5EObolNhaRkG2f9RX+weRgZEgb/fJQ4KQ
         9Ug8wgnlea/v4JonW6umdfmz1VgBB5WEsexfAf3K/M8FZKcw9LghpapiR5IrGq5In2h9
         G4gAsX2nM19O+fmuqC68TWK0q5hRtOEoHZ60OVXZK+abS2e8DBKw+eoYxKtCpQNlBdOR
         9+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=aNmMz3cRMj5kxPfKCvTpL8Ywx++ZqyPMyM5lgZsCem0=;
        b=Bx9Hu/Xqj0K3UkBN0mFeQdVhWZXRB89+YxDrg8/d/yfv9PrBggxUck99EJ5Z9Axd8H
         7TFB+4luF7Lol0wmSS/p/SaeIvy+xTs1bnQrQbwGO0MLjcw20rZIKnoqwnuXoxQDBNyX
         z1kyZdF2gVIjF7oFGobmwJ3s/6xjr7n5uP+vqqGCHvAmIW+hnI5lBdohpsb89+6sZ6AE
         ITQkmAyy7FMpH6wGtohrqdmAX1Q7x6FedGFY6MD2CD1VOzVmn6RYnb6hGeDuiOWcP+mU
         xZaBt+9t81vClowgOl+1mhz5I+CgWS9NbHDHg2xn1d5TrdcXZ9+vkPjSFa/HdThWOJ9o
         v0Kg==
X-Gm-Message-State: ACrzQf0GkVfLvm422Bs5T3xKQIaVHmXl1CD9jsZftdp76xly4uxj2igA
        Iib4DsMMd5tVTPvL6Xa8gFmkxg==
X-Google-Smtp-Source: AMsMyM7YuwPFdA87r12pdmxnJL/qrjWsFKeaMHd5sqwqWLhURp8wgPj4mnNYQE36NrXRR8nhMNoE+Q==
X-Received: by 2002:a05:600c:5486:b0:3b4:7e47:e19 with SMTP id iv6-20020a05600c548600b003b47e470e19mr6268513wmb.12.1664789197014;
        Mon, 03 Oct 2022 02:26:37 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.gmail.com with ESMTPSA id ay3-20020a5d6f03000000b0022cc157bf26sm9707520wrb.85.2022.10.03.02.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:26:36 -0700 (PDT)
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
Subject: [PATCH v8 07/29] thermal/drivers/exynos: Use generic thermal_zone_get_trip() function
Date:   Mon,  3 Oct 2022 11:25:40 +0200
Message-Id: <20221003092602.1323944-8-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
References: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
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

The thermal framework gives the possibility to register the trip
points with the thermal zone. When that is done, no get_trip_* ops are
needed and they can be removed.

Convert ops content logic into generic trip points and register them with the
thermal zone.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/thermal/samsung/exynos_tmu.c | 41 +++++++++++-----------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 51874d0a284c..0e33d32a9d2e 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -260,16 +260,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct thermal_zone_device *tzd = data->tzd;
-	const struct thermal_trip * const trips =
-		of_thermal_get_trip_points(tzd);
 	unsigned int status;
-	int ret = 0, temp, hyst;
-
-	if (!trips) {
-		dev_err(&pdev->dev,
-			"Cannot get trip points from device tree!\n");
-		return -ENODEV;
-	}
+	int ret = 0, temp;
 
 	if (data->soc != SOC_ARCH_EXYNOS5433) /* FIXME */
 		ret = tzd->ops->get_crit_temp(tzd, &temp);
@@ -303,19 +295,16 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 
 		/* Write temperature code for rising and falling threshold */
 		for (i = 0; i < ntrips; i++) {
-			/* Write temperature code for rising threshold */
-			ret = tzd->ops->get_trip_temp(tzd, i, &temp);
-			if (ret)
-				goto err;
-			temp /= MCELSIUS;
-			data->tmu_set_trip_temp(data, i, temp);
 
-			/* Write temperature code for falling threshold */
-			ret = tzd->ops->get_trip_hyst(tzd, i, &hyst);
+			struct thermal_trip trip;
+			
+			ret = thermal_zone_get_trip(tzd, i, &trip);
 			if (ret)
 				goto err;
-			hyst /= MCELSIUS;
-			data->tmu_set_trip_hyst(data, i, temp, hyst);
+
+			data->tmu_set_trip_temp(data, i, trip.temperature / MCELSIUS);
+			data->tmu_set_trip_hyst(data, i, trip.temperature / MCELSIUS,
+						trip.hysteresis / MCELSIUS);
 		}
 
 		data->tmu_clear_irqs(data);
@@ -360,21 +349,23 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 }
 
 static void exynos4210_tmu_set_trip_temp(struct exynos_tmu_data *data,
-					 int trip, u8 temp)
+					 int trip_id, u8 temp)
 {
-	const struct thermal_trip * const trips =
-		of_thermal_get_trip_points(data->tzd);
+	struct thermal_trip trip;
 	u8 ref, th_code;
 
-	ref = trips[0].temperature / MCELSIUS;
+	if (thermal_zone_get_trip(data->tzd, 0, &trip))
+		return;
 
-	if (trip == 0) {
+	ref = trip.temperature / MCELSIUS;
+	
+	if (trip_id == 0) {
 		th_code = temp_to_code(data, ref);
 		writeb(th_code, data->base + EXYNOS4210_TMU_REG_THRESHOLD_TEMP);
 	}
 
 	temp -= ref;
-	writeb(temp, data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL0 + trip * 4);
+	writeb(temp, data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL0 + trip_id * 4);
 }
 
 /* failing thresholds are not supported on Exynos4210 */
-- 
2.34.1

