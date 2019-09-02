Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21174A50AA
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbfIBICY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:02:24 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51490 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730129AbfIBICW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:22 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6F353C0419;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411341; bh=4COHdtFTDR5TsR1zywo8dHE+8UKYJjqPIwYaAeI8pyg=;
        h=From:To:Cc:Subject:Date:From;
        b=DdkuJriaM4/aER3fqZqTEzsnXsx/AYp8+0gwL4/R1QSKZdpQ4VDvIQoDtXxnajxWY
         QWqH/Jd2Cm7MCiYHVvHZHpE7x1W98KFZXd/Mmvc9X0v8L7IZUnT/YSyaNlzH6bs0zm
         DMAZGAj5S9eBhlGmaT8koMqisB5MUhMRJCvOhVAfggtgCSd9fKppePInaeA1w8JJT8
         aiauR+ka1H54huxYDQCzigw+LIF5cJxH/sFaCr8xGdmuRDhFguE8PHBPG2yP6MQLn3
         tu1BtfSdmSNXaR3Pm9VBnF6c+5HgGIskIU1Wwsap85x6ylRG6Upej8jydAL8hwgG03
         CzXInQL34H5lg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4F684A0063;
        Mon,  2 Sep 2019 08:02:14 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/13] net: stmmac: Improvements for -next
Date:   Mon,  2 Sep 2019 10:01:42 +0200
Message-Id: <cover.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple of improvements for -next tree. More info in commit logs. Some of them
includes fixes for features that are only in -next tree.

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

Jose Abreu (13):
  net: stmmac: selftests: Return proper error code to userspace
  net: stmmac: xgmac: Add RBU handling in DMA interrupt
  net: stmmac: Do not return error code in TC Initialization
  net: stmmac: Implement L3/L4 Filters using TC Flower
  net: stmmac: selftests: Add selftest for L3/L4 Filters
  net: stmmac: xgmac: Implement ARP Offload
  net: stmmac: selftests: Implement the ARP Offload test
  net: stmmac: Only consider RX error when HW Timestamping is not
    enabled
  net: stmmac: ethtool: Let user configure TX coalesce without RIWT
  net: stmmac: xgmac: Correct RAVSEL field interpretation
  net: stmmac: Correctly assing MAX MTU in XGMAC cores case
  net: stmmac: xgmac: Enable RX Jumbo frame support
  net: stmmac: selftests: Add Jumbo Frame tests

 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  33 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 205 +++++++++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   8 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  19 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  12 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  21 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  18 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 451 ++++++++++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 247 ++++++++++-
 10 files changed, 969 insertions(+), 47 deletions(-)

-- 
2.7.4

