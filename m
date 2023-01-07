Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D9660DA5
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjAGKMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjAGKMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:12:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE667CDF9
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:12:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso2582090pjl.2
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxn2R3Zq6Tw0lN1kjveUcYSsFlHI5w7882f4dWmiIs8=;
        b=CAQzGXuk5gjXcMdu2qybMbtXplJTr7mVVwfn54QTksvSoLjt6r298sLZI/TmsSLZoK
         4e0/ax4jzdH7SxPK/lC/qdMV3yqwgNs/zlTJ89chgp9JCwP9HrHj3puZaU2u+qWrfnuB
         RuAIfUjNLeiMLYopzyd3A4llvOJzD3c+nqJN95Sir8KjK4QvBN2B9835F3fz36lZQwUa
         dkru38Sy6T/7z+gj0BX7qEJf9oNVZWXwcZ0wOrggayOKKci2EIVwRo3XW/d0arwjAxfw
         JNhdV7vSa3Ju+56NS1cIHrAuN7EQrsPo6hONdu4KmgvfK+W1hc8OTjQTc4bkb+6akplK
         wg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxn2R3Zq6Tw0lN1kjveUcYSsFlHI5w7882f4dWmiIs8=;
        b=gljKglcugz0/JY8HVzBD1bOE4bpWia81A36/SOQOzY/gpi92XjuKCvEDsNjlsUPNHO
         Cq40FfkdWHbxD8r+s0PdukJk1NTNGTX5yqNg+hCaHv/iGSokMAT8UlGHfs4Pwd4VtKzj
         BKhrC7pBcP2ZSqSBD+TAotyWtQjDPOh2QeQ/HFhPFo1XvAiYmYWiU4kpYex747D0Aosa
         Xb8Y6nUc42oZhP5FBfHIESWtEkL1oE2uWej0K3HHVX14dcRvHdKvUY+GGIT939krztrz
         ISP3oDx6+LAsHC3Pr2NBXnev/LUwvyvTwnx2KBkPQdFxRI0VU8H/N9raYojkEr9zVh5G
         5Tvw==
X-Gm-Message-State: AFqh2kpdFKqTqnVSwajwWmVO+Oq4p/nEkF8LtzsQF9IjIWWRaTLRouBN
        Mbj2KxioI7Y9x/jWeQHTqUt5KaXuypG/Nerz4IGbuA==
X-Google-Smtp-Source: AMrXdXtorhSgoXGUo2Yw6t7HzJwsPYcqqad2AGnKBLCfoQauFWA81zkewwm96cHkp7cz7QWcCJrG/g==
X-Received: by 2002:a17:903:32c6:b0:189:df3c:1ba1 with SMTP id i6-20020a17090332c600b00189df3c1ba1mr80861081plr.38.1673086321443;
        Sat, 07 Jan 2023 02:12:01 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id b11-20020a1709027e0b00b0018982bf03b4sm2394131plm.117.2023.01.07.02.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:12:01 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v2 2/9] devlink: remove linecards lock
Date:   Sat,  7 Jan 2023 11:11:43 +0100
Message-Id: <20230107101151.532611-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107101151.532611-1-jiri@resnulli.us>
References: <20230107101151.532611-1-jiri@resnulli.us>
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

