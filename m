Return-Path: <netdev+bounces-4975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1777370F622
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6400281300
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808E618C05;
	Wed, 24 May 2023 12:18:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A3D18C03
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:53 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B29130
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:51 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94a342f7c4cso151217166b.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930731; x=1687522731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvHSM1U/Ik/DQAZsWMpTg8xLA9lNmPvHf6W0fcg5knA=;
        b=0qhb8dWFJcBeWN3xfTKy+FNpLPouDrJl837u8xmCKn1FHraBOTkEwaHwuCsjMedCeT
         Qraqv/Q4eCaUBhdcIlOo2jRi8i5QB7ykR5KD04xsp710Zvwxv1kfCuH1Gc7jaRAKOWOL
         Mqw1lZ34uSiafSkVSesRATpGiBVpA4gY4x49fkJerKG5NBQzeXnLsLhn4UW78MI9bDgA
         Dae72iH2GBc6N6byOPEMPK8wy+2xYPCIPOxjv5PCo2jwO0CGlID6aUblFSBTvuOyXGPf
         jzzKuVvhE0I1YLagOaNRSWzJRAsFGu3wqZU1IW9J/lr+wQ+Mbhyg4V5JR3gOq1ReXuRJ
         kokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930731; x=1687522731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvHSM1U/Ik/DQAZsWMpTg8xLA9lNmPvHf6W0fcg5knA=;
        b=HlBJdzZaaLglMSnE5LCJuT1wImIWs5ghQ9Z4YSUAF4IEcg5dRQ1Vn4sXnUouLwhlkm
         4SFDo2VqTNlVPA78lk4aazktjcnsHwfm+lmLPpnpyqz9kaZnFIeuM65BSp9pzanrp8Ga
         43G4UaZbNXEMi1ycsUUM/fv0e0ZdPI5Yolr8jNBVg1llgYoLj4VLstqenSUM8U71QUNt
         3Dpy061o7xRYbLdTPbp6LZfIfJK/p/OnwZLVdQ+qPxmNdvUp8VbOYRC7hOgfRsH/dRx7
         rMAmtgTrHGrn9IQ/onN42xrGVaPeRDJ66cN0lGQEZDYAVIAbj/GwlBfh6euyeEzEjDtO
         TMjQ==
X-Gm-Message-State: AC+VfDxTlAk9V+I7xpVRf/yqGLJHl4fDRIW7UBbyEdGcNjSQx1Xxvqn9
	Z4vXAq4MAnPCxDpNK0Yyra/1II/mgmcPW6T2DwQEdw==
X-Google-Smtp-Source: ACHHUZ7W+XUk8rY7IEr0zYXclAPoUv5GNYpnhKzv2Ywa4yRhl/MnDKhTSXJ6u9wesi4MoBtE76Mrqw==
X-Received: by 2002:a17:907:2d23:b0:96a:928c:d382 with SMTP id gs35-20020a1709072d2300b0096a928cd382mr19106516ejc.48.1684930731533;
        Wed, 24 May 2023 05:18:51 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id jl16-20020a17090775d000b009662d0e637esm5678976ejc.155.2023.05.24.05.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:50 -0700 (PDT)
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
Subject: [patch net-next 09/15] mlx5: register devlink ports with ops
Date: Wed, 24 May 2023 14:18:30 +0200
Message-Id: <20230524121836.2070879-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230524121836.2070879-1-jiri@resnulli.us>
References: <20230524121836.2070879-1-jiri@resnulli.us>
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


