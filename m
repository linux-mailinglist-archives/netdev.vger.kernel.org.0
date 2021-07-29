Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDDD3DA2A3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhG2L5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbhG2L5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:57:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A192C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:57:04 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n28-20020a05600c3b9cb02902552e60df56so3827255wms.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ba1iJmAyqagKpMTSuItuq8ZuW63KNd8SLJ5GPxqSiTM=;
        b=PLmD+kqV9jVV9jdFgXijZPCNG7nsHnJHhvGJQBZGo932IYTMwPsr3uXMRaP8lf2O5v
         vtXFF1rjgGn9yMKXnFavFZTCaxJhqbJXU6KEHPpHM1tKYBJwR44X/4Je13FkZGPNsJA3
         /4JukIx5folmD5H8kKIZEM8KWUYZOEYiDtssSOQfldELHART8LimyJyViJc1hzuOS1og
         M/6o2lz1okAMdeeTH1D4t9acJ77kqQO+MTl/Sp+ltVjP0yOhuw8XBQy2qsEAOgE+TG9E
         Jh/P4CCsyMBwp6qCBKO9B3MUDjVEIsEvQtbgfaG8KSzB/vzzqR5W4o/fL806UAhvck3d
         slvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ba1iJmAyqagKpMTSuItuq8ZuW63KNd8SLJ5GPxqSiTM=;
        b=IY2jZ5+Wj0KMEzW1zR73R55tGr3Y5n+hh8sp6dBpq0XPl9hkaZIobCrZuIf55gRwv5
         CCqsurOMkAW1vUd17py2q29ybtkIBfMrqIcDmqxiN+PHqUozoMj3ONzhZgiu+iT2qGz6
         B7F4fG2dGjdFNaO7gulAZ71ZlGexl4i/80hWWokleOxGtajgF1SdpfnEX7imIeoFQr5q
         SA57/fAMOtqtWpUTEy7mgv9FepGd5Fj1dMYUrHMXUgFYOgYuTYMbVQLMt98vDjaOfpKA
         slnd/g3t6/dIQ7Iqp7tbHJWrvWPz7Z54HaWlncTQoblzFnCMAoo3fwiuz2jzz4PC6wbV
         ujmA==
X-Gm-Message-State: AOAM5302FC3MTgcyyq9FGRMW8k/wXW/ZL3XHsp8Ep96v3+8aZPo73Ci/
        tv6+7sgSvDEgLDmDv0QhBjR1dOjj3Q3ysMsw9Pk=
X-Google-Smtp-Source: ABdhPJy8Tt3gIUtlY+O4+Vt07HJLNE5VaAZCJqIPEVk1+JLINxzpXlPsOxRSMzvhp9N/OX5E5S71fA==
X-Received: by 2002:a05:600c:4f4d:: with SMTP id m13mr4435100wmq.9.1627559822691;
        Thu, 29 Jul 2021 04:57:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t17sm2673417wmq.17.2021.07.29.04.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 04:57:02 -0700 (PDT)
Date:   Thu, 29 Jul 2021 13:57:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Break parameter notification
 sequence to be before/after unload/load driver
Message-ID: <YQKXjTZ0W04L7xqG@nanopsycho>
References: <cover.1627545799.git.leonro@nvidia.com>
 <6d59d527ccbec04615ef0b4a237ea4e27f10cd8d.1627545799.git.leonro@nvidia.com>
 <YQKPkmYfKdM9zE5f@nanopsycho>
 <YQKSmwzppN4KNQiX@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQKSmwzppN4KNQiX@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 29, 2021 at 01:35:55PM CEST, leon@kernel.org wrote:
>On Thu, Jul 29, 2021 at 01:22:58PM +0200, Jiri Pirko wrote:
>> Thu, Jul 29, 2021 at 10:15:25AM CEST, leon@kernel.org wrote:
>> >From: Leon Romanovsky <leonro@nvidia.com>
>
><...>
>
>> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >index b596a971b473..54e2a0375539 100644
>> >--- a/net/core/devlink.c
>> >+++ b/net/core/devlink.c
>> >@@ -3801,8 +3801,9 @@ static void devlink_param_notify(struct devlink *devlink,
>> > 				 struct devlink_param_item *param_item,
>> > 				 enum devlink_command cmd);
>> > 
>> >-static void devlink_reload_netns_change(struct devlink *devlink,
>> >-					struct net *dest_net)
>> >+static void devlink_params_notify(struct devlink *devlink, struct net *dest_net,
>> 
>> Please name it differently. This function notifies not only the params,
>> but the devlink instance itself as well.
>
>I'm open for suggestion. What did you have in mind?

devlink_ns_change_notify?

>
>> 
>> 
>> >+				  struct net *curr_net,
>> >+				  enum devlink_command cmd)
>> > {
>> > 	struct devlink_param_item *param_item;
>> > 
>> >@@ -3812,17 +3813,17 @@ static void devlink_reload_netns_change(struct devlink *devlink,
>> > 	 * reload process so the notifications are generated separatelly.
>> > 	 */
>> > 
>> >-	list_for_each_entry(param_item, &devlink->param_list, list)
>> >-		devlink_param_notify(devlink, 0, param_item,
>> >-				     DEVLINK_CMD_PARAM_DEL);
>> >-	devlink_notify(devlink, DEVLINK_CMD_DEL);
>> >+	if (!dest_net || net_eq(dest_net, curr_net))
>> >+		return;
>> > 
>> >-	__devlink_net_set(devlink, dest_net);
>> >+	if (cmd == DEVLINK_CMD_PARAM_NEW)
>> >+		devlink_notify(devlink, DEVLINK_CMD_NEW);
>> 
>> This is quite odd. According to PARAMS cmd you decife devlink CMD.
>> 
>> Just have bool arg which would help you select both
>> DEVLINK_CMD_PARAM_NEW/DEL and DEVLINK_CMD_NEW/DEL
>
>The patch is quite misleading, but the final result looks neat:
>
>   3847 static void devlink_params_notify(struct devlink *devlink, struct net *dest_net,
>   3848                                   struct net *curr_net,
>   3849                                   enum devlink_command cmd)
>   3850 {
>   3851         struct devlink_param_item *param_item;
>   3852 
>   3853         /* Userspace needs to be notified about devlink objects
>   3854          * removed from original and entering new network namespace.
>   3855          * The rest of the devlink objects are re-created during
>   3856          * reload process so the notifications are generated separatelly.
>   3857          */
>   3858 
>   3859         if (!dest_net || net_eq(dest_net, curr_net))
>   3860                 return;
>   3861 
>   3862         if (cmd == DEVLINK_CMD_PARAM_NEW)
>   3863                 devlink_notify(devlink, DEVLINK_CMD_NEW);

Nothing misleading here. This is exactly what I'm pointing out...



>   3864 
>   3865         list_for_each_entry(param_item, &devlink->param_list, list)
>   3866                 devlink_param_notify(devlink, 0, param_item, cmd);
>   3867 
>   3868         if (cmd == DEVLINK_CMD_PARAM_DEL)
>   3869                 devlink_notify(devlink, DEVLINK_CMD_DEL);
>   3870 }
>
>
>So as you can see in line 3866, we anyway will need to provide "cmd", so
>do you suggest to add extra two bool variables to the function signature
>to avoid "cmd == DEVLINK_CMD_PARAM_NEW" and "cmd == DEVLINK_CMD_PARAM_DEL" ifs?
>
>Thanks
