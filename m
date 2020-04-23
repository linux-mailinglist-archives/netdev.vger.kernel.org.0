Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441B61B66A6
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDWWPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgDWWPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:15:19 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3B8C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:15:19 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so8509575wmg.1
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=KA/rG/Mx2zA9QFFywW+k2RB8K1mQJ+0YUrKzzAKDF3c=;
        b=GumieYIJNokAmQTucpvN1gjlNENOgafz5AQhTpokBuTt0g8N8qS9lPyym+UDtI10/R
         pPuKk81vnu7F1Vgrm2lI1OA2V+N0jJd436wqeTdAjS7IWJKzWtwL3wTD2r2u4iHv7RFd
         grS1DCTm/Rzg9pn6ZcSXIH2e3g/2X0ZCGUmVrNYcpt8Brv03jgyixRiZcSCYSne+aIHl
         uleyKhkLj7wmCuVU2yinUgMSTOwdtcE1GUJeqK4gmp0TPFh54MuEZf4d7WW6N7RnU2bx
         bDUIIlqSUPkr4eWnc7Cs/PL6wfTvG4F5aDH/uBqd4dwrXoIoJmxWpjD4qcM5oZE9IU8U
         Jg4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=KA/rG/Mx2zA9QFFywW+k2RB8K1mQJ+0YUrKzzAKDF3c=;
        b=hKbIF8qFdRpVBCQASNfHNn10uPtcQ1bOCyT8KbtYcQ/5uTJMS6NcRo37hdYE/r9sRV
         vjXsH5pSSXn2ELE73IbfpYRrF68hHos9W+3vvybEhPXBz3qk0YhnKu7+thdcW/9ktanB
         S1o406lcimPg3aHM3taTXWcxSfp61iWv/8n15fuYp6vWRndhWbv9seTPZgH3Rb6GQyeE
         GPyURml1CfjNbjGFg9bOXhxdDdgjZwjl0UVuEvJjgYntMC7mOSCXxTvObjdF5VyvOeT2
         3RhFfrwzSi6uvl4arCHc9zyF7P17ztWOTZgVzkwrRZITSM6Y6LYjfLwQUzM9SmtyZoEx
         cBYA==
X-Gm-Message-State: AGi0PubbCcmx2R8ks3TBq888gAFYY4T9gVoBHjwWwtlUWVtpmHbjtybb
        b7fNDrCnAiijPGEK62IG5Bs=
X-Google-Smtp-Source: APiQypKqD8Jv2+cvb638ccpcRLvmmHLJFq7nzgue1b/BJcd08MXzXn2PtqQfTFoZAaPi/dP0LbjCKg==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr6197995wmi.187.1587680117795;
        Thu, 23 Apr 2020 15:15:17 -0700 (PDT)
Received: from white ([188.27.146.47])
        by smtp.gmail.com with ESMTPSA id p7sm5849499wrf.31.2020.04.23.15.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 15:15:17 -0700 (PDT)
Date:   Fri, 24 Apr 2020 01:15:15 +0300
From:   Lese Doru Calin <lesedorucalin01@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5] net: Option to retrieve the pending data from send queue
 of UDP socket
Message-ID: <20200423221515.GA4335@white>
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
This is what this patch does. It adds a new command SIOUDPPENDGET to the ioctl 
syscall regarding UDP sockets, which stores the pending data from the write queue
and the destination address in a struct msghdr. The arg for ioctl needs to be a
pointer to a user space struct msghdr. To retrive the data requires the 
CAP_NET_ADMIN capability.

Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
---
It a different approach from https://lore.kernel.org/netdev/20200416132242.GA2586@white/,
that has given up on UDP "Repair mode" in the fast path for a ioctl syscall. 

 include/linux/socket.h       |   2 +
 include/uapi/linux/sockios.h |   3 +
 net/ipv4/udp.c               | 144 ++++++++++++++++++++++++++++++++---
 net/socket.c                 |   4 +-
 4 files changed, 139 insertions(+), 14 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 54338fac45cb..632ba0ea6709 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -351,6 +351,8 @@ struct ucred {
 #define IPX_TYPE	1
 
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
+extern int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+			      void __user *uaddr, int __user *ulen);
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
index 32564b350823..3f53502a533e 100644
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
@@ -1794,18 +1924,8 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 
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

