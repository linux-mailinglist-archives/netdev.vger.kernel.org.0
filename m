Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32EC2D75A3
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405959AbgLKM3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405476AbgLKM1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:40 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D55C061285
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:25 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 23so13059354lfg.10
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVfvXqT12TyMn/Pwpg5bdVK94JN1/wHnqx5/oPgUWmg=;
        b=L2YBod+kUjkJENr40XjzVBovwZfjlgXd5oq+DLNldj2Tkjb/mN/76cep9sa+XjIYEm
         TIY72mE9NMzQxI66XL0nVyfG8bKBx0IqVhgOqB1EnOYWgDlDzyoTI5uZD/3FqNxuCciU
         Vt7LXuH7ddop7475GnVzJ0i3Qgh7E77h5JmghAFIcr6Hl+vb3ilMS//Pa8eqda2+lfxi
         IUEETl+JVtdGBXzeU/E72wmeRqmrIacPMwTuMDRNLWthcxk40bfL769AgN2Fc6WmvXql
         pIdm1L4RrGqdSaXI5+fPQb0HltHCX7CdORMqYPpmCttnGKsBoXRLgtsr/BZa/3KePBpm
         Oobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVfvXqT12TyMn/Pwpg5bdVK94JN1/wHnqx5/oPgUWmg=;
        b=Lq5Bq461Mrht3Don8AvduAAKeP7EuheAFDBTWLsk5WyQ7GAb8mS5CqZqb7FbiniFYD
         +RwLPxYEJ4y5bHM+LFqGPanwkjE0ooBia6hNAdAI0ilcIpcRMfBU1Raq5zW3t1I3IBFP
         cJReSIXYl4pSHaRGwEL3Z9fv/OMmoR3dC60c8dqteT5j3Sp0Ki+me/f8dlel9fB638JO
         sjAAoMW18twPoOlYa9ARlpSKkeJpOfZ41yBynTM7jQd7zW5hSLav+dEpat/JxHFfvu6p
         2EyGENNRq4qG+0sRpG5zdfLdv3KFkh3ovCBN+rEXLu++ad5Lqk0z9r5Gp1jiR7O4dQ/b
         Xbzw==
X-Gm-Message-State: AOAM530ktadDGwkjHYNhuHNWKarARCkoKX5Ro+GCjDWWZcy80N+HlXhN
        eLHcB0IAq6LFW03I1uKEvoYA3oKlqpjgZw==
X-Google-Smtp-Source: ABdhPJwJLE2eNZlah/1nlYfg9uHjBCC4O5rde+NYVmwXvaj603Co81vljXvZTyDs1YPTIt0dZXxPbw==
X-Received: by 2002:ac2:41da:: with SMTP id d26mr4632916lfi.15.1607689583818;
        Fri, 11 Dec 2020 04:26:23 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:23 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 11/12] gtp: netlink update for ipv6
Date:   Fri, 11 Dec 2020 13:26:11 +0100
Message-Id: <20201211122612.869225-12-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the netlink changes required to support IPv6.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c        | 84 ++++++++++++++++++++++++++++++----------
 include/uapi/linux/gtp.h |  2 +
 2 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c902bffefa3..40bbbe8cfad6 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1231,11 +1231,26 @@ static struct gtp_dev *gtp_find_dev(struct net *src_net, struct nlattr *nla[])
 	return gtp;
 }
 
-static void ipv4_pdp_fill(struct pdp_ctx *pctx, struct genl_info *info)
+static void pdp_fill(struct pdp_ctx *pctx, struct genl_info *info)
 {
 	pctx->gtp_version = nla_get_u32(info->attrs[GTPA_VERSION]);
-	ipv4(&pctx->peer_addr) = nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]);
-	ipv4(&pctx->ms_addr) = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
+	pctx->flags = 0;
+
+	if (info->attrs[GTPA_PEER_IPV6]) {
+		pctx->flags |= PDP_F_PEER_V6;
+		pctx->peer_addr = nla_get_in6_addr(info->attrs[GTPA_PEER_IPV6]);
+	} else
+		ipv6_addr_set_v4mapped(
+				nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]),
+				&pctx->peer_addr);
+
+	if (info->attrs[GTPA_MS_IPV6]) {
+		pctx->flags |= PDP_F_MS_V6;
+		pctx->ms_addr = nla_get_in6_addr(info->attrs[GTPA_MS_IPV6]);
+	} else
+		ipv6_addr_set_v4mapped(
+				nla_get_be32(info->attrs[GTPA_MS_ADDRESS]),
+				&pctx->ms_addr);
 
 	switch (pctx->gtp_version) {
 	case GTP_V0:
@@ -1263,13 +1278,20 @@ static struct pdp_ctx *gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 	u32 hash_ms, hash_tid = 0;
 	unsigned int version;
 	bool found = false;
-	__be32 ms_addr;
 
-	ms_addr = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
-	hash_ms = ipv4_hashfn(ms_addr) % gtp->hash_size;
+	if (info->attrs[GTPA_MS_IPV6]) {
+		struct in6_addr ms_addr_v6;
+		ms_addr_v6 = nla_get_in6_addr(info->attrs[GTPA_MS_IPV6]);
+		hash_ms = ipv6_hashfn(&ms_addr_v6) % gtp->hash_size;
+		pctx = ipv6_pdp_find(gtp, &ms_addr_v6);
+	} else {
+		__be32 ms_addr;
+		ms_addr = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
+		hash_ms = ipv4_hashfn(ms_addr) % gtp->hash_size;
+		pctx = ipv4_pdp_find(gtp, ms_addr);
+	}
 	version = nla_get_u32(info->attrs[GTPA_VERSION]);
 
-	pctx = ipv4_pdp_find(gtp, ms_addr);
 	if (pctx)
 		found = true;
 	if (version == GTP_V0)
@@ -1292,7 +1314,7 @@ static struct pdp_ctx *gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 		if (!pctx)
 			pctx = pctx_tid;
 
-		ipv4_pdp_fill(pctx, info);
+		pdp_fill(pctx, info);
 
 		if (pctx->gtp_version == GTP_V0)
 			netdev_dbg(dev, "GTPv0-U: update tunnel id = %llx (pdp %p)\n",
@@ -1312,7 +1334,7 @@ static struct pdp_ctx *gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 	sock_hold(sk);
 	pctx->sk = sk;
 	pctx->dev = gtp->dev;
-	ipv4_pdp_fill(pctx, info);
+	pdp_fill(pctx, info);
 	atomic_set(&pctx->tx_seq, 0);
 
 	switch (pctx->gtp_version) {
@@ -1334,14 +1356,14 @@ static struct pdp_ctx *gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 
 	switch (pctx->gtp_version) {
 	case GTP_V0:
-		netdev_dbg(dev, "GTPv0-U: new PDP ctx id=%llx ssgn=%pI4 ms=%pI4 (pdp=%p)\n",
-			   pctx->u.v0.tid, &ipv4(&pctx->peer_addr),
-			   &ipv4(&pctx->ms_addr), pctx);
+		netdev_dbg(dev, "GTPv0-U: new PDP ctx id=%llx ssgn=%pI6 ms=%pI6 (pdp=%p)\n",
+			   pctx->u.v0.tid, &pctx->peer_addr,
+			   &pctx->ms_addr, pctx);
 		break;
 	case GTP_V1:
-		netdev_dbg(dev, "GTPv1-U: new PDP ctx id=%x/%x ssgn=%pI4 ms=%pI4 (pdp=%p)\n",
+		netdev_dbg(dev, "GTPv1-U: new PDP ctx id=%x/%x ssgn=%pI6 ms=%pI6 (pdp=%p)\n",
 			   pctx->u.v1.i_tei, pctx->u.v1.o_tei,
-			   &ipv4(&pctx->peer_addr), &ipv4(&pctx->ms_addr), pctx);
+			   &pctx->peer_addr, &pctx->ms_addr, pctx);
 		break;
 	}
 
@@ -1374,9 +1396,13 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 	int err;
 
 	if (!info->attrs[GTPA_VERSION] ||
-	    !info->attrs[GTPA_LINK] ||
-	    !info->attrs[GTPA_PEER_ADDRESS] ||
-	    !info->attrs[GTPA_MS_ADDRESS])
+	    !info->attrs[GTPA_LINK])
+		return -EINVAL;
+
+	if (!info->attrs[GTPA_PEER_ADDRESS] == !info->attrs[GTPA_PEER_IPV6])
+		return -EINVAL;
+
+	if (!info->attrs[GTPA_MS_ADDRESS] == !info->attrs[GTPA_MS_IPV6])
 		return -EINVAL;
 
 	version = nla_get_u32(info->attrs[GTPA_VERSION]);
@@ -1439,7 +1465,11 @@ static struct pdp_ctx *gtp_find_pdp_by_link(struct net *net,
 	if (!gtp)
 		return ERR_PTR(-ENODEV);
 
-	if (nla[GTPA_MS_ADDRESS]) {
+	if (nla[GTPA_MS_IPV6]) {
+		struct in6_addr ip = nla_get_in6_addr(nla[GTPA_MS_IPV6]);
+
+		return ipv6_pdp_find(gtp, &ip);
+	} else if (nla[GTPA_MS_ADDRESS]) {
 		__be32 ip = nla_get_be32(nla[GTPA_MS_ADDRESS]);
 
 		return ipv4_pdp_find(gtp, ip);
@@ -1522,9 +1552,19 @@ static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 		goto nlmsg_failure;
 
 	if (nla_put_u32(skb, GTPA_VERSION, pctx->gtp_version) ||
-	    nla_put_u32(skb, GTPA_LINK, pctx->dev->ifindex) ||
-	    nla_put_be32(skb, GTPA_PEER_ADDRESS, ipv4(&pctx->peer_addr)) ||
-	    nla_put_be32(skb, GTPA_MS_ADDRESS, ipv4(&pctx->ms_addr)))
+	    nla_put_u32(skb, GTPA_LINK, pctx->dev->ifindex))
+		goto nla_put_failure;
+
+	if ((pctx->flags & PDP_F_PEER_V6) &&
+	   nla_put_in6_addr(skb, GTPA_PEER_IPV6, &pctx->peer_addr))
+		goto nla_put_failure;
+	else if (nla_put_be32(skb, GTPA_PEER_ADDRESS, ipv4(&pctx->peer_addr)))
+		goto nla_put_failure;
+
+	if ((pctx->flags & PDP_F_MS_V6) &&
+	    nla_put_in6_addr(skb, GTPA_MS_IPV6, &pctx->ms_addr))
+		goto nla_put_failure;
+	else if (nla_put_be32(skb, GTPA_MS_ADDRESS, ipv4(&pctx->ms_addr)))
 		goto nla_put_failure;
 
 	switch (pctx->gtp_version) {
@@ -1660,6 +1700,8 @@ static const struct nla_policy gtp_genl_policy[GTPA_MAX + 1] = {
 	[GTPA_TID]		= { .type = NLA_U64, },
 	[GTPA_PEER_ADDRESS]	= { .type = NLA_U32, },
 	[GTPA_MS_ADDRESS]	= { .type = NLA_U32, },
+	[GTPA_PEER_IPV6]	= { .len = sizeof(struct in6_addr), },
+	[GTPA_MS_IPV6]		= { .len = sizeof(struct in6_addr), },
 	[GTPA_FLOW]		= { .type = NLA_U16, },
 	[GTPA_NET_NS_FD]	= { .type = NLA_U32, },
 	[GTPA_I_TEI]		= { .type = NLA_U32, },
diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
index 79f9191bbb24..5fe0ca6a917e 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -30,6 +30,8 @@ enum gtp_attrs {
 	GTPA_I_TEI,	/* for GTPv1 only */
 	GTPA_O_TEI,	/* for GTPv1 only */
 	GTPA_PAD,
+	GTPA_PEER_IPV6,
+	GTPA_MS_IPV6,
 	__GTPA_MAX,
 };
 #define GTPA_MAX (__GTPA_MAX + 1)
-- 
2.27.0

