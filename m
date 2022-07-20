Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E08157B267
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbiGTILd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238843AbiGTILX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:11:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2470474FC
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4nh-0008Ql-5d
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5ABE1B5919
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:41 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A8C06B58FF;
        Wed, 20 Jul 2022 08:10:40 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ec850fba;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 11/29] can: sja1000: Change the return type as void for SoC specific init
Date:   Wed, 20 Jul 2022 10:10:16 +0200
Message-Id: <20220720081034.3277385-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Change the return type as void for SoC specific init function as it
always return 0.

Link: https://lore.kernel.org/all/20220710115248.190280-6-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/sja1000_platform.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index 0b78568f5286..81bc741905fd 100644
--- a/drivers/net/can/sja1000/sja1000_platform.c
+++ b/drivers/net/can/sja1000/sja1000_platform.c
@@ -31,7 +31,7 @@ MODULE_LICENSE("GPL v2");
 
 struct sja1000_of_data {
 	size_t  priv_sz;
-	int     (*init)(struct sja1000_priv *priv, struct device_node *of);
+	void    (*init)(struct sja1000_priv *priv, struct device_node *of);
 };
 
 struct technologic_priv {
@@ -94,15 +94,13 @@ static void sp_technologic_write_reg16(const struct sja1000_priv *priv,
 	spin_unlock_irqrestore(&tp->io_lock, flags);
 }
 
-static int sp_technologic_init(struct sja1000_priv *priv, struct device_node *of)
+static void sp_technologic_init(struct sja1000_priv *priv, struct device_node *of)
 {
 	struct technologic_priv *tp = priv->priv;
 
 	priv->read_reg = sp_technologic_read_reg16;
 	priv->write_reg = sp_technologic_write_reg16;
 	spin_lock_init(&tp->io_lock);
-
-	return 0;
 }
 
 static void sp_populate(struct sja1000_priv *priv,
@@ -266,11 +264,8 @@ static int sp_probe(struct platform_device *pdev)
 	if (of) {
 		sp_populate_of(priv, of);
 
-		if (of_data && of_data->init) {
-			err = of_data->init(priv, of);
-			if (err)
-				goto exit_free;
-		}
+		if (of_data && of_data->init)
+			of_data->init(priv, of);
 	} else {
 		sp_populate(priv, pdata, res_mem->flags);
 	}
-- 
2.35.1


