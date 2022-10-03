Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DEB5F2DC9
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiJCJaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiJCJ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:29:21 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6D840E2D
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:27:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bv17so6834922wrb.10
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=G/YO0fJeKfkSzRqdgqFU3ij4yJaDOnZPHmbsRpXJf/A=;
        b=m8PGB4q8KhZuJG6l/iwZ3mhCBCZ/XAWQq4HqyyeOlZmJsxaKnDIAvHfvP2B8cpfI+q
         YM3K1cyu4sxjpaAmCPBWvKeeLa1EEb6ZJka1ItuxPrMZjKEz4ETXfhJIEemzcWj0kgOo
         2KT0FPG0besMn6ElRxhEiGyzaGdQKW034dZ8e78COMrF9oCqOLlC/zD6Ee37125Ew5kC
         eHySFW2YcmjFQ7yyql3CyGezaW6mb/IC6/a2GHQLVO/CebhgzwsMSL95rI42xQdFf75t
         azAlJ7AqS+tkSm4dNRK7WkHqo2z2tdE2lgmIbaWzQFs8BSmD9yfLseDkCDgSJ6HOiUMe
         /HRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=G/YO0fJeKfkSzRqdgqFU3ij4yJaDOnZPHmbsRpXJf/A=;
        b=S8KXHV2biK5oJ6So1QLHJBM76utCgoJy8H2UG1pykrfRqRFPM7Ymn+dS1zW5QmypZe
         ikkdxGfuVvrXagnJDP0nBMPf+Z4sbflrfqVsj0CxOIIxWledJtrUqMsQcCVlMHJ/CaZg
         xrjTmDJoqiGJRybvD5ip9dYG74QO/xGb/GZBahUBfvn9Y9xr53+jTa7nf7EQLUCttpXq
         3tr491DAy9LhDX6xhlGIgCDnVHBHbZUxjj+4i5GH3wwrH2pC0EBW0LfiAxjXjgiL00aT
         Yms84BOkZdJt0Y/VS7Cx4pq4gdueS9ys1gl+z0F7RJwGRTBdsrpUOO+0OOX2ZZ1oklyi
         +tdA==
X-Gm-Message-State: ACrzQf1/oxOrISlTtsTwPSGKrDJ6EK+j/I+ZTwENMg4T8xZO7OMJZlEV
        LKPF8hH/uSkoJolwi+ofwenROg==
X-Google-Smtp-Source: AMsMyM7gsn52CUx5wrjtjzaxGVsGC7FPsBHbuCD2UcRFhsLzFWaoemeyB4TfY2JmOJO152GiXW+J+w==
X-Received: by 2002:a5d:56c8:0:b0:22e:32c5:d397 with SMTP id m8-20020a5d56c8000000b0022e32c5d397mr4824209wrw.462.1664789227584;
        Mon, 03 Oct 2022 02:27:07 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.gmail.com with ESMTPSA id ay3-20020a5d6f03000000b0022cc157bf26sm9707520wrb.85.2022.10.03.02.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:27:07 -0700 (PDT)
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
Subject: [PATCH v8 16/29] thermal/of: Remove of_thermal_get_ntrips()
Date:   Mon,  3 Oct 2022 11:25:49 +0200
Message-Id: <20221003092602.1323944-17-daniel.lezcano@linaro.org>
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

The thermal OF code uses the generic trip points to initialize the
thermal zone. Consequently thermal_zone_get_num_trips() can be used
and the of_thermal_get_ntrips() is no longer needed. Remove it.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/thermal/thermal_core.h |  5 -----
 drivers/thermal/thermal_of.c   | 16 ----------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index c5990a3fcf8a..b00fc1913734 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -139,13 +139,8 @@ thermal_cooling_device_stats_update(struct thermal_cooling_device *cdev,
 
 /* device tree support */
 #ifdef CONFIG_THERMAL_OF
-int of_thermal_get_ntrips(struct thermal_zone_device *);
 bool of_thermal_is_trip_valid(struct thermal_zone_device *, int);
 #else
-static inline int of_thermal_get_ntrips(struct thermal_zone_device *tz)
-{
-	return 0;
-}
 static inline bool of_thermal_is_trip_valid(struct thermal_zone_device *tz,
 					    int trip)
 {
diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 2f533fc94917..89afa59c4915 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -19,22 +19,6 @@
 
 #include "thermal_core.h"
 
-/**
- * of_thermal_get_ntrips - function to export number of available trip
- *			   points.
- * @tz: pointer to a thermal zone
- *
- * This function is a globally visible wrapper to get number of trip points
- * stored in the local struct __thermal_zone
- *
- * Return: number of available trip points, -ENODEV when data not available
- */
-int of_thermal_get_ntrips(struct thermal_zone_device *tz)
-{
-	return tz->num_trips;
-}
-EXPORT_SYMBOL_GPL(of_thermal_get_ntrips);
-
 /**
  * of_thermal_is_trip_valid - function to check if trip point is valid
  *
-- 
2.34.1

