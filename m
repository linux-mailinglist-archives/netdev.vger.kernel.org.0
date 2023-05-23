Return-Path: <netdev+bounces-4669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6E070DCBD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 805051C20D51
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C531D2D1;
	Tue, 23 May 2023 12:39:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBE41D2BF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:39:13 +0000 (UTC)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD1B118
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:08 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4f380cd1019so8267510e87.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684845486; x=1687437486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIjp12QYx65PHQVD6D8YunmaAHZpk/I/cj/MnWmrubw=;
        b=1G+UX52R1++U4iwz/Xv9oXVcVVL6Ao4oIZ+H7GE/cEtadfRc7FEOTgJUiKfjLe0FhN
         24D0C809wlBms8slmVHorZkDw10vXMgz+06ymmYxEXox0hFqgvtJLA0ZO29NF84ZZLi6
         J7vrghcBBGCRabUaZOfFKUCl+LdzigrkGbQrT1Y6hh1lU6uwtOqKLDIJ/wnPZ9wciZY2
         2iHekJFG5A/WVLqUJAh10fJN2eLlFxRQSBsBAAQpXnyCGzzKQtD4R2otV20l29DV44Fl
         XdXun9A2tcvIX5JjmAmMl35a1lNPHKCJpPZqwINDsyo8lLaWVCuDZgDLobmJmPpxJgn4
         4Ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684845486; x=1687437486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIjp12QYx65PHQVD6D8YunmaAHZpk/I/cj/MnWmrubw=;
        b=kzYkk4MxVZCzwL2Kv9+kA1dXIODlSopCJP9I8av2joDCnlSV0WUgUr2tOTN++cuj0i
         TOmcy6BRgEy5i2RqRYH8dfoSvGFMDz32vZjTxX5JsCNJ5wOUZCqNbPcx+aa0qxC0X7af
         y7WZGhOOWAc8x1ZnmuvYSCanUkyl5+xMEfCE6y8mJNl7YgqfLZLE/lF6HQT4VJfI92Ib
         gxYf4LAzbLrQ1RMr6tTyHrin9j40ObfKQvdrIxvKFcBRg/AFwCLdLkIu1Fy+HnrrouQs
         mUe77tHiXYcWun38seVkK3GlKt8iygnUgS3mGNFrUDPrgc4bgbR8nVrUzIMtIXsWLt+1
         vTpg==
X-Gm-Message-State: AC+VfDxyO7rd10UI7NmhCcqAlcwFaajXyDhb5lVF6fsx7Dztao+fvfhS
	AeCH+HYdE0Dco14aM7eakBCMl8qsQu8WnnwvoTI=
X-Google-Smtp-Source: ACHHUZ4Y0qbwq+RcNI3xhcWpJuDtg1kc7iFQZQf3WYGowoQplfoeDFWvwJhzBn/HK7Btjc4lbDEczw==
X-Received: by 2002:ac2:5fae:0:b0:4b5:61e8:8934 with SMTP id s14-20020ac25fae000000b004b561e88934mr3796646lfe.64.1684845486426;
        Tue, 23 May 2023 05:38:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 7-20020ac24847000000b004efefb9fcb3sm1315938lfy.268.2023.05.23.05.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 05:38:05 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net-next 1/3] devlink: remove duplicate port notification
Date: Tue, 23 May 2023 14:37:59 +0200
Message-Id: <20230523123801.2007784-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523123801.2007784-1-jiri@resnulli.us>
References: <20230523123801.2007784-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

The notification about created port is send from devl_port_register()
function called from ops->port_new(). No need to send it again here,
so remove the call and the helper function.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  9 ++--
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  3 +-
 include/net/devlink.h                         |  4 +-
 net/devlink/leftover.c                        | 45 +------------------
 4 files changed, 6 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 7d955a4d9f14..de15b9c85e1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -282,8 +282,7 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
 
 static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 		       const struct devlink_port_new_attrs *new_attr,
-		       struct netlink_ext_ack *extack,
-		       unsigned int *new_port_index)
+		       struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	struct mlx5_sf *sf;
@@ -297,7 +296,6 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 						new_attr->controller, new_attr->sfnum);
 	if (err)
 		goto esw_err;
-	*new_port_index = sf->port_index;
 	trace_mlx5_sf_add(dev, sf->port_index, sf->controller, sf->hw_fn_id, new_attr->sfnum);
 	return 0;
 
@@ -338,8 +336,7 @@ mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_
 
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *new_attr,
-			     struct netlink_ext_ack *extack,
-			     unsigned int *new_port_index)
+			     struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	struct mlx5_sf_table *table;
@@ -355,7 +352,7 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 				   "Port add is only supported in eswitch switchdev mode or SF ports are disabled.");
 		return -EOPNOTSUPP;
 	}
-	err = mlx5_sf_add(dev, table, new_attr, extack, new_port_index);
+	err = mlx5_sf_add(dev, table, new_attr, extack);
 	mlx5_sf_table_put(table);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 3a480e06ecc0..1f7d8cbd72e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -20,8 +20,7 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
 
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *add_attr,
-			     struct netlink_ext_ack *extack,
-			     unsigned int *new_port_index);
+			     struct netlink_ext_ack *extack);
 int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 			     struct netlink_ext_ack *extack);
 int mlx5_devlink_sf_port_fn_state_get(struct devlink_port *dl_port,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6a942e70e451..ccea6e079777 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1500,7 +1500,6 @@ struct devlink_ops {
 	 * @devlink: Devlink instance
 	 * @attrs: attributes of the new port
 	 * @extack: extack for reporting error messages
-	 * @new_port_index: index of the new port
 	 *
 	 * Devlink core will call this device driver function upon user request
 	 * to create a new port function of a specified flavor and optional
@@ -1515,8 +1514,7 @@ struct devlink_ops {
 	 */
 	int (*port_new)(struct devlink *devlink,
 			const struct devlink_port_new_attrs *attrs,
-			struct netlink_ext_ack *extack,
-			unsigned int *new_port_index);
+			struct netlink_ext_ack *extack);
 	/**
 	 * port_del() - Delete a port function
 	 * @devlink: Devlink instance
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index cd0254968076..cb60e42b2761 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1354,45 +1354,12 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 	return devlink->ops->port_unsplit(devlink, devlink_port, info->extack);
 }
 
-static int devlink_port_new_notify(struct devlink *devlink,
-				   unsigned int port_index,
-				   struct genl_info *info)
-{
-	struct devlink_port *devlink_port;
-	struct sk_buff *msg;
-	int err;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	lockdep_assert_held(&devlink->lock);
-	devlink_port = devlink_port_get_by_index(devlink, port_index);
-	if (!devlink_port) {
-		err = -ENODEV;
-		goto out;
-	}
-
-	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_NEW,
-				   info->snd_portid, info->snd_seq, 0, NULL);
-	if (err)
-		goto out;
-
-	return genlmsg_reply(msg, info);
-
-out:
-	nlmsg_free(msg);
-	return err;
-}
-
 static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink_port_new_attrs new_attrs = {};
 	struct devlink *devlink = info->user_ptr[0];
-	unsigned int new_port_index;
-	int err;
 
 	if (!devlink->ops->port_new || !devlink->ops->port_del)
 		return -EOPNOTSUPP;
@@ -1423,17 +1390,7 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 		new_attrs.sfnum_valid = true;
 	}
 
-	err = devlink->ops->port_new(devlink, &new_attrs, extack,
-				     &new_port_index);
-	if (err)
-		return err;
-
-	err = devlink_port_new_notify(devlink, new_port_index, info);
-	if (err && err != -ENODEV) {
-		/* Fail to send the response; destroy newly created port. */
-		devlink->ops->port_del(devlink, new_port_index, extack);
-	}
-	return err;
+	return devlink->ops->port_new(devlink, &new_attrs, extack);
 }
 
 static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
-- 
2.39.2


