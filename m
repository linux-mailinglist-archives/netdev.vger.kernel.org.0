Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55731C2400
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 10:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgEBI3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 04:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbgEBI27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 04:28:59 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E517C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 01:28:59 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x25so2528179wmc.0
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 01:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=/8TOEfn/f3krSiYbART1jbzpegPNU+rqldlhVTZ6ajA=;
        b=hfDAe+wsN7no5kxGU2KlUBk+ExyDLbQWlnAHD1JHfrUaMV+UrNJxlcimZg61zPKdzy
         HyJLujJR8BR2VeLjo+ueX6vaBAHARAUSTqD0ofsylJwCcNug030EexFeJ87pVuJ8qEY1
         W9+HxDBowxbWvOpzfFUpfpRMDxnlw4ts5GOKEWJcGjigagQrntzSgbI6T8UFxVTEc5r4
         /TRYnVUijw4V1tQv/Q60Gkg3daA40Q4LfPa72sIbRX73cYE4yCEFe2S0G9I5f3jhGRiu
         MP6C7NnpHQZBq2Iw21q28urWzXXSGfh1SskHILRFFMuqNKIRWZwxR01AACxAN8vwIlM6
         kwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/8TOEfn/f3krSiYbART1jbzpegPNU+rqldlhVTZ6ajA=;
        b=GkUelFWSQUYaahq3L1goapsqErwJOCsYTBgCZ9jKji7k0cUXiGelpgr8D+EpXpd4MC
         s6hUz0py+HK3LcVZjYFaoQOcVlcJY2XEOlNdsiNLOa7k9vKPjK8SoEcawY6YICOo6sXf
         9hSVu0rDpOhPpYYLhi+/BrzrijJaIl6BDtOYL4E6yBmXkSrwFn67DlhUB86Fy6Kc3Unk
         iQPJhfrlzQooln1Euq71Wb2eXep41FMSBXJQLYSNPMeCKnUkDazz7yAtGqXfxKKNceB9
         o1nK4/2x5LHXJURmWaQ7OnIwKuvUHGbTDDA2YnIu4bIs4ES/19EYyGntBxA5SR/IYhlJ
         LVZw==
X-Gm-Message-State: AGi0PuY7Neb5DAZ5l1LuGW/VlP2LQDnpWznZ4DPysOOoexBjdXcSwW0C
        J6q5Ne7G73JJdyzS+cApsIg=
X-Google-Smtp-Source: APiQypLDUDLD7AnKeaZeCapFvOzYfc3IcYuUqCkUk23TXjFVhmnZele0YYN1nvgGhcGUi6tTcemOwg==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr3764733wmj.21.1588408138033;
        Sat, 02 May 2020 01:28:58 -0700 (PDT)
Received: from white ([188.27.146.47])
        by smtp.gmail.com with ESMTPSA id y9sm3048662wmm.26.2020.05.02.01.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 01:28:57 -0700 (PDT)
Date:   Sat, 2 May 2020 11:28:56 +0300
From:   Lese Doru Calin <lesedorucalin01@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6] net: Option to retrieve the pending data from send queue
 of UDP socket
Message-ID: <20200502082856.GA3152@white>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this year's edition of GSoC, there is a project idea for CRIU to add support
for checkpoint/restore of cork-ed UDP sockets. But to add it, the kernel API needs
to be extended.
This is what this patch does. It adds a new command, called SIOUDPPENDGET, to the 
ioctl syscall regarding UDP sockets, which stores the pending data from the write
queue and the destination address in a struct msghdr. The arg for ioctl needs to 
be a pointer to a user space struct msghdr. The syscall returns the number of writed
bytes, if successful, or error. To retrive the data requires the CAP_NET_ADMIN
capability.

Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
---
 include/linux/socket.h       |   2 +
 include/uapi/linux/sockios.h |   3 +
 net/ipv4/udp.c               | 145 +++++++++++++++++++++++++++++++----
 net/socket.c                 |   4 +-
 4 files changed, 139 insertions(+), 15 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 54338fac45cb..632ba0ea6709 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -351,6 +351,8 @@ struct ucred {
 #define IPX_TYPE	1
 
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
+extern int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+			     void __user *uaddr, int __user *ulen);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec64;
diff --git a/include/uapi/linux/sockios.h b/include/uapi/linux/sockios.h
index 7d1bccbbef78..3639fa906604 100644
--- a/include/uapi/linux/sockios.h
+++ b/include/uapi/linux/sockios.h
@@ -153,6 +153,9 @@
 #define SIOCSHWTSTAMP	0x89b0		/* set and get config		*/
 #define SIOCGHWTSTAMP	0x89b1		/* get config			*/
 
+/* UDP socket calls*/
+#define SIOUDPPENDGET 0x89C0	/* get the pending data from write queue */
+
 /* Device private ioctl calls */
 
 /*
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 32564b350823..f729a5e7f90b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1620,6 +1620,133 @@ static int first_packet_length(struct sock *sk)
 	return res;
 }
 
+static void udp_set_source_addr(struct sock *sk, struct msghdr *msg,
+				int *addr_len, u32 addr, u16 port)
+{
+	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
+
+	if (sin) {
+		sin->sin_family = AF_INET;
+		sin->sin_port = port;
+		sin->sin_addr.s_addr = addr;
+		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
+
+		if (cgroup_bpf_enabled)
+			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
+					 (struct sockaddr *)sin);
+	}
+}
+
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
+		if (len <= copied)
+			break;
+	}
+	return err ?: copied;
+}
+
+static int udp_get_pending_write_queue(struct sock *sk, struct msghdr *msg,
+				       int *addr_len)
+{
+	int err = 0, off = sizeof(struct udphdr);
+	struct inet_sock *inet = inet_sk(sk);
+	struct udp_sock *up = udp_sk(sk);
+	struct flowi4 *fl4;
+	struct flowi6 *fl6;
+
+	switch (up->pending) {
+	case 0:
+		return -ENODATA;
+	case AF_INET:
+		off += sizeof(struct iphdr);
+		fl4 = &inet->cork.fl.u.ip4;
+		udp_set_source_addr(sk, msg, addr_len,
+				    fl4->daddr, fl4->fl4_dport);
+		break;
+	case AF_INET6:
+		off += sizeof(struct ipv6hdr);
+		if (msg->msg_name) {
+			DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6,
+					 msg->msg_name);
+
+			fl6 = &inet->cork.fl.u.ip6;
+			sin6->sin6_family = AF_INET6;
+			sin6->sin6_port = fl6->fl6_dport;
+			sin6->sin6_flowinfo = 0;
+			sin6->sin6_addr = fl6->daddr;
+			sin6->sin6_scope_id = fl6->flowi6_oif;
+			*addr_len = sizeof(*sin6);
+
+			if (cgroup_bpf_enabled)
+				BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
+						(struct sockaddr *)sin6);
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	lock_sock(sk);
+	if (unlikely(!up->pending)) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+	err = udp_peek_sndq(sk, msg, off, msg_data_left(msg));
+	release_sock(sk);
+	return err;
+}
+
+static int prep_msghdr_recv_pending(struct sock *sk, void __user *argp)
+{
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct user_msghdr __user *msg;
+	struct sockaddr __user *uaddr;
+	struct sockaddr_storage addr;
+	struct msghdr msg_sys;
+	int __user *uaddr_len;
+	int err = 0, len = 0;
+
+	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!argp)
+		return -EINVAL;
+
+	msg = (struct user_msghdr __user *)argp;
+	err = recvmsg_copy_msghdr(&msg_sys, msg, 0, &uaddr, &iov);
+	if (err < 0)
+		return err;
+
+	uaddr_len = &msg->msg_namelen;
+	msg_sys.msg_name = &addr;
+	msg_sys.msg_flags = 0;
+
+	err = udp_get_pending_write_queue(sk, &msg_sys, &len);
+	msg_sys.msg_namelen = len;
+	len = err;
+
+	if (uaddr && err >= 0)
+		err = move_addr_to_user(&addr, msg_sys.msg_namelen,
+					uaddr, uaddr_len);
+
+	kfree(iov);
+	return err < 0 ? err : len;
+}
+
 /*
  *	IOCTL requests applicable to the UDP protocol
  */
@@ -1641,6 +1768,9 @@ int udp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		return put_user(amount, (int __user *)arg);
 	}
 
+	case SIOUDPPENDGET:
+		return prep_msghdr_recv_pending(sk, (void __user *)arg);
+
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -1729,7 +1859,6 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		int flags, int *addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
-	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
 	struct sk_buff *skb;
 	unsigned int ulen, copied;
 	int off, err, peeking = flags & MSG_PEEK;
@@ -1794,18 +1923,8 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 
 	sock_recv_ts_and_drops(msg, sk, skb);
 
-	/* Copy the address. */
-	if (sin) {
-		sin->sin_family = AF_INET;
-		sin->sin_port = udp_hdr(skb)->source;
-		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
-		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
-		*addr_len = sizeof(*sin);
-
-		if (cgroup_bpf_enabled)
-			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
-							(struct sockaddr *)sin);
-	}
+	udp_set_source_addr(sk, msg, addr_len, ip_hdr(skb)->saddr,
+			    udp_hdr(skb)->source);
 
 	if (udp_sk(sk)->gro_enabled)
 		udp_cmsg_recv(msg, sk, skb);
diff --git a/net/socket.c b/net/socket.c
index 2dd739fba866..bd25d528c9a0 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -217,8 +217,8 @@ int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *k
  *	specified. Zero is returned for a success.
  */
 
-static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
-			     void __user *uaddr, int __user *ulen)
+int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+		      void __user *uaddr, int __user *ulen)
 {
 	int err;
 	int len;
-- 
2.17.1

