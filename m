Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB163DB7F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiK3RFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiK3RFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:05:07 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DFA7062C
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:00:08 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id td2so28743499ejc.5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QaTPllFhiFxfAskxhNbu2e1XrpAWvShDuFJlx0DJFMw=;
        b=jn2LbdTwYcE+a6iNQvZ/Une4LtxDuEQxpxYLVRxx65nDS1fUGqGCuH+NEszEKvEegG
         2WZTZNiQnfKiCf1AwQLqm6NqkuGOliAzvjwN9e4p0g2kYPcb9CH5QUKsTb5ZxtcrBsDJ
         LPJrITS952y3m20behd4YkLOb9UZM3J6ipc4c3i5jFZW1Lg9yrKoPcv9NPkFty2Hi7G5
         55Dr85yyqZKyt2G41UXT9txBVm+2nvAWents6uUx71W00R0zGD6m9BVwdA8lEAx6+0aQ
         tqbCDFcDSGiMe5EY14IbK1ex6lO9mBRpcc9zM7lA0tTCS+JV2aHLvVIdGMioExoSkK1k
         Y3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QaTPllFhiFxfAskxhNbu2e1XrpAWvShDuFJlx0DJFMw=;
        b=a2xnGrePKihSRmIeJ/t7IOrZfU6VyZwI61IN2sEvN6jcMJBC9oqVQsv7VZNTNZDYRD
         cc1tsF1KkYpKgEkFfRFzinhtd6MQIKYF8ZFNzoWPt+pFt9ADjAhTYe2jnIFd87kPNwIR
         i14mxjnScv5iAzIMy7stocm0so45imP2URCVq9s26QoGGdA/oRtFB1gEb0Pr489TJO9D
         EwnB5el+uAfB45YyvsmGThhj83RL/qIxmBQKj9xdIoVFz1TQsmEwd6rF1y+4/4PoHBml
         F/acbVquZTbvMkGRbekJVzcreyOx4/PceUkAuLiPI1Bc3gmGl/iWEpV686iMxKZRvf2X
         S0nw==
X-Gm-Message-State: ANoB5pm9xTpzHgE5trN5FUfSPJ9BKMyS0zgdbNm3F8bxjaUKZqLjTS7t
        chuKnm6SWRINCqrDab7vX25bDg==
X-Google-Smtp-Source: AA0mqf4fX/4oxvlCmlobQ9Xd54n2L0OnElKDx3OgqPuKgqDlevMzD5rJJGEmujURm5K2aeFlSKVByQ==
X-Received: by 2002:a17:906:a20f:b0:7bf:f0e9:1cde with SMTP id r15-20020a170906a20f00b007bff0e91cdemr12907082ejy.512.1669827607197;
        Wed, 30 Nov 2022 09:00:07 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b007ad9c826d75sm835317ejf.61.2022.11.30.09.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:00:06 -0800 (PST)
Date:   Wed, 30 Nov 2022 18:00:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4eMFUBWKuLLavGB@nanopsycho>
References: <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
 <Y4dBrx3GTl2TLIrJ@nanopsycho>
 <20221130084659.618a8d60@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221130084659.618a8d60@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 30, 2022 at 05:46:59PM CET, kuba@kernel.org wrote:
>On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote:
>> >Look at the __devlink_free() and changes 
>> >to devlink_compat_flash_update() here:
>> >
>> >https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/  
>> 
>> **)
>> I see. With the change I suggest, meaning doing
>> devlink_port_register/unregister() and netdev_register/unregister only
>> for registered devlink instance, you don't need this at all. When you
>> hit this compat callback, the netdevice is there and therefore devlink
>> instance is registered for sure.
>
>If you move devlink registration up it has to be under the instance
>lock, otherwise we're back to reload problems. That implies unregister
>should be under the lock too. But then we can't wait for refs in
>unregister. Perhaps I don't understand the suggestion.

I unlock for register and for the rest of the init I lock again.


>
>> >The model I had in mind (a year ago when it all started) was that 
>> >the driver takes the devlink instance lock around its entire init path,
>> >including the registration of the instance. This way the devlink
>> >instance is never visible "half initialized". I mean - it's "visible"
>> >as in you can see a notification over netlink before init is done but
>> >you can't access it until the init in the driver is completed and it
>> >releases the instance lock.  
>> 
>> What is "half-initialized"? Take devlink reload flow for instance. There
>> are multiple things removed/readded, like devlink_port and related
>> netdevice. No problem there.
>
>Yes, but reload is under the instance lock, so nothing can mess with 
>a device in a transitional state.

Sure, that is what I want to do too. To be under instance lock.

>
>> I think that we really need to go a step back and put the
>> devlink_register at the point of init flow where all things that are
>> "static" during register lifetime are initialized, the rest would be
>> initialized later on. This would make things aligned with
>> devlink_reload() and would make possible to share init/fini/reload
>> code in drivers.
>
>Yes, I agree that the move should be done but I don't think its
>sufficient.
>
>> >For that to work and to avoid ordering issues with netdev we need to
>> >allow unregistering a devlink instance before all references are gone.  
>> 
>> References of what? devlink instance, put by devlink_put()?
>
>Yes.
>
>> >So we atomically look up and take a reference on a devlink instance.
>> >Then take its lock. Then under the instance lock we check if it's still
>> >registered.  
>> 
>> As mentioned above (**), I don't think this is needed.
>
>But it is, please just let me do it and make the bugs stop 😭

Why exactly is it needed? I don't see it, pardon my ignorance :)

Let me send the RFC of the change tomorrow, you'll see what I mean.
