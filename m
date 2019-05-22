Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3842126542
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 15:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfEVN4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 09:56:45 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:59606 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbfEVN4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 09:56:44 -0400
Received: from sapphire.lan (unknown [192.168.100.188])
        by mx.tkos.co.il (Postfix) with ESMTP id DC54344030A;
        Wed, 22 May 2019 16:56:40 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Fugang Duan <fugang.duan@nxp.com>
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] net: fec: remove redundant ipg clock disable
Date:   Wed, 22 May 2019 16:56:15 +0300
Message-Id: <b88a935c6e3f845b8eac78c32e2f15743014e418.1558533375.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't disable the ipg clock in the regulator error path. The clock is
disable unconditionally two lines below the failed_regulator label.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/net/ethernet/freescale/fec_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index aa7d4e27c5d1..f63eb2b57c3e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3473,7 +3473,6 @@ fec_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev,
 				"Failed to enable phy regulator: %d\n", ret);
-			clk_disable_unprepare(fep->clk_ipg);
 			goto failed_regulator;
 		}
 	} else {
-- 
2.20.1

