Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0B011605F
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfLHEmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:42:46 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40968 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLHEmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:42:45 -0500
Received: by mail-pg1-f193.google.com with SMTP id x8so5387023pgk.8;
        Sat, 07 Dec 2019 20:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=46Cslhljx0drWYUaFV1vL+brfJba5TUjAyGh4T5WE8w=;
        b=dg3sa+9LttOx51pHFEe35rbr68ZQ7c9P/cF1fNC77eIaO46GbCW/SFNG1+VzaUheE8
         vFWjpyumD+rAlkcoopus65077TepqwwqFqPTfSp/aC/KpvXFAvWu7BXoPWFsROJkpNxL
         vQjoXnIH8aGHS5XGSD456wEky7QoaNruqQslCKPnVGqTP4NUrbnIxOdMG0mUAnUY1QzM
         Me5ROrkVGnZd2mUATGOyliLh0Chb+GHkj1lUqOrOR274iSZ5sfbeIYHLQ1ilzlhPPL8E
         f1op+4m6S2jgPdlZUzf4ijdqg6fOHq68J17trqfXSZ5BcG+vdAgHKLav4/vhf2723Tp8
         ENKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=46Cslhljx0drWYUaFV1vL+brfJba5TUjAyGh4T5WE8w=;
        b=rU+JwVYf/kMEOOmvXAatdnEFEeG+GsIY8fi+1n6ky6eVTqXvmH+uxnV8wweaW+Q0oK
         jL/QOLIueA3OJkz2vYCtD/s2dOZi3NeqsJ89lYxK90RTCXh7LCRXxSuWjkm6mU8T+iGT
         IuZEzXlSbUfwwIu9IzAmFfzPBVCJMEQ9ilhd9irSrAGAM6oU/slSA1L6fyflb5ff2ltz
         GqmDzwXxMpy56842E4ZASuMU1ULS7CVSBdGaVHKDPt9sCt+f7CFiTnCI9KXcortaPksS
         ppgv1HsdvndDIO5fJWK8ygfJsO873mY1NXx88r9doGckGc3JjOzgDkDv2FlosCzVtsOU
         MfFA==
X-Gm-Message-State: APjAAAVbXneFcBvNfxW4Z5YK5oBfFE9hIAm/Sgq6p1eXY4e6E/A6FdV2
        FnmW4YR3yR89YTVjkcLc7FXAORBt
X-Google-Smtp-Source: APXvYqzJH0acCAPPORV24+QTgAPDPaZMA7ACp6A2spNDWjjmp5TEtu+TgUDvtWxMU3KA5rvm17TX+g==
X-Received: by 2002:a63:8f46:: with SMTP id r6mr12309761pgn.51.1575780164664;
        Sat, 07 Dec 2019 20:42:44 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o184sm3719003pgo.62.2019.12.07.20.42.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:42:43 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 7/7] netfilter: nft_tunnel: add support for geneve opts
Date:   Sun,  8 Dec 2019 12:41:37 +0800
Message-Id: <dded05afd8ad1a1f3a80deb84c6b6553b8f80ae3.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <40a34ac68b79886f755ec076cbf787ecf7fdc014.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
 <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
 <e64595c27468e392826f0afb5f18b68ce258787a.1575779993.git.lucien.xin@gmail.com>
 <396287a2b2d8797dae70c5740084c4d0cb225a08.1575779993.git.lucien.xin@gmail.com>
 <40a34ac68b79886f755ec076cbf787ecf7fdc014.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like vxlan and erspan opts, geneve opts should also be supported in
nft_tunnel. The difference is geneve RFC (draft-ietf-nvo3-geneve-14)
allows a geneve packet to carry multiple geneve opts. So with this
patch, nftables/libnftnl would do:

  # nft add table ip filter
  # nft add chain ip filter input { type filter hook input priority 0 \; }
  # nft add tunnel filter geneve_02 { type geneve\; id 2\; \
    ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
    sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
    opts \"1:1:34567890,2:2:12121212,3:3:1212121234567890\"\; }
  # nft list tunnels table filter
    table ip filter {
    	tunnel geneve_02 {
    		id 2
    		ip saddr 192.168.1.1
    		ip daddr 192.168.1.2
    		sport 9000
    		dport 9001
    		tos 18
    		ttl 64
    		flags 1
    		geneve opts 1:1:34567890,2:2:12121212,3:3:1212121234567890
    	}
    }

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  10 +++
 net/netfilter/nft_tunnel.c               | 110 +++++++++++++++++++++++++++----
 2 files changed, 108 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bb9b049..f74b957 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1729,6 +1729,7 @@ enum nft_tunnel_opts_attributes {
 	NFTA_TUNNEL_KEY_OPTS_UNSPEC,
 	NFTA_TUNNEL_KEY_OPTS_VXLAN,
 	NFTA_TUNNEL_KEY_OPTS_ERSPAN,
+	NFTA_TUNNEL_KEY_OPTS_GENEVE,
 	__NFTA_TUNNEL_KEY_OPTS_MAX
 };
 #define NFTA_TUNNEL_KEY_OPTS_MAX	(__NFTA_TUNNEL_KEY_OPTS_MAX - 1)
@@ -1750,6 +1751,15 @@ enum nft_tunnel_opts_erspan_attributes {
 };
 #define NFTA_TUNNEL_KEY_ERSPAN_MAX	(__NFTA_TUNNEL_KEY_ERSPAN_MAX - 1)
 
+enum nft_tunnel_opts_geneve_attributes {
+	NFTA_TUNNEL_KEY_GENEVE_UNSPEC,
+	NFTA_TUNNEL_KEY_GENEVE_CLASS,
+	NFTA_TUNNEL_KEY_GENEVE_TYPE,
+	NFTA_TUNNEL_KEY_GENEVE_DATA,
+	__NFTA_TUNNEL_KEY_GENEVE_MAX
+};
+#define NFTA_TUNNEL_KEY_GENEVE_MAX	(__NFTA_TUNNEL_KEY_GENEVE_MAX - 1)
+
 enum nft_tunnel_flags {
 	NFT_TUNNEL_F_ZERO_CSUM_TX	= (1 << 0),
 	NFT_TUNNEL_F_DONT_FRAGMENT	= (1 << 1),
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 32263dc..f621d2b2 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -11,6 +11,7 @@
 #include <net/ip_tunnels.h>
 #include <net/vxlan.h>
 #include <net/erspan.h>
+#include <net/geneve.h>
 
 struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
@@ -144,6 +145,7 @@ struct nft_tunnel_opts {
 	union {
 		struct vxlan_metadata	vxlan;
 		struct erspan_metadata	erspan;
+		u8	data[IP_TUNNEL_OPTS_MAX];
 	} u;
 	u32	len;
 	__be16	flags;
@@ -298,9 +300,53 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
 	return 0;
 }
 
+static const struct nla_policy nft_tunnel_opts_geneve_policy[NFTA_TUNNEL_KEY_GENEVE_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_GENEVE_CLASS]	= { .type = NLA_U16 },
+	[NFTA_TUNNEL_KEY_GENEVE_TYPE]	= { .type = NLA_U8 },
+	[NFTA_TUNNEL_KEY_GENEVE_DATA]	= { .type = NLA_BINARY, .len = 128 },
+};
+
+static int nft_tunnel_obj_geneve_init(const struct nlattr *attr,
+				      struct nft_tunnel_opts *opts)
+{
+	struct geneve_opt *opt = (struct geneve_opt *)opts->u.data + opts->len;
+	struct nlattr *tb[NFTA_TUNNEL_KEY_GENEVE_MAX + 1];
+	int err, data_len;
+
+	err = nla_parse_nested(tb, NFTA_TUNNEL_KEY_GENEVE_MAX, attr,
+			       nft_tunnel_opts_geneve_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_TUNNEL_KEY_GENEVE_CLASS] ||
+	    !tb[NFTA_TUNNEL_KEY_GENEVE_TYPE] ||
+	    !tb[NFTA_TUNNEL_KEY_GENEVE_DATA])
+		return -EINVAL;
+
+	attr = tb[NFTA_TUNNEL_KEY_GENEVE_DATA];
+	data_len = nla_len(attr);
+	if (data_len % 4)
+		return -EINVAL;
+
+	opts->len += sizeof(*opt) + data_len;
+	if (opts->len > IP_TUNNEL_OPTS_MAX)
+		return -EINVAL;
+
+	memcpy(opt->opt_data, nla_data(attr), data_len);
+	opt->length = data_len / 4;
+	opt->opt_class = nla_get_be16(tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]);
+	opt->type = nla_get_u8(tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]);
+	opts->flags = TUNNEL_GENEVE_OPT;
+
+	return 0;
+}
+
 static const struct nla_policy nft_tunnel_opts_policy[NFTA_TUNNEL_KEY_OPTS_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_OPTS_UNSPEC]	= {
+		.strict_start_type = NFTA_TUNNEL_KEY_OPTS_GENEVE },
 	[NFTA_TUNNEL_KEY_OPTS_VXLAN]	= { .type = NLA_NESTED, },
 	[NFTA_TUNNEL_KEY_OPTS_ERSPAN]	= { .type = NLA_NESTED, },
+	[NFTA_TUNNEL_KEY_OPTS_GENEVE]	= { .type = NLA_NESTED, },
 };
 
 static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
@@ -308,22 +354,43 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 				    struct ip_tunnel_info *info,
 				    struct nft_tunnel_opts *opts)
 {
-	struct nlattr *tb[NFTA_TUNNEL_KEY_OPTS_MAX + 1];
-	int err;
+	int err, rem, type = 0;
+	struct nlattr *nla;
 
-	err = nla_parse_nested_deprecated(tb, NFTA_TUNNEL_KEY_OPTS_MAX, attr,
-					  nft_tunnel_opts_policy, NULL);
+	err = nla_validate_nested_deprecated(attr, NFTA_TUNNEL_KEY_OPTS_MAX,
+					     nft_tunnel_opts_policy, NULL);
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]) {
-		err = nft_tunnel_obj_vxlan_init(tb[NFTA_TUNNEL_KEY_OPTS_VXLAN],
-						opts);
-	} else if (tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]) {
-		err = nft_tunnel_obj_erspan_init(tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN],
-						 opts);
-	} else {
-		return -EOPNOTSUPP;
+	nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem) {
+		switch (nla_type(nla)) {
+		case NFTA_TUNNEL_KEY_OPTS_VXLAN:
+			if (type)
+				return -EINVAL;
+			err = nft_tunnel_obj_vxlan_init(nla, opts);
+			if (err)
+				return err;
+			type = TUNNEL_VXLAN_OPT;
+			break;
+		case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
+			if (type)
+				return -EINVAL;
+			err = nft_tunnel_obj_erspan_init(nla, opts);
+			if (err)
+				return err;
+			type = TUNNEL_ERSPAN_OPT;
+			break;
+		case NFTA_TUNNEL_KEY_OPTS_GENEVE:
+			if (type && type != TUNNEL_GENEVE_OPT)
+				return -EINVAL;
+			err = nft_tunnel_obj_geneve_init(nla, opts);
+			if (err)
+				return err;
+			type = TUNNEL_GENEVE_OPT;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return err;
@@ -513,6 +580,25 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 			break;
 		}
 		nla_nest_end(skb, inner);
+	} else if (opts->flags & TUNNEL_GENEVE_OPT) {
+		struct geneve_opt *opt;
+		int offset = 0;
+
+		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+		if (!inner)
+			goto failure;
+		while (opts->len > offset) {
+			opt = (struct geneve_opt *)opts->u.data + offset;
+			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
+					 opt->opt_class) ||
+			    nla_put_u8(skb, NFTA_TUNNEL_KEY_GENEVE_TYPE,
+				       opt->type) ||
+			    nla_put(skb, NFTA_TUNNEL_KEY_GENEVE_DATA,
+				    opt->length * 4, opt->opt_data))
+				goto inner_failure;
+			offset += sizeof(*opt) + opt->length * 4;
+		}
+		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 	return 0;
-- 
2.1.0

