Return-Path: <netdev+bounces-4671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 514B970DCBF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77220281273
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB131E50A;
	Tue, 23 May 2023 12:39:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E8B1EA69
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:39:15 +0000 (UTC)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416D8118
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:13 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2af2c7f2883so42524881fa.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684845491; x=1687437491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXc2tgHtY8JsvHvYi5Y3WaNSHc2OvVQzrpUhvy+ObpU=;
        b=1ZsYizzZALjXrgL5hAm6Jftznrsf2J1WC7xUcpPuY179tT+3wzLENH8dBfLvaq4YxX
         CVlmUEz20kBKtc2PLwtIC463XcKMZS4cyxKp0JJVSflXGMPtUqMjVNBYczByyS4hn1od
         m9XawRaYvnCJXMjF6hybldeMsd9gJhFm0Bzvn2H/xoBypuRzLRo+Vg0hMg/D3hZdOOfq
         vInA495EcOjmh0PPcXufkRhB7u5hySQJHpuM+MdWHmA98p+ziGNYfwNPSiRH//Cqh68k
         TFNKWRDJQVIdZlFJQ62wK29Ef4y3EYwzsef1+VYWX8l/qM56+wlgB3UmWRs1i+DxmfVf
         WyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684845491; x=1687437491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXc2tgHtY8JsvHvYi5Y3WaNSHc2OvVQzrpUhvy+ObpU=;
        b=d6NXZE9OaCgvmDVXrnjYzq4qjfuYgUz2ZuruZdj6xzRqrZcf97JaB9BkUaxjgz4VrQ
         tTlQgqxqR44Ok/NTVheemHTAHEyK8m57DM6KE7JWhjKzkAdk/x6Oa7Rj+QNOwBu6jQXj
         WGTuLjdQBIOjT/paAR/UHYt9qgbVEsoSQ4tzSdXXxIJ40CV2+wdmREtpTA8K96g0TczQ
         Nn9jQrAmX9EwDAeMLCovUARX9WT0hgIoqsIdPGUg4zRN9kCc5wEfci4ED416JVykeSf9
         dQjjG5Cy1lXFaj2kX9Kz7oTbJSIEzMuPEVV+H9QjExu/Q21lyg4IJZ/PoBV5675mCXEc
         g2/w==
X-Gm-Message-State: AC+VfDwkgnE985Ch/az8Ho9zcnMGg1O/5U34kpbMpYjMBNLo217p0qV2
	rjQoYPpKFAwWMh+By5B5WeYUTnaNEAOrmV+8Rhg=
X-Google-Smtp-Source: ACHHUZ6tvorTVdyguFLqKXgTRxKAu5+VBK/FRYO2PhZOtvB1jUf1O6i0rDtEKB1mB3TeJfPikr+OSQ==
X-Received: by 2002:a2e:8659:0:b0:2a8:ac5c:d8f1 with SMTP id i25-20020a2e8659000000b002a8ac5cd8f1mr5364974ljj.1.1684845491287;
        Tue, 23 May 2023 05:38:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z19-20020a2e8853000000b002a8ecae9567sm1605937ljj.84.2023.05.23.05.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 05:38:10 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net-next 3/3] devlink: pass devlink_port pointer to ops->port_del() instead of index
Date: Tue, 23 May 2023 14:38:01 +0200
Message-Id: <20230523123801.2007784-4-jiri@resnulli.us>
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

Historically there was a reason why port_dev() along with for example
port_split() did get port_index instead of the devlink_port pointer.
With the locking changes that were done which ensured devlink instance
mutex is hold for every command, the port ops could get devlink_port
pointer directly. Change the forgotten port_dev() op to be as others
and pass devlink_port pointer instead of port_index.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h      |  3 ++-
 include/net/devlink.h                                |  4 ++--
 net/devlink/leftover.c                               | 11 +++--------
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index de15b9c85e1b..c7d4691cb65a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -376,7 +376,8 @@ static void mlx5_sf_dealloc(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 	}
 }
 
-int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
+int mlx5_devlink_sf_port_del(struct devlink *devlink,
+			     struct devlink_port *dl_port,
 			     struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -391,7 +392,7 @@ int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 				   "Port del is only supported in eswitch switchdev mode or SF ports are disabled.");
 		return -EOPNOTSUPP;
 	}
-	sf = mlx5_sf_lookup_by_index(table, port_index);
+	sf = mlx5_sf_lookup_by_index(table, dl_port->index);
 	if (!sf) {
 		err = -ENODEV;
 		goto sf_err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 1f7d8cbd72e8..c5430b8dcdf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -21,7 +21,8 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *add_attr,
 			     struct netlink_ext_ack *extack);
-int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
+int mlx5_devlink_sf_port_del(struct devlink *devlink,
+			     struct devlink_port *dl_port,
 			     struct netlink_ext_ack *extack);
 int mlx5_devlink_sf_port_fn_state_get(struct devlink_port *dl_port,
 				      enum devlink_port_fn_state *state,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 24a48f3d4c35..1bd56c8d6f3c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1516,7 +1516,7 @@ struct devlink_ops {
 	/**
 	 * port_del() - Delete a port function
 	 * @devlink: Devlink instance
-	 * @port_index: port function index to delete
+	 * @port: The devlink port
 	 * @extack: extack for reporting error messages
 	 *
 	 * Devlink core will call this device driver function upon user request
@@ -1528,7 +1528,7 @@ struct devlink_ops {
 	 *
 	 * Return: 0 on success, negative value otherwise.
 	 */
-	int (*port_del)(struct devlink *devlink, unsigned int port_index,
+	int (*port_del)(struct devlink *devlink, struct devlink_port *port,
 			struct netlink_ext_ack *extack);
 	/**
 	 * port_fn_state_get() - Get the state of a port function
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index cb60e42b2761..0410137a4a31 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1396,20 +1396,14 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
-	unsigned int port_index;
 
 	if (!devlink->ops->port_del)
 		return -EOPNOTSUPP;
 
-	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PORT_INDEX)) {
-		NL_SET_ERR_MSG(extack, "Port index is not specified");
-		return -EINVAL;
-	}
-	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
-
-	return devlink->ops->port_del(devlink, port_index, extack);
+	return devlink->ops->port_del(devlink, devlink_port, extack);
 }
 
 static int
@@ -6341,6 +6335,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_PORT_DEL,
 		.doit = devlink_nl_cmd_port_del_doit,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_LINECARD_GET,
-- 
2.39.2


