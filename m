Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF131A8E94
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391973AbgDNW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391947AbgDNW1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 18:27:53 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B21C061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 15:27:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f13so16458253wrm.13
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 15:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZgJpVzWjv2/ZrpsimyFCOTAickfRqJg/npiQg/ZTJ2k=;
        b=ojS1F+HMQ6TCIHlTctOSiMHfi+ohonQe9nOaQbWm/rD1652unosSkGjfKc++c8UU2W
         spyZ4uk2AXMG8WCiWxhn9vobdKdLOnAwQJEJYzQow6p5Ie9hFWIlgtmB+ypx5VN7U/k1
         Ci9lQwvv7f/U6dMp6Uspl25U4y+Mvn3HTloh9unZf2IpFwR4V5unzJ/FWrs5aYayFlcP
         GnqBZAxcboF3tq3m+8tDZXQluTAhstACOM9aBWd8wsqrOxEJQg8xnc121JPFxolo48Mb
         qFSZ+uxNlaZwuctzHLfWXc0kFxJO4LvyKK9TNfp08BOOa+klcl0/xfJUY2PFjhTWAFQF
         khhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZgJpVzWjv2/ZrpsimyFCOTAickfRqJg/npiQg/ZTJ2k=;
        b=hfPb1cZOJ0HBwDtfeltY7Ia9Rhhk4s6XoSpmZIzaOpbjJRwKOOcuspFmWxa3FsgBzT
         KPvvT2UYzpo5OiULO8X7h27dhrIW2agugAxfejEHQey8EBlpgj2ItdW4PJVOU31cIcZZ
         P2sZIN4ker6Dq2U/9+be6xoV+d9LqFrSOuhhDPF5D9eqYOoK2wcZpIjNLhE6YIf1IpdT
         p7BYeoHSfja9w9UkWOfbh64QpnaidAU2NLhkB0/3D+XBlBfXUV0JYWK+HS+DxmI85rBV
         u+Qi1LzhJPLcmt+9vCxA41vc44S6Y1Sy2+Qtu0GGqH9Un6O7h+2tkmp5kD21SyXf0t5H
         YkWg==
X-Gm-Message-State: AGi0PuYGI2GU37/nTAdQgCBl6tADww0XkM3VwPpejCzpEF5xlBJFZUkl
        9KGubMQ78JrSorS4/4c5Egw=
X-Google-Smtp-Source: APiQypL1YxACDI8A2eHe2FVGP2V4pl0/+T+HH0aXwa+RrgN9rWvtfqGXdKMZAZ821/kOZ433SyVP0g==
X-Received: by 2002:adf:a345:: with SMTP id d5mr22579668wrb.23.1586903271726;
        Tue, 14 Apr 2020 15:27:51 -0700 (PDT)
Received: from white ([2a02:2f01:8515:ef00:146c:7647:7e6f:9c9b])
        by smtp.gmail.com with ESMTPSA id w17sm12363935wru.20.2020.04.14.15.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 15:27:51 -0700 (PDT)
Date:   Wed, 15 Apr 2020 01:27:49 +0300
From:   =?utf-8?B?TGXFn2UgRG9ydSBDxINsaW4=?= <lesedorucalin01@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
Message-ID: <20200414222749.GA22558@white>
References: <20200414090925.GA10402@white>
 <f5245714-c088-fd91-de4c-6ff7decbf552@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5245714-c088-fd91-de4c-6ff7decbf552@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 11:43:59AM -0700, Eric Dumazet wrote:
> 
> 
> On 4/14/20 2:09 AM, Lese Doru Calin wrote:
> > In this year's edition of GSoC, there is a project idea for CRIU to add 
> > support for checkpoint/restore of cork-ed UDP sockets. But to add it, the
> > kernel API needs to be extended.
> > 
> > This is what this patch does. It adds UDP "repair mode" for UDP sockets in 
> > a similar approach to the TCP "repair mode", but only the send queue is
> > necessary to be retrieved. So the patch extends the recv and setsockopt 
> > syscalls. Using UDP_REPAIR option in setsockopt, caller can set the socket
> > in repair mode. If it is setted, the recv/recvfrom/recvmsg will receive the
> > write queue and the destination of the data. As in the TCP mode, to change 
> > the repair mode requires the CAP_NET_ADMIN capability and to receive data 
> > the caller is obliged to use the MSG_PEEK flag.
> > 
> > Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
> > ---
> >  include/linux/udp.h      |  3 ++-
> >  include/uapi/linux/udp.h |  1 +
> >  net/ipv4/udp.c           | 55 ++++++++++++++++++++++++++++++++++++++++
> >  net/ipv6/udp.c           | 45 ++++++++++++++++++++++++++++++++
> >  4 files changed, 103 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/udp.h b/include/linux/udp.h
> > index aa84597bdc33..b22bd70118ce 100644
> > --- a/include/linux/udp.h
> > +++ b/include/linux/udp.h
> > @@ -51,7 +51,8 @@ struct udp_sock {
> >  					   * different encapsulation layer set
> >  					   * this
> >  					   */
> > -			 gro_enabled:1;	/* Can accept GRO packets */
> > +			 gro_enabled:1,	/* Can accept GRO packets */
> > +			 repair:1;/* Receive the send queue */
> >  	/*
> >  	 * Following member retains the information to create a UDP header
> >  	 * when the socket is uncorked.
> > diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
> > index 4828794efcf8..2fe78329d6da 100644
> > --- a/include/uapi/linux/udp.h
> > +++ b/include/uapi/linux/udp.h
> > @@ -29,6 +29,7 @@ struct udphdr {
> >  
> >  /* UDP socket options */
> >  #define UDP_CORK	1	/* Never send partially complete segments */
> > +#define UDP_REPAIR  19  /* Receive the send queue */
> >  #define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
> >  #define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
> >  #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 32564b350823..dc9d15d564d6 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1720,6 +1720,28 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
> >  }
> >  EXPORT_SYMBOL(__skb_recv_udp);
> >  
> > +static int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> > +{
> > +	int copy, copied = 0, err = 0;
> > +	struct sk_buff *skb;
> > +
> > +	skb_queue_walk(&sk->sk_write_queue, skb) {
> > +		copy = len - copied;
> > +		if (copy > skb->len - off)
> > +			copy = skb->len - off;
> > +
> > +		err = skb_copy_datagram_msg(skb, off, msg, copy);
> > +		if (err)
> > +			break;
> > +
> > +		copied += copy;
> > +
> > +		if (len <= copied)
> > +			break;
> > +	}
> > +	return err ?: copied;
> > +}
> > +
> >  /*
> >   * 	This should be easy, if there is something there we
> >   * 	return it, otherwise we block.
> > @@ -1729,8 +1751,10 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
> >  		int flags, int *addr_len)
> >  {
> >  	struct inet_sock *inet = inet_sk(sk);
> > +	struct udp_sock *up = udp_sk(sk);
> >  	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
> >  	struct sk_buff *skb;
> > +	struct flowi4 *fl4;
> >  	unsigned int ulen, copied;
> >  	int off, err, peeking = flags & MSG_PEEK;
> >  	int is_udplite = IS_UDPLITE(sk);
> > @@ -1739,6 +1763,12 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
> >  	if (flags & MSG_ERRQUEUE)
> >  		return ip_recv_error(sk, msg, len, addr_len);
> >  
> > +	if (unlikely(up->repair)) {
> 
> Socket lock is not held, disaster seems possible :/
> 

I missed that. Sorry.

> > +		if (!peeking)
> > +			return -EPERM;
> > +		goto recv_sndq;
> > +	}
> > +
> 
> 
> Really, I would rather stop adding code in fast path for REPAIR stuff.
> 
> A new setsockopt() would be much better I think.
> 

I could implement it as a option for getsockopt syscall, with a pointer to a 
buffer or a user_msghdr as a parameter, so that other syscalls are not affected.

> >  try_again:
> >  	off = sk_peek_offset(sk, flags);
> >  	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
> > @@ -1832,6 +1862,18 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
> >  	cond_resched();
> >  	msg->msg_flags &= ~MSG_TRUNC;
> >  	goto try_again;
> > +
> > +recv_sndq:
> > +	off = sizeof(struct iphdr) + sizeof(struct udphdr);
> > +	if (sin) {
> > +		fl4 = &inet->cork.fl.u.ip4;
> > +		sin->sin_family = AF_INET;
> > +		sin->sin_port = fl4->fl4_dport;
> > +		sin->sin_addr.s_addr = fl4->daddr;
> > +		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
> > +		*addr_len = sizeof(*sin);
> > +	}
> > +	return udp_peek_sndq(sk, msg, off, len);
> >  }
> >  
> >  int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > @@ -2557,6 +2599,15 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
> >  		}
> >  		break;
> >  
> > +	case UDP_REPAIR:
> > +		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> > +			err = -EPERM;
> > +		else if (val != 0)
> > +			up->repair = 1;
> > +		else
> > +			up->repair = 0;
> > +		break;
> > +
> >  	case UDP_ENCAP:
> >  		switch (val) {
> >  		case 0:
> > @@ -2678,6 +2729,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
> >  		val = up->corkflag;
> >  		break;
> >  
> > +	case UDP_REPAIR:
> > +		val = up->repair;
> > +		break;
> > +
> >  	case UDP_ENCAP:
> >  		val = up->encap_type;
> >  		break;
> > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > index 7d4151747340..ec653f9fce2d 100644
> > --- a/net/ipv6/udp.c
> > +++ b/net/ipv6/udp.c
> > @@ -250,6 +250,28 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
> >  EXPORT_SYMBOL_GPL(udp6_lib_lookup);
> >  #endif
> >  
> > +static int udp6_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> > +{
> > +	int copy, copied = 0, err = 0;
> > +	struct sk_buff *skb;
> > +
> > +	skb_queue_walk(&sk->sk_write_queue, skb) {
> > +		copy = len - copied;
> > +		if (copy > skb->len - off)
> > +			copy = skb->len - off;
> > +
> > +		err = skb_copy_datagram_msg(skb, off, msg, copy);
> > +		if (err)
> > +			break;
> > +
> > +		copied += copy;
> > +
> > +		if (len <= copied)
> > +			break;
> > +	}
> > +	return err ?: copied;
> > +}
> > +
> >  /* do not use the scratch area len for jumbogram: their length execeeds the
> >   * scratch area space; note that the IP6CB flags is still in the first
> >   * cacheline, so checking for jumbograms is cheap
> > @@ -269,7 +291,9 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> >  {
> >  	struct ipv6_pinfo *np = inet6_sk(sk);
> >  	struct inet_sock *inet = inet_sk(sk);
> > +	struct udp_sock *up = udp_sk(sk);
> >  	struct sk_buff *skb;
> > +	struct flowi6 *fl6;
> >  	unsigned int ulen, copied;
> >  	int off, err, peeking = flags & MSG_PEEK;
> >  	int is_udplite = IS_UDPLITE(sk);
> > @@ -283,6 +307,12 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> >  	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
> >  		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
> >  
> > +	if (unlikely(up->repair)) {
> > +		if (!peeking)
> > +			return -EPERM;
> > +		goto recv_sndq;
> > +	}
> > +
> >  try_again:
> >  	off = sk_peek_offset(sk, flags);
> >  	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
> > @@ -394,6 +424,21 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> >  	cond_resched();
> >  	msg->msg_flags &= ~MSG_TRUNC;
> >  	goto try_again;
> > +
> > +recv_sndq:
> > +	off = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
> > +	if (msg->msg_name) {
> > +		DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
> > +
> > +		fl6 = &inet->cork.fl.u.ip6;
> > +		sin6->sin6_family = AF_INET6;
> > +		sin6->sin6_port = fl6->fl6_dport;
> > +		sin6->sin6_flowinfo = 0;
> > +		sin6->sin6_addr = fl6->daddr;
> > +		sin6->sin6_scope_id = fl6->flowi6_oif;
> > +		*addr_len = sizeof(*sin6);
> > +	}
> > +	return udp6_peek_sndq(sk, msg, off, len);
> >  }
> >  
> >  DEFINE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
> > 
