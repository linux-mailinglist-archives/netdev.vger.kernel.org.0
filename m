Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BFACFD69
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfJHPRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:17:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32836 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJHPRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:17:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id i76so3258545pgc.0
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=3iCjK+ymo0xJpIwVNyStioOUP2580aJWaTGnvJ/+BCs=;
        b=PhJCd2ZkcgFkvLGd5frnt0PHgMtkxseCsm9zT4AeLgdP7dAIVOZVY8QYACAVMR+LV1
         bM3SKeU2jllyi9qVyD+T8jnHGwa8cWSirr/k8H8SFDUDiavOUGkqKHdnd0OWd+TA42RB
         9Sb7wQ8yuo0iF2T2b8286uzcBMrCWfMRZDP/mZdEQnH5AqbLanSP/+cvu434vffzlnV3
         HvvUrIF00nWxm/khGQ/awejGkF5WGkEvnrrlOOqGGmw9mgq5LV303wffYnnWPrSJc0mF
         /SCLmihgL2SWiUVUxCRc0pd550jC+mvZEY+GPmaj2zLozTksrMLNV1ab1k5AiRZHRlZA
         PxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=3iCjK+ymo0xJpIwVNyStioOUP2580aJWaTGnvJ/+BCs=;
        b=KneTv93BHPDl0x53e+c+UsrgpQTawOkwiyIJWO6keULjU0rjraPZOQMZksL8uyktTb
         La3TJ0vAbmMS6BPFFNd77cnkoAQBBQ5D08ZOMNe/P2VoQhr4wqEPfuEa66mdmX3e5v54
         ikkpoFGS5gSZLAWARIZGjj3IpFJrcaVoqa/8hQWy80gx58xr7dtOchX1UPlQ5P3WijUj
         G2iD/uEU3vmw1kjykwZY+oiU9lukJN8V7v3+dsrj5WBM68TggM0MHSnwyPTTZTTpYuS+
         C94KlzucQUlrsiihM4v42SsotHKsnYG6lNKXZNunFUjUSF9DbBEIJToC1G0JsDHPF/eV
         8MfA==
X-Gm-Message-State: APjAAAVs6nSBL8Pb48Hb23Iqrxttq5FpQ/svfUurUddAQ2JoXL2TEN/f
        swzTF0P00iKkLjf1fuOHfM1/VRuK
X-Google-Smtp-Source: APXvYqxwN8odZ2DpHXy196DsUhIXZFa3oM7H2Aj3/8n1z9QngxJK52cEYI9gusMf+kZFzqwRk9felQ==
X-Received: by 2002:a63:6c81:: with SMTP id h123mr37279876pgc.132.1570547835121;
        Tue, 08 Oct 2019 08:17:15 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s1sm2775893pjs.31.2019.10.08.08.17.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:17:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCHv2 net-next 6/6] erspan: make md work without TUNNEL_ERSPAN_OPT set
Date:   Tue,  8 Oct 2019 23:16:16 +0800
Message-Id: <84a19a454d49bdc89692f9af4e89b73636f99edd.1570547676.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ad3f4008718a8c90e6c779d30723936934dd85c1.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
 <d29fbb1833cea0e9aff96317b9e49f230ca6d3dc.1570547676.git.lucien.xin@gmail.com>
 <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
 <db1089611398f17980ddfb54568c95837928e5a9.1570547676.git.lucien.xin@gmail.com>
 <b870b739bf2819134a3de9f2a19132d978109e7a.1570547676.git.lucien.xin@gmail.com>
 <ad3f4008718a8c90e6c779d30723936934dd85c1.1570547676.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now when a skb comes with ip_tun_info but with no TUNNEL_ERSPAN_OPT to
a md erspan device, it will be dropped.

This patch is to allow this skb to go through this erspan device, and
the options (version, index, hwid, dir, etc.) will be filled with
tunnel's params, which can be configured by users.

This can be verified by:

 # ip net a a; ip net a b
 # ip -n a l a eth0 type veth peer name eth0 netns b
 # ip -n a l s eth0 up; ip -n b link set eth0 up
 # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
 # ip -n b l a erspan1 type erspan key 1 seq local 10.1.0.2 remote 10.1.0.1
 # ip -n b a a 1.1.1.1/24 dev erspan1; ip -n b l s erspan1 up
 # ip -n b r a 2.1.1.0/24 dev erspan1
 # ip -n a l a erspan1 type erspan key 1 seq local 10.1.0.1 external
 # ip -n a a a 2.1.1.1/24 dev erspan1; ip -n a l s erspan1 up
 # ip -n a r a 1.1.1.0/24 encap ip id 1 dst 10.1.0.2 dev erspan1
 # ip net exec a ping 1.1.1.1 -c 1

Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_gre.c  | 31 +++++++++++++------------------
 net/ipv6/ip6_gre.c | 35 +++++++++++++++++++----------------
 2 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b5e1f5e..84a445d 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -491,15 +491,12 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	struct erspan_metadata *md = NULL;
 	struct ip_tunnel_info *tun_info;
 	const struct ip_tunnel_key *key;
-	struct erspan_metadata *md;
+	int version, nhoff, thoff;
 	bool truncate = false;
 	__be16 proto;
-	int tunnel_hlen;
-	int version;
-	int nhoff;
-	int thoff;
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
@@ -507,15 +504,11 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto err_free_skb;
 
 	key = &tun_info->key;
-	if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
-		goto err_free_skb;
-	if (sizeof(*md) > tun_info->options_len)
-		goto err_free_skb;
-	md = ip_tunnel_info_opts(tun_info);
-
-	/* ERSPAN has fixed 8 byte GRE header */
-	version = md->version;
-	tunnel_hlen = 8 + erspan_hdr_len(version);
+	if (key->tun_flags & TUNNEL_ERSPAN_OPT) {
+		if (tun_info->options_len < sizeof(*md))
+			goto err_free_skb;
+		md = ip_tunnel_info_opts(tun_info);
+	}
 
 	if (skb_cow_head(skb, dev->needed_headroom))
 		goto err_free_skb;
@@ -538,15 +531,17 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	    (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff))
 		truncate = true;
 
+	version = md ? md->version : tunnel->erspan_ver;
 	if (version == 1) {
 		erspan_build_header(skb, ntohl(tunnel_id_to_key32(key->tun_id)),
-				    ntohl(md->u.index), truncate, true);
+				    md ? ntohl(md->u.index) : tunnel->index,
+				    truncate, true);
 		proto = htons(ETH_P_ERSPAN);
 	} else if (version == 2) {
 		erspan_build_header_v2(skb,
 				       ntohl(tunnel_id_to_key32(key->tun_id)),
-				       md->u.md2.dir,
-				       get_hwid(&md->u.md2),
+				       md ? md->u.md2.dir : tunnel->dir,
+				       md ? get_hwid(&md->u.md2) : tunnel->hwid,
 				       truncate, true);
 		proto = htons(ETH_P_ERSPAN2);
 	} else {
@@ -556,7 +551,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	gre_build_header(skb, 8, TUNNEL_SEQ,
 			 proto, 0, htonl(tunnel->o_seqno++));
 
-	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
+	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, 8 + erspan_hdr_len(version));
 
 	return;
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 116987d..3b7d213 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -959,10 +959,11 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	 * for native mode, call prepare_ip6gre_xmit_{ipv4,ipv6}.
 	 */
 	if (t->parms.collect_md) {
+		struct erspan_metadata *md = NULL;
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
-		struct erspan_metadata *md;
 		__be32 tun_id;
+		int version;
 
 		tun_info = skb_tunnel_info(skb);
 		if (unlikely(!tun_info ||
@@ -978,23 +979,25 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
 
 		dsfield = key->tos;
-		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
-			goto tx_err;
-		if (sizeof(*md) > tun_info->options_len)
-			goto tx_err;
-		md = ip_tunnel_info_opts(tun_info);
+		if (key->tun_flags & TUNNEL_ERSPAN_OPT) {
+			if (tun_info->options_len < sizeof(*md))
+				goto tx_err;
+			md = ip_tunnel_info_opts(tun_info);
+		}
 
 		tun_id = tunnel_id_to_key32(key->tun_id);
-		if (md->version == 1) {
-			erspan_build_header(skb,
-					    ntohl(tun_id),
-					    ntohl(md->u.index), truncate,
-					    false);
-		} else if (md->version == 2) {
-			erspan_build_header_v2(skb,
-					       ntohl(tun_id),
-					       md->u.md2.dir,
-					       get_hwid(&md->u.md2),
+		version = md ? md->version : t->parms.erspan_ver;
+		if (version == 1) {
+			erspan_build_header(skb, ntohl(tun_id),
+					    md ? ntohl(md->u.index)
+					       : t->parms.index,
+					    truncate, false);
+		} else if (version == 2) {
+			erspan_build_header_v2(skb, ntohl(tun_id),
+					       md ? md->u.md2.dir
+						  : t->parms.dir,
+					       md ? get_hwid(&md->u.md2)
+						  : t->parms.hwid,
 					       truncate, false);
 		} else {
 			goto tx_err;
-- 
2.1.0

