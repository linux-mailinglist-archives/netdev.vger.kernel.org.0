Return-Path: <netdev+bounces-7850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBB9721CA1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 187592810CD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9A217EA;
	Mon,  5 Jun 2023 03:45:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA79137D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:45:07 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8B3B7
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 20:45:06 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b0201d9a9eso31323455ad.0
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 20:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685936706; x=1688528706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4SSVnlC4IwShHocep9s7ywh2nFdFJx4NP0mnzsxLtQ=;
        b=As6EY1mjueMRZ7v0/kgCl2t91e15oNTmUA0m6RVlAOyhhApKue6wdKlKzvvava5Fcd
         7bZlp0aFbor4T+wPcVB7EOsdXcZqEey4q983dLSdBzROsSVwnxGW1k2POoACXCndxFV5
         jSTTeEVl43/bU4MYq8IlqIKpo6Z/kEFBPKMZWkj58lzSahNq5GkSQ/+j0IUvnyYmZVQ1
         QcWOn71C3ALjIheNI740qF//drYAQpKWahvI3cPkZtsYHoE0W3WNF3tU2OWgzT71NEYM
         knrOlEANyLAfubq+jUVTXFE11Cn7dEIw1kVc1JqQgJmORJYkQDRbzHG0pf5bFi2O+h+2
         CUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685936706; x=1688528706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4SSVnlC4IwShHocep9s7ywh2nFdFJx4NP0mnzsxLtQ=;
        b=LKEiMzwDMdz+GMAaq1L/cGqaQdwXasAuixFHl16tHL1aZ96UPvLogM1at39zF90ZL8
         cBlxY9+ksqRFc7vLYqUWc/Qam+9QKNKAySWxsvnIgxMbGlLcnI4nI0ISagUTpxfHuBQi
         iwVTJub2GFUJXYS2XFgFYLoR7XzY0BwiuXumxe9rPwSAo+sBh2aNBFNw60Xy+Iqv4eia
         iqqKciDW2r40aZ5154RczJXi7/FPV5lBv40Uo0ruHg2BXlO4+boo8Gcr9Y0SUjJUIhot
         CKgqEpDLO0FHvfvLREzj8gNuB10M9OqoNop6dKQLRhOEnklWIzomHK96h1egJUKe32MW
         +nUQ==
X-Gm-Message-State: AC+VfDzcbRumvByb3Q8XOqwjXUBAF3PfM/OxeqNSt8I2C3FzLzu3pTT6
	E0vCMIX6JnS7wxRrnrwSnEQTkQ==
X-Google-Smtp-Source: ACHHUZ4BO/9Z64c1dfqNlXO6bfWV+qB2TMgQnTpAnH1ehEOf3mlCBA7r9y4+HPsB7FnzNnLUZIyQ0w==
X-Received: by 2002:a17:902:e84d:b0:1b0:3ab6:5140 with SMTP id t13-20020a170902e84d00b001b03ab65140mr7153073plg.4.1685936705787;
        Sun, 04 Jun 2023 20:45:05 -0700 (PDT)
Received: from [10.254.80.225] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id a12-20020a170902eccc00b00186a2274382sm5384273plh.76.2023.06.04.20.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 20:45:05 -0700 (PDT)
Message-ID: <6f67c3ca-5e73-d7ac-f32a-42a21d3ea576@bytedance.com>
Date: Mon, 5 Jun 2023 11:44:55 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure into
 consideration
Content-Language: en-US
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Shakeel Butt <shakeelb@google.com>, Paolo Abeni <pabeni@redhat.com>
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
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/4/23 6:36 PM, Willem de Bruijn wrote:
> On Fri, Jun 2, 2023 at 10:42 PM Shakeel Butt <shakeelb@google.com> wrote:
>>
>> On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
>>> The sk_under_memory_pressure() is called to check whether there is
>>> memory pressure related to this socket. But now it ignores the net-
>>> memcg's pressure if the proto of the socket doesn't care about the
>>> global pressure, which may put burden on its memcg compaction or
>>> reclaim path (also remember that socket memory is un-reclaimable).
>>>
>>> So always check the memcg's vm status to alleviate memstalls when
>>> it's in pressure.
>>>
>>
>> This is interesting. UDP is the only protocol which supports memory
>> accounting (i.e. udp_memory_allocated) but it does not define
>> memory_pressure. In addition, it does have sysctl_udp_mem. So
>> effectively UDP supports a hard limit and ignores memcg pressure at the
>> moment. This patch will change its behavior to consider memcg pressure
>> as well. I don't have any objection but let's get opinion of UDP
>> maintainer.
> 
> Others have more experience with memory pressure on UDP, for the
> record. Paolo worked on UDP memory pressure in
> https://lore.kernel.org/netdev/cover.1579281705.git.pabeni@redhat.com/
> 
> It does seem odd to me to modify sk_under_memory_pressure only. See
> for instance its use in __sk_mem_raise_allocated:
> 
>          if (sk_has_memory_pressure(sk)) {
>                  u64 alloc;
> 
>                  if (!sk_under_memory_pressure(sk))
>                          return 1;
> 
> This is not even reached as sk_has_memory_pressure is false for UDP.

I intended to make __sk_mem_raise_allocated() be aware of net-memcg
pressure instead of just this bit [1][2].

[1] 
https://lore.kernel.org/lkml/20230523094652.49411-5-wuyun.abel@bytedance.com/
[2] 
https://lore.kernel.org/lkml/20230523094652.49411-6-wuyun.abel@bytedance.com/

And TBH I am wondering why considering memcg's pressure here, as the
main part in this if statement is to allow the sockets that are below
average memory usage to raise from a *global* memory view, which seems
nothing to do with memcg.

> So this commit only affects the only other protocol-independent
> caller, __sk_mem_reduce_allocated, to possibly call
> sk_leave_memory_pressure if now under the global limit.
> 
> What is the expected behavioral change in practice of this commit?

Be more conservative on sockmem alloc if under memcg pressure, to
avoid worse memstall/latency.

> 
> 
>>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>>> ---
>>>   include/net/sock.h | 6 ++----
>>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index 3f63253ee092..ad1895ffbc4a 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
>>>
>>>   static inline bool sk_under_memory_pressure(const struct sock *sk)
>>>   {
>>> -     if (!sk->sk_prot->memory_pressure)
>>> -             return false;
>>> -
>>>        if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
>>>                return true;
>>>
>>> -     return !!*sk->sk_prot->memory_pressure;
>>> +     return sk->sk_prot->memory_pressure &&
>>> +             *sk->sk_prot->memory_pressure;
>>>   }
>>>
>>>   static inline long
>>> --
>>> 2.37.3
>>>

