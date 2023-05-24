Return-Path: <netdev+bounces-4973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B5370F61D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 578BE28134A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE08718AE5;
	Wed, 24 May 2023 12:18:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B221518004
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:51 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28214184
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:50 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94a342f7c4cso151206466b.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930728; x=1687522728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yp+sMF4CAKTu5r6oQFZVmidr6bUxAiDEFsT/tt0Ubww=;
        b=aPVpQ+uUzTMDcOrrt//GlLJQkQ5SnaR85ibab8bXbF6o8t8t0qJ0GxlNTqH8sfXle7
         IrlhcHBeqqjTezkGsHDVejw4gxk0Nw5zM+RmRzTKygfRwzQD3wzZx8mO8HkRv1lpZeQW
         8N9RRid1rIalRSFQqdEToE5kEanPOB1tlFZDF0w4BqvC1tmK4AV9mF7UqHOBFZRaz8O0
         uGzFIVYhzyQXAPet9CUyRI1yGW8Ey21BMpBPT/bE0GxLehtj3riE46OEl27ws4BeQRNo
         4fX7H8PUfa6iAeyhUJ9nOnsXhHYHz2hsdI1toRr1aEacJx5gL41UmuLQTjEz03lPG5mT
         cxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930728; x=1687522728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yp+sMF4CAKTu5r6oQFZVmidr6bUxAiDEFsT/tt0Ubww=;
        b=C5UOoPGys8lDO3XjLozWHP/fi5Op0UKWDZ8FgDJCSxg6/Sz3mJk0ttOugqsay+izgL
         hLUyAEJpHr+qaRCJQ7XvFQ15k6EV8hhmSLIcvMB4HxMGCDgG14oAWnJyKQwuFjMDFDs9
         D7L1cJqQVJ/SYdROKZNqcMRHDrKLcbA8sObYJu/4M0S+W5Cn3jvb0sh8Uf0Fm6W1ECLO
         mZ+K3ZoxVyzXhD0caUWr74hOzmMcHCGLCKuAe+rwpMVOnRHfrDdRkeMaU4B+B3UcHJg7
         +EhvGf9exImgqjqR7HJvHidQF72vwpAiZPppQpYeX9iNUqnIwlHj/DWrBWDACKu9XktD
         a8zw==
X-Gm-Message-State: AC+VfDzTQa6wXqO12kiItMNyaxFZ4gwvSCXwp4ZjOk/0ahIXfEYgRKk6
	j2L+/xkhPyz7F4uRpbA/hE8qmlq568tbv6Jy5LJbPA==
X-Google-Smtp-Source: ACHHUZ4I85Ocd0IG/RYzKE7SAnxPLnlL7zjFja06pOB+UDRaj7ZpNbR8cPWG1amAD6ez/T0cVns5Hw==
X-Received: by 2002:a17:907:7647:b0:94e:9a73:1637 with SMTP id kj7-20020a170907764700b0094e9a731637mr15628691ejc.75.1684930728572;
        Wed, 24 May 2023 05:18:48 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id qp9-20020a170907206900b00969dc13d0b1sm5634779ejb.43.2023.05.24.05.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:47 -0700 (PDT)
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
Subject: [patch net-next 07/15] devlink: move port_type_set() op into devlink_port_ops
Date: Wed, 24 May 2023 14:18:28 +0200
Message-Id: <20230524121836.2070879-8-jiri@resnulli.us>
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

Move port_type_set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 52 +++++++++++------------
 include/net/devlink.h                     |  5 ++-
 net/devlink/leftover.c                    |  5 +--
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index fd81c0b7191d..9c652e044c0f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3027,7 +3027,33 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	}
 }
 
+static int mlx4_devlink_port_type_set(struct devlink_port *devlink_port,
+				      enum devlink_port_type port_type)
+{
+	struct mlx4_port_info *info = container_of(devlink_port,
+						   struct mlx4_port_info,
+						   devlink_port);
+	enum mlx4_port_type mlx4_port_type;
+
+	switch (port_type) {
+	case DEVLINK_PORT_TYPE_AUTO:
+		mlx4_port_type = MLX4_PORT_TYPE_AUTO;
+		break;
+	case DEVLINK_PORT_TYPE_ETH:
+		mlx4_port_type = MLX4_PORT_TYPE_ETH;
+		break;
+	case DEVLINK_PORT_TYPE_IB:
+		mlx4_port_type = MLX4_PORT_TYPE_IB;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return __set_port_type(info, mlx4_port_type);
+}
+
 static const struct devlink_port_ops mlx4_devlink_port_ops = {
+	.port_type_set = mlx4_devlink_port_type_set,
 };
 
 static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
@@ -3881,31 +3907,6 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	return err;
 }
 
-static int mlx4_devlink_port_type_set(struct devlink_port *devlink_port,
-				      enum devlink_port_type port_type)
-{
-	struct mlx4_port_info *info = container_of(devlink_port,
-						   struct mlx4_port_info,
-						   devlink_port);
-	enum mlx4_port_type mlx4_port_type;
-
-	switch (port_type) {
-	case DEVLINK_PORT_TYPE_AUTO:
-		mlx4_port_type = MLX4_PORT_TYPE_AUTO;
-		break;
-	case DEVLINK_PORT_TYPE_ETH:
-		mlx4_port_type = MLX4_PORT_TYPE_ETH;
-		break;
-	case DEVLINK_PORT_TYPE_IB:
-		mlx4_port_type = MLX4_PORT_TYPE_IB;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return __set_port_type(info, mlx4_port_type);
-}
-
 static void mlx4_devlink_param_load_driverinit_values(struct devlink *devlink)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3990,7 +3991,6 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 }
 
 static const struct devlink_ops mlx4_devlink_ops = {
-	.port_type_set	= mlx4_devlink_port_type_set,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down	= mlx4_devlink_reload_down,
 	.reload_up	= mlx4_devlink_reload_up,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6ddb1fb905b2..6fd1697d0443 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1274,8 +1274,6 @@ struct devlink_ops {
 	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
 			 enum devlink_reload_limit limit, u32 *actions_performed,
 			 struct netlink_ext_ack *extack);
-	int (*port_type_set)(struct devlink_port *devlink_port,
-			     enum devlink_port_type port_type);
 	int (*sb_pool_get)(struct devlink *devlink, unsigned int sb_index,
 			   u16 pool_index,
 			   struct devlink_sb_pool_info *pool_info);
@@ -1652,12 +1650,15 @@ void devlink_free(struct devlink *devlink);
  * @port_split: Callback used to split the port into multiple ones.
  * @port_unsplit: Callback used to unsplit the port group back into
  *		  a single port.
+ * @port_type_set: Callback used to set a type of a port.
  */
 struct devlink_port_ops {
 	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
 			  unsigned int count, struct netlink_ext_ack *extack);
 	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
 			    struct netlink_ext_ack *extack);
+	int (*port_type_set)(struct devlink_port *devlink_port,
+			     enum devlink_port_type port_type);
 };
 
 void devlink_port_init(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 8646861127a0..b8fb96a8f4d6 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1137,14 +1137,13 @@ static int devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	int err;
 
-	if (!devlink_port->devlink->ops->port_type_set)
+	if (!devlink_port->ops || !devlink_port->ops->port_type_set)
 		return -EOPNOTSUPP;
 
 	if (port_type == devlink_port->type)
 		return 0;
 
-	err = devlink_port->devlink->ops->port_type_set(devlink_port,
-							port_type);
+	err = devlink_port->ops->port_type_set(devlink_port, port_type);
 	if (err)
 		return err;
 
-- 
2.39.2


