Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8612511DFFA
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfLMIxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:53:53 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43928 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMIxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:53:53 -0500
Received: by mail-pl1-f193.google.com with SMTP id p27so953031pli.10;
        Fri, 13 Dec 2019 00:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=lcX08jSnRBdm9LOuHEdK4FTt8D4eBxuCx3/ranZw88E=;
        b=t2q6Vfan5MzkqF+7a5bKTgc9lwVVfITuHfgipeJmuzTzJdgFbTU8De+RRGxvk0hx8q
         bZuNL+qq/nC2ZwsXOGaa6g+9tx9luF95dsnU4ROI4eYsx0UfF2OIcDCptUcB8ykDgOfS
         2dFlVihRH8OV0eAFG3okoer/kVeKEQ4xD61me2SlrOmNClNSNnSfB+MUpCMzl7cVeMzn
         SemwlrRP3ZMcJTMw8ULkY61SpxagKs6MFASFzC8c/ZfzpqBdvfXWSKrx/TkjMhO5yvEQ
         sD6jQjh6utlgFTJ5CQnYbUiDyZ/vj+cDnAr7zSv//+AuEy5bv5+8FsAC1JVizdonTlql
         uScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=lcX08jSnRBdm9LOuHEdK4FTt8D4eBxuCx3/ranZw88E=;
        b=Pgx3inBC6wpMNIiTko3Qkm13Hzoq1qsx0Q7+gw3pb1Plb7s+O3wjQaAX3U95d85vQJ
         JZrfLryo0hJTevdgcCGZTnak8lrIY56u3fq5h4ozb+jR4/u1SnpYZOiq6ngxMYA7/Opt
         AftiPlA0Ml75nCmhS9QhHrGnJxyhtJ4z5vTXkRDKM9y5qZg7LZvP8ZymrwCslQsTExEk
         nBo+imtBE4u3gDHQoK/rkMt80i7SVWV+NAiuGFn9fJ1TLgB7x7Rl9/HkS0iHHD+QrcRm
         Kopfy5g8PahuXY/yDiQbjWP5t45ZkpaHf1O/LNGVafaWblsOekZwYCaok4rH3vYpj9Ca
         4vLA==
X-Gm-Message-State: APjAAAXjGM6gyLc8ib7TUf/F1iBV5Ophyq8kDXcBX23UtTdlIPAbPU4f
        JGtCYzJ27mo7ePdolUb6ocPMp30b
X-Google-Smtp-Source: APXvYqwebTgIzhWdzfeQ7ZpWtaKCsUkg/7qC2PGmtZmhmK58/Zm/pSmsLmlSw2BGs5R1AFz416Wq9Q==
X-Received: by 2002:a17:902:b418:: with SMTP id x24mr14435110plr.85.1576227231986;
        Fri, 13 Dec 2019 00:53:51 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm8664012pje.26.2019.12.13.00.53.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 00:53:51 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2 nf-next 4/5] netfilter: nft_tunnel: also dump OPTS_ERSPAN/VXLAN
Date:   Fri, 13 Dec 2019 16:53:08 +0800
Message-Id: <e4812b0aef4aaeee9751fec15f5f34d6f983e134.1576226965.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <46a6912e0996a23b79a6d52eaf9ed501a1dab86b.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <38e59ca61c8582cfc0bf1b90cccc53c4455f8357.1576226965.git.lucien.xin@gmail.com>
 <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
 <46a6912e0996a23b79a6d52eaf9ed501a1dab86b.1576226965.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the nest attr OPTS_ERSPAN/VXLAN when dumping
KEY_OPTS, and it would be helpful when parsing in userpace. Also,
this is needed for supporting multiple geneve opts in the future
patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index b3a9b10..eb17402 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -468,17 +468,24 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				struct nft_tunnel_obj *priv)
 {
 	struct nft_tunnel_opts *opts = &priv->opts;
-	struct nlattr *nest;
+	struct nlattr *nest, *inner;
 
 	nest = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS);
 	if (!nest)
 		return -1;
 
 	if (opts->flags & TUNNEL_VXLAN_OPT) {
+		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_VXLAN);
+		if (!inner)
+			return -1;
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
 				 htonl(opts->u.vxlan.gbp)))
 			return -1;
+		nla_nest_end(skb, inner);
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
+		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
+		if (!inner)
+			return -1;
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
 				 htonl(opts->u.erspan.version)))
 			return -1;
@@ -496,6 +503,7 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				return -1;
 			break;
 		}
+		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 
-- 
2.1.0

