Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EF6662F37
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbjAISfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbjAISdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:50 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B379625FB
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id e10so6481108pgc.9
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUsQyYY1/hLbs2LR5cy5OuPI1tMhMrmcV0LwFHVi8yg=;
        b=hla6sYBV/2KRcsM+db37CDWNjagEKpcApTcrxandnShQVrE8Rc6zwMSZlHtXo+F3dX
         NP9cFAgIeIfrC6DP7V8QRlMzmdztH1ByvImXDbG7T7pXVaIP086ZLn9r9aTMle61yh9v
         V+fnIdKCUPtyKt1cALx2bA0IWtY5SD9LQgNhIHCi6TnTQyswTTsg7NAomTITF/J9bl6M
         A7PMWuQsNUsMYokK/iiL/ilEHgxmnyEBD1RUCWQcGeLfYJe/4YD2EHdLSkwtujm4evJp
         +4qjxL/0SWbTVVEK2rIllKpSNhDmzP8RolC4QCBFe5SYQSkh9mgnz5MJemAwuU5RCVIE
         qt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bUsQyYY1/hLbs2LR5cy5OuPI1tMhMrmcV0LwFHVi8yg=;
        b=Fe+4stIX7n3N+AzA8zURhUIKddqDzDs/lBQQtgjlkW9AEWO3wJtPlp++jCQDGfFoIc
         pWfKUiLpuUyajlIMq/dTHaLlDS58clfI8Q/qeTOcyP/ooQbbA52b684Igs8pY2Ek08EE
         K5vbTLfXIgnWU88oQx9rKs960MPYcnrQ/UJOBKm5/0rdyHGZe679qrHAsYdwJ8PU+5Id
         juCbBj7cfJJ/QEQXMNI/iAIFIIwg66AaF10DINv3KbJfZREjJlkSScUVKFUFonikajEe
         JtVbMdhL5v1joHBOeUi2xzeCJJbKiWGIghks3C0sGp15JkhyrTkIZSvEtq98z+kHo0F2
         mv0w==
X-Gm-Message-State: AFqh2kqXQf51mtqsCLdaRPaHsQ/ArcKhj3B0fXKeGeVHpR6/x3OKghYg
        78CSzp4pUEaGgaMR/iQ7Egke/t8stpB0mZ02zBvtiw==
X-Google-Smtp-Source: AMrXdXvNquajcq/+qS+4kEugpS/ehg/L4+KOcijyuau5J90VxA3UbQMvkE+jl8g5YTIASU7DfZhBHA==
X-Received: by 2002:aa7:8b1a:0:b0:582:26bc:a75b with SMTP id f26-20020aa78b1a000000b0058226bca75bmr30507261pfd.9.1673289101890;
        Mon, 09 Jan 2023 10:31:41 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id b29-20020a62a11d000000b00582f222f088sm6351059pff.47.2023.01.09.10.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:41 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 05/11] devlink: remove reporters_lock
Date:   Mon,  9 Jan 2023 19:31:14 +0100
Message-Id: <20230109183120.649825-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
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
v2->v3:
- split from v2 patch #4 - "devlink: remove reporters_lock", no change
---
 include/net/devlink.h       |  1 -
 net/devlink/core.c          |  2 --
 net/devlink/devl_internal.h |  1 -
 net/devlink/leftover.c      | 53 +++++++------------------------------
 4 files changed, 9 insertions(+), 48 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8b0e63f7f49e..b8ef03445b3a 100644
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
index d223a46fe557..4142b69ec680 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -217,7 +217,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	lockdep_register_key(&devlink->lock_key);
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
-	mutex_init(&devlink->reporters_lock);
 	refcount_set(&devlink->refcount, 1);
 
 	return devlink;
@@ -239,7 +238,6 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	lockdep_unregister_key(&devlink->lock_key);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 61c707c4f9a3..733e28c695d4 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -31,7 +31,6 @@ struct devlink {
 	struct list_head param_list;
 	struct list_head region_list;
 	struct list_head reporter_list;
-	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
 	struct list_head trap_list;
 	struct list_head trap_group_list;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 023c6c6b5f8a..50ac049ee60b 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7278,12 +7278,10 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_priv);
 
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
@@ -7295,7 +7293,6 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
 				     const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink->reporter_list,
-						      &devlink->reporters_lock,
 						      reporter_name);
 }
 
@@ -7304,7 +7301,6 @@ devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
 					  const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink_port->reporter_list,
-						      &devlink_port->reporters_lock,
 						      reporter_name);
 }
 
@@ -7350,22 +7346,18 @@ devl_port_health_reporter_create(struct devlink_port *port,
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
@@ -7386,20 +7378,16 @@ devl_health_reporter_create(struct devlink *devlink,
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
@@ -7450,13 +7438,9 @@ __devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
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
 
@@ -7479,13 +7463,9 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
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
 
@@ -7728,17 +7708,13 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
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
@@ -7838,8 +7814,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!devl_is_registered(devlink))
 			goto next_devlink;
 
-		mutex_lock(&devlink->reporters_lock);
-
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
 			if (idx < state->idx) {
@@ -7851,7 +7825,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 				NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->reporters_lock);
 				devl_unlock(devlink);
 				devlink_put(devlink);
 				state->idx = idx;
@@ -7859,10 +7832,8 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->reporters_lock);
 
 		xa_for_each(&devlink->ports, port_index, port) {
-			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
 				if (idx < state->idx) {
 					idx++;
@@ -7874,7 +7845,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
-					mutex_unlock(&port->reporters_lock);
 					devl_unlock(devlink);
 					devlink_put(devlink);
 					state->idx = idx;
@@ -7882,7 +7852,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				}
 				idx++;
 			}
-			mutex_unlock(&port->reporters_lock);
 		}
 next_devlink:
 		devl_unlock(devlink);
@@ -9608,12 +9577,9 @@ int devl_port_register(struct devlink *devlink,
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
@@ -9664,7 +9630,6 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
 }
 EXPORT_SYMBOL_GPL(devl_port_unregister);
-- 
2.39.0

