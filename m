Return-Path: <netdev+bounces-6250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD6671559C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28B771C20B8B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF3479E4;
	Tue, 30 May 2023 06:40:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFA37E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:40:09 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF18E8
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:40:07 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q3t1M-0001BU-Od; Tue, 30 May 2023 08:39:52 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q3t1K-003oJd-30; Tue, 30 May 2023 08:39:50 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q3t1J-009NGk-Dl; Tue, 30 May 2023 08:39:49 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	UNGLinuxDriver@microchip.com,
	George McCollister <george.mccollister@gmail.com>,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next] net: dsa: Switch i2c drivers back to use .probe()
Date: Tue, 30 May 2023 08:39:36 +0200
Message-Id: <20230530063936.2160016-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2190; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=b+ToDtHHYtUFwIaAAD/lF/vK1xhdcMF/MsEEHE7GQbQ=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkdZonjgcn2gQA3d0c43xTGjR0NFjOjghrfF56S EBf+g/wXVGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZHWaJwAKCRCPgPtYfRL+ TvFZB/9Kjijt3jfwO9BzHksqa5bZdpy26rTAER4oIIwBlMBEjvw4KJZ00t8HiJiQsgtPafZsv7Q UNWPz8Q+6DJby8JR3cLSpB2yAGNn7sze35tQoDMjDhBx06T50kY9GWWiDh/dPNn9UFMXRxEuLr2 0NDgDKQstscQEP0TvUATDrOyZh5gcHjtXCNwfJSFNSVBJN9x/yBHCwP7c+oXQjK02o0z7eOT4yJ CflxiAN4oobqPGejVyyFMuu+enjNMT8WNMJY1QgCiFiQdpmzHLQy6qZU/ra/4whZuLLOChB2jCy rkvPdZq+8htYFGZdO1xBf7JNxyv3eO/IaMXaqO9oU0PL4NDl
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

After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
call-back type"), all drivers being converted to .probe_new() and then
03c835f498b5 ("i2c: Switch .probe() to not take an id parameter") convert
back to (the new) .probe() to be able to eventually drop .probe_new() from
struct i2c_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/dsa/lan9303_i2c.c           | 2 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
 drivers/net/dsa/xrs700x/xrs700x_i2c.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lan9303_i2c.c b/drivers/net/dsa/lan9303_i2c.c
index e8844820c3a9..bbbec322bc4f 100644
--- a/drivers/net/dsa/lan9303_i2c.c
+++ b/drivers/net/dsa/lan9303_i2c.c
@@ -105,7 +105,7 @@ static struct i2c_driver lan9303_i2c_driver = {
 		.name = "LAN9303_I2C",
 		.of_match_table = lan9303_i2c_of_match,
 	},
-	.probe_new = lan9303_i2c_probe,
+	.probe = lan9303_i2c_probe,
 	.remove = lan9303_i2c_remove,
 	.shutdown = lan9303_i2c_shutdown,
 	.id_table = lan9303_i2c_id,
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 97a317263a2f..3ee26effbcb8 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -119,7 +119,7 @@ static struct i2c_driver ksz9477_i2c_driver = {
 		.name	= "ksz9477-switch",
 		.of_match_table = ksz9477_dt_ids,
 	},
-	.probe_new = ksz9477_i2c_probe,
+	.probe = ksz9477_i2c_probe,
 	.remove	= ksz9477_i2c_remove,
 	.shutdown = ksz9477_i2c_shutdown,
 	.id_table = ksz9477_i2c_id,
diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
index 14ff6887a225..c1179d7311f7 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -147,7 +147,7 @@ static struct i2c_driver xrs700x_i2c_driver = {
 		.name	= "xrs700x-i2c",
 		.of_match_table = of_match_ptr(xrs700x_i2c_dt_ids),
 	},
-	.probe_new = xrs700x_i2c_probe,
+	.probe = xrs700x_i2c_probe,
 	.remove	= xrs700x_i2c_remove,
 	.shutdown = xrs700x_i2c_shutdown,
 	.id_table = xrs700x_i2c_id,
-- 
2.39.2


