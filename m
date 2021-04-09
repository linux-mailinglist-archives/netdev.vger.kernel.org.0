Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AAA35A52E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhDISG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:06:26 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:37549 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhDISGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:06:25 -0400
Received: by mail-ed1-f44.google.com with SMTP id s15so7569010edd.4;
        Fri, 09 Apr 2021 11:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+VYaSFqvE94v5NicutFxkslkAzAqd1oznHRzpd6JiLQ=;
        b=kbnLsjJhAhlQ9tM7o3UNuHAzmeWcFSxgjsOIHUaMuhnkDZrgFglxF9T6ayJYvwWv95
         SYSRBaPsgoH6rKWD/CxHR95X5GNe8nF4OmAIQA+jxNOyDN+qpQm6cGrPTzoMgEl6ac6Y
         1+HtE9oRIAXdNww6MJSUK1QytkcKC+PbQzGoq2ZFxSkxjsQczHtDC7gwKMz36eweYtx2
         DITdCprU0RST+9TBjcxmahimiGRLiNGazSZBzoeKVfWi1NTsrA7H3DrH+x0003IonIgR
         zwTARXaByS+TBKWOInsoIhFpPPC6nzn87sJYXStC+i54bRqkrOWgUUI0zD7XFiGcLYpQ
         3jmw==
X-Gm-Message-State: AOAM532WdgBQn5/I0hqBLww0fxtP+rOfSpfK7V7kgKpon0lzjEI62Xdf
        +4v/Lmop791e5bq55lV3r+L1oUb1cmY=
X-Google-Smtp-Source: ABdhPJyEGiwAMbKUSfdwF7pIV/rVb13Fgml9olgymXzby12C7VY6bpyio0WgCUi/b+QEBmY/tXgklw==
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr18500306edb.71.1617991571441;
        Fri, 09 Apr 2021 11:06:11 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id k26sm1571383ejc.23.2021.04.09.11.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:06:10 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH net-next 0/3] introduce skb_for_each_frag()
Date:   Fri,  9 Apr 2021 20:06:02 +0200
Message-Id: <20210409180605.78599-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Introduce skb_for_each_frag, an helper macro to iterate over the SKB frags.

First patch introduces the helper, the second one is generated with
coccinelle and uses the macro where possible.
Last one is a chunk which have to be applied by hand.

The second patch raises some checkpatch.pl warnings because part of
net/tls/tls_sw.c is indented with spaces.

Build tested with an allmodconfig and a test run.

Matteo Croce (3):
  skbuff: add helper to walk over the fraglist
  net: use skb_for_each_frag() helper where possible
  net: use skb_for_each_frag() in illegal_highdma()

 arch/um/drivers/vector_kern.c                 |  4 +--
 drivers/atm/he.c                              |  2 +-
 drivers/hsi/clients/ssi_protocol.c            |  2 +-
 drivers/infiniband/hw/hfi1/ipoib_tx.c         |  2 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  4 +--
 drivers/net/ethernet/3com/3c59x.c             |  2 +-
 drivers/net/ethernet/3com/typhoon.c           |  2 +-
 drivers/net/ethernet/adaptec/starfire.c       |  2 +-
 drivers/net/ethernet/aeroflex/greth.c         |  6 ++--
 drivers/net/ethernet/alteon/acenic.c          |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c     |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  4 +--
 drivers/net/ethernet/atheros/atlx/atl1.c      |  4 +--
 drivers/net/ethernet/broadcom/bgmac.c         |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 ++--
 drivers/net/ethernet/broadcom/tg3.c           |  2 +-
 drivers/net/ethernet/cadence/macb_main.c      |  4 +--
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  4 +--
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  5 ++--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  4 +--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +--
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  4 +--
 drivers/net/ethernet/ibm/ibmveth.c            |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/marvell/sky2.c           | 10 +++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  2 +-
 drivers/net/ethernet/neterion/s2io.c          |  2 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |  6 ++--
 drivers/net/ethernet/ni/nixge.c               |  2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |  2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  2 +-
 drivers/net/ethernet/realtek/8139cp.c         |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  2 +-
 drivers/net/ethernet/sfc/tx.c                 |  2 +-
 drivers/net/ethernet/sun/cassini.c            |  2 +-
 drivers/net/ethernet/sun/niu.c                |  4 +--
 drivers/net/ethernet/sun/sungem.c             |  2 +-
 drivers/net/ethernet/sun/sunhme.c             |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  4 +--
 .../net/ethernet/synopsys/dwc-xlgmac-desc.c   |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/ethernet/via/via-velocity.c       |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  2 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  2 +-
 drivers/net/usb/usbnet.c                      |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c |  2 +-
 drivers/net/xen-netback/netback.c             |  2 +-
 drivers/net/xen-netfront.c                    |  2 +-
 drivers/s390/net/qeth_core_main.c             |  4 +--
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/staging/octeon/ethernet-tx.c          |  2 +-
 include/linux/skbuff.h                        |  4 +++
 net/appletalk/ddp.c                           |  2 +-
 net/core/datagram.c                           |  4 +--
 net/core/dev.c                                |  2 +-
 net/core/skbuff.c                             | 30 +++++++++----------
 net/ipv4/inet_fragment.c                      |  2 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/iucv/af_iucv.c                            |  4 +--
 net/kcm/kcmsock.c                             |  3 +-
 net/tls/tls_sw.c                              |  2 +-
 96 files changed, 140 insertions(+), 138 deletions(-)

-- 
2.30.2

