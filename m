Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D5104FFB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfKUKEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:04:12 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42580 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfKUKEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:04:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id q17so1329961pgt.9
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=vpLT+Nu5r+46CMXGzADtgrs6I06sXxq/4GDvXL0YszM=;
        b=Ma9eFKsp+PQtbXr4dsUT8o0nZS43Vc5NxD4xpyrVN2u8xtPBwdQANC5E1TMze5WXAL
         o11q+TKf9mObz7tdKJ4ciwi/uXnZdj8wUw0CjxoWNJbKwAKH4zANzCvocb4D/7dFH/zH
         aMD9OhILmeTKjEujKe0RgUMW62WG8hQsGStnAtYxODF/klVRciHSdBbMqIca2FLukHrf
         nzncjK5iTOj1hBiyTYj9iHneq7ULGERWoOu/Bdxh2CIgmJqvpZJXW+0cFHdyWEEhf4is
         BDIgwxubbyKGU5+2rwtPOzWBzGaq+SlJqCgthhodSIAxwSNa4rBVY/vTR3Eyvx/9tm/O
         quHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=vpLT+Nu5r+46CMXGzADtgrs6I06sXxq/4GDvXL0YszM=;
        b=p1icDhczHeZXgUySpqqqwmFqBY10wuJjUotW5DIapNp4Gw+U16USAEKULX6lfajxz7
         AeoNPpK+w+30KLoPOK6qPJpAXxnh3gKQxtRrh3CiIsD6OhVPBwUN8aZud5T11TLVUvYA
         WbyCPopUbQ2sgNwY9XJFfzCvwjvR0RpjjteePlPyAzlQXwei21Zu2BTe6pECmjFt55T3
         PLPFtNdLfQbZ2dR2D5jLSmSjah6OljgwIsTRaE0GKdp2QqMqW11B3MbhinFOJSSJGvmz
         uAaRFeFukYIepSgPadKw99ycsK3ZRqG0xEqL6EIt1AN4LH1n87Trcsaj2OHRyNhbz5w9
         0hPw==
X-Gm-Message-State: APjAAAWr294ebN5NMghZtM7y6GRq3p0WQx6yShqBqyRxfYeJNCKJ9Do0
        y4EjelSgzrynU44cmtSQ2LflEx71
X-Google-Smtp-Source: APXvYqxitMNP4GxdKx6XkLYaGQMs5bQVXJBPbN4/oFZ7huCa/Psmt3F8NnLBfXTkdFek2qVLME2BpA==
X-Received: by 2002:a63:a452:: with SMTP id c18mr8542648pgp.188.1574330651181;
        Thu, 21 Nov 2019 02:04:11 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y36sm2355566pgk.66.2019.11.21.02.04.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:04:10 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCHv2 net-next 4/4] net: sched: allow flower to match erspan options
Date:   Thu, 21 Nov 2019 18:03:29 +0800
Message-Id: <8de7d353bec58c875fb5d9b325589ea600ae6d49.1574330535.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <41dcd3e6be804fabe1ad22ddf7461fd63b26f284.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
 <a67eb8fbc6f2244cd8ae67747ebc4dd42d0516d0.1574330535.git.lucien.xin@gmail.com>
 <82fd552a95b82c06cc3c700a9c444086cd74b89e.1574330535.git.lucien.xin@gmail.com>
 <41dcd3e6be804fabe1ad22ddf7461fd63b26f284.1574330535.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
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

v1->v2:
  - improve some err msgs of extack.

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
index abc7380..c307ee1 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -23,6 +23,7 @@
 #include <net/flow_dissector.h>
 #include <net/geneve.h>
 #include <net/vxlan.h>
+#include <net/erspan.h>
 
 #include <net/dst.h>
 #include <net/dst_metadata.h>
@@ -693,6 +694,7 @@ enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
 		.strict_start_type = TCA_FLOWER_KEY_ENC_OPTS_VXLAN },
 	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -708,6 +710,14 @@ vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
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
@@ -972,6 +982,70 @@ static int fl_set_vxlan_opt(const struct nlattr *nla, struct fl_flow_key *key,
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
+		NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option ver");
+		return -EINVAL;
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER])
+		md->version = nla_get_u8(tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]);
+
+	if (md->version == 1) {
+		if (!option_len && !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option index");
+			return -EINVAL;
+		}
+		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX];
+			md->u.index = nla_get_be32(nla);
+		}
+	} else if (md->version == 2) {
+		if (!option_len && (!tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR] ||
+				    !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID])) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option dir or hwid");
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
+		NL_SET_ERR_MSG(extack, "Tunnel key erspan option ver is incorrect");
+		return -EINVAL;
+	}
+
+	return sizeof(*md);
+}
+
 static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			  struct fl_flow_key *mask,
 			  struct netlink_ext_ack *extack)
@@ -1068,6 +1142,39 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			if (msk_depth)
 				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
+		case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
+			if (key->enc_opts.dst_opt_type) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for erspan options");
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
@@ -2239,6 +2346,39 @@ static int fl_dump_key_vxlan_opt(struct sk_buff *skb,
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
@@ -2297,6 +2437,11 @@ static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
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

