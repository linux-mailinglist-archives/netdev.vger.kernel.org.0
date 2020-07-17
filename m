Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875762233C4
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGQGYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgGQGYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86202C08C5C0;
        Thu, 16 Jul 2020 23:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kbGmHpM4oj2iSBg8afJLPvPTqr4Oo7etdmQf4Gx3p6g=; b=enqk4z7AtkWvVVT0ktmRixHxYG
        ZE6nr495nmVeqXTvqNhSZAk/LeaHFxGyOtXhcccmzRAlDjVvCGobT5rvHbv8NtqQVHaaC0xnJ3Hb9
        Er4n5IYTU1mkuPplXbnndtuOcDytQpv+nxt2M2mW36ArSipGP+w85zBQ6rbtZjlLM/sDr+9hGxTHZ
        Qlr1OYczhUpJGuvEig/YgFx4M/upAXCRfjYxwDUMHdHL9JWNfSAGdJfBWwKwwpLzh7X4CsuKqjYrI
        r7j1ievIEPg0b6BeMmzWbCoFv1zqE/m3+gPFPm60upHtjdfqlSfIuBgAOyTb4MtC1WwSlbOkQ2ELx
        UAjW3v0A==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJnM-000576-Cm; Fri, 17 Jul 2020 06:24:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 22/22] net: make ->{get,set}sockopt in proto_ops optional
Date:   Fri, 17 Jul 2020 08:23:31 +0200
Message-Id: <20200717062331.691152-23-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just check for a NULL method instead of wiring up
sock_no_{get,set}sockopt.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/af_alg.c             |  1 -
 crypto/algif_aead.c         |  4 ----
 crypto/algif_hash.c         |  4 ----
 crypto/algif_rng.c          |  2 --
 crypto/algif_skcipher.c     |  4 ----
 drivers/isdn/mISDN/socket.c |  2 --
 drivers/net/ppp/pppoe.c     |  2 --
 drivers/net/ppp/pptp.c      |  2 --
 include/net/sock.h          |  2 --
 net/appletalk/ddp.c         |  2 --
 net/bluetooth/bnep/sock.c   |  2 --
 net/bluetooth/cmtp/sock.c   |  2 --
 net/bluetooth/hidp/sock.c   |  2 --
 net/caif/caif_socket.c      |  2 --
 net/can/bcm.c               |  2 --
 net/core/sock.c             | 14 --------------
 net/key/af_key.c            |  2 --
 net/nfc/llcp_sock.c         |  2 --
 net/nfc/rawsock.c           |  4 ----
 net/packet/af_packet.c      |  2 --
 net/phonet/socket.c         |  2 --
 net/qrtr/qrtr.c             |  2 --
 net/smc/af_smc.c            |  9 +++++++--
 net/socket.c                |  4 ++++
 net/unix/af_unix.c          |  6 ------
 net/vmw_vsock/af_vsock.c    |  2 --
 26 files changed, 11 insertions(+), 73 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 28fc323e3fe304..29f71428520b4b 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -335,7 +335,6 @@ static const struct proto_ops alg_proto_ops = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.sendpage	=	sock_no_sendpage,
 	.sendmsg	=	sock_no_sendmsg,
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 0ae000a61c7f5b..527d09a694627b 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -361,11 +361,9 @@ static struct proto_ops algif_aead_ops = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
-	.setsockopt	=	sock_no_setsockopt,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	aead_sendmsg,
@@ -454,11 +452,9 @@ static struct proto_ops algif_aead_ops_nokey = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
-	.setsockopt	=	sock_no_setsockopt,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	aead_sendmsg_nokey,
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index e71727c25a7db7..50f7b22f1b4825 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -279,10 +279,8 @@ static struct proto_ops algif_hash_ops = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
-	.setsockopt	=	sock_no_setsockopt,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg,
@@ -383,10 +381,8 @@ static struct proto_ops algif_hash_ops_nokey = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
-	.setsockopt	=	sock_no_setsockopt,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg_nokey,
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 087c0ad09d382b..6300e0566dc560 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -101,11 +101,9 @@ static struct proto_ops algif_rng_ops = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
-	.setsockopt	=	sock_no_setsockopt,
 	.sendmsg	=	sock_no_sendmsg,
 	.sendpage	=	sock_no_sendpage,
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ec5567c87a6df4..c487887f46711e 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -188,11 +188,9 @@ static struct proto_ops algif_skcipher_ops = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
-	.setsockopt	=	sock_no_setsockopt,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	skcipher_sendmsg,
@@ -281,11 +279,9 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
-	.setsockopt	=	sock_no_setsockopt,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	skcipher_sendmsg_nokey,
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index dff4132b3702c6..1b2b91479107bc 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -738,8 +738,6 @@ static const struct proto_ops base_sock_ops = {
 	.recvmsg	= sock_no_recvmsg,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.connect	= sock_no_connect,
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index beedaad082551b..d7f50b835050d1 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1110,8 +1110,6 @@ static const struct proto_ops pppoe_ops = {
 	.poll		= datagram_poll,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.sendmsg	= pppoe_sendmsg,
 	.recvmsg	= pppoe_recvmsg,
 	.mmap		= sock_no_mmap,
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index acccb747aedad6..ee5058445d06e2 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -618,8 +618,6 @@ static const struct proto_ops pptp_ops = {
 	.getname    = pptp_getname,
 	.listen     = sock_no_listen,
 	.shutdown   = sock_no_shutdown,
-	.setsockopt = sock_no_setsockopt,
-	.getsockopt = sock_no_getsockopt,
 	.sendmsg    = sock_no_sendmsg,
 	.recvmsg    = sock_no_recvmsg,
 	.mmap       = sock_no_mmap,
diff --git a/include/net/sock.h b/include/net/sock.h
index 3bd8bc578bf3e5..62e18fc8ac9f96 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1714,8 +1714,6 @@ int sock_no_getname(struct socket *, struct sockaddr *, int);
 int sock_no_ioctl(struct socket *, unsigned int, unsigned long);
 int sock_no_listen(struct socket *, int);
 int sock_no_shutdown(struct socket *, int);
-int sock_no_getsockopt(struct socket *, int , int, char __user *, int __user *);
-int sock_no_setsockopt(struct socket *, int, int, char __user *, unsigned int);
 int sock_no_sendmsg(struct socket *, struct msghdr *, size_t);
 int sock_no_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len);
 int sock_no_recvmsg(struct socket *, struct msghdr *, size_t, int);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 15787e8c0629a0..1d48708c5a2eb5 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1917,8 +1917,6 @@ static const struct proto_ops atalk_dgram_ops = {
 #endif
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.sendmsg	= atalk_sendmsg,
 	.recvmsg	= atalk_recvmsg,
 	.mmap		= sock_no_mmap,
diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index cfd83c5521aecc..d515571b2afba9 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -182,8 +182,6 @@ static const struct proto_ops bnep_sock_ops = {
 	.recvmsg	= sock_no_recvmsg,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.connect	= sock_no_connect,
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index defdd4871919f3..96d49d9fae9643 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -185,8 +185,6 @@ static const struct proto_ops cmtp_sock_ops = {
 	.recvmsg	= sock_no_recvmsg,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.connect	= sock_no_connect,
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 03be6a4baef30e..595fb3c9d6c361 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -233,8 +233,6 @@ static const struct proto_ops hidp_sock_ops = {
 	.recvmsg	= sock_no_recvmsg,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.connect	= sock_no_connect,
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index ef14da50a98191..b94ecd931002e7 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -981,7 +981,6 @@ static const struct proto_ops caif_seqpacket_ops = {
 	.listen = sock_no_listen,
 	.shutdown = sock_no_shutdown,
 	.setsockopt = setsockopt,
-	.getsockopt = sock_no_getsockopt,
 	.sendmsg = caif_seqpkt_sendmsg,
 	.recvmsg = caif_seqpkt_recvmsg,
 	.mmap = sock_no_mmap,
@@ -1002,7 +1001,6 @@ static const struct proto_ops caif_stream_ops = {
 	.listen = sock_no_listen,
 	.shutdown = sock_no_shutdown,
 	.setsockopt = setsockopt,
-	.getsockopt = sock_no_getsockopt,
 	.sendmsg = caif_stream_sendmsg,
 	.recvmsg = caif_stream_recvmsg,
 	.mmap = sock_no_mmap,
diff --git a/net/can/bcm.c b/net/can/bcm.c
index c96fa0f33db39c..d14ea12affb112 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1648,8 +1648,6 @@ static const struct proto_ops bcm_ops = {
 	.gettstamp     = sock_gettstamp,
 	.listen        = sock_no_listen,
 	.shutdown      = sock_no_shutdown,
-	.setsockopt    = sock_no_setsockopt,
-	.getsockopt    = sock_no_getsockopt,
 	.sendmsg       = bcm_sendmsg,
 	.recvmsg       = bcm_recvmsg,
 	.mmap          = sock_no_mmap,
diff --git a/net/core/sock.c b/net/core/sock.c
index 48655d5c4cf37a..d828bfe1c47dfa 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2783,20 +2783,6 @@ int sock_no_shutdown(struct socket *sock, int how)
 }
 EXPORT_SYMBOL(sock_no_shutdown);
 
-int sock_no_setsockopt(struct socket *sock, int level, int optname,
-		    char __user *optval, unsigned int optlen)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL(sock_no_setsockopt);
-
-int sock_no_getsockopt(struct socket *sock, int level, int optname,
-		    char __user *optval, int __user *optlen)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL(sock_no_getsockopt);
-
 int sock_no_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
 {
 	return -EOPNOTSUPP;
diff --git a/net/key/af_key.c b/net/key/af_key.c
index b67ed3a8486c25..f13626c1a98592 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3734,8 +3734,6 @@ static const struct proto_ops pfkey_ops = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.setsockopt	=	sock_no_setsockopt,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.sendpage	=	sock_no_sendpage,
 
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 28604414dec1b7..6da1e2334bb697 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -921,8 +921,6 @@ static const struct proto_ops llcp_rawsock_ops = {
 	.ioctl          = sock_no_ioctl,
 	.listen         = sock_no_listen,
 	.shutdown       = sock_no_shutdown,
-	.setsockopt     = sock_no_setsockopt,
-	.getsockopt     = sock_no_getsockopt,
 	.sendmsg        = sock_no_sendmsg,
 	.recvmsg        = llcp_sock_recvmsg,
 	.mmap           = sock_no_mmap,
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index ba5ffd3badd324..b2061b6746eaa6 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -276,8 +276,6 @@ static const struct proto_ops rawsock_ops = {
 	.ioctl          = sock_no_ioctl,
 	.listen         = sock_no_listen,
 	.shutdown       = sock_no_shutdown,
-	.setsockopt     = sock_no_setsockopt,
-	.getsockopt     = sock_no_getsockopt,
 	.sendmsg        = rawsock_sendmsg,
 	.recvmsg        = rawsock_recvmsg,
 	.mmap           = sock_no_mmap,
@@ -296,8 +294,6 @@ static const struct proto_ops rawsock_raw_ops = {
 	.ioctl          = sock_no_ioctl,
 	.listen         = sock_no_listen,
 	.shutdown       = sock_no_shutdown,
-	.setsockopt     = sock_no_setsockopt,
-	.getsockopt     = sock_no_getsockopt,
 	.sendmsg        = sock_no_sendmsg,
 	.recvmsg        = rawsock_recvmsg,
 	.mmap           = sock_no_mmap,
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 35aee9e980536d..c240fb5de3f014 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4503,8 +4503,6 @@ static const struct proto_ops packet_ops_spkt = {
 	.gettstamp =	sock_gettstamp,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
-	.setsockopt =	sock_no_setsockopt,
-	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	packet_sendmsg_spkt,
 	.recvmsg =	packet_recvmsg,
 	.mmap =		sock_no_mmap,
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 87c60f83c18061..2599235d592e0b 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -439,8 +439,6 @@ const struct proto_ops phonet_dgram_ops = {
 	.ioctl		= pn_socket_ioctl,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.sendmsg	= pn_socket_sendmsg,
 	.recvmsg	= sock_common_recvmsg,
 	.mmap		= sock_no_mmap,
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 24a8c3c6da0dca..0cb4adfc6641da 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1208,8 +1208,6 @@ static const struct proto_ops qrtr_proto_ops = {
 	.gettstamp	= sock_gettstamp,
 	.poll		= datagram_poll,
 	.shutdown	= sock_no_shutdown,
-	.setsockopt	= sock_no_setsockopt,
-	.getsockopt	= sock_no_getsockopt,
 	.release	= qrtr_release,
 	.mmap		= sock_no_mmap,
 	.sendpage	= sock_no_sendpage,
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 9033215438384b..9711c9e0e515bf 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1742,8 +1742,11 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	/* generic setsockopts reaching us here always apply to the
 	 * CLC socket
 	 */
-	rc = smc->clcsock->ops->setsockopt(smc->clcsock, level, optname,
-					   optval, optlen);
+	if (unlikely(!smc->clcsock->ops->setsockopt))
+		rc = -EOPNOTSUPP;
+	else
+		rc = smc->clcsock->ops->setsockopt(smc->clcsock, level, optname,
+						   optval, optlen);
 	if (smc->clcsock->sk->sk_err) {
 		sk->sk_err = smc->clcsock->sk->sk_err;
 		sk->sk_error_report(sk);
@@ -1808,6 +1811,8 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
 
 	smc = smc_sk(sock->sk);
 	/* socket options apply to the CLC socket */
+	if (unlikely(!smc->clcsock->ops->getsockopt))
+		return -EOPNOTSUPP;
 	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
 					     optval, optlen);
 }
diff --git a/net/socket.c b/net/socket.c
index dec345982abbb6..93846568c2fb7a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2131,6 +2131,8 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *optval,
 
 	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
 		err = sock_setsockopt(sock, level, optname, optval, optlen);
+	else if (unlikely(!sock->ops->setsockopt))
+		err = -EOPNOTSUPP;
 	else
 		err = sock->ops->setsockopt(sock, level, optname, optval,
 					    optlen);
@@ -2175,6 +2177,8 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 
 	if (level == SOL_SOCKET)
 		err = sock_getsockopt(sock, level, optname, optval, optlen);
+	else if (unlikely(!sock->ops->getsockopt))
+		err = -EOPNOTSUPP;
 	else
 		err = sock->ops->getsockopt(sock, level, optname, optval,
 					    optlen);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3385a7a0b23133..181ea6fb56a617 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -714,8 +714,6 @@ static const struct proto_ops unix_stream_ops = {
 #endif
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
-	.setsockopt =	sock_no_setsockopt,
-	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_stream_sendmsg,
 	.recvmsg =	unix_stream_recvmsg,
 	.mmap =		sock_no_mmap,
@@ -741,8 +739,6 @@ static const struct proto_ops unix_dgram_ops = {
 #endif
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
-	.setsockopt =	sock_no_setsockopt,
-	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_dgram_sendmsg,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
@@ -767,8 +763,6 @@ static const struct proto_ops unix_seqpacket_ops = {
 #endif
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
-	.setsockopt =	sock_no_setsockopt,
-	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_seqpacket_sendmsg,
 	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 626bf9044418cc..df204c6761c453 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1202,8 +1202,6 @@ static const struct proto_ops vsock_dgram_ops = {
 	.ioctl = sock_no_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = vsock_shutdown,
-	.setsockopt = sock_no_setsockopt,
-	.getsockopt = sock_no_getsockopt,
 	.sendmsg = vsock_dgram_sendmsg,
 	.recvmsg = vsock_dgram_recvmsg,
 	.mmap = sock_no_mmap,
-- 
2.27.0

