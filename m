Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51897AC6DC
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406712AbfIGNsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:48:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39599 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733096AbfIGNsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:48:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so5137568pgi.6
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Zvqvj0SAWpRVvbLIHyr6uhQGnZW7ODqSqCSSGUzXMas=;
        b=J5mUqjKBc4uTsUgkIIRLuMBFhiI99wwN99VnRJ/SPMLSiMMkqvrf82wykmkF/pGG5h
         s5zoCXYAZaPeDnCzxS9NnZvBfSy4NhEiLJWNTNgGE/IhG6FpiBxDFnJ+c4s47aA4d+UF
         o/XqmqeWBYeRg0adqNXsyrkWHDLfwTiKg0v8npdLtz+9eIWM31CC8dkl9COUaZ7+zofu
         1wFb2zdwRARLskdyDFkm+mwtZGiz0ktdszhthj6eJpnTjUalF/mWjCDqXXQhSzFpoKIs
         T4zpQd3/w0f5/HOehHVx8r5+FuK9g+FUf61VSFmrnXMkXVnCd3c/v2Qdqb+zKdrsnJ/b
         5+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Zvqvj0SAWpRVvbLIHyr6uhQGnZW7ODqSqCSSGUzXMas=;
        b=eIVlQueT7I/PwSj5PdB2Ctl6ABSP5SJ302GlHmZKSR+veg61kC3qWTOyMC/ekpiaaS
         322Ox+MbaKPCHaWkyPh2e0WDP+ePobDMtIhC5MreGtW5lvUEPCH5YAV2j3QUBRbmwFPe
         p2UChVFspFXCJfdeYnP1zpNK3DFDl5gKg90Vrjc3LpRxFXGuO7KA4YjQrVvmYf+fiyrt
         P/cQjD8Nlq57R4Y2YlfjdMJgr6OiuBBsJwaCmHlCmsLGO+BD+KA9Ub59r/L85g/a9zD1
         QUdVpkbr4eW/oOgacDSJf9K9y7CE41/NZMvxJM86fv1w1Z2YFoIMMm8/xaCiooM0Pin7
         xB1Q==
X-Gm-Message-State: APjAAAXzZWU9R9Z6Usqbq3d/NtrFvvv/sEfPkLKk0Wo98yBXaZj3OsTK
        ZknExZDddkjfuL6wd739pOQ=
X-Google-Smtp-Source: APXvYqyNO+k0ObQ8kdbnsftxvRl7OxJEmSp/tjQXxGFh+wandbzrhppgt6SnbuB7X91OeUjPuL7+IQ==
X-Received: by 2002:a62:4e52:: with SMTP id c79mr17252204pfb.28.1567864098673;
        Sat, 07 Sep 2019 06:48:18 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id r28sm20085547pfg.62.2019.09.07.06.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:48:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 11/11] net: remove unnecessary variables and callback
Date:   Sat,  7 Sep 2019 22:48:09 +0900
Message-Id: <20190907134809.720-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes variables and callback these are related to the nested
device structure.
devices that can be nested have their own nest_level variable that
represents the depth of nested devices.
In the previous patch, new {lower/upper}_level variables are added and
they replace old private nest_level variable.
So, this patch removes all 'nest_level' variables.

In order to avoid lockdep warning, ->ndo_get_lock_subclass() was added
to get lockdep subclass value, which is actually lower nested depth value.
But now, they use the dynamic lockdep key to avoid lockdep warning instead
of the subclass.
So, this patch removes ->ndo_get_lock_subclass() callback.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : this patch isn't changed

 drivers/net/bonding/bond_alb.c                |  2 +-
 drivers/net/bonding/bond_main.c               | 14 -------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 drivers/net/macsec.c                          |  9 ---------
 drivers/net/macvlan.c                         |  7 -------
 include/linux/if_macvlan.h                    |  1 -
 include/linux/if_vlan.h                       | 12 -----------
 include/linux/netdevice.h                     | 12 -----------
 include/net/bonding.h                         |  1 -
 net/8021q/vlan.c                              |  1 -
 net/8021q/vlan_dev.c                          |  6 ------
 net/core/dev.c                                | 20 -------------------
 net/core/dev_addr_lists.c                     | 12 +++++------
 net/smc/smc_core.c                            |  2 +-
 net/smc/smc_pnet.c                            |  2 +-
 15 files changed, 10 insertions(+), 93 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 8c79bad2a9a5..4f2e6910c623 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -952,7 +952,7 @@ static int alb_upper_dev_walk(struct net_device *upper, void *_data)
 	struct bond_vlan_tag *tags;
 
 	if (is_vlan_dev(upper) &&
-	    bond->nest_level == vlan_get_encap_level(upper) - 1) {
+	    bond->dev->lower_level == upper->lower_level - 1) {
 		if (upper->addr_assign_type == NET_ADDR_STOLEN) {
 			alb_send_lp_vid(slave, mac_addr,
 					vlan_dev_vlan_proto(upper),
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7f574e74ed78..69eb61466fbe 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1733,8 +1733,6 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		goto err_upper_unlink;
 	}
 
-	bond->nest_level = dev_get_nest_level(bond_dev) + 1;
-
 	/* If the mode uses primary, then the following is handled by
 	 * bond_change_active_slave().
 	 */
@@ -1983,9 +1981,6 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (!bond_has_slaves(bond)) {
 		bond_set_carrier(bond);
 		eth_hw_addr_random(bond_dev);
-		bond->nest_level = SINGLE_DEPTH_NESTING;
-	} else {
-		bond->nest_level = dev_get_nest_level(bond_dev) + 1;
 	}
 
 	unblock_netpoll_tx();
@@ -3472,13 +3467,6 @@ static void bond_fold_stats(struct rtnl_link_stats64 *_res,
 	}
 }
 
-static int bond_get_nest_level(struct net_device *bond_dev)
-{
-	struct bonding *bond = netdev_priv(bond_dev);
-
-	return bond->nest_level;
-}
-
 static void bond_get_stats(struct net_device *bond_dev,
 			   struct rtnl_link_stats64 *stats)
 {
@@ -4298,7 +4286,6 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_neigh_setup	= bond_neigh_setup,
 	.ndo_vlan_rx_add_vid	= bond_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= bond_vlan_rx_kill_vid,
-	.ndo_get_lock_subclass  = bond_get_nest_level,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_netpoll_setup	= bond_netpoll_setup,
 	.ndo_netpoll_cleanup	= bond_netpoll_cleanup,
@@ -4822,7 +4809,6 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
-	bond->nest_level = SINGLE_DEPTH_NESTING;
 	bond_dev_set_lockdep_class(bond_dev);
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 00b2d4a86159..e056f9aad8df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2797,7 +2797,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 			       struct mlx5_esw_flow_attr *attr,
 			       u32 *action)
 {
-	int nest_level = vlan_get_encap_level(attr->parse_attr->filter_dev);
+	int nest_level = attr->parse_attr->filter_dev->lower_level;
 	struct flow_action_entry vlan_act = {
 		.id = FLOW_ACTION_VLAN_POP,
 	};
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 41ec1ed0d545..c0cb595f2bba 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -269,7 +269,6 @@ struct macsec_dev {
 	struct gro_cells gro_cells;
 	struct lock_class_key xmit_lock_key;
 	struct lock_class_key addr_lock_key;
-	unsigned int nest_level;
 };
 
 /**
@@ -2988,11 +2987,6 @@ static int macsec_get_iflink(const struct net_device *dev)
 	return macsec_priv(dev)->real_dev->ifindex;
 }
 
-static int macsec_get_nest_level(struct net_device *dev)
-{
-	return macsec_priv(dev)->nest_level;
-}
-
 static const struct net_device_ops macsec_netdev_ops = {
 	.ndo_init		= macsec_dev_init,
 	.ndo_uninit		= macsec_dev_uninit,
@@ -3006,7 +3000,6 @@ static const struct net_device_ops macsec_netdev_ops = {
 	.ndo_start_xmit		= macsec_start_xmit,
 	.ndo_get_stats64	= macsec_get_stats64,
 	.ndo_get_iflink		= macsec_get_iflink,
-	.ndo_get_lock_subclass  = macsec_get_nest_level,
 };
 
 static const struct device_type macsec_type = {
@@ -3289,8 +3282,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	macsec->nest_level = dev_get_nest_level(real_dev) + 1;
-
 	err = netdev_upper_dev_link(real_dev, dev, extack);
 	if (err < 0)
 		goto unregister;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index dae368a2e8d1..2c14bc606514 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -867,11 +867,6 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 #define MACVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
 
-static int macvlan_get_nest_level(struct net_device *dev)
-{
-	return ((struct macvlan_dev *)netdev_priv(dev))->nest_level;
-}
-
 static void macvlan_dev_set_lockdep_one(struct net_device *dev,
 					struct netdev_queue *txq,
 					void *_unused)
@@ -1180,7 +1175,6 @@ static const struct net_device_ops macvlan_netdev_ops = {
 	.ndo_fdb_add		= macvlan_fdb_add,
 	.ndo_fdb_del		= macvlan_fdb_del,
 	.ndo_fdb_dump		= ndo_dflt_fdb_dump,
-	.ndo_get_lock_subclass  = macvlan_get_nest_level,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= macvlan_dev_poll_controller,
 	.ndo_netpoll_setup	= macvlan_dev_netpoll_setup,
@@ -1464,7 +1458,6 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	vlan->dev      = dev;
 	vlan->port     = port;
 	vlan->set_features = MACVLAN_FEATURES;
-	vlan->nest_level = dev_get_nest_level(lowerdev) + 1;
 
 	vlan->mode     = MACVLAN_MODE_VEPA;
 	if (data && data[IFLA_MACVLAN_MODE])
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index ea5b41823287..e9202edcf101 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -29,7 +29,6 @@ struct macvlan_dev {
 	netdev_features_t	set_features;
 	enum macvlan_mode	mode;
 	u16			flags;
-	int			nest_level;
 	unsigned int		macaddr_count;
 	struct lock_class_key xmit_lock_key;
 	struct lock_class_key addr_lock_key;
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 1aed9f613e90..6f30284a58e5 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -182,8 +182,6 @@ struct vlan_dev_priv {
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	struct netpoll				*netpoll;
 #endif
-	unsigned int				nest_level;
-
 	struct lock_class_key			xmit_lock_key;
 	struct lock_class_key			addr_lock_key;
 };
@@ -224,11 +222,6 @@ extern void vlan_vids_del_by_dev(struct net_device *dev,
 
 extern bool vlan_uses_dev(const struct net_device *dev);
 
-static inline int vlan_get_encap_level(struct net_device *dev)
-{
-	BUG_ON(!is_vlan_dev(dev));
-	return vlan_dev_priv(dev)->nest_level;
-}
 #else
 static inline struct net_device *
 __vlan_find_dev_deep_rcu(struct net_device *real_dev,
@@ -298,11 +291,6 @@ static inline bool vlan_uses_dev(const struct net_device *dev)
 {
 	return false;
 }
-static inline int vlan_get_encap_level(struct net_device *dev)
-{
-	BUG();
-	return 0;
-}
 #endif
 
 /**
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 309ae000bae7..e13db714ee85 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1408,7 +1408,6 @@ struct net_device_ops {
 	void			(*ndo_dfwd_del_station)(struct net_device *pdev,
 							void *priv);
 
-	int			(*ndo_get_lock_subclass)(struct net_device *dev);
 	int			(*ndo_set_tx_maxrate)(struct net_device *dev,
 						      int queue_index,
 						      u32 maxrate);
@@ -4047,16 +4046,6 @@ static inline void netif_addr_lock(struct net_device *dev)
 	spin_lock(&dev->addr_list_lock);
 }
 
-static inline void netif_addr_lock_nested(struct net_device *dev)
-{
-	int subclass = SINGLE_DEPTH_NESTING;
-
-	if (dev->netdev_ops->ndo_get_lock_subclass)
-		subclass = dev->netdev_ops->ndo_get_lock_subclass(dev);
-
-	spin_lock_nested(&dev->addr_list_lock, subclass);
-}
-
 static inline void netif_addr_lock_bh(struct net_device *dev)
 {
 	spin_lock_bh(&dev->addr_list_lock);
@@ -4334,7 +4323,6 @@ void netdev_lower_state_changed(struct net_device *lower_dev,
 extern u8 netdev_rss_key[NETDEV_RSS_KEY_LEN] __read_mostly;
 void netdev_rss_key_fill(void *buffer, size_t len);
 
-int dev_get_nest_level(struct net_device *dev);
 int skb_checksum_help(struct sk_buff *skb);
 int skb_crc32c_csum_help(struct sk_buff *skb);
 int skb_csum_hwoffload_help(struct sk_buff *skb,
diff --git a/include/net/bonding.h b/include/net/bonding.h
index c39ac7061e41..74f41dd73866 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -203,7 +203,6 @@ struct bonding {
 	struct   slave __rcu *primary_slave;
 	struct   bond_up_slave __rcu *slave_arr; /* Array of usable slaves */
 	bool     force_primary;
-	u32      nest_level;
 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
 			      struct slave *);
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 54728d2eda18..d4bcfd8f95bf 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -172,7 +172,6 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (err < 0)
 		goto out_uninit_mvrp;
 
-	vlan->nest_level = dev_get_nest_level(real_dev) + 1;
 	err = register_netdevice(dev);
 	if (err < 0)
 		goto out_uninit_mvrp;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 12bc80650087..e8707827540c 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -514,11 +514,6 @@ static void vlan_dev_set_lockdep_class(struct net_device *dev)
 	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, NULL);
 }
 
-static int vlan_dev_get_lock_subclass(struct net_device *dev)
-{
-	return vlan_dev_priv(dev)->nest_level;
-}
-
 static const struct header_ops vlan_header_ops = {
 	.create	 = vlan_dev_hard_header,
 	.parse	 = eth_header_parse,
@@ -814,7 +809,6 @@ static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_netpoll_cleanup	= vlan_dev_netpoll_cleanup,
 #endif
 	.ndo_fix_features	= vlan_dev_fix_features,
-	.ndo_get_lock_subclass  = vlan_dev_get_lock_subclass,
 	.ndo_get_iflink		= vlan_dev_get_iflink,
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index ac055b531c96..73a69a7a3553 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7510,26 +7510,6 @@ void *netdev_lower_dev_get_private(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_lower_dev_get_private);
 
-
-int dev_get_nest_level(struct net_device *dev)
-{
-	struct net_device *lower = NULL;
-	struct list_head *iter;
-	int max_nest = -1;
-	int nest;
-
-	ASSERT_RTNL();
-
-	netdev_for_each_lower_dev(dev, lower, iter) {
-		nest = dev_get_nest_level(lower);
-		if (max_nest < nest)
-			max_nest = nest;
-	}
-
-	return max_nest + 1;
-}
-EXPORT_SYMBOL(dev_get_nest_level);
-
 /**
  * netdev_lower_change - Dispatch event about lower device state change
  * @lower_dev: device
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 6393ba930097..2f949b5a1eb9 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -637,7 +637,7 @@ int dev_uc_sync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync(&to->uc, &from->uc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -667,7 +667,7 @@ int dev_uc_sync_multiple(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync_multiple(&to->uc, &from->uc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -691,7 +691,7 @@ void dev_uc_unsync(struct net_device *to, struct net_device *from)
 		return;
 
 	netif_addr_lock_bh(from);
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	__hw_addr_unsync(&to->uc, &from->uc, to->addr_len);
 	__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
@@ -858,7 +858,7 @@ int dev_mc_sync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync(&to->mc, &from->mc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -888,7 +888,7 @@ int dev_mc_sync_multiple(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync_multiple(&to->mc, &from->mc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -912,7 +912,7 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 		return;
 
 	netif_addr_lock_bh(from);
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	__hw_addr_unsync(&to->mc, &from->mc, to->addr_len);
 	__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 4ca50ddf8d16..a2e91b8d04b3 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -558,7 +558,7 @@ int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)
 	}
 
 	rtnl_lock();
-	nest_lvl = dev_get_nest_level(ndev);
+	nest_lvl = ndev->lower_level;
 	for (i = 0; i < nest_lvl; i++) {
 		struct list_head *lower = &ndev->adj_list.lower;
 
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index bab2da8cf17a..2920b006f65c 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -718,7 +718,7 @@ static struct net_device *pnet_find_base_ndev(struct net_device *ndev)
 	int i, nest_lvl;
 
 	rtnl_lock();
-	nest_lvl = dev_get_nest_level(ndev);
+	nest_lvl = ndev->lower_level;
 	for (i = 0; i < nest_lvl; i++) {
 		struct list_head *lower = &ndev->adj_list.lower;
 
-- 
2.17.1

