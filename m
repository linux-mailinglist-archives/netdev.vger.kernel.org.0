Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34588F11A1
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbfKFJBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:01:42 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35059 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfKFJBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:01:42 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so274867plp.2
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 01:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=tZ8OfzzLSBuweT31YJ+Wra3rkM5/2natWbC42rc1mEw=;
        b=epGVJEAjyi4cW51+nqkMzio1Fg/4XnJXuOok5cta2NR+2FPlAmoatROWRUFlO6bjmA
         UFI/8MD5BoXIhg7YCex+3BA7zMrxOLCoLHcwvUQ2rnAd7UcEvXhKHk3OBi3G14WnHD9z
         xteWhaO8rupMAN72IbB5z8Ve0R8GYkHIGyqp9bGwqfnXwDIHmoTWQ2/XR0gKBfta6Cr7
         7AkzhtVVunki6Ps41FCwpeTWjv9v+BbQForUON2enYxyPc8ihRcVBFR50FFYxMgmaa/b
         LDL0J8BxkuvU7SpKt9Qrjg5bbasycZCHSS5yqfqnXDWc19+hSxrNoGjZYxuaNaCHc87+
         Jnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=tZ8OfzzLSBuweT31YJ+Wra3rkM5/2natWbC42rc1mEw=;
        b=J92dMHve5UdlmCm1zAoY6jKjSqiwKMLS+ZA41PPHj/BEuKJu0kR1Ox8RrK5GskBTvq
         tPd8MEWQFHMxvenilMYZ9FTgyT+PbusDwkCC+ckZza+lVBUwfT/KLFBkMlhfEsXF/Bbc
         WAwlCQH9ZRz09SbzyyiB5mdLETNJ1JHLxnNZ1AArxetuafoRNbYbN8jhL2Z/7q0bTxCw
         ec8HT6BAY0m0AwFuuYOetEuV2msGl5tVYVmAryTSNSTv7k5ojUOqEXANPOYUUVgLUhiO
         urh3TfCAMl1aK8OVcIOLCf3Nd66RYygWRGB6QMYjncB7WQWgBWoLdX3oLqOFYEa3wsST
         dXiA==
X-Gm-Message-State: APjAAAUaWDV+C2hD8S/+xCA3qa7I1B5nMOQkV93IXnUcZSFHGTibmJsf
        0HUmGGjASgtxtW4YTBD4saJvaNRi
X-Google-Smtp-Source: APXvYqwPbbDVgiumGLxHOl94NsR7fEFukIGHUvmHdrCjludFzlfpHA0YKbbxRqA7C/iSTWraBcW09w==
X-Received: by 2002:a17:902:4a:: with SMTP id 68mr1486904pla.8.1573030901035;
        Wed, 06 Nov 2019 01:01:41 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t12sm23691737pgv.45.2019.11.06.01.01.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 01:01:40 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        u9012063@gmail.com
Subject: [PATCH net-next 3/5] lwtunnel: add options setting and dumping for geneve
Date:   Wed,  6 Nov 2019 17:01:05 +0800
Message-Id: <f5c8d0637858b8fe0e95243e4514533dbe9189cd.1573030805.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <205adb4659c05108760ef058275fd44b8a907da4.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
 <aeac8e3758555d75a9026ffdba985d95301552a0.1573030805.git.lucien.xin@gmail.com>
 <205adb4659c05108760ef058275fd44b8a907da4.1573030805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To add options setting and dumping, .build_state(), .fill_encap() and
.get_encap_size() in ip_tun_lwt_ops needs to be extended:

ip_tun_build_state():
  ip_tun_parse_opts():
    ip_tun_parse_opts_geneve()

ip_tun_fill_encap_info():
  ip_tun_fill_encap_opts():
    ip_tun_fill_encap_opts_geneve()

ip_tun_encap_nlsize()
   ip_tun_opts_nlsize():
     if (tun_flags & TUNNEL_GENEVE_OPT)

ip_tun_parse_opts(), ip_tun_fill_encap_opts() and ip_tun_opts_nlsize()
processes LWTUNNEL_IP_OPTS.

ip_tun_parse_opts_geneve(), ip_tun_fill_encap_opts_geneve() and
if (tun_flags & TUNNEL_GENEVE_OPT) processes LWTUNNEL_IP_OPTS_GENEVE.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/lwtunnel.h |  20 ++++
 net/ipv4/ip_tunnel_core.c     | 212 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 216 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index de696ca..b595ab2 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -27,6 +27,7 @@ enum lwtunnel_ip_t {
 	LWTUNNEL_IP_TOS,
 	LWTUNNEL_IP_FLAGS,
 	LWTUNNEL_IP_PAD,
+	LWTUNNEL_IP_OPTS,
 	__LWTUNNEL_IP_MAX,
 };
 
@@ -41,12 +42,31 @@ enum lwtunnel_ip6_t {
 	LWTUNNEL_IP6_TC,
 	LWTUNNEL_IP6_FLAGS,
 	LWTUNNEL_IP6_PAD,
+	LWTUNNEL_IP6_OPTS,
 	__LWTUNNEL_IP6_MAX,
 };
 
 #define LWTUNNEL_IP6_MAX (__LWTUNNEL_IP6_MAX - 1)
 
 enum {
+	LWTUNNEL_IP_OPTS_UNSPEC,
+	LWTUNNEL_IP_OPTS_GENEVE,
+	__LWTUNNEL_IP_OPTS_MAX,
+};
+
+#define LWTUNNEL_IP_OPTS_MAX (__LWTUNNEL_IP_OPTS_MAX - 1)
+
+enum {
+	LWTUNNEL_IP_OPT_GENEVE_UNSPEC,
+	LWTUNNEL_IP_OPT_GENEVE_CLASS,
+	LWTUNNEL_IP_OPT_GENEVE_TYPE,
+	LWTUNNEL_IP_OPT_GENEVE_DATA,
+	__LWTUNNEL_IP_OPT_GENEVE_MAX,
+};
+
+#define LWTUNNEL_IP_OPT_GENEVE_MAX (__LWTUNNEL_IP_OPT_GENEVE_MAX - 1)
+
+enum {
 	LWT_BPF_PROG_UNSPEC,
 	LWT_BPF_PROG_FD,
 	LWT_BPF_PROG_NAME,
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index c0b5bad..1ec9d94 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -34,6 +34,7 @@
 #include <net/netns/generic.h>
 #include <net/rtnetlink.h>
 #include <net/dst_metadata.h>
+#include <net/geneve.h>
 
 const struct ip_tunnel_encap_ops __rcu *
 		iptun_encaps[MAX_IPTUN_ENCAP_OPS] __read_mostly;
@@ -218,24 +219,112 @@ static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
 	[LWTUNNEL_IP_TTL]	= { .type = NLA_U8 },
 	[LWTUNNEL_IP_TOS]	= { .type = NLA_U8 },
 	[LWTUNNEL_IP_FLAGS]	= { .type = NLA_U16 },
+	[LWTUNNEL_IP_OPTS]	= { .type = NLA_NESTED },
 };
 
+static const struct nla_policy ip_opts_policy[LWTUNNEL_IP_OPTS_MAX + 1] = {
+	[LWTUNNEL_IP_OPTS_GENEVE]	= { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+geneve_opt_policy[LWTUNNEL_IP_OPT_GENEVE_MAX + 1] = {
+	[LWTUNNEL_IP_OPT_GENEVE_CLASS]	= { .type = NLA_U16 },
+	[LWTUNNEL_IP_OPT_GENEVE_TYPE]	= { .type = NLA_U8 },
+	[LWTUNNEL_IP_OPT_GENEVE_DATA]	= { .type = NLA_BINARY, .len = 128 },
+};
+
+static int ip_tun_parse_opts_geneve(struct nlattr *attr,
+				    struct ip_tunnel_info *info,
+				    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[LWTUNNEL_IP_OPT_GENEVE_MAX + 1];
+	int data_len, err;
+
+	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPT_GENEVE_MAX,
+					  attr, geneve_opt_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[LWTUNNEL_IP_OPT_GENEVE_CLASS] ||
+	    !tb[LWTUNNEL_IP_OPT_GENEVE_TYPE] ||
+	    !tb[LWTUNNEL_IP_OPT_GENEVE_DATA])
+		return -EINVAL;
+
+	attr = tb[LWTUNNEL_IP_OPT_GENEVE_DATA];
+	data_len = nla_len(attr);
+	if (data_len % 4)
+		return -EINVAL;
+
+	if (info) {
+		struct geneve_opt *opt = ip_tunnel_info_opts(info);
+
+		memcpy(opt->opt_data, nla_data(attr), data_len);
+		opt->length = data_len / 4;
+		attr = tb[LWTUNNEL_IP_OPT_GENEVE_CLASS];
+		opt->opt_class = nla_get_be16(attr);
+		attr = tb[LWTUNNEL_IP_OPT_GENEVE_TYPE];
+		opt->type = nla_get_u8(attr);
+		info->key.tun_flags |= TUNNEL_GENEVE_OPT;
+	}
+
+	return sizeof(struct geneve_opt) + data_len;
+}
+
+static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[LWTUNNEL_IP_OPTS_MAX + 1];
+	int err;
+
+	if (!attr)
+		return 0;
+
+	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_OPTS_MAX, attr,
+					  ip_opts_policy, extack);
+	if (err)
+		return err;
+
+	if (tb[LWTUNNEL_IP_OPTS_GENEVE])
+		err = ip_tun_parse_opts_geneve(tb[LWTUNNEL_IP_OPTS_GENEVE],
+					       info, extack);
+	else
+		err = -EINVAL;
+
+	return err;
+}
+
+static int ip_tun_get_optlen(struct nlattr *attr,
+			     struct netlink_ext_ack *extack)
+{
+	return ip_tun_parse_opts(attr, NULL, extack);
+}
+
+static int ip_tun_set_opts(struct nlattr *attr, struct ip_tunnel_info *info,
+			   struct netlink_ext_ack *extack)
+{
+	return ip_tun_parse_opts(attr, info, extack);
+}
+
 static int ip_tun_build_state(struct nlattr *attr,
 			      unsigned int family, const void *cfg,
 			      struct lwtunnel_state **ts,
 			      struct netlink_ext_ack *extack)
 {
-	struct ip_tunnel_info *tun_info;
-	struct lwtunnel_state *new_state;
 	struct nlattr *tb[LWTUNNEL_IP_MAX + 1];
-	int err;
+	struct lwtunnel_state *new_state;
+	struct ip_tunnel_info *tun_info;
+	int err, opt_len;
 
 	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_MAX, attr,
 					  ip_tun_policy, extack);
 	if (err < 0)
 		return err;
 
-	new_state = lwtunnel_state_alloc(sizeof(*tun_info));
+	opt_len = ip_tun_get_optlen(tb[LWTUNNEL_IP_OPTS], extack);
+	if (opt_len < 0)
+		return opt_len;
+
+	new_state = lwtunnel_state_alloc(sizeof(*tun_info) + opt_len);
 	if (!new_state)
 		return -ENOMEM;
 
@@ -243,6 +332,12 @@ static int ip_tun_build_state(struct nlattr *attr,
 
 	tun_info = lwt_tun_info(new_state);
 
+	err = ip_tun_set_opts(tb[LWTUNNEL_IP_OPTS], tun_info, extack);
+	if (err < 0) {
+		lwtstate_free(new_state);
+		return err;
+	}
+
 #ifdef CONFIG_DST_CACHE
 	err = dst_cache_init(&tun_info->dst_cache, GFP_KERNEL);
 	if (err) {
@@ -267,10 +362,10 @@ static int ip_tun_build_state(struct nlattr *attr,
 		tun_info->key.tos = nla_get_u8(tb[LWTUNNEL_IP_TOS]);
 
 	if (tb[LWTUNNEL_IP_FLAGS])
-		tun_info->key.tun_flags = nla_get_be16(tb[LWTUNNEL_IP_FLAGS]);
+		tun_info->key.tun_flags |= nla_get_be16(tb[LWTUNNEL_IP_FLAGS]);
 
 	tun_info->mode = IP_TUNNEL_INFO_TX;
-	tun_info->options_len = 0;
+	tun_info->options_len = opt_len;
 
 	*ts = new_state;
 
@@ -286,6 +381,54 @@ static void ip_tun_destroy_state(struct lwtunnel_state *lwtstate)
 #endif
 }
 
+static int ip_tun_fill_encap_opts_geneve(struct sk_buff *skb,
+					 struct ip_tunnel_info *tun_info)
+{
+	struct geneve_opt *opt;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, LWTUNNEL_IP_OPTS_GENEVE);
+	if (!nest)
+		return -ENOMEM;
+
+	opt = ip_tunnel_info_opts(tun_info);
+	if (nla_put_be16(skb, LWTUNNEL_IP_OPT_GENEVE_CLASS, opt->opt_class) ||
+	    nla_put_u8(skb, LWTUNNEL_IP_OPT_GENEVE_TYPE, opt->type) ||
+	    nla_put(skb, LWTUNNEL_IP_OPT_GENEVE_DATA, opt->length * 4,
+		    opt->opt_data)) {
+		nla_nest_cancel(skb, nest);
+		return -ENOMEM;
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+}
+
+static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
+				  struct ip_tunnel_info *tun_info)
+{
+	struct nlattr *nest;
+	int err = 0;
+
+	if (!(tun_info->key.tun_flags & TUNNEL_GENEVE_OPT))
+		return 0;
+
+	nest = nla_nest_start_noflag(skb, type);
+	if (!nest)
+		return -ENOMEM;
+
+	if (tun_info->key.tun_flags & TUNNEL_GENEVE_OPT)
+		err = ip_tun_fill_encap_opts_geneve(skb, tun_info);
+
+	if (err) {
+		nla_nest_cancel(skb, nest);
+		return err;
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+}
+
 static int ip_tun_fill_encap_info(struct sk_buff *skb,
 				  struct lwtunnel_state *lwtstate)
 {
@@ -297,12 +440,34 @@ static int ip_tun_fill_encap_info(struct sk_buff *skb,
 	    nla_put_in_addr(skb, LWTUNNEL_IP_SRC, tun_info->key.u.ipv4.src) ||
 	    nla_put_u8(skb, LWTUNNEL_IP_TOS, tun_info->key.tos) ||
 	    nla_put_u8(skb, LWTUNNEL_IP_TTL, tun_info->key.ttl) ||
-	    nla_put_be16(skb, LWTUNNEL_IP_FLAGS, tun_info->key.tun_flags))
+	    nla_put_be16(skb, LWTUNNEL_IP_FLAGS, tun_info->key.tun_flags) ||
+	    ip_tun_fill_encap_opts(skb, LWTUNNEL_IP_OPTS, tun_info))
 		return -ENOMEM;
 
 	return 0;
 }
 
+static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
+{
+	int opt_len;
+
+	if (!(info->key.tun_flags & TUNNEL_GENEVE_OPT))
+		return 0;
+
+	opt_len = nla_total_size(0);		/* LWTUNNEL_IP_OPTS */
+	if (info->key.tun_flags & TUNNEL_GENEVE_OPT) {
+		struct geneve_opt *opt = ip_tunnel_info_opts(info);
+
+		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_GENEVE */
+			   + nla_total_size(2)	/* OPT_GENEVE_CLASS */
+			   + nla_total_size(1)	/* OPT_GENEVE_TYPE */
+			   + nla_total_size(opt->length * 4);
+						/* OPT_GENEVE_DATA */
+	}
+
+	return opt_len;
+}
+
 static int ip_tun_encap_nlsize(struct lwtunnel_state *lwtstate)
 {
 	return nla_total_size_64bit(8)	/* LWTUNNEL_IP_ID */
@@ -310,7 +475,9 @@ static int ip_tun_encap_nlsize(struct lwtunnel_state *lwtstate)
 		+ nla_total_size(4)	/* LWTUNNEL_IP_SRC */
 		+ nla_total_size(1)	/* LWTUNNEL_IP_TOS */
 		+ nla_total_size(1)	/* LWTUNNEL_IP_TTL */
-		+ nla_total_size(2);	/* LWTUNNEL_IP_FLAGS */
+		+ nla_total_size(2)	/* LWTUNNEL_IP_FLAGS */
+		+ ip_tun_opts_nlsize(lwt_tun_info(lwtstate));
+					/* LWTUNNEL_IP_OPTS */
 }
 
 static int ip_tun_cmp_encap(struct lwtunnel_state *a, struct lwtunnel_state *b)
@@ -348,17 +515,21 @@ static int ip6_tun_build_state(struct nlattr *attr,
 			       struct lwtunnel_state **ts,
 			       struct netlink_ext_ack *extack)
 {
-	struct ip_tunnel_info *tun_info;
-	struct lwtunnel_state *new_state;
 	struct nlattr *tb[LWTUNNEL_IP6_MAX + 1];
-	int err;
+	struct lwtunnel_state *new_state;
+	struct ip_tunnel_info *tun_info;
+	int err, opt_len;
 
 	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP6_MAX, attr,
 					  ip6_tun_policy, extack);
 	if (err < 0)
 		return err;
 
-	new_state = lwtunnel_state_alloc(sizeof(*tun_info));
+	opt_len = ip_tun_get_optlen(tb[LWTUNNEL_IP6_OPTS], extack);
+	if (opt_len < 0)
+		return opt_len;
+
+	new_state = lwtunnel_state_alloc(sizeof(*tun_info) + opt_len);
 	if (!new_state)
 		return -ENOMEM;
 
@@ -366,6 +537,12 @@ static int ip6_tun_build_state(struct nlattr *attr,
 
 	tun_info = lwt_tun_info(new_state);
 
+	err = ip_tun_set_opts(tb[LWTUNNEL_IP6_OPTS], tun_info, extack);
+	if (err < 0) {
+		lwtstate_free(new_state);
+		return err;
+	}
+
 	if (tb[LWTUNNEL_IP6_ID])
 		tun_info->key.tun_id = nla_get_be64(tb[LWTUNNEL_IP6_ID]);
 
@@ -382,10 +559,10 @@ static int ip6_tun_build_state(struct nlattr *attr,
 		tun_info->key.tos = nla_get_u8(tb[LWTUNNEL_IP6_TC]);
 
 	if (tb[LWTUNNEL_IP6_FLAGS])
-		tun_info->key.tun_flags = nla_get_be16(tb[LWTUNNEL_IP6_FLAGS]);
+		tun_info->key.tun_flags |= nla_get_be16(tb[LWTUNNEL_IP6_FLAGS]);
 
 	tun_info->mode = IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_IPV6;
-	tun_info->options_len = 0;
+	tun_info->options_len = opt_len;
 
 	*ts = new_state;
 
@@ -403,7 +580,8 @@ static int ip6_tun_fill_encap_info(struct sk_buff *skb,
 	    nla_put_in6_addr(skb, LWTUNNEL_IP6_SRC, &tun_info->key.u.ipv6.src) ||
 	    nla_put_u8(skb, LWTUNNEL_IP6_TC, tun_info->key.tos) ||
 	    nla_put_u8(skb, LWTUNNEL_IP6_HOPLIMIT, tun_info->key.ttl) ||
-	    nla_put_be16(skb, LWTUNNEL_IP6_FLAGS, tun_info->key.tun_flags))
+	    nla_put_be16(skb, LWTUNNEL_IP6_FLAGS, tun_info->key.tun_flags) ||
+	    ip_tun_fill_encap_opts(skb, LWTUNNEL_IP6_OPTS, tun_info))
 		return -ENOMEM;
 
 	return 0;
@@ -416,7 +594,9 @@ static int ip6_tun_encap_nlsize(struct lwtunnel_state *lwtstate)
 		+ nla_total_size(16)	/* LWTUNNEL_IP6_SRC */
 		+ nla_total_size(1)	/* LWTUNNEL_IP6_HOPLIMIT */
 		+ nla_total_size(1)	/* LWTUNNEL_IP6_TC */
-		+ nla_total_size(2);	/* LWTUNNEL_IP6_FLAGS */
+		+ nla_total_size(2)	/* LWTUNNEL_IP6_FLAGS */
+		+ ip_tun_opts_nlsize(lwt_tun_info(lwtstate));
+					/* LWTUNNEL_IP6_OPTS */
 }
 
 static const struct lwtunnel_encap_ops ip6_tun_lwt_ops = {
-- 
2.1.0

