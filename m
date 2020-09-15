Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC126A11A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgIOIl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:41:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59837 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgIOIlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 16BF15C00F9;
        Tue, 15 Sep 2020 04:41:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=L0TMQZkTcD0Z1U896ZUya8MSGZiSiZIeoB/f2QZR50o=; b=O7r+8wXU
        P4uU9t05l6eAH1rBSpp7oHk2XSvkmphol+cANU1LupSYcGU0G1WQXz0YxCUL3wAD
        y+GA6UVHFZPZvcqwdnr1oNVpGt8BiOlbxpQ49i6pF4AMgrtUR/YIKMH1x7sbfdm0
        b/OFmFNOqivJWX7aoi+Jao8kHVkDHLoJWzmCAAGLfyYtyGkoLYVqNI2vvZzik+Ky
        HaoPMO7r8vvw73KkYotxsE1mwpQCwOmurKUhJB34OUHzHs7maVRCQ4i0AgwuUkvS
        3zS9uId16G0dyobpThUuRoKhj7Bb10eJIpWFmlT0x8T4oCSVwS58fV5jQbAG0Mnz
        h48L7QaxPedSDg==
X-ME-Sender: <xms:S35gX14mTynqYccOT9ofoSeRYh9W0sM_2rk9fiv8qJ7Q8BozmURmJA>
    <xme:S35gXy7myd3MKxDpqGymEt-sh66jLAYR_3fZlL9vmBGQQeXjzi9UK2L9j9M0Ix0yk
    Bveagta06ERT9I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:S35gX8etjOFSCr6V94YK7aXE-srRERtjL3ybLxyX8MfeVVzsCy_b0Q>
    <xmx:S35gX-IzXne0vWYTeHsgzUN5HfRQfiBkjjk00zPRsM-ETD7px67qjQ>
    <xmx:S35gX5LnVIKfte6L5Ru4kB-Yv_0PEmdOJwOdfRE314rI315xalyEXA>
    <xmx:TH5gXwWVqmt-YMrskEBV5aZCxoeEXrTagGN-iC4cQPhnOvwYRIn79Q>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3EE833064674;
        Tue, 15 Sep 2020 04:41:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: core: Push code doing params register/unregister into separate helpers
Date:   Tue, 15 Sep 2020 11:40:53 +0300
Message-Id: <20200915084058.18555-4-idosch@idosch.org>
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

Extract the code calling params register/unregister driver ops into
separate functions. Call publish/unpublish unconditionally.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 39 +++++++++++++++-------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index fa892e3cd6f9..a530f4ba033a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1545,6 +1545,24 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 	.trap_policer_counter_get	= mlxsw_devlink_trap_policer_counter_get,
 };
 
+static int mlxsw_core_params_register(struct mlxsw_core *mlxsw_core)
+{
+	int err;
+
+	if (mlxsw_core->driver->params_register) {
+		err = mlxsw_core->driver->params_register(mlxsw_core);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static void mlxsw_core_params_unregister(struct mlxsw_core *mlxsw_core)
+{
+	if (mlxsw_core->driver->params_register)
+		mlxsw_core->driver->params_unregister(mlxsw_core);
+}
+
 static int
 __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 				 const struct mlxsw_bus *mlxsw_bus,
@@ -1617,8 +1635,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_devlink_register;
 	}
 
-	if (mlxsw_driver->params_register && !reload) {
-		err = mlxsw_driver->params_register(mlxsw_core);
+	if (!reload) {
+		err = mlxsw_core_params_register(mlxsw_core);
 		if (err)
 			goto err_register_params;
 	}
@@ -1643,8 +1661,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->params_register)
-		devlink_params_publish(devlink);
+	devlink_params_publish(devlink);
 
 	if (!reload)
 		devlink_reload_enable(devlink);
@@ -1658,8 +1675,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 		mlxsw_core->driver->fini(mlxsw_core);
 err_driver_init:
 err_fw_rev_validate:
-	if (mlxsw_driver->params_unregister && !reload)
-		mlxsw_driver->params_unregister(mlxsw_core);
+	if (!reload)
+		mlxsw_core_params_unregister(mlxsw_core);
 err_register_params:
 	if (!reload)
 		devlink_unregister(devlink);
@@ -1724,14 +1741,13 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 			return;
 	}
 
-	if (mlxsw_core->driver->params_unregister)
-		devlink_params_unpublish(devlink);
+	devlink_params_unpublish(devlink);
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
 	if (mlxsw_core->driver->fini)
 		mlxsw_core->driver->fini(mlxsw_core);
-	if (mlxsw_core->driver->params_unregister && !reload)
-		mlxsw_core->driver->params_unregister(mlxsw_core);
+	if (!reload)
+		mlxsw_core_params_unregister(mlxsw_core);
 	if (!reload)
 		devlink_unregister(devlink);
 	mlxsw_emad_fini(mlxsw_core);
@@ -1744,8 +1760,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	return;
 
 reload_fail_deinit:
-	if (mlxsw_core->driver->params_unregister)
-		mlxsw_core->driver->params_unregister(mlxsw_core);
+	mlxsw_core_params_unregister(mlxsw_core);
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	devlink_free(devlink);
-- 
2.26.2

