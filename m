Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E4F21CBC5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgGLWQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbgGLWQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:16:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117D6C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o1so4614459plk.1
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ugffQQmakv86gP8mn7N5Eab7Yd5i8vN9F/C2dBVrdS8=;
        b=V+zsgTwpzFweh02DOwRlWsPrhXiHDsiNjk4DxGJTS9KG74wIz00frrmxScn9V2F5KR
         kd6eHNjyiZND+68lw+BvoxmdhSrMTSYTsJXxtav2F4tDsKwvMs6PLoCO9RoR+Kl0foen
         P4YOmyMMr4aYRGUo+pStRoy/WFjA5cA0rEWKsRbibgAzEHNJ8xTSufPtmUESOuHa+bdT
         +srT5aOytMJmJxwHZEuVaLZZXYdne4zIN+hjRpSPd5G4NuvwQ4yiyjHyUYVyN7JHiaD2
         KdghrmvWUe34LOvc9S1zs0qOJCyO1huFUvB8JcZqI4ZxK4kUcVbja3iQdhRiy4kB8Wqk
         7Riw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ugffQQmakv86gP8mn7N5Eab7Yd5i8vN9F/C2dBVrdS8=;
        b=AzOm1gMKkW6bCAFVCgqMfm4TK9zU+DO2pxYDDuOJV8u8B4cHnvaqq4WmUa+b+10og5
         OLN7wjHzcZsjqisU3lBUCbEFPZbabEwPNoGQ5Yqs6tiOVL/Kt86T5oB0HNKfH3P2ap4d
         gEYLfO2Un8Ms1/POW7AsrAjoWouCBEIEs1j345PZbqpSM0qBIqaJE6V+oEz5AQC0mXjM
         pSbuk+0CSHIBzC0sJRfYDBC+Hxm9oQtzZpT3zwKsDPYtVJdLYl04NKUxQY4fZZO6BSze
         OqbmKOdnjFOm+7OrXXJJLcO8NXyqCdvEad9nH/PMsKwHUzO+cMykx/52lTbSmm++RUB9
         kmjw==
X-Gm-Message-State: AOAM5316+ipwETZ+CI+jGRBhc59X38vZeTivHOFdfNHFqcWVYl/tkZ4K
        IchcRDcLcZMv0D1P9ek5qiuf4EF0
X-Google-Smtp-Source: ABdhPJxc7EX6GB2tqqYpWsGxtBmKywlWG/zWcUS1IOGG2cjXnqNbfQWEXt8e15usHEXUj0rsj9l6AQ==
X-Received: by 2002:a17:902:70c2:: with SMTP id l2mr39815211plt.84.1594592197820;
        Sun, 12 Jul 2020 15:16:37 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y198sm12470228pfg.116.2020.07.12.15.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 15:16:37 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, mkubecek@suse.cz, kuba@kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 3/3] net: treewide: Convert to netdev_ops_equal()
Date:   Sun, 12 Jul 2020 15:16:25 -0700
Message-Id: <20200712221625.287763-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200712221625.287763-1-f.fainelli@gmail.com>
References: <20200712221625.287763-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support overloading of netdev_ops which can be done by
specific subsystems such as DSA, utilize netdev_ops_equal() which allows
a network driver implementing a ndo_equal operation to still qualify
whether a net_device::netdev_ops is equal or not to its own.

Mechanical conversion done by spatch with the following SmPL patch:

    @@
    struct net_device *n;
    const struct net_device_ops o;
    identifier netdev_ops;
    @@

    - n->netdev_ops != &o
    + !netdev_ops_equal(n, &o)

    @@
    struct net_device *n;
    const struct net_device_ops o;
    identifier netdev_ops;
    @@

    - n->netdev_ops == &o
    + netdev_ops_equal(n, &o)

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c              | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c           | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c       | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c           | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c        | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c          | 2 +-
 drivers/net/ethernet/mscc/ocelot_net.c                  | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h            | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.h       | 2 +-
 drivers/net/ethernet/rocker/rocker_main.c               | 2 +-
 drivers/net/ethernet/sfc/efx.c                          | 2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                   | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 2 +-
 drivers/net/ethernet/ti/cpsw_new.c                      | 2 +-
 drivers/net/ethernet/via/via-velocity.c                 | 2 +-
 drivers/net/gtp.c                                       | 2 +-
 drivers/net/hyperv/netvsc_drv.c                         | 4 ++--
 drivers/net/ipvlan/ipvlan_main.c                        | 2 +-
 drivers/net/ppp/ppp_generic.c                           | 2 +-
 drivers/net/team/team.c                                 | 2 +-
 drivers/net/tun.c                                       | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 4 ++--
 drivers/net/wireless/quantenna/qtnfmac/core.c           | 2 +-
 drivers/s390/net/qeth_l3_main.c                         | 4 ++--
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c                 | 2 +-
 drivers/staging/unisys/visornic/visornic_main.c         | 2 +-
 net/atm/clip.c                                          | 2 +-
 net/dsa/slave.c                                         | 2 +-
 net/openvswitch/vport-internal_dev.c                    | 4 ++--
 net/openvswitch/vport-internal_dev.h                    | 2 +-
 31 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index dfed9ade6950..e51d01db447c 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2317,7 +2317,7 @@ static int bcm_sysport_map_queues(struct notifier_block *nb,
 	if (info->switch_number)
 		return 0;
 
-	if (dev->netdev_ops != &bcm_sysport_netdev_ops)
+	if (!netdev_ops_equal(dev, &bcm_sysport_netdev_ops))
 		return 0;
 
 	port = info->port_number;
@@ -2377,7 +2377,7 @@ static int bcm_sysport_unmap_queues(struct notifier_block *nb,
 
 	dev = info->master;
 
-	if (dev->netdev_ops != &bcm_sysport_netdev_ops)
+	if (!netdev_ops_equal(dev, &bcm_sysport_netdev_ops))
 		return 0;
 
 	port = info->port_number;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 4b5c8fd76a51..3806ea4eb6ae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -248,7 +248,7 @@ static const struct net_device_ops bnxt_vf_rep_netdev_ops = {
 
 bool bnxt_dev_is_vf_rep(struct net_device *dev)
 {
-	return dev->netdev_ops == &bnxt_vf_rep_netdev_ops;
+	return netdev_ops_equal(dev, &bnxt_vf_rep_netdev_ops);
 }
 
 /* Called when the parent PF interface is closed:
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index 600de587d7a9..a6f7c79692ab 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -622,7 +622,7 @@ lio_vf_rep_netdev_event(struct notifier_block *nb,
 		return NOTIFY_DONE;
 	}
 
-	if (ndev->netdev_ops != &lio_vf_rep_ndev_ops)
+	if (!netdev_ops_equal(ndev, &lio_vf_rep_ndev_ops))
 		return NOTIFY_DONE;
 
 	vf_rep = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 4d898ff21a46..520b6aec8250 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -174,7 +174,7 @@ static const struct net_device_ops ixgbe_netdev_ops;
 
 static bool netif_is_ixgbe(struct net_device *dev)
 {
-	return dev && (dev->netdev_ops == &ixgbe_netdev_ops);
+	return dev && (netdev_ops_equal(dev, &ixgbe_netdev_ops));
 }
 
 static int ixgbe_read_pci_cfg_word_parent(struct ixgbe_adapter *adapter,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0a69f10ac30c..e3e200211d59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -646,12 +646,12 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 
 bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
+	return netdev_ops_equal(netdev, &mlx5e_netdev_ops_uplink_rep);
 }
 
 bool mlx5e_eswitch_vf_rep(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &mlx5e_netdev_ops_rep;
+	return netdev_ops_equal(netdev, &mlx5e_netdev_ops_rep);
 }
 
 static void mlx5e_build_rep_params(struct net_device *netdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b366c46a5604..26328a5e4db7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4913,7 +4913,7 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 	struct mlx5e_tc_table *tc;
 	struct mlx5e_priv *priv;
 
-	if (ndev->netdev_ops != &mlx5e_netdev_ops ||
+	if (!netdev_ops_equal(ndev, &mlx5e_netdev_ops) ||
 	    event != NETDEV_UNREGISTER ||
 	    ndev->reg_state == NETREG_REGISTERED)
 		return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index eeeafd1d82ce..cb8d39f59d29 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3699,7 +3699,7 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
 {
-	return dev->netdev_ops == &mlxsw_sp_port_netdev_ops;
+	return __netdev_ops_equal(dev, &mlxsw_sp_port_netdev_ops);
 }
 
 static int mlxsw_sp_lower_dev_walk(struct net_device *lower_dev, void *data)
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 41a1b5f6df95..df21ecc8eec8 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -866,7 +866,7 @@ static int ocelot_port_obj_del(struct net_device *dev,
 /* Checks if the net_device instance given to us originate from our driver. */
 static bool ocelot_netdevice_dev_check(const struct net_device *dev)
 {
-	return dev->netdev_ops == &ocelot_port_netdev_ops;
+	return __netdev_ops_equal(dev, &ocelot_port_netdev_ops);
 }
 
 static int ocelot_netdevice_port_event(struct net_device *dev,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index ff4438478ea9..cb15c9aa61b9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -921,7 +921,7 @@ extern const struct net_device_ops nfp_net_netdev_ops;
 
 static inline bool nfp_netdev_is_nfp_net(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &nfp_net_netdev_ops;
+	return netdev_ops_equal(netdev, &nfp_net_netdev_ops);
 }
 
 /* Prototypes */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h
index 48a74accbbd3..e37c3488ecfd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h
@@ -77,7 +77,7 @@ extern const struct net_device_ops nfp_repr_netdev_ops;
 
 static inline bool nfp_netdev_is_nfp_repr(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &nfp_repr_netdev_ops;
+	return netdev_ops_equal(netdev, &nfp_repr_netdev_ops);
 }
 
 static inline int nfp_repr_get_port_id(struct net_device *netdev)
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index fc99e7118e49..a076052b1d69 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2713,7 +2713,7 @@ static void rocker_msix_fini(const struct rocker *rocker)
 
 static bool rocker_port_dev_check(const struct net_device *dev)
 {
-	return dev->netdev_ops == &rocker_port_netdev_ops;
+	return __netdev_ops_equal(dev, &rocker_port_netdev_ops);
 }
 
 static int
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index befd253af918..e4dd723b85aa 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -758,7 +758,7 @@ static int efx_netdev_event(struct notifier_block *this,
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
 
-	if ((net_dev->netdev_ops == &efx_netdev_ops) &&
+	if ((netdev_ops_equal(net_dev, &efx_netdev_ops)) &&
 	    event == NETDEV_CHANGENAME)
 		efx_update_name(netdev_priv(net_dev));
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 42bcd34fc508..4062ef3a10db 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2242,7 +2242,7 @@ static int ef4_netdev_event(struct notifier_block *this,
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
 
-	if ((net_dev->netdev_ops == &ef4_netdev_ops) &&
+	if ((netdev_ops_equal(net_dev, &ef4_netdev_ops)) &&
 	    event == NETDEV_CHANGENAME)
 		ef4_update_name(netdev_priv(net_dev));
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 73677c3b33b6..ef90ef10fb14 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4440,7 +4440,7 @@ static int stmmac_device_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (dev->netdev_ops != &stmmac_netdev_ops)
+	if (!netdev_ops_equal(dev, &stmmac_netdev_ops))
 		goto done;
 
 	switch (event) {
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1247d35d42ef..820f8ceb49f3 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1464,7 +1464,7 @@ static int cpsw_register_ports(struct cpsw_common *cpsw)
 
 bool cpsw_port_dev_check(const struct net_device *ndev)
 {
-	if (ndev->netdev_ops == &cpsw_netdev_ops) {
+	if (netdev_ops_equal(ndev, &cpsw_netdev_ops)) {
 		struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 
 		return !cpsw->data.dual_emac;
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 713dbc04b25b..8366764e52f9 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -3674,7 +3674,7 @@ static int velocity_netdev_event(struct notifier_block *nb, unsigned long notifi
 	struct net_device *dev = ifa->ifa_dev->dev;
 
 	if (dev_net(dev) == &init_net &&
-	    dev->netdev_ops == &velocity_netdev_ops)
+	    netdev_ops_equal(dev, &velocity_netdev_ops))
 		velocity_get_ip(netdev_priv(dev));
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 21640a035d7d..2fd828b35729 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -894,7 +894,7 @@ static struct gtp_dev *gtp_find_dev(struct net *src_net, struct nlattr *nla[])
 
 	/* Check if there's an existing gtpX device to configure */
 	dev = dev_get_by_index_rcu(net, nla_get_u32(nla[GTPA_LINK]));
-	if (dev && dev->netdev_ops == &gtp_netdev_ops)
+	if (dev && netdev_ops_equal(dev, &gtp_netdev_ops))
 		gtp = netdev_priv(dev);
 
 	put_net(net);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6267f706e8ee..d9eb87fc7e28 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2101,7 +2101,7 @@ static struct net_device *get_netvsc_byref(struct net_device *vf_netdev)
 	struct net_device *dev;
 
 	dev = netdev_master_upper_dev_get(vf_netdev);
-	if (!dev || dev->netdev_ops != &device_ops)
+	if (!dev || !netdev_ops_equal(dev, &device_ops))
 		return NULL;	/* not a netvsc device */
 
 	net_device_ctx = netdev_priv(dev);
@@ -2628,7 +2628,7 @@ static int netvsc_netdev_event(struct notifier_block *this,
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
 
 	/* Skip our own events */
-	if (event_dev->netdev_ops == &device_ops)
+	if (netdev_ops_equal(event_dev, &device_ops))
 		return NOTIFY_DONE;
 
 	/* Avoid non-Ethernet type devices */
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 15e87c097b0b..aa02c66fb74a 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -376,7 +376,7 @@ static void ipvlan_adjust_mtu(struct ipvl_dev *ipvlan, struct net_device *dev)
 static bool netif_is_ipvlan(const struct net_device *dev)
 {
 	/* both ipvlan and ipvtap devices use the same netdev_ops */
-	return dev->netdev_ops == &ipvlan_netdev_ops;
+	return netdev_ops_equal((struct net_device *)dev, &ipvlan_netdev_ops);
 }
 
 static int ipvlan_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 7d005896a0f9..e36752752833 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1012,7 +1012,7 @@ static __net_exit void ppp_exit_net(struct net *net)
 
 	rtnl_lock();
 	for_each_netdev_safe(net, dev, aux) {
-		if (dev->netdev_ops == &ppp_netdev_ops)
+		if (netdev_ops_equal(dev, &ppp_netdev_ops))
 			unregister_netdevice_queue(dev, &list);
 	}
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8c1e02752ff6..6c1016231135 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2292,7 +2292,7 @@ static struct team *team_nl_team_get(struct genl_info *info)
 
 	ifindex = nla_get_u32(info->attrs[TEAM_ATTR_TEAM_IFINDEX]);
 	dev = dev_get_by_index(net, ifindex);
-	if (!dev || dev->netdev_ops != &team_netdev_ops) {
+	if (!dev || !netdev_ops_equal(dev, &team_netdev_ops)) {
 		if (dev)
 			dev_put(dev);
 		return NULL;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7adeb91bd368..c46f6cff22b6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2697,9 +2697,9 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 	if (dev) {
 		if (ifr->ifr_flags & IFF_TUN_EXCL)
 			return -EBUSY;
-		if ((ifr->ifr_flags & IFF_TUN) && dev->netdev_ops == &tun_netdev_ops)
+		if ((ifr->ifr_flags & IFF_TUN) && netdev_ops_equal(dev, &tun_netdev_ops))
 			tun = netdev_priv(dev);
-		else if ((ifr->ifr_flags & IFF_TAP) && dev->netdev_ops == &tap_netdev_ops)
+		else if ((ifr->ifr_flags & IFF_TAP) && netdev_ops_equal(dev, &tap_netdev_ops))
 			tun = netdev_priv(dev);
 		else
 			return -EINVAL;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index c88655acc78c..2279c3c81d02 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -918,7 +918,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 
 	if (ifp->ndev) {
 		if (bsscfgidx == 0) {
-			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
+			if (netdev_ops_equal(ifp->ndev, &brcmf_netdev_ops_pri)) {
 				rtnl_lock();
 				brcmf_netdev_stop(ifp->ndev);
 				rtnl_unlock();
@@ -927,7 +927,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 			netif_stop_queue(ifp->ndev);
 		}
 
-		if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
+		if (netdev_ops_equal(ifp->ndev, &brcmf_netdev_ops_pri)) {
 			cancel_work_sync(&ifp->multicast_work);
 			cancel_work_sync(&ifp->ndoffload_work);
 		}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index eea777f8acea..b1abecba1f5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -665,7 +665,7 @@ static int qtnf_core_mac_attach(struct qtnf_bus *bus, unsigned int macid)
 
 bool qtnf_netdev_is_qtn(const struct net_device *ndev)
 {
-	return ndev->netdev_ops == &qtnf_netdev_ops;
+	return __netdev_ops_equal(ndev, &qtnf_netdev_ops);
 }
 
 static int qtnf_check_br_ports(struct net_device *dev, void *data)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 1e50aa0297a3..c539c36ff2ae 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2173,8 +2173,8 @@ static struct qeth_card *qeth_l3_get_card_from_dev(struct net_device *dev)
 {
 	if (is_vlan_dev(dev))
 		dev = vlan_dev_real_dev(dev);
-	if (dev->netdev_ops == &qeth_l3_osa_netdev_ops ||
-	    dev->netdev_ops == &qeth_l3_netdev_ops)
+	if (netdev_ops_equal(dev, &qeth_l3_osa_netdev_ops) ||
+	    netdev_ops_equal(dev, &qeth_l3_netdev_ops))
 		return (struct qeth_card *) dev->ml_priv;
 	return NULL;
 }
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 546ad376df99..6edad9df9f7c 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1145,7 +1145,7 @@ static int port_bridge_leave(struct net_device *netdev)
 
 static bool ethsw_port_dev_check(const struct net_device *netdev)
 {
-	return netdev->netdev_ops == &ethsw_port_ops;
+	return __netdev_ops_equal(netdev, &ethsw_port_ops);
 }
 
 static int port_netdevice_event(struct notifier_block *unused,
diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/staging/unisys/visornic/visornic_main.c
index 0433536930a9..517a1aa95226 100644
--- a/drivers/staging/unisys/visornic/visornic_main.c
+++ b/drivers/staging/unisys/visornic/visornic_main.c
@@ -1441,7 +1441,7 @@ static ssize_t info_debugfs_read(struct file *file, char __user *buf,
 	rcu_read_lock();
 	for_each_netdev_rcu(current->nsproxy->net_ns, dev) {
 		/* Only consider netdevs that are visornic, and are open */
-		if (dev->netdev_ops != &visornic_dev_ops ||
+		if (!netdev_ops_equal(dev, &visornic_dev_ops) ||
 		    (!netif_queue_stopped(dev)))
 			continue;
 
diff --git a/net/atm/clip.c b/net/atm/clip.c
index 294cb9efe3d3..b0cb48e7e497 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -554,7 +554,7 @@ static int clip_device_event(struct notifier_block *this, unsigned long event,
 		return NOTIFY_DONE;
 
 	/* ignore non-CLIP devices */
-	if (dev->type != ARPHRD_ATM || dev->netdev_ops != &clip_netdev_ops)
+	if (dev->type != ARPHRD_ATM || !netdev_ops_equal(dev, &clip_netdev_ops))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e147e10b411c..2c57ea6d8e20 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1845,7 +1845,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 
 bool dsa_slave_dev_check(const struct net_device *dev)
 {
-	return dev->netdev_ops == &dsa_slave_netdev_ops;
+	return __netdev_ops_equal(dev, &dsa_slave_netdev_ops);
 }
 
 static int dsa_slave_changeupper(struct net_device *dev,
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 58a7b8312c28..d8aef7444781 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -258,9 +258,9 @@ static struct vport_ops ovs_internal_vport_ops = {
 	.send		= internal_dev_recv,
 };
 
-int ovs_is_internal_dev(const struct net_device *netdev)
+int ovs_is_internal_dev(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &internal_dev_netdev_ops;
+	return netdev_ops_equal(netdev, &internal_dev_netdev_ops);
 }
 
 struct vport *ovs_internal_dev_get_vport(struct net_device *netdev)
diff --git a/net/openvswitch/vport-internal_dev.h b/net/openvswitch/vport-internal_dev.h
index 0112d1b09d4b..f5021d681b74 100644
--- a/net/openvswitch/vport-internal_dev.h
+++ b/net/openvswitch/vport-internal_dev.h
@@ -9,7 +9,7 @@
 #include "datapath.h"
 #include "vport.h"
 
-int ovs_is_internal_dev(const struct net_device *);
+int ovs_is_internal_dev(struct net_device *);
 struct vport *ovs_internal_dev_get_vport(struct net_device *);
 int ovs_internal_dev_rtnl_link_register(void);
 void ovs_internal_dev_rtnl_link_unregister(void);
-- 
2.25.1

