Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6574CE6A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbfFTNQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:16:01 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38236 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfFTNQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:16:01 -0400
Received: by mail-io1-f67.google.com with SMTP id j6so1501407ioa.5
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 06:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I/O/yyALdCbsqKYK1a9DcWSXjStvVGaq6qBlcx4Muio=;
        b=MHywfs/nm337cGrusxf5U3yNCrkYeYHqQE4P7Mk/QviPsIvQ9lF6G6c6WwGzIXcaxG
         YCO0WWMxJn5tc9vMF5+rze4LBUZfKt++0+H82YSbHq6RkyRtIlkrs9/385LkzvSwXvqd
         EM0wflKKoY0tUckmUC0ypLyjQPF69aJHE2NLVYZewvQKeKCcGEMJt8PUodMGv7deGx8Q
         XDiuyYdYvJ2scWzWOEQOsP3lflrrQrLz3IaEYgPsvfPBWNVHkUZSnFsquiFfGjZTG4//
         u0+GqyFDS482GoVwf+wadrH2Bwa8xA9bQal6Z2TbXmxUn7wEKSgmDE3WmJI8b9mOU7kn
         VVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I/O/yyALdCbsqKYK1a9DcWSXjStvVGaq6qBlcx4Muio=;
        b=HcJdQJZnC+0fe0HUR6GKepJQmJK3zC8EE2alXCdYZnuaPYCpeLes9OA/u2JyeLEmGH
         YPmlF39p9LOibphOH8lBSuoxlCGMxZxM2iwHpmOAmia0OHLl6usezGojTdFp9nCVAX9K
         eFVtGFFg0ZSgR9H3F24EjGsjGqPVZ9h5jmzHuKAHLWGMVQ81aOphddegJb6AF/zwFhf7
         40yUfKY+10/jCSsptEHC1eP07C+b2Xya3VJK+DuuDjzQP0nQlSyUSjG7/QslcTvqnl0M
         vdxEG7t+E5Js8undVLBsg740JEZFdcdeIREhExv9IHrC3Y0ddsLvyDmjoaqOiccomiBt
         uS+A==
X-Gm-Message-State: APjAAAW1mS/luZdZBEcZKOUbb/WiGIpPtugPfIV4k45CUrgTZ7OGNwhU
        hN9owI2Yk56sTEE2WYgQvcNcrHfD
X-Google-Smtp-Source: APXvYqz5J/lZEYG/XPpmfxWel9m4wHFO3LAUXFNEWKhxXtRv+33Z5q/ZkJVQM015C9kQiU4vxK91zA==
X-Received: by 2002:a5e:8306:: with SMTP id x6mr18966659iom.130.1561036560428;
        Thu, 20 Jun 2019 06:16:00 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id c1sm16596573ioc.43.2019.06.20.06.15.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 06:15:59 -0700 (PDT)
Subject: Re: [PATCH net-next v6 03/11] ipv4/route: Allow NULL flowinfo in
 rt_fill_info()
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560987611.git.sbrivio@redhat.com>
 <5ba00822d7e86cdcb9231b39fda3cc4a04e2836f.1560987611.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9efa65d3-5797-fde0-d5c2-3c7747d591ad@gmail.com>
Date:   Thu, 20 Jun 2019 07:15:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <5ba00822d7e86cdcb9231b39fda3cc4a04e2836f.1560987611.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 5:59 PM, Stefano Brivio wrote:
> In the next patch, we're going to use rt_fill_info() to dump exception
> routes upon RTM_GETROUTE with NLM_F_ROOT, meaning userspace is requesting
> a dump and not a specific route selection, which in turn implies the input
> interface is not relevant. Update rt_fill_info() to handle a NULL
> flowinfo.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> v6: New patch
> 
>  net/ipv4/route.c | 57 ++++++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 26 deletions(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 66cbe8a7a168..052a80373b1d 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2699,7 +2699,8 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
>  	r->rtm_family	 = AF_INET;
>  	r->rtm_dst_len	= 32;
>  	r->rtm_src_len	= 0;
> -	r->rtm_tos	= fl4->flowi4_tos;
> +	if (fl4)
> +		r->rtm_tos	= fl4->flowi4_tos;

tracing back to the alloc_skb it does not appear to be initialized to 0,
so this should be:
	r->rtm_tos	= fl4 ? fl4->flowi4_tos : 0;


other than that it looks fine to me.

Reviewed-by: David Ahern <dsahern@gmail.com>
