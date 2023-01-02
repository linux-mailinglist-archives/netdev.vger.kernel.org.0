Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B52E65B428
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbjABPYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbjABPYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:24:39 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C90A6434
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:24:38 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bk16so13345654wrb.11
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 07:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=TFCSIYXGzDkc/pebklfJXz0nnuu2Hk0D0HitHUmn/ek=;
        b=XKC7AT6q3C0yz7y1JMAdc4gO5cb1nS3KKokuxQDkOr6mBckwmvl6cOf0zzauopF1Na
         rX4Ls1OWuzswJeJGzTysSFnMON6fjQfpZBI/hT8XTYxUG6JNFOjdPSULW+uGiJmbw0oO
         iqDAPkFGDgq+8Rt8HlP0YWxKBoU9VxjVMMye9uKPgApTR0o4AHtJoyIrXHLmPN4sUJQB
         +i8VEUTSNrLXTEeWuz9xiYnVl+ms2E+kt+8tCs0PZ8/RA+pnNrdeAuxqO0Bdn3VC9y5I
         tE4darLNNDQtBpQkExVNBNM5zjjBaUZoGLRDXKGLXRzHxOuWgVQlGXA7BV9SPH4UGPYe
         hpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFCSIYXGzDkc/pebklfJXz0nnuu2Hk0D0HitHUmn/ek=;
        b=30YUtuVGs4D/rlAs3fEJgI1AEz36MuXtMdnApJ5i0msULFBMnZ6Wsy8tcMZpxcdyzg
         egWaAvpgPzwdhvOiqnirSBn74X0Juplr+khHW3pt03CGY2DPs5h4XRIPmaRf42gB4kIG
         fG0Th/UE+Q4PMUKqfznovqrTMqFmhZ4NEjz64fKNaBJu+kXi06Jy2ew6uO84kahBrXBp
         7GMzmS6clrZAsW8NTStJSaRwxZb/B6kvWDjUFlWx45FME3+EkjD8BMBp1clZ8CivO8hN
         bzieJYAdt79Xrb2HGlCfkfCqPU6nK5yHcaf/D6NPLQT5C7COU+IEpp9wO7Jv1rSWx0OT
         LVTA==
X-Gm-Message-State: AFqh2kr9tb0WUjGweko2YQFamkSwXRG06P94v0OKo+eMP/qFeUenI2Vv
        CmxbbKfM+eYjpc+sMXTmVseJ6TCXGDkKCc+k
X-Google-Smtp-Source: AMrXdXv9VZNi+ZtjpEkaIhmnq4PAocAjMt6VCfi98ObToUVMYQb+LvZwADim2ooX5KLSp6PWsCWz7g==
X-Received: by 2002:a05:6000:383:b0:242:8198:625e with SMTP id u3-20020a056000038300b002428198625emr27651110wrf.63.1672673076631;
        Mon, 02 Jan 2023 07:24:36 -0800 (PST)
Received: from localhost.localdomain (p200300c1c7122500ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c712:2500:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id d14-20020adfa40e000000b0029d9ed7e707sm638322wra.44.2023.01.02.07.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 07:24:36 -0800 (PST)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [RFC PATCH 1/2] net: flower: add support for matching cfm fields
Date:   Mon,  2 Jan 2023 16:24:23 +0100
Message-Id: <20230102152424.889155-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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
 include/net/flow_dissector.h |  11 ++++
 include/uapi/linux/pkt_cls.h |  12 ++++
 net/core/flow_dissector.c    |  41 ++++++++++++
 net/sched/cls_flower.c       | 118 ++++++++++++++++++++++++++++++++++-
 4 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 5ccf52ef8809..a70497f96bed 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -297,6 +297,16 @@ struct flow_dissector_key_l2tpv3 {
 	__be32 session_id;
 };
 
+/**
+ * struct flow_dissector_key_cfm
+ *
+ */
+struct flow_dissector_key_cfm {
+	u8	mdl:3,
+		ver:5;
+	u8	opcode;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -329,6 +339,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
 	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
 	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
+	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 648a82f32666..d55f70ccfe3c 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -594,6 +594,8 @@ enum {
 
 	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
 
+	TCA_FLOWER_KEY_CFM,
+
 	__TCA_FLOWER_MAX,
 };
 
@@ -702,6 +704,16 @@ enum {
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
 };
 
+enum {
+	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
+	TCA_FLOWER_KEY_CFM_MD_LEVEL,
+	TCA_FLOWER_KEY_CFM_OPCODE,
+	__TCA_FLOWER_KEY_CFM_OPT_MAX,
+};
+
+#define TCA_FLOWER_KEY_CFM_OPT_MAX \
+		(__TCA_FLOWER_KEY_CFM_OPT_MAX - 1)
+
 #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
 
 /* Match-all classifier */
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 25fb0bbc310f..adb23d31f199 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -547,6 +547,41 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
 	return FLOW_DISSECT_RET_OUT_GOOD;
 }
 
+static enum flow_dissect_ret
+__skb_flow_dissect_cfm(const struct sk_buff *skb,
+		       struct flow_dissector *flow_dissector,
+		       void *target_container, const void *data,
+		       int nhoff, int hlen)
+{
+	struct flow_dissector_key_cfm *key_cfm;
+	struct cfm_common_hdr {
+		__u8 mdlevel_version;
+		__u8 opcode;
+		__u8 flags;
+		__u8 tlv_offset;
+	} *hdr, _hdr;
+#define CFM_MD_LEVEL_SHIFT	5
+#define CFM_MD_VERSION_MASK	0x1f
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
+		return FLOW_DISSECT_RET_OUT_GOOD;
+
+	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data,
+				   hlen, &_hdr);
+	if (!hdr)
+		return FLOW_DISSECT_RET_OUT_BAD;
+
+	key_cfm = skb_flow_dissector_target(flow_dissector,
+					    FLOW_DISSECTOR_KEY_CFM,
+					    target_container);
+
+	key_cfm->mdl = hdr->mdlevel_version >> CFM_MD_LEVEL_SHIFT;
+	key_cfm->ver = hdr->mdlevel_version & CFM_MD_VERSION_MASK;
+	key_cfm->opcode = hdr->opcode;
+
+	return  FLOW_DISSECT_RET_OUT_GOOD;
+}
+
 static enum flow_dissect_ret
 __skb_flow_dissect_gre(const struct sk_buff *skb,
 		       struct flow_dissector_key_control *key_control,
@@ -1390,6 +1425,12 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 
+	case htons(ETH_P_CFM): {
+		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
+					       target_container, data,
+					       nhoff, hlen);
+		break;
+	}
 	default:
 		fdret = FLOW_DISSECT_RET_OUT_BAD;
 		break;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0b15698b3531..80250945d716 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -71,6 +71,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_num_of_vlans num_of_vlans;
 	struct flow_dissector_key_pppoe pppoe;
 	struct flow_dissector_key_l2tpv3 l2tpv3;
+	struct flow_dissector_key_cfm cfm;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -716,7 +717,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
-
+	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -765,6 +766,12 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
 	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX + 1] = {
+	[TCA_FLOWER_KEY_CFM_MD_LEVEL]		= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_CFM_OPCODE]		= { .type = NLA_U8 },
+};
+
 static void fl_set_key_val(struct nlattr **tb,
 			   void *val, int val_type,
 			   void *mask, int mask_type, int len)
@@ -1649,6 +1656,67 @@ static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
 	return false;
 }
 
+#define CFM_MD_LEVEL_MASK 0x7
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
+	if (level & ~CFM_MD_LEVEL_MASK) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_CFM_MD_LEVEL],
+				    "cfm md level must be 0-7");
+		return -EINVAL;
+	}
+	key->cfm.mdl = level;
+	mask->cfm.mdl = CFM_MD_LEVEL_MASK;
+
+	return 0;
+}
+
+static void fl_set_key_cfm_opcode(struct nlattr **tb,
+				  struct fl_flow_key *key,
+				  struct fl_flow_key *mask,
+				  struct netlink_ext_ack *extack)
+{
+	if (!tb[TCA_FLOWER_KEY_CFM_OPCODE])
+		return;
+
+	fl_set_key_val(tb, &key->cfm.opcode,
+		       TCA_FLOWER_KEY_CFM_OPCODE,
+		       &mask->cfm.opcode,
+		       TCA_FLOWER_UNSPEC,
+		       sizeof(key->cfm.opcode));
+}
+
+static int fl_set_key_cfm(struct nlattr **tb,
+			  struct fl_flow_key *key,
+			  struct fl_flow_key *mask,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *nla_cfm_opt[TCA_FLOWER_KEY_CFM_OPT_MAX + 1];
+	int err;
+
+	if (!tb[TCA_FLOWER_KEY_CFM])
+		return 0;
+
+	err = nla_parse_nested(nla_cfm_opt, TCA_FLOWER_KEY_CFM_OPT_MAX,
+			       tb[TCA_FLOWER_KEY_CFM],
+			       cfm_opt_policy, extack);
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
@@ -1799,6 +1867,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       TCA_FLOWER_KEY_L2TPV3_SID,
 			       &mask->l2tpv3.session_id, TCA_FLOWER_UNSPEC,
 			       sizeof(key->l2tpv3.session_id));
+	} else if (key->basic.n_proto  == htons(ETH_P_CFM)) {
+		ret = fl_set_key_cfm(tb, key, mask, extack);
+		if (ret)
+			return ret;
 	}
 
 	if (key->basic.ip_proto == IPPROTO_TCP ||
@@ -1981,6 +2053,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_L2TPV3, l2tpv3);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CFM, cfm);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -2989,6 +3063,45 @@ static int fl_dump_key_ct(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int fl_dump_key_cfm(struct sk_buff *skb,
+			   struct fl_flow_key *key,
+			   struct fl_flow_key *mask)
+{
+	struct nlattr *opts;
+	int err;
+
+	if (!memchr_inv(&mask->cfm, 0, sizeof(mask->cfm)))
+		return 0;
+
+	opts = nla_nest_start(skb, TCA_FLOWER_KEY_CFM);
+	if (!opts)
+		return -EMSGSIZE;
+
+	if (mask->cfm.mdl &&
+	    nla_put_u8(skb,
+		       TCA_FLOWER_KEY_CFM_MD_LEVEL,
+		       key->cfm.mdl)) {
+		err = -EMSGSIZE;
+		goto err_cfm_opts;
+	}
+
+	if (mask->cfm.opcode &&
+	    nla_put_u8(skb,
+		       TCA_FLOWER_KEY_CFM_OPCODE,
+		       key->cfm.opcode)) {
+		err = -EMSGSIZE;
+		goto err_cfm_opts;
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
@@ -3271,6 +3384,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			     sizeof(key->hash.hash)))
 		goto nla_put_failure;
 
+	if (fl_dump_key_cfm(skb, key, mask))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.39.0

