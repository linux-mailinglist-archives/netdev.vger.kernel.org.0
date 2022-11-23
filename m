Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF27634F3D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiKWEzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbiKWEzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C765FE06B3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 642C160916
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D88C433B5;
        Wed, 23 Nov 2022 04:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179314;
        bh=UKRuycntyQsrTVBx85kQf1/TxBbtwJti++PBJwHUKWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vvjl3Dih7sljjtIp1At0h4IKDh1VxCiXD7fZ1ra0GnmgYwSVJPiChHsNoMGA04bjp
         5XOXQ/cPln+97nqo94Bp+Ra1R2wLIpDA57+B3U++Sc8ySA/gW6YbTvV4qvjQbGwPih
         7BU8mYEujkYZr9KeBoNfUd6COletmqxdKgrSbiM8/YzQmg7IQedkbNLyzJO1iJFmHT
         7Kc2GSkUhESLJb/g3ALYYXK11bIg9ZA6SnORxR75fPpj1bXzJpF2BFrom1Xq/jbBkj
         L5spvaebTfi2NZBoaUDGvkG0n+lHE76Q7ngKZ5X/OmzZaBS0WBUOk6EZZ0WcSa26RT
         UKEI1KXWj+L1A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 06/12] nfc: mrvl: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:55:01 -0800
Message-Id: <20221123045507.2091409-7-kuba@kernel.org>
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

