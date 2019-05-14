Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAFE1C956
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 15:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfENNXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 09:23:31 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:39837 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbfENNXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 09:23:30 -0400
Received: from [109.168.11.45] (port=60568 helo=pc-ceresoli.dev.aim)
        by hostingweb31.netsons.net with esmtpa (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1hQXOp-00FJWI-FG; Tue, 14 May 2019 15:23:19 +0200
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     netdev@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        "Nicolas . Ferre" <Nicolas.Ferre@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        "shubhrajyoti . datta @ xilinx . com" <shubhrajyoti.datta@xilinx.com>,
        Harini Katakam <harini.katakam@xilinx.com>
Subject: [PATCH net RESEND] net: macb: fix error format in dev_err()
Date:   Tue, 14 May 2019 15:23:07 +0200
Message-Id: <20190514132307.15311-1-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Errors are negative numbers. Using %u shows them as very large positive
numbers such as 4294967277 that don't make sense. Use the %d format
instead, and get a much nicer -19.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Fixes: b48e0bab142f ("net: macb: Migrate to devm clock interface")
Fixes: 93b31f48b3ba ("net/macb: unify clock management")
Fixes: 421d9df0628b ("net/macb: merge at91_ether driver into macb driver")
Fixes: aead88bd0e99 ("net: ethernet: macb: Add support for rx_clk")
Fixes: f5473d1d44e4 ("net: macb: Support clock management for tsu_clk")
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---

No content change. Resending with 'net' in the subject and with Fixes: tags
as suggested by Andrew Lunn. There are many because the error was added
once and replicated while adding more dev_err() lines. Also adding
Acked/Reviewed-by: tags got in the meanwhile.
---
 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c049410bc888..bebd9b1aeb64 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3343,7 +3343,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get macb_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
 		return err;
 	}
 
@@ -3352,7 +3352,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
 		return err;
 	}
 
@@ -3370,31 +3370,31 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
 	err = clk_prepare_enable(*hclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable hclk (%d)\n", err);
 		goto err_disable_pclk;
 	}
 
 	err = clk_prepare_enable(*tx_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable tx_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable tx_clk (%d)\n", err);
 		goto err_disable_hclk;
 	}
 
 	err = clk_prepare_enable(*rx_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable rx_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable rx_clk (%d)\n", err);
 		goto err_disable_txclk;
 	}
 
 	err = clk_prepare_enable(*tsu_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable tsu_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable tsu_clk (%d)\n", err);
 		goto err_disable_rxclk;
 	}
 
@@ -3868,7 +3868,7 @@ static int at91ether_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
-- 
2.21.0

