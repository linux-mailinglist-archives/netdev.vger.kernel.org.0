Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9864A4C3F7
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 01:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfFSXMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 19:12:35 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33659 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSXMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 19:12:35 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so2056iop.0
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 16:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+XwKAUeONwY7DBzBV5fzvSFaOxAOXMGxMY8BNo+fkbs=;
        b=kCKQB5Ysb1Nwh/qFjqz2JYzGSx1rZ2eZvenPOgcsnmTZL9nxLmSOVWJ/S1/i3NrZbl
         ECEXAfgc96sGLfxnnVgM9bEbLkTrogtANv1xBev1IQaoZIpxKtkUzsWeaF89ek4A2Ku6
         6DOSXPOkrjocNyvJFmTDVwFyaLuO8ifcSBaXUzKINBVa5qk2he+8AmfVrCMFgW1nxr7I
         sL4d0miqTsJ0vIrqL53xWvtbaknRBmCH0eqGCBQ9qWBJReQvQaqvYvRCQLjEvTbG+KCX
         rCb8K50uG5X6QbY5MvKg/Fx4NMR4yMny/ExO65+lxcCXxJb0ABMb0gQ2PuGVfBcUtaUM
         UHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+XwKAUeONwY7DBzBV5fzvSFaOxAOXMGxMY8BNo+fkbs=;
        b=SzCQtwis4kOX+I8e3mIATzQfJWffhZJwTa9n3YTwmUEHcEpdjefhJNkYA9JEwqmwu5
         Pj5ZqNxByjPjn8z9wSCIqjrj5hhPOsY+kssl1h0r69tMej5/GcvFjK/eRIeZnLQM7669
         X+F5dE/+pQP+NIdFpWeR9w/Pjs604u0ZL5xoM52aPpdD+Yl3oKGG9sYMGNcryqntuUo2
         Xjm60W/S7PSDE54QlszCv3GSOFQWOS2vhMwnw1ci7ELGjM4rAve3TKa8nLTen3qu9bT9
         HpztPiITlucTZeExqGxnLHS+h36hqqV8pFasI8sz2+emksfZmEIlxSf1V0NRy1BpJX3L
         kMWQ==
X-Gm-Message-State: APjAAAVyXRrRmWuAYl/RI5TxQCjOxmqx5UdPZ3QgBRghB4kTW2NTu+JG
        eybRfh77v+rCWI69kcKVtP8=
X-Google-Smtp-Source: APXvYqxvbWuWc6iHgL/4RB/LfQzZBDfxCG2pSWH3Yiu4TxwD/CbqBiHgscOHEikcDSVqVeMaf/3ZcQ==
X-Received: by 2002:a6b:f90f:: with SMTP id j15mr7021482iog.43.1560985954722;
        Wed, 19 Jun 2019 16:12:34 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30? ([2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30])
        by smtp.googlemail.com with ESMTPSA id f20sm19426125ioh.17.2019.06.19.16.12.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 16:12:33 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/5] ipv6: honor RT6_LOOKUP_F_DST_NOREF in
 rule lookup logic
To:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
References: <20190619223158.35829-1-tracywwnj@gmail.com>
 <20190619223158.35829-4-tracywwnj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <857851ee-c610-0b19-b5b1-1948bebe84ab@gmail.com>
Date:   Wed, 19 Jun 2019 17:12:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190619223158.35829-4-tracywwnj@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 4:31 PM, Wei Wang wrote:
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index bcfae13409b5..d22b6c140f23 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -113,14 +113,15 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
>  		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
>  		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
>  			return &rt->dst;
> -		ip6_rt_put(rt);
> +		ip6_rt_put_flags(rt, flags);
>  		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
>  		if (rt->dst.error != -EAGAIN)
>  			return &rt->dst;
> -		ip6_rt_put(rt);
> +		ip6_rt_put_flags(rt, flags);
>  	}
>  
> -	dst_hold(&net->ipv6.ip6_null_entry->dst);
> +	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
> +		dst_hold(&net->ipv6.ip6_null_entry->dst);
>  	return &net->ipv6.ip6_null_entry->dst;
>  }
>  

What about the fib6_rule_lookup when CONFIG_IPV6_MULTIPLE_TABLES is
configured off? If caller passes in RT6_LOOKUP_F_DST_NOREF that version
is still taking a reference in the error path and does a put after the
lookup.
