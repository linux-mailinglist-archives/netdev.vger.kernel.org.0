Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93A8445D7B
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhKEBsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhKEBsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:48:52 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69978C061714;
        Thu,  4 Nov 2021 18:46:13 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id j128-20020a1c2386000000b003301a98dd62so8507384wmj.5;
        Thu, 04 Nov 2021 18:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2xhc5oWpvO9Tk65WJtzZWw7fGB5wYEtIT3Aaq8xkviA=;
        b=QuAX2YIVdOkDaBevFozERc6N4+YXFCkM0rdD+8v1wsW27UpiEFrzOZLoAZ2zyphUhw
         mdqyTfRTOwmrAFlj42xOjNglqtwz52C4HJzcmZWKo9Pb5vdb6+dIUbPptCxM8yVwQR0f
         ByzrW5CMcEi+FadkLPglRtZAfseBP3mSwYzl4JEWB6DEAj4gaGWIM5phN+LV1uCM44TC
         4u1YMUMENa6aiA46E0VLlgm3mLqDTelZCHZrPrCcdIjlG9Lqax8bFIdyl+glE8o7k7nn
         AspdrCFutJQh5GuT8immG08vNiBllBC1YhOQ2g6nEdBqJwtC7sfQg9mCJSc03jvYz2/2
         5xGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2xhc5oWpvO9Tk65WJtzZWw7fGB5wYEtIT3Aaq8xkviA=;
        b=Kk35vLZeqKPU+sEIbNA6fHTI9kYWG4qCeR1gRQrxG27evNHlJrVoqZeklgOd81YQje
         qUH7+ejG6wyA3ECKcF7pA5r4GBzCnLfLJ0RMRXr4MPMiiVRqYtT0El4ysd1FSg5anv0y
         TVRI8H0D4xo+ZRzgAH3bm5QkBDLOy7+vhdHfKfJ0F4M7jdQXQGV2qEa0ZMQ+v0THi69p
         U92ducPXFeIdMGqidNDzzknVsN6VnIpAUyEmOIoUBWbHmUtVreFHVMH3vAG5qlIAySPB
         qT/98IPNFLbKvIazyY/gs7qD6ZIrF3RnDeIaA5MDv4YU9UHeXj3TGp91jmRvBj0rVBtU
         6XRg==
X-Gm-Message-State: AOAM532L6bNTuYRufGHzORr8LD3cvXWs/MhuyL+a09M6x58fEvqE6D+J
        qtg8YmuOH+0krjrVgInBbVQ=
X-Google-Smtp-Source: ABdhPJzX1mhMIpnvJbqUXJj+GamrvNa9AxYluUoas0Jjrg4lrIURGC3Xng1GrJ3DjAerE++vcN2/zw==
X-Received: by 2002:a1c:a715:: with SMTP id q21mr27297533wme.23.1636076772108;
        Thu, 04 Nov 2021 18:46:12 -0700 (PDT)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id 10sm8240762wrb.75.2021.11.04.18.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 18:46:11 -0700 (PDT)
Message-ID: <cccdd347-57ee-62e5-2824-a3e7e2910395@gmail.com>
Date:   Fri, 5 Nov 2021 01:46:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 09/25] tcp: authopt: Disable via sysctl by default
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <137399b962131c278acbfa5446a3b6d59aa0547b.1635784253.git.cdleonard@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <137399b962131c278acbfa5446a3b6d59aa0547b.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 16:34, Leonard Crestez wrote:
> This is mainly intended to protect against local privilege escalations
> through a rarely used feature so it is deliberately not namespaced.
> 
> Enforcement is only at the setsockopt level, this should be enough to
> ensure that the tcp_authopt_needed static key never turns on.
> 
> No effort is made to handle disabling when the feature is already in
> use.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
[..]
> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
> index 5e80e5e5e36e..7c49dcce7d24 100644
> --- a/net/ipv4/tcp_authopt.c
> +++ b/net/ipv4/tcp_authopt.c
> @@ -3,10 +3,15 @@
>  #include <linux/kernel.h>
>  #include <net/tcp.h>
>  #include <net/tcp_authopt.h>
>  #include <crypto/hash.h>
>  
> +/* This is mainly intended to protect against local privilege escalations through
> + * a rarely used feature so it is deliberately not namespaced.
> + */
> +int sysctl_tcp_authopt;

Could you add pr_warn_once() for setsockopt() without this set, so that
it's visible in dmesg for a user that gets -EPERM.

Thanks,
          Dmitry
