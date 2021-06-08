Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AB039F709
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhFHMqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:49 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53455 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232745AbhFHMqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 991F75C0148;
        Tue,  8 Jun 2021 08:44:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 08:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=IiCgTOPQcnef8vinMJ6HJft9ev1IIf2IuLQzdULISu0=; b=ZoYOd24P
        cDDiQwnezgEbZfHw7t14wuoAyKMOt5aApU4CB71dpHRnOTtGcSqcPlX5JVQldWQ3
        4ZlnpSOzCRTR7CQyAWOp/Kq2ZObW5iCrovIJuun+s+Icrv8QFm+3A8HrAAwlBEGo
        LfqNLd//UZp5dgVXAcVL4IVj/HR6N9zxUR7SoJGz9Q11zn7nNqiooSUaL4ebrz5I
        g1/tdr8YfT4EgPdp9rkJgdC2hXkSE5on3brCJAP+CWAcSfueneeSNwSNYp9I2mSd
        +hBCoHfASOZjBD/xUPRV1XDSiBGDjXwA/cRYxY1tmYQYBJZszYHDdV+R91+2HUjP
        85FV36TwRRV+Ug==
X-ME-Sender: <xms:RGa_YMUfx7Ocl9z4bVx4QCzgWynY6OgUD6Cn3H_4_SMQjQtvWYxoGg>
    <xme:RGa_YAmh5dmOqpxWTlTxwxKMHlfDVBFufSpoJ8SZeNMEUAOM5nz_McP5TLw88yyMg
    WKKnMBautvRNKc>
X-ME-Received: <xmr:RGa_YAb_H09b7N6Sqf7c6R32Pm82-HKEoF9vRqf4-3Fzk7wVEqigNerWA2pssDO86BOEhv9PYiauWk-TsF9gsxRCkxFWGOLtte1ZyC8o8vrYVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RGa_YLVlKgIlO-gLu9tmufJ5QD1zAyqkj30zY9Z2BTHkFaZHE1PuYw>
    <xmx:RGa_YGmwjfinQIUY9JPUU81jPOoOcx6H9NsDOIWEQUp3Z4wqzWcsjg>
    <xmx:RGa_YAcPhVAoDzzbXF7tcd_5CBF8ruuMz5Qfbq7oQ1u93KAXssXjfw>
    <xmx:RGa_YIV_DWmdy1FbqBEqmQ8678x9Yvuxtl9AxN7MOlvSKba-nVRUaA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: reg: Extend MTMP register with new threshold field
Date:   Tue,  8 Jun 2021 15:44:11 +0300
Message-Id: <20210608124414.1664294-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mykola Kostenok <c_mykolak@nvidia.com>

Extend Management Temperature (MTMP) register with new field specifying
the maximum temperature threshold.

Extend mlxsw_reg_mtmp_unpack() function with two extra arguments,
providing high and maximum temperature thresholds. For modules, these
thresholds correspond to critical and emergency thresholds that are read
from the module's EEPROM.

Signed-off-by: Mykola Kostenok <c_mykolak@nvidia.com>
Acked-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    |  2 +-
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  6 +++---
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  6 +++---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 20 ++++++++++++++++++-
 4 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index dd26865bd587..bcad1327d861 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -142,7 +142,7 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
 		return err;
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &module_temp, NULL, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &module_temp, NULL, NULL, NULL, NULL);
 	if (!module_temp) {
 		*temp = 0;
 		return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 2196c946698a..d41afdfbd085 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -72,7 +72,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
 		return err;
 	}
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
 	return sprintf(buf, "%d\n", temp);
 }
 
@@ -95,7 +95,7 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
 		return err;
 	}
-	mlxsw_reg_mtmp_unpack(mtmp_pl, NULL, &temp_max, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, NULL, &temp_max, NULL, NULL, NULL);
 	return sprintf(buf, "%d\n", temp_max);
 }
 
@@ -239,7 +239,7 @@ static int mlxsw_hwmon_module_temp_get(struct device *dev,
 		dev_err(dev, "Failed to query module temperature\n");
 		return err;
 	}
-	mlxsw_reg_mtmp_unpack(mtmp_pl, p_temp, NULL, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, p_temp, NULL, NULL, NULL, NULL);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 85f0ce285146..8d844d3c2e40 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -281,7 +281,7 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 		dev_err(dev, "Failed to query temp sensor\n");
 		return err;
 	}
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
 	if (temp > 0)
 		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal->trips,
 					      temp);
@@ -442,7 +442,7 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 		*p_temp = (int) temp;
 		return 0;
 	}
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
 	*p_temp = temp;
 
 	if (!temp)
@@ -560,7 +560,7 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 	if (err)
 		return err;
 
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
 	if (temp > 0)
 		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 8eff2fc21283..93f1db3927af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9463,6 +9463,14 @@ MLXSW_ITEM32(reg, mtmp, sensor_index, 0x00, 0, 12);
 					  ((s16)((GENMASK(15, 0) + (v_) + 1) \
 					   * 125)); })
 
+/* reg_mtmp_max_operational_temperature
+ * The highest temperature in the nominal operational range. Reading is in
+ * 0.125 Celsius degrees units.
+ * In case of module this is SFF critical temperature threshold.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mtmp, max_operational_temperature, 0x04, 16, 16);
+
 /* reg_mtmp_temperature
  * Temperature reading from the sensor. Reading is in 0.125 Celsius
  * degrees units.
@@ -9541,7 +9549,9 @@ static inline void mlxsw_reg_mtmp_pack(char *payload, u16 sensor_index,
 }
 
 static inline void mlxsw_reg_mtmp_unpack(char *payload, int *p_temp,
-					 int *p_max_temp, char *sensor_name)
+					 int *p_max_temp, int *p_temp_hi,
+					 int *p_max_oper_temp,
+					 char *sensor_name)
 {
 	s16 temp;
 
@@ -9553,6 +9563,14 @@ static inline void mlxsw_reg_mtmp_unpack(char *payload, int *p_temp,
 		temp = mlxsw_reg_mtmp_max_temperature_get(payload);
 		*p_max_temp = MLXSW_REG_MTMP_TEMP_TO_MC(temp);
 	}
+	if (p_temp_hi) {
+		temp = mlxsw_reg_mtmp_temperature_threshold_hi_get(payload);
+		*p_temp_hi = MLXSW_REG_MTMP_TEMP_TO_MC(temp);
+	}
+	if (p_max_oper_temp) {
+		temp = mlxsw_reg_mtmp_max_operational_temperature_get(payload);
+		*p_max_oper_temp = MLXSW_REG_MTMP_TEMP_TO_MC(temp);
+	}
 	if (sensor_name)
 		mlxsw_reg_mtmp_sensor_name_memcpy_from(payload, sensor_name);
 }
-- 
2.31.1

