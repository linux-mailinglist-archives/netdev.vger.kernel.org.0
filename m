Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99982632CCF
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiKUTQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiKUTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2F0C72C4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6002FB815D2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD7EC43145;
        Mon, 21 Nov 2022 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058149;
        bh=YO1B1vvLQCKlGZqqWnnewwVruNF83ffLcKOx7qcLWwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDRbO0jR37Kw6eLMR4WljTTEyFjxDGOcbCfU8xzJjQuuckzXOdYMDz23dBJAIRfDN
         CnRE9748zTF3/cHCI2sHr+iWIw7S48a970MQXhtGs83xlNi7Q4eyfiH6K0DX6tbD2H
         Ht7vY0zGSMXJHAAbY2yJVvpWb/Vux+76DoXjuwDptIMqElzyKUECQF0/6kXXFlFlWP
         EqGJ8x38TDjEtnCNfVzdQ7H4blF0ym3/2Yry5YcwDAkErKHczkEvKji6T0vkdBIN1t
         0yJ2YeSs+o3lT3mG+uWq9ppzhQaRnRG1qWPM59kZU4xqdxBoy8YAY2A6EC4Ip/S51w
         Yt7rKmqajqlAA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 01/12] net: dsa: lan9303: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:35 -0800
Message-Id: <20221121191546.1853970-2-kuba@kernel.org>
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
 drivers/net/dsa/lan9303_i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lan9303_i2c.c b/drivers/net/dsa/lan9303_i2c.c
index 7d746cd9ca1b..1cb41c36bd47 100644
--- a/drivers/net/dsa/lan9303_i2c.c
+++ b/drivers/net/dsa/lan9303_i2c.c
@@ -29,8 +29,7 @@ static const struct regmap_config lan9303_i2c_regmap_config = {
 	.cache_type = REGCACHE_NONE,
 };
 
-static int lan9303_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int lan9303_i2c_probe(struct i2c_client *client)
 {
 	struct lan9303_i2c *sw_dev;
 	int ret;
@@ -106,7 +105,7 @@ static struct i2c_driver lan9303_i2c_driver = {
 		.name = "LAN9303_I2C",
 		.of_match_table = of_match_ptr(lan9303_i2c_of_match),
 	},
-	.probe = lan9303_i2c_probe,
+	.probe_new = lan9303_i2c_probe,
 	.remove = lan9303_i2c_remove,
 	.shutdown = lan9303_i2c_shutdown,
 	.id_table = lan9303_i2c_id,
-- 
2.38.1

