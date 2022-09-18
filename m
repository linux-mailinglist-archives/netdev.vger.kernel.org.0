Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498935BBD14
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIRJvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiIRJuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA6617A97
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjc915ThzmVMj;
        Sun, 18 Sep 2022 17:46:01 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:51 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 30/55] treewide: use netdev_feature_test helpers
Date:   Sun, 18 Sep 2022 09:43:11 +0000
Message-ID: <20220918094336.28958-31-shenjian15@huawei.com>
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

Replace the '&' expressions of single feature bit by
netdev_feature_test helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  2 +-
 drivers/net/bonding/bond_main.c               | 10 +-
 drivers/net/ethernet/3com/3c59x.c             |  6 +-
 drivers/net/ethernet/aeroflex/greth.c         |  3 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c      | 14 +--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 38 ++++----
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  6 +-
 .../ethernet/aquantia/atlantic/aq_filters.c   |  8 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 25 ++---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  2 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  6 +-
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  6 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   | 16 ++--
 drivers/net/ethernet/atheros/atlx/atl2.c      |  6 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |  6 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  6 +-
 drivers/net/ethernet/broadcom/bnx2.c          | 17 ++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 24 ++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 22 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 drivers/net/ethernet/broadcom/tg3.c           | 14 +--
 drivers/net/ethernet/brocade/bna/bnad.c       | 10 +-
 drivers/net/ethernet/cadence/macb_main.c      | 31 ++++---
 drivers/net/ethernet/calxeda/xgmac.c          |  6 +-
 .../net/ethernet/cavium/liquidio/lio_core.c   |  4 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 65 +++++++------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 45 +++++----
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 14 +--
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  8 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c       |  8 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 16 ++--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  8 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 13 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  8 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  7 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |  4 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c  |  2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  6 +-
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/davicom/dm9000.c         | 11 ++-
 drivers/net/ethernet/davicom/dm9051.c         |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  6 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |  4 +-
 drivers/net/ethernet/faraday/ftgmac100.c      | 10 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 13 +--
 drivers/net/ethernet/freescale/enetc/enetc.c  | 24 ++---
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  9 +-
 drivers/net/ethernet/freescale/fec_main.c     |  8 +-
 drivers/net/ethernet/freescale/gianfar.c      | 18 ++--
 .../net/ethernet/freescale/gianfar_ethtool.c  |  2 +-
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |  2 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  3 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |  4 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  4 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 30 +++---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  4 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    | 19 ++--
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  4 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  4 +-
 drivers/net/ethernet/intel/e100.c             | 11 ++-
 drivers/net/ethernet/intel/e1000/e1000_main.c | 24 ++---
 drivers/net/ethernet/intel/e1000e/netdev.c    | 30 +++---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 21 +++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 12 +--
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 57 +++++++-----
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  8 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 27 +++---
 drivers/net/ethernet/intel/igbvf/netdev.c     |  4 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 23 ++---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  9 +-
 .../net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c   |  2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 46 ++++-----
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |  4 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  8 +-
 drivers/net/ethernet/jme.c                    |  6 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 10 +-
 .../marvell/octeontx2/nic/otx2_common.c       | 22 +++--
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 14 ++-
 .../marvell/octeontx2/nic/otx2_txrx.c         |  6 +-
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/marvell/sky2.c           | 24 ++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 20 ++--
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c  |  6 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 24 ++---
 .../net/ethernet/mellanox/mlx4/en_resources.c |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 14 +--
 .../mellanox/mlx5/core/en_accel/ktls.c        |  4 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  8 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  6 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  5 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  2 +-
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  4 +-
 drivers/net/ethernet/mscc/ocelot.c            |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  7 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  4 +-
 drivers/net/ethernet/natsemi/ns83820.c        |  2 +-
 drivers/net/ethernet/neterion/s2io.c          |  8 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  4 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  |  4 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 32 +++----
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  3 +-
 drivers/net/ethernet/nvidia/forcedeth.c       | 26 +++---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 36 +++----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  6 +-
 .../ethernet/qlogic/netxen/netxen_nic_init.c  |  4 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 10 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  6 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  6 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  4 +-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  4 +-
 drivers/net/ethernet/realtek/8139cp.c         |  6 +-
 drivers/net/ethernet/realtek/8139too.c        | 12 +--
 drivers/net/ethernet/realtek/r8169_main.c     | 12 +--
 drivers/net/ethernet/renesas/ravb_main.c      |  9 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  9 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  4 +-
 drivers/net/ethernet/sfc/ef10.c               |  2 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |  4 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |  8 +-
 drivers/net/ethernet/sfc/efx.c                |  4 +-
 drivers/net/ethernet/sfc/efx_common.c         |  6 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  7 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |  4 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  8 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c   |  2 +-
 drivers/net/ethernet/sfc/rx.c                 |  2 +-
 drivers/net/ethernet/sfc/rx_common.c          |  4 +-
 drivers/net/ethernet/sfc/siena/efx.c          |  4 +-
 drivers/net/ethernet/sfc/siena/efx_common.c   |  6 +-
 drivers/net/ethernet/sfc/siena/farch.c        |  2 +-
 .../net/ethernet/sfc/siena/mcdi_port_common.c |  2 +-
 drivers/net/ethernet/sfc/siena/rx.c           |  2 +-
 drivers/net/ethernet/sfc/siena/rx_common.c    |  4 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +-
 .../stmicro/stmmac/stmmac_selftests.c         |  4 +-
 drivers/net/ethernet/sun/niu.c                |  2 +-
 drivers/net/ethernet/sun/sungem.c             |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c | 14 +--
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    | 30 +++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  2 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  2 +-
 drivers/net/hyperv/netvsc_bpf.c               |  2 +-
 drivers/net/hyperv/netvsc_drv.c               | 12 ++-
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/macsec.c                          |  3 +-
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/net_failover.c                    |  2 +-
 drivers/net/netdevsim/netdev.c                |  3 +-
 drivers/net/tap.c                             |  3 +-
 drivers/net/team/team.c                       |  4 +-
 drivers/net/usb/aqc111.c                      | 22 ++---
 drivers/net/usb/ax88179_178a.c                |  8 +-
 drivers/net/usb/lan78xx.c                     | 12 +--
 drivers/net/usb/r8152.c                       | 18 ++--
 drivers/net/usb/smsc75xx.c                    |  4 +-
 drivers/net/usb/smsc95xx.c                    |  8 +-
 drivers/net/veth.c                            | 11 ++-
 drivers/net/virtio_net.c                      | 12 +--
 drivers/net/vmxnet3/vmxnet3_drv.c             | 18 ++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 18 ++--
 drivers/net/wireless/ath/ath6kl/main.c        |  4 +-
 drivers/net/wireless/ath/ath6kl/txrx.c        |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  2 +-
 drivers/net/xen-netfront.c                    | 12 +--
 drivers/s390/net/qeth_core_main.c             | 27 +++---
 drivers/s390/net/qeth_l3_main.c               |  4 +-
 drivers/scsi/fcoe/fcoe.c                      | 12 +--
 drivers/staging/qlge/qlge_main.c              | 18 ++--
 include/linux/if_vlan.h                       |  8 +-
 include/linux/netdev_feature_helpers.h        |  5 +-
 include/linux/netdevice.h                     | 18 ++--
 include/net/pkt_cls.h                         |  2 +-
 include/net/sock.h                            |  2 +-
 include/net/udp_tunnel.h                      |  8 +-
 net/8021q/vlan.c                              |  6 +-
 net/8021q/vlan_core.c                         |  4 +-
 net/core/dev.c                                | 93 ++++++++++---------
 net/core/pktgen.c                             |  8 +-
 net/core/skbuff.c                             |  7 +-
 net/core/skmsg.c                              |  2 +-
 net/core/sock.c                               |  2 +-
 net/ethtool/ioctl.c                           | 10 +-
 net/hsr/hsr_forward.c                         |  8 +-
 net/hsr/hsr_framereg.c                        |  2 +-
 net/hsr/hsr_slave.c                           |  2 +-
 net/ipv4/esp4_offload.c                       | 12 +--
 net/ipv4/gre_offload.c                        |  2 +-
 net/ipv4/ip_output.c                          | 20 ++--
 net/ipv4/tcp.c                                |  8 +-
 net/ipv4/udp_offload.c                        | 10 +-
 net/ipv6/esp6_offload.c                       |  6 +-
 net/ipv6/ip6_output.c                         | 16 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c         |  3 +-
 net/nsh/nsh.c                                 |  2 +-
 net/sctp/offload.c                            |  2 +-
 net/sctp/output.c                             |  2 +-
 net/sunrpc/sunrpc.h                           |  2 +-
 net/tls/tls_device.c                          |  6 +-
 net/xfrm/xfrm_device.c                        | 14 +--
 net/xfrm/xfrm_output.c                        |  4 +-
 245 files changed, 1156 insertions(+), 1044 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 9920c4cb8aa3..4ac7af5a635d 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1351,7 +1351,7 @@ static int vector_set_features(struct net_device *dev,
 	 * no way to negotiate it on raw sockets, so we can change
 	 * only our side.
 	 */
-	if (features & NETIF_F_GRO)
+	if (netdev_feature_test(NETIF_F_GRO_BIT, features))
 		/* All new frame buffers will be GRO-sized */
 		vp->req_size = 65536;
 	else
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index fd9d7f2c4d64..f020a2886ddd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1070,7 +1070,7 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
 	};
 	struct ib_qp *tx_qp;
 
-	if (dev->features & NETIF_F_SG)
+	if (netdev_active_feature_test(dev, NETIF_F_SG_BIT))
 		attr.cap.max_send_sge = min_t(u32, priv->ca->attrs.max_send_sge,
 					      MAX_SKB_FRAGS + 1);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index ed25061fac62..2c631c7d6b13 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -260,7 +260,7 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		dev->stats.multicast++;
 
 	skb->dev = dev;
-	if ((dev->features & NETIF_F_RXCSUM) &&
+	if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT) &&
 			likely(wc->wc_flags & IB_WC_IP_CSUM_OK))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b8f8ba623c9e..6db8d834c3e4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1813,7 +1813,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	/* vlan challenged mutual exclusion */
 	/* no need to lock since we're protected by rtnl_lock */
-	if (slave_dev->features & NETIF_F_VLAN_CHALLENGED) {
+	if (netdev_active_feature_test(slave_dev, NETIF_F_VLAN_CHALLENGED_BIT)) {
 		slave_dbg(bond_dev, slave_dev, "is NETIF_F_VLAN_CHALLENGED\n");
 		if (vlan_uses_dev(bond_dev)) {
 			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
@@ -1826,7 +1826,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		slave_dbg(bond_dev, slave_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
 	}
 
-	if (slave_dev->features & NETIF_F_HW_ESP)
+	if (netdev_active_feature_test(slave_dev, NETIF_F_HW_ESP_BIT))
 		slave_dbg(bond_dev, slave_dev, "is esp-hw-offload capable\n");
 
 	/* Old ifenslave binaries are no longer supported.  These can
@@ -2121,7 +2121,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	}
 #endif
 
-	if (!(bond_dev->features & NETIF_F_LRO))
+	if (!netdev_active_feature_test(bond_dev, NETIF_F_LRO_BIT))
 		dev_disable_lro(slave_dev);
 
 	res = netdev_rx_handler_register(slave_dev, bond_handle_frame,
@@ -2423,8 +2423,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	}
 
 	bond_compute_features(bond);
-	if (!(bond_dev->features & NETIF_F_VLAN_CHALLENGED) &&
-	    (old_features & NETIF_F_VLAN_CHALLENGED))
+	if (!netdev_active_feature_test(bond_dev, NETIF_F_VLAN_CHALLENGED_BIT) &&
+	    netdev_feature_test(NETIF_F_VLAN_CHALLENGED_BIT, old_features))
 		slave_info(bond_dev, slave_dev, "last VLAN challenged slave left bond - VLAN blocking is removed\n");
 
 	vlan_vids_del_by_dev(slave_dev, bond_dev);
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 66eb2d9fe576..acd2a729be7b 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1457,9 +1457,9 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 
 	if (print_info) {
 		pr_info("%s: scatter/gather %sabled. h/w checksums %sabled\n",
-				print_name,
-				(dev->features & NETIF_F_SG) ? "en":"dis",
-				(dev->features & NETIF_F_IP_CSUM) ? "en":"dis");
+			print_name,
+			netdev_active_feature_test(dev, NETIF_F_SG_BIT) ? "en" : "dis",
+			netdev_active_feature_test(dev, NETIF_F_IP_CSUM_BIT) ? "en" : "dis");
 	}
 
 	dev->ethtool_ops = &vortex_ethtool_ops;
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index ae768c5cdc59..0e424ac95a65 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -914,7 +914,8 @@ static int greth_rx_gbit(struct net_device *dev, int limit)
 
 				skb_put(skb, pkt_len);
 
-				if (dev->features & NETIF_F_RXCSUM && hw_checksummed(status))
+				if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT) &&
+				    hw_checksummed(status))
 					skb->ip_summed = CHECKSUM_UNNECESSARY;
 				else
 					skb_checksum_none_assert(skb);
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 379b3d809f9e..100b71152659 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -340,7 +340,7 @@ static inline void tse_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 	struct ethhdr *eth_hdr;
 	u16 vid;
 
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    !__vlan_get_tag(skb, &vid)) {
 		eth_hdr = (struct ethhdr *)skb->data;
 		memmove(skb->data + VLAN_HLEN, eth_hdr, ETH_ALEN * 2);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 50470e55cbe5..5d287e960a2a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1533,7 +1533,7 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
 				   struct sk_buff *skb)
 {
 	/* Rx csum disabled */
-	if (unlikely(!(rx_ring->netdev->features & NETIF_F_RXCSUM))) {
+	if (unlikely(!netdev_active_feature_test(rx_ring->netdev, NETIF_F_RXCSUM_BIT))) {
 		skb->ip_summed = CHECKSUM_NONE;
 		return;
 	}
@@ -1591,7 +1591,7 @@ static void ena_set_rx_hash(struct ena_ring *rx_ring,
 {
 	enum pkt_hash_types hash_type;
 
-	if (likely(rx_ring->netdev->features & NETIF_F_RXHASH)) {
+	if (likely(netdev_active_feature_test(rx_ring->netdev, NETIF_F_RXHASH_BIT))) {
 		if (likely((ena_rx_ctx->l4_proto == ENA_ETH_IO_L4_PROTO_TCP) ||
 			   (ena_rx_ctx->l4_proto == ENA_ETH_IO_L4_PROTO_UDP)))
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 3936543a74d8..f9664f194a6a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -449,7 +449,7 @@ static void xgbe_config_rss(struct xgbe_prv_data *pdata)
 	if (!pdata->hw_feat.rss)
 		return;
 
-	if (pdata->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_RXHASH_BIT))
 		ret = xgbe_enable_rss(pdata);
 	else
 		ret = xgbe_disable_rss(pdata);
@@ -948,7 +948,7 @@ static int xgbe_set_promiscuous_mode(struct xgbe_prv_data *pdata,
 	if (enable) {
 		xgbe_disable_rx_vlan_filtering(pdata);
 	} else {
-		if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		if (netdev_active_feature_test(pdata->netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 			xgbe_enable_rx_vlan_filtering(pdata);
 	}
 
@@ -1990,7 +1990,7 @@ static int xgbe_dev_read(struct xgbe_channel *channel)
 	rdata->rx.len = XGMAC_GET_BITS_LE(rdesc->desc3, RX_NORMAL_DESC3, PL);
 
 	/* Set checksum done indicator as appropriate */
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)) {
 		XGMAC_SET_BITS(packet->attributes, RX_PACKET_ATTRIBUTES,
 			       CSUM_DONE, 1);
 		XGMAC_SET_BITS(packet->attributes, RX_PACKET_ATTRIBUTES,
@@ -2021,7 +2021,7 @@ static int xgbe_dev_read(struct xgbe_channel *channel)
 	if (!err || !etlt) {
 		/* No error if err is 0 or etlt is 0 */
 		if ((etlt == 0x09) &&
-		    (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
+		    netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 			XGMAC_SET_BITS(packet->attributes, RX_PACKET_ATTRIBUTES,
 				       VLAN_CTAG, 1);
 			packet->vlan_ctag = XGMAC_GET_BITS_LE(rdesc->desc0,
@@ -2823,7 +2823,7 @@ static void xgbe_config_mac_speed(struct xgbe_prv_data *pdata)
 
 static void xgbe_config_checksum_offload(struct xgbe_prv_data *pdata)
 {
-	if (pdata->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_RXCSUM_BIT))
 		xgbe_enable_rx_csum(pdata);
 	else
 		xgbe_disable_rx_csum(pdata);
@@ -2838,12 +2838,12 @@ static void xgbe_config_vlan_support(struct xgbe_prv_data *pdata)
 	/* Set the current VLAN Hash Table register value */
 	xgbe_update_vlan_hash_table(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		xgbe_enable_rx_vlan_filtering(pdata);
 	else
 		xgbe_disable_rx_vlan_filtering(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		xgbe_enable_rx_vlan_stripping(pdata);
 	else
 		xgbe_disable_rx_vlan_stripping(pdata);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 93ddf9a66be3..88e09b177c03 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2191,8 +2191,8 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 		return features;
 
 	/* VXLAN CSUM requires VXLAN base */
-	if ((features & NETIF_F_GSO_UDP_TUNNEL_CSUM) &&
-	    !(features & NETIF_F_GSO_UDP_TUNNEL)) {
+	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, features)) {
 		netdev_notice(netdev,
 			      "forcing tx udp tunnel support\n");
 		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, features);
@@ -2206,14 +2206,14 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	}
 
 	if (features & netdev_ip_csum_features) {
-		if (!(features & NETIF_F_GSO_UDP_TUNNEL_CSUM)) {
+		if (!netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
 			netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 					   features);
 		}
 	} else {
-		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM) {
+		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming off\n");
 			netdev_feature_del(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
@@ -2232,31 +2232,33 @@ static int xgbe_set_features(struct net_device *netdev,
 	netdev_features_t rxhash, rxcsum, rxvlan, rxvlan_filter;
 	int ret = 0;
 
-	rxhash = pdata->netdev_features & NETIF_F_RXHASH;
-	rxcsum = pdata->netdev_features & NETIF_F_RXCSUM;
-	rxvlan = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_RX;
-	rxvlan_filter = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_FILTER;
+	rxhash = netdev_feature_test(NETIF_F_RXHASH_BIT, pdata->netdev_features);
+	rxcsum = netdev_feature_test(NETIF_F_RXCSUM_BIT, pdata->netdev_features);
+	rxvlan = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				     pdata->netdev_features);
+	rxvlan_filter = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    pdata->netdev_features);
 
-	if ((features & NETIF_F_RXHASH) && !rxhash)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) && !rxhash)
 		ret = hw_if->enable_rss(pdata);
-	else if (!(features & NETIF_F_RXHASH) && rxhash)
+	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, features) && rxhash)
 		ret = hw_if->disable_rss(pdata);
 	if (ret)
 		return ret;
 
-	if ((features & NETIF_F_RXCSUM) && !rxcsum)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !rxcsum)
 		hw_if->enable_rx_csum(pdata);
-	else if (!(features & NETIF_F_RXCSUM) && rxcsum)
+	else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && rxcsum)
 		hw_if->disable_rx_csum(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) && !rxvlan)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && !rxvlan)
 		hw_if->enable_rx_vlan_stripping(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) && rxvlan)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && rxvlan)
 		hw_if->disable_rx_vlan_stripping(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) && !rxvlan_filter)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && !rxvlan_filter)
 		hw_if->enable_rx_vlan_filtering(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) && rxvlan_filter)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && rxvlan_filter)
 		hw_if->disable_rx_vlan_filtering(pdata);
 
 	pdata->netdev_features = features;
@@ -2598,8 +2600,8 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
-		if (!(netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
-		    (skb->protocol == htons(ETH_P_8021Q)))
+		if (!netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
+		    skb->protocol == htons(ETH_P_8021Q))
 			max_len += VLAN_HLEN;
 
 		if (skb->len > max_len) {
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index a6709e94f31d..2f03cdebb00d 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -321,7 +321,7 @@ static int xgene_enet_work_msg(struct sk_buff *skb, u64 *hopinfo)
 	    unlikely(skb->protocol != htons(ETH_P_8021Q)))
 		goto out;
 
-	if (unlikely(!(skb->dev->features & NETIF_F_IP_CSUM)))
+	if (unlikely(!netdev_active_feature_test(skb->dev, NETIF_F_IP_CSUM_BIT)))
 		goto out;
 
 	iph = ip_hdr(skb);
@@ -332,7 +332,7 @@ static int xgene_enet_work_msg(struct sk_buff *skb, u64 *hopinfo)
 		l4hlen = tcp_hdrlen(skb) >> 2;
 		csum_enable = 1;
 		proto = TSO_IPPROTO_TCP;
-		if (ndev->features & NETIF_F_TSO) {
+		if (netdev_active_feature_test(ndev, NETIF_F_TSO_BIT)) {
 			hdr_len = ethhdr + ip_hdrlen(skb) + tcp_hdrlen(skb);
 			mss = skb_shinfo(skb)->gso_size;
 
@@ -591,7 +591,7 @@ static void xgene_enet_rx_csum(struct sk_buff *skb)
 	struct net_device *ndev = skb->dev;
 	struct iphdr *iph = ip_hdr(skb);
 
-	if (!(ndev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	if (skb->protocol != htons(ETH_P_IP))
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 30a573db02bb..96919291ec5d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -164,7 +164,7 @@ aq_check_approve_fvlan(struct aq_nic_s *aq_nic,
 		return -EINVAL;
 	}
 
-	if ((aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_active_feature_test(aq_nic->ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT) &&
 	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci) & VLAN_VID_MASK,
 		       aq_nic->active_vlans))) {
 		netdev_err(aq_nic->ndev,
@@ -236,7 +236,7 @@ aq_rule_is_not_support(struct aq_nic_s *aq_nic,
 {
 	bool rule_is_not_support = false;
 
-	if (!(aq_nic->ndev->features & NETIF_F_NTUPLE)) {
+	if (!netdev_active_feature_test(aq_nic->ndev, NETIF_F_NTUPLE_BIT)) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: Please, to enable the RX flow control:\n"
 			   "ethtool -K %s ntuple on\n", aq_nic->ndev->name);
@@ -835,7 +835,7 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 	aq_fvlan_rebuild(aq_nic, aq_nic->active_vlans,
 			 aq_nic->aq_hw_rx_fltrs.fl2.aq_vlans);
 
-	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_active_feature_test(aq_nic->ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) {
 		hweight = bitmap_weight(aq_nic->active_vlans, VLAN_N_VID);
 
 		err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw, false);
@@ -849,7 +849,7 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 	if (err)
 		return err;
 
-	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_active_feature_test(aq_nic->ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) {
 		if (hweight <= AQ_VLAN_MAX_FILTERS && hweight > 0) {
 			err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw,
 				!(aq_nic->packet_filter & IFF_PROMISC));
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index b7867dcd5289..c331631d82c0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -162,8 +162,8 @@ static int aq_ndev_change_mtu(struct net_device *ndev, int new_mtu)
 static int aq_ndev_set_features(struct net_device *ndev,
 				netdev_features_t features)
 {
-	bool is_vlan_tx_insert = !!(features & NETIF_F_HW_VLAN_CTAG_TX);
-	bool is_vlan_rx_strip = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+	bool is_vlan_tx_insert = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	bool is_vlan_rx_strip = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	bool need_ndev_restart = false;
 	struct aq_nic_cfg_s *aq_cfg;
@@ -173,15 +173,15 @@ static int aq_ndev_set_features(struct net_device *ndev,
 
 	aq_cfg = aq_nic_get_cfg(aq_nic);
 
-	if (!(features & NETIF_F_NTUPLE)) {
-		if (aq_nic->ndev->features & NETIF_F_NTUPLE) {
+	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, features)) {
+		if (netdev_active_feature_test(aq_nic->ndev, NETIF_F_NTUPLE_BIT)) {
 			err = aq_clear_rxnfc_all_rules(aq_nic);
 			if (unlikely(err))
 				goto err_exit;
 		}
 	}
-	if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
-		if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
+		if (netdev_active_feature_test(aq_nic->ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) {
 			err = aq_filters_vlan_offload_off(aq_nic);
 			if (unlikely(err))
 				goto err_exit;
@@ -190,8 +190,9 @@ static int aq_ndev_set_features(struct net_device *ndev,
 
 	aq_cfg->features = features;
 
-	if (*aq_cfg->aq_hw_caps->hw_features & NETIF_F_LRO) {
-		is_lro = features & NETIF_F_LRO;
+	if (netdev_feature_test(NETIF_F_LRO_BIT,
+				*aq_cfg->aq_hw_caps->hw_features)) {
+		is_lro = netdev_feature_test(NETIF_F_LRO_BIT, features);
 
 		if (aq_cfg->is_lro != is_lro) {
 			aq_cfg->is_lro = is_lro;
@@ -200,7 +201,7 @@ static int aq_ndev_set_features(struct net_device *ndev,
 	}
 
 	netdev_features_xor(changed, aq_nic->ndev->features, features);
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		err = aq_nic->aq_hw_ops->hw_set_offload(aq_nic->aq_hw,
 							aq_cfg);
 
@@ -232,12 +233,12 @@ static netdev_features_t aq_ndev_fix_features(struct net_device *ndev,
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct bpf_prog *prog;
 
-	if (!(features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
 	prog = READ_ONCE(aq_nic->xdp_prog);
 	if (prog && !prog->aux->xdp_has_frags &&
-	    aq_nic->xdp_prog && features & NETIF_F_LRO) {
+	    aq_nic->xdp_prog && netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		netdev_err(ndev, "LRO is not supported with single buffer XDP, disabling\n");
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 	}
@@ -465,7 +466,7 @@ static int aq_xdp_setup(struct net_device *ndev, struct bpf_prog *prog,
 			return -EOPNOTSUPP;
 		}
 
-		if (prog && ndev->features & NETIF_F_LRO) {
+		if (prog && netdev_active_feature_test(ndev, NETIF_F_LRO_BIT)) {
 			netdev_err(ndev,
 				   "LRO is not supported with single buffer XDP, disabling\n");
 			netdev_active_feature_del(ndev, NETIF_F_LRO_BIT);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 963aa9359257..bc9649ea37e9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -146,8 +146,10 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 
 	cfg->link_speed_msk &= cfg->aq_hw_caps->link_speed_msk;
 	cfg->features = *cfg->aq_hw_caps->hw_features;
-	cfg->is_vlan_rx_strip = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_RX);
-	cfg->is_vlan_tx_insert = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_TX);
+	cfg->is_vlan_rx_strip =
+		netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, cfg->features);
+	cfg->is_vlan_tx_insert =
+		netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, cfg->features);
 	cfg->is_vlan_force_promisc = true;
 
 	for (i = 0; i < sizeof(cfg->prio_tc_map); i++)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 25129e723b57..2e8255586e93 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -369,7 +369,7 @@ static void aq_rx_checksum(struct aq_ring_s *self,
 			   struct aq_ring_buff_s *buff,
 			   struct sk_buff *skb)
 {
-	if (!(self->aq_nic->ndev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(self->aq_nic->ndev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	if (unlikely(buff->is_cso_err)) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 0ba71726238a..bb0b93f3eb9f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -260,7 +260,7 @@ static int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
 int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 			     struct aq_nic_cfg_s *aq_nic_cfg)
 {
-	u64 rxcsum = !!(aq_nic_cfg->features & NETIF_F_RXCSUM);
+	u64 rxcsum = netdev_feature_test(NETIF_F_RXCSUM_BIT, aq_nic_cfg->features);
 	unsigned int i;
 
 	/* TX checksums offloads*/
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 8ad92c2f92cb..49e2d061348d 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -414,7 +414,7 @@ ax88796c_skb_return(struct ax88796c_device *ax_local,
 	stats = this_cpu_ptr(ax_local->stats);
 
 	do {
-		if (!(ndev->features & NETIF_F_RXCSUM))
+		if (!netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT))
 			break;
 
 		/* checksum error bit is set */
@@ -780,7 +780,7 @@ static void ax88796c_set_csums(struct ax88796c_device *ax_local)
 
 	lockdep_assert_held(&ax_local->spi_lock);
 
-	if (ndev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT)) {
 		AX_WRITE(&ax_local->ax_spi, COERCR0_DEFAULT, P4_COERCR0);
 		AX_WRITE(&ax_local->ax_spi, COERCR1_DEFAULT, P4_COERCR1);
 	} else {
@@ -788,7 +788,7 @@ static void ax88796c_set_csums(struct ax88796c_device *ax_local)
 		AX_WRITE(&ax_local->ax_spi, 0, P4_COERCR1);
 	}
 
-	if (ndev->features & NETIF_F_HW_CSUM) {
+	if (netdev_active_feature_test(ndev, NETIF_F_HW_CSUM_BIT)) {
 		AX_WRITE(&ax_local->ax_spi, COETCR0_DEFAULT, P4_COETCR0);
 		AX_WRITE(&ax_local->ax_spi, COETCR1_TXPPPE, P4_COETCR1);
 	} else {
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index db35ffb830de..d780a32ca51d 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -262,7 +262,7 @@ static int alx_clean_rx_irq(struct alx_rx_queue *rxq, int budget)
 		skb->protocol = eth_type_trans(skb, rxq->netdev);
 
 		skb_checksum_none_assert(skb);
-		if (alx->dev->features & NETIF_F_RXCSUM &&
+		if (netdev_active_feature_test(alx->dev, NETIF_F_RXCSUM_BIT) &&
 		    !(rrd->word3 & (cpu_to_le32(1 << RRD_ERR_L4_SHIFT) |
 				    cpu_to_le32(1 << RRD_ERR_IPV4_SHIFT)))) {
 			switch (ALX_GET_FIELD(le32_to_cpu(rrd->word2),
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 8cffd89c855e..202cc99ac334 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -429,7 +429,7 @@ static void atl1c_set_multi(struct net_device *netdev)
 
 static void __atl1c_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*mac_ctrl_data |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -514,7 +514,7 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -534,7 +534,7 @@ static int atl1c_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1c_vlan_mode(netdev, features);
 
 	return 0;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index b1fdc855ae84..ebc1606368d0 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -299,7 +299,7 @@ static void atl1e_set_multi(struct net_device *netdev)
 static void __atl1e_rx_mode(netdev_features_t features, u32 *mac_ctrl_data)
 {
 
-	if (features & NETIF_F_RXALL) {
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, features)) {
 		/* enable RX of ALL frames */
 		*mac_ctrl_data |= MAC_CTRL_DBG;
 	} else {
@@ -326,7 +326,7 @@ static void atl1e_rx_mode(struct net_device *netdev,
 
 static void __atl1e_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*mac_ctrl_data |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -389,7 +389,7 @@ static netdev_features_t atl1e_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -403,10 +403,10 @@ static int atl1e_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1e_vlan_mode(netdev, features);
 
-	if (changed & NETIF_F_RXALL)
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, changed))
 		atl1e_rx_mode(netdev, features);
 
 
@@ -1068,7 +1068,7 @@ static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter)
 		value |= MAC_CTRL_PROMIS_EN;
 	if (netdev->flags & IFF_ALLMULTI)
 		value |= MAC_CTRL_MC_ALL_EN;
-	if (netdev->features & NETIF_F_RXALL)
+	if (netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT))
 		value |= MAC_CTRL_DBG;
 	AT_WRITE_REG(hw, REG_MAC_CTRL, value);
 }
@@ -1430,7 +1430,7 @@ static void atl1e_clean_rx_irq(struct atl1e_adapter *adapter, u8 que,
 
 			/* error packet */
 			if ((prrs->pkt_flag & RRS_IS_ERR_FRAME) &&
-			    !(netdev->features & NETIF_F_RXALL)) {
+			    !netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 				if (prrs->err_flag & (RRS_ERR_BAD_CRC |
 					RRS_ERR_DRIBBLE | RRS_ERR_CODE |
 					RRS_ERR_TRUNC)) {
@@ -1444,7 +1444,7 @@ static void atl1e_clean_rx_irq(struct atl1e_adapter *adapter, u8 que,
 
 			packet_size = ((prrs->word1 >> RRS_PKT_SIZE_SHIFT) &
 					RRS_PKT_SIZE_MASK);
-			if (likely(!(netdev->features & NETIF_F_RXFCS)))
+			if (likely(!netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT)))
 				packet_size -= 4; /* CRC */
 
 			skb = netdev_alloc_skb_ip_align(netdev, packet_size);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 4dde0f0b5620..b43c193dc433 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -343,7 +343,7 @@ static inline void atl2_irq_disable(struct atl2_adapter *adapter)
 
 static void __atl2_vlan_mode(netdev_features_t features, u32 *ctrl)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*ctrl |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -379,7 +379,7 @@ static netdev_features_t atl2_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -393,7 +393,7 @@ static int atl2_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl2_vlan_mode(netdev, features);
 
 	return 0;
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index 24679d304234..d840713c8ad8 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -207,7 +207,7 @@ static void atlx_link_chg_task(struct work_struct *work)
 
 static void __atlx_vlan_mode(netdev_features_t features, u32 *ctrl)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*ctrl |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -244,7 +244,7 @@ static netdev_features_t atlx_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -258,7 +258,7 @@ static int atlx_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atlx_vlan_mode(netdev, features);
 
 	return 0;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 784f46970f8b..28190575d0d4 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -123,7 +123,7 @@ static void bcm_sysport_set_rx_csum(struct net_device *dev,
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	u32 reg;
 
-	priv->rx_chk_en = !!(wanted & NETIF_F_RXCSUM);
+	priv->rx_chk_en = netdev_feature_test(NETIF_F_RXCSUM_BIT, wanted);
 	reg = rxchk_readl(priv, RXCHK_CONTROL);
 	/* Clear L2 header checks, which would prevent BPDUs
 	 * from being received.
@@ -185,7 +185,7 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 	tdma_writel(priv, reg, TDMA_CONTROL);
 
 	/* Default TPID is ETH_P_8021AD, change to ETH_P_8021Q */
-	if (wanted & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, wanted))
 		tdma_writel(priv, ETH_P_8021Q, TDMA_TPID);
 }
 
@@ -1550,7 +1550,7 @@ static int bcm_sysport_init_tx_ring(struct bcm_sysport_priv *priv,
 	/* Adjust the packet size calculations if SYSTEMPORT is responsible
 	 * for HW insertion of VLAN tags
 	 */
-	if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_active_feature_test(priv->netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		reg = VLAN_HLEN << RING_PKT_SIZE_ADJ_SHIFT;
 	tdma_writel(priv, reg, TDMA_DESC_RING_PCP_DEI_VID(index));
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index d1e45b7752d0..59658e99bdc3 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3259,15 +3259,14 @@ bnx2_rx_int(struct bnx2 *bp, struct bnx2_napi *bnapi, int budget)
 		}
 
 		skb_checksum_none_assert(skb);
-		if ((bp->dev->features & NETIF_F_RXCSUM) &&
-			(status & (L2_FHDR_STATUS_TCP_SEGMENT |
-			L2_FHDR_STATUS_UDP_DATAGRAM))) {
+		if (netdev_active_feature_test(bp->dev, NETIF_F_RXCSUM_BIT) &&
+		    (status & (L2_FHDR_STATUS_TCP_SEGMENT | L2_FHDR_STATUS_UDP_DATAGRAM))) {
 
 			if (likely((status & (L2_FHDR_ERRORS_TCP_XSUM |
 					      L2_FHDR_ERRORS_UDP_XSUM)) == 0))
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 		}
-		if ((bp->dev->features & NETIF_F_RXHASH) &&
+		if (netdev_active_feature_test(bp->dev, NETIF_F_RXHASH_BIT) &&
 		    ((status & L2_FHDR_STATUS_USE_RXHASH) ==
 		     L2_FHDR_STATUS_USE_RXHASH))
 			skb_set_hash(skb, rx_hdr->l2_fhdr_hash,
@@ -3587,8 +3586,8 @@ bnx2_set_rx_mode(struct net_device *dev)
 	rx_mode = bp->rx_mode & ~(BNX2_EMAC_RX_MODE_PROMISCUOUS |
 				  BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG);
 	sort_mode = 1 | BNX2_RPM_SORT_USER0_BC_EN;
-	if (!(dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
-	     (bp->flags & BNX2_FLAG_CAN_KEEP_VLAN))
+	if (!netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
+	    (bp->flags & BNX2_FLAG_CAN_KEEP_VLAN))
 		rx_mode |= BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG;
 	if (dev->flags & IFF_PROMISC) {
 		/* Promiscuous mode. */
@@ -7754,7 +7753,7 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 	struct bnx2 *bp = netdev_priv(dev);
 
 	/* TSO with VLAN tag won't work with current firmware */
-	if (features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
 		netdev_features_t tso;
 
 		tso = dev->hw_features & NETIF_F_ALL_TSO;
@@ -7763,8 +7762,8 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 		netdev_vlan_features_clear(dev, NETIF_F_ALL_TSO);
 	}
 
-	if ((!!(features & NETIF_F_HW_VLAN_CTAG_RX) !=
-	    !!(bp->rx_mode & BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG)) &&
+	if ((netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) !=
+	     !!(bp->rx_mode & BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG)) &&
 	    netif_running(dev)) {
 		bnx2_netif_stop(bp, false);
 		dev->features = features;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 44c4d94ad7e3..1095cfb0783a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -413,7 +413,7 @@ static u32 bnx2x_get_rxhash(const struct bnx2x *bp,
 			    enum pkt_hash_types *rxhash_type)
 {
 	/* Get Toeplitz hash from CQE */
-	if ((bp->dev->features & NETIF_F_RXHASH) &&
+	if (netdev_active_feature_test(bp->dev, NETIF_F_RXHASH_BIT) &&
 	    (cqe->status_flags & ETH_FAST_PATH_RX_CQE_RSS_HASH_FLG)) {
 		enum eth_rss_hash_type htype;
 
@@ -1074,7 +1074,7 @@ static int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 
 		skb_checksum_none_assert(skb);
 
-		if (bp->dev->features & NETIF_F_RXCSUM)
+		if (netdev_active_feature_test(bp->dev, NETIF_F_RXCSUM_BIT))
 			bnx2x_csum_validate(skb, cqe, fp,
 					    bnx2x_fp_qstats(bp, fp));
 
@@ -2496,9 +2496,9 @@ static void bnx2x_bz_fp(struct bnx2x *bp, int index)
 	/* set the tpa flag for each queue. The tpa flag determines the queue
 	 * minimal size so it must be set prior to queue memory allocation
 	 */
-	if (bp->dev->features & NETIF_F_LRO)
+	if (netdev_active_feature_test(bp->dev, NETIF_F_LRO_BIT))
 		fp->mode = TPA_MODE_LRO;
-	else if (bp->dev->features & NETIF_F_GRO_HW)
+	else if (netdev_active_feature_test(bp->dev, NETIF_F_GRO_HW_BIT))
 		fp->mode = TPA_MODE_GRO;
 	else
 		fp->mode = TPA_MODE_DISABLED;
@@ -4911,28 +4911,28 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 		/* Revert the requested changes in features if they
 		 * would require internal reload of PF in bnx2x_set_features().
 		 */
-		if (!(features & NETIF_F_RXCSUM) && !bp->disable_tpa) {
+		if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !bp->disable_tpa) {
 			netdev_feature_del(NETIF_F_RXCSUM_BIT, features);
-			if (dev->features & NETIF_F_RXCSUM)
+			if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT))
 				netdev_feature_add(NETIF_F_RXCSUM_BIT,
 						   features);
 		}
 
-		if (changed & NETIF_F_LOOPBACK) {
+		if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed)) {
 			netdev_feature_del(NETIF_F_LOOPBACK_BIT, features);
-			if (dev->features & NETIF_F_LOOPBACK)
+			if (netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT))
 				netdev_feature_add(NETIF_F_LOOPBACK_BIT,
 						   features);
 		}
 	}
 
 	/* TPA requires Rx CSUM offloading */
-	if (!(features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
-	if (!(features & NETIF_F_GRO) || !bnx2x_mtu_allows_gro(dev->mtu))
+	if (!netdev_feature_test(NETIF_F_GRO_BIT, features) || !bnx2x_mtu_allows_gro(dev->mtu))
 		netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
-	if (features & NETIF_F_GRO_HW)
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
 	return features;
@@ -4949,7 +4949,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 
 	/* VFs or non SRIOV PFs should be able to change loopback feature */
 	if (!pci_num_vf(bp->pdev)) {
-		if (features & NETIF_F_LOOPBACK) {
+		if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features)) {
 			if (bp->link_params.loopback_mode != LOOPBACK_BMAC) {
 				bp->link_params.loopback_mode = LOOPBACK_BMAC;
 				bnx2x_reload = true;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 5466966a2243..2a3b18665054 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -3405,9 +3405,9 @@ static void bnx2x_drv_info_ether_stat(struct bnx2x *bp)
 				ether_stat->mac_local + MAC_PAD, MAC_PAD,
 				ETH_ALEN);
 	ether_stat->mtu_size = bp->dev->mtu;
-	if (bp->dev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(bp->dev, NETIF_F_RXCSUM_BIT))
 		ether_stat->feature_flags |= FEATURE_ETH_CHKSUM_OFFLOAD_MASK;
-	if (bp->dev->features & NETIF_F_TSO)
+	if (netdev_active_feature_test(bp->dev, NETIF_F_TSO_BIT))
 		ether_stat->feature_flags |= FEATURE_ETH_LSO_MASK;
 	ether_stat->feature_flags |= bp->common.boot_mode;
 
@@ -13258,7 +13258,7 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
-	if (dev->features & NETIF_F_LRO)
+	if (netdev_active_feature_test(dev, NETIF_F_LRO_BIT))
 		netdev_active_feature_del(dev, NETIF_F_GRO_HW_BIT);
 
 	/* Add Loopback capability to the device */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d1664fdfc980..87d25669c673 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2026,13 +2026,13 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	skb_checksum_none_assert(skb);
 	if (RX_CMP_L4_CS_OK(rxcmp1)) {
-		if (dev->features & NETIF_F_RXCSUM) {
+		if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			skb->csum_level = RX_CMP_ENCAP(rxcmp1);
 		}
 	} else {
 		if (rxcmp1->rx_cmp_cfa_code_errors_v2 & RX_CMP_L4_CS_ERR_BITS) {
-			if (dev->features & NETIF_F_RXCSUM)
+			if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT))
 				bnapi->cp_ring.sw_stats.rx.rx_l4_csum_errors++;
 		}
 	}
@@ -3907,9 +3907,9 @@ void bnxt_set_tpa_flags(struct bnxt *bp)
 	bp->flags &= ~BNXT_FLAG_TPA;
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		return;
-	if (bp->dev->features & NETIF_F_LRO)
+	if (netdev_active_feature_test(bp->dev, NETIF_F_LRO_BIT))
 		bp->flags |= BNXT_FLAG_LRO;
-	else if (bp->dev->features & NETIF_F_GRO_HW)
+	else if (netdev_active_feature_test(bp->dev, NETIF_F_GRO_HW_BIT))
 		bp->flags |= BNXT_FLAG_GRO;
 }
 
@@ -11176,17 +11176,17 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	struct bnxt *bp = netdev_priv(dev);
 	netdev_features_t vlan_features;
 
-	if ((features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features) && !bnxt_rfs_capable(bp))
 		netdev_feature_del(NETIF_F_NTUPLE_BIT, features);
 
 	if ((bp->flags & BNXT_FLAG_NO_AGG_RINGS) || bp->xdp_prog)
 		netdev_features_clear_set(features, NETIF_F_LRO_BIT,
 					  NETIF_F_GRO_HW_BIT);
 
-	if (!(features & NETIF_F_GRO))
+	if (!netdev_feature_test(NETIF_F_GRO_BIT, features))
 		netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
 
-	if (features & NETIF_F_GRO_HW)
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
@@ -11218,9 +11218,9 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	bool update_tpa = false;
 
 	flags &= ~BNXT_FLAG_ALL_CONFIG_FEATS;
-	if (features & NETIF_F_GRO_HW)
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
 		flags |= BNXT_FLAG_GRO;
-	else if (features & NETIF_F_LRO)
+	else if (netdev_feature_test(NETIF_F_LRO_BIT, features))
 		flags |= BNXT_FLAG_LRO;
 
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
@@ -11229,7 +11229,7 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	if (features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 		flags |= BNXT_FLAG_STRIP_VLAN;
 
-	if (features & NETIF_F_NTUPLE)
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features))
 		flags |= BNXT_FLAG_RFS;
 
 	changes = flags ^ bp->flags;
@@ -13638,7 +13638,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_hw_feature_add(dev, NETIF_F_GRO_HW_BIT);
 	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
-	if (dev->features & NETIF_F_GRO_HW)
+	if (netdev_active_feature_test(dev, NETIF_F_GRO_HW_BIT))
 		netdev_active_feature_del(dev, NETIF_F_LRO_BIT);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 28b8efe736f5..cd8676723ba1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -473,7 +473,7 @@ bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
 		return NULL;
 	skb_checksum_none_assert(skb);
 	if (RX_CMP_L4_CS_OK(rxcmp1)) {
-		if (bp->dev->features & NETIF_F_RXCSUM) {
+		if (netdev_active_feature_test(bp->dev, NETIF_F_RXCSUM_BIT)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			skb->csum_level = RX_CMP_ENCAP(rxcmp1);
 		}
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d72dca1bbaf6..711dddfcc1d1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2293,7 +2293,7 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 
 		status = (struct status_64 *)skb->data;
 		dma_length_status = status->length_status;
-		if (dev->features & NETIF_F_RXCSUM) {
+		if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)) {
 			rx_csum = (__force __be16)(status->rx_csum & 0xffff);
 			if (rx_csum) {
 				skb->csum = (__force __wsum)ntohs(rx_csum);
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 720c48bd117f..00f887601a1a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6918,7 +6918,7 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 			tg3_hwclock_to_timestamp(tp, tstamp,
 						 skb_hwtstamps(skb));
 
-		if ((tp->dev->features & NETIF_F_RXCSUM) &&
+		if (netdev_active_feature_test(tp->dev, NETIF_F_RXCSUM_BIT) &&
 		    (desc->type_flags & RXD_FLAG_TCPUDP_CSUM) &&
 		    (((desc->ip_tcp_csum & RXD_TCPCSUM_MASK)
 		      >> RXD_TCPCSUM_SHIFT) == 0xffff))
@@ -8282,7 +8282,7 @@ static void tg3_set_loopback(struct net_device *dev, netdev_features_t features)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	if (features & NETIF_F_LOOPBACK) {
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features)) {
 		if (tp->mac_mode & MAC_MODE_PORT_INT_LPBACK)
 			return;
 
@@ -8320,7 +8320,7 @@ static int tg3_set_features(struct net_device *dev, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev))
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed) && netif_running(dev))
 		tg3_set_loopback(dev, features);
 
 	return 0;
@@ -11648,7 +11648,7 @@ static int tg3_start(struct tg3 *tp, bool reset_phy, bool test_irq,
 	 * Reset loopback feature if it was turned on while the device was down
 	 * make sure that it's installed properly now.
 	 */
-	if (dev->features & NETIF_F_LOOPBACK)
+	if (netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT))
 		tg3_set_loopback(dev, dev->features);
 
 	return 0;
@@ -17746,10 +17746,10 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if ((tg3_flag(tp, HW_TSO_1) ||
 	     tg3_flag(tp, HW_TSO_2) ||
 	     tg3_flag(tp, HW_TSO_3)) &&
-	    (features & NETIF_F_IP_CSUM))
+	    netdev_feature_test(NETIF_F_IP_CSUM_BIT, features))
 		netdev_feature_add(NETIF_F_TSO_BIT, features);
 	if (tg3_flag(tp, HW_TSO_2) || tg3_flag(tp, HW_TSO_3)) {
-		if (features & NETIF_F_IPV6_CSUM)
+		if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features))
 			netdev_feature_add(NETIF_F_TSO6_BIT, features);
 		if (tg3_flag(tp, HW_TSO_3) ||
 		    tg3_asic_rev(tp) == ASIC_REV_5761 ||
@@ -17910,7 +17910,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	}
 
 	netdev_info(dev, "RXcsums[%d] LinkChgREG[%d] MIirq[%d] ASF[%d] TSOcap[%d]\n",
-		    (dev->features & NETIF_F_RXCSUM) != 0,
+		    netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT),
 		    tg3_flag(tp, USE_LINKCHG_REG) != 0,
 		    (tp->phy_flags & TG3_PHYFLG_USE_MI_INTERRUPT) != 0,
 		    tg3_flag(tp, ENABLE_ASF) != 0,
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index b0f1da5175ca..087aa63598bd 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -699,7 +699,7 @@ bnad_cq_process(struct bnad *bnad, struct bna_ccb *ccb, int budget)
 		masked_flags = flags & flags_cksum_prot_mask;
 
 		if (likely
-		    ((bnad->netdev->features & NETIF_F_RXCSUM) &&
+		    (netdev_active_feature_test(bnad->netdev, NETIF_F_RXCSUM_BIT) &&
 		     ((masked_flags == flags_tcp4) ||
 		      (masked_flags == flags_udp4) ||
 		      (masked_flags == flags_tcp6) ||
@@ -709,7 +709,7 @@ bnad_cq_process(struct bnad *bnad, struct bna_ccb *ccb, int budget)
 			skb_checksum_none_assert(skb);
 
 		if ((flags & BNA_CQ_EF_VLAN) &&
-		    (bnad->netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
+		    netdev_active_feature_test(bnad->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), ntohs(cmpl->vlan_tag));
 
 		if (BNAD_RXBUF_IS_SK_BUFF(unmap_q->type))
@@ -2082,7 +2082,7 @@ bnad_init_rx_config(struct bnad *bnad, struct bna_rx_config *rx_config)
 	}
 
 	rx_config->vlan_strip_status =
-		(bnad->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) ?
+		netdev_active_feature_test(bnad->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT) ?
 		BNA_STATUS_T_ENABLED : BNA_STATUS_T_DISABLED;
 }
 
@@ -3350,12 +3350,12 @@ static int bnad_set_features(struct net_device *dev, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(dev)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) && netif_running(dev)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&bnad->bna_lock, flags);
 
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 			bna_rx_vlan_strip_enable(bnad->rx_info[0].rx);
 		else
 			bna_rx_vlan_strip_disable(bnad->rx_info[0].rx);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e608f0c41071..31b258a47077 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1375,7 +1375,7 @@ static int gem_rx(struct macb_queue *queue, struct napi_struct *napi,
 
 		skb->protocol = eth_type_trans(skb, bp->dev);
 		skb_checksum_none_assert(skb);
-		if (bp->dev->features & NETIF_F_RXCSUM &&
+		if (netdev_active_feature_test(bp->dev, NETIF_F_RXCSUM_BIT) &&
 		    !(bp->dev->flags & IFF_PROMISC) &&
 		    GEM_BFEXT(RX_CSUM, ctrl) & GEM_RX_CSUM_CHECKED_MASK)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2093,7 +2093,7 @@ static unsigned int macb_tx_map(struct macb *bp,
 		if (i == queue->tx_head) {
 			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
 			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
-			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
+			if (netdev_active_feature_test(bp->dev, NETIF_F_HW_CSUM_BIT) &&
 			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
 			    !ptp_one_step_sync(skb))
 				ctrl |= MACB_BIT(TX_NOCRC);
@@ -2195,7 +2195,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	struct sk_buff *nskb;
 	u32 fcs;
 
-	if (!(ndev->features & NETIF_F_HW_CSUM) ||
+	if (!netdev_active_feature_test(ndev, NETIF_F_HW_CSUM_BIT) ||
 	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
 	    skb_shinfo(*skb)->gso_size || ptp_one_step_sync(*skb))
 		return 0;
@@ -2674,7 +2674,7 @@ static void macb_configure_dma(struct macb *bp)
 		else
 			dmacfg |= GEM_BIT(ENDIA_DESC); /* CPU in big endian */
 
-		if (bp->dev->features & NETIF_F_HW_CSUM)
+		if (netdev_active_feature_test(bp->dev, NETIF_F_HW_CSUM_BIT))
 			dmacfg |= GEM_BIT(TXCOEN);
 		else
 			dmacfg &= ~GEM_BIT(TXCOEN);
@@ -2710,7 +2710,7 @@ static void macb_init_hw(struct macb *bp)
 		config |= MACB_BIT(BIG);	/* Receive oversized frames */
 	if (bp->dev->flags & IFF_PROMISC)
 		config |= MACB_BIT(CAF);	/* Copy All Frames */
-	else if (macb_is_gem(bp) && bp->dev->features & NETIF_F_RXCSUM)
+	else if (macb_is_gem(bp) && netdev_active_feature_test(bp->dev, NETIF_F_RXCSUM_BIT))
 		config |= GEM_BIT(RXCOEN);
 	if (!(bp->dev->flags & IFF_BROADCAST))
 		config |= MACB_BIT(NBC);	/* No BroadCast */
@@ -2821,7 +2821,7 @@ static void macb_set_rx_mode(struct net_device *dev)
 		cfg &= ~MACB_BIT(CAF);
 
 		/* Enable RX checksum offload only if requested */
-		if (macb_is_gem(bp) && dev->features & NETIF_F_RXCSUM)
+		if (macb_is_gem(bp) && netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT))
 			cfg |= GEM_BIT(RXCOEN);
 	}
 
@@ -3344,7 +3344,7 @@ static void gem_enable_flow_filters(struct macb *bp, bool enable)
 	u32 t2_scr;
 	int num_t2_scr;
 
-	if (!(netdev->features & NETIF_F_NTUPLE))
+	if (!netdev_active_feature_test(netdev, NETIF_F_NTUPLE_BIT))
 		return;
 
 	num_t2_scr = GEM_BFEXT(T2SCR, gem_readl(bp, DCFG8));
@@ -3704,7 +3704,7 @@ static inline void macb_set_txcsum_feature(struct macb *bp,
 		return;
 
 	val = gem_readl(bp, DMACFG);
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
 		val |= GEM_BIT(TXCOEN);
 	else
 		val &= ~GEM_BIT(TXCOEN);
@@ -3722,7 +3722,7 @@ static inline void macb_set_rxcsum_feature(struct macb *bp,
 		return;
 
 	val = gem_readl(bp, NCFGR);
-	if ((features & NETIF_F_RXCSUM) && !(netdev->flags & IFF_PROMISC))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !(netdev->flags & IFF_PROMISC))
 		val |= GEM_BIT(RXCOEN);
 	else
 		val &= ~GEM_BIT(RXCOEN);
@@ -3736,7 +3736,8 @@ static inline void macb_set_rxflow_feature(struct macb *bp,
 	if (!macb_is_gem(bp))
 		return;
 
-	gem_enable_flow_filters(bp, !!(features & NETIF_F_NTUPLE));
+	gem_enable_flow_filters(bp,
+				netdev_feature_test(NETIF_F_NTUPLE_BIT, features));
 }
 
 static int macb_set_features(struct net_device *netdev,
@@ -3748,15 +3749,15 @@ static int macb_set_features(struct net_device *netdev,
 	netdev_features_xor(changed, netdev->features, features);
 
 	/* TX checksum offload */
-	if (changed & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, changed))
 		macb_set_txcsum_feature(bp, features);
 
 	/* RX checksum offload */
-	if (changed & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		macb_set_rxcsum_feature(bp, features);
 
 	/* RX Flow Filters */
-	if (changed & NETIF_F_NTUPLE)
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed))
 		macb_set_rxflow_feature(bp, features);
 
 	return 0;
@@ -5126,7 +5127,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
 	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
 		bp->pm_data.usrio = macb_or_gem_readl(bp, USRIO);
 
-	if (netdev->hw_features & NETIF_F_NTUPLE)
+	if (netdev_hw_feature_test(netdev, NETIF_F_NTUPLE_BIT))
 		bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
 
 	if (bp->ptp_info)
@@ -5195,7 +5196,7 @@ static int __maybe_unused macb_resume(struct device *dev)
 		napi_enable(&queue->napi_tx);
 	}
 
-	if (netdev->hw_features & NETIF_F_NTUPLE)
+	if (netdev_hw_feature_test(netdev, NETIF_F_NTUPLE_BIT))
 		gem_writel_n(bp, ETHT, SCRT2_ETHT, bp->pm_data.scrt2);
 
 	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 5405aeb04200..a626fa1d13d4 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -975,7 +975,7 @@ static int xgmac_hw_init(struct net_device *dev)
 
 	ctrl |= XGMAC_CONTROL_DDIC | XGMAC_CONTROL_JE | XGMAC_CONTROL_ACS |
 		XGMAC_CONTROL_CAR;
-	if (dev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT))
 		ctrl |= XGMAC_CONTROL_IPC;
 	writel(ctrl, ioaddr + XGMAC_CONTROL);
 
@@ -1495,11 +1495,11 @@ static int xgmac_set_features(struct net_device *dev, netdev_features_t features
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	ctrl = readl(ioaddr + XGMAC_CONTROL);
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		ctrl |= XGMAC_CONTROL_IPC;
 	else
 		ctrl &= ~XGMAC_CONTROL_IPC;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 73cb03266549..4353cd50d297 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -659,7 +659,7 @@ liquidio_push_packet(u32 __maybe_unused octeon_id,
 		skb_pull(skb, rh->r_dh.len * BYTES_PER_DHLEN_UNIT);
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
-		if ((netdev->features & NETIF_F_RXCSUM) &&
+		if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
 		    (((rh->r_dh.encap_on) &&
 		      (rh->r_dh.csum_verified & CNNIC_TUN_CSUM_VERIFIED)) ||
 		     (!(rh->r_dh.encap_on) &&
@@ -680,7 +680,7 @@ liquidio_push_packet(u32 __maybe_unused octeon_id,
 		}
 
 		/* inbound VLAN tag */
-		if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 		    rh->r_dh.vlan) {
 			u16 priority = rh->r_dh.priority;
 			u16 vid = rh->r_dh.vlan;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 182c2b8d8aec..a2e18f493d7e 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2720,30 +2720,35 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((request & NETIF_F_RXCSUM) &&
-	    !(lio->dev_capability & NETIF_F_RXCSUM))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_RXCSUM_BIT, request);
 
-	if ((request & NETIF_F_HW_CSUM) &&
-	    !(lio->dev_capability & NETIF_F_HW_CSUM))
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, request);
 
-	if ((request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
+	if (netdev_feature_test(NETIF_F_TSO_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_TSO_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_TSO_BIT, request);
 
-	if ((request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_TSO6_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_TSO6_BIT, request);
 
-	if ((request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
+	if (netdev_feature_test(NETIF_F_LRO_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_LRO_BIT, request);
 
 	/*Disable LRO if RXCSUM is off */
-	if (!(request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
-	    (lio->dev_capability & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	    netdev_active_feature_test(netdev, NETIF_F_LRO_BIT) &&
+	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_LRO_BIT, request);
 
-	if ((request & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    !(lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				 lio->dev_capability))
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, request);
 
 	return request;
@@ -2759,40 +2764,40 @@ static int liquidio_set_features(struct net_device *netdev,
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((features & NETIF_F_LRO) &&
-	    (lio->dev_capability & NETIF_F_LRO) &&
-	    !(netdev->features & NETIF_F_LRO))
+	if (netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability) &&
+	    !netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	else if (!(features & NETIF_F_LRO) &&
-		 (lio->dev_capability & NETIF_F_LRO) &&
-		 (netdev->features & NETIF_F_LRO))
+	else if (!netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+		 netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability) &&
+		 netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_DISABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
 
 	/* Sending command to firmware to enable/disable RX checksum
 	 * offload settings using ethtool
 	 */
-	if (!(netdev->features & NETIF_F_RXCSUM) &&
-	    (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-	    (features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->enc_dev_capability) &&
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev,
 					    OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_ENABLE);
-	else if ((netdev->features & NETIF_F_RXCSUM) &&
-		 (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-		 !(features & NETIF_F_RXCSUM))
+	else if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
+		 netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->enc_dev_capability) &&
+		 !netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_DISABLE);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    (lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) &&
+	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, lio->dev_capability) &&
+	    !netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_VLAN_FILTER_CTL,
 				     OCTNET_CMD_VLAN_FILTER_ENABLE);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-		 (lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-		 (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) &&
+		 netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, lio->dev_capability) &&
+		 netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_VLAN_FILTER_CTL,
 				     OCTNET_CMD_VLAN_FILTER_DISABLE);
 
@@ -3668,7 +3673,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		else
 			octeon_dev->priv_flags = 0x0;
 
-		if (netdev->features & NETIF_F_LRO)
+		if (netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 			liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 					     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index c9807b759702..51d202c0bf52 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1818,26 +1818,30 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((request & NETIF_F_RXCSUM) &&
-	    !(lio->dev_capability & NETIF_F_RXCSUM))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_RXCSUM_BIT, request);
 
-	if ((request & NETIF_F_HW_CSUM) &&
-	    !(lio->dev_capability & NETIF_F_HW_CSUM))
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, request);
 
-	if ((request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
+	if (netdev_feature_test(NETIF_F_TSO_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_TSO_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_TSO_BIT, request);
 
-	if ((request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_TSO6_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_TSO6_BIT, request);
 
-	if ((request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
+	if (netdev_feature_test(NETIF_F_LRO_BIT, request) &&
+	    !netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_LRO_BIT, request);
 
 	/* Disable LRO if RXCSUM is off */
-	if (!(request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
-	    (lio->dev_capability & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	    netdev_active_feature_test(netdev, NETIF_F_LRO_BIT) &&
+	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		netdev_feature_del(NETIF_F_LRO_BIT, request);
 
 	return request;
@@ -1854,24 +1858,25 @@ static int liquidio_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (!(changed & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	if ((features & NETIF_F_LRO) && (lio->dev_capability & NETIF_F_LRO))
+	if (netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	else if (!(features & NETIF_F_LRO) &&
-		 (lio->dev_capability & NETIF_F_LRO))
+	else if (!netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+		 netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_DISABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	if (!(netdev->features & NETIF_F_RXCSUM) &&
-	    (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-	    (features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->dev_capability) &&
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_ENABLE);
-	else if ((netdev->features & NETIF_F_RXCSUM) &&
-		 (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-		 !(features & NETIF_F_RXCSUM))
+	else if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
+		 netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->enc_dev_capability) &&
+		 !netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_DISABLE);
 
@@ -2190,7 +2195,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		else
 			octeon_dev->priv_flags = 0x0;
 
-		if (netdev->features & NETIF_F_LRO)
+		if (netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 			liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 					     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 0c1a0eb9d1a6..979a03faca7a 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -732,7 +732,7 @@ static inline void nicvf_set_rxhash(struct net_device *netdev,
 	u8 hash_type;
 	u32 hash;
 
-	if (!(netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	switch (cqe_rx->rss_alg) {
@@ -823,7 +823,7 @@ static void nicvf_rcv_pkt_handler(struct net_device *netdev,
 	nicvf_set_rxhash(netdev, cqe_rx, skb);
 
 	skb_record_rx_queue(skb, rq_idx);
-	if (netdev->hw_features & NETIF_F_RXCSUM) {
+	if (netdev_hw_feature_test(netdev, NETIF_F_RXCSUM_BIT)) {
 		/* HW by default verifies TCP/UDP/SCTP checksums */
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	} else {
@@ -837,7 +837,7 @@ static void nicvf_rcv_pkt_handler(struct net_device *netdev,
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       ntohs((__force __be16)cqe_rx->vlan_tci));
 
-	if (napi && (netdev->features & NETIF_F_GRO))
+	if (napi && netdev_active_feature_test(netdev, NETIF_F_GRO_BIT))
 		napi_gro_receive(napi, skb);
 	else
 		netif_receive_skb(skb);
@@ -1768,7 +1768,7 @@ static int nicvf_config_loopback(struct nicvf *nic,
 
 	mbx.lbk.msg = NIC_MBOX_MSG_LOOPBACK;
 	mbx.lbk.vf_id = nic->vf_id;
-	mbx.lbk.enable = (features & NETIF_F_LOOPBACK) != 0;
+	mbx.lbk.enable = netdev_feature_test(NETIF_F_LOOPBACK_BIT, features);
 
 	return nicvf_send_msg_to_pf(nic, &mbx);
 }
@@ -1778,7 +1778,7 @@ static netdev_features_t nicvf_fix_features(struct net_device *netdev,
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
-	if ((features & NETIF_F_LOOPBACK) &&
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features) &&
 	    netif_running(netdev) && !nic->loopback_supported)
 		netdev_feature_del(NETIF_F_LOOPBACK_BIT, features);
 
@@ -1792,10 +1792,10 @@ static int nicvf_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		nicvf_config_vlan_stripping(nic, features);
 
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed) && netif_running(netdev))
 		return nicvf_config_loopback(nic, features);
 
 	return 0;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 06397cc8bb36..c9080dbccca1 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -715,7 +715,7 @@ void nicvf_config_vlan_stripping(struct nicvf *nic, netdev_features_t features)
 	rq_cfg = nicvf_queue_reg_read(nic, NIC_QSET_RQ_GEN_CFG, 0);
 
 	/* Enable first VLAN stripping */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		rq_cfg |= (1ULL << 25);
 	else
 		rq_cfg &= ~(1ULL << 25);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 00e2492d944b..30e371efcb77 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -187,7 +187,7 @@ static void link_start(struct port_info *p)
 
 static void enable_hw_csum(struct adapter *adapter)
 {
-	if (adapter->port[0].dev->hw_features & NETIF_F_TSO)
+	if (netdev_hw_feature_test(adapter->port[0].dev, NETIF_F_TSO_BIT))
 		t1_tp_set_ip_checksum_offload(adapter->tp, 1);	/* for TSO only */
 	t1_tp_set_tcp_checksum_offload(adapter->tp, 1);
 }
@@ -870,7 +870,7 @@ static netdev_features_t t1_fix_features(struct net_device *dev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -884,7 +884,7 @@ static int t1_set_features(struct net_device *dev, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t1_vlan_mode(adapter, features);
 
 	return 0;
@@ -1057,7 +1057,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 
 		netdev->netdev_ops = &cxgb_netdev_ops;
-		netdev->hard_header_len += (netdev->hw_features & NETIF_F_TSO) ?
+		netdev->hard_header_len += netdev_hw_feature_test(netdev, NETIF_F_TSO_BIT) ?
 			sizeof(struct cpl_tx_pkt_lso) : sizeof(struct cpl_tx_pkt);
 
 		netif_napi_add(netdev, &adapter->napi, t1_poll, 64);
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 861edff5ed89..0e1afce8d3a5 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -728,7 +728,7 @@ void t1_vlan_mode(struct adapter *adapter, netdev_features_t features)
 {
 	struct sge *sge = adapter->sge;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		sge->sge_control |= F_VLAN_XTRACT;
 	else
 		sge->sge_control &= ~F_VLAN_XTRACT;
@@ -913,7 +913,7 @@ void t1_sge_intr_enable(struct sge *sge)
 	u32 en = SGE_INT_ENABLE;
 	u32 val = readl(sge->adapter->regs + A_PL_ENABLE);
 
-	if (sge->adapter->port[0].dev->hw_features & NETIF_F_TSO)
+	if (netdev_hw_feature_test(sge->adapter->port[0].dev, NETIF_F_TSO_BIT))
 		en &= ~F_PACKET_TOO_BIG;
 	writel(en, sge->adapter->regs + A_SG_INT_ENABLE);
 	writel(val | SGE_PL_INTR_MASK, sge->adapter->regs + A_PL_ENABLE);
@@ -937,7 +937,7 @@ bool t1_sge_intr_error_handler(struct sge *sge)
 	u32 cause = readl(adapter->regs + A_SG_INT_CAUSE);
 	bool wake = false;
 
-	if (adapter->port[0].dev->hw_features & NETIF_F_TSO)
+	if (netdev_hw_feature_test(adapter->port[0].dev, NETIF_F_TSO_BIT))
 		cause &= ~F_PACKET_TOO_BIG;
 	if (cause & F_RESPQ_EXHAUSTED)
 		sge->stats.respQ_empty++;
@@ -1377,7 +1377,7 @@ static void sge_rx(struct sge *sge, struct freelQ *fl, unsigned int len)
 	dev = adapter->port[p->iff].dev;
 
 	skb->protocol = eth_type_trans(skb, dev);
-	if ((dev->features & NETIF_F_RXCSUM) && p->csum == 0xffff &&
+	if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT) && p->csum == 0xffff &&
 	    skb->protocol == htons(ETH_P_IP) &&
 	    (skb->data[9] == IPPROTO_TCP || skb->data[9] == IPPROTO_UDP)) {
 		++st->rx_cso_good;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 7c3c4729363a..3b7348ffc71d 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1184,15 +1184,15 @@ static void cxgb_vlan_mode(struct net_device *dev, netdev_features_t features)
 
 	if (adapter->params.rev > 0) {
 		t3_set_vlan_accel(adapter, 1 << pi->port_id,
-				  features & NETIF_F_HW_VLAN_CTAG_RX);
+				  netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features));
 	} else {
 		/* single control for all ports */
-		unsigned int i, have_vlans = features & NETIF_F_HW_VLAN_CTAG_RX;
+		unsigned int i, have_vlans = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+								 features);
 
 		for_each_port(adapter, i)
-			have_vlans |=
-				adapter->port[i]->features &
-				NETIF_F_HW_VLAN_CTAG_RX;
+			have_vlans |= netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+							  adapter->port[i]->features);
 
 		t3_set_vlan_accel(adapter, 1, have_vlans);
 	}
@@ -2286,7 +2286,7 @@ static int cxgb_siocdevprivate(struct net_device *dev,
 		t.fl_size[0] = q->fl_size;
 		t.fl_size[1] = q->jumbo_size;
 		t.polling = q->polling;
-		t.lro = !!(dev->features & NETIF_F_GRO);
+		t.lro = netdev_active_feature_test(dev, NETIF_F_GRO_BIT);
 		t.intr_lat = q->coalesce_usecs;
 		t.cong_thres = q->cong_thres;
 		t.qnum = q1;
@@ -2595,7 +2595,7 @@ static netdev_features_t cxgb_fix_features(struct net_device *dev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -2608,7 +2608,7 @@ static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		cxgb_vlan_mode(dev, features);
 
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 62dfbdd33365..45448ff151a1 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -2096,7 +2096,7 @@ static void rx_eth(struct adapter *adap, struct sge_rspq *rq,
 	skb_pull(skb, sizeof(*p) + pad);
 	skb->protocol = eth_type_trans(skb, adap->port[p->iff]);
 	pi = netdev_priv(skb->dev);
-	if ((skb->dev->features & NETIF_F_RXCSUM) && p->csum_valid &&
+	if (netdev_active_feature_test(skb->dev, NETIF_F_RXCSUM_BIT) && p->csum_valid &&
 	    p->csum == htons(0xffff) && !p->fragment) {
 		qs->port_stats[SGE_PSTAT_RX_CSUM_GOOD]++;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2177,8 +2177,8 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 		offset = 2 + sizeof(struct cpl_rx_pkt);
 		cpl = qs->lro_va = sd->pg_chunk.va + 2;
 
-		if ((qs->netdev->features & NETIF_F_RXCSUM) &&
-		     cpl->csum_valid && cpl->csum == htons(0xffff)) {
+		if (netdev_active_feature_test(qs->netdev, NETIF_F_RXCSUM_BIT) &&
+		    cpl->csum_valid && cpl->csum == htons(0xffff)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			qs->port_stats[SGE_PSTAT_RX_CSUM_GOOD]++;
 		} else
@@ -2339,7 +2339,7 @@ static int process_responses(struct adapter *adap, struct sge_qset *qs,
 
 	while (likely(budget_left && is_new_response(r, q))) {
 		int packet_complete, eth, ethpad = 2;
-		int lro = !!(qs->netdev->features & NETIF_F_GRO);
+		int lro = netdev_active_feature_test(qs->netdev, NETIF_F_GRO_BIT);
 		struct sk_buff *skb = NULL;
 		u32 len, flags;
 		__be32 rss_hi, rss_lo;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 10aa8786c4d3..ec054538e224 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -514,7 +514,8 @@ static int link_start(struct net_device *dev)
 	 */
 	ret = t4_set_rxmode(pi->adapter, mb, pi->viid, pi->viid_mirror,
 			    dev->mtu, -1, -1, -1,
-			    !!(dev->features & NETIF_F_HW_VLAN_CTAG_RX), true);
+			    netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT),
+			    true);
 	if (ret == 0)
 		ret = cxgb4_update_mac_filt(pi, pi->viid, &pi->xact_addr_filt,
 					    dev->dev_addr, true, &pi->smt_idx);
@@ -1278,12 +1279,13 @@ static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 	int err;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_HW_VLAN_CTAG_RX))
+	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		return 0;
 
 	err = t4_set_rxmode(pi->adapter, pi->adapter->mbox, pi->viid,
 			    pi->viid_mirror, -1, -1, -1, -1,
-			    !!(features & NETIF_F_HW_VLAN_CTAG_RX), true);
+			    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features),
+			    true);
 	if (unlikely(err)) {
 		dev->features = features;
 		netdev_active_feature_change(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
@@ -1464,7 +1466,8 @@ static int cxgb4_port_mirror_start(struct net_device *dev)
 	ret = t4_set_rxmode(adap, adap->mbox, pi->viid, pi->viid_mirror,
 			    dev->mtu, (dev->flags & IFF_PROMISC) ? 1 : 0,
 			    (dev->flags & IFF_ALLMULTI) ? 1 : 0, 1,
-			    !!(dev->features & NETIF_F_HW_VLAN_CTAG_RX), true);
+			    netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT),
+			    true);
 	if (ret) {
 		dev_err(adap->pdev_dev,
 			"Failed start up Rx mode for Mirror VI 0x%x, ret: %d\n",
@@ -3861,7 +3864,7 @@ static netdev_features_t cxgb_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
 	/* Disable GRO, if RX_CSUM is disabled */
-	if (!(features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_del(NETIF_F_GRO_BIT, features);
 
 	return features;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h
index 70a07b7cca56..a33661d36211 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h
@@ -41,7 +41,7 @@ static inline bool can_tc_u32_offload(struct net_device *dev)
 {
 	struct adapter *adap = netdev2adap(dev);
 
-	return (dev->features & NETIF_F_HW_TC) && adap->tc_u32 ? true : false;
+	return netdev_active_feature_test(dev, NETIF_F_HW_TC_BIT) && adap->tc_u32 ? true : false;
 }
 
 int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index ee52e3b1d74f..e47042f56ef0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3468,7 +3468,7 @@ static void do_gro(struct sge_eth_rxq *rxq, const struct pkt_gl *gl,
 	if (pi->rxtstamp)
 		cxgb4_sgetim_to_hwtstamp(adapter, skb_hwtstamps(skb),
 					 gl->sgetstamp);
-	if (rxq->rspq.netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(rxq->rspq.netdev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, (__force u32)pkt->rsshdr.hash_val,
 			     PKT_HASH_TYPE_L3);
 
@@ -3710,7 +3710,7 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 	}
 
 	csum_ok = pkt->csum_calc && !err_vec &&
-		  (q->netdev->features & NETIF_F_RXCSUM);
+		  (netdev_active_feature_test(q->netdev, NETIF_F_RXCSUM_BIT));
 
 	if (err_vec)
 		rxq->stats.bad_rx_pkts++;
@@ -3723,7 +3723,7 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 
 	if (((pkt->l2info & htonl(RXF_TCP_F)) ||
 	     tnl_hdr_len) &&
-	    (q->netdev->features & NETIF_F_GRO) && csum_ok && !pkt->ip_frag) {
+	    netdev_active_feature_test(q->netdev, NETIF_F_GRO_BIT) && csum_ok && !pkt->ip_frag) {
 		do_gro(rxq, si, pkt, tnl_hdr_len);
 		return 0;
 	}
@@ -3754,7 +3754,7 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 
 	skb->protocol = eth_type_trans(skb, q->netdev);
 	skb_record_rx_queue(skb, q->idx);
-	if (skb->dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(skb->dev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, (__force u32)pkt->rsshdr.hash_val,
 			     PKT_HASH_TYPE_L3);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 64de70b13ded..1dc39903d87c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1181,7 +1181,7 @@ static netdev_features_t cxgb4vf_fix_features(struct net_device *dev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -1196,9 +1196,10 @@ static int cxgb4vf_set_features(struct net_device *dev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t4vf_set_rxmode(pi->adapter, pi->viid, -1, -1, -1, -1,
-				features & NETIF_F_HW_VLAN_CTAG_TX, 0);
+				netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features),
+				0);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 43b2ceb6aa32..e40a46528021 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -1614,7 +1614,7 @@ int t4vf_ethrx_handler(struct sge_rspq *rspq, const __be64 *rsp,
 	struct sk_buff *skb;
 	const struct cpl_rx_pkt *pkt = (void *)rsp;
 	bool csum_ok = pkt->csum_calc && !pkt->err_vec &&
-		       (rspq->netdev->features & NETIF_F_RXCSUM);
+		       netdev_active_feature_test(rspq->netdev, NETIF_F_RXCSUM_BIT);
 	struct sge_eth_rxq *rxq = container_of(rspq, struct sge_eth_rxq, rspq);
 	struct adapter *adapter = rspq->adapter;
 	struct sge *s = &adapter->sge;
@@ -1625,7 +1625,7 @@ int t4vf_ethrx_handler(struct sge_rspq *rspq, const __be64 *rsp,
 	 * enabled, handle the packet in the GRO path.
 	 */
 	if ((pkt->l2info & cpu_to_be32(RXF_TCP_F)) &&
-	    (rspq->netdev->features & NETIF_F_GRO) && csum_ok &&
+	    netdev_active_feature_test(rspq->netdev, NETIF_F_GRO_BIT) && csum_ok &&
 	    !pkt->ip_frag) {
 		do_gro(rxq, gl, pkt);
 		return 0;
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 1e55b12fee51..5c521ed8175f 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -135,7 +135,7 @@ static int chtls_inline_feature(struct tls_toe_device *dev)
 
 	for (i = 0; i < cdev->lldi->nports; i++) {
 		netdev = cdev->ports[i];
-		if (netdev->features & NETIF_F_HW_TLS_RECORD)
+		if (netdev_active_feature_test(netdev, NETIF_F_HW_TLS_RECORD_BIT))
 			return 1;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 7e1cca8b787b..9ad7c5b0734a 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1360,7 +1360,7 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 		skb_put(skb, bytes_written);
 		skb->protocol = eth_type_trans(skb, netdev);
 		skb_record_rx_queue(skb, q_number);
-		if ((netdev->features & NETIF_F_RXHASH) && rss_hash &&
+		if (netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT) && rss_hash &&
 		    (type == 3)) {
 			switch (rss_type) {
 			case CQ_ENET_RQ_DESC_RSS_TYPE_TCP_IPv4:
@@ -1403,7 +1403,7 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 		 * inner csum_ok. outer_csum_ok is set by hw when outer udp
 		 * csum is correct or is zero.
 		 */
-		if ((netdev->features & NETIF_F_RXCSUM) && !csum_not_calc &&
+		if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) && !csum_not_calc &&
 		    tcp_udp_csum_ok && outer_csum_ok &&
 		    (ipv4_csum_ok || ipv6)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1414,7 +1414,7 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
 
 		skb_mark_napi_id(skb, &enic->napi[rq->index]);
-		if (!(netdev->features & NETIF_F_GRO))
+		if (!netdev_active_feature_test(netdev, NETIF_F_GRO_BIT))
 			netif_receive_skb(skb);
 		else
 			napi_gro_receive(&enic->napi[q_number], skb);
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 96423bf6ed2d..cc3865fb7d83 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1991,7 +1991,7 @@ static int gmac_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
-	int enable = features & NETIF_F_RXCSUM;
+	int enable = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
 	unsigned long flags;
 	u32 reg;
 
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index f859ea1e8fdb..650c37096cfe 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -591,11 +591,12 @@ static int dm9000_set_features(struct net_device *dev,
 	unsigned long flags;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	spin_lock_irqsave(&dm->lock, flags);
-	iow(dm, DM9000_RCSR, (features & NETIF_F_RXCSUM) ? RCSR_CSUM : 0);
+	iow(dm, DM9000_RCSR,
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, features) ? RCSR_CSUM : 0);
 	spin_unlock_irqrestore(&dm->lock, flags);
 
 	return 0;
@@ -913,9 +914,9 @@ dm9000_init_dm9000(struct net_device *dev)
 	db->io_mode = ior(db, DM9000_ISR) >> 6;	/* ISR bit7:6 keeps I/O mode */
 
 	/* Checksum mode */
-	if (dev->hw_features & NETIF_F_RXCSUM)
+	if (netdev_hw_feature_test(dev, NETIF_F_RXCSUM_BIT))
 		iow(db, DM9000_RCSR,
-			(dev->features & NETIF_F_RXCSUM) ? RCSR_CSUM : 0);
+			netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT) ? RCSR_CSUM : 0);
 
 	iow(db, DM9000_GPCR, GPCR_GEP_CNTL);	/* Let GPIO0 output */
 	iow(db, DM9000_GPR, 0);
@@ -1171,7 +1172,7 @@ dm9000_rx(struct net_device *dev)
 
 			/* Pass to upper layer */
 			skb->protocol = eth_type_trans(skb, dev);
-			if (dev->features & NETIF_F_RXCSUM) {
+			if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)) {
 				if ((((rxbyte & 0x1c) << 3) & rxbyte) == 0)
 					skb->ip_summed = CHECKSUM_UNNECESSARY;
 				else
diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index a523ddda7609..ce2c0c6d940c 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -802,7 +802,7 @@ static int dm9051_loop_rx(struct board_info *db)
 			return ret;
 
 		skb->protocol = eth_type_trans(skb, db->ndev);
-		if (db->ndev->features & NETIF_F_RXCSUM)
+		if (netdev_active_feature_test(db->ndev, NETIF_F_RXCSUM_BIT))
 			skb_checksum_none_assert(skb);
 		netif_rx(skb);
 		db->ndev->stats.rx_bytes += rxlen;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index fc1345fa42f6..6ea623d6ddf4 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2407,14 +2407,14 @@ static void be_rx_compl_process(struct be_rx_obj *rxo, struct napi_struct *napi,
 
 	skb_fill_rx_data(rxo, skb, rxcp);
 
-	if (likely((netdev->features & NETIF_F_RXCSUM) && csum_passed(rxcp)))
+	if (likely(netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) && csum_passed(rxcp)))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	else
 		skb_checksum_none_assert(skb);
 
 	skb->protocol = eth_type_trans(skb, netdev);
 	skb_record_rx_queue(skb, rxo - &adapter->rx_obj[0]);
-	if (netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, rxcp->rss_hash, PKT_HASH_TYPE_L3);
 
 	skb->csum_level = rxcp->tunneled;
@@ -2472,7 +2472,7 @@ static void be_rx_compl_process_gro(struct be_rx_obj *rxo,
 	skb->data_len = rxcp->pkt_size;
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb_record_rx_queue(skb, rxo - &adapter->rx_obj[0]);
-	if (adapter->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, rxcp->rss_hash, PKT_HASH_TYPE_L3);
 
 	skb->csum_level = rxcp->tunneled;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 4d1dc4c82541..1792c85ca043 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1061,8 +1061,8 @@ static int tsnep_netdev_set_features(struct net_device *netdev,
 	int retval = 0;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_LOOPBACK) {
-		enable = !!(features & NETIF_F_LOOPBACK);
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed)) {
+		enable = netdev_feature_test(NETIF_F_LOOPBACK_BIT, features);
 		retval = tsnep_phy_loopback(adapter, enable);
 	}
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 0ba3df97b8c8..1b6fcc214160 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -330,7 +330,7 @@ static void ftgmac100_start_hw(struct ftgmac100 *priv)
 		maccr |= FTGMAC100_MACCR_HT_MULTI_EN;
 
 	/* Vlan filtering enabled */
-	if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(priv->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		maccr |= FTGMAC100_MACCR_RM_VLAN;
 
 	/* Hit the HW */
@@ -514,7 +514,7 @@ static bool ftgmac100_rx_packet(struct ftgmac100 *priv, int *processed)
 	 * by HW as one of the supported checksummed protocols before
 	 * we accept the HW test results.
 	 */
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)) {
 		u32 err_bits = FTGMAC100_RXDES1_TCP_CHKSUM_ERR |
 			FTGMAC100_RXDES1_UDP_CHKSUM_ERR |
 			FTGMAC100_RXDES1_IP_CHKSUM_ERR;
@@ -529,7 +529,7 @@ static bool ftgmac100_rx_packet(struct ftgmac100 *priv, int *processed)
 	skb_put(skb, size);
 
 	/* Extract vlan tag */
-	if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    (csum_vlan & FTGMAC100_RXDES1_VLANTAG_AVAIL))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       csum_vlan & 0xffff);
@@ -1604,11 +1604,11 @@ static int ftgmac100_set_features(struct net_device *netdev,
 
 	netdev_features_xor(changed, netdev->features, features);
 	/* Update the vlan filtering bit */
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		u32 maccr;
 
 		maccr = ioread32(priv->base + FTGMAC100_OFFSET_MACCR);
-		if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_active_feature_test(priv->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 			maccr |= FTGMAC100_MACCR_RM_VLAN;
 		else
 			maccr &= ~FTGMAC100_MACCR_RM_VLAN;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index abfe54500719..546002f864d0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1735,7 +1735,7 @@ static u8 rx_csum_offload(const struct dpaa_priv *priv, const struct qm_fd *fd)
 	 * We know there were no parser errors (and implicitly no
 	 * L4 csum error), otherwise we wouldn't be here.
 	 */
-	if ((priv->net_dev->features & NETIF_F_RXCSUM) &&
+	if (netdev_active_feature_test(priv->net_dev, NETIF_F_RXCSUM_BIT) &&
 	    (be32_to_cpu(fd->status) & FM_FD_STAT_L4CV))
 		return CHECKSUM_UNNECESSARY;
 
@@ -2734,7 +2734,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	}
 
 	/* Extract the hash stored in the headroom before running XDP */
-	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use &&
+	if (netdev_active_feature_test(net_dev, NETIF_F_RXHASH_BIT) && priv->keygen_in_use &&
 	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
 					      &hash_offset)) {
 		hash = be32_to_cpu(*(u32 *)(vaddr + hash_offset));
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index ebba24e81ff9..ec4cfea8b170 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -122,7 +122,7 @@ static void dpaa2_eth_validate_rx_csum(struct dpaa2_eth_priv *priv,
 	skb_checksum_none_assert(skb);
 
 	/* HW checksum validation is disabled, nothing to do here */
-	if (!(priv->net_dev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(priv->net_dev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* Read checksum validation bits */
@@ -2427,15 +2427,15 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 	int err;
 
 	netdev_features_xor(changed, net_dev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
+		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features);
 		err = dpaa2_eth_set_rx_vlan_filtering(priv, enable);
 		if (err)
 			return err;
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
-		enable = !!(features & NETIF_F_RXCSUM);
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
+		enable = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
 		err = dpaa2_eth_set_rx_csum(priv, enable);
 		if (err)
 			return err;
@@ -4691,7 +4691,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_netdev_init;
 
 	/* Configure checksum offload based on current interface flags */
-	err = dpaa2_eth_set_rx_csum(priv, !!(net_dev->features & NETIF_F_RXCSUM));
+	err = dpaa2_eth_set_rx_csum(priv,
+				    netdev_active_feature_test(net_dev, NETIF_F_RXCSUM_BIT));
 	if (err)
 		goto err_csum;
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 171c13c01658..f0edb74e509d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -989,7 +989,7 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
 
 	/* TODO: hashing */
-	if (rx_ring->ndev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(rx_ring->ndev, NETIF_F_RXCSUM_BIT)) {
 		u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);
 
 		skb->csum = csum_unfold((__force __sum16)~htons(inet_csum));
@@ -2059,7 +2059,7 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
 	tbmr = ENETC_TBMR_EN;
-	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_active_feature_test(tx_ring->ndev, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		tbmr |= ENETC_TBMR_VIH;
 
 	/* enable ring */
@@ -2100,7 +2100,7 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	if (rx_ring->ext_en)
 		rbmr |= ENETC_RBMR_BDS;
 
-	if (rx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(rx_ring->ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		rbmr |= ENETC_RBMR_VTE;
 
 	rx_ring->rcir = hw->reg + ENETC_BDR(RX, idx, ENETC_RBCIR);
@@ -2648,19 +2648,21 @@ int enetc_set_features(struct net_device *ndev,
 	int err = 0;
 
 	netdev_features_xor(changed, ndev->features, features);
-	if (changed & NETIF_F_RXHASH)
-		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed))
+		enetc_set_rss(ndev,
+			      netdev_feature_test(NETIF_F_RXHASH_BIT, features));
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		enetc_enable_rxvlan(ndev,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_RX));
+				    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features));
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, changed))
 		enetc_enable_txvlan(ndev,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
+				    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features));
 
-	if (changed & NETIF_F_HW_TC)
-		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+	if (netdev_feature_test(NETIF_F_HW_TC_BIT, changed))
+		err = enetc_set_psfp(ndev,
+				     netdev_feature_test(NETIF_F_HW_TC_BIT, features));
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 6cac44808e60..c181e3db7962 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -712,17 +712,18 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, ndev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
 
-		if (!!(features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 			enetc_disable_si_vlan_promisc(pf, 0);
 		else
 			enetc_enable_si_vlan_promisc(pf, 0);
 	}
 
-	if (changed & NETIF_F_LOOPBACK)
-		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed))
+		enetc_set_loopback(ndev,
+				   netdev_feature_test(NETIF_F_LOOPBACK_BIT, features));
 
 	return enetc_set_features(ndev, features);
 }
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6a1513c91e77..cdffbf75e9ca 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1632,7 +1632,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 
 		/* If this is a VLAN packet remove the VLAN Tag */
 		vlan_packet_rcvd = false;
-		if ((ndev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (netdev_active_feature_test(ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 		    fep->bufdesc_ex &&
 		    (ebdp->cbd_esc & cpu_to_fec32(BD_ENET_RX_VLAN))) {
 			/* Push and remove the vlan tag */
@@ -3456,8 +3456,8 @@ static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 	netdev->features = features;
 
 	/* Receive checksum has been changed */
-	if (changed & NETIF_F_RXCSUM) {
-		if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 			fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 		else
 			fep->csum_flags &= ~FLAG_RX_CSUM_ENABLED;
@@ -3471,7 +3471,7 @@ static int fec_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (netif_running(netdev) && changed & NETIF_F_RXCSUM) {
+	if (netif_running(netdev) && netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		napi_disable(&fep->napi);
 		netif_tx_lock_bh(netdev);
 		fec_stop(netdev);
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 7a4de2bd3418..62b5df3e3fda 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -161,8 +161,8 @@ static void gfar_rx_offload_en(struct gfar_private *priv)
 	/* set this when rx hw offload (TOE) functions are being used */
 	priv->uses_rxfcb = 0;
 
-	if (priv->ndev->features & NETIF_F_RXCSUM ||
-	    priv->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(priv->ndev, NETIF_F_RXCSUM_BIT) ||
+	    netdev_active_feature_test(priv->ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		priv->uses_rxfcb = 1;
 
 	if (priv->hwts_rx_en || priv->rx_filer_enable)
@@ -184,7 +184,7 @@ static void gfar_mac_rx_config(struct gfar_private *priv)
 	if (priv->ndev->flags & IFF_PROMISC)
 		rctrl |= RCTRL_PROM;
 
-	if (priv->ndev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(priv->ndev, NETIF_F_RXCSUM_BIT))
 		rctrl |= RCTRL_CHECKSUMMING;
 
 	if (priv->extended_hash)
@@ -199,7 +199,7 @@ static void gfar_mac_rx_config(struct gfar_private *priv)
 	if (priv->hwts_rx_en)
 		rctrl |= RCTRL_PRSDEP_INIT | RCTRL_TS_ENABLE;
 
-	if (priv->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(priv->ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		rctrl |= RCTRL_VLEX | RCTRL_PRSDEP_INIT;
 
 	/* Clear the LFC bit */
@@ -218,7 +218,7 @@ static void gfar_mac_tx_config(struct gfar_private *priv)
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
 	u32 tctrl = 0;
 
-	if (priv->ndev->features & NETIF_F_IP_CSUM)
+	if (netdev_active_feature_test(priv->ndev, NETIF_F_IP_CSUM_BIT))
 		tctrl |= TCTRL_INIT_CSUM;
 
 	if (priv->prio_sched_en)
@@ -229,7 +229,7 @@ static void gfar_mac_tx_config(struct gfar_private *priv)
 		gfar_write(&regs->tr47wt, DEFAULT_WRRS_WEIGHT);
 	}
 
-	if (priv->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_active_feature_test(priv->ndev, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		tctrl |= TCTRL_VLINS;
 
 	gfar_write(&regs->tctrl, tctrl);
@@ -2483,14 +2483,14 @@ static void gfar_process_frame(struct net_device *ndev, struct sk_buff *skb)
 	/* Trim off the FCS */
 	pskb_trim(skb, skb->len - ETH_FCS_LEN);
 
-	if (ndev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT))
 		gfar_rx_checksum(skb, fcb);
 
 	/* There's need to check for NETIF_F_HW_VLAN_CTAG_RX here.
 	 * Even if vlan rx accel is disabled, on some chips
 	 * RXFCB_VLN is pseudo randomly set.
 	 */
-	if (ndev->features & NETIF_F_HW_VLAN_CTAG_RX &&
+	if (netdev_active_feature_test(ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    be16_to_cpu(fcb->flags) & RXFCB_VLN)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       be16_to_cpu(fcb->vlctl));
@@ -3265,7 +3265,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
 		priv->padding = 8 + DEFAULT_PADDING;
 
-	if (dev->features & NETIF_F_IP_CSUM ||
+	if (netdev_active_feature_test(dev, NETIF_F_IP_CSUM_BIT) ||
 	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
 		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 6bb30e21d8db..2b8ecdab0f53 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -514,7 +514,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 
 	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & netdev_ctag_vlan_offload_features) &&
-	    !(changed & NETIF_F_RXCSUM))
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	while (test_and_set_bit_lock(GFAR_RESETTING, &priv->state))
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
index 29a6c2ede43a..fcd72a474ee2 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -432,10 +432,10 @@ static void fun_handle_cqe_pkt(struct funeth_rxq *q, struct funeth_txq *xdp_q)
 
 	skb_record_rx_queue(skb, q->qidx);
 	cv = be16_to_cpu(rxreq->pkt_cv);
-	if (likely((q->netdev->features & NETIF_F_RXHASH) && rxreq->hash))
+	if (likely(netdev_active_feature_test(q->netdev, NETIF_F_RXHASH_BIT) && rxreq->hash))
 		skb_set_hash(skb, be32_to_cpu(rxreq->hash),
 			     cqe_to_pkt_hash_type(cv));
-	if (likely((q->netdev->features & NETIF_F_RXCSUM) && rxreq->csum)) {
+	if (likely(netdev_active_feature_test(q->netdev, NETIF_F_RXCSUM_BIT) && rxreq->csum)) {
 		FUN_QSTAT_INC(q, rx_cso);
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		skb->csum_level = be16_to_cpu(rxreq->csum) - 1;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index f8a2f206d5c1..9e5a28b8ddc4 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -564,7 +564,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		cmd.create_rx_queue.rx_buff_ring_size =
 			cpu_to_be16(priv->options_dqo_rda.rx_buff_ring_entries);
 		cmd.create_rx_queue.enable_rsc =
-			!!(priv->dev->features & NETIF_F_LRO);
+			netdev_active_feature_test(priv->dev, NETIF_F_LRO_BIT);
 	}
 
 	return gve_adminq_issue_cmd(priv, &cmd);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index bfc1d0a173af..d86b6004580a 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1185,7 +1185,8 @@ static int gve_set_features(struct net_device *netdev,
 	struct gve_priv *priv = netdev_priv(netdev);
 	int err;
 
-	if ((netdev->features & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
+	if (netdev_active_feature_test(netdev, NETIF_F_LRO_BIT) !=
+	    netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		netdev_active_feature_change(netdev, NETIF_F_LRO_BIT);
 		if (netif_carrier_ok(netdev)) {
 			/* To make this process as simple as possible we
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 021bbf308d68..5f479566011c 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -592,7 +592,7 @@ static bool gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 		desc = &rx->desc.desc_ring[idx];
 	}
 
-	if (likely(feat & NETIF_F_RXCSUM)) {
+	if (likely(netdev_feature_test(NETIF_F_RXCSUM_BIT, feat))) {
 		/* NIC passes up the partial sum */
 		if (first_desc->csum)
 			skb->ip_summed = CHECKSUM_COMPLETE;
@@ -602,7 +602,7 @@ static bool gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 	}
 
 	/* parse flags & pass relevant info up */
-	if (likely(feat & NETIF_F_RXHASH) &&
+	if (likely(netdev_feature_test(NETIF_F_RXHASH_BIT, feat)) &&
 	    gve_needs_rss(first_desc->flags_seq))
 		skb_set_hash(skb, be32_to_cpu(first_desc->rss_hash),
 			     gve_rss_type(first_desc->flags_seq));
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8c939628e2d8..edff4d162236 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -637,10 +637,10 @@ static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 
 	skb_record_rx_queue(rx->ctx.skb_head, rx->q_num);
 
-	if (feat & NETIF_F_RXHASH)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, feat))
 		gve_rx_skb_hash(rx->ctx.skb_head, desc, ptype);
 
-	if (feat & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, feat))
 		gve_rx_skb_csum(rx->ctx.skb_head, desc, ptype);
 
 	/* RSC packets must set gso_size otherwise the TCP stack will complain
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 6c4a37fae478..d47e01652a91 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -478,7 +478,7 @@ static void hns_nic_rx_checksum(struct hns_nic_ring_data *ring_data,
 	u32 l4id;
 
 	/* check if RX checksum offload is enabled */
-	if (unlikely(!(netdev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)))
 		return;
 
 	/* In hardware, we only support checksum for the following protocols:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 31d8da9aeb5f..b098d070deef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1503,7 +1503,8 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 		return -EINVAL;
 
 	if (skb->protocol == htons(ETH_P_8021Q) &&
-	    !(handle->kinfo.netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !netdev_active_feature_test(handle->kinfo.netdev,
+					NETIF_F_HW_VLAN_CTAG_TX_BIT)) {
 		/* When HW VLAN acceleration is turned off, and the stack
 		 * sets the protocol to 802.1q, the driver just need to
 		 * set the protocol to the encapsulated ethertype.
@@ -2412,36 +2413,41 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	int ret;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_GRO_HW && h->ae_algo->ops->set_gro_en) {
-		enable = !!(features & NETIF_F_GRO_HW);
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, changed) &&
+	    h->ae_algo->ops->set_gro_en) {
+		enable = netdev_feature_test(NETIF_F_GRO_HW_BIT, features);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
 	    h->ae_algo->ops->enable_hw_strip_rxvtag) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					     features);
 		ret = h->ae_algo->ops->enable_hw_strip_rxvtag(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_NTUPLE) && h->ae_algo->ops->enable_fd) {
-		enable = !!(features & NETIF_F_NTUPLE);
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed) &&
+	    h->ae_algo->ops->enable_fd) {
+		enable = netdev_feature_test(NETIF_F_NTUPLE_BIT, features);
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
 	    h->ae_algo->ops->cls_flower_active(h)) {
 		netdev_err(netdev,
 			   "there are offloaded TC filters active, cannot disable HW TC offload");
 		return -EINVAL;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed) &&
 	    h->ae_algo->ops->enable_vlan_filter) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					     features);
 		ret = h->ae_algo->ops->enable_vlan_filter(h, enable);
 		if (ret)
 			return ret;
@@ -3938,7 +3944,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 
 	skb_checksum_none_assert(skb);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state))
@@ -4229,7 +4235,7 @@ static void hns3_handle_rx_vlan_tag(struct hns3_enet_ring *ring,
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
 	 * in one layer tag case.
 	 */
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		u16 vlan_tag;
 
 		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 45cd19ef3c5b..6efae0ac751e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -339,7 +339,7 @@ static void hns3_selftest_prepare(struct net_device *ndev,
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	/* Disable the vlan filter for selftest does not support it */
 	if (h->ae_algo->ops->enable_vlan_filter &&
-	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    netdev_active_feature_test(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
@@ -365,7 +365,7 @@ static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	if (h->ae_algo->ops->enable_vlan_filter &&
-	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    netdev_active_feature_test(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		h->ae_algo->ops->enable_vlan_filter(h, true);
 #endif
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index d04e95313da7..59475894676e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -870,7 +870,7 @@ static netdev_features_t hinic_fix_features(struct net_device *netdev,
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 		netif_info(nic_dev, drv, netdev, "disabling LRO as RXCSUM is off\n");
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 	}
@@ -1073,8 +1073,9 @@ static int set_features(struct hinic_dev *nic_dev,
 		netdev_features_xor(changed, pre_features, features);
 
 	netdev_features_zero(failed_features);
-	if (changed & NETIF_F_TSO) {
-		ret = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
+	if (netdev_feature_test(NETIF_F_TSO_BIT, changed)) {
+		ret = hinic_port_set_tso(nic_dev,
+					 netdev_feature_test(NETIF_F_TSO_BIT, features) ?
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
 		if (ret) {
 			err = ret;
@@ -1082,7 +1083,7 @@ static int set_features(struct hinic_dev *nic_dev,
 		}
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		ret = hinic_set_rx_csum_offload(nic_dev, csum_en);
 		if (ret) {
 			err = ret;
@@ -1091,9 +1092,9 @@ static int set_features(struct hinic_dev *nic_dev,
 		}
 	}
 
-	if (changed & NETIF_F_LRO) {
+	if (netdev_feature_test(NETIF_F_LRO_BIT, changed)) {
 		ret = hinic_set_rx_lro_state(nic_dev,
-					     !!(features & NETIF_F_LRO),
+					     netdev_feature_test(NETIF_F_LRO_BIT, features),
 					     HINIC_LRO_RX_TIMER_DEFAULT,
 					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
 		if (ret) {
@@ -1102,10 +1103,10 @@ static int set_features(struct hinic_dev *nic_dev,
 		}
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		ret = hinic_set_rx_vlan_offload(nic_dev,
-						!!(features &
-						   NETIF_F_HW_VLAN_CTAG_RX));
+						netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+								    features));
 		if (ret) {
 			err = ret;
 			netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index e5828a658caf..9d1cebbeffec 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -104,7 +104,7 @@ static void rx_csum(struct hinic_rxq *rxq, u32 status,
 
 	csum_err = HINIC_RQ_CQE_STATUS_GET(status, CSUM_ERR);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	if (!csum_err) {
@@ -409,7 +409,7 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 
 		offload_type = be32_to_cpu(cqe->offload_type);
 		vlan_len = be32_to_cpu(cqe->len);
-		if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 		    HINIC_GET_RX_VLAN_OFFLOAD_EN(offload_type)) {
 			vid = HINIC_GET_RX_VLAN_TAG(vlan_len);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 99f76b0c3031..d524d76a09eb 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -743,7 +743,7 @@ static netdev_features_t ibmveth_fix_features(struct net_device *dev,
 	 * checksummed.
 	 */
 
-	if (!(features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		netdev_features_clear(features, NETIF_F_CSUM_MASK);
 
 	return features;
@@ -903,7 +903,7 @@ static int ibmveth_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct ibmveth_adapter *adapter = netdev_priv(dev);
-	int rx_csum = !!(features & NETIF_F_RXCSUM);
+	int rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
 	int large_send = !!(features & netdev_general_tso_features);
 	int rc1 = 0, rc2 = 0;
 
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index a715fcb2b3f2..636c386d6761 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1115,7 +1115,7 @@ static int e100_configure(struct nic *nic, struct cb *cb, struct sk_buff *skb)
 		config->promiscuous_mode = 0x1;		/* 1=on, 0=off */
 	}
 
-	if (unlikely(netdev->features & NETIF_F_RXFCS))
+	if (unlikely(netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT)))
 		config->rx_crc_transfer = 0x1;	/* 1=save, 0=discard */
 
 	if (nic->flags & multicast_all)
@@ -1142,7 +1142,7 @@ static int e100_configure(struct nic *nic, struct cb *cb, struct sk_buff *skb)
 		}
 	}
 
-	if (netdev->features & NETIF_F_RXALL) {
+	if (netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 		config->rx_save_overruns = 0x1; /* 1=save, 0=discard */
 		config->rx_save_bad_frames = 0x1;       /* 1=save, 0=discard */
 		config->rx_discard_short_frames = 0x0;  /* 1=discard, 0=save */
@@ -1990,7 +1990,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 	}
 
 	/* Get actual data size */
-	if (unlikely(dev->features & NETIF_F_RXFCS))
+	if (unlikely(netdev_active_feature_test(dev, NETIF_F_RXFCS_BIT)))
 		fcs_pad = 4;
 	actual_size = le16_to_cpu(rfd->actual_size) & 0x3FFF;
 	if (unlikely(actual_size > RFD_BUF_LEN - sizeof(struct rfd)))
@@ -2021,7 +2021,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 	/* If we are receiving all frames, then don't bother
 	 * checking for errors.
 	 */
-	if (unlikely(dev->features & NETIF_F_RXALL)) {
+	if (unlikely(netdev_active_feature_test(dev, NETIF_F_RXALL_BIT))) {
 		if (actual_size > ETH_DATA_LEN + VLAN_ETH_HLEN + fcs_pad)
 			/* Received oversized frame, but keep it. */
 			nic->rx_over_length_errors++;
@@ -2807,7 +2807,8 @@ static int e100_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (!(changed & NETIF_F_RXFCS && changed & NETIF_F_RXALL))
+	if (!(netdev_feature_test(NETIF_F_RXFCS_BIT, changed) &&
+	      netdev_feature_test(NETIF_F_RXALL_BIT, changed)))
 		return 0;
 
 	netdev->features = features;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index f3d8c71354e5..a1a0cdb3cf2e 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -793,7 +793,7 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -808,14 +808,15 @@ static int e1000_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		e1000_vlan_mode(netdev, features);
 
-	if (!(changed & NETIF_F_RXCSUM && changed & NETIF_F_RXALL))
+	if (!(netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) &&
+	      netdev_feature_test(NETIF_F_RXALL_BIT, changed)))
 		return 0;
 
 	netdev->features = features;
-	adapter->rx_csum = !!(features & NETIF_F_RXCSUM);
+	adapter->rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
 
 	if (netif_running(netdev))
 		e1000_reinit_locked(adapter);
@@ -1831,7 +1832,7 @@ static void e1000_setup_rctl(struct e1000_adapter *adapter)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXALL_BIT)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode
 		 */
@@ -4187,7 +4188,7 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 						    rx_desc->errors,
 						    length, mapped)) {
 				length--;
-			} else if (netdev->features & NETIF_F_RXALL) {
+			} else if (netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 				goto process_skb;
 			} else {
 				/* an error means any chain goes out the window
@@ -4238,7 +4239,8 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 				if (length <= copybreak) {
 					u8 *vaddr;
 
-					if (likely(!(netdev->features & NETIF_F_RXFCS)))
+					if (likely(!netdev_active_feature_test(netdev,
+									       NETIF_F_RXFCS_BIT)))
 						length -= 4;
 					skb = e1000_alloc_rx_skb(adapter,
 								 length);
@@ -4284,7 +4286,7 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 				  le16_to_cpu(rx_desc->csum), skb);
 
 		total_rx_bytes += (skb->len - 4); /* don't count FCS */
-		if (likely(!(netdev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT)))
 			pskb_trim(skb, skb->len - 4);
 		total_rx_packets++;
 
@@ -4439,7 +4441,7 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 						    rx_desc->errors,
 						    length, data)) {
 				length--;
-			} else if (netdev->features & NETIF_F_RXALL) {
+			} else if (netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 				goto process_skb;
 			} else {
 				dev_kfree_skb(skb);
@@ -4451,7 +4453,7 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 		total_rx_bytes += (length - 4); /* don't count FCS */
 		total_rx_packets++;
 
-		if (likely(!(netdev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT)))
 			/* adjust length to remove Ethernet CRC, this must be
 			 * done after the TBI_ACCEPT workaround above
 			 */
@@ -4899,7 +4901,7 @@ static void __e1000_vlan_mode(struct e1000_adapter *adapter,
 	u32 ctrl;
 
 	ctrl = er32(CTRL);
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		ctrl |= E1000_CTRL_VME;
 	} else {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index f7c201d06e54..60b545597f01 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -579,7 +579,7 @@ static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 	skb_checksum_none_assert(skb);
 
 	/* Rx checksum disabled */
-	if (!(adapter->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(adapter->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* Ignore Checksum bit is set */
@@ -897,7 +897,7 @@ static void e1000_alloc_jumbo_rx_buffers(struct e1000_ring *rx_ring,
 static inline void e1000_rx_hash(struct net_device *netdev, __le32 rss,
 				 struct sk_buff *skb)
 {
-	if (netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, le32_to_cpu(rss), PKT_HASH_TYPE_L3);
 }
 
@@ -979,7 +979,7 @@ static bool e1000_clean_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 		}
 
 		if (unlikely((staterr & E1000_RXDEXT_ERR_FRAME_ERR_MASK) &&
-			     !(netdev->features & NETIF_F_RXALL))) {
+			     !netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT))) {
 			/* recycle */
 			buffer_info->skb = skb;
 			goto next_desc;
@@ -991,7 +991,7 @@ static bool e1000_clean_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 			 * but keep the FCS bytes out of the total_rx_bytes
 			 * counter
 			 */
-			if (netdev->features & NETIF_F_RXFCS)
+			if (netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT))
 				total_rx_bytes -= 4;
 			else
 				length -= 4;
@@ -1365,7 +1365,7 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 		}
 
 		if (unlikely((staterr & E1000_RXDEXT_ERR_FRAME_ERR_MASK) &&
-			     !(netdev->features & NETIF_F_RXALL))) {
+			     !netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT))) {
 			dev_kfree_skb_irq(skb);
 			goto next_desc;
 		}
@@ -1416,7 +1416,7 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 
 				/* remove the CRC */
 				if (!(adapter->flags2 & FLAG2_CRC_STRIPPING)) {
-					if (!(netdev->features & NETIF_F_RXFCS))
+					if (!netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT))
 						l1 -= 4;
 				}
 
@@ -1445,7 +1445,7 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 		 * this whole operation can get a little cpu intensive
 		 */
 		if (!(adapter->flags2 & FLAG2_CRC_STRIPPING)) {
-			if (!(netdev->features & NETIF_F_RXFCS))
+			if (!netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT))
 				pskb_trim(skb, skb->len - 4);
 		}
 
@@ -1560,7 +1560,7 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 		/* errors is only valid for DD + EOP descriptors */
 		if (unlikely((staterr & E1000_RXD_STAT_EOP) &&
 			     ((staterr & E1000_RXDEXT_ERR_FRAME_ERR_MASK) &&
-			      !(netdev->features & NETIF_F_RXALL)))) {
+			      !netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)))) {
 			/* recycle both page and skb */
 			buffer_info->skb = skb;
 			/* an error means any chain goes out the window too */
@@ -3167,7 +3167,7 @@ static void e1000_setup_rctl(struct e1000_adapter *adapter)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXALL_BIT)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode
 		 */
@@ -3272,7 +3272,7 @@ static void e1000_configure_rx(struct e1000_adapter *adapter)
 
 	/* Enable Receive Checksum Offload for TCP and UDP */
 	rxcsum = er32(RXCSUM);
-	if (adapter->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXCSUM_BIT))
 		rxcsum |= E1000_RXCSUM_TUOFL;
 	else
 		rxcsum &= ~E1000_RXCSUM_TUOFL;
@@ -3453,7 +3453,7 @@ static void e1000e_set_rx_mode(struct net_device *netdev)
 
 	ew32(RCTL, rctl);
 
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		e1000e_vlan_strip_enable(adapter);
 	else
 		e1000e_vlan_strip_disable(adapter);
@@ -3763,7 +3763,7 @@ static void e1000_configure(struct e1000_adapter *adapter)
 
 	e1000_configure_tx(adapter);
 
-	if (adapter->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXHASH_BIT))
 		e1000e_setup_rss_hash(adapter);
 	e1000_setup_rctl(adapter);
 	e1000_configure_rx(adapter);
@@ -7304,7 +7304,7 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -7331,8 +7331,8 @@ static int e1000_set_features(struct net_device *netdev,
 	if (!(changed & changeable))
 		return 0;
 
-	if (changed & NETIF_F_RXFCS) {
-		if (features & NETIF_F_RXFCS) {
+	if (netdev_feature_test(NETIF_F_RXFCS_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features)) {
 			adapter->flags2 &= ~FLAG2_CRC_STRIPPING;
 		} else {
 			/* We need to take it back to defaults, which might mean
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index db6501c8ea39..2f1e5af847f2 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -352,7 +352,7 @@ static inline void fm10k_rx_checksum(struct fm10k_ring *ring,
 	skb_checksum_none_assert(skb);
 
 	/* Rx checksum disabled via ethtool */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* TCP/UDP checksum error bit is set */
@@ -388,7 +388,7 @@ static inline void fm10k_rx_hash(struct fm10k_ring *ring,
 {
 	u16 rss_type;
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	rss_type = le16_to_cpu(rx_desc->w.pkt_info) & FM10K_RXD_RSSTYPE_MASK;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 30ab7f26b72d..0f2cfb6e9ce9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3235,7 +3235,7 @@ static void i40e_restore_vlan(struct i40e_vsi *vsi)
 	if (!vsi->netdev)
 		return;
 
-	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(vsi->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		i40e_vlan_stripping_enable(vsi);
 	else
 		i40e_vlan_stripping_disable(vsi);
@@ -12853,7 +12853,7 @@ bool i40e_set_ntuple(struct i40e_pf *pf, netdev_features_t features)
 	/* Check if Flow Director n-tuple support was enabled or disabled.  If
 	 * the state changed, we need to reset.
 	 */
-	if (features & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features)) {
 		/* Enable filters and mark for reset */
 		if (!(pf->flags & I40E_FLAG_FD_SB_ENABLED))
 			need_reset = true;
@@ -12922,25 +12922,28 @@ static int i40e_set_features(struct net_device *netdev,
 	struct i40e_pf *pf = vsi->back;
 	bool need_reset;
 
-	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) &&
+	    !netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		i40e_pf_config_rss(pf);
-	else if (!(features & NETIF_F_RXHASH) &&
-		 netdev->features & NETIF_F_RXHASH)
+	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, features) &&
+		 netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		i40e_clear_rss_lut(vsi);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		i40e_vlan_stripping_enable(vsi);
 	else
 		i40e_vlan_stripping_disable(vsi);
 
-	if (!(features & NETIF_F_HW_TC) &&
-	    (netdev->features & NETIF_F_HW_TC) && pf->num_cloud_filters) {
+	if (!netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
+	    netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
+	    pf->num_cloud_filters) {
 		dev_err(&pf->pdev->dev,
 			"Offloaded tc filters active, can't turn hw_tc_offload off");
 		return -EINVAL;
 	}
 
-	if (!(features & NETIF_F_HW_L2FW_DOFFLOAD) && vsi->macvlan_cnt)
+	if (!netdev_feature_test(NETIF_F_HW_L2FW_DOFFLOAD_BIT, features) &&
+	    vsi->macvlan_cnt)
 		i40e_del_all_macvlans(vsi);
 
 	need_reset = i40e_set_ntuple(pf, features);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 69e67eb6aea7..da6f09f89412 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1780,7 +1780,7 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum enabled and ip headers found? */
-	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(vsi->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* did the hardware decode the packet and checksum? */
@@ -1882,7 +1882,7 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
 		cpu_to_le64((u64)I40E_RX_DESC_FLTSTAT_RSS_HASH <<
 			    I40E_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
@@ -2944,7 +2944,7 @@ static inline int i40e_tx_prepare_vlan_flags(struct sk_buff *skb,
 	u32  tx_flags = 0;
 
 	if (protocol == htons(ETH_P_8021Q) &&
-	    !(tx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !netdev_active_feature_test(tx_ring->netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT)) {
 		/* When HW VLAN acceleration is turned off by the user the
 		 * stack sets the protocol to 8021q so that the driver
 		 * can take any steps required to support the SW only
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 03f1dd9d296d..e3dd3d359245 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2649,7 +2649,7 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 				 err);
 	}
 	dev_info(&pdev->dev, "MAC address: %pM\n", adapter->hw.mac.addr);
-	if (netdev->features & NETIF_F_GRO)
+	if (netdev_active_feature_test(netdev, NETIF_F_GRO_BIT))
 		dev_info(&pdev->dev, "GRO is enabled\n");
 
 	iavf_change_state(adapter, __IAVF_DOWN);
@@ -4826,17 +4826,17 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	 * TSO needs minimum 576 bytes to work correctly.
 	 */
 	if (netdev->wanted_features) {
-		if (!(netdev->wanted_features & NETIF_F_TSO) ||
+		if (!netdev_wanted_feature_test(netdev, NETIF_F_TSO_BIT) ||
 		    netdev->mtu < 576)
 			netdev_active_feature_del(netdev, NETIF_F_TSO_BIT);
-		if (!(netdev->wanted_features & NETIF_F_TSO6) ||
+		if (!netdev_wanted_feature_test(netdev, NETIF_F_TSO6_BIT) ||
 		    netdev->mtu < 576)
 			netdev_active_feature_del(netdev, NETIF_F_TSO6_BIT);
-		if (!(netdev->wanted_features & NETIF_F_TSO_ECN))
+		if (!netdev_wanted_feature_test(netdev, NETIF_F_TSO_ECN_BIT))
 			netdev_active_feature_del(netdev, NETIF_F_TSO_ECN_BIT);
-		if (!(netdev->wanted_features & NETIF_F_GRO))
+		if (!netdev_wanted_feature_test(netdev, NETIF_F_GRO_BIT))
 			netdev_active_feature_del(netdev, NETIF_F_GRO_BIT);
-		if (!(netdev->wanted_features & NETIF_F_GSO))
+		if (!netdev_wanted_feature_test(netdev, NETIF_F_GSO_BIT))
 			netdev_active_feature_del(netdev, NETIF_F_GSO_BIT);
 	}
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 06d18797d25a..795faa0ca0b4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -894,10 +894,10 @@ static void iavf_receive_skb(struct iavf_ring *rx_ring,
 {
 	struct iavf_q_vector *q_vector = rx_ring->q_vector;
 
-	if ((rx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(rx_ring->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    (vlan_tag & VLAN_VID_MASK))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
-	else if ((rx_ring->netdev->features & NETIF_F_HW_VLAN_STAG_RX) &&
+	else if (netdev_active_feature_test(rx_ring->netdev, NETIF_F_HW_VLAN_STAG_RX_BIT) &&
 		 vlan_tag & VLAN_VID_MASK)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD), vlan_tag);
 
@@ -998,7 +998,7 @@ static inline void iavf_rx_checksum(struct iavf_vsi *vsi,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum enabled and ip headers found? */
-	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(vsi->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* did the hardware decode the packet and checksum? */
@@ -1093,7 +1093,7 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(ring->netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d126f4cb3ba8..bdd2157d2f25 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3296,8 +3296,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 		/* disable or enable CRC stripping */
 		if (vsi->netdev)
-			ice_vsi_cfg_crc_strip(vsi, !!(vsi->netdev->features &
-					      NETIF_F_RXFCS));
+			ice_vsi_cfg_crc_strip(vsi,
+					      netdev_active_feature_test(vsi->netdev,
+									 NETIF_F_RXFCS_BIT));
 
 		break;
 	case ICE_VSI_VF:
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6e4dd1aae6d5..8e36b4d799c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -435,8 +435,8 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 						IFF_PROMISC;
 					goto out_promisc;
 				}
-				if (vsi->netdev->features &
-				    NETIF_F_HW_VLAN_CTAG_FILTER)
+				if (netdev_active_feature_test(vsi->netdev,
+							       NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 					vlan_ops->ena_rx_filtering(vsi);
 			}
 		}
@@ -5821,12 +5821,16 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	bool cur_ctag, cur_stag, req_ctag, req_stag;
 
 	cur_vlan_fltr = netdev->features & NETIF_VLAN_FILTERING_FEATURES;
-	cur_ctag = cur_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
-	cur_stag = cur_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+	cur_ctag = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       cur_vlan_fltr);
+	cur_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				       cur_vlan_fltr);
 
 	req_vlan_fltr = features & NETIF_VLAN_FILTERING_FEATURES;
-	req_ctag = req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
-	req_stag = req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+	req_ctag = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       req_vlan_fltr);
+	req_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				       req_vlan_fltr);
 
 	if (req_vlan_fltr != cur_vlan_fltr) {
 		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
@@ -5848,10 +5852,10 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been disabled for both types.\n");
 			}
 		} else {
-			if (req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER)
+			if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT, req_vlan_fltr))
 				netdev_warn(netdev, "cannot support requested 802.1ad filtering setting in SVM mode\n");
 
-			if (req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER)
+			if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, req_vlan_fltr))
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 						   features);
 		}
@@ -5864,8 +5868,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 				      netdev_stag_vlan_offload_features);
 	}
 
-	if (!(netdev->features & NETIF_F_RXFCS) &&
-	    (features & NETIF_F_RXFCS) &&
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT) &&
+	    netdev_feature_test(NETIF_F_RXFCS_BIT, features) &&
 	    (features & NETIF_VLAN_STRIPPING_FEATURES) &&
 	    !ice_vsi_has_non_zero_vlans(np->vsi)) {
 		netdev_warn(netdev, "Disabling VLAN stripping as FCS/CRC stripping is also disabled and there is no VLAN configured\n");
@@ -5967,7 +5971,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	netdev_features_xor(diff, current_vlan_features,
 			    requested_vlan_features);
 	if (diff) {
-		if ((features & NETIF_F_RXFCS) &&
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features) &&
 		    (features & NETIF_VLAN_STRIPPING_FEATURES)) {
 			dev_err(ice_pf_to_dev(vsi->back),
 				"To enable VLAN stripping, you must first enable FCS/CRC stripping\n");
@@ -6052,8 +6056,9 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	/* Multiple features can be changed in one call so keep features in
 	 * separate if/else statements to guarantee each feature is checked
 	 */
-	if (changed & NETIF_F_RXHASH)
-		ice_vsi_manage_rss_lut(vsi, !!(features & NETIF_F_RXHASH));
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed))
+		ice_vsi_manage_rss_lut(vsi,
+				       netdev_feature_test(NETIF_F_RXHASH_BIT, features));
 
 	ret = ice_set_vlan_features(netdev, features);
 	if (ret)
@@ -6062,42 +6067,44 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	/* Turn on receive of FCS aka CRC, and after setting this
 	 * flag the packet data will have the 4 byte CRC appended
 	 */
-	if (changed & NETIF_F_RXFCS) {
-		if ((features & NETIF_F_RXFCS) &&
+	if (netdev_feature_test(NETIF_F_RXFCS_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features) &&
 		    (features & NETIF_VLAN_STRIPPING_FEATURES)) {
 			dev_err(ice_pf_to_dev(vsi->back),
 				"To disable FCS/CRC stripping, you must first disable VLAN stripping\n");
 			return -EIO;
 		}
 
-		ice_vsi_cfg_crc_strip(vsi, !!(features & NETIF_F_RXFCS));
+		ice_vsi_cfg_crc_strip(vsi,
+				      netdev_feature_test(NETIF_F_RXFCS_BIT, features));
 		ret = ice_down_up(vsi);
 		if (ret)
 			return ret;
 	}
 
-	if (changed & NETIF_F_NTUPLE) {
-		bool ena = !!(features & NETIF_F_NTUPLE);
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed)) {
+		bool ena = netdev_feature_test(NETIF_F_NTUPLE_BIT, features);
 
 		ice_vsi_manage_fdir(vsi, ena);
 		ena ? ice_init_arfs(vsi) : ice_clear_arfs(vsi);
 	}
 
 	/* don't turn off hw_tc_offload when ADQ is already enabled */
-	if (!(features & NETIF_F_HW_TC) && ice_is_adq_active(pf)) {
+	if (!netdev_feature_test(NETIF_F_HW_TC_BIT, features) && ice_is_adq_active(pf)) {
 		dev_err(ice_pf_to_dev(pf), "ADQ is active, can't turn hw_tc_offload off\n");
 		return -EACCES;
 	}
 
-	if (changed & NETIF_F_HW_TC) {
-		bool ena = !!(features & NETIF_F_HW_TC);
+	if (netdev_feature_test(NETIF_F_HW_TC_BIT, changed)) {
+		bool ena = netdev_feature_test(NETIF_F_HW_TC_BIT, features);
 
 		ena ? set_bit(ICE_FLAG_CLS_FLOWER, pf->flags) :
 		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
 	}
 
-	if (changed & NETIF_F_LOOPBACK)
-		ret = ice_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed))
+		ret = ice_set_loopback(vsi,
+				       netdev_feature_test(NETIF_F_LOOPBACK_BIT, features));
 
 	return ret;
 }
@@ -8331,7 +8338,7 @@ static void ice_remove_q_channels(struct ice_vsi *vsi, bool rem_fltr)
 		ice_rem_all_chnl_fltrs(pf);
 
 	/* remove ntuple filters since queue configuration is being changed */
-	if  (vsi->netdev->features & NETIF_F_NTUPLE) {
+	if  (netdev_active_feature_test(vsi->netdev, NETIF_F_NTUPLE_BIT)) {
 		struct ice_hw *hw = &pf->hw;
 
 		mutex_lock(&hw->fdir_fltr_lock);
@@ -8611,7 +8618,7 @@ static int ice_setup_tc_mqprio_qdisc(struct net_device *netdev, void *type_data)
 		 * and set the flag for TC flower filter if hw_tc_offload
 		 * already ON
 		 */
-		if (vsi->netdev->features & NETIF_F_HW_TC)
+		if (netdev_active_feature_test(vsi->netdev, NETIF_F_HW_TC_BIT))
 			set_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 42df686e0215..f8bd43b70542 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1672,7 +1672,7 @@ ice_add_cls_flower(struct net_device *netdev, struct ice_vsi *vsi,
 	if (ice_is_port_repr_netdev(netdev))
 		vsi_netdev = netdev;
 
-	if (!(vsi_netdev->features & NETIF_F_HW_TC) &&
+	if (!netdev_active_feature_test(vsi_netdev, NETIF_F_HW_TC_BIT) &&
 	    !test_bit(ICE_FLAG_CLS_FLOWER, pf->flags)) {
 		/* Based on TC indirect notifications from kernel, all ice
 		 * devices get an instance of rule from higher level device.
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 7ee38d02d1e5..7bade466c0e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -76,7 +76,7 @@ ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 	struct ice_32b_rx_flex_desc_nic *nic_mdid;
 	u32 hash;
 
-	if (!(rx_ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(rx_ring->netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	if (rx_desc->wb.rxdid != ICE_RXDID_FLEX_NIC)
@@ -114,7 +114,7 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	skb_checksum_none_assert(skb);
 
 	/* check if Rx checksum is enabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* check if HW has decoded the packet and checksum */
@@ -212,9 +212,9 @@ ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 	netdev_features_t features = rx_ring->netdev->features;
 	bool non_zero_vlan = !!(vlan_tag & VLAN_VID_MASK);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) && non_zero_vlan)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && non_zero_vlan)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
-	else if ((features & NETIF_F_HW_VLAN_STAG_RX) && non_zero_vlan)
+	else if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, features) && non_zero_vlan)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD), vlan_tag);
 
 	napi_gro_receive(&rx_ring->q_vector->napi, skb);
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index e5f3e7680dc6..a0e93dbbdd57 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2901,7 +2901,7 @@ static int igb_add_ethtool_nfc_entry(struct igb_adapter *adapter,
 	struct igb_nfc_filter *input, *rule;
 	int err = 0;
 
-	if (!(netdev->hw_features & NETIF_F_NTUPLE))
+	if (!netdev_hw_feature_test(netdev, NETIF_F_NTUPLE_BIT))
 		return -EOPNOTSUPP;
 
 	/* Don't allow programming if the action is a queue greater than
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 2a03b70bac35..01af57d888c3 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2438,7 +2438,7 @@ static netdev_features_t igb_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -2453,13 +2453,14 @@ static int igb_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igb_vlan_mode(netdev, features);
 
-	if (!(changed & NETIF_F_RXALL) && !(changed & NETIF_F_NTUPLE))
+	if (!netdev_feature_test(NETIF_F_RXALL_BIT, changed) &&
+	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, changed))
 		return 0;
 
-	if (!(features & NETIF_F_NTUPLE)) {
+	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, features)) {
 		struct hlist_node *node2;
 		struct igb_nfc_filter *rule;
 
@@ -2538,7 +2539,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_BIT, features);
 
 	return features;
@@ -4568,7 +4569,7 @@ void igb_setup_rctl(struct igb_adapter *adapter)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXALL_BIT)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode
 		 */
@@ -5077,7 +5078,7 @@ static int igb_vlan_promisc_enable(struct igb_adapter *adapter)
 	case e1000_i211:
 	case e1000_i350:
 		/* VLAN filtering needed for VLAN prio filter */
-		if (adapter->netdev->features & NETIF_F_NTUPLE)
+		if (netdev_active_feature_test(adapter->netdev, NETIF_F_NTUPLE_BIT))
 			break;
 		fallthrough;
 	case e1000_82576:
@@ -5249,7 +5250,7 @@ static void igb_set_rx_mode(struct net_device *netdev)
 
 	/* disable VLAN filtering for modes that require it */
 	if ((netdev->flags & IFF_PROMISC) ||
-	    (netdev->features & NETIF_F_RXALL)) {
+	    netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 		/* if we fail to set all rules then just clear VFE */
 		if (igb_vlan_promisc_enable(adapter))
 			rctl &= ~E1000_RCTL_VFE;
@@ -8615,7 +8616,7 @@ static inline void igb_rx_checksum(struct igb_ring *ring,
 		return;
 
 	/* Rx checksum disabled via ethtool */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* TCP/UDP checksum error bit is set */
@@ -8648,7 +8649,7 @@ static inline void igb_rx_hash(struct igb_ring *ring,
 			       union e1000_adv_rx_desc *rx_desc,
 			       struct sk_buff *skb)
 {
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(ring->netdev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb,
 			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
 			     PKT_HASH_TYPE_L3);
@@ -8706,7 +8707,7 @@ static bool igb_cleanup_headers(struct igb_ring *rx_ring,
 	if (unlikely((igb_test_staterr(rx_desc,
 				       E1000_RXDEXT_ERR_FRAME_ERR_MASK)))) {
 		struct net_device *netdev = rx_ring->netdev;
-		if (!(netdev->features & NETIF_F_RXALL)) {
+		if (!netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 			dev_kfree_skb_any(skb);
 			return true;
 		}
@@ -8743,7 +8744,7 @@ static void igb_process_skb_fields(struct igb_ring *rx_ring,
 	    !igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))
 		igb_ptp_rx_rgtstamp(rx_ring->q_vector, skb);
 
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    igb_test_staterr(rx_desc, E1000_RXD_STAT_VP)) {
 		u16 vid;
 
@@ -9167,7 +9168,7 @@ static void igb_vlan_mode(struct net_device *netdev, netdev_features_t features)
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, rctl;
-	bool enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+	bool enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
 
 	if (enable) {
 		/* enable VLAN tag insert/strip */
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index edf03bfe8914..00cdc7432d85 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2608,7 +2608,7 @@ static int igbvf_set_features(struct net_device *netdev,
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		adapter->flags &= ~IGBVF_FLAG_RX_CSUM_DISABLED;
 	else
 		adapter->flags |= IGBVF_FLAG_RX_CSUM_DISABLED;
@@ -2650,7 +2650,7 @@ igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_BIT, features);
 
 	return features;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8cc077b712ad..6d7ac6cfa1ac 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1305,7 +1305,7 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 	struct igc_nfc_rule *rule, *old_rule;
 	int err;
 
-	if (!(netdev->hw_features & NETIF_F_NTUPLE)) {
+	if (!netdev_hw_feature_test(netdev, NETIF_F_NTUPLE_BIT)) {
 		netdev_dbg(netdev, "N-tuple filters disabled\n");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 781555d4d9a7..67849c8d1877 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -826,7 +826,7 @@ static void igc_setup_rctl(struct igc_adapter *adapter)
 	wr32(IGC_RXDCTL(0), 0);
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXALL_BIT)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in set_rx_mode
 		 */
@@ -1531,7 +1531,7 @@ static void igc_rx_checksum(struct igc_ring *ring,
 		return;
 
 	/* Rx checksum disabled via ethtool */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* TCP/UDP checksum error bit is set */
@@ -1564,7 +1564,7 @@ static inline void igc_rx_hash(struct igc_ring *ring,
 			       union igc_adv_rx_desc *rx_desc,
 			       struct sk_buff *skb)
 {
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(ring->netdev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb,
 			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
 			     PKT_HASH_TYPE_L3);
@@ -1577,7 +1577,7 @@ static void igc_rx_vlan(struct igc_ring *rx_ring,
 	struct net_device *dev = rx_ring->netdev;
 	u16 vid;
 
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    igc_test_staterr(rx_desc, IGC_RXD_STAT_VP)) {
 		if (igc_test_staterr(rx_desc, IGC_RXDEXT_STATERR_LB) &&
 		    test_bit(IGC_RING_FLAG_RX_LB_VLAN_BSWAP, &rx_ring->flags))
@@ -1616,7 +1616,7 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
 
 static void igc_vlan_mode(struct net_device *netdev, netdev_features_t features)
 {
-	bool enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+	bool enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	struct igc_hw *hw = &adapter->hw;
 	u32 ctrl;
@@ -1914,7 +1914,7 @@ static bool igc_cleanup_headers(struct igc_ring *rx_ring,
 	if (unlikely(igc_test_staterr(rx_desc, IGC_RXDEXT_STATERR_RXE))) {
 		struct net_device *netdev = rx_ring->netdev;
 
-		if (!(netdev->features & NETIF_F_RXALL)) {
+		if (!netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 			dev_kfree_skb_any(skb);
 			return true;
 		}
@@ -4978,7 +4978,7 @@ static netdev_features_t igc_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
@@ -4993,14 +4993,15 @@ static int igc_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igc_vlan_mode(netdev, features);
 
 	/* Add VLAN support */
-	if (!(changed & NETIF_F_RXALL) && !(changed & NETIF_F_NTUPLE))
+	if (!netdev_feature_test(NETIF_F_RXALL_BIT, changed) &&
+	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, changed))
 		return 0;
 
-	if (!(features & NETIF_F_NTUPLE))
+	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, features))
 		igc_flush_nfc_rules(adapter);
 
 	netdev->features = features;
@@ -5044,7 +5045,7 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* We can only support IPv4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_BIT, features);
 
 	return features;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 0b324849ccd0..0caf35886a95 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -301,7 +301,7 @@ ixgb_fix_features(struct net_device *netdev, netdev_features_t features)
 	 * Tx VLAN insertion does not work per HW design when Rx stripping is
 	 * disabled.
 	 */
-	if (!(features & NETIF_F_HW_VLAN_CTAG_RX))
+	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 
 	return features;
@@ -314,10 +314,11 @@ ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (!(changed & NETIF_F_RXCSUM) && !(changed & NETIF_F_HW_VLAN_CTAG_RX))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) &&
+	    !netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		return 0;
 
-	adapter->rx_csum = !!(features & NETIF_F_RXCSUM);
+	adapter->rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
 
 	if (netif_running(netdev)) {
 		ixgb_down(adapter, true);
@@ -1097,7 +1098,7 @@ ixgb_set_multi(struct net_device *netdev)
 	}
 
 alloc_failed:
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		ixgb_vlan_strip_enable(adapter);
 	else
 		ixgb_vlan_strip_disable(adapter);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
index e85f7d2e8810..55ae3e59ee23 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
@@ -317,7 +317,7 @@ static u8 ixgbe_dcbnl_set_all(struct net_device *netdev)
 		int max_frame = adapter->netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
 
 #ifdef IXGBE_FCOE
-		if (adapter->netdev->features & NETIF_F_FCOE_MTU)
+		if (netdev_active_feature_test(adapter->netdev, NETIF_F_FCOE_MTU_BIT))
 			max_frame = max(max_frame, IXGBE_FCOE_JUMBO_FRAME_SIZE);
 #endif
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index e88e3dfac8c2..0c0a9dc8b6d6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2394,7 +2394,7 @@ static bool ixgbe_update_rsc(struct ixgbe_adapter *adapter)
 
 	/* nothing to do if LRO or RSC are not enabled */
 	if (!(adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE) ||
-	    !(netdev->features & NETIF_F_LRO))
+	    !netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 		return false;
 
 	/* check the feature flag value and enable RSC if necessary */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 00f4e95fcd31..98da6d4d5ba0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -645,7 +645,7 @@ void ixgbe_configure_fcoe(struct ixgbe_adapter *adapter)
 	u32 etqf;
 
 	/* Minimal functionality for FCoE requires at least CRC offloads */
-	if (!(adapter->netdev->features & NETIF_F_FCOE_CRC))
+	if (!netdev_active_feature_test(adapter->netdev, NETIF_F_FCOE_CRC_BIT))
 		return;
 
 	/* Enable L2 EtherType filter for FCoE, needed for FCoE CRC and DDP */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 86b11164655e..e83de178d43a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -982,7 +982,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 			set_bit(__IXGBE_RX_CSUM_UDP_ZERO_ERR, &ring->state);
 
 #ifdef IXGBE_FCOE
-		if (adapter->netdev->features & NETIF_F_FCOE_MTU) {
+		if (netdev_active_feature_test(adapter->netdev, NETIF_F_FCOE_MTU_BIT)) {
 			struct ixgbe_ring_feature *f;
 			f = &adapter->ring_feature[RING_F_FCOE];
 			if ((rxr_idx >= f->offset) &&
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 288384161dac..f3b1d4777c3f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1427,7 +1427,7 @@ static inline void ixgbe_rx_hash(struct ixgbe_ring *ring,
 {
 	u16 rss_type;
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	rss_type = le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
@@ -1477,7 +1477,7 @@ static inline void ixgbe_rx_checksum(struct ixgbe_ring *ring,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum disabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* check for VXLAN and Geneve packets */
@@ -1696,7 +1696,7 @@ void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 	if (unlikely(flags & IXGBE_FLAG_RX_HWTSTAMP_ENABLED))
 		ixgbe_ptp_rx_hwtstamp(rx_ring, rx_desc, skb);
 
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_VP)) {
 		u16 vid = le16_to_cpu(rx_desc->wb.upper.vlan);
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
@@ -1894,7 +1894,7 @@ bool ixgbe_cleanup_headers(struct ixgbe_ring *rx_ring,
 	if (!netdev ||
 	    (unlikely(ixgbe_test_staterr(rx_desc,
 					 IXGBE_RXDADV_ERR_FRAME_ERR_MASK) &&
-	     !(netdev->features & NETIF_F_RXALL)))) {
+	     !netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)))) {
 		dev_kfree_skb_any(skb);
 		return true;
 	}
@@ -4961,7 +4961,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (features & NETIF_F_RXALL) {
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, features)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode */
 		fctrl |= (IXGBE_FCTRL_SBP | /* Receive bad packets */
@@ -4974,12 +4974,12 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 
 	IXGBE_WRITE_REG(hw, IXGBE_FCTRL, fctrl);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		ixgbe_vlan_strip_enable(adapter);
 	else
 		ixgbe_vlan_strip_disable(adapter);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		ixgbe_vlan_promisc_disable(adapter);
 	else
 		ixgbe_vlan_promisc_enable(adapter);
@@ -5061,7 +5061,7 @@ static void ixgbe_configure_dcb(struct ixgbe_adapter *adapter)
 		netif_set_tso_max_size(adapter->netdev, 32768);
 
 #ifdef IXGBE_FCOE
-	if (adapter->netdev->features & NETIF_F_FCOE_MTU)
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_FCOE_MTU_BIT))
 		max_frame = max(max_frame, IXGBE_FCOE_JUMBO_FRAME_SIZE);
 #endif
 
@@ -5118,7 +5118,7 @@ static int ixgbe_hpbthresh(struct ixgbe_adapter *adapter, int pb)
 
 #ifdef IXGBE_FCOE
 	/* FCoE traffic class uses FCOE jumbo frames */
-	if ((dev->features & NETIF_F_FCOE_MTU) &&
+	if (netdev_active_feature_test(dev, NETIF_F_FCOE_MTU_BIT) &&
 	    (tc < IXGBE_FCOE_JUMBO_FRAME_SIZE) &&
 	    (pb == ixgbe_fcoe_get_tc(adapter)))
 		tc = IXGBE_FCOE_JUMBO_FRAME_SIZE;
@@ -5179,7 +5179,7 @@ static int ixgbe_lpbthresh(struct ixgbe_adapter *adapter, int pb)
 
 #ifdef IXGBE_FCOE
 	/* FCoE traffic class uses FCOE jumbo frames */
-	if ((dev->features & NETIF_F_FCOE_MTU) &&
+	if (netdev_active_feature_test(dev, NETIF_F_FCOE_MTU_BIT) &&
 	    (tc < IXGBE_FCOE_JUMBO_FRAME_SIZE) &&
 	    (pb == netdev_get_prio_tc_map(dev, adapter->fcoe.up)))
 		tc = IXGBE_FCOE_JUMBO_FRAME_SIZE;
@@ -8828,8 +8828,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 #ifdef IXGBE_FCOE
 	/* setup tx offload for FCoE */
 	if ((protocol == htons(ETH_P_FCOE)) &&
-	    (tx_ring->netdev->features & NETIF_F_FSO ||
-	     tx_ring->netdev->features & NETIF_F_FCOE_CRC)) {
+	    (netdev_active_feature_test(tx_ring->netdev, NETIF_F_FSO_BIT) ||
+	     netdev_active_feature_test(tx_ring->netdev, NETIF_F_FCOE_CRC_BIT))) {
 		tso = ixgbe_fso(tx_ring, first, &hdr_len);
 		if (tso < 0)
 			goto out_drop;
@@ -9836,14 +9836,14 @@ static netdev_features_t ixgbe_fix_features(struct net_device *netdev,
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then RSC/LRO should also be disabled */
-	if (!(features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
 	/* Turn off LRO if not RSC capable */
 	if (!(adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
-	if (adapter->xdp_prog && (features & NETIF_F_LRO)) {
+	if (adapter->xdp_prog && netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		e_dev_err("LRO is not supported with XDP\n");
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 	}
@@ -9877,7 +9877,7 @@ static int ixgbe_set_features(struct net_device *netdev,
 	netdev_features_xor(changed, netdev->features, features);
 
 	/* Make sure RSC matches LRO, reset if change */
-	if (!(features & NETIF_F_LRO)) {
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
 			need_reset = true;
 		adapter->flags2 &= ~IXGBE_FLAG2_RSC_ENABLED;
@@ -9887,7 +9887,8 @@ static int ixgbe_set_features(struct net_device *netdev,
 		    adapter->rx_itr_setting > IXGBE_MIN_RSC_ITR) {
 			adapter->flags2 |= IXGBE_FLAG2_RSC_ENABLED;
 			need_reset = true;
-		} else if ((changed & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
+		} else if (netdev_feature_test(NETIF_F_LRO_BIT, changed) !=
+			   netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 			e_info(probe, "rx-usecs set too low, "
 			       "disabling RSC\n");
 		}
@@ -9897,7 +9898,8 @@ static int ixgbe_set_features(struct net_device *netdev,
 	 * Check if Flow Director n-tuple support or hw_tc support was
 	 * enabled or disabled.  If the state changed, we need to reset.
 	 */
-	if ((features & NETIF_F_NTUPLE) || (features & NETIF_F_HW_TC)) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features) ||
+	    netdev_feature_test(NETIF_F_HW_TC_BIT, features)) {
 		/* turn off ATR, enable perfect filters and reset */
 		if (!(adapter->flags & IXGBE_FLAG_FDIR_PERFECT_CAPABLE))
 			need_reset = true;
@@ -9924,17 +9926,17 @@ static int ixgbe_set_features(struct net_device *netdev,
 			adapter->flags |= IXGBE_FLAG_FDIR_HASH_CAPABLE;
 	}
 
-	if (changed & NETIF_F_RXALL)
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, changed))
 		need_reset = true;
 
 	netdev->features = features;
 
-	if ((changed & NETIF_F_HW_L2FW_DOFFLOAD) && adapter->num_rx_pools > 1)
+	if (netdev_feature_test(NETIF_F_HW_L2FW_DOFFLOAD_BIT, changed) && adapter->num_rx_pools > 1)
 		ixgbe_reset_l2fw_offload(adapter);
 	else if (need_reset)
 		ixgbe_do_reset(netdev);
-	else if (changed & NETIF_F_HW_VLAN_CTAG_RX ||
-		 changed & NETIF_F_HW_VLAN_CTAG_FILTER)
+	else if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) ||
+		 netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed))
 		ixgbe_set_rx_mode(netdev);
 
 	return 1;
@@ -10252,7 +10254,7 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * IPsec offoad sets skb->encapsulation but still can handle
 	 * the TSO, so it's the exception.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID)) {
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features)) {
 #ifdef CONFIG_IXGBE_IPSEC
 		if (!secpath_exists(skb))
 #endif
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 29cc60988071..ae9e2259fe10 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -495,7 +495,7 @@ static int ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 max_frame, u32 vf
 		s32 err = 0;
 
 #ifdef CONFIG_FCOE
-		if (dev->features & NETIF_F_FCOE_MTU)
+		if (netdev_active_feature_test(dev, NETIF_F_FCOE_MTU_BIT))
 			pf_max_frame = max_t(int, pf_max_frame,
 					     IXGBE_FCOE_JUMBO_FRAME_SIZE);
 
@@ -859,7 +859,7 @@ static void ixgbe_set_vf_rx_tx(struct ixgbe_adapter *adapter, int vf)
 		int pf_max_frame = dev->mtu + ETH_HLEN;
 
 #if IS_ENABLED(CONFIG_FCOE)
-		if (dev->features & NETIF_F_FCOE_MTU)
+		if (netdev_active_feature_test(dev, NETIF_F_FCOE_MTU_BIT))
 			pf_max_frame = max_t(int, pf_max_frame,
 					     IXGBE_FCOE_JUMBO_FRAME_SIZE);
 #endif /* CONFIG_FCOE */
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index ae7ec049e020..88f98ac608a2 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -104,7 +104,7 @@ void ixgbevf_ipsec_restore(struct ixgbevf_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	int i;
 
-	if (!(adapter->netdev->features & NETIF_F_HW_ESP))
+	if (!netdev_active_feature_test(adapter->netdev, NETIF_F_HW_ESP_BIT))
 		return;
 
 	/* reload the Rx and Tx keys */
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 124d2396a2ba..50b920ae83e1 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -445,7 +445,7 @@ static inline void ixgbevf_rx_hash(struct ixgbevf_ring *ring,
 {
 	u16 rss_type;
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	rss_type = le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
@@ -472,7 +472,7 @@ static inline void ixgbevf_rx_checksum(struct ixgbevf_ring *ring,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum disabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(ring->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	/* if IP and error */
@@ -743,7 +743,7 @@ static bool ixgbevf_cleanup_headers(struct ixgbevf_ring *rx_ring,
 					  IXGBE_RXDADV_ERR_FRAME_ERR_MASK))) {
 		struct net_device *netdev = rx_ring->netdev;
 
-		if (!(netdev->features & NETIF_F_RXALL)) {
+		if (!netdev_active_feature_test(netdev, NETIF_F_RXALL_BIT)) {
 			dev_kfree_skb_any(skb);
 			return true;
 		}
@@ -4431,7 +4431,7 @@ ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_BIT, features);
 
 	return features;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 13d0de32c6f7..8a9918e34249 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -717,7 +717,7 @@ jme_set_clean_rxdesc(struct jme_adapter *jme, int i)
 	rxdesc->desc1.bufaddrl	= cpu_to_le32(
 					(__u64)rxbi->mapping & 0xFFFFFFFFUL);
 	rxdesc->desc1.datalen	= cpu_to_le16(rxbi->len);
-	if (jme->dev->features & NETIF_F_HIGHDMA)
+	if (netdev_active_feature_test(jme->dev, NETIF_F_HIGHDMA_BIT))
 		rxdesc->desc1.flags = RXFLAG_64BIT;
 	wmb();
 	rxdesc->desc1.flags	|= RXFLAG_OWN | RXFLAG_INT;
@@ -2006,7 +2006,7 @@ jme_map_tx_skb(struct jme_adapter *jme, struct sk_buff *skb, int idx)
 	struct jme_ring *txring = &(jme->txring[0]);
 	struct txdesc *txdesc = txring->desc, *ctxdesc;
 	struct jme_buffer_info *txbi = txring->bufinf, *ctxbi;
-	bool hidma = jme->dev->features & NETIF_F_HIGHDMA;
+	bool hidma = netdev_active_feature_test(jme->dev, NETIF_F_HIGHDMA_BIT);
 	int i, nr_frags = skb_shinfo(skb)->nr_frags;
 	int mask = jme->tx_ring_mask;
 	u32 len;
@@ -2677,7 +2677,7 @@ jme_set_features(struct net_device *netdev, netdev_features_t features)
 	struct jme_adapter *jme = netdev_priv(netdev);
 
 	spin_lock_bh(&jme->rxmcs_lock);
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		jme->reg_rxmcs |= RXMCS_CHECKSUM;
 	else
 		jme->reg_rxmcs &= ~RXMCS_CHECKSUM;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 0f8e364522e8..b66895090e87 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1686,7 +1686,7 @@ static int
 mv643xx_eth_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
-	bool rx_csum = features & NETIF_F_RXCSUM;
+	bool rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
 
 	wrlp(mp, PORT_CONFIG, rx_csum ? 0x02000000 : 0x00000000);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 08297329cc9c..bf6b662c2c91 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1839,7 +1839,7 @@ static void mvneta_rx_error(struct mvneta_port *pp,
 /* Handle RX checksum offload based on the descriptor's status */
 static int mvneta_rx_csum(struct mvneta_port *pp, u32 status)
 {
-	if ((pp->dev->features & NETIF_F_RXCSUM) &&
+	if (netdev_active_feature_test(pp->dev, NETIF_F_RXCSUM_BIT) &&
 	    (status & MVNETA_RXD_L3_IP4) &&
 	    (status & MVNETA_RXD_L4_CSUM_OK))
 		return CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 1c73afaeed86..054946f8fa6e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4905,7 +4905,7 @@ static int mvpp2_prs_mac_da_accept_list(struct mvpp2_port *port,
 
 static void mvpp2_set_rx_promisc(struct mvpp2_port *port, bool enable)
 {
-	if (!enable && (port->dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	if (!enable && netdev_active_feature_test(port->dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		mvpp2_prs_vid_enable_filtering(port);
 	else
 		mvpp2_prs_vid_disable_filtering(port);
@@ -5283,8 +5283,8 @@ static int mvpp2_set_features(struct net_device *dev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
 			mvpp2_prs_vid_enable_filtering(port);
 		} else {
 			/* Invalidate all registered VID filters for this
@@ -5296,8 +5296,8 @@ static int mvpp2_set_features(struct net_device *dev,
 		}
 	}
 
-	if (changed & NETIF_F_RXHASH) {
-		if (features & NETIF_F_RXHASH)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_RXHASH_BIT, features))
 			mvpp22_port_rss_enable(port);
 		else
 			mvpp22_port_rss_disable(port);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index eb95fbb32b6d..a77a0ebb0286 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1770,15 +1770,15 @@ EXPORT_SYMBOL(otx2_get_max_mtu);
 int otx2_handle_ntuple_tc_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	bool ntuple = !!(features & NETIF_F_NTUPLE);
-	bool tc = !!(features & NETIF_F_HW_TC);
+	bool ntuple = netdev_feature_test(NETIF_F_NTUPLE_BIT, features);
+	bool tc = netdev_feature_test(NETIF_F_HW_TC_BIT, features);
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if ((changed & NETIF_F_NTUPLE) && !ntuple)
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed) && !ntuple)
 		otx2_destroy_ntuple_flows(pfvf);
 
-	if ((changed & NETIF_F_NTUPLE) && ntuple) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed) && ntuple) {
 		if (!pfvf->flow_cfg->max_flows) {
 			netdev_err(netdev,
 				   "Can't enable NTUPLE, MCAM entries not allocated\n");
@@ -1786,7 +1786,7 @@ int otx2_handle_ntuple_tc_features(struct net_device *netdev, netdev_features_t
 		}
 	}
 
-	if ((changed & NETIF_F_HW_TC) && tc) {
+	if (netdev_feature_test(NETIF_F_HW_TC_BIT, changed) && tc) {
 		if (!pfvf->flow_cfg->max_flows) {
 			netdev_err(netdev,
 				   "Can't enable TC, MCAM entries not allocated\n");
@@ -1794,21 +1794,23 @@ int otx2_handle_ntuple_tc_features(struct net_device *netdev, netdev_features_t
 		}
 	}
 
-	if ((changed & NETIF_F_HW_TC) && !tc &&
+	if (netdev_feature_test(NETIF_F_HW_TC_BIT, changed) && !tc &&
 	    pfvf->flow_cfg && pfvf->flow_cfg->nr_flows) {
 		netdev_err(netdev, "Can't disable TC hardware offload while flows are active\n");
 		return -EBUSY;
 	}
 
-	if ((changed & NETIF_F_NTUPLE) && ntuple &&
-	    (netdev->features & NETIF_F_HW_TC) && !(changed & NETIF_F_HW_TC)) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed) && ntuple &&
+	    netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, changed)) {
 		netdev_err(netdev,
 			   "Can't enable NTUPLE when TC is active, disable TC and retry\n");
 		return -EINVAL;
 	}
 
-	if ((changed & NETIF_F_HW_TC) && tc &&
-	    (netdev->features & NETIF_F_NTUPLE) && !(changed & NETIF_F_NTUPLE)) {
+	if (netdev_feature_test(NETIF_F_HW_TC_BIT, changed) && tc &&
+	    netdev_active_feature_test(netdev, NETIF_F_NTUPLE_BIT) &&
+	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, changed)) {
 		netdev_err(netdev,
 			   "Can't enable TC when NTUPLE is active, disable NTUPLE and retry\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 5bd16e95370b..1aed3e03afba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -716,7 +716,7 @@ static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
 static int otx2_get_rxnfc(struct net_device *dev,
 			  struct ethtool_rxnfc *nfc, u32 *rules)
 {
-	bool ntuple = !!(dev->features & NETIF_F_NTUPLE);
+	bool ntuple = netdev_active_feature_test(dev, NETIF_F_NTUPLE_BIT);
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
 
@@ -749,7 +749,7 @@ static int otx2_get_rxnfc(struct net_device *dev,
 
 static int otx2_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
 {
-	bool ntuple = !!(dev->features & NETIF_F_NTUPLE);
+	bool ntuple = netdev_active_feature_test(dev, NETIF_F_NTUPLE_BIT);
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f3cdef7edff4..c500f6f44569 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1908,7 +1908,7 @@ static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 static netdev_features_t otx2_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 	else
 		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
@@ -1937,13 +1937,17 @@ static int otx2_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed) &&
+	    netif_running(netdev))
 		return otx2_cgx_config_loopback(pf,
-						features & NETIF_F_LOOPBACK);
+						netdev_feature_test(NETIF_F_LOOPBACK_BIT,
+								    features));
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(netdev))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
+	    netif_running(netdev))
 		return otx2_enable_rxvlan(pf,
-					  features & NETIF_F_HW_VLAN_CTAG_RX);
+					  netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+							      features));
 
 	return otx2_handle_ntuple_tc_features(netdev, features);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index a18e8efd0f1e..2d3f367ff6b8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -231,7 +231,7 @@ static void otx2_set_rxhash(struct otx2_nic *pfvf,
 	struct otx2_rss_info *rss;
 	u32 hash = 0;
 
-	if (!(pfvf->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(pfvf->netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	rss = &pfvf->hw.rss_info;
@@ -321,7 +321,7 @@ static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 	}
 
 	/* If RXALL is enabled pass on packets to stack. */
-	if (pfvf->netdev->features & NETIF_F_RXALL)
+	if (netdev_active_feature_test(pfvf->netdev, NETIF_F_RXALL_BIT))
 		return false;
 
 	/* Free buffer back to pool */
@@ -372,7 +372,7 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	otx2_set_rxhash(pfvf, cqe, skb);
 
 	skb_record_rx_queue(skb, cq->cq_idx);
-	if (pfvf->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(pfvf->netdev, NETIF_F_RXCSUM_BIT))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	napi_gro_frags(napi);
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 2a761f09d267..09845ffe3d80 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3113,7 +3113,7 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
 
 	skb_put(skb, len);
 
-	if (dev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)) {
 		skb->csum = le16_to_cpu(csum);
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index c601bbf8eeb7..077c8ab05eb1 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1274,7 +1274,7 @@ static void rx_set_checksum(struct sky2_port *sky2)
 
 	sky2_write32(sky2->hw,
 		     Q_ADDR(rxqaddr[sky2->port], Q_CSR),
-		     (sky2->netdev->features & NETIF_F_RXCSUM)
+		     netdev_active_feature_test(sky2->netdev, NETIF_F_RXCSUM_BIT)
 		     ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
 }
 
@@ -1292,7 +1292,7 @@ static void rx_set_rss(struct net_device *dev, netdev_features_t features)
 	}
 
 	/* Program RSS initial values */
-	if (features & NETIF_F_RXHASH) {
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features)) {
 		u32 rss_key[10];
 
 		netdev_rss_key_fill(rss_key, sizeof(rss_key));
@@ -1410,14 +1410,14 @@ static void sky2_vlan_mode(struct net_device *dev, netdev_features_t features)
 	struct sky2_hw *hw = sky2->hw;
 	u16 port = sky2->port;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T),
 			     RX_VLAN_STRIP_ON);
 	else
 		sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T),
 			     RX_VLAN_STRIP_OFF);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_ON);
 
@@ -2747,7 +2747,7 @@ static int sky2_status_intr(struct sky2_hw *hw, int to_do, u16 idx)
 
 			/* This chip reports checksum status differently */
 			if (hw->flags & SKY2_HW_NEW_LE) {
-				if ((dev->features & NETIF_F_RXCSUM) &&
+				if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT) &&
 				    (le->css & (CSS_ISIPV4 | CSS_ISIPV6)) &&
 				    (le->css & CSS_TCPUDPCSOK))
 					skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2771,7 +2771,7 @@ static int sky2_status_intr(struct sky2_hw *hw, int to_do, u16 idx)
 			sky2_rx_tag(sky2, length);
 			fallthrough;
 		case OP_RXCHKS:
-			if (likely(dev->features & NETIF_F_RXCSUM))
+			if (likely(netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)))
 				sky2_rx_checksum(sky2, status);
 			break;
 
@@ -4322,9 +4322,9 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
-	if ( (features & NETIF_F_RXHASH) &&
-	     !(features & NETIF_F_RXCSUM) &&
-	     (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, features) &&
+	    (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
 		netdev_info(dev, "receive hashing forces receive checksum\n");
 		netdev_feature_add(NETIF_F_RXCSUM_BIT, features);
 	}
@@ -4338,15 +4338,15 @@ static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if ((changed & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) &&
 	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
 		sky2_write32(sky2->hw,
 			     Q_ADDR(rxqaddr[sky2->port], Q_CSR),
-			     (features & NETIF_F_RXCSUM)
+			     netdev_feature_test(NETIF_F_RXCSUM_BIT, features)
 			     ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
 	}
 
-	if (changed & NETIF_F_RXHASH)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed))
 		rx_set_rss(dev, features);
 
 	if (changed & netdev_ctag_vlan_offload_features)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6f8564886a55..5c76433a70ab 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1921,7 +1921,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
 			mtk_ppe_check_skb(eth->ppe, skb, hash);
 
-		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+		if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 				if (trxd.rxd3 & RX_DMA_VTAG_V2)
 					__vlan_hwaccel_put_tag(skb,
@@ -2700,7 +2700,7 @@ static int mtk_hwlro_get_fdir_all(struct net_device *dev,
 static netdev_features_t mtk_fix_features(struct net_device *dev,
 					  netdev_features_t features)
 {
-	if (!(features & NETIF_F_LRO)) {
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		struct mtk_mac *mac = netdev_priv(dev);
 		int ip_cnt = mtk_hwlro_get_ip_cnt(mac);
 
@@ -2720,10 +2720,10 @@ static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 	int err = 0;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	if (!(features & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, features))
 		mtk_hwlro_netdev_disable(dev);
 
 	return err;
@@ -3708,13 +3708,13 @@ static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
-		if (dev->hw_features & NETIF_F_LRO) {
+		if (netdev_hw_feature_test(dev, NETIF_F_LRO_BIT)) {
 			cmd->data = MTK_MAX_RX_RING_NUM;
 			ret = 0;
 		}
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
-		if (dev->hw_features & NETIF_F_LRO) {
+		if (netdev_hw_feature_test(dev, NETIF_F_LRO_BIT)) {
 			struct mtk_mac *mac = netdev_priv(dev);
 
 			cmd->rule_cnt = mac->hwlro_ip_cnt;
@@ -3722,11 +3722,11 @@ static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 		}
 		break;
 	case ETHTOOL_GRXCLSRULE:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_hw_feature_test(dev, NETIF_F_LRO_BIT))
 			ret = mtk_hwlro_get_fdir_entry(dev, cmd);
 		break;
 	case ETHTOOL_GRXCLSRLALL:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_hw_feature_test(dev, NETIF_F_LRO_BIT))
 			ret = mtk_hwlro_get_fdir_all(dev, cmd,
 						     rule_locs);
 		break;
@@ -3743,11 +3743,11 @@ static int mtk_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXCLSRLINS:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_hw_feature_test(dev, NETIF_F_LRO_BIT))
 			ret = mtk_hwlro_add_ipaddr(dev, cmd);
 		break;
 	case ETHTOOL_SRXCLSRLDEL:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_hw_feature_test(dev, NETIF_F_LRO_BIT))
 			ret = mtk_hwlro_del_ipaddr(dev, cmd);
 		break;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 7d45f1d55f79..788ec4986217 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1244,13 +1244,13 @@ static int mlx4_en_check_rxfh_func(struct net_device *dev, u8 hfunc)
 	if (hfunc == ETH_RSS_HASH_TOP) {
 		if (!(priv->mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS_TOP))
 			return -EINVAL;
-		if (!(dev->features & NETIF_F_RXHASH))
+		if (!netdev_active_feature_test(dev, NETIF_F_RXHASH_BIT))
 			en_warn(priv, "Toeplitz hash function should be used in conjunction with RX hashing for optimal performance\n");
 		return 0;
 	} else if (hfunc == ETH_RSS_HASH_XOR) {
 		if (!(priv->mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS_XOR))
 			return -EINVAL;
-		if (dev->features & NETIF_F_RXHASH)
+		if (netdev_active_feature_test(dev, NETIF_F_RXHASH_BIT))
 			en_warn(priv, "Enabling both XOR Hash function and RX Hashing can limit RPS functionality\n");
 		return 0;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index ff4395638546..bc4b88cc81e3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -104,7 +104,7 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
-	if (features & NETIF_F_LOOPBACK)
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features))
 		priv->ctrl_flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
 	else
 		priv->ctrl_flags &= cpu_to_be32(~MLX4_WQE_CTRL_FORCE_LOOPBACK);
@@ -116,7 +116,7 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 	 * and not performing the selftest or flb disabled
 	 */
 	if (mlx4_is_mfunc(priv->mdev->dev) &&
-	    !(features & NETIF_F_LOOPBACK) && !priv->validate_loopback)
+	    !netdev_feature_test(NETIF_F_LOOPBACK_BIT, features) && !priv->validate_loopback)
 		priv->flags |= MLX4_EN_FLAG_RX_FILTER_NEEDED;
 
 	/* Set dmac in Tx WQE if we are in SRIOV mode or if loopback selftest
@@ -131,7 +131,7 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 	    priv->rss_map.indir_qp && priv->rss_map.indir_qp->qpn) {
 		int i;
 		int err = 0;
-		int loopback = !!(features & NETIF_F_LOOPBACK);
+		int loopback = netdev_feature_test(NETIF_F_LOOPBACK_BIT, features);
 
 		for (i = 0; i < priv->rx_ring_num; i++) {
 			int ret;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 36a1d28998b3..a7e3ec4f034d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2506,7 +2506,7 @@ static netdev_features_t mlx4_en_fix_features(struct net_device *netdev,
 	 * enable/disable make sure S-TAG flag is always in same state as
 	 * C-TAG.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
 	    !(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
 		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 	else
@@ -2524,12 +2524,12 @@ static int mlx4_en_set_features(struct net_device *netdev,
 
 	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXFCS_BIT)) {
 		en_info(priv, "Turn %s RX-FCS\n",
-			(features & NETIF_F_RXFCS) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_RXFCS_BIT, features) ? "ON" : "OFF");
 		reset = true;
 	}
 
 	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXALL_BIT)) {
-		u8 ignore_fcs_value = (features & NETIF_F_RXALL) ? 1 : 0;
+		u8 ignore_fcs_value = netdev_feature_test(NETIF_F_RXALL_BIT, features) ? 1 : 0;
 
 		en_info(priv, "Turn %s RX-ALL\n",
 			ignore_fcs_value ? "ON" : "OFF");
@@ -2541,21 +2541,21 @@ static int mlx4_en_set_features(struct net_device *netdev,
 
 	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		en_info(priv, "Turn %s RX vlan strip offload\n",
-			(features & NETIF_F_HW_VLAN_CTAG_RX) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) ? "ON" : "OFF");
 		reset = true;
 	}
 
 	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		en_info(priv, "Turn %s TX vlan strip offload\n",
-			(features & NETIF_F_HW_VLAN_CTAG_TX) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features) ? "ON" : "OFF");
 
 	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_STAG_TX_BIT))
 		en_info(priv, "Turn %s TX S-VLAN strip offload\n",
-			(features & NETIF_F_HW_VLAN_STAG_TX) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_HW_VLAN_STAG_TX_BIT, features) ? "ON" : "OFF");
 
 	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_LOOPBACK_BIT)) {
 		en_info(priv, "Turn %s loopback\n",
-			(features & NETIF_F_LOOPBACK) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_LOOPBACK_BIT, features) ? "ON" : "OFF");
 		mlx4_en_update_loopback_state(netdev, features);
 	}
 
@@ -3519,7 +3519,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 		return 0; /* Nothing to change */
 
 	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
-	    (features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
 	    (priv->hwtstamp_config.rx_filter != HWTSTAMP_FILTER_NONE)) {
 		en_warn(priv, "Can't turn ON rx vlan offload while time-stamping rx filter is ON\n");
 		return -EINVAL;
@@ -3546,7 +3546,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 	mlx4_en_safe_replace_resources(priv, tmp);
 
 	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 			netdev_active_feature_add(dev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
@@ -3556,7 +3556,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 		/* RX time-stamping is OFF, update the RX vlan offload
 		 * to the latest wanted state
 		 */
-		if (dev->wanted_features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_wanted_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 			netdev_active_feature_add(dev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
@@ -3565,7 +3565,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 	}
 
 	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT)) {
-		if (features & NETIF_F_RXFCS)
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features))
 			netdev_active_feature_add(dev, NETIF_F_RXFCS_BIT);
 		else
 			netdev_active_feature_del(dev, NETIF_F_RXFCS_BIT);
@@ -3576,7 +3576,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 	 * Turn Off RX vlan offload in case of time-stamping is ON
 	 */
 	if (ts_config.rx_filter != HWTSTAMP_FILTER_NONE) {
-		if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 			en_warn(priv, "Turning off RX vlan offload since RX time-stamping is ON\n");
 		netdev_active_feature_del(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_resources.c b/drivers/net/ethernet/mellanox/mlx4/en_resources.c
index 6883ac75d37f..193bfc0e17b2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_resources.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_resources.c
@@ -76,12 +76,12 @@ void mlx4_en_fill_qp_context(struct mlx4_en_priv *priv, int size, int stride,
 	    context->pri_path.counter_index !=
 			    MLX4_SINK_COUNTER_INDEX(mdev->dev)) {
 		/* disable multicast loopback to qp with same counter */
-		if (!(dev->features & NETIF_F_LOOPBACK))
+		if (!netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT))
 			context->pri_path.fl |= MLX4_FL_ETH_SRC_CHECK_MC_LB;
 		context->pri_path.control |= MLX4_CTRL_ETH_SRC_CHECK_IF_COUNTER;
 	}
 	context->db_rec_addr = cpu_to_be64(priv->res.db.dma << 2);
-	if (!(dev->features & NETIF_F_HW_VLAN_CTAG_RX))
+	if (!netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		context->param3 |= cpu_to_be32(1 << 30);
 
 	if (!is_tx && !rss &&
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 8f762fc170b3..266f119a93c4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -643,7 +643,7 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 	hw_checksum = csum_unfold((__force __sum16)cqe->checksum);
 
 	if (cqe->vlan_my_qpn & cpu_to_be32(MLX4_CQE_CVLAN_PRESENT_MASK) &&
-	    !(dev_features & NETIF_F_HW_VLAN_CTAG_RX)) {
+	    !netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, dev_features)) {
 		hw_checksum = get_fixed_vlan_csum(hw_checksum, hdr);
 		hdr += sizeof(struct vlan_hdr);
 	}
@@ -839,7 +839,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 		}
 		skb_record_rx_queue(skb, cq_ring);
 
-		if (likely(dev->features & NETIF_F_RXCSUM)) {
+		if (likely(netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT))) {
 			/* TODO: For IP non TCP/UDP packets when csum complete is
 			 * not an option (not supported or any other reason) we can
 			 * actually check cqe IPOK status bit and report
@@ -851,7 +851,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			    cqe->checksum == cpu_to_be16(0xffff)) {
 				bool l2_tunnel;
 
-				l2_tunnel = (dev->hw_enc_features & NETIF_F_RXCSUM) &&
+				l2_tunnel = netdev_hw_enc_feature_test(dev, NETIF_F_RXCSUM_BIT) &&
 					(cqe->vlan_my_qpn & cpu_to_be32(MLX4_CQE_L2_TUNNEL));
 				ip_summed = CHECKSUM_UNNECESSARY;
 				hash_type = PKT_HASH_TYPE_L4;
@@ -875,19 +875,19 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			ring->csum_none++;
 		}
 		skb->ip_summed = ip_summed;
-		if (dev->features & NETIF_F_RXHASH)
+		if (netdev_active_feature_test(dev, NETIF_F_RXHASH_BIT))
 			skb_set_hash(skb,
 				     be32_to_cpu(cqe->immed_rss_invalid),
 				     hash_type);
 
 		if ((cqe->vlan_my_qpn &
 		     cpu_to_be32(MLX4_CQE_CVLAN_PRESENT_MASK)) &&
-		    (dev->features & NETIF_F_HW_VLAN_CTAG_RX))
+		    netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       be16_to_cpu(cqe->sl_vid));
 		else if ((cqe->vlan_my_qpn &
 			  cpu_to_be32(MLX4_CQE_SVLAN_PRESENT_MASK)) &&
-			 (dev->features & NETIF_F_HW_VLAN_STAG_RX))
+			 netdev_active_feature_test(dev, NETIF_F_HW_VLAN_STAG_RX_BIT))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD),
 					       be16_to_cpu(cqe->sl_vid));
 
@@ -1085,7 +1085,7 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	/* Cancel FCS removal if FW allows */
 	if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_FCS_KEEP) {
 		context->param3 |= cpu_to_be32(1 << 29);
-		if (priv->dev->features & NETIF_F_RXFCS)
+		if (netdev_active_feature_test(priv->dev, NETIF_F_RXFCS_BIT))
 			ring->fcs_del = 0;
 		else
 			ring->fcs_del = ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 90268776942d..08d556f8fef3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -137,7 +137,7 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 	if (!priv->tls->rx_wq)
 		return -ENOMEM;
 
-	if (priv->netdev->features & NETIF_F_HW_TLS_RX) {
+	if (netdev_active_feature_test(priv->netdev, NETIF_F_HW_TLS_RX_BIT)) {
 		err = mlx5e_accel_fs_tcp_create(priv->fs);
 		if (err) {
 			destroy_workqueue(priv->tls->rx_wq);
@@ -153,7 +153,7 @@ void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 	if (!mlx5e_is_ktls_rx(priv->mdev))
 		return;
 
-	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
+	if (netdev_active_feature_test(priv->netdev, NETIF_F_HW_TLS_RX_BIT))
 		mlx5e_accel_fs_tcp_destroy(priv->fs);
 
 	destroy_workqueue(priv->tls->rx_wq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 29ed20abc3da..adeea7a0bd78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -493,7 +493,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
 
-	arfs_enabled = opened && (priv->netdev->features & NETIF_F_NTUPLE);
+	arfs_enabled = opened && netdev_active_feature_test(priv->netdev, NETIF_F_NTUPLE_BIT);
 	if (arfs_enabled)
 		mlx5e_arfs_disable(priv->fs);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 7cf11c1b93a2..d043952123a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1308,7 +1308,7 @@ int mlx5e_create_flow_steering(struct mlx5e_flow_steering *fs,
 
 	mlx5e_fs_set_ns(fs, ns, false);
 	err = mlx5e_arfs_create_tables(fs, rx_res,
-				       !!(netdev->hw_features & NETIF_F_NTUPLE));
+				       netdev_hw_feature_test(netdev, NETIF_F_NTUPLE_BIT));
 	if (err) {
 		fs_err(fs, "Failed to create arfs tables, err=%d\n", err);
 		netdev_hw_feature_del(netdev, NETIF_F_NTUPLE_BIT);
@@ -1355,7 +1355,8 @@ int mlx5e_create_flow_steering(struct mlx5e_flow_steering *fs,
 err_destroy_inner_ttc_table:
 	mlx5e_destroy_inner_ttc_table(fs);
 err_destroy_arfs_tables:
-	mlx5e_arfs_destroy_tables(fs, !!(netdev->hw_features & NETIF_F_NTUPLE));
+	mlx5e_arfs_destroy_tables(fs,
+				  netdev_hw_feature_test(netdev, NETIF_F_NTUPLE_BIT));
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a67b7be0e500..411cba30ebb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3896,19 +3896,19 @@ static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev
 						       netdev_features_t features)
 {
 	netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, features);
-	if (netdev->features & NETIF_F_HW_TLS_RX)
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_TLS_RX_BIT))
 		netdev_warn(netdev, "Disabling hw_tls_rx, not supported in switchdev mode\n");
 
 	netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, features);
-	if (netdev->features & NETIF_F_HW_TLS_TX)
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_TLS_TX_BIT))
 		netdev_warn(netdev, "Disabling hw_tls_tx, not supported in switchdev mode\n");
 
 	netdev_feature_del(NETIF_F_NTUPLE_BIT, features);
-	if (netdev->features & NETIF_F_NTUPLE)
+	if (netdev_active_feature_test(netdev, NETIF_F_NTUPLE_BIT))
 		netdev_warn(netdev, "Disabling ntuple, not supported in switchdev mode\n");
 
 	netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
-	if (netdev->features & NETIF_F_GRO_HW)
+	if (netdev_active_feature_test(netdev, NETIF_F_GRO_HW_BIT))
 		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
 
 	return features;
@@ -3935,34 +3935,34 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 	}
 
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		if (features & NETIF_F_LRO) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
 			netdev_feature_del(NETIF_F_LRO_BIT, features);
 		}
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_warn(netdev, "Disabling HW-GRO, not supported in legacy RQ\n");
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
 	if (params->xdp_prog) {
-		if (features & NETIF_F_LRO) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 			netdev_warn(netdev, "LRO is incompatible with XDP\n");
 			netdev_feature_del(NETIF_F_LRO_BIT, features);
 		}
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_warn(netdev, "HW GRO is incompatible with XDP\n");
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
 	if (priv->xsk.refcnt) {
-		if (features & NETIF_F_LRO) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 			netdev_warn(netdev, "LRO is incompatible with AF_XDP (%u XSKs are active)\n",
 				    priv->xsk.refcnt);
 			netdev_feature_del(NETIF_F_LRO_BIT, features);
 		}
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_warn(netdev, "HW GRO is incompatible with AF_XDP (%u XSKs are active)\n",
 				    priv->xsk.refcnt);
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
@@ -3971,10 +3971,10 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
 		netdev_feature_del(NETIF_F_RXHASH_BIT, features);
-		if (netdev->features & NETIF_F_RXHASH)
+		if (netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
 
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_warn(netdev, "Disabling HW-GRO, not supported when CQE compress is active\n");
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
 		}
@@ -5140,7 +5140,8 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_tc_nic_cleanup:
 	mlx5e_tc_nic_cleanup(priv);
 err_destroy_flow_steering:
-	mlx5e_destroy_flow_steering(priv->fs, !!(priv->netdev->hw_features & NETIF_F_NTUPLE),
+	mlx5e_destroy_flow_steering(priv->fs,
+				    netdev_hw_feature_test(priv->netdev, NETIF_F_NTUPLE_BIT),
 				    priv->profile);
 err_destroy_rx_res:
 	mlx5e_rx_res_destroy(priv->rx_res);
@@ -5157,7 +5158,8 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 {
 	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
-	mlx5e_destroy_flow_steering(priv->fs, !!(priv->netdev->hw_features & NETIF_F_NTUPLE),
+	mlx5e_destroy_flow_steering(priv->fs,
+				    netdev_hw_feature_test(priv->netdev, NETIF_F_NTUPLE_BIT),
 				    priv->profile);
 	mlx5e_rx_res_destroy(priv->rx_res);
 	mlx5e_close_drop_rq(&priv->drop_rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4d3e7897b51b..990c497e17c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1344,7 +1344,7 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 	int network_depth = 0;
 	__be16 proto;
 
-	if (unlikely(!(netdev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)))
 		goto csum_none;
 
 	if (lro) {
@@ -1441,7 +1441,7 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 								  rq->clock, get_cqe_ts(cqe));
 	skb_record_rx_queue(skb, rq->ix);
 
-	if (likely(netdev->features & NETIF_F_RXHASH))
+	if (likely(netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT)))
 		mlx5e_skb_set_hash(cqe, skb);
 
 	if (cqe_has_vlan(cqe)) {
@@ -2316,7 +2316,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	skb->protocol = *((__be16 *)(skb->data));
 
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)) {
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
 		stats->csum_complete++;
@@ -2330,7 +2330,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 								  rq->clock, get_cqe_ts(cqe));
 	skb_record_rx_queue(skb, rq->ix);
 
-	if (likely(netdev->features & NETIF_F_RXHASH))
+	if (likely(netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT)))
 		mlx5e_skb_set_hash(cqe, skb);
 
 	/* 20 bytes of ipoib header and 4 for encap existing */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0872a214d2a3..2a28051d03d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4831,7 +4831,7 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 	priv = tc->priv;
 	peer_priv = netdev_priv(ndev);
 	if (priv == peer_priv ||
-	    !(priv->netdev->features & NETIF_F_HW_TC))
+	    !netdev_active_feature_test(priv->netdev, NETIF_F_HW_TC_BIT))
 		return NOTIFY_DONE;
 
 	mlx5e_tc_hairpin_update_dead_peer(priv, peer_priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index ac983e9c2b3c..28473094921d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -331,7 +331,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 
 	mlx5e_fs_set_ns(priv->fs, ns, false);
 	err = mlx5e_arfs_create_tables(priv->fs, priv->rx_res,
-				       !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
+				       netdev_hw_feature_test(priv->netdev, NETIF_F_NTUPLE_BIT));
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
 			   err);
@@ -351,7 +351,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv->fs,
-				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
+				  netdev_hw_feature_test(priv->netdev, NETIF_F_NTUPLE_BIT));
 
 	return err;
 }
@@ -360,7 +360,7 @@ static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
 	mlx5e_destroy_ttc_table(priv->fs);
 	mlx5e_arfs_destroy_tables(priv->fs,
-				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
+				  netdev_hw_feature_test(priv->netdev, NETIF_F_NTUPLE_BIT));
 	mlx5e_ethtool_cleanup_steering(priv->fs);
 }
 
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 91b8f9a15018..50789716b1c7 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6507,7 +6507,7 @@ static int netdev_set_features(struct net_device *dev,
 	mutex_lock(&hw_priv->lock);
 
 	/* see note in hw_setup() */
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		hw->rx_cfg |= DMA_RX_CSUM_TCP | DMA_RX_CSUM_IP;
 	else
 		hw->rx_cfg &= ~(DMA_RX_CSUM_TCP | DMA_RX_CSUM_IP);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 934d9e2c4008..594afe94874e 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1586,7 +1586,7 @@ static void lan743x_rfe_set_multicast(struct lan743x_adapter *adapter)
 			rfctl |= RFE_CTL_AM_;
 	}
 
-	if (netdev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT))
 		rfctl |= RFE_CTL_IP_COE_ | RFE_CTL_TCP_UDP_COE_;
 
 	memset(hash_table, 0, DP_SEL_VHF_HASH_LEN * sizeof(u32));
@@ -2669,7 +2669,8 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 	if (is_last && rx->skb_head) {
 		rx->skb_head->protocol = eth_type_trans(rx->skb_head,
 							rx->adapter->netdev);
-		if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
+		if (netdev_active_feature_test(rx->adapter->netdev,
+					       NETIF_F_RXCSUM_BIT)) {
 			if (!is_ice && !is_tce && !is_icsm)
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 		}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 51f8a0816377..23593a7ac617 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -431,7 +431,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 	skb->dev = lan966x->ports[src_port]->dev;
 	skb_pull(skb, IFH_LEN * sizeof(u32));
 
-	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
+	if (likely(!netdev_active_feature_test(skb->dev, NETIF_F_RXFCS_BIT)))
 		skb_trim(skb, skb->len - ETH_FCS_LEN);
 
 	lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index c4c4c282890e..87e144b8bbc9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -641,7 +641,7 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 		/* Update the statistics if part of the FCS was read before */
 		len -= ETH_FCS_LEN - sz;
 
-		if (unlikely(dev->features & NETIF_F_RXFCS)) {
+		if (unlikely(netdev_active_feature_test(dev, NETIF_F_RXFCS_BIT))) {
 			buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
 			*buf = val;
 		}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 66360c8c5a38..6f6c21c5142e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -238,7 +238,7 @@ static bool sparx5_fdma_rx_get_frame(struct sparx5 *sparx5, struct sparx5_rx *rx
 	}
 	skb->dev = port->ndev;
 	skb_pull(skb, IFH_LEN * sizeof(u32));
-	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
+	if (likely(!netdev_active_feature_test(skb->dev, NETIF_F_RXFCS_BIT)))
 		skb_trim(skb, skb->len - ETH_FCS_LEN);
 
 	sparx5_ptp_rxtstamp(sparx5, skb, fi.timestamp);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 8f8cc9bd5577..888d494bbeda 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1139,12 +1139,12 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	skb_checksum_none_assert(skb);
 	skb_record_rx_queue(skb, rxq_idx);
 
-	if ((ndev->features & NETIF_F_RXCSUM) && cqe->rx_iphdr_csum_succeed) {
+	if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT) && cqe->rx_iphdr_csum_succeed) {
 		if (cqe->rx_tcp_csum_succeed || cqe->rx_udp_csum_succeed)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	if (cqe->rx_hashtype != 0 && (ndev->features & NETIF_F_RXHASH)) {
+	if (cqe->rx_hashtype != 0 && netdev_active_feature_test(ndev, NETIF_F_RXHASH_BIT)) {
 		hash_value = cqe->ppi[0].pkt_hash;
 
 		if (cqe->rx_hashtype & MANA_HASH_L4)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 874fb2a5874e..0828c3d23f82 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1042,7 +1042,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 	/* Update the statistics if part of the FCS was read before */
 	len -= ETH_FCS_LEN - sz;
 
-	if (unlikely(dev->features & NETIF_F_RXFCS)) {
+	if (unlikely(netdev_active_feature_test(dev, NETIF_F_RXFCS_BIT))) {
 		buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
 		*buf = val;
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 254958b08505..828fa985f398 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -849,7 +849,7 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 
 	/* Filtering */
 	val = ocelot_read(ocelot, ANA_VLANMASK);
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		val |= BIT(port);
 	else
 		val &= ~BIT(port);
@@ -865,14 +865,15 @@ static int ocelot_set_features(struct net_device *dev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if ((dev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC) &&
+	if (netdev_active_feature_test(dev, NETIF_F_HW_TC_BIT) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
 	    priv->tc.offload_cnt) {
 		netdev_err(dev,
 			   "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed))
 		ocelot_vlan_mode(ocelot, port, features);
 
 	return 0;
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 9f65201a1f70..301edf3f6cc1 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1285,7 +1285,7 @@ myri10ge_vlan_rx(struct net_device *dev, void *addr, struct sk_buff *skb)
 	va = addr;
 	va += MXGEFW_PAD;
 	veh = (struct vlan_ethhdr *)va;
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    veh->h_vlan_proto == htons(ETH_P_8021Q)) {
 		/* fixup csum if needed */
 		if (skb->ip_summed == CHECKSUM_COMPLETE) {
@@ -1363,7 +1363,7 @@ myri10ge_rx_done(struct myri10ge_slice_state *ss, int len, __wsum csum)
 	skb->len = len;
 	skb->data_len = len;
 	skb->truesize += len;
-	if (dev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)) {
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum;
 	}
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 0335a389bb01..2f418dc090d9 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2164,7 +2164,7 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 		(unsigned)readl(dev->base + SRR) >> 8,
 		(unsigned)readl(dev->base + SRR) & 0xff,
 		ndev->dev_addr, addr, pci_dev->irq,
-		(ndev->features & NETIF_F_HIGHDMA) ? "h,sg" : "sg"
+		netdev_active_feature_test(ndev, NETIF_F_HIGHDMA_BIT) ? "h,sg" : "sg"
 		);
 
 #ifdef PHY_CODE_IS_FINISHED
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index c6002fe4d2d3..951dd5045ecb 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6574,7 +6574,7 @@ static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (changed & NETIF_F_LRO && netif_running(dev)) {
+	if (netdev_feature_test(NETIF_F_LRO_BIT, changed) && netif_running(dev)) {
 		int rc;
 
 		s2io_stop_all_tx_queue(sp);
@@ -7125,7 +7125,7 @@ static int s2io_card_up(struct s2io_nic *sp)
 		struct ring_info *ring = &mac_control->rings[i];
 
 		ring->mtu = dev->mtu;
-		ring->lro = !!(dev->features & NETIF_F_LRO);
+		ring->lro = netdev_active_feature_test(dev, NETIF_F_LRO_BIT);
 		ret = fill_rx_buffers(sp, ring, 1);
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
@@ -7159,7 +7159,7 @@ static int s2io_card_up(struct s2io_nic *sp)
 	/* Setting its receive mode */
 	s2io_set_multicast(dev, true);
 
-	if (dev->features & NETIF_F_LRO) {
+	if (netdev_active_feature_test(dev, NETIF_F_LRO_BIT)) {
 		/* Initialize max aggregatable pkts per session based on MTU */
 		sp->lro_max_aggr_per_sess = ((1<<16) - 1) / dev->mtu;
 		/* Check if we can use (if specified) user provided value */
@@ -7371,7 +7371,7 @@ static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp)
 	if ((rxdp->Control_1 & TCP_OR_UDP_FRAME) &&
 	    ((!ring_data->lro) ||
 	     (!(rxdp->Control_1 & RXD_FRAME_IP_FRAG))) &&
-	    (dev->features & NETIF_F_RXCSUM)) {
+	    netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)) {
 		l3_csum = RXD_GET_L3_CKSUM(rxdp->Control_1);
 		l4_csum = RXD_GET_L4_CKSUM(rxdp->Control_1);
 		if ((l3_csum == L3_CKSUM_OK) && (l4_csum == L4_CKSUM_OK)) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 448c1c1afaee..2f5a4ec628b1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -641,7 +641,7 @@ nfp_nfd3_rx_csum(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 {
 	skb_checksum_none_assert(skb);
 
-	if (!(dp->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(dp->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	if (meta->csum_type) {
@@ -685,7 +685,7 @@ static void
 nfp_nfd3_set_hash(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		  unsigned int type, __be32 *hash)
 {
-	if (!(netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 2b427d8ccb2f..b21e5bbb59f5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -650,7 +650,7 @@ nfp_nfdk_rx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 {
 	skb_checksum_none_assert(skb);
 
-	if (!(dp->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(dp->netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	if (meta->csum_type) {
@@ -694,7 +694,7 @@ static void
 nfp_nfdk_set_hash(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		  unsigned int type, __be32 *hash)
 {
-	if (!(netdev->features & NETIF_F_RXHASH))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		return;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 7af1dd2709ac..0f93a60655cb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1676,8 +1676,8 @@ static int nfp_net_set_features(struct net_device *netdev,
 	new_ctrl = nn->dp.ctrl;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_RXCSUM) {
-		if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXCSUM_ANY;
@@ -1698,38 +1698,38 @@ static int nfp_net_set_features(struct net_device *netdev,
 			new_ctrl &= ~NFP_NET_CFG_CTRL_LSO_ANY;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ?:
 				    NFP_NET_CFG_CTRL_RXVLAN;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXVLAN_ANY;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_TX) {
-		if (features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2 ?:
 				    NFP_NET_CFG_CTRL_TXVLAN;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXVLAN_ANY;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 			new_ctrl |= NFP_NET_CFG_CTRL_CTAG_FILTER;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_STAG_RX) {
-		if (features & NETIF_F_HW_VLAN_STAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, features))
 			new_ctrl |= NFP_NET_CFG_CTRL_RXQINQ;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
 	}
 
-	if (changed & NETIF_F_SG) {
-		if (features & NETIF_F_SG)
+	if (netdev_feature_test(NETIF_F_SG_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_SG_BIT, features))
 			new_ctrl |= NFP_NET_CFG_CTRL_GATHER;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_GATHER;
@@ -1760,16 +1760,16 @@ static netdev_features_t
 nfp_net_fix_features(struct net_device *netdev,
 		     netdev_features_t features)
 {
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
-	    (features & NETIF_F_HW_VLAN_STAG_RX)) {
-		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
+	    netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, features)) {
+		if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 			netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT,
 					   features);
 			netdev_wanted_feature_del(netdev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 			netdev_warn(netdev,
 				    "S-tag and C-tag stripping can't be enabled at the same time. Enabling S-tag stripping and disabling C-tag stripping\n");
-		} else if (netdev->features & NETIF_F_HW_VLAN_STAG_RX) {
+		} else if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_STAG_RX_BIT)) {
 			netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT,
 					   features);
 			netdev_wanted_feature_del(netdev,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index c224707f763f..01a1fbf9aa0d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -66,7 +66,8 @@ int nfp_port_set_features(struct net_device *netdev, netdev_features_t features)
 	if (!port)
 		return 0;
 
-	if ((netdev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC) &&
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
 	    port->tc_offload_cnt) {
 		netdev_err(netdev, "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 528bcedda177..9a76c5919d35 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3053,7 +3053,7 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 			 * here. Even if vlan rx accel is disabled,
 			 * NV_RX3_VLAN_TAG_PRESENT is pseudo randomly set.
 			 */
-			if (dev->features & NETIF_F_HW_VLAN_CTAG_RX &&
+			if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 			    vlanflags & NV_RX3_VLAN_TAG_PRESENT) {
 				u16 vid = vlanflags & NV_RX3_VLAN_TAG_MASK;
 
@@ -4881,7 +4881,7 @@ static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
 
 	spin_lock_irqsave(&np->lock, flags);
 	miicontrol = mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ);
-	if (features & NETIF_F_LOOPBACK) {
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features)) {
 		if (miicontrol & BMCR_LOOPBACK) {
 			spin_unlock_irqrestore(&np->lock, flags);
 			netdev_info(dev, "Loopback already enabled\n");
@@ -4943,12 +4943,12 @@ static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
 
 	spin_lock_irq(&np->lock);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		np->txrxctl_bits |= NVREG_TXRXCTL_VLANSTRIP;
 	else
 		np->txrxctl_bits &= ~NVREG_TXRXCTL_VLANSTRIP;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
 		np->txrxctl_bits |= NVREG_TXRXCTL_VLANINS;
 	else
 		np->txrxctl_bits &= ~NVREG_TXRXCTL_VLANINS;
@@ -4966,16 +4966,17 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 	int retval;
 
 	netdev_features_xor(changed, dev->features, features);
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev)) {
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed) &&
+	    netif_running(dev)) {
 		retval = nv_set_loopback(dev, features);
 		if (retval != 0)
 			return retval;
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		spin_lock_irq(&np->lock);
 
-		if (features & NETIF_F_RXCSUM)
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 			np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
 		else
 			np->txrxctl_bits &= ~NVREG_TXRXCTL_RXCHECK;
@@ -5617,7 +5618,7 @@ static int nv_open(struct net_device *dev)
 	/* If the loopback feature was set while the device was down, make sure
 	 * that it's set correctly now.
 	 */
-	if (dev->features & NETIF_F_LOOPBACK)
+	if (netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT))
 		nv_set_loopback(dev, dev->features);
 
 	return 0;
@@ -6121,12 +6122,13 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 		 dev->name, np->phy_oui, np->phyaddr, dev->dev_addr);
 
 	dev_info(&pci_dev->dev, "%s%s%s%s%s%s%s%s%s%s%sdesc-v%u\n",
-		 dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
-		 (dev->features & NETIF_F_IP_CSUM || dev->features & NETIF_F_SG) ?
-			"csum " : "",
+		 netdev_active_feature_test(dev, NETIF_F_HIGHDMA_BIT) ? "highdma " : "",
+		 (netdev_active_feature_test(dev, NETIF_F_IP_CSUM_BIT) ||
+		  netdev_active_feature_test(dev, NETIF_F_SG_BIT)) ?
+		 "csum " : "",
 		 dev->features & netdev_ctag_vlan_offload_features ?
 			"vlan " : "",
-		 dev->features & (NETIF_F_LOOPBACK) ?
+		 netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT) ?
 			"loopback " : "",
 		 id->driver_data & DEV_HAS_POWER_CNTRL ? "pwrctl " : "",
 		 id->driver_data & DEV_HAS_MGMT_UNIT ? "mgmt " : "",
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 0062c75e7d84..452d3fae2f0e 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2209,7 +2209,7 @@ static int pch_gbe_set_features(struct net_device *netdev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (!(changed & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7a68744b7011..081c54db89ef 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1368,37 +1368,37 @@ static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
 {
 	u64 wanted = 0;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
 		wanted |= IONIC_ETH_HW_VLAN_TX_TAG;
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		wanted |= IONIC_ETH_HW_VLAN_RX_STRIP;
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		wanted |= IONIC_ETH_HW_VLAN_RX_FILTER;
-	if (features & NETIF_F_RXHASH)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features))
 		wanted |= IONIC_ETH_HW_RX_HASH;
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_RX_CSUM;
-	if (features & NETIF_F_SG)
+	if (netdev_feature_test(NETIF_F_SG_BIT, features))
 		wanted |= IONIC_ETH_HW_TX_SG;
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_TX_CSUM;
-	if (features & NETIF_F_TSO)
+	if (netdev_feature_test(NETIF_F_TSO_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO;
-	if (features & NETIF_F_TSO6)
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_IPV6;
-	if (features & NETIF_F_TSO_ECN)
+	if (netdev_feature_test(NETIF_F_TSO_ECN_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_ECN;
-	if (features & NETIF_F_GSO_GRE)
+	if (netdev_feature_test(NETIF_F_GSO_GRE_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_GRE;
-	if (features & NETIF_F_GSO_GRE_CSUM)
+	if (netdev_feature_test(NETIF_F_GSO_GRE_CSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_GRE_CSUM;
-	if (features & NETIF_F_GSO_IPXIP4)
+	if (netdev_feature_test(NETIF_F_GSO_IPXIP4_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_IPXIP4;
-	if (features & NETIF_F_GSO_IPXIP6)
+	if (netdev_feature_test(NETIF_F_GSO_IPXIP6_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_IPXIP6;
-	if (features & NETIF_F_GSO_UDP_TUNNEL)
+	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_UDP;
-	if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
+	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_UDP_CSUM;
 
 	return cpu_to_le64(wanted);
@@ -2046,7 +2046,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 		}
 	}
 
-	if (lif->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(lif->netdev, NETIF_F_RXHASH_BIT))
 		ionic_lif_rss_init(lif);
 
 	ionic_lif_rx_mode(lif);
@@ -3130,7 +3130,7 @@ void ionic_lif_deinit(struct ionic_lif *lif)
 		cancel_work_sync(&lif->deferred.work);
 		cancel_work_sync(&lif->tx_timeout_work);
 		ionic_rx_filters_deinit(lif);
-		if (lif->netdev->features & NETIF_F_RXHASH)
+		if (netdev_active_feature_test(lif->netdev, NETIF_F_RXHASH_BIT))
 			ionic_lif_rss_deinit(lif);
 	}
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index c03986bf2628..c9e89ce54c0d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -247,7 +247,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 
 	skb_record_rx_queue(skb, q->index);
 
-	if (likely(netdev->features & NETIF_F_RXHASH)) {
+	if (likely(netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))) {
 		switch (comp->pkt_type_color & IONIC_RXQ_COMP_PKT_TYPE_MASK) {
 		case IONIC_PKT_TYPE_IPV4:
 		case IONIC_PKT_TYPE_IPV6:
@@ -264,7 +264,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		}
 	}
 
-	if (likely(netdev->features & NETIF_F_RXCSUM) &&
+	if (likely(netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)) &&
 	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC)) {
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = (__force __wsum)le16_to_cpu(comp->csum);
@@ -278,7 +278,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		     (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_IP_BAD)))
 		stats->csum_error++;
 
-	if (likely(netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (likely(netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) &&
 	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_VLAN)) {
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       le16_to_cpu(comp->vlan_tci));
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 35ec9aab3dc7..15eb5cd4e3db 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -1497,8 +1497,8 @@ static struct sk_buff *netxen_process_rxbuf(struct netxen_adapter *adapter,
 	if (!skb)
 		goto no_skb;
 
-	if (likely((adapter->netdev->features & NETIF_F_RXCSUM)
-	    && cksum == STATUS_CKSUM_OK)) {
+	if (likely(netdev_active_feature_test(adapter->netdev, NETIF_F_RXCSUM_BIT) &&
+		   cksum == STATUS_CKSUM_OK)) {
 		adapter->stats.csummed++;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	} else
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 1d34037c9bc8..2ca440255aa7 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -523,7 +523,7 @@ static void netxen_set_multicast_list(struct net_device *dev)
 static netdev_features_t netxen_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 		netdev_info(dev, "disabling LRO as RXCSUM is off\n");
 
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
@@ -540,16 +540,16 @@ static int netxen_set_features(struct net_device *dev,
 	int hw_lro;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	hw_lro = (features & NETIF_F_LRO) ? NETXEN_NIC_LRO_ENABLED
+	hw_lro = (netdev_feature_test(NETIF_F_LRO_BIT, features)) ? NETXEN_NIC_LRO_ENABLED
 	         : NETXEN_NIC_LRO_DISABLED;
 
 	if (netxen_config_hw_lro(adapter, hw_lro))
 		return -EIO;
 
-	if (!(features & NETIF_F_LRO) && netxen_send_lro_cleanup(adapter))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, features) && netxen_send_lro_cleanup(adapter))
 		return -EIO;
 
 	return 0;
@@ -1123,7 +1123,7 @@ __netxen_nic_up(struct netxen_adapter *adapter, struct net_device *netdev)
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
 		netxen_config_intr_coalesce(adapter);
 
-	if (netdev->features & NETIF_F_LRO)
+	if (netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 		netxen_config_hw_lro(adapter, NETXEN_NIC_LRO_ENABLED);
 
 	netxen_napi_enable(adapter);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index a3635890a0e2..4fb113d9713e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -916,7 +916,7 @@ netdev_features_t qede_fix_features(struct net_device *dev,
 	struct qede_dev *edev = netdev_priv(dev);
 
 	if (edev->xdp_prog || edev->ndev->mtu > PAGE_SIZE ||
-	    !(features & NETIF_F_GRO))
+	    !netdev_feature_test(NETIF_F_GRO_BIT, features))
 		netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
 
 	return features;
@@ -929,7 +929,7 @@ int qede_set_features(struct net_device *dev, netdev_features_t features)
 	bool need_reload = false;
 
 	netdev_features_xor(changes, dev->features, features);
-	if (changes & NETIF_F_GRO_HW)
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, changes))
 		need_reload = true;
 
 	if (need_reload) {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 49e2278e3e8a..61cc3fb2e808 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1608,7 +1608,7 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 		}
 	}
 
-	edev->gro_disable = !(edev->ndev->features & NETIF_F_GRO_HW);
+	edev->gro_disable = !netdev_active_feature_test(edev->ndev, NETIF_F_GRO_HW_BIT);
 	if (!edev->gro_disable)
 		qede_set_tpa_param(rxq);
 err:
@@ -2791,9 +2791,9 @@ static void qede_get_generic_tlv_data(void *dev, struct qed_generic_tlvs *data)
 	struct netdev_hw_addr *ha;
 	int i;
 
-	if (edev->ndev->features & NETIF_F_IP_CSUM)
+	if (netdev_active_feature_test(edev->ndev, NETIF_F_IP_CSUM_BIT))
 		data->feat_flags |= QED_TLV_IP_CSUM;
-	if (edev->ndev->features & NETIF_F_TSO)
+	if (netdev_active_feature_test(edev->ndev, NETIF_F_TSO_BIT))
 		data->feat_flags |= QED_TLV_LSO;
 
 	ether_addr_copy(data->mac[0], edev->ndev->dev_addr);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index abfe0de86ff9..8228e1d55e38 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1084,7 +1084,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 		}
 	}
 
-	if (!(features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
 	return features;
@@ -1094,11 +1094,11 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	int hw_lro = (features & NETIF_F_LRO) ? QLCNIC_LRO_ENABLED : 0;
+	int hw_lro = netdev_feature_test(NETIF_F_LRO_BIT, features) ? QLCNIC_LRO_ENABLED : 0;
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (!(changed & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
 	netdev_active_feature_change(netdev, NETIF_F_LRO_BIT);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 9da5e97f8a0a..7a2604557d71 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -1152,7 +1152,7 @@ static struct sk_buff *qlcnic_process_rxbuf(struct qlcnic_adapter *adapter,
 			 DMA_FROM_DEVICE);
 
 	skb = buffer->skb;
-	if (likely((adapter->netdev->features & NETIF_F_RXCSUM) &&
+	if (likely(netdev_active_feature_test(adapter->netdev, NETIF_F_RXCSUM_BIT) &&
 		   (cksum == STATUS_CKSUM_OK || cksum == STATUS_CKSUM_LOOP))) {
 		adapter->stats.csummed++;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 590efc540e4f..3115a942a865 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -1889,7 +1889,7 @@ int __qlcnic_up(struct qlcnic_adapter *adapter, struct net_device *netdev)
 
 	qlcnic_config_def_intr_coalesce(adapter);
 
-	if (netdev->features & NETIF_F_LRO)
+	if (netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 		qlcnic_config_hw_lro(adapter, QLCNIC_LRO_ENABLED);
 
 	set_bit(__QLCNIC_DEV_UP, &adapter->state);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 0d80447d4d3b..ce22330ea963 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -286,7 +286,7 @@ void emac_mac_mode_config(struct emac_adapter *adpt)
 	mac = readl(adpt->base + EMAC_MAC_CTRL);
 	mac &= ~(VLAN_STRIP | PROM_MODE | MULTI_ALL | MAC_LP_EN);
 
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		mac |= VLAN_STRIP;
 
 	if (netdev->flags & IFF_PROMISC)
@@ -1143,7 +1143,7 @@ void emac_mac_rx_process(struct emac_adapter *adpt, struct emac_rx_queue *rx_q,
 		skb_put(skb, RRD_PKT_SIZE(&rrd) - ETH_FCS_LEN);
 		skb->dev = netdev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
-		if (netdev->features & NETIF_F_RXCSUM)
+		if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT))
 			skb->ip_summed = RRD_L4F(&rrd) ?
 					  CHECKSUM_NONE : CHECKSUM_UNNECESSARY;
 		else
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 0b06f9875b56..2595fe837c78 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -404,7 +404,7 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 	struct rmnet_priv *priv = netdev_priv(skb->dev);
 	struct rmnet_map_dl_csum_trailer *csum_trailer;
 
-	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
+	if (unlikely(!netdev_active_feature_test(skb->dev, NETIF_F_RXCSUM_BIT))) {
 		priv->stats.csum_sw++;
 		return -EOPNOTSUPP;
 	}
@@ -503,7 +503,7 @@ int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
 	if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
 		return -EINVAL;
 
-	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
+	if (unlikely(!netdev_active_feature_test(skb->dev, NETIF_F_RXCSUM_BIT))) {
 		priv->stats.csum_sw++;
 	} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
 		priv->stats.csum_ok++;
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index eb0fec232e04..56c9e0627577 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1466,17 +1466,17 @@ static int cp_set_features(struct net_device *dev, netdev_features_t features)
 	unsigned long flags;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	spin_lock_irqsave(&cp->lock, flags);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		cp->cpcmd |= RxChkSum;
 	else
 		cp->cpcmd &= ~RxChkSum;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		cp->cpcmd |= RxVlanOn;
 	else
 		cp->cpcmd &= ~RxVlanOn;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index e90df0de255e..24b30873c38d 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -906,14 +906,14 @@ static int rtl8139_set_features(struct net_device *dev, netdev_features_t featur
 	void __iomem *ioaddr = tp->mmio_addr;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_RXALL))
+	if (!netdev_feature_test(NETIF_F_RXALL_BIT, changed))
 		return 0;
 
 	spin_lock_irqsave(&tp->lock, flags);
 
-	if (changed & NETIF_F_RXALL) {
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, changed)) {
 		int rx_mode = tp->rx_config;
-		if (features & NETIF_F_RXALL)
+		if (netdev_feature_test(NETIF_F_RXALL_BIT, features))
 			rx_mode |= (AcceptErr | AcceptRunt);
 		else
 			rx_mode &= ~(AcceptErr | AcceptRunt);
@@ -1972,7 +1972,7 @@ static int rtl8139_rx(struct net_device *dev, struct rtl8139_private *tp,
 		/* read size+status of next frame from DMA ring buffer */
 		rx_status = le32_to_cpu (*(__le32 *) (rx_ring + ring_offset));
 		rx_size = rx_status >> 16;
-		if (likely(!(dev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_active_feature_test(dev, NETIF_F_RXFCS_BIT)))
 			pkt_size = rx_size - 4;
 		else
 			pkt_size = rx_size;
@@ -2013,7 +2013,7 @@ static int rtl8139_rx(struct net_device *dev, struct rtl8139_private *tp,
 		if (unlikely((rx_size > (MAX_ETH_FRAME_SIZE+4)) ||
 			     (rx_size < 8) ||
 			     (!(rx_status & RxStatusOK)))) {
-			if ((dev->features & NETIF_F_RXALL) &&
+			if (netdev_active_feature_test(dev, NETIF_F_RXALL_BIT) &&
 			    (rx_size <= (MAX_ETH_FRAME_SIZE + 4)) &&
 			    (rx_size >= 8) &&
 			    (!(rx_status & RxStatusOK))) {
@@ -2584,7 +2584,7 @@ static void __set_rx_mode (struct net_device *dev)
 		}
 	}
 
-	if (dev->features & NETIF_F_RXALL)
+	if (netdev_active_feature_test(dev, NETIF_F_RXALL_BIT))
 		rx_mode |= (AcceptErr | AcceptRunt);
 
 	/* We can safely update without stopping the chip. */
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4fe234ef92a0..81d7a4eb2a5a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1444,13 +1444,13 @@ static void rtl_set_rx_config_features(struct rtl8169_private *tp,
 {
 	u32 rx_config = RTL_R32(tp, RxConfig);
 
-	if (features & NETIF_F_RXALL)
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, features))
 		rx_config |= RX_CONFIG_ACCEPT_ERR_MASK;
 	else
 		rx_config &= ~RX_CONFIG_ACCEPT_ERR_MASK;
 
 	if (rtl_is_8125(tp)) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 			rx_config |= RX_VLAN_8125;
 		else
 			rx_config &= ~RX_VLAN_8125;
@@ -1466,13 +1466,13 @@ static int rtl8169_set_features(struct net_device *dev,
 
 	rtl_set_rx_config_features(tp, features);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		tp->cp_cmd |= RxChkSum;
 	else
 		tp->cp_cmd &= ~RxChkSum;
 
 	if (!rtl_is_8125(tp)) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 			tp->cp_cmd |= RxVlan;
 		else
 			tp->cp_cmd &= ~RxVlan;
@@ -4432,14 +4432,14 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 			if (status & RxCRC)
 				dev->stats.rx_crc_errors++;
 
-			if (!(dev->features & NETIF_F_RXALL))
+			if (!netdev_active_feature_test(dev, NETIF_F_RXALL_BIT))
 				goto release_descriptor;
 			else if (status & RxRWT || !(status & (RxRUNT | RxCRC)))
 				goto release_descriptor;
 		}
 
 		pkt_size = status & GENMASK(13, 0);
-		if (likely(!(dev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_active_feature_test(dev, NETIF_F_RXFCS_BIT)))
 			pkt_size -= ETH_FCS_LEN;
 
 		/* The driver does not support incoming fragmented frames.
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d7d6f2798d88..49c2d8aa3c25 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -554,7 +554,7 @@ static void ravb_emac_init_rcar(struct net_device *ndev)
 
 	/* EMAC Mode: PAUSE prohibition; Duplex; RX Checksum; TX; RX */
 	ravb_write(ndev, ECMR_ZPF | ECMR_DM |
-		   (ndev->features & NETIF_F_RXCSUM ? ECMR_RCSC : 0) |
+		   (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT) ? ECMR_RCSC : 0) |
 		   ECMR_TE | ECMR_RE, ECMR);
 
 	ravb_set_rate_rcar(ndev);
@@ -953,7 +953,7 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 
 			skb_put(skb, pkt_len);
 			skb->protocol = eth_type_trans(skb, ndev);
-			if (ndev->features & NETIF_F_RXCSUM)
+			if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT))
 				ravb_rx_csum(skb);
 			napi_gro_receive(&priv->napi[q], skb);
 			stats->rx_packets++;
@@ -2339,8 +2339,9 @@ static int ravb_set_features_rcar(struct net_device *ndev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, ndev->features, features);
-	if (changed & NETIF_F_RXCSUM)
-		ravb_set_rx_csum(ndev, features & NETIF_F_RXCSUM);
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
+		ravb_set_rx_csum(ndev,
+				 netdev_feature_test(NETIF_F_RXCSUM_BIT, features));
 
 	ndev->features = features;
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index b01318964100..4a55c969241c 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1507,7 +1507,7 @@ static int sh_eth_dev_init(struct net_device *ndev)
 
 	/* EMAC Mode: PAUSE prohibition; Duplex; RX Checksum; TX; RX */
 	sh_eth_write(ndev, ECMR_ZPF | (mdp->duplex ? ECMR_DM : 0) |
-		     (ndev->features & NETIF_F_RXCSUM ? ECMR_RCSC : 0) |
+		     (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT) ? ECMR_RCSC : 0) |
 		     ECMR_TE | ECMR_RE, ECMR);
 
 	if (mdp->cd->set_rate)
@@ -1657,7 +1657,7 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status, int *quota)
 					 DMA_FROM_DEVICE);
 			skb_put(skb, pkt_len);
 			skb->protocol = eth_type_trans(skb, ndev);
-			if (ndev->features & NETIF_F_RXCSUM)
+			if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT))
 				sh_eth_rx_csum(skb);
 			netif_receive_skb(skb);
 			ndev->stats.rx_packets++;
@@ -2936,8 +2936,9 @@ static int sh_eth_set_features(struct net_device *ndev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, ndev->features, features);
-	if (changed & NETIF_F_RXCSUM && mdp->cd->rx_csum)
-		sh_eth_set_rx_csum(ndev, features & NETIF_F_RXCSUM);
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) && mdp->cd->rx_csum)
+		sh_eth_set_rx_csum(ndev,
+				   netdev_feature_test(NETIF_F_RXCSUM_BIT, features));
 
 	ndev->features = features;
 
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 97f884c1993b..da2f375ad180 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1782,8 +1782,8 @@ static int sxgbe_set_features(struct net_device *dev,
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (changed & NETIF_F_RXCSUM) {
-		if (features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 			priv->hw->mac->enable_rx_csum(priv->ioaddr);
 			priv->rxcsum_insertion = true;
 		} else {
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 7c4338bddab3..3aefa37ae5ce 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2713,7 +2713,7 @@ static u16 efx_ef10_handle_rx_event_errors(struct efx_channel *channel,
 	bool handled = false;
 
 	if (EFX_QWORD_FIELD(*event, ESF_DZ_RX_ECRC_ERR)) {
-		if (!(efx->net_dev->features & NETIF_F_RXALL)) {
+		if (!netdev_active_feature_test(efx->net_dev, NETIF_F_RXALL_BIT)) {
 			if (!efx->loopback_selftest)
 				channel->n_rx_eth_crc_err += n_packets;
 			return EFX_RX_PKT_DISCARD;
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 65bbe37753e6..dcdca4cddc67 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -68,7 +68,7 @@ void __ef100_rx_packet(struct efx_channel *channel)
 	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
 
 	if (ef100_has_fcs_error(channel, prefix) &&
-	    unlikely(!(efx->net_dev->features & NETIF_F_RXALL)))
+	    unlikely(!netdev_active_feature_test(efx->net_dev, NETIF_F_RXALL_BIT)))
 		goto out;
 
 	rx_buf->len = le16_to_cpu((__force __le16)PREFIX_FIELD(prefix, LENGTH));
@@ -111,7 +111,7 @@ void __ef100_rx_packet(struct efx_channel *channel)
 		goto free_rx_buffer;
 	}
 
-	if (likely(efx->net_dev->features & NETIF_F_RXCSUM)) {
+	if (likely(netdev_active_feature_test(efx->net_dev, NETIF_F_RXCSUM_BIT))) {
 		if (PREFIX_FIELD(prefix, NT_OR_INNER_L3_CLASS) == 1) {
 			++channel->n_rx_ip_hdr_chksum_err;
 		} else {
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 102ddc7e206a..a6c8ae23faeb 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -61,7 +61,7 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 
 	if (!skb_is_gso_tcp(skb))
 		return false;
-	if (!(efx->net_dev->features & NETIF_F_TSO))
+	if (!netdev_active_feature_test(efx->net_dev, NETIF_F_TSO_BIT))
 		return false;
 
 	mss = skb_shinfo(skb)->gso_size;
@@ -175,9 +175,9 @@ static void ef100_make_send_desc(struct efx_nic *efx,
 			     ESF_GZ_TX_SEND_LEN, buffer->len,
 			     ESF_GZ_TX_SEND_ADDR, buffer->dma_addr);
 
-	if (likely(efx->net_dev->features & NETIF_F_HW_CSUM))
+	if (likely(netdev_active_feature_test(efx->net_dev, NETIF_F_HW_CSUM_BIT)))
 		ef100_set_tx_csum_partial(skb, buffer, txd);
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX &&
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_HW_VLAN_CTAG_TX_BIT) &&
 	    skb && skb_vlan_tag_present(skb))
 		ef100_set_tx_hw_vlan(skb, txd);
 }
@@ -202,7 +202,7 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
 		mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		vlan_enable = skb_vlan_tag_present(skb);
 
 	len = skb->len - buffer->len;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 9f6c4a971c48..b723b9851544 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1005,8 +1005,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
-	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
-	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
+	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, *efx->type->offload_features) ||
+	    netdev_feature_test(NETIF_F_HW_CSUM_BIT, *efx->type->offload_features))
 		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 3d57a23022b7..f106c9e995a6 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -218,7 +218,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
 	netdev_features_andnot(tmp, net_dev->features, data);
-	if (tmp & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, tmp)) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -228,8 +228,8 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
 	netdev_features_xor(tmp, net_dev->features, data);
-	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER ||
-	    tmp & NETIF_F_RXFCS) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, tmp) ||
+	    netdev_feature_test(NETIF_F_RXFCS_BIT, tmp)) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 854e1bca7ac9..8b37fc2e134e 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -1689,7 +1689,8 @@ static int ef4_probe_filters(struct ef4_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT,
+				*efx->type->offload_features)) {
 		struct ef4_channel *channel;
 		int i, success = 1;
 
@@ -2187,7 +2188,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
 	netdev_features_andnot(tmp, net_dev->features, data);
-	if (tmp & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, tmp)) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -2195,7 +2196,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
 	netdev_features_xor(tmp, net_dev->features, data);
-	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, tmp)) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 6bbdb5d2eebf..e3edf8ef2eb7 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -443,7 +443,7 @@ ef4_rx_packet_gro(struct ef4_channel *channel, struct ef4_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, ef4_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
 	skb->ip_summed = ((rx_buf->flags & EF4_RX_PKT_CSUMMED) ?
@@ -672,7 +672,7 @@ void __ef4_rx_packet(struct ef4_channel *channel)
 		goto out;
 	}
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(efx->net_dev, NETIF_F_RXCSUM_BIT)))
 		rx_buf->flags &= ~EF4_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EF4_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 64d01b301585..fb4db91f4d8f 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1302,6 +1302,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 {
 	struct net_device *net_dev = efx->net_dev;
 	struct efx_mcdi_filter_table *table;
+	netdev_features_t feats;
 	int rc;
 
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
@@ -1323,7 +1324,8 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		rc = efx_mcdi_filter_table_probe_matches(efx, table, true);
 	if (rc)
 		goto fail;
-	if ((efx_supported_features(efx) & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	feats = efx_supported_features(efx);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, feats) &&
 	    !(efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC)) &&
 	      efx_mcdi_filter_match_supported(table, false,
@@ -1347,7 +1349,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 
 	table->mc_promisc_last = false;
 	table->vlan_filter =
-		!!(efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		netdev_active_feature_test(efx->net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	INIT_LIST_HEAD(&table->vlan_list);
 	init_rwsem(&table->lock);
 
@@ -1764,7 +1766,7 @@ void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
 	 * Do it in advance to avoid conflicts for unicast untagged and
 	 * VLAN 0 tagged filters.
 	 */
-	vlan_filter = !!(net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+	vlan_filter = netdev_active_feature_test(net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	if (table->vlan_filter != vlan_filter) {
 		table->vlan_filter = vlan_filter;
 		efx_mcdi_filter_remove_old(efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 899cc1671004..52f24c51cdfc 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -1110,7 +1110,7 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 
 	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_FLAGS,
 			      SET_MAC_IN_FLAG_INCLUDE_FCS,
-			      !!(efx->net_dev->features & NETIF_F_RXFCS));
+			      netdev_active_feature_test(efx->net_dev, NETIF_F_RXFCS_BIT));
 
 	switch (efx->wanted_fc) {
 	case EFX_FC_RX | EFX_FC_TX:
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 2375cef577e4..f64ae5623309 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -387,7 +387,7 @@ void __efx_rx_packet(struct efx_channel *channel)
 	if (!efx_do_xdp(efx, channel, rx_buf, &eh))
 		goto out;
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(efx->net_dev, NETIF_F_RXCSUM_BIT)))
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EFX_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index ab83fd836031..ba6296325f38 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -520,7 +520,7 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH &&
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_RXHASH_BIT) &&
 	    efx_rx_buf_hash_valid(efx, eh))
 		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
@@ -798,7 +798,7 @@ int efx_probe_filters(struct efx_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, *efx->type->offload_features)) {
 		struct efx_channel *channel;
 		int i, success = 1;
 
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index e5937694bbb1..0583c4be58ce 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -988,8 +988,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
-	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
-	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
+	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, *efx->type->offload_features) ||
+	    netdev_feature_test(NETIF_F_HW_CSUM_BIT, *efx->type->offload_features))
 		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 2693b2386916..f37dd541a593 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -216,7 +216,8 @@ int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if ((net_dev->features & NETIF_F_NTUPLE) && !(data & NETIF_F_NTUPLE)) {
+	if (netdev_active_feature_test(net_dev, NETIF_F_NTUPLE_BIT) &&
+	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, data)) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -226,7 +227,8 @@ int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
 	netdev_features_xor(features, net_dev->features, data);
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) || (features & NETIF_F_RXFCS)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) ||
+	    netdev_feature_test(NETIF_F_RXFCS_BIT, features)) {
 		/* efx_siena_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index 89ccd65c978b..3047cf1c50cf 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -923,7 +923,7 @@ static u16 efx_farch_handle_rx_not_ok(struct efx_rx_queue *rx_queue,
 	(void) rx_ev_other_err;
 #endif
 
-	if (efx->net_dev->features & NETIF_F_RXALL)
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_RXALL_BIT))
 		/* don't discard frame for CRC error */
 		rx_ev_eth_crc_err = false;
 
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
index 067fe0f4393a..012cae6eb990 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
@@ -1119,7 +1119,7 @@ int efx_siena_mcdi_set_mac(struct efx_nic *efx)
 
 	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_FLAGS,
 			      SET_MAC_IN_FLAG_INCLUDE_FCS,
-			      !!(efx->net_dev->features & NETIF_F_RXFCS));
+			      netdev_active_feature_test(efx->net_dev, NETIF_F_RXFCS_BIT));
 
 	switch (efx->wanted_fc) {
 	case EFX_FC_RX | EFX_FC_TX:
diff --git a/drivers/net/ethernet/sfc/siena/rx.c b/drivers/net/ethernet/sfc/siena/rx.c
index 98d3c0743c0f..36729823ffd9 100644
--- a/drivers/net/ethernet/sfc/siena/rx.c
+++ b/drivers/net/ethernet/sfc/siena/rx.c
@@ -387,7 +387,7 @@ void __efx_siena_rx_packet(struct efx_channel *channel)
 	if (!efx_do_xdp(efx, channel, rx_buf, &eh))
 		goto out;
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(efx->net_dev, NETIF_F_RXCSUM_BIT)))
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EFX_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/siena/rx_common.c b/drivers/net/ethernet/sfc/siena/rx_common.c
index be17b8676fff..7d98d0af06d9 100644
--- a/drivers/net/ethernet/sfc/siena/rx_common.c
+++ b/drivers/net/ethernet/sfc/siena/rx_common.c
@@ -525,7 +525,7 @@ efx_siena_rx_packet_gro(struct efx_channel *channel,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
 	if (csum) {
@@ -805,7 +805,7 @@ int efx_siena_probe_filters(struct efx_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, *efx->type->offload_features)) {
 		struct efx_channel *channel;
 		int i, success = 1;
 
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index de799075704a..57cc1b3ddd72 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -397,7 +397,7 @@ static inline void ioc3_rx(struct net_device *dev)
 				goto next;
 			}
 
-			if (likely(dev->features & NETIF_F_RXCSUM))
+			if (likely(netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT)))
 				ioc3_tcpudp_checksum(skb,
 						     w0 & ERXBUF_IPCKSUM_MASK,
 						     len);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index af4fc0b60a7e..d594f6b312f2 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1752,7 +1752,7 @@ static int netsec_netdev_set_features(struct net_device *ndev,
 {
 	struct netsec_priv *priv = netdev_priv(ndev);
 
-	priv->rx_cksum_offload_flag = !!(features & NETIF_F_RXCSUM);
+	priv->rx_cksum_offload_flag = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index c25bfecb4a2d..3e5e259198b2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -718,7 +718,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	}
 
 	/* VLAN filtering */
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		value |= GMAC_PACKET_FILTER_VTFE;
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 49a314e709ff..05dc3483757d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3158,7 +3158,7 @@ static void stmmac_mac_config_rss(struct stmmac_priv *priv)
 		return;
 	}
 
-	if (priv->dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(priv->dev, NETIF_F_RXHASH_BIT))
 		priv->rss.enable = true;
 	else
 		priv->rss.enable = false;
@@ -4532,9 +4532,9 @@ static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 	vlan_proto = veth->h_vlan_proto;
 
 	if ((vlan_proto == htons(ETH_P_8021Q) &&
-	     dev->features & NETIF_F_HW_VLAN_CTAG_RX) ||
+	     netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) ||
 	    (vlan_proto == htons(ETH_P_8021AD) &&
-	     dev->features & NETIF_F_HW_VLAN_STAG_RX)) {
+	     netdev_active_feature_test(dev, NETIF_F_HW_VLAN_STAG_RX_BIT))) {
 		/* pop the vlan tag */
 		vlanid = ntohs(veth->h_vlan_TCI);
 		memmove(skb->data + VLAN_HLEN, veth, ETH_ALEN * 2);
@@ -5606,7 +5606,7 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 
 	/* Disable tso if asked by ethtool */
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		if (features & NETIF_F_TSO)
+		if (netdev_feature_test(NETIF_F_TSO_BIT, features))
 			priv->tso = true;
 		else
 			priv->tso = false;
@@ -5621,7 +5621,7 @@ static int stmmac_set_features(struct net_device *netdev,
 	struct stmmac_priv *priv = netdev_priv(netdev);
 
 	/* Keep the COE Type in case of csum is supporting */
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		priv->hw->rx_csum = priv->plat->rx_coe;
 	else
 		priv->hw->rx_csum = 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 49af7e78b7f5..c632b335b41c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -974,7 +974,7 @@ static int stmmac_test_vlanfilt_perfect(struct stmmac_priv *priv)
 {
 	int ret, prev_cap = priv->dma_cap.vlhash;
 
-	if (!(priv->dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	if (!netdev_active_feature_test(priv->dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		return -EOPNOTSUPP;
 
 	priv->dma_cap.vlhash = 0;
@@ -1068,7 +1068,7 @@ static int stmmac_test_dvlanfilt_perfect(struct stmmac_priv *priv)
 {
 	int ret, prev_cap = priv->dma_cap.vlhash;
 
-	if (!(priv->dev->features & NETIF_F_HW_VLAN_STAG_FILTER))
+	if (!netdev_active_feature_test(priv->dev, NETIF_F_HW_VLAN_STAG_FILTER_BIT))
 		return -EOPNOTSUPP;
 
 	priv->dma_cap.vlhash = 0;
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 1fae42ea9879..c95c5d2f31f2 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3492,7 +3492,7 @@ static int niu_process_rx_pkt(struct napi_struct *napi, struct niu *np,
 	__pskb_pull_tail(skb, len);
 
 	rh = (struct rx_pkt_hdr1 *) skb->data;
-	if (np->dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(np->dev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb,
 			     ((u32)rh->hashval2_0 << 24 |
 			      (u32)rh->hashval2_1 << 16 |
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 7418e4400763..ccd06f237ef9 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -843,7 +843,7 @@ static int gem_rx(struct gem *gp, int work_to_do)
 			skb = copy_skb;
 		}
 
-		if (likely(dev->features & NETIF_F_RXCSUM)) {
+		if (likely(netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT))) {
 			__sum16 csum;
 
 			csum = (__force __sum16)htons((status & RXDCTRL_TCPCSUM) ^ 0xffff);
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
index 76eb7db80f13..7bdab63032a1 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
@@ -263,7 +263,7 @@ static int xlgmac_set_promiscuous_mode(struct xlgmac_pdata *pdata,
 	if (enable) {
 		xlgmac_disable_rx_vlan_filtering(pdata);
 	} else {
-		if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		if (netdev_active_feature_test(pdata->netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 			xlgmac_enable_rx_vlan_filtering(pdata);
 	}
 
@@ -404,7 +404,7 @@ static void xlgmac_config_jumbo_enable(struct xlgmac_pdata *pdata)
 
 static void xlgmac_config_checksum_offload(struct xlgmac_pdata *pdata)
 {
-	if (pdata->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_RXCSUM_BIT))
 		xlgmac_enable_rx_csum(pdata);
 	else
 		xlgmac_disable_rx_csum(pdata);
@@ -425,12 +425,12 @@ static void xlgmac_config_vlan_support(struct xlgmac_pdata *pdata)
 	/* Set the current VLAN Hash Table register value */
 	xlgmac_update_vlan_hash_table(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		xlgmac_enable_rx_vlan_filtering(pdata);
 	else
 		xlgmac_disable_rx_vlan_filtering(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		xlgmac_enable_rx_vlan_stripping(pdata);
 	else
 		xlgmac_disable_rx_vlan_stripping(pdata);
@@ -2433,7 +2433,7 @@ static void xlgmac_config_rss(struct xlgmac_pdata *pdata)
 	if (!pdata->hw_feat.rss)
 		return;
 
-	if (pdata->netdev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(pdata->netdev, NETIF_F_RXHASH_BIT))
 		ret = xlgmac_enable_rss(pdata);
 	else
 		ret = xlgmac_disable_rss(pdata);
@@ -2760,7 +2760,7 @@ static int xlgmac_dev_read(struct xlgmac_channel *channel)
 			0);
 
 	/* Set checksum done indicator as appropriate */
-	if (netdev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT))
 		pkt_info->attributes = XLGMAC_SET_REG_BITS(
 				pkt_info->attributes,
 				RX_PACKET_ATTRIBUTES_CSUM_DONE_POS,
@@ -2779,7 +2779,7 @@ static int xlgmac_dev_read(struct xlgmac_channel *channel)
 	if (!err || !etlt) {
 		/* No error if err is 0 or etlt is 0 */
 		if ((etlt == 0x09) &&
-		    (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
+		    netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 			pkt_info->attributes = XLGMAC_SET_REG_BITS(
 					pkt_info->attributes,
 					RX_PACKET_ATTRIBUTES_VLAN_CTAG_POS,
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index e54ce73396ee..302304ccb41f 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -884,31 +884,33 @@ static int xlgmac_set_features(struct net_device *netdev,
 	struct xlgmac_hw_ops *hw_ops = &pdata->hw_ops;
 	int ret = 0;
 
-	rxhash = pdata->netdev_features & NETIF_F_RXHASH;
-	rxcsum = pdata->netdev_features & NETIF_F_RXCSUM;
-	rxvlan = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_RX;
-	rxvlan_filter = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	if ((features & NETIF_F_RXHASH) && !rxhash)
+	rxhash = netdev_feature_test(NETIF_F_RXHASH_BIT, pdata->netdev_features);
+	rxcsum = netdev_feature_test(NETIF_F_RXCSUM_BIT, pdata->netdev_features);
+	rxvlan = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				     pdata->netdev_features);
+	rxvlan_filter = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    pdata->netdev_features);
+
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) && !rxhash)
 		ret = hw_ops->enable_rss(pdata);
-	else if (!(features & NETIF_F_RXHASH) && rxhash)
+	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, features) && rxhash)
 		ret = hw_ops->disable_rss(pdata);
 	if (ret)
 		return ret;
 
-	if ((features & NETIF_F_RXCSUM) && !rxcsum)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !rxcsum)
 		hw_ops->enable_rx_csum(pdata);
-	else if (!(features & NETIF_F_RXCSUM) && rxcsum)
+	else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && rxcsum)
 		hw_ops->disable_rx_csum(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) && !rxvlan)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && !rxvlan)
 		hw_ops->enable_rx_vlan_stripping(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) && rxvlan)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && rxvlan)
 		hw_ops->disable_rx_vlan_stripping(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) && !rxvlan_filter)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && !rxvlan_filter)
 		hw_ops->enable_rx_vlan_filtering(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) && rxvlan_filter)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && rxvlan_filter)
 		hw_ops->disable_rx_vlan_filtering(pdata);
 
 	pdata->netdev_features = features;
@@ -1219,7 +1221,7 @@ static int xlgmac_rx_poll(struct xlgmac_channel *channel, int budget)
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
-		if (!(netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (!netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 		    (skb->protocol == htons(ETH_P_8021Q)))
 			max_len += VLAN_HLEN;
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6bac37951b65..a64c450ce149 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -664,7 +664,7 @@ static void am65_cpsw_nuss_rx_csum(struct sk_buff *skb, u32 csum_info)
 	 */
 	skb_checksum_none_assert(skb);
 
-	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(skb->dev, NETIF_F_RXCSUM_BIT)))
 		return;
 
 	if ((csum_info & (AM65_CPSW_RX_PSD_IPV6_VALID |
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 54df79fe38ff..6a90ced12df5 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -936,7 +936,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	/* checksum offload */
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)) {
 		if ((data_status & GELIC_DESCR_DATA_STATUS_CHK_MASK) &&
 		    (!(data_error & GELIC_DESCR_DATA_ERROR_CHK_MASK)))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index f78387987793..4edb4efee977 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -967,7 +967,7 @@ spider_net_pass_skb_up(struct spider_net_descr *descr,
 
 	/* checksum offload */
 	skb_checksum_none_assert(skb);
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT)) {
 		if ( ( (data_status & SPIDER_NET_DATA_STATUS_CKSUM_MASK) ==
 		       SPIDER_NET_DATA_STATUS_CKSUM_MASK) &&
 		     !(data_error & SPIDER_NET_DATA_ERR_CKSUM_MASK))
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 4a9522689fa4..802c07df0e06 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -142,7 +142,7 @@ int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
 
-	if (prog && (dev->features & NETIF_F_LRO)) {
+	if (prog && (netdev_active_feature_test(dev, NETIF_F_LRO_BIT))) {
 		netdev_err(dev, "XDP: not support LRO\n");
 		NL_SET_ERR_MSG_MOD(extack, "XDP: not support LRO");
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index e9d8ffa45703..98e2b649fabf 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -846,13 +846,15 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	}
 
 	/* Do L4 checksum offload if enabled and present. */
-	if ((ppi_flags & NVSC_RSC_CSUM_INFO) && (net->features & NETIF_F_RXCSUM)) {
+	if ((ppi_flags & NVSC_RSC_CSUM_INFO) &&
+	    netdev_active_feature_test(net, NETIF_F_RXCSUM_BIT)) {
 		if (csum_info->receive.tcp_checksum_succeeded ||
 		    csum_info->receive.udp_checksum_succeeded)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	if ((ppi_flags & NVSC_RSC_HASH_INFO) && (net->features & NETIF_F_RXHASH))
+	if ((ppi_flags & NVSC_RSC_HASH_INFO) &&
+	    netdev_active_feature_test(net, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, *hash_info, PKT_HASH_TYPE_L4);
 
 	if (ppi_flags & NVSC_RSC_VLAN) {
@@ -1911,7 +1913,7 @@ static netdev_features_t netvsc_fix_features(struct net_device *ndev,
 	if (!nvdev || nvdev->destroy)
 		return features;
 
-	if ((features & NETIF_F_LRO) && netvsc_xdp_get(nvdev)) {
+	if (netdev_feature_test(NETIF_F_LRO_BIT, features) && netvsc_xdp_get(nvdev)) {
 		netdev_feature_change(NETIF_F_LRO_BIT, features);
 		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
 	}
@@ -1933,12 +1935,12 @@ static int netvsc_set_features(struct net_device *ndev,
 		return -ENODEV;
 
 	netdev_features_xor(change, ndev->features, features);
-	if (!(change & NETIF_F_LRO))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, change))
 		goto syncvf;
 
 	memset(&offloads, 0, sizeof(struct ndis_offload_params));
 
-	if (features & NETIF_F_LRO) {
+	if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		offloads.rsc_ip_v4 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 		offloads.rsc_ip_v6 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 	} else {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 29b2376f9ef3..d5d94b6a7a0c 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1419,7 +1419,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	if (hwcaps.rsc.ip4 && hwcaps.rsc.ip6) {
 		netdev_hw_feature_add(net, NETIF_F_LRO_BIT);
 
-		if (net->features & NETIF_F_LRO) {
+		if (netdev_active_feature_test(net, NETIF_F_LRO_BIT)) {
 			offloads.rsc_ip_v4 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 			offloads.rsc_ip_v6 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 		} else {
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f81674c5a3de..0527988c4daf 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -344,7 +344,8 @@ static bool macsec_check_offload(enum macsec_offload offload,
 		return macsec->real_dev->phydev &&
 		       macsec->real_dev->phydev->macsec_ops;
 	else if (offload == MACSEC_OFFLOAD_MAC)
-		return macsec->real_dev->features & NETIF_F_HW_MACSEC &&
+		return netdev_active_feature_test(macsec->real_dev,
+						  NETIF_F_HW_MACSEC_BIT) &&
 		       macsec->real_dev->macsec_ops;
 
 	return false;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 498cb6e04a87..0207298835a0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -629,7 +629,7 @@ static int macvlan_open(struct net_device *dev)
 	/* Attempt to populate accel_priv which is used to offload the L2
 	 * forwarding requests for unicast packets.
 	 */
-	if (lowerdev->features & NETIF_F_HW_L2FW_DOFFLOAD)
+	if (netdev_active_feature_test(lowerdev, NETIF_F_HW_L2FW_DOFFLOAD_BIT))
 		vlan->accel_priv =
 		      lowerdev->netdev_ops->ndo_dfwd_add_station(lowerdev, dev);
 
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 2bea292328a5..962a0a9c0307 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -489,7 +489,7 @@ static int net_failover_slave_pre_register(struct net_device *slave_dev,
 				  !dev_is_pci(slave_dev->dev.parent)))
 		return -EINVAL;
 
-	if (failover_dev->features & NETIF_F_VLAN_CHALLENGED &&
+	if (netdev_active_feature_test(failover_dev, NETIF_F_VLAN_CHALLENGED_BIT) &&
 	    vlan_uses_dev(failover_dev)) {
 		netdev_err(failover_dev, "Device %s is VLAN challenged and failover device has VLAN set up\n",
 			   failover_dev->name);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index f2c03b964f54..00f660d89c82 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -233,7 +233,8 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	if ((dev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC))
+	if (netdev_active_feature_test(dev, NETIF_F_HW_TC_BIT) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features))
 		return nsim_bpf_disable_tc(ns);
 
 	return 0;
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index db31ebdb6b64..90dd849cb6c9 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -547,7 +547,8 @@ static int tap_open(struct inode *inode, struct file *file)
 	 * The macvlan supports zerocopy iff the lower device supports zero
 	 * copy so we don't have to look at the lower device directly.
 	 */
-	if ((tap->dev->features & NETIF_F_HIGHDMA) && (tap->dev->features & NETIF_F_SG))
+	if (netdev_active_feature_test(tap->dev, NETIF_F_HIGHDMA_BIT) &&
+	    netdev_active_feature_test(tap->dev, NETIF_F_SG_BIT))
 		sock_set_flag(&q->sk, SOCK_ZEROCOPY);
 
 	err = tap_set_queue(tap, file, q);
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index dc6df0ba0a26..7e1c22c955ca 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1167,7 +1167,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		return -EBUSY;
 	}
 
-	if (port_dev->features & NETIF_F_VLAN_CHALLENGED &&
+	if (netdev_active_feature_test(port_dev, NETIF_F_VLAN_CHALLENGED_BIT) &&
 	    vlan_uses_dev(dev)) {
 		NL_SET_ERR_MSG(extack, "Device is VLAN challenged and team device has VLAN set up");
 		netdev_err(dev, "Device %s is VLAN challenged and team device has VLAN set up\n",
@@ -1232,7 +1232,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		goto err_enable_netpoll;
 	}
 
-	if (!(dev->features & NETIF_F_LRO))
+	if (!netdev_active_feature_test(dev, NETIF_F_LRO_BIT))
 		dev_disable_lro(port_dev);
 
 	err = netdev_rx_handler_register(port_dev, team_handle_frame,
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 134de64d4be7..6687081c5e37 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -598,23 +598,23 @@ static int aqc111_set_features(struct net_device *net,
 	u8 reg8 = 0;
 
 	netdev_features_xor(changed, net->features, features);
-	if (changed & NETIF_F_IP_CSUM) {
+	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
 		reg8 ^= SFR_TXCOE_TCP | SFR_TXCOE_UDP;
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL,
 				 1, 1, &reg8);
 	}
 
-	if (changed & NETIF_F_IPV6_CSUM) {
+	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
 		reg8 ^= SFR_TXCOE_TCPV6 | SFR_TXCOE_UDPV6;
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL,
 				 1, 1, &reg8);
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_RXCOE_CTL, 1, 1, &reg8);
-		if (features & NETIF_F_RXCSUM) {
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 			aqc111_data->rx_checksum = 1;
 			reg8 &= ~(SFR_RXCOE_IP | SFR_RXCOE_TCP | SFR_RXCOE_UDP |
 				  SFR_RXCOE_TCPV6 | SFR_RXCOE_UDPV6);
@@ -627,8 +627,8 @@ static int aqc111_set_features(struct net_device *net,
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_RXCOE_CTL,
 				 1, 1, &reg8);
 	}
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
 			u16 i = 0;
 
 			for (i = 0; i < 256; i++) {
@@ -908,17 +908,17 @@ static void aqc111_configure_csum_offload(struct usbnet *dev)
 {
 	u8 reg8 = 0;
 
-	if (dev->net->features & NETIF_F_RXCSUM) {
+	if (netdev_active_feature_test(dev->net, NETIF_F_RXCSUM_BIT)) {
 		reg8 |= SFR_RXCOE_IP | SFR_RXCOE_TCP | SFR_RXCOE_UDP |
 			SFR_RXCOE_TCPV6 | SFR_RXCOE_UDPV6;
 	}
 	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_RXCOE_CTL, 1, 1, &reg8);
 
 	reg8 = 0;
-	if (dev->net->features & NETIF_F_IP_CSUM)
+	if (netdev_active_feature_test(dev->net, NETIF_F_IP_CSUM_BIT))
 		reg8 |= SFR_TXCOE_IP | SFR_TXCOE_TCP | SFR_TXCOE_UDP;
 
-	if (dev->net->features & NETIF_F_IPV6_CSUM)
+	if (netdev_active_feature_test(dev->net, NETIF_F_IPV6_CSUM_BIT))
 		reg8 |= SFR_TXCOE_TCPV6 | SFR_TXCOE_UDPV6;
 
 	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
@@ -935,7 +935,7 @@ static int aqc111_link_reset(struct usbnet *dev)
 
 		/* Vlan Tag Filter */
 		reg8 = SFR_VLAN_CONTROL_VSO;
-		if (dev->net->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		if (netdev_active_feature_test(dev->net, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 			reg8 |= SFR_VLAN_CONTROL_VFE;
 
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_VLAN_ID_CONTROL,
@@ -1241,7 +1241,7 @@ static struct sk_buff *aqc111_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 			   AQ_TX_DESC_VLAN_SHIFT;
 	}
 
-	if (!dev->can_dma_sg && (dev->net->features & NETIF_F_SG) &&
+	if (!dev->can_dma_sg && netdev_active_feature_test(dev->net, NETIF_F_SG_BIT) &&
 	    skb_linearize(skb))
 		return NULL;
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 755d99e1815a..3f3c7da6f758 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -901,19 +901,19 @@ ax88179_set_features(struct net_device *net, netdev_features_t features)
 	netdev_features_t changed;
 
 	netdev_features_xor(changed, net->features, features);
-	if (changed & NETIF_F_IP_CSUM) {
+	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_TXCOE_TCP | AX_TXCOE_UDP;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 	}
 
-	if (changed & NETIF_F_IPV6_CSUM) {
+	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
 		       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
@@ -1481,7 +1481,7 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 
 	headroom = skb_headroom(skb) - 8;
 
-	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb))
+	if (netdev_active_feature_test(dev->net, NETIF_F_SG_BIT) && skb_linearize(skb))
 		return NULL;
 
 	if ((skb_header_cloned(skb) || headroom < 0) &&
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 027a1c5103f8..db7eae1b976e 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2600,7 +2600,7 @@ static int lan78xx_set_features(struct net_device *netdev,
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
-	if (features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 		pdata->rfe_ctl |= RFE_CTL_TCPUDP_COE_ | RFE_CTL_IP_COE_;
 		pdata->rfe_ctl |= RFE_CTL_ICMP_COE_ | RFE_CTL_IGMP_COE_;
 	} else {
@@ -2608,12 +2608,12 @@ static int lan78xx_set_features(struct net_device *netdev,
 		pdata->rfe_ctl &= ~(RFE_CTL_ICMP_COE_ | RFE_CTL_IGMP_COE_);
 	}
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		pdata->rfe_ctl |= RFE_CTL_VLAN_STRIP_;
 	else
 		pdata->rfe_ctl &= ~RFE_CTL_VLAN_STRIP_;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		pdata->rfe_ctl |= RFE_CTL_VLAN_FILTER_;
 	else
 		pdata->rfe_ctl &= ~RFE_CTL_VLAN_FILTER_;
@@ -3542,10 +3542,10 @@ static void lan78xx_rx_csum_offload(struct lan78xx_net *dev,
 	/* HW Checksum offload appears to be flawed if used when not stripping
 	 * VLAN headers. Drop back to S/W checksums under these conditions.
 	 */
-	if (!(dev->net->features & NETIF_F_RXCSUM) ||
+	if (!netdev_active_feature_test(dev->net, NETIF_F_RXCSUM_BIT) ||
 	    unlikely(rx_cmd_a & RX_CMD_A_ICSM_) ||
 	    ((rx_cmd_a & RX_CMD_A_FVTG_) &&
-	     !(dev->net->features & NETIF_F_HW_VLAN_CTAG_RX))) {
+	     !netdev_active_feature_test(dev->net, NETIF_F_HW_VLAN_CTAG_RX_BIT))) {
 		skb->ip_summed = CHECKSUM_NONE;
 	} else {
 		skb->csum = ntohs((u16)(rx_cmd_b >> RX_CMD_B_CSUM_SHIFT_));
@@ -3557,7 +3557,7 @@ static void lan78xx_rx_vlan_offload(struct lan78xx_net *dev,
 				    struct sk_buff *skb,
 				    u32 rx_cmd_a, u32 rx_cmd_b)
 {
-	if ((dev->net->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_active_feature_test(dev->net, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    (rx_cmd_a & RX_CMD_A_FVTG_))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       (rx_cmd_b & 0xffff));
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ba71a6d9a9da..e835a7be2a67 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2349,7 +2349,7 @@ static u8 r8152_rx_csum(struct r8152 *tp, struct rx_desc *rx_desc)
 	u8 checksum = CHECKSUM_NONE;
 	u32 opts2, opts3;
 
-	if (!(tp->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(tp->netdev, NETIF_F_RXCSUM_BIT))
 		goto return_result;
 
 	opts2 = le32_to_cpu(rx_desc->opts2);
@@ -3267,8 +3267,8 @@ static int rtl8152_set_features(struct net_device *dev,
 
 	mutex_lock(&tp->control);
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 			rtl_rx_vlan_en(tp, true);
 		else
 			rtl_rx_vlan_en(tp, false);
@@ -5447,7 +5447,8 @@ static void r8152b_exit_oob(struct r8152 *tp)
 	ocp_write_dword(tp, MCU_TYPE_USB, USB_TX_DMA,
 			TEST_MODE_DISABLE | TX_SIZE_ADJUST1);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp,
+		       netdev_active_feature_test(tp->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT));
 
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
 
@@ -5892,7 +5893,8 @@ static void r8153_first_init(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp,
+		       netdev_active_feature_test(tp->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT));
 
 	rtl8153_change_mtu(tp);
 
@@ -6403,7 +6405,8 @@ static void rtl8153c_up(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp,
+		       netdev_active_feature_test(tp->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT));
 
 	rtl8153c_change_mtu(tp);
 
@@ -6495,7 +6498,8 @@ static void rtl8156_up(struct r8152 *tp)
 	ocp_data &= ~MCU_BORW_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp,
+		       netdev_active_feature_test(tp->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT));
 
 	rtl8156_change_mtu(tp);
 
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 2d216c0d74de..d3f64cdadfd4 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -944,7 +944,7 @@ static int smsc75xx_set_features(struct net_device *netdev,
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		pdata->rfe_ctl |= RFE_CTL_TCPUDP_CKM | RFE_CTL_IP_CKM;
 	else
 		pdata->rfe_ctl &= ~(RFE_CTL_TCPUDP_CKM | RFE_CTL_IP_CKM);
@@ -2170,7 +2170,7 @@ static int smsc75xx_resume(struct usb_interface *intf)
 static void smsc75xx_rx_csum_offload(struct usbnet *dev, struct sk_buff *skb,
 				     u32 rx_cmd_a, u32 rx_cmd_b)
 {
-	if (!(dev->net->features & NETIF_F_RXCSUM) ||
+	if (!netdev_active_feature_test(dev->net, NETIF_F_RXCSUM_BIT) ||
 	    unlikely(rx_cmd_a & RX_CMD_A_LCSM)) {
 		skb->ip_summed = CHECKSUM_NONE;
 	} else {
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 8f667e5eb246..43ba97ab1a82 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -601,12 +601,12 @@ static int smsc95xx_set_features(struct net_device *netdev,
 	if (ret < 0)
 		return ret;
 
-	if (features & NETIF_F_IP_CSUM)
+	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, features))
 		read_buf |= Tx_COE_EN_;
 	else
 		read_buf &= ~Tx_COE_EN_;
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		read_buf |= Rx_COE_EN_;
 	else
 		read_buf &= ~Rx_COE_EN_;
@@ -1824,7 +1824,7 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 
 			/* last frame in this batch */
 			if (skb->len == size) {
-				if (dev->net->features & NETIF_F_RXCSUM)
+				if (netdev_active_feature_test(dev->net, NETIF_F_RXCSUM_BIT))
 					smsc95xx_rx_csum_offload(skb);
 				skb_trim(skb, skb->len - 4); /* remove fcs */
 				skb->truesize = size + sizeof(struct sk_buff);
@@ -1842,7 +1842,7 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			ax_skb->data = packet;
 			skb_set_tail_pointer(ax_skb, size);
 
-			if (dev->net->features & NETIF_F_RXCSUM)
+			if (netdev_active_feature_test(dev->net, NETIF_F_RXCSUM_BIT))
 				smsc95xx_rx_csum_offload(ax_skb);
 			skb_trim(ax_skb, ax_skb->len - 4); /* remove fcs */
 			ax_skb->truesize = size + sizeof(struct sk_buff);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 1b6d33903a47..9d972158bf7b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -307,8 +307,8 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 {
 	return !(dev->features & NETIF_F_ALL_TSO) ||
 		(skb->destructor == sock_wfree &&
-		 (rcv->features & NETIF_F_GRO_FRAGLIST ||
-		  rcv->features & NETIF_F_GRO_UDP_FWD));
+		 (netdev_active_feature_test(rcv, NETIF_F_GRO_FRAGLIST_BIT) ||
+		  netdev_active_feature_test(rcv, NETIF_F_GRO_UDP_FWD_BIT)));
 }
 
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -1059,7 +1059,7 @@ static void veth_napi_del(struct net_device *dev)
 
 static bool veth_gro_requested(const struct net_device *dev)
 {
-	return !!(dev->wanted_features & NETIF_F_GRO);
+	return netdev_wanted_feature_test(dev, NETIF_F_GRO_BIT);
 }
 
 static int veth_enable_xdp_range(struct net_device *dev, int start, int end,
@@ -1476,10 +1476,11 @@ static int veth_set_features(struct net_device *dev,
 	int err;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_xdp_prog)
+	if (!netdev_feature_test(NETIF_F_GRO_BIT, changed) ||
+	    !(dev->flags & IFF_UP) || priv->_xdp_prog)
 		return 0;
 
-	if (features & NETIF_F_GRO) {
+	if (netdev_feature_test(NETIF_F_GRO_BIT, features)) {
 		err = veth_napi_enable(dev);
 		if (err)
 			return err;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ad16d382af9c..917df26f3794 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1267,7 +1267,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		return;
 
 	hdr = skb_vnet_hdr(skb);
-	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
+	if (netdev_active_feature_test(dev, NETIF_F_RXHASH_BIT) && vi->has_rss_hash_report)
 		virtio_skb_set_hash((const struct virtio_net_hdr_v1_hash *)hdr, skb);
 
 	if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
@@ -2582,7 +2582,7 @@ static bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *
 	if (new_hashtypes != vi->rss_hash_types_saved) {
 		vi->rss_hash_types_saved = new_hashtypes;
 		vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
-		if (vi->dev->features & NETIF_F_RXHASH)
+		if (netdev_active_feature_test(vi->dev, NETIF_F_RXHASH_BIT))
 			return virtnet_commit_rss_command(vi);
 	}
 
@@ -3217,11 +3217,11 @@ static int virtnet_set_features(struct net_device *dev,
 	int err;
 
 	netdev_features_xor(changed, dev->features, features);
-	if (changed & NETIF_F_GRO_HW) {
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, changed)) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
-		if (features & NETIF_F_GRO_HW)
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
 			offloads = vi->guest_offloads_capable;
 		else
 			offloads = vi->guest_offloads_capable &
@@ -3233,8 +3233,8 @@ static int virtnet_set_features(struct net_device *dev,
 		vi->guest_offloads = offloads;
 	}
 
-	if (changed & NETIF_F_RXHASH) {
-		if (features & NETIF_F_RXHASH)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed)) {
+		if (netdev_feature_test(NETIF_F_RXHASH_BIT, features))
 			vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
 		else
 			vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index ccead2500579..e9671df05780 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1271,7 +1271,7 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		struct sk_buff *skb,
 		union Vmxnet3_GenericDesc *gdesc)
 {
-	if (!gdesc->rcd.cnc && adapter->netdev->features & NETIF_F_RXCSUM) {
+	if (!gdesc->rcd.cnc && netdev_active_feature_test(adapter->netdev, NETIF_F_RXCSUM_BIT)) {
 		if (gdesc->rcd.v4 &&
 		    (le32_to_cpu(gdesc->dword[3]) &
 		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
@@ -1527,7 +1527,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 
 #ifdef VMXNET3_RSS
 			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
-			    (adapter->netdev->features & NETIF_F_RXHASH)) {
+			    netdev_active_feature_test(adapter->netdev, NETIF_F_RXHASH_BIT)) {
 				enum pkt_hash_types hash_type;
 
 				switch (rcd->rssType) {
@@ -1631,7 +1631,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
 			if (!rcd->tcp ||
-			    !(adapter->netdev->features & NETIF_F_LRO))
+			    !netdev_active_feature_test(adapter->netdev, NETIF_F_LRO_BIT))
 				goto not_lro;
 
 			if (segCnt != 0 && mss != 0) {
@@ -1662,7 +1662,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (unlikely(rcd->ts))
 				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), rcd->tci);
 
-			if (adapter->netdev->features & NETIF_F_LRO)
+			if (netdev_active_feature_test(adapter->netdev, NETIF_F_LRO_BIT))
 				netif_receive_skb(skb);
 			else
 				napi_gro_receive(&rq->napi, skb);
@@ -2582,18 +2582,18 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	devRead->misc.ddLen = cpu_to_le32(sizeof(struct vmxnet3_adapter));
 
 	/* set up feature flags */
-	if (adapter->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_RXCSUM_BIT))
 		devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
 
-	if (adapter->netdev->features & NETIF_F_LRO) {
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_LRO_BIT)) {
 		devRead->misc.uptFeatures |= UPT1_F_LRO;
 		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
 	}
-	if (adapter->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		devRead->misc.uptFeatures |= UPT1_F_RXVLAN;
 
-	if (adapter->netdev->features & NETIF_F_GSO_UDP_TUNNEL ||
-	    adapter->netdev->features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
+	if (netdev_active_feature_test(adapter->netdev, NETIF_F_GSO_UDP_TUNNEL_BIT) ||
+	    netdev_active_feature_test(adapter->netdev, NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT))
 		devRead->misc.uptFeatures |= UPT1_F_RXINNEROFLD;
 
 	devRead->misc.mtu = cpu_to_le32(adapter->netdev->mtu);
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 8d664a9e4bd9..25daec280b1a 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -250,7 +250,7 @@ netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
 				       netdev_features_t features)
 {
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!(features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 
 	return features;
@@ -317,10 +317,10 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_feat
 					       NETIF_F_TSO_BIT,
 					       NETIF_F_TSO6_BIT,
 					       NETIF_F_LRO_BIT);
-		if (features & NETIF_F_GSO_UDP_TUNNEL)
+		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, features))
 			netdev_hw_enc_feature_add(netdev,
 						  NETIF_F_GSO_UDP_TUNNEL_BIT);
-		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
+		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features))
 			netdev_hw_enc_feature_add(netdev,
 						  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
@@ -421,11 +421,11 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
 
 	netdev_features_xor(changed, netdev->features, features);
-	if (changed & NETIF_F_RXCSUM ||
-	    changed & NETIF_F_LRO ||
-	    changed & NETIF_F_HW_VLAN_CTAG_RX ||
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) ||
+	    netdev_feature_test(NETIF_F_LRO_BIT, changed) ||
+	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) ||
 	    changed & tun_offload_mask) {
-		if (features & NETIF_F_RXCSUM)
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXCSUM;
 		else
@@ -433,14 +433,14 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 			~UPT1_F_RXCSUM;
 
 		/* update hardware LRO capability accordingly */
-		if (features & NETIF_F_LRO)
+		if (netdev_feature_test(NETIF_F_LRO_BIT, features))
 			adapter->shared->devRead.misc.uptFeatures |=
 							UPT1_F_LRO;
 		else
 			adapter->shared->devRead.misc.uptFeatures &=
 							~UPT1_F_LRO;
 
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXVLAN;
 		else
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 756c2c8a8b96..9ae4af581545 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1126,7 +1126,7 @@ static int ath6kl_set_features(struct net_device *dev,
 	struct ath6kl *ar = vif->ar;
 	int err = 0;
 
-	if ((features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) &&
 	    (ar->rx_meta_ver != WMI_META_VERSION_2)) {
 		ar->rx_meta_ver = WMI_META_VERSION_2;
 		err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
@@ -1137,7 +1137,7 @@ static int ath6kl_set_features(struct net_device *dev,
 			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 			return err;
 		}
-	} else if (!(features & NETIF_F_RXCSUM) &&
+	} else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) &&
 		   (ar->rx_meta_ver == WMI_META_VERSION_2)) {
 		ar->rx_meta_ver = 0;
 		err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a56fab6232a9..ab32745f9732 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -391,7 +391,7 @@ netdev_tx_t ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
-		if ((dev->features & NETIF_F_IP_CSUM) &&
+		if (netdev_active_feature_test(dev, NETIF_F_IP_CSUM_BIT) &&
 		    (csum == CHECKSUM_PARTIAL)) {
 			csum_start = skb->csum_start -
 					(skb_network_header(skb) - skb->head) +
@@ -410,7 +410,7 @@ netdev_tx_t ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			goto fail_tx;
 		}
 
-		if ((dev->features & NETIF_F_IP_CSUM) &&
+		if (netdev_active_feature_test(dev, NETIF_F_IP_CSUM_BIT) &&
 		    (csum == CHECKSUM_PARTIAL)) {
 			meta_v2.csum_start = csum_start;
 			meta_v2.csum_dest = csum_dest;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 49ca1e168fc5..20c68f832923 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -271,7 +271,7 @@ static void iwl_mvm_rx_csum(struct ieee80211_sta *sta,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
 
-	if (mvmvif->features & NETIF_F_RXCSUM &&
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, mvmvif->features) &&
 	    status & RX_MPDU_RES_STATUS_CSUM_DONE &&
 	    status & RX_MPDU_RES_STATUS_CSUM_OK)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 2c43a9989783..11c09b1ab7b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -494,7 +494,7 @@ static void iwl_mvm_rx_csum(struct iwl_mvm *mvm,
 
 		mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
 
-		if (mvmvif->features & NETIF_F_RXCSUM &&
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, mvmvif->features) &&
 		    flags & IWL_RX_L3L4_TCP_UDP_CSUM_OK &&
 		    (flags & IWL_RX_L3L4_IP_HDR_CSUM_OK ||
 		     l3_prot == IWL_RX_L3_TYPE_IPV6 ||
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index ef885d29fe45..ace8ebaaaabf 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -240,7 +240,7 @@ static const struct attribute_group xennet_dev_group;
 
 static bool xennet_can_sg(struct net_device *dev)
 {
-	return dev->features & NETIF_F_SG;
+	return netdev_active_feature_test(dev, NETIF_F_SG_BIT);
 }
 
 
@@ -1474,20 +1474,20 @@ static netdev_features_t xennet_fix_features(struct net_device *dev,
 {
 	struct netfront_info *np = netdev_priv(dev);
 
-	if (features & NETIF_F_SG &&
+	if (netdev_feature_test(NETIF_F_SG_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-sg", 0))
 		netdev_feature_del(NETIF_F_SG_BIT, features);
 
-	if (features & NETIF_F_IPV6_CSUM &&
+	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend,
 				  "feature-ipv6-csum-offload", 0))
 		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, features);
 
-	if (features & NETIF_F_TSO &&
+	if (netdev_feature_test(NETIF_F_TSO_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv4", 0))
 		netdev_feature_del(NETIF_F_TSO_BIT, features);
 
-	if (features & NETIF_F_TSO6 &&
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv6", 0))
 		netdev_feature_del(NETIF_F_TSO6_BIT, features);
 
@@ -1497,7 +1497,7 @@ static netdev_features_t xennet_fix_features(struct net_device *dev,
 static int xennet_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
-	if (!(features & NETIF_F_SG) && dev->mtu > ETH_DATA_LEN) {
+	if (!netdev_feature_test(NETIF_F_SG_BIT, features) && dev->mtu > ETH_DATA_LEN) {
 		netdev_info(dev, "Reducing MTU because no SG offload");
 		dev->mtu = ETH_DATA_LEN;
 	}
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6105c02a723b..d4005c2cca70 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5501,7 +5501,7 @@ static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
 {
 	struct napi_struct *napi = &card->napi;
 
-	if (is_cso && (card->dev->features & NETIF_F_RXCSUM)) {
+	if (is_cso && netdev_active_feature_test(card->dev, NETIF_F_RXCSUM_BIT)) {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		QETH_CARD_STAT_INC(card, rx_skb_csum);
 	} else {
@@ -6798,33 +6798,38 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 	QETH_CARD_HEX(card, 2, &features, sizeof(features));
 
 	netdev_features_xor(changed, dev->features, features);
-	if ((changed & NETIF_F_IP_CSUM)) {
-		rc = qeth_set_ipa_csum(card, features & NETIF_F_IP_CSUM,
+	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, changed)) {
+		rc = qeth_set_ipa_csum(card,
+				       netdev_feature_test(NETIF_F_IP_CSUM_BIT, features),
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4,
 				       &card->info.has_lp2lp_cso_v4);
 		if (rc)
 			netdev_feature_change(NETIF_F_IP_CSUM_BIT, changed);
 	}
-	if (changed & NETIF_F_IPV6_CSUM) {
-		rc = qeth_set_ipa_csum(card, features & NETIF_F_IPV6_CSUM,
+	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, changed)) {
+		rc = qeth_set_ipa_csum(card,
+				       netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features),
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV6,
 				       &card->info.has_lp2lp_cso_v6);
 		if (rc)
 			netdev_feature_change(NETIF_F_IPV6_CSUM_BIT, changed);
 	}
-	if (changed & NETIF_F_RXCSUM) {
-		rc = qeth_set_ipa_rx_csum(card, features & NETIF_F_RXCSUM);
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
+		rc = qeth_set_ipa_rx_csum(card,
+					  netdev_feature_test(NETIF_F_RXCSUM_BIT, features));
 		if (rc)
 			netdev_feature_change(NETIF_F_RXCSUM_BIT, changed);
 	}
-	if (changed & NETIF_F_TSO) {
-		rc = qeth_set_ipa_tso(card, features & NETIF_F_TSO,
+	if (netdev_feature_test(NETIF_F_TSO_BIT, changed)) {
+		rc = qeth_set_ipa_tso(card,
+				      netdev_feature_test(NETIF_F_TSO_BIT, features),
 				      QETH_PROT_IPV4);
 		if (rc)
 			netdev_feature_change(NETIF_F_TSO_BIT, changed);
 	}
-	if (changed & NETIF_F_TSO6) {
-		rc = qeth_set_ipa_tso(card, features & NETIF_F_TSO6,
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, changed)) {
+		rc = qeth_set_ipa_tso(card,
+				      netdev_feature_test(NETIF_F_TSO6_BIT, features),
 				      QETH_PROT_IPV6);
 		if (rc)
 			netdev_feature_change(NETIF_F_TSO6_BIT, changed);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 34a64b5f4502..28f21ea7bb81 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1890,9 +1890,9 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		}
 
 		/* allow for de-acceleration of NETIF_F_HW_VLAN_CTAG_TX: */
-		if (card->dev->hw_features & NETIF_F_TSO6)
+		if (netdev_hw_feature_test(card->dev, NETIF_F_TSO6_BIT))
 			headroom = sizeof(struct qeth_hdr_tso) + VLAN_HLEN;
-		else if (card->dev->hw_features & NETIF_F_TSO)
+		else if (netdev_hw_feature_test(card->dev, NETIF_F_TSO_BIT))
 			headroom = sizeof(struct qeth_hdr_tso);
 		else
 			headroom = sizeof(struct qeth_hdr) + VLAN_HLEN;
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6ec296321ffc..e9cc09187b6e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -653,19 +653,19 @@ static void fcoe_netdev_features_change(struct fc_lport *lport,
 {
 	mutex_lock(&lport->lp_mutex);
 
-	if (netdev->features & NETIF_F_SG)
+	if (netdev_active_feature_test(netdev, NETIF_F_SG_BIT))
 		lport->sg_supp = 1;
 	else
 		lport->sg_supp = 0;
 
-	if (netdev->features & NETIF_F_FCOE_CRC) {
+	if (netdev_active_feature_test(netdev, NETIF_F_FCOE_CRC_BIT)) {
 		lport->crc_offload = 1;
 		FCOE_NETDEV_DBG(netdev, "Supports FCCRC offload\n");
 	} else {
 		lport->crc_offload = 0;
 	}
 
-	if (netdev->features & NETIF_F_FSO) {
+	if (netdev_active_feature_test(netdev, NETIF_F_FSO_BIT)) {
 		lport->seq_offload = 1;
 		lport->lso_max = min(netdev->gso_max_size, GSO_LEGACY_MAX_SIZE);
 		FCOE_NETDEV_DBG(netdev, "Supports LSO for max len 0x%x\n",
@@ -722,7 +722,7 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	 * will return 0, so do this first.
 	 */
 	mfs = netdev->mtu;
-	if (netdev->features & NETIF_F_FCOE_MTU) {
+	if (netdev_active_feature_test(netdev, NETIF_F_FCOE_MTU_BIT)) {
 		mfs = FCOE_MTU;
 		FCOE_NETDEV_DBG(netdev, "Supports FCOE_MTU of %d bytes\n", mfs);
 	}
@@ -1548,7 +1548,7 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	skb->priority = fcoe->priority;
 
 	if (is_vlan_dev(fcoe->netdev) &&
-	    fcoe->realdev->features & NETIF_F_HW_VLAN_CTAG_TX) {
+	    netdev_active_feature_test(fcoe->realdev, NETIF_F_HW_VLAN_CTAG_TX_BIT)) {
 		/* must set skb->dev before calling vlan_put_tag */
 		skb->dev = fcoe->realdev;
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
@@ -1863,7 +1863,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	case NETDEV_CHANGE:
 		break;
 	case NETDEV_CHANGEMTU:
-		if (netdev->features & NETIF_F_FCOE_MTU)
+		if (netdev_active_feature_test(netdev, NETIF_F_FCOE_MTU_BIT))
 			break;
 		mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
 				     sizeof(struct fcoe_crc_eof));
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 6bcf77c35bab..5e158dbf987f 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -387,7 +387,7 @@ static int qlge_set_mac_addr_reg(struct qlge_adapter *qdev, const u8 *addr,
 		cam_output = (CAM_OUT_ROUTE_NIC |
 			      (qdev->func << CAM_OUT_FUNC_SHIFT) |
 			      (0 << CAM_OUT_CQ_ID_SHIFT));
-		if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_active_feature_test(qdev->ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 			cam_output |= CAM_OUT_RV;
 		/* route to NIC core */
 		qlge_write32(qdev, MAC_ADDR_DATA, cam_output);
@@ -1396,7 +1396,7 @@ static void qlge_update_mac_hdr_len(struct qlge_adapter *qdev,
 {
 	u16 *tags;
 
-	if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(qdev->ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		return;
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) {
 		tags = (u16 *)page;
@@ -1511,7 +1511,7 @@ static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
 	skb->protocol = eth_type_trans(skb, ndev);
 	skb_checksum_none_assert(skb);
 
-	if ((ndev->features & NETIF_F_RXCSUM) &&
+	if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT) &&
 	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
@@ -1618,7 +1618,7 @@ static void qlge_process_mac_rx_skb(struct qlge_adapter *qdev,
 	/* If rx checksum is on, and there are no
 	 * csum or frame errors.
 	 */
-	if ((ndev->features & NETIF_F_RXCSUM) &&
+	if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT) &&
 	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
@@ -1905,7 +1905,7 @@ static void qlge_process_mac_split_rx_intr(struct qlge_adapter *qdev,
 	/* If rx checksum is on, and there are no
 	 * csum or frame errors.
 	 */
-	if ((ndev->features & NETIF_F_RXCSUM) &&
+	if (netdev_active_feature_test(ndev, NETIF_F_RXCSUM_BIT) &&
 	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
@@ -1944,7 +1944,7 @@ static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
 {
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
 	u16 vlan_id = ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) &&
-		       (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)) ?
+		       netdev_active_feature_test(qdev->ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) ?
 		((le16_to_cpu(ib_mac_rsp->vlan_id) &
 		  IB_MAC_IOCB_RSP_VLAN_MASK)) : 0xffff;
 
@@ -2224,7 +2224,7 @@ static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		qlge_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK |
 			     NIC_RCV_CFG_VLAN_MATCH_AND_NON);
 	} else {
@@ -2274,7 +2274,7 @@ static int qlge_set_features(struct net_device *ndev,
 	int err;
 
 	netdev_features_xor(changed, ndev->features, features);
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		/* Update the behavior of vlan accel in the adapter */
 		err = qlge_update_hw_vlan_features(ndev, features);
 		if (err)
@@ -3573,7 +3573,7 @@ static int qlge_adapter_initialize(struct qlge_adapter *qdev)
 	/* Set the default queue, and VLAN behavior. */
 	value = NIC_RCV_CFG_DFQ;
 	mask = NIC_RCV_CFG_DFQ_MASK;
-	if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_active_feature_test(qdev->ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		value |= NIC_RCV_CFG_RV;
 		mask |= (NIC_RCV_CFG_RV << 16);
 	}
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 890ea73b4ffb..173bf09b4cad 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -318,9 +318,11 @@ static inline bool eth_type_vlan(__be16 ethertype)
 static inline bool vlan_hw_offload_capable(netdev_features_t features,
 					   __be16 proto)
 {
-	if (proto == htons(ETH_P_8021Q) && features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (proto == htons(ETH_P_8021Q) &&
+	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
 		return true;
-	if (proto == htons(ETH_P_8021AD) && features & NETIF_F_HW_VLAN_STAG_TX)
+	if (proto == htons(ETH_P_8021AD) &&
+	    netdev_feature_test(NETIF_F_HW_VLAN_STAG_TX_BIT, features))
 		return true;
 	return false;
 }
@@ -568,7 +570,7 @@ static inline int __vlan_hwaccel_get_tag(const struct sk_buff *skb,
  */
 static inline int vlan_get_tag(const struct sk_buff *skb, u16 *vlan_tci)
 {
-	if (skb->dev->features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (netdev_active_feature_test(skb->dev, NETIF_F_HW_VLAN_CTAG_TX_BIT)) {
 		return __vlan_hwaccel_get_tag(skb, vlan_tci);
 	} else {
 		return __vlan_get_tag(skb, vlan_tci);
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 97b0edf5d2f7..0650d003ccf0 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -700,8 +700,9 @@ static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
-	if ((f1 & NETIF_F_HW_CSUM) != (f2 & NETIF_F_HW_CSUM)) {
-		if (f1 & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, f1) !=
+	    netdev_feature_test(NETIF_F_HW_CSUM_BIT, f2)) {
+		if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, f1))
 			netdev_features_set(f1, netdev_ip_csum_features);
 		else
 			netdev_features_set(f2, netdev_ip_csum_features);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 78e26b2e94b4..a9e231ea116e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2377,7 +2377,7 @@ static inline bool __netdev_feature_test(int nr, const netdev_features_t *src)
 
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
+	if (!netdev_active_feature_test(dev, NETIF_F_GRO_BIT) || dev->xdp_prog)
 		return true;
 	return false;
 }
@@ -4407,7 +4407,7 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_LOCK(dev, txq, cpu) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if (netdev_active_feature_test(dev, NETIF_F_LLTX_BIT) == 0) {	\
 		__netif_tx_lock(txq, cpu);		\
 	} else {					\
 		__netif_tx_acquire(txq);		\
@@ -4415,12 +4415,12 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_TRYLOCK(dev, txq)			\
-	(((dev->features & NETIF_F_LLTX) == 0) ?	\
+	((netdev_active_feature_test(dev, NETIF_F_LLTX_BIT) == 0) ?	\
 		__netif_tx_trylock(txq) :		\
 		__netif_tx_acquire(txq))
 
 #define HARD_TX_UNLOCK(dev, txq) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if (netdev_active_feature_test(dev, NETIF_F_LLTX_BIT) == 0) {	\
 		__netif_tx_unlock(txq);			\
 	} else {					\
 		__netif_tx_release(txq);		\
@@ -4812,20 +4812,20 @@ static inline bool can_checksum_protocol(netdev_features_t features,
 					 __be16 protocol)
 {
 	if (protocol == htons(ETH_P_FCOE))
-		return !!(features & NETIF_F_FCOE_CRC);
+		return netdev_feature_test(NETIF_F_FCOE_CRC_BIT, features);
 
 	/* Assume this is an IP checksum (not SCTP CRC) */
 
-	if (features & NETIF_F_HW_CSUM) {
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features)) {
 		/* Can checksum everything */
 		return true;
 	}
 
 	switch (protocol) {
 	case htons(ETH_P_IP):
-		return !!(features & NETIF_F_IP_CSUM);
+		return netdev_feature_test(NETIF_F_IP_CSUM_BIT, features);
 	case htons(ETH_P_IPV6):
-		return !!(features & NETIF_F_IPV6_CSUM);
+		return netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features);
 	default:
 		return false;
 	}
@@ -4956,7 +4956,7 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 static inline bool skb_gso_ok(struct sk_buff *skb, netdev_features_t features)
 {
 	return net_gso_ok(features, skb_shinfo(skb)->gso_type) &&
-	       (!skb_has_frag_list(skb) || (features & NETIF_F_FRAGLIST));
+	       (!skb_has_frag_list(skb) || netdev_feature_test(NETIF_F_FRAGLIST_BIT, features));
 }
 
 static inline bool netif_needs_gso(struct sk_buff *skb,
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d9d90e6925e1..a5cce3a41415 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -654,7 +654,7 @@ struct tc_cls_u32_offload {
 
 static inline bool tc_can_offload(const struct net_device *dev)
 {
-	return dev->features & NETIF_F_HW_TC;
+	return netdev_active_feature_test(dev, NETIF_F_HW_TC_BIT);
 }
 
 static inline bool tc_can_offload_extack(const struct net_device *dev,
diff --git a/include/net/sock.h b/include/net/sock.h
index 624ed56a43bf..35404aedf51c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2257,7 +2257,7 @@ static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
 		if (!csum_and_copy_from_iter_full(to, copy, &csum, from))
 			return -EFAULT;
 		skb->csum = csum_block_add(skb->csum, csum, offset);
-	} else if (sk->sk_route_caps & NETIF_F_NOCACHE_COPY) {
+	} else if (netdev_feature_test(NETIF_F_NOCACHE_COPY_BIT, sk->sk_route_caps)) {
 		if (!copy_from_iter_full_nocache(to, copy, from))
 			return -EFAULT;
 	} else if (!copy_from_iter_full(to, copy, from))
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 72394f441dad..0b1ebe087921 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -133,7 +133,7 @@ void udp_tunnel_notify_del_rx_port(struct socket *sock, unsigned short type);
 static inline void udp_tunnel_get_rx_info(struct net_device *dev)
 {
 	ASSERT_RTNL();
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_active_feature_test(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT))
 		return;
 	call_netdevice_notifiers(NETDEV_UDP_TUNNEL_PUSH_INFO, dev);
 }
@@ -141,7 +141,7 @@ static inline void udp_tunnel_get_rx_info(struct net_device *dev)
 static inline void udp_tunnel_drop_rx_info(struct net_device *dev)
 {
 	ASSERT_RTNL();
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_active_feature_test(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT))
 		return;
 	call_netdevice_notifiers(NETDEV_UDP_TUNNEL_DROP_INFO, dev);
 }
@@ -330,7 +330,7 @@ udp_tunnel_nic_set_port_priv(struct net_device *dev, unsigned int table,
 static inline void
 udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 {
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_active_feature_test(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT))
 		return;
 	if (udp_tunnel_nic_ops)
 		udp_tunnel_nic_ops->add_port(dev, ti);
@@ -339,7 +339,7 @@ udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 static inline void
 udp_tunnel_nic_del_port(struct net_device *dev, struct udp_tunnel_info *ti)
 {
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_active_feature_test(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT))
 		return;
 	if (udp_tunnel_nic_ops)
 		udp_tunnel_nic_ops->del_port(dev, ti);
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index e40aa3e3641c..aec2e74ccfd9 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -131,7 +131,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
 {
 	const char *name = real_dev->name;
 
-	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
+	if (netdev_active_feature_test(real_dev, NETIF_F_VLAN_CHALLENGED_BIT)) {
 		pr_info("VLANs not supported on %s\n", name);
 		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
 		return -EOPNOTSUPP;
@@ -379,13 +379,13 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 	}
 
 	if ((event == NETDEV_UP) &&
-	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
+	    netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) {
 		pr_info("adding VLAN 0 to HW filter on device %s\n",
 			dev->name);
 		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
 	}
 	if (event == NETDEV_DOWN &&
-	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	    netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		vlan_vid_del(dev, htons(ETH_P_8021Q), 0);
 
 	vlan_info = rtnl_dereference(dev->vlan_info);
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 0beb44f2fe1f..0c47445367bd 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -169,10 +169,10 @@ struct vlan_vid_info {
 static bool vlan_hw_filter_capable(const struct net_device *dev, __be16 proto)
 {
 	if (proto == htons(ETH_P_8021Q) &&
-	    dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		return true;
 	if (proto == htons(ETH_P_8021AD) &&
-	    dev->features & NETIF_F_HW_VLAN_STAG_FILTER)
+	    netdev_active_feature_test(dev, NETIF_F_HW_VLAN_STAG_FILTER_BIT))
 		return true;
 	return false;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 528c7da47a44..c2bfbb30fea5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1588,7 +1588,7 @@ void dev_disable_lro(struct net_device *dev)
 	netdev_wanted_feature_del(dev, NETIF_F_LRO_BIT);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_LRO))
+	if (unlikely(netdev_active_feature_test(dev, NETIF_F_LRO_BIT)))
 		netdev_WARN(dev, "failed to disable LRO!\n");
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
@@ -1609,7 +1609,7 @@ static void dev_disable_gro_hw(struct net_device *dev)
 	netdev_wanted_feature_del(dev, NETIF_F_GRO_HW_BIT);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_GRO_HW))
+	if (unlikely(netdev_active_feature_test(dev, NETIF_F_GRO_HW_BIT)))
 		netdev_WARN(dev, "failed to disable GRO_HW!\n");
 }
 
@@ -3393,7 +3393,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * support segmentation on this frame without needing additional
 	 * work.
 	 */
-	if (features & NETIF_F_GSO_PARTIAL) {
+	if (netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
@@ -3444,7 +3444,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 #ifdef CONFIG_HIGHMEM
 	int i;
 
-	if (!(dev->features & NETIF_F_HIGHDMA)) {
+	if (!netdev_active_feature_test(dev, NETIF_F_HIGHDMA_BIT)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -3643,10 +3643,10 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features)
 {
 	if (unlikely(skb_csum_is_sctp(skb)))
-		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
+		return netdev_feature_test(NETIF_F_SCTP_CRC_BIT, features) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
 		return 0;
 
 	if (features & netdev_ip_csum_features) {
@@ -4410,7 +4410,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 		/* Should we steer this flow to a different hardware queue? */
 		if (!skb_rx_queue_recorded(skb) || !dev->rx_cpu_rmap ||
-		    !(dev->features & NETIF_F_NTUPLE))
+		    !netdev_active_feature_test(dev, NETIF_F_NTUPLE_BIT))
 			goto out;
 		rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap, next_cpu);
 		if (rxq_index == skb_get_rx_queue(skb))
@@ -9613,89 +9613,97 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	netdev_features_t tmp;
 
 	/* Fix illegal checksum combinations */
-	if ((features & NETIF_F_HW_CSUM) &&
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
 	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
 		netdev_features_clear(features, netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
+	if ((features & NETIF_F_ALL_TSO) &&
+	    !netdev_feature_test(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
 		netdev_features_clear(features, NETIF_F_ALL_TSO);
 	}
 
-	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
-					!(features & NETIF_F_IP_CSUM)) {
+	if (netdev_feature_test(NETIF_F_TSO_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_IP_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
 		netdev_feature_del(NETIF_F_TSO_BIT, features);
 		netdev_feature_del(NETIF_F_TSO_ECN_BIT, features);
 	}
 
-	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
-					 !(features & NETIF_F_IPV6_CSUM)) {
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
 		netdev_feature_del(NETIF_F_TSO6_BIT, features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
+	if (netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_TSO_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT, features);
 
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
 	netdev_feature_del(NETIF_F_TSO_ECN_BIT, tmp);
-	if (!(features & tmp) && (features & NETIF_F_TSO_ECN))
+	if (!(features & tmp) &&
+	    netdev_feature_test(NETIF_F_TSO_ECN_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_ECN_BIT, features);
 
 	/* Software GSO depends on SG. */
-	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
+	if (netdev_feature_test(NETIF_F_GSO_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
 		netdev_feature_del(NETIF_F_GSO_BIT, features);
 	}
 
 	/* GSO partial features require GSO partial be set */
 	if ((features & dev->gso_partial_features) &&
-	    !(features & NETIF_F_GSO_PARTIAL)) {
+	    !netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
 		netdev_features_clear(features, dev->gso_partial_features);
 	}
 
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (features & NETIF_F_RXFCS) {
-		if (features & NETIF_F_LRO) {
+	if (netdev_feature_test(NETIF_F_RXFCS_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
 			netdev_feature_del(NETIF_F_LRO_BIT, features);
 		}
 
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
-	if ((features & NETIF_F_GRO_HW) && (features & NETIF_F_LRO)) {
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features) &&
+	    netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
 		netdev_feature_del(NETIF_F_LRO_BIT, features);
 	}
 
-	if (features & NETIF_F_HW_TLS_TX) {
+	if (netdev_feature_test(NETIF_F_HW_TLS_TX_BIT, features)) {
 		bool ip_csum = (features & netdev_ip_csum_features) ==
 			netdev_ip_csum_features;
-		bool hw_csum = features & NETIF_F_HW_CSUM;
+		bool hw_csum = netdev_feature_test(NETIF_F_HW_CSUM_BIT,
+						   features);
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
@@ -9703,7 +9711,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		}
 	}
 
-	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
+	if (netdev_feature_test(NETIF_F_HW_TLS_RX_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
 		netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, features);
 	}
@@ -9764,7 +9773,7 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_features_t diff;
 
 		netdev_features_xor(diff, dev->features, features);
-		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
+		if (netdev_feature_test(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, diff)) {
 			/* udp_tunnel_{get,drop}_rx_info both need
 			 * NETIF_F_RX_UDP_TUNNEL_PORT enabled on the
 			 * device, or they won't do anything.
@@ -9772,7 +9781,7 @@ int __netdev_update_features(struct net_device *dev)
 			 * *before* calling udp_tunnel_get_rx_info,
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
-			if (features & NETIF_F_RX_UDP_TUNNEL_PORT) {
+			if (netdev_feature_test(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, features)) {
 				dev->features = features;
 				udp_tunnel_get_rx_info(dev);
 			} else {
@@ -9780,8 +9789,8 @@ int __netdev_update_features(struct net_device *dev)
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
+			if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
 				dev->features = features;
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
@@ -9789,8 +9798,8 @@ int __netdev_update_features(struct net_device *dev)
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_STAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_STAG_FILTER) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
+			if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT, features)) {
 				dev->features = features;
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
@@ -10016,8 +10025,8 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if ((dev->hw_features & NETIF_F_HW_VLAN_CTAG_FILTER ||
-	     dev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((netdev_hw_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT) ||
+	     netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
 		netdev_WARN(dev, "Buggy VLAN acceleration in driver!\n");
@@ -10053,13 +10062,13 @@ int register_netdevice(struct net_device *dev)
 	 * of ignoring a static IP ID value.  This doesn't enable the
 	 * feature itself but allows the user to enable it later.
 	 */
-	if (dev->hw_features & NETIF_F_TSO)
+	if (netdev_hw_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_hw_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
-	if (dev->vlan_features & NETIF_F_TSO)
+	if (netdev_vlan_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_vlan_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
-	if (dev->mpls_features & NETIF_F_TSO)
+	if (netdev_mpls_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_mpls_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
-	if (dev->hw_enc_features & NETIF_F_TSO)
+	if (netdev_hw_enc_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_hw_enc_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
@@ -10960,7 +10969,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* Don't allow namespace local devices to be moved. */
 	err = -EINVAL;
-	if (dev->features & NETIF_F_NETNS_LOCAL)
+	if (netdev_active_feature_test(dev, NETIF_F_NETNS_LOCAL_BIT))
 		goto out;
 
 	/* Ensure the device has been registrered */
@@ -11158,7 +11167,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 {
 	netdev_features_t tmp;
 
-	if (mask & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, mask))
 		netdev_features_set(mask, NETIF_F_CSUM_MASK);
 	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, mask);
 
@@ -11173,7 +11182,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
-	if (all & NETIF_F_HW_CSUM) {
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, all)) {
 		tmp = NETIF_F_CSUM_MASK;
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, tmp);
 		netdev_features_clear(all, tmp);
@@ -11331,7 +11340,7 @@ static void __net_exit default_device_exit_net(struct net *net)
 		char fb_name[IFNAMSIZ];
 
 		/* Ignore unmoveable devices (i.e. loopback) */
-		if (dev->features & NETIF_F_NETNS_LOCAL)
+		if (netdev_active_feature_test(dev, NETIF_F_NETNS_LOCAL_BIT))
 			continue;
 
 		/* Leave virtual devices for the generic cleanup */
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 198d94f2e8f0..aa3058dae0ae 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2963,8 +2963,8 @@ static struct sk_buff *fill_packet_ipv4(struct net_device *odev,
 
 	if (!(pkt_dev->flags & F_UDPCSUM)) {
 		skb->ip_summed = CHECKSUM_NONE;
-	} else if (odev->features & NETIF_F_HW_CSUM ||
-		   odev->features & NETIF_F_IP_CSUM) {
+	} else if (netdev_active_feature_test(odev, NETIF_F_HW_CSUM_BIT) ||
+		   netdev_active_feature_test(odev, NETIF_F_IP_CSUM_BIT)) {
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum = 0;
 		udp4_hwcsum(skb, iph->saddr, iph->daddr);
@@ -3099,8 +3099,8 @@ static struct sk_buff *fill_packet_ipv6(struct net_device *odev,
 
 	if (!(pkt_dev->flags & F_UDPCSUM)) {
 		skb->ip_summed = CHECKSUM_NONE;
-	} else if (odev->features & NETIF_F_HW_CSUM ||
-		   odev->features & NETIF_F_IPV6_CSUM) {
+	} else if (netdev_active_feature_test(odev, NETIF_F_HW_CSUM_BIT) ||
+		   netdev_active_feature_test(odev, NETIF_F_IPV6_CSUM_BIT)) {
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum_start = skb_transport_header(skb) - skb->head;
 		skb->csum_offset = offsetof(struct udphdr, check);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d1df34d68943..0e40de13de3f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4057,11 +4057,11 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	if (unlikely(!proto))
 		return ERR_PTR(-EINVAL);
 
-	sg = !!(features & NETIF_F_SG);
+	sg = netdev_feature_test(NETIF_F_SG_BIT, features);
 	csum = !!can_checksum_protocol(features, proto);
 
 	if (sg && csum && (mss != GSO_BY_FRAGS))  {
-		if (!(features & NETIF_F_GSO_PARTIAL)) {
+		if (!netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
 			struct sk_buff *iter;
 			unsigned int frag_len;
 
@@ -4317,7 +4317,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		unsigned short gso_size = skb_shinfo(head_skb)->gso_size;
 
 		/* Update type to add partial and then remove dodgy if set */
-		type |= (features & NETIF_F_GSO_PARTIAL) ? 0 : SKB_GSO_PARTIAL;
+		type |= netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features) ?
+				0 : SKB_GSO_PARTIAL;
 		type &= ~SKB_GSO_DODGY;
 
 		/* Update GSO info and prepare to start updating headers on
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 188f8558d27d..f08ad75d72ac 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -387,7 +387,7 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 		copy = (buf_size > bytes) ? bytes : buf_size;
 		to = sg_virt(sge) + msg->sg.copybreak;
 		msg->sg.copybreak += copy;
-		if (sk->sk_route_caps & NETIF_F_NOCACHE_COPY)
+		if (netdev_feature_test(NETIF_F_NOCACHE_COPY_BIT, sk->sk_route_caps))
 			ret = copy_from_iter_nocache(to, copy, from);
 		else
 			ret = copy_from_iter(to, copy, from);
diff --git a/net/core/sock.c b/net/core/sock.c
index 5b89b03660b9..89f99b42b179 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2373,7 +2373,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	sk->sk_route_caps = dst->dev->features;
 	if (sk_is_tcp(sk))
 		netdev_feature_add(NETIF_F_GSO_BIT, sk->sk_route_caps);
-	if (sk->sk_route_caps & NETIF_F_GSO)
+	if (netdev_feature_test(NETIF_F_GSO_BIT, sk->sk_route_caps))
 		netdev_features_set(sk->sk_route_caps, NETIF_F_GSO_SOFTWARE);
 	if (unlikely(sk->sk_gso_disabled))
 		netdev_features_clear(sk->sk_route_caps, NETIF_F_GSO_MASK);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 595b8dae7fa3..88d5b1ba6e42 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -313,15 +313,15 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 {
 	u32 flags = 0;
 
-	if (dev->features & NETIF_F_LRO)
+	if (netdev_active_feature_test(dev, NETIF_F_LRO_BIT))
 		flags |= ETH_FLAG_LRO;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		flags |= ETH_FLAG_RXVLAN;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		flags |= ETH_FLAG_TXVLAN;
-	if (dev->features & NETIF_F_NTUPLE)
+	if (netdev_active_feature_test(dev, NETIF_F_NTUPLE_BIT))
 		flags |= ETH_FLAG_NTUPLE;
-	if (dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(dev, NETIF_F_RXHASH_BIT))
 		flags |= ETH_FLAG_RXHASH;
 
 	return flags;
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 5bf357734b11..735ab1f6cb3e 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -291,7 +291,7 @@ struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
 		/* set the lane id properly */
 		hsr_set_path_id(hsr_ethhdr, port);
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
-	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+	} else if (netdev_active_feature_test(port->dev, NETIF_F_HW_HSR_TAG_INS_BIT)) {
 		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
@@ -335,7 +335,7 @@ struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
 			return NULL;
 		}
 		return skb_clone(frame->skb_prp, GFP_ATOMIC);
-	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+	} else if (netdev_active_feature_test(port->dev, NETIF_F_HW_HSR_TAG_INS_BIT)) {
 		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
@@ -391,7 +391,7 @@ bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
 
 bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
 {
-	if (port->dev->features & NETIF_F_HW_HSR_FWD)
+	if (netdev_active_feature_test(port->dev, NETIF_F_HW_HSR_FWD_BIT))
 		return prp_drop_frame(frame, port);
 
 	return false;
@@ -432,7 +432,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		/* If hardware duplicate generation is enabled, only send out
 		 * one port.
 		 */
-		if ((port->dev->features & NETIF_F_HW_HSR_DUP) && sent)
+		if (netdev_active_feature_test(port->dev, NETIF_F_HW_HSR_DUP_BIT) && sent)
 			continue;
 
 		/* Don't send frame over port where it has been sent before.
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 584e21788799..0a1f7f9ebb9e 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -465,7 +465,7 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 	 * ensures entries of restarted nodes gets pruned so that they can
 	 * re-register and resume communications.
 	 */
-	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	if (!netdev_active_feature_test(port->dev, NETIF_F_HW_HSR_TAG_RM_BIT) &&
 	    seq_nr_before(sequence_nr, node->seq_out[port->type]))
 		return;
 
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index b70e6bbf6021..e8b588a0b1aa 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -54,7 +54,7 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 	 */
 	protocol = eth_hdr(skb)->h_proto;
 
-	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	if (!netdev_active_feature_test(port->dev, NETIF_F_HW_HSR_TAG_RM_BIT) &&
 	    hsr->proto_ops->invalid_dan_ingress_frame &&
 	    hsr->proto_ops->invalid_dan_ingress_frame(protocol))
 		goto finish_pass;
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 5aeebbc1d349..b3d5cc34e3ec 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -217,14 +217,14 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
-	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev) {
+	if ((!netdev_gso_partial_feature_test(skb->dev, NETIF_F_HW_ESP_BIT) &&
+	     !netdev_feature_test(NETIF_F_HW_ESP_BIT, features)) || x->xso.dev != skb->dev) {
 		netdev_features_andnot(esp_features, features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
-	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
-		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM)) {
+	} else if (!netdev_feature_test(NETIF_F_HW_ESP_TX_CSUM_BIT, features) &&
+		   !netdev_gso_partial_feature_test(skb->dev, NETIF_F_HW_ESP_TX_CSUM_BIT)) {
 		netdev_features_andnot(esp_features, features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
@@ -268,8 +268,8 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	if (!xo)
 		return -EINVAL;
 
-	if ((!(features & NETIF_F_HW_ESP) &&
-	     !(skb->dev->gso_partial_features & NETIF_F_HW_ESP)) ||
+	if ((!netdev_feature_test(NETIF_F_HW_ESP_BIT, features) &&
+	     !netdev_gso_partial_feature_test(skb->dev, NETIF_F_HW_ESP_BIT)) ||
 	    x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
 		hw_offload = false;
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index c9a90bed4ce4..cea677526304 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -51,7 +51,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	need_ipsec = skb_dst(skb) && dst_xfrm(skb_dst(skb));
 	/* Try to offload checksum if possible */
 	offload_csum = !!(need_csum && !need_ipsec &&
-			  (skb->dev->features & NETIF_F_HW_CSUM));
+			  netdev_active_feature_test(skb->dev, NETIF_F_HW_CSUM_BIT));
 
 	/* segment inner packet. */
 	segs = skb_mac_gso_segment(skb, features);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8353875a9506..e128d2957d3f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1013,10 +1013,11 @@ static int __ip_append_data(struct sock *sk,
 	 */
 	if (transhdrlen &&
 	    length + fragheaderlen <= mtu &&
-	    (rt->dst.dev->features & NETIF_F_HW_CSUM ||
-	     rt->dst.dev->features & NETIF_F_IP_CSUM) &&
+	    (netdev_active_feature_test(rt->dst.dev, NETIF_F_HW_CSUM_BIT) ||
+	     netdev_active_feature_test(rt->dst.dev, NETIF_F_IP_CSUM_BIT)) &&
 	    (!(flags & MSG_MORE) || cork->gso_size) &&
-	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
+	    (!exthdrlen || netdev_active_feature_test(rt->dst.dev,
+						      NETIF_F_HW_ESP_TX_CSUM_BIT)))
 		csummode = CHECKSUM_PARTIAL;
 
 	if ((flags & MSG_ZEROCOPY) && length) {
@@ -1029,7 +1030,7 @@ static int __ip_append_data(struct sock *sk,
 			/* Leave uarg NULL if can't zerocopy, callers should
 			 * be able to handle it.
 			 */
-			if ((rt->dst.dev->features & NETIF_F_SG) &&
+			if (netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT) &&
 			    csummode == CHECKSUM_PARTIAL) {
 				paged = true;
 				zc = true;
@@ -1040,7 +1041,7 @@ static int __ip_append_data(struct sock *sk,
 			if (!uarg)
 				return -ENOBUFS;
 			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-			if (rt->dst.dev->features & NETIF_F_SG &&
+			if (netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT) &&
 			    csummode == CHECKSUM_PARTIAL) {
 				paged = true;
 				zc = true;
@@ -1105,11 +1106,12 @@ static int __ip_append_data(struct sock *sk,
 				alloc_extra += rt->dst.trailer_len;
 
 			if ((flags & MSG_MORE) &&
-			    !(rt->dst.dev->features&NETIF_F_SG))
+			    !netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT))
 				alloclen = mtu;
 			else if (!paged &&
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
-				  !(rt->dst.dev->features & NETIF_F_SG)))
+				  !netdev_active_feature_test(rt->dst.dev,
+							      NETIF_F_SG_BIT)))
 				alloclen = fraglen;
 			else {
 				alloclen = fragheaderlen + transhdrlen;
@@ -1197,7 +1199,7 @@ static int __ip_append_data(struct sock *sk,
 		if (copy > length)
 			copy = length;
 
-		if (!(rt->dst.dev->features&NETIF_F_SG) &&
+		if (!netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT) &&
 		    skb_tailroom(skb) >= copy) {
 			unsigned int off;
 
@@ -1375,7 +1377,7 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 	if (cork->flags & IPCORK_OPT)
 		opt = cork->opt;
 
-	if (!(rt->dst.dev->features & NETIF_F_SG))
+	if (!netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT))
 		return -EOPNOTSUPP;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 467a9c6aefb1..8a8dbe2f7ddc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1132,7 +1132,7 @@ EXPORT_SYMBOL_GPL(do_tcp_sendpages);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags)
 {
-	if (!(sk->sk_route_caps & NETIF_F_SG))
+	if (!netdev_feature_test(NETIF_F_SG_BIT, sk->sk_route_caps))
 		return sock_no_sendpage_locked(sk, page, offset, size, flags);
 
 	tcp_rate_check_app_limited(sk);  /* is sending application-limited? */
@@ -1230,14 +1230,16 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
 			net_zcopy_get(uarg);
-			zc = sk->sk_route_caps & NETIF_F_SG;
+			zc = netdev_feature_test(NETIF_F_SG_BIT,
+						 sk->sk_route_caps);
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
 			if (!uarg) {
 				err = -ENOBUFS;
 				goto out_err;
 			}
-			zc = sk->sk_route_caps & NETIF_F_SG;
+			zc = netdev_feature_test(NETIF_F_SG_BIT,
+						 sk->sk_route_caps);
 			if (!zc)
 				uarg->zerocopy = 0;
 		}
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 908670adfdfc..0cbe51ad0803 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -64,9 +64,9 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	/* Try to offload checksum if possible */
 	offload_csum = !!(need_csum &&
 			  !need_ipsec &&
-			  (skb->dev->features & NETIF_F_HW_CSUM ||
-			   (is_ipv6 ? (skb->dev->features & NETIF_F_IPV6_CSUM) :
-				      (skb->dev->features & NETIF_F_IP_CSUM))));
+			  (netdev_active_feature_test(skb->dev, NETIF_F_HW_CSUM_BIT) ||
+			   (is_ipv6 ? netdev_active_feature_test(skb->dev, NETIF_F_IPV6_CSUM_BIT) :
+				      netdev_active_feature_test(skb->dev, NETIF_F_IP_CSUM_BIT))));
 
 	features &= skb->dev->hw_enc_features;
 	if (need_csum)
@@ -548,10 +548,10 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	 */
 	NAPI_GRO_CB(skb)->is_flist = 0;
 	if (!sk || !udp_sk(sk)->gro_receive) {
-		if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
+		if (netdev_active_feature_test(skb->dev, NETIF_F_GRO_FRAGLIST_BIT))
 			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled : 1;
 
-		if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
+		if ((!sk && netdev_active_feature_test(skb->dev, NETIF_F_GRO_UDP_FWD_BIT)) ||
 		    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
 			return call_gro_receive(udp_gro_receive_segment, head, skb);
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 19f685f6b378..5d8642b40a66 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -256,12 +256,12 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
+	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, features) || x->xso.dev != skb->dev) {
 		netdev_features_andnot(esp_features, features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
-	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM)) {
+	} else if (!netdev_feature_test(NETIF_F_HW_ESP_TX_CSUM_BIT, features)) {
 		netdev_features_andnot(esp_features, features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
@@ -305,7 +305,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	if (!xo)
 		return -EINVAL;
 
-	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
+	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, features) || x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
 		hw_offload = false;
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 28239182d820..40ca76257ec1 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1539,8 +1539,8 @@ static int __ip6_append_data(struct sock *sk,
 	    headersize == sizeof(struct ipv6hdr) &&
 	    length <= mtu - headersize &&
 	    (!(flags & MSG_MORE) || cork->gso_size) &&
-	    (rt->dst.dev->features & NETIF_F_IPV6_CSUM ||
-	     rt->dst.dev->features & NETIF_F_HW_CSUM))
+	    (netdev_active_feature_test(rt->dst.dev, NETIF_F_IPV6_CSUM_BIT) ||
+	     netdev_active_feature_test(rt->dst.dev, NETIF_F_HW_CSUM_BIT)))
 		csummode = CHECKSUM_PARTIAL;
 
 	if ((flags & MSG_ZEROCOPY) && length) {
@@ -1553,7 +1553,7 @@ static int __ip6_append_data(struct sock *sk,
 			/* Leave uarg NULL if can't zerocopy, callers should
 			 * be able to handle it.
 			 */
-			if ((rt->dst.dev->features & NETIF_F_SG) &&
+			if (netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT) &&
 			    csummode == CHECKSUM_PARTIAL) {
 				paged = true;
 				zc = true;
@@ -1564,7 +1564,7 @@ static int __ip6_append_data(struct sock *sk,
 			if (!uarg)
 				return -ENOBUFS;
 			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-			if (rt->dst.dev->features & NETIF_F_SG &&
+			if (netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT) &&
 			    csummode == CHECKSUM_PARTIAL) {
 				paged = true;
 				zc = true;
@@ -1644,11 +1644,13 @@ static int __ip6_append_data(struct sock *sk,
 			alloc_extra += sizeof(struct frag_hdr);
 
 			if ((flags & MSG_MORE) &&
-			    !(rt->dst.dev->features&NETIF_F_SG))
+			    !netdev_active_feature_test(rt->dst.dev,
+							NETIF_F_SG_BIT))
 				alloclen = mtu;
 			else if (!paged &&
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
-				  !(rt->dst.dev->features & NETIF_F_SG)))
+				  !netdev_active_feature_test(rt->dst.dev,
+							      NETIF_F_SG_BIT)))
 				alloclen = fraglen;
 			else {
 				alloclen = fragheaderlen + transhdrlen;
@@ -1751,7 +1753,7 @@ static int __ip6_append_data(struct sock *sk,
 		if (copy > length)
 			copy = length;
 
-		if (!(rt->dst.dev->features&NETIF_F_SG) &&
+		if (!netdev_active_feature_test(rt->dst.dev, NETIF_F_SG_BIT) &&
 		    skb_tailroom(skb) >= copy) {
 			unsigned int off;
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index a0921adc31a9..e8e10d13df1b 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -172,7 +172,8 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	/* Only update csum if we really have to */
 	if (sctph->dest != cp->dport || payload_csum ||
 	    (skb->ip_summed == CHECKSUM_PARTIAL &&
-	     !(skb_dst(skb)->dev->features & NETIF_F_SCTP_CRC))) {
+	     !netdev_active_feature_test(skb_dst(skb)->dev,
+					 NETIF_F_SCTP_CRC_BIT))) {
 		sctph->dest = cp->dport;
 		sctp_nat_csum(skb, sctph, sctphoff);
 	} else if (skb->ip_summed != CHECKSUM_PARTIAL) {
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index fc6aff0922dc..cc38680a2982 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -107,7 +107,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb->protocol = proto;
 
 	netdev_features_zero(feats);
-	if (features & NETIF_F_SG)
+	if (netdev_feature_test(NETIF_F_SG_BIT, features))
 		netdev_feature_add(NETIF_F_SG_BIT, feats);
 	segs = skb_mac_gso_segment(skb, feats);
 	if (IS_ERR_OR_NULL(segs)) {
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index f4a528febbdc..c3d81154771e 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -78,7 +78,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 		goto out;
 
 	/* All that is left is update SCTP CRC if necessary */
-	if (!(features & NETIF_F_SCTP_CRC)) {
+	if (!netdev_feature_test(NETIF_F_SCTP_CRC_BIT, features)) {
 		for (skb = segs; skb; skb = skb->next) {
 			if (skb->ip_summed == CHECKSUM_PARTIAL) {
 				sh = sctp_hdr(skb);
diff --git a/net/sctp/output.c b/net/sctp/output.c
index a63df055ac57..9b3e83b8e544 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -544,7 +544,7 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 	if (sctp_checksum_disable)
 		return 1;
 
-	if (!(tp->dst->dev->features & NETIF_F_SCTP_CRC) ||
+	if (!netdev_active_feature_test(tp->dst->dev, NETIF_F_SCTP_CRC_BIT) ||
 	    dst_xfrm(tp->dst) || packet->ipfragok || tp->encap_port) {
 		struct sctphdr *sh =
 			(struct sctphdr *)skb_transport_header(head);
diff --git a/net/sunrpc/sunrpc.h b/net/sunrpc/sunrpc.h
index d4a362c9e4b3..1fda340afe9b 100644
--- a/net/sunrpc/sunrpc.h
+++ b/net/sunrpc/sunrpc.h
@@ -30,7 +30,7 @@ static inline int sock_is_loopback(struct sock *sk)
 	rcu_read_lock();
 	dst = rcu_dereference(sk->sk_dst_cache);
 	if (dst && dst->dev &&
-	    (dst->dev->features & NETIF_F_LOOPBACK))
+	    netdev_active_feature_test(dst->dev, NETIF_F_LOOPBACK_BIT))
 		loopback = 1;
 	rcu_read_unlock();
 	return loopback;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index dbaf2ddcf656..1d1782e83ccb 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1086,7 +1086,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		return -EINVAL;
 	}
 
-	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
+	if (!netdev_active_feature_test(netdev, NETIF_F_HW_TLS_TX_BIT)) {
 		rc = -EOPNOTSUPP;
 		goto release_netdev;
 	}
@@ -1255,7 +1255,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 		return -EINVAL;
 	}
 
-	if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
+	if (!netdev_active_feature_test(netdev, NETIF_F_HW_TLS_RX_BIT)) {
 		rc = -EOPNOTSUPP;
 		goto release_netdev;
 	}
@@ -1437,7 +1437,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 	case NETDEV_FEAT_CHANGE:
 		if (netif_is_bond_master(dev))
 			return NOTIFY_DONE;
-		if ((dev->features & NETIF_F_HW_TLS_RX) &&
+		if (netdev_active_feature_test(dev, NETIF_F_HW_TLS_RX_BIT) &&
 		    !dev->tlsdev_ops->tls_dev_resync)
 			return NOTIFY_BAD;
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 78ebbccbd616..0ec7a813fab3 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -112,7 +112,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (!xo || (xo->flags & XFRM_XMIT))
 		return skb;
 
-	if (!(features & NETIF_F_HW_ESP)) {
+	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, features)) {
 		esp_features = features;
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_features_clear(esp_features, NETIF_F_CSUM_MASK);
@@ -374,18 +374,18 @@ void xfrm_dev_backlog(struct softnet_data *sd)
 static int xfrm_api_check(struct net_device *dev)
 {
 #ifdef CONFIG_XFRM_OFFLOAD
-	if ((dev->features & NETIF_F_HW_ESP_TX_CSUM) &&
-	    !(dev->features & NETIF_F_HW_ESP))
+	if (netdev_active_feature_test(dev, NETIF_F_HW_ESP_TX_CSUM_BIT) &&
+	    !netdev_active_feature_test(dev, NETIF_F_HW_ESP_BIT))
 		return NOTIFY_BAD;
 
-	if ((dev->features & NETIF_F_HW_ESP) &&
+	if (netdev_active_feature_test(dev, NETIF_F_HW_ESP_BIT) &&
 	    (!(dev->xfrmdev_ops &&
 	       dev->xfrmdev_ops->xdo_dev_state_add &&
 	       dev->xfrmdev_ops->xdo_dev_state_delete)))
 		return NOTIFY_BAD;
 #else
-	if (dev->features & NETIF_F_HW_ESP ||
-	    dev->features & NETIF_F_HW_ESP_TX_CSUM)
+	if (netdev_active_feature_test(dev, NETIF_F_HW_ESP_BIT) ||
+	    netdev_active_feature_test(dev, NETIF_F_HW_ESP_TX_CSUM_BIT))
 		return NOTIFY_BAD;
 #endif
 
@@ -394,7 +394,7 @@ static int xfrm_api_check(struct net_device *dev)
 
 static int xfrm_dev_down(struct net_device *dev)
 {
-	if (dev->features & NETIF_F_HW_ESP)
+	if (netdev_active_feature_test(dev, NETIF_F_HW_ESP_BIT))
 		xfrm_dev_state_flush(dev_net(dev), dev, true);
 
 	return NOTIFY_DONE;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e986c4b64902..9ade97734543 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -748,7 +748,9 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 			goto out;
 		}
 
-		if (x->xso.dev && x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)
+		if (x->xso.dev &&
+		    netdev_active_feature_test(x->xso.dev,
+					       NETIF_F_HW_ESP_TX_CSUM_BIT))
 			goto out;
 	} else {
 		if (skb_is_gso(skb))
-- 
2.33.0

