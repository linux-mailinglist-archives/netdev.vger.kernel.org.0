Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9471CC2E
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfENPqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:46:48 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:35820 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726406AbfENPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:45:42 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 00A99C019E;
        Tue, 14 May 2019 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557848732; bh=4mT+CT/Y/eN1ccimNjL9XsPYGjFtt8YEZq6/C+Bm3Mw=;
        h=From:To:Cc:Subject:Date:From;
        b=Etajpdh84QTRJ5YQGyMqZ0UIypNAEH5MUjYIISSVeujbtU4F4zHpIqz3q28QT52Ss
         yo+KkBRfIaZkLwDrxHwsPg1GCQwKltT1JHd2kIGs1/8jHCr3f2j6EUsZuUau28yXLG
         LNZYSufovBZdvR6t/NDy1eHWtbXdjADu9zB7YFGhFHfmP5CBDbf96dcE6mbHR+oyV5
         vfwz2YtbTx98oHUEBGLrWpIrZbALyvMZP7Ehlf035QhGYdJYUHwJ0sg0jHslKNMCtQ
         ERprrCf+jkeRfyQtIQ3/qZTPbw5qwm46QG+gNLh6mGFhmuRtoCeBjYh4PtLXCDEZ/V
         mDZHIa6HaxgNQ==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 10FC9A0244;
        Tue, 14 May 2019 15:45:39 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 0A82A3EA09;
        Tue, 14 May 2019 17:45:39 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC net-next v2 00/14] net: stmmac: Selftests
Date:   Tue, 14 May 2019 17:45:22 +0200
Message-Id: <cover.1557848472.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Submitting with net-next closed for proper review and testing. ]

This introduces selftests support in stmmac driver. We add 9 basic sanity
checks and MAC loopback support for all cores within the driver. This way
more tests can easily be added in the future and can be run in virtually
any MAC/GMAC/QoS/XGMAC platform.

Having this we can find regressions and missing features in the driver
while at the same time we can check if the IP is correctly working.

We have been using this for some time now and I do have more tests to
submit in the feature. My experience is that although writing the tests
adds more development time, the gain results are obvious.

I let this feature optional within the driver under a Kconfig option.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>

Corentin Labbe (1):
  net: ethernet: stmmac: dwmac-sun8i: Enable control of loopback

Jose Abreu (13):
  net: stmmac: Add MAC loopback callback to HWIF
  net: stmmac: dwmac100: Add MAC loopback support
  net: stmmac: dwmac1000: Add MAC loopback support
  net: stmmac: dwmac4/5: Add MAC loopback support
  net: stmmac: dwxgmac2: Add MAC loopback support
  net: stmmac: Switch MMC functions to HWIF callbacks
  net: stmmac: dwmac1000: Also pass control frames while in promisc mode
  net: stmmac: dwmac4/5: Also pass control frames while in promisc mode
  net: stmmac: dwxgmac2: Also pass control frames while in promisc mode
  net: stmmac: Introduce selftests support
  net: stmmac: dwmac1000: Fix Hash Filter
  net: stmmac: dwmac1000: Clear unused address entries
  net: stmmac: dwmac4/5: Fix Hash Filter

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   2 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  13 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  22 +-
 .../net/ethernet/stmicro/stmmac/dwmac100_core.c    |  13 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  19 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   2 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  15 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   9 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  21 +
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |   4 -
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |  13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  22 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 846 +++++++++++++++++++++
 19 files changed, 1014 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c

-- 
2.7.4

