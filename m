Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284C56E53E9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjDQVc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjDQVcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:32:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811925272
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:52 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dx24so23916266ejb.11
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1681767170; x=1684359170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I7UpKVaFBfq5Rg4wLX5/+hvj8XbVayo9/OxCuE/1q/4=;
        b=YVkOw7IFgHhccZczhyGGcIxzvrgC8F67pUJzHD1ddEKlCsIsUtv0L+fDAwd2lQ5JQT
         zbpRO0dAYujC1HlMYnpY4kzjduAE2yI6kcqQPGVubpSjQWGExP3/Hv1ZSEKnBA9dirvF
         cWc1EL2sBDqOrLPNYGQa3Q49CqQw4lnpYvSHAVlK1EnrCPSJw669A5XjabQcfyXfueaI
         3L2c6jhVbb2CwSvpb6RLT+hNtbNWOOcGMZZ2eQUDUEPZYhwwgGKOGngO8/HFY8Zh0cMe
         8RFESE6V5vVx4HMdDAbY2CnuQmnfylUAP14qOyLH2Wlm+k9+Cfw9FIODhmUnCTaH+6gl
         Ll5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681767170; x=1684359170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I7UpKVaFBfq5Rg4wLX5/+hvj8XbVayo9/OxCuE/1q/4=;
        b=ULbvDpGIS0g5HDxOOtjV9Hk3ytnAIFQp8GHqnn1JWNct+abplbb2tKxjYQfwB87+FF
         SgIbkMtn9QOv8uCMm19SjfjmnKpzg+u1/n6fgiwQBaCLaQ8EOgTQOAa/kI2xGqkzh8oW
         ZlkG/K1XaLpvQieRloyxsmEIti51R790U+PrPuFhyn/sUA/Ld+N/ITvWzVoNTE3Npo4W
         xNY4rq8tIksQiF58pVoXhuw4BV1g+hU2mTqh5H8466890rsjCligInWA11yTiEICcTGM
         +ajzismf6PutSX3lMvmIHvm+WUOo6FNztRg0DOY0ZD14EZc99sJxw3Wyw5oUiz3ArcGn
         MLdA==
X-Gm-Message-State: AAQBX9fXUTY9oROT8uVCUTCEIyG8Bij9Zfai6CzpTRCKBx52TI0ai3bu
        su6yIuGr0+9vzdNcttBbjSOskfarT+S+Xth1
X-Google-Smtp-Source: AKy350Zf5h02NU5KF2Hp9nPBYAQBGlP5Gc0BExy8lvZ5ODb522SVy/X/pvMyqhR+uUoBCmo2AqDmVQ==
X-Received: by 2002:a17:906:28cc:b0:94b:769f:3ba3 with SMTP id p12-20020a17090628cc00b0094b769f3ba3mr8886878ejd.8.1681767170510;
        Mon, 17 Apr 2023 14:32:50 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id k18-20020a17090632d200b0094f05fee9d3sm4670005ejk.211.2023.04.17.14.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 14:32:50 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v3 2/3] net: flower: add support for matching cfm fields
Date:   Mon, 17 Apr 2023 23:32:32 +0200
Message-Id: <20230417213233.525380-3-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417213233.525380-1-zahari.doychev@linux.com>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zdoychev@maxlinear.com>

Add support to the tc flower classifier to match based on fields in CFM
information elements like level and opcode.

tc filter add dev ens6 ingress protocol 802.1q \
	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
	action drop

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
---
 include/uapi/linux/pkt_cls.h |   9 +++
 net/sched/cls_flower.c       | 109 ++++++++++++++++++++++++++++++++++-
 2 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 648a82f32666..8e3f809c9a03 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -594,6 +594,8 @@ enum {
 
 	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
 
+	TCA_FLOWER_KEY_CFM,	/* nested */
+
 	__TCA_FLOWER_MAX,
 };
 
@@ -702,6 +704,13 @@ enum {
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
index cc49256d5318..4962d6c90d0f 100644
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
@@ -720,7 +722,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
-
+	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -769,6 +771,11 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
 	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
 };
 
+static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
+	[TCA_FLOWER_KEY_CFM_MD_LEVEL]		= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_CFM_OPCODE]		= { .type = NLA_U8 },
+};
+
 static void fl_set_key_val(struct nlattr **tb,
 			   void *val, int val_type,
 			   void *mask, int mask_type, int len)
@@ -1653,6 +1660,60 @@ static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
 	return false;
 }
 
+static int fl_set_key_cfm_md_level(struct nlattr **tb,
+				   struct fl_flow_key *key,
+				   struct fl_flow_key *mask,
+				   struct netlink_ext_ack *extack)
+{
+	u8 level;
+
+	if (!tb[TCA_FLOWER_KEY_CFM_MD_LEVEL])
+		return 0;
+
+	level = nla_get_u8(tb[TCA_FLOWER_KEY_CFM_MD_LEVEL]);
+	if (level & ~FIELD_MAX(FLOW_DIS_CFM_MDL_MASK)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[TCA_FLOWER_KEY_CFM_MD_LEVEL],
+				    "cfm md level must be in [0, 7]");
+		return -EINVAL;
+	}
+
+	key->cfm.mdl_ver = FIELD_PREP(FLOW_DIS_CFM_MDL_MASK, level);
+	mask->cfm.mdl_ver = FLOW_DIS_CFM_MDL_MASK;
+
+	return 0;
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
+
+	return fl_set_key_cfm_md_level(nla_cfm_opt, key, mask, extack);
+}
+
 static int fl_set_key(struct net *net, struct nlattr **tb,
 		      struct fl_flow_key *key, struct fl_flow_key *mask,
 		      struct netlink_ext_ack *extack)
@@ -1803,6 +1864,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       TCA_FLOWER_KEY_L2TPV3_SID,
 			       &mask->l2tpv3.session_id, TCA_FLOWER_UNSPEC,
 			       sizeof(key->l2tpv3.session_id));
+	} else if (key->basic.n_proto  == htons(ETH_P_CFM)) {
+		ret = fl_set_key_cfm(tb, key, mask, extack);
+		if (ret)
+			return ret;
 	}
 
 	if (key->basic.ip_proto == IPPROTO_TCP ||
@@ -1985,6 +2050,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_L2TPV3, l2tpv3);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CFM, cfm);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3004,6 +3071,43 @@ static int fl_dump_key_ct(struct sk_buff *skb,
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
+	if (!memchr_inv(mask, 0, sizeof(mask)))
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
@@ -3286,6 +3390,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			     sizeof(key->hash.hash)))
 		goto nla_put_failure;
 
+	if (fl_dump_key_cfm(skb, &key->cfm, &mask->cfm))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.40.0

