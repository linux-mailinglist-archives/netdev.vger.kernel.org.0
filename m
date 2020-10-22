Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5625C2960A2
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900626AbgJVOFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900622AbgJVOFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:05:35 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD52BC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:05:34 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id j62so1099416qtd.0
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SCpLIKwtEPaRyQId8j7Sm16PJLGB/jhHvvxs3ULL/vE=;
        b=W0YFflFWpY4gU0YPX2S8LpOaSI6mdVpqg1y1bJNPrH2NTjmBQoPik/1CQjLmtLTHBN
         Oiywk9ruEFa6bRwVIEYTQQjXn/bkGsRwzEbC66HToCYJZskdTdGEMTjnSogT6m4PTQ9F
         mkypsZaqNPfEptQOc06uxbwouSxV7ypWGvEx7EhWXFTILyyp92kLcZY33k2wkz7C86kG
         +36wX4lbtYEja/519yPAJedCOk82NZ2l1Y0z5Kdr5DYN07TxJ2dB3rXrYIYFurTzCZLB
         HjzmeXN5DtpQpgIE2m9xR+zWgOVaTEX7m+mizst6FempI3CZpXnleTJBeQvJK/zKEvYI
         uotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SCpLIKwtEPaRyQId8j7Sm16PJLGB/jhHvvxs3ULL/vE=;
        b=tQzZV5nFLg3eQGnHtP33Tc4Om2SFrfb8GxFFrKMQMXNFErN1PBSfOLTcqTlTLMgmtk
         IjeJqQVS50Z4GHwcIW1mxmNBVCNip5JIT4xvXLL/cyHem1vHOzl386IZuILGF3WooyVd
         +w3HZGLZEcGRSmGvd42ntgKoSeCQAK275RfmwW1QSU+jLbm51NWSWZH2yaXtkMiVq77Y
         JUorECGRPMxtKEkDREorlff9gYHYpS/LKbaVVk8rWmc8eFKhmJSt/d34wYf2f6ba0Epp
         xUHewVXfgk1Hx5iUUibym9inkPwZADfVWmr09MJFnut04Nt6gzLcg2D5QwD4Nf8wmLc9
         B5Hw==
X-Gm-Message-State: AOAM533LBie5R/5qwDYFrqf5so7/kG/8fGZAlvhQWvwCr7w2aB03+6O4
        A/xxBDlOkRrXON521Em0hwHZsg==
X-Google-Smtp-Source: ABdhPJybKGCC3FrgUMQTcn9y7xLmpTl5UwWAMWViO5bKnsvGLeZXvKs4PzpY9kKRGXZwhKMMfXtSiA==
X-Received: by 2002:aed:3f16:: with SMTP id p22mr2168000qtf.181.1603375533169;
        Thu, 22 Oct 2020 07:05:33 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id g188sm1030219qkf.3.2020.10.22.07.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 07:05:31 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
 <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
 <87362a1byb.fsf@buslov.dev>
 <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
 <ygnh8sc03s9u.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
Date:   Thu, 22 Oct 2020 10:05:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ygnh8sc03s9u.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-21 4:19 a.m., Vlad Buslov wrote:
> 
> On Tue 20 Oct 2020 at 15:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2020-10-19 11:18 a.m., Vlad Buslov wrote:
>> My worry is you have a very specific use case for your hardware or
>> maybe it is ovs - where counters are uniquely tied to filters and
>> there is no sharing. And possibly maybe only one counter can be tied
>> to a filter (was not sure if you could handle more than one action
>> in the terse from looking at the code).
> 
> OVS uses cookie to uniquely identify the flow and it does support
> multiple actions per flow.


ok, so they use it like a flowid/classid to identify the flow.
In our use case the cookie stores all kinds of other state that
the controller can avoid to lookup after a query.
index otoh is universal i.e two different users can intepret it
per action tying it specific stats.
IOW: I dont think it replaces the index.
Do they set cookies on all actions in a flow?


>> Our assumptions so far had no such constraints.
>> Maybe a new TERSE_OPTIONS TLV, and then add an extra flag
>> to indicate interest in the tlv? Peharps store the stats in it as well.
> 
> Maybe, but wouldn't that require making it a new dump mode? Current
> terse dump is already in released kernel and this seems like a
> backward-incompatible change.
> 

I meant you would set a new flag(in addition to TERSE) in a request to
the kernel to ask for the index to be made available on the response.
Response comes back in a TLV with just index in it for now.

>>
>>> This wouldn't be much of a terse dump anymore. What prevents user that
>>> needs all action info from calling regular dump? It is not like terse
>>> dump substitutes it or somehow makes it harder to use.
>>
>> Both scaling and correctness are important. You have the cookie
>> in the terse dump, thats a lot of data.
> 
> Cookie only consumes space in resulting netlink packet if used set the
> cookie during action init. Otherwise, the cookie attribute is omitted.

True, but: I am wondering why it is even considered in when terseness
was a requirement (and index was left out).

>> In our case we totally bypass filters to reduce the amount of data
>> crossing to user space (tc action ls). Theres still a lot of data
>> crossing which we could trim with a terse dump. All we are interested
>> in are stats. Another alternative is perhaps to introduce the index for
>> the direct dump.
> 
> What is the direct dump?

tc action ls ...
Like i said in our use cases to get the stats we just dumped the actions
we wanted. It is a lot less data than having the filter + actions.
And with your idea of terseness we can trim down further how much
data by removing all the action attributes coming back if we set TERSE
flag in such a request. But the index has to be there to make sense.

cheers,
jamal


