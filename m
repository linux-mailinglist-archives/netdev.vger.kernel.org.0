Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEC163D4AD
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbiK3Ldr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiK3LdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:33:11 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E112B622
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:32:10 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z20so23608559edc.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCLizZFqVMBex6LDJOdkhOaN/HpY/Uk9igOYheHLaTg=;
        b=yzlILFHR/R6Yxu0o4xL4jZDZZlXSu4xrYgGgCQG1kRXtuz2GLMop34AG0/901+NmLy
         BiikA65CzhUlo4uE4xQp10ko24VTFNtTEQwBMZfLmxK7KgMIj+jyLL14tQv7zXbb3oKd
         /nNUnFsKJoE2sj4KCDtgvTQ80ERxKCtgC50To4J8St6L6eI1M475DDZ6u/r09bHm8r6m
         o00QtW/Npz35anmjMKq2XhH3Lss5MZga9aS52VR02XYodWNdvD73NnJXpZqJwaHGGb0r
         dM33mcWna6q3DZ9aGpb4i/HYZwPZXHIzTWtyEBvjK2GL4Mu4+V0DlFkxx8EfUNAU9WHc
         XUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCLizZFqVMBex6LDJOdkhOaN/HpY/Uk9igOYheHLaTg=;
        b=QiSIrwyBw/gFeNx/qxtV5V6JpRz7hlwuusM+Z1AYrSnMzAiGE1ghOQZbI2Go+GHyw2
         cEo+3m63Y9LyhqCqQccLRlRfYYEgQGgTU9Jphu6LGVGcjnso5iiKoUZ41BEu5W3MrVfx
         iJ4uouURZmckrcwD0zf6EFuEAV2UdPYsU2lInxZGGK6R93Rpph0Eyo6SuQYn2qU9aP1u
         Xdep2QY0mKPP4LlEVytOuqFcVXyKYjU2Pnhf795u9xQammNZw0+i428ysPvpqZjjAIsE
         EnddBc579Hx79XMzqBkSF4/xyynrRakkzCjdZC1MkR8u8qPwo1IkrdB/NJHyCYX0M6+J
         KZiA==
X-Gm-Message-State: ANoB5pn7QD2EWBn+1R4LD+Ikal8IQTEX8tgkggHylYQQkdXArm88lwnC
        SHD3o1lh8v1rRW61LwPRyWqtCA==
X-Google-Smtp-Source: AA0mqf4O+Hd8z0mVWfoygK5QZFBMteR5gkjA+2HeAFksyVh/9bSShZ3US0+wjO3yKQsZBDYrEuXJzw==
X-Received: by 2002:a05:6402:e9c:b0:458:d064:a8c2 with SMTP id h28-20020a0564020e9c00b00458d064a8c2mr55631300eda.346.1669807929185;
        Wed, 30 Nov 2022 03:32:09 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id lb26-20020a170907785a00b00781e7d364ebsm544849ejc.144.2022.11.30.03.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 03:32:08 -0800 (PST)
Date:   Wed, 30 Nov 2022 12:32:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4c/N/H0xrGQwnKP@nanopsycho>
References: <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
 <Y4caLsLEQFMgz7HV@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4caLsLEQFMgz7HV@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 30, 2022 at 09:54:06AM CET, leon@kernel.org wrote:
>On Tue, Nov 29, 2022 at 06:18:26PM -0800, Jakub Kicinski wrote:
>> On Tue, 29 Nov 2022 09:31:40 +0100 Jiri Pirko wrote:
>> > >Cool. Do you also agree with doing proper refcounting for the devlink
>> > >instance struct and the liveness check after locking the instance?  
>> > 
>> > Could you elaborate a bit more? I missed that in the thread and can't
>> > find it. Why do we need it?
>> 
>> Look at the __devlink_free() and changes 
>> to devlink_compat_flash_update() here:
>> 
>> https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/
>> 
>> The model I had in mind (a year ago when it all started) was that 
>> the driver takes the devlink instance lock around its entire init path,
>> including the registration of the instance. This way the devlink
>> instance is never visible "half initialized". I mean - it's "visible"
>> as in you can see a notification over netlink before init is done but
>> you can't access it until the init in the driver is completed and it
>> releases the instance lock.
>
>In parallel thread, Jiri wanted to avoid this situation of netlink
>notifications for not-visible yet object. He gave as an example
>devlink_port which is advertised without devlink being ready.

To be honest, I'm lost tracking what you point at. I never suggested to
send notification of devlink_port before devlink notification is sent
previously. Perhaps you misread that.

>
>Thanks
