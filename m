Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F7F288E98
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389725AbgJIQRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389410AbgJIQRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:17:44 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8086FC0613D2;
        Fri,  9 Oct 2020 09:17:44 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i2so7550025pgh.7;
        Fri, 09 Oct 2020 09:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rBlFvBuPHpKcQCf/9R4Y/GSt33DCU18bEcZZFT4oiYE=;
        b=po44Cel5kR3/d+veaeQYUEAbTR0d5tflKbfG1ySenY1cg0pRfzpXCQpP/+WduekHTe
         3CehJa6hBViO/IDwmOIvwmKq358QRXPZ41HCqxQxqjn7xJ4/HiDsyUh5cdgblH6GIbTa
         MKHQq7odk8nTbbMyVyxnSO//Ho1/mE7OL8nl1zmtZWWpOFoJqbZTPn+UmlZtfnBy4vRJ
         ciNo9IHzKqECbwk4LSItfei2eeIAMHZgyq4YoIclVFms2YwqjMD7pXqcGPyZkAkXlA4r
         mVFWQDeA2+qO7D9Mj1l0RSqozSp+UnPrv1j5KfVtKw6h2xIFt/2UWtoHqMvFNIzfD8NF
         M2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rBlFvBuPHpKcQCf/9R4Y/GSt33DCU18bEcZZFT4oiYE=;
        b=KKVGrYkbJYTfU//ZQqDTvVfLLEtH3cJBL38QUE0QValXCzJcpt26ZAlebJou1QdEwr
         9hK3qVHkh0eUdiT4rgd9wOCg5DO5f9BtUInx6mawx5ePlm3bg+oznaAn+hxC5hykp5l2
         hZKcEOokYNBz9q5kv24ny1BUvJzOy9a2cYveeS7KdC62G2ksUZz1Jlg8Gr6wF+ORnAfe
         2eGf4UVBfSaFVpTYm1FqFp2O4r+bcXh9dJJ5cByYQDs0JslrGrbodeORVkAfDHnlxMz1
         7B1a0QlulWXezGlQI9+KAPWokuhxtKupb9zU9uzZDSgLHOYUhHpnqPxvMWY9UVaqechC
         FJgg==
X-Gm-Message-State: AOAM5316bDmhStPrMNh76H8EzMT/H03zclPP6qb26mODte7/MsdqhZC/
        F4uZR80HCIZBaaMGjWnpNxo=
X-Google-Smtp-Source: ABdhPJwk4YWzWHQXL9rVfF7zpbxkTK3ud1Ov2sKU0EQgCE4TbElqOGxQ4kaXDIuBH9ULjumdnNIlAw==
X-Received: by 2002:a17:90b:698:: with SMTP id m24mr5591498pjz.154.1602260263918;
        Fri, 09 Oct 2020 09:17:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id n9sm11258904pgi.2.2020.10.09.09.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 09:17:43 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2] bpf_fib_lookup: optionally skip neighbour
 lookup
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20201009101356.129228-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0a463800-a663-3fd3-2e1a-eac5526ed691@gmail.com>
Date:   Fri, 9 Oct 2020 09:17:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201009101356.129228-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 3:13 AM, Toke Høiland-Jørgensen wrote:
> The bpf_fib_lookup() helper performs a neighbour lookup for the destination
> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
> that the BPF program will pass the packet up the stack in this case.
> However, with the addition of bpf_redirect_neigh() that can be used instead
> to perform the neighbour lookup, at the cost of a bit of duplicated work.
> 
> For that we still need the target ifindex, and since bpf_fib_lookup()
> already has that at the time it performs the neighbour lookup, there is
> really no reason why it can't just return it in any case. So let's just
> always return the ifindex, and also add a flag that lets the caller turn
> off the neighbour lookup entirely in bpf_fib_lookup().

seems really odd to do the fib lookup only to skip the neighbor lookup
and defer to a second helper to do a second fib lookup and send out.

The better back-to-back calls is to return the ifindex and gateway on
successful fib lookup regardless of valid neighbor. If the call to
bpf_redirect_neigh is needed, it can have a flag to skip the fib lookup
and just redirect to the given nexthop address + ifindex. ie.,
bpf_redirect_neigh only does neighbor handling in this case.


> 
> v2:
> - Add flag (Daniel)
> - Remove misleading code example from commit message (David)
> 
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/uapi/linux/bpf.h       | 10 ++++++----
>  net/core/filter.c              | 15 ++++++++++++---
>  tools/include/uapi/linux/bpf.h | 10 ++++++----
>  3 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index d83561e8cd2c..9c7c10ce7ace 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4813,12 +4813,14 @@ struct bpf_raw_tracepoint_args {
>  	__u64 args[0];
>  };
>  
> -/* DIRECT:  Skip the FIB rules and go to FIB table associated with device
> - * OUTPUT:  Do lookup from egress perspective; default is ingress
> +/* DIRECT:      Skip the FIB rules and go to FIB table associated with device
> + * OUTPUT:      Do lookup from egress perspective; default is ingress
> + * SKIP_NEIGH:  Skip neighbour lookup and return BPF_FIB_LKUP_RET_NO_NEIGH on success
>   */
>  enum {
> -	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
> -	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
> +	BPF_FIB_LOOKUP_DIRECT      = (1U << 0),
> +	BPF_FIB_LOOKUP_OUTPUT      = (1U << 1),
> +	BPF_FIB_LOOKUP_SKIP_NEIGH  = (1U << 2),
>  };
>  
>  enum {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 05df73780dd3..1038337bc06c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5192,7 +5192,6 @@ static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
>  	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
>  	params->h_vlan_TCI = 0;
>  	params->h_vlan_proto = 0;
> -	params->ifindex = dev->ifindex;
>  
>  	return 0;
>  }
> @@ -5289,6 +5288,10 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>  	dev = nhc->nhc_dev;
>  
>  	params->rt_metric = res.fi->fib_priority;
> +	params->ifindex = dev->ifindex;
> +
> +	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
> +		return BPF_FIB_LKUP_RET_NO_NEIGH;
>  
>  	/* xdp and cls_bpf programs are run in RCU-bh so
>  	 * rcu_read_lock_bh is not needed here
> @@ -5414,6 +5417,10 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>  
>  	dev = res.nh->fib_nh_dev;
>  	params->rt_metric = res.f6i->fib6_metric;
> +	params->ifindex = dev->ifindex;
> +
> +	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
> +		return BPF_FIB_LKUP_RET_NO_NEIGH;
>  
>  	/* xdp and cls_bpf programs are run in RCU-bh so rcu_read_lock_bh is
>  	 * not needed here.
> @@ -5432,7 +5439,8 @@ BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
>  	if (plen < sizeof(*params))
>  		return -EINVAL;
>  
> -	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
> +	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT |
> +		      BPF_FIB_LOOKUP_SKIP_NEIGH))
>  		return -EINVAL;
>  
>  	switch (params->family) {
> @@ -5469,7 +5477,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>  	if (plen < sizeof(*params))
>  		return -EINVAL;
>  
> -	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
> +	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT |
> +		      BPF_FIB_LOOKUP_SKIP_NEIGH))
>  		return -EINVAL;
>  
>  	switch (params->family) {
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index d83561e8cd2c..9c7c10ce7ace 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -4813,12 +4813,14 @@ struct bpf_raw_tracepoint_args {
>  	__u64 args[0];
>  };
>  
> -/* DIRECT:  Skip the FIB rules and go to FIB table associated with device
> - * OUTPUT:  Do lookup from egress perspective; default is ingress
> +/* DIRECT:      Skip the FIB rules and go to FIB table associated with device
> + * OUTPUT:      Do lookup from egress perspective; default is ingress
> + * SKIP_NEIGH:  Skip neighbour lookup and return BPF_FIB_LKUP_RET_NO_NEIGH on success
>   */
>  enum {
> -	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
> -	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
> +	BPF_FIB_LOOKUP_DIRECT      = (1U << 0),
> +	BPF_FIB_LOOKUP_OUTPUT      = (1U << 1),
> +	BPF_FIB_LOOKUP_SKIP_NEIGH  = (1U << 2),
>  };
>  
>  enum {
> 

