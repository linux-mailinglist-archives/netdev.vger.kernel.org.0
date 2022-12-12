Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EEE649DB3
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiLLLbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiLLLbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D469958C
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1R-0000LT-6Q
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E8DEE13CBE2
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0128313CB95;
        Mon, 12 Dec 2022 11:30:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 61a9a8d1;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 16/39] USB: core: export usb_cache_string()
Date:   Mon, 12 Dec 2022 12:30:22 +0100
Message-Id: <20221212113045.222493-17-mkl@pengutronix.de>
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

usb_cache_string() can also be useful for the drivers so export it.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/all/20221130174658.29282-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/usb/core/message.c | 1 +
 drivers/usb/core/usb.h     | 1 -
 include/linux/usb.h        | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 4d59d927ae3e..127fac1af676 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1037,6 +1037,7 @@ char *usb_cache_string(struct usb_device *udev, int index)
 	}
 	return smallbuf;
 }
+EXPORT_SYMBOL_GPL(usb_cache_string);
 
 /*
  * usb_get_device_descriptor - (re)reads the device descriptor (usbcore)
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 82538daac8b8..0eac7d4285d1 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -47,7 +47,6 @@ extern int usb_get_device_descriptor(struct usb_device *dev,
 extern int usb_set_isoch_delay(struct usb_device *dev);
 extern int usb_get_bos_descriptor(struct usb_device *dev);
 extern void usb_release_bos_descriptor(struct usb_device *dev);
-extern char *usb_cache_string(struct usb_device *udev, int index);
 extern int usb_set_configuration(struct usb_device *dev, int configuration);
 extern int usb_choose_configuration(struct usb_device *udev);
 extern int usb_generic_driver_probe(struct usb_device *udev);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 9ff1ad4dfad1..d2d2f41052c0 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1829,6 +1829,7 @@ static inline int usb_get_ptm_status(struct usb_device *dev, void *data)
 
 extern int usb_string(struct usb_device *dev, int index,
 	char *buf, size_t size);
+extern char *usb_cache_string(struct usb_device *udev, int index);
 
 /* wrappers that also update important state inside usbcore */
 extern int usb_clear_halt(struct usb_device *dev, int pipe);
-- 
2.35.1


