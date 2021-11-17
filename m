Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A193453E24
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhKQCDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:03:16 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26320 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbhKQCDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 21:03:14 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hv5bq3zNkzbhyk;
        Wed, 17 Nov 2021 09:55:19 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:00:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 17 Nov 2021 10:00:01 +0800
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
Subject: [RESEND PATCH V6 net-next 4/6] ethtool: extend ringparam setting/getting API with rx_buf_len
Date:   Wed, 17 Nov 2021 09:55:24 +0800
Message-ID: <20211117015526.27593-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211117015526.27593-1-huangguangbin2@huawei.com>
References: <20211117015526.27593-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add two new parameters kernel_ringparam and extack for
.get_ringparam and .set_ringparam to extend more ring params
through netlink.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  4 ++-
 drivers/net/can/c_can/c_can_ethtool.c         |  4 ++-
 drivers/net/ethernet/3com/typhoon.c           |  4 ++-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  8 ++++--
 drivers/net/ethernet/amd/pcnet32.c            |  8 ++++--
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  | 11 +++++---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  8 ++++--
 drivers/net/ethernet/atheros/atlx/atl1.c      |  8 ++++--
 drivers/net/ethernet/broadcom/b44.c           |  8 ++++--
 drivers/net/ethernet/broadcom/bcm63xx_enet.c  | 25 +++++++++++++------
 drivers/net/ethernet/broadcom/bnx2.c          |  8 ++++--
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  8 ++++--
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  8 ++++--
 drivers/net/ethernet/broadcom/tg3.c           | 10 ++++++--
 .../net/ethernet/brocade/bna/bnad_ethtool.c   |  8 ++++--
 drivers/net/ethernet/cadence/macb_main.c      |  8 ++++--
 .../ethernet/cavium/liquidio/lio_ethtool.c    | 11 +++++---
 .../ethernet/cavium/thunder/nicvf_ethtool.c   |  8 ++++--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  8 ++++--
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  8 ++++--
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  8 ++++--
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  8 ++++--
 .../net/ethernet/cisco/enic/enic_ethtool.c    |  8 ++++--
 drivers/net/ethernet/cortina/gemini.c         |  8 ++++--
 .../net/ethernet/emulex/benet/be_ethtool.c    |  4 ++-
 drivers/net/ethernet/ethoc.c                  |  8 ++++--
 drivers/net/ethernet/faraday/ftgmac100.c      | 14 ++++++++---
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  4 ++-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  8 ++++--
 .../net/ethernet/freescale/ucc_geth_ethtool.c |  8 ++++--
 drivers/net/ethernet/google/gve/gve_ethtool.c |  4 ++-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  6 ++++-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  8 ++++--
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |  8 ++++--
 drivers/net/ethernet/ibm/emac/core.c          |  7 ++++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  8 ++++--
 drivers/net/ethernet/intel/e100.c             |  8 ++++--
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |  8 ++++--
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  8 ++++--
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |  8 ++++--
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  8 ++++--
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 12 +++++++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  8 ++++--
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  8 ++++--
 drivers/net/ethernet/intel/igbvf/ethtool.c    |  8 ++++--
 drivers/net/ethernet/intel/igc/igc_ethtool.c  | 14 ++++++++---
 .../net/ethernet/intel/ixgb/ixgb_ethtool.c    |  8 ++++--
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  8 ++++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  8 ++++--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  8 ++++--
 drivers/net/ethernet/marvell/mvneta.c         | 14 ++++++++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14 ++++++++---
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  8 ++++--
 drivers/net/ethernet/marvell/skge.c           |  8 ++++--
 drivers/net/ethernet/marvell/sky2.c           |  8 ++++--
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |  8 ++++--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  8 ++++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 14 ++++++++---
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  8 ++++--
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c  |  7 ++++--
 drivers/net/ethernet/micrel/ksz884x.c         |  6 ++++-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  4 ++-
 drivers/net/ethernet/neterion/s2io.c          |  7 ++++--
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  8 ++++--
 drivers/net/ethernet/nvidia/forcedeth.c       | 10 ++++++--
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        | 12 +++++++--
 .../net/ethernet/pasemi/pasemi_mac_ethtool.c  |  4 ++-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  8 ++++--
 .../qlogic/netxen/netxen_nic_ethtool.c        |  8 ++++--
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  8 ++++--
 .../ethernet/qlogic/qlcnic/qlcnic_ethtool.c   |  8 ++++--
 .../net/ethernet/qualcomm/emac/emac-ethtool.c |  8 ++++--
 drivers/net/ethernet/qualcomm/qca_debug.c     |  8 ++++--
 drivers/net/ethernet/realtek/8139cp.c         |  4 ++-
 drivers/net/ethernet/realtek/r8169_main.c     |  4 ++-
 drivers/net/ethernet/renesas/ravb_main.c      |  8 ++++--
 drivers/net/ethernet/renesas/sh_eth.c         |  8 ++++--
 drivers/net/ethernet/sfc/ef100_ethtool.c      |  7 ++++--
 drivers/net/ethernet/sfc/ethtool.c            | 14 ++++++++---
 drivers/net/ethernet/sfc/falcon/ethtool.c     | 14 ++++++++---
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  8 ++++--
 drivers/net/ethernet/tehuti/tehuti.c          | 12 +++++++--
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c   |  7 ++++--
 drivers/net/ethernet/ti/cpmac.c               |  8 ++++--
 drivers/net/ethernet/ti/cpsw_ethtool.c        |  8 ++++--
 drivers/net/ethernet/ti/cpsw_priv.h           |  8 ++++--
 .../net/ethernet/toshiba/spider_net_ethtool.c |  4 ++-
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 14 ++++++++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 14 ++++++++---
 drivers/net/hyperv/netvsc_drv.c               |  8 ++++--
 drivers/net/netdevsim/ethtool.c               |  8 ++++--
 drivers/net/usb/r8152.c                       |  8 ++++--
 drivers/net/virtio_net.c                      |  4 ++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 10 +++++---
 drivers/s390/net/qeth_ethtool.c               |  4 ++-
 include/linux/ethtool.h                       |  8 ++++--
 net/ethtool/ioctl.c                           | 10 +++++---
 net/ethtool/rings.c                           |  9 ++++---
 net/mac80211/ethtool.c                        |  8 ++++--
 99 files changed, 617 insertions(+), 212 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index cde6db184c26..4fc1a5d70dcf 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1441,7 +1441,9 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
 }
 
 static void vector_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct vector_private *vp = netdev_priv(netdev);
 
diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
index 377c7d2e7612..6655146294fc 100644
--- a/drivers/net/can/c_can/c_can_ethtool.c
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -20,7 +20,9 @@ static void c_can_get_drvinfo(struct net_device *netdev,
 }
 
 static void c_can_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct c_can_priv *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 05e15b6e5e2c..481f1df3106c 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -1138,7 +1138,9 @@ typhoon_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 }
 
 static void
-typhoon_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+typhoon_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering,
+		      struct kernel_ethtool_ringparam *kernel_ering,
+		      struct netlink_ext_ack *extack)
 {
 	ering->rx_max_pending = RXENT_ENTRIES;
 	ering->tx_max_pending = TXLO_ENTRIES - 1;
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 13e745cf3781..6b9b43e422c1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -465,7 +465,9 @@ static void ena_get_drvinfo(struct net_device *dev,
 }
 
 static void ena_get_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
@@ -476,7 +478,9 @@ static void ena_get_ringparam(struct net_device *netdev,
 }
 
 static int ena_set_ringparam(struct net_device *netdev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	u32 new_tx_size, new_rx_size;
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index f5c50ff377ff..c20c369c7eb8 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -860,7 +860,9 @@ static int pcnet32_nway_reset(struct net_device *dev)
 }
 
 static void pcnet32_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *ering)
+				  struct ethtool_ringparam *ering,
+				  struct kernel_ethtool_ringparam *kernel_ering,
+				  struct netlink_ext_ack *extack)
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
 
@@ -871,7 +873,9 @@ static void pcnet32_get_ringparam(struct net_device *dev,
 }
 
 static int pcnet32_set_ringparam(struct net_device *dev,
-				 struct ethtool_ringparam *ering)
+				 struct ethtool_ringparam *ering,
+				 struct kernel_ethtool_ringparam *kernel_ering,
+				 struct netlink_ext_ack *extack)
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
 	unsigned long flags;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 94879cf8b420..6ceb1cdf6eba 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -619,8 +619,11 @@ static int xgbe_get_module_eeprom(struct net_device *netdev,
 	return pdata->phy_if.module_eeprom(pdata, eeprom, data);
 }
 
-static void xgbe_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ringparam)
+static void
+xgbe_get_ringparam(struct net_device *netdev,
+		   struct ethtool_ringparam *ringparam,
+		   struct kernel_ethtool_ringparam *kernel_ringparam,
+		   struct netlink_ext_ack *extack)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 
@@ -631,7 +634,9 @@ static void xgbe_get_ringparam(struct net_device *netdev,
 }
 
 static int xgbe_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ringparam)
+			      struct ethtool_ringparam *ringparam,
+			      struct kernel_ethtool_ringparam *kernel_ringparam,
+			      struct netlink_ext_ack *extack)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	unsigned int rx, tx;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a9ef0544e30f..a418238f6309 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -812,7 +812,9 @@ static int aq_ethtool_set_pauseparam(struct net_device *ndev,
 }
 
 static void aq_get_ringparam(struct net_device *ndev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
@@ -827,7 +829,9 @@ static void aq_get_ringparam(struct net_device *ndev,
 }
 
 static int aq_set_ringparam(struct net_device *ndev,
-			    struct ethtool_ringparam *ring)
+			    struct ethtool_ringparam *ring,
+			    struct kernel_ethtool_ringparam *kernel_ring,
+			    struct netlink_ext_ack *extack)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	const struct aq_hw_caps_s *hw_caps;
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index b4c9e805e981..6a969969d221 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3438,7 +3438,9 @@ static void atl1_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
 }
 
 static void atl1_get_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	struct atl1_tpd_ring *txdr = &adapter->tpd_ring;
@@ -3451,7 +3453,9 @@ static void atl1_get_ringparam(struct net_device *netdev,
 }
 
 static int atl1_set_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	struct atl1_tpd_ring *tpdr = &adapter->tpd_ring;
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 969591bbc066..e5857e88c207 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1961,7 +1961,9 @@ static int b44_set_link_ksettings(struct net_device *dev,
 }
 
 static void b44_get_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct kernel_ethtool_ringparam *kernel_ering,
+			      struct netlink_ext_ack *extack)
 {
 	struct b44 *bp = netdev_priv(dev);
 
@@ -1972,7 +1974,9 @@ static void b44_get_ringparam(struct net_device *dev,
 }
 
 static int b44_set_ringparam(struct net_device *dev,
-			     struct ethtool_ringparam *ering)
+			     struct ethtool_ringparam *ering,
+			     struct kernel_ethtool_ringparam *kernel_ering,
+			     struct netlink_ext_ack *extack)
 {
 	struct b44 *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index a568994a03a6..b04e423c446a 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1497,8 +1497,11 @@ static int bcm_enet_set_link_ksettings(struct net_device *dev,
 	}
 }
 
-static void bcm_enet_get_ringparam(struct net_device *dev,
-				   struct ethtool_ringparam *ering)
+static void
+bcm_enet_get_ringparam(struct net_device *dev,
+		       struct ethtool_ringparam *ering,
+		       struct kernel_ethtool_ringparam *kernel_ering,
+		       struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 
@@ -1512,7 +1515,9 @@ static void bcm_enet_get_ringparam(struct net_device *dev,
 }
 
 static int bcm_enet_set_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *ering)
+				  struct ethtool_ringparam *ering,
+				  struct kernel_ethtool_ringparam *kernel_ering,
+				  struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 	int was_running;
@@ -2579,8 +2584,11 @@ static void bcm_enetsw_get_ethtool_stats(struct net_device *netdev,
 	}
 }
 
-static void bcm_enetsw_get_ringparam(struct net_device *dev,
-				     struct ethtool_ringparam *ering)
+static void
+bcm_enetsw_get_ringparam(struct net_device *dev,
+			 struct ethtool_ringparam *ering,
+			 struct kernel_ethtool_ringparam *kernel_ering,
+			 struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 
@@ -2595,8 +2603,11 @@ static void bcm_enetsw_get_ringparam(struct net_device *dev,
 	ering->tx_pending = priv->tx_ring_size;
 }
 
-static int bcm_enetsw_set_ringparam(struct net_device *dev,
-				    struct ethtool_ringparam *ering)
+static int
+bcm_enetsw_set_ringparam(struct net_device *dev,
+			 struct ethtool_ringparam *ering,
+			 struct kernel_ethtool_ringparam *kernel_ering,
+			 struct netlink_ext_ack *extack)
 {
 	struct bcm_enet_priv *priv;
 	int was_running;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index babc955ba64e..e20aafeb4ca9 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7318,7 +7318,9 @@ static int bnx2_set_coalesce(struct net_device *dev,
 }
 
 static void
-bnx2_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+bnx2_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering,
+		   struct kernel_ethtool_ringparam *kernel_ering,
+		   struct netlink_ext_ack *extack)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
@@ -7389,7 +7391,9 @@ bnx2_change_ring_size(struct bnx2 *bp, u32 rx, u32 tx, bool reset_irq)
 }
 
 static int
-bnx2_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+bnx2_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ering,
+		   struct kernel_ethtool_ringparam *kernel_ering,
+		   struct netlink_ext_ack *extack)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 	int rc;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 472a3a478038..0e319ac7799f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1914,7 +1914,9 @@ static int bnx2x_set_coalesce(struct net_device *dev,
 }
 
 static void bnx2x_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ering)
+				struct ethtool_ringparam *ering,
+				struct kernel_ethtool_ringparam *kernel_ering,
+				struct netlink_ext_ack *extack)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
@@ -1938,7 +1940,9 @@ static void bnx2x_get_ringparam(struct net_device *dev,
 }
 
 static int bnx2x_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct kernel_ethtool_ringparam *kernel_ering,
+			       struct netlink_ext_ack *extack)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 8188d55722e4..15253396096a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -775,7 +775,9 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 }
 
 static void bnxt_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct kernel_ethtool_ringparam *kernel_ering,
+			       struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
@@ -794,7 +796,9 @@ static void bnxt_get_ringparam(struct net_device *dev,
 }
 
 static int bnxt_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct kernel_ethtool_ringparam *kernel_ering,
+			      struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 85ca3909859d..283f3c1f1195 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12390,7 +12390,10 @@ static int tg3_nway_reset(struct net_device *dev)
 	return r;
 }
 
-static void tg3_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+static void tg3_get_ringparam(struct net_device *dev,
+			      struct ethtool_ringparam *ering,
+			      struct kernel_ethtool_ringparam *kernel_ering,
+			      struct netlink_ext_ack *extack)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
@@ -12411,7 +12414,10 @@ static void tg3_get_ringparam(struct net_device *dev, struct ethtool_ringparam *
 	ering->tx_pending = tp->napi[0].tx_pending;
 }
 
-static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ering)
+static int tg3_set_ringparam(struct net_device *dev,
+			     struct ethtool_ringparam *ering,
+			     struct kernel_ethtool_ringparam *kernel_ering,
+			     struct netlink_ext_ack *extack)
 {
 	struct tg3 *tp = netdev_priv(dev);
 	int i, irq_sync = 0, err = 0;
diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 391b85f25141..4b4ad731897f 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -405,7 +405,9 @@ static int bnad_set_coalesce(struct net_device *netdev,
 
 static void
 bnad_get_ringparam(struct net_device *netdev,
-		   struct ethtool_ringparam *ringparam)
+		   struct ethtool_ringparam *ringparam,
+		   struct kernel_ethtool_ringparam *kernel_ringparam,
+		   struct netlink_ext_ack *extack)
 {
 	struct bnad *bnad = netdev_priv(netdev);
 
@@ -418,7 +420,9 @@ bnad_get_ringparam(struct net_device *netdev,
 
 static int
 bnad_set_ringparam(struct net_device *netdev,
-		   struct ethtool_ringparam *ringparam)
+		   struct ethtool_ringparam *ringparam,
+		   struct kernel_ethtool_ringparam *kernel_ringparam,
+		   struct netlink_ext_ack *extack)
 {
 	int i, current_err, err = 0;
 	struct bnad *bnad = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 57c5f48d19a4..7b68f5a1720c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3135,7 +3135,9 @@ static int macb_set_link_ksettings(struct net_device *netdev,
 }
 
 static void macb_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct macb *bp = netdev_priv(netdev);
 
@@ -3147,7 +3149,9 @@ static void macb_get_ringparam(struct net_device *netdev,
 }
 
 static int macb_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct macb *bp = netdev_priv(netdev);
 	u32 new_rx_size, new_tx_size;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index 2b9747867d4c..2c10ae3f7fc1 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -947,7 +947,9 @@ static int lio_set_phys_id(struct net_device *netdev,
 
 static void
 lio_ethtool_get_ringparam(struct net_device *netdev,
-			  struct ethtool_ringparam *ering)
+			  struct ethtool_ringparam *ering,
+			  struct kernel_ethtool_ringparam *kernel_ering,
+			  struct netlink_ext_ack *extack)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
@@ -1252,8 +1254,11 @@ static int lio_reset_queues(struct net_device *netdev, uint32_t num_qs)
 	return 0;
 }
 
-static int lio_ethtool_set_ringparam(struct net_device *netdev,
-				     struct ethtool_ringparam *ering)
+static int
+lio_ethtool_set_ringparam(struct net_device *netdev,
+			  struct ethtool_ringparam *ering,
+			  struct kernel_ethtool_ringparam *kernel_ering,
+			  struct netlink_ext_ack *extack)
 {
 	u32 rx_count, tx_count, rx_count_old, tx_count_old;
 	struct lio *lio = GET_LIO(netdev);
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index 7f2882109b16..5a9fad61e9ea 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -467,7 +467,9 @@ static int nicvf_get_coalesce(struct net_device *netdev,
 }
 
 static void nicvf_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 	struct queue_set *qs = nic->qs;
@@ -479,7 +481,9 @@ static void nicvf_get_ringparam(struct net_device *netdev,
 }
 
 static int nicvf_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 	struct queue_set *qs = nic->qs;
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 609820e214a3..18acd7cf3d6d 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -710,7 +710,9 @@ static int set_pauseparam(struct net_device *dev,
 	return 0;
 }
 
-static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			  struct kernel_ethtool_ringparam *kernel_e,
+			  struct netlink_ext_ack *extack)
 {
 	struct adapter *adapter = dev->ml_priv;
 	int jumbo_fl = t1_is_T1B(adapter) ? 1 : 0;
@@ -724,7 +726,9 @@ static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	e->tx_pending = adapter->params.sge.cmdQ_size[0];
 }
 
-static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			 struct kernel_ethtool_ringparam *kernel_e,
+			 struct netlink_ext_ack *extack)
 {
 	struct adapter *adapter = dev->ml_priv;
 	int jumbo_fl = t1_is_T1B(adapter) ? 1 : 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index bfffcaeee624..e2637bd2f423 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1948,7 +1948,9 @@ static int set_pauseparam(struct net_device *dev,
 	return 0;
 }
 
-static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			  struct kernel_ethtool_ringparam *kernel_e,
+			  struct netlink_ext_ack *extack)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
@@ -1964,7 +1966,9 @@ static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	e->tx_pending = q->txq_size[0];
 }
 
-static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			 struct kernel_ethtool_ringparam *kernel_e,
+			 struct netlink_ext_ack *extack)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 129352bbe114..0e4ec4079741 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -890,7 +890,9 @@ static int set_pauseparam(struct net_device *dev,
 	return 0;
 }
 
-static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			  struct kernel_ethtool_ringparam *kernel_e,
+			  struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	const struct sge *s = &pi->adapter->sge;
@@ -906,7 +908,9 @@ static void get_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	e->tx_pending = s->ethtxq[pi->first_qset].q.size;
 }
 
-static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
+static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e,
+			 struct kernel_ethtool_ringparam *kernel_e,
+			 struct netlink_ext_ack *extack)
 {
 	int i;
 	const struct port_info *pi = netdev_priv(dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 64479c464b4e..61808c2c26a6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1591,7 +1591,9 @@ static void cxgb4vf_set_msglevel(struct net_device *dev, u32 msglevel)
  * first Queue Set.
  */
 static void cxgb4vf_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *rp)
+				  struct ethtool_ringparam *rp,
+				  struct kernel_ethtool_ringparam *kernel_rp,
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
+				 struct kernel_ethtool_ringparam *kernel_rp,
+				 struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 6ded4d9fa32a..6c11f9d62526 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -177,7 +177,9 @@ static void enic_get_strings(struct net_device *netdev, u32 stringset,
 }
 
 static void enic_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct enic *enic = netdev_priv(netdev);
 	struct vnic_enet_config *c = &enic->config;
@@ -189,7 +191,9 @@ static void enic_get_ringparam(struct net_device *netdev,
 }
 
 static int enic_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct enic *enic = netdev_priv(netdev);
 	struct vnic_enet_config *c = &enic->config;
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 941f175fb911..07add311f65d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2105,7 +2105,9 @@ static void gmac_get_pauseparam(struct net_device *netdev,
 }
 
 static void gmac_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *rp)
+			       struct ethtool_ringparam *rp,
+			       struct kernel_ethtool_ringparam *kernel_rp,
+			       struct netlink_ext_ack *extack)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 
@@ -2123,7 +2125,9 @@ static void gmac_get_ringparam(struct net_device *netdev,
 }
 
 static int gmac_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *rp)
+			      struct ethtool_ringparam *rp,
+			      struct kernel_ethtool_ringparam *kernel_rp,
+			      struct netlink_ext_ack *extack)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 	int err = 0;
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index f9955308b93d..dfa784339781 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -683,7 +683,9 @@ static int be_get_link_ksettings(struct net_device *netdev,
 }
 
 static void be_get_ringparam(struct net_device *netdev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index b1c8ffea6ad2..d618a8b785b0 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -945,7 +945,9 @@ static void ethoc_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 }
 
 static void ethoc_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct ethoc *priv = netdev_priv(dev);
 
@@ -961,7 +963,9 @@ static void ethoc_get_ringparam(struct net_device *dev,
 }
 
 static int ethoc_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct ethoc *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 97c5d70de76e..691605c15265 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1178,8 +1178,11 @@ static void ftgmac100_get_drvinfo(struct net_device *netdev,
 	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
 }
 
-static void ftgmac100_get_ringparam(struct net_device *netdev,
-				    struct ethtool_ringparam *ering)
+static void
+ftgmac100_get_ringparam(struct net_device *netdev,
+			struct ethtool_ringparam *ering,
+			struct kernel_ethtool_ringparam *kernel_ering,
+			struct netlink_ext_ack *extack)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 
@@ -1190,8 +1193,11 @@ static void ftgmac100_get_ringparam(struct net_device *netdev,
 	ering->tx_pending = priv->tx_q_entries;
 }
 
-static int ftgmac100_set_ringparam(struct net_device *netdev,
-				   struct ethtool_ringparam *ering)
+static int
+ftgmac100_set_ringparam(struct net_device *netdev,
+			struct ethtool_ringparam *ering,
+			struct kernel_ethtool_ringparam *kernel_ering,
+			struct netlink_ext_ack *extack)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 910b9f722504..fa5b4f885b17 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -562,7 +562,9 @@ static int enetc_set_rxfh(struct net_device *ndev, const u32 *indir,
 }
 
 static void enetc_get_ringparam(struct net_device *ndev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 7b32ed29bf4c..ff756265d58f 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -372,7 +372,9 @@ static int gfar_scoalesce(struct net_device *dev,
  * rx, rx_mini, and rx_jumbo rings are the same size, as mini and
  * jumbo are ignored by the driver */
 static void gfar_gringparam(struct net_device *dev,
-			    struct ethtool_ringparam *rvals)
+			    struct ethtool_ringparam *rvals,
+			    struct kernel_ethtool_ringparam *kernel_rvals,
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
+			   struct kernel_ethtool_ringparam *kernel_rvals,
+			   struct netlink_ext_ack *extack)
 {
 	struct gfar_private *priv = netdev_priv(dev);
 	int err = 0, i;
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index 14c08a868190..69b2b98b1525 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -207,7 +207,9 @@ uec_get_regs(struct net_device *netdev,
 
 static void
 uec_get_ringparam(struct net_device *netdev,
-                    struct ethtool_ringparam *ring)
+		  struct ethtool_ringparam *ring,
+		  struct kernel_ethtool_ringparam *kernel_ring,
+		  struct netlink_ext_ack *extack)
 {
 	struct ucc_geth_private *ugeth = netdev_priv(netdev);
 	struct ucc_geth_info *ug_info = ugeth->ug_info;
@@ -226,7 +228,9 @@ uec_get_ringparam(struct net_device *netdev,
 
 static int
 uec_set_ringparam(struct net_device *netdev,
-                    struct ethtool_ringparam *ring)
+		  struct ethtool_ringparam *ring,
+		  struct kernel_ethtool_ringparam *kernel_ring,
+		  struct netlink_ext_ack *extack)
 {
 	struct ucc_geth_private *ugeth = netdev_priv(netdev);
 	struct ucc_geth_info *ug_info = ugeth->ug_info;
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index c8df47a97fa4..fd2d2c705391 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -419,7 +419,9 @@ static int gve_set_channels(struct net_device *netdev,
 }
 
 static void gve_get_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *cmd)
+			      struct ethtool_ringparam *cmd,
+			      struct kernel_ethtool_ringparam *kernel_cmd,
+			      struct netlink_ext_ack *extack)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index ab7390225942..d7a27c244d48 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -663,9 +663,13 @@ static void hns_nic_get_drvinfo(struct net_device *net_dev,
  * hns_get_ringparam - get ring parameter
  * @net_dev: net device
  * @param: ethtool parameter
+ * @kernel_param: ethtool external parameter
+ * @extack: netlink extended ACK report struct
  */
 static void hns_get_ringparam(struct net_device *net_dev,
-			      struct ethtool_ringparam *param)
+			      struct ethtool_ringparam *param,
+			      struct kernel_ethtool_ringparam *kernel_param,
+			      struct netlink_ext_ack *extack)
 {
 	struct hns_nic_priv *priv = netdev_priv(net_dev);
 	struct hnae_ae_ops *ops;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 9a816dbec613..e35a2661b45d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -643,7 +643,9 @@ static u32 hns3_get_link(struct net_device *netdev)
 }
 
 static void hns3_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct kernel_ethtool_ringparam *kernel_param,
+			       struct netlink_ext_ack *extack)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
@@ -1081,7 +1083,9 @@ static int hns3_check_ringparam(struct net_device *ndev,
 }
 
 static int hns3_set_ringparam(struct net_device *ndev,
-			      struct ethtool_ringparam *param)
+			      struct ethtool_ringparam *param,
+			      struct kernel_ethtool_ringparam *kernel_param,
+			      struct netlink_ext_ack *extack)
 {
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	struct hnae3_handle *h = priv->ae_handle;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index a35a80f9a234..93192f58ac88 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -547,7 +547,9 @@ static void hinic_get_drvinfo(struct net_device *netdev,
 }
 
 static void hinic_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
@@ -580,7 +582,9 @@ static int check_ringparam_valid(struct hinic_dev *nic_dev,
 }
 
 static int hinic_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	u16 new_sq_depth, new_rq_depth;
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 6b3fc8823c54..fbea9f7efe8c 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2137,8 +2137,11 @@ emac_ethtool_set_link_ksettings(struct net_device *ndev,
 	return 0;
 }
 
-static void emac_ethtool_get_ringparam(struct net_device *ndev,
-				       struct ethtool_ringparam *rp)
+static void
+emac_ethtool_get_ringparam(struct net_device *ndev,
+			   struct ethtool_ringparam *rp,
+			   struct kernel_ethtool_ringparam *kernel_rp,
+			   struct netlink_ext_ack *extack)
 {
 	rp->rx_max_pending = rp->rx_pending = NUM_RX_BUFF;
 	rp->tx_max_pending = rp->tx_pending = NUM_TX_BUFF;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3cca51735421..02bf5d65ad1e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3088,7 +3088,9 @@ static u32 ibmvnic_get_link(struct net_device *netdev)
 }
 
 static void ibmvnic_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
@@ -3108,7 +3110,9 @@ static void ibmvnic_get_ringparam(struct net_device *netdev,
 }
 
 static int ibmvnic_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int ret;
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 5039a2536951..0411cb59a48e 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2557,7 +2557,9 @@ static int e100_set_eeprom(struct net_device *netdev,
 }
 
 static void e100_get_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct nic *nic = netdev_priv(netdev);
 	struct param_range *rfds = &nic->params.rfds;
@@ -2570,7 +2572,9 @@ static void e100_get_ringparam(struct net_device *netdev,
 }
 
 static int e100_set_ringparam(struct net_device *netdev,
-	struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct nic *nic = netdev_priv(netdev);
 	struct param_range *rfds = &nic->params.rfds;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 0a57172dfcbc..32803b0cf1e8 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -539,7 +539,9 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 }
 
 static void e1000_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
@@ -556,7 +558,9 @@ static void e1000_get_ringparam(struct net_device *netdev,
 }
 
 static int e1000_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 8515e00d1b40..b80ae9a82224 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -655,7 +655,9 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 }
 
 static void e1000_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -666,7 +668,9 @@ static void e1000_get_ringparam(struct net_device *netdev,
 }
 
 static int e1000_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_ring *temp_tx = NULL, *temp_rx = NULL;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 0d37f011d0ce..d53369e30040 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -502,7 +502,9 @@ static void fm10k_set_msglevel(struct net_device *netdev, u32 data)
 }
 
 static void fm10k_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct fm10k_intfc *interface = netdev_priv(netdev);
 
@@ -517,7 +519,9 @@ static void fm10k_get_ringparam(struct net_device *netdev,
 }
 
 static int fm10k_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct fm10k_intfc *interface = netdev_priv(netdev);
 	struct fm10k_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 513ba6974355..091f36adbbe1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1916,7 +1916,9 @@ static void i40e_get_drvinfo(struct net_device *netdev,
 }
 
 static void i40e_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_pf *pf = np->vsi->back;
@@ -1944,7 +1946,9 @@ static bool i40e_active_tx_ring_index(struct i40e_vsi *vsi, u16 index)
 }
 
 static int i40e_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct i40e_ring *tx_rings = NULL, *rx_rings = NULL;
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 5a359a0a20ec..d2ac5488c627 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -580,12 +580,16 @@ static void iavf_get_drvinfo(struct net_device *netdev,
  * iavf_get_ringparam - Get ring parameters
  * @netdev: network interface device structure
  * @ring: ethtool ringparam structure
+ * @kernel_ring: ethtool extenal ringparam structure
+ * @extack: netlink extended ACK report struct
  *
  * Returns current ring parameters. TX and RX rings are reported separately,
  * but the number of rings is not reported.
  **/
 static void iavf_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
@@ -599,12 +603,16 @@ static void iavf_get_ringparam(struct net_device *netdev,
  * iavf_set_ringparam - Set ring parameters
  * @netdev: network interface device structure
  * @ring: ethtool ringparam structure
+ * @kernel_ring: ethtool external ringparam structure
+ * @extack: netlink extended ACK report struct
  *
  * Sets ring parameters. TX and RX rings are controlled separately, but the
  * number of rings is not specified, so all rings get the same settings.
  **/
 static int iavf_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	u32 new_rx_count, new_tx_count;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 572519e402f4..5af2faaa21e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2686,7 +2686,9 @@ ice_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 }
 
 static void
-ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct kernel_ethtool_ringparam *kernel_ring,
+		  struct netlink_ext_ack *extack)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -2704,7 +2706,9 @@ ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 }
 
 static int
-ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct kernel_ethtool_ringparam *kernel_ring,
+		  struct netlink_ext_ack *extack)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_tx_ring *xdp_rings = NULL;
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index fb1029352c3e..51a2dcaf553d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -864,7 +864,9 @@ static void igb_get_drvinfo(struct net_device *netdev,
 }
 
 static void igb_get_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
@@ -875,7 +877,9 @@ static void igb_get_ringparam(struct net_device *netdev,
 }
 
 static int igb_set_ringparam(struct net_device *netdev,
-			     struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct igb_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index 06e5bd646a0e..9d4322b74163 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -175,7 +175,9 @@ static void igbvf_get_drvinfo(struct net_device *netdev,
 }
 
 static void igbvf_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	struct igbvf_ring *tx_ring = adapter->tx_ring;
@@ -188,7 +190,9 @@ static void igbvf_get_ringparam(struct net_device *netdev,
 }
 
 static int igbvf_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	struct igbvf_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index e0a76ac1bbbc..8cc077b712ad 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -567,8 +567,11 @@ static int igc_ethtool_set_eeprom(struct net_device *netdev,
 	return ret_val;
 }
 
-static void igc_ethtool_get_ringparam(struct net_device *netdev,
-				      struct ethtool_ringparam *ring)
+static void
+igc_ethtool_get_ringparam(struct net_device *netdev,
+			  struct ethtool_ringparam *ring,
+			  struct kernel_ethtool_ringparam *kernel_ering,
+			  struct netlink_ext_ack *extack)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
@@ -578,8 +581,11 @@ static void igc_ethtool_get_ringparam(struct net_device *netdev,
 	ring->tx_pending = adapter->tx_ring_count;
 }
 
-static int igc_ethtool_set_ringparam(struct net_device *netdev,
-				     struct ethtool_ringparam *ring)
+static int
+igc_ethtool_set_ringparam(struct net_device *netdev,
+			  struct ethtool_ringparam *ring,
+			  struct kernel_ethtool_ringparam *kernel_ering,
+			  struct netlink_ext_ack *extack)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	struct igc_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
index 582099a5ad41..46efcfab7234 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
@@ -464,7 +464,9 @@ ixgb_get_drvinfo(struct net_device *netdev,
 
 static void
 ixgb_get_ringparam(struct net_device *netdev,
-		struct ethtool_ringparam *ring)
+		   struct ethtool_ringparam *ring,
+		   struct kernel_ethtool_ringparam *kernel_ring,
+		   struct netlink_ext_ack *extack)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	struct ixgb_desc_ring *txdr = &adapter->tx_ring;
@@ -478,7 +480,9 @@ ixgb_get_ringparam(struct net_device *netdev,
 
 static int
 ixgb_set_ringparam(struct net_device *netdev,
-		struct ethtool_ringparam *ring)
+		   struct ethtool_ringparam *ring,
+		   struct kernel_ethtool_ringparam *kernel_ring,
+		   struct netlink_ext_ack *extack)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	struct ixgb_desc_ring *txdr = &adapter->tx_ring;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 8362822316a9..f70967c32116 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1118,7 +1118,9 @@ static void ixgbe_get_drvinfo(struct net_device *netdev,
 }
 
 static void ixgbe_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_ring *tx_ring = adapter->tx_ring[0];
@@ -1131,7 +1133,9 @@ static void ixgbe_get_ringparam(struct net_device *netdev,
 }
 
 static int ixgbe_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_ring *temp_ring;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 8380f905e708..3b41f83c8dff 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -225,7 +225,9 @@ static void ixgbevf_get_drvinfo(struct net_device *netdev,
 }
 
 static void ixgbevf_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
@@ -236,7 +238,9 @@ static void ixgbevf_get_ringparam(struct net_device *netdev,
 }
 
 static int ixgbevf_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 	struct ixgbevf_ring *tx_ring = NULL, *rx_ring = NULL;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index bb14fa2241a3..116919730237 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1638,7 +1638,9 @@ static int mv643xx_eth_set_coalesce(struct net_device *dev,
 }
 
 static void
-mv643xx_eth_get_ringparam(struct net_device *dev, struct ethtool_ringparam *er)
+mv643xx_eth_get_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
+			  struct kernel_ethtool_ringparam *kernel_er,
+			  struct netlink_ext_ack *extack)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
@@ -1650,7 +1652,9 @@ mv643xx_eth_get_ringparam(struct net_device *dev, struct ethtool_ringparam *er)
 }
 
 static int
-mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er)
+mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
+			  struct kernel_ethtool_ringparam *kernel_er,
+			  struct netlink_ext_ack *extack)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 67a644177880..350d24d7ead0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4510,8 +4510,11 @@ static void mvneta_ethtool_get_drvinfo(struct net_device *dev,
 }
 
 
-static void mvneta_ethtool_get_ringparam(struct net_device *netdev,
-					 struct ethtool_ringparam *ring)
+static void
+mvneta_ethtool_get_ringparam(struct net_device *netdev,
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	struct mvneta_port *pp = netdev_priv(netdev);
 
@@ -4521,8 +4524,11 @@ static void mvneta_ethtool_get_ringparam(struct net_device *netdev,
 	ring->tx_pending = pp->tx_ring_size;
 }
 
-static int mvneta_ethtool_set_ringparam(struct net_device *dev,
-					struct ethtool_ringparam *ring)
+static int
+mvneta_ethtool_set_ringparam(struct net_device *dev,
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index df6c793f4b1b..8b1ca0b13e88 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5431,8 +5431,11 @@ static void mvpp2_ethtool_get_drvinfo(struct net_device *dev,
 		sizeof(drvinfo->bus_info));
 }
 
-static void mvpp2_ethtool_get_ringparam(struct net_device *dev,
-					struct ethtool_ringparam *ring)
+static void
+mvpp2_ethtool_get_ringparam(struct net_device *dev,
+			    struct ethtool_ringparam *ring,
+			    struct kernel_ethtool_ringparam *kernel_ring,
+			    struct netlink_ext_ack *extack)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 
@@ -5442,8 +5445,11 @@ static void mvpp2_ethtool_get_ringparam(struct net_device *dev,
 	ring->tx_pending = port->tx_ring_size;
 }
 
-static int mvpp2_ethtool_set_ringparam(struct net_device *dev,
-				       struct ethtool_ringparam *ring)
+static int
+mvpp2_ethtool_set_ringparam(struct net_device *dev,
+			    struct ethtool_ringparam *ring,
+			    struct kernel_ethtool_ringparam *kernel_ring,
+			    struct netlink_ext_ack *extack)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	u16 prev_rx_ring_size = port->rx_ring_size;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 80d4ce61f442..d85db90632d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -360,7 +360,9 @@ static int otx2_set_pauseparam(struct net_device *netdev,
 }
 
 static void otx2_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_qset *qs = &pfvf->qset;
@@ -372,7 +374,9 @@ static void otx2_get_ringparam(struct net_device *netdev,
 }
 
 static int otx2_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	bool if_up = netif_running(netdev);
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 0c864e5bf0a6..cf03c67fbf40 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -492,7 +492,9 @@ static void skge_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 }
 
 static void skge_get_ring_param(struct net_device *dev,
-				struct ethtool_ringparam *p)
+				struct ethtool_ringparam *p,
+				struct kernel_ethtool_ringparam *kernel_p,
+				struct netlink_ext_ack *extack)
 {
 	struct skge_port *skge = netdev_priv(dev);
 
@@ -504,7 +506,9 @@ static void skge_get_ring_param(struct net_device *dev,
 }
 
 static int skge_set_ring_param(struct net_device *dev,
-			       struct ethtool_ringparam *p)
+			       struct ethtool_ringparam *p,
+			       struct kernel_ethtool_ringparam *kernel_p,
+			       struct netlink_ext_ack *extack)
 {
 	struct skge_port *skge = netdev_priv(dev);
 	int err = 0;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 28b5b9341145..1d3a5aff3d0a 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4149,7 +4149,9 @@ static unsigned long roundup_ring_size(unsigned long pending)
 }
 
 static void sky2_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct kernel_ethtool_ringparam *kernel_ering,
+			       struct netlink_ext_ack *extack)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 
@@ -4161,7 +4163,9 @@ static void sky2_get_ringparam(struct net_device *dev,
 }
 
 static int sky2_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct kernel_ethtool_ringparam *kernel_ering,
+			      struct netlink_ext_ack *extack)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 066d79e4ecfc..e97d97e94231 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1141,7 +1141,9 @@ static void mlx4_en_get_pauseparam(struct net_device *dev,
 }
 
 static int mlx4_en_set_ringparam(struct net_device *dev,
-				 struct ethtool_ringparam *param)
+				 struct ethtool_ringparam *param,
+				 struct kernel_ethtool_ringparam *kernel_param,
+				 struct netlink_ext_ack *extack)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
@@ -1208,7 +1210,9 @@ static int mlx4_en_set_ringparam(struct net_device *dev,
 }
 
 static void mlx4_en_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *param)
+				  struct ethtool_ringparam *param,
+				  struct kernel_ethtool_ringparam *kernel_param,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c2ea5fad48dd..b5089935bea8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -314,7 +314,9 @@ void mlx5e_ethtool_get_ringparam(struct mlx5e_priv *priv,
 }
 
 static void mlx5e_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *param)
+				struct ethtool_ringparam *param,
+				struct kernel_ethtool_ringparam *kernel_param,
+				struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
@@ -380,7 +382,9 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 }
 
 static int mlx5e_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct kernel_ethtool_ringparam *kernel_param,
+			       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e58a9ec42553..65dcd45df56b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -219,16 +219,22 @@ static int mlx5e_rep_get_sset_count(struct net_device *dev, int sset)
 	}
 }
 
-static void mlx5e_rep_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *param)
+static void
+mlx5e_rep_get_ringparam(struct net_device *dev,
+			struct ethtool_ringparam *param,
+			struct kernel_ethtool_ringparam *kernel_param,
+			struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
 	mlx5e_ethtool_get_ringparam(priv, param);
 }
 
-static int mlx5e_rep_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+static int
+mlx5e_rep_set_ringparam(struct net_device *dev,
+			struct ethtool_ringparam *param,
+			struct kernel_ethtool_ringparam *kernel_param,
+			struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 962d41418ce7..c1369c36db21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -67,7 +67,9 @@ static void mlx5i_get_ethtool_stats(struct net_device *dev,
 }
 
 static int mlx5i_set_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct kernel_ethtool_ringparam *kernel_param,
+			       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
@@ -75,7 +77,9 @@ static int mlx5i_set_ringparam(struct net_device *dev,
 }
 
 static void mlx5i_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *param)
+				struct ethtool_ringparam *param,
+				struct kernel_ethtool_ringparam *kernel_param,
+				struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
index 92b798f8e73a..ceeb7f4c3f6c 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
@@ -33,8 +33,11 @@ static void mlxbf_gige_get_regs(struct net_device *netdev,
 	memcpy_fromio(p, priv->base, MLXBF_GIGE_MMIO_REG_SZ);
 }
 
-static void mlxbf_gige_get_ringparam(struct net_device *netdev,
-				     struct ethtool_ringparam *ering)
+static void
+mlxbf_gige_get_ringparam(struct net_device *netdev,
+			 struct ethtool_ringparam *ering,
+			 struct kernel_ethtool_ringparam *kernel_ering,
+			 struct netlink_ext_ack *extack)
 {
 	struct mlxbf_gige *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 99c0c1491af2..d024983815da 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6317,11 +6317,15 @@ static int netdev_set_pauseparam(struct net_device *dev,
  * netdev_get_ringparam - get tx/rx ring parameters
  * @dev:	Network device.
  * @ring:	Ethtool RING settings data structure.
+ * @kernel_ring:	Ethtool external RING settings data structure.
+ * @extack:	Netlink handle.
  *
  * This procedure returns the TX/RX ring settings.
  */
 static void netdev_get_ringparam(struct net_device *dev,
-	struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct dev_priv *priv = netdev_priv(dev);
 	struct dev_info *hw_priv = priv->adapter;
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 5736fcdafd7a..83a5e29c836a 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1704,7 +1704,9 @@ myri10ge_set_pauseparam(struct net_device *netdev,
 
 static void
 myri10ge_get_ringparam(struct net_device *netdev,
-		       struct ethtool_ringparam *ring)
+		       struct ethtool_ringparam *ring,
+		       struct kernel_ethtool_ringparam *kernel_ring,
+		       struct netlink_ext_ack *extack)
 {
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index d1c32c65db05..d6ae44f164a9 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -5461,8 +5461,11 @@ static int s2io_ethtool_set_led(struct net_device *dev,
 	return 0;
 }
 
-static void s2io_ethtool_gringparam(struct net_device *dev,
-				    struct ethtool_ringparam *ering)
+static void
+s2io_ethtool_gringparam(struct net_device *dev,
+			struct ethtool_ringparam *ering,
+			struct kernel_ethtool_ringparam *kernel_ering,
+			struct netlink_ext_ack *extack)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
 	int i, tx_desc_count = 0, rx_desc_count = 0;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1de076f55740..93fa8e677e05 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -381,7 +381,9 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
 }
 
 static void nfp_net_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 
@@ -406,7 +408,9 @@ static int nfp_net_set_ring_size(struct nfp_net *nn, u32 rxd_cnt, u32 txd_cnt)
 }
 
 static int nfp_net_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	u32 rxd_cnt, txd_cnt;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 9b530d7509a4..660013f716d4 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4651,7 +4651,10 @@ static int nv_nway_reset(struct net_device *dev)
 	return ret;
 }
 
-static void nv_get_ringparam(struct net_device *dev, struct ethtool_ringparam* ring)
+static void nv_get_ringparam(struct net_device *dev,
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	struct fe_priv *np = netdev_priv(dev);
 
@@ -4662,7 +4665,10 @@ static void nv_get_ringparam(struct net_device *dev, struct ethtool_ringparam* r
 	ring->tx_pending = np->tx_ring_size;
 }
 
-static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ring)
+static int nv_set_ringparam(struct net_device *dev,
+			    struct ethtool_ringparam *ring,
+			    struct kernel_ethtool_ringparam *kernel_ring,
+			    struct netlink_ext_ack *extack)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index 660b07cb5b92..84cc79e928c8 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -270,9 +270,13 @@ static int pch_gbe_nway_reset(struct net_device *netdev)
  * pch_gbe_get_ringparam - Report ring sizes
  * @netdev:  Network interface device structure
  * @ring:    Ring param structure
+ * @kernel_ring:	Ring external param structure
+ * @extack:	netlink handle
  */
 static void pch_gbe_get_ringparam(struct net_device *netdev,
-					struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	struct pch_gbe_tx_ring *txdr = adapter->tx_ring;
@@ -288,12 +292,16 @@ static void pch_gbe_get_ringparam(struct net_device *netdev,
  * pch_gbe_set_ringparam - Set ring sizes
  * @netdev:  Network interface device structure
  * @ring:    Ring param structure
+ * @kernel_ring:	Ring external param structure
+ * @extack:	netlink handle
  * Returns
  *	0:			Successful.
  *	Negative value:		Failed.
  */
 static int pch_gbe_set_ringparam(struct net_device *netdev,
-					struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	struct pch_gbe_tx_ring *txdr, *tx_old;
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c b/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
index e1a304886a3c..4c7e0c991105 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
@@ -69,7 +69,9 @@ pasemi_mac_ethtool_set_msglevel(struct net_device *netdev,
 
 static void
 pasemi_mac_ethtool_get_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ering)
+				 struct ethtool_ringparam *ering,
+				 struct kernel_ethtool_ringparam *kernel_ering,
+				 struct netlink_ext_ack *extack)
 {
 	struct pasemi_mac *mac = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index c54d735b9e2e..386a5cf1e224 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -512,7 +512,9 @@ static int ionic_set_coalesce(struct net_device *netdev,
 }
 
 static void ionic_get_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
@@ -523,7 +525,9 @@ static void ionic_get_ringparam(struct net_device *netdev,
 }
 
 static int ionic_set_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_queue_params qparam;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index a075643f5826..3c4a84ea6321 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -392,7 +392,9 @@ netxen_nic_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 
 static void
 netxen_nic_get_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+			 struct ethtool_ringparam *ring,
+			 struct kernel_ethtool_ringparam *kernel_ring,
+			 struct netlink_ext_ack *extack)
 {
 	struct netxen_adapter *adapter = netdev_priv(dev);
 
@@ -430,7 +432,9 @@ netxen_validate_ringparam(u32 val, u32 min, u32 max, char *r_name)
 
 static int
 netxen_nic_set_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+			 struct ethtool_ringparam *ring,
+			 struct kernel_ethtool_ringparam *kernel_ring,
+			 struct netlink_ext_ack *extack)
 {
 	struct netxen_adapter *adapter = netdev_priv(dev);
 	u16 max_rcv_desc = MAX_RCV_DESCRIPTORS_10G;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8284c4c1528f..100c9c52c20b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -888,7 +888,9 @@ int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal,
 }
 
 static void qede_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ering)
+			       struct ethtool_ringparam *ering,
+			       struct kernel_ethtool_ringparam *kernel_ering,
+			       struct netlink_ext_ack *extack)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
@@ -899,7 +901,9 @@ static void qede_get_ringparam(struct net_device *dev,
 }
 
 static int qede_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ering)
+			      struct ethtool_ringparam *ering,
+			      struct kernel_ethtool_ringparam *kernel_ering,
+			      struct netlink_ext_ack *extack)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index fc364b4ab6eb..e10fe071a40f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -632,7 +632,9 @@ qlcnic_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 
 static void
 qlcnic_get_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+		     struct ethtool_ringparam *ring,
+		     struct kernel_ethtool_ringparam *kernel_ring,
+		     struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(dev);
 
@@ -663,7 +665,9 @@ qlcnic_validate_ringparam(u32 val, u32 min, u32 max, char *r_name)
 
 static int
 qlcnic_set_ringparam(struct net_device *dev,
-		struct ethtool_ringparam *ring)
+		     struct ethtool_ringparam *ring,
+		     struct kernel_ethtool_ringparam *kernel_ring,
+		     struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(dev);
 	u16 num_rxd, num_jumbo_rxd, num_txd;
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
index f72e13b83869..f502db9cdea9 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
@@ -133,7 +133,9 @@ static int emac_nway_reset(struct net_device *netdev)
 }
 
 static void emac_get_ringparam(struct net_device *netdev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
@@ -144,7 +146,9 @@ static void emac_get_ringparam(struct net_device *netdev,
 }
 
 static int emac_set_ringparam(struct net_device *netdev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index d59fff2fbcc6..792ce9a323cd 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -246,7 +246,9 @@ qcaspi_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *p)
 }
 
 static void
-qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
+qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring,
+		     struct kernel_ethtool_ringparam *kernel_ring,
+		     struct netlink_ext_ack *extack)
 {
 	struct qcaspi *qca = netdev_priv(dev);
 
@@ -257,7 +259,9 @@ qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 }
 
 static int
-qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
+qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring,
+		     struct kernel_ethtool_ringparam *kernel_ring,
+		     struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	struct qcaspi *qca = netdev_priv(dev);
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 4f39f843bb3a..ad7b9e9d7f95 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1388,7 +1388,9 @@ static void cp_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *info
 }
 
 static void cp_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ring)
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
 {
 	ring->rx_max_pending = CP_RX_RING_SIZE;
 	ring->tx_max_pending = CP_TX_RING_SIZE;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bbe21db20417..d4d2625903cc 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1873,7 +1873,9 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 }
 
 static void rtl8169_get_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *data)
+				  struct ethtool_ringparam *data,
+				  struct kernel_ethtool_ringparam *kernel_data,
+				  struct netlink_ext_ack *extack)
 {
 	data->rx_max_pending = NUM_RX_DESC;
 	data->rx_pending = NUM_RX_DESC;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b4c597f4040c..1ec37ba83e13 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1605,7 +1605,9 @@ static void ravb_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 }
 
 static void ravb_get_ringparam(struct net_device *ndev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 
@@ -1616,7 +1618,9 @@ static void ravb_get_ringparam(struct net_device *ndev,
 }
 
 static int ravb_set_ringparam(struct net_device *ndev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index a3fbb2221c9a..223626290ce0 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2296,7 +2296,9 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 }
 
 static void sh_eth_get_ringparam(struct net_device *ndev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 
@@ -2307,7 +2309,9 @@ static void sh_eth_get_ringparam(struct net_device *ndev,
 }
 
 static int sh_eth_set_ringparam(struct net_device *ndev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 	int ret;
diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 835c838b7dfa..5dba4125d953 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -20,8 +20,11 @@
 /* This is the maximum number of descriptor rings supported by the QDMA */
 #define EFX_EF100_MAX_DMAQ_SIZE 16384UL
 
-static void ef100_ethtool_get_ringparam(struct net_device *net_dev,
-					struct ethtool_ringparam *ring)
+static void
+ef100_ethtool_get_ringparam(struct net_device *net_dev,
+			    struct ethtool_ringparam *ring,
+			    struct kernel_ethtool_ringparam *kernel_ring,
+			    struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index e002ce21788d..48506373721a 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -157,8 +157,11 @@ static int efx_ethtool_set_coalesce(struct net_device *net_dev,
 	return 0;
 }
 
-static void efx_ethtool_get_ringparam(struct net_device *net_dev,
-				      struct ethtool_ringparam *ring)
+static void
+efx_ethtool_get_ringparam(struct net_device *net_dev,
+			  struct ethtool_ringparam *ring,
+			  struct kernel_ethtool_ringparam *kernel_ring,
+			  struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -168,8 +171,11 @@ static void efx_ethtool_get_ringparam(struct net_device *net_dev,
 	ring->tx_pending = efx->txq_entries;
 }
 
-static int efx_ethtool_set_ringparam(struct net_device *net_dev,
-				     struct ethtool_ringparam *ring)
+static int
+efx_ethtool_set_ringparam(struct net_device *net_dev,
+			  struct ethtool_ringparam *ring,
+			  struct kernel_ethtool_ringparam *kernel_ring,
+			  struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	u32 txq_entries;
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index 137e8a7aeaa1..907254b36663 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -637,8 +637,11 @@ static int ef4_ethtool_set_coalesce(struct net_device *net_dev,
 	return 0;
 }
 
-static void ef4_ethtool_get_ringparam(struct net_device *net_dev,
-				      struct ethtool_ringparam *ring)
+static void
+ef4_ethtool_get_ringparam(struct net_device *net_dev,
+			  struct ethtool_ringparam *ring,
+			  struct kernel_ethtool_ringparam *kernel_ring,
+			  struct netlink_ext_ack *extack)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 
@@ -648,8 +651,11 @@ static void ef4_ethtool_get_ringparam(struct net_device *net_dev,
 	ring->tx_pending = efx->txq_entries;
 }
 
-static int ef4_ethtool_set_ringparam(struct net_device *net_dev,
-				     struct ethtool_ringparam *ring)
+static int
+ef4_ethtool_set_ringparam(struct net_device *net_dev,
+			  struct ethtool_ringparam *ring,
+			  struct kernel_ethtool_ringparam *kernel_ring,
+			  struct netlink_ext_ack *extack)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 	u32 txq_entries;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d89455803bed..eead45369eb9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -463,7 +463,9 @@ static int stmmac_nway_reset(struct net_device *dev)
 }
 
 static void stmmac_get_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct stmmac_priv *priv = netdev_priv(netdev);
 
@@ -474,7 +476,9 @@ static void stmmac_get_ringparam(struct net_device *netdev,
 }
 
 static int stmmac_set_ringparam(struct net_device *netdev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
 	    ring->rx_pending < DMA_MIN_RX_SIZE ||
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 0775a5542f2f..89bc1602661c 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2245,9 +2245,13 @@ static inline int bdx_tx_fifo_size_to_packets(int tx_size)
  * bdx_get_ringparam - report ring sizes
  * @netdev
  * @ring
+ * @kernel_ring
+ * @extack
  */
 static void
-bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct kernel_ethtool_ringparam *kernel_ring,
+		  struct netlink_ext_ack *extack)
 {
 	struct bdx_priv *priv = netdev_priv(netdev);
 
@@ -2262,9 +2266,13 @@ bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
  * bdx_set_ringparam - set ring sizes
  * @netdev
  * @ring
+ * @kernel_ring
+ * @extack
  */
 static int
-bdx_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
+bdx_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
+		  struct kernel_ethtool_ringparam *kernel_ring,
+		  struct netlink_ext_ack *extack)
 {
 	struct bdx_priv *priv = netdev_priv(netdev);
 	int rx_size = 0;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index b05de9b61ad6..d45b6bb86f0b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -453,8 +453,11 @@ static int am65_cpsw_set_channels(struct net_device *ndev,
 	return am65_cpsw_nuss_update_tx_chns(common, chs->tx_count);
 }
 
-static void am65_cpsw_get_ringparam(struct net_device *ndev,
-				    struct ethtool_ringparam *ering)
+static void
+am65_cpsw_get_ringparam(struct net_device *ndev,
+			struct ethtool_ringparam *ering,
+			struct kernel_ethtool_ringparam *kernel_ering,
+			struct netlink_ext_ack *extack)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index 7449436fc87c..bef5e68dac31 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -817,7 +817,9 @@ static void cpmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
 }
 
 static void cpmac_get_ringparam(struct net_device *dev,
-						struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct cpmac_priv *priv = netdev_priv(dev);
 
@@ -833,7 +835,9 @@ static void cpmac_get_ringparam(struct net_device *dev,
 }
 
 static int cpmac_set_ringparam(struct net_device *dev,
-						struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct cpmac_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 158c8d3793f4..aa42141be3c0 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -658,7 +658,9 @@ int cpsw_set_channels_common(struct net_device *ndev,
 }
 
 void cpsw_get_ringparam(struct net_device *ndev,
-			struct ethtool_ringparam *ering)
+			struct ethtool_ringparam *ering,
+			struct kernel_ethtool_ringparam *kernel_ering,
+			struct netlink_ext_ack *extack)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
@@ -671,7 +673,9 @@ void cpsw_get_ringparam(struct net_device *ndev,
 }
 
 int cpsw_set_ringparam(struct net_device *ndev,
-		       struct ethtool_ringparam *ering)
+		       struct ethtool_ringparam *ering,
+		       struct kernel_ethtool_ringparam *kernel_ering,
+		       struct netlink_ext_ack *extack)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 	int descs_num, ret;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 435668ee542d..f33c882eb70e 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -491,9 +491,13 @@ int cpsw_get_eee(struct net_device *ndev, struct ethtool_eee *edata);
 int cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata);
 int cpsw_nway_reset(struct net_device *ndev);
 void cpsw_get_ringparam(struct net_device *ndev,
-			struct ethtool_ringparam *ering);
+			struct ethtool_ringparam *ering,
+			struct kernel_ethtool_ringparam *kernel_ering,
+			struct netlink_ext_ack *extack);
 int cpsw_set_ringparam(struct net_device *ndev,
-		       struct ethtool_ringparam *ering);
+		       struct ethtool_ringparam *ering,
+		       struct kernel_ethtool_ringparam *kernel_ering,
+		       struct netlink_ext_ack *extack);
 int cpsw_set_channels_common(struct net_device *ndev,
 			     struct ethtool_channels *chs,
 			     cpdma_handler_fn rx_handler);
diff --git a/drivers/net/ethernet/toshiba/spider_net_ethtool.c b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
index 54f655a68148..5e4241408854 100644
--- a/drivers/net/ethernet/toshiba/spider_net_ethtool.c
+++ b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
@@ -110,7 +110,9 @@ spider_net_ethtool_nway_reset(struct net_device *netdev)
 
 static void
 spider_net_ethtool_get_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ering)
+				 struct ethtool_ringparam *ering
+				 struct kernel_ethtool_ringparam *kernel_ering,
+				 struct netlink_ext_ack *extack)
 {
 	struct spider_net_card *card = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index e7065c9a8e38..b900ab5aef2a 100644
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
+				struct kernel_ethtool_ringparam *kernel_ering,
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
+				struct kernel_ethtool_ringparam *kernel_ering,
+				struct netlink_ext_ack *extack)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9b068b81ae09..d8db008aa8e1 100644
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
+			       struct kernel_ethtool_ringparam *kernel_ering,
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
+			       struct kernel_ethtool_ringparam *kernel_ering,
+			       struct netlink_ext_ack *extack)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 7e66ae1d2a59..efa963b7af54 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1858,7 +1858,9 @@ static void __netvsc_get_ringparam(struct netvsc_device *nvdev,
 }
 
 static void netvsc_get_ringparam(struct net_device *ndev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
@@ -1870,7 +1872,9 @@ static void netvsc_get_ringparam(struct net_device *ndev,
 }
 
 static int netvsc_set_ringparam(struct net_device *ndev,
-				struct ethtool_ringparam *ring)
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 0ab6a40be611..2b84169bf3a2 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -65,7 +65,9 @@ static int nsim_set_coalesce(struct net_device *dev,
 }
 
 static void nsim_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *ring)
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
@@ -73,7 +75,9 @@ static void nsim_get_ringparam(struct net_device *dev,
 }
 
 static int nsim_set_ringparam(struct net_device *dev,
-			      struct ethtool_ringparam *ring)
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kernel_ring,
+			      struct netlink_ext_ack *extack)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4a02f33f0643..9c5b6c685585 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8983,7 +8983,9 @@ static int rtl8152_set_tunable(struct net_device *netdev,
 }
 
 static void rtl8152_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
@@ -8992,7 +8994,9 @@ static void rtl8152_get_ringparam(struct net_device *netdev,
 }
 
 static int rtl8152_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring)
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 1771d6e5224f..788a037a1a90 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2174,7 +2174,9 @@ static void virtnet_cpu_notif_remove(struct virtnet_info *vi)
 }
 
 static void virtnet_get_ringparam(struct net_device *dev,
-				struct ethtool_ringparam *ring)
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 16f3a2057b90..3172d46c0335 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -575,10 +575,11 @@ vmxnet3_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
-
 static void
 vmxnet3_get_ringparam(struct net_device *netdev,
-		      struct ethtool_ringparam *param)
+		      struct ethtool_ringparam *param,
+		      struct kernel_ethtool_ringparam *kernel_param,
+		      struct netlink_ext_ack *extack)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -595,10 +596,11 @@ vmxnet3_get_ringparam(struct net_device *netdev,
 	param->rx_jumbo_pending = adapter->rx_ring2_size;
 }
 
-
 static int
 vmxnet3_set_ringparam(struct net_device *netdev,
-		      struct ethtool_ringparam *param)
+		      struct ethtool_ringparam *param,
+		      struct kernel_ethtool_ringparam *kernel_param,
+		      struct netlink_ext_ack *extack)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	u32 new_tx_ring_size, new_rx_ring_size, new_rx_ring2_size;
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 46d0fe0d0e8a..b0b36b2132fe 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -144,7 +144,9 @@ static int qeth_set_coalesce(struct net_device *dev,
 }
 
 static void qeth_get_ringparam(struct net_device *dev,
-			       struct ethtool_ringparam *param)
+			       struct ethtool_ringparam *param,
+			       struct kernel_ethtool_ringparam *kernel_param,
+			       struct netlink_ext_ack *extack)
 {
 	struct qeth_card *card = dev->ml_priv;
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 0b252b82988b..a26f37a27167 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -656,9 +656,13 @@ struct ethtool_ops {
 				struct kernel_ethtool_coalesce *,
 				struct netlink_ext_ack *);
 	void	(*get_ringparam)(struct net_device *,
-				 struct ethtool_ringparam *);
+				 struct ethtool_ringparam *,
+				 struct kernel_ethtool_ringparam *,
+				 struct netlink_ext_ack *);
 	int	(*set_ringparam)(struct net_device *,
-				 struct ethtool_ringparam *);
+				 struct ethtool_ringparam *,
+				 struct kernel_ethtool_ringparam *,
+				 struct netlink_ext_ack *);
 	void	(*get_pause_stats)(struct net_device *dev,
 				   struct ethtool_pause_stats *pause_stats);
 	void	(*get_pauseparam)(struct net_device *,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 5c5f170a9851..af2d4e022076 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1743,11 +1743,13 @@ static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 static int ethtool_get_ringparam(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_ringparam ringparam = { .cmd = ETHTOOL_GRINGPARAM };
+	struct kernel_ethtool_ringparam kernel_ringparam = {};
 
 	if (!dev->ethtool_ops->get_ringparam)
 		return -EOPNOTSUPP;
 
-	dev->ethtool_ops->get_ringparam(dev, &ringparam);
+	dev->ethtool_ops->get_ringparam(dev, &ringparam,
+					&kernel_ringparam, NULL);
 
 	if (copy_to_user(useraddr, &ringparam, sizeof(ringparam)))
 		return -EFAULT;
@@ -1757,6 +1759,7 @@ static int ethtool_get_ringparam(struct net_device *dev, void __user *useraddr)
 static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_ringparam ringparam, max = { .cmd = ETHTOOL_GRINGPARAM };
+	struct kernel_ethtool_ringparam kernel_ringparam;
 	int ret;
 
 	if (!dev->ethtool_ops->set_ringparam || !dev->ethtool_ops->get_ringparam)
@@ -1765,7 +1768,7 @@ static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(&ringparam, useraddr, sizeof(ringparam)))
 		return -EFAULT;
 
-	dev->ethtool_ops->get_ringparam(dev, &max);
+	dev->ethtool_ops->get_ringparam(dev, &max, &kernel_ringparam, NULL);
 
 	/* ensure new ring parameters are within the maximums */
 	if (ringparam.rx_pending > max.rx_max_pending ||
@@ -1774,7 +1777,8 @@ static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 	    ringparam.tx_pending > max.tx_max_pending)
 		return -EINVAL;
 
-	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
+	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
+					      &kernel_ringparam, NULL);
 	if (!ret)
 		ethtool_notify(dev, ETHTOOL_MSG_RINGS_NTF, NULL);
 	return ret;
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index bd8e9a7530eb..450b8866373d 100644
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
+					&data->kernel_ringparam, extack);
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -142,7 +144,7 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
-	ops->get_ringparam(dev, &ringparam);
+	ops->get_ringparam(dev, &ringparam, &kernel_ringparam, info->extack);
 
 	ethnl_update_u32(&ringparam.rx_pending, tb[ETHTOOL_A_RINGS_RX], &mod);
 	ethnl_update_u32(&ringparam.rx_mini_pending,
@@ -183,7 +185,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
+	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
+					      &kernel_ringparam, info->extack);
 	if (ret < 0)
 		goto out_ops;
 	ethtool_notify(dev, ETHTOOL_MSG_RINGS_NTF, NULL);
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 99a2e30b3833..b2253df54413 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -14,7 +14,9 @@
 #include "driver-ops.h"
 
 static int ieee80211_set_ringparam(struct net_device *dev,
-				   struct ethtool_ringparam *rp)
+				   struct ethtool_ringparam *rp,
+				   struct kernel_ethtool_ringparam *kernel_rp,
+				   struct netlink_ext_ack *extack)
 {
 	struct ieee80211_local *local = wiphy_priv(dev->ieee80211_ptr->wiphy);
 
@@ -25,7 +27,9 @@ static int ieee80211_set_ringparam(struct net_device *dev,
 }
 
 static void ieee80211_get_ringparam(struct net_device *dev,
-				    struct ethtool_ringparam *rp)
+				    struct ethtool_ringparam *rp,
+				    struct kernel_ethtool_ringparam *kernel_rp,
+				    struct netlink_ext_ack *extack)
 {
 	struct ieee80211_local *local = wiphy_priv(dev->ieee80211_ptr->wiphy);
 
-- 
2.33.0

