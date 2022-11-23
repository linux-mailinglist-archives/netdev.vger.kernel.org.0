Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEB3634F3C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiKWEzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiKWEzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214DFE068F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B237D61A46
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF61C43146;
        Wed, 23 Nov 2022 04:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179315;
        bh=V0Tfnrre0NHsKqOVg/o2NU8BX+XapJ3aQFkGui0t2Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syT6skesPzZYWYEuQQkDYuvqXEVxoBtYQNFPTC/b7DKTO7tOv2TKoXzsq9Y2MtOIZ
         MOYPyjqxmt1j7k2nzV/i6iwjHZf2GpCwZQ9B0pptfOhkdDy/XafWI+VI4dsslbnyhG
         MTdeWrEHTTQbS+jJFnqKq7266DIW51kew+nBPOWVlzbSnhaIEJLiCEoaglxmha7jtq
         9hajUmyoKQ6kz/B6Nf3eIFy43j0NKQ73eFrZA6HJaO4gYeCWNYPsSG9o92tWyxy+X4
         phOcFMH1BiYdGx+3CUBvWj22Ghij0ha0lKlDiQ4J1QKne7AUPoUG3ES8YKDb2UgOW1
         4H6Jcfl0ADDjw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 08/12] nfc: pn533: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:55:03 -0800
Message-Id: <20221123045507.2091409-9-kuba@kernel.org>
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

