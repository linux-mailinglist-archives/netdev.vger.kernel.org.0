Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15E42138CE
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 12:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgGCKoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 06:44:13 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42184 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCKoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 06:44:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id BDDD92A63E7
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
To:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 3/3] thermal: Make thermal_zone_device_is_enabled() available to core only
Date:   Fri,  3 Jul 2020 12:43:54 +0200
Message-Id: <20200703104354.19657-4-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200703104354.19657-1-andrzej.p@collabora.com>
References: <20200703104354.19657-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is not needed by drivers.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_core.c | 1 -
 drivers/thermal/thermal_core.h | 2 ++
 include/linux/thermal.h        | 5 -----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index a61e91513584..052343c59b0a 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -519,7 +519,6 @@ int thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
 
 	return mode == THERMAL_DEVICE_ENABLED;
 }
-EXPORT_SYMBOL_GPL(thermal_zone_device_is_enabled);
 
 void thermal_zone_device_update(struct thermal_zone_device *tz,
 				enum thermal_notify_event event)
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index c95689586e19..b1464b3a21e2 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -166,4 +166,6 @@ of_thermal_get_trip_points(struct thermal_zone_device *tz)
 }
 #endif
 
+int thermal_zone_device_is_enabled(struct thermal_zone_device *tz);
+
 #endif /* __THERMAL_CORE_H__ */
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index b9efaa780d88..108251f23e5c 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -418,7 +418,6 @@ void thermal_cdev_update(struct thermal_cooling_device *);
 void thermal_notify_framework(struct thermal_zone_device *, int);
 int thermal_zone_device_enable(struct thermal_zone_device *tz);
 int thermal_zone_device_disable(struct thermal_zone_device *tz);
-int thermal_zone_device_is_enabled(struct thermal_zone_device *tz);
 #else
 static inline struct thermal_zone_device *thermal_zone_device_register(
 	const char *type, int trips, int mask, void *devdata,
@@ -472,10 +471,6 @@ static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
 
 static inline int thermal_zone_device_disable(struct thermal_zone_device *tz)
 { return -ENODEV; }
-
-static inline int
-thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
-{ return -ENODEV; }
 #endif /* CONFIG_THERMAL */
 
 #endif /* __THERMAL_H__ */
-- 
2.17.1

