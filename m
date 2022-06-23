Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E1255892D
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiFWTij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiFWTiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C81532F6;
        Thu, 23 Jun 2022 12:26:52 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cv13so557461pjb.4;
        Thu, 23 Jun 2022 12:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Y0TCNESLD/rJ9/TFEtPJwXznn4zmtOcnw/KdCW8HRE=;
        b=TT54HI6VO9lCoF2Bxt+tOJutd03nl69oNOvasXhkl7AveAZMpzJMwD3Vmh1IqgKB47
         MyjJq0+OIWuWjvzdAkjqcHaF6gsnwxN8h5AKgco1vBnts8wjay31nQA0TI1+SQXJ1uAp
         t2VRoFaIFWksEOpiVQHk0ddklTqGUVj91+9KAMGMN2NkUaewspNtfWTcWYh2R0DmUiRG
         nGuzZKBMtB8LXF74fTmmXY0qwteWWzLXJUuC3Z36cwKEq/NxQZZaQlsHZMOm4Wc0asHd
         KPk37NJT8+Uwyi8+wPh248p0dr0lGc/6GvY4yR1lirIk/+5bEvN53NsmCoj+7JvyU1x0
         FQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Y0TCNESLD/rJ9/TFEtPJwXznn4zmtOcnw/KdCW8HRE=;
        b=p5G1nJ6FANLXXOV+6IqOJelHjwc0ab6+e9eDWGmnExMACidjV6p3raSAcmKqaZ44bG
         uRkh8RxDYw2nnui8djVrRr7lQ8IGaggNkhC8vfJm0jc08LGuxaeKN5b3H93NRRA+jgxk
         tvL0Ks7zWv7h16JudEPuCQhqMkbJE5/id89R5AFpTNoKGVkjUoEy9OWgIWhMQLnxWgpT
         kXJvubUla392LBEkwd253AYte3U6rr/RBLe0Pic/jNeaW9VVYaHobnRyx75r1k8Hj0E7
         yQQGAC2BWlLkbkTW65uf01rn1pIRr3udjiH3PW3TdayoFWgoOvTHRNMEATDcoKqJ+dHH
         xcEg==
X-Gm-Message-State: AJIora8uhbPZADjEadNn7IDf+Yu4Q5q1n/4asgS8YtHEIqsl/su5KzUc
        LguSKQmk2tSFpLEiR4QrRNeHWjwqRs4lig==
X-Google-Smtp-Source: AGRyM1sYXoi6mjnndgO6xvRmxbXj8S18yc5FGcFiuORFrh1KOxJF1jmj9HkoxnNjPXcMf/cmxLh3ew==
X-Received: by 2002:a17:902:d701:b0:16a:2206:9ba8 with SMTP id w1-20020a170902d70100b0016a22069ba8mr22754875ply.168.1656012412063;
        Thu, 23 Jun 2022 12:26:52 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902a50900b001690ca017fasm177923plq.38.2022.06.23.12.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:26:51 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 2/8] net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
Date:   Fri, 24 Jun 2022 00:56:31 +0530
Message-Id: <20220623192637.3866852-3-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3777; h=from:subject; bh=yxHb0ifk5aVasbSBPoPTm1vSYrZWRJ8Q5CI8Hl78dZ4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5L6esi0GFbhO7IDbjwEudp3zQ1+XquL2TpK0l1 rGF9weyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+SwAKCRBM4MiGSL8RypoeD/ 45JXeXnWLCEJkh4iZoWN0ZudnYVFcwT8gBDErgs1fQK9DecbOP+QR9itgg2yzEJsBADICiB+sGOxnQ +WCbGAmCEwAiMQsxUOEVeFMcNqHEdv7S/cTXnJi1qiLFn7h0FxmHeTagbapJjJMygPaB0pyBJaF3NF OQWR0/JdvBM/L/xmaB5cYV+77XLaVEOFxDF82Qv1eIEHEekXSO8bXx3i0cG//tp8E2I9WKMeIZLlNV mDmjMLbFHjoPeoTIkSkrM3p5FlMSwf2CNbRGHB96Hb1D2wIS3jH1QLI94si1DL7KZM+zbPsti3Wigj tf7gjpHOKSxFeabCyHyz98RRznRWELMIiJxCZmP2FIOnbSkH9784Jp6xZbYd2FDc6Q9enCyuFoznlH A3Rky7iwTj2lU0iiuztOuMVoS3yOl2OUGnYUo+TR3IQJ8syAVPlVULimROeDskHOTmb8mpv6Zk85x1 s/F/PJwfFjBrqqX+q603WKbdyIv/npnJY9yHbXsJ/cAoXGXdmiNdtCTRa1Q9tX69wTUB7GdL7JNmMq OqMU+FV8JSAJV+5XFgNq4cCusmuuRB9zG9DW7k+afK2tU2YaKdxWowxnTUy/b1V+DiaDoxtzrnJyKN /M/w26YDoZwmqWEU7Qo7mabYYEfZnoJAeTieBraAGGZfbXRwLEq6LxcjKaBA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index bc4d5cd63a94..5cb1820054fb 100644
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
2.36.1

