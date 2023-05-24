Return-Path: <netdev+bounces-4977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1781F70F626
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D27401C20CCD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F6218C1F;
	Wed, 24 May 2023 12:18:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DEB18C03
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:58 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5601D9E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:56 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96fe2a1db26so157725066b.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930735; x=1687522735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJb2QMDl75hVEpCgB5B9dmDdv3Q9DLi4HpEJ9o/QJXM=;
        b=RsicsqUwoPnF5aO9VyqR0ooJImv06uK8v2EnMbnaybDHzY08ij8zvEndriSyGxwElq
         Y6kgJvwSqa+5Te7jx+VsBPBAENU8ImnMCmpBfXj6NcxQLwIKIsaaOv+p3YOjbTuXE41+
         19g1VzW1AF8JT85JmvdwlXCCIkKmrN0EyCuW6mCROc5H6fGt9lmeQO2qh8Ja1vRU6c3z
         r4wGHPEZS+YnGOYCPIWS/BexzMyrQbDV4WRPbbwnqHXsyNo+cCace/sWGHm6fsGxQyYX
         L25kPOed4HoDsL9aK28IRyha4Ya+3WCHfH9hF4e88vzwimpG3GRNSzhu2P84enGLh4Py
         /foQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930735; x=1687522735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJb2QMDl75hVEpCgB5B9dmDdv3Q9DLi4HpEJ9o/QJXM=;
        b=eIYSRbXq3sZOOAS02l168gpORcExhK+/UoLDKihgR9sd3UhpdauCmBAmhbZkusSo7V
         KTULuLzb2wWHu7isY54Bqi8rXmY2omkzz+roIMw1xzCIyhIfW0V7fn6WJYMhS64a47Te
         wXUW3W57BjRbMjsix/3IDIharRqjdirVps405dGQUcMZdrrCKv3jmHoSsitCysDIwvLm
         UgCEM8DzG9+K+sfQRweHLRbACcqVmw6upU17wJ+oayfvCbl6Se5nYanhMZTLf6FSGjtI
         7Ck7oOQFSwxUBbLg0XET0irpB/epkW2CDju0IELMkcFdmjeXBdpHXu6YJu1gdVoE13QH
         5YXw==
X-Gm-Message-State: AC+VfDwn0S3HATr5PSTfadfaN8QMv0z39ZUgOtlBXxJRUc7ahN5BA+Mu
	98u9Vf2PGxrda7vLAV5Dnc8atue9qUwmdFha4AldUQ==
X-Google-Smtp-Source: ACHHUZ6kZjEfvzaLmmqUfWR7No6OScxmkPKQuw4Jxwg7MwycIGYZgJBYXPYRVqfvpKBHs9c0CGHqFg==
X-Received: by 2002:a17:906:eec8:b0:968:2bb1:f39d with SMTP id wu8-20020a170906eec800b009682bb1f39dmr15679765ejb.36.1684930734919;
        Wed, 24 May 2023 05:18:54 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e14-20020a170906844e00b0095fd0462695sm5636304ejy.5.2023.05.24.05.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:53 -0700 (PDT)
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
Subject: [patch net-next 11/15] devlink: move port_fn_roce_get/set() to devlink_port_ops
Date: Wed, 24 May 2023 14:18:32 +0200
Message-Id: <20230524121836.2070879-12-jiri@resnulli.us>
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

Move port_fn_roce_get/set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 --
 .../mellanox/mlx5/core/esw/devlink_port.c     |  4 +++
 include/net/devlink.h                         | 31 ++++++++-----------
 net/devlink/leftover.c                        | 18 +++++------
 4 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1e96f32bd1b5..d63ec466dcd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -317,8 +317,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_node_new = mlx5_esw_devlink_rate_node_new,
 	.rate_node_del = mlx5_esw_devlink_rate_node_del,
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
-	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
-	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
 	.port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
 	.port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 78d12c377900..9011619e1fdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -68,6 +68,8 @@ static void mlx5_esw_dl_port_free(struct devlink_port *dl_port)
 static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
 	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
 	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
+	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
+	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
 };
 
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num)
@@ -143,6 +145,8 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
 	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
 	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
+	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
+	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
 };
 
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 984829e9239e..5ceedd279a1d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1429,24 +1429,6 @@ struct devlink_ops {
 	int (*trap_policer_counter_get)(struct devlink *devlink,
 					const struct devlink_trap_policer *policer,
 					u64 *p_drops);
-	/**
-	 * @port_fn_roce_get: Port function's roce get function.
-	 *
-	 * Query RoCE state of a function managed by the devlink port.
-	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
-	 */
-	int (*port_fn_roce_get)(struct devlink_port *devlink_port,
-				bool *is_enable,
-				struct netlink_ext_ack *extack);
-	/**
-	 * @port_fn_roce_set: Port function's roce set function.
-	 *
-	 * Enable/Disable the RoCE state of a function managed by the devlink
-	 * port.
-	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
-	 */
-	int (*port_fn_roce_set)(struct devlink_port *devlink_port,
-				bool enable, struct netlink_ext_ack *extack);
 	/**
 	 * @port_fn_migratable_get: Port function's migratable get function.
 	 *
@@ -1636,6 +1618,14 @@ void devlink_free(struct devlink *devlink);
  * @port_fn_hw_addr_set: Callback used to set port function's hardware address.
  *			 Should be used by device drivers to set the hardware
  *			 address of a function managed by the devlink port.
+ * @port_fn_roce_get: Callback used to get port function's RoCE capability.
+ *		      Should be used by device drivers to report
+ *		      the current state of RoCE capability of a function
+ *		      managed by the devlink port.
+ * @port_fn_roce_set: Callback used to set port function's RoCE capability.
+ *		      Should be used by device drivers to enable/disable
+ *		      RoCE capability of a function managed
+ *		      by the devlink port.
  *
  * Note: Driver should return -EOPNOTSUPP if it doesn't support
  * port function (@port_fn_*) handling for a particular port.
@@ -1653,6 +1643,11 @@ struct devlink_port_ops {
 	int (*port_fn_hw_addr_set)(struct devlink_port *port,
 				   const u8 *hw_addr, int hw_addr_len,
 				   struct netlink_ext_ack *extack);
+	int (*port_fn_roce_get)(struct devlink_port *devlink_port,
+				bool *is_enable,
+				struct netlink_ext_ack *extack);
+	int (*port_fn_roce_set)(struct devlink_port *devlink_port,
+				bool enable, struct netlink_ext_ack *extack);
 };
 
 void devlink_port_init(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index fe38c4b2ab14..a72586c5b1ad 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -447,18 +447,18 @@ static void devlink_port_fn_cap_fill(struct nla_bitfield32 *caps,
 		caps->value |= cap;
 }
 
-static int devlink_port_fn_roce_fill(const struct devlink_ops *ops,
-				     struct devlink_port *devlink_port,
+static int devlink_port_fn_roce_fill(struct devlink_port *devlink_port,
 				     struct nla_bitfield32 *caps,
 				     struct netlink_ext_ack *extack)
 {
 	bool is_enable;
 	int err;
 
-	if (!ops->port_fn_roce_get)
+	if (!devlink_port->ops || !devlink_port->ops->port_fn_roce_get)
 		return 0;
 
-	err = ops->port_fn_roce_get(devlink_port, &is_enable, extack);
+	err = devlink_port->ops->port_fn_roce_get(devlink_port, &is_enable,
+						  extack);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
@@ -501,7 +501,7 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	struct nla_bitfield32 caps = {};
 	int err;
 
-	err = devlink_port_fn_roce_fill(ops, devlink_port, &caps, extack);
+	err = devlink_port_fn_roce_fill(devlink_port, &caps, extack);
 	if (err)
 		return err;
 
@@ -837,9 +837,8 @@ static int
 devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
 			 struct netlink_ext_ack *extack)
 {
-	const struct devlink_ops *ops = devlink_port->devlink->ops;
-
-	return ops->port_fn_roce_set(devlink_port, enable, extack);
+	return devlink_port->ops->port_fn_roce_set(devlink_port, enable,
+						   extack);
 }
 
 static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
@@ -1214,7 +1213,8 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 
 		caps = nla_get_bitfield32(attr);
 		if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE &&
-		    !ops->port_fn_roce_set) {
+		    (!devlink_port->ops ||
+		     !devlink_port->ops->port_fn_roce_set)) {
 			NL_SET_ERR_MSG_ATTR(extack, attr,
 					    "Port doesn't support RoCE function attribute");
 			return -EOPNOTSUPP;
-- 
2.39.2


