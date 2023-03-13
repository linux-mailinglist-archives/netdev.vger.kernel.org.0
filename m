Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0236B7434
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCMKhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCMKhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BC950FB5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY3-0008UR-LJ; Mon, 13 Mar 2023 11:36:59 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-003pL4-Fi; Mon, 13 Mar 2023 11:36:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY1-004W3z-GI; Mon, 13 Mar 2023 11:36:57 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 9/9] net: ucc_geth: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:53 +0100
Message-Id: <20230313103653.2753139-10-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1861; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=hiPfQ6LuVEv3fcOfxf1fooE2/sTKihR8xeGbsyguKpE=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvy+zOYR8NtOaP8TlwSO+iN4rUOWLMakd6JyL ljJuPMgBreJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78vgAKCRDB/BR4rcrs CSGmB/sEXrdkvsfxvj/SPIlDEPwwzN68YX5VDNIO1CG5oeoLAFFfaaKkGS3HUEBdlSF26a6jOYu /JmgBNDiVtvp4NAo1n586V2i/5e7dqqjZqaSGGiwHVozRBh5KnIfMbEbQ4WphWzprP/232Zlfzr C/WkGG3jPKexIRm7wD8WTMUR52NK3nAuWols7AED7z+EQ2bQ/NQYetBa3GTeBG6q7oLPbu8Ummw Oqw6PsHVwjtiGU6q/0dCNteNJ/IOZLfzOIx0eLobgvbBDVmZMmEOqa2nmhvZgFkZpdjQnBJHYRo pJVXrJ3aS/8zcUj2KpbC6gXutJsyb2jxS2O4eBZh1lnZ5XJ+
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
 drivers/net/ethernet/freescale/ucc_geth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 7a4cb4f07c32..2b3a15f24e7c 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3753,7 +3753,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	return err;
 }
 
-static int ucc_geth_remove(struct platform_device* ofdev)
+static void ucc_geth_remove(struct platform_device* ofdev)
 {
 	struct net_device *dev = platform_get_drvdata(ofdev);
 	struct ucc_geth_private *ugeth = netdev_priv(dev);
@@ -3767,8 +3767,6 @@ static int ucc_geth_remove(struct platform_device* ofdev)
 	of_node_put(ugeth->ug_info->phy_node);
 	kfree(ugeth->ug_info);
 	free_netdev(dev);
-
-	return 0;
 }
 
 static const struct of_device_id ucc_geth_match[] = {
@@ -3787,7 +3785,7 @@ static struct platform_driver ucc_geth_driver = {
 		.of_match_table = ucc_geth_match,
 	},
 	.probe		= ucc_geth_probe,
-	.remove		= ucc_geth_remove,
+	.remove_new	= ucc_geth_remove,
 	.suspend	= ucc_geth_suspend,
 	.resume		= ucc_geth_resume,
 };
-- 
2.39.1

