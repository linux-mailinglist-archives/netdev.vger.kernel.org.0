Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D33A43005F
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 07:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243662AbhJPFG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 01:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbhJPFGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 01:06:55 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480C7C061570;
        Fri, 15 Oct 2021 22:04:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i76so7973751pfe.13;
        Fri, 15 Oct 2021 22:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VNg5ZuSqXtZnIDT/1CeK+dUC1AUVpXTi6dIHjGdCB00=;
        b=O6f/lrGFRvziPIrEcq2SK9AmUeLEU3LElV7tq1rCZPWAQ5lx8VJgS5O+2FOZaY0MYc
         Z09kxUko1rnjEfPnHhu3FfbANUunLACgh7JnMYQw9sWzjc3NxoHQrqFTzypDj2kjohm0
         oToW0d88Gm03fTTZVGcxB+3vppPNm4WFpUansTv1NV/qwKEhXttEJMJ/1wcow703btaF
         MuMzXQGNjeRVmsupDxWx0g1ZCbT5PJV3aknIWoDVFTnM23pOEykGlzMC/AU9CXIxGN+a
         S6CiUlSWASAPZVO/sBMN6KfI9i8ylnS3yALkQoRydqJLLQC4s1mJJXx6bJL/s355/Uw/
         tnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VNg5ZuSqXtZnIDT/1CeK+dUC1AUVpXTi6dIHjGdCB00=;
        b=qTIWn3NGXUOE8uNRSXJB0xqbytfbRevRkNjN0Mowginh2nwxqiC90nfS9ilHioIN84
         HG6cy1YPZsKv9vTZ1FJXU+/aHhSLZ1i99q5+agcD6QJJeB4+429bPQDsVTvcL9zCnzyx
         PJen07wIdqzjmMmjCwPI24uftvJAEk4zzXzs1YS+QVGiYsVn8wnffSaxaOcRQB36VeIn
         AHMEARqRYERne63QFAdjKDvhR7fFdaicjK1GbuBRr/pTIMxUil52YdhT8mHRMle4E6OK
         Ya6mcQASKqLp8DKZSFdgck8H6B7Ug3mRVVcznW6nEPg7peEvby1Mcl2AUMxbMEeiq7EV
         MKVg==
X-Gm-Message-State: AOAM530NKB3TVDYoP/5gH4L7qsGCk+prgN/gjmKbL0ib7oB+QovKPely
        f7uGXFvINS5nyJIa1tGglB4=
X-Google-Smtp-Source: ABdhPJzQXYg1bz9xjyuz0BE9PX7NPJ2cEc8GOhsD22CjbWyyyiI0x7xzT6EX3ZLXoChnqKclO8+avA==
X-Received: by 2002:a63:ea48:: with SMTP id l8mr12304501pgk.99.1634360686763;
        Fri, 15 Oct 2021 22:04:46 -0700 (PDT)
Received: from rok-te3.kortoor.gmail.com.beta.tailscale.net ([211.250.198.237])
        by smtp.googlemail.com with ESMTPSA id u24sm6263989pfm.27.2021.10.15.22.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 22:04:46 -0700 (PDT)
From:   Kyungrok Chung <acadx0@gmail.com>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH v2 net-next] net: make use of helper netif_is_bridge_master()
Date:   Sat, 16 Oct 2021 14:04:38 +0900
Message-Id: <20211016050439.2592877-1-acadx0@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of netdev helper functions to improve code readability.
Replace 'dev->priv_flags & IFF_EBRIDGE' with netif_is_bridge_master(dev).

Signed-off-by: Kyungrok Chung <acadx0@gmail.com>
---

v1->v2:
  - Apply fixes to batman-adv, core too.

 net/batman-adv/multicast.c      | 2 +-
 net/bridge/br.c                 | 4 ++--
 net/bridge/br_fdb.c             | 6 +++---
 net/bridge/br_if.c              | 2 +-
 net/bridge/br_ioctl.c           | 2 +-
 net/bridge/br_mdb.c             | 4 ++--
 net/bridge/br_netfilter_hooks.c | 2 +-
 net/bridge/br_netlink.c         | 4 ++--
 net/core/rtnetlink.c            | 2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index a3b6658ed789..433901dcf0c3 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -89,7 +89,7 @@ static struct net_device *batadv_mcast_get_bridge(struct net_device *soft_iface)
 	rcu_read_lock();
 	do {
 		upper = netdev_master_upper_dev_get_rcu(upper);
-	} while (upper && !(upper->priv_flags & IFF_EBRIDGE));
+	} while (upper && !netif_is_bridge_master(upper));
 
 	dev_hold(upper);
 	rcu_read_unlock();
diff --git a/net/bridge/br.c b/net/bridge/br.c
index d3a32c6813e0..1fac72cc617f 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -36,7 +36,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 	bool changed_addr;
 	int err;
 
-	if (dev->priv_flags & IFF_EBRIDGE) {
+	if (netif_is_bridge_master(dev)) {
 		err = br_vlan_bridge_event(dev, event, ptr);
 		if (err)
 			return notifier_from_errno(err);
@@ -349,7 +349,7 @@ static void __net_exit br_net_exit(struct net *net)
 
 	rtnl_lock();
 	for_each_netdev(net, dev)
-		if (dev->priv_flags & IFF_EBRIDGE)
+		if (netif_is_bridge_master(dev))
 			br_dev_delete(dev, &list);
 
 	unregister_netdevice_many(&list);
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 46812b659710..a6a68e18c70a 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -825,7 +825,7 @@ int br_fdb_dump(struct sk_buff *skb,
 	struct net_bridge_fdb_entry *f;
 	int err = 0;
 
-	if (!(dev->priv_flags & IFF_EBRIDGE))
+	if (!netif_is_bridge_master(dev))
 		return err;
 
 	if (!filter_dev) {
@@ -1076,7 +1076,7 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		return -EINVAL;
 	}
 
-	if (dev->priv_flags & IFF_EBRIDGE) {
+	if (netif_is_bridge_master(dev)) {
 		br = netdev_priv(dev);
 		vg = br_vlan_group(br);
 	} else {
@@ -1173,7 +1173,7 @@ int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 	struct net_bridge *br;
 	int err;
 
-	if (dev->priv_flags & IFF_EBRIDGE) {
+	if (netif_is_bridge_master(dev)) {
 		br = netdev_priv(dev);
 		vg = br_vlan_group(br);
 	} else {
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4a02f8bb278a..c11bba3e7ec0 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -471,7 +471,7 @@ int br_del_bridge(struct net *net, const char *name)
 	if (dev == NULL)
 		ret =  -ENXIO; 	/* Could not find device */
 
-	else if (!(dev->priv_flags & IFF_EBRIDGE)) {
+	else if (!netif_is_bridge_master(dev)) {
 		/* Attempt to delete non bridge device! */
 		ret = -EPERM;
 	}
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index 49c268871fc1..db4ab2c2ce18 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -26,7 +26,7 @@ static int get_bridge_ifindices(struct net *net, int *indices, int num)
 	for_each_netdev_rcu(net, dev) {
 		if (i >= num)
 			break;
-		if (dev->priv_flags & IFF_EBRIDGE)
+		if (netif_is_bridge_master(dev))
 			indices[i++] = dev->ifindex;
 	}
 	rcu_read_unlock();
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 0281453f7766..61ccf46fcc21 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -422,7 +422,7 @@ static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	cb->seq = net->dev_base_seq;
 
 	for_each_netdev_rcu(net, dev) {
-		if (dev->priv_flags & IFF_EBRIDGE) {
+		if (netif_is_bridge_master(dev)) {
 			struct net_bridge *br = netdev_priv(dev);
 			struct br_port_msg *bpm;
 
@@ -1016,7 +1016,7 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -ENODEV;
 	}
 
-	if (!(dev->priv_flags & IFF_EBRIDGE)) {
+	if (!netif_is_bridge_master(dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge");
 		return -EOPNOTSUPP;
 	}
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 8edfb98ae1d5..b5af68c105a8 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -968,7 +968,7 @@ static int brnf_device_event(struct notifier_block *unused, unsigned long event,
 	struct net *net;
 	int ret;
 
-	if (event != NETDEV_REGISTER || !(dev->priv_flags & IFF_EBRIDGE))
+	if (event != NETDEV_REGISTER || !netif_is_bridge_master(dev))
 		return NOTIFY_DONE;
 
 	ASSERT_RTNL();
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5c6c4305ed23..0c8b5f1a15bc 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -106,7 +106,7 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 		p = br_port_get_check_rcu(dev);
 		if (p)
 			vg = nbp_vlan_group_rcu(p);
-	} else if (dev->priv_flags & IFF_EBRIDGE) {
+	} else if (netif_is_bridge_master(dev)) {
 		br = netdev_priv(dev);
 		vg = br_vlan_group_rcu(br);
 	}
@@ -1050,7 +1050,7 @@ int br_dellink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags)
 
 	p = br_port_get_rtnl(dev);
 	/* We want to accept dev as bridge itself as well */
-	if (!p && !(dev->priv_flags & IFF_EBRIDGE))
+	if (!p && !netif_is_bridge_master(dev))
 		return -EINVAL;
 
 	err = br_afspec(br, p, afspec, RTM_DELLINK, &changed, NULL);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2dc1b209ba91..d3676666a529 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4384,7 +4384,7 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 					continue;
 
 				if (br_dev != netdev_master_upper_dev_get(dev) &&
-				    !(dev->priv_flags & IFF_EBRIDGE))
+				    netif_is_bridge_master(dev))
 					continue;
 				cops = ops;
 			}
-- 
2.33.0

