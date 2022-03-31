Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74ED4EE1BB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbiCaTdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 15:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiCaTdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 15:33:11 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88126329B8
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 12:31:23 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y10so471237edv.7
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 12:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=vkygapT2jAgP/nSR9dcYt29mIbPdfc05KbTSchZW1fQ=;
        b=M4J2WrzdtVevpAj3dZqjiNNMaZr7SsrjxYlB30nP72FxVd1yZdUu92bH1/7ps+UqSh
         QpIhaozZAqRpvQR08QRqZQxgizYDffiafN19OHtv2Bj829bGliB96RGqA5SPujFlW02C
         fzRfeSk4733yuKre3NnAexBsDZVoAcR9wLC2KQ5kp7X1P8TqoJaAic8yB0qPLpRuzHze
         XYiUWunn4p/tUkqG+ZWN15cpJbAJzp+dHE4/A8A7oGwPUW+mXi83/7x0+AYJLS7rKmR3
         JxX9qLtb4wJFUnpLzedM3KGZVZFlw9UILrjGeUqsJvNcZj5mQYzj0DwpPRqE6utKC+km
         jEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=vkygapT2jAgP/nSR9dcYt29mIbPdfc05KbTSchZW1fQ=;
        b=WIDZq/TdTQCFXOs0YkAzhGbw/3rugNBXOB9fF2CguoRvftZwL6jeNTcgozmntxSy21
         aQBcUC7j4rl8E85rmNktIZsk0ZR4p4mU7zF+VZ4SctL4o7ipA40LCeinG8Lxh+N6htEB
         1f6Vj1CXlp6R3okJDHlV6gN9eC+WDLgNZ2JfrHf5yYrp2Vutz45i0u/kK6ip2iI7S5NP
         FvDjbeW1f/GyTct3J2DBTfDlha9X4dYkvZaNIDkqU83+F+f2yDTX/SfhnOVQo4h3zcTm
         wxHbSDQpl0+uOioHdBjNOgS2/b30yfPJzDuatC3/eNhZlnsqcYW4KOe74DGKPKPloSjR
         sjCA==
X-Gm-Message-State: AOAM532vNieuOCl97q+M0aNWzKbqYhT+th9B7PgYPuYpPODgfmGcQzZJ
        BkT9gWEhP3P9AGcc5onsc8Ne1g==
X-Google-Smtp-Source: ABdhPJwXEDXMlDt0TGhDBm/jjBX0Om3Q+kwBIeccblliLn7EAgpmxR6pIHsGxGv2tYjd+2RNs0MLvQ==
X-Received: by 2002:a50:e696:0:b0:413:3846:20a9 with SMTP id z22-20020a50e696000000b00413384620a9mr18055342edm.96.1648755081854;
        Thu, 31 Mar 2022 12:31:21 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id q2-20020a170906144200b006ceb8723de9sm124011ejc.120.2022.03.31.12.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 12:31:21 -0700 (PDT)
Message-ID: <d2291d26-8875-22af-b256-35e7bf3054dc@blackwall.org>
Date:   Thu, 31 Mar 2022 22:31:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net 1/2] net: ipv4: fix route with nexthop object delete
 warning
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     donaldsharp72@gmail.com, philippe.guibert@outlook.com,
        kuba@kernel.org, davem@davemloft.net, idosch@idosch.org
References: <20220331154615.108214-1-razor@blackwall.org>
 <20220331154615.108214-2-razor@blackwall.org>
 <46d8d642-4c25-20e9-0805-4e4727a232b1@kernel.org>
 <CF021BA4-036B-40FC-ADBB-F7C66D57348A@blackwall.org>
 <7AF573C9-E80A-497F-B820-EA6B95676E2D@blackwall.org>
In-Reply-To: <7AF573C9-E80A-497F-B820-EA6B95676E2D@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2022 20:34, Nikolay Aleksandrov wrote:
> On 31 March 2022 20:17:14 EEST, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 31 March 2022 20:05:43 EEST, David Ahern <dsahern@kernel.org> wrote:
>>> On 3/31/22 9:46 AM, Nikolay Aleksandrov wrote:
>>>> FRR folks have hit a kernel warning[1] while deleting routes[2] which is
>>>> caused by trying to delete a route pointing to a nexthop id without
>>>> specifying nhid but matching on an interface. That is, a route is found
>>>> but we hit a warning while matching it. The warning is from
>>>> fib_info_nh() in include/net/nexthop.h because we run it on a fib_info
>>>> with nexthop object. The call chain is:
>>>>  inet_rtm_delroute -> fib_table_delete -> fib_nh_match (called with a
>>>> nexthop fib_info and also with fc_oif set thus calling fib_info_nh on
>>>> the fib_info and triggering the warning). The fix is to not do any
>>>> matching in that branch if the fi has a nexthop object because those are
>>>> managed separately.
>>>>
[snip]
>>>> [2] https://github.com/FRRouting/frr/issues/6412
>>>>
>>>> Fixes: 4c7e8084fd46 ("ipv4: Plumb support for nexthop object in a fib_info")
>>>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>>>> ---
>>>>  net/ipv4/fib_semantics.c | 7 ++++++-
>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>>>> index cc8e84ef2ae4..ccb62038f6a4 100644
>>>> --- a/net/ipv4/fib_semantics.c
>>>> +++ b/net/ipv4/fib_semantics.c
>>>> @@ -889,8 +889,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
>>>>  	}
>>>>  
>>>>  	if (cfg->fc_oif || cfg->fc_gw_family) {
>>>> -		struct fib_nh *nh = fib_info_nh(fi, 0);
>>>> +		struct fib_nh *nh;
>>>> +
>>>> +		/* cannot match on nexthop object attributes */
>>>> +		if (fi->nh)
>>>> +			return 1;
>>>>  
>>>> +		nh = fib_info_nh(fi, 0);
>>>>  		if (cfg->fc_encap) {
>>>>  			if (fib_encap_match(net, cfg->fc_encap_type,
>>>>  					    cfg->fc_encap, nh, cfg, extack))
>>>
>>> I think the right fix is something like this:
>>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>>> index cc8e84ef2ae4..c70775f5e155 100644
>>> --- a/net/ipv4/fib_semantics.c
>>> +++ b/net/ipv4/fib_semantics.c
>>> @@ -886,6 +886,8 @@ int fib_nh_match(struct net *net, struct fib_config
>>> *cfg, struct fib_info *fi,
>>>                if (fi->nh && cfg->fc_nh_id == fi->nh->id)
>>>                        return 0;
>>>                return 1;
>>> +       } else if (fi->nh) {
>>> +               return 1;
>>>        }
>>>
>>> ie., if the cfg has a nexthop id it needs to match fib_info.
>>> if the cfg does not have a nexthop id, but fib_info does then it is not
>>> a match
>>
>>
>> Right, that is also correct and I was tempted to cut it all short in that case
>> but seemed riskier so I went with the more narrow fix for that specific case.
>> Anyway, I'll respin with that change.
>>
>> Cheers,
>> Nik
>>
> 
> Actually I just remembered another reason - ip route del default
> should work regardless of specifying nhid or not. I can't test right now,
> but I suspect that may break if the nh match code is invoked with that change.
> 
> I'll verify it once I'm back in front of a pc.
> 

I just tested it and yes - the change breaks the standard ip route del <addr> case.
I.e.:
$ ip r add 1.2.3.4/32 nhid 12
$ ip r del 1.2.3.4/32
RTNETLINK answers: No such process

Even though:
$ ip r show 1.2.3.4/32
1.2.3.4 nhid 12 via 192.168.11.2 dev dummy0 

Before that change it worked, so I think we should proceed with my fix instead.
The command must not match if there's any nexthop specification after the route
as it doesn't right now, and it must match if there isn't any nh spec.

Cheers,
 Nik
