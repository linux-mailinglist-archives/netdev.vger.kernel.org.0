Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65915F1A20
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJAGCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJAGCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B54182771
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s30so4753396eds.1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=j//RMtmjuhFCSNar8/1S7tqsXks+im+YIHkmlHq1CCc=;
        b=b5+yYao9UzlAHzkszPCxOlPVR/rhsp68/AIbi55JiyCaP0p41GOZRV+McLtrfvaG/u
         StLxu/BIQFPAjhJ8JvV2yZg0PzJSRAI1OlpuLNaFNxWthv7cBWplTDrF3/C7oK2jmG9+
         7gyhSDPL8CQxKC4AYp6P0g8fGVptJSIt2iuXp9EzVTCuINXBmtp5qUYVX6WA84WOpLgx
         cS/uNFslLyZCkmoeMNyFvRuvmuQZxmqKgFQVMJgTasedKpT3jcrMdRiXgilO65jcYnm5
         1ck76gpr8eDoMf1K92KPlfxXN9JXYs4ld+cX/6ipYQPZtJ2KfiktTyYsp/sAPUYlMm4c
         t5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=j//RMtmjuhFCSNar8/1S7tqsXks+im+YIHkmlHq1CCc=;
        b=ZLvxCtZXkZCwjvyByCBFXV7Bfpi5GlJpRAGmDoQz/MUqxxoEQdoFNvp2fG6gAL4NtP
         4XEfOoabtUPKEtZa4s/PgqnUx3wKPjhXOgFIsdzxdBUXM9R74y4VPNRGbnywcZkaJIml
         q7k8PzR1yzQOtMBLAmzAqrpo+1qmBJ6PnsfGK6aGOrwyjNNcA8f0kKxX7wlHouwC5mXF
         oVlC93XU0CdYtgWy8uEOnGnHb4+urXEs+56RBEnS9cNKQ5g1zEtju9xotpkFuNUIkQp+
         ZE5PHtiKZZxlqUO15dFjY7XqO+doAZRfv7vhS+URym5tLPRL4NCnD8a6KOQGQAvsMhft
         katg==
X-Gm-Message-State: ACrzQf1yktpbcTGwCti2i+odwYCcvIXGRS9wIDme58g/Dj9TIqBmKMdO
        DcCX/3/RzK6u/s2PP44fRTXnHvs5EssF5oKZ
X-Google-Smtp-Source: AMsMyM44u917jk2NvK8omN9i/xyyBCtIlGiMNKdhjJlT8niNdK0qVh9a8HKGlR1cXezoHJPvpC+AAA==
X-Received: by 2002:a05:6402:2201:b0:44f:443e:2a78 with SMTP id cq1-20020a056402220100b0044f443e2a78mr10257329edb.76.1664604127827;
        Fri, 30 Sep 2022 23:02:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s25-20020a05640217d900b0044ee91129f9sm2922128edy.70.2022.09.30.23.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:02:07 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 12/13] net: remove unused ndo_get_devlink_port
Date:   Sat,  1 Oct 2022 08:01:44 +0200
Message-Id: <20221001060145.3199964-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Remove ndo_get_devlink_port which is no longer used alongside with the
implementations in drivers.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  8 --------
 .../net/ethernet/fungible/funeth/funeth_main.c    |  8 --------
 drivers/net/ethernet/intel/ice/ice_main.c         | 15 ---------------
 drivers/net/ethernet/intel/ice/ice_repr.c         |  9 ---------
 .../ethernet/marvell/prestera/prestera_devlink.c  |  7 -------
 .../ethernet/marvell/prestera/prestera_devlink.h  |  2 --
 .../net/ethernet/marvell/prestera/prestera_main.c |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c  | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 10 ----------
 drivers/net/ethernet/mellanox/mlxsw/minimal.c     | 11 -----------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c    | 11 -----------
 drivers/net/ethernet/mscc/ocelot_net.c            | 10 ----------
 drivers/net/ethernet/netronome/nfp/nfp_app.h      |  2 --
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c  | 11 -----------
 .../net/ethernet/netronome/nfp/nfp_net_common.c   |  2 --
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c |  1 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c          |  8 --------
 drivers/net/netdevsim/netdev.c                    |  9 ---------
 include/linux/netdevice.h                         |  5 -----
 net/dsa/slave.c                                   |  8 --------
 22 files changed, 150 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 59d211fb01ba..0a00fad5cb83 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13073,13 +13073,6 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 	return 0;
 }
 
-static struct devlink_port *bnxt_get_devlink_port(struct net_device *dev)
-{
-	struct bnxt *bp = netdev_priv(dev);
-
-	return &bp->dl_port;
-}
-
 static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_open		= bnxt_open,
 	.ndo_start_xmit		= bnxt_start_xmit,
@@ -13111,7 +13104,6 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_xdp_xmit		= bnxt_xdp_xmit,
 	.ndo_bridge_getlink	= bnxt_bridge_getlink,
 	.ndo_bridge_setlink	= bnxt_bridge_setlink,
-	.ndo_get_devlink_port	= bnxt_get_devlink_port,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index 208dc89f4972..b4cce30e526a 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1178,13 +1178,6 @@ static int fun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
-static struct devlink_port *fun_get_devlink_port(struct net_device *netdev)
-{
-	struct funeth_priv *fp = netdev_priv(netdev);
-
-	return &fp->dl_port;
-}
-
 static int fun_init_vports(struct fun_ethdev *ed, unsigned int n)
 {
 	if (ed->num_vports)
@@ -1350,7 +1343,6 @@ static const struct net_device_ops fun_netdev_ops = {
 	.ndo_set_vf_vlan	= fun_set_vf_vlan,
 	.ndo_set_vf_rate	= fun_set_vf_rate,
 	.ndo_get_vf_config	= fun_get_vf_config,
-	.ndo_get_devlink_port	= fun_get_devlink_port,
 };
 
 #define GSO_ENCAP_FLAGS (NETIF_F_GSO_GRE | NETIF_F_GSO_IPXIP4 | \
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a4d5a6969f10..8f1aaf06c334 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -298,20 +298,6 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	return status;
 }
 
-/**
- * ice_get_devlink_port - Get devlink port from netdev
- * @netdev: the netdevice structure
- */
-static struct devlink_port *ice_get_devlink_port(struct net_device *netdev)
-{
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-
-	if (!ice_is_switchdev_running(pf))
-		return NULL;
-
-	return &pf->devlink_port;
-}
-
 /**
  * ice_vsi_sync_fltr - Update the VSI filter list to the HW
  * @vsi: ptr to the VSI
@@ -9107,5 +9093,4 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
-	.ndo_get_devlink_port = ice_get_devlink_port,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 663a7a0e1814..0483eb14c288 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -134,14 +134,6 @@ static int ice_repr_stop(struct net_device *netdev)
 	return 0;
 }
 
-static struct devlink_port *
-ice_repr_get_devlink_port(struct net_device *netdev)
-{
-	struct ice_repr *repr = ice_netdev_to_repr(netdev);
-
-	return &repr->vf->devlink_port;
-}
-
 /**
  * ice_repr_sp_stats64 - get slow path stats for port representor
  * @dev: network interface device structure
@@ -250,7 +242,6 @@ static const struct net_device_ops ice_repr_netdev_ops = {
 	.ndo_open = ice_repr_open,
 	.ndo_stop = ice_repr_stop,
 	.ndo_start_xmit = ice_eswitch_port_start_xmit,
-	.ndo_get_devlink_port = ice_repr_get_devlink_port,
 	.ndo_setup_tc = ice_repr_setup_tc,
 	.ndo_has_offload_stats = ice_repr_ndo_has_offload_stats,
 	.ndo_get_offload_stats = ice_repr_ndo_get_offload_stats,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 637b8fee65e7..84ad05c9f12d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -445,13 +445,6 @@ void prestera_devlink_port_unregister(struct prestera_port *port)
 	devlink_port_unregister(&port->dl_port);
 }
 
-struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
-{
-	struct prestera_port *port = netdev_priv(dev);
-
-	return &port->dl_port;
-}
-
 int prestera_devlink_traps_register(struct prestera_switch *sw)
 {
 	const u32 groups_count = ARRAY_SIZE(prestera_trap_groups_arr);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
index 04e8556f748a..bf84ad6fd87e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -15,8 +15,6 @@ void prestera_devlink_unregister(struct prestera_switch *sw);
 int prestera_devlink_port_register(struct prestera_port *port);
 void prestera_devlink_port_unregister(struct prestera_port *port);
 
-struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
-
 void prestera_devlink_trap_report(struct prestera_port *port,
 				  struct sk_buff *skb, u8 cpu_code);
 int prestera_devlink_traps_register(struct prestera_switch *sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 18fefb27a356..626f46a6f227 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -558,7 +558,6 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
-	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
 int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index ce0e56f856d6..83adaabf59f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -62,13 +62,3 @@ void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
 		devl_unlock(devlink);
 }
-
-struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (!netif_device_present(dev))
-		return NULL;
-
-	return mlx5e_devlink_get_dl_port(priv);
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index 1c203257ac30..4f238d4fff55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -9,7 +9,6 @@
 
 int mlx5e_devlink_port_register(struct mlx5e_priv *priv);
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
-struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev);
 
 static inline struct devlink_port *
 mlx5e_devlink_get_dl_port(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 05e7fcba15a7..478e6fceb016 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4801,7 +4801,6 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_has_offload_stats   = mlx5e_has_offload_stats,
 	.ndo_get_offload_stats   = mlx5e_get_offload_stats,
 #endif
-	.ndo_get_devlink_port    = mlx5e_get_devlink_port,
 };
 
 static u32 mlx5e_choose_lro_timeout(struct mlx5_core_dev *mdev, u32 wanted_timeout)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index d99382f6a43e..808705fe5ba4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -607,15 +607,6 @@ static int mlx5e_rep_change_mtu(struct net_device *netdev, int new_mtu)
 	return mlx5e_change_mtu(netdev, new_mtu, NULL);
 }
 
-static struct devlink_port *mlx5e_rep_get_devlink_port(struct net_device *netdev)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5_core_dev *dev = priv->mdev;
-
-	return mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
-}
-
 static int mlx5e_rep_change_carrier(struct net_device *dev, bool new_carrier)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -644,7 +635,6 @@ static const struct net_device_ops mlx5e_netdev_ops_rep = {
 	.ndo_stop                = mlx5e_rep_close,
 	.ndo_start_xmit          = mlx5e_xmit,
 	.ndo_setup_tc            = mlx5e_rep_setup_tc,
-	.ndo_get_devlink_port    = mlx5e_rep_get_devlink_port,
 	.ndo_get_stats64         = mlx5e_rep_get_stats,
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index d3e2c88ba677..f6fd1a998ff2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -81,20 +81,9 @@ static int mlxsw_m_port_stop(struct net_device *dev)
 	return 0;
 }
 
-static struct devlink_port *
-mlxsw_m_port_get_devlink_port(struct net_device *dev)
-{
-	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
-	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
-
-	return mlxsw_core_port_devlink_port_get(mlxsw_m->core,
-						mlxsw_m_port->local_port);
-}
-
 static const struct net_device_ops mlxsw_m_port_netdev_ops = {
 	.ndo_open		= mlxsw_m_port_open,
 	.ndo_stop		= mlxsw_m_port_stop,
-	.ndo_get_devlink_port	= mlxsw_m_port_get_devlink_port,
 };
 
 static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 01bb3238c558..85a6fba14e02 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1259,16 +1259,6 @@ static int mlxsw_sp_set_features(struct net_device *dev,
 	return 0;
 }
 
-static struct devlink_port *
-mlxsw_sp_port_get_devlink_port(struct net_device *dev)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-
-	return mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
-						mlxsw_sp_port->local_port);
-}
-
 static int mlxsw_sp_port_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				      struct ifreq *ifr)
 {
@@ -1342,7 +1332,6 @@ static const struct net_device_ops mlxsw_sp_port_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= mlxsw_sp_port_add_vid,
 	.ndo_vlan_rx_kill_vid	= mlxsw_sp_port_kill_vid,
 	.ndo_set_features	= mlxsw_sp_set_features,
-	.ndo_get_devlink_port	= mlxsw_sp_port_get_devlink_port,
 	.ndo_eth_ioctl		= mlxsw_sp_port_ioctl,
 };
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 5efc07751c8d..f50dada2bb8e 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -194,15 +194,6 @@ void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
 	devlink_port_unregister(dlp);
 }
 
-static struct devlink_port *ocelot_get_devlink_port(struct net_device *dev)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->port.index;
-
-	return &ocelot->devlink_ports[port];
-}
-
 int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 			       struct flow_cls_offload *f,
 			       bool ingress)
@@ -925,7 +916,6 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_set_features		= ocelot_set_features,
 	.ndo_setup_tc			= ocelot_setup_tc,
 	.ndo_eth_ioctl			= ocelot_ioctl,
-	.ndo_get_devlink_port		= ocelot_get_devlink_port,
 };
 
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_app.h b/drivers/net/ethernet/netronome/nfp/nfp_app.h
index dd56207df246..90707346a4ef 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_app.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_app.h
@@ -445,6 +445,4 @@ int nfp_app_nic_vnic_alloc(struct nfp_app *app, struct nfp_net *nn,
 int nfp_app_nic_vnic_init_phy_port(struct nfp_pf *pf, struct nfp_app *app,
 				   struct nfp_net *nn, unsigned int id);
 
-struct devlink_port *nfp_devlink_get_devlink_port(struct net_device *netdev);
-
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index f3f0f11d8b52..8bfd48d50ef0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -362,14 +362,3 @@ void nfp_devlink_port_unregister(struct nfp_port *port)
 {
 	devl_port_unregister(&port->dl_port);
 }
-
-struct devlink_port *nfp_devlink_get_devlink_port(struct net_device *netdev)
-{
-	struct nfp_port *port;
-
-	port = nfp_port_from_netdev(netdev);
-	if (!port)
-		return NULL;
-
-	return &port->dl_port;
-}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 27f4786ace4f..8b9a909b0e97 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2013,7 +2013,6 @@ const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
 	.ndo_bpf		= nfp_net_xdp,
 	.ndo_xsk_wakeup		= nfp_net_xsk_wakeup,
-	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 	.ndo_bridge_getlink     = nfp_net_bridge_getlink,
 	.ndo_bridge_setlink     = nfp_net_bridge_setlink,
 };
@@ -2044,7 +2043,6 @@ const struct net_device_ops nfp_nfdk_netdev_ops = {
 	.ndo_features_check	= nfp_net_features_check,
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
 	.ndo_bpf		= nfp_net_xdp,
-	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 	.ndo_bridge_getlink     = nfp_net_bridge_getlink,
 	.ndo_bridge_setlink     = nfp_net_bridge_setlink,
 };
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 8b77582bdfa0..4706c15fdb54 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -275,7 +275,6 @@ const struct net_device_ops nfp_repr_netdev_ops = {
 	.ndo_set_features	= nfp_port_set_features,
 	.ndo_set_mac_address    = eth_mac_addr,
 	.ndo_get_port_parent_id	= nfp_port_get_port_parent_id,
-	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 };
 
 void
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 43d1fba22d41..38bfc3c2b334 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1380,13 +1380,6 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
-static struct devlink_port *am65_cpsw_ndo_get_devlink_port(struct net_device *ndev)
-{
-	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
-
-	return &port->devlink_port;
-}
-
 static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
@@ -1400,7 +1393,6 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
 	.ndo_eth_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
-	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
 };
 
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 4eb90cc49e22..9e46200bb688 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -238,13 +238,6 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
 	return 0;
 }
 
-static struct devlink_port *nsim_get_devlink_port(struct net_device *dev)
-{
-	struct netdevsim *ns = netdev_priv(dev);
-
-	return &ns->nsim_dev_port->devlink_port;
-}
-
 static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_start_xmit		= nsim_start_xmit,
 	.ndo_set_rx_mode	= nsim_set_rx_mode,
@@ -263,7 +256,6 @@ static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_setup_tc		= nsim_setup_tc,
 	.ndo_set_features	= nsim_set_features,
 	.ndo_bpf		= nsim_bpf,
-	.ndo_get_devlink_port	= nsim_get_devlink_port,
 };
 
 static const struct net_device_ops nsim_vf_netdev_ops = {
@@ -275,7 +267,6 @@ static const struct net_device_ops nsim_vf_netdev_ops = {
 	.ndo_get_stats64	= nsim_get_stats64,
 	.ndo_setup_tc		= nsim_setup_tc,
 	.ndo_set_features	= nsim_set_features,
-	.ndo_get_devlink_port	= nsim_get_devlink_port,
 };
 
 static void nsim_setup(struct net_device *dev)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 73ae13dd3657..ee383e91dfd5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1366,10 +1366,6 @@ struct netdev_net_notifier {
  *	queue id bound to an AF_XDP socket. The flags field specifies if
  *	only RX, only Tx, or both should be woken up using the flags
  *	XDP_WAKEUP_RX and XDP_WAKEUP_TX.
- * struct devlink_port *(*ndo_get_devlink_port)(struct net_device *dev);
- *	Get devlink port instance associated with a given netdev.
- *	Called with a reference on the netdevice and devlink locks only,
- *	rtnl_lock is not held.
  * int (*ndo_tunnel_ctl)(struct net_device *dev, struct ip_tunnel_parm *p,
  *			 int cmd);
  *	Add, change, delete or get information on an IPv4 tunnel.
@@ -1600,7 +1596,6 @@ struct net_device_ops {
 							  struct xdp_buff *xdp);
 	int			(*ndo_xsk_wakeup)(struct net_device *dev,
 						  u32 queue_id, u32 flags);
-	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
 	int			(*ndo_tunnel_ctl)(struct net_device *dev,
 						  struct ip_tunnel_parm *p, int cmd);
 	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a72f6e3c9ed6..651937d69c8e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2165,13 +2165,6 @@ static const struct dcbnl_rtnl_ops __maybe_unused dsa_slave_dcbnl_ops = {
 	.ieee_delapp		= dsa_slave_dcbnl_ieee_delapp,
 };
 
-static struct devlink_port *dsa_slave_get_devlink_port(struct net_device *dev)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-
-	return &dp->devlink_port;
-}
-
 static void dsa_slave_get_stats64(struct net_device *dev,
 				  struct rtnl_link_stats64 *s)
 {
@@ -2219,7 +2212,6 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_get_stats64	= dsa_slave_get_stats64,
 	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
-	.ndo_get_devlink_port	= dsa_slave_get_devlink_port,
 	.ndo_change_mtu		= dsa_slave_change_mtu,
 	.ndo_fill_forward_path	= dsa_slave_fill_forward_path,
 };
-- 
2.37.1

