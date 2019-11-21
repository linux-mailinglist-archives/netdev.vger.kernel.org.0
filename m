Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F08104FFA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfKUKEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:04:05 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41933 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfKUKEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:04:04 -0500
Received: by mail-pg1-f194.google.com with SMTP id 207so1335171pge.8
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mEu7jjB2PKuXdRy+rAbE74ZeeCgeP5e/Z8DDETk3sKE=;
        b=Mreevu//YcTm6TAxum3KzozokCioRbIyH0rOPZNIas4FJ7pvFtszWKiJkDmeZDvemQ
         8sJID0IXC8rVXeMdLbBkKBBItIhHwkIS97thG4yqQVUjMFlakItzOGo7f1bFcrgfsREd
         r1N0RQch8Y4U21mev/WEEtB9ahwXQf9u9ef+I02sVoGZis3Oh2kD54QvDOCAu1mjKrrW
         2uWhGs/JGf1o/4kXCTYTKOv1GDk4CCrntj0EH1grV+bspE3RqBfmZj0c8Mx0GCQ+QYNl
         pJQjUvuDea7lOt18GIrGV3keO+jvIh0+xl5kYUvXWlHfI42SbaqlRTJT+JDxgRyLfVTY
         L8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=mEu7jjB2PKuXdRy+rAbE74ZeeCgeP5e/Z8DDETk3sKE=;
        b=r9vYBxmG3uJ14ZvBdsunPn0P9mPxWvIDWWU6r7EBeTLx2FLcIsPeC8PoBYzE0LjpMk
         WYHhEMpf6vbBJaIzIzkMU0ULr2xbPthG3mO3kHw6k1IpaAasRVzf6azoiFk5tzoIDeto
         RiXWwlQNqH6juDZgD+mBDSX12OA0tOzy3Q0wB9n7KI1e2245ISGC99kXHXuMre70vB1m
         33+Zo4/5T0bKzK2hrXMs3YnLymMDp/UXS0c30ydz9p4w9N1njG6S/4rjEV1UkCEexhRq
         jsPw6QyeuZrHMXwNKe6JBEofjhTdhZzLxnyfnRTbYA11GuWaprtyRfcUanC3kaEWPylu
         ZC7Q==
X-Gm-Message-State: APjAAAXXd1Bk1mnGkUuXKGop25Ji7Y9wMbVRnKNU35YIjkzt/k+hMgNx
        3zhbw+0r8rtxCp7B6X1L8PyH2ez/
X-Google-Smtp-Source: APXvYqzwrTH0jaDW4aDM1kbGKy07EINCYAoIHUA9VSE3ofuMkEpwEd+IKCX8RFFjQUsf7QI+QSDYqw==
X-Received: by 2002:a62:6884:: with SMTP id d126mr9359652pfc.109.1574330642872;
        Thu, 21 Nov 2019 02:04:02 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y6sm2750932pfm.12.2019.11.21.02.04.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:04:02 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCHv2 net-next 3/4] net: sched: allow flower to match vxlan options
Date:   Thu, 21 Nov 2019 18:03:28 +0800
Message-Id: <41dcd3e6be804fabe1ad22ddf7461fd63b26f284.1574330535.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <82fd552a95b82c06cc3c700a9c444086cd74b89e.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
 <a67eb8fbc6f2244cd8ae67747ebc4dd42d0516d0.1574330535.git.lucien.xin@gmail.com>
 <82fd552a95b82c06cc3c700a9c444086cd74b89e.1574330535.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to allow matching gbp option in vxlan.

The options can be described in the form GBP/GBP_MASK,
where GBP is represented as a 32bit hexadecimal value.
Different from geneve, only one option can be set. And
also, geneve options and vxlan options can't be set at
the same time.

  # ip link add name vxlan0 type vxlan dstport 0 external
  # tc qdisc add dev vxlan0 ingress
  # tc filter add dev vxlan0 protocol ip parent ffff: \
      flower \
        enc_src_ip 10.0.99.192 \
        enc_dst_ip 10.0.99.193 \
        enc_key_id 11 \
        vxlan_opts 01020304/ffffffff \
        ip_proto udp \
        action mirred egress redirect dev eth0

v1->v2:
  - add .strict_start_type for enc_opts_policy as Jakub noticed.
  - use Duplicate instead of Wrong in err msg for extack as Jakub
    suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/pkt_cls.h |  13 ++++++
 net/sched/cls_flower.c       | 109 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index c6ad22f..929825d 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -571,6 +571,10 @@ enum {
 					 * TCA_FLOWER_KEY_ENC_OPT_GENEVE_
 					 * attributes
 					 */
+	TCA_FLOWER_KEY_ENC_OPTS_VXLAN,	/* Nested
+					 * TCA_FLOWER_KEY_ENC_OPT_VXLAN_
+					 * attributes
+					 */
 	__TCA_FLOWER_KEY_ENC_OPTS_MAX,
 };
 
@@ -589,6 +593,15 @@ enum {
 		(__TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX - 1)
 
 enum {
+	TCA_FLOWER_KEY_ENC_OPT_VXLAN_UNSPEC,
+	TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP,		/* u32 */
+	__TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX,
+};
+
+#define TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX \
+		(__TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX - 1)
+
+enum {
 	TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT = (1 << 0),
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
 };
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 74221e3..abc7380 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -22,6 +22,7 @@
 #include <net/ip.h>
 #include <net/flow_dissector.h>
 #include <net/geneve.h>
+#include <net/vxlan.h>
 
 #include <net/dst.h>
 #include <net/dst_metadata.h>
@@ -688,7 +689,10 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 
 static const struct nla_policy
 enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPTS_UNSPEC]        = {
+		.strict_start_type = TCA_FLOWER_KEY_ENC_OPTS_VXLAN },
 	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -699,6 +703,11 @@ geneve_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX + 1] = {
 						       .len = 128 },
 };
 
+static const struct nla_policy
+vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
+};
+
 static void fl_set_key_val(struct nlattr **tb,
 			   void *val, int val_type,
 			   void *mask, int mask_type, int len)
@@ -928,6 +937,41 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
 	return sizeof(struct geneve_opt) + data_len;
 }
 
+static int fl_set_vxlan_opt(const struct nlattr *nla, struct fl_flow_key *key,
+			    int depth, int option_len,
+			    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1];
+	struct vxlan_metadata *md;
+	int err;
+
+	md = (struct vxlan_metadata *)&key->enc_opts.data[key->enc_opts.len];
+	memset(md, 0xff, sizeof(*md));
+
+	if (!depth)
+		return sizeof(*md);
+
+	if (nla_type(nla) != TCA_FLOWER_KEY_ENC_OPTS_VXLAN) {
+		NL_SET_ERR_MSG(extack, "Non-vxlan option type for mask");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX, nla,
+			       vxlan_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!option_len && !tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]) {
+		NL_SET_ERR_MSG(extack, "Missing tunnel key vxlan option gbp");
+		return -EINVAL;
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP])
+		md->gbp = nla_get_u32(tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]);
+
+	return sizeof(*md);
+}
+
 static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			  struct fl_flow_key *mask,
 			  struct netlink_ext_ack *extack)
@@ -958,6 +1002,11 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			  nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS]), key_depth) {
 		switch (nla_type(nla_opt_key)) {
 		case TCA_FLOWER_KEY_ENC_OPTS_GENEVE:
+			if (key->enc_opts.dst_opt_type &&
+			    key->enc_opts.dst_opt_type != TUNNEL_GENEVE_OPT) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for geneve options");
+				return -EINVAL;
+			}
 			option_len = 0;
 			key->enc_opts.dst_opt_type = TUNNEL_GENEVE_OPT;
 			option_len = fl_set_geneve_opt(nla_opt_key, key,
@@ -986,6 +1035,39 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			if (msk_depth)
 				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
+		case TCA_FLOWER_KEY_ENC_OPTS_VXLAN:
+			if (key->enc_opts.dst_opt_type) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for vxlan options");
+				return -EINVAL;
+			}
+			option_len = 0;
+			key->enc_opts.dst_opt_type = TUNNEL_VXLAN_OPT;
+			option_len = fl_set_vxlan_opt(nla_opt_key, key,
+						      key_depth, option_len,
+						      extack);
+			if (option_len < 0)
+				return option_len;
+
+			key->enc_opts.len += option_len;
+			/* At the same time we need to parse through the mask
+			 * in order to verify exact and mask attribute lengths.
+			 */
+			mask->enc_opts.dst_opt_type = TUNNEL_VXLAN_OPT;
+			option_len = fl_set_vxlan_opt(nla_opt_msk, mask,
+						      msk_depth, option_len,
+						      extack);
+			if (option_len < 0)
+				return option_len;
+
+			mask->enc_opts.len += option_len;
+			if (key->enc_opts.len != mask->enc_opts.len) {
+				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
+				return -EINVAL;
+			}
+
+			if (msk_depth)
+				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
+			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
 			return -EINVAL;
@@ -2135,6 +2217,28 @@ static int fl_dump_key_geneve_opt(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int fl_dump_key_vxlan_opt(struct sk_buff *skb,
+				 struct flow_dissector_key_enc_opts *enc_opts)
+{
+	struct vxlan_metadata *md;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, TCA_FLOWER_KEY_ENC_OPTS_VXLAN);
+	if (!nest)
+		goto nla_put_failure;
+
+	md = (struct vxlan_metadata *)&enc_opts->data[0];
+	if (nla_put_u32(skb, TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP, md->gbp))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int fl_dump_key_ct(struct sk_buff *skb,
 			  struct flow_dissector_key_ct *key,
 			  struct flow_dissector_key_ct *mask)
@@ -2188,6 +2292,11 @@ static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
 		if (err)
 			goto nla_put_failure;
 		break;
+	case TUNNEL_VXLAN_OPT:
+		err = fl_dump_key_vxlan_opt(skb, enc_opts);
+		if (err)
+			goto nla_put_failure;
+		break;
 	default:
 		goto nla_put_failure;
 	}
-- 
2.1.0

