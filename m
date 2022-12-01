Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B2663EB46
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiLAIjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiLAIjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:39:32 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A1386A1E
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 00:39:28 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x2so1437839edd.2
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 00:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R2A7UboQ3FATux5TsIgS3DlWXxgC24MIPv5TH2ZNaaA=;
        b=N6FGuKrQgP5lLoo2FPmdynuFlJ2I+r5VMdGRr0Co9MTm/hXuKAffGV8yjkqptn1e4z
         bdxfXqKHIyzNsgkXytqGooiySqsMhl1o2iwPdSpERiTet/AkSJ6jW29X1grV9ABgH6Lm
         ays+VamyQOg7iLd5houvM9+QMAP5yYmt7NLR/A23prMbEGiPCxmMIObTWlvAKr3BrXxU
         KR/GNz9zvovY0CrT1pwDUCtCOfNVssRw+WpKk4YIH0JcmQcCc4Q5Aj9h45/F8YScnvCP
         LOwJhS+P0ZTINKD9BweDzpEVv5IOFqfPT9/MfCu/MStCQEx4qNh5jrFD/nwIvw4WaHR1
         Zq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R2A7UboQ3FATux5TsIgS3DlWXxgC24MIPv5TH2ZNaaA=;
        b=a4wCAJy1w8t4wI4g/5+PqB8M6oUC/0AjdvJpUZF5YykuF31Uxs+v6sZxds0OSNRl1M
         3vJ0vcsyiQaJHkyCLi5a/CPg8iXcDwpOFP99tY1ly8QuWcGx+4KXw46d5q8qjGLZX2Uc
         McHPWtXivp2dHKwP4qyxe/vlWqK/kp3AFvtWj6MzwFJon0CZXK4ugy3iGV7hmDBUSbco
         fOMXxLxZiGJAV87BqLeaoh7aIprXCoZ6cTcq0aaoe49zsCT6a2wLpX5y4GydoDmDF8Gq
         zkwTB7Sk2mG2SGagI2nuDAmMMtUqXPoYBHvEkN7Vo2fkGTvRJByMqa6Fq07dm229yoqG
         6TRg==
X-Gm-Message-State: ANoB5pk7pY5Xkjo0YSTSxMUv6hjYAgdoSmN3J5Pc1sya5gDrWJlMBU7i
        dYTaZFyotBz/V9vXA/+nSbzeuQ==
X-Google-Smtp-Source: AA0mqf6Qatw1fsOHK/HNdURo5iPQdvnwd44UMS25M/cROTyNr0KE7LkKTpNqJsGy/+FDGdsQjOYW5A==
X-Received: by 2002:a05:6402:1156:b0:467:374e:5f9b with SMTP id g22-20020a056402115600b00467374e5f9bmr41863610edw.283.1669883967293;
        Thu, 01 Dec 2022 00:39:27 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id cz15-20020a0564021caf00b004589da5e5cesm1457035edb.41.2022.12.01.00.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 00:39:26 -0800 (PST)
Date:   Thu, 1 Dec 2022 09:39:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4hoPcbHoaOBuj2D@nanopsycho>
References: <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
 <Y4dBrx3GTl2TLIrJ@nanopsycho>
 <20221130084659.618a8d60@kernel.org>
 <Y4eMFUBWKuLLavGB@nanopsycho>
 <20221130092042.0c223a8c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221130092042.0c223a8c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 30, 2022 at 06:20:42PM CET, kuba@kernel.org wrote:
>On Wed, 30 Nov 2022 18:00:05 +0100 Jiri Pirko wrote:
>> Wed, Nov 30, 2022 at 05:46:59PM CET, kuba@kernel.org wrote:
>> >On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote:  
>> >> **)
>> >> I see. With the change I suggest, meaning doing
>> >> devlink_port_register/unregister() and netdev_register/unregister only
>> >> for registered devlink instance, you don't need this at all. When you
>> >> hit this compat callback, the netdevice is there and therefore devlink
>> >> instance is registered for sure.  
>> >
>> >If you move devlink registration up it has to be under the instance
>> >lock, otherwise we're back to reload problems. That implies unregister
>> >should be under the lock too. But then we can't wait for refs in
>> >unregister. Perhaps I don't understand the suggestion.  
>> 
>> I unlock for register and for the rest of the init I lock again.
>
>The moment you register that instance callbacks can start coming.
>Leon move the register call last for a good reason - all drivers
>we looked at had bugs in handling init.
>
>We can come up with fixes in the drivers, flags, devlink_set_features()
>and all that sort of garbage until the day we die but let's not.
>The driver facing API should be simple - hold the lock around entire
>init.
>
>> >> What is "half-initialized"? Take devlink reload flow for instance. There
>> >> are multiple things removed/readded, like devlink_port and related
>> >> netdevice. No problem there.  
>> >
>> >Yes, but reload is under the instance lock, so nothing can mess with 
>> >a device in a transitional state.  
>> 
>> Sure, that is what I want to do too. To be under instance lock.
>
>I'm confused, you just said "I unlock for register".

Ah, right. I got your point now, you don't want the user to see
half-init devlink objects. In reload, the secondhalf-uninit&seconfhalf-init
happens atomically under instance lock, so the user sees the whole picture
still.

But is it a problem? For ports, I don't think so. For the other objects
being removed-readded during reload, why do you think it is a problem?


>
>> >> As mentioned above (**), I don't think this is needed.  
>> >
>> >But it is, please just let me do it and make the bugs stop 😭  
>> 
>> Why exactly is it needed? I don't see it, pardon my ignorance :)
>> 
>> Let me send the RFC of the change tomorrow, you'll see what I mean.
>
>The way I see it Leon had a stab at it, you did too, now it's my turn..

Up to you.
