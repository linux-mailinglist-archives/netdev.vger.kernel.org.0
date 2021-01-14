Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7D2F5BC8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbhANH5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbhANH5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:57:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E4CC0617A2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:56:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzxUX-00072h-D4
        for netdev@vger.kernel.org; Thu, 14 Jan 2021 08:56:25 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0F53E5C3622
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 07:56:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0CD0D5C35FC;
        Thu, 14 Jan 2021 07:56:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fbe1ac91;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [net-next 03/17] can: dev: move driver related infrastructure into separate subdir
Date:   Thu, 14 Jan 2021 08:56:03 +0100
Message-Id: <20210114075617.1402597-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114075617.1402597-1-mkl@pengutronix.de>
References: <20210114075617.1402597-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the CAN driver related infrastructure into a separate subdir.
It will be split into more files in the coming patches.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Makefile               | 7 +------
 drivers/net/can/dev/Makefile           | 7 +++++++
 drivers/net/can/{ => dev}/dev.c        | 0
 drivers/net/can/{ => dev}/rx-offload.c | 0
 4 files changed, 8 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/can/dev/Makefile
 rename drivers/net/can/{ => dev}/dev.c (100%)
 rename drivers/net/can/{ => dev}/rx-offload.c (100%)

diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 22164300122d..a2b4463d8480 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -7,12 +7,7 @@ obj-$(CONFIG_CAN_VCAN)		+= vcan.o
 obj-$(CONFIG_CAN_VXCAN)		+= vxcan.o
 obj-$(CONFIG_CAN_SLCAN)		+= slcan.o
 
-obj-$(CONFIG_CAN_DEV)		+= can-dev.o
-can-dev-y			+= dev.o
-can-dev-y			+= rx-offload.o
-
-can-dev-$(CONFIG_CAN_LEDS)	+= led.o
-
+obj-y				+= dev/
 obj-y				+= rcar/
 obj-y				+= spi/
 obj-y				+= usb/
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
new file mode 100644
index 000000000000..cba92e6bcf6f
--- /dev/null
+++ b/drivers/net/can/dev/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CAN_DEV)		+= can-dev.o
+can-dev-y			+= dev.o
+can-dev-y			+= rx-offload.o
+
+can-dev-$(CONFIG_CAN_LEDS)	+= led.o
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev/dev.c
similarity index 100%
rename from drivers/net/can/dev.c
rename to drivers/net/can/dev/dev.c
diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/dev/rx-offload.c
similarity index 100%
rename from drivers/net/can/rx-offload.c
rename to drivers/net/can/dev/rx-offload.c
-- 
2.29.2


