Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3EA2C4326
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgKYPgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:36:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730481AbgKYPgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2642C21527;
        Wed, 25 Nov 2020 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318573;
        bh=XU355mrKT77scx7mv1cBMHYh9RK2g5pjjm9Cv/KA7NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0m8h0QYf3P/Ojf7ahSqHVDZO1MHeGlQqclMzp1jkKl9zhewylrVT1Ig4Zq4pN2fyI
         9IgpJob3VyqxS2pIflfFRAu+gn4lQhrEOxHGeMVY+8OQdTHp/A+HdLflYHlgeujdem
         V/wOzq7MwDx1X2RXr9KzL4U/97+Frhl4RMmh6qMM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 17/33] net: stmmac: dwmac_lib: enlarge dma reset timeout
Date:   Wed, 25 Nov 2020 10:35:34 -0500
Message-Id: <20201125153550.810101-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 56311a315da7ebc668dbcc2f1c99689cc10796c4 ]

If the phy enables power saving technology, the dwmac's software reset
needs more time to complete, enlarge dma reset timeout to 200000us.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Link: https://lore.kernel.org/r/20201113090902.5c7aab1a@xhacker.debian
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index cb87d31a99dfb..57a53a600aa55 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -23,7 +23,7 @@ int dwmac_dma_reset(void __iomem *ioaddr)
 
 	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
 				 !(value & DMA_BUS_MODE_SFT_RESET),
-				 10000, 100000);
+				 10000, 200000);
 }
 
 /* CSR1 enables the transmit DMA to check for new descriptor */
-- 
2.27.0

