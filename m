Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9141E506D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgE0VZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0VZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:25:45 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5A6C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:45 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh7so3746404plb.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F2RtY5oOCd6DP/a49eiRDoZevGghGXUim/GfrjpbJWc=;
        b=QnwiAzhE4rzEUdbW0SbpvyjXxNg2FmilwFqNCA5mR1FWVm5cfZCb3yswpnelYBTJa+
         e+kU4s02WDCIojgiEmQrd+lZkh6uRaYqeiMc6KocM5Jju77Np2VmTNhyPW+FrcKLLoZa
         SsUBHsLLWxtcx11S6biASSJcJHW5P3k/Ae15g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F2RtY5oOCd6DP/a49eiRDoZevGghGXUim/GfrjpbJWc=;
        b=peUqOCN6uQSFRCLKp3DtmLjBwfiefYPqMG6sv1WUzErRQ4HE9fxFtbUeRTj2nTue+9
         OeIJZ/9Nx3r60MkxFCWafv03VVqPFR/0HZWmbEJD9OiCkVAsCN54vHoPCnz+NiDTmCDc
         E4NEnrpjKKOQrAEPd7FTpRnUsXOYsZD6y/TY656FW2O7qEphoOnnNLx9deGaT7WVpSCY
         GrScCyYEiKNsyADILzRT4CqBQweGfc7wfw7L4SrmwJ9zBR+38ufOYlakoRD9P9DwBuTR
         mqj8TN2iozwWzJkzGcryCir66c0S1w2LbFahxxTydMP/DXCC3DtMdDbB36ujariBwz/1
         TfmA==
X-Gm-Message-State: AOAM532COFBCa0MuCI61Ag/vvxchBqunfa8esaxxi0bmhUVzW223BZF/
        yy7qY/kNqXoEP5uW5ID3er+m6JdTkRI9tPxKW5LqUkyLkKtWDuOYFqnrz1ODUMukrhRkI4UbNg2
        9XBLZNRY8qPCJJze9ipxmXVq9ADEjRBonvAsA+wMuccUod1wNaKQYqUznlt3lB8rTqNFELEFj
X-Google-Smtp-Source: ABdhPJyqHgvRjU62115kuXIc5fR/qknFn+4HRF5cuEai91IL/lo+Dp71EQ0sGXVrfkH6ZSOpJyH2Dw==
X-Received: by 2002:a17:902:c686:: with SMTP id r6mr332166plx.147.1590614744458;
        Wed, 27 May 2020 14:25:44 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:25:43 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 02/11] net: do away with the IFF_XMIT_DST_RELEASE_PERM flag
Date:   Wed, 27 May 2020 14:25:03 -0700
Message-Id: <20200527212512.17901-3-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFF_XMIT_DST_RELEASE_PERM is redundant. It is only ever set by
alloc_netdev_mqs() which also sets IFF_XMIT_DST_RELEASE. And, whenever
IFF_XMIT_DST_RELEASE_PERM is cleared, this only in netif_keep_dst(),
so too IFF_XMIT_DST_RELEASE is cleared. That is, any change to the
IFF_XMIT_DST_RELEASE_PERM flag implies a corresponding update to
IFF_XMIT_DST_RELEASE.

The converse is not universally true, but where this is not the
case, it doesn't matter. While IFF_XMIT_DST_RELEASE can become
cleared independently of IFF_XMIT_DST_RELEASE_PERM, the former is
generally never set anywhere the latter is not. The only exception
to this is the VLAN driver, more on this later.

The IFF_XMIT_DST_RELEASE_PERM flag is used when computing features of
team style aggregate devices. Here the general pattern is:

	flags = IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM;

	for each slave_dev {
		flags &= slave_dev->priv_flags;
	}

	master_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
	if (flags == (IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM))
		master_dev->priv_flags |= IFF_XMIT_DST_RELEASE;

The bonding driver differs slightly from this pattern, having an
additional conjunction testing IFF_XMIT_DST_RELEASE_PERM of the master
device. This term can be ignored, however, since it is always true, the
bonding driver never changes the default value of this flag.

Given slave flags, the truth table for IFF_XMIT_DST_RELEASE of the master
device is given by:

CASE | IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM | RESULT
-----+----------------------+---------------------------+-------
1.   |          0           |             0             |   0
2.   |          0           |             1             |   0
3.   |          1           |             0             |   0
4.   |          1           |             1             |   1

With the exception of VLAN devices, case 3 is impossible. Most devices
fall into case 1 or 4, with a device starting out with both flags set
and making use of the netif_keep_dst() interface to clear both flags as
needed. Aggregate devices, if they are nested and have a slave that
keeps dst, are an example of case 2. This class of device begins with
IFF_XMIT_DST_RELEASE cleared and always leaves IFF_XMIT_DST_RELEASE_PERM
set, never touching it. Thus, barring VLAN devices, a slave device needs
IFF_XMIT_DST_RELEASE set, and only this set, in order for the resultant
flag to be set. The same logical argument generalizes to multiple slave
devices as well as arbitrarily nested devices, any single slave or
nested device that has IFF_XMIT_DST_RELEASE cleared will result in the
master device having the flag cleared, but IFF_XMIT_DST_RELEASE_PERM
will always remain set, ensuring case 3 is again impossible.

Before commit 0287587884b15 ("net: better IFF_XMIT_DST_RELEASE support"),
VLAN devices behaved the same way as the aggregate devices, each
starting with IFF_XMIT_RELEASE_DST cleared and later setting it based on
the requirements of the underlying real device. This change introduced
netif_keep_dst() and converted VLAN devices to use the new interface,
with the side effect that IFF_XMIT_RELEASE_DST_PERM is now always
cleared in vlan_setup() and can never become set. This change in
behavior introduces a subtle bug, since now any VLAN device enslaved
to an aggregate device will unconditionally hold on to dst even if the
underlying device no longer needs it. Thus, while VLAN devices are an
example of case 3, they should not be and so IFF_XMIT_DST_RELEASE_PERM
can be safely removed restoring the correct VLAN behavior.

Fixes: 0287587884b15 ("net: better IFF_XMIT_DST_RELEASE support")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/bonding/bond_main.c | 12 ++++--------
 drivers/net/net_failover.c      | 16 ++++++++--------
 drivers/net/team/team.c         | 11 ++++-------
 include/linux/netdevice.h       |  6 +-----
 net/core/dev.c                  |  2 +-
 5 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a25c65d4af71..4c45f1692934 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1132,8 +1132,6 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 
 static void bond_compute_features(struct bonding *bond)
 {
-	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
-					IFF_XMIT_DST_RELEASE_PERM;
 	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
 	netdev_features_t enc_features  = BOND_ENC_FEATURES;
 	netdev_features_t mpls_features  = BOND_MPLS_FEATURES;
@@ -1148,6 +1146,7 @@ static void bond_compute_features(struct bonding *bond)
 		goto done;
 	vlan_features &= NETIF_F_ALL_FOR_ALL;
 	mpls_features &= NETIF_F_ALL_FOR_ALL;
+	bond_dev->priv_flags |= IFF_XMIT_DST_RELEASE;
 
 	bond_for_each_slave(bond, slave, iter) {
 		vlan_features = netdev_increment_features(vlan_features,
@@ -1161,7 +1160,9 @@ static void bond_compute_features(struct bonding *bond)
 							  slave->dev->mpls_features,
 							  BOND_MPLS_FEATURES);
 
-		dst_release_flag &= slave->dev->priv_flags;
+		bond_dev->priv_flags &= slave->dev->priv_flags |
+					~IFF_XMIT_DST_RELEASE;
+
 		if (slave->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = slave->dev->hard_header_len;
 
@@ -1180,11 +1181,6 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->gso_max_segs = gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);
 
-	bond_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
-	if ((bond_dev->priv_flags & IFF_XMIT_DST_RELEASE_PERM) &&
-	    dst_release_flag == (IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM))
-		bond_dev->priv_flags |= IFF_XMIT_DST_RELEASE;
-
 	netdev_change_features(bond_dev);
 }
 
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index b16a1221d19b..436945e0a4c1 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -382,11 +382,11 @@ static void net_failover_compute_features(struct net_device *dev)
 					  NETIF_F_ALL_FOR_ALL;
 	netdev_features_t enc_features  = FAILOVER_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
-	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
-					IFF_XMIT_DST_RELEASE_PERM;
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	struct net_device *primary_dev, *standby_dev;
 
+	dev->priv_flags |= IFF_XMIT_DST_RELEASE;
+
 	primary_dev = rcu_dereference(nfo_info->primary_dev);
 	if (primary_dev) {
 		vlan_features =
@@ -398,7 +398,9 @@ static void net_failover_compute_features(struct net_device *dev)
 						  primary_dev->hw_enc_features,
 						  FAILOVER_ENC_FEATURES);
 
-		dst_release_flag &= primary_dev->priv_flags;
+		dev->priv_flags &= primary_dev->priv_flags |
+				   ~IFF_XMIT_DST_RELEASE;
+
 		if (primary_dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = primary_dev->hard_header_len;
 	}
@@ -414,7 +416,9 @@ static void net_failover_compute_features(struct net_device *dev)
 						  standby_dev->hw_enc_features,
 						  FAILOVER_ENC_FEATURES);
 
-		dst_release_flag &= standby_dev->priv_flags;
+		dev->priv_flags &= standby_dev->priv_flags |
+				   ~IFF_XMIT_DST_RELEASE;
+
 		if (standby_dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = standby_dev->hard_header_len;
 	}
@@ -423,10 +427,6 @@ static void net_failover_compute_features(struct net_device *dev)
 	dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
 	dev->hard_header_len = max_hard_header_len;
 
-	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
-	if (dst_release_flag == (IFF_XMIT_DST_RELEASE |
-				 IFF_XMIT_DST_RELEASE_PERM))
-		dev->priv_flags |= IFF_XMIT_DST_RELEASE;
 
 	netdev_change_features(dev);
 }
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8c1e02752ff6..5987fc2db031 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -988,8 +988,8 @@ static void __team_compute_features(struct team *team)
 					  NETIF_F_ALL_FOR_ALL;
 	netdev_features_t enc_features  = TEAM_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
-	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
-					IFF_XMIT_DST_RELEASE_PERM;
+
+	team->dev->priv_flags |= IFF_XMIT_DST_RELEASE;
 
 	list_for_each_entry(port, &team->port_list, list) {
 		vlan_features = netdev_increment_features(vlan_features,
@@ -1000,8 +1000,9 @@ static void __team_compute_features(struct team *team)
 						  port->dev->hw_enc_features,
 						  TEAM_ENC_FEATURES);
 
+		team->dev->priv_flags &= port->dev->priv_flags |
+					 ~IFF_XMIT_DST_RELEASE;
 
-		dst_release_flag &= port->dev->priv_flags;
 		if (port->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = port->dev->hard_header_len;
 	}
@@ -1012,10 +1013,6 @@ static void __team_compute_features(struct team *team)
 				     NETIF_F_HW_VLAN_STAG_TX |
 				     NETIF_F_GSO_UDP_L4;
 	team->dev->hard_header_len = max_hard_header_len;
-
-	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
-	if (dst_release_flag == (IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM))
-		team->dev->priv_flags |= IFF_XMIT_DST_RELEASE;
 }
 
 static void team_compute_features(struct team *team)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a96e9c4ec36..fe7705eaad5a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1516,8 +1516,6 @@ struct net_device_ops {
  * @IFF_LIVE_ADDR_CHANGE: device supports hardware address
  *	change when it's running
  * @IFF_MACVLAN: Macvlan device
- * @IFF_XMIT_DST_RELEASE_PERM: IFF_XMIT_DST_RELEASE not taking into account
- *	underlying stacked devices
  * @IFF_L3MDEV_MASTER: device is an L3 master device
  * @IFF_NO_QUEUE: device can run without qdisc attached
  * @IFF_OPENVSWITCH: device is a Open vSwitch master
@@ -1551,7 +1549,6 @@ enum netdev_priv_flags {
 	IFF_SUPP_NOFCS			= 1<<14,
 	IFF_LIVE_ADDR_CHANGE		= 1<<15,
 	IFF_MACVLAN			= 1<<16,
-	IFF_XMIT_DST_RELEASE_PERM	= 1<<17,
 	IFF_L3MDEV_MASTER		= 1<<18,
 	IFF_NO_QUEUE			= 1<<19,
 	IFF_OPENVSWITCH			= 1<<20,
@@ -1584,7 +1581,6 @@ enum netdev_priv_flags {
 #define IFF_SUPP_NOFCS			IFF_SUPP_NOFCS
 #define IFF_LIVE_ADDR_CHANGE		IFF_LIVE_ADDR_CHANGE
 #define IFF_MACVLAN			IFF_MACVLAN
-#define IFF_XMIT_DST_RELEASE_PERM	IFF_XMIT_DST_RELEASE_PERM
 #define IFF_L3MDEV_MASTER		IFF_L3MDEV_MASTER
 #define IFF_NO_QUEUE			IFF_NO_QUEUE
 #define IFF_OPENVSWITCH			IFF_OPENVSWITCH
@@ -4853,7 +4849,7 @@ static inline bool netif_is_failover_slave(const struct net_device *dev)
 /* This device needs to keep skb dst for qdisc enqueue or ndo_start_xmit() */
 static inline void netif_keep_dst(struct net_device *dev)
 {
-	dev->priv_flags &= ~(IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM);
+	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 }
 
 /* return true if dev can't cope with mtu frames that need vlan tag insertion */
diff --git a/net/core/dev.c b/net/core/dev.c
index ae37586f6ee8..fb663e2f60eb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9944,7 +9944,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 #ifdef CONFIG_NET_SCHED
 	hash_init(dev->qdisc_hash);
 #endif
-	dev->priv_flags = IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM;
+	dev->priv_flags = IFF_XMIT_DST_RELEASE;
 	setup(dev);
 
 	if (!dev->tx_queue_len) {
-- 
2.26.2

