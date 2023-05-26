Return-Path: <netdev+bounces-5632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAA47124B1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88E101C20FF5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910DF18B1A;
	Fri, 26 May 2023 10:28:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816DF18AFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:58 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06574FB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3078a3f3b5fso518646f8f.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096935; x=1687688935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQxVkgGDouEgwrvZ6ACvnwje4jd8D/X8ptxEaKZWXtM=;
        b=0bNdbRPTIY7RIkRQ0GN1qr9uM/vY3NicEvuPD1jAfce/SvJnqlD62xHVbIhKDzezdf
         1v/Q7Gf++oeWn0iEXPbtetaBgmlMWjoSWXSTue+o7ow9XGtEN1a0PbU9gfcFQPb/iIvx
         Hl14YkuJFyicV2ddAzYycQ57HWXCKF+oQcsMFvGMA7JpI2WcVM38HAjZJujpipWrUTxV
         07nZIuhfharL7aHiJnQeGun/UtQzbrQkxOqsb1fHK+QIn05DbMCKTnaH5AH95owmyNLh
         xTLk9L4oOubGSuIxpf7gs/7IUP3nDBOgXJ0zxpk7r1/n2RucfubFt86vWXeIm3LV1lIe
         VLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096935; x=1687688935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pQxVkgGDouEgwrvZ6ACvnwje4jd8D/X8ptxEaKZWXtM=;
        b=FazuxLN7LoGG3HsR5v+LgmFxubln/Je6LmyRH1OLrQC4STrjMI0JUnawwZYXvmO/+C
         UqAtB83gfHVFotFDGKXpA0PWWaED2nZSHIF/KMUsUVJf7GsO/10TCCYFgS7ryaLyJVFp
         5X+6CfvovDAe3WRNwdn3vmIaeVSB2WVLyWY1FhoHS4hZnS3Jt7ZK6x0HPDpckDElHy+W
         oKv8ZDo7qvf291fPVMtbFEbX3ibUhvalXtk7vpEWRWTtJLa1qj6NAAuEHZxg9f51htjB
         L9xYcgkt3dHKTaRwKx9snxLmOREJYL0B6r7Pq4lBmmDJ+eJczD/XuAGnp4wsSx82UHol
         1vtg==
X-Gm-Message-State: AC+VfDyuOmiRdL/0iBKW0T8042botKxiejsbOpO4Yh2t1B0EOARqWZ7q
	cu1PPlM4NlWGOMTV5H3QlxQM91lDpjacWCNaiMBT/Q==
X-Google-Smtp-Source: ACHHUZ5ti7CBqHTzV+n9h2dys5qpNSD8RQ/cFiL063oMItzbLOY2l7tIQLKqWSzLm22IO0yf2JTGVg==
X-Received: by 2002:adf:ec44:0:b0:30a:af0c:3105 with SMTP id w4-20020adfec44000000b0030aaf0c3105mr1196287wrn.53.1685096935591;
        Fri, 26 May 2023 03:28:55 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e18-20020a5d5312000000b0030922ba6d0csm4753130wrv.45.2023.05.26.03.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:55 -0700 (PDT)
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
Subject: [patch net-next v2 07/15] devlink: move port_type_set() op into devlink_port_ops
Date: Fri, 26 May 2023 12:28:33 +0200
Message-Id: <20230526102841.2226553-8-jiri@resnulli.us>
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

Move port_type_set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- avoid ops check as they no longer could be null
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 52 +++++++++++------------
 include/net/devlink.h                     |  5 ++-
 net/devlink/leftover.c                    |  5 +--
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 369642478fab..61286b0d9b0c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3024,7 +3024,33 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
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
@@ -3878,31 +3904,6 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
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
@@ -3987,7 +3988,6 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
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
index 43c97271f299..7fbcd58fb21e 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1137,14 +1137,13 @@ static int devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	int err;
 
-	if (!devlink_port->devlink->ops->port_type_set)
+	if (!devlink_port->ops->port_type_set)
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


