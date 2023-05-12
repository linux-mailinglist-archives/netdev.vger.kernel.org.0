Return-Path: <netdev+bounces-2291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EFCA70111F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:28:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30DC2281BAD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D28E261EC;
	Fri, 12 May 2023 21:27:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B5710792
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:47 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3695FEF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-0005I4-Vj; Fri, 12 May 2023 23:27:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-0033WV-8p; Fri, 12 May 2023 23:27:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIW-003qi7-GE; Fri, 12 May 2023 23:27:32 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 10/19] can: janz-ican3: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:16 +0200
Message-Id: <20230512212725.143824-11-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1782; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=u/7hB2ddYCYrZL/WHa/iTR+BFlAMoSy/Fbr/1MkIrOg=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8voDfzVjE7mQZlBJmh985TlNzbPgMsSp734 9WaeFtp9SeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vLwAKCRCPgPtYfRL+ Tpa5B/9CV8KNRLdlbx9P3tpkCXUoAp74+jbM4h0TCCpmPolScKUVv4sA2GOJ1Fpb36BuNKcMAc0 UnTrjoHfSd6P1NZ4FrAV7C4IPk62QEFBjBi4693ogYSC9eFvMJl1QmgYa3cr7gu2ukmffJv5Tk5 fe2fXVIMiAYsfc4HHg3PG2wOn18QN7j5Nyz63kzwWvjpOvnpegcpqLqeSASwHc6SqYL31uYoMtq aHxzo+RTe1h8wKx7uht8DflvqcmjkSK6FHWCX+WxdmNKmgF+B6dvnpYeQ15IVbAQ+VPkFe33r+V QR0572VPFNadVoQyshHAZZjq1qEjhsVyTzTaoeyOVnJFqu7W
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
 drivers/net/can/janz-ican3.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 0732a5092141..d048ea565b89 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -2023,7 +2023,7 @@ static int ican3_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ican3_remove(struct platform_device *pdev)
+static void ican3_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct ican3_dev *mod = netdev_priv(ndev);
@@ -2042,8 +2042,6 @@ static int ican3_remove(struct platform_device *pdev)
 	iounmap(mod->dpm);
 
 	free_candev(ndev);
-
-	return 0;
 }
 
 static struct platform_driver ican3_driver = {
@@ -2051,7 +2049,7 @@ static struct platform_driver ican3_driver = {
 		.name	= DRV_NAME,
 	},
 	.probe		= ican3_probe,
-	.remove		= ican3_remove,
+	.remove_new	= ican3_remove,
 };
 
 module_platform_driver(ican3_driver);
-- 
2.39.2


