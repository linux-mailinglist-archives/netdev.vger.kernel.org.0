Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1C33E143B
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbhHEL4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhHEL4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:56:02 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011E7C061765;
        Thu,  5 Aug 2021 04:55:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628164545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s7WqRuMebEWoKXLcbn+kLHFI7DjA26Fq8DkuvqaP2lc=;
        b=tbrMKfekxjYjsTdiLck6bq8Vskbgc/QdSh2Q+42pPlDBkN1qNydn5T+cRMSzUA59PN+qpH
        AFFMLzIqqtA1MxT2dLneZyFEUBRkBLJCPzCKwRrXok8r5idkZqeFpIbmX+M8RpblbORgh9
        +KPgkKPGdM60CaToyMa2Jpm6gTjoMJc=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: Remove redundant if statements
Date:   Thu,  5 Aug 2021 19:55:27 +0800
Message-Id: <20210805115527.19435-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'if (dev)' statement already move into dev_{put , hold}, so remove
redundant if statements.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/batman-adv/bridge_loop_avoidance.c |  6 ++----
 net/batman-adv/distributed-arp-table.c |  3 +--
 net/batman-adv/gateway_client.c        |  3 +--
 net/batman-adv/multicast.c             |  9 +++------
 net/batman-adv/originator.c            | 12 ++++--------
 net/batman-adv/translation-table.c     |  9 +++------
 net/can/raw.c                          |  8 ++------
 net/core/dev.c                         |  6 ++----
 net/core/drop_monitor.c                |  6 ++----
 net/core/dst.c                         |  6 ++----
 net/core/neighbour.c                   | 15 +++++----------
 net/decnet/dn_dev.c                    |  6 ++----
 net/decnet/dn_fib.c                    |  3 +--
 net/decnet/dn_route.c                  | 18 ++++++------------
 net/ethtool/netlink.c                  |  6 ++----
 net/ieee802154/nl-phy.c                |  3 +--
 net/ieee802154/nl802154.c              |  3 +--
 net/ieee802154/socket.c                |  3 +--
 net/ipv4/fib_semantics.c               |  4 +---
 net/ipv4/icmp.c                        |  3 +--
 net/ipv4/route.c                       |  3 +--
 net/ipv6/addrconf.c                    |  6 ++----
 net/ipv6/ip6mr.c                       |  3 +--
 net/ipv6/route.c                       |  3 +--
 net/llc/af_llc.c                       |  6 ++----
 net/netfilter/nf_flow_table_offload.c  |  3 +--
 net/netfilter/nf_queue.c               | 24 ++++++++----------------
 net/netlabel/netlabel_unlabeled.c      |  6 ++----
 net/netrom/nr_loopback.c               |  3 +--
 net/netrom/nr_route.c                  |  3 +--
 net/packet/af_packet.c                 | 15 +++++----------
 net/phonet/af_phonet.c                 |  3 +--
 net/phonet/pn_dev.c                    |  6 ++----
 net/phonet/socket.c                    |  3 +--
 net/sched/act_mirred.c                 |  6 ++----
 net/smc/smc_ib.c                       |  3 +--
 net/smc/smc_pnet.c                     |  3 +--
 net/wireless/nl80211.c                 | 16 +++++-----------
 net/wireless/scan.c                    |  3 +--
 39 files changed, 82 insertions(+), 168 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 63d42dcc9324..2b639c8b0ded 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -2274,8 +2274,7 @@ int batadv_bla_claim_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	if (primary_if)
 		batadv_hardif_put(primary_if);
 
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	return ret;
 }
@@ -2446,8 +2445,7 @@ int batadv_bla_backbone_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	if (primary_if)
 		batadv_hardif_put(primary_if);
 
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	return ret;
 }
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 8c95a11a830a..7976a0435662 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -984,8 +984,7 @@ int batadv_dat_cache_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	if (primary_if)
 		batadv_hardif_put(primary_if);
 
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	return ret;
 }
diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 007f2827935d..36a98d3cefe0 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -557,8 +557,7 @@ int batadv_gw_dump(struct sk_buff *msg, struct netlink_callback *cb)
 out:
 	if (primary_if)
 		batadv_hardif_put(primary_if);
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	return ret;
 }
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 923e2197c2db..0158f267c403 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -91,8 +91,7 @@ static struct net_device *batadv_mcast_get_bridge(struct net_device *soft_iface)
 		upper = netdev_master_upper_dev_get_rcu(upper);
 	} while (upper && !(upper->priv_flags & IFF_EBRIDGE));
 
-	if (upper)
-		dev_hold(upper);
+	dev_hold(upper);
 	rcu_read_unlock();
 
 	return upper;
@@ -509,8 +508,7 @@ batadv_mcast_mla_softif_get(struct net_device *dev,
 	}
 
 out:
-	if (bridge)
-		dev_put(bridge);
+	dev_put(bridge);
 
 	return ret4 + ret6;
 }
@@ -2239,8 +2237,7 @@ batadv_mcast_netlink_get_primary(struct netlink_callback *cb,
 	}
 
 out:
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	if (!ret && primary_if)
 		*primary_if = hard_iface;
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index da7249448474..6a4d3f437e00 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -799,12 +799,10 @@ int batadv_hardif_neigh_dump(struct sk_buff *msg, struct netlink_callback *cb)
  out:
 	if (hardif)
 		batadv_hardif_put(hardif);
-	if (hard_iface)
-		dev_put(hard_iface);
+	dev_put(hard_iface);
 	if (primary_if)
 		batadv_hardif_put(primary_if);
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	return ret;
 }
@@ -1412,12 +1410,10 @@ int batadv_orig_dump(struct sk_buff *msg, struct netlink_callback *cb)
  out:
 	if (hardif)
 		batadv_hardif_put(hardif);
-	if (hard_iface)
-		dev_put(hard_iface);
+	dev_put(hard_iface);
 	if (primary_if)
 		batadv_hardif_put(primary_if);
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	return ret;
 }
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 434b4f042909..711fe5a2cec4 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -820,8 +820,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 out:
 	if (in_hardif)
 		batadv_hardif_put(in_hardif);
-	if (in_dev)
-		dev_put(in_dev);
+	dev_put(in_dev);
 	if (tt_local)
 		batadv_tt_local_entry_put(tt_local);
 	if (tt_global)
@@ -1217,8 +1216,7 @@ int batadv_tt_local_dump(struct sk_buff *msg, struct netlink_callback *cb)
  out:
 	if (primary_if)
 		batadv_hardif_put(primary_if);
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	cb->args[0] = bucket;
 	cb->args[1] = idx;
@@ -2005,8 +2003,7 @@ int batadv_tt_global_dump(struct sk_buff *msg, struct netlink_callback *cb)
  out:
 	if (primary_if)
 		batadv_hardif_put(primary_if);
-	if (soft_iface)
-		dev_put(soft_iface);
+	dev_put(soft_iface);
 
 	cb->args[0] = bucket;
 	cb->args[1] = idx;
diff --git a/net/can/raw.c b/net/can/raw.c
index cd5a49380116..7105fa4824e4 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -592,9 +592,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		ro->count  = count;
 
  out_fil:
-		if (dev)
-			dev_put(dev);
-
+		dev_put(dev);
 		release_sock(sk);
 		rtnl_unlock();
 
@@ -638,9 +636,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		ro->err_mask = err_mask;
 
  out_err:
-		if (dev)
-			dev_put(dev);
-
+		dev_put(dev);
 		release_sock(sk);
 		rtnl_unlock();
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 5af0ba1ed473..eaaeff404ce9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -831,8 +831,7 @@ struct net_device *dev_get_by_name(struct net *net, const char *name)
 
 	rcu_read_lock();
 	dev = dev_get_by_name_rcu(net, name);
-	if (dev)
-		dev_hold(dev);
+	dev_hold(dev);
 	rcu_read_unlock();
 	return dev;
 }
@@ -905,8 +904,7 @@ struct net_device *dev_get_by_index(struct net *net, int ifindex)
 
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(net, ifindex);
-	if (dev)
-		dev_hold(dev);
+	dev_hold(dev);
 	rcu_read_unlock();
 	return dev;
 }
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index ead2a8aa57b4..49442cae6f69 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -850,8 +850,7 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 	}
 
 	hw_metadata->input_dev = metadata->input_dev;
-	if (hw_metadata->input_dev)
-		dev_hold(hw_metadata->input_dev);
+	dev_hold(hw_metadata->input_dev);
 
 	return hw_metadata;
 
@@ -867,8 +866,7 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 static void
 net_dm_hw_metadata_free(const struct devlink_trap_metadata *hw_metadata)
 {
-	if (hw_metadata->input_dev)
-		dev_put(hw_metadata->input_dev);
+	dev_put(hw_metadata->input_dev);
 	kfree(hw_metadata->fa_cookie);
 	kfree(hw_metadata->trap_name);
 	kfree(hw_metadata->trap_group_name);
diff --git a/net/core/dst.c b/net/core/dst.c
index fb3bcba87744..497ef9b3fc6a 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -49,8 +49,7 @@ void dst_init(struct dst_entry *dst, struct dst_ops *ops,
 	      unsigned short flags)
 {
 	dst->dev = dev;
-	if (dev)
-		dev_hold(dev);
+	dev_hold(dev);
 	dst->ops = ops;
 	dst_init_metrics(dst, dst_default_metrics.metrics, true);
 	dst->expires = 0UL;
@@ -118,8 +117,7 @@ struct dst_entry *dst_destroy(struct dst_entry * dst)
 
 	if (dst->ops->destroy)
 		dst->ops->destroy(dst);
-	if (dst->dev)
-		dev_put(dst->dev);
+	dev_put(dst->dev);
 
 	lwtstate_put(dst->lwtstate);
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 5427c4b9c087..b963d6b02c4f 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -741,12 +741,10 @@ struct pneigh_entry * pneigh_lookup(struct neigh_table *tbl,
 	write_pnet(&n->net, net);
 	memcpy(n->key, pkey, key_len);
 	n->dev = dev;
-	if (dev)
-		dev_hold(dev);
+	dev_hold(dev);
 
 	if (tbl->pconstructor && tbl->pconstructor(n)) {
-		if (dev)
-			dev_put(dev);
+		dev_put(dev);
 		kfree(n);
 		n = NULL;
 		goto out;
@@ -778,8 +776,7 @@ int pneigh_delete(struct neigh_table *tbl, struct net *net, const void *pkey,
 			write_unlock_bh(&tbl->lock);
 			if (tbl->pdestructor)
 				tbl->pdestructor(n);
-			if (n->dev)
-				dev_put(n->dev);
+			dev_put(n->dev);
 			kfree(n);
 			return 0;
 		}
@@ -812,8 +809,7 @@ static int pneigh_ifdown_and_unlock(struct neigh_table *tbl,
 		n->next = NULL;
 		if (tbl->pdestructor)
 			tbl->pdestructor(n);
-		if (n->dev)
-			dev_put(n->dev);
+		dev_put(n->dev);
 		kfree(n);
 	}
 	return -ENOENT;
@@ -1662,8 +1658,7 @@ void neigh_parms_release(struct neigh_table *tbl, struct neigh_parms *parms)
 	list_del(&parms->list);
 	parms->dead = 1;
 	write_unlock_bh(&tbl->lock);
-	if (parms->dev)
-		dev_put(parms->dev);
+	dev_put(parms->dev);
 	call_rcu(&parms->rcu_head, neigh_rcu_free_parms);
 }
 EXPORT_SYMBOL(neigh_parms_release);
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index d1c50a48614b..0ee7d4c0c955 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -521,8 +521,7 @@ int dn_dev_set_default(struct net_device *dev, int force)
 	}
 	spin_unlock(&dndev_lock);
 
-	if (old)
-		dev_put(old);
+	dev_put(old);
 	return rv;
 }
 
@@ -536,8 +535,7 @@ static void dn_dev_check_default(struct net_device *dev)
 	}
 	spin_unlock(&dndev_lock);
 
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 }
 
 /*
diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
index 153a5fc1bdde..269c029ad74f 100644
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -92,8 +92,7 @@ void dn_fib_free_info(struct dn_fib_info *fi)
 	}
 
 	change_nexthops(fi) {
-		if (nh->nh_dev)
-			dev_put(nh->nh_dev);
+		dev_put(nh->nh_dev);
 		nh->nh_dev = NULL;
 	} endfor_nexthops(fi);
 	kfree(fi);
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 729d3de6020d..7e85f2a1ae25 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1026,8 +1026,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 	if (!fld.daddr) {
 		fld.daddr = fld.saddr;
 
-		if (dev_out)
-			dev_put(dev_out);
+		dev_put(dev_out);
 		err = -EINVAL;
 		dev_out = init_net.loopback_dev;
 		if (!dev_out->dn_ptr)
@@ -1084,8 +1083,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 					neigh_release(neigh);
 					neigh = NULL;
 				} else {
-					if (dev_out)
-						dev_put(dev_out);
+					dev_put(dev_out);
 					if (dn_dev_islocal(neigh->dev, fld.daddr)) {
 						dev_out = init_net.loopback_dev;
 						res.type = RTN_LOCAL;
@@ -1144,8 +1142,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 	if (res.type == RTN_LOCAL) {
 		if (!fld.saddr)
 			fld.saddr = fld.daddr;
-		if (dev_out)
-			dev_put(dev_out);
+		dev_put(dev_out);
 		dev_out = init_net.loopback_dev;
 		dev_hold(dev_out);
 		if (!dev_out->dn_ptr)
@@ -1168,8 +1165,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 	if (!fld.saddr)
 		fld.saddr = DN_FIB_RES_PREFSRC(res);
 
-	if (dev_out)
-		dev_put(dev_out);
+	dev_put(dev_out);
 	dev_out = DN_FIB_RES_DEV(res);
 	dev_hold(dev_out);
 	fld.flowidn_oif = dev_out->ifindex;
@@ -1222,8 +1218,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 		neigh_release(neigh);
 	if (free_res)
 		dn_fib_res_put(&res);
-	if (dev_out)
-		dev_put(dev_out);
+	dev_put(dev_out);
 out:
 	return err;
 
@@ -1503,8 +1498,7 @@ static int dn_route_input_slow(struct sk_buff *skb)
 	if (free_res)
 		dn_fib_res_put(&res);
 	dev_put(in_dev);
-	if (out_dev)
-		dev_put(out_dev);
+	dev_put(out_dev);
 out:
 	return err;
 
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 417aaf9ca219..f8bca08e727e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -398,8 +398,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 		ops->cleanup_data(reply_data);
 
 	genlmsg_end(rskb, reply_payload);
-	if (req_info->dev)
-		dev_put(req_info->dev);
+	dev_put(req_info->dev);
 	kfree(reply_data);
 	kfree(req_info);
 	return genlmsg_reply(rskb, info);
@@ -411,8 +410,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	if (ops->cleanup_data)
 		ops->cleanup_data(reply_data);
 err_dev:
-	if (req_info->dev)
-		dev_put(req_info->dev);
+	dev_put(req_info->dev);
 	kfree(reply_data);
 	kfree(req_info);
 	return ret;
diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index 88215b5c93aa..dd5a45f8a78a 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -340,8 +340,7 @@ int ieee802154_del_iface(struct sk_buff *skb, struct genl_info *info)
 out_dev:
 	wpan_phy_put(phy);
 out:
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 
 	return rc;
 }
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 0cf2374c143b..277124f206e0 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2226,8 +2226,7 @@ static void nl802154_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		if (ops->internal_flags & NL802154_FLAG_NEED_WPAN_DEV) {
 			struct wpan_dev *wpan_dev = info->user_ptr[1];
 
-			if (wpan_dev->netdev)
-				dev_put(wpan_dev->netdev);
+			dev_put(wpan_dev->netdev);
 		} else {
 			dev_put(info->user_ptr[1]);
 		}
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index f5077de3619e..90233efa1f6b 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -41,8 +41,7 @@ ieee802154_get_dev(struct net *net, const struct ieee802154_addr *addr)
 		ieee802154_devaddr_to_raw(hwaddr, addr->extended_addr);
 		rcu_read_lock();
 		dev = dev_getbyhwaddr_rcu(net, ARPHRD_IEEE802154, hwaddr);
-		if (dev)
-			dev_hold(dev);
+		dev_hold(dev);
 		rcu_read_unlock();
 		break;
 	case IEEE802154_ADDR_SHORT:
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f29feb7772da..b42c429cebbe 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -208,9 +208,7 @@ static void rt_fibinfo_free_cpus(struct rtable __rcu * __percpu *rtp)
 
 void fib_nh_common_release(struct fib_nh_common *nhc)
 {
-	if (nhc->nhc_dev)
-		dev_put(nhc->nhc_dev);
-
+	dev_put(nhc->nhc_dev);
 	lwtstate_put(nhc->nhc_lwtstate);
 	rt_fibinfo_free_cpus(nhc->nhc_pcpu_rth_output);
 	rt_fibinfo_free(&nhc->nhc_rth_input);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index c695d294a5df..8b30cadff708 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1095,8 +1095,7 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 					 sizeof(struct in6_addr))
 				goto send_mal_query;
 			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
-			if (dev)
-				dev_hold(dev);
+			dev_hold(dev);
 			break;
 #endif
 		default:
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 44a96cfcfbdf..b181773d7ad3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2813,8 +2813,7 @@ struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_or
 		new->output = dst_discard_out;
 
 		new->dev = net->loopback_dev;
-		if (new->dev)
-			dev_hold(new->dev);
+		dev_hold(new->dev);
 
 		rt->rt_is_input = ort->rt_is_input;
 		rt->rt_iif = ort->rt_iif;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 0b786fc7b7d4..8381288a0d6e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -701,8 +701,7 @@ static int inet6_netconf_get_devconf(struct sk_buff *in_skb,
 errout:
 	if (in6_dev)
 		in6_dev_put(in6_dev);
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 	return err;
 }
 
@@ -5417,8 +5416,7 @@ static int inet6_rtm_getaddr(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 errout_ifa:
 	in6_ifa_put(ifa);
 errout:
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 	if (fillargs.netnsid >= 0)
 		put_net(tgt_net);
 
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 06b0d2c329b9..36ed9efb8825 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -559,8 +559,7 @@ static int pim6_rcv(struct sk_buff *skb)
 	read_lock(&mrt_lock);
 	if (reg_vif_num >= 0)
 		reg_dev = mrt->vif_table[reg_vif_num].dev;
-	if (reg_dev)
-		dev_hold(reg_dev);
+	dev_hold(reg_dev);
 	read_unlock(&mrt_lock);
 
 	if (!reg_dev)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 6b8051106aba..6cf4bb89ca69 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3626,8 +3626,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	if (err) {
 		lwtstate_put(fib6_nh->fib_nh_lws);
 		fib6_nh->fib_nh_lws = NULL;
-		if (dev)
-			dev_put(dev);
+		dev_put(dev);
 	}
 
 	return err;
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index ac5cadd02cfa..3086f4a6ae68 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -224,8 +224,7 @@ static int llc_ui_release(struct socket *sock)
 	} else {
 		release_sock(sk);
 	}
-	if (llc->dev)
-		dev_put(llc->dev);
+	dev_put(llc->dev);
 	sock_put(sk);
 	llc_sk_free(sk);
 out:
@@ -363,8 +362,7 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 	} else
 		llc->dev = dev_getbyhwaddr_rcu(&init_net, addr->sllc_arphrd,
 					   addr->sllc_mac);
-	if (llc->dev)
-		dev_hold(llc->dev);
+	dev_hold(llc->dev);
 	rcu_read_unlock();
 	if (!llc->dev)
 		goto out;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index f92006cec94c..2bfd9f1b8f11 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -251,8 +251,7 @@ static int flow_offload_eth_src(struct net *net,
 	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 8,
 			    &val, &mask);
 
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 
 	return 0;
 }
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index bbd1209694b8..7f2f69b609d8 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -51,18 +51,14 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	struct nf_hook_state *state = &entry->state;
 
 	/* Release those devices we held, or Alexey will kill me. */
-	if (state->in)
-		dev_put(state->in);
-	if (state->out)
-		dev_put(state->out);
+	dev_put(state->in);
+	dev_put(state->out);
 	if (state->sk)
 		sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	if (entry->physin)
-		dev_put(entry->physin);
-	if (entry->physout)
-		dev_put(entry->physout);
+	dev_put(entry->physin);
+	dev_put(entry->physout);
 #endif
 }
 
@@ -95,18 +91,14 @@ void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
 
-	if (state->in)
-		dev_hold(state->in);
-	if (state->out)
-		dev_hold(state->out);
+	dev_hold(state->in);
+	dev_hold(state->out);
 	if (state->sk)
 		sock_hold(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	if (entry->physin)
-		dev_hold(entry->physin);
-	if (entry->physout)
-		dev_hold(entry->physout);
+	dev_hold(entry->physin);
+	dev_hold(entry->physout);
 #endif
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 2483df0bbd7c..566ba4397ee4 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -492,8 +492,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		netlbl_af4list_audit_addr(audit_buf, 1,
 					  (dev != NULL ? dev->name : NULL),
 					  addr->s_addr, mask->s_addr);
-		if (dev != NULL)
-			dev_put(dev);
+		dev_put(dev);
 		if (entry != NULL &&
 		    security_secid_to_secctx(entry->secid,
 					     &secctx, &secctx_len) == 0) {
@@ -553,8 +552,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		netlbl_af6list_audit_addr(audit_buf, 1,
 					  (dev != NULL ? dev->name : NULL),
 					  addr, mask);
-		if (dev != NULL)
-			dev_put(dev);
+		dev_put(dev);
 		if (entry != NULL &&
 		    security_secid_to_secctx(entry->secid,
 					     &secctx, &secctx_len) == 0) {
diff --git a/net/netrom/nr_loopback.c b/net/netrom/nr_loopback.c
index a880dd33e901..511819fbfa67 100644
--- a/net/netrom/nr_loopback.c
+++ b/net/netrom/nr_loopback.c
@@ -59,8 +59,7 @@ static void nr_loopback_timer(struct timer_list *unused)
 		if (dev == NULL || nr_rx_frame(skb, dev) == 0)
 			kfree_skb(skb);
 
-		if (dev != NULL)
-			dev_put(dev);
+		dev_put(dev);
 
 		if (!skb_queue_empty(&loopback_queue) && !nr_loopback_running())
 			mod_timer(&loopback_timer, jiffies + 10);
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index de0456073dc0..ddd5cbd455e3 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -582,8 +582,7 @@ struct net_device *nr_dev_first(void)
 			if (first == NULL || strncmp(dev->name, first->name, 3) < 0)
 				first = dev;
 	}
-	if (first)
-		dev_hold(first);
+	dev_hold(first);
 	rcu_read_unlock();
 
 	return first;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 57a1971f29e5..543365f58e97 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -250,8 +250,7 @@ static struct net_device *packet_cached_dev_get(struct packet_sock *po)
 
 	rcu_read_lock();
 	dev = rcu_dereference(po->cached_dev);
-	if (likely(dev))
-		dev_hold(dev);
+	dev_hold(dev);
 	rcu_read_unlock();
 
 	return dev;
@@ -3024,8 +3023,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 out_free:
 	kfree_skb(skb);
 out_unlock:
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 out:
 	return err;
 }
@@ -3158,8 +3156,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		}
 	}
 
-	if (dev)
-		dev_hold(dev);
+	dev_hold(dev);
 
 	proto_curr = po->prot_hook.type;
 	dev_curr = po->prot_hook.dev;
@@ -3196,8 +3193,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 			packet_cached_dev_assign(po, dev);
 		}
 	}
-	if (dev_curr)
-		dev_put(dev_curr);
+	dev_put(dev_curr);
 
 	if (proto == 0 || !need_rehook)
 		goto out_unlock;
@@ -4109,8 +4105,7 @@ static int packet_notifier(struct notifier_block *this,
 				if (msg == NETDEV_UNREGISTER) {
 					packet_cached_dev_reset(po);
 					WRITE_ONCE(po->ifindex, -1);
-					if (po->prot_hook.dev)
-						dev_put(po->prot_hook.dev);
+					dev_put(po->prot_hook.dev);
 					po->prot_hook.dev = NULL;
 				}
 				spin_unlock(&po->bind_lock);
diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
index ca6ae4c59433..65218b7ce9f9 100644
--- a/net/phonet/af_phonet.c
+++ b/net/phonet/af_phonet.c
@@ -275,8 +275,7 @@ int pn_skb_send(struct sock *sk, struct sk_buff *skb,
 
 drop:
 	kfree_skb(skb);
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 	return err;
 }
 EXPORT_SYMBOL(pn_skb_send);
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 876d0ae5f9fd..cde671d29d5d 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -122,8 +122,7 @@ struct net_device *phonet_device_get(struct net *net)
 			break;
 		dev = NULL;
 	}
-	if (dev)
-		dev_hold(dev);
+	dev_hold(dev);
 	rcu_read_unlock();
 	return dev;
 }
@@ -411,8 +410,7 @@ struct net_device *phonet_route_output(struct net *net, u8 daddr)
 	daddr >>= 2;
 	rcu_read_lock();
 	dev = rcu_dereference(routes->table[daddr]);
-	if (dev)
-		dev_hold(dev);
+	dev_hold(dev);
 	rcu_read_unlock();
 
 	if (!dev)
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 2599235d592e..71e2caf6ab85 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -379,8 +379,7 @@ static int pn_socket_ioctl(struct socket *sock, unsigned int cmd,
 			saddr = PN_NO_ADDR;
 		release_sock(sk);
 
-		if (dev)
-			dev_put(dev);
+		dev_put(dev);
 		if (saddr == PN_NO_ADDR)
 			return -EHOSTUNREACH;
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 77ee80e3effc..37f51d778728 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -78,8 +78,7 @@ static void tcf_mirred_release(struct tc_action *a)
 
 	/* last reference to action, no need to lock */
 	dev = rcu_dereference_protected(m->tcfm_dev, 1);
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 }
 
 static const struct nla_policy mirred_policy[TCA_MIRRED_MAX + 1] = {
@@ -180,8 +179,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		mac_header_xmit = dev_is_mac_header_xmit(dev);
 		dev = rcu_replace_pointer(m->tcfm_dev, dev,
 					  lockdep_is_held(&m->tcf_lock));
-		if (dev)
-			dev_put(dev);
+		dev_put(dev);
 		m->tcfm_mac_header_xmit = mac_header_xmit;
 	}
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 7d7ba0320d5a..a8845343d183 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -753,8 +753,7 @@ void smc_ib_ndev_change(struct net_device *ndev, unsigned long event)
 			if (!libdev->ops.get_netdev)
 				continue;
 			lndev = libdev->ops.get_netdev(libdev, i + 1);
-			if (lndev)
-				dev_put(lndev);
+			dev_put(lndev);
 			if (lndev != ndev)
 				continue;
 			if (event == NETDEV_REGISTER)
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 6f6d33edb135..4a964e9190b0 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -394,8 +394,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	return 0;
 
 out_put:
-	if (ndev)
-		dev_put(ndev);
+	dev_put(ndev);
 	return rc;
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 16c88beea48b..dceed5b5b226 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6527,8 +6527,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	err = rdev_change_station(rdev, dev, mac_addr, &params);
 
  out_put_vlan:
-	if (params.vlan)
-		dev_put(params.vlan);
+	dev_put(params.vlan);
 
 	return err;
 }
@@ -6763,8 +6762,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	err = rdev_add_station(rdev, dev, mac_addr, &params);
 
-	if (params.vlan)
-		dev_put(params.vlan);
+	dev_put(params.vlan);
 	return err;
 }
 
@@ -8489,8 +8487,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		goto out_free;
 
 	nl80211_send_scan_start(rdev, wdev);
-	if (wdev->netdev)
-		dev_hold(wdev->netdev);
+	dev_hold(wdev->netdev);
 
 	return 0;
 
@@ -14860,9 +14857,7 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			return -ENETDOWN;
 		}
 
-		if (dev)
-			dev_hold(dev);
-
+		dev_hold(dev);
 		info->user_ptr[0] = rdev;
 	}
 
@@ -14884,8 +14879,7 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		if (ops->internal_flags & NL80211_FLAG_NEED_WDEV) {
 			struct wireless_dev *wdev = info->user_ptr[1];
 
-			if (wdev->netdev)
-				dev_put(wdev->netdev);
+			dev_put(wdev->netdev);
 		} else {
 			dev_put(info->user_ptr[1]);
 		}
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7897b1478c3c..11c68b159324 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -975,8 +975,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 	}
 #endif
 
-	if (wdev->netdev)
-		dev_put(wdev->netdev);
+	dev_put(wdev->netdev);
 
 	kfree(rdev->int_scan_req);
 	rdev->int_scan_req = NULL;
-- 
2.32.0

