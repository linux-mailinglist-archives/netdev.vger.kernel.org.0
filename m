Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1B4632CD8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiKUTRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKUTQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FDAD53B9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201476142D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546AEC43147;
        Mon, 21 Nov 2022 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058152;
        bh=Su6kfkxatbFFjdL0cqvrD9NaKGJqNFqgxti96jNa/XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoft2NE+dBFIcqFNl7tUMdCnRZOw//vU5TuRFsYPiFXFCUPnxWYJPhRSdvDMXriql
         R+Hg2RX4hrb/nt9P7Yxn4LdeVT4SCKEFWt5qkN0uwoURSxfKJidkcrVZ++qKnsGb0d
         ThcLqRp+yzdZebEhJd5rgC/A/chh6c9XW4ivtBBomOAmkQD7C9hqc+kg0swkZ2lzei
         zrQpawjk3uGRXGrXg1M+Lw2HtRT2dNtzeOUbiKLZdj+eWXcemTbOH8nWkFUJNZBbd4
         u07UpohQmEn3Sb8I0WWB4t/IUIpCsPrWpu2I2bmuTlzz5VU8sFA3soxt3hmh0QjEmj
         Mww0tpOyptW2w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next 11/12] nfc: st-nci: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:45 -0800
Message-Id: <20221121191546.1853970-12-kuba@kernel.org>
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

