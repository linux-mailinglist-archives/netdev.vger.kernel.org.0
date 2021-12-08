Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B03246D3AC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhLHMyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhLHMyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:54:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C510C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:51:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muwPX-0003E1-Ef
        for netdev@vger.kernel.org; Wed, 08 Dec 2021 13:51:03 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F35E46BFBE6
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:50:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2BDBC6BFBC8;
        Wed,  8 Dec 2021 12:50:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9fa4d4a4;
        Wed, 8 Dec 2021 12:50:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jimmy Assarsson <extja@kvaser.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 1/8] can: bittiming: replace CAN units with the generic ones from linux/units.h
Date:   Wed,  8 Dec 2021 13:50:48 +0100
Message-Id: <20211208125055.223141-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211208125055.223141-1-mkl@pengutronix.de>
References: <20211208125055.223141-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

In [1], we introduced a set of units in linux/can/bittiming.h. Since
then, generic SI prefixes were added to linux/units.h in [2]. Those
new prefixes can perfectly replace CAN specific ones.

This patch replaces all occurrences of the CAN units with their
corresponding prefix (from linux/units) and the unit (as a comment)
according to below table.

 CAN units	SI metric prefix (from linux/units) + unit (as a comment)
 ------------------------------------------------------------------------
 CAN_KBPS	KILO /* BPS */
 CAN_MBPS	MEGA /* BPS */
 CAM_MHZ	MEGA /* Hz */

The definition are then removed from linux/can/bittiming.h

[1] commit 1d7750760b70 ("can: bittiming: add CAN_KBPS, CAN_MBPS and
CAN_MHZ macros")

[2] commit 26471d4a6cf8 ("units: Add SI metric prefix definitions")

Link: https://lore.kernel.org/all/20211124014536.782550-1-mailhol.vincent@wanadoo.fr
Suggested-by: Jimmy Assarsson <extja@kvaser.com>
Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c           | 5 +++--
 drivers/net/can/usb/etas_es58x/es581_4.c  | 5 +++--
 drivers/net/can/usb/etas_es58x/es58x_fd.c | 5 +++--
 include/linux/can/bittiming.h             | 7 -------
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 0509625c3082..d5fca3bfaf9a 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
  */
 
+#include <linux/units.h>
 #include <linux/can/dev.h>
 
 #ifdef CONFIG_CAN_CALC_BITTIMING
@@ -81,9 +82,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	if (bt->sample_point) {
 		sample_point_nominal = bt->sample_point;
 	} else {
-		if (bt->bitrate > 800 * CAN_KBPS)
+		if (bt->bitrate > 800 * KILO /* BPS */)
 			sample_point_nominal = 750;
-		else if (bt->bitrate > 500 * CAN_KBPS)
+		else if (bt->bitrate > 500 * KILO /* BPS */)
 			sample_point_nominal = 800;
 		else
 			sample_point_nominal = 875;
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
index 14e360c9f2c9..1bcdcece5ec7 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.c
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/units.h>
 #include <asm/unaligned.h>
 
 #include "es58x_core.h"
@@ -469,8 +470,8 @@ const struct es58x_parameters es581_4_param = {
 	.bittiming_const = &es581_4_bittiming_const,
 	.data_bittiming_const = NULL,
 	.tdc_const = NULL,
-	.bitrate_max = 1 * CAN_MBPS,
-	.clock = {.freq = 50 * CAN_MHZ},
+	.bitrate_max = 1 * MEGA /* BPS */,
+	.clock = {.freq = 50 * MEGA /* Hz */},
 	.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC,
 	.tx_start_of_frame = 0xAFAF,
 	.rx_start_of_frame = 0xFAFA,
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index 4f0cae29f4d8..ec87126e1a7d 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/units.h>
 #include <asm/unaligned.h>
 
 #include "es58x_core.h"
@@ -522,8 +523,8 @@ const struct es58x_parameters es58x_fd_param = {
 	 * Mbps work in an optimal environment but are not recommended
 	 * for production environment.
 	 */
-	.bitrate_max = 8 * CAN_MBPS,
-	.clock = {.freq = 80 * CAN_MHZ},
+	.bitrate_max = 8 * MEGA /* BPS */,
+	.clock = {.freq = 80 * MEGA /* Hz */},
 	.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY |
 	    CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
 	    CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_TDC_AUTO,
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 20b50baf3a02..a81652d1c6f3 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -12,13 +12,6 @@
 #define CAN_SYNC_SEG 1
 
 
-/* Kilobits and Megabits per second */
-#define CAN_KBPS 1000UL
-#define CAN_MBPS 1000000UL
-
-/* Megahertz */
-#define CAN_MHZ 1000000UL
-
 #define CAN_CTRLMODE_TDC_MASK					\
 	(CAN_CTRLMODE_TDC_AUTO | CAN_CTRLMODE_TDC_MANUAL)
 

base-commit: 1fe5b01262844be03de98afdd56d1d393df04d7e
-- 
2.33.0


