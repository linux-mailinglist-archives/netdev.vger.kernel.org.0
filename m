Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11449279F66
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgI0Hu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:57 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51251 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730492AbgI0Hu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8D5AD45A;
        Sun, 27 Sep 2020 03:50:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=G69fcuxjoNLIw1okzNJSDoCXVWaTNanC4NRFF6XTV3g=; b=lWU1qumL
        35PjlRiZ4NZ19kUgnoD08EzV0qyr/cEQKwZc0wreqvMnlSf97tRddMHvGFJjeIEP
        11Gcx68KahWIpiARVWGIsJVmp+o5Kkz2naIM0Wn8esODQ6BKogT4ZvyW/Lp9A/Q9
        YMEkeXwgYYJM1CKDsA7ZwkOP7MrPT6oWVy1nDVbTkL2v+YRmfl16jUbxDqkT9VpX
        iWe96rMAxsAX4ljVDBczn9upq+0Ooo3QomwLTigc+nog2FaBeXOFo/efe8butMkG
        dCalLAARr63rLWvVyljLDs2366GujkFNZ5wS8Higky4cLOJ/vgrmFIXU288hxb6H
        4ZbL/fgZJvQCmg==
X-ME-Sender: <xms:X0RwX1X8sPbmD9aXb9Bn95BS-6jsajytsPSaDkinjY8d3388vHfSfw>
    <xme:X0RwX1nqYaiHBgbJ__cmfhYrRn58w-obVXVbJcmD8noxQraYLAlS7uLL53sOeAKn2
    OkRKVcYMsy1fu4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:X0RwXxYWqdm4jKPGe5ZrB7HHkVW_XHfAvDsp0MVWe-2y4iASx_Iacg>
    <xmx:X0RwX4WXAUzWqMxSWTgq4Uf9yy4319OQzD4b3TYQK4H18UqNrzp4FA>
    <xmx:X0RwX_nFrgu6KnBIds7RBeVsPXDGCG-lZIwoyXB0YhG5CkMZ_cOsyA>
    <xmx:X0RwX9i2AnueowH_eWR9FehHTDA1ZSC8vlM2V-MDCbIQbWdjKwERCA>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 99EC33280059;
        Sun, 27 Sep 2020 03:50:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: Enable temperature event for all supported port module sensors
Date:   Sun, 27 Sep 2020 10:50:12 +0300
Message-Id: <20200927075015.1417714-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

MTWE (Management Temperature Warning Event) is triggered for sensors
whose temperature event enable bit is enabled in the MTMP register.

Enable events for all the modules that have a temperature sensor.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 99 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  8 ++
 2 files changed, 107 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 06c04175878b..63dd1fb58381 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -306,6 +306,99 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom);
 
+static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
+					    u8 module,
+					    bool *p_has_temp_sensor)
+{
+	char mtbr_pl[MLXSW_REG_MTBR_LEN];
+	u16 temp;
+	int err;
+
+	mlxsw_reg_mtbr_pack(mtbr_pl, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
+			    1);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mtbr), mtbr_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mtbr_temp_unpack(mtbr_pl, 0, &temp, NULL);
+
+	switch (temp) {
+	case MLXSW_REG_MTBR_BAD_SENS_INFO:
+	case MLXSW_REG_MTBR_NO_CONN:
+	case MLXSW_REG_MTBR_NO_TEMP_SENS:
+	case MLXSW_REG_MTBR_INDEX_NA:
+		*p_has_temp_sensor = false;
+		break;
+	default:
+		*p_has_temp_sensor = temp ? true : false;
+	}
+	return 0;
+}
+
+static int mlxsw_env_temp_event_set(struct mlxsw_core *mlxsw_core,
+				    u16 sensor_index, bool enable)
+{
+	char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
+	enum mlxsw_reg_mtmp_tee tee;
+	int err, threshold_hi;
+
+	mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, sensor_index);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err)
+		return err;
+
+	if (enable) {
+		err = mlxsw_env_module_temp_thresholds_get(mlxsw_core,
+							   sensor_index -
+							   MLXSW_REG_MTMP_MODULE_INDEX_MIN,
+							   SFP_TEMP_HIGH_WARN,
+							   &threshold_hi);
+		/* In case it is not possible to query the module's threshold,
+		 * use the default value.
+		 */
+		if (err)
+			threshold_hi = MLXSW_REG_MTMP_THRESH_HI;
+		else
+			/* mlxsw_env_module_temp_thresholds_get() multiplies
+			 * Celsius degrees by 1000 whereas MTMP expects
+			 * temperature in 0.125 Celsius degrees units.
+			 * Convert threshold_hi to correct units.
+			 */
+			threshold_hi = threshold_hi / 1000 * 8;
+
+		mlxsw_reg_mtmp_temperature_threshold_hi_set(mtmp_pl, threshold_hi);
+		mlxsw_reg_mtmp_temperature_threshold_lo_set(mtmp_pl, threshold_hi -
+							    MLXSW_REG_MTMP_HYSTERESIS_TEMP);
+	}
+	tee = enable ? MLXSW_REG_MTMP_TEE_GENERATE_EVENT : MLXSW_REG_MTMP_TEE_NO_EVENT;
+	mlxsw_reg_mtmp_tee_set(mtmp_pl, tee);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtmp), mtmp_pl);
+}
+
+static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core,
+					      u8 module_count)
+{
+	int i, err, sensor_index;
+	bool has_temp_sensor;
+
+	for (i = 0; i < module_count; i++) {
+		err = mlxsw_env_module_has_temp_sensor(mlxsw_core, i,
+						       &has_temp_sensor);
+		if (err)
+			return err;
+
+		if (!has_temp_sensor)
+			continue;
+
+		sensor_index = i + MLXSW_REG_MTMP_MODULE_INDEX_MIN;
+		err = mlxsw_env_temp_event_set(mlxsw_core, sensor_index, true);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static void mlxsw_env_mtwe_event_func(const struct mlxsw_reg_info *reg,
 				      char *mtwe_pl, void *priv)
 {
@@ -424,8 +517,14 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (err)
 		goto err_temp_warn_event_register;
 
+	err = mlxsw_env_module_temp_event_enable(mlxsw_core, env->module_count);
+	if (err)
+		goto err_temp_event_enable;
+
 	return 0;
 
+err_temp_event_enable:
+	mlxsw_env_temp_warn_event_unregister(env);
 err_temp_warn_event_register:
 	kfree(env);
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 827906c9fdeb..e8415589d4fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8516,6 +8516,13 @@ MLXSW_ITEM32(reg, mtmp, max_temperature, 0x08, 0, 16);
  * 2 - Generate single event
  * Access: RW
  */
+
+enum mlxsw_reg_mtmp_tee {
+	MLXSW_REG_MTMP_TEE_NO_EVENT,
+	MLXSW_REG_MTMP_TEE_GENERATE_EVENT,
+	MLXSW_REG_MTMP_TEE_GENERATE_SINGLE_EVENT,
+};
+
 MLXSW_ITEM32(reg, mtmp, tee, 0x0C, 30, 2);
 
 #define MLXSW_REG_MTMP_THRESH_HI 0x348	/* 105 Celsius */
@@ -8526,6 +8533,7 @@ MLXSW_ITEM32(reg, mtmp, tee, 0x0C, 30, 2);
  */
 MLXSW_ITEM32(reg, mtmp, temperature_threshold_hi, 0x0C, 0, 16);
 
+#define MLXSW_REG_MTMP_HYSTERESIS_TEMP 0x28 /* 5 Celsius */
 /* reg_mtmp_temperature_threshold_lo
  * Low threshold for Temperature Warning Event. In 0.125 Celsius.
  * Access: RW
-- 
2.26.2

