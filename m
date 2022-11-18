Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63F063062F
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 01:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiKSAIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 19:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbiKSAHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 19:07:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00F994A6B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:32:09 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9T-0004gy-A4; Fri, 18 Nov 2022 23:48:03 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9Q-0058mB-ML; Fri, 18 Nov 2022 23:48:01 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9Q-0000Pd-QA; Fri, 18 Nov 2022 23:48:00 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Angel Iglesias <ang.iglesiasg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Colin Ian King <colin.i.king@gmail.com>
Cc:     linux-i2c@vger.kernel.org, kernel@pengutronix.de,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 505/606] nfc: pn544: Convert to i2c's .probe_new()
Date:   Fri, 18 Nov 2022 23:43:59 +0100
Message-Id: <20221118224540.619276-506-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118224540.619276-1-uwe@kleine-koenig.org>
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/nfc/pn544/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 9e754abcfa2a..8b0d910bee06 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -866,8 +866,7 @@ static const struct acpi_gpio_mapping acpi_pn544_gpios[] = {
 	{ },
 };
 
-static int pn544_hci_i2c_probe(struct i2c_client *client,
-			       const struct i2c_device_id *id)
+static int pn544_hci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct pn544_i2c_phy *phy;
@@ -954,7 +953,7 @@ static struct i2c_driver pn544_hci_i2c_driver = {
 		   .of_match_table = of_match_ptr(of_pn544_i2c_match),
 		   .acpi_match_table = ACPI_PTR(pn544_hci_i2c_acpi_match),
 		  },
-	.probe = pn544_hci_i2c_probe,
+	.probe_new = pn544_hci_i2c_probe,
 	.id_table = pn544_hci_i2c_id_table,
 	.remove = pn544_hci_i2c_remove,
 };
-- 
2.38.1

