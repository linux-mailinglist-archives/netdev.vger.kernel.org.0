Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5046314638
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhBICZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhBICYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:24:49 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89033C06178A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 18:24:08 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id k25so17863792oik.13
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 18:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u3xrU02yQUF/xibod3GzL3Drcd8fUDkPNb1Cp1StP18=;
        b=c0yzXJa1ObkLLnWNKid+sEkLgAKNsUjiTtytFnfqO4VcLErAL+RV3MZBNReyyzLQ2t
         uw6SOpZLXnZeDyfgl4qg7D3IW22nf35HmeDdSC6zuzQ+wypIadECtgsQUhn5Br4H6zfk
         eH0WuLULd8hlSJsMOJlNRJ1JbT9Im2qAJcTDKLfTP7fwwtlH49OTD9AuULc+wf9s57ra
         m5MTbAdp3cqB+zGNP+demBjQfLzAFmC+yWhR5+xNxkeGeqIQi/4/Xxz2z9m3ycr4iQH3
         MUMPL3M09giWap4aAKYnIaoKImZx8ArKX4PZEQkie0eLdFERN0Jjf9Un+Crr8qavpMH7
         yclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u3xrU02yQUF/xibod3GzL3Drcd8fUDkPNb1Cp1StP18=;
        b=VhWpnpQ9ba0vRr1UbhEq4NcGEEjsfokH1xZ2OZQdnfV2RAGh5ypd4LQd8BLpw/3t5H
         czrMYt2Vu6IxaOULvg+xrfI8IY5qDq4RaPC6gdwDxuoUP/tXT43xxK91gTHJ0QuztJqR
         oTplQYSJLpy+df1ewAjEIHuCr5sy5gNw2lawHVQeIiV2SBXddnUE99d3okRs6SsEvcrB
         SZAMUz40+zAYOzWLK2ZXPB2hNZ9TAf7HutbirFup1jxm59ZVwXh5ZNVFJRhD+HylniO1
         iyunlvfJgGAbNLDCQ1TKkNfHGOq/koH6ibCvUaS4WQDN9vmU+O/Op5N9dOuZ0eV4Zudv
         005g==
X-Gm-Message-State: AOAM530sPv98n+r4YueP0fEuGjGQL6CMQkkxjtOn8NpPwxSR/qDaIUVO
        5EbFnpsMC58Y8x39XQgxTEg=
X-Google-Smtp-Source: ABdhPJxHLF2ZCTpdVruDImmcp3s4gejPHAjwYpwsnrmQtoL+0LkXrpbFMQVa9bm141HPKdNa8EeBRA==
X-Received: by 2002:aca:3cc3:: with SMTP id j186mr1116175oia.12.1612837448027;
        Mon, 08 Feb 2021 18:24:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id a13sm4186250otr.49.2021.02.08.18.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 18:24:07 -0800 (PST)
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal>
 <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com>
Date:   Mon, 8 Feb 2021 19:24:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 11:41 AM, Jakub Kicinski wrote:
> On Sun, 7 Feb 2021 10:26:54 +0200 Leon Romanovsky wrote:
>> On Sat, Feb 06, 2021 at 03:28:28PM -0800, Jakub Kicinski wrote:
>>> On Sat,  6 Feb 2021 12:36:48 -0800 Arjun Roy wrote:  
>>>> From: Arjun Roy <arjunroy@google.com>
>>>>
>>>> Explicitly define reserved field and require it to be 0-valued.  
>>>  
>>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>>> index e1a17c6b473c..c8469c579ed8 100644
>>>> --- a/net/ipv4/tcp.c
>>>> +++ b/net/ipv4/tcp.c
>>>> @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>>>>  		}
>>>>  		if (copy_from_user(&zc, optval, len))
>>>>  			return -EFAULT;
>>>> +		if (zc.reserved)
>>>> +			return -EINVAL;
>>>>  		lock_sock(sk);
>>>>  		err = tcp_zerocopy_receive(sk, &zc, &tss);
>>>>  		release_sock(sk);  
>>>
>>> I was expecting we'd also throw in a check_zeroed_user().
>>> Either we can check if the buffer is zeroed all the way,
>>> or we can't and we shouldn't validate reserved either
>>>
>>> 	check_zeroed_user(optval + offsetof(reserved),
>>> 			  len - offsetof(reserved))
>>> ?  
>>
>> There is a check that len is not larger than zs and users can't give
>> large buffer.
>>
>> I would say that is pretty safe to write "if (zc.reserved)".
> 
> Which check? There's a check which truncates (writes back to user space
> len = min(len, sizeof(zc)). Application can still pass garbage beyond
> sizeof(zc) and syscall may start failing in the future if sizeof(zc)
> changes.
> 

That would be the case for new userspace on old kernel. Extending the
check to the end of the struct would guarantee new userspace can not ask
for something that the running kernel does not understand.


