Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E376B15FF9C
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgBOSGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 13:06:46 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36304 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgBOSGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 13:06:46 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so14141294iog.3;
        Sat, 15 Feb 2020 10:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NsIiQwqS6cgJUXhrYokg58sE3wdZNJcLzDgH2A9wBoc=;
        b=JUzmgHQW0ygVNxC34Ag12afliKhMOAUqzeWSF3J9lw3YnjIMrP4kbsR42OW7Yq+OSn
         h4Q0I4WN5Em59aiqyBnT2EB9kdV04bU234kSP37eixi8T0w32JKB/ADi9udSHkqcChvs
         Ip7p6NDxnSpq1btxmaYmLfhLnULw6hkoQhpxhFw0iuwvCqhRYv+WOCT1SP8YHLAE/xQr
         b4rIGpvzhx9SB3qEJql9k/WliaRxmsaLUqXy/a/9ZvQVp9Zd7bbwUVgIrvLKp7g6p2hv
         jouDcKrfpARvxanwvVG21BxEKocNUsaQvTnbSXOGr2KPPqKCjx8er3fxOGm9VRmihzIy
         OpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NsIiQwqS6cgJUXhrYokg58sE3wdZNJcLzDgH2A9wBoc=;
        b=Qf9ItVjaijvc1Pc5Dy+8/uW+CteJiNPm5eZcBsZKG4gzKB70QG8gWTKS+ASbizEBf/
         AL0Te+4z16LExOlhjiejHFQBQPLL6YayMhbj16R1XJKM9DyEZ/pAlpHk4zORxey3vqZ9
         n+dmiSW8qac15oUdIWlSQD51Dtkk587/8Ubtw7te8aCH7rKWKN+Q159xl7CSQSRcCYf+
         PH5m6s4bNbeikucebSD9GJi1DFMsCkDlHN05lpFiHiSKLsGWasqFF0ujxj/WQNEKJYHS
         ym8tzBQFhwm6vy04j6vkdDl1/QWNZxXVrxvt+dvG6LNWMuttkDFvh2uQpYKIVVkJoDik
         MAvQ==
X-Gm-Message-State: APjAAAXWfY8AtxtWIZmNKsXePQyJArXJGc1NhL31LLgtwIO1lX+0vF3c
        ejjltFSE1WuL2PRV04g0TKQ=
X-Google-Smtp-Source: APXvYqw/TMuTdtEKSxM80YYuxF8GBW/gVKEKjwlvY7UdU+P7uRrVmdcJ2dOIMCbrdKjjtfL1jWrUfQ==
X-Received: by 2002:a6b:4906:: with SMTP id u6mr6537311iob.120.1581790005139;
        Sat, 15 Feb 2020 10:06:45 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:65d1:a3b2:d15f:79af? ([2601:282:803:7700:65d1:a3b2:d15f:79af])
        by smtp.googlemail.com with ESMTPSA id m3sm3385454ilf.64.2020.02.15.10.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 10:06:44 -0800 (PST)
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
To:     Carmine Scarpitta <carmine.scarpitta@uniroma2.it>,
        davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahmed.abdelsalam@gssi.it, david.lebrun@uclouvain.be,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
 <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
Date:   Sat, 15 Feb 2020 11:06:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/20 6:09 PM, Carmine Scarpitta wrote:
> In IPv4, the routing subsystem is invoked by calling ip_route_input_rcu()
> which performs the recognition logic and calls ip_route_input_slow().
> 
> ip_route_input_slow() initialises both "fi" and "table" members
> of the fib_result structure to null before calling fib_lookup().
> 
> fib_lookup() performs fib lookup in the routing table configured
> by the policy routing rules.
> 
> In this patch, we allow invoking the ip4 routing subsystem
> with known routing table. This is useful for use-cases implementing
> a separate routing table per tenant.
> 
> The patch introduces a new flag named "tbl_known" to the definition of
> ip_route_input_rcu() and ip_route_input_slow().
> 
> When the flag is set, ip_route_input_slow() will call fib_table_lookup()
> using the defined table instead of using fib_lookup().

I do not like this change. If you want a specific table lookup, then why
just call fib_table_lookup directly? Both it and rt_dst_alloc are
exported for modules. Your next patch already does a fib table lookup.


> 
> Signed-off-by: Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
> Acked-by: Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
> Acked-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Acked-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
> ---
>  include/net/route.h |  2 +-
>  net/ipv4/route.c    | 22 ++++++++++++++--------
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/route.h b/include/net/route.h
> index a9c60fc68e36..4ff977bd7029 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -183,7 +183,7 @@ int ip_route_input_noref(struct sk_buff *skb, __be32 dst, __be32 src,
>  			 u8 tos, struct net_device *devin);
>  int ip_route_input_rcu(struct sk_buff *skb, __be32 dst, __be32 src,
>  		       u8 tos, struct net_device *devin,
> -		       struct fib_result *res);
> +		       struct fib_result *res, bool tbl_known);
>  
>  int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
>  		      u8 tos, struct net_device *devin,
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index d5c57b3f77d5..39cec9883d6f 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2077,7 +2077,7 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
>  
>  static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
>  			       u8 tos, struct net_device *dev,
> -			       struct fib_result *res)
> +			       struct fib_result *res, bool tbl_known)
>  {
>  	struct in_device *in_dev = __in_dev_get_rcu(dev);
>  	struct flow_keys *flkeys = NULL, _flkeys;
> @@ -2109,8 +2109,6 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
>  	if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr))
>  		goto martian_source;
>  
> -	res->fi = NULL;
> -	res->table = NULL;
>  	if (ipv4_is_lbcast(daddr) || (saddr == 0 && daddr == 0))
>  		goto brd_input;

I believe this also introduces a potential bug. You remove the fi
initialization yet do not cover the goto case.


