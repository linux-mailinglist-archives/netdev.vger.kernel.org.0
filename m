Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE0130F64A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhBDP32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbhBDP3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:29:11 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E78BC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 07:28:29 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id w20so2654515qta.0
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 07:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VMr78ssSbYthxr3r370oVaePUYVHlYiwHTcIa+JWR0I=;
        b=dsFkk0ra9twof6PApcDS+xxxoszFjYTr65iR6r+no31yn+GkpWuh6P8CFBVlnTRcvj
         42pbpqHBIFFnwGg/87lreVP7K/Gpn8SHyT1DDX+yOBKizKRhwEeHL8Gcn2q6p5R30KiD
         cDk2+gnD5/3DN30y4EaHWr9A21m4+sGgyqLYqT9YJM8+OCeI/6ajZmB7jMLXgmfs86Ll
         B6/MgDn+op34tQstzXVKA7M3ET9FOJ9+cX3aSrv06Gk+UrQLzh/Bwwh9lPrM/J0+Cy3t
         vj88UW9z0xfoKR6AkFdAAZjHnGnBAVR3xUz1tdJ6eZOdFzs3qoN1db+jcbZRuGfLvulL
         hzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VMr78ssSbYthxr3r370oVaePUYVHlYiwHTcIa+JWR0I=;
        b=BVRkbnG9Hx2C6mmcxZKHD03Qz6z7jRD9z/NL0JIxUgusQojlHcagWM+SnGw8MS2RmB
         q8I05BrwknStAXTMvP19WsrGFuLcb7+bNi6MNZ+sGc9NU8Opmfbybk8+vwoGcsPxi18o
         AsIz+VzmPEmu5bMEFVlwI6c9unUeL6IyGjmrD5Y/RPc/ELZ+d4uvFu2bkc1KRZM7CUHv
         EtxyG1s/GyPLmrc4/hRnOqSS1UFjGnBk7m7593LIS6yLSqGqSdODrkb0hmeUcaNEQE95
         CFYPmmD0BKhI0eUnvjISJanPaL7gVKx0igMj5UIXzzJ5His9qvZB1kJB3QfwBzFCP8Ze
         Rq1A==
X-Gm-Message-State: AOAM532ezHj3LJFRsnDXp0UWU6G9edCqZboRXz8eF3f5K3YRqJFBDSZp
        MqeW1zt2rfM8yZqg61jA/9LGADWhj7JiGQ==
X-Google-Smtp-Source: ABdhPJy6Oa17i86Omz94170x3Q/9H+fgkGiNlquAAZmwYWzKMmZLAL721XgdaI9h865GFFN0DgTljQ==
X-Received: by 2002:aed:212d:: with SMTP id 42mr88402qtc.106.1612452508385;
        Thu, 04 Feb 2021 07:28:28 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 12sm5460546qkg.39.2021.02.04.07.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 07:28:27 -0800 (PST)
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
 <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
 <20210204140450.GS3158@orbyte.nwl.cc>
 <0cab775c-cd3c-f3a0-7680-570cc92eb96e@mojatatu.com>
 <20210204145006.GT3158@orbyte.nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7d5e31b1-0348-e617-0d3e-5acee7796361@mojatatu.com>
Date:   Thu, 4 Feb 2021 10:28:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210204145006.GT3158@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-04 9:50 a.m., Phil Sutter wrote:
> On Thu, Feb 04, 2021 at 09:34:01AM -0500, Jamal Hadi Salim wrote:
>> On 2021-02-04 9:04 a.m., Phil Sutter wrote:
>>> Jamal,
>>>
>>> On Thu, Feb 04, 2021 at 08:19:55AM -0500, Jamal Hadi Salim wrote:
>>>> I couldnt tell by inspection if what used to work before continues to.
>>>> In particular the kernel version does consider the divisor when folding.
>>>
>>> That's correct. And so does tc. What's the matter?
>>>
>>
>> tc assumes 256 when undefined. Maybe man page needs to be
>> updated to state we need divisor specified otherwise default
>> is 256.
> 
> tc-u32.8 mentions the default in 'sample' option description. Specifying
> divisor is mandatory when creating a hash table, so that path is
> covered, too. I still don't get how this is related to my patch, though.
> 

It is a general comment related to this code (that you are modifying).
You mentioned divisor in your earlier email as part of the syntax for
sample. So it made me wonder:
Does the bucket placement assume a specific number of buckets in a
table? Example if i had a hash table with 4 buckets, would the sample
then pick the correct bucket? Would it be also correct for 32 buckets,
etc. Or it didnt matter before and it doesnt matter now.

>>>> Two examples that currently work, if you can try them:
>>>
>>> Both lack information about the used hashkey and divisor.
>>>
>>>> Most used scheme:
>>>> ---
>>>> tc filter add dev $DEV parent 999:0  protocol ip prio 10 u32 \
>>>> ht 2:: \
>>>> sample ip protocol 1 0xff match ip src 1.2.3.4/32 flowid 1:10 \
>>>> action ok
>>>> ----
>>>
>>> htid before: 0x201000
>>> htid after: 0x201000
>>>
>>
>> Ok, this is the most common use-case. So we are good.
> 
> Whatever.

Meaning?


cheers,
jamal
