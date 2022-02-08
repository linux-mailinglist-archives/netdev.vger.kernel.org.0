Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2173F4ADB26
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351154AbiBHOaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiBHOaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:30:10 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AF8C03FECE;
        Tue,  8 Feb 2022 06:30:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y9so8807551pjf.1;
        Tue, 08 Feb 2022 06:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dwXWBke4MaOCVdpwJ6R3dlZU15cNbrG2g5BYV69w3O4=;
        b=jZaJ3TRRMhDEMS6GgFa7aqUpYHjEaeEiFe+w2mIrq1QH5WgO8daOmK7EgZRMaUkli9
         Krb+f0er/fnQDs84xQ42FCF76Ie2bvHCJHdpA+YC3+NmJzKqr6jZ6LmzzJOxj/MYrwnS
         cSQ7U20btypYoI6el0zjEtBJcxc+lCc9EQkF4uhFEw8Eje7k2RuCXnISJUxuE9COhql1
         r3GXp1rVJmz5FQ9/W5ubF0VFeWNCMrcpub02KXU0VBW9mci/6AV1e+kBosN12moXrkFc
         lTS5q4ttRpq8HDe66Qlxbc/PHvLoGsC7vhsyKMXly+WBZM5wQhQWBKHRsBGe1/yP71rA
         4kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dwXWBke4MaOCVdpwJ6R3dlZU15cNbrG2g5BYV69w3O4=;
        b=SkEMzQifT5KW8a1BDFNKHxGKjHlkk7wLercHoAvQlMx3nitvemvd2+tBNCSa5oZUDL
         brj+nxRoo8RuSRQu+IS5cGn6P3Fl+Wrgy24nuURPWMBl8ygnpOZIVmxjv7UD3yMdWodF
         SzZlq/tY29+uufXMS97yog/cQAvQWC6aKELK2vTwdUjEsa6BwdJIyV//v56LA9XFl7lt
         5QAMWB5b2cce9HXwvid/PKmolH4QBR5XI/bBQ+/c1rWWbZU2DcjliiEJ6W0UaJ8Bwo5i
         rWdsdtG78vCm8qjG9VKdktIoCp1mgD3GBCTNVKetEjkvXIJ6qh5+POTBgweYoz6D6mey
         BlGg==
X-Gm-Message-State: AOAM530tBvcNvzNeTqGykHSKUQF48yf7t1TAH0dkHNlD1pliclfpW5tX
        uihnyq3lYd3miEs2zbhCF4o=
X-Google-Smtp-Source: ABdhPJwwpsbBrErFYkJ0Dx5aLJ10h5Uu2dF8Suqka5m/ya7nc4Keh8AVvvwSae48FHq1uTWlAe+hrA==
X-Received: by 2002:a17:902:d2c9:: with SMTP id n9mr4980888plc.54.1644330608807;
        Tue, 08 Feb 2022 06:30:08 -0800 (PST)
Received: from [192.168.99.7] (i220-99-138-239.s42.a013.ap.plala.or.jp. [220.99.138.239])
        by smtp.googlemail.com with ESMTPSA id mv17sm2736584pjb.14.2022.02.08.06.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 06:30:08 -0800 (PST)
Message-ID: <9d4fd782-896d-4a44-b596-517c84d97d5a@gmail.com>
Date:   Tue, 8 Feb 2022 23:30:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 1/3] netfilter: flowtable: Support GRE
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
 <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
 <YgFdS0ak3LIR2waA@salvia>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <YgFdS0ak3LIR2waA@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/02/08 2:56, Pablo Neira Ayuso wrote:
> On Thu, Feb 03, 2022 at 08:59:39PM +0900, Toshiaki Makita wrote:
>> Support GREv0 without NAT.
>>
>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>> ---
>>   net/netfilter/nf_flow_table_core.c    | 10 +++++--
>>   net/netfilter/nf_flow_table_ip.c      | 54 ++++++++++++++++++++++++++++-------
>>   net/netfilter/nf_flow_table_offload.c | 19 +++++++-----
>>   net/netfilter/nft_flow_offload.c      | 13 +++++++++
>>   4 files changed, 77 insertions(+), 19 deletions(-)
>>
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index b90eca7..e66a375 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -39,8 +39,14 @@
>>   
>>   	ft->l3proto = ctt->src.l3num;
>>   	ft->l4proto = ctt->dst.protonum;
>> -	ft->src_port = ctt->src.u.tcp.port;
>> -	ft->dst_port = ctt->dst.u.tcp.port;
>> +
>> +	switch (ctt->dst.protonum) {
>> +	case IPPROTO_TCP:
>> +	case IPPROTO_UDP:
>> +		ft->src_port = ctt->src.u.tcp.port;
>> +		ft->dst_port = ctt->dst.u.tcp.port;
>> +		break;
>> +	}
>>   }
>>   
>>   struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index 889cf88..48e2f58 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -172,6 +172,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
>>   	struct flow_ports *ports;
>>   	unsigned int thoff;
>>   	struct iphdr *iph;
>> +	u8 ipproto;
>>
>>   	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
>>   		return -1;
>> @@ -185,13 +186,19 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
>>   
>>   	thoff += offset;
>>   
>> -	switch (iph->protocol) {
>> +	ipproto = iph->protocol;
>> +	switch (ipproto) {
>>   	case IPPROTO_TCP:
>>   		*hdrsize = sizeof(struct tcphdr);
>>   		break;
>>   	case IPPROTO_UDP:
>>   		*hdrsize = sizeof(struct udphdr);
>>   		break;
>> +#ifdef CONFIG_NF_CT_PROTO_GRE
>> +	case IPPROTO_GRE:
>> +		*hdrsize = sizeof(struct gre_base_hdr);
>> +		break;
>> +#endif
>>   	default:
>>   		return -1;
>>   	}
>> @@ -202,15 +209,25 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
>>   	if (!pskb_may_pull(skb, thoff + *hdrsize))
>>   		return -1;
>>   
>> +	if (ipproto == IPPROTO_GRE) {
> 
> No ifdef here? Maybe remove these ifdef everywhere?

I wanted to avoid adding many ifdefs and I expect this to be compiled out when 
CONFIG_NF_CT_PROTO_GRE=n as this block is unreachable anyway. It rather may have 
been unintuitive though.

Removing all of these ifdefs will cause inconsistent behavior between 
CONFIG_NF_CT_PROTO_GRE=n/y.
When CONFIG_NF_CT_PROTO_GRE=n, conntrack cannot determine GRE version, thus it will 
track GREv1 without key infomation, and the flow will be offloaded.
When CONFIG_NF_CT_PROTO_GRE=y, GREv1 will have key information and will not be 
offloaded.
I wanted to just refuse offloading of GRE to avoid this inconsistency.
Anyway this kind of inconsistency seems to happen in software conntrack, so if you'd 
like to remove ifdefs, I will do.

>> +		struct gre_base_hdr *greh;
>> +
>> +		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
>> +		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
>> +			return -1;
>> +	}
>> +
>>   	iph = (struct iphdr *)(skb_network_header(skb) + offset);
>> -	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>>   
>>   	tuple->src_v4.s_addr	= iph->saddr;
>>   	tuple->dst_v4.s_addr	= iph->daddr;
>> -	tuple->src_port		= ports->source;
>> -	tuple->dst_port		= ports->dest;
>> +	if (ipproto == IPPROTO_TCP || ipproto == IPPROTO_UDP) {
>> +		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>> +		tuple->src_port		= ports->source;
>> +		tuple->dst_port		= ports->dest;
>> +	}
> 
> maybe:
> 
>          switch (ipproto) {
>          case IPPROTO_TCP:
>          case IPPROTO_UDP:
>                  ...
>                  break;
>          case IPPROTO_GRE:
>                  break;
>          }
> 
> ?

Sure, will fix.

>>   	tuple->l3proto		= AF_INET;
>> -	tuple->l4proto		= iph->protocol;
>> +	tuple->l4proto		= ipproto;
>>   	tuple->iifidx		= dev->ifindex;
>>   	nf_flow_tuple_encap(skb, tuple);
>>   
>> @@ -521,6 +538,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>>   	struct flow_ports *ports;
>>   	struct ipv6hdr *ip6h;
>>   	unsigned int thoff;
>> +	u8 nexthdr;
>>   
>>   	thoff = sizeof(*ip6h) + offset;
>>   	if (!pskb_may_pull(skb, thoff))
>> @@ -528,13 +546,19 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>>   
>>   	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
>>   
>> -	switch (ip6h->nexthdr) {
>> +	nexthdr = ip6h->nexthdr;
>> +	switch (nexthdr) {
>>   	case IPPROTO_TCP:
>>   		*hdrsize = sizeof(struct tcphdr);
>>   		break;
>>   	case IPPROTO_UDP:
>>   		*hdrsize = sizeof(struct udphdr);
>>   		break;
>> +#ifdef CONFIG_NF_CT_PROTO_GRE
>> +	case IPPROTO_GRE:
>> +		*hdrsize = sizeof(struct gre_base_hdr);
>> +		break;
>> +#endif
>>   	default:
>>   		return -1;
>>   	}
>> @@ -545,15 +569,25 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>>   	if (!pskb_may_pull(skb, thoff + *hdrsize))
>>   		return -1;
>>   
>> +	if (nexthdr == IPPROTO_GRE) {
>> +		struct gre_base_hdr *greh;
>> +
>> +		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
>> +		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
>> +			return -1;
>> +	}
>> +
>>   	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
>> -	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>>   
>>   	tuple->src_v6		= ip6h->saddr;
>>   	tuple->dst_v6		= ip6h->daddr;
>> -	tuple->src_port		= ports->source;
>> -	tuple->dst_port		= ports->dest;
>> +	if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP) {
>> +		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>> +		tuple->src_port		= ports->source;
>> +		tuple->dst_port		= ports->dest;
>> +	}
>>   	tuple->l3proto		= AF_INET6;
>> -	tuple->l4proto		= ip6h->nexthdr;
>> +	tuple->l4proto		= nexthdr;
>>   	tuple->iifidx		= dev->ifindex;
>>   	nf_flow_tuple_encap(skb, tuple);
>>   
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index b561e0a..9b81080 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -170,6 +170,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>>   		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
>>   		break;
>>   	case IPPROTO_UDP:
>> +	case IPPROTO_GRE:
>>   		break;
>>   	default:
>>   		return -EOPNOTSUPP;
>> @@ -178,15 +179,19 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>>   	key->basic.ip_proto = tuple->l4proto;
>>   	mask->basic.ip_proto = 0xff;
>>   
>> -	key->tp.src = tuple->src_port;
>> -	mask->tp.src = 0xffff;
>> -	key->tp.dst = tuple->dst_port;
>> -	mask->tp.dst = 0xffff;
>> -
>>   	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
>>   				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
>> -				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
>> -				      BIT(FLOW_DISSECTOR_KEY_PORTS);
>> +				      BIT(FLOW_DISSECTOR_KEY_BASIC);
>> +
>> +	if (tuple->l4proto == IPPROTO_TCP || tuple->l4proto == IPPROTO_UDP) {
>> +		key->tp.src = tuple->src_port;
>> +		mask->tp.src = 0xffff;
>> +		key->tp.dst = tuple->dst_port;
>> +		mask->tp.dst = 0xffff;
>> +
>> +		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
>> index 0af34ad..731b5d8 100644
>> --- a/net/netfilter/nft_flow_offload.c
>> +++ b/net/netfilter/nft_flow_offload.c
>> @@ -298,6 +298,19 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>>   		break;
>>   	case IPPROTO_UDP:
>>   		break;
>> +#ifdef CONFIG_NF_CT_PROTO_GRE
>> +	case IPPROTO_GRE: {
>> +		struct nf_conntrack_tuple *tuple;
>> +
>> +		if (ct->status & IPS_NAT_MASK)
>> +			goto out;
> 
> Why this NAT check?

NAT requires more work. I'd like to start with a minimal GRE support.
Maybe we can add NAT support later.

Toshiaki Makita

>> +		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
>> +		/* No support for GRE v1 */
>> +		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
>> +			goto out;
>> +		break;
>> +	}
>> +#endif
>>   	default:
>>   		goto out;
>>   	}
>> -- 
>> 1.8.3.1
>>
