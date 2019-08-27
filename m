Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0709EC59
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfH0PWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 11:22:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35254 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0PWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 11:22:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so3505500wmg.0;
        Tue, 27 Aug 2019 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Spk/7nyE/nT+VZarCTcJww4THetyUEU/waY4Rm0/gF4=;
        b=J4/qrorNAUBgXfuvu3IwAqPkSje/x/d8mwImUgF/C2Mac0PhX3/mv0uWlvmpSb8aH4
         TfF4wg1MPJjTD2Z+C8uljmIll1IG/wWJ1v1fDad4aNNx84ebIRM7sYb+UJQ/D58FEW95
         PuIxC+kDGjFl1fXUPVu1BqrkICY2oCGTGYa1oAlMEcVPmFWvA7UpKmKOfQBo1tWNIVVu
         F7rmr13jbqb9MbLE//ZmTHmtJjBwMbQO7uxIUWAoTB7AgZrzE4jCXkGZ7+kL34O4KwFw
         rMy4oerEOhVpJkDxbc2gAPK/HCRsz9GVJ+5GZkpN3hmA5fu0x6hhBwNduGxeKxpxJxjn
         6PCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Spk/7nyE/nT+VZarCTcJww4THetyUEU/waY4Rm0/gF4=;
        b=dsFwfCa2+8vvV8mdVbfdHLKOUFzV8CBuupLzf/VI79P6T7fjiezXWInz/vO7Wcfw29
         EYIiO1ntFvjq8azCvD0qzsa1poJVjVXb6rDZews5Tsu9eS2G0Bd89P2Ly2TJVWiEGrcP
         xKDlGjf+YlybXDCgRgoX4TbrVWJSFel/2sG0TeQnZ0HRJ4DvSdxvUENzEPMTtj9HoSuY
         JZN/YIcq00C1k8mrakp/d+nKhVrtFA9sQXdeJrEJTFQa13Q7eKwfwsoKRiAO9gnm+xds
         G1eVeLe1ImFIFHUEUoefRQlNvvPGRNzrSLC1ijvqglHGp3B8na1Z0ddmZp/ssU8xNyuV
         D/Ow==
X-Gm-Message-State: APjAAAVkspQmYdW260nUFk4v4Pxx6bt6QN7Rup+FI5KVsF2IhPYuhRJo
        601fLWZDV2gLR3QeKQqmpJI=
X-Google-Smtp-Source: APXvYqzBtu8qQSzftoBoGEPWKov5NjItQxZ9Gts4hY/9P75nGx6LHF01ME5A6BqdidKm85ow9PlN3Q==
X-Received: by 2002:a1c:a514:: with SMTP id o20mr30113350wme.149.1566919356319;
        Tue, 27 Aug 2019 08:22:36 -0700 (PDT)
Received: from [192.168.8.147] (212.160.185.81.rev.sfr.net. [81.185.160.212])
        by smtp.gmail.com with ESMTPSA id t198sm4822597wmt.39.2019.08.27.08.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 08:22:35 -0700 (PDT)
Subject: Re: [PATCH] ipv6: Not to probe neighbourless routes
To:     Yi Wang <wang.yi59@zte.com.cn>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.liang82@zte.com.cn,
        Cheng Lin <cheng.lin130@zte.com.cn>
References: <1566896907-5121-1-git-send-email-wang.yi59@zte.com.cn>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7788439f-6207-6da0-a6f8-db2d2fc61fe4@gmail.com>
Date:   Tue, 27 Aug 2019 17:22:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566896907-5121-1-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/19 11:08 AM, Yi Wang wrote:
> From: Cheng Lin <cheng.lin130@zte.com.cn>
> 
> Originally, Router Reachability Probing require a neighbour entry
> existed. Commit 2152caea7196 ("ipv6: Do not depend on rt->n in
> rt6_probe().") removed the requirement for a neighbour entry. And
> commit f547fac624be ("ipv6: rate-limit probes for neighbourless
> routes") adds rate-limiting for neighbourless routes.
> 
> And, the Neighbor Discovery for IP version 6 (IPv6)(rfc4861) says,
> "
> 7.2.5.  Receipt of Neighbor Advertisements
> 
> When a valid Neighbor Advertisement is received (either solicited or
> unsolicited), the Neighbor Cache is searched for the target's entry.
> If no entry exists, the advertisement SHOULD be silently discarded.
> There is no need to create an entry if none exists, since the
> recipient has apparently not initiated any communication with the
> target.
> ".
> 
> In rt6_probe(), just a Neighbor Solicitation message are transmited.
> When receiving a Neighbor Advertisement, the node does nothing in a
> Neighborless condition.
> 
> Not sure it's needed to create a neighbor entry in Router
> Reachability Probing. And the Original way may be the right way.
> 
> This patch recover the requirement for a neighbour entry.
> 
> Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
> ---
>  include/net/ip6_fib.h | 5 -----
>  net/ipv6/route.c      | 5 +----
>  2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> index 4b5656c..8c2e022 100644
> --- a/include/net/ip6_fib.h
> +++ b/include/net/ip6_fib.h
> @@ -124,11 +124,6 @@ struct rt6_exception {
>  
>  struct fib6_nh {
>  	struct fib_nh_common	nh_common;
> -
> -#ifdef CONFIG_IPV6_ROUTER_PREF
> -	unsigned long		last_probe;
> -#endif
> -
>  	struct rt6_info * __percpu *rt6i_pcpu;
>  	struct rt6_exception_bucket __rcu *rt6i_exception_bucket;
>  };
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index fd059e0..c4bcffc 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -639,12 +639,12 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
>  	nh_gw = &fib6_nh->fib_nh_gw6;
>  	dev = fib6_nh->fib_nh_dev;
>  	rcu_read_lock_bh();
> -	idev = __in6_dev_get(dev);
>  	neigh = __ipv6_neigh_lookup_noref(dev, nh_gw);
>  	if (neigh) {
>  		if (neigh->nud_state & NUD_VALID)
>  			goto out;
>  
> +		idev = __in6_dev_get(dev);
>  		write_lock(&neigh->lock);
>  		if (!(neigh->nud_state & NUD_VALID) &&
>  		    time_after(jiffies,
> @@ -654,9 +654,6 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
>  				__neigh_set_probe_once(neigh);
>  		}
>  		write_unlock(&neigh->lock);
> -	} else if (time_after(jiffies, fib6_nh->last_probe +
> -				       idev->cnf.rtr_probe_interval)) {
> -		work = kmalloc(sizeof(*work), GFP_ATOMIC);
>  	}
>  
>  	if (work) {
> 

Have you really compiled this patch ?


