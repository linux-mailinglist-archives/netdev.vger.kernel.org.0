Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2B567B401
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbjAYOO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbjAYOOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:24 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB21559240
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:21 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qx13so47900234ejb.13
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRY0peVD3Y0PaTppiwn1zqiopatTJT3SdkvKEwb1Etc=;
        b=HN7T19fL2ckr7iDGEdXl4P1O3gfV0vRov058hUjZG86SwiuFvxeMaFgaFRR/E35AJC
         JIvNpshyx2ZF5o0XHijRo45JJTJCV0NS1fGrFc7FKEOdxHgCfjg4l51dZTe2CEMgWC5P
         K59beAqlbKfvnJ77mtxqRQ8mNqO+SeNkyEolWWDbifjKj/7Bqagl+ljkID7cRRDdevgC
         UKUpLFOiAO+1BQK9oCG1nUmlbDGHwCnCwxuQs7toOrD6qs0P4FNxilxxynVMko8+aGMZ
         EKaUiMO8FJ4cMGX64fKkbiPyMFoVb36ibdikTM/bUyQdobjsbmN1y5PlvNRegWjNfVZd
         93kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRY0peVD3Y0PaTppiwn1zqiopatTJT3SdkvKEwb1Etc=;
        b=a33jtopcgM9JzChPJMathWXzAuh8AT3U5iU68LtSBPkY1EyE55B2TzKXBwLu3KmLg3
         SvhEsqgHSwhjjeBazusHuoW/Qnyn/UQtyAXk9hUsmh7DV2ffZRENcBh5saV9xNF74oNO
         eFjjaBgUmQJDdxE0ZolPsgyWhj0PJ1GLy0Rl5oh2NE/aDZqvqMpsG+0D68d9L59wgt75
         6/7fsz5Jyh6ZiqAACUdQksVRwEOdmF/5EttRYFG3YUK3Fi7LRkBnfubFqCf2dtGopPv+
         cppudMgxFwRVedoWXujEUCnYcLw2IBcFLOvtFIE47XMkeNsFrejngCtkEpj9DZrbTCGv
         Z7pQ==
X-Gm-Message-State: AFqh2koeyFi9HJkFLMsUYQ/l2qV4xITbWadmnMp9CnBs3ySzl99W4f7G
        UCOjezxeReQPxax/7tZ4cPNcpkQe4SrJZ32uT80=
X-Google-Smtp-Source: AMrXdXsrsuEzzYeDFU+hFdNsN1CeNmOHsDwlNqkdZY3THIIwiyRicze4NpoMTqA30imVkLAVty81tA==
X-Received: by 2002:a17:906:7d5:b0:86d:9e43:e59 with SMTP id m21-20020a17090607d500b0086d9e430e59mr28146459ejc.39.1674656060153;
        Wed, 25 Jan 2023 06:14:20 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id my10-20020a1709065a4a00b0078d22b0bcf2sm2433155ejc.168.2023.01.25.06.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:19 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next 02/12] net/mlx5: Covert devlink params registration to use devlink_params_register/unregister()
Date:   Wed, 25 Jan 2023 15:14:02 +0100
Message-Id: <20230125141412.1592256-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
References: <20230125141412.1592256-1-jiri@resnulli.us>
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

Since mlx5 is the only user of devlink API to register/unregister a
single param, convert it to use array registration function allowing to
simplify the devlink API by removing the single param registration
functions.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 80 +++++++++++--------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 91847a3d03a2..2d2fcb518172 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -624,11 +624,12 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 					   value);
 }
 
-static const struct devlink_param enable_eth_param =
+static const struct devlink_param mlx5_devlink_eth_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_ETH, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, NULL);
+			      NULL, NULL, NULL),
+};
 
-static int mlx5_devlink_eth_param_register(struct devlink *devlink)
+static int mlx5_devlink_eth_params_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
@@ -637,7 +638,8 @@ static int mlx5_devlink_eth_param_register(struct devlink *devlink)
 	if (!mlx5_eth_supported(dev))
 		return 0;
 
-	err = devlink_param_register(devlink, &enable_eth_param);
+	err = devlink_params_register(devlink, mlx5_devlink_eth_params,
+				      ARRAY_SIZE(mlx5_devlink_eth_params));
 	if (err)
 		return err;
 
@@ -648,14 +650,15 @@ static int mlx5_devlink_eth_param_register(struct devlink *devlink)
 	return 0;
 }
 
-static void mlx5_devlink_eth_param_unregister(struct devlink *devlink)
+static void mlx5_devlink_eth_params_unregister(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
 	if (!mlx5_eth_supported(dev))
 		return;
 
-	devlink_param_unregister(devlink, &enable_eth_param);
+	devlink_params_unregister(devlink, mlx5_devlink_eth_params,
+				  ARRAY_SIZE(mlx5_devlink_eth_params));
 }
 
 static int mlx5_devlink_enable_rdma_validate(struct devlink *devlink, u32 id,
@@ -670,11 +673,12 @@ static int mlx5_devlink_enable_rdma_validate(struct devlink *devlink, u32 id,
 	return 0;
 }
 
-static const struct devlink_param enable_rdma_param =
+static const struct devlink_param mlx5_devlink_rdma_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_RDMA, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, mlx5_devlink_enable_rdma_validate);
+			      NULL, NULL, mlx5_devlink_enable_rdma_validate),
+};
 
-static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
+static int mlx5_devlink_rdma_params_register(struct devlink *devlink)
 {
 	union devlink_param_value value;
 	int err;
@@ -682,7 +686,8 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return 0;
 
-	err = devlink_param_register(devlink, &enable_rdma_param);
+	err = devlink_params_register(devlink, mlx5_devlink_rdma_params,
+				      ARRAY_SIZE(mlx5_devlink_rdma_params));
 	if (err)
 		return err;
 
@@ -693,19 +698,21 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 	return 0;
 }
 
-static void mlx5_devlink_rdma_param_unregister(struct devlink *devlink)
+static void mlx5_devlink_rdma_params_unregister(struct devlink *devlink)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return;
 
-	devlink_param_unregister(devlink, &enable_rdma_param);
+	devlink_params_unregister(devlink, mlx5_devlink_rdma_params,
+				  ARRAY_SIZE(mlx5_devlink_rdma_params));
 }
 
-static const struct devlink_param enable_vnet_param =
+static const struct devlink_param mlx5_devlink_vnet_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_VNET, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, NULL);
+			      NULL, NULL, NULL),
+};
 
-static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
+static int mlx5_devlink_vnet_params_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
@@ -714,7 +721,8 @@ static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
 	if (!mlx5_vnet_supported(dev))
 		return 0;
 
-	err = devlink_param_register(devlink, &enable_vnet_param);
+	err = devlink_params_register(devlink, mlx5_devlink_vnet_params,
+				      ARRAY_SIZE(mlx5_devlink_vnet_params));
 	if (err)
 		return err;
 
@@ -725,45 +733,46 @@ static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
 	return 0;
 }
 
-static void mlx5_devlink_vnet_param_unregister(struct devlink *devlink)
+static void mlx5_devlink_vnet_params_unregister(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
 	if (!mlx5_vnet_supported(dev))
 		return;
 
-	devlink_param_unregister(devlink, &enable_vnet_param);
+	devlink_params_unregister(devlink, mlx5_devlink_vnet_params,
+				  ARRAY_SIZE(mlx5_devlink_vnet_params));
 }
 
 static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
 {
 	int err;
 
-	err = mlx5_devlink_eth_param_register(devlink);
+	err = mlx5_devlink_eth_params_register(devlink);
 	if (err)
 		return err;
 
-	err = mlx5_devlink_rdma_param_register(devlink);
+	err = mlx5_devlink_rdma_params_register(devlink);
 	if (err)
 		goto rdma_err;
 
-	err = mlx5_devlink_vnet_param_register(devlink);
+	err = mlx5_devlink_vnet_params_register(devlink);
 	if (err)
 		goto vnet_err;
 	return 0;
 
 vnet_err:
-	mlx5_devlink_rdma_param_unregister(devlink);
+	mlx5_devlink_rdma_params_unregister(devlink);
 rdma_err:
-	mlx5_devlink_eth_param_unregister(devlink);
+	mlx5_devlink_eth_params_unregister(devlink);
 	return err;
 }
 
 static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
 {
-	mlx5_devlink_vnet_param_unregister(devlink);
-	mlx5_devlink_rdma_param_unregister(devlink);
-	mlx5_devlink_eth_param_unregister(devlink);
+	mlx5_devlink_vnet_params_unregister(devlink);
+	mlx5_devlink_rdma_params_unregister(devlink);
+	mlx5_devlink_eth_params_unregister(devlink);
 }
 
 static int mlx5_devlink_max_uc_list_validate(struct devlink *devlink, u32 id,
@@ -791,11 +800,12 @@ static int mlx5_devlink_max_uc_list_validate(struct devlink *devlink, u32 id,
 	return 0;
 }
 
-static const struct devlink_param max_uc_list_param =
+static const struct devlink_param mlx5_devlink_max_uc_list_params[] = {
 	DEVLINK_PARAM_GENERIC(MAX_MACS, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, mlx5_devlink_max_uc_list_validate);
+			      NULL, NULL, mlx5_devlink_max_uc_list_validate),
+};
 
-static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
+static int mlx5_devlink_max_uc_list_params_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
@@ -804,7 +814,8 @@ static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
 	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
 		return 0;
 
-	err = devlink_param_register(devlink, &max_uc_list_param);
+	err = devlink_params_register(devlink, mlx5_devlink_max_uc_list_params,
+				      ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
 	if (err)
 		return err;
 
@@ -816,14 +827,15 @@ static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
 }
 
 static void
-mlx5_devlink_max_uc_list_param_unregister(struct devlink *devlink)
+mlx5_devlink_max_uc_list_params_unregister(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
 	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
 		return;
 
-	devlink_param_unregister(devlink, &max_uc_list_param);
+	devlink_params_unregister(devlink, mlx5_devlink_max_uc_list_params,
+				  ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
 }
 
 #define MLX5_TRAP_DROP(_id, _group_id)					\
@@ -885,7 +897,7 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 	if (err)
 		goto auxdev_reg_err;
 
-	err = mlx5_devlink_max_uc_list_param_register(devlink);
+	err = mlx5_devlink_max_uc_list_params_register(devlink);
 	if (err)
 		goto max_uc_list_err;
 
@@ -904,7 +916,7 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 
 void mlx5_devlink_params_unregister(struct devlink *devlink)
 {
-	mlx5_devlink_max_uc_list_param_unregister(devlink);
+	mlx5_devlink_max_uc_list_params_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
-- 
2.39.0

