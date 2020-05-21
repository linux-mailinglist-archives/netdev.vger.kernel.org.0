Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7E41DD4BD
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgEURr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55444 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727966AbgEURr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590083246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VnfhpW8OB7JqBEZaQ1liw5mEsNfq4Ge00tLMJnFV6xE=;
        b=YOPBwYK11stTklBsYrOtqJZx22zjmiNPDXOVFGAIaLQrGl9Om7HUlvQfWgl+ERwUraQeEw
        L7kh/RWfrbya/sVtao0MuTcSI4tUM44zcUIF6t1kJl0r4h9r5lYzjQsOhRk6Cgo9cWDTDS
        8CV3xZAWE6wMS1DB8SqWus8vOvT5RGo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-xybcun-vMX6IPkp0riOX-Q-1; Thu, 21 May 2020 13:47:22 -0400
X-MC-Unique: xybcun-vMX6IPkp0riOX-Q-1
Received: by mail-wm1-f72.google.com with SMTP id t62so2945691wmt.7
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 10:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VnfhpW8OB7JqBEZaQ1liw5mEsNfq4Ge00tLMJnFV6xE=;
        b=KRS5GKJ7DgAwh8jdc4oEkrHpoLdIVB0rAVoVHMTgkFawGG4pHaPMZlk5exLopaD9U0
         +/G9dMjtY7sGX2mWMtHWkIJONtZZpyUQN4kRhwyxpZUynKkLnvHI2T30LnHy8ueUqO5G
         Gnw+/b6dYwvhsUHCia/24oTWwOgfR7XKYvdr93ntSdCLLDA78BFsQIXMnFtYKcLRHLUg
         7j9phcJvp9kQ+Yj656hbwGs6+k7R+piAJfjeqgAsdnFV8N+jQu16iDMnx2KUXSTCMJ1R
         jU8XXFKOZVD9R3S9wIU99Y80c3n5yFiLKnXvS6iebcMfWhdgKw5NicODNN++mz8E1XkK
         TANg==
X-Gm-Message-State: AOAM530dCJ9VK6bx519JiPYvEp8x/bii3WN3/XttEI0bjB+oHsqYJOmd
        ti1iJnQhJbl/r6d/MG0QdVoC3TWBAvXI/T27XDOzT8g5jNkx1qOsRN35X25unZPQlsNvPb24iNM
        9Gj+ucrBmfQ7BHf//
X-Received: by 2002:a5d:5686:: with SMTP id f6mr9548098wrv.168.1590083241013;
        Thu, 21 May 2020 10:47:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoEIh96jTMFfkjnGR1nQz+7wc22yrIfCZaMv+e5RRdyxAEonAuJ9WMLzqJ+HVHFoNibjiCHQ==
X-Received: by 2002:a5d:5686:: with SMTP id f6mr9548080wrv.168.1590083240665;
        Thu, 21 May 2020 10:47:20 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id b18sm7072274wrn.82.2020.05.21.10.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 10:47:20 -0700 (PDT)
Date:   Thu, 21 May 2020 19:47:18 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Benjamin LaHaise <benjamin.lahaise@netronome.com>,
        Tom Herbert <tom@herbertland.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Liel Shoshan <liels@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>
Subject: [PATCH net-next v2 2/2] cls_flower: Support filtering on multiple
 MPLS Label Stack Entries
Message-ID: <e110d749b34b9d8d2ad9ab80ad05c19d90bf57c5.1590081480.git.gnault@redhat.com>
References: <cover.1590081480.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1590081480.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With struct flow_dissector_key_mpls now recording the first
FLOW_DIS_MPLS_MAX labels, we can extend Flower to filter on any of
these LSEs independently.

In order to avoid creating new netlink attributes for every possible
depth, let's define a new TCA_FLOWER_KEY_MPLS_OPTS nested attribute
that contains the list of LSEs to match. Each LSE is represented by
another attribute, TCA_FLOWER_KEY_MPLS_OPTS_LSE, which then contains
the attributes representing the depth and the MPLS fields to match at
this depth (label, TTL, etc.).

For each MPLS field, the mask is always set to all-ones, as this is
what the original API did. We could allow user configurable masks in
the future if there is demand for more flexibility.

The new API also allows to only specify an LSE depth. In that case,
Flower only verifies that the MPLS label stack depth is greater or
equal to the provided depth (that is, an LSE exists at this depth).

Filters that only match on one (or more) fields of the first LSE are
dumped using the old netlink attributes, to avoid confusing user space
programs that don't understand the new API.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/uapi/linux/pkt_cls.h |  23 ++++
 net/sched/cls_flower.c       | 243 ++++++++++++++++++++++++++++++++++-
 2 files changed, 265 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index fc672b232437..7576209d96f9 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -576,6 +576,8 @@ enum {
 	TCA_FLOWER_KEY_CT_LABELS,	/* u128 */
 	TCA_FLOWER_KEY_CT_LABELS_MASK,	/* u128 */
 
+	TCA_FLOWER_KEY_MPLS_OPTS,
+
 	__TCA_FLOWER_MAX,
 };
 
@@ -640,6 +642,27 @@ enum {
 #define TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX \
 		(__TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX - 1)
 
+enum {
+	TCA_FLOWER_KEY_MPLS_OPTS_UNSPEC,
+	TCA_FLOWER_KEY_MPLS_OPTS_LSE,
+	__TCA_FLOWER_KEY_MPLS_OPTS_MAX,
+};
+
+#define TCA_FLOWER_KEY_MPLS_OPTS_MAX (__TCA_FLOWER_KEY_MPLS_OPTS_MAX - 1)
+
+enum {
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_UNSPEC,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_TC,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
+	__TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX,
+};
+
+#define TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX \
+		(__TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX - 1)
+
 enum {
 	TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT = (1 << 0),
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f524afe0b7f5..96f5999281e0 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -668,6 +668,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_MPLS_BOS]	= { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_MPLS_TC]	= { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_MPLS_LABEL]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_MPLS_OPTS]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_TCP_FLAGS]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_TCP_FLAGS_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_IP_TOS]		= { .type = NLA_U8 },
@@ -726,6 +727,20 @@ erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
 };
 
+static const struct nla_policy
+mpls_opts_policy[TCA_FLOWER_KEY_MPLS_OPTS_MAX + 1] = {
+	[TCA_FLOWER_KEY_MPLS_OPTS_LSE]    = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]      = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]      = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]       = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
+};
+
 static void fl_set_key_val(struct nlattr **tb,
 			   void *val, int val_type,
 			   void *mask, int mask_type, int len)
@@ -776,6 +791,126 @@ static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 	return 0;
 }
 
+static int fl_set_key_mpls_lse(const struct nlattr *nla_lse,
+			       struct flow_dissector_key_mpls *key_val,
+			       struct flow_dissector_key_mpls *key_mask,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1];
+	struct flow_dissector_mpls_lse *lse_mask;
+	struct flow_dissector_mpls_lse *lse_val;
+	u8 lse_index;
+	u8 depth;
+	int err;
+
+	err = nla_parse_nested(tb, TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX, nla_lse,
+			       mpls_stack_entry_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]) {
+		NL_SET_ERR_MSG(extack, "Missing MPLS option \"depth\"");
+		return -EINVAL;
+	}
+
+	depth = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]);
+
+	/* LSE depth starts at 1, for consistency with terminology used by
+	 * RFC 3031 (section 3.9), where depth 0 refers to unlabeled packets.
+	 */
+	if (depth < 1 || depth > FLOW_DIS_MPLS_MAX) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH],
+				    "Invalid MPLS depth");
+		return -EINVAL;
+	}
+	lse_index = depth - 1;
+
+	dissector_set_mpls_lse(key_val, lse_index);
+	dissector_set_mpls_lse(key_mask, lse_index);
+
+	lse_val = &key_val->ls[lse_index];
+	lse_mask = &key_mask->ls[lse_index];
+
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]) {
+		lse_val->mpls_ttl = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]);
+		lse_mask->mpls_ttl = MPLS_TTL_MASK;
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]) {
+		u8 bos = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]);
+
+		if (bos & ~MPLS_BOS_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS],
+					    "Bottom Of Stack (BOS) must be 0 or 1");
+			return -EINVAL;
+		}
+		lse_val->mpls_bos = bos;
+		lse_mask->mpls_bos = MPLS_BOS_MASK;
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]) {
+		u8 tc = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]);
+
+		if (tc & ~MPLS_TC_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC],
+					    "Traffic Class (TC) must be between 0 and 7");
+			return -EINVAL;
+		}
+		lse_val->mpls_tc = tc;
+		lse_mask->mpls_tc = MPLS_TC_MASK;
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]) {
+		u32 label = nla_get_u32(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]);
+
+		if (label & ~MPLS_LABEL_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL],
+					    "Label must be between 0 and 1048575");
+			return -EINVAL;
+		}
+		lse_val->mpls_label = label;
+		lse_mask->mpls_label = MPLS_LABEL_MASK;
+	}
+
+	return 0;
+}
+
+static int fl_set_key_mpls_opts(const struct nlattr *nla_mpls_opts,
+				struct flow_dissector_key_mpls *key_val,
+				struct flow_dissector_key_mpls *key_mask,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *nla_lse;
+	int rem;
+	int err;
+
+	if (!(nla_mpls_opts->nla_type & NLA_F_NESTED)) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_mpls_opts,
+				    "NLA_F_NESTED is missing");
+		return -EINVAL;
+	}
+
+	nla_for_each_nested(nla_lse, nla_mpls_opts, rem) {
+		if (nla_type(nla_lse) != TCA_FLOWER_KEY_MPLS_OPTS_LSE) {
+			NL_SET_ERR_MSG_ATTR(extack, nla_lse,
+					    "Invalid MPLS option type");
+			return -EINVAL;
+		}
+
+		err = fl_set_key_mpls_lse(nla_lse, key_val, key_mask, extack);
+		if (err < 0)
+			return err;
+	}
+	if (rem) {
+		NL_SET_ERR_MSG(extack,
+			       "Bytes leftover after parsing MPLS options");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int fl_set_key_mpls(struct nlattr **tb,
 			   struct flow_dissector_key_mpls *key_val,
 			   struct flow_dissector_key_mpls *key_mask,
@@ -784,6 +919,21 @@ static int fl_set_key_mpls(struct nlattr **tb,
 	struct flow_dissector_mpls_lse *lse_mask;
 	struct flow_dissector_mpls_lse *lse_val;
 
+	if (tb[TCA_FLOWER_KEY_MPLS_OPTS]) {
+		if (tb[TCA_FLOWER_KEY_MPLS_TTL] ||
+		    tb[TCA_FLOWER_KEY_MPLS_BOS] ||
+		    tb[TCA_FLOWER_KEY_MPLS_TC] ||
+		    tb[TCA_FLOWER_KEY_MPLS_LABEL]) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPTS],
+					    "MPLS label, Traffic Class, Bottom Of Stack and Time To Live must be encapsulated in the MPLS options attribute");
+			return -EBADMSG;
+		}
+
+		return fl_set_key_mpls_opts(tb[TCA_FLOWER_KEY_MPLS_OPTS],
+					    key_val, key_mask, extack);
+	}
+
 	lse_val = &key_val->ls[0];
 	lse_mask = &key_mask->ls[0];
 
@@ -2232,6 +2382,89 @@ static int fl_dump_key_port_range(struct sk_buff *skb, struct fl_flow_key *key,
 	return 0;
 }
 
+static int fl_dump_key_mpls_opt_lse(struct sk_buff *skb,
+				    struct flow_dissector_key_mpls *mpls_key,
+				    struct flow_dissector_key_mpls *mpls_mask,
+				    u8 lse_index)
+{
+	struct flow_dissector_mpls_lse *lse_mask = &mpls_mask->ls[lse_index];
+	struct flow_dissector_mpls_lse *lse_key = &mpls_key->ls[lse_index];
+	int err;
+
+	err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH,
+			 lse_index + 1);
+	if (err)
+		return err;
+
+	if (lse_mask->mpls_ttl) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL,
+				 lse_key->mpls_ttl);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_bos) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS,
+				 lse_key->mpls_bos);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_tc) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_TC,
+				 lse_key->mpls_tc);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_label) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
+				 lse_key->mpls_label);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int fl_dump_key_mpls_opts(struct sk_buff *skb,
+				 struct flow_dissector_key_mpls *mpls_key,
+				 struct flow_dissector_key_mpls *mpls_mask)
+{
+	struct nlattr *opts;
+	struct nlattr *lse;
+	u8 lse_index;
+	int err;
+
+	opts = nla_nest_start(skb, TCA_FLOWER_KEY_MPLS_OPTS);
+	if (!opts)
+		return -EMSGSIZE;
+
+	for (lse_index = 0; lse_index < FLOW_DIS_MPLS_MAX; lse_index++) {
+		if (!(mpls_mask->used_lses & 1 << lse_index))
+			continue;
+
+		lse = nla_nest_start(skb, TCA_FLOWER_KEY_MPLS_OPTS_LSE);
+		if (!lse) {
+			err = -EMSGSIZE;
+			goto err_opts;
+		}
+
+		err = fl_dump_key_mpls_opt_lse(skb, mpls_key, mpls_mask,
+					       lse_index);
+		if (err)
+			goto err_opts_lse;
+		nla_nest_end(skb, lse);
+	}
+	nla_nest_end(skb, opts);
+
+	return 0;
+
+err_opts_lse:
+	nla_nest_cancel(skb, lse);
+err_opts:
+	nla_nest_cancel(skb, opts);
+
+	return err;
+}
+
 static int fl_dump_key_mpls(struct sk_buff *skb,
 			    struct flow_dissector_key_mpls *mpls_key,
 			    struct flow_dissector_key_mpls *mpls_mask)
@@ -2240,12 +2473,20 @@ static int fl_dump_key_mpls(struct sk_buff *skb,
 	struct flow_dissector_mpls_lse *lse_key;
 	int err;
 
-	if (!memchr_inv(mpls_mask, 0, sizeof(*mpls_mask)))
+	if (!mpls_mask->used_lses)
 		return 0;
 
 	lse_mask = &mpls_mask->ls[0];
 	lse_key = &mpls_key->ls[0];
 
+	/* For backward compatibility, don't use the MPLS nested attributes if
+	 * the rule can be expressed using the old attributes.
+	 */
+	if (mpls_mask->used_lses & ~1 ||
+	    (!lse_mask->mpls_ttl && !lse_mask->mpls_bos &&
+	     !lse_mask->mpls_tc && !lse_mask->mpls_label))
+		return fl_dump_key_mpls_opts(skb, mpls_key, mpls_mask);
+
 	if (lse_mask->mpls_ttl) {
 		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_TTL,
 				 lse_key->mpls_ttl);
-- 
2.21.1

