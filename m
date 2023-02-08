Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4040D68F36F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjBHQkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjBHQk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:40:26 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EC04E52E;
        Wed,  8 Feb 2023 08:40:18 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3F2E61BF203;
        Wed,  8 Feb 2023 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675874417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5IY2oVgOi4BwHuNcg4KU4s9e+YaMLKjv+djWjs2zE1w=;
        b=YHiMew4DDTZtKpK+kkFnUpmCk7lw8g0jZdCSDsSaqdQQq41UeOHj64XUJU2xIzLcRCqk5j
        ryzVtL4vpTCRqV3n2+qLfHTGZjD0m/jWjwkw3FJonsPB/4yOPW0igeoUc22KYAMTqjZAWN
        y9odpyZZD91wXeqcpp1YzOWp2KlTXlaAlgDL96uMKAeN9dESGXYi07M78eMb+lP7lJ7ILK
        48xEeUMt8Hs2pYz8mEvdJqPc+/LWJREwJrEA7L/NwacSCeA4Ak25IIYXcZZQos0Q4o52fA
        zzxCB8Giv06zfY5pokELEaoquFEDxYHpbBPqXfFmHRAKjAFrjtCNqlW8ZQROOw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next v2 0/6] net: stmmac: add renesas,rzn1-gmac support
Date:   Wed,  8 Feb 2023 17:41:57 +0100
Message-Id: <20230208164203.378153-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rzn1-gmac instance is connected to a PCS (MIIC). In order to use
this pcs, add support in the sttmac driver to set a generic phylink pcs
device instead of the xpcs only. Moreover, it adds support to provide
a phylink pcs device from the stmmac platform data and use it with the
driver. It also adds the bindings and the new rzn1-gmac driver that
retrieve this pcs from the device-tree.

---
V2:
 - Remove patch that moves phylink_start() earlier in init
 - Add miic_early_qsetup()  which allows initializing some miic port
   earlier to provide a RX clock to stmmac IP
 - Call miic_early_setup() in rzn1 stmmac driver
 - Fix bindings

Clément Léger (6):
  net: pcs: rzn1-miic: add pcs_early_setup() function
  net: stmmac: add support to use a generic phylink_pcs as PCS
  net: stmmac: add support to provide pcs from platform data
  dt-bindings: net: renesas,rzn1-gmac: Document RZ/N1 GMAC support
  net: stmmac: add support for RZ/N1 GMAC
  ARM: dts: r9a06g032: describe GMAC1

 .../bindings/net/renesas,rzn1-gmac.yaml       |  67 ++++++++++
 arch/arm/boot/dts/r9a06g032.dtsi              |  18 +++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-rzn1.c  | 120 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   1 +
 drivers/net/pcs/pcs-rzn1-miic.c               |  12 ++
 include/linux/pcs-rzn1-miic.h                 |   3 +
 include/linux/stmmac.h                        |   1 +
 11 files changed, 240 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c

-- 
2.39.0

