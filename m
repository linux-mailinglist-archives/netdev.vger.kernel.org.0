Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E4039E416
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhFGQbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:31:03 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:38768 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbhFGQ3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 12:29:09 -0400
Received: by mail-oi1-f174.google.com with SMTP id z3so18641505oib.5;
        Mon, 07 Jun 2021 09:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9ZqdoOGM6WNxBQ2zegFXX/sQze7k1gjalJLlzwIinkI=;
        b=PnBKUyerdBk1FlTaZPiNuRVFXdluPnzQkKTaLVAgoTKj34JELhdQiLmIGO1c7CdFqF
         Y40dEJNCrzC0SUWhr5ndiynmXRfxCSQh+4okoL0CWxgkzkcpT6tbp5zztxO5C6rw38Qa
         QJDW+O+49yCwpPpvqIXor+5eHPBOuo0VIjhXyMJeC6cqCz3dHNVgZTUUB+srFo1NHa3M
         XWqTD9xueFiJxsKMsevlD5Wg/eNUrB6HqAWRszlb+06Q2u7Hty3LQIjMw+mF1dG6z5K2
         TzSe51YS39bcEObKcyk5ptOV4sSBA0EBHAT5ubxY2xwZdqnrSM8ZtmzlZk0AvGPTS0nh
         IMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9ZqdoOGM6WNxBQ2zegFXX/sQze7k1gjalJLlzwIinkI=;
        b=MKM/kLl8YSZXnh2fMH0u37ie38Y+qKtwsfZdwVnrzgVo9q7LdA3yQa545W4ls035yr
         zaypb2q/SedcgGi++15w7Y6pC9zpCFfAY/E2hq7Khs5WQgjD4QLtt91qtO0i9aoGmFMT
         KPMu2T40DtTA42PWhe4Iv5AKcL0vjGToCqV9JJPlQpeAnVcjKQ8tC8Jw6eru86ed4gt5
         ZjlcfCwofW3hZiCz/XLZV5xvsAEnXswOSvpwZxnGaHhYVsi9mUyIOKDSsh1XPsOyoqrL
         0W5BznRaMU6jIMnUTAuaO/QkbN49b3BgZmJO9qDY3fm0BiE1iXXLi2rZPuau0hd0S/+w
         yQUg==
X-Gm-Message-State: AOAM533toPa8AJmlTklzMjtfjzv5NI5h+LhgOdHviuEmlwj0sSnidqzF
        p31eDWDLEhDuaD5vfuvhLkgu7r6iliA=
X-Google-Smtp-Source: ABdhPJx1z5z9KChS1eqfEXcgia7lez0Q1mRQ1ai05P/UsqFgCKpX3N8JAsxRmE4jIQ5cI5JaO3k0NA==
X-Received: by 2002:aca:47c5:: with SMTP id u188mr44981oia.174.1623083177503;
        Mon, 07 Jun 2021 09:26:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id l2sm1310633otn.32.2021.06.07.09.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 09:26:16 -0700 (PDT)
Subject: Re: [PATCH] ping: Check return value of function 'ping_queue_rcv_skb'
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210607091058.2766648-1-zhengyongjun3@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1c31a9fa-6322-cebb-c78c-189c905eaf86@gmail.com>
Date:   Mon, 7 Jun 2021 10:26:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607091058.2766648-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 3:10 AM, Zheng Yongjun wrote:
> Function 'ping_queue_rcv_skb' not always return success, which will
> also return fail. If not check the wrong return value of it, lead to function
> `ping_rcv` return success.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ipv4/ping.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 1c9f71a37258..8e84cde95011 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -968,10 +968,11 @@ bool ping_rcv(struct sk_buff *skb)
>  		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
>  
>  		pr_debug("rcv on socket %p\n", sk);
> -		if (skb2)
> -			ping_queue_rcv_skb(sk, skb2);
> +		if (skb2 && !ping_queue_rcv_skb(sk, skb2)) {
> +			sock_put(sk);
> +			return true;
> +		}
>  		sock_put(sk);
> -		return true;
>  	}
>  	pr_debug("no socket, dropping\n");
>  
> 

declare a default return variable:

	bool rc = false;

set to to true if ping_queue_rcv_skb() fails and have one exit path with
one sock_put.
