Return-Path: <netdev+bounces-6249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F8C715598
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC1211C20B03
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C7D4C78;
	Tue, 30 May 2023 06:38:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0815B7E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:38:45 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241D810E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:38:33 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f623adec61so42308655e9.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685428711; x=1688020711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BsESgppsPw+/s7Jzu1Tno4p2CYh340FBnYCkFXYwoVA=;
        b=RyzaBHi1N7LZAgX4geCfzT4ZnIWo05fvKDBGwhU2yBCPmGc3xvK6Wb4okIyLfI+glM
         yx0V+VO2tMJM+wKpGYql6jrX2ujL2S1YT/TDz9RvWrIHAMmnXUn89CReUWtv/iBuNbWJ
         p5IQHIfeHuN4mTvXnoYVMVwkHIWbo/H8qHHrtZ8Fc3Brj5BPtyNMApIWOZnRbRlgEShr
         T2CpRE6gilvBkhCGrUJJv4UsKAfIWUGgrkl5+w9oSTOuEKjzZF8OvAGlqBuBM+bdJvKp
         5bS3qEKlst75LlWW0ABePPBqknYdyEAyL1JdAvkeqPpxMaWBYuJnG7xAv2Dp2C5x72SH
         aS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685428711; x=1688020711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BsESgppsPw+/s7Jzu1Tno4p2CYh340FBnYCkFXYwoVA=;
        b=NzgtmpHgU3TCouUpfFSaNXLSj7+NOe2OdOI3T7mEeCLvus/CGvdAqko91NAFkIXL8c
         QOkWbmkMvGLBUTqooo+N5nOBfCEG3MITFe8i8rxasY+bBEbNCi3MbwKFgtToFxzIQRcr
         KfemJBy6nCDszlkUnJA58TbXtdArDUIY0ho02eSrky62+iSM4kNF+Fjfy9eVy002MQye
         yfshW/kw+ELqVtSXPvlNZg9YjJP+CsZ1J5gsj1Nhqfh6wbcTAxNKzU3RNWWfHH7MvJ2w
         ln4h5/cD44vxhAYoehJVFqsDm+c1dgIagjSpKyO5aFxZXCnnRiFuI7eWi3AMyDWUrN9V
         MrJw==
X-Gm-Message-State: AC+VfDwSK8aXB8BJH1xjVDFL0y0hhPyd9TgCAPleDgW8SLse8iHPVQOQ
	c1xuehH9/lroTCIZgZZtx75LkP1Q/Kpvj0/gBsY=
X-Google-Smtp-Source: ACHHUZ7lL/Bx8fKLxSb1jQJYCcXju32xzLfaAmHxT764qe5+qop7HWdYkIq+gE+P6S75mGwaRVjzag==
X-Received: by 2002:a05:600c:c3:b0:3f6:3e4:7cc9 with SMTP id u3-20020a05600c00c300b003f603e47cc9mr663538wmm.40.1685428711309;
        Mon, 29 May 2023 23:38:31 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f8-20020a1c6a08000000b003f41bb52834sm20087269wmc.38.2023.05.29.23.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:38:30 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	saeedm@nvidia.com,
	moshe@nvidia.com,
	simon.horman@corigine.com,
	leon@kernel.org
Subject: [patch net-next] devlink: bring port new reply back
Date: Tue, 30 May 2023 08:38:29 +0200
Message-Id: <20230530063829.2493909-1-jiri@resnulli.us>
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
index ec109b39c3ea..2ddb9dad3225 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1500,6 +1500,7 @@ struct devlink_ops {
 	 * @devlink: Devlink instance
 	 * @attrs: attributes of the new port
 	 * @extack: extack for reporting error messages
+	 * @devlink_port: pointer to store new devlink port pointer
 	 *
 	 * Devlink core will call this device driver function upon user request
 	 * to create a new port function of a specified flavor and optional
@@ -1512,7 +1513,8 @@ struct devlink_ops {
 	 */
 	int (*port_new)(struct devlink *devlink,
 			const struct devlink_port_new_attrs *attrs,
-			struct netlink_ext_ack *extack);
+			struct netlink_ext_ack *extack,
+			struct devlink_port **devlink_port);
 	/**
 	 * port_del() - Delete a port function
 	 * @devlink: Devlink instance
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 9e801b749194..269aa1a6a13c 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1360,6 +1360,9 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink_port_new_attrs new_attrs = {};
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_port *devlink_port;
+	struct sk_buff *msg;
+	int err;
 
 	if (!devlink->ops->port_new || !devlink->ops->port_del)
 		return -EOPNOTSUPP;
@@ -1390,7 +1393,30 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
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
+	devlink->ops->port_del(devlink, devlink_port, NULL);
+	return err;
 }
 
 static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
-- 
2.39.2


