Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D96229D27
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbgGVQcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:42 -0400
Received: from mail.katalix.com ([3.9.82.81]:35448 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbgGVQch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 12:32:37 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id CA04C915B2;
        Wed, 22 Jul 2020 17:32:34 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435554; bh=35lKuYCo1lXNC+EP8vmRdxrDbzMh1bTqm/rBKxuCKmw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2003/10]=20l2tp:=20cleanup=20dif
         ficult-to-read=20line=20breaks|Date:=20Wed,=2022=20Jul=202020=2017
         :32:07=20+0100|Message-Id:=20<20200722163214.7920-4-tparkin@katali
         x.com>|In-Reply-To:=20<20200722163214.7920-1-tparkin@katalix.com>|
         References:=20<20200722163214.7920-1-tparkin@katalix.com>;
        b=zDYvCHLXYK5A8JshU7aA56zdzaDWS5YBSQt2XDkUpwUtdEHGQm3TVS4Z8Q9qGFTsD
         WBXEznKduT388owd518jlUGNQTOoRA327Ky/8Qh9IZ8oCAtF0F2uPwV6mUZuupX5xt
         OY8j1GWG1na2WmeEFkauBSY8EK6l8z7zfsrbgOslAB9Yg4lj65U6GH22eLgfnutaB4
         JHcObSwNYCDQ+dKOafa5LKZIuuc2JtHwd7SbJTiVipuJtqm0uHqsqGz34evUH3wWyq
         /X+9ao7zw16w+UzUENO9HsD5iP8+Z2iZhSPsB+XU6+XL9YSNxFO1+wiiI3vPxRmVI5
         u+05E3jihD72Q==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 03/10] l2tp: cleanup difficult-to-read line breaks
Date:   Wed, 22 Jul 2020 17:32:07 +0100
Message-Id: <20200722163214.7920-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some l2tp code had line breaks which made the code more difficult to
read.  These were originally motivated by the 80-character line width
coding guidelines, but were actually a negative from the perspective of
trying to follow the code.

Remove these linebreaks for clearer code, even if we do exceed 80
characters in width in some places.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_netlink.c | 69 +++++++++++++++++------------------------
 net/l2tp/l2tp_ppp.c     |  6 ++--
 2 files changed, 31 insertions(+), 44 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 3120f8dcc56a..42b409bc0de7 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -165,71 +165,63 @@ static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info
 	struct l2tp_tunnel_cfg cfg = { 0, };
 	struct l2tp_tunnel *tunnel;
 	struct net *net = genl_info_net(info);
+	struct nlattr **attrs = info->attrs;
 
-	if (!info->attrs[L2TP_ATTR_CONN_ID]) {
+	if (!attrs[L2TP_ATTR_CONN_ID]) {
 		ret = -EINVAL;
 		goto out;
 	}
-	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
+	tunnel_id = nla_get_u32(attrs[L2TP_ATTR_CONN_ID]);
 
-	if (!info->attrs[L2TP_ATTR_PEER_CONN_ID]) {
+	if (!attrs[L2TP_ATTR_PEER_CONN_ID]) {
 		ret = -EINVAL;
 		goto out;
 	}
-	peer_tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_PEER_CONN_ID]);
+	peer_tunnel_id = nla_get_u32(attrs[L2TP_ATTR_PEER_CONN_ID]);
 
-	if (!info->attrs[L2TP_ATTR_PROTO_VERSION]) {
+	if (!attrs[L2TP_ATTR_PROTO_VERSION]) {
 		ret = -EINVAL;
 		goto out;
 	}
-	proto_version = nla_get_u8(info->attrs[L2TP_ATTR_PROTO_VERSION]);
+	proto_version = nla_get_u8(attrs[L2TP_ATTR_PROTO_VERSION]);
 
-	if (!info->attrs[L2TP_ATTR_ENCAP_TYPE]) {
+	if (!attrs[L2TP_ATTR_ENCAP_TYPE]) {
 		ret = -EINVAL;
 		goto out;
 	}
-	cfg.encap = nla_get_u16(info->attrs[L2TP_ATTR_ENCAP_TYPE]);
+	cfg.encap = nla_get_u16(attrs[L2TP_ATTR_ENCAP_TYPE]);
 
 	fd = -1;
-	if (info->attrs[L2TP_ATTR_FD]) {
-		fd = nla_get_u32(info->attrs[L2TP_ATTR_FD]);
+	if (attrs[L2TP_ATTR_FD]) {
+		fd = nla_get_u32(attrs[L2TP_ATTR_FD]);
 	} else {
 #if IS_ENABLED(CONFIG_IPV6)
-		if (info->attrs[L2TP_ATTR_IP6_SADDR] &&
-		    info->attrs[L2TP_ATTR_IP6_DADDR]) {
-			cfg.local_ip6 = nla_data(
-				info->attrs[L2TP_ATTR_IP6_SADDR]);
-			cfg.peer_ip6 = nla_data(
-				info->attrs[L2TP_ATTR_IP6_DADDR]);
+		if (attrs[L2TP_ATTR_IP6_SADDR] && attrs[L2TP_ATTR_IP6_DADDR]) {
+			cfg.local_ip6 = nla_data(attrs[L2TP_ATTR_IP6_SADDR]);
+			cfg.peer_ip6 = nla_data(attrs[L2TP_ATTR_IP6_DADDR]);
 		} else
 #endif
-		if (info->attrs[L2TP_ATTR_IP_SADDR] &&
-		    info->attrs[L2TP_ATTR_IP_DADDR]) {
-			cfg.local_ip.s_addr = nla_get_in_addr(
-				info->attrs[L2TP_ATTR_IP_SADDR]);
-			cfg.peer_ip.s_addr = nla_get_in_addr(
-				info->attrs[L2TP_ATTR_IP_DADDR]);
+		if (attrs[L2TP_ATTR_IP_SADDR] && attrs[L2TP_ATTR_IP_DADDR]) {
+			cfg.local_ip.s_addr = nla_get_in_addr(attrs[L2TP_ATTR_IP_SADDR]);
+			cfg.peer_ip.s_addr = nla_get_in_addr(attrs[L2TP_ATTR_IP_DADDR]);
 		} else {
 			ret = -EINVAL;
 			goto out;
 		}
-		if (info->attrs[L2TP_ATTR_UDP_SPORT])
-			cfg.local_udp_port = nla_get_u16(info->attrs[L2TP_ATTR_UDP_SPORT]);
-		if (info->attrs[L2TP_ATTR_UDP_DPORT])
-			cfg.peer_udp_port = nla_get_u16(info->attrs[L2TP_ATTR_UDP_DPORT]);
-		cfg.use_udp_checksums = nla_get_flag(
-			info->attrs[L2TP_ATTR_UDP_CSUM]);
+		if (attrs[L2TP_ATTR_UDP_SPORT])
+			cfg.local_udp_port = nla_get_u16(attrs[L2TP_ATTR_UDP_SPORT]);
+		if (attrs[L2TP_ATTR_UDP_DPORT])
+			cfg.peer_udp_port = nla_get_u16(attrs[L2TP_ATTR_UDP_DPORT]);
+		cfg.use_udp_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_CSUM]);
 
 #if IS_ENABLED(CONFIG_IPV6)
-		cfg.udp6_zero_tx_checksums = nla_get_flag(
-			info->attrs[L2TP_ATTR_UDP_ZERO_CSUM6_TX]);
-		cfg.udp6_zero_rx_checksums = nla_get_flag(
-			info->attrs[L2TP_ATTR_UDP_ZERO_CSUM6_RX]);
+		cfg.udp6_zero_tx_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_ZERO_CSUM6_TX]);
+		cfg.udp6_zero_rx_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_ZERO_CSUM6_RX]);
 #endif
 	}
 
-	if (info->attrs[L2TP_ATTR_DEBUG])
-		cfg.debug = nla_get_u32(info->attrs[L2TP_ATTR_DEBUG]);
+	if (attrs[L2TP_ATTR_DEBUG])
+		cfg.debug = nla_get_u32(attrs[L2TP_ATTR_DEBUG]);
 
 	ret = -EINVAL;
 	switch (cfg.encap) {
@@ -715,8 +707,7 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 	if (nla_put_u32(skb, L2TP_ATTR_CONN_ID, tunnel->tunnel_id) ||
 	    nla_put_u32(skb, L2TP_ATTR_SESSION_ID, session->session_id) ||
 	    nla_put_u32(skb, L2TP_ATTR_PEER_CONN_ID, tunnel->peer_tunnel_id) ||
-	    nla_put_u32(skb, L2TP_ATTR_PEER_SESSION_ID,
-			session->peer_session_id) ||
+	    nla_put_u32(skb, L2TP_ATTR_PEER_SESSION_ID, session->peer_session_id) ||
 	    nla_put_u32(skb, L2TP_ATTR_DEBUG, session->debug) ||
 	    nla_put_u16(skb, L2TP_ATTR_PW_TYPE, session->pwtype))
 		goto nla_put_failure;
@@ -724,11 +715,9 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 	if ((session->ifname[0] &&
 	     nla_put_string(skb, L2TP_ATTR_IFNAME, session->ifname)) ||
 	    (session->cookie_len &&
-	     nla_put(skb, L2TP_ATTR_COOKIE, session->cookie_len,
-		     &session->cookie[0])) ||
+	     nla_put(skb, L2TP_ATTR_COOKIE, session->cookie_len, session->cookie)) ||
 	    (session->peer_cookie_len &&
-	     nla_put(skb, L2TP_ATTR_PEER_COOKIE, session->peer_cookie_len,
-		     &session->peer_cookie[0])) ||
+	     nla_put(skb, L2TP_ATTR_PEER_COOKIE, session->peer_cookie_len, session->peer_cookie)) ||
 	    nla_put_u8(skb, L2TP_ATTR_RECV_SEQ, session->recv_seq) ||
 	    nla_put_u8(skb, L2TP_ATTR_SEND_SEQ, session->send_seq) ||
 	    nla_put_u8(skb, L2TP_ATTR_LNS_MODE, session->lns_mode) ||
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 48fbaf5ee82c..3fed922addb5 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1566,8 +1566,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
 		user_data_ok = 'N';
 	}
 
-	seq_printf(m, "  SESSION '%s' %08X/%d %04X/%04X -> "
-		   "%04X/%04X %d %c\n",
+	seq_printf(m, "  SESSION '%s' %08X/%d %04X/%04X -> %04X/%04X %d %c\n",
 		   session->name, ip, port,
 		   tunnel->tunnel_id,
 		   session->session_id,
@@ -1606,8 +1605,7 @@ static int pppol2tp_seq_show(struct seq_file *m, void *v)
 		seq_puts(m, "PPPoL2TP driver info, " PPPOL2TP_DRV_VERSION "\n");
 		seq_puts(m, "TUNNEL name, user-data-ok session-count\n");
 		seq_puts(m, " debug tx-pkts/bytes/errs rx-pkts/bytes/errs\n");
-		seq_puts(m, "  SESSION name, addr/port src-tid/sid "
-			 "dest-tid/sid state user-data-ok\n");
+		seq_puts(m, "  SESSION name, addr/port src-tid/sid dest-tid/sid state user-data-ok\n");
 		seq_puts(m, "   mtu/mru/rcvseq/sendseq/lns debug reorderto\n");
 		seq_puts(m, "   nr/ns tx-pkts/bytes/errs rx-pkts/bytes/errs\n");
 		goto out;
-- 
2.17.1

