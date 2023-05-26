Return-Path: <netdev+bounces-5636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9817124BA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8C932817E9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC81209BE;
	Fri, 26 May 2023 10:29:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D26168BC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:29:05 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E910A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:03 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6042d610fso6600345e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096942; x=1687688942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SyblXuOra8Yt+P7P1kYmFr8L5gj5W1qW3DL3L7tEjb0=;
        b=ztICOyMVrFZ/enwN4CyHvzfI743IJpqTZG4YZD5MmA8yvoJJ31kioltJYObl2OXTf6
         ajgNJVZPtIBW96A3hlDzcJrw3RRlayKHnSg3H81W17F9TDt8PhSbh9vj8n6y0d/Pfsdg
         sS8KuNyC5AfFIOrbjccold08mmCuHd1SgkgrlMSyQ84Y+odLUI7W5iPKRJtRaeSaz2ca
         ApARxiZHnA5Gif7U7eEoRfAW/27ddR7rRQvqV+/W1X5lWQMHPhGYR/kMxaSl1SKTlHVX
         VQSNvbFt80+dWpOAJk+CkUhfWOTuWR1vntnk4DPBKmsm2g2cIalSbxMCaUA0T/QfpmZt
         0o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096942; x=1687688942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SyblXuOra8Yt+P7P1kYmFr8L5gj5W1qW3DL3L7tEjb0=;
        b=gVGwbqWu/+01n/xLbq0CFkYp6VNic/FLiYNRhpH4fwzj3/OSJ112RGDDWNkX02jtdX
         2sT7vvYLetmZkAHGKUf6S10dvz7zE2NmsddqPatuMTgSxwQKHpJZx2ZDxzP2JgthhW1C
         cBAN1aDp9NU3wnMHWmnDhCxDR+QHkH9eXrfJPcsu9zgHMmBMpmL2Qp8kyjNnt9dVOTjA
         exOTHlkwM4kNG+2bffH4Dz2oGhf5Sme1r8F6WWtPjva90nPgP1z6EtXXuj+Eqw7fAM9s
         ACcQAiqVhMYMEtIhd7VHO+Y659FQLynPa+DWCyOam0dX221N+teKzEWDM+YTejeq7PPo
         kflw==
X-Gm-Message-State: AC+VfDxUSykXS6EDhMkZCvrSKt+Vtz/+yI0fw50EWVdg0CLwCiTBAcw9
	veMHsyEJBYv3c1Mj9l9ifNTWqVbINbOvD0Xx2BKhEg==
X-Google-Smtp-Source: ACHHUZ4tAS2Q4WF6bkP5k/97LpT8gUHrHw4eS67OBCl2Chwmldc4tUFWrIiFOPOxFdjQ7S9MuWmIvQ==
X-Received: by 2002:a7b:cd85:0:b0:3f6:f56:5e82 with SMTP id y5-20020a7bcd85000000b003f60f565e82mr1036382wmj.3.1685096942058;
        Fri, 26 May 2023 03:29:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c024800b003f4e8530696sm4711768wmj.46.2023.05.26.03.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:29:01 -0700 (PDT)
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
Subject: [patch net-next v2 11/15] devlink: move port_fn_roce_get/set() to devlink_port_ops
Date: Fri, 26 May 2023 12:28:37 +0200
Message-Id: <20230526102841.2226553-12-jiri@resnulli.us>
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

Move port_fn_roce_get/set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- avoid ops check as they no longer could be null
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 --
 .../mellanox/mlx5/core/esw/devlink_port.c     |  4 +++
 include/net/devlink.h                         | 31 ++++++++-----------
 net/devlink/leftover.c                        | 17 +++++-----
 4 files changed, 25 insertions(+), 29 deletions(-)

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
index 861d9c2a80aa..22d904bb600a 100644
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
+	if (!devlink_port->ops->port_fn_roce_get)
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
@@ -1214,7 +1213,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 
 		caps = nla_get_bitfield32(attr);
 		if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE &&
-		    !ops->port_fn_roce_set) {
+		    !devlink_port->ops->port_fn_roce_set) {
 			NL_SET_ERR_MSG_ATTR(extack, attr,
 					    "Port doesn't support RoCE function attribute");
 			return -EOPNOTSUPP;
-- 
2.39.2


