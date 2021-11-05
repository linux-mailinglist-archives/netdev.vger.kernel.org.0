Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677284461A8
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 10:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhKEJ4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 05:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhKEJ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 05:56:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CA3C061714;
        Fri,  5 Nov 2021 02:54:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c8so14399054ede.13;
        Fri, 05 Nov 2021 02:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DuiEAv4X8nRbsvh0TZ76A3H9pHWEyuQ0bqy+epxl76w=;
        b=We/W8/ZwmW6KJVN5yi8xuNZi7QCwaeCftdWuWWAR/vV3xMPtMYkzFJTXso470Bzjbn
         IwhSwQEz4cswX8a+4rk8XlgGnwiiSmu5Vs1qiiVY5Le0qpd9jBzs5J5N32K6W+VEvrG5
         J+02lX0aCdB82U3TnGMTTXY2Y7GYPFnsMmDB7B+WDpMR9Z7vmwVFCsTzro/assNPWaJ4
         4CTk0vFS0prH562T+t6ibiYjYN4ahuqQNkeHUOAc7D63pJgNJ2AiYpV+4NNfHAAXXW3V
         iLKyndc/IjZbY5z8oEliNcGtG9B60l1xpOgSAIBjb2GEzvOn1VX6LZd1c97HFICr0gNv
         lFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DuiEAv4X8nRbsvh0TZ76A3H9pHWEyuQ0bqy+epxl76w=;
        b=hU8VM0Zg71zqxWQghqEbvayddG72ObQIz5ksJfw85prFA053Y78WvMXkl+XeVG9ktr
         srvszucz6jjHaKGYnkxAnUlTDaRb/wo/bEBlKJAXk+johcKGy+V8GPenOyUjwvUTQ3/J
         YQGSl+kG72himveBGRaj90R63grq5peoi0QZnmu1nG/jhUjnAIKzEDAb6+9RtJ2Qgzqz
         RVtBuSMK+1ofAS6KTHWm0h69N8HCLtYtQE/VorUuQJBXSIyJ2k/jt3WBVICgSOBl5EfC
         gDVpJtJpY4W6yKHwfOu8nuTWULj+jRwp1RY9VvOUYZaTVlOkxRpUSpYfCbIsloU4OFvv
         UmsQ==
X-Gm-Message-State: AOAM531ytN8+/xSa6J4bF+/qP0dWy1PkDOB2dEWrG0Z2LPFXR7gMNQvO
        IaEmhLR/yTs7V/kuyRWnXm0BcZFk4gu/HA==
X-Google-Smtp-Source: ABdhPJzxAQA4oTPZ0kTrV59usVLSC0mfI0frSSPQlkuxiDVCm7buQEtr1KQolS/oUoQuZgL+j0Ff7w==
X-Received: by 2002:a05:6402:4246:: with SMTP id g6mr40694394edb.112.1636106044469;
        Fri, 05 Nov 2021 02:54:04 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:9439:4202:183c:5296? ([2a04:241e:501:3870:9439:4202:183c:5296])
        by smtp.gmail.com with ESMTPSA id g21sm4286121edw.86.2021.11.05.02.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 02:54:04 -0700 (PDT)
Subject: Re: [PATCH 5/5] tcp/md5: Make more generic tcp_sig_pool
To:     Dmitry Safonov <dima@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211105014953.972946-1-dima@arista.com>
 <20211105014953.972946-6-dima@arista.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <88edb8ff-532e-5662-cda7-c00904c612b4@gmail.com>
Date:   Fri, 5 Nov 2021 11:54:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211105014953.972946-6-dima@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 3:49 AM, Dmitry Safonov wrote:
> Convert tcp_md5sig_pool to more generic tcp_sig_pool.
> Now tcp_sig_pool_alloc(const char *alg) can be used to allocate per-cpu
> ahash request for different hashing algorithms besides md5.
> tcp_sig_pool_get() and tcp_sig_pool_put() should be used to get
> ahash_request and scratch area.

This pool pattern is a workaround for crypto-api only being able to 
allocate transforms from user context.

It would be useful for this "one-transform-per-cpu" object to be part of 
crypto api itself, there is nothing TCP-specific here other than the 
size of scratch buffer.

> Make tcp_sig_pool reusable for TCP Authentication Option support
> (TCP-AO, RFC5925), where RFC5926[1] requires HMAC-SHA1 and AES-128_CMAC
> hashing at least.
Additional work would be required to support options of arbitrary size 
and I don't think anyone would use non-standard crypto algorithms.

Is RFC5926 conformance really insufficient?

My knowledge of cryptography doesn't go much beyond "data goes in 
signature goes out" but there are many recent arguments from that cipher 
agility is outright harmful and recent protocols like WireGuard don't 
support any algorithm choices.

> +#define TCP_SIG_POOL_MAX		8
> +static struct tcp_sig_pool_priv_t {
> +	struct tcp_sig_crypto		cryptos[TCP_SIG_POOL_MAX];
> +	unsigned int			cryptos_nr;
> +} tcp_sig_pool_priv = {
> +	.cryptos_nr = 1,
> +	.cryptos[TCP_MD5_SIG_ID].alg = "md5",
> +};

Why an array of 8? Better to use an arbitrary list.

--
Regards,
Leonard
