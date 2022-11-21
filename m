Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E4E632CD1
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiKUTQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiKUTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33050D3293
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2CD461449
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444C0C43147;
        Mon, 21 Nov 2022 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058151;
        bh=V0Tfnrre0NHsKqOVg/o2NU8BX+XapJ3aQFkGui0t2Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pr2snjW7x8fnqEokWcsce837DMKqyuAJkvr3dhr+oa1QbEllAS2mcoo7gwzRgu87J
         x7O4wF5EVhZ24E5oTYnFzPa1wjqy2U80b0xpZXC9A4mmdAEMPbHDLaDyyCwVbV++xl
         R5a72LXnpCvbyLXCUnbVUb9iICuRzB/al8NfgGofMa90tE8b1sLP/ni8bSSQk+roK2
         mAjZyZ1KoGQ2GID4g5OZEodt9gpufFxb0tTOJu99g4X3nQMKdf4Uor+UZnbkGprs5d
         iAZrKCu6WwHF9WHH50hgsX7aCAaMGefmzxbR1Yirf5HA4h4xD0xgc8MXQDieiZqOWh
         xxFl+HUnQZq8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 08/12] nfc: pn533: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:42 -0800
Message-Id: <20221121191546.1853970-9-kuba@kernel.org>
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
 drivers/nfc/pn533/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index ddf3db286bad..1503a98f0405 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -163,8 +163,7 @@ static const struct pn533_phy_ops i2c_phy_ops = {
 };
 
 
-static int pn533_i2c_probe(struct i2c_client *client,
-			       const struct i2c_device_id *id)
+static int pn533_i2c_probe(struct i2c_client *client)
 {
 	struct pn533_i2c_phy *phy;
 	struct pn533 *priv;
@@ -260,7 +259,7 @@ static struct i2c_driver pn533_i2c_driver = {
 		   .name = PN533_I2C_DRIVER_NAME,
 		   .of_match_table = of_match_ptr(of_pn533_i2c_match),
 		  },
-	.probe = pn533_i2c_probe,
+	.probe_new = pn533_i2c_probe,
 	.id_table = pn533_i2c_id_table,
 	.remove = pn533_i2c_remove,
 };
-- 
2.38.1

