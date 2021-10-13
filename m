Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0007E42CB43
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhJMUqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhJMUqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42028610F9;
        Wed, 13 Oct 2021 20:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157884;
        bh=XS6BJD+6qHKlurUs3DDZsVtq09WAsGew5gSbcrPJ60Y=;
        h=From:To:Cc:Subject:Date:From;
        b=XpeyUWoSLShaiPVk6rS437TfOLb15v5nWOsx7OSaC7kaBeIyJC+hmTucR5XsOqRo6
         kgvg7d54GM4jXyCOY6MgnBJMHo1d1WhnJrPV3/94zlZW1UKe2H4JFGx9/LMQsPo304
         WoPirrVHsgIOOfnuXm1AE3xOmB4EqgsgyqdzAjB+tWI2ro5myMxUIQv/jqR/phYq1A
         u9Xf4ySznP+92TSph/TVZaqxDRFLjSwr/JPGujmlPYX/gHNAK1K9S6YepZkyT85IMo
         U9RQdL5X8KUC6xbh31dHf0PtkedztrDD1cgnsfYDjhxYr6SxMIjvpyRmlUUrEmPHAm
         plEezw25XQGog==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/7] ethernet: more netdev->dev_addr write removals
Date:   Wed, 13 Oct 2021 13:44:28 -0700
Message-Id: <20211013204435.322561-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another series removing direct writes to netdev->dev_addr.

Jakub Kicinski (7):
  ethernet: constify references to netdev->dev_addr in drivers
  ethernet: make eth_hw_addr_random() use dev_addr_set()
  ethernet: make use of eth_hw_addr_random() where appropriate
  ethernet: manually convert memcpy(dev_addr,..., sizeof(addr))
  ethernet: ibm/emac: use of_get_ethdev_address() to load dev_addr
  ethernet: replace netdev->dev_addr assignment loops
  ethernet: replace netdev->dev_addr 16bit writes

 drivers/net/ethernet/3com/3c515.c             |  5 ++--
 drivers/net/ethernet/3com/3c574_cs.c          | 11 ++++-----
 drivers/net/ethernet/3com/3c589_cs.c          | 10 ++++----
 drivers/net/ethernet/3com/3c59x.c             |  4 +++-
 drivers/net/ethernet/actions/owl-emac.c       |  2 +-
 drivers/net/ethernet/adaptec/starfire.c       | 10 ++++----
 drivers/net/ethernet/alacritech/slicoss.c     |  2 +-
 drivers/net/ethernet/alteon/acenic.c          |  4 ++--
 drivers/net/ethernet/altera/altera_tse_main.c |  2 +-
 drivers/net/ethernet/amd/nmclan_cs.c          |  3 ++-
 drivers/net/ethernet/amd/sun3lance.c          |  4 +---
 drivers/net/ethernet/amd/sunlance.c           |  4 +---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c      |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h          |  2 +-
 drivers/net/ethernet/apm/xgene-v2/mac.c       |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_hw.c    |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_sgmac.c |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_xgmac.c |  2 +-
 drivers/net/ethernet/apple/bmac.c             | 15 +++++-------
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  6 ++---
 .../ethernet/aquantia/atlantic/aq_macsec.c    |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  4 ++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  4 ++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  4 ++--
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  4 ++--
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |  2 +-
 drivers/net/ethernet/broadcom/b44.c           |  6 +++--
 drivers/net/ethernet/broadcom/bcmsysport.c    |  2 +-
 drivers/net/ethernet/broadcom/bgmac.c         |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  4 ++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |  3 ++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |  2 +-
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.h   |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  4 ++--
 drivers/net/ethernet/cadence/macb_main.c      |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 drivers/net/ethernet/chelsio/cxgb/gmac.h      |  2 +-
 drivers/net/ethernet/chelsio/cxgb/pm3393.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/vsc7326.c   |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/common.h   |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/xgmac.c    |  2 +-
 drivers/net/ethernet/cisco/enic/enic_pp.c     |  2 +-
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c  |  4 +++-
 drivers/net/ethernet/dlink/dl2k.c             |  5 ++--
 drivers/net/ethernet/dlink/sundance.c         |  4 +++-
 drivers/net/ethernet/dnet.c                   |  8 +++----
 drivers/net/ethernet/emulex/benet/be_cmds.c   |  2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h   |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/ethoc.c                  |  2 +-
 drivers/net/ethernet/fealnx.c                 |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  4 ++--
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  8 +++----
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  2 +-
 .../net/ethernet/freescale/fman/fman_memac.c  |  8 +++----
 .../net/ethernet/freescale/fman/fman_memac.h  |  2 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  8 +++----
 .../net/ethernet/freescale/fman/fman_tgec.h   |  2 +-
 drivers/net/ethernet/freescale/fman/mac.h     |  2 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c     |  7 ++----
 drivers/net/ethernet/hisilicon/hip04_eth.c    |  2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hnae.h     |  2 +-
 .../net/ethernet/hisilicon/hns/hns_ae_adapt.c |  2 +-
 .../ethernet/hisilicon/hns/hns_dsaf_gmac.c    |  2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c |  2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.h |  5 ++--
 .../ethernet/hisilicon/hns/hns_dsaf_xgmac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
 drivers/net/ethernet/i825xx/sun3_82586.c      |  7 +++---
 drivers/net/ethernet/ibm/emac/core.c          |  2 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |  2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c     |  2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.h     |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  4 ++--
 drivers/net/ethernet/marvell/pxa168_eth.c     |  6 ++---
 drivers/net/ethernet/mediatek/mtk_star_emac.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  4 ++--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +-
 drivers/net/ethernet/micrel/ks8842.c          |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  4 ++--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  7 +++---
 drivers/net/ethernet/neterion/s2io.c          |  2 +-
 drivers/net/ethernet/neterion/s2io.h          |  2 +-
 .../netronome/nfp/flower/tunnel_conf.c        |  6 ++---
 drivers/net/ethernet/nxp/lpc_eth.c            |  2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.h      |  2 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c         | 10 ++++----
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  2 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  2 +-
 drivers/net/ethernet/rdc/r6040.c              | 24 +++++++++----------
 drivers/net/ethernet/realtek/8139cp.c         |  5 ++--
 drivers/net/ethernet/realtek/8139too.c        |  5 ++--
 drivers/net/ethernet/realtek/atp.c            |  4 +++-
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |  2 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_core.c   |  3 ++-
 drivers/net/ethernet/sfc/ef10.c               |  4 ++--
 drivers/net/ethernet/sfc/ef10_sriov.c         |  2 +-
 drivers/net/ethernet/sfc/ef10_sriov.h         |  6 ++---
 drivers/net/ethernet/sfc/net_driver.h         |  2 +-
 drivers/net/ethernet/sfc/siena_sriov.c        |  2 +-
 drivers/net/ethernet/sfc/siena_sriov.h        |  2 +-
 drivers/net/ethernet/sis/sis190.c             |  4 +++-
 drivers/net/ethernet/sis/sis900.c             | 15 ++++++++----
 drivers/net/ethernet/smsc/epic100.c           |  4 +++-
 drivers/net/ethernet/smsc/smc91c92_cs.c       |  5 ++--
 drivers/net/ethernet/smsc/smsc911x.c          |  2 +-
 drivers/net/ethernet/smsc/smsc9420.c          |  2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |  4 ++--
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  2 +-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |  2 +-
 .../ethernet/stmicro/stmmac/dwmac100_core.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |  2 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_core.c   |  3 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 ++-
 .../stmicro/stmmac/stmmac_selftests.c         |  4 ++--
 drivers/net/ethernet/sun/sunbmac.c            |  6 ++---
 drivers/net/ethernet/sun/sunqe.c              |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |  2 +-
 drivers/net/ethernet/ti/cpmac.c               |  2 +-
 drivers/net/ethernet/ti/davinci_emac.c        |  4 +---
 drivers/net/ethernet/ti/netcp_core.c          |  4 ++--
 drivers/net/ethernet/ti/tlan.c                |  4 ++--
 drivers/net/ethernet/toshiba/tc35815.c        |  3 ++-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  7 +++---
 drivers/net/ethernet/xircom/xirc2ps_cs.c      |  2 +-
 drivers/net/phy/mscc/mscc_main.c              |  2 +-
 drivers/net/usb/aqc111.c                      |  2 +-
 drivers/net/usb/ax88179_178a.c                |  8 +++----
 drivers/net/usb/catc.c                        |  2 +-
 drivers/net/usb/dm9601.c                      |  3 ++-
 drivers/net/usb/mcs7830.c                     |  3 ++-
 drivers/net/usb/pegasus.c                     |  2 +-
 drivers/net/usb/sr9700.c                      |  3 ++-
 drivers/pcmcia/pcmcia_cis.c                   |  5 ++--
 include/linux/etherdevice.h                   |  5 +++-
 include/linux/qed/qed_eth_if.h                |  2 +-
 include/linux/qed/qed_if.h                    |  2 +-
 include/linux/qed/qed_rdma_if.h               |  3 ++-
 net/atm/lec.c                                 |  3 +--
 164 files changed, 293 insertions(+), 275 deletions(-)

-- 
2.31.1

