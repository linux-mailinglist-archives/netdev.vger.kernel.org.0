Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713B03B8BCD
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 03:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbhGABmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 21:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbhGABmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 21:42:39 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9D9C061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 18:40:09 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id c12-20020a9d684c0000b029047762db628aso890904oto.13
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 18:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AeII59XfNjxVmYLaimFclVYpr7upSoF/aG4oimEIPjw=;
        b=WzTGtA1eieFCA/uhQNnstVt4PQRMj1iTt3n8oOJ8KiPytm34+hgMrYZWcwlmq4A/b7
         EIkKAUDtSwO7Rkk828uGbpUWTdZiwE3yMDGMBVyTWgJztY9Kty38bgnpQRh+taRUA9GI
         Pk8j+slUjpeN3gcjy2XiveNZFGQEGJVEMrGUfqUgL4ejk8xbgyVvNWWl02xMQsMJ8P3X
         nV6AHOmDL4wacbPwB2FI7KIjJ2on+BpW4gpI8bgSWZzIAgLVlfoFRAlgm7R2HOturfj1
         ptWO2yTCS2BQgINR0dvit+FwA4A1ZAymDRtNZmicfXgQSzvZTFYjD3YPCvW6o3AFeTqG
         FURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AeII59XfNjxVmYLaimFclVYpr7upSoF/aG4oimEIPjw=;
        b=os8dDns5rYWepk0Dm1GMMCM5MD2mOo28WekcFJToJkcxIhlKajeVF+19mixPYDcD79
         4BgIMVhlAUuyR+JFE6sYTocfalsgT+9vu/vGGbwNwWLZx8S2il4jz7dc/unmNo0Co23z
         6asfiJqSi7VWMJgeSK169ZNl1m2TDyglyke/4Kv4TyH3/8+HkOLFqIJzyWFZwGXf8hbx
         zFrs65T+8ClI3vw4jFqfr+qxTB6F+LFvABusfQAs4YupGl9LQdve89lyZvYQdRNO5oH4
         rrHosrG4pn+91DfPdyChiGjgty1m+6w0EP7PFMGTmI8fLOGVA7h7jlX95Zg1Ra/edpfo
         wenw==
X-Gm-Message-State: AOAM533y6OckuwgfBpIWL9Djw5prV80dbnxqzlfpJLwzOkx17A+KT6Br
        xK1oMfdZG79Nao4dOu5fQn8=
X-Google-Smtp-Source: ABdhPJwaM5GxUl1KhTwZuKQnmqTgfJ0XNgRow5vMq2/69qS5Za5TWhbFEZLGfYCV72g3PcVV+IlHlQ==
X-Received: by 2002:a9d:6a2:: with SMTP id 31mr11222059otx.265.1625103608623;
        Wed, 30 Jun 2021 18:40:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id t76sm5013512oif.14.2021.06.30.18.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 18:40:08 -0700 (PDT)
Subject: Re: [RFC net-next 2/2] net: ipv4: Consolidate ipv4_mtu and
 ip_dst_mtu_maybe_forward
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20210701011728.22626-1-vfedorenko@novek.ru>
 <20210701011728.22626-3-vfedorenko@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <424dcef7-9d5e-ce3a-d9af-190ffca2a093@gmail.com>
Date:   Wed, 30 Jun 2021 19:40:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701011728.22626-3-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/21 7:17 PM, Vadim Fedorenko wrote:
> Consolidate IPv4 MTU code the same way it is done in IPv6 to have code
> aligned in both address families
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  include/net/ip.h | 22 ++++++++++++++++++----
>  net/ipv4/route.c | 21 +--------------------
>  2 files changed, 19 insertions(+), 24 deletions(-)
> 
> diff --git a/include/net/ip.h b/include/net/ip.h
> index d9683bef8684..ed261f2a40ac 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -436,18 +436,32 @@ static inline bool ip_sk_ignore_df(const struct sock *sk)
>  static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>  						    bool forwarding)
>  {
> +	const struct rtable *rt = (const struct rtable *)dst;

I realize this a code move from ipv4_mtu, but please use container_of
here; I have been removing the typecasts as code is changed.

>  	struct net *net = dev_net(dst->dev);
>  	unsigned int mtu;
>  
>  	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
>  	    ip_mtu_locked(dst) ||
> -	    !forwarding)
> -		return dst_mtu(dst);
> +	    !forwarding) {
> +		mtu = rt->rt_pmtu;
> +		if (mtu && time_before(jiffies, rt->dst.expires))
> +			goto out;
> +	}
>  
>  	/* 'forwarding = true' case should always honour route mtu */
>  	mtu = dst_metric_raw(dst, RTAX_MTU);
> -	if (!mtu)
> -		mtu = min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
> +	if (mtu)
> +		goto out;
> +
> +	mtu = READ_ONCE(dst->dev->mtu);
> +
> +	if (unlikely(ip_mtu_locked(dst))) {
> +		if (rt->rt_uses_gateway && mtu > 576)
> +			mtu = 576;
> +	}
> +
> +out:
> +	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
>  
>  	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
>  }
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 99c06944501a..04754d55b3c1 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1299,26 +1299,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
>  
>  INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
>  {
> -	const struct rtable *rt = (const struct rtable *)dst;
> -	unsigned int mtu = rt->rt_pmtu;
> -
> -	if (!mtu || time_after_eq(jiffies, rt->dst.expires))
> -		mtu = dst_metric_raw(dst, RTAX_MTU);
> -
> -	if (mtu)
> -		goto out;
> -
> -	mtu = READ_ONCE(dst->dev->mtu);
> -
> -	if (unlikely(ip_mtu_locked(dst))) {
> -		if (rt->rt_uses_gateway && mtu > 576)
> -			mtu = 576;
> -	}
> -
> -out:
> -	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
> -
> -	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
> +	return ip_dst_mtu_maybe_forward(dst, false);
>  }
>  EXPORT_INDIRECT_CALLABLE(ipv4_mtu);
>  
> 

