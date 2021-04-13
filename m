Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F46635DBE6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbhDMJx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242878AbhDMJxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:53:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD723C061358
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:52:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWFib-0002jA-6D
        for netdev@vger.kernel.org; Tue, 13 Apr 2021 11:52:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3CF9760DAC7
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:52:19 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8EA9960DA57;
        Tue, 13 Apr 2021 09:52:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8cfdf408;
        Tue, 13 Apr 2021 09:52:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [net-next 08/14] can: peak_usb: remove write only variable struct peak_usb_adapter::ts_period
Date:   Tue, 13 Apr 2021 11:51:55 +0200
Message-Id: <20210413095201.2409865-9-mkl@pengutronix.de>
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

The variable struct peak_usb_adapter::ts_period is only ever written
to. This patch removes it from the driver.

Link: https://lore.kernel.org/r/20210406111622.1874957-5-mkl@pengutronix.de
Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
Tested-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c      | 1 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.h | 1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   | 4 ----
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  | 1 -
 4 files changed, 7 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index e23049c81159..38bee69ff48a 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -1050,7 +1050,6 @@ const struct peak_usb_adapter pcan_usb = {
 
 	/* timestamps usage */
 	.ts_used_bits = 16,
-	.ts_period = 24575, /* calibration period in ts. */
 	.us_per_ts_scale = PCAN_USB_TS_US_PER_TICK, /* us=(ts*scale) */
 	.us_per_ts_shift = PCAN_USB_TS_DIV_SHIFTER, /*  >> shift     */
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index 64c4c22bb296..b00a4811bf61 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -73,7 +73,6 @@ struct peak_usb_adapter {
 	u8 ep_msg_in;
 	u8 ep_msg_out[PCAN_USB_MAX_CHANNEL];
 	u8 ts_used_bits;
-	u32 ts_period;
 	u8 us_per_ts_shift;
 	u32 us_per_ts_scale;
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 6f62b6f51051..b11eabad575b 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -1081,7 +1081,6 @@ const struct peak_usb_adapter pcan_usb_fd = {
 
 	/* timestamps usage */
 	.ts_used_bits = 32,
-	.ts_period = 1000000, /* calibration period in ts. */
 	.us_per_ts_scale = 1, /* us = (ts * scale) >> shift */
 	.us_per_ts_shift = 0,
 
@@ -1156,7 +1155,6 @@ const struct peak_usb_adapter pcan_usb_chip = {
 
 	/* timestamps usage */
 	.ts_used_bits = 32,
-	.ts_period = 1000000, /* calibration period in ts. */
 	.us_per_ts_scale = 1, /* us = (ts * scale) >> shift */
 	.us_per_ts_shift = 0,
 
@@ -1231,7 +1229,6 @@ const struct peak_usb_adapter pcan_usb_pro_fd = {
 
 	/* timestamps usage */
 	.ts_used_bits = 32,
-	.ts_period = 1000000, /* calibration period in ts. */
 	.us_per_ts_scale = 1, /* us = (ts * scale) >> shift */
 	.us_per_ts_shift = 0,
 
@@ -1306,7 +1303,6 @@ const struct peak_usb_adapter pcan_usb_x6 = {
 
 	/* timestamps usage */
 	.ts_used_bits = 32,
-	.ts_period = 1000000, /* calibration period in ts. */
 	.us_per_ts_scale = 1, /* us = (ts * scale) >> shift */
 	.us_per_ts_shift = 0,
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index ecb08359f719..589ba797fb33 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -1058,7 +1058,6 @@ const struct peak_usb_adapter pcan_usb_pro = {
 
 	/* timestamps usage */
 	.ts_used_bits = 32,
-	.ts_period = 1000000, /* calibration period in ts. */
 	.us_per_ts_scale = 1, /* us = (ts * scale) >> shift */
 	.us_per_ts_shift = 0,
 
-- 
2.30.2


