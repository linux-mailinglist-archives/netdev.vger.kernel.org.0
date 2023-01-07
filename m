Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D401660D5F
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjAGJtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjAGJtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:49:24 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680B37DE1A
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:49:20 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y1so4258219plb.2
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxn2R3Zq6Tw0lN1kjveUcYSsFlHI5w7882f4dWmiIs8=;
        b=LoAHDDisDvZFGSad9Q5W5e8/x14e/yzLrN24IPRMmNjYpItsvl/++/ktQq/x7LTJDD
         yAYdxrA7OituaYX+rAyf7a0rgC+hbpD9laaOJmezgsOfu+lzj/R2/gQdhm8YyAp05/od
         nL6G0O862CGloHIjby2e9jvoEL8iT8JrTpE+pJHWk3SyYGT0+2TzX6QA+P1BEZizmH0p
         RkSEoRTeYCp3N8kAzHQGGgJouyxiLmcX1aawmsJ66xaWquZ5FMc0fy5V7sgn3SMf3F1C
         GldqnFW7MTHB9jHjf6M2gLsauqx50eCLkKGuEFnraJCYwfCzfA3XZhoLE6ocAc9+V5kr
         f6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxn2R3Zq6Tw0lN1kjveUcYSsFlHI5w7882f4dWmiIs8=;
        b=xCqlg8s0Bar8df04Q6neEvFTUe5BiK9s+QDKbrX3Pt2Wmrh6zxykv2/pPj5XOV2ubs
         VW9rkPhqD4mGOxI8R6VVmbIC5rlGeeBLTNiExZbQSLHQ0bVBBH2BWT/gxP2IrzYesK2r
         gIgOIq3cvo3p9Oqsu4OxzR6ggr/havAo3x89+5gBtrJq91Xe3OjN8/HlORU44f3kkkty
         YkmrmlXG22dt9k3WnCLXcMCl87QVCAnYDpNGjmJ8md9iMUY3s6qFJSQlmETaL5MY4hvF
         01tLrWRkp6/fgL8STo7+HMGReFehMu4HwQNonAu7hzaoyVFcSY7TgqGWtt1f3MSngRT7
         +hfQ==
X-Gm-Message-State: AFqh2krBPd1m0DyZTLoK1XpdafouT/gbPBBL4ToWrxKC3sPxT3mkkGv6
        xLXOlZwOwumf4XA6u1l7XJvyye65AtoO8wv6eNzWqA==
X-Google-Smtp-Source: AMrXdXvsMRjLYs2oaXrC5LdfWLFpy6YYLUvXb5nhNwQLg51i6bXJ1Op3ASV9xPA4hbV2L2pOBKaV8Q==
X-Received: by 2002:a17:903:240b:b0:192:8bee:3e29 with SMTP id e11-20020a170903240b00b001928bee3e29mr47778635plo.2.1673084959934;
        Sat, 07 Jan 2023 01:49:19 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903120500b0018862bb3976sm2262547plh.308.2023.01.07.01.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:49:19 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, maximmi@nvidia.com, gal@nvidia.com
Subject: [patch net-next 2/8] devlink: remove linecards lock
Date:   Sat,  7 Jan 2023 10:49:03 +0100
Message-Id: <20230107094909.530239-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107094909.530239-1-jiri@resnulli.us>
References: <20230107094909.530239-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Similar to other devlink objects, convert the linecards list to be
protected by devlink instance lock. Alongside with that rename the
create/destroy() functions to devl_* to indicated the devlink instance
lock needs to be held while calling them.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_linecards.c  |  8 ++--
 include/net/devlink.h                         |  6 +--
 net/devlink/core.c                            |  2 -
 net/devlink/devl_internal.h                   |  1 -
 net/devlink/leftover.c                        | 41 +++++++------------
 5 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 83d2dc91ba2c..025e0db983fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -1259,9 +1259,9 @@ static int mlxsw_linecard_init(struct mlxsw_core *mlxsw_core,
 	linecard->linecards = linecards;
 	mutex_init(&linecard->lock);
 
-	devlink_linecard = devlink_linecard_create(priv_to_devlink(mlxsw_core),
-						   slot_index, &mlxsw_linecard_ops,
-						   linecard);
+	devlink_linecard = devl_linecard_create(priv_to_devlink(mlxsw_core),
+						slot_index, &mlxsw_linecard_ops,
+						linecard);
 	if (IS_ERR(devlink_linecard))
 		return PTR_ERR(devlink_linecard);
 
@@ -1285,7 +1285,7 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
 	if (linecard->active)
 		mlxsw_linecard_active_clear(linecard);
 	mlxsw_linecard_bdev_del(linecard);
-	devlink_linecard_destroy(linecard->devlink_linecard);
+	devl_linecard_destroy(linecard->devlink_linecard);
 	mutex_destroy(&linecard->lock);
 }
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 425ecef431b7..d7c9572e5bea 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1687,9 +1687,9 @@ void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard);
 struct devlink_linecard *
-devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
-			const struct devlink_linecard_ops *ops, void *priv);
-void devlink_linecard_destroy(struct devlink_linecard *linecard);
+devl_linecard_create(struct devlink *devlink, unsigned int linecard_index,
+		     const struct devlink_linecard_ops *ops, void *priv);
+void devl_linecard_destroy(struct devlink_linecard *linecard);
 void devlink_linecard_provision_set(struct devlink_linecard *linecard,
 				    const char *type);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
diff --git a/net/devlink/core.c b/net/devlink/core.c
index 4014a01c8f3d..d223a46fe557 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -218,7 +218,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
 	mutex_init(&devlink->reporters_lock);
-	mutex_init(&devlink->linecards_lock);
 	refcount_set(&devlink->refcount, 1);
 
 	return devlink;
@@ -240,7 +239,6 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_destroy(&devlink->linecards_lock);
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	lockdep_unregister_key(&devlink->lock_key);
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 82268c4579a3..ca49ad31027c 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -37,7 +37,6 @@ struct devlink {
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
 	struct list_head linecard_list;
-	struct mutex linecards_lock; /* protects linecard_list */
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
 	struct devlink_dev_stats stats;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 478b81b85f03..4b01b15f8659 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -282,13 +282,10 @@ devlink_linecard_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
 		u32 linecard_index = nla_get_u32(attrs[DEVLINK_ATTR_LINECARD_INDEX]);
 		struct devlink_linecard *linecard;
 
-		mutex_lock(&devlink->linecards_lock);
 		linecard = devlink_linecard_get_by_index(devlink, linecard_index);
-		if (linecard)
-			refcount_inc(&linecard->refcount);
-		mutex_unlock(&devlink->linecards_lock);
 		if (!linecard)
 			return ERR_PTR(-ENODEV);
+		refcount_inc(&linecard->refcount);
 		return linecard;
 	}
 	return ERR_PTR(-EINVAL);
@@ -2129,7 +2126,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	devlink_dump_for_each_instance_get(msg, state, devlink) {
 		int idx = 0;
 
-		mutex_lock(&devlink->linecards_lock);
+		devl_lock(devlink);
 		if (!devl_is_registered(devlink))
 			goto next_devlink;
 
@@ -2147,7 +2144,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 						       cb->extack);
 			mutex_unlock(&linecard->state_lock);
 			if (err) {
-				mutex_unlock(&devlink->linecards_lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				state->idx = idx;
 				goto out;
@@ -2155,7 +2152,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 next_devlink:
-		mutex_unlock(&devlink->linecards_lock);
+		devl_unlock(devlink);
 		devlink_put(devlink);
 	}
 out:
@@ -10225,7 +10222,7 @@ static void devlink_linecard_types_fini(struct devlink_linecard *linecard)
 }
 
 /**
- *	devlink_linecard_create - Create devlink linecard
+ *	devl_linecard_create - Create devlink linecard
  *
  *	@devlink: devlink
  *	@linecard_index: driver-specific numerical identifier of the linecard
@@ -10238,8 +10235,8 @@ static void devlink_linecard_types_fini(struct devlink_linecard *linecard)
  *	Return: Line card structure or an ERR_PTR() encoded error code.
  */
 struct devlink_linecard *
-devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
-			const struct devlink_linecard_ops *ops, void *priv)
+devl_linecard_create(struct devlink *devlink, unsigned int linecard_index,
+		     const struct devlink_linecard_ops *ops, void *priv)
 {
 	struct devlink_linecard *linecard;
 	int err;
@@ -10248,17 +10245,13 @@ devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 		    !ops->types_count || !ops->types_get))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->linecards_lock);
-	if (devlink_linecard_index_exists(devlink, linecard_index)) {
-		mutex_unlock(&devlink->linecards_lock);
+	if (devlink_linecard_index_exists(devlink, linecard_index))
 		return ERR_PTR(-EEXIST);
-	}
+
 
 	linecard = kzalloc(sizeof(*linecard), GFP_KERNEL);
-	if (!linecard) {
-		mutex_unlock(&devlink->linecards_lock);
+	if (!linecard)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	linecard->devlink = devlink;
 	linecard->index = linecard_index;
@@ -10271,35 +10264,29 @@ devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 	if (err) {
 		mutex_destroy(&linecard->state_lock);
 		kfree(linecard);
-		mutex_unlock(&devlink->linecards_lock);
 		return ERR_PTR(err);
 	}
 
 	list_add_tail(&linecard->list, &devlink->linecard_list);
 	refcount_set(&linecard->refcount, 1);
-	mutex_unlock(&devlink->linecards_lock);
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	return linecard;
 }
-EXPORT_SYMBOL_GPL(devlink_linecard_create);
+EXPORT_SYMBOL_GPL(devl_linecard_create);
 
 /**
- *	devlink_linecard_destroy - Destroy devlink linecard
+ *	devl_linecard_destroy - Destroy devlink linecard
  *
  *	@linecard: devlink linecard
  */
-void devlink_linecard_destroy(struct devlink_linecard *linecard)
+void devl_linecard_destroy(struct devlink_linecard *linecard)
 {
-	struct devlink *devlink = linecard->devlink;
-
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
-	mutex_lock(&devlink->linecards_lock);
 	list_del(&linecard->list);
 	devlink_linecard_types_fini(linecard);
-	mutex_unlock(&devlink->linecards_lock);
 	devlink_linecard_put(linecard);
 }
-EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
+EXPORT_SYMBOL_GPL(devl_linecard_destroy);
 
 /**
  *	devlink_linecard_provision_set - Set provisioning on linecard
-- 
2.39.0

