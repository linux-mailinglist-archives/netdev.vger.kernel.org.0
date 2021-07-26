Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689E43D5B5A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhGZNds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbhGZNd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C379DC0619E0
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LY-0002Mr-6Z
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:44 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9A27A6582D0
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:26 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C6C0C658206;
        Mon, 26 Jul 2021 14:12:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9ca0619f;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 34/46] can: peak_usb: pcan_usb_get_device_id(): read value only in case of success
Date:   Mon, 26 Jul 2021 16:11:32 +0200
Message-Id: <20210726141144.862529-35-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

In case of error, reading value from response argument is useless.

Link: https://lore.kernel.org/r/20210625130931.27438-2-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 1d6f77252f01..9f3e16684e28 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -384,7 +384,8 @@ static int pcan_usb_get_device_id(struct peak_usb_device *dev, u32 *device_id)
 	if (err)
 		netdev_err(dev->netdev, "getting device id failure: %d\n", err);
 
-	*device_id = args[0];
+	else
+		*device_id = args[0];
 
 	return err;
 }
-- 
2.30.2


