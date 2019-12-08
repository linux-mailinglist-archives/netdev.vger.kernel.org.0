Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CE116055
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfLHEmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:42:04 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37340 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLHEmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:42:03 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep17so4429032pjb.4;
        Sat, 07 Dec 2019 20:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qwOLvkvckTZtxbwDsH5jIwK2rcBu/wMQwWoDdBycLec=;
        b=FGh2NSrJqTZysqMHKqE/b+j5/WFcXnevjltSxkmsBm/Ig6VYBxx/WJP+3GUcrHzCfK
         CaFkRwUiW6zFX81cfoz57sD9V3Mgqiw9PUlA3GRMYzANPWK+wQEyxRkMYP+y54hKlvlJ
         ttBvUxjvga3c+DNRh8ke4Prkp1BfmVQ3DhZXOkAHtqvgq3ZgSjm+u98CFd5R+etMrbCj
         FBMUO62M+APlsCpVyOujBoGQG7CDNA6uXCZTYfkG+sG3RYIgagDy46YLPDSygu9XR70P
         QH6uPB9hhR/5RvMMtEB8ApSRtdknXKt0OBOhQtGskWQgLiS2sltw75VLtbYpWDR65X2K
         MWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qwOLvkvckTZtxbwDsH5jIwK2rcBu/wMQwWoDdBycLec=;
        b=C2pbQu09H1S4y5LjHQvrHhPHIThaH3LdlItuGlORxYvxTseTmzVfqRVObE6BB7966L
         uqgPV0NopFXW7t+65/Y0vjskqmKvaBJ6tBcpwnBNbRN9OhX/4iTHd5M/Vs5Iqub6rCAF
         d/ualgj9HT5taVSuUNHvRL8wNP8zwGcvrjF6ZPeXhNI8s2+kpCqXXqGOdceiWSoE65kz
         uNIqXcaVWEWor7zglB6KDq0J9hiua5MIzHXaJI3ZMu0YrWKL9PamPjeKep4CCCfQ6aw+
         Ywts4IPqnuusrEsKtw/nlYhGLwW0/NnVvXeR8lc2TIof+kOk8eMLeWlzq7p/uKL9EcXH
         MU/Q==
X-Gm-Message-State: APjAAAXptMEnLmqEx/k5u3FvnRaNvW7SNXAPBLVhZJdyHjB0C5aHWpQs
        9Gcq8cB5Vwn0bgBxC6LislgzhxSs
X-Google-Smtp-Source: APXvYqzSQfs3QyxhjCCNnhMOtWaQuXKTP+a+eyXFWggwPnSMRxjOROv8Hv1t6sd7qTGsNCE5LooGyQ==
X-Received: by 2002:a17:90a:890c:: with SMTP id u12mr25192470pjn.79.1575780122804;
        Sat, 07 Dec 2019 20:42:02 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o3sm7821679pjp.23.2019.12.07.20.42.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:42:02 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/7] netfilter: nft_tunnel: parse VXLAN_GBP attr as u32 in nft_tunnel
Date:   Sun,  8 Dec 2019 12:41:32 +0800
Message-Id: <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both user and kernel sides want VXLAN_GBP opt as u32, so there's no
need to convert it on each side.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nft_tunnel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index f76cd7d..d9d6c0d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -239,7 +239,7 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
 	if (!tb[NFTA_TUNNEL_KEY_VXLAN_GBP])
 		return -EINVAL;
 
-	opts->u.vxlan.gbp = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]));
+	opts->u.vxlan.gbp = nla_get_u32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]);
 
 	opts->len	= sizeof(struct vxlan_metadata);
 	opts->flags	= TUNNEL_VXLAN_OPT;
@@ -475,8 +475,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 		return -1;
 
 	if (opts->flags & TUNNEL_VXLAN_OPT) {
-		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
-				 htonl(opts->u.vxlan.gbp)))
+		if (nla_put_u32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
+				opts->u.vxlan.gbp))
 			return -1;
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
 		switch (opts->u.erspan.version) {
-- 
2.1.0

