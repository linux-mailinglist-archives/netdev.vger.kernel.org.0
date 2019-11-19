Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F7E102094
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfKSJcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:32:33 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40665 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfKSJcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:32:33 -0500
Received: by mail-pg1-f196.google.com with SMTP id e17so3714431pgd.7
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=2fqqU8j37cZJ1rSuvUIFmZLwY/Hk+5dmq/P8W3EdOPI=;
        b=s9hHHZQKiAMU4LGKwpxkp59wPgLH9yT5ZbEus+QmCiVk7ql1S2QUK9Mu4SQD07TzQ7
         lFeEo2rblyV0BeE2L0Dzy1QvenIQgoE2/ckapLKcTMcjlLUeKM3sZd45bs3jyGUPM4r9
         aovWwO77Cn+GtNdq8jvfnWs5YkGPJFwBNiXaawyWFBOZtXqNuD81Q6yRxqe2k1av04bx
         YkHfyGLUdnrrFir9ZNU1ZF6Ug87R6obxGDK5pw90rJl85T9x77j+ivLVm8zD+TuKfpip
         /KbdHx73Mr6FV1liIX5lt/XRx7JQE+akOV32KeQCQHV38KaofDUgVQi2TVXwAIvgaHSa
         9EYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=2fqqU8j37cZJ1rSuvUIFmZLwY/Hk+5dmq/P8W3EdOPI=;
        b=AmqJ4hOqKCb6cVxzdbsIDgGmSy5AthvE5WXwTxatLA3r7mWvFh2L7RMQM4ul+urH2U
         4mtmvjsootgzMSmntCHjbYRvCQaCuZSkUy6uVd9h0cyKDihFpsWw2xXaO3piqbWEGJ5y
         MGbp5ISiC28HldeA9XIB3zpIJ1O7cu2LOwBJUMCwHUkv+SKmmQ2zfFjMInhr6NhGWY+E
         d5Mrjd/0FcOFIIYsAQN/kfo3/uWubwmJqrPoDJKggZlYEeWMQU4+RHg+h4rmZtTkzCyI
         o4p84pNzB1t6YhJR+ytijNDWdS9MM+VU73umJNPv/emNOWPrtr3BXIShGkXug2w04/5y
         eQqA==
X-Gm-Message-State: APjAAAXMeJM1ei+46N74nYwScnL0Sm7ExsZ9/0VxNizgh4l/Dt8trggQ
        DlS9Su7ipd9fTT1TIv1GY3MLAaEv
X-Google-Smtp-Source: APXvYqxmfF+mncSPtmjrk8FFGZDW3Q9E4G63a6Qhp1anNM16XvO/X72tBQKdq1z0CqZXt8RSdc2nlw==
X-Received: by 2002:a63:8a44:: with SMTP id y65mr1198532pgd.20.1574155951613;
        Tue, 19 Nov 2019 01:32:31 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b24sm22409017pgk.93.2019.11.19.01.32.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 01:32:30 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com
Subject: [PATCH net-next 4/4] net: sched: allow flower to match erspan options
Date:   Tue, 19 Nov 2019 17:31:49 +0800
Message-Id: <c67e92a927f02672bbe28649aab139e61c0029ec.1574155869.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <9daf090729d21b39dd17b71665136644bcfa04c5.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
 <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
 <a84fb50a28d9a931e641924962eb05e8cfca12bf.1574155869.git.lucien.xin@gmail.com>
 <9daf090729d21b39dd17b71665136644bcfa04c5.1574155869.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to allow matching options in erspan.

The options can be described in the form:
VER:INDEX:DIR:HWID/VER:INDEX_MASK:DIR_MASK:HWID_MASK.
When ver is set to 1, index will be applied while dir
and hwid will be ignored, and when ver is set to 2,
dir and hwid will be used while index will be ignored.

Different from geneve, only one option can be set. And
also, geneve options, vxlan options or erspan options
can't be set at the same time.

  # ip link add name erspan1 type erspan external
  # tc qdisc add dev erspan1 ingress
  # tc filter add dev erspan1 protocol ip parent ffff: \
      flower \
        enc_src_ip 10.0.99.192 \
        enc_dst_ip 10.0.99.193 \
        enc_key_id 11 \
        erspan_opts 1:12:0:0/1:ffff:0:0 \
        ip_proto udp \
        action mirred egress redirect dev eth0

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/pkt_cls.h |  16 +++++
 net/sched/cls_flower.c       | 145 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 929825d..449a639 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -575,6 +575,10 @@ enum {
 					 * TCA_FLOWER_KEY_ENC_OPT_VXLAN_
 					 * attributes
 					 */
+	TCA_FLOWER_KEY_ENC_OPTS_ERSPAN,	/* Nested
+					 * TCA_FLOWER_KEY_ENC_OPT_ERSPAN_
+					 * attributes
+					 */
 	__TCA_FLOWER_KEY_ENC_OPTS_MAX,
 };
 
@@ -602,6 +606,18 @@ enum {
 		(__TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX - 1)
 
 enum {
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_UNSPEC,
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER,              /* u8 */
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX,            /* be32 */
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR,              /* u8 */
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID,             /* u8 */
+	__TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX,
+};
+
+#define TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX \
+		(__TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX - 1)
+
+enum {
 	TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT = (1 << 0),
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
 };
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 80b0c8f0..23e5ef1 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -23,6 +23,7 @@
 #include <net/flow_dissector.h>
 #include <net/geneve.h>
 #include <net/vxlan.h>
+#include <net/erspan.h>
 
 #include <net/dst.h>
 #include <net/dst_metadata.h>
@@ -691,6 +692,7 @@ static const struct nla_policy
 enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -706,6 +708,14 @@ vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]        = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]      = { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]        = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
+};
+
 static void fl_set_key_val(struct nlattr **tb,
 			   void *val, int val_type,
 			   void *mask, int mask_type, int len)
@@ -970,6 +980,70 @@ static int fl_set_vxlan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 	return sizeof(*md);
 }
 
+static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
+			     int depth, int option_len,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	struct erspan_metadata *md;
+	int err;
+
+	md = (struct erspan_metadata *)&key->enc_opts.data[key->enc_opts.len];
+	memset(md, 0xff, sizeof(*md));
+	md->version = 1;
+
+	if (!depth)
+		return sizeof(*md);
+
+	if (nla_type(nla) != TCA_FLOWER_KEY_ENC_OPTS_ERSPAN) {
+		NL_SET_ERR_MSG(extack, "Non-erspan option type for mask");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX, nla,
+			       erspan_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!option_len && !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]) {
+		NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option");
+		return -EINVAL;
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER])
+		md->version = nla_get_u8(tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]);
+
+	if (md->version == 1) {
+		if (!option_len && !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option");
+			return -EINVAL;
+		}
+		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX];
+			md->u.index = nla_get_be32(nla);
+		}
+	} else if (md->version == 2) {
+		if (!option_len && (!tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR] ||
+				    !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID])) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option");
+			return -EINVAL;
+		}
+		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]) {
+			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR];
+			md->u.md2.dir = nla_get_u8(nla);
+		}
+		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]) {
+			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID];
+			set_hwid(&md->u.md2, nla_get_u8(nla));
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "erspan ver is not correct");
+		return -EINVAL;
+	}
+
+	return sizeof(*md);
+}
+
 static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			  struct fl_flow_key *mask,
 			  struct netlink_ext_ack *extack)
@@ -1066,6 +1140,39 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			if (msk_depth)
 				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
+		case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
+			if (key->enc_opts.dst_opt_type) {
+				NL_SET_ERR_MSG(extack, "Wrong type for erspan options");
+				return -EINVAL;
+			}
+			option_len = 0;
+			key->enc_opts.dst_opt_type = TUNNEL_ERSPAN_OPT;
+			option_len = fl_set_erspan_opt(nla_opt_key, key,
+						       key_depth, option_len,
+						       extack);
+			if (option_len < 0)
+				return option_len;
+
+			key->enc_opts.len += option_len;
+			/* At the same time we need to parse through the mask
+			 * in order to verify exact and mask attribute lengths.
+			 */
+			mask->enc_opts.dst_opt_type = TUNNEL_ERSPAN_OPT;
+			option_len = fl_set_erspan_opt(nla_opt_msk, mask,
+						       msk_depth, option_len,
+						       extack);
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
@@ -2237,6 +2344,39 @@ static int fl_dump_key_vxlan_opt(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int fl_dump_key_erspan_opt(struct sk_buff *skb,
+				  struct flow_dissector_key_enc_opts *enc_opts)
+{
+	struct erspan_metadata *md;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, TCA_FLOWER_KEY_ENC_OPTS_ERSPAN);
+	if (!nest)
+		goto nla_put_failure;
+
+	md = (struct erspan_metadata *)&enc_opts->data[0];
+	if (nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER, md->version))
+		goto nla_put_failure;
+
+	if (md->version == 1 &&
+	    nla_put_be32(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX, md->u.index))
+		goto nla_put_failure;
+
+	if (md->version == 2 &&
+	    (nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR,
+			md->u.md2.dir) ||
+	     nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID,
+			get_hwid(&md->u.md2))))
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
@@ -2295,6 +2435,11 @@ static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
 		if (err)
 			goto nla_put_failure;
 		break;
+	case TUNNEL_ERSPAN_OPT:
+		err = fl_dump_key_erspan_opt(skb, enc_opts);
+		if (err)
+			goto nla_put_failure;
+		break;
 	default:
 		goto nla_put_failure;
 	}
-- 
2.1.0

