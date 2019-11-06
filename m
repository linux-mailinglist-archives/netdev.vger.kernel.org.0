Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90736F11A5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731570AbfKFJB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:01:59 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34546 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731526AbfKFJB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:01:59 -0500
Received: by mail-pl1-f196.google.com with SMTP id k7so11127765pll.1
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 01:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=da6NZhi45s00NCsWrtY1MzdnRdz1zAsarEWuxcfx56Q=;
        b=jRSBujbKL/GmN5EV3cRNjozSBGlEKr+RWUuW3daYFT+yYE7VLLiaE9TogSZcgC1eZv
         q+TN+Ektp8jY68tgDF7ElOjfQOF9tHWHehI0p/C1UJ9IlTjS6FojTfULBCTOAQmgevcR
         h1RxP2xt1oXMAordc2hdsy7jF6Us65zKlTmjBJ5aW/sH00ruOuSDoIFc3ieuai83nGfe
         cExSGjvjaxhF/Wt+nNapR8DGJ8T3ESwbluNId2Rts+Hof6aZle6wYD+eMUU0TeZ5ZoRM
         dvMAinyHXiulrEtoyGTCWdxp8qBgyKEjZNbfT5UN3W2q13rel/9Ih1GT+SbFDrD/85AJ
         lo5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=da6NZhi45s00NCsWrtY1MzdnRdz1zAsarEWuxcfx56Q=;
        b=ZSRasyUZO/U5z4eoZsERg4oQyPcCG6vSAydLB0R98ERo6RgJDi44P5PhZzu2GwTFKG
         FgAy6vkGqql6M5qeKGbt6vdFl/hGD9Pm9xgNE5OGsmjtqk9BwRvTz1DmcKp8p+CTVqc0
         +X+a+zXZW6yvquDhyb1+cCYgMwajPecuqOnVYrWE3nUAEzqy8C7pG4Y8gH4mIGvpFdoP
         i/kZksXItHetCBfbFdpOmHaXzar44lLTyrmS1MrEwczX/KL/FPxlTDJasUss5DtKhsXl
         0DA9onKGk9nIhIaKia+qidUSWCSn1TlE6/z0d79BZ/XYxhTzPBMOhLeXpGA7IpuRyXed
         CEYw==
X-Gm-Message-State: APjAAAWtaVCvli4oYRPxHOPfw6NwdpVEbIyoAbGZbpjPNT7VyQr2Aw8Y
        Ojx/oLx3bM4lJ4B/RkKF82UrCB8z
X-Google-Smtp-Source: APXvYqzoTfrXO0pPHh1BOxXNxX8Q2Uipfhqd8eSDY4nPnsKzvmtoOqCbSiBaHJb2uH+xhjAewoJPNw==
X-Received: by 2002:a17:902:694a:: with SMTP id k10mr1489662plt.304.1573030918146;
        Wed, 06 Nov 2019 01:01:58 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r5sm18876506pfh.179.2019.11.06.01.01.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 01:01:57 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        u9012063@gmail.com
Subject: [PATCH net-next 5/5] lwtunnel: add options setting and dumping for erspan
Date:   Wed,  6 Nov 2019 17:01:07 +0800
Message-Id: <aea7b19e3ff52536e637b2459a0fdb578d0eba5e.1573030805.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c98d3ea3e591f5a0e5767bc7eabcd7035764bbb3.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
 <aeac8e3758555d75a9026ffdba985d95301552a0.1573030805.git.lucien.xin@gmail.com>
 <205adb4659c05108760ef058275fd44b8a907da4.1573030805.git.lucien.xin@gmail.com>
 <f5c8d0637858b8fe0e95243e4514533dbe9189cd.1573030805.git.lucien.xin@gmail.com>
 <c98d3ea3e591f5a0e5767bc7eabcd7035764bbb3.1573030805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the code framework built on the last patch, to
support setting and dumping for vxlan, we only need to
add ip_tun_parse_opts_erspan() for .build_state and
ip_tun_fill_encap_opts_erspan() for .fill_encap and
if (tun_flags & TUNNEL_ERSPAN_OPT) for .get_encap_size.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/lwtunnel.h | 12 ++++++
 net/ipv4/ip_tunnel_core.c     | 94 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 638b7b1..f6035f7 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -52,6 +52,7 @@ enum {
 	LWTUNNEL_IP_OPTS_UNSPEC,
 	LWTUNNEL_IP_OPTS_GENEVE,
 	LWTUNNEL_IP_OPTS_VXLAN,
+	LWTUNNEL_IP_OPTS_ERSPAN,
 	__LWTUNNEL_IP_OPTS_MAX,
 };
 
@@ -76,6 +77,17 @@ enum {
 #define LWTUNNEL_IP_OPT_VXLAN_MAX (__LWTUNNEL_IP_OPT_VXLAN_MAX - 1)
 
 enum {
+	LWTUNNEL_IP_OPT_ERSPAN_UNSPEC,
+	LWTUNNEL_IP_OPT_ERSPAN_VER,
+	LWTUNNEL_IP_OPT_ERSPAN_INDEX,
+	LWTUNNEL_IP_OPT_ERSPAN_DIR,
+	LWTUNNEL_IP_OPT_ERSPAN_HWID,
+	__LWTUNNEL_IP_OPT_ERSPAN_MAX,
+};
+
+#define LWTUNNEL_IP_OPT_ERSPAN_MAX (__LWTUNNEL_IP_OPT_ERSPAN_MAX - 1)
+
+enum {
 	LWT_BPF_PROG_UNSPEC,
 	LWT_BPF_PROG_FD,
 	LWT_BPF_PROG_NAME,
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 61be2e0..d4f84bf 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -36,6 +36,7 @@
 #include <net/dst_metadata.h>
 #include <net/geneve.h>
 #include <net/vxlan.h>
+#include <net/erspan.h>
 
 const struct ip_tunnel_encap_ops __rcu *
 		iptun_encaps[MAX_IPTUN_ENCAP_OPS] __read_mostly;
@@ -226,6 +227,7 @@ static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
 static const struct nla_policy ip_opts_policy[LWTUNNEL_IP_OPTS_MAX + 1] = {
 	[LWTUNNEL_IP_OPTS_GENEVE]	= { .type = NLA_NESTED },
 	[LWTUNNEL_IP_OPTS_VXLAN]	= { .type = NLA_NESTED },
+	[LWTUNNEL_IP_OPTS_ERSPAN]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -240,6 +242,14 @@ vxlan_opt_policy[LWTUNNEL_IP_OPT_VXLAN_MAX + 1] = {
 	[LWTUNNEL_IP_OPT_VXLAN_GBP]	= { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+erspan_opt_policy[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1] = {
+	[LWTUNNEL_IP_OPT_ERSPAN_VER]	= { .type = NLA_U8 },
+	[LWTUNNEL_IP_OPT_ERSPAN_INDEX]	= { .type = NLA_U32 },
+	[LWTUNNEL_IP_OPT_ERSPAN_DIR]	= { .type = NLA_U8 },
+	[LWTUNNEL_IP_OPT_ERSPAN_HWID]	= { .type = NLA_U8 },
+};
+
 static int ip_tun_parse_opts_geneve(struct nlattr *attr,
 				    struct ip_tunnel_info *info,
 				    struct netlink_ext_ack *extack)
@@ -303,6 +313,46 @@ static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
 	return sizeof(struct vxlan_metadata);
 }
 
+static int ip_tun_parse_opts_erspan(struct nlattr *attr,
+				    struct ip_tunnel_info *info,
+				    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1];
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPT_ERSPAN_MAX,
+					  attr, erspan_opt_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[LWTUNNEL_IP_OPT_ERSPAN_VER])
+		return -EINVAL;
+
+	if (info) {
+		struct erspan_metadata *md = ip_tunnel_info_opts(info);
+
+		attr = tb[LWTUNNEL_IP_OPT_ERSPAN_VER];
+		md->version = nla_get_u8(attr);
+
+		if (md->version == 1 && tb[LWTUNNEL_IP_OPT_ERSPAN_INDEX]) {
+			attr = tb[LWTUNNEL_IP_OPT_ERSPAN_INDEX];
+			md->u.index = nla_get_be32(attr);
+		} else if (md->version == 2 && tb[LWTUNNEL_IP_OPT_ERSPAN_DIR] &&
+			   tb[LWTUNNEL_IP_OPT_ERSPAN_HWID]) {
+			attr = tb[LWTUNNEL_IP_OPT_ERSPAN_DIR];
+			md->u.md2.dir = nla_get_u8(attr);
+			attr = tb[LWTUNNEL_IP_OPT_ERSPAN_HWID];
+			set_hwid(&md->u.md2, nla_get_u8(attr));
+		} else {
+			return -EINVAL;
+		}
+
+		info->key.tun_flags |= TUNNEL_ERSPAN_OPT;
+	}
+
+	return sizeof(struct erspan_metadata);
+}
+
 static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 			     struct netlink_ext_ack *extack)
 {
@@ -323,6 +373,9 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 	else if (tb[LWTUNNEL_IP_OPTS_VXLAN])
 		err = ip_tun_parse_opts_vxlan(tb[LWTUNNEL_IP_OPTS_VXLAN],
 					      info, extack);
+	else if (tb[LWTUNNEL_IP_OPTS_ERSPAN])
+		err = ip_tun_parse_opts_erspan(tb[LWTUNNEL_IP_OPTS_ERSPAN],
+					       info, extack);
 	else
 		err = -EINVAL;
 
@@ -460,6 +513,37 @@ static int ip_tun_fill_encap_opts_vxlan(struct sk_buff *skb,
 	return 0;
 }
 
+static int ip_tun_fill_encap_opts_erspan(struct sk_buff *skb,
+					 struct ip_tunnel_info *tun_info)
+{
+	struct erspan_metadata *md;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, LWTUNNEL_IP_OPTS_ERSPAN);
+	if (!nest)
+		return -ENOMEM;
+
+	md = ip_tunnel_info_opts(tun_info);
+	if (nla_put_u32(skb, LWTUNNEL_IP_OPT_ERSPAN_VER, md->version))
+		goto err;
+
+	if (md->version == 1 &&
+	    nla_put_be32(skb, LWTUNNEL_IP_OPT_ERSPAN_INDEX, md->u.index))
+		goto err;
+
+	if (md->version == 2 &&
+	    (nla_put_u8(skb, LWTUNNEL_IP_OPT_ERSPAN_DIR, md->u.md2.dir) ||
+	     nla_put_u8(skb, LWTUNNEL_IP_OPT_ERSPAN_HWID,
+			get_hwid(&md->u.md2))))
+		goto err;
+
+	nla_nest_end(skb, nest);
+	return 0;
+err:
+	nla_nest_cancel(skb, nest);
+	return -ENOMEM;
+}
+
 static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
 				  struct ip_tunnel_info *tun_info)
 {
@@ -467,7 +551,7 @@ static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
 	int err = 0;
 
 	if (!(tun_info->key.tun_flags &
-	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT)))
+	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)))
 		return 0;
 
 	nest = nla_nest_start_noflag(skb, type);
@@ -478,6 +562,8 @@ static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
 		err = ip_tun_fill_encap_opts_geneve(skb, tun_info);
 	else if (tun_info->key.tun_flags & TUNNEL_VXLAN_OPT)
 		err = ip_tun_fill_encap_opts_vxlan(skb, tun_info);
+	else if (tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT)
+		err = ip_tun_fill_encap_opts_erspan(skb, tun_info);
 
 	if (err) {
 		nla_nest_cancel(skb, nest);
@@ -511,7 +597,7 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 	int opt_len;
 
 	if (!(info->key.tun_flags &
-	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT)))
+	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)))
 		return 0;
 
 	opt_len = nla_total_size(0);		/* LWTUNNEL_IP_OPTS */
@@ -526,6 +612,10 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 	} else if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
 		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_VXLAN */
 			   + nla_total_size(4);	/* OPT_VXLAN_GBP */
+	} else if (info->key.tun_flags & TUNNEL_ERSPAN_OPT) {
+		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_ERSPAN */
+			   + nla_total_size(1)	/* OPT_ERSPAN_VER */
+			   + nla_total_size(4);	/* OPT_ERSPAN_INDEX/DIR/HWID */
 	}
 
 	return opt_len;
-- 
2.1.0

