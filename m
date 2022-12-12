Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EA2649DB4
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiLLLbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbiLLLbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3DC6324
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1T-0000RO-DJ
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:03 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DD5F513CC04
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C2F1713CBB2;
        Mon, 12 Dec 2022 11:30:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a5588975;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 20/39] can: etas_es58x: remove es58x_get_product_info()
Date:   Mon, 12 Dec 2022 12:30:26 +0100
Message-Id: <20221212113045.222493-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Now that the product information are available under devlink, no more
need to print them in the kernel log. Remove es58x_get_product_info().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/all/20221130174658.29282-7-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 52 ++-------------------
 1 file changed, 3 insertions(+), 49 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 4d6d5a4ac06e..0c7f7505632c 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2141,48 +2141,6 @@ static void es58x_free_netdevs(struct es58x_device *es58x_dev)
 	}
 }
 
-/**
- * es58x_get_product_info() - Get the product information and print them.
- * @es58x_dev: ES58X device.
- *
- * Do a synchronous call to get the product information.
- *
- * Return: zero on success, errno when any error occurs.
- */
-static int es58x_get_product_info(struct es58x_device *es58x_dev)
-{
-	struct usb_device *udev = es58x_dev->udev;
-	const int es58x_prod_info_idx = 6;
-	/* Empirical tests show a prod_info length of maximum 83,
-	 * below should be more than enough.
-	 */
-	const size_t prod_info_len = 127;
-	char *prod_info;
-	int ret;
-
-	prod_info = kmalloc(prod_info_len, GFP_KERNEL);
-	if (!prod_info)
-		return -ENOMEM;
-
-	ret = usb_string(udev, es58x_prod_info_idx, prod_info, prod_info_len);
-	if (ret < 0) {
-		dev_err(es58x_dev->dev,
-			"%s: Could not read the product info: %pe\n",
-			__func__, ERR_PTR(ret));
-		goto out_free;
-	}
-	if (ret >= prod_info_len - 1) {
-		dev_warn(es58x_dev->dev,
-			 "%s: Buffer is too small, result might be truncated\n",
-			 __func__);
-	}
-	dev_info(es58x_dev->dev, "Product info: %s\n", prod_info);
-
- out_free:
-	kfree(prod_info);
-	return ret < 0 ? ret : 0;
-}
-
 /**
  * es58x_init_es58x_dev() - Initialize the ES58X device.
  * @intf: USB interface.
@@ -2261,28 +2219,24 @@ static int es58x_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
 	struct es58x_device *es58x_dev;
-	int ch_idx, ret;
+	int ch_idx;
 
 	es58x_dev = es58x_init_es58x_dev(intf, id->driver_info);
 	if (IS_ERR(es58x_dev))
 		return PTR_ERR(es58x_dev);
 
-	ret = es58x_get_product_info(es58x_dev);
-	if (ret)
-		return ret;
-
 	es58x_parse_product_info(es58x_dev);
 	devlink_register(priv_to_devlink(es58x_dev));
 
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
-		ret = es58x_init_netdev(es58x_dev, ch_idx);
+		int ret = es58x_init_netdev(es58x_dev, ch_idx);
 		if (ret) {
 			es58x_free_netdevs(es58x_dev);
 			return ret;
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.35.1


