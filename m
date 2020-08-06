Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E71F23D6E9
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgHFGl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgHFGlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:41:18 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC45C061756
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 23:41:17 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id m20so24830584eds.2
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 23:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=jDUym0vWEpZIcMhWfa/K7V4V+Szd7ch6LROXk73w6hQ=;
        b=pqZPBAHqzO9t39KetthMni+h5xvguVJURtACJeU+jpTCCm8WNXLISsTFl6IJU4UsE8
         IbGeGSfmTWa1ToeEM++ZFsGIz1zqBibaFyf0DLIZEnWfotWrOzcsFsofSH3JMTnajWPn
         v/IveldnQcEILJKt1tGvQNAuRILTDZs1731GsXtJjthZvgnwc7QhM+xbI2rlCUimaBVW
         7USUMuOKkdQUGkeix6iSCVqDSTigP0hrf/NV0j1FsSt3ZA7zd75Ua9L5fNMbgHSitm6t
         l0P+qIibDQ55U0eXJ9ec0jNQQGAC78pKeh3Oc/ZC+Oy0wugXcpaZmsYaN4DTIZY32HGl
         ZMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=jDUym0vWEpZIcMhWfa/K7V4V+Szd7ch6LROXk73w6hQ=;
        b=Shxao59ucRwdr/qSqnx+z++vi6E1dxqLY+wREt/oJEeFXNTxFGD/Aur7g9oFCd743t
         fGuhLzFMSNY1ho+bA9NQjIoDpsehx+idcY00uYsLyMRQqBPuGOwmb6Xw5bDcTKlvjSsG
         am2PLTvu43CE8vDCOgumSGn4ssxVWoGvXcLFVVWfbIyjtBnLCeNptoTIe7iPiIgXhlgS
         DvwDn1al9WuDkcVOJluo8hNi0Y01gU8qyxDpA08p+VIa7MMMMIZ4O7HpI1pK5lGtW7HI
         1PGxS19eUgUu59bRzX2EKu0bt+dg79KTEnPmRGursm77Pc+ni3AVYoua8UVQXM7Qr3Fx
         YvEg==
X-Gm-Message-State: AOAM530GrkbEtHvJt61KNd8oNWwJECVsU1wVI2I8II+fcm3TPCda3w78
        Mwb6+0qeX9csdGbWEL28Bbs554X6I+nh+E6HTYn32XCHi9CysaurR8uzOWOQnqSxjSIAwE1MkeL
        oHv5MdHStCw==
X-Google-Smtp-Source: ABdhPJzhboHOTfkuAM14VstGdrhfyo4qmphKKGc7ktZhyPZ8YfLSuytZrb9SO76LJ8TfitGybTBJDg==
X-Received: by 2002:a50:fc0e:: with SMTP id i14mr2610860edr.346.1596696076367;
        Wed, 05 Aug 2020 23:41:16 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw15pracyli75x11.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:d05d:939:f42b:f575])
        by smtp.gmail.com with ESMTPSA id h18sm2880984edw.56.2020.08.05.23.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 23:41:15 -0700 (PDT)
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
Subject: [PATCH net 1/2] net: refactor bind_bucket fastreuse into helper
Date:   Thu,  6 Aug 2020 08:41:07 +0200
Message-Id: <20200806064109.183059-2-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200806064109.183059-1-tim.froidcoeur@tessares.net>
References: <20200806064109.183059-1-tim.froidcoeur@tessares.net>
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
 include/net/inet_connection_sock.h |  4 ++
 net/ipv4/inet_connection_sock.c    | 99 ++++++++++++++++--------------
 2 files changed, 58 insertions(+), 45 deletions(-)

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
index afaf582a5aa9..3b46b1f6086e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -266,7 +266,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
 				     struct sock *sk)
 {
-	kuid_t uid = sock_i_uid(sk);
+	kuid_t uid = sock_i_uid((struct sock *)sk);
 
 	if (tb->fastreuseport <= 0)
 		return 0;
@@ -296,6 +296,57 @@ static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
 				    ipv6_only_sock(sk), true, false);
 }
 
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk)
+{
+	kuid_t uid = sock_i_uid((struct sock *)sk);
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


