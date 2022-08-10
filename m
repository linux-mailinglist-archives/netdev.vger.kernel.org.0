Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4009058E565
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiHJDPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiHJDN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FD682F8C
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfq0ZbRzXdSf;
        Wed, 10 Aug 2022 11:09:39 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:44 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 03/36] net: replace multiple feature bits with DECLARE_NETDEV_FEATURE_SET
Date:   Wed, 10 Aug 2022 11:05:51 +0800
Message-ID: <20220810030624.34711-4-shenjian15@huawei.com>
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

There are many netdev_features bits group used in drivers, replace them
with DECLARE_NETDEV_FEATURE_SET, prepare to remove all the NETIF_F_XXX
macroes.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_transports.c           |  49 +++++--
 drivers/infiniband/ulp/ipoib/ipoib.h          |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   8 +-
 drivers/net/amt.c                             |  16 ++-
 drivers/net/bareudp.c                         |  21 ++-
 drivers/net/bonding/bond_main.c               |  48 +++++--
 drivers/net/dsa/xrs700x/xrs700x.c             |  15 +-
 drivers/net/dummy.c                           |  11 +-
 drivers/net/ethernet/3com/typhoon.c           |  18 ++-
 drivers/net/ethernet/aeroflex/greth.c         |   9 +-
 drivers/net/ethernet/alteon/acenic.c          |  10 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  13 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  59 ++++----
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  12 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  14 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  21 ++-
 drivers/net/ethernet/atheros/alx/main.c       |  15 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h    |   1 +
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  14 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h    |   1 +
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  10 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  22 ++-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  24 +++-
 drivers/net/ethernet/broadcom/bgmac.c         |   9 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  14 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  83 ++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  54 +++++--
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  10 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  39 +++--
 drivers/net/ethernet/calxeda/xgmac.c          |  15 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  42 ++++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  40 ++++--
 .../ethernet/cavium/liquidio/octeon_network.h |   4 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  27 +++-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  19 ++-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  29 +++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  68 ++++++---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  39 ++++-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   7 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  19 ++-
 drivers/net/ethernet/cortina/gemini.c         |  22 ++-
 drivers/net/ethernet/emulex/benet/be_main.c   |  47 ++++--
 drivers/net/ethernet/faraday/ftgmac100.c      |  13 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  14 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  17 ++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  10 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  42 ++++--
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  40 ++++--
 drivers/net/ethernet/freescale/fec_main.c     |  11 +-
 drivers/net/ethernet/freescale/gianfar.c      |  18 ++-
 .../ethernet/fungible/funeth/funeth_main.c    |  48 +++++--
 drivers/net/ethernet/google/gve/gve_main.c    |  21 +--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  51 +++++--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  40 ++++--
 .../net/ethernet/huawei/hinic/hinic_main.c    |  37 +++--
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  34 +++--
 drivers/net/ethernet/ibm/emac/core.c          |   7 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  11 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |   8 +-
 drivers/net/ethernet/intel/e1000/e1000.h      |   1 +
 drivers/net/ethernet/intel/e1000/e1000_main.c |  33 +++--
 drivers/net/ethernet/intel/e1000e/netdev.c    |  46 ++++--
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  37 +++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  75 +++++-----
 drivers/net/ethernet/intel/iavf/iavf.h        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  43 +++---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  64 ++++++---
 drivers/net/ethernet/intel/igb/igb_main.c     |  74 ++++++----
 drivers/net/ethernet/intel/igbvf/netdev.c     |  76 ++++++----
 drivers/net/ethernet/intel/igc/igc_mac.c      |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c     |  77 ++++++----
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  15 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 134 +++++++++++-------
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  15 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |   1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  87 +++++++-----
 drivers/net/ethernet/jme.c                    |  34 +++--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   9 +-
 drivers/net/ethernet/marvell/mvneta.c         |  12 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  19 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  17 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  17 ++-
 drivers/net/ethernet/marvell/skge.c           |   9 +-
 drivers/net/ethernet/marvell/sky2.c           |  19 ++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c  |   1 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  75 ++++++----
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  20 +--
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 ++-
 drivers/net/ethernet/micrel/ksz884x.c         |   9 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   9 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  15 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  14 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  11 +-
 drivers/net/ethernet/neterion/s2io.c          |  24 +++-
 drivers/net/ethernet/nvidia/forcedeth.c       |  10 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  10 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |  11 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  23 +--
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  11 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  50 +++++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  29 ++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  34 +++--
 drivers/net/ethernet/qualcomm/emac/emac.c     |  23 ++-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  12 +-
 drivers/net/ethernet/realtek/8139cp.c         |  23 ++-
 drivers/net/ethernet/realtek/8139too.c        |   8 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  18 ++-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  15 +-
 drivers/net/ethernet/sfc/ef10.c               |  11 +-
 drivers/net/ethernet/sfc/ef100_netdev.c       |   9 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  15 +-
 drivers/net/ethernet/sfc/efx.c                |  21 ++-
 drivers/net/ethernet/sfc/falcon/efx.c         |  10 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   1 +
 drivers/net/ethernet/sfc/net_driver.h         |   1 +
 drivers/net/ethernet/sfc/siena/efx.c          |  22 ++-
 drivers/net/ethernet/sgi/ioc3-eth.c           |  13 +-
 drivers/net/ethernet/silan/sc92031.c          |  11 +-
 drivers/net/ethernet/socionext/netsec.c       |  11 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  11 +-
 drivers/net/ethernet/sun/ldmvsw.c             |   7 +-
 drivers/net/ethernet/sun/niu.c                |   9 +-
 drivers/net/ethernet/sun/sungem.c             |   9 +-
 drivers/net/ethernet/sun/sunvnet.c            |  10 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  25 +++-
 drivers/net/ethernet/tehuti/tehuti.h          |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  13 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  11 +-
 drivers/net/ethernet/via/via-velocity.c       |  19 ++-
 drivers/net/geneve.c                          |  20 ++-
 drivers/net/hyperv/netvsc_drv.c               |  11 +-
 drivers/net/ifb.c                             |  20 ++-
 drivers/net/ipvlan/ipvlan_main.c              |  58 ++++++--
 drivers/net/ipvlan/ipvtap.c                   |  12 +-
 drivers/net/loopback.c                        |  25 ++--
 drivers/net/macsec.c                          |  22 ++-
 drivers/net/macvlan.c                         |  56 ++++++--
 drivers/net/macvtap.c                         |  12 +-
 drivers/net/net_failover.c                    |  23 +++
 drivers/net/netdevsim/ipsec.c                 |  13 +-
 drivers/net/netdevsim/netdev.c                |  14 +-
 drivers/net/netdevsim/netdevsim.h             |   1 +
 drivers/net/nlmon.c                           |  11 +-
 drivers/net/tap.c                             |  18 ++-
 drivers/net/team/team.c                       |  31 +++-
 drivers/net/thunderbolt.c                     |  11 +-
 drivers/net/tun.c                             |  28 +++-
 drivers/net/usb/aqc111.c                      |  38 ++++-
 drivers/net/usb/aqc111.h                      |  14 --
 drivers/net/usb/ax88179_178a.c                |  11 +-
 drivers/net/usb/lan78xx.c                     |   8 +-
 drivers/net/usb/r8152.c                       |  53 +++++--
 drivers/net/usb/smsc75xx.c                    |  10 +-
 drivers/net/veth.c                            |  27 ++--
 drivers/net/vmxnet3/vmxnet3_drv.c             |  36 +++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  35 +++--
 drivers/net/vmxnet3/vmxnet3_int.h             |   1 +
 drivers/net/vrf.c                             |  12 +-
 drivers/net/vsockmon.c                        |  11 +-
 drivers/net/vxlan/vxlan_core.c                |  20 ++-
 drivers/net/wireguard/device.c                |  20 ++-
 drivers/net/wireless/ath/wil6210/netdev.c     |  14 +-
 drivers/net/xen-netback/interface.c           |  14 +-
 drivers/net/xen-netfront.c                    |  20 ++-
 drivers/s390/net/qeth_l3_main.c               |  13 +-
 drivers/staging/qlge/qlge_main.c              |  21 +--
 include/net/bonding.h                         |   5 +-
 include/net/net_failover.h                    |   8 +-
 net/8021q/vlan_dev.c                          |  15 +-
 net/batman-adv/soft-interface.c               |   9 +-
 net/bridge/br_device.c                        |  25 +++-
 net/ethtool/ioctl.c                           |  17 ++-
 net/hsr/hsr_device.c                          |  13 +-
 net/ipv4/ip_gre.c                             |  19 +--
 net/ipv4/ipip.c                               |  19 ++-
 net/ipv6/ip6_gre.c                            |  15 +-
 net/ipv6/ip6_tunnel.c                         |  19 ++-
 net/ipv6/sit.c                                |  18 ++-
 net/mac80211/ieee80211_i.h                    |  13 +-
 net/mac80211/main.c                           |  24 ++++
 net/openvswitch/vport-internal_dev.c          |  13 +-
 net/xfrm/xfrm_interface.c                     |  16 ++-
 184 files changed, 2923 insertions(+), 1139 deletions(-)

diff --git a/arch/um/drivers/vector_transports.c b/arch/um/drivers/vector_transports.c
index 0794d23f07cb..bf43b554e5f2 100644
--- a/arch/um/drivers/vector_transports.c
+++ b/arch/um/drivers/vector_transports.c
@@ -397,6 +397,35 @@ static int build_l2tpv3_transport_data(struct vector_private *vp)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(raw_hw_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(raw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(hybrid_hw_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(hybrid_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(tap_hw_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(tap_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT);
+
 static int build_raw_transport_data(struct vector_private *vp)
 {
 	if (uml_raw_enable_vnet_headers(vp->fds->rx_fd)) {
@@ -406,10 +435,8 @@ static int build_raw_transport_data(struct vector_private *vp)
 		vp->verify_header = &raw_verify_header;
 		vp->header_size = sizeof(struct virtio_net_hdr);
 		vp->rx_header_size = sizeof(struct virtio_net_hdr);
-		vp->dev->hw_features |= (NETIF_F_TSO | NETIF_F_GRO);
-		vp->dev->features |=
-			(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-				NETIF_F_TSO | NETIF_F_GRO);
+		netdev_hw_features_set_array(vp->dev, &raw_hw_feature_set);
+		netdev_active_features_set_array(vp->dev, &raw_feature_set);
 		netdev_info(
 			vp->dev,
 			"raw: using vnet headers for tso and tx/rx checksum"
@@ -425,11 +452,8 @@ static int build_hybrid_transport_data(struct vector_private *vp)
 		vp->verify_header = &raw_verify_header;
 		vp->header_size = sizeof(struct virtio_net_hdr);
 		vp->rx_header_size = sizeof(struct virtio_net_hdr);
-		vp->dev->hw_features |=
-			(NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
-		vp->dev->features |=
-			(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-				NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
+		netdev_hw_features_set_array(vp->dev, &hybrid_hw_feature_set);
+		netdev_active_features_set_array(vp->dev, &hybrid_feature_set);
 		netdev_info(
 			vp->dev,
 			"tap/raw hybrid: using vnet headers for tso and tx/rx checksum"
@@ -450,11 +474,8 @@ static int build_tap_transport_data(struct vector_private *vp)
 		vp->verify_header = &raw_verify_header;
 		vp->header_size = sizeof(struct virtio_net_hdr);
 		vp->rx_header_size = sizeof(struct virtio_net_hdr);
-		vp->dev->hw_features |=
-			(NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
-		vp->dev->features |=
-			(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-				NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
+		netdev_hw_features_set_array(vp->dev, &tap_hw_feature_set);
+		netdev_active_features_set_array(vp->dev, &tap_feature_set);
 		netdev_info(
 			vp->dev,
 			"tap: using vnet headers for tso and tx/rx checksum"
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 35e9c8a330e2..8f0cbaa4afdc 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -38,6 +38,7 @@
 #include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/workqueue.h>
 #include <linux/kref.h>
 #include <linux/if_infiniband.h>
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 2a8961b685c2..4d917762352f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2104,6 +2104,10 @@ static const struct net_device_ops ipoib_netdev_default_pf = {
 	.ndo_stop		 = ipoib_ib_dev_stop_default,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(ipoib_feature_set,
+				  NETIF_F_VLAN_CHALLENGED_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 void ipoib_setup_common(struct net_device *dev)
 {
 	dev->header_ops		 = &ipoib_header_ops;
@@ -2119,8 +2123,8 @@ void ipoib_setup_common(struct net_device *dev)
 	dev->addr_len		 = INFINIBAND_ALEN;
 	dev->type		 = ARPHRD_INFINIBAND;
 	dev->tx_queue_len	 = ipoib_sendq_size * 2;
-	dev->features		 = (NETIF_F_VLAN_CHALLENGED	|
-				    NETIF_F_HIGHDMA);
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &ipoib_feature_set);
 	netif_keep_dst(dev);
 
 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 9a247eb7679c..f76013edd417 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -9,6 +9,7 @@
 #include <linux/jhash.h>
 #include <linux/if_tunnel.h>
 #include <linux/net.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/igmp.h>
 #include <linux/workqueue.h>
 #include <net/sch_generic.h>
@@ -3095,6 +3096,15 @@ static const struct net_device_ops amt_netdev_ops = {
 	.ndo_get_stats64        = dev_get_tstats64,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(amt_feature_set,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_NETNS_LOCAL_BIT);
+static DECLARE_NETDEV_FEATURE_SET(amt_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static void amt_link_setup(struct net_device *dev)
 {
 	dev->netdev_ops         = &amt_netdev_ops;
@@ -3107,12 +3117,10 @@ static void amt_link_setup(struct net_device *dev)
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
 	dev->priv_flags		|= IFF_NO_QUEUE;
-	dev->features		|= NETIF_F_LLTX;
 	dev->features		|= NETIF_F_GSO_SOFTWARE;
-	dev->features		|= NETIF_F_NETNS_LOCAL;
-	dev->hw_features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->hw_features	|= NETIF_F_FRAGLIST | NETIF_F_RXCSUM;
+	netdev_active_features_set_array(dev, &amt_feature_set);
 	dev->hw_features	|= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set_array(dev, &amt_hw_feature_set);
 	eth_hw_addr_random(dev);
 	eth_zero_addr(dev->broadcast);
 	ether_setup(dev);
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 683203f87ae2..08b11ed436ad 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/hash.h>
+#include <linux/netdev_features_helper.h>
 #include <net/dst_metadata.h>
 #include <net/gro_cells.h>
 #include <net/rtnetlink.h>
@@ -536,18 +537,28 @@ static const struct device_type bareudp_type = {
 	.name = "bareudp",
 };
 
+static DECLARE_NETDEV_FEATURE_SET(bareudp_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_LLTX_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bareudp_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /* Initialize the device structure. */
 static void bareudp_setup(struct net_device *dev)
 {
 	dev->netdev_ops = &bareudp_netdev_ops;
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &bareudp_type);
-	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features    |= NETIF_F_RXCSUM;
-	dev->features    |= NETIF_F_LLTX;
+	netdev_active_features_set_array(dev, &bareudp_feature_set);
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_features_set_array(dev, &bareudp_hw_feature_set);
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e75acb14d066..a7783abec601 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -59,6 +59,7 @@
 #include <linux/uaccess.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/inetdevice.h>
 #include <linux/igmp.h>
 #include <linux/etherdevice.h>
@@ -254,6 +255,25 @@ static const struct flow_dissector_key flow_keys_bonding_keys[] = {
 
 static struct flow_dissector flow_keys_bonding __read_mostly;
 
+static DECLARE_NETDEV_FEATURE_SET(bond_vlan_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LRO_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bond_enc_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bond_mpls_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT);
+
+static netdev_features_t bond_vlan_features __ro_after_init;
+static netdev_features_t bond_enc_features __ro_after_init;
+static netdev_features_t bond_mpls_features __ro_after_init;
 /*-------------------------- Forward declarations ---------------------------*/
 
 static int bond_init(struct net_device *bond_dev);
@@ -1421,16 +1441,11 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	return features;
 }
 
-#define BOND_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-				 NETIF_F_HIGHDMA | NETIF_F_LRO)
+#define BOND_VLAN_FEATURES	bond_vlan_features
 
-#define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
-
-#define BOND_MPLS_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_GSO_SOFTWARE)
+#define BOND_ENC_FEATURES	bond_enc_features
 
+#define BOND_MPLS_FEATURES	bond_mpls_features
 
 static void bond_compute_features(struct bonding *bond)
 {
@@ -6195,6 +6210,21 @@ static int bond_check_params(struct bond_params *params)
 	return 0;
 }
 
+static void __init bond_netdev_features_init(void)
+{
+	bond_vlan_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&bond_vlan_feature_set,
+				  &bond_vlan_features);
+
+	bond_enc_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&bond_enc_feature_set,
+				  &bond_enc_features);
+
+	bond_mpls_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&bond_mpls_feature_set,
+				  &bond_mpls_features);
+}
+
 /* Called from registration process */
 static int bond_init(struct net_device *bond_dev)
 {
@@ -6355,6 +6385,8 @@ static int __init bonding_init(void)
 				ARRAY_SIZE(flow_keys_bonding_keys));
 
 	register_netdevice_notifier(&bond_netdev_notifier);
+
+	bond_netdev_features_init();
 out:
 	return res;
 err:
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 3887ed33c5fe..18f978461df5 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -9,15 +9,18 @@
 #include <linux/if_bridge.h>
 #include <linux/of_device.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_hsr.h>
 #include "xrs700x.h"
 #include "xrs700x_reg.h"
 
 #define XRS700X_MIB_INTERVAL msecs_to_jiffies(3000)
 
-#define XRS7000X_SUPPORTED_HSR_FEATURES \
-	(NETIF_F_HW_HSR_TAG_INS | NETIF_F_HW_HSR_TAG_RM | \
-	 NETIF_F_HW_HSR_FWD | NETIF_F_HW_HSR_DUP)
+static DECLARE_NETDEV_FEATURE_SET(xrs7000x_hsr_feature_set,
+				  NETIF_F_HW_HSR_TAG_INS_BIT,
+				  NETIF_F_HW_HSR_TAG_RM_BIT,
+				  NETIF_F_HW_HSR_FWD_BIT,
+				  NETIF_F_HW_HSR_DUP_BIT);
 
 #define XRS7003E_ID	0x100
 #define XRS7003F_ID	0x101
@@ -632,7 +635,8 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
-		slave->features |= XRS7000X_SUPPORTED_HSR_FEATURES;
+		netdev_active_features_set_array(slave,
+						 &xrs7000x_hsr_feature_set);
 	}
 
 	return 0;
@@ -686,7 +690,8 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
-		slave->features &= ~XRS7000X_SUPPORTED_HSR_FEATURES;
+		netdev_active_features_clear_array(slave,
+						   &xrs7000x_hsr_feature_set);
 	}
 
 	return 0;
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index f82ad7419508..6f176774efbd 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/init.h>
@@ -110,6 +111,13 @@ static const struct ethtool_ops dummy_ethtool_ops = {
 	.get_ts_info		= ethtool_op_get_ts_info,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(dummy_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LLTX_BIT);
+
 static void dummy_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -123,9 +131,8 @@ static void dummy_setup(struct net_device *dev)
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
-	dev->features	|= NETIF_F_SG | NETIF_F_FRAGLIST;
+	netdev_active_features_set_array(dev, &dummy_feature_set);
 	dev->features	|= NETIF_F_GSO_SOFTWARE;
-	dev->features	|= NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
 	dev->features	|= NETIF_F_GSO_ENCAP_ALL;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index cad4f354cc76..cb7a4bb5cf74 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -108,6 +108,7 @@ static const int multicast_filter_limit = 32;
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/mm.h>
@@ -2286,6 +2287,15 @@ static const struct net_device_ops typhoon_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(typhoon_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(typhoon_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int
 typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -2476,10 +2486,10 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * on the current 3XP firmware -- it does not respect the offload
 	 * settings -- so we only allow the user to toggle the TX processing.
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX;
-	dev->features = dev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &typhoon_hw_feature_set);
+	dev->features = dev->hw_features;
+	netdev_active_features_set_array(dev, &typhoon_feature_set);
 
 	err = register_netdev(dev);
 	if (err < 0) {
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 447dc64a17e5..dca85429a0ea 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1336,6 +1336,11 @@ static int greth_mdio_init(struct greth_private *greth)
 	return ret;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(greth_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /* Initialize the GRETH MAC */
 static int greth_of_probe(struct platform_device *ofdev)
 {
@@ -1483,8 +1488,8 @@ static int greth_of_probe(struct platform_device *ofdev)
 	GRETH_REGSAVE(regs->status, 0xFF);
 
 	if (greth->gbit_mac) {
-		dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM;
+		netdev_hw_features_zero(dev);
+		netdev_hw_features_set_array(dev, &greth_hw_feature_set);
 		dev->features = dev->hw_features | NETIF_F_HIGHDMA;
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 22fe98555b24..4a16e176248c 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -55,6 +55,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
@@ -451,6 +452,12 @@ static const struct net_device_ops ace_netdev_ops = {
 	.ndo_change_mtu		= ace_change_mtu,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(acenic_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
 static int acenic_probe_one(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -469,8 +476,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
 	ap->pdev = pdev;
 	ap->name = pci_name(pdev);
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_features_set_array(dev, &acenic_feature_set);
 
 	dev->watchdog_timeo = 5*HZ;
 	dev->min_mtu = 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..ab102769965f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -11,6 +11,7 @@
 #include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/numa.h>
 #include <linux/pci.h>
 #include <linux/utsname.h>
@@ -4010,6 +4011,11 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 	return max_num_io_queues;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ena_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 				 struct net_device *netdev)
 {
@@ -4041,11 +4047,8 @@ static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV6_CSUM_MASK)
 		dev_features |= NETIF_F_RXCSUM;
 
-	netdev->features =
-		dev_features |
-		NETIF_F_SG |
-		NETIF_F_RXHASH |
-		NETIF_F_HIGHDMA;
+	netdev->features = dev_features;
+	netdev_active_features_set_array(netdev, &ena_feature_set);
 
 	netdev->hw_features |= netdev->features;
 	netdev->vlan_features |= netdev->features;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index 0e8698928e4d..a5c4fb8aa676 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -118,6 +118,7 @@
 #include <linux/device.h>
 #include <linux/spinlock.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/io.h>
 #include <linux/notifier.h>
@@ -259,6 +260,34 @@ void xgbe_set_counts(struct xgbe_prv_data *pdata)
 	}
 }
 
+static DECLARE_NETDEV_FEATURE_SET(xgbe_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+static DECLARE_NETDEV_FEATURE_SET(xgbe_hw_enc_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(xgbe_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 {
 	struct net_device *netdev = pdata->netdev;
@@ -342,30 +371,16 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 #endif
 
 	/* Set device features */
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6 |
-			      NETIF_F_GRO |
-			      NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_HW_VLAN_CTAG_TX |
-			      NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &xgbe_hw_feature_set);
 
 	if (pdata->hw_feat.rss)
 		netdev->hw_features |= NETIF_F_RXHASH;
 
 	if (pdata->hw_feat.vxn) {
-		netdev->hw_enc_features = NETIF_F_SG |
-					  NETIF_F_IP_CSUM |
-					  NETIF_F_IPV6_CSUM |
-					  NETIF_F_RXCSUM |
-					  NETIF_F_TSO |
-					  NETIF_F_TSO6 |
-					  NETIF_F_GRO |
-					  NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_enc_features_zero(netdev);
+		netdev_hw_enc_features_set_array(netdev,
+						 &xgbe_hw_enc_feature_set);
 
 		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
 				       NETIF_F_GSO_UDP_TUNNEL_CSUM;
@@ -373,11 +388,7 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 		netdev->udp_tunnel_nic_info = xgbe_get_udp_tunnel_info();
 	}
 
-	netdev->vlan_features |= NETIF_F_SG |
-				 NETIF_F_IP_CSUM |
-				 NETIF_F_IPV6_CSUM |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6;
+	netdev_vlan_features_set_array(netdev, &xgbe_vlan_feature_set);
 
 	netdev->features |= netdev->hw_features;
 	pdata->netdev_features = netdev->features;
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 53dc8d5fede8..49a35bd4c16d 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/gpio.h>
+#include <linux/netdev_features_helper.h>
 #include "xgene_enet_main.h"
 #include "xgene_enet_hw.h"
 #include "xgene_enet_sgmac.h"
@@ -2012,6 +2013,12 @@ static const struct of_device_id xgene_enet_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, xgene_enet_of_match);
 
+static DECLARE_NETDEV_FEATURE_SET(xgene_vlan_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_SG_BIT);
+
 static int xgene_enet_probe(struct platform_device *pdev)
 {
 	struct net_device *ndev;
@@ -2034,10 +2041,7 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 	xgene_enet_set_ethtool_ops(ndev);
-	ndev->features |= NETIF_F_IP_CSUM |
-			  NETIF_F_GSO |
-			  NETIF_F_GRO |
-			  NETIF_F_SG;
+	netdev_active_features_set_array(ndev, &xgene_vlan_feature_set);
 
 	of_id = of_match_device(xgene_enet_of_match, &pdev->dev);
 	if (of_id) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index e11cc29d3264..2a726e6213b4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -20,6 +20,7 @@
 
 #include <linux/moduleparam.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/timer.h>
 #include <linux/cpu.h>
@@ -368,6 +369,15 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 	return err;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(aq_nic_vlan_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 void aq_nic_ndev_init(struct aq_nic_s *self)
 {
 	const struct aq_hw_caps_s *aq_hw_caps = self->aq_nic_cfg.aq_hw_caps;
@@ -375,9 +385,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 
 	self->ndev->hw_features |= aq_hw_caps->hw_features;
 	self->ndev->features = aq_hw_caps->hw_features;
-	self->ndev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-				     NETIF_F_RXHASH | NETIF_F_SG |
-				     NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_vlan_features_set_array(self->ndev, &aq_nic_vlan_feature_set);
 	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 6ba5b024a7be..9309d371b8da 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -19,6 +19,7 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/skbuff.h>
@@ -33,6 +34,11 @@ static int msg_enable = NETIF_MSG_PROBE |
 static const char *no_regs_list = "80018001,e1918001,8001a001,fc0d0000";
 unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsigned long) * 8)];
 
+static DECLARE_NETDEV_FEATURE_SET(ax88796c_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+static netdev_features_t ax88796c_features __ro_after_init;
+
 module_param(msg_enable, int, 0444);
 MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for bitmap)");
 
@@ -920,12 +926,12 @@ ax88796c_set_features(struct net_device *ndev, netdev_features_t features)
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
 	netdev_features_t changed = features ^ ndev->features;
 
-	if (!(changed & (NETIF_F_RXCSUM | NETIF_F_HW_CSUM)))
+	if (!(changed & ax88796c_features))
 		return 0;
 
 	ndev->features = features;
 
-	if (changed & (NETIF_F_RXCSUM | NETIF_F_HW_CSUM))
+	if (changed & ax88796c_features)
 		ax88796c_set_csums(ax_local);
 
 	return 0;
@@ -1023,8 +1029,8 @@ static int ax88796c_probe(struct spi_device *spi)
 	ndev->irq = spi->irq;
 	ndev->netdev_ops = &ax88796c_netdev_ops;
 	ndev->ethtool_ops = &ax88796c_ethtool_ops;
-	ndev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
-	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	ndev->hw_features |= ax88796c_features;
+	ndev->features |= ax88796c_features;
 	ndev->needed_headroom = TX_OVERHEAD;
 	ndev->needed_tailroom = TX_EOP_SIZE;
 
@@ -1138,6 +1144,11 @@ static struct spi_driver ax88796c_spi_driver = {
 	.id_table = asix_id,
 };
 
+static void __init ax88796c_features_init(void)
+{
+	netdev_features_set_array(&ax88796c_feature_set, &ax88796c_features);
+}
+
 static __init int ax88796c_spi_init(void)
 {
 	int ret;
@@ -1150,6 +1161,8 @@ static __init int ax88796c_spi_init(void)
 		pr_err("Invalid bitmap description, masking all registers\n");
 	}
 
+	ax88796c_features_init();
+
 	return spi_register_driver(&ax88796c_spi_driver);
 }
 
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index a89b93cb4e26..7f5cb50f4b66 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -42,6 +42,7 @@
 #include <linux/aer.h>
 #include <linux/bitops.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <net/ip6_checksum.h>
 #include <linux/crc32.h>
@@ -1712,6 +1713,13 @@ static const struct net_device_ops alx_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(alx_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *netdev;
@@ -1821,11 +1829,8 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_HW_CSUM |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &alx_hw_feature_set);
 
 	if (alx_get_perm_macaddr(hw, hw->perm_addr)) {
 		dev_warn(&pdev->dev,
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 43d821fe7a54..6a1f8191a336 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index be4b1f8eef29..220253cec3c2 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2618,6 +2618,13 @@ static const struct net_device_ops atl1c_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(atl1c_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 {
 	SET_NETDEV_DEV(netdev, &pdev->dev);
@@ -2629,11 +2636,8 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	atl1c_set_ethtool_ops(netdev);
 
 	/* TODO: add when ready */
-	netdev->hw_features =	NETIF_F_SG		|
-				NETIF_F_HW_CSUM		|
-				NETIF_F_HW_VLAN_CTAG_RX	|
-				NETIF_F_TSO		|
-				NETIF_F_TSO6;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &atl1c_hw_feature_set);
 	netdev->features =	netdev->hw_features	|
 				NETIF_F_HW_VLAN_CTAG_TX;
 	return 0;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index 9fcad783c939..007eef2cc9fc 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 57a51fb7746c..0aaca5a1f87c 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2255,6 +2255,12 @@ static const struct net_device_ops atl1e_netdev_ops = {
 
 };
 
+static DECLARE_NETDEV_FEATURE_SET(atl1e_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
 static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 {
 	SET_NETDEV_DEV(netdev, &pdev->dev);
@@ -2269,8 +2275,8 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 			  (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 	atl1e_set_ethtool_ops(netdev);
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO |
-			      NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &atl1e_hw_feature_set);
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_TX;
 	/* not enabled by default */
 	netdev->hw_features |= NETIF_F_RXALL | NETIF_F_RXFCS;
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index ff1fe09abf9f..c46d3e7ae89f 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/pm.h>
@@ -2891,6 +2892,18 @@ static const struct net_device_ops atl1_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(atl1_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(atl1_hw_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
 /**
  * atl1_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -2987,12 +3000,11 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_common;
 
-	netdev->features = NETIF_F_HW_CSUM;
-	netdev->features |= NETIF_F_SG;
-	netdev->features |= (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_array(netdev, &atl1_feature_set);
 
-	netdev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_TSO |
-			      NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &atl1_hw_feature_set);
 
 	/* is this valid? see atl1_setup_mac_ctrl() */
 	netdev->features |= NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 47fc8e6963d5..05a0c169e418 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
@@ -153,17 +154,25 @@ static void bcm_sysport_set_rx_csum(struct net_device *dev,
 	rxchk_writel(priv, reg, RXCHK_CONTROL);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(bcm_sysport_tx_csum_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
 static void bcm_sysport_set_tx_csum(struct net_device *dev,
 				    netdev_features_t wanted)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
+	netdev_features_t tx_csum_features;
 	u32 reg;
 
+	netdev_features_zero(&tx_csum_features);
+	netdev_features_set_array(&bcm_sysport_tx_csum_feature_set,
+				  &tx_csum_features);
 	/* Hardware transmit checksum requires us to enable the Transmit status
 	 * block prepended to the packet contents
 	 */
-	priv->tsb_en = !!(wanted & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				    NETIF_F_HW_VLAN_CTAG_TX));
+	priv->tsb_en = !!(wanted & tx_csum_features);
 	reg = tdma_readl(priv, TDMA_CONTROL);
 	if (priv->tsb_en)
 		reg |= tdma_control_bit(priv, TSB_EN);
@@ -2453,6 +2462,13 @@ static const struct of_device_id bcm_sysport_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, bcm_sysport_of_match);
 
+DECLARE_NETDEV_FEATURE_SET(bcm_feature_set,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_HIGHDMA_BIT,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
 static int bcm_sysport_probe(struct platform_device *pdev)
 {
 	const struct bcm_sysport_hw_params *params;
@@ -2566,9 +2582,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	dev->netdev_ops = &bcm_sysport_netdev_ops;
 	netif_napi_add(dev, &priv->napi, bcm_sysport_poll, 64);
 
-	dev->features |= NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
-			 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			 NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_active_features_set_array(dev, &bcm_feature_set);
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 	dev->max_mtu = UMAC_MAX_MTU_SIZE;
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 2dfc1e32bbb3..523cadd48669 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -13,6 +13,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/bcm47xx_nvram.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <net/dsa.h>
@@ -1485,6 +1486,11 @@ struct bgmac *bgmac_alloc(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(bgmac_alloc);
 
+static DECLARE_NETDEV_FEATURE_SET(bgmac_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+
 int bgmac_enet_probe(struct bgmac *bgmac)
 {
 	struct net_device *net_dev = bgmac->net_dev;
@@ -1535,7 +1541,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 		goto err_dma_free;
 	}
 
-	net_dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_active_features_zero(net_dev);
+	netdev_active_features_set_array(net_dev, &bgmac_feature_set);
 	net_dev->hw_features = net_dev->features;
 	net_dev->vlan_features = net_dev->features;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index b97ed9b5f685..0e779e5dee9a 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
@@ -8544,6 +8545,14 @@ static const struct net_device_ops bnx2_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(bnx2_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int
 bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -8580,9 +8589,8 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	eth_hw_addr_set(dev, bp->mac_addr);
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-		NETIF_F_TSO | NETIF_F_TSO_ECN |
-		NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &bnx2_hw_feature_set);
 
 	if (BNX2_CHIP(bp) == BNX2_CHIP_5709)
 		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 962253db25b8..845d31294667 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -32,6 +32,7 @@
 #include <linux/aer.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
@@ -13045,6 +13046,55 @@ static void bnx2x_disable_pcie_error_reporting(struct bnx2x *bp)
 	}
 }
 
+static DECLARE_NETDEV_FEATURE_SET(bnx2x_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_GRO_HW_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bnx2x_hw_gso_feature_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bnx2x_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bnx2x_gso_partial_feature_set,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bnx2x_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 			  struct net_device *dev, unsigned long board_type)
 {
@@ -13197,34 +13247,23 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-		NETIF_F_RXCSUM | NETIF_F_LRO | NETIF_F_GRO | NETIF_F_GRO_HW |
-		NETIF_F_RXHASH | NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &bnx2x_hw_feature_set);
 	if (!chip_is_e1x) {
-		dev->hw_features |= NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM |
-				    NETIF_F_GSO_IPXIP4 |
-				    NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
-
-		dev->hw_enc_features =
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-			NETIF_F_GSO_IPXIP4 |
-			NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM |
-			NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-			NETIF_F_GSO_PARTIAL;
-
-		dev->gso_partial_features = NETIF_F_GSO_GRE_CSUM |
-					    NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_features_set_array(dev, &bnx2x_hw_gso_feature_set);
+
+		netdev_hw_enc_features_zero(dev);
+		netdev_hw_enc_features_set_array(dev, &bnx2x_hw_enc_feature_set);
+
+		netdev_gso_partial_features_zero(dev);
+		netdev_gso_partial_features_set_array(dev, &bnx2x_gso_partial_feature_set);
 
 		if (IS_PF(bp))
 			dev->udp_tunnel_nic_info = &bnx2x_udp_tunnels;
 	}
 
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_HIGHDMA;
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_array(dev, &bnx2x_vlan_feature_set);
 
 	if (IS_PF(bp)) {
 		if (chip_is_e1x)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ba0f1ffac507..825bf829b36a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
@@ -13517,6 +13518,38 @@ void bnxt_print_device_info(struct bnxt *bp)
 	pcie_print_link_status(bp->pdev);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(bnxt_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_GRO_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bnxt_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT);
+static DECLARE_NETDEV_FEATURE_SET(bnxt_gso_partial_feature_set,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT);
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *dev;
@@ -13594,27 +13627,18 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto init_err_pci_clean;
 	}
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
-			   NETIF_F_TSO | NETIF_F_TSO6 |
-			   NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			   NETIF_F_GSO_IPXIP4 |
-			   NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM |
-			   NETIF_F_GSO_PARTIAL | NETIF_F_RXHASH |
-			   NETIF_F_RXCSUM | NETIF_F_GRO;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &bnxt_hw_feature_set);
 
 	if (BNXT_SUPPORTS_TPA(bp))
 		dev->hw_features |= NETIF_F_LRO;
 
-	dev->hw_enc_features =
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM |
-			NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_PARTIAL;
+	netdev_hw_enc_features_zero(dev);
+	netdev_hw_enc_features_set_array(dev, &bnxt_hw_enc_feature_set);
 	dev->udp_tunnel_nic_info = &bnxt_udp_tunnels;
 
-	dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_GRE_CSUM;
+	netdev_gso_partial_features_zero(dev);
+	netdev_gso_partial_features_set_array(dev, &bnxt_gso_partial_feature_set);
 	dev->vlan_features = dev->hw_features | NETIF_F_HIGHDMA;
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
 		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 8309fb993cdb..0d41ae12e262 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -28,6 +28,7 @@
 #include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
@@ -3969,6 +3970,12 @@ static const struct of_device_id bcmgenet_match[] = {
 };
 MODULE_DEVICE_TABLE(of, bcmgenet_match);
 
+static DECLARE_NETDEV_FEATURE_SET(bcmgenet_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int bcmgenet_probe(struct platform_device *pdev)
 {
 	struct bcmgenet_platform_data *pd = pdev->dev.platform_data;
@@ -4025,8 +4032,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	priv->msg_enable = netif_msg_init(-1, GENET_MSG_DEFAULT);
 
 	/* Set default features */
-	dev->features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			 NETIF_F_RXCSUM;
+	netdev_active_features_set_array(dev, &bcmgenet_feature_set);
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 29dd0f93d6c0..786df1e64947 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -10,6 +10,7 @@
  */
 #include <linux/bitops.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/in.h>
@@ -3417,22 +3418,40 @@ static const struct net_device_ops bnad_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(bnad_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bnad_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(bnad_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static void
 bnad_netdev_init(struct bnad *bnad)
 {
 	struct net_device *netdev = bnad->netdev;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
-
-	netdev->vlan_features = NETIF_F_SG | NETIF_F_HIGHDMA |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &bnad_hw_feature_set);
+	netdev_vlan_features_zero(netdev);
+	netdev_vlan_features_set_array(netdev, &bnad_vlan_feature_set);
 
-	netdev->features |= netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HIGHDMA;
+	netdev->features |= netdev->hw_features;
+	netdev_active_features_set_array(netdev, &bnad_feature_set);
 
 	netdev->mem_start = bnad->mmio_start;
 	netdev->mem_end = bnad->mmio_start + bnad->mmio_len - 1;
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 1281d1565ef8..415f61527650 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -14,6 +14,7 @@
 #include <linux/if.h>
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/slab.h>
 
 /* XGMAC Register definitions */
@@ -1682,6 +1683,14 @@ static const struct ethtool_ops xgmac_ethtool_ops = {
 	.get_link_ksettings = xgmac_ethtool_get_link_ksettings,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(xgmac_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(xgmac_csum_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /**
  * xgmac_probe
  * @pdev: platform device pointer
@@ -1774,10 +1783,10 @@ static int xgmac_probe(struct platform_device *pdev)
 	if (device_can_wakeup(priv->device))
 		priv->wolopts = WAKE_MAGIC;	/* Magic Frame as default */
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &xgmac_hw_feature_set);
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
-		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				     NETIF_F_RXCSUM;
+		netdev_hw_features_set_array(ndev, &xgmac_csum_feature_set);
 	ndev->features |= ndev->hw_features;
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index bee35ce60171..9c9c8dee0c7b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/firmware.h>
+#include <linux/netdev_features_helper.h>
 #include <net/vxlan.h>
 #include <linux/kthread.h>
 #include "liquidio_common.h"
@@ -3317,6 +3318,27 @@ static int lio_nic_info(struct octeon_recv_info *recv_info, void *buf)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(liquidio_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_LRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(liquidio_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_LRO_BIT);
+
 /**
  * setup_nic_devices - Setup network interfaces
  * @octeon_dev:  octeon device
@@ -3555,26 +3577,18 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		if (OCTEON_CN23XX_PF(octeon_dev) ||
 		    OCTEON_CN6XXX(octeon_dev)) {
-			lio->dev_capability = NETIF_F_HIGHDMA
-					      | NETIF_F_IP_CSUM
-					      | NETIF_F_IPV6_CSUM
-					      | NETIF_F_SG | NETIF_F_RXCSUM
-					      | NETIF_F_GRO
-					      | NETIF_F_TSO | NETIF_F_TSO6
-					      | NETIF_F_LRO;
+			netdev_features_zero(&lio->dev_capability);
+			netdev_features_set_array(&liquidio_feature_set,
+						  &lio->dev_capability);
 		}
 		netif_set_tso_max_size(netdev, OCTNIC_GSO_MAX_SIZE);
 
 		/*  Copy of transmit encapsulation capabilities:
 		 *  TSO, TSO6, Checksums for this device
 		 */
-		lio->enc_dev_capability = NETIF_F_IP_CSUM
-					  | NETIF_F_IPV6_CSUM
-					  | NETIF_F_GSO_UDP_TUNNEL
-					  | NETIF_F_HW_CSUM | NETIF_F_SG
-					  | NETIF_F_RXCSUM
-					  | NETIF_F_TSO | NETIF_F_TSO6
-					  | NETIF_F_LRO;
+		netdev_features_zero(&lio->enc_dev_capability);
+		netdev_features_set_array(&liquidio_enc_feature_set,
+					  &lio->enc_dev_capability);
 
 		netdev->hw_enc_features = (lio->enc_dev_capability &
 					   ~NETIF_F_LRO);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index ac196883f07e..9e0c176ea7af 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/netdev_features_helper.h>
 #include <net/vxlan.h>
 #include "liquidio_common.h"
 #include "octeon_droq.h"
@@ -1926,6 +1927,27 @@ static int lio_nic_info(struct octeon_recv_info *recv_info, void *buf)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(lio_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_LRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(lio_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_LRO_BIT);
+
 /**
  * setup_nic_devices - Setup network interfaces
  * @octeon_dev:  octeon device
@@ -2088,24 +2110,16 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		lio->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
-		lio->dev_capability = NETIF_F_HIGHDMA
-				      | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
-				      | NETIF_F_SG | NETIF_F_RXCSUM
-				      | NETIF_F_TSO | NETIF_F_TSO6
-				      | NETIF_F_GRO
-				      | NETIF_F_LRO;
+		netdev_features_zero(&lio->dev_capability);
+		netdev_features_set_array(&lio_feature_set, &lio->dev_capability);
 		netif_set_tso_max_size(netdev, OCTNIC_GSO_MAX_SIZE);
 
 		/* Copy of transmit encapsulation capabilities:
 		 * TSO, TSO6, Checksums for this device
 		 */
-		lio->enc_dev_capability = NETIF_F_IP_CSUM
-					  | NETIF_F_IPV6_CSUM
-					  | NETIF_F_GSO_UDP_TUNNEL
-					  | NETIF_F_HW_CSUM | NETIF_F_SG
-					  | NETIF_F_RXCSUM
-					  | NETIF_F_TSO | NETIF_F_TSO6
-					  | NETIF_F_LRO;
+		netdev_features_zero(&lio->enc_dev_capability);
+		netdev_features_set_array(&lio_enc_feature_set,
+					  &lio->enc_dev_capability);
 
 		netdev->hw_enc_features =
 		    (lio->enc_dev_capability & ~NETIF_F_LRO);
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_network.h b/drivers/net/ethernet/cavium/liquidio/octeon_network.h
index ebe56bd8849b..61e5e5782f5b 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_network.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_network.h
@@ -147,13 +147,13 @@ struct lio {
 	u32 msg_enable;
 
 	/** Copy of Interface capabilities: TSO, TSO6, LRO, Chescksums . */
-	u64 dev_capability;
+	netdev_features_t dev_capability;
 
 	/* Copy of transmit encapsulation capabilities:
 	 * TSO, TSO6, Checksums for this device for Kernel
 	 * 3.10.0 onwards
 	 */
-	u64 enc_dev_capability;
+	netdev_features_t enc_dev_capability;
 
 	/** Copy of beacaon reg in phy */
 	u32 phy_beacon_val;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 768ea426d49f..c6923ecabb63 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -7,6 +7,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -2092,6 +2093,22 @@ static const struct net_device_ops nicvf_netdev_ops = {
 	.ndo_set_rx_mode        = nicvf_set_rx_mode,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(nicvf_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(nicvf_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
@@ -2203,18 +2220,16 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_unregister_interrupts;
 
-	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_SG |
-			       NETIF_F_TSO | NETIF_F_GRO | NETIF_F_TSO6 |
-			       NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			       NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &nicvf_hw_feature_set);
 
 	netdev->hw_features |= NETIF_F_RXHASH;
 
 	netdev->features |= netdev->hw_features;
 	netdev->hw_features |= NETIF_F_LOOPBACK;
 
-	netdev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_vlan_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &nicvf_vlan_feature_set);
 
 	netdev->netdev_ops = &nicvf_netdev_ops;
 	netdev->watchdog_timeo = NICVF_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index f4054d2553ea..44404b711e09 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -39,6 +39,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/mii.h>
@@ -942,6 +943,18 @@ static const struct net_device_ops cxgb_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(cxgb_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(cxgb_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned long mmio_start, mmio_len;
@@ -1031,10 +1044,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->mem_start = mmio_start;
 		netdev->mem_end = mmio_start + mmio_len - 1;
 		netdev->ml_priv = adapter;
-		netdev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM;
-		netdev->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_LLTX | NETIF_F_HIGHDMA;
+		netdev_hw_features_set_array(netdev, &cxgb_hw_feature_set);
+		netdev_active_features_set_array(netdev, &cxgb_feature_set);
 
 		if (vlan_tso_capable(adapter)) {
 			netdev->features |=
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 174b1e156669..80f65f491b3f 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -37,6 +37,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/mdio.h>
@@ -3199,15 +3200,29 @@ static void cxgb3_init_iscsi_mac(struct net_device *dev)
 	pi->iscsic.mac_addr[3] |= 0x80;
 }
 
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN)
-#define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
-			NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
+static DECLARE_NETDEV_FEATURE_SET(cxgb_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(cxgb_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int i, err;
 	resource_size_t mmio_start, mmio_len;
 	const struct adapter_info *ai;
 	struct adapter *adapter = NULL;
+	netdev_features_t vlan_feat;
 	struct port_info *pi;
 
 	if (!cxgb3_wq) {
@@ -3303,11 +3318,13 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->irq = pdev->irq;
 		netdev->mem_start = mmio_start;
 		netdev->mem_end = mmio_start + mmio_len - 1;
-		netdev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_features_zero(netdev);
+		netdev_hw_features_set_array(netdev, &cxgb_hw_feature_set);
 		netdev->features |= netdev->hw_features |
 				    NETIF_F_HW_VLAN_CTAG_TX;
-		netdev->vlan_features |= netdev->features & VLAN_FEAT;
+		netdev_features_zero(&vlan_feat);
+		netdev_features_set_array(&cxgb_vlan_feature_set, &vlan_feat);
+		netdev->vlan_features |= netdev->features & vlan_feat;
 
 		netdev->features |= NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index d0061921529f..f40e6964de89 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -50,6 +50,7 @@
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/rtnetlink.h>
@@ -6205,10 +6206,41 @@ static void free_some_resources(struct adapter *adapter)
 		t4_fw_bye(adapter, adapter->pf);
 }
 
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN | \
-		   NETIF_F_GSO_UDP_L4)
-#define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
-		   NETIF_F_GRO | NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
+static DECLARE_NETDEV_FEATURE_SET(cxgb4_tso_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT);
+static DECLARE_NETDEV_FEATURE_SET(cxgb4_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(cxgb4_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_TC_BIT,
+				  NETIF_F_NTUPLE_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(cxgb4_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(cxgb4_new_hw_feature_set,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_HW_TLS_RECORD_BIT);
+
 #define SEGMENT_SIZE 128
 
 static int t4_get_chip_type(struct adapter *adap, int ver)
@@ -6598,6 +6630,8 @@ static const struct xfrmdev_ops cxgb4_xfrmdev_ops = {
 
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
+	netdev_features_t vlan_features;
+	netdev_features_t tso_features;
 	struct net_device *netdev;
 	struct adapter *adapter;
 	static int adap_idx = 1;
@@ -6809,30 +6843,26 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pi->port_id = i;
 		netdev->irq = pdev->irq;
 
-		netdev->hw_features = NETIF_F_SG | TSO_FLAGS |
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_TC | NETIF_F_NTUPLE | NETIF_F_HIGHDMA;
+		netdev_features_zero(&tso_features);
+		netdev_features_set_array(&cxgb4_tso_feature_set, &tso_features);
+		netdev->hw_features = tso_features;
+		netdev_hw_features_set_array(netdev, &cxgb4_hw_feature_set);
 
 		if (chip_ver > CHELSIO_T5) {
-			netdev->hw_enc_features |= NETIF_F_IP_CSUM |
-						   NETIF_F_IPV6_CSUM |
-						   NETIF_F_RXCSUM |
-						   NETIF_F_GSO_UDP_TUNNEL |
-						   NETIF_F_GSO_UDP_TUNNEL_CSUM |
-						   NETIF_F_TSO | NETIF_F_TSO6;
+			netdev_hw_enc_features_set_array(netdev,
+							 &cxgb4_hw_enc_feature_set);
 
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					       NETIF_F_HW_TLS_RECORD;
+			netdev_hw_features_set_array(netdev,
+						     &cxgb4_new_hw_feature_set);
 
 			if (adapter->rawf_cnt)
 				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
 		}
 
 		netdev->features |= netdev->hw_features;
-		netdev->vlan_features = netdev->features & VLAN_FEAT;
+		vlan_features = tso_features;
+		netdev_features_set_array(&cxgb4_vlan_feature_set, &vlan_features);
+		netdev->vlan_features = netdev->features & vlan_features;
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
 			netdev->hw_features |= NETIF_F_HW_TLS_TX;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index c2822e635f89..2d6e1b42b36b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -41,6 +41,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/debugfs.h>
 #include <linux/ethtool.h>
@@ -1921,9 +1922,26 @@ static void cxgb4vf_get_wol(struct net_device *dev,
 /*
  * TCP Segmentation Offload flags which we support.
  */
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN)
-#define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
-		   NETIF_F_GRO | NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
+static DECLARE_NETDEV_FEATURE_SET(cxgb4vf_tso_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(cxgb4vf_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(cxgb4vf_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 static const struct ethtool_ops cxgb4vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
@@ -2895,6 +2913,8 @@ static unsigned int cxgb4vf_get_port_mask(struct adapter *adapter)
 static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *ent)
 {
+	netdev_features_t vlan_features;
+	netdev_features_t tso_features;
 	struct adapter *adapter;
 	struct net_device *netdev;
 	struct port_info *pi;
@@ -3067,11 +3087,16 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		pi->xact_addr_filt = -1;
 		netdev->irq = pdev->irq;
 
-		netdev->hw_features = NETIF_F_SG | TSO_FLAGS | NETIF_F_GRO |
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_features_zero(&tso_features);
+		netdev_features_set_array(&cxgb4vf_tso_feature_set,
+					  &tso_features);
+		netdev->hw_features = tso_features;
+		netdev_hw_features_set_array(netdev, &cxgb4vf_hw_feature_set);
 		netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
-		netdev->vlan_features = netdev->features & VLAN_FEAT;
+		vlan_features = tso_features;
+		netdev_features_set_array(&cxgb4vf_vlan_feature_set,
+					  &vlan_features);
+		netdev->vlan_features = netdev->features & vlan_features;
 
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 		netdev->min_mtu = 81;
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 21ba6e893072..8d631b2cba23 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/mii.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -738,6 +739,10 @@ static const struct net_device_ops ep93xx_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(ep93xx_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+
 static struct net_device *ep93xx_dev_alloc(struct ep93xx_eth_data *data)
 {
 	struct net_device *dev;
@@ -751,7 +756,7 @@ static struct net_device *ep93xx_dev_alloc(struct ep93xx_eth_data *data)
 	dev->ethtool_ops = &ep93xx_ethtool_ops;
 	dev->netdev_ops = &ep93xx_netdev_ops;
 
-	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	netdev_active_features_set_array(dev, &ep93xx_feature_set);
 
 	return dev;
 }
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 372fb7b3a282..276fa370ce50 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -27,6 +27,7 @@
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/if.h>
 #include <linux/if_ether.h>
@@ -2665,6 +2666,15 @@ static void enic_iounmap(struct enic *enic)
 			iounmap(enic->bar[i].vaddr);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(enic_hw_enc_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
 static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
@@ -2904,13 +2914,8 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		u64 patch_level;
 		u64 a1 = 0;
 
-		netdev->hw_enc_features |= NETIF_F_RXCSUM		|
-					   NETIF_F_TSO			|
-					   NETIF_F_TSO6			|
-					   NETIF_F_TSO_ECN		|
-					   NETIF_F_GSO_UDP_TUNNEL	|
-					   NETIF_F_HW_CSUM		|
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_enc_features_set_array(netdev,
+						 &enic_hw_enc_feature_set);
 		netdev->hw_features |= netdev->hw_enc_features;
 		/* get bit mask from hw about supported offload bit level
 		 * BIT(0) = fw supports patch_level 0
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 9e6de2f968fa..d2b0296b426a 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -36,6 +36,7 @@
 #include <linux/ethtool.h>
 #include <linux/tcp.h>
 #include <linux/u64_stats_sync.h>
+#include <linux/netdev_features_helper.h>
 
 #include <linux/in.h>
 #include <linux/ip.h>
@@ -78,9 +79,16 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 			      GMAC0_SWTQ00_FIN_INT_BIT)
 #define GMAC0_IRQ4_8 (GMAC0_MIB_INT_BIT | GMAC0_RX_OVERRUN_INT_BIT)
 
-#define GMAC_OFFLOAD_FEATURES (NETIF_F_SG | NETIF_F_IP_CSUM | \
-		NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | \
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6)
+static DECLARE_NETDEV_FEATURE_SET(gmac_offload_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT);
+static netdev_features_t gmac_offload_features __ro_after_init;
+#define GMAC_OFFLOAD_FEATURES gmac_offload_features
 
 /**
  * struct gmac_queue_page - page buffer per-page info
@@ -2610,6 +2618,12 @@ static struct platform_driver gemini_ethernet_driver = {
 	.remove = gemini_ethernet_remove,
 };
 
+static void __init gmac_netdev_features_init(void)
+{
+	netdev_features_set_array(&gmac_offload_feature_set,
+				  &gmac_offload_features);
+}
+
 static int __init gemini_ethernet_module_init(void)
 {
 	int ret;
@@ -2624,6 +2638,8 @@ static int __init gemini_ethernet_module_init(void)
 		return ret;
 	}
 
+	gmac_netdev_features_init();
+
 	return 0;
 }
 module_init(gemini_ethernet_module_init);
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 414362febbb9..964e7d6111df 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -18,6 +18,7 @@
 #include <asm/div64.h>
 #include <linux/aer.h>
 #include <linux/if_bridge.h>
+#include <linux/netdev_features_helper.h>
 #include <net/busy_poll.h>
 #include <net/vxlan.h>
 
@@ -3967,6 +3968,13 @@ static void be_cancel_err_detection(struct be_adapter *adapter)
 	}
 }
 
+DECLARE_NETDEV_FEATURE_SET(be_hw_enc_feature_set,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_BIT);
+
 /* VxLAN offload Notes:
  *
  * The stack defines tunnel offload flags (hw_enc_features) for IP and doesn't
@@ -3999,9 +4007,7 @@ static int be_vxlan_set_port(struct net_device *netdev, unsigned int table,
 	}
 	adapter->vxlan_port = ti->port;
 
-	netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				   NETIF_F_TSO | NETIF_F_TSO6 |
-				   NETIF_F_GSO_UDP_TUNNEL;
+	netdev_hw_enc_features_set_array(netdev, &be_hw_enc_feature_set);
 
 	dev_info(dev, "Enabled VxLAN offloads for UDP port %d\n",
 		 be16_to_cpu(ti->port));
@@ -5182,23 +5188,40 @@ static const struct net_device_ops be_netdev_ops = {
 	.ndo_get_phys_port_id   = be_get_phys_port_id,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(be_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(be_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(be_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+
 static void be_netdev_init(struct net_device *netdev)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 
-	netdev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-		NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_hw_features_set_array(netdev, &be_hw_feature_set);
 	if ((be_if_cap_flags(adapter) & BE_IF_FLAGS_RSS))
 		netdev->hw_features |= NETIF_F_RXHASH;
 
-	netdev->features |= netdev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HIGHDMA;
+	netdev->features |= netdev->hw_features;
+	netdev_active_features_set_array(netdev, &be_feature_set);
 
-	netdev->vlan_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_vlan_features_set_array(netdev, &be_vlan_feature_set);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index c03663785a8d..8c95ad9df5e5 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1777,6 +1777,14 @@ static bool ftgmac100_has_child_node(struct device_node *np, const char *name)
 	return ret;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ftgmac100_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
 static int ftgmac100_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -1931,9 +1939,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	priv->tx_q_entries = priv->new_tx_q_entries = DEF_TX_QUEUE_ENTRIES;
 
 	/* Base feature set */
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-		NETIF_F_GRO | NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &ftgmac100_hw_feature_set);
 
 	if (priv->use_ncsi)
 		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 45634579adb6..545e2b1afad7 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -20,6 +20,7 @@
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/net.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/if_ether.h>
@@ -197,6 +198,14 @@ static int dpaa_rx_extra_headroom;
 #define dpaa_get_max_mtu()	\
 	(dpaa_max_frm - (VLAN_ETH_HLEN + ETH_FCS_LEN))
 
+static DECLARE_NETDEV_FEATURE_SET(dpaa_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static int dpaa_netdev_init(struct net_device *net_dev,
 			    const struct net_device_ops *dpaa_ops,
 			    u16 tx_timeout)
@@ -224,10 +233,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
 
-	net_dev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_LLTX | NETIF_F_RXHASH);
-
-	net_dev->hw_features |= NETIF_F_SG | NETIF_F_HIGHDMA;
+	netdev_hw_features_set_array(net_dev, &dpaa_hw_feature_set);
 	/* The kernels enables GSO automatically, if we declare NETIF_F_SG.
 	 * For conformity, we'll still declare GSO explicitly.
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cd9ec80522e7..d3c51e1a7c82 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -9,6 +9,7 @@
 #include <linux/of_net.h>
 #include <linux/interrupt.h>
 #include <linux/msi.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/kthread.h>
 #include <linux/iommu.h>
 #include <linux/fsl/mc.h>
@@ -4327,6 +4328,16 @@ static int dpaa2_eth_set_mac_addr(struct dpaa2_eth_priv *priv)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(dpaa2_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_HW_TC_BIT,
+				  NETIF_F_TSO_BIT);
+
 static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 {
 	struct device *dev = net_dev->dev.parent;
@@ -4388,10 +4399,8 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	net_dev->priv_flags &= ~not_supported;
 
 	/* Features */
-	net_dev->features = NETIF_F_RXCSUM |
-			    NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_SG | NETIF_F_HIGHDMA |
-			    NETIF_F_LLTX | NETIF_F_HW_TC | NETIF_F_TSO;
+	netdev_active_features_zero(net_dev);
+	netdev_active_features_set_array(net_dev, &dpaa2_feature_set);
 	net_dev->gso_max_segs = DPAA2_ETH_ENQUEUE_MAX_FDS;
 	net_dev->hw_features = net_dev->features;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index e507e9065214..87ae011633ba 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3238,6 +3238,11 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(dpaa2_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				  NETIF_F_HW_TC_BIT);
+
 static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 				   u16 port_idx)
 {
@@ -3280,9 +3285,8 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	/* The DPAA2 switch's ingress path depends on the VLAN table,
 	 * thus we are not able to disable VLAN filtering.
 	 */
-	port_netdev->features = NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_HW_VLAN_STAG_FILTER |
-				NETIF_F_HW_TC;
+	netdev_active_features_zero(port_netdev);
+	netdev_active_features_set_array(port_netdev, &dpaa2_feature_set);
 
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 0002dca4d417..e7d92ac769e9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -11,6 +11,7 @@
 #define __ETHSW_H
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c4a0e836d4f0..b8daac778c64 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -4,6 +4,7 @@
 #include <asm/unaligned.h>
 #include <linux/mdio.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/fsl/enetc_mdio.h>
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
@@ -744,6 +745,31 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_xdp_xmit		= enetc_xdp_xmit,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(enetc_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_LOOPBACK_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(enetc_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(enetc_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 				  const struct net_device_ops *ndev_ops)
 {
@@ -761,16 +787,12 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK |
-			    NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
-	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
-			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
-	ndev->vlan_features = NETIF_F_SG | NETIF_F_HW_CSUM |
-			      NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &enetc_hw_feature_set);
+	netdev_active_features_zero(ndev);
+	netdev_active_features_set_array(ndev, &enetc_feature_set);
+	netdev_vlan_features_zero(ndev);
+	netdev_vlan_features_set_array(ndev, &enetc_vlan_feature_set);
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 17924305afa2..a4eab1e1e590 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -2,6 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include "enetc.h"
 
 #define ENETC_DRV_NAME_STR "ENETC VF driver"
@@ -103,6 +104,29 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_setup_tc		= enetc_setup_tc,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(enetc_vf_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(enetc_vf_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(enetc_vf_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 				  const struct net_device_ops *ndev_ops)
 {
@@ -120,16 +144,12 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
-	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
-			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
-	ndev->vlan_features = NETIF_F_SG | NETIF_F_HW_CSUM |
-			      NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &enetc_vf_hw_feature_set);
+	netdev_active_features_zero(ndev);
+	netdev_active_features_set_array(ndev, &enetc_vf_feature_set);
+	netdev_vlan_features_zero(ndev);
+	netdev_vlan_features_set_array(ndev, &enetc_vf_vlan_feature_set);
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e8e2aa1e7f01..49850ee91d4e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/in.h>
@@ -3465,6 +3466,13 @@ static const unsigned short offset_des_active_txq[] = {
 	FEC_X_DES_ACTIVE_0, FEC_X_DES_ACTIVE_1, FEC_X_DES_ACTIVE_2
 };
 
+static DECLARE_NETDEV_FEATURE_SET(fec_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT);
+
  /*
   * XXX:  We need to clean up on failure exits here.
   *
@@ -3569,8 +3577,7 @@ static int fec_enet_init(struct net_device *ndev)
 		netif_set_tso_max_segs(ndev, FEC_MAX_TSO_SEGS);
 
 		/* enable hw accelerator */
-		ndev->features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
-				| NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO);
+		netdev_active_features_set_array(ndev, &fec_feature_set);
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index e7bf1524b68e..72a1842794a7 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -67,6 +67,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_vlan.h>
@@ -3191,6 +3192,16 @@ static const struct net_device_ops gfar_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(gfar_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(gfar_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 /* Set up the ethernet device structure, private data,
  * and anything else we need before we start
  */
@@ -3239,10 +3250,9 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
-		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-				   NETIF_F_RXCSUM;
-		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG |
-				 NETIF_F_RXCSUM | NETIF_F_HIGHDMA;
+		netdev_hw_features_zero(dev);
+		netdev_hw_features_set_array(dev, &gfar_hw_feature_set);
+		netdev_active_features_set_array(dev, &gfar_feature_set);
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index f247b7ad3a88..537daf19f7f6 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -9,6 +9,7 @@
 #include <linux/if_vlan.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/rtnetlink.h>
 #include <linux/inetdevice.h>
@@ -1354,14 +1355,6 @@ static const struct net_device_ops fun_netdev_ops = {
 	.ndo_get_devlink_port	= fun_get_devlink_port,
 };
 
-#define GSO_ENCAP_FLAGS (NETIF_F_GSO_GRE | NETIF_F_GSO_IPXIP4 | \
-			 NETIF_F_GSO_IPXIP6 | NETIF_F_GSO_UDP_TUNNEL | \
-			 NETIF_F_GSO_UDP_TUNNEL_CSUM)
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN | \
-		   NETIF_F_GSO_UDP_L4)
-#define VLAN_FEAT (NETIF_F_SG | NETIF_F_HW_CSUM | TSO_FLAGS | \
-		   GSO_ENCAP_FLAGS | NETIF_F_HIGHDMA)
-
 static void fun_dflt_rss_indir(struct funeth_priv *fp, unsigned int nrx)
 {
 	unsigned int i;
@@ -1708,9 +1701,35 @@ int fun_change_num_queues(struct net_device *dev, unsigned int ntx,
 	return err;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(fun_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(fun_gso_encap_feature_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(fun_tso_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(fun_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 {
+	netdev_features_t gso_encap_flags = netdev_empty_features;
+	netdev_features_t tso_flags = netdev_empty_features;
 	struct fun_dev *fdev = &ed->fdev;
+	netdev_features_t vlan_feat;
 	struct net_device *netdev;
 	struct funeth_priv *fp;
 	unsigned int ntx, nrx;
@@ -1763,14 +1782,19 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	SET_NETDEV_DEV(netdev, fdev->dev);
 	netdev->netdev_ops = &fun_netdev_ops;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev_features_set_array(&fun_gso_encap_feature_set, &gso_encap_flags);
+	netdev_features_set_array(&fun_tso_feature_set, &tso_flags);
+	vlan_feat = gso_encap_flags | tso_flags;
+	netdev_features_set_array(&fun_vlan_feature_set, &vlan_feat);
+
+	netdev_hw_features_set_array(netdev, &fun_hw_feature_set);
 	if (fp->port_caps & FUN_PORT_CAP_OFFLOADS)
-		netdev->hw_features |= NETIF_F_HW_CSUM | TSO_FLAGS;
+		netdev->hw_features |= NETIF_F_HW_CSUM | tso_flags;
 	if (fp->port_caps & FUN_PORT_CAP_ENCAP_OFFLOADS)
-		netdev->hw_features |= GSO_ENCAP_FLAGS;
+		netdev->hw_features |= gso_encap_flags;
 
 	netdev->features |= netdev->hw_features | NETIF_F_HIGHDMA;
-	netdev->vlan_features = netdev->features & VLAN_FEAT;
+	netdev->vlan_features = netdev->features & vlan_feat;
 	netdev->mpls_features = netdev->vlan_features;
 	netdev->hw_enc_features = netdev->hw_features;
 
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 6cafee55efc3..357e2d9cd740 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -1528,6 +1529,16 @@ static void gve_write_version(u8 __iomem *driver_version_register)
 	writeb('\n', driver_version_register);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(gve_hw_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXHASH_BIT);
+
 static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int max_tx_queues, max_rx_queues;
@@ -1588,14 +1599,8 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Features might be set in other locations as well (such as
 	 * `gve_adminq_describe_device`).
 	 */
-	dev->hw_features = NETIF_F_HIGHDMA;
-	dev->hw_features |= NETIF_F_SG;
-	dev->hw_features |= NETIF_F_HW_CSUM;
-	dev->hw_features |= NETIF_F_TSO;
-	dev->hw_features |= NETIF_F_TSO6;
-	dev->hw_features |= NETIF_F_TSO_ECN;
-	dev->hw_features |= NETIF_F_RXCSUM;
-	dev->hw_features |= NETIF_F_RXHASH;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &gve_hw_feature_set);
 	dev->features = dev->hw_features;
 	dev->watchdog_timeo = 5 * HZ;
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index d94cc8c6681f..c7556817e6a4 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -13,6 +13,7 @@
 #include <linux/ipv6.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/skbuff.h>
@@ -1791,6 +1792,11 @@ static int hns_nic_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(hns_v1_off_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+
 static netdev_features_t hns_nic_fix_features(
 		struct net_device *netdev, netdev_features_t features)
 {
@@ -1798,8 +1804,7 @@ static netdev_features_t hns_nic_fix_features(
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6 |
-				NETIF_F_HW_VLAN_CTAG_FILTER);
+		netdev_features_clear_array(&hns_v1_off_feature_set, &features);
 		break;
 	default:
 		break;
@@ -2240,6 +2245,34 @@ static int hns_nic_notifier_action(struct notifier_block *nb,
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(hns_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(hns_vlan_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(hns_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(hns_v2_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_NTUPLE_BIT);
+
 static int hns_nic_dev_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -2323,21 +2356,15 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &hns_nic_netdev_ops;
 	hns_ethtool_set_ops(ndev);
 
-	ndev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO;
-	ndev->vlan_features |=
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
-	ndev->vlan_features |= NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+	netdev_active_features_set_array(ndev, &hns_feature_set);
+	netdev_vlan_features_set_array(ndev, &hns_vlan_feature_set);
 
 	/* MTU range: 68 - 9578 (v1) or 9706 (v2) */
 	ndev->min_mtu = MAC_MIN_MTU;
 	switch (priv->enet_ver) {
 	case AE_VERSION_2:
-		ndev->features |= NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_NTUPLE;
-		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-			NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_active_features_set_array(ndev, &hns_v2_feature_set);
+		netdev_hw_features_set_array(ndev, &hns_hw_feature_set);
 		ndev->vlan_features |= NETIF_F_TSO | NETIF_F_TSO6;
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 35d70041b9e8..df3f46d7f217 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -12,6 +12,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/skbuff.h>
@@ -3253,23 +3254,42 @@ static struct pci_driver hns3_driver = {
 	.err_handler    = &hns3_err_handler,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(hns3_default_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_FRAGLIST_BIT);
+static DECLARE_NETDEV_FEATURE_SET(hns3_vlan_off_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_GRO_HW_BIT,
+				  NETIF_F_NTUPLE_BIT,
+				  NETIF_F_HW_TC_BIT);
+
 /* set default feature to hns3 */
 static void hns3_set_default_feature(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct pci_dev *pdev = h->pdev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+	netdev_features_t vlan_off_features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
+	netdev_active_features_set_array(netdev, &hns3_default_feature_set);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		netdev->features |= NETIF_F_GRO_HW;
@@ -3296,10 +3316,10 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->vlan_features |= netdev->features &
-		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
-		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
-		  NETIF_F_HW_TC);
+	netdev_features_zero(&vlan_off_features);
+	netdev_features_set_array(&hns3_vlan_off_feature_set,
+				  &vlan_off_features);
+	netdev->vlan_features |= netdev->features & ~vlan_off_features;
 
 	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c23ee2ddbce3..b8db3b423a5b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/slab.h>
 #include <linux/if_vlan.h>
 #include <linux/semaphore.h>
@@ -916,21 +917,41 @@ static const struct net_device_ops hinicvf_netdev_ops = {
 	.ndo_set_features = hinic_set_features,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(hinic_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(hinic_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
 static void netdev_features_init(struct net_device *netdev)
 {
-	netdev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM | NETIF_F_LRO |
-			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &hinic_hw_feature_set);
 
 	netdev->vlan_features = netdev->hw_features;
 
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
-				  NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
-				  NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL;
+	netdev_hw_enc_features_zero(netdev);
+	netdev_hw_enc_features_set_array(netdev, &hinic_hw_enc_feature_set);
 }
 
 static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 5dc302880f5f..cc520574a710 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2936,6 +2936,26 @@ static const struct net_device_ops ehea_netdev_ops = {
 	.ndo_tx_timeout		= ehea_tx_watchdog,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(ehea_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ehea_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ehea_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_IP_CSUM_BIT);
+
 static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 					 u32 logical_port_id,
 					 struct device_node *dn)
@@ -2993,14 +3013,12 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 	dev->netdev_ops = &ehea_netdev_ops;
 	ehea_set_ethtool_ops(dev);
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_TSO |
-		      NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_CTAG_TX;
-	dev->features = NETIF_F_SG | NETIF_F_TSO |
-		      NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
-		      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		      NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_TSO | NETIF_F_HIGHDMA |
-			NETIF_F_IP_CSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &ehea_hw_feature_set);
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &ehea_feature_set);
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_array(dev, &ehea_vlan_feature_set);
 	dev->watchdog_timeo = EHEA_WATCH_DOG_TIMEOUT;
 
 	/* MTU range: 68 - 9022 */
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index fbea9f7efe8c..6b026ba0f262 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3032,6 +3032,10 @@ static const struct net_device_ops emac_gige_netdev_ops = {
 	.ndo_change_mtu		= emac_change_mtu,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(emac_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT);
+
 static int emac_probe(struct platform_device *ofdev)
 {
 	struct net_device *ndev;
@@ -3171,7 +3175,8 @@ static int emac_probe(struct platform_device *ofdev)
 		goto err_detach_tah;
 
 	if (dev->tah_dev) {
-		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG;
+		netdev_hw_features_zero(ndev);
+		netdev_hw_features_set_array(ndev, &emac_hw_feature_set);
 		ndev->features |= ndev->hw_features | NETIF_F_RXCSUM;
 	}
 	ndev->watchdog_timeo = 5 * HZ;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 5c6a04d29f5b..b45b7ff892ef 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1623,6 +1623,11 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(ibmveth_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 {
 	int rc, i, mac_len;
@@ -1681,10 +1686,8 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->ethtool_ops = &netdev_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
 	netdev->hw_features = NETIF_F_SG;
-	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL) {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				       NETIF_F_RXCSUM;
-	}
+	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
+		netdev_hw_features_set_array(netdev, &ibmveth_hw_feature_set);
 
 	netdev->features |= netdev->hw_features;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5ab7c0f81e9a..c0ae18a2b601 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4831,6 +4831,11 @@ static void send_query_ip_offload(struct ibmvnic_adapter *adapter)
 	ibmvnic_send_crq(adapter, &crq);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ibmvnic_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GRO_BIT);
+
 static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 {
 	struct ibmvnic_control_ip_offload_buffer *ctrl_buf = &adapter->ip_offload_ctrl;
@@ -4870,7 +4875,8 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		adapter->netdev->hw_features = 0;
 	}
 
-	adapter->netdev->hw_features = NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+	netdev_hw_features_zero(adapter->netdev);
+	netdev_hw_features_set_array(adapter->netdev, &ibmvnic_hw_feature_set);
 
 	if (buf->tcp_ipv4_chksum || buf->udp_ipv4_chksum)
 		adapter->netdev->hw_features |= NETIF_F_IP_CSUM;
diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
index 4817eb13ca6f..86bc74be959f 100644
--- a/drivers/net/ethernet/intel/e1000/e1000.h
+++ b/drivers/net/ethernet/intel/e1000/e1000.h
@@ -16,6 +16,7 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 23299fc56199..07670cabf19f 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -907,6 +907,22 @@ static int e1000_init_hw_struct(struct e1000_adapter *adapter,
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(e1000_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(e1000_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+static DECLARE_NETDEV_FEATURE_SET(e1000_hw_rx_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXALL_BIT,
+				  NETIF_F_RXFCS_BIT);
+static DECLARE_NETDEV_FEATURE_SET(e1000_vlan_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT);
+
 /**
  * e1000_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -1035,11 +1051,10 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	if (hw->mac_type >= e1000_82543) {
-		netdev->hw_features = NETIF_F_SG |
-				   NETIF_F_HW_CSUM |
-				   NETIF_F_HW_VLAN_CTAG_RX;
-		netdev->features = NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_features_zero(netdev);
+		netdev_hw_features_set_array(netdev, &e1000_hw_feature_set);
+		netdev_active_features_zero(netdev);
+		netdev_active_features_set_array(netdev, &e1000_feature_set);
 	}
 
 	if ((hw->mac_type >= e1000_82544) &&
@@ -1049,18 +1064,14 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->features |= netdev->hw_features;
-	netdev->hw_features |= (NETIF_F_RXCSUM |
-				NETIF_F_RXALL |
-				NETIF_F_RXFCS);
+	netdev_hw_features_set_array(netdev, &e1000_hw_rx_feature_set);
 
 	if (pci_using_dac) {
 		netdev->features |= NETIF_F_HIGHDMA;
 		netdev->vlan_features |= NETIF_F_HIGHDMA;
 	}
 
-	netdev->vlan_features |= (NETIF_F_TSO |
-				  NETIF_F_HW_CSUM |
-				  NETIF_F_SG);
+	netdev_vlan_features_set_array(netdev, &e1000_vlan_feature_set);
 
 	/* Do not set IFF_UNICAST_FLT for VMWare's 82545EM */
 	if (hw->device_id != E1000_DEV_ID_82545EM_COPPER ||
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 321f2a95ae3a..60b4c6ee5bd8 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/interrupt.h>
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
@@ -7311,18 +7312,27 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	return features;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(e1000_changable_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXFCS_BIT,
+				  NETIF_F_RXALL_BIT);
+
 static int e1000_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changeable;
 
 	if (changed & (NETIF_F_TSO | NETIF_F_TSO6))
 		adapter->flags |= FLAG_TSO_FORCE;
 
-	if (!(changed & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_RXFCS |
-			 NETIF_F_RXALL)))
+	netdev_features_zero(&changeable);
+	netdev_features_set_array(&e1000_changable_feature_set, &changeable);
+	if (!(changed & changeable))
 		return 0;
 
 	if (changed & NETIF_F_RXFCS) {
@@ -7371,6 +7381,21 @@ static const struct net_device_ops e1000e_netdev_ops = {
 	.ndo_features_check	= passthru_features_check,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(e1000_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(e1000_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+
 /**
  * e1000_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -7523,14 +7548,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "PHY reset is blocked due to SOL/IDER session.\n");
 
 	/* Set initial default active device features */
-	netdev->features = (NETIF_F_SG |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_TSO |
-			    NETIF_F_TSO6 |
-			    NETIF_F_RXHASH |
-			    NETIF_F_RXCSUM |
-			    NETIF_F_HW_CSUM);
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_array(netdev, &e1000_feature_set);
 
 	/* Set user-changeable features (subset of all device features) */
 	netdev->hw_features = netdev->features;
@@ -7541,10 +7560,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (adapter->flags & FLAG_HAS_HW_VLAN_FILTER)
 		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->vlan_features |= (NETIF_F_SG |
-				  NETIF_F_TSO |
-				  NETIF_F_TSO6 |
-				  NETIF_F_HW_CSUM);
+	netdev_vlan_features_set_array(netdev, &e1000_vlan_feature_set);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2cca9e84e31e..a42148582779 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -5,6 +5,7 @@
 #include <linux/vmalloc.h>
 #include <net/udp_tunnel.h>
 #include <linux/if_macvlan.h>
+#include <linux/netdev_features_helper.h>
 
 /**
  * fm10k_setup_tx_resources - allocate Tx resources (Descriptors)
@@ -1536,6 +1537,24 @@ static const struct net_device_ops fm10k_netdev_ops = {
 	.ndo_features_check	= fm10k_features_check,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(fm10k_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(fm10k_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT);
+
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
 struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
@@ -1557,24 +1576,12 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	interface->msg_enable = BIT(DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	/* configure default features */
-	dev->features |= NETIF_F_IP_CSUM |
-			 NETIF_F_IPV6_CSUM |
-			 NETIF_F_SG |
-			 NETIF_F_TSO |
-			 NETIF_F_TSO6 |
-			 NETIF_F_TSO_ECN |
-			 NETIF_F_RXHASH |
-			 NETIF_F_RXCSUM;
+	netdev_active_features_set_array(dev, &fm10k_feature_set);
 
 	/* Only the PF can support VXLAN and NVGRE tunnel offloads */
 	if (info->mac == fm10k_mac_pf) {
-		dev->hw_enc_features = NETIF_F_IP_CSUM |
-				       NETIF_F_TSO |
-				       NETIF_F_TSO6 |
-				       NETIF_F_TSO_ECN |
-				       NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_IPV6_CSUM |
-				       NETIF_F_SG;
+		netdev_hw_enc_features_zero(dev);
+		netdev_hw_enc_features_set_array(dev, &fm10k_hw_enc_feature_set);
 
 		dev->features |= NETIF_F_GSO_UDP_TUNNEL;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b36bf9c3e1e4..69ac22c7e800 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7,6 +7,7 @@
 #include <linux/bpf.h>
 #include <generated/utsrelease.h>
 #include <linux/crash_dump.h>
+#include <linux/netdev_features_helper.h>
 
 /* Local includes */
 #include "i40e.h"
@@ -13616,6 +13617,37 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_dfwd_del_station	= i40e_fwd_del,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(i40e_hw_enc_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(i40e_gso_partial_feature_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(i40e_mpls_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 /**
  * i40e_config_netdev - Setup the netdev flags
  * @vsi: the VSI being configured
@@ -13631,6 +13663,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	u8 broadcast[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
 	int etherdev_size;
+	netdev_features_t gso_partial_features;
 	netdev_features_t hw_enc_features;
 	netdev_features_t hw_features;
 
@@ -13643,25 +13676,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
 
-	hw_enc_features = NETIF_F_SG			|
-			  NETIF_F_HW_CSUM		|
-			  NETIF_F_HIGHDMA		|
-			  NETIF_F_SOFT_FEATURES		|
-			  NETIF_F_TSO			|
-			  NETIF_F_TSO_ECN		|
-			  NETIF_F_TSO6			|
-			  NETIF_F_GSO_GRE		|
-			  NETIF_F_GSO_GRE_CSUM		|
-			  NETIF_F_GSO_PARTIAL		|
-			  NETIF_F_GSO_IPXIP4		|
-			  NETIF_F_GSO_IPXIP6		|
-			  NETIF_F_GSO_UDP_TUNNEL	|
-			  NETIF_F_GSO_UDP_TUNNEL_CSUM	|
-			  NETIF_F_GSO_UDP_L4		|
-			  NETIF_F_SCTP_CRC		|
-			  NETIF_F_RXHASH		|
-			  NETIF_F_RXCSUM		|
-			  0;
+	hw_enc_features = NETIF_F_SOFT_FEATURES;
+	netdev_features_set_array(&i40e_hw_enc_feature_set, &hw_enc_features);
 
 	if (!(pf->hw_features & I40E_HW_OUTER_UDP_CSUM_CAPABLE))
 		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
@@ -13675,22 +13691,15 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	/* record features VLANs can make use of */
 	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
 
-#define I40E_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE |		\
-				   NETIF_F_GSO_GRE_CSUM |	\
-				   NETIF_F_GSO_IPXIP4 |		\
-				   NETIF_F_GSO_IPXIP6 |		\
-				   NETIF_F_GSO_UDP_TUNNEL |	\
-				   NETIF_F_GSO_UDP_TUNNEL_CSUM)
-
-	netdev->gso_partial_features = I40E_GSO_PARTIAL_FEATURES;
+	netdev_features_zero(&gso_partial_features);
+	netdev_features_set_array(&i40e_gso_partial_feature_set,
+				  &gso_partial_features);
+	netdev->gso_partial_features = gso_partial_features;
 	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    I40E_GSO_PARTIAL_FEATURES;
+			    gso_partial_features;
 
-	netdev->mpls_features |= NETIF_F_SG;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
-	netdev->mpls_features |= NETIF_F_TSO;
-	netdev->mpls_features |= NETIF_F_TSO6;
-	netdev->mpls_features |= I40E_GSO_PARTIAL_FEATURES;
+	netdev_mpls_features_set_array(netdev, &i40e_mpls_feature_set);
+	netdev->mpls_features |= gso_partial_features;
 
 	/* enable macvlan offloads */
 	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3f6187c16424..5d033a16a95a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
 #include <linux/ethtool.h>
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 45d097a164ad..55ab0229179f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4585,6 +4585,26 @@ static int iavf_check_reset_complete(struct iavf_hw *hw)
 	return -EBUSY;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(iavf_hw_enc_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(iavf_gso_feature_set,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT);
+
 /**
  * iavf_process_config - Process the config information we got from the PF
  * @adapter: board private structure
@@ -4600,31 +4620,14 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	netdev_features_t hw_enc_features;
 	netdev_features_t hw_features;
 
-	hw_enc_features = NETIF_F_SG			|
-			  NETIF_F_IP_CSUM		|
-			  NETIF_F_IPV6_CSUM		|
-			  NETIF_F_HIGHDMA		|
-			  NETIF_F_SOFT_FEATURES	|
-			  NETIF_F_TSO			|
-			  NETIF_F_TSO_ECN		|
-			  NETIF_F_TSO6			|
-			  NETIF_F_SCTP_CRC		|
-			  NETIF_F_RXHASH		|
-			  NETIF_F_RXCSUM		|
-			  0;
+	hw_enc_features = NETIF_F_SOFT_FEATURES;
+	netdev_features_set_array(&iavf_hw_enc_feature_set, &hw_enc_features);
 
 	/* advertise to stack only if offloads for encapsulated packets is
 	 * supported
 	 */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ENCAP) {
-		hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL	|
-				   NETIF_F_GSO_GRE		|
-				   NETIF_F_GSO_GRE_CSUM		|
-				   NETIF_F_GSO_IPXIP4		|
-				   NETIF_F_GSO_IPXIP6		|
-				   NETIF_F_GSO_UDP_TUNNEL_CSUM	|
-				   NETIF_F_GSO_PARTIAL		|
-				   0;
+		netdev_features_set_array(&iavf_gso_feature_set, &hw_enc_features);
 
 		if (!(vfres->vf_cap_flags &
 		      VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM))
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index cc5b85afd437..b61c849845ee 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/compiler.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index eb40526ee179..34a859ecae0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3293,6 +3293,36 @@ static void ice_set_ops(struct net_device *netdev)
 	ice_set_ethtool_ops(netdev);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ice_safe_mode_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ice_dflt_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_NTUPLE_BIT,
+				  NETIF_F_RXHASH_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ice_csumo_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ice_tso_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ice_mpls_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 /**
  * ice_set_netdev_features - set features for the given netdev
  * @netdev: netdev instance
@@ -3308,20 +3338,18 @@ static void ice_set_netdev_features(struct net_device *netdev)
 
 	if (ice_is_safe_mode(pf)) {
 		/* safe mode */
-		netdev->features = NETIF_F_SG | NETIF_F_HIGHDMA;
+		netdev_active_features_zero(netdev);
+		netdev_active_features_set_array(netdev,
+						 &ice_safe_mode_feature_set);
 		netdev->hw_features = netdev->features;
 		return;
 	}
 
-	dflt_features = NETIF_F_SG	|
-			NETIF_F_HIGHDMA	|
-			NETIF_F_NTUPLE	|
-			NETIF_F_RXHASH;
+	netdev_features_zero(&dflt_features);
+	netdev_features_set_array(&ice_dflt_feature_set, &dflt_features);
 
-	csumo_features = NETIF_F_RXCSUM	  |
-			 NETIF_F_IP_CSUM  |
-			 NETIF_F_SCTP_CRC |
-			 NETIF_F_IPV6_CSUM;
+	netdev_features_zero(&csumo_features);
+	netdev_features_set_array(&ice_csumo_feature_set, &csumo_features);
 
 	vlano_features = NETIF_F_HW_VLAN_CTAG_FILTER |
 			 NETIF_F_HW_VLAN_CTAG_TX     |
@@ -3331,17 +3359,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	if (is_dvm_ena)
 		vlano_features |= NETIF_F_HW_VLAN_STAG_FILTER;
 
-	tso_features = NETIF_F_TSO			|
-		       NETIF_F_TSO_ECN			|
-		       NETIF_F_TSO6			|
-		       NETIF_F_GSO_GRE			|
-		       NETIF_F_GSO_UDP_TUNNEL		|
-		       NETIF_F_GSO_GRE_CSUM		|
-		       NETIF_F_GSO_UDP_TUNNEL_CSUM	|
-		       NETIF_F_GSO_PARTIAL		|
-		       NETIF_F_GSO_IPXIP4		|
-		       NETIF_F_GSO_IPXIP6		|
-		       NETIF_F_GSO_UDP_L4;
+	netdev_features_zero(&tso_features);
+	netdev_features_set_array(&ice_tso_feature_set, &tso_features);
 
 	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_GRE_CSUM;
@@ -3350,9 +3369,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 			      vlano_features | tso_features;
 
 	/* add support for HW_CSUM on packets with MPLS header */
-	netdev->mpls_features =  NETIF_F_HW_CSUM |
-				 NETIF_F_TSO     |
-				 NETIF_F_TSO6;
+	netdev_mpls_features_zero(netdev);
+	netdev_mpls_features_set_array(netdev, &ice_mpls_feature_set);
 
 	/* enable features */
 	netdev->features |= netdev->hw_features;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d8b836a85cc3..2fd8d8c94305 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/ipv6.h>
 #include <linux/slab.h>
 #include <net/checksum.h>
@@ -2500,6 +2501,20 @@ static int igb_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	return ndo_dflt_fdb_add(ndm, tb, dev, addr, vid, flags);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(igb_l2_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(igb_l3_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 #define IGB_MAX_MAC_HDR_LEN	127
 #define IGB_MAX_NETWORK_HDR_LEN	511
 
@@ -2511,21 +2526,18 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_array(&igb_l2_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_array(&igb_l3_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -3144,6 +3156,21 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
 	return status;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(igb_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(igb_gso_partial_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
 /**
  *  igb_probe - Device Initialization Routine
  *  @pdev: PCI device information struct
@@ -3164,6 +3191,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	s32 ret_val;
 	static int global_quad_port_a; /* global quad port a indication */
 	const struct e1000_info *ei = igb_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	u8 part_str[E1000_PBANUM_LENGTH];
 	int err;
 
@@ -3268,12 +3296,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * set by igb_sw_init so we should use an or instead of an
 	 * assignment.
 	 */
-	netdev->features |= NETIF_F_SG |
-			    NETIF_F_TSO |
-			    NETIF_F_TSO6 |
-			    NETIF_F_RXHASH |
-			    NETIF_F_RXCSUM |
-			    NETIF_F_HW_CSUM;
+	netdev_active_features_set_array(netdev, &igb_feature_set);
 
 	if (hw->mac.type >= e1000_82576)
 		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
@@ -3281,15 +3304,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hw->mac.type >= e1000_i350)
 		netdev->features |= NETIF_F_HW_TC;
 
-#define IGB_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
-				  NETIF_F_GSO_GRE_CSUM | \
-				  NETIF_F_GSO_IPXIP4 | \
-				  NETIF_F_GSO_IPXIP6 | \
-				  NETIF_F_GSO_UDP_TUNNEL | \
-				  NETIF_F_GSO_UDP_TUNNEL_CSUM)
-
-	netdev->gso_partial_features = IGB_GSO_PARTIAL_FEATURES;
-	netdev->features |= NETIF_F_GSO_PARTIAL | IGB_GSO_PARTIAL_FEATURES;
+	netdev_features_zero(&gso_partial_features);
+	netdev_features_set_array(&igb_feature_set, &gso_partial_features);
+	netdev->gso_partial_features = gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
 
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= netdev->features |
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index f4e91db89fe5..362e26df28b0 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
 #include <linux/slab.h>
@@ -2615,6 +2616,18 @@ static int igbvf_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(igbvf_l2_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(igbvf_l3_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 #define IGBVF_MAX_MAC_HDR_LEN		127
 #define IGBVF_MAX_NETWORK_HDR_LEN	511
 
@@ -2626,19 +2639,18 @@ igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_array(&igbvf_l2_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_array(&igbvf_l3_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -2667,6 +2679,21 @@ static const struct net_device_ops igbvf_netdev_ops = {
 	.ndo_features_check	= igbvf_features_check,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(igbvf_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(igbvf_gso_partial_feature_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
 /**
  * igbvf_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -2684,6 +2711,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct igbvf_adapter *adapter;
 	struct e1000_hw *hw;
 	const struct igbvf_info *ei = igbvf_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	static int cards_found;
 	int err;
 
@@ -2758,23 +2786,15 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	adapter->bd_number = cards_found++;
 
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_HW_CSUM |
-			      NETIF_F_SCTP_CRC;
-
-#define IGBVF_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
-				    NETIF_F_GSO_GRE_CSUM | \
-				    NETIF_F_GSO_IPXIP4 | \
-				    NETIF_F_GSO_IPXIP6 | \
-				    NETIF_F_GSO_UDP_TUNNEL | \
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
-
-	netdev->gso_partial_features = IGBVF_GSO_PARTIAL_FEATURES;
-	netdev->hw_features |= NETIF_F_GSO_PARTIAL |
-			       IGBVF_GSO_PARTIAL_FEATURES;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &igbvf_hw_feature_set);
+
+	netdev_features_zero(&gso_partial_features);
+	netdev_features_set_array(&igbvf_gso_partial_feature_set,
+				  &gso_partial_features);
+
+	netdev->gso_partial_features = gso_partial_features;
+	netdev->hw_features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
 
 	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index a5c4b19d71a2..79e65b35ab3d 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -3,6 +3,7 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/netdev_features_helper.h>
 
 #include "igc_mac.h"
 #include "igc_hw.h"
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ebff0e04045d..e5b97822e191 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -9,6 +9,7 @@
 #include <linux/udp.h>
 #include <linux/ip.h>
 #include <linux/pm_runtime.h>
+#include <linux/netdev_features_helper.h>
 #include <net/pkt_sched.h>
 #include <linux/bpf_trace.h>
 #include <net/xdp_sock_drv.h>
@@ -4973,6 +4974,18 @@ static int igc_set_features(struct net_device *netdev,
 	return 1;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(igc_l2_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(igc_l3_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static netdev_features_t
 igc_features_check(struct sk_buff *skb, struct net_device *dev,
 		   netdev_features_t features)
@@ -4981,19 +4994,18 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_array(&igc_l2_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_array(&igc_l3_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	/* We can only support IPv4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -6201,6 +6213,23 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	return value;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(igc_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_HW_TC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(igc_gso_partial_feature_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
 /**
  * igc_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -6219,6 +6248,7 @@ static int igc_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct igc_hw *hw;
 	const struct igc_info *ei = igc_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	int err;
 
 	err = pci_enable_device_mem(pdev);
@@ -6299,24 +6329,13 @@ static int igc_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	/* Add supported features to the features list*/
-	netdev->features |= NETIF_F_SG;
-	netdev->features |= NETIF_F_TSO;
-	netdev->features |= NETIF_F_TSO6;
-	netdev->features |= NETIF_F_TSO_ECN;
-	netdev->features |= NETIF_F_RXCSUM;
-	netdev->features |= NETIF_F_HW_CSUM;
-	netdev->features |= NETIF_F_SCTP_CRC;
-	netdev->features |= NETIF_F_HW_TC;
-
-#define IGC_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
-				  NETIF_F_GSO_GRE_CSUM | \
-				  NETIF_F_GSO_IPXIP4 | \
-				  NETIF_F_GSO_IPXIP6 | \
-				  NETIF_F_GSO_UDP_TUNNEL | \
-				  NETIF_F_GSO_UDP_TUNNEL_CSUM)
-
-	netdev->gso_partial_features = IGC_GSO_PARTIAL_FEATURES;
-	netdev->features |= NETIF_F_GSO_PARTIAL | IGC_GSO_PARTIAL_FEATURES;
+	netdev_active_features_set_array(netdev, &igc_feature_set);
+
+	netdev_features_zero(&gso_partial_features);
+	netdev_features_set_array(&igc_gso_partial_feature_set,
+				  &gso_partial_features);
+	netdev->gso_partial_features = gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 45be9a1ab6af..c3ae375f04dd 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -3,6 +3,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/netdev_features_helper.h>
 #include <linux/prefetch.h>
 #include "ixgb.h"
 
@@ -343,6 +344,13 @@ static const struct net_device_ops ixgb_netdev_ops = {
 	.ndo_set_features       = ixgb_set_features,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(ixgb_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
 /**
  * ixgb_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -428,11 +436,8 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	netdev->hw_features = NETIF_F_SG |
-			   NETIF_F_TSO |
-			   NETIF_F_HW_CSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &ixgb_hw_feature_set);
 	netdev->features = netdev->hw_features |
 			   NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features |= NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index d1e430b8c8aa..98db7c46e89c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
 #include <linux/in.h>
@@ -10210,6 +10211,20 @@ static void ixgbe_fwd_del(struct net_device *pdev, void *priv)
 	kfree(accel);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_l2_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_l3_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 #define IXGBE_MAX_MAC_HDR_LEN		127
 #define IXGBE_MAX_NETWORK_HDR_LEN	511
 
@@ -10221,21 +10236,18 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IXGBE_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IXGBE_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_array(&ixgbe_l2_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IXGBE_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IXGBE_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_array(&ixgbe_l3_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -10755,6 +10767,47 @@ static void ixgbe_set_fw_version(struct ixgbe_adapter *adapter)
 		 "0x%08x", nvm_ver.etk_id);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_gso_partial_feature_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+#ifdef CONFIG_IXGBE_IPSEC
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_esp_feature_set,
+				  NETIF_F_HW_ESP_BIT,
+				  NETIF_F_HW_ESP_TX_CSUM_BIT,
+				  NETIF_F_GSO_ESP_BIT);
+#endif
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_hw_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_RXALL_BIT,
+				  NETIF_F_HW_L2FW_DOFFLOAD_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_mpls_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+#ifdef IXGBE_FCOE
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_fcoe_feature_set,
+				  NETIF_F_FSO_BIT,
+				  NETIF_F_FCOE_CRC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ixgbe_vlan_fcoe_feature_set,
+				  NETIF_F_FSO_BIT,
+				  NETIF_F_FCOE_CRC_BIT,
+				  NETIF_F_FCOE_MTU_BIT);
+#endif
+
 /**
  * ixgbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -10772,6 +10825,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgbe_adapter *adapter = NULL;
 	struct ixgbe_hw *hw;
 	const struct ixgbe_info *ii = ixgbe_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	unsigned int indices = MAX_TX_QUEUES;
 	u8 part_str[IXGBE_PBANUM_LENGTH];
 	int i, err, expected_gts;
@@ -10958,42 +11012,27 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 skip_sriov:
 
 #endif
-	netdev->features = NETIF_F_SG |
-			   NETIF_F_TSO |
-			   NETIF_F_TSO6 |
-			   NETIF_F_RXHASH |
-			   NETIF_F_RXCSUM |
-			   NETIF_F_HW_CSUM;
-
-#define IXGBE_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
-				    NETIF_F_GSO_GRE_CSUM | \
-				    NETIF_F_GSO_IPXIP4 | \
-				    NETIF_F_GSO_IPXIP6 | \
-				    NETIF_F_GSO_UDP_TUNNEL | \
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
-
-	netdev->gso_partial_features = IXGBE_GSO_PARTIAL_FEATURES;
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_array(netdev, &ixgbe_feature_set);
+
+	netdev_features_zero(&gso_partial_features);
+	netdev_features_set_array(&ixgbe_gso_partial_feature_set,
+				  &gso_partial_features);
+
+	netdev->gso_partial_features = gso_partial_features;
 	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    IXGBE_GSO_PARTIAL_FEATURES;
+			    gso_partial_features;
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
 		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
 
 #ifdef CONFIG_IXGBE_IPSEC
-#define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
-				 NETIF_F_HW_ESP_TX_CSUM | \
-				 NETIF_F_GSO_ESP)
-
 	if (adapter->ipsec)
-		netdev->features |= IXGBE_ESP_FEATURES;
+		netdev_active_features_set_array(netdev, &ixgbe_esp_feature_set);
 #endif
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_HW_VLAN_CTAG_FILTER |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_RXALL |
-			       NETIF_F_HW_L2FW_DOFFLOAD;
+	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set_array(netdev, &ixgbe_hw_feature_set);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
 		netdev->hw_features |= NETIF_F_NTUPLE |
@@ -11003,11 +11042,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->hw_enc_features |= netdev->vlan_features;
-	netdev->mpls_features |= NETIF_F_SG |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6 |
-				 NETIF_F_HW_CSUM;
-	netdev->mpls_features |= IXGBE_GSO_PARTIAL_FEATURES;
+	netdev_mpls_features_set_array(netdev, &ixgbe_mpls_feature_set);
+	netdev->mpls_features |= gso_partial_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
 	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
@@ -11040,12 +11076,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		fcoe_l = min_t(int, IXGBE_FCRETA_SIZE, num_online_cpus());
 		adapter->ring_feature[RING_F_FCOE].limit = fcoe_l;
 
-		netdev->features |= NETIF_F_FSO |
-				    NETIF_F_FCOE_CRC;
-
-		netdev->vlan_features |= NETIF_F_FSO |
-					 NETIF_F_FCOE_CRC |
-					 NETIF_F_FCOE_MTU;
+		netdev_active_features_set_array(netdev, &ixgbe_fcoe_feature_set);
+		netdev_vlan_features_set_array(netdev, &ixgbe_vlan_fcoe_feature_set);
 	}
 #endif /* IXGBE_FCOE */
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE)
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 9984ebc62d78..82341ac13e62 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -612,6 +612,11 @@ void ixgbevf_ipsec_rx(struct ixgbevf_ring *rx_ring,
 	adapter->rx_ipsec++;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ixgbevf_esp_feature_set,
+				  NETIF_F_HW_ESP_BIT,
+				  NETIF_F_HW_ESP_TX_CSUM_BIT,
+				  NETIF_F_GSO_ESP_BIT);
+
 /**
  * ixgbevf_init_ipsec_offload - initialize registers for IPsec operation
  * @adapter: board private structure
@@ -651,12 +656,10 @@ void ixgbevf_init_ipsec_offload(struct ixgbevf_adapter *adapter)
 
 	adapter->netdev->xfrmdev_ops = &ixgbevf_xfrmdev_ops;
 
-#define IXGBEVF_ESP_FEATURES	(NETIF_F_HW_ESP | \
-				 NETIF_F_HW_ESP_TX_CSUM | \
-				 NETIF_F_GSO_ESP)
-
-	adapter->netdev->features |= IXGBEVF_ESP_FEATURES;
-	adapter->netdev->hw_enc_features |= IXGBEVF_ESP_FEATURES;
+	netdev_active_features_set_array(adapter->netdev,
+					 &ixgbevf_esp_feature_set);
+	netdev_hw_enc_features_set_array(adapter->netdev,
+					 &ixgbevf_esp_feature_set);
 
 	return;
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
index 149c733fcc2b..29bad7b3f573 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
@@ -9,6 +9,7 @@
 #include <linux/timer.h>
 #include <linux/io.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_vlan.h>
 #include <linux/u64_stats_sync.h>
 #include <net/xdp.h>
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 2f12fbe229c1..095159721a96 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
 #include <linux/in.h>
@@ -4396,6 +4397,18 @@ static void ixgbevf_get_stats(struct net_device *netdev,
 	rcu_read_unlock();
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ixgbevf_l2_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ixgbevf_l3_disable_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 #define IXGBEVF_MAX_MAC_HDR_LEN		127
 #define IXGBEVF_MAX_NETWORK_HDR_LEN	511
 
@@ -4407,19 +4420,18 @@ ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_array(&ixgbevf_l2_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_array(&ixgbevf_l3_disable_feature_set,
+					    &features);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -4504,6 +4516,26 @@ static void ixgbevf_assign_netdev_ops(struct net_device *dev)
 	dev->watchdog_timeo = 5 * HZ;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ixgbevf_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ixgbevf_gso_partial_feature_set,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT,
+				  NETIF_F_GSO_IPXIP4_BIT,
+				  NETIF_F_GSO_IPXIP6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ixgbevf_mpls_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+
 /**
  * ixgbevf_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -4521,6 +4553,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgbevf_adapter *adapter = NULL;
 	struct ixgbe_hw *hw = NULL;
 	const struct ixgbevf_info *ii = ixgbevf_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	bool disable_dev = false;
 	int err;
 
@@ -4593,32 +4626,22 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_sw_init;
 	}
 
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_HW_CSUM |
-			      NETIF_F_SCTP_CRC;
-
-#define IXGBEVF_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
-				      NETIF_F_GSO_GRE_CSUM | \
-				      NETIF_F_GSO_IPXIP4 | \
-				      NETIF_F_GSO_IPXIP6 | \
-				      NETIF_F_GSO_UDP_TUNNEL | \
-				      NETIF_F_GSO_UDP_TUNNEL_CSUM)
-
-	netdev->gso_partial_features = IXGBEVF_GSO_PARTIAL_FEATURES;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &ixgbevf_hw_feature_set);
+
+	netdev_features_zero(&gso_partial_features);
+	netdev_features_set_array(&ixgbevf_gso_partial_feature_set,
+				  &gso_partial_features);
+	netdev->gso_partial_features = gso_partial_features;
 	netdev->hw_features |= NETIF_F_GSO_PARTIAL |
-			       IXGBEVF_GSO_PARTIAL_FEATURES;
+			       gso_partial_features;
 
 	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_SG |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6 |
-				 NETIF_F_HW_CSUM;
-	netdev->mpls_features |= IXGBEVF_GSO_PARTIAL_FEATURES;
+
+	netdev_mpls_features_set_array(netdev, &ixgbevf_mpls_feature_set);
+	netdev->mpls_features |= gso_partial_features;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index f43d6616bc0d..6db2f01468c5 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -2901,6 +2902,22 @@ static const struct net_device_ops jme_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(jme_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(jme_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
 static int
 jme_init_one(struct pci_dev *pdev,
 	     const struct pci_device_id *ent)
@@ -2955,19 +2972,10 @@ jme_init_one(struct pci_dev *pdev,
 	netdev->netdev_ops = &jme_netdev_ops;
 	netdev->ethtool_ops		= &jme_ethtool_ops;
 	netdev->watchdog_timeo		= TX_TIMEOUT;
-	netdev->hw_features		=	NETIF_F_IP_CSUM |
-						NETIF_F_IPV6_CSUM |
-						NETIF_F_SG |
-						NETIF_F_TSO |
-						NETIF_F_TSO6 |
-						NETIF_F_RXCSUM;
-	netdev->features		=	NETIF_F_IP_CSUM |
-						NETIF_F_IPV6_CSUM |
-						NETIF_F_SG |
-						NETIF_F_TSO |
-						NETIF_F_TSO6 |
-						NETIF_F_HW_VLAN_CTAG_TX |
-						NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &jme_hw_feature_set);
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_array(netdev, &jme_feature_set);
 	if (using_dac)
 		netdev->features	|=	NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a6c1..e43fa3a2af17 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -38,6 +38,7 @@
 #include <linux/ethtool.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -3086,6 +3087,11 @@ static const struct net_device_ops mv643xx_eth_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(mv643xx_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT);
+
 static int mv643xx_eth_probe(struct platform_device *pdev)
 {
 	struct mv643xx_eth_platform_data *pd;
@@ -3200,7 +3206,8 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	dev->watchdog_timeo = 2 * HZ;
 	dev->base_addr = 0;
 
-	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &mv643xx_feature_set);
 	dev->vlan_features = dev->features;
 
 	dev->features |= NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0caa2df87c04..b097a857fe4e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -22,6 +22,7 @@
 #include <linux/mbus.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -5377,6 +5378,13 @@ static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(mvneta_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /* Device initialization routine */
 static int mvneta_probe(struct platform_device *pdev)
 {
@@ -5612,8 +5620,8 @@ static int mvneta_probe(struct platform_device *pdev)
 		}
 	}
 
-	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_TSO | NETIF_F_RXCSUM;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &mvneta_feature_set);
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b84128b549b4..38c5ab6a5126 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include <linux/skbuff.h>
@@ -6653,6 +6654,16 @@ static bool mvpp2_use_acpi_compat_mode(struct fwnode_handle *port_fwnode)
 		!fwnode_get_named_child_node(port_fwnode, "fixed-link"));
 }
 
+static DECLARE_NETDEV_FEATURE_SET(mvpp2_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mvpp2_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+
 /* Ports initialization */
 static int mvpp2_port_probe(struct platform_device *pdev,
 			    struct fwnode_handle *port_fwnode,
@@ -6846,11 +6857,11 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		}
 	}
 
-	features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		   NETIF_F_TSO;
+	netdev_features_zero(&features);
+	netdev_features_set_array(&mvpp2_feature_set, &features);
 	dev->features = features | NETIF_F_RXCSUM;
-	dev->hw_features |= features | NETIF_F_RXCSUM | NETIF_F_GRO |
-			    NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->hw_features |= features;
+	netdev_hw_features_set_array(dev, &mvpp2_hw_feature_set);
 
 	if (mvpp22_rss_is_supported(port)) {
 		dev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9376d0e62914..a228447cbb2e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -15,6 +15,7 @@
 #include <net/ip.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/netdev_features_helper.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -2550,6 +2551,16 @@ static void otx2_sriov_vfcfg_cleanup(struct otx2_nic *pf)
 	}
 }
 
+static DECLARE_NETDEV_FEATURE_SET(otx2_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT);
+
 static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device *dev = &pdev->dev;
@@ -2692,10 +2703,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
-	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			       NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			       NETIF_F_GSO_UDP_L4);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &otx2_hw_feature_set);
 	netdev->features |= netdev->hw_features;
 
 	err = otx2_mcam_flow_init(pf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 86653bb8e403..08c82c0d41a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -7,6 +7,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/net_tstamp.h>
 
@@ -520,6 +521,16 @@ static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
 	return otx2vf_register_mbox_intr(vf, false);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(otx2vf_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_UDP_L4_BIT);
+
 static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int num_vec = pci_msix_vec_count(pdev);
@@ -637,10 +648,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
 
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_GSO_UDP_L4;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &otx2vf_hw_feature_set);
 	netdev->features = netdev->hw_features;
 	/* Support TSO on tag interface */
 	netdev->vlan_features |= netdev->features;
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index c1e985416c0e..8bdac1c90c0c 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/pci.h>
@@ -3806,6 +3807,10 @@ static const struct net_device_ops skge_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(skge_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT);
 
 /* Initialize network device */
 static struct net_device *skge_devinit(struct skge_hw *hw, int port,
@@ -3860,8 +3865,8 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	if (is_genesis(hw))
 		timer_setup(&skge->link_timer, xm_link_timer, 0);
 	else {
-		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-		                   NETIF_F_RXCSUM;
+		netdev_hw_features_zero(dev);
+		netdev_hw_features_set_array(dev, &skge_hw_feature_set);
 		dev->features |= dev->hw_features;
 	}
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index bbea5458000b..e3b3b2c7aff3 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -1398,7 +1399,10 @@ static int sky2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return err;
 }
 
-#define SKY2_VLAN_OFFLOADS (NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO)
+static DECLARE_NETDEV_FEATURE_SET(sky2_vlan_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT);
 
 static void sky2_vlan_mode(struct net_device *dev, netdev_features_t features)
 {
@@ -1417,13 +1421,13 @@ static void sky2_vlan_mode(struct net_device *dev, netdev_features_t features)
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_ON);
 
-		dev->vlan_features |= SKY2_VLAN_OFFLOADS;
+		netdev_vlan_features_set_array(dev, &sky2_vlan_feature_set);
 	} else {
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_OFF);
 
 		/* Can't do transmit offload of vlan without hw vlan */
-		dev->vlan_features &= ~SKY2_VLAN_OFFLOADS;
+		netdev_vlan_features_clear_array(dev, &sky2_vlan_feature_set);
 	}
 }
 
@@ -4587,6 +4591,11 @@ static const struct net_device_ops sky2_netdev_ops[2] = {
   },
 };
 
+static DECLARE_NETDEV_FEATURE_SET(sky2_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT);
+
 /* Initialize network device */
 static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 					   int highmem, int wol)
@@ -4634,7 +4643,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 
 	sky2->port = port;
 
-	dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO;
+	netdev_hw_features_set_array(dev, &sky2_hw_feature_set);
 
 	if (highmem)
 		dev->features |= NETIF_F_HIGHDMA;
@@ -4646,7 +4655,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
 		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_HW_VLAN_CTAG_RX;
-		dev->vlan_features |= SKY2_VLAN_OFFLOADS;
+		netdev_vlan_features_set_array(dev, &sky2_vlan_feature_set);
 	}
 
 	dev->features |= dev->hw_features;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index f1259bdb1a29..edde15669886 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/slab.h>
 
 #include <linux/mlx4/driver.h>
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index ca4b93a01034..594a650b6bdc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -39,6 +39,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/netdev_features_helper.h>
 #include <net/ip.h>
 #include <net/vxlan.h>
 #include <net/devlink.h>
@@ -3155,6 +3156,41 @@ void mlx4_en_set_stats_bitmap(struct mlx4_dev *dev,
 	last_i += NUM_PHY_STATS;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(mlx4_gso_feature_set,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mlx4_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mlx4_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mlx4_hw_feature_set1,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mlx4_hw_feature_set2,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXHASH_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mlx4_hw_feature_set3,
+				  NETIF_F_LOOPBACK_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mlx4_vlan_tag_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_STAG_TX_BIT,
+				  NETIF_F_HW_VLAN_STAG_RX_BIT);
+
 int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 			struct mlx4_en_port_profile *prof)
 {
@@ -3322,37 +3358,28 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	/*
 	 * Set driver features
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &mlx4_hw_feature_set1);
 	if (mdev->LSO_support)
 		dev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
 
 	if (mdev->dev->caps.tunnel_offload_mode ==
 	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
-		dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
-		dev->features    |= NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
+		netdev_hw_features_set_array(dev, &mlx4_gso_feature_set);
+		netdev_active_features_set_array(dev, &mlx4_gso_feature_set);
 		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		dev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				       NETIF_F_RXCSUM |
-				       NETIF_F_TSO | NETIF_F_TSO6 |
-				       NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				       NETIF_F_GSO_PARTIAL;
+		netdev_hw_enc_features_zero(dev);
+		netdev_hw_enc_features_set_array(dev, &mlx4_hw_enc_feature_set);
 
 		dev->udp_tunnel_nic_info = &mlx4_udp_tunnels;
 	}
 
 	dev->vlan_features = dev->hw_features;
 
-	dev->hw_features |= NETIF_F_RXCSUM | NETIF_F_RXHASH;
-	dev->features = dev->hw_features | NETIF_F_HIGHDMA |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_VLAN_CTAG_FILTER;
-	dev->hw_features |= NETIF_F_LOOPBACK |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_set_array(dev, &mlx4_hw_feature_set2);
+	dev->features = dev->hw_features;
+	netdev_active_features_set_array(dev, &mlx4_feature_set);
+	netdev_hw_features_set_array(dev, &mlx4_hw_feature_set3);
 
 	if (!(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN)) {
 		dev->features |= NETIF_F_HW_VLAN_STAG_RX |
@@ -3372,14 +3399,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		err = mlx4_get_is_vlan_offload_disabled(mdev->dev, port,
 							&vlan_offload_disabled);
 		if (!err && vlan_offload_disabled) {
-			dev->hw_features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-					      NETIF_F_HW_VLAN_CTAG_RX |
-					      NETIF_F_HW_VLAN_STAG_TX |
-					      NETIF_F_HW_VLAN_STAG_RX);
-			dev->features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-					   NETIF_F_HW_VLAN_CTAG_RX |
-					   NETIF_F_HW_VLAN_STAG_TX |
-					   NETIF_F_HW_VLAN_STAG_RX);
+			netdev_hw_features_clear_array(dev, &mlx4_vlan_tag_feature_set);
+			netdev_active_features_clear_array(dev, &mlx4_vlan_tag_feature_set);
 		}
 	} else {
 		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_PHV_EN &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index c02b7b08fb4c..d859b58c4c8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -31,6 +31,7 @@
  */
 
 #include <rdma/ib_verbs.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/mlx5/fs.h>
 #include "en.h"
 #include "en/params.h"
@@ -72,6 +73,16 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 	params->tunneled_offload_en = false;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(mlx5i_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXHASH_BIT);
+
 /* Called directly after IPoIB netdevice was created to initialize SW structs */
 int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev)
 {
@@ -87,14 +98,7 @@ int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev)
 	mlx5e_timestamp_init(priv);
 
 	/* netdev init */
-	netdev->hw_features    |= NETIF_F_SG;
-	netdev->hw_features    |= NETIF_F_IP_CSUM;
-	netdev->hw_features    |= NETIF_F_IPV6_CSUM;
-	netdev->hw_features    |= NETIF_F_GRO;
-	netdev->hw_features    |= NETIF_F_TSO;
-	netdev->hw_features    |= NETIF_F_TSO6;
-	netdev->hw_features    |= NETIF_F_RXCSUM;
-	netdev->hw_features    |= NETIF_F_RXHASH;
+	netdev_hw_features_set_array(netdev, &mlx5i_hw_feature_set);
 
 	netdev->netdev_ops = &mlx5i_netdev_ops;
 	netdev->ethtool_ops = &mlx5i_ethtool_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1e240cdd9cbd..a38ed21cfbdf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/slab.h>
@@ -1596,6 +1597,16 @@ static int mlxsw_sp_port_label_info_get(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(mlxsw_feature_set,
+				  NETIF_F_NETNS_LOCAL_BIT,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_TC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mlxsw_hw_feature_set,
+				  NETIF_F_HW_TC_BIT,
+				  NETIF_F_LOOPBACK_BIT);
+
 static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				bool split,
 				struct mlxsw_sp_port_mapping *port_mapping)
@@ -1682,9 +1693,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 
 	netif_carrier_off(dev);
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_LLTX | NETIF_F_SG |
-			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
-	dev->hw_features |= NETIF_F_HW_TC | NETIF_F_LOOPBACK;
+	netdev_active_features_set_array(dev, &mlxsw_feature_set);
+	netdev_hw_features_set_array(dev, &mlxsw_hw_feature_set);
 
 	dev->min_mtu = 0;
 	dev->max_mtu = ETH_MAX_MTU;
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 2b3eb5ed8233..07b6d0124d1a 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/micrel_phy.h>
+#include <linux/netdev_features_helper.h>
 
 
 /* DMA Registers */
@@ -6686,6 +6687,11 @@ static int stp;
  */
 static int fast_aging;
 
+static DECLARE_NETDEV_FEATURE_SET(ksz_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /**
  * netdev_init - initialize network device.
  * @dev:	Network device.
@@ -6705,7 +6711,8 @@ static int __init netdev_init(struct net_device *dev)
 	/* 500 ms timeout */
 	dev->watchdog_timeo = HZ / 2;
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &ksz_hw_feature_set);
 
 	/*
 	 * Hardware does not really support IPv6 checksum generation, but
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a9a1dea6d731..5f429b54bc30 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/crc32.h>
 #include <linux/microchipphy.h>
@@ -3323,6 +3324,11 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 	return ret;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(lan743x_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+
 /* lan743x_pcidev_probe - Device Initialization Routine
  * @pdev: PCI device information struct
  * @id: entry in lan743x_pci_tbl
@@ -3383,7 +3389,8 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 
 	adapter->netdev->netdev_ops = &lan743x_netdev_ops;
 	adapter->netdev->ethtool_ops = &lan743x_ethtool_ops;
-	adapter->netdev->features = NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM;
+	netdev_active_features_zero(adapter->netdev);
+	netdev_active_features_set_array(adapter->netdev, &lan743x_hw_feature_set);
 	adapter->netdev->hw_features = adapter->netdev->features;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9259a74eca40..d2a424573d89 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2039,6 +2039,15 @@ int mana_detach(struct net_device *ndev, bool from_close)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(mana_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXHASH_BIT);
+
 static int mana_probe_port(struct mana_context *ac, int port_idx,
 			   struct net_device **ndev_storage)
 {
@@ -2081,10 +2090,8 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	netdev_lockdep_set_classes(ndev);
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	ndev->hw_features |= NETIF_F_RXCSUM;
-	ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
-	ndev->hw_features |= NETIF_F_RXHASH;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &mana_hw_feature_set);
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 5e6136e80282..0f88dac6920a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -10,6 +10,7 @@
 
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of_net.h>
 #include <linux/phy/phy.h>
 #include <net/pkt_cls.h>
@@ -1809,6 +1810,14 @@ static int ocelot_port_phylink_create(struct ocelot *ocelot, int port,
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ocelot_hw_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_RXFCS_BIT,
+				  NETIF_F_HW_TC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ocelot_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_TC_BIT);
+
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct device_node *portnp)
 {
@@ -1833,9 +1842,8 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	dev->ethtool_ops = &ocelot_ethtool_ops;
 	dev->max_mtu = OCELOT_JUMBO_MTU;
 
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
-		NETIF_F_HW_TC;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
+	netdev_hw_features_set_array(dev, &ocelot_hw_feature_set);
+	netdev_active_features_set_array(dev, &ocelot_feature_set);
 
 	err = of_get_ethdev_address(portnp, dev);
 	if (err)
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 971dde8c3286..cffe22b5f5f3 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -42,6 +42,7 @@
 
 #include <linux/tcp.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/module.h>
@@ -243,7 +244,7 @@ struct myri10ge_priv {
 	unsigned long serial_number;
 	int vendor_specific_offset;
 	int fw_multicast_support;
-	u32 features;
+	netdev_features_t features;
 	u32 max_tso6;
 	u32 read_dma;
 	u32 write_dma;
@@ -681,13 +682,19 @@ static int myri10ge_adopt_running_firmware(struct myri10ge_priv *mgp)
 	return status;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(myri10ge_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT);
+
 static int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
 {
 	struct myri10ge_cmd cmd;
 	int status;
 
 	/* probe for IPv6 TSO support */
-	mgp->features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO;
+	netdev_features_zero(&mgp->features);
+	netdev_features_set_array(&myri10ge_feature_set, &mgp->features);
 	status = myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_MAX_TSO6_HDR_SIZE,
 				   &cmd, 0);
 	if (status == 0) {
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 30f955efa830..79dd414f6e36 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -60,6 +60,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/mdio.h>
 #include <linux/skbuff.h>
@@ -7638,6 +7639,19 @@ static const struct net_device_ops s2io_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(s2io_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_SG_BIT);
+static DECLARE_NETDEV_FEATURE_SET(s2io_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 /**
  *  s2io_init_nic - Initialization of the adapter .
  *  @pdev : structure containing the PCI related information of the device.
@@ -7853,12 +7867,10 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 	/*  Driver entry points */
 	dev->netdev_ops = &s2io_netdev_ops;
 	dev->ethtool_ops = &netdev_ethtool_ops;
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_RXCSUM | NETIF_F_LRO;
-	dev->features |= dev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &s2io_hw_feature_set);
+	dev->features |= dev->hw_features;
+	netdev_active_features_set_array(dev, &s2io_feature_set);
 	dev->watchdog_timeo = WATCH_DOG_TIMEOUT;
 	INIT_WORK(&sp->rst_timer_task, s2io_restart_nic);
 	INIT_WORK(&sp->set_link_task, s2io_set_link);
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 5116badaf091..71c5363084e6 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -37,6 +37,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -5706,6 +5707,12 @@ static const struct net_device_ops nv_netdev_ops_optimized = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(nv_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 {
 	struct net_device *dev;
@@ -5811,8 +5818,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	if (id->driver_data & DEV_HAS_CHECKSUM) {
 		np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
-		dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_RXCSUM;
+		netdev_hw_features_set_array(dev, &nv_hw_feature_set);
 	}
 
 	np->vlanctl_bits = 0;
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 46da937ad27f..8213d2300ff4 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -13,6 +13,7 @@
 #include <linux/gpio/machine.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_pch.h>
@@ -2463,6 +2464,11 @@ static void pch_gbe_remove(struct pci_dev *pdev)
 	free_netdev(netdev);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(pch_gbe_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+
 static int pch_gbe_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *pci_id)
 {
@@ -2518,8 +2524,8 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	netdev->watchdog_timeo = PCH_GBE_WATCHDOG_PERIOD;
 	netif_napi_add(netdev, &adapter->napi,
 		       pch_gbe_napi_poll, NAPI_POLL_WEIGHT);
-	netdev->hw_features = NETIF_F_RXCSUM |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &pch_gbe_hw_feature_set);
 	netdev->features = netdev->hw_features;
 	pch_gbe_set_ethtool_ops(netdev);
 
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index f0ace3a0e85c..55437fd2de69 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1672,6 +1672,13 @@ static const struct net_device_ops pasemi_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(pasemi_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_GSO_BIT);
+
 static int
 pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -1699,8 +1706,8 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &mac->napi, pasemi_mac_poll, 64);
 
-	dev->features = NETIF_F_IP_CSUM | NETIF_F_LLTX | NETIF_F_SG |
-			NETIF_F_HIGHDMA | NETIF_F_GSO;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &pasemi_feature_set);
 
 	mac->dma_pdev = pci_get_device(PCI_VENDOR_ID_PASEMI, 0xa007, NULL);
 	if (!mac->dma_pdev) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1443f788ee37..4f2511f763dd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -5,6 +5,7 @@
 #include <linux/printk.h>
 #include <linux/dynamic_debug.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/rtnetlink.h>
@@ -1479,6 +1480,17 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ionic_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_TSO_ECN_BIT);
+
 static int ionic_init_nic_features(struct ionic_lif *lif)
 {
 	struct net_device *netdev = lif->netdev;
@@ -1486,15 +1498,8 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	int err;
 
 	/* set up what we expect to support by default */
-	features = NETIF_F_HW_VLAN_CTAG_TX |
-		   NETIF_F_HW_VLAN_CTAG_RX |
-		   NETIF_F_HW_VLAN_CTAG_FILTER |
-		   NETIF_F_SG |
-		   NETIF_F_HW_CSUM |
-		   NETIF_F_RXCSUM |
-		   NETIF_F_TSO |
-		   NETIF_F_TSO6 |
-		   NETIF_F_TSO_ECN;
+	netdev_features_zero(&features);
+	netdev_features_set_array(&ionic_feature_set, &features);
 
 	if (lif->nxqs > 1)
 		features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 4e6f00af17d9..72cbf78344b5 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -5,6 +5,7 @@
  * All rights reserved.
  */
 
+#include <linux/netdev_features_helper.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
@@ -1327,6 +1328,12 @@ netxen_nic_reset_context(struct netxen_adapter *adapter)
 	return err;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(netxen_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int
 netxen_setup_netdev(struct netxen_adapter *adapter,
 		struct net_device *netdev)
@@ -1347,8 +1354,8 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 
 	netdev->ethtool_ops = &netxen_nic_ethtool_ops;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-	                      NETIF_F_RXCSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &netxen_hw_feature_set);
 
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
 		netdev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index f56b679adb4b..04af61f4122a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -20,6 +20,7 @@
 #include <asm/param.h>
 #include <linux/io.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <net/udp_tunnel.h>
@@ -820,6 +821,35 @@ static struct qede_dev *qede_alloc_etherdev(struct qed_dev *cdev,
 	return edev;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(qede_hw_feature_set,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_GRO_HW_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_TC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(qede_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(qede_vlan_feature_set,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(qede_feature_set,
+				  NETIF_F_RXHASH_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
 static void qede_init_ndev(struct qede_dev *edev)
 {
 	struct net_device *ndev = edev->ndev;
@@ -850,9 +880,8 @@ static void qede_init_ndev(struct qede_dev *edev)
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* user-changeble features */
-	hw_features = NETIF_F_GRO | NETIF_F_GRO_HW | NETIF_F_SG |
-		      NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		      NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_TC;
+	netdev_features_zero(&hw_features);
+	netdev_features_set_array(&qede_hw_feature_set, &hw_features);
 
 	if (edev->dev_info.common.b_arfs_capable)
 		hw_features |= NETIF_F_NTUPLE;
@@ -863,10 +892,8 @@ static void qede_init_ndev(struct qede_dev *edev)
 
 	if (udp_tunnel_enable || edev->dev_info.common.gre_enable) {
 		hw_features |= NETIF_F_TSO_ECN;
-		ndev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-					NETIF_F_SG | NETIF_F_TSO |
-					NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-					NETIF_F_RXCSUM;
+		netdev_hw_enc_features_zero(ndev);
+		netdev_hw_enc_features_set_array(ndev, &qede_hw_enc_feature_set);
 	}
 
 	if (udp_tunnel_enable) {
@@ -884,11 +911,10 @@ static void qede_init_ndev(struct qede_dev *edev)
 					  NETIF_F_GSO_GRE_CSUM);
 	}
 
-	ndev->vlan_features = hw_features | NETIF_F_RXHASH | NETIF_F_RXCSUM |
-			      NETIF_F_HIGHDMA;
-	ndev->features = hw_features | NETIF_F_RXHASH | NETIF_F_RXCSUM |
-			 NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA |
-			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX;
+	ndev->vlan_features = hw_features;
+	netdev_vlan_features_set_array(ndev, &qede_vlan_feature_set);
+	ndev->features = hw_features;
+	netdev_active_features_set_array(ndev, &qede_feature_set);
 
 	ndev->hw_features = hw_features;
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 4b8bc46f55c2..2401cbc015f0 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <net/ip.h>
 #include <linux/bitops.h>
+#include <linux/netdev_features_helper.h>
 
 #include "qlcnic.h"
 #include "qlcnic_hdr.h"
@@ -1020,14 +1021,24 @@ int qlcnic_change_mtu(struct net_device *netdev, int mtu)
 	return rc;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(qlcnic_csum_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(qlcnic_changable_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 					      netdev_features_t features)
 {
 	u32 offload_flags = adapter->offload_flags;
 
 	if (offload_flags & BIT_0) {
-		features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			    NETIF_F_IPV6_CSUM;
+		netdev_features_set_array(&qlcnic_csum_feature_set, &features);
 		adapter->rx_csum = 1;
 		if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 			if (!(offload_flags & BIT_1))
@@ -1041,9 +1052,7 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 				features |= NETIF_F_TSO6;
 		}
 	} else {
-		features &= ~(NETIF_F_RXCSUM |
-			      NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM);
+		netdev_features_clear_array(&qlcnic_csum_feature_set, &features);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
 			features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
@@ -1057,6 +1066,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changeable;
 	netdev_features_t changed;
 
 	if (qlcnic_82xx_check(adapter) &&
@@ -1065,11 +1075,10 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 			features = qlcnic_process_flags(adapter, features);
 		} else {
 			changed = features ^ netdev->features;
-			features ^= changed & (NETIF_F_RXCSUM |
-					       NETIF_F_IP_CSUM |
-					       NETIF_F_IPV6_CSUM |
-					       NETIF_F_TSO |
-					       NETIF_F_TSO6);
+			netdev_features_zero(&changeable);
+			netdev_features_set_array(&qlcnic_changable_feature_set,
+						  &changeable);
+			features ^= changed & changeable;
 		}
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 28476b982bab..f8c043914d6a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -14,6 +14,7 @@
 #include <linux/inetdevice.h>
 #include <linux/aer.h>
 #include <linux/log2.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <net/vxlan.h>
 
@@ -2258,6 +2259,25 @@ static int qlcnic_set_real_num_queues(struct qlcnic_adapter *adapter,
 	return err;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(qlcnic_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(qlcnic_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(qlcnic_hw_enc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 int
 qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 {
@@ -2276,11 +2296,8 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 	netdev->ethtool_ops = (qlcnic_sriov_vf_check(adapter)) ?
 		&qlcnic_sriov_vf_ethtool_ops : &qlcnic_ethtool_ops;
 
-	netdev->features |= (NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-			     NETIF_F_IPV6_CSUM | NETIF_F_GRO |
-			     NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA);
-	netdev->vlan_features |= (NETIF_F_SG | NETIF_F_IP_CSUM |
-				  NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA);
+	netdev_active_features_set_array(netdev, &qlcnic_feature_set);
+	netdev_vlan_features_set_array(netdev, &qlcnic_vlan_feature_set);
 
 	if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 		netdev->features |= (NETIF_F_TSO | NETIF_F_TSO6);
@@ -2300,10 +2317,9 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 		netdev->features |= NETIF_F_GSO_UDP_TUNNEL;
 
 		/* encapsulation Tx offload supported by Adapter */
-		netdev->hw_enc_features = NETIF_F_IP_CSUM        |
-					  NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_TSO            |
-					  NETIF_F_TSO6;
+		netdev_vlan_features_zero(netdev);
+		netdev_vlan_features_set_array(netdev,
+					       &qlcnic_hw_enc_feature_set);
 	}
 
 	if (qlcnic_encap_rx_offload(adapter)) {
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index a55c52696d49..c302d50324fb 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/of_device.h>
@@ -590,6 +591,20 @@ static const struct acpi_device_id emac_acpi_match[] = {
 MODULE_DEVICE_TABLE(acpi, emac_acpi_match);
 #endif
 
+static DECLARE_NETDEV_FEATURE_SET(emac_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(emac_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static int emac_probe(struct platform_device *pdev)
 {
 	struct net_device *netdev;
@@ -665,13 +680,11 @@ static int emac_probe(struct platform_device *pdev)
 	}
 
 	/* set hw features */
-	netdev->features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_array(netdev, &emac_feature_set);
 	netdev->hw_features = netdev->features;
 
-	netdev->vlan_features |= NETIF_F_SG | NETIF_F_HW_CSUM |
-				 NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_vlan_features_set_array(netdev, &emac_vlan_feature_set);
 
 	/* MTU range: 46 - 9194 */
 	netdev->min_mtu = EMAC_MIN_ETH_FRAME_SIZE -
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 1b2119b1d48a..92215121428f 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_arp.h>
+#include <linux/netdev_features_helper.h>
 #include <net/pkt_sched.h>
 #include "rmnet_config.h"
 #include "rmnet_handlers.h"
@@ -243,6 +244,12 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	eth_random_addr(rmnet_dev->perm_addr);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(rmnet_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_SG_BIT);
+
 /* Exposed API */
 
 int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
@@ -261,9 +268,8 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		return -EBUSY;
 	}
 
-	rmnet_dev->hw_features = NETIF_F_RXCSUM;
-	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	rmnet_dev->hw_features |= NETIF_F_SG;
+	netdev_hw_features_zero(rmnet_dev);
+	netdev_hw_features_set_array(rmnet_dev, &rmnet_hw_feature_set);
 
 	priv->real_dev = real_dev;
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index e0feeec13da6..c5c2e491d251 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -58,6 +58,7 @@
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -1883,6 +1884,18 @@ static const struct net_device_ops cp_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(cp_default_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(cp_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *dev;
@@ -1990,16 +2003,14 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &cp_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_features_set_array(dev, &cp_default_feature_set);
 
 	if (pci_using_dac)
 		dev->features |= NETIF_F_HIGHDMA;
 
-	dev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HIGHDMA;
+	netdev_hw_features_set_array(dev, &cp_default_feature_set);
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_array(dev, &cp_vlan_feature_set);
 
 	/* MTU range: 60 - 4096 */
 	dev->min_mtu = CP_MIN_MTU;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 15b40fd93cd2..3844a0f418ec 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -102,6 +102,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/delay.h>
@@ -940,6 +941,11 @@ static const struct net_device_ops rtl8139_netdev_ops = {
 	.ndo_set_features	= rtl8139_set_features,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(rtl8139_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static int rtl8139_init_one(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
@@ -1008,7 +1014,7 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	 * through the use of skb_copy_and_csum_dev we enable these
 	 * features
 	 */
-	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA;
+	netdev_active_features_set_array(dev, &rtl8139_feature_set);
 	dev->vlan_features = dev->features;
 
 	dev->hw_features |= NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1b7fdb4f056b..b999f129490c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -5298,6 +5299,16 @@ static bool rtl_aspm_is_safe(struct rtl8169_private *tp)
 	return false;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(rtl_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(rtl_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT);
+
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct rtl8169_private *tp;
@@ -5415,9 +5426,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &rtl_hw_feature_set);
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_array(dev, &rtl_vlan_feature_set);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/*
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index a1c10b61269b..30af142820c6 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/prefetch.h>
@@ -2050,6 +2051,15 @@ static int sxgbe_sw_reset(void __iomem *addr)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(sxgbe_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GRO_BIT);
+
 /**
  * sxgbe_drv_probe
  * @device: device pointer
@@ -2105,9 +2115,8 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 
 	ndev->netdev_ops = &sxgbe_netdev_ops;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_RXCSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_GRO;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &sxgbe_hw_feature_set);
 	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index ee734b69150f..21db8af0fb73 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1301,6 +1301,12 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 	nic_data->mc_stats = NULL;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ef10_tso_feature_set,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT);
+
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
@@ -1356,8 +1362,9 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+		netdev_features_zero(&encap_tso_features);
+		netdev_features_set_array(&ef10_tso_feature_set,
+					  &encap_tso_features);
 
 		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
 		efx->net_dev->features |= encap_tso_features;
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 17b9d37218cb..15f654e5ad0a 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -345,6 +345,11 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	efx->state = STATE_PROBED;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ef100_vlan_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
@@ -370,8 +375,8 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	net_dev->features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 	net_dev->hw_enc_features |= efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
-				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_array(net_dev, &ef100_vlan_feature_set);
 	netif_set_tso_max_segs(net_dev,
 			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
 	efx->mdio.dev = net_dev;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 8061efdaf82c..819931161be9 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -150,6 +150,15 @@ static int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address)
 	return 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(ef100_tso_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				  NETIF_F_GSO_GRE_BIT,
+				  NETIF_F_GSO_GRE_CSUM_BIT);
+
 int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
@@ -188,10 +197,10 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
 		struct net_device *net_dev = efx->net_dev;
-		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
-					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
+		netdev_features_t tso;
 
+		netdev_features_zero(&tso);
+		netdev_features_set_array(&ef100_tso_feature_set, &tso);
 		net_dev->features |= tso;
 		net_dev->hw_features |= tso;
 		net_dev->hw_enc_features |= tso;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 153d68e29b8b..3baebaabdf32 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -985,6 +985,18 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 	return rc;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(efx_active_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXALL_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(efx_vlan_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
@@ -1001,17 +1013,16 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
+	net_dev->features |= efx->type->offload_features;
+	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
-				   NETIF_F_RXCSUM);
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index a63f40b09856..0240c7f5843a 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2853,6 +2853,12 @@ static int ef4_pci_probe_main(struct ef4_nic *efx)
 	return rc;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(efx_vlan_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /* NIC initialisation
  *
  * This is called at module load (or hotplug insertion,
@@ -2901,9 +2907,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_RXCSUM);
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_RXCSUM);
-
+	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
 
 	/* Disable VLAN filtering by default.  It may be enforced if
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a2c7139f2b32..8ee0cc45e8ad 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -26,6 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
+#include <linux/netdev_features_helper.h>
 #include <net/busy_poll.h>
 
 #include "enum.h"
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 7ef823d7a89a..3ec44ed52933 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -25,6 +25,7 @@
 #include <linux/rwsem.h>
 #include <linux/vmalloc.h>
 #include <linux/mtd/mtd.h>
+#include <linux/netdev_features_helper.h>
 #include <net/busy_poll.h>
 #include <net/xdp.h>
 
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 63d999e63960..050e1b0ad0cb 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/notifier.h>
@@ -967,6 +968,18 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 	return rc;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(efx_active_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_RXALL_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(efx_vlan_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
@@ -983,17 +996,16 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
+	net_dev->features |= efx->type->offload_features;
+	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
-				   NETIF_F_RXCSUM);
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index e2d009866a7b..84227eb0e3a4 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -825,6 +825,13 @@ static const struct net_device_ops ioc3_netdev_ops = {
 	.ndo_set_mac_address	= ioc3_set_mac_address,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(ioc_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(ioc_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static int ioc3eth_probe(struct platform_device *pdev)
 {
 	u32 sw_physid1, sw_physid2, vendor, model, rev;
@@ -926,8 +933,10 @@ static int ioc3eth_probe(struct platform_device *pdev)
 	dev->watchdog_timeo	= 5 * HZ;
 	dev->netdev_ops		= &ioc3_netdev_ops;
 	dev->ethtool_ops	= &ioc3_ethtool_ops;
-	dev->hw_features	= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
-	dev->features		= NETIF_F_IP_CSUM | NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &ioc_hw_feature_set);
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &ioc_feature_set);
 
 	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
 	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index ff4197f5e46d..65b0b8574698 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -1394,6 +1395,12 @@ static const struct net_device_ops sc92031_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(sc92031_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+
 static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err;
@@ -1437,8 +1444,8 @@ static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	/* faked with skb_copy_and_csum_dev */
-	dev->features = NETIF_F_SG | NETIF_F_HIGHDMA |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &sc92031_feature_set);
 
 	dev->netdev_ops		= &sc92031_netdev_ops;
 	dev->watchdog_timeo	= TX_TIMEOUT;
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index b0c5a44785fa..67fba95978b4 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -10,6 +10,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/netlink.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
@@ -1975,6 +1976,13 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 	return ret;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(netsec_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+
 static int netsec_probe(struct platform_device *pdev)
 {
 	struct resource *mmio_res, *eeprom_res;
@@ -2098,8 +2106,7 @@ static int netsec_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &netsec_netdev_ops;
 	ndev->ethtool_ops = &netsec_ethtool_ops;
 
-	ndev->features |= NETIF_F_HIGHDMA | NETIF_F_RXCSUM | NETIF_F_GSO |
-				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_active_features_set_array(ndev, &netsec_feature_set);
 	ndev->hw_features = ndev->features;
 
 	priv->rx_cksum_offload_flag = true;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 070b5ef165eb..23b80ddad54d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -35,6 +35,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #endif /* CONFIG_DEBUG_FS */
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/phylink.h>
 #include <linux/udp.h>
@@ -7026,6 +7027,12 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
 	}
 }
 
+static DECLARE_NETDEV_FEATURE_SET(stmmac_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /**
  * stmmac_dvr_probe
  * @device: device pointer
@@ -7132,8 +7139,8 @@ int stmmac_dvr_probe(struct device *device,
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_RXCSUM;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &stmmac_hw_feature_set);
 
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 0cd8493b810f..49fa25fa045b 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -223,6 +223,10 @@ static struct vnet *vsw_get_vnet(struct mdesc_handle *hp,
 	return vp;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(vsw_hw_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT);
+
 static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 					   struct vio_dev *vdev,
 					   u64 handle,
@@ -246,7 +250,8 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 	dev->ethtool_ops = &vsw_ethtool_ops;
 	dev->watchdog_timeo = VSW_TX_TIMEOUT;
 
-	dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &vsw_hw_feature_set);
 	dev->features = dev->hw_features;
 
 	/* MTU range: 68 - 65535 */
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index df70df29deea..f7fa28ba5d53 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
@@ -9733,9 +9734,15 @@ static void niu_device_announce(struct niu *np)
 	}
 }
 
+static DECLARE_NETDEV_FEATURE_SET(niu_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXHASH_BIT);
+
 static void niu_set_basic_features(struct net_device *dev)
 {
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXHASH;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &niu_hw_feature_set);
 	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
 }
 
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index a14591b41acb..42a7a6a5926f 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/mii.h>
@@ -2843,6 +2844,11 @@ static const struct net_device_ops gem_netdev_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(gem_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned long gemreg_base, gemreg_len;
@@ -2989,7 +2995,8 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, dev);
 
 	/* We can do scatter/gather and HW checksum */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &gem_hw_feature_set);
 	dev->features = dev->hw_features;
 	if (pci_using_dac)
 		dev->features |= NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index da8119625cf3..0552fe23a397 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -281,6 +281,12 @@ static const struct net_device_ops vnet_ops = {
 #endif
 };
 
+static DECLARE_NETDEV_FEATURE_SET(vnet_hw_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT);
+
 static struct vnet *vnet_new(const u64 *local_mac,
 			     struct vio_dev *vdev)
 {
@@ -314,8 +320,8 @@ static struct vnet *vnet_new(const u64 *local_mac,
 	dev->ethtool_ops = &vnet_ethtool_ops;
 	dev->watchdog_timeo = VNET_TX_TIMEOUT;
 
-	dev->hw_features = NETIF_F_TSO | NETIF_F_GSO | NETIF_F_ALL_TSO |
-			   NETIF_F_HW_CSUM | NETIF_F_SG;
+	dev->hw_features = NETIF_F_ALL_TSO;
+	netdev_hw_features_set_array(dev, &vnet_hw_feature_set);
 	dev->features = dev->hw_features;
 
 	/* MTU range: 68 - 65535 */
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 985073eba3bd..fd89439791ce 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1862,6 +1862,21 @@ static const struct net_device_ops bdx_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= bdx_vlan_rx_kill_vid,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(bdx_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(bdx_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
 /**
  * bdx_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -1976,13 +1991,11 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* these fields are used for info purposes only
 		 * so we can have them same for all ports of the board */
 		ndev->if_port = port;
-		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO |
-		    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM |
-		    NETIF_F_HIGHDMA;
+		netdev_active_features_zero(ndev);
+		netdev_active_features_set_array(ndev, &bdx_feature_set);
 
-		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_hw_features_zero(ndev);
+		netdev_hw_features_set_array(ndev, &bdx_hw_feature_set);
 
 	/************** priv ****************/
 		priv = nic->priv[port] = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/tehuti/tehuti.h b/drivers/net/ethernet/tehuti/tehuti.h
index 909e7296cecf..eef81f973233 100644
--- a/drivers/net/ethernet/tehuti/tehuti.h
+++ b/drivers/net/ethernet/tehuti/tehuti.h
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f4a6b590a1e3..b390983861d8 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -14,6 +14,7 @@
 #include <linux/kmemleak.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/of.h>
 #include <linux/of_mdio.h>
@@ -1932,6 +1933,12 @@ static void am65_cpsw_nuss_phylink_cleanup(struct am65_cpsw_common *common)
 	}
 }
 
+static DECLARE_NETDEV_FEATURE_SET(am65_cpsw_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_TC_BIT);
+
 static int
 am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 {
@@ -1966,10 +1973,8 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
 	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
-	port->ndev->hw_features = NETIF_F_SG |
-				  NETIF_F_RXCSUM |
-				  NETIF_F_HW_CSUM |
-				  NETIF_F_HW_TC;
+	netdev_hw_features_zero(port->ndev);
+	netdev_hw_features_set_array(port->ndev, &am65_cpsw_hw_feature_set);
 	port->ndev->features = port->ndev->hw_features |
 			       NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 353e58b22c51..fb9ba01138f1 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
@@ -1359,6 +1360,12 @@ static void cpsw_remove_dt(struct cpsw_common *cpsw)
 	}
 }
 
+static DECLARE_NETDEV_FEATURE_SET(cpsw_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_NETNS_LOCAL_BIT,
+				  NETIF_F_HW_TC_BIT);
+
 static int cpsw_create_ports(struct cpsw_common *cpsw)
 {
 	struct cpsw_platform_data *data = &cpsw->data;
@@ -1403,9 +1410,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 
 		cpsw->slaves[i].ndev = ndev;
 
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
-
+		netdev_active_features_set_array(ndev, &cpsw_feature_set);
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index ff0c102cb578..06ac16f37bf5 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -45,6 +45,7 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
@@ -2748,6 +2749,16 @@ static u32 velocity_get_link(struct net_device *dev)
 	return BYTE_REG_BITS_IS_ON(PHYSR0_LINKGD, &regs->PHYSR0) ? 1 : 0;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(velocity_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(velocity_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_IP_CSUM_BIT);
+
 /**
  *	velocity_probe - set up discovered velocity device
  *	@dev: PCI device
@@ -2848,11 +2859,9 @@ static int velocity_probe(struct device *dev, int irq,
 	netdev->ethtool_ops = &velocity_ethtool_ops;
 	netif_napi_add(netdev, &vptr->napi, velocity_poll, NAPI_POLL_WEIGHT);
 
-	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-			   NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_IP_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &velocity_hw_feature_set);
+	netdev_active_features_set_array(netdev, &velocity_feature_set);
 
 	/* MTU range: 64 - 9000 */
 	netdev->min_mtu = VELOCITY_MIN_MTU;
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 018d365f9deb..33a1554c7f83 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/hash.h>
+#include <linux/netdev_features_helper.h>
 #include <net/ipv6_stubs.h>
 #include <net/dst_metadata.h>
 #include <net/gro_cells.h>
@@ -1234,6 +1235,18 @@ static void geneve_offload_rx_ports(struct net_device *dev, bool push)
 	rcu_read_unlock();
 }
 
+static DECLARE_NETDEV_FEATURE_SET(geneve_feature_set,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(geneve_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /* Initialize the device structure. */
 static void geneve_setup(struct net_device *dev)
 {
@@ -1245,13 +1258,10 @@ static void geneve_setup(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &geneve_type);
 
-	dev->features    |= NETIF_F_LLTX;
-	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features    |= NETIF_F_RXCSUM;
+	netdev_active_features_set_array(dev, &geneve_feature_set);
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
 
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_features_set_array(dev, &geneve_hw_feature_set);
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 
 	/* MTU range: 68 - (something less than 65535) */
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 15ebd5426604..6bf8d63132a1 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
@@ -2450,6 +2451,11 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
 	return NOTIFY_OK;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(netvsc_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
 static int netvsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -2533,9 +2539,8 @@ static int netvsc_probe(struct hv_device *dev,
 		schedule_work(&nvdev->subchan_work);
 
 	/* hw_features computed in rndis_netdev_set_hwcaps() */
-	net->features = net->hw_features |
-		NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
+	net->features = net->hw_features;
+	netdev_active_features_set_array(net, &netvsc_feature_set);
 	net->vlan_features = net->features;
 
 	netdev_lockdep_set_classes(net);
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 1c64d5347b8e..92ffd1b9849b 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -288,10 +289,13 @@ static const struct ethtool_ops ifb_ethtool_ops = {
 	.get_ethtool_stats	= ifb_get_ethtool_stats,
 };
 
-#define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST	| \
-		      NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL	| \
-		      NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX		| \
-		      NETIF_F_HW_VLAN_STAG_TX)
+static DECLARE_NETDEV_FEATURE_SET(ifb_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_STAG_TX_BIT);
 
 static void ifb_dev_free(struct net_device *dev)
 {
@@ -309,6 +313,8 @@ static void ifb_dev_free(struct net_device *dev)
 
 static void ifb_setup(struct net_device *dev)
 {
+	netdev_features_t ifb_features;
+
 	/* Initialize the device structure. */
 	dev->netdev_ops = &ifb_netdev_ops;
 	dev->ethtool_ops = &ifb_ethtool_ops;
@@ -317,10 +323,12 @@ static void ifb_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->tx_queue_len = TX_Q_LIMIT;
 
-	dev->features |= IFB_FEATURES;
+	ifb_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_array(&ifb_feature_set, &ifb_features);
+	dev->features |= ifb_features;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
-	dev->vlan_features |= IFB_FEATURES & ~(NETIF_F_HW_VLAN_CTAG_TX |
+	dev->vlan_features |= ifb_features & ~(NETIF_F_HW_VLAN_CTAG_TX |
 					       NETIF_F_HW_VLAN_STAG_TX);
 
 	dev->flags |= IFF_NOARP;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 49ba8a50dfb1..b0d7a484fd39 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -3,9 +3,14 @@
  */
 
 #include <linux/ethtool.h>
+#include <linux/netdev_features_helper.h>
 
 #include "ipvlan.h"
 
+static netdev_features_t ipvlan_offload_features __ro_after_init;
+static netdev_features_t ipvlan_always_on_features __ro_after_init;
+static netdev_features_t ipvlan_features __ro_after_init;
+
 static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
 				struct netlink_ext_ack *extack)
 {
@@ -107,18 +112,30 @@ static void ipvlan_port_destroy(struct net_device *dev)
 	kfree(port);
 }
 
-#define IPVLAN_ALWAYS_ON_OFLOADS \
-	(NETIF_F_SG | NETIF_F_HW_CSUM | \
-	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL)
-
-#define IPVLAN_ALWAYS_ON \
-	(IPVLAN_ALWAYS_ON_OFLOADS | NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED)
-
-#define IPVLAN_FEATURES \
-	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
-	 NETIF_F_GSO | NETIF_F_ALL_TSO | NETIF_F_GSO_ROBUST | \
-	 NETIF_F_GRO | NETIF_F_RXCSUM | \
-	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
+static DECLARE_NETDEV_FEATURE_SET(ipvlan_on_offload_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_GSO_ROBUST_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(ipvlan_always_on_feature_set,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_VLAN_CHALLENGED_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(ipvlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_GSO_ROBUST_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+
+#define IPVLAN_FEATURES			ipvlan_features
+#define IPVLAN_ALWAYS_ON_OFLOADS	ipvlan_offload_features
+#define IPVLAN_ALWAYS_ON		ipvlan_always_on_features
 
 	/* NETIF_F_GSO_ENCAP_ALL NETIF_F_GSO_SOFTWARE Newly added */
 
@@ -1018,6 +1035,21 @@ static struct notifier_block ipvlan_addr6_vtor_notifier_block __read_mostly = {
 };
 #endif
 
+static void __init ipvlan_features_init(void)
+{
+	ipvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_array(&ipvlan_on_offload_feature_set,
+				  &ipvlan_offload_features);
+
+	ipvlan_always_on_features = ipvlan_offload_features;
+	netdev_features_set_array(&ipvlan_always_on_feature_set,
+				  &ipvlan_always_on_features);
+
+	ipvlan_features = NETIF_F_ALL_TSO;
+	netdev_features_set_array(&ipvlan_feature_set,
+				  &ipvlan_features);
+}
+
 static int __init ipvlan_init_module(void)
 {
 	int err;
@@ -1042,6 +1074,8 @@ static int __init ipvlan_init_module(void)
 		goto error;
 	}
 
+	ipvlan_features_init();
+
 	return 0;
 error:
 	unregister_inetaddr_notifier(&ipvlan_addr4_notifier_block);
diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index ef02f2cf5ce1..c6d95576ad40 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -18,14 +18,18 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/netdev_features_helper.h>
 
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 #include <linux/virtio_net.h>
 
-#define TUN_OFFLOADS (NETIF_F_HW_CSUM | NETIF_F_TSO_ECN | NETIF_F_TSO | \
-		      NETIF_F_TSO6)
+static DECLARE_NETDEV_FEATURE_SET(tun_offload_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
 
 static dev_t ipvtap_major;
 static struct cdev ipvtap_cdev;
@@ -86,7 +90,9 @@ static int ipvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	vlantap->tap.tap_features = TUN_OFFLOADS;
+	netdev_features_zero(&vlantap->tap.tap_features);
+	netdev_features_set_array(&tun_offload_feature_set,
+				  &vlantap->tap.tap_features);
 	vlantap->tap.count_tx_dropped = ipvtap_count_tx_dropped;
 	vlantap->tap.update_features =	ipvtap_update_features;
 	vlantap->tap.count_rx_dropped = ipvtap_count_rx_dropped;
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 14e8d04cb434..308c8674e3ad 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -41,6 +41,7 @@
 
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -160,6 +161,18 @@ static const struct net_device_ops loopback_ops = {
 	.ndo_set_mac_address = eth_mac_addr,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(lp_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_NETNS_LOCAL_BIT,
+				  NETIF_F_VLAN_CHALLENGED_BIT,
+				  NETIF_F_LOOPBACK_BIT);
+
 static void gen_lo_setup(struct net_device *dev,
 			 unsigned int mtu,
 			 const struct ethtool_ops *eth_ops,
@@ -176,16 +189,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
 	netif_keep_dst(dev);
 	dev->hw_features	= NETIF_F_GSO_SOFTWARE;
-	dev->features		= NETIF_F_SG | NETIF_F_FRAGLIST
-		| NETIF_F_GSO_SOFTWARE
-		| NETIF_F_HW_CSUM
-		| NETIF_F_RXCSUM
-		| NETIF_F_SCTP_CRC
-		| NETIF_F_HIGHDMA
-		| NETIF_F_LLTX
-		| NETIF_F_NETNS_LOCAL
-		| NETIF_F_VLAN_CHALLENGED
-		| NETIF_F_LOOPBACK;
+	dev->features		= NETIF_F_GSO_SOFTWARE;
+	netdev_active_features_set_array(dev, &lp_feature_set);
 	dev->ethtool_ops	= eth_ops;
 	dev->header_ops		= hdr_ops;
 	dev->netdev_ops		= dev_ops;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f1683ce6b561..ca7f01d33483 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -12,6 +12,7 @@
 #include <crypto/aead.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/rtnetlink.h>
 #include <linux/refcount.h>
 #include <net/genetlink.h>
@@ -3420,15 +3421,20 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-#define SW_MACSEC_FEATURES \
-	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
+static netdev_features_t macsec_no_inherit_features __ro_after_init;
+static netdev_features_t sw_macsec_features __ro_after_init;
+static DECLARE_NETDEV_FEATURE_SET(sw_macsec_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_FRAGLIST_BIT);
+#define SW_MACSEC_FEATURES sw_macsec_features
 
 /* If h/w offloading is enabled, use real device features save for
  *   VLAN_FEATURES - they require additional ops
  *   HW_MACSEC - no reason to report it
  */
 #define REAL_DEV_FEATURES(dev) \
-	((dev)->features & ~(NETIF_F_VLAN_FEATURES | NETIF_F_HW_MACSEC))
+	((dev)->features & ~macsec_no_inherit_features)
 
 static int macsec_dev_init(struct net_device *dev)
 {
@@ -4351,6 +4357,14 @@ static struct notifier_block macsec_notifier = {
 	.notifier_call = macsec_notify,
 };
 
+static void __init macsec_features_init(void)
+{
+	netdev_features_set_array(&sw_macsec_feature_set, &sw_macsec_features);
+
+	macsec_no_inherit_features = NETIF_F_VLAN_FEATURES;
+	macsec_no_inherit_features |= NETIF_F_HW_MACSEC;
+}
+
 static int __init macsec_init(void)
 {
 	int err;
@@ -4368,6 +4382,8 @@ static int __init macsec_init(void)
 	if (err)
 		goto rtnl;
 
+	macsec_features_init();
+
 	return 0;
 
 rtnl:
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 1080d6ebff63..d9a20c0341c6 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -19,6 +19,7 @@
 #include <linux/rculist.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/net_tstamp.h>
 #include <linux/ethtool.h>
@@ -67,6 +68,10 @@ struct macvlan_skb_cb {
 
 #define MACVLAN_SKB_CB(__skb) ((struct macvlan_skb_cb *)&((__skb)->cb[0]))
 
+static netdev_features_t macvlan_offload_features __ro_after_init;
+static netdev_features_t macvlan_always_on_features __ro_after_init;
+static netdev_features_t macvlan_features __ro_after_init;
+
 static void macvlan_port_destroy(struct net_device *dev);
 static void update_port_bc_queue_len(struct macvlan_port *port);
 
@@ -868,17 +873,30 @@ static int macvlan_eth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
  */
 static struct lock_class_key macvlan_netdev_addr_lock_key;
 
-#define ALWAYS_ON_OFFLOADS \
-	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE | \
-	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL)
-
-#define ALWAYS_ON_FEATURES (ALWAYS_ON_OFFLOADS | NETIF_F_LLTX)
-
-#define MACVLAN_FEATURES \
-	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
-	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_LRO | \
-	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
-	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
+static DECLARE_NETDEV_FEATURE_SET(macvlan_on_offload_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_GSO_ROBUST_BIT);
+static DECLARE_NETDEV_FEATURE_SET(macvlan_always_on_feature_set,
+				  NETIF_F_LLTX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(macvlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+
+#define MACVLAN_FEATURES	macvlan_features
+#define ALWAYS_ON_OFFLOADS	macvlan_offload_features
+#define ALWAYS_ON_FEATURES	macvlan_always_on_features
 
 #define MACVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
@@ -1813,6 +1831,20 @@ static struct notifier_block macvlan_notifier_block __read_mostly = {
 	.notifier_call	= macvlan_device_event,
 };
 
+static void __init macvlan_features_init(void)
+{
+	macvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_array(&macvlan_on_offload_feature_set,
+				  &macvlan_offload_features);
+
+	macvlan_always_on_features = macvlan_offload_features;
+	netdev_features_set_array(&macvlan_always_on_feature_set,
+				  &macvlan_always_on_features);
+
+	netdev_features_set_array(&macvlan_feature_set,
+				  &macvlan_features);
+}
+
 static int __init macvlan_init_module(void)
 {
 	int err;
@@ -1822,6 +1854,8 @@ static int __init macvlan_init_module(void)
 	err = macvlan_link_register(&macvlan_link_ops);
 	if (err < 0)
 		goto err1;
+
+	macvlan_features_init();
 	return 0;
 err1:
 	unregister_netdevice_notifier(&macvlan_notifier_block);
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index cecf8c63096c..03ee8c8f9ee7 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -18,6 +18,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/netdev_features_helper.h>
 
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
@@ -49,8 +50,11 @@ static struct class macvtap_class = {
 };
 static struct cdev macvtap_cdev;
 
-#define TUN_OFFLOADS (NETIF_F_HW_CSUM | NETIF_F_TSO_ECN | NETIF_F_TSO | \
-		      NETIF_F_TSO6)
+static DECLARE_NETDEV_FEATURE_SET(tun_offload_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
 
 static void macvtap_count_tx_dropped(struct tap_dev *tap)
 {
@@ -90,7 +94,9 @@ static int macvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	vlantap->tap.tap_features = TUN_OFFLOADS;
+	netdev_features_zero(&vlantap->tap.tap_features);
+	netdev_features_set_array(&tun_offload_feature_set,
+				  &vlantap->tap.tap_features);
 
 	/* Register callbacks for rx/tx drops accounting and updating
 	 * net_device features
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 21a0435c02de..d6c2082d0993 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/module.h>
@@ -27,6 +28,19 @@
 #include <uapi/linux/if_arp.h>
 #include <net/net_failover.h>
 
+static netdev_features_t failover_vlan_features __ro_after_init;
+static netdev_features_t failover_enc_features __ro_after_init;
+static DECLARE_NETDEV_FEATURE_SET(failover_vlan_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(failover_enc_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static bool net_failover_xmit_ready(struct net_device *dev)
 {
 	return netif_running(dev) && netif_carrier_ok(dev);
@@ -823,9 +837,18 @@ void net_failover_destroy(struct failover *failover)
 }
 EXPORT_SYMBOL_GPL(net_failover_destroy);
 
+static __init void net_failover_features_init(void)
+{
+	netdev_features_set_array(&failover_vlan_feature_set,
+				  &failover_vlan_features);
+	netdev_features_set_array(&failover_enc_feature_set,
+				  &failover_enc_features);
+}
+
 static __init int
 net_failover_init(void)
 {
+	net_failover_features_init();
 	return 0;
 }
 module_init(net_failover_init);
diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index 386336a38f34..ad0b5bf06f49 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -272,16 +272,17 @@ bool nsim_ipsec_tx(struct netdevsim *ns, struct sk_buff *skb)
 	return true;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(nsim_esp_feature_set,
+				  NETIF_F_HW_ESP_BIT,
+				  NETIF_F_HW_ESP_TX_CSUM_BIT,
+				  NETIF_F_GSO_ESP_BIT);
+
 void nsim_ipsec_init(struct netdevsim *ns)
 {
 	ns->netdev->xfrmdev_ops = &nsim_xfrmdev_ops;
 
-#define NSIM_ESP_FEATURES	(NETIF_F_HW_ESP | \
-				 NETIF_F_HW_ESP_TX_CSUM | \
-				 NETIF_F_GSO_ESP)
-
-	ns->netdev->features |= NSIM_ESP_FEATURES;
-	ns->netdev->hw_enc_features |= NSIM_ESP_FEATURES;
+	netdev_active_features_set_array(ns->netdev, &nsim_esp_feature_set);
+	netdev_hw_enc_features_set_array(ns->netdev, &nsim_esp_feature_set);
 
 	ns->ipsec.pfile = debugfs_create_file("ipsec", 0400,
 					      ns->nsim_dev_port->ddir, ns,
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e470e3398abc..ad687b14dda3 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/slab.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -278,6 +279,13 @@ static const struct net_device_ops nsim_vf_netdev_ops = {
 	.ndo_get_devlink_port	= nsim_get_devlink_port,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(nsim_feature_set,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_BIT);
+
 static void nsim_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -288,11 +296,7 @@ static void nsim_setup(struct net_device *dev)
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE |
 			   IFF_NO_QUEUE;
-	dev->features |= NETIF_F_HIGHDMA |
-			 NETIF_F_SG |
-			 NETIF_F_FRAGLIST |
-			 NETIF_F_HW_CSUM |
-			 NETIF_F_TSO;
+	netdev_active_features_set_array(dev, &nsim_feature_set);
 	dev->hw_features |= NETIF_F_HW_TC;
 	dev->max_mtu = ETH_MAX_MTU;
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7d8ed8d8df5c..cf020a685530 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/u64_stats_sync.h>
 #include <net/devlink.h>
 #include <net/udp_tunnel.h>
diff --git a/drivers/net/nlmon.c b/drivers/net/nlmon.c
index 5e19a6839dea..2ccfaf04b429 100644
--- a/drivers/net/nlmon.c
+++ b/drivers/net/nlmon.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/netlink.h>
 #include <net/net_namespace.h>
 #include <linux/if_arp.h>
@@ -80,6 +81,12 @@ static const struct net_device_ops nlmon_ops = {
 	.ndo_get_stats64 = nlmon_get_stats64,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(nlmon_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LLTX_BIT);
+
 static void nlmon_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_NETLINK;
@@ -89,8 +96,8 @@ static void nlmon_setup(struct net_device *dev)
 	dev->ethtool_ops = &nlmon_ethtool_ops;
 	dev->needs_free_netdev = true;
 
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			NETIF_F_HIGHDMA | NETIF_F_LLTX;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &nlmon_feature_set);
 	dev->flags = IFF_NOARP;
 
 	/* That's rather a softlimit here, which, of course,
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c3d42062559d..7b1c1e724c43 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -17,6 +17,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/netdev_features_helper.h>
 
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
@@ -116,8 +117,13 @@ struct major_info {
 
 static const struct proto_ops tap_socket_ops;
 
-#define RX_OFFLOADS (NETIF_F_GRO | NETIF_F_LRO)
-#define TAP_FEATURES (NETIF_F_GSO | NETIF_F_SG | NETIF_F_FRAGLIST)
+static DECLARE_NETDEV_FEATURE_SET(tap_rx_offload_feature_set,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_LRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(tap_feature_set,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT);
 
 static struct tap_dev *tap_dev_get_rcu(const struct net_device *dev)
 {
@@ -321,7 +327,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct net_device *dev = skb->dev;
 	struct tap_dev *tap;
 	struct tap_queue *q;
-	netdev_features_t features = TAP_FEATURES;
+	netdev_features_t features;
 	enum skb_drop_reason drop_reason;
 
 	tap = tap_dev_get_rcu(dev);
@@ -334,6 +340,8 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 
 	skb_push(skb, ETH_HLEN);
 
+	netdev_features_zero(&features);
+	netdev_features_set_array(&tap_feature_set, &features);
 	/* Apply the forward feature mask so that we perform segmentation
 	 * according to users wishes.  This only works if VNET_HDR is
 	 * enabled.
@@ -966,9 +974,9 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * user-space will not receive TSO frames.
 	 */
 	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
-		features |= RX_OFFLOADS;
+		netdev_features_set_array(&tap_rx_offload_feature_set, &features);
 	else
-		features &= ~RX_OFFLOADS;
+		netdev_features_clear_array(&tap_rx_offload_feature_set, &features);
 
 	/* tap_features are the same as features on tun/tap and
 	 * reflect user expectations.
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index aac133a1e27a..452d414dff62 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/netpoll.h>
 #include <linux/if_vlan.h>
 #include <linux/if_arp.h>
@@ -980,12 +981,20 @@ static void team_port_disable(struct team *team,
 	team_lower_state_changed(port);
 }
 
-#define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
-			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-			    NETIF_F_HIGHDMA | NETIF_F_LRO)
-
-#define TEAM_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
+static DECLARE_NETDEV_FEATURE_SET(team_vlan_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LRO_BIT);
+static DECLARE_NETDEV_FEATURE_SET(team_enc_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static netdev_features_t team_vlan_features __ro_after_init;
+static netdev_features_t team_enc_features __ro_after_init;
+#define TEAM_VLAN_FEATURES	team_vlan_features
+#define TEAM_ENC_FEATURES	team_enc_features
 
 static void __team_compute_features(struct team *team)
 {
@@ -2875,6 +2884,13 @@ static void team_nl_fini(void)
 	genl_unregister_family(&team_nl_family);
 }
 
+static void __init team_features_init(void)
+{
+	team_vlan_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&team_vlan_feature_set, &team_vlan_features);
+	team_enc_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&team_enc_feature_set, &team_enc_features);
+}
 
 /******************
  * Change checkers
@@ -3031,7 +3047,6 @@ static struct notifier_block team_notifier_block __read_mostly = {
 	.notifier_call = team_device_event,
 };
 
-
 /***********************
  * Module init and exit
  ***********************/
@@ -3050,6 +3065,8 @@ static int __init team_module_init(void)
 	if (err)
 		goto err_nl_init;
 
+	team_features_init();
+
 	return 0;
 
 err_nl_init:
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ff5d0e98a088..baed53386606 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -14,6 +14,7 @@
 #include <linux/jhash.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/rtnetlink.h>
 #include <linux/sizes.h>
 #include <linux/thunderbolt.h>
@@ -1217,6 +1218,12 @@ static void tbnet_generate_mac(struct net_device *dev)
 	eth_hw_addr_set(dev, addr);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(tbnet_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT);
+
 static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 {
 	struct tb_xdomain *xd = tb_service_parent(svc);
@@ -1259,8 +1266,8 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	 * we need to announce support for most of the offloading
 	 * features here.
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_ALL_TSO | NETIF_F_GRO |
-			   NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	dev->hw_features = NETIF_F_ALL_TSO;
+	netdev_hw_features_set_array(dev, &tbnet_hw_feature_set);
 	dev->features = dev->hw_features | NETIF_F_HIGHDMA;
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 259b2b84b2b3..d34d930a3029 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/miscdevice.h>
 #include <linux/ethtool.h>
@@ -171,6 +172,19 @@ struct tun_prog {
 	struct bpf_prog *prog;
 };
 
+static netdev_features_t tun_user_features __ro_after_init;
+static DECLARE_NETDEV_FEATURE_SET(tun_user_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+static DECLARE_NETDEV_FEATURE_SET(tun_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_STAG_TX_BIT);
+#define TUN_USER_FEATURES	tun_user_features
+
 /* Since the socket were moved to tun_file, to preserve the behavior of persist
  * device, socket filter, sndbuf and vnet header size were restore when the
  * file were attached to a persist device.
@@ -184,8 +198,6 @@ struct tun_struct {
 
 	struct net_device	*dev;
 	netdev_features_t	set_features;
-#define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
-			  NETIF_F_TSO6)
 
 	int			align;
 	int			vnet_hdr_sz;
@@ -989,9 +1001,8 @@ static int tun_net_init(struct net_device *dev)
 
 	tun_flow_init(tun);
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->hw_features = TUN_USER_FEATURES;
+	netdev_hw_features_set_array(dev, &tun_hw_feature_set);
 	dev->features = dev->hw_features | NETIF_F_LLTX;
 	dev->vlan_features = dev->features &
 			     ~(NETIF_F_HW_VLAN_CTAG_TX |
@@ -3668,6 +3679,11 @@ static struct notifier_block tun_notifier_block __read_mostly = {
 	.notifier_call	= tun_device_event,
 };
 
+static void __init tun_features_init(void)
+{
+	netdev_features_set_array(&tun_user_feature_set, &tun_user_features);
+}
+
 static int __init tun_init(void)
 {
 	int ret = 0;
@@ -3692,6 +3708,8 @@ static int __init tun_init(void)
 		goto err_notifier;
 	}
 
+	tun_features_init();
+
 	return  0;
 
 err_notifier:
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 3020e81159d0..d55be54264f8 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/usb.h>
@@ -22,6 +23,31 @@
 
 #define DRIVER_NAME "aqc111"
 
+/* Feature. ********************************************/
+DECLARE_NETDEV_FEATURE_SET(aq_support_feature_set,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_HW_VLAN_CTAG_RX_BIT);
+
+DECLARE_NETDEV_FEATURE_SET(aq_support_hw_feature_set,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+
+DECLARE_NETDEV_FEATURE_SET(aq_support_vlan_feature_set,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_TSO_BIT);
+
 static int aqc111_read_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
 				u16 index, u16 size, void *data)
 {
@@ -731,9 +757,9 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (usb_device_no_sg_constraint(dev->udev))
 		dev->can_dma_sg = 1;
 
-	dev->net->hw_features |= AQ_SUPPORT_HW_FEATURE;
-	dev->net->features |= AQ_SUPPORT_FEATURE;
-	dev->net->vlan_features |= AQ_SUPPORT_VLAN_FEATURE;
+	netdev_hw_features_set_array(dev->net, &aq_support_hw_feature_set);
+	netdev_active_features_set_array(dev->net, &aq_support_feature_set);
+	netdev_vlan_features_set_array(dev->net, &aq_support_vlan_feature_set);
 
 	netif_set_tso_max_size(dev->net, 65535);
 
@@ -996,9 +1022,9 @@ static int aqc111_reset(struct usbnet *dev)
 	if (usb_device_no_sg_constraint(dev->udev))
 		dev->can_dma_sg = 1;
 
-	dev->net->hw_features |= AQ_SUPPORT_HW_FEATURE;
-	dev->net->features |= AQ_SUPPORT_FEATURE;
-	dev->net->vlan_features |= AQ_SUPPORT_VLAN_FEATURE;
+	netdev_hw_features_set_array(dev->net, &aq_support_hw_feature_set);
+	netdev_active_features_set_array(dev->net, &aq_support_feature_set);
+	netdev_vlan_features_set_array(dev->net, &aq_support_vlan_feature_set);
 
 	/* Power up ethernet PHY */
 	aqc111_data->phy_cfg = AQ_PHY_POWER_EN;
diff --git a/drivers/net/usb/aqc111.h b/drivers/net/usb/aqc111.h
index b562db4da337..ebc23df8295f 100644
--- a/drivers/net/usb/aqc111.h
+++ b/drivers/net/usb/aqc111.h
@@ -24,20 +24,6 @@
 #define AQ_USB_PHY_SET_TIMEOUT		10000
 #define AQ_USB_SET_TIMEOUT		4000
 
-/* Feature. ********************************************/
-#define AQ_SUPPORT_FEATURE	(NETIF_F_SG | NETIF_F_IP_CSUM |\
-				 NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |\
-				 NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_TX |\
-				 NETIF_F_HW_VLAN_CTAG_RX)
-
-#define AQ_SUPPORT_HW_FEATURE	(NETIF_F_SG | NETIF_F_IP_CSUM |\
-				 NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |\
-				 NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_FILTER)
-
-#define AQ_SUPPORT_VLAN_FEATURE (NETIF_F_SG | NETIF_F_IP_CSUM |\
-				 NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |\
-				 NETIF_F_TSO)
-
 /* SFR Reg. ********************************************/
 
 #define SFR_GENERAL_STATUS		0x03
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 0ad468a00064..67c4bce50df2 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -13,6 +13,7 @@
 #include <linux/usb/usbnet.h>
 #include <uapi/linux/mdio.h>
 #include <linux/mdio.h>
+#include <linux/netdev_features_helper.h>
 
 #define AX88179_PHY_ID				0x03
 #define AX_EEPROM_LEN				0x100
@@ -1265,6 +1266,13 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 			  dev->net->dev_addr);
 }
 
+DECLARE_NETDEV_FEATURE_SET(ax88179_feature_set,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_TSO_BIT);
+
 static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct ax88179_data *ax179_data;
@@ -1291,8 +1299,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id = 0x03;
 	dev->mii.supports_gmii = 1;
 
-	dev->net->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | NETIF_F_TSO;
+	netdev_active_features_set_array(dev->net, &ax88179_feature_set);
 
 	dev->net->hw_features |= dev->net->features;
 
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3226ab33afae..b3c01bee9504 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -25,6 +25,7 @@
 #include <linux/irq.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/microchipphy.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy_fixed.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
@@ -3430,6 +3431,11 @@ lan78xx_start_xmit(struct sk_buff *skb, struct net_device *net)
 	return NETDEV_TX_OK;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(lan78xx_tso_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_SG_BIT);
+
 static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 {
 	struct lan78xx_priv *pdata = NULL;
@@ -3465,7 +3471,7 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 		dev->net->features |= NETIF_F_RXCSUM;
 
 	if (DEFAULT_TSO_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_SG;
+		netdev_active_features_set_array(dev->net, &lan78xx_tso_feature_set);
 
 	if (DEFAULT_VLAN_RX_OFFLOAD)
 		dev->net->features |= NETIF_F_HW_VLAN_CTAG_RX;
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0f6efaabaa32..5e11eaab71f5 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
@@ -2095,6 +2096,11 @@ static struct tx_agg *r8152_get_tx_agg(struct r8152 *tp)
 	return agg;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(r8152_csum_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO6_BIT);
+
 /* r8152_csum_workaround()
  * The hw limits the value of the transport offset. When the offset is out of
  * range, calculate the checksum by sw.
@@ -2107,7 +2113,7 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
 
-		features &= ~(NETIF_F_SG | NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
+		netdev_features_clear_array(&r8152_csum_feature_set, &features);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR(segs) || !segs)
 			goto drop;
@@ -9576,6 +9582,35 @@ u8 rtl8152_get_version(struct usb_interface *intf)
 }
 EXPORT_SYMBOL_GPL(rtl8152_get_version);
 
+static DECLARE_NETDEV_FEATURE_SET(r8152_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(r8152_hw_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+static DECLARE_NETDEV_FEATURE_SET(r8152_vlan_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static bool rtl8152_supports_lenovo_macpassthru(struct usb_device *udev)
 {
 	int parent_vendor_id = le16_to_cpu(udev->parent->descriptor.idVendor);
@@ -9662,17 +9697,11 @@ static int rtl8152_probe(struct usb_interface *intf,
 	netdev->netdev_ops = &rtl8152_netdev_ops;
 	netdev->watchdog_timeo = RTL8152_TX_TIMEOUT;
 
-	netdev->features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
-			    NETIF_F_TSO | NETIF_F_FRAGLIST | NETIF_F_IPV6_CSUM |
-			    NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_FRAGLIST |
-			      NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
-			      NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-				NETIF_F_HIGHDMA | NETIF_F_FRAGLIST |
-				NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+	netdev_active_features_set_array(netdev, &r8152_feature_set);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &r8152_hw_feature_set);
+	netdev_vlan_features_zero(netdev);
+	netdev_vlan_features_set_array(netdev, &r8152_vlan_feature_set);
 
 	if (tp->version == RTL_VER_01) {
 		netdev->features &= ~NETIF_F_RXCSUM;
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 95de452ff4da..34b79291e159 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -1445,6 +1446,11 @@ static const struct net_device_ops smsc75xx_netdev_ops = {
 	.ndo_set_features	= smsc75xx_set_features,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(smsc75xx_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc75xx_priv *pdata = NULL;
@@ -1478,8 +1484,8 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
 
-	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev->net);
+	netdev_hw_features_set_array(dev->net, &smsc75xx_hw_feature_set);
 
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2cb833b3006a..6de15832dafe 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/slab.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
@@ -1620,14 +1621,22 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_get_peer_dev	= veth_peer_dev,
 };
 
-#define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
-		       NETIF_F_RXCSUM | NETIF_F_SCTP_CRC | NETIF_F_HIGHDMA | \
-		       NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL | \
-		       NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX | \
-		       NETIF_F_HW_VLAN_STAG_TX | NETIF_F_HW_VLAN_STAG_RX )
+static DECLARE_NETDEV_FEATURE_SET(veth_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_STAG_TX_BIT,
+				  NETIF_F_HW_VLAN_STAG_RX_BIT);
 
 static void veth_setup(struct net_device *dev)
 {
+	netdev_features_t veth_features;
+
 	ether_setup(dev);
 
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
@@ -1637,8 +1646,10 @@ static void veth_setup(struct net_device *dev)
 
 	dev->netdev_ops = &veth_netdev_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
+	veth_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_array(&veth_feature_set, &veth_features);
 	dev->features |= NETIF_F_LLTX;
-	dev->features |= VETH_FEATURES;
+	dev->features |= veth_features;
 	dev->vlan_features = dev->features &
 			     ~(NETIF_F_HW_VLAN_CTAG_TX |
 			       NETIF_F_HW_VLAN_STAG_TX |
@@ -1648,8 +1659,8 @@ static void veth_setup(struct net_device *dev)
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	dev->hw_features = VETH_FEATURES;
-	dev->hw_enc_features = VETH_FEATURES;
+	dev->hw_features = veth_features;
+	dev->hw_enc_features = veth_features;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 53b3b241e027..b2f3fb5a29d5 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3301,26 +3301,42 @@ vmxnet3_change_mtu(struct net_device *netdev, int new_mtu)
 	return err;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(vmxnet3_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(vmxnet3_hw_enc_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 static void
 vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-		NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_LRO | NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &vmxnet3_hw_feature_set);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
 		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
 				NETIF_F_GSO_UDP_TUNNEL_CSUM;
-
-		netdev->hw_enc_features = NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_enc_features_zero(netdev);
+		netdev_hw_enc_features_set_array(netdev,
+						 &vmxnet3_hw_enc_feature_set);
 	}
 
 	if (VMXNET3_VERSION_GE_7(adapter)) {
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index e2034adc3a1a..25b3243a9630 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -298,15 +298,35 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 	return features;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(vmxnet3_hw_enc_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_LRO_BIT);
+
+static DECLARE_NETDEV_FEATURE_SET(vmxnet3_hw_enc_feature_set2,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_BIT,
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
 static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_enc_features |= NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO;
+		netdev_hw_enc_features_set_array(netdev,
+						 &vmxnet3_hw_enc_feature_set);
 		if (features & NETIF_F_GSO_UDP_TUNNEL)
 			netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
 		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
@@ -364,11 +384,8 @@ static void vmxnet3_disable_encap_offloads(struct net_device *netdev)
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_enc_features &= ~(NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM);
+		netdev_hw_enc_features_clear_array(netdev,
+						   &vmxnet3_hw_enc_feature_set2);
 	}
 	if (VMXNET3_VERSION_GE_7(adapter)) {
 		unsigned long flags;
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 3367db23aa13..d42f997efa4a 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -31,6 +31,7 @@
 #include <linux/ethtool.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/compiler.h>
 #include <linux/slab.h>
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 5df7a0abc39d..7ad145f832cc 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/init.h>
@@ -1664,6 +1665,14 @@ static int vrf_add_fib_rules(const struct net_device *dev)
 	return err;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(vrf_offload_feature_set,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SCTP_CRC_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static void vrf_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -1688,8 +1697,7 @@ static void vrf_setup(struct net_device *dev)
 
 	/* enable offload features */
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
-	dev->features   |= NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CRC;
-	dev->features   |= NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
+	netdev_active_features_set_array(dev, &vrf_offload_feature_set);
 
 	dev->hw_features = dev->features;
 	dev->hw_enc_features = dev->features;
diff --git a/drivers/net/vsockmon.c b/drivers/net/vsockmon.c
index b1bb1b04b664..a5cee59ea872 100644
--- a/drivers/net/vsockmon.c
+++ b/drivers/net/vsockmon.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
+#include <linux/netdev_features_helper.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
@@ -97,6 +98,12 @@ static const struct ethtool_ops vsockmon_ethtool_ops = {
 	.get_link = always_on,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(vsockmon_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_LLTX_BIT);
+
 static void vsockmon_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_VSOCKMON;
@@ -106,8 +113,8 @@ static void vsockmon_setup(struct net_device *dev)
 	dev->ethtool_ops = &vsockmon_ethtool_ops;
 	dev->needs_free_netdev = true;
 
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			NETIF_F_HIGHDMA | NETIF_F_LLTX;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_array(dev, &vsockmon_feature_set);
 
 	dev->flags = IFF_NOARP;
 
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 90811ab851fd..0076b12b6bae 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -15,6 +15,7 @@
 #include <linux/igmp.h>
 #include <linux/if_ether.h>
 #include <linux/ethtool.h>
+#include <linux/netdev_features_helper.h>
 #include <net/arp.h>
 #include <net/ndisc.h>
 #include <net/gro.h>
@@ -3153,6 +3154,18 @@ static void vxlan_offload_rx_ports(struct net_device *dev, bool push)
 	spin_unlock(&vn->sock_lock);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(vxlan_feature_set,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(vxlan_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 /* Initialize the device structure. */
 static void vxlan_setup(struct net_device *dev)
 {
@@ -3165,14 +3178,11 @@ static void vxlan_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &vxlan_type);
 
-	dev->features	|= NETIF_F_LLTX;
-	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features   |= NETIF_F_RXCSUM;
+	netdev_active_features_set_array(dev, &vxlan_feature_set);
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
 
 	dev->vlan_features = dev->features;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_features_set_array(dev, &vxlan_hw_feature_set);
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	netif_keep_dst(dev);
 	dev->priv_flags |= IFF_NO_QUEUE | IFF_CHANGE_PROTO_DOWN;
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index aa9a7a5970fd..aeed694110d4 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -15,6 +15,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/inetdevice.h>
 #include <linux/if_arp.h>
 #include <linux/icmp.h>
@@ -271,14 +272,19 @@ static void wg_destruct(struct net_device *dev)
 
 static const struct device_type device_type = { .name = KBUILD_MODNAME };
 
+static DECLARE_NETDEV_FEATURE_SET(wg_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+
 static void wg_setup(struct net_device *dev)
 {
 	struct wg_device *wg = netdev_priv(dev);
-	enum { WG_NETDEV_FEATURES = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-				    NETIF_F_SG | NETIF_F_GSO |
-				    NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA };
 	const int overhead = MESSAGE_MINIMUM_LENGTH + sizeof(struct udphdr) +
 			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
+	netdev_features_t wg_netdev_features;
 
 	dev->netdev_ops = &netdev_ops;
 	dev->header_ops = &ip_tunnel_header_ops;
@@ -290,9 +296,11 @@ static void wg_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->features |= NETIF_F_LLTX;
-	dev->features |= WG_NETDEV_FEATURES;
-	dev->hw_features |= WG_NETDEV_FEATURES;
-	dev->hw_enc_features |= WG_NETDEV_FEATURES;
+	wg_netdev_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&wg_feature_set, &wg_netdev_features);
+	dev->features |= wg_netdev_features;
+	dev->hw_features |= wg_netdev_features;
+	dev->hw_enc_features |= wg_netdev_features;
 	dev->mtu = ETH_DATA_LEN - overhead;
 	dev->max_mtu = round_down(INT_MAX, MESSAGE_PADDING_MULTIPLE) - overhead;
 
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 87a88f26233e..c2012c4e0084 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/rtnetlink.h>
 #include "wil6210.h"
 #include "txrx.h"
@@ -294,6 +295,14 @@ static u8 wil_vif_find_free_mid(struct wil6210_priv *wil)
 	return U8_MAX;
 }
 
+static DECLARE_NETDEV_FEATURE_SET(wil_hw_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 struct wil6210_vif *
 wil_vif_alloc(struct wil6210_priv *wil, const char *name,
 	      unsigned char name_assign_type, enum nl80211_iftype iftype)
@@ -335,9 +344,8 @@ wil_vif_alloc(struct wil6210_priv *wil, const char *name,
 	ndev->netdev_ops = &wil_netdev_ops;
 	wil_set_ethtoolops(ndev);
 	ndev->ieee80211_ptr = wdev;
-	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_SG | NETIF_F_GRO |
-			    NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &wil_hw_feature_set);
 
 	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index fb32ae82d9b0..989328168e1c 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -33,6 +33,7 @@
 #include <linux/kthread.h>
 #include <linux/sched/task.h>
 #include <linux/ethtool.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
@@ -476,6 +477,14 @@ static const struct net_device_ops xenvif_netdev_ops = {
 	.ndo_validate_addr   = eth_validate_addr,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(xenvif_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_FRAGLIST_BIT);
+
 struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 			    unsigned int handle)
 {
@@ -522,9 +531,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	INIT_LIST_HEAD(&vif->fe_mcast_addr);
 
 	dev->netdev_ops	= &xenvif_netdev_ops;
-	dev->hw_features = NETIF_F_SG |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_FRAGLIST;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_array(dev, &xenvif_hw_feature_set);
 	dev->features = dev->hw_features | NETIF_F_RXCSUM;
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 27a11cc08c61..d4833794cec0 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -1703,6 +1704,16 @@ static void xennet_free_netdev(struct net_device *netdev)
 	free_netdev(netdev);
 }
 
+static DECLARE_NETDEV_FEATURE_SET(xennet_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_GSO_ROBUST_BIT);
+static DECLARE_NETDEV_FEATURE_SET(xennet_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT);
+
 static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 {
 	int err;
@@ -1728,11 +1739,10 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	netdev->netdev_ops	= &xennet_netdev_ops;
 
-	netdev->features        = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-				  NETIF_F_GSO_ROBUST;
-	netdev->hw_features	= NETIF_F_SG |
-				  NETIF_F_IPV6_CSUM |
-				  NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_array(netdev, &xennet_feature_set);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_array(netdev, &xennet_hw_feature_set);
 
 	/*
          * Assume that all hw features are available for now. This set
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 8d44bce0477a..8628599ed692 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1854,6 +1854,11 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_neigh_setup	= qeth_l3_neigh_setup,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(qeth_l3_feature_set,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_IP_CSUM_BIT);
+
 static int qeth_l3_setup_netdev(struct qeth_card *card)
 {
 	struct net_device *dev = card->dev;
@@ -1868,10 +1873,10 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 
 		if (!IS_VM_NIC(card)) {
 			card->dev->features |= NETIF_F_SG;
-			card->dev->hw_features |= NETIF_F_TSO |
-				NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
-			card->dev->vlan_features |= NETIF_F_TSO |
-				NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+			netdev_hw_features_set_array(card->dev,
+						     &qeth_l3_feature_set);
+			netdev_vlan_features_set_array(card->dev,
+						       &qeth_l3_feature_set);
 		}
 
 		if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 6cd7fc9589c3..a3576a11443d 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -31,6 +31,7 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
@@ -4533,6 +4534,16 @@ static void qlge_timer(struct timer_list *t)
 
 static const struct devlink_ops qlge_devlink_ops;
 
+static DECLARE_NETDEV_FEATURE_SET(qlge_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO_ECN_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_RXCSUM_BIT);
+
 static int qlge_probe(struct pci_dev *pdev,
 		      const struct pci_device_id *pci_entry)
 {
@@ -4567,14 +4578,8 @@ static int qlge_probe(struct pci_dev *pdev,
 		goto netdev_free;
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-	ndev->hw_features = NETIF_F_SG |
-		NETIF_F_IP_CSUM |
-		NETIF_F_TSO |
-		NETIF_F_TSO_ECN |
-		NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_RXCSUM;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_array(ndev, &qlge_hw_feature_set);
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = ndev->hw_features;
 	/* vlan gets same features (except vlan filter) */
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 6e78d657aa05..cfad04d40bf2 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -89,10 +89,9 @@
 #define bond_for_each_slave_rcu(bond, pos, iter) \
 	netdev_for_each_lower_private_rcu((bond)->dev, pos, iter)
 
-#define BOND_XFRM_FEATURES (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
-			    NETIF_F_GSO_ESP)
+#define BOND_XFRM_FEATURES netdev_xfrm_features
 
-#define BOND_TLS_FEATURES (NETIF_F_HW_TLS_TX | NETIF_F_HW_TLS_RX)
+#define BOND_TLS_FEATURES netdev_tls_features
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern atomic_t netpoll_block_tx;
diff --git a/include/net/net_failover.h b/include/net/net_failover.h
index b12a1c469d1c..781d1de8a190 100644
--- a/include/net/net_failover.h
+++ b/include/net/net_failover.h
@@ -30,11 +30,7 @@ struct net_failover_info {
 struct failover *net_failover_create(struct net_device *standby_dev);
 void net_failover_destroy(struct failover *failover);
 
-#define FAILOVER_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_FRAGLIST | NETIF_F_ALL_TSO | \
-				 NETIF_F_HIGHDMA | NETIF_F_LRO)
-
-#define FAILOVER_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
+#define FAILOVER_VLAN_FEATURES	failover_vlan_features
+#define FAILOVER_ENC_FEATURES	failover_enc_features
 
 #endif /* _NET_FAILOVER_H */
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 64ca07daf4ee..75d12ff0d146 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -550,6 +550,13 @@ static struct device_type vlan_type = {
 
 static const struct net_device_ops vlan_netdev_ops;
 
+static DECLARE_NETDEV_FEATURE_SET(vlan_hw_feature_set,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_SCTP_CRC_BIT);
+
 static int vlan_dev_init(struct net_device *dev)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
@@ -567,11 +574,9 @@ static int vlan_dev_init(struct net_device *dev)
 	if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 		dev->state |= (1 << __LINK_STATE_NOCARRIER);
 
-	dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG |
-			   NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
-			   NETIF_F_GSO_ENCAP_ALL |
-			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
-			   NETIF_F_ALL_FCOE;
+	dev->hw_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	dev->hw_features |= NETIF_F_ALL_FCOE;
+	netdev_hw_features_set_array(dev, &vlan_hw_feature_set);
 
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 0f5c0679b55a..1a958b279489 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/netlink.h>
 #include <linux/percpu.h>
 #include <linux/random.h>
@@ -992,6 +993,11 @@ static void batadv_softif_free(struct net_device *dev)
 	rcu_barrier();
 }
 
+static DECLARE_NETDEV_FEATURE_SET(batadv_feature_set,
+				  NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				  NETIF_F_NETNS_LOCAL_BIT,
+				  NETIF_F_LLTX_BIT);
+
 /**
  * batadv_softif_init_early() - early stage initialization of soft interface
  * @dev: registered network device to modify
@@ -1003,8 +1009,7 @@ static void batadv_softif_init_early(struct net_device *dev)
 	dev->netdev_ops = &batadv_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = batadv_softif_free;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_NETNS_LOCAL;
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_features_set_array(dev, &batadv_feature_set);
 	dev->priv_flags |= IFF_NO_QUEUE;
 
 	/* can't call min_mtu, because the needed variables
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 58a4f70e01e3..8f78e6d297b8 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/netpoll.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -18,8 +19,11 @@
 #include <linux/uaccess.h>
 #include "br_private.h"
 
-#define COMMON_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA | \
-			 NETIF_F_GSO_MASK | NETIF_F_HW_CSUM)
+static DECLARE_NETDEV_FEATURE_SET(br_common_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT);
 
 const struct nf_br_ops __rcu *nf_br_ops __read_mostly;
 EXPORT_SYMBOL_GPL(nf_br_ops);
@@ -479,9 +483,16 @@ static struct device_type br_type = {
 	.name	= "bridge",
 };
 
+static DECLARE_NETDEV_FEATURE_SET(br_feature_set,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_NETNS_LOCAL_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_STAG_TX_BIT);
+
 void br_dev_setup(struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
+	netdev_features_t common_features;
 
 	eth_hw_addr_random(dev);
 	ether_setup(dev);
@@ -492,11 +503,13 @@ void br_dev_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &br_type);
 	dev->priv_flags = IFF_EBRIDGE | IFF_NO_QUEUE;
 
-	dev->features = COMMON_FEATURES | NETIF_F_LLTX | NETIF_F_NETNS_LOCAL |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
-	dev->hw_features = COMMON_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
+	common_features = NETIF_F_GSO_MASK;
+	netdev_features_set_array(&br_common_feature_set, &common_features);
+	dev->features = common_features;
+	netdev_active_features_set_array(dev, &br_feature_set);
+	dev->hw_features = common_features | NETIF_F_HW_VLAN_CTAG_TX |
 			   NETIF_F_HW_VLAN_STAG_TX;
-	dev->vlan_features = COMMON_FEATURES;
+	dev->vlan_features = common_features;
 
 	br->dev = dev;
 	spin_lock_init(&br->lock);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6a7308de192d..2ed9277a873e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/bitops.h>
@@ -288,9 +289,13 @@ static int ethtool_set_one_feature(struct net_device *dev,
 
 #define ETH_ALL_FLAGS    (ETH_FLAG_LRO | ETH_FLAG_RXVLAN | ETH_FLAG_TXVLAN | \
 			  ETH_FLAG_NTUPLE | ETH_FLAG_RXHASH)
-#define ETH_ALL_FEATURES (NETIF_F_LRO | NETIF_F_HW_VLAN_CTAG_RX | \
-			  NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_NTUPLE | \
-			  NETIF_F_RXHASH)
+
+static DECLARE_NETDEV_FEATURE_SET(ethtool_all_feature_set,
+				  NETIF_F_LRO_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_NTUPLE_BIT,
+				  NETIF_F_RXHASH_BIT);
 
 static u32 __ethtool_get_flags(struct net_device *dev)
 {
@@ -313,6 +318,7 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
 	netdev_features_t features = 0, changed;
+	netdev_features_t eth_all_features;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
@@ -328,8 +334,11 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	if (data & ETH_FLAG_RXHASH)
 		features |= NETIF_F_RXHASH;
 
+	netdev_features_zero(&eth_all_features);
+	netdev_features_set_array(&ethtool_all_feature_set, &eth_all_features);
+
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->features) & ETH_ALL_FEATURES;
+	changed = (features ^ dev->features) & eth_all_features;
 	if (changed & ~dev->hw_features)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 6ffef47e9be5..ab1c4dfa25b7 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
@@ -435,6 +436,13 @@ static struct hsr_proto_ops prp_ops = {
 	.update_san_info = prp_update_san_info,
 };
 
+static DECLARE_NETDEV_FEATURE_SET(hsr_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT);
+
 void hsr_dev_setup(struct net_device *dev)
 {
 	eth_hw_addr_random(dev);
@@ -448,9 +456,8 @@ void hsr_dev_setup(struct net_device *dev)
 
 	dev->needs_free_netdev = true;
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA |
-			   NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX;
+	dev->hw_features = NETIF_F_GSO_MASK;
+	netdev_hw_features_set_array(dev, &hsr_hw_feature_set);
 
 	dev->features = dev->hw_features;
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 5c58e21f724e..fbdf3713245f 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -935,10 +936,11 @@ static const struct net_device_ops ipgre_netdev_ops = {
 	.ndo_tunnel_ctl		= ipgre_tunnel_ctl,
 };
 
-#define GRE_FEATURES (NETIF_F_SG |		\
-		      NETIF_F_FRAGLIST |	\
-		      NETIF_F_HIGHDMA |		\
-		      NETIF_F_HW_CSUM)
+static DECLARE_NETDEV_FEATURE_SET(gre_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT);
 
 static void ipgre_tunnel_setup(struct net_device *dev)
 {
@@ -959,8 +961,9 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
 	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
-	dev->features		|= GRE_FEATURES | NETIF_F_LLTX;
-	dev->hw_features	|= GRE_FEATURES;
+	netdev_active_features_set_array(dev, &gre_feature_set);
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
+	netdev_hw_features_set_array(dev, &gre_feature_set);
 
 	flags = tunnel->parms.o_flags;
 
@@ -1300,8 +1303,8 @@ static int erspan_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen +
 		       erspan_hdr_len(tunnel->erspan_ver);
 
-	dev->features		|= GRE_FEATURES;
-	dev->hw_features	|= GRE_FEATURES;
+	netdev_active_features_set_array(dev, &gre_feature_set);
+	netdev_hw_features_set_array(dev, &gre_feature_set);
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
 
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 123ea63a04cb..66b2deb4ddff 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -94,6 +94,7 @@
 #include <linux/uaccess.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -354,14 +355,16 @@ static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_tunnel_ctl	= ipip_tunnel_ctl,
 };
 
-#define IPIP_FEATURES (NETIF_F_SG |		\
-		       NETIF_F_FRAGLIST |	\
-		       NETIF_F_HIGHDMA |	\
-		       NETIF_F_GSO_SOFTWARE |	\
-		       NETIF_F_HW_CSUM)
+static DECLARE_NETDEV_FEATURE_SET(ipip_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT);
 
 static void ipip_tunnel_setup(struct net_device *dev)
 {
+	netdev_features_t ipip_features;
+
 	dev->netdev_ops		= &ipip_netdev_ops;
 	dev->header_ops		= &ip_tunnel_header_ops;
 
@@ -371,8 +374,10 @@ static void ipip_tunnel_setup(struct net_device *dev)
 	dev->features		|= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	dev->features		|= IPIP_FEATURES;
-	dev->hw_features	|= IPIP_FEATURES;
+	ipip_features		= NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&ipip_feature_set, &ipip_features);
+	dev->features		|= ipip_features;
+	dev->hw_features	|= ipip_features;
 	ip_tunnel_setup(dev, ipip_net_id);
 }
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 80cb50d459e4..b91a001077af 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -1464,18 +1465,20 @@ static void ip6gre_tunnel_setup(struct net_device *dev)
 	eth_random_addr(dev->perm_addr);
 }
 
-#define GRE6_FEATURES (NETIF_F_SG |		\
-		       NETIF_F_FRAGLIST |	\
-		       NETIF_F_HIGHDMA |	\
-		       NETIF_F_HW_CSUM)
+static DECLARE_NETDEV_FEATURE_SET(gre_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT);
 
 static void ip6gre_tnl_init_features(struct net_device *dev)
 {
 	struct ip6_tnl *nt = netdev_priv(dev);
 	__be16 flags;
 
-	dev->features		|= GRE6_FEATURES | NETIF_F_LLTX;
-	dev->hw_features	|= GRE6_FEATURES;
+	netdev_active_features_set_array(dev, &gre_feature_set);
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
+	netdev_hw_features_set_array(dev, &gre_feature_set);
 
 	flags = nt->parms.o_flags;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 3fda5634578c..da8eccfd1849 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -27,6 +27,7 @@
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_arp.h>
 #include <linux/icmpv6.h>
 #include <linux/init.h>
@@ -1813,11 +1814,11 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
 
-#define IPXIPX_FEATURES (NETIF_F_SG |		\
-			 NETIF_F_FRAGLIST |	\
-			 NETIF_F_HIGHDMA |	\
-			 NETIF_F_GSO_SOFTWARE |	\
-			 NETIF_F_HW_CSUM)
+static DECLARE_NETDEV_FEATURE_SET(ipxipx_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT);
 
 /**
  * ip6_tnl_dev_setup - setup virtual tunnel device
@@ -1829,6 +1830,8 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 
 static void ip6_tnl_dev_setup(struct net_device *dev)
 {
+	netdev_features_t ipxipx_features;
+
 	dev->netdev_ops = &ip6_tnl_netdev_ops;
 	dev->header_ops = &ip_tunnel_header_ops;
 	dev->needs_free_netdev = true;
@@ -1840,8 +1843,10 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 	dev->features |= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	dev->features		|= IPXIPX_FEATURES;
-	dev->hw_features	|= IPXIPX_FEATURES;
+	ipxipx_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&ipxipx_feature_set, &ipxipx_features);
+	dev->features		|= ipxipx_features;
+	dev->hw_features	|= ipxipx_features;
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 6b73b7a5f175..9e4c02fd379c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -24,6 +24,7 @@
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_arp.h>
 #include <linux/icmp.h>
 #include <linux/slab.h>
@@ -1407,16 +1408,17 @@ static void ipip6_dev_free(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-#define SIT_FEATURES (NETIF_F_SG	   | \
-		      NETIF_F_FRAGLIST	   | \
-		      NETIF_F_HIGHDMA	   | \
-		      NETIF_F_GSO_SOFTWARE | \
-		      NETIF_F_HW_CSUM)
+static DECLARE_NETDEV_FEATURE_SET(sit_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT);
 
 static void ipip6_tunnel_setup(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+	netdev_features_t sit_features;
 
 	dev->netdev_ops		= &ipip6_netdev_ops;
 	dev->header_ops		= &ip_tunnel_header_ops;
@@ -1430,9 +1432,11 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	netif_keep_dst(dev);
 	dev->addr_len		= 4;
+	sit_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&sit_feature_set, &sit_features);
 	dev->features		|= NETIF_F_LLTX;
-	dev->features		|= SIT_FEATURES;
-	dev->hw_features	|= SIT_FEATURES;
+	dev->features		|= sit_features;
+	dev->hw_features	|= sit_features;
 }
 
 static int ipip6_tunnel_init(struct net_device *dev)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e192e1ec0261..c40217911ff4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/types.h>
@@ -1902,13 +1903,13 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 /* color change handling */
 void ieee80211_color_change_finalize_work(struct work_struct *work);
 
+extern netdev_features_t mac80211_tx_features __ro_after_init;
+extern netdev_features_t mac80211_rx_features __ro_after_init;
+extern netdev_features_t mac80211_supported_features __ro_after_init;
 /* interface handling */
-#define MAC80211_SUPPORTED_FEATURES_TX	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | \
-					 NETIF_F_HW_CSUM | NETIF_F_SG | \
-					 NETIF_F_HIGHDMA | NETIF_F_GSO_SOFTWARE)
-#define MAC80211_SUPPORTED_FEATURES_RX	(NETIF_F_RXCSUM)
-#define MAC80211_SUPPORTED_FEATURES	(MAC80211_SUPPORTED_FEATURES_TX | \
-					 MAC80211_SUPPORTED_FEATURES_RX)
+#define MAC80211_SUPPORTED_FEATURES_TX	mac80211_rx_features
+#define MAC80211_SUPPORTED_FEATURES_RX	mac80211_rx_features
+#define MAC80211_SUPPORTED_FEATURES	mac80211_supported_features
 
 int ieee80211_iface_init(void);
 void ieee80211_iface_exit(void);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5b1c47ed0cc0..00d8f3bce563 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -33,6 +33,18 @@
 #include "led.h"
 #include "debugfs.h"
 
+static DECLARE_NETDEV_FEATURE_SET(mac80211_tx_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HW_CSUM_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_HIGHDMA_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mac80211_rx_feature_set,
+				  NETIF_F_RXCSUM_BIT);
+netdev_features_t mac80211_tx_features __ro_after_init;
+netdev_features_t mac80211_rx_features __ro_after_init;
+netdev_features_t mac80211_supported_features __ro_after_init;
+
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	u64 mc;
@@ -1527,6 +1539,16 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
 
+static void __init ieee80211_features_init(void)
+{
+	mac80211_tx_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&mac80211_tx_feature_set,
+				  &mac80211_tx_features);
+	netdev_features_set_array(&mac80211_rx_feature_set,
+				  &mac80211_rx_features);
+	mac80211_supported_features = mac80211_tx_features | mac80211_rx_features;
+}
+
 static int __init ieee80211_init(void)
 {
 	struct sk_buff *skb;
@@ -1544,6 +1566,8 @@ static int __init ieee80211_init(void)
 	if (ret)
 		goto err_netdev;
 
+	ieee80211_features_init();
+
 	return 0;
  err_netdev:
 	rc80211_minstrel_exit();
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 5b2ee9c1c00b..1e401624908b 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -6,6 +6,7 @@
 #include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
@@ -92,6 +93,13 @@ static struct rtnl_link_ops internal_dev_link_ops __read_mostly = {
 	.kind = "openvswitch",
 };
 
+static DECLARE_NETDEV_FEATURE_SET(ovs_feature_set,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HIGHDMA_BIT,
+				  NETIF_F_HW_CSUM_BIT);
+
 static void do_setup(struct net_device *netdev)
 {
 	ether_setup(netdev);
@@ -108,9 +116,8 @@ static void do_setup(struct net_device *netdev)
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
 	netdev->rtnl_link_ops = &internal_dev_link_ops;
 
-	netdev->features = NETIF_F_LLTX | NETIF_F_SG | NETIF_F_FRAGLIST |
-			   NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			   NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev->features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_active_features_set_array(netdev, &ovs_feature_set);
 
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5113fa0fbcee..d80bff81b346 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -20,6 +20,7 @@
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_link.h>
 #include <linux/if_arp.h>
 #include <linux/icmpv6.h>
@@ -572,15 +573,16 @@ static void xfrmi_dev_setup(struct net_device *dev)
 	eth_broadcast_addr(dev->broadcast);
 }
 
-#define XFRMI_FEATURES (NETIF_F_SG |		\
-			NETIF_F_FRAGLIST |	\
-			NETIF_F_GSO_SOFTWARE |	\
-			NETIF_F_HW_CSUM)
+static DECLARE_NETDEV_FEATURE_SET(xfrmi_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HW_CSUM_BIT);
 
 static int xfrmi_dev_init(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct net_device *phydev = __dev_get_by_index(xi->net, xi->p.link);
+	netdev_features_t xfrmi_features;
 	int err;
 
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
@@ -593,9 +595,11 @@ static int xfrmi_dev_init(struct net_device *dev)
 		return err;
 	}
 
+	xfrmi_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_array(&xfrmi_feature_set, &xfrmi_features);
 	dev->features |= NETIF_F_LLTX;
-	dev->features |= XFRMI_FEATURES;
-	dev->hw_features |= XFRMI_FEATURES;
+	dev->features |= xfrmi_features;
+	dev->hw_features |= xfrmi_features;
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.33.0

