Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739292CF9D4
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 06:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgLEFpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 00:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgLEFpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 00:45:11 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB75DC061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 21:44:30 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id y24so7478934otk.3
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 21:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=853fbmkw3RfwdMXQqzgr2QHt7c/+CH8BQS657/7722E=;
        b=XN1egDH+BX+IaHbDuxazM8TvQTrUduZzq6RB7dnVQgrMGaxoiBdaoZ1BGTDTCRbw+1
         F7aMlZ/yZRydn/zcBAoUbnfTqMPu7BiNTs5Y19Y3KIFqYvninluWg0TZMyB8EW9BGPWQ
         jmt6Za6T8JYfWnWWpvC/g3MCVVLo5ya8R8kNwFDJBc+JGrcqRoPJ+f0gVwhYC0U29DDW
         9ayfciMb1Fo2VzSV42LPtPlGMh4C5i5YPXExhn2NvUPm5NAbNvwdowzFv4Z5Nh3U04GH
         8Sd9W3/gv4zonjiZ4S2KJWtqar/xQccgpK4yaKKSK/Nfmrs1BoJEFQsgFh1FpI6uHLYe
         P8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=853fbmkw3RfwdMXQqzgr2QHt7c/+CH8BQS657/7722E=;
        b=X9KuPnQf+V7yYFm3IOS0D+6bTvSA7MCnRlz78gvt3JxQZ878O3eaqMbkJvgWVaPf3k
         gS8djPoMdn4WFY5Rvhs3u3aNSgM+oDmAYCykr6l8a0DWJAPQac/bBQTc6kKmRfJEkQfN
         zBJIs+9vEi24vF3FKAoOeXcqmWxtB5KDA3i2FJq/bKsUhT+hokoZcCLDET4y82wMDWIW
         BC7XGj29OLDDNmOukRjTmFD+yz36gzN4IC0sWKC+tE4DObKkIdjQ47v0ze54ewGhvnuD
         NDezamSvxABsWTkGNaIpcvSOUziGPjY15ChJyJsvkADlF+ZMR5wqn1jTCU3HPEavwrTd
         JUCg==
X-Gm-Message-State: AOAM532DVp3xpobaX1rYpqTRDTQwhYbMKfrGGXIzrtvdk5OG6sjGIheF
        rjZCmIiPjzpVvWOnRD69pjYF6uG/JKU=
X-Google-Smtp-Source: ABdhPJxk1caSTkb6QoYhJ3nCXe4jxIkBgh+zD9FJKE8/118v/pMBehLY/KQDKxGTTO0ezeal+9vmSg==
X-Received: by 2002:a05:6830:1e1c:: with SMTP id s28mr2052otr.82.1607147070097;
        Fri, 04 Dec 2020 21:44:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id v8sm1163840otp.10.2020.12.04.21.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 21:44:29 -0800 (PST)
Subject: Re: [PATCH net-next 6/6] icmp: add response to RFC 8335 PROBE
 messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
 <403b12364707f6e579b91927799c505867336bb3.1607050389.git.andreas.a.roeseler@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b467f650-54b6-32c7-4cf1-9fd519c2488f@gmail.com>
Date:   Fri, 4 Dec 2020 22:44:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <403b12364707f6e579b91927799c505867336bb3.1607050389.git.andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/20 8:17 PM, Andreas Roeseler wrote:
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 005faea415a4..313061b60387 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -984,20 +984,121 @@ static bool icmp_redirect(struct sk_buff *skb)
>  static bool icmp_echo(struct sk_buff *skb)
>  {
>  	struct net *net;
> +	struct icmp_bxm icmp_param;
> +	struct net_device *dev;
> +	struct net_device *target_dev;
> +	struct in_ifaddr *ifaddr;
> +	struct inet6_ifaddr *inet6_ifaddr;
> +	struct list_head *position;
> +	struct icmp_extobj_hdr *extobj_hdr;
> +	struct icmp_ext_ctype3_hdr *ctype3_hdr;
> +	__u8 status;

networking coding style is reverse xmas tree — i.e., longest to shortest.


>  
>  	net = dev_net(skb_dst(skb)->dev);
> -	if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> -		struct icmp_bxm icmp_param;
> +	/* should there be an ICMP stat for ignored echos? */
> +	if (net->ipv4.sysctl_icmp_echo_ignore_all)
> +		return true;
> +
> +	icmp_param.data.icmph		= *icmp_hdr(skb);
> +	icmp_param.skb			= skb;
> +	icmp_param.offset		= 0;
> +	icmp_param.data_len		= skb->len;
> +	icmp_param.head_len		= sizeof(struct icmphdr);
>  
> -		icmp_param.data.icmph	   = *icmp_hdr(skb);
> +	if (icmp_param.data.icmph.type == ICMP_ECHO) {
>  		icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> -		icmp_param.skb		   = skb;
> -		icmp_param.offset	   = 0;
> -		icmp_param.data_len	   = skb->len;
> -		icmp_param.head_len	   = sizeof(struct icmphdr);
> -		icmp_reply(&icmp_param, skb);
> +		goto send_reply;
>  	}
> -	/* should there be an ICMP stat for ignored echos? */
> +	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> +		return true;
> +	/* We currently do not support probing off the proxy node */
> +	if ((ntohs(icmp_param.data.icmph.un.echo.sequence) & 1) == 0)
> +		return true;
> +
> +	icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> +	icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> +	extobj_hdr = (struct icmp_extobj_hdr *)(skb->data + sizeof(struct icmp_ext_hdr));
> +	ctype3_hdr = (struct icmp_ext_ctype3_hdr *)(extobj_hdr + 1);
> +	status = 0;
> +	target_dev = NULL;
> +	read_lock(&dev_base_lock);
> +	for_each_netdev(net, dev) {

for_each_netdev needs to be replaced by an appropriate lookup.


> +		switch (extobj_hdr->class_type) {
> +		case CTYPE_NAME:
> +			if (strcmp(dev->name, (char *)(extobj_hdr + 1)) == 0)
> +				goto found_matching_interface;
> +			break;
> +		case CTYPE_INDEX:
> +			if (ntohl(*((uint32_t *)(extobj_hdr + 1))) ==
> +				dev->ifindex)
> +				goto found_matching_interface;
> +			break;
> +		case CTYPE_ADDR:

1. In general, a name lookup is done by __dev_get_by_name /
dev_get_by_name_rcu / dev_get_by_name based on locking. rtnl is not held
in the datapath. Depending on need, you can hold the rcu lock
(rcu_read_lock) and use dev_get_by_name_rcu but you need to make sure
all references to the dev are used before calling rcu_read_unlock.

2. Similarly, lookup by index is done using __dev_get_by_index /
dev_get_by_index_rcu / dev_get_by_index.

3. Address to device lookup is done using something like __ip_dev_find
(IPv4) or ipv6_dev_find (IPv6) - again check the locking needs.


> +			switch (ntohs(ctype3_hdr->afi)) {
> +			/* IPV4 address */
> +			case 1:
> +				ifaddr = dev->ip_ptr->ifa_list;
> +				while (ifaddr) {
> +					if (memcmp(&ifaddr->ifa_address,
> +						   (ctype3_hdr + 1),
> +						   sizeof(ifaddr->ifa_address)) == 0)
> +						goto found_matching_interface;
> +					ifaddr = ifaddr->ifa_next;
> +				}
> +				break;
> +			/* IPV6 address */
> +			case 2:

No magic numbers - if AFI enums do not exist, add them.

