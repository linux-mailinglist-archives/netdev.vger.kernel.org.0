Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6FF1A89FE
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504267AbgDNSoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504258AbgDNSoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:44:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6BEC061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:44:03 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y12so280881pll.2
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dGhWAK8m8T9TIOY0UNf4PQFZKDLJLz/bpJJqkjm/2bc=;
        b=DQUuKO7a9c915BNC+2vW3Zj/Hh/g5JdnuHMwU4jVgffM2VrGmn/NIJH8kCDJ9VequT
         IRSf/Al7tOmYE/ZiK63yMtV4evAun/9TK4vVJC84Q5WmyBadYRxNwIY6O7NGhvZ5amPr
         nmziRPsR48A+BBH0W+9LJ8G/t19i7h3p11qXzdE4fSYKYP6nYg1ZKbmMmvIDki8jmA+c
         wyxsOrvDDVhIlFzPlSnPH0WsqrHtiJrcjoAkh7e2XOZAiFHgDzCIrU2ffm7GZjttn6Mr
         Mefr5v4ormOJ3/YKcW1ozrSTC2AhnpmUX/FNVoZaPadU2HR7HNWv4XDreKBDw40xTewq
         C+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dGhWAK8m8T9TIOY0UNf4PQFZKDLJLz/bpJJqkjm/2bc=;
        b=XJGdgK9dC+csf01BPoSTm4NG6ne54KUthjS5hGroXKlmaTfRjCPlfiw6N/beI9F++y
         JI9XGzmNs3oHvUSvsRimL27FLHy11kZtwu1sAnrs9Ni0MZr6IyDFOyoozlCvKfqZTVXS
         A0zVoPQmHM/EI0KDEJd5L9KG72NadMJufHHvMHcHVu04r/lXFU9FdZU/05ha8w9rE1oy
         BC5kirpTjyhbx7nfxdg9150tebRAmf+U019AnfNAwKTpy5OZb46TnXzqsQacYCX5FdsN
         TJzi3xVUHmj+0xxiiOLnWVbbpQpHIgh5S5EA0NCMg1wATTLZMIHE2LufQU+JQuMo4drp
         JxqQ==
X-Gm-Message-State: AGi0PuYAeESSt0r7DDDyUYo7+xeL+fVtgLhKjZsqfNW+e9K66u38W4sL
        4f7J7e1u9G9H/Q4yxO4byxLLP6vc
X-Google-Smtp-Source: APiQypLI3VrNqxYE0Q8AFqYtrHghStag3lrHxoGMnXGPZI6zseRp67mtRVlXeZUeOYOnKAafk3tkbw==
X-Received: by 2002:a17:90b:90e:: with SMTP id bo14mr1694249pjb.104.1586889842790;
        Tue, 14 Apr 2020 11:44:02 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o40sm11085293pjb.18.2020.04.14.11.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 11:44:01 -0700 (PDT)
Subject: Re: [PATCH v3] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
To:     =?UTF-8?B?TGXFn2UgRG9ydSBDxINsaW4=?= <lesedorucalin01@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20200414090925.GA10402@white>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f5245714-c088-fd91-de4c-6ff7decbf552@gmail.com>
Date:   Tue, 14 Apr 2020 11:43:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414090925.GA10402@white>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/20 2:09 AM, Leşe Doru Călin wrote:
> In this year's edition of GSoC, there is a project idea for CRIU to add 
> support for checkpoint/restore of cork-ed UDP sockets. But to add it, the
> kernel API needs to be extended.
> 
> This is what this patch does. It adds UDP "repair mode" for UDP sockets in 
> a similar approach to the TCP "repair mode", but only the send queue is
> necessary to be retrieved. So the patch extends the recv and setsockopt 
> syscalls. Using UDP_REPAIR option in setsockopt, caller can set the socket
> in repair mode. If it is setted, the recv/recvfrom/recvmsg will receive the
> write queue and the destination of the data. As in the TCP mode, to change 
> the repair mode requires the CAP_NET_ADMIN capability and to receive data 
> the caller is obliged to use the MSG_PEEK flag.
> 
> Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
> ---
>  include/linux/udp.h      |  3 ++-
>  include/uapi/linux/udp.h |  1 +
>  net/ipv4/udp.c           | 55 ++++++++++++++++++++++++++++++++++++++++
>  net/ipv6/udp.c           | 45 ++++++++++++++++++++++++++++++++
>  4 files changed, 103 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index aa84597bdc33..b22bd70118ce 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -51,7 +51,8 @@ struct udp_sock {
>  					   * different encapsulation layer set
>  					   * this
>  					   */
> -			 gro_enabled:1;	/* Can accept GRO packets */
> +			 gro_enabled:1,	/* Can accept GRO packets */
> +			 repair:1;/* Receive the send queue */
>  	/*
>  	 * Following member retains the information to create a UDP header
>  	 * when the socket is uncorked.
> diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
> index 4828794efcf8..2fe78329d6da 100644
> --- a/include/uapi/linux/udp.h
> +++ b/include/uapi/linux/udp.h
> @@ -29,6 +29,7 @@ struct udphdr {
>  
>  /* UDP socket options */
>  #define UDP_CORK	1	/* Never send partially complete segments */
> +#define UDP_REPAIR  19  /* Receive the send queue */
>  #define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
>  #define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
>  #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 32564b350823..dc9d15d564d6 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1720,6 +1720,28 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
>  }
>  EXPORT_SYMBOL(__skb_recv_udp);
>  
> +static int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> +{
> +	int copy, copied = 0, err = 0;
> +	struct sk_buff *skb;
> +
> +	skb_queue_walk(&sk->sk_write_queue, skb) {
> +		copy = len - copied;
> +		if (copy > skb->len - off)
> +			copy = skb->len - off;
> +
> +		err = skb_copy_datagram_msg(skb, off, msg, copy);
> +		if (err)
> +			break;
> +
> +		copied += copy;
> +
> +		if (len <= copied)
> +			break;
> +	}
> +	return err ?: copied;
> +}
> +
>  /*
>   * 	This should be easy, if there is something there we
>   * 	return it, otherwise we block.
> @@ -1729,8 +1751,10 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  		int flags, int *addr_len)
>  {
>  	struct inet_sock *inet = inet_sk(sk);
> +	struct udp_sock *up = udp_sk(sk);
>  	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
>  	struct sk_buff *skb;
> +	struct flowi4 *fl4;
>  	unsigned int ulen, copied;
>  	int off, err, peeking = flags & MSG_PEEK;
>  	int is_udplite = IS_UDPLITE(sk);
> @@ -1739,6 +1763,12 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  	if (flags & MSG_ERRQUEUE)
>  		return ip_recv_error(sk, msg, len, addr_len);
>  
> +	if (unlikely(up->repair)) {

Socket lock is not held, disaster seems possible :/

> +		if (!peeking)
> +			return -EPERM;
> +		goto recv_sndq;
> +	}
> +


Really, I would rather stop adding code in fast path for REPAIR stuff.

A new setsockopt() would be much better I think.

>  try_again:
>  	off = sk_peek_offset(sk, flags);
>  	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
> @@ -1832,6 +1862,18 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  	cond_resched();
>  	msg->msg_flags &= ~MSG_TRUNC;
>  	goto try_again;
> +
> +recv_sndq:
> +	off = sizeof(struct iphdr) + sizeof(struct udphdr);
> +	if (sin) {
> +		fl4 = &inet->cork.fl.u.ip4;
> +		sin->sin_family = AF_INET;
> +		sin->sin_port = fl4->fl4_dport;
> +		sin->sin_addr.s_addr = fl4->daddr;
> +		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
> +		*addr_len = sizeof(*sin);
> +	}
> +	return udp_peek_sndq(sk, msg, off, len);
>  }
>  
>  int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> @@ -2557,6 +2599,15 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
>  		}
>  		break;
>  
> +	case UDP_REPAIR:
> +		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> +			err = -EPERM;
> +		else if (val != 0)
> +			up->repair = 1;
> +		else
> +			up->repair = 0;
> +		break;
> +
>  	case UDP_ENCAP:
>  		switch (val) {
>  		case 0:
> @@ -2678,6 +2729,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
>  		val = up->corkflag;
>  		break;
>  
> +	case UDP_REPAIR:
> +		val = up->repair;
> +		break;
> +
>  	case UDP_ENCAP:
>  		val = up->encap_type;
>  		break;
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 7d4151747340..ec653f9fce2d 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -250,6 +250,28 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
>  EXPORT_SYMBOL_GPL(udp6_lib_lookup);
>  #endif
>  
> +static int udp6_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> +{
> +	int copy, copied = 0, err = 0;
> +	struct sk_buff *skb;
> +
> +	skb_queue_walk(&sk->sk_write_queue, skb) {
> +		copy = len - copied;
> +		if (copy > skb->len - off)
> +			copy = skb->len - off;
> +
> +		err = skb_copy_datagram_msg(skb, off, msg, copy);
> +		if (err)
> +			break;
> +
> +		copied += copy;
> +
> +		if (len <= copied)
> +			break;
> +	}
> +	return err ?: copied;
> +}
> +
>  /* do not use the scratch area len for jumbogram: their length execeeds the
>   * scratch area space; note that the IP6CB flags is still in the first
>   * cacheline, so checking for jumbograms is cheap
> @@ -269,7 +291,9 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  {
>  	struct ipv6_pinfo *np = inet6_sk(sk);
>  	struct inet_sock *inet = inet_sk(sk);
> +	struct udp_sock *up = udp_sk(sk);
>  	struct sk_buff *skb;
> +	struct flowi6 *fl6;
>  	unsigned int ulen, copied;
>  	int off, err, peeking = flags & MSG_PEEK;
>  	int is_udplite = IS_UDPLITE(sk);
> @@ -283,6 +307,12 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
>  		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
>  
> +	if (unlikely(up->repair)) {
> +		if (!peeking)
> +			return -EPERM;
> +		goto recv_sndq;
> +	}
> +
>  try_again:
>  	off = sk_peek_offset(sk, flags);
>  	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
> @@ -394,6 +424,21 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  	cond_resched();
>  	msg->msg_flags &= ~MSG_TRUNC;
>  	goto try_again;
> +
> +recv_sndq:
> +	off = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
> +	if (msg->msg_name) {
> +		DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
> +
> +		fl6 = &inet->cork.fl.u.ip6;
> +		sin6->sin6_family = AF_INET6;
> +		sin6->sin6_port = fl6->fl6_dport;
> +		sin6->sin6_flowinfo = 0;
> +		sin6->sin6_addr = fl6->daddr;
> +		sin6->sin6_scope_id = fl6->flowi6_oif;
> +		*addr_len = sizeof(*sin6);
> +	}
> +	return udp6_peek_sndq(sk, msg, off, len);
>  }
>  
>  DEFINE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
> 
