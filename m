Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EDD422D06
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhJEPzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhJEPzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19006124C;
        Tue,  5 Oct 2021 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633449208;
        bh=ZyJm7i5/kHb73N2jrQ0xBrKoCJ2Gc4t5case5pCdD4g=;
        h=From:To:Cc:Subject:Date:From;
        b=dWUameeyFC0QNrfVU59mix3Wd1LtrlzJo5rvgcZH6EFtn82BPQ40dd7taXl9kGfUP
         mW6+hC1FFZaqL+A1U8LTCEETcl8Gwu20V8w8UVAn9qCa9iOH6oRrIR/VdCmZ3h650g
         abH8mQkUuKKe4xZicIh683hjZ/Sqs2uHKoVG/oH5nU1OvpHAubnMDaE5HBU5zKG8oa
         EDDP4G/Ko0pl7bwM7EvmG1m7kFavFCWnsdEq//qrv2nBSJx2a8zIoSqG9vCNvSYfrZ
         nZaaP4xO+7yJq7MhE5jTOymAOFMX36+Q7cQzPYZMWIbt/Ep+EClAf2CXj3orfYnWl1
         urm8ov4IasuvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] net: add a helpers for loading netdev->dev_addr from FW
Date:   Tue,  5 Oct 2021 08:53:17 -0700
Message-Id: <20211005155321.2966828-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're trying to make all writes to netdev->dev_addr go via helpers.
A lot of places pass netdev->dev_addr to of_get_ethdev_address() and
device_get_ethdev_addr() so this set adds new functions which wrap
the functionality.

Jakub Kicinski (4):
  of: net: add a helper for loading netdev->dev_addr
  ethernet: use of_get_ethdev_address()
  device property: add a helper for loading netdev->dev_addr
  ethernet: use device_get_ethdev_addr()

 drivers/base/property.c                       | 20 +++++++++++++++
 drivers/net/ethernet/allwinner/sun4i-emac.c   |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  2 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 drivers/net/ethernet/arc/emac_main.c          |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |  2 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c  |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c    |  2 +-
 .../net/ethernet/broadcom/bgmac-platform.c    |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 drivers/net/ethernet/cadence/macb_main.c      |  2 +-
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  2 +-
 drivers/net/ethernet/ethoc.c                  |  2 +-
 drivers/net/ethernet/ezchip/nps_enet.c        |  2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c  |  2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c     |  2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 drivers/net/ethernet/korina.c                 |  2 +-
 drivers/net/ethernet/lantiq_xrx200.c          |  2 +-
 drivers/net/ethernet/litex/litex_liteeth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c     |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 drivers/net/ethernet/micrel/ks8851_common.c   |  2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            |  2 +-
 drivers/net/ethernet/qualcomm/qca_spi.c       |  2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c      |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  2 +-
 .../ethernet/samsung/sxgbe/sxgbe_platform.c   |  2 +-
 drivers/net/ethernet/socionext/sni_ave.c      |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  2 +-
 drivers/of/of_net.c                           | 25 +++++++++++++++++++
 include/linux/of_net.h                        |  6 +++++
 include/linux/property.h                      |  2 ++
 42 files changed, 91 insertions(+), 38 deletions(-)

-- 
2.31.1

