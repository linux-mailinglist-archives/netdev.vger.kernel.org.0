Return-Path: <netdev+bounces-8559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF50A72491D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FCB21C20B0E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F0333C9E;
	Tue,  6 Jun 2023 16:28:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B60F33C9A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:28:46 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D240910C2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:28:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXv-00056k-IV; Tue, 06 Jun 2023 18:28:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXu-005Y5d-Ms; Tue, 06 Jun 2023 18:28:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXt-00Bl0U-P7; Tue, 06 Jun 2023 18:28:33 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Madalin Bucur <madalin.bucur@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Sean Anderson <sean.anderson@seco.com>,
	netdev@vger.kernel.org,
	kernel@pengutronix.de,
	Madalin Bucur <madalin.bucur@oss.nxp.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: [PATCH net-next v2 4/8] net: fman: Convert to platform remove callback returning void
Date: Tue,  6 Jun 2023 18:28:25 +0200
Message-Id: <20230606162829.166226-5-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1729; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=9XlZOxPo8x+dfeqL6TZCQg97B+hezbS+e7gfBQATAr4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkf16mCSfJUasQJQjdi63nGVJnfGboftMUteoMo 45Ixqr1/nKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZH9epgAKCRCPgPtYfRL+ TmB+B/wNgFI3k+QWo0A8icvmrvWIEc/0oG6T+xuJd5x9JDPbIuPr09U6W0hmtM29ANvx7L0eL2T bIT00D8gS06FZeqHJHHwIhBmpSW5afteNdvcPQthhNe+jUmclFSLeqy+XkdUvIHgcrSa57srBT4 qWkuAFgTtxsM9YWpOb24RhUa8ZmtYs+3nRh28QKgeQL6bFURupcgAR9jL+GgTWhaSTodqmkQ5ZQ JXMebOoWeVxzxOq8PKEkpMIPE7Lm3xFdxhcNOvFvK5N568+EMi34xHNMaVCdf8KntglJWd8W7eS 9YPufDU5WZj+HjKJl0sFVe6CtWatQDAn7kP+jktAc32SvlvY
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
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
2.39.2


