Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7035DBE7
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbhDMJx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242957AbhDMJxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:53:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8B0C06135A
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:52:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWFib-0002lK-9W
        for netdev@vger.kernel.org; Tue, 13 Apr 2021 11:52:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CE2BD60DAD0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:52:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8CA1C60DA74;
        Tue, 13 Apr 2021 09:52:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3116ee4e;
        Tue, 13 Apr 2021 09:52:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [net-next 13/14] can: peak_usb: pcan_usb_get_serial(): unconditionally assign serial_number
Date:   Tue, 13 Apr 2021 11:52:00 +0200
Message-Id: <20210413095201.2409865-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413095201.2409865-1-mkl@pengutronix.de>
References: <20210413095201.2409865-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function serial_number is only called from one location with a
valid serial_number pointer. Remove not needed NULL pointer check.

Link: https://lore.kernel.org/r/20210406111622.1874957-10-mkl@pengutronix.de
Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
Tested-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index ffb01c3a3827..929cc1b05aa2 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -367,9 +367,7 @@ static int pcan_usb_get_serial(struct peak_usb_device *dev, u32 *serial_number)
 	err = pcan_usb_wait_rsp(dev, PCAN_USB_CMD_SN, PCAN_USB_GET, args);
 	if (err)
 		return err;
-
-	if (serial_number)
-		*serial_number = le32_to_cpup((__le32 *)args);
+	*serial_number = le32_to_cpup((__le32 *)args);
 
 	return 0;
 }
-- 
2.30.2


