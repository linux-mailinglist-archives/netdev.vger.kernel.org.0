Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C041244AA
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfLRKdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:33:39 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:46438 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbfLRKdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:33:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BF0BA40346;
        Wed, 18 Dec 2019 10:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576665201; bh=0M9mYY6dp+dohtIQdCtyeu3ar+st+lmwIwwIyzmrtEs=;
        h=From:To:Cc:Subject:Date:From;
        b=Oqr9YdTMq7rKi76ubUYqeeAZPBqhy9xYt+pcgaPQCjCillvkAX8cd7xDoBVbKNIiA
         wZXIGHoXGM0um9oi7FSdwc2DzhHbNbNlGI2fWta06r9fospEE/vrMjUPZ01GFGKNiC
         DLSN3H7FvMmlySIuSFqXTw539a/5mjdzzCrENMCE3FHojVZYb33YR0CvKOTlSc52Y6
         62EsFBN7cxGhI36BwclRX2ZoYWlB1z7NkQHG3olyty1PttwTygNL7jBca2JWY9xKc0
         z7TriHFtjmqZDNiWMJLUICYE73uXk1SWxqJqmHDnmMXghTp+TvsgdbGN0wBpqGSHNx
         LGxrRd7SU0pCQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 68555A0066;
        Wed, 18 Dec 2019 10:33:18 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Richard.Ong@synopsys.com, Boon Leong <boon.leong.ong@intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: stmmac: TSN support using TAPRIO API
Date:   Wed, 18 Dec 2019 11:33:04 +0100
Message-Id: <cover.1576664870.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds TSN support (EST and Frame Preemption) for stmmac driver.

1) Adds the HW specific support for EST in GMAC5+ cores.

2) Adds the HW specific support for EST in XGMAC3+ cores.

3) Integrates EST HW specific support with TAPRIO scheduler API.

4) Adds the Frame Preemption suppor on stmmac TAPRIO implementation.

5) Adds the HW specific support for Frame Preemption in GMAC5+ cores.

6) Adds the HW specific support for Frame Preemption in XGMAC3+ cores.

7) Adds support for HW debug counters for Frame Preemption available in
GMAC5+ cores.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (7):
  net: stmmac: Add basic EST support for GMAC5+
  net: stmmac: Add basic EST support for XGMAC
  net: stmmac: Integrate EST with TAPRIO scheduler API
  net: stmmac: Add Frame Preemption support using TAPRIO API
  net: stmmac: gmac5+: Add support for Frame Preemption
  net: stmmac: xgmac3+: Add support for Frame Preemption
  net: stmmac: mmc: Add Frame Preemption counters on GMAC5+ cores

 drivers/net/ethernet/stmicro/stmmac/common.h       |   5 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |  12 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   4 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   4 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       | 118 ++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h       |  24 ++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  25 ++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  76 ++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   4 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  14 +++
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |  16 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 135 +++++++++++++++++++++
 include/linux/stmmac.h                             |  13 ++
 14 files changed, 452 insertions(+)

-- 
2.7.4

