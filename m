Return-Path: <netdev+bounces-12175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E44A7368E9
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B4161C20432
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D1EFC15;
	Tue, 20 Jun 2023 10:13:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587558464
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:13:28 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCD4DB
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:13:26 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b539d2f969so25083565ad.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687256006; x=1689848006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hfUr1e9aEQZRasLBwYauLBgpBkHg6F78JJmqZq7mi1o=;
        b=kGAeI2k3c7yrjwWMuk9zKQSyRj2fyG04oBVEuSGxLYzlpdg1RRLqQ7vgmusYieQWNq
         rXUbQkyU5cdc14ox53xkgIKMau5Mhro6ux/G7dWapSTmk8pZBq89mctgu8eisA/8O9HC
         p40SMFfbn+a8xjDhJKTdGZqslkEP9dtUhf0LDMYYoMLa7YrxSZXtv/eUdwZ953rE+6iC
         tftSJje1HVjU3LUTDS/mcmPRnKsRcq2b0WuDCgPda5ilR5CLwbsqMOFjPXLhWSOR4JCr
         /xwzY0vHRGiYhFLclXS5Bb8OzE674jpHuR24JOYdlWXtkWpO65LmiZmQ9T/6YIk4JSGy
         pcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687256006; x=1689848006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hfUr1e9aEQZRasLBwYauLBgpBkHg6F78JJmqZq7mi1o=;
        b=Enk5ZbNhu3H8s94lxkoj7KQ2tbr2k6t2dG5b2PHA+dXnUhukKjZJHr+zqyVSMxhX5t
         s8kK8tpApk2u2jNdDd2LR0XDPT0nn/BKkXOq3nmpGZNt5CQPZOc+M+/IZsvn4D7dVUza
         kBOyquv4jM7QCXowTha02J3L3RD1XY4GfVtenn+BYLWhUP06r+m8llYkLeQpUO/fFmWb
         4AlSNVxcxPjRgCkC+F2nJrBN6i/v1p4nrAVUm4e1lzhDwh7UBZMuI736DX3cF252pzpc
         MaqfrbCCyGzfiyrNkTkJvZq+De5cuNwOvI7pfWJ00nL9goonQ11aD17m9XEqpHoc8Q4V
         F1bA==
X-Gm-Message-State: AC+VfDwL59VjxAWqMcoHEMTeRA9/KtRa2up+0TIFjv9qQ7evqTNiIYrU
	asF1atVKtUjcABOUbrm/ujCSwA==
X-Google-Smtp-Source: ACHHUZ4WtJhG0PPz3SFJZ/k2bW8clbE97J78XfZQ7GBV0JaALbG0TDAUZwHyCzssBTaOzSYxJlv5pQ==
X-Received: by 2002:a17:902:d2ca:b0:1b0:5ce9:adc7 with SMTP id n10-20020a170902d2ca00b001b05ce9adc7mr23389792plc.28.1687256005848;
        Tue, 20 Jun 2023 03:13:25 -0700 (PDT)
Received: from [10.94.58.170] ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id n21-20020a170902969500b001ab1b7bae5asm1270189plp.184.2023.06.20.03.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 03:13:25 -0700 (PDT)
Message-ID: <23d45f7e-3a34-44b3-f1a0-b992bbb5076f@bytedance.com>
Date: Tue, 20 Jun 2023 18:13:18 +0800
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
 <6ed78c81-c1ac-dba4-059c-12f6b2bb9c53@bytedance.com>
 <CANn89iK4hme4XmUyZVjTXMZYqAm8w+9tbwnrtHyJ3N28cAFYTw@mail.gmail.com>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <CANn89iK4hme4XmUyZVjTXMZYqAm8w+9tbwnrtHyJ3N28cAFYTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/20/23 4:46 PM, Eric Dumazet wrote:
> On Tue, Jun 20, 2023 at 5:04 AM Abel Wu <wuyun.abel@bytedance.com> wrote:
>>
>> On 6/19/23 6:08 PM, Eric Dumazet wrote:
>>> On Mon, Jun 19, 2023 at 10:26 AM Abel Wu <wuyun.abel@bytedance.com> wrote:
>>>>
>>>> If there is no net-memcg associated with the sock, don't bother
>>>> calculating its memory usage for charge.
>>>>
>>>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>>>> ---
>>>>    net/ipv4/inet_connection_sock.c | 18 +++++++++++-------
>>>>    1 file changed, 11 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
>>>> index 65ad4251f6fd..73798282c1ef 100644
>>>> --- a/net/ipv4/inet_connection_sock.c
>>>> +++ b/net/ipv4/inet_connection_sock.c
>>>> @@ -706,20 +706,24 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>>>>    out:
>>>>           release_sock(sk);
>>>>           if (newsk && mem_cgroup_sockets_enabled) {
>>>> -               int amt;
>>>> +               int amt = 0;
>>>>
>>>>                   /* atomically get the memory usage, set and charge the
>>>>                    * newsk->sk_memcg.
>>>>                    */
>>>>                   lock_sock(newsk);
>>>>
>>>> -               /* The socket has not been accepted yet, no need to look at
>>>> -                * newsk->sk_wmem_queued.
>>>> -                */
>>>> -               amt = sk_mem_pages(newsk->sk_forward_alloc +
>>>> -                                  atomic_read(&newsk->sk_rmem_alloc));
>>>>                   mem_cgroup_sk_alloc(newsk);
>>>> -               if (newsk->sk_memcg && amt)
>>>> +               if (newsk->sk_memcg) {
>>>> +                       /* The socket has not been accepted yet, no need
>>>> +                        * to look at newsk->sk_wmem_queued.
>>>> +                        */
>>>> +                       amt = sk_mem_pages(newsk->sk_forward_alloc +
>>>> +                                          atomic_read(&newsk->sk_rmem_alloc));
>>>> +
>>>> +               }
>>>> +
>>>> +               if (amt)
>>>>                           mem_cgroup_charge_skmem(newsk->sk_memcg, amt,
>>>>                                                   GFP_KERNEL | __GFP_NOFAIL);
>>>
>>> This looks correct, but claiming reading an atomic_t is an 'atomic op'
>>> is a bit exaggerated.
>>
>> Yeah, shall I change subject to 'inet: Skip usage calculation if no
>> memcg to charge'? Or do you have any suggestions?
> 
> I would call this a cleanup or refactoring, maybe...

Alright, I have changed to 'cleanup', please take a look at v2.

Yet I have another question about this condition:
	'if (newsk && mem_cgroup_sockets_enabled)'
IMHO in the scope of cgroup v1, 'mem_cgroup_sockets_enabled' doesn't
imply socket accounting enabled for current's memcg. As the listening
socket and the newly accepted socket are processing same traffic, can
we make this condition more specific like this:
	'if (newsk && mem_cgroup_sockets_enabled && sk->sk_memcg)'
would you mind shedding some light please?

Thanks!
	Abel

