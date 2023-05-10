Return-Path: <netdev+bounces-1501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 690496FE06F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 231B328155D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E8114AA1;
	Wed, 10 May 2023 14:35:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7564F12B6F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:35:52 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BFBA26C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:35:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1aae5c2423dso71059845ad.3
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683729331; x=1686321331;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bTpSjY8dX/y2zw0+NUgDM2A5G47HoQ8GogR43hjUa+4=;
        b=U1BL7pDWdm6dMgdRlYEOsn3jJ6itpMbTnfKk4p5qEwlDqp8kiNataTmNTlWgZet2CV
         KnuZQwYCPuozY32mLmNHfejB4ko8pgMHHq07odHo4IJFsV61QzZpkXIkWgrxcG4IPG33
         rdI474FkDKXtC+ssqTsqUJFniv1/Q60bZBpHhziKMMJaGuOXdHJTvSVwaBtkvBlnCEma
         rSf6pyMDO3u0CZM5fJ8jp4xc0F9MficrxIMpX5aq1XFLba4UDC4FcTW/HBxxNJYv/w4D
         CSIh9bjxJ0Q3Ya8QdvaHbgBN0ZATdo32Zrsw50ttJ6+sne6tR0iVXKN6oZLvIZuTfMzB
         kwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729331; x=1686321331;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTpSjY8dX/y2zw0+NUgDM2A5G47HoQ8GogR43hjUa+4=;
        b=jwzVh8Id1QP2Cu/gT3pyigvjqOm4mf4ir9afom8z3y36cYipNlBNmYU4xLzqHcWyT8
         IyNOYFzG0fVKpieNyT2CkmBFYQBByNbjO6WzwOCGHSyUT5HpcvO5lw8ywKfLreb58+uf
         LnI6mxVXE09YXeTnLfoPOcFJe/1utYbOKaLrwvlVBDVC1wzHkPy5E+yXO/VsKZaFRJYq
         Pk+VnT1WYhudHmnJ8K0VQgl3H0HY8CJxjKwr9r/A0DWudVH7L+Slkz6yrtubvZNscC6Y
         kGdTngW5/lE1Rv5v5AypWZVKztAO7xzJu4XvxdhqOVRSSMVB/oPoqIkQMT1jUCyV8JBB
         poEA==
X-Gm-Message-State: AC+VfDzmal/D0ecZs/60a5TuhH1IMM6I4i4OKeBGkBAsxa8GA1PrxR/j
	QMbXN5rwHmPHRji2fEjw/QFBDw==
X-Google-Smtp-Source: ACHHUZ6LlHvWjeKdwipRJtpid2l1hYqXh/C154EJzieaxeO/rFUIva+U+OxJyW22thRzh/C4w8vlgg==
X-Received: by 2002:a17:90b:190f:b0:24e:16ae:61ca with SMTP id mp15-20020a17090b190f00b0024e16ae61camr17257306pjb.34.1683729330995;
        Wed, 10 May 2023 07:35:30 -0700 (PDT)
Received: from [10.255.19.214] ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id bx15-20020a17090af48f00b00246f9725ffcsm21611374pjb.33.2023.05.10.07.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 07:35:30 -0700 (PDT)
Message-ID: <d2abfe0c-0152-860c-60f7-2787973c95d0@bytedance.com>
Date: Wed, 10 May 2023 22:35:25 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: Re: [PATCH] sock: Fix misuse of sk_under_memory_pressure()
To: Paolo Abeni <pabeni@redhat.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230506085903.96133-1-wuyun.abel@bytedance.com>
 <588689343dcd6c904e7fc142a001043015e5b14e.camel@redhat.com>
Content-Language: en-US
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <588689343dcd6c904e7fc142a001043015e5b14e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Paolo, thanks very much for comment!

On 5/9/23 3:52 PM, Paolo Abeni wrote:
> On Sat, 2023-05-06 at 16:59 +0800, Abel Wu wrote:
>> The commit 180d8cd942ce ("foundations of per-cgroup memory pressure
>> controlling") wrapped proto::memory_pressure status into an accessor
>> named sk_under_memory_pressure(), and in the next commit e1aab161e013
>> ("socket: initial cgroup code") added the consideration of net-memcg
>> pressure into this accessor.
>>
>> But with the former patch applied, not all of the call sites of
>> sk_under_memory_pressure() are interested in net-memcg's pressure.
>> The __sk_mem_{raise,reduce}_allocated() only focus on proto/netns
>> pressure rather than net-memcg's.
> 
> Why do you state the above? The current behavior is established since
> ~12y, arguably we can state quite the opposite.
> 
> I think this patch should at least target net-next, and I think we need
> a more detailed reasoning to introduce such behavior change.

Sorry for failed to provide a reasonable explanation... When @allocated
is no more than tcp_mem[0], the global tcp_mem pressure is gone even if
the socket's memcg is under pressure.

This reveals that prot::memory_pressure only considers the global tcp
memory pressure, and is irrelevant to the memcg's. IOW if we're updating
prot::memory_pressure or making desicions upon prot::memory_pressure,
the memcg stat should not be considered and sk_under_memory_pressure()
should not be called since it considers both.

> 
>> IOW this accessor are generally
>> used for deciding whether should reclaim or not.
>>
>> Fixes: e1aab161e013 ("socket: initial cgroup code")
>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>> ---
>>   include/net/sock.h |  5 -----
>>   net/core/sock.c    | 17 +++++++++--------
>>   2 files changed, 9 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 8b7ed7167243..752d51030c5a 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -1404,11 +1404,6 @@ static inline int sk_under_cgroup_hierarchy(struct sock *sk,
>>   #endif
>>   }
>>   
>> -static inline bool sk_has_memory_pressure(const struct sock *sk)
>> -{
>> -	return sk->sk_prot->memory_pressure != NULL;
>> -}
>> -
>>   static inline bool sk_under_memory_pressure(const struct sock *sk)
>>   {
>>   	if (!sk->sk_prot->memory_pressure)
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 5440e67bcfe3..8d215f821ea6 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -3017,13 +3017,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>>   		}
>>   	}
>>   
>> -	if (sk_has_memory_pressure(sk)) {
>> -		u64 alloc;
>> -
>> -		if (!sk_under_memory_pressure(sk))
>> -			return 1;
>> -		alloc = sk_sockets_allocated_read_positive(sk);
>> -		if (sk_prot_mem_limits(sk, 2) > alloc *
>> +	if (prot->memory_pressure) {
>> +		/*
>> +		 * If under global pressure, allow the sockets that are below
>> +		 * average memory usage to raise, trying to be fair between all
>> +		 * the sockets under global constrains.
>> +		 */
>> +		if (!*prot->memory_pressure ||
>> +		    sk_prot_mem_limits(sk, 2) > sk_sockets_allocated_read_positive(sk) *
> 
> The above introduces unrelated changes that makes the code IMHO less
> readable - I don't see a good reason to drop the 'alloc' variable.
Besides drop the @alloc variable, this change also removes the condition
of memcg's pressure from sk_under_memory_pressure() due to the reason
aforementioned. I can re-introduce @alloc in the next version if you
think it makes code more readable.

Thanks & Best,
	Abel


