Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418E920D350
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgF2S5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbgF2S5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:57:44 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5BAC00F812;
        Mon, 29 Jun 2020 05:30:07 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id C716F2A2D98
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
Subject: [PATCH v7 11/11] thermal: Rename set_mode() to change_mode()
Date:   Mon, 29 Jun 2020 14:29:25 +0200
Message-Id: <20200629122925.21729-12-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629122925.21729-1-andrzej.p@collabora.com>
References: <20200629122925.21729-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

set_mode() is only called when tzd's mode is about to change. Actual
setting is performed in thermal_core, in thermal_zone_device_set_mode().
The meaning of set_mode() callback is actually to notify the driver about
the mode being changed and giving the driver a chance to oppose such
change.

To better reflect the purpose of the method rename it to change_mode()

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
[for acerhdf]
Acked-by: Peter Kaestle <peter@piie.net>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/platform/x86/acerhdf.c                          | 6 +++---
 drivers/thermal/imx_thermal.c                           | 8 ++++----
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 6 +++---
 drivers/thermal/intel/intel_quark_dts_thermal.c         | 6 +++---
 drivers/thermal/thermal_core.c                          | 4 ++--
 include/linux/thermal.h                                 | 2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 76323855c80c..f816a8a13039 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -413,8 +413,8 @@ static inline void acerhdf_enable_kernelmode(void)
  *          the temperature and the fan.
  * disabled: the BIOS takes control of the fan.
  */
-static int acerhdf_set_mode(struct thermal_zone_device *thermal,
-			    enum thermal_device_mode mode)
+static int acerhdf_change_mode(struct thermal_zone_device *thermal,
+			       enum thermal_device_mode mode)
 {
 	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
 		acerhdf_revert_to_bios_mode();
@@ -473,7 +473,7 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
 	.bind = acerhdf_bind,
 	.unbind = acerhdf_unbind,
 	.get_temp = acerhdf_get_ec_temp,
-	.set_mode = acerhdf_set_mode,
+	.change_mode = acerhdf_change_mode,
 	.get_trip_type = acerhdf_get_trip_type,
 	.get_trip_hyst = acerhdf_get_trip_hyst,
 	.get_trip_temp = acerhdf_get_trip_temp,
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index a02398118d88..9700ae39feb7 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -330,8 +330,8 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 	return 0;
 }
 
-static int imx_set_mode(struct thermal_zone_device *tz,
-			enum thermal_device_mode mode)
+static int imx_change_mode(struct thermal_zone_device *tz,
+			   enum thermal_device_mode mode)
 {
 	struct imx_thermal_data *data = tz->devdata;
 	struct regmap *map = data->tempmon;
@@ -447,7 +447,7 @@ static struct thermal_zone_device_ops imx_tz_ops = {
 	.bind = imx_bind,
 	.unbind = imx_unbind,
 	.get_temp = imx_get_temp,
-	.set_mode = imx_set_mode,
+	.change_mode = imx_change_mode,
 	.get_trip_type = imx_get_trip_type,
 	.get_trip_temp = imx_get_trip_temp,
 	.get_crit_temp = imx_get_crit_temp,
@@ -860,7 +860,7 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
 	 * Need to disable thermal sensor, otherwise, when thermal core
 	 * try to get temperature before thermal sensor resume, a wrong
 	 * temperature will be read as the thermal sensor is powered
-	 * down. This is done in set_mode() operation called from
+	 * down. This is done in change_mode() operation called from
 	 * thermal_zone_device_disable()
 	 */
 	ret = thermal_zone_device_disable(data->tz);
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index ce49d3b100d5..d3732f624913 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -377,8 +377,8 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
-				enum thermal_device_mode mode)
+static int int3400_thermal_change_mode(struct thermal_zone_device *thermal,
+				       enum thermal_device_mode mode)
 {
 	struct int3400_thermal_priv *priv = thermal->devdata;
 	int result = 0;
@@ -399,7 +399,7 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
 
 static struct thermal_zone_device_ops int3400_thermal_ops = {
 	.get_temp = int3400_thermal_get_temp,
-	.set_mode = int3400_thermal_set_mode,
+	.change_mode = int3400_thermal_change_mode,
 };
 
 static struct thermal_zone_params int3400_thermal_params = {
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index e29c3e330b17..3eafc6b0e6c3 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -298,8 +298,8 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
 	return 0;
 }
 
-static int sys_set_mode(struct thermal_zone_device *tzd,
-				enum thermal_device_mode mode)
+static int sys_change_mode(struct thermal_zone_device *tzd,
+			   enum thermal_device_mode mode)
 {
 	int ret;
 
@@ -319,7 +319,7 @@ static struct thermal_zone_device_ops tzone_ops = {
 	.get_trip_type = sys_get_trip_type,
 	.set_trip_temp = sys_set_trip_temp,
 	.get_crit_temp = sys_get_crit_temp,
-	.set_mode = sys_set_mode,
+	.change_mode = sys_change_mode,
 };
 
 static void free_soc_dts(struct soc_sensor_entry *aux_entry)
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index e613f5c07bad..a61e91513584 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -482,8 +482,8 @@ static int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
 		return ret;
 	}
 
-	if (tz->ops->set_mode)
-		ret = tz->ops->set_mode(tz, mode);
+	if (tz->ops->change_mode)
+		ret = tz->ops->change_mode(tz, mode);
 
 	if (!ret)
 		tz->mode = mode;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index df013c39ba9b..b9efaa780d88 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -76,7 +76,7 @@ struct thermal_zone_device_ops {
 		       struct thermal_cooling_device *);
 	int (*get_temp) (struct thermal_zone_device *, int *);
 	int (*set_trips) (struct thermal_zone_device *, int, int);
-	int (*set_mode) (struct thermal_zone_device *,
+	int (*change_mode) (struct thermal_zone_device *,
 		enum thermal_device_mode);
 	int (*get_trip_type) (struct thermal_zone_device *, int,
 		enum thermal_trip_type *);
-- 
2.17.1

