Return-Path: <netdev+bounces-2297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C5A701131
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95010280C8E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3BC261FD;
	Fri, 12 May 2023 21:27:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6183E1EA77
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:54 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BF793ED
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:48 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIZ-0005KY-Vb; Fri, 12 May 2023 23:27:36 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIY-0033X2-V9; Fri, 12 May 2023 23:27:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-003qiW-Pt; Fri, 12 May 2023 23:27:33 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	=?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 16/19] can: softing: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:22 +0200
Message-Id: <20230512212725.143824-17-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1859; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=jTXzgKrUMDN72Axnj5aYxzcmMIg+A+FIUaiSoDTwQZk=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq82HAJiamGEBpDtcygtkbBSbIUHpAhhXT29f 6jMHiLkAuCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vNgAKCRCPgPtYfRL+ TjLNCACphNuXo0WYCs2SRbUjXKGGdmt7QvfCUWb7/BjYFWzBwROeP1+Hpb9fmxKKDHAaxi2OILW 3Ofumi52rY2Qx2tLzcUMK5E33LnjBhWzw+AgtSxA4t5He2jCfDrvZvmH4t4sMXdGPCge4DR7bpL FYEiwiQJR3pMH7yCqPpwVCHZ1wjOg3rOQvUL4c59aLpkZaJeeSAO2rofimWXn4IPYDyqhDTdHCd cb3YfjP3iqD5KnColY7HoimRn2jzwkPpuKATepLwJ/zoCoSh81cvUgHKpMb1XMTUTvQ9JbGffyZ 58PjFA7kD6ceoBuiA4JnBlw6ntN0g4GLJImz/P7CJzdCUr7R
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
 drivers/net/can/softing/softing_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index c72f505d29fe..bd25137062c5 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -729,7 +729,7 @@ static const struct attribute_group softing_pdev_group = {
 /*
  * platform driver
  */
-static int softing_pdev_remove(struct platform_device *pdev)
+static void softing_pdev_remove(struct platform_device *pdev)
 {
 	struct softing *card = platform_get_drvdata(pdev);
 	int j;
@@ -747,7 +747,6 @@ static int softing_pdev_remove(struct platform_device *pdev)
 
 	iounmap(card->dpram);
 	kfree(card);
-	return 0;
 }
 
 static int softing_pdev_probe(struct platform_device *pdev)
@@ -855,7 +854,7 @@ static struct platform_driver softing_driver = {
 		.name = KBUILD_MODNAME,
 	},
 	.probe = softing_pdev_probe,
-	.remove = softing_pdev_remove,
+	.remove_new = softing_pdev_remove,
 };
 
 module_platform_driver(softing_driver);
-- 
2.39.2


