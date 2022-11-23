Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151B5634F43
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiKWEzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbiKWEzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BDDE068F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D39A4B81E98
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D214C433B5;
        Wed, 23 Nov 2022 04:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179316;
        bh=Su6kfkxatbFFjdL0cqvrD9NaKGJqNFqgxti96jNa/XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwAv3zlSbmZGQk5MCWD9BAUFtHTEap0d27TWaDPtslcVHfhuCbvZg6ba/dvVX/vSK
         X+UO4PMVOcqofQ3bgXmgaAh6Nm39N6X79IXe2HUSajk4xUE8jIjyMcm/muClUhffYm
         xQT0J8WQKhrCpZgrJKX2SmY3nTwJ1ajsUhohxg92u+jei+owY9Vys/R5pUr4CU1Cc9
         jpqeR/f+QpHfvj3to8n+7a4Eqf2CzDbNlFVnvR8f0xvIUmwlSxd6wZTsRjqg34ZJ9m
         lk001vsKUWopd9HDXV+c53Rn7Cffv1dfaxOkgJdrlva2uLf0orm3Dl8uZnPpRd4+1V
         zRTwhygyPWWbA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 11/12] nfc: st-nci: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:55:06 -0800
Message-Id: <20221123045507.2091409-12-kuba@kernel.org>
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
 drivers/nfc/st-nci/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 89fa24d71bef..6b5eed8a1fbe 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -195,8 +195,7 @@ static const struct acpi_gpio_mapping acpi_st_nci_gpios[] = {
 	{},
 };
 
-static int st_nci_i2c_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int st_nci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct st_nci_i2c_phy *phy;
@@ -284,7 +283,7 @@ static struct i2c_driver st_nci_i2c_driver = {
 		.of_match_table = of_match_ptr(of_st_nci_i2c_match),
 		.acpi_match_table = ACPI_PTR(st_nci_i2c_acpi_match),
 	},
-	.probe = st_nci_i2c_probe,
+	.probe_new = st_nci_i2c_probe,
 	.id_table = st_nci_i2c_id_table,
 	.remove = st_nci_i2c_remove,
 };
-- 
2.38.1

