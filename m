Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334A72B3FE7
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgKPJfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgKPJfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:16 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A386C0613CF;
        Mon, 16 Nov 2020 01:35:16 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 74so24195985lfo.5;
        Mon, 16 Nov 2020 01:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DRogxLAWeILeQ6O5RXo7aniYeaKUoqbSS7azBUAy5Kw=;
        b=WlEbLFYdpEyjkHcsw64/Ldawgo53paFUAqNMf76aMfyLQzOm1q6hBp1Wx/Qw6UGvyy
         U6Mlfa0SXIZBGPX88KZHQxhWv8pz+DCJxINMnz/nBk2RsnzA5/Y7cGXqUk0G6Abp3XuO
         6n1oQLC85mIbPWdXc4e/6/6FWZxPiL90YX07i1QWcgUFqOx7RvbXSJd4/LRX/0OJvAFs
         NuTDcYrMl0mIWdvpEpG9NiFf/GbVSDbxLTfzZNOe35Gb1z0GdIBO82kvgTAUg7cadFqX
         K/kF/OcH7+1VDnoSG5z4bL5+FZ0Gk1ymdYj7/4vGDdps8/ObgNI08jJ4reLErhA8wlf9
         UjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DRogxLAWeILeQ6O5RXo7aniYeaKUoqbSS7azBUAy5Kw=;
        b=RBfWoft8C3ICyOJudMYETZDViqT3Deiia7JsEgQGBO46h5YW7j4l2dlHlS/K3ToOWF
         b4blDtONvMm96t5Zfd9rFPj0/ZXlrFlyrDPyQr8wK6h3WAyPpmGAz1AMELyaUZV0FS4i
         8WtAOwQIlioH9Pw1XVtQVqL2EQCxAys+oBZM8h5hfTfQZTh3F7QLILeqqfaVNg5nhpvm
         nU/ES4BaplK4feSgO7AQPXihabalbRyEue8YZIVg+kPrP+ta+IrklWzTn58XBTmLoukS
         ih3R3uVeBS/bKoXv3tpdzaEa8vjPCOuMjxfoMyKsCLYS2vHW2pTtIvll341b/5YGNP0n
         dEHQ==
X-Gm-Message-State: AOAM530v/KWF0wV25/4695PP8v2i7tIzGDAlrAj7tL/Tak8N//F8CUbz
        xDNMPknP0Cxo9NOJB7HsmSo=
X-Google-Smtp-Source: ABdhPJwZSitmq4q2+XMdKps3x1Y/CBuSJ5fG9gJYLmD19asV8v9AL897u2KYDgbUKBIpY8c3dmg/iA==
X-Received: by 2002:a05:6512:74e:: with SMTP id c14mr5468117lfs.463.1605519314602;
        Mon, 16 Nov 2020 01:35:14 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:13 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH 2/8] drivers/net: turn XDP flags on
Date:   Mon, 16 Nov 2020 10:34:46 +0100
Message-Id: <20201116093452.7541-3-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116093452.7541-1-marekx.majtyka@intel.com>
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Turn 'xdp' and 'af-xdp-zc' feature flags on for:
 - i40e
 - ice
 - ixgbe
 - mlx5.

Turn 'xdp' feature flag on for:
 - igb
 - tun
 - veth
 - dpaa2
 - mvneta
 - mvpp2
 - qede
 - sfc
 - netsec
 - cpsw
 - xen
 - virtio_net.

The first group of NICs is currently visible with ethtool as:
  $ ethtool -k enp1s0f0
    Features for enp1s0f0:
    ..
    xdp: on [fixed]
    af-xdp-zc: on [fixed]

whereas for the second group output is as:
  $ ethtool -k enp1s0f0
    Features for enp1s0f0:
    ..
    xdp: on [fixed]
    af-xdp-zc: off [fixed]

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c       | 2 ++
 drivers/net/ethernet/intel/ice/ice_main.c         | 4 ++++
 drivers/net/ethernet/intel/igb/igb_main.c         | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 3 +++
 drivers/net/ethernet/marvell/mvneta.c             | 1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c      | 1 +
 drivers/net/ethernet/sfc/efx.c                    | 1 +
 drivers/net/ethernet/socionext/netsec.c           | 1 +
 drivers/net/ethernet/ti/cpsw.c                    | 2 ++
 drivers/net/ethernet/ti/cpsw_new.c                | 2 ++
 drivers/net/tun.c                                 | 4 ++++
 drivers/net/veth.c                                | 1 +
 drivers/net/virtio_net.c                          | 1 +
 drivers/net/xen-netfront.c                        | 1 +
 18 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7975f59735d6..9f689717319d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12604,6 +12604,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->features |= dev->hw_features | NETIF_F_HIGHDMA;
 	if (dev->features & NETIF_F_GRO_HW)
 		dev->features &= ~NETIF_F_LRO;
+	xdp_set_feature_flag(&dev->features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cf9400a9886d..418ec3dae1dd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4014,6 +4014,7 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 			    NETIF_F_SG | NETIF_F_HIGHDMA |
 			    NETIF_F_LLTX | NETIF_F_HW_TC;
 	net_dev->hw_features = net_dev->features;
+	xdp_set_feature_flag(&net_dev->features);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4f8a2154b93f..0b7825f629c6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12873,6 +12873,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->hw_features |= hw_features;
 
 	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	xdp_set_feature_flag(&netdev->features);
+	xsk_set_feature_flag(&netdev->features);
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
 	if (vsi->type == I40E_VSI_MAIN) {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2dea4d0e9415..7b932ba42f09 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -13,6 +13,7 @@
 #include "ice_dcb_lib.h"
 #include "ice_dcb_nl.h"
 #include "ice_devlink.h"
+#include <net/xdp_sock_drv.h>
 
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
 static const char ice_driver_string[] = DRV_SUMMARY;
@@ -2941,6 +2942,9 @@ static void ice_set_netdev_features(struct net_device *netdev)
 
 	/* enable features */
 	netdev->features |= netdev->hw_features;
+	xdp_set_feature_flag(&netdev->features);
+	xsk_set_feature_flag(&netdev->features);
+
 	/* encap and VLAN devices inherit default, csumo and tso features */
 	netdev->hw_enc_features |= dflt_features | csumo_features |
 				   tso_features;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5fc2c381da55..e89a0442606f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3293,6 +3293,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_HW_VLAN_CTAG_RX |
 			    NETIF_F_HW_VLAN_CTAG_TX;
 
+	xdp_set_feature_flag(&netdev->features);
+
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45ae33e15303..fccc282a9492 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10880,6 +10880,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
 		netdev->features |= NETIF_F_LRO;
 
+	xdp_set_feature_flag(&netdev->features);
+	xsk_set_feature_flag(&netdev->features);
+
 	if (ixgbe_check_fw_error(adapter)) {
 		err = -EIO;
 		goto err_sw_init;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 183530ed4d1d..b80c1eca820e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5262,6 +5262,7 @@ static int mvneta_probe(struct platform_device *pdev)
 			NETIF_F_TSO | NETIF_F_RXCSUM;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
+	xdp_set_feature_flag(&dev->features);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->gso_max_segs = MVNETA_MAX_TSO_SEGS;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3069e192d773..6add63ef9ac0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6475,6 +6475,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
 	dev->vlan_features |= features;
+	xdp_set_feature_flag(&dev->features);
 	dev->gso_max_segs = MVPP2_MAX_TSO_SEGS;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 527c5f12c5af..67aaec330816 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4980,6 +4980,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->features         |= NETIF_F_HIGHDMA;
 	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
+	xdp_set_feature_flag(&netdev->features);
+	xsk_set_feature_flag(&netdev->features);
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 05e3a3b60269..add1b820adea 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -839,6 +839,7 @@ static void qede_init_ndev(struct qede_dev *edev)
 	ndev->features = hw_features | NETIF_F_RXHASH | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA |
 			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX;
+	xdp_set_feature_flag(&ndev->features);
 
 	ndev->hw_features = hw_features;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 718308076341..ca5a582ce26b 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1101,6 +1101,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct efx_nic_type *) entry->driver_data;
 	efx->fixed_features |= NETIF_F_HIGHDMA;
+	xdp_set_feature_flag(&efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 1503cc9ec6e2..8a8cca53821d 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2099,6 +2099,7 @@ static int netsec_probe(struct platform_device *pdev)
 	ndev->features |= NETIF_F_HIGHDMA | NETIF_F_RXCSUM | NETIF_F_GSO |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	ndev->hw_features = ndev->features;
+	xdp_set_feature_flag(&ndev->features);
 
 	priv->rx_cksum_offload_flag = true;
 
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9fd1f77190ad..ca5548f92b56 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1475,6 +1475,7 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 	priv_sl2->emac_port = 1;
 	cpsw->slaves[1].ndev = ndev;
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	xdp_set_feature_flag(&ndev->features);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
@@ -1654,6 +1655,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	cpsw->slaves[0].ndev = ndev;
 
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	xdp_set_feature_flag(&ndev->features);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index f779d2e1b5c5..9a8fb3dd8a19 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1416,6 +1416,8 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
 				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL;
 
+		xdp_set_feature_flag(&ndev->features);
+
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3d45d56172cb..2187714598d6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2721,6 +2721,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 				     ~(NETIF_F_HW_VLAN_CTAG_TX |
 				       NETIF_F_HW_VLAN_STAG_TX);
 
+		/* Currently tap does not support XDP, only tun does. */
+		if (tun->flags == IFF_TUN)
+			xdp_set_feature_flag(&dev->features);
+
 		tun->flags = (tun->flags & ~TUN_FEATURES) |
 			      (ifr->ifr_flags & TUN_FEATURES);
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8c737668008a..26f2e83d9a2c 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1266,6 +1266,7 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_features = VETH_FEATURES;
 	dev->hw_enc_features = VETH_FEATURES;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+	xdp_set_feature_flag(&dev->features);
 }
 
 /*
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..ee33e9fce4c5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3017,6 +3017,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		dev->hw_features |= NETIF_F_LRO;
 
 	dev->vlan_features = dev->features;
+	xdp_set_feature_flag(&dev->features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = MIN_MTU;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 920cac4385bf..abe5f0104c73 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1555,6 +1555,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
          * negotiate with the backend regarding supported features.
          */
 	netdev->features |= netdev->hw_features;
+	xdp_set_feature_flag(&netdev->features);
 
 	netdev->ethtool_ops = &xennet_ethtool_ops;
 	netdev->min_mtu = ETH_MIN_MTU;
-- 
2.20.1

