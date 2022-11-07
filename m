Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3372361FB33
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiKGRYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiKGRYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:24:34 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD532250B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:24:32 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s12so9085478edd.5
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 09:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nu9i4FL1+eZ5jOv0EMSWj8rVxepdKdHDDkbMf187GUU=;
        b=M0wAH3AjcFHjaavNN5/6PP2jzaalbB0Z+RJCZHJ01XuavQbnklZ+ArWskHtuIEakxJ
         fwJ/EZQM12QKXelf/lHOtyBkX6NeHE3DPvbCD2SS6Y9dF71HZqkonuu0CPFPgkHcnyRt
         rI+kXKA8u9pvum52GpvldO8m4WFuhfTZMaKC7DAEsao+ulznqfDYjO0MgpIWQgjRlM7T
         9SG1szcmCYrCIgg4zr4GgFlenxLXBcT+FnfAmdIsrAATDMTX/blcrWl7Sd50mTAunimM
         uuP5m9P/PJTEUNVaQfUPAto29YH00GIJyBXri5dP5BscSF/zo1+8S3s162liLlL/oesR
         RmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nu9i4FL1+eZ5jOv0EMSWj8rVxepdKdHDDkbMf187GUU=;
        b=T7y1xmwCmsw0Dj3vHMvcLczpSiCWsTqlw8+W7o+CQHpYxZDVTJYUAtSG24Uzk/A78S
         N+N5RWe0S9xZO990Uzpdxk+o4m/zE0MNS1H3sWe1dtnqgXIvsEslqGnb9Onqe8CxGI3y
         nh57NugmEVq7WF7SFbzEI9d5KHPIILoz1vVPELC4uLRiq35RU27VrTQcNKSg4f5O7n7J
         c340Ccr5gFpzA8gioGAgzf5fS5R1MctBBA2FRWgmgEsPhORz7Nde8SCnnaUnVu5PRR+8
         xzYY7uyOQ5f4O6cPWhvONjoadQtL3QfmIxVNwnxQs76XUTfw0hrXV9alqXcSwjd+uRNP
         0L7A==
X-Gm-Message-State: ACrzQf1yZE6PIAC2MXbYnZYwqhblET9/vG195aZy31IExZAnU+e/fj4f
        I7EEdxJPapY5YW2BVIA2Vygd9IqXIGFvDrJNOCA=
X-Google-Smtp-Source: AMsMyM7NH+toedXmtKOIK6/q2fYbfiCB+y+yA/JGgm1ubmdgbY6OTa4SLMTr6eoujcIMl/XhE8Nu/Q==
X-Received: by 2002:a05:6402:540d:b0:450:bda7:f76e with SMTP id ev13-20020a056402540d00b00450bda7f76emr30491967edb.249.1667841870973;
        Mon, 07 Nov 2022 09:24:30 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o5-20020a170906768500b007a1d4944d45sm3701982ejm.142.2022.11.07.09.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 09:24:30 -0800 (PST)
Date:   Mon, 7 Nov 2022 18:24:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next 2/2] net: devlink: move netdev notifier block to
 dest namespace during reload
Message-ID: <Y2k/TUCa3/BXne9Q@nanopsycho>
References: <20221107145213.913178-1-jiri@resnulli.us>
 <20221107145213.913178-3-jiri@resnulli.us>
 <Y2k3uIMn2R42AH6q@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2k3uIMn2R42AH6q@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 07, 2022 at 05:52:08PM CET, idosch@idosch.org wrote:
>On Mon, Nov 07, 2022 at 03:52:13PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> The notifier block tracking netdev changes in devlink is registered
>> during devlink_alloc() per-net, it is then unregistered
>> in devlink_free(). When devlink moves from net namespace to another one,
>> the notifier block needs to move along.
>> 
>> Fix this by adding forgotten call to move the block.
>> 
>> Reported-by: Ido Schimmel <idosch@idosch.org>
>> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Does not trigger with my reproducer. Will test the fix tonight in
>regression and report tomorrow morning.

Ok!

>
>> ---
>>  net/core/devlink.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 40fcdded57e6..ea0b319385fc 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -4502,8 +4502,11 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>>  	if (err)
>>  		return err;
>>  
>> -	if (dest_net && !net_eq(dest_net, curr_net))
>> +	if (dest_net && !net_eq(dest_net, curr_net)) {
>> +		move_netdevice_notifier_net(curr_net, dest_net,
>> +					    &devlink->netdevice_nb);
>>  		write_pnet(&devlink->_net, dest_net);
>> +	}
>
>I suggest adding this:
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 83fd10aeddd5..3b5aedc93335 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -9843,8 +9843,8 @@ void devlink_free(struct devlink *devlink)
> 
>        xa_destroy(&devlink->snapshot_ids);
> 
>-       unregister_netdevice_notifier_net(devlink_net(devlink),
>-                                         &devlink->netdevice_nb);
>+       WARN_ON(unregister_netdevice_notifier_net(devlink_net(devlink),
>+                                                 &devlink->netdevice_nb));
> 
>        xa_erase(&devlinks, devlink->index);
>
>This tells about the failure right away. Instead, we saw random memory
>corruptions in later tests.

Should be a separate patch then.


>
>>  
>>  	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
>>  	devlink_reload_failed_set(devlink, !!err);
>> -- 
>> 2.37.3
>> 
