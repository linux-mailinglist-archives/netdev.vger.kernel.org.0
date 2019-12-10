Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B72119129
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLJTzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:55:01 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:45152 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbfLJTzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:55:00 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 79420C0B80;
        Tue, 10 Dec 2019 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576007700; bh=M/cwTD418HXN3ZYDrXvm66mfCePGTem77sm0VuzRvnI=;
        h=From:To:Cc:Subject:Date:From;
        b=Uu7ur+tWnfQV7PBhydZCGLaul9JV7TkAP4j6Q7kW6D+wOeM4sfpJedSnSUPmomo4y
         aZAbLKUccL9eBeU7xQhw8LdfRFd5kLM+Vw1b7zp3JPYN12EXU+PRKrpqmFmSDv46dc
         Gkn5ngK7H5Zwmwwq8BlsMfKO9tq9bEllJhLbCFXyWW++bTt7R421HGWXuBQUm39Z9G
         eBcjvwAzzy8DUTyMox9SCXCagWENJJgtx6xN4iuXdlUF56qTi3UUxQQN0FqBiiEXix
         eOT1HvArWJVJJN0XfyvB6HCCuyzFwIoYt9Out3ANHAfVDj770bXsGnYjiZyHZii24G
         FUJH4SsyatvJg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 214B7A005D;
        Tue, 10 Dec 2019 19:54:57 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: stmmac: Improvements for -next
Date:   Tue, 10 Dec 2019 20:54:40 +0100
Message-Id: <cover.1576007149.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improvements for stmmac.

1) Adds more information regarding HW Caps in the DebugFS file.

2) Prevents incostant bandwidth because of missing interrupts.

3) Allows interrupts to be independently enabled or disabled so that we don't
have to schedule both TX and RX NAPIs.

4) Stops using a magic number in coalesce timer re-arm.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (4):
  net: stmmac: Print more information in DebugFS DMA Capabilities file
  net: stmmac: Always arm TX Timer at end of transmission start
  net: stmmac: Let TX and RX interrupts be independently
    enabled/disabled
  net: stmmac: Always use TX coalesce timer value when rescheduling

 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  | 24 +++++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   | 11 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   | 47 +++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |  6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    | 22 ++++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  2 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 24 +++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 94 +++++++++++++++-------
 10 files changed, 183 insertions(+), 54 deletions(-)

-- 
2.7.4

