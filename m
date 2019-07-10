Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641D964B2F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfGJRFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:05:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46442 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfGJRFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:05:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id i8so1521712pgm.13
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 10:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=IOlW9k8T+hVdZ67L3PoEHzl1wq41ih3NFhm2ew0sito=;
        b=eikFnIe/0OKgesXZTMrCFc8bEWW4CV1Pf/8D50CS5pNN2ntryvKcWg/hgYbQJPNTE7
         FSX3sz1PNWXHBcKtBJcCUkHhCkjjMH6bDQ2SDjqcUnMwAtx+FhlKZIB2lv9Ho97lZe8a
         lr8GsaOMlENmqb/oh3qJiqgG603OL6DFW6hvE1TNgdG1E3nTFj9pwPQ67tD1sNjYdumK
         fP02ZQmToRTUXbBKWv06I45feo243FU1I/3i/+A+eRzxTj+k7rtWti0olks6gM3rY9QV
         oiIIxNj+sxNTblEx0TO0jYebjPcnPEPcItM2EZDALaVIFdbpo3ZjpvzEzNjQa+GBtZ57
         /qSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IOlW9k8T+hVdZ67L3PoEHzl1wq41ih3NFhm2ew0sito=;
        b=J7e5uVDb73lGi/xS3bkGPgYe3YXrScwu6oJ16Kqq4jhrvjTsJhT535Q2Q3TrR8c6Td
         VsbkGnF+UhSAK+JT0gtI9sx1Z413FzLmMWEn2vNqUNE8AX+abHbmPSTZ8twX5w7FdkZz
         Gqnqd0c0R85hk56zHu8x7Y3uCmN63298wU2YZWPFXKCtDq95Uax1KpvQK4rMTMnxSB7o
         PVWc/JVUeMgp/aqtzo2G2TWq7ADcSUI0e7KxueMMaJJLhBJSRtWH4oTV2N0Kj8IlRrqs
         kZXwzV2RfnvNWVFRS3UdnS9UiVriCVlm/m8VqpP9kdV3d4SHevXLViRfLvy43YBJUjlN
         Hz/Q==
X-Gm-Message-State: APjAAAVxWe2RBDpNwV0PKtXOQx1xeLiCO8xkRspuyhtbTrBskPtZVS0I
        kkuMqt+Kl1HOVMMi6UQB673/Dvdsb/A=
X-Google-Smtp-Source: APXvYqxfxfInta/TUbHygKv5bI3IRzqpYsAIXdvYsxjR0eDhf09+TKHxaNDd/fepMmQ9iGbQ+JLVvg==
X-Received: by 2002:a63:f346:: with SMTP id t6mr39479386pgj.203.1562778309023;
        Wed, 10 Jul 2019 10:05:09 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b37sm9446622pjc.15.2019.07.10.10.05.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 10:05:08 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
 <20190708193454.GF2282@nanopsycho.orion>
 <af206309-514d-9619-1455-efc93af8431e@pensando.io>
 <20190708200350.GG2282@nanopsycho.orion>
 <6f9ebbca-4f13-b046-477c-678489e6ffbf@pensando.io>
 <20190709065620.GJ2282@nanopsycho.orion>
 <0ae90b8d-5c73-e60d-8e56-5f6f56331e1a@pensando.io>
 <20190710064819.GC2282@nanopsycho>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <dddb1a17-991a-30b6-a1ad-b7c5bc05348a@pensando.io>
Date:   Wed, 10 Jul 2019 10:06:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190710064819.GC2282@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/19 11:48 PM, Jiri Pirko wrote:
> Tue, Jul 09, 2019 at 09:13:53PM CEST, snelson@pensando.io wrote:
>> On 7/8/19 11:56 PM, Jiri Pirko wrote:
>>> Tue, Jul 09, 2019 at 12:58:00AM CEST, snelson@pensando.io wrote:
>>>> On 7/8/19 1:03 PM, Jiri Pirko wrote:
>>>>> Mon, Jul 08, 2019 at 09:58:09PM CEST, snelson@pensando.io wrote:

>>>>>> If I'm not mistaken, the alloc is only allocating enough for a pointer, not
>>>>>> the whole per device struct, and a few lines down from here the pointer to
>>>>>> the new devlink struct is assigned to ionic->dl.  This was based on what I
>>>>>> found in the qed driver's qed_devlink_register(), and it all seems to work.
>>>>> I'm not saying your code won't work. What I say is that you should have
>>>>> a struct for device that would be allocated by devlink_alloc()
>>>> Is there a particular reason why?  I appreciate that devlink_alloc() can give
>>>> you this device specific space, just as alloc_etherdev_mq() can, but is there
>>> Yes. Devlink manipulates with the whole device. However,
>>> alloc_etherdev_mq() allocates only net_device. These are 2 different
>>> things. devlink port relates 1:1 to net_device. However, devlink
>>> instance can have multiple ports. What I say is do it correctly.
>> So what you are saying is that anyone who wants to add even the smallest
>> devlink feature to their driver needs to rework their basic device memory
>> setup to do it the devlink way.  I can see where some folks may have a
>> problem with this.
> It's just about having a structure to hold device data. You don't have
> to rework anything, just add this small one.

Well, there's a bit of logic rework to and a little data twiddling - not 
too bad in our case.  Others may not be thrilled depending on how 
they've already implemented their drivers.

>>>>> The ionic struct should be associated with devlink_port. That you are
>>>>> missing too.
>>>> We don't support any of devlink_port features at this point, just the simple
>>>> device information.
>>> No problem, you can still register devlink_port. You don't have to do
>>> much in order to do so.
>> Is there any write-up to help guide developers new to devlink in using the
>> interface correctly?  I haven't found much yet, but perhaps I've missed
>> something.  The manpages are somewhat useful in showing what the user might
>> do, but they really don't help much in guiding the developer through these
>> details.
> That is not job of a manpage. See the rest of the code to get inspired.
>

Sure, we should all be able to poke through the code and figure out the 
basics - "use the Force, read the source" - but as software engineers we 
should be including some bits of documentation to help those new to the 
feature to steer away from pitfalls and use the feature correctly.  
We're all busy with our own projects and only have limited time to dig 
into and understand someone else's code; if there's not a guide, we'll 
do what we can to get it working and then move on, with no guarantee 
that we followed the original intent.

There's a Documentation page on the devlink-health feature, and a brief 
bit on devlink-params, but I haven't seen anything yet that spells out 
the "proper" way to use the devlink framework.  Of course, the 
open-source spirit is for me to scratch my own itch and take care of the 
need myself: I'd be happy to get a brief doc started, but if the 
original developers can take a few minutes to at least sketch some notes 
down about important bits like "the device struct should be associated 
with devlink_port" and why it should, then we have a chance at saving a 
lot of other people's time, and perhaps we can fill out the details 
correctly and not miss something important.

sln


