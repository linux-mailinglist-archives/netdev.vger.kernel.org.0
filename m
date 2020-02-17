Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7BB161D63
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgBQWg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:36:57 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34626 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgBQWg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:36:56 -0500
Received: by mail-qk1-f196.google.com with SMTP id c20so17767596qkm.1
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uo9kSdZ3WMOjPjnxhZzwPm3etI2GMqLIwfvDqeGLBmc=;
        b=SQdaaLBhUXmr5SgBrjGtHmGNCwaAT7UK5chRn2iZHKNNjM5W15XRgpoPUVJptegNaG
         m+WJ62FGccDWrmKlvvS6p9P8SZRuh7X5yMPQMhsg/x02E4hKhJXVkC32nxjqJMVZMxdw
         VJy5CFmMKIeoK3AQV+PL/WkY0fXFOQdMb2/igw/vtSRxxA2slyEAeuNbPC+ucx/Tzgpr
         ZAVSWR0sfZDNbsJh0kG3v6YO2kt/r0bhVPangyHRz1SOwL+9XUsRGQ2x1YR3OGhvPcK6
         GHrhfj/nIEMsMU4n4eilW59h9NdcrPskJpuikCnAqyiKmarYNR9Dw5kv0Po77SmFSe6r
         IFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uo9kSdZ3WMOjPjnxhZzwPm3etI2GMqLIwfvDqeGLBmc=;
        b=jtcBBt10DOmpK5DNQyFb/SiPsQbOQz5XyEDiqeF/bxqsayc80YMUgd+9UJMtBX2nmd
         IumjPBW6P3U/BW4GlJKgZPGq/tzsGprWSJuxp34j3Duni6RaZsDMQ+gaCHuKh7vvJEbB
         xR3l9wXX4qHSdY8Hh0gZ6VFpZBQIIhBptnJoqCYCBArGIzVYpOx5FXYi7yaSqm66cM1b
         nwAz7iiIg0wQbtrS1ctaL7FzUKQjtRs1eLV/6iU92Qw90/JDMhPRPEiBcnl6Mt6KR2/C
         M+5puTHgICzhBvUQsp7glOLNqeBZcihzj8JH+OTfdT2KT9HDY9a9stdf4yks4cvDLPm8
         jCuw==
X-Gm-Message-State: APjAAAUWkE09pEt3NtVPw8XT9zhyGsnCzXTWghznEplQAIFdIsMnrjN1
        qJDhHRi8ZMDv2ysfhfT3bRk=
X-Google-Smtp-Source: APXvYqz2WlbLgGm3ycHSs6BY7tymqKQ0ilW/MXrKoTPjADQccdxtavkYTc/gJvNoK/8vk8b235soWA==
X-Received: by 2002:a37:8343:: with SMTP id f64mr15682364qkd.21.1581979015705;
        Mon, 17 Feb 2020 14:36:55 -0800 (PST)
Received: from localhost.localdomain ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id a2sm964031qka.75.2020.02.17.14.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:36:55 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PACTH net-next 4/5] net: add net available in build_state
Date:   Mon, 17 Feb 2020 17:35:40 -0500
Message-Id: <20200217223541.18862-5-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200217223541.18862-1-alex.aring@gmail.com>
References: <20200217223541.18862-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The build_state callback of lwtunnel doesn't contain the net namespace
structure yet. This patch will add it so we can check on specific
address configuration at creation time of rpl source routes.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 include/net/ip_fib.h      |  5 +++--
 include/net/lwtunnel.h    |  4 ++--
 net/core/lwt_bpf.c        |  2 +-
 net/core/lwtunnel.c       |  4 ++--
 net/ipv4/fib_lookup.h     |  2 +-
 net/ipv4/fib_semantics.c  | 22 ++++++++++++----------
 net/ipv4/fib_trie.c       |  2 +-
 net/ipv4/ip_tunnel_core.c |  4 ++--
 net/ipv6/ila/ila_lwt.c    |  2 +-
 net/ipv6/route.c          |  2 +-
 net/ipv6/seg6_iptunnel.c  |  2 +-
 net/ipv6/seg6_local.c     |  5 +++--
 net/mpls/mpls_iptunnel.c  |  2 +-
 13 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 6a1ae49809de..74f86ebbfcdf 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -470,8 +470,9 @@ int fib_nh_init(struct net *net, struct fib_nh *fib_nh,
 		struct fib_config *cfg, int nh_weight,
 		struct netlink_ext_ack *extack);
 void fib_nh_release(struct net *net, struct fib_nh *fib_nh);
-int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *fc_encap,
-		       u16 fc_encap_type, void *cfg, gfp_t gfp_flags,
+int fib_nh_common_init(struct net *net, struct fib_nh_common *nhc,
+		       struct nlattr *fc_encap, u16 fc_encap_type,
+		       void *cfg, gfp_t gfp_flags,
 		       struct netlink_ext_ack *extack);
 void fib_nh_common_release(struct fib_nh_common *nhc);
 
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index 5d6c5b1fc695..a7f0a857cadf 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -34,7 +34,7 @@ struct lwtunnel_state {
 };
 
 struct lwtunnel_encap_ops {
-	int (*build_state)(struct nlattr *encap,
+	int (*build_state)(struct net *net, struct nlattr *encap,
 			   unsigned int family, const void *cfg,
 			   struct lwtunnel_state **ts,
 			   struct netlink_ext_ack *extack);
@@ -113,7 +113,7 @@ int lwtunnel_valid_encap_type(u16 encap_type,
 			      struct netlink_ext_ack *extack);
 int lwtunnel_valid_encap_type_attr(struct nlattr *attr, int len,
 				   struct netlink_ext_ack *extack);
-int lwtunnel_build_state(u16 encap_type,
+int lwtunnel_build_state(struct net *net, u16 encap_type,
 			 struct nlattr *encap,
 			 unsigned int family, const void *cfg,
 			 struct lwtunnel_state **lws,
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 99a6de52b21d..7d3438215f32 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -367,7 +367,7 @@ static const struct nla_policy bpf_nl_policy[LWT_BPF_MAX + 1] = {
 	[LWT_BPF_XMIT_HEADROOM]	= { .type = NLA_U32 },
 };
 
-static int bpf_build_state(struct nlattr *nla,
+static int bpf_build_state(struct net *net, struct nlattr *nla,
 			   unsigned int family, const void *cfg,
 			   struct lwtunnel_state **ts,
 			   struct netlink_ext_ack *extack)
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 2f9c0de533c7..4cd03955fa32 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -98,7 +98,7 @@ int lwtunnel_encap_del_ops(const struct lwtunnel_encap_ops *ops,
 }
 EXPORT_SYMBOL_GPL(lwtunnel_encap_del_ops);
 
-int lwtunnel_build_state(u16 encap_type,
+int lwtunnel_build_state(struct net *net, u16 encap_type,
 			 struct nlattr *encap, unsigned int family,
 			 const void *cfg, struct lwtunnel_state **lws,
 			 struct netlink_ext_ack *extack)
@@ -122,7 +122,7 @@ int lwtunnel_build_state(u16 encap_type,
 	rcu_read_unlock();
 
 	if (found) {
-		ret = ops->build_state(encap, family, cfg, lws, extack);
+		ret = ops->build_state(net, encap, family, cfg, lws, extack);
 		if (ret)
 			module_put(ops->owner);
 	} else {
diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index c092e9a55790..818916b2a04d 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -35,7 +35,7 @@ static inline void fib_alias_accessed(struct fib_alias *fa)
 void fib_release_info(struct fib_info *);
 struct fib_info *fib_create_info(struct fib_config *cfg,
 				 struct netlink_ext_ack *extack);
-int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
+int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		 struct netlink_ext_ack *extack);
 bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi);
 int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a803cdd9400a..04494f8a5c65 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -570,8 +570,9 @@ static int fib_detect_death(struct fib_info *fi, int order,
 	return 1;
 }
 
-int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *encap,
-		       u16 encap_type, void *cfg, gfp_t gfp_flags,
+int fib_nh_common_init(struct net *net, struct fib_nh_common *nhc,
+		       struct nlattr *encap, u16 encap_type,
+		       void *cfg, gfp_t gfp_flags,
 		       struct netlink_ext_ack *extack)
 {
 	int err;
@@ -589,8 +590,9 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *encap,
 			err = -EINVAL;
 			goto lwt_failure;
 		}
-		err = lwtunnel_build_state(encap_type, encap, nhc->nhc_family,
-					   cfg, &lwtstate, extack);
+		err = lwtunnel_build_state(net, encap_type, encap,
+					   nhc->nhc_family, cfg, &lwtstate,
+					   extack);
 		if (err)
 			goto lwt_failure;
 
@@ -614,7 +616,7 @@ int fib_nh_init(struct net *net, struct fib_nh *nh,
 
 	nh->fib_nh_family = AF_INET;
 
-	err = fib_nh_common_init(&nh->nh_common, cfg->fc_encap,
+	err = fib_nh_common_init(net, &nh->nh_common, cfg->fc_encap,
 				 cfg->fc_encap_type, cfg, GFP_KERNEL, extack);
 	if (err)
 		return err;
@@ -814,7 +816,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 
 #endif /* CONFIG_IP_ROUTE_MULTIPATH */
 
-static int fib_encap_match(u16 encap_type,
+static int fib_encap_match(struct net *net, u16 encap_type,
 			   struct nlattr *encap,
 			   const struct fib_nh *nh,
 			   const struct fib_config *cfg,
@@ -826,7 +828,7 @@ static int fib_encap_match(u16 encap_type,
 	if (encap_type == LWTUNNEL_ENCAP_NONE)
 		return 0;
 
-	ret = lwtunnel_build_state(encap_type, encap, AF_INET,
+	ret = lwtunnel_build_state(net, encap_type, encap, AF_INET,
 				   cfg, &lwtstate, extack);
 	if (!ret) {
 		result = lwtunnel_cmp_encap(lwtstate, nh->fib_nh_lws);
@@ -836,7 +838,7 @@ static int fib_encap_match(u16 encap_type,
 	return result;
 }
 
-int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
+int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		 struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
@@ -857,8 +859,8 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
 		struct fib_nh *nh = fib_info_nh(fi, 0);
 
 		if (cfg->fc_encap) {
-			if (fib_encap_match(cfg->fc_encap_type, cfg->fc_encap,
-					    nh, cfg, extack))
+			if (fib_encap_match(net, cfg->fc_encap_type,
+					    cfg->fc_encap, nh, cfg, extack))
 				return 1;
 		}
 #ifdef CONFIG_IP_ROUTE_CLASSID
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ff0c24371e33..196b265030f7 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1684,7 +1684,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 		     fi->fib_prefsrc == cfg->fc_prefsrc) &&
 		    (!cfg->fc_protocol ||
 		     fi->fib_protocol == cfg->fc_protocol) &&
-		    fib_nh_match(cfg, fi, extack) == 0 &&
+		    fib_nh_match(net, cfg, fi, extack) == 0 &&
 		    fib_metrics_match(cfg, fi)) {
 			fa_to_delete = fa;
 			break;
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 47f8b947eef1..181b7a2a0247 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -432,7 +432,7 @@ static int ip_tun_set_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 	return ip_tun_parse_opts(attr, info, extack);
 }
 
-static int ip_tun_build_state(struct nlattr *attr,
+static int ip_tun_build_state(struct net *net, struct nlattr *attr,
 			      unsigned int family, const void *cfg,
 			      struct lwtunnel_state **ts,
 			      struct netlink_ext_ack *extack)
@@ -719,7 +719,7 @@ static const struct nla_policy ip6_tun_policy[LWTUNNEL_IP6_MAX + 1] = {
 	[LWTUNNEL_IP6_OPTS]		= { .type = NLA_NESTED },
 };
 
-static int ip6_tun_build_state(struct nlattr *attr,
+static int ip6_tun_build_state(struct net *net, struct nlattr *attr,
 			       unsigned int family, const void *cfg,
 			       struct lwtunnel_state **ts,
 			       struct netlink_ext_ack *extack)
diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index 422dcc691f71..8c1ce78956ba 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -125,7 +125,7 @@ static const struct nla_policy ila_nl_policy[ILA_ATTR_MAX + 1] = {
 	[ILA_ATTR_HOOK_TYPE] = { .type = NLA_U8, },
 };
 
-static int ila_build_state(struct nlattr *nla,
+static int ila_build_state(struct net *net, struct nlattr *nla,
 			   unsigned int family, const void *cfg,
 			   struct lwtunnel_state **ts,
 			   struct netlink_ext_ack *extack)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4fbdc60b4e07..7283c9abeaa8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3475,7 +3475,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	    !netif_carrier_ok(dev))
 		fib6_nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 
-	err = fib_nh_common_init(&fib6_nh->nh_common, cfg->fc_encap,
+	err = fib_nh_common_init(net, &fib6_nh->nh_common, cfg->fc_encap,
 				 cfg->fc_encap_type, cfg, gfp_flags, extack);
 	if (err)
 		goto out;
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index ab7f124ff5d7..7f64bb668d40 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -376,7 +376,7 @@ static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	return err;
 }
 
-static int seg6_build_state(struct nlattr *nla,
+static int seg6_build_state(struct net *net, struct nlattr *nla,
 			    unsigned int family, const void *cfg,
 			    struct lwtunnel_state **ts,
 			    struct netlink_ext_ack *extack)
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 7cbc19731997..e3f1a292aa01 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -970,8 +970,9 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	return 0;
 }
 
-static int seg6_local_build_state(struct nlattr *nla, unsigned int family,
-				  const void *cfg, struct lwtunnel_state **ts,
+static int seg6_local_build_state(struct net *net, struct nlattr *nla,
+				  unsigned int family, const void *cfg,
+				  struct lwtunnel_state **ts,
 				  struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[SEG6_LOCAL_MAX + 1];
diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 44b675016393..2def85718d94 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -162,7 +162,7 @@ static int mpls_xmit(struct sk_buff *skb)
 	return -EINVAL;
 }
 
-static int mpls_build_state(struct nlattr *nla,
+static int mpls_build_state(struct net *net, struct nlattr *nla,
 			    unsigned int family, const void *cfg,
 			    struct lwtunnel_state **ts,
 			    struct netlink_ext_ack *extack)
-- 
2.20.1

