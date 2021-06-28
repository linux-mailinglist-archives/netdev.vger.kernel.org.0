Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C22E3B58AF
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhF1Fr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:47:57 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40900 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhF1Fr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:56 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 3769A800053;
        Mon, 28 Jun 2021 07:45:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:45:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:45:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7BA3C318031F; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 04/17] xfrm: remove description from xfrm_type struct
Date:   Mon, 28 Jun 2021 07:45:09 +0200
Message-ID: <20210628054522.1718786-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its set but never read. Reduces size of xfrm_type to 64 bytes on 64bit.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      | 2 --
 net/ipv4/ah4.c          | 1 -
 net/ipv4/esp4.c         | 1 -
 net/ipv4/esp4_offload.c | 1 -
 net/ipv4/ipcomp.c       | 1 -
 net/ipv4/xfrm4_tunnel.c | 1 -
 net/ipv6/ah6.c          | 1 -
 net/ipv6/esp6.c         | 1 -
 net/ipv6/esp6_offload.c | 1 -
 net/ipv6/ipcomp6.c      | 1 -
 net/ipv6/mip6.c         | 2 --
 net/ipv6/xfrm6_tunnel.c | 1 -
 12 files changed, 14 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6e11db6fa0ab..1aad78c5f2d5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -388,7 +388,6 @@ void xfrm_flush_gc(void);
 void xfrm_state_delete_tunnel(struct xfrm_state *x);
 
 struct xfrm_type {
-	char			*description;
 	struct module		*owner;
 	u8			proto;
 	u8			flags;
@@ -410,7 +409,6 @@ int xfrm_register_type(const struct xfrm_type *type, unsigned short family);
 void xfrm_unregister_type(const struct xfrm_type *type, unsigned short family);
 
 struct xfrm_type_offload {
-	char		*description;
 	struct module	*owner;
 	u8		proto;
 	void		(*encap)(struct xfrm_state *, struct sk_buff *pskb);
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 36ed85bf2ad5..2d2d08aa787d 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -554,7 +554,6 @@ static int ah4_rcv_cb(struct sk_buff *skb, int err)
 
 static const struct xfrm_type ah_type =
 {
-	.description	= "AH4",
 	.owner		= THIS_MODULE,
 	.proto	     	= IPPROTO_AH,
 	.flags		= XFRM_TYPE_REPLAY_PROT,
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 35803ab7ac80..f5362b9d75eb 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1198,7 +1198,6 @@ static int esp4_rcv_cb(struct sk_buff *skb, int err)
 
 static const struct xfrm_type esp_type =
 {
-	.description	= "ESP4",
 	.owner		= THIS_MODULE,
 	.proto	     	= IPPROTO_ESP,
 	.flags		= XFRM_TYPE_REPLAY_PROT,
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index be019a1fe3af..8e4e9aa12130 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -342,7 +342,6 @@ static const struct net_offload esp4_offload = {
 };
 
 static const struct xfrm_type_offload esp_type_offload = {
-	.description	= "ESP4 OFFLOAD",
 	.owner		= THIS_MODULE,
 	.proto	     	= IPPROTO_ESP,
 	.input_tail	= esp_input_tail,
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index b42683212c65..2e69e81e1f5d 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -152,7 +152,6 @@ static int ipcomp4_rcv_cb(struct sk_buff *skb, int err)
 }
 
 static const struct xfrm_type ipcomp_type = {
-	.description	= "IPCOMP4",
 	.owner		= THIS_MODULE,
 	.proto	     	= IPPROTO_COMP,
 	.init_state	= ipcomp4_init_state,
diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index fb0648e7fb32..f4555a88f86b 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -42,7 +42,6 @@ static void ipip_destroy(struct xfrm_state *x)
 }
 
 static const struct xfrm_type ipip_type = {
-	.description	= "IPIP",
 	.owner		= THIS_MODULE,
 	.proto	     	= IPPROTO_IPIP,
 	.init_state	= ipip_init_state,
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 20d492da725a..e9705c256068 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -755,7 +755,6 @@ static int ah6_rcv_cb(struct sk_buff *skb, int err)
 }
 
 static const struct xfrm_type ah6_type = {
-	.description	= "AH6",
 	.owner		= THIS_MODULE,
 	.proto		= IPPROTO_AH,
 	.flags		= XFRM_TYPE_REPLAY_PROT,
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 393ae2b78e7d..be2c0ac76eaa 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -1243,7 +1243,6 @@ static int esp6_rcv_cb(struct sk_buff *skb, int err)
 }
 
 static const struct xfrm_type esp6_type = {
-	.description	= "ESP6",
 	.owner		= THIS_MODULE,
 	.proto		= IPPROTO_ESP,
 	.flags		= XFRM_TYPE_REPLAY_PROT,
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 40ed4fcf1cf4..a349d4798077 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -377,7 +377,6 @@ static const struct net_offload esp6_offload = {
 };
 
 static const struct xfrm_type_offload esp6_type_offload = {
-	.description	= "ESP6 OFFLOAD",
 	.owner		= THIS_MODULE,
 	.proto	     	= IPPROTO_ESP,
 	.input_tail	= esp6_input_tail,
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index daef890460b7..491aba66b7ae 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -172,7 +172,6 @@ static int ipcomp6_rcv_cb(struct sk_buff *skb, int err)
 }
 
 static const struct xfrm_type ipcomp6_type = {
-	.description	= "IPCOMP6",
 	.owner		= THIS_MODULE,
 	.proto		= IPPROTO_COMP,
 	.init_state	= ipcomp6_init_state,
diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 878fcec14949..bc560e1664aa 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -324,7 +324,6 @@ static void mip6_destopt_destroy(struct xfrm_state *x)
 }
 
 static const struct xfrm_type mip6_destopt_type = {
-	.description	= "MIP6DESTOPT",
 	.owner		= THIS_MODULE,
 	.proto		= IPPROTO_DSTOPTS,
 	.flags		= XFRM_TYPE_NON_FRAGMENT | XFRM_TYPE_LOCAL_COADDR,
@@ -456,7 +455,6 @@ static void mip6_rthdr_destroy(struct xfrm_state *x)
 }
 
 static const struct xfrm_type mip6_rthdr_type = {
-	.description	= "MIP6RT",
 	.owner		= THIS_MODULE,
 	.proto		= IPPROTO_ROUTING,
 	.flags		= XFRM_TYPE_NON_FRAGMENT | XFRM_TYPE_REMOTE_COADDR,
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index f696d46e6910..2b31112c0856 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -291,7 +291,6 @@ static void xfrm6_tunnel_destroy(struct xfrm_state *x)
 }
 
 static const struct xfrm_type xfrm6_tunnel_type = {
-	.description	= "IP6IP6",
 	.owner          = THIS_MODULE,
 	.proto		= IPPROTO_IPV6,
 	.init_state	= xfrm6_tunnel_init_state,
-- 
2.25.1

