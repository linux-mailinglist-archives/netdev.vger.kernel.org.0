Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCB2672129
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjARPYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjARPXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:52 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C354222E4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:30 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id v6so41058652ejg.6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/WYyDhgWvrQAugwjSVOnozL10LttT+AspbQZ1z+SNw=;
        b=I4oZ2WT7MZR9mI/2prX40NJUd3DB0x9PM6uoDOyUBCi0unToVaXxJRkLedpX51MRpd
         KaVi657JOoi2TlZE36wz86z8wXPR/0iu0CGC3TWX+jMRQNLI5+b+1vssYsmrzsQ53AR0
         oXeXcrP8Isz/YM1CboVjBzBCRk+imkRfvrp+X9VjoiWWT3Lon+Ix2UdKszyKX3zhgQ5O
         U8mDZc0bwHj5UJtyOMJ0wjcGV4xlicSLQISNrRGaIySONouAiXyRd3MEsjgkV6UeghRr
         zZHrspOAe1pAPSdqEVPwh04J0STSwiTEb71m9hp5v4NH00ftkOVOA430ldNxoDwcAKPM
         e+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/WYyDhgWvrQAugwjSVOnozL10LttT+AspbQZ1z+SNw=;
        b=72Jvneu28YvJ5Rn7UvefRBohFIfyXKjNlkxU0Kj+OVRvILzfckRN15BIyVzqfH6Ye/
         h8oFz4VpvrwLRtya46wINdPbg2ipFAgcixvSBoPUZ6eD8NSmTrTpVG9rK+juO5rt+un0
         GMCibz1KTvxA2/K1Bs8CoqGwNrRHmczo4sMr3+yVqY7FgK6KHdisGzvdukMQamCpeUV6
         V6pdyiNy3Pt6PBvGJQswNJv9JuRSNjki+EdChY3TGnu0JvxCMJRVBITUIstZMa2IZk3K
         WK40XYUlJp2fcH7wOXCPwplBPjVm7DRnfuQP+wXVBP/hON1PhxqXoU7TYiLOvO9rQvDg
         xnyw==
X-Gm-Message-State: AFqh2kpj2kdyye1d72ioIkZDeVzabsMV2NBFWk6ZpQQeFdr/0eeZbAUY
        WEoSEoo7K85T+nkxdEd6/1AoCufwsQdjfsv1yXIU/A==
X-Google-Smtp-Source: AMrXdXtbbPG8vFhlnbzJIhpwMTT52/Rd5edMqFVZtTXn2B5Uxnc8FvWiw4heFxrUllmJO/d5nDPsxg==
X-Received: by 2002:a17:907:cc8a:b0:7ad:d62d:9d31 with SMTP id up10-20020a170907cc8a00b007add62d9d31mr2835303ejc.67.1674055288989;
        Wed, 18 Jan 2023 07:21:28 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id cf23-20020a170906b2d700b007aef930360asm10395071ejb.59.2023.01.18.07.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:28 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 06/12] devlink: remove reporters_lock
Date:   Wed, 18 Jan 2023 16:21:09 +0100
Message-Id: <20230118152115.1113149-7-jiri@resnulli.us>
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

Similar to other devlink objects, rely on devlink instance lock
and remove object specific reporters_lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v4->v5:
- rebased on top of the mutex destroy fix
v2->v3:
- split from v2 patch #4 - "devlink: remove reporters_lock", no change
---
 include/net/devlink.h       |  1 -
 net/devlink/core.c          |  2 --
 net/devlink/devl_internal.h |  1 -
 net/devlink/leftover.c      | 53 +++++++------------------------------
 4 files changed, 9 insertions(+), 48 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0d64feaef7cb..d9ea76bea36e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -146,7 +146,6 @@ struct devlink_port {
 	   initialized:1;
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
-	struct mutex reporters_lock; /* Protects reporter_list */
 
 	struct devlink_rate *devlink_rate;
 	struct devlink_linecard *linecard;
diff --git a/net/devlink/core.c b/net/devlink/core.c
index dfc5b58c0464..6c0e2fc57e45 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -246,7 +246,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	lockdep_register_key(&devlink->lock_key);
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
-	mutex_init(&devlink->reporters_lock);
 	refcount_set(&devlink->refcount, 1);
 
 	return devlink;
@@ -268,7 +267,6 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_destroy(&devlink->reporters_lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index dd4e2c37cf07..bdb83014b4b5 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -32,7 +32,6 @@ struct devlink {
 	struct list_head param_list;
 	struct list_head region_list;
 	struct list_head reporter_list;
-	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
 	struct list_head trap_list;
 	struct list_head trap_group_list;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 0fc374140e6a..29e2351ee752 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7281,12 +7281,10 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_priv);
 
 static struct devlink_health_reporter *
 __devlink_health_reporter_find_by_name(struct list_head *reporter_list,
-				       struct mutex *list_lock,
 				       const char *reporter_name)
 {
 	struct devlink_health_reporter *reporter;
 
-	lockdep_assert_held(list_lock);
 	list_for_each_entry(reporter, reporter_list, list)
 		if (!strcmp(reporter->ops->name, reporter_name))
 			return reporter;
@@ -7298,7 +7296,6 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
 				     const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink->reporter_list,
-						      &devlink->reporters_lock,
 						      reporter_name);
 }
 
@@ -7307,7 +7304,6 @@ devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
 					  const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink_port->reporter_list,
-						      &devlink_port->reporters_lock,
 						      reporter_name);
 }
 
@@ -7353,22 +7349,18 @@ devl_port_health_reporter_create(struct devlink_port *port,
 	struct devlink_health_reporter *reporter;
 
 	devl_assert_locked(port->devlink);
-	mutex_lock(&port->reporters_lock);
+
 	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
-						   &port->reporters_lock, ops->name)) {
-		reporter = ERR_PTR(-EEXIST);
-		goto unlock;
-	}
+						   ops->name))
+		return ERR_PTR(-EEXIST);
 
 	reporter = __devlink_health_reporter_create(port->devlink, ops,
 						    graceful_period, priv);
 	if (IS_ERR(reporter))
-		goto unlock;
+		return reporter;
 
 	reporter->devlink_port = port;
 	list_add_tail(&reporter->list, &port->reporter_list);
-unlock:
-	mutex_unlock(&port->reporters_lock);
 	return reporter;
 }
 EXPORT_SYMBOL_GPL(devl_port_health_reporter_create);
@@ -7405,20 +7397,16 @@ devl_health_reporter_create(struct devlink *devlink,
 	struct devlink_health_reporter *reporter;
 
 	devl_assert_locked(devlink);
-	mutex_lock(&devlink->reporters_lock);
-	if (devlink_health_reporter_find_by_name(devlink, ops->name)) {
-		reporter = ERR_PTR(-EEXIST);
-		goto unlock;
-	}
+
+	if (devlink_health_reporter_find_by_name(devlink, ops->name))
+		return ERR_PTR(-EEXIST);
 
 	reporter = __devlink_health_reporter_create(devlink, ops,
 						    graceful_period, priv);
 	if (IS_ERR(reporter))
-		goto unlock;
+		return reporter;
 
 	list_add_tail(&reporter->list, &devlink->reporter_list);
-unlock:
-	mutex_unlock(&devlink->reporters_lock);
 	return reporter;
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_create);
@@ -7469,13 +7457,9 @@ __devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 void
 devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	struct mutex *lock = &reporter->devlink->reporters_lock;
-
 	devl_assert_locked(reporter->devlink);
 
-	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(lock);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7498,13 +7482,9 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 void
 devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	struct mutex *lock = &reporter->devlink_port->reporters_lock;
-
 	devl_assert_locked(reporter->devlink);
 
-	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(lock);
 }
 EXPORT_SYMBOL_GPL(devl_port_health_reporter_destroy);
 
@@ -7758,17 +7738,13 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
 	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
 	if (IS_ERR(devlink_port)) {
-		mutex_lock(&devlink->reporters_lock);
 		reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
 		if (reporter)
 			refcount_inc(&reporter->refcount);
-		mutex_unlock(&devlink->reporters_lock);
 	} else {
-		mutex_lock(&devlink_port->reporters_lock);
 		reporter = devlink_port_health_reporter_find_by_name(devlink_port, reporter_name);
 		if (reporter)
 			refcount_inc(&reporter->refcount);
-		mutex_unlock(&devlink_port->reporters_lock);
 	}
 
 	return reporter;
@@ -7868,8 +7844,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!devl_is_registered(devlink))
 			goto next_devlink;
 
-		mutex_lock(&devlink->reporters_lock);
-
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
 			if (idx < state->idx) {
@@ -7881,7 +7855,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 				NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->reporters_lock);
 				devl_unlock(devlink);
 				devlink_put(devlink);
 				state->idx = idx;
@@ -7889,10 +7862,8 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->reporters_lock);
 
 		xa_for_each(&devlink->ports, port_index, port) {
-			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
 				if (idx < state->idx) {
 					idx++;
@@ -7904,7 +7875,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
-					mutex_unlock(&port->reporters_lock);
 					devl_unlock(devlink);
 					devlink_put(devlink);
 					state->idx = idx;
@@ -7912,7 +7882,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				}
 				idx++;
 			}
-			mutex_unlock(&port->reporters_lock);
 		}
 next_devlink:
 		devl_unlock(devlink);
@@ -9633,12 +9602,9 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
-	mutex_init(&devlink_port->reporters_lock);
 	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
-	if (err) {
-		mutex_destroy(&devlink_port->reporters_lock);
+	if (err)
 		return err;
-	}
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9689,7 +9655,6 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
 }
 EXPORT_SYMBOL_GPL(devl_port_unregister);
-- 
2.39.0

