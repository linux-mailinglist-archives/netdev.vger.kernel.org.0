Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BA14A51F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfFRPT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:19:56 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41141 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfFRPT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:19:56 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so30636385ioc.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 08:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wEtu+zKt9aOYeCzxAQKVhku0Wtsy4qhw2dzfrbpYR7k=;
        b=WPJ2aXQyUTaG9F0g7WOrQxAeD5aBmaekUTyNuXjzpUEkmtOTHixf7ExaJEs8nbonjM
         xifRyEBLfQKGwhs3MlaC4bKAPFlqAD9NYFl45/CXImBiQ1st8wXU7SDK/W1dMU+oiJPl
         XNC6CFwukq2C77LKWqGUL1TMnSnkqgoZFNC1W2IJ2/ZwSgUq38nTGsHsJcKp9Fn+kgqH
         vo08Mxc4nR3VFaosjZyUgCZdUh//j9s5xOyoPOEUR9ly3j0lNYYZszJeQM3pvdch8OPP
         HG356QycWHKVc1FtKbROTWnip5LQT+UoLohPKekrIyV92dXeSu1bS28WTgoAZ0nn+3mT
         QyeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wEtu+zKt9aOYeCzxAQKVhku0Wtsy4qhw2dzfrbpYR7k=;
        b=ZUme6MIz6gRGbDRoSc0X3cxQLYiwuaAcOqoUvdC30OO8dXIz0c6MRKNcksO3vRHRHt
         p9B6IBo47mrGufd98nkyG6+I/vYK5L9p8dfJVAElveR6j+B5fyvoOJaQdtcoyT0XVlk3
         0+NER2IUd8+NkiCuPLkt61Tewhu9vODj3a3RNNpSKoXY2fJMwIGnUjI4r4vAEo2i4YjF
         IVbIkgNoHQlbAuCR7VMeUv6pndja8vLrkyUF09+JKoJEKndemFx48u//MSIgvvjbfZWJ
         EcAmCPeFrXRR6cpxFKCu8iU0QAW4EqgEE/NRy/l27PRNECcm7pbrFC2smGE9ty+DOOfI
         UxKg==
X-Gm-Message-State: APjAAAVD7mBwtcjm8d3pvveD8SSWQbctb5Gh5ovyoV5p2Q2MXkhzUdXg
        che7xfZlovgUng8DNEV9R53f+TVE
X-Google-Smtp-Source: APXvYqzRC2zr1TAsTQ366KP6M2Rg7gzoA0Ef4I+I9I2XUQ2CaO5ntzXmHsfiYq370dlpIDVwMJLJzQ==
X-Received: by 2002:a5d:9416:: with SMTP id v22mr2119709ion.4.1560871194953;
        Tue, 18 Jun 2019 08:19:54 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fd97:2a7b:2975:7041? ([2601:282:800:fd80:fd97:2a7b:2975:7041])
        by smtp.googlemail.com with ESMTPSA id t133sm30848562iof.21.2019.06.18.08.19.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:19:54 -0700 (PDT)
Subject: Re: [PATCH net v5 5/6] ipv6: Dump route exceptions if requested
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560827176.git.sbrivio@redhat.com>
 <364403cca3d7836557f8ffe83c9c48b436be76eb.1560827176.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <333b0a08-07dd-3c70-1268-2d9eb5646564@gmail.com>
Date:   Tue, 18 Jun 2019 09:19:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <364403cca3d7836557f8ffe83c9c48b436be76eb.1560827176.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 7:20 AM, Stefano Brivio wrote:
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 0f60eb3a2873..7375f3b7d310 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4854,33 +4854,94 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
>  	return false;
>  }
>  
> -int rt6_dump_route(struct fib6_info *rt, void *p_arg)
> +/* Return -1 if done with node, number of handled routes on partial dump */
> +int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)

Changing the return code of rt6_dump_route should be a separate patch.


>  {
>  	struct rt6_rtnl_dump_arg *arg = (struct rt6_rtnl_dump_arg *) p_arg;
>  	struct fib_dump_filter *filter = &arg->filter;
> +	struct rt6_exception_bucket *bucket;
>  	unsigned int flags = NLM_F_MULTI;
> +	struct rt6_exception *rt6_ex;
>  	struct net *net = arg->net;
> +	int i, count = 0;
>  
>  	if (rt == net->ipv6.fib6_null_entry)
> -		return 0;
> +		return -1;
>  
>  	if ((filter->flags & RTM_F_PREFIX) &&
>  	    !(rt->fib6_flags & RTF_PREFIX_RT)) {
>  		/* success since this is not a prefix route */
> -		return 1;
> +		return -1;
>  	}
> -	if (filter->filter_set) {
> -		if ((filter->rt_type && rt->fib6_type != filter->rt_type) ||
> -		    (filter->dev && !fib6_info_uses_dev(rt, filter->dev)) ||
> -		    (filter->protocol && rt->fib6_protocol != filter->protocol)) {
> -			return 1;
> -		}
> +	if (filter->filter_set &&
> +	    ((filter->rt_type  && rt->fib6_type != filter->rt_type) ||
> +	     (filter->dev      && !fib6_info_uses_dev(rt, filter->dev)) ||
> +	     (filter->protocol && rt->fib6_protocol != filter->protocol))) {
> +		return -1;
> +	}
> +
> +	if (filter->filter_set ||
> +	    !filter->dump_routes || !filter->dump_exceptions) {
>  		flags |= NLM_F_DUMP_FILTERED;
>  	}
>  
> -	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> -			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
> -			     arg->cb->nlh->nlmsg_seq, flags);
> +	if (filter->dump_routes) {
> +		if (skip) {
> +			skip--;
> +		} else {
> +			if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL,
> +					  0, RTM_NEWROUTE,
> +					  NETLINK_CB(arg->cb->skb).portid,
> +					  arg->cb->nlh->nlmsg_seq, flags)) {
> +				return 0;
> +			}
> +			count++;
> +		}
> +	}
> +
> +	if (!filter->dump_exceptions)
> +		return -1;
> +

And the dump of the exception bucket should be a standalone function.
You will see why with net-next (it is per fib6_nh).

> +	bucket = rcu_dereference(rt->rt6i_exception_bucket);
> +	if (!bucket)
> +		return -1;
> +
> +	for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
> +		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
> +			if (skip) {
> +				skip--;
> +				continue;
> +			}
> +
> +			/* Expiration of entries doesn't bump sernum, insertion
> +			 * does. Removal is triggered by insertion, so we can
> +			 * rely on the fact that if entries change between two
> +			 * partial dumps, this node is scanned again completely,
> +			 * see rt6_insert_exception() and fib6_dump_table().
> +			 *
> +			 * Count expired entries we go through as handled
> +			 * entries that we'll skip next time, in case of partial
> +			 * node dump. Otherwise, if entries expire meanwhile,
> +			 * we'll skip the wrong amount.
> +			 */
> +			if (rt6_check_expired(rt6_ex->rt6i)) {
> +				count++;
> +				continue;
> +			}
> +
> +			if (rt6_fill_node(net, arg->skb, rt, &rt6_ex->rt6i->dst,
> +					  NULL, NULL, 0, RTM_NEWROUTE,
> +					  NETLINK_CB(arg->cb->skb).portid,
> +					  arg->cb->nlh->nlmsg_seq, flags)) {
> +				return count;
> +			}
> +
> +			count++;
> +		}
> +		bucket++;
> +	}
> +
> +	return -1;
>  }
>  
>  static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
> 

