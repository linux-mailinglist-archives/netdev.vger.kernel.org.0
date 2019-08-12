Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC1F89A2E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfHLJod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:44:33 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:35332 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727612AbfHLJoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:44:30 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7FC1DC21DB;
        Mon, 12 Aug 2019 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565603069; bh=NmX8XhNa7Yyj0AxzvLSwb00xjlHeMa4pt6SjJT15Duc=;
        h=From:To:Cc:Subject:Date:From;
        b=lbK+nvM84AiTIyQALrUBPzY3qhpsKJeh7YtMIojwkkFDT10ox6TGJHtrqZHBnlqR+
         r38hAbmG+8J82BfSoiqg0mFZtAYhoJ3l1wdMvaZpL2AOmKNB85rGrSd9yd2REBeF0h
         p+gIiXLodAFmiwbjge1+XD4i/dKA6M9Bo+s3qTW1XDk1J8B2C9hzW/pjrakMqxNUCb
         2rT9Ba+/5X87/g242ocQ9vNNF11/ZAoSFBsKbe+KzV+VzJtHmmHawB3VcnEXFAQiuJ
         BeS4CVaoX+hk+GNRdJE7YuimD8HIV3EqpD4qWTDcK199FTtwicCDpLinI57PdNt32E
         S9IeUC7gq473g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 2E897A0057;
        Mon, 12 Aug 2019 09:44:21 +0000 (UTC)
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
Subject: [PATCH net-next v2 00/12] net: stmmac: Improvements for -next
Date:   Mon, 12 Aug 2019 11:43:59 +0200
Message-Id: <cover.1565602974.git.joabreu@synopsys.com>
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

Jose Abreu (12):
  net: stmmac: Get correct timestamp values from XGMAC
  net: stmmac: Prepare to add Split Header support
  net: stmmac: xgmac: Correctly return that RX descriptor is not last
    one
  net: stmmac: Add Split Header support and enable it in XGMAC cores
  net: stmmac: Add a counter for Split Header packets
  net: stmmac: dwxgmac: Add Flexible PPS support
  net: stmmac: Add ethtool register dump for XGMAC cores
  net: stmmac: Add support for SA Insertion/Replacement in XGMAC cores
  net: stmmac: selftests: Add tests for SA Insertion/Replacement
  net: stmmac: xgmac: Add EEE support
  net: stmmac: Add support for VLAN Insertion Offload
  net: stmmac: selftests: Add selftest for VLAN TX Offload

 drivers/net/ethernet/stmicro/stmmac/common.h       |  10 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  56 ++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 182 ++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |  88 ++++++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  31 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  30 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  10 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  25 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 287 ++++++++++++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 194 +++++++++++++-
 10 files changed, 822 insertions(+), 91 deletions(-)

-- 
2.7.4

