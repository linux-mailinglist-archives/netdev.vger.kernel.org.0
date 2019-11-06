Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AE3F11A2
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731518AbfKFJBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:01:51 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37799 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfKFJBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:01:51 -0500
Received: by mail-pl1-f195.google.com with SMTP id p13so11115440pll.4
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 01:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=hm/a63JrfGhZdwBSYQ9GZlF+8YQxc0JTAlFrihL1mLs=;
        b=Ef4OrtZ7p+FL2/R06ib7crdB8W6qFWfT5MHcCywSTGvk7CmzNn8GYkcdJLSQ2hjLmo
         09CkqjGFsm5QErlB/w6UOkC6KZdG4n5gFGvrHaOV9XWDA0NmoqieKsooCYSDSmKFPZFa
         iGs24kQApyQhDCoI8fRG2dn7GqWdYd8T4dOZtqso6VvJnJ4xFc50l+g1GOHGxkNIcPvw
         ngpp1pBkgE1vTrFtBU9wwr+0WQ5bDUpEG1JI/JtB0tF0ym3RvLTrS+bWqfINiUctiUOu
         nM2OEgwgHB81I0V+Rh7RfRL9E9AId0e1nTOmXuU5GxseAEY/OZicmRBOUdcFpqwwDG2U
         XOrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=hm/a63JrfGhZdwBSYQ9GZlF+8YQxc0JTAlFrihL1mLs=;
        b=nRm9xOjWi7AEYLJw+NkfHKDFAHuWo4P3hU9vl8DAwtcpYR7wLLDHHKqRIj1OSqpUkP
         r0J0bV/YLuEOFe9qgDALaMm/PyZJmsQV08eety3bSVGNZJJ5cGNmLhXD5djEyuooKQjW
         ZRe7qwYoqsg7Rh0gyAXLQ2aKtCiumlKgaq6fBvZtE/flGU41zISD7I1Q0B6HunodQ4eK
         dgkCcJ9QIU2PduiL8hkEQDpiav0h3LIOMmj1mHwLT6aP+ITjz7pNqLGle7XH69dCKvzh
         DxHV8qt/SrTy6ltxSPB/I/lTGnwfMdXowPGj0HpHH7GeNv0TupsfQmu2i/+w0ORaqj+G
         iYZw==
X-Gm-Message-State: APjAAAWdgNVHODFIHS+FI8S4w+vYDf5XtrsL6a6ovXMPK3n0a89cUVk+
        ene9orDe+KHJjM2RKi6i9UEhVd7c
X-Google-Smtp-Source: APXvYqwFhPjoL6mNvrfC8BCiJYet2Xapmu8tr+mC+KwHAWNqA5Er56Ra1ptMMwA6t/ytf1QWNj7U5g==
X-Received: by 2002:a17:902:b715:: with SMTP id d21mr1465169pls.312.1573030909458;
        Wed, 06 Nov 2019 01:01:49 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i5sm10776164pfo.52.2019.11.06.01.01.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 01:01:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        u9012063@gmail.com
Subject: [PATCH net-next 4/5] lwtunnel: add options setting and dumping for vxlan
Date:   Wed,  6 Nov 2019 17:01:06 +0800
Message-Id: <c98d3ea3e591f5a0e5767bc7eabcd7035764bbb3.1573030805.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <f5c8d0637858b8fe0e95243e4514533dbe9189cd.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
 <aeac8e3758555d75a9026ffdba985d95301552a0.1573030805.git.lucien.xin@gmail.com>
 <205adb4659c05108760ef058275fd44b8a907da4.1573030805.git.lucien.xin@gmail.com>
 <f5c8d0637858b8fe0e95243e4514533dbe9189cd.1573030805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the code framework built on the last patch, to
support setting and dumping for vxlan, we only need to
add ip_tun_parse_opts_vxlan() for .build_state and
ip_tun_fill_encap_opts_vxlan() for .fill_encap and
if (tun_flags & TUNNEL_VXLAN_OPT) for .get_encap_size.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/lwtunnel.h |  9 ++++++
 net/ipv4/ip_tunnel_core.c     | 67 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index b595ab2..638b7b1 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -51,6 +51,7 @@ enum lwtunnel_ip6_t {
 enum {
 	LWTUNNEL_IP_OPTS_UNSPEC,
 	LWTUNNEL_IP_OPTS_GENEVE,
+	LWTUNNEL_IP_OPTS_VXLAN,
 	__LWTUNNEL_IP_OPTS_MAX,
 };
 
@@ -67,6 +68,14 @@ enum {
 #define LWTUNNEL_IP_OPT_GENEVE_MAX (__LWTUNNEL_IP_OPT_GENEVE_MAX - 1)
 
 enum {
+	LWTUNNEL_IP_OPT_VXLAN_UNSPEC,
+	LWTUNNEL_IP_OPT_VXLAN_GBP,
+	__LWTUNNEL_IP_OPT_VXLAN_MAX,
+};
+
+#define LWTUNNEL_IP_OPT_VXLAN_MAX (__LWTUNNEL_IP_OPT_VXLAN_MAX - 1)
+
+enum {
 	LWT_BPF_PROG_UNSPEC,
 	LWT_BPF_PROG_FD,
 	LWT_BPF_PROG_NAME,
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 1ec9d94..61be2e0 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -35,6 +35,7 @@
 #include <net/rtnetlink.h>
 #include <net/dst_metadata.h>
 #include <net/geneve.h>
+#include <net/vxlan.h>
 
 const struct ip_tunnel_encap_ops __rcu *
 		iptun_encaps[MAX_IPTUN_ENCAP_OPS] __read_mostly;
@@ -224,6 +225,7 @@ static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
 
 static const struct nla_policy ip_opts_policy[LWTUNNEL_IP_OPTS_MAX + 1] = {
 	[LWTUNNEL_IP_OPTS_GENEVE]	= { .type = NLA_NESTED },
+	[LWTUNNEL_IP_OPTS_VXLAN]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -233,6 +235,11 @@ geneve_opt_policy[LWTUNNEL_IP_OPT_GENEVE_MAX + 1] = {
 	[LWTUNNEL_IP_OPT_GENEVE_DATA]	= { .type = NLA_BINARY, .len = 128 },
 };
 
+static const struct nla_policy
+vxlan_opt_policy[LWTUNNEL_IP_OPT_VXLAN_MAX + 1] = {
+	[LWTUNNEL_IP_OPT_VXLAN_GBP]	= { .type = NLA_U32 },
+};
+
 static int ip_tun_parse_opts_geneve(struct nlattr *attr,
 				    struct ip_tunnel_info *info,
 				    struct netlink_ext_ack *extack)
@@ -270,6 +277,32 @@ static int ip_tun_parse_opts_geneve(struct nlattr *attr,
 	return sizeof(struct geneve_opt) + data_len;
 }
 
+static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
+				   struct ip_tunnel_info *info,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPT_VXLAN_MAX,
+					  attr, vxlan_opt_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[LWTUNNEL_IP_OPT_VXLAN_GBP])
+		return -EINVAL;
+
+	if (info) {
+		struct vxlan_metadata *md = ip_tunnel_info_opts(info);
+
+		attr = tb[LWTUNNEL_IP_OPT_VXLAN_GBP];
+		md->gbp = nla_get_u32(attr);
+		info->key.tun_flags |= TUNNEL_VXLAN_OPT;
+	}
+
+	return sizeof(struct vxlan_metadata);
+}
+
 static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 			     struct netlink_ext_ack *extack)
 {
@@ -287,6 +320,9 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 	if (tb[LWTUNNEL_IP_OPTS_GENEVE])
 		err = ip_tun_parse_opts_geneve(tb[LWTUNNEL_IP_OPTS_GENEVE],
 					       info, extack);
+	else if (tb[LWTUNNEL_IP_OPTS_VXLAN])
+		err = ip_tun_parse_opts_vxlan(tb[LWTUNNEL_IP_OPTS_VXLAN],
+					      info, extack);
 	else
 		err = -EINVAL;
 
@@ -404,13 +440,34 @@ static int ip_tun_fill_encap_opts_geneve(struct sk_buff *skb,
 	return 0;
 }
 
+static int ip_tun_fill_encap_opts_vxlan(struct sk_buff *skb,
+					struct ip_tunnel_info *tun_info)
+{
+	struct vxlan_metadata *md;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, LWTUNNEL_IP_OPTS_VXLAN);
+	if (!nest)
+		return -ENOMEM;
+
+	md = ip_tunnel_info_opts(tun_info);
+	if (nla_put_u32(skb, LWTUNNEL_IP_OPT_VXLAN_GBP, md->gbp)) {
+		nla_nest_cancel(skb, nest);
+		return -ENOMEM;
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+}
+
 static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
 				  struct ip_tunnel_info *tun_info)
 {
 	struct nlattr *nest;
 	int err = 0;
 
-	if (!(tun_info->key.tun_flags & TUNNEL_GENEVE_OPT))
+	if (!(tun_info->key.tun_flags &
+	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT)))
 		return 0;
 
 	nest = nla_nest_start_noflag(skb, type);
@@ -419,6 +476,8 @@ static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
 
 	if (tun_info->key.tun_flags & TUNNEL_GENEVE_OPT)
 		err = ip_tun_fill_encap_opts_geneve(skb, tun_info);
+	else if (tun_info->key.tun_flags & TUNNEL_VXLAN_OPT)
+		err = ip_tun_fill_encap_opts_vxlan(skb, tun_info);
 
 	if (err) {
 		nla_nest_cancel(skb, nest);
@@ -451,7 +510,8 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 {
 	int opt_len;
 
-	if (!(info->key.tun_flags & TUNNEL_GENEVE_OPT))
+	if (!(info->key.tun_flags &
+	      (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT)))
 		return 0;
 
 	opt_len = nla_total_size(0);		/* LWTUNNEL_IP_OPTS */
@@ -463,6 +523,9 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 			   + nla_total_size(1)	/* OPT_GENEVE_TYPE */
 			   + nla_total_size(opt->length * 4);
 						/* OPT_GENEVE_DATA */
+	} else if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_VXLAN */
+			   + nla_total_size(4);	/* OPT_VXLAN_GBP */
 	}
 
 	return opt_len;
-- 
2.1.0

