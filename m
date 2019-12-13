Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65AE511DFFC
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLMIyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:54:01 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36474 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMIyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:54:01 -0500
Received: by mail-pg1-f194.google.com with SMTP id k3so1236330pgc.3;
        Fri, 13 Dec 2019 00:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=r2ccaQDGg0mEXYWHSPEJGMChgOc49ZtQjX6loVbkTLo=;
        b=eSOxZOq4efJmhJuFHOiaeu4LjiDA5bFZYAQn/VZu/M/g5b/TtUgVY0IhPPi0p2R+gV
         dcySoze662Jb1ACGbTyXc1++KwdRBLwEmZGh0H+3ak2rG7h9yXKP44yClRTHoq9+3f/x
         p8th89VWT8LS+/lW37HSGJe49I3Are0mzR49oAz0Rv41N6/fU+kqGTtkUkULbwNZhPbN
         8yc5rH3gonayKy/dvIRGdbrqYxFx2KNhIhft/BnciPTC5HGWhdbqNz/RvHW86M6/AdCG
         UB5KkhGo+I6KdwPzBlZ01AhWrw/JH5KbXtn1Sv9uW5eFgL+uIVsOSrJajZMdhEzAlgaT
         b1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=r2ccaQDGg0mEXYWHSPEJGMChgOc49ZtQjX6loVbkTLo=;
        b=aIjhV8NP8x1ip2U/pHDS+gaakkn460ekg4wF0XdiM2Ej3+HuJytgMqgZr3NJ9mfZGZ
         HJ/vlVYy/HxUakBrU8wv2XGqbo+JZ7kYUoedCa6tNYv4p+mwAJtBGItmjaF+y13DduO+
         Ssq3HXSCRfhS65+9Z7/PEk6zYpo5tWaVNNkGq5U55Okoq81eJ2m4MvnUqIjhTPZ4Df6n
         1JNmy/qzxammBD03J1FSQyw1Jm5StEfLCeHZeFdjH61lsENhPDYkqXl73Pf9ijyyfaZl
         rOZlkeBvofcvnduREgEbwDRZvrhyNOGpzxRgd9cAtxQlor4UntTTdjlq4LM7tZFxdGGI
         R7Eg==
X-Gm-Message-State: APjAAAXXflHreAgbgsXzQMSExy1krIc6XfnL3F4UNRWfxmg/0TKlOsMw
        pL0sZ05q/IhYITMBZD+rnSzLBLuC
X-Google-Smtp-Source: APXvYqwrg8zKyVwhagJwqeWUsZh3zYDKiIAsEWUwKA54gXjsvF5bCLC7ubdQYFNHTCNEidNSAjslOA==
X-Received: by 2002:a63:106:: with SMTP id 6mr15782739pgb.190.1576227240355;
        Fri, 13 Dec 2019 00:54:00 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d2sm8693861pja.1.2019.12.13.00.53.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 00:53:59 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2 nf-next 5/5] netfilter: nft_tunnel: add the missing nla_nest_cancel()
Date:   Fri, 13 Dec 2019 16:53:09 +0800
Message-Id: <eef81a92304174c58faed2403c7b487b00193626.1576226965.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e4812b0aef4aaeee9751fec15f5f34d6f983e134.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <38e59ca61c8582cfc0bf1b90cccc53c4455f8357.1576226965.git.lucien.xin@gmail.com>
 <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
 <46a6912e0996a23b79a6d52eaf9ed501a1dab86b.1576226965.git.lucien.xin@gmail.com>
 <e4812b0aef4aaeee9751fec15f5f34d6f983e134.1576226965.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nla_put_xxx() fails under nla_nest_start_noflag(),
nla_nest_cancel() should be called, so that the skb can
be trimmed properly.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index eb17402..23cd163 100644
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
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
 				 htonl(opts->u.vxlan.gbp)))
-			return -1;
+			goto inner_failure;
 		nla_nest_end(skb, inner);
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
 		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
 		if (!inner)
-			return -1;
+			goto failure;
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
 				 htonl(opts->u.erspan.version)))
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

