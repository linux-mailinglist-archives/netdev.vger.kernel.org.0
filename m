Return-Path: <netdev+bounces-8561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 225C8724924
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C84E628106A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C14933CB1;
	Tue,  6 Jun 2023 16:28:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D7C33C9A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:28:47 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEB710D5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:28:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXv-00056m-Mg; Tue, 06 Jun 2023 18:28:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXv-005Y5i-0P; Tue, 06 Jun 2023 18:28:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXu-00Bl0b-6W; Tue, 06 Jun 2023 18:28:34 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Cc: netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next v2 6/8] net: fsl_pq_mdio: Convert to platform remove callback returning void
Date: Tue,  6 Jun 2023 18:28:27 +0200
Message-Id: <20230606162829.166226-7-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1855; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=ERnBGNG/jq9pugVELXQhvxuP85oTn5JkBf4NKPRymCo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkf16oB/Qp6F67KnyVe5uI4jvWHjC8jxClkmf2e YpaAethKguJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZH9eqAAKCRCPgPtYfRL+ TkYCB/9PMUi8KdLEW8it9Pit0JZ8P3aQTViB0op3k4Y6PJFj2wW8duLdI2sx93WaxOLw5yXta2g IPZRLnsedm73tOGULOQHTjDwBCUUMVAM8u9UkAhw3i8/8tzJmZnqxlQ7fG50QNxX3oGA9iLPLor 7A6kkp0ps7gwrBOqhDsAK1apHCJLkTlRAyuX67+dvmvFuyPA0UhcTA9Nzv4sR9uUHI7q6dgTpG6 no3gXfvVBKS0+/0+nOUVM5+FaZEvlKbif80HkQrLGlGYFDevIb/6/zauoWYyLOejWLWtKxv/ReS Q16jZKoGyo3NMvCvVOI2YM4srbPyK8C+ZYYaeYooNaLTvuEz
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

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/fsl_pq_mdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
index 9d58d8334467..01d594886f52 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -511,7 +511,7 @@ static int fsl_pq_mdio_probe(struct platform_device *pdev)
 }
 
 
-static int fsl_pq_mdio_remove(struct platform_device *pdev)
+static void fsl_pq_mdio_remove(struct platform_device *pdev)
 {
 	struct device *device = &pdev->dev;
 	struct mii_bus *bus = dev_get_drvdata(device);
@@ -521,8 +521,6 @@ static int fsl_pq_mdio_remove(struct platform_device *pdev)
 
 	iounmap(priv->map);
 	mdiobus_free(bus);
-
-	return 0;
 }
 
 static struct platform_driver fsl_pq_mdio_driver = {
@@ -531,7 +529,7 @@ static struct platform_driver fsl_pq_mdio_driver = {
 		.of_match_table = fsl_pq_mdio_match,
 	},
 	.probe = fsl_pq_mdio_probe,
-	.remove = fsl_pq_mdio_remove,
+	.remove_new = fsl_pq_mdio_remove,
 };
 
 module_platform_driver(fsl_pq_mdio_driver);
-- 
2.39.2


