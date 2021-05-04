Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7065372484
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 04:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhEDCrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 22:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhEDCrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 22:47:16 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B62C061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 19:46:21 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id l6so7451318oii.1
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 19:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S7qLXy0Cp35c7iOiovjxFCoLBgp6iuh/PTLreyG0USU=;
        b=SxZkTao+C3WXuAKjRARoF2CYos+njserHzRCXdFPajXezjGon9pL0+W8IJFC2nQc21
         QMh05B/M8HNmTBfOTr2+ZJMnA9vsOoW7C1YA2ByffobrPeLEH/hbhr2OGDeXbDldvrr7
         SR2WIuvUGfXd8fPagP+7ShV71zbGeWeZX2rMs3V6ciXUzfZp2i0jZiXORW5bf6NZRYs2
         E3C+kWyrgfCriMD79lY+o4s6nObs6ysNN3P8KfiI1pfzIR11FP4qXoluxMhi+U9ZIt0A
         3wuRcjHo/uNJ/7eSokCkVAvDkUYVJUbhzBfjXFkTXQ0+gzyhcZah9sbfwSl9ETqVcgY4
         Em+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S7qLXy0Cp35c7iOiovjxFCoLBgp6iuh/PTLreyG0USU=;
        b=uIOlnA+3qg1IuL7adntg2cPmLFczxH+dpiExbw2vOx0sQI2esUGezWRqIGsSn4OkGh
         cJRf1k2xoJ8A+gzUKgHRukAZ/Wn4YE0YUZ4fpwaaJhtuOBiE+VVz1YPBLdlnBb47Ijzy
         GeSRaSAKhvv1KQPOGiCGdqOoORffm2BtIkKL9mL+zMlb9wR1ESGuvHV4hMcBjN8ysLtH
         ZlR6dydR/IeQ84gpwHGi7YeGMxr7adjQr3Wvk+Pm/O9pm2u+FOskEet95nPthEU5KmvK
         zj1r6yOwzGsZyQcD4z+3YwvIvSvxz05yATpVsBIpbwN+A8hJLF2wjdLS38RjHZM3w7OV
         gyDA==
X-Gm-Message-State: AOAM53108Arf7JYp2jR/NsEBCe8FL9tC373AEavnSsNShqfhNKC65k9d
        MF8UTdfs86rIU7WIFOvZLKvOfQlUSXaw5Q==
X-Google-Smtp-Source: ABdhPJwQYs+aGV96iy5Ho7zVjknYSjYW5ZqNWgw/7Gp7Gpyvsta4ElxXImsDuE5qy983TGU3NjyMLQ==
X-Received: by 2002:aca:f008:: with SMTP id o8mr16174085oih.106.1620096380727;
        Mon, 03 May 2021 19:46:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id y6sm464697otk.42.2021.05.03.19.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:46:20 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 07/10] ipv6: Add custom multipath hash policy
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210502162257.3472453-1-idosch@idosch.org>
 <20210502162257.3472453-8-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1b0c0460-914c-ffa2-ae42-af0ea12ad596@gmail.com>
Date:   Mon, 3 May 2021 20:46:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210502162257.3472453-8-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 10:22 AM, Ido Schimmel wrote:
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 9935e18146e5..b4c65c5baf35 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -2326,6 +2326,125 @@ static void ip6_multipath_l3_keys(const struct sk_buff *skb,
>  	}
>  }
>  
> +static u32 rt6_multipath_custom_hash_outer(const struct net *net,
> +					   const struct sk_buff *skb,
> +					   bool *p_has_inner)
> +{
> +	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
> +	struct flow_keys keys, hash_keys;
> +
> +	if (!net->ipv6.sysctl.multipath_hash_fields_need_outer)
> +		return 0;
> +
> +	memset(&hash_keys, 0, sizeof(hash_keys));
> +	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
> +
> +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
> +		hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
> +		hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
> +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(FLOWLABEL, hash_fields))
> +		hash_keys.tags.flow_label = keys.tags.flow_label;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
> +		hash_keys.ports.src = keys.ports.src;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
> +		hash_keys.ports.dst = keys.ports.dst;
> +
> +	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
> +	return flow_hash_from_keys(&hash_keys);
> +}
> +
> +static u32 rt6_multipath_custom_hash_inner(const struct net *net,
> +					   const struct sk_buff *skb,
> +					   bool has_inner)
> +{
> +	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
> +	struct flow_keys keys, hash_keys;
> +
> +	/* We assume the packet carries an encapsulation, but if none was
> +	 * encountered during dissection of the outer flow, then there is no
> +	 * point in calling the flow dissector again.
> +	 */
> +	if (!has_inner)
> +		return 0;
> +
> +	if (!net->ipv6.sysctl.multipath_hash_fields_need_inner)
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
> +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_IP, hash_fields))
> +			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
> +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_IP, hash_fields))
> +			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
> +	} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
> +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_IP, hash_fields))
> +			hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
> +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_IP, hash_fields))
> +			hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
> +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_FLOWLABEL, hash_fields))
> +			hash_keys.tags.flow_label = keys.tags.flow_label;
> +	}
> +
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_IP_PROTO, hash_fields))
> +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_PORT, hash_fields))
> +		hash_keys.ports.src = keys.ports.src;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_PORT, hash_fields))
> +		hash_keys.ports.dst = keys.ports.dst;
> +
> +	return flow_hash_from_keys(&hash_keys);
> +}
> +
> +static u32 rt6_multipath_custom_hash_skb(const struct net *net,
> +					 const struct sk_buff *skb)
> +{
> +	u32 mhash, mhash_inner;
> +	bool has_inner = true;
> +
> +	mhash = rt6_multipath_custom_hash_outer(net, skb, &has_inner);
> +	mhash_inner = rt6_multipath_custom_hash_inner(net, skb, has_inner);
> +
> +	return jhash_2words(mhash, mhash_inner, 0);
> +}
> +
> +static u32 rt6_multipath_custom_hash_fl6(const struct net *net,
> +					 const struct flowi6 *fl6)
> +{
> +	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
> +	struct flow_keys hash_keys;
> +
> +	if (!net->ipv6.sysctl.multipath_hash_fields_need_outer)
> +		return 0;
> +
> +	memset(&hash_keys, 0, sizeof(hash_keys));
> +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
> +		hash_keys.addrs.v6addrs.src = fl6->saddr;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
> +		hash_keys.addrs.v6addrs.dst = fl6->daddr;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
> +		hash_keys.basic.ip_proto = fl6->flowi6_proto;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(FLOWLABEL, hash_fields))
> +		hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
> +		hash_keys.ports.src = fl6->fl6_sport;
> +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
> +		hash_keys.ports.dst = fl6->fl6_dport;
> +
> +	return flow_hash_from_keys(&hash_keys);
> +}
> +

given the amount of duplication with IPv4, should be able to use inline
macros and the flowi_uli union to make some common helpers without
impacting performance.

