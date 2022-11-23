Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C925634F38
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiKWEzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiKWEzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10BDE068F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C06760916
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E614C43470;
        Wed, 23 Nov 2022 04:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179311;
        bh=YO1B1vvLQCKlGZqqWnnewwVruNF83ffLcKOx7qcLWwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehgC0sXmDGz37Z8wyxEW7eu9RFDTN9BDm6cGob8NwEkzGRMAXAmm2mIyCYWDnERkg
         vO3JB38RP4vB5QEpEkWzAUQUXUJW0RvYKYIpMB1g/POjzLb13GyOL2tC3nKkC2ffWE
         uqM+FMMvK3Y9tSd/U7mlVi+q7FWk9cgcSchh9e0+miwaWsvLXFBQcFooXcJLYYn7p/
         mXcUcqUHJw9qW8t6tdRBJXMCBi+CauMV9qFecMhHHuy4INA4VbM/sxdvpZitRiDpXf
         Dgk9abPhwXQnzXJpQdROj57qk/JCalgdBwugvOCdfjIdldrfn+UihRYS2XkwoFEbVz
         X/v4lj9XSCANA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 01/12] net: dsa: lan9303: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:54:56 -0800
Message-Id: <20221123045507.2091409-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123045507.2091409-1-kuba@kernel.org>
References: <20221123045507.2091409-1-kuba@kernel.org>
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

