Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920B8634F3F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbiKWEzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiKWEzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DA9E06B4
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D8EF61A46
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0D6C43147;
        Wed, 23 Nov 2022 04:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179312;
        bh=6tWejKANGf/iLybzyqrEN+w8cIwfKPxO+oYB2tNYJdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+Uo32lggG9F5sZkdCobJv6Oo6sAYjuuqaET1zWWBn7R7Oz4Bf6/EoHBN9iNMpRiJ
         sr/G96YFJkUiUnzhY74QDUaiBg8bT4FkmKpQwsBfF5KtlxRVsPJiu5vgPtEsTBjxme
         ppMn96QuSAm3hNZswpVryfusU+gEtTQSqwPrh+podOWsos8ma8TjMNey4ijnNbvszP
         el5RlHL25oTYZTXWQZGG2GfwY//HlUyFjGfIoCx29n55pj8EdkF1/A/2EFECaP6j87
         OfeZOncDoFgN5XWXkbj3CSPZrYgpLfhcztdHFV86PJARzsSrwZ7sq+2fQJiwd6O5JT
         O/ClQT3xtyDyA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 03/12] net: dsa: xrs700x: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:54:58 -0800
Message-Id: <20221123045507.2091409-4-kuba@kernel.org>
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
 drivers/net/dsa/xrs700x/xrs700x_i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
index 54065cdedd35..14ff6887a225 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -76,8 +76,7 @@ static const struct regmap_config xrs700x_i2c_regmap_config = {
 	.val_format_endian = REGMAP_ENDIAN_BIG
 };
 
-static int xrs700x_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *i2c_id)
+static int xrs700x_i2c_probe(struct i2c_client *i2c)
 {
 	struct xrs700x *priv;
 	int ret;
@@ -148,7 +147,7 @@ static struct i2c_driver xrs700x_i2c_driver = {
 		.name	= "xrs700x-i2c",
 		.of_match_table = of_match_ptr(xrs700x_i2c_dt_ids),
 	},
-	.probe	= xrs700x_i2c_probe,
+	.probe_new = xrs700x_i2c_probe,
 	.remove	= xrs700x_i2c_remove,
 	.shutdown = xrs700x_i2c_shutdown,
 	.id_table = xrs700x_i2c_id,
-- 
2.38.1

