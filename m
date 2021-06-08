Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211EC39EB45
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 03:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhFHBTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 21:19:34 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:39658 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHBTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 21:19:33 -0400
Received: by mail-oi1-f169.google.com with SMTP id m137so16092082oig.6
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 18:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ThlCqxmVdDNxngFv54HuOyJ6SE7XTehPpgb6bhFWygA=;
        b=WAYqdn2v1kaiCefJg1byITBXEzdgRpu/E8X4fPcn2rCZeJSIrb+SdCVXb5ARfWihgo
         R2s/HsllC3AsckCaIR+AWltwMDVYBukAG3VNBhg6juyahboX8Le/kgThGBSKUaZZb8eE
         deXg0KAMG1aFrQa3p+SlWdvAuRIyTGeBl8KfCUSAyP5VWuxJecFcR/3NGeAfvA5qC9DM
         MvtZb2Q8fJlPGZQ32j2cuxF4O5si4k8mQoIVQIgt5dXS/FzuLU9TVYzx6Qqd2/PpMpo2
         d05TdWyZ6Go98DGcpu+F3XsZCBSH6Ba3M7PT8fP7auhZscHMEdtyTk+oYbqrgBO/Rtt9
         EPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ThlCqxmVdDNxngFv54HuOyJ6SE7XTehPpgb6bhFWygA=;
        b=INb4OmJ9fslr8V6qBKfSHqZng/rBu+x2peK3GEF1bAbE/vx3TFuzaTBTL4o2A2rypQ
         H2EMH4KlKdv9rOQrn4MWJh7G8v22i+U/KXXTdBwytPlP7AdsE99mzaPZAhUhv+Oc0PMO
         aRnxgZJeEo7Hcp8ajVK3nkVeYvgMxme1o/veDNwR9x+iIZPn9beEhQn8nSW8Ahk11Qyo
         9QIvSg/WeNb/geQQsWOmOFcjfn3Aq9NamkdR0TMPrchzk1SemZa3IiR9mf+lPWS9UAhR
         d89F3xxtj86gKPNxFuitO3yXqeyTgFzZAlkcz6hfvF9RybqKIxilguq3jL6er8kS7uov
         wwJw==
X-Gm-Message-State: AOAM5321TwMDUWUzETMWVZ4cNdX92auQ6MMim9ZC+y3i8Xr+GwMhIuYb
        rVPurJpr8RLNv6JZZ5sZL1e72eUY52Y=
X-Google-Smtp-Source: ABdhPJxjS4kNgdGZLwqvGIueA8pqEAvcXbDyykLsJhUb30+F4V1ObEmGdsR8MSXolEM63aKrycqVTA==
X-Received: by 2002:aca:3904:: with SMTP id g4mr1158346oia.129.1623114987937;
        Mon, 07 Jun 2021 18:16:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id v22sm2579274oic.37.2021.06.07.18.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 18:16:27 -0700 (PDT)
Subject: Re: [PATCH] ipv6: ensure ip6_dst_mtu_forward() returns at least
 IPV6_MIN_MTU
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210607234307.3375806-1-zenczykowski@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0b6324f8-f49b-3d69-f792-81acf4fb2ec5@gmail.com>
Date:   Mon, 7 Jun 2021 19:16:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607234307.3375806-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 5:43 PM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> ip6_dst_mtu_forward() has just two call sites, one of which already
> enforces the minimum mtu (which we can now remove), but it does
> materially affect the other (presumably buggy) call site in:
>   net/netfilter/nf_flow_table_core.c
>   flow_offload_fill_route()
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  include/net/ip6_route.h | 4 ++--
>  net/ipv6/ip6_output.c   | 2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 9dd3c75a4d62..e01364c0821d 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -315,14 +315,14 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
>  	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);

we can prevent a route getting an mtu as a metric that is < IPV6_MIN_MTU.

>  
>  	if (mtu)
> -		return mtu;
> +		return max_t(unsigned int, mtu, IPV6_MIN_MTU);
>  
>  	rcu_read_lock();
>  	idev = __in6_dev_get(dst->dev);
>  	mtu = idev ? idev->cnf.mtu6 : IPV6_MIN_MTU;

and we can prevent cnf.mtu6 getting set < IPV6_MIN_MTU:

addrconf_notify(), NETDEV_CHANGEMTU case.
ipv6_add_dev() already requires dev->mtu to be > IPV6_MIN_MTU
ndisc_router_discovery requires it.

so it seems implausible for the idev to get a value below the minimum.

the metric is less clear that it is checked, so it would be the one to
make sure is meeting expectations.
