Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36E452DE57
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiESUXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244718AbiESUXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:23:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90ABF9419B
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:23:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nrmgD-0005Ht-Qj
        for netdev@vger.kernel.org; Thu, 19 May 2022 22:23:29 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6FBC582633
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 20:23:28 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E2AC082626;
        Thu, 19 May 2022 20:23:27 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c88d6bc4;
        Thu, 19 May 2022 20:23:26 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 3/4] can: can-dev: remove obsolete CAN LED support
Date:   Thu, 19 May 2022 22:23:07 +0200
Message-Id: <20220519202308.1435903-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220519202308.1435903-1-mkl@pengutronix.de>
References: <20220519202308.1435903-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

Since commit 30f3b42147ba6f ("can: mark led trigger as broken") the
CAN specific LED support was disabled and marked as BROKEN. As the
common LED support with CONFIG_LEDS_TRIGGER_NETDEV should do this work
now the code can be removed as preparation for a CAN netdevice Kconfig
rework.

Link: https://lore.kernel.org/all/20220518154527.29046-1-socketcan@hartkopp.net
Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
[mkl: remove led.h from MAINTAINERS]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS                              |   1 -
 drivers/net/can/Kconfig                  |  17 ---
 drivers/net/can/at91_can.c               |  10 --
 drivers/net/can/c_can/c_can_main.c       |  16 +--
 drivers/net/can/ctucanfd/ctucanfd_base.c |  10 --
 drivers/net/can/dev/Makefile             |   2 -
 drivers/net/can/dev/dev.c                |   5 -
 drivers/net/can/dev/rx-offload.c         |   2 -
 drivers/net/can/flexcan/flexcan-core.c   |   7 --
 drivers/net/can/ifi_canfd/ifi_canfd.c    |   9 --
 drivers/net/can/led.c                    | 140 -----------------------
 drivers/net/can/m_can/m_can.c            |  11 --
 drivers/net/can/m_can/m_can.h            |   1 -
 drivers/net/can/rcar/rcar_can.c          |   8 --
 drivers/net/can/rcar/rcar_canfd.c        |   7 --
 drivers/net/can/sja1000/sja1000.c        |  11 --
 drivers/net/can/spi/hi311x.c             |   8 --
 drivers/net/can/spi/mcp251x.c            |  10 --
 drivers/net/can/sun4i_can.c              |   7 --
 drivers/net/can/ti_hecc.c                |   8 --
 drivers/net/can/usb/mcba_usb.c           |   8 --
 drivers/net/can/usb/usb_8dev.c           |  11 --
 drivers/net/can/xilinx_can.c             |  10 +-
 include/linux/can/dev.h                  |  10 --
 include/linux/can/led.h                  |  51 ---------
 25 files changed, 2 insertions(+), 378 deletions(-)
 delete mode 100644 drivers/net/can/led.c
 delete mode 100644 include/linux/can/led.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a29bf2452f4..234380c959c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4376,7 +4376,6 @@ F:	drivers/net/can/
 F:	drivers/phy/phy-can-transceiver.c
 F:	include/linux/can/bittiming.h
 F:	include/linux/can/dev.h
-F:	include/linux/can/led.h
 F:	include/linux/can/length.h
 F:	include/linux/can/platform/
 F:	include/linux/can/rx-offload.h
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index ac760fd39282..b2dcc1e5a388 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -71,23 +71,6 @@ config CAN_CALC_BITTIMING
 	  arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "sjw".
 	  If unsure, say Y.
 
-config CAN_LEDS
-	bool "Enable LED triggers for Netlink based drivers"
-	depends on LEDS_CLASS
-	# The netdev trigger (LEDS_TRIGGER_NETDEV) should be able to do
-	# everything that this driver is doing. This is marked as broken
-	# because it uses stuff that is intended to be changed or removed.
-	# Please consider switching to the netdev trigger and confirm it
-	# fulfills your needs instead of fixing this driver.
-	depends on BROKEN
-	select LEDS_TRIGGERS
-	help
-	  This option adds two LED triggers for packet receive and transmit
-	  events on each supported CAN device.
-
-	  Say Y here if you are working on a system with led-class supported
-	  LEDs and you want to use them as canbus activity indicators.
-
 config CAN_AT91
 	tristate "Atmel AT91 onchip CAN controller"
 	depends on (ARCH_AT91 || COMPILE_TEST) && HAS_IOMEM
diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 953aef8d3978..29ed0d3cd171 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -23,7 +23,6 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 
 #define AT91_MB_MASK(i)		((1 << (i)) - 1)
 
@@ -618,8 +617,6 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
 		stats->rx_bytes += cf->len;
 
 	netif_receive_skb(skb);
-
-	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
 /**
@@ -854,7 +851,6 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 						 mb - get_mb_tx_first(priv),
 						 NULL);
 			dev->stats.tx_packets++;
-			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
 	}
 
@@ -1101,8 +1097,6 @@ static int at91_open(struct net_device *dev)
 		goto out_close;
 	}
 
-	can_led_event(dev, CAN_LED_EVENT_OPEN);
-
 	/* start chip and queuing */
 	at91_chip_start(dev);
 	napi_enable(&priv->napi);
@@ -1133,8 +1127,6 @@ static int at91_close(struct net_device *dev)
 
 	close_candev(dev);
 
-	can_led_event(dev, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -1331,8 +1323,6 @@ static int at91_can_probe(struct platform_device *pdev)
 		goto exit_free;
 	}
 
-	devm_can_led_init(dev);
-
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 2034dbe30958..a7362af0babb 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -40,7 +40,6 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 
 #include "c_can.h"
 
@@ -759,7 +758,6 @@ static void c_can_do_tx(struct net_device *dev)
 
 	stats->tx_bytes += bytes;
 	stats->tx_packets += pkts;
-	can_led_event(dev, CAN_LED_EVENT_TX);
 
 	tail = c_can_get_tx_tail(tx_ring);
 
@@ -906,9 +904,6 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 		quota -= n;
 	}
 
-	if (pkts)
-		can_led_event(dev, CAN_LED_EVENT_RX);
-
 	return pkts;
 }
 
@@ -1182,8 +1177,6 @@ static int c_can_open(struct net_device *dev)
 	if (err)
 		goto exit_start_fail;
 
-	can_led_event(dev, CAN_LED_EVENT_OPEN);
-
 	napi_enable(&priv->napi);
 	/* enable status change, error and module interrupts */
 	c_can_irq_control(priv, true);
@@ -1214,8 +1207,6 @@ static int c_can_close(struct net_device *dev)
 	c_can_reset_ram(priv, false);
 	c_can_pm_runtime_put_sync(priv);
 
-	can_led_event(dev, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -1365,8 +1356,6 @@ static const struct net_device_ops c_can_netdev_ops = {
 
 int register_c_can_dev(struct net_device *dev)
 {
-	int err;
-
 	/* Deactivate pins to prevent DRA7 DCAN IP from being
 	 * stuck in transition when module is disabled.
 	 * Pins are activated in c_can_start() and deactivated
@@ -1378,10 +1367,7 @@ int register_c_can_dev(struct net_device *dev)
 	dev->netdev_ops = &c_can_netdev_ops;
 	c_can_set_ethtool_ops(dev);
 
-	err = register_candev(dev);
-	if (!err)
-		devm_can_led_init(dev);
-	return err;
+	return register_candev(dev);
 }
 EXPORT_SYMBOL_GPL(register_c_can_dev);
 
diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 2ada097d1ede..64990bf20fdc 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -29,7 +29,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 #include <linux/pm_runtime.h>
 
 #include "ctucanfd.h"
@@ -957,9 +956,6 @@ static int ctucan_rx_poll(struct napi_struct *napi, int quota)
 		ctucan_write32(priv, CTUCANFD_COMMAND, REG_COMMAND_CDO);
 	}
 
-	if (work_done)
-		can_led_event(ndev, CAN_LED_EVENT_RX);
-
 	if (!framecnt && res != 0) {
 		if (napi_complete_done(napi, work_done)) {
 			/* Clear and enable RBNEI. It is level-triggered, so
@@ -1079,8 +1075,6 @@ static void ctucan_tx_interrupt(struct net_device *ndev)
 		}
 	} while (some_buffers_processed);
 
-	can_led_event(ndev, CAN_LED_EVENT_TX);
-
 	spin_lock_irqsave(&priv->tx_lock, flags);
 
 	/* Check if at least one TX buffer is free */
@@ -1236,7 +1230,6 @@ static int ctucan_open(struct net_device *ndev)
 	}
 
 	netdev_info(ndev, "ctu_can_fd device registered\n");
-	can_led_event(ndev, CAN_LED_EVENT_OPEN);
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
 
@@ -1269,7 +1262,6 @@ static int ctucan_close(struct net_device *ndev)
 	free_irq(ndev->irq, ndev);
 	close_candev(ndev);
 
-	can_led_event(ndev, CAN_LED_EVENT_STOP);
 	pm_runtime_put(priv->dev);
 
 	return 0;
@@ -1434,8 +1426,6 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 		goto err_deviceoff;
 	}
 
-	devm_can_led_init(ndev);
-
 	pm_runtime_put(dev);
 
 	netdev_dbg(ndev, "mem_base=0x%p irq=%d clock=%d, no. of txt buffers:%d\n",
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index 3e2e207861fc..af2901db473c 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -7,5 +7,3 @@ can-dev-y			+= length.o
 can-dev-y			+= netlink.o
 can-dev-y			+= rx-offload.o
 can-dev-y                       += skb.o
-
-can-dev-$(CONFIG_CAN_LEDS)	+= led.o
diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index e7ab45f1c43b..96c9d9db00cf 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -14,7 +14,6 @@
 #include <linux/can/can-ml.h>
 #include <linux/can/dev.h>
 #include <linux/can/skb.h>
-#include <linux/can/led.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
 
@@ -512,8 +511,6 @@ static __init int can_dev_init(void)
 {
 	int err;
 
-	can_led_notifier_init();
-
 	err = can_netlink_register();
 	if (!err)
 		pr_info(MOD_DESC "\n");
@@ -525,8 +522,6 @@ module_init(can_dev_init);
 static __exit void can_dev_exit(void)
 {
 	can_netlink_unregister();
-
-	can_led_notifier_exit();
 }
 module_exit(can_dev_exit);
 
diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index 509d21170c8c..a32a01c172d4 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -70,8 +70,6 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
 			napi_reschedule(&offload->napi);
 	}
 
-	can_led_event(offload->dev, CAN_LED_EVENT_RX);
-
 	return work_done;
 }
 
diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index fe9bda0f5ec4..d060088047f1 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -14,7 +14,6 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/firmware/imx/sci.h>
@@ -1081,7 +1080,6 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 			can_rx_offload_get_echo_skb(&priv->offload, 0,
 						    reg_ctrl << 16, NULL);
 		stats->tx_packets++;
-		can_led_event(dev, CAN_LED_EVENT_TX);
 
 		/* after sending a RTR frame MB is in RX mode */
 		priv->write(FLEXCAN_MB_CODE_TX_INACTIVE,
@@ -1738,8 +1736,6 @@ static int flexcan_open(struct net_device *dev)
 
 	flexcan_chip_interrupts_enable(dev);
 
-	can_led_event(dev, CAN_LED_EVENT_OPEN);
-
 	netif_start_queue(dev);
 
 	return 0;
@@ -1785,8 +1781,6 @@ static int flexcan_close(struct net_device *dev)
 
 	pm_runtime_put(priv->dev);
 
-	can_led_event(dev, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -2189,7 +2183,6 @@ static int flexcan_probe(struct platform_device *pdev)
 	}
 
 	of_can_transceiver(dev);
-	devm_can_led_init(dev);
 
 	return 0;
 
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index b0a3473f211d..968ed6d7316b 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -345,9 +345,6 @@ static int ifi_canfd_do_rx_poll(struct net_device *ndev, int quota)
 		rxst = readl(priv->base + IFI_CANFD_RXSTCMD);
 	}
 
-	if (pkts)
-		can_led_event(ndev, CAN_LED_EVENT_RX);
-
 	return pkts;
 }
 
@@ -626,7 +623,6 @@ static irqreturn_t ifi_canfd_isr(int irq, void *dev_id)
 	if (isr & IFI_CANFD_INTERRUPT_TXFIFO_REMOVE) {
 		stats->tx_bytes += can_get_echo_skb(ndev, 0, NULL);
 		stats->tx_packets++;
-		can_led_event(ndev, CAN_LED_EVENT_TX);
 	}
 
 	if (isr & tx_irq_mask)
@@ -830,7 +826,6 @@ static int ifi_canfd_open(struct net_device *ndev)
 
 	ifi_canfd_start(ndev);
 
-	can_led_event(ndev, CAN_LED_EVENT_OPEN);
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
 
@@ -853,8 +848,6 @@ static int ifi_canfd_close(struct net_device *ndev)
 
 	close_candev(ndev);
 
-	can_led_event(ndev, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -1004,8 +997,6 @@ static int ifi_canfd_plat_probe(struct platform_device *pdev)
 		goto err_reg;
 	}
 
-	devm_can_led_init(ndev);
-
 	dev_info(dev, "Driver registered: regs=%p, irq=%d, clock=%d\n",
 		 priv->base, ndev->irq, priv->can.clock.freq);
 
diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
deleted file mode 100644
index db14897f8e16..000000000000
--- a/drivers/net/can/led.c
+++ /dev/null
@@ -1,140 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
- * Copyright 2012, Kurt Van Dijck <kurt.van.dijck@eia.be>
- */
-
-#include <linux/module.h>
-#include <linux/device.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/netdevice.h>
-#include <linux/can/dev.h>
-
-#include <linux/can/led.h>
-
-static unsigned long led_delay = 50;
-module_param(led_delay, ulong, 0644);
-MODULE_PARM_DESC(led_delay,
-		"blink delay time for activity leds (msecs, default: 50).");
-
-/* Trigger a LED event in response to a CAN device event */
-void can_led_event(struct net_device *netdev, enum can_led_event event)
-{
-	struct can_priv *priv = netdev_priv(netdev);
-
-	switch (event) {
-	case CAN_LED_EVENT_OPEN:
-		led_trigger_event(priv->tx_led_trig, LED_FULL);
-		led_trigger_event(priv->rx_led_trig, LED_FULL);
-		led_trigger_event(priv->rxtx_led_trig, LED_FULL);
-		break;
-	case CAN_LED_EVENT_STOP:
-		led_trigger_event(priv->tx_led_trig, LED_OFF);
-		led_trigger_event(priv->rx_led_trig, LED_OFF);
-		led_trigger_event(priv->rxtx_led_trig, LED_OFF);
-		break;
-	case CAN_LED_EVENT_TX:
-		if (led_delay) {
-			led_trigger_blink_oneshot(priv->tx_led_trig,
-						  &led_delay, &led_delay, 1);
-			led_trigger_blink_oneshot(priv->rxtx_led_trig,
-						  &led_delay, &led_delay, 1);
-		}
-		break;
-	case CAN_LED_EVENT_RX:
-		if (led_delay) {
-			led_trigger_blink_oneshot(priv->rx_led_trig,
-						  &led_delay, &led_delay, 1);
-			led_trigger_blink_oneshot(priv->rxtx_led_trig,
-						  &led_delay, &led_delay, 1);
-		}
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(can_led_event);
-
-static void can_led_release(struct device *gendev, void *res)
-{
-	struct can_priv *priv = netdev_priv(to_net_dev(gendev));
-
-	led_trigger_unregister_simple(priv->tx_led_trig);
-	led_trigger_unregister_simple(priv->rx_led_trig);
-	led_trigger_unregister_simple(priv->rxtx_led_trig);
-}
-
-/* Register CAN LED triggers for a CAN device
- *
- * This is normally called from a driver's probe function
- */
-void devm_can_led_init(struct net_device *netdev)
-{
-	struct can_priv *priv = netdev_priv(netdev);
-	void *res;
-
-	res = devres_alloc(can_led_release, 0, GFP_KERNEL);
-	if (!res) {
-		netdev_err(netdev, "cannot register LED triggers\n");
-		return;
-	}
-
-	snprintf(priv->tx_led_trig_name, sizeof(priv->tx_led_trig_name),
-		 "%s-tx", netdev->name);
-	snprintf(priv->rx_led_trig_name, sizeof(priv->rx_led_trig_name),
-		 "%s-rx", netdev->name);
-	snprintf(priv->rxtx_led_trig_name, sizeof(priv->rxtx_led_trig_name),
-		 "%s-rxtx", netdev->name);
-
-	led_trigger_register_simple(priv->tx_led_trig_name,
-				    &priv->tx_led_trig);
-	led_trigger_register_simple(priv->rx_led_trig_name,
-				    &priv->rx_led_trig);
-	led_trigger_register_simple(priv->rxtx_led_trig_name,
-				    &priv->rxtx_led_trig);
-
-	devres_add(&netdev->dev, res);
-}
-EXPORT_SYMBOL_GPL(devm_can_led_init);
-
-/* NETDEV rename notifier to rename the associated led triggers too */
-static int can_led_notifier(struct notifier_block *nb, unsigned long msg,
-			    void *ptr)
-{
-	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
-	struct can_priv *priv = safe_candev_priv(netdev);
-	char name[CAN_LED_NAME_SZ];
-
-	if (!priv)
-		return NOTIFY_DONE;
-
-	if (!priv->tx_led_trig || !priv->rx_led_trig || !priv->rxtx_led_trig)
-		return NOTIFY_DONE;
-
-	if (msg == NETDEV_CHANGENAME) {
-		snprintf(name, sizeof(name), "%s-tx", netdev->name);
-		led_trigger_rename_static(name, priv->tx_led_trig);
-
-		snprintf(name, sizeof(name), "%s-rx", netdev->name);
-		led_trigger_rename_static(name, priv->rx_led_trig);
-
-		snprintf(name, sizeof(name), "%s-rxtx", netdev->name);
-		led_trigger_rename_static(name, priv->rxtx_led_trig);
-	}
-
-	return NOTIFY_DONE;
-}
-
-/* notifier block for netdevice event */
-static struct notifier_block can_netdev_notifier __read_mostly = {
-	.notifier_call = can_led_notifier,
-};
-
-int __init can_led_notifier_init(void)
-{
-	return register_netdevice_notifier(&can_netdev_notifier);
-}
-
-void __exit can_led_notifier_exit(void)
-{
-	unregister_netdevice_notifier(&can_netdev_notifier);
-}
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 7582908e1192..5d0c82d8b9a9 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -565,9 +565,6 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 		rxfs = m_can_read(cdev, M_CAN_RXF0S);
 	}
 
-	if (pkts)
-		can_led_event(dev, CAN_LED_EVENT_RX);
-
 	return pkts;
 }
 
@@ -1087,8 +1084,6 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			if (cdev->is_peripheral)
 				timestamp = m_can_get_timestamp(cdev);
 			m_can_tx_update_stats(cdev, 0, timestamp);
-
-			can_led_event(dev, CAN_LED_EVENT_TX);
 			netif_wake_queue(dev);
 		}
 	} else  {
@@ -1097,7 +1092,6 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
 
-			can_led_event(dev, CAN_LED_EVENT_TX);
 			if (netif_queue_stopped(dev) &&
 			    !m_can_tx_fifo_full(cdev))
 				netif_wake_queue(dev);
@@ -1562,7 +1556,6 @@ static int m_can_close(struct net_device *dev)
 		can_rx_offload_disable(&cdev->offload);
 
 	close_candev(dev);
-	can_led_event(dev, CAN_LED_EVENT_STOP);
 
 	phy_power_off(cdev->transceiver);
 
@@ -1806,8 +1799,6 @@ static int m_can_open(struct net_device *dev)
 	/* start the m_can controller */
 	m_can_start(dev);
 
-	can_led_event(dev, CAN_LED_EVENT_OPEN);
-
 	if (!cdev->is_peripheral)
 		napi_enable(&cdev->napi);
 
@@ -1995,8 +1986,6 @@ int m_can_class_register(struct m_can_classdev *cdev)
 		goto rx_offload_del;
 	}
 
-	devm_can_led_init(cdev->net);
-
 	of_can_transceiver(cdev->net);
 
 	dev_info(cdev->dev, "%s device registered (irq=%d, version=%d)\n",
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index d18b515e6ccc..4c0267f9f297 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -7,7 +7,6 @@
 #define _CAN_M_CAN_H_
 
 #include <linux/can/core.h>
-#include <linux/can/led.h>
 #include <linux/can/rx-offload.h>
 #include <linux/completion.h>
 #include <linux/device.h>
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 103f1a92eee2..d45762f1cf6b 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -12,7 +12,6 @@
 #include <linux/errno.h>
 #include <linux/netdevice.h>
 #include <linux/platform_device.h>
-#include <linux/can/led.h>
 #include <linux/can/dev.h>
 #include <linux/clk.h>
 #include <linux/of.h>
@@ -389,7 +388,6 @@ static void rcar_can_tx_done(struct net_device *ndev)
 	/* Clear interrupt */
 	isr = readb(&priv->regs->isr);
 	writeb(isr & ~RCAR_CAN_ISR_TXFF, &priv->regs->isr);
-	can_led_event(ndev, CAN_LED_EVENT_TX);
 }
 
 static irqreturn_t rcar_can_interrupt(int irq, void *dev_id)
@@ -531,7 +529,6 @@ static int rcar_can_open(struct net_device *ndev)
 			   ndev->irq, err);
 		goto out_close;
 	}
-	can_led_event(ndev, CAN_LED_EVENT_OPEN);
 	rcar_can_start(ndev);
 	netif_start_queue(ndev);
 	return 0;
@@ -581,7 +578,6 @@ static int rcar_can_close(struct net_device *ndev)
 	clk_disable_unprepare(priv->can_clk);
 	clk_disable_unprepare(priv->clk);
 	close_candev(ndev);
-	can_led_event(ndev, CAN_LED_EVENT_STOP);
 	return 0;
 }
 
@@ -666,8 +662,6 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
 	}
 	stats->rx_packets++;
 
-	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
-
 	netif_receive_skb(skb);
 }
 
@@ -812,8 +806,6 @@ static int rcar_can_probe(struct platform_device *pdev)
 		goto fail_candev;
 	}
 
-	devm_can_led_init(ndev);
-
 	dev_info(&pdev->dev, "device registered (IRQ%d)\n", ndev->irq);
 
 	return 0;
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index f75ebaa35519..40a11445d021 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -29,7 +29,6 @@
 #include <linux/errno.h>
 #include <linux/netdevice.h>
 #include <linux/platform_device.h>
-#include <linux/can/led.h>
 #include <linux/can/dev.h>
 #include <linux/clk.h>
 #include <linux/of.h>
@@ -1128,7 +1127,6 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
 	/* Clear interrupt */
 	rcar_canfd_write(priv->base, RCANFD_CFSTS(gpriv, ch, RCANFD_CFFIFO_IDX),
 			 sts & ~RCANFD_CFSTS_CFTXIF);
-	can_led_event(ndev, CAN_LED_EVENT_TX);
 }
 
 static void rcar_canfd_handle_global_err(struct rcar_canfd_global *gpriv, u32 ch)
@@ -1419,7 +1417,6 @@ static int rcar_canfd_open(struct net_device *ndev)
 	if (err)
 		goto out_close;
 	netif_start_queue(ndev);
-	can_led_event(ndev, CAN_LED_EVENT_OPEN);
 	return 0;
 out_close:
 	napi_disable(&priv->napi);
@@ -1469,7 +1466,6 @@ static int rcar_canfd_close(struct net_device *ndev)
 	napi_disable(&priv->napi);
 	clk_disable_unprepare(gpriv->can_clk);
 	close_candev(ndev);
-	can_led_event(ndev, CAN_LED_EVENT_STOP);
 	return 0;
 }
 
@@ -1619,8 +1615,6 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 	 */
 	rcar_canfd_write(priv->base, RCANFD_RFPCTR(gpriv, ridx), 0xff);
 
-	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
-
 	if (!(cf->can_id & CAN_RTR_FLAG))
 		stats->rx_bytes += cf->len;
 	stats->rx_packets++;
@@ -1792,7 +1786,6 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	netif_napi_add_weight(ndev, &priv->napi, rcar_canfd_rx_poll,
 			      RCANFD_NAPI_WEIGHT);
 	spin_lock_init(&priv->tx_lock);
-	devm_can_led_init(ndev);
 	gpriv->ch[priv->channel] = priv;
 	err = register_candev(ndev);
 	if (err) {
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 966316479485..2e7638f98cf1 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -60,7 +60,6 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 
 #include "sja1000.h"
 
@@ -383,8 +382,6 @@ static void sja1000_rx(struct net_device *dev)
 	sja1000_write_cmdreg(priv, CMD_RRB);
 
 	netif_rx(skb);
-
-	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
 static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
@@ -531,7 +528,6 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 				stats->tx_packets++;
 			}
 			netif_wake_queue(dev);
-			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
 		if (isrc & IRQ_RI) {
 			/* receive interrupt */
@@ -587,8 +583,6 @@ static int sja1000_open(struct net_device *dev)
 	/* init and start chi */
 	sja1000_start(dev);
 
-	can_led_event(dev, CAN_LED_EVENT_OPEN);
-
 	netif_start_queue(dev);
 
 	return 0;
@@ -606,8 +600,6 @@ static int sja1000_close(struct net_device *dev)
 
 	close_candev(dev);
 
-	can_led_event(dev, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -673,9 +665,6 @@ int register_sja1000dev(struct net_device *dev)
 
 	ret =  register_candev(dev);
 
-	if (!ret)
-		devm_can_led_init(dev);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_sja1000dev);
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index a5b2952b8d0f..ebc4ebb44c98 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -16,7 +16,6 @@
 
 #include <linux/can/core.h>
 #include <linux/can/dev.h>
-#include <linux/can/led.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -354,8 +353,6 @@ static void hi3110_hw_rx(struct spi_device *spi)
 	}
 	priv->net->stats.rx_packets++;
 
-	can_led_event(priv->net, CAN_LED_EVENT_RX);
-
 	netif_rx(skb);
 }
 
@@ -567,8 +564,6 @@ static int hi3110_stop(struct net_device *net)
 
 	mutex_unlock(&priv->hi3110_lock);
 
-	can_led_event(net, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -725,7 +720,6 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 		if (priv->tx_busy && statf & HI3110_STAT_TXMTY) {
 			net->stats.tx_packets++;
 			net->stats.tx_bytes += can_get_echo_skb(net, 0, NULL);
-			can_led_event(net, CAN_LED_EVENT_TX);
 			priv->tx_busy = false;
 			netif_wake_queue(net);
 		}
@@ -783,7 +777,6 @@ static int hi3110_open(struct net_device *net)
 	if (ret)
 		goto out_free_wq;
 
-	can_led_event(net, CAN_LED_EVENT_OPEN);
 	netif_wake_queue(net);
 	mutex_unlock(&priv->hi3110_lock);
 
@@ -931,7 +924,6 @@ static int hi3110_can_probe(struct spi_device *spi)
 	if (ret)
 		goto error_probe;
 
-	devm_can_led_init(net);
 	netdev_info(net, "%x successfully initialized.\n", priv->model);
 
 	return 0;
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index fc747bff5eeb..666a4505a55a 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -22,7 +22,6 @@
 #include <linux/bitfield.h>
 #include <linux/can/core.h>
 #include <linux/can/dev.h>
-#include <linux/can/led.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -738,8 +737,6 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 	}
 	priv->net->stats.rx_packets++;
 
-	can_led_event(priv->net, CAN_LED_EVENT_RX);
-
 	netif_rx(skb);
 }
 
@@ -973,8 +970,6 @@ static int mcp251x_stop(struct net_device *net)
 
 	mutex_unlock(&priv->mcp_lock);
 
-	can_led_event(net, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -1177,7 +1172,6 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			break;
 
 		if (intf & CANINTF_TX) {
-			can_led_event(net, CAN_LED_EVENT_TX);
 			if (priv->tx_busy) {
 				net->stats.tx_packets++;
 				net->stats.tx_bytes += can_get_echo_skb(net, 0,
@@ -1232,8 +1226,6 @@ static int mcp251x_open(struct net_device *net)
 	if (ret)
 		goto out_free_irq;
 
-	can_led_event(net, CAN_LED_EVENT_OPEN);
-
 	netif_wake_queue(net);
 	mutex_unlock(&priv->mcp_lock);
 
@@ -1403,8 +1395,6 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto error_probe;
 
-	devm_can_led_init(net);
-
 	ret = mcp251x_gpio_setup(priv);
 	if (ret)
 		goto error_probe;
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 25d6d81ab4f4..155b90f6c767 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -51,7 +51,6 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
@@ -516,8 +515,6 @@ static void sun4i_can_rx(struct net_device *dev)
 	sun4i_can_write_cmdreg(priv, SUN4I_CMD_RELEASE_RBUF);
 
 	netif_rx(skb);
-
-	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
 static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
@@ -664,7 +661,6 @@ static irqreturn_t sun4i_can_interrupt(int irq, void *dev_id)
 			stats->tx_bytes += can_get_echo_skb(dev, 0, NULL);
 			stats->tx_packets++;
 			netif_wake_queue(dev);
-			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
 		if ((isrc & SUN4I_INT_RBUF_VLD) &&
 		    !(isrc & SUN4I_INT_DATA_OR)) {
@@ -729,7 +725,6 @@ static int sun4ican_open(struct net_device *dev)
 		goto exit_can_start;
 	}
 
-	can_led_event(dev, CAN_LED_EVENT_OPEN);
 	netif_start_queue(dev);
 
 	return 0;
@@ -756,7 +751,6 @@ static int sun4ican_close(struct net_device *dev)
 
 	free_irq(dev->irq, dev);
 	close_candev(dev);
-	can_led_event(dev, CAN_LED_EVENT_STOP);
 
 	return 0;
 }
@@ -883,7 +877,6 @@ static int sun4ican_probe(struct platform_device *pdev)
 			DRV_NAME, err);
 		goto exit_free;
 	}
-	devm_can_led_init(dev);
 
 	dev_info(&pdev->dev, "device registered (base=%p, irq=%d)\n",
 		 priv->base, dev->irq);
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index bb3f2e3b004c..debe17bfd0f0 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -34,7 +34,6 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 #include <linux/can/rx-offload.h>
 
 #define DRV_NAME "ti_hecc"
@@ -759,7 +758,6 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 				can_rx_offload_get_echo_skb(&priv->offload,
 							    mbxno, stamp, NULL);
 			stats->tx_packets++;
-			can_led_event(ndev, CAN_LED_EVENT_TX);
 			--priv->tx_tail;
 		}
 
@@ -814,8 +812,6 @@ static int ti_hecc_open(struct net_device *ndev)
 		return err;
 	}
 
-	can_led_event(ndev, CAN_LED_EVENT_OPEN);
-
 	ti_hecc_start(ndev);
 	can_rx_offload_enable(&priv->offload);
 	netif_start_queue(ndev);
@@ -834,8 +830,6 @@ static int ti_hecc_close(struct net_device *ndev)
 	close_candev(ndev);
 	ti_hecc_transceiver_switch(priv, 0);
 
-	can_led_event(ndev, CAN_LED_EVENT_STOP);
-
 	return 0;
 }
 
@@ -954,8 +948,6 @@ static int ti_hecc_probe(struct platform_device *pdev)
 		goto probe_exit_offload;
 	}
 
-	devm_can_led_init(ndev);
-
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%u)\n",
 		 priv->base, (u32)ndev->irq);
 
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index c45a814e1de2..792ab9da317d 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -10,7 +10,6 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/signal.h>
@@ -232,8 +231,6 @@ static void mcba_usb_write_bulk_callback(struct urb *urb)
 		netdev->stats.tx_packets++;
 		netdev->stats.tx_bytes += can_get_echo_skb(netdev, ctx->ndx,
 							   NULL);
-
-		can_led_event(netdev, CAN_LED_EVENT_TX);
 	}
 
 	if (urb->status)
@@ -452,7 +449,6 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 	}
 	stats->rx_packets++;
 
-	can_led_event(priv->netdev, CAN_LED_EVENT_RX);
 	netif_rx(skb);
 }
 
@@ -700,7 +696,6 @@ static int mcba_usb_open(struct net_device *netdev)
 	priv->can_speed_check = true;
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	can_led_event(netdev, CAN_LED_EVENT_OPEN);
 	netif_start_queue(netdev);
 
 	return 0;
@@ -732,7 +727,6 @@ static int mcba_usb_close(struct net_device *netdev)
 	mcba_urb_unlink(priv);
 
 	close_candev(netdev);
-	can_led_event(netdev, CAN_LED_EVENT_STOP);
 
 	return 0;
 }
@@ -857,8 +851,6 @@ static int mcba_usb_probe(struct usb_interface *intf,
 	priv->rx_pipe = usb_rcvbulkpipe(priv->udev, in->bEndpointAddress);
 	priv->tx_pipe = usb_sndbulkpipe(priv->udev, out->bEndpointAddress);
 
-	devm_can_led_init(netdev);
-
 	/* Start USB dev only if we have successfully registered CAN device */
 	err = mcba_usb_start(priv);
 	if (err) {
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index b638604bf1ee..f3363575bf32 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -21,7 +21,6 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 
 /* driver constants */
 #define MAX_RX_URBS			20
@@ -480,8 +479,6 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 		stats->rx_packets++;
 
 		netif_rx(skb);
-
-		can_led_event(priv->netdev, CAN_LED_EVENT_RX);
 	} else {
 		netdev_warn(priv->netdev, "frame type %d unknown",
 			 msg->type);
@@ -582,8 +579,6 @@ static void usb_8dev_write_bulk_callback(struct urb *urb)
 	netdev->stats.tx_packets++;
 	netdev->stats.tx_bytes += can_get_echo_skb(netdev, context->echo_index, NULL);
 
-	can_led_event(netdev, CAN_LED_EVENT_TX);
-
 	/* Release context */
 	context->echo_index = MAX_TX_URBS;
 
@@ -807,8 +802,6 @@ static int usb_8dev_open(struct net_device *netdev)
 	if (err)
 		return err;
 
-	can_led_event(netdev, CAN_LED_EVENT_OPEN);
-
 	/* finally start device */
 	err = usb_8dev_start(priv);
 	if (err) {
@@ -865,8 +858,6 @@ static int usb_8dev_close(struct net_device *netdev)
 
 	close_candev(netdev);
 
-	can_led_event(netdev, CAN_LED_EVENT_STOP);
-
 	return err;
 }
 
@@ -974,8 +965,6 @@ static int usb_8dev_probe(struct usb_interface *intf,
 			 (version>>8) & 0xff, version & 0xff);
 	}
 
-	devm_can_led_init(netdev);
-
 	return 0;
 
 cleanup_unregister_candev:
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 7f730b471e9f..8a3b7b103ca4 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 #include <linux/pm_runtime.h>
 
 #define DRIVER_NAME	"xilinx_can"
@@ -1209,10 +1208,8 @@ static int xcan_rx_poll(struct napi_struct *napi, int quota)
 					XCAN_IXR_RXNEMP_MASK);
 	}
 
-	if (work_done) {
-		can_led_event(ndev, CAN_LED_EVENT_RX);
+	if (work_done)
 		xcan_update_error_state_after_rxtx(ndev);
-	}
 
 	if (work_done < quota) {
 		if (napi_complete_done(napi, work_done)) {
@@ -1298,7 +1295,6 @@ static void xcan_tx_interrupt(struct net_device *ndev, u32 isr)
 
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
-	can_led_event(ndev, CAN_LED_EVENT_TX);
 	xcan_update_error_state_after_rxtx(ndev);
 }
 
@@ -1420,7 +1416,6 @@ static int xcan_open(struct net_device *ndev)
 		goto err_candev;
 	}
 
-	can_led_event(ndev, CAN_LED_EVENT_OPEN);
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
 
@@ -1452,7 +1447,6 @@ static int xcan_close(struct net_device *ndev)
 	free_irq(ndev->irq, ndev);
 	close_candev(ndev);
 
-	can_led_event(ndev, CAN_LED_EVENT_STOP);
 	pm_runtime_put(priv->dev);
 
 	return 0;
@@ -1812,8 +1806,6 @@ static int xcan_probe(struct platform_device *pdev)
 		goto err_disableclks;
 	}
 
-	devm_can_led_init(ndev);
-
 	pm_runtime_put(&pdev->dev);
 
 	if (priv->devtype.flags & XCAN_FLAG_CANFD_2) {
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index c2ea47f30046..e22dc03c850e 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -17,7 +17,6 @@
 #include <linux/can.h>
 #include <linux/can/bittiming.h>
 #include <linux/can/error.h>
-#include <linux/can/led.h>
 #include <linux/can/length.h>
 #include <linux/can/netlink.h>
 #include <linux/can/skb.h>
@@ -85,15 +84,6 @@ struct can_priv {
 	int (*do_get_berr_counter)(const struct net_device *dev,
 				   struct can_berr_counter *bec);
 	int (*do_get_auto_tdcv)(const struct net_device *dev, u32 *tdcv);
-
-#ifdef CONFIG_CAN_LEDS
-	struct led_trigger *tx_led_trig;
-	char tx_led_trig_name[CAN_LED_NAME_SZ];
-	struct led_trigger *rx_led_trig;
-	char rx_led_trig_name[CAN_LED_NAME_SZ];
-	struct led_trigger *rxtx_led_trig;
-	char rxtx_led_trig_name[CAN_LED_NAME_SZ];
-#endif
 };
 
 static inline bool can_tdc_is_enabled(const struct can_priv *priv)
diff --git a/include/linux/can/led.h b/include/linux/can/led.h
deleted file mode 100644
index 7c3cfd798c56..000000000000
--- a/include/linux/can/led.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
- */
-
-#ifndef _CAN_LED_H
-#define _CAN_LED_H
-
-#include <linux/if.h>
-#include <linux/leds.h>
-#include <linux/netdevice.h>
-
-enum can_led_event {
-	CAN_LED_EVENT_OPEN,
-	CAN_LED_EVENT_STOP,
-	CAN_LED_EVENT_TX,
-	CAN_LED_EVENT_RX,
-};
-
-#ifdef CONFIG_CAN_LEDS
-
-/* keep space for interface name + "-tx"/"-rx"/"-rxtx"
- * suffix and null terminator
- */
-#define CAN_LED_NAME_SZ (IFNAMSIZ + 6)
-
-void can_led_event(struct net_device *netdev, enum can_led_event event);
-void devm_can_led_init(struct net_device *netdev);
-int __init can_led_notifier_init(void);
-void __exit can_led_notifier_exit(void);
-
-#else
-
-static inline void can_led_event(struct net_device *netdev,
-				 enum can_led_event event)
-{
-}
-static inline void devm_can_led_init(struct net_device *netdev)
-{
-}
-static inline int can_led_notifier_init(void)
-{
-	return 0;
-}
-static inline void can_led_notifier_exit(void)
-{
-}
-
-#endif
-
-#endif /* !_CAN_LED_H */
-- 
2.35.1


