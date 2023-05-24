Return-Path: <netdev+bounces-4976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B124570F623
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65CC828124C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2217618C0F;
	Wed, 24 May 2023 12:18:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1227418C03
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:57 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8915D130
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:54 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96fbc74fbf1so138312066b.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930733; x=1687522733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAL7X0YbD+plO3cc/R6raWVU7Aiw1nQbU6/f1JjME/w=;
        b=Rn2dQ6aYMaK2G+T48T4U5kZ7DA6PhCscJLIUuzp2opTjQs6gGGgUsoOkHq2fmeRViO
         25QCAk4vDsvclzOL3NEde9wwYve7QrkV8+FeRk28sW3st7PVFh8oVOIbYo1eHW7khGw/
         /uGy54sNrjJxLMqltR7gQM/lha6AtI6fw7s47Xu0zX8oHK+XCpEaatWiifdEr4rztg8E
         5bRDpqmamT0ltt0XmUlSz2g5o6dIkGU6dA/pKjYW/gVaq6FA4ji+YpfB6wiMJIcl3QqE
         RbhEAZbmOTg1D1DFzlDL9GPkbiRuVgwKPmniflI7B1umJJVGYCk2ZRgPsuA9eaV2NEvu
         ADjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930733; x=1687522733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAL7X0YbD+plO3cc/R6raWVU7Aiw1nQbU6/f1JjME/w=;
        b=hmeaLOdWMEdV0gkcRlk1QlJFHXZwDrQufEO2+7G7LBFKWfDHsLgPWuQHJbvWiV4Ot2
         Vi5cE4jPHJN+cCUfc7RnL83v+DvxzEOrf8g8E7wufV1b9gEx0vG2VD9bQvOd6pr+IemP
         fvJXZOnSDcM+2MLCx7VaTtiDPwBl4Z8Kxoeo16nY6ENjhWpiuD63MJUaB7XOu6ZFJITJ
         oAW2v0GwrJpAdY3kG8jytm4IILE7PdW1vGyZjhGDCLzmJWWJr9v9iclN73lzTgzH3Gi4
         Gt2AwfahhA/2O1Qn9RFn9EC7in1EKYB8IVpzLoZcGN67b2C0t0U/+SeEDeEpb7okYU5n
         SPCg==
X-Gm-Message-State: AC+VfDy2zOiwbSkUCzd7HJpavaYwdOktduixHbmsjy3hEaa/JTsnlPOm
	RkOlzegHiMoTu7MmI+37MkxyWV7ig6j2zpcFruqlfg==
X-Google-Smtp-Source: ACHHUZ5EpU87gonOMzovlKlxt9vGHuX3HWUnQTVC5hW3QEjPf4DnjwFm1oNg/XabghcLK+WmPuRqUg==
X-Received: by 2002:a17:907:3da0:b0:95e:d448:477 with SMTP id he32-20020a1709073da000b0095ed4480477mr19526712ejc.33.1684930733048;
        Wed, 24 May 2023 05:18:53 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c17-20020a170906341100b00965a56f82absm5711643ejb.212.2023.05.24.05.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:52 -0700 (PDT)
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
Subject: [patch net-next 10/15] devlink: move port_fn_hw_addr_get/set() to devlink_port_ops
Date: Wed, 24 May 2023 14:18:31 +0200
Message-Id: <20230524121836.2070879-11-jiri@resnulli.us>
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

Move port_fn_hw_addr_get/set() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 -
 .../mellanox/mlx5/core/esw/devlink_port.c     |  4 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 12 +--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 12 +--
 drivers/net/ethernet/sfc/efx_devlink.c        | 86 +++++++++----------
 include/net/devlink.h                         | 38 ++++----
 net/devlink/leftover.c                        | 15 ++--
 7 files changed, 80 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index bfaec67abf0d..1e96f32bd1b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -310,8 +310,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_inline_mode_get = mlx5_devlink_eswitch_inline_mode_get,
 	.eswitch_encap_mode_set = mlx5_devlink_eswitch_encap_mode_set,
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
-	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
-	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
 	.rate_leaf_tx_share_set = mlx5_esw_devlink_rate_leaf_tx_share_set,
 	.rate_leaf_tx_max_set = mlx5_esw_devlink_rate_leaf_tx_max_set,
 	.rate_node_tx_share_set = mlx5_esw_devlink_rate_node_tx_share_set,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index d9c17481b972..78d12c377900 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -66,6 +66,8 @@ static void mlx5_esw_dl_port_free(struct devlink_port *dl_port)
 }
 
 static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
+	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
+	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
 };
 
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num)
@@ -139,6 +141,8 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 }
 
 static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
+	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
+	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
 };
 
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 6c5c05c414fb..9cbededdbe9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -503,12 +503,12 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 					struct netlink_ext_ack *extack);
 int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode *encap);
-int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
-					   u8 *hw_addr, int *hw_addr_len,
-					   struct netlink_ext_ack *extack);
-int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
-					   const u8 *hw_addr, int hw_addr_len,
-					   struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_hw_addr_get(struct devlink_port *port,
+				     u8 *hw_addr, int *hw_addr_len,
+				     struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_hw_addr_set(struct devlink_port *port,
+				     const u8 *hw_addr, int hw_addr_len,
+				     struct netlink_ext_ack *extack);
 int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
 				  struct netlink_ext_ack *extack);
 int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 76db72f339d6..7cbdb23c0e18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3953,9 +3953,9 @@ is_port_function_supported(struct mlx5_eswitch *esw, u16 vport_num)
 	       mlx5_esw_is_sf_vport(esw, vport_num);
 }
 
-int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
-					   u8 *hw_addr, int *hw_addr_len,
-					   struct netlink_ext_ack *extack)
+int mlx5_devlink_port_fn_hw_addr_get(struct devlink_port *port,
+				     u8 *hw_addr, int *hw_addr_len,
+				     struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw;
 	struct mlx5_vport *vport;
@@ -3982,9 +3982,9 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 	return 0;
 }
 
-int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
-					   const u8 *hw_addr, int hw_addr_len,
-					   struct netlink_ext_ack *extack)
+int mlx5_devlink_port_fn_hw_addr_set(struct devlink_port *port,
+				     const u8 *hw_addr, int hw_addr_len,
+				     struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw;
 	u16 vport_num;
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index f93437757ba3..0c5677edc9b6 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -26,46 +26,6 @@ struct efx_devlink {
 
 #ifdef CONFIG_SFC_SRIOV
 
-static const struct devlink_port_ops sfc_devlink_port_ops = {
-};
-
-static void efx_devlink_del_port(struct devlink_port *dl_port)
-{
-	if (!dl_port)
-		return;
-	devl_port_unregister(dl_port);
-}
-
-static int efx_devlink_add_port(struct efx_nic *efx,
-				struct mae_mport_desc *mport)
-{
-	bool external = false;
-
-	if (!ef100_mport_on_local_intf(efx, mport))
-		external = true;
-
-	switch (mport->mport_type) {
-	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
-		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL)
-			devlink_port_attrs_pci_vf_set(&mport->dl_port, 0, mport->pf_idx,
-						      mport->vf_idx,
-						      external);
-		else
-			devlink_port_attrs_pci_pf_set(&mport->dl_port, 0, mport->pf_idx,
-						      external);
-		break;
-	default:
-		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
-		return 0;
-	}
-
-	mport->dl_port.index = mport->mport_id;
-
-	return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
-					   mport->mport_id,
-					   &sfc_devlink_port_ops);
-}
-
 static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
 				     int *hw_addr_len,
 				     struct netlink_ext_ack *extack)
@@ -164,6 +124,48 @@ static int efx_devlink_port_addr_set(struct devlink_port *port,
 	return rc;
 }
 
+static const struct devlink_port_ops sfc_devlink_port_ops = {
+	.port_fn_hw_addr_get = efx_devlink_port_addr_get,
+	.port_fn_hw_addr_set = efx_devlink_port_addr_set,
+};
+
+static void efx_devlink_del_port(struct devlink_port *dl_port)
+{
+	if (!dl_port)
+		return;
+	devl_port_unregister(dl_port);
+}
+
+static int efx_devlink_add_port(struct efx_nic *efx,
+				struct mae_mport_desc *mport)
+{
+	bool external = false;
+
+	if (!ef100_mport_on_local_intf(efx, mport))
+		external = true;
+
+	switch (mport->mport_type) {
+	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
+		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL)
+			devlink_port_attrs_pci_vf_set(&mport->dl_port, 0, mport->pf_idx,
+						      mport->vf_idx,
+						      external);
+		else
+			devlink_port_attrs_pci_pf_set(&mport->dl_port, 0, mport->pf_idx,
+						      external);
+		break;
+	default:
+		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
+		return 0;
+	}
+
+	mport->dl_port.index = mport->mport_id;
+
+	return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
+					   mport->mport_id,
+					   &sfc_devlink_port_ops);
+}
+
 #endif
 
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
@@ -620,10 +622,6 @@ static int efx_devlink_info_get(struct devlink *devlink,
 
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
-#ifdef CONFIG_SFC_SRIOV
-	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
-	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
-#endif
 };
 
 #ifdef CONFIG_SFC_SRIOV
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6fd1697d0443..984829e9239e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1429,28 +1429,6 @@ struct devlink_ops {
 	int (*trap_policer_counter_get)(struct devlink *devlink,
 					const struct devlink_trap_policer *policer,
 					u64 *p_drops);
-	/**
-	 * @port_function_hw_addr_get: Port function's hardware address get function.
-	 *
-	 * Should be used by device drivers to report the hardware address of a function managed
-	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
-	 * function handling for a particular port.
-	 *
-	 * Note: @extack can be NULL when port notifier queries the port function.
-	 */
-	int (*port_function_hw_addr_get)(struct devlink_port *port, u8 *hw_addr,
-					 int *hw_addr_len,
-					 struct netlink_ext_ack *extack);
-	/**
-	 * @port_function_hw_addr_set: Port function's hardware address set function.
-	 *
-	 * Should be used by device drivers to set the hardware address of a function managed
-	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
-	 * function handling for a particular port.
-	 */
-	int (*port_function_hw_addr_set)(struct devlink_port *port,
-					 const u8 *hw_addr, int hw_addr_len,
-					 struct netlink_ext_ack *extack);
 	/**
 	 * @port_fn_roce_get: Port function's roce get function.
 	 *
@@ -1651,6 +1629,16 @@ void devlink_free(struct devlink *devlink);
  * @port_unsplit: Callback used to unsplit the port group back into
  *		  a single port.
  * @port_type_set: Callback used to set a type of a port.
+ * @port_fn_hw_addr_get: Callback used to set port function's hardware address.
+ *			 Should be used by device drivers to report
+ *			 the hardware address of a function managed
+ *			 by the devlink port.
+ * @port_fn_hw_addr_set: Callback used to set port function's hardware address.
+ *			 Should be used by device drivers to set the hardware
+ *			 address of a function managed by the devlink port.
+ *
+ * Note: Driver should return -EOPNOTSUPP if it doesn't support
+ * port function (@port_fn_*) handling for a particular port.
  */
 struct devlink_port_ops {
 	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
@@ -1659,6 +1647,12 @@ struct devlink_port_ops {
 			    struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
+	int (*port_fn_hw_addr_get)(struct devlink_port *port, u8 *hw_addr,
+				   int *hw_addr_len,
+				   struct netlink_ext_ack *extack);
+	int (*port_fn_hw_addr_set)(struct devlink_port *port,
+				   const u8 *hw_addr, int hw_addr_len,
+				   struct netlink_ext_ack *extack);
 };
 
 void devlink_port_init(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index b8fb96a8f4d6..fe38c4b2ab14 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -691,8 +691,7 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
-static int devlink_port_fn_hw_addr_fill(const struct devlink_ops *ops,
-					struct devlink_port *port,
+static int devlink_port_fn_hw_addr_fill(struct devlink_port *port,
 					struct sk_buff *msg,
 					struct netlink_ext_ack *extack,
 					bool *msg_updated)
@@ -701,10 +700,10 @@ static int devlink_port_fn_hw_addr_fill(const struct devlink_ops *ops,
 	int hw_addr_len;
 	int err;
 
-	if (!ops->port_function_hw_addr_get)
+	if (!port->ops || !port->ops->port_fn_hw_addr_get)
 		return 0;
 
-	err = ops->port_function_hw_addr_get(port, hw_addr, &hw_addr_len,
+	err = port->ops->port_fn_hw_addr_get(port, hw_addr, &hw_addr_len,
 					     extack);
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -884,8 +883,7 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 		return -EMSGSIZE;
 
 	ops = port->devlink->ops;
-	err = devlink_port_fn_hw_addr_fill(ops, port, msg, extack,
-					   &msg_updated);
+	err = devlink_port_fn_hw_addr_fill(port, msg, extack, &msg_updated);
 	if (err)
 		goto out;
 	err = devlink_port_fn_caps_fill(ops, port, msg, extack,
@@ -1156,7 +1154,6 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 					     const struct nlattr *attr,
 					     struct netlink_ext_ack *extack)
 {
-	const struct devlink_ops *ops = port->devlink->ops;
 	const u8 *hw_addr;
 	int hw_addr_len;
 
@@ -1177,7 +1174,7 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 		}
 	}
 
-	return ops->port_function_hw_addr_set(port, hw_addr, hw_addr_len,
+	return port->ops->port_fn_hw_addr_set(port, hw_addr, hw_addr_len,
 					      extack);
 }
 
@@ -1201,7 +1198,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 	struct nlattr *attr;
 
 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
-	    !ops->port_function_hw_addr_set) {
+	    (!devlink_port->ops || !devlink_port->ops->port_fn_hw_addr_set)) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
 				    "Port doesn't support function attributes");
 		return -EOPNOTSUPP;
-- 
2.39.2


