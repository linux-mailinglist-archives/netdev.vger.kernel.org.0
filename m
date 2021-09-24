Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686D34176DE
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 16:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346802AbhIXOgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 10:36:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9787 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346779AbhIXOfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 10:35:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HGDyz707GzWRTd;
        Fri, 24 Sep 2021 22:32:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:11 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>,
        <linux-s390@vger.kernel.org>
Subject: [PATCH V2 net-next 4/6] ethtool: extend ringparam setting uAPI with rx_buf_len
Date:   Fri, 24 Sep 2021 22:29:57 +0800
Message-ID: <20210924142959.7798-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924142959.7798-1-huangguangbin2@huawei.com>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add two new parameters ringparam_ext and extack for
.get_ringparam and .set_ringparam to extend more ring params
through netlink.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 arch/um/drivers/vector_kern.c                    |  4 +++-
 drivers/net/can/c_can/c_can_ethtool.c            |  4 +++-
 drivers/net/ethernet/3com/typhoon.c              |  4 +++-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    |  8 ++++++--
 drivers/net/ethernet/amd/pcnet32.c               |  8 ++++++--
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c     |  8 ++++++--
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c  |  8 ++++++--
 drivers/net/ethernet/atheros/atlx/atl1.c         |  8 ++++++--
 drivers/net/ethernet/broadcom/b44.c              |  8 ++++++--
 drivers/net/ethernet/broadcom/bcm63xx_enet.c     | 16 ++++++++++++----
 drivers/net/ethernet/broadcom/bnx2.c             |  8 ++++++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c  |  8 ++++++--
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c    |  8 ++++++--
 drivers/net/ethernet/broadcom/tg3.c              | 10 ++++++++--
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c  |  8 ++++++--
 drivers/net/ethernet/cadence/macb_main.c         |  8 ++++++--
 .../net/ethernet/cavium/liquidio/lio_ethtool.c   |  8 ++++++--
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c  |  8 ++++++--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c        |  8 ++++++--
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c  |  8 ++++++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c   |  8 ++++++--
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c  |  8 ++++++--
 drivers/net/ethernet/cisco/enic/enic_ethtool.c   |  8 ++++++--
 drivers/net/ethernet/cortina/gemini.c            |  8 ++++++--
 drivers/net/ethernet/emulex/benet/be_ethtool.c   |  4 +++-
 drivers/net/ethernet/ethoc.c                     |  8 ++++++--
 drivers/net/ethernet/faraday/ftgmac100.c         |  8 ++++++--
 .../net/ethernet/freescale/enetc/enetc_ethtool.c |  4 +++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c |  8 ++++++--
 .../net/ethernet/freescale/ucc_geth_ethtool.c    |  8 ++++++--
 drivers/net/ethernet/google/gve/gve_ethtool.c    |  4 +++-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |  6 +++++-
 .../net/ethernet/hisilicon/hns3/hns3_ethtool.c   |  8 ++++++--
 .../net/ethernet/huawei/hinic/hinic_ethtool.c    |  8 ++++++--
 drivers/net/ethernet/ibm/emac/core.c             |  4 +++-
 drivers/net/ethernet/ibm/ibmvnic.c               |  8 ++++++--
 drivers/net/ethernet/intel/e100.c                |  8 ++++++--
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |  8 ++++++--
 drivers/net/ethernet/intel/e1000e/ethtool.c      |  8 ++++++--
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c |  8 ++++++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c   |  8 ++++++--
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c   | 12 ++++++++++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c     |  8 ++++++--
 drivers/net/ethernet/intel/igb/igb_ethtool.c     |  8 ++++++--
 drivers/net/ethernet/intel/igbvf/ethtool.c       |  8 ++++++--
 drivers/net/ethernet/intel/igc/igc_ethtool.c     |  8 ++++++--
 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c   |  8 ++++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |  8 ++++++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c     |  8 ++++++--
 drivers/net/ethernet/marvell/mv643xx_eth.c       |  8 ++++++--
 drivers/net/ethernet/marvell/mvneta.c            |  8 ++++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |  8 ++++++--
 .../marvell/octeontx2/nic/otx2_ethtool.c         |  8 ++++++--
 drivers/net/ethernet/marvell/skge.c              |  8 ++++++--
 drivers/net/ethernet/marvell/sky2.c              |  8 ++++++--
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c  |  8 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c |  8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  8 ++++++--
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c  |  8 ++++++--
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c     |  4 +++-
 drivers/net/ethernet/micrel/ksz884x.c            |  5 ++++-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |  4 +++-
 drivers/net/ethernet/neterion/s2io.c             |  4 +++-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c |  8 ++++++--
 drivers/net/ethernet/nvidia/forcedeth.c          | 10 ++++++++--
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c  | 10 ++++++++--
 drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c |  4 +++-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c  |  8 ++++++--
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c  |  8 ++++++--
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c  |  8 ++++++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c  |  8 ++++++--
 .../net/ethernet/qualcomm/emac/emac-ethtool.c    |  8 ++++++--
 drivers/net/ethernet/qualcomm/qca_debug.c        |  8 ++++++--
 drivers/net/ethernet/realtek/8139cp.c            |  4 +++-
 drivers/net/ethernet/realtek/r8169_main.c        |  4 +++-
 drivers/net/ethernet/renesas/ravb_main.c         |  8 ++++++--
 drivers/net/ethernet/renesas/sh_eth.c            |  8 ++++++--
 drivers/net/ethernet/sfc/ef100_ethtool.c         |  4 +++-
 drivers/net/ethernet/sfc/ethtool.c               |  8 ++++++--
 drivers/net/ethernet/sfc/falcon/ethtool.c        |  8 ++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  8 ++++++--
 drivers/net/ethernet/tehuti/tehuti.c             | 10 ++++++++--
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c      |  4 +++-
 drivers/net/ethernet/ti/cpmac.c                  |  8 ++++++--
 drivers/net/ethernet/ti/cpsw_ethtool.c           |  8 ++++++--
 drivers/net/ethernet/ti/cpsw_priv.h              |  8 ++++++--
 .../net/ethernet/toshiba/spider_net_ethtool.c    |  4 +++-
 drivers/net/ethernet/xilinx/ll_temac_main.c      | 14 ++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_main.c    | 14 ++++++++++----
 drivers/net/hyperv/netvsc_drv.c                  |  8 ++++++--
 drivers/net/netdevsim/ethtool.c                  |  8 ++++++--
 drivers/net/usb/r8152.c                          |  8 ++++++--
 drivers/net/virtio_net.c                         |  4 +++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c            |  8 ++++++--
 drivers/s390/net/qeth_ethtool.c                  |  4 +++-
 net/ethtool/ioctl.c                              |  9 ++++++---
 net/ethtool/rings.c                              | 15 +++++++++++----
 net/mac80211/ethtool.c                           |  8 ++++++--
 98 files changed, 562 insertions(+), 185 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index cde6db184c26..22b59e262c1c 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1441,7 +1441,9 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
 }
 
 static void vector_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct vector_private *vp = netdev_priv(netdev);
 
diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
index 377c7d2e7612..1d7eddfd09ec 100644
--- a/drivers/net/can/c_can/c_can_ethtool.c
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -20,7 +20,9 @@ static void c_can_get_drvinfo(struct net_device *netdev,
 }
 
 static void c_can_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct c_can_priv *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 05e15b6e5e2c..dae332ab6626 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -1138,7 +1138,9 @@ typhoon_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 }
 
 static void
-typhoon_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+typhoon_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering,
+		      struct ethtool_ringparam_ext *ering_ext,
+		      struct netlink_ext_ack *extack)
 {
 	ering->rx_max_pending = RXENT_ENTRIES;
 	ering->tx_max_pending = TXLO_ENTRIES - 1;
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 13e745cf3781..ea1af149d02f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -465,7 +465,9 @@ static void ena_get_drvinfo(struct net_device *dev,
 }
 
 static void ena_get_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
@@ -476,7 +478,9 @@ static void ena_get_ringparam(struct net_device *netdev,
 }
 
 static int ena_set_ringparam(struct net_device *netdev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct ethtool_ringparam_ext *ring_ext,
+			     struct netlink_ext_ack *extack)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	u32 new_tx_size, new_rx_size;
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 70d76fdb9f56..e5708b312133 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -860,7 +860,9 @@ static int pcnet32_nway_reset(struct net_device *dev)
 }
 
 static void pcnet32_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *ering)
+				  struct ethtool_ringparam *ering,
+				  struct ethtool_ringparam_ext *ering_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
 
@@ -871,7 +873,9 @@ static void pcnet32_get_ringparam(struct net_device *dev,
 }
 
 static int pcnet32_set_ringparam(struct net_device *dev,
-				 struct ethtool_ringparam *ering)
+				 struct ethtool_ringparam *ering,
+				 struct ethtool_ringparam_ext *ering_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
 	unsigned long flags;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index bafc51c34e0b..08a52594cda0 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -622,7 +622,9 @@ static int xgbe_get_module_eeprom(struct net_device *netdev,
 }
 
 static void xgbe_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ringparam)
+			       struct ethtool_ringparam *ringparam,
+			       struct ethtool_ringparam_ext *ringparam_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 
@@ -633,7 +635,9 @@ static void xgbe_get_ringparam(struct net_device *netdev,
 }
 
 static int xgbe_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ringparam)
+			      struct ethtool_ringparam *ringparam,
+			      struct ethtool_ringparam_ext *ringparam_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	unsigned int rx, tx;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a9ef0544e30f..6aacc0fe34fc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -812,7 +812,9 @@ static int aq_ethtool_set_pauseparam(struct net_device *ndev,
 }
 
 static void aq_get_ringparam(struct net_device *ndev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct ethtool_ringparam_ext *ring_ext,
+			     struct netlink_ext_ack *extack)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
@@ -827,7 +829,9 @@ static void aq_get_ringparam(struct net_device *ndev,
 }
 
 static int aq_set_ringparam(struct net_device *ndev,
-			    struct ethtool_ringparam *ring)
+			    struct ethtool_ringparam *ring,
+			    struct ethtool_ringparam_ext *ring_ext,
+			    struct netlink_ext_ack *extack)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	const struct aq_hw_caps_s *hw_caps;
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 68f6c0bbd945..92ac2eba0b36 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3438,7 +3438,9 @@ static void atl1_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
 }
 
 static void atl1_get_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	struct atl1_tpd_ring *txdr = &adapter->tpd_ring;
@@ -3451,7 +3453,9 @@ static void atl1_get_ringparam(struct net_device *netdev,
 }
 
 static int atl1_set_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	struct atl1_tpd_ring *tpdr = &adapter->tpd_ring;
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index fa784953c601..10fd625285f2 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1959,7 +1959,9 @@ static int b44_set_link_ksettings(struct net_device *dev,
 }
 
 static void b44_get_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct ethtool_ringparam_ext *ering_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct b44 *bp = netdev_priv(dev);
 
@@ -1970,7 +1972,9 @@ static void b44_get_ringparam(struct net_device *dev,
 }
 
 static int b44_set_ringparam(struct net_device *dev,
-			     struct ethtool_ringparam *ering)
+			     struct ethtool_ringparam *ering,
+			     struct ethtool_ringparam_ext *ering_ext,
+			     struct netlink_ext_ack *extack)
 {
 	struct b44 *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index d56886300ecf..33c7c612c84f 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1498,7 +1498,9 @@ static int bcm_enet_set_link_ksettings(struct net_device *dev,
 }
 
 static void bcm_enet_get_ringparam(struct net_device *dev,
-				   struct ethtool_ringparam *ering)
+				   struct ethtool_ringparam *ering,
+				   struct ethtool_ringparam_ext *ering_ext,
+				   struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 
@@ -1512,7 +1514,9 @@ static void bcm_enet_get_ringparam(struct net_device *dev,
 }
 
 static int bcm_enet_set_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *ering)
+				  struct ethtool_ringparam *ering,
+				  struct ethtool_ringparam_ext *ering_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 	int was_running;
@@ -2580,7 +2584,9 @@ static void bcm_enetsw_get_ethtool_stats(struct net_device *netdev,
 }
 
 static void bcm_enetsw_get_ringparam(struct net_device *dev,
-				     struct ethtool_ringparam *ering)
+				     struct ethtool_ringparam *ering,
+				     struct ethtool_ringparam_ext *ering_ext,
+				     struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 
@@ -2596,7 +2602,9 @@ static void bcm_enetsw_get_ringparam(struct net_device *dev,
 }
 
 static int bcm_enetsw_set_ringparam(struct net_device *dev,
-				    struct ethtool_ringparam *ering)
+				    struct ethtool_ringparam *ering,
+				    struct ethtool_ringparam_ext *ering_ext,
+				    struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 	int was_running;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 8c83973adca5..a197736e806b 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7318,7 +7318,9 @@ static int bnx2_set_coalesce(struct net_device *dev,
 }
 
 static void
-bnx2_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+bnx2_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering,
+		   struct ethtool_ringparam_ext *ering_ext,
+		   struct netlink_ext_ack *extack)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
@@ -7389,7 +7391,9 @@ bnx2_change_ring_size(struct bnx2 *bp, u32 rx, u32 tx, bool reset_irq)
 }
 
 static int
-bnx2_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+bnx2_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ering,
+		   struct ethtool_ringparam_ext *ering_ext,
+		   struct netlink_ext_ack *extack)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 	int rc;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 472a3a478038..f3c72597cf1e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1914,7 +1914,9 @@ static int bnx2x_set_coalesce(struct net_device *dev,
 }
 
 static void bnx2x_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ering)
+				struct ethtool_ringparam *ering,
+				struct ethtool_ringparam_ext *ering_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
@@ -1938,7 +1940,9 @@ static void bnx2x_get_ringparam(struct net_device *dev,
 }
 
 static int bnx2x_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct ethtool_ringparam_ext *ering_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7260910e75fb..de35b51105dc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -773,7 +773,9 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 }
 
 static void bnxt_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct ethtool_ringparam_ext *ering_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
@@ -792,7 +794,9 @@ static void bnxt_get_ringparam(struct net_device *dev,
 }
 
 static int bnxt_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct ethtool_ringparam_ext *ering_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5e0e0e70d801..97604ccf6a6f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12396,7 +12396,10 @@ static int tg3_nway_reset(struct net_device *dev)
 	return r;
 }
 
-static void tg3_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+static void tg3_get_ringparam(struct net_device *dev,
+			      struct ethtool_ringparam *ering,
+			      struct ethtool_ringparam_ext *ering_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
@@ -12417,7 +12420,10 @@ static void tg3_get_ringparam(struct net_device *dev, struct ethtool_ringparam *
 	ering->tx_pending = tp->napi[0].tx_pending;
 }
 
-static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+static int tg3_set_ringparam(struct net_device *dev,
+			     struct ethtool_ringparam *ering,
+			     struct ethtool_ringparam_ext *ering_ext,
+			     struct netlink_ext_ack *extack)
 {
 	struct tg3 *tp = netdev_priv(dev);
 	int i, irq_sync = 0, err = 0;
diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 391b85f25141..8eba325c9764 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -405,7 +405,9 @@ static int bnad_set_coalesce(struct net_device *netdev,
 
 static void
 bnad_get_ringparam(struct net_device *netdev,
-		   struct ethtool_ringparam *ringparam)
+		   struct ethtool_ringparam *ringparam,
+		   struct ethtool_ringparam_ext *ering_ext,
+		   struct netlink_ext_ack *extack)
 {
 	struct bnad *bnad = netdev_priv(netdev);
 
@@ -418,7 +420,9 @@ bnad_get_ringparam(struct net_device *netdev,
 
 static int
 bnad_set_ringparam(struct net_device *netdev,
-		   struct ethtool_ringparam *ringparam)
+		   struct ethtool_ringparam *ringparam,
+		   struct ethtool_ringparam_ext *ering_ext,
+		   struct netlink_ext_ack *extack)
 {
 	int i, current_err, err = 0;
 	struct bnad *bnad = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e2730b3e1a57..5277ee50f597 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3096,7 +3096,9 @@ static int macb_set_link_ksettings(struct net_device *netdev,
 }
 
 static void macb_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct macb *bp = netdev_priv(netdev);
 
@@ -3108,7 +3110,9 @@ static void macb_get_ringparam(struct net_device *netdev,
 }
 
 static int macb_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct macb *bp = netdev_priv(netdev);
 	u32 new_rx_size, new_tx_size;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index 2b9747867d4c..303c0472c93a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -947,7 +947,9 @@ static int lio_set_phys_id(struct net_device *netdev,
 
 static void
 lio_ethtool_get_ringparam(struct net_device *netdev,
-			  struct ethtool_ringparam *ering)
+			  struct ethtool_ringparam *ering,
+			  struct ethtool_ringparam_ext *ering_ext,
+			  struct netlink_ext_ack *extack)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
@@ -1253,7 +1255,9 @@ static int lio_reset_queues(struct net_device *netdev, uint32_t num_qs)
 }
 
 static int lio_ethtool_set_ringparam(struct net_device *netdev,
-				     struct ethtool_ringparam *ering)
+				     struct ethtool_ringparam *ering,
+				     struct ethtool_ringparam_ext *ering_ext,
+				     struct netlink_ext_ack *extack)
 {
 	u32 rx_count, tx_count, rx_count_old, tx_count_old;
 	struct lio *lio = GET_LIO(netdev);
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index 7f2882109b16..01aaa5a77c4b 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -467,7 +467,9 @@ static int nicvf_get_coalesce(struct net_device *netdev,
 }
 
 static void nicvf_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 	struct queue_set *qs = nic->qs;
@@ -479,7 +481,9 @@ static void nicvf_get_ringparam(struct net_device *netdev,
 }
 
 static int nicvf_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 	struct queue_set *qs = nic->qs;
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index d246eee4b6d5..8e72a7f95401 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -710,7 +710,9 @@ static int set_pauseparam(struct net_device *dev,
 	return 0;
 }
 
-static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			  struct ethtool_ringparam_ext *e_ext,
+			  struct netlink_ext_ack *extack)
 {
 	struct adapter *adapter = dev->ml_priv;
 	int jumbo_fl = t1_is_T1B(adapter) ? 1 : 0;
@@ -724,7 +726,9 @@ static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	e->tx_pending = adapter->params.sge.cmdQ_size[0];
 }
 
-static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			 struct ethtool_ringparam_ext *e_ext,
+			 struct netlink_ext_ack *extack)
 {
 	struct adapter *adapter = dev->ml_priv;
 	int jumbo_fl = t1_is_T1B(adapter) ? 1 : 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 38e47703f9ab..5d40e19579e6 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1948,7 +1948,9 @@ static int set_pauseparam(struct net_device *dev,
 	return 0;
 }
 
-static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			  struct ethtool_ringparam_ext *e_ext,
+			  struct netlink_ext_ack *extack)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
@@ -1964,7 +1966,9 @@ static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	e->tx_pending = q->txq_size[0];
 }
 
-static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			 struct ethtool_ringparam_ext *e_ext,
+			 struct netlink_ext_ack *extack)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 5903bdb78916..675a27b167a0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -890,7 +890,9 @@ static int set_pauseparam(struct net_device *dev,
 	return 0;
 }
 
-static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			  struct ethtool_ringparam_ext *e_ext,
+			  struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	const struct sge *s = &pi->adapter->sge;
@@ -906,7 +908,9 @@ static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	e->tx_pending = s->ethtxq[pi->first_qset].q.size;
 }
 
-static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			 struct ethtool_ringparam_ext *e_ext,
+			 struct netlink_ext_ack *extack)
 {
 	int i;
 	const struct port_info *pi = netdev_priv(dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 4920a80a0460..ade808daf16b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1591,7 +1591,9 @@ static void cxgb4vf_set_msglevel(struct net_device *dev, u32 msglevel)
  * first Queue Set.
  */
 static void cxgb4vf_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *rp)
+				  struct ethtool_ringparam *rp,
+				  struct ethtool_ringparam_ext *rp_ext,
+				  struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	const struct sge *s = &pi->adapter->sge;
@@ -1614,7 +1616,9 @@ static void cxgb4vf_get_ringparam(struct net_device *dev,
  * device -- after vetting them of course!
  */
 static int cxgb4vf_set_ringparam(struct net_device *dev,
-				 struct ethtool_ringparam *rp)
+				 struct ethtool_ringparam *rp,
+				 struct ethtool_ringparam_ext *rp_ext,
+				 struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 12ffc14fbecd..89857c03375d 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -177,7 +177,9 @@ static void enic_get_strings(struct net_device *netdev, u32 stringset,
 }
 
 static void enic_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct enic *enic = netdev_priv(netdev);
 	struct vnic_enet_config *c = &enic->config;
@@ -189,7 +191,9 @@ static void enic_get_ringparam(struct net_device *netdev,
 }
 
 static int enic_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct enic *enic = netdev_priv(netdev);
 	struct vnic_enet_config *c = &enic->config;
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 6e745ca4c433..a8b9bcc50e02 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2105,7 +2105,9 @@ static void gmac_get_pauseparam(struct net_device *netdev,
 }
 
 static void gmac_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *rp)
+			       struct ethtool_ringparam *rp,
+			       struct ethtool_ringparam_ext *rp_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 
@@ -2123,7 +2125,9 @@ static void gmac_get_ringparam(struct net_device *netdev,
 }
 
 static int gmac_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *rp)
+			      struct ethtool_ringparam *rp,
+			      struct ethtool_ringparam_ext *rp_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 	int err = 0;
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index f9955308b93d..db1c8eef6091 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -683,7 +683,9 @@ static int be_get_link_ksettings(struct net_device *netdev,
 }
 
 static void be_get_ringparam(struct net_device *netdev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct ethtool_ringparam_ext *ring_ext,
+			     struct netlink_ext_ack *extack)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 0064ebdaf4b4..efec86e49887 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -945,7 +945,9 @@ static void ethoc_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 }
 
 static void ethoc_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct ethoc *priv = netdev_priv(dev);
 
@@ -961,7 +963,9 @@ static void ethoc_get_ringparam(struct net_device *dev,
 }
 
 static int ethoc_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct ethoc *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index ff76e401a014..832da04ed257 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1182,7 +1182,9 @@ static void ftgmac100_get_drvinfo(struct net_device *netdev,
 }
 
 static void ftgmac100_get_ringparam(struct net_device *netdev,
-				    struct ethtool_ringparam *ering)
+				    struct ethtool_ringparam *ering,
+				    struct ethtool_ringparam_ext *ering_ext,
+				    struct netlink_ext_ack *extack)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 
@@ -1194,7 +1196,9 @@ static void ftgmac100_get_ringparam(struct net_device *netdev,
 }
 
 static int ftgmac100_set_ringparam(struct net_device *netdev,
-				   struct ethtool_ringparam *ering)
+				   struct ethtool_ringparam *ering,
+				   struct ethtool_ringparam_ext *ering_ext,
+				   struct netlink_ext_ack *extack)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 9690e36e9e85..1302d1ab1a17 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -562,7 +562,9 @@ static int enetc_set_rxfh(struct net_device *ndev, const u32 *indir,
 }
 
 static void enetc_get_ringparam(struct net_device *ndev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 7b32ed29bf4c..0eec50eae4b0 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -372,7 +372,9 @@ static int gfar_scoalesce(struct net_device *dev,
  * rx, rx_mini, and rx_jumbo rings are the same size, as mini and
  * jumbo are ignored by the driver */
 static void gfar_gringparam(struct net_device *dev,
-			    struct ethtool_ringparam *rvals)
+			    struct ethtool_ringparam *rvals,
+			    struct ethtool_ringparam_ext *rvals_ext,
+			    struct netlink_ext_ack *extack)
 {
 	struct gfar_private *priv = netdev_priv(dev);
 	struct gfar_priv_tx_q *tx_queue = NULL;
@@ -399,7 +401,9 @@ static void gfar_gringparam(struct net_device *dev,
  * necessary so that we don't mess things up while we're in motion.
  */
 static int gfar_sringparam(struct net_device *dev,
-			   struct ethtool_ringparam *rvals)
+			   struct ethtool_ringparam *rvals,
+			   struct ethtool_ringparam_ext *rvals_ext,
+			   struct netlink_ext_ack *extack)
 {
 	struct gfar_private *priv = netdev_priv(dev);
 	int err = 0, i;
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index 14c08a868190..985f9cdb7e8a 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -207,7 +207,9 @@ uec_get_regs(struct net_device *netdev,
 
 static void
 uec_get_ringparam(struct net_device *netdev,
-                    struct ethtool_ringparam *ring)
+		  struct ethtool_ringparam *ring,
+		  struct ethtool_ringparam_ext *ring_ext,
+		  struct netlink_ext_ack *extack)
 {
 	struct ucc_geth_private *ugeth = netdev_priv(netdev);
 	struct ucc_geth_info *ug_info = ugeth->ug_info;
@@ -226,7 +228,9 @@ uec_get_ringparam(struct net_device *netdev,
 
 static int
 uec_set_ringparam(struct net_device *netdev,
-                    struct ethtool_ringparam *ring)
+		  struct ethtool_ringparam *ring,
+		  struct ethtool_ringparam_ext *ring_ext,
+		  struct netlink_ext_ack *extack)
 {
 	struct ucc_geth_private *ugeth = netdev_priv(netdev);
 	struct ucc_geth_info *ug_info = ugeth->ug_info;
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 716e6240305d..70b92022e46c 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -416,7 +416,9 @@ static int gve_set_channels(struct net_device *netdev,
 }
 
 static void gve_get_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *cmd)
+			      struct ethtool_ringparam *cmd,
+			      struct ethtool_ringparam_ext *ering_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index ab7390225942..a2abd0f64e1a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -663,9 +663,13 @@ static void hns_nic_get_drvinfo(struct net_device *net_dev,
  * hns_get_ringparam - get ring parameter
  * @net_dev: net device
  * @param: ethtool parameter
+ * @param_ext: ethtool external parameter
+ * @extack: netlink netlink extended ACK report struct
  */
 static void hns_get_ringparam(struct net_device *net_dev,
-			      struct ethtool_ringparam *param)
+			      struct ethtool_ringparam *param,
+			      struct ethtool_ringparam_ext *param_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct hns_nic_priv *priv = netdev_priv(net_dev);
 	struct hnae_ae_ops *ops;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c757e067f31f..ed50b3b7b9e8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -639,7 +639,9 @@ static u32 hns3_get_link(struct net_device *netdev)
 }
 
 static void hns3_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct ethtool_ringparam_ext *param_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
@@ -1077,7 +1079,9 @@ static int hns3_check_ringparam(struct net_device *ndev,
 }
 
 static int hns3_set_ringparam(struct net_device *ndev,
-			      struct ethtool_ringparam *param)
+			      struct ethtool_ringparam *param,
+			      struct ethtool_ringparam_ext *param_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	struct hnae3_handle *h = priv->ae_handle;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index b431c300ef1b..7a79bfb9e0ff 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -549,7 +549,9 @@ static void hinic_get_drvinfo(struct net_device *netdev,
 }
 
 static void hinic_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
@@ -582,7 +584,9 @@ static int check_ringparam_valid(struct hinic_dev *nic_dev,
 }
 
 static int hinic_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	u16 new_sq_depth, new_rq_depth;
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 664a91af662d..134fa6c265ca 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2138,7 +2138,9 @@ emac_ethtool_set_link_ksettings(struct net_device *ndev,
 }
 
 static void emac_ethtool_get_ringparam(struct net_device *ndev,
-				       struct ethtool_ringparam *rp)
+				       struct ethtool_ringparam *rp,
+				       struct ethtool_ringparam_ext *rp_ext,
+				       struct netlink_ext_ack *extack)
 {
 	rp->rx_max_pending = rp->rx_pending = NUM_RX_BUFF;
 	rp->tx_max_pending = rp->tx_pending = NUM_TX_BUFF;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8f17096e614d..fce169457828 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3090,7 +3090,9 @@ static u32 ibmvnic_get_link(struct net_device *netdev)
 }
 
 static void ibmvnic_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct ethtool_ringparam_ext *ring_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
@@ -3110,7 +3112,9 @@ static void ibmvnic_get_ringparam(struct net_device *netdev,
 }
 
 static int ibmvnic_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int ret;
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 373eb027b925..a103a3eaf74b 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2549,7 +2549,9 @@ static int e100_set_eeprom(struct net_device *netdev,
 }
 
 static void e100_get_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct nic *nic = netdev_priv(netdev);
 	struct param_range *rfds = &nic->params.rfds;
@@ -2562,7 +2564,9 @@ static void e100_get_ringparam(struct net_device *netdev,
 }
 
 static int e100_set_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct nic *nic = netdev_priv(netdev);
 	struct param_range *rfds = &nic->params.rfds;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 0a57172dfcbc..a96f4eb74a84 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -539,7 +539,9 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 }
 
 static void e1000_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
@@ -556,7 +558,9 @@ static void e1000_get_ringparam(struct net_device *netdev,
 }
 
 static int e1000_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 8515e00d1b40..0fa5962639e1 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -655,7 +655,9 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 }
 
 static void e1000_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -666,7 +668,9 @@ static void e1000_get_ringparam(struct net_device *netdev,
 }
 
 static int e1000_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_ring *temp_tx = NULL, *temp_rx = NULL;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 0d37f011d0ce..1ae89e58de3d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -502,7 +502,9 @@ static void fm10k_set_msglevel(struct net_device *netdev, u32 data)
 }
 
 static void fm10k_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct fm10k_intfc *interface = netdev_priv(netdev);
 
@@ -517,7 +519,9 @@ static void fm10k_get_ringparam(struct net_device *netdev,
 }
 
 static int fm10k_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct fm10k_intfc *interface = netdev_priv(netdev);
 	struct fm10k_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 513ba6974355..ca3a1e6b07e5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1916,7 +1916,9 @@ static void i40e_get_drvinfo(struct net_device *netdev,
 }
 
 static void i40e_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_pf *pf = np->vsi->back;
@@ -1944,7 +1946,9 @@ static bool i40e_active_tx_ring_index(struct i40e_vsi *vsi, u16 index)
 }
 
 static int i40e_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct i40e_ring *tx_rings = NULL, *rx_rings = NULL;
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 5a359a0a20ec..f576324d025b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -580,12 +580,16 @@ static void iavf_get_drvinfo(struct net_device *netdev,
  * iavf_get_ringparam - Get ring parameters
  * @netdev: network interface device structure
  * @ring: ethtool ringparam structure
+ * @ring_ext: ethtool extenal ringparam structure
+ * @extack: netlink netlink extended ACK report struct
  *
  * Returns current ring parameters. TX and RX rings are reported separately,
  * but the number of rings is not reported.
  **/
 static void iavf_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
@@ -599,12 +603,16 @@ static void iavf_get_ringparam(struct net_device *netdev,
  * iavf_set_ringparam - Set ring parameters
  * @netdev: network interface device structure
  * @ring: ethtool ringparam structure
+ * @ring_ext: ethtool external ringparam structure
+ * @extack: netlink netlink extended ACK report struct
  *
  * Sets ring parameters. TX and RX rings are controlled separately, but the
  * number of rings is not specified, so all rings get the same settings.
  **/
 static int iavf_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	u32 new_rx_count, new_tx_count;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index c451cf401e63..596521f2792e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2647,7 +2647,9 @@ ice_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 }
 
 static void
-ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct ethtool_ringparam_ext *ring_ext,
+		  struct netlink_ext_ack *extack)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -2665,7 +2667,9 @@ ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 }
 
 static int
-ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct ethtool_ringparam_ext *ring_ext,
+		  struct netlink_ext_ack *extack)
 {
 	struct ice_ring *tx_rings = NULL, *rx_rings = NULL;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index fb1029352c3e..9cd533604ada 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -864,7 +864,9 @@ static void igb_get_drvinfo(struct net_device *netdev,
 }
 
 static void igb_get_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
@@ -875,7 +877,9 @@ static void igb_get_ringparam(struct net_device *netdev,
 }
 
 static int igb_set_ringparam(struct net_device *netdev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct ethtool_ringparam_ext *ring_ext,
+			     struct netlink_ext_ack *extack)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct igb_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index 06e5bd646a0e..764b37c4852f 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -175,7 +175,9 @@ static void igbvf_get_drvinfo(struct net_device *netdev,
 }
 
 static void igbvf_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	struct igbvf_ring *tx_ring = adapter->tx_ring;
@@ -188,7 +190,9 @@ static void igbvf_get_ringparam(struct net_device *netdev,
 }
 
 static int igbvf_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	struct igbvf_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index e0a76ac1bbbc..8f2f282a7072 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -568,7 +568,9 @@ static int igc_ethtool_set_eeprom(struct net_device *netdev,
 }
 
 static void igc_ethtool_get_ringparam(struct net_device *netdev,
-				      struct ethtool_ringparam *ring)
+				      struct ethtool_ringparam *ring,
+				      struct ethtool_ringparam_ext *ring_ext,
+				      struct netlink_ext_ack *extack)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
@@ -579,7 +581,9 @@ static void igc_ethtool_get_ringparam(struct net_device *netdev,
 }
 
 static int igc_ethtool_set_ringparam(struct net_device *netdev,
-				     struct ethtool_ringparam *ring)
+				     struct ethtool_ringparam *ring,
+				     struct ethtool_ringparam_ext *ring_ext,
+				     struct netlink_ext_ack *extack)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	struct igc_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
index 582099a5ad41..0317f715e84d 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
@@ -464,7 +464,9 @@ ixgb_get_drvinfo(struct net_device *netdev,
 
 static void
 ixgb_get_ringparam(struct net_device *netdev,
-		struct ethtool_ringparam *ring)
+		   struct ethtool_ringparam *ring,
+		   struct ethtool_ringparam_ext *ring_ext,
+		   struct netlink_ext_ack *extack)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	struct ixgb_desc_ring *txdr = &adapter->tx_ring;
@@ -478,7 +480,9 @@ ixgb_get_ringparam(struct net_device *netdev,
 
 static int
 ixgb_set_ringparam(struct net_device *netdev,
-		struct ethtool_ringparam *ring)
+		   struct ethtool_ringparam *ring,
+		   struct ethtool_ringparam_ext *ring_ext,
+		   struct netlink_ext_ack *extack)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	struct ixgb_desc_ring *txdr = &adapter->tx_ring;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index fc26e4ddeb0d..ee7b8f04da59 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1119,7 +1119,9 @@ static void ixgbe_get_drvinfo(struct net_device *netdev,
 }
 
 static void ixgbe_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_ring *tx_ring = adapter->tx_ring[0];
@@ -1132,7 +1134,9 @@ static void ixgbe_get_ringparam(struct net_device *netdev,
 }
 
 static int ixgbe_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 8380f905e708..0b9dd29b3cd2 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -225,7 +225,9 @@ static void ixgbevf_get_drvinfo(struct net_device *netdev,
 }
 
 static void ixgbevf_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct ethtool_ringparam_ext *ring_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
@@ -236,7 +238,9 @@ static void ixgbevf_get_ringparam(struct net_device *netdev,
 }
 
 static int ixgbevf_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 	struct ixgbevf_ring *tx_ring = NULL, *rx_ring = NULL;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 28d5ad296646..811da9acb464 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1638,7 +1638,9 @@ static int mv643xx_eth_set_coalesce(struct net_device *dev,
 }
 
 static void
-mv643xx_eth_get_ringparam(struct net_device *dev, struct ethtool_ringparam *er)
+mv643xx_eth_get_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
+			  struct ethtool_ringparam_ext *er_ext,
+			  struct netlink_ext_ack *extack)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
@@ -1650,7 +1652,9 @@ mv643xx_eth_get_ringparam(struct net_device *dev, struct ethtool_ringparam *er)
 }
 
 static int
-mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er)
+mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
+			  struct ethtool_ringparam_ext *er_ext,
+			  struct netlink_ext_ack *extack)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 9d460a270601..12d5b23f841a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4556,7 +4556,9 @@ static void mvneta_ethtool_get_drvinfo(struct net_device *dev,
 
 
 static void mvneta_ethtool_get_ringparam(struct net_device *netdev,
-					 struct ethtool_ringparam *ring)
+					 struct ethtool_ringparam *ring,
+					 struct ethtool_ringparam_ext *ring_ext,
+					 struct netlink_ext_ack *extack)
 {
 	struct mvneta_port *pp = netdev_priv(netdev);
 
@@ -4567,7 +4569,9 @@ static void mvneta_ethtool_get_ringparam(struct net_device *netdev,
 }
 
 static int mvneta_ethtool_set_ringparam(struct net_device *dev,
-					struct ethtool_ringparam *ring)
+					struct ethtool_ringparam *ring,
+					struct ethtool_ringparam_ext *ring_ext,
+					struct netlink_ext_ack *extack)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d5c92e43f89e..2bbab8f204b9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5430,7 +5430,9 @@ static void mvpp2_ethtool_get_drvinfo(struct net_device *dev,
 }
 
 static void mvpp2_ethtool_get_ringparam(struct net_device *dev,
-					struct ethtool_ringparam *ring)
+					struct ethtool_ringparam *ring,
+					struct ethtool_ringparam_ext *ring_ext,
+					struct netlink_ext_ack *extack)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 
@@ -5441,7 +5443,9 @@ static void mvpp2_ethtool_get_ringparam(struct net_device *dev,
 }
 
 static int mvpp2_ethtool_set_ringparam(struct net_device *dev,
-				       struct ethtool_ringparam *ring)
+				       struct ethtool_ringparam *ring,
+				       struct ethtool_ringparam_ext *ring_ext,
+				       struct netlink_ext_ack *extack)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	u16 prev_rx_ring_size = port->rx_ring_size;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 38e5924ca8e9..f842c3f885d5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -360,7 +360,9 @@ static int otx2_set_pauseparam(struct net_device *netdev,
 }
 
 static void otx2_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_qset *qs = &pfvf->qset;
@@ -372,7 +374,9 @@ static void otx2_get_ringparam(struct net_device *netdev,
 }
 
 static int otx2_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	bool if_up = netif_running(netdev);
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 051dd3fb5b03..1700479b2f68 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -492,7 +492,9 @@ static void skge_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 }
 
 static void skge_get_ring_param(struct net_device *dev,
-				struct ethtool_ringparam *p)
+				struct ethtool_ringparam *p,
+				struct ethtool_ringparam_ext *p_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct skge_port *skge = netdev_priv(dev);
 
@@ -504,7 +506,9 @@ static void skge_get_ring_param(struct net_device *dev,
 }
 
 static int skge_set_ring_param(struct net_device *dev,
-			       struct ethtool_ringparam *p)
+			       struct ethtool_ringparam *p,
+			       struct ethtool_ringparam_ext *p_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct skge_port *skge = netdev_priv(dev);
 	int err = 0;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 3cb9c1271328..0df186119d84 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4149,7 +4149,9 @@ static unsigned long roundup_ring_size(unsigned long pending)
 }
 
 static void sky2_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct ethtool_ringparam_ext *ering_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 
@@ -4161,7 +4163,9 @@ static void sky2_get_ringparam(struct net_device *dev,
 }
 
 static int sky2_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct ethtool_ringparam_ext *ering_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index ef518b1040f7..de543e043ddf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1138,7 +1138,9 @@ static void mlx4_en_get_pauseparam(struct net_device *dev,
 }
 
 static int mlx4_en_set_ringparam(struct net_device *dev,
-				 struct ethtool_ringparam *param)
+				 struct ethtool_ringparam *param,
+				 struct ethtool_ringparam_ext *param_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
@@ -1205,7 +1207,9 @@ static int mlx4_en_set_ringparam(struct net_device *dev,
 }
 
 static void mlx4_en_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *param)
+				  struct ethtool_ringparam *param,
+				  struct ethtool_ringparam_ext *param_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 306fb5d6a36d..286b090273fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -316,7 +316,9 @@ void mlx5e_ethtool_get_ringparam(struct mlx5e_priv *priv,
 }
 
 static void mlx5e_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *param)
+				struct ethtool_ringparam *param,
+				struct ethtool_ringparam_ext *param_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
@@ -382,7 +384,9 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 }
 
 static int mlx5e_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct ethtool_ringparam_ext *param_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ae71a17fdb27..7b86e9533817 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -219,7 +219,9 @@ static int mlx5e_rep_get_sset_count(struct net_device *dev, int sset)
 }
 
 static void mlx5e_rep_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *param)
+				    struct ethtool_ringparam *param,
+				    struct ethtool_ringparam_ext *param_ext,
+				    struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
@@ -227,7 +229,9 @@ static void mlx5e_rep_get_ringparam(struct net_device *dev,
 }
 
 static int mlx5e_rep_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+				   struct ethtool_ringparam *param,
+				   struct ethtool_ringparam_ext *param_ext,
+				   struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 0c8594c7df21..86c152298e43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -67,7 +67,9 @@ static void mlx5i_get_ethtool_stats(struct net_device *dev,
 }
 
 static int mlx5i_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct ethtool_ringparam_ext *param_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
@@ -75,7 +77,9 @@ static int mlx5i_set_ringparam(struct net_device *dev,
 }
 
 static void mlx5i_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *param)
+				struct ethtool_ringparam *param,
+				struct ethtool_ringparam_ext *param_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
index 92b798f8e73a..3c6674ea7241 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
@@ -34,7 +34,9 @@ static void mlxbf_gige_get_regs(struct net_device *netdev,
 }
 
 static void mlxbf_gige_get_ringparam(struct net_device *netdev,
-				     struct ethtool_ringparam *ering)
+				     struct ethtool_ringparam *ering,
+				     struct ethtool_ringparam_ext *ering_ext,
+				     struct netlink_ext_ack *extack)
 {
 	struct mlxbf_gige *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index a0ee155f9f51..f7bc31651946 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6317,11 +6317,14 @@ static int netdev_set_pauseparam(struct net_device *dev,
  * netdev_get_ringparam - get tx/rx ring parameters
  * @dev:	Network device.
  * @ring:	Ethtool RING settings data structure.
+ * @ring_ext:	Ethtool external RING settings data structure.
  *
  * This procedure returns the TX/RX ring settings.
  */
 static void netdev_get_ringparam(struct net_device *dev,
-	struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct dev_priv *priv = netdev_priv(dev);
 	struct dev_info *hw_priv = priv->adapter;
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c1a75b08ced7..485b61e9ddef 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1703,7 +1703,9 @@ myri10ge_set_pauseparam(struct net_device *netdev,
 
 static void
 myri10ge_get_ringparam(struct net_device *netdev,
-		       struct ethtool_ringparam *ring)
+		       struct ethtool_ringparam *ring,
+		       struct ethtool_ringparam_ext *ring_ext,
+		       struct netlink_ext_ack *extack)
 {
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 09c0e839cca5..48edddf5929a 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -5462,7 +5462,9 @@ static int s2io_ethtool_set_led(struct net_device *dev,
 }
 
 static void s2io_ethtool_gringparam(struct net_device *dev,
-				    struct ethtool_ringparam *ering)
+				    struct ethtool_ringparam *ering,
+				    struct ethtool_ringparam_ext *ering_ext,
+				    struct netlink_ext_ack *extack)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
 	int i, tx_desc_count = 0, rx_desc_count = 0;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 0685ece1f155..21e58081872b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -380,7 +380,9 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
 }
 
 static void nfp_net_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct ethtool_ringparam_ext *ring_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 
@@ -405,7 +407,9 @@ static int nfp_net_set_ring_size(struct nfp_net *nn, u32 rxd_cnt, u32 txd_cnt)
 }
 
 static int nfp_net_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	u32 rxd_cnt, txd_cnt;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index ef3fb4cc90af..805947dccbb2 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4651,7 +4651,10 @@ static int nv_nway_reset(struct net_device *dev)
 	return ret;
 }
 
-static void nv_get_ringparam(struct net_device *dev, struct ethtool_ringparam* ring)
+static void nv_get_ringparam(struct net_device *dev,
+			     struct ethtool_ringparam *ring,
+			     struct ethtool_ringparam_ext *ring_ext,
+			     struct netlink_ext_ack *extack)
 {
 	struct fe_priv *np = netdev_priv(dev);
 
@@ -4662,7 +4665,10 @@ static void nv_get_ringparam(struct net_device *dev, struct ethtool_ringparam* r
 	ring->tx_pending = np->tx_ring_size;
 }
 
-static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ring)
+static int nv_set_ringparam(struct net_device *dev,
+			    struct ethtool_ringparam *ring,
+			    struct ethtool_ringparam_ext *ring_ext,
+			    struct netlink_ext_ack *extack)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index 660b07cb5b92..f4f4eaf8b66f 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -270,9 +270,12 @@ static int pch_gbe_nway_reset(struct net_device *netdev)
  * pch_gbe_get_ringparam - Report ring sizes
  * @netdev:  Network interface device structure
  * @ring:    Ring param structure
+ * @ring_ext:	Ring external param structure
  */
 static void pch_gbe_get_ringparam(struct net_device *netdev,
-					struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct ethtool_ringparam_ext *ring_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	struct pch_gbe_tx_ring *txdr = adapter->tx_ring;
@@ -288,12 +291,15 @@ static void pch_gbe_get_ringparam(struct net_device *netdev,
  * pch_gbe_set_ringparam - Set ring sizes
  * @netdev:  Network interface device structure
  * @ring:    Ring param structure
+ * @ring_ext:	Ring external param structure
  * Returns
  *	0:			Successful.
  *	Negative value:		Failed.
  */
 static int pch_gbe_set_ringparam(struct net_device *netdev,
-					struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	struct pch_gbe_tx_ring *txdr, *tx_old;
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c b/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
index e1a304886a3c..fd11307ea08a 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
@@ -69,7 +69,9 @@ pasemi_mac_ethtool_set_msglevel(struct net_device *netdev,
 
 static void
 pasemi_mac_ethtool_get_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ering)
+				 struct ethtool_ringparam *ering,
+				 struct ethtool_ringparam_ext *ering_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct pasemi_mac *mac = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 3de1a03839e2..c0b9814c0e7e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -527,7 +527,9 @@ static int ionic_set_coalesce(struct net_device *netdev,
 }
 
 static void ionic_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
@@ -538,7 +540,9 @@ static void ionic_get_ringparam(struct net_device *netdev,
 }
 
 static int ionic_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_queue_params qparam;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index a075643f5826..a86efa1ef56a 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -392,7 +392,9 @@ netxen_nic_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 
 static void
 netxen_nic_get_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+			 struct ethtool_ringparam *ring,
+			 struct ethtool_ringparam_ext *ring_ext,
+			 struct netlink_ext_ack *extack)
 {
 	struct netxen_adapter *adapter = netdev_priv(dev);
 
@@ -430,7 +432,9 @@ netxen_validate_ringparam(u32 val, u32 min, u32 max, char *r_name)
 
 static int
 netxen_nic_set_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+			 struct ethtool_ringparam *ring,
+			 struct ethtool_ringparam_ext *ring_ext,
+			 struct netlink_ext_ack *extack)
 {
 	struct netxen_adapter *adapter = netdev_priv(dev);
 	u16 max_rcv_desc = MAX_RCV_DESCRIPTORS_10G;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8284c4c1528f..75daee33f0e7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -888,7 +888,9 @@ int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal,
 }
 
 static void qede_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct ethtool_ringparam_ext *ering_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
@@ -899,7 +901,9 @@ static void qede_get_ringparam(struct net_device *dev,
 }
 
 static int qede_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct ethtool_ringparam_ext *ering_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index fc364b4ab6eb..516685ddd023 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -632,7 +632,9 @@ qlcnic_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 
 static void
 qlcnic_get_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+		     struct ethtool_ringparam *ring,
+		     struct ethtool_ringparam_ext *ring_ext,
+		     struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(dev);
 
@@ -663,7 +665,9 @@ qlcnic_validate_ringparam(u32 val, u32 min, u32 max, char *r_name)
 
 static int
 qlcnic_set_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+		     struct ethtool_ringparam *ring,
+		     struct ethtool_ringparam_ext *ring_ext,
+		     struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(dev);
 	u16 num_rxd, num_jumbo_rxd, num_txd;
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
index f72e13b83869..cf6ce09073f0 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
@@ -133,7 +133,9 @@ static int emac_nway_reset(struct net_device *netdev)
 }
 
 static void emac_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
@@ -144,7 +146,9 @@ static void emac_get_ringparam(struct net_device *netdev,
 }
 
 static int emac_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index d59fff2fbcc6..33d0720c5745 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -246,7 +246,9 @@ qcaspi_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *p)
 }
 
 static void
-qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
+qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring,
+		     struct ethtool_ringparam_ext *ring_ext,
+		     struct netlink_ext_ack *extack)
 {
 	struct qcaspi *qca = netdev_priv(dev);
 
@@ -257,7 +259,9 @@ qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 }
 
 static int
-qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
+qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring,
+		     struct ethtool_ringparam_ext *ring_ext,
+		     struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	struct qcaspi *qca = netdev_priv(dev);
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 2b84b4565e64..4f9f97e2148d 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1388,7 +1388,9 @@ static void cp_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *info
 }
 
 static void cp_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct ethtool_ringparam_ext *ring_ext,
+			     struct netlink_ext_ack *extack)
 {
 	ring->rx_max_pending = CP_RX_RING_SIZE;
 	ring->tx_max_pending = CP_TX_RING_SIZE;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0199914440ab..f0a42cf1b30c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1872,7 +1872,9 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 }
 
 static void rtl8169_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *data)
+				  struct ethtool_ringparam *data,
+				  struct ethtool_ringparam_ext *data_ext,
+				  struct netlink_ext_ack *extack)
 {
 	data->rx_max_pending = NUM_RX_DESC;
 	data->rx_pending = NUM_RX_DESC;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f85f2d97b18..ce1e5648029b 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1246,7 +1246,9 @@ static void ravb_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 }
 
 static void ravb_get_ringparam(struct net_device *ndev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 
@@ -1257,7 +1259,9 @@ static void ravb_get_ringparam(struct net_device *ndev,
 }
 
 static int ravb_set_ringparam(struct net_device *ndev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 1374faa229a2..086e4458b867 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2294,7 +2294,9 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 }
 
 static void sh_eth_get_ringparam(struct net_device *ndev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 
@@ -2305,7 +2307,9 @@ static void sh_eth_get_ringparam(struct net_device *ndev,
 }
 
 static int sh_eth_set_ringparam(struct net_device *ndev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 	int ret;
diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 835c838b7dfa..f0bff0d668b2 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -21,7 +21,9 @@
 #define EFX_EF100_MAX_DMAQ_SIZE 16384UL
 
 static void ef100_ethtool_get_ringparam(struct net_device *net_dev,
-					struct ethtool_ringparam *ring)
+					struct ethtool_ringparam *ring,
+					struct ethtool_ringparam_ext *ring_ext,
+					struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index e002ce21788d..7eaa1a7c6521 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -158,7 +158,9 @@ static int efx_ethtool_set_coalesce(struct net_device *net_dev,
 }
 
 static void efx_ethtool_get_ringparam(struct net_device *net_dev,
-				      struct ethtool_ringparam *ring)
+				      struct ethtool_ringparam *ring,
+				      struct ethtool_ringparam_ext *ring_ext,
+				      struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -169,7 +171,9 @@ static void efx_ethtool_get_ringparam(struct net_device *net_dev,
 }
 
 static int efx_ethtool_set_ringparam(struct net_device *net_dev,
-				     struct ethtool_ringparam *ring)
+				     struct ethtool_ringparam *ring,
+				     struct ethtool_ringparam_ext *ring_ext,
+				     struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	u32 txq_entries;
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index 137e8a7aeaa1..89347774d954 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -638,7 +638,9 @@ static int ef4_ethtool_set_coalesce(struct net_device *net_dev,
 }
 
 static void ef4_ethtool_get_ringparam(struct net_device *net_dev,
-				      struct ethtool_ringparam *ring)
+				      struct ethtool_ringparam *ring,
+				      struct ethtool_ringparam_ext *ring_ext,
+				      struct netlink_ext_ack *extack)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 
@@ -649,7 +651,9 @@ static void ef4_ethtool_get_ringparam(struct net_device *net_dev,
 }
 
 static int ef4_ethtool_set_ringparam(struct net_device *net_dev,
-				     struct ethtool_ringparam *ring)
+				     struct ethtool_ringparam *ring,
+				     struct ethtool_ringparam_ext *ring_ext,
+				     struct netlink_ext_ack *extack)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 	u32 txq_entries;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d89455803bed..d1096cf02722 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -463,7 +463,9 @@ static int stmmac_nway_reset(struct net_device *dev)
 }
 
 static void stmmac_get_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct stmmac_priv *priv = netdev_priv(netdev);
 
@@ -474,7 +476,9 @@ static void stmmac_get_ringparam(struct net_device *netdev,
 }
 
 static int stmmac_set_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
 	    ring->rx_pending < DMA_MIN_RX_SIZE ||
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 6b409f9c5863..e7d0d8254030 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2243,9 +2243,12 @@ static inline int bdx_tx_fifo_size_to_packets(int tx_size)
  * bdx_get_ringparam - report ring sizes
  * @netdev
  * @ring
+ * @ring_ext
  */
 static void
-bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct ethtool_ringparam_ext *ring_ext,
+		  struct netlink_ext_ack *extack)
 {
 	struct bdx_priv *priv = netdev_priv(netdev);
 
@@ -2260,9 +2263,12 @@ bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
  * bdx_set_ringparam - set ring sizes
  * @netdev
  * @ring
+ * @ring_ext
  */
 static int
-bdx_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+bdx_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct ethtool_ringparam_ext *ring_ext,
+		  struct netlink_ext_ack *extack)
 {
 	struct bdx_priv *priv = netdev_priv(netdev);
 	int rx_size = 0;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index 6e4d4f9e32e0..c3dd232286f2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -454,7 +454,9 @@ static int am65_cpsw_set_channels(struct net_device *ndev,
 }
 
 static void am65_cpsw_get_ringparam(struct net_device *ndev,
-				    struct ethtool_ringparam *ering)
+				    struct ethtool_ringparam *ering,
+				    struct ethtool_ringparam_ext *ering_ext,
+				    struct netlink_ext_ack *extack)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index 02d4e51f7306..d9c843429fc3 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -817,7 +817,9 @@ static void cpmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
 }
 
 static void cpmac_get_ringparam(struct net_device *dev,
-						struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct cpmac_priv *priv = netdev_priv(dev);
 
@@ -833,7 +835,9 @@ static void cpmac_get_ringparam(struct net_device *dev,
 }
 
 static int cpmac_set_ringparam(struct net_device *dev,
-						struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct cpmac_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 158c8d3793f4..24c2c6689105 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -658,7 +658,9 @@ int cpsw_set_channels_common(struct net_device *ndev,
 }
 
 void cpsw_get_ringparam(struct net_device *ndev,
-			struct ethtool_ringparam *ering)
+			struct ethtool_ringparam *ering,
+			struct ethtool_ringparam_ext *ring_ext,
+			struct netlink_ext_ack *extack)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
@@ -671,7 +673,9 @@ void cpsw_get_ringparam(struct net_device *ndev,
 }
 
 int cpsw_set_ringparam(struct net_device *ndev,
-		       struct ethtool_ringparam *ering)
+		       struct ethtool_ringparam *ering,
+		       struct ethtool_ringparam_ext *ring_ext,
+		       struct netlink_ext_ack *extack)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 	int descs_num, ret;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 435668ee542d..9fb77b5e1316 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -491,9 +491,13 @@ int cpsw_get_eee(struct net_device *ndev, struct ethtool_eee *edata);
 int cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata);
 int cpsw_nway_reset(struct net_device *ndev);
 void cpsw_get_ringparam(struct net_device *ndev,
-			struct ethtool_ringparam *ering);
+			struct ethtool_ringparam *ering,
+			struct ethtool_ringparam_ext *ring_ext,
+			struct netlink_ext_ack *extack);
 int cpsw_set_ringparam(struct net_device *ndev,
-		       struct ethtool_ringparam *ering);
+		       struct ethtool_ringparam *ering,
+		       struct ethtool_ringparam_ext *ring_ext,
+		       struct netlink_ext_ack *extack);
 int cpsw_set_channels_common(struct net_device *ndev,
 			     struct ethtool_channels *chs,
 			     cpdma_handler_fn rx_handler);
diff --git a/drivers/net/ethernet/toshiba/spider_net_ethtool.c b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
index 54f655a68148..85cf022b15f1 100644
--- a/drivers/net/ethernet/toshiba/spider_net_ethtool.c
+++ b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
@@ -110,7 +110,9 @@ spider_net_ethtool_nway_reset(struct net_device *netdev)
 
 static void
 spider_net_ethtool_get_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ering)
+				 struct ethtool_ringparam *ering
+				 struct ethtool_ringparam_ext *ering_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct spider_net_card *card = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 463094ced104..bff1387b6076 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1276,8 +1276,11 @@ static const struct attribute_group temac_attr_group = {
  * ethtool support
  */
 
-static void ll_temac_ethtools_get_ringparam(struct net_device *ndev,
-					    struct ethtool_ringparam *ering)
+static void
+ll_temac_ethtools_get_ringparam(struct net_device *ndev,
+				struct ethtool_ringparam *ering,
+				struct ethtool_ringparam_ext *ering_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 
@@ -1291,8 +1294,11 @@ static void ll_temac_ethtools_get_ringparam(struct net_device *ndev,
 	ering->tx_pending = lp->tx_bd_num;
 }
 
-static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
-					   struct ethtool_ringparam *ering)
+static int
+ll_temac_ethtools_set_ringparam(struct net_device *ndev,
+				struct ethtool_ringparam *ering,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 871b5ec3183d..c682843139de 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1323,8 +1323,11 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 	data[39] = axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
 }
 
-static void axienet_ethtools_get_ringparam(struct net_device *ndev,
-					   struct ethtool_ringparam *ering)
+static void
+axienet_ethtools_get_ringparam(struct net_device *ndev,
+			       struct ethtool_ringparam *ering,
+			       struct ethtool_ringparam_ext *ering_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
 
@@ -1338,8 +1341,11 @@ static void axienet_ethtools_get_ringparam(struct net_device *ndev,
 	ering->tx_pending = lp->tx_bd_num;
 }
 
-static int axienet_ethtools_set_ringparam(struct net_device *ndev,
-					  struct ethtool_ringparam *ering)
+static int
+axienet_ethtools_set_ringparam(struct net_device *ndev,
+			       struct ethtool_ringparam *ering,
+			       struct ethtool_ringparam_ext *ering_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 382bebc2420d..1a68301a9444 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1857,7 +1857,9 @@ static void __netvsc_get_ringparam(struct netvsc_device *nvdev,
 }
 
 static void netvsc_get_ringparam(struct net_device *ndev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
@@ -1869,7 +1871,9 @@ static void netvsc_get_ringparam(struct net_device *ndev,
 }
 
 static int netvsc_set_ringparam(struct net_device *ndev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct ethtool_ringparam_ext *ring_ext,
+				struct netlink_ext_ack *extack)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 0ab6a40be611..a8e31aa19455 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -65,7 +65,9 @@ static int nsim_set_coalesce(struct net_device *dev,
 }
 
 static void nsim_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct ethtool_ringparam_ext *ring_ext,
+			       struct netlink_ext_ack *extack)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
@@ -73,7 +75,9 @@ static void nsim_get_ringparam(struct net_device *dev,
 }
 
 static int nsim_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct ethtool_ringparam_ext *ring_ext,
+			      struct netlink_ext_ack *extack)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 60ba9b734055..ee5f9456a1c6 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8969,7 +8969,9 @@ static int rtl8152_set_tunable(struct net_device *netdev,
 }
 
 static void rtl8152_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct ethtool_ringparam_ext *ring_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
@@ -8978,7 +8980,9 @@ static void rtl8152_get_ringparam(struct net_device *netdev,
 }
 
 static int rtl8152_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct ethtool_ringparam_ext *ring_ext,
+				 struct netlink_ext_ack *extack)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2ed49884565f..c4a0c7873a0c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2159,7 +2159,9 @@ static void virtnet_cpu_notif_remove(struct virtnet_info *vi)
 }
 
 static void virtnet_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct ethtool_ringparam_ext *ring_ext,
+				  struct netlink_ext_ack *extack)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 5dd8360b21a0..3b50e80dabb7 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -578,7 +578,9 @@ vmxnet3_get_link_ksettings(struct net_device *netdev,
 
 static void
 vmxnet3_get_ringparam(struct net_device *netdev,
-		      struct ethtool_ringparam *param)
+		      struct ethtool_ringparam *param,
+		      struct ethtool_ringparam_ext *param_ext,
+		      struct netlink_ext_ack *extack)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -598,7 +600,9 @@ vmxnet3_get_ringparam(struct net_device *netdev,
 
 static int
 vmxnet3_set_ringparam(struct net_device *netdev,
-		      struct ethtool_ringparam *param)
+		      struct ethtool_ringparam *param,
+		      struct ethtool_ringparam_ext *param_ext,
+		      struct netlink_ext_ack *extack)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	u32 new_tx_ring_size, new_rx_ring_size, new_rx_ring2_size;
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 46d0fe0d0e8a..33db7b51e086 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -144,7 +144,9 @@ static int qeth_set_coalesce(struct net_device *dev,
 }
 
 static void qeth_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct ethtool_ringparam_ext *param_ext,
+			       struct netlink_ext_ack *extack))
 {
 	struct qeth_card *card = dev->ml_priv;
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index a6600e361c34..63de9d67a08b 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1725,11 +1725,12 @@ static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 static int ethtool_get_ringparam(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_ringparam ringparam = { .cmd = ETHTOOL_GRINGPARAM };
+	struct ethtool_ringparam_ext ringparam_ext = {};
 
 	if (!dev->ethtool_ops->get_ringparam)
 		return -EOPNOTSUPP;
 
-	dev->ethtool_ops->get_ringparam(dev, &ringparam);
+	dev->ethtool_ops->get_ringparam(dev, &ringparam, &ringparam_ext, NULL);
 
 	if (copy_to_user(useraddr, &ringparam, sizeof(ringparam)))
 		return -EFAULT;
@@ -1739,6 +1740,7 @@ static int ethtool_get_ringparam(struct net_device *dev, void __user *useraddr)
 static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_ringparam ringparam, max = { .cmd = ETHTOOL_GRINGPARAM };
+	struct ethtool_ringparam_ext ringparam_ext;
 	int ret;
 
 	if (!dev->ethtool_ops->set_ringparam || !dev->ethtool_ops->get_ringparam)
@@ -1747,7 +1749,7 @@ static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(&ringparam, useraddr, sizeof(ringparam)))
 		return -EFAULT;
 
-	dev->ethtool_ops->get_ringparam(dev, &max);
+	dev->ethtool_ops->get_ringparam(dev, &max, &ringparam_ext, NULL);
 
 	/* ensure new ring parameters are within the maximums */
 	if (ringparam.rx_pending > max.rx_max_pending ||
@@ -1756,7 +1758,8 @@ static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 	    ringparam.tx_pending > max.tx_max_pending)
 		return -EINVAL;
 
-	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
+	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam, &ringparam_ext,
+					      NULL);
 	if (!ret)
 		ethtool_notify(dev, ETHTOOL_MSG_RINGS_NTF, NULL);
 	return ret;
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index dd645d1334be..4abaa7d7ce75 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -26,6 +26,7 @@ static int rings_prepare_data(const struct ethnl_req_info *req_base,
 			      struct genl_info *info)
 {
 	struct rings_reply_data *data = RINGS_REPDATA(reply_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -34,7 +35,8 @@ static int rings_prepare_data(const struct ethnl_req_info *req_base,
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
-	dev->ethtool_ops->get_ringparam(dev, &data->ringparam);
+	dev->ethtool_ops->get_ringparam(dev, &data->ringparam,
+					&data->ringparam_ext, extack);
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -59,6 +61,7 @@ static int rings_fill_reply(struct sk_buff *skb,
 			    const struct ethnl_reply_data *reply_base)
 {
 	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
+	const struct ethtool_ringparam_ext *ringparam_ext = &data->ringparam_ext;
 	const struct ethtool_ringparam *ringparam = &data->ringparam;
 
 	if ((ringparam->rx_max_pending &&
@@ -80,7 +83,10 @@ static int rings_fill_reply(struct sk_buff *skb,
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
 			  ringparam->tx_max_pending) ||
 	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
-			  ringparam->tx_pending))))
+			  ringparam->tx_pending)))  ||
+	    (ringparam_ext->rx_buf_len &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN,
+			  ringparam_ext->rx_buf_len))))
 		return -EMSGSIZE;
 
 	return 0;
@@ -138,7 +144,7 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
-	ops->get_ringparam(dev, &ringparam);
+	ops->get_ringparam(dev, &ringparam, &ringparam_ext, info->extack);
 
 	ethnl_update_u32(&ringparam.rx_pending, tb[ETHTOOL_A_RINGS_RX], &mod);
 	ethnl_update_u32(&ringparam.rx_mini_pending,
@@ -179,7 +185,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
+	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam, &ringparam_ext,
+					      info->extack);
 	if (ret < 0)
 		goto out_ops;
 	ethtool_notify(dev, ETHTOOL_MSG_RINGS_NTF, NULL);
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 99a2e30b3833..36d1ee384d38 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -14,7 +14,9 @@
 #include "driver-ops.h"
 
 static int ieee80211_set_ringparam(struct net_device *dev,
-				   struct ethtool_ringparam *rp)
+				   struct ethtool_ringparam *rp,
+				   struct ethtool_ringparam_ext *rp_ext,
+				   struct netlink_ext_ack *extack)
 {
 	struct ieee80211_local *local = wiphy_priv(dev->ieee80211_ptr->wiphy);
 
@@ -25,7 +27,9 @@ static int ieee80211_set_ringparam(struct net_device *dev,
 }
 
 static void ieee80211_get_ringparam(struct net_device *dev,
-				    struct ethtool_ringparam *rp)
+				    struct ethtool_ringparam *rp,
+				    struct ethtool_ringparam_ext *rp_ext,
+				    struct netlink_ext_ack *extack)
 {
 	struct ieee80211_local *local = wiphy_priv(dev->ieee80211_ptr->wiphy);
 
-- 
2.33.0

