Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64937AB0E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhEKPrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhEKPrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 11:47:37 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D7DC061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:46:30 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id k25so19441150oic.4
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DD+GmLhR3P4/N7IafXqcIbAsGHci6maf9s5Q/89MZZI=;
        b=sXiQ+cY7hfO1hqWLMbfvBj8Bf8oeb5cFbz88+j4ykGBf21h1QXb5MuxjwuPyUqOzi4
         5X4/zicgik5B6SlDvRWN9cn8Cf/GXYj07y4+PpepRWYrpyR8G+31qauMRiAkbPin8z6J
         pJRH9viH/XULvzD3xFFI+Ub1AbsnwBM2g2lDDdRvpncDuunt975Kv1gs5odcEmwEI/ij
         ccJ7Eio5pimwMIclq7Q+lynWIlyFPyxgsdf8LkHHnK08xvTcahYY/YYPjfBbSrQPOztg
         pWBAKeyVXL28JkRiWjv2F5DbCJFSIJAQ1lvPW1pSRrua5/Rl2Dna9JawFfj5COZIyRED
         HGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DD+GmLhR3P4/N7IafXqcIbAsGHci6maf9s5Q/89MZZI=;
        b=ugeWu8eK8nnAS0wlfqNgrj691iXFU73miaLagpnldRSkUXymxAUHbkt0xFfIQItCQl
         5ljmbLyaJtCUcwWgVQHfyM6TmH/fFnuBgdDh15oTCu2sgOuiIcxyM1fwEzhWur4y8SXw
         NpsNvOGiwmAEbuQkIKeZWDXoBmOB3jLEBNj/zICtbtgY7HrxcREvo4qPfUIqt2EwNNA1
         EEhXtOmUuRwM/4+cczODWQ+Iod5mgFU3oIY/HKKjrJk1YSE8et3B8NTFOa6gIuYUZm/c
         hAg4zgvDFl/OpqVUAU9pWrgaR3NJyYsj7Rd9O2Qf+rr++/o+5RIlgA+IAKqFRjF9kloN
         P14w==
X-Gm-Message-State: AOAM531/JSO8Z/U72EkDQI9wc7cMjQv8pxYxmBywy+0p7SP+aZXsP9+8
        a5cavEoaxNHa7xW+12YonKARULoLCCe4rA==
X-Google-Smtp-Source: ABdhPJzRWPNsxJI2ty/u2IhMaku69mRXDk1r79NXw+0Qz6TshvtUOweVyOStFkVWZ7YT0luRBrRs0g==
X-Received: by 2002:aca:1814:: with SMTP id h20mr4014868oih.150.1620747990163;
        Tue, 11 May 2021 08:46:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:8052:e21b:4a8:8b78])
        by smtp.googlemail.com with ESMTPSA id j16sm1330915otn.55.2021.05.11.08.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 08:46:29 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v2 03/10] ipv4: Add custom multipath hash
 policy
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210509151615.200608-1-idosch@idosch.org>
 <20210509151615.200608-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0a199bbf-0ee7-1826-0906-dcfed8c86c7d@gmail.com>
Date:   Tue, 11 May 2021 09:46:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210509151615.200608-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/21 9:16 AM, Ido Schimmel wrote:
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 9d61e969446e..a4c477475f4c 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1906,6 +1906,121 @@ static void ip_multipath_l3_keys(const struct sk_buff *skb,
>  	hash_keys->addrs.v4addrs.dst = key_iph->daddr;
>  }
>  
> +static u32 fib_multipath_custom_hash_outer(const struct net *net,
> +					   const struct sk_buff *skb,
> +					   bool *p_has_inner)
> +{
> +	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
> +	struct flow_keys keys, hash_keys;
> +
> +	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
> +		return 0;
> +
> +	memset(&hash_keys, 0, sizeof(hash_keys));
> +	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
> +
> +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
> +		hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
> +		hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
> +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
> +		hash_keys.ports.src = keys.ports.src;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
> +		hash_keys.ports.dst = keys.ports.dst;
> +
> +	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
> +	return flow_hash_from_keys(&hash_keys);
> +}
> +
> +static u32 fib_multipath_custom_hash_inner(const struct net *net,
> +					   const struct sk_buff *skb,
> +					   bool has_inner)
> +{
> +	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
> +	struct flow_keys keys, hash_keys;
> +
> +	/* We assume the packet carries an encapsulation, but if none was
> +	 * encountered during dissection of the outer flow, then there is no
> +	 * point in calling the flow dissector again.
> +	 */
> +	if (!has_inner)
> +		return 0;
> +
> +	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_MASK))
> +		return 0;
> +
> +	memset(&hash_keys, 0, sizeof(hash_keys));
> +	skb_flow_dissect_flow_keys(skb, &keys, 0);
> +
> +	if (!(keys.control.flags & FLOW_DIS_ENCAPSULATION))
> +		return 0;
> +
> +	if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
> +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
> +			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
> +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
> +			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
> +	} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
> +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
> +			hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
> +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
> +			hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
> +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL)
> +			hash_keys.tags.flow_label = keys.tags.flow_label;
> +	}
> +
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO)
> +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT)
> +		hash_keys.ports.src = keys.ports.src;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT)
> +		hash_keys.ports.dst = keys.ports.dst;
> +
> +	return flow_hash_from_keys(&hash_keys);
> +}
> +
> +static u32 fib_multipath_custom_hash_skb(const struct net *net,
> +					 const struct sk_buff *skb)
> +{
> +	u32 mhash, mhash_inner;
> +	bool has_inner = true;
> +

Is it not possible to do the dissect once here and pass keys to outer
and inner functions?

	memset(&hash_keys, 0, sizeof(hash_keys));
	skb_flow_dissect_flow_keys(skb, &keys, flag);


> +	mhash = fib_multipath_custom_hash_outer(net, skb, &has_inner);
> +	mhash_inner = fib_multipath_custom_hash_inner(net, skb, has_inner);
> +
> +	return jhash_2words(mhash, mhash_inner, 0);
> +}
> +
> +static u32 fib_multipath_custom_hash_fl4(const struct net *net,
> +					 const struct flowi4 *fl4)
> +{
> +	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
> +	struct flow_keys hash_keys;
> +
> +	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
> +		return 0;
> +
> +	memset(&hash_keys, 0, sizeof(hash_keys));
> +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
> +		hash_keys.addrs.v4addrs.src = fl4->saddr;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
> +		hash_keys.addrs.v4addrs.dst = fl4->daddr;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
> +		hash_keys.basic.ip_proto = fl4->flowi4_proto;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
> +		hash_keys.ports.src = fl4->fl4_sport;
> +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
> +		hash_keys.ports.dst = fl4->fl4_dport;
> +
> +	return flow_hash_from_keys(&hash_keys);
> +}
> +
>  /* if skb is set it will be used and fl4 can be NULL */
>  int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
>  		       const struct sk_buff *skb, struct flow_keys *flkeys)
