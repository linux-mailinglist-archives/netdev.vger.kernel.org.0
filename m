Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7AD426806
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbhJHKhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:37:07 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:33579 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhJHKhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:37:05 -0400
Received: (Authenticated sender: herve.codina@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPA id 2C3CF240009;
        Fri,  8 Oct 2021 10:35:07 +0000 (UTC)
From:   Herve Codina <herve.codina@bootlin.com>
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 0/4] net: stmmac: fix regression on SPEAr3xx SOC
Date:   Fri,  8 Oct 2021 12:34:36 +0200
Message-Id: <20211008103440.3929006-1-herve.codina@bootlin.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethernet driver used on old SPEAr3xx soc was previously supported on old
kernel. Some regressions were introduced during the different updates leading
to a broken driver for this soc.

This series fixes these regressions and brings back ethernet on SPEAr3xx.
Tested on a SPEAr320 board.

Herve Codina (4):
  net: stmmac: fix get_hw_feature() on old hardware
  dt-bindings: net: snps,dwmac: add dwmac 3.40a IP version
  net: stmmac: add support for dwmac 3.40a
  ARM: dts: spear3xx: Fix gmac node

 .../devicetree/bindings/net/snps,dwmac.yaml         |  2 ++
 arch/arm/boot/dts/spear3xx.dtsi                     |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c | 13 +++++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c    |  6 ++++--
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  |  6 ++++--
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |  6 +++---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c   |  8 ++++++++
 8 files changed, 34 insertions(+), 10 deletions(-)

-- 
2.31.1

