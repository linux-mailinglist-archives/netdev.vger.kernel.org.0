Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC030756
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfEaDyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:54:53 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:39687 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfEaDyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:13 -0400
Received: by mail-it1-f196.google.com with SMTP id j204so7724032ite.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aKNmhoCuw/eCc7wd53pD7Lrwug+Yfz2FeaJH4e2wTqA=;
        b=tDmMop7pS/Jx2ovpSkXLmS4AZMBK4I02veODFx6Oic0oGU/s5Gg6/sXkjoVn0icAns
         sEHHieQF3cTNrmm8f/nKb/X5cIL3RmqZjMZeYCrAUxeprVgKeRjjkog0rV/lCMWj5Vbu
         EPNj0WE3ZbAhA9e0pIWQ5FUwb69ayx+SU7Z6/OBnhY4a+umf+W7E+gFOp45E1dqXBCzW
         MVXEcxZHtYo+KdPV9qye+ZOTTNLD572iR5m3jCzkt55XZqU5h4fuGovqEJ4LeWFNHC/y
         Ch86qcwExxwZvIGs1K7pB9sygEm6WRZClhZyMWcH/t8AIkNN4/qV9I4CydGBrNKktH6H
         j1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKNmhoCuw/eCc7wd53pD7Lrwug+Yfz2FeaJH4e2wTqA=;
        b=cCG3PxEoTXlir6NLs9u6XWKUBY+/9I6+ZG9Mq1KiNcahbTrud928NvvxKkxQUzkc3r
         7o20Dt6vM0cWhoRSMrprVH5bTNCcPuobqIC9GSubnGgxHMIKkIgIV0sVFVE9vfpecGhl
         f+INgxq3luYF28MVVqBI7XUJuW1RfqW+j+z3vikKZmFRvH6n7Ym3ymKyYOW3t01esgMB
         H9EO+/7fUXUv6Xd+oT7q4Z+jtFjHdZx27pW3BY1toSuJUhBPI9o7NscB7hJbsixbpnmb
         LbkacU2UHuiO35KzBDgSS3hwai07CjANhmV6xDsZM74DU8J29cR0koxRo+hI+LGmyskn
         glyg==
X-Gm-Message-State: APjAAAXaUAEAcFpbQdrUn+hnghjt/xilxe6RfnNOho0hUYD3JcRu/MUr
        I5dSv+OdP+e+QvZDriKCWguLNw==
X-Google-Smtp-Source: APXvYqzNh5Gt73/UDcYSjOKcN0N786csRFOLEdAJmG94j2xowlQ5VKuNP+ftJScbqqkCiVapc7lkYQ==
X-Received: by 2002:a02:950a:: with SMTP id y10mr5357447jah.26.1559274851907;
        Thu, 30 May 2019 20:54:11 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:11 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 12/17] soc: qcom: ipa: IPA network device and microcontroller
Date:   Thu, 30 May 2019 22:53:43 -0500
Message-Id: <20190531035348.7194-13-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch includes the code that implements a Linux network device,
using one TX and one RX IPA endpoint.  It is used to implement the
network device representing the modem and its connection to wireless
networks.  There are only a few things that are really modem-specific
though, and they aren't clearly called out here.  Such distinctions
will be made clearer if we wish to support a network device for
anything other than the modem.

Sort of unrelated, this patch also includes the code supporting the
microcontroller CPU present on the IPA.  The microcontroller can be
used to implement special handling of packets, but at this time we
don't support that.  Still, it is a component that needs to be
initialized, and in the event of a crash we need to do some
synchronization between the AP and the microcontroller.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_netdev.c | 251 +++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_netdev.h |  24 ++++
 drivers/net/ipa/ipa_uc.c     | 208 +++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_uc.h     |  32 +++++
 4 files changed, 515 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_netdev.c
 create mode 100644 drivers/net/ipa/ipa_netdev.h
 create mode 100644 drivers/net/ipa/ipa_uc.c
 create mode 100644 drivers/net/ipa/ipa_uc.h

diff --git a/drivers/net/ipa/ipa_netdev.c b/drivers/net/ipa/ipa_netdev.c
new file mode 100644
index 000000000000..19c73c4da02b
--- /dev/null
+++ b/drivers/net/ipa/ipa_netdev.c
@@ -0,0 +1,251 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+
+/* Modem Transport Network Driver. */
+
+#include <linux/errno.h>
+#include <linux/if_arp.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/if_rmnet.h>
+
+#include "ipa.h"
+#include "ipa_data.h"
+#include "ipa_endpoint.h"
+#include "ipa_mem.h"
+#include "ipa_netdev.h"
+#include "ipa_qmi.h"
+
+#define IPA_NETDEV_NAME		"rmnet_ipa%d"
+
+#define TAILROOM		0	/* for padding by mux layer */
+
+#define IPA_NETDEV_TIMEOUT	10	/* seconds */
+
+/** struct ipa_priv - IPA network device private data */
+struct ipa_priv {
+	struct ipa_endpoint *tx_endpoint;
+	struct ipa_endpoint *rx_endpoint;
+};
+
+/** ipa_netdev_open() - Opens the modem network interface */
+static int ipa_netdev_open(struct net_device *netdev)
+{
+	struct ipa_priv *priv = netdev_priv(netdev);
+	int ret;
+
+	ret = ipa_endpoint_enable_one(priv->tx_endpoint);
+	if (ret)
+		return ret;
+	ret = ipa_endpoint_enable_one(priv->rx_endpoint);
+	if (ret)
+		goto err_disable_tx;
+
+	netif_start_queue(netdev);
+
+	return 0;
+
+err_disable_tx:
+	ipa_endpoint_disable_one(priv->tx_endpoint);
+
+	return ret;
+}
+
+/** ipa_netdev_stop() - Stops the modem network interface. */
+static int ipa_netdev_stop(struct net_device *netdev)
+{
+	struct ipa_priv *priv = netdev_priv(netdev);
+
+	netif_stop_queue(netdev);
+
+	ipa_endpoint_disable_one(priv->rx_endpoint);
+	ipa_endpoint_disable_one(priv->tx_endpoint);
+
+	return 0;
+}
+
+/** ipa_netdev_xmit() - Transmits an skb.
+ * @skb: skb to be transmitted
+ * @dev: network device
+ *
+ * Return codes:
+ * NETDEV_TX_OK: Success
+ * NETDEV_TX_BUSY: Error while transmitting the skb. Try again later
+ */
+static int ipa_netdev_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct net_device_stats *stats = &netdev->stats;
+	struct ipa_priv *priv = netdev_priv(netdev);
+	struct ipa_endpoint *endpoint;
+	u32 skb_len = skb->len;
+
+	if (!skb_len)
+		goto err_drop;
+
+	endpoint = priv->tx_endpoint;
+	if (endpoint->data->config.qmap && skb->protocol != htons(ETH_P_MAP))
+		goto err_drop;
+
+	if (ipa_endpoint_skb_tx(endpoint, skb))
+		return NETDEV_TX_BUSY;
+
+	stats->tx_packets++;
+	stats->tx_bytes += skb_len;
+
+	return NETDEV_TX_OK;
+
+err_drop:
+	dev_kfree_skb_any(skb);
+	stats->tx_dropped++;
+
+	return NETDEV_TX_OK;
+}
+
+void ipa_netdev_skb_rx(struct net_device *netdev, struct sk_buff *skb)
+{
+	struct net_device_stats *stats = &netdev->stats;
+
+	if (skb) {
+		skb->dev = netdev;
+		skb->protocol = htons(ETH_P_MAP);
+		stats->rx_packets++;
+		stats->rx_bytes += skb->len;
+
+		(void)netif_receive_skb(skb);
+	} else {
+		stats->rx_dropped++;
+	}
+}
+
+static const struct net_device_ops ipa_netdev_ops = {
+	.ndo_open	= ipa_netdev_open,
+	.ndo_stop	= ipa_netdev_stop,
+	.ndo_start_xmit	= ipa_netdev_xmit,
+};
+
+/** netdev_setup() - netdev setup function  */
+static void netdev_setup(struct net_device *netdev)
+{
+	netdev->netdev_ops = &ipa_netdev_ops;
+	ether_setup(netdev);
+	/* No header ops (override value set by ether_setup()) */
+	netdev->header_ops = NULL;
+	netdev->type = ARPHRD_RAWIP;
+	netdev->hard_header_len = 0;
+	netdev->max_mtu = IPA_MTU;
+	netdev->mtu = netdev->max_mtu;
+	netdev->addr_len = 0;
+	netdev->flags &= ~(IFF_BROADCAST | IFF_MULTICAST);
+	/* The endpoint is configured for QMAP */
+	netdev->needed_headroom = sizeof(struct rmnet_map_header);
+	netdev->needed_tailroom = TAILROOM;
+	netdev->watchdog_timeo = IPA_NETDEV_TIMEOUT * HZ;
+	netdev->hw_features = NETIF_F_SG;
+}
+
+/** ipa_netdev_suspend() - suspend callback for runtime_pm
+ * @dev: pointer to device
+ *
+ * This callback will be invoked by the runtime_pm framework when an AP suspend
+ * operation is invoked, usually by pressing a suspend button.
+ *
+ * Returns -EAGAIN to runtime_pm framework in case there are pending packets
+ * in the Tx queue. This will postpone the suspend operation until all the
+ * pending packets will be transmitted.
+ *
+ * In case there are no packets to send, releases the WWAN0_PROD entity.
+ * As an outcome, the number of IPA active clients should be decremented
+ * until IPA clocks can be gated.
+ */
+void ipa_netdev_suspend(struct net_device *netdev)
+{
+	struct ipa_priv *priv = netdev_priv(netdev);
+
+	netif_stop_queue(netdev);
+
+	ipa_endpoint_suspend(priv->tx_endpoint);
+	ipa_endpoint_suspend(priv->rx_endpoint);
+}
+
+/** ipa_netdev_resume() - resume callback for runtime_pm
+ * @dev: pointer to device
+ *
+ * This callback will be invoked by the runtime_pm framework when an AP resume
+ * operation is invoked.
+ *
+ * Enables the network interface queue and returns success to the
+ * runtime_pm framework.
+ */
+void ipa_netdev_resume(struct net_device *netdev)
+{
+	struct ipa_priv *priv = netdev_priv(netdev);
+
+	ipa_endpoint_resume(priv->rx_endpoint);
+	ipa_endpoint_resume(priv->tx_endpoint);
+
+	netif_wake_queue(netdev);
+}
+
+struct net_device *ipa_netdev_setup(struct ipa *ipa,
+				    struct ipa_endpoint *rx_endpoint,
+				    struct ipa_endpoint *tx_endpoint)
+{
+	struct net_device *netdev;
+	struct ipa_priv *priv;
+	int ret;
+
+	/* Zero modem shared memory before we begin */
+	ret = ipa_smem_zero_modem(ipa);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Start QMI communication with the modem */
+	ret = ipa_qmi_setup(ipa);
+	if (ret)
+		return ERR_PTR(ret);
+
+	netdev = alloc_netdev(sizeof(struct ipa_priv), IPA_NETDEV_NAME,
+			      NET_NAME_UNKNOWN, netdev_setup);
+	if (!netdev) {
+		ret = -ENOMEM;
+		goto err_qmi_exit;
+	}
+
+	rx_endpoint->netdev = netdev;
+	tx_endpoint->netdev = netdev;
+
+	priv = netdev_priv(netdev);
+	priv->tx_endpoint = tx_endpoint;
+	priv->rx_endpoint = rx_endpoint;
+
+	ret = register_netdev(netdev);
+	if (ret)
+		goto err_free_netdev;
+
+	return netdev;
+
+err_free_netdev:
+	free_netdev(netdev);
+err_qmi_exit:
+	ipa_qmi_teardown(ipa);
+
+	return ERR_PTR(ret);
+}
+
+void ipa_netdev_teardown(struct net_device *netdev)
+{
+	struct ipa_priv *priv = netdev_priv(netdev);
+	struct ipa *ipa = priv->tx_endpoint->ipa;
+
+	if (!netif_queue_stopped(netdev))
+		(void)ipa_netdev_stop(netdev);
+
+	unregister_netdev(netdev);
+
+	free_netdev(netdev);
+
+	ipa_qmi_teardown(ipa);
+}
diff --git a/drivers/net/ipa/ipa_netdev.h b/drivers/net/ipa/ipa_netdev.h
new file mode 100644
index 000000000000..8ab1e8ea0b4a
--- /dev/null
+++ b/drivers/net/ipa/ipa_netdev.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _IPA_NETDEV_H_
+#define _IPA_NETDEV_H_
+
+struct ipa;
+struct ipa_endpoint;
+struct net_device;
+struct sk_buff;
+
+struct net_device *ipa_netdev_setup(struct ipa *ipa,
+				    struct ipa_endpoint *rx_endpoint,
+				    struct ipa_endpoint *tx_endpoint);
+void ipa_netdev_teardown(struct net_device *netdev);
+
+void ipa_netdev_skb_rx(struct net_device *netdev, struct sk_buff *skb);
+
+void ipa_netdev_suspend(struct net_device *netdev);
+void ipa_netdev_resume(struct net_device *netdev);
+
+#endif /* _IPA_NETDEV_H_ */
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
new file mode 100644
index 000000000000..57256d1c3b90
--- /dev/null
+++ b/drivers/net/ipa/ipa_uc.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include "ipa.h"
+#include "ipa_clock.h"
+#include "ipa_uc.h"
+
+/**
+ * DOC:  The IPA embedded microcontroller
+ *
+ * The IPA incorporates a microcontroller that is able to do some additional
+ * handling/offloading of network activity.  The current code makes
+ * essentially no use of the microcontroller, but it still requires some
+ * initialization.  It needs to be notified in the event the AP crashes.
+ *
+ * The microcontroller can generate two interrupts to the AP.  One interrupt
+ * is used to indicate that a response to a request from the AP is available.
+ * The other is used to notify the AP of the occurrence of an event.  In
+ * addition, the AP can interrupt the microcontroller by writing a register.
+ *
+ * A 128 byte block of structured memory within the IPA SRAM is used together
+ * with these interrupts to implement the communication interface between the
+ * AP and the IPA microcontroller.  Each side writes data to the shared area
+ * before interrupting its peer, which will read the written data in response
+ * to the interrupt.  Some information found in the shared area is currently
+ * unused.  All remaining space in the shared area is reserved, and must not
+ * be read or written by the AP.
+ */
+/* Supports hardware interface version 0x2000 */
+
+/* Offset relative to the base of the IPA shared address space of the
+ * shared region used for communication with the microcontroller.  The
+ * region is 128 bytes in size, but only the first 40 bytes are used.
+ */
+#define IPA_SMEM_UC_OFFSET	0x0000
+
+/* Delay to allow a the microcontroller to save state when crashing */
+#define IPA_SEND_DELAY		100	/* microseconds */
+
+/**
+ * struct ipa_uc_shared_area - AP/microcontroller shared memory area
+ * @command:		command code (AP->microcontroller)
+ * @command_param:	low 32 bits of command parameter (AP->microcontroller)
+ * @command_param_hi:	high 32 bits of command parameter (AP->microcontroller)
+ *
+ * @response:		response code (microcontroller->AP)
+ * @response_param:	response parameter (microcontroller->AP)
+ *
+ * @event:		event code (microcontroller->AP)
+ * @event_param:	event parameter (microcontroller->AP)
+ *
+ * @first_error_address: address of first error-source on SNOC
+ * @hw_state:		state of hardware (including error type information)
+ * @warning_counter:	counter of non-fatal hardware errors
+ * @interface_version:	hardware-reported interface version
+ */
+struct ipa_uc_shared_area {
+	u8 command;		/* enum ipa_uc_command */
+	u8 reserved0[3];
+	__le32 command_param;
+	__le32 command_param_hi;
+	u8 response;		/* enum ipa_uc_response */
+	u8 reserved1[3];
+	__le32 response_param;
+	u8 event;		/* enum ipa_uc_event */
+	u8 reserved2[3];
+
+	__le32 event_param;
+	__le32 first_error_address;
+	u8 hw_state;
+	u8 warning_counter;
+	__le16 reserved3;
+	__le16 interface_version;
+	__le16 reserved4;
+};
+
+/** enum ipa_uc_command - commands from the AP to the microcontroller */
+enum ipa_uc_command {
+	IPA_UC_COMMAND_NO_OP		= 0,
+	IPA_UC_COMMAND_UPDATE_FLAGS	= 1,
+	IPA_UC_COMMAND_DEBUG_RUN_TEST	= 2,
+	IPA_UC_COMMAND_DEBUG_GET_INFO	= 3,
+	IPA_UC_COMMAND_ERR_FATAL	= 4,
+	IPA_UC_COMMAND_CLK_GATE		= 5,
+	IPA_UC_COMMAND_CLK_UNGATE	= 6,
+	IPA_UC_COMMAND_MEMCPY		= 7,
+	IPA_UC_COMMAND_RESET_PIPE	= 8,
+	IPA_UC_COMMAND_REG_WRITE	= 9,
+	IPA_UC_COMMAND_GSI_CH_EMPTY	= 10,
+};
+
+/** enum ipa_uc_response - microcontroller response codes */
+enum ipa_uc_response {
+	IPA_UC_RESPONSE_NO_OP		= 0,
+	IPA_UC_RESPONSE_INIT_COMPLETED	= 1,
+	IPA_UC_RESPONSE_CMD_COMPLETED	= 2,
+	IPA_UC_RESPONSE_DEBUG_GET_INFO	= 3,
+};
+
+/** enum ipa_uc_event - common cpu events reported by the microcontroller */
+enum ipa_uc_event {
+	IPA_UC_EVENT_NO_OP     = 0,
+	IPA_UC_EVENT_ERROR     = 1,
+	IPA_UC_EVENT_LOG_INFO  = 2,
+};
+
+/* Microcontroller event IPA interrupt handler */
+static void ipa_uc_event_handler(struct ipa *ipa,
+				 enum ipa_interrupt_id interrupt_id)
+{
+	struct ipa_uc_shared_area *shared;
+
+	shared = ipa->shared_virt + IPA_SMEM_UC_OFFSET;
+	dev_err(&ipa->pdev->dev, "unsupported microcontroller event %hhu\n",
+		shared->event);
+	WARN_ON(shared->event == IPA_UC_EVENT_ERROR);
+}
+
+/* Microcontroller response IPA interrupt handler */
+static void ipa_uc_response_hdlr(struct ipa *ipa,
+				 enum ipa_interrupt_id interrupt_id)
+{
+	struct ipa_uc_shared_area *shared;
+
+	/* An INIT_COMPLETED response message is sent to the AP by the
+	 * microcontroller when it is operational.  Other than this, the AP
+	 * should only receive responses from the microntroller when it has
+	 * sent it a request message.
+	 *
+	 * We can drop the clock reference taken in ipa_uc_init() once we
+	 * know the microcontroller has finished its initialization.
+	 */
+	shared = ipa->shared_virt + IPA_SMEM_UC_OFFSET;
+	switch (shared->response) {
+	case IPA_UC_RESPONSE_INIT_COMPLETED:
+		ipa->uc_loaded = 1;
+		ipa_clock_put(ipa->clock);
+		break;
+	default:
+		dev_warn(&ipa->pdev->dev,
+			 "unsupported microcontroller response %hhu\n",
+			 shared->response);
+		break;
+	}
+}
+
+/* ipa_uc_setup() - Set up the microcontroller */
+void ipa_uc_setup(struct ipa *ipa)
+{
+	/* The microcontroller needs the IPA clock running until it has
+	 * completed its initialization.  It signals this by sending an
+	 * INIT_COMPLETED response message to the AP.  This could occur after
+	 * we have finished doing the rest of the IPA initialization, so we
+	 * need to take an extra "proxy" reference, and hold it until we've
+	 * received that signal.  (This reference is dropped in
+	 * ipa_uc_response_hdlr(), above.)
+	 */
+	ipa_clock_get(ipa->clock);
+
+	ipa->uc_loaded = 0;
+	ipa_interrupt_add(ipa->interrupt, IPA_INTERRUPT_UC_0,
+			  ipa_uc_event_handler);
+	ipa_interrupt_add(ipa->interrupt, IPA_INTERRUPT_UC_1,
+			  ipa_uc_response_hdlr);
+}
+
+/* Inverse of ipa_uc_setup() */
+void ipa_uc_teardown(struct ipa *ipa)
+{
+	ipa_interrupt_remove(ipa->interrupt, IPA_INTERRUPT_UC_1);
+	ipa_interrupt_remove(ipa->interrupt, IPA_INTERRUPT_UC_0);
+	if (!ipa->uc_loaded)
+		ipa_clock_put(ipa->clock);
+}
+
+/* Send a command to the microcontroller */
+static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
+{
+	struct ipa_uc_shared_area *shared;
+
+	shared = ipa->shared_virt + IPA_SMEM_UC_OFFSET;
+	shared->command = command;
+	shared->command_param = cpu_to_le32(command_param);
+	shared->command_param_hi = 0;
+	shared->response = 0;
+	shared->response_param = 0;
+
+	iowrite32(1, ipa->reg_virt + IPA_REG_IRQ_UC_OFFSET);
+}
+
+/* Tell the microcontroller the AP is shutting down */
+void ipa_uc_panic_notifier(struct ipa *ipa)
+{
+	if (!ipa->uc_loaded)
+		return;
+
+	send_uc_command(ipa, IPA_UC_COMMAND_ERR_FATAL, 0);
+
+	/* give uc enough time to save state */
+	udelay(IPA_SEND_DELAY);
+}
diff --git a/drivers/net/ipa/ipa_uc.h b/drivers/net/ipa/ipa_uc.h
new file mode 100644
index 000000000000..c258cb6e1161
--- /dev/null
+++ b/drivers/net/ipa/ipa_uc.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+#ifndef _IPA_UC_H_
+#define _IPA_UC_H_
+
+struct ipa;
+
+/**
+ * ipa_uc_setup() - set up the IPA microcontroller subsystem
+ * @ipa:	IPA pointer
+ */
+void ipa_uc_setup(struct ipa *ipa);
+
+/**
+ * ipa_uc_teardown() - inverse of ipa_uc_setup()
+ * @ipa:	IPA pointer
+ */
+void ipa_uc_teardown(struct ipa *ipa);
+
+/**
+ * ipa_uc_panic_notifier()
+ * @ipa:	IPA pointer
+ *
+ * Notifier function called when the system crashes, to inform the
+ * microcontroller of the event.
+ */
+void ipa_uc_panic_notifier(struct ipa *ipa);
+
+#endif /* _IPA_UC_H_ */
-- 
2.20.1

