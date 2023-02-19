Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8BD69C0DE
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 15:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjBSOjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 09:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjBSOig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 09:38:36 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B4F30F6
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 06:38:11 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id c17so334789wrx.0
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 06:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDzCeDjhe5THr9kYy7urFayWf0fqGV769f7YqEQHSUI=;
        b=Z8AUw1H7XELv4lEQit2NEoHxzkJGSQ9zsP1UD7S8vitx8spwRUH0oFv8bdDtDUB7q2
         SNRmLHoRxwEVKUl/VsrqK9RNCaH1gzMo9ynsfKIN7MspMhv2+OTXNw37ASDMyG5rXg2S
         E4Z8d+o6VcMFeBKRdCVTonKE+IY8nNVYPK2nknixLzkYkiwB0kOvd3pxmsL81HwsRRyQ
         FMb1mye/6YaO4vwnZKZHlVFKOf2bqSAxGetjMoXF4eR6pMEN9xUyRa8XwLBt76MGZ8Ix
         JC0hsXx6gJMOWvCqGmj33vrE4QmloGXxa3PKyoElUOscBWJHqe2D7w8dhVej9RVybn8O
         JXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BDzCeDjhe5THr9kYy7urFayWf0fqGV769f7YqEQHSUI=;
        b=KhgnC7vqYcDunqEZwIdKMI72zM+1rRpkC+4Dwl/yJ05dGAkQB2GYAx9Vv1GsCs3XSx
         tZt/iRMpX6il5NvbeHm8X+AVxOO1Dbn02etYoEHK6oulrel71R0OGJuw8tcpMtH7vABb
         Coo/msvazF4My0BB7b9QhH2CEM6Uy3Jx2PK+cMJvvkjUceV9sBeHmIKljNb8RgwldVE4
         ie4qIp/fCvfqP8tLtbiCKY8AhxQqM3Tm2v51fA6HMMyLWcAkCETgvsZgGqVDYDdjbygA
         0t3qKwlhOEgH8B3GLU/X1ElzY1rkCN6No36fONMb9VxMu9xxgm8ZMqJQ/VlQDYF/gmv9
         TYCA==
X-Gm-Message-State: AO0yUKWmcJ8Y/LN4c67kIcs6COoa3wOIIJzNIlmBeab5SzSyZfxhGzOv
        UnVye23YdvXdc8mgzLPiP4cOrg==
X-Google-Smtp-Source: AK7set9gOvB2cw69asE5RVyB9RUwaoIIbKR7PwzhRSmLV9VgO/U1+dASYDHK4cogBEzlHi+x69Yx6A==
X-Received: by 2002:adf:db01:0:b0:2c3:e07d:46cc with SMTP id s1-20020adfdb01000000b002c3e07d46ccmr1488574wri.41.1676817489911;
        Sun, 19 Feb 2023 06:38:09 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:6f43:b92:7670:463])
        by smtp.gmail.com with ESMTPSA id a18-20020adfe5d2000000b002be505ab59asm86176wrn.97.2023.02.19.06.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 06:38:09 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     rafael@kernel.org, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Amit Kucheria <amitk@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Balsam CHIHI <bchihi@baylibre.com>,
        linux-acpi@vger.kernel.org (open list:ACPI THERMAL DRIVER),
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET SWITCH DRIVERS),
        linux-omap@vger.kernel.org (open list:TI BANDGAP AND THERMAL DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v1 10/17] thermal: Do not access 'type' field, use the tz id instead
Date:   Sun, 19 Feb 2023 15:36:50 +0100
Message-Id: <20230219143657.241542-11-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219143657.241542-1-daniel.lezcano@linaro.org>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
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

The 'type' field is used as a name in the message. However we can have
multiple thermal zone with the same type. The information is not
accurate.

Moreover, the thermal zone device structure is directly accessed while
we want to improve the self-encapsulation of the code.

Replace the 'type' in the message by the thermal zone id.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/acpi/thermal.c                             | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 4 ++--
 drivers/thermal/mediatek/lvts_thermal.c            | 5 +----
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 4 ++--
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 69d0da6456d5..4b5afaf843e2 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -842,7 +842,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 		goto acpi_bus_detach;
 
 	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
-		 tz->thermal_zone->id);
+		 thermal_zone_device_get_id(tz->thermal_zone));
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 228b6ffaef98..8dbb1c15b842 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -176,8 +176,8 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	}
 
 	if (crit_temp > emerg_temp) {
-		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
-			 tz->tzdev->type, crit_temp, emerg_temp);
+		dev_warn(dev, "tz id %d: Critical threshold %d is above emergency threshold %d\n",
+			 thermal_zone_device_get_id(tz->tzdev), crit_temp, emerg_temp);
 		return 0;
 	}
 
diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index a65a81114cc5..90aab92a4185 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -304,10 +304,8 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 *
 	 * 14-0 : Raw temperature for threshold
 	 */
-	if (low != -INT_MAX) {
-		pr_debug("%s: Setting low limit temperature interrupt: %d\n", tz->type, low);
+	if (low != -INT_MAX)
 		writel(raw_low, LVTS_H2NTHRE(base));
-	}
 
 	/*
 	 * Hot temperature threshold
@@ -318,7 +316,6 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 *
 	 * 14-0 : Raw temperature for threshold
 	 */
-	pr_debug("%s: Setting high limit temperature interrupt: %d\n", tz->type, high);
 	writel(raw_high, LVTS_HTHRE(base));
 
 	return 0;
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 8586cfe92df6..eda6d3af7b67 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -43,8 +43,8 @@ static void ti_thermal_work(struct work_struct *work)
 
 	thermal_zone_device_update(data->ti_thermal, THERMAL_EVENT_UNSPECIFIED);
 
-	dev_dbg(data->bgp->dev, "updated thermal zone %s\n",
-		data->ti_thermal->type);
+	dev_dbg(data->bgp->dev, "updated thermal zone id %d\n",
+		thermal_zone_device_get_id(data->ti_thermal));
 }
 
 /**
-- 
2.34.1

