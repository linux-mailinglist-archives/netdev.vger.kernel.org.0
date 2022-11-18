Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC81363067E
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 01:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiKSAKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 19:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237482AbiKSAJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 19:09:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CF394A7D
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:33:06 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9T-0004h6-BL; Fri, 18 Nov 2022 23:48:03 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9Q-0058mE-OB; Fri, 18 Nov 2022 23:48:01 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owA9Q-0000PW-CP; Fri, 18 Nov 2022 23:48:00 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Angel Iglesias <ang.iglesiasg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Michael Walle <michael@walle.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org, kernel@pengutronix.de,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 503/606] NFC: nxp-nci: Convert to i2c's .probe_new()
Date:   Fri, 18 Nov 2022 23:43:57 +0100
Message-Id: <20221118224540.619276-504-uwe@kleine-koenig.org>
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
 drivers/nfc/nxp-nci/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index ec6446511984..d4c299be7949 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -263,8 +263,7 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
 	{ }
 };
 
-static int nxp_nci_i2c_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+static int nxp_nci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct nxp_nci_i2c_phy *phy;
@@ -349,7 +348,7 @@ static struct i2c_driver nxp_nci_i2c_driver = {
 		   .acpi_match_table = ACPI_PTR(acpi_id),
 		   .of_match_table = of_nxp_nci_i2c_match,
 		  },
-	.probe = nxp_nci_i2c_probe,
+	.probe_new = nxp_nci_i2c_probe,
 	.id_table = nxp_nci_i2c_id_table,
 	.remove = nxp_nci_i2c_remove,
 };
-- 
2.38.1

