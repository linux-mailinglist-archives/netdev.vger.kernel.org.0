Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD152F73F7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbhAOICw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732113AbhAOICu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 03:02:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068B6C061575;
        Fri, 15 Jan 2021 00:02:10 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j13so4747134pjz.3;
        Fri, 15 Jan 2021 00:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zLF4fV86SRQDVgeUDT3hPst+ReZobQLZUKPgR6M+yC0=;
        b=XEP4Ah7bWV8dI+9wU73E06Cgrm9EeKdpTK8UKzPDFzVLTqedryf3HB8AdwVtfsimeH
         /Q9QuC7Crx6C59YTJzY9ao7szbuz2Dy1X7YND9VWP+s6SPAe9jds78qgufnISGkmcYEN
         EJhPAjEENb6JkwraVcldcjyblW34ICex/LtfY/0BhGWVVOXyI/6dGz3xVhFtGJP9pIqJ
         GUxubqr4XtvQtE8IpYMAfMq7Wt3UfMT6+j/efDIpcotH2AxT/fJ4Pxdpcm2k4SIXzcIs
         r8qH7C1QIo4X9c+K/7+2l4SPXpy0JWrRUeuI5DuHTO7EAWftKlhCxTpFoLuIiTWkF97o
         XGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zLF4fV86SRQDVgeUDT3hPst+ReZobQLZUKPgR6M+yC0=;
        b=oJVwD1d6BTjyYBAfxtoZ8wkFUhtX6mi18/8kvlus+9vPFbRSSH/jLEAX+IOe6OMLwq
         9ByG8yOb57FEYDRcaMiGPpqny5fayNtNe3aKFltzkM7t9oLEQVuWiG300lkTd9CENS/z
         nRa0x6qvH9yS2NB//Z4JLWJohARq9BAVotg8QGl0Q/W5XTxvSCUiBz8sUzHL+6D/9Lu5
         kGc/gFgl1ypB7o81hGFLlf5sQBERHCeSgkBMBsb1INIhAJAAtFJ94B6NYmGR+MYQllts
         oR8L2yIOexQm+pkPRKcCZJF7ONhJfwKxFflzbOyGmJwigb2J4pda+zLRxF8ZdwGlvgpU
         fV0Q==
X-Gm-Message-State: AOAM531chPG14J/NJYGD2u5YwWZde4GWGPBn6ZJzrZTBhobQKBdPztMF
        avK9RcDun3BEd8ZmhScToQ==
X-Google-Smtp-Source: ABdhPJziglyCdJ5TP6GEcI1Gl8Z/6lpjSaer4JBKUpuymURYG91eHw65BkGM8yKrxQPA/XJ/NVdCJw==
X-Received: by 2002:a17:90a:5a86:: with SMTP id n6mr9446585pji.65.1610697729225;
        Fri, 15 Jan 2021 00:02:09 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id z11sm7546137pjn.5.2021.01.15.00.02.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 00:02:08 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>
Subject: [PATCH v2 net-next 1/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Fri, 15 Jan 2021 00:02:03 -0800
Message-Id: <20210115080203.8889-1-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPv4, default route is learned via DHCPv4 and user is allowed to change
metric using config etc/network/interfaces. But for IPv6, default route can
be learned via RA, for which, currently a fixed metric value 1024 is used.

Ideally, user should be able to configure metric on default route for IPv6
similar to IPv4. This fix adds sysctl for the same.

Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu <zxu@linkedin.com>

Changes in v1.
---
1.) Correct the call to rt6_add_dflt_router.
---

Changes in v2.
[Refer: lkml.org/lkml/2021/1/14/1400]
---
1.) Replace accept_ra_defrtr_metric to ra_defrtr_metric.
2.) Change Type to __u32 instead of __s32.
3.) Change description in Documentation/networking/ip-sysctl.rst.
4.) Use proc_douintvec instead of proc_dointvec.
5.) Code style in ndisc_router_discovery().
6.) Change Type to u32 instead of unsigned int.
---

Logs:
----------------------------------------------------------------
For IPv4:
----------------------------------------------------------------

Config in etc/network/interfaces
----------------------------------------------------------------
```
auto eth0
iface eth0 inet dhcp
    metric 4261413864
```

IPv4 Kernel Route Table:
----------------------------------------------------------------
```
$ ip route list
default via 172.21.47.1 dev eth0 metric 4261413864
```

FRR Table, if a static route is configured.
[In real scenario, it is useful to prefer BGP learned default route over DHCPv4 default route.]
----------------------------------------------------------------
```
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, P - PIM, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       > - selected route, * - FIB route

S>* 0.0.0.0/0 [20/0] is directly connected, eth0, 00:00:03
K   0.0.0.0/0 [254/1000] via 172.21.47.1, eth0, 6d08h51m
```
----------------------------------------------------------------

***i.e. User can prefer Default Router learned via Routing Protocol in IPv4.***
***Similar behavior is not possible for IPv6, without this fix.***

----------------------------------------------------------------
After fix [for IPv6]:
----------------------------------------------------------------
```
sudo sysctl -w net.ipv6.conf.eth0.net.ipv6.conf.eth0.ra_defrtr_metric=1996489705
```

IP monitor: [When IPv6 RA is received]
----------------------------------------------------------------
```
default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  pref high
```

Kernel IPv6 routing table
----------------------------------------------------------------
```
$ ip -6 route list
default via fe80::be16:65ff:feb3:ce8e dev eth0 proto ra metric 1996489705 expires 21sec hoplimit 64 pref high
```

FRR Table, if a static route is configured.
[In real scenario, it is useful to prefer BGP learned default route over IPv6 RA default route.]
----------------------------------------------------------------
```
Codes: K - kernel route, C - connected, S - static, R - RIPng,
       O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
       v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       > - selected route, * - FIB route

S>* ::/0 [20/0] is directly connected, eth0, 00:00:06
K   ::/0 [119/1001] via fe80::xx16:xxxx:feb3:ce8e, eth0, 6d07h43m
```

If the metric is changed later, the effect will be seen only when next IPv6
RA is received, because the default route must be fully controlled by RA msg.
Below metric is changed from 1996489705 to 1996489704.
----------------------------------------------------------------
```
$ sudo sysctl -w net.ipv6.conf.eth0.ra_defrtr_metric=1996489704
net.ipv6.conf.eth0.ra_defrtr_metric = 1996489704
```

IP monitor:
[On next IPv6 RA msg, Kernel deletes prev route and installs new route with updated metric]
----------------------------------------------------------------
```
Deleted default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  expires 3sec hoplimit 64 pref high
default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489704  pref high
```
---
 Documentation/networking/ip-sysctl.rst | 12 ++++++++++++
 include/linux/ipv6.h                   |  1 +
 include/net/ip6_route.h                |  3 ++-
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv6/addrconf.c                    | 10 ++++++++++
 net/ipv6/ndisc.c                       | 14 ++++++++++----
 net/ipv6/route.c                       |  5 +++--
 8 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dd2b12a32b73..c4b8d4b8d213 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1871,6 +1871,18 @@ accept_ra_defrtr - BOOLEAN
 		- enabled if accept_ra is enabled.
 		- disabled if accept_ra is disabled.
 
+ra_defrtr_metric - INTEGER
+	Route metric for default route learned in Router Advertisement. This value
+	will be assigned as metric for the default route learned via IPv6 Router
+	Advertisement. Takes affect only if accept_ra_defrtr' is enabled.
+
+	Possible values are:
+		0:
+			default value will be used for route metric
+			i.e. IP6_RT_PRIO_USER 1024.
+		1 to 0xFFFFFFFF:
+			current value will be used for route metric.
+
 accept_ra_from_local - BOOLEAN
 	Accept RA with source-address that is found on local machine
 	if the RA is otherwise proper and able to be accepted.
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index dda61d150a13..9d1f29f0c512 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -31,6 +31,7 @@ struct ipv6_devconf {
 	__s32		max_desync_factor;
 	__s32		max_addresses;
 	__s32		accept_ra_defrtr;
+	__u32		ra_defrtr_metric;
 	__s32		accept_ra_min_hop_limit;
 	__s32		accept_ra_pinfo;
 	__s32		ignore_routes_with_linkdown;
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2a5277758379..f51a118bfce8 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -174,7 +174,8 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
 				     struct net_device *dev);
 struct fib6_info *rt6_add_dflt_router(struct net *net,
 				     const struct in6_addr *gwaddr,
-				     struct net_device *dev, unsigned int pref);
+				     struct net_device *dev, unsigned int pref,
+				     u32 defrtr_usr_metric);
 
 void rt6_purge_dflt_routers(struct net *net);
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 13e8751bf24a..70603775fe91 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -189,6 +189,7 @@ enum {
 	DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
+	DEVCONF_RA_DEFRTR_METRIC,
 	DEVCONF_MAX
 };
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 458179df9b27..1e05d3caa712 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -571,6 +571,7 @@ enum {
 	NET_IPV6_ACCEPT_SOURCE_ROUTE=25,
 	NET_IPV6_ACCEPT_RA_FROM_LOCAL=26,
 	NET_IPV6_ACCEPT_RA_RT_INFO_MIN_PLEN=27,
+	NET_IPV6_RA_DEFRTR_METRIC=28,
 	__NET_IPV6_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index eff2cacd5209..b13d3213e58f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -205,6 +205,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.max_desync_factor	= MAX_DESYNC_FACTOR,
 	.max_addresses		= IPV6_MAX_ADDRESSES,
 	.accept_ra_defrtr	= 1,
+	.ra_defrtr_metric = 0,
 	.accept_ra_from_local	= 0,
 	.accept_ra_min_hop_limit= 1,
 	.accept_ra_pinfo	= 1,
@@ -260,6 +261,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.max_desync_factor	= MAX_DESYNC_FACTOR,
 	.max_addresses		= IPV6_MAX_ADDRESSES,
 	.accept_ra_defrtr	= 1,
+	.ra_defrtr_metric = 0,
 	.accept_ra_from_local	= 0,
 	.accept_ra_min_hop_limit= 1,
 	.accept_ra_pinfo	= 1,
@@ -5475,6 +5477,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_MAX_DESYNC_FACTOR] = cnf->max_desync_factor;
 	array[DEVCONF_MAX_ADDRESSES] = cnf->max_addresses;
 	array[DEVCONF_ACCEPT_RA_DEFRTR] = cnf->accept_ra_defrtr;
+	array[DEVCONF_RA_DEFRTR_METRIC] = cnf->ra_defrtr_metric;
 	array[DEVCONF_ACCEPT_RA_MIN_HOP_LIMIT] = cnf->accept_ra_min_hop_limit;
 	array[DEVCONF_ACCEPT_RA_PINFO] = cnf->accept_ra_pinfo;
 #ifdef CONFIG_IPV6_ROUTER_PREF
@@ -6667,6 +6670,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "ra_defrtr_metric",
+		.data		= &ipv6_devconf.ra_defrtr_metric,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec,
+	},
 	{
 		.procname	= "accept_ra_min_hop_limit",
 		.data		= &ipv6_devconf.accept_ra_min_hop_limit,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 76717478f173..2bffed49f5c0 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1173,6 +1173,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	struct neighbour *neigh = NULL;
 	struct inet6_dev *in6_dev;
 	struct fib6_info *rt = NULL;
+	u32 defrtr_usr_metric;
 	struct net *net;
 	int lifetime;
 	struct ndisc_options ndopts;
@@ -1303,18 +1304,23 @@ static void ndisc_router_discovery(struct sk_buff *skb)
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
 
 		rt = rt6_add_dflt_router(net, &ipv6_hdr(skb)->saddr,
-					 skb->dev, pref);
+					 skb->dev, pref, defrtr_usr_metric);
 		if (!rt) {
 			ND_PRINTK(0, err,
 				  "RA: %s failed to add default route\n",
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 188e114b29b4..64fe5b51b0c2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4252,11 +4252,12 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
 struct fib6_info *rt6_add_dflt_router(struct net *net,
 				     const struct in6_addr *gwaddr,
 				     struct net_device *dev,
-				     unsigned int pref)
+				     unsigned int pref,
+				     u32 defrtr_usr_metric)
 {
 	struct fib6_config cfg = {
 		.fc_table	= l3mdev_fib_table(dev) ? : RT6_TABLE_DFLT,
-		.fc_metric	= IP6_RT_PRIO_USER,
+		.fc_metric	= defrtr_usr_metric ? : IP6_RT_PRIO_USER,
 		.fc_ifindex	= dev->ifindex,
 		.fc_flags	= RTF_GATEWAY | RTF_ADDRCONF | RTF_DEFAULT |
 				  RTF_UP | RTF_EXPIRES | RTF_PREF(pref),

base-commit: 139711f033f636cc78b6aaf7363252241b9698ef
-- 
2.29.0

