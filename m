Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6661B63064E
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 01:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiKSAJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 19:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiKSAJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 19:09:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD25A6160
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:32:46 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9S-0004f9-M5; Fri, 18 Nov 2022 23:48:02 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9Q-0058m3-2P; Fri, 18 Nov 2022 23:48:01 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9Q-0000PR-4Z; Fri, 18 Nov 2022 23:48:00 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Angel Iglesias <ang.iglesiasg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>,
        Jean Delvare <jdelvare@suse.de>,
        Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     linux-i2c@vger.kernel.org, kernel@pengutronix.de,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 502/606] nfc: mrvl: Convert to i2c's .probe_new()
Date:   Fri, 18 Nov 2022 23:43:56 +0100
Message-Id: <20221118224540.619276-503-uwe@kleine-koenig.org>
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
 drivers/nfc/nfcmrvl/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 24436c9e54c9..c3ab49df1e35 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -181,8 +181,7 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
 	return 0;
 }
 
-static int nfcmrvl_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int nfcmrvl_i2c_probe(struct i2c_client *client)
 {
 	const struct nfcmrvl_platform_data *pdata;
 	struct nfcmrvl_i2c_drv_data *drv_data;
@@ -257,7 +256,7 @@ static const struct i2c_device_id nfcmrvl_i2c_id_table[] = {
 MODULE_DEVICE_TABLE(i2c, nfcmrvl_i2c_id_table);
 
 static struct i2c_driver nfcmrvl_i2c_driver = {
-	.probe = nfcmrvl_i2c_probe,
+	.probe_new = nfcmrvl_i2c_probe,
 	.id_table = nfcmrvl_i2c_id_table,
 	.remove = nfcmrvl_i2c_remove,
 	.driver = {
-- 
2.38.1

