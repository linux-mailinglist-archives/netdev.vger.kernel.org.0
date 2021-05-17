Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55832382BFF
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 14:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhEQMXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 08:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbhEQMXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 08:23:44 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE6FC061573;
        Mon, 17 May 2021 05:22:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so3595154pjb.4;
        Mon, 17 May 2021 05:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pmtOpzqls0v/g8o8UmNm35xKnZImhknJV+CPfOBnR2I=;
        b=ZSWDGwnAxGrYQr6RXUC+qdahlBpjYA7g/2VB/7Fk1AkXx6J5OVoJFGLyW9mTzLCl8U
         86E+m8ChsCyJkvPyJc/C+/Vzc2vh1zMnMRHVGseOupql/aB8ZWSYT7i9CK1KkyGYZ9+E
         saUhBUVgl+3M8iKLZ2T2cwFS/FL3pDKW8lLEcASZ2YeJ3mIncURhY1cOJJ5ejgGGqW1t
         S4Tf7IvlDpwBSPSoCidLlMMIO68tK6Nx44uoE8UI9tx9yNt55p6it6CfypRrNhObDsdz
         w5dkmFvVUUXpYatVK15wp+nBLdhdRMSZhO+Og/vnC3kWcMQlgneK5Btmc7mIQOHqsFEm
         Gh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pmtOpzqls0v/g8o8UmNm35xKnZImhknJV+CPfOBnR2I=;
        b=QaHXgFfI8HXcGEX9koRKogJEK1yC3HQtIJ+KpFNFOGnPhx9Btul9ly1/F1UeKD/ZvK
         d92+BmP508MjDDRtLv87nvc9czYl+tAWSSpQMrM97zy/T1ocUpRYXkJ6YXEdbKryDpa9
         MEjL8LjDa2uUdCoNubPdqf9sRb6Ujv8xeoDW2xIcmKwjkD7PmyDr5uwgyjE80jAkSChv
         mfJ88gWRcy/5n+qLpKi3jVpuyM8qomBetPemwSgHQOR+aOBgl4QGDEhsJRKcMDSt91Ue
         09iK6K/OgKcP9S+Ru/2duyMjBzrf50KUY6KUA4kXH1n+nWyuew/5mgts9QOwNkf0Jj6l
         YqKg==
X-Gm-Message-State: AOAM533ysFwqJp/g9Z9LIzRVSVPCjjS+g48FWvsosK0LDyWMHlUxybf3
        SKE82L1gs4K+f36NmaRbwO4=
X-Google-Smtp-Source: ABdhPJyY5B0QcOE1jsXz7him0KPOunpY/NeoUHNK0q33VZMgEdlMR4/O6K2+jGqiQrJFZ0wUbJmunw==
X-Received: by 2002:a17:90a:aa0b:: with SMTP id k11mr26433295pjq.153.1621254147878;
        Mon, 17 May 2021 05:22:27 -0700 (PDT)
Received: from sz-dl-056.autox.sz ([45.67.53.159])
        by smtp.gmail.com with ESMTPSA id x13sm10854990pjl.22.2021.05.17.05.22.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 05:22:27 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
X-Google-Original-From: Yejune Deng <yejunedeng@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, xeb@mail.ru, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, vyasevich@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        edumazet@google.com, yejunedeng@gmail.com, weiwan@google.com,
        paul@paul-moore.com, rdunlap@infradead.org, rdias@singlestore.com,
        fw@strlen.de, andrew@lunn.ch, tparkin@katalix.com,
        stefan@datenfreihafen.org, matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dccp@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: [PATCH] net: Remove the member netns_ok
Date:   Mon, 17 May 2021 20:22:05 +0800
Message-Id: <1621254125-21588-1-git-send-email-yejunedeng@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every protocol has the 'netns_ok' member and it is euqal to 1. The
'if (!prot->netns_ok)' always false in inet_add_protocol().

Signed-off-by: Yejune Deng <yejunedeng@gmail.com>
---
 include/net/protocol.h    | 1 -
 net/dccp/ipv4.c           | 1 -
 net/ipv4/af_inet.c        | 4 ----
 net/ipv4/gre_demux.c      | 1 -
 net/ipv4/ipmr.c           | 1 -
 net/ipv4/protocol.c       | 6 ------
 net/ipv4/tunnel4.c        | 3 ---
 net/ipv4/udplite.c        | 1 -
 net/ipv4/xfrm4_protocol.c | 3 ---
 net/l2tp/l2tp_ip.c        | 1 -
 net/sctp/protocol.c       | 1 -
 11 files changed, 23 deletions(-)

diff --git a/include/net/protocol.h b/include/net/protocol.h
index 2b778e1..f51c06a 100644
--- a/include/net/protocol.h
+++ b/include/net/protocol.h
@@ -43,7 +43,6 @@ struct net_protocol {
 	int			(*err_handler)(struct sk_buff *skb, u32 info);
 
 	unsigned int		no_policy:1,
-				netns_ok:1,
 				/* does the protocol do more stringent
 				 * icmp tag validation than simple
 				 * socket lookup?
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index ffc601a..f81c1df 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -977,7 +977,6 @@ static const struct net_protocol dccp_v4_protocol = {
 	.handler	= dccp_v4_rcv,
 	.err_handler	= dccp_v4_err,
 	.no_policy	= 1,
-	.netns_ok	= 1,
 	.icmp_strict_tag_validation = 1,
 };
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f17870e..d9bccad6 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1720,7 +1720,6 @@ EXPORT_SYMBOL_GPL(snmp_fold_field64);
 #ifdef CONFIG_IP_MULTICAST
 static const struct net_protocol igmp_protocol = {
 	.handler =	igmp_rcv,
-	.netns_ok =	1,
 };
 #endif
 
@@ -1733,7 +1732,6 @@ static struct net_protocol tcp_protocol = {
 	.handler	=	tcp_v4_rcv,
 	.err_handler	=	tcp_v4_err,
 	.no_policy	=	1,
-	.netns_ok	=	1,
 	.icmp_strict_tag_validation = 1,
 };
 
@@ -1746,14 +1744,12 @@ static struct net_protocol udp_protocol = {
 	.handler =	udp_rcv,
 	.err_handler =	udp_err,
 	.no_policy =	1,
-	.netns_ok =	1,
 };
 
 static const struct net_protocol icmp_protocol = {
 	.handler =	icmp_rcv,
 	.err_handler =	icmp_err,
 	.no_policy =	1,
-	.netns_ok =	1,
 };
 
 static __net_init int ipv4_mib_init_net(struct net *net)
diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index 5d1e6fe..cbb2b4b 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -195,7 +195,6 @@ static int gre_err(struct sk_buff *skb, u32 info)
 static const struct net_protocol net_gre_protocol = {
 	.handler     = gre_rcv,
 	.err_handler = gre_err,
-	.netns_ok    = 1,
 };
 
 static int __init gre_init(void)
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 939792a..12b564b 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -3007,7 +3007,6 @@ static const struct seq_operations ipmr_mfc_seq_ops = {
 #ifdef CONFIG_IP_PIMSM_V2
 static const struct net_protocol pim_protocol = {
 	.handler	=	pim_rcv,
-	.netns_ok	=	1,
 };
 #endif
 
diff --git a/net/ipv4/protocol.c b/net/ipv4/protocol.c
index 9a8c089..6913979 100644
--- a/net/ipv4/protocol.c
+++ b/net/ipv4/protocol.c
@@ -31,12 +31,6 @@ EXPORT_SYMBOL(inet_offloads);
 
 int inet_add_protocol(const struct net_protocol *prot, unsigned char protocol)
 {
-	if (!prot->netns_ok) {
-		pr_err("Protocol %u is not namespace aware, cannot register.\n",
-			protocol);
-		return -EINVAL;
-	}
-
 	return !cmpxchg((const struct net_protocol **)&inet_protos[protocol],
 			NULL, prot) ? 0 : -1;
 }
diff --git a/net/ipv4/tunnel4.c b/net/ipv4/tunnel4.c
index e44aaf4..5048c47 100644
--- a/net/ipv4/tunnel4.c
+++ b/net/ipv4/tunnel4.c
@@ -218,7 +218,6 @@ static const struct net_protocol tunnel4_protocol = {
 	.handler	=	tunnel4_rcv,
 	.err_handler	=	tunnel4_err,
 	.no_policy	=	1,
-	.netns_ok	=	1,
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -226,7 +225,6 @@ static const struct net_protocol tunnel64_protocol = {
 	.handler	=	tunnel64_rcv,
 	.err_handler	=	tunnel64_err,
 	.no_policy	=	1,
-	.netns_ok	=	1,
 };
 #endif
 
@@ -235,7 +233,6 @@ static const struct net_protocol tunnelmpls4_protocol = {
 	.handler	=	tunnelmpls4_rcv,
 	.err_handler	=	tunnelmpls4_err,
 	.no_policy	=	1,
-	.netns_ok	=	1,
 };
 #endif
 
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index bd8773b..cd1cd68 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -31,7 +31,6 @@ static const struct net_protocol udplite_protocol = {
 	.handler	= udplite_rcv,
 	.err_handler	= udplite_err,
 	.no_policy	= 1,
-	.netns_ok	= 1,
 };
 
 struct proto 	udplite_prot = {
diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index ea595c8..2fe5860 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -181,21 +181,18 @@ static const struct net_protocol esp4_protocol = {
 	.handler	=	xfrm4_esp_rcv,
 	.err_handler	=	xfrm4_esp_err,
 	.no_policy	=	1,
-	.netns_ok	=	1,
 };
 
 static const struct net_protocol ah4_protocol = {
 	.handler	=	xfrm4_ah_rcv,
 	.err_handler	=	xfrm4_ah_err,
 	.no_policy	=	1,
-	.netns_ok	=	1,
 };
 
 static const struct net_protocol ipcomp4_protocol = {
 	.handler	=	xfrm4_ipcomp_rcv,
 	.err_handler	=	xfrm4_ipcomp_err,
 	.no_policy	=	1,
-	.netns_ok	=	1,
 };
 
 static const struct xfrm_input_afinfo xfrm4_input_afinfo = {
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 97ae125..536c30d 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -635,7 +635,6 @@ static struct inet_protosw l2tp_ip_protosw = {
 
 static struct net_protocol l2tp_ip_protocol __read_mostly = {
 	.handler	= l2tp_ip_recv,
-	.netns_ok	= 1,
 };
 
 static int __init l2tp_ip_init(void)
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6f2bbfe..baa4e77 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1171,7 +1171,6 @@ static const struct net_protocol sctp_protocol = {
 	.handler     = sctp4_rcv,
 	.err_handler = sctp_v4_err,
 	.no_policy   = 1,
-	.netns_ok    = 1,
 	.icmp_strict_tag_validation = 1,
 };
 
-- 
2.7.4

