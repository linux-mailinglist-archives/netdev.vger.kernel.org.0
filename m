Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6C244648A
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhKEOCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhKEOCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 10:02:18 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88747C061714;
        Fri,  5 Nov 2021 06:59:38 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so6529543wmd.1;
        Fri, 05 Nov 2021 06:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IEEilxdtumvhQuHu01CeJOMQonSCRYhoVYf2TPz9W88=;
        b=cyPzB0Hfyhyz6+3VmCkjD1Qagc5Dcy/GPXBRG1j23G8+3aboF3wkH22enNT1xEHYN4
         z8AZcW1jkNMZkFT7xOwpE2qJDE8AlxtpS4QHazMzRRGg5mCEPDJVD5VuQNR5cRpGDrcW
         45NfO+xztyVBfxx0DbuHWdO+6TjHbAnEOxZT2l9jeV8pCdvA8UwmZX3lHxQzL1vryLQY
         lbYNGpkedzF/QI8FJcYaxnQmoyc+Pk18Gp+wjTUOfe4QDw0JAV9ffUJO7UmACn8S8Pdy
         SFvwv71vUfLWehRi8WAeLO/dsIvBDz6SGFcTDIdGDmng95Jxzdle/qjsn5aTySmCdsHW
         tOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IEEilxdtumvhQuHu01CeJOMQonSCRYhoVYf2TPz9W88=;
        b=uiNV+Fytnp1+BcYBOQE5t6nTJrZXuasaaVCobdcgYBBlNASINW76FaZh0wH9SB60tU
         twDWYh5O+ROH0X4YfcSTiZlgOP240IcLZkNodwCRJo9FLECnSO7/m4UR7ZSLwH0ctD+1
         nCOh+p6f1/lQa278B9AD0BSSYHKOP8qwM7I4npvc9/lYTiaibOZwS/Srck3r2Nzk7l7X
         x5I6OE4SBdvxaqXJBNZPZOUtuxqPBrM5BUL66MU1AfGxXj6PN770SRQD3LWW6O1nElJN
         KZG9p55HzJiGKmTGR0UJK0nLtvjnIhlbxWsa9owbdDBy+Mg2HCCwlEtvZENdCLWWY+Yq
         sMOg==
X-Gm-Message-State: AOAM5309+X6hC7YkYdgB+uuVv8WwHnD62nJIUC1GQckjrNTlxoMZvTCR
        J4KZCeIQdGWFcOvb2PD0QsFtN7fZ1jM=
X-Google-Smtp-Source: ABdhPJx2a9hZ0x06sdOx3SDxsTfmhIlR9rYS5MjQmw8Yp7iiAPp+QLiNzM5v4AQkH9sfHtf1TnU98g==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr8814127wmq.148.1636120777042;
        Fri, 05 Nov 2021 06:59:37 -0700 (PDT)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id z14sm8305992wrp.70.2021.11.05.06.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 06:59:36 -0700 (PDT)
Message-ID: <11215b43-cd3f-6cdc-36da-44636ca11f51@gmail.com>
Date:   Fri, 5 Nov 2021 13:59:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 5/5] tcp/md5: Make more generic tcp_sig_pool
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <dima@arista.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20211105014953.972946-1-dima@arista.com>
 <20211105014953.972946-6-dima@arista.com>
 <88edb8ff-532e-5662-cda7-c00904c612b4@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <88edb8ff-532e-5662-cda7-c00904c612b4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 09:54, Leonard Crestez wrote:
> On 11/5/21 3:49 AM, Dmitry Safonov wrote:
>> Convert tcp_md5sig_pool to more generic tcp_sig_pool.
>> Now tcp_sig_pool_alloc(const char *alg) can be used to allocate per-cpu
>> ahash request for different hashing algorithms besides md5.
>> tcp_sig_pool_get() and tcp_sig_pool_put() should be used to get
>> ahash_request and scratch area.
> 
> This pool pattern is a workaround for crypto-api only being able to
> allocate transforms from user context.
>> It would be useful for this "one-transform-per-cpu" object to be part of
> crypto api itself, there is nothing TCP-specific here other than the
> size of scratch buffer.

Agree, it would be nice to have something like this as a part of crypto.
The intention here is to reuse md5 sig pool, rather than introduce
another similar one.

>> Make tcp_sig_pool reusable for TCP Authentication Option support
>> (TCP-AO, RFC5925), where RFC5926[1] requires HMAC-SHA1 and AES-128_CMAC
>> hashing at least.
> Additional work would be required to support options of arbitrary size
> and I don't think anyone would use non-standard crypto algorithms.
> 
> Is RFC5926 conformance really insufficient?

For the resulting hash, the scratch buffer can be used.

Honestly, I just don't see much benefit in introducing more code and
structures in order to limit hash algorithms. If anything,

:if (strcmp("hmac(sha1)", opts.algo) && strcmp("cmac(aes)", opts.algo))
:       return -EPROTONOSUPPORT;

and passing the string straight to crypto seems to be better than adding
new structures.

On the other side, those two hashes MUST be supported to comply with
RFC, other may. As user can already configure conflicting receive/send
ids for MKTs, I don't see a point not allowing any hash algorithm
supported by crypto.

> My knowledge of cryptography doesn't go much beyond "data goes in
> signature goes out" but there are many recent arguments from that cipher
> agility is outright harmful and recent protocols like WireGuard don't
> support any algorithm choices.

You already limit usage when root-enabled sysctl is triggered, I don't
see big concerns here.

> 
>> +#define TCP_SIG_POOL_MAX        8
>> +static struct tcp_sig_pool_priv_t {
>> +    struct tcp_sig_crypto        cryptos[TCP_SIG_POOL_MAX];
>> +    unsigned int            cryptos_nr;
>> +} tcp_sig_pool_priv = {
>> +    .cryptos_nr = 1,
>> +    .cryptos[TCP_MD5_SIG_ID].alg = "md5",
>> +};
> 
> Why an array of 8? Better to use an arbitrary list.

Some reasonable limit, may be 16 or whatever in order to avoid
dynamically (re-)allocating the array and keeping O(1) lookups.

Thanks,
          Dmitry
