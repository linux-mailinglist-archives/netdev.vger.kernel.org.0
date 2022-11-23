Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBC8634F3B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbiKWEzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiKWEzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0396E0756
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D285261A4D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E834C43470;
        Wed, 23 Nov 2022 04:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179314;
        bh=9V+rNjkjdxDUTad45j0N4LOvclMD+V9X0PzfICi+ha0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqTcMoOYXhjBX5CfyRD8fDXhe4Z4/F3lxUcD1jgnb3KTdkU7kXDtKUvEht4XzKkX+
         JgoJN5WTMciHIZzt+zUooy8cI0B0MjVjAWWU5Z2VMjzc0/+ej1PemftsZX7Vc7az7O
         ZwVUOh0Q2iwW5DcUXtcjMDRKdfdCQNv1Zqhb6meI6L8q24M45ccnabX7NyxVksrd/l
         AAGVHfVpl9MVOXN6h2dFHQJ8GaR9mm44cv+xJrE5qvW3tqaf2g37Wxmi1Qf+alMVQ5
         SIeB0CsUtRTRym7TvSnpoHEClAbp6YbQ+UyPRU1pLJdBkXoBGo6b5RYfM5dt6HLm+7
         kqL2RKueDHhbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 07/12] NFC: nxp-nci: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:55:02 -0800
Message-Id: <20221123045507.2091409-8-kuba@kernel.org>
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

