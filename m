Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E9E5BBD05
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiIRJug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiIRJuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218C712AEA
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjbw22pqz14QXK;
        Sun, 18 Sep 2022 17:45:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:50 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 25/55] treewide: use netdev_features_or/set helpers
Date:   Sun, 18 Sep 2022 09:43:06 +0000
Message-ID: <20220918094336.28958-26-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the "f1 = f2 | f2" features expressions with
netdev_features_or helpers, and replace the "f1 |= f2"
features expressions with netdev_featues_set helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  2 +-
 drivers/net/amt.c                             |  4 +--
 drivers/net/bareudp.c                         |  4 +--
 drivers/net/bonding/bond_main.c               | 23 ++++++++-------
 drivers/net/bonding/bond_options.c            |  4 +--
 drivers/net/dummy.c                           |  8 ++---
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
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  4 +--
 drivers/net/ethernet/broadcom/tg3.c           |  8 ++---
 drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  3 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  3 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  3 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  4 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  8 ++---
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/davicom/dm9000.c         |  2 +-
 drivers/net/ethernet/dnet.c                   |  3 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/ethoc.c                  |  3 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  8 ++---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  4 +--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  8 ++---
 drivers/net/ethernet/ibm/emac/core.c          |  2 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  6 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  5 ++--
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  3 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  6 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 15 +++++-----
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 24 ++++++++-------
 drivers/net/ethernet/intel/ice/ice_main.c     | 29 ++++++++++---------
 drivers/net/ethernet/intel/igb/igb_main.c     | 10 +++----
 drivers/net/ethernet/intel/igbvf/netdev.c     |  8 ++---
 drivers/net/ethernet/intel/igc/igc_main.c     |  8 ++---
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
 .../ethernet/microchip/lan966x/lan966x_main.c |  2 +-
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
 drivers/net/ethernet/sfc/ef100_netdev.c       |  8 ++---
 drivers/net/ethernet/sfc/ef100_nic.c          |  6 ++--
 drivers/net/ethernet/sfc/efx.c                |  8 ++---
 drivers/net/ethernet/sfc/efx_common.c         |  4 +--
 drivers/net/ethernet/sfc/falcon/efx.c         |  8 ++---
 drivers/net/ethernet/sfc/falcon/net_driver.h  |  5 +++-
 drivers/net/ethernet/sfc/net_driver.h         |  5 +++-
 drivers/net/ethernet/sfc/siena/efx.c          |  8 ++---
 drivers/net/ethernet/sfc/siena/efx_common.c   |  4 +--
 drivers/net/ethernet/sfc/siena/net_driver.h   |  5 +++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 ++---
 drivers/net/ethernet/sun/niu.c                |  2 +-
 drivers/net/ethernet/sun/sunhme.c             |  4 +--
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  6 ++--
 drivers/net/ethernet/via/via-rhine.c          |  2 +-
 drivers/net/geneve.c                          |  4 +--
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/ifb.c                             | 11 +++----
 drivers/net/ipvlan/ipvlan_main.c              | 17 ++++++-----
 drivers/net/macsec.c                          |  7 +++--
 drivers/net/macvlan.c                         | 17 ++++++-----
 drivers/net/net_failover.c                    | 10 +++----
 drivers/net/tap.c                             |  2 +-
 drivers/net/team/team.c                       | 13 +++++----
 drivers/net/tun.c                             |  2 +-
 drivers/net/usb/ax88179_178a.c                |  2 +-
 drivers/net/usb/smsc75xx.c                    |  2 +-
 drivers/net/veth.c                            |  8 +++--
 drivers/net/virtio_net.c                      |  5 ++--
 drivers/net/vrf.c                             |  2 +-
 drivers/net/vxlan/vxlan_core.c                |  4 +--
 drivers/net/wireguard/device.c                |  6 ++--
 drivers/net/wireless/ath/wil6210/netdev.c     |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +--
 drivers/net/xen-netfront.c                    |  2 +-
 drivers/s390/net/qeth_core_main.c             |  2 +-
 drivers/s390/net/qeth_l3_main.c               |  3 +-
 include/linux/netdev_feature_helpers.h        |  7 +++--
 include/net/udp.h                             |  2 +-
 net/8021q/vlan.h                              |  4 +--
 net/8021q/vlan_dev.c                          | 10 +++----
 net/bridge/br_device.c                        |  2 +-
 net/core/dev.c                                | 19 ++++++------
 net/core/sock.c                               |  2 +-
 net/ethtool/common.h                          |  1 +
 net/ethtool/features.c                        |  2 +-
 net/ethtool/ioctl.c                           |  6 ++--
 net/ipv4/ip_gre.c                             |  8 ++---
 net/ipv4/ipip.c                               |  4 +--
 net/ipv6/ip6_gre.c                            |  4 +--
 net/ipv6/ip6_tunnel.c                         |  4 +--
 net/ipv6/sit.c                                |  4 +--
 net/mac80211/iface.c                          |  4 +--
 net/mac80211/main.c                           |  3 +-
 net/openvswitch/vport-internal_dev.c          |  5 ++--
 net/xfrm/xfrm_device.c                        |  6 ++--
 net/xfrm/xfrm_interface.c                     |  4 +--
 139 files changed, 385 insertions(+), 339 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 11be19e299a3..de878f4f7963 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1862,7 +1862,7 @@ static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 		if (priv->kernel_caps & IBK_UD_TSO)
 			netdev_hw_feature_add(priv->dev, NETIF_F_TSO_BIT);
 
-		priv->dev->features |= priv->dev->hw_features;
+		netdev_active_features_set(priv->dev, priv->dev->hw_features);
 	}
 }
 
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f3cd014f93d0..30a2aa83a4b0 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3106,10 +3106,10 @@ static void amt_link_setup(struct net_device *dev)
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
 	dev->priv_flags		|= IFF_NO_QUEUE;
-	dev->features		|= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_active_features_set_set(dev, NETIF_F_LLTX_BIT,
 				       NETIF_F_NETNS_LOCAL_BIT);
-	dev->hw_features	|= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
 	eth_hw_addr_random(dev);
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index c71190b54118..3b91d4256f76 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -546,10 +546,10 @@ static void bareudp_setup(struct net_device *dev)
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_FRAGLIST_BIT,
 				       NETIF_F_LLTX_BIT);
-	dev->features    |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
 	dev->mtu = ETH_DATA_LEN;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c769e401bc9d..0756d00f09e5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1406,7 +1406,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		features |= BOND_TLS_FEATURES;
+		netdev_features_set(features, BOND_TLS_FEATURES);
 	else
 		features &= ~BOND_TLS_FEATURES;
 #endif
@@ -1414,7 +1414,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	mask = features;
 
 	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
 		features = netdev_increment_features(features,
@@ -1483,10 +1483,11 @@ static void bond_compute_features(struct bonding *bond)
 
 done:
 	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
-	bond_dev->hw_enc_features |= netdev_tx_vlan_features;
+	netdev_hw_enc_features_or(bond_dev, enc_features,
+				  NETIF_F_GSO_ENCAP_ALL);
+	netdev_hw_enc_features_set(bond_dev, netdev_tx_vlan_features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	bond_dev->hw_enc_features |= xfrm_features;
+	netdev_hw_enc_features_set(bond_dev, xfrm_features);
 #endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->mpls_features = mpls_features;
 	netif_set_tso_max_segs(bond_dev, tso_max_segs);
@@ -5775,18 +5776,18 @@ void bond_setup(struct net_device *bond_dev)
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
index 3498db1c1b3c..31fa1a65231d 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -835,7 +835,7 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 		return false;
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
-		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
+		netdev_wanted_features_set(bond->dev, BOND_XFRM_FEATURES);
 	else
 		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
 
@@ -848,7 +848,7 @@ static bool bond_set_tls_features(struct bonding *bond)
 		return false;
 
 	if (bond_sk_check(bond))
-		bond->dev->wanted_features |= BOND_TLS_FEATURES;
+		netdev_wanted_features_set(bond->dev, BOND_TLS_FEATURES);
 	else
 		bond->dev->wanted_features &= ~BOND_TLS_FEATURES;
 
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index 8bee9d473b78..801925bd0cd4 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -127,10 +127,10 @@ static void dummy_setup(struct net_device *dev)
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
 				       NETIF_F_FRAGLIST_BIT, NETIF_F_HW_CSUM_BIT,
 				       NETIF_F_HIGHDMA_BIT, NETIF_F_LLTX_BIT);
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
index 8c0d2c0c2265..65ec23d1763e 100644
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
index 5bd9744abed7..b5598ce80465 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1357,7 +1357,7 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 * so it is turned off
 	 */
 	ndev->hw_features &= ~NETIF_F_SG;
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 
 	/* VLAN offloading of tagging, stripping and filtering is not
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a0ddc4b694af..50470e55cbe5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4048,8 +4048,8 @@ static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 	netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
 				       NETIF_F_RXHASH_BIT, NETIF_F_HIGHDMA_BIT);
 
-	netdev->hw_features |= netdev->features;
-	netdev->vlan_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
+	netdev_vlan_features_set(netdev, netdev->features);
 }
 
 static void ena_set_conf_feat_params(struct ena_adapter *adapter,
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index a481936e80fa..38beb91beb85 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -63,6 +63,7 @@ Revision History:
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
index e2b841080e13..1c66e9a7bb5e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2202,7 +2202,7 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	if ((features & vxlan_base) != vxlan_base) {
 		netdev_notice(netdev,
 			      "forcing both tx and rx udp tunnel support\n");
-		features |= vxlan_base;
+		netdev_features_set(features, vxlan_base);
 	}
 
 	if (features & netdev_ip_csum_features) {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index 0ee584af4971..79a4a8c1471e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -376,7 +376,7 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 				     NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
 				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	pdata->netdev_features = netdev->features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index fad7c338c0f5..963aa9359257 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -372,7 +372,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	const struct aq_hw_caps_s *aq_hw_caps = self->aq_nic_cfg.aq_hw_caps;
 	struct aq_nic_cfg_s *aq_nic_cfg = &self->aq_nic_cfg;
 
-	self->ndev->hw_features |= *aq_hw_caps->hw_features;
+	netdev_hw_features_set(self->ndev, *aq_hw_caps->hw_features);
 	self->ndev->features = *aq_hw_caps->hw_features;
 	netdev_vlan_features_set_set(self->ndev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT,
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 9996030a2e5d..ee4428ef59fb 100644
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
index e674272efb37..cbbb0ac2e1f3 100644
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
index 153ff772b4d6..78d562d80022 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -18,6 +18,7 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
index e7b2840a3db9..784f46970f8b 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2575,8 +2575,8 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 				       NETIF_F_HIGHDMA_BIT, NETIF_F_IP_CSUM_BIT,
 				       NETIF_F_IPV6_CSUM_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT);
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_hw_features_set(dev, dev->features);
+	netdev_vlan_features_set(dev, dev->features);
 	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
 	/* Request the WOL interrupt and advertise suspend if available */
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index be0798756045..3655af27b665 100644
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
@@ -8595,8 +8595,8 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					   NETIF_F_TSO6_BIT);
 
 	dev->vlan_features = dev->hw_features;
-	dev->hw_features |= netdev_ctag_vlan_offload_features;
-	dev->features |= dev->hw_features;
+	netdev_hw_features_set(dev, netdev_ctag_vlan_offload_features);
+	netdev_active_features_set(dev, dev->hw_features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->min_mtu = MIN_ETHERNET_PACKET_SIZE;
 	dev->max_mtu = MAX_ETHERNET_JUMBO_PACKET_SIZE;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 5d0a9cbd48ac..19a164e96a2b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13255,7 +13255,7 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 	 * getting a response to CHANNEL_TLV_ACQUIRE from PF.
 	 */
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (dev->features & NETIF_F_LRO)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 524640db4e92..6cb58b0c21aa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11197,7 +11197,8 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 			features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
 		else if (vlan_features)
-			features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
+			netdev_features_set(features,
+					    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	}
 #ifdef CONFIG_BNXT_SRIOV
 	if (BNXT_VF(bp) && bp->vf.vlan)
@@ -13628,12 +13629,12 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
index fcc65890820a..beba73d73f3f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -472,7 +472,7 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	dev->gso_partial_features = pf_dev->gso_partial_features;
 	dev->vlan_features = pf_dev->vlan_features;
 	dev->hw_enc_features = pf_dev->hw_enc_features;
-	dev->features |= pf_dev->features;
+	netdev_active_features_set(dev, pf_dev->features);
 	bnxt_vf_rep_eth_addr_gen(bp->pf.mac_addr, vf_rep->vf_idx,
 				 dev->perm_addr);
 	eth_hw_addr_set(dev, dev->perm_addr);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 4912fe1a027d..d72dca1bbaf6 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4028,8 +4028,8 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	/* Set default features */
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				       NETIF_F_HW_CSUM_BIT, NETIF_F_RXCSUM_BIT);
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_hw_features_set(dev, dev->features);
+	netdev_vlan_features_set(dev, dev->features);
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 8f18ddb0b6ad..5e1ede8bd049 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17758,9 +17758,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 			netdev_feature_add(NETIF_F_TSO_ECN_BIT, features);
 	}
 
-	dev->features |= features;
-	dev->features |= netdev_ctag_vlan_offload_features;
-	dev->vlan_features |= features;
+	netdev_active_features_set(dev, features);
+	netdev_active_features_set(dev, netdev_ctag_vlan_offload_features);
+	netdev_vlan_features_set(dev, features);
 
 	/*
 	 * Add loopback capability only for a subset of devices that support
@@ -17772,7 +17772,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 		/* Add the loopback capability */
 		netdev_feature_add(NETIF_F_LOOPBACK_BIT, features);
 
-	dev->hw_features |= features;
+	netdev_hw_features_set(dev, features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 60 - 9000 or 1500, depending on hardware */
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index ae3f2656c268..ca543079316a 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3435,7 +3435,7 @@ bnad_netdev_init(struct bnad *bnad)
 				     NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
 				     NETIF_F_TSO6_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_features_set_set(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       NETIF_F_HIGHDMA_BIT);
 
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 8d379803e2fb..531686bf9426 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1781,7 +1781,7 @@ static int xgmac_probe(struct platform_device *pdev)
 		netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_IPV6_CSUM_BIT,
 					   NETIF_F_RXCSUM_BIT);
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 46 - 9000 */
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 3ce097733695..41de76874bfb 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3592,7 +3592,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |= netdev_ctag_vlan_features;
+		netdev_features_set(lio->dev_capability,
+				    netdev_ctag_vlan_features);
 
 		netdev->features = lio->dev_capability;
 		netdev->features &= ~NETIF_F_LRO;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index ed0ae09f9b04..dc847580d4c7 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2118,7 +2118,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |= netdev_ctag_vlan_features;
+		netdev_features_set(lio->dev_capability,
+				    netdev_ctag_vlan_features);
 
 		netdev->features = lio->dev_capability;
 		netdev->features &= ~NETIF_F_LRO;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index c2b1db842af2..7818d35545d2 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2213,7 +2213,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_hw_feature_add(netdev, NETIF_F_LOOPBACK_BIT);
 
 	netdev_vlan_features_zero(netdev);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index f1e69dbe2b73..b326156e3605 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1042,7 +1042,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					       NETIF_F_HIGHDMA_BIT);
 
 		if (vlan_tso_capable(adapter)) {
-			netdev->features |= netdev_ctag_vlan_offload_features;
+			netdev_active_features_set(netdev,
+						   netdev_ctag_vlan_offload_features);
 			netdev_hw_feature_add(netdev,
 					      NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index d2048a131987..04dcb4c3c043 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3310,7 +3310,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					   NETIF_F_TSO_ECN_BIT,
 					   NETIF_F_IPV6_CSUM_BIT,
 					   NETIF_F_HIGHDMA_BIT);
-		netdev->features |= netdev->hw_features;
+		netdev_active_features_set(netdev, netdev->hw_features);
 		netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 		netdev_features_zero(vlan_feat);
 		netdev_features_set_set(vlan_feat, NETIF_F_SG_BIT,
@@ -3318,7 +3318,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					NETIF_F_RXCSUM_BIT,
 					NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		vlan_feat &= netdev->features;
-		netdev->vlan_features |= vlan_feat;
+		netdev_vlan_features_set(netdev, vlan_feat);
 
 		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index ebbb41ccd278..3a610e650db9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6845,7 +6845,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
 		}
 
-		netdev->features |= netdev->hw_features;
+		netdev_active_features_set(netdev, netdev->hw_features);
 		vlan_features = tso_features;
 		netdev_features_set_set(vlan_features, NETIF_F_SG_BIT,
 					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index a2bd70f6cae0..d9c2b84d7231 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2885,7 +2885,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->watchdog_timeo = 2 * HZ;
 	enic_set_ethtool_ops(netdev);
 
-	netdev->features |= netdev_ctag_vlan_offload_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_offload_features);
 	if (ENIC_SETTING(enic, LOOP)) {
 		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 		enic->loop_enable = 1;
@@ -2914,7 +2914,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					       NETIF_F_GSO_UDP_TUNNEL_BIT,
 					       NETIF_F_HW_CSUM_BIT,
 					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-		netdev->hw_features |= netdev->hw_enc_features;
+		netdev_hw_features_set(netdev, netdev->hw_enc_features);
 		/* get bit mask from hw about supported offload bit level
 		 * BIT(0) = fw supports patch_level 0
 		 *	    fcoe bit = encap
@@ -2947,8 +2947,8 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev->features |= netdev->hw_features;
-	netdev->vlan_features |= netdev->features;
+	netdev_active_features_set(netdev, netdev->hw_features);
+	netdev_vlan_features_set(netdev, netdev->features);
 
 #ifdef CONFIG_RFS_ACCEL
 	netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index d8a0cc9ed5d3..2bd0892f5f53 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2463,7 +2463,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	gmac_clear_hw_stats(netdev);
 
 	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
-	netdev->features |= GMAC_OFFLOAD_FEATURES;
+	netdev_active_features_set(netdev, GMAC_OFFLOAD_FEATURES);
 	netdev_active_feature_add(netdev, NETIF_F_GRO_BIT);
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
 	 * payloads of 10236 bytes minus VLAN and ethernet header
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 6e274878b962..f16bb16bf892 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1648,7 +1648,7 @@ dm9000_probe(struct platform_device *pdev)
 		netdev_hw_features_zero(ndev);
 		netdev_hw_features_set_set(ndev, NETIF_F_RXCSUM_BIT,
 					   NETIF_F_IP_CSUM_BIT);
-		ndev->features |= ndev->hw_features;
+		netdev_active_features_set(ndev, ndev->hw_features);
 	}
 
 	/* from this point we assume that we have found a DM9000 */
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 17143e07c875..7dcf42dd6e61 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
index 7848b7d31b2a..e41adc6136c2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5196,7 +5196,7 @@ static void be_netdev_init(struct net_device *netdev)
 	if ((be_if_cap_flags(adapter) & BE_IF_FLAGS_RSS))
 		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_features_set_set(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT,
 				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       NETIF_F_HIGHDMA_BIT);
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 3ced63aaa6cb..64d94cc8d263 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/mii.h>
+#include <linux/netdev_feature_helpers.h>
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
index 30f93d01b4d7..b71e8d37e48e 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1951,7 +1951,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev_hw_features_clear_set(netdev, NETIF_F_HW_CSUM_BIT,
 					     NETIF_F_RXCSUM_BIT);
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	/* register network device */
 	err = register_netdev(netdev);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 9cd1a51fd60c..abfe54500719 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -242,7 +242,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	/* we do not want shared skbs on TX */
 	net_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 
-	net_dev->features |= net_dev->hw_features;
+	netdev_active_features_set(net_dev, net_dev->hw_features);
 	net_dev->vlan_features = net_dev->features;
 
 	if (is_valid_ether_addr(mac_addr)) {
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 846ea4800301..7a4de2bd3418 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3251,7 +3251,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
-		dev->hw_features |= netdev_ctag_vlan_offload_features;
+		netdev_hw_features_set(dev, netdev_ctag_vlan_offload_features);
 		netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index c0426ee6aeed..57734fae1c1e 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1769,7 +1769,7 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	netdev_features_set_set(tso_flags, NETIF_F_TSO_BIT,
 				NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT,
 				NETIF_F_GSO_UDP_L4_BIT);
-	vlan_feat = gso_encap_flags | tso_flags;
+	netdev_features_or(vlan_feat, gso_encap_flags, tso_flags);
 	netdev_features_set_set(vlan_feat, NETIF_F_SG_BIT,
 				NETIF_F_HW_CSUM_BIT,
 				NETIF_F_HIGHDMA_BIT);
@@ -1778,12 +1778,12 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 				   NETIF_F_RXCSUM_BIT);
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
index 5e4b13f3aead..239b1ff2c322 100644
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
index f7796d1301e4..6c4a37fae478 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -2345,7 +2345,7 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 					   NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
 					   NETIF_F_GSO_BIT, NETIF_F_GRO_BIT,
 					   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
-		ndev->vlan_features |= netdev_general_tso_features;
+		netdev_vlan_features_set(ndev, netdev_general_tso_features);
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 		break;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0b35c3d3f6fb..cf2a2e123279 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3337,7 +3337,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev_active_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	else
-		netdev->features |= netdev_ip_csum_features;
+		netdev_active_features_set(netdev, netdev_ip_csum_features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev_active_feature_add(netdev,
@@ -3346,7 +3346,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
 		netdev_active_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
@@ -3359,9 +3359,9 @@ static void hns3_set_default_feature(struct net_device *netdev)
 				NETIF_F_NTUPLE_BIT,
 				NETIF_F_HW_TC_BIT);
 	features = netdev->features & ~vlan_off_features;
-	netdev->vlan_features |= features;
+	netdev_vlan_features_set(netdev, features);
 
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 42bea854c367..3c97e9ae9cb2 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3174,7 +3174,7 @@ static int emac_probe(struct platform_device *ofdev)
 		netdev_hw_features_zero(ndev);
 		netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_SG_BIT);
-		ndev->features |= ndev->hw_features;
+		netdev_active_features_set(ndev, ndev->hw_features);
 		netdev_active_feature_add(ndev, NETIF_F_RXCSUM_BIT);
 	}
 	ndev->watchdog_timeo = 5 * HZ;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 460f31f9b8cb..6155eb06dfe8 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1686,15 +1686,15 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 					   NETIF_F_IPV6_CSUM_BIT,
 					   NETIF_F_RXCSUM_BIT);
 
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
index 0df1835faa9f..e6b46fcf3a57 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4890,7 +4890,8 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		netdev_hw_feature_add(adapter->netdev, NETIF_F_TSO6_BIT);
 
 	if (adapter->state == VNIC_PROBING) {
-		adapter->netdev->features |= adapter->netdev->hw_features;
+		netdev_active_features_set(adapter->netdev,
+					   adapter->netdev->hw_features);
 	} else if (old_hw_features != adapter->netdev->hw_features) {
 		netdev_features_t tmp;
 
@@ -4901,7 +4902,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		tmp = old_hw_features ^ adapter->netdev->hw_features;
 		tmp &= adapter->netdev->hw_features;
 		tmp &= adapter->netdev->wanted_features;
-		adapter->netdev->features |= tmp;
+		netdev_active_features_set(adapter->netdev, tmp);
 	}
 
 	memset(&crq, 0, sizeof(crq));
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 0840cf57aa1a..f1c7f42c59c1 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1052,7 +1052,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_hw_features_set_set(netdev,
 				   NETIF_F_RXCSUM_BIT,
 				   NETIF_F_RXALL_BIT,
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a8e3417c179a..e78b7b99a124 100644
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
index bffb7c0313d0..9346cf8cdf45 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1592,17 +1592,17 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	netdev_feature_add(NETIF_F_HW_L2FW_DOFFLOAD_BIT, hw_features);
 
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
index 64723ab03eaf..a6ad3df2c745 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13664,10 +13664,10 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 
 	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 
-	netdev->hw_enc_features |= hw_enc_features;
+	netdev_hw_enc_features_set(netdev, hw_enc_features);
 
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features;
+	netdev_vlan_features_set(netdev, hw_enc_features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	netdev_features_zero(gso_partial_features);
@@ -13679,25 +13679,26 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	netdev_mpls_features_set_set(netdev, NETIF_F_SG_BIT,
 				     NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
 				     NETIF_F_TSO6_BIT);
-	netdev->mpls_features |= gso_partial_features;
+	netdev_mpls_features_set(netdev, gso_partial_features);
 
 	/* enable macvlan offloads */
 	netdev_hw_feature_add(netdev, NETIF_F_HW_L2FW_DOFFLOAD_BIT);
 
-	hw_features = hw_enc_features | netdev_ctag_vlan_offload_features;
+	netdev_features_or(hw_features, hw_enc_features,
+			   netdev_ctag_vlan_offload_features);
 
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
 		netdev_features_set_set(hw_features, NETIF_F_NTUPLE_BIT,
 					NETIF_F_HW_TC_BIT);
 
-	netdev->hw_features |= hw_features;
+	netdev_hw_features_set(netdev, hw_features);
 
-	netdev->features |= hw_features;
+	netdev_active_features_set(netdev, hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 95acdb5fb492..523e8c9252ab 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4457,7 +4457,8 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 
 	/* Enable VLAN features if supported */
 	if (VLAN_ALLOWED(adapter)) {
-		hw_features |= netdev_ctag_vlan_offload_features;
+		netdev_features_set(hw_features,
+				    netdev_ctag_vlan_offload_features);
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4524,7 +4525,7 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 		return features;
 
 	if (VLAN_ALLOWED(adapter)) {
-		features |= netdev_ctag_vlan_features;
+		netdev_features_set(features, netdev_ctag_vlan_features);
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4630,9 +4631,12 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 			      netdev_features_t requested_features)
 {
 	netdev_features_t allowed_features;
+	netdev_features_t vlan_hw_features;
+	netdev_features_t vlan_features;
 
-	allowed_features = iavf_get_netdev_vlan_hw_features(adapter) |
-		iavf_get_netdev_vlan_features(adapter);
+	vlan_hw_features = iavf_get_netdev_vlan_hw_features(adapter);
+	vlan_features = iavf_get_netdev_vlan_features(adapter);
+	netdev_features_or(allowed_features, vlan_hw_features, vlan_features);
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
@@ -4777,10 +4781,10 @@ int iavf_process_config(struct iavf_adapter *adapter)
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
@@ -4797,12 +4801,12 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
 		netdev_feature_add(NETIF_F_GSO_UDP_L4_BIT, hw_features);
 
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
index ff0c4cecb092..974693a0e067 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3373,9 +3373,9 @@ static void ice_set_netdev_features(struct net_device *netdev)
 					    NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 					    NETIF_F_GSO_GRE_CSUM_BIT);
 	/* set features that user can change */
-	netdev->hw_features = dflt_features | csumo_features;
-	netdev->hw_features |= vlano_features;
-	netdev->hw_features |= tso_features;
+	netdev_hw_features_or(netdev, dflt_features, csumo_features);
+	netdev_hw_features_set(netdev, vlano_features);
+	netdev_hw_features_set(netdev, tso_features);
 
 	/* add support for HW_CSUM on packets with MPLS header */
 	netdev_mpls_features_zero(netdev);
@@ -3385,18 +3385,18 @@ static void ice_set_netdev_features(struct net_device *netdev)
 				     NETIF_F_TSO6_BIT);
 
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
@@ -3404,7 +3404,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * ice_fix_features() ndo callback.
 	 */
 	if (is_dvm_ena)
-		netdev->hw_features |= netdev_stag_vlan_offload_features;
+		netdev_hw_features_set(netdev,
+				       netdev_stag_vlan_offload_features);
 
 	/* Leave CRC / FCS stripping enabled by default, but allow the value to
 	 * be changed at runtime
@@ -5830,12 +5831,14 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	if (req_vlan_fltr != cur_vlan_fltr) {
 		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
 			if (req_ctag && req_stag) {
-				features |= NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_set(features,
+						    NETIF_VLAN_FILTERING_FEATURES);
 			} else if (!req_ctag && !req_stag) {
 				features &= ~NETIF_VLAN_FILTERING_FEATURES;
 			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
 				   (!cur_stag && req_stag && !cur_ctag)) {
-				features |= NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_set(features,
+						    NETIF_VLAN_FILTERING_FEATURES);
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
 			} else if ((cur_ctag && !req_ctag && cur_stag) ||
 				   (cur_stag && !req_stag && cur_ctag)) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ab1c72753033..a31fd2db8263 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3302,10 +3302,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
 	netdev_hw_features_set_set(netdev,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -3316,13 +3316,13 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
index 56d1dee40f51..e09e31a94ae5 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2786,18 +2786,18 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
index 798b932eebb5..e76e095e051b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6365,7 +6365,7 @@ static int igc_probe(struct pci_dev *pdev,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
@@ -6376,14 +6376,14 @@ static int igc_probe(struct pci_dev *pdev,
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
index 53d27e7ba43d..6eac56f0cd69 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10987,7 +10987,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->features |= gso_partial_features;
+	netdev_active_features_set(netdev, gso_partial_features);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
 		netdev_hw_features_set_set(netdev,
@@ -11002,7 +11002,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					       NETIF_F_GSO_ESP_BIT);
 #endif
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
 	netdev_hw_features_set_set(netdev,
 				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
@@ -11017,18 +11017,18 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= netdev->features;
+	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 	netdev_mpls_features_set_set(netdev,
 				     NETIF_F_SG_BIT,
 				     NETIF_F_TSO_BIT,
 				     NETIF_F_TSO6_BIT,
 				     NETIF_F_HW_CSUM_BIT);
-	netdev->mpls_features |= gso_partial_features;
+	netdev_mpls_features_set(netdev, gso_partial_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= netdev_ctag_vlan_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 2bc6092309ea..172c0488687f 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4620,12 +4620,12 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
 	netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
-	netdev->hw_features |= gso_partial_features;
+	netdev_hw_features_set(netdev, gso_partial_features);
 
 	netdev->features = netdev->hw_features;
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= netdev->features;
+	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	netdev_mpls_features_set_set(netdev,
@@ -4633,11 +4633,11 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				     NETIF_F_TSO_BIT,
 				     NETIF_F_TSO6_BIT,
 				     NETIF_F_HW_CSUM_BIT);
-	netdev->mpls_features |= gso_partial_features;
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_mpls_features_set(netdev, gso_partial_features);
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= netdev_ctag_vlan_features;
+	netdev_active_features_set(netdev, netdev_ctag_vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index cb54394aad51..08297329cc9c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5618,8 +5618,8 @@ static int mvneta_probe(struct platform_device *pdev)
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				       NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT);
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_hw_features_set(dev, dev->features);
+	netdev_vlan_features_set(dev, dev->features);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_set_tso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 5cdf778d8af8..5a533a4e726f 100644
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
 
@@ -6851,7 +6852,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 				NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT);
 	dev->features = features;
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
-	dev->hw_features |= features;
+	netdev_hw_features_set(dev, features);
 	netdev_hw_features_set_set(dev, NETIF_F_RXCSUM_BIT, NETIF_F_GRO_BIT,
 				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
@@ -6863,7 +6864,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	if (!port->priv->percpu_pools)
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
-	dev->vlan_features |= features;
+	netdev_vlan_features_set(dev, features);
 	netif_set_tso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 64490b2a90b6..b5234cf6716e 100644
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
index 686d8e122a40..d6075630525c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2751,7 +2751,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 				   NETIF_F_RXHASH_BIT, NETIF_F_SG_BIT,
 				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				   NETIF_F_GSO_UDP_L4_BIT);
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	err = otx2_mcam_flow_init(pf);
 	if (err)
@@ -2764,11 +2764,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
index dc9848c5b3d5..87870bab4893 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -646,9 +646,9 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 				   NETIF_F_GSO_UDP_L4_BIT);
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
index 2b01ed5c6913..2a761f09d267 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3864,7 +3864,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 		netdev_hw_features_zero(dev);
 		netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT);
-		dev->features |= dev->hw_features;
+		netdev_active_features_set(dev, dev->hw_features);
 	}
 
 	/* read the mac address */
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 9410f898671e..d17b56857ffe 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4651,11 +4651,11 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
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
index b4de9b45540d..1cb707c987fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3902,7 +3902,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
 		~netdev_ctag_vlan_offload_features;
-	eth->netdev[id]->features |= *eth->soc->hw_features;
+	netdev_active_features_set(eth->netdev[id], *eth->soc->hw_features);
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
 	eth->netdev[id]->irq = eth->irq[0];
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 65a1d1c65de2..a2550be0a1b1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3327,7 +3327,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_IPV6_CSUM_BIT);
 	if (mdev->LSO_support)
-		dev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(dev, netdev_general_tso_features);
 
 	if (mdev->dev->caps.tunnel_offload_mode ==
 	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6f27aa24b6e2..bf3e53acd5d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -735,7 +735,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev_hw_feature_add(netdev, NETIF_F_TSO6_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_NETNS_LOCAL_BIT);
 }
 
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index be05d2a60177..91b8f9a15018 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6716,7 +6716,7 @@ static int __init netdev_init(struct net_device *dev)
 	 */
 	netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 
 	sema_init(&priv->proc_sem, 1);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1645e7cd17d2..c4c4c282890e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -753,7 +753,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->ethtool_ops = &lan966x_ethtool_ops;
-	dev->features |= netdev_tx_vlan_features;
+	netdev_active_features_set(dev, netdev_tx_vlan_features);
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 01e2799dafe1..39ddccd62afe 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3872,7 +3872,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->features = netdev->hw_features;
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= mgp->features;
+	netdev_vlan_features_set(netdev, mgp->features);
 	if (mgp->fw_ver_tiny < 37)
 		netdev->vlan_features &= ~NETIF_F_TSO6;
 	if (mgp->fw_ver_tiny < 32)
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index fdc883ba136b..0335a389bb01 100644
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
index 2157d22ced2b..dbc46e260969 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7859,7 +7859,7 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				   NETIF_F_RXCSUM_BIT, NETIF_F_LRO_BIT,
 				   NETIF_F_SG_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
 				       NETIF_F_HIGHDMA_BIT);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0cd76ae68ddb..bcd348fc501e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2362,7 +2362,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXCSUM) {
-		netdev->hw_features |= netdev_ip_csum_features;
+		netdev_hw_features_set(netdev, netdev_ip_csum_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_GATHER) {
@@ -2371,7 +2371,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	}
 	if ((nn->cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    nn->cap & NFP_NET_CFG_CTRL_LSO2) {
-		netdev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(netdev, netdev_general_tso_features);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					 NFP_NET_CFG_CTRL_LSO;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 3c762f5dc8ec..476a91ef99b9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -252,7 +252,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	tmp = NETIF_F_SOFT_FEATURES;
 	netdev_feature_add(NETIF_F_HW_TC_BIT, tmp);
 	tmp &= old_features;
-	features |= tmp;
+	netdev_features_set(features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, features);
 
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
index 44d3bc6acce9..acf3b88f9edb 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5821,10 +5821,10 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
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
index ac83523c3baa..eaebaac13180 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1544,10 +1544,10 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
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
index 85e57a012bec..3ab48fccd634 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1358,7 +1358,7 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 		netdev_hw_features_set_set(netdev, NETIF_F_IPV6_CSUM_BIT,
 					   NETIF_F_TSO6_BIT);
 
-	netdev->vlan_features |= netdev->hw_features;
+	netdev_vlan_features_set(netdev, netdev->hw_features);
 
 	if (adapter->pci_using_dac) {
 		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
@@ -1371,7 +1371,7 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 	if (adapter->capabilities & NX_FW_CAPABILITY_HW_LRO)
 		netdev_hw_feature_add(netdev, NETIF_F_LRO_BIT);
 
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	netdev->irq = adapter->msix_entries[0].vector;
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 0ccc4496c08c..590efc540e4f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2287,8 +2287,9 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 				     NETIF_F_HIGHDMA_BIT);
 
 	if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
-		netdev->features |= netdev_general_tso_features;
-		netdev->vlan_features |= netdev_general_tso_features;
+		netdev_active_features_set(netdev,
+					   netdev_general_tso_features);
+		netdev_vlan_features_set(netdev, netdev_general_tso_features);
 	}
 
 	if (qlcnic_vlan_tx_check(adapter))
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3f7dacbd08df..97cb15d48fc6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5262,7 +5262,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rtl_chip_supports_csum_v2(tp))
 		netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 
 	/* There has been a number of reports that using SG/TSO results in
 	 * tx timeouts. However for a lot of people SG/TSO works fine.
@@ -5271,7 +5271,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
 		netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
-		dev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(dev, netdev_general_tso_features);
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 9a0e1af76ebc..624079763107 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2111,7 +2111,7 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT,
 				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				   NETIF_F_GRO_BIT);
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index fc7cdea99654..7c4338bddab3 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1352,7 +1352,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	netdev_features_zero(hw_enc_features);
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= netdev_ip_csum_features;
+		netdev_features_set(hw_enc_features, netdev_ip_csum_features);
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
@@ -1364,9 +1364,9 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 					NETIF_F_GSO_GRE_CSUM_BIT);
 
-		hw_enc_features |= encap_tso_features;
+		netdev_features_set(hw_enc_features, encap_tso_features);
 		netdev_feature_add(NETIF_F_TSO_BIT, hw_enc_features);
-		efx->net_dev->features |= encap_tso_features;
+		netdev_active_features_set(efx->net_dev, encap_tso_features);
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
 
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 787e69216303..8314049ff340 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -367,10 +367,10 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
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
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT);
 	netif_set_tso_max_segs(net_dev,
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 183d3df49a2a..7fda289809f4 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -197,9 +197,9 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 					NETIF_F_GSO_GRE_BIT,
 					NETIF_F_GSO_GRE_CSUM_BIT);
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
index 3efa720b9355..03319eb81cfa 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1002,7 +1002,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
@@ -1012,13 +1012,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				     NETIF_F_RXCSUM_BIT);
 
 	tmp = net_dev->features & ~efx->fixed_features;
-	net_dev->hw_features |= tmp;
+	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
@@ -1028,7 +1028,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 70a48ede5599..71f90a2c341c 100644
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
index d26a8334b844..bfcb7d2c66fd 100644
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
 
@@ -2901,7 +2901,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_feature_add(net_dev, NETIF_F_SG_BIT);
 	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
@@ -2915,7 +2915,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 3c51561e200e..35fa95504a5f 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1302,8 +1302,11 @@ static inline struct ef4_rx_buffer *ef4_rx_buffer(struct ef4_rx_queue *rx_queue,
 static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx)
 {
 	const struct net_device *net_dev = efx->net_dev;
+	netdev_features_t features;
 
-	return net_dev->features | net_dev->hw_features;
+	netdev_features_or(features, net_dev->features, net_dev->hw_features);
+
+	return features;
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 293af2027995..dae500645595 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1753,8 +1753,11 @@ efx_channel_tx_old_fill_level(struct efx_channel *channel)
 static inline netdev_features_t efx_supported_features(const struct efx_nic *efx)
 {
 	const struct net_device *net_dev = efx->net_dev;
+	netdev_features_t features;
 
-	return net_dev->features | net_dev->hw_features;
+	netdev_features_or(features, net_dev->features, net_dev->hw_features);
+
+	return features;
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 8905065f575f..98de7d4da0aa 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -985,7 +985,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
@@ -995,13 +995,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				     NETIF_F_RXCSUM_BIT);
 
 	tmp = net_dev->features & ~efx->fixed_features;
-	net_dev->hw_features |= tmp;
+	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
@@ -1011,7 +1011,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 3b37d9ccfc6c..1c2c7500848e 100644
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
index 36db05a3fb03..7040cfccd556 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -1681,8 +1681,11 @@ efx_channel_tx_old_fill_level(struct efx_channel *channel)
 static inline netdev_features_t efx_supported_features(const struct efx_nic *efx)
 {
 	const struct net_device *net_dev = efx->net_dev;
+	netdev_features_t features;
 
-	return net_dev->features | net_dev->hw_features;
+	netdev_features_or(features, net_dev->features, net_dev->hw_features);
+
+	return features;
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 754a1df0099e..72328ed81ae1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7128,7 +7128,7 @@ int stmmac_dvr_probe(struct device *device,
 	}
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		ndev->hw_features |= netdev_general_tso_features;
+		netdev_hw_features_set(ndev, netdev_general_tso_features);
 		if (priv->plat->has_gmac4)
 			netdev_hw_feature_add(ndev, NETIF_F_GSO_UDP_L4_BIT);
 		priv->tso = true;
@@ -7174,14 +7174,14 @@ int stmmac_dvr_probe(struct device *device,
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
index ded37de7e450..1fae42ea9879 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9739,7 +9739,7 @@ static void niu_set_basic_features(struct net_device *dev)
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_RXHASH_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 }
 
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 29f66d042d48..adf00230329c 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2787,7 +2787,7 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	/* Happy Meal can do it all... */
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 	hp->irq = op->archdata.irqs[0];
@@ -3109,7 +3109,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	/* Happy Meal can do it all... */
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT);
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index c985c67596f8..d81a3b69ec47 100644
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
index d5cfdb196ead..5a9a9c1cf1fd 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -973,7 +973,7 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 					       NETIF_F_HW_CSUM_BIT);
 
 	if (rp->quirks & rqMgmt)
-		dev->features |= netdev_ctag_vlan_features;
+		netdev_active_features_set(dev, netdev_ctag_vlan_features);
 
 	/* dev->name not defined before register_netdev()! */
 	rc = register_netdev(dev);
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index bdf8624995f5..4bf2d7dce38f 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1250,11 +1250,11 @@ static void geneve_setup(struct net_device *dev)
 				       NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				       NETIF_F_FRAGLIST_BIT,
 				       NETIF_F_RXCSUM_BIT);
-	dev->features    |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 
 	/* MTU range: 68 - (something less than 65535) */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index e8c5d5d3e3d8..2be3039acf20 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1433,7 +1433,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	 */
 	netdev_features_fill(features);
 	features &= ~NETVSC_SUPPORTED_HW_FEATURES;
-	features |= net->hw_features;
+	netdev_features_set(features, net->hw_features);
 	net->features &= features;
 
 	netif_set_tso_max_size(net, gso_max_size);
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 58718326083a..37c660df9a39 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -315,17 +315,18 @@ static void ifb_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->tx_queue_len = TX_Q_LIMIT;
 
-	ifb_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_or(ifb_features, NETIF_F_GSO_SOFTWARE,
+			   NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_set(ifb_features, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_SG_BIT, NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT,
 				NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				NETIF_F_HW_VLAN_STAG_TX_BIT);
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
index ef346c99e42e..c9993c6d0cec 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -129,10 +129,10 @@ static int ipvlan_init(struct net_device *dev)
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
 
@@ -233,15 +233,15 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 	netdev_features_t tmp;
 
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(tmp);
 	tmp &= ~IPVLAN_FEATURES;
-	tmp |= ipvlan->sfeatures;
+	netdev_features_set(tmp, ipvlan->sfeatures);
 	features &= tmp;
 	features = netdev_increment_features(ipvlan->phy_dev->features,
 					     features, features);
-	features |= IPVLAN_ALWAYS_ON;
-	tmp = IPVLAN_FEATURES | IPVLAN_ALWAYS_ON;
+	netdev_features_set(features, IPVLAN_ALWAYS_ON);
+	netdev_features_or(tmp, IPVLAN_FEATURES, IPVLAN_ALWAYS_ON);
 	features &= tmp;
 
 	return features;
@@ -1020,7 +1020,8 @@ static struct notifier_block ipvlan_addr6_vtor_notifier_block __read_mostly = {
 static void __init ipvlan_features_init(void)
 {
 	/* NETIF_F_GSO_ENCAP_ALL NETIF_F_GSO_SOFTWARE Newly added */
-	ipvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_or(ipvlan_offload_features, NETIF_F_GSO_SOFTWARE,
+			   NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_set(ipvlan_offload_features,
 				NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_GSO_ROBUST_BIT);
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 197037f22d27..dfe6b39f1fc7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3479,7 +3479,7 @@ static int macsec_dev_init(struct net_device *dev)
 	} else {
 		dev->features = real_dev->features & SW_MACSEC_FEATURES;
 		netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-		dev->features |= NETIF_F_GSO_SOFTWARE;
+		netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	}
 
 	dev->needed_headroom = real_dev->needed_headroom +
@@ -3517,8 +3517,9 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 		return REAL_DEV_FEATURES(real_dev);
 
 	tmp = real_dev->features & SW_MACSEC_FEATURES;
-	tmp |= NETIF_F_GSO_SOFTWARE;
-	tmp |= NETIF_F_SOFT_FEATURES;
+	netdev_features_set(tmp, NETIF_F_GSO_SOFTWARE);
+	netdev_features_set(tmp, NETIF_F_SOFT_FEATURES);
+
 	features &= tmp;
 	netdev_feature_add(NETIF_F_LLTX_BIT, features);
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d58d585d73bf..d1423617ff0c 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -896,11 +896,11 @@ static int macvlan_init(struct net_device *dev)
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
@@ -1080,10 +1080,10 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 	netdev_features_t tmp;
 
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(tmp);
 	tmp &= ~MACVLAN_FEATURES;
-	tmp |= vlan->set_features;
+	netdev_features_set(tmp, vlan->set_features);
 	features &= tmp;
 	mask = features;
 
@@ -1091,8 +1091,8 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	tmp &= ~NETIF_F_LRO;
 	lowerdev_features &= tmp;
 	features = netdev_increment_features(lowerdev_features, features, mask);
-	features |= ALWAYS_ON_FEATURES;
-	tmp = ALWAYS_ON_FEATURES | MACVLAN_FEATURES;
+	netdev_features_set(features, ALWAYS_ON_FEATURES);
+	netdev_features_or(tmp, ALWAYS_ON_FEATURES, MACVLAN_FEATURES);
 	features &= tmp;
 
 	return features;
@@ -1819,7 +1819,8 @@ static struct notifier_block macvlan_notifier_block __read_mostly = {
 
 static void __init macvlan_features_init(void)
 {
-	macvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_or(macvlan_offload_features, NETIF_F_GSO_SOFTWARE,
+			   NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_set(macvlan_offload_features,
 				NETIF_F_SG_BIT,
 				NETIF_F_HW_CSUM_BIT,
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 26232f59a94e..2bea292328a5 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -425,7 +425,7 @@ static void net_failover_compute_features(struct net_device *dev)
 	}
 
 	dev->vlan_features = vlan_features;
-	dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	netdev_hw_enc_features_or(dev, enc_features, NETIF_F_GSO_ENCAP_ALL);
 	dev->hard_header_len = max_hard_header_len;
 
 	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -744,11 +744,11 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	/* Don't allow failover devices to change network namespaces. */
 	netdev_active_feature_add(failover_dev, NETIF_F_NETNS_LOCAL_BIT);
 
-	failover_dev->hw_features = FAILOVER_VLAN_FEATURES |
-				    netdev_ctag_vlan_features;
+	netdev_hw_features_or(failover_dev, FAILOVER_VLAN_FEATURES,
+			      netdev_ctag_vlan_features);
 
-	failover_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-	failover_dev->features |= failover_dev->hw_features;
+	netdev_hw_features_set(failover_dev, NETIF_F_GSO_ENCAP_ALL);
+	netdev_active_features_set(failover_dev, failover_dev->hw_features);
 
 	dev_addr_set(failover_dev, standby_dev->dev_addr);
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 4959b22551e4..db31ebdb6b64 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -340,7 +340,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	 * enabled.
 	 */
 	if (q->flags & IFF_VNET_HDR)
-		features |= tap->tap_features;
+		netdev_features_set(features, tap->tap_features);
 	if (netif_needs_gso(skb, features)) {
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index d1f39c5ce632..41e8af2325dd 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1014,8 +1014,9 @@ static void __team_compute_features(struct team *team)
 	rcu_read_unlock();
 
 	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
-	team->dev->hw_enc_features |= netdev_tx_vlan_features;
+	netdev_hw_enc_features_or(team->dev, enc_features,
+				  NETIF_F_GSO_ENCAP_ALL);
+	netdev_hw_enc_features_set(team->dev, netdev_tx_vlan_features);
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2007,7 +2008,7 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 
 	mask = features;
 	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
@@ -2178,9 +2179,9 @@ static void team_setup(struct net_device *dev)
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
index ba9a8f6c5fd9..c0f0cff917ce 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2890,7 +2890,7 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 
 	tun->set_features = features;
 	tun->dev->wanted_features &= ~TUN_USER_FEATURES;
-	tun->dev->wanted_features |= features;
+	netdev_wanted_features_set(tun->dev, features);
 	netdev_update_features(tun->dev);
 
 	return 0;
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index ac430e2d19b4..88a57c8ad62f 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1298,7 +1298,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 				       NETIF_F_RXCSUM_BIT,
 				       NETIF_F_TSO_BIT);
 
-	dev->net->hw_features |= dev->net->features;
+	netdev_hw_features_set(dev->net, dev->net->features);
 
 	netif_set_tso_max_size(dev->net, 16384);
 
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index b973c0d3c6e1..2d216c0d74de 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1474,7 +1474,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= netdev_ip_csum_features;
+		netdev_active_features_set(dev->net, netdev_ip_csum_features);
 
 	if (DEFAULT_RX_CSUM_ENABLE)
 		netdev_active_feature_add(dev->net, NETIF_F_RXCSUM_BIT);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ae6d20365e47..5c2218f5fbed 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1571,7 +1571,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 				veth_disable_xdp(dev);
 
 			if (peer) {
-				peer->hw_features |= NETIF_F_GSO_SOFTWARE;
+				netdev_hw_features_set(peer,
+						       NETIF_F_GSO_SOFTWARE);
 				peer->max_mtu = ETH_MAX_MTU;
 			}
 		}
@@ -1632,7 +1633,8 @@ static void veth_setup(struct net_device *dev)
 
 	dev->netdev_ops = &veth_netdev_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
-	veth_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_or(veth_features, NETIF_F_GSO_SOFTWARE,
+			   NETIF_F_GSO_ENCAP_ALL);
 	netdev_features_set_set(veth_features, NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_RXCSUM_BIT, NETIF_F_SCTP_CRC_BIT,
@@ -1642,7 +1644,7 @@ static void veth_setup(struct net_device *dev)
 				NETIF_F_HW_VLAN_STAG_TX_BIT,
 				NETIF_F_HW_VLAN_STAG_RX_BIT);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->features |= veth_features;
+	netdev_active_features_set(dev, veth_features);
 	dev->vlan_features = dev->features & ~netdev_vlan_offload_features;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = veth_dev_free;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index eca9d6b28b75..4900ab1bdea6 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3728,7 +3728,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 			netdev_active_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
 						       NETIF_F_SG_BIT);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
-			dev->hw_features |= netdev_general_tso_features;
+			netdev_hw_features_set(dev,
+					       netdev_general_tso_features);
 			netdev_hw_feature_add(dev, NETIF_F_TSO_ECN_BIT);
 		}
 		/* Individual feature bits: what can host handle? */
@@ -3744,7 +3745,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		if (gso) {
 			netdev_features_t tmp = dev->hw_features & NETIF_F_ALL_TSO;
 
-			dev->features |= tmp;
+			netdev_active_features_set(dev, tmp);
 		}
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 5b3088b0b6f7..c7fd71f66b2e 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1688,7 +1688,7 @@ static void vrf_setup(struct net_device *dev)
 	netdev_active_feature_add(dev, NETIF_F_VLAN_CHALLENGED_BIT);
 
 	/* enable offload features */
-	dev->features   |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_active_features_set_set(dev, NETIF_F_RXCSUM_BIT,
 				       NETIF_F_HW_CSUM_BIT,
 				       NETIF_F_SCTP_CRC_BIT, NETIF_F_SG_BIT,
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index f8bb383779e1..e179c780b761 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3167,12 +3167,12 @@ static void vxlan_setup(struct net_device *dev)
 				       NETIF_F_HW_CSUM_BIT,
 				       NETIF_F_FRAGLIST_BIT,
 				       NETIF_F_RXCSUM_BIT);
-	dev->features   |= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 
 	dev->vlan_features = dev->features;
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	netif_keep_dst(dev);
 	dev->priv_flags |= IFF_NO_QUEUE | IFF_CHANGE_PROTO_DOWN;
 
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 99ec1a71a8d9..6930f0882b0d 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -297,9 +297,9 @@ static void wg_setup(struct net_device *dev)
 	netdev_features_set_set(wg_netdev_features, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
 				NETIF_F_GSO_BIT, NETIF_F_HIGHDMA_BIT);
-	dev->features |= wg_netdev_features;
-	dev->hw_features |= wg_netdev_features;
-	dev->hw_enc_features |= wg_netdev_features;
+	netdev_active_features_set(dev, wg_netdev_features);
+	netdev_hw_features_set(dev, wg_netdev_features);
+	netdev_hw_enc_features_set(dev, wg_netdev_features);
 	dev->mtu = ETH_DATA_LEN - overhead;
 	dev->max_mtu = round_down(INT_MAX, MESSAGE_PADDING_MULTIPLE) - overhead;
 
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 4b61525f5853..b1af33ed0a35 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -342,7 +342,7 @@ wil_vif_alloc(struct wil6210_priv *wil, const char *name,
 				   NETIF_F_GRO_BIT, NETIF_F_TSO_BIT,
 				   NETIF_F_TSO6_BIT);
 
-	ndev->features |= ndev->hw_features;
+	netdev_active_features_set(ndev, ndev->hw_features);
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 	return vif;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 25176f5cf94d..603fa9183816 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -615,7 +615,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	}
 
-	hw->netdev_features |= *mvm->cfg->features;
+	netdev_features_set(hw->netdev_features, *mvm->cfg->features);
 	if (!iwl_mvm_is_csum_supported(mvm))
 		hw->netdev_features &= ~IWL_CSUM_NETIF_FLAGS_MASK;
 
@@ -1416,7 +1416,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	mvmvif->features |= hw->netdev_features;
+	netdev_features_set(mvmvif->features, hw->netdev_features);
 
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 1003233f8cc1..00bd7be507db 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1744,7 +1744,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
          * xennet_connect() which is the earliest point where we can
          * negotiate with the backend regarding supported features.
          */
-	netdev->features |= netdev->hw_features;
+	netdev_active_features_set(netdev, netdev->hw_features);
 
 	netdev->ethtool_ops = &xennet_ethtool_ops;
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 33f2fad0b9b9..c2b6f2d8dcd5 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6874,7 +6874,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 
 		netdev_features_zero(restricted);
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
-			restricted |= NETIF_F_ALL_TSO;
+			netdev_features_set(restricted, NETIF_F_ALL_TSO);
 
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 614859697a96..e7484986d94f 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1908,7 +1908,8 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		return -ENODEV;
 
 	card->dev->needed_headroom = headroom;
-	card->dev->features |= netdev_ctag_vlan_offload_features;
+	netdev_active_features_set(card->dev,
+				   netdev_ctag_vlan_offload_features);
 
 	netif_keep_dst(card->dev);
 	if (card->dev->hw_features & netdev_general_tso_features)
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index d7ab441e0560..d5ceaf4b52d3 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -702,9 +702,9 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 {
 	if ((f1 & NETIF_F_HW_CSUM) != (f2 & NETIF_F_HW_CSUM)) {
 		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= netdev_ip_csum_features;
+			netdev_features_set(f1, netdev_ip_csum_features);
 		else
-			f2 |= netdev_ip_csum_features;
+			netdev_features_set(f2, netdev_ip_csum_features);
 	}
 
 	return f1 & f2;
@@ -716,7 +716,8 @@ netdev_get_wanted_features(struct net_device *dev)
 	netdev_features_t tmp;
 
 	tmp = dev->features & ~dev->hw_features;
-	return dev->wanted_features | tmp;
+	netdev_features_set(tmp, dev->wanted_features);
+	return tmp;
 }
 
 #endif
diff --git a/include/net/udp.h b/include/net/udp.h
index f6bfe025f865..ecdf76e4318f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -467,7 +467,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	 * asks for the final checksum values
 	 */
 	if (!inet_get_convert_csum(sk))
-		features |= netdev_ip_csum_features;
+		netdev_features_set(features, netdev_ip_csum_features);
 
 	/* UDP segmentation expects packets of type CHECKSUM_PARTIAL or
 	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 70e92a44cbb0..07b70cf135ef 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -108,8 +108,8 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 {
 	netdev_features_t ret;
 
-	ret = NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE;
-	ret |= NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_or(ret, NETIF_F_CSUM_MASK, NETIF_F_GSO_SOFTWARE);
+	netdev_features_set(ret, NETIF_F_GSO_ENCAP_ALL);
 	ret &= real_dev->hw_enc_features;
 
 	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK)) {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index d1ba565425d0..72e72a799943 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -567,15 +567,15 @@ static int vlan_dev_init(struct net_device *dev)
 	if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 		dev->state |= (1 << __LINK_STATE_NOCARRIER);
 
-	dev->hw_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
-	dev->hw_features |= NETIF_F_ALL_FCOE;
+	netdev_hw_features_or(dev, NETIF_F_GSO_SOFTWARE, NETIF_F_GSO_ENCAP_ALL);
+	netdev_hw_features_set(dev, NETIF_F_ALL_FCOE);
 	netdev_hw_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_SG_BIT,
 				   NETIF_F_FRAGLIST_BIT,
 				   NETIF_F_HIGHDMA_BIT,
 				   NETIF_F_SCTP_CRC_BIT);
 
-	dev->features |= dev->hw_features;
+	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
@@ -662,9 +662,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	if (lower_features & netdev_ip_csum_features)
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, lower_features);
 	features = netdev_intersect_features(features, lower_features);
-	tmp = NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE;
+	netdev_features_or(tmp, NETIF_F_SOFT_FEATURES, NETIF_F_GSO_SOFTWARE);
 	tmp &= old_features;
-	features |= tmp;
+	netdev_features_set(features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, features);
 
 	return features;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 7f2869ab25c6..f1d851deb536 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -500,7 +500,7 @@ void br_dev_setup(struct net_device *dev)
 				       NETIF_F_NETNS_LOCAL_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				       NETIF_F_HW_VLAN_STAG_TX_BIT);
-	dev->hw_features = common_features | netdev_tx_vlan_features;
+	netdev_hw_features_or(dev, common_features, netdev_tx_vlan_features);
 	dev->vlan_features = common_features;
 
 	br->dev = dev;
diff --git a/net/core/dev.c b/net/core/dev.c
index 5c6839083b21..f396d6a63b9f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3399,7 +3399,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 
 		partial_features = dev->features & dev->gso_partial_features;
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, partial_features);
-		partial_features |= features;
+		netdev_features_set(partial_features, features);
 		if (!skb_gso_ok(skb, partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
@@ -3565,7 +3565,8 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		features &= dev->hw_enc_features;
 
 	if (skb_vlan_tagged(skb)) {
-		tmp = dev->vlan_features | netdev_tx_vlan_features;
+		netdev_features_or(tmp, dev->vlan_features,
+				   netdev_tx_vlan_features);
 		features = netdev_intersect_features(features, tmp);
 	}
 
@@ -10027,9 +10028,9 @@ int register_netdevice(struct net_device *dev)
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
@@ -11152,17 +11153,17 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t tmp;
 
 	if (mask & NETIF_F_HW_CSUM)
-		mask |= NETIF_F_CSUM_MASK;
+		netdev_features_set(mask, NETIF_F_CSUM_MASK);
 	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, mask);
 
-	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
+	netdev_features_or(tmp, NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
 	tmp &= one;
 	tmp &= mask;
-	all |= tmp;
+	netdev_features_set(all, tmp);
 
 	netdev_features_fill(tmp);
 	tmp &= ~NETIF_F_ALL_FOR_ALL;
-	tmp |= one;
+	netdev_features_set(tmp, one);
 	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
diff --git a/net/core/sock.c b/net/core/sock.c
index 62b560e30296..61e8dc0d65d9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2374,7 +2374,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	if (sk_is_tcp(sk))
 		netdev_feature_add(NETIF_F_GSO_BIT, sk->sk_route_caps);
 	if (sk->sk_route_caps & NETIF_F_GSO)
-		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
+		netdev_features_set(sk->sk_route_caps, NETIF_F_GSO_SOFTWARE);
 	if (unlikely(sk->sk_gso_disabled))
 		sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 	if (sk_can_gso(sk)) {
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 2dc2b80aea5f..d2faec777289 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -4,6 +4,7 @@
 #define _ETHTOOL_COMMON_H
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/ethtool.h>
 
 #define ETHTOOL_DEV_FEATURE_WORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 32)
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 67a837d44491..51e4702c2b6d 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -255,7 +255,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		dev->wanted_features &= ~dev->hw_features;
 		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
-		dev->wanted_features |= tmp;
+		netdev_wanted_features_set(dev, tmp);
 		__netdev_update_features(dev);
 	}
 	ethnl_features_to_bitmap(new_active, dev->features);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 672ffa3ba2e1..052edfd2bee1 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -159,7 +159,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 
 	dev->wanted_features &= ~valid;
 	tmp = wanted & valid;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_set(dev, tmp);
 	__netdev_update_features(dev);
 
 	tmp = dev->wanted_features ^ dev->features;
@@ -296,7 +296,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (edata.data)
-		dev->wanted_features |= mask;
+		netdev_wanted_features_set(dev, mask);
 	else
 		dev->wanted_features &= ~mask;
 
@@ -363,7 +363,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	dev->wanted_features &= ~changed;
 	tmp = features & changed;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_set(dev, tmp);
 
 	__netdev_update_features(dev);
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 6ee63ea39eb5..480754eadf4b 100644
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
index 8e54d5b20f1e..fc7835e24717 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -373,8 +373,8 @@ static void ipip_tunnel_setup(struct net_device *dev)
 				NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT,
 				NETIF_F_HW_CSUM_BIT);
-	dev->features		|= ipip_features;
-	dev->hw_features	|= ipip_features;
+	netdev_active_features_set(dev, ipip_features);
+	netdev_hw_features_set(dev, ipip_features);
 	ip_tunnel_setup(dev, ipip_net_id);
 }
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index ca36765bd453..b36ec1e215ae 100644
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
index 04c0db84bdc6..86c7052a3dd3 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1838,8 +1838,8 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 				NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT,
 				NETIF_F_HW_CSUM_BIT);
-	dev->features		|= ipxipx_features;
-	dev->hw_features	|= ipxipx_features;
+	netdev_active_features_set(dev, ipxipx_features);
+	netdev_hw_features_set(dev, ipxipx_features);
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 2d39f53c81a4..15b0a28d339b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1432,8 +1432,8 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 				NETIF_F_HIGHDMA_BIT,
 				NETIF_F_HW_CSUM_BIT);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->features		|= sit_features;
-	dev->hw_features	|= sit_features;
+	netdev_active_features_set(dev, sit_features);
+	netdev_hw_features_set(dev, sit_features);
 }
 
 static int ipip6_tunnel_init(struct net_device *dev)
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f14b0da3b9e1..d2227c0af028 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2228,10 +2228,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		if (type == NL80211_IFTYPE_STATION)
 			sdata->u.mgd.use_4addr = params->use_4addr;
 
-		ndev->features |= local->hw.netdev_features;
+		netdev_active_features_set(ndev, local->hw.netdev_features);
 		ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 		tmp = ndev->features & MAC80211_SUPPORTED_FEATURES_TX;
-		ndev->hw_features |= tmp;
+		netdev_hw_features_set(ndev, tmp);
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3427752ecc8d..d5607d4cf903 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1543,7 +1543,8 @@ static void __init ieee80211_features_init(void)
 				NETIF_F_SG_BIT,
 				NETIF_F_HIGHDMA_BIT);
 	netdev_features_set_set(mac80211_rx_features, NETIF_F_RXCSUM_BIT);
-	mac80211_supported_features = mac80211_tx_features | mac80211_rx_features;
+	netdev_features_or(mac80211_supported_features, mac80211_tx_features,
+			   mac80211_rx_features);
 }
 
 static int __init ieee80211_init(void)
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 2bf22a159aae..7af99c4758c1 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -109,7 +109,8 @@ static void do_setup(struct net_device *netdev)
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
 	netdev->rtnl_link_ops = &internal_dev_link_ops;
 
-	netdev->features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_active_features_or(netdev, NETIF_F_GSO_SOFTWARE,
+				  NETIF_F_GSO_ENCAP_ALL);
 	netdev_active_features_set_set(netdev, NETIF_F_LLTX_BIT,
 				       NETIF_F_SG_BIT,
 				       NETIF_F_FRAGLIST_BIT,
@@ -118,7 +119,7 @@ static void do_setup(struct net_device *netdev)
 
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
-	netdev->features |= netdev_tx_vlan_features;
+	netdev_active_features_set(netdev, netdev_tx_vlan_features);
 	netdev->hw_features = netdev->features;
 	netdev->hw_features &= ~NETIF_F_LLTX;
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 06b94053097e..c0c7df416ce6 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -156,7 +156,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	if (!skb->next) {
-		esp_features |= skb->dev->gso_partial_features;
+		netdev_features_set(esp_features,
+				    skb->dev->gso_partial_features);
 		xfrm_outer_mode_prep(x, skb);
 
 		xo->flags |= XFRM_DEV_RESUME;
@@ -177,7 +178,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	skb_list_walk_safe(skb, skb2, nskb) {
-		esp_features |= skb->dev->gso_partial_features;
+		netdev_features_set(esp_features,
+				    skb->dev->gso_partial_features);
 		skb_mark_not_on_list(skb2);
 
 		xo = xfrm_offload(skb2);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 9ef68486816a..3d5b8c6377d7 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -594,8 +594,8 @@ static int xfrmi_dev_init(struct net_device *dev)
 	netdev_features_set_set(xfrmi_features, NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT, NETIF_F_HW_CSUM_BIT);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->features |= xfrmi_features;
-	dev->hw_features |= xfrmi_features;
+	netdev_active_features_set(dev, xfrmi_features);
+	netdev_hw_features_set(dev, xfrmi_features);
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.33.0

