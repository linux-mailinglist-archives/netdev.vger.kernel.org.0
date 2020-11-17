Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C42D2B6AA6
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgKQQrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgKQQro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:47:44 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D7FC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 08:47:43 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id s24so21799132ioj.13
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 08:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v6SwFN3Sgm10Mx1vV1xFIQRnKZAFPvVDNoxilkxHVuA=;
        b=d5Cb3OtFLghDkcjJWyKso1Zss2mynJ/WaZRKqGZHQIojByi2OAkxI9YArKpSJfcWYv
         rq+FCqBYytEwTk6H+J4Ds3/jEEr8+rxAxbAaKWSvnHdezbwqoHX2RlnjijAVIgzOf4iN
         lKr0BJ5fc/YFcBJctXZ72VS1UQPtR4DHlQuXj1imN1KUiXHVEaaTtME67OF1KE4KV8jP
         7OhtqHHcV7mMjM37bUpLpLmS5ubpZWM3OAu0/ApwE7Wl6P6XLUv8SjFW7jxxNSpjFJl9
         50Jqegx7Sz2UKkbtHdNjOUtVVbwyWWreV/omZJ6zGxQaMiGY7Syyv/m9R5F0CZR27xuq
         FFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v6SwFN3Sgm10Mx1vV1xFIQRnKZAFPvVDNoxilkxHVuA=;
        b=Wwiq3caCmRIXrIUNb9rU8PkVmjk/VaEvO+Ag17VcDJe4wDx9RDVkW0iD9QykL9xASY
         tG9A/jvDXS/i2Xg/uYeuXeOXJz2RyJQyz0OVbVIPk0n1egjZ61AY/IaJ/DU74pPDK4j+
         5WWg8A3gZyVNtq8SjGAX9ONv63Qjxiu3CwAyTLxc8nDMgNABOTY0VFjHDmIZNi2QcuXr
         vV6Bfx+UDQqqaCSZ1/YaiaQc74ujMxqCOPk6tBAexlt3K1vfsOWR7oMgy8N270OyaRH6
         oZlPag8dpOq4o9S1ql+V1yMhtr2h5ThTy0D46y0V9TSx4G0eR1nFYLGW96lioOpYM9ZB
         auHA==
X-Gm-Message-State: AOAM530oawNkPlpLGHoSGL6wnQq8wO77oiWo2oseF0pc6c889S9ieq7u
        wuaUJ9i0cWxAgqWR5nv0iHJMSwwrGEw=
X-Google-Smtp-Source: ABdhPJwz5Pfr5Z8NA3SgxRwVerH2wzKB0GxQB2dJeNFSMmUAk7oKvjpMSCBHwtRGd7XzukfY5DUyOA==
X-Received: by 2002:a5d:9d16:: with SMTP id j22mr12270198ioj.172.1605631662526;
        Tue, 17 Nov 2020 08:47:42 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:c472:ae53:db1e:5dd0])
        by smtp.googlemail.com with ESMTPSA id c89sm14120252ilf.26.2020.11.17.08.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 08:47:41 -0800 (PST)
Subject: Re: [PATCH v2] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
To:     Oliver Herms <oliver.peter.herms@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20201117091938.GA562664@tws>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1a9d419d-0299-d043-c977-1abc95d221cf@gmail.com>
Date:   Tue, 17 Nov 2020 09:47:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117091938.GA562664@tws>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 2:19 AM, Oliver Herms wrote:
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
> index 82cbb46a2a4f..d7e94eac3136 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5489,6 +5489,10 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
>  	rtm->rtm_scope = RT_SCOPE_UNIVERSE;
>  	rtm->rtm_protocol = rt->fib6_protocol;
>  
> +	if (dst && dst->lwtstate && lwtunnel_fill_encap(skb, dst->lwtstate,
> +	    RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
> +		goto nla_put_failure;
> +
>  	if (rt6_flags & RTF_CACHE)
>  		rtm->rtm_flags |= RTM_F_CLONED;
>  
> 

That needs to be moved down to this section:

       if (rt6) {
                if (rt6_flags & RTF_GATEWAY &&
                    nla_put_in6_addr(skb, RTA_GATEWAY, &rt6->rt6i_gateway))
                        goto nla_put_failure;

                if (dst->dev && nla_put_u32(skb, RTA_OIF,
dst->dev->ifindex))
                        goto nla_put_failure;

   --> add ENCAP here


