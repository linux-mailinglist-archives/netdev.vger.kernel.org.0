Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03D840C36D
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhIOKOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:14:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43819 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237427AbhIOKOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 85C5A5C0198;
        Wed, 15 Sep 2021 06:13:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Sep 2021 06:13:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Favshbg968JUDb6W47PyI5ofkx0yND+80r/OkjI0cEY=; b=s9+aJ7qC
        Z4g0SiNQQQjksnJTfqDKg+x77fOLT4qgGLVEmYiK2tGq4EiNkpnn1oxOcce4I0kx
        aO22Ci2hU+lpPDqKa+otOax5nB4ZsHNB82dvsOBotyDHdZBsutdSkYdHKbSeCmxR
        S5eBLg4Jfx5ST6l5MZbivLS9Oz9GbQtc6x9traE+DH2iLakCQNS0sZNjz3JUv6cC
        GtNPNfgMRAiDEKcXvzj40I8AWcQXDs/Fxy5xDZKQYNHOOBC+oBn+vZPhl+2Ywokz
        Yj5naVqDHXeyJXUpJhXAPJhMA19hK3aBmasdo1F3MsTPIjEVK2jajawCjY10xp9R
        mZIJHqwYYzzr/Q==
X-ME-Sender: <xms:SsdBYZZACVgd6VeiF9X6lG-051VWeJ33skLAsWkBIs_zrZHDAxfz4A>
    <xme:SsdBYQZgNbL2RDsaY0aSB9sUCydhKmeZAnCfqVYRA-zmGCH7TWUJ22o2jw-F2uXYQ
    KFHN6d1d5vjHHM>
X-ME-Received: <xmr:SsdBYb-e54W90Xw8rQZcHojRdI9Hf0P3bDAQRj6oO7aNoGGLLb4RmnWZVPhe3rZxspfbgCVbFlRpRZIeJtlEM_yISot5zmiY4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:SsdBYXqdNVvl5fFJQ3JpxIkNh3tFDCa-5h3BCKytE2i0xAXe02GSFg>
    <xmx:SsdBYUptCzaa6ggWwuSomf3nyBMRHyiVnjM0jB1Rg3zVog5dYmZ-Pw>
    <xmx:SsdBYdSgLLSfcco38rzS7h7Bs-0lXGl-Smj5ftTxAfavGRM6WIQpxw>
    <xmx:SsdBYZC1fSGuKpJQyXdGH_rT_jiMzmk-BbsJu1M62P4Q9S8eBzfPqA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: core: Remove mlxsw_core_is_initialized()
Date:   Wed, 15 Sep 2021 13:13:06 +0300
Message-Id: <20210915101314.407476-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

After the previous patch, the switch driver is always initialized last,
making this function redundant.

Remove it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 8 --------
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 1 -
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 6 ------
 3 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 44803746ded5..8c634976ca77 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -90,7 +90,6 @@ struct mlxsw_core {
 		struct devlink_health_reporter *fw_fatal;
 	} health;
 	struct mlxsw_env *env;
-	bool is_initialized; /* Denotes if core was already initialized. */
 	unsigned long driver_priv[];
 	/* driver_priv has to be always the last item */
 };
@@ -2014,7 +2013,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_driver_init;
 	}
 
-	mlxsw_core->is_initialized = true;
 	devlink_params_publish(devlink);
 
 	if (!reload)
@@ -2099,7 +2097,6 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	}
 
 	devlink_params_unpublish(devlink);
-	mlxsw_core->is_initialized = false;
 	if (mlxsw_core->driver->fini)
 		mlxsw_core->driver->fini(mlxsw_core);
 	mlxsw_env_fini(mlxsw_core->env);
@@ -2938,11 +2935,6 @@ struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core)
 	return mlxsw_core->env;
 }
 
-bool mlxsw_core_is_initialized(const struct mlxsw_core *mlxsw_core)
-{
-	return mlxsw_core->is_initialized;
-}
-
 static void mlxsw_core_buf_dump_dbg(struct mlxsw_core *mlxsw_core,
 				    const char *buf, size_t size)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index d21981cc04ca..12023a550007 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -249,7 +249,6 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u8 local_port);
 bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u8 local_port);
 struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core);
-bool mlxsw_core_is_initialized(const struct mlxsw_core *mlxsw_core);
 
 int mlxsw_core_schedule_dw(struct delayed_work *dwork, unsigned long delay);
 bool mlxsw_core_schedule_work(struct work_struct *work);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 3713c45cfa1e..27e721f96b3b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -667,12 +667,6 @@ mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
-	/* Prevent switch driver from accessing uninitialized data. */
-	if (!mlxsw_core_is_initialized(mlxsw_core)) {
-		*p_counter = 0;
-		return 0;
-	}
-
 	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
 		return -EINVAL;
 
-- 
2.31.1

