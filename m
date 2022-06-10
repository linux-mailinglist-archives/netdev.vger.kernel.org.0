Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7581B546857
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349192AbiFJOaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344927AbiFJOav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:51 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4727613CA2F;
        Fri, 10 Jun 2022 07:30:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so2233581pjb.3;
        Fri, 10 Jun 2022 07:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yv2ujViesI7iZ5pUTL94PJt7L5AXnXGvqy5kLDepAhw=;
        b=LB/Nr6LWiTuqLaJOUn2jiZMtJSRQK2oTZdwP5U2M2aWMEowlCn/xUFAFeFF23vt47Y
         V7ztAJbnSzoMkLBDsdnVf2XJz2VTBTRDxMB3FkkbonD/2kEE1tcX4lEBvmqujWp8BGC5
         zyT7+pGaOViI/28FZzelnmuhZGqlXc4GByUfBCt7lCJWSe+nCwxOnzyYLx0ArwzsXZ8L
         ycLtq+5c/hwS+dzSBn7G1NiUlm384ieK1g/vyD7mDjvh4uNrOvQWgsgL5i+qPI6gD4i8
         vo5PTDdpYTpuPUF2XG9PqVZX9XGR0T0k966/1qSpgPKZQa+GBr6UZwBG1D18zGpL7lLd
         DCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=yv2ujViesI7iZ5pUTL94PJt7L5AXnXGvqy5kLDepAhw=;
        b=Jdoo0KX1pI1zqMRZO9oMS0/eHvEQcetGPSWiOiCd8jGifC/CqzTBNLd+wHSj8zs7bO
         lGaAduWYzk0kmKzX9yY6boCFk/86EdOB4DVnpMzJC4ZF9XzsnMyjJILwTcjXZZf3Gn9w
         IOGc0TftYfBLHrAWQZDzKqA/muc/pSgAe6a8D+IuKdHvgJ9tlR4re9FDDxKLoIUSYLla
         cQmhnRjWw0errmnADKUyf3dYeYDPIyk8HSv5GESytI2M4R3dUt4YprLoX/9rWajwSjyQ
         BL2TkFuSDGskONyZNyvGB7HbG6+y1goycQZZFstIvdtsurLtVesCZssP7hGVj/V6ijed
         lB8w==
X-Gm-Message-State: AOAM5326+HA8wQSmb6/ktfOj/YRSpGOHXtfSqe2d01wSq66vf9PoSIsu
        +hjAc8vNExPeJDhe1I2AW5Q7wtHWMeYpAA==
X-Google-Smtp-Source: ABdhPJwfhhkfUEUmxIkX1fsRI4mH/9vFupfe+vU7uvGD9Rb0dqChG+Ia665LHwJqDzutB4zVBFuZ6g==
X-Received: by 2002:a17:90b:3506:b0:1e8:8449:6acb with SMTP id ls6-20020a17090b350600b001e884496acbmr46125pjb.27.1654871443711;
        Fri, 10 Jun 2022 07:30:43 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:43 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 2/7] can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using CAN_DEV
Date:   Fri, 10 Jun 2022 23:30:04 +0900
Message-Id: <20220610143009.323579-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
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

