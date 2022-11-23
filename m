Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C1B634F3E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiKWEzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiKWEzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538A9E06B3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E42F861A3F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09043C4347C;
        Wed, 23 Nov 2022 04:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179312;
        bh=cRQgY2bqdUW8NFj+TM+0XvwMdI4vnBTlX+HZzyx2STg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnO4dMKArT2zgCoJ4rj3HzPb8bIAcMg49rfkpaCxG45aIuAffFe7+DZoI+OoUOT8R
         xKFGS4aWAy5WSVkAem9Te5d7MaghLkKpvn2zGc5ik1aYorrpMyNoQ9POgPgNw/74gb
         HR+GgWpKX9TNiU3Muf5pwPeMO0o7wpJayzXyAZYXNScceXW/vYn2M+FZPo4MdWvrht
         bJ5i7aby8aICT56OtHalsWQvbvGIqOQVisu8QdE8euLLajfqREoAFHmVPrWMkDntTc
         uKJqZE1EHpj/hNy6EEsxu8tdRJ3snOVrXFDkt9j24LkwpbMGPOoY72kpHycPRLQxRt
         ON3sCXb/eUjYA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 02/12] net: dsa: microchip: ksz9477: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:54:57 -0800
Message-Id: <20221123045507.2091409-3-kuba@kernel.org>
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
 drivers/net/dsa/microchip/ksz9477_i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index db4aec0a51dc..c1a633ca1e6d 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -14,8 +14,7 @@
 
 KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
 
-static int ksz9477_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *i2c_id)
+static int ksz9477_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap_config rc;
 	struct ksz_device *dev;
@@ -120,7 +119,7 @@ static struct i2c_driver ksz9477_i2c_driver = {
 		.name	= "ksz9477-switch",
 		.of_match_table = of_match_ptr(ksz9477_dt_ids),
 	},
-	.probe	= ksz9477_i2c_probe,
+	.probe_new = ksz9477_i2c_probe,
 	.remove	= ksz9477_i2c_remove,
 	.shutdown = ksz9477_i2c_shutdown,
 	.id_table = ksz9477_i2c_id,
-- 
2.38.1

