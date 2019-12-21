Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAFE12896C
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 15:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfLUOPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 09:15:07 -0500
Received: from smtp7.web4u.cz ([81.91.87.87]:51136 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726715AbfLUOPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 09:15:05 -0500
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id ABBDB203720;
        Sat, 21 Dec 2019 15:08:24 +0100 (CET)
Received: from thor.pikron.com (unknown [89.102.8.6])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id 14D8B20371F;
        Sat, 21 Dec 2019 15:08:24 +0100 (CET)
From:   pisa@cmp.felk.cvut.cz
To:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com, Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v3 3/6] can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.
Date:   Sat, 21 Dec 2019 15:07:32 +0100
Message-Id: <d1ba59b56b4da2d38d97b74612adc7ae7896966d.1576922226.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
X-W4U-Auth: 5480aea52a3d20580578397f434b1b6a613f7423
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Jerabek <martin.jerabek01@gmail.com>

This driver adds support for the CTU CAN FD open-source IP core.
More documentation and core sources at project page
(https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
The core integration to Xilinx Zynq system as platform driver
is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
Implementation on Intel FGA based PCI Express board is available
from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).

More about CAN related projects used and developed at the Faculty
of the Electrical Engineering (http://www.fel.cvut.cz/en/)
of Czech Technical University (https://www.cvut.cz/en)
in at Prague http://canbus.pages.fel.cvut.cz/ .

Signed-off-by: Martin Jerabek <martin.jerabek01@gmail.com>
Signed-off-by: Ondrej Ille <ondrej.ille@gmail.com>
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 drivers/net/can/Kconfig                     |    1 +
 drivers/net/can/Makefile                    |    1 +
 drivers/net/can/ctucanfd/Kconfig            |   18 +
 drivers/net/can/ctucanfd/Makefile           |    7 +
 drivers/net/can/ctucanfd/ctu_can_fd.c       | 1116 +++++++++++++++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd.h       |   88 +++
 drivers/net/can/ctucanfd/ctu_can_fd_frame.h |  190 +++++
 drivers/net/can/ctucanfd/ctu_can_fd_hw.c    |  781 +++++++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd_hw.h    |  917 ++++++++++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd_regs.h  |  965 +++++++++++++++++++++++
 10 files changed, 4084 insertions(+)
 create mode 100644 drivers/net/can/ctucanfd/Kconfig
 create mode 100644 drivers/net/can/ctucanfd/Makefile
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_frame.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_hw.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_hw.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_regs.h

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 17c166cc8482..458afc4b81f2 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -168,6 +168,7 @@ config PCH_CAN
 
 source "drivers/net/can/c_can/Kconfig"
 source "drivers/net/can/cc770/Kconfig"
+source "drivers/net/can/ctucanfd/Kconfig"
 source "drivers/net/can/ifi_canfd/Kconfig"
 source "drivers/net/can/m_can/Kconfig"
 source "drivers/net/can/mscan/Kconfig"
diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 22164300122d..28b39cd122f0 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -21,6 +21,7 @@ obj-y				+= softing/
 obj-$(CONFIG_CAN_AT91)		+= at91_can.o
 obj-$(CONFIG_CAN_CC770)		+= cc770/
 obj-$(CONFIG_CAN_C_CAN)		+= c_can/
+obj-$(CONFIG_CAN_CTUCANFD)	+= ctucanfd/
 obj-$(CONFIG_CAN_FLEXCAN)	+= flexcan.o
 obj-$(CONFIG_CAN_GRCAN)		+= grcan.o
 obj-$(CONFIG_CAN_IFI_CANFD)	+= ifi_canfd/
diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
new file mode 100644
index 000000000000..a3b65088c9f7
--- /dev/null
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -0,0 +1,18 @@
+config CAN_CTUCANFD
+	tristate "CTU CAN-FD IP core"
+	---help---
+	  This driver adds support for the CTU CAN FD open-source IP core.
+	  More documentation and core sources at project page
+	  (https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
+	  The core integration to Xilinx Zynq system as platform driver
+	  is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
+	  Implementation on Intel FGA based PCI Express board is available
+	  from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
+	  More about CAN related projects used and developed at the Faculty
+	  of the Electrical Engineering (http://www.fel.cvut.cz/en/)
+	  of Czech Technical University (https://www.cvut.cz/en)
+	  in at Prague http://canbus.pages.fel.cvut.cz/ .
+
+if CAN_CTUCANFD
+
+endif
diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
new file mode 100644
index 000000000000..8d47008d0076
--- /dev/null
+++ b/drivers/net/can/ctucanfd/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the CTU CAN-FD IP module drivers
+#
+
+obj-$(CONFIG_CAN_CTUCANFD) := ctucanfd.o
+ctucanfd-y := ctu_can_fd.o ctu_can_fd_hw.o
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd.c b/drivers/net/can/ctucanfd/ctu_can_fd.c
new file mode 100644
index 000000000000..916ff7468687
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd.c
@@ -0,0 +1,1116 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ * Copyright (C) 2015-2018
+ *
+ * Authors:
+ *     Ondrej Ille <ondrej.ille@gmail.com>
+ *     Martin Jerabek <martin.jerabek01@gmail.com>
+ *     Jaroslav Beran <jara.beran@gmail.com>
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#include <linux/clk.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/can/error.h>
+#include <linux/can/led.h>
+#include <linux/pm_runtime.h>
+
+#include "ctu_can_fd.h"
+#include "ctu_can_fd_regs.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Jerabek");
+MODULE_DESCRIPTION("CTU CAN FD interface");
+
+#define DRV_NAME "ctucanfd"
+
+static const char * const ctucan_state_strings[] = {
+	"CAN_STATE_ERROR_ACTIVE",
+	"CAN_STATE_ERROR_WARNING",
+	"CAN_STATE_ERROR_PASSIVE",
+	"CAN_STATE_BUS_OFF",
+	"CAN_STATE_STOPPED",
+	"CAN_STATE_SLEEPING"
+};
+
+/* TX buffer rotation:
+ * - when a buffer transitions to empty state, rotate order and priorities
+ * - if more buffers seem to transition at the same time, rotate
+ *   by the number of buffers
+ * - it may be assumed that buffers transition to empty state in FIFO order
+ *   (because we manage priorities that way)
+ * - at frame filling, do not rotate anything, just increment buffer modulo
+ *   counter
+ */
+
+
+#define CTUCAN_FLAG_RX_FFW_BUFFERED	1
+
+static int ctucan_reset(struct net_device *ndev)
+{
+	int i;
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	netdev_dbg(ndev, "ctucan_reset");
+
+	ctucan_hw_reset(&priv->p);
+	for (i = 0; i < 100; ++i) {
+		if (ctucan_hw_check_access(&priv->p))
+			return 0;
+		usleep_range(100, 200);
+	}
+
+	netdev_warn(ndev, "device did not leave reset\n");
+	return -ETIMEDOUT;
+}
+
+/**
+ * ctucan_set_bittiming - CAN set bit timing routine
+ * @ndev:	Pointer to net_device structure
+ *
+ * This is the driver set bittiming routine.
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_set_bittiming(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct can_bittiming *bt = &priv->can.bittiming;
+
+	netdev_dbg(ndev, "ctucan_set_bittiming");
+
+	if (ctucan_hw_is_enabled(&priv->p)) {
+		netdev_alert(ndev,
+			     "BUG! Cannot set bittiming - CAN is enabled\n");
+		return -EPERM;
+	}
+
+	/* Note that bt may be modified here */
+	ctucan_hw_set_nom_bittiming(&priv->p, bt);
+
+	return 0;
+}
+
+/**
+ * ctucan_set_data_bittiming - CAN set data bit timing routine
+ * @ndev:	Pointer to net_device structure
+ *
+ * This is the driver set data bittiming routine.
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_set_data_bittiming(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct can_bittiming *dbt = &priv->can.data_bittiming;
+
+	netdev_dbg(ndev, "ctucan_set_data_bittiming");
+
+	if (ctucan_hw_is_enabled(&priv->p)) {
+		netdev_alert(ndev,
+			     "BUG! Cannot set bittiming - CAN is enabled\n");
+		return -EPERM;
+	}
+
+	/* Note that dbt may be modified here */
+	ctucan_hw_set_data_bittiming(&priv->p, dbt);
+
+	return 0;
+}
+
+/**
+ * ctucan_set_secondary_sample_point - CAN set secondary sample point routine
+ * @ndev:	Pointer to net_device structure
+ *
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_set_secondary_sample_point(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct can_bittiming *dbt = &priv->can.data_bittiming;
+	int ssp_offset = 0;
+	bool ssp_ena;
+
+	netdev_dbg(ndev, "ctucan_set_secondary_sample_point");
+
+	if (ctucan_hw_is_enabled(&priv->p)) {
+		netdev_alert(ndev,
+			     "BUG! Cannot set SSP - CAN is enabled\n");
+		return -EPERM;
+	}
+
+	// Use for bit-rates above 1 Mbits/s
+	if (dbt->bitrate > 1000000) {
+		ssp_ena = true;
+
+		// Calculate SSP in minimal time quanta
+		ssp_offset = (priv->can.clock.freq / 1000) *
+			      dbt->sample_point / dbt->bitrate;
+
+		if (ssp_offset > 127) {
+			netdev_warn(ndev, "SSP offset saturated to 127\n");
+			ssp_offset = 127;
+		}
+	} else
+		ssp_ena = false;
+
+	ctucan_hw_configure_ssp(&priv->p, ssp_ena, true, ssp_offset);
+
+	return 0;
+}
+
+/**
+ * ctucan_chip_start - This the drivers start routine
+ * @ndev:	Pointer to net_device structure
+ *
+ * This is the drivers start routine.
+ *
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_chip_start(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	union ctu_can_fd_int_stat int_ena, int_msk, int_enamask_mask;
+	int err;
+	struct can_ctrlmode mode;
+
+	netdev_dbg(ndev, "ctucan_chip_start");
+
+	err = ctucan_reset(ndev);
+	if (err < 0)
+		return err;
+
+	priv->txb_prio = 0x01234567;
+	priv->txb_head = 0;
+	priv->txb_tail = 0;
+	priv->p.write_reg(&priv->p, CTU_CAN_FD_TX_PRIORITY, priv->txb_prio);
+
+	err = ctucan_set_bittiming(ndev);
+	if (err < 0)
+		return err;
+
+	err = ctucan_set_data_bittiming(ndev);
+	if (err < 0)
+		return err;
+
+	err = ctucan_set_secondary_sample_point(ndev);
+	if (err < 0)
+		return err;
+
+	/* Enable interrupts */
+	int_ena.u32 = 0;
+	int_ena.s.rbnei = 1;
+	int_ena.s.txbhci = 1;
+
+	int_ena.s.ewli = 1;
+	int_ena.s.fcsi = 1;
+
+	int_enamask_mask.u32 = 0xFFFFFFFF;
+
+	mode.flags = priv->can.ctrlmode;
+	mode.mask = 0xFFFFFFFF;
+	ctucan_hw_set_mode_reg(&priv->p, &mode);
+
+	/* One shot mode supported indirectly via Retransmit limit */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		ctucan_hw_set_ret_limit(&priv->p, true, 0);
+
+	/* Bus error reporting -> Allow Error interrupt */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) {
+		int_ena.s.ali = 1;
+		int_ena.s.bei = 1;
+	}
+
+	int_msk.u32 = ~int_ena.u32; /* mask all disabled interrupts */
+
+	/* It's after reset, so there is no need to clear anything */
+	ctucan_hw_int_mask_set(&priv->p, int_msk);
+	ctucan_hw_int_ena_set(&priv->p, int_ena);
+
+	/* Controller enters ERROR_ACTIVE on initial FCSI */
+	priv->can.state = CAN_STATE_STOPPED;
+
+	/* Enable the controller */
+	ctucan_hw_enable(&priv->p, true);
+
+	return 0;
+}
+
+/**
+ * ctucan_do_set_mode - This sets the mode of the driver
+ * @ndev:	Pointer to net_device structure
+ * @mode:	Tells the mode of the driver
+ *
+ * This check the drivers state and calls the
+ * the corresponding modes to set.
+ *
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_do_set_mode(struct net_device *ndev, enum can_mode mode)
+{
+	int ret;
+
+	netdev_dbg(ndev, "ctucan_do_set_mode");
+
+	switch (mode) {
+	case CAN_MODE_START:
+		ret = ctucan_chip_start(ndev);
+		if (ret < 0) {
+			netdev_err(ndev, "ctucan_chip_start failed!\n");
+			return ret;
+		}
+		netif_wake_queue(ndev);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ctucan_start_xmit - Starts the transmission
+ * @skb:	sk_buff pointer that contains data to be Txed
+ * @ndev:	Pointer to net_device structure
+ *
+ * This function is invoked from upper layers to initiate transmission. This
+ * function uses the next available free txbuf and populates their fields to
+ * start the transmission.
+ *
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct net_device_stats *stats = &ndev->stats;
+	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
+	u32 txb_id;
+	bool ok;
+	unsigned long flags;
+
+	if (can_dropped_invalid_skb(ndev, skb))
+		return NETDEV_TX_OK;
+
+	/* Check if the TX buffer is full */
+	if (unlikely(!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))) {
+		netif_stop_queue(ndev);
+		netdev_err(ndev, "BUG!, no TXB free when queue awake!\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	txb_id = priv->txb_head & priv->txb_mask;
+	netdev_dbg(ndev, "%s: using TXB#%u", __func__, txb_id);
+	ok = ctucan_hw_insert_frame(&priv->p, cf, 0, txb_id,
+				     can_is_canfd_skb(skb));
+
+	if (!ok) {
+		netdev_err(ndev,
+		    "BUG! TXNF set but cannot insert frame into TXTB! HW Bug?");
+		return NETDEV_TX_BUSY;
+	}
+	can_put_echo_skb(skb, ndev, txb_id);
+
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->tx_bytes += cf->len;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	ctucan_hw_txt_set_rdy(&priv->p, txb_id);
+
+	priv->txb_head++;
+
+	/* Check if all TX buffers are full */
+	if (!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))
+		netif_stop_queue(ndev);
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	return NETDEV_TX_OK;
+}
+
+/**
+ * xcan_rx -  Is called from CAN isr to complete the received
+ *		frame  processing
+ * @ndev:	Pointer to net_device structure
+ *
+ * This function is invoked from the CAN isr(poll) to process the Rx frames. It
+ * does minimal processing and invokes "netif_receive_skb" to complete further
+ * processing.
+ * Return: 1 on success and 0 on failure.
+ */
+static int ctucan_rx(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct net_device_stats *stats = &ndev->stats;
+	struct canfd_frame *cf;
+	struct sk_buff *skb;
+	u64 ts;
+	union ctu_can_fd_frame_form_w ffw;
+
+	if (test_bit(CTUCAN_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
+		ffw = priv->rxfrm_first_word;
+		clear_bit(CTUCAN_FLAG_RX_FFW_BUFFERED, &priv->drv_flags);
+	} else {
+		ffw = ctu_can_fd_read_rx_ffw(&priv->p);
+	}
+
+	if (ffw.s.fdf == FD_CAN)
+		skb = alloc_canfd_skb(ndev, &cf);
+	else
+		skb = alloc_can_skb(ndev, (struct can_frame **)&cf);
+
+	if (unlikely(!skb)) {
+		priv->rxfrm_first_word = ffw;
+		set_bit(CTUCAN_FLAG_RX_FFW_BUFFERED, &priv->drv_flags);
+		return 0;
+	}
+
+	ctucan_hw_read_rx_frame_ffw(&priv->p, cf, &ts, ffw);
+
+	stats->rx_bytes += cf->len;
+	stats->rx_packets++;
+	netif_receive_skb(skb);
+
+	return 1;
+}
+
+
+static const char *ctucan_state_to_str(enum can_state state)
+{
+	if (state >= CAN_STATE_MAX)
+		return "UNKNOWN";
+	return ctucan_state_strings[state];
+}
+
+/**
+ * ctucan_err_interrupt - error frame Isr
+ * @ndev:	net_device pointer
+ * @isr:	interrupt status register value
+ *
+ * This is the CAN error interrupt and it will
+ * check the the type of error and forward the error
+ * frame to upper layers.
+ */
+static void ctucan_err_interrupt(struct net_device *ndev,
+				 union ctu_can_fd_int_stat isr)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct net_device_stats *stats = &ndev->stats;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	enum can_state state;
+	struct can_berr_counter berr;
+	union ctu_can_fd_err_capt_alc err_capt_alc;
+	int dologerr = net_ratelimit();
+
+	ctucan_hw_read_err_ctrs(&priv->p, &berr);
+	state = ctucan_hw_read_error_state(&priv->p);
+	err_capt_alc = ctu_can_fd_read_err_capt_alc(&priv->p);
+
+	if (dologerr)
+		netdev_info(ndev, "%s: ISR = 0x%08x, rxerr %d, txerr %d,"
+			" error type %u, pos %u, ALC id_field %u, bit %u\n",
+			__func__, isr.u32, berr.rxerr, berr.txerr,
+			err_capt_alc.s.err_type, err_capt_alc.s.err_pos,
+			err_capt_alc.s.alc_id_field, err_capt_alc.s.alc_bit);
+
+	skb = alloc_can_err_skb(ndev, &cf);
+
+	/* EWLI:  error warning limit condition met
+	 * FCSI: Fault confinement State changed
+	 * ALI:  arbitration lost (just informative)
+	 * BEI:  bus error interrupt
+	 */
+
+	if (isr.s.fcsi || isr.s.ewli) {
+
+		netdev_info(ndev, "  state changes from %s to %s",
+				ctucan_state_to_str(priv->can.state),
+				ctucan_state_to_str(state));
+
+		if (priv->can.state == state)
+			netdev_warn(ndev,
+				    "current and previous state is the same! (missed interrupt?)");
+
+		priv->can.state = state;
+		if (state == CAN_STATE_BUS_OFF) {
+			priv->can.can_stats.bus_off++;
+			can_bus_off(ndev);
+			if (skb)
+				cf->can_id |= CAN_ERR_BUSOFF;
+		} else if (state == CAN_STATE_ERROR_PASSIVE) {
+			priv->can.can_stats.error_passive++;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = (berr.rxerr > 127) ?
+						CAN_ERR_CRTL_RX_PASSIVE :
+						CAN_ERR_CRTL_TX_PASSIVE;
+				cf->data[6] = berr.txerr;
+				cf->data[7] = berr.rxerr;
+			}
+		} else if (state == CAN_STATE_ERROR_WARNING) {
+			priv->can.can_stats.error_warning++;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] |= (berr.txerr > berr.rxerr) ?
+					CAN_ERR_CRTL_TX_WARNING :
+					CAN_ERR_CRTL_RX_WARNING;
+				cf->data[6] = berr.txerr;
+				cf->data[7] = berr.rxerr;
+			}
+		} else if (state == CAN_STATE_ERROR_ACTIVE) {
+			cf->data[1] = CAN_ERR_CRTL_ACTIVE;
+			cf->data[6] = berr.txerr;
+			cf->data[7] = berr.rxerr;
+		} else {
+			netdev_warn(ndev, "    unhandled error state (%d:%s)!",
+				    state, ctucan_state_to_str(state));
+		}
+	}
+
+	/* Check for Arbitration Lost interrupt */
+	if (isr.s.ali) {
+		if (dologerr)
+			netdev_info(ndev, "  arbitration lost");
+		priv->can.can_stats.arbitration_lost++;
+		if (skb) {
+			cf->can_id |= CAN_ERR_LOSTARB;
+			cf->data[0] = CAN_ERR_LOSTARB_UNSPEC;
+		}
+	}
+
+	/* Check for Bus Error interrupt */
+	if (isr.s.bei) {
+		netdev_info(ndev, "  bus error");
+		priv->can.can_stats.bus_error++;
+		stats->tx_errors++; // TODO: really?
+		if (skb) {
+			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+			cf->data[2] = CAN_ERR_PROT_UNSPEC;
+			cf->data[3] = CAN_ERR_PROT_LOC_UNSPEC;
+		}
+	}
+
+	if (skb) {
+		stats->rx_packets++;
+		stats->rx_bytes += cf->can_dlc;
+		netif_rx(skb);
+	}
+}
+
+/**
+ * ctucan_rx_poll - Poll routine for rx packets (NAPI)
+ * @napi:	napi structure pointer
+ * @quota:	Max number of rx packets to be processed.
+ *
+ * This is the poll routine for rx part.
+ * It will process the packets maximux quota value.
+ *
+ * Return: number of packets received
+ */
+static int ctucan_rx_poll(struct napi_struct *napi, int quota)
+{
+	struct net_device *ndev = napi->dev;
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	int work_done = 0;
+	union ctu_can_fd_status status;
+	u32 framecnt;
+
+	framecnt = ctucan_hw_get_rx_frame_count(&priv->p);
+	netdev_dbg(ndev, "rx_poll: %d frames in RX FIFO", framecnt);
+	while (framecnt && work_done < quota) {
+		ctucan_rx(ndev);
+		work_done++;
+		framecnt = ctucan_hw_get_rx_frame_count(&priv->p);
+	}
+
+	/* Check for RX FIFO Overflow */
+	status = ctu_can_get_status(&priv->p);
+	if (status.s.dor) {
+		struct net_device_stats *stats = &ndev->stats;
+		struct can_frame *cf;
+		struct sk_buff *skb;
+
+		netdev_info(ndev, "  rx fifo overflow");
+		stats->rx_over_errors++;
+		stats->rx_errors++;
+		skb = alloc_can_err_skb(ndev, &cf);
+		if (skb) {
+			cf->can_id |= CAN_ERR_CRTL;
+			cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
+			stats->rx_packets++;
+			stats->rx_bytes += cf->can_dlc;
+			netif_rx(skb);
+		}
+
+		/* Clear Data Overrun */
+		ctucan_hw_clr_overrun_flag(&priv->p);
+	}
+
+	if (work_done)
+		can_led_event(ndev, CAN_LED_EVENT_RX);
+
+	if (!framecnt) {
+		if (napi_complete_done(napi, work_done)) {
+			union ctu_can_fd_int_stat iec;
+			/* Clear and enable RBNEI. It is level-triggered, so
+			 * there is no race condition.
+			 */
+			iec.u32 = 0;
+			iec.s.rbnei = 1;
+			ctucan_hw_int_clr(&priv->p, iec);
+			ctucan_hw_int_mask_clr(&priv->p, iec);
+		}
+	}
+
+	return work_done;
+}
+
+static void ctucan_rotate_txb_prio(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	u32 prio = priv->txb_prio;
+	u32 nbuffersm1 = priv->txb_mask; /* nbuffers - 1 */
+
+	prio = (prio << 4) | ((prio >> (nbuffersm1 * 4)) & 0xF);
+	netdev_dbg(ndev, "%s: from 0x%08x to 0x%08x",
+		   __func__, priv->txb_prio, prio);
+	priv->txb_prio = prio;
+	priv->p.write_reg(&priv->p, CTU_CAN_FD_TX_PRIORITY, prio);
+}
+
+/**
+ * xcan_tx_interrupt - Tx Done Isr
+ * @ndev:	net_device pointer
+ */
+static void ctucan_tx_interrupt(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct net_device_stats *stats = &ndev->stats;
+	bool first = true;
+	union ctu_can_fd_int_stat icr;
+	bool some_buffers_processed;
+	unsigned long flags;
+
+	netdev_dbg(ndev, "%s", __func__);
+
+	/*  read tx_status
+	 *  if txb[n].finished (bit 2)
+	 *	if ok -> echo
+	 *	if error / aborted -> ?? (find how to handle oneshot mode)
+	 *	txb_tail++
+	 */
+
+	icr.u32 = 0;
+	icr.s.txbhci = 1;
+	do {
+		spin_lock_irqsave(&priv->tx_lock, flags);
+
+		some_buffers_processed = false;
+		while ((int)(priv->txb_head - priv->txb_tail) > 0) {
+			u32 txb_idx = priv->txb_tail & priv->txb_mask;
+			u32 status = ctucan_hw_get_tx_status(&priv->p, txb_idx);
+
+			netdev_dbg(ndev, "TXI: TXB#%u: status 0x%x",
+				   txb_idx, status);
+
+			switch (status) {
+			case TXT_TOK:
+				netdev_dbg(ndev, "TXT_OK");
+				can_get_echo_skb(ndev, txb_idx);
+				stats->tx_packets++;
+				break;
+			case TXT_ERR:
+				/* This indicated that retransmit limit has been
+				 * reached. Obviously we should not echo the
+				 * frame, but also not indicate any kind
+				 * of error. If desired, it was already reported
+				 * (possible multiple times) on each arbitration
+				 * lost.
+				 */
+				netdev_warn(ndev, "TXB in Error state");
+				can_free_echo_skb(ndev, txb_idx);
+				stats->tx_dropped++;
+				break;
+			case TXT_ABT:
+				/* Same as for TXT_ERR, only with different
+				 * cause. We *could* re-queue the frame, but
+				 * multiqueue/abort is not supported yet anyway.
+				 */
+				netdev_warn(ndev, "TXB in Aborted state");
+				can_free_echo_skb(ndev, txb_idx);
+				stats->tx_dropped++;
+				break;
+			default:
+				/* Bug only if the first buffer is not finished,
+				 * otherwise it is pretty much expected
+				 */
+				if (first) {
+					netdev_err(ndev, "BUG: TXB#%u not in a finished state (0x%x)!",
+						   txb_idx, status);
+					spin_unlock_irqrestore(&priv->tx_lock,
+								flags);
+					/* do not clear nor wake */
+					return;
+				}
+				goto clear;
+			}
+			priv->txb_tail++;
+			first = false;
+			some_buffers_processed = true;
+			/* Adjust priorities *before* marking the buffer
+			 * as empty.
+			 */
+			ctucan_rotate_txb_prio(ndev);
+			ctucan_hw_txt_set_empty(&priv->p, txb_idx);
+		}
+clear:
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+		/* If no buffers were processed this time, wa cannot
+		 * clear - that would introduce a race condition.
+		 */
+		if (some_buffers_processed) {
+			/* Clear the interrupt again as not to receive it again
+			 * for a buffer we already handled (possibly causing
+			 * the bug log)
+			 */
+			ctucan_hw_int_clr(&priv->p, icr);
+		}
+	} while (some_buffers_processed);
+
+	can_led_event(ndev, CAN_LED_EVENT_TX);
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	/* Check if at least one TX buffer is free */
+	if (CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))
+		netif_wake_queue(ndev);
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+}
+
+/**
+ * xcan_interrupt - CAN Isr
+ * @irq:	irq number
+ * @dev_id:	device id poniter
+ *
+ * This is the CTU CAN FD ISR. It checks for the type of interrupt
+ * and invokes the corresponding ISR.
+ *
+ * Return:
+ * IRQ_NONE - If CAN device is in sleep mode, IRQ_HANDLED otherwise
+ */
+static irqreturn_t ctucan_interrupt(int irq, void *dev_id)
+{
+	struct net_device *ndev = (struct net_device *)dev_id;
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	union ctu_can_fd_int_stat isr, icr;
+	int irq_loops = 0;
+
+	netdev_dbg(ndev, "ctucan_interrupt");
+
+	do {
+		/* Get the interrupt status */
+		isr = ctu_can_fd_int_sts(&priv->p);
+
+		if (!isr.u32)
+			return irq_loops ? IRQ_HANDLED : IRQ_NONE;
+
+		/* Receive Buffer Not Empty Interrupt */
+		if (isr.s.rbnei) {
+			netdev_dbg(ndev, "RXBNEI");
+			icr.u32 = 0;
+			icr.s.rbnei = 1;
+			/* Mask RXBNEI the first then clear interrupt,
+			 * then schedule NAPI. Even if another IRQ fires,
+			 * isr.s.rbnei will always be 0 (masked).
+			 */
+			ctucan_hw_int_mask_set(&priv->p, icr);
+			ctucan_hw_int_clr(&priv->p, icr);
+			napi_schedule(&priv->napi);
+		}
+
+		/* TX Buffer HW Command Interrupt */
+		if (isr.s.txbhci) {
+			netdev_dbg(ndev, "TXBHCI");
+			/* Cleared inside */
+			ctucan_tx_interrupt(ndev);
+		}
+
+		/* Error interrupts */
+		if (isr.s.ewli || isr.s.fcsi || isr.s.ali) {
+			union ctu_can_fd_int_stat ierrmask = { .s = {
+				  .ewli = 1, .fcsi = 1, .ali = 1, .bei = 1 } };
+			icr.u32 = isr.u32 & ierrmask.u32;
+
+			netdev_dbg(ndev, "some ERR interrupt: clearing 0x%08x",
+				   icr.u32);
+			ctucan_hw_int_clr(&priv->p, icr);
+			ctucan_err_interrupt(ndev, isr);
+		}
+		/* Ignore RI, TI, LFI, RFI, BSI */
+	} while (irq_loops++ < 10000);
+
+	netdev_err(ndev, "%s: stuck interrupt (isr=0x%08x), stopping\n",
+		   __func__, isr.u32);
+
+	if (isr.s.txbhci) {
+		int i;
+
+		netdev_err(ndev, "txb_head=0x%08x txb_tail=0x%08x\n",
+			priv->txb_head, priv->txb_tail);
+		for (i = 0; i <= priv->txb_mask; i++) {
+			u32 status = ctucan_hw_get_tx_status(&priv->p, i);
+
+			netdev_err(ndev, "txb[%d] txb status=0x%08x\n",
+				i, status);
+		}
+	}
+
+	{
+		union ctu_can_fd_int_stat imask;
+
+		imask.u32 = 0xffffffff;
+		ctucan_hw_int_ena_clr(&priv->p, imask);
+		ctucan_hw_int_mask_set(&priv->p, imask);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * ctucan_chip_stop - Driver stop routine
+ * @ndev:	Pointer to net_device structure
+ *
+ * This is the drivers stop routine. It will disable the
+ * interrupts and disable the controller.
+ */
+static void ctucan_chip_stop(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	union ctu_can_fd_int_stat mask;
+
+	netdev_dbg(ndev, "ctucan_chip_stop");
+
+	mask.u32 = 0xffffffff;
+
+	/* Disable interrupts and disable can */
+	ctucan_hw_int_mask_set(&priv->p, mask);
+	ctucan_hw_enable(&priv->p, false);
+	priv->can.state = CAN_STATE_STOPPED;
+}
+
+/**
+ * ctucan_open - Driver open routine
+ * @ndev:	Pointer to net_device structure
+ *
+ * This is the driver open routine.
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_open(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	netdev_dbg(ndev, "ctucan_open");
+
+	ret = pm_runtime_get_sync(priv->dev);
+	if (ret < 0) {
+		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
+			   __func__, ret);
+		return ret;
+	}
+
+	ret = request_irq(ndev->irq, ctucan_interrupt, priv->irq_flags,
+			  ndev->name, ndev);
+	if (ret < 0) {
+		netdev_err(ndev, "irq allocation for CAN failed\n");
+		goto err;
+	}
+
+	/* Common open */
+	ret = open_candev(ndev);
+	if (ret) {
+		netdev_warn(ndev, "open_candev failed!\n");
+		goto err_irq;
+	}
+
+	ret = ctucan_chip_start(ndev);
+	if (ret < 0) {
+		netdev_err(ndev, "ctucan_chip_start failed!\n");
+		goto err_candev;
+	}
+
+	netdev_info(ndev, "ctu_can_fd device registered");
+	can_led_event(ndev, CAN_LED_EVENT_OPEN);
+	napi_enable(&priv->napi);
+	netif_start_queue(ndev);
+
+	return 0;
+
+err_candev:
+	close_candev(ndev);
+err_irq:
+	free_irq(ndev->irq, ndev);
+err:
+	pm_runtime_put(priv->dev);
+
+	return ret;
+}
+
+/**
+ * ctucan_close - Driver close routine
+ * @ndev:	Pointer to net_device structure
+ *
+ * Return: 0 always
+ */
+static int ctucan_close(struct net_device *ndev)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	netdev_dbg(ndev, "ctucan_close");
+
+	netif_stop_queue(ndev);
+	napi_disable(&priv->napi);
+	ctucan_chip_stop(ndev);
+	free_irq(ndev->irq, ndev);
+	close_candev(ndev);
+
+	can_led_event(ndev, CAN_LED_EVENT_STOP);
+	pm_runtime_put(priv->dev);
+
+	return 0;
+}
+
+/**
+ * ctucan_get_berr_counter - error counter routine
+ * @ndev:	Pointer to net_device structure
+ * @bec:	Pointer to can_berr_counter structure
+ *
+ * This is the driver error counter routine.
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_get_berr_counter(const struct net_device *ndev,
+				   struct can_berr_counter *bec)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	netdev_dbg(ndev, "ctucan_get_berr_counter");
+
+	ret = pm_runtime_get_sync(priv->dev);
+	if (ret < 0) {
+		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
+			   __func__, ret);
+		return ret;
+	}
+
+	ctucan_hw_read_err_ctrs(&priv->p, bec);
+
+	pm_runtime_put(priv->dev);
+
+	return 0;
+}
+
+static const struct net_device_ops ctucan_netdev_ops = {
+	.ndo_open	= ctucan_open,
+	.ndo_stop	= ctucan_close,
+	.ndo_start_xmit	= ctucan_start_xmit,
+	.ndo_change_mtu	= can_change_mtu,
+};
+
+int ctucan_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	netdev_dbg(ndev, "ctucan_suspend");
+
+	if (netif_running(ndev)) {
+		netif_stop_queue(ndev);
+		netif_device_detach(ndev);
+	}
+
+	priv->can.state = CAN_STATE_SLEEPING;
+
+	return 0;
+}
+EXPORT_SYMBOL(ctucan_suspend);
+
+int ctucan_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	netdev_dbg(ndev, "ctucan_resume");
+
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+
+	if (netif_running(ndev)) {
+		netif_device_attach(ndev);
+		netif_start_queue(ndev);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ctucan_resume);
+
+int ctucan_probe_common(struct device *dev, void __iomem *addr,
+		int irq, unsigned int ntxbufs, unsigned long can_clk_rate,
+		int pm_enable_call, void (*set_drvdata_fnc)(struct device *dev,
+		struct net_device *ndev))
+{
+	struct ctucan_priv *priv;
+	struct net_device *ndev;
+	int ret;
+
+	/* Create a CAN device instance */
+	ndev = alloc_candev(sizeof(struct ctucan_priv), ntxbufs);
+	if (!ndev)
+		return -ENOMEM;
+
+	priv = netdev_priv(ndev);
+	spin_lock_init(&priv->tx_lock);
+	INIT_LIST_HEAD(&priv->peers_on_pdev);
+	priv->txb_mask = ntxbufs - 1;
+	priv->dev = dev;
+	priv->can.bittiming_const = &ctu_can_fd_bit_timing_max;
+	priv->can.data_bittiming_const = &ctu_can_fd_bit_timing_data_max;
+	priv->can.do_set_mode = ctucan_do_set_mode;
+
+	/* Needed for timing adjustment to be performed as soon as possible */
+	priv->can.do_set_bittiming = ctucan_set_bittiming;
+	priv->can.do_set_data_bittiming = ctucan_set_data_bittiming;
+
+	priv->can.do_get_berr_counter = ctucan_get_berr_counter;
+	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK
+					| CAN_CTRLMODE_LISTENONLY
+					| CAN_CTRLMODE_FD
+					| CAN_CTRLMODE_PRESUME_ACK
+					| CAN_CTRLMODE_BERR_REPORTING
+					| CAN_CTRLMODE_FD_NON_ISO
+					| CAN_CTRLMODE_ONE_SHOT;
+	priv->p.mem_base = addr;
+
+	/* Get IRQ for the device */
+	ndev->irq = irq;
+	ndev->flags |= IFF_ECHO;	/* We support local echo */
+
+	if (set_drvdata_fnc != NULL)
+		set_drvdata_fnc(dev, ndev);
+	SET_NETDEV_DEV(ndev, dev);
+	ndev->netdev_ops = &ctucan_netdev_ops;
+
+	/* Getting the CAN can_clk info */
+	if (can_clk_rate == 0) {
+		priv->can_clk = devm_clk_get(dev, NULL);
+		if (IS_ERR(priv->can_clk)) {
+			dev_err(dev, "Device clock not found.\n");
+			ret = PTR_ERR(priv->can_clk);
+			goto err_free;
+		}
+		can_clk_rate = clk_get_rate(priv->can_clk);
+	}
+
+	priv->p.write_reg = ctucan_hw_write32;
+	priv->p.read_reg = ctucan_hw_read32;
+
+	if (pm_enable_call)
+		pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
+			   __func__, ret);
+		goto err_pmdisable;
+	}
+
+	if ((priv->p.read_reg(&priv->p, CTU_CAN_FD_DEVICE_ID) &
+			    0xFFFF) != CTU_CAN_FD_ID) {
+		priv->p.write_reg = ctucan_hw_write32_be;
+		priv->p.read_reg = ctucan_hw_read32_be;
+		if ((priv->p.read_reg(&priv->p, CTU_CAN_FD_DEVICE_ID) &
+			      0xFFFF) != CTU_CAN_FD_ID) {
+			netdev_err(ndev, "CTU_CAN_FD signature not found\n");
+			ret = -ENODEV;
+			goto err_disableclks;
+		}
+	}
+
+	ret = ctucan_reset(ndev);
+	if (ret < 0)
+		goto err_pmdisable;
+
+	priv->can.clock.freq = can_clk_rate;
+
+	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGHT);
+
+	ret = register_candev(ndev);
+	if (ret) {
+		dev_err(dev, "fail to register failed (err=%d)\n", ret);
+		goto err_disableclks;
+	}
+
+	devm_can_led_init(ndev);
+
+	pm_runtime_put(dev);
+
+	netdev_dbg(ndev, "mem_base=0x%p irq=%d clock=%d, txb mask:%d\n",
+		   priv->p.mem_base, ndev->irq, priv->can.clock.freq,
+		   priv->txb_mask);
+
+	return 0;
+
+err_disableclks:
+	pm_runtime_put(priv->dev);
+err_pmdisable:
+	if (pm_enable_call)
+		pm_runtime_disable(dev);
+err_free:
+	list_del_init(&priv->peers_on_pdev);
+	free_candev(ndev);
+	return ret;
+}
+EXPORT_SYMBOL(ctucan_probe_common);
+
+static __init int ctucan_init(void)
+{
+	printk(KERN_INFO "%s CAN netdevice driver\n", DRV_NAME);
+
+	return 0;
+}
+
+module_init(ctucan_init);
+
+static __exit void ctucan_exit(void)
+{
+	printk(KERN_INFO "%s: driver removed\n", DRV_NAME);
+}
+
+module_exit(ctucan_exit);
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd.h b/drivers/net/can/ctucanfd/ctu_can_fd.h
new file mode 100644
index 000000000000..6cb8ce0e9b35
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0+
+ *******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ * Copyright (C) 2015-2018
+ *
+ * Authors:
+ *     Ondrej Ille <ondrej.ille@gmail.com>
+ *     Martin Jerabek <martin.jerabek01@gmail.com>
+ *     Jaroslav Beran <jara.beran@gmail.com>
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#ifndef __CTU_CAN_FD__
+#define __CTU_CAN_FD__
+
+#include <linux/netdevice.h>
+#include <linux/can/dev.h>
+#include <linux/list.h>
+
+#include "ctu_can_fd_hw.h"
+
+struct ctucan_priv {
+	struct can_priv can; // must be first member!
+	struct ctucan_hw_priv p;
+
+	unsigned int txb_head;
+	unsigned int txb_tail;
+	u32 txb_prio;
+	unsigned int txb_mask;
+	spinlock_t tx_lock;
+
+	struct napi_struct napi;
+	struct device *dev;
+	struct clk *can_clk;
+
+	int irq_flags;
+	unsigned long drv_flags;
+
+	union ctu_can_fd_frame_form_w rxfrm_first_word;
+
+	struct list_head peers_on_pdev;
+};
+
+/**
+ * ctucan_probe_common - Device type independent registration call
+ *
+ * This function does all the memory allocation and registration for the CAN
+ * device.
+ *
+ * @dev:	Handle to the generic device structure
+ * @addr:	Base address of CTU CAN FD core address
+ * @irq:	Interrupt number
+ * @ntxbufs:	Number of implemented Tx buffers
+ * @can_clk_rate: Clock rate, if 0 then clock are taken from device node
+ * @pm_enable_call: Whether pm_runtime_enable should be called
+ * @set_drvdata_fnc: Function to set network driver data for physical device
+ *
+ * Return: 0 on success and failure value on error
+ */
+int ctucan_probe_common(struct device *dev, void __iomem *addr,
+			int irq, unsigned int ntxbufs,
+			unsigned long can_clk_rate,
+			int pm_enable_call,
+			void (*set_drvdata_fnc)(struct device *dev,
+			struct net_device *ndev));
+
+int ctucan_suspend(struct device *dev) __maybe_unused;
+int ctucan_resume(struct device *dev) __maybe_unused;
+
+#endif /*__CTU_CAN_FD__*/
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd_frame.h b/drivers/net/can/ctucanfd/ctu_can_fd_frame.h
new file mode 100644
index 000000000000..d1d6f8ef24e6
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd_frame.h
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ * Copyright (C) 2015-2018
+ *
+ * Authors:
+ *     Ondrej Ille <ondrej.ille@gmail.com>
+ *     Martin Jerabek <martin.jerabek01@gmail.com>
+ *     Jaroslav Beran <jara.beran@gmail.com>
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+/* This file is autogenerated, DO NOT EDIT! */
+
+#ifndef __CTU_CAN_FD_CAN_FD_FRAME_FORMAT__
+#define __CTU_CAN_FD_CAN_FD_FRAME_FORMAT__
+
+/* CAN_Frame_format memory map */
+enum ctu_can_fd_can_frame_format {
+	CTU_CAN_FD_FRAME_FORM_W        = 0x0,
+	CTU_CAN_FD_IDENTIFIER_W        = 0x4,
+	CTU_CAN_FD_TIMESTAMP_L_W       = 0x8,
+	CTU_CAN_FD_TIMESTAMP_U_W       = 0xc,
+	CTU_CAN_FD_DATA_1_4_W         = 0x10,
+	CTU_CAN_FD_DATA_5_8_W         = 0x14,
+	CTU_CAN_FD_DATA_61_64_W       = 0x4c,
+};
+
+
+/* Register descriptions: */
+union ctu_can_fd_frame_form_w {
+	uint32_t u32;
+	struct ctu_can_fd_frame_form_w_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FRAME_FORM_W */
+		uint32_t dlc                     : 4;
+		uint32_t reserved_4              : 1;
+		uint32_t rtr                     : 1;
+		uint32_t ide                     : 1;
+		uint32_t fdf                     : 1;
+		uint32_t reserved_8              : 1;
+		uint32_t brs                     : 1;
+		uint32_t esi_rsv                 : 1;
+		uint32_t rwcnt                   : 5;
+		uint32_t reserved_31_16         : 16;
+#else
+		uint32_t reserved_31_16         : 16;
+		uint32_t rwcnt                   : 5;
+		uint32_t esi_rsv                 : 1;
+		uint32_t brs                     : 1;
+		uint32_t reserved_8              : 1;
+		uint32_t fdf                     : 1;
+		uint32_t ide                     : 1;
+		uint32_t rtr                     : 1;
+		uint32_t reserved_4              : 1;
+		uint32_t dlc                     : 4;
+#endif
+	} s;
+};
+
+enum ctu_can_fd_frame_form_w_rtr {
+	NO_RTR_FRAME       = 0x0,
+	RTR_FRAME          = 0x1,
+};
+
+enum ctu_can_fd_frame_form_w_ide {
+	BASE           = 0x0,
+	EXTENDED       = 0x1,
+};
+
+enum ctu_can_fd_frame_form_w_fdf {
+	NORMAL_CAN       = 0x0,
+	FD_CAN           = 0x1,
+};
+
+enum ctu_can_fd_frame_form_w_brs {
+	BR_NO_SHIFT       = 0x0,
+	BR_SHIFT          = 0x1,
+};
+
+enum ctu_can_fd_frame_form_w_esi_rsv {
+	ESI_ERR_ACTIVE       = 0x0,
+	ESI_ERR_PASIVE       = 0x1,
+};
+
+union ctu_can_fd_identifier_w {
+	uint32_t u32;
+	struct ctu_can_fd_identifier_w_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* IDENTIFIER_W */
+		uint32_t identifier_ext         : 18;
+		uint32_t identifier_base        : 11;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t identifier_base        : 11;
+		uint32_t identifier_ext         : 18;
+#endif
+	} s;
+};
+
+union ctu_can_fd_timestamp_l_w {
+	uint32_t u32;
+	struct ctu_can_fd_timestamp_l_w_s {
+  /* TIMESTAMP_L_W */
+		uint32_t time_stamp_31_0        : 32;
+	} s;
+};
+
+union ctu_can_fd_timestamp_u_w {
+	uint32_t u32;
+	struct ctu_can_fd_timestamp_u_w_s {
+  /* TIMESTAMP_U_W */
+		uint32_t timestamp_l_w          : 32;
+	} s;
+};
+
+union ctu_can_fd_data_1_4_w {
+	uint32_t u32;
+	struct ctu_can_fd_data_1_4_w_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* DATA_1_4_W */
+		uint32_t data_1                  : 8;
+		uint32_t data_2                  : 8;
+		uint32_t data_3                  : 8;
+		uint32_t data_4                  : 8;
+#else
+		uint32_t data_4                  : 8;
+		uint32_t data_3                  : 8;
+		uint32_t data_2                  : 8;
+		uint32_t data_1                  : 8;
+#endif
+	} s;
+};
+
+union ctu_can_fd_data_5_8_w {
+	uint32_t u32;
+	struct ctu_can_fd_data_5_8_w_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* DATA_5_8_W */
+		uint32_t data_5                  : 8;
+		uint32_t data_6                  : 8;
+		uint32_t data_7                  : 8;
+		uint32_t data_8                  : 8;
+#else
+		uint32_t data_8                  : 8;
+		uint32_t data_7                  : 8;
+		uint32_t data_6                  : 8;
+		uint32_t data_5                  : 8;
+#endif
+	} s;
+};
+
+union ctu_can_fd_data_61_64_w {
+	uint32_t u32;
+	struct ctu_can_fd_data_61_64_w_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* DATA_61_64_W */
+		uint32_t data_61                 : 8;
+		uint32_t data_62                 : 8;
+		uint32_t data_63                 : 8;
+		uint32_t data_64                 : 8;
+#else
+		uint32_t data_64                 : 8;
+		uint32_t data_63                 : 8;
+		uint32_t data_62                 : 8;
+		uint32_t data_61                 : 8;
+#endif
+	} s;
+};
+
+#endif
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd_hw.c b/drivers/net/can/ctucanfd/ctu_can_fd_hw.c
new file mode 100644
index 000000000000..95c98bf5209d
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd_hw.c
@@ -0,0 +1,781 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ * Copyright (C) 2015-2018
+ *
+ * Authors:
+ *     Ondrej Ille <ondrej.ille@gmail.com>
+ *     Martin Jerabek <martin.jerabek01@gmail.com>
+ *     Jaroslav Beran <jara.beran@gmail.com>
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#ifndef __KERNEL__
+# include "ctu_can_fd_linux_defs.h"
+#else
+# include <linux/can/dev.h>
+#endif
+
+#include "ctu_can_fd_frame.h"
+#include "ctu_can_fd_hw.h"
+
+void ctucan_hw_write32(struct ctucan_hw_priv *priv,
+			enum ctu_can_fd_can_registers reg, u32 val)
+{
+	iowrite32(val, (char *)priv->mem_base + reg);
+}
+
+void ctucan_hw_write32_be(struct ctucan_hw_priv *priv,
+			   enum ctu_can_fd_can_registers reg, u32 val)
+{
+	iowrite32(val, (char *)priv->mem_base + reg);
+}
+
+u32 ctucan_hw_read32(struct ctucan_hw_priv *priv,
+		      enum ctu_can_fd_can_registers reg)
+{
+	return ioread32((char *)priv->mem_base + reg);
+}
+
+u32 ctucan_hw_read32_be(struct ctucan_hw_priv *priv,
+			 enum ctu_can_fd_can_registers reg)
+{
+	return ioread32be((char *)priv->mem_base + reg);
+}
+
+static void ctucan_hw_write_txt_buf(struct ctucan_hw_priv *priv,
+				     enum ctu_can_fd_can_registers buf_base,
+				     u32 offset, u32 val)
+{
+	priv->write_reg(priv, buf_base + offset, val);
+}
+
+static inline union ctu_can_fd_identifier_w ctucan_hw_id_to_hwid(canid_t id)
+{
+	union ctu_can_fd_identifier_w hwid;
+
+	hwid.u32 = 0;
+
+	if (id & CAN_EFF_FLAG) {
+		hwid.s.identifier_base = (id & CAN_EFF_MASK) >> 18;
+
+		/* getting lowest 18 bits, replace with sth nicer... */
+		hwid.s.identifier_ext = (id & 0x3FFFF);
+	} else {
+		hwid.s.identifier_base = id & CAN_SFF_MASK;
+	}
+	return hwid;
+}
+
+// TODO: rename or do not depend on previous value of id
+static inline void ctucan_hw_hwid_to_id(union ctu_can_fd_identifier_w hwid,
+					 canid_t *id,
+					 enum ctu_can_fd_frame_form_w_ide type)
+{
+	/* Preserve flags which we dont set */
+	*id &= ~(CAN_EFF_FLAG | CAN_EFF_MASK);
+
+	if (type == EXTENDED) {
+		*id |= CAN_EFF_FLAG;
+		*id |= hwid.s.identifier_base << 18;
+		*id |= hwid.s.identifier_ext;
+	} else {
+		*id = hwid.s.identifier_base;
+	}
+}
+
+static bool ctucan_hw_len_to_dlc(u8 len, u8 *dlc)
+{
+	*dlc = can_len2dlc(len);
+	return true;
+}
+
+bool ctucan_hw_check_access(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_device_id_version reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_DEVICE_ID);
+
+	if (reg.s.device_id != CTU_CAN_FD_ID)
+		return false;
+
+	return true;
+}
+
+u32 ctucan_hw_get_version(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_device_id_version reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_DEVICE_ID);
+	return reg.s.ver_major * 10 + reg.s.ver_minor;
+}
+
+void ctucan_hw_enable(struct ctucan_hw_priv *priv, bool enable)
+{
+	union ctu_can_fd_mode_settings reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
+	reg.s.ena = enable ? CTU_CAN_ENABLED : CTU_CAN_DISABLED;
+	priv->write_reg(priv, CTU_CAN_FD_MODE, reg.u32);
+}
+
+void ctucan_hw_reset(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_mode_settings mode;
+
+	mode.u32 = 0;
+	mode.s.rst = 1;
+	/* it does not matter that we overwrite the rest of the reg
+	 * - we're resetting
+	 */
+	priv->write_reg(priv, CTU_CAN_FD_MODE, mode.u32);
+}
+
+bool ctucan_hw_set_ret_limit(struct ctucan_hw_priv *priv, bool enable, u8 limit)
+{
+	union ctu_can_fd_mode_settings reg;
+
+	if (limit > CTU_CAN_FD_RETR_MAX)
+		return false;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
+	reg.s.rtrle = enable ? RTRLE_ENABLED : RTRLE_DISABLED;
+	reg.s.rtrth = limit & 0xF;
+	priv->write_reg(priv, CTU_CAN_FD_MODE, reg.u32);
+	return true;
+}
+
+void ctucan_hw_set_mode_reg(struct ctucan_hw_priv *priv,
+			     const struct can_ctrlmode *mode)
+{
+	u32 flags = mode->flags;
+	union ctu_can_fd_mode_settings reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
+
+	if (mode->mask & CAN_CTRLMODE_LOOPBACK)
+		reg.s.ilbp = flags & CAN_CTRLMODE_LOOPBACK ?
+					INT_LOOP_ENABLED : INT_LOOP_DISABLED;
+
+	if (mode->mask & CAN_CTRLMODE_LISTENONLY)
+		reg.s.lom = flags & CAN_CTRLMODE_LISTENONLY ?
+					LOM_ENABLED : LOM_DISABLED;
+
+	if (mode->mask & CAN_CTRLMODE_FD)
+		reg.s.fde = flags & CAN_CTRLMODE_FD ?
+				FDE_ENABLE : FDE_DISABLE;
+
+	if (mode->mask & CAN_CTRLMODE_PRESUME_ACK)
+		reg.s.stm = flags & CAN_CTRLMODE_PRESUME_ACK ?
+				STM_ENABLED : STM_DISABLED;
+
+	if (mode->mask & CAN_CTRLMODE_FD_NON_ISO)
+		reg.s.nisofd = flags & CAN_CTRLMODE_FD_NON_ISO ?
+				NON_ISO_FD : ISO_FD;
+
+	priv->write_reg(priv, CTU_CAN_FD_MODE, reg.u32);
+}
+
+void ctucan_hw_rel_rx_buf(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_command reg;
+
+	reg.u32 = 0;
+	reg.s.rrb = 1;
+	priv->write_reg(priv, CTU_CAN_FD_COMMAND, reg.u32);
+}
+
+void ctucan_hw_clr_overrun_flag(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_command reg;
+
+	reg.u32 = 0;
+	reg.s.cdo = 1;
+	priv->write_reg(priv, CTU_CAN_FD_COMMAND, reg.u32);
+}
+
+static void ctucan_hw_int_conf(struct ctucan_hw_priv *priv,
+				enum ctu_can_fd_can_registers sreg,
+				enum ctu_can_fd_can_registers creg,
+				union ctu_can_fd_int_stat mask,
+				union ctu_can_fd_int_stat val)
+{
+	priv->write_reg(priv, sreg, mask.u32 & val.u32);
+	priv->write_reg(priv, creg, mask.u32 & (~val.u32));
+}
+
+void ctucan_hw_int_ena(struct ctucan_hw_priv *priv,
+			union ctu_can_fd_int_stat mask,
+			union ctu_can_fd_int_stat val)
+{
+	ctucan_hw_int_conf(priv, CTU_CAN_FD_INT_ENA_SET,
+			    CTU_CAN_FD_INT_ENA_CLR, mask, val);
+}
+
+void ctucan_hw_int_mask(struct ctucan_hw_priv *priv,
+			 union ctu_can_fd_int_stat mask,
+			 union ctu_can_fd_int_stat val)
+{
+	ctucan_hw_int_conf(priv, CTU_CAN_FD_INT_MASK_SET,
+			    CTU_CAN_FD_INT_MASK_CLR, mask, val);
+}
+
+void ctucan_hw_set_mode(struct ctucan_hw_priv *priv,
+			 const struct can_ctrlmode *mode)
+{
+	ctucan_hw_set_mode_reg(priv, mode);
+
+	/* One shot mode supported indirectly via Retransmitt limit */
+	if (mode->mask & CAN_CTRLMODE_ONE_SHOT)
+		ctucan_hw_set_ret_limit(priv, !!(mode->flags &
+					 CAN_CTRLMODE_ONE_SHOT), 0);
+
+	/* Bus error reporting -> Allow Error interrupt */
+	if (mode->mask & CAN_CTRLMODE_BERR_REPORTING) {
+		union ctu_can_fd_int_stat ena, mask;
+
+		ena.u32 = 0;
+		mask.u32 = 0;
+		ena.s.bei = !!(mode->flags & CAN_CTRLMODE_ONE_SHOT);
+		mask.s.bei = 1;
+		ctucan_hw_int_ena(priv, ena, mask);
+	}
+}
+
+const struct can_bittiming_const ctu_can_fd_bit_timing_max = {
+	.name = "ctu_can_fd",
+	.tseg1_min = 2,
+	.tseg1_max = 190,
+	.tseg2_min = 1,
+	.tseg2_max = 63,
+	.sjw_max = 31,
+	.brp_min = 1,
+	.brp_max = 8,
+	.brp_inc = 1,
+};
+
+const struct can_bittiming_const ctu_can_fd_bit_timing_data_max = {
+	.name = "ctu_can_fd",
+	.tseg1_min = 2,
+	.tseg1_max = 94,
+	.tseg2_min = 1,
+	.tseg2_max = 31,
+	.sjw_max = 31,
+	.brp_min = 1,
+	.brp_max = 2,
+	.brp_inc = 1,
+};
+
+void ctucan_hw_set_nom_bittiming(struct ctucan_hw_priv *priv,
+				  struct can_bittiming *nbt)
+{
+	union ctu_can_fd_btr btr;
+
+	/* The timing calculation functions have only constraints on tseg1,
+	 * which is prop_seg + phase1_seg combined. tseg1 is then split in half
+	 * and stored into prog_seg and phase_seg1. In CTU CAN FD, PROP is
+	 * 7 bits wide but PH1 only 6, so we must re-distribute the values here.
+	 */
+	u32 prop_seg = nbt->prop_seg;
+	u32 phase_seg1 = nbt->phase_seg1;
+
+	if (phase_seg1 > 63) {
+		prop_seg += phase_seg1 - 63;
+		phase_seg1 = 63;
+		nbt->prop_seg = prop_seg;
+		nbt->phase_seg1 = phase_seg1;
+	}
+
+	btr.u32 = 0;
+	btr.s.prop = prop_seg;
+	btr.s.ph1 = phase_seg1;
+	btr.s.ph2 = nbt->phase_seg2;
+	btr.s.brp = nbt->brp;
+	btr.s.sjw = nbt->sjw;
+
+	priv->write_reg(priv, CTU_CAN_FD_BTR, btr.u32);
+}
+
+void ctucan_hw_set_data_bittiming(struct ctucan_hw_priv *priv,
+				   struct can_bittiming *dbt)
+{
+	union ctu_can_fd_btr_fd btr_fd;
+
+	/* The timing calculation functions have only constraints on tseg1,
+	 * which is prop_seg + phase1_seg combined. tseg1 is then split in half
+	 * and stored into prog_seg and phase_seg1. In CTU CAN FD, PROP_FD is
+	 * 6 bits wide but PH1_FD only 5, so we must re-distribute the values
+	 * here.
+	 */
+	u32 prop_seg = dbt->prop_seg;
+	u32 phase_seg1 = dbt->phase_seg1;
+
+	if (phase_seg1 > 31) {
+		prop_seg += phase_seg1 - 31;
+		phase_seg1 = 31;
+		dbt->prop_seg = prop_seg;
+		dbt->phase_seg1 = phase_seg1;
+	}
+
+	btr_fd.u32 = 0;
+	btr_fd.s.prop_fd = prop_seg;
+	btr_fd.s.ph1_fd = phase_seg1;
+	btr_fd.s.ph2_fd = dbt->phase_seg2;
+	btr_fd.s.brp_fd = dbt->brp;
+	btr_fd.s.sjw_fd = dbt->sjw;
+
+	priv->write_reg(priv, CTU_CAN_FD_BTR_FD, btr_fd.u32);
+}
+
+void ctucan_hw_set_err_limits(struct ctucan_hw_priv *priv, u8 ewl, u8 erp)
+{
+	union ctu_can_fd_ewl_erp_fault_state reg;
+
+	reg.u32 = 0;
+	reg.s.ew_limit = ewl;
+	reg.s.erp_limit = erp;
+	// era, bof, erp are read-only
+
+	priv->write_reg(priv, CTU_CAN_FD_EWL, reg.u32);
+}
+
+void ctucan_hw_read_err_ctrs(struct ctucan_hw_priv *priv,
+			      struct can_berr_counter *ctr)
+{
+	union ctu_can_fd_rec_tec reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_REC);
+	ctr->txerr = reg.s.tec_val;
+	ctr->rxerr = reg.s.rec_val;
+}
+
+enum can_state ctucan_hw_read_error_state(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_ewl_erp_fault_state reg;
+	union ctu_can_fd_rec_tec err;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_EWL);
+	err.u32 = priv->read_reg(priv, CTU_CAN_FD_REC);
+
+	if (reg.s.era) {
+		if (reg.s.ew_limit > err.s.rec_val &&
+		    reg.s.ew_limit > err.s.tec_val)
+			return CAN_STATE_ERROR_ACTIVE;
+		else
+			return CAN_STATE_ERROR_WARNING;
+	} else if (reg.s.erp) {
+		return CAN_STATE_ERROR_PASSIVE;
+	} else if (reg.s.bof) {
+		return CAN_STATE_BUS_OFF;
+	}
+	WARN(true, "Invalid error state");
+	return CAN_STATE_ERROR_PASSIVE;
+}
+
+void ctucan_hw_set_err_ctrs(struct ctucan_hw_priv *priv,
+			     const struct can_berr_counter *ctr)
+{
+	union ctu_can_fd_ctr_pres reg;
+
+	reg.u32 = 0;
+
+	reg.s.ctpv = ctr->txerr;
+	reg.s.ptx = 1;
+	priv->write_reg(priv, CTU_CAN_FD_CTR_PRES, reg.u32);
+
+	reg.s.ctpv = ctr->rxerr;
+	reg.s.ptx = 0;
+	reg.s.prx = 1;
+	priv->write_reg(priv, CTU_CAN_FD_CTR_PRES, reg.u32);
+}
+
+bool ctucan_hw_get_mask_filter_support(struct ctucan_hw_priv *priv, u8 fnum)
+{
+	union ctu_can_fd_filter_control_filter_status reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_FILTER_CONTROL);
+
+	switch (fnum) {
+	case CTU_CAN_FD_FILTER_A:
+		if (reg.s.sfa)
+			return true;
+	break;
+	case CTU_CAN_FD_FILTER_B:
+		if (reg.s.sfb)
+			return true;
+	break;
+	case CTU_CAN_FD_FILTER_C:
+		if (reg.s.sfc)
+			return true;
+	break;
+	}
+
+	return false;
+}
+
+bool ctucan_hw_get_range_filter_support(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_filter_control_filter_status reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_FILTER_CONTROL);
+
+	if (reg.s.sfr)
+		return true;
+
+	return false;
+}
+
+bool ctucan_hw_set_mask_filter(struct ctucan_hw_priv *priv, u8 fnum,
+				bool enable, const struct can_filter *filter)
+{
+	union ctu_can_fd_filter_control_filter_status creg;
+	enum ctu_can_fd_can_registers maddr, vaddr;
+	union ctu_can_fd_identifier_w hwid_mask;
+	union ctu_can_fd_identifier_w hwid_val;
+	uint8_t val = 0;
+
+	if (!ctucan_hw_get_mask_filter_support(priv, fnum))
+		return false;
+
+	if (enable)
+		val = 1;
+
+	creg.u32 = priv->read_reg(priv, CTU_CAN_FD_FILTER_CONTROL);
+
+	switch (fnum) {
+	case CTU_CAN_FD_FILTER_A:
+		maddr = CTU_CAN_FD_FILTER_A_MASK;
+		vaddr = CTU_CAN_FD_FILTER_A_VAL;
+		creg.s.fanb = val;
+		creg.s.fane = val;
+		creg.s.fafb = val;
+		creg.s.fafe = val;
+	break;
+	case CTU_CAN_FD_FILTER_B:
+		maddr = CTU_CAN_FD_FILTER_B_MASK;
+		vaddr = CTU_CAN_FD_FILTER_B_VAL;
+		creg.s.fbnb = val;
+		creg.s.fbne = val;
+		creg.s.fbfb = val;
+		creg.s.fbfe = val;
+	break;
+	case CTU_CAN_FD_FILTER_C:
+		maddr = CTU_CAN_FD_FILTER_C_MASK;
+		vaddr = CTU_CAN_FD_FILTER_C_VAL;
+		creg.s.fcnb = val;
+		creg.s.fcne = val;
+		creg.s.fcfb = val;
+		creg.s.fcfe = val;
+	break;
+	default:
+		return false;
+	}
+
+	hwid_mask = ctucan_hw_id_to_hwid(filter->can_id);
+	hwid_val = ctucan_hw_id_to_hwid(filter->can_mask);
+	priv->write_reg(priv, CTU_CAN_FD_FILTER_CONTROL, creg.u32);
+	priv->write_reg(priv, maddr, hwid_mask.u32);
+	priv->write_reg(priv, vaddr, hwid_val.u32);
+	return true;
+}
+
+void ctucan_hw_set_range_filter(struct ctucan_hw_priv *priv, canid_t low_th,
+				 canid_t high_th, bool enable)
+{
+	union ctu_can_fd_identifier_w hwid_low;
+	union ctu_can_fd_identifier_w hwid_high;
+	union ctu_can_fd_filter_control_filter_status creg;
+
+	hwid_low = ctucan_hw_id_to_hwid(low_th);
+	hwid_high = ctucan_hw_id_to_hwid(high_th);
+
+	creg.u32 = priv->read_reg(priv, CTU_CAN_FD_FILTER_CONTROL);
+
+	creg.s.frnb = enable;
+	creg.s.frne = enable;
+	creg.s.frfb = enable;
+	creg.s.frfe = enable;
+
+	priv->write_reg(priv, CTU_CAN_FD_FILTER_CONTROL, creg.u32);
+	priv->write_reg(priv, CTU_CAN_FD_FILTER_RAN_LOW, hwid_low.u32);
+	priv->write_reg(priv, CTU_CAN_FD_FILTER_RAN_HIGH, hwid_high.u32);
+}
+
+void ctucan_hw_set_rx_tsop(struct ctucan_hw_priv *priv,
+			    enum ctu_can_fd_rx_settings_rtsop val)
+{
+	union ctu_can_fd_rx_status_rx_settings reg;
+
+	reg.u32 = 0;
+	reg.s.rtsop = val;
+	priv->write_reg(priv, CTU_CAN_FD_RX_STATUS, reg.u32);
+}
+
+void ctucan_hw_read_rx_frame(struct ctucan_hw_priv *priv,
+			      struct canfd_frame *cf, u64 *ts)
+{
+	union ctu_can_fd_frame_form_w ffw;
+
+	ffw.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_DATA);
+	ctucan_hw_read_rx_frame_ffw(priv, cf, ts, ffw);
+}
+
+void ctucan_hw_read_rx_frame_ffw(struct ctucan_hw_priv *priv,
+				  struct canfd_frame *cf, u64 *ts,
+				  union ctu_can_fd_frame_form_w ffw)
+{
+	union ctu_can_fd_identifier_w idw;
+	unsigned int i;
+	enum ctu_can_fd_frame_form_w_ide ide;
+
+	idw.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_DATA);
+	cf->can_id = 0;
+	cf->flags = 0;
+
+	/* BRS, ESI, RTR Flags */
+	if (ffw.s.fdf == FD_CAN) {
+		if (ffw.s.brs == BR_SHIFT)
+			cf->flags |= CANFD_BRS;
+		if (ffw.s.esi_rsv == ESI_ERR_PASIVE)
+			cf->flags |= CANFD_ESI;
+	} else if (ffw.s.rtr == RTR_FRAME) {
+		cf->can_id |= CAN_RTR_FLAG;
+	}
+
+	/* DLC */
+	if (ffw.s.dlc <= 8) {
+		cf->len = ffw.s.dlc;
+	} else {
+		if (ffw.s.fdf == FD_CAN)
+			cf->len = (ffw.s.rwcnt - 3) << 2;
+		else
+			cf->len = 8;
+	}
+
+	ide = (enum ctu_can_fd_frame_form_w_ide)ffw.s.ide;
+	ctucan_hw_hwid_to_id(idw, &cf->can_id, ide);
+
+	/* Timestamp */
+	*ts = (u64)(priv->read_reg(priv, CTU_CAN_FD_RX_DATA));
+	*ts |= ((u64)priv->read_reg(priv, CTU_CAN_FD_RX_DATA) << 32);
+
+	/* Data */
+	for (i = 0; i < cf->len; i += 4) {
+		u32 data = priv->read_reg(priv, CTU_CAN_FD_RX_DATA);
+		*(u32 *)(cf->data + i) = data;
+	}
+}
+
+enum ctu_can_fd_tx_status_tx1s ctucan_hw_get_tx_status(struct ctucan_hw_priv
+							*priv, u8 buf)
+{
+	union ctu_can_fd_tx_status reg;
+	uint32_t status;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_TX_STATUS);
+
+	switch (buf) {
+	case CTU_CAN_FD_TXT_BUFFER_1:
+		status = reg.s.tx1s;
+		break;
+	case CTU_CAN_FD_TXT_BUFFER_2:
+		status = reg.s.tx2s;
+		break;
+	case CTU_CAN_FD_TXT_BUFFER_3:
+		status = reg.s.tx3s;
+		break;
+	case CTU_CAN_FD_TXT_BUFFER_4:
+		status = reg.s.tx4s;
+		break;
+	default:
+		status = ~0;
+	}
+	return (enum ctu_can_fd_tx_status_tx1s)status;
+}
+
+bool ctucan_hw_is_txt_buf_accessible(struct ctucan_hw_priv *priv, u8 buf)
+{
+	enum ctu_can_fd_tx_status_tx1s buf_status;
+
+	buf_status = ctucan_hw_get_tx_status(priv, buf);
+	if (buf_status == TXT_RDY || buf_status == TXT_TRAN ||
+	    buf_status == TXT_ABTP)
+		return false;
+
+	return true;
+}
+
+bool ctucan_hw_txt_buf_give_command(struct ctucan_hw_priv *priv, u8 cmd, u8 buf)
+{
+	union ctu_can_fd_tx_command reg;
+
+	reg.u32 = 0;
+
+	switch (buf) {
+	case CTU_CAN_FD_TXT_BUFFER_1:
+		reg.s.txb1 = 1;
+		break;
+	case CTU_CAN_FD_TXT_BUFFER_2:
+		reg.s.txb2 = 1;
+		break;
+	case CTU_CAN_FD_TXT_BUFFER_3:
+		reg.s.txb3 = 1;
+		break;
+	case CTU_CAN_FD_TXT_BUFFER_4:
+		reg.s.txb4 = 1;
+		break;
+	default:
+		return false;
+	}
+
+	// TODO: use named constants for the command
+	if (cmd & 0x1)
+		reg.s.txce = 1;
+	else if (cmd & 0x2)
+		reg.s.txcr = 1;
+	else if (cmd & 0x4)
+		reg.s.txca = 1;
+	else
+		return false;
+
+	priv->write_reg(priv, CTU_CAN_FD_TX_COMMAND, reg.u32);
+	return true;
+}
+
+void ctucan_hw_set_txt_priority(struct ctucan_hw_priv *priv, const u8 *prio)
+{
+	union ctu_can_fd_tx_priority reg;
+
+	reg.u32 = 0;
+	reg.s.txt1p = prio[0];
+	reg.s.txt2p = prio[1];
+	reg.s.txt3p = prio[2];
+	reg.s.txt4p = prio[3];
+
+	priv->write_reg(priv, CTU_CAN_FD_TX_PRIORITY, reg.u32);
+}
+
+static const enum ctu_can_fd_can_registers
+	tx_buf_bases[CTU_CAN_FD_TXT_BUFFER_COUNT] = {
+		CTU_CAN_FD_TXTB1_DATA_1, CTU_CAN_FD_TXTB2_DATA_1,
+		CTU_CAN_FD_TXTB3_DATA_1, CTU_CAN_FD_TXTB4_DATA_1
+};
+
+bool ctucan_hw_insert_frame(struct ctucan_hw_priv *priv,
+			     const struct canfd_frame *cf, u64 ts, u8 buf,
+			     bool isfdf)
+{
+	enum ctu_can_fd_can_registers buf_base;
+	union ctu_can_fd_frame_form_w ffw;
+	union ctu_can_fd_identifier_w idw;
+	u8 dlc;
+	unsigned int i;
+
+	ffw.u32 = 0;
+	idw.u32 = 0;
+
+	if (buf >= CTU_CAN_FD_TXT_BUFFER_COUNT)
+		return false;
+	buf_base = tx_buf_bases[buf];
+
+	if (!ctucan_hw_is_txt_buf_accessible(priv, buf))
+		return false;
+
+	if (cf->can_id & CAN_RTR_FLAG)
+		ffw.s.rtr = RTR_FRAME;
+
+	if (cf->can_id & CAN_EFF_FLAG)
+		ffw.s.ide = EXTENDED;
+	else
+		ffw.s.ide = BASE;
+
+	idw = ctucan_hw_id_to_hwid(cf->can_id);
+
+	if (!ctucan_hw_len_to_dlc(cf->len, &dlc))
+		return false;
+	ffw.s.dlc = dlc;
+
+	if (isfdf) {
+		ffw.s.fdf = FD_CAN;
+		if (cf->flags & CANFD_BRS)
+			ffw.s.brs = BR_SHIFT;
+	}
+
+	ctucan_hw_write_txt_buf(priv, buf_base,
+				 CTU_CAN_FD_FRAME_FORM_W, ffw.u32);
+
+	ctucan_hw_write_txt_buf(priv, buf_base,
+				 CTU_CAN_FD_IDENTIFIER_W, idw.u32);
+
+	ctucan_hw_write_txt_buf(priv, buf_base,
+				 CTU_CAN_FD_TIMESTAMP_L_W, (u32)(ts));
+
+	ctucan_hw_write_txt_buf(priv, buf_base,
+				 CTU_CAN_FD_TIMESTAMP_U_W, (u32)(ts >> 32));
+
+	if (!(cf->can_id & CAN_RTR_FLAG)) {
+		for (i = 0; i < cf->len; i += 4) {
+			u32 data = *(u32 *)(cf->data + i);
+
+			ctucan_hw_write_txt_buf(priv, buf_base,
+					CTU_CAN_FD_DATA_1_4_W + i, data);
+		}
+	}
+
+	return true;
+}
+
+u64 ctucan_hw_read_timestamp(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_timestamp_low ts_low;
+	union ctu_can_fd_timestamp_high ts_high;
+	union ctu_can_fd_timestamp_high ts_high_2;
+
+	ts_high.u32 = priv->read_reg(priv, CTU_CAN_FD_TIMESTAMP_HIGH);
+	ts_low.u32 = priv->read_reg(priv, CTU_CAN_FD_TIMESTAMP_LOW);
+	ts_high_2.u32 = priv->read_reg(priv, CTU_CAN_FD_TIMESTAMP_HIGH);
+
+	if (ts_high.u32 != ts_high_2.u32)
+		ts_low.u32 = priv->read_reg(priv, CTU_CAN_FD_TIMESTAMP_LOW);
+
+	return (((u64)ts_high_2.u32) << 32) | ((u64)ts_low.u32);
+}
+
+void ctucan_hw_configure_ssp(struct ctucan_hw_priv *priv, bool enable_ssp,
+			     bool use_trv_delay, int ssp_offset)
+{
+	union ctu_can_fd_trv_delay_ssp_cfg ssp_cfg;
+
+	ssp_cfg.u32 = 0;
+	if (enable_ssp) {
+		if (use_trv_delay)
+			ssp_cfg.s.ssp_src = SSP_SRC_MEAS_N_OFFSET;
+		else
+			ssp_cfg.s.ssp_src = SSP_SRC_OFFSET;
+	} else {
+		ssp_cfg.s.ssp_src = SSP_SRC_NO_SSP;
+	}
+
+	ssp_cfg.s.ssp_offset = (uint32_t)ssp_offset;
+	priv->write_reg(priv, CTU_CAN_FD_TRV_DELAY, ssp_cfg.u32);
+}
+
+// TODO: AL_CAPTURE and ERROR_CAPTURE
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd_hw.h b/drivers/net/can/ctucanfd/ctu_can_fd_hw.h
new file mode 100644
index 000000000000..18dacdf1ecf2
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd_hw.h
@@ -0,0 +1,917 @@
+/* SPDX-License-Identifier: GPL-2.0+
+ *******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ * Copyright (C) 2015-2018
+ *
+ * Authors:
+ *     Ondrej Ille <ondrej.ille@gmail.com>
+ *     Martin Jerabek <martin.jerabek01@gmail.com>
+ *     Jaroslav Beran <jara.beran@gmail.com>
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#ifndef __CTU_CAN_FD_HW__
+#define __CTU_CAN_FD_HW__
+
+#include <asm/byteorder.h>
+
+#if defined(__LITTLE_ENDIAN_BITFIELD) == defined(__BIG_ENDIAN_BITFIELD)
+# error __BIG_ENDIAN_BITFIELD or __LITTLE_ENDIAN_BITFIELD must be defined.
+#endif
+
+#include "ctu_can_fd_regs.h"
+#include "ctu_can_fd_frame.h"
+
+#define CTU_CAN_FD_RETR_MAX 15
+
+#define CTU_CAN_FD_FILTER_A 0
+#define CTU_CAN_FD_FILTER_B 1
+#define CTU_CAN_FD_FILTER_C 2
+
+#define CTU_CAN_FD_TXT_BUFFER_COUNT 4
+
+#define CTU_CAN_FD_TXT_BUFFER_1 0
+#define CTU_CAN_FD_TXT_BUFFER_2 1
+#define CTU_CAN_FD_TXT_BUFFER_3 2
+#define CTU_CAN_FD_TXT_BUFFER_4 3
+
+/*
+ * Status macros -> pass "ctu_can_get_status" result
+ */
+
+// True if Core is transceiver of current frame
+#define CTU_CAN_FD_IS_TRANSMITTER(stat) (!!(stat).ts)
+
+// True if Core is receiver of current frame
+#define CTU_CAN_FD_IS_RECEIVER(stat) (!!(stat).s.rxs)
+
+// True if Core is idle (integrating or interfame space)
+#define CTU_CAN_FD_IS_IDLE(stat) (!!(stat).s.idle)
+
+// True if Core is transmitting error frame
+#define CTU_CAN_FD_ERR_FRAME(stat) (!!(stat).s.eft)
+
+// True if Error warning limit was reached
+#define CTU_CAN_FD_EWL(stat) (!!(stat).s.ewl)
+
+// True if at least one TXT Buffer is empty
+#define CTU_CAN_FD_TXTNF(stat) (!!(stat).s.txnf)
+
+// True if data overrun flag of RX Buffer occurred
+#define CTU_CAN_FD_DATA_OVERRUN(stat) (!!(stat).s.dor)
+
+// True if RX Buffer is not empty
+#define CTU_CAN_FD_RX_BUF_NEMPTY(stat) (!!(stat).s.rxne)
+
+/*
+ * Interrupt macros -> pass "ctu_can_fd_int_sts" result
+ */
+
+// Frame reveived interrupt
+#define CTU_CAN_FD_RX_INT(int_stat) (!!(int_stat).s.rxi)
+
+// Frame transceived interrupt
+#define CTU_CAN_FD_TX_INT(int_stat) (!!(int_stat).s.txi)
+
+// Error warning limit reached interrupt
+#define CTU_CAN_FD_EWL_INT(int_stat) (!!(int_stat).s.ewli)
+
+// RX Buffer data overrun interrupt
+#define CTU_CAN_FD_OVERRUN_INT(int_stat) (!!(int_stat).s.doi)
+
+// Fault confinement changed interrupt
+#define CTU_CAN_FD_FAULT_STATE_CHANGED_INT(int_stat) (!!(int_stat).s.fcsi)
+
+// Error frame transmission started interrupt
+#define CTU_CAN_FD_BUS_ERROR_INT(int_stat) (!!(int_stat).s.bei)
+
+// Event logger finished interrupt
+#define CTU_CAN_FD_LOGGER_FIN_INT(int_stat) (!!(int_stat).s.lfi)
+
+// RX Buffer full interrupt
+#define CTU_CAN_FD_RX_FULL_INT(int_stat) (!!(int_stat).s.rxfi)
+
+// Bit-rate shifted interrupt
+#define CTU_CAN_FD_BIT_RATE_SHIFT_INT(int_stat) (!!(int_stat).s.bsi)
+
+// Receive buffer not empty interrupt
+#define CTU_CAN_FD_RX_BUF_NEPMTY_INT(int_stat) (!!(int_stat).s.rbnei)
+
+// TX Buffer received HW command interrupt
+#define CTU_CAN_FD_TXT_BUF_HWCMD_INT(int_stat) (!!(int_stat).s.txbhci)
+
+static inline bool CTU_CAN_FD_INT_ERROR(union ctu_can_fd_int_stat i)
+{
+	return i.s.ewli || i.s.doi || i.s.fcsi || i.s.ali;
+}
+
+struct ctucan_hw_priv;
+#ifndef ctucan_hw_priv
+struct ctucan_hw_priv {
+	void __iomem *mem_base;
+	u32 (*read_reg)(struct ctucan_hw_priv *priv,
+			enum ctu_can_fd_can_registers reg);
+	void (*write_reg)(struct ctucan_hw_priv *priv,
+			enum ctu_can_fd_can_registers reg, u32 val);
+};
+#endif
+
+void ctucan_hw_write32(struct ctucan_hw_priv *priv,
+			enum ctu_can_fd_can_registers reg, u32 val);
+void ctucan_hw_write32_be(struct ctucan_hw_priv *priv,
+			enum ctu_can_fd_can_registers reg, u32 val);
+u32 ctucan_hw_read32(struct ctucan_hw_priv *priv,
+			enum ctu_can_fd_can_registers reg);
+u32 ctucan_hw_read32_be(struct ctucan_hw_priv *priv,
+			enum ctu_can_fd_can_registers reg);
+
+/**
+ * ctucan_hw_check_access - Checks whether the core is mapped correctly
+ *                           at it's base address.
+ *
+ * @priv: Private info
+ *
+ * Return: true if the core is accessible correctly, false otherwise.
+ */
+bool ctucan_hw_check_access(struct ctucan_hw_priv *priv);
+
+/**
+ * ctucan_hw_get_version - Returns version of CTU CAN FD IP Core.
+ *
+ * @priv: Private info
+ *
+ * Return: IP Core version in format major*10 + minor
+ */
+u32 ctucan_hw_get_version(struct ctucan_hw_priv *priv);
+
+/**
+ * ctucan_hw_enable - Enables/disables the operation of CTU CAN FD Core.
+ *
+ * If disabled, the Core will never start transmitting on the CAN bus,
+ * nor receiving.
+ *
+ * @priv: Private info
+ * @enable: Enable/disable the core.
+ */
+void ctucan_hw_enable(struct ctucan_hw_priv *priv, bool enable);
+
+/**
+ * ctucan_hw_reset - Resets the CTU CAN FD Core.
+ *
+ * NOTE: After resetting, you must wait until ctucan_hw_check_access()
+ * succeeds!
+ *
+ * @priv: Private info
+ */
+void ctucan_hw_reset(struct ctucan_hw_priv *priv);
+
+/**
+ * ctucan_hw_set_ret_limit - Set retransmit limit for sent messages
+ *
+ * Configures CTU CAN FD Core to limit the amount of retransmit attempts after
+ * occurence of error (Error frame, Arbitration lost). If retransmit limit is
+ * disabled, the Core will attempt to retransmit inifinitely. If retransmit
+ * limit is reached, the Core will finish and according TXT buffer will end up
+ * in TX Error state.
+ *
+ * @priv: Private info
+ * @enable: Enable/disable the retransmit limitation
+ * @limit: Number to which limit the retransmission (1-CTU_CAN_FD_RETR_MAX)
+ * Return: True if set correctly. False if "limit" is too high.
+ */
+bool ctucan_hw_set_ret_limit(struct ctucan_hw_priv *priv, bool enable,
+			      u8 limit);
+
+/**
+ * ctucan_hw_set_mode_reg - Configures CTU CAN FD Core for special operating
+ *                           modes by access to MODEregister.
+ *
+ * Following flags from "mode" are not configured by this function:
+ *  CAN_CTRLMODE_ONE_SHOT, CAN_CTRLMODE_BERR_REPORTING.
+ *
+ * Following flags are configured:
+ *
+ *	CAN_CTRLMODE_LOOPBACK	- Bit loopback mode. Every dominant bit is
+ *				  re-routed internally and not send on the bus.
+ *
+ *	CAN_CTRLMODE_LISTENONLY	- No frame is transmitted, no dominant bit is
+ *				  sent on the bus.
+ *
+ *	CAN_CTRLMODE_3_SAMPLES  - Tripple sampling mode
+ *
+ *	CAN_CTRLMODE_FD		- Flexible data-rate support. When not set, Core
+ *				  does not accept CAN FD Frames and interprets,
+ *				  them as form error. Capability to transmit
+ *				  CAN FD Frames is not affected by this setting.
+ *
+ *	CAN_CTRLMODE_PRESUME_ACK - When set, Core does not require dominant bit
+ *				   in ACK field to consider the transmission as
+ *				   valid.
+ *
+ *	CAN_CTRLMODE_FD_NON_ISO  - When set, the Core transmits the frames
+ *				   according to NON-ISO FD standard.
+ *
+ * @priv: Private info
+ * @mode: CAN mode to be set to on the Core.
+ */
+void ctucan_hw_set_mode_reg(struct ctucan_hw_priv *priv,
+			     const struct can_ctrlmode *mode);
+
+/**
+ * ctucan_hw_rel_rx_buf - Gives command to CTU CAN FD Core to erase
+ *                         and reset the RX FIFO.
+ *
+ * This action is finished immediately and does not need waiting.
+ *
+ * @priv: Private info
+ */
+void ctucan_hw_rel_rx_buf(struct ctucan_hw_priv *priv);
+
+/**
+ * ctucan_hw_clr_overrun_flag - Gives command to CTU CAN FD Core to clear
+ *                               the Data overrun flag on the RX FIFO Buffer.
+ *
+ * @priv: Private info
+ */
+void ctucan_hw_clr_overrun_flag(struct ctucan_hw_priv *priv);
+
+/**
+ * ctu_can_get_status - Returns mode/status vector of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: Mode/status structure with multiple mode flags.
+ */
+static inline union ctu_can_fd_status
+	ctu_can_get_status(struct ctucan_hw_priv *priv)
+{
+	/* MODE and STATUS are within the same word */
+	union ctu_can_fd_status res;
+
+	res.u32 = priv->read_reg(priv, CTU_CAN_FD_STATUS);
+	return res;
+}
+
+/**
+ * ctucan_hw_is_enabled - Test if core is enabled..
+ *
+ * @priv: Private info
+ *
+ * Return: Return true if core is in enabled/active state..
+ */
+static inline bool ctucan_hw_is_enabled(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_mode_settings reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
+	return reg.s.ena == CTU_CAN_ENABLED;
+}
+
+/**
+ * ctu_can_fd_int_sts - Reads the interrupt status vector from CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: Interrupt status vector.
+ */
+static inline union ctu_can_fd_int_stat
+	ctu_can_fd_int_sts(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_int_stat res;
+
+	res.u32 = priv->read_reg(priv, CTU_CAN_FD_INT_STAT);
+	return res;
+}
+
+/**
+ * ctucan_hw_int_clr - Clears the interrupts from CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @mask: Mask of interrupts which should be cleared.
+ */
+static inline void ctucan_hw_int_clr(struct ctucan_hw_priv *priv,
+				      union ctu_can_fd_int_stat mask)
+{
+	priv->write_reg(priv, CTU_CAN_FD_INT_STAT, mask.u32);
+}
+
+/**
+ * ctucan_hw_int_ena_set - Sets enable interrupt bits.
+ *
+ * @priv: Private info
+ * @mask: Mask of interrupts which should be disabled.
+ */
+static inline void ctucan_hw_int_ena_set(struct ctucan_hw_priv *priv,
+					  union ctu_can_fd_int_stat mask)
+{
+	priv->write_reg(priv, CTU_CAN_FD_INT_ENA_SET, mask.u32);
+}
+
+/**
+ * ctucan_hw_int_ena_clr - Clears enable interrupt bits.
+ *
+ * @priv: Private info
+ * @mask: Mask of interrupts which should be disabled.
+ */
+static inline void ctucan_hw_int_ena_clr(struct ctucan_hw_priv *priv,
+					  union ctu_can_fd_int_stat mask)
+{
+	priv->write_reg(priv, CTU_CAN_FD_INT_ENA_CLR, mask.u32);
+}
+
+/**
+ * ctucan_hw_int_ena - Enable/Disable interrupts of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @mask: Mask of interrupts which should be enabled/disabled.
+ * @val: 0 - disable, 1 - enable the interrupt.
+ */
+void ctucan_hw_int_ena(struct ctucan_hw_priv *priv,
+			union ctu_can_fd_int_stat mask,
+			union ctu_can_fd_int_stat val);
+
+/**
+ * ctucan_hw_int_mask_set - Mask interrupts of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @mask: Mask of interrupts which should be masked.
+ */
+static inline void ctucan_hw_int_mask_set(struct ctucan_hw_priv *priv,
+					   union ctu_can_fd_int_stat mask)
+{
+	priv->write_reg(priv, CTU_CAN_FD_INT_MASK_SET, mask.u32);
+}
+
+/**
+ * ctucan_hw_int_mask_clr - Unmask interrupts of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @mask: Mask of interrupts which should be unmasked.
+ */
+static inline void ctucan_hw_int_mask_clr(struct ctucan_hw_priv *priv,
+					   union ctu_can_fd_int_stat mask)
+{
+	priv->write_reg(priv, CTU_CAN_FD_INT_MASK_CLR, mask.u32);
+}
+
+/**
+ * ctucan_hw_int_mask - Mask/Unmask interrupts of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @mask: Mask of interrupts which should be enabled/disabled.
+ * @val: 0 - unmask, 1 - mask the interrupt.
+ */
+void ctucan_hw_int_mask(struct ctucan_hw_priv *priv,
+			 union ctu_can_fd_int_stat mask,
+			 union ctu_can_fd_int_stat val);
+
+/**
+ * ctucan_hw_set_mode - Set the modes of CTU CAN FD IP Core.
+ *
+ *All flags from "ctucan_hw_set_mode_reg" are configured,
+ * plus CAN_CTRLMODE_ONE_SHOT, CAN_CTRLMODE_BERR_REPORTING,
+ * which are configured via "retransmit limit" and enabling error interrupts.
+ *
+ * @priv: Private info
+ * @mode: Mode of the controller from Socket CAN.
+ */
+void ctucan_hw_set_mode(struct ctucan_hw_priv *priv,
+			 const struct can_ctrlmode *mode);
+
+/**
+ * ctucan_hw_set_nom_bittiming - Set Nominal bit timing of CTU CAN FD Core.
+ *
+ * NOTE: phase_seg1 and prop_seg may be modified if phase_seg1 > 63
+ *       This is because in Linux, the constraints are only
+ *       on phase_seg1+prop_seg.
+ *
+ * @priv: Private info
+ * @nbt: Nominal bit timing settings of CAN Controller.
+ */
+void ctucan_hw_set_nom_bittiming(struct ctucan_hw_priv *priv,
+				  struct can_bittiming *nbt);
+
+/**
+ * ctucan_hw_set_data_bittiming - Set Data bit timing of CTU CAN FD Core.
+ *
+ * NOTE: phase_seg1 and prop_seg may be modified if phase_seg1 > 63
+ *       This is because in Linux, the constraints are only
+ *       on phase_seg1+prop_seg.
+ *
+ * @priv: Private info
+ * @dbt: Data bit timing settings of CAN Controller.
+ */
+void ctucan_hw_set_data_bittiming(struct ctucan_hw_priv *priv,
+				   struct can_bittiming *dbt);
+
+/**
+ * ctucan_hw_set_err_limits - Set limits for error warning and passive
+ *                             transition
+ *
+ * Set error limit when CTU CAN FD Core should transfer to Error warning
+ * and error passive states. If any of RX/TX counters reach this value
+ * according state is changed. By default these counters are set as in
+ * CAN Standard (96, 128).
+ *
+ * @priv: Private info
+ * @ewl: Error warning limit
+ * @erp: Error passive limit
+ */
+void ctucan_hw_set_err_limits(struct ctucan_hw_priv *priv, u8 ewl, u8 erp);
+
+/**
+ * ctucan_hw_set_def_err_limits - Set default error limits
+ *                                 to the CTU CAN FD Core.
+ *
+ * @priv: Private info
+ */
+static inline void ctucan_hw_set_def_err_limits(struct ctucan_hw_priv *priv)
+{
+	ctucan_hw_set_err_limits(priv, 96, 128);
+}
+
+/**
+ * ctucan_hw_read_err_ctrs - Read TX/RX error counters of CTU CAN FD IP Core.
+ *
+ * @priv: Private info
+ * @ctr: Pointer to error counter structure to fill
+ */
+void ctucan_hw_read_err_ctrs(struct ctucan_hw_priv *priv,
+			      struct can_berr_counter *ctr);
+
+/**
+ * ctucan_hw_read_nom_errs - Read special error counter which returns number
+ *                        of Errors which were detected during Nominal Bit-rate.
+ *
+ * @priv: Private info
+ * Return: Number of Error frames detected during Nominal Bit-rate
+ */
+static inline u16 ctucan_hw_read_nom_errs(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_err_norm_err_fd reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_ERR_NORM);
+	return reg.s.err_norm_val;
+}
+
+/**
+ * ctucan_hw_erase_nom_errs - Give command to CTU CAN FD Core to erase
+ *                             the nominal error counter.
+ *
+ * @priv: Private info
+ */
+static inline void ctucan_hw_erase_nom_errs(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_ctr_pres reg;
+
+	reg.u32 = 0;
+	reg.s.enorm = 1;
+	priv->write_reg(priv, CTU_CAN_FD_CTR_PRES, reg.u32);
+}
+
+/**
+ * ctucan_hw_read_fd_errs - Read special error counter which returns number
+ *                           of Errors which were detected during Data Bit-rate.
+ *
+ * @priv: Private info
+ * Return: Number of Error frames detected during Data Bit-rate
+ */
+static inline u16 ctucan_hw_read_fd_errs(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_err_norm_err_fd reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_ERR_NORM);
+	return reg.s.err_fd_val;
+}
+
+/**
+ * ctucan_hw_erase_fd_errs - Give command to CTU CAN FD Core to erase the Data
+ *                            error counter.
+ *
+ * @priv: Private info
+ */
+static inline void ctucan_hw_erase_fd_errs(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_ctr_pres reg;
+
+	reg.u32 = 0;
+	reg.s.efd = 1;
+	priv->write_reg(priv, CTU_CAN_FD_CTR_PRES, reg.u32);
+}
+
+/**
+ * ctucan_hw_read_error_state - Read fault confinement state of CTU CAN FD Core
+ *                               (determined by TX/RX Counters).
+ *
+ * @priv: Private info
+ * Return: Error state of the CTU CAN FD Core.
+ */
+enum can_state ctucan_hw_read_error_state(struct ctucan_hw_priv *priv);
+
+/**
+ * ctucan_hw_set_err_ctrs - Set value to TX/RX error counters
+ *                           of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @ctr: Value to be set into counters
+ * Return: Error state of the CTU CAN FD Core.
+ */
+void ctucan_hw_set_err_ctrs(struct ctucan_hw_priv *priv,
+			     const struct can_berr_counter *ctr);
+
+/*
+ * ctu_can_fd_read_err_capt_alc - Read core captured last error or arbitration
+ *                                lost reason.
+ *
+ * @priv: Private info
+ * Return: Error state of the CTU CAN FD.
+ */
+static inline union ctu_can_fd_err_capt_alc
+		ctu_can_fd_read_err_capt_alc(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_err_capt_alc res;
+
+	res.u32 = priv->read_reg(priv, CTU_CAN_FD_ERR_CAPT);
+	return res;
+}
+
+/**
+ * ctucan_hw_get_mask_filter_support - Check Mask filters support
+ *                                      of given filter.
+ *
+ * @priv: Private info
+ * @fnum: Filter number.
+ * Return: True if filter is present and can be used, False otherwise.
+ */
+bool ctucan_hw_get_mask_filter_support(struct ctucan_hw_priv *priv, u8 fnum);
+
+/**
+ * ctucan_hw_get_range_filter_support - Check Range filter support
+ *                                       of given filter.
+ *
+ * @priv: Private info
+ * Return: True if Range filter is present and can be used, False otherwise.
+ */
+bool ctucan_hw_get_range_filter_support(struct ctucan_hw_priv *priv);
+
+/**
+ * ctucan_hw_set_mask_filter - Configure mask filter of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @fnum: Filter number.
+ * @enable: True if filter should be enabled.
+ * @filter: Filter configuration.
+ * Return: True if mask filter was configured properly, false otherwise.
+ */
+bool ctucan_hw_set_mask_filter(struct ctucan_hw_priv *priv, u8 fnum,
+				bool enable, const struct can_filter *filter);
+
+/**
+ * ctucan_hw_set_range_filter - Configure range filter of CTU CAN FD Core.
+ *
+ * An identifier of RX Frame will pass the Range filter if its decimal value
+ * is between lower and upper threshold of range filter.
+ *
+ * @priv: Private info
+ * @low_th: Lower threshold of identifiers which should be accepted
+ * @high_th: Upper threshold of identifiers which should be accepted
+ * @enable: Enable the range filter.
+ */
+void ctucan_hw_set_range_filter(struct ctucan_hw_priv *priv, canid_t low_th,
+				 canid_t high_th, bool enable);
+
+/**
+ * ctucan_hw_get_rx_fifo_size - Get size of the RX FIFO Buffer
+ *                               of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: Size of the RX Buffer in words (32 bit)
+ */
+static inline u16 ctucan_hw_get_rx_fifo_size(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_rx_mem_info reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_MEM_INFO);
+	return reg.s.rx_buff_size;
+}
+
+/**
+ * ctucan_hw_get_rx_fifo_mem_free - Get number of free words in RX FIFO Buffer
+ *                                   of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: Number of free words (32 bit) in RX Buffer.
+ */
+static inline u16 ctucan_hw_get_rx_fifo_mem_free(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_rx_mem_info reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_MEM_INFO);
+	return reg.s.rx_mem_free;
+}
+
+/**
+ * ctucan_hw_is_rx_fifo_empty - Check if RX FIFO Buffer is empty.
+ *
+ * @priv: Private info
+ * Return: True if empty, false otherwise.
+ */
+static inline bool ctucan_hw_is_rx_fifo_empty(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_rx_status_rx_settings reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_STATUS);
+	return reg.s.rxe;
+}
+
+/**
+ * ctucan_hw_is_rx_fifo_full - Check if RX FIFO Buffer is full.
+ *
+ * @priv: Private info
+ * Return: True if Full, false otherwise.
+ */
+static inline bool ctucan_hw_is_rx_fifo_full(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_rx_status_rx_settings reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_STATUS);
+	return reg.s.rxf;
+}
+
+/**
+ * ctucan_hw_get_rx_frame_count - Get number of CAN Frames stored in RX Buffer
+ *                                 of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: True if Full, false otherwise.
+ */
+static inline u16 ctucan_hw_get_rx_frame_count(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_rx_status_rx_settings reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_STATUS);
+	return reg.s.rxfrc;
+}
+
+/**
+ * ctucan_hw_set_rx_tsop - Set timestamp option on RX Frame.
+ *
+ * @priv: Private info
+ * @val: Timestamp option settings.
+ */
+void ctucan_hw_set_rx_tsop(struct ctucan_hw_priv *priv,
+			    enum ctu_can_fd_rx_settings_rtsop val);
+
+/*
+ * ctu_can_fd_read_rx_ffw - Reads the first word of CAN Frame from RX FIFO
+ *                          Buffer.
+ *
+ * @priv: Private info
+ *
+ * Return: The firts word of received frame
+ */
+static inline union ctu_can_fd_frame_form_w
+	ctu_can_fd_read_rx_ffw(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_frame_form_w ffw;
+
+	ffw.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_DATA);
+	return ffw;
+}
+
+/**
+ * ctucan_hw_read_rx_word - Reads one word of CAN Frame from RX FIFO Buffer.
+ *
+ * @priv: Private info
+ *
+ * Return: One wword of received frame
+ */
+static inline u32 ctucan_hw_read_rx_word(struct ctucan_hw_priv *priv)
+{
+	return priv->read_reg(priv, CTU_CAN_FD_RX_DATA);
+}
+
+/**
+ * ctucan_hw_read_rx_frame - Reads CAN Frame from RX FIFO Buffer and stores it
+ *                            to a buffer.
+ *
+ * @priv: Private info
+ * @data: Pointer to buffer where the CAN Frame should be stored.
+ * @ts: Pointer to u64 where RX Timestamp should be stored.
+ */
+void ctucan_hw_read_rx_frame(struct ctucan_hw_priv *priv,
+			      struct canfd_frame *data, u64 *ts);
+
+/**
+ * ctucan_hw_read_rx_frame_ffw - Reads rest of CAN Frame from RX FIFO Buffer
+ *                                and stores it to a buffer.
+ *
+ * @priv: Private info
+ * @cf: Pointer to buffer where the CAN Frame should be stored.
+ * @ts: Pointer to u64 where RX Timestamp should be stored.
+ * @ffw: Already read the first frame control word by the caller
+ */
+void ctucan_hw_read_rx_frame_ffw(struct ctucan_hw_priv *priv,
+				  struct canfd_frame *cf, u64 *ts,
+				  union ctu_can_fd_frame_form_w ffw);
+
+/*
+ * ctucan_hw_get_tx_status - Returns status of TXT Buffer.
+ *
+ * @priv: Private info
+ * @buf: TXT Buffer index (1 to CTU_CAN_FD_TXT_BUFFER_COUNT)
+ * Return: Status of the TXT Buffer.
+ */
+enum ctu_can_fd_tx_status_tx1s
+	ctucan_hw_get_tx_status(struct ctucan_hw_priv *priv, u8 buf);
+
+/**
+ * ctucan_hw_is_txt_buf_accessible - Checks if TXT Buffer is accessible
+ *                                    and can be written to.
+ *
+ * @priv: Private info
+ * @buf: TXT Buffer index (1 to CTU_CAN_FD_TXT_BUFFER_COUNT)
+ * Return: Status of the TXT Buffer.
+ */
+bool ctucan_hw_is_txt_buf_accessible(struct ctucan_hw_priv *priv, u8 buf);
+
+/**
+ * ctucan_hw_txt_buf_give_command - Give command to TXT Buffer
+ *                                   of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @cmd: Command line buffer.
+ * @buf: TXT Buffer index (1 to CTU_CAN_FD_TXT_BUFFER_COUNT)
+ * Return: Status of the TXT Buffer.
+ */
+bool ctucan_hw_txt_buf_give_command(struct ctucan_hw_priv *priv, u8 cmd,
+				     u8 buf);
+
+/**
+ * ctucan_hw_txt_set_empty - Give "set_empty" command to TXT Buffer.
+ *
+ * @priv: Private info
+ * @buf: TXT Buffer index (1 to CTU_CAN_FD_TXT_BUFFER_COUNT)
+ * Return: Status of the TXT Buffer.
+ */
+static inline void ctucan_hw_txt_set_empty(struct ctucan_hw_priv *priv, u8 buf)
+{
+	ctucan_hw_txt_buf_give_command(priv, 0x1, buf);
+}
+
+/**
+ * ctucan_hw_txt_set_rdy - Give "set_ready" command to TXT Buffer.
+ *
+ * @priv: Private info
+ * @buf: TXT Buffer index (1 to CTU_CAN_FD_TXT_BUFFER_COUNT)
+ * Return: Status of the TXT Buffer.
+ */
+static inline void ctucan_hw_txt_set_rdy(struct ctucan_hw_priv *priv, u8 buf)
+{
+	ctucan_hw_txt_buf_give_command(priv, 0x2, buf);
+}
+
+/**
+ * ctucan_hw_txt_set_abort - Give "set_abort" command to TXT Buffer.
+ *
+ * @priv: Private info
+ * @buf: TXT Buffer index (1 to CTU_CAN_FD_TXT_BUFFER_COUNT)
+ * Return: Status of the TXT Buffer.
+ */
+static inline void ctucan_hw_txt_set_abort(struct ctucan_hw_priv *priv, u8 buf)
+{
+	ctucan_hw_txt_buf_give_command(priv, 0x4, buf);
+}
+
+/**
+ * ctucan_hw_set_txt_priority - Set priority of TXT Buffers in CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @prio: Pointer to array with CTU_CAN_FD_TXT_BUFFER_COUNT number
+ *		of elements with TXT Buffer priorities.
+ */
+void ctucan_hw_set_txt_priority(struct ctucan_hw_priv *priv, const u8 *prio);
+
+/**
+ * ctucan_hw_insert_frame - Insert CAN FD frame to TXT Buffer
+ *                           of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * @data: Pointer to CAN Frame buffer.
+ * @ts: Timestamp when the buffer should be sent.
+ * @buf: Index of TXT Buffer where to insert the CAN Frame.
+ * @isfdf: True if the frame is a FD frame.
+ * Return: True if the frame was inserted successfully, False otherwise.
+ */
+bool ctucan_hw_insert_frame(struct ctucan_hw_priv *priv,
+			     const struct canfd_frame *data, u64 ts,
+			     u8 buf, bool isfdf);
+
+/**
+ * ctucan_hw_get_tran_delay - Read transceiver delay as measured
+ *                             by CTU CAN FD Core.
+ *
+ * Note that transceiver delay can be measured only after at least
+ * one CAN FD Frame with BRS bit was sent since the last re-start of the Core.
+ *
+ * @priv: Private info
+ * Return: True if the frame was inserted successfully, False otherwise.
+ */
+static inline u16 ctucan_hw_get_tran_delay(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_trv_delay_ssp_cfg reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_TRV_DELAY);
+	return reg.s.trv_delay_value;
+}
+
+/**
+ * ctucan_hw_get_tx_frame_ctr - Read number of transmitted CAN/CAN FD Frames
+ *                               by CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: Number of received CAN/CAN FD frames.
+ */
+static inline u32 ctucan_hw_get_tx_frame_ctr(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_tx_fr_ctr reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_TX_FR_CTR);
+	return reg.s.tx_fr_ctr_val;
+}
+
+/**
+ * ctucan_hw_get_rx_frame_ctr - Read number of received CAN/CAN FD Frames
+ *                               by CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: Number of received CAN/CAN FD frames.
+ */
+static inline u32 ctucan_hw_get_rx_frame_ctr(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_rx_fr_ctr reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_RX_FR_CTR);
+	return reg.s.rx_fr_ctr_val;
+}
+
+/*
+ * ctu_can_fd_read_debug_info - Returns debug information of CTU CAN FD Core.
+ *
+ * @priv: Private info
+ * Return: Content of Debug register.
+ */
+static inline union ctu_can_fd_debug_register
+	ctu_can_fd_read_debug_info(struct ctucan_hw_priv *priv)
+{
+	union ctu_can_fd_debug_register reg;
+
+	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_DEBUG_REGISTER);
+	return reg;
+}
+
+/**
+ * ctucan_hw_read_timestamp - Read timestamp value which is used internally
+ *                             by CTU CAN FD Core.
+ *
+ * Reads timestamp twice and checks consistency betwen upper and
+ * lower timestamp word.
+ *
+ * @priv: Private info
+ * Return: Value of timestamp in CTU CAN FD Core
+ */
+u64 ctucan_hw_read_timestamp(struct ctucan_hw_priv *priv);
+
+/**
+ * ctucan_hw_configure_ssp - Configure Secondary sample point usage and
+ *			     position.
+ *
+ * @priv: Private info
+ * @enable_ssp: Enable Secondary Sampling point. When false, regular sampling
+ *	       point is used.
+ * @use_trv_delay: Add Transmitter delay to secondary sampling point position.
+ * @ssp_offset: Position of secondary sampling point.
+ */
+void ctucan_hw_configure_ssp(struct ctucan_hw_priv *priv, bool enable_ssp,
+			     bool use_trv_delay, int ssp_offset);
+
+extern const struct can_bittiming_const ctu_can_fd_bit_timing_max;
+extern const struct can_bittiming_const ctu_can_fd_bit_timing_data_max;
+
+#endif
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd_regs.h b/drivers/net/can/ctucanfd/ctu_can_fd_regs.h
new file mode 100644
index 000000000000..1dbcdb8aae6a
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd_regs.h
@@ -0,0 +1,965 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ * Copyright (C) 2015-2018
+ *
+ * Authors:
+ *     Ondrej Ille <ondrej.ille@gmail.com>
+ *     Martin Jerabek <martin.jerabek01@gmail.com>
+ *     Jaroslav Beran <jara.beran@gmail.com>
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+/* This file is autogenerated, DO NOT EDIT! */
+
+#ifndef __CTU_CAN_FD_CAN_FD_REGISTER_MAP__
+#define __CTU_CAN_FD_CAN_FD_REGISTER_MAP__
+
+/* CAN_Registers memory map */
+enum ctu_can_fd_can_registers {
+	CTU_CAN_FD_DEVICE_ID             = 0x0,
+	CTU_CAN_FD_VERSION               = 0x2,
+	CTU_CAN_FD_MODE                  = 0x4,
+	CTU_CAN_FD_SETTINGS              = 0x6,
+	CTU_CAN_FD_STATUS                = 0x8,
+	CTU_CAN_FD_COMMAND               = 0xc,
+	CTU_CAN_FD_INT_STAT             = 0x10,
+	CTU_CAN_FD_INT_ENA_SET          = 0x14,
+	CTU_CAN_FD_INT_ENA_CLR          = 0x18,
+	CTU_CAN_FD_INT_MASK_SET         = 0x1c,
+	CTU_CAN_FD_INT_MASK_CLR         = 0x20,
+	CTU_CAN_FD_BTR                  = 0x24,
+	CTU_CAN_FD_BTR_FD               = 0x28,
+	CTU_CAN_FD_EWL                  = 0x2c,
+	CTU_CAN_FD_ERP                  = 0x2d,
+	CTU_CAN_FD_FAULT_STATE          = 0x2e,
+	CTU_CAN_FD_REC                  = 0x30,
+	CTU_CAN_FD_TEC                  = 0x32,
+	CTU_CAN_FD_ERR_NORM             = 0x34,
+	CTU_CAN_FD_ERR_FD               = 0x36,
+	CTU_CAN_FD_CTR_PRES             = 0x38,
+	CTU_CAN_FD_FILTER_A_MASK        = 0x3c,
+	CTU_CAN_FD_FILTER_A_VAL         = 0x40,
+	CTU_CAN_FD_FILTER_B_MASK        = 0x44,
+	CTU_CAN_FD_FILTER_B_VAL         = 0x48,
+	CTU_CAN_FD_FILTER_C_MASK        = 0x4c,
+	CTU_CAN_FD_FILTER_C_VAL         = 0x50,
+	CTU_CAN_FD_FILTER_RAN_LOW       = 0x54,
+	CTU_CAN_FD_FILTER_RAN_HIGH      = 0x58,
+	CTU_CAN_FD_FILTER_CONTROL       = 0x5c,
+	CTU_CAN_FD_FILTER_STATUS        = 0x5e,
+	CTU_CAN_FD_RX_MEM_INFO          = 0x60,
+	CTU_CAN_FD_RX_POINTERS          = 0x64,
+	CTU_CAN_FD_RX_STATUS            = 0x68,
+	CTU_CAN_FD_RX_SETTINGS          = 0x6a,
+	CTU_CAN_FD_RX_DATA              = 0x6c,
+	CTU_CAN_FD_TX_STATUS            = 0x70,
+	CTU_CAN_FD_TX_COMMAND           = 0x74,
+	CTU_CAN_FD_TX_PRIORITY          = 0x78,
+	CTU_CAN_FD_ERR_CAPT             = 0x7c,
+	CTU_CAN_FD_ALC                  = 0x7e,
+	CTU_CAN_FD_TRV_DELAY            = 0x80,
+	CTU_CAN_FD_SSP_CFG              = 0x82,
+	CTU_CAN_FD_RX_FR_CTR            = 0x84,
+	CTU_CAN_FD_TX_FR_CTR            = 0x88,
+	CTU_CAN_FD_DEBUG_REGISTER       = 0x8c,
+	CTU_CAN_FD_YOLO_REG             = 0x90,
+	CTU_CAN_FD_TIMESTAMP_LOW        = 0x94,
+	CTU_CAN_FD_TIMESTAMP_HIGH       = 0x98,
+	CTU_CAN_FD_TXTB1_DATA_1        = 0x100,
+	CTU_CAN_FD_TXTB1_DATA_2        = 0x104,
+	CTU_CAN_FD_TXTB1_DATA_20       = 0x14c,
+	CTU_CAN_FD_TXTB2_DATA_1        = 0x200,
+	CTU_CAN_FD_TXTB2_DATA_2        = 0x204,
+	CTU_CAN_FD_TXTB2_DATA_20       = 0x24c,
+	CTU_CAN_FD_TXTB3_DATA_1        = 0x300,
+	CTU_CAN_FD_TXTB3_DATA_2        = 0x304,
+	CTU_CAN_FD_TXTB3_DATA_20       = 0x34c,
+	CTU_CAN_FD_TXTB4_DATA_1        = 0x400,
+	CTU_CAN_FD_TXTB4_DATA_2        = 0x404,
+	CTU_CAN_FD_TXTB4_DATA_20       = 0x44c,
+};
+
+
+/* Register descriptions: */
+union ctu_can_fd_device_id_version {
+	uint32_t u32;
+	struct ctu_can_fd_device_id_version_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* DEVICE_ID */
+		uint32_t device_id              : 16;
+  /* VERSION */
+		uint32_t ver_minor               : 8;
+		uint32_t ver_major               : 8;
+#else
+		uint32_t ver_major               : 8;
+		uint32_t ver_minor               : 8;
+		uint32_t device_id              : 16;
+#endif
+	} s;
+};
+
+enum ctu_can_fd_device_id_device_id {
+	CTU_CAN_FD_ID    = 0xcafd,
+};
+
+union ctu_can_fd_mode_settings {
+	uint32_t u32;
+	struct ctu_can_fd_mode_settings_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* MODE */
+		uint32_t rst                     : 1;
+		uint32_t lom                     : 1;
+		uint32_t stm                     : 1;
+		uint32_t afm                     : 1;
+		uint32_t fde                     : 1;
+		uint32_t reserved_6_5            : 2;
+		uint32_t acf                     : 1;
+		uint32_t tstm                    : 1;
+		uint32_t reserved_15_9           : 7;
+  /* SETTINGS */
+		uint32_t rtrle                   : 1;
+		uint32_t rtrth                   : 4;
+		uint32_t ilbp                    : 1;
+		uint32_t ena                     : 1;
+		uint32_t nisofd                  : 1;
+		uint32_t reserved_31_24          : 8;
+#else
+		uint32_t reserved_31_24          : 8;
+		uint32_t nisofd                  : 1;
+		uint32_t ena                     : 1;
+		uint32_t ilbp                    : 1;
+		uint32_t rtrth                   : 4;
+		uint32_t rtrle                   : 1;
+		uint32_t reserved_15_9           : 7;
+		uint32_t tstm                    : 1;
+		uint32_t acf                     : 1;
+		uint32_t reserved_6_5            : 2;
+		uint32_t fde                     : 1;
+		uint32_t afm                     : 1;
+		uint32_t stm                     : 1;
+		uint32_t lom                     : 1;
+		uint32_t rst                     : 1;
+#endif
+	} s;
+};
+
+enum ctu_can_fd_mode_lom {
+	LOM_DISABLED       = 0x0,
+	LOM_ENABLED        = 0x1,
+};
+
+enum ctu_can_fd_mode_stm {
+	STM_DISABLED       = 0x0,
+	STM_ENABLED        = 0x1,
+};
+
+enum ctu_can_fd_mode_afm {
+	AFM_DISABLED       = 0x0,
+	AFM_ENABLED        = 0x1,
+};
+
+enum ctu_can_fd_mode_fde {
+	FDE_DISABLE       = 0x0,
+	FDE_ENABLE        = 0x1,
+};
+
+enum ctu_can_fd_mode_acf {
+	ACF_DISABLED       = 0x0,
+	ACF_ENABLED        = 0x1,
+};
+
+enum ctu_can_fd_settings_rtrle {
+	RTRLE_DISABLED       = 0x0,
+	RTRLE_ENABLED        = 0x1,
+};
+
+enum ctu_can_fd_settings_ilbp {
+	INT_LOOP_DISABLED       = 0x0,
+	INT_LOOP_ENABLED        = 0x1,
+};
+
+enum ctu_can_fd_settings_ena {
+	CTU_CAN_DISABLED       = 0x0,
+	CTU_CAN_ENABLED        = 0x1,
+};
+
+enum ctu_can_fd_settings_nisofd {
+	ISO_FD           = 0x0,
+	NON_ISO_FD       = 0x1,
+};
+
+union ctu_can_fd_status {
+	uint32_t u32;
+	struct ctu_can_fd_status_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* STATUS */
+		uint32_t rxne                    : 1;
+		uint32_t dor                     : 1;
+		uint32_t txnf                    : 1;
+		uint32_t eft                     : 1;
+		uint32_t rxs                     : 1;
+		uint32_t txs                     : 1;
+		uint32_t ewl                     : 1;
+		uint32_t idle                    : 1;
+		uint32_t reserved_31_8          : 24;
+#else
+		uint32_t reserved_31_8          : 24;
+		uint32_t idle                    : 1;
+		uint32_t ewl                     : 1;
+		uint32_t txs                     : 1;
+		uint32_t rxs                     : 1;
+		uint32_t eft                     : 1;
+		uint32_t txnf                    : 1;
+		uint32_t dor                     : 1;
+		uint32_t rxne                    : 1;
+#endif
+	} s;
+};
+
+union ctu_can_fd_command {
+	uint32_t u32;
+	struct ctu_can_fd_command_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+		uint32_t reserved_1_0            : 2;
+  /* COMMAND */
+		uint32_t rrb                     : 1;
+		uint32_t cdo                     : 1;
+		uint32_t ercrst                  : 1;
+		uint32_t rxfcrst                 : 1;
+		uint32_t txfcrst                 : 1;
+		uint32_t reserved_31_7          : 25;
+#else
+		uint32_t reserved_31_7          : 25;
+		uint32_t txfcrst                 : 1;
+		uint32_t rxfcrst                 : 1;
+		uint32_t ercrst                  : 1;
+		uint32_t cdo                     : 1;
+		uint32_t rrb                     : 1;
+		uint32_t reserved_1_0            : 2;
+#endif
+	} s;
+};
+
+union ctu_can_fd_int_stat {
+	uint32_t u32;
+	struct ctu_can_fd_int_stat_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* INT_STAT */
+		uint32_t rxi                     : 1;
+		uint32_t txi                     : 1;
+		uint32_t ewli                    : 1;
+		uint32_t doi                     : 1;
+		uint32_t fcsi                    : 1;
+		uint32_t ali                     : 1;
+		uint32_t bei                     : 1;
+		uint32_t ofi                     : 1;
+		uint32_t rxfi                    : 1;
+		uint32_t bsi                     : 1;
+		uint32_t rbnei                   : 1;
+		uint32_t txbhci                  : 1;
+		uint32_t reserved_31_12         : 20;
+#else
+		uint32_t reserved_31_12         : 20;
+		uint32_t txbhci                  : 1;
+		uint32_t rbnei                   : 1;
+		uint32_t bsi                     : 1;
+		uint32_t rxfi                    : 1;
+		uint32_t ofi                     : 1;
+		uint32_t bei                     : 1;
+		uint32_t ali                     : 1;
+		uint32_t fcsi                    : 1;
+		uint32_t doi                     : 1;
+		uint32_t ewli                    : 1;
+		uint32_t txi                     : 1;
+		uint32_t rxi                     : 1;
+#endif
+	} s;
+};
+
+union ctu_can_fd_int_ena_set {
+	uint32_t u32;
+	struct ctu_can_fd_int_ena_set_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* INT_ENA_SET */
+		uint32_t int_ena_set            : 12;
+		uint32_t reserved_31_12         : 20;
+#else
+		uint32_t reserved_31_12         : 20;
+		uint32_t int_ena_set            : 12;
+#endif
+	} s;
+};
+
+union ctu_can_fd_int_ena_clr {
+	uint32_t u32;
+	struct ctu_can_fd_int_ena_clr_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* INT_ENA_CLR */
+		uint32_t int_ena_clr            : 12;
+		uint32_t reserved_31_12         : 20;
+#else
+		uint32_t reserved_31_12         : 20;
+		uint32_t int_ena_clr            : 12;
+#endif
+	} s;
+};
+
+union ctu_can_fd_int_mask_set {
+	uint32_t u32;
+	struct ctu_can_fd_int_mask_set_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* INT_MASK_SET */
+		uint32_t int_mask_set           : 12;
+		uint32_t reserved_31_12         : 20;
+#else
+		uint32_t reserved_31_12         : 20;
+		uint32_t int_mask_set           : 12;
+#endif
+	} s;
+};
+
+union ctu_can_fd_int_mask_clr {
+	uint32_t u32;
+	struct ctu_can_fd_int_mask_clr_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* INT_MASK_CLR */
+		uint32_t int_mask_clr           : 12;
+		uint32_t reserved_31_12         : 20;
+#else
+		uint32_t reserved_31_12         : 20;
+		uint32_t int_mask_clr           : 12;
+#endif
+	} s;
+};
+
+union ctu_can_fd_btr {
+	uint32_t u32;
+	struct ctu_can_fd_btr_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* BTR */
+		uint32_t prop                    : 7;
+		uint32_t ph1                     : 6;
+		uint32_t ph2                     : 6;
+		uint32_t brp                     : 8;
+		uint32_t sjw                     : 5;
+#else
+		uint32_t sjw                     : 5;
+		uint32_t brp                     : 8;
+		uint32_t ph2                     : 6;
+		uint32_t ph1                     : 6;
+		uint32_t prop                    : 7;
+#endif
+	} s;
+};
+
+union ctu_can_fd_btr_fd {
+	uint32_t u32;
+	struct ctu_can_fd_btr_fd_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* BTR_FD */
+		uint32_t prop_fd                 : 6;
+		uint32_t reserved_6              : 1;
+		uint32_t ph1_fd                  : 5;
+		uint32_t reserved_12             : 1;
+		uint32_t ph2_fd                  : 5;
+		uint32_t reserved_18             : 1;
+		uint32_t brp_fd                  : 8;
+		uint32_t sjw_fd                  : 5;
+#else
+		uint32_t sjw_fd                  : 5;
+		uint32_t brp_fd                  : 8;
+		uint32_t reserved_18             : 1;
+		uint32_t ph2_fd                  : 5;
+		uint32_t reserved_12             : 1;
+		uint32_t ph1_fd                  : 5;
+		uint32_t reserved_6              : 1;
+		uint32_t prop_fd                 : 6;
+#endif
+	} s;
+};
+
+union ctu_can_fd_ewl_erp_fault_state {
+	uint32_t u32;
+	struct ctu_can_fd_ewl_erp_fault_state_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* EWL */
+		uint32_t ew_limit                : 8;
+  /* ERP */
+		uint32_t erp_limit               : 8;
+  /* FAULT_STATE */
+		uint32_t era                     : 1;
+		uint32_t erp                     : 1;
+		uint32_t bof                     : 1;
+		uint32_t reserved_31_19         : 13;
+#else
+		uint32_t reserved_31_19         : 13;
+		uint32_t bof                     : 1;
+		uint32_t erp                     : 1;
+		uint32_t era                     : 1;
+		uint32_t erp_limit               : 8;
+		uint32_t ew_limit                : 8;
+#endif
+	} s;
+};
+
+union ctu_can_fd_rec_tec {
+	uint32_t u32;
+	struct ctu_can_fd_rec_tec_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* REC */
+		uint32_t rec_val                 : 9;
+		uint32_t reserved_15_9           : 7;
+  /* TEC */
+		uint32_t tec_val                 : 9;
+		uint32_t reserved_31_25          : 7;
+#else
+		uint32_t reserved_31_25          : 7;
+		uint32_t tec_val                 : 9;
+		uint32_t reserved_15_9           : 7;
+		uint32_t rec_val                 : 9;
+#endif
+	} s;
+};
+
+union ctu_can_fd_err_norm_err_fd {
+	uint32_t u32;
+	struct ctu_can_fd_err_norm_err_fd_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* ERR_NORM */
+		uint32_t err_norm_val           : 16;
+  /* ERR_FD */
+		uint32_t err_fd_val             : 16;
+#else
+		uint32_t err_fd_val             : 16;
+		uint32_t err_norm_val           : 16;
+#endif
+	} s;
+};
+
+union ctu_can_fd_ctr_pres {
+	uint32_t u32;
+	struct ctu_can_fd_ctr_pres_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* CTR_PRES */
+		uint32_t ctpv                    : 9;
+		uint32_t ptx                     : 1;
+		uint32_t prx                     : 1;
+		uint32_t enorm                   : 1;
+		uint32_t efd                     : 1;
+		uint32_t reserved_31_13         : 19;
+#else
+		uint32_t reserved_31_13         : 19;
+		uint32_t efd                     : 1;
+		uint32_t enorm                   : 1;
+		uint32_t prx                     : 1;
+		uint32_t ptx                     : 1;
+		uint32_t ctpv                    : 9;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_a_mask {
+	uint32_t u32;
+	struct ctu_can_fd_filter_a_mask_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_A_MASK */
+		uint32_t bit_mask_a_val         : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_mask_a_val         : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_a_val {
+	uint32_t u32;
+	struct ctu_can_fd_filter_a_val_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_A_VAL */
+		uint32_t bit_val_a_val          : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_val_a_val          : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_b_mask {
+	uint32_t u32;
+	struct ctu_can_fd_filter_b_mask_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_B_MASK */
+		uint32_t bit_mask_b_val         : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_mask_b_val         : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_b_val {
+	uint32_t u32;
+	struct ctu_can_fd_filter_b_val_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_B_VAL */
+		uint32_t bit_val_b_val          : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_val_b_val          : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_c_mask {
+	uint32_t u32;
+	struct ctu_can_fd_filter_c_mask_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_C_MASK */
+		uint32_t bit_mask_c_val         : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_mask_c_val         : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_c_val {
+	uint32_t u32;
+	struct ctu_can_fd_filter_c_val_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_C_VAL */
+		uint32_t bit_val_c_val          : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_val_c_val          : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_ran_low {
+	uint32_t u32;
+	struct ctu_can_fd_filter_ran_low_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_RAN_LOW */
+		uint32_t bit_ran_low_val        : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_ran_low_val        : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_ran_high {
+	uint32_t u32;
+	struct ctu_can_fd_filter_ran_high_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_RAN_HIGH */
+		uint32_t bit_ran_high_val       : 29;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t bit_ran_high_val       : 29;
+#endif
+	} s;
+};
+
+union ctu_can_fd_filter_control_filter_status {
+	uint32_t u32;
+	struct ctu_can_fd_filter_control_filter_status_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* FILTER_CONTROL */
+		uint32_t fanb                    : 1;
+		uint32_t fane                    : 1;
+		uint32_t fafb                    : 1;
+		uint32_t fafe                    : 1;
+		uint32_t fbnb                    : 1;
+		uint32_t fbne                    : 1;
+		uint32_t fbfb                    : 1;
+		uint32_t fbfe                    : 1;
+		uint32_t fcnb                    : 1;
+		uint32_t fcne                    : 1;
+		uint32_t fcfb                    : 1;
+		uint32_t fcfe                    : 1;
+		uint32_t frnb                    : 1;
+		uint32_t frne                    : 1;
+		uint32_t frfb                    : 1;
+		uint32_t frfe                    : 1;
+  /* FILTER_STATUS */
+		uint32_t sfa                     : 1;
+		uint32_t sfb                     : 1;
+		uint32_t sfc                     : 1;
+		uint32_t sfr                     : 1;
+		uint32_t reserved_31_20         : 12;
+#else
+		uint32_t reserved_31_20         : 12;
+		uint32_t sfr                     : 1;
+		uint32_t sfc                     : 1;
+		uint32_t sfb                     : 1;
+		uint32_t sfa                     : 1;
+		uint32_t frfe                    : 1;
+		uint32_t frfb                    : 1;
+		uint32_t frne                    : 1;
+		uint32_t frnb                    : 1;
+		uint32_t fcfe                    : 1;
+		uint32_t fcfb                    : 1;
+		uint32_t fcne                    : 1;
+		uint32_t fcnb                    : 1;
+		uint32_t fbfe                    : 1;
+		uint32_t fbfb                    : 1;
+		uint32_t fbne                    : 1;
+		uint32_t fbnb                    : 1;
+		uint32_t fafe                    : 1;
+		uint32_t fafb                    : 1;
+		uint32_t fane                    : 1;
+		uint32_t fanb                    : 1;
+#endif
+	} s;
+};
+
+union ctu_can_fd_rx_mem_info {
+	uint32_t u32;
+	struct ctu_can_fd_rx_mem_info_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* RX_MEM_INFO */
+		uint32_t rx_buff_size           : 13;
+		uint32_t reserved_15_13          : 3;
+		uint32_t rx_mem_free            : 13;
+		uint32_t reserved_31_29          : 3;
+#else
+		uint32_t reserved_31_29          : 3;
+		uint32_t rx_mem_free            : 13;
+		uint32_t reserved_15_13          : 3;
+		uint32_t rx_buff_size           : 13;
+#endif
+	} s;
+};
+
+union ctu_can_fd_rx_pointers {
+	uint32_t u32;
+	struct ctu_can_fd_rx_pointers_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* RX_POINTERS */
+		uint32_t rx_wpp                 : 12;
+		uint32_t reserved_15_12          : 4;
+		uint32_t rx_rpp                 : 12;
+		uint32_t reserved_31_28          : 4;
+#else
+		uint32_t reserved_31_28          : 4;
+		uint32_t rx_rpp                 : 12;
+		uint32_t reserved_15_12          : 4;
+		uint32_t rx_wpp                 : 12;
+#endif
+	} s;
+};
+
+union ctu_can_fd_rx_status_rx_settings {
+	uint32_t u32;
+	struct ctu_can_fd_rx_status_rx_settings_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* RX_STATUS */
+		uint32_t rxe                     : 1;
+		uint32_t rxf                     : 1;
+		uint32_t reserved_3_2            : 2;
+		uint32_t rxfrc                  : 11;
+		uint32_t reserved_15             : 1;
+  /* RX_SETTINGS */
+		uint32_t rtsop                   : 1;
+		uint32_t reserved_31_17         : 15;
+#else
+		uint32_t reserved_31_17         : 15;
+		uint32_t rtsop                   : 1;
+		uint32_t reserved_15             : 1;
+		uint32_t rxfrc                  : 11;
+		uint32_t reserved_3_2            : 2;
+		uint32_t rxf                     : 1;
+		uint32_t rxe                     : 1;
+#endif
+	} s;
+};
+
+enum ctu_can_fd_rx_settings_rtsop {
+	RTS_END       = 0x0,
+	RTS_BEG       = 0x1,
+};
+
+union ctu_can_fd_rx_data {
+	uint32_t u32;
+	struct ctu_can_fd_rx_data_s {
+  /* RX_DATA */
+		uint32_t rx_data                : 32;
+	} s;
+};
+
+union ctu_can_fd_tx_status {
+	uint32_t u32;
+	struct ctu_can_fd_tx_status_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* TX_STATUS */
+		uint32_t tx1s                    : 4;
+		uint32_t tx2s                    : 4;
+		uint32_t tx3s                    : 4;
+		uint32_t tx4s                    : 4;
+		uint32_t reserved_31_16         : 16;
+#else
+		uint32_t reserved_31_16         : 16;
+		uint32_t tx4s                    : 4;
+		uint32_t tx3s                    : 4;
+		uint32_t tx2s                    : 4;
+		uint32_t tx1s                    : 4;
+#endif
+	} s;
+};
+
+enum ctu_can_fd_tx_status_tx1s {
+	TXT_RDY        = 0x1,
+	TXT_TRAN       = 0x2,
+	TXT_ABTP       = 0x3,
+	TXT_TOK        = 0x4,
+	TXT_ERR        = 0x6,
+	TXT_ABT        = 0x7,
+	TXT_ETY        = 0x8,
+};
+
+union ctu_can_fd_tx_command {
+	uint32_t u32;
+	struct ctu_can_fd_tx_command_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* TX_COMMAND */
+		uint32_t txce                    : 1;
+		uint32_t txcr                    : 1;
+		uint32_t txca                    : 1;
+		uint32_t reserved_7_3            : 5;
+		uint32_t txb1                    : 1;
+		uint32_t txb2                    : 1;
+		uint32_t txb3                    : 1;
+		uint32_t txb4                    : 1;
+		uint32_t reserved_31_12         : 20;
+#else
+		uint32_t reserved_31_12         : 20;
+		uint32_t txb4                    : 1;
+		uint32_t txb3                    : 1;
+		uint32_t txb2                    : 1;
+		uint32_t txb1                    : 1;
+		uint32_t reserved_7_3            : 5;
+		uint32_t txca                    : 1;
+		uint32_t txcr                    : 1;
+		uint32_t txce                    : 1;
+#endif
+	} s;
+};
+
+union ctu_can_fd_tx_priority {
+	uint32_t u32;
+	struct ctu_can_fd_tx_priority_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* TX_PRIORITY */
+		uint32_t txt1p                   : 3;
+		uint32_t reserved_3              : 1;
+		uint32_t txt2p                   : 3;
+		uint32_t reserved_7              : 1;
+		uint32_t txt3p                   : 3;
+		uint32_t reserved_11             : 1;
+		uint32_t txt4p                   : 3;
+		uint32_t reserved_31_15         : 17;
+#else
+		uint32_t reserved_31_15         : 17;
+		uint32_t txt4p                   : 3;
+		uint32_t reserved_11             : 1;
+		uint32_t txt3p                   : 3;
+		uint32_t reserved_7              : 1;
+		uint32_t txt2p                   : 3;
+		uint32_t reserved_3              : 1;
+		uint32_t txt1p                   : 3;
+#endif
+	} s;
+};
+
+union ctu_can_fd_err_capt_alc {
+	uint32_t u32;
+	struct ctu_can_fd_err_capt_alc_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* ERR_CAPT */
+		uint32_t err_pos                 : 5;
+		uint32_t err_type                : 3;
+		uint32_t reserved_15_8           : 8;
+  /* ALC */
+		uint32_t alc_bit                 : 5;
+		uint32_t alc_id_field            : 3;
+		uint32_t reserved_31_24          : 8;
+#else
+		uint32_t reserved_31_24          : 8;
+		uint32_t alc_id_field            : 3;
+		uint32_t alc_bit                 : 5;
+		uint32_t reserved_15_8           : 8;
+		uint32_t err_type                : 3;
+		uint32_t err_pos                 : 5;
+#endif
+	} s;
+};
+
+enum ctu_can_fd_err_capt_err_pos {
+	ERC_POS_SOF         = 0x0,
+	ERC_POS_ARB         = 0x1,
+	ERC_POS_CTRL        = 0x2,
+	ERC_POS_DATA        = 0x3,
+	ERC_POS_CRC         = 0x4,
+	ERC_POS_ACK         = 0x5,
+	ERC_POS_INTF        = 0x6,
+	ERC_POS_ERR         = 0x7,
+	ERC_POS_OVRL        = 0x8,
+	ERC_POS_OTHER      = 0x1f,
+};
+
+enum ctu_can_fd_err_capt_err_type {
+	ERC_BIT_ERR        = 0x0,
+	ERC_CRC_ERR        = 0x1,
+	ERC_FRM_ERR        = 0x2,
+	ERC_ACK_ERR        = 0x3,
+	ERC_STUF_ERR       = 0x4,
+};
+
+enum ctu_can_fd_alc_alc_id_field {
+	ALC_RSVD            = 0x0,
+	ALC_BASE_ID         = 0x1,
+	ALC_SRR_RTR         = 0x2,
+	ALC_IDE             = 0x3,
+	ALC_EXTENSION       = 0x4,
+	ALC_RTR             = 0x5,
+};
+
+union ctu_can_fd_trv_delay_ssp_cfg {
+	uint32_t u32;
+	struct ctu_can_fd_trv_delay_ssp_cfg_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* TRV_DELAY */
+		uint32_t trv_delay_value         : 7;
+		uint32_t reserved_15_7           : 9;
+  /* SSP_CFG */
+		uint32_t ssp_offset              : 8;
+		uint32_t ssp_src                 : 2;
+		uint32_t reserved_31_26          : 6;
+#else
+		uint32_t reserved_31_26          : 6;
+		uint32_t ssp_src                 : 2;
+		uint32_t ssp_offset              : 8;
+		uint32_t reserved_15_7           : 9;
+		uint32_t trv_delay_value         : 7;
+#endif
+	} s;
+};
+
+enum ctu_can_fd_ssp_cfg_ssp_src {
+	SSP_SRC_MEAS_N_OFFSET       = 0x0,
+	SSP_SRC_NO_SSP              = 0x1,
+	SSP_SRC_OFFSET              = 0x2,
+};
+
+union ctu_can_fd_rx_fr_ctr {
+	uint32_t u32;
+	struct ctu_can_fd_rx_fr_ctr_s {
+  /* RX_FR_CTR */
+		uint32_t rx_fr_ctr_val          : 32;
+	} s;
+};
+
+union ctu_can_fd_tx_fr_ctr {
+	uint32_t u32;
+	struct ctu_can_fd_tx_fr_ctr_s {
+  /* TX_FR_CTR */
+		uint32_t tx_fr_ctr_val          : 32;
+	} s;
+};
+
+union ctu_can_fd_debug_register {
+	uint32_t u32;
+	struct ctu_can_fd_debug_register_s {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+  /* DEBUG_REGISTER */
+		uint32_t stuff_count             : 3;
+		uint32_t destuff_count           : 3;
+		uint32_t pc_arb                  : 1;
+		uint32_t pc_con                  : 1;
+		uint32_t pc_dat                  : 1;
+		uint32_t pc_stc                  : 1;
+		uint32_t pc_crc                  : 1;
+		uint32_t pc_crcd                 : 1;
+		uint32_t pc_ack                  : 1;
+		uint32_t pc_ackd                 : 1;
+		uint32_t pc_eof                  : 1;
+		uint32_t pc_int                  : 1;
+		uint32_t pc_susp                 : 1;
+		uint32_t pc_ovr                  : 1;
+		uint32_t pc_sof                  : 1;
+		uint32_t reserved_31_19         : 13;
+#else
+		uint32_t reserved_31_19         : 13;
+		uint32_t pc_sof                  : 1;
+		uint32_t pc_ovr                  : 1;
+		uint32_t pc_susp                 : 1;
+		uint32_t pc_int                  : 1;
+		uint32_t pc_eof                  : 1;
+		uint32_t pc_ackd                 : 1;
+		uint32_t pc_ack                  : 1;
+		uint32_t pc_crcd                 : 1;
+		uint32_t pc_crc                  : 1;
+		uint32_t pc_stc                  : 1;
+		uint32_t pc_dat                  : 1;
+		uint32_t pc_con                  : 1;
+		uint32_t pc_arb                  : 1;
+		uint32_t destuff_count           : 3;
+		uint32_t stuff_count             : 3;
+#endif
+	} s;
+};
+
+union ctu_can_fd_yolo_reg {
+	uint32_t u32;
+	struct ctu_can_fd_yolo_reg_s {
+  /* YOLO_REG */
+		uint32_t yolo_val               : 32;
+	} s;
+};
+
+union ctu_can_fd_timestamp_low {
+	uint32_t u32;
+	struct ctu_can_fd_timestamp_low_s {
+  /* TIMESTAMP_LOW */
+		uint32_t timestamp_low          : 32;
+	} s;
+};
+
+union ctu_can_fd_timestamp_high {
+	uint32_t u32;
+	struct ctu_can_fd_timestamp_high_s {
+  /* TIMESTAMP_HIGH */
+		uint32_t timestamp_high         : 32;
+	} s;
+};
+
+#endif
-- 
2.11.0

