Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAB2B3043
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 15:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbfIONgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 09:36:33 -0400
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:53748 "EHLO
        resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbfIONgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 09:36:32 -0400
Received: from resomta-ch2-19v.sys.comcast.net ([69.252.207.115])
        by resqmta-ch2-10v.sys.comcast.net with ESMTP
        id 9Ty0iqSkcIBD89Uhbi5i6V; Sun, 15 Sep 2019 13:36:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
        s=20190202a; t=1568554591;
        bh=MEZp/vTJWRPhzWbE3MQ5arrdOQsBADZ2/C35BaUHlNA=;
        h=Received:Received:From:To:Subject:Date:Message-ID:MIME-Version:
         Content-Type;
        b=QZW2oc9tSyfggBbZ6m3dmOneBPM0wZUybFWNP2tA2HNGArF0UJf+yp6f1EsX4bB04
         E1aAPSEZQ5ARIsCGcDSTUFrRJ8sIKSzAEnRBcpuzLhgYow/UiSZw6frBucdvAWBvki
         8YDnUkZLfYsVJv62esKtj6XsP587Scz9LG0zOQXw92HXrgksOQHQOWvi33lOBH7nFm
         XijDjreXlGFED4iKHNCfiF5I2xtvnAf5tcoVehtf5Z+z4oJPn6w2NMGwH4uRMU8OX7
         fu7iguq6YtNgf1XIvRrjhQDzvFph1p46plCh8s0WvjLxNdQF7i5XiD0DcKfrIKXfsv
         Y7Q0D5ikuWi+Q==
Received: from DireWolf ([108.49.206.201])
        by resomta-ch2-19v.sys.comcast.net with ESMTPSA
        id 9UhFixDUKy6NS9UhGirnzE; Sun, 15 Sep 2019 13:36:28 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedufedruddugdeijecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfhfjgfufffkgggtgffothesthejghdtvddtvdenucfhrhhomhepfdfuthgvvhgvucgkrggsvghlvgdfuceoiigrsggvlhgvsegtohhmtggrshhtrdhnvghtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedutdekrdegledrvddtiedrvddtudenucfrrghrrghmpehhvghlohepffhirhgvhgholhhfpdhinhgvthepuddtkedrgeelrddvtdeirddvtddupdhmrghilhhfrhhomhepiigrsggvlhgvsegtohhmtggrshhtrdhnvghtpdhrtghpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopegvughumhgriigvthesghhoohhglhgvrdgtohhmpdhrtghpthhtohepkhhrrghighesghhoohhglhgvrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhkvggrthhonhesrhgrhihthhgvohhnrdgtohhmpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrsggvnhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhgvmhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhgvmhguvggsrhhuihhjnhdrkhgvrhhnvghlsehgmhgrihhlrdgtohhmnec
X-Xfinity-VMeta: sc=-100;st=legit
From:   "Steve Zabele" <zabele@comcast.net>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kraig@google.com>,
        <pabeni@redhat.com>, <mark.keaton@raytheon.com>,
        "'Willem de Bruijn'" <willemb@google.com>
References: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCH net] udp: correct reuseport selection with connected sockets
Date:   Sun, 15 Sep 2019 09:36:40 -0400
Message-ID: <007001d56bca$a65bd660$f3138320$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AdVp0OvzRFeXCUM2T92xo6v8c4r2ugB+Wszg
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Willem,

Thanks a bunch for getting this resolved, *very* much appreciated. This is a
really big help for us

Do you know if this will be backported to 4.19 stable, and if so when it
might be available??

Thanks again

Steve

-----Original Message-----
From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com] 
Sent: Thursday, September 12, 2019 9:17 PM
To: netdev@vger.kernel.org
Cc: davem@davemloft.net; edumazet@google.com; kraig@google.com;
zabele@comcast.net; pabeni@redhat.com; mark.keaton@raytheon.com; Willem de
Bruijn
Subject: [PATCH net] udp: correct reuseport selection with connected sockets

From: Willem de Bruijn <willemb@google.com>

UDP reuseport groups can hold a mix unconnected and connected sockets.
Ensure that connections only receive all traffic to their 4-tuple.

Fast reuseport returns on the first reuseport match on the assumption
that all matches are equal. Only if connections are present, return to
the previous behavior of scoring all sockets.

Record if connections are present and if so (1) treat such connected
sockets as an independent match from the group, (2) only return
2-tuple matches from reuseport and (3) do not return on the first
2-tuple reuseport match to allow for a higher scoring match later.

New field has_conns is set without locks. No other fields in the
bitmap are modified at runtime and the field is only ever set
unconditionally, so an RMW cannot miss a change.

Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
Link:
http://lkml.kernel.org/r/CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw
@mail.gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

I was unable to compile some older kernels, so the Fixes tag is based
on basic analysis, not bisected to by the regression test.
---
 include/net/sock_reuseport.h | 20 +++++++++++++++++++-
 net/core/sock_reuseport.c    | 15 +++++++++++++--
 net/ipv4/datagram.c          |  2 ++
 net/ipv4/udp.c               |  5 +++--
 net/ipv6/datagram.c          |  2 ++
 net/ipv6/udp.c               |  5 +++--
 6 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index d9112de85261..43f4a818d88f 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -21,7 +21,8 @@ struct sock_reuseport {
 	unsigned int		synq_overflow_ts;
 	/* ID stays the same even after the size of socks[] grows. */
 	unsigned int		reuseport_id;
-	bool			bind_inany;
+	unsigned int		bind_inany:1;
+	unsigned int		has_conns:1;
 	struct bpf_prog __rcu	*prog;		/* optional BPF sock
selector */
 	struct sock		*socks[0];	/* array of sock pointers */
 };
@@ -37,6 +38,23 @@ extern struct sock *reuseport_select_sock(struct sock
*sk,
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
+static inline bool reuseport_has_conns(struct sock *sk, bool set)
+{
+	struct sock_reuseport *reuse;
+	bool ret = false;
+
+	rcu_read_lock();
+	reuse = rcu_dereference(sk->sk_reuseport_cb);
+	if (reuse) {
+		if (set)
+			reuse->has_conns = 1;
+		ret = reuse->has_conns;
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 int reuseport_get_id(struct sock_reuseport *reuse);
 
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 9408f9264d05..f3ceec93f392 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -295,8 +295,19 @@ struct sock *reuseport_select_sock(struct sock *sk,
 
 select_by_hash:
 		/* no bpf or invalid bpf result: fall back to hash usage */
-		if (!sk2)
-			sk2 = reuse->socks[reciprocal_scale(hash, socks)];
+		if (!sk2) {
+			int i, j;
+
+			i = j = reciprocal_scale(hash, socks);
+			while (reuse->socks[i]->sk_state == TCP_ESTABLISHED)
{
+				i++;
+				if (i >= reuse->num_socks)
+					i = 0;
+				if (i == j)
+					goto out;
+			}
+			sk2 = reuse->socks[i];
+		}
 	}
 
 out:
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 7bd29e694603..9a0fe0c2fa02 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -15,6 +15,7 @@
 #include <net/sock.h>
 #include <net/route.h>
 #include <net/tcp_states.h>
+#include <net/sock_reuseport.h>
 
 int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int
addr_len)
 {
@@ -69,6 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct
sockaddr *uaddr, int addr_len
 	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
+	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 	inet->inet_id = jiffies;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d88821c794fb..16486c8b708b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -423,12 +423,13 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			if (sk->sk_reuseport) {
+			if (sk->sk_reuseport &&
+			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp_ehashfn(net, daddr, hnum,
 						   saddr, sport);
 				result = reuseport_select_sock(sk, hash,
skb,
 							sizeof(struct
udphdr));
-				if (result)
+				if (result && !reuseport_has_conns(sk,
false))
 					return result;
 			}
 			badness = score;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 9ab897ded4df..96f939248d2f 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -27,6 +27,7 @@
 #include <net/ip6_route.h>
 #include <net/tcp_states.h>
 #include <net/dsfield.h>
+#include <net/sock_reuseport.h>
 
 #include <linux/errqueue.h>
 #include <linux/uaccess.h>
@@ -254,6 +255,7 @@ int __ip6_datagram_connect(struct sock *sk, struct
sockaddr *uaddr,
 		goto out;
 	}
 
+	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 out:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 827fe7385078..5995fdc99d3f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -158,13 +158,14 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			if (sk->sk_reuseport) {
+			if (sk->sk_reuseport &&
+			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp6_ehashfn(net, daddr, hnum,
 						    saddr, sport);
 
 				result = reuseport_select_sock(sk, hash,
skb,
 							sizeof(struct
udphdr));
-				if (result)
+				if (result && !reuseport_has_conns(sk,
false))
 					return result;
 			}
 			result = sk;
-- 
2.23.0.237.gc6a4ce50a0-goog

