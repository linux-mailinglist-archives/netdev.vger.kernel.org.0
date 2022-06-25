Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1407E55A9B5
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiFYMG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiFYMGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA001704B
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YI-0002SY-Pp
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2223E9F17C
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:04:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4C2509F163;
        Sat, 25 Jun 2022 12:03:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id de146f3a;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Max Staudt <max@enpas.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/22] can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using CAN_DEV
Date:   Sat, 25 Jun 2022 14:03:19 +0200
Message-Id: <20220625120335.324697-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

In the next patches, the software/virtual drivers (slcan, v(x)can)
will depend on drivers/net/can/dev/skb.o.

This patch changes the scope of the can-dev module to include the
above mentioned drivers.

To do so, we reuse the menu "CAN Device Drivers" and turn it into a
configmenu using the config symbol CAN_DEV (which we released in
previous patch). Also, add a description to this new CAN_DEV
menuconfig.

The symbol CAN_DEV now only triggers the build of skb.o. For this
reasons, all the macros from linux/module.h are deported from
drivers/net/can/dev/dev.c to drivers/net/can/dev/skb.c.

Finally, drivers/net/can/dev/Makefile is adjusted accordingly.

Link: https://lore.kernel.org/all/20220610143009.323579-3-mailhol.vincent@wanadoo.fr
Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Max Staudt <max@enpas.org>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Kconfig      | 29 ++++++++++++++++++++++++++---
 drivers/net/can/dev/Makefile | 16 +++++++++-------
 drivers/net/can/dev/dev.c    |  9 +--------
 drivers/net/can/dev/skb.c    |  7 +++++++
 4 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 99f189ad35ad..3c692af16676 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -1,5 +1,25 @@
 # SPDX-License-Identifier: GPL-2.0-only
-menu "CAN Device Drivers"
+
+menuconfig CAN_DEV
+	tristate "CAN Device Drivers"
+	default y
+	help
+	  Controller Area Network (CAN) is serial communications protocol up to
+	  1Mbit/s for its original release (now known as Classical CAN) and up
+	  to 8Mbit/s for the more recent CAN with Flexible Data-Rate
+	  (CAN-FD). The CAN bus was originally mainly for automotive, but is now
+	  widely used in marine (NMEA2000), industrial, and medical
+	  applications. More information on the CAN network protocol family
+	  PF_CAN is contained in <Documentation/networking/can.rst>.
+
+	  This section contains all the CAN(-FD) device drivers including the
+	  virtual ones. If you own such devices or plan to use the virtual CAN
+	  interfaces to develop applications, say Y here.
+
+	  To compile as a module, choose M here: the module will be called
+	  can-dev.
+
+if CAN_DEV
 
 config CAN_VCAN
 	tristate "Virtual Local CAN Interface (vcan)"
@@ -49,7 +69,7 @@ config CAN_SLCAN
 	  also be built as a module. If so, the module will be called slcan.
 
 config CAN_NETLINK
-	tristate "CAN device drivers with Netlink support"
+	bool "CAN device drivers with Netlink support"
 	default y
 	help
 	  Enables the common framework for CAN device drivers. This is the
@@ -57,6 +77,9 @@ config CAN_NETLINK
 	  as bittiming validation, support of CAN error states, device restart
 	  and others.
 
+	  The additional features selected by this option will be added to the
+	  can-dev module.
+
 	  This is required by all platform and hardware CAN drivers. If you
 	  plan to use such devices or if unsure, say Y.
 
@@ -178,4 +201,4 @@ config CAN_DEBUG_DEVICES
 	  a problem with CAN support and want to see more of what is going
 	  on.
 
-endmenu
+endif #CAN_DEV
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index 5b4c813c6222..1baaf7020f7c 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -1,9 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CAN_NETLINK) += can-dev.o
-can-dev-y			+= bittiming.o
-can-dev-y			+= dev.o
-can-dev-y			+= length.o
-can-dev-y			+= netlink.o
-can-dev-y			+= rx-offload.o
-can-dev-y                       += skb.o
+obj-$(CONFIG_CAN_DEV) += can-dev.o
+
+can-dev-y += skb.o
+
+can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
+can-dev-$(CONFIG_CAN_NETLINK) += dev.o
+can-dev-$(CONFIG_CAN_NETLINK) += length.o
+can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
+can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 96c9d9db00cf..523eaacfe29e 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
  */
 
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
@@ -17,12 +16,6 @@
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
 
-#define MOD_DESC "CAN device driver interface"
-
-MODULE_DESCRIPTION(MOD_DESC);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Wolfgang Grandegger <wg@grandegger.com>");
-
 static void can_update_state_error_stats(struct net_device *dev,
 					 enum can_state new_state)
 {
@@ -513,7 +506,7 @@ static __init int can_dev_init(void)
 
 	err = can_netlink_register();
 	if (!err)
-		pr_info(MOD_DESC "\n");
+		pr_info("CAN device driver interface\n");
 
 	return err;
 }
diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 61660248c69e..a4208f125b76 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -5,6 +5,13 @@
  */
 
 #include <linux/can/dev.h>
+#include <linux/module.h>
+
+#define MOD_DESC "CAN device driver interface"
+
+MODULE_DESCRIPTION(MOD_DESC);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Wolfgang Grandegger <wg@grandegger.com>");
 
 /* Local echo of CAN messages
  *
-- 
2.35.1


