Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717BE48E47F
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbiANGyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbiANGyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:54:39 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD63EC061574;
        Thu, 13 Jan 2022 22:54:39 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id u15so12581124ple.2;
        Thu, 13 Jan 2022 22:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lP+FWeLatKIgWi4K1uF9Ut4u7DuYHyR3vsLHEPtX4Zs=;
        b=KU4eR1cryTDNQ7A8gd3td28XecdUreEOHE2hNGXuP4aR0uQ7GF0Oo3Amb1NxFA3AoR
         5TZ76WkFeA22lB2YniQTjSFJO2RDlbg9KmYW9nTH/90Xcm+w2SqrJCt/Ni2z06aqgoR1
         G4R2Dn67iLvf93mUxjKOpvSRoBs7pohecn7s4WTrhKP8CjVxvYGf8qAIwUYFStk62caF
         TSUZ81SjpQrqw40x2RWbBFwrYdiCXqE78tJgq1rU3Eh5p4UdGEfAK1cM2BKWZfz2mce+
         OxBIuY5ARrRA5Wj4UkFG8n/dSRIwBcoLD9yyMxCzZFYybpbHBcnI6ydh2N8+Xs4Yk6DC
         rf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lP+FWeLatKIgWi4K1uF9Ut4u7DuYHyR3vsLHEPtX4Zs=;
        b=HJ/l6YHW/IPSl/b49YMDFk5m1v2BZFW1XLeEM2a9C/bSWDL3y469p4m4fVWF4N4fQN
         SqJmvTFo1E42urkX1FYVt3CpdPzdZG6k6kOFsihfvwuAqbfbL92O73RiZLG2Zvde6m9P
         +MA1rg6KBZcuoYUtf9lD8//ow7l3eDs9BmK+VaoRi1n4E7gqcRQNlakVMBrlVnoDS25t
         f3mhNG6NpCqJWOcbgMaDiInznncW+zHnfq+mjyNQPqlOCSm5rONZH1NPkPd1KDcP+cde
         mzG9XjGOyADVvqLU3eTtARCinElSIQ/UHu9jLyNVh1paz0+3csqai70y/m7ZOfcj5DYb
         0ZBA==
X-Gm-Message-State: AOAM532JhuUhZUCRfPKOJ3ZlRrgavIygJ1PqdPG1xnP4w4LUpODL+Z1S
        xasVvwX3tY24dckibB21fpKR6ntzj8gP6Q==
X-Google-Smtp-Source: ABdhPJzyzjU/uZgZ9WDaZtLdgohJVVkoeQi9389BxFrLS3PC+cWNzAw3yccfqXmhvCOn5ZEtBHUidw==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr9106011pjj.116.1642143279166;
        Thu, 13 Jan 2022 22:54:39 -0800 (PST)
Received: from [0.0.0.0] ([20.187.112.107])
        by smtp.gmail.com with ESMTPSA id y79sm4505412pfb.116.2022.01.13.22.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 22:54:38 -0800 (PST)
Subject: Re: [PATCH net] ax25: use after free in ax25_connect
From:   Hangyu Hua <hbh25y@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111042048.43532-1-hbh25y@gmail.com>
 <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
 <f48850cb-8e26-afa0-576c-691bb4be5587@gmail.com>
 <571c72e8-2111-6aa0-1bd7-e0af7fc50539@gmail.com>
 <80007b3e-eba8-1fbe-302d-4398830843dd@gmail.com>
Message-ID: <ff65d70b-b6e1-3b35-8bd0-92f6f022cd5d@gmail.com>
Date:   Fri, 14 Jan 2022 14:54:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <80007b3e-eba8-1fbe-302d-4398830843dd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any suggestions for this patch ? Guys.

I think putting sk_to_ax25 after lock_sock(sk) here will avoid any 
possilbe race conditions like other functions in ax25_proto_ops.

On 2022/1/12 下午7:11, Hangyu Hua wrote:
> Yes.
> 
> And there are two ways to release ax25, ax25_release and time expiry. I 
> tested that ax25_release will not be invoked before ax25_connect is done 
> by closing fd from user space. I think the reason is that __sys_connect 
> use fdget() to protect fd. But i can't test if a function like 
> ax25_std_heartbeat_expiry will release ax25 between sk_to_ax25(sk) and 
> lock_sock(sk).
> 
> So i think it's better to protect sk_to_ax25(sk) by a lock. Beacause 
> functions like ax25_release use sk_to_ax25 after a lock.
> 
> 
> On 2022/1/12 下午5:59, Eric Dumazet wrote:
>>
>> On 1/11/22 18:13, Hangyu Hua wrote:
>>> I try to use ax25_release to trigger this bug like this:
>>> ax25_release                 ax25_connect
>>> lock_sock(sk);
>>> -----------------------------sk = sock->sk;
>>> -----------------------------ax25 = sk_to_ax25(sk);
>>> ax25_destroy_socket(ax25);
>>> release_sock(sk);
>>> -----------------------------lock_sock(sk);
>>> -----------------------------use ax25 again
>>>
>>> But i failed beacause their have large speed difference. And i
>>> don't have a physical device to test other function in ax25.
>>> Anyway, i still think there will have a function to trigger this
>>> race condition like ax25_destroy_timer. Beacause Any ohter
>>> functions in ax25_proto_ops like ax25_bind protect ax25_sock by 
>>> lock_sock(sk).
>>
>>
>> For a given sk pointer, sk_to_ax25(sk) is always returning the same 
>> value,
>>
>> regardless of sk lock being held or not.
>>
>> ax25_sk(sk)->cb  is set only from ax25_create() or ax25_make_new()
>>
>> ax25_connect can not be called until these operations have completed ?
>>
>>
>>
>>>
>>> Thanks.
>>>
>>>
>>>
>>>
>>> On 2022/1/12 上午4:56, Eric Dumazet wrote:
>>>>
>>>> On 1/10/22 20:20, Hangyu Hua wrote:
>>>>> sk_to_ax25(sk) needs to be called after lock_sock(sk) to avoid UAF
>>>>> caused by a race condition.
>>>>
>>>> Can you describe what race condition you have found exactly ?
>>>>
>>>> sk pointer can not change.
>>>>
>>>>
>>>>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>>>>> ---
>>>>>   net/ax25/af_ax25.c | 4 +++-
>>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
>>>>> index cfca99e295b8..c5d62420a2a8 100644
>>>>> --- a/net/ax25/af_ax25.c
>>>>> +++ b/net/ax25/af_ax25.c
>>>>> @@ -1127,7 +1127,7 @@ static int __must_check ax25_connect(struct 
>>>>> socket *sock,
>>>>>       struct sockaddr *uaddr, int addr_len, int flags)
>>>>>   {
>>>>>       struct sock *sk = sock->sk;
>>>>> -    ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
>>>>> +    ax25_cb *ax25, *ax25t;
>>>>>       struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 
>>>>> *)uaddr;
>>>>>       ax25_digi *digi = NULL;
>>>>>       int ct = 0, err = 0;
>>>>> @@ -1155,6 +1155,8 @@ static int __must_check ax25_connect(struct 
>>>>> socket *sock,
>>>>>       lock_sock(sk);
>>>>> +    ax25 = sk_to_ax25(sk);
>>>>> +
>>>>>       /* deal with restarts */
>>>>>       if (sock->state == SS_CONNECTING) {
>>>>>           switch (sk->sk_state) {
