Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10793F7C7A
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242437AbhHYS5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbhHYS5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 14:57:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450C8C061757;
        Wed, 25 Aug 2021 11:56:21 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id mf2so510400ejb.9;
        Wed, 25 Aug 2021 11:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xvawx26XH1LgAnwFO6bkrCV07A1Wb2tVA3/Wjwf9oRQ=;
        b=OEeSzujyOV65sqIdM5kYmWTYcqidPsldWKX79B3NxqL4aMp6dfU7LRu+/VYaO3NwQB
         LIw51AnkVRjthkcsR1EONmLe/N/Jp9RhzMCuhfEdAKWQgIlnJuGUxuE7Ruq8Y4NGeybD
         zCoa0MSY1k3gAIeFQ0ELLZVrfxxSpKXu470fadvRWCNm9/U/I5Gbd6ZtJYroZIrKvHEr
         +yzXg19h2Qc1lDOcx66x6HrvJ96GbgUB3QTGp6h3k8uomIH3AwD/wUS+mPz2Lx3gdYUW
         meZyoHddVqUr+5LVnzYal6g6i8usJ121xGfz8v1P6uLIBHy6IIRijD9Yj4zHPsKgl4aV
         nHdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xvawx26XH1LgAnwFO6bkrCV07A1Wb2tVA3/Wjwf9oRQ=;
        b=n9Zp/Z1TDfBtDt7C2bC0sctpD7PUvoNP+1dmls1hVu8IFMK025zzkMIyqaSwsHDz7I
         7XoXbgvuPdMMXXlT0Gn0K6kqHWy0uRqrtzGkwv4rHTqm/ZXJ0RglHtvbNMO6+T7tm83N
         QssN7zxsRbsMY5vmvbd6qBsdktpVAYEhitAHLQmYbCIoWuX6Dj+3hrOGUPGH39AkF4Cg
         Bz6BwTmD4mn5H133gBEsjGMCrHGpuCcoyB4htQspa1oEunW7jnAvMVpVgrz9eULtRPx9
         FPklbi++X1z0ou8oBwLxD6cnPGGL52I6tIl785p66ftSjtZCjM3A+MHBpa2tMF/8LWt0
         MJZg==
X-Gm-Message-State: AOAM532Qx+VAyeYTMbiJoQkQ28GHeQgWXsjUOtKvM/z7b5mtPENjqGpH
        BmUdYRFsfg0PmSvLCqtLXwDgARZtzuE7YQ==
X-Google-Smtp-Source: ABdhPJyifGSNNpdCglT67n9EYRdk9exke3nves7QvqUrYs9XqP5ZyqlAHGUrSgYsQDGqI1sKzyl+mw==
X-Received: by 2002:a17:906:a0da:: with SMTP id bh26mr73147ejb.505.1629917779776;
        Wed, 25 Aug 2021 11:56:19 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:f02c:a1bd:70b1:fe95? ([2a04:241e:502:1d80:f02c:a1bd:70b1:fe95])
        by smtp.gmail.com with ESMTPSA id e7sm517874edk.3.2021.08.25.11.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 11:56:19 -0700 (PDT)
Subject: Re: [RFCv3 05/15] tcp: authopt: Add crypto initialization
To:     Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>
References: <cover.1629840814.git.cdleonard@gmail.com>
 <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
 <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com>
 <27e56f61-3267-de50-0d49-5fcfc59af93c@gmail.com>
 <CANn89iJPyQpJTxrDMGszEOrgKwaEdYz1xaRK7vKbS4qj9tV23g@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <9ee51fc2-0b7e-4dc5-881b-9f6d671347ea@gmail.com>
Date:   Wed, 25 Aug 2021 21:56:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJPyQpJTxrDMGszEOrgKwaEdYz1xaRK7vKbS4qj9tV23g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 8:55 PM, Eric Dumazet wrote:
> On Wed, Aug 25, 2021 at 9:35 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> On 25.08.2021 02:34, Eric Dumazet wrote:
>>> On 8/24/21 2:34 PM, Leonard Crestez wrote:
>>>> The crypto_shash API is used in order to compute packet signatures. The
>>>> API comes with several unfortunate limitations:
>>>>
>>>> 1) Allocating a crypto_shash can sleep and must be done in user context.
>>>> 2) Packet signatures must be computed in softirq context
>>>> 3) Packet signatures use dynamic "traffic keys" which require exclusive
>>>> access to crypto_shash for crypto_setkey.
>>>>
>>>> The solution is to allocate one crypto_shash for each possible cpu for
>>>> each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
>>>> softirq context, signatures are computed and the tfm is returned.
>>>>
>>>
>>> I could not see the per-cpu stuff that you mention in the changelog.
>>
>> That's a little embarrasing, I forgot to implement the actual per-cpu
>> stuff. tcp_authopt_alg_imp.tfm is meant to be an array up to NR_CPUS and
>> tcp_authopt_alg_get_tfm needs no locking other than preempt_disable
>> (which should already be the case).
> 
> Well, do not use arrays of NR_CPUS and instead use normal per_cpu
> accessors (as in __tcp_alloc_md5sig_pool)
> 
>>
>> The reference counting would still only happen from very few places:
>> setsockopt, close and openreq. This would only impact request/response
>> traffic and relatively little.
> 
> What I meant is that __tcp_alloc_md5sig_pool() allocates stuff one time,
> we do not care about tcp_md5sig_pool_populated going back to false.
> 
> Otherwise, a single user application constantly allocating a socket,
> enabling MD5 (or authopt), then closing the socket would incur
> a big cost on hosts with a lot of cpus.

Allocating only once would definitely simply things.

I don't know if this might end up tying hardware resources forever if 
some accelerators are in play but for this feature software-only crypto 
is perfectly fine.

--
Regards,
Leonard
