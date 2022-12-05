Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765BB642B9A
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbiLEP0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiLEPZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:25:53 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374A6C758
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e13so16208707edj.7
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4HNqla0eakUJHXR2NrtoGN8EbZpmoE91NN06afSM54=;
        b=f+ThbaeSP55AHdX4/h5wDUSBPSvLt0OYjzLuUbjWUfecbyz3gz6OM6L4TOenzCq8RA
         EKl5w+jFjQ71ngS1BzZpfU6zHMPcWCEltCdWS3PRa+CpP/PrHNpzprdiLN0yBx59IUai
         hG78Pr4yTS+xClPeLbul4C4oHHvWRORlVVEuWfe8+CgGKNNUO4ocV/YCg1JcJH166iby
         nSUoTSTP2zJaqfc5miUSCwKqgzUpOcKub2DBDqowxfv2O5GMonyEhQNOlkm5so8yHJ69
         XVOr2E2H3xWuM3ZvJAbh3BBJljfiJCavPab1QeuJchDzK8TXQ17MSvVNjEbB7RiX8lSW
         HP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j4HNqla0eakUJHXR2NrtoGN8EbZpmoE91NN06afSM54=;
        b=AykRvAR8nQEUkvwyNRlvBOvXNt6vS8TkPJKHiI2bHH5LEYNSpyuch/nz2iu3ktWJ8T
         1XMpQ/o0+xFiLFA4OGvEcWVLCV73h89bUwd+/igHl3/cE1dYX2s4GOn2Clx/O713wlqY
         uydzrmFwcr1j80MwwUcs4YMSB+Q2/5KF2Bs1j6snphb12uyyiARbvLIf2m4cKukFAsVc
         3ye4Z+s9ckDZbcx3ohx+QkFyAccAbXaNP64ZnQmt+yYuI4rljpMry55sJxR/8yI0xaI8
         wJuj8tdfJoBvEhx2bpfHZF4oYdkSe8sYJHqDch8Oyemv69/QTXyJKY6/h+5o7+w8EOqU
         fokw==
X-Gm-Message-State: ANoB5pldoM7of20K9p7yu/gAZbWVWB1l+xjVry8c8MfbkQ3bs6hhovFk
        qLvrmj7f1zzKiJtLdlFJ6Os+Moq5OnTXFyR42jpiEQ==
X-Google-Smtp-Source: AA0mqf5UjQAMD4GmmDP0eh7elWXjEH4EDFmedQ/rNx4RB6duYRGjkiz4L9CEtl78qVSivFsKRT4s2g==
X-Received: by 2002:a05:6402:3212:b0:46c:76da:b58b with SMTP id g18-20020a056402321200b0046c76dab58bmr8065200eda.116.1670253785160;
        Mon, 05 Dec 2022 07:23:05 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kq16-20020a170906abd000b007c09da0d773sm778717ejb.100.2022.12.05.07.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:23:04 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 3/8] mlxsw: call devl_port_register/unregister() on registered instance
Date:   Mon,  5 Dec 2022 16:22:52 +0100
Message-Id: <20221205152257.454610-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Move the code so devl_port_register/unregister() are called only
then devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->v1:
- shortened patch subject
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 24 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 38 ++++++++++++++-----
 3 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a0a06e2eff82..9908fb0f2d8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2215,8 +2215,24 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 		devl_unlock(devlink);
 		devlink_register(devlink);
 	}
+
+	if (mlxsw_driver->ports_init) {
+		if (!reload)
+			devl_lock(devlink);
+		err = mlxsw_driver->ports_init(mlxsw_core);
+		if (!reload)
+			devl_unlock(devlink);
+		if (err)
+			goto err_driver_ports_init;
+	}
+
 	return 0;
 
+err_driver_ports_init:
+	if (!reload) {
+		devlink_unregister(devlink);
+		devl_lock(devlink);
+	}
 err_driver_init:
 	mlxsw_env_fini(mlxsw_core->env);
 err_env_init:
@@ -2284,6 +2300,14 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
+	if (mlxsw_core->driver->ports_fini) {
+		if (!reload)
+			devl_lock(devlink);
+		mlxsw_core->driver->ports_fini(mlxsw_core);
+		if (!reload)
+			devl_unlock(devlink);
+	}
+
 	if (!reload) {
 		devlink_unregister(devlink);
 		devl_lock(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e0a6fcbbcb19..a41ca92318e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -348,6 +348,8 @@ struct mlxsw_driver {
 		    const struct mlxsw_bus_info *mlxsw_bus_info,
 		    struct netlink_ext_ack *extack);
 	void (*fini)(struct mlxsw_core *mlxsw_core);
+	int (*ports_init)(struct mlxsw_core *mlxsw_core);
+	void (*ports_fini)(struct mlxsw_core *mlxsw_core);
 	int (*port_split)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			  unsigned int count, struct netlink_ext_ack *extack);
 	int (*port_unsplit)(struct mlxsw_core *mlxsw_core, u16 local_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f5b2d965d476..b216c7dd8419 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3251,16 +3251,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_sample_trigger_init;
 	}
 
-	err = mlxsw_sp_ports_create(mlxsw_sp);
-	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
-		goto err_ports_create;
-	}
-
 	return 0;
 
-err_ports_create:
-	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
 err_sample_trigger_init:
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 err_port_module_info_init:
@@ -3445,11 +3437,24 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
 
+static int mlxsw_sp_ports_init(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	int err;
+
+	err = mlxsw_sp_ports_create(mlxsw_sp);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
-	mlxsw_sp_ports_remove(mlxsw_sp);
 	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
@@ -3478,6 +3483,13 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_parsing_fini(mlxsw_sp);
 }
 
+static void mlxsw_sp_ports_fini(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+
+	mlxsw_sp_ports_remove(mlxsw_sp);
+}
+
 static const struct mlxsw_config_profile mlxsw_sp1_config_profile = {
 	.used_flood_mode                = 1,
 	.flood_mode                     = MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_CONTROLLED,
@@ -3934,6 +3946,8 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.fw_filename			= MLXSW_SP1_FW_FILENAME,
 	.init				= mlxsw_sp1_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
@@ -3971,6 +3985,8 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.fw_filename			= MLXSW_SP2_FW_FILENAME,
 	.init				= mlxsw_sp2_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
@@ -4010,6 +4026,8 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.fw_filename			= MLXSW_SP3_FW_FILENAME,
 	.init				= mlxsw_sp3_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
@@ -4047,6 +4065,8 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.priv_size			= sizeof(struct mlxsw_sp),
 	.init				= mlxsw_sp4_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
-- 
2.37.3

