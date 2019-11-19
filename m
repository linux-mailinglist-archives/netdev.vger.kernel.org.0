Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B5A102090
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKSJcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:32:16 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39585 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfKSJcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:32:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so11886199pfo.6
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=bScbvIwkGBoh1naQzO4gnU0ykxub5jQIM8oWCSi2j1Y=;
        b=mTi+lfGH+Z5fhYTn57fcLF9VLTmK1IvUB5zqcWRKZJr7/KcIwKgDSx9G7nqYyd9G+h
         3qFbyQepz6Hi7VoRqLH4AZMhJVpEwFRIbH+3oCJj5r3eOLf33vcz3hAT3kBaQVZv52W6
         09KyNyorep2RuN3KdB0sdVhVFKVXtUNZ7R3VAZTBYkg6cWPwGEbml9L5HsWHyWjl4Or3
         ahPdKL3PS0GfoVewVCzytnwtCBo/oeiwNPgA7PnxnsycPITD3kz3+SeiuA2vPnLa6Y1q
         +/8y1g93qNHtXexBRh8KRtcZ3crDy2m8JCNDz66lvBTC26/DegEv515RzltoiiFhOV+l
         xYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=bScbvIwkGBoh1naQzO4gnU0ykxub5jQIM8oWCSi2j1Y=;
        b=UKHPTADGwKESYHKiGENos+YUjgpr6CY+1ZTyqIB7uF+TNniFjWN+7eYCiSA8LfX6C2
         l1Ib+hpI3Vyrdg8ovqFVAEPpHgZ48KNkYBjryvQHLduYnrX+e+5/OBvmuM8QnVPgrvFW
         V4uUnjPoNafo6325BG3T4eBdKmIDaSzMVdy1zDgFQqsMmK7sLKrMptTM3prnOwy3AON3
         CwWdopf+63tKNiopqpQ8hvITGL4gUQnXtgB6RqpN/mGLemSIoExJgZf2J90/XjFl3JEy
         bqyumQXeRldzxyEYMC686maRJ9cUvDtXZH84zBAZrFneOIv+hnl72WUvXZoS0we//FeZ
         8XMQ==
X-Gm-Message-State: APjAAAUYX02LSmZ5b3fYLsHFh3a1xPNnAI5zZ7C3NvoWdbAEeQOsQIfV
        Il5cu55wbyHV38bcWWd5Lzc3hqxa
X-Google-Smtp-Source: APXvYqwjJymSQkeg2liTFf/PHmyxwTdFMRQ5tvz9PzbXOIkEa72dWTknxfq1/IHWEwraKVrzaUUsmg==
X-Received: by 2002:a63:fb49:: with SMTP id w9mr3926800pgj.296.1574155934332;
        Tue, 19 Nov 2019 01:32:14 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v128sm6005148pgv.24.2019.11.19.01.32.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 01:32:13 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com
Subject: [PATCH net-next 2/4] net: sched: add erspan option support to act_tunnel_key
Date:   Tue, 19 Nov 2019 17:31:47 +0800
Message-Id: <a84fb50a28d9a931e641924962eb05e8cfca12bf.1574155869.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
 <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h |  16 +++++
 net/sched/act_tunnel_key.c                | 108 ++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

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
index 6519333..0272e9b 100644
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
@@ -56,6 +57,7 @@ static const struct nla_policy
 enc_opts_policy[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1] = {
 	[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]	= { .type = NLA_NESTED },
 	[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]		= { .type = NLA_NESTED },
+	[TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -71,6 +73,14 @@ vxlan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1] = {
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
@@ -149,6 +159,49 @@ tunnel_key_copy_vxlan_opt(const struct nlattr *nla, void *dst, int dst_len,
 	return sizeof(struct vxlan_metadata);
 }
 
+static int
+tunnel_key_copy_erspan_opt(const struct nlattr *nla, void *dst, int dst_len,
+			   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	int err;
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
+	if (dst) {
+		struct erspan_metadata *md = dst;
+
+		nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER];
+		md->version = nla_get_u8(nla);
+
+		if (md->version == 1 &&
+		    tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX];
+			md->u.index = nla_get_be32(nla);
+		} else if (md->version == 2 &&
+			   tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR] &&
+			   tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID]) {
+			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR];
+			md->u.md2.dir = nla_get_u8(nla);
+			nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID];
+			set_hwid(&md->u.md2, nla_get_u8(nla));
+		} else {
+			NL_SET_ERR_MSG(extack, "erspan ver is incorrect or some option is missed");
+			return -EINVAL;
+		}
+	}
+
+	return sizeof(struct erspan_metadata);
+}
+
 static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 				int dst_len, struct netlink_ext_ack *extack)
 {
@@ -190,6 +243,18 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 			opts_len += opt_len;
 			type = TUNNEL_VXLAN_OPT;
 			break;
+		case TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN:
+			if (type) {
+				NL_SET_ERR_MSG(extack, "Wrong type for erspan options");
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
 
@@ -233,6 +298,14 @@ static int tunnel_key_opts_set(struct nlattr *nla, struct ip_tunnel_info *info,
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
@@ -528,6 +601,37 @@ static int tunnel_key_vxlan_opts_dump(struct sk_buff *skb,
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
@@ -549,6 +653,10 @@ static int tunnel_key_opts_dump(struct sk_buff *skb,
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

