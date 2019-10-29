Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49D6E8A7A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbfJ2OP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:15:29 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:53394 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389207AbfJ2OPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:15:20 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3731FC04BB;
        Tue, 29 Oct 2019 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572358520; bh=nGvMdw6v8QDeKK9JnNRRIrf2w9HChn1Wdr+DNEOBHYA=;
        h=From:To:Cc:Subject:Date:From;
        b=iNG18OtbHULWKiWvg4ptyuJZJ/uwepsJ4ZxfBLvqzEPhb6abo/kHUWLbhYAev+oYm
         mAsJiltcGBwyFA0hqWlhQ9D7f1WoSnonrGO1w604iQQEH9JFOrkj2SAveDuU6AVn+m
         a07foVBen1Qu8Ie+fjtuv0utJN9SvCUbfryp5dlPfOg4p+8gl37g3WYUY++x8FDpWc
         wuGaWTo7OO1LzTcG+M0TA6XBfnZ0TZDOWq9dY6zKG6w4BXhkekfjCgJLD5KyPb/IJH
         a4MRmhkwRsbWhKktXJ1/X4g5m3B0MFTyn50B91Gf5oqfL+2YrLcTZlR9WMdf7+bCMZ
         LSqW4UXNqJx1A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id BA0ECA0057;
        Tue, 29 Oct 2019 14:15:08 +0000 (UTC)
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
Subject: [PATCH net 0/9] net: stmmac: Fixes for -net
Date:   Tue, 29 Oct 2019 15:14:44 +0100
Message-Id: <cover.1572355609.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc fixes for stmmac.

Patch 1/9, corrects a sparse warning reported by kbuild.

Patch 2/9 and 3/9, use the correct variable type for bitrev32() calls.

Patch 4/9, fixes the random failures the we were seing when running selftests.

Patch 5/9, prevents a crash that can occur when receiving AVB packets and with
SPH feature enabled on XGMAC.

Patch 6/9, fixes the correct settings for CBS on XGMAC.

Patch 7/9, corrects the interpretation of AVB feature on XGMAC.

Patch 8/9, disables Flow Control for AVB enabled queues on XGMAC.

Patch 9/9, disables MMC interrupts on XGMAC, preventing a storm of interrupts.

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

Jose Abreu (9):
  net: stmmac: Fix sparse warning
  net: stmmac: gmac4: bitrev32 returns u32
  net: stmmac: xgmac: bitrev32 returns u32
  net: stmmac: selftests: Must remove UC/MC addresses to prevent false
    positives
  net: stmmac: xgmac: Only get SPH header len if available
  net: stmmac: xgmac: Fix TSA selection
  net: stmmac: xgmac: Fix AV Feature detection
  net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in
    AV
  net: stmmac: xgmac: Disable MMC interrupts by default

 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   5 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 104 +++++++++++++++------
 8 files changed, 94 insertions(+), 39 deletions(-)

-- 
2.7.4

