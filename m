Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29B048BCF9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 03:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348191AbiALCOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 21:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbiALCN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 21:13:59 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8798FC06173F;
        Tue, 11 Jan 2022 18:13:59 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo2073573pjb.2;
        Tue, 11 Jan 2022 18:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UBRSCwl1h80JfOWUyCNKWUY0/nYFol6Uy1tcq62PMUg=;
        b=W/ypUrhWNGGj6kS1x25nDafTlERA5Dr+GytZo6BWkb5HhZ/h5wrxitFrLjuPtUodFy
         sX4y6LipH4UYN0XujN1baAvtbuOwqnBcjgkMFZ0H25O9EL1UOasbRs7C1+QlWWgGpJA0
         ykYOZv40w9sCOqHnrc8UshSJ9XK0qYCBHWrs+KuH7W5J3DITS6cxIZwRm1rvvGfK6IVO
         xTM9pkoMncJ1d9tVvrAzBFAKqn0KkJqhllpuwBAPs8rcvy+Cbbfy1rHeMaYxwOpqXLPp
         4K6J98r2Nml4FwFpmXyQLQO59vPv/ueGlspyDS54KcUYFf14OSVAUdncUXrIyXl+ER1q
         kBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UBRSCwl1h80JfOWUyCNKWUY0/nYFol6Uy1tcq62PMUg=;
        b=x7wWyBAZQmp4f2ITSDGuDtMJNUT/KxuUH4O46vmHxk9yK6wv6YU9fEpLoeAF5RS7l0
         0F/Bo1Deus/PTuXUC7th9DhSjtvs01nqQL06lK/d+MFA8Xd16RTe1Htop2+UwdKozWki
         JxWG9BXL9lGwurFiwa4//9mAK3ehdoVBK58CeMVE4g57jRY8zCNeaMhHCUSr4c7kZkRN
         NODAGnH/1I+y7NKm8DgZvTxoVzqK6nMWLOs+2x9CVqbBABHQAIp5TAbrGiZ5qlvvqPzr
         WciOUQbsyG2nkAkMCpyua2CGEj7BR9V0t2Sqru3wrythI2F8YiAu99RAtweV8oC1+ur5
         MTMQ==
X-Gm-Message-State: AOAM5304zL0ygLW2i53B9sUphPvuvdHjRrGNOHZ5AM0XfavEGW5iZfsn
        oG3HnyZ6eiiZpPmhAwxKW8nPxMSU4hzcAg==
X-Google-Smtp-Source: ABdhPJwcEUecB1z2jtYuD1HUeCMO8y23p3vLqbACbVgfAsy4DKieYQ8c603nk4GF65JxmZXnPe5M/A==
X-Received: by 2002:a17:90a:7e81:: with SMTP id j1mr6318043pjl.14.1641953638984;
        Tue, 11 Jan 2022 18:13:58 -0800 (PST)
Received: from [0.0.0.0] ([20.187.112.107])
        by smtp.gmail.com with ESMTPSA id hk13sm4064773pjb.35.2022.01.11.18.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 18:13:58 -0800 (PST)
Subject: Re: [PATCH net] ax25: use after free in ax25_connect
To:     Eric Dumazet <eric.dumazet@gmail.com>, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111042048.43532-1-hbh25y@gmail.com>
 <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
From:   Hangyu Hua <hbh25y@gmail.com>
Message-ID: <f48850cb-8e26-afa0-576c-691bb4be5587@gmail.com>
Date:   Wed, 12 Jan 2022 10:13:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I try to use ax25_release to trigger this bug like this:
ax25_release                 ax25_connect
lock_sock(sk);
-----------------------------sk = sock->sk;
-----------------------------ax25 = sk_to_ax25(sk);
ax25_destroy_socket(ax25);
release_sock(sk);
-----------------------------lock_sock(sk);
-----------------------------use ax25 again

But i failed beacause their have large speed difference. And i
don't have a physical device to test other function in ax25.
Anyway, i still think there will have a function to trigger this
race condition like ax25_destroy_timer. Beacause Any ohter
functions in ax25_proto_ops like ax25_bind protect ax25_sock by 
lock_sock(sk).

Thanks.




On 2022/1/12 上午4:56, Eric Dumazet wrote:
> 
> On 1/10/22 20:20, Hangyu Hua wrote:
>> sk_to_ax25(sk) needs to be called after lock_sock(sk) to avoid UAF
>> caused by a race condition.
> 
> Can you describe what race condition you have found exactly ?
> 
> sk pointer can not change.
> 
> 
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/ax25/af_ax25.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
>> index cfca99e295b8..c5d62420a2a8 100644
>> --- a/net/ax25/af_ax25.c
>> +++ b/net/ax25/af_ax25.c
>> @@ -1127,7 +1127,7 @@ static int __must_check ax25_connect(struct 
>> socket *sock,
>>       struct sockaddr *uaddr, int addr_len, int flags)
>>   {
>>       struct sock *sk = sock->sk;
>> -    ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
>> +    ax25_cb *ax25, *ax25t;
>>       struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 
>> *)uaddr;
>>       ax25_digi *digi = NULL;
>>       int ct = 0, err = 0;
>> @@ -1155,6 +1155,8 @@ static int __must_check ax25_connect(struct 
>> socket *sock,
>>       lock_sock(sk);
>> +    ax25 = sk_to_ax25(sk);
>> +
>>       /* deal with restarts */
>>       if (sock->state == SS_CONNECTING) {
>>           switch (sk->sk_state) {
