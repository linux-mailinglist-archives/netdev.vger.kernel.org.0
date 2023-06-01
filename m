Return-Path: <netdev+bounces-7033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41964719583
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8E75281549
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D34171BB;
	Thu,  1 Jun 2023 08:26:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B0C168BF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:26:19 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2572111F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:26:18 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddE-0002u2-GT; Thu, 01 Jun 2023 10:26:04 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddC-004JKf-WC; Thu, 01 Jun 2023 10:26:03 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddC-00A5yc-DB; Thu, 01 Jun 2023 10:26:02 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next 3/4] ath10k: Convert to platform remove callback returning void
Date: Thu,  1 Jun 2023 10:25:55 +0200
Message-Id: <20230601082556.2738446-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
References: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3192; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=wPyGg8vqpI8ICYVHsb0hUkRVG2HoNMcDpA8BThv+i/s=; b=owGbwMvMwMXY3/A7olbonx/jabUkhpSKMP6rJpo9+xvfsvtVLnt5ZKsPF+vVxqXmyz1XTVZXu rj3wWa9TkZjFgZGLgZZMUUW+8Y1mVZVcpGda/9dhhnEygQyhYGLUwAmknGHg6Epw1nEuX3Ps/YL LCozXG/LN7wQVf7y4s6CeW4VdlOsGc6bGX7+8iD6nktBurDCxxl3TzcoKkU84ksvYvdleRih/8J sxYMSty1dJa23Xj76E+yzQOXIBO88s2+xSkFyNzYwMRyzivZPOmzlvrXLQ6aRXfTWk377dpb7q9 7Jei39drj2n8XUyjiT11PnLOE6bvHc5dS6xYUR7O+Ninx/Hze6I7PezjSZhS3l/ESBbf0uy8KDv ppejPb99vrv7bj4vfcCe7PmaZZPi2AIushxLnqpsBjP2fSUzJU1zY5OmxllzmTsWbqc/0Bwaa// 3DWRAbKbDkVb2sxjnXE8PCFmYq2MarZQkQg7e/72WpliAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

Both ath10k platform drivers return zero unconditionally in their remove
callback, so they can be trivially converted to use .remove_new().

Also fix on of the more offending whitespace issues in the definition
of ath10k_snoc_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/wireless/ath/ath10k/ahb.c  | 6 ++----
 drivers/net/wireless/ath/ath10k/snoc.c | 8 +++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index fffdbad75074..632da4c5e5da 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -820,7 +820,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ath10k_ahb_remove(struct platform_device *pdev)
+static void ath10k_ahb_remove(struct platform_device *pdev)
 {
 	struct ath10k *ar = platform_get_drvdata(pdev);
 
@@ -834,8 +834,6 @@ static int ath10k_ahb_remove(struct platform_device *pdev)
 	ath10k_ahb_clock_disable(ar);
 	ath10k_ahb_resource_deinit(ar);
 	ath10k_core_destroy(ar);
-
-	return 0;
 }
 
 static struct platform_driver ath10k_ahb_driver = {
@@ -844,7 +842,7 @@ static struct platform_driver ath10k_ahb_driver = {
 		.of_match_table = ath10k_ahb_of_match,
 	},
 	.probe  = ath10k_ahb_probe,
-	.remove = ath10k_ahb_remove,
+	.remove_new = ath10k_ahb_remove,
 };
 
 int ath10k_ahb_init(void)
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 5128a452c65f..26214c00cd0d 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1848,7 +1848,7 @@ static int ath10k_snoc_free_resources(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_snoc_remove(struct platform_device *pdev)
+static void ath10k_snoc_remove(struct platform_device *pdev)
 {
 	struct ath10k *ar = platform_get_drvdata(pdev);
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
@@ -1861,8 +1861,6 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
 		wait_for_completion_timeout(&ar->driver_recovery, 3 * HZ);
 
 	ath10k_snoc_free_resources(ar);
-
-	return 0;
 }
 
 static void ath10k_snoc_shutdown(struct platform_device *pdev)
@@ -1875,8 +1873,8 @@ static void ath10k_snoc_shutdown(struct platform_device *pdev)
 
 static struct platform_driver ath10k_snoc_driver = {
 	.probe  = ath10k_snoc_probe,
-	.remove = ath10k_snoc_remove,
-	.shutdown =  ath10k_snoc_shutdown,
+	.remove_new = ath10k_snoc_remove,
+	.shutdown = ath10k_snoc_shutdown,
 	.driver = {
 		.name   = "ath10k_snoc",
 		.of_match_table = ath10k_snoc_dt_match,
-- 
2.39.2


