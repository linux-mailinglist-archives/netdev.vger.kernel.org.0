Return-Path: <netdev+bounces-9195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E23727D5B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D29BA1C21009
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B9810972;
	Thu,  8 Jun 2023 10:57:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F9910958
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:57:05 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A1C269A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:57:02 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-514ab6cb529so3213782a12.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 03:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686221821; x=1688813821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Liq2bqxq+TmXGwqj/8IY7MuHOwvnUJwqSsRqrT/Wdp0=;
        b=d37uGpOlGXHFsBufuG+p4CZV2falJ/ndFROD5ZtG4XocsaYg4Ve0X2ljAnJfyGgRmL
         qSNYpEzQzmR6aECqgEzI/iN3KAXUISXunvUIrqmGAGKZu0cGsNItEGMDLG7Vv04z8ImH
         X3g2fUPNzIjAa9NoRHgSClXv7tmP8qZeEV5t8LnNNbl/E6MOVrXvJsbv09wrQVnDlT0N
         BDgz8KWmNFHK4mq4zH3BzKoBpmZlRPhG4ztBuB41/yD+aRJhIISHQLuusW3dV9pHmBZ0
         y8DhqzYUIlK7qZVc0Kx+BngWCn6FRJdrJkwEDnuNOGTotxjKPGfHL4FqqXXmtgzlKsT3
         0epg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686221821; x=1688813821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Liq2bqxq+TmXGwqj/8IY7MuHOwvnUJwqSsRqrT/Wdp0=;
        b=WBMWobj31B3juQgEEgCUItYQvwAm4mtQtXrlUdEXToCeO6zFNw+LWWJS+3rhPFY2yY
         WzmcB+uLX9fXLzJt9KUovuBMZRob0AlmGmK1q0yTy9CmS1/H6Yn9f3D0Q7R3zEXXaTBj
         ZWqmuHNgidAj/SjWL9VABqQ+wiF/LmSURsYCykHJzBZd6DviGEKiUEkdpMWdO6/kr37A
         K6PY5SSEJvZZZWW7mZAQRvGT3iA/Hh5YdyY/GUI7dlRIqpCxIp/Yh2rnjhQz9bK/B6N7
         a8WDVcpVfgxKJSwR88DywlWM+gzyvLEtNRpk4XLWh25geqGEu0leJOgC6q5QwJFwRIEb
         Q6bA==
X-Gm-Message-State: AC+VfDzsEbcDkc6q6Ls190m2jc3YAErSFJhq51a/Ed2z+roZSW+vnMoC
	rqlUQMNtCjWRd6VPjBYUqP1c6eCazuQuWQ==
X-Google-Smtp-Source: ACHHUZ6NlwoALestYSBBw8kE6xhT2tAgKQJbdNhLKJwPEQukiHpEAZgmthL01tf1sjWeesZqu58WMQ==
X-Received: by 2002:a17:907:2d2b:b0:977:cc28:d974 with SMTP id gs43-20020a1709072d2b00b00977cc28d974mr2012922ejc.14.1686221820714;
        Thu, 08 Jun 2023 03:57:00 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id t23-20020a1709064f1700b0094f07545d40sm522719eju.220.2023.06.08.03.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 03:57:00 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From: Zahari Doychev <zahari.doychev@linux.com>
To: netdev@vger.kernel.org
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com,
	simon.horman@corigine.com,
	idosch@idosch.org,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v7 2/3] net: flower: add support for matching cfm fields
Date: Thu,  8 Jun 2023 12:56:47 +0200
Message-ID: <20230608105648.266575-3-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230608105648.266575-1-zahari.doychev@linux.com>
References: <20230608105648.266575-1-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Zahari Doychev <zdoychev@maxlinear.com>

Add support to the tc flower classifier to match based on fields in CFM
information elements like level and opcode.

tc filter add dev ens6 ingress protocol 802.1q \
	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
	action drop

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/uapi/linux/pkt_cls.h |   9 ++++
 net/sched/cls_flower.c       | 102 +++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 00933dda7b10..7865f5a9885b 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -596,6 +596,8 @@ enum {
 
 	TCA_FLOWER_L2_MISS,		/* u8 */
 
+	TCA_FLOWER_KEY_CFM,		/* nested */
+
 	__TCA_FLOWER_MAX,
 };
 
@@ -704,6 +706,13 @@ enum {
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
 };
 
+enum {
+	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
+	TCA_FLOWER_KEY_CFM_MD_LEVEL,
+	TCA_FLOWER_KEY_CFM_OPCODE,
+	TCA_FLOWER_KEY_CFM_OPT_MAX,
+};
+
 #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
 
 /* Match-all classifier */
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index e02ecabbb75c..56065cc5a661 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -11,6 +11,7 @@
 #include <linux/rhashtable.h>
 #include <linux/workqueue.h>
 #include <linux/refcount.h>
+#include <linux/bitfield.h>
 
 #include <linux/if_ether.h>
 #include <linux/in6.h>
@@ -71,6 +72,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_num_of_vlans num_of_vlans;
 	struct flow_dissector_key_pppoe pppoe;
 	struct flow_dissector_key_l2tpv3 l2tpv3;
+	struct flow_dissector_key_cfm cfm;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -725,6 +727,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
 	[TCA_FLOWER_L2_MISS]		= NLA_POLICY_MAX(NLA_U8, 1),
+	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -773,6 +776,12 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
 	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
 };
 
+static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
+	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8,
+						FLOW_DIS_CFM_MDL_MAX),
+	[TCA_FLOWER_KEY_CFM_OPCODE]	= { .type = NLA_U8 },
+};
+
 static void fl_set_key_val(struct nlattr **tb,
 			   void *val, int val_type,
 			   void *mask, int mask_type, int len)
@@ -1660,6 +1669,53 @@ static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
 	return false;
 }
 
+static void fl_set_key_cfm_md_level(struct nlattr **tb,
+				    struct fl_flow_key *key,
+				    struct fl_flow_key *mask,
+				    struct netlink_ext_ack *extack)
+{
+	u8 level;
+
+	if (!tb[TCA_FLOWER_KEY_CFM_MD_LEVEL])
+		return;
+
+	level = nla_get_u8(tb[TCA_FLOWER_KEY_CFM_MD_LEVEL]);
+	key->cfm.mdl_ver = FIELD_PREP(FLOW_DIS_CFM_MDL_MASK, level);
+	mask->cfm.mdl_ver = FLOW_DIS_CFM_MDL_MASK;
+}
+
+static void fl_set_key_cfm_opcode(struct nlattr **tb,
+				  struct fl_flow_key *key,
+				  struct fl_flow_key *mask,
+				  struct netlink_ext_ack *extack)
+{
+	fl_set_key_val(tb, &key->cfm.opcode, TCA_FLOWER_KEY_CFM_OPCODE,
+		       &mask->cfm.opcode, TCA_FLOWER_UNSPEC,
+		       sizeof(key->cfm.opcode));
+}
+
+static int fl_set_key_cfm(struct nlattr **tb,
+			  struct fl_flow_key *key,
+			  struct fl_flow_key *mask,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *nla_cfm_opt[TCA_FLOWER_KEY_CFM_OPT_MAX];
+	int err;
+
+	if (!tb[TCA_FLOWER_KEY_CFM])
+		return 0;
+
+	err = nla_parse_nested(nla_cfm_opt, TCA_FLOWER_KEY_CFM_OPT_MAX,
+			       tb[TCA_FLOWER_KEY_CFM], cfm_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	fl_set_key_cfm_opcode(nla_cfm_opt, key, mask, extack);
+	fl_set_key_cfm_md_level(nla_cfm_opt, key, mask, extack);
+
+	return 0;
+}
+
 static int fl_set_key(struct net *net, struct nlattr **tb,
 		      struct fl_flow_key *key, struct fl_flow_key *mask,
 		      struct netlink_ext_ack *extack)
@@ -1814,6 +1870,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       TCA_FLOWER_KEY_L2TPV3_SID,
 			       &mask->l2tpv3.session_id, TCA_FLOWER_UNSPEC,
 			       sizeof(key->l2tpv3.session_id));
+	} else if (key->basic.n_proto  == htons(ETH_P_CFM)) {
+		ret = fl_set_key_cfm(tb, key, mask, extack);
+		if (ret)
+			return ret;
 	}
 
 	if (key->basic.ip_proto == IPPROTO_TCP ||
@@ -1996,6 +2056,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_L2TPV3, l2tpv3);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CFM, cfm);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3029,6 +3091,43 @@ static int fl_dump_key_ct(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int fl_dump_key_cfm(struct sk_buff *skb,
+			   struct flow_dissector_key_cfm *key,
+			   struct flow_dissector_key_cfm *mask)
+{
+	struct nlattr *opts;
+	int err;
+	u8 mdl;
+
+	if (!memchr_inv(mask, 0, sizeof(*mask)))
+		return 0;
+
+	opts = nla_nest_start(skb, TCA_FLOWER_KEY_CFM);
+	if (!opts)
+		return -EMSGSIZE;
+
+	if (FIELD_GET(FLOW_DIS_CFM_MDL_MASK, mask->mdl_ver)) {
+		mdl = FIELD_GET(FLOW_DIS_CFM_MDL_MASK, key->mdl_ver);
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_CFM_MD_LEVEL, mdl);
+		if (err)
+			goto err_cfm_opts;
+	}
+
+	if (mask->opcode) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_CFM_OPCODE, key->opcode);
+		if (err)
+			goto err_cfm_opts;
+	}
+
+	nla_nest_end(skb, opts);
+
+	return 0;
+
+err_cfm_opts:
+	nla_nest_cancel(skb, opts);
+	return err;
+}
+
 static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
 			       struct flow_dissector_key_enc_opts *enc_opts)
 {
@@ -3316,6 +3415,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			     sizeof(key->hash.hash)))
 		goto nla_put_failure;
 
+	if (fl_dump_key_cfm(skb, &key->cfm, &mask->cfm))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.41.0


