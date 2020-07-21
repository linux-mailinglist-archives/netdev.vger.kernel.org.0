Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A6D22879A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGURlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:52 -0400
Received: from mail.katalix.com ([3.9.82.81]:53302 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730455AbgGURlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:03 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id DC6D493AFA;
        Tue, 21 Jul 2020 18:33:00 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352780; bh=T8EKDvC6/rl+JkX6WZE8/OJ5t8Z6y7nC/xL5xJbewtY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2011/29]=20l2tp:=20cleanup=20unnecessary=20braces=20in=20if=20
         statements|Date:=20Tue,=2021=20Jul=202020=2018:32:03=20+0100|Messa
         ge-Id:=20<20200721173221.4681-12-tparkin@katalix.com>|In-Reply-To:
         =20<20200721173221.4681-1-tparkin@katalix.com>|References:=20<2020
         0721173221.4681-1-tparkin@katalix.com>;
        b=X4rOBOwBdcfFRna9n7ISENfdi0kub4HP4oNzmhBFJSaxQHmovJw5NxZ9FlyEGmOMJ
         NZVGWcXE7hYtzL5kpoxZMlkr6N7MTk/PqTFs7W9NMyiXJjXErUhbsWIaRGdruLsDz/
         N7ZWNb+qqEgWzGD0sjs4+Vl1aGVpOzvBBNr7UMGrOS+hsShCJAww8l2Ra382dVjkbr
         XBvUHknS46oaiPiaXaxF7w41Vm3GQuZB7WtmQ+1H0/vWOJXIC4WmGiDD+y97v52Wop
         WhtyALq28+7f+qcFAkVs3a5nbM/89Miw04Ddxsw2IkwSqKd0zMBc+hayKiDrdvAJrm
         cPhafDbyuQlcQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 11/29] l2tp: cleanup unnecessary braces in if statements
Date:   Tue, 21 Jul 2020 18:32:03 +0100
Message-Id: <20200721173221.4681-12-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These checks are all simple and don't benefit from extra braces to
clarify intent.  Remove them for easier-reading code.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c |  6 +++---
 net/l2tp/l2tp_ppp.c  | 23 +++++++++--------------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index dc8cb1fe94dc..acba7757bd79 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -681,7 +681,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * check if we sre sending sequence numbers and if not,
 		 * configure it so.
 		 */
-		if ((!session->lns_mode) && (!session->send_seq)) {
+		if (!session->lns_mode && !session->send_seq) {
 			l2tp_info(session, L2TP_MSG_SEQ,
 				  "%s: requested to enable seq numbers by LNS\n",
 				  session->name);
@@ -705,7 +705,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * If we're the LNS and we're sending sequence numbers, the
 		 * LAC is broken. Discard the frame.
 		 */
-		if ((!session->lns_mode) && (session->send_seq)) {
+		if (!session->lns_mode && session->send_seq) {
 			l2tp_info(session, L2TP_MSG_SEQ,
 				  "%s: requested to disable seq numbers by LNS\n",
 				  session->name);
@@ -1387,7 +1387,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 
 out:
 	*sockp = sock;
-	if ((err < 0) && sock) {
+	if (err < 0 && sock) {
 		kernel_sock_shutdown(sock, SHUT_RDWR);
 		sock_release(sock);
 		*sockp = NULL;
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 7404661d4117..e58fe7e3b884 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -802,8 +802,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	 * the internal context for use by ioctl() and sockopt()
 	 * handlers.
 	 */
-	if ((session->session_id == 0) &&
-	    (session->peer_session_id == 0)) {
+	if (session->session_id == 0 && session->peer_session_id == 0) {
 		error = 0;
 		goto out_no_ppp;
 	}
@@ -925,7 +924,7 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 	tunnel = session->tunnel;
 
 	inet = inet_sk(tunnel->sock);
-	if ((tunnel->version == 2) && (tunnel->sock->sk_family == AF_INET)) {
+	if (tunnel->version == 2 && tunnel->sock->sk_family == AF_INET) {
 		struct sockaddr_pppol2tp sp;
 
 		len = sizeof(sp);
@@ -943,8 +942,7 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 		sp.pppol2tp.addr.sin_addr.s_addr = inet->inet_daddr;
 		memcpy(uaddr, &sp, len);
 #if IS_ENABLED(CONFIG_IPV6)
-	} else if ((tunnel->version == 2) &&
-		   (tunnel->sock->sk_family == AF_INET6)) {
+	} else if (tunnel->version == 2 && tunnel->sock->sk_family == AF_INET6) {
 		struct sockaddr_pppol2tpin6 sp;
 
 		len = sizeof(sp);
@@ -962,8 +960,7 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 		memcpy(&sp.pppol2tp.addr.sin6_addr, &tunnel->sock->sk_v6_daddr,
 		       sizeof(tunnel->sock->sk_v6_daddr));
 		memcpy(uaddr, &sp, len);
-	} else if ((tunnel->version == 3) &&
-		   (tunnel->sock->sk_family == AF_INET6)) {
+	} else if (tunnel->version == 3 && tunnel->sock->sk_family == AF_INET6) {
 		struct sockaddr_pppol2tpv3in6 sp;
 
 		len = sizeof(sp);
@@ -1179,7 +1176,7 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 
 	switch (optname) {
 	case PPPOL2TP_SO_RECVSEQ:
-		if ((val != 0) && (val != 1)) {
+		if (val != 0 && val != 1) {
 			err = -EINVAL;
 			break;
 		}
@@ -1190,7 +1187,7 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 		break;
 
 	case PPPOL2TP_SO_SENDSEQ:
-		if ((val != 0) && (val != 1)) {
+		if (val != 0 && val != 1) {
 			err = -EINVAL;
 			break;
 		}
@@ -1208,7 +1205,7 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 		break;
 
 	case PPPOL2TP_SO_LNSMODE:
-		if ((val != 0) && (val != 1)) {
+		if (val != 0 && val != 1) {
 			err = -EINVAL;
 			break;
 		}
@@ -1274,8 +1271,7 @@ static int pppol2tp_setsockopt(struct socket *sock, int level, int optname,
 
 	/* Special case: if session_id == 0x0000, treat as operation on tunnel
 	 */
-	if ((session->session_id == 0) &&
-	    (session->peer_session_id == 0)) {
+	if (session->session_id == 0 && session->peer_session_id == 0) {
 		tunnel = session->tunnel;
 		err = pppol2tp_tunnel_setsockopt(sk, tunnel, optname, val);
 	} else {
@@ -1392,8 +1388,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 		goto end;
 
 	/* Special case: if session_id == 0x0000, treat as operation on tunnel */
-	if ((session->session_id == 0) &&
-	    (session->peer_session_id == 0)) {
+	if (session->session_id == 0 && session->peer_session_id == 0) {
 		tunnel = session->tunnel;
 		err = pppol2tp_tunnel_getsockopt(sk, tunnel, optname, &val);
 		if (err)
-- 
2.17.1

