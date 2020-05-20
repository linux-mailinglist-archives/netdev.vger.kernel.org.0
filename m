Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5291DBB73
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgETR2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:28:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60829 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgETR2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2+zD3HZdEq+9hnkglpmY9VDlG7bltPE6sGGPGE7c7X0=;
        b=Fjdfgm7Uc4JfRQGSHhnmcTcewtrt7cjhmeY09UPT9dVU/Efedu6js9jUyeQk/lp6H3pBPx
        eh0KlPOF7wy7s1tSFvvjlOa6B1BIvzRzALKcsX2jAwsENM+l3eSRJXqw+un5ntaihIfAPf
        GAOp4fATD4snRLtGhBGppo4qg5OEpBM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-fnRwWukwOPqPauVtsCYWyQ-1; Wed, 20 May 2020 13:28:42 -0400
X-MC-Unique: fnRwWukwOPqPauVtsCYWyQ-1
Received: by mail-wm1-f69.google.com with SMTP id f62so1541445wme.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 10:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2+zD3HZdEq+9hnkglpmY9VDlG7bltPE6sGGPGE7c7X0=;
        b=GfilYhwKbT4zXaeFk1ZSt4Vg6F0UzJ2fs2VwcfXaohzCpGQKTTJdg8MHgC9r0LiHqM
         lxfhMjHBj32+AQ5l9d2tNrdrSbDHoWIbAKRpe0xco1MuaYBkd9IuxCU3gwTI3zPpp0yi
         xyGMlKZT9ok/Y1jcC7GEqRCIuKg6haTLj+Sf+Ia55rviICc3RePXAk3huBhR3uPBzrH5
         Qf2aFk/hGNXbZWymhi0w9ZCemUbpylhNhwr/SmloeURB+gk0YSOkrtzf5MjKC/g001hy
         VpfZn5JHaP3QVHuxJ/+ponFPsmicLpQ68bzBAodQVOHimo8bjpDm7YI9AdSu3ZeNNUnC
         YpLA==
X-Gm-Message-State: AOAM533UKMMI+CoIRJTXDaIONVYghLIrn1kLp3Q/AMyQ13HdVe055IEB
        T7+B5WIOs31PDXwY0HHeIQKKPuy9R34MtSU9ykbOJuYKpTTpd6mG5OVkIUaJPbNBuumRrGuXxos
        RLflVCSBb9p2eC+v/
X-Received: by 2002:a1c:f207:: with SMTP id s7mr5389858wmc.123.1589995721483;
        Wed, 20 May 2020 10:28:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdqQmGZ2aO26qdiuJUSuzFXSu/aM80BB4X6T8t3UviYthpkjbXR7YQgr68wHHOgGfzdgpIGw==
X-Received: by 2002:a1c:f207:: with SMTP id s7mr5389821wmc.123.1589995720816;
        Wed, 20 May 2020 10:28:40 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id g10sm3452857wrx.4.2020.05.20.10.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:28:40 -0700 (PDT)
Date:   Wed, 20 May 2020 19:28:38 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Benjamin LaHaise <benjamin.lahaise@netronome.com>,
        Tom Herbert <tom@herbertland.com>,
        Liel Shoshan <liels@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>
Subject: [PATCH net-next 1/2] flow_dissector: Parse multiple MPLS Label Stack
 Entries
Message-ID: <1cf89ed887eff6121d344cd1c4e0e23d84c1ac33.1589993550.git.gnault@redhat.com>
References: <cover.1589993550.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1589993550.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current MPLS dissector only parses the first MPLS Label Stack
Entry (second LSE can be parsed too, but only to set a key_id).

This patch adds the possibility to parse several LSEs by making
__skb_flow_dissect_mpls() return FLOW_DISSECT_RET_PROTO_AGAIN as long
as the Bottom Of Stack bit hasn't been seen, up to a maximum of
FLOW_DIS_MPLS_MAX entries.

FLOW_DIS_MPLS_MAX is arbitrarily set to 7. This should be enough for
many practical purposes, without wasting too much space.

To record the parsed values, flow_dissector_key_mpls is modified to
store an array of stack entries, instead of just the values of the
first one. A bit field, "used_lses", is also added to keep track of
the LSEs that have been set. The objective is to avoid defining a
new FLOW_DISSECTOR_KEY_MPLS_XX for each level of the MPLS stack.

TC flower, which is the only user of FLOW_DISSECTOR_KEY_MPLS, is
adapted for the new struct flow_dissector_key_mpls layout. Matching
on several MPLS Label Stack Entries will be added in the next patch.

Finally, the behaviour of the FLOW_DISSECTOR_KEY_MPLS_ENTROPY key is
slightly modified. Instead of recording the first Entropy Label, it
now records the last one. This shouldn't have any consequences since
there doesn't seem to have any user of FLOW_DISSECTOR_KEY_MPLS_ENTROPY
in the tree. We'd probably better do a hash of all parsed MPLS labels
instead (excluding reserved labels) anyway. That'd give better entropy
and would probably also simplify the code. But that's not the purpose
of this patch, so I'm keeping that as a future exercise.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/flow_dissector.h | 14 +++++++++-
 net/core/flow_dissector.c    | 49 ++++++++++++++++++++++-----------
 net/sched/cls_flower.c       | 52 +++++++++++++++++++++++++-----------
 3 files changed, 82 insertions(+), 33 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 628383915827..4fb1a69c6ecf 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -59,13 +59,25 @@ struct flow_dissector_key_vlan {
 	__be16	vlan_tpid;
 };
 
-struct flow_dissector_key_mpls {
+struct flow_dissector_mpls_lse {
 	u32	mpls_ttl:8,
 		mpls_bos:1,
 		mpls_tc:3,
 		mpls_label:20;
 };
 
+#define FLOW_DIS_MPLS_MAX 7
+struct flow_dissector_key_mpls {
+	struct flow_dissector_mpls_lse ls[FLOW_DIS_MPLS_MAX]; /* Label Stack */
+	u8 used_lses; /* One bit set for each Label Stack Entry in use */
+};
+
+static inline void dissector_set_mpls_lse(struct flow_dissector_key_mpls *mpls,
+					  int lse_index)
+{
+	mpls->used_lses |= 1 << lse_index;
+}
+
 #define FLOW_DIS_TUN_OPTS_MAX 255
 /**
  * struct flow_dissector_key_enc_opts:
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3eff84824c8b..214d08aa3439 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -464,47 +464,59 @@ EXPORT_SYMBOL(skb_flow_dissect_tunnel_info);
 static enum flow_dissect_ret
 __skb_flow_dissect_mpls(const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
-			void *target_container, void *data, int nhoff, int hlen)
+			void *target_container, void *data, int nhoff, int hlen,
+			int lse_index, bool *entropy_label)
 {
-	struct flow_dissector_key_keyid *key_keyid;
-	struct mpls_label *hdr, _hdr[2];
-	u32 entry, label;
+	struct mpls_label *hdr, _hdr;
+	u32 entry, label, bos;
 
 	if (!dissector_uses_key(flow_dissector,
 				FLOW_DISSECTOR_KEY_MPLS_ENTROPY) &&
 	    !dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_MPLS))
 		return FLOW_DISSECT_RET_OUT_GOOD;
 
+	if (lse_index >= FLOW_DIS_MPLS_MAX)
+		return FLOW_DISSECT_RET_OUT_GOOD;
+
 	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data,
 				   hlen, &_hdr);
 	if (!hdr)
 		return FLOW_DISSECT_RET_OUT_BAD;
 
-	entry = ntohl(hdr[0].entry);
+	entry = ntohl(hdr->entry);
 	label = (entry & MPLS_LS_LABEL_MASK) >> MPLS_LS_LABEL_SHIFT;
+	bos = (entry & MPLS_LS_S_MASK) >> MPLS_LS_S_SHIFT;
 
 	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_MPLS)) {
 		struct flow_dissector_key_mpls *key_mpls;
+		struct flow_dissector_mpls_lse *lse;
 
 		key_mpls = skb_flow_dissector_target(flow_dissector,
 						     FLOW_DISSECTOR_KEY_MPLS,
 						     target_container);
-		key_mpls->mpls_label = label;
-		key_mpls->mpls_ttl = (entry & MPLS_LS_TTL_MASK)
-					>> MPLS_LS_TTL_SHIFT;
-		key_mpls->mpls_tc = (entry & MPLS_LS_TC_MASK)
-					>> MPLS_LS_TC_SHIFT;
-		key_mpls->mpls_bos = (entry & MPLS_LS_S_MASK)
-					>> MPLS_LS_S_SHIFT;
+		lse = &key_mpls->ls[lse_index];
+
+		lse->mpls_ttl = (entry & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
+		lse->mpls_bos = bos;
+		lse->mpls_tc = (entry & MPLS_LS_TC_MASK) >> MPLS_LS_TC_SHIFT;
+		lse->mpls_label = label;
+		dissector_set_mpls_lse(key_mpls, lse_index);
 	}
 
-	if (label == MPLS_LABEL_ENTROPY) {
+	if (*entropy_label &&
+	    dissector_uses_key(flow_dissector,
+			       FLOW_DISSECTOR_KEY_MPLS_ENTROPY)) {
+		struct flow_dissector_key_keyid *key_keyid;
+
 		key_keyid = skb_flow_dissector_target(flow_dissector,
 						      FLOW_DISSECTOR_KEY_MPLS_ENTROPY,
 						      target_container);
-		key_keyid->keyid = hdr[1].entry & htonl(MPLS_LS_LABEL_MASK);
+		key_keyid->keyid = label;
 	}
-	return FLOW_DISSECT_RET_OUT_GOOD;
+
+	*entropy_label = label == MPLS_LABEL_ENTROPY;
+
+	return bos ? FLOW_DISSECT_RET_OUT_GOOD : FLOW_DISSECT_RET_PROTO_AGAIN;
 }
 
 static enum flow_dissect_ret
@@ -963,6 +975,8 @@ bool __skb_flow_dissect(const struct net *net,
 	struct bpf_prog *attached = NULL;
 	enum flow_dissect_ret fdret;
 	enum flow_dissector_key_id dissector_vlan = FLOW_DISSECTOR_KEY_MAX;
+	bool mpls_el = false;
+	int mpls_lse = 0;
 	int num_hdrs = 0;
 	u8 ip_proto = 0;
 	bool ret;
@@ -1262,7 +1276,10 @@ bool __skb_flow_dissect(const struct net *net,
 	case htons(ETH_P_MPLS_MC):
 		fdret = __skb_flow_dissect_mpls(skb, flow_dissector,
 						target_container, data,
-						nhoff, hlen);
+						nhoff, hlen, mpls_lse,
+						&mpls_el);
+		nhoff += sizeof(struct mpls_label);
+		mpls_lse++;
 		break;
 	case htons(ETH_P_FCOE):
 		if ((hlen - nhoff) < FCOE_HEADER_LEN) {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0c574700da75..f524afe0b7f5 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -781,9 +781,17 @@ static int fl_set_key_mpls(struct nlattr **tb,
 			   struct flow_dissector_key_mpls *key_mask,
 			   struct netlink_ext_ack *extack)
 {
+	struct flow_dissector_mpls_lse *lse_mask;
+	struct flow_dissector_mpls_lse *lse_val;
+
+	lse_val = &key_val->ls[0];
+	lse_mask = &key_mask->ls[0];
+
 	if (tb[TCA_FLOWER_KEY_MPLS_TTL]) {
-		key_val->mpls_ttl = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_TTL]);
-		key_mask->mpls_ttl = MPLS_TTL_MASK;
+		lse_val->mpls_ttl = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_TTL]);
+		lse_mask->mpls_ttl = MPLS_TTL_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
 	}
 	if (tb[TCA_FLOWER_KEY_MPLS_BOS]) {
 		u8 bos = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_BOS]);
@@ -794,8 +802,10 @@ static int fl_set_key_mpls(struct nlattr **tb,
 					    "Bottom Of Stack (BOS) must be 0 or 1");
 			return -EINVAL;
 		}
-		key_val->mpls_bos = bos;
-		key_mask->mpls_bos = MPLS_BOS_MASK;
+		lse_val->mpls_bos = bos;
+		lse_mask->mpls_bos = MPLS_BOS_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
 	}
 	if (tb[TCA_FLOWER_KEY_MPLS_TC]) {
 		u8 tc = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_TC]);
@@ -806,8 +816,10 @@ static int fl_set_key_mpls(struct nlattr **tb,
 					    "Traffic Class (TC) must be between 0 and 7");
 			return -EINVAL;
 		}
-		key_val->mpls_tc = tc;
-		key_mask->mpls_tc = MPLS_TC_MASK;
+		lse_val->mpls_tc = tc;
+		lse_mask->mpls_tc = MPLS_TC_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
 	}
 	if (tb[TCA_FLOWER_KEY_MPLS_LABEL]) {
 		u32 label = nla_get_u32(tb[TCA_FLOWER_KEY_MPLS_LABEL]);
@@ -818,8 +830,10 @@ static int fl_set_key_mpls(struct nlattr **tb,
 					    "Label must be between 0 and 1048575");
 			return -EINVAL;
 		}
-		key_val->mpls_label = label;
-		key_mask->mpls_label = MPLS_LABEL_MASK;
+		lse_val->mpls_label = label;
+		lse_mask->mpls_label = MPLS_LABEL_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
 	}
 	return 0;
 }
@@ -2222,31 +2236,37 @@ static int fl_dump_key_mpls(struct sk_buff *skb,
 			    struct flow_dissector_key_mpls *mpls_key,
 			    struct flow_dissector_key_mpls *mpls_mask)
 {
+	struct flow_dissector_mpls_lse *lse_mask;
+	struct flow_dissector_mpls_lse *lse_key;
 	int err;
 
 	if (!memchr_inv(mpls_mask, 0, sizeof(*mpls_mask)))
 		return 0;
-	if (mpls_mask->mpls_ttl) {
+
+	lse_mask = &mpls_mask->ls[0];
+	lse_key = &mpls_key->ls[0];
+
+	if (lse_mask->mpls_ttl) {
 		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_TTL,
-				 mpls_key->mpls_ttl);
+				 lse_key->mpls_ttl);
 		if (err)
 			return err;
 	}
-	if (mpls_mask->mpls_tc) {
+	if (lse_mask->mpls_tc) {
 		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_TC,
-				 mpls_key->mpls_tc);
+				 lse_key->mpls_tc);
 		if (err)
 			return err;
 	}
-	if (mpls_mask->mpls_label) {
+	if (lse_mask->mpls_label) {
 		err = nla_put_u32(skb, TCA_FLOWER_KEY_MPLS_LABEL,
-				  mpls_key->mpls_label);
+				  lse_key->mpls_label);
 		if (err)
 			return err;
 	}
-	if (mpls_mask->mpls_bos) {
+	if (lse_mask->mpls_bos) {
 		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_BOS,
-				 mpls_key->mpls_bos);
+				 lse_key->mpls_bos);
 		if (err)
 			return err;
 	}
-- 
2.21.1

