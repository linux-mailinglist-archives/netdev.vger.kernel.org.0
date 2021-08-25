Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D863F7A92
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbhHYQcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240303AbhHYQcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:32:45 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739EBC0613CF;
        Wed, 25 Aug 2021 09:31:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n27so20839261eja.5;
        Wed, 25 Aug 2021 09:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wMkJXZoogesNm5JJZvMGG6cJlR5rgjyot4jq2nzi3Aw=;
        b=XULmqv9aBdS0Fee5y/TVfH7zm0Ki8Fr9H6xJYbd0rgvjJtLfgAxop9scK+vLa5YF7Q
         ukSf92YyYuuQd/O8ZZsjGI9hE1j+oCpd+hr3dAHN3kkyZGA6gwGLU83U1lOgfLD8UqP8
         8L0bsVwbZ1o3hbubchyuRfG94vhOJq3fimjwrPyi81k0fIXjklnca92aKj3WQoj4fn5v
         Ws9+UJMA2uevL8VA2/+8ZeYGLy2p7aZwhafF+9t2DhnRkJ/PFfOY/aRf+dVBG4sRCmtU
         CV6orFj5J2Ba/ezTejHEBAHrDkMSCv/KF844Hk+jogvV7mtmKSQ3UiXLcMn0F00vBA2b
         vrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wMkJXZoogesNm5JJZvMGG6cJlR5rgjyot4jq2nzi3Aw=;
        b=jOaRvfG4CdG7+5hAwusJDmL8egOvWnWliM5KV8QsKS+zIe+5gc1Eb/Rpkd1Z0WZ4N6
         qiZeW2ZShhoARBysCwH9uAXcIBMb+l5diDxbGjfsvywQgprA/MG3AvOeNGyROcAbhi3C
         2yqW6Oxyxc2nUrg0eXJ4DKaINO7IaWVgqViib8H6fo6eofDPVS8WQUU1cS5pDkYCPXDp
         u3y3WSoeam6YH2KS/GAiziVCx+iN+DTcexrf7PpTqhvX+gPGtow+yEP8WGoCb9DEPJRX
         2aR66g9G6X3Rg2BPRTnkPPDrNONFB2Ie2SsxLRCxP4uI/o3a9l9PX1+p1CP2WFetTgMF
         yacw==
X-Gm-Message-State: AOAM530cRMvKYQ28xdtIE4RdxyTt4KaebeyKDQoJZHuqcCquhy5Ot15S
        kVYSKX0p8Y9SvGH64WW5hB57wSxuswMM1A==
X-Google-Smtp-Source: ABdhPJyjhFW8we3pTfnvc4pI+Xrp2mFk6xfZ9gm2T2OaD4xNkrY/og4kroIQQpaA9fsSUNaUm683XQ==
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr9640191ejc.247.1629909118029;
        Wed, 25 Aug 2021 09:31:58 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:f02c:a1bd:70b1:fe95? ([2a04:241e:502:1d80:f02c:a1bd:70b1:fe95])
        by smtp.gmail.com with ESMTPSA id y21sm302048edu.13.2021.08.25.09.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:31:57 -0700 (PDT)
Subject: Re: [RFCv3 05/15] tcp: authopt: Add crypto initialization
To:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
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
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1629840814.git.cdleonard@gmail.com>
 <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
 <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com>
 <20210825080817.GA19149@gondor.apana.org.au>
 <CAMj1kXE_sDZJjmkoqHcLz=9fDqLPBNbyfH4zxN2s2RdgKO=eSw@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <c8f254e8-e241-8aad-4211-14c4da4e211c@gmail.com>
Date:   Wed, 25 Aug 2021 19:31:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXE_sDZJjmkoqHcLz=9fDqLPBNbyfH4zxN2s2RdgKO=eSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/21 7:04 PM, Ard Biesheuvel wrote:
> On Wed, 25 Aug 2021 at 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> On Tue, Aug 24, 2021 at 04:34:58PM -0700, Eric Dumazet wrote:
>>>
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
>> Perhaps it's time we moved the key information from the tfm into
>> the request structure for hashes? Or at least provide a way for
>> the key to be in the request structure in addition to the tfm as
>> the tfm model still works for IPsec.  Ard/Eric, what do you think
>> about that?
>>
> 
> I think it makes sense for a shash desc to have the ability to carry a
> key, which will be used instead of the TFM key, but this seems like
> quite a lot of work, given that all implementations will need to be
> updated. Also, setkey() can currently sleep, so we need to check
> whether the existing key manipulation code can actually execute during
> init/update/final if sleeping is not permitted.

Are you sure that setkey can sleep? The documentation is not clear, 
maybe it only applies to certain hardware implementations?

The TCP Authentication Option needs dynamic keys for SYN and SYNACK 
packets, all of which happens in BH context.

--
Regards,
Leonard
