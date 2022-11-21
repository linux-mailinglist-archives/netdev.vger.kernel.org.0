Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DB9632CD9
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiKUTRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiKUTQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3EBD48D9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7054061447
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FCAC433C1;
        Mon, 21 Nov 2022 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058152;
        bh=Hha/PZ9e9uaNOICKSzmUwuppjBfKYrFtF+2dhxdog0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4U2WpUnK55MlgV1O89pVDUULJYMGPTC4sYh6m0R3dY1liHqyvZYwabQV87Y0Q636
         2tnsDMQn8HHlUE3EpPTQ9Gqs4rTqMOsXAnGGutAU5VRlSAYEfrKAUU/67/JhXfiEFb
         3gEAkOyraAi4J4n/jVL94iHw4Iy592xHJo6sANN+1OcNyOfw847nTeg7VA7sI4MXI9
         bKVCEGUxBEk8pJU38XjGRpPLOfOcP7ennYzVQ9b/4yAybCzFNtFd62Q365i04XgH3Y
         gpjLa0016BWKA3GNXd3QXn2o7kVulp+j82LHDN81ja4RrJaVh91iSzmSjagqXSLkPL
         fqKaBgzFpnTEQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 12/12] nfc: st21nfca: i2c: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:46 -0800
Message-Id: <20221121191546.1853970-13-kuba@kernel.org>
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
 drivers/nfc/st21nfca/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 76b55986bcf8..55f7a2391bb1 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -487,8 +487,7 @@ static const struct acpi_gpio_mapping acpi_st21nfca_gpios[] = {
 	{},
 };
 
-static int st21nfca_hci_i2c_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int st21nfca_hci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct st21nfca_i2c_phy *phy;
@@ -598,7 +597,7 @@ static struct i2c_driver st21nfca_hci_i2c_driver = {
 		.of_match_table = of_match_ptr(of_st21nfca_i2c_match),
 		.acpi_match_table = ACPI_PTR(st21nfca_hci_i2c_acpi_match),
 	},
-	.probe = st21nfca_hci_i2c_probe,
+	.probe_new = st21nfca_hci_i2c_probe,
 	.id_table = st21nfca_hci_i2c_id_table,
 	.remove = st21nfca_hci_i2c_remove,
 };
-- 
2.38.1

