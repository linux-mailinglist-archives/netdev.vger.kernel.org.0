Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D09846A8
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfHGID3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:03:29 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:33668 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728078AbfHGID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:03:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9135FC0BBE;
        Wed,  7 Aug 2019 08:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565165008; bh=bHZeuqh+A4HXIxvR7wW8nFizE/h0mhPF5BRmuOVjENw=;
        h=From:To:Cc:Subject:Date:From;
        b=jRTcCVg+hjilIDAzB0b/6j2tuuirHwQ26dmyfMl8cky41nMHGV4s/V6egPWmw/kG8
         YLleJaVQjG+OG/A1fRPUcdLEw/3wu6dSFUk9nFOTi/vkxm+yUugykBept9oTcSRbZq
         YXhUPAXdjc52+T1quqZKngZvWyfefdXmZQwiN49UxxalxH6LyCjVg3UCTIyU0r63Ar
         Y5pZOstknQDF6g4y+dKc09GZK2alU0Xa68p5VJxbaxzbi95Uj2BgkVsKXiEMHqCis6
         f9fPLrQvCZvhk4SJrrLKlKBpSEHHvRcpUD9rK5bza2pg5e6gaLeDHva93NgQyVM3Vf
         JhqajgFIpezcg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 883C7A0057;
        Wed,  7 Aug 2019 08:03:25 +0000 (UTC)
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
Subject: [PATCH net-next v3 00/10] net: stmmac: Improvements for -next
Date:   Wed,  7 Aug 2019 10:03:08 +0200
Message-Id: <cover.1565164729.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ This is just a rebase of v2 into latest -next in order to avoid a merge
conflict ]

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

Jose Abreu (10):
  net: stmmac: xgmac: Implement MMC counters
  net: stmmac: xgmac: Implement set_mtl_tx_queue_weight()
  net: stmmac: xgmac: Implement tx_queue_prio()
  net: stmmac: Implement RSS and enable it in XGMAC core
  net: stmmac: selftests: Add RSS test
  net: stmmac: Implement VLAN Hash Filtering in XGMAC
  net: stmmac: selftests: Add test for VLAN and Double VLAN Filtering
  net: stmmac: Implement Safety Features in XGMAC core
  net: stmmac: Add Flexible RX Parser support in XGMAC
  net: stmmac: selftests: Add a selftest for Flexible RX Parser

 drivers/net/ethernet/stmicro/stmmac/common.h       |   6 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  76 ++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 605 ++++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |  29 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  10 +
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  17 +
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |   9 +
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     | 192 +++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  11 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  81 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 120 +++-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 322 ++++++++++-
 include/linux/stmmac.h                             |   1 +
 14 files changed, 1474 insertions(+), 9 deletions(-)

-- 
2.7.4

