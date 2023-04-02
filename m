Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1D6D38AE
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjDBPLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjDBPK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:10:59 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B6CB44E
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:10:56 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so16644718wms.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680448255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDl8nRk0eSQqzPNkJG6z//kwz+gkZtPiAu4STeTYlSE=;
        b=YS1VoH7biuJmHG/hZvZd2LHhiZH8gCeENj03WICyD0cfGNsfO5mQJIsjDDX75zIdzn
         rzQYwqOUvNIk6bK3yxROyKmeCMvuGZon8e4XsvOmlxkid2Nn51kmFp6yyYVoHdTEr3QK
         3OlPX+BC0ljUmj9z9xf3TYROefFzH07g5AEas1zZjEeTlT37SthJHbs30v2HqSz5CITU
         n+iqntNNgsCA7oNgfsX8dFA72Ui6q5aZYvILSKlMs7KK5fz+h500LF2vvPzzLJ6QCqE6
         YdMrbpdvi/JgpTILvTL/MGdMU5n8lIC6+8xY1RS4VkEKJw1HEjgWx2/HxFLxOAE9KgIa
         WJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WDl8nRk0eSQqzPNkJG6z//kwz+gkZtPiAu4STeTYlSE=;
        b=VyJ4M9VPNtGBzqXb53cyEnrwRTGkStBtjNDY2ZiZoLfV+Q66TGBy/rplyJNotQZMnT
         5WKHqequ7k8+21g7kMRcFruYAaZvLWINLxsaoQoOWMzmQTUnbLlH3t2tyQmnGmCfJDjM
         to1mUOlxO4UH8XsV43gQE1BYVK1xy4kYHuf3ZdK7SmGt4VBwZSOBnGoau/sr4Z1EpjVU
         LbSAadBrrbsx61Ic9ZkD2QYaQoEIXugsgBJ1vuJvSpI9j1Ol7bR4R5YzMaJ29wmvUPHd
         Q5C1qy04u7raN+6icRnfnYbPCAMJQxeB9IyfhSggz/rZAlQiFDf7dpJ2ffEOVzxNkdWV
         8cEQ==
X-Gm-Message-State: AO0yUKWAse2jJLoYK0amRSPMEgh+4KBMU3ub/XJgL3v4yy5kfcPvYn60
        P/QGoTWDGozvutnR2ctU64zQMlljRjlHBKSr
X-Google-Smtp-Source: AK7set8pSvx2U2TeoRojYJdJlD1lURZsZH7iDgfRq9q7vfX8fZfH5T+mQAKME2TukTYSiXnBfbeVjA==
X-Received: by 2002:a05:600c:287:b0:3ed:cc22:23db with SMTP id 7-20020a05600c028700b003edcc2223dbmr26109107wmk.3.1680448255353;
        Sun, 02 Apr 2023 08:10:55 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id y5-20020a1c4b05000000b003edd1c44b57sm9307529wma.27.2023.04.02.08.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 08:10:55 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v2 1/2] net: flower: add support for matching cfm fields
Date:   Sun,  2 Apr 2023 17:10:30 +0200
Message-Id: <20230402151031.531534-2-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230402151031.531534-1-zahari.doychev@linux.com>
References: <20230402151031.531534-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
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
 include/net/flow_dissector.h |  21 +++++++
 include/uapi/linux/pkt_cls.h |   9 +++
 net/core/flow_dissector.c    |  29 ++++++++++
 net/sched/cls_flower.c       | 108 ++++++++++++++++++++++++++++++++++-
 4 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 5ccf52ef8809..e1e7e51db88f 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -297,6 +297,26 @@ struct flow_dissector_key_l2tpv3 {
 	__be32 session_id;
 };
 
+/**
+ * struct flow_dissector_key_cfm
+ * @mdl_ver: maintenance domain level(mdl) and cfm protocol version
+ * @opcode: code specifying a type of cfm protocol packet
+ *
+ * See 802.1ag, ITU-T G.8013/Y.1731
+ *         1               2
+ * |7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * | mdl | version |     opcode    |
+ * +-----+---------+-+-+-+-+-+-+-+-+
+ */
+struct flow_dissector_key_cfm {
+	u8	mdl_ver;
+	u8	opcode;
+};
+
+#define FLOW_DIS_CFM_MDL_MASK	 7
+#define FLOW_DIS_CFM_MDL_SHIFT	 5
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -329,6 +349,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
 	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
 	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
+	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
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
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 25fb0bbc310f..7c694e7b9917 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -547,6 +547,29 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
 	return FLOW_DISSECT_RET_OUT_GOOD;
 }
 
+static enum flow_dissect_ret
+__skb_flow_dissect_cfm(const struct sk_buff *skb,
+		       struct flow_dissector *flow_dissector,
+		       void *target_container, const void *data,
+		       int nhoff, int hlen)
+{
+	struct flow_dissector_key_cfm *key, *hdr, _hdr;
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
+		return FLOW_DISSECT_RET_OUT_GOOD;
+
+	hdr = __skb_header_pointer(skb, nhoff, sizeof(*key), data, hlen, &_hdr);
+	if (!hdr)
+		return FLOW_DISSECT_RET_OUT_BAD;
+
+	key = skb_flow_dissector_target(flow_dissector, FLOW_DISSECTOR_KEY_CFM,
+					target_container);
+
+	*key = *hdr;
+
+	return  FLOW_DISSECT_RET_OUT_GOOD;
+}
+
 static enum flow_dissect_ret
 __skb_flow_dissect_gre(const struct sk_buff *skb,
 		       struct flow_dissector_key_control *key_control,
@@ -1390,6 +1413,12 @@ bool __skb_flow_dissect(const struct net *net,
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
index 885c95191ccf..75f3a64f0daa 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -71,6 +71,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_num_of_vlans num_of_vlans;
 	struct flow_dissector_key_pppoe pppoe;
 	struct flow_dissector_key_l2tpv3 l2tpv3;
+	struct flow_dissector_key_cfm cfm;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -711,7 +712,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
-
+	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -760,6 +761,11 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
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
@@ -1644,6 +1650,60 @@ static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
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
+	if (level & ~FLOW_DIS_CFM_MDL_MASK) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[TCA_FLOWER_KEY_CFM_MD_LEVEL],
+				    "cfm md level must be 0-7");
+		return -EINVAL;
+	}
+
+	key->cfm.mdl_ver = level << FLOW_DIS_CFM_MDL_SHIFT;
+	mask->cfm.mdl_ver = FLOW_DIS_CFM_MDL_MASK << FLOW_DIS_CFM_MDL_SHIFT;
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
@@ -1794,6 +1854,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       TCA_FLOWER_KEY_L2TPV3_SID,
 			       &mask->l2tpv3.session_id, TCA_FLOWER_UNSPEC,
 			       sizeof(key->l2tpv3.session_id));
+	} else if (key->basic.n_proto  == htons(ETH_P_CFM)) {
+		ret = fl_set_key_cfm(tb, key, mask, extack);
+		if (ret)
+			return ret;
 	}
 
 	if (key->basic.ip_proto == IPPROTO_TCP ||
@@ -1976,6 +2040,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_L2TPV3, l2tpv3);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CFM, cfm);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -2984,6 +3050,43 @@ static int fl_dump_key_ct(struct sk_buff *skb,
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
+	if (mask->cfm.mdl_ver) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_CFM_MD_LEVEL,
+				 key->cfm.mdl_ver >> FLOW_DIS_CFM_MDL_SHIFT);
+		if (err)
+			goto err_cfm_opts;
+	}
+
+	if (mask->cfm.opcode) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_CFM_OPCODE,
+				 key->cfm.opcode);
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
@@ -3266,6 +3369,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			     sizeof(key->hash.hash)))
 		goto nla_put_failure;
 
+	if (fl_dump_key_cfm(skb, key, mask))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.40.0

