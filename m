Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF82E773C
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 09:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgL3ItW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 03:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgL3ItV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 03:49:21 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB60C06179B;
        Wed, 30 Dec 2020 00:48:40 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g3so8408606plp.2;
        Wed, 30 Dec 2020 00:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=stjJ/ZyqK3D4lx+sldwpApKZ5c34uuiZLq2vtS6ffDM=;
        b=K81fRK/+sadqnxCZgdyE92pL3ojeLvrQKtFJbi+gkPUX2ZYe4dBcvFeG63zBjY6aJa
         TVJU66YYWwNu4JHE+I54hKxLCEFIl7ZFJULYIA6BVV+IOrwSAjiCBBb5hMaXRo99lhwp
         ibOM0bARBuPN6cqXu/6ykNchxQSjmT/bjTyrbHzBiRuh246gU/0cm18L3UcLdAWzzvVt
         TY0KMrMFP8Ddw4tKl/FRrWZXmc6laZivz817+HkpzBRkOUcBi6QdcEbERNLUBBtwvUBK
         IRcpxfZkbPUnvXOUBUkEJMpHOOP5sFSaV4hmnEUcI2YTl5vyhKtfgpHeLBPOrl5zbFuK
         nJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=stjJ/ZyqK3D4lx+sldwpApKZ5c34uuiZLq2vtS6ffDM=;
        b=B1bpMzIDmdTc0jcK5wv8HZp9TNgKdvQVyHS/yHFeex6tySfD8uJFoj0RtrvN7FVfvu
         2JDnSaCupLPuZ2YxSoo50GHfLvPYrXTyLqE+EbYAa8upDpjTprQjIYQsa0hidWHilX+j
         a+nV0DwxIrF8G4hsd2Ppw6p/bbGkgB17f8BfTamGvrGZrs/vs6feT0Si74otWucr/LnO
         pDF1Pm5YY9blTZGhM+TEiK8xxKzpQJ0JaRO/FDjMv+NcFHKmeudhFYinr+K85l8DxBng
         seBMgBuoln5qsAc/EGaD/LoU6u5evhoejUB7XWLsKBZTB1hbuMafhwgDJHfh4WFHz8ru
         E7Vw==
X-Gm-Message-State: AOAM532bXtiYzamfZ/uTJrzC2b5NssvFs7W0iR1mU2BDtLvg4+G9L59P
        ZZcn+vVixP0nECNcQLsf1w==
X-Google-Smtp-Source: ABdhPJxeU5Yalywof3N6PmsuMe8Dm5rgHkLM6/HGFd0H4jEs7n3KpK5/bM/7MOpHz1JaZyHFgJ+APQ==
X-Received: by 2002:a17:902:59dc:b029:da:84c7:f175 with SMTP id d28-20020a17090259dcb02900da84c7f175mr29348656plj.75.1609318120390;
        Wed, 30 Dec 2020 00:48:40 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id h1sm30907643pgj.59.2020.12.30.00.48.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Dec 2020 00:48:39 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu1@linkedin.com>
Subject: [PATCH] Allow user to set metric on default route learned via Router Advertisement.
Date:   Wed, 30 Dec 2020 00:48:33 -0800
Message-Id: <1609318113-12770-2-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609318113-12770-1-git-send-email-pchaudhary@linkedin.com>
References: <1609318113-12770-1-git-send-email-pchaudhary@linkedin.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix:
For IPv4, default route is learned via DHCPv4 and user is allowed to change
metric using config etc/network/interfaces. But for IPv6, default route can
be learned via RA, for which, currently a fixed metric value 1024 is used.

Ideally, user should be able to configure metric on default route for IPv6
similar to IPv4. This fix adds sysctl for the same.

Signed-off-by: Praveen Chaudhary<pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu<zxu1@linkedin.com>
---
 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 include/linux/ipv6.h                   |  1 +
 include/net/ip6_route.h                |  3 ++-
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv6/addrconf.c                    | 10 ++++++++++
 net/ipv6/ndisc.c                       | 15 +++++++++++----
 net/ipv6/route.c                       |  8 +++++---
 8 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dd2b12a..073c1f3 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1871,6 +1871,14 @@ accept_ra_defrtr - BOOLEAN
 		- enabled if accept_ra is enabled.
 		- disabled if accept_ra is disabled.
 
+accept_ra_defrtr_metric - INTEGER
+	Metric for default router learned in Router Advertisement.
+
+	Functional default:
+
+		* 0 if accept_ra_defrtr is enabled.
+		* Ignored, if accept_ra_defrtr is enabled.
+
 accept_ra_from_local - BOOLEAN
 	Accept RA with source-address that is found on local machine
 	if the RA is otherwise proper and able to be accepted.
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index dda61d1..19af90c 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -31,6 +31,7 @@ struct ipv6_devconf {
 	__s32		max_desync_factor;
 	__s32		max_addresses;
 	__s32		accept_ra_defrtr;
+	__s32		accept_ra_defrtr_metric;
 	__s32		accept_ra_min_hop_limit;
 	__s32		accept_ra_pinfo;
 	__s32		ignore_routes_with_linkdown;
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2a52777..a470bda 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -174,7 +174,8 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
 				     struct net_device *dev);
 struct fib6_info *rt6_add_dflt_router(struct net *net,
 				     const struct in6_addr *gwaddr,
-				     struct net_device *dev, unsigned int pref);
+				     struct net_device *dev, unsigned int pref,
+				     unsigned int defrtr_usr_metric);
 
 void rt6_purge_dflt_routers(struct net *net);
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 13e8751..945de5d 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -189,6 +189,7 @@ enum {
 	DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
+	DEVCONF_ACCEPT_RA_DEFRTR_METRIC,
 	DEVCONF_MAX
 };
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 458179d..5e79c19 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -571,6 +571,7 @@ enum {
 	NET_IPV6_ACCEPT_SOURCE_ROUTE=25,
 	NET_IPV6_ACCEPT_RA_FROM_LOCAL=26,
 	NET_IPV6_ACCEPT_RA_RT_INFO_MIN_PLEN=27,
+	NET_IPV6_ACCEPT_RA_DEFRTR_METRIC=28,
 	__NET_IPV6_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index eff2cac..702ec4a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -205,6 +205,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.max_desync_factor	= MAX_DESYNC_FACTOR,
 	.max_addresses		= IPV6_MAX_ADDRESSES,
 	.accept_ra_defrtr	= 1,
+	.accept_ra_defrtr_metric = 0,
 	.accept_ra_from_local	= 0,
 	.accept_ra_min_hop_limit= 1,
 	.accept_ra_pinfo	= 1,
@@ -260,6 +261,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.max_desync_factor	= MAX_DESYNC_FACTOR,
 	.max_addresses		= IPV6_MAX_ADDRESSES,
 	.accept_ra_defrtr	= 1,
+	.accept_ra_defrtr_metric = 0,
 	.accept_ra_from_local	= 0,
 	.accept_ra_min_hop_limit= 1,
 	.accept_ra_pinfo	= 1,
@@ -5475,6 +5477,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_MAX_DESYNC_FACTOR] = cnf->max_desync_factor;
 	array[DEVCONF_MAX_ADDRESSES] = cnf->max_addresses;
 	array[DEVCONF_ACCEPT_RA_DEFRTR] = cnf->accept_ra_defrtr;
+	array[DEVCONF_ACCEPT_RA_DEFRTR_METRIC] = cnf->accept_ra_defrtr_metric;
 	array[DEVCONF_ACCEPT_RA_MIN_HOP_LIMIT] = cnf->accept_ra_min_hop_limit;
 	array[DEVCONF_ACCEPT_RA_PINFO] = cnf->accept_ra_pinfo;
 #ifdef CONFIG_IPV6_ROUTER_PREF
@@ -6668,6 +6671,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "accept_ra_defrtr_metric",
+		.data		= &ipv6_devconf.accept_ra_defrtr_metric,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "accept_ra_min_hop_limit",
 		.data		= &ipv6_devconf.accept_ra_min_hop_limit,
 		.maxlen		= sizeof(int),
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 7671747..05f7f24 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1180,6 +1180,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	unsigned int pref = 0;
 	__u32 old_if_flags;
 	bool send_ifinfo_notify = false;
+	unsigned int defrtr_usr_metric = 0;
 
 	__u8 *opt = (__u8 *)(ra_msg + 1);
 
@@ -1303,18 +1304,24 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 			return;
 		}
 	}
-	if (rt && lifetime == 0) {
+
+	defrtr_usr_metric = in6_dev->cnf.accept_ra_defrtr_metric;
+	/* default metric is IP6_RT_PRIO_USER */
+	if (defrtr_usr_metric == 0)
+		defrtr_usr_metric = IP6_RT_PRIO_USER;
+	/* delete the route if lifetime is 0 or if new metric is needed */
+	if (rt && (lifetime == 0 || rt->rt6i_metric != defrtr_usr_metric))  {
 		ip6_del_rt(net, rt, false);
 		rt = NULL;
 	}
 
-	ND_PRINTK(3, info, "RA: rt: %p  lifetime: %d, for dev: %s\n",
-		  rt, lifetime, skb->dev->name);
+	ND_PRINTK(3, info, "RA: rt: %p  lifetime: %d, metric: %d, for dev: %s\n",
+		  rt, lifetime, defrtr_usr_metric, skb->dev->name);
 	if (!rt && lifetime) {
 		ND_PRINTK(3, info, "RA: adding default router\n");
 
 		rt = rt6_add_dflt_router(net, &ipv6_hdr(skb)->saddr,
-					 skb->dev, pref);
+					 skb->dev, pref, defrtr_usr_metric);
 		if (!rt) {
 			ND_PRINTK(0, err,
 				  "RA: %s failed to add default route\n",
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 188e114..249b211 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4252,11 +4252,12 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
 struct fib6_info *rt6_add_dflt_router(struct net *net,
 				     const struct in6_addr *gwaddr,
 				     struct net_device *dev,
-				     unsigned int pref)
+				     unsigned int pref,
+				     unsigned int defrtr_usr_metric)
 {
 	struct fib6_config cfg = {
 		.fc_table	= l3mdev_fib_table(dev) ? : RT6_TABLE_DFLT,
-		.fc_metric	= IP6_RT_PRIO_USER,
+		.fc_metric	= defrtr_usr_metric ? defrtr_usr_metric : IP6_RT_PRIO_USER,
 		.fc_ifindex	= dev->ifindex,
 		.fc_flags	= RTF_GATEWAY | RTF_ADDRCONF | RTF_DEFAULT |
 				  RTF_UP | RTF_EXPIRES | RTF_PREF(pref),
@@ -4266,7 +4267,8 @@ struct fib6_info *rt6_add_dflt_router(struct net *net,
 		.fc_nlinfo.nlh = NULL,
 		.fc_nlinfo.nl_net = net,
 	};
-
+    ND_PRINTK(3, info, "RA: metric: %d for dev: %s\n",
+              cfg.fc_metric, dev->name);
 	cfg.fc_gateway = *gwaddr;
 
 	if (!ip6_route_add(&cfg, GFP_ATOMIC, NULL)) {
-- 
2.7.4

