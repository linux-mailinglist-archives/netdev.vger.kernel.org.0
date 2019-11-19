Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997E9102AD9
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfKSRe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:34:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39639 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKSReZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:34:25 -0500
Received: by mail-pf1-f194.google.com with SMTP id x28so12523077pfo.6
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 09:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w2ktijandbVIJfqAUnbaYlih2NmssgaL/L9dPySZ93Y=;
        b=EGNQ7MlvDpjfOpq68gLJyTHdWRTG9kRM1XKHb8yZOXjRyHJlWF88Hi5yhbYaxgoE3C
         a+qzw/gjjNU6a0+7ZzrdX2WABLIKQMLtDFcePq00NGGtZmxsyx1Kdr7xnHOXxzryGnNG
         kf3Cg+5W9GgEF0tTO+mFfys5Jl/IKVSALPq0IR9CnsUFhT//by1MVk53eNH4xqRd3hGi
         HsETf04aK8sbeV92Ne0XpmsmKnWpRySY0UjBeAN20QbvXzr4qIYcXXTJNTp0iWoBOXog
         8yVmr0B9r22H3NM0yQzQg0nJuzXUKdJIqjK7HVjGGRdrq1/1JvXIncRqvwWZBpmEp2GA
         C20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2ktijandbVIJfqAUnbaYlih2NmssgaL/L9dPySZ93Y=;
        b=bvEZa8bBwdcEw8Zrur07tY/tkNTyim1MIeZBSUTSRtW3eWbgPwkgFRhQfJcQsjO06H
         u9IfbmbqIAcIsGy0w5Vx05TOWheOcKwsoKA1DNZZt3mehIVWQ2amAhQFoklcY5B+fadd
         tLBE8MTKGr4CkQgu8XlvdXXkmwkJ/YMIGUwfqueijW0Xf4cqOmHO3EDpv2pzFKX/hHKw
         IfQ+24pFjyKQv+bwYOWghVEB6jJjLXk2XI77GE2FE8w7g/pqTIxABmP467zVKCc66y4y
         ysYJv4vQzla/2uCbDNYO76uWtWJnXSRfKN061viveZoTccQjYaculB6yorDP5/favBsR
         9N3A==
X-Gm-Message-State: APjAAAUfY98qF3H+jpPabkZ61zXqsyZIx2j6dcVgpyA2wjo76k8mSiZw
        /T8pszhPJYcHSRU5GBLaIOU=
X-Google-Smtp-Source: APXvYqzK822L9++zNebj4UlaMUWHFD2n8hgLE1M1PQZOHNVReakoSwvQSt5V2EL8GSMDIapjCRZ/bw==
X-Received: by 2002:a62:e306:: with SMTP id g6mr7300779pfh.32.1574184865087;
        Tue, 19 Nov 2019 09:34:25 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id a13sm9790645pfi.187.2019.11.19.09.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 09:34:24 -0800 (PST)
Subject: Re: [PATCH net-next v3 1/2] ipv6: introduce and uses route look hints
 for list input
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>
References: <cover.1574165644.git.pabeni@redhat.com>
 <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c6d67eb8-623e-9265-567c-3d5cc1de7477@gmail.com>
Date:   Tue, 19 Nov 2019 09:34:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/19 6:38 AM, Paolo Abeni wrote:
> When doing RX batch packet processing, we currently always repeat
> the route lookup for each ingress packet. If policy routing is
> configured, and IPV6_SUBTREES is disabled at build time, we
> know that packets with the same destination address will use
> the same dst.
> 
> This change tries to avoid per packet route lookup caching
> the destination address of the latest successful lookup, and
> reusing it for the next packet when the above conditions are
> in place. Ingress traffic for most servers should fit.
> 
> The measured performance delta under UDP flood vs a recvmmsg
> receiver is as follow:
> 
> vanilla		patched		delta
> Kpps		Kpps		%
> 1431		1674		+17
> 



> In the worst-case scenario - each packet has a different
> destination address - the performance delta is within noise
> range.
> 
> v2 -> v3:
>  - add fib6_has_custom_rules() helpers (David A.)
>  - add ip6_extract_route_hint() helper (Edward C.)
>  - use hint directly in ip6_list_rcv_finish() (Willem)
> 
> v1 -> v2:
>  - fix build issue with !CONFIG_IPV6_MULTIPLE_TABLES
>  - fix potential race when fib6_has_custom_rules is set
>    while processing a packet batch
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/ip6_fib.h |  9 +++++++++
>  net/ipv6/ip6_input.c  | 26 ++++++++++++++++++++++++--
>  2 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> index 5d1615463138..9ab60611b97b 100644
> --- a/include/net/ip6_fib.h
> +++ b/include/net/ip6_fib.h
> @@ -502,6 +502,11 @@ static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
>  }
>  
>  #ifdef CONFIG_IPV6_MULTIPLE_TABLES
> +static inline bool fib6_has_custom_rules(struct net *net)

const struct net *net

> +{
> +	return net->ipv6.fib6_has_custom_rules;

It would be nice to be able to detect that some custom rules only impact egress routes :/

> +}
> +
>  int fib6_rules_init(void);
>  void fib6_rules_cleanup(void);
>  bool fib6_rule_default(const struct fib_rule *rule);
> @@ -527,6 +532,10 @@ static inline bool fib6_rules_early_flow_dissect(struct net *net,
>  	return true;
>  }
>  #else
> +static inline bool fib6_has_custom_rules(struct net *net)

const struct net *net

> +{
> +	return 0;


	return false;


BTW, this deserves a patch on its own :)

> +}
>  static inline int               fib6_rules_init(void)
>  {
>  	return 0;
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index ef7f707d9ae3..792b52aa9fc9 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -59,6 +59,7 @@ static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
>  			INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
>  					udp_v6_early_demux, skb);
>  	}
> +

Why adding a new line ? Please refrain adding noise to a patch.

>  	if (!skb_valid_dst(skb))
>  		ip6_route_input(skb);
>  }
> @@ -86,11 +87,26 @@ static void ip6_sublist_rcv_finish(struct list_head *head)
>  	}
>  }
>  
> +static bool ip6_can_use_hint(struct sk_buff *skb, const struct sk_buff *hint)
> +{
> +	return hint && !skb_dst(skb) &&
> +	       ipv6_addr_equal(&ipv6_hdr(hint)->daddr, &ipv6_hdr(skb)->daddr);
> +}
> +

Why keeping whole skb as the hint, since all you want is the ipv6_hdr(skb)->daddr ?

Remembering the pointer to daddr would avoid de-referencing many skb fields.


> +static struct sk_buff *ip6_extract_route_hint(struct net *net,
> +					      struct sk_buff *skb)
> +{
> +	if (IS_ENABLED(IPV6_SUBTREES) || fib6_has_custom_rules(net))
> +		return NULL;
> +
> +	return skb;
> +}
> +
>  static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
>  				struct list_head *head)
>  {
> +	struct sk_buff *skb, *next, *hint = NULL;
>  	struct dst_entry *curr_dst = NULL;
> -	struct sk_buff *skb, *next;
>  	struct list_head sublist;
>  
>  	INIT_LIST_HEAD(&sublist);
> @@ -104,9 +120,15 @@ static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
>  		skb = l3mdev_ip6_rcv(skb);
>  		if (!skb)
>  			continue;
> -		ip6_rcv_finish_core(net, sk, skb);
> +
> +		if (ip6_can_use_hint(skb, hint))
> +			skb_dst_copy(skb, hint);
> +		else
> +			ip6_rcv_finish_core(net, sk, skb);
>  		dst = skb_dst(skb);
>  		if (curr_dst != dst) {
> +			hint = ip6_extract_route_hint(net, skb);
> +
>  			/* dispatch old sublist */
>  			if (!list_empty(&sublist))
>  				ip6_sublist_rcv_finish(&sublist);
> 
