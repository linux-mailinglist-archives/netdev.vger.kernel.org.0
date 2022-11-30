Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEE963D4D7
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbiK3Lmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiK3Lms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:42:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C171165BF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:42:43 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n21so40624202ejb.9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVHPV8npvhmDLhaDDRX2HQfR7gJ2e0jetXkbXrsSGHg=;
        b=xH8CQJNFAyLGi9v3vQToDxCeqUiO0MYPqGfjvq7j3g/Fafb2bI6P/X2z9lrjhhpVLs
         abEzKUwV7Y67+E7S8plCQtFMk1Uld2fdzU1idWCy3S9pTJhp1VAVRrV/C+bWYPx/9Yjm
         ncCUeRVVFyHmsUUJU+8YqwiFozv8GU7qHlrls29rYXde9UYp/nWeAqSZ+5JMTtKMX6J1
         A20dXM4rQ52tvrFFIIhuxQ9PTVWeKqISTHeGhrzEoHJorJy4mzTnV3wsyFB2489cKuDC
         yzI8kY6PCUPFcErax3CPLNShIdA6evZ4Le5j8X65KCpluM2/9hbeni2L0oDcRnuJLYz8
         5W1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVHPV8npvhmDLhaDDRX2HQfR7gJ2e0jetXkbXrsSGHg=;
        b=PYadpq/DQXJHNceZEqAtq/du2eFPt/d1IJWp1RzuMfIbeQHifV8NyhklGeeF9xeAht
         UJtPuxM7TuzaOXkrrnQk2vlX3M08PzidCxEiu3KXnLL/kWvXJmBIGFy+Rx7a16nts2BJ
         oVIJwp2lXZaEQlO5peTVX3+oxQLfcbQDhIqEePFcCmhuyNrmph0/WUNfY2dlGz5fD4P0
         Et7409NXzVoWmE9+vchVY0nZqTQ/74MzRUtiq/9VxuHP+dswITe2KAmwt6SAejrQDmny
         cmZXmKkZ4L2zzOXS9wEI66cmih9DaHhOyz9nMgT3MJZXLBobrqapnvmewiBi4zaiTNfZ
         PMyg==
X-Gm-Message-State: ANoB5pmPCReHFZex5Wb+fbB8UF9jCIys9rLRm3ovnorDzakmSzH9jqDv
        knBayh6RDst6+6HQg8A6KloxUg==
X-Google-Smtp-Source: AA0mqf5SxfWFr9kaYKgHUgKDwjIpYTYCuTeHGLhGHrYCVt/MLvlIXwPC/BWfxL/Dd0TefIPWIHFmXA==
X-Received: by 2002:a17:907:3f8a:b0:7bf:4ae6:c36 with SMTP id hr10-20020a1709073f8a00b007bf4ae60c36mr13971780ejc.674.1669808561785;
        Wed, 30 Nov 2022 03:42:41 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id pk18-20020a170906d7b200b007c094d31f35sm551612ejb.76.2022.11.30.03.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 03:42:40 -0800 (PST)
Date:   Wed, 30 Nov 2022 12:42:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4dBrx3GTl2TLIrJ@nanopsycho>
References: <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129181826.79cef64c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 30, 2022 at 03:18:26AM CET, kuba@kernel.org wrote:
>On Tue, 29 Nov 2022 09:31:40 +0100 Jiri Pirko wrote:
>> >Cool. Do you also agree with doing proper refcounting for the devlink
>> >instance struct and the liveness check after locking the instance?  
>> 
>> Could you elaborate a bit more? I missed that in the thread and can't
>> find it. Why do we need it?
>
>Look at the __devlink_free() and changes 
>to devlink_compat_flash_update() here:
>
>https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/

**)
I see. With the change I suggest, meaning doing
devlink_port_register/unregister() and netdev_register/unregister only
for registered devlink instance, you don't need this at all. When you
hit this compat callback, the netdevice is there and therefore devlink
instance is registered for sure.


>
>The model I had in mind (a year ago when it all started) was that 
>the driver takes the devlink instance lock around its entire init path,
>including the registration of the instance. This way the devlink
>instance is never visible "half initialized". I mean - it's "visible"
>as in you can see a notification over netlink before init is done but
>you can't access it until the init in the driver is completed and it
>releases the instance lock.

What is "half-initialized"? Take devlink reload flow for instance. There
are multiple things removed/readded, like devlink_port and related
netdevice. No problem there.

I think that we really need to go a step back and put the
devlink_register at the point of init flow where all things that are
"static" during register lifetime are initialized, the rest would be
initialized later on. This would make things aligned with
devlink_reload() and would make possible to share init/fini/reload
code in drivers.


>
>For that to work and to avoid ordering issues with netdev we need to
>allow unregistering a devlink instance before all references are gone.

References of what? devlink instance, put by devlink_put()?


>
>So we atomically look up and take a reference on a devlink instance.
>Then take its lock. Then under the instance lock we check if it's still
>registered.

As mentioned above (**), I don't think this is needed.


>
>For devlink core that's not a problem it's all hidden in the helpers.
