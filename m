Return-Path: <netdev+bounces-2304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D85470113D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B38701C2135E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A94261CE;
	Fri, 12 May 2023 21:27:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B82098A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:59 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA8B30E5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:53 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIY-0005Hd-Kr; Fri, 12 May 2023 23:27:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIW-0033W9-AN; Fri, 12 May 2023 23:27:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIV-003qhk-4E; Fri, 12 May 2023 23:27:31 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	=?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Zhang Changzhong <zhangchangzhong@huawei.com>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 04/19] can: cc770_isa: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:10 +0200
Message-Id: <20230512212725.143824-5-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1765; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=phsnlg7L18rq9a0SrfAQjUpinbYqXx4THZMY/AcYf+Y=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8omLvfPP+TIgmocceDqeMCylqp/8dGyYHG9 b5J5Lapi0WJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vKAAKCRCPgPtYfRL+ TlsQB/9sq5qfKLNL8ku/7o3PaJPz9FdHsb6zeqm0RO3+E40TnPKXPuvCuUFsosZiyG3BFS7kmUo C/pApeCRe8Y1GTciS/2p/0ZgB5d5GjruoB/U5880A35tvPBf6wRgnCmqWIdLjGWsXxUk2HTMgrV SurZKeDLoPJjMrmLvO0+2WaRK/0Yy+9zIFkyromr+6ynLGcOs3xsKpOnsZ3eeOej1EZv41PGVk9 tVlRDYE5IOaaJI7nzzuozj9nTEgiWwVODJ6VLCwVTMlvaW6T9CT7af/8ZbT78IdMXRRyzLWzNxm Ts2Lf0STYMZvgj+tIEjZ2+L8+sDvZrrbpipymSxnrsLZXVUp
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
 drivers/net/can/cc770/cc770_isa.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/cc770/cc770_isa.c b/drivers/net/can/cc770/cc770_isa.c
index 8f6dccd5a587..22009440a983 100644
--- a/drivers/net/can/cc770/cc770_isa.c
+++ b/drivers/net/can/cc770/cc770_isa.c
@@ -285,7 +285,7 @@ static int cc770_isa_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int cc770_isa_remove(struct platform_device *pdev)
+static void cc770_isa_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct cc770_priv *priv = netdev_priv(dev);
@@ -303,13 +303,11 @@ static int cc770_isa_remove(struct platform_device *pdev)
 			release_region(port[idx], CC770_IOSIZE);
 	}
 	free_cc770dev(dev);
-
-	return 0;
 }
 
 static struct platform_driver cc770_isa_driver = {
 	.probe = cc770_isa_probe,
-	.remove = cc770_isa_remove,
+	.remove_new = cc770_isa_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 	},
-- 
2.39.2


