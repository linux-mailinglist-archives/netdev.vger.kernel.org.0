Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EA4575F64
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 12:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiGOKau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 06:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiGOKas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 06:30:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A02184EF7
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 03:30:47 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oCIaf-000489-S0; Fri, 15 Jul 2022 12:30:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oCIae-0015pm-2v; Fri, 15 Jul 2022 12:30:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oCIad-005KS9-Dh; Fri, 15 Jul 2022 12:30:31 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH] crypto: keembay-ocs-ecc: Drop if with an always false condition
Date:   Fri, 15 Jul 2022 12:30:26 +0200
Message-Id: <20220715103026.82224-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1005; h=from:subject; bh=ma24unCZAkxnnRLy6eiCI6gzFPOBHB1tX4WNu6DmYSc=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBi0UG++FOYApzGOlzGqC9UI7ejrZfYQMJYI2aLH0Ac 0tsP7/mJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYtFBvgAKCRDB/BR4rcrsCcmFB/ 9qMII1HjuVgi5ZCmrfo7CaxLezC8m/dXSHswptpN1c7ohW7xH3PECYnFcVzRU1fUWYrShGyOHbhDBV FUHIrsLJv0qeDgPG4QjUOaRzyz9rUnhooxn6YCr9NwWgTY38yW3pdwLzTNxR1e8usFRfWpPpXI3Opb /0aAFquXLq5yvArxyuPNJf8UeracdY/gQY7bhSwKK+/23Vdn1jmQj4LFQQlvc4zxXBw2hbYxj0PXb/ 2SKOLIS4PUPKLcUWwq7zxJQzi0umGFCTT183+Z/FyqKDneQyfxRYEzgUZZyerI2fdCSbGHfS+jFOgM zPjTGVNJQC3tIEGM5dQa4ErgZGNyja
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remove callback is only called after probe completed successfully.
In this case platform_set_drvdata() was called with a non-NULL argument
(in wlcore_probe()) and so wl is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/wireless/ti/wl12xx/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index c6da0cfb4afb..d06a2c419447 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1924,13 +1924,10 @@ static int wl12xx_remove(struct platform_device *pdev)
 	struct wl1271 *wl = platform_get_drvdata(pdev);
 	struct wl12xx_priv *priv;
 
-	if (!wl)
-		goto out;
 	priv = wl->priv;
 
 	kfree(priv->rx_mem_addr);
 
-out:
 	return wlcore_remove(pdev);
 }
 

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.36.1

