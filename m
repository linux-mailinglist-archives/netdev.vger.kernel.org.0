Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5512A1996
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgJaSb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:31:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgJaSb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:31:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYves-004XXt-1P; Sat, 31 Oct 2020 19:31:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Xin Long <lucien.xin@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: ipv6: For kerneldoc warnings with W=1
Date:   Sat, 31 Oct 2020 19:30:44 +0100
Message-Id: <20201031183044.1082193-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

net/ipv6/addrconf.c:2005: warning: Function parameter or member 'dev' not described in 'ipv6_dev_find'
net/ipv6/ip6_vti.c:138: warning: Function parameter or member 'ip6n' not described in 'vti6_tnl_bucket'
net/ipv6/ip6_tunnel.c:218: warning: Function parameter or member 'ip6n' not described in 'ip6_tnl_bucket'
net/ipv6/ip6_tunnel.c:238: warning: Function parameter or member 'ip6n' not described in 'ip6_tnl_link'
net/ipv6/ip6_tunnel.c:254: warning: Function parameter or member 'ip6n' not described in 'ip6_tnl_unlink'
net/ipv6/ip6_tunnel.c:427: warning: Function parameter or member 'raw' not described in 'ip6_tnl_parse_tlv_enc_lim'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'skb' not described in 'ip6_tnl_err'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'ipproto' not described in 'ip6_tnl_err'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'opt' not described in 'ip6_tnl_err'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'type' not described in 'ip6_tnl_err'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'code' not described in 'ip6_tnl_err'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'msg' not described in 'ip6_tnl_err'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'info' not described in 'ip6_tnl_err'
net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'offset' not described in 'ip6_tnl_err'

ip6_tnl_err() is an internal function, so remove the kerneldoc. For
the others, add the missing parameters.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ipv6/addrconf.c   |  1 +
 net/ipv6/ip6_tunnel.c | 15 +++++++--------
 net/ipv6/ip6_vti.c    |  1 +
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 01146b66d666..4211e960130c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1997,6 +1997,7 @@ EXPORT_SYMBOL(ipv6_chk_prefix);
  * ipv6_dev_find - find the first device with a given source address.
  * @net: the net namespace
  * @addr: the source address
+ * @dev: used to find the L3 domain of interest
  *
  * The caller should be protected by RCU, or RTNL.
  */
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a0217e5bf3bc..e3e7859e2ef7 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -204,6 +204,7 @@ ip6_tnl_lookup(struct net *net, int link,
 
 /**
  * ip6_tnl_bucket - get head of list matching given tunnel parameters
+ *   @ip6n: the private data for ip6_vti in the netns
  *   @p: parameters containing tunnel end-points
  *
  * Description:
@@ -230,6 +231,7 @@ ip6_tnl_bucket(struct ip6_tnl_net *ip6n, const struct __ip6_tnl_parm *p)
 
 /**
  * ip6_tnl_link - add tunnel to hash table
+ *   @ip6n: the private data for ip6_vti in the netns
  *   @t: tunnel to be added
  **/
 
@@ -246,6 +248,7 @@ ip6_tnl_link(struct ip6_tnl_net *ip6n, struct ip6_tnl *t)
 
 /**
  * ip6_tnl_unlink - remove tunnel from hash table
+ *   @ip6n: the private data for ip6_vti in the netns
  *   @t: tunnel to be removed
  **/
 
@@ -417,6 +420,7 @@ ip6_tnl_dev_uninit(struct net_device *dev)
 /**
  * parse_tvl_tnl_enc_lim - handle encapsulation limit option
  *   @skb: received socket buffer
+ *   @raw: the ICMPv6 error message data
  *
  * Return:
  *   0 if none was found,
@@ -485,14 +489,9 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 }
 EXPORT_SYMBOL(ip6_tnl_parse_tlv_enc_lim);
 
-/**
- * ip6_tnl_err - tunnel error handler
- *
- * Description:
- *   ip6_tnl_err() should handle errors in the tunnel according
- *   to the specifications in RFC 2473.
- **/
-
+/* ip6_tnl_err() should handle errors in the tunnel according to the
+ * specifications in RFC 2473.
+ */
 static int
 ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 	    u8 *type, u8 *code, int *msg, __u32 *info, int offset)
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 5f9c4fdc120d..46d137a693ac 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -125,6 +125,7 @@ vti6_tnl_lookup(struct net *net, const struct in6_addr *remote,
 
 /**
  * vti6_tnl_bucket - get head of list matching given tunnel parameters
+ *   @ip6n: the private data for ip6_vti in the netns
  *   @p: parameters containing tunnel end-points
  *
  * Description:
-- 
2.28.0

