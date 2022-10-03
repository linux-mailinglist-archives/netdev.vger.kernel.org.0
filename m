Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9CB5F2E0E
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiJCJcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiJCJbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:31:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433425465F
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:27:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a3so3520611wrt.0
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=9Ogs5/BdK1Y/lDDyEmjA88qgr/D6i26XcRmp1g6reCg=;
        b=l9koF9bF965NaCuA+Ntkb2Pm9axOdp3LETpP2GojpFRy9GhKkGTVqUxLJZzVehHC3W
         CqEj+nWMVltstLhaGqZ9V496HAk8l7VO/0LTKCwV8plbbwg0w8CyKy47Idz1EovHVLGs
         DqLQVLukkGTCeYGul5OcJB3aRk7gNy7holm+NytTRlhiIZ/OLz5bhDfJ91CSy/MrHiuK
         EOVqtMdHxaYm1b0BCxHczrqlpfPb925t7aFSwqe3eQUjtjQWMyoSyzSXSOXnA00rRbVf
         RcT+Fideb8DNO8Y6yg75DzykXNiubqyHcdLcw+FanyBuAOndMuI6ev+igalUTLBGe8zc
         TBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9Ogs5/BdK1Y/lDDyEmjA88qgr/D6i26XcRmp1g6reCg=;
        b=nqOIiIMvLrJ4Dntn++POqxrhKJmFkHqyvNGGuZyhxJ2gDG4MsYVwWUDWeH/1SUvGe0
         aCVIFRyhvM3RZvPadkjUP63WBm/79pgUMWHfGAvX6uClzk5fipYbm1zUYOWoo4bzJg5X
         Q9/8gc3nceIWU/Q6SiEBKsk3rMPQJVFFMWzdnq82vMxdCt0WSlsBrDgTG/suzmIZaQXj
         0gZEF1rKzjv7sovEABdCt/2SdV6HTmmxi6Fgo7MR953Ws001am0wTKxSZ9luteXYcEh2
         1jblKqJvY4iDrw+K58OEa3BYi0hfICNd/2TS6w0/5VTqiFoLM+gm2wCN+NM7913RNHpG
         rUcQ==
X-Gm-Message-State: ACrzQf2N8boEz4HpWtnKnMHkuLcDWC6vfe90S70FCupUYdorsZLVX4V5
        p8cUJWOINaNJijaYqfjy2SgFXw==
X-Google-Smtp-Source: AMsMyM73+P1/BH4acbKDs43aU6WmdFaaXg72ipQbyYvquhkAtm0V1FAqwRkF92ZeyeQ9frW6D3DhXw==
X-Received: by 2002:a5d:4cc2:0:b0:22e:372d:9c9 with SMTP id c2-20020a5d4cc2000000b0022e372d09c9mr3386176wrt.576.1664789247627;
        Mon, 03 Oct 2022 02:27:27 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.gmail.com with ESMTPSA id ay3-20020a5d6f03000000b0022cc157bf26sm9707520wrb.85.2022.10.03.02.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:27:27 -0700 (PDT)
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
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v8 22/29] thermal/drivers/rcar: Use generic thermal_zone_get_trip() function
Date:   Mon,  3 Oct 2022 11:25:55 +0200
Message-Id: <20221003092602.1323944-23-daniel.lezcano@linaro.org>
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
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/thermal/rcar_thermal.c | 53 ++++------------------------------
 1 file changed, 6 insertions(+), 47 deletions(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 61c2b8855cb8..436f5f9cf729 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -278,52 +278,12 @@ static int rcar_thermal_get_temp(struct thermal_zone_device *zone, int *temp)
 	return rcar_thermal_get_current_temp(priv, temp);
 }
 
-static int rcar_thermal_get_trip_type(struct thermal_zone_device *zone,
-				      int trip, enum thermal_trip_type *type)
-{
-	struct rcar_thermal_priv *priv = rcar_zone_to_priv(zone);
-	struct device *dev = rcar_priv_to_dev(priv);
-
-	/* see rcar_thermal_get_temp() */
-	switch (trip) {
-	case 0: /* +90 <= temp */
-		*type = THERMAL_TRIP_CRITICAL;
-		break;
-	default:
-		dev_err(dev, "rcar driver trip error\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int rcar_thermal_get_trip_temp(struct thermal_zone_device *zone,
-				      int trip, int *temp)
-{
-	struct rcar_thermal_priv *priv = rcar_zone_to_priv(zone);
-	struct device *dev = rcar_priv_to_dev(priv);
-
-	/* see rcar_thermal_get_temp() */
-	switch (trip) {
-	case 0: /* +90 <= temp */
-		*temp = MCELSIUS(90);
-		break;
-	default:
-		dev_err(dev, "rcar driver trip error\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static const struct thermal_zone_device_ops rcar_thermal_zone_of_ops = {
+static struct thermal_zone_device_ops rcar_thermal_zone_ops = {
 	.get_temp	= rcar_thermal_get_temp,
 };
 
-static struct thermal_zone_device_ops rcar_thermal_zone_ops = {
-	.get_temp	= rcar_thermal_get_temp,
-	.get_trip_type	= rcar_thermal_get_trip_type,
-	.get_trip_temp	= rcar_thermal_get_trip_temp,
+static struct thermal_trip trips[] = {
+	{ .type = THERMAL_TRIP_CRITICAL, .temperature = 90000 }
 };
 
 /*
@@ -529,11 +489,10 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 		if (chip->use_of_thermal) {
 			priv->zone = devm_thermal_of_zone_register(
 						dev, i, priv,
-						&rcar_thermal_zone_of_ops);
+						&rcar_thermal_zone_ops);
 		} else {
-			priv->zone = thermal_zone_device_register(
-						"rcar_thermal",
-						1, 0, priv,
+			priv->zone = thermal_zone_device_register_with_trips(
+				"rcar_thermal", trips, ARRAY_SIZE(trips), 0, priv,
 						&rcar_thermal_zone_ops, NULL, 0,
 						idle);
 
-- 
2.34.1

