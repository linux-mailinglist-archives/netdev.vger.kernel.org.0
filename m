Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304825860CF
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiGaTUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbiGaTUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0A8DFEE
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUO-0007AW-RM
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 30BDEBEC2D
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B1FD9BEC22;
        Sun, 31 Jul 2022 19:20:33 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0fe2b58e;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/36] can: kvaser_usb: use KBUILD_MODNAME instead of hard coded names
Date:   Sun, 31 Jul 2022 21:20:00 +0200
Message-Id: <20220731192029.746751-8-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The driver uses the string "kvaser_usb" to populate
usb_driver::name. KBUILD_MODNAME also evaluates to "kvaser_ubs". Use
KBUILD_MODNAME and get rid on the hardcoded string names.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220726082707.58758-8-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index f211bfcb1d97..ce60b16ac8ee 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -869,7 +869,7 @@ static void kvaser_usb_disconnect(struct usb_interface *intf)
 }
 
 static struct usb_driver kvaser_usb_driver = {
-	.name = "kvaser_usb",
+	.name = KBUILD_MODNAME,
 	.probe = kvaser_usb_probe,
 	.disconnect = kvaser_usb_disconnect,
 	.id_table = kvaser_usb_table,
-- 
2.35.1


