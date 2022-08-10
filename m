Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E5B58E560
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiHJDPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiHJDN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F104E81B28
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zft59qKzXdSK;
        Wed, 10 Aug 2022 11:09:42 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 25/36] treewide: use netdev_features_or/set helpers
Date:   Wed, 10 Aug 2022 11:06:13 +0800
Message-ID: <20220810030624.34711-26-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the '|' expressions of features by netdev_features_or
helpers, and '|=' expressions by netdev_features_set helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  2 +-
 drivers/net/amt.c                             |  4 +--
 drivers/net/bareudp.c                         |  4 +--
 drivers/net/bonding/bond_main.c               | 23 +++++++--------
 drivers/net/bonding/bond_options.c            |  5 ++--
 drivers/net/dummy.c                           |  8 +++---
 drivers/net/ethernet/alacritech/slicoss.c     |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  4 +--
 drivers/net/ethernet/amd/amd8111e.c           |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  2 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  4 +--
 drivers/net/ethernet/atheros/atlx/atl2.c      |  2 +-
 drivers/net/ethernet/broadcom/b44.c           |  3 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  4 +--
 drivers/net/ethernet/broadcom/bnx2.c          |  6 ++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  9 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  3 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  4 +--
 drivers/net/ethernet/broadcom/tg3.c           |  8 +++---
 drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  2 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  2 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  3 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  4 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   | 10 +++----
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/davicom/dm9000.c         |  2 +-
 drivers/net/ethernet/dnet.c                   |  3 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/ethoc.c                  |  3 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  8 +++---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  4 +--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  8 +++---
 drivers/net/ethernet/ibm/emac/core.c          |  2 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  6 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  5 ++--
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  3 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  6 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 15 +++++-----
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 21 +++++++-------
 drivers/net/ethernet/intel/ice/ice_main.c     | 28 ++++++++++---------
 drivers/net/ethernet/intel/igb/igb_main.c     | 12 ++++----
 drivers/net/ethernet/intel/igbvf/netdev.c     |  8 +++---
 drivers/net/ethernet/intel/igc/igc_main.c     |  8 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 12 ++++----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 +++----
 drivers/net/ethernet/marvell/mvneta.c         |  4 +--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 +++++----
 .../ethernet/marvell/octeon_ep/octep_main.c   |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 10 +++----
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  6 ++--
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  4 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  3 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  2 +-
 drivers/net/ethernet/natsemi/ns83820.c        |  2 +-
 drivers/net/ethernet/neterion/s2io.c          |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 +--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  6 ++--
 drivers/net/ethernet/nvidia/forcedeth.c       |  4 +--
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  6 ++--
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  4 +--
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  5 ++--
 drivers/net/ethernet/realtek/r8169_main.c     |  4 +--
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  2 +-
 drivers/net/ethernet/sfc/ef10.c               |  6 ++--
 drivers/net/ethernet/sfc/ef100_netdev.c       |  8 +++---
 drivers/net/ethernet/sfc/ef100_nic.c          |  6 ++--
 drivers/net/ethernet/sfc/efx.c                |  8 +++---
 drivers/net/ethernet/sfc/efx_common.c         |  4 +--
 drivers/net/ethernet/sfc/falcon/efx.c         |  8 +++---
 drivers/net/ethernet/sfc/falcon/net_driver.h  |  2 +-
 drivers/net/ethernet/sfc/net_driver.h         |  2 +-
 drivers/net/ethernet/sfc/siena/efx.c          |  9 +++---
 drivers/net/ethernet/sfc/siena/efx_common.c   |  4 +--
 drivers/net/ethernet/sfc/siena/net_driver.h   |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 +++---
 drivers/net/ethernet/sun/niu.c                |  2 +-
 drivers/net/ethernet/sun/sunhme.c             |  4 +--
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  6 ++--
 drivers/net/ethernet/via/via-rhine.c          |  2 +-
 drivers/net/geneve.c                          |  4 +--
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/ifb.c                             | 11 ++++----
 drivers/net/ipvlan/ipvlan_main.c              | 17 +++++------
 drivers/net/macsec.c                          |  6 ++--
 drivers/net/macvlan.c                         | 17 +++++------
 drivers/net/net_failover.c                    | 11 ++++----
 drivers/net/tap.c                             |  2 +-
 drivers/net/team/team.c                       | 13 +++++----
 drivers/net/tun.c                             |  4 +--
 drivers/net/usb/ax88179_178a.c                |  2 +-
 drivers/net/usb/smsc75xx.c                    |  2 +-
 drivers/net/veth.c                            |  8 ++++--
 drivers/net/virtio_net.c                      |  5 ++--
 drivers/net/vrf.c                             |  2 +-
 drivers/net/vxlan/vxlan_core.c                |  4 +--
 drivers/net/wireguard/device.c                |  6 ++--
 drivers/net/wireless/ath/wil6210/netdev.c     |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +--
 drivers/net/xen-netfront.c                    |  2 +-
 drivers/s390/net/qeth_core_main.c             |  2 +-
 drivers/s390/net/qeth_l3_main.c               |  3 +-
 include/linux/netdev_features_helper.h        |  6 ++--
 include/net/udp.h                             |  2 +-
 net/8021q/vlan.h                              |  4 +--
 net/8021q/vlan_dev.c                          | 11 ++++----
 net/bridge/br_device.c                        |  3 +-
 net/core/dev.c                                | 18 ++++++------
 net/core/sock.c                               |  2 +-
 net/ethtool/ioctl.c                           |  6 ++--
 net/ipv4/ip_gre.c                             |  8 +++---
 net/ipv4/ipip.c                               |  4 +--
 net/ipv6/ip6_gre.c                            |  4 +--
 net/ipv6/ip6_tunnel.c                         |  4 +--
 net/ipv6/sit.c                                |  4 +--
 net/mac80211/iface.c                          |  4 +--
 net/mac80211/main.c                           |  3 +-
 net/openvswitch/vport-internal_dev.c          |  5 ++--
 net/xfrm/xfrm_device.c                        |  5 ++--
 net/xfrm/xfrm_interface.c                     |  4 +--
 137 files changed, 375 insertions(+), 341 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index fe18d7819d3c..e4d20673150c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1861,7 +1861,7 @@ static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 		if (priv->kernel_caps & IBK_UD_TSO)
 			netdev_hw_feature_add(priv->dev, NETIF_F_TSO_BIT);
 
-		priv->dev->features |= priv->dev->hw_features;
+		netdev_active_features_set(priv->dev, priv->dev->hw_features);
 	}
 }
 
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f76013edd417..8a1ac2663260 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3117,9 +3117,9 @@ static void amt_link_setup(struct net_device *dev)
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
 	dev->priv_flags		|= IFF_NO_QUEUE;
-	dev->features		|= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_active_features_set_array(dev, &amt_feature_set);
-	dev->hw_features	|= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_hw_features_set_array(dev, &amt_hw_feature_set);
 	eth_hw_addr_random(dev);
 	eth_zero_addr(dev->broadcast);
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 08b11ed436ad..4c602e2e178f 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -557,9 +557,9 @@ static void bareudp_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &bareudp_type);
 	netdev_active_features_set_array(dev, &bareudp_feature_set);
-	dev->features    |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_hw_features_set_array(dev, &bareudp_hw_feature_set);
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
 	dev->mtu = ETH_DATA_LEN;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index f117f63e2879..06fa1a5fcb36 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1421,7 +1421,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		features |= BOND_TLS_FEATURES;
+		netdev_features_set(&features, BOND_TLS_FEATURES);
 	else
 		features &= ~BOND_TLS_FEATURES;
 #endif
@@ -1429,7 +1429,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	mask = features;
 
 	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
 		features = netdev_increment_features(features,
@@ -1498,10 +1498,11 @@ static void bond_compute_features(struct bonding *bond)
 
 done:
 	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
-	bond_dev->hw_enc_features |= netdev_tx_vlan_features;
+	bond_dev->hw_enc_features = netdev_features_or(enc_features,
+						       NETIF_F_GSO_ENCAP_ALL);
+	netdev_hw_enc_features_set(bond_dev, netdev_tx_vlan_features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	bond_dev->hw_enc_features |= xfrm_features;
+	netdev_hw_enc_features_set(bond_dev, xfrm_features);
 #endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->mpls_features = mpls_features;
 	netif_set_tso_max_segs(bond_dev, tso_max_segs);
@@ -5769,18 +5770,18 @@ void bond_setup(struct net_device *bond_dev)
 	netdev_hw_feature_add(bond_dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_hw_feature_add(bond_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
-	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-	bond_dev->features |= bond_dev->hw_features;
-	bond_dev->features |= netdev_tx_vlan_features;
+	netdev_hw_features_set(bond_dev, NETIF_F_GSO_ENCAP_ALL);
+	netdev_active_features_set(bond_dev, bond_dev->hw_features);
+	netdev_active_features_set(bond_dev, netdev_tx_vlan_features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	bond_dev->hw_features |= BOND_XFRM_FEATURES;
+	netdev_hw_features_set(bond_dev, BOND_XFRM_FEATURES);
 	/* Only enable XFRM features if this is an active-backup config */
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
-		bond_dev->features |= BOND_XFRM_FEATURES;
+		netdev_active_features_set(bond_dev, BOND_XFRM_FEATURES);
 #endif /* CONFIG_XFRM_OFFLOAD */
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		bond_dev->features |= BOND_TLS_FEATURES;
+		netdev_active_features_set(bond_dev, BOND_TLS_FEATURES);
 #endif
 }
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 3498db1c1b3c..a90752e8aeef 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/if.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/ctype.h>
@@ -835,7 +836,7 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 		return false;
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
-		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
+		netdev_wanted_features_set(bond->dev, BOND_XFRM_FEATURES);
 	else
 		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
 
@@ -848,7 +849,7 @@ static bool bond_set_tls_features(struct bonding *bond)
 		return false;
 
 	if (bond_sk_check(bond))
-		bond->dev->wanted_features |= BOND_TLS_FEATURES;
+		netdev_wanted_features_set(bond->dev, BOND_TLS_FEATURES);
 	else
 		bond->dev->wanted_features &= ~BOND_TLS_FEATURES;
 
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index 6f176774efbd..ab196591a0bf 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -132,10 +132,10 @@ static void dummy_setup(struct net_device *dev)
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
 	netdev_active_features_set_array(dev, &dummy_feature_set);
-	dev->features	|= NETIF_F_GSO_SOFTWARE;
-	dev->features	|= NETIF_F_GSO_ENCAP_ALL;
-	dev->hw_features |= dev->features;
-	dev->hw_enc_features |= dev->features;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
+	netdev_active_features_set(dev, NETIF_F_GSO_ENCAP_ALL);
+	netdev_hw_features_set(dev, dev->features);
+	netdev_hw_enc_features_set(dev, dev->features);
 	eth_hw_addr_random(dev);
 
 	dev->min_mtu = 0;
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index a8989c1146bb..c88cdfef3f22 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1781,7 +1781,7 @@ static int slic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->netdev_ops = &slic_netdev_ops;
 	netdev_hw_features_zero(dev);
 	netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 
 	dev->ethtool_ops = &slic_ethtool_ops;
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 64f9ee8581ce..3539769a84bb 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1558,7 +1558,7 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 * so it is turned off
 	 */
 	ndev->hw_features &= ~NETIF_F_SG;
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 
 	/* VLAN offloading of tagging, stripping and filtering is not
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 202b10c77408..833f6e67e925 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4050,8 +4050,8 @@ static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 	netdev->features = dev_features;
 	netdev_active_features_set_array(netdev, &ena_feature_set);
 
-	netdev->hw_features |= netdev->features;
-	netdev->vlan_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
+	netdev_vlan_features_set(netdev, netdev->features);
 }
 
 static void ena_set_conf_feat_params(struct ena_adapter *adapter,
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index d94d982357b1..585f9f6bc8b8 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -63,6 +63,7 @@ Revision History:
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -1791,7 +1792,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 #if AMD8111E_VLAN_TAG_USED
-	dev->features |= netdev_ctag_vlan_offload_features;
+	netdev_active_features_set(dev, netdev_ctag_vlan_offload_features);
 #endif
 
 	lp = netdev_priv(dev);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 4ee601db53cd..9d7ad79804e0 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2203,7 +2203,7 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	if ((features & vxlan_base) != vxlan_base) {
 		netdev_notice(netdev,
 			      "forcing both tx and rx udp tunnel support\n");
-		features |= vxlan_base;
+		netdev_features_set(&features, vxlan_base);
 	}
 
 	if (features & netdev_ip_csum_features) {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index e6a050b6bdee..6f2071d6098c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -390,7 +390,7 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 
 	netdev_vlan_features_set_array(netdev, &xgbe_vlan_feature_set);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	pdata->netdev_features = netdev->features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 5d6eaefb8391..775fff8f67d0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -383,7 +383,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	const struct aq_hw_caps_s *aq_hw_caps = self->aq_nic_cfg.aq_hw_caps;
 	struct aq_nic_cfg_s *aq_nic_cfg = &self->aq_nic_cfg;
 
-	self->ndev->hw_features |= *aq_hw_caps->hw_features;
+	netdev_hw_features_set(self->ndev, *aq_hw_caps->hw_features);
 	self->ndev->features = *aq_hw_caps->hw_features;
 	netdev_vlan_features_set_array(self->ndev, &aq_nic_vlan_feature_set);
 	netdev_gso_partial_features_zero(self->ndev);
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 9309d371b8da..b6c193dbee99 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -1029,8 +1029,8 @@ static int ax88796c_probe(struct spi_device *spi)
 	ndev->irq = spi->irq;
 	ndev->netdev_ops = &ax88796c_netdev_ops;
 	ndev->ethtool_ops = &ax88796c_ethtool_ops;
-	ndev->hw_features |= ax88796c_features;
-	ndev->features |= ax88796c_features;
+	netdev_hw_features_set(ndev, ax88796c_features);
+	netdev_active_features_set(ndev, ax88796c_features);
 	ndev->needed_headroom = TX_OVERHEAD;
 	ndev->needed_tailroom = TX_EOP_SIZE;
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index e47f6325cfba..47b323c13448 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1392,7 +1392,7 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_hw_features_zero(netdev);
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
-	netdev->features |= netdev_ctag_vlan_offload_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_offload_features);
 
 	/* Init PHY as early as possible due to power saving issue  */
 	atl2_phy_init(&adapter->hw);
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 075bdded8e45..37eac9beda4e 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -18,6 +18,7 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/if_ether.h>
@@ -2359,7 +2360,7 @@ static int b44_init_one(struct ssb_device *sdev,
 	SET_NETDEV_DEV(dev, sdev->dev);
 
 	/* No interesting netdevice features in this card... */
-	dev->features |= netdev_empty_features;
+	netdev_active_features_set(dev, netdev_empty_features);
 
 	bp = netdev_priv(dev);
 	bp->sdev = sdev;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 05a0c169e418..471be11b949c 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2583,8 +2583,8 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	netif_napi_add(dev, &priv->napi, bcm_sysport_poll, 64);
 
 	netdev_active_features_set_array(dev, &bcm_feature_set);
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_hw_features_set(dev, dev->features);
+	netdev_vlan_features_set(dev, dev->features);
 	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
 	/* Request the WOL interrupt and advertise suspend if available */
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index a47dd8ae6e8d..8455b0679670 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7758,7 +7758,7 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 		netdev_features_t tso;
 
 		tso = dev->hw_features & NETIF_F_ALL_TSO;
-		dev->vlan_features |= tso;
+		netdev_vlan_features_set(dev, tso);
 	} else {
 		dev->vlan_features &= ~NETIF_F_ALL_TSO;
 	}
@@ -8602,8 +8602,8 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	dev->vlan_features = dev->hw_features;
-	dev->hw_features |= netdev_ctag_vlan_offload_features;
-	dev->features |= dev->hw_features;
+	netdev_hw_features_set(dev, netdev_ctag_vlan_offload_features);
+	netdev_active_features_set(dev, dev->hw_features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->min_mtu = MIN_ETHERNET_PACKET_SIZE;
 	dev->max_mtu = MAX_ETHERNET_JUMBO_PACKET_SIZE;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index fe618561b712..92a1e370eac6 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13278,7 +13278,7 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 	 * getting a response to CHANNEL_TLV_ACQUIRE from PF.
 	 */
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (dev->features & NETIF_F_LRO)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a45a5c5684ca..258d9491a2f7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11203,7 +11203,8 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 			features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
 		else if (vlan_features)
-			features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
+			netdev_features_set(&features,
+					    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	}
 #ifdef CONFIG_BNXT_SRIOV
 	if (BNXT_VF(bp) && bp->vf.vlan)
@@ -13648,12 +13649,12 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->vlan_features = dev->hw_features;
 	netdev_vlan_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
-		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
+		netdev_hw_features_set(dev, BNXT_HW_FEATURE_VLAN_ALL_RX);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_TX_INSERT)
-		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_TX;
+		netdev_hw_features_set(dev, BNXT_HW_FEATURE_VLAN_ALL_TX);
 	if (BNXT_SUPPORTS_TPA(bp))
 		netdev_hw_feature_add(dev, NETIF_F_GRO_HW_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (dev->features & NETIF_F_GRO_HW)
 		dev->features &= ~NETIF_F_LRO;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index eb4803b11c0e..efd34f4ccd6a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -8,6 +8,7 @@
  */
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/jhash.h>
@@ -472,7 +473,7 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	dev->gso_partial_features = pf_dev->gso_partial_features;
 	dev->vlan_features = pf_dev->vlan_features;
 	dev->hw_enc_features = pf_dev->hw_enc_features;
-	dev->features |= pf_dev->features;
+	netdev_active_features_set(dev, pf_dev->features);
 	bnxt_vf_rep_eth_addr_gen(bp->pf.mac_addr, vf_rep->vf_idx,
 				 dev->perm_addr);
 	eth_hw_addr_set(dev, dev->perm_addr);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0d41ae12e262..4157ab4acfb0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4033,8 +4033,8 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	/* Set default features */
 	netdev_active_features_set_array(dev, &bcmgenet_feature_set);
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_hw_features_set(dev, dev->features);
+	netdev_vlan_features_set(dev, dev->features);
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ad927bc15d12..841c6dc1546f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17755,9 +17755,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 			netdev_feature_add(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
-	dev->features |= features;
-	dev->features |= netdev_ctag_vlan_offload_features;
-	dev->vlan_features |= features;
+	netdev_active_features_set(dev, features);
+	netdev_active_features_set(dev, netdev_ctag_vlan_offload_features);
+	netdev_vlan_features_set(dev, features);
 
 	/*
 	 * Add loopback capability only for a subset of devices that support
@@ -17769,7 +17769,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 		/* Add the loopback capability */
 		netdev_feature_add(NETIF_F_LOOPBACK_BIT, &features);
 
-	dev->hw_features |= features;
+	netdev_hw_features_set(dev, features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 60 - 9000 or 1500, depending on hardware */
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 786df1e64947..e0732e92657b 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3450,7 +3450,7 @@ bnad_netdev_init(struct bnad *bnad)
 	netdev_vlan_features_zero(netdev);
 	netdev_vlan_features_set_array(netdev, &bnad_vlan_feature_set);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_features_set_array(netdev, &bnad_feature_set);
 
 	netdev->mem_start = bnad->mmio_start;
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 415f61527650..fc3d688c1228 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1787,7 +1787,7 @@ static int xgmac_probe(struct platform_device *pdev)
 	netdev_hw_features_set_array(ndev, &xgmac_hw_feature_set);
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
 		netdev_hw_features_set_array(ndev, &xgmac_csum_feature_set);
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 46 - 9000 */
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index fafd248977ed..aa2e0d3537a3 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3600,7 +3600,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |= netdev_ctag_vlan_features;
+		netdev_features_set(&lio->dev_capability, netdev_ctag_vlan_features);
 
 		netdev->features = lio->dev_capability;
 		netdev->features &= ~NETIF_F_LRO;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 688a6c4931b9..6ee1032b3dad 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2128,7 +2128,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |= netdev_ctag_vlan_features;
+		netdev_features_set(&lio->dev_capability, netdev_ctag_vlan_features);
 
 		netdev->features = lio->dev_capability;
 		netdev->features &= ~NETIF_F_LRO;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index e806eb803dd5..67ad6c5e539f 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2225,7 +2225,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_hw_feature_add(netdev, NETIF_F_LOOPBACK_BIT);
 
 	netdev_vlan_features_zero(netdev);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 3174489477bc..80cc1f6fcfef 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1048,7 +1048,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_active_features_set_array(netdev, &cxgb_feature_set);
 
 		if (vlan_tso_capable(adapter)) {
-			netdev->features |= netdev_ctag_vlan_offload_features;
+			netdev_active_features_set(netdev,
+						   netdev_ctag_vlan_offload_features);
 			netdev_hw_feature_add(netdev,
 					      NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 35daa61d3c4f..c6d08aceffa0 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3321,12 +3321,12 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->mem_end = mmio_start + mmio_len - 1;
 		netdev_hw_features_zero(netdev);
 		netdev_hw_features_set_array(netdev, &cxgb_hw_feature_set);
-		netdev->features |= netdev->hw_features;
+		netdev_active_features_set(netdev, netdev->hw_features);
 		netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 		netdev_features_zero(&vlan_feat);
 		netdev_features_set_array(&cxgb_vlan_feature_set, &vlan_feat);
 		vlan_feat &= netdev->features;
-		netdev->vlan_features |= vlan_feat;
+		netdev_vlan_features_set(netdev, vlan_feat);
 
 		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index e5f29203a496..fd2e42662dd5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6861,7 +6861,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
 		}
 
-		netdev->features |= netdev->hw_features;
+		netdev_active_features_set(netdev, netdev->hw_features);
 		vlan_features = tso_features;
 		netdev_features_set_array(&cxgb4_vlan_feature_set, &vlan_features);
 		netdev->vlan_features = netdev->features & vlan_features;
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 77379e284cb9..5e67f4cd4285 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2894,7 +2894,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->watchdog_timeo = 2 * HZ;
 	enic_set_ethtool_ops(netdev);
 
-	netdev->features |= netdev_ctag_vlan_offload_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_offload_features);
 	if (ENIC_SETTING(enic, LOOP)) {
 		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 		enic->loop_enable = 1;
@@ -2906,7 +2906,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_hw_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	}
 	if (ENIC_SETTING(enic, TSO)) {
-		netdev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(netdev, netdev_general_tso_features);
 		netdev_hw_feature_add(netdev, NETIF_F_TSO_ECN_BIT);
 	}
 	if (ENIC_SETTING(enic, RSS))
@@ -2919,7 +2919,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		netdev_hw_enc_features_set_array(netdev,
 						 &enic_hw_enc_feature_set);
-		netdev->hw_features |= netdev->hw_enc_features;
+		netdev_hw_features_set(netdev, netdev->hw_enc_features);
 		/* get bit mask from hw about supported offload bit level
 		 * BIT(0) = fw supports patch_level 0
 		 *	    fcoe bit = encap
@@ -2952,8 +2952,8 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev->features |= netdev->hw_features;
-	netdev->vlan_features |= netdev->features;
+	netdev_active_features_set(netdev, netdev->hw_features);
+	netdev_vlan_features_set(netdev, netdev->features);
 
 #ifdef CONFIG_RFS_ACCEL
 	netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 09e2dc3bd280..6acb087baa6b 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2471,7 +2471,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	gmac_clear_hw_stats(netdev);
 
 	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
-	netdev->features |= GMAC_OFFLOAD_FEATURES;
+	netdev_active_features_set(netdev, GMAC_OFFLOAD_FEATURES);
 	netdev_active_feature_add(netdev, NETIF_F_GRO_BIT);
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
 	 * payloads of 10236 bytes minus VLAN and ethernet header
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index c90d8be25be5..8d3e3b3413d3 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1648,7 +1648,7 @@ dm9000_probe(struct platform_device *pdev)
 		netdev_hw_features_zero(ndev);
 		netdev_hw_feature_add(ndev, NETIF_F_RXCSUM_BIT);
 		netdev_hw_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
-		ndev->features |= ndev->hw_features;
+		netdev_active_features_set(ndev, ndev->hw_features);
 	}
 
 	/* from this point we assume that we have found a DM9000 */
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 7f4dcea2cd87..81f07336d205 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
@@ -763,7 +764,7 @@ static int dnet_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* TODO: Actually, we have some interesting features... */
-	dev->features |= netdev_empty_features;
+	netdev_active_features_set(dev, netdev_empty_features);
 
 	bp = netdev_priv(dev);
 	bp->dev = dev;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 0a29313e167a..ed6339b57841 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5218,7 +5218,7 @@ static void be_netdev_init(struct net_device *netdev)
 	if ((be_if_cap_flags(adapter) & BE_IF_FLAGS_RSS))
 		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_features_set_array(netdev, &be_feature_set);
 
 	netdev_vlan_features_set_array(netdev, &be_vlan_feature_set);
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 3ced63aaa6cb..1d62b8f04188 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/mii.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
@@ -1220,7 +1221,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	/* setup the net_device structure */
 	netdev->netdev_ops = &ethoc_netdev_ops;
 	netdev->watchdog_timeo = ETHOC_TIMEOUT;
-	netdev->features |= netdev_empty_features;
+	netdev_active_features_set(netdev, netdev_empty_features);
 	netdev->ethtool_ops = &ethoc_ethtool_ops;
 
 	/* setup NAPI */
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index c286e0039851..17525ce5f682 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1957,7 +1957,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	/* register network device */
 	err = register_netdev(netdev);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index c0cd9b14ef72..6f9bde1c4153 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -244,7 +244,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	/* we do not want shared skbs on TX */
 	net_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 
-	net_dev->features |= net_dev->hw_features;
+	netdev_active_features_set(net_dev, net_dev->hw_features);
 	net_dev->vlan_features = net_dev->features;
 
 	if (is_valid_ether_addr(mac_addr)) {
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 26861683f699..18efcb947d0f 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3257,7 +3257,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
-		dev->hw_features |= netdev_ctag_vlan_offload_features;
+		netdev_hw_features_set(dev, netdev_ctag_vlan_offload_features);
 		netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index fd981e357f2f..0fee1effb7ce 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1784,18 +1784,18 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 
 	netdev_features_set_array(&fun_gso_encap_feature_set, &gso_encap_flags);
 	netdev_features_set_array(&fun_tso_feature_set, &tso_flags);
-	vlan_feat = gso_encap_flags | tso_flags;
+	vlan_feat = netdev_features_or(gso_encap_flags, tso_flags);
 	netdev_features_set_array(&fun_vlan_feature_set, &vlan_feat);
 
 	netdev_hw_features_set_array(netdev, &fun_hw_feature_set);
 	if (fp->port_caps & FUN_PORT_CAP_OFFLOADS) {
 		netdev_hw_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
-		netdev->hw_features |= tso_flags;
+		netdev_hw_features_set(netdev, tso_flags);
 	}
 	if (fp->port_caps & FUN_PORT_CAP_ENCAP_OFFLOADS)
-		netdev->hw_features |= gso_encap_flags;
+		netdev_hw_features_set(netdev, gso_encap_flags);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	netdev->vlan_features = netdev->features & vlan_feat;
 	netdev->mpls_features = netdev->vlan_features;
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index bf79258b4904..a2d2ac6503ff 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1237,9 +1237,9 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	if (HAS_CAP_TSO(priv->hw_cap))
 		netdev_hw_feature_add(ndev, NETIF_F_SG_BIT);
 
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
-	ndev->vlan_features |= ndev->features;
+	netdev_vlan_features_set(ndev, ndev->features);
 
 	ret = hix5hd2_init_hw_desc_queue(priv);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 3a5a2adba3a2..837ff9f4e131 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -2364,7 +2364,7 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 	case AE_VERSION_2:
 		netdev_active_features_set_array(ndev, &hns_v2_feature_set);
 		netdev_hw_features_set_array(ndev, &hns_hw_feature_set);
-		ndev->vlan_features |= netdev_general_tso_features;
+		netdev_vlan_features_set(ndev, netdev_general_tso_features);
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 		break;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e67a30738a2d..30f231610e61 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3305,7 +3305,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev_active_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	else
-		netdev->features |= netdev_ip_csum_features;
+		netdev_active_features_set(netdev, netdev_ip_csum_features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev_active_feature_add(netdev,
@@ -3314,7 +3314,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
 		netdev_active_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
@@ -3322,9 +3322,9 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev_features_set_array(&hns3_vlan_off_feature_set,
 				  &vlan_off_features);
 	features = netdev->features & ~vlan_off_features;
-	netdev->vlan_features |= features;
+	netdev_vlan_features_set(netdev, features);
 
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 5e8d43e04b53..87c277fc95c4 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3177,7 +3177,7 @@ static int emac_probe(struct platform_device *ofdev)
 	if (dev->tah_dev) {
 		netdev_hw_features_zero(ndev);
 		netdev_hw_features_set_array(ndev, &emac_hw_feature_set);
-		ndev->features |= ndev->hw_features;
+		netdev_active_features_set(ndev, ndev->hw_features);
 		netdev_active_feature_add(ndev, NETIF_F_RXCSUM_BIT);
 	}
 	ndev->watchdog_timeo = 5 * HZ;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 9d5b99ce60c2..4687a22434ed 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1689,15 +1689,15 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
 		netdev_hw_features_set_array(netdev, &ibmveth_hw_feature_set);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	ret = h_illan_attributes(adapter->vdev->unit_address, 0, 0, &ret_attr);
 
 	/* If running older firmware, TSO should not be enabled by default */
 	if (ret == H_SUCCESS && (ret_attr & IBMVETH_ILLAN_LRG_SND_SUPPORT) &&
 	    !old_large_send) {
-		netdev->hw_features |= netdev_general_tso_features;
-		netdev->features |= netdev->hw_features;
+		netdev_hw_features_set(netdev, netdev_general_tso_features);
+		netdev_active_features_set(netdev, netdev->hw_features);
 	} else {
 		netdev_hw_feature_add(netdev, NETIF_F_TSO_BIT);
 	}
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5b757634973d..b5fa773272dd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4893,7 +4893,8 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		netdev_hw_feature_add(adapter->netdev, NETIF_F_TSO6_BIT);
 
 	if (adapter->state == VNIC_PROBING) {
-		adapter->netdev->features |= adapter->netdev->hw_features;
+		netdev_active_features_set(adapter->netdev,
+					   adapter->netdev->hw_features);
 	} else if (old_hw_features != adapter->netdev->hw_features) {
 		netdev_features_t tmp = netdev_empty_features;
 
@@ -4903,7 +4904,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		tmp = old_hw_features ^ adapter->netdev->hw_features;
 		tmp &= adapter->netdev->hw_features;
 		tmp &= adapter->netdev->wanted_features;
-		adapter->netdev->features |= tmp;
+		netdev_active_features_set(adapter->netdev, tmp);
 	}
 
 	memset(&crq, 0, sizeof(crq));
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index ea3a958a8945..acf68d405812 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1063,7 +1063,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_hw_features_set_array(netdev, &e1000_hw_rx_feature_set);
 
 	if (pci_using_dac) {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 439fb2110c55..a2b28da7a56e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5305,7 +5305,8 @@ static void e1000_watchdog_task(struct work_struct *work)
 					netdev->features &= ~netdev_general_tso_features;
 					break;
 				case SPEED_1000:
-					netdev->features |= netdev_general_tso_features;
+					netdev_active_features_set(netdev,
+								   netdev_general_tso_features);
 					break;
 				default:
 					/* oops */
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index e51f05bfaa1d..3b9df01b313e 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1595,17 +1595,17 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	netdev_feature_add(NETIF_F_HW_L2FW_DOFFLOAD_BIT, &hw_features);
 
 	/* configure VLAN features */
-	dev->vlan_features |= dev->features;
+	netdev_vlan_features_set(dev, dev->features);
 
 	/* we want to leave these both on as we cannot disable VLAN tag
 	 * insertion or stripping on the hardware since it is contained
 	 * in the FTAG and not in the frame itself.
 	 */
-	dev->features |= netdev_ctag_vlan_features;
+	netdev_active_features_set(dev, netdev_ctag_vlan_features);
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
-	dev->hw_features |= hw_features;
+	netdev_hw_features_set(dev, hw_features);
 
 	/* MTU range: 68 - 15342 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 0eb64901e3e1..25a2b77ffd6f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13687,10 +13687,10 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 
 	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 
-	netdev->hw_enc_features |= hw_enc_features;
+	netdev_hw_enc_features_set(netdev, hw_enc_features);
 
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features;
+	netdev_vlan_features_set(netdev, hw_enc_features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	netdev_features_zero(&gso_partial_features);
@@ -13698,24 +13698,25 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	netdev_mpls_features_set_array(netdev, &i40e_mpls_feature_set);
-	netdev->mpls_features |= gso_partial_features;
+	netdev_mpls_features_set(netdev, gso_partial_features);
 
 	/* enable macvlan offloads */
 	netdev_hw_feature_add(netdev, NETIF_F_HW_L2FW_DOFFLOAD_BIT);
 
-	hw_features = hw_enc_features | netdev_ctag_vlan_offload_features;
+	hw_features = netdev_features_or(hw_enc_features,
+					 netdev_ctag_vlan_offload_features);
 
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED)) {
 		netdev_feature_add(NETIF_F_NTUPLE_BIT, &hw_features);
 		netdev_feature_add(NETIF_F_HW_TC_BIT, &hw_features);
 	}
 
-	netdev->hw_features |= hw_features;
+	netdev_hw_features_set(netdev, hw_features);
 
-	netdev->features |= hw_features;
+	netdev_active_features_set(netdev, hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 19b79755ddda..ae8471342166 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4324,7 +4324,8 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 
 	/* Enable VLAN features if supported */
 	if (VLAN_ALLOWED(adapter)) {
-		hw_features |= netdev_ctag_vlan_offload_features;
+		netdev_features_set(&hw_features,
+				    netdev_ctag_vlan_offload_features);
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4390,7 +4391,7 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 		return features;
 
 	if (VLAN_ALLOWED(adapter)) {
-		features |= netdev_ctag_vlan_features;
+		netdev_features_set(&features, netdev_ctag_vlan_features);
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4497,8 +4498,8 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 {
 	netdev_features_t allowed_features;
 
-	allowed_features = iavf_get_netdev_vlan_hw_features(adapter) |
-		iavf_get_netdev_vlan_features(adapter);
+	allowed_features = netdev_features_or(iavf_get_netdev_vlan_hw_features(adapter),
+					      iavf_get_netdev_vlan_features(adapter));
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
@@ -4646,10 +4647,10 @@ int iavf_process_config(struct iavf_adapter *adapter)
 		netdev_gso_partial_feature_add(netdev,
 					       NETIF_F_GSO_GRE_CSUM_BIT);
 		netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
-		netdev->hw_enc_features |= hw_enc_features;
+		netdev_hw_enc_features_set(netdev, hw_enc_features);
 	}
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features;
+	netdev_vlan_features_set(netdev, hw_enc_features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	/* Write features and hw_features separately to avoid polluting
@@ -4666,12 +4667,12 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
 		netdev_feature_add(NETIF_F_GSO_UDP_L4_BIT, &hw_features);
 
-	netdev->hw_features |= hw_features;
-	netdev->hw_features |= hw_vlan_features;
+	netdev_hw_features_set(netdev, hw_features);
+	netdev_hw_features_set(netdev, hw_vlan_features);
 	vlan_features = iavf_get_netdev_vlan_features(adapter);
 
-	netdev->features |= hw_features;
-	netdev->features |= vlan_features;
+	netdev_active_features_set(netdev, hw_features);
+	netdev_active_features_set(netdev, vlan_features);
 
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
 		netdev_active_feature_add(netdev,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d0ecd7f3302a..d71c226ae5af 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3365,27 +3365,27 @@ static void ice_set_netdev_features(struct net_device *netdev)
 				       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 	/* set features that user can change */
-	netdev->hw_features = dflt_features | csumo_features;
-	netdev->hw_features |= vlano_features;
-	netdev->hw_features |= tso_features;
+	netdev->hw_features = netdev_features_or(dflt_features, csumo_features);
+	netdev_hw_features_set(netdev, vlano_features);
+	netdev_hw_features_set(netdev, tso_features);
 
 	/* add support for HW_CSUM on packets with MPLS header */
 	netdev_mpls_features_zero(netdev);
 	netdev_mpls_features_set_array(netdev, &ice_mpls_feature_set);
 
 	/* enable features */
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_LOOPBACK_BIT);
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
-	netdev->hw_enc_features |= dflt_features;
-	netdev->hw_enc_features |= csumo_features;
-	netdev->hw_enc_features |= tso_features;
-	netdev->vlan_features |= dflt_features;
-	netdev->vlan_features |= csumo_features;
-	netdev->vlan_features |= tso_features;
+	netdev_hw_enc_features_set(netdev, dflt_features);
+	netdev_hw_enc_features_set(netdev, csumo_features);
+	netdev_hw_enc_features_set(netdev, tso_features);
+	netdev_vlan_features_set(netdev, dflt_features);
+	netdev_vlan_features_set(netdev, csumo_features);
+	netdev_vlan_features_set(netdev, tso_features);
 
 	/* advertise support but don't enable by default since only one type of
 	 * VLAN offload can be enabled at a time (i.e. CTAG or STAG). When one
@@ -3393,7 +3393,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * ice_fix_features() ndo callback.
 	 */
 	if (is_dvm_ena)
-		netdev->hw_features |= netdev_stag_vlan_offload_features;
+		netdev_hw_features_set(netdev, netdev_stag_vlan_offload_features);
 }
 
 /**
@@ -5791,12 +5791,14 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	if (req_vlan_fltr != cur_vlan_fltr) {
 		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
 			if (req_ctag && req_stag) {
-				features |= NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_set(&features,
+						    NETIF_VLAN_FILTERING_FEATURES);
 			} else if (!req_ctag && !req_stag) {
 				features &= ~NETIF_VLAN_FILTERING_FEATURES;
 			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
 				   (!cur_stag && req_stag && !cur_ctag)) {
-				features |= NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_set(&features,
+						    NETIF_VLAN_FILTERING_FEATURES);
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
 			} else if ((cur_ctag && !req_ctag && cur_stag) ||
 				   (cur_stag && !req_stag && cur_ctag)) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 14e391e4bc23..c6b1d30ba2f6 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3310,11 +3310,11 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_features_set_array(&igb_feature_set, &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features;
-	netdev->hw_features |= netdev_ctag_vlan_offload_features;
+	netdev_hw_features_set(netdev, netdev->features);
+	netdev_hw_features_set(netdev, netdev_ctag_vlan_offload_features);
 	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
 
 	if (hw->mac.type >= e1000_i350)
@@ -3322,13 +3322,13 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= netdev->features;
+	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 	netdev_mpls_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= netdev_ctag_vlan_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_features);
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 55685206eac1..7d04d87157de 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2795,18 +2795,18 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->hw_features |= gso_partial_features;
+	netdev_hw_features_set(netdev, gso_partial_features);
 
 	netdev->features = netdev->hw_features;
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= netdev->features;
+	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 	netdev_mpls_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= netdev_ctag_vlan_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_features);
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f53175a80606..c594dfeb5dfd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6336,7 +6336,7 @@ static int igc_probe(struct pci_dev *pdev,
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
@@ -6347,14 +6347,14 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
 
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= netdev->features;
+	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 	netdev_mpls_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 40228bff5e82..727df1a82ec0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11022,7 +11022,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB) {
 		netdev_active_feature_add(netdev, NETIF_F_SCTP_CRC_BIT);
@@ -11034,7 +11034,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_active_features_set_array(netdev, &ixgbe_esp_feature_set);
 #endif
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
 	netdev_hw_features_set_array(netdev, &ixgbe_hw_feature_set);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB) {
@@ -11044,14 +11044,14 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= netdev->features;
+	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 	netdev_mpls_features_set_array(netdev, &ixgbe_mpls_feature_set);
-	netdev->mpls_features |= gso_partial_features;
+	netdev_mpls_features_set(netdev, gso_partial_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= netdev_ctag_vlan_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 79d2400b03df..bca192bf7ed9 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4634,20 +4634,20 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->hw_features |= gso_partial_features;
+	netdev_hw_features_set(netdev, gso_partial_features);
 
 	netdev->features = netdev->hw_features;
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= netdev->features;
+	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	netdev_mpls_features_set_array(netdev, &ixgbevf_mpls_feature_set);
-	netdev->mpls_features |= gso_partial_features;
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_mpls_features_set(netdev, gso_partial_features);
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= netdev_ctag_vlan_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 3b9c7257622d..c2a77f161286 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5623,8 +5623,8 @@ static int mvneta_probe(struct platform_device *pdev)
 
 	netdev_active_features_zero(dev);
 	netdev_active_features_set_array(dev, &mvneta_feature_set);
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_hw_features_set(dev, dev->features);
+	netdev_vlan_features_set(dev, dev->features);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_set_tso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ce17ed4b8828..c6f608388dff 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1278,8 +1278,8 @@ static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 		port->dev->features &= ~csums;
 		port->dev->hw_features &= ~csums;
 	} else {
-		port->dev->features |= csums;
-		port->dev->hw_features |= csums;
+		netdev_active_features_set(port->dev, csums);
+		netdev_hw_features_set(port->dev, csums);
 	}
 }
 
@@ -1344,8 +1344,9 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 			dev->features &= ~netdev_ip_csum_features;
 			dev->hw_features &= ~netdev_ip_csum_features;
 		} else {
-			dev->features |= netdev_ip_csum_features;
-			dev->hw_features |= netdev_ip_csum_features;
+			netdev_active_features_set(dev,
+						   netdev_ip_csum_features);
+			netdev_hw_features_set(dev, netdev_ip_csum_features);
 		}
 	}
 
@@ -6860,7 +6861,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	netdev_features_set_array(&mvpp2_feature_set, &features);
 	dev->features = features;
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
-	dev->hw_features |= features;
+	netdev_hw_features_set(dev, features);
 	netdev_hw_features_set_array(dev, &mvpp2_hw_feature_set);
 
 	if (mvpp22_rss_is_supported(port)) {
@@ -6871,7 +6872,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	if (!port->priv->percpu_pools)
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
-	dev->vlan_features |= features;
+	netdev_vlan_features_set(dev, features);
 	netif_set_tso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index bde76afe991d..3e7bb0126b12 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1067,7 +1067,7 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_hw_features_zero(netdev);
 	netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev->min_mtu = OCTEP_MIN_MTU;
 	netdev->max_mtu = OCTEP_MAX_MTU;
 	netdev->mtu = OCTEP_DEFAULT_MTU;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index fc61e17b300f..ef2d175f586b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2705,7 +2705,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &otx2_hw_feature_set);
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	err = otx2_mcam_flow_init(pf);
 	if (err)
@@ -2718,11 +2718,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* Support TSO on tag interface */
-	netdev->vlan_features |= netdev->features;
-	netdev->hw_features  |= netdev_tx_vlan_features;
+	netdev_vlan_features_set(netdev, netdev->features);
+	netdev_hw_features_set(netdev, netdev_tx_vlan_features);
 	if (pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
-		netdev->hw_features |= netdev_rx_vlan_features;
-	netdev->features |= netdev->hw_features;
+		netdev_hw_features_set(netdev, netdev_rx_vlan_features);
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	/* HW supports tc offload but mutually exclusive with n-tuple filters */
 	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index d75a09f291b0..3303e9b631b2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -652,9 +652,9 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev_hw_features_set_array(netdev, &otx2vf_hw_feature_set);
 	netdev->features = netdev->hw_features;
 	/* Support TSO on tag interface */
-	netdev->vlan_features |= netdev->features;
-	netdev->hw_features  |= netdev_tx_vlan_features;
-	netdev->features |= netdev->hw_features;
+	netdev_vlan_features_set(netdev, netdev->features);
+	netdev_hw_features_set(netdev, netdev_tx_vlan_features);
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 9f16ade3e439..cd2636ef08d3 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3867,7 +3867,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	else {
 		netdev_hw_features_zero(dev);
 		netdev_hw_features_set_array(dev, &skge_hw_feature_set);
-		dev->features |= dev->hw_features;
+		netdev_active_features_set(dev, dev->hw_features);
 	}
 
 	/* read the mac address */
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 01e9893f73bb..caaa3692e2b8 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4655,11 +4655,11 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 		netdev_hw_feature_add(dev, NETIF_F_RXHASH_BIT);
 
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
-		dev->hw_features |= netdev_ctag_vlan_offload_features;
+		netdev_hw_features_set(dev, netdev_ctag_vlan_offload_features);
 		netdev_vlan_features_set_array(dev, &sky2_vlan_feature_set);
 	}
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 
 	/* MTU range: 60 - 1500 or 9000 */
 	dev->min_mtu = ETH_ZLEN;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0043f387449f..5557bae234b1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3901,7 +3901,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
 		~netdev_ctag_vlan_offload_features;
-	eth->netdev[id]->features |= *eth->soc->hw_features;
+	netdev_active_features_set(eth->netdev[id], *eth->soc->hw_features);
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
 	eth->netdev[id]->irq = eth->irq[0];
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 080b5450e3a8..113944e047ab 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3361,7 +3361,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &mlx4_hw_feature_set1);
 	if (mdev->LSO_support)
-		dev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(dev, netdev_general_tso_features);
 
 	if (mdev->dev->caps.tunnel_offload_mode ==
 	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3ee785091aa7..bd2a7e875ce6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -687,7 +687,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev_hw_feature_add(netdev, NETIF_F_TSO6_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_NETNS_LOCAL_BIT);
 }
 
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index f421f48cb135..39891b7e6c71 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6720,7 +6720,7 @@ static int __init netdev_init(struct net_device *dev)
 	 */
 	netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 
 	sema_init(&priv->proc_sem, 1);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 738eaa88279a..c5c4d680e70c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -5,6 +5,7 @@
 #include <linux/if_vlan.h>
 #include <linux/iopoll.h>
 #include <linux/ip.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
 #include <linux/packing.h>
@@ -753,7 +754,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->ethtool_ops = &lan966x_ethtool_ops;
-	dev->features |= netdev_tx_vlan_features;
+	netdev_active_features_set(dev, netdev_tx_vlan_features);
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 83a3ad14c79f..c6dd11c872f9 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3876,7 +3876,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->features = netdev->hw_features;
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= mgp->features;
+	netdev_vlan_features_set(netdev, mgp->features);
 	if (mgp->fw_ver_tiny < 37)
 		netdev->vlan_features &= ~NETIF_F_TSO6;
 	if (mgp->fw_ver_tiny < 32)
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index a5db6ccdb2df..f7309c2498da 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2150,7 +2150,7 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 
 #ifdef NS83820_VLAN_ACCEL_SUPPORT
 	/* We also support hardware vlan acceleration */
-	ndev->features |= netdev_ctag_vlan_offload_features;
+	netdev_active_features_set(ndev, netdev_ctag_vlan_offload_features);
 #endif
 
 	if (using_dac) {
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 8b3def9866d0..9b74b1b87220 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7869,7 +7869,7 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 	dev->ethtool_ops = &netdev_ethtool_ops;
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &s2io_hw_feature_set);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_features_set_array(dev, &s2io_feature_set);
 	dev->watchdog_timeo = WATCH_DOG_TIMEOUT;
 	INIT_WORK(&sp->rst_timer_task, s2io_restart_nic);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0b2e6dfa0ac2..071e0c6aa219 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2359,7 +2359,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXCSUM) {
-		netdev->hw_features |= netdev_ip_csum_features;
+		netdev_hw_features_set(netdev, netdev_ip_csum_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_GATHER) {
@@ -2368,7 +2368,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	}
 	if ((nn->cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    nn->cap & NFP_NET_CFG_CTRL_LSO2) {
-		netdev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(netdev, netdev_general_tso_features);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					 NFP_NET_CFG_CTRL_LSO;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index a193d87c7e39..b8a8aa917fdd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -252,7 +252,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	tmp = NETIF_F_SOFT_FEATURES;
 	netdev_feature_add(NETIF_F_HW_TC_BIT, &tmp);
 	tmp &= old_features;
-	features |= tmp;
+	netdev_features_set(&features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
 	return features;
@@ -350,12 +350,12 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	if (repr_cap & NFP_NET_CFG_CTRL_RXCSUM_ANY)
 		netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 	if (repr_cap & NFP_NET_CFG_CTRL_TXCSUM)
-		netdev->hw_features |= netdev_ip_csum_features;
+		netdev_hw_features_set(netdev, netdev_ip_csum_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_GATHER)
 		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 	if ((repr_cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    repr_cap & NFP_NET_CFG_CTRL_LSO2)
-		netdev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(netdev, netdev_general_tso_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_RSS_ANY)
 		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 	if (repr_cap & NFP_NET_CFG_CTRL_VXLAN) {
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 5adc4f02f36f..44e502650328 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5825,10 +5825,10 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	np->vlanctl_bits = 0;
 	if (id->driver_data & DEV_HAS_VLAN) {
 		np->vlanctl_bits = NVREG_VLANCONTROL_ENABLE;
-		dev->hw_features |= netdev_ctag_vlan_offload_features;
+		netdev_hw_features_set(dev, netdev_ctag_vlan_offload_features);
 	}
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 
 	/* Add loopback capability to the device. */
 	netdev_hw_feature_add(dev, NETIF_F_LOOPBACK_BIT);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2d1c6d591baa..c330ea873300 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1546,10 +1546,10 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 		netdev_hw_enc_feature_add(netdev,
 					  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
-	netdev->hw_features |= netdev->hw_enc_features;
-	netdev->features |= netdev->hw_features;
+	netdev_hw_features_set(netdev, netdev->hw_enc_features);
+	netdev_active_features_set(netdev, netdev->hw_features);
 	features = netdev->features & ~NETIF_F_VLAN_FEATURES;
-	netdev->vlan_features |= features;
+	netdev_vlan_features_set(netdev, features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
 			      IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index b4c56b023122..ce1bb941fd85 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1364,7 +1364,7 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 		netdev_hw_feature_add(netdev, NETIF_F_TSO6_BIT);
 	}
 
-	netdev->vlan_features |= netdev->hw_features;
+	netdev_vlan_features_set(netdev, netdev->hw_features);
 
 	if (adapter->pci_using_dac) {
 		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
@@ -1377,7 +1377,7 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 	if (adapter->capabilities & NX_FW_CAPABILITY_HW_LRO)
 		netdev_hw_feature_add(netdev, NETIF_F_LRO_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	netdev->irq = adapter->msix_entries[0].vector;
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index d768cee19d3a..fa06ba45e8dc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2300,8 +2300,9 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 	netdev_vlan_features_set_array(netdev, &qlcnic_vlan_feature_set);
 
 	if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
-		netdev->features |= netdev_general_tso_features;
-		netdev->vlan_features |= netdev_general_tso_features;
+		netdev_active_features_set(netdev,
+					   netdev_general_tso_features);
+		netdev_vlan_features_set(netdev, netdev_general_tso_features);
 	}
 
 	if (qlcnic_vlan_tx_check(adapter))
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ded5fef309be..d0887e74167f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5445,7 +5445,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rtl_chip_supports_csum_v2(tp))
 		netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 
 	/* There has been a number of reports that using SG/TSO results in
 	 * tx timeouts. However for a lot of people SG/TSO works fine.
@@ -5454,7 +5454,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
 		netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
-		dev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(dev, netdev_general_tso_features);
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 0a664cc7739e..9c6b7136f7fa 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2117,7 +2117,7 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 
 	netdev_hw_features_zero(ndev);
 	netdev_hw_features_set_array(ndev, &sxgbe_hw_feature_set);
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 2e0a096b5967..351ee0954053 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1357,7 +1357,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= netdev_ip_csum_features;
+		netdev_features_set(&hw_enc_features, netdev_ip_csum_features);
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
@@ -1366,9 +1366,9 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		netdev_features_set_array(&ef10_tso_feature_set,
 					  &encap_tso_features);
 
-		hw_enc_features |= encap_tso_features;
+		netdev_features_set(&hw_enc_features, encap_tso_features);
 		netdev_feature_add(NETIF_F_TSO_BIT, &hw_enc_features);
-		efx->net_dev->features |= encap_tso_features;
+		netdev_active_features_set(efx->net_dev, encap_tso_features);
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
 
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index cbe9fda5464f..3597c4e02d08 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -372,10 +372,10 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	efx->net_dev = net_dev;
 	SET_NETDEV_DEV(net_dev, &efx->pci_dev->dev);
 
-	net_dev->features |= *efx->type->offload_features;
-	net_dev->hw_features |= *efx->type->offload_features;
-	net_dev->hw_enc_features |= *efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
+	netdev_hw_features_set(net_dev, *efx->type->offload_features);
+	netdev_hw_enc_features_set(net_dev, *efx->type->offload_features);
+	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &ef100_vlan_feature_set);
 	netif_set_tso_max_segs(net_dev,
 			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index f40766137540..2fb83949b87c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -201,9 +201,9 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 		netdev_features_zero(&tso);
 		netdev_features_set_array(&ef100_tso_feature_set, &tso);
-		net_dev->features |= tso;
-		net_dev->hw_features |= tso;
-		net_dev->hw_enc_features |= tso;
+		netdev_active_features_set(net_dev, tso);
+		netdev_hw_features_set(net_dev, tso);
+		netdev_hw_enc_features_set(net_dev, tso);
 		/* EF100 HW can only offload outer checksums if they are UDP,
 		 * so for GRE_CSUM we have to use GSO_PARTIAL.
 		 */
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 9feb3295ccaa..5134fbd0382a 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1014,7 +1014,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
 	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
@@ -1023,11 +1023,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
 	tmp = net_dev->features & ~efx->fixed_features;
-	net_dev->hw_features |= tmp;
+	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
@@ -1037,7 +1037,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index c3a29d4169c9..def02fe850af 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -414,9 +414,9 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
+	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 6fab0c10b78d..b803b8688c60 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -635,9 +635,9 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
+	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
 
@@ -2907,7 +2907,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_feature_add(net_dev, NETIF_F_SG_BIT);
 	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
@@ -2919,7 +2919,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index f04b66b62840..f3812d26aeb0 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1303,7 +1303,7 @@ static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	return netdev_active_features_or(net_dev, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 4b0ae2353f3f..6b398fd3d6d4 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1754,7 +1754,7 @@ static inline netdev_features_t efx_supported_features(const struct efx_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	return netdev_active_features_or(net_dev, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 4a3d2be92a12..d5818151bb04 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -996,7 +996,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
 	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
@@ -1005,10 +1005,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
-	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
+	netdev_hw_features_set(net_dev,
+			       net_dev->features & ~efx->fixed_features);
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
@@ -1018,7 +1019,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 4c0f915dba82..1c7a4ee1723f 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -411,9 +411,9 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
+	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
 
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 331af932e56d..0748b4955f99 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -11,6 +11,7 @@
 #define EFX_NET_DRIVER_H
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
@@ -1681,7 +1682,7 @@ static inline netdev_features_t efx_supported_features(const struct efx_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	return netdev_active_features_or(net_dev, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c85941528096..4d722a6ed2ca 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7148,7 +7148,7 @@ int stmmac_dvr_probe(struct device *device,
 	}
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		ndev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(ndev, netdev_general_tso_features);
 		if (priv->plat->has_gmac4)
 			netdev_hw_feature_add(ndev, NETIF_F_GSO_UDP_L4_BIT);
 		priv->tso = true;
@@ -7194,14 +7194,14 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
-	ndev->features |= netdev_rx_vlan_features;
+	netdev_active_features_set(ndev, netdev_rx_vlan_features);
 	if (priv->dma_cap.vlhash)
-		ndev->features |= netdev_vlan_filter_features;
+		netdev_active_features_set(ndev, netdev_vlan_filter_features);
 	if (priv->dma_cap.vlins) {
 		netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 		if (priv->dma_cap.dvlan)
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 41398fa580c2..bc531188b957 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9743,7 +9743,7 @@ static void niu_set_basic_features(struct net_device *dev)
 {
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &niu_hw_feature_set);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 }
 
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 5eaf7c40a0ad..494bbfafd91b 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2788,7 +2788,7 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	netdev_hw_features_zero(dev);
 	netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
 	netdev_hw_feature_add(dev, NETIF_F_HW_CSUM_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 	hp->irq = op->archdata.irqs[0];
@@ -3111,7 +3111,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	netdev_hw_features_zero(dev);
 	netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
 	netdev_hw_feature_add(dev, NETIF_F_HW_CSUM_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index f15e8768526d..a20c6c055369 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -181,7 +181,7 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 	if (pdata->hw_feat.tso) {
 		netdev->hw_features = netdev_general_tso_features;
 		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
-		netdev->hw_features |= netdev_ip_csum_features;
+		netdev_hw_features_set(netdev, netdev_ip_csum_features);
 	} else if (pdata->hw_feat.tx_coe) {
 		netdev->hw_features = netdev_ip_csum_features;
 	}
@@ -194,7 +194,7 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 	if (pdata->hw_feat.rss)
 		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
-	netdev->vlan_features |= netdev->hw_features;
+	netdev_vlan_features_set(netdev, netdev->hw_features);
 
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	if (pdata->hw_feat.sa_vlan_ins)
@@ -202,7 +202,7 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 	if (pdata->hw_feat.vlhash)
 		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	pdata->netdev_features = netdev->features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index adc8a3de10ff..cee1a279832a 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -974,7 +974,7 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 	}
 
 	if (rp->quirks & rqMgmt)
-		dev->features |= netdev_ctag_vlan_features;
+		netdev_active_features_set(dev, netdev_ctag_vlan_features);
 
 	/* dev->name not defined before register_netdev()! */
 	rc = register_netdev(dev);
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 33a1554c7f83..08bd27fd0ed0 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1259,10 +1259,10 @@ static void geneve_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &geneve_type);
 
 	netdev_active_features_set_array(dev, &geneve_feature_set);
-	dev->features    |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 
 	netdev_hw_features_set_array(dev, &geneve_hw_feature_set);
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 
 	/* MTU range: 68 - (something less than 65535) */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 9729cd9c37b3..0737794728a2 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1433,7 +1433,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	 */
 	netdev_features_fill(&features);
 	features &= ~NETVSC_SUPPORTED_HW_FEATURES;
-	features |= net->hw_features;
+	netdev_features_set(&features, net->hw_features);
 	net->features &= features;
 
 	netif_set_tso_max_size(net, gso_max_size);
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 370f3fa59587..912570321bfd 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -323,13 +323,14 @@ static void ifb_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->tx_queue_len = TX_Q_LIMIT;
 
-	ifb_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	ifb_features = netdev_features_or(NETIF_F_GSO_SOFTWARE,
+					  NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_array(&ifb_feature_set, &ifb_features);
-	dev->features |= ifb_features;
-	dev->hw_features |= dev->features;
-	dev->hw_enc_features |= dev->features;
+	netdev_active_features_set(dev, ifb_features);
+	netdev_hw_features_set(dev, dev->features);
+	netdev_hw_enc_features_set(dev, dev->features);
 	ifb_features &= ~netdev_tx_vlan_features;
-	dev->vlan_features |= ifb_features;
+	netdev_vlan_features_set(dev, ifb_features);
 
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 0078ecfe8838..3d96a990eded 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -152,10 +152,10 @@ static int ipvlan_init(struct net_device *dev)
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
 	dev->features = phy_dev->features & IPVLAN_FEATURES;
-	dev->features |= IPVLAN_ALWAYS_ON;
+	netdev_active_features_set(dev, IPVLAN_ALWAYS_ON);
 	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
-	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
-	dev->hw_enc_features |= dev->features;
+	netdev_vlan_features_set(dev, IPVLAN_ALWAYS_ON_OFLOADS);
+	netdev_hw_enc_features_set(dev, dev->features);
 	netif_inherit_tso_max(dev, phy_dev);
 	dev->hard_header_len = phy_dev->hard_header_len;
 
@@ -256,15 +256,15 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 	netdev_features_t tmp;
 
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(&tmp);
 	tmp &= ~IPVLAN_FEATURES;
-	tmp |= ipvlan->sfeatures;
+	netdev_features_set(&tmp, ipvlan->sfeatures);
 	features &= tmp;
 	features = netdev_increment_features(ipvlan->phy_dev->features,
 					     features, features);
-	features |= IPVLAN_ALWAYS_ON;
-	tmp = IPVLAN_FEATURES | IPVLAN_ALWAYS_ON;
+	netdev_features_set(&features, IPVLAN_ALWAYS_ON);
+	tmp = netdev_features_or(IPVLAN_FEATURES, IPVLAN_ALWAYS_ON);
 	features &= tmp;
 
 	return features;
@@ -1042,7 +1042,8 @@ static struct notifier_block ipvlan_addr6_vtor_notifier_block __read_mostly = {
 
 static void __init ipvlan_features_init(void)
 {
-	ipvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	ipvlan_offload_features = netdev_features_or(NETIF_F_GSO_SOFTWARE,
+						     NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_array(&ipvlan_on_offload_feature_set,
 				  &ipvlan_offload_features);
 
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 35b9e9831ab8..c8ee65e9c170 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3457,7 +3457,7 @@ static int macsec_dev_init(struct net_device *dev)
 	} else {
 		dev->features = real_dev->features & SW_MACSEC_FEATURES;
 		netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-		dev->features |= NETIF_F_GSO_SOFTWARE;
+		netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	}
 
 	dev->needed_headroom = real_dev->needed_headroom +
@@ -3495,8 +3495,8 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 		return REAL_DEV_FEATURES(real_dev);
 
 	tmp = real_dev->features & SW_MACSEC_FEATURES;
-	tmp |= NETIF_F_GSO_SOFTWARE;
-	tmp |= NETIF_F_SOFT_FEATURES;
+	netdev_features_set(&tmp, NETIF_F_GSO_SOFTWARE);
+	netdev_features_set(&tmp, NETIF_F_SOFT_FEATURES);
 	features &= tmp;
 	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 5df2989cf562..1fc6941fe633 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -917,11 +917,11 @@ static int macvlan_init(struct net_device *dev)
 	dev->state		= (dev->state & ~MACVLAN_STATE_MASK) |
 				  (lowerdev->state & MACVLAN_STATE_MASK);
 	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
-	dev->features		|= ALWAYS_ON_FEATURES;
+	netdev_active_features_set(dev, ALWAYS_ON_FEATURES);
 	netdev_hw_feature_add(dev, NETIF_F_LRO_BIT);
 	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
-	dev->vlan_features	|= ALWAYS_ON_OFFLOADS;
-	dev->hw_enc_features    |= dev->features;
+	netdev_vlan_features_set(dev, ALWAYS_ON_OFFLOADS);
+	netdev_hw_enc_features_set(dev, dev->features);
 	netif_inherit_tso_max(dev, lowerdev);
 	dev->hard_header_len	= lowerdev->hard_header_len;
 	macvlan_set_lockdep_class(dev);
@@ -1101,10 +1101,10 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 	netdev_features_t tmp;
 
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(&tmp);
 	tmp &= ~MACVLAN_FEATURES;
-	tmp |= vlan->set_features;
+	netdev_features_set(&tmp, vlan->set_features);
 	features &= tmp;
 	mask = features;
 
@@ -1112,8 +1112,8 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	tmp &= ~NETIF_F_LRO;
 	lowerdev_features &= tmp;
 	features = netdev_increment_features(lowerdev_features, features, mask);
-	features |= ALWAYS_ON_FEATURES;
-	tmp = ALWAYS_ON_FEATURES | MACVLAN_FEATURES;
+	netdev_features_set(&features, ALWAYS_ON_FEATURES);
+	tmp = netdev_features_or(ALWAYS_ON_FEATURES, MACVLAN_FEATURES);
 	features &= tmp;
 
 	return features;
@@ -1840,7 +1840,8 @@ static struct notifier_block macvlan_notifier_block __read_mostly = {
 
 static void __init macvlan_features_init(void)
 {
-	macvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	macvlan_offload_features = netdev_features_or(NETIF_F_GSO_SOFTWARE,
+						      NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_array(&macvlan_on_offload_feature_set,
 				  &macvlan_offload_features);
 
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index c643e4914e8e..b2721d802929 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -435,7 +435,8 @@ static void net_failover_compute_features(struct net_device *dev)
 	}
 
 	dev->vlan_features = vlan_features;
-	dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	dev->hw_enc_features = netdev_features_or(enc_features,
+						  NETIF_F_GSO_ENCAP_ALL);
 	dev->hard_header_len = max_hard_header_len;
 
 	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -754,11 +755,11 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	/* Don't allow failover devices to change network namespaces. */
 	netdev_active_feature_add(failover_dev, NETIF_F_NETNS_LOCAL_BIT);
 
-	failover_dev->hw_features = FAILOVER_VLAN_FEATURES |
-				    netdev_ctag_vlan_features;
+	failover_dev->hw_features = netdev_features_or(FAILOVER_VLAN_FEATURES,
+						       netdev_ctag_vlan_features);
 
-	failover_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-	failover_dev->features |= failover_dev->hw_features;
+	netdev_hw_features_set(failover_dev, NETIF_F_GSO_ENCAP_ALL);
+	netdev_active_features_set(failover_dev, failover_dev->hw_features);
 
 	dev_addr_set(failover_dev, standby_dev->dev_addr);
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 323e4158cf4a..3700b3b6141a 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -347,7 +347,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	 * enabled.
 	 */
 	if (q->flags & IFF_VNET_HDR)
-		features |= tap->tap_features;
+		netdev_features_set(&features, tap->tap_features);
 	if (netif_needs_gso(skb, features)) {
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index e9b51c600b35..2aaf3a8789f3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1024,8 +1024,9 @@ static void __team_compute_features(struct team *team)
 	rcu_read_unlock();
 
 	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
-	team->dev->hw_enc_features |= netdev_tx_vlan_features;
+	team->dev->hw_enc_features = netdev_features_or(enc_features,
+							NETIF_F_GSO_ENCAP_ALL);
+	netdev_hw_enc_features_set(team->dev, netdev_tx_vlan_features);
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2017,7 +2018,7 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 
 	mask = features;
 	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
@@ -2188,9 +2189,9 @@ static void team_setup(struct net_device *dev)
 	netdev_hw_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_hw_feature_add(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
-	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-	dev->features |= dev->hw_features;
-	dev->features |= netdev_tx_vlan_features;
+	netdev_hw_features_set(dev, NETIF_F_GSO_ENCAP_ALL);
+	netdev_active_features_set(dev, dev->hw_features);
+	netdev_active_features_set(dev, netdev_tx_vlan_features);
 }
 
 static int team_newlink(struct net *src_net, struct net_device *dev,
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e7950125d628..4f067242d634 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1179,7 +1179,7 @@ static netdev_features_t tun_net_fix_features(struct net_device *dev,
 
 	tmp1 = features & tun->set_features;
 	tmp2 = features & ~TUN_USER_FEATURES;
-	return tmp1 | tmp2;
+	return netdev_features_or(tmp1, tmp2);
 }
 
 static void tun_set_headroom(struct net_device *dev, int new_hr)
@@ -2895,7 +2895,7 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 
 	tun->set_features = features;
 	tun->dev->wanted_features &= ~TUN_USER_FEATURES;
-	tun->dev->wanted_features |= features;
+	netdev_wanted_features_set(tun->dev, features);
 	netdev_update_features(tun->dev);
 
 	return 0;
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 67c4bce50df2..3d5f0241f2bc 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1301,7 +1301,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	netdev_active_features_set_array(dev->net, &ax88179_feature_set);
 
-	dev->net->hw_features |= dev->net->features;
+	netdev_hw_features_set(dev->net, dev->net->features);
 
 	netif_set_tso_max_size(dev->net, 16384);
 
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 0370e1fc3365..3a413073eb66 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1479,7 +1479,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= netdev_ip_csum_features;
+		netdev_active_features_set(dev->net, netdev_ip_csum_features);
 
 	if (DEFAULT_RX_CSUM_ENABLE)
 		netdev_active_feature_add(dev->net, NETIF_F_RXCSUM_BIT);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 7fcecff337a5..fe9bc2f94672 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1575,7 +1575,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 				veth_disable_xdp(dev);
 
 			if (peer) {
-				peer->hw_features |= NETIF_F_GSO_SOFTWARE;
+				netdev_hw_features_set(peer,
+						       NETIF_F_GSO_SOFTWARE);
 				peer->max_mtu = ETH_MAX_MTU;
 			}
 		}
@@ -1648,10 +1649,11 @@ static void veth_setup(struct net_device *dev)
 
 	dev->netdev_ops = &veth_netdev_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
-	veth_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	veth_features = netdev_features_or(NETIF_F_GSO_SOFTWARE,
+					   NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_array(&veth_feature_set, &veth_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->features |= veth_features;
+	netdev_active_features_set(dev, veth_features);
 	dev->vlan_features = dev->features & ~netdev_vlan_offload_features;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = veth_dev_free;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d10c1a8782cc..d3eb1f5570d3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3521,7 +3521,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
-			dev->hw_features |= netdev_general_tso_features;
+			netdev_hw_features_set(dev,
+					       netdev_general_tso_features);
 			netdev_hw_feature_add(dev, NETIF_F_TSO_ECN_BIT);
 		}
 		/* Individual feature bits: what can host handle? */
@@ -3537,7 +3538,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		if (gso) {
 			netdev_features_t tmp = dev->hw_features & NETIF_F_ALL_TSO;
 
-			dev->features |= tmp;
+			netdev_active_features_set(dev, tmp);
 		}
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 98ae263639fc..a257ba4202e6 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1696,7 +1696,7 @@ static void vrf_setup(struct net_device *dev)
 	netdev_active_feature_add(dev, NETIF_F_VLAN_CHALLENGED_BIT);
 
 	/* enable offload features */
-	dev->features   |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_active_features_set_array(dev, &vrf_offload_feature_set);
 
 	dev->hw_features = dev->features;
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 0076b12b6bae..728684964be0 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3179,11 +3179,11 @@ static void vxlan_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &vxlan_type);
 
 	netdev_active_features_set_array(dev, &vxlan_feature_set);
-	dev->features   |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 
 	dev->vlan_features = dev->features;
 	netdev_hw_features_set_array(dev, &vxlan_hw_feature_set);
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netif_keep_dst(dev);
 	dev->priv_flags |= IFF_NO_QUEUE | IFF_CHANGE_PROTO_DOWN;
 
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 3c127313fb05..ae084d85a065 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -298,9 +298,9 @@ static void wg_setup(struct net_device *dev)
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	wg_netdev_features = NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&wg_feature_set, &wg_netdev_features);
-	dev->features |= wg_netdev_features;
-	dev->hw_features |= wg_netdev_features;
-	dev->hw_enc_features |= wg_netdev_features;
+	netdev_active_features_set(dev, wg_netdev_features);
+	netdev_hw_features_set(dev, wg_netdev_features);
+	netdev_hw_enc_features_set(dev, wg_netdev_features);
 	dev->mtu = ETH_DATA_LEN - overhead;
 	dev->max_mtu = round_down(INT_MAX, MESSAGE_PADDING_MULTIPLE) - overhead;
 
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index c2012c4e0084..bc08d4eb5b30 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -347,7 +347,7 @@ wil_vif_alloc(struct wil6210_priv *wil, const char *name,
 	netdev_hw_features_zero(ndev);
 	netdev_hw_features_set_array(ndev, &wil_hw_feature_set);
 
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 	return vif;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 0c94d7bf80f6..ee66440cbb22 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -615,7 +615,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	}
 
-	hw->netdev_features |= *mvm->cfg->features;
+	netdev_features_set(&hw->netdev_features, *mvm->cfg->features);
 	if (!iwl_mvm_is_csum_supported(mvm))
 		hw->netdev_features &= ~IWL_CSUM_NETIF_FLAGS_MASK;
 
@@ -1416,7 +1416,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	mvmvif->features |= hw->netdev_features;
+	netdev_features_set(&mvmvif->features, hw->netdev_features);
 
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index d4833794cec0..1b089e6ef929 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1750,7 +1750,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
          * xennet_connect() which is the earliest point where we can
          * negotiate with the backend regarding supported features.
          */
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	netdev->ethtool_ops = &xennet_ethtool_ops;
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 1975d01b6cad..0d3d0ffdb46b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6945,7 +6945,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 		netdev_features_t restricted = netdev_empty_features;
 
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
-			restricted |= NETIF_F_ALL_TSO;
+			netdev_features_set(&restricted, NETIF_F_ALL_TSO);
 
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 0f342a6d3070..daa1b6f2b47e 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1909,7 +1909,8 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		return -ENODEV;
 
 	card->dev->needed_headroom = headroom;
-	card->dev->features |= netdev_ctag_vlan_offload_features;
+	netdev_active_features_set(card->dev,
+				   netdev_ctag_vlan_offload_features);
 
 	netif_keep_dst(card->dev);
 	if (card->dev->hw_features & netdev_general_tso_features)
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index 772401f25a81..e529e1cbde51 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -690,9 +690,9 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 {
 	if ((f1 & NETIF_F_HW_CSUM) != (f2 & NETIF_F_HW_CSUM)) {
 		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= netdev_ip_csum_features;
+			netdev_features_set(&f1, netdev_ip_csum_features);
 		else
-			f2 |= netdev_ip_csum_features;
+			netdev_features_set(&f2, netdev_ip_csum_features);
 	}
 
 	return f1 & f2;
@@ -704,7 +704,7 @@ netdev_get_wanted_features(struct net_device *dev)
 	netdev_features_t tmp;
 
 	tmp = dev->features & ~dev->hw_features;
-	return dev->wanted_features | tmp;
+	return netdev_wanted_features_or(dev, tmp);
 }
 
 #endif
diff --git a/include/net/udp.h b/include/net/udp.h
index f901e40bd470..7ef2157be238 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -467,7 +467,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	 * asks for the final checksum values
 	 */
 	if (!inet_get_convert_csum(sk))
-		features |= netdev_ip_csum_features;
+		netdev_features_set(&features, netdev_ip_csum_features);
 
 	/* UDP segmentation expects packets of type CHECKSUM_PARTIAL or
 	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 4c11028ce4f8..42eab811f8a1 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -108,8 +108,8 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 {
 	netdev_features_t ret;
 
-	ret = NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE;
-	ret |= NETIF_F_GSO_ENCAP_ALL;
+	ret = netdev_features_or(NETIF_F_CSUM_MASK, NETIF_F_GSO_SOFTWARE);
+	netdev_features_set(&ret, NETIF_F_GSO_ENCAP_ALL);
 	ret &= real_dev->hw_enc_features;
 
 	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK)) {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 6df3fd365714..24c812234a79 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -574,11 +574,12 @@ static int vlan_dev_init(struct net_device *dev)
 	if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 		dev->state |= (1 << __LINK_STATE_NOCARRIER);
 
-	dev->hw_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
-	dev->hw_features |= NETIF_F_ALL_FCOE;
+	dev->hw_features = netdev_features_or(NETIF_F_GSO_SOFTWARE,
+					      NETIF_F_GSO_ENCAP_ALL);
+	netdev_hw_features_set(dev, NETIF_F_ALL_FCOE);
 	netdev_hw_features_set_array(dev, &vlan_hw_feature_set);
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
@@ -665,9 +666,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	if (lower_features & netdev_ip_csum_features)
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &lower_features);
 	features = netdev_intersect_features(features, lower_features);
-	tmp = NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE;
+	tmp = netdev_features_or(NETIF_F_SOFT_FEATURES, NETIF_F_GSO_SOFTWARE);
 	tmp &= old_features;
-	features |= tmp;
+	netdev_features_set(&features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
 	return features;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 1d5e13e2acb8..f9e510bb4bbc 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -507,7 +507,8 @@ void br_dev_setup(struct net_device *dev)
 	netdev_features_set_array(&br_common_feature_set, &common_features);
 	dev->features = common_features;
 	netdev_active_features_set_array(dev, &br_feature_set);
-	dev->hw_features = common_features | netdev_tx_vlan_features;
+	dev->hw_features = netdev_features_or(common_features,
+					      netdev_tx_vlan_features);
 	dev->vlan_features = common_features;
 
 	br->dev = dev;
diff --git a/net/core/dev.c b/net/core/dev.c
index e374eb18c716..6589b3c7c70c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3400,7 +3400,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 
 		partial_features = dev->features & dev->gso_partial_features;
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &partial_features);
-		if (!skb_gso_ok(skb, features | partial_features))
+		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
 
@@ -3565,7 +3565,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		features &= dev->hw_enc_features;
 
 	if (skb_vlan_tagged(skb)) {
-		tmp = dev->vlan_features | netdev_tx_vlan_features;
+		tmp = netdev_vlan_features_or(dev, netdev_tx_vlan_features);
 		features = netdev_intersect_features(features, tmp);
 	}
 
@@ -10027,9 +10027,9 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= NETIF_F_SOFT_FEATURES;
-	dev->hw_features |= NETIF_F_SOFT_FEATURES_OFF;
-	dev->features |= NETIF_F_SOFT_FEATURES;
+	netdev_hw_features_set(dev, NETIF_F_SOFT_FEATURES);
+	netdev_hw_features_set(dev, NETIF_F_SOFT_FEATURES_OFF);
+	netdev_active_features_set(dev, NETIF_F_SOFT_FEATURES);
 
 	if (dev->udp_tunnel_nic_info) {
 		netdev_active_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
@@ -11154,17 +11154,17 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t tmp;
 
 	if (mask & NETIF_F_HW_CSUM)
-		mask |= NETIF_F_CSUM_MASK;
+		netdev_features_set(&mask, NETIF_F_CSUM_MASK);
 	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
-	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
+	tmp = netdev_features_or(NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
 	tmp &= one;
 	tmp &= mask;
-	all |= tmp;
+	netdev_features_set(&all, tmp);
 
 	netdev_features_fill(&tmp);
 	tmp &= ~NETIF_F_ALL_FOR_ALL;
-	tmp |= one;
+	netdev_features_set(&tmp, one);
 	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
diff --git a/net/core/sock.c b/net/core/sock.c
index c71c43882785..456ce67fbb08 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2320,7 +2320,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	if (sk_is_tcp(sk))
 		netdev_feature_add(NETIF_F_GSO_BIT, &sk->sk_route_caps);
 	if (sk->sk_route_caps & NETIF_F_GSO)
-		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
+		netdev_features_set(&sk->sk_route_caps, NETIF_F_GSO_SOFTWARE);
 	if (unlikely(sk->sk_gso_disabled))
 		sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 	if (sk_can_gso(sk)) {
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3e5116f6d56a..f99fcbb224d4 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -294,7 +294,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (edata.data)
-		dev->wanted_features |= mask;
+		netdev_wanted_features_set(dev, mask);
 	else
 		dev->wanted_features &= ~mask;
 
@@ -356,7 +356,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	netdev_features_set_array(&ethtool_all_feature_set, &eth_all_features);
 
 	/* allow changing only bits set in hw_features */
-	changed = dev->features ^ features;
+	changed = netdev_active_features_xor(dev, features);
 	changed &= eth_all_features;
 	tmp = changed & ~dev->hw_features;
 	if (tmp)
@@ -364,7 +364,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	dev->wanted_features &= ~changed;
 	tmp = features & changed;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_set(dev, tmp);
 
 	__netdev_update_features(dev);
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index fbdf3713245f..04586ad67183 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -776,8 +776,8 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 		dev->features &= ~NETIF_F_GSO_SOFTWARE;
 		dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
 	} else {
-		dev->features |= NETIF_F_GSO_SOFTWARE;
-		dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+		netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
+		netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	}
 }
 
@@ -975,8 +975,8 @@ static void __gre_tunnel_init(struct net_device *dev)
 	if (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		return;
 
-	dev->features |= NETIF_F_GSO_SOFTWARE;
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 }
 
 static int ipgre_tunnel_init(struct net_device *dev)
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index e1988286c523..e2ad4be46c90 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -376,8 +376,8 @@ static void ipip_tunnel_setup(struct net_device *dev)
 
 	ipip_features		= NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&ipip_feature_set, &ipip_features);
-	dev->features		|= ipip_features;
-	dev->hw_features	|= ipip_features;
+	netdev_active_features_set(dev, ipip_features);
+	netdev_hw_features_set(dev, ipip_features);
 	ip_tunnel_setup(dev, ipip_net_id);
 }
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 1a322cd002cb..79393bd9c5b0 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1490,8 +1490,8 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 	if (flags & TUNNEL_CSUM && nt->encap.type != TUNNEL_ENCAP_NONE)
 		return;
 
-	dev->features |= NETIF_F_GSO_SOFTWARE;
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 }
 
 static int ip6gre_tunnel_init_common(struct net_device *dev)
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2922f0f66634..1239dcef22c5 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1845,8 +1845,8 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 
 	ipxipx_features = NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&ipxipx_feature_set, &ipxipx_features);
-	dev->features		|= ipxipx_features;
-	dev->hw_features	|= ipxipx_features;
+	netdev_active_features_set(dev, ipxipx_features);
+	netdev_hw_features_set(dev, ipxipx_features);
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 69d10ab34e1c..9f65f6cf0cd3 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1435,8 +1435,8 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	sit_features = NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&sit_feature_set, &sit_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->features		|= sit_features;
-	dev->hw_features	|= sit_features;
+	netdev_active_features_set(dev, sit_features);
+	netdev_hw_features_set(dev, sit_features);
 }
 
 static int ipip6_tunnel_init(struct net_device *dev)
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bd0c2073828c..d3dc0628cac3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2397,9 +2397,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		if (type == NL80211_IFTYPE_STATION)
 			sdata->u.mgd.use_4addr = params->use_4addr;
 
-		ndev->features |= local->hw.netdev_features;
+		netdev_active_features_set(ndev, local->hw.netdev_features);
 		tmp = ndev->features & MAC80211_SUPPORTED_FEATURES_TX;
-		ndev->hw_features |= tmp;
+		netdev_hw_features_set(ndev, tmp);
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 00d8f3bce563..7a3d98473a0a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1546,7 +1546,8 @@ static void __init ieee80211_features_init(void)
 				  &mac80211_tx_features);
 	netdev_features_set_array(&mac80211_rx_feature_set,
 				  &mac80211_rx_features);
-	mac80211_supported_features = mac80211_tx_features | mac80211_rx_features;
+	mac80211_supported_features = netdev_features_or(mac80211_tx_features,
+							 mac80211_rx_features);
 }
 
 static int __init ieee80211_init(void)
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 888ffcb2e1ca..4baf9c563c87 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -116,12 +116,13 @@ static void do_setup(struct net_device *netdev)
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
 	netdev->rtnl_link_ops = &internal_dev_link_ops;
 
-	netdev->features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev->features = netdev_features_or(NETIF_F_GSO_SOFTWARE,
+					      NETIF_F_GSO_ENCAP_ALL);
 	netdev_active_features_set_array(netdev, &ovs_feature_set);
 
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
-	netdev->features |= netdev_tx_vlan_features;
+	netdev_active_features_set(netdev, netdev_tx_vlan_features);
 	netdev->hw_features = netdev->features;
 	netdev->hw_features &= ~NETIF_F_LLTX;
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 06b94053097e..c492b2952d6a 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -156,7 +157,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	if (!skb->next) {
-		esp_features |= skb->dev->gso_partial_features;
+		netdev_features_set(&esp_features, skb->dev->gso_partial_features);
 		xfrm_outer_mode_prep(x, skb);
 
 		xo->flags |= XFRM_DEV_RESUME;
@@ -177,7 +178,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	skb_list_walk_safe(skb, skb2, nskb) {
-		esp_features |= skb->dev->gso_partial_features;
+		netdev_features_set(&esp_features, skb->dev->gso_partial_features);
 		skb_mark_not_on_list(skb2);
 
 		xo = xfrm_offload(skb2);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 41a05e6d2ef0..3d3d62301078 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -598,8 +598,8 @@ static int xfrmi_dev_init(struct net_device *dev)
 	xfrmi_features = NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&xfrmi_feature_set, &xfrmi_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->features |= xfrmi_features;
-	dev->hw_features |= xfrmi_features;
+	netdev_active_features_set(dev, xfrmi_features);
+	netdev_hw_features_set(dev, xfrmi_features);
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.33.0

