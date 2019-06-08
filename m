Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB2239F18
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfFHLyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727619AbfFHLke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CBA121726;
        Sat,  8 Jun 2019 11:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994034;
        bh=fGkjKiQfawmic6BBanSd1Vtb2m0w+VoWvZ0ZFBjSH7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jp5yBtlF6vZU4dcigaqP2fBka9lJjkcBY1lokX6GvVgKRbJid1sZlyXyTKG0ahht4
         CYl6iiCeIiUXO6EwmYNuREgC/J5KrUguoLC8dFwWPpTlYpryL6sX202rATrS2E6dFY
         h7k2/VW1aF+Z8SGMJhMtnsBxVEfAaLFK7/2iL+L0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biao Huang <biao.huang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 28/70] net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio read/write fail
Date:   Sat,  8 Jun 2019 07:39:07 -0400
Message-Id: <20190608113950.8033-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>

[ Upstream commit f4ca7a9260dfe700f2a16f0881825de625067515 ]

1. the frequency of csr clock is 66.5MHz, so the csr_clk value should
be 0 other than 5.
2. the csr_clk can be got from device tree, so remove initialization here.

Fixes: 9992f37e346b ("stmmac: dwmac-mediatek: add support for mt2712")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index bf2562995fc8..126b66bb73a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -346,8 +346,6 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 		return PTR_ERR(plat_dat);
 
 	plat_dat->interface = priv_plat->phy_mode;
-	/* clk_csr_i = 250-300MHz & MDC = clk_csr_i/124 */
-	plat_dat->clk_csr = 5;
 	plat_dat->has_gmac4 = 1;
 	plat_dat->has_gmac = 0;
 	plat_dat->pmt = 0;
-- 
2.20.1

