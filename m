Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1553B1837
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 12:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhFWKuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 06:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhFWKuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 06:50:08 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AFDC061574;
        Wed, 23 Jun 2021 03:47:49 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i94so2110185wri.4;
        Wed, 23 Jun 2021 03:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LE5pkpuyz9/1h7qLqpB53JJHQ0x6Y6WcvDGHdI2kzOg=;
        b=u8nqXqfVHkqh5TPyFHVDMBF023CUywpxEqR/AJkxVmUM68KUWP0uj1Dx8jOG7J+N8k
         HKKDA5NeetCAu906VH9CxemU8YiABrNjYUJzlS0dPBp92Tw8TBCypwpkrSO3xGaubFJH
         iqa4O8f/9beayO5LePK8DDzYLNnY4+XGI0KmdBuPmZrtcHxK+nNtxe9iuPIlwAhcu3vN
         J3fOpMzK+rMIZKPruXplKqLljO7YFtuNnGUJU338EaQrnSHgzYkWeiEoAjl3bncUeg6I
         BUqW9d8y2iLhXRW1nLMLCz8UW4OcFMZkdQ/oLhcp2N/eclA12pu8NZyWPrdMMkjVpPJI
         nrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LE5pkpuyz9/1h7qLqpB53JJHQ0x6Y6WcvDGHdI2kzOg=;
        b=fq9mqnplr4NQV09qXudq9f5zzPHD8kJ5B/8zrFCnQBA33VqNraelrj19WvPcqbBmna
         OWRfOR362EJotwzGvxfTO59+0cMG7IsC+j1ae8A6TaUTgWRuRtN8AvE5Nl+UXUBrymfl
         f1hywvecvXImMXqEUdwNi+dz1ufBN4Y6xmQvw4aCXA45QGrrKjTKAczpRSq5DX9gLzMv
         eFfmIY+GXq2lKN3/yFoCY/CUwpC+HMqqqJgS6rqwDTFvEuVPjaG6o+Y0MD6dNdZO9B2T
         evK4gl4+6AmKmOcDTDFihnUsR6dl80T2W48wCTleGqMb3HjvzqJr82urDbq73IMUarcu
         DgSA==
X-Gm-Message-State: AOAM532cL9rtNdlP8hNrBhXrEpXa4cJba1ENExTNcn5k5MsgeB0lNtEr
        pjY0x5tF5jVd5fRnBee1e44=
X-Google-Smtp-Source: ABdhPJwvBnsHy7N09i2wQUkJQQDc00KUiN8apisB+3XDRsvpUdsof8vTMVrB0F4s4A/MHMwvLFmytw==
X-Received: by 2002:a5d:548a:: with SMTP id h10mr10779502wrv.234.1624445268454;
        Wed, 23 Jun 2021 03:47:48 -0700 (PDT)
Received: from [192.168.98.98] (8.249.23.93.rev.sfr.net. [93.23.249.8])
        by smtp.gmail.com with ESMTPSA id b11sm2512141wrf.43.2021.06.23.03.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 03:47:47 -0700 (PDT)
Subject: Re: [PATCH] decnet: af_decnet: pmc should not be referenced when it's
 NULL
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
References: <20210623033540.27552-1-13145886936@163.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f9cfcede-2684-8723-4979-c0534d711483@gmail.com>
Date:   Wed, 23 Jun 2021 12:47:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210623033540.27552-1-13145886936@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 5:35 AM, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> pmc should not be referenced when it's NULL.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/decnet/af_decnet.c | 67 ++++++++++++++++--------------------------
>  1 file changed, 25 insertions(+), 42 deletions(-)
> 
> diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
> index 5dbd45dc35ad..be2758ac40cb 100644
> --- a/net/decnet/af_decnet.c
> +++ b/net/decnet/af_decnet.c
> @@ -152,7 +152,8 @@ static atomic_long_t decnet_memory_allocated;
>  
>  static int __dn_setsockopt(struct socket *sock, int level, int optname,
>  		sockptr_t optval, unsigned int optlen, int flags);
> -static int __dn_getsockopt(struct socket *sock, int level, int optname, char __user *optval, int __user *optlen, int flags);
> +static int __dn_getsockopt(struct socket *sock, int level, int optname,
> +		char __user *optval, int __user *optlen, int flags);
>  
>  static struct hlist_head *dn_find_list(struct sock *sk)
>  {
> @@ -176,6 +177,7 @@ static int check_port(__le16 port)
>  
>  	sk_for_each(sk, &dn_sk_hash[le16_to_cpu(port) & DN_SK_HASH_MASK]) {
>  		struct dn_scp *scp = DN_SK(sk);
> +
>  		if (scp->addrloc == port)
>  			return -1;
>

Please do not add noise to your patch.

Never mix cleanups and a fix.

Also, decnet is no longer used, please do not send space cleanups.

