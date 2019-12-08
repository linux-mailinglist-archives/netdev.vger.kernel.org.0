Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A38211605B
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfLHEm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:42:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42754 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLHEm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:42:28 -0500
Received: by mail-pg1-f194.google.com with SMTP id i5so5378000pgj.9;
        Sat, 07 Dec 2019 20:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=vU0FLV7+EIF3kbe1Ku5lKr+RUiD4T7AQaC3MO52HDQE=;
        b=SGV5MbLLv5EnP6NirvU9H8pEKpuEm2QG2pGW17+HQYuwR/LcA4NtqON9auXY7/z3xB
         pWCZigrXvy5rB+8oARscBgWYO7sV5mWQhJ7NKJXdVI27gbx4KRotXg43BAvzJoaysedb
         rFKyJuBOP7pP+aykkh2iZsOHAZ53ju72HXR93kdTFvQZ+EQxyPSp+wEq1xiDpgMaGnCV
         leH80Dh8nUp+us9soOKc4AvSG4PspYCKQQc3jfdX+wagnZ6FV0rAChvVGwWIFrPhDoUG
         Jb/3++F5gZFTO+XQa0tUNVzFdSiQXpKBDc/YGlRKnwnPed72ZbaNqeMWvjkGpqBwWOVc
         geiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=vU0FLV7+EIF3kbe1Ku5lKr+RUiD4T7AQaC3MO52HDQE=;
        b=ES4Cd8hFjZuDDnRFkEKnvmOErTKzlVDgWf5pYmsHImahkOVNV4Johr08H1A2DxmblJ
         xinx6jhvjAXRmYHJzOwTPckV6C6AW59L7VNqQSV3c6BJtoqjJul9ox1rly0/d9eFS/bR
         j9vHRMa2kMPG6W4nOLx8nXVHSexhHa5TzsPX0fmoY1kS006G0Y+vQsTvMOwPZHTgNsad
         R7hy+fSQaKghl1tNwrS0prsYk2nU2YhfGha78OgFfhLyMAor2zWBcz/MpHySHyGZ07Ge
         U1lLQhdgI+WQMj9AEN7nknbvZnTRnn5V3ieqV9bhB4coIAXrHO2KdFq4hqjhmW2FFWuY
         3NHQ==
X-Gm-Message-State: APjAAAX/xsFtFUNjmDQ+ratFZ4p2dMGlbKAUTRao+8Ez6+hpIshhD8WH
        q8122luHS1Y2q/OzbtGTVjOm/ubX
X-Google-Smtp-Source: APXvYqwS/kXp54dMfcb3H8SVWHrT2ZJrSo8fVBBHupDimetkcMQpJvNY4hoRXegJGR3cB+r1ksDqbQ==
X-Received: by 2002:a65:62d3:: with SMTP id m19mr12057185pgv.270.1575780147747;
        Sat, 07 Dec 2019 20:42:27 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c9sm21389578pfn.65.2019.12.07.20.42.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:42:27 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 5/7] netfilter: nft_tunnel: also dump OPTS_ERSPAN/VXLAN
Date:   Sun,  8 Dec 2019 12:41:35 +0800
Message-Id: <396287a2b2d8797dae70c5740084c4d0cb225a08.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e64595c27468e392826f0afb5f18b68ce258787a.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
 <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
 <e64595c27468e392826f0afb5f18b68ce258787a.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the nest attr OPTS_ERSPAN/VXLAN when dumping
KEY_OPTS, and it would be helpful when parsing in userpace. Also,
this is needed for supporting multiple geneve opts in the future
patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nft_tunnel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 576437f..e9b94b8 100644
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
 		if (nla_put_u32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
 				opts->u.vxlan.gbp))
 			return -1;
+		nla_nest_end(skb, inner);
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
+		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
+		if (!inner)
+			return -1;
 		if (nla_put_u8(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
 			       opts->u.erspan.version))
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

