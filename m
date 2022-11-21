Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E05632CCE
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiKUTQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiKUTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDDAD39DC
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ABDC6142C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D72EC433D6;
        Mon, 21 Nov 2022 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058150;
        bh=UKRuycntyQsrTVBx85kQf1/TxBbtwJti++PBJwHUKWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POWavPfmqtZ4lQzqa1o1agL1OtZSkqssIjfYEBMKulMe6rlv9QtM8XjNtkXtyjSvE
         iGGtmYx3XqGZb9y/9jR0Ju6YDQXh7J0vN5L3KBqqlg5qVGUionInwqhBhIg53eurXy
         p2K6pG/kQEdP5FxNhm+HOrt5frgVmYkPdgIgOlGtl6Cf/cb6ROWn15P/VJynREAkUV
         TH1rPLlm/AoDC1PmqbFXNh/WHp7ck3PM5UdNvllEknrtdPY06wkvHZtQm4mcz0lcXJ
         okPRMAgKYK+Balkv0a+uBKrbZG8xRNSbSOenN3WzfNcOcGYCCFmokwg7yiqtR/+qAe
         koaUHr8Fi1Ozw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 06/12] nfc: mrvl: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:40 -0800
Message-Id: <20221121191546.1853970-7-kuba@kernel.org>
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

