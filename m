Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E6615568
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 23:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfEFVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 17:25:13 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:37946 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfEFVZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 17:25:12 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 058C75099;
        Mon,  6 May 2019 23:25:08 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id a62b6721;
        Mon, 6 May 2019 23:25:07 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
Date:   Mon,  6 May 2019 23:24:43 +0200
Message-Id: <1557177887-30446-1-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series is an attempt to fix the mess, I've somehow managed to
introduce.

First patch in this series is defacto v5 of the previous 05/10 patch in the
series, but since the v4 of this 05/10 patch wasn't picked up by the
patchwork for some unknown reason, this patch wasn't applied with the other
9 patches in the series, so I'm resending it as a separate patch of this
fixup series again.

Second patch is a result of this rebase against net-next tree, where I was
checking again all current users of of_get_mac_address and found out, that
there's new one in DSA, so I've converted this user to the new ERR_PTR
encoded error value as well.

Third patch which was sent as v5 wasn't considered for merge, but I still
think, that we need to check for possible NULL value, thus current IS_ERR
check isn't sufficient and we need to use IS_ERR_OR_NULL instead.

Fourth patch fixes warning reported by kbuild test robot.

Cheers,

Petr

Petr Štetiar (4):
  net: ethernet: support of_get_mac_address new ERR_PTR error
  net: dsa: support of_get_mac_address new ERR_PTR error
  staging: octeon-ethernet: Fix of_get_mac_address ERR_PTR check
  net: usb: smsc: fix warning reported by kbuild test robot

 drivers/net/ethernet/aeroflex/greth.c                 | 2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c           | 2 +-
 drivers/net/ethernet/altera/altera_tse_main.c         | 2 +-
 drivers/net/ethernet/arc/emac_main.c                  | 2 +-
 drivers/net/ethernet/aurora/nb8800.c                  | 2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c            | 2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c            | 2 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c        | 2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        | 2 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c      | 2 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c     | 2 +-
 drivers/net/ethernet/davicom/dm9000.c                 | 2 +-
 drivers/net/ethernet/ethoc.c                          | 2 +-
 drivers/net/ethernet/ezchip/nps_enet.c                | 2 +-
 drivers/net/ethernet/freescale/fec_main.c             | 2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c          | 2 +-
 drivers/net/ethernet/freescale/fman/mac.c             | 2 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 2 +-
 drivers/net/ethernet/freescale/gianfar.c              | 2 +-
 drivers/net/ethernet/freescale/ucc_geth.c             | 2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c           | 2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c         | 2 +-
 drivers/net/ethernet/lantiq_xrx200.c                  | 2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c            | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                 | 2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c             | 2 +-
 drivers/net/ethernet/marvell/sky2.c                   | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c           | 2 +-
 drivers/net/ethernet/micrel/ks8851.c                  | 2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c              | 2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                    | 2 +-
 drivers/net/ethernet/qualcomm/qca_spi.c               | 2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c              | 2 +-
 drivers/net/ethernet/renesas/ravb_main.c              | 2 +-
 drivers/net/ethernet/renesas/sh_eth.c                 | 2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c   | 2 +-
 drivers/net/ethernet/socionext/sni_ave.c              | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 2 +-
 drivers/net/ethernet/ti/cpsw.c                        | 2 +-
 drivers/net/ethernet/ti/netcp_core.c                  | 2 +-
 drivers/net/ethernet/wiznet/w5100.c                   | 2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c           | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c     | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c         | 2 +-
 drivers/net/usb/smsc75xx.c                            | 2 +-
 drivers/net/usb/smsc95xx.c                            | 2 +-
 drivers/staging/octeon/ethernet.c                     | 2 +-
 net/dsa/slave.c                                       | 2 +-
 net/ethernet/eth.c                                    | 2 +-
 49 files changed, 49 insertions(+), 49 deletions(-)

-- 
1.9.1

