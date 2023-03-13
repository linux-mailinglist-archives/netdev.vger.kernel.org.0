Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F10B6B7431
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjCMKhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCMKhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8E55B5D0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-0008TR-Nw; Mon, 13 Mar 2023 11:36:58 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-003pKu-3o; Mon, 13 Mar 2023 11:36:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-004W3l-Mv; Mon, 13 Mar 2023 11:36:56 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH net-next 5/9] net: fman: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:49 +0100
Message-Id: <20230313103653.2753139-6-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1622; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=S0b1ub64SJQANCQ1Ra0dif/j9QVEkLXZ8ZAJPlxmGxk=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvyxV0JP0HqHjuDS8KYzq/dTxHffEBpqMP0wK N2dLQ99+OmJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78sQAKCRDB/BR4rcrs CQODB/4t0xbdHK2zj9f8e+nY9BDoZrVctvFf+gmq0ruuElwqqpaz5CCUH2xaKpXRGQ+McugQak+ wuBttC+uwpuWbunc4B/e8DPP+pZ1UwHQLIeMVH9XvSlzsQmZ26T4tQZMAQMvqGhD8ZTT+zcBSid UrWqIUbINXYPpfZQyS6dDVmDtKHyqwrvxwhjE8VLHOJ6ohXUfWWolUo/9QsPvTBAI3adjHZfBSW /eusMHxHkB/ik0fnnxP8Sx8To9UJ17JE1Ts2Hd3gv/87VxgB8ML2kJVmfEDd0ChR2B0pl7sE/jG E4xpU2cojPY1VLUjkYdcWoxbQCFGecf37IFjHhdhyNge83gT
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
 drivers/net/ethernet/freescale/fman/mac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 43665806c590..c5045891d694 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -331,12 +331,11 @@ static int mac_probe(struct platform_device *_of_dev)
 	return err;
 }
 
-static int mac_remove(struct platform_device *pdev)
+static void mac_remove(struct platform_device *pdev)
 {
 	struct mac_device *mac_dev = platform_get_drvdata(pdev);
 
 	platform_device_unregister(mac_dev->priv->eth_dev);
-	return 0;
 }
 
 static struct platform_driver mac_driver = {
@@ -345,7 +344,7 @@ static struct platform_driver mac_driver = {
 		.of_match_table	= mac_match,
 	},
 	.probe		= mac_probe,
-	.remove		= mac_remove,
+	.remove_new	= mac_remove,
 };
 
 builtin_platform_driver(mac_driver);
-- 
2.39.1

