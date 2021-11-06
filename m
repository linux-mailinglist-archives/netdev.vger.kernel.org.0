Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D84470D0
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 22:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhKFV5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 17:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbhKFV5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 17:57:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622CFC06120E
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 14:55:05 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mjTeR-0000zj-Pa
        for netdev@vger.kernel.org; Sat, 06 Nov 2021 22:55:03 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2DE416A5FAB
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 21:55:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EC2856A5F88;
        Sat,  6 Nov 2021 21:54:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 072e02fa;
        Sat, 6 Nov 2021 21:54:50 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 6/8] can: peak_usb: exchange the order of information messages
Date:   Sat,  6 Nov 2021 22:54:47 +0100
Message-Id: <20211106215449.57946-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106215449.57946-1-mkl@pengutronix.de>
References: <20211106215449.57946-1-mkl@pengutronix.de>
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

Proposes the possible update of the PCAN-USB firmware after indicating its
name and current version.

Link: https://lore.kernel.org/all/20211021081505.18223-3-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index af8d3dadbbb8..876218752766 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -883,6 +883,11 @@ static int pcan_usb_init(struct peak_usb_device *dev)
 		return err;
 	}
 
+	dev_info(dev->netdev->dev.parent,
+		 "PEAK-System %s adapter hwrev %u serial %08X (%u channel)\n",
+		 pcan_usb.name, dev->device_rev, serial_number,
+		 pcan_usb.ctrl_count);
+
 	/* Since rev 4.1, PCAN-USB is able to make single-shot as well as
 	 * looped back frames.
 	 */
@@ -896,11 +901,6 @@ static int pcan_usb_init(struct peak_usb_device *dev)
 			 "Firmware update available. Please contact support@peak-system.com\n");
 	}
 
-	dev_info(dev->netdev->dev.parent,
-		 "PEAK-System %s adapter hwrev %u serial %08X (%u channel)\n",
-		 pcan_usb.name, dev->device_rev, serial_number,
-		 pcan_usb.ctrl_count);
-
 	return 0;
 }
 
-- 
2.33.0


