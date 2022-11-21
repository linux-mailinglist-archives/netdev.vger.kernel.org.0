Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317C3632CD7
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiKUTQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiKUTQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75A2D53BB
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52544B815C8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44CAC43145;
        Mon, 21 Nov 2022 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058151;
        bh=9V+rNjkjdxDUTad45j0N4LOvclMD+V9X0PzfICi+ha0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC84VNETh7lxpBXT2G7HgvlmtDXkGr8UJnvr3Eeaf2Yr+rrW2Eiy+jRROjkHRPXk4
         NDBYZotd5ZWrORzRFfm5UFXLq7Y2kCqvg07/QC7coIb8W6swpbBSnVYxDMKstkHMBm
         gEKPPUpXilV4U9s/iogZ3ei+YPlMN8zjZWd6XSeFQMk3tlIoXimF0Ow4EnaUIPgNpT
         nmSyVeJeNbV1uoPBT0rL8aaTdvgSa57X+9vW7gLOgNiJVluEGIszTiluzCqDAbnS1b
         9u0lGnk+as9snJ5+uvrymGm6jI/eVbjrnPq1Ed5iI0eUJze3ZK4PxkwX9z9g+jt47L
         Gs57ZSFNqYETg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 07/12] NFC: nxp-nci: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:41 -0800
Message-Id: <20221121191546.1853970-8-kuba@kernel.org>
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
 drivers/nfc/nxp-nci/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index ec6446511984..d4c299be7949 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -263,8 +263,7 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
 	{ }
 };
 
-static int nxp_nci_i2c_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+static int nxp_nci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct nxp_nci_i2c_phy *phy;
@@ -349,7 +348,7 @@ static struct i2c_driver nxp_nci_i2c_driver = {
 		   .acpi_match_table = ACPI_PTR(acpi_id),
 		   .of_match_table = of_nxp_nci_i2c_match,
 		  },
-	.probe = nxp_nci_i2c_probe,
+	.probe_new = nxp_nci_i2c_probe,
 	.id_table = nxp_nci_i2c_id_table,
 	.remove = nxp_nci_i2c_remove,
 };
-- 
2.38.1

