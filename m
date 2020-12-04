Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538AA2CEC37
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgLDKao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgLDKan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:30:43 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12758C061A51;
        Fri,  4 Dec 2020 02:30:03 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s27so6974217lfp.5;
        Fri, 04 Dec 2020 02:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aFRlI4fXaEVeSmIkxNMWXJSVPFP7SIfGNqf3YjlK88=;
        b=odb/3GuHRfPSJGUYct9gfeG6YBCEcxqSDfKh1Eicm7rho/UZGfsh4QeqB+EJfguW6Y
         R+3QVPTYwayKVu0so9T336C9PBBDl+PWdIj3Prfh5LGUZqcFe+JVE25sX0ZSAz/3lbSr
         C+r8NXCUO4yLk5D27hWmHZgjpnxIEb1L/W/rvwll9TqsnAT+ZK9BT40493trBRG5nJBx
         7a0zQHFaPWASFMX6xQALTWAP1A2QYdUd46xpekTFITs4httbaHgX9W7Y9vdfSq8HGE9B
         di7GYRkYESSo14K1WMecU+Icniv8NPoP8TvpWTxD2yVUEJ8r/CbTT/Yxx2w6svjuME9l
         KmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aFRlI4fXaEVeSmIkxNMWXJSVPFP7SIfGNqf3YjlK88=;
        b=R2voED/+CtYgqPJXK5HYCrHEKe3iuIVClCJ55ipENbIeu9efbZoaTWtJ8UCufKRk4E
         ctOoC7OG6L89bS1tUbKfRP1G1mW1cMpJf2YR8t0p/SwT03J4sxmkvExKrKU50w2eWxj0
         ty+mb1MYOEpwnjRiyRvdnre4dEvdZ2rhadq2o99sowXrA3/dnlXfq2npB4/AlRuzG3/W
         e4/B1hULgJf4+jyczWnukVX/Zfzgn1Vl5t9ygPNGRe8BtxCzBw04x7sqzvHbDPy4Yg92
         7Pp+s1QQWyW2ovH01IZcBQbc+WTG4dA8fCZeffHxxh/9jhRykQ+pkcvWocHBh8UfcGZv
         NqpA==
X-Gm-Message-State: AOAM533T3vRkL/0fYJ+Sbixew/nEe+i+BAVsawaYZkrVB1RLcBDi7BB6
        6ur//um0CFPXOfJDt+DO/mg=
X-Google-Smtp-Source: ABdhPJyQfEehQIdMVx05bZCQHV2oYzq3h7hwmh3DbMe5tSIo62sTBok+wgnK6kFhQcQfRzXAVOM5Gw==
X-Received: by 2002:a19:5205:: with SMTP id m5mr2902610lfb.310.1607077801535;
        Fri, 04 Dec 2020 02:30:01 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id d9sm62738lfj.228.2020.12.04.02.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 02:30:00 -0800 (PST)
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
Subject: [PATCH v2 bpf 2/5] drivers/net: turn XDP properties on
Date:   Fri,  4 Dec 2020 11:28:58 +0100
Message-Id: <20201204102901.109709-3-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201204102901.109709-1-marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Turn 'hw-offload' property flag on for:
 - netronome.

Turn 'native' and 'zerocopy' properties flags on for:
 - i40e
 - ice
 - ixgbe
 - mlx5.

Turn 'native' properties flags on for:
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

Turn 'basic' (tx, pass, aborted and drop) properties flags on for:
 - netronome
 - ena
 - mlx4.

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c        | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           | 1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c         | 3 +++
 drivers/net/ethernet/intel/ice/ice_main.c           | 4 ++++
 drivers/net/ethernet/intel/igb/igb_main.c           | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 3 +++
 drivers/net/ethernet/marvell/mvneta.c               | 3 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 3 +++
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c      | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 3 +++
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 5 +++++
 drivers/net/ethernet/qlogic/qede/qede_main.c        | 2 ++
 drivers/net/ethernet/sfc/efx.c                      | 2 ++
 drivers/net/ethernet/socionext/netsec.c             | 2 ++
 drivers/net/ethernet/ti/cpsw.c                      | 3 +++
 drivers/net/ethernet/ti/cpsw_new.c                  | 2 ++
 drivers/net/tun.c                                   | 4 ++++
 drivers/net/veth.c                                  | 2 ++
 drivers/net/virtio_net.c                            | 2 ++
 drivers/net/xen-netfront.c                          | 2 ++
 21 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6ad59f0068f6..a0a7558d733b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4290,6 +4290,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
+	xdp_set_basic_properties(&netdev->xdp_properties);
+
 	u64_stats_init(&adapter->syncp);
 
 	rc = ena_enable_msix_and_set_admin_interrupts(adapter);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 725d929eddb1..5a153102d73b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12604,6 +12604,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->features |= dev->hw_features | NETIF_F_HIGHDMA;
 	if (dev->features & NETIF_F_GRO_HW)
 		dev->features &= ~NETIF_F_LRO;
+	xdp_set_full_properties(&dev->xdp_properties);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 40953980e846..abdd4ceed6f2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4014,6 +4014,7 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 			    NETIF_F_SG | NETIF_F_HIGHDMA |
 			    NETIF_F_LLTX | NETIF_F_HW_TC;
 	net_dev->hw_features = net_dev->features;
+	xdp_set_full_properties(&net_dev->xdp_properties);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4f8a2154b93f..6e5dae9b871f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12875,6 +12875,9 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
+	xdp_set_full_properties(&netdev->xdp_properties);
+	xsk_set_zc_property(&netdev->xdp_properties);
+
 	if (vsi->type == I40E_VSI_MAIN) {
 		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
 		ether_addr_copy(mac_addr, hw->mac.perm_addr);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2dea4d0e9415..638942df136b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -13,6 +13,7 @@
 #include "ice_dcb_lib.h"
 #include "ice_dcb_nl.h"
 #include "ice_devlink.h"
+#include <net/xdp_sock_drv.h>
 
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
 static const char ice_driver_string[] = DRV_SUMMARY;
@@ -2979,6 +2980,9 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 
 	ice_set_netdev_features(netdev);
 
+	xdp_set_full_properties(&netdev->xdp_properties);
+	xsk_set_zc_properties(&netdev->xdp_properties);
+
 	ice_set_ops(netdev);
 
 	if (vsi->type == ICE_VSI_PF) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 6a4ef4934fcf..ed7e0a2efe1a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3297,6 +3297,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
+	xdp_set_full_properties(&netdev->xdp_properties);
+
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = MAX_STD_JUMBO_FRAME_SIZE;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 50e6b8b6ba7b..6fa98bf48e21 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10844,6 +10844,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
+	xdp_set_full_properties(&netdev->xdp_properties);
+	xsk_set_zc_property(&netdev->xdp_properties);
+
 	/* MTU range: 68 - 9710 */
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = IXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ba6dcb19bb1d..6431772b4706 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5262,6 +5262,9 @@ static int mvneta_probe(struct platform_device *pdev)
 			NETIF_F_TSO | NETIF_F_RXCSUM;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
+
+	xdp_set_full_properties(&dev->xdp_properties);
+
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->gso_max_segs = MVNETA_MAX_TSO_SEGS;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 5504cbc24970..4d6a86b40403 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6475,6 +6475,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
 	dev->vlan_features |= features;
+
+	xdp_set_full_properties(&dev->xdp_properties);
+
 	dev->gso_max_segs = MVPP2_MAX_TSO_SEGS;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 106513f772c3..3b81c98b85a0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3395,6 +3395,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		priv->rss_hash_fn = ETH_RSS_HASH_TOP;
 	}
 
+	xdp_set_basic_properties(&dev->xdp_properties);
+
 	/* MTU range: 68 - hw-specific max */
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 427fc376fe1a..0f6055528a32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4981,6 +4981,9 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->features         |= NETIF_F_HIGHDMA;
 	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
 
+	xdp_set_full_properties(&netdev->xdp_properties);
+	xsk_set_zc_property(&netdev->xdp_properties);
+
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
 	mlx5e_set_netdev_dev_addr(netdev);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b4acf2f41e84..37280465326c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -4099,8 +4099,13 @@ int nfp_net_init(struct nfp_net *nn)
 		return err;
 
 	if (nn->dp.netdev) {
+		struct net_device *dev = nn->dp.netdev;
+
 		nfp_net_netdev_init(nn);
 
+		xdp_set_hw_offload_property(&dev->xdp_properties);
+		xdp_set_basic_properties(&dev->xdp_properties);
+
 		err = nfp_ccm_mbox_init(nn);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 9cf960a6d007..fc11fae05857 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -842,6 +842,8 @@ static void qede_init_ndev(struct qede_dev *edev)
 
 	ndev->hw_features = hw_features;
 
+	xdp_set_full_properties(&ndev->xdp_properties);
+
 	/* MTU range: 46 - 9600 */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
 	ndev->max_mtu = QEDE_MAX_JUMBO_PACKET_SIZE;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 718308076341..bbf6d3255040 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1111,6 +1111,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	netif_info(efx, probe, efx->net_dev,
 		   "Solarflare NIC detected\n");
 
+	xdp_set_full_properties(&efx->net_dev->xdp_properties);
+
 	if (!efx->type->is_vf)
 		efx_probe_vpd_strings(efx);
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 27d3c9d9210e..df1f952f678a 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2100,6 +2100,8 @@ static int netsec_probe(struct platform_device *pdev)
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	ndev->hw_features = ndev->features;
 
+	xdp_set_full_properties(&ndev->xdp_properties);
+
 	priv->rx_cksum_offload_flag = true;
 
 	ret = netsec_register_mdio(priv, phy_addr);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9fd1f77190ad..02fd7275e477 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1476,6 +1476,8 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 	cpsw->slaves[1].ndev = ndev;
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
 
+	xdp_set_full_properties(&ndev->xdp_properties);
+
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
 
@@ -1654,6 +1656,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	cpsw->slaves[0].ndev = ndev;
 
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	xdp_set_full_properties(&ndev->xdp_properties);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index f779d2e1b5c5..22bf1b0d4d48 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1416,6 +1416,8 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
 				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL;
 
+		xdp_set_full_properties(&ndev->xdp_properties);
+
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8867d39db6ac..6d16e878b1bd 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2721,6 +2721,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 				     ~(NETIF_F_HW_VLAN_CTAG_TX |
 				       NETIF_F_HW_VLAN_STAG_TX);
 
+		/* Currently tap does not support XDP, only tun does. */
+		if (tun->flags == IFF_TUN)
+			xdp_set_full_properties(&dev->xdp_properties);
+
 		tun->flags = (tun->flags & ~TUN_FEATURES) |
 			      (ifr->ifr_flags & TUN_FEATURES);
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 9bd37c7151f8..5a48823a0377 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1270,6 +1270,8 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_features = VETH_FEATURES;
 	dev->hw_enc_features = VETH_FEATURES;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+
+	xdp_set_full_properties(&dev->xdp_properties);
 }
 
 /*
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 052975ea0af4..f05a45942d37 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3018,6 +3018,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 	dev->vlan_features = dev->features;
 
+	xdp_set_full_properties(&dev->xdp_properties);
+
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = MIN_MTU;
 	dev->max_mtu = MAX_MTU;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b01848ef4649..e2c3c668abae 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1556,6 +1556,8 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
          */
 	netdev->features |= netdev->hw_features;
 
+	xdp_set_full_properties(&netdev->xdp_properties);
+
 	netdev->ethtool_ops = &xennet_ethtool_ops;
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = XEN_NETIF_MAX_TX_SIZE;
-- 
2.27.0

