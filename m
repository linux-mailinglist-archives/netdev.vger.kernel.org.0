Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD952D82F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfE2Irw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42271 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726557AbfE2Irs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A1AC321540;
        Wed, 29 May 2019 04:47:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ezPJuD2IHsBaiw7RxDYp32Nj6zTOXQz37WjO75rWHGU=; b=EjMX4iFG
        KErW2Eps7vfOW7/Gvlj+0n8WFNcP2yQ6CLWQuQAlX2HNr4FUGSf6BJvp7XhNFxTP
        TrWeMSiBCnmWhQVR54WMyohVdujaoctEIrIC3bkEh6lUneqiLj4dxRRO8UOomOed
        aAnMLyggoW13iE5xvjzdbqQUuvTKzdsY7k1UuXBy0h27iEHRUEqSAwgxd4JBTrcH
        bO2iW/0I5+le7bfuOmzX2lsDlBkHUzplzo9xSVowMAZeu50ME0pM6Ff4ossaWYfg
        1ZY64CCGFHmNPj1k0p6t9Tgeqa0+Efyew6kX5cuYNJdGNZj154neLq7bC4nrVvQ1
        qos1wVfKqC5rZQ==
X-ME-Sender: <xms:M0fuXDyW0i6h-chcFlybJx-HGmkuU0RkWnXFWi6W37qkv25a1YGGmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:M0fuXE7sUyqrQo2V1r20r5426D6WihP12HReuCjkSk1gP_NoZluGlQ>
    <xmx:M0fuXJ_eckv3wIPIgEyW-fGoRGo-tF7YYfyYibSORTBKN6AS_M3KGQ>
    <xmx:M0fuXOIbko-JkPCREIzzqRHp6mIDR9Q24R05MQgxHxnq51xdJxnCbg>
    <xmx:M0fuXPD7py7pWMBcipn4EcYgymRv-Ky6Nkp2sLGiBi0d7eOT65BAsw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F22D80061;
        Wed, 29 May 2019 04:47:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/8] mlxsw: core: Extend hwmon interface with inter-connect temperature attributes
Date:   Wed, 29 May 2019 11:47:20 +0300
Message-Id: <20190529084722.22719-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529084722.22719-1-idosch@idosch.org>
References: <20190529084722.22719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Add new attributes to hwmon object for exposing inter-connects temperature
input, highest, reset_history temperatures and label. Temperatures are read
from Management Temperature Register.
The number of inter-connect devices is read from Management General
Peripheral Information Register.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 101 +++++++++++++++++-
 1 file changed, 96 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 496dc904c5ed..8cd446856340 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -23,6 +23,14 @@ struct mlxsw_hwmon_attr {
 	char name[32];
 };
 
+static int mlxsw_hwmon_get_attr_index(int index, int count)
+{
+	if (index >= count)
+		return index % count + MLXSW_REG_MTMP_GBOX_INDEX_MIN;
+
+	return index;
+}
+
 struct mlxsw_hwmon {
 	struct mlxsw_core *core;
 	const struct mlxsw_bus_info *bus_info;
@@ -33,6 +41,7 @@ struct mlxsw_hwmon {
 	struct mlxsw_hwmon_attr hwmon_attrs[MLXSW_HWMON_ATTR_COUNT];
 	unsigned int attrs_count;
 	u8 sensor_count;
+	u8 module_sensor_count;
 };
 
 static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
@@ -44,10 +53,12 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	unsigned int temp;
+	int index;
 	int err;
 
-	mlxsw_reg_mtmp_pack(mtmp_pl, mlwsw_hwmon_attr->type_index,
-			    false, false);
+	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
+					   mlxsw_hwmon->module_sensor_count);
+	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
@@ -66,10 +77,12 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	unsigned int temp_max;
+	int index;
 	int err;
 
-	mlxsw_reg_mtmp_pack(mtmp_pl, mlwsw_hwmon_attr->type_index,
-			    false, false);
+	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
+					   mlxsw_hwmon->module_sensor_count);
+	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
@@ -88,6 +101,7 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	unsigned long val;
+	int index;
 	int err;
 
 	err = kstrtoul(buf, 10, &val);
@@ -96,7 +110,9 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 	if (val != 1)
 		return -EINVAL;
 
-	mlxsw_reg_mtmp_pack(mtmp_pl, mlwsw_hwmon_attr->type_index, true, true);
+	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
+					   mlxsw_hwmon->module_sensor_count);
+	mlxsw_reg_mtmp_pack(mtmp_pl, index, true, true);
 	err = mlxsw_reg_write(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to reset temp sensor history\n");
@@ -333,6 +349,20 @@ mlxsw_hwmon_module_temp_label_show(struct device *dev,
 		       mlwsw_hwmon_attr->type_index);
 }
 
+static ssize_t
+mlxsw_hwmon_gbox_temp_label_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
+	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	int index = mlwsw_hwmon_attr->type_index -
+		    mlxsw_hwmon->module_sensor_count + 1;
+
+	return sprintf(buf, "gearbox %03u\n", index);
+}
+
 enum mlxsw_hwmon_attr_type {
 	MLXSW_HWMON_ATTR_TYPE_TEMP,
 	MLXSW_HWMON_ATTR_TYPE_TEMP_MAX,
@@ -345,6 +375,7 @@ enum mlxsw_hwmon_attr_type {
 	MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_CRIT,
 	MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_EMERG,
 	MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_LABEL,
+	MLXSW_HWMON_ATTR_TYPE_TEMP_GBOX_LABEL,
 };
 
 static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
@@ -428,6 +459,13 @@ static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
 		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
 			 "temp%u_label", num + 1);
 		break;
+	case MLXSW_HWMON_ATTR_TYPE_TEMP_GBOX_LABEL:
+		mlxsw_hwmon_attr->dev_attr.show =
+			mlxsw_hwmon_gbox_temp_label_show;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0444;
+		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
+			 "temp%u_label", num + 1);
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -556,6 +594,54 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 				     index, index);
 		index++;
 	}
+	mlxsw_hwmon->module_sensor_count = index;
+
+	return 0;
+}
+
+static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
+{
+	int index, max_index, sensor_index;
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	u8 gbox_num;
+	int err;
+
+	mlxsw_reg_mgpir_pack(mgpir_pl);
+	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, NULL, NULL);
+	if (!gbox_num)
+		return 0;
+
+	index = mlxsw_hwmon->module_sensor_count;
+	max_index = mlxsw_hwmon->module_sensor_count + gbox_num;
+	while (index < max_index) {
+		sensor_index = index % mlxsw_hwmon->module_sensor_count +
+			       MLXSW_REG_MTMP_GBOX_INDEX_MIN;
+		mlxsw_reg_mtmp_pack(mtmp_pl, sensor_index, true, true);
+		err = mlxsw_reg_write(mlxsw_hwmon->core,
+				      MLXSW_REG(mtmp), mtmp_pl);
+		if (err) {
+			dev_err(mlxsw_hwmon->bus_info->dev, "Failed to setup temp sensor number %d\n",
+				sensor_index);
+			return err;
+		}
+		mlxsw_hwmon_attr_add(mlxsw_hwmon, MLXSW_HWMON_ATTR_TYPE_TEMP,
+				     index, index);
+		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+				     MLXSW_HWMON_ATTR_TYPE_TEMP_MAX, index,
+				     index);
+		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+				     MLXSW_HWMON_ATTR_TYPE_TEMP_RST, index,
+				     index);
+		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+				     MLXSW_HWMON_ATTR_TYPE_TEMP_GBOX_LABEL,
+				     index, index);
+		index++;
+	}
 
 	return 0;
 }
@@ -586,6 +672,10 @@ int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 	if (err)
 		goto err_temp_module_init;
 
+	err = mlxsw_hwmon_gearbox_init(mlxsw_hwmon);
+	if (err)
+		goto err_temp_gearbox_init;
+
 	mlxsw_hwmon->groups[0] = &mlxsw_hwmon->group;
 	mlxsw_hwmon->group.attrs = mlxsw_hwmon->attrs;
 
@@ -602,6 +692,7 @@ int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 	return 0;
 
 err_hwmon_register:
+err_temp_gearbox_init:
 err_temp_module_init:
 err_fans_init:
 err_temp_init:
-- 
2.20.1

