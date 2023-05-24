Return-Path: <netdev+bounces-4971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA9170F61B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88CA7280612
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B582E182D9;
	Wed, 24 May 2023 12:18:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6B8182A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:48 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023F7184
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-96f5685f902so125372166b.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930725; x=1687522725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkYJGO774FXuE0CJQn4Jxs9ivc+UjknqYrDbRPACZ6w=;
        b=b0o1gswOB8TfjaK7TsTbtuepG/UrZRgD5M7ztAypwGI9alfczGRYVIP7vPkpvmg5Fm
         U0MipGE5QdIKIyPMYRrXuhXlKDh4Ac+T9hepqFwBMBvZJDW00KsC8uXYtx6YsNVbv/KN
         FcpuFEf+XSyKcNhIrVx7PPmVmJnAApdeqDy/E0lO4ZQ4G9xqep+JXSEy8cictRLmQy+7
         5uEghRmV7te5HQzSv+7ratgBhwC1C47Yc1PMata+vC0aShNX65uErzi40de+SY18s8qb
         SKjzI+Q1n3IwlLSJVKSxgaWcpMVwl+oiFjJs1q6/SgE98/hSlrfVoOJK2OCSrHtNue8u
         56BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930725; x=1687522725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NkYJGO774FXuE0CJQn4Jxs9ivc+UjknqYrDbRPACZ6w=;
        b=A10Tx2zmG2WpSBeRk++UYt0wGROhdcSm/PxqSkdI9fQh+cg+o3mN54fJVIBry16GjK
         Xo6RU/0ByCNS0IHGz0/kRaQ+j9B+Jc4NJkR85YqXm7Ef52oiPYoTpF6xHxrcyORU6+YH
         cVvkap27WRmygw8fD52Ye/6ovibkqEBwP25uZYBwgVrpgK/8NOW+jLshBA/fg3Yjyvtg
         GzsZSvtbeMSTjZzNdsLbmxjhH5DR2sFBrrR6nv2/M0XvdpV3Do+v+kApwsChBMe+MZhH
         lhcEYWO5LL3aXDw/InZqK5h++KtQm0D9Mf+VrcjJG7K7t6AaBKKLsW9mfVI2GIzJF7xA
         llbg==
X-Gm-Message-State: AC+VfDya5RfyoTagIn79BC1Z8zNyzqiugS8iJBwcdJaUPHYtqvC6f8GJ
	FxMnVkuavJJ0J8rgmI9CFq/XuGOvGF5V2tj+JOiL9g==
X-Google-Smtp-Source: ACHHUZ6xvFk88IKkpT4Pb/fT+riSpRLrijqJYs1Df2N8a+xewBARzDO2I5J0CVsLXTbmKRkDpx8aJA==
X-Received: by 2002:a17:907:709:b0:965:6075:d0e1 with SMTP id xb9-20020a170907070900b009656075d0e1mr16360788ejb.72.1684930725477;
        Wed, 24 May 2023 05:18:45 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id lr22-20020a170906fb9600b00969cbd5718asm5665063ejb.48.2023.05.24.05.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:44 -0700 (PDT)
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
Subject: [patch net-next 05/15] devlink: move port_split/unsplit() ops into devlink_port_ops
Date: Wed, 24 May 2023 14:18:26 +0200
Message-Id: <20230524121836.2070879-6-jiri@resnulli.us>
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

Move port_split/unsplit() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c     |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/core.c       |  4 ++--
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c |  4 ++--
 include/net/devlink.h                            | 11 +++++++----
 net/devlink/leftover.c                           | 10 +++++-----
 5 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 6661d12772a3..80dc5445b50d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1256,8 +1256,6 @@ static const struct devlink_ops ice_devlink_ops = {
 			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down = ice_devlink_reload_down,
 	.reload_up = ice_devlink_reload_up,
-	.port_split = ice_devlink_port_split,
-	.port_unsplit = ice_devlink_port_unsplit,
 	.eswitch_mode_get = ice_eswitch_mode_get,
 	.eswitch_mode_set = ice_eswitch_mode_set,
 	.info_get = ice_devlink_info_get,
@@ -1513,6 +1511,8 @@ ice_devlink_set_port_split_options(struct ice_pf *pf,
 }
 
 static const struct devlink_port_ops ice_devlink_port_ops = {
+	.port_split = ice_devlink_port_split,
+	.port_unsplit = ice_devlink_port_unsplit,
 };
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 605881b17ccc..1ccf3b73ed72 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1723,8 +1723,6 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 				  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
-	.port_split			= mlxsw_devlink_port_split,
-	.port_unsplit			= mlxsw_devlink_port_unsplit,
 	.sb_pool_get			= mlxsw_devlink_sb_pool_get,
 	.sb_pool_set			= mlxsw_devlink_sb_pool_set,
 	.sb_port_pool_get		= mlxsw_devlink_sb_port_pool_get,
@@ -3117,6 +3115,8 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
 EXPORT_SYMBOL(mlxsw_core_res_get);
 
 static const struct devlink_port_ops mlxsw_devlink_port_ops = {
+	.port_split			= mlxsw_devlink_port_split,
+	.port_unsplit			= mlxsw_devlink_port_unsplit,
 };
 
 static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 4e4296ecae7c..8c6954c58a88 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -311,8 +311,6 @@ nfp_devlink_flash_update(struct devlink *devlink,
 }
 
 const struct devlink_ops nfp_devlink_ops = {
-	.port_split		= nfp_devlink_port_split,
-	.port_unsplit		= nfp_devlink_port_unsplit,
 	.sb_pool_get		= nfp_devlink_sb_pool_get,
 	.sb_pool_set		= nfp_devlink_sb_pool_set,
 	.eswitch_mode_get	= nfp_devlink_eswitch_mode_get,
@@ -322,6 +320,8 @@ const struct devlink_ops nfp_devlink_ops = {
 };
 
 static const struct devlink_port_ops nfp_devlink_port_ops = {
+	.port_split		= nfp_devlink_port_split,
+	.port_unsplit		= nfp_devlink_port_unsplit,
 };
 
 int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 850148b98f70..6ddb1fb905b2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1276,10 +1276,6 @@ struct devlink_ops {
 			 struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
-	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
-			  unsigned int count, struct netlink_ext_ack *extack);
-	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
-			    struct netlink_ext_ack *extack);
 	int (*sb_pool_get)(struct devlink *devlink, unsigned int sb_index,
 			   u16 pool_index,
 			   struct devlink_sb_pool_info *pool_info);
@@ -1653,8 +1649,15 @@ void devlink_free(struct devlink *devlink);
 
 /**
  * struct devlink_port_ops - Port operations
+ * @port_split: Callback used to split the port into multiple ones.
+ * @port_unsplit: Callback used to unsplit the port group back into
+ *		  a single port.
  */
 struct devlink_port_ops {
+	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
+			  unsigned int count, struct netlink_ext_ack *extack);
+	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
+			    struct netlink_ext_ack *extack);
 };
 
 void devlink_port_init(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index ff1c2ed84aba..8646861127a0 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1320,7 +1320,7 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 
 	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PORT_SPLIT_COUNT))
 		return -EINVAL;
-	if (!devlink->ops->port_split)
+	if (!devlink_port->ops || !devlink_port->ops->port_split)
 		return -EOPNOTSUPP;
 
 	count = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT]);
@@ -1339,8 +1339,8 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	return devlink->ops->port_split(devlink, devlink_port, count,
-					info->extack);
+	return devlink_port->ops->port_split(devlink, devlink_port, count,
+					     info->extack);
 }
 
 static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
@@ -1349,9 +1349,9 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = info->user_ptr[0];
 
-	if (!devlink->ops->port_unsplit)
+	if (!devlink_port->ops || !devlink_port->ops->port_unsplit)
 		return -EOPNOTSUPP;
-	return devlink->ops->port_unsplit(devlink, devlink_port, info->extack);
+	return devlink_port->ops->port_unsplit(devlink, devlink_port, info->extack);
 }
 
 static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
-- 
2.39.2


