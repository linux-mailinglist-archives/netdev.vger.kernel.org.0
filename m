Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A922B5BBD00
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiIRJvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4655B12092
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbr2BXWzlVlx;
        Sun, 18 Sep 2022 17:45:44 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:46 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 03/55] treewide: replace multiple feature bits with DECLARE_NETDEV_FEATURE_SET
Date:   Sun, 18 Sep 2022 09:42:44 +0000
Message-ID: <20220918094336.28958-4-shenjian15@huawei.com>
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

There are many netdev_features bits group used in drivers, replace them
with netdev_features_set_set and netdev_features_clear_set, preparing to
remove all the NETIF_F_XXX macroes later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |   5 +-
 arch/um/drivers/vector_transports.c           |  32 +++--
 drivers/infiniband/hw/hfi1/netdev.h           |   1 +
 drivers/infiniband/hw/hfi1/vnic_main.c        |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h          |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  11 +-
 drivers/net/amt.c                             |   9 +-
 drivers/net/bareudp.c                         |  11 +-
 drivers/net/bonding/bond_main.c               |  34 +++--
 drivers/net/dsa/xrs700x/xrs700x.c             |  17 ++-
 drivers/net/dummy.c                           |   6 +-
 drivers/net/ethernet/3com/3c59x.c             |   4 +-
 drivers/net/ethernet/3com/typhoon.c           |  12 +-
 drivers/net/ethernet/adaptec/starfire.c       |   7 +-
 drivers/net/ethernet/aeroflex/greth.c         |   6 +-
 drivers/net/ethernet/alteon/acenic.c          |   7 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  51 ++++---
 drivers/net/ethernet/amd/xgbe/xgbe.h          |   1 +
 drivers/net/ethernet/apm/xgene-v2/main.c      |   3 +-
 drivers/net/ethernet/apm/xgene-v2/main.h      |   1 +
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  11 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   8 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  16 ++-
 drivers/net/ethernet/atheros/alx/main.c       |  10 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h    |   1 +
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |   9 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h    |   1 +
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |   9 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  15 ++-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  16 ++-
 drivers/net/ethernet/broadcom/bgmac.c         |   6 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  11 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  66 +++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  49 ++++---
 .../net/ethernet/broadcom/genet/bcmgenet.c    |   5 +-
 drivers/net/ethernet/broadcom/tg3.c           |   5 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  27 ++--
 drivers/net/ethernet/cadence/macb_main.c      |   4 +-
 drivers/net/ethernet/calxeda/xgmac.c          |   9 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  34 +++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  30 +++--
 .../ethernet/cavium/liquidio/octeon_network.h |   4 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  17 ++-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  13 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  21 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  57 +++++---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  30 +++--
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   3 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  23 ++--
 drivers/net/ethernet/cortina/gemini.c         |  11 +-
 drivers/net/ethernet/davicom/dm9000.c         |   5 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  29 ++--
 drivers/net/ethernet/faraday/ftgmac100.c      |  11 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   9 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  11 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   8 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  28 ++--
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  27 ++--
 drivers/net/ethernet/freescale/fec_main.c     |   7 +-
 drivers/net/ethernet/freescale/gianfar.c      |  12 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  36 +++--
 drivers/net/ethernet/google/gve/gve_main.c    |  14 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  32 +++--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  32 +++--
 .../net/ethernet/huawei/hinic/hinic_main.c    |  26 ++--
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  22 +--
 drivers/net/ethernet/ibm/emac/core.c          |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c            |   8 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |   4 +-
 drivers/net/ethernet/intel/e1000/e1000.h      |   1 +
 drivers/net/ethernet/intel/e1000/e1000_main.c |  28 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c    |  32 ++---
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  34 ++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  63 ++++-----
 drivers/net/ethernet/intel/iavf/iavf.h        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  40 +++---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  63 +++++----
 drivers/net/ethernet/intel/igb/igb_main.c     |  79 ++++++-----
 drivers/net/ethernet/intel/igbvf/netdev.c     |  67 ++++++----
 drivers/net/ethernet/intel/igc/igc_mac.c      |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c     |  68 ++++++----
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 125 ++++++++++--------
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  14 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |   1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  77 ++++++-----
 drivers/net/ethernet/jme.c                    |  31 +++--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   5 +-
 drivers/net/ethernet/marvell/mvneta.c         |  10 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  14 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  11 +-
 .../ethernet/marvell/prestera/prestera_main.c |   4 +-
 drivers/net/ethernet/marvell/skge.c           |   6 +-
 drivers/net/ethernet/marvell/sky2.c           |  15 ++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c  |   1 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  51 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  38 +++---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  10 +-
 drivers/net/ethernet/micrel/ksz884x.c         |   5 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   7 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |   9 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   8 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |   7 +-
 drivers/net/ethernet/neterion/s2io.c          |  16 ++-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   8 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |   6 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |   6 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |   6 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  21 +--
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |   9 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  55 +++++---
 drivers/net/ethernet/qlogic/qla3xxx.c         |   4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  26 ++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  23 ++--
 drivers/net/ethernet/qualcomm/emac/emac.c     |  15 ++-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   8 +-
 drivers/net/ethernet/realtek/8139cp.c         |  17 ++-
 drivers/net/ethernet/realtek/8139too.c        |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  14 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |   9 +-
 drivers/net/ethernet/sfc/ef10.c               |   8 +-
 drivers/net/ethernet/sfc/ef100_netdev.c       |   5 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  13 +-
 drivers/net/ethernet/sfc/efx.c                |  12 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |   6 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   1 +
 drivers/net/ethernet/sfc/net_driver.h         |   1 +
 drivers/net/ethernet/sfc/siena/efx.c          |  13 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |   8 +-
 drivers/net/ethernet/silan/sc92031.c          |   7 +-
 drivers/net/ethernet/socionext/netsec.c       |   7 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   7 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   6 +-
 drivers/net/ethernet/sun/cassini.c            |   4 +-
 drivers/net/ethernet/sun/ldmvsw.c             |   3 +-
 drivers/net/ethernet/sun/niu.c                |   5 +-
 drivers/net/ethernet/sun/sungem.c             |   5 +-
 drivers/net/ethernet/sun/sunhme.c             |   7 +-
 drivers/net/ethernet/sun/sunvnet.c            |   5 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  20 ++-
 drivers/net/ethernet/tehuti/tehuti.h          |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   9 +-
 drivers/net/ethernet/ti/cpsw.c                |   7 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   9 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |   4 +-
 drivers/net/ethernet/toshiba/spider_net.c     |   7 +-
 drivers/net/ethernet/via/via-rhine.c          |   4 +-
 drivers/net/ethernet/via/via-velocity.c       |  13 +-
 drivers/net/geneve.c                          |  12 +-
 drivers/net/hyperv/hyperv_net.h               |   6 +-
 drivers/net/hyperv/netvsc_drv.c               |  20 ++-
 drivers/net/ifb.c                             |  18 ++-
 drivers/net/ipvlan/ipvlan_main.c              |  49 +++++--
 drivers/net/ipvlan/ipvtap.c                   |   9 +-
 drivers/net/loopback.c                        |  20 +--
 drivers/net/macsec.c                          |  19 ++-
 drivers/net/macvlan.c                         |  48 +++++--
 drivers/net/macvtap.c                         |   9 +-
 drivers/net/net_failover.c                    |  19 +++
 drivers/net/netdevsim/ipsec.c                 |  12 +-
 drivers/net/netdevsim/netdev.c                |   9 +-
 drivers/net/netdevsim/netdevsim.h             |   1 +
 drivers/net/nlmon.c                           |   8 +-
 drivers/net/tap.c                             |  15 ++-
 drivers/net/team/team.c                       |  26 +++-
 drivers/net/thunderbolt.c                     |   8 +-
 drivers/net/tun.c                             |  18 ++-
 drivers/net/usb/aqc111.c                      |  38 +++++-
 drivers/net/usb/aqc111.h                      |  14 --
 drivers/net/usb/ax88179_178a.c                |   8 +-
 drivers/net/usb/cdc_mbim.c                    |   4 +-
 drivers/net/usb/lan78xx.c                     |   5 +-
 drivers/net/usb/r8152.c                       |  34 +++--
 drivers/net/usb/smsc75xx.c                    |   6 +-
 drivers/net/usb/smsc95xx.c                    |   5 +-
 drivers/net/veth.c                            |  24 ++--
 drivers/net/virtio_net.c                      |   8 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  34 +++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  27 ++--
 drivers/net/vmxnet3/vmxnet3_int.h             |   1 +
 drivers/net/vrf.c                             |   8 +-
 drivers/net/vsockmon.c                        |   7 +-
 drivers/net/vxlan/vxlan_core.c                |  12 +-
 drivers/net/wireguard/device.c                |   9 +-
 drivers/net/wireless/ath/ath6kl/core.h        |   1 +
 drivers/net/wireless/ath/ath6kl/main.c        |   3 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |   9 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |   8 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   8 +-
 drivers/net/xen-netback/interface.c           |   8 +-
 drivers/net/xen-netfront.c                    |  14 +-
 drivers/s390/net/qeth_l3_main.c               |  12 +-
 drivers/staging/octeon/ethernet.c             |   4 +-
 drivers/staging/qlge/qlge_main.c              |  18 +--
 include/linux/netdev_feature_helpers.h        |  28 ++--
 include/net/bonding.h                         |   5 +-
 include/net/net_failover.h                    |   8 +-
 net/8021q/vlan_dev.c                          |  12 +-
 net/batman-adv/soft-interface.c               |   6 +-
 net/bridge/br_device.c                        |  20 ++-
 net/core/dev.c                                |   3 +-
 net/core/sock.c                               |   5 +-
 net/dsa/slave.c                               |   4 +-
 net/ethtool/ioctl.c                           |  13 +-
 net/hsr/hsr_device.c                          |   8 +-
 net/ipv4/ip_gre.c                             |  19 +--
 net/ipv4/ipip.c                               |  18 +--
 net/ipv6/ip6_gre.c                            |  17 ++-
 net/ipv6/ip6_tunnel.c                         |  18 +--
 net/ipv6/sit.c                                |  17 +--
 net/mac80211/ieee80211_i.h                    |  13 +-
 net/mac80211/main.c                           |  19 +++
 net/openvswitch/vport-internal_dev.c          |  10 +-
 net/xfrm/xfrm_interface.c                     |  14 +-
 221 files changed, 2128 insertions(+), 1267 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 548265312743..e1e91f6db8f9 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1628,7 +1628,10 @@ static void vector_eth_configure(
 		.bpf			= NULL
 	});
 
-	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT);
+	dev->features = dev->hw_features;
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
 	timer_setup(&vp->tl, vector_timer_expire, 0);
diff --git a/arch/um/drivers/vector_transports.c b/arch/um/drivers/vector_transports.c
index 0794d23f07cb..91c93993306e 100644
--- a/arch/um/drivers/vector_transports.c
+++ b/arch/um/drivers/vector_transports.c
@@ -406,10 +406,12 @@ static int build_raw_transport_data(struct vector_private *vp)
 		vp->verify_header = &raw_verify_header;
 		vp->header_size = sizeof(struct virtio_net_hdr);
 		vp->rx_header_size = sizeof(struct virtio_net_hdr);
-		vp->dev->hw_features |= (NETIF_F_TSO | NETIF_F_GRO);
-		vp->dev->features |=
-			(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-				NETIF_F_TSO | NETIF_F_GRO);
+		netdev_hw_features_set_set(vp->dev, NETIF_F_TSO_BIT,
+					   NETIF_F_GRO_BIT);
+		netdev_active_features_set_set(vp->dev, NETIF_F_RXCSUM_BIT,
+					       NETIF_F_HW_CSUM_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_GRO_BIT);
 		netdev_info(
 			vp->dev,
 			"raw: using vnet headers for tso and tx/rx checksum"
@@ -425,11 +427,12 @@ static int build_hybrid_transport_data(struct vector_private *vp)
 		vp->verify_header = &raw_verify_header;
 		vp->header_size = sizeof(struct virtio_net_hdr);
 		vp->rx_header_size = sizeof(struct virtio_net_hdr);
-		vp->dev->hw_features |=
-			(NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
-		vp->dev->features |=
-			(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-				NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
+		netdev_hw_features_set_set(vp->dev, NETIF_F_TSO_BIT,
+					   NETIF_F_GSO_BIT, NETIF_F_GRO_BIT);
+		netdev_active_features_set_set(vp->dev, NETIF_F_RXCSUM_BIT,
+					       NETIF_F_HW_CSUM_BIT,
+					       NETIF_F_TSO_BIT, NETIF_F_GSO_BIT,
+					       NETIF_F_GRO_BIT);
 		netdev_info(
 			vp->dev,
 			"tap/raw hybrid: using vnet headers for tso and tx/rx checksum"
@@ -450,11 +453,12 @@ static int build_tap_transport_data(struct vector_private *vp)
 		vp->verify_header = &raw_verify_header;
 		vp->header_size = sizeof(struct virtio_net_hdr);
 		vp->rx_header_size = sizeof(struct virtio_net_hdr);
-		vp->dev->hw_features |=
-			(NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
-		vp->dev->features |=
-			(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-				NETIF_F_TSO | NETIF_F_GSO | NETIF_F_GRO);
+		netdev_hw_features_set_set(vp->dev, NETIF_F_TSO_BIT,
+					   NETIF_F_GSO_BIT, NETIF_F_GRO_BIT);
+		netdev_active_features_set_set(vp->dev, NETIF_F_RXCSUM_BIT,
+					       NETIF_F_HW_CSUM_BIT,
+					       NETIF_F_TSO_BIT, NETIF_F_GSO_BIT,
+					       NETIF_F_GRO_BIT);
 		netdev_info(
 			vp->dev,
 			"tap: using vnet headers for tso and tx/rx checksum"
diff --git a/drivers/infiniband/hw/hfi1/netdev.h b/drivers/infiniband/hw/hfi1/netdev.h
index 8aa074670a9c..685de6e3055d 100644
--- a/drivers/infiniband/hw/hfi1/netdev.h
+++ b/drivers/infiniband/hw/hfi1/netdev.h
@@ -10,6 +10,7 @@
 #include "hfi.h"
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/xarray.h>
 
 /**
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 3650fababf25..949a414d4d7d 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -588,7 +588,9 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 	rn->free_rdma_netdev = hfi1_vnic_free_rn;
 	rn->set_id = hfi1_vnic_set_vesw_id;
 
-	netdev->features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_set(netdev, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_SG_BIT);
 	netdev->hw_features = netdev->features;
 	netdev->vlan_features = netdev->features;
 	netdev->watchdog_timeo = msecs_to_jiffies(HFI_TX_TIMEOUT_MS);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 35e9c8a330e2..2080dfe5986b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -38,6 +38,7 @@
 #include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/workqueue.h>
 #include <linux/kref.h>
 #include <linux/if_infiniband.h>
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a4904371e2db..7ec6c1fedfa1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -219,7 +219,8 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+		netdev_features_clear_set(features, NETIF_F_IP_CSUM_BIT,
+					  NETIF_F_TSO_BIT);
 
 	return features;
 }
@@ -1855,7 +1856,8 @@ static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 	priv->kernel_caps = priv->ca->attrs.kernel_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
-		priv->dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		netdev_hw_features_set_set(priv->dev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT);
 
 		if (priv->kernel_caps & IBK_UD_TSO)
 			priv->dev->hw_features |= NETIF_F_TSO;
@@ -2121,8 +2123,9 @@ void ipoib_setup_common(struct net_device *dev)
 	dev->addr_len		 = INFINIBAND_ALEN;
 	dev->type		 = ARPHRD_INFINIBAND;
 	dev->tx_queue_len	 = ipoib_sendq_size * 2;
-	dev->features		 = (NETIF_F_VLAN_CHALLENGED	|
-				    NETIF_F_HIGHDMA);
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_VLAN_CHALLENGED_BIT,
+				       NETIF_F_HIGHDMA_BIT);
 	netif_keep_dst(dev);
 
 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2d20be6ffb7e..f3cd014f93d0 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -9,6 +9,7 @@
 #include <linux/jhash.h>
 #include <linux/if_tunnel.h>
 #include <linux/net.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/igmp.h>
 #include <linux/workqueue.h>
 #include <net/sch_generic.h>
@@ -3105,12 +3106,12 @@ static void amt_link_setup(struct net_device *dev)
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
 	dev->priv_flags		|= IFF_NO_QUEUE;
-	dev->features		|= NETIF_F_LLTX;
 	dev->features		|= NETIF_F_GSO_SOFTWARE;
-	dev->features		|= NETIF_F_NETNS_LOCAL;
-	dev->hw_features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->hw_features	|= NETIF_F_FRAGLIST | NETIF_F_RXCSUM;
+	netdev_active_features_set_set(dev, NETIF_F_LLTX_BIT,
+				       NETIF_F_NETNS_LOCAL_BIT);
 	dev->hw_features	|= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
 	eth_hw_addr_random(dev);
 	eth_zero_addr(dev->broadcast);
 	ether_setup(dev);
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 683203f87ae2..c71190b54118 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/hash.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/dst_metadata.h>
 #include <net/gro_cells.h>
 #include <net/rtnetlink.h>
@@ -542,12 +543,12 @@ static void bareudp_setup(struct net_device *dev)
 	dev->netdev_ops = &bareudp_netdev_ops;
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &bareudp_type);
-	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features    |= NETIF_F_RXCSUM;
-	dev->features    |= NETIF_F_LLTX;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_RXCSUM_BIT, NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_LLTX_BIT);
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ddd07395827a..7cdaf25cb920 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -59,6 +59,7 @@
 #include <linux/uaccess.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/inetdevice.h>
 #include <linux/igmp.h>
 #include <linux/etherdevice.h>
@@ -254,6 +255,10 @@ static const struct flow_dissector_key flow_keys_bonding_keys[] = {
 
 static struct flow_dissector flow_keys_bonding __read_mostly;
 
+static netdev_features_t bond_vlan_features __ro_after_init;
+static netdev_features_t bond_enc_features __ro_after_init;
+static netdev_features_t bond_mpls_features __ro_after_init;
+
 /*-------------------------- Forward declarations ---------------------------*/
 
 static int bond_init(struct net_device *bond_dev);
@@ -1421,16 +1426,11 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	return features;
 }
 
-#define BOND_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-				 NETIF_F_HIGHDMA | NETIF_F_LRO)
-
-#define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
+#define BOND_VLAN_FEATURES	bond_vlan_features
 
-#define BOND_MPLS_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_GSO_SOFTWARE)
+#define BOND_ENC_FEATURES	bond_enc_features
 
+#define BOND_MPLS_FEATURES	bond_mpls_features
 
 static void bond_compute_features(struct bonding *bond)
 {
@@ -6216,6 +6216,22 @@ static int bond_check_params(struct bond_params *params)
 	return 0;
 }
 
+static void __init bond_netdev_features_init(void)
+{
+	bond_vlan_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(bond_vlan_features, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT, NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HIGHDMA_BIT, NETIF_F_LRO_BIT);
+
+	bond_enc_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(bond_enc_features, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT);
+
+	bond_mpls_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(bond_mpls_features,  NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT);
+}
+
 /* Called from registration process */
 static int bond_init(struct net_device *bond_dev)
 {
@@ -6376,6 +6392,8 @@ static int __init bonding_init(void)
 				ARRAY_SIZE(flow_keys_bonding_keys));
 
 	register_netdevice_notifier(&bond_netdev_notifier);
+
+	bond_netdev_features_init();
 out:
 	return res;
 err:
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index fa622639d640..d9e23850d184 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -9,16 +9,13 @@
 #include <linux/if_bridge.h>
 #include <linux/of_device.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_hsr.h>
 #include "xrs700x.h"
 #include "xrs700x_reg.h"
 
 #define XRS700X_MIB_INTERVAL msecs_to_jiffies(3000)
 
-#define XRS7000X_SUPPORTED_HSR_FEATURES \
-	(NETIF_F_HW_HSR_TAG_INS | NETIF_F_HW_HSR_TAG_RM | \
-	 NETIF_F_HW_HSR_FWD | NETIF_F_HW_HSR_DUP)
-
 #define XRS7003E_ID	0x100
 #define XRS7003F_ID	0x101
 #define XRS7004E_ID	0x200
@@ -633,7 +630,11 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
-		slave->features |= XRS7000X_SUPPORTED_HSR_FEATURES;
+		netdev_active_features_set_set(slave,
+					       NETIF_F_HW_HSR_TAG_INS_BIT,
+					       NETIF_F_HW_HSR_TAG_RM_BIT,
+					       NETIF_F_HW_HSR_FWD_BIT,
+					       NETIF_F_HW_HSR_DUP_BIT);
 	}
 
 	return 0;
@@ -687,7 +688,11 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
-		slave->features &= ~XRS7000X_SUPPORTED_HSR_FEATURES;
+		netdev_active_features_clear_set(slave,
+						 NETIF_F_HW_HSR_TAG_INS_BIT,
+						 NETIF_F_HW_HSR_TAG_RM_BIT,
+						 NETIF_F_HW_HSR_FWD_BIT,
+						 NETIF_F_HW_HSR_DUP_BIT);
 	}
 
 	return 0;
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index aa0fc00faecb..8bee9d473b78 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/init.h>
@@ -123,9 +124,10 @@ static void dummy_setup(struct net_device *dev)
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
-	dev->features	|= NETIF_F_SG | NETIF_F_FRAGLIST;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT, NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_HIGHDMA_BIT, NETIF_F_LLTX_BIT);
 	dev->features	|= NETIF_F_GSO_SOFTWARE;
-	dev->features	|= NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
 	dev->features	|= NETIF_F_GSO_ENCAP_ALL;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 082388bb6169..66eb2d9fe576 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -82,6 +82,7 @@ static int vortex_debug = 1;
 #include <linux/mii.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -1448,7 +1449,8 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 		if (card_idx < MAX_UNITS &&
 		    ((hw_checksums[card_idx] == -1 && (vp->drv_flags & HAS_HWCKSM)) ||
 				hw_checksums[card_idx] == 1)) {
-			dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+			netdev_active_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+						       NETIF_F_SG_BIT);
 		}
 	} else
 		dev->netdev_ops =  &vortex_netdev_ops;
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index aaaff3ba43ef..d72f1ef73484 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -108,6 +108,7 @@ static const int multicast_filter_limit = 32;
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/mm.h>
@@ -2476,10 +2477,13 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * on the current 3XP firmware -- it does not respect the offload
 	 * settings -- so we only allow the user to toggle the TX processing.
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX;
-	dev->features = dev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_TSO_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	dev->features = dev->hw_features;
+	netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_RXCSUM_BIT);
 
 	err = register_netdev(dev);
 	if (err < 0) {
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 857361c74f5d..408be86d6c88 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -33,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -685,11 +686,13 @@ static int starfire_init_one(struct pci_dev *pdev,
 #ifdef ZEROCOPY
 	/* Starfire can do TCP/UDP checksumming */
 	if (enable_hw_cksum)
-		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+		netdev_active_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_SG_BIT);
 #endif /* ZEROCOPY */
 
 #ifdef VLAN_SUPPORT
-	dev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 #endif /* VLAN_RX_KILL_VID */
 #ifdef ADDR_64BITS
 	dev->features |= NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 9c4fe25aca6c..6065eabcd87a 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1483,8 +1483,10 @@ static int greth_of_probe(struct platform_device *ofdev)
 	GRETH_REGSAVE(regs->status, 0xFF);
 
 	if (greth->gbit_mac) {
-		dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM;
+		netdev_hw_features_zero(dev);
+		netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
+					   NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT);
 		dev->features = dev->hw_features | NETIF_F_HIGHDMA;
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index d7762da8b2c0..a3c6dcc6d57b 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -55,6 +55,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
@@ -469,8 +470,10 @@ static int acenic_probe_one(struct pci_dev *pdev,
 	ap->pdev = pdev;
 	ap->name = pci_name(pdev);
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	dev->watchdog_timeo = 5*HZ;
 	dev->min_mtu = 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 371269e0b2b9..571dc950c863 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -11,6 +11,7 @@
 #include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/numa.h>
 #include <linux/pci.h>
 #include <linux/utsname.h>
@@ -4041,11 +4042,9 @@ static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV6_CSUM_MASK)
 		dev_features |= NETIF_F_RXCSUM;
 
-	netdev->features =
-		dev_features |
-		NETIF_F_SG |
-		NETIF_F_RXHASH |
-		NETIF_F_HIGHDMA;
+	netdev->features = dev_features;
+	netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
+				       NETIF_F_RXHASH_BIT, NETIF_F_HIGHDMA_BIT);
 
 	netdev->hw_features |= netdev->features;
 	netdev->vlan_features |= netdev->features;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index f342bb853189..4101c9ee7c99 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2183,7 +2183,9 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	netdev_features_t vxlan_base;
 
-	vxlan_base = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_RX_UDP_TUNNEL_PORT;
+	netdev_features_zero(vxlan_base);
+	netdev_features_set_set(vxlan_base, NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 
 	if (!pdata->hw_feat.vxn)
 		return features;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index 0e8698928e4d..912335f684e5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -118,6 +118,7 @@
 #include <linux/device.h>
 #include <linux/spinlock.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/io.h>
 #include <linux/notifier.h>
@@ -342,42 +343,38 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
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
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_GRO_BIT, NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
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
-
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_enc_features_zero(netdev);
+		netdev_hw_enc_features_set_set(netdev, NETIF_F_SG_BIT,
+					       NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_IPV6_CSUM_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_GRO_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
+		netdev_hw_features_set_set(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 		netdev->udp_tunnel_nic_info = xgbe_get_udp_tunnel_info();
 	}
 
-	netdev->vlan_features |= NETIF_F_SG |
-				 NETIF_F_IP_CSUM |
-				 NETIF_F_IPV6_CSUM |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6;
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT,
+				     NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 
 	netdev->features |= netdev->hw_features;
 	pdata->netdev_features = netdev->features;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index b875c430222e..c57a5e98c0d6 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -119,6 +119,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/workqueue.h>
 #include <linux/phy.h>
 #include <linux/if_vlan.h>
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index d022b6db9e06..c33d9f810953 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -648,8 +648,7 @@ static int xge_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 
-	ndev->features |= NETIF_F_GSO |
-			  NETIF_F_GRO;
+	netdev_active_features_set_set(ndev, NETIF_F_GSO_BIT, NETIF_F_GRO_BIT);
 
 	ret = xge_get_resources(pdata);
 	if (ret)
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.h b/drivers/net/ethernet/apm/xgene-v2/main.h
index b3985a7be59d..ac7bfdd8e2b1 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.h
+++ b/drivers/net/ethernet/apm/xgene-v2/main.h
@@ -17,6 +17,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 53dc8d5fede8..a6709e94f31d 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/gpio.h>
+#include <linux/netdev_feature_helpers.h>
 #include "xgene_enet_main.h"
 #include "xgene_enet_hw.h"
 #include "xgene_enet_sgmac.h"
@@ -2034,10 +2035,9 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 	xgene_enet_set_ethtool_ops(ndev);
-	ndev->features |= NETIF_F_IP_CSUM |
-			  NETIF_F_GSO |
-			  NETIF_F_GRO |
-			  NETIF_F_SG;
+	netdev_active_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_GSO_BIT, NETIF_F_GRO_BIT,
+				       NETIF_F_SG_BIT);
 
 	of_id = of_match_device(xgene_enet_of_match, &pdev->dev);
 	if (of_id) {
@@ -2065,7 +2065,8 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	spin_lock_init(&pdata->mac_lock);
 
 	if (pdata->phy_mode == PHY_INTERFACE_MODE_XGMII) {
-		ndev->features |= NETIF_F_TSO | NETIF_F_RXCSUM;
+		netdev_active_features_set_set(ndev, NETIF_F_TSO_BIT,
+					       NETIF_F_RXCSUM_BIT);
 		spin_lock_init(&pdata->mss_lock);
 	}
 	ndev->hw_features = ndev->features;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 06508eebb585..11b3425562fe 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -20,6 +20,7 @@
 
 #include <linux/moduleparam.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/timer.h>
 #include <linux/cpu.h>
@@ -373,9 +374,10 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 
 	self->ndev->hw_features |= aq_hw_caps->hw_features;
 	self->ndev->features = aq_hw_caps->hw_features;
-	self->ndev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-				     NETIF_F_RXHASH | NETIF_F_SG |
-				     NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_vlan_features_set_set(self->ndev, NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT,
+				     NETIF_F_SG_BIT, NETIF_F_LRO_BIT,
+				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 6ba5b024a7be..9996030a2e5d 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -19,6 +19,7 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
 
@@ -1150,6 +1156,8 @@ static __init int ax88796c_spi_init(void)
 		pr_err("Invalid bitmap description, masking all registers\n");
 	}
 
+	netdev_features_set_array(&ax88796c_feature_set, ax88796c_features);
+
 	return spi_register_driver(&ax88796c_spi_driver);
 }
 
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index a89b93cb4e26..e07247d87407 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -42,6 +42,7 @@
 #include <linux/aer.h>
 #include <linux/bitops.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <net/ip6_checksum.h>
 #include <linux/crc32.h>
@@ -1821,11 +1822,10 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_HW_CSUM |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT);
 
 	if (alx_get_perm_macaddr(hw, hw->perm_addr)) {
 		dev_warn(&pdev->dev,
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 43d821fe7a54..e2e1c28141e7 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index be4b1f8eef29..cb2c12cdd0dc 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2629,11 +2629,10 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	atl1c_set_ethtool_ops(netdev);
 
 	/* TODO: add when ready */
-	netdev->hw_features =	NETIF_F_SG		|
-				NETIF_F_HW_CSUM		|
-				NETIF_F_HW_VLAN_CTAG_RX	|
-				NETIF_F_TSO		|
-				NETIF_F_TSO6;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT);
 	netdev->features =	netdev->hw_features	|
 				NETIF_F_HW_VLAN_CTAG_TX;
 	return 0;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index 9fcad783c939..96eb671c3e1b 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 57a51fb7746c..13b5b706d1ce 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2269,11 +2269,14 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 			  (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 	atl1e_set_ethtool_ops(netdev);
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO |
-			      NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_TSO_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_TX;
 	/* not enabled by default */
-	netdev->hw_features |= NETIF_F_RXALL | NETIF_F_RXFCS;
+	netdev_hw_features_set_set(netdev, NETIF_F_RXALL_BIT,
+				   NETIF_F_RXFCS_BIT);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 7fcfba370fc3..a7e3ae45b5af 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/pm.h>
@@ -2987,12 +2988,16 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_common;
 
-	netdev->features = NETIF_F_HW_CSUM;
-	netdev->features |= NETIF_F_SG;
-	netdev->features |= (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_set(netdev, NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_SG_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
-	netdev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_TSO |
-			      NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	/* is this valid? see atl1_setup_mac_ctrl() */
 	netdev->features |= NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 52144ea2bbf3..e7b2840a3db9 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
@@ -157,13 +158,17 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 				    netdev_features_t wanted)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
+	netdev_features_t tx_csum_features;
 	u32 reg;
 
+	netdev_features_zero(tx_csum_features);
+	netdev_features_set_set(tx_csum_features, NETIF_F_IP_CSUM_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	/* Hardware transmit checksum requires us to enable the Transmit status
 	 * block prepended to the packet contents
 	 */
-	priv->tsb_en = !!(wanted & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				    NETIF_F_HW_VLAN_CTAG_TX));
+	priv->tsb_en = !!(wanted & tx_csum_features);
 	reg = tdma_readl(priv, TDMA_CONTROL);
 	if (priv->tsb_en)
 		reg |= tdma_control_bit(priv, TSB_EN);
@@ -2566,9 +2571,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	dev->netdev_ops = &bcm_sysport_netdev_ops;
 	netif_napi_add(dev, &priv->napi, bcm_sysport_poll, 64);
 
-	dev->features |= NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
-			 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			 NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_active_features_set_set(dev, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HIGHDMA_BIT, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 	dev->max_mtu = UMAC_MAX_MTU_SIZE;
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 29a9ab20ff98..2c902c0b4ffe 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -13,6 +13,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/bcm47xx_nvram.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <net/dsa.h>
@@ -1535,7 +1536,10 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 		goto err_dma_free;
 	}
 
-	net_dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_active_features_zero(net_dev);
+	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT);
 	net_dev->hw_features = net_dev->features;
 	net_dev->vlan_features = net_dev->features;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index b612781be893..687e2aa9c721 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
@@ -8580,12 +8581,14 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	eth_hw_addr_set(dev, bp->mac_addr);
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-		NETIF_F_TSO | NETIF_F_TSO_ECN |
-		NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO_ECN_BIT,
+				   NETIF_F_RXHASH_BIT, NETIF_F_RXCSUM_BIT);
 
 	if (BNX2_CHIP(bp) == BNX2_CHIP_5709)
-		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		netdev_hw_features_set_set(dev, NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_TSO6_BIT);
 
 	dev->vlan_features = dev->hw_features;
 	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 51b1690fd045..ad2c38c261bc 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -32,6 +32,7 @@
 #include <linux/aer.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
@@ -12349,8 +12350,10 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	/* Set TPA flags */
 	if (bp->disable_tpa) {
-		bp->dev->hw_features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
-		bp->dev->features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		netdev_hw_features_clear_set(bp->dev, NETIF_F_LRO_BIT,
+					     NETIF_F_GRO_HW_BIT);
+		netdev_active_features_clear_set(bp->dev, NETIF_F_LRO_BIT,
+						 NETIF_F_GRO_HW_BIT);
 	}
 
 	if (CHIP_IS_E1(bp))
@@ -13197,34 +13200,49 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-		NETIF_F_RXCSUM | NETIF_F_LRO | NETIF_F_GRO | NETIF_F_GRO_HW |
-		NETIF_F_RXHASH | NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO_ECN_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_RXCSUM_BIT, NETIF_F_LRO_BIT,
+				   NETIF_F_GRO_BIT, NETIF_F_GRO_HW_BIT,
+				   NETIF_F_RXHASH_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
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
+		netdev_hw_features_set_set(dev, NETIF_F_GSO_GRE_BIT,
+					   NETIF_F_GSO_GRE_CSUM_BIT,
+					   NETIF_F_GSO_IPXIP4_BIT,
+					   NETIF_F_GSO_UDP_TUNNEL_BIT,
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					   NETIF_F_GSO_PARTIAL_BIT);
+
+		netdev_hw_enc_features_zero(dev);
+		netdev_hw_enc_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_IPV6_CSUM_BIT,
+					       NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+					       NETIF_F_TSO_ECN_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_GSO_IPXIP4_BIT,
+					       NETIF_F_GSO_GRE_BIT,
+					       NETIF_F_GSO_GRE_CSUM_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					       NETIF_F_GSO_PARTIAL_BIT);
+
+		netdev_gso_partial_features_zero(dev);
+		netdev_gso_partial_features_set_set(dev,
+						    NETIF_F_GSO_GRE_CSUM_BIT,
+						    NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 		if (IS_PF(bp))
 			dev->udp_tunnel_nic_info = &bnx2x_udp_tunnels;
 	}
 
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_HIGHDMA;
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				     NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_TSO_ECN_BIT, NETIF_F_TSO6_BIT,
+				     NETIF_F_HIGHDMA_BIT);
 
 	if (IS_PF(bp)) {
 		if (chip_is_e1x)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f46eefb5a029..a737cc9d2752 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
@@ -11179,7 +11180,8 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 		features &= ~NETIF_F_NTUPLE;
 
 	if ((bp->flags & BNXT_FLAG_NO_AGG_RINGS) || bp->xdp_prog)
-		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		netdev_features_clear_set(features, NETIF_F_LRO_BIT,
+					  NETIF_F_GRO_HW_BIT);
 
 	if (!(features & NETIF_F_GRO))
 		features &= ~NETIF_F_GRO_HW;
@@ -13267,8 +13269,10 @@ static int bnxt_get_dflt_rings(struct bnxt *bp, int *max_rx, int *max_tx,
 			return rc;
 		}
 		bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
-		bp->dev->hw_features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
-		bp->dev->features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		netdev_hw_features_clear_set(bp->dev, NETIF_F_LRO_BIT,
+					     NETIF_F_GRO_HW_BIT);
+		netdev_active_features_clear_set(bp->dev, NETIF_F_LRO_BIT,
+						 NETIF_F_GRO_HW_BIT);
 		bnxt_set_ring_params(bp);
 	}
 
@@ -13591,27 +13595,36 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
+	netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_GSO_UDP_TUNNEL_BIT,
+				   NETIF_F_GSO_GRE_BIT, NETIF_F_GSO_IPXIP4_BIT,
+				   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				   NETIF_F_GSO_GRE_CSUM_BIT,
+				   NETIF_F_GSO_PARTIAL_BIT, NETIF_F_RXHASH_BIT,
+				   NETIF_F_RXCSUM_BIT, NETIF_F_GRO_BIT);
 
 	if (BNXT_SUPPORTS_TPA(bp))
 		dev->hw_features |= NETIF_F_LRO;
 
-	dev->hw_enc_features =
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM |
-			NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_PARTIAL;
+	netdev_hw_enc_features_zero(dev);
+	netdev_hw_enc_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				       NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       NETIF_F_GSO_GRE_BIT,
+				       NETIF_F_GSO_IPXIP4_BIT,
+				       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				       NETIF_F_GSO_GRE_CSUM_BIT,
+				       NETIF_F_GSO_IPXIP4_BIT,
+				       NETIF_F_GSO_PARTIAL_BIT);
 	dev->udp_tunnel_nic_info = &bnxt_udp_tunnels;
 
-	dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_GRE_CSUM;
+	netdev_gso_partial_features_zero(dev);
+	netdev_gso_partial_features_set_set(dev, NETIF_F_GSO_GRE_CSUM_BIT,
+					    NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	dev->vlan_features = dev->hw_features | NETIF_F_HIGHDMA;
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
 		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 667e66079c73..4912fe1a027d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -28,6 +28,7 @@
 #include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
@@ -4025,8 +4026,8 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	priv->msg_enable = netif_msg_init(-1, GENET_MSG_DEFAULT);
 
 	/* Set default features */
-	dev->features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			 NETIF_F_RXCSUM;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_HW_CSUM_BIT, NETIF_F_RXCSUM_BIT);
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 59d2d907e989..e27272328a65 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -36,6 +36,7 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -17725,7 +17726,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 	 * to hardware bugs.
 	 */
 	if (tg3_chip_rev_id(tp) != CHIPREV_ID_5700_B0) {
-		features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		netdev_features_set_set(features, NETIF_F_SG_BIT,
+					NETIF_F_IP_CSUM_BIT,
+					NETIF_F_RXCSUM_BIT);
 
 		if (tg3_flag(tp, 5755_PLUS))
 			features |= NETIF_F_IPV6_CSUM;
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 29dd0f93d6c0..ae3f2656c268 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -10,6 +10,7 @@
  */
 #include <linux/bitops.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/in.h>
@@ -3422,17 +3423,21 @@ bnad_netdev_init(struct bnad *bnad)
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
-
-	netdev->features |= netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_vlan_features_zero(netdev);
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT,
+				     NETIF_F_HIGHDMA_BIT, NETIF_F_IP_CSUM_BIT,
+				     NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT);
+
+	netdev->features |= netdev->hw_features;
+	netdev_active_features_set_set(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HIGHDMA_BIT);
 
 	netdev->mem_start = bnad->mmio_start;
 	netdev->mem_end = bnad->mmio_start + bnad->mmio_len - 1;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 66c7d08d376a..fbdce0d335c2 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -21,6 +21,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
@@ -4056,7 +4057,8 @@ static int macb_init(struct platform_device *pdev)
 
 	/* Checksum offload is only available on gem with packet buffer */
 	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE))
-		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+		netdev_hw_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT);
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
 		dev->hw_features &= ~NETIF_F_SG;
 	dev->features = dev->hw_features;
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 1281d1565ef8..8d379803e2fb 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -14,6 +14,7 @@
 #include <linux/if.h>
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/slab.h>
 
 /* XGMAC Register definitions */
@@ -1774,10 +1775,12 @@ static int xgmac_probe(struct platform_device *pdev)
 	if (device_can_wakeup(priv->device))
 		priv->wolopts = WAKE_MAGIC;	/* Magic Frame as default */
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT);
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
-		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				     NETIF_F_RXCSUM;
+		netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT);
 	ndev->features |= ndev->hw_features;
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index bee35ce60171..51334509ba12 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/firmware.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/vxlan.h>
 #include <linux/kthread.h>
 #include "liquidio_common.h"
@@ -3555,26 +3556,31 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		if (OCTEON_CN23XX_PF(octeon_dev) ||
 		    OCTEON_CN6XXX(octeon_dev)) {
-			lio->dev_capability = NETIF_F_HIGHDMA
-					      | NETIF_F_IP_CSUM
-					      | NETIF_F_IPV6_CSUM
-					      | NETIF_F_SG | NETIF_F_RXCSUM
-					      | NETIF_F_GRO
-					      | NETIF_F_TSO | NETIF_F_TSO6
-					      | NETIF_F_LRO;
+			netdev_features_zero(lio->dev_capability);
+			netdev_features_set_set(lio->dev_capability,
+						NETIF_F_HIGHDMA_BIT,
+						NETIF_F_IP_CSUM_BIT,
+						NETIF_F_IPV6_CSUM_BIT,
+						NETIF_F_SG_BIT,
+						NETIF_F_RXCSUM_BIT,
+						NETIF_F_GRO_BIT,
+						NETIF_F_TSO_BIT,
+						NETIF_F_TSO6_BIT,
+						NETIF_F_LRO_BIT);
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
+		netdev_features_zero(lio->enc_dev_capability);
+		netdev_features_set_set(lio->enc_dev_capability,
+					NETIF_F_IP_CSUM_BIT,
+					NETIF_F_IPV6_CSUM_BIT,
+					NETIF_F_GSO_UDP_TUNNEL_BIT,
+					NETIF_F_HW_CSUM_BIT, NETIF_F_SG_BIT,
+					NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
+					NETIF_F_TSO6_BIT, NETIF_F_LRO_BIT);
 
 		netdev->hw_enc_features = (lio->enc_dev_capability &
 					   ~NETIF_F_LRO);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index ac196883f07e..861ecd176404 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/vxlan.h>
 #include "liquidio_common.h"
 #include "octeon_droq.h"
@@ -2088,24 +2089,27 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		lio->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
-		lio->dev_capability = NETIF_F_HIGHDMA
-				      | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
-				      | NETIF_F_SG | NETIF_F_RXCSUM
-				      | NETIF_F_TSO | NETIF_F_TSO6
-				      | NETIF_F_GRO
-				      | NETIF_F_LRO;
+		netdev_features_zero(lio->dev_capability);
+		netdev_features_set_set(lio->dev_capability,
+					NETIF_F_HIGHDMA_BIT,
+					NETIF_F_IP_CSUM_BIT,
+					NETIF_F_IPV6_CSUM_BIT, NETIF_F_SG_BIT,
+					NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
+					NETIF_F_TSO6_BIT, NETIF_F_GRO_BIT,
+					NETIF_F_LRO_BIT);
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
+		netdev_features_zero(lio->enc_dev_capability);
+		netdev_features_set_set(lio->enc_dev_capability,
+					NETIF_F_IP_CSUM_BIT,
+					NETIF_F_IPV6_CSUM_BIT,
+					NETIF_F_GSO_UDP_TUNNEL_BIT,
+					NETIF_F_HW_CSUM_BIT, NETIF_F_SG_BIT,
+					NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
+					NETIF_F_TSO6_BIT, NETIF_F_LRO_BIT);
 
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
index 768ea426d49f..30250252dac5 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -7,6 +7,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -2203,18 +2204,22 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_unregister_interrupts;
 
-	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_SG |
-			       NETIF_F_TSO | NETIF_F_GRO | NETIF_F_TSO6 |
-			       NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			       NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_GRO_BIT,
+				   NETIF_F_TSO6_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	netdev->hw_features |= NETIF_F_RXHASH;
 
 	netdev->features |= netdev->hw_features;
 	netdev->hw_features |= NETIF_F_LOOPBACK;
 
-	netdev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_vlan_features_zero(netdev);
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT,
+				     NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 
 	netdev->netdev_ops = &nicvf_netdev_ops;
 	netdev->watchdog_timeo = NICVF_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 17043c4fce52..c787b9122df8 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -39,6 +39,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/mii.h>
@@ -1031,10 +1032,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->mem_start = mmio_start;
 		netdev->mem_end = mmio_start + mmio_len - 1;
 		netdev->ml_priv = adapter;
-		netdev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM;
-		netdev->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_LLTX | NETIF_F_HIGHDMA;
+		netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
+					   NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT);
+		netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
+					       NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_LLTX_BIT,
+					       NETIF_F_HIGHDMA_BIT);
 
 		if (vlan_tso_capable(adapter)) {
 			netdev->features |=
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index a46afc0bf5cc..1e933a9220e9 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -37,6 +37,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/mdio.h>
@@ -3199,15 +3200,13 @@ static void cxgb3_init_iscsi_mac(struct net_device *dev)
 	pi->iscsic.mac_addr[3] |= 0x80;
 }
 
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN)
-#define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
-			NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int i, err;
 	resource_size_t mmio_start, mmio_len;
 	const struct adapter_info *ai;
 	struct adapter *adapter = NULL;
+	netdev_features_t vlan_feat;
 	struct port_info *pi;
 
 	if (!cxgb3_wq) {
@@ -3303,11 +3302,21 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->irq = pdev->irq;
 		netdev->mem_start = mmio_start;
 		netdev->mem_end = mmio_start + mmio_len - 1;
-		netdev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_features_zero(netdev);
+		netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
+					   NETIF_F_IP_CSUM_BIT, NETIF_F_TSO_BIT,
+					   NETIF_F_TSO6_BIT,
+					   NETIF_F_TSO_ECN_BIT,
+					   NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_HIGHDMA_BIT);
 		netdev->features |= netdev->hw_features |
 				    NETIF_F_HW_VLAN_CTAG_TX;
-		netdev->vlan_features |= netdev->features & VLAN_FEAT;
+		netdev_features_zero(vlan_feat);
+		netdev_features_set_set(vlan_feat, NETIF_F_SG_BIT,
+					NETIF_F_IP_CSUM_BIT, NETIF_F_TSO_BIT,
+					NETIF_F_RXCSUM_BIT,
+					NETIF_F_HW_VLAN_CTAG_RX_BIT);
+		netdev->vlan_features |= netdev->features & vlan_feat;
 
 		netdev->features |= NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9cbce1faab26..964a98ae9556 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -50,6 +50,7 @@
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/rtnetlink.h>
@@ -6205,10 +6206,6 @@ static void free_some_resources(struct adapter *adapter)
 		t4_fw_bye(adapter, adapter->pf);
 }
 
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN | \
-		   NETIF_F_GSO_UDP_L4)
-#define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
-		   NETIF_F_GRO | NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
 #define SEGMENT_SIZE 128
 
 static int t4_get_chip_type(struct adapter *adap, int ver)
@@ -6598,6 +6595,8 @@ static const struct xfrmdev_ops cxgb4_xfrmdev_ops = {
 
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
+	netdev_features_t vlan_features;
+	netdev_features_t tso_features;
 	struct net_device *netdev;
 	struct adapter *adapter;
 	static int adap_idx = 1;
@@ -6809,30 +6808,48 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pi->port_id = i;
 		netdev->irq = pdev->irq;
 
-		netdev->hw_features = NETIF_F_SG | TSO_FLAGS |
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_TC | NETIF_F_NTUPLE | NETIF_F_HIGHDMA;
+		netdev_features_zero(tso_features);
+		netdev_features_set_set(tso_features, NETIF_F_TSO_BIT,
+					NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT,
+					NETIF_F_GSO_UDP_L4_BIT);
+		netdev->hw_features = tso_features;
+		netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
+					   NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT,
+					   NETIF_F_RXHASH_BIT, NETIF_F_GRO_BIT,
+					   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					   NETIF_F_HW_TC_BIT,
+					   NETIF_F_NTUPLE_BIT,
+					   NETIF_F_HIGHDMA_BIT);
 
 		if (chip_ver > CHELSIO_T5) {
-			netdev->hw_enc_features |= NETIF_F_IP_CSUM |
-						   NETIF_F_IPV6_CSUM |
-						   NETIF_F_RXCSUM |
-						   NETIF_F_GSO_UDP_TUNNEL |
-						   NETIF_F_GSO_UDP_TUNNEL_CSUM |
-						   NETIF_F_TSO | NETIF_F_TSO6;
-
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					       NETIF_F_HW_TLS_RECORD;
+			netdev_hw_enc_features_set_set(netdev,
+						       NETIF_F_IP_CSUM_BIT,
+						       NETIF_F_IPV6_CSUM_BIT,
+						       NETIF_F_RXCSUM_BIT,
+						       NETIF_F_GSO_UDP_TUNNEL_BIT,
+						       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+						       NETIF_F_TSO_BIT,
+						       NETIF_F_TSO6_BIT);
+
+			netdev_hw_features_set_set(netdev,
+						   NETIF_F_GSO_UDP_TUNNEL_BIT,
+						   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+						   NETIF_F_HW_TLS_RECORD_BIT);
 
 			if (adapter->rawf_cnt)
 				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
 		}
 
 		netdev->features |= netdev->hw_features;
-		netdev->vlan_features = netdev->features & VLAN_FEAT;
+		vlan_features = tso_features;
+		netdev_features_set_set(vlan_features, NETIF_F_SG_BIT,
+					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
+					NETIF_F_IPV6_CSUM_BIT,
+					NETIF_F_HIGHDMA_BIT);
+		netdev->vlan_features = netdev->features & vlan_features;
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
 			netdev->hw_features |= NETIF_F_HW_TLS_TX;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 54db79f4dcfe..e26142ea68de 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -41,6 +41,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/debugfs.h>
 #include <linux/ethtool.h>
@@ -1918,13 +1919,6 @@ static void cxgb4vf_get_wol(struct net_device *dev,
 	memset(&wol->sopass, 0, sizeof(wol->sopass));
 }
 
-/*
- * TCP Segmentation Offload flags which we support.
- */
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN)
-#define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
-		   NETIF_F_GRO | NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
-
 static const struct ethtool_ops cxgb4vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES,
@@ -2895,6 +2889,8 @@ static unsigned int cxgb4vf_get_port_mask(struct adapter *adapter)
 static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *ent)
 {
+	netdev_features_t vlan_features;
+	netdev_features_t tso_features;
 	struct adapter *adapter;
 	struct net_device *netdev;
 	struct port_info *pi;
@@ -3067,11 +3063,23 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		pi->xact_addr_filt = -1;
 		netdev->irq = pdev->irq;
 
-		netdev->hw_features = NETIF_F_SG | TSO_FLAGS | NETIF_F_GRO |
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_features_zero(tso_features);
+		netdev_features_set_set(tso_features, NETIF_F_TSO_BIT,
+					NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT);
+		netdev->hw_features = tso_features;
+		netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
+					   NETIF_F_GRO_BIT, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT,
+					   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					   NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
-		netdev->vlan_features = netdev->features & VLAN_FEAT;
+		vlan_features = tso_features;
+		netdev_features_set_set(vlan_features, NETIF_F_SG_BIT,
+					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
+					NETIF_F_IPV6_CSUM_BIT,
+					NETIF_F_HIGHDMA_BIT);
+		netdev->vlan_features = netdev->features & vlan_features;
 
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 		netdev->min_mtu = 81;
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 888506185326..0f7727cc47ce 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/mii.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -751,7 +752,7 @@ static struct net_device *ep93xx_dev_alloc(struct ep93xx_eth_data *data)
 	dev->ethtool_ops = &ep93xx_ethtool_ops;
 	dev->netdev_ops = &ep93xx_netdev_ops;
 
-	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT);
 
 	return dev;
 }
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 372fb7b3a282..24f9c5497b8a 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -27,6 +27,7 @@
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/if.h>
 #include <linux/if_ether.h>
@@ -2892,10 +2893,12 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(dev, "loopback tag=0x%04x\n", enic->loop_tag);
 	}
 	if (ENIC_SETTING(enic, TXCSUM))
-		netdev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+		netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
+					   NETIF_F_HW_CSUM_BIT);
 	if (ENIC_SETTING(enic, TSO))
-		netdev->hw_features |= NETIF_F_TSO |
-			NETIF_F_TSO6 | NETIF_F_TSO_ECN;
+		netdev_hw_features_set_set(netdev, NETIF_F_TSO_BIT,
+					   NETIF_F_TSO6_BIT,
+					   NETIF_F_TSO_ECN_BIT);
 	if (ENIC_SETTING(enic, RSS))
 		netdev->hw_features |= NETIF_F_RXHASH;
 	if (ENIC_SETTING(enic, RXCSUM))
@@ -2904,13 +2907,13 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		u64 patch_level;
 		u64 a1 = 0;
 
-		netdev->hw_enc_features |= NETIF_F_RXCSUM		|
-					   NETIF_F_TSO			|
-					   NETIF_F_TSO6			|
-					   NETIF_F_TSO_ECN		|
-					   NETIF_F_GSO_UDP_TUNNEL	|
-					   NETIF_F_HW_CSUM		|
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_enc_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_TSO_ECN_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_HW_CSUM_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		netdev->hw_features |= netdev->hw_enc_features;
 		/* get bit mask from hw about supported offload bit level
 		 * BIT(0) = fw supports patch_level 0
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 6dae768671e3..ee85285c4b11 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -36,6 +36,7 @@
 #include <linux/ethtool.h>
 #include <linux/tcp.h>
 #include <linux/u64_stats_sync.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include <linux/in.h>
 #include <linux/ip.h>
@@ -78,9 +79,8 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 			      GMAC0_SWTQ00_FIN_INT_BIT)
 #define GMAC0_IRQ4_8 (GMAC0_MIB_INT_BIT | GMAC0_RX_OVERRUN_INT_BIT)
 
-#define GMAC_OFFLOAD_FEATURES (NETIF_F_SG | NETIF_F_IP_CSUM | \
-		NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | \
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6)
+static netdev_features_t gmac_offload_features __ro_after_init;
+#define GMAC_OFFLOAD_FEATURES gmac_offload_features
 
 /**
  * struct gmac_queue_page - page buffer per-page info
@@ -2624,6 +2624,11 @@ static int __init gemini_ethernet_module_init(void)
 		return ret;
 	}
 
+	netdev_features_set_set(gmac_offload_features, NETIF_F_SG_BIT,
+				NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
+				NETIF_F_TSO_ECN_BIT, NETIF_F_TSO6_BIT);
+
 	return 0;
 }
 module_init(gemini_ethernet_module_init);
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 77229e53b04e..6e274878b962 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/skbuff.h>
@@ -1644,7 +1645,9 @@ dm9000_probe(struct platform_device *pdev)
 
 	/* dm9000a/b are capable of hardware checksum offload */
 	if (db->type == TYPE_DM9000A || db->type == TYPE_DM9000B) {
-		ndev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+		netdev_hw_features_zero(ndev);
+		netdev_hw_features_set_set(ndev, NETIF_F_RXCSUM_BIT,
+					   NETIF_F_IP_CSUM_BIT);
 		ndev->features |= ndev->hw_features;
 	}
 
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 414362febbb9..55c0a66acad2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -18,6 +18,7 @@
 #include <asm/div64.h>
 #include <linux/aer.h>
 #include <linux/if_bridge.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/busy_poll.h>
 #include <net/vxlan.h>
 
@@ -3999,9 +4000,10 @@ static int be_vxlan_set_port(struct net_device *netdev, unsigned int table,
 	}
 	adapter->vxlan_port = ti->port;
 
-	netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				   NETIF_F_TSO | NETIF_F_TSO6 |
-				   NETIF_F_GSO_UDP_TUNNEL;
+	netdev_hw_enc_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT,
+				       NETIF_F_GSO_UDP_TUNNEL_BIT);
 
 	dev_info(dev, "Enabled VxLAN offloads for UDP port %d\n",
 		 be16_to_cpu(ti->port));
@@ -5186,19 +5188,22 @@ static void be_netdev_init(struct net_device *netdev)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 
-	netdev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-		NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT, NETIF_F_GSO_UDP_TUNNEL_BIT,
+				   NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	if ((be_if_cap_flags(adapter) & BE_IF_FLAGS_RSS))
 		netdev->hw_features |= NETIF_F_RXHASH;
 
-	netdev->features |= netdev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HIGHDMA;
+	netdev->features |= netdev->hw_features;
+	netdev_active_features_set_set(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HIGHDMA_BIT);
 
-	netdev->vlan_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT, NETIF_F_IP_CSUM_BIT,
+				     NETIF_F_IPV6_CSUM_BIT);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 9277d5fb5052..f3cdbd10af8a 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1931,9 +1931,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	priv->tx_q_entries = priv->new_tx_q_entries = DEF_TX_QUEUE_ENTRIES;
 
 	/* Base feature set */
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-		NETIF_F_GRO | NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_CSUM_BIT, NETIF_F_GRO_BIT,
+				   NETIF_F_SG_BIT, NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
 	if (priv->use_ncsi)
 		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
@@ -1947,7 +1949,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
 
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
-		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
+		netdev_hw_features_clear_set(netdev, NETIF_F_HW_CSUM_BIT,
+					     NETIF_F_RXCSUM_BIT);
 	netdev->features |= netdev->hw_features;
 
 	/* register network device */
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 0a180d17121c..ea97e40b4194 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -20,6 +20,7 @@
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/net.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/if_ether.h>
@@ -227,10 +228,10 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
 
-	net_dev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_LLTX | NETIF_F_RXHASH);
-
-	net_dev->hw_features |= NETIF_F_SG | NETIF_F_HIGHDMA;
+	netdev_hw_features_set_set(net_dev, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_LLTX_BIT,
+				   NETIF_F_RXHASH_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_HIGHDMA_BIT);
 	/* The kernels enables GSO automatically, if we declare NETIF_F_SG.
 	 * For conformity, we'll still declare GSO explicitly.
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 75d51572693d..2b79cf7b6b69 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -9,6 +9,7 @@
 #include <linux/of_net.h>
 #include <linux/interrupt.h>
 #include <linux/msi.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/kthread.h>
 #include <linux/iommu.h>
 #include <linux/fsl/mc.h>
@@ -4388,10 +4389,12 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	net_dev->priv_flags &= ~not_supported;
 
 	/* Features */
-	net_dev->features = NETIF_F_RXCSUM |
-			    NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_SG | NETIF_F_HIGHDMA |
-			    NETIF_F_LLTX | NETIF_F_HW_TC | NETIF_F_TSO;
+	netdev_active_features_zero(net_dev);
+	netdev_active_features_set_set(net_dev, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_HIGHDMA_BIT, NETIF_F_LLTX_BIT,
+				       NETIF_F_HW_TC_BIT, NETIF_F_TSO_BIT);
 	net_dev->gso_max_segs = DPAA2_ETH_ENQUEUE_MAX_FDS;
 	net_dev->hw_features = net_dev->features;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index e507e9065214..9f18e88754a4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3280,9 +3280,11 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	/* The DPAA2 switch's ingress path depends on the VLAN table,
 	 * thus we are not able to disable VLAN filtering.
 	 */
-	port_netdev->features = NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_HW_VLAN_STAG_FILTER |
-				NETIF_F_HW_TC;
+	netdev_active_features_zero(port_netdev);
+	netdev_active_features_set_set(port_netdev,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				       NETIF_F_HW_TC_BIT);
 
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 0002dca4d417..7c310a672ddc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -11,6 +11,7 @@
 #define __ETHSW_H
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c4a0e836d4f0..19c00607ff7c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -4,6 +4,7 @@
 #include <asm/unaligned.h>
 #include <linux/mdio.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/fsl/enetc_mdio.h>
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
@@ -761,16 +762,23 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
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
+	netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   NETIF_F_LOOPBACK_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
+	netdev_active_features_zero(ndev);
+	netdev_active_features_set_set(ndev, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT);
+	netdev_vlan_features_zero(ndev);
+	netdev_vlan_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 17924305afa2..d9899932de67 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -2,6 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include "enetc.h"
 
 #define ENETC_DRV_NAME_STR "ENETC VF driver"
@@ -120,16 +121,22 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
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
+	netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT);
+	netdev_active_features_zero(ndev);
+	netdev_active_features_set_set(ndev, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT);
+	netdev_vlan_features_zero(ndev);
+	netdev_vlan_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ad01db156972..a594e7e90378 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/in.h>
@@ -3641,8 +3642,10 @@ static int fec_enet_init(struct net_device *ndev)
 		netif_set_tso_max_segs(ndev, FEC_MAX_TSO_SEGS);
 
 		/* enable hw accelerator */
-		ndev->features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
-				| NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO);
+		netdev_active_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_IPV6_CSUM_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_SG_BIT, NETIF_F_TSO_BIT);
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index e7bf1524b68e..f2d015371e6c 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -67,6 +67,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_vlan.h>
@@ -3239,10 +3240,13 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
-		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-				   NETIF_F_RXCSUM;
-		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG |
-				 NETIF_F_RXCSUM | NETIF_F_HIGHDMA;
+		netdev_hw_features_zero(dev);
+		netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT);
+		netdev_active_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_SG_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_HIGHDMA_BIT);
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index b6de2ad82a32..dd2affc863cc 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -9,6 +9,7 @@
 #include <linux/if_vlan.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
@@ -1711,6 +1704,9 @@ int fun_change_num_queues(struct net_device *dev, unsigned int ntx,
 static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 {
 	struct fun_dev *fdev = &ed->fdev;
+	netdev_features_t gso_encap_flags;
+	netdev_features_t tso_flags;
+	netdev_features_t vlan_feat;
 	struct net_device *netdev;
 	struct funeth_priv *fp;
 	unsigned int ntx, nrx;
@@ -1763,14 +1759,30 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	SET_NETDEV_DEV(netdev, fdev->dev);
 	netdev->netdev_ops = &fun_netdev_ops;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev_features_zero(gso_encap_flags);
+	netdev_features_zero(tso_flags);
+	netdev_features_set_set(gso_encap_flags, NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+	netdev_features_set_set(tso_flags, NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT,
+				NETIF_F_GSO_UDP_L4_BIT);
+	vlan_feat = gso_encap_flags | tso_flags;
+	netdev_features_set_set(vlan_feat, NETIF_F_SG_BIT,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_HIGHDMA_BIT);
+
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_RXHASH_BIT,
+				   NETIF_F_RXCSUM_BIT);
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
index 044db3ebb071..df3a8b786c7a 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -1588,14 +1589,11 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
+	netdev_hw_features_set_set(dev, NETIF_F_HIGHDMA_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT,
+				   NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT);
 	dev->features = dev->hw_features;
 	dev->watchdog_timeo = 5 * HZ;
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index d94cc8c6681f..11f208e479ae 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -13,6 +13,7 @@
 #include <linux/ipv6.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/skbuff.h>
@@ -1798,8 +1799,9 @@ static netdev_features_t hns_nic_fix_features(
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6 |
-				NETIF_F_HW_VLAN_CTAG_FILTER);
+		netdev_features_clear_set(features, NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 		break;
 	default:
 		break;
@@ -2323,21 +2325,27 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &hns_nic_netdev_ops;
 	hns_ethtool_set_ops(ndev);
 
-	ndev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO;
-	ndev->vlan_features |=
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
-	ndev->vlan_features |= NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+	netdev_active_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT,
+				       NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_GSO_BIT, NETIF_F_GRO_BIT);
+	netdev_vlan_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+				     NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				     NETIF_F_SG_BIT, NETIF_F_GSO_BIT,
+				     NETIF_F_GRO_BIT);
 
 	/* MTU range: 68 - 9578 (v1) or 9706 (v2) */
 	ndev->min_mtu = MAC_MIN_MTU;
 	switch (priv->enet_ver) {
 	case AE_VERSION_2:
-		ndev->features |= NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_NTUPLE;
-		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-			NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_active_features_set_set(ndev, NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_NTUPLE_BIT);
+		netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
+					   NETIF_F_GSO_BIT, NETIF_F_GRO_BIT,
+					   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 		ndev->vlan_features |= NETIF_F_TSO | NETIF_F_TSO6;
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 82f83e3f8162..e91e1d39800d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -12,6 +12,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/skbuff.h>
@@ -3305,17 +3306,23 @@ static void hns3_set_default_feature(struct net_device *netdev)
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
+	netdev_active_features_set_set(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_GSO_BIT, NETIF_F_GRO_BIT,
+				       NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				       NETIF_F_GSO_GRE_BIT,
+				       NETIF_F_GSO_GRE_CSUM_BIT,
+				       NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       NETIF_F_SCTP_CRC_BIT,
+				       NETIF_F_FRAGLIST_BIT);
 
 	if (hnae3_ae_dev_gro_supported(ae_dev))
 		netdev->features |= NETIF_F_GRO_HW;
@@ -3341,10 +3348,15 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->vlan_features |= netdev->features &
-		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
-		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
-		  NETIF_F_HW_TC);
+	netdev_features_zero(vlan_off_features);
+	netdev_features_set_set(vlan_off_features,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_GRO_HW_BIT,
+				NETIF_F_NTUPLE_BIT,
+				NETIF_F_HW_TC_BIT);
+	netdev->vlan_features |= netdev->features & ~vlan_off_features;
 
 	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c23ee2ddbce3..7ae848678461 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/slab.h>
 #include <linux/if_vlan.h>
 #include <linux/semaphore.h>
@@ -918,19 +919,28 @@ static const struct net_device_ops hinicvf_netdev_ops = {
 
 static void netdev_features_init(struct net_device *netdev)
 {
-	netdev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM | NETIF_F_LRO |
-			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
+				   NETIF_F_HIGHDMA_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_LRO_BIT, NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_GSO_UDP_TUNNEL_BIT,
+				   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	netdev->vlan_features = netdev->hw_features;
 
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
-				  NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
-				  NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL;
+	netdev_hw_enc_features_zero(netdev);
+	netdev_hw_enc_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT,
+				       NETIF_F_SCTP_CRC_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				       NETIF_F_TSO_ECN_BIT,
+				       NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 }
 
 static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 5dc302880f5f..1ea3ead47eb1 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2993,14 +2993,20 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
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
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				       NETIF_F_HIGHDMA_BIT, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_RXCSUM_BIT);
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_HIGHDMA_BIT, NETIF_F_IP_CSUM_BIT);
 	dev->watchdog_timeo = EHEA_WATCH_DOG_TIMEOUT;
 
 	/* MTU range: 68 - 9022 */
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 0a4d04a8825d..ce8e7d9be073 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3171,7 +3171,9 @@ static int emac_probe(struct platform_device *ofdev)
 		goto err_detach_tah;
 
 	if (dev->tah_dev) {
-		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG;
+		netdev_hw_features_zero(ndev);
+		netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_SG_BIT);
 		ndev->features |= ndev->hw_features | NETIF_F_RXCSUM;
 	}
 	ndev->watchdog_timeo = 5 * HZ;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index ee4548e08446..424ba4a1870c 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1681,10 +1681,10 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->ethtool_ops = &netdev_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
 	netdev->hw_features = NETIF_F_SG;
-	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL) {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				       NETIF_F_RXCSUM;
-	}
+	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
+		netdev_hw_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT);
 
 	netdev->features |= netdev->hw_features;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5ab7c0f81e9a..1987bedb5c12 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4870,7 +4870,9 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		adapter->netdev->hw_features = 0;
 	}
 
-	adapter->netdev->hw_features = NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+	netdev_hw_features_zero(adapter->netdev);
+	netdev_hw_features_set_set(adapter->netdev, NETIF_F_SG_BIT,
+				   NETIF_F_GSO_BIT, NETIF_F_GRO_BIT);
 
 	if (buf->tcp_ipv4_chksum || buf->udp_ipv4_chksum)
 		adapter->netdev->hw_features |= NETIF_F_IP_CSUM;
diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
index 4817eb13ca6f..16ee3bfa316b 100644
--- a/drivers/net/ethernet/intel/e1000/e1000.h
+++ b/drivers/net/ethernet/intel/e1000/e1000.h
@@ -16,6 +16,7 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 23299fc56199..9b96bace6707 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1035,11 +1035,15 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	if (hw->mac_type >= e1000_82543) {
-		netdev->hw_features = NETIF_F_SG |
-				   NETIF_F_HW_CSUM |
-				   NETIF_F_HW_VLAN_CTAG_RX;
-		netdev->features = NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_features_zero(netdev);
+		netdev_hw_features_set_set(netdev,
+					   NETIF_F_SG_BIT,
+					   NETIF_F_HW_CSUM_BIT,
+					   NETIF_F_HW_VLAN_CTAG_RX_BIT);
+		netdev_active_features_zero(netdev);
+		netdev_active_features_set_set(netdev,
+					       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					       NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 
 	if ((hw->mac_type >= e1000_82544) &&
@@ -1049,18 +1053,20 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->features |= netdev->hw_features;
-	netdev->hw_features |= (NETIF_F_RXCSUM |
-				NETIF_F_RXALL |
-				NETIF_F_RXFCS);
+	netdev_hw_features_set_set(netdev,
+				   NETIF_F_RXCSUM_BIT,
+				   NETIF_F_RXALL_BIT,
+				   NETIF_F_RXFCS_BIT);
 
 	if (pci_using_dac) {
 		netdev->features |= NETIF_F_HIGHDMA;
 		netdev->vlan_features |= NETIF_F_HIGHDMA;
 	}
 
-	netdev->vlan_features |= (NETIF_F_TSO |
-				  NETIF_F_HW_CSUM |
-				  NETIF_F_SG);
+	netdev_vlan_features_set_set(netdev,
+				     NETIF_F_TSO_BIT,
+				     NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_SG_BIT);
 
 	/* Do not set IFF_UNICAST_FLT for VMWare's 82545EM */
 	if (hw->device_id != E1000_DEV_ID_82545EM_COPPER ||
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 56984803c957..f716cefb46b4 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/interrupt.h>
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
@@ -7316,13 +7317,17 @@ static int e1000_set_features(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changeable;
 
 	if (changed & (NETIF_F_TSO | NETIF_F_TSO6))
 		adapter->flags |= FLAG_TSO_FORCE;
 
-	if (!(changed & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_RXFCS |
-			 NETIF_F_RXALL)))
+	netdev_features_zero(changeable);
+	netdev_features_set_set(changeable, NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT, NETIF_F_RXCSUM_BIT,
+				NETIF_F_RXHASH_BIT, NETIF_F_RXFCS_BIT,
+				NETIF_F_RXALL_BIT);
+	if (!(changed & changeable))
 		return 0;
 
 	if (changed & NETIF_F_RXFCS) {
@@ -7523,14 +7528,13 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
+	netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				       NETIF_F_RXHASH_BIT, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_CSUM_BIT);
 
 	/* Set user-changeable features (subset of all device features) */
 	netdev->hw_features = netdev->features;
@@ -7541,10 +7545,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (adapter->flags & FLAG_HAS_HW_VLAN_FILTER)
 		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->vlan_features |= (NETIF_F_SG |
-				  NETIF_F_TSO |
-				  NETIF_F_TSO6 |
-				  NETIF_F_HW_CSUM);
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT, NETIF_F_HW_CSUM_BIT);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2cca9e84e31e..d0790e2b8a92 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -5,6 +5,7 @@
 #include <linux/vmalloc.h>
 #include <net/udp_tunnel.h>
 #include <linux/if_macvlan.h>
+#include <linux/netdev_feature_helpers.h>
 
 /**
  * fm10k_setup_tx_resources - allocate Tx resources (Descriptors)
@@ -1557,24 +1558,27 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
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
+	netdev_active_features_set_set(dev,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT,
+				       NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT,
+				       NETIF_F_TSO_ECN_BIT,
+				       NETIF_F_RXHASH_BIT,
+				       NETIF_F_RXCSUM_BIT);
 
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
+		netdev_hw_enc_features_set_set(dev,
+					       NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_TSO_ECN_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_IPV6_CSUM_BIT,
+					       NETIF_F_SG_BIT);
 
 		dev->features |= NETIF_F_GSO_UDP_TUNNEL;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5e60ff79450d..fd2cac55cb31 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7,6 +7,7 @@
 #include <linux/bpf.h>
 #include <generated/utsrelease.h>
 #include <linux/crash_dump.h>
+#include <linux/netdev_feature_helpers.h>
 
 /* Local includes */
 #include "i40e.h"
@@ -13629,6 +13630,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	u8 broadcast[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
 	int etherdev_size;
+	netdev_features_t gso_partial_features;
 	netdev_features_t hw_enc_features;
 	netdev_features_t hw_features;
 
@@ -13641,25 +13643,18 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
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
+	netdev_features_set_set(hw_enc_features, NETIF_F_SG_BIT,
+				NETIF_F_HW_CSUM_BIT, NETIF_F_HIGHDMA_BIT,
+				NETIF_F_TSO_BIT, NETIF_F_TSO_ECN_BIT,
+				NETIF_F_TSO6_BIT, NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_PARTIAL_BIT,
+				NETIF_F_GSO_IPXIP4_BIT, NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				NETIF_F_GSO_UDP_L4_BIT, NETIF_F_SCTP_CRC_BIT,
+				NETIF_F_RXHASH_BIT, NETIF_F_RXCSUM_BIT);
 
 	if (!(pf->hw_features & I40E_HW_OUTER_UDP_CSUM_CAPABLE))
 		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
@@ -13673,22 +13668,21 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
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
+	netdev_features_zero(gso_partial_features);
+	netdev_features_set_set(gso_partial_features, NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+	netdev->gso_partial_features = gso_partial_features;
 	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    I40E_GSO_PARTIAL_FEATURES;
+			    gso_partial_features;
 
-	netdev->mpls_features |= NETIF_F_SG;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
-	netdev->mpls_features |= NETIF_F_TSO;
-	netdev->mpls_features |= NETIF_F_TSO6;
-	netdev->mpls_features |= I40E_GSO_PARTIAL_FEATURES;
+	netdev_mpls_features_set_set(netdev, NETIF_F_SG_BIT,
+				     NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT);
+	netdev->mpls_features |= gso_partial_features;
 
 	/* enable macvlan offloads */
 	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
@@ -13698,7 +13692,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 		      NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
-		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+		netdev_features_set_set(hw_features, NETIF_F_NTUPLE_BIT,
+					NETIF_F_HW_TC_BIT);
 
 	netdev->hw_features |= hw_features;
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3f6187c16424..5f19135f50d2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
 #include <linux/ethtool.h>
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 1671e52b6ba2..34d55e5b461c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4725,31 +4725,31 @@ int iavf_process_config(struct iavf_adapter *adapter)
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
+	netdev_features_set_set(hw_enc_features,
+				NETIF_F_SG_BIT,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO_ECN_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_SCTP_CRC_BIT,
+				NETIF_F_RXHASH_BIT,
+				NETIF_F_RXCSUM_BIT);
 
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
+		netdev_features_set_set(hw_enc_features,
+					NETIF_F_GSO_UDP_TUNNEL_BIT,
+					NETIF_F_GSO_GRE_BIT,
+					NETIF_F_GSO_GRE_CSUM_BIT,
+					NETIF_F_GSO_IPXIP4_BIT,
+					NETIF_F_GSO_IPXIP6_BIT,
+					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					NETIF_F_GSO_PARTIAL_BIT);
 
 		if (!(vfres->vf_cap_flags &
 		      VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM))
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 001500afc4a6..f8182f31302d 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/compiler.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7f59050e4122..dab06a6c12d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3327,20 +3327,26 @@ static void ice_set_netdev_features(struct net_device *netdev)
 
 	if (ice_is_safe_mode(pf)) {
 		/* safe mode */
-		netdev->features = NETIF_F_SG | NETIF_F_HIGHDMA;
+		netdev_active_features_zero(netdev);
+		netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
+					       NETIF_F_HIGHDMA_BIT);
 		netdev->hw_features = netdev->features;
 		return;
 	}
 
-	dflt_features = NETIF_F_SG	|
-			NETIF_F_HIGHDMA	|
-			NETIF_F_NTUPLE	|
-			NETIF_F_RXHASH;
+	netdev_features_zero(dflt_features);
+	netdev_features_set_set(dflt_features,
+				NETIF_F_SG_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_NTUPLE_BIT,
+				NETIF_F_RXHASH_BIT);
 
-	csumo_features = NETIF_F_RXCSUM	  |
-			 NETIF_F_IP_CSUM  |
-			 NETIF_F_SCTP_CRC |
-			 NETIF_F_IPV6_CSUM;
+	netdev_features_zero(csumo_features);
+	netdev_features_set_set(csumo_features,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_SCTP_CRC_BIT,
+				NETIF_F_IPV6_CSUM_BIT);
 
 	vlano_features = NETIF_F_HW_VLAN_CTAG_FILTER |
 			 NETIF_F_HW_VLAN_CTAG_TX     |
@@ -3350,28 +3356,33 @@ static void ice_set_netdev_features(struct net_device *netdev)
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
-
-	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE_CSUM;
+	netdev_features_zero(tso_features);
+	netdev_features_set_set(tso_features,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO_ECN_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				NETIF_F_GSO_PARTIAL_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_L4_BIT);
+
+	netdev_gso_partial_features_set_set(netdev,
+					    NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					    NETIF_F_GSO_GRE_CSUM_BIT);
 	/* set features that user can change */
 	netdev->hw_features = dflt_features | csumo_features |
 			      vlano_features | tso_features;
 
 	/* add support for HW_CSUM on packets with MPLS header */
-	netdev->mpls_features =  NETIF_F_HW_CSUM |
-				 NETIF_F_TSO     |
-				 NETIF_F_TSO6;
+	netdev_mpls_features_zero(netdev);
+	netdev_mpls_features_set_set(netdev,
+				     NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT);
 
 	/* enable features */
 	netdev->features |= netdev->hw_features;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ff0c7f0bf07a..af656420ec4d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/ipv6.h>
 #include <linux/slab.h>
 #include <net/checksum.h>
@@ -2511,21 +2512,27 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 
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
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_GSO_UDP_L4_BIT,
+					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
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
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_GSO_UDP_L4_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -3164,6 +3171,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	s32 ret_val;
 	static int global_quad_port_a; /* global quad port a indication */
 	const struct e1000_info *ei = igb_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	u8 part_str[E1000_PBANUM_LENGTH];
 	int err;
 
@@ -3268,34 +3276,39 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * set by igb_sw_init so we should use an or instead of an
 	 * assignment.
 	 */
-	netdev->features |= NETIF_F_SG |
-			    NETIF_F_TSO |
-			    NETIF_F_TSO6 |
-			    NETIF_F_RXHASH |
-			    NETIF_F_RXCSUM |
-			    NETIF_F_HW_CSUM;
+	netdev_active_features_set_set(netdev,
+				       NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT,
+				       NETIF_F_RXHASH_BIT,
+				       NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_CSUM_BIT);
 
 	if (hw->mac.type >= e1000_82576)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+		netdev_active_features_set_set(netdev,
+					       NETIF_F_SCTP_CRC_BIT,
+					       NETIF_F_GSO_UDP_L4_BIT);
 
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
+	netdev_features_zero(gso_partial_features);
+	netdev_features_set_set(gso_partial_features,
+				NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+	netdev->gso_partial_features = gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
 
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_RXALL;
+	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set_set(netdev,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_RXALL_BIT);
 
 	if (hw->mac.type >= e1000_i350)
 		netdev->hw_features |= NETIF_F_NTUPLE;
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index f4e91db89fe5..2964afacac72 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
 #include <linux/slab.h>
@@ -2626,19 +2627,25 @@ igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -2684,6 +2691,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct igbvf_adapter *adapter;
 	struct e1000_hw *hw;
 	const struct igbvf_info *ei = igbvf_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	static int cards_found;
 	int err;
 
@@ -2758,23 +2766,26 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
+	netdev_hw_features_set_set(netdev,
+				   NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT,
+				   NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_SCTP_CRC_BIT);
+
+	netdev_features_zero(gso_partial_features);
+	netdev_features_set_set(gso_partial_features,
+				NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
+	netdev->gso_partial_features = gso_partial_features;
+	netdev->hw_features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
 
 	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index a5c4b19d71a2..dc0e3aee643b 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -3,6 +3,7 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include "igc_mac.h"
 #include "igc_hw.h"
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index bf6c461e1a2a..63f30912cada 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -9,6 +9,7 @@
 #include <linux/udp.h>
 #include <linux/ip.h>
 #include <linux/pm_runtime.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/pkt_sched.h>
 #include <linux/bpf_trace.h>
 #include <net/xdp_sock_drv.h>
@@ -5019,19 +5020,25 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	/* We can only support IPv4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -6257,6 +6264,7 @@ static int igc_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct igc_hw *hw;
 	const struct igc_info *ei = igc_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	int err;
 
 	err = pci_enable_device_mem(pdev);
@@ -6337,24 +6345,26 @@ static int igc_probe(struct pci_dev *pdev,
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
+	netdev_active_features_set_set(netdev,
+				       NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT,
+				       NETIF_F_TSO_ECN_BIT,
+				       NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_SCTP_CRC_BIT,
+				       NETIF_F_HW_TC_BIT);
+
+	netdev_features_zero(gso_partial_features);
+	netdev_features_set_set(gso_partial_features,
+				NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+	netdev->gso_partial_features = gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 45be9a1ab6af..51e89e9aefcb 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -3,6 +3,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/netdev_feature_helpers.h>
 #include <linux/prefetch.h>
 #include "ixgb.h"
 
@@ -428,11 +429,13 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	netdev->hw_features = NETIF_F_SG |
-			   NETIF_F_TSO |
-			   NETIF_F_HW_CSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev,
+				   NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT,
+				   NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev->features = netdev->hw_features |
 			   NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features |= NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 298cfbfcb7b6..38f553e0411e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
 #include <linux/in.h>
@@ -10221,21 +10222,27 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 
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
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_GSO_UDP_L4_BIT,
+					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
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
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_GSO_UDP_L4_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -10772,6 +10779,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgbe_adapter *adapter = NULL;
 	struct ixgbe_hw *hw;
 	const struct ixgbe_info *ii = ixgbe_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	unsigned int indices = MAX_TX_QUEUES;
 	u8 part_str[IXGBE_PBANUM_LENGTH];
 	int i, err, expected_gts;
@@ -10958,56 +10966,64 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
+	netdev_active_features_set_set(netdev,
+				       NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT,
+				       NETIF_F_RXHASH_BIT,
+				       NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_CSUM_BIT);
+
+	netdev_features_zero(gso_partial_features);
+	netdev_features_set_set(gso_partial_features,
+				NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
+	netdev->gso_partial_features = gso_partial_features;
 	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    IXGBE_GSO_PARTIAL_FEATURES;
+			    gso_partial_features;
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+		netdev_hw_features_set_set(netdev,
+					   NETIF_F_SCTP_CRC_BIT,
+					   NETIF_F_GSO_UDP_L4_BIT);
 
 #ifdef CONFIG_IXGBE_IPSEC
-#define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
-				 NETIF_F_HW_ESP_TX_CSUM | \
-				 NETIF_F_GSO_ESP)
-
 	if (adapter->ipsec)
-		netdev->features |= IXGBE_ESP_FEATURES;
+		netdev_active_features_set_set(netdev,
+					       NETIF_F_HW_ESP_BIT,
+					       NETIF_F_HW_ESP_TX_CSUM_BIT,
+					       NETIF_F_GSO_ESP_BIT);
 #endif
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_HW_VLAN_CTAG_FILTER |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_RXALL |
-			       NETIF_F_HW_L2FW_DOFFLOAD;
+	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set_set(netdev,
+				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_RXALL_BIT,
+				   NETIF_F_HW_L2FW_DOFFLOAD_BIT);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->hw_features |= NETIF_F_NTUPLE |
-				       NETIF_F_HW_TC;
+		netdev_active_features_set_set(netdev,
+					       NETIF_F_NTUPLE_BIT,
+					       NETIF_F_HW_TC_BIT);
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->hw_enc_features |= netdev->vlan_features;
-	netdev->mpls_features |= NETIF_F_SG |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6 |
-				 NETIF_F_HW_CSUM;
-	netdev->mpls_features |= IXGBE_GSO_PARTIAL_FEATURES;
+	netdev_mpls_features_set_set(netdev,
+				     NETIF_F_SG_BIT,
+				     NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT,
+				     NETIF_F_HW_CSUM_BIT);
+	netdev->mpls_features |= gso_partial_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
 	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
@@ -11040,12 +11056,13 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		fcoe_l = min_t(int, IXGBE_FCRETA_SIZE, num_online_cpus());
 		adapter->ring_feature[RING_F_FCOE].limit = fcoe_l;
 
-		netdev->features |= NETIF_F_FSO |
-				    NETIF_F_FCOE_CRC;
-
-		netdev->vlan_features |= NETIF_F_FSO |
-					 NETIF_F_FCOE_CRC |
-					 NETIF_F_FCOE_MTU;
+		netdev_active_features_set_set(netdev,
+					       NETIF_F_FSO_BIT,
+					       NETIF_F_FCOE_CRC_BIT);
+		netdev_vlan_features_set_set(netdev,
+					     NETIF_F_FSO_BIT,
+					     NETIF_F_FCOE_CRC_BIT,
+					     NETIF_F_FCOE_MTU_BIT);
 	}
 #endif /* IXGBE_FCOE */
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE)
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 9984ebc62d78..ae7ec049e020 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -651,12 +651,14 @@ void ixgbevf_init_ipsec_offload(struct ixgbevf_adapter *adapter)
 
 	adapter->netdev->xfrmdev_ops = &ixgbevf_xfrmdev_ops;
 
-#define IXGBEVF_ESP_FEATURES	(NETIF_F_HW_ESP | \
-				 NETIF_F_HW_ESP_TX_CSUM | \
-				 NETIF_F_GSO_ESP)
-
-	adapter->netdev->features |= IXGBEVF_ESP_FEATURES;
-	adapter->netdev->hw_enc_features |= IXGBEVF_ESP_FEATURES;
+	netdev_active_features_set_set(adapter->netdev,
+				       NETIF_F_HW_ESP_BIT,
+				       NETIF_F_HW_ESP_TX_CSUM_BIT,
+				       NETIF_F_GSO_ESP_BIT);
+	netdev_hw_enc_features_set_set(adapter->netdev,
+				       NETIF_F_HW_ESP_BIT,
+				       NETIF_F_HW_ESP_TX_CSUM_BIT,
+				       NETIF_F_GSO_ESP_BIT);
 
 	return;
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
index 149c733fcc2b..2fa9286e0975 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
@@ -9,6 +9,7 @@
 #include <linux/timer.h>
 #include <linux/io.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_vlan.h>
 #include <linux/u64_stats_sync.h>
 #include <net/xdp.h>
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 2f12fbe229c1..248fb4b58166 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
 #include <linux/in.h>
@@ -4407,19 +4408,25 @@ ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN)) {
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN)) {
+		netdev_features_clear_set(features,
+					  NETIF_F_HW_CSUM_BIT,
+					  NETIF_F_SCTP_CRC_BIT,
+					  NETIF_F_TSO_BIT,
+					  NETIF_F_TSO6_BIT);
+		return features;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
@@ -4521,6 +4528,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgbevf_adapter *adapter = NULL;
 	struct ixgbe_hw *hw = NULL;
 	const struct ixgbevf_info *ii = ixgbevf_info_tbl[ent->driver_data];
+	netdev_features_t gso_partial_features;
 	bool disable_dev = false;
 	int err;
 
@@ -4593,32 +4601,37 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
+	netdev_hw_features_set_set(netdev,
+				   NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT,
+				   NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_SCTP_CRC_BIT);
+
+	netdev_features_zero(gso_partial_features);
+	netdev_features_set_set(gso_partial_features,
+				NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
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
+	netdev_mpls_features_set_set(netdev,
+				     NETIF_F_SG_BIT,
+				     NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT,
+				     NETIF_F_HW_CSUM_BIT);
+	netdev->mpls_features |= gso_partial_features;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index b56594407965..6eb610dce765 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -2955,19 +2956,23 @@ jme_init_one(struct pci_dev *pdev,
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
+	netdev_hw_features_set_set(netdev,
+				   NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT,
+				   NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT,
+				   NETIF_F_RXCSUM_BIT);
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_set(netdev,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT,
+				       NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT,
+				       NETIF_F_TSO6_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	if (using_dac)
 		netdev->features	|=	NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 8b9abe622489..0891bbe7d95e 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -38,6 +38,7 @@
 #include <linux/ethtool.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -3200,7 +3201,9 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	dev->watchdog_timeo = 2 * HZ;
 	dev->base_addr = 0;
 
-	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_TSO_BIT);
 	dev->vlan_features = dev->features;
 
 	dev->features |= NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b500fe1dfa81..cb54394aad51 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -22,6 +22,7 @@
 #include <linux/mbus.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -3847,7 +3848,8 @@ static netdev_features_t mvneta_fix_features(struct net_device *dev,
 	struct mvneta_port *pp = netdev_priv(dev);
 
 	if (pp->tx_csum_limit && dev->mtu > pp->tx_csum_limit) {
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+		netdev_features_clear_set(features, NETIF_F_IP_CSUM_BIT,
+					  NETIF_F_TSO_BIT);
 		netdev_info(dev,
 			    "Disable IP checksum for MTU greater than %dB\n",
 			    pp->tx_csum_limit);
@@ -5612,8 +5614,10 @@ static int mvneta_probe(struct platform_device *pdev)
 		}
 	}
 
-	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_TSO | NETIF_F_RXCSUM;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				       NETIF_F_RXCSUM_BIT);
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 38e5b4be6a4d..be0b95342b1d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include <linux/skbuff.h>
@@ -6846,11 +6847,13 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		}
 	}
 
-	features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		   NETIF_F_TSO;
+	netdev_features_zero(features);
+	netdev_features_set_set(features, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT);
 	dev->features = features | NETIF_F_RXCSUM;
-	dev->hw_features |= features | NETIF_F_RXCSUM | NETIF_F_GRO |
-			    NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->hw_features |= features;
+	netdev_hw_features_set_set(dev, NETIF_F_RXCSUM_BIT, NETIF_F_GRO_BIT,
+				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	if (mvpp22_rss_is_supported(port)) {
 		dev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 49a4ff01cecb..1c94b41927a7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -15,6 +15,7 @@
 #include <net/ip.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -2744,10 +2745,12 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
-	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			       NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			       NETIF_F_GSO_UDP_L4);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				   NETIF_F_RXHASH_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_GSO_UDP_L4_BIT);
 	netdev->features |= netdev->hw_features;
 
 	err = otx2_mcam_flow_init(pf);
@@ -2773,7 +2776,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
 		netdev->hw_features |= NETIF_F_HW_TC;
 
-	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
+	netdev_hw_features_set_set(netdev, NETIF_F_LOOPBACK_BIT,
+				   NETIF_F_RXALL_BIT);
 
 	netif_set_tso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 86653bb8e403..7fdcf33a35e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -7,6 +7,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/net_tstamp.h>
 
@@ -637,10 +638,12 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
 
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_GSO_UDP_L4;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				   NETIF_F_RXHASH_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_GSO_UDP_L4_BIT);
 	netdev->features = netdev->hw_features;
 	/* Support TSO on tag interface */
 	netdev->vlan_features |= netdev->features;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3956d6d5df3c..470b059443b8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -6,6 +6,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/if_vlan.h>
@@ -627,7 +628,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_dl_port_register;
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
+	netdev_active_features_set_set(dev, NETIF_F_NETNS_LOCAL_BIT,
+				       NETIF_F_HW_TC_BIT);
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 	SET_NETDEV_DEV(dev, sw->dev->dev);
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index bcc4aa59d10a..424bd88a0946 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/pci.h>
@@ -3860,8 +3861,9 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	if (is_genesis(hw))
 		timer_setup(&skge->link_timer, xm_link_timer, 0);
 	else {
-		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-		                   NETIF_F_RXCSUM;
+		netdev_hw_features_zero(dev);
+		netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT);
 		dev->features |= dev->hw_features;
 	}
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e19acfcd84d4..90c5297c791f 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
 
@@ -4634,7 +4638,8 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 
 	sky2->port = port;
 
-	dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO;
+	netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT);
 
 	if (highmem)
 		dev->features |= NETIF_F_HIGHDMA;
@@ -4646,7 +4651,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
 		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_HW_VLAN_CTAG_RX;
-		dev->vlan_features |= SKY2_VLAN_OFFLOADS;
+		netdev_vlan_features_set_array(dev, &sky2_vlan_feature_set);
 	}
 
 	dev->features |= dev->hw_features;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index f1259bdb1a29..ff4395638546 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/slab.h>
 
 #include <linux/mlx4/driver.h>
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index ca4b93a01034..2561daf63151 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -39,6 +39,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/ip.h>
 #include <net/vxlan.h>
 #include <net/devlink.h>
@@ -3322,41 +3323,49 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	/*
 	 * Set driver features
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT);
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
+		netdev_hw_features_set_set(dev, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					   NETIF_F_GSO_PARTIAL_BIT);
+		netdev_active_features_set_set(dev, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					       NETIF_F_GSO_PARTIAL_BIT);
 		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		dev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				       NETIF_F_RXCSUM |
-				       NETIF_F_TSO | NETIF_F_TSO6 |
-				       NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				       NETIF_F_GSO_PARTIAL;
+		netdev_hw_enc_features_zero(dev);
+		netdev_hw_enc_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_IPV6_CSUM_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					       NETIF_F_GSO_PARTIAL_BIT);
 
 		dev->udp_tunnel_nic_info = &mlx4_udp_tunnels;
 	}
 
 	dev->vlan_features = dev->hw_features;
 
-	dev->hw_features |= NETIF_F_RXCSUM | NETIF_F_RXHASH;
-	dev->features = dev->hw_features | NETIF_F_HIGHDMA |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_VLAN_CTAG_FILTER;
-	dev->hw_features |= NETIF_F_LOOPBACK |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_set_set(dev, NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT);
+	dev->features = dev->hw_features;
+	netdev_active_features_set_set(dev, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_hw_features_set_set(dev, NETIF_F_LOOPBACK_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	if (!(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN)) {
-		dev->features |= NETIF_F_HW_VLAN_STAG_RX |
-			NETIF_F_HW_VLAN_STAG_FILTER;
+		netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_STAG_RX_BIT,
+					       NETIF_F_HW_VLAN_STAG_FILTER_BIT);
 		dev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 13aac5131ff7..841e4fb520d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -34,6 +34,7 @@
 
 #include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/timecounter.h>
 #include <linux/net_tstamp.h>
 #include <linux/crash_dump.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 905025a10a8a..8b1be6bfb475 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4920,31 +4920,33 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_features_set_set(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+		netdev_hw_enc_features_set_set(netdev,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL |
-					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_vlan_features_set_set(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					     NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE |
-						NETIF_F_GSO_GRE_CSUM;
+		netdev_hw_features_set_set(netdev, NETIF_F_GSO_GRE_BIT,
+					   NETIF_F_GSO_GRE_CSUM_BIT);
+		netdev_hw_enc_features_set_set(netdev, NETIF_F_GSO_GRE_BIT,
+					       NETIF_F_GSO_GRE_CSUM_BIT);
+		netdev_gso_partial_features_set_set(netdev, NETIF_F_GSO_GRE_BIT,
+						    NETIF_F_GSO_GRE_CSUM_BIT);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-		netdev->hw_features |= NETIF_F_GSO_IPXIP4 |
-				       NETIF_F_GSO_IPXIP6;
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4 |
-					   NETIF_F_GSO_IPXIP6;
-		netdev->gso_partial_features |= NETIF_F_GSO_IPXIP4 |
-						NETIF_F_GSO_IPXIP6;
+		netdev_hw_features_set_set(netdev, NETIF_F_GSO_IPXIP4_BIT,
+					   NETIF_F_GSO_IPXIP6_BIT);
+		netdev_hw_enc_features_set_set(netdev, NETIF_F_GSO_IPXIP4_BIT,
+					       NETIF_F_GSO_IPXIP6_BIT);
+		netdev_gso_partial_features_set_set(netdev,
+						    NETIF_F_GSO_IPXIP4_BIT,
+						    NETIF_F_GSO_IPXIP6_BIT);
 	}
 
 	netdev->gso_partial_features             |= NETIF_F_GSO_UDP_L4;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5bcf5bceff71..72aa22236ffa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/slab.h>
@@ -1682,9 +1683,12 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 
 	netif_carrier_off(dev);
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_LLTX | NETIF_F_SG |
-			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
-	dev->hw_features |= NETIF_F_HW_TC | NETIF_F_LOOPBACK;
+	netdev_active_features_set_set(dev, NETIF_F_NETNS_LOCAL_BIT,
+				       NETIF_F_LLTX_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_TC_BIT);
+	netdev_hw_features_set_set(dev, NETIF_F_HW_TC_BIT,
+				   NETIF_F_LOOPBACK_BIT);
 
 	dev->min_mtu = 0;
 	dev->max_mtu = ETH_MAX_MTU;
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 468520079c65..02c666cc48e6 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/micrel_phy.h>
+#include <linux/netdev_feature_helpers.h>
 
 
 /* DMA Registers */
@@ -6705,7 +6706,9 @@ static int __init netdev_init(struct net_device *dev)
 	/* 500 ms timeout */
 	dev->watchdog_timeo = HZ / 2;
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_RXCSUM_BIT);
 
 	/*
 	 * Hardware does not really support IPv6 checksum generation, but
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 2599dfffd1da..934d9e2c4008 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/crc32.h>
 #include <linux/microchipphy.h>
@@ -3394,8 +3395,10 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 
 	adapter->netdev->netdev_ops = &lan743x_netdev_ops;
 	adapter->netdev->ethtool_ops = &lan743x_ethtool_ops;
-	adapter->netdev->features = NETIF_F_SG | NETIF_F_TSO |
-				    NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	netdev_active_features_zero(adapter->netdev);
+	netdev_active_features_set_set(adapter->netdev, NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT, NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_RXCSUM_BIT);
 	adapter->netdev->hw_features = adapter->netdev->features;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9259a74eca40..68962a6c0bbd 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2081,10 +2081,11 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	netdev_lockdep_set_classes(ndev);
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	ndev->hw_features |= NETIF_F_RXCSUM;
-	ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
-	ndev->hw_features |= NETIF_F_RXHASH;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_RXHASH_BIT);
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2979fb1ba0f7..a2db1db99c4b 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -10,6 +10,7 @@
 
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of_net.h>
 #include <linux/phy/phy.h>
 #include <net/pkt_cls.h>
@@ -1854,9 +1855,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	dev->ethtool_ops = &ocelot_ethtool_ops;
 	dev->max_mtu = OCELOT_JUMBO_MTU;
 
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
-		NETIF_F_HW_TC;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
+	netdev_hw_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   NETIF_F_RXFCS_BIT, NETIF_F_HW_TC_BIT);
+	netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_TC_BIT);
 
 	err = of_get_ethdev_address(portnp, dev);
 	if (err)
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 9063e2e22cd5..8873cdcadb0f 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -42,6 +42,7 @@
 
 #include <linux/tcp.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
@@ -687,7 +688,9 @@ static int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
 	int status;
 
 	/* probe for IPv6 TSO support */
-	mgp->features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO;
+	netdev_features_zero(mgp->features);
+	netdev_features_set_set(mgp->features, NETIF_F_SG_BIT,
+				NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT);
 	status = myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_MAX_TSO6_HDR_SIZE,
 				   &cmd, 0);
 	if (status == 0) {
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index d8a77b0db50d..4d69c006dcaa 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -60,6 +60,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/mdio.h>
 #include <linux/skbuff.h>
@@ -7853,12 +7854,15 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
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
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_RXCSUM_BIT, NETIF_F_LRO_BIT,
+				   NETIF_F_SG_BIT);
+	dev->features |= dev->hw_features;
+	netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HIGHDMA_BIT);
 	dev->watchdog_timeo = WATCH_DOG_TIMEOUT;
 	INIT_WORK(&sp->rst_timer_task, s2io_restart_nic);
 	INIT_WORK(&sp->set_link_task, s2io_set_link);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 469c3939c306..e6d11d509145 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/ip.h>
@@ -2377,9 +2378,10 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		netdev->hw_features |= NETIF_F_RXHASH;
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO) {
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					       NETIF_F_GSO_PARTIAL;
+			netdev_hw_features_set_set(netdev,
+						   NETIF_F_GSO_UDP_TUNNEL_BIT,
+						   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+						   NETIF_F_GSO_PARTIAL_BIT);
 			netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		}
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 7c0675ca337b..7afbd49551bc 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -37,6 +37,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -5811,8 +5812,9 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	if (id->driver_data & DEV_HAS_CHECKSUM) {
 		np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
-		dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_RXCSUM;
+		netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+					   NETIF_F_RXCSUM_BIT);
 	}
 
 	np->vlanctl_bits = 0;
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 46da937ad27f..ab519deead53 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -13,6 +13,7 @@
 #include <linux/gpio/machine.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_pch.h>
@@ -2518,8 +2519,9 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	netdev->watchdog_timeo = PCH_GBE_WATCHDOG_PERIOD;
 	netif_napi_add(netdev, &adapter->napi,
 		       pch_gbe_napi_poll, NAPI_POLL_WEIGHT);
-	netdev->hw_features = NETIF_F_RXCSUM |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT);
 	netdev->features = netdev->hw_features;
 	pch_gbe_set_ethtool_ops(netdev);
 
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index f0ace3a0e85c..42a0f3fbd649 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1699,8 +1699,10 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &mac->napi, pasemi_mac_poll, 64);
 
-	dev->features = NETIF_F_IP_CSUM | NETIF_F_LLTX | NETIF_F_SG |
-			NETIF_F_HIGHDMA | NETIF_F_GSO;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_LLTX_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_HIGHDMA_BIT, NETIF_F_GSO_BIT);
 
 	mac->dma_pdev = pci_get_device(PCI_VENDOR_ID_PASEMI, 0xa007, NULL);
 	if (!mac->dma_pdev) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0be79c516781..6930603e1698 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -5,6 +5,7 @@
 #include <linux/printk.h>
 #include <linux/dynamic_debug.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/rtnetlink.h>
@@ -1486,15 +1487,17 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
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
+	netdev_features_zero(features);
+	netdev_features_set_set(features,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_TSO_ECN_BIT);
 
 	if (lif->nxqs > 1)
 		features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 4e6f00af17d9..5f950dfed66c 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -5,6 +5,7 @@
  * All rights reserved.
  */
 
+#include <linux/netdev_feature_helpers.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
@@ -1347,11 +1348,13 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 
 	netdev->ethtool_ops = &netxen_nic_ethtool_ops;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-	                      NETIF_F_RXCSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_RXCSUM_BIT);
 
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
-		netdev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		netdev_hw_features_set_set(netdev, NETIF_F_IPV6_CSUM_BIT,
+					   NETIF_F_TSO6_BIT);
 
 	netdev->vlan_features |= netdev->hw_features;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 3c1bfff29157..7fc2fed4472f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -20,6 +20,7 @@
 #include <asm/param.h>
 #include <linux/io.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <net/udp_tunnel.h>
@@ -850,9 +851,12 @@ static void qede_init_ndev(struct qede_dev *edev)
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* user-changeble features */
-	hw_features = NETIF_F_GRO | NETIF_F_GRO_HW | NETIF_F_SG |
-		      NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		      NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_TC;
+	netdev_features_zero(hw_features);
+	netdev_features_set_set(hw_features, NETIF_F_GRO_BIT,
+				NETIF_F_GRO_HW_BIT, NETIF_F_SG_BIT,
+				NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				NETIF_F_HW_TC_BIT);
 
 	if (edev->dev_info.common.b_arfs_capable)
 		hw_features |= NETIF_F_NTUPLE;
@@ -863,32 +867,41 @@ static void qede_init_ndev(struct qede_dev *edev)
 
 	if (udp_tunnel_enable || edev->dev_info.common.gre_enable) {
 		hw_features |= NETIF_F_TSO_ECN;
-		ndev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-					NETIF_F_SG | NETIF_F_TSO |
-					NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-					NETIF_F_RXCSUM;
+		netdev_hw_enc_features_zero(ndev);
+		netdev_hw_enc_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_IPV6_CSUM_BIT,
+					       NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+					       NETIF_F_TSO_ECN_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_RXCSUM_BIT);
 	}
 
 	if (udp_tunnel_enable) {
-		hw_features |= (NETIF_F_GSO_UDP_TUNNEL |
-				NETIF_F_GSO_UDP_TUNNEL_CSUM);
-		ndev->hw_enc_features |= (NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_GSO_UDP_TUNNEL_CSUM);
+		netdev_features_set_set(hw_features, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+		netdev_hw_enc_features_set_set(ndev, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 		qede_set_udp_tunnels(edev);
 	}
 
 	if (edev->dev_info.common.gre_enable) {
-		hw_features |= (NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM);
-		ndev->hw_enc_features |= (NETIF_F_GSO_GRE |
-					  NETIF_F_GSO_GRE_CSUM);
-	}
-
-	ndev->vlan_features = hw_features | NETIF_F_RXHASH | NETIF_F_RXCSUM |
-			      NETIF_F_HIGHDMA;
-	ndev->features = hw_features | NETIF_F_RXHASH | NETIF_F_RXCSUM |
-			 NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA |
-			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_features_set_set(hw_features, NETIF_F_GSO_GRE_BIT,
+					NETIF_F_GSO_GRE_CSUM_BIT);
+		netdev_hw_enc_features_set_set(ndev, NETIF_F_GSO_GRE_BIT,
+					       NETIF_F_GSO_GRE_CSUM_BIT);
+	}
+
+	ndev->vlan_features = hw_features;
+	netdev_vlan_features_set_set(ndev, NETIF_F_RXHASH_BIT,
+				     NETIF_F_RXCSUM_BIT, NETIF_F_HIGHDMA_BIT);
+	ndev->features = hw_features;
+	netdev_active_features_set_set(ndev, NETIF_F_RXHASH_BIT,
+				       NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
 	ndev->hw_features = hw_features;
 
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 31e3ab149727..5777ca67a327 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -26,6 +26,7 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
@@ -3796,7 +3797,8 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 
 	ndev->features |= NETIF_F_HIGHDMA;
 	if (qdev->device_id == QL3032_DEVICE_ID)
-		ndev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+		netdev_active_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_SG_BIT);
 
 	qdev->mem_map_registers = pci_ioremap_bar(pdev, 1);
 	if (!qdev->mem_map_registers) {
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 4b8bc46f55c2..a68d14f6068f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <net/ip.h>
 #include <linux/bitops.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include "qlcnic.h"
 #include "qlcnic_hdr.h"
@@ -1026,8 +1027,9 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 	u32 offload_flags = adapter->offload_flags;
 
 	if (offload_flags & BIT_0) {
-		features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			    NETIF_F_IPV6_CSUM;
+		netdev_features_set_set(features, NETIF_F_RXCSUM_BIT,
+					NETIF_F_IP_CSUM_BIT,
+					NETIF_F_IPV6_CSUM_BIT);
 		adapter->rx_csum = 1;
 		if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 			if (!(offload_flags & BIT_1))
@@ -1041,9 +1043,9 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 				features |= NETIF_F_TSO6;
 		}
 	} else {
-		features &= ~(NETIF_F_RXCSUM |
-			      NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM);
+		netdev_features_clear_set(features, NETIF_F_RXCSUM_BIT,
+					  NETIF_F_IP_CSUM_BIT,
+					  NETIF_F_IPV6_CSUM_BIT);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
 			features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
@@ -1057,6 +1059,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changeable;
 	netdev_features_t changed;
 
 	if (qlcnic_82xx_check(adapter) &&
@@ -1065,11 +1068,14 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 			features = qlcnic_process_flags(adapter, features);
 		} else {
 			changed = features ^ netdev->features;
-			features ^= changed & (NETIF_F_RXCSUM |
-					       NETIF_F_IP_CSUM |
-					       NETIF_F_IPV6_CSUM |
-					       NETIF_F_TSO |
-					       NETIF_F_TSO6);
+			netdev_features_zero(changeable);
+			netdev_features_set_set(changeable,
+						NETIF_F_RXCSUM_BIT,
+						NETIF_F_IP_CSUM_BIT,
+						NETIF_F_IPV6_CSUM_BIT,
+						NETIF_F_TSO_BIT,
+						NETIF_F_TSO6_BIT);
+			features ^= changed & changeable;
 		}
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 28476b982bab..c118ab110fd5 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -14,6 +14,7 @@
 #include <linux/inetdevice.h>
 #include <linux/aer.h>
 #include <linux/log2.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <net/vxlan.h>
 
@@ -2276,11 +2277,14 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 	netdev->ethtool_ops = (qlcnic_sriov_vf_check(adapter)) ?
 		&qlcnic_sriov_vf_ethtool_ops : &qlcnic_ethtool_ops;
 
-	netdev->features |= (NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-			     NETIF_F_IPV6_CSUM | NETIF_F_GRO |
-			     NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA);
-	netdev->vlan_features |= (NETIF_F_SG | NETIF_F_IP_CSUM |
-				  NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA);
+	netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
+				       NETIF_F_IP_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT, NETIF_F_GRO_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HIGHDMA_BIT);
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT,
+				     NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				     NETIF_F_HIGHDMA_BIT);
 
 	if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 		netdev->features |= (NETIF_F_TSO | NETIF_F_TSO6);
@@ -2300,10 +2304,11 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 		netdev->features |= NETIF_F_GSO_UDP_TUNNEL;
 
 		/* encapsulation Tx offload supported by Adapter */
-		netdev->hw_enc_features = NETIF_F_IP_CSUM        |
-					  NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_TSO            |
-					  NETIF_F_TSO6;
+		netdev_hw_enc_features_zero(netdev);
+		netdev_hw_enc_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT);
 	}
 
 	if (qlcnic_encap_rx_offload(adapter)) {
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index a55c52696d49..986a12eb1d67 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/of_device.h>
@@ -665,13 +666,17 @@ static int emac_probe(struct platform_device *pdev)
 	}
 
 	/* set hw features */
-	netdev->features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
+				       NETIF_F_HW_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	netdev->hw_features = netdev->features;
 
-	netdev->vlan_features |= NETIF_F_SG | NETIF_F_HW_CSUM |
-				 NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT,
+				     NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_TSO6_BIT);
 
 	/* MTU range: 46 - 9194 */
 	netdev->min_mtu = EMAC_MIN_ETH_FRAME_SIZE -
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 1b2119b1d48a..3532f47190bc 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_arp.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/pkt_sched.h>
 #include "rmnet_config.h"
 #include "rmnet_handlers.h"
@@ -261,9 +262,10 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		return -EBUSY;
 	}
 
-	rmnet_dev->hw_features = NETIF_F_RXCSUM;
-	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	rmnet_dev->hw_features |= NETIF_F_SG;
+	netdev_hw_features_zero(rmnet_dev);
+	netdev_hw_features_set_set(rmnet_dev, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				   NETIF_F_SG_BIT);
 
 	priv->real_dev = real_dev;
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index f5786d78ed23..8543fc682d12 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -58,6 +58,7 @@
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -1990,16 +1991,20 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &cp_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_TSO_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	if (pci_using_dac)
 		dev->features |= NETIF_F_HIGHDMA;
 
-	dev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HIGHDMA;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				     NETIF_F_TSO_BIT, NETIF_F_HIGHDMA_BIT);
 
 	/* MTU range: 60 - 4096 */
 	dev->min_mtu = CP_MIN_MTU;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index ab424b5b4920..8c7b6b80dbd9 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -102,6 +102,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/delay.h>
@@ -1008,7 +1009,8 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	 * through the use of skb_copy_and_csum_dev we enable these
 	 * features
 	 */
-	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_HIGHDMA_BIT);
 	dev->vlan_features = dev->features;
 
 	dev->hw_features |= NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f6f63ba6593a..e44a553398f2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -5239,9 +5240,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_vlan_features_zero(dev);
+	netdev_vlan_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				     NETIF_F_TSO_BIT);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/*
@@ -5267,7 +5272,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
-		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
+		netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
+					   NETIF_F_TSO_BIT);
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V1);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V1);
 	}
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 9e7b62750bb0..dd21b60ec33c 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -15,6 +15,7 @@
 #include <linux/sort.h>
 #include <linux/random.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
 #include <linux/etherdevice.h>
@@ -2578,7 +2579,8 @@ static int rocker_probe_port(struct rocker *rocker, unsigned int port_number)
 		       NAPI_POLL_WEIGHT);
 	rocker_carrier_init(rocker_port);
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_SG;
+	netdev_active_features_set_set(dev, NETIF_F_NETNS_LOCAL_BIT,
+				       NETIF_F_SG_BIT);
 
 	/* MTU range: 68 - 9000 */
 	dev->min_mtu = ROCKER_PORT_MIN_MTU;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index a1c10b61269b..37428e2d4f3d 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/prefetch.h>
@@ -2105,9 +2106,11 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 
 	ndev->netdev_ops = &sxgbe_netdev_ops;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_RXCSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_GRO;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_GRO_BIT);
 	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index ee734b69150f..74f3af39f132 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1356,8 +1356,12 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+		netdev_features_zero(encap_tso_features);
+		netdev_features_set_set(encap_tso_features,
+					NETIF_F_GSO_UDP_TUNNEL_BIT,
+					NETIF_F_GSO_GRE_BIT,
+					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					NETIF_F_GSO_GRE_CSUM_BIT);
 
 		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
 		efx->net_dev->features |= encap_tso_features;
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 17b9d37218cb..7568230083e8 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -370,8 +370,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	net_dev->features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 	net_dev->hw_enc_features |= efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
-				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT);
 	netif_set_tso_max_segs(net_dev,
 			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
 	efx->mdio.dev = net_dev;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 8061efdaf82c..2c8ecb2fdf98 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -188,10 +188,15 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
 		struct net_device *net_dev = efx->net_dev;
-		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
-					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
-
+		netdev_features_t tso;
+
+		netdev_features_zero(tso);
+		netdev_features_set_set(tso, NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+					NETIF_F_GSO_PARTIAL_BIT,
+					NETIF_F_GSO_UDP_TUNNEL_BIT,
+					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					NETIF_F_GSO_GRE_BIT,
+					NETIF_F_GSO_GRE_CSUM_BIT);
 		net_dev->features |= tso;
 		net_dev->hw_features |= tso;
 		net_dev->hw_enc_features |= tso;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 054d5ce6029e..b16c6aeb9c38 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1001,17 +1001,19 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
+	net_dev->features |= efx->type->offload_features;
+	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
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
+	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
+				     NETIF_F_RXCSUM_BIT);
 
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f18418e07eb8..0a07a52fe180 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2901,9 +2901,9 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_RXCSUM);
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_RXCSUM);
-
+	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
+				     NETIF_F_RXCSUM_BIT);
 	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
 
 	/* Disable VLAN filtering by default.  It may be enforced if
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a2c7139f2b32..e876ac952cbc 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -26,6 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/busy_poll.h>
 
 #include "enum.h"
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 7ef823d7a89a..0f49fe683008 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -25,6 +25,7 @@
 #include <linux/rwsem.h>
 #include <linux/vmalloc.h>
 #include <linux/mtd/mtd.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/busy_poll.h>
 #include <net/xdp.h>
 
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 60e5b7c8ccf9..ef3c5d16c4f5 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/notifier.h>
@@ -983,17 +984,19 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
+	net_dev->features |= efx->type->offload_features;
+	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
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
+	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
+				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
+				     NETIF_F_RXCSUM_BIT);
 
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 8fc3f5272fa7..de799075704a 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -926,8 +926,12 @@ static int ioc3eth_probe(struct platform_device *pdev)
 	dev->watchdog_timeo	= 5 * HZ;
 	dev->netdev_ops		= &ioc3_netdev_ops;
 	dev->ethtool_ops	= &ioc3_ethtool_ops;
-	dev->hw_features	= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
-	dev->features		= NETIF_F_IP_CSUM | NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT);
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_HIGHDMA_BIT);
 
 	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
 	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index ff4197f5e46d..b26446e85965 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -1437,8 +1438,10 @@ static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	/* faked with skb_copy_and_csum_dev */
-	dev->features = NETIF_F_SG | NETIF_F_HIGHDMA |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT);
 
 	dev->netdev_ops		= &sc92031_netdev_ops;
 	dev->watchdog_timeo	= TX_TIMEOUT;
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 85e62f5489b6..af4fc0b60a7e 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -10,6 +10,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netlink.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
@@ -2098,8 +2099,10 @@ static int netsec_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &netsec_netdev_ops;
 	ndev->ethtool_ops = &netsec_ethtool_ops;
 
-	ndev->features |= NETIF_F_HIGHDMA | NETIF_F_RXCSUM | NETIF_F_GSO |
-				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_active_features_set_set(ndev, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_RXCSUM_BIT, NETIF_F_GSO_BIT,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT);
 	ndev->hw_features = ndev->features;
 
 	priv->rx_cksum_offload_flag = true;
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index ee341a383e69..e17193624604 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -15,6 +15,7 @@
 #include <linux/mii.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
@@ -1594,8 +1595,10 @@ static int ave_probe(struct platform_device *pdev)
 	ndev->ethtool_ops = &ave_ethtool_ops;
 	SET_NETDEV_DEV(ndev, dev);
 
-	ndev->features    |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);
-	ndev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);
+	netdev_active_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_RXCSUM_BIT);
+	netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT);
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8418e795cc21..f4e7007e1f0c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -35,6 +35,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #endif /* CONFIG_DEBUG_FS */
+#include <linux/netdev_feature_helpers.h>
 #include <linux/net_tstamp.h>
 #include <linux/phylink.h>
 #include <linux/udp.h>
@@ -7117,8 +7118,9 @@ int stmmac_dvr_probe(struct device *device,
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_RXCSUM;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT);
 
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 19a3eb6efc3a..0f5a60bb69fa 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -71,6 +71,7 @@
 #include <linux/dma-mapping.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -5057,7 +5058,8 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Cassini features. */
 	if ((cp->cas_flags & CAS_FLAG_NO_HW_CSUM) == 0)
-		dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		netdev_active_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
+					       NETIF_F_SG_BIT);
 
 	dev->features |= NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index bc51a75a0e19..eaf2b6d8c187 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -246,7 +246,8 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 	dev->ethtool_ops = &vsw_ethtool_ops;
 	dev->watchdog_timeo = VSW_TX_TIMEOUT;
 
-	dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_HW_CSUM_BIT, NETIF_F_SG_BIT);
 	dev->features = dev->hw_features;
 
 	/* MTU range: 68 - 65535 */
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 204a29e72292..1b4d6b2f57ec 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
@@ -9735,7 +9736,9 @@ static void niu_device_announce(struct niu *np)
 
 static void niu_set_basic_features(struct net_device *dev)
 {
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXHASH;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_RXHASH_BIT);
 	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
 }
 
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 6fb89c55f957..443537075d55 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/mii.h>
@@ -2989,7 +2990,9 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, dev);
 
 	/* We can do scatter/gather and HW checksum */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT);
 	dev->features = dev->hw_features;
 	if (pci_using_dac)
 		dev->features |= NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1921054b7f7d..fd99c2e677b1 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -31,6 +31,7 @@
 #include <linux/random.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/mm.h>
@@ -2784,7 +2785,8 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT);
 	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
 
 	hp->irq = op->archdata.irqs[0];
@@ -3104,7 +3106,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT);
 	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 042b50227850..469a1f9cc2fc 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -314,8 +314,9 @@ static struct vnet *vnet_new(const u64 *local_mac,
 	dev->ethtool_ops = &vnet_ethtool_ops;
 	dev->watchdog_timeo = VNET_TX_TIMEOUT;
 
-	dev->hw_features = NETIF_F_TSO | NETIF_F_GSO | NETIF_F_ALL_TSO |
-			   NETIF_F_HW_CSUM | NETIF_F_SG;
+	dev->hw_features = NETIF_F_ALL_TSO;
+	netdev_hw_features_set_set(dev, NETIF_F_TSO_BIT, NETIF_F_GSO_BIT,
+				   NETIF_F_HW_CSUM_BIT, NETIF_F_SG_BIT);
 	dev->features = dev->hw_features;
 
 	/* MTU range: 68 - 65535 */
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 08ba658db987..b0dee4f3f23f 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1976,13 +1976,19 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* these fields are used for info purposes only
 		 * so we can have them same for all ports of the board */
 		ndev->if_port = port;
-		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO |
-		    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM |
-		    NETIF_F_HIGHDMA;
-
-		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_active_features_zero(ndev);
+		netdev_active_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					       NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+					       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_HIGHDMA_BIT);
+
+		netdev_hw_features_zero(ndev);
+		netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
+					   NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
 	/************** priv ****************/
 		priv = nic->priv[port] = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/tehuti/tehuti.h b/drivers/net/ethernet/tehuti/tehuti.h
index 909e7296cecf..c1f70f9b0786 100644
--- a/drivers/net/ethernet/tehuti/tehuti.h
+++ b/drivers/net/ethernet/tehuti/tehuti.h
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 7ef5d8208a4e..728aaba3fef2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -14,6 +14,7 @@
 #include <linux/kmemleak.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/net_tstamp.h>
 #include <linux/of.h>
 #include <linux/of_mdio.h>
@@ -1977,10 +1978,10 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
 	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
-	port->ndev->hw_features = NETIF_F_SG |
-				  NETIF_F_RXCSUM |
-				  NETIF_F_HW_CSUM |
-				  NETIF_F_HW_TC;
+	netdev_hw_features_zero(port->ndev);
+	netdev_hw_features_set_set(port->ndev, NETIF_F_SG_BIT,
+				   NETIF_F_RXCSUM_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_HW_TC_BIT);
 	port->ndev->features = port->ndev->hw_features |
 			       NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 312250c642bb..de8b0529b2bd 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -17,6 +17,7 @@
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
@@ -1456,7 +1457,8 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	priv_sl2->emac_port = 1;
 	cpsw->slaves[1].ndev = ndev;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_features_set_set(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
@@ -1633,7 +1635,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	cpsw->slaves[0].ndev = ndev;
 
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_features_set_set(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 007de15179f0..70f9dcf2d572 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
@@ -1403,9 +1404,11 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 
 		cpsw->slaves[i].ndev = ndev;
 
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
-
+		netdev_active_features_set_set(ndev,
+					       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       NETIF_F_NETNS_LOCAL_BIT,
+					       NETIF_F_HW_TC_BIT);
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 6e838e8f79d0..9e9eb2f4efda 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1461,7 +1461,9 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	int status;
 	u64 v1, v2;
 
-	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT);
 
 	netdev->features = NETIF_F_IP_CSUM;
 	if (GELIC_CARD_RX_CSUM_DEFAULT)
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index bc4914c758ad..0d02fc2cdfff 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2275,10 +2275,13 @@ spider_net_setup_netdev(struct spider_net_card *card)
 
 	spider_net_setup_netdev_ops(netdev);
 
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_IP_CSUM_BIT);
 	if (SPIDER_NET_RX_CSUM_DEFAULT)
 		netdev->features |= NETIF_F_RXCSUM;
-	netdev->features |= NETIF_F_IP_CSUM | NETIF_F_LLTX;
+	netdev_active_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_LLTX_BIT);
 	/* some time: NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 	 *		NETIF_F_HW_VLAN_CTAG_FILTER
 	 */
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 29cde0bec4b1..5c94afc768b2 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -99,6 +99,7 @@ static const int multicast_filter_limit = 32;
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
@@ -968,7 +969,8 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 	netif_napi_add(dev, &rp->napi, rhine_napipoll, 64);
 
 	if (rp->quirks & rqRhineI)
-		dev->features |= NETIF_F_SG|NETIF_F_HW_CSUM;
+		netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+					       NETIF_F_HW_CSUM_BIT);
 
 	if (rp->quirks & rqMgmt)
 		dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 5d710ebb9680..558a520376bc 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -45,6 +45,7 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
@@ -2848,11 +2849,13 @@ static int velocity_probe(struct device *dev, int irq,
 	netdev->ethtool_ops = &velocity_ethtool_ops;
 	netif_napi_add(netdev, &vptr->napi, velocity_poll, NAPI_POLL_WEIGHT);
 
-	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-			   NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_IP_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_IP_CSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_active_features_set_set(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_IP_CSUM_BIT);
 
 	/* MTU range: 64 - 9000 */
 	netdev->min_mtu = VELOCITY_MIN_MTU;
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index f393e454f45c..bdf8624995f5 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/hash.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/ipv6_stubs.h>
 #include <net/dst_metadata.h>
 #include <net/gro_cells.h>
@@ -1245,13 +1246,14 @@ static void geneve_setup(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &geneve_type);
 
-	dev->features    |= NETIF_F_LLTX;
-	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features    |= NETIF_F_RXCSUM;
+	netdev_active_features_set_set(dev, NETIF_F_LLTX_BIT,
+				       NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_RXCSUM_BIT);
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
 
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 
 	/* MTU range: 68 - (something less than 65535) */
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 25b38a374e3c..a5f3c033605f 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -873,10 +873,8 @@ struct nvsp_message {
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
 #define NETVSC_SEND_BUFFER_ID			0
 
-#define NETVSC_SUPPORTED_HW_FEATURES (NETIF_F_RXCSUM | NETIF_F_IP_CSUM | \
-				      NETIF_F_TSO | NETIF_F_IPV6_CSUM | \
-				      NETIF_F_TSO6 | NETIF_F_LRO | \
-				      NETIF_F_SG | NETIF_F_RXHASH)
+extern netdev_features_t netvsc_supported_hw_features __ro_after_init;
+#define NETVSC_SUPPORTED_HW_FEATURES netvsc_supported_hw_features
 
 #define VRSS_SEND_TAB_SIZE 16  /* must be power of 2 */
 #define VRSS_CHANNEL_MAX 64
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 5f08482065ca..f438a98cd2f4 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
@@ -52,6 +53,8 @@ static const u32 default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 				NETIF_MSG_IFDOWN | NETIF_MSG_RX_ERR |
 				NETIF_MSG_TX_ERR;
 
+netdev_features_t netvsc_supported_hw_features __ro_after_init;
+
 static int debug = -1;
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
@@ -2533,9 +2536,10 @@ static int netvsc_probe(struct hv_device *dev,
 		schedule_work(&nvdev->subchan_work);
 
 	/* hw_features computed in rndis_netdev_set_hwcaps() */
-	net->features = net->hw_features |
-		NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
+	net->features = net->hw_features;
+	netdev_active_features_set_set(net, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	net->vlan_features = net->features;
 
 	netdev_lockdep_set_classes(net);
@@ -2769,6 +2773,16 @@ static int __init netvsc_drv_init(void)
 	if (ret)
 		return ret;
 
+	netdev_features_set_set(netvsc_supported_hw_features,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_LRO_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_RXHASH_BIT);
+
 	register_netdevice_notifier(&netvsc_netdev_notifier);
 	return 0;
 }
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 1c64d5347b8e..56dcf6677cdf 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -288,11 +289,6 @@ static const struct ethtool_ops ifb_ethtool_ops = {
 	.get_ethtool_stats	= ifb_get_ethtool_stats,
 };
 
-#define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST	| \
-		      NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL	| \
-		      NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX		| \
-		      NETIF_F_HW_VLAN_STAG_TX)
-
 static void ifb_dev_free(struct net_device *dev)
 {
 	struct ifb_dev_private *dp = netdev_priv(dev);
@@ -309,6 +305,8 @@ static void ifb_dev_free(struct net_device *dev)
 
 static void ifb_setup(struct net_device *dev)
 {
+	netdev_features_t ifb_features;
+
 	/* Initialize the device structure. */
 	dev->netdev_ops = &ifb_netdev_ops;
 	dev->ethtool_ops = &ifb_ethtool_ops;
@@ -317,10 +315,16 @@ static void ifb_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->tx_queue_len = TX_Q_LIMIT;
 
-	dev->features |= IFB_FEATURES;
+	ifb_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_set(ifb_features, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT, NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_STAG_TX_BIT);
+	dev->features |= ifb_features;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
-	dev->vlan_features |= IFB_FEATURES & ~(NETIF_F_HW_VLAN_CTAG_TX |
+	dev->vlan_features |= ifb_features & ~(NETIF_F_HW_VLAN_CTAG_TX |
 					       NETIF_F_HW_VLAN_STAG_TX);
 
 	dev->flags |= IFF_NOARP;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 54c94a69c2bb..a4f461ec1374 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -3,9 +3,14 @@
  */
 
 #include <linux/ethtool.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include "ipvlan.h"
 
+static netdev_features_t ipvlan_offload_features __ro_after_init;
+static netdev_features_t ipvlan_always_on_features __ro_after_init;
+static netdev_features_t ipvlan_features __ro_after_init;
+
 static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
 				struct netlink_ext_ack *extack)
 {
@@ -107,20 +112,9 @@ static void ipvlan_port_destroy(struct net_device *dev)
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
-
-	/* NETIF_F_GSO_ENCAP_ALL NETIF_F_GSO_SOFTWARE Newly added */
+#define IPVLAN_FEATURES			ipvlan_features
+#define IPVLAN_ALWAYS_ON_OFLOADS	ipvlan_offload_features
+#define IPVLAN_ALWAYS_ON		ipvlan_always_on_features
 
 #define IPVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
@@ -1018,6 +1012,31 @@ static struct notifier_block ipvlan_addr6_vtor_notifier_block __read_mostly = {
 };
 #endif
 
+static void __init ipvlan_features_init(void)
+{
+	/* NETIF_F_GSO_ENCAP_ALL NETIF_F_GSO_SOFTWARE Newly added */
+	ipvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_set(ipvlan_offload_features,
+				NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_GSO_ROBUST_BIT);
+
+	ipvlan_always_on_features = ipvlan_offload_features;
+	netdev_features_set_set(ipvlan_always_on_features, NETIF_F_LLTX_BIT,
+				NETIF_F_VLAN_CHALLENGED_BIT);
+
+	ipvlan_features = NETIF_F_ALL_TSO;
+	netdev_features_set_set(ipvlan_features, NETIF_F_SG_BIT,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_GSO_BIT,
+				NETIF_F_GSO_ROBUST_BIT,
+				NETIF_F_GRO_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+}
+
 static int __init ipvlan_init_module(void)
 {
 	int err;
@@ -1042,6 +1061,8 @@ static int __init ipvlan_init_module(void)
 		goto error;
 	}
 
+	ipvlan_features_init();
+
 	return 0;
 error:
 	unregister_inetaddr_notifier(&ipvlan_addr4_notifier_block);
diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index cbabca167a07..ba2730ba5c1f 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -18,15 +18,13 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 #include <linux/virtio_net.h>
 
-#define TUN_OFFLOADS (NETIF_F_HW_CSUM | NETIF_F_TSO_ECN | NETIF_F_TSO | \
-		      NETIF_F_TSO6)
-
 static dev_t ipvtap_major;
 static struct cdev ipvtap_cdev;
 
@@ -86,7 +84,10 @@ static int ipvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	vlantap->tap.tap_features = TUN_OFFLOADS;
+	netdev_features_zero(vlantap->tap.tap_features);
+	netdev_features_set_set(vlantap->tap.tap_features,
+				NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_ECN_BIT,
+				NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 	vlantap->tap.count_tx_dropped = ipvtap_count_tx_dropped;
 	vlantap->tap.update_features =	ipvtap_update_features;
 	vlantap->tap.count_rx_dropped = ipvtap_count_rx_dropped;
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 14e8d04cb434..f5f5cbb29766 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -41,6 +41,7 @@
 
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -176,16 +177,15 @@ static void gen_lo_setup(struct net_device *dev,
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
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_HW_CSUM_BIT, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_SCTP_CRC_BIT,
+				       NETIF_F_HIGHDMA_BIT, NETIF_F_LLTX_BIT,
+				       NETIF_F_NETNS_LOCAL_BIT,
+				       NETIF_F_VLAN_CHALLENGED_BIT,
+				       NETIF_F_LOOPBACK_BIT);
 	dev->ethtool_ops	= eth_ops;
 	dev->header_ops		= hdr_ops;
 	dev->netdev_ops		= dev_ops;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 830fed3914b6..299879133317 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -12,6 +12,7 @@
 #include <crypto/aead.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/rtnetlink.h>
 #include <linux/refcount.h>
 #include <net/genetlink.h>
@@ -3446,15 +3447,16 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-#define SW_MACSEC_FEATURES \
-	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
+static netdev_features_t macsec_no_inherit_features __ro_after_init;
+static netdev_features_t sw_macsec_features __ro_after_init;
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
@@ -4391,6 +4393,15 @@ static struct notifier_block macsec_notifier = {
 	.notifier_call = macsec_notify,
 };
 
+static void __init macsec_features_init(void)
+{
+	netdev_features_set_set(sw_macsec_features, NETIF_F_SG_BIT,
+				NETIF_F_HIGHDMA_BIT, NETIF_F_FRAGLIST_BIT);
+
+	macsec_no_inherit_features = NETIF_F_VLAN_FEATURES;
+	macsec_no_inherit_features |= NETIF_F_HW_MACSEC;
+}
+
 static int __init macsec_init(void)
 {
 	int err;
@@ -4408,6 +4419,8 @@ static int __init macsec_init(void)
 	if (err)
 		goto rtnl;
 
+	macsec_features_init();
+
 	return 0;
 
 rtnl:
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 713e3354cb2e..fa20b4b2ff0a 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -19,6 +19,7 @@
 #include <linux/rculist.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
 
@@ -868,17 +873,9 @@ static int macvlan_eth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
+#define MACVLAN_FEATURES	macvlan_features
+#define ALWAYS_ON_OFFLOADS	macvlan_offload_features
+#define ALWAYS_ON_FEATURES	macvlan_always_on_features
 
 #define MACVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
@@ -1813,6 +1810,33 @@ static struct notifier_block macvlan_notifier_block __read_mostly = {
 	.notifier_call	= macvlan_device_event,
 };
 
+static void __init macvlan_features_init(void)
+{
+	macvlan_offload_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_set(macvlan_offload_features,
+				NETIF_F_SG_BIT,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_GSO_ROBUST_BIT);
+
+	macvlan_always_on_features = macvlan_offload_features;
+	netdev_features_set_set(macvlan_always_on_features, NETIF_F_LLTX_BIT);
+
+	netdev_features_set_set(macvlan_features,
+				NETIF_F_SG_BIT,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_GSO_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_LRO_BIT,
+				NETIF_F_TSO_ECN_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_GRO_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+}
+
 static int __init macvlan_init_module(void)
 {
 	int err;
@@ -1822,6 +1846,8 @@ static int __init macvlan_init_module(void)
 	err = macvlan_link_register(&macvlan_link_ops);
 	if (err < 0)
 		goto err1;
+
+	macvlan_features_init();
 	return 0;
 err1:
 	unregister_netdevice_notifier(&macvlan_notifier_block);
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index cecf8c63096c..14f75986f4c4 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -18,6 +18,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
@@ -49,9 +50,6 @@ static struct class macvtap_class = {
 };
 static struct cdev macvtap_cdev;
 
-#define TUN_OFFLOADS (NETIF_F_HW_CSUM | NETIF_F_TSO_ECN | NETIF_F_TSO | \
-		      NETIF_F_TSO6)
-
 static void macvtap_count_tx_dropped(struct tap_dev *tap)
 {
 	struct macvtap_dev *vlantap = container_of(tap, struct macvtap_dev, tap);
@@ -90,7 +88,10 @@ static int macvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	vlantap->tap.tap_features = TUN_OFFLOADS;
+	netdev_features_zero(vlantap->tap.tap_features);
+	netdev_features_set_set(vlantap->tap.tap_features,
+				NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_ECN_BIT,
+				NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 
 	/* Register callbacks for rx/tx drops accounting and updating
 	 * net_device features
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 7a28e082436e..9adc0cbce2a8 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/module.h>
@@ -27,6 +28,9 @@
 #include <uapi/linux/if_arp.h>
 #include <net/net_failover.h>
 
+static netdev_features_t failover_vlan_features __ro_after_init;
+static netdev_features_t failover_enc_features __ro_after_init;
+
 static bool net_failover_xmit_ready(struct net_device *dev)
 {
 	return netif_running(dev) && netif_carrier_ok(dev);
@@ -823,9 +827,24 @@ void net_failover_destroy(struct failover *failover)
 }
 EXPORT_SYMBOL_GPL(net_failover_destroy);
 
+static __init void net_failover_features_init(void)
+{
+	netdev_features_set_set(failover_vlan_features,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_LRO_BIT);
+	netdev_features_set_set(failover_enc_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_RXCSUM_BIT);
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
index 386336a38f34..10677f52f131 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -276,12 +276,12 @@ void nsim_ipsec_init(struct netdevsim *ns)
 {
 	ns->netdev->xfrmdev_ops = &nsim_xfrmdev_ops;
 
-#define NSIM_ESP_FEATURES	(NETIF_F_HW_ESP | \
-				 NETIF_F_HW_ESP_TX_CSUM | \
-				 NETIF_F_GSO_ESP)
-
-	ns->netdev->features |= NSIM_ESP_FEATURES;
-	ns->netdev->hw_enc_features |= NSIM_ESP_FEATURES;
+	netdev_active_features_set_set(ns->netdev, NETIF_F_HW_ESP_BIT,
+				       NETIF_F_HW_ESP_TX_CSUM_BIT,
+				       NETIF_F_GSO_ESP_BIT);
+	netdev_hw_enc_features_set_set(ns->netdev, NETIF_F_HW_ESP_BIT,
+				       NETIF_F_HW_ESP_TX_CSUM_BIT,
+				       NETIF_F_GSO_ESP_BIT);
 
 	ns->ipsec.pfile = debugfs_create_file("ipsec", 0400,
 					      ns->nsim_dev_port->ddir, ns,
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 9a1a5b203624..2fdfb4e6ba23 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/slab.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -288,11 +289,9 @@ static void nsim_setup(struct net_device *dev)
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE |
 			   IFF_NO_QUEUE;
-	dev->features |= NETIF_F_HIGHDMA |
-			 NETIF_F_SG |
-			 NETIF_F_FRAGLIST |
-			 NETIF_F_HW_CSUM |
-			 NETIF_F_TSO;
+	netdev_active_features_set_set(dev, NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_SG_BIT, NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT);
 	dev->hw_features |= NETIF_F_HW_TC;
 	dev->max_mtu = ETH_MAX_MTU;
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7d8ed8d8df5c..9a33a10e1dd9 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/u64_stats_sync.h>
 #include <net/devlink.h>
 #include <net/udp_tunnel.h>
diff --git a/drivers/net/nlmon.c b/drivers/net/nlmon.c
index 5e19a6839dea..189651736277 100644
--- a/drivers/net/nlmon.c
+++ b/drivers/net/nlmon.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netlink.h>
 #include <net/net_namespace.h>
 #include <linux/if_arp.h>
@@ -89,8 +90,11 @@ static void nlmon_setup(struct net_device *dev)
 	dev->ethtool_ops = &nlmon_ethtool_ops;
 	dev->needs_free_netdev = true;
 
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			NETIF_F_HIGHDMA | NETIF_F_LLTX;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_LLTX_BIT);
 	dev->flags = IFF_NOARP;
 
 	/* That's rather a softlimit here, which, of course,
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 9e75ed3f08ce..c82465160e4d 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -17,6 +17,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
@@ -116,9 +117,6 @@ struct major_info {
 
 static const struct proto_ops tap_socket_ops;
 
-#define RX_OFFLOADS (NETIF_F_GRO | NETIF_F_LRO)
-#define TAP_FEATURES (NETIF_F_GSO | NETIF_F_SG | NETIF_F_FRAGLIST)
-
 static struct tap_dev *tap_dev_get_rcu(const struct net_device *dev)
 {
 	return rcu_dereference(dev->rx_handler_data);
@@ -321,7 +319,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct net_device *dev = skb->dev;
 	struct tap_dev *tap;
 	struct tap_queue *q;
-	netdev_features_t features = TAP_FEATURES;
+	netdev_features_t features;
 	enum skb_drop_reason drop_reason;
 
 	tap = tap_dev_get_rcu(dev);
@@ -334,6 +332,9 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 
 	skb_push(skb, ETH_HLEN);
 
+	netdev_features_zero(features);
+	netdev_features_set_set(features, NETIF_F_GSO_BIT, NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT);
 	/* Apply the forward feature mask so that we perform segmentation
 	 * according to users wishes.  This only works if VNET_HDR is
 	 * enabled.
@@ -968,9 +969,11 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * user-space will not receive TSO frames.
 	 */
 	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
-		features |= RX_OFFLOADS;
+		netdev_features_set_set(features, NETIF_F_GRO_BIT,
+					NETIF_F_LRO_BIT);
 	else
-		features &= ~RX_OFFLOADS;
+		netdev_features_clear_set(features, NETIF_F_GRO_BIT,
+					  NETIF_F_LRO_BIT);
 
 	/* tap_features are the same as features on tun/tap and
 	 * reflect user expectations.
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index ab92416d861f..fa0fb4d074e7 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netpoll.h>
 #include <linux/if_vlan.h>
 #include <linux/if_arp.h>
@@ -980,12 +981,10 @@ static void team_port_disable(struct team *team,
 	team_lower_state_changed(port);
 }
 
-#define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
-			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-			    NETIF_F_HIGHDMA | NETIF_F_LRO)
-
-#define TEAM_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
+static netdev_features_t team_vlan_features __ro_after_init;
+static netdev_features_t team_enc_features __ro_after_init;
+#define TEAM_VLAN_FEATURES	team_vlan_features
+#define TEAM_ENC_FEATURES	team_enc_features
 
 static void __team_compute_features(struct team *team)
 {
@@ -2876,6 +2875,19 @@ static void team_nl_fini(void)
 	genl_unregister_family(&team_nl_family);
 }
 
+static void __init team_features_init(void)
+{
+	team_vlan_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(team_vlan_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_LRO_BIT);
+	team_enc_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(team_enc_features, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT);
+}
 
 /******************
  * Change checkers
@@ -3051,6 +3063,8 @@ static int __init team_module_init(void)
 	if (err)
 		goto err_nl_init;
 
+	team_features_init();
+
 	return 0;
 
 err_nl_init:
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index c058eabd7b36..b3842ff71c75 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -15,6 +15,7 @@
 #include <linux/jhash.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/rtnetlink.h>
 #include <linux/sizes.h>
 #include <linux/thunderbolt.h>
@@ -1277,8 +1278,11 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	 * we need to announce support for most of the offloading
 	 * features here.
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_ALL_TSO | NETIF_F_GRO |
-			   NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	dev->hw_features = NETIF_F_ALL_TSO;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
+				   NETIF_F_GRO_BIT,
+				   NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT);
 	dev->features = dev->hw_features | NETIF_F_HIGHDMA;
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3732e51b5ad8..be2d41f0c10d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/miscdevice.h>
 #include <linux/ethtool.h>
@@ -171,6 +172,9 @@ struct tun_prog {
 	struct bpf_prog *prog;
 };
 
+static netdev_features_t tun_user_features __ro_after_init;
+#define TUN_USER_FEATURES	tun_user_features
+
 /* Since the socket were moved to tun_file, to preserve the behavior of persist
  * device, socket filter, sndbuf and vnet header size were restore when the
  * file were attached to a persist device.
@@ -184,8 +188,6 @@ struct tun_struct {
 
 	struct net_device	*dev;
 	netdev_features_t	set_features;
-#define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
-			  NETIF_F_TSO6)
 
 	int			align;
 	int			vnet_hdr_sz;
@@ -989,9 +991,11 @@ static int tun_net_init(struct net_device *dev)
 
 	tun_flow_init(tun);
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->hw_features = TUN_USER_FEATURES;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
+				   NETIF_F_FRAGLIST_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_STAG_TX_BIT);
 	dev->features = dev->hw_features | NETIF_F_LLTX;
 	dev->vlan_features = dev->features &
 			     ~(NETIF_F_HW_VLAN_CTAG_TX |
@@ -3692,6 +3696,10 @@ static int __init tun_init(void)
 		goto err_notifier;
 	}
 
+	netdev_features_set_set(tun_user_features, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_TSO_ECN_BIT, NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT);
+
 	return  0;
 
 err_notifier:
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index a017e9de2119..bf6d429b31f2 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
index aff39bf3161d..ac430e2d19b4 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -13,6 +13,7 @@
 #include <linux/usb/usbnet.h>
 #include <uapi/linux/mdio.h>
 #include <linux/mdio.h>
+#include <linux/netdev_feature_helpers.h>
 
 #define AX88179_PHY_ID				0x03
 #define AX_EEPROM_LEN				0x100
@@ -1291,8 +1292,11 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id = 0x03;
 	dev->mii.supports_gmii = 1;
 
-	dev->net->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | NETIF_F_TSO;
+	netdev_active_features_set_set(dev->net, NETIF_F_SG_BIT,
+				       NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_IPV6_CSUM_BIT,
+				       NETIF_F_RXCSUM_BIT,
+				       NETIF_F_TSO_BIT);
 
 	dev->net->hw_features |= dev->net->features;
 
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c89639381eca..22d425731938 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
@@ -185,7 +186,8 @@ static int cdc_mbim_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->flags |= IFF_NOARP;
 
 	/* no need to put the VLAN tci in the packet headers */
-	dev->net->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_features_set_set(dev->net, NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	/* monitor VLAN additions and removals */
 	dev->net->netdev_ops = &cdc_mbim_netdev_ops;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3226ab33afae..381799e045e1 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -25,6 +25,7 @@
 #include <linux/irq.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/microchipphy.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/phy_fixed.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
@@ -3465,7 +3466,9 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 		dev->net->features |= NETIF_F_RXCSUM;
 
 	if (DEFAULT_TSO_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_SG;
+		netdev_active_features_set_set(dev->net, NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_SG_BIT);
 
 	if (DEFAULT_VLAN_RX_OFFLOAD)
 		dev->net->features |= NETIF_F_HW_VLAN_CTAG_RX;
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a51d8ded60f3..b64ac07157df 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
@@ -2109,7 +2110,9 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
 
-		features &= ~(NETIF_F_SG | NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
+		netdev_features_clear_set(features, NETIF_F_SG_BIT,
+					  NETIF_F_IPV6_CSUM_BIT,
+					  NETIF_F_TSO6_BIT);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR(segs) || !segs)
 			goto drop;
@@ -9667,17 +9670,24 @@ static int rtl8152_probe(struct usb_interface *intf,
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
+	netdev_active_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_IP_CSUM_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_TSO_BIT, NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO6_BIT,
+				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_IP_CSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_FRAGLIST_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_vlan_features_zero(netdev);
+	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT,
+				     NETIF_F_IP_CSUM_BIT, NETIF_F_TSO_BIT,
+				     NETIF_F_HIGHDMA_BIT, NETIF_F_FRAGLIST_BIT,
+				     NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO6_BIT);
 
 	if (tp->version == RTL_VER_01) {
 		netdev->features &= ~NETIF_F_RXCSUM;
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 95de452ff4da..d598ef577c47 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -1478,8 +1479,9 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
 
-	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev->net);
+	netdev_hw_features_set_set(dev->net, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT);
 
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bfb58c91db04..47dd1651f49d 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -1085,7 +1086,9 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
 
-	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev->net);
+	netdev_hw_features_set_set(dev->net, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT);
 	set_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 
 	smsc95xx_init_mac_address(dev);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 550c85a366a0..bb88eb1d465a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/slab.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
@@ -1616,14 +1617,10 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_get_peer_dev	= veth_peer_dev,
 };
 
-#define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
-		       NETIF_F_RXCSUM | NETIF_F_SCTP_CRC | NETIF_F_HIGHDMA | \
-		       NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL | \
-		       NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX | \
-		       NETIF_F_HW_VLAN_STAG_TX | NETIF_F_HW_VLAN_STAG_RX )
-
 static void veth_setup(struct net_device *dev)
 {
+	netdev_features_t veth_features;
+
 	ether_setup(dev);
 
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
@@ -1633,8 +1630,17 @@ static void veth_setup(struct net_device *dev)
 
 	dev->netdev_ops = &veth_netdev_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
+	veth_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_features_set_set(veth_features, NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT, NETIF_F_SCTP_CRC_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_STAG_TX_BIT,
+				NETIF_F_HW_VLAN_STAG_RX_BIT);
 	dev->features |= NETIF_F_LLTX;
-	dev->features |= VETH_FEATURES;
+	dev->features |= veth_features;
 	dev->vlan_features = dev->features &
 			     ~(NETIF_F_HW_VLAN_CTAG_TX |
 			       NETIF_F_HW_VLAN_STAG_TX |
@@ -1644,8 +1650,8 @@ static void veth_setup(struct net_device *dev)
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	dev->hw_features = VETH_FEATURES;
-	dev->hw_enc_features = VETH_FEATURES;
+	dev->hw_features = veth_features;
+	dev->hw_enc_features = veth_features;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e0e57083d442..0ec2e7d1d757 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5,6 +5,7 @@
  */
 //#define DEBUG
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/module.h>
@@ -3719,10 +3720,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 	/* Do we support "hardware" checksums? */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
 		/* This opens up the world of extra features. */
-		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		netdev_hw_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
+					   NETIF_F_SG_BIT);
 		if (csum)
-			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
-
+			netdev_active_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
+						       NETIF_F_SG_BIT);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
 			dev->hw_features |= NETIF_F_TSO
 				| NETIF_F_TSO_ECN | NETIF_F_TSO6;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 53b3b241e027..ea9c6f618ef9 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3301,26 +3301,34 @@ vmxnet3_change_mtu(struct net_device *netdev, int new_mtu)
 	return err;
 }
 
-
 static void
 vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-		NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_LRO | NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT,
+				   NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				   NETIF_F_LRO_BIT, NETIF_F_HIGHDMA_BIT);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				NETIF_F_GSO_UDP_TUNNEL_CSUM;
-
-		netdev->hw_enc_features = NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_features_set_set(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT,
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+		netdev_hw_enc_features_zero(netdev);
+		netdev_hw_enc_features_set_set(netdev,
+					       NETIF_F_SG_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_HW_CSUM_BIT,
+					       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_LRO_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
 
 	if (VMXNET3_VERSION_GE_7(adapter)) {
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 18cf7c723201..7f44673ceb2e 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -303,10 +303,14 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_feat
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_enc_features |= NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO;
+		netdev_hw_enc_features_set_set(netdev, NETIF_F_SG_BIT,
+					       NETIF_F_RXCSUM_BIT,
+					       NETIF_F_HW_CSUM_BIT,
+					       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					       NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       NETIF_F_TSO_BIT,
+					       NETIF_F_TSO6_BIT,
+					       NETIF_F_LRO_BIT);
 		if (features & NETIF_F_GSO_UDP_TUNNEL)
 			netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
 		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
@@ -364,11 +368,16 @@ static void vmxnet3_disable_encap_offloads(struct net_device *netdev)
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_enc_features &= ~(NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM);
+		netdev_hw_enc_features_clear_set(netdev, NETIF_F_SG_BIT,
+						 NETIF_F_RXCSUM_BIT,
+						 NETIF_F_HW_CSUM_BIT,
+						 NETIF_F_HW_VLAN_CTAG_TX_BIT,
+						 NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						 NETIF_F_TSO_BIT,
+						 NETIF_F_TSO6_BIT,
+						 NETIF_F_LRO_BIT,
+						 NETIF_F_GSO_UDP_TUNNEL_BIT,
+						 NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
 	if (VMXNET3_VERSION_GE_7(adapter)) {
 		unsigned long flags;
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 3367db23aa13..82d661d919f6 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -31,6 +31,7 @@
 #include <linux/ethtool.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/compiler.h>
 #include <linux/slab.h>
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index badf6f09ae51..34d6c183931f 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/init.h>
@@ -1688,8 +1689,11 @@ static void vrf_setup(struct net_device *dev)
 
 	/* enable offload features */
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
-	dev->features   |= NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CRC;
-	dev->features   |= NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
+	netdev_active_features_set_set(dev, NETIF_F_RXCSUM_BIT,
+				       NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_SCTP_CRC_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_HIGHDMA_BIT);
 
 	dev->hw_features = dev->features;
 	dev->hw_enc_features = dev->features;
diff --git a/drivers/net/vsockmon.c b/drivers/net/vsockmon.c
index b1bb1b04b664..1eb173aa9ab5 100644
--- a/drivers/net/vsockmon.c
+++ b/drivers/net/vsockmon.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
@@ -106,8 +107,10 @@ static void vsockmon_setup(struct net_device *dev)
 	dev->ethtool_ops = &vsockmon_ethtool_ops;
 	dev->needs_free_netdev = true;
 
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			NETIF_F_HIGHDMA | NETIF_F_LLTX;
+	netdev_active_features_zero(dev);
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_HIGHDMA_BIT, NETIF_F_LLTX_BIT);
 
 	dev->flags = IFF_NOARP;
 
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 6ab669dcd1c6..f8bb383779e1 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -15,6 +15,7 @@
 #include <linux/igmp.h>
 #include <linux/if_ether.h>
 #include <linux/ethtool.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/arp.h>
 #include <net/ndisc.h>
 #include <net/gro.h>
@@ -3162,14 +3163,15 @@ static void vxlan_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &vxlan_type);
 
-	dev->features	|= NETIF_F_LLTX;
-	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features   |= NETIF_F_RXCSUM;
+	netdev_active_features_set_set(dev, NETIF_F_LLTX_BIT, NETIF_F_SG_BIT,
+				       NETIF_F_HW_CSUM_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_RXCSUM_BIT);
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
 
 	dev->vlan_features = dev->features;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	netif_keep_dst(dev);
 	dev->priv_flags |= IFF_NO_QUEUE | IFF_CHANGE_PROTO_DOWN;
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 32831d40d757..87a1675843ce 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -15,6 +15,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/inetdevice.h>
 #include <linux/if_arp.h>
 #include <linux/icmp.h>
@@ -275,11 +276,9 @@ static const struct device_type device_type = { .name = KBUILD_MODNAME };
 static void wg_setup(struct net_device *dev)
 {
 	struct wg_device *wg = netdev_priv(dev);
-	netdev_features_t wg_netdev_features =
-		NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA;
 	const int overhead = MESSAGE_MINIMUM_LENGTH + sizeof(struct udphdr) +
 			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
+	netdev_features_t wg_netdev_features;
 
 	dev->netdev_ops = &netdev_ops;
 	dev->header_ops = &ip_tunnel_header_ops;
@@ -291,6 +290,10 @@ static void wg_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->features |= NETIF_F_LLTX;
+	wg_netdev_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(wg_netdev_features, NETIF_F_HW_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
+				NETIF_F_GSO_BIT, NETIF_F_HIGHDMA_BIT);
 	dev->features |= wg_netdev_features;
 	dev->hw_features |= wg_netdev_features;
 	dev->hw_enc_features |= wg_netdev_features;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 77e052336eb5..75c3d7b6346f 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -19,6 +19,7 @@
 #define CORE_H
 
 #include <linux/etherdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/rtnetlink.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d3aa9e7a37c2..946c8fbae08a 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1305,7 +1305,8 @@ void init_netdev(struct net_device *dev)
 
 	if (!test_bit(ATH6KL_FW_CAPABILITY_NO_IP_CHECKSUM,
 		      ar->fw_capabilities))
-		dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		netdev_hw_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
+					   NETIF_F_RXCSUM_BIT);
 
 	return;
 }
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index e76b38ad1d44..4b61525f5853 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/rtnetlink.h>
 #include "wil6210.h"
 #include "txrx.h"
@@ -335,9 +336,11 @@ wil_vif_alloc(struct wil6210_priv *wil, const char *name,
 	ndev->netdev_ops = &wil_netdev_ops;
 	wil_set_ethtoolops(ndev);
 	ndev->ieee80211_ptr = wdev;
-	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_SG | NETIF_F_GRO |
-			    NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_hw_features_zero(ndev);
+	netdev_hw_features_set_set(ndev, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
+				   NETIF_F_GRO_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT);
 
 	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index f4070fddc8c7..e7d855826bbc 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
@@ -96,8 +97,11 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 
-	if (priv->trans->max_skb_frags)
-		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	if (priv->trans->max_skb_frags) {
+		netdev_features_zero(hw->netdev_features);
+		netdev_features_set_set(hw->netdev_features,
+					NETIF_F_HIGHDMA_BIT, NETIF_F_SG_BIT);
+	}
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FMT;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5eb28f8ee87e..c8d523acec7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/if_arp.h>
@@ -318,8 +319,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->trans->num_rx_queues > 1)
 		ieee80211_hw_set(hw, USES_RSS);
 
-	if (mvm->trans->max_skb_frags)
-		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	if (mvm->trans->max_skb_frags) {
+		netdev_features_zero(hw->netdev_features);
+		netdev_features_set_set(hw->netdev_features,
+					NETIF_F_HIGHDMA_BIT, NETIF_F_SG_BIT);
+	}
 
 	hw->queues = IEEE80211_NUM_ACS;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index fb32ae82d9b0..81a4c99fb60e 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -33,6 +33,7 @@
 #include <linux/kthread.h>
 #include <linux/sched/task.h>
 #include <linux/ethtool.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
@@ -522,9 +523,10 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	INIT_LIST_HEAD(&vif->fe_mcast_addr);
 
 	dev->netdev_ops	= &xenvif_netdev_ops;
-	dev->hw_features = NETIF_F_SG |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_FRAGLIST;
+	netdev_hw_features_zero(dev);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT, NETIF_F_FRAGLIST_BIT);
 	dev->features = dev->hw_features | NETIF_F_RXCSUM;
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 27a11cc08c61..1003233f8cc1 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -1728,11 +1729,14 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	netdev->netdev_ops	= &xennet_netdev_ops;
 
-	netdev->features        = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-				  NETIF_F_GSO_ROBUST;
-	netdev->hw_features	= NETIF_F_SG |
-				  NETIF_F_IPV6_CSUM |
-				  NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_active_features_zero(netdev);
+	netdev_active_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
+				       NETIF_F_RXCSUM_BIT,
+				       NETIF_F_GSO_ROBUST_BIT);
+	netdev_hw_features_zero(netdev);
+	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
+				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
+				   NETIF_F_TSO6_BIT);
 
 	/*
          * Assume that all hw features are available for now. This set
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 8d44bce0477a..430856ad17ea 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1868,10 +1868,14 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 
 		if (!IS_VM_NIC(card)) {
 			card->dev->features |= NETIF_F_SG;
-			card->dev->hw_features |= NETIF_F_TSO |
-				NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
-			card->dev->vlan_features |= NETIF_F_TSO |
-				NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+			netdev_hw_features_set_set(card->dev,
+						   NETIF_F_TSO_BIT,
+						   NETIF_F_RXCSUM_BIT,
+						   NETIF_F_IP_CSUM_BIT);
+			netdev_vlan_features_set_set(card->dev,
+						     NETIF_F_TSO_BIT,
+						    NETIF_F_RXCSUM_BIT,
+						    NETIF_F_IP_CSUM_BIT);
 		}
 
 		if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index f662739137b5..d3d9745d9e64 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/phy.h>
 #include <linux/slab.h>
@@ -422,7 +423,8 @@ int cvm_oct_common_init(struct net_device *dev)
 		priv->queue = -1;
 
 	if (priv->queue != -1)
-		dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM;
+		netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+					       NETIF_F_IP_CSUM_BIT);
 
 	/* We do our own locking, Linux doesn't need to */
 	dev->features |= NETIF_F_LLTX;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ca6b966f5dd3..bf685aee0fbf 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -31,6 +31,7 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
@@ -4567,14 +4568,15 @@ static int qlge_probe(struct pci_dev *pdev,
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
+	netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT,
+				   NETIF_F_IP_CSUM_BIT,
+				   NETIF_F_TSO_BIT,
+				   NETIF_F_TSO_ECN_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   NETIF_F_RXCSUM_BIT);
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = ndev->hw_features;
 	/* vlan gets same features (except vlan filter) */
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 132bf0de1523..7faea4c39bca 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -594,49 +594,49 @@ static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 
 #define __netdev_active_features_set_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_active_features_set_array(ndev, uniq);	\
+	__netdev_features_set_array(&(uniq), &(ndev)->features);	\
 })
 #define netdev_active_features_set_set(ndev, ...)		\
 	__netdev_active_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_hw_features_set_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_hw_features_set_array(ndev, uniq);	\
+	__netdev_features_set_array(&(uniq), &(ndev)->hw_features);	\
 })
 #define netdev_hw_features_set_set(ndev, ...)		\
 	__netdev_hw_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_wanted_features_set_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_wanted_features_set_array(ndev, uniq);	\
+	__netdev_features_set_array(&(uniq), &(ndev)->wanted_features);	\
 })
 #define netdev_wanted_features_set_set(ndev, ...)		\
 	__netdev_wanted_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_vlan_features_set_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_vlan_features_set_array(ndev, uniq);	\
+	__netdev_features_set_array(&(uniq), &(ndev)->vlan_features);	\
 })
 #define netdev_vlan_features_set_set(ndev, ...)		\
 	__netdev_vlan_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_hw_enc_features_set_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_hw_enc_features_set_array(ndev, uniq);	\
+	__netdev_features_set_array(&(uniq), &(ndev)->hw_enc_features);	\
 })
 #define netdev_hw_enc_features_set_set(ndev, ...)		\
 	__netdev_hw_enc_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_mpls_features_set_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_mpls_features_set_array(ndev, uniq);	\
+	__netdev_features_set_array(&(uniq), &(ndev)->mpls_features);	\
 })
 #define netdev_mpls_features_set_set(ndev, ...)		\
 	__netdev_mpls_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_gso_partial_features_set_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_gso_partial_features_set_array(ndev, uniq);	\
+	__netdev_features_set_array(&(uniq), &(ndev)->gso_partial_features);	\
 })
 #define netdev_gso_partial_features_set_set(ndev, ...)		\
 	__netdev_gso_partial_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
@@ -650,49 +650,49 @@ static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 
 #define __netdev_active_features_clear_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_active_features_clear_array(ndev, uniq);	\
+	__netdev_features_clear_array(&(uniq), &(ndev)->features);	\
 })
 #define netdev_active_features_clear_set(ndev, ...)		\
 	__netdev_active_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_hw_features_clear_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_hw_features_clear_array(ndev, uniq);	\
+	__netdev_features_clear_array(&(uniq), &(ndev)->hw_features);	\
 })
 #define netdev_hw_features_clear_set(ndev, ...)		\
 	__netdev_hw_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_wanted_features_clear_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_wanted_features_clear_array(ndev, uniq);	\
+	__netdev_features_clear_array(&(uniq), &(ndev)->wanted_features);	\
 })
 #define netdev_wanted_features_clear_set(ndev, ...)		\
 		__netdev_wanted_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_vlan_features_clear_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_vlan_features_clear_array(ndev, uniq);	\
+	__netdev_features_clear_array(&(uniq), &(ndev)->vlan_features);	\
 })
 #define netdev_vlan_features_clear_set(ndev, ...)		\
 	__netdev_vlan_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_hw_enc_features_clear_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_hw_enc_features_clear_array(ndev, uniq);	\
+	__netdev_features_clear_array(&(uniq), &(ndev)->hw_enc_features);	\
 })
 #define netdev_hw_enc_features_clear_set(ndev, ...)		\
 	__netdev_hw_enc_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_mpls_features_clear_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_mpls_features_clear_array(ndev, uniq);	\
+	__netdev_features_clear_array(&(uniq), &(ndev)->mpls_features);	\
 })
 #define netdev_mpls_features_clear_set(ndev, ...)		\
 	__netdev_mpls_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
 #define __netdev_gso_partial_features_clear_set(ndev, uniq, ...) ({	\
 	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
-	netdev_gso_partial_features_clear_array(ndev, uniq);	\
+	__netdev_features_clear_array(&(uniq), &(ndev)->gso_partial_features);	\
 })
 #define netdev_gso_partial_features_clear_set(ndev, ...)		\
 	__netdev_gso_partial_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
diff --git a/include/net/bonding.h b/include/net/bonding.h
index afd606df149a..ac54b5b6850a 100644
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
index 7940074bdb27..c98828e28e0d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -567,11 +567,13 @@ static int vlan_dev_init(struct net_device *dev)
 	if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 		dev->state |= (1 << __LINK_STATE_NOCARRIER);
 
-	dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG |
-			   NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
-			   NETIF_F_GSO_ENCAP_ALL |
-			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
-			   NETIF_F_ALL_FCOE;
+	dev->hw_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	dev->hw_features |= NETIF_F_ALL_FCOE;
+	netdev_hw_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_SG_BIT,
+				   NETIF_F_FRAGLIST_BIT,
+				   NETIF_F_HIGHDMA_BIT,
+				   NETIF_F_SCTP_CRC_BIT);
 
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 0f5c0679b55a..7d986b56bb08 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netlink.h>
 #include <linux/percpu.h>
 #include <linux/random.h>
@@ -1003,8 +1004,9 @@ static void batadv_softif_init_early(struct net_device *dev)
 	dev->netdev_ops = &batadv_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = batadv_softif_free;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_NETNS_LOCAL;
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       NETIF_F_NETNS_LOCAL_BIT,
+				       NETIF_F_LLTX_BIT);
 	dev->priv_flags |= IFF_NO_QUEUE;
 
 	/* can't call min_mtu, because the needed variables
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index b82906fc999a..aa67b4a1270a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netpoll.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -18,9 +19,6 @@
 #include <linux/uaccess.h>
 #include "br_private.h"
 
-#define COMMON_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA | \
-			 NETIF_F_GSO_MASK | NETIF_F_HW_CSUM)
-
 const struct nf_br_ops __rcu *nf_br_ops __read_mostly;
 EXPORT_SYMBOL_GPL(nf_br_ops);
 
@@ -482,6 +480,7 @@ static struct device_type br_type = {
 void br_dev_setup(struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
+	netdev_features_t common_features;
 
 	eth_hw_addr_random(dev);
 	ether_setup(dev);
@@ -492,11 +491,18 @@ void br_dev_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &br_type);
 	dev->priv_flags = IFF_EBRIDGE | IFF_NO_QUEUE;
 
-	dev->features = COMMON_FEATURES | NETIF_F_LLTX | NETIF_F_NETNS_LOCAL |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
-	dev->hw_features = COMMON_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
+	common_features = NETIF_F_GSO_MASK;
+	netdev_features_set_set(common_features, NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT, NETIF_F_HIGHDMA_BIT,
+				NETIF_F_HW_CSUM_BIT);
+	dev->features = common_features;
+	netdev_active_features_set_set(dev, NETIF_F_LLTX_BIT,
+				       NETIF_F_NETNS_LOCAL_BIT,
+				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       NETIF_F_HW_VLAN_STAG_TX_BIT);
+	dev->hw_features = common_features | NETIF_F_HW_VLAN_CTAG_TX |
 			   NETIF_F_HW_VLAN_STAG_TX;
-	dev->vlan_features = COMMON_FEATURES;
+	dev->vlan_features = common_features;
 
 	br->dev = dev;
 	spin_lock_init(&br->lock);
diff --git a/net/core/dev.c b/net/core/dev.c
index 491130bdbbad..a7da9862540d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10057,7 +10057,8 @@ int register_netdevice(struct net_device *dev)
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG | NETIF_F_GSO_PARTIAL;
+	netdev_hw_enc_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_GSO_PARTIAL_BIT);
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
diff --git a/net/core/sock.c b/net/core/sock.c
index eeb6cbac6f49..377c29ee985e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -102,6 +102,7 @@
 #include <linux/string.h>
 #include <linux/sockios.h>
 #include <linux/net.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
@@ -2380,7 +2381,9 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 		} else {
-			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
+			netdev_features_set_set(sk->sk_route_caps,
+						NETIF_F_SG_BIT,
+						NETIF_F_HW_CSUM_BIT);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
 			sk_trim_gso_size(sk);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 345106b1ed78..5d9d1d83754c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/phylink.h>
@@ -2291,7 +2292,8 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	slave->hw_features |= NETIF_F_HW_TC;
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)
-		slave->features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
+		netdev_active_features_clear_set(slave, NETIF_F_SG_BIT,
+						 NETIF_F_FRAGLIST_BIT);
 	if (ds->needs_standalone_vlan_filtering)
 		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9298eb3251cb..01d3e3478a5d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/bitops.h>
@@ -288,9 +289,6 @@ static int ethtool_set_one_feature(struct net_device *dev,
 
 #define ETH_ALL_FLAGS    (ETH_FLAG_LRO | ETH_FLAG_RXVLAN | ETH_FLAG_TXVLAN | \
 			  ETH_FLAG_NTUPLE | ETH_FLAG_RXHASH)
-#define ETH_ALL_FEATURES (NETIF_F_LRO | NETIF_F_HW_VLAN_CTAG_RX | \
-			  NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_NTUPLE | \
-			  NETIF_F_RXHASH)
 
 static u32 __ethtool_get_flags(struct net_device *dev)
 {
@@ -313,6 +311,7 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
 	netdev_features_t features = 0, changed;
+	netdev_features_t eth_all_features;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
@@ -328,8 +327,14 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	if (data & ETH_FLAG_RXHASH)
 		features |= NETIF_F_RXHASH;
 
+	netdev_features_zero(eth_all_features);
+	netdev_features_set_set(eth_all_features, NETIF_F_LRO_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_NTUPLE_BIT, NETIF_F_RXHASH_BIT);
+
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->features) & ETH_ALL_FEATURES;
+	changed = (features ^ dev->features) & eth_all_features;
 	if (changed & ~dev->hw_features)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 6ffef47e9be5..bd58b20f1679 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
@@ -448,9 +449,10 @@ void hsr_dev_setup(struct net_device *dev)
 
 	dev->needs_free_netdev = true;
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA |
-			   NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX;
+	dev->hw_features = NETIF_F_GSO_MASK;
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_FRAGLIST_BIT,
+				   NETIF_F_HIGHDMA_BIT, NETIF_F_HW_CSUM_BIT,
+				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
 	dev->features = dev->hw_features;
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f866d6282b2b..6ee63ea39eb5 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
index 123ea63a04cb..7b17560db559 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -94,6 +94,7 @@
 #include <linux/uaccess.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -354,14 +355,10 @@ static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_tunnel_ctl	= ipip_tunnel_ctl,
 };
 
-#define IPIP_FEATURES (NETIF_F_SG |		\
-		       NETIF_F_FRAGLIST |	\
-		       NETIF_F_HIGHDMA |	\
-		       NETIF_F_GSO_SOFTWARE |	\
-		       NETIF_F_HW_CSUM)
-
 static void ipip_tunnel_setup(struct net_device *dev)
 {
+	netdev_features_t ipip_features;
+
 	dev->netdev_ops		= &ipip_netdev_ops;
 	dev->header_ops		= &ip_tunnel_header_ops;
 
@@ -371,8 +368,13 @@ static void ipip_tunnel_setup(struct net_device *dev)
 	dev->features		|= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	dev->features		|= IPIP_FEATURES;
-	dev->hw_features	|= IPIP_FEATURES;
+	ipip_features		= NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(ipip_features, NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_HW_CSUM_BIT);
+	dev->features		|= ipip_features;
+	dev->hw_features	|= ipip_features;
 	ip_tunnel_setup(dev, ipip_net_id);
 }
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 48b4ff0294f6..05af9e3d6b05 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
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
-
 static void ip6gre_tnl_init_features(struct net_device *dev)
 {
 	struct ip6_tnl *nt = netdev_priv(dev);
 	__be16 flags;
 
-	dev->features		|= GRE6_FEATURES | NETIF_F_LLTX;
-	dev->hw_features	|= GRE6_FEATURES;
+	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_HW_CSUM_BIT);
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
+	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
+				   NETIF_F_FRAGLIST_BIT,
+				   NETIF_F_HIGHDMA_BIT,
+				   NETIF_F_HW_CSUM_BIT);
 
 	flags = nt->parms.o_flags;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 9e97f3b4c7e8..2e499393d966 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -27,6 +27,7 @@
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_arp.h>
 #include <linux/icmpv6.h>
 #include <linux/init.h>
@@ -1809,12 +1810,6 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
 
-#define IPXIPX_FEATURES (NETIF_F_SG |		\
-			 NETIF_F_FRAGLIST |	\
-			 NETIF_F_HIGHDMA |	\
-			 NETIF_F_GSO_SOFTWARE |	\
-			 NETIF_F_HW_CSUM)
-
 /**
  * ip6_tnl_dev_setup - setup virtual tunnel device
  *   @dev: virtual device associated with tunnel
@@ -1825,6 +1820,8 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 
 static void ip6_tnl_dev_setup(struct net_device *dev)
 {
+	netdev_features_t ipxipx_features;
+
 	dev->netdev_ops = &ip6_tnl_netdev_ops;
 	dev->header_ops = &ip_tunnel_header_ops;
 	dev->needs_free_netdev = true;
@@ -1836,8 +1833,13 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 	dev->features |= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	dev->features		|= IPXIPX_FEATURES;
-	dev->hw_features	|= IPXIPX_FEATURES;
+	ipxipx_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(ipxipx_features, NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_HW_CSUM_BIT);
+	dev->features		|= ipxipx_features;
+	dev->hw_features	|= ipxipx_features;
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 98f1cf40746f..500acde55435 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -24,6 +24,7 @@
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_arp.h>
 #include <linux/icmp.h>
 #include <linux/slab.h>
@@ -1407,16 +1408,11 @@ static void ipip6_dev_free(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-#define SIT_FEATURES (NETIF_F_SG	   | \
-		      NETIF_F_FRAGLIST	   | \
-		      NETIF_F_HIGHDMA	   | \
-		      NETIF_F_GSO_SOFTWARE | \
-		      NETIF_F_HW_CSUM)
-
 static void ipip6_tunnel_setup(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+	netdev_features_t sit_features;
 
 	dev->netdev_ops		= &ipip6_netdev_ops;
 	dev->header_ops		= &ip_tunnel_header_ops;
@@ -1430,9 +1426,14 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	netif_keep_dst(dev);
 	dev->addr_len		= 4;
+	sit_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(sit_features, NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_HW_CSUM_BIT);
 	dev->features		|= NETIF_F_LLTX;
-	dev->features		|= SIT_FEATURES;
-	dev->hw_features	|= SIT_FEATURES;
+	dev->features		|= sit_features;
+	dev->hw_features	|= sit_features;
 }
 
 static int ipip6_tunnel_init(struct net_device *dev)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 977aea4467e0..e364caaf584c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/types.h>
@@ -1904,13 +1905,13 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
index 46f3eddc2388..3427752ecc8d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -33,6 +33,10 @@
 #include "led.h"
 #include "debugfs.h"
 
+netdev_features_t mac80211_tx_features __ro_after_init;
+netdev_features_t mac80211_rx_features __ro_after_init;
+netdev_features_t mac80211_supported_features __ro_after_init;
+
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	u64 mc;
@@ -1529,6 +1533,19 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
 
+static void __init ieee80211_features_init(void)
+{
+	mac80211_tx_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(mac80211_tx_features,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_HIGHDMA_BIT);
+	netdev_features_set_set(mac80211_rx_features, NETIF_F_RXCSUM_BIT);
+	mac80211_supported_features = mac80211_tx_features | mac80211_rx_features;
+}
+
 static int __init ieee80211_init(void)
 {
 	struct sk_buff *skb;
@@ -1546,6 +1563,8 @@ static int __init ieee80211_init(void)
 	if (ret)
 		goto err_netdev;
 
+	ieee80211_features_init();
+
 	return 0;
  err_netdev:
 	rc80211_minstrel_exit();
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 35f42c9821c2..c3ef955e2a3a 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -6,6 +6,7 @@
 #include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
@@ -108,9 +109,12 @@ static void do_setup(struct net_device *netdev)
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
 	netdev->rtnl_link_ops = &internal_dev_link_ops;
 
-	netdev->features = NETIF_F_LLTX | NETIF_F_SG | NETIF_F_FRAGLIST |
-			   NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			   NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev->features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
+	netdev_active_features_set_set(netdev, NETIF_F_LLTX_BIT,
+				       NETIF_F_SG_BIT,
+				       NETIF_F_FRAGLIST_BIT,
+				       NETIF_F_HIGHDMA_BIT,
+				       NETIF_F_HW_CSUM_BIT);
 
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5113fa0fbcee..7d3fe0b2624c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -20,6 +20,7 @@
 #include <linux/net.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_link.h>
 #include <linux/if_arp.h>
 #include <linux/icmpv6.h>
@@ -572,15 +573,11 @@ static void xfrmi_dev_setup(struct net_device *dev)
 	eth_broadcast_addr(dev->broadcast);
 }
 
-#define XFRMI_FEATURES (NETIF_F_SG |		\
-			NETIF_F_FRAGLIST |	\
-			NETIF_F_GSO_SOFTWARE |	\
-			NETIF_F_HW_CSUM)
-
 static int xfrmi_dev_init(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct net_device *phydev = __dev_get_by_index(xi->net, xi->p.link);
+	netdev_features_t xfrmi_features;
 	int err;
 
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
@@ -593,9 +590,12 @@ static int xfrmi_dev_init(struct net_device *dev)
 		return err;
 	}
 
+	xfrmi_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_set_set(xfrmi_features, NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT, NETIF_F_HW_CSUM_BIT);
 	dev->features |= NETIF_F_LLTX;
-	dev->features |= XFRMI_FEATURES;
-	dev->hw_features |= XFRMI_FEATURES;
+	dev->features |= xfrmi_features;
+	dev->hw_features |= xfrmi_features;
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.33.0

