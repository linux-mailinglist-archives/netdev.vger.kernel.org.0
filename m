Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0CA59E9A7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiHWR2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiHWR00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:26:26 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A52D51F0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661267090; x=1692803090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HI4TtFytANHkLG0B7MZdgSsptx9Sua0xxtihFUGtMMs=;
  b=hfxQ2ZBt6q9SLIuYBTi0awwFIvmb1rX2yjoij0/H2CvyCKn4TZbHyt4D
   ZZLK/YAu3J4wtcEreuyuHflZT0MdnZPsCDu9sWExp+cdqPhYLGh1U1LoV
   f2sTnRdcLYHXGUgmaflrceU4A+rBpP7oy129ZIOody1UPt5C5vJaCx/Ti
   bTReYeNmu1KJe8jaWpK8WgoTd+egmsfICc80YniF9WRtCQwYZv77jVohx
   Ppr5nOf4pDkR3npUDrMZ0YJdvmKYxGtH94FVcf352liB9QEBh5J5KkAO8
   vvoomDg7k+TQu75t2s24o8Nh4m/iHHldg0xYCnOoCMS7NuWHOhI4YKB+t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="273464965"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="273464965"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 08:04:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="854894265"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 08:04:48 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Yu Xiao <yu.xiao@corigine.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Yufeng Mo <moyufeng@huawei.com>,
        Sixiang Chen <sixiang.chen@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Erik Ekman <erik@kryo.se>, Ido Schimmel <idosch@nvidia.com>,
        Jie Wang <wangjie125@huawei.com>,
        Moshe Tal <moshet@nvidia.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Marco Bonelli <marco@mebeim.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH net-next 1/2] ethtool: pass netlink extended ACK to .set_fecparam
Date:   Tue, 23 Aug 2022 08:04:37 -0700
Message-Id: <20220823150438.3613327-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220823150438.3613327-1-jacob.e.keller@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the netlink extended ACK structure pointer to the interface for
.set_fecparam. This allows reporting errors to the user appropriately when
using the netlink ethtool interface.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Derek Chickles <dchickles@marvell.com>
Cc: Satanand Burla <sburla@marvell.com>
Cc: Felix Manlunas <fmanlunas@marvell.com>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Geetha sowjanya <gakula@marvell.com>
Cc: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: hariprasad <hkelam@marvell.com>
Cc: Taras Chornyi <tchornyi@marvell.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Simon Horman <simon.horman@corigine.com>
Cc: Shannon Nelson <snelson@pensando.io>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Fei Qin <fei.qin@corigine.com>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Yu Xiao <yu.xiao@corigine.com>
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Yufeng Mo <moyufeng@huawei.com>
Cc: Sixiang Chen <sixiang.chen@corigine.com>
Cc: Yinjun Zhang <yinjun.zhang@corigine.com>
Cc: Hao Chen <chenhao288@hisilicon.com>
Cc: Guangbin Huang <huangguangbin2@huawei.com>
Cc: Sean Anderson <sean.anderson@seco.com>
Cc: Erik Ekman <erik@kryo.se>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Jie Wang <wangjie125@huawei.com>
Cc: Moshe Tal <moshet@nvidia.com>
Cc: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc: Marco Bonelli <marco@mebeim.net>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>

---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c         | 3 ++-
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c        | 3 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c        | 3 ++-
 drivers/net/ethernet/fungible/funeth/funeth_ethtool.c     | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c        | 3 ++-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c            | 3 ++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c              | 4 +++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 ++-
 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c  | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      | 3 ++-
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c      | 3 ++-
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c       | 3 ++-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c           | 3 ++-
 drivers/net/ethernet/sfc/ethtool_common.c                 | 3 ++-
 drivers/net/ethernet/sfc/ethtool_common.h                 | 3 ++-
 drivers/net/ethernet/sfc/siena/ethtool_common.c           | 3 ++-
 drivers/net/ethernet/sfc/siena/ethtool_common.h           | 3 ++-
 drivers/net/netdevsim/ethtool.c                           | 3 ++-
 include/linux/ethtool.h                                   | 3 ++-
 net/ethtool/fec.c                                         | 2 +-
 net/ethtool/ioctl.c                                       | 2 +-
 21 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 87eb5362ad70..9ad00240ee06 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2022,7 +2022,8 @@ static u32 bnxt_ethtool_forced_fec_to_fw(struct bnxt_link_info *link_info,
 }
 
 static int bnxt_set_fecparam(struct net_device *dev,
-			     struct ethtool_fecparam *fecparam)
+			     struct ethtool_fecparam *fecparam,
+			     struct netlink_ext_ack *extack)
 {
 	struct hwrm_port_phy_cfg_input *req;
 	struct bnxt *bp = netdev_priv(dev);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index 2c10ae3f7fc1..d6ba8153c649 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -3084,7 +3084,8 @@ static int lio_get_fecparam(struct net_device *netdev,
 }
 
 static int lio_set_fecparam(struct net_device *netdev,
-			    struct ethtool_fecparam *fec)
+			    struct ethtool_fecparam *fec,
+			    struct netlink_ext_ack *extack)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 77897edd2bc0..cd7f09aa63fb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -834,7 +834,8 @@ static int get_fecparam(struct net_device *dev, struct ethtool_fecparam *fec)
 	return 0;
 }
 
-static int set_fecparam(struct net_device *dev, struct ethtool_fecparam *fec)
+static int set_fecparam(struct net_device *dev, struct ethtool_fecparam *fec,
+			struct netlink_ext_ack *extack)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct link_config *lc = &pi->link_cfg;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
index 31aa185f4d17..31b15506ca4c 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
@@ -1087,7 +1087,8 @@ static int fun_get_fecparam(struct net_device *netdev,
 }
 
 static int fun_set_fecparam(struct net_device *netdev,
-			    struct ethtool_fecparam *fec)
+			    struct ethtool_fecparam *fec,
+			    struct netlink_ext_ack *extack)
 {
 	struct funeth_priv *fp = netdev_priv(netdev);
 	u64 fec_mode;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 4c7988e308a2..82f7d70477e6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1673,7 +1673,8 @@ static int hns3_get_fecparam(struct net_device *netdev,
 }
 
 static int hns3_set_fecparam(struct net_device *netdev,
-			     struct ethtool_fecparam *fec)
+			     struct ethtool_fecparam *fec,
+			     struct netlink_ext_ack *extack)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 156e92c43780..35e6eb65e237 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1582,7 +1582,8 @@ static int i40e_get_fec_param(struct net_device *netdev,
 }
 
 static int i40e_set_fec_param(struct net_device *netdev,
-			      struct ethtool_fecparam *fecparam)
+			      struct ethtool_fecparam *fecparam,
+			      struct netlink_ext_ack *extack)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_pf *pf = np->vsi->back;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 60dca15635db..770101577a94 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1012,9 +1012,11 @@ static int ice_set_fec_cfg(struct net_device *netdev, enum ice_fec_mode req_fec)
  * ice_set_fecparam - Set FEC link options
  * @netdev: network interface device structure
  * @fecparam: Ethtool structure to retrieve FEC parameters
+ * @extack: Netlink extended ACK response
  */
 static int
-ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
+ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam,
+		 struct netlink_ext_ack *extack)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 3f60a80e34c8..1bc5f661fe00 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1024,7 +1024,8 @@ static int otx2_get_fecparam(struct net_device *netdev,
 }
 
 static int otx2_set_fecparam(struct net_device *netdev,
-			     struct ethtool_fecparam *fecparam)
+			     struct ethtool_fecparam *fecparam,
+			     struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct mbox *mbox = &pfvf->mbox;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 1da7ff889417..4f19f0dfac5e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -705,7 +705,8 @@ static int prestera_ethtool_get_fecparam(struct net_device *dev,
 }
 
 static int prestera_ethtool_set_fecparam(struct net_device *dev,
-					 struct ethtool_fecparam *fecparam)
+					 struct ethtool_fecparam *fecparam,
+					 struct netlink_ext_ack *extack)
 {
 	struct prestera_port *port = netdev_priv(dev);
 	struct prestera_port_mac_config cfg_mac;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index b811207fe5ed..1e2b82aff1cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1668,7 +1668,8 @@ static int mlx5e_get_fecparam(struct net_device *netdev,
 }
 
 static int mlx5e_set_fecparam(struct net_device *netdev,
-			      struct ethtool_fecparam *fecparam)
+			      struct ethtool_fecparam *fecparam,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index eeb1455a4e5d..4c29da87c61f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1015,7 +1015,8 @@ nfp_port_get_fecparam(struct net_device *netdev,
 
 static int
 nfp_port_set_fecparam(struct net_device *netdev,
-		      struct ethtool_fecparam *param)
+		      struct ethtool_fecparam *param,
+		      struct netlink_ext_ack *extack)
 {
 	struct nfp_eth_table_port *eth_port;
 	struct nfp_port *port;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 01c22701482d..d9ff8899c67c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -360,7 +360,8 @@ static int ionic_get_fecparam(struct net_device *netdev,
 }
 
 static int ionic_set_fecparam(struct net_device *netdev,
-			      struct ethtool_fecparam *fec)
+			      struct ethtool_fecparam *fec,
+			      struct netlink_ext_ack *extack)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	u8 fec_type;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 97a7ab0826ed..db3aab14907e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1912,7 +1912,8 @@ static int qede_get_fecparam(struct net_device *dev,
 }
 
 static int qede_set_fecparam(struct net_device *dev,
-			     struct ethtool_fecparam *fecparam)
+			     struct ethtool_fecparam *fecparam,
+			     struct netlink_ext_ack *extack)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qed_link_params params;
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bc840ede3053..2b1b505da4fb 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -616,7 +616,8 @@ int efx_ethtool_get_fecparam(struct net_device *net_dev,
 }
 
 int efx_ethtool_set_fecparam(struct net_device *net_dev,
-			     struct ethtool_fecparam *fecparam)
+			     struct ethtool_fecparam *fecparam,
+			     struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
 	int rc;
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 659491932101..4cdc322f4616 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -37,7 +37,8 @@ int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
 int efx_ethtool_get_fecparam(struct net_device *net_dev,
 			     struct ethtool_fecparam *fecparam);
 int efx_ethtool_set_fecparam(struct net_device *net_dev,
-			     struct ethtool_fecparam *fecparam);
+			     struct ethtool_fecparam *fecparam,
+			     struct netlink_ext_ack *extack);
 int efx_ethtool_get_rxnfc(struct net_device *net_dev,
 			  struct ethtool_rxnfc *info, u32 *rule_locs);
 int efx_ethtool_set_rxnfc(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index 0207d07f54e3..9f65cb1c058c 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -616,7 +616,8 @@ int efx_siena_ethtool_get_fecparam(struct net_device *net_dev,
 }
 
 int efx_siena_ethtool_set_fecparam(struct net_device *net_dev,
-				   struct ethtool_fecparam *fecparam)
+				   struct ethtool_fecparam *fecparam,
+				   struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.h b/drivers/net/ethernet/sfc/siena/ethtool_common.h
index 04b375dc6800..7dadd95eb69f 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.h
@@ -34,7 +34,8 @@ int efx_siena_ethtool_set_link_ksettings(struct net_device *net_dev,
 int efx_siena_ethtool_get_fecparam(struct net_device *net_dev,
 				   struct ethtool_fecparam *fecparam);
 int efx_siena_ethtool_set_fecparam(struct net_device *net_dev,
-				   struct ethtool_fecparam *fecparam);
+				   struct ethtool_fecparam *fecparam,
+				   struct netlink_ext_ack *extack);
 int efx_siena_ethtool_get_rxnfc(struct net_device *net_dev,
 				struct ethtool_rxnfc *info, u32 *rule_locs);
 int efx_siena_ethtool_set_rxnfc(struct net_device *net_dev,
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index ffd9f84b6644..88f3738c5899 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -124,7 +124,8 @@ nsim_get_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
 }
 
 static int
-nsim_set_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
+nsim_set_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam,
+		  struct netlink_ext_ack *extack)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 	u32 fec;
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 99dc7bfbcd3c..3ce1ef7b1390 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -735,7 +735,8 @@ struct ethtool_ops {
 	int	(*get_fecparam)(struct net_device *,
 				      struct ethtool_fecparam *);
 	int	(*set_fecparam)(struct net_device *,
-				      struct ethtool_fecparam *);
+				      struct ethtool_fecparam *,
+				      struct netlink_ext_ack *extack);
 	void	(*get_ethtool_phy_stats)(struct net_device *,
 					 struct ethtool_stats *, u64 *);
 	int	(*get_phy_tunable)(struct net_device *,
diff --git a/net/ethtool/fec.c b/net/ethtool/fec.c
index 9f5a134e2e01..79931b0de177 100644
--- a/net/ethtool/fec.c
+++ b/net/ethtool/fec.c
@@ -295,7 +295,7 @@ int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	ret = dev->ethtool_ops->set_fecparam(dev, &fec);
+	ret = dev->ethtool_ops->set_fecparam(dev, &fec, info->extack);
 	if (ret < 0)
 		goto out_ops;
 	ethtool_notify(dev, ETHTOOL_MSG_FEC_NTF, NULL);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6a7308de192d..2f397d016d3a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2706,7 +2706,7 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 	fecparam.active_fec = 0;
 	fecparam.reserved = 0;
 
-	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
+	return dev->ethtool_ops->set_fecparam(dev, &fecparam, NULL);
 }
 
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
-- 
2.37.1.394.gc50926e1f488

