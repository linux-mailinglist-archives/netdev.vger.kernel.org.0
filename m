Return-Path: <netdev+bounces-12103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A547361F1
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 05:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E3AC1C20A2A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 03:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD0215A8;
	Tue, 20 Jun 2023 03:04:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104BFED5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:04:39 +0000 (UTC)
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF18E4A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:04:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-25eb9e82a2bso2003460a91.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687230276; x=1689822276;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FWAkX0wvK40L8Asrfp0HwD5G44IXPeP/M4M7zLIxf3U=;
        b=djRrFrDbBleVZdWXxrOVE2nAKGvwYAf4SY5iAtcImwDM+I6r6WJcylT6f6OEkUtoBV
         xgbl/pjdRjjbtHc5UotGCivqqLtUAFWTziJfP4qHWqCtF3SY3KH3HJwKpd1WN5JBEG90
         ng3L0GsmDo5iSLEF2nMA4rY9ABP63GvoZFfSCMxckB4194G8VI6P5u4dtP98jj7qLMf2
         YzUEmrXwxvwxdwbyzx+rsdyhmdambZrPMuzPZQ5DkaaChocbcjRoKD3NAYMiSqvWhTXT
         kwwa5Jhcfy1oQ+S8CId5jxKKVoOfz97qM3yf/h8BF4LWcxiXsSjjfx16mVBROj/iokmL
         33iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687230276; x=1689822276;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FWAkX0wvK40L8Asrfp0HwD5G44IXPeP/M4M7zLIxf3U=;
        b=eAipBfOJxl6HT60c4kwmz3PMcUb15Pf2LXFQeagsV6GOAZyeouuxfgJGKqIU3wAKq5
         4Vqrg9M/qRFKjbhQri/baETJnkjHAIBFOoE9ShIYwve1eOwbMQQA4JK8/Dz/pZ7aoH9Y
         +kd6QfDEn+KW0IbPMXWA28cytftvITLERFg3WvIny5Ajn4MHWLUuoll5X+v1ATf7vzK5
         Fb2qbgOV11nJz1JU4AAFYGhhIVaCoeB1x+Ia3hHMKGw1WXAwGvYf/kTLmqSQtPvM2Gvr
         Qu10ZCULGNKcCm1XeilooibQemBHVlKjNnHfIZAKKA46v/djIaOH5W4QoqE781M4FHyM
         KFaQ==
X-Gm-Message-State: AC+VfDzsHo9IEChGl4ZWw7EvCf9yfBFqFQdabwTC9K9NihI1FDpymdtl
	AHYZkb5YZfltVDCDtxc2mqrnt1APXAv10zcffCs=
X-Google-Smtp-Source: ACHHUZ4w85QKY83xVfS+cRb6Qqre68nSV3CdsUk24aZ87xP4al2moPQV5NWIu5nneOTpdg6qNbI8Mg==
X-Received: by 2002:a17:90a:19cb:b0:25e:e211:d300 with SMTP id 11-20020a17090a19cb00b0025ee211d300mr5873247pjj.4.1687230276680;
        Mon, 19 Jun 2023 20:04:36 -0700 (PDT)
Received: from [10.94.58.170] ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id iz7-20020a170902ef8700b001b0603829a0sm457578plb.199.2023.06.19.20.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 20:04:35 -0700 (PDT)
Message-ID: <6ed78c81-c1ac-dba4-059c-12f6b2bb9c53@bytedance.com>
Date: Tue, 20 Jun 2023 11:04:30 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: Re: [PATCH net-next] inet: Save one atomic op if no memcg to
 charge
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern
 <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 "open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20230619082547.73929-1-wuyun.abel@bytedance.com>
 <CANn89i+deprQWB0dmsUD1sRmy1VQCQwKnZUkLu_AEGV=ow=PKQ@mail.gmail.com>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <CANn89i+deprQWB0dmsUD1sRmy1VQCQwKnZUkLu_AEGV=ow=PKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/19/23 6:08 PM, Eric Dumazet wrote:
> On Mon, Jun 19, 2023 at 10:26 AM Abel Wu <wuyun.abel@bytedance.com> wrote:
>>
>> If there is no net-memcg associated with the sock, don't bother
>> calculating its memory usage for charge.
>>
>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>> ---
>>   net/ipv4/inet_connection_sock.c | 18 +++++++++++-------
>>   1 file changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
>> index 65ad4251f6fd..73798282c1ef 100644
>> --- a/net/ipv4/inet_connection_sock.c
>> +++ b/net/ipv4/inet_connection_sock.c
>> @@ -706,20 +706,24 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>>   out:
>>          release_sock(sk);
>>          if (newsk && mem_cgroup_sockets_enabled) {
>> -               int amt;
>> +               int amt = 0;
>>
>>                  /* atomically get the memory usage, set and charge the
>>                   * newsk->sk_memcg.
>>                   */
>>                  lock_sock(newsk);
>>
>> -               /* The socket has not been accepted yet, no need to look at
>> -                * newsk->sk_wmem_queued.
>> -                */
>> -               amt = sk_mem_pages(newsk->sk_forward_alloc +
>> -                                  atomic_read(&newsk->sk_rmem_alloc));
>>                  mem_cgroup_sk_alloc(newsk);
>> -               if (newsk->sk_memcg && amt)
>> +               if (newsk->sk_memcg) {
>> +                       /* The socket has not been accepted yet, no need
>> +                        * to look at newsk->sk_wmem_queued.
>> +                        */
>> +                       amt = sk_mem_pages(newsk->sk_forward_alloc +
>> +                                          atomic_read(&newsk->sk_rmem_alloc));
>> +
>> +               }
>> +
>> +               if (amt)
>>                          mem_cgroup_charge_skmem(newsk->sk_memcg, amt,
>>                                                  GFP_KERNEL | __GFP_NOFAIL);
> 
> This looks correct, but claiming reading an atomic_t is an 'atomic op'
> is a bit exaggerated.

Yeah, shall I change subject to 'inet: Skip usage calculation if no
memcg to charge'? Or do you have any suggestions?

Thanks,
	Abel

