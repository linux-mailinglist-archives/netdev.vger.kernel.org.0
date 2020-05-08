Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACCC1CB1E7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgEHOjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgEHOjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:39:14 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44D4C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 07:39:13 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b6so626103qkh.11
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 07:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZV9GHUrBu60ikyhaeZg+ZmOXTFO1JNkkIi0hpM0OLRQ=;
        b=dpqyYIoA+P7qcV1suxOvx2cawEp4ti666dxqbrcpS+OfXFu7faMVN1ZaXHJNuJyNyt
         ycYrG6cKC6mnxSCFpQw2/nqrYVdOgPFCQp6QE/Zfl1f+eHeVdIf4MY1FlAyV55XTdWdw
         xl3pZKiw6w9MS8a9vgD2kHCwSQWMdxOEDny99qakAn20XTT5+9YDz2209/Wjcnd87VoN
         IvdcKaWgN/HlG4EYL4J9xvlh8YWe8W1vibUjxuNzQEWwRUuhFZFuyOS2JNC/0dm+epV9
         2ZpSU8dK+wj31ciahh/pYfuYCLBKZLgMn6IWFcFHgu8lcRLWOc6+r730ubrv57jO7liv
         hMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZV9GHUrBu60ikyhaeZg+ZmOXTFO1JNkkIi0hpM0OLRQ=;
        b=HsAcY2BTm0qcBFdeStDz3eQngLoxzyZV85U2X218NUrvQNM5evDF+2vHVN0hlvoNOG
         7hmmxVxvqSSsAo0QUhwit5ve6zhWYoIpihgdW3+DHeEtRIy9bj3i1/SgXqbP6eh0biYM
         D/7aEenC+qNqWqT5bjwYSbpzJcuZ1RhBr3EbDnRiCYFpk0aEdnvKvw+dlMIp5jsjjVBR
         oE3eg+h1KZ9mdO69N8YwdI0pn8JLqrKJYjY5lD61X0iBv28g95/FhEwEQ1IZNOyK76/F
         ihQUsAz9ef2EYfJidFM6KD51/yrnJOIH+rADLLltqVn0fd4ri9tlQc4OqFozLvCtG8p8
         2Tlg==
X-Gm-Message-State: AGi0PuZH1L+AQNh0dS5H2BDfiLNgfFa/eDanyHCqVCqgNtqtFWveOMSN
        AFLcY3HqwVbXDe5veIO+rIw=
X-Google-Smtp-Source: APiQypJ3Clv81PnMb4RTxt9Tqsvvo/enyweaXZXQkPfGLHFm01Vv+HxIbBhad3P+IUmvfGfd+EyfLg==
X-Received: by 2002:a37:27d8:: with SMTP id n207mr3231083qkn.40.1588948753163;
        Fri, 08 May 2020 07:39:13 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c09e:cbdc:b4a2:7243? ([2601:282:803:7700:c09e:cbdc:b4a2:7243])
        by smtp.googlemail.com with ESMTPSA id t67sm1304639qka.17.2020.05.08.07.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 07:39:12 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
References: <20200508143414.42022-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <362c2030-6e7f-512d-4285-d904b4a433b6@gmail.com>
Date:   Fri, 8 May 2020 08:39:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508143414.42022-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 8:34 AM, Eric Dumazet wrote:
> We currently have to adjust ipv6 route gc_thresh/max_size depending
> on number of cpus on a server, this makes very little sense.
> 
> If the kernels sets /proc/sys/net/ipv6/route/gc_thresh to 1024
> and /proc/sys/net/ipv6/route/max_size to 4096, then we better
> not track the percpu dst that our implementation uses.
> 
> Only routes not added (directly or indirectly) by the admin
> should be tracked and limited.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Maciej Żenczykowski <maze@google.com>
> ---
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index a9072dba00f4fb0b61bce1fc0f44a3a81ba702fa..4292653af533bb641ae8571fffe45b39327d0380 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1377,7 +1377,7 @@ static struct rt6_info *ip6_rt_pcpu_alloc(const struct fib6_result *res)
>  
>  	rcu_read_lock();
>  	dev = ip6_rt_get_dev_rcu(res);
> -	pcpu_rt = ip6_dst_alloc(dev_net(dev), dev, flags);
> +	pcpu_rt = ip6_dst_alloc(dev_net(dev), dev, flags | DST_NOCOUNT);
>  	rcu_read_unlock();
>  	if (!pcpu_rt) {
>  		fib6_info_release(f6i);
> 

At this point in IPv6's evolution it seems like it can align more with
IPv4 and just get rid of the dst limits completely.
