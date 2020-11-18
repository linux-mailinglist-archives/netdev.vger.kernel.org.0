Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C572B856F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgKRUTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRUTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:19:18 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AD9C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:19:18 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id l12so3224468ilo.1
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uOPEYQqYgzbZjinpV0YNcjCY1eMBo6OmLzh2Es0+GSg=;
        b=EAO99yg8Ga+YI2hkFLTfMAnfKy7xY/Voq7kmSJgQFL36T7LB3NxEuk9ZZQ2drrlyEn
         CIQb0UMm6P/sjGl7rBRp+M11s2BjYvCGxiV6kdXUos6IzILuhiB82kMpmH+qDyln6UFf
         5ILUaZfPxS68Qc1HtXyPdNp14swMvxxJ0tAivY7Lg8DNNutABqgQ7/AyVi6rSeoW6CGv
         Plso+RtjOmLazAnufIsTWEIju46v0hb2J0xVlNzOcuHVjCRoIQ0YaSMdXR1L/2p9rxiQ
         olfcePnNxxP9FR5O2QWKwzm9fJjzJRK3rwueIRVMCUGUP6mm92SN74W1yQ06MM/BVgn9
         8A/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uOPEYQqYgzbZjinpV0YNcjCY1eMBo6OmLzh2Es0+GSg=;
        b=EkbihG1T6/BgCV/+lzVZyQsME1BE37rZXSKk2yLRb7kt9hx3qVoUJw5glNXYNrEdqb
         C8w2WUMAUPESTqxDSrJi+xgL7o0fJ5qS4BC/ytcx9LkF2pFKjuEKcYvg82L1P8YUUyQy
         umhLCJQGsocOUcO/7SIVV0JZrUTLuZQiBf9ZMp4CTOHBnIdE9WZSBoyg2oAseOPyOvbZ
         ZoHXSaksvJUDFXXYdSrkvZyzMFkhDwSulU6m9HG0Jnvu7grq8Fo0LoQoGKOlvnqms/NS
         3dAy/rilq00TXM+lhJuLefyw6SknQ/pBUMl4krM//CbAf6dkOab72qltG7ElJ+sRWeKX
         22EQ==
X-Gm-Message-State: AOAM530qvO07vq4FHNIKTiu92V8CqLU1H4G/l6QEC+h9ojxQ2GK7/mbG
        6zk0mltyyB5/rAGyhuNmy0D9RHtfDCc=
X-Google-Smtp-Source: ABdhPJw+oQrO9LSFaI4GzTr+d2YPsqViY3acgscXPE+t6+ST1JkJy3bwpnQMA/LqoXPKxdqL5hf6pg==
X-Received: by 2002:a92:35d7:: with SMTP id c84mr11002486ilf.251.1605730757353;
        Wed, 18 Nov 2020 12:19:17 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:70e6:174c:7aed:1d19])
        by smtp.googlemail.com with ESMTPSA id n21sm2628577ioj.31.2020.11.18.12.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 12:19:16 -0800 (PST)
Subject: Re: [PATCH v3] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
To:     Oliver Herms <oliver.peter.herms@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20201118151436.GA420026@tws>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <75cc0e7b-1922-850f-da22-550c8c90aac6@gmail.com>
Date:   Wed, 18 Nov 2020 13:19:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118151436.GA420026@tws>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 8:14 AM, Oliver Herms wrote:
> This patch adds an IPv6 routes encapsulation attribute
> to the result of netlink RTM_GETROUTE requests
> (i.e. ip route get 2001:db8::).
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv6/route.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 7e0ce7af8234..64bda402357b 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5558,6 +5558,10 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
>  
>  		if (dst->dev && nla_put_u32(skb, RTA_OIF, dst->dev->ifindex))
>  			goto nla_put_failure;
> +
> +		if (dst && dst->lwtstate &&
> +		    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
> +			goto nla_put_failure;
>  	} else if (rt->fib6_nsiblings) {
>  		struct fib6_info *sibling, *next_sibling;
>  		struct nlattr *mp;
> 

You forgot to remove the dst part of that. rt6 == dst so to be in this
branch dst != NULL.

Besides that nit that maybe Jakub will fixup before applying:

Reviewed-by: David Ahern <dsahern@kernel.org>
