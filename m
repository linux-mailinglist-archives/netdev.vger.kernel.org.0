Return-Path: <netdev+bounces-7942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 849877222BE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1E741C20B71
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78BFD156C6;
	Mon,  5 Jun 2023 09:57:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B625680
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:57:20 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972A6D3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:57:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b0201d9a9eso33281825ad.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 02:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685959038; x=1688551038;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TyuCPt1vQNlaWH7tCffqZV2k/RtNlXHoU62GbJy8Xjk=;
        b=KKGiHDA+xwC+Nm4KS7WEjinOuCG1iVjs4z+FmI8SpBouzvSfV4RqeQidTBGyVkA19I
         Oh0TRdzdP3GJkcP6FekYo8ImlboVTxzu/vCtrxiT+dkG2TBAvOliU6hwgC3b5yQCwkZV
         ue8mOe5XCOP2vcouiSDq+wVpvmWTG/JDCIfoUa4Pyh87YXdvAXY7EDkQVKzI/nyoPaWV
         gWrnFcvLgMQqHdqUnwpFVXl7QK+x1EbdnB8dsjpgLIjIozZlTX8BW9drTjYqqlP7v9oY
         Igs9eoVOUVnNsUfVZM7CU8zm4TwVsb3znjj/lBNSD/l+EYn15Btp40XCSuplRIWpCx/E
         4jxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685959038; x=1688551038;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TyuCPt1vQNlaWH7tCffqZV2k/RtNlXHoU62GbJy8Xjk=;
        b=l4Ct63EfMqyYlROzM77mM3nWSAag5lfVhU1IkimYHE2VfeEmC91z3nOhlaraYTK2Ds
         jG3k+EZX4PYqOR2yK9mZaXRKIxSAkmtyZ2tLlYgl0uLTfsYkPPh3rXtSKjKxf0Ug7UEE
         xqo8Wnns+SFkyw2QKMJPafZn1TJV6vBrofLS3mD0mwpTL2QxMFjV3QJ8bCWfhXvZVBe8
         Hqbp4erG+mAPAgAZ4TSGhQqFAXjmZMOMzmDB54+UF0y93StzAmPukG9+bWg3WvbmcwGb
         lTs5F/sNnQ9yda6v+0VXQGCrH1aO7X5mkUejfNd5KQhmXApqGVZpi+0OYDVRHiydqTj9
         WFww==
X-Gm-Message-State: AC+VfDwofY7zLz41Hq+8O5QEryZ8123TYKLCsmqbetXBZY0w3S1nWABz
	dGoM3cxB+YHunDmE1xc2GZ+0zg==
X-Google-Smtp-Source: ACHHUZ7UU+7VhOoZ+LaCsaa8oefNZLkAgK8CdKo9gcU9SGPUfv5AJPuReZuksUmH0QYq0D1i0CWW5Q==
X-Received: by 2002:a17:903:2305:b0:1b0:4c6c:716 with SMTP id d5-20020a170903230500b001b04c6c0716mr9054747plh.4.1685959038094;
        Mon, 05 Jun 2023 02:57:18 -0700 (PDT)
Received: from [10.254.80.225] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id x21-20020a17090300d500b001ae469ca0c0sm6152081plc.245.2023.06.05.02.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 02:57:17 -0700 (PDT)
Message-ID: <806149cf-cc07-ad5a-267e-94a6bc3b4106@bytedance.com>
Date: Mon, 5 Jun 2023 17:57:09 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: Re: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure
 into consideration
Content-Language: en-US
To: Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Shakeel Butt <shakeelb@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>,
 Muchun Song <muchun.song@linux.dev>, Simon Horman
 <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
 <20230602081135.75424-3-wuyun.abel@bytedance.com>
 <20230602204159.vo7fmuvh3y2pdfi5@google.com>
 <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
 <6f67c3ca-5e73-d7ac-f32a-42a21d3ea576@bytedance.com>
 <727b1fb64d04deb8b2a9ae1fec4b51dafa1ff2b5.camel@redhat.com>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <727b1fb64d04deb8b2a9ae1fec4b51dafa1ff2b5.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/5/23 4:27 PM, Paolo Abeni wrote:
> On Mon, 2023-06-05 at 11:44 +0800, Abel Wu wrote:
>> On 6/4/23 6:36 PM, Willem de Bruijn wrote:
>>> On Fri, Jun 2, 2023 at 10:42 PM Shakeel Butt <shakeelb@google.com> wrote:
>>>>
>>>> On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
>>>>> The sk_under_memory_pressure() is called to check whether there is
>>>>> memory pressure related to this socket. But now it ignores the net-
>>>>> memcg's pressure if the proto of the socket doesn't care about the
>>>>> global pressure, which may put burden on its memcg compaction or
>>>>> reclaim path (also remember that socket memory is un-reclaimable).
>>>>>
>>>>> So always check the memcg's vm status to alleviate memstalls when
>>>>> it's in pressure.
>>>>>
>>>>
>>>> This is interesting. UDP is the only protocol which supports memory
>>>> accounting (i.e. udp_memory_allocated) but it does not define
>>>> memory_pressure. In addition, it does have sysctl_udp_mem. So
>>>> effectively UDP supports a hard limit and ignores memcg pressure at the
>>>> moment. This patch will change its behavior to consider memcg pressure
>>>> as well. I don't have any objection but let's get opinion of UDP
>>>> maintainer.
> 
> Thanks for the head-up, I did not notice the side effect on UDP.
> 
>>
>>> So this commit only affects the only other protocol-independent
>>> caller, __sk_mem_reduce_allocated, to possibly call
>>> sk_leave_memory_pressure if now under the global limit.
>>>
>>> What is the expected behavioral change in practice of this commit?
>>
>> Be more conservative on sockmem alloc if under memcg pressure, to
>> avoid worse memstall/latency.
> 
> I guess the above is for TCP sockets only, right? Or at least not for
> UDP sockets?

Yes, I started off with TCP but wondering if it is applicable to the
others too as the 'problem' sounds really generic to me.

> 
> If so, I think we should avoid change of behaviour for UDP - e.g.
> keeping the initial 'if (!sk->sk_prot->memory_pressure)' in
> sk_under_memory_pressure(), with some comments about the rationale for
> future memory. That should preserve the whole patchset effect for other
> protocols, right?

Keeping the if statement as it is would imply the prot pressure as a
master 'switch' to all kinds of pressure. IMHO this might hurt other
protocols with pressure enabled if they are all used in one memcg which
happens to be under vmpressure, IOW UDP allocations are given higher
priority than others.

> 
> If instead you are also interested into UDP sockets under pressure, how
> that is going to work? UDP sockets can reclaim memory only at send and
> close time. A memcg under pressure could starve some sockets forever if
> the the ones keeping the memory busy are left untouched.

Yes.. And it starts to get me confused that why&when should the memcg
pressure be used given that we don't want to put harsh constrains on
sockmem even under memcg pressure.

Thanks!
	Abel

