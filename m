Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAF31A7702
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437419AbgDNJJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437410AbgDNJJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:09:33 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8D2C008769
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 02:09:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a81so13055202wmf.5
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 02:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=QwfKGdqam9RIuBIMLZ/S/DFAHpLMsKb4kuHzoefPgZA=;
        b=PpI2smU4Q7O7yGn29QKLR5E6hM2tJGmjffnfP7dOyNCNAFoNTNNGABUFekttfgkYiP
         hadODThe0lRT7x7HGgHEn9QEBULOXlWQqAmKyFjfJ0QJ7ZlEVAtdHyyrTTehKFKOVMRG
         r2H+OL/yuKyiI6HbKsKl7VSrk4FsZM3fPQuMSQbqQpjgN49YRQyNUXk/Gv4E+stmJkIr
         j8U2+nxQX03RAZI/r8P2y3TR3JqWLWX6vUTmNA0DRO/DHR4CZ4jK+mY8ENxSS0/jjSfh
         zV51qklLAsev4Bi88dM6/+qdLYfOVf+RpiYV3e0mgLya5vpcsveEdLRsrIue1uUvPxC9
         +biQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=QwfKGdqam9RIuBIMLZ/S/DFAHpLMsKb4kuHzoefPgZA=;
        b=lOQlWDIEafT8UCNSC5rm6MorSImZ6b79hz5b3UGRMj8iohKVAwy+y49n87ZdrDBM+r
         RiLmJDRAn8ATVOcj06G12d+pG6xo+2xInKZReG2BmV21UQV74YUFgERAMSrgLCLjvxnV
         2MJxXoJbswcTYx2ZWivExsfgUqpjsFk5kBPM1aDtQs0HCwzZclWcVVR2Puz5g7DjZXsC
         04FzHk8AAZ0RWt+lrcSCPP1L0c6CgKH9bvnIC3ove5JzFFN9nuUklXVoLv2+kDwMt85R
         EpZK6vBIzLCJpHLyjJY5fgcmnuUGWA4rSbEL3Q1U4pYud0Hp8hxGoCWAymr4nCBVDvlR
         cavw==
X-Gm-Message-State: AGi0PuaHzNxVhPiNR+B4NXa4u/tx36b/qjdl1Beic5tGaJ+3VrsJXm8q
        VenrB1U3uk9J2h5KgeGq/hY=
X-Google-Smtp-Source: APiQypLE/GfWvo5cFIPIM2QWKl6I5o86DIJtqT7i1OZu7oQiXcusw4XfKALU6y2Vue94X1qQnTCbNQ==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr22146271wmi.152.1586855370308;
        Tue, 14 Apr 2020 02:09:30 -0700 (PDT)
Received: from white ([188.27.148.74])
        by smtp.gmail.com with ESMTPSA id r17sm8608271wrn.43.2020.04.14.02.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 02:09:29 -0700 (PDT)
Date:   Tue, 14 Apr 2020 12:09:25 +0300
From:   =?utf-8?B?TGXFn2UgRG9ydSBDxINsaW4=?= <lesedorucalin01@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v3] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
Message-ID: <20200414090925.GA10402@white>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this year's edition of GSoC, there is a project idea for CRIU to add 
support for checkpoint/restore of cork-ed UDP sockets. But to add it, the
kernel API needs to be extended.

This is what this patch does. It adds UDP "repair mode" for UDP sockets in 
a similar approach to the TCP "repair mode", but only the send queue is
necessary to be retrieved. So the patch extends the recv and setsockopt 
syscalls. Using UDP_REPAIR option in setsockopt, caller can set the socket
in repair mode. If it is setted, the recv/recvfrom/recvmsg will receive the
write queue and the destination of the data. As in the TCP mode, to change 
the repair mode requires the CAP_NET_ADMIN capability and to receive data 
the caller is obliged to use the MSG_PEEK flag.

Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
---
 include/linux/udp.h      |  3 ++-
 include/uapi/linux/udp.h |  1 +
 net/ipv4/udp.c           | 55 ++++++++++++++++++++++++++++++++++++++++
 net/ipv6/udp.c           | 45 ++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index aa84597bdc33..b22bd70118ce 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -51,7 +51,8 @@ struct udp_sock {
 					   * different encapsulation layer set
 					   * this
 					   */
-			 gro_enabled:1;	/* Can accept GRO packets */
+			 gro_enabled:1,	/* Can accept GRO packets */
+			 repair:1;/* Receive the send queue */
 	/*
 	 * Following member retains the information to create a UDP header
 	 * when the socket is uncorked.
diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 4828794efcf8..2fe78329d6da 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -29,6 +29,7 @@ struct udphdr {
 
 /* UDP socket options */
 #define UDP_CORK	1	/* Never send partially complete segments */
+#define UDP_REPAIR  19  /* Receive the send queue */
 #define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
 #define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
 #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 32564b350823..dc9d15d564d6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1720,6 +1720,28 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
+static int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
+{
+	int copy, copied = 0, err = 0;
+	struct sk_buff *skb;
+
+	skb_queue_walk(&sk->sk_write_queue, skb) {
+		copy = len - copied;
+		if (copy > skb->len - off)
+			copy = skb->len - off;
+
+		err = skb_copy_datagram_msg(skb, off, msg, copy);
+		if (err)
+			break;
+
+		copied += copy;
+
+		if (len <= copied)
+			break;
+	}
+	return err ?: copied;
+}
+
 /*
  * 	This should be easy, if there is something there we
  * 	return it, otherwise we block.
@@ -1729,8 +1751,10 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		int flags, int *addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
+	struct udp_sock *up = udp_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
 	struct sk_buff *skb;
+	struct flowi4 *fl4;
 	unsigned int ulen, copied;
 	int off, err, peeking = flags & MSG_PEEK;
 	int is_udplite = IS_UDPLITE(sk);
@@ -1739,6 +1763,12 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len, addr_len);
 
+	if (unlikely(up->repair)) {
+		if (!peeking)
+			return -EPERM;
+		goto recv_sndq;
+	}
+
 try_again:
 	off = sk_peek_offset(sk, flags);
 	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
@@ -1832,6 +1862,18 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	cond_resched();
 	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
+
+recv_sndq:
+	off = sizeof(struct iphdr) + sizeof(struct udphdr);
+	if (sin) {
+		fl4 = &inet->cork.fl.u.ip4;
+		sin->sin_family = AF_INET;
+		sin->sin_port = fl4->fl4_dport;
+		sin->sin_addr.s_addr = fl4->daddr;
+		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
+	}
+	return udp_peek_sndq(sk, msg, off, len);
 }
 
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
@@ -2557,6 +2599,15 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		}
 		break;
 
+	case UDP_REPAIR:
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+			err = -EPERM;
+		else if (val != 0)
+			up->repair = 1;
+		else
+			up->repair = 0;
+		break;
+
 	case UDP_ENCAP:
 		switch (val) {
 		case 0:
@@ -2678,6 +2729,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->corkflag;
 		break;
 
+	case UDP_REPAIR:
+		val = up->repair;
+		break;
+
 	case UDP_ENCAP:
 		val = up->encap_type;
 		break;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7d4151747340..ec653f9fce2d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -250,6 +250,28 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
 EXPORT_SYMBOL_GPL(udp6_lib_lookup);
 #endif
 
+static int udp6_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
+{
+	int copy, copied = 0, err = 0;
+	struct sk_buff *skb;
+
+	skb_queue_walk(&sk->sk_write_queue, skb) {
+		copy = len - copied;
+		if (copy > skb->len - off)
+			copy = skb->len - off;
+
+		err = skb_copy_datagram_msg(skb, off, msg, copy);
+		if (err)
+			break;
+
+		copied += copy;
+
+		if (len <= copied)
+			break;
+	}
+	return err ?: copied;
+}
+
 /* do not use the scratch area len for jumbogram: their length execeeds the
  * scratch area space; note that the IP6CB flags is still in the first
  * cacheline, so checking for jumbograms is cheap
@@ -269,7 +291,9 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
+	struct udp_sock *up = udp_sk(sk);
 	struct sk_buff *skb;
+	struct flowi6 *fl6;
 	unsigned int ulen, copied;
 	int off, err, peeking = flags & MSG_PEEK;
 	int is_udplite = IS_UDPLITE(sk);
@@ -283,6 +307,12 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
+	if (unlikely(up->repair)) {
+		if (!peeking)
+			return -EPERM;
+		goto recv_sndq;
+	}
+
 try_again:
 	off = sk_peek_offset(sk, flags);
 	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
@@ -394,6 +424,21 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	cond_resched();
 	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
+
+recv_sndq:
+	off = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
+	if (msg->msg_name) {
+		DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
+
+		fl6 = &inet->cork.fl.u.ip6;
+		sin6->sin6_family = AF_INET6;
+		sin6->sin6_port = fl6->fl6_dport;
+		sin6->sin6_flowinfo = 0;
+		sin6->sin6_addr = fl6->daddr;
+		sin6->sin6_scope_id = fl6->flowi6_oif;
+		*addr_len = sizeof(*sin6);
+	}
+	return udp6_peek_sndq(sk, msg, off, len);
 }
 
 DEFINE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
-- 
2.17.1
