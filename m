Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9E1F1968
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbfKFPDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:03:14 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43094 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731944AbfKFPDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:03:12 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C994DC0486;
        Wed,  6 Nov 2019 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573052592; bh=GRMw5KsuEu3tCfQdQK07Pp1yvOjWXrXvCMdDCR8/7Rs=;
        h=From:To:Cc:Subject:Date:From;
        b=QVd8rwFitMwUxrJM2ueIli+P/H09CxFhXntduV37l53PAcTPAxJa1NCY3Pb9TZG1z
         qp1d+dlFLmdbvhTqAQmBuNK6f67Y/O8EcKTv5BIwWYCmr2v2sFMuS53LGkZhm+CX5T
         MsIwUi3ppwpkWyfKIKESa+lNzFP2fJ6pGSNxG0ufXoKToDvI0JtLUvLy2AqnhL7CRD
         C8G2lU05O5C/xAvKxDMFPiCS8GAQqV/rjzZ0iyUSAAG8FdIzLsTChmkSB0SKzJKJkI
         mfmE4wJOuzl2/JmN53EM304nOMEZpRVQXS2xgRh/G18rfg1xZrU9oDYCC5kOSHq/Al
         hhWGhu8WRMryA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A99C6A005D;
        Wed,  6 Nov 2019 15:03:09 +0000 (UTC)
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
Subject: [PATCH net 00/11] net: stmmac: Fixes for -net
Date:   Wed,  6 Nov 2019 16:02:54 +0100
Message-Id: <cover.1573052378.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc fixes for stmmac.

Patch 1/11 and 2/11, use the correct variable type for bitrev32() calls.

Patch 3/11, fixes the random failures the we were seing when running selftests.

Patch 4/11, prevents a crash that can occur when receiving AVB packets and with
SPH feature enabled on XGMAC.

Patch 5/11, fixes the correct settings for CBS on XGMAC.

Patch 6/11, corrects the interpretation of AVB feature on XGMAC.

Patch 7/11, disables Flow Control for AVB enabled queues on XGMAC.

Patch 8/11, disables MMC interrupts on XGMAC, preventing a storm of interrupts.

Patch 9/11, fixes the number of packets that were being taken into account in
the RX path cleaning function.

Patch 10/11, fixes an incorrect descriptor setting that could cause IP
misbehavior.

Patch 11/11, fixes the IOC generation mechanism when multiple descriptors
are used.

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

Jose Abreu (11):
  net: stmmac: gmac4: bitrev32 returns u32
  net: stmmac: xgmac: bitrev32 returns u32
  net: stmmac: selftests: Prevent false positives in filter tests
  net: stmmac: xgmac: Only get SPH header len if available
  net: stmmac: xgmac: Fix TSA selection
  net: stmmac: xgmac: Fix AV Feature detection
  net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in
    AV
  net: stmmac: xgmac: Disable MMC interrupts by default
  net: stmmac: Fix the packet count in stmmac_rx()
  net: stmmac: Fix TSO descriptor with Enhanced Addressing
  net: stmmac: Fix the TX IOC in xmit path

 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   3 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  70 ++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 134 +++++++++++++++------
 7 files changed, 144 insertions(+), 78 deletions(-)

-- 
2.7.4

