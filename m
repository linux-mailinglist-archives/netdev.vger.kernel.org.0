Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74EC27948B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgIYXMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbgIYXM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:12:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD94DC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:12:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q4so249417pjh.5
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A+onII+/r9IiW++tMMxMEWI4PuRnGp0PoK8WrPTW9tA=;
        b=Q68hfXXSA311F8EKRNq1LHDPM6IoW0L7jIQSzESKceppWiwZ/HvlBzWiXcpMeb4F/w
         i7xbGwsIQNHA6FA4ucUObTexi9qTLAwWgU2lA8Yyu9j+mlqd3pWzNwKiXjd3J+UXVl6a
         GIxyo4x63OV8j5XP9321aWws1ICs3f07XmNNkwT297G1Kn7Qj/ZKeGlDQ4fMzBZ+PyAU
         kcaXnFa2AErwjCot9Y9hlnpb3CI4RKp/cGBlxRCQWJd9jF3hQEmPNI5uBSS4krvjPJ2d
         L6qHkMXvCpuJJMjeCrJc1NZl62WsrDpqLqqg586srY8VA1WDMp6nDcuruTa2oj55ZxZY
         wp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A+onII+/r9IiW++tMMxMEWI4PuRnGp0PoK8WrPTW9tA=;
        b=JVK3G2eXMMp6zlfDmwuiZEVNFBp/8GgRJXTLeDo8xmfRMJDT43sKRC6Zdyzjy6YVXP
         cVK5MmyOchB6oKFz8rbEvpkYrCpjLqgtfLyOjBj63O5hJILqelwMP8Hb4DbUnb1l9dWP
         f1gcwW9v2KpI21xtiX3G/1UKx6ehWSgS3H0U9qpxGDe+2CzRefp6jLwA5zLoW90SKLGU
         j1qzk0oxR202PbSJZTuHZMNC5RbkVn3Zuq88BfFMzoP7Mbe/LTiY6FyiRKNmqMZpX6vJ
         APeuj46z/ZJu95kJ0T5dlWMtBvhTdUyiD1qK1Pwplp1rXxLkr1CEuBP81jt1a9s4tyZI
         dBOA==
X-Gm-Message-State: AOAM533LjDj1dpoNPBqkLvkydaNtjUY5ySnlxqxWMNLKsReCmQMdpqKR
        QhzHcq7qSU7YYl+AL9PoNZaIq4lNEVfwPQ==
X-Google-Smtp-Source: ABdhPJwlaksWld3NTvsSkelWt+OqJhjkvXYZtNIQUzdwds+ffN0rJnVFa3YFKXqN4JYkkz1hiFt7sQ==
X-Received: by 2002:a17:90b:a4b:: with SMTP id gw11mr726242pjb.37.1601075548842;
        Fri, 25 Sep 2020 16:12:28 -0700 (PDT)
Received: from harryc-og.bne.opengear.com (brisbane.opengear.com. [60.241.24.90])
        by smtp.gmail.com with ESMTPSA id q190sm3916417pfq.99.2020.09.25.16.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 16:12:28 -0700 (PDT)
From:   Qingtao Cao <qingtao.cao.au@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, corbet@lwn.net
Cc:     Qingtao Cao <qingtao.cao@digi.com>,
        David Leonard <david.leonard@digi.com>
Subject: [PATCH 1/1] Network: support default route metric per interface
Date:   Sat, 26 Sep 2020 09:11:59 +1000
Message-Id: <20200925231159.945-2-qingtao.cao.au@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925231159.945-1-qingtao.cao.au@gmail.com>
References: <20200925231159.945-1-qingtao.cao.au@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qingtao Cao <qingtao.cao@digi.com>

Add /proc/sys/net/ipv[4|6]/conf/<device>/def_rt_metric sysfs attribute
file for each network interface so that userspace programs can specify
different default route metrics for each interface, which will also be
applied by the kernel when new routes are automatically created for
relevant interfaces, when userspace programs may have not specified
metrics via relevant netlink messages for example.

Signed-off-by: Qingtao Cao <qingtao.cao@digi.com>
Signed-off-by: David Leonard <david.leonard@digi.com>
---
 Documentation/networking/ip-sysctl.rst |  8 +++++
 include/linux/inetdevice.h             |  4 +++
 include/linux/ipv6.h                   |  3 ++
 include/net/ip6_route.h                | 15 ++++++++
 include/uapi/linux/ip.h                |  1 +
 include/uapi/linux/ipv6.h              |  1 +
 net/ipv4/Kconfig                       | 13 +++++++
 net/ipv4/devinet.c                     |  3 ++
 net/ipv4/fib_frontend.c                | 27 ++++++++++++++
 net/ipv6/addrconf.c                    | 30 ++++++++++++++--
 net/ipv6/route.c                       | 50 ++++++++++++++++++++++++--
 11 files changed, 150 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 837d51f9e1fa..b3252591fc31 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1591,6 +1591,10 @@ igmp_link_local_mcast_reports - BOOLEAN
 
 	Default TRUE
 
+def_rt_metric - INTEGER
+	Default metric used for routes when no metric is specified.
+	0 to use system default
+
 Alexey Kuznetsov.
 kuznet@ms2.inr.ac.ru
 
@@ -2264,6 +2268,10 @@ enhanced_dad - BOOLEAN
 
 	Default: TRUE
 
+def_rt_metric - INTEGER
+	Default metric used for routes when no metric is specified.
+	0 to use system default
+
 ``icmp/*``:
 ===========
 
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 3515ca64e638..2904f158e048 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -119,6 +119,10 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 #define IN_DEV_NET_ROUTE_LOCALNET(in_dev, net)	\
 	IN_DEV_NET_ORCONF(in_dev, net, ROUTE_LOCALNET)
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+#define IN_DEV_DEF_RT_METRIC(in_dev)	IN_DEV_CONF_GET((in_dev), DEF_RT_METRIC)
+#endif
+
 #define IN_DEV_RX_REDIRECTS(in_dev) \
 	((IN_DEV_FORWARD(in_dev) && \
 	  IN_DEV_ANDCONF((in_dev), ACCEPT_REDIRECTS)) \
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index a44789d027cc..be399c74c8b2 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -75,6 +75,9 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	__s32           def_rt_metric;
+#endif
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2a5277758379..ca470729d5b9 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -336,4 +336,19 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
 struct neighbour *ip6_neigh_lookup(const struct in6_addr *gw,
 				   struct net_device *dev, struct sk_buff *skb,
 				   const void *daddr);
+
+#ifdef CONFIG_IP_DEF_RT_METRIC
+static inline void rt6_get_dev_dflt_metric(struct net_device *dev, struct fib6_config *cfg)
+{
+	struct inet6_dev *idev = NULL;
+
+	idev = in6_dev_get(dev);
+	if (idev) {
+		if (idev->cnf.def_rt_metric)
+			cfg->fc_metric = idev->cnf.def_rt_metric;
+		in6_dev_put(idev);
+	}
+}
+#endif
+
 #endif
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..de97706b900c 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -169,6 +169,7 @@ enum
 	IPV4_DEVCONF_DROP_UNICAST_IN_L2_MULTICAST,
 	IPV4_DEVCONF_DROP_GRATUITOUS_ARP,
 	IPV4_DEVCONF_BC_FORWARDING,
+	IPV4_DEVCONF_DEF_RT_METRIC,
 	__IPV4_DEVCONF_MAX
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 13e8751bf24a..c4ba9ce53756 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -189,6 +189,7 @@ enum {
 	DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
+	DEVCONF_DEF_RT_METRIC,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 87983e70f03f..529cd5a26e9a 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -457,6 +457,19 @@ config INET_DIAG_DESTROY
 	  had been disconnected.
 	  If unsure, say N.
 
+config IP_DEF_RT_METRIC
+	bool "IP: default route metrics support"
+	help
+	  Allow userspace to specify the default metric for routes per network
+	  interfaces when no metric is explicitly provided. When userspace
+	  programs change routes' metrics, if they save the new metric value
+	  into relevant network interface's def_rt_metric sysfs attribute file,
+	  the kernel will also apply it whenever new routes are created for
+	  that interface, unless the metric is explicitly specified. Leave 0
+	  to use the system default values.
+
+	  If unsure, say N.
+
 menuconfig TCP_CONG_ADVANCED
 	bool "TCP: advanced congestion control"
 	help
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 123a6d39438f..775a358e5466 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2538,6 +2538,9 @@ static struct devinet_sysctl_table {
 					"ignore_routes_with_linkdown"),
 		DEVINET_SYSCTL_RW_ENTRY(DROP_GRATUITOUS_ARP,
 					"drop_gratuitous_arp"),
+#ifdef CONFIG_IP_DEF_RT_METRIC
+		DEVINET_SYSCTL_RW_ENTRY(DEF_RT_METRIC, "def_rt_metric"),
+#endif
 
 		DEVINET_SYSCTL_FLUSHING_ENTRY(NOXFRM, "disable_xfrm"),
 		DEVINET_SYSCTL_FLUSHING_ENTRY(NOPOLICY, "disable_policy"),
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 86a23e4a6a50..459fdc507d50 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -724,6 +724,10 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 	struct nlattr *attr;
 	int err, remaining;
 	struct rtmsg *rtm;
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	struct net_device *dev = NULL;
+	struct in_device *in_dev = NULL;
+#endif
 
 	err = nlmsg_validate_deprecated(nlh, sizeof(*rtm), RTA_MAX,
 					rtm_ipv4_policy, extack);
@@ -828,6 +832,21 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		goto errout;
 	}
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	/* Apply the default route metric of the out interface if needed */
+	if (cfg->fc_priority == 0 && cfg->fc_oif) {
+		dev = dev_get_by_index(net, cfg->fc_oif);
+		if (dev) {
+			in_dev = in_dev_get(dev);
+			if (in_dev) {
+				cfg->fc_priority = IN_DEV_DEF_RT_METRIC(in_dev);
+				in_dev_put(in_dev);
+			}
+			dev_put(dev);
+		}
+	}
+#endif
+
 	return 0;
 errout:
 	return err;
@@ -1081,6 +1100,14 @@ static void fib_magic(int cmd, int type, __be32 dst, int dst_len,
 	else
 		cfg.fc_scope = RT_SCOPE_HOST;
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	/* If the netlink message doesn't have the IFA_RT_PRIORITY attribute,
+	 * fall back on the interface's default route metric
+	 */
+	if (cfg.fc_priority == 0)
+		cfg.fc_priority = IN_DEV_DEF_RT_METRIC(ifa->ifa_dev);
+#endif
+
 	if (cmd == RTM_NEWROUTE)
 		fib_table_insert(net, tb, &cfg, NULL);
 	else
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 01146b66d666..6480da7ae885 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2388,7 +2388,7 @@ addrconf_prefix_route(struct in6_addr *pfx, int plen, u32 metric,
 {
 	struct fib6_config cfg = {
 		.fc_table = l3mdev_fib_table(dev) ? : RT6_TABLE_PREFIX,
-		.fc_metric = metric ? : IP6_RT_PRIO_ADDRCONF,
+		.fc_metric = metric,
 		.fc_ifindex = dev->ifindex,
 		.fc_expires = expires,
 		.fc_dst_len = plen,
@@ -2400,6 +2400,14 @@ addrconf_prefix_route(struct in6_addr *pfx, int plen, u32 metric,
 
 	cfg.fc_dst = *pfx;
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	if (cfg.fc_metric == 0)
+		rt6_get_dev_dflt_metric(dev, &cfg);
+#endif
+
+	if (cfg.fc_metric == 0)
+		cfg.fc_metric = IP6_RT_PRIO_ADDRCONF;
+
 	/* Prevent useless cloning on PtP SIT.
 	   This thing is done here expecting that the whole
 	   class of non-broadcast devices need not cloning.
@@ -2462,7 +2470,6 @@ static void addrconf_add_mroute(struct net_device *dev)
 {
 	struct fib6_config cfg = {
 		.fc_table = l3mdev_fib_table(dev) ? : RT6_TABLE_LOCAL,
-		.fc_metric = IP6_RT_PRIO_ADDRCONF,
 		.fc_ifindex = dev->ifindex,
 		.fc_dst_len = 8,
 		.fc_flags = RTF_UP,
@@ -2472,6 +2479,13 @@ static void addrconf_add_mroute(struct net_device *dev)
 
 	ipv6_addr_set(&cfg.fc_dst, htonl(0xFF000000), 0, 0, 0);
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	rt6_get_dev_dflt_metric(dev, &cfg);
+#endif
+
+	if (cfg.fc_metric == 0)
+		cfg.fc_metric = IP6_RT_PRIO_ADDRCONF;
+
 	ip6_route_add(&cfg, GFP_KERNEL, NULL);
 }
 
@@ -5512,6 +5526,9 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
 	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	array[DEVCONF_DEF_RT_METRIC] = cnf->def_rt_metric;
+#endif
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6892,6 +6909,15 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	{
+		.procname	= "def_rt_metric",
+		.data		= &ipv6_devconf.def_rt_metric,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fb075d9545b9..f3d74e0f6434 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4190,7 +4190,6 @@ static struct fib6_info *rt6_add_route_info(struct net *net,
 					   unsigned int pref)
 {
 	struct fib6_config cfg = {
-		.fc_metric	= IP6_RT_PRIO_USER,
 		.fc_ifindex	= dev->ifindex,
 		.fc_dst_len	= prefixlen,
 		.fc_flags	= RTF_GATEWAY | RTF_ADDRCONF | RTF_ROUTEINFO |
@@ -4202,6 +4201,13 @@ static struct fib6_info *rt6_add_route_info(struct net *net,
 		.fc_nlinfo.nl_net = net,
 	};
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	rt6_get_dev_dflt_metric(dev, &cfg);
+#endif
+
+	if (cfg.fc_metric == 0)
+		cfg.fc_metric = IP6_RT_PRIO_USER;
+
 	cfg.fc_table = l3mdev_fib_table(dev) ? : RT6_TABLE_INFO;
 	cfg.fc_dst = *prefix;
 	cfg.fc_gateway = *gwaddr;
@@ -4255,7 +4261,6 @@ struct fib6_info *rt6_add_dflt_router(struct net *net,
 {
 	struct fib6_config cfg = {
 		.fc_table	= l3mdev_fib_table(dev) ? : RT6_TABLE_DFLT,
-		.fc_metric	= IP6_RT_PRIO_USER,
 		.fc_ifindex	= dev->ifindex,
 		.fc_flags	= RTF_GATEWAY | RTF_ADDRCONF | RTF_DEFAULT |
 				  RTF_UP | RTF_EXPIRES | RTF_PREF(pref),
@@ -4266,6 +4271,13 @@ struct fib6_info *rt6_add_dflt_router(struct net *net,
 		.fc_nlinfo.nl_net = net,
 	};
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	rt6_get_dev_dflt_metric(dev, &cfg);
+#endif
+
+	if (cfg.fc_metric == 0)
+		cfg.fc_metric = IP6_RT_PRIO_USER;
+
 	cfg.fc_gateway = *gwaddr;
 
 	if (!ip6_route_add(&cfg, GFP_ATOMIC, NULL)) {
@@ -4326,11 +4338,15 @@ static void rtmsg_to_fib6_config(struct net *net,
 				 struct in6_rtmsg *rtmsg,
 				 struct fib6_config *cfg)
 {
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	struct net_device *dev = NULL;
+#endif
+
 	*cfg = (struct fib6_config){
 		.fc_table = l3mdev_fib_table_by_index(net, rtmsg->rtmsg_ifindex) ?
 			 : RT6_TABLE_MAIN,
 		.fc_ifindex = rtmsg->rtmsg_ifindex,
-		.fc_metric = rtmsg->rtmsg_metric ? : IP6_RT_PRIO_USER,
+		.fc_metric = rtmsg->rtmsg_metric,
 		.fc_expires = rtmsg->rtmsg_info,
 		.fc_dst_len = rtmsg->rtmsg_dst_len,
 		.fc_src_len = rtmsg->rtmsg_src_len,
@@ -4343,6 +4359,19 @@ static void rtmsg_to_fib6_config(struct net *net,
 		.fc_src = rtmsg->rtmsg_src,
 		.fc_gateway = rtmsg->rtmsg_gateway,
 	};
+
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	if (cfg->fc_metric == 0 && cfg->fc_ifindex) {
+		dev = dev_get_by_index_rcu(net, cfg->fc_ifindex);
+		if (dev) {
+			rt6_get_dev_dflt_metric(dev, cfg);
+			dev_put(dev);
+		}
+	}
+#endif
+
+	if (cfg->fc_metric == 0)
+		cfg->fc_metric = IP6_RT_PRIO_USER;
 }
 
 int ipv6_route_ioctl(struct net *net, unsigned int cmd, struct in6_rtmsg *rtmsg)
@@ -4886,6 +4915,10 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *tb[RTA_MAX+1];
 	unsigned int pref;
 	int err;
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	struct net *net = NULL;
+	struct net_device *dev = NULL;
+#endif
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
 				     rtm_ipv6_policy, extack);
@@ -5014,6 +5047,17 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 	}
 
+#ifdef CONFIG_IP_DEF_RT_METRIC
+	if (cfg->fc_metric == 0 && cfg->fc_ifindex) {
+		net = dev_net(skb->dev);
+		dev = dev_get_by_index_rcu(net, cfg->fc_ifindex);
+		if (dev) {
+			rt6_get_dev_dflt_metric(dev, cfg);
+			dev_put(dev);
+		}
+	}
+#endif
+
 	err = 0;
 errout:
 	return err;
-- 
2.17.1

