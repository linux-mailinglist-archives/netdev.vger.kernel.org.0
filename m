Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFA4292D4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbfEXIUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:20:43 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:38330 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389566AbfEXIUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:42 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 64DF2C012D;
        Fri, 24 May 2019 08:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686027; bh=pTugxC0xi6tYCnoQGaHnrYQc67+/MuULJSrDVJlby38=;
        h=From:To:Cc:Subject:Date:From;
        b=Mzx7ypakxqoo6XQJtzXNgeTfh9n4JMJk1vFytFhri/GuK8SVtfuxaG1exRQkNF41o
         BjcIMqm+8Xt5d7PrxO3I5bzWiVYC55vuqUKfQvZGqfk4uhwiQi45Ezu6xiiS1NXe/X
         XHIX0TPBF1HTyrNco8jghEYfoc5rUxrF7xARQUQKPxSQWoAOT0E7JWI165rjNULOGw
         Yi8zvTCllYxW3J2R5llFRraOjIXCim+HJsw5Pg/rge2b2ntkXcL1WKLTcxzreG5/Gg
         kOY+SMwQQtDYAbVeAjid319HKIGaxDfYH2Ju8EoQ3SUhPIN7gTJFk7hr+TDVpsYIQZ
         vOCQafWJqhW2w==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 686A2A00AA;
        Fri, 24 May 2019 08:20:36 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 4A8853FAE9;
        Fri, 24 May 2019 10:20:35 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 00/18] net: stmmac: Improvements and Selftests
Date:   Fri, 24 May 2019 10:20:08 +0200
Message-Id: <cover.1558685827.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Thanks to the introducion of selftests this series ended up being a misc
of improvements and the selftests additions per-se. ]

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

Jose Abreu (17):
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
  net: stmmac: dwmac4/5: Do not disable whole RX in dma_stop_rx()
  net: stmmac: dwxgmac2: Do not disable whole RX in dma_stop_rx()
  net: stmmac: dwmac4/5: Clear unused address entries
  net: stmmac: Prevent missing interrupts when running NAPI

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   2 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  13 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  22 +-
 .../net/ethernet/stmicro/stmmac/dwmac100_core.c    |  13 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  29 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   4 -
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   2 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  15 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   4 -
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   9 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  21 +
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |   4 -
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |  13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  22 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 850 +++++++++++++++++++++
 21 files changed, 1029 insertions(+), 23 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c

-- 
2.7.4

