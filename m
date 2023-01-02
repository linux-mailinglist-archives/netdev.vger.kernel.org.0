Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF0865B300
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbjABN61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjABN6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:58:22 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6975593
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 05:58:20 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id y8so26323501wrl.13
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 05:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/14tuXJ33w9oORIh+APauLeiH3rkdbP5ku9k2FH3mE=;
        b=a7Cur1F7G3d6wsN/n7zH5uWQ8fpov9zS9R8gMm8LZDiDuvWQm/WKrk78RdSu3yRGmY
         4S9qONXVDSzLdvaJnR860bjYFypC7WeDY8Q6fK60nk+wFyRGHWt7NMCwqcCtLEY0lKce
         e4x3YdWfEmJEx6YcinPrJ35/IkskvLafovb0zvZDZHveSzW0I2nTOzoj0uzyqhBrUVrd
         FTySmaNV6fBzP0bEgHHkehw8u2ptqIQa9osr1Z+u68m+OtMGzYMNEYphMGYyF5oYBZZI
         74YUI+TJOrg30vzm7NHKooRt6A+d5toOlvNkP+7PocnDtHjC9XNM8elFf5Dy/qlwnmxZ
         pDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/14tuXJ33w9oORIh+APauLeiH3rkdbP5ku9k2FH3mE=;
        b=xQWfaiq7udzi5QFDA8GkIIo+NRHEcv43DrWc2NXC0/Wjvy8bfnVgS09ool6AyrtBkn
         W7ExhFUiQZ7kPR4zpGHA2g7r7yzikcLVjOHp2M+35zqDcWDSpfL24lLVkwo0lpm3Au7h
         7babMzBMEq0AcuO9wB/qs0012Zv0zGu3sQ3/b7DAdfaRV8Z+vhTablxMtehsv/3tcqCy
         4C9k/JflTsNtiSrMM+LghbX8tndHfNRktr872+Lttg2k6tGH9iJ+cF+LtYcIKHN0QbIi
         ka2pw9U+7fmHH+Yd5QrZgD7ycfFvaAvnXCt8MipYedwgrFA1+sxnQacvQhCheQqP3wB9
         rojw==
X-Gm-Message-State: AFqh2kr+y2hY8zCTsbFtkhCixfiMa2N2g7tIsCFaqVYXZOC0xR0uXxEV
        Z9onlLoY7H5ZkQSl0PJnETKQRQ==
X-Google-Smtp-Source: AMrXdXuCMowYsxMa12HnWN9Z57tEhRsydjSOdggc7rZe5MHG0MZCjMO4lyU5tG3K2zhYTPtgvJ20GA==
X-Received: by 2002:a05:6000:69c:b0:281:67a6:5138 with SMTP id bo28-20020a056000069c00b0028167a65138mr17046397wrb.15.1672667898495;
        Mon, 02 Jan 2023 05:58:18 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t4-20020a5d42c4000000b002876ab9debcsm17765732wrr.36.2023.01.02.05.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 05:58:17 -0800 (PST)
Date:   Mon, 2 Jan 2023 14:58:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7Li+GMB6BU+D/6W@nanopsycho>
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

This would be probably very valuable to add as a comment inside the code
for the future reader mind sake.


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

Why "alive"? To be consistent with the existing terminology, how about
to name it devl_is_registered()?

Also, "devl_" implicates that it should be called with devlink instance
lock held, so probably devlink_is_registered() would be better.


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

This comment is not related to the patch, should be added in a separate
one.


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
