Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBCE11605D
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfLHEmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:42:37 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33633 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLHEmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:42:37 -0500
Received: by mail-pf1-f196.google.com with SMTP id y206so5480087pfb.0;
        Sat, 07 Dec 2019 20:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=LUnoWiG9+9pi0qPuK3fsT14g6l0jI+6UruxBIhkvNW0=;
        b=ZoMFG10EkAjW1bY8R4kiwymuP6EftHXU8FHtsrTBj69+bZO1XPvD5dFpOoIssNrMLQ
         IcEqciO8b8Nqs6nicvxz4nbDgFMY993fcGRyasICppdiNCmNaFBlGvOX/sjlS/jd4Sai
         /KAD0851aLyacizKl+O7T5Qiyul39NSS2XTkkHfWLyAoflCG+kpx4iNXsqrs4K4P4mS1
         kVohCH/p9uDgpJmeIsZdYd56zj2g7cb+b5WbKWSJOKexKxj8Wpu6DW8WTn3Fg4+In8tS
         7k/neGxrRCGLeUEFAg6rnV2HjKtbgwUj5DBoWZFSMGpjdSVijzi1FrduqwyF3jzkizrN
         NXdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=LUnoWiG9+9pi0qPuK3fsT14g6l0jI+6UruxBIhkvNW0=;
        b=PYLvsfJviUKPTxyCdi916qacEpUYkQuPFM3WV54TnbYcX7NKBqo7YSajVn19gtOX97
         pLu5LSG90JYytQ2dlYTC+XTRXhIxp3kLrwbBBtOufpcME66pIeldTwy9O4BLblYhtXgG
         /VHtCNuXc+tP3WDkoyN+VGXc/DGEFaMUjJexz2m/qkJFiMgo1Hrdu1uVbCSRG+b/4Pyg
         HV8BgBg+go25TDQavAFJYHxfCbPxeyZ/i6PCK2MzZKBvn03eZ7ea4rfS9HAJbcxtKrsX
         X04an68qJvHv81mYzLFl/PXywSpAB5CgpqMfo5nL+Fieq+cftua/YEETelEOivkaKv0P
         EwTw==
X-Gm-Message-State: APjAAAXwp88MG9usFNXzKFRLwnzkhN+9QiB/7EwErNVYho3nl2t+OfsK
        y01VvpX/6wH8JcC/tZBrlFlEwI0e
X-Google-Smtp-Source: APXvYqwCEWpvIB1vuhiidcbEY0yd5qtQp6qGjrpey9ozsDC3QaYxqZ+fVRxtZFH0gmXvQ5KEjoJJ/Q==
X-Received: by 2002:a62:ea19:: with SMTP id t25mr23209091pfh.74.1575780156248;
        Sat, 07 Dec 2019 20:42:36 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g30sm20031122pgm.23.2019.12.07.20.42.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:42:35 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 6/7] netfilter: nft_tunnel: add the missing nla_nest_cancel()
Date:   Sun,  8 Dec 2019 12:41:36 +0800
Message-Id: <40a34ac68b79886f755ec076cbf787ecf7fdc014.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <396287a2b2d8797dae70c5740084c4d0cb225a08.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
 <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
 <e64595c27468e392826f0afb5f18b68ce258787a.1575779993.git.lucien.xin@gmail.com>
 <396287a2b2d8797dae70c5740084c4d0cb225a08.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nla_put_xxx() fails under nla_nest_start_noflag(),
nla_nest_cancel() should be called, so that the skb can
be trimmed properly.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nft_tunnel.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index e9b94b8..32263dc 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -443,10 +443,15 @@ static int nft_tunnel_ip_dump(struct sk_buff *skb, struct ip_tunnel_info *info)
 		if (!nest)
 			return -1;
 
-		if (nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_SRC, &info->key.u.ipv6.src) < 0 ||
-		    nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_DST, &info->key.u.ipv6.dst) < 0 ||
-		    nla_put_be32(skb, NFTA_TUNNEL_KEY_IP6_FLOWLABEL, info->key.label))
+		if (nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_SRC,
+				     &info->key.u.ipv6.src) < 0 ||
+		    nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_DST,
+				     &info->key.u.ipv6.dst) < 0 ||
+		    nla_put_be32(skb, NFTA_TUNNEL_KEY_IP6_FLOWLABEL,
+				 info->key.label)) {
+			nla_nest_cancel(skb, nest);
 			return -1;
+		}
 
 		nla_nest_end(skb, nest);
 	} else {
@@ -454,9 +459,13 @@ static int nft_tunnel_ip_dump(struct sk_buff *skb, struct ip_tunnel_info *info)
 		if (!nest)
 			return -1;
 
-		if (nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_SRC, info->key.u.ipv4.src) < 0 ||
-		    nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_DST, info->key.u.ipv4.dst) < 0)
+		if (nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_SRC,
+				    info->key.u.ipv4.src) < 0 ||
+		    nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_DST,
+				    info->key.u.ipv4.dst) < 0) {
+			nla_nest_cancel(skb, nest);
 			return -1;
+		}
 
 		nla_nest_end(skb, nest);
 	}
@@ -477,37 +486,42 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 	if (opts->flags & TUNNEL_VXLAN_OPT) {
 		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_VXLAN);
 		if (!inner)
-			return -1;
+			goto failure;
 		if (nla_put_u32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
 				opts->u.vxlan.gbp))
-			return -1;
+			goto inner_failure;
 		nla_nest_end(skb, inner);
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
 		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
 		if (!inner)
-			return -1;
+			goto failure;
 		if (nla_put_u8(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
 			       opts->u.erspan.version))
-			return -1;
+			goto inner_failure;
 		switch (opts->u.erspan.version) {
 		case ERSPAN_VERSION:
 			if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
 					 opts->u.erspan.u.index))
-				return -1;
+				goto inner_failure;
 			break;
 		case ERSPAN_VERSION2:
 			if (nla_put_u8(skb, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
 				       get_hwid(&opts->u.erspan.u.md2)) ||
 			    nla_put_u8(skb, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
 				       opts->u.erspan.u.md2.dir))
-				return -1;
+				goto inner_failure;
 			break;
 		}
 		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
-
 	return 0;
+
+inner_failure:
+	nla_nest_cancel(skb, inner);
+failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
 }
 
 static int nft_tunnel_ports_dump(struct sk_buff *skb,
-- 
2.1.0

