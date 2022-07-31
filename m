Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5025860C8
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiGaTUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiGaTUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37314DFD0
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUO-00079s-65
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C76D0BEC25
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3065BBEC18;
        Sun, 31 Jul 2022 19:20:33 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6572631a;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/36] can: gs_ubs: use KBUILD_MODNAME instead of hard coded names
Date:   Sun, 31 Jul 2022 21:19:59 +0200
Message-Id: <20220731192029.746751-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The driver uses the string "gs_usb" to populate usb_driver::name,
can_bittiming_const::name and
can_data_bittiming_const::name. KBUILD_MODNAME evaluates to
"gs_ubs". Use KBUILD_MODNAME and get rid on the hardcoded string
names.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220726082707.58758-7-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index d3a658b444b5..fd239b523c42 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -993,7 +993,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	netdev->flags |= IFF_ECHO; /* we support full roundtrip echo */
 
 	/* dev setup */
-	strcpy(dev->bt_const.name, "gs_usb");
+	strcpy(dev->bt_const.name, KBUILD_MODNAME);
 	dev->bt_const.tseg1_min = le32_to_cpu(bt_const->tseg1_min);
 	dev->bt_const.tseg1_max = le32_to_cpu(bt_const->tseg1_max);
 	dev->bt_const.tseg2_min = le32_to_cpu(bt_const->tseg2_min);
@@ -1100,7 +1100,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 			return ERR_PTR(rc);
 		}
 
-		strcpy(dev->data_bt_const.name, "gs_usb");
+		strcpy(dev->data_bt_const.name, KBUILD_MODNAME);
 		dev->data_bt_const.tseg1_min = le32_to_cpu(bt_const_extended->dtseg1_min);
 		dev->data_bt_const.tseg1_max = le32_to_cpu(bt_const_extended->dtseg1_max);
 		dev->data_bt_const.tseg2_min = le32_to_cpu(bt_const_extended->dtseg2_min);
@@ -1270,7 +1270,7 @@ static const struct usb_device_id gs_usb_table[] = {
 MODULE_DEVICE_TABLE(usb, gs_usb_table);
 
 static struct usb_driver gs_usb_driver = {
-	.name = "gs_usb",
+	.name = KBUILD_MODNAME,
 	.probe = gs_usb_probe,
 	.disconnect = gs_usb_disconnect,
 	.id_table = gs_usb_table,
-- 
2.35.1


