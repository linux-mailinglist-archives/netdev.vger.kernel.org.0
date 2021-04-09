Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8285359CD4
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhDILN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbhDILN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:13:58 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675ACC061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 04:13:45 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id c123so544804qke.1
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 04:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=olaUNSDjleTTJkOpGVJDouLkY8OF0cSWN8vMXi5A+Cc=;
        b=FBHWHBiHXpPLVmPUI68K+qPfBnCJSsMimfqToObqKnSr4K1NfnODGzYvRwQBzlorgW
         mtH2sd0MGHJCXme43wBrvyMqpJCQpyHXPsop2KCt3BBdJOn0Nj0qN0Ll41oCjrxHyXKW
         PWmjj7iumob9sJ1m1ZZzsFrxxJbVaW5nKlwmDtAXSQgv/99z1vLZER72h8Set5XKDGsv
         T+zorZyHfBvkEo95CcW7G3A/0VcRS3JDBLQ2sreneyGckxfcwzJcyPlRKc4p25yRx+WL
         Neh7hOjU8qOtFGN7atuRvYk/xzZ37f31HSay4OTMv9hMe812OA2YCZgW81EiJpWIx6qy
         jqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=olaUNSDjleTTJkOpGVJDouLkY8OF0cSWN8vMXi5A+Cc=;
        b=ukU3Qu8qXuiBq4+AQMsG+1PicimH1iikdrC/feoV6rkoEzruSPKFWHKc1GWiycW4FD
         Fo6xB+B32uqdzS2Rx0CsC+tF9c3mWQnVACAKH6R/BoY/eEwYyhtKQAe4C4J2wBE875mW
         6CUeMWGJcaZPo4sjLC70UIK4wz7Ebn/tjVoSC3j44Jej9zkUrFQPz/RX987llHuV+bb1
         F3C5v5W+7y07NP0O4k4djH73BZiKEsd2xD4OB7X2OwsTw2ivz6Du38uhGbE2MANeP3Ug
         +T1X6azSCPCA7Ti7uFMmPXqMp5nxl8K+KZx/FqDduN4I2DPL4iKXNaRD9ACrsxr3CPe3
         OlMA==
X-Gm-Message-State: AOAM530TQZpo3UHm6xXX7TLkfWHoxUtgakmlK4OgeUImZdF3OkdOtGtk
        LZATvw10VQVcHhQtGochN15Ryg==
X-Google-Smtp-Source: ABdhPJyJPaG5wgalweR3ST/Xmu1rg4dp0K8XvvngsQXavkYY/RIFkkFfh4EwCEGy39MU1CD0RCjdNw==
X-Received: by 2002:a05:620a:24c9:: with SMTP id m9mr4140626qkn.103.1617966824344;
        Fri, 09 Apr 2021 04:13:44 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-22-184-144-36-31.dsl.bell.ca. [184.144.36.31])
        by smtp.googlemail.com with ESMTPSA id z8sm1560102qtn.12.2021.04.09.04.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 04:13:43 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
 <20210408133829.2135103-2-petrm@nvidia.com>
 <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
 <20210408142545.1a6424e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <e04c2d9c-119f-621b-6ce9-6f6f449b6f86@mojatatu.com>
Date:   Fri, 9 Apr 2021 07:13:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408142545.1a6424e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-08 5:25 p.m., Jakub Kicinski wrote:
> On Thu, 8 Apr 2021 10:05:07 -0400 Jamal Hadi Salim wrote:
>> On 2021-04-08 9:38 a.m., Petr Machata wrote:
>>> The TC action "trap" is used to instruct the HW datapath to drop the
>>> matched packet and transfer it for processing in the SW pipeline. If
>>> instead it is desirable to forward the packet and transferring a _copy_ to
>>> the SW pipeline, there is no practical way to achieve that.
>>>
>>> To that end add a new generic action, trap_fwd. In the software pipeline,
>>> it is equivalent to an OK. When offloading, it should forward the packet to
>>> the host, but unlike trap it should not drop the packet.
>>
>> I am concerned about adding new opcodes which only make sense if you
>> offload (or make sense only if you are running in s/w).
>>
>> Those opcodes are intended to be generic abstractions so the dispatcher
>> can decide what to do next. Adding things that are specific only
>> to scenarios of hardware offload removes that opaqueness.
>> I must have missed the discussion on ACT_TRAP because it is the
>> same issue there i.e shouldnt be an opcode. For details see:
>> https://people.netfilter.org/pablo/netdev0.1/papers/Linux-Traffic-Control-Classifier-Action-Subsystem-Architecture.pdf
>>
>> IMO:
>> It seems to me there are two actions here encapsulated in one.
>> The first is to "trap" and the second is to "drop".
>> This is no different semantically than say "mirror and drop"
>> offload being enunciated by "skip_sw".
>>
>> Does the spectrum not support multiple actions?
>> e.g with a policy like:
>>    match blah action trap action drop skip_sw
> 
> To make sure I understand - are you saying that trap should become
> more general and support both "and then drop" as well as "and then
> pass" semantics?
> 

No.
Main issue is the pollution of the opcodes - whether it is
one or multiple actions is less of a concern.
Those opcodes are intended to be for the core action dispatcher's
consumption. See figure 6 and table 1 of the document i referred to.

Basically:
You dont an action then add an opcode for it even if it is hardware
offloaded (otherwise that opcode space would have grown a lot more by
now for all those actions that are offloaded).
Trap, for example, could have been a dummy action that just returns
the STOLEN/DROP/PASS opcode and does nothing else.
Typically we expect things that are offloaded to have a software
equivalent. It makes for good control consistency etc clean.

> Seems like that ship has sailed, but also - how does it make it any
> better WRT not having HW only opcodes? Or are you saying one is better
> than two?

The opcodes are not tied to whether an action is offloaded or not.
That role belongs to the "skip_sw" axes - which works well
today since we dont offload actions on their own without some
filter rule which specifies the offload option.

I will barf if someone implements 3 actions: "trap", "trap and forward",
"trap and drop" - but that is not messing up with the core architecture
so the barfing is more due to the bad taste of that approach.
A cleaner approach is to code one and change the return code for those
3 to "STOLEN", "PIPE", and "DROP"

cheers,
jamal
