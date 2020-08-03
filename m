Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E7723B131
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgHCXoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgHCXoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:44:20 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E3DC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 16:44:20 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id a19so12220315qvy.3
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GzkYeTQTSoKA+WqHVpSPWmDat9tjhIJHTo8F1mSdmUE=;
        b=WoAP2TO9Y6Rxwn28FxcYN7kcEWI+Hl9z1/7qaDChtTskz1QbkKJJ6qve/Iwo04vJn5
         2lEXXzRXs5FUJIEsQ6xC7aFwAZjL2iiOJdarPb+L5cNr6Nw8jz+qSmIyWRZaE6J0rf7O
         Aiw7O+P4t/xPezQ7/yrq6PWGQAb+CBnyXX6x55fQtjyTCQAYADh9xkM54smOGUSVRQzh
         XzeXdJvwzaFU56qn4qaVUcprKEbVHi/6YWWZzPP7Yi//07vfdrjRNdVBXMvUYfqKDkFI
         LlKi/TkjR2E7HNgbUowoK/68EBRkjesgcvCFHPOOV9tw5voMQkSfZtpxXkGzOU6UvBqZ
         8yMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GzkYeTQTSoKA+WqHVpSPWmDat9tjhIJHTo8F1mSdmUE=;
        b=iCRl9yFM1hpubph4WlwzF0O7GSR7Mglb0YrROdFQR4bbLhiK3/5TzOdgMz1qK0//jQ
         Xfz176wjh5N+jboyUzLZ3NOi3DwRjk2UdMueK1H+XIFZIvJlt4QNk+cww4rFX0pIlG9l
         NyApNAcyQdGL/6GcjLkIWyKva4Ik8KQ6f2kBTAdnt5RBJCHcbMy2XYLCp53tXSVnueIR
         LlC++fiXwsFNCjw4nERrLIGksxJ9vL7BmgRM9YNtRDxIqw0/455f0XZqfF5nAT99ILtq
         7vhJMm/AbBNfgdGS0wV+t4w51X9MbJpJOVlyp60Lkfc8+IuyCblbRqqDhRghh3L3L4jx
         U0nQ==
X-Gm-Message-State: AOAM533AAJdki0NmhXH+ddvy9Eq+GTa9dwLTFm/Th8hIg4mlyCGNtVL1
        nQseCq/XQeYqo00E/a5AYwdln4cH
X-Google-Smtp-Source: ABdhPJxEs2c3XcPfKfXqh8Zkw8To624QN2nyTDlWttcFzn6CJcuOLwofuAQ+EGXdnnziC0trq+Btnw==
X-Received: by 2002:ad4:4a27:: with SMTP id n7mr19484727qvz.184.1596498258796;
        Mon, 03 Aug 2020 16:44:18 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c16b:8bf3:e3ba:8c79? ([2601:282:803:7700:c16b:8bf3:e3ba:8c79])
        by smtp.googlemail.com with ESMTPSA id q34sm6536130qtk.32.2020.08.03.16.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:44:18 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] tunnels: PMTU discovery support for directly
 bridged IP packets
To:     Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
References: <cover.1596487323.git.sbrivio@redhat.com>
 <c7b3e4800ea02d964bab7dd9f349e0a0720bff2d.1596487323.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6978999-4f05-5e87-2964-bec444221cf5@gmail.com>
Date:   Mon, 3 Aug 2020 17:44:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <c7b3e4800ea02d964bab7dd9f349e0a0720bff2d.1596487323.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 2:52 PM, Stefano Brivio wrote:
> @@ -461,6 +464,91 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
>  	}
>  }
>  
> +/**
> + * skb_tunnel_check_pmtu() - Check, update PMTU and trigger ICMP reply as needed
> + * @skb:	Buffer being sent by encapsulation, L2 headers expected
> + * @encap_dst:	Destination for tunnel encapsulation (outer IP)
> + * @headroom:	Encapsulation header size, bytes
> + * @reply:	Build matching ICMP or ICMPv6 message as a result
> + *
> + * L2 tunnel implementations that can carry IP and can be directly bridged
> + * (currently UDP tunnels) can't always rely on IP forwarding paths to handle
> + * PMTU discovery. In the bridged case, ICMP or ICMPv6 messages need to be built
> + * based on payload and sent back by the encapsulation itself.
> + *
> + * For routable interfaces, we just need to update the PMTU for the destination.
> + *
> + * Return: 0 if ICMP error not needed, length if built, negative value on error
> + */
> +static inline int skb_tunnel_check_pmtu(struct sk_buff *skb,
> +					struct dst_entry *encap_dst,
> +					int headroom, bool reply)

Given its size, this is probably better as a function. I believe it can
go into net/ipv4/ip_tunnel_core.c like you have iptunnel_pmtud_build_icmp.


> +{
> +	u32 mtu = dst_mtu(encap_dst) - headroom;
> +
> +	if ((skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu)) ||
> +	    (!skb_is_gso(skb) && (skb->len - skb_mac_header_len(skb)) <= mtu))
> +		return 0;
> +
> +	skb_dst_update_pmtu_no_confirm(skb, mtu);
> +
> +	if (!reply || skb->pkt_type == PACKET_HOST)
> +		return 0;
> +
> +	if (skb->protocol == htons(ETH_P_IP) && mtu > 576) {

I am surprised the 576 does not have an existing macro.

> +		const struct icmphdr *icmph = icmp_hdr(skb);
> +		const struct iphdr *iph = ip_hdr(skb);
> +
> +		if (iph->frag_off != htons(IP_DF) ||
> +		    ipv4_is_lbcast(iph->daddr) ||
> +		    ipv4_is_multicast(iph->daddr) ||
> +		    ipv4_is_zeronet(iph->saddr) ||
> +		    ipv4_is_loopback(iph->saddr) ||
> +		    ipv4_is_lbcast(iph->saddr) ||
> +		    ipv4_is_multicast(iph->saddr) ||
> +		    (iph->protocol == IPPROTO_ICMP && icmp_is_err(icmph->type)))
> +			return 0;
> +
> +		return iptunnel_pmtud_build_icmp(skb, mtu);
> +	}
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (skb->protocol == htons(ETH_P_IPV6) && mtu > IPV6_MIN_MTU) {
> +		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +		int stype = ipv6_addr_type(&ip6h->saddr);
> +		u8 proto = ip6h->nexthdr;
> +		__be16 frag_off;
> +		int offset;
> +
> +		if (stype == IPV6_ADDR_ANY || stype == IPV6_ADDR_MULTICAST ||
> +		    stype == IPV6_ADDR_LOOPBACK)
> +			return 0;
> +
> +		offset = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto,
> +					  &frag_off);
> +		if (offset < 0 || (frag_off & htons(~0x7)))
> +			return 0;
> +
> +		if (proto == IPPROTO_ICMPV6) {
> +			struct icmp6hdr *icmp6h;
> +
> +			if (!pskb_may_pull(skb, (skb_network_header(skb) +
> +						 offset + 1 - skb->data)))
> +				return 0;
> +
> +			icmp6h = (struct icmp6hdr *)(skb_network_header(skb) +
> +						     offset);
> +			if (icmpv6_is_err(icmp6h->icmp6_type) ||
> +			    icmp6h->icmp6_type == NDISC_REDIRECT)
> +				return 0;
> +		}
> +
> +		return iptunnel_pmtud_build_icmp(skb, mtu);
> +	}
> +#endif


separate v4 and v6 code into helpers based on skb->protocol; the mtu
check then becomes part of the version specific helpers.

> +	return 0;
> +}
> +
>  static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
>  {
>  	return info + 1;
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index f8b419e2475c..54a3dbf7f512 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -184,6 +184,128 @@ int iptunnel_handle_offloads(struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL_GPL(iptunnel_handle_offloads);
>  
> +/**
> + * iptunnel_pmtud_build_icmp() - Build ICMP or ICMPv6 error message for PMTUD
> + * @skb:	Original packet with L2 header
> + * @mtu:	MTU value for ICMP or ICMPv6 error
> + *
> + * Return: length on success, negative error code if message couldn't be built.
> + */
> +int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
> +{
> +	struct ethhdr eh;
> +	int len, err;
> +
> +	if (skb->protocol == htons(ETH_P_IP))
> +		len = ETH_HLEN + sizeof(struct iphdr);
> +	else if (IS_ENABLED(CONFIG_IPV6) && skb->protocol == htons(ETH_P_IPV6))
> +		len = ETH_HLEN + sizeof(struct ipv6hdr);
> +	else
> +		return 0;
> +
> +	if (!pskb_may_pull(skb, len))
> +		return -EINVAL;
> +
> +	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
> +	pskb_pull(skb, ETH_HLEN);
> +	skb_reset_network_header(skb);
> +
> +	if (skb->protocol == htons(ETH_P_IP)) {
> +		const struct iphdr *iph = ip_hdr(skb);
> +		struct icmphdr *icmph;
> +		struct iphdr *niph;
> +
> +		err = pskb_trim(skb, 576 - sizeof(*niph) - sizeof(*icmph));
> +		if (err)
> +			return err;
> +
> +		len = skb->len + sizeof(*icmph);
> +		err = skb_cow(skb, sizeof(*niph) + sizeof(*icmph) + ETH_HLEN);
> +		if (err)
> +			return err;
> +
> +		icmph = skb_push(skb, sizeof(*icmph));
> +		*icmph = (struct icmphdr) {
> +			.type			= ICMP_DEST_UNREACH,
> +			.code			= ICMP_FRAG_NEEDED,
> +			.checksum		= 0,
> +			.un.frag.__unused	= 0,
> +			.un.frag.mtu		= ntohs(mtu),
> +		};
> +		icmph->checksum = ip_compute_csum(icmph, len);
> +		skb_reset_transport_header(skb);
> +
> +		niph = skb_push(skb, sizeof(*niph));
> +		*niph = (struct iphdr) {
> +			.ihl			= sizeof(*niph) / 4u,
> +			.version 		= 4,
> +			.tos 			= 0,
> +			.tot_len		= htons(len + sizeof(*niph)),
> +			.id			= 0,
> +			.frag_off		= htons(IP_DF),
> +			.ttl			= iph->ttl,
> +			.protocol		= IPPROTO_ICMP,
> +			.saddr			= iph->daddr,
> +			.daddr			= iph->saddr,
> +		};
> +		ip_send_check(niph);
> +	}
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +	else if (skb->protocol == htons(ETH_P_IPV6)) {
> +		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +		struct icmp6hdr *icmp6h;
> +		struct ipv6hdr *nip6h;
> +		__wsum csum;
> +
> +		err = pskb_trim(skb, IPV6_MIN_MTU -
> +				     sizeof(*nip6h) - sizeof(*icmp6h));
> +		if (err)
> +			return err;
> +
> +		len = skb->len + sizeof(*icmp6h);
> +		err = skb_cow(skb, sizeof(*nip6h) + sizeof(*icmp6h) + ETH_HLEN);
> +		if (err)
> +			return err;
> +
> +		icmp6h = skb_push(skb, sizeof(*icmp6h));
> +		*icmp6h = (struct icmp6hdr) {
> +			.icmp6_type		= ICMPV6_PKT_TOOBIG,
> +			.icmp6_code		= 0,
> +			.icmp6_cksum		= 0,
> +			.icmp6_mtu		= htonl(mtu),
> +		};
> +		skb_reset_transport_header(skb);
> +
> +		nip6h = skb_push(skb, sizeof(*nip6h));
> +		*nip6h = (struct ipv6hdr) {
> +			.priority		= 0,
> +			.version		= 6,
> +			.flow_lbl		= { 0 },
> +			.payload_len		= htons(len),
> +			.nexthdr		= IPPROTO_ICMPV6,
> +			.hop_limit		= ip6h->hop_limit,
> +			.saddr			= ip6h->daddr,
> +			.daddr			= ip6h->saddr,
> +		};
> +
> +		csum = csum_partial(icmp6h, len, 0);
> +		icmp6h->icmp6_cksum = csum_ipv6_magic(&nip6h->saddr,
> +						      &nip6h->daddr, len,
> +						      IPPROTO_ICMPV6, csum);
> +	}
> +#endif
> +
> +	skb_reset_network_header(skb);
> +	skb->ip_summed = CHECKSUM_NONE;
> +
> +	eth_header(skb, skb->dev, htons(eh.h_proto), eh.h_source, eh.h_dest, 0);
> +	skb_reset_mac_header(skb);
> +
> +	return skb->len;
> +}
> +EXPORT_SYMBOL(iptunnel_pmtud_build_icmp);

I think separate v4 and v6 versions would be more readable; the
duplication is mostly skb manipulation.
