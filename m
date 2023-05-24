Return-Path: <netdev+bounces-4980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D3370F635
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22EE12812E4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B2C19508;
	Wed, 24 May 2023 12:19:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC38919504
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:19:02 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28709E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:19:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-513fd8cc029so1902436a12.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930739; x=1687522739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHLkWvb8hGc4er6p4IbdjeBQu5ETNgOVtKKvjXJWnfI=;
        b=bCkYgHF57bGwl36Vsna/jzuTp0Zr91eB1U0K+5Lhyf0nvh/ww+NOMWXyDn7XpMLTzC
         MQIkMc5xNhB1tU0/gKgWo6EG2SMI/MH2WRPutEatD1JN3BvAOeJQHYhRvZdZrIB5nGsw
         weqiJMkW9jECgUTSCGntuNq2/oSaTpbAi/gi1Lv5ea1tDQrpH+TLJNtUPqFJ9B8nWIKU
         qPZJK/bNkNnPoaEq5j8PIK0tdzfRicRiWeAo3rDZnJymX86PrRw7hzm71wk78Vn5noPU
         L9tfA8bQm3ZwiZNaevPnAXG4DCuem20NJ0aW0SrGFqs/hjYV0m3qBRaRhvPn9BiN/OIt
         g/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930739; x=1687522739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kHLkWvb8hGc4er6p4IbdjeBQu5ETNgOVtKKvjXJWnfI=;
        b=EuKTke74vo6bw/KSQSp33Mzl9lRv8RAT/J9/N/pLXI+DBTQsjyCDci5gaK3w2yOlAA
         FheqC5uNtr5HzZRjADjs3WiR4WZHXKvOe613LQbrqAWOL1eYWxeQUzDYP2Ga9aSh57FT
         VHs66ONV1CT3/xSTvAI4/Ydus/RbFK9rAmzzai1BLrUXZyILbVLn7hbjzl7WgUQVazuK
         5u5IKzWh0sVsL23eoWEh7CFPaD2OGwBPeJPrr7cf1ywDMM9NvzYNzicGsFioWsYhWoaJ
         rovF+Gtu+P29XC7z4WZPhL7SuCMrmZmYajk2ME0RRt+Kb9MZKnzSvzJgKVWT3X2JeSy7
         hnXg==
X-Gm-Message-State: AC+VfDyNXsm2Q6xpoOrV4wEoKKYYRvXdE9bpkXMp1QX1g3FHVl/PY8dJ
	ynAtPZ+jHh8qwZeaX2Z+9OCl2JqeFMqLKqZk2lOJqA==
X-Google-Smtp-Source: ACHHUZ7pifP5NkES/X7vgHySn9/N9YHhX2b5j3I0PlYIm+whKovrwOr93nGXxlG3+HQxIi7eY46pmQ==
X-Received: by 2002:a17:907:940b:b0:96f:bc31:5e0b with SMTP id dk11-20020a170907940b00b0096fbc315e0bmr12110096ejc.64.1684930739429;
        Wed, 24 May 2023 05:18:59 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w26-20020a170907271a00b0096599bf7029sm5788148ejk.145.2023.05.24.05.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:58 -0700 (PDT)
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
Subject: [patch net-next 14/15] devlink: move port_del() to devlink_port_ops
Date: Wed, 24 May 2023 14:18:35 +0200
Message-Id: <20230524121836.2070879-15-jiri@resnulli.us>
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

Move port_del() from devlink_ops into newly introduced devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  1 -
 .../mellanox/mlx5/core/esw/devlink_port.c     |  3 +++
 include/net/devlink.h                         | 22 +++++--------------
 net/devlink/leftover.c                        |  6 ++---
 4 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e39fd85ea2f9..63635cc44479 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -320,7 +320,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
-	.port_del = mlx5_devlink_sf_port_del,
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 76c5d6e9d47f..f370f67d9e33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -145,6 +145,9 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 }
 
 static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
+#ifdef CONFIG_MLX5_SF_MANAGER
+	.port_del = mlx5_devlink_sf_port_del,
+#endif
 	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
 	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
 	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 21254d6884ee..aeccab044358 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1447,23 +1447,6 @@ struct devlink_ops {
 	int (*port_new)(struct devlink *devlink,
 			const struct devlink_port_new_attrs *attrs,
 			struct netlink_ext_ack *extack);
-	/**
-	 * port_del() - Delete a port function
-	 * @devlink: Devlink instance
-	 * @port: The devlink port
-	 * @extack: extack for reporting error messages
-	 *
-	 * Devlink core will call this device driver function upon user request
-	 * to delete a previously created port function
-	 *
-	 * Notes:
-	 *	- On success, drivers must unregister the corresponding devlink
-	 *	  port
-	 *
-	 * Return: 0 on success, negative value otherwise.
-	 */
-	int (*port_del)(struct devlink *devlink, struct devlink_port *port,
-			struct netlink_ext_ack *extack);
 
 	/**
 	 * Rate control callbacks.
@@ -1560,6 +1543,9 @@ void devlink_free(struct devlink *devlink);
  * @port_unsplit: Callback used to unsplit the port group back into
  *		  a single port.
  * @port_type_set: Callback used to set a type of a port.
+ * @port_del: Callback used to delete selected port along with related function.
+ *	      Devlink core calls this upon user request to delete
+ *	      a port previously created by devlink_ops->port_new().
  * @port_fn_hw_addr_get: Callback used to set port function's hardware address.
  *			 Should be used by device drivers to report
  *			 the hardware address of a function managed
@@ -1602,6 +1588,8 @@ struct devlink_port_ops {
 			    struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
+	int (*port_del)(struct devlink *devlink, struct devlink_port *port,
+			struct netlink_ext_ack *extack);
 	int (*port_fn_hw_addr_get)(struct devlink_port *port, u8 *hw_addr,
 				   int *hw_addr_len,
 				   struct netlink_ext_ack *extack);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index ddff9815c651..b35dee4dddbc 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1350,7 +1350,7 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 	struct devlink_port_new_attrs new_attrs = {};
 	struct devlink *devlink = info->user_ptr[0];
 
-	if (!devlink->ops->port_new || !devlink->ops->port_del)
+	if (!devlink->ops->port_new)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
@@ -1389,10 +1389,10 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 
-	if (!devlink->ops->port_del)
+	if (!devlink_port->ops || !devlink_port->ops->port_del)
 		return -EOPNOTSUPP;
 
-	return devlink->ops->port_del(devlink, devlink_port, extack);
+	return devlink_port->ops->port_del(devlink, devlink_port, extack);
 }
 
 static int
-- 
2.39.2


