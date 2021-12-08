Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1C046D144
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhLHKt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhLHKt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 05:49:29 -0500
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E6DC061A72
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 02:45:56 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed10:a0bd:6217:e9a0:bd39])
        by xavier.telenet-ops.be with bizsmtp
        id Tmlt260072LoXaB01mltK0; Wed, 08 Dec 2021 11:45:53 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1muuSO-003dvS-Uq; Wed, 08 Dec 2021 11:45:52 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1muuF5-00BVl0-Vp; Wed, 08 Dec 2021 11:32:08 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] sh_eth: Use dev_err_probe() helper
Date:   Wed,  8 Dec 2021 11:32:07 +0100
Message-Id: <2576cc15bdbb5be636640f491bcc087a334e2c02.1638959463.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the dev_err_probe() helper, instead of open-coding the same
operation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/renesas/sh_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 223626290ce0e278..d947a628e1663009 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3368,8 +3368,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	/* MDIO bus init */
 	ret = sh_mdio_init(mdp, pd);
 	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "MDIO init failed: %d\n", ret);
+		dev_err_probe(&pdev->dev, ret, "MDIO init failed\n");
 		goto out_release;
 	}
 
-- 
2.25.1

