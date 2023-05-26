Return-Path: <netdev+bounces-5634-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5267124B5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BE771C20F46
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE221E534;
	Fri, 26 May 2023 10:29:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C951C764
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:29:01 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1371AFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:00 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30ac4e7f37bso312737f8f.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096938; x=1687688938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvHSM1U/Ik/DQAZsWMpTg8xLA9lNmPvHf6W0fcg5knA=;
        b=gzb8eVF8d2iFM87nUdfm6/HM3etc3LrhZ6xo5POFsl7JeKDc9R+f2TfCEInC/mEO/X
         80m5kUppyobuuqvTEhscS/dNdhBtwHTyHXI4qKVFFfqDDp2Ix1gLMCqdtlQnSnDipWEz
         BWd2Iq45xTDaypzztgfkG+LMf8WmV2SM1JxQHpO4xIbfzm/EoghBDBnHY6NR9owS+FAB
         /7YpFXzyy6oHEn7eTbboDkpcatfVApoeUkfxXsaWjYs6YwtFiNiJya3xLjsEjnVpkih2
         t/yU6UhQvXZ568vsO3/yN1soOq88lWwMO7DG9J/yFbAnJIdFi3wqPxOYLSIAUHfvebdZ
         jolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096938; x=1687688938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvHSM1U/Ik/DQAZsWMpTg8xLA9lNmPvHf6W0fcg5knA=;
        b=Wr/D4do7edr+fLDo6vDB32u1sJxT0i1GUyW7CdqzG5UIMyDLnDskQ9++qOMLKRW5Fp
         JvTeGxSIS4pdMaoRSpzgiQGwhULloXHFh/rQZ4YxUoN/TzWZ79PckfSh0A8fLOvNNaNH
         GSc+a5f8JcHbLbJ225qtJIPKeDOyvPYGfIqWzFR3Hlf8ZRFYbH1NlpkwzogcYd+swd8K
         tpMnMNgxKsu0g9WqXKjmMXhz+H/4TNuA3vSn1bcKROHamdMUDVOjpVlk1aADB+POvQsG
         ArmunvMaZxr9IWp3/Jussu2z718AObXZDWiS8GTzrqoH++IcZ9UoqJhwdDtrO6kkAKs7
         5QkQ==
X-Gm-Message-State: AC+VfDwgIyBln4xbSiAte+RSFjxjO4V23LXihomuaNZMo/YFMX3Mug5a
	BLYMcmpaDa24jtiTkCncv20oxcdaceqE3oehUzgkcQ==
X-Google-Smtp-Source: ACHHUZ73LZ2ATpBW6snReoJWv61G21Ch+xiXFN1rBGszkczl6lrldi7Jxy3Pezu4ksPP1tPIumAabA==
X-Received: by 2002:adf:e3ce:0:b0:306:31e0:958 with SMTP id k14-20020adfe3ce000000b0030631e00958mr1119929wrm.15.1685096938665;
        Fri, 26 May 2023 03:28:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d6506000000b0030639a86f9dsm4593555wru.51.2023.05.26.03.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:58 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	tariqt@nvidia.com,
	idosch@nvidia.com,
	petrm@nvidia.com,
	simon.horman@corigine.com,
	ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com,
	michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: [patch net-next v2 09/15] mlx5: register devlink ports with ops
Date: Fri, 26 May 2023 12:28:35 +0200
Message-Id: <20230526102841.2226553-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230526102841.2226553-1-jiri@resnulli.us>
References: <20230526102841.2226553-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

Use newly introduce devlink port registration function variant and
register devlink port passing ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c   | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 084a910bb4e7..d9c17481b972 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -65,6 +65,9 @@ static void mlx5_esw_dl_port_free(struct devlink_port *dl_port)
 	kfree(dl_port);
 }
 
+static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
+};
+
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_core_dev *dev = esw->dev;
@@ -87,7 +90,8 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
-	err = devl_port_register(devlink, dl_port, dl_port_index);
+	err = devl_port_register_with_ops(devlink, dl_port, dl_port_index,
+					  &mlx5_esw_dl_port_ops);
 	if (err)
 		goto reg_err;
 
@@ -134,6 +138,9 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 	return IS_ERR(vport) ? ERR_CAST(vport) : vport->dl_port;
 }
 
+static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
+};
+
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
 				      u16 vport_num, u32 controller, u32 sfnum)
 {
@@ -156,7 +163,8 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	devlink_port_attrs_pci_sf_set(dl_port, controller, pfnum, sfnum, !!controller);
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
-	err = devl_port_register(devlink, dl_port, dl_port_index);
+	err = devl_port_register_with_ops(devlink, dl_port, dl_port_index,
+					  &mlx5_esw_dl_sf_port_ops);
 	if (err)
 		return err;
 
-- 
2.39.2


