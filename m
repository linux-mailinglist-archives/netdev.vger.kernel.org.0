Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D46B7432
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCMKhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCMKhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997B35BC8E
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-0008TA-E5; Mon, 13 Mar 2023 11:36:58 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY1-003pKm-NF; Mon, 13 Mar 2023 11:36:57 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-004W3d-A5; Mon, 13 Mar 2023 11:36:56 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH net-next 3/9] net: dpaa: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:47 +0100
Message-Id: <20230313103653.2753139-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1735; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=mAitTQsB2Qx6Ydp88AtMOIQB1Fqj+4Z1o3BtpHIDZY0=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvyrN0KI02jSIM2HytPYbDQkHNqycZnvS4Ez4 HmpvSoWTrSJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78qwAKCRDB/BR4rcrs CYUwB/4i15xVlEcavZZCrW7gd8xq15lip/HtqelNtlkvci30ai+/fqIFtNY0h10hFtyUQiP8Ep/ kS8a+gw7ODP0fU1UQR5L92tFSocKcEw2JPENb1Gi5YuWNy3uX7bThhOlRuhzFvOLpPmRKTo9sHy 9h8RDqC571kPbE8e+vrFExwGBBd5jkzvbaUxGrbqNDAcdxtPr64E4q9SVzuNYS3fppnSkCj0+wG DZhqWkXSIen+QUbSmkgaLw4le9wt68oT8aAKY7Da0HVKKLSbreXELVAAG+FpeFUOai64QibtYn6 erJ5Odzz/cy/roc3I3VHL+RjiGLyNcOGZyEvaIh2F1NL9bRw
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 97cad3750096..477db267b95f 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -3501,7 +3501,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int dpaa_remove(struct platform_device *pdev)
+static void dpaa_remove(struct platform_device *pdev)
 {
 	struct net_device *net_dev;
 	struct dpaa_priv *priv;
@@ -3533,8 +3533,6 @@ static int dpaa_remove(struct platform_device *pdev)
 	dpaa_bps_free(priv);
 
 	free_netdev(net_dev);
-
-	return 0;
 }
 
 static const struct platform_device_id dpaa_devtype[] = {
@@ -3552,7 +3550,7 @@ static struct platform_driver dpaa_driver = {
 	},
 	.id_table = dpaa_devtype,
 	.probe = dpaa_eth_probe,
-	.remove = dpaa_remove
+	.remove_new = dpaa_remove
 };
 
 static int __init dpaa_load(void)
-- 
2.39.1

