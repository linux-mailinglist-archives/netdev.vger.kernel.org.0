Return-Path: <netdev+bounces-2527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E58097025A3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6DD21C20A53
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7B979ED;
	Mon, 15 May 2023 07:04:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF137468
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:04:19 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B20CE6C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:04:15 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-644d9bf05b7so6920341b3a.3
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684134254; x=1686726254;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uCD3xCkYfNGpqdz6rqz02ewnV2gLCfaLBzIL2dOb0BA=;
        b=D1mpfMLp7iU8M3v125lHslePhrwXN2Nt+06xjigCCbJbL7mP0D+PJFTTNI1FYgUUnK
         QfR/RWKA7uYUn+C43m2jOF6GoSJl0ykfcND/3ZN091cctME9K2XC/JNzB1753dN4T9Ey
         OQ/E70uGGf4o0/+3IMxEk2A90Bb3asP4DRWoDhHoQj3S9WoYOC+cGjUZbhhDQGov+y67
         +BReDFE2p3uqO+uou1s35DoJB5zjfdW/4L25mlP/NIClKgpvH5i0+UsCJVL2I3e28O/d
         BWTzFROMVrCyDaOEKspvZN13aEQIjFp8KPDBy49bn9aBw4mGXN2RiRazZgKIomioxJs5
         0rAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684134254; x=1686726254;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCD3xCkYfNGpqdz6rqz02ewnV2gLCfaLBzIL2dOb0BA=;
        b=GAwFpzOCWHWQYerBLQwLomJ/hEXtl/+QvP4SQtCJTovQ0xdiAmqc8BWVNhO1ov0gG/
         tSuFDpY6xzVq3jbGktAtAGIhZdtNTX/5vgO8EYK71MApacdxVFPnchMBg7dvfGjjlT5M
         42ml4Mv5Lt0H+nsxzXJU68Zy5w4z6PT/Z+rvUkAUv2aog9OxAaxjl0Gvp9RKlWoJdFWd
         tBIQmS+3xjr/N6yobMCvy6ddclWGs6UJPGeLQCNdtMFUg/wWF04PcRB4ymWNs9jKqJXH
         HhOm89Z9jmDxgT2NbANw+G0HK6gcm+DoefuElpPHT7jbvWOWtgrlxkeVG70DAI0ym3+B
         BKpQ==
X-Gm-Message-State: AC+VfDzzjhLLHDw+K+vn3ZQXsxqSZdTreHuPRg3G/reVN3MHkUvTpypO
	5nb1oxdLprTz9NjxFhtFLkzqkQ==
X-Google-Smtp-Source: ACHHUZ7xQVY62gBHyh5WbfOru28n/sfK3aVYm1uQn10+hMHGXiNsfOtkuRIeJBKrPkF4xBG0ETof1A==
X-Received: by 2002:a05:6a00:158b:b0:64a:f730:1552 with SMTP id u11-20020a056a00158b00b0064af7301552mr11703642pfk.19.1684134254696;
        Mon, 15 May 2023 00:04:14 -0700 (PDT)
Received: from [10.255.9.129] ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id c13-20020aa78e0d000000b00646ebc77b1fsm2099965pfr.75.2023.05.15.00.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 00:04:14 -0700 (PDT)
Message-ID: <6b355d57-30b4-748d-87f4-d79a50fe5487@bytedance.com>
Date: Mon, 15 May 2023 15:04:09 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH] sock: Fix misuse of sk_under_memory_pressure()
From: Abel Wu <wuyun.abel@bytedance.com>
To: Paolo Abeni <pabeni@redhat.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230506085903.96133-1-wuyun.abel@bytedance.com>
 <588689343dcd6c904e7fc142a001043015e5b14e.camel@redhat.com>
 <d2abfe0c-0152-860c-60f7-2787973c95d0@bytedance.com>
Content-Language: en-US
In-Reply-To: <d2abfe0c-0152-860c-60f7-2787973c95d0@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Gentle ping :)

On 5/10/23 10:35 PM, Abel Wu wrote:
> Hi Paolo, thanks very much for comment!
> 
> On 5/9/23 3:52 PM, Paolo Abeni wrote:
>> On Sat, 2023-05-06 at 16:59 +0800, Abel Wu wrote:
>>> The commit 180d8cd942ce ("foundations of per-cgroup memory pressure
>>> controlling") wrapped proto::memory_pressure status into an accessor
>>> named sk_under_memory_pressure(), and in the next commit e1aab161e013
>>> ("socket: initial cgroup code") added the consideration of net-memcg
>>> pressure into this accessor.
>>>
>>> But with the former patch applied, not all of the call sites of
>>> sk_under_memory_pressure() are interested in net-memcg's pressure.
>>> The __sk_mem_{raise,reduce}_allocated() only focus on proto/netns
>>> pressure rather than net-memcg's.
>>
>> Why do you state the above? The current behavior is established since
>> ~12y, arguably we can state quite the opposite.
>>
>> I think this patch should at least target net-next, and I think we need
>> a more detailed reasoning to introduce such behavior change.
> 
> Sorry for failed to provide a reasonable explanation... When @allocated
> is no more than tcp_mem[0], the global tcp_mem pressure is gone even if
> the socket's memcg is under pressure.
> 
> This reveals that prot::memory_pressure only considers the global tcp
> memory pressure, and is irrelevant to the memcg's. IOW if we're updating
> prot::memory_pressure or making desicions upon prot::memory_pressure,
> the memcg stat should not be considered and sk_under_memory_pressure()
> should not be called since it considers both.
> 
>>
>>> IOW this accessor are generally
>>> used for deciding whether should reclaim or not.
>>>
>>> Fixes: e1aab161e013 ("socket: initial cgroup code")
>>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>>> ---
>>>   include/net/sock.h |  5 -----
>>>   net/core/sock.c    | 17 +++++++++--------
>>>   2 files changed, 9 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index 8b7ed7167243..752d51030c5a 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -1404,11 +1404,6 @@ static inline int 
>>> sk_under_cgroup_hierarchy(struct sock *sk,
>>>   #endif
>>>   }
>>> -static inline bool sk_has_memory_pressure(const struct sock *sk)
>>> -{
>>> -    return sk->sk_prot->memory_pressure != NULL;
>>> -}
>>> -
>>>   static inline bool sk_under_memory_pressure(const struct sock *sk)
>>>   {
>>>       if (!sk->sk_prot->memory_pressure)
>>> diff --git a/net/core/sock.c b/net/core/sock.c
>>> index 5440e67bcfe3..8d215f821ea6 100644
>>> --- a/net/core/sock.c
>>> +++ b/net/core/sock.c
>>> @@ -3017,13 +3017,14 @@ int __sk_mem_raise_allocated(struct sock *sk, 
>>> int size, int amt, int kind)
>>>           }
>>>       }
>>> -    if (sk_has_memory_pressure(sk)) {
>>> -        u64 alloc;
>>> -
>>> -        if (!sk_under_memory_pressure(sk))
>>> -            return 1;
>>> -        alloc = sk_sockets_allocated_read_positive(sk);
>>> -        if (sk_prot_mem_limits(sk, 2) > alloc *
>>> +    if (prot->memory_pressure) {
>>> +        /*
>>> +         * If under global pressure, allow the sockets that are below
>>> +         * average memory usage to raise, trying to be fair between all
>>> +         * the sockets under global constrains.
>>> +         */
>>> +        if (!*prot->memory_pressure ||
>>> +            sk_prot_mem_limits(sk, 2) > 
>>> sk_sockets_allocated_read_positive(sk) *
>>
>> The above introduces unrelated changes that makes the code IMHO less
>> readable - I don't see a good reason to drop the 'alloc' variable.
> Besides drop the @alloc variable, this change also removes the condition
> of memcg's pressure from sk_under_memory_pressure() due to the reason
> aforementioned. I can re-introduce @alloc in the next version if you
> think it makes code more readable.
> 
> Thanks & Best,
>      Abel
> 

