Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A9D672123
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjARPYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjARPXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:44 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72D333456
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:20 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ud5so84109285ejc.4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPs5boUXNfH/ofTeAQzPqRAbf1LNlPZ1Nmt3yv9fFqY=;
        b=Y592FF9dVeUtRnFdK8ZKA3uxxdZ+4VzxHRLp2P0iuwFELNtRuaq95wX/ayvKH3WmyC
         dNIRW2BgKBxQ6/zAcesJkUMIDLaKUsa0PlJFe3DGlNtSG1Aj9CbhkK3VdmLv+RSlxuAs
         RQGqS9mic9BQWSMZN3VY2eAUZxrg8hXz5WmCaeV/0AqBjoTTXaJOEC8Bpuo3q2YD3AK3
         WkiUq8RtgZlUxly9NSW/pt5KbRXwZn02opZiHqiGyTyw/W4SLOXv08BFHJIvSlBJMWnr
         CqRMkc4iMRlJ5Fey9B/sTpQgufZCImOIPa4Tk5G/SlcHqkPy8U+62tAxhBWgMc2XGEh/
         AgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HPs5boUXNfH/ofTeAQzPqRAbf1LNlPZ1Nmt3yv9fFqY=;
        b=keBb+iOmAtAP/3o869SeUBV1tmApCC9ay+sV8l3gFxKEZNa3S6cWawC54Acdlc/XR0
         eS2o/Zy1QOsYTzjMXruplCD6koQfnp/K/V18l0vWuX695bGUJV09Yof9yeUzJXdHWLyP
         +0+bsns5tJHU9QrvRObNOxAZ6qK/Gh++iTcB7vuadQzDNCaV/yQ8JeGG4dFLyKqev8IK
         EROq10dBe+WpaPlKCKf0WRIceKQwpNIfeUYR0jqm1ge98KN03GyGw3KpuFFqn+6P/5JQ
         yOBvmfqad3UiFg+xMHH2wPlDwKZ8vrOV7PsAlshdPtdMDYxiWTkXhe+bc0YetcLw2JhX
         ybJA==
X-Gm-Message-State: AFqh2kohIGvJXAgPYweD55k9qULSrKnTGfNJy8/xHOzE1fKZSWEQAmA7
        AxdizArutmWUqTKWvTluuzMNzMMNZwnJmYJIdgB18A==
X-Google-Smtp-Source: AMrXdXtveRUbFS+PaYyzK7UBZMbMq7Asah5Vut+YZluMkJfuuvI/CBtff87ThWRdyg6LgkINNIVWWA==
X-Received: by 2002:a17:906:774f:b0:870:94e:13f9 with SMTP id o15-20020a170906774f00b00870094e13f9mr7279292ejn.0.1674055279290;
        Wed, 18 Jan 2023 07:21:19 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b007b839689adesm14607877ejh.166.2023.01.18.07.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:18 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 01/12] devlink: remove linecards lock
Date:   Wed, 18 Jan 2023 16:21:04 +0100
Message-Id: <20230118152115.1113149-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
References: <20230118152115.1113149-1-jiri@resnulli.us>
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
create/destroy() functions to devl_* to indicate the devlink instance
lock needs to be held while calling them.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v2->v3: fixed typo in patch description
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
index 60beca2df7cc..dfc5b58c0464 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -247,7 +247,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
 	mutex_init(&devlink->reporters_lock);
-	mutex_init(&devlink->linecards_lock);
 	refcount_set(&devlink->refcount, 1);
 
 	return devlink;
@@ -269,7 +268,6 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_destroy(&devlink->linecards_lock);
 	mutex_destroy(&devlink->reporters_lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index e724e4c2a4ff..32f0adc40c18 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -38,7 +38,6 @@ struct devlink {
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
 	struct list_head linecard_list;
-	struct mutex linecards_lock; /* protects linecard_list */
 	const struct devlink_ops *ops;
 	u64 features;
 	struct xarray snapshot_ids;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index bf5e0b1c0422..6ba1baab80d3 100644
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
@@ -10223,7 +10220,7 @@ static void devlink_linecard_types_fini(struct devlink_linecard *linecard)
 }
 
 /**
- *	devlink_linecard_create - Create devlink linecard
+ *	devl_linecard_create - Create devlink linecard
  *
  *	@devlink: devlink
  *	@linecard_index: driver-specific numerical identifier of the linecard
@@ -10236,8 +10233,8 @@ static void devlink_linecard_types_fini(struct devlink_linecard *linecard)
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
@@ -10246,17 +10243,13 @@ devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
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
@@ -10269,35 +10262,29 @@ devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
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

