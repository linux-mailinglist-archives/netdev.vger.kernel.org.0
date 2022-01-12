Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3597548C2E2
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 12:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352769AbiALLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 06:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352761AbiALLLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 06:11:10 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD635C06173F;
        Wed, 12 Jan 2022 03:11:10 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id pf13so4200602pjb.0;
        Wed, 12 Jan 2022 03:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iVlCo1TFSBMrozoizl3ZBqKH7/OrLx149Kn2CvvnqdE=;
        b=mTU+vUGIHWlm/17PwWxhC45VAIcBNSpihQhGtzP5UaoiGz8da4P5avJYxJkBU1GjIl
         UXuvK7ddIsu6seAIBZlml0UmPuLLx4Dl9+Ibh/8wyC5dJjLcnzKguZHRh4/iV5IQOWYi
         xALxGXzujDSy7Mt288cr426RK9lBjUV/Z1c0ANiuQt+Cv6rEUBgISXG8Dj1RhouxzpIB
         370vGB8j+MaEbAl1q52QWaY8GZIVZOcOUAkztzafYwfvPQAnNCgUK3kj0dc8+m9v3MYl
         npUMqFtvpvuC3tMjQ82Cub8uu/rLKXHnbNSqXMmXGVpkNTawVZ8wpyhPCCc+zNgSSfsp
         YkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iVlCo1TFSBMrozoizl3ZBqKH7/OrLx149Kn2CvvnqdE=;
        b=SqH7tlSAllZHETl3XbGOX6c2dV5yxUOzUfzmu2L+JXjncSLCK1wY/Kp9/sHQDZ4FEV
         MR1PCTIM1fgC4o/SiM5QyQX6uYEIrehU2JQpCXA5c0S3WEQaRuYBXEUF1KHnbwQYRHiQ
         9552wdapH5t6Vn/ZlsDo1WybdCpn/kty9vTxgnfwx/r8T3P2vJp9HjeP1r/1+IOk7/BU
         rN0DhdznKHyXSb2fAKMbmtlkTusFUEe0RcsLMW1HfmqjaqiNrjeYqMzJOBQn+5o9oZlS
         Ig0pTAuG7u1safIDFI5e04kEKAXYMdW20ogCHbp3Ve7nb1jA/eUWdLkDxn+6STp+dmz7
         Phug==
X-Gm-Message-State: AOAM533EL+Pd7f6K3jrEe4UaxXLjZhlEGO6NST508XIMRjN9BvaWSLbQ
        xDiBFV5VkXhA73mRQC9ZHFjLCOtODItdhMia
X-Google-Smtp-Source: ABdhPJz6nLyHQ0+VX2XGrBaoC2n4a2WzeLuc0Qv4oKEdShF4rH4Xrax3gMHQTRt0oBgEI9tDniXEuw==
X-Received: by 2002:a17:902:c086:b0:14a:6828:388d with SMTP id j6-20020a170902c08600b0014a6828388dmr2142149pld.17.1641985870124;
        Wed, 12 Jan 2022 03:11:10 -0800 (PST)
Received: from [0.0.0.0] ([20.187.112.145])
        by smtp.gmail.com with ESMTPSA id z24sm5347743pjq.17.2022.01.12.03.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 03:11:09 -0800 (PST)
Subject: Re: [PATCH net] ax25: use after free in ax25_connect
To:     Eric Dumazet <eric.dumazet@gmail.com>, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111042048.43532-1-hbh25y@gmail.com>
 <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
 <f48850cb-8e26-afa0-576c-691bb4be5587@gmail.com>
 <571c72e8-2111-6aa0-1bd7-e0af7fc50539@gmail.com>
From:   Hangyu Hua <hbh25y@gmail.com>
Message-ID: <80007b3e-eba8-1fbe-302d-4398830843dd@gmail.com>
Date:   Wed, 12 Jan 2022 19:11:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <571c72e8-2111-6aa0-1bd7-e0af7fc50539@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes.

And there are two ways to release ax25, ax25_release and time expiry. I 
tested that ax25_release will not be invoked before ax25_connect is done 
by closing fd from user space. I think the reason is that __sys_connect 
use fdget() to protect fd. But i can't test if a function like 
ax25_std_heartbeat_expiry will release ax25 between sk_to_ax25(sk) and 
lock_sock(sk).

So i think it's better to protect sk_to_ax25(sk) by a lock. Beacause 
functions like ax25_release use sk_to_ax25 after a lock.


On 2022/1/12 下午5:59, Eric Dumazet wrote:
> 
> On 1/11/22 18:13, Hangyu Hua wrote:
>> I try to use ax25_release to trigger this bug like this:
>> ax25_release                 ax25_connect
>> lock_sock(sk);
>> -----------------------------sk = sock->sk;
>> -----------------------------ax25 = sk_to_ax25(sk);
>> ax25_destroy_socket(ax25);
>> release_sock(sk);
>> -----------------------------lock_sock(sk);
>> -----------------------------use ax25 again
>>
>> But i failed beacause their have large speed difference. And i
>> don't have a physical device to test other function in ax25.
>> Anyway, i still think there will have a function to trigger this
>> race condition like ax25_destroy_timer. Beacause Any ohter
>> functions in ax25_proto_ops like ax25_bind protect ax25_sock by 
>> lock_sock(sk).
> 
> 
> For a given sk pointer, sk_to_ax25(sk) is always returning the same value,
> 
> regardless of sk lock being held or not.
> 
> ax25_sk(sk)->cb  is set only from ax25_create() or ax25_make_new()
> 
> ax25_connect can not be called until these operations have completed ?
> 
> 
> 
>>
>> Thanks.
>>
>>
>>
>>
>> On 2022/1/12 上午4:56, Eric Dumazet wrote:
>>>
>>> On 1/10/22 20:20, Hangyu Hua wrote:
>>>> sk_to_ax25(sk) needs to be called after lock_sock(sk) to avoid UAF
>>>> caused by a race condition.
>>>
>>> Can you describe what race condition you have found exactly ?
>>>
>>> sk pointer can not change.
>>>
>>>
>>>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>>>> ---
>>>>   net/ax25/af_ax25.c | 4 +++-
>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
>>>> index cfca99e295b8..c5d62420a2a8 100644
>>>> --- a/net/ax25/af_ax25.c
>>>> +++ b/net/ax25/af_ax25.c
>>>> @@ -1127,7 +1127,7 @@ static int __must_check ax25_connect(struct 
>>>> socket *sock,
>>>>       struct sockaddr *uaddr, int addr_len, int flags)
>>>>   {
>>>>       struct sock *sk = sock->sk;
>>>> -    ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
>>>> +    ax25_cb *ax25, *ax25t;
>>>>       struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 
>>>> *)uaddr;
>>>>       ax25_digi *digi = NULL;
>>>>       int ct = 0, err = 0;
>>>> @@ -1155,6 +1155,8 @@ static int __must_check ax25_connect(struct 
>>>> socket *sock,
>>>>       lock_sock(sk);
>>>> +    ax25 = sk_to_ax25(sk);
>>>> +
>>>>       /* deal with restarts */
>>>>       if (sock->state == SS_CONNECTING) {
>>>>           switch (sk->sk_state) {
