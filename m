Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA81457128
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhKSOwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235337AbhKSOwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:52:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7FDB615E2;
        Fri, 19 Nov 2021 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637333356;
        bh=oLkNvNwqxRbFvbTkGiuCR3MkEEh94mTDpOBNhsBD7QI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ex/M8vV+83ctDHEMzRjaJgu4DVjbr5ofHkEFMgkfWw+nEUAR8QRez4F28RhzFISUV
         N3KnlBrApQ0zhesbffh3cC8LblpQOkt/rss0gOmvff2a+iYwOrsWc5GlT9/D9LjhFO
         LB4hawdjco5W2mzBNyOD+Kb8Xhr29gMx4kh/nAqmpbF8ekZXZUXDOgOvAD2ntyaKMg
         9pkEWVYEnCftSz6IV2WxKBQgKrTyQZi6XdBGyLlqu1j3fomaSIFQRlxfLL1J9FsTw5
         0mOjVpc++tykC23L0Cbbh8D6hm4+OmKgZjQg6rwyRTho5RHbjnyq9+nb72sGnlHnfZ
         ZccGYSa+KTU3w==
Date:   Fri, 19 Nov 2021 06:49:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, argeorge@cisco.com
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <20211119064914.56f6872e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZuqkGNRqigj1D5CBaCGvT8xcwzkparmUwUPMMDcp=UmuUQ@mail.gmail.com>
References: <YXmWb2PZJQhpMfrR@shredder>
        <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
        <YXnRup1EJaF5Gwua@shredder>
        <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
        <YXqq19HxleZd6V9W@shredder>
        <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
        <YYeajTs6d4j39rJ2@shredder>
        <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YY0uB7OyTRCoNBJQ@shredder>
        <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZDK6JxwcoPvk/Zx@shredder>
        <952e8bb0-bc1e-5600-92f2-de4d6744fcb0@nvidia.com>
        <20211115071109.1bf4875b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZura-Vav599FTVkMb33uY0xtpNkotxU-q8FUiBxoHqXh7Q@mail.gmail.com>
        <20211119060958.31782ca9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZuqkGNRqigj1D5CBaCGvT8xcwzkparmUwUPMMDcp=UmuUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 19:56:51 +0530 sundeep subbaraya wrote:
> On Fri, Nov 19, 2021 at 7:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 19 Nov 2021 16:17:53 +0530 sundeep subbaraya wrote:  
> > > As said by Ido, ndo_change_proto_down with proto_down as
> > > on and off is sufficient for our requirement right now. We will use
> > > ndo_change_proto_down instead of devlink. Thanks everyone for
> > > pitching in.  
> >
> > ndo_change_proto_down is for software devices. Make sure you explain
> > your use case well, otherwise it's going to be a nack.  
> 
> Sorry new to networking stuff here. Where does the below imply it is
> for software devices?
> * void (*ndo_change_proto_down)(struct net_device *dev,
>  *                               bool proto_down);
>  *      This function is used to pass protocol port error state information
>  *      to the switch driver. The switch driver can react to the proto_down
>  *      by doing a phys down on the associated switch port.
> I will find out the use case (pinged customer again)

Don't trust comments or documentation when working on Linux.
Code and git history are the sources of truth.

But you're right in a sense, the software devices which use this
callback today look like pretty fake users to allow out-of-tree
code to do things.

Will anyone who does not work on Cumulus Linus scream if we do this?

----->8---------------

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 19 Nov 2021 06:43:58 -0800
Subject: [PATCH] net: remove .ndo_change_proto_down

.ndo_change_proto_down was added seemingly to enable out-of-tree
implementations. Over 2.5yrs later we still have no real users
upstream. Stub this out for now, we can revert once real users
materialize. (rocker is a test vehicle, not a user.)

We need to drop the optimization on the sysfs side, because
unlike ndos priv_flags will be changed at runtime, so we'd
need READ_ONCE/WRITE_ONCE everywhere..

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_main.c | 12 -----------
 drivers/net/macvlan.c                     |  3 +--
 drivers/net/vxlan.c                       |  3 +--
 include/linux/netdevice.h                 | 11 ++--------
 net/core/dev.c                            | 26 ++++-------------------
 net/core/net-sysfs.c                      |  6 ------
 net/core/rtnetlink.c                      |  3 +--
 7 files changed, 9 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index ba4062881eed..b620470c7905 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1995,17 +1995,6 @@ static int rocker_port_get_phys_port_name(struct net_device *dev,
 	return err ? -EOPNOTSUPP : 0;
 }
 
-static int rocker_port_change_proto_down(struct net_device *dev,
-					 bool proto_down)
-{
-	struct rocker_port *rocker_port = netdev_priv(dev);
-
-	if (rocker_port->dev->flags & IFF_UP)
-		rocker_port_set_enable(rocker_port, !proto_down);
-	rocker_port->dev->proto_down = proto_down;
-	return 0;
-}
-
 static void rocker_port_neigh_destroy(struct net_device *dev,
 				      struct neighbour *n)
 {
@@ -2037,7 +2026,6 @@ static const struct net_device_ops rocker_port_netdev_ops = {
 	.ndo_set_mac_address		= rocker_port_set_mac_address,
 	.ndo_change_mtu			= rocker_port_change_mtu,
 	.ndo_get_phys_port_name		= rocker_port_get_phys_port_name,
-	.ndo_change_proto_down		= rocker_port_change_proto_down,
 	.ndo_neigh_destroy		= rocker_port_neigh_destroy,
 	.ndo_get_port_parent_id		= rocker_port_get_port_parent_id,
 };
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d2f830ec2969..71ad30c10b6e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1171,7 +1171,6 @@ static const struct net_device_ops macvlan_netdev_ops = {
 #endif
 	.ndo_get_iflink		= macvlan_dev_get_iflink,
 	.ndo_features_check	= passthru_features_check,
-	.ndo_change_proto_down  = dev_change_proto_down_generic,
 };
 
 void macvlan_common_setup(struct net_device *dev)
@@ -1182,7 +1181,7 @@ void macvlan_common_setup(struct net_device *dev)
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);
-	dev->priv_flags	       |= IFF_UNICAST_FLT;
+	dev->priv_flags	       |= IFF_UNICAST_FLT | IFF_CHANGE_PROTO_DOWN;
 	dev->netdev_ops		= &macvlan_netdev_ops;
 	dev->needs_free_netdev	= true;
 	dev->header_ops		= &macvlan_hard_header_ops;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 563f86de0e0d..74a28b11260e 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3234,7 +3234,6 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
 	.ndo_fdb_dump		= vxlan_fdb_dump,
 	.ndo_fdb_get		= vxlan_fdb_get,
 	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
-	.ndo_change_proto_down  = dev_change_proto_down_generic,
 };
 
 static const struct net_device_ops vxlan_netdev_raw_ops = {
@@ -3305,7 +3304,7 @@ static void vxlan_setup(struct net_device *dev)
 	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	netif_keep_dst(dev);
-	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE | IFF_CHANGE_PROTO_DOWN;
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cb7f2661d187..647d0960c510 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1297,11 +1297,6 @@ struct netdev_net_notifier {
  *	TX queue.
  * int (*ndo_get_iflink)(const struct net_device *dev);
  *	Called to get the iflink value of this device.
- * void (*ndo_change_proto_down)(struct net_device *dev,
- *				 bool proto_down);
- *	This function is used to pass protocol port error state information
- *	to the switch driver. The switch driver can react to the proto_down
- *      by doing a phys down on the associated switch port.
  * int (*ndo_fill_metadata_dst)(struct net_device *dev, struct sk_buff *skb);
  *	This function is used to get egress tunnel information for given skb.
  *	This is useful for retrieving outer tunnel header parameters while
@@ -1542,8 +1537,6 @@ struct net_device_ops {
 						      int queue_index,
 						      u32 maxrate);
 	int			(*ndo_get_iflink)(const struct net_device *dev);
-	int			(*ndo_change_proto_down)(struct net_device *dev,
-							 bool proto_down);
 	int			(*ndo_fill_metadata_dst)(struct net_device *dev,
 						       struct sk_buff *skb);
 	void			(*ndo_set_rx_headroom)(struct net_device *dev,
@@ -1646,6 +1639,7 @@ enum netdev_priv_flags {
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
 	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_CHANGE_PROTO_DOWN		= 1<<32,
 };
 
 #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
@@ -1982,7 +1976,7 @@ struct net_device {
 
 	/* Read-mostly cache-line for fast-path access */
 	unsigned int		flags;
-	unsigned int		priv_flags;
+	unsigned long long	priv_flags;
 	const struct net_device_ops *netdev_ops;
 	int			ifindex;
 	unsigned short		gflags;
@@ -3735,7 +3729,6 @@ int dev_get_port_parent_id(struct net_device *dev,
 			   struct netdev_phys_item_id *ppid, bool recurse);
 bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
 int dev_change_proto_down(struct net_device *dev, bool proto_down);
-int dev_change_proto_down_generic(struct net_device *dev, bool proto_down);
 void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
 				  u32 value);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
diff --git a/net/core/dev.c b/net/core/dev.c
index 9219e319e901..a2ed933df7fc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8558,35 +8558,17 @@ bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b)
 EXPORT_SYMBOL(netdev_port_same_parent_id);
 
 /**
- *	dev_change_proto_down - update protocol port state information
+ *	dev_change_proto_down - set carrier according to proto_down.
+ *
  *	@dev: device
  *	@proto_down: new value
- *
- *	This info can be used by switch drivers to set the phys state of the
- *	port.
  */
 int dev_change_proto_down(struct net_device *dev, bool proto_down)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
-
-	if (!ops->ndo_change_proto_down)
+	if (!(dev->priv_flags & IFF_CHANGE_PROTO_DOWN))
 		return -EOPNOTSUPP;
 	if (!netif_device_present(dev))
 		return -ENODEV;
-	return ops->ndo_change_proto_down(dev, proto_down);
-}
-EXPORT_SYMBOL(dev_change_proto_down);
-
-/**
- *	dev_change_proto_down_generic - generic implementation for
- * 	ndo_change_proto_down that sets carrier according to
- * 	proto_down.
- *
- *	@dev: device
- *	@proto_down: new value
- */
-int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
-{
 	if (proto_down)
 		netif_carrier_off(dev);
 	else
@@ -8594,7 +8576,7 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
 	dev->proto_down = proto_down;
 	return 0;
 }
-EXPORT_SYMBOL(dev_change_proto_down_generic);
+EXPORT_SYMBOL(dev_change_proto_down);
 
 /**
  *	dev_change_proto_down_reason - proto down reason
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index addbef5419fb..a1ec86bcc9d9 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -490,12 +490,6 @@ static ssize_t proto_down_store(struct device *dev,
 {
 	struct net_device *netdev = to_net_dev(dev);
 
-	/* The check is also done in change_proto_down; this helps returning
-	 * early without hitting the trylock/restart in netdev_store.
-	 */
-	if (!netdev->netdev_ops->ndo_change_proto_down)
-		return -EOPNOTSUPP;
-
 	return netdev_store(dev, attr, buf, len, change_proto_down);
 }
 NETDEVICE_SHOW_RW(proto_down, fmt_dec);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2af8aeeadadf..2ff3369892ff 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2539,13 +2539,12 @@ static int do_set_proto_down(struct net_device *dev,
 			     struct netlink_ext_ack *extack)
 {
 	struct nlattr *pdreason[IFLA_PROTO_DOWN_REASON_MAX + 1];
-	const struct net_device_ops *ops = dev->netdev_ops;
 	unsigned long mask = 0;
 	u32 value;
 	bool proto_down;
 	int err;
 
-	if (!ops->ndo_change_proto_down) {
+	if (!(dev->priv_flags & IFF_CHANGE_PROTO_DOWN)) {
 		NL_SET_ERR_MSG(extack,  "Protodown not supported by device");
 		return -EOPNOTSUPP;
 	}
-- 
2.31.1

