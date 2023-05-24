Return-Path: <netdev+bounces-4979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C127B70F62F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BB8D1C20C28
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E5A182A2;
	Wed, 24 May 2023 12:19:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806CB18C38
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:19:01 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F8F135
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:59 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-50bcb4a81ceso1950441a12.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930738; x=1687522738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vc2OwA+LoPDgXhr9RKH6t+01QYSWA1uGgZ4ErdZulk4=;
        b=ansFp8C10tUq+ewJjtEb6OfoHBv6JAo3qNZs+G4jgAOE/eZIwkyFNDUnBq7iEMpEe3
         V2ekuwY5f8rU+coSNgIRLcqK0LSAbbd0TGChfbuvZVAAImvy5T5XU7wubD34QNl3s4rw
         H3/o4Xvf/169sCJue4aElUe1tSnwhVrV5womnhFYsrZMvofAfmETtjv8e+dGlIlNzfvn
         FvvJEjEz2LkBz23aVYnzFwx996z2FAMJLC01yxVf3RmnA+XEynK16OEgR6OlvFDhHfrQ
         8OsPWJZyE7ANcMIZMpHfJnV9xSOSROJWNXmIKi4ZouxkXQP2FGKBzvKhwSPkYeC3ahj5
         DHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930738; x=1687522738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vc2OwA+LoPDgXhr9RKH6t+01QYSWA1uGgZ4ErdZulk4=;
        b=DkZ1C5bfatq8rSV820J0Co2KftCWQf2hOvJ5ffkZfDctKN4iyqRm+Wka3rgmG06u7D
         bi8P7as/O6ydsrG4H7W9nd2ZSkCE61eUHDrMP1gN47U9i4aLcdvkvfflqs6KAdRI+Hwg
         iTz0Wc6qNpkYi19mr8hwpz9gV4mRRXH+Iw8fmmdhg0Rf4KncOpBV0MKIszCuMFE1kEqj
         uKCB9/GnhGdaCk6uPM2O58BZS77Y3+j9Gr2HjvwXmt1f8GnMKntqLdmCTcQ3nZfrk+Iy
         cnK3ErvsUbtDwCZEsmssXSFPbc3bGJMYcoEx+ijaazDTHfd8Sv8UErzky8xitVF5o2wj
         IN+Q==
X-Gm-Message-State: AC+VfDzQPHmNY45LwksItouyco2jCISHYsF6SgK62JEpQu0HxNxdA7Zw
	hm4dfgq+dUb//zv5p2/+RYrW7WPQbRrZXH6ie2zZSg==
X-Google-Smtp-Source: ACHHUZ7c4ZlUWZGL6YbomyFhe0sfoc9iCBD4VhZYYAjRZYfgJl52wxmebQ/Ux+/bjVINurSEW40CrQ==
X-Received: by 2002:a17:907:3e24:b0:96a:5bdd:7557 with SMTP id hp36-20020a1709073e2400b0096a5bdd7557mr18046284ejc.70.1684930737967;
        Wed, 24 May 2023 05:18:57 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v3-20020a170906858300b0096a68648329sm5718405ejx.214.2023.05.24.05.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:57 -0700 (PDT)
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
Subject: [patch net-next 13/15] devlink: move port_fn_state_get/set() to devlink_port_ops
Date: Wed, 24 May 2023 14:18:34 +0200
Message-Id: <20230524121836.2070879-14-jiri@resnulli.us>
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

Move port_fn_state_get/set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
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
index e19554187362..ddff9815c651 100644
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
+	if (!port->ops || !port->ops->port_fn_state_get)
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
+	    (!devlink_port->ops || !devlink_port->ops->port_fn_state_set)) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
 				    "Function does not support state setting");
 		return -EOPNOTSUPP;
-- 
2.39.2


