Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B42E26A113
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgIOIl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:41:59 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57969 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgIOIlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 25CF85C00EB;
        Tue, 15 Sep 2020 04:41:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sRLtRTPcrkYdtWhEGbdqi6esHRu1eijoHzReA5JOGr0=; b=Xa1K1nak
        SPLSsG9tZ5sGZR0RSY8I9xk+wzWqQsCQXgNuN+O5/xvrG/D+VIG65iE7dZgSn7Br
        NL0fKV5um/VfqbNVCngJ2eINJKDJsTUyrIJI6mUFO3+mZ9dgoEYlxVlQyBxgZjTZ
        O4UGVpP/xGC3tp4fTznay5tXdMVorgivywsKu+1bbhvXbB02V9zQhmweNeLgnstT
        Uy56xFbl1h8IWTd6h09SqxCKeRJRyQL3DEXr3iS9EMsTOMe864Lvv4PzpabxONLc
        JiUHiv9559Y28CBZcAj0yTtCReICUPvnViluGO8EfLvVda70gi57IIgaY96dtYEB
        A1IIuClmOGcOCQ==
X-ME-Sender: <xms:Tn5gX6D0SNzvdPLxTNCjQiXRhziqhUK0nqJv9S46nI11gX85zd8udQ>
    <xme:Tn5gX0gETuLHuXMVJfuv8FQq1IYIQ_S_w8xgrzS7Gd0Hd-uI2_AmHeM-3qD-G0ltZ
    XQDdiZbDCG9kYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Tn5gX9na0MxIB91X_-ter601W71kSscm2sh3DUyHhGMyDxdNJGgV5A>
    <xmx:Tn5gX4yQewz2WC3Y2NudtDbioT8bukp6toKW60D_aov_qLteRcnvRw>
    <xmx:Tn5gX_QXzjkW-bmSjNE9HGWTEf_ykJLKwzt7xezte8wMCPbSDTJ9eA>
    <xmx:Tn5gX6evgDNi5o2wnvtzrqHEE5iTJAFL8VU2ypYT8mXZhiOamfwlCw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A90E3064674;
        Tue, 15 Sep 2020 04:41:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: Move fw_load_policy devlink param into core.c
Date:   Tue, 15 Sep 2020 11:40:54 +0300
Message-Id: <20200915084058.18555-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As the fw flashing code was moved to core.c, move the param which is
related to it there as well. Remove unnecessary parentheses on the way.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 51 +++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 59 +------------------
 2 files changed, 51 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a530f4ba033a..7b5939e068d1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1117,6 +1117,46 @@ static int mlxsw_core_fw_flash_update(struct mlxsw_core *mlxsw_core,
 	return err;
 }
 
+static int mlxsw_core_devlink_param_fw_load_policy_validate(struct devlink *devlink, u32 id,
+							    union devlink_param_value val,
+							    struct netlink_ext_ack *extack)
+{
+	if (val.vu8 != DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER &&
+	    val.vu8 != DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH) {
+		NL_SET_ERR_MSG_MOD(extack, "'fw_load_policy' must be 'driver' or 'flash'");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param mlxsw_core_fw_devlink_params[] = {
+	DEVLINK_PARAM_GENERIC(FW_LOAD_POLICY, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT), NULL, NULL,
+			      mlxsw_core_devlink_param_fw_load_policy_validate),
+};
+
+static int mlxsw_core_fw_params_register(struct mlxsw_core *mlxsw_core)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	union devlink_param_value value;
+	int err;
+
+	err = devlink_params_register(devlink, mlxsw_core_fw_devlink_params,
+				      ARRAY_SIZE(mlxsw_core_fw_devlink_params));
+	if (err)
+		return err;
+
+	value.vu8 = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER;
+	devlink_param_driverinit_value_set(devlink, DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY, value);
+	return 0;
+}
+
+static void mlxsw_core_fw_params_unregister(struct mlxsw_core *mlxsw_core)
+{
+	devlink_params_unregister(priv_to_devlink(mlxsw_core), mlxsw_core_fw_devlink_params,
+				  ARRAY_SIZE(mlxsw_core_fw_devlink_params));
+}
+
 static int mlxsw_devlink_port_split(struct devlink *devlink,
 				    unsigned int port_index,
 				    unsigned int count,
@@ -1549,16 +1589,25 @@ static int mlxsw_core_params_register(struct mlxsw_core *mlxsw_core)
 {
 	int err;
 
+	err = mlxsw_core_fw_params_register(mlxsw_core);
+	if (err)
+		return err;
+
 	if (mlxsw_core->driver->params_register) {
 		err = mlxsw_core->driver->params_register(mlxsw_core);
 		if (err)
-			return err;
+			goto err_params_register;
 	}
 	return 0;
+
+err_params_register:
+	mlxsw_core_fw_params_unregister(mlxsw_core);
+	return err;
 }
 
 static void mlxsw_core_params_unregister(struct mlxsw_core *mlxsw_core)
 {
+	mlxsw_core_fw_params_unregister(mlxsw_core);
 	if (mlxsw_core->driver->params_register)
 		mlxsw_core->driver->params_unregister(mlxsw_core);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 75742db632e9..18d2eacfae83 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3186,52 +3186,6 @@ static int mlxsw_sp_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
-static int
-mlxsw_sp_devlink_param_fw_load_policy_validate(struct devlink *devlink, u32 id,
-					       union devlink_param_value val,
-					       struct netlink_ext_ack *extack)
-{
-	if ((val.vu8 != DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER) &&
-	    (val.vu8 != DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH)) {
-		NL_SET_ERR_MSG_MOD(extack, "'fw_load_policy' must be 'driver' or 'flash'");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static const struct devlink_param mlxsw_sp_devlink_params[] = {
-	DEVLINK_PARAM_GENERIC(FW_LOAD_POLICY,
-			      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL,
-			      mlxsw_sp_devlink_param_fw_load_policy_validate),
-};
-
-static int mlxsw_sp_params_register(struct mlxsw_core *mlxsw_core)
-{
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
-	union devlink_param_value value;
-	int err;
-
-	err = devlink_params_register(devlink, mlxsw_sp_devlink_params,
-				      ARRAY_SIZE(mlxsw_sp_devlink_params));
-	if (err)
-		return err;
-
-	value.vu8 = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
-					   value);
-	return 0;
-}
-
-static void mlxsw_sp_params_unregister(struct mlxsw_core *mlxsw_core)
-{
-	devlink_params_unregister(priv_to_devlink(mlxsw_core),
-				  mlxsw_sp_devlink_params,
-				  ARRAY_SIZE(mlxsw_sp_devlink_params));
-}
-
 static int
 mlxsw_sp_params_acl_region_rehash_intrvl_get(struct devlink *devlink, u32 id,
 					     struct devlink_param_gset_ctx *ctx)
@@ -3269,24 +3223,16 @@ static int mlxsw_sp2_params_register(struct mlxsw_core *mlxsw_core)
 	union devlink_param_value value;
 	int err;
 
-	err = mlxsw_sp_params_register(mlxsw_core);
-	if (err)
-		return err;
-
 	err = devlink_params_register(devlink, mlxsw_sp2_devlink_params,
 				      ARRAY_SIZE(mlxsw_sp2_devlink_params));
 	if (err)
-		goto err_devlink_params_register;
+		return err;
 
 	value.vu32 = 0;
 	devlink_param_driverinit_value_set(devlink,
 					   MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
 					   value);
 	return 0;
-
-err_devlink_params_register:
-	mlxsw_sp_params_unregister(mlxsw_core);
-	return err;
 }
 
 static void mlxsw_sp2_params_unregister(struct mlxsw_core *mlxsw_core)
@@ -3294,7 +3240,6 @@ static void mlxsw_sp2_params_unregister(struct mlxsw_core *mlxsw_core)
 	devlink_params_unregister(priv_to_devlink(mlxsw_core),
 				  mlxsw_sp2_devlink_params,
 				  ARRAY_SIZE(mlxsw_sp2_devlink_params));
-	mlxsw_sp_params_unregister(mlxsw_core);
 }
 
 static void mlxsw_sp_ptp_transmitted(struct mlxsw_core *mlxsw_core,
@@ -3338,8 +3283,6 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp1_resources_register,
 	.kvd_sizes_get			= mlxsw_sp_kvd_sizes_get,
-	.params_register		= mlxsw_sp_params_register,
-	.params_unregister		= mlxsw_sp_params_unregister,
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp1_config_profile,
-- 
2.26.2

