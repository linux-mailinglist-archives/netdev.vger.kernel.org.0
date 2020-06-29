Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A220E389
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390488AbgF2VPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgF2VO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:14:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F139EC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:14:57 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a14so3864231pfi.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jBLxWz7MJ/wrxKHzf9hck26CtoS+jskY1v23ZWdEq/M=;
        b=Gt8mSXR/r1BZN1Zux60DRK3Z3JbUYvW+FgmeXmFJkd3Y1VsRnkOzS/4JahR87LwZR6
         yi+BMk4GzFhofoXUA5A8VgiVaiQ4306b99PSAVr6E0sRO29AUEjndzPdJv0JYDSANMjC
         N30GF+ZxFY2HpOml/6Hnmk+Q6HmyRNAeAdTTSpC9OJFdybnccw0SqjqZCsy/Fr1BOLJq
         p2atooZOHQ7x3XzhZWS4OqP4MKnJnHWtAWJrHLatGtoJSkBAhwN+kJb4Garpch/QTtbB
         CR+CYKQxlbQMs1Uo3Z2Ca/voLMJv6D6Hbw9TfPsmPS35Izuh63RDAc01pTZJMa+3W53G
         OX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jBLxWz7MJ/wrxKHzf9hck26CtoS+jskY1v23ZWdEq/M=;
        b=f/jMjIni1pRUKzGz1D2BdGBqYIiPNLrTPCYbjJDI7zKwxdMhTuc3dxiM+ou2mECaWp
         AMFb/xY30MqKLos6X9aZtAkUETPE+3Mnrt9lbyyLqufl7L5nnIOfZ3f/iq4drKHiC+Pw
         9ZbZoq6nX+sVmGSYShCkM0en79jnFq5lk3yU1An4hrOUOgYHML5t0mrbfFeNT340oHcf
         vu/2+4IQ7DNhM8NDJqIHZgn5oJZhLBSQqRVt8vvk/WFGRlR5H210ViG3F0xXs0I4PLQq
         /9iLnHlaAFyep3aw5NxvVuifwVyhIgjExdQF2eSOEWo1MJDC4/wor950o4WS9d7C7tRo
         mAyw==
X-Gm-Message-State: AOAM533tQ+M4jK3T/8s2AupEUSjV2GNIQMYlzkq69GtnKvJ8guWUOQ94
        ctqbemf3xCAuFcCyxatK50g=
X-Google-Smtp-Source: ABdhPJzqva0abS/sKc9/XEZoHU9M3pLhPtyyD3AJZlmhX4EB83ang81oPxtyxVicGIBK21FWxJH6Gg==
X-Received: by 2002:a63:d208:: with SMTP id a8mr11816521pgg.351.1593465297517;
        Mon, 29 Jun 2020 14:14:57 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z3sm537285pfz.38.2020.06.29.14.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 14:14:56 -0700 (PDT)
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com>
Date:   Mon, 29 Jun 2020 14:14:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/20 9:57 AM, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> ICMP messages may include an extension structure after the original
> datagram. RFC 4884 standardized this behavior.
> 
> It introduces an explicit original datagram length field in the ICMP
> header to delineate the original datagram from the extension struct.
> 
> Return this field when reading an ICMP error from the error queue.

RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
second word of icmp header.

Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?

Should we add an element in the union to make this a little bit more explicit/readable ?

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -76,6 +76,7 @@ struct icmphdr {
                __be16  sequence;
        } echo;
        __be32  gateway;
+       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
        struct {
                __be16  __unused;
                __be16  mtu;



> 
> ICMPv6 by default already returns the entire 32-bit part of the header
> that includes this field by default. For consistency, do the exact
> same for ICMP. So far it only returns mtu on ICMP_FRAG_NEEDED and gw
> on ICMP_PARAMETERPROB.
> 
> For backwards compatibility, make this optional, set by setsockopt
> SOL_IP/IP_RECVERR_RFC4884. For API documentation and feature test, see
> https://github.com/wdebruij/kerneltools/blob/master/tests/recv_icmp.c
> 
> Alternative implementation to reading from the skb in ip_icmp_error
> is to pass the field from icmp_unreach, again analogous to ICMPv6. But
> this would require changes to every $proto_err() callback, which for
> ICMP_FRAG_NEEDED pass the u32 info arg to a pmtu update function.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/net/inet_sock.h |  1 +
>  include/uapi/linux/in.h |  1 +
>  net/ipv4/ip_sockglue.c  | 12 ++++++++++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index a7ce00af6c44..a3702d1d4875 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -225,6 +225,7 @@ struct inet_sock {
>  				mc_all:1,
>  				nodefrag:1;
>  	__u8			bind_address_no_port:1,
> +				recverr_rfc4884:1,
>  				defer_connect:1; /* Indicates that fastopen_connect is set
>  						  * and cookie exists so we defer connect
>  						  * until first data frame is written
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index 8533bf07450f..3d0d8231dc19 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -123,6 +123,7 @@ struct in_addr {
>  #define IP_CHECKSUM	23
>  #define IP_BIND_ADDRESS_NO_PORT	24
>  #define IP_RECVFRAGSIZE	25
> +#define IP_RECVERR_RFC4884	26
>  
>  /* IP_MTU_DISCOVER values */
>  #define IP_PMTUDISC_DONT		0	/* Never send DF frames */
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 84ec3703c909..525140e3947c 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -398,6 +398,9 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
>  	if (!skb)
>  		return;
>  
> +	if (inet_sk(sk)->recverr_rfc4884)
> +		info = ntohl(icmp_hdr(skb)->un.gateway);

ntohl(icmp_hdr(skb)->un.second_word);

> +
>  	serr = SKB_EXT_ERR(skb);
>  	serr->ee.ee_errno = err;
>  	serr->ee.ee_origin = SO_EE_ORIGIN_ICMP;
> @@ -755,6 +758,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
>  	case IP_RECVORIGDSTADDR:
>  	case IP_CHECKSUM:
>  	case IP_RECVFRAGSIZE:
> +	case IP_RECVERR_RFC4884:
>  		if (optlen >= sizeof(int)) {
>  			if (get_user(val, (int __user *) optval))
>  				return -EFAULT;
> @@ -914,6 +918,11 @@ static int do_ip_setsockopt(struct sock *sk, int level,
>  		if (!val)
>  			skb_queue_purge(&sk->sk_error_queue);
>  		break;
> +	case IP_RECVERR_RFC4884:
> +		if (val != 0 && val != 1)
> +			goto e_inval;
> +		inet->recverr_rfc4884 = val;
> +		break;
>  	case IP_MULTICAST_TTL:
>  		if (sk->sk_type == SOCK_STREAM)
>  			goto e_inval;
> @@ -1588,6 +1597,9 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
>  	case IP_RECVERR:
>  		val = inet->recverr;
>  		break;
> +	case IP_RECVERR_RFC4884:
> +		val = inet->recverr_rfc4884;
> +		break;
>  	case IP_MULTICAST_TTL:
>  		val = inet->mc_ttl;
>  		break;
> 
