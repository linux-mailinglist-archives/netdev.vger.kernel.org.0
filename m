Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C362065B3A0
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 15:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjABO53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 09:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjABO52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 09:57:28 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB7F63F7
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 06:57:27 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id m3so11591771wmq.0
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 06:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QdMw2U3Aja1AvzWezaU8619lAYObO2kE3EqCPWUIgLE=;
        b=HUw/TeE/bbAzUgWOkLH3Vnsr1v97rZ44qqGgVKRWKCG7n0XvEU96usXENvpBDfekH9
         eB0nxxjz9cq4wr8hxv1FgmxhsmpqBQ8+koBjaNhtdY4wqCOwioN/d/SeMspLpfz+IzS/
         6FWgO8AhWDefqm+nVYeDhyLI7FfwCiMNQ4eCYcAcs0L64z/8G8Q3GgOBLW9KvMMgHchZ
         l0BIkKZPKhtxp3YGo3Qpu79EnL50zlAWTqZz6krVLvuTUSk/RQHfsvJSZA51NdNJHViV
         6zXYYF1QuXeEaeiBb2J7Q39/HXMWvNfkfDE6/SduQHxHkwakLTyM12R+4YsNzks54ghb
         RJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdMw2U3Aja1AvzWezaU8619lAYObO2kE3EqCPWUIgLE=;
        b=jCDMYJzEqR21XzmfNzvy/6j1pcFnGlUkm5lu+C0MTNS7ilb//DjoBN3pNlzYSgB+ch
         iQ6Wj9Us8VjNzj0LRoUtpDvIrogWXCs8ZFyPoCrCfoZAz4z6aGbgFMCKUItwbwXcR/pp
         u6C7KAeI/aRsybxTho8RpolSKSbviX3xfnm9s7Na3Ro/FDCNi/9EUszstrGs9ANI3zy3
         sVcKof7Cu6TNpi9jzWJmRYsdu11J0cPCAupZCCSWW1+g8+ipOnmkCI/u2vH9nxVzMvLB
         0Q8ydoNjwhNsLV8OjV5URYhjgjIPmq/VtW1HfrXi5Tzk2jq0myWw0Zg28Exq/xJ9wFTN
         L0kg==
X-Gm-Message-State: AFqh2kqGt07CYCLT8PIxfyQoK1KLl7YCKZOhBqp4PlUNQRUi/ANBFQZF
        mD+Z7rZTREycjQ58UYmJlwhnUru+RAIYTPdr4x4P0A==
X-Google-Smtp-Source: AMrXdXvbb0exIQjIbLogaV5BczR455uPIPczNs0aqYNrrLCf3FSPRre2NqhjFW5DSp3FJFhlHQOeJA==
X-Received: by 2002:a05:600c:3495:b0:3c6:e62e:2e74 with SMTP id a21-20020a05600c349500b003c6e62e2e74mr29380037wmq.15.1672671445569;
        Mon, 02 Jan 2023 06:57:25 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ay39-20020a05600c1e2700b003cfa80443a0sm38726184wmb.35.2023.01.02.06.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 06:57:25 -0800 (PST)
Date:   Mon, 2 Jan 2023 15:57:24 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7Lw1GSGml1E8SXw@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217011953.152487-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 17, 2022 at 02:19:47AM CET, kuba@kernel.org wrote:
>Always check under the instance lock whether the devlink instance
>is still / already registered.
>
>This is a no-op for the most part, as the unregistration path currently
>waits for all references. On the init path, however, we may temporarily
>open up a race with netdev code, if netdevs are registered before the
>devlink instance. This is temporary, the next change fixes it, and this
>commit has been split out for the ease of review.
>
>Note that in case of iterating over sub-objects which have their
>own lock (regions and line cards) we assume an implicit dependency
>between those objects existing and devlink unregistration.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> include/net/devlink.h |  1 +
> net/devlink/basic.c   | 35 +++++++++++++++++++++++++++++------
> net/devlink/core.c    | 25 +++++++++++++++++++++----
> net/devlink/netlink.c | 10 ++++++++--
> 4 files changed, 59 insertions(+), 12 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 6a2e4f21779f..36e013d3aa52 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1626,6 +1626,7 @@ struct device *devlink_to_dev(const struct devlink *devlink);
> void devl_lock(struct devlink *devlink);
> int devl_trylock(struct devlink *devlink);
> void devl_unlock(struct devlink *devlink);
>+bool devl_is_alive(struct devlink *devlink);
> void devl_assert_locked(struct devlink *devlink);
> bool devl_lock_is_held(struct devlink *devlink);
> 
>diff --git a/net/devlink/basic.c b/net/devlink/basic.c
>index 5f33d74eef83..6b18e70a39fd 100644
>--- a/net/devlink/basic.c
>+++ b/net/devlink/basic.c
>@@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
> 		int idx = 0;
> 
> 		mutex_lock(&devlink->linecards_lock);
>+		if (!devl_is_alive(devlink))
>+			goto next_devlink;


Thinking about this a bit more, things would be cleaner if reporters and
linecards are converted to rely on instance lock as well. I don't see a
good reason for a separate lock in both cases, really.

Also, we could introduce devlinks_xa_for_each_registered_get_lock()
iterator that would lock the instance as well right away to avoid
this devl_is_alive() dance on multiple places when you iterate devlinks.


>+
> 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
> 			if (idx < dump->idx) {
> 				idx++;
>@@ -2151,6 +2154,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
> 			}
> 			idx++;
> 		}
>+next_devlink:
> 		mutex_unlock(&devlink->linecards_lock);
> 		devlink_put(devlink);
> 	}
>@@ -7809,6 +7813,12 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
> 		int idx = 0;
> 
> 		mutex_lock(&devlink->reporters_lock);
>+		if (!devl_is_alive(devlink)) {
>+			mutex_unlock(&devlink->reporters_lock);
>+			devlink_put(devlink);
>+			continue;
>+		}
>+
> 		list_for_each_entry(reporter, &devlink->reporter_list,
> 				    list) {
> 			if (idx < dump->idx) {
>@@ -7830,6 +7840,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
> 		mutex_unlock(&devlink->reporters_lock);
> 
> 		devl_lock(devlink);
>+		if (!devl_is_alive(devlink))
>+			goto next_devlink;
>+
> 		xa_for_each(&devlink->ports, port_index, port) {
> 			mutex_lock(&port->reporters_lock);
> 			list_for_each_entry(reporter, &port->reporter_list, list) {
>@@ -7853,6 +7866,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
> 			}
> 			mutex_unlock(&port->reporters_lock);
> 		}
>+next_devlink:
> 		devl_unlock(devlink);
> 		devlink_put(devlink);
> 	}
>@@ -12218,7 +12232,8 @@ void devlink_compat_running_version(struct devlink *devlink,
> 		return;
> 
> 	devl_lock(devlink);

How about to have a helper, something like devl_lock_alive() (or
devl_lock_registered() with the naming scheme I suggest in the other
thread)? Then you can do:

	if (!devl_lock_alive(devlink))
		return;
	__devlink_compat_running_version(devlink, buf, len);
	devl_unlock(devlink);



>-	__devlink_compat_running_version(devlink, buf, len);
>+	if (devl_is_alive(devlink))
>+		__devlink_compat_running_version(devlink, buf, len);
> 	devl_unlock(devlink);
> }
> 
>@@ -12227,20 +12242,28 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
> 	struct devlink_flash_update_params params = {};
> 	int ret;
> 
>-	if (!devlink->ops->flash_update)
>-		return -EOPNOTSUPP;
>+	devl_lock(devlink);
>+	if (!devl_is_alive(devlink)) {
>+		ret = -ENODEV;
>+		goto out_unlock;
>+	}
>+
>+	if (!devlink->ops->flash_update) {
>+		ret = -EOPNOTSUPP;
>+		goto out_unlock;
>+	}
> 
> 	ret = request_firmware(&params.fw, file_name, devlink->dev);
> 	if (ret)
>-		return ret;
>+		goto out_unlock;
> 
>-	devl_lock(devlink);
> 	devlink_flash_update_begin_notify(devlink);
> 	ret = devlink->ops->flash_update(devlink, &params, NULL);
> 	devlink_flash_update_end_notify(devlink);
>-	devl_unlock(devlink);
> 
> 	release_firmware(params.fw);
>+out_unlock:
>+	devl_unlock(devlink);
> 
> 	return ret;
> }
>diff --git a/net/devlink/core.c b/net/devlink/core.c
>index d3b8336946fd..2abad8247597 100644
>--- a/net/devlink/core.c
>+++ b/net/devlink/core.c
>@@ -67,6 +67,21 @@ void devl_unlock(struct devlink *devlink)
> }
> EXPORT_SYMBOL_GPL(devl_unlock);
> 
>+bool devl_is_alive(struct devlink *devlink)
>+{
>+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>+}
>+EXPORT_SYMBOL_GPL(devl_is_alive);
>+
>+/**
>+ * devlink_try_get() - try to obtain a reference on a devlink instance
>+ * @devlink: instance to reference
>+ *
>+ * Obtain a reference on a devlink instance. A reference on a devlink instance
>+ * only implies that it's safe to take the instance lock. It does not imply
>+ * that the instance is registered, use devl_is_alive() after taking
>+ * the instance lock to check registration status.
>+ */
> struct devlink *__must_check devlink_try_get(struct devlink *devlink)
> {
> 	if (refcount_inc_not_zero(&devlink->refcount))
>@@ -300,10 +315,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
> 	devlinks_xa_for_each_registered_get(net, index, devlink) {
> 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
> 		devl_lock(devlink);
>-		err = devlink_reload(devlink, &init_net,
>-				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>-				     DEVLINK_RELOAD_LIMIT_UNSPEC,
>-				     &actions_performed, NULL);
>+		err = 0;
>+		if (devl_is_alive(devlink))
>+			err = devlink_reload(devlink, &init_net,
>+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>+					     DEVLINK_RELOAD_LIMIT_UNSPEC,
>+					     &actions_performed, NULL);
> 		devl_unlock(devlink);
> 		devlink_put(devlink);
> 
>diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
>index b38df704be1c..773efaabb6ad 100644
>--- a/net/devlink/netlink.c
>+++ b/net/devlink/netlink.c
>@@ -98,7 +98,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
> 
> 	devlinks_xa_for_each_registered_get(net, index, devlink) {
> 		devl_lock(devlink);
>-		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
>+		if (devl_is_alive(devlink) &&
>+		    strcmp(devlink->dev->bus->name, busname) == 0 &&
> 		    strcmp(dev_name(devlink->dev), devname) == 0)
> 			return devlink;
> 		devl_unlock(devlink);
>@@ -210,7 +211,12 @@ int devlink_instance_iter_dump(struct sk_buff *msg, struct netlink_callback *cb)
> 
> 	devlink_dump_for_each_instance_get(msg, dump, devlink) {
> 		devl_lock(devlink);
>-		err = cmd->dump_one(msg, devlink, cb);
>+
>+		if (devl_is_alive(devlink))
>+			err = cmd->dump_one(msg, devlink, cb);
>+		else
>+			err = 0;
>+
> 		devl_unlock(devlink);
> 		devlink_put(devlink);
> 
>-- 
>2.38.1
>
