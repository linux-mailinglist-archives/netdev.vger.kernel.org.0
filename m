Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2F123DA35
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 14:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgHFMJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 08:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgHFLRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 07:17:00 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B092C0617AA
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 04:06:46 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m20so25357969eds.2
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 04:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=S/X2S8Un72gBHPqjEBeUbRT6khumFRMEJ0GKnYWhQoU=;
        b=ZQmX2XOG51SZPQLT9CoMa3NRtTFzhOTfEl/HndyrmJ+5KOoCEzpzgAKbfksi1pDrgR
         J8OcaKxOL8iiZiWypX7BiJ7ZAQlJ7+snk+f10xB/Iyhw+3YDrIBXMlCYYSPTXcYrW3ag
         CdXnh8Y9ClcWRbAfbrNLSMKnqZf65CNXESYNM5rXyzz2t6iOaAr1f0JAW8itoGpEqLt2
         yAPUGnk6bT+31I9WRdTAzRctxNu80WZiYZh5z4I3JXdBJT7syuUJba8V0Vl67sWTEwJG
         1quus6OfKfIXUxvE6YKGwbWPqRpa3IW8I0TjosZ3w3qY2LVtiDeQ7OkcQ6YBnavx+ZIo
         /bLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=S/X2S8Un72gBHPqjEBeUbRT6khumFRMEJ0GKnYWhQoU=;
        b=mJCT5U+xozeF5StxYEm9dL83BVasll9tMGhMQPmcsk38lvUgVQjjUvbCjZWQzy+pyQ
         KW1Ox7biq+KXnMqri38pNqXe5E8HYyg7v9YWVm3iMYFhooNiBxP/1xKfvK5yFwbXFcR5
         XCOCm9ZkR7Bzc01Cp1DDAJ2/TOEISl28WeMqEkX+PwsMoJHI8JbkrZe+p+0/xFi9rhUD
         pwtUd3QZYEu7FNz9+XSDFhNgkNu7nVgQJ2oGQT8WBPeNpqvFeHAV3143yWnhDUGWNLCW
         cG9nhH0YlOviYkXLjOXJsp20D7QAS7BILfQHm3JQaijpTw49sT2wHLhqaob9JDezUapG
         gJWA==
X-Gm-Message-State: AOAM533rqLCvE3jzwVaX4g9YCqrcxj+es2+fJPHJIWM+a05KSOC6IrD0
        f4jyTMCe4gJ/5IgDboodxBb39NTUpQfwDEQaFT1fciR1S1N+KIzw71cCwsntClccRNhr1FiBO7g
        xragPBOfAbcrfh3w=
X-Google-Smtp-Source: ABdhPJy3G6d4eB2KPic/Jx2xZphGvOf7yTyGdw/FaCqjMdrsgXqO8sB7/mWx+z08+SMJ8SK5WtqviQ==
X-Received: by 2002:aa7:ccd5:: with SMTP id y21mr3402579edt.91.1596712004954;
        Thu, 06 Aug 2020 04:06:44 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw15pracyli75x11.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:d05d:939:f42b:f575])
        by smtp.gmail.com with ESMTPSA id v13sm3597682edl.9.2020.08.06.04.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 04:06:44 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     tim.froidcoeur@tessares.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/2] net: refactor bind_bucket fastreuse into helper
Date:   Thu,  6 Aug 2020 13:06:30 +0200
Message-Id: <20200806110631.475855-2-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200806110631.475855-1-tim.froidcoeur@tessares.net>
References: <20200806110631.475855-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the fastreuse update code in inet_csk_get_port into a small
helper function that can be called from other places.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
---

Notes:
    - remove unnecessary cast (Matt)

 include/net/inet_connection_sock.h |  4 ++
 net/ipv4/inet_connection_sock.c    | 97 ++++++++++++++++--------------
 2 files changed, 57 insertions(+), 44 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index e5b388f5fa20..1d59bf55bb4d 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -316,6 +316,10 @@ int inet_csk_compat_getsockopt(struct sock *sk, int level, int optname,
 int inet_csk_compat_setsockopt(struct sock *sk, int level, int optname,
 			       char __user *optval, unsigned int optlen);
 
+/* update the fast reuse flag when adding a socket */
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk);
+
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
 #define TCP_PINGPONG_THRESH	3
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index afaf582a5aa9..a1be020bde8e 100644
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


-- 


Disclaimer: https://www.tessares.net/mail-disclaimer/ 
<https://www.tessares.net/mail-disclaimer/>


