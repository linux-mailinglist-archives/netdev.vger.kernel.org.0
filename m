Return-Path: <netdev+bounces-5639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D480A7124C0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 808BA281815
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1468E168C1;
	Fri, 26 May 2023 10:29:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0378C156CF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:29:10 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B6F116
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:08 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f60e730bf2so6321265e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096947; x=1687688947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YufjcQHtbzkXlgZQA4plcBbsV/QNUtlmShq99rImNoU=;
        b=OTLi1fg4TzSnhTQv7udlrjt4RMYStLszy5yxZAlmcUp/+GZSjLai45CanYCKVOUAHY
         zLycC65QQY3g5SH1+/vowsgUUZsg6pxalnMzDjEZaI7d5MffQw+9+wz9CgRncU1ROcMN
         Ae7wSqWA/OZjxY/zpDoltB6+d6iFUeRi32bngFy+cwih8tw6gEOsqPLE9qQH9WfLO3fR
         YywbsHJKw0hwZT41YWR83sE+454TtftypqsrJfGDbSCuZQMg/yGhR/7G1HZnXzralGfu
         njjj1CjbUuxWRibOpH0Jt9xL34cUNGK4qy96u73gXiWNn2fu4tGriFlYj6D5ox6UZ2Ns
         rw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096947; x=1687688947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YufjcQHtbzkXlgZQA4plcBbsV/QNUtlmShq99rImNoU=;
        b=ihx2Y7EGv3ActDz0kQbo0SS3ZPeu60F5iP4u9pX1D2qoDYwhqACDwamcIKiqZPjOsD
         OiZn8WGlHWFawr1oTDsSGu8aCTJaI920A10NtRdeYX6q9zUq5j+0EaZ8/R9nDW8OucdY
         QwXiHPU6sgTCB/qUxo2oUqeN1AHVWFVD1m5zFCX02DNz4QU3wiOLEowEfKL1hoKNhZW8
         aBN+K1A+sS/+h5EnyhqlWViT3lQTUkVlf4zCdmXzVySm2mYyitNhAZGkyAMri0JeD0nB
         SRMUQcaPg1FHkY6zY9loPiemWohpDSd/qisoYwF5iH0P4df4CwS/Gh9YalWOCWoKneYW
         kaUw==
X-Gm-Message-State: AC+VfDzfL7iHuHyLsnLRLHiy6riWKqEBGdMsXU1SKyaqJWmfx9GiOH7B
	dwF16whv4j7rQXxR9WGt1Hs5v12d21OYXvptLVn6Aw==
X-Google-Smtp-Source: ACHHUZ62ni72nOKjqndEe3FW+BuYW8Bb5OLHzwCViwp12kkDK1djiQVhGldSAb5kPUZ/WsxJsFx0JQ==
X-Received: by 2002:a1c:ed0b:0:b0:3f6:b36:c337 with SMTP id l11-20020a1ced0b000000b003f60b36c337mr1084968wmh.1.1685096946980;
        Fri, 26 May 2023 03:29:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p20-20020a1c7414000000b003f60eb72cf5sm8511657wmc.2.2023.05.26.03.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:29:06 -0700 (PDT)
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
Subject: [patch net-next v2 14/15] devlink: move port_del() to devlink_port_ops
Date: Fri, 26 May 2023 12:28:40 +0200
Message-Id: <20230526102841.2226553-15-jiri@resnulli.us>
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

Move port_del() from devlink_ops into newly introduced devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- avoid ops check as they no longer could be null
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
index 03ce24a1397e..52aaa439caa5 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1348,7 +1348,7 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 	struct devlink_port_new_attrs new_attrs = {};
 	struct devlink *devlink = info->user_ptr[0];
 
-	if (!devlink->ops->port_new || !devlink->ops->port_del)
+	if (!devlink->ops->port_new)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
@@ -1387,10 +1387,10 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 
-	if (!devlink->ops->port_del)
+	if (!devlink_port->ops->port_del)
 		return -EOPNOTSUPP;
 
-	return devlink->ops->port_del(devlink, devlink_port, extack);
+	return devlink_port->ops->port_del(devlink, devlink_port, extack);
 }
 
 static int
-- 
2.39.2


