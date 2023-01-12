Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A56D667903
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbjALPXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbjALPWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:22:53 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B64017418;
        Thu, 12 Jan 2023 07:15:25 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 17DAF1243;
        Thu, 12 Jan 2023 16:15:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673536523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z7B4pND5e+QR5QtoQ7I5oChkxQuHHA20+0hEeYmGTgM=;
        b=u49FS3Dk9qDfluXiGp9TkmisU6Qu5EvwZeqGdovxab6dVxup2BRDNMldkVcrzwCEAfpQAO
        ZqMoR10rIPYiZXZgHEfpSBuByb641u4TLay6c3YIfCdpyyraN3BAKHkEcEFVIkadRUCeaH
        NhRHm0VW+4rqcCspn5gc2CDfsZ3V9+V77PoUo5/EbEgb2mqudJB6j2SVDvbwlriGHsQVNE
        g+ewd5Nm+se/6Xbqu+vFAXV0+H4iY4LjVWzQ14ymHNqNk0p3sf4brIiS32qqEmA3kq2MDu
        6wV/2+U3EUaZghtv6GX3t0E72N3yCT7u78d3h0OeNauAyUvteuYApMHhmZ3Iug==
From:   Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 00/10] net: mdio: Continue separating C22 and C45
Date:   Thu, 12 Jan 2023 16:15:07 +0100
Message-Id: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAPsjwGMC/zWNwQrCMBBEf6Xs2YVuTLX4K+Jhk25tDsawG6RQ+
 u+mgoc5PIZ5s4GJJjG4dRuofJKld25Apw7iwvkpmKbG4Hp37okcZqkta8XoBzQpolzbBgtrRYcU
 xjkE8v4yXqFJAptgUM5xOTQvtip6FEVlTuvv+Q5/KTz2/QtSEQk5kwAAAA==
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Li Yang <leoyang.li@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've picked this older series from Andrew up and rebased it onto
the latest net-next.

This is the second patch set in the series which separates the C22
and C45 MDIO bus transactions at the API level to the MDIO bus drivers.

Signed-off-by: Michael Walle <michael@walle.cc>

￼

To: Heiner Kallweit <hkallweit1@gmail.com>
To: Russell King <linux@armlinux.org.uk>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Ray Jui <rjui@broadcom.com>
To: Scott Branden <sbranden@broadcom.com>
To: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
To: Joel Stanley <joel@jms.id.au>
To: Andrew Jeffery <andrew@aj.id.au>
To: Felix Fietkau <nbd@nbd.name>
To: John Crispin <john@phrozen.org>
To: Sean Wang <sean.wang@mediatek.com>
To: Mark Lee <Mark-MC.Lee@mediatek.com>
To: Lorenzo Bianconi <lorenzo@kernel.org>
To: Matthias Brugger <matthias.bgg@gmail.com>
To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>
To: Alexandre Torgue <alexandre.torgue@foss.st.com>
To: Jose Abreu <joabreu@synopsys.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Claudiu Manoil <claudiu.manoil@nxp.com>
To: Alexandre Belloni <alexandre.belloni@bootlin.com>
To: Florian Fainelli <f.fainelli@gmail.com>
To: Li Yang <leoyang.li@nxp.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-aspeed@lists.ozlabs.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>

---
Andrew Lunn (10):
      net: mdio: cavium: Separate C22 and C45 transactions
      net: mdio: i2c: Separate C22 and C45 transactions
      net: mdio: mux-bcm-iproc: Separate C22 and C45 transactions
      net: mdio: aspeed: Separate C22 and C45 transactions
      net: mdio: ipq4019: Separate C22 and C45 transactions
      net: ethernet: mtk_eth_soc: Separate C22 and C45 transactions
      net: lan743x: Separate C22 and C45 transactions
      net: stmmac: Separate C22 and C45 transactions for xgmac2
      net: stmmac: Separate C22 and C45 transactions for xgmac
      enetc: Separate C22 and C45 transactions

 drivers/net/dsa/ocelot/felix_vsc9959.c             |   6 +-
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c  | 119 ++++++--
 .../net/ethernet/freescale/enetc/enetc_pci_mdio.c  |   6 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  12 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 178 +++++++----
 drivers/net/ethernet/microchip/lan743x_main.c      | 106 ++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  | 331 ++++++++++++++-------
 drivers/net/mdio/mdio-aspeed.c                     |  47 +--
 drivers/net/mdio/mdio-cavium.c                     | 111 +++++--
 drivers/net/mdio/mdio-cavium.h                     |   9 +-
 drivers/net/mdio/mdio-i2c.c                        |  32 +-
 drivers/net/mdio/mdio-ipq4019.c                    | 154 ++++++----
 drivers/net/mdio/mdio-mux-bcm-iproc.c              |  54 +++-
 drivers/net/mdio/mdio-octeon.c                     |   6 +-
 drivers/net/mdio/mdio-thunder.c                    |   6 +-
 include/linux/fsl/enetc_mdio.h                     |  21 +-
 16 files changed, 766 insertions(+), 432 deletions(-)
---
base-commit: 0a093b2893c711d82622a9ab27da4f1172821336
change-id: 20230112-net-next-c45-seperation-part-2-1b8fbb144687

Best regards,
-- 
Michael Walle <michael@walle.cc>
