Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B948510F80
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 05:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357461AbiD0DZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 23:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiD0DZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 23:25:46 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEC3205E2;
        Tue, 26 Apr 2022 20:22:35 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id q75so471096qke.6;
        Tue, 26 Apr 2022 20:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sv6j3yQkqmqlnv/D43Xt3QFUU0mKBweO3ildOel+yQ0=;
        b=Ld1vmZkGyG2s7Qy6YmhBjJjVlHN5hziODK/eqnpBIpSoA3YfP9pvA8eNtwJzXapp+O
         vEHgO+PtIlaiBKajsGk9BXk1JdQw5n3pGPny9gK5ZL0Hr661YyqigweG9fT+Sm95CeUF
         xcnqVRutKzMWHgeQaTrSJVYpJT/BUl13M8MbbnxXhZgII3MI8l7bJKxRu+8FKqMitFXw
         PLFVVHMU/YXuMPfsZy8bHZR0pEOG3AuEBB58JHsFXw//IKfAxJjQ2vutGLwZ4xhaspZH
         t0cp0OIXVUTW3i1q4W9RPy+FN0+qIb5rva3GeycqD9ZSicvz/Er3zFg2fpY3NrFNQHai
         qKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sv6j3yQkqmqlnv/D43Xt3QFUU0mKBweO3ildOel+yQ0=;
        b=e6AvmyxWGz+omNV8UM+XLUotWwsOtmJWMXPHyGoVJL8EYQsUpyxPmHqKedIJPzm/sR
         ZqAOB0UzfTV81UQ5DZ5pegk45Frs6q3nCUE1y1qlhlY+exMjY1HlmLQtfkFGoeXpDYHQ
         cjWFGKiHOnkACPRUaDLqZVgqWl0GhL7FD1GwULdKRswcXinUfII/GIhbCi1tK/STd/RX
         yi46YUyYRsLsb4eRw6WG61BdaiwaRcIaOCaBWR/fZ+yXvnSFlPzxJf33neu+2i1N64jk
         5nZbslkBuOExaimcfO8RwobNPMEvfL/RckjfUtMvQf1v77X/sTPphToFVVvq/D6DJMH0
         tujQ==
X-Gm-Message-State: AOAM530gu6qOMNUSq6yq0kKEjg8gsvI30m/oH0lTx8gv0baMtYYyylfF
        Q9NH3/f8GMM8eQAlWgbEV5I=
X-Google-Smtp-Source: ABdhPJzESuC/cwch4IxN3PDksjLOFNh9YqBLO8cV1FYh3am8pn5iP1U+58Am0SOHQ1afQjnEsj5zxg==
X-Received: by 2002:a37:b984:0:b0:67f:64a2:313e with SMTP id j126-20020a37b984000000b0067f64a2313emr14684905qkf.3.1651029754451;
        Tue, 26 Apr 2022 20:22:34 -0700 (PDT)
Received: from emn.localdomain. ([104.245.1.41])
        by smtp.googlemail.com with ESMTPSA id h5-20020a05622a170500b002f3818c7b92sm1237450qtk.49.2022.04.26.20.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 20:22:34 -0700 (PDT)
From:   Erin MacNeil <lnx.erin@gmail.com>
To:     lnx.erin@gmail.com
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Martynas Pumputis <m@lambda.lt>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Wei Wang <weiwan@google.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Florian Westphal <fw@strlen.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Richard Sanger <rsanger@wand.net.nz>,
        Yajun Deng <yajun.deng@linux.dev>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-can@vger.kernel.org, linux-wpan@vger.kernel.org,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next v2] net: Add SO_RCVMARK socket option to provide SO_MARK with recvmsg().
Date:   Tue, 26 Apr 2022 23:21:51 -0400
Message-Id: <20220427032212.28470-1-lnx.erin@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <202204270907.nUUrw3dS-lkp@intel.com>
References: <202204270907.nUUrw3dS-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a new socket option, SO_RCVMARK, to indicate that SO_MARK
should be included in the ancillary data returned by recvmsg().

Renamed the sock_recv_ts_and_drops() function to sock_recv_cmsgs().

Signed-off-by: Erin MacNeil <lnx.erin@gmail.com>
---
 arch/alpha/include/uapi/asm/socket.h    |  2 ++
 arch/mips/include/uapi/asm/socket.h     |  2 ++
 arch/parisc/include/uapi/asm/socket.h   |  2 ++
 arch/sparc/include/uapi/asm/socket.h    |  2 ++
 include/net/sock.h                      | 18 ++++++++++--------
 include/uapi/asm-generic/socket.h       |  2 ++
 net/atm/common.c                        |  2 +-
 net/bluetooth/af_bluetooth.c            |  4 ++--
 net/can/bcm.c                           |  2 +-
 net/can/j1939/socket.c                  |  2 +-
 net/can/raw.c                           |  2 +-
 net/core/sock.c                         |  7 +++++++
 net/ieee802154/socket.c                 |  4 ++--
 net/ipv4/raw.c                          |  2 +-
 net/ipv4/udp.c                          |  2 +-
 net/ipv6/raw.c                          |  2 +-
 net/ipv6/udp.c                          |  2 +-
 net/key/af_key.c                        |  2 +-
 net/mctp/af_mctp.c                      |  2 +-
 net/packet/af_packet.c                  |  2 +-
 net/sctp/socket.c                       |  2 +-
 net/socket.c                            | 15 ++++++++++++---
 tools/include/uapi/asm-generic/socket.h |  2 ++
 23 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 7d81535893af..739891b94136 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -135,6 +135,8 @@
 
 #define SO_TXREHASH		74
 
+#define SO_RCVMARK		75
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 1d55e57b8466..18f3d95ecfec 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -146,6 +146,8 @@
 
 #define SO_TXREHASH		74
 
+#define SO_RCVMARK		75
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 654061e0964e..f486d3dfb6bb 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -127,6 +127,8 @@
 
 #define SO_TXREHASH		0x4048
 
+#define SO_RCVMARK		0x4049
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 666f81e617ea..ff08038fc2b2 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -128,6 +128,8 @@
 
 #define SO_TXREHASH              0x0053
 
+#define SO_RCVMARK               0x0054
+
 
 #if !defined(__KERNEL__)
 
diff --git a/include/net/sock.h b/include/net/sock.h
index a01d6c421aa2..30e7cbad194c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -895,6 +895,7 @@ enum sock_flags {
 	SOCK_TXTIME,
 	SOCK_XDP, /* XDP is attached */
 	SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
+	SOCK_RCVMARK, /* Receive SO_MARK  ancillary data with packet */
 };
 
 #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
@@ -2649,20 +2650,21 @@ sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 		__sock_recv_wifi_status(msg, sk, skb);
 }
 
-void __sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
-			      struct sk_buff *skb);
+void __sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
+		       struct sk_buff *skb);
 
 #define SK_DEFAULT_STAMP (-1L * NSEC_PER_SEC)
-static inline void sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
-					  struct sk_buff *skb)
+static inline void sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
+				   struct sk_buff *skb)
 {
-#define FLAGS_TS_OR_DROPS ((1UL << SOCK_RXQ_OVFL)			| \
-			   (1UL << SOCK_RCVTSTAMP))
+#define FLAGS_RECV_CMSGS ((1UL << SOCK_RXQ_OVFL)			| \
+			   (1UL << SOCK_RCVTSTAMP)			| \
+			   (1UL << SOCK_RCVMARK))
 #define TSFLAGS_ANY	  (SOF_TIMESTAMPING_SOFTWARE			| \
 			   SOF_TIMESTAMPING_RAW_HARDWARE)
 
-	if (sk->sk_flags & FLAGS_TS_OR_DROPS || sk->sk_tsflags & TSFLAGS_ANY)
-		__sock_recv_ts_and_drops(msg, sk, skb);
+	if (sk->sk_flags & FLAGS_RECV_CMSGS || sk->sk_tsflags & TSFLAGS_ANY)
+		__sock_recv_cmsgs(msg, sk, skb);
 	else if (unlikely(sock_flag(sk, SOCK_TIMESTAMP)))
 		sock_write_timestamp(sk, skb->tstamp);
 	else if (unlikely(sk->sk_stamp == SK_DEFAULT_STAMP))
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 467ca2f28760..638230899e98 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -130,6 +130,8 @@
 
 #define SO_TXREHASH		74
 
+#define SO_RCVMARK		75
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/atm/common.c b/net/atm/common.c
index d0c8ab7ff8f6..f7019df41c3e 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -553,7 +553,7 @@ int vcc_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	error = skb_copy_datagram_msg(skb, 0, msg, copied);
 	if (error)
 		return error;
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (!(flags & MSG_PEEK)) {
 		pr_debug("%d -= %d\n", atomic_read(&sk->sk_rmem_alloc),
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 62705734343b..b506409bb498 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -280,7 +280,7 @@ int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	skb_reset_transport_header(skb);
 	err = skb_copy_datagram_msg(skb, 0, msg, copied);
 	if (err == 0) {
-		sock_recv_ts_and_drops(msg, sk, skb);
+		sock_recv_cmsgs(msg, sk, skb);
 
 		if (msg->msg_name && bt_sk(sk)->skb_msg_name)
 			bt_sk(sk)->skb_msg_name(skb, msg->msg_name,
@@ -384,7 +384,7 @@ int bt_sock_stream_recvmsg(struct socket *sock, struct msghdr *msg,
 		copied += chunk;
 		size   -= chunk;
 
-		sock_recv_ts_and_drops(msg, sk, skb);
+		sock_recv_cmsgs(msg, sk, skb);
 
 		if (!(flags & MSG_PEEK)) {
 			int skb_len = skb_headlen(skb);
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 64c07e650bb4..65ee1b784a30 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1647,7 +1647,7 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		return err;
 	}
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (msg->msg_name) {
 		__sockaddr_check_size(BCM_MIN_NAMELEN);
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 0bb4fd3f6264..f5ecfdcf57b2 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -841,7 +841,7 @@ static int j1939_sk_recvmsg(struct socket *sock, struct msghdr *msg,
 		paddr->can_addr.j1939.pgn = skcb->addr.pgn;
 	}
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 	msg->msg_flags |= skcb->msg_flags;
 	skb_free_datagram(sk, skb);
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 0cf728dcff36..b7dbb57557f3 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -866,7 +866,7 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		return err;
 	}
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (msg->msg_name) {
 		__sockaddr_check_size(RAW_MIN_NAMELEN);
diff --git a/net/core/sock.c b/net/core/sock.c
index 29abec3eabd8..673b6e49f109 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1311,6 +1311,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 		__sock_set_mark(sk, val);
 		break;
+	case SO_RCVMARK:
+		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
+		break;
 
 	case SO_RXQ_OVFL:
 		sock_valbool_flag(sk, SOCK_RXQ_OVFL, valbool);
@@ -1737,6 +1740,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_mark;
 		break;
 
+	case SO_RCVMARK:
+		v.val = sock_flag(sk, SOCK_RCVMARK);
+		break;
+
 	case SO_RXQ_OVFL:
 		v.val = sock_flag(sk, SOCK_RXQ_OVFL);
 		break;
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index f24852814fa3..718fb77bb372 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -328,7 +328,7 @@ static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (err)
 		goto done;
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (flags & MSG_TRUNC)
 		copied = skb->len;
@@ -718,7 +718,7 @@ static int dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (err)
 		goto done;
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (saddr) {
 		/* Clear the implicit padding in struct sockaddr_ieee802154
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 4056b0da85ea..bbd717805b10 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -783,7 +783,7 @@ static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (err)
 		goto done;
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	/* Copy the address. */
 	if (sin) {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa8545ca6964..9d5071c79c95 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1909,7 +1909,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		UDP_INC_STATS(sock_net(sk),
 			      UDP_MIB_INDATAGRAMS, is_udplite);
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	/* Copy the address. */
 	if (sin) {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 0d7c13d33d1a..3b7cbd522b54 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -512,7 +512,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		*addr_len = sizeof(*sin6);
 	}
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (np->rxopt.all)
 		ip6_datagram_recv_ctl(sk, msg, skb);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 688af6f809fe..3fc97d4621ac 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -391,7 +391,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (!peeking)
 		SNMP_INC_STATS(mib, UDP_MIB_INDATAGRAMS);
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	/* Copy the address. */
 	if (msg->msg_name) {
diff --git a/net/key/af_key.c b/net/key/af_key.c
index d09ec26b1081..175a162eec58 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3711,7 +3711,7 @@ static int pfkey_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (err)
 		goto out_free;
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	err = (flags & MSG_TRUNC) ? skb->len : copied;
 
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 221863afc4b1..c2fc2a7b2528 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -238,7 +238,7 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (rc < 0)
 		goto out_free;
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (addr) {
 		struct mctp_skb_cb *cb = mctp_cb(skb);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index fd31334cf688..677f9cfa9660 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3477,7 +3477,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		sll->sll_protocol = skb->protocol;
 	}
 
-	sock_recv_ts_and_drops(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (msg->msg_name) {
 		const size_t max_len = min(sizeof(skb->cb),
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3e3fe923bed5..6d37d2dfb3da 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2128,7 +2128,7 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		head_skb = event->chunk->head_skb;
 	else
 		head_skb = skb;
-	sock_recv_ts_and_drops(msg, sk, head_skb);
+	sock_recv_cmsgs(msg, sk, head_skb);
 	if (sctp_ulpevent_is_notification(event)) {
 		msg->msg_flags |= MSG_NOTIFICATION;
 		sp->pf->event_msgname(event, msg->msg_name, addr_len);
diff --git a/net/socket.c b/net/socket.c
index 6887840682bb..f0c39c874665 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -930,13 +930,22 @@ static inline void sock_recv_drops(struct msghdr *msg, struct sock *sk,
 			sizeof(__u32), &SOCK_SKB_CB(skb)->dropcount);
 }
 
-void __sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
-	struct sk_buff *skb)
+static void sock_recv_mark(struct msghdr *msg, struct sock *sk,
+			   struct sk_buff *skb)
+{
+	if (sock_flag(sk, SOCK_RCVMARK) && skb)
+		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32),
+			 &skb->mark);
+}
+
+void __sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
+		       struct sk_buff *skb)
 {
 	sock_recv_timestamp(msg, sk, skb);
 	sock_recv_drops(msg, sk, skb);
+	sock_recv_mark(msg, sk, skb);
 }
-EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
+EXPORT_SYMBOL_GPL(__sock_recv_cmsgs);
 
 INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
 					   size_t, int));
diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..8756df13be50 100644
--- a/tools/include/uapi/asm-generic/socket.h
+++ b/tools/include/uapi/asm-generic/socket.h
@@ -119,6 +119,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_RCVMARK		75
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
-- 
2.20.1

