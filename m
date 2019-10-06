Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA42ECCF00
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfJFGfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:35:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40023 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726225AbfJFGfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:35:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D92A72102F;
        Sun,  6 Oct 2019 02:35:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Oct 2019 02:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=XlBM3qc/rNsNZUUMvkIBTJQdDxSRNoHNF0PJEFJMAjI=; b=db68E7gc
        Pb4UM6B/fSNxD/qoG723GXqdODzaIdZqNfXNunok82wMrs73v1+Rj9lkoBtyHaCC
        /5BxWjRj04FVHfiPsXAc4kGkyfE+UwRGm0VmPVl2mVmtqP7ZLedL3cDHJSp9e8OW
        5L9UJcTm4Cyu4boGHMDoDRSVtAxV0mvmjsY9PocmFA7EAdX2oMRklVup+gan8sam
        /hYt50zZsGusfdyWepqnZu+Rql5ZG9fo02vPJycqlcHl1SSNHZM62HzGLUbDkDm4
        2qHaQn63qaYYJkgdpnpymls+9FrticjE4E8IgBdfjLC2UwJ8HWxywHqEarnLzA1+
        ibFbi6ySNEK12Q==
X-ME-Sender: <xms:KYuZXTzgbmYhvIE0pElCbaZWkkX3qpf06Q2Mc_cSoZdnL396h2a7lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheeggdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:KYuZXcyLnH8E_DPXBrackxUzoUZe4HFpt05sW-WeZdFWc5RNhV-dDw>
    <xmx:KYuZXdaKZvgYybQKZcD06AOyOBGvpXQhRNU3lOCDYeTc5zzqKWD17g>
    <xmx:KYuZXdW6qXkLc-ODO135cD0oSaJR2k2mn6bAg-x9b7RNE4QTK3XTzg>
    <xmx:KYuZXajT3lPx7clqzBqpSmJ6XWHT4hgKEsE2pfUxRbhYMuevqGCL9A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A110AD60057;
        Sun,  6 Oct 2019 02:35:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] mlxsw: thermal: Provide optimization for QSFP modules number detection
Date:   Sun,  6 Oct 2019 09:34:50 +0300
Message-Id: <20191006063452.7666-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006063452.7666-1-idosch@idosch.org>
References: <20191006063452.7666-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Use new field "num_of_modules" of MGPIR register for "thermal" interface
in order to get the number of modules supported by system directly from
the system configuration, instead of getting it from port to module
mapping info.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 37 ++++++++-----------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index b2c76a95f671..c721b171bd8d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -112,6 +112,7 @@ struct mlxsw_thermal {
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
 	enum thermal_device_mode mode;
 	struct mlxsw_thermal_module *tz_module_arr;
+	u8 tz_module_num;
 	struct mlxsw_thermal_module *tz_gearbox_arr;
 	u8 tz_gearbox_num;
 	unsigned int tz_highest_score;
@@ -775,23 +776,10 @@ static void mlxsw_thermal_module_tz_fini(struct thermal_zone_device *tzdev)
 
 static int
 mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
-			  struct mlxsw_thermal *thermal, u8 local_port)
+			  struct mlxsw_thermal *thermal, u8 module)
 {
 	struct mlxsw_thermal_module *module_tz;
-	char pmlp_pl[MLXSW_REG_PMLP_LEN];
-	u8 width, module;
-	int err;
-
-	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
-	err = mlxsw_reg_query(core, MLXSW_REG(pmlp), pmlp_pl);
-	if (err)
-		return err;
 
-	width = mlxsw_reg_pmlp_width_get(pmlp_pl);
-	if (!width)
-		return 0;
-
-	module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
 	module_tz = &thermal->tz_module_arr[module];
 	/* Skip if parent is already set (case of port split). */
 	if (module_tz->parent)
@@ -819,26 +807,34 @@ static int
 mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 			   struct mlxsw_thermal *thermal)
 {
-	unsigned int module_count = mlxsw_core_max_ports(core);
 	struct mlxsw_thermal_module *module_tz;
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	int i, err;
 
 	if (!mlxsw_core_res_query_enabled(core))
 		return 0;
 
-	thermal->tz_module_arr = kcalloc(module_count,
+	mlxsw_reg_mgpir_pack(mgpir_pl);
+	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL,
+			       &thermal->tz_module_num);
+
+	thermal->tz_module_arr = kcalloc(thermal->tz_module_num,
 					 sizeof(*thermal->tz_module_arr),
 					 GFP_KERNEL);
 	if (!thermal->tz_module_arr)
 		return -ENOMEM;
 
-	for (i = 1; i < module_count; i++) {
+	for (i = 0; i < thermal->tz_module_num; i++) {
 		err = mlxsw_thermal_module_init(dev, core, thermal, i);
 		if (err)
 			goto err_unreg_tz_module_arr;
 	}
 
-	for (i = 0; i < module_count - 1; i++) {
+	for (i = 0; i < thermal->tz_module_num; i++) {
 		module_tz = &thermal->tz_module_arr[i];
 		if (!module_tz->parent)
 			continue;
@@ -850,7 +846,7 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 	return 0;
 
 err_unreg_tz_module_arr:
-	for (i = module_count - 1; i >= 0; i--)
+	for (i = thermal->tz_module_num - 1; i >= 0; i--)
 		mlxsw_thermal_module_fini(&thermal->tz_module_arr[i]);
 	kfree(thermal->tz_module_arr);
 	return err;
@@ -859,13 +855,12 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 static void
 mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal)
 {
-	unsigned int module_count = mlxsw_core_max_ports(thermal->core);
 	int i;
 
 	if (!mlxsw_core_res_query_enabled(thermal->core))
 		return;
 
-	for (i = module_count - 1; i >= 0; i--)
+	for (i = thermal->tz_module_num - 1; i >= 0; i--)
 		mlxsw_thermal_module_fini(&thermal->tz_module_arr[i]);
 	kfree(thermal->tz_module_arr);
 }
-- 
2.21.0

