Return-Path: <netdev+bounces-6815-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7227184B2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88ACA1C20F24
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F38154B8;
	Wed, 31 May 2023 14:20:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0506B1429C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:20:49 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3771B8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:20:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-307d58b3efbso4260561f8f.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685542827; x=1688134827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NW6pv0ys5yjotNp1e2w5du2XPtksodoULpWFRsKNaZo=;
        b=hXfCGjExdxvLKY6Px6xUjlSHNx7oL8mPxou3eVQHm+6E9AHrCduSp1oor/NhBoybdW
         f08HP13B3rcF2leeYVZjM8L9z2wtxNrXkFicmU+jrcUtpaD/wUAgibvctEz6FMdrNHOU
         GASY6CGQf5riWPgtgMUaLgo+Ym+k9XlB+CvpJ8urcMbCy0I/S803vXSY6DT4CRAryH6N
         cyx3baqZWcXjRRHSiuTF21q1fNW2OJQvtSTXTmVxYk+LANCYHEdXpjVyrkmA4AVcqpnv
         5f4dAGPMVKc/xGwBPWlIzaBUZZsP424G/1iSOf0iamNgmDexbfQWdgXQozDb4BGApVTQ
         F3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685542827; x=1688134827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NW6pv0ys5yjotNp1e2w5du2XPtksodoULpWFRsKNaZo=;
        b=eHza6Me+gX/gHzg3uRiBagf/wdZh+nkA/RvoIzxo9tjx8+cUvKIGPWrZE+j2pIGJs0
         LmiwW5C4wry22d7LGofWT840LZ0ahsI6X85qB6IaXq15xHvRQqnIueBEc8MF0glyTWXz
         f9TUCOkZVE7+HXurU3lmrKG8fy5gbVccpvjWRa56t+WroiZIA6+ZiC3fbeCf/L1hYJ4B
         W3jFFO7lOdV8M/EYNnS3n75SaTEg3PfxpYUS/PPzrhukx+bRzBJaE/HPR6JOFhxmD96+
         GKNbZTyIhfgZL6SYx5C8CFwhRSomBYCKV7X4b2CdFGgtTcJOWT79xRFneYyUQSgG/KjU
         SeYg==
X-Gm-Message-State: AC+VfDzQSgXvlVi0NoYzB4pBefXlULFMmveKVd1vjhyVKaU6qNxDb8Pf
	QTR20XefTO3HExNTs799Z2utSaFMFlKpdgRuSv0=
X-Google-Smtp-Source: ACHHUZ52aicufxTwI/U0zh9B4d1AdfOU/jMPyOrNcbA2YSAqBA4Ep0tPCnQklcjN+Jwm3Af+v3z98Q==
X-Received: by 2002:a05:6000:14d:b0:309:1c89:c618 with SMTP id r13-20020a056000014d00b003091c89c618mr4171719wrx.56.1685542827040;
        Wed, 31 May 2023 07:20:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h12-20020a5d6e0c000000b002ca864b807csm7130922wrz.0.2023.05.31.07.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 07:20:26 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com,
	tariqt@nvidia.com,
	simon.horman@corigine.com
Subject: [patch net-next v2] devlink: bring port new reply back
Date: Wed, 31 May 2023 16:20:25 +0200
Message-Id: <20230531142025.2605001-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
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

In the offending fixes commit I mistakenly removed the reply message of
the port new command. I was under impression it is a new port
notification, partly due to the "notify" in the name of the helper
function. Bring the code sending reply with new port message back, this
time putting it directly to devlink_nl_cmd_port_new_doit()

Fixes: c496daeb8630 ("devlink: remove duplicate port notification")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- rebased on top of port_ops patchset
---
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  9 ++++--
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  3 +-
 include/net/devlink.h                         |  4 ++-
 net/devlink/leftover.c                        | 28 ++++++++++++++++++-
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index c7d4691cb65a..9c02e5ea797c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -282,7 +282,8 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
 
 static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 		       const struct devlink_port_new_attrs *new_attr,
-		       struct netlink_ext_ack *extack)
+		       struct netlink_ext_ack *extack,
+		       struct devlink_port **dl_port)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	struct mlx5_sf *sf;
@@ -296,6 +297,7 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 						new_attr->controller, new_attr->sfnum);
 	if (err)
 		goto esw_err;
+	*dl_port = &sf->dl_port;
 	trace_mlx5_sf_add(dev, sf->port_index, sf->controller, sf->hw_fn_id, new_attr->sfnum);
 	return 0;
 
@@ -336,7 +338,8 @@ mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_
 
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *new_attr,
-			     struct netlink_ext_ack *extack)
+			     struct netlink_ext_ack *extack,
+			     struct devlink_port **dl_port)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	struct mlx5_sf_table *table;
@@ -352,7 +355,7 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 				   "Port add is only supported in eswitch switchdev mode or SF ports are disabled.");
 		return -EOPNOTSUPP;
 	}
-	err = mlx5_sf_add(dev, table, new_attr, extack);
+	err = mlx5_sf_add(dev, table, new_attr, extack, dl_port);
 	mlx5_sf_table_put(table);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index c5430b8dcdf6..860f9ddb7107 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -20,7 +20,8 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
 
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *add_attr,
-			     struct netlink_ext_ack *extack);
+			     struct netlink_ext_ack *extack,
+			     struct devlink_port **dl_port);
 int mlx5_devlink_sf_port_del(struct devlink *devlink,
 			     struct devlink_port *dl_port,
 			     struct netlink_ext_ack *extack);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index fe42ad46cf3b..9a3c51aa6e81 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1434,6 +1434,7 @@ struct devlink_ops {
 	 * @devlink: Devlink instance
 	 * @attrs: attributes of the new port
 	 * @extack: extack for reporting error messages
+	 * @devlink_port: pointer to store new devlink port pointer
 	 *
 	 * Devlink core will call this device driver function upon user request
 	 * to create a new port function of a specified flavor and optional
@@ -1446,7 +1447,8 @@ struct devlink_ops {
 	 */
 	int (*port_new)(struct devlink *devlink,
 			const struct devlink_port_new_attrs *attrs,
-			struct netlink_ext_ack *extack);
+			struct netlink_ext_ack *extack,
+			struct devlink_port **devlink_port);
 
 	/**
 	 * Rate control callbacks.
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index d5ca9fbe2d40..649a9701eb6a 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1347,6 +1347,9 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink_port_new_attrs new_attrs = {};
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_port *devlink_port;
+	struct sk_buff *msg;
+	int err;
 
 	if (!devlink->ops->port_new)
 		return -EOPNOTSUPP;
@@ -1377,7 +1380,30 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 		new_attrs.sfnum_valid = true;
 	}
 
-	return devlink->ops->port_new(devlink, &new_attrs, extack);
+	err = devlink->ops->port_new(devlink, &new_attrs,
+				     extack, &devlink_port);
+	if (err)
+		return err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto err_out_port_del;
+	}
+	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_NEW,
+				   info->snd_portid, info->snd_seq, 0, NULL);
+	if (WARN_ON_ONCE(err))
+		goto err_out_msg_free;
+	err = genlmsg_reply(msg, info);
+	if (err)
+		goto err_out_port_del;
+	return 0;
+
+err_out_msg_free:
+	nlmsg_free(msg);
+err_out_port_del:
+	devlink_port->ops->port_del(devlink, devlink_port, NULL);
+	return err;
 }
 
 static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
-- 
2.39.2


