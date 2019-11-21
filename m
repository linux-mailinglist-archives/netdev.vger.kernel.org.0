Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4828104FF8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKUKD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:03:58 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43881 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfKUKD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:03:57 -0500
Received: by mail-pl1-f196.google.com with SMTP id a18so1328140plm.10
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=4f3S2iP2dvBR0tjKD6jw83p2/B2Buvy/DUYbZAqyF9Q=;
        b=qnBm8JcKfMa7Qd1HjovefpndYUBVVq5OfB2Vcna9lT/pla9R7qC0lCmiqDnw0elQru
         lr6LiEISWHESYfcQuiNQ7EVv6S32yBbhakartI3fPI5x3PT7YLkMsjfWkuwgxZgNgn92
         LJAIixCBoQU+CCbkJUGCQjzHxguDeL3JC+1dEUBeuKYaf/puqqWUCH9bMTK4AbXIjbQp
         VT0IRHryEGtQBF5FV02zv0xSnxKZLNuYD+YULeWYoZt5Are0uaIRYaOBc02JrgRftFrG
         8sriGaC6/dYZXwPCIKlCwzaVcjUG7x9Hb1+kzqYlAyecVfH80exA9CEspmXBPNqJVT+K
         kNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=4f3S2iP2dvBR0tjKD6jw83p2/B2Buvy/DUYbZAqyF9Q=;
        b=YsC1s62v3vcKy2DKyAalEyOoGIwRkbDE0aF87vLBu+iki8KtWLI1tOpO8qJbLOI8HQ
         Sp5aJ6NfjLqFI+2yd++YouDrNmrWiNMof0L2ay2az4L57inNfAX6OKtYJLqKxeRPPyJO
         roO1Qo2J0CeHUWIQlHtmCb9CxtjNslRz4q5mNPKnRW2hGdOjyEWxF8r7UDcpYH2XKgQ5
         KYrvgNOcolzZy5BefKqj43SJA+bsBTBQSgJTyOg/n3wL6zzrtJ/JswFDFFaM5uTZbQKC
         IjDP3lMbnmyX1670L+dWr4riXgF8gN4JlAuAANsJMIW3S7oaZYaaekrZ/HgU9rJS8aJu
         UFNQ==
X-Gm-Message-State: APjAAAXGLLliUmUgmxbWaIm3rAmhrWziCPXuTnyAf9sMBESTmkPC8YOU
        IntdIp0MJs0sR3gu75lujlVxtq6O
X-Google-Smtp-Source: APXvYqzuqg/uge54J32dqXVUvu2AzlE8K2iNIgFeeZmH7SB1x84pTVUKe0isr3LTEBG6VGzQsE+Oww==
X-Received: by 2002:a17:902:760b:: with SMTP id k11mr7730935pll.126.1574330634459;
        Thu, 21 Nov 2019 02:03:54 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d38sm2328123pgd.59.2019.11.21.02.03.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:03:53 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCHv2 net-next 2/4] net: sched: add erspan option support to act_tunnel_key
Date:   Thu, 21 Nov 2019 18:03:27 +0800
Message-Id: <82fd552a95b82c06cc3c700a9c444086cd74b89e.1574330535.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a67eb8fbc6f2244cd8ae67747ebc4dd42d0516d0.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
 <a67eb8fbc6f2244cd8ae67747ebc4dd42d0516d0.1574330535.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to allow setting erspan options using the
act_tunnel_key action. Different from geneve options,
only one option can be set. And also, geneve options,
vxlan options or erspan options can't be set at the
same time.

Options are expressed as ver:index:dir:hwid, when ver
is set to 1, index will be applied while dir and hwid
will be ignored, and when ver is set to 2, dir and
hwid will be used while index will be ignored.

  # ip link add name erspan1 type erspan external
  # tc qdisc add dev eth0 ingress
  # tc filter add dev eth0 protocol ip parent ffff: \
           flower indev eth0 \
              ip_proto udp \
              action tunnel_key \
                  set src_ip 10.0.99.192 \
                  dst_ip 10.0.99.193 \
                  dst_port 6081 \
                  id 11 \
  		erspan_opts 1:2:0:0 \
          action mirred egress redirect dev erspan1

v1->v2:
  - do the validation when dst is not yet allocated as Jakub suggested.
  - use Duplicate instead of Wrong in err msg for extack.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h |  16 ++++
 net/sched/act_tunnel_key.c                | 118 ++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+)

diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index f302c2a..3f10dc4 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -54,6 +54,10 @@ enum {
 						 * TCA_TUNNEL_KEY_ENC_OPTS_
 						 * attributes
 						 */
+	TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN,		/* Nested
+						 * TCA_TUNNEL_KEY_ENC_OPTS_
+						 * attributes
+						 */
 	__TCA_TUNNEL_KEY_ENC_OPTS_MAX,
 };
 
@@ -80,4 +84,16 @@ enum {
 #define TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX \
 	(__TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX - 1)
 
+enum {
+	TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_UNSPEC,
+	TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER,		/* u8 */
+	TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX,		/* be32 */
+	TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR,		/* u8 */
+	TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID,		/* u8 */
+	__TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX,
+};
+
+#define TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX \
+	(__TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX - 1)
+
 #endif
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index ff0909b..30b5825 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -11,6 +11,7 @@
 #include <linux/rtnetlink.h>
 #include <net/geneve.h>
 #include <net/vxlan.h>
+#include <net/erspan.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/dst.h>
@@ -58,6 +59,7 @@ enc_opts_policy[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1] = {
 		.strict_start_type = TCA_TUNNEL_KEY_ENC_OPTS_VXLAN },
 	[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]	= { .type = NLA_NESTED },
 	[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]		= { .type = NLA_NESTED },
+	[TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -73,6 +75,14 @@ vxlan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1] = {
 	[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]	   = { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+erspan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
+	[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER]	   = { .type = NLA_U8 },
+	[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX]	   = { .type = NLA_U32 },
+	[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR]	   = { .type = NLA_U8 },
+	[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID]	   = { .type = NLA_U8 },
+};
+
 static int
 tunnel_key_copy_geneve_opt(const struct nlattr *nla, void *dst, int dst_len,
 			   struct netlink_ext_ack *extack)
@@ -151,6 +161,59 @@ tunnel_key_copy_vxlan_opt(const struct nlattr *nla, void *dst, int dst_len,
 	return sizeof(struct vxlan_metadata);
 }
 
+static int
+tunnel_key_copy_erspan_opt(const struct nlattr *nla, void *dst, int dst_len,
+			   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	int err;
+	u8 ver;
+
+	err = nla_parse_nested(tb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX, nla,
+			       erspan_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER]) {
+		NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option ver");
+		return -EINVAL;
+	}
+
+	ver = nla_get_u8(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER]);
+	if (ver == 1) {
+		if (!tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option index");
+			return -EINVAL;
+		}
+	} else if (ver == 2) {
+		if (!tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR] ||
+		    !tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID]) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option dir or hwid");
+			return -EINVAL;
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Tunnel key erspan option ver is incorrect");
+		return -EINVAL;
+	}
+
+	if (dst) {
+		struct erspan_metadata *md = dst;
+
+		md->version = ver;
+		if (ver == 1) {
+			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX];
+			md->u.index = nla_get_be32(nla);
+		} else {
+			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR];
+			md->u.md2.dir = nla_get_u8(nla);
+			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID];
+			set_hwid(&md->u.md2, nla_get_u8(nla));
+		}
+	}
+
+	return sizeof(struct erspan_metadata);
+}
+
 static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 				int dst_len, struct netlink_ext_ack *extack)
 {
@@ -192,6 +255,18 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 			opts_len += opt_len;
 			type = TUNNEL_VXLAN_OPT;
 			break;
+		case TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN:
+			if (type) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for erspan options");
+				return -EINVAL;
+			}
+			opt_len = tunnel_key_copy_erspan_opt(attr, dst,
+							     dst_len, extack);
+			if (opt_len < 0)
+				return opt_len;
+			opts_len += opt_len;
+			type = TUNNEL_ERSPAN_OPT;
+			break;
 		}
 	}
 
@@ -235,6 +310,14 @@ static int tunnel_key_opts_set(struct nlattr *nla, struct ip_tunnel_info *info,
 #else
 		return -EAFNOSUPPORT;
 #endif
+	case TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN:
+#if IS_ENABLED(CONFIG_INET)
+		info->key.tun_flags |= TUNNEL_ERSPAN_OPT;
+		return tunnel_key_copy_opts(nla, ip_tunnel_info_opts(info),
+					    opts_len, extack);
+#else
+		return -EAFNOSUPPORT;
+#endif
 	default:
 		NL_SET_ERR_MSG(extack, "Cannot set tunnel options for unknown tunnel type");
 		return -EINVAL;
@@ -530,6 +613,37 @@ static int tunnel_key_vxlan_opts_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static int tunnel_key_erspan_opts_dump(struct sk_buff *skb,
+				       const struct ip_tunnel_info *info)
+{
+	struct erspan_metadata *md = (struct erspan_metadata *)(info + 1);
+	struct nlattr *start;
+
+	start = nla_nest_start_noflag(skb, TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN);
+	if (!start)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(skb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER, md->version))
+		goto err;
+
+	if (md->version == 1 &&
+	    nla_put_be32(skb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX, md->u.index))
+		goto err;
+
+	if (md->version == 2 &&
+	    (nla_put_u8(skb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR,
+			md->u.md2.dir) ||
+	     nla_put_u8(skb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID,
+			get_hwid(&md->u.md2))))
+		goto err;
+
+	nla_nest_end(skb, start);
+	return 0;
+err:
+	nla_nest_cancel(skb, start);
+	return -EMSGSIZE;
+}
+
 static int tunnel_key_opts_dump(struct sk_buff *skb,
 				const struct ip_tunnel_info *info)
 {
@@ -551,6 +665,10 @@ static int tunnel_key_opts_dump(struct sk_buff *skb,
 		err = tunnel_key_vxlan_opts_dump(skb, info);
 		if (err)
 			goto err_out;
+	} else if (info->key.tun_flags & TUNNEL_ERSPAN_OPT) {
+		err = tunnel_key_erspan_opts_dump(skb, info);
+		if (err)
+			goto err_out;
 	} else {
 err_out:
 		nla_nest_cancel(skb, start);
-- 
2.1.0

