Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10595488663
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbiAHVoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiAHVoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECC6C061759
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:07 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVN-0004YM-TW
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:05 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E579B6D3A8E
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id ADAC46D3A22;
        Sat,  8 Jan 2022 21:43:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 65d7dcdc;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 15/22] can: flexcan: move driver into separate sub directory
Date:   Sat,  8 Jan 2022 22:43:38 +0100
Message-Id: <20220108214345.1848470-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108214345.1848470-1-mkl@pengutronix.de>
References: <20220108214345.1848470-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the flexcan driver into a separate directory, a later
patch will add more files.

Link: https://lore.kernel.org/all/20220107193105.1699523-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Makefile                              | 2 +-
 drivers/net/can/flexcan/Makefile                      | 6 ++++++
 drivers/net/can/{flexcan.c => flexcan/flexcan-core.c} | 0
 3 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/can/flexcan/Makefile
 rename drivers/net/can/{flexcan.c => flexcan/flexcan-core.c} (100%)

diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index a2b4463d8480..1e660afcb61b 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -16,7 +16,7 @@ obj-y				+= softing/
 obj-$(CONFIG_CAN_AT91)		+= at91_can.o
 obj-$(CONFIG_CAN_CC770)		+= cc770/
 obj-$(CONFIG_CAN_C_CAN)		+= c_can/
-obj-$(CONFIG_CAN_FLEXCAN)	+= flexcan.o
+obj-$(CONFIG_CAN_FLEXCAN)	+= flexcan/
 obj-$(CONFIG_CAN_GRCAN)		+= grcan.o
 obj-$(CONFIG_CAN_IFI_CANFD)	+= ifi_canfd/
 obj-$(CONFIG_CAN_JANZ_ICAN3)	+= janz-ican3.o
diff --git a/drivers/net/can/flexcan/Makefile b/drivers/net/can/flexcan/Makefile
new file mode 100644
index 000000000000..25dd1d12b866
--- /dev/null
+++ b/drivers/net/can/flexcan/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CAN_FLEXCAN) += flexcan.o
+
+flexcan-objs :=
+flexcan-objs += flexcan-core.o
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan/flexcan-core.c
similarity index 100%
rename from drivers/net/can/flexcan.c
rename to drivers/net/can/flexcan/flexcan-core.c
-- 
2.34.1


