Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA5E66006D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjAFMmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbjAFMmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:42:11 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746CB71896
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:41:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a184so964224pfa.9
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TTDFH6zNk9XWWHgfsaQt+7diT2Fi0SeVhoaL6E+89bg=;
        b=Ms27xndaWe7to3qYA6wnjKdyFF9c0hpOSFYMfwaHcWWhI0bKcEdK2/78g+jtIeJI5h
         sSwimo/VxB2HNYAWO4wVmvtbLGgjMGGtg2fda12e/hroO9Eahpm0Y2Zq39x4cyDbp8N6
         BpHefRDHmqKQYmGwGxelTTl3qyWIV5oueruUSg1NM3L/4fD47PB0TaUyXW3bDXUpKpbe
         49kWz8zSSsQ7t8VmVzzOt6nnU3w3UJILfz8+4ukpyJUK3ko5s6tbc/0xQaXnAsuYvJB3
         Pc/3PcfI65eSCZI2EAjnxDvaNq6WJTf582IRu4fD+fQnFKljv1L4WQGoRiJyrCBFbqSt
         +TUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTDFH6zNk9XWWHgfsaQt+7diT2Fi0SeVhoaL6E+89bg=;
        b=s1MJ4GU0XXOVxAWU/VRlF9u0PKq4ytdOmxQokGEyGW1QxpYH39Pj6Um6fRMzYLp91T
         akYiDdDzlEatK5/ctq8Ekc/ALu1Z7aU84EmOf9N9BlooF9GSueAiHYNK0sxN2Lsa5HAH
         Ujn/uE+reGwjqpYeprW/7LKHm70K2OjDfBevJnLvBwj6IeJ4nGJsFEF09KdUsVo46QoO
         1sTBNRoHEQGg9XZqJtbh57Yzx2tS2aNQ1zMoGZpk58wrJOAOxkNuGewuqjNZ4r88/PWr
         GZJ+uFP/JaM501xlbGavTLMdfKhhkoMpfAWJ633mirfFOhLTpd8Hl55IzjGbApIdQWhO
         2WDA==
X-Gm-Message-State: AFqh2krQZ3l9skPWpNxlgeFPHEjXrgzjE3/r6BkzbgTASMgW1pGTELPh
        miZdQFw0KY6Afcku1glx5YruGg==
X-Google-Smtp-Source: AMrXdXtEJGBB+RN9wGYueTR2bPLC0+/Xc+DLfTWBFAs0zrkULb7RLaEiyIle10LmqjtPwulCfPYGfA==
X-Received: by 2002:a05:6a00:4c8c:b0:581:61a7:c8f0 with SMTP id eb12-20020a056a004c8c00b0058161a7c8f0mr36537999pfb.4.1673008917867;
        Fri, 06 Jan 2023 04:41:57 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id q1-20020aa79821000000b005821db4ff2csm1057865pfl.69.2023.01.06.04.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 04:41:57 -0800 (PST)
Date:   Fri, 6 Jan 2023 13:41:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 4/9] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7gXEk3XEXGEpooC@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:33:57AM CET, kuba@kernel.org wrote:
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
> net/devlink/core.c          | 19 +++++++++++++++----
> net/devlink/devl_internal.h |  8 ++++++++
> net/devlink/leftover.c      | 35 +++++++++++++++++++++++++++++------
> net/devlink/netlink.c       | 10 ++++++++--
> 4 files changed, 60 insertions(+), 12 deletions(-)
>
>diff --git a/net/devlink/core.c b/net/devlink/core.c
>index d3b8336946fd..c53c996edf1d 100644
>--- a/net/devlink/core.c
>+++ b/net/devlink/core.c
>@@ -67,6 +67,15 @@ void devl_unlock(struct devlink *devlink)
> }
> EXPORT_SYMBOL_GPL(devl_unlock);
> 
>+/**
>+ * devlink_try_get() - try to obtain a reference on a devlink instance
>+ * @devlink: instance to reference
>+ *
>+ * Obtain a reference on a devlink instance. A reference on a devlink instance
>+ * only implies that it's safe to take the instance lock. It does not imply
>+ * that the instance is registered, use devl_is_registered() after taking
>+ * the instance lock to check registration status.
>+ */
> struct devlink *__must_check devlink_try_get(struct devlink *devlink)
> {
> 	if (refcount_inc_not_zero(&devlink->refcount))
>@@ -300,10 +309,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
> 	devlinks_xa_for_each_registered_get(net, index, devlink) {
> 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
> 		devl_lock(devlink);
>-		err = devlink_reload(devlink, &init_net,
>-				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>-				     DEVLINK_RELOAD_LIMIT_UNSPEC,
>-				     &actions_performed, NULL);
>+		err = 0;
>+		if (devl_is_registered(devlink))
>+			err = devlink_reload(devlink, &init_net,
>+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>+					     DEVLINK_RELOAD_LIMIT_UNSPEC,
>+					     &actions_performed, NULL);
> 		devl_unlock(devlink);
> 		devlink_put(devlink);
> 
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index 6342552e5f99..01a00df81d0e 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -86,6 +86,14 @@ extern struct genl_family devlink_nl_family;
> 
> struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
> 
>+static inline bool devl_is_registered(struct devlink *devlink)
>+{
>+	/* To prevent races the caller must hold the instance lock
>+	 * or another lock taken during unregistration.
>+	 */
>+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>+}
>+
> /* Netlink */
> #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
> #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
>diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>index bec408da4dbe..491f821c8b77 100644
>--- a/net/devlink/leftover.c
>+++ b/net/devlink/leftover.c
>@@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
> 		int idx = 0;
> 
> 		mutex_lock(&devlink->linecards_lock);
>+		if (!devl_is_registered(devlink))
>+			goto next_devlink;
>+
> 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
> 			if (idx < state->idx) {
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
>+		if (!devl_is_registered(devlink)) {

Good. I have patchset to remove this and linecard lock prepared. That
makes things smoother.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>



>+			mutex_unlock(&devlink->reporters_lock);
>+			devlink_put(devlink);
>+			continue;
>+		}
>+
> 		list_for_each_entry(reporter, &devlink->reporter_list,
> 				    list) {
> 			if (idx < state->idx) {
>@@ -7830,6 +7840,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
> 		mutex_unlock(&devlink->reporters_lock);
> 
> 		devl_lock(devlink);
>+		if (!devl_is_registered(devlink))
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
>-	__devlink_compat_running_version(devlink, buf, len);
>+	if (devl_is_registered(devlink))
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
>+	if (!devl_is_registered(devlink)) {
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
>diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
>index 69111746f5d9..b5b8ac6db2d1 100644
>--- a/net/devlink/netlink.c
>+++ b/net/devlink/netlink.c
>@@ -98,7 +98,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
> 
> 	devlinks_xa_for_each_registered_get(net, index, devlink) {
> 		devl_lock(devlink);
>-		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
>+		if (devl_is_registered(devlink) &&
>+		    strcmp(devlink->dev->bus->name, busname) == 0 &&
> 		    strcmp(dev_name(devlink->dev), devname) == 0)
> 			return devlink;
> 		devl_unlock(devlink);
>@@ -211,7 +212,12 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
> 
> 	devlink_dump_for_each_instance_get(msg, state, devlink) {
> 		devl_lock(devlink);
>-		err = cmd->dump_one(msg, devlink, cb);
>+
>+		if (devl_is_registered(devlink))
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
