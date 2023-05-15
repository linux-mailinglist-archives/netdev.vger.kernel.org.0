Return-Path: <netdev+bounces-2600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA027702A61
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF9A01C20959
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC933C2E3;
	Mon, 15 May 2023 10:20:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2EAC148
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:20:30 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC222107
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:20:28 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1adc913094aso43262375ad.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684146028; x=1686738028;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bVcYbGMTcnCH725Fn9H40mWDeMdYeKHUtwfwgBEqrVs=;
        b=NUFknoKLINs0CRaF8sgFYTioxUzqdoPQbpm6deM6LbunJlP6nK3LRvmgH31/KF7rOm
         plxnTbhvqKVathcad8a++qW04F3Xsdw/7TrqRCTRFR4/1bCCaUmczeG5A5ybQN12bnjq
         ZkKTwXjnWyfiIOyqcS58NIpwUgTOXuLqLOw9Vt2fsBZ6rTRWVozrl8MYzm3WfIPnMBY3
         Sc/KJ9aMkDeAFbKBP4T8L9b+29I66i0KSBuStbd9khsYdwPFDCyl41lgVQHAEfQauy5e
         Wm1AgkvrE4u0RyHvz8xTJQNg/oePvQ4uH09Qb5lQBahRQK7COrrAzWienBrTxgHXyXLN
         UEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684146028; x=1686738028;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVcYbGMTcnCH725Fn9H40mWDeMdYeKHUtwfwgBEqrVs=;
        b=fW+dBkHUe0UpOVyPFNVFY94qQA66ucjbwh+U3KR4STHevyp8qQ3HhTvVjl5t8QFZR+
         Ymy+B7oZhffhvkWUN/xiBKj1QcHhpE4PrJF5mr+nIq64BBZGolQjYywDWgp0glQQ4PJA
         XW4dNuAJc+1m2icZ2pBO4RM6JL8G+wShHOOPefSk7f1BsOMA8UZJT1kEbTkOmEU1h+M1
         gVj60YCgyriGRf1Eb9uo2pnMrdT2kfZUz0qXdZCe2Ru1uXqg6m90XnkSL0tt7lqaJE8D
         HNNS/B6TvDsYC2OqTbnlPjti+bOmrcVlWwxf0WscEFAlWXyTXG48uBpBVvgJ9pSfk5vM
         qZVA==
X-Gm-Message-State: AC+VfDyZ1RIcYvTp7Ai2yt3IVNVFgZkhLHc3e9hc1NOf1phsvSWsdQ+Z
	bhRaMcLoeQM/DVpkiUepNG5uUtvb0tycCQIjjbM=
X-Google-Smtp-Source: ACHHUZ7PCi0pvjly4wa61Bfp0Xu2bwaIKoeBHG0s3217u8aUKvU4Vp5IaMtZFb+a2T7MLiVWFaOZmw==
X-Received: by 2002:a17:902:cec9:b0:19a:a9d8:e47f with SMTP id d9-20020a170902cec900b0019aa9d8e47fmr47490935plg.36.1684146027973;
        Mon, 15 May 2023 03:20:27 -0700 (PDT)
Received: from [10.255.9.129] ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902db0c00b001adbb8991b3sm9383747plx.89.2023.05.15.03.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 03:20:27 -0700 (PDT)
Message-ID: <bfbfc15f-3d16-f127-0642-d5f78147a58d@bytedance.com>
Date: Mon, 15 May 2023 18:20:21 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: Re: [PATCH] sock: Fix misuse of sk_under_memory_pressure()
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230506085903.96133-1-wuyun.abel@bytedance.com>
 <588689343dcd6c904e7fc142a001043015e5b14e.camel@redhat.com>
 <d2abfe0c-0152-860c-60f7-2787973c95d0@bytedance.com>
 <6b355d57-30b4-748d-87f4-d79a50fe5487@bytedance.com>
 <CANn89iJqzE6r9dm2hoHxgYeLQvStZYvRhCxFVmpV_LczaO-4xw@mail.gmail.com>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <CANn89iJqzE6r9dm2hoHxgYeLQvStZYvRhCxFVmpV_LczaO-4xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/23 3:21 PM, Eric Dumazet wrote:>
> I still do not understand the patch.
> 
> If I do not understand the patch and its changelog now in May 2023,
> how will anyone understand it later
> when/if a regression is investigated ?
> 
> I repeat :
> 
> Changelog is evasive, I do not see what practical problem you want to solve.
> 
> 
> sk_has_memory_pressure() is not about memcg, simply the fact that a
> proto has a non NULL memory_pressure pointer.

Yes, it has nothing to do with sk_has_memory_pressure(), this accessor
is removed only due to it is not used anymore after this fix. I really
should have put this into a separate patch.

> 
> I suggest that you answer these questions, and send a V2 with an
> updated changelog.

OK, I will.

> 
> Again, what is the practical problem you want to solve ?
> What is the behavior of the current stack that you think is a problem ?

The status of global tcp_mem pressure is updated when:

   a) __sk_mem_raise_allocated():

	enter: sk_memory_allocated(sk) >  tcp_mem[1]
	leave: sk_memory_allocated(sk) <= tcp_mem[0]

   b) __sk_mem_reduce_allocated():

	leave: sk_under_memory_pressure(sk) &&
		sk_memory_allocated(sk) < tcp_mem[0]

So the conditions of leaving global pressure are inconstant, which may
lead to the situation that one pressured memcg prevents the global
pressure from being cleared when there is indeed no global pressure,
thus the global constrains are still in effect unexpectedly on the other
sockets. The patch fixes this by removing the condition of net-memcg's
pressure in __sk_mem_reduce_allocated().

As for the changes in __sk_mem_raise_allocated(), I don't think it is
the right place to check the pressure of the @sk's memcg. That piece of
code was originally only trying to be fair between all the sockets if
there is global pressure. And if we really want to forbid the socket
memory from being raised when the socket's memcg is in pressure, the
condition should be in the first place inside this function.

So I plan to split this patch into three in v2:

   [1/3] fix inconstant condition in __sk_mem_reduce_allocated()
   [2/3] remove unrelated check in __sk_mem_raise_allocated()
   [3/3] remove sk_has_memory_pressure() since it is no longer used

Does this make sense to you?

Thanks & Best,
	Abel

