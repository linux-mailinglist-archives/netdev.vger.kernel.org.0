Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126FC5E22D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfGCKiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:38:00 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:40264 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726957AbfGCKh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 06:37:59 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1C1DAC2B74;
        Wed,  3 Jul 2019 10:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562150278; bh=YuAWET3ywOVQCjdj+L6B5IMUgwZSEh23haYiO+SltPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=eLUuaG9UTI3/AeUg1PUBC/D1IYEvwxbCUsFEN64CmAt2s/lJoosGdPEQqyM/MdQR/
         zrw/SpP0zvBj2qB/7F53I8oMEQOlgPjONkZ3Uer3cYdCqoEhaXiCNDfz/uH7JeWNVc
         PuKFiiRoOO1MbtuSo3Cqzc0rYqoGdsyMoID87W1NxmnjYWSA0mlLX0IYKKJBQcbsmC
         HvND2UQqnief8mBgFIOzwN+9cizONk9kE7NGkAvvXJh4G1vwH45B/BkjxnBUtComcC
         Bvu3GVLXihH8mSCGOMSVv6Vf8SupkWRtjYLlL7cn7kFjabgYQRBx2OJu/hiSNKlf/k
         Vp4yF0X1Y38hg==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6580CA0062;
        Wed,  3 Jul 2019 10:37:54 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 2D7AF3E573;
        Wed,  3 Jul 2019 12:37:54 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH net-next 0/3] net: stmmac: Some performance improvements and a fix
Date:   Wed,  3 Jul 2019 12:37:47 +0200
Message-Id: <cover.1562149883.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some performace improvements (01/03 and 03/03) and a fix (02/03), all for -next.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>

Jose Abreu (3):
  net: stmmac: Implement RX Coalesce Frames setting
  net: stmmac: Fix descriptors address being in > 32 bits address space
  net: stmmac: Introducing support for Page Pool

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  10 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  12 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 210 +++++++--------------
 12 files changed, 107 insertions(+), 172 deletions(-)

-- 
2.7.4

