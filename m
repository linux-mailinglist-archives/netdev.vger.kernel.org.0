Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB889446757
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhKEQzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhKEQzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 12:55:54 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC72C061714;
        Fri,  5 Nov 2021 09:53:14 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w1so35479028edd.10;
        Fri, 05 Nov 2021 09:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3wQiaaWhR30+eBaE/+DYo9nkogWMcP6rX9ZpU/zDODA=;
        b=h0qtt4EyrB8SubAJDk6MU80NETFOFF+DciUePl49cGm7MPXqsYpPWFGxJbJbiwZ1eg
         Cyhj7z4sq3t0zKTExlgcxnHXjouxKYPfn6BZ20GvcjBR3VWmAtMyEeGd8+SCzhZCaDHA
         CroS1AkarPJGy4jVHpl+NnXGgVibW+5vmoJF905dNCmaKgybUI+SN2JAT0HHocMArBde
         gHyab7ptqjtjL4ZXKIpbW3yBYYmOzfkE4qG87Pz2fx4+v0z4aX/NP7Xbk4jPAEeHFw0x
         krb/LBNKt2H3/a+isRKQpUjnmxNvHaFAoNb8+L2hITrWyhA2hcoXd1iO2MyG2XA4r9L+
         JnAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3wQiaaWhR30+eBaE/+DYo9nkogWMcP6rX9ZpU/zDODA=;
        b=WMafNoOUGdw9zvZZOpW6mOx+3rjGSb5brSyEtkIKdFvzpnFT+JR5KCrC0pzEd29Og1
         h7QP16DNE/BVAL+vPnawmJgR8NzVVXQpwRu+8AUvYDUvKtmLOB1sIHhBEb37Lsdnhfq8
         RnC5QzrLaBJ85J2boR+KpKabIYcLzgUYckvDS1RdoQOGOuY+jBUeWirkYEtxrkfmPe9l
         uk4acGv5V8elG19tjQC+NOAnJjWScfcOZGTdm3hRzRKnz9gG8Iacd/CKsMtKOonUn9Ww
         PSfNo9k+h7Nr/MH0ivTvC3x/OGA+g4x2RgYE2mbSugGLdJBHvo+WqGcPKsv2tPJEnlRl
         1FJQ==
X-Gm-Message-State: AOAM533aVwylAJV3lsRcqAKqwppbcBgViOVBYFt83Mc4hRh70I7Fyben
        4JE2za5W7xAYp94U/OmFUuM=
X-Google-Smtp-Source: ABdhPJzo2+IndVPww4UMxxGyhzUoBuE9XZD6xUx0GRRNIq95EeHqno3CSGN55nQ1K6VbnrDUglf3ug==
X-Received: by 2002:a05:6402:d0e:: with SMTP id eb14mr18970650edb.59.1636131193486;
        Fri, 05 Nov 2021 09:53:13 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:9439:4202:183c:5296? ([2a04:241e:501:3870:9439:4202:183c:5296])
        by smtp.gmail.com with ESMTPSA id j12sm5482429edw.14.2021.11.05.09.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 09:53:13 -0700 (PDT)
Subject: Re: [PATCH 5/5] tcp/md5: Make more generic tcp_sig_pool
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20211105014953.972946-1-dima@arista.com>
 <20211105014953.972946-6-dima@arista.com>
 <88edb8ff-532e-5662-cda7-c00904c612b4@gmail.com>
 <11215b43-cd3f-6cdc-36da-44636ca11f51@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <4de0111a-af4e-779e-eda9-f0cda433dde5@gmail.com>
Date:   Fri, 5 Nov 2021 18:53:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <11215b43-cd3f-6cdc-36da-44636ca11f51@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 3:59 PM, Dmitry Safonov wrote:
> On 11/5/21 09:54, Leonard Crestez wrote:
>> On 11/5/21 3:49 AM, Dmitry Safonov wrote:
>>> Convert tcp_md5sig_pool to more generic tcp_sig_pool.
>>> Now tcp_sig_pool_alloc(const char *alg) can be used to allocate per-cpu
>>> ahash request for different hashing algorithms besides md5.
>>> tcp_sig_pool_get() and tcp_sig_pool_put() should be used to get
>>> ahash_request and scratch area.
>>
>> This pool pattern is a workaround for crypto-api only being able to
>> allocate transforms from user context.
>>> It would be useful for this "one-transform-per-cpu" object to be part of
>> crypto api itself, there is nothing TCP-specific here other than the
>> size of scratch buffer.
> 
> Agree, it would be nice to have something like this as a part of crypto.
> The intention here is to reuse md5 sig pool, rather than introduce
> another similar one.
> 
>>> Make tcp_sig_pool reusable for TCP Authentication Option support
>>> (TCP-AO, RFC5925), where RFC5926[1] requires HMAC-SHA1 and AES-128_CMAC
>>> hashing at least.
>> Additional work would be required to support options of arbitrary size
>> and I don't think anyone would use non-standard crypto algorithms.
>>
>> Is RFC5926 conformance really insufficient?
> 
> For the resulting hash, the scratch buffer can be used.
> 
> Honestly, I just don't see much benefit in introducing more code and
> structures in order to limit hash algorithms. If anything,
> 
> :if (strcmp("hmac(sha1)", opts.algo) && strcmp("cmac(aes)", opts.algo))
> :       return -EPROTONOSUPPORT;
> 
> and passing the string straight to crypto seems to be better than adding
> new structures.
> 
> On the other side, those two hashes MUST be supported to comply with
> RFC, other may. As user can already configure conflicting receive/send
> ids for MKTs, I don't see a point not allowing any hash algorithm
> supported by crypto.

The algorithm enum controls not just the algorithm but the length in 
bytes of the traffic key and signatures. Supporting arbitrary algorithms 
requires supporting arbitrary byte lengths everywhere and increasing a 
couple of stack allocations (including some in the TCP core).

An earlier version actually had u8 fields for the length but those were 
later removed.

Adding this is not difficult but requires careful testing of the new 
corner cases. All this will be for functionality is never going to be used.

>> My knowledge of cryptography doesn't go much beyond "data goes in
>> signature goes out" but there are many recent arguments from that cipher
>> agility is outright harmful and recent protocols like WireGuard don't
>> support any algorithm choices.
> 
> You already limit usage when root-enabled sysctl is triggered, I don't
> see big concerns here.
> 
>>
>>> +#define TCP_SIG_POOL_MAX        8
>>> +static struct tcp_sig_pool_priv_t {
>>> +    struct tcp_sig_crypto        cryptos[TCP_SIG_POOL_MAX];
>>> +    unsigned int            cryptos_nr;
>>> +} tcp_sig_pool_priv = {
>>> +    .cryptos_nr = 1,
>>> +    .cryptos[TCP_MD5_SIG_ID].alg = "md5",
>>> +};
>>
>> Why an array of 8? Better to use an arbitrary list.
> 
> Some reasonable limit, may be 16 or whatever in order to avoid
> dynamically (re-)allocating the array and keeping O(1) lookups.

Defining an arbitrary array length limit is an underhanded way of making 
lookup O(1).
