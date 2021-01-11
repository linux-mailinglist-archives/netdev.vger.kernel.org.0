Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950352F2089
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403823AbhAKURB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391382AbhAKURA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:17:00 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ABEC061794;
        Mon, 11 Jan 2021 12:16:19 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q7so393710pgm.5;
        Mon, 11 Jan 2021 12:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fdRtUN0vRfDIgoyI5IKMd32l9LrJZSebJr2uosM4FH8=;
        b=rhTxTlp17JDo/Jq6WvAxkEU1qFHfUoLFOGLKO7yXjROIN7zKN8kHdloRMA0liB+tbl
         wfZDsZ8pSmVFD+8bA8RNy/SndBObj0sRZBgz5winwOSwRwLeZvGY+fVtgARDhm1tGpIN
         G1to/Eklstxd2urW7BrnzoKyKMleqwbGYDo7gO7WKmyNw0C5R6JR6dzknw3BcJQ0OWZU
         FT/Gtxfgsmckw+WkC96Gd3EFSrT38vMqF3ja/tcfNUgo7Gn177CLQxxLeSBGRnuJ6ezP
         Jkmy5xP3Uasg37+EbGhiXxYAZTsXh09xD65olRnDJCbM0BuWt81mTZMl6g8GXXZIqmWi
         ZuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fdRtUN0vRfDIgoyI5IKMd32l9LrJZSebJr2uosM4FH8=;
        b=SgWndCZiALZqA7n9eej9FpXq2gsvR2+VdLnFTpOawrpgZ+87YYM6SVr9RN6xbSBVPn
         dFvqDNisuQDFOON4PtFXWqUHyyjDNtANol3ZMFtcUZGC0cBqdGuBu/R2kVPZGWu9hFmm
         TgXz8xPkIj5aBK/27fStzUE+tARBYhKloU5lgplrKxK+7mHNbvBFuixCZVtWRCmNiHL7
         f033LnZ90z4et6TmCAphu1StwqT8EVVvTUkVHjBPn1IQg2Qi953QX7lNUaZ9D5gU9RyI
         TJfRheGKuwZOnd1S1yW+AfRA+AId0n94B4xxTA4B+ls51OHE+9J5lbUmKgrMUD839bQr
         7Oyg==
X-Gm-Message-State: AOAM5305r3VZM47nIBzTRZ2QgJ3aQDL9Ja7RaMfwmZYrqYhyIKuCuKgE
        RBF75ztzl6odzhILwMaBKw==
X-Google-Smtp-Source: ABdhPJyQ8ga5gZKZ7xLZqkxuDgItmBaLV/mt1zSRov2rDyErY8m/WYoBaBW6qlp8XCjz7XRAtPPUYQ==
X-Received: by 2002:a63:e14a:: with SMTP id h10mr1188532pgk.297.1610396179522;
        Mon, 11 Jan 2021 12:16:19 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id t25sm591278pgv.30.2021.01.11.12.16.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 12:16:19 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v0 net-next 1/1] Allow user to set metric on default route learned via Router Advertisement. Router Advertisement.
Date:   Mon, 11 Jan 2021 12:16:10 -0800
Message-Id: <20210111201610.2425-2-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210111201610.2425-1-pchaudhary@linkedin.com>
References: <20210111201610.2425-1-pchaudhary@linkedin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Zhenggen Xu
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
index dd2b12a32b73..073c1f3f8429 100644
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
index dda61d150a13..19af90c77200 100644
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
index 2a5277758379..a470bdab2420 100644
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
index 13e8751bf24a..945de5de5144 100644
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
index 458179df9b27..5e79c196e33c 100644
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
index eff2cacd5209..702ec4a33936 100644
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
@@ -6667,6 +6670,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "accept_ra_defrtr_metric",
+		.data		= &ipv6_devconf.accept_ra_defrtr_metric,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "accept_ra_min_hop_limit",
 		.data		= &ipv6_devconf.accept_ra_min_hop_limit,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 76717478f173..05f7f246a768 100644
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
index 188e114b29b4..249b211362cd 100644
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
2.29.0

