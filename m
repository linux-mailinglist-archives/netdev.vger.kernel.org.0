Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB79241FBC
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 20:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgHKSdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 14:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgHKSdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 14:33:37 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A0EC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:33:37 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m20so9820794eds.2
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uvpTifvmA6Sc41kGl5K0nuA2H17+wK1f0z6V7of9HC4=;
        b=ZtzmrPaJ5HeSLaLy1Ho7DSMKO26xYZVdXRzbMVe9YyHIe0NQDPeD1blGHaeDUVJ6R5
         mQpIb3V2r5CfFDOVt+c08RTmn6bnbJ2A2Wrrx3CQ9WMTlkzsQjq4LPPVUrABUlnFhGPc
         jR6nvp5lLqgVv3rnGDmXt4HF+8ifUENtBLxmSmyqKjX/YKYAvqOy2NvYcbTRAwUnqyWv
         DYDofYL2qyFUPrMrBmkN551Yn6WXYlZsZTPOYQJKeKCYQ7DU9m3nY90gxAXho7sKHP4l
         Xc3T12R5d7DIIvR5c0Ypn2uL4UdS7nH71pqzsggy6+v6puWmmyWrWOLAHM+v4bYiNpFG
         60Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvpTifvmA6Sc41kGl5K0nuA2H17+wK1f0z6V7of9HC4=;
        b=a/wjxV4t2gv1JngdYKx9bPyuRdOUF15NQQz3UD5vsuiQ//QHn8/hoKTUoozqb5LULH
         fxWZKyhIAY0ToRUtwax73GEaSEv8FvzRiNsrWsqOf0A/PqOE6SFR7WLN3KIpOSfp1rp+
         kMJMQ5ghnbg+i5rSFP8cJ/A467L0zuTzkxI09Rs8EUtnrDtxKY4qlfsVSAKwMwGcKTOp
         yN5Miimeo/y77b8Vr6matlhdacy3qln+4uxUqRiNLpN/UzY73PAsF1CBbKmhgmYo6q/m
         lj/mKzBpfU6AMmUnAA9to18QNJNA6RseWV23zTCSmSDoq7zpjGsGtyNYIIFQOlROxtbz
         xjlg==
X-Gm-Message-State: AOAM530uAyU64Aj2+cxn691pi6uLOhxVr08edv0x/a6+VbNQR/pE1G6C
        5mEU/aaaX0mCa9VvegWCdD4A5A==
X-Google-Smtp-Source: ABdhPJwTXsaxszps1o5oesjiaZVr40GWxyJUE5oaudKSRPFyOQb7l1RouUYOcOSnCRHJy+vI9YFjHw==
X-Received: by 2002:aa7:d70a:: with SMTP id t10mr26817320edq.68.1597170815987;
        Tue, 11 Aug 2020 11:33:35 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw14xncxzsvibs41.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:9d04:d01e:8e99:1111])
        by smtp.gmail.com with ESMTPSA id ch24sm15350222ejb.7.2020.08.11.11.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 11:33:35 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        KOVACS Krisztian <hidden@balabit.hu>
Cc:     Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v4 1/2] net: refactor bind_bucket fastreuse into helper
Date:   Tue, 11 Aug 2020 20:33:23 +0200
Message-Id: <20200811183325.42748-2-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200811183325.42748-1-tim.froidcoeur@tessares.net>
References: <20200811183325.42748-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the fastreuse update code in inet_csk_get_port into a small
helper function that can be called from other places.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
---
 include/net/inet_connection_sock.h |  4 ++
 net/ipv4/inet_connection_sock.c    | 97 ++++++++++++++++--------------
 2 files changed, 57 insertions(+), 44 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 1e209ce7d1bd..aa8893c68c50 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -304,6 +304,10 @@ void inet_csk_listen_stop(struct sock *sk);
 
 void inet_csk_addr2sockaddr(struct sock *sk, struct sockaddr *uaddr);
 
+/* update the fast reuse flag when adding a socket */
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk);
+
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
 #define TCP_PINGPONG_THRESH	3
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index d1a3913eebe0..b457dd2d6c75 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -296,6 +296,57 @@ static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
 				    ipv6_only_sock(sk), true, false);
 }
 
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk)
+{
+	kuid_t uid = sock_i_uid(sk);
+	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
+
+	if (hlist_empty(&tb->owners)) {
+		tb->fastreuse = reuse;
+		if (sk->sk_reuseport) {
+			tb->fastreuseport = FASTREUSEPORT_ANY;
+			tb->fastuid = uid;
+			tb->fast_rcv_saddr = sk->sk_rcv_saddr;
+			tb->fast_ipv6_only = ipv6_only_sock(sk);
+			tb->fast_sk_family = sk->sk_family;
+#if IS_ENABLED(CONFIG_IPV6)
+			tb->fast_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
+#endif
+		} else {
+			tb->fastreuseport = 0;
+		}
+	} else {
+		if (!reuse)
+			tb->fastreuse = 0;
+		if (sk->sk_reuseport) {
+			/* We didn't match or we don't have fastreuseport set on
+			 * the tb, but we have sk_reuseport set on this socket
+			 * and we know that there are no bind conflicts with
+			 * this socket in this tb, so reset our tb's reuseport
+			 * settings so that any subsequent sockets that match
+			 * our current socket will be put on the fast path.
+			 *
+			 * If we reset we need to set FASTREUSEPORT_STRICT so we
+			 * do extra checking for all subsequent sk_reuseport
+			 * socks.
+			 */
+			if (!sk_reuseport_match(tb, sk)) {
+				tb->fastreuseport = FASTREUSEPORT_STRICT;
+				tb->fastuid = uid;
+				tb->fast_rcv_saddr = sk->sk_rcv_saddr;
+				tb->fast_ipv6_only = ipv6_only_sock(sk);
+				tb->fast_sk_family = sk->sk_family;
+#if IS_ENABLED(CONFIG_IPV6)
+				tb->fast_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
+#endif
+			}
+		} else {
+			tb->fastreuseport = 0;
+		}
+	}
+}
+
 /* Obtain a reference to a local port for the given sock,
  * if snum is zero it means select any available local port.
  * We try to allocate an odd port (and leave even ports for connect())
@@ -308,7 +359,6 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 	struct inet_bind_hashbucket *head;
 	struct net *net = sock_net(sk);
 	struct inet_bind_bucket *tb = NULL;
-	kuid_t uid = sock_i_uid(sk);
 	int l3mdev;
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
@@ -345,49 +395,8 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 			goto fail_unlock;
 	}
 success:
-	if (hlist_empty(&tb->owners)) {
-		tb->fastreuse = reuse;
-		if (sk->sk_reuseport) {
-			tb->fastreuseport = FASTREUSEPORT_ANY;
-			tb->fastuid = uid;
-			tb->fast_rcv_saddr = sk->sk_rcv_saddr;
-			tb->fast_ipv6_only = ipv6_only_sock(sk);
-			tb->fast_sk_family = sk->sk_family;
-#if IS_ENABLED(CONFIG_IPV6)
-			tb->fast_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
-#endif
-		} else {
-			tb->fastreuseport = 0;
-		}
-	} else {
-		if (!reuse)
-			tb->fastreuse = 0;
-		if (sk->sk_reuseport) {
-			/* We didn't match or we don't have fastreuseport set on
-			 * the tb, but we have sk_reuseport set on this socket
-			 * and we know that there are no bind conflicts with
-			 * this socket in this tb, so reset our tb's reuseport
-			 * settings so that any subsequent sockets that match
-			 * our current socket will be put on the fast path.
-			 *
-			 * If we reset we need to set FASTREUSEPORT_STRICT so we
-			 * do extra checking for all subsequent sk_reuseport
-			 * socks.
-			 */
-			if (!sk_reuseport_match(tb, sk)) {
-				tb->fastreuseport = FASTREUSEPORT_STRICT;
-				tb->fastuid = uid;
-				tb->fast_rcv_saddr = sk->sk_rcv_saddr;
-				tb->fast_ipv6_only = ipv6_only_sock(sk);
-				tb->fast_sk_family = sk->sk_family;
-#if IS_ENABLED(CONFIG_IPV6)
-				tb->fast_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
-#endif
-			}
-		} else {
-			tb->fastreuseport = 0;
-		}
-	}
+	inet_csk_update_fastreuse(tb, sk);
+
 	if (!inet_csk(sk)->icsk_bind_hash)
 		inet_bind_hash(sk, tb, port);
 	WARN_ON(inet_csk(sk)->icsk_bind_hash != tb);
-- 
2.25.1

