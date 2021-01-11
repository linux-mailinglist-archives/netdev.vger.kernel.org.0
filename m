Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119702F2250
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389096AbhAKV7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKV7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:59:20 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAE2C061794;
        Mon, 11 Jan 2021 13:58:40 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b5so383480pjl.0;
        Mon, 11 Jan 2021 13:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aBXnKLnbF5QBJWOxzxvZrwLpPgIU33au5TIuZ8DUciQ=;
        b=hXw9N8PpOiOjWAjoV07v/RUpwNy0/XJkbGzeSzpQAbJPwdAi2dDUp+0Qy/IcTF5GBY
         K/14xQzFM0saAW/lY/n3dFwfqy3nmV5zeexDIEfYov0FWX2+pJGwcvCF4SJ4+625Su/4
         bFbGa1yGRWvpx/JYjMTM7fhYzeInWgAyOaw78MLWwOEAmByb5s/Q2fHUjO7TFAtJpgEO
         anZDYlbIAT+aqWBe7JvVoAI3ci85MmKpLxnAnGG3iNSlro7huY8YbpAG2Tf4PrUU01x9
         YrjxwyMBIvWl/qttZ4ruaMlwolyCmG3CyPh1EfY3XVCst+oK5pX2PfRC/afZmn4jzf2l
         EUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aBXnKLnbF5QBJWOxzxvZrwLpPgIU33au5TIuZ8DUciQ=;
        b=nXzqkMZWJkeQABB9Ritnn1xGnczcyZ28i8Z+efDFYbLzs1JHJCFSkqVUERHE+wMJL1
         Xk0ALeUKbBbjZxPEF9f5edWv91rxJ04rPyJuEJFJtnQuA272aRExccB17u+APqWptrmS
         7cP1Ze5r90JyAL2RSHad+kPJ2kf391J4CNl8ApxptYm8D8yoOzBF6/M0gPuEstkVtxUs
         CXsPdrTxWP9ex7RZ1TuaLcayT1f/kdkMJwdMo4JWoFaQuVnc44xFpX2A0PhSvKH01iXC
         8u0pxnl3zvO2a0gR71kr3OcqibAP5cG0DpMGyBPYTB1wtsNMmejYY9M7rlPW+wlKb3bo
         cGzQ==
X-Gm-Message-State: AOAM531p31SUks7UMyeTPgEHjDs8DZt1fY7RiYl7E1O9m1hhw1q9NRYX
        vhNwQkgw4VGdt4+hUaJohw==
X-Google-Smtp-Source: ABdhPJzNvJaV0cppcJBUw6uYQ8HHuD4/i1AtZmQuYWaq6Px2L13/5EFZpta2iEX3baeuKfj6UztUFA==
X-Received: by 2002:a17:90a:7842:: with SMTP id y2mr991134pjl.36.1610402319904;
        Mon, 11 Jan 2021 13:58:39 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id z13sm403883pjz.42.2021.01.11.13.58.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 13:58:39 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>
Subject: [PATCH v0 net-next 1/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Mon, 11 Jan 2021 13:58:29 -0800
Message-Id: <20210111215829.3774-2-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210111215829.3774-1-pchaudhary@linkedin.com>
References: <20210111215829.3774-1-pchaudhary@linkedin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPv4, default route is learned via DHCPv4 and user is allowed to change
metric using config etc/network/interfaces. But for IPv6, default route can
be learned via RA, for which, currently a fixed metric value 1024 is used.

Ideally, user should be able to configure metric on default route for IPv6
similar to IPv4. This fix adds sysctl for the same.

Signed-off-by: Praveen Chaudhary<pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu<zxu@linkedin.com>
---
 Documentation/networking/ip-sysctl.rst | 18 ++++++++++++++++++
 include/linux/ipv6.h                   |  1 +
 include/net/ip6_route.h                |  3 ++-
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv6/addrconf.c                    | 10 ++++++++++
 net/ipv6/ndisc.c                       | 12 +++++++++---
 net/ipv6/route.c                       |  5 +++--
 8 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dd2b12a32b73..384159081d91 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1871,6 +1871,24 @@ accept_ra_defrtr - BOOLEAN
 		- enabled if accept_ra is enabled.
 		- disabled if accept_ra is disabled.
 
+accept_ra_defrtr_metric - INTEGER
+	Route metric for default route learned in Router Advertisement. This
+	value will be assigned as metric for the route learned via IPv6 Router
+	Advertisement.
+
+	Possible values are:
+		0:
+			Use default value i.e. IP6_RT_PRIO_USER	1024.
+		0xFFFFFFFF to -1:
+			-ve values represent high route metric, value will be treated as
+			unsigned value. This behaviour is inline with current IPv4 metric
+			shown with commands such as "route -n" or "ip route list".
+		1 to 0x7FFFFFF:
+			+ve values will be used as is for route metric.
+
+	Functional default: enabled if accept_ra_defrtr is enabled.
+				disabled if accept_ra_defrtr is disabled.
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
index 76717478f173..955dde8aad22 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1180,6 +1180,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	unsigned int pref = 0;
 	__u32 old_if_flags;
 	bool send_ifinfo_notify = false;
+	unsigned int defrtr_usr_metric = 0;
 
 	__u8 *opt = (__u8 *)(ra_msg + 1);
 
@@ -1303,13 +1304,18 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 			return;
 		}
 	}
-	if (rt && lifetime == 0) {
+	/* Set default route metric if specified by user */
+	defrtr_usr_metric = in6_dev->cnf.accept_ra_defrtr_metric;
+	if (defrtr_usr_metric == 0)
+		defrtr_usr_metric = IP6_RT_PRIO_USER;
+	/* delete the route if lifetime is 0 or if metric needs change */
+	if (rt && ((lifetime == 0) || (rt->fib6_metric != defrtr_usr_metric)))  {
 		ip6_del_rt(net, rt, false);
 		rt = NULL;
 	}
 
-	ND_PRINTK(3, info, "RA: rt: %p  lifetime: %d, for dev: %s\n",
-		  rt, lifetime, skb->dev->name);
+	ND_PRINTK(3, info, "RA: rt: %p  lifetime: %d, metric: %d, for dev: %s\n",
+		  rt, lifetime, defrtr_usr_metric, skb->dev->name);
 	if (!rt && lifetime) {
 		ND_PRINTK(3, info, "RA: adding default router\n");
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 188e114b29b4..5f177ae97e42 100644
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
-- 
2.29.0

