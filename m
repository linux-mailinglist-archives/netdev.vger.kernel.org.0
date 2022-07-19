Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57FC57A0A2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiGSOIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbiGSOIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:01 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ED853D2A;
        Tue, 19 Jul 2022 06:24:43 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id j22so27179960ejs.2;
        Tue, 19 Jul 2022 06:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lE4c6sszvZbkuJN9C07UY0PUQWB5cLJYZTKLAPRZnko=;
        b=nYlPYDXWQ7Me0sTGD61jEhbHp1OLSjmApZg65gpyOsbyS/0ToS7RkU6GysWjBI3f1G
         xyfvQ4dZiqklmHRLhVJ1RwfPLbG+SlyrikYwS2SIK7sgkTjh4Oa4xUs54B8LUqBTlmnI
         Ohlux2uv7GFuzfKfwNzvkcaltldPuwguqUnJhtBZALI6k/oP6dTrzPAke/AKElBDQe7y
         LuHhVJiJ5LNJlexVeEE6tR8sB6wsLJwiEcfa8vUzZbzzki++1C7R1dWftXVdJGXoOtPh
         FJ5Q1R106coowuP0o/d3uEpLIaJt8/M2uVT5rPh7qKR1HJcDdK0DYQddzeda60CWdmTN
         TF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lE4c6sszvZbkuJN9C07UY0PUQWB5cLJYZTKLAPRZnko=;
        b=oxEl24ElMQIjXcoOuwFMO105WaQfBdM+qB4ZFY1w8ciaLdBgFBs+uztkV+vo0oJMgE
         ShEvlS/jVu+jOyXlESP2He/BzEkspJFUCk2B3jclbPLY4y2s/FTmMmX7yu2BgO3P7U2s
         1vSZ3U62X35jvsqgOG39mckNufd7s2+4BbijzWyeVWhw7CFhA9+EHfI85mlrErJvfTwQ
         e/XM4UlrjZ0oUCGAzB3Izj3OQ0aZnFeNe3iBCoazzS7idEtMV7MVgXMFWP5RF547foEW
         RUzgUzXhp+yePZb2TaZ+YigD2hzykdfcCgmoeZsLbSMMo2C+35uhzVE/vLZklzchjA1L
         hW/Q==
X-Gm-Message-State: AJIora92W2mmeK5FCej3SVlSnrWs50NamZQRQkz/ujsGS7cNDv/FLz4V
        r66fpkZciwjY6RqInMOL5YGFkNw01gkcxw==
X-Google-Smtp-Source: AGRyM1vkvEz/ZGBR7vpdehj4D1M0QcOUw4X7MNMChvEw60hKclT8saaDFGkS9GAGr1geKkO981msdw==
X-Received: by 2002:a17:906:844f:b0:72b:549e:a654 with SMTP id e15-20020a170906844f00b0072b549ea654mr29319274ejy.535.1658237081321;
        Tue, 19 Jul 2022 06:24:41 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090616c800b00715a02874acsm6655065ejd.35.2022.07.19.06.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:41 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v6 06/13] net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
Date:   Tue, 19 Jul 2022 15:24:23 +0200
Message-Id: <20220719132430.19993-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3777; i=memxor@gmail.com; h=from:subject; bh=SUqdFpeA+7gJZkfhIAoext8wzNqYLWZ/6oT/iWwgjcY=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlvMDEOxo4w0uhBueM5sy0jqlWJ/66E7l8GD1b plfesfyJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RytuBD/ 9JJvJeOrSDYwj6by09Dr87K9w3zd/q3YO9ZOpaFhGfo1HDwj0K3KcpSirJE8oQCmZkq/kMiBk8lVcq v0zaeqGqP2qcDYp6EFLIwp9VW2rnU1VZNVfQTiD1+pSx6l9I+HU9r8DgrHncbxMmEU60hjRKjcDewx I6x6z1u+8c3VJzczinby01V5tiVBnAomH8P+wRt0BniH0i3qxL+KFH3MfTQH2tc6CnVARkbepKquSJ n+nQdzUnLylOublK0W3Rmtnw/TYj1GKwenAMXMMuEIAGPSZOYKPub41k4OO4Mnr6EtZnGQzB9qjRP/ WLKT+PISSRsdzhqgIXG4u1z2xpo/leoO2baecswTEv5qXpp36OPr1WgvqnSpGEIVJr4ckybrzr/b2b QrQ0fvEQggRZuKkAZZrLqXUkgsAU1g0gLePUj1yFxIYLLjQLiHmVqqcOtDE7gy6CZaRwI5x5ZUBFNg k6n8VVL870PmEQbE4H52H/W5KV49m66tKq8mareEWjoylkydqGOnvKLrHOxgR2s9ykkU/bGwsSm1yj 75VoppdgZbqpGNZ91mVdrvKzFOmYfhejgP69TowwPxR8iFBnQZLdHVRTncZSXtXhRPOkwIhWvgOg2S ZwMJm4wqQQXgiZ4ZmyfzbLUTToRKIEP4XdRbb4J8PXLpQ6wy2MCtFaVqD+aw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move common checks inside the common function, and maintain the only
difference the two being how to obtain the struct net * from ctx.
No functional change intended.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/netfilter/nf_conntrack_bpf.c | 52 +++++++++++---------------------
 1 file changed, 18 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 5b20d0ca9b01..0ba3cbde72ec 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -57,16 +57,19 @@ enum {
 
 static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 					  struct bpf_sock_tuple *bpf_tuple,
-					  u32 tuple_len, u8 protonum,
-					  s32 netns_id, u8 *dir)
+					  u32 tuple_len, struct bpf_ct_opts *opts,
+					  u32 opts_len)
 {
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 
-	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts_len != NF_BPF_CT_OPTS_SZ)
+		return ERR_PTR(-EINVAL);
+	if (unlikely(opts->l4proto != IPPROTO_TCP && opts->l4proto != IPPROTO_UDP))
 		return ERR_PTR(-EPROTO);
-	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
 	memset(&tuple, 0, sizeof(tuple));
@@ -89,23 +92,22 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 		return ERR_PTR(-EAFNOSUPPORT);
 	}
 
-	tuple.dst.protonum = protonum;
+	tuple.dst.protonum = opts->l4proto;
 
-	if (netns_id >= 0) {
-		net = get_net_ns_by_id(net, netns_id);
+	if (opts->netns_id >= 0) {
+		net = get_net_ns_by_id(net, opts->netns_id);
 		if (unlikely(!net))
 			return ERR_PTR(-ENONET);
 	}
 
 	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
-	if (netns_id >= 0)
+	if (opts->netns_id >= 0)
 		put_net(net);
 	if (!hash)
 		return ERR_PTR(-ENOENT);
 
 	ct = nf_ct_tuplehash_to_ctrack(hash);
-	if (dir)
-		*dir = NF_CT_DIRECTION(hash);
+	opts->dir = NF_CT_DIRECTION(hash);
 
 	return ct;
 }
@@ -138,20 +140,11 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct net *caller_net;
 	struct nf_conn *nfct;
 
-	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
-
-	if (!opts)
-		return NULL;
-	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts__sz != NF_BPF_CT_OPTS_SZ) {
-		opts->error = -EINVAL;
-		return NULL;
-	}
 	caller_net = dev_net(ctx->rxq->dev);
-	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
-				  opts->netns_id, &opts->dir);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
 	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
+		if (opts)
+			opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 	return nfct;
@@ -181,20 +174,11 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct net *caller_net;
 	struct nf_conn *nfct;
 
-	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
-
-	if (!opts)
-		return NULL;
-	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts__sz != NF_BPF_CT_OPTS_SZ) {
-		opts->error = -EINVAL;
-		return NULL;
-	}
 	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
-	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
-				  opts->netns_id, &opts->dir);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
 	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
+		if (opts)
+			opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 	return nfct;
-- 
2.34.1

