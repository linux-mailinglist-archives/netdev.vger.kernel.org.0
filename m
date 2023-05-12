Return-Path: <netdev+bounces-2295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F4D70112C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 998881C209A3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2F819BAD;
	Fri, 12 May 2023 21:27:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624CE261FD
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:52 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A12B7EFC
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:47 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIY-0005I9-TF; Fri, 12 May 2023 23:27:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-0033WY-Bv; Fri, 12 May 2023 23:27:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIW-003qiA-N9; Fri, 12 May 2023 23:27:32 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 11/19] can: m_can: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:17 +0200
Message-Id: <20230512212725.143824-12-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1965; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=zzskZ5tpf+H24pFcmP7ncTMlaLZrL4bcJODIW61mQmk=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8w2gvE9gI4lOBmX9qRsJ3499FKdlPZff/Bs ATKLvBqnJuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vMAAKCRCPgPtYfRL+ TmbSB/9SNcnOrEOSj17BHCNF7w/0IovmFO0taTKIcc/1cdqMI+oPq0DE0pk0rvc43qAuHXOvwx8 ReBhFCL0kkcFEnyFeOLC9PXj/nvp9pH24h9pwhydI4TOX0+6IUgQxyrxDwyqq+NHj0cQ7NqA1hn iKZIqI2CKx9cc6Niq2fY1drCuEFNId5zOiyGOAsBsRuHGYshMbP2P70NC6aBL2uFC2tAVn9kJPG OV2z2HZDQXoFHm+6bWtlS1mIsidfcDM6A8b4Qi1R5G+H96bT8kIiRCERxLy43MdOwVfK5qUYPpq YqIngeF2peFOgcEjDXvH6gr9+zrL7xxWQIPVDrhtuG+bUmrX
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
returning an error code. However the value returned is ignored (apart from
emitting a warning) and this typically results in resource leaks. To improve
here there is a quest to make the remove callback return void. In the first
step of this quest all drivers are converted to .remove_new() which already
returns void. Eventually after all drivers are converted, .remove_new() is
renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/can/m_can/m_can_platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 9c1dcf838006..94dc82644113 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -164,7 +164,7 @@ static __maybe_unused int m_can_resume(struct device *dev)
 	return m_can_class_resume(dev);
 }
 
-static int m_can_plat_remove(struct platform_device *pdev)
+static void m_can_plat_remove(struct platform_device *pdev)
 {
 	struct m_can_plat_priv *priv = platform_get_drvdata(pdev);
 	struct m_can_classdev *mcan_class = &priv->cdev;
@@ -172,8 +172,6 @@ static int m_can_plat_remove(struct platform_device *pdev)
 	m_can_class_unregister(mcan_class);
 
 	m_can_class_free_dev(mcan_class->net);
-
-	return 0;
 }
 
 static int __maybe_unused m_can_runtime_suspend(struct device *dev)
@@ -223,7 +221,7 @@ static struct platform_driver m_can_plat_driver = {
 		.pm     = &m_can_pmops,
 	},
 	.probe = m_can_plat_probe,
-	.remove = m_can_plat_remove,
+	.remove_new = m_can_plat_remove,
 };
 
 module_platform_driver(m_can_plat_driver);
-- 
2.39.2


