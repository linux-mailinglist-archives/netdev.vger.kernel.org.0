Return-Path: <netdev+bounces-5638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B87097124BE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B6EE1C20850
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A180424EAE;
	Fri, 26 May 2023 10:29:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9782F156CF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:29:07 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D161B12A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-30a1fdde3d6so531125f8f.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096945; x=1687688945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=og0kkG966eeRprzAK8hgpsqJ6E7ckHejC1Wgc+4WtdU=;
        b=OwsdvPmZahPnvIQ0td6MnbCO/ey81IrRFSLNGIYh/T4s6HMHNgtXJ0ZPNYd3CsIVw4
         TJMHQJQssbo1IyxcR4dljcvcLNwgqIRulVvqslOxQIMrW973ec9Gs/qpGHbooBjAD+z3
         63/0H1h7kAfJdFcvBm0uyE1dWnFF9GHy9L5r15oADUrL7xYIzmEpGZ95eBG1q+VDxEf6
         SUcer29Kc5Gb84fNqzzJVmJfD02nAmV7fyhhkA0hctQAviBiAMsawE6KsPLayg84SN+O
         lBRBj8IWooZrcSralSJzwQG6g9A+pgK0yGM5snsUI2TJGZLVSnTQbgx32hDh6uo5em7l
         7PwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096945; x=1687688945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=og0kkG966eeRprzAK8hgpsqJ6E7ckHejC1Wgc+4WtdU=;
        b=NuQw6tZWlzKprlcBL12p7s4KwSGRDf+MiS65sDtl+e2V7yWfQYRIAeWAtnDwTnjubY
         081CV2IkmVh6TH44MxHPfkFtyvb0rSBZFrccn7XNTumk/tiCDBfXlVeEUAlrey+um7Fy
         yInNDAtOeTIecO5xsF+nidjDCtocq7pALwrrH8exV9WcOk6THfm9R9NextqBiZns9VKE
         Bu7ee48rGppcus9jSRcQRP8l/x/hj8dy8kQqJm66ZK/uQirljjoUdSiZ3AqSycub1slN
         jsexvzbWlQknSOn6xqkBZmaxGFxFoUHRRdqgABVdi3UDjZc8WrDE47oPMjMb0s3KKo3P
         Tsuw==
X-Gm-Message-State: AC+VfDwl/SyuzK9bdfnry9Jsi+3ueGLaENhPI2Sat7QSRWvm3gmkHZec
	7vg8Fxgo6U6jO9TpDtL3M6++x3dJxWJwOrDp3LkS4Q==
X-Google-Smtp-Source: ACHHUZ4zgwMaltQWV7a9D8Wpn6HIX1nbf2N2zmlWFmFi9OZPT0N6n+0PxauXStKma7QII9Ojd/Gv7w==
X-Received: by 2002:a5d:4285:0:b0:300:cb8c:fd8f with SMTP id k5-20020a5d4285000000b00300cb8cfd8fmr941688wrq.54.1685096945389;
        Fri, 26 May 2023 03:29:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q14-20020adff50e000000b00307acec258esm4662173wro.3.2023.05.26.03.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:29:04 -0700 (PDT)
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
Subject: [patch net-next v2 13/15] devlink: move port_fn_state_get/set() to devlink_port_ops
Date: Fri, 26 May 2023 12:28:39 +0200
Message-Id: <20230526102841.2226553-14-jiri@resnulli.us>
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

Move port_fn_state_get/set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- avoid ops check as they no longer could be null
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 -
 .../mellanox/mlx5/core/esw/devlink_port.c     |  4 ++
 include/net/devlink.h                         | 45 +++++++------------
 net/devlink/leftover.c                        | 19 +++-----
 4 files changed, 26 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 678bae618769..e39fd85ea2f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -321,8 +321,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
 	.port_del = mlx5_devlink_sf_port_del,
-	.port_fn_state_get = mlx5_devlink_sf_port_fn_state_get,
-	.port_fn_state_set = mlx5_devlink_sf_port_fn_state_set,
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 2ececd2b86c8..76c5d6e9d47f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -149,6 +149,10 @@ static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
 	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
 	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
 	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
+#ifdef CONFIG_MLX5_SF_MANAGER
+	.port_fn_state_get = mlx5_devlink_sf_port_fn_state_get,
+	.port_fn_state_set = mlx5_devlink_sf_port_fn_state_set,
+#endif
 };
 
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 94a1fdb4105d..21254d6884ee 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1464,36 +1464,6 @@ struct devlink_ops {
 	 */
 	int (*port_del)(struct devlink *devlink, struct devlink_port *port,
 			struct netlink_ext_ack *extack);
-	/**
-	 * port_fn_state_get() - Get the state of a port function
-	 * @devlink: Devlink instance
-	 * @port: The devlink port
-	 * @state: Admin configured state
-	 * @opstate: Current operational state
-	 * @extack: extack for reporting error messages
-	 *
-	 * Reports the admin and operational state of a devlink port function
-	 *
-	 * Return: 0 on success, negative value otherwise.
-	 */
-	int (*port_fn_state_get)(struct devlink_port *port,
-				 enum devlink_port_fn_state *state,
-				 enum devlink_port_fn_opstate *opstate,
-				 struct netlink_ext_ack *extack);
-	/**
-	 * port_fn_state_set() - Set the admin state of a port function
-	 * @devlink: Devlink instance
-	 * @port: The devlink port
-	 * @state: Admin state
-	 * @extack: extack for reporting error messages
-	 *
-	 * Set the admin state of a devlink port function
-	 *
-	 * Return: 0 on success, negative value otherwise.
-	 */
-	int (*port_fn_state_set)(struct devlink_port *port,
-				 enum devlink_port_fn_state state,
-				 struct netlink_ext_ack *extack);
 
 	/**
 	 * Rate control callbacks.
@@ -1613,6 +1583,14 @@ void devlink_free(struct devlink *devlink);
  *			    capability. Should be used by device drivers
  *			    to enable/disable migratable capability of
  *			    a function managed by the devlink port.
+ * @port_fn_state_get: Callback used to get port function's state.
+ *		       Should be used by device drivers to report
+ *		       the current admin and operational state of a
+ *		       function managed by the devlink port.
+ * @port_fn_state_set: Callback used to get port function's state.
+ *		       Should be used by device drivers set
+ *		       the admin state of a function managed
+ *		       by the devlink port.
  *
  * Note: Driver should return -EOPNOTSUPP if it doesn't support
  * port function (@port_fn_*) handling for a particular port.
@@ -1641,6 +1619,13 @@ struct devlink_port_ops {
 	int (*port_fn_migratable_set)(struct devlink_port *devlink_port,
 				      bool enable,
 				      struct netlink_ext_ack *extack);
+	int (*port_fn_state_get)(struct devlink_port *port,
+				 enum devlink_port_fn_state *state,
+				 enum devlink_port_fn_opstate *opstate,
+				 struct netlink_ext_ack *extack);
+	int (*port_fn_state_set)(struct devlink_port *port,
+				 enum devlink_port_fn_state state,
+				 struct netlink_ext_ack *extack);
 };
 
 void devlink_port_init(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 3526e85bc8cb..03ce24a1397e 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -787,8 +787,7 @@ devlink_port_fn_opstate_valid(enum devlink_port_fn_opstate opstate)
 	       opstate == DEVLINK_PORT_FN_OPSTATE_ATTACHED;
 }
 
-static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
-				      struct devlink_port *port,
+static int devlink_port_fn_state_fill(struct devlink_port *port,
 				      struct sk_buff *msg,
 				      struct netlink_ext_ack *extack,
 				      bool *msg_updated)
@@ -797,10 +796,10 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 	enum devlink_port_fn_state state;
 	int err;
 
-	if (!ops->port_fn_state_get)
+	if (!port->ops->port_fn_state_get)
 		return 0;
 
-	err = ops->port_fn_state_get(port, &state, &opstate, extack);
+	err = port->ops->port_fn_state_get(port, &state, &opstate, extack);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
@@ -870,7 +869,6 @@ static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
 {
-	const struct devlink_ops *ops;
 	struct nlattr *function_attr;
 	bool msg_updated = false;
 	int err;
@@ -879,14 +877,13 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	if (!function_attr)
 		return -EMSGSIZE;
 
-	ops = port->devlink->ops;
 	err = devlink_port_fn_hw_addr_fill(port, msg, extack, &msg_updated);
 	if (err)
 		goto out;
 	err = devlink_port_fn_caps_fill(port, msg, extack, &msg_updated);
 	if (err)
 		goto out;
-	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
+	err = devlink_port_fn_state_fill(port, msg, extack, &msg_updated);
 out:
 	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
@@ -1179,18 +1176,15 @@ static int devlink_port_fn_state_set(struct devlink_port *port,
 				     struct netlink_ext_ack *extack)
 {
 	enum devlink_port_fn_state state;
-	const struct devlink_ops *ops;
 
 	state = nla_get_u8(attr);
-	ops = port->devlink->ops;
-	return ops->port_fn_state_set(port, state, extack);
+	return port->ops->port_fn_state_set(port, state, extack);
 }
 
 static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					  struct nlattr **tb,
 					  struct netlink_ext_ack *extack)
 {
-	const struct devlink_ops *ops = devlink_port->devlink->ops;
 	struct nlattr *attr;
 
 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
@@ -1199,7 +1193,8 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 				    "Port doesn't support function attributes");
 		return -EOPNOTSUPP;
 	}
-	if (tb[DEVLINK_PORT_FN_ATTR_STATE] && !ops->port_fn_state_set) {
+	if (tb[DEVLINK_PORT_FN_ATTR_STATE] &&
+	    !devlink_port->ops->port_fn_state_set) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
 				    "Function does not support state setting");
 		return -EOPNOTSUPP;
-- 
2.39.2


