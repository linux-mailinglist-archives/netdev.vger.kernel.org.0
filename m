Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5317632CD0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiKUTQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiKUTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6989AD48C9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03EDE61447
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A134C433D6;
        Mon, 21 Nov 2022 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058151;
        bh=2yYxpQPEW3/B+N3rcUfmvr2RsfowQDZLMTYTXtHe1Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MO9VYEITkz8DGuTCvuFQAt9FB3r/Y2FcptG8KQCkO0M9Aca50KaOFl45+8Cy+B/50
         KR65afn1Plai5ww2VHjp7qO0YqPGuqMkIWAV+q8KBpzMxRLj/NxygJmOQ598b6kTlC
         feMZDQpAuDEIfyhaQc7gfvBncrwyslmIB25CVPUjUsNp6JJptD+KP1qFHpTWNK777j
         MDgQi9uY784xl+iQuamv4jUCIWYrwEyjomOy728XHuKmqvqhMGKcCBruM8hNUAjQMh
         kMEJi1x5b0AT8yfG3ct1eJENqSNHAVO0Iv6U/eUPJ1pu4vSk/BYOk1ocqtkyFBbzmu
         nGtMbOCU0knFw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 09/12] nfc: pn544: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:43 -0800
Message-Id: <20221121191546.1853970-10-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121191546.1853970-1-kuba@kernel.org>
References: <20221121191546.1853970-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

