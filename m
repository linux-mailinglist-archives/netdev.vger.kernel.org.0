Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5CB6C9C1C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjC0HeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjC0HeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:34:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2109C4EC2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:34:03 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pghMf-0000Io-Fr
        for netdev@vger.kernel.org; Mon, 27 Mar 2023 09:34:01 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B453619CDE0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:34:00 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4740F19CDC3;
        Mon, 27 Mar 2023 07:33:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1529bc47;
        Mon, 27 Mar 2023 07:33:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 02/11] can: rcar_canfd: Improve error messages
Date:   Mon, 27 Mar 2023 09:33:45 +0200
Message-Id: <20230327073354.1003134-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327073354.1003134-1-mkl@pengutronix.de>
References: <20230327073354.1003134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Improve printed error messages:
  - Replace numerical error codes by mnemotechnic error codes, to
    improve the user experience in case of errors,
  - Drop parentheses around printed numbers, cfr.
    Documentation/process/coding-style.rst,
  - Drop printing of an error message in case of out-of-memory, as the
    core memory allocation code already takes care of this.

Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/4162cc46f72257ec191007675933985b6df394b9.1679414936.git.geert+renesas@glider.be
[mkl: use colon instead of comma]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 41 +++++++++++++++----------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index d8fbc3fca475..701311dabab3 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1424,13 +1424,13 @@ static int rcar_canfd_open(struct net_device *ndev)
 	/* Peripheral clock is already enabled in probe */
 	err = clk_prepare_enable(gpriv->can_clk);
 	if (err) {
-		netdev_err(ndev, "failed to enable CAN clock, error %d\n", err);
+		netdev_err(ndev, "failed to enable CAN clock: %pe\n", ERR_PTR(err));
 		goto out_phy;
 	}
 
 	err = open_candev(ndev);
 	if (err) {
-		netdev_err(ndev, "open_candev() failed, error %d\n", err);
+		netdev_err(ndev, "open_candev() failed: %pe\n", ERR_PTR(err));
 		goto out_can_clock;
 	}
 
@@ -1731,10 +1731,9 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	int err = -ENODEV;
 
 	ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
-	if (!ndev) {
-		dev_err(dev, "alloc_candev() failed\n");
+	if (!ndev)
 		return -ENOMEM;
-	}
+
 	priv = netdev_priv(ndev);
 
 	ndev->netdev_ops = &rcar_canfd_netdev_ops;
@@ -1777,8 +1776,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 				       rcar_canfd_channel_err_interrupt, 0,
 				       irq_name, priv);
 		if (err) {
-			dev_err(dev, "devm_request_irq CH Err(%d) failed, error %d\n",
-				err_irq, err);
+			dev_err(dev, "devm_request_irq CH Err %d failed: %pe\n",
+				err_irq, ERR_PTR(err));
 			goto fail;
 		}
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "canfd.ch%d_trx",
@@ -1791,8 +1790,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 				       rcar_canfd_channel_tx_interrupt, 0,
 				       irq_name, priv);
 		if (err) {
-			dev_err(dev, "devm_request_irq Tx (%d) failed, error %d\n",
-				tx_irq, err);
+			dev_err(dev, "devm_request_irq Tx %d failed: %pe\n",
+				tx_irq, ERR_PTR(err));
 			goto fail;
 		}
 	}
@@ -1823,7 +1822,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	gpriv->ch[priv->channel] = priv;
 	err = register_candev(ndev);
 	if (err) {
-		dev_err(dev, "register_candev() failed, error %d\n", err);
+		dev_err(dev, "register_candev() failed: %pe\n", ERR_PTR(err));
 		goto fail_candev;
 	}
 	dev_info(dev, "device registered (channel %u)\n", priv->channel);
@@ -1967,16 +1966,16 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				ch_irq, err);
+			dev_err(dev, "devm_request_irq %d failed: %pe\n",
+				ch_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 
 		err = devm_request_irq(dev, g_irq, rcar_canfd_global_interrupt,
 				       0, "canfd.g_int", gpriv);
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				g_irq, err);
+			dev_err(dev, "devm_request_irq %d failed: %pe\n",
+				g_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 	} else {
@@ -1985,8 +1984,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 				       "canfd.g_recc", gpriv);
 
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				g_recc_irq, err);
+			dev_err(dev, "devm_request_irq %d failed: %pe\n",
+				g_recc_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 
@@ -1994,8 +1993,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 				       rcar_canfd_global_err_interrupt, 0,
 				       "canfd.g_err", gpriv);
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				g_err_irq, err);
+			dev_err(dev, "devm_request_irq %d failed: %pe\n",
+				g_err_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 	}
@@ -2012,14 +2011,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	/* Enable peripheral clock for register access */
 	err = clk_prepare_enable(gpriv->clkp);
 	if (err) {
-		dev_err(dev, "failed to enable peripheral clock, error %d\n",
-			err);
+		dev_err(dev, "failed to enable peripheral clock: %pe\n",
+			ERR_PTR(err));
 		goto fail_reset;
 	}
 
 	err = rcar_canfd_reset_controller(gpriv);
 	if (err) {
-		dev_err(dev, "reset controller failed\n");
+		dev_err(dev, "reset controller failed: %pe\n", ERR_PTR(err));
 		goto fail_clk;
 	}
 
-- 
2.39.2


