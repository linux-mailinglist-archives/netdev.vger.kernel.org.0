Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29D853C8AB
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243714AbiFCK3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243703AbiFCK3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:29:34 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C913B563;
        Fri,  3 Jun 2022 03:29:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 15so6893995pfy.3;
        Fri, 03 Jun 2022 03:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6A3iu3rNJWzBkutodRRieEYgk6pwGMMZT+XJ2wM+6eA=;
        b=fhosUP+l3BU/qFj8oHGlC2pTDy/MwsvcIj+aMHQIY67yLhDlnMo8hi1YBn6t1qJuzn
         6W/AlKo63G3a5wsEn/FnlFyMyIlkz2UPro6Te/MY876SpJaXbfd71q+i3cHEva4eZYhG
         t5neDRTOtI2Xvx8xV54lzs7sRbWXWgE1YVZdlg5sucKsb604n367+EaMDp3RnprWeipd
         7u7/iIvdUzqIs9VSdUXBdd3ksIgy8RY8afWoej9hs0W82mujm/s00Sa6KAsjhQHnEZiv
         dHUv3ClRoHJv5LCauv0IHdXtfathokMu/s3h93W/rpfIjjp55Sm5+VnaG754P9Awo01B
         gt0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=6A3iu3rNJWzBkutodRRieEYgk6pwGMMZT+XJ2wM+6eA=;
        b=SE01ciwqLfcZsz05FGhLb8ZmBhESXMG7XvcQhCleUdu7eAyVpo3NDdAT+IFgU2unMd
         eyWTx6oBDhyDGd3hfJVICdVg/oqEQG6EzX6RDtSlmbqkFgZcOeVfoLNaspIQM1wPebu9
         mqnj/xFqbWIJEyAXQg1pqgprQi8nl+OlHKwU1JceJ4E27OZHNpHYIYD7T+C7MNybdsFq
         o6MBpjBH+9NrsLlEpVsg61fmDyquNcsoOuxQ4nTae9cx4335nKr69MrbXzpU09+RHzm3
         SUrJ2Jp7ay78/5IFfJnHx4lWk6iwxw+JGWhUW3LsFRZIZkZ+9AQ2VVAUrjwfU5XaQnkd
         wRyA==
X-Gm-Message-State: AOAM530Lqnwy0r4nf1GEsExzHHU5GU/ATjB3EoTpW8dLr8F1e+yKOOIP
        6KTY67pU34tPQMjOZOuooAvDahB1Sf/E1Q==
X-Google-Smtp-Source: ABdhPJz0sP7Z3VZSZtL3qu64mERQ95OJxW1/Q6a92GAwgpNRrenV9xEYqx/yV4tPHLDh4sKUkdJzuw==
X-Received: by 2002:a63:cc53:0:b0:372:7d69:49fb with SMTP id q19-20020a63cc53000000b003727d6949fbmr8391718pgi.21.1654252169895;
        Fri, 03 Jun 2022 03:29:29 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id b22-20020a056a0002d600b0050dc7628182sm3041676pft.92.2022.06.03.03.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:29:29 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 2/7] can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using CAN_DEV
Date:   Fri,  3 Jun 2022 19:28:43 +0900
Message-Id: <20220603102848.17907-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
index 99f189ad35ad..b1e47f6c5586 100644
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
+	  interface to develop applications, say Y here.
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
index 5b4c813c6222..919f87e36eed 100644
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
+can-dev-$(CONFIG_CAN_DEV) += skb.o
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

