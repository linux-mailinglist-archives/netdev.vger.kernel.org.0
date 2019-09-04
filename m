Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B22A8443
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfIDNRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:17:16 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:33472 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729296AbfIDNRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:17:14 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 754F9C573D;
        Wed,  4 Sep 2019 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567603034; bh=m0FKVlQ3LYmFjKrpFGWx405TxbxntEzWiK7CqLuD+Lo=;
        h=From:To:Cc:Subject:Date:From;
        b=Ex1Hb+dmHc02GukpJLes2UZSljRIUwzCQcg0To9kjxphUB1VpAWd4NHLOsqQI+/HI
         bObZ0RaFww1z1fQhWGcxh4YJCkEp3kCuJ1/F9wveAF15yQvXtQERByeM2LhXcb/HHt
         UsXD2ZRg3nomsCzqG4qo9ZWhCus37Br8SXH1hReR11r+A+30zN396NUtAa3kIy2Klu
         /miHONSZ9p767M57c9sHx+D5RRrmaLLhXGkjsQvrhHTD2IaxNzuxb63sqa7kVIQZoj
         bTllNjRkKTUuztiSs1g8jPXcImygWx8RralUo6KVPA+8RNQ9rQtGcwZxJMUUTT32bp
         UUOYNEyZk1O2Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7C9EEA005E;
        Wed,  4 Sep 2019 13:17:11 +0000 (UTC)
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
Subject: [PATCH v2 net-next 00/13] net: stmmac: Improvements for -next
Date:   Wed,  4 Sep 2019 15:16:52 +0200
Message-Id: <cover.1567602867.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple of improvements for -next tree. More info in commit logs.

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
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 205 ++++++++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   8 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  19 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  12 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  21 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  18 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 483 ++++++++++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 247 ++++++++++-
 10 files changed, 1001 insertions(+), 47 deletions(-)

-- 
2.7.4

