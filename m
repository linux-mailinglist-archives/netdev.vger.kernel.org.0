Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2C85F2D2D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiJCJ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiJCJ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:26:43 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B70338687
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:26:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w18so7041530wro.7
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=NHEq81Yai/Cx5A3bz8fUfqWE2nXe05b8U8mTE9eCuHA=;
        b=Ycp6Hv4OEi8FM6VSg6+nld2un4TWu5RT/UHJ8CejYgHfolerJaG1wnQo3PgBjI2Q1Q
         5lG35sIANDxExFGMZdxevSZ4jkoWJs71I1WhCUW3WpGUKz8Xj3OvorKKc7Ckl8lboa4T
         A+SWrCFj4y1VZ9KSQpxYWvspygR3ifIEcrTRtGYpL+l45A7CSyhxjOSGQLPsS9SoZbr+
         0GDmWOX7tK+KJ5kAfABFp+x1bgLGdI3Q91D+KTHNztlIUqChrzU5Q/Jb18KdkawMMGwj
         o4UNL5QFghlup4I3RgYdw9HSkhBOvFvTBMTASXGRW2rogV5c9Zd9q/D3hnoklNOyEGXQ
         eFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NHEq81Yai/Cx5A3bz8fUfqWE2nXe05b8U8mTE9eCuHA=;
        b=TPqFJogJc9v+HA/vmbX7eDZatLbo6VqWMSfa+pwYun81XAbnqF8zPzDGWdGvhxoSxm
         ITvpod/F9cksIbbzNotp00y/HCEG2X3iFHJIe/7lzx9+kH4PKFaSv5PEwn9KYEwiJU7S
         qNvlcb228tI/A8BNneKRs3VPTCT+93RwQ2+BHTctRvtLaDyW2GD0Kwc9wo3NLtJ6c9rV
         obxnJftiA4UEjqoeH9YzF2Q+/7ubcNRzkmR+ra8vv0wKpv/8fP2mm1gDRdBnong0iEXE
         mJS97GGFTlFjEw3feXJ1oKRd81nBpN0GROA7uXcORVx5WECKGWG8p6vQ8mDG1gBc/KSE
         BtKw==
X-Gm-Message-State: ACrzQf2iJa8tekDgl5e1B4Tv3faWqDlBzBQs0l/Lbh7r7H2NojYQ/lSz
        zz2ESD9iSpk0MKtAf6YH1Ta6jw==
X-Google-Smtp-Source: AMsMyM5yEsq+QukFS+lIBKqy0vt6Y6QsuNmQH5ynCr5tl8rdfj8uN8IK3YCqBKYzp8zgIvZ1otYNXw==
X-Received: by 2002:a5d:59ae:0:b0:22a:ff17:db96 with SMTP id p14-20020a5d59ae000000b0022aff17db96mr12870552wrr.299.1664789180392;
        Mon, 03 Oct 2022 02:26:20 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.gmail.com with ESMTPSA id ay3-20020a5d6f03000000b0022cc157bf26sm9707520wrb.85.2022.10.03.02.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:26:19 -0700 (PDT)
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
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v8 02/29] thermal/sysfs: Always expose hysteresis attributes
Date:   Mon,  3 Oct 2022 11:25:35 +0200
Message-Id: <20221003092602.1323944-3-daniel.lezcano@linaro.org>
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

Instead of avoiding to expose the hysteresis attributes of a thermal
zone when its get_trip_hyst() operation is not defined, which is
confusing, expose them always and use the default
thermal_zone_get_trip() function returning 0 hysteresis when that
operation is not present.

The hysteresis of 0 is perfectly valid, so this change should not
introduce any backwards compatibility issues.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/thermal/thermal_sysfs.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index d093d7aa64c6..6c45194aaabb 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -426,23 +426,20 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 		return -ENOMEM;
 	}
 
-	if (tz->ops->get_trip_hyst) {
-		tz->trip_hyst_attrs = kcalloc(tz->num_trips,
-					      sizeof(*tz->trip_hyst_attrs),
-					      GFP_KERNEL);
-		if (!tz->trip_hyst_attrs) {
-			kfree(tz->trip_type_attrs);
-			kfree(tz->trip_temp_attrs);
-			return -ENOMEM;
-		}
+	tz->trip_hyst_attrs = kcalloc(tz->num_trips,
+				      sizeof(*tz->trip_hyst_attrs),
+				      GFP_KERNEL);
+	if (!tz->trip_hyst_attrs) {
+		kfree(tz->trip_type_attrs);
+		kfree(tz->trip_temp_attrs);
+		return -ENOMEM;
 	}
 
 	attrs = kcalloc(tz->num_trips * 3 + 1, sizeof(*attrs), GFP_KERNEL);
 	if (!attrs) {
 		kfree(tz->trip_type_attrs);
 		kfree(tz->trip_temp_attrs);
-		if (tz->ops->get_trip_hyst)
-			kfree(tz->trip_hyst_attrs);
+		kfree(tz->trip_hyst_attrs);
 		return -ENOMEM;
 	}
 
@@ -475,9 +472,6 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 		}
 		attrs[indx + tz->num_trips] = &tz->trip_temp_attrs[indx].attr.attr;
 
-		/* create Optional trip hyst attribute */
-		if (!tz->ops->get_trip_hyst)
-			continue;
 		snprintf(tz->trip_hyst_attrs[indx].name, THERMAL_NAME_LENGTH,
 			 "trip_point_%d_hyst", indx);
 
@@ -514,8 +508,7 @@ static void destroy_trip_attrs(struct thermal_zone_device *tz)
 
 	kfree(tz->trip_type_attrs);
 	kfree(tz->trip_temp_attrs);
-	if (tz->ops->get_trip_hyst)
-		kfree(tz->trip_hyst_attrs);
+	kfree(tz->trip_hyst_attrs);
 	kfree(tz->trips_attribute_group.attrs);
 }
 
-- 
2.34.1

