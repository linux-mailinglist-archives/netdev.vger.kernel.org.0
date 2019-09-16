Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD67B3539
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfIPHLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:11:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38987 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730589AbfIPHLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:11:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so19270704pgi.6
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=vOTVZiVA0MsWYy/u8OeGK0VZSvuDAWIa5BlSv0Zw4cc=;
        b=u71rg5+fBTy0mf1BQgiV9V6fTVvS+D9IW4oFC/RFWgRPXkVnqD8/s04LDVc+LQyhAU
         efRPYh3SY3qOfVhCgq1Pqbub4OjT/xOI8rn3p00fbB9gkF38+W8W1SZkW/fCBpVaKf1s
         wFIqHF8md/1Ih2OoVCJjdMh1V+XeEf7lGc3AEb5s1N9KJwaVzYZOxi2FrK9mHK8ng92+
         RnypkS3yIAciu+fgMpzPUzyRDxtjN8SlsY+BoefWt4o8LU3cLyFbWA30tLzjOUpNJJc4
         j37I2VZJ9qrrGdCUObRDaY397hWq/qKcm1ySUKiTQuxli9YWcTt++K76QGu8BcpbqDgG
         uM9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=vOTVZiVA0MsWYy/u8OeGK0VZSvuDAWIa5BlSv0Zw4cc=;
        b=VRX0jSl8+sA2pBqRPd4JJ3sUgnMig8yIDy96yzBXFMkSWj9A29CoEPVa1cGHhRqge2
         E/XlxWPC7vymEbWoJbmzFBh1gMaa2mUiFsIT90BWoupInBXbtAqxunsxnS04qRnVWdEN
         YgWI7sRI0ENtL7GqtJUJpRQ/t/JP0J0ToUtDBQHDA6OJkNiUI1TIL5oG9WrhD0aGqdnX
         uCSjotoPgepQNnTTjhKNY/meIx7ZNBzQIY3CHp3GDE9s2nlhNsltkPrMIbvVN5j6tB9P
         8xu8rAR6gl3i2GCYnxF95mJ/pOYPPsFWt6mE0XsIoDKBISh9kuXbHON0E/Vch/gDmRSK
         i0qA==
X-Gm-Message-State: APjAAAUor2S1ri9OZE2gBJhfB1VGmAB53P5Ko/pwh2typjI+9RRwwHbH
        honLYYWy2rKBe46+N5s5Hppp3poSUyM=
X-Google-Smtp-Source: APXvYqw8N4BJ6iKwP1UejEKWJiIGBPMGEaiAHycbo54Q0Ohxx+wlkv/CxK1Fvfe4DbJPhR7ryaReYw==
X-Received: by 2002:a63:7c0d:: with SMTP id x13mr54453003pgc.360.1568617878707;
        Mon, 16 Sep 2019 00:11:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id dw19sm3152962pjb.27.2019.09.16.00.11.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:11:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCH net-next 6/6] erspan: make md work without TUNNEL_ERSPAN_OPT set
Date:   Mon, 16 Sep 2019 15:10:20 +0800
Message-Id: <90c2f6a1008b6a9e86bd7f427e28aedec902d552.1568617721.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <df4d06219243295fba75ab6361f0d750a135b7cc.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
 <ec8435ca550a364b793bd8f307d6c2751931e684.1568617721.git.lucien.xin@gmail.com>
 <c8ce746cdbfe59ef332997e1ad87e88af49aac5b.1568617721.git.lucien.xin@gmail.com>
 <25b60ddb9a54413e20d5a55e9e03454c82e4561d.1568617721.git.lucien.xin@gmail.com>
 <7d552d01b82edf9523288030dc03f467aee92912.1568617721.git.lucien.xin@gmail.com>
 <df4d06219243295fba75ab6361f0d750a135b7cc.1568617721.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
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
index df7149c..ac4cbb8 100644
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
index 4aba9e0..a48cec3 100644
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

