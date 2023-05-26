Return-Path: <netdev+bounces-5637-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 586BE7124BC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E1262817FE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D80F23D7C;
	Fri, 26 May 2023 10:29:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7CA168BC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:29:07 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50622FB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:05 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f6dbe3c230so6267985e9.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096944; x=1687688944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xeCIX3C1UJN1pg6Yv4B9g4gjC+pHMlpiLCT/CAeIeaM=;
        b=cnzOXHV+JTwCgtI9uCsBrf3owfaXGGYUP7VLnLsN5HHjJydaMgL+i/ZK6KqH+KNvLC
         riu39UYAzG+q19/1ll5f/PgR3xedsfs1cZ0sC5I+xOXT3LaxLeP/1tJrQDRqlNiOaMSZ
         r8aVaTyCBHCJ7zeRw9N/VsgwSWh43aGCsynb0Sxcv/5K4DPYrJzjTjJYerznSQjbN2UV
         HBSkM40ISsqrnL+SZXkLKpuz4ung0fgHcAgQ38kM6hhVyQlYXERlHodjIBjRu4dkXH+v
         TlvmUNyc9HdMGEBG9DztLrv2bgEQWrxSWdmNF7PKqNg6OSoGIamq8z7a2lO+RKDaVeqB
         xMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096944; x=1687688944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xeCIX3C1UJN1pg6Yv4B9g4gjC+pHMlpiLCT/CAeIeaM=;
        b=Q77o2lVtEn89IWlh7zCZGsnwSqKs1x03QYpWis42SglpyO7l6sDiWYceufJXF2mKV2
         BTcw8iAPABifMFZ5Fpc3DwvVz7nx+3TEQlEQz/oJkj53svl6t0iji5g45cSrAuKuw7m0
         BRO45GxfDNQztbwprK0iDdxHs8HLLav1+9vFG+wn2DIWhaVjAcI16UAdaeRQmO4LNr/q
         rH0vPs6Ldpn8y855sp3mWuXz6w7EdJV1mdrciea8fRoFp6jI6Yhi1N0M/EjKdV5zL/4T
         982usqD8SV+IFkoCGyT8kTKk+AMGrWNbjLb4xQkdYeJhCN+Mo2XnljHWUvzkQTCvjFWP
         d2sQ==
X-Gm-Message-State: AC+VfDwmS1B4CbgKYD9FN7gflHjfiy6YcA66Bjj9o+DPcuDBVZi+pfwf
	dnhBAwIumM0y2E9raSr8dxou+aEBkRp+4BEZiFF01A==
X-Google-Smtp-Source: ACHHUZ5pWLux4uqN/py7BwTqERiKA1OGLCl3gt5G04iQ/6deRr6A4kgx2ctLwzoQ7JiMHTrTWvOgQg==
X-Received: by 2002:adf:f307:0:b0:30a:c89c:c338 with SMTP id i7-20020adff307000000b0030ac89cc338mr1095345wro.50.1685096943775;
        Fri, 26 May 2023 03:29:03 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q2-20020adff502000000b003062c0ef959sm4627331wro.69.2023.05.26.03.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:29:03 -0700 (PDT)
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
Subject: [patch net-next v2 12/15] devlink: move port_fn_migratable_get/set() to devlink_port_ops
Date: Fri, 26 May 2023 12:28:38 +0200
Message-Id: <20230526102841.2226553-13-jiri@resnulli.us>
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

Move port_fn_migratable_get/set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- avoid ops check as they no longer could be null
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 --
 .../mellanox/mlx5/core/esw/devlink_port.c     |  2 ++
 include/net/devlink.h                         | 35 ++++++++-----------
 net/devlink/leftover.c                        | 23 ++++++------
 4 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d63ec466dcd6..678bae618769 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -317,8 +317,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_node_new = mlx5_esw_devlink_rate_node_new,
 	.rate_node_del = mlx5_esw_devlink_rate_node_del,
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
-	.port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
-	.port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 9011619e1fdd..2ececd2b86c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -70,6 +70,8 @@ static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
 	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
 	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
 	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
+	.port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
+	.port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
 };
 
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num)
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5ceedd279a1d..94a1fdb4105d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1429,27 +1429,6 @@ struct devlink_ops {
 	int (*trap_policer_counter_get)(struct devlink *devlink,
 					const struct devlink_trap_policer *policer,
 					u64 *p_drops);
-	/**
-	 * @port_fn_migratable_get: Port function's migratable get function.
-	 *
-	 * Query migratable state of a function managed by the devlink port.
-	 * Return -EOPNOTSUPP if port function migratable handling is not
-	 * supported.
-	 */
-	int (*port_fn_migratable_get)(struct devlink_port *devlink_port,
-				      bool *is_enable,
-				      struct netlink_ext_ack *extack);
-	/**
-	 * @port_fn_migratable_set: Port function's migratable set function.
-	 *
-	 * Enable/Disable migratable state of a function managed by the devlink
-	 * port.
-	 * Return -EOPNOTSUPP if port function migratable handling is not
-	 * supported.
-	 */
-	int (*port_fn_migratable_set)(struct devlink_port *devlink_port,
-				      bool enable,
-				      struct netlink_ext_ack *extack);
 	/**
 	 * port_new() - Add a new port function of a specified flavor
 	 * @devlink: Devlink instance
@@ -1626,6 +1605,14 @@ void devlink_free(struct devlink *devlink);
  *		      Should be used by device drivers to enable/disable
  *		      RoCE capability of a function managed
  *		      by the devlink port.
+ * @port_fn_migratable_get: Callback used to get port function's migratable
+ *			    capability. Should be used by device drivers
+ *			    to report the current state of migratable capability
+ *			    of a function managed by the devlink port.
+ * @port_fn_migratable_set: Callback used to set port function's migratable
+ *			    capability. Should be used by device drivers
+ *			    to enable/disable migratable capability of
+ *			    a function managed by the devlink port.
  *
  * Note: Driver should return -EOPNOTSUPP if it doesn't support
  * port function (@port_fn_*) handling for a particular port.
@@ -1648,6 +1635,12 @@ struct devlink_port_ops {
 				struct netlink_ext_ack *extack);
 	int (*port_fn_roce_set)(struct devlink_port *devlink_port,
 				bool enable, struct netlink_ext_ack *extack);
+	int (*port_fn_migratable_get)(struct devlink_port *devlink_port,
+				      bool *is_enable,
+				      struct netlink_ext_ack *extack);
+	int (*port_fn_migratable_set)(struct devlink_port *devlink_port,
+				      bool enable,
+				      struct netlink_ext_ack *extack);
 };
 
 void devlink_port_init(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 22d904bb600a..3526e85bc8cb 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -469,19 +469,19 @@ static int devlink_port_fn_roce_fill(struct devlink_port *devlink_port,
 	return 0;
 }
 
-static int devlink_port_fn_migratable_fill(const struct devlink_ops *ops,
-					   struct devlink_port *devlink_port,
+static int devlink_port_fn_migratable_fill(struct devlink_port *devlink_port,
 					   struct nla_bitfield32 *caps,
 					   struct netlink_ext_ack *extack)
 {
 	bool is_enable;
 	int err;
 
-	if (!ops->port_fn_migratable_get ||
+	if (!devlink_port->ops->port_fn_migratable_get ||
 	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF)
 		return 0;
 
-	err = ops->port_fn_migratable_get(devlink_port, &is_enable, extack);
+	err = devlink_port->ops->port_fn_migratable_get(devlink_port,
+							&is_enable, extack);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
@@ -492,8 +492,7 @@ static int devlink_port_fn_migratable_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
-static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
-				     struct devlink_port *devlink_port,
+static int devlink_port_fn_caps_fill(struct devlink_port *devlink_port,
 				     struct sk_buff *msg,
 				     struct netlink_ext_ack *extack,
 				     bool *msg_updated)
@@ -505,7 +504,7 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	if (err)
 		return err;
 
-	err = devlink_port_fn_migratable_fill(ops, devlink_port, &caps, extack);
+	err = devlink_port_fn_migratable_fill(devlink_port, &caps, extack);
 	if (err)
 		return err;
 
@@ -828,9 +827,8 @@ static int
 devlink_port_fn_mig_set(struct devlink_port *devlink_port, bool enable,
 			struct netlink_ext_ack *extack)
 {
-	const struct devlink_ops *ops = devlink_port->devlink->ops;
-
-	return ops->port_fn_migratable_set(devlink_port, enable, extack);
+	return devlink_port->ops->port_fn_migratable_set(devlink_port, enable,
+							 extack);
 }
 
 static int
@@ -885,8 +883,7 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	err = devlink_port_fn_hw_addr_fill(port, msg, extack, &msg_updated);
 	if (err)
 		goto out;
-	err = devlink_port_fn_caps_fill(ops, port, msg, extack,
-					&msg_updated);
+	err = devlink_port_fn_caps_fill(port, msg, extack, &msg_updated);
 	if (err)
 		goto out;
 	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
@@ -1219,7 +1216,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 			return -EOPNOTSUPP;
 		}
 		if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
-			if (!ops->port_fn_migratable_set) {
+			if (!devlink_port->ops->port_fn_migratable_set) {
 				NL_SET_ERR_MSG_ATTR(extack, attr,
 						    "Port doesn't support migratable function attribute");
 				return -EOPNOTSUPP;
-- 
2.39.2


