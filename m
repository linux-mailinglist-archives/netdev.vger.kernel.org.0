Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8B2696169
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjBNKss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjBNKsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:48:35 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12233900A
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:47:59 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id mc25so1619916ejb.13
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHNhTJBQnGSbR3VaGYk+HM9a6Rw4l5zLGw9CEd5wS4I=;
        b=O9Zgp1p6HhW3MvskwIc1ML/2DBoLQ1jgd/l9+o4mEzhqpTTbCtH4hyE3I1/iJYXhxl
         PZTNDqJgW60AD8Q2aegvUgIEjrIj5uVNHzKNm5CUWTnaLLNAj0fBWzNrGhLFzVtOHacT
         l0giSFl5eM1+54ylnW6YoOVEq4WMUQUF+KAPINoXAmnhoSmst01xqtsJlj9WGVmnai39
         v5kcEUkW8bJ9VJ55kR0UANG6AVvLrqJaYZQPwiVG8YHM1atVRPLafLFQ7qbuKV+4n+8g
         x23NMsVoDvET2Ye9AoChqvy7/JqeSHWGg/5MqEvW8rPEPG2xWhc1hhoygYAeweA63GE7
         xMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHNhTJBQnGSbR3VaGYk+HM9a6Rw4l5zLGw9CEd5wS4I=;
        b=ezYENFmipT4o94s2lYJJJ3b6cS1svljhmQy4O+d45YUNPLvn1auhmzNH04y+bRRE8y
         KAM7KgyP1R86SRTdwdKR4I8lVTbIpo2EnXylzvX5FjIrBvMp/ylP3DHnLhKHZQa4L+fA
         jsd0MMOct1snxQtzZumS/r308hy8P5upbqqJ419w4hEnXjrvZF+Y5X10K5C/2aFku8mU
         K8jVct6mO2jP32SlO84+DYpcjmBKxJcvFD+NHv6YEd9DLiyqMZFTi6ckt8ynoseJ+2rY
         budilYe6cb9JB1Y8eW9pkJzERd10mpGPS3uByXICOfTPr+Sa14CV6cjvqYYbuN7FfmKu
         2ibw==
X-Gm-Message-State: AO0yUKUO/cZvsCFFZ4IX/gt4C/q5pXpSepEt7hMqOsFNUsP6qvYN6bM5
        oIH6hez3E0izE82B7oMKOmQXZg==
X-Google-Smtp-Source: AK7set+FPPfGuBX+VWWtuOmDYyJOjhte3uAePCTubh3W5rcPzLAsLGFd4GLqSam8q4hPrHKVYFxTJA==
X-Received: by 2002:a17:906:c343:b0:878:7cf3:a9e7 with SMTP id ci3-20020a170906c34300b008787cf3a9e7mr2176375ejb.65.1676371677058;
        Tue, 14 Feb 2023 02:47:57 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e19-20020a170906749300b0088f8abd3214sm8181973ejl.92.2023.02.14.02.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 02:47:56 -0800 (PST)
Date:   Tue, 14 Feb 2023 11:47:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net] devlink: change port event netdev notifier from
 per-net to global
Message-ID: <Y+tm23NsQcWSAlhU@nanopsycho>
References: <20230206094151.2557264-1-jiri@resnulli.us>
 <Y+tJQJqyEekxIYdE@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+tJQJqyEekxIYdE@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 09:41:36AM CET, idosch@idosch.org wrote:
>On Mon, Feb 06, 2023 at 10:41:51AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Currently only the network namespace of devlink instance is monitored
>> for port events. If netdev is moved to a different namespace and then
>> unregistered, NETDEV_PRE_UNINIT is missed which leads to trigger
>> following WARN_ON in devl_port_unregister().
>> WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
>> 
>> Fix this by changing the netdev notifier from per-net to global so no
>> event is missed.
>> 
>> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  net/core/devlink.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>> 
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 032d6d0a5ce6..909a10e4b0dd 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -9979,7 +9979,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>>  		goto err_xa_alloc;
>>  
>>  	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
>> -	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
>> +	ret = register_netdevice_notifier(&devlink->netdevice_nb);
>>  	if (ret)
>>  		goto err_register_netdevice_notifier;
>>  
>> @@ -10171,8 +10171,7 @@ void devlink_free(struct devlink *devlink)
>>  	xa_destroy(&devlink->snapshot_ids);
>>  	xa_destroy(&devlink->ports);
>>  
>> -	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
>> -						       &devlink->netdevice_nb));
>> +	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
>>  
>>  	xa_erase(&devlinks, devlink->index);
>>  
>> @@ -10503,6 +10502,8 @@ static int devlink_netdevice_event(struct notifier_block *nb,
>>  		break;
>>  	case NETDEV_REGISTER:
>>  	case NETDEV_CHANGENAME:
>> +		if (devlink_net(devlink) != dev_net(netdev))
>> +			return NOTIFY_OK;
>>  		/* Set the netdev on top of previously set type. Note this
>>  		 * event happens also during net namespace change so here
>>  		 * we take into account netdev pointer appearing in this
>> @@ -10512,6 +10513,8 @@ static int devlink_netdevice_event(struct notifier_block *nb,
>>  					netdev);
>>  		break;
>>  	case NETDEV_UNREGISTER:
>> +		if (devlink_net(devlink) != dev_net(netdev))
>> +			return NOTIFY_OK;
>>  		/* Clear netdev pointer, but not the type. This event happens
>>  		 * also during net namespace change so we need to clear
>>  		 * pointer to netdev that is going to another net namespace.
>
>Since the notifier block is no longer registered per-netns it shouldn't
>be moved to a different netns on reload. I'm testing the following diff
>[1] against net-next (although it should be eventually submitted to
>net).

Oh yeah. That is needed. Thanks!

>
>[1]
>diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>index d9cdbc047b49..efbee940bb03 100644
>--- a/include/linux/netdevice.h
>+++ b/include/linux/netdevice.h
>@@ -2858,8 +2858,6 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
> int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
> int unregister_netdevice_notifier_net(struct net *net,
> 				      struct notifier_block *nb);
>-void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
>-				 struct notifier_block *nb);
> int register_netdevice_notifier_dev_net(struct net_device *dev,
> 					struct notifier_block *nb,
> 					struct netdev_net_notifier *nn);
>diff --git a/net/core/dev.c b/net/core/dev.c
>index 7307a0c15c9f..709b1a02820b 100644
>--- a/net/core/dev.c
>+++ b/net/core/dev.c
>@@ -1870,14 +1870,6 @@ static void __move_netdevice_notifier_net(struct net *src_net,
> 	__register_netdevice_notifier_net(dst_net, nb, true);
> }
> 
>-void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
>-				 struct notifier_block *nb)
>-{
>-	rtnl_lock();
>-	__move_netdevice_notifier_net(src_net, dst_net, nb);
>-	rtnl_unlock();
>-}
>-
> int register_netdevice_notifier_dev_net(struct net_device *dev,
> 					struct notifier_block *nb,
> 					struct netdev_net_notifier *nn)
>diff --git a/net/devlink/dev.c b/net/devlink/dev.c
>index ab4e0f3c4e3d..c879c3c78e18 100644
>--- a/net/devlink/dev.c
>+++ b/net/devlink/dev.c
>@@ -343,8 +343,6 @@ static void devlink_reload_netns_change(struct devlink *devlink,
> 	 * reload process so the notifications are generated separatelly.
> 	 */
> 	devlink_notify_unregister(devlink);
>-	move_netdevice_notifier_net(curr_net, dest_net,
>-				    &devlink->netdevice_nb);
> 	write_pnet(&devlink->_net, dest_net);
> 	devlink_notify_register(devlink);
> }
