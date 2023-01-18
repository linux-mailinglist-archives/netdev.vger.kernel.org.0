Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABF76719BF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjARK4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjARKxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:53:01 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498CF8100B;
        Wed, 18 Jan 2023 02:01:46 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A0F67125C;
        Wed, 18 Jan 2023 11:01:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674036104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mJlXAa/qkylSd69OPqPPuscGxs/BZYHJRgJ6yHTXKPg=;
        b=VaR2ztJS25J2+GUfFLOhG2pduVTooXBz0fDVkqPYjDtmtBuK8u3CKFU+dCFUgrwrNcpZSS
        xqxvsR7Bk6WX3t/v1YyPzUaJSNzLOehrazKHtwxm7ZTv7aDkl0d7N4xUWWFqUHqWRHM2oS
        xMI1F4W0V9wL9zlAu21aClmH7pWuPublyh4GOjk2/y6nhEVHh87g7j83e6KZQVieB98SmY
        SkKV4IIXSBo5J5r/tD0/deEP7t51oHQLSPm5AF3F5jiKOhyJ/xqaAEywzt0PNyp6kWDAOt
        oc4njm15cQ4lf/w51vdgNUpIjVDItdFirWL0zQGTyS+rjWAhT+PJY6pew2RICQ==
From:   Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 0/6] net: phy: Remove probe_capabilities
Date:   Wed, 18 Jan 2023 11:01:35 +0100
Message-Id: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH/Dx2MC/5WOQQ6CMBBFr0Jm7ZiWIoor72FYTMsgTaCQtkEM4
 e4WEg/gYhY/L//NXyGwtxzgnq3gebbBji6F/JSB6ci9GG2TMuQiV0LKEh3HdEtEz8M4M05+1IyG
 JtK2tzG5UKimELJQVWtKSCJNgVF7cqbbVQOFyH4Hk+fWLsf3J/zEUCfS2RBH/zlmzfLg/yyYJQq
 8EOXVVd0oFR9v6ns+GwP1tm1f2oxXifYAAAA=
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
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
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all the drivers which used .probe_capabilities converted to the
new c45 MDIO access methods, we can now decide based upon these whether
a bus driver supports c45 and we can get rid of the not widely used
probe_capabilites.

Unfortunately, due to a now broader support of c45 scans, this will
trigger a bug on some boards with a (c22-only) Micrel PHY. These PHYs
don't ignore c45 accesses correctly, thinking they are addressed
themselves and distrupt the MDIO access. To avoid this, a blacklist
for c45 scans is introduced.

To: Heiner Kallweit <hkallweit1@gmail.com>
To: Russell King <linux@armlinux.org.uk>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
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
To: Joel Stanley <joel@jms.id.au>
To: Andrew Jeffery <andrew@aj.id.au>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-aspeed@lists.ozlabs.org
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>

---
- Link to v1: https://lore.kernel.org/r/20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc

---
Andrew Lunn (6):
      net: mdio: Move mdiobus_scan() within file
      net: mdio: Rework scanning of bus ready for quirks
      net: mdio: Add workaround for Micrel PHYs which are not C45 compatible
      net: mdio: scan bus based on bus capabilities for C22 and C45
      net: phy: Decide on C45 capabilities based on presence of method
      net: phy: Remove probe_capabilities

 drivers/net/ethernet/adi/adin1110.c               |   1 -
 drivers/net/ethernet/freescale/xgmac_mdio.c       |   1 -
 drivers/net/ethernet/marvell/pxa168_eth.c         |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c       |   1 -
 drivers/net/ethernet/microchip/lan743x_main.c     |   2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |   3 -
 drivers/net/mdio/mdio-aspeed.c                    |   1 -
 drivers/net/phy/mdio_bus.c                        | 197 +++++++++++++++-------
 drivers/net/phy/phy_device.c                      |   2 +-
 include/linux/micrel_phy.h                        |   2 +
 include/linux/phy.h                               |  10 +-
 11 files changed, 140 insertions(+), 82 deletions(-)
---
base-commit: c12e2e5b76b2e739ccdf196bee960412b45d5f85
change-id: 20230116-net-next-remove-probe-capabilities-03d401439fc6

Best regards,
-- 
Michael Walle <michael@walle.cc>
