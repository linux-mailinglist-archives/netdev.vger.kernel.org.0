Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CCAF76BC
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKOnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:43:00 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:55136 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726908AbfKKOm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:42:59 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6123CC08B7;
        Mon, 11 Nov 2019 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573483379; bh=xvb79Aahx3jHaPdlZ0qpbSpWPSpjW4NAZIBnGit7MJA=;
        h=From:To:Cc:Subject:Date:From;
        b=mG7s8u/tskFiKSC2onN0QpZIETTM+suYlB3kuRs5z62CfC+EBLVrJpy691KgkU4ZH
         dqPNNGQLN06Jtvax8ZZPn9GeYsGEO17CuntaAdQmN7uBDg3iWILoptfhAh9kr8JL8S
         ekJ680+kU+Jf1MV26oK/somYcDE/MhNlDvJd+18PwN2cGxv3tYhsXt4FdoTokH9PCo
         pyJd6pNm3tbGqGk2OcMH1A5h5j6bcM/uzXfO01MHB8rZl1HEG2j82BwuPZIPlrtAtU
         8QmjqhnS8crQKjDWYT39sUXXwMwqPqrRgC1ACP+mXEGQLmSwM7ModWHwaZiidNeEbH
         qYpcXxe6rxqRA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C4B41A01EF;
        Mon, 11 Nov 2019 14:42:50 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: stmmac: Improvements for -next
Date:   Mon, 11 Nov 2019 15:42:33 +0100
Message-Id: <cover.1573482991.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc improvements for stmmac.

Patch 1/6, fixes a sparse warning that was introduced in recent commit in
-next.

Patch 2/6, adds the Split Header support which is also available in XGMAC
cores and now in GMAC4+ with this patch.

Patch 3/6, adds the C45 support for MDIO transactions when using XGMAC cores.

Patch 4/6, removes the speed dependency on CBS callbacks so that it can be used
in XGMAC cores.

Patch 5/6, reworks the over-engineered stmmac_rx() function so that its easier
to read.

Patch 6/6, implements the UDP Segmentation Offload feature in GMAC4+ cores.

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

Jose Abreu (6):
  net: stmmac: Fix sparse warning
  net: stmmac: gmac4+: Add Split Header support
  net: stmmac: xgmac: Add C45 PHY support in the MDIO callbacks
  net: stmmac: tc: Remove the speed dependency
  net: stmmac: Rework stmmac_rx()
  net: stmmac: Implement UDP Segmentation Offload

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |  21 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  19 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |   1 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 183 ++++++++++++++-------
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |  58 +++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   2 -
 11 files changed, 217 insertions(+), 81 deletions(-)

-- 
2.7.4

