Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094336EE97C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbjDYVQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236351AbjDYVQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:16:47 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9FB358D
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-94f32588c13so918684166b.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1682457403; x=1685049403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VirsPSEZeycASmNTLhjYY2AENwlx9shah11zHv/e8Dc=;
        b=clJIl3c6tSGJ2spQhlZ6NnRCSgVS8YEByryP0fdXRb9FsUOAy7fTAJ9GuD+93s8u6b
         1a8aS1mc5N+J55H8K9i81IHhIwdoxnLXHQWlB7LANSN8UBz43tHh5abAC2UG4cs/dAAz
         2heQ7uMZtvr+hZbBJGPYPtrA43159K+5R4Udc9iL7+HqsfuL/0WhmPsOj1FckkmToou1
         eoGUrA2Nx8zMlPn2pCdG61PalbRg+wkP1BnEjUW50B/0/k2JUE5YhgI48hJjesBgpOHG
         vDiBUrHjljILO6IY4VNB0Np2Qyq5XkApiFN2eEXGZft/XFo7fnlbmyaHakDaYY24BP4p
         Q/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682457403; x=1685049403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VirsPSEZeycASmNTLhjYY2AENwlx9shah11zHv/e8Dc=;
        b=IIl9hlSUkc91Y0p3Fjtm1KQSjKBRRbIzRC05aUM2DIVYT+jcGTExXyH27CIgibU85Y
         lFv8eh7mXCeFVMdCsJ4T63679O/XkzZk96u7/vCsveVybQmtphZ9PXYkRnqUC9kG6zjc
         VQSjBi1zE/0g0i709HJh95Lrm2hHM3R1MIA6sDDMwc6IjJW48ZWFCFLBLKDcXn/0iwg4
         Lslt6119FPKQxyiS3ty1Dv1F10UE5pt/LAnYQcX8tPwGdHwj5iiUurGPdf/e9ruXPd4s
         N+IhQryqdgOC/7tGKoBZSBkX68k4hT33FEccVo+fRT/rMDI4XTpIbE97zpqGydRkYYM8
         UqNQ==
X-Gm-Message-State: AAQBX9dLsJiviKkaZR8RBPkcy63QBAmRJJj3RY/IHFu6fG4wC/8jJ9Rn
        gih4FpcLZda0g22kRmZmevhZEcr8i4TJQw==
X-Google-Smtp-Source: AKy350ZqgGjCIu562O8S57eEEsveYuwAD0p20u2BTIioZvl28n17eeC/3WDcGJonjVq/u/mKQgdf9w==
X-Received: by 2002:a17:906:3c0f:b0:94a:99a4:58df with SMTP id h15-20020a1709063c0f00b0094a99a458dfmr16341163ejg.25.1682457403303;
        Tue, 25 Apr 2023 14:16:43 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bv7-20020a170907934700b00959c6cb82basm2302896ejc.105.2023.04.25.14.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 14:16:43 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        idosch@idosch.org, Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v4 2/3] net: flower: add support for matching cfm fields
Date:   Tue, 25 Apr 2023 23:16:29 +0200
Message-Id: <20230425211630.698373-3-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425211630.698373-1-zahari.doychev@linux.com>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/uapi/linux/pkt_cls.h |   9 +++
 net/sched/cls_flower.c       | 103 ++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 1 deletion(-)

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
index cc49256d5318..5d77da484a88 100644
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
+	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8, 7),
+	[TCA_FLOWER_KEY_CFM_OPCODE]	= { .type = NLA_U8 },
+};
+
 static void fl_set_key_val(struct nlattr **tb,
 			   void *val, int val_type,
 			   void *mask, int mask_type, int len)
@@ -1653,6 +1660,54 @@ static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
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
@@ -1803,6 +1858,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       TCA_FLOWER_KEY_L2TPV3_SID,
 			       &mask->l2tpv3.session_id, TCA_FLOWER_UNSPEC,
 			       sizeof(key->l2tpv3.session_id));
+	} else if (key->basic.n_proto  == htons(ETH_P_CFM)) {
+		ret = fl_set_key_cfm(tb, key, mask, extack);
+		if (ret)
+			return ret;
 	}
 
 	if (key->basic.ip_proto == IPPROTO_TCP ||
@@ -1985,6 +2044,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_L2TPV3, l2tpv3);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CFM, cfm);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3004,6 +3065,43 @@ static int fl_dump_key_ct(struct sk_buff *skb,
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
@@ -3286,6 +3384,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			     sizeof(key->hash.hash)))
 		goto nla_put_failure;
 
+	if (fl_dump_key_cfm(skb, &key->cfm, &mask->cfm))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.40.0

