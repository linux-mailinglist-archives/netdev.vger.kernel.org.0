Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9352B632CD2
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiKUTQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKUTQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB59D48D8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C02E6144E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0298C433C1;
        Mon, 21 Nov 2022 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058152;
        bh=Obutgu2WsdcNW5+RYlbX611pjMXilgLMQL03SjAfyZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvzPBQdCbpQ2rxGPAxkPGkZgKXAHdQZ6jA4KkmsKtQe9CBfdRB0GhCcdICRe1JUsK
         uRnMbH1vOFK3tS44MoMyq6OcCY31mrkozXcTxj0YfGKzK7ks/w5fLLNNagTG/mvXkj
         Haw10ob7efHvP9nlXjm23LAM8yi0xXAr5ERT6GBL1upa9vMYZkdnKBWdxWONRyYNVK
         kKhVMylcemEDuTEcPUusMRS0OpBWZttFCaam5IoOAHRiyJo/MEgoEkAK0Fd58Bmvd4
         7RgoK508yddUbFFaMRdRXqv86rnQFwl6Fb0zAKxkLlbvfr3Th23oi1wl89KsqbhLys
         xmZjfxSC9nNug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 10/12] nfc: s3fwrn5: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:44 -0800
Message-Id: <20221121191546.1853970-11-kuba@kernel.org>
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
 drivers/nfc/s3fwrn5/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index ecdee838d25d..2517ae71f9a4 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -177,8 +177,7 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
 	return 0;
 }
 
-static int s3fwrn5_i2c_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int s3fwrn5_i2c_probe(struct i2c_client *client)
 {
 	struct s3fwrn5_i2c_phy *phy;
 	int ret;
@@ -262,7 +261,7 @@ static struct i2c_driver s3fwrn5_i2c_driver = {
 		.name = S3FWRN5_I2C_DRIVER_NAME,
 		.of_match_table = of_match_ptr(of_s3fwrn5_i2c_match),
 	},
-	.probe = s3fwrn5_i2c_probe,
+	.probe_new = s3fwrn5_i2c_probe,
 	.remove = s3fwrn5_i2c_remove,
 	.id_table = s3fwrn5_i2c_id_table,
 };
-- 
2.38.1

