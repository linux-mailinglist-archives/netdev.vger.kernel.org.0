Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0864CAD62
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbiCBSVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243014AbiCBSVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:21:33 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F25335244
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 10:20:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s1so2264165plg.12
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 10:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nTZbe4RuErueR3NlMysDToKJ1PjS4LUzZYWPRH1r4jo=;
        b=XhQ3TdR8U2YPnlD1reEh+xSsKJdZ07164txZBu3hx6Rd6MGIsvwJiF1XTrU1rI9lkn
         pYCXIouj9n1bSMUglFOyvAdjpnTbTufY+9h8ywGlnEO603hMjRUFF3wRQG98wIp6m351
         oA02mr8McOsz5X/c+mq0Igr6E2EqGCh+8dN6q1Tzdw9oT/6Y0jrAnSXQM6rxZ4hP3DUU
         nIotTthm1+p+tbCAvtki1Er8s4NOJPamW/9VhGBLM6sy1n64IT05sL+9XEOhXOUvI1E0
         Y8ObdUFrNVmrEfq8okZ+bjBv7jW/gMjF0B7NpGkI68neSw8bfi4qWNXivSqorW8DspdU
         F1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nTZbe4RuErueR3NlMysDToKJ1PjS4LUzZYWPRH1r4jo=;
        b=D7pQcnWlu3D6V1oou24lOnJZW2wsQiWHcPlsoK3n2j73ISqduvW9V4i1DFaXhmjbnP
         P9i96DfRLITBc96l17qq83o+t2n+lfh5FHsbrKweMRemGsCt79foYx5aQjHLoGVSs5lf
         89t8qjp+W8uzgvxQIYoC6lhJF93agYc6UUry8yDit/pBbp0rwf7FFdvT5U0HeFnsyDdv
         FagQfO8xSu2wlQ3AjTgKDMNeM9F0HxySML/mvsyHyRaRLmVvmlTNY1QiAzPri9lTkE2i
         I8Nyt74saCQpocGh7jq9nbKDAfL/k5q/0gvCy4jC6uh5pFsC3v1QUyM5jUBRFRdt+5uo
         p56A==
X-Gm-Message-State: AOAM533yg8DwfDjJ4LweAgWJQE6okN2WGd76PjxJdwHuElrRnHPV0Q2Z
        t6S4Dssi7ZmN4AThDqHpMuk=
X-Google-Smtp-Source: ABdhPJzPqd+ELn499rhAgevc3/VtuEm0G6wET4lWAVI8X0RcLCQTPQyNnf+sQ954v+ihSPGXau05bQ==
X-Received: by 2002:a17:90b:1d10:b0:1bf:9de:c86f with SMTP id on16-20020a17090b1d1000b001bf09dec86fmr503129pjb.173.1646245248733;
        Wed, 02 Mar 2022 10:20:48 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s17-20020a056a0008d100b004cce703d042sm21752191pfu.32.2022.03.02.10.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 10:20:47 -0800 (PST)
Message-ID: <513731ee-17fb-ee6b-9354-5dc3890bd7f5@gmail.com>
Date:   Wed, 2 Mar 2022 10:20:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
 <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
 <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
 <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
 <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220302100246.393f1af7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220302100246.393f1af7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/2022 10:02 AM, Jakub Kicinski wrote:
> On Wed, 23 Feb 2022 14:48:18 -0800 Jakub Kicinski wrote:
>>> Understood and I won't require you or me to complete this investigating
>>> before fixing the regression, this is just so we understand where it
>>> stemmed from and possibly fix the IRQ layer if need be. Given what I
>>> just wrote, do you think you can sprinkle debug prints throughout the
>>> kernel to figure out whether enable_irq_wake() somehow messes up the
>>> interrupt descriptor of interrupt and test that theory? We can do that
>>> offline if you want.
>>
>> Let me mark v2 as Deferred for now, then. I'm not really sure if that's
>> what's intended but we have 3 weeks or so until 5.17 is cut so we can
>> afford a few days of investigating.
> 
> I think the "few days of investigating" have now run out :(
> How should we proceed?

I have not had a chance to provide Peter with the debug patch I wanted 
him to apply, but your patch seemed better in that regard because if we 
don't have a Wake-on-LAN interrupt line, we should not mark the device 
as wake-up capable to begin with. Peter, could you try Jakub's patch and 
confirm that it works equally well as yours?

https://lore.kernel.org/netdev/20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
-- 
Florian
