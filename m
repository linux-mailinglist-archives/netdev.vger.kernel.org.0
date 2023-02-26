Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752496A351B
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 23:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBZW42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 17:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjBZWzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 17:55:53 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5591A66A
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 14:55:28 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bw19so4377927wrb.13
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 14:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dexA46MbFD/1LJf//eW76xTgHB+gKrlRAfZ8jnkaOvM=;
        b=OHQGVxYUDNZxeRnZqcRN+uMUSgX2YZfaD26tyEg/q5/y5/W8rIqtESjkMaDxMvTyXM
         14fXI+DfYB1jlOG85VuFrAvlgnZnGQzr3a+bCM025odzMOonRnE0+5erpzWFbT4beu1O
         uFy6JmlEH8UqFlEgmgLJulXxxEu2M7bXfEDcMOa8SYeqTJXe07+SeHPQaWW8NfompTht
         vlrsbABafmS0ubMqA0WJ+IQzOLnyqAGxcxQgbf0x7Bw5iybB0k0HSE+JYdGnFSumzUYO
         u7gZmzF4hWOi3QiL+4/5p1eCUxVvfeVNa/zOgO15PdO5qpcmFAYqGJwWccswC8JHnBIa
         IO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dexA46MbFD/1LJf//eW76xTgHB+gKrlRAfZ8jnkaOvM=;
        b=b32B4A8Dr8DeGR8+JpSWti/zxXtaoHJh9vPTrwJKrICwq+ti1zTydZwgxvaGvNWC82
         ANUPWs1nPD7SCYSaiZM0TfppdxkbNR3Lf7sOdX+DLeXoxIuZOcW8GC4Q/9CB2T+KpQp9
         s2XCxr1SStWXy0+gn+hkWlL5a1P39tT71sN6HUR4jAh2EEi4biYvASFr7DqAJZuI+ODA
         Ez0s4TFVW9fbQaf6UYywtRcRrBMpmhA70Cj6/d2bMMgm4An2Qdy1W978tlcrXLndf7ec
         UKwx5yD4FaheqoW4ELzkzZd9BF79ByKWICr81MAcHOX18HwwK4V7wnyX1JfD+8edhZ5J
         g+6g==
X-Gm-Message-State: AO0yUKU98IMiDZFZOkwqJhWgD97R5nG+Bp5OXtNOBYFCo/+Ovp3jyl8r
        Z/1fIdT2xOtl7ZAiCZfQ5ne7jg==
X-Google-Smtp-Source: AK7set9HlGkC9SZA4cKWEzZ4LPrqJg0BCucqxyFxYbvbS4WkLoFy2G2Zb56PXu9VcB3ZfJBDVcTVvg==
X-Received: by 2002:adf:ed0b:0:b0:2c7:1e16:57cf with SMTP id a11-20020adfed0b000000b002c71e1657cfmr7898234wro.67.1677452115247;
        Sun, 26 Feb 2023 14:55:15 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:8baa:6b32:391b:62de])
        by smtp.gmail.com with ESMTPSA id d10-20020a05600c3aca00b003eb369abd92sm6138074wms.2.2023.02.26.14.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:55:14 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     rafael@kernel.org, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Balsam CHIHI <bchihi@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET SWITCH DRIVERS),
        linux-omap@vger.kernel.org (open list:TI BANDGAP AND THERMAL DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v3 13/20] thermal: Use thermal_zone_device_type() accessor
Date:   Sun, 26 Feb 2023 23:53:59 +0100
Message-Id: <20230226225406.979703-14-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226225406.979703-1-daniel.lezcano@linaro.org>
References: <20230226225406.979703-1-daniel.lezcano@linaro.org>
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

Replace the accesses to 'tz->type' by its accessor version in order to
self-encapsulate the thermal_zone_device structure.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com> #mlxsw
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com> #MediaTek LVTS
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 2 +-
 drivers/thermal/mediatek/lvts_thermal.c            | 6 ++++--
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 722e4a40afef..b0a169e68df9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -177,7 +177,7 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 
 	if (crit_temp > emerg_temp) {
 		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
-			 tz->tzdev->type, crit_temp, emerg_temp);
+			 thermal_zone_device_type(tz->tzdev), crit_temp, emerg_temp);
 		return 0;
 	}
 
diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index beb835d644e2..216f53eb1385 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -305,7 +305,8 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 * 14-0 : Raw temperature for threshold
 	 */
 	if (low != -INT_MAX) {
-		pr_debug("%s: Setting low limit temperature interrupt: %d\n", tz->type, low);
+		pr_debug("%s: Setting low limit temperature interrupt: %d\n",
+			 thermal_zone_device_type(tz), low);
 		writel(raw_low, LVTS_H2NTHRE(base));
 	}
 
@@ -318,7 +319,8 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 *
 	 * 14-0 : Raw temperature for threshold
 	 */
-	pr_debug("%s: Setting high limit temperature interrupt: %d\n", tz->type, high);
+	pr_debug("%s: Setting high limit temperature interrupt: %d\n",
+		 thermal_zone_device_type(tz), high);
 	writel(raw_high, LVTS_HTHRE(base));
 
 	return 0;
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 060f46cea5ff..0c8914017c18 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -44,7 +44,7 @@ static void ti_thermal_work(struct work_struct *work)
 	thermal_zone_device_update(data->ti_thermal, THERMAL_EVENT_UNSPECIFIED);
 
 	dev_dbg(data->bgp->dev, "updated thermal zone %s\n",
-		data->ti_thermal->type);
+		thermal_zone_device_type(data->ti_thermal));
 }
 
 /**
-- 
2.34.1

