Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D78A427C54
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhJIRVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhJIRVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 13:21:23 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD95C061570;
        Sat,  9 Oct 2021 10:19:26 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so11161822ote.8;
        Sat, 09 Oct 2021 10:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UZqTJRIKhlJ43FGgr7DGTxAyJOWTtWJNQ/u5JBWcW1k=;
        b=WZwp2JD30emcfMBe/9zCcNw9rAKyhIEH/bhw90Ex9zNcZ/HzXp/XarDmhJhc6I02Qv
         XvxcudZ6hmLVuzdlxUo4WQhZ9TcPhHUE2NHCw8EG5PaUtjnYxqdKpOLADGrOhloNeVcx
         DuIS9S0NzpXBD5ihOoLOsY9xViKKTflUW4qaHnMwJAhah7GYzWDGNUFKFd/pdPPhCLUs
         ciY5oUhfpME910q4qGpgo9VB+c7xJJtjdz5MucTjDFWlQHm54HrKHh07Oq1R3ecbXwbK
         wi28bdDR5C5+GbiI+hdY+iTXhJqePZOG1n8GFcwyAcpF7a0vYm6AeH4Tk6B2BcxQvx9j
         ZXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZqTJRIKhlJ43FGgr7DGTxAyJOWTtWJNQ/u5JBWcW1k=;
        b=VEzfc0hQQ3yvY3xTfD2omE8AO/yrjEjNysCDyqcUugQs3YWkq2PZ6K2tKVRZ8/Uj1C
         QWsiZAPQMUoNOmFqDmYWTRuNLSCXAkONlzrIFUm3Yng/RMgukdCmCZkCAAa9IuYLoHMG
         Fq03Kp31UmCQO21f7Wlh0ak8POHoidlMeZHwjVS4fSftt8qZwDEXpzM8mc6bIgxrw9u7
         yvmyNnMaqyIHDfMSHud3zC7+XQBkGZpC7q5XL0AIiB96K5xws3ZSTvn0EZC84m4NplPS
         9rTUTvKuRAqCJ9LrxAvKsY7TTV1ksGBV+DCNjQUyhhQUddD/fMF2sO0QiYEnrSptre0f
         kaPA==
X-Gm-Message-State: AOAM531FvjBHhQsJk2+nraz4LA5Uza5D/W54W/TxTwKOqa0jsQC+XjrB
        IlD34Hap3BnOogppHyiTbYDIvSWgyxdVYA==
X-Google-Smtp-Source: ABdhPJx5koKOmpa4SIttslUC6uXSHE/n/hySn/pg6RoVqHhZ65HpSs3ilfxf16QPUj+oGLiV4gBoxw==
X-Received: by 2002:a9d:60da:: with SMTP id b26mr14793219otk.369.1633799965288;
        Sat, 09 Oct 2021 10:19:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id q12sm609705oth.79.2021.10.09.10.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 10:19:24 -0700 (PDT)
Subject: Re: [PATCH] tcp: md5: Fix overlap between vrf and non-vrf keys
To:     Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com>
 <209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com>
 <912670a5-8ef2-79cc-b74b-ee5c83534f2b@gmail.com>
 <5c77ac1a-b6af-982f-d72f-e71098df3112@gmail.com>
 <3b52d69d-c39f-c662-7211-4b9130c8b527@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <eec5818a-c62c-eecf-c81c-e3162fc9e01a@gmail.com>
Date:   Sat, 9 Oct 2021 11:19:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <3b52d69d-c39f-c662-7211-4b9130c8b527@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/21 9:51 AM, Leonard Crestez wrote:
> On 07.10.2021 21:27, David Ahern wrote:
>> On 10/7/21 12:41 AM, Leonard Crestez wrote:
>>> On 07.10.2021 04:14, David Ahern wrote:
>>>> On 10/6/21 11:48 AM, Leonard Crestez wrote:
>>>>> @@ -1103,11 +1116,11 @@ static struct tcp_md5sig_key
>>>>> *tcp_md5_do_lookup_exact(const struct sock *sk,
>>>>>    #endif
>>>>>        hlist_for_each_entry_rcu(key, &md5sig->head, node,
>>>>>                     lockdep_sock_is_held(sk)) {
>>>>>            if (key->family != family)
>>>>>                continue;
>>>>> -        if (key->l3index && key->l3index != l3index)
>>>>> +        if (key->l3index != l3index)
>>>>
>>>> That seems like the bug fix there. The L3 reference needs to match for
>>>> new key and existing key. I think the same change is needed in
>>>> __tcp_md5_do_lookup.
>>>
>>> Current behavior is that keys added without tcpm_ifindex will match
>>> connections both inside and outside VRFs. Changing this might break real
>>> applications, is it really OK to claim that this behavior was a bug all
>>> along?
>>
>> no.
>>
>> It's been a few years. I need to refresh on the logic and that is not
>> going to happen before this weekend.
> 
> It seems that always doing a strict key->l3index != l3index condition
> inside of __tcp_md5_do_lookup breaks the usecase of binding one listener
> to each VRF and not specifying the ifindex for each key.
> 
> This is a very valid usecase, maybe the most common way to use md5 with
> vrf.
> 
> Ways to fix this:
> * Make this comparison only take effect if TCP_MD5SIG_FLAG_IFINDEX is set.
> * Make this comparison only take effect if tcp_l3mdev_accept=1
> * Add a new flag?
> 
> Right now passing TCP_MD5SIG_FLAG_IFINDEX and ifindex == 0 results in an
> error but maybe it should be accepted to mean "key applies only for
> default VRF".
> 

I think I remember the history now: prior to the set
98c8147648fa..5cad8bce26e0 MD5 lookups for VRF and default VRF both
succeed on an address or prefix match because the L3 domain was not
checked. That set did not want to break the legacy behavior which is why
the change is based on db key having l3index set and matching the
ingress domain.

That means the limitation (hole depending on perspective) is a default
VRF and a VRF having overlap addresses with a key installed with the L3
index set (can't since default VRF does not have one) - which I believe
is your point.

So, yes, one option is to have a flag that indicates strict checking to
close the legacy path.
