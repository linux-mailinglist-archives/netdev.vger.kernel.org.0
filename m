Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C91C352B2C
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhDBN6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 09:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhDBN6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 09:58:08 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D883C061794
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 06:57:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so4367759wml.2
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 06:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=URNQ5cQagOdArui4UMPt++GrfT0zQ3DLXwL0Fk7yHg0=;
        b=B6DLt17usIEbcjoPFZoabBcmV4ds+zxMo1wVeoXVk2wwX8xEZUEu+QBViRbZS+V7qw
         t74aIvfVk99P5nO2Nbwi+XYm9sIsdNJI7ojug7XNP8SPFFbhYAhVKKoT0zjT1AiXXxS5
         X9LoD7bf0H66dETrG5UMJ6Vu+xoFVpPXN+otR4VEKz88UEc3Lcsesty7zQRNdBP/L+vv
         NvgHTcWMPipcEDfh//RCytfq61CjPeRRxLOKcpRLX9sMb2IYsXTWLrb1BavTFZpcmXjd
         pf+Hn29XFoHxrvOlWpXaOc52KFqNz9PguY9Z94WlOTLngnYeUcaxguBiGkRX+1qvy2gB
         8YEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=URNQ5cQagOdArui4UMPt++GrfT0zQ3DLXwL0Fk7yHg0=;
        b=FB4+kp54FquzLjrV5yjGB9lmODGKCQpO+2b5Ko4PjZATD0daGNGifEsyRr+mJG3DPh
         FKy//c0GcBf3E7Lvi59NYcdUEZyY3KdsqZRjlCccdD+Ya/Ai/eBmvajuYERpqz4II24C
         trixY7KPKpZdwJjM4T7KMVZs0/gtefWnesT4pgBr3f81RQ3CmKX271MYY8fiaXmzjfqa
         qV6HCCF+pAzH62p/F6ughDFjSlRxU5WIB3QXJ0xq6IMKl43iP2b3vCrgiDcNAjoM00Rq
         8J0vKsAKoHXkMt6WTxQBTzOKdif48NzwGSGmBxG8kx2rTXI43VZ1TuFWVK+wI66lPKLN
         ISXw==
X-Gm-Message-State: AOAM533ng/al+TKib7++wfyTpLVBZy3YnDTEjyDKKf766zGR+sfema1Y
        EOIQDoeAMDhhmsF0UlKKPewsmg==
X-Google-Smtp-Source: ABdhPJy8ePMBoHn9kqmF9oqBnIjtjJGrIPpXMQabxbxjcmeSch2xpMKdIkjm6u5c5hnfoVlqbHL12A==
X-Received: by 2002:a1c:771a:: with SMTP id t26mr13044019wmi.60.1617371876714;
        Fri, 02 Apr 2021 06:57:56 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:a749:9ffe:22a4:1295])
        by smtp.gmail.com with ESMTPSA id k16sm2285661wro.11.2021.04.02.06.57.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Apr 2021 06:57:56 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     gregkh@linuxfoundation.org, kuba@kernel.org, davem@davemloft.net
Cc:     linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v8 2/2] net: Add Qcom WWAN control driver
Date:   Fri,  2 Apr 2021 16:06:37 +0200
Message-Id: <1617372397-13988-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617372397-13988-1-git-send-email-loic.poulain@linaro.org>
References: <1617372397-13988-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MHI WWWAN control driver allows MHI QCOM-based modems to expose
different modem control protocols/ports via the WWAN framework, so that
userspace modem tools or daemon (e.g. ModemManager) can control WWAN
config and state (APN config, SMS, provider selection...). A QCOM-based
modem can expose one or several of the following protocols:
- AT: Well known AT commands interactive protocol (microcom, minicom...)
- MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
- QMI: QCOM MSM/Modem Interface (libqmi, qmicli)
- QCDM: QCOM Modem diagnostic interface (libqcdm)
- FIREHOSE: XML-based protocol for Modem firmware management
        (qmi-firmware-update)

Note that this patch is mostly a rework of the earlier MHI UCI
tentative that was a generic interface for accessing MHI bus from
userspace. As suggested, this new version is WWAN specific and is
dedicated to only expose channels used for controlling a modem, and
for which related opensource userpace support exist.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: update copyright (2021)
 v3: Move driver to dedicated drivers/net/wwan directory
 v4: Rework to use wwan framework instead of self cdev management
 v5: Fix errors/typos in Kconfig
 v6: - Move to new wwan interface, No need dedicated call to wwan_dev_create
     - Cleanup code (remove legacy from mhi_uci, unused defines/vars...)
     - Remove useless write_lock mutex
     - Add mhi_wwan_wait_writable and mhi_wwan_wait_dlqueue_lock_irq helpers
     - Rework locking
     - Add MHI_WWAN_TX_FULL flag
     - Add support for NONBLOCK read/write
 v7: Fix change log (mixed up 1/2 and 2/2)
 v8: - Implement wwan_port_ops (instead of fops)
     - Remove all mhi wwan data obsolete members (kref, lock, waitqueues)
     - Add tracking of RX buffer budget
     - Use WWAN TX flow control function to stop TX when MHI queue is full

 drivers/net/wwan/Kconfig         |  14 +++
 drivers/net/wwan/Makefile        |   2 +
 drivers/net/wwan/mhi_wwan_ctrl.c | 253 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 269 insertions(+)
 create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 545fe54..ce0bbfb 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -19,4 +19,18 @@ config WWAN_CORE
 	  To compile this driver as a module, choose M here: the module will be
 	  called wwan.
 
+config MHI_WWAN_CTRL
+	tristate "MHI WWAN control driver for QCOM-based PCIe modems"
+	select WWAN_CORE
+	depends on MHI_BUS
+	help
+	  MHI WWAN CTRL allows QCOM-based PCIe modems to expose different modem
+	  control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
+	  and FIREHOSE. These protocols can be accessed directly from userspace
+	  (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
+	  libqcdm...).
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called mhi_wwan_ctrl
+
 endif # WWAN
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index 934590b..556cd90 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -5,3 +5,5 @@
 
 obj-$(CONFIG_WWAN_CORE) += wwan.o
 wwan-objs += wwan_core.o
+
+obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
new file mode 100644
index 0000000..f2fab23
--- /dev/null
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
+#include <linux/kernel.h>
+#include <linux/mhi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/wwan.h>
+
+/* MHI wwan flags */
+#define MHI_WWAN_DL_CAP		BIT(0)
+#define MHI_WWAN_UL_CAP		BIT(1)
+#define MHI_WWAN_STARTED	BIT(2)
+
+#define MHI_WWAN_MAX_MTU	0x8000
+
+struct mhi_wwan_dev {
+	/* Lower level is a mhi dev, upper level is a wwan port */
+	struct mhi_device *mhi_dev;
+	struct wwan_port *wwan_port;
+
+	/* State and capabilities */
+	unsigned long flags;
+	size_t mtu;
+
+	/* Protect against concurrent TX and TX-completion (bh) */
+	spinlock_t tx_lock;
+
+	struct work_struct rx_refill;
+	atomic_t rx_budget;
+};
+
+static bool mhi_wwan_ctrl_refill_needed(struct mhi_wwan_dev *mhiwwan)
+{
+	if (!test_bit(MHI_WWAN_STARTED, &mhiwwan->flags))
+		return false;
+
+	if (!test_bit(MHI_WWAN_DL_CAP, &mhiwwan->flags))
+		return false;
+
+	if (!atomic_read(&mhiwwan->rx_budget))
+		return false;
+
+	return true;
+}
+
+void __mhi_skb_destructor(struct sk_buff *skb)
+{
+	struct mhi_wwan_dev *mhiwwan = skb_shinfo(skb)->destructor_arg;
+
+	/* RX buffer has been consumed, increase the allowed budget */
+	atomic_inc(&mhiwwan->rx_budget);
+
+	if (mhi_wwan_ctrl_refill_needed(mhiwwan))
+		schedule_work(&mhiwwan->rx_refill);
+}
+
+static void mhi_wwan_ctrl_refill_work(struct work_struct *work)
+{
+	struct mhi_wwan_dev *mhiwwan = container_of(work, struct mhi_wwan_dev, rx_refill);
+	struct mhi_device *mhi_dev = mhiwwan->mhi_dev;
+
+	if (!mhi_wwan_ctrl_refill_needed(mhiwwan))
+		return;
+
+	while (atomic_read(&mhiwwan->rx_budget)) {
+		struct sk_buff *skb;
+
+		skb = alloc_skb(mhiwwan->mtu, GFP_KERNEL);
+		if (!skb)
+			break;
+
+		/* To prevent unlimited buffer allocation if nothing consumes
+		 * the RX buffers (passed to WWAN core), track their lifespan
+		 * to not allocate more than allowed budget.
+		 */
+		skb->destructor = __mhi_skb_destructor;
+		skb_shinfo(skb)->destructor_arg = mhiwwan;
+
+		if (mhi_queue_skb(mhi_dev, DMA_FROM_DEVICE, skb, mhiwwan->mtu, MHI_EOT)) {
+			dev_err(&mhi_dev->dev, "Failed to queue buffer\n");
+			kfree_skb(skb);
+			break;
+		}
+
+		atomic_dec(&mhiwwan->rx_budget);
+	}
+}
+
+static int mhi_wwan_ctrl_start(struct wwan_port *port)
+{
+	struct mhi_wwan_dev *mhiwwan = wwan_port_get_drvdata(port);
+	int ret, rx_budget;
+
+	/* Start mhi device's channel(s) */
+	ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev);
+	if (ret)
+		return ret;
+
+	set_bit(MHI_WWAN_STARTED, &mhiwwan->flags);
+
+	/* Don't allocate more buffers than MHI channel queue size */
+	rx_budget = mhi_get_free_desc_count(mhiwwan->mhi_dev, DMA_FROM_DEVICE);
+	atomic_set(&mhiwwan->rx_budget, rx_budget);
+
+	/* Add buffers to the MHI inbound queue */
+	mhi_wwan_ctrl_refill_work(&mhiwwan->rx_refill);
+
+	return 0;
+}
+
+static void mhi_wwan_ctrl_stop(struct wwan_port *port)
+{
+	struct mhi_wwan_dev *mhiwwan = wwan_port_get_drvdata(port);
+
+	clear_bit(MHI_WWAN_STARTED, &mhiwwan->flags);
+	mhi_unprepare_from_transfer(mhiwwan->mhi_dev);
+}
+
+static int mhi_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	struct mhi_wwan_dev *mhiwwan = wwan_port_get_drvdata(port);
+	int ret;
+
+	if (skb->len > mhiwwan->mtu)
+		return -EMSGSIZE;
+
+	if (!test_bit(MHI_WWAN_UL_CAP, &mhiwwan->flags))
+		return -ENOTSUPP;
+
+	spin_lock_bh(&mhiwwan->tx_lock);
+	ret = mhi_queue_skb(mhiwwan->mhi_dev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
+	if (mhi_queue_is_full(mhiwwan->mhi_dev, DMA_TO_DEVICE))
+		wwan_port_txoff(port);
+	spin_unlock_bh(&mhiwwan->tx_lock);
+
+	return ret;
+}
+
+static const struct wwan_port_ops wwan_pops = {
+	.start = mhi_wwan_ctrl_start,
+	.stop = mhi_wwan_ctrl_stop,
+	.tx = mhi_wwan_ctrl_tx,
+};
+
+static void mhi_ul_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct mhi_wwan_dev *mhiwwan = dev_get_drvdata(&mhi_dev->dev);
+	struct wwan_port *port = mhiwwan->wwan_port;
+	struct sk_buff *skb = mhi_result->buf_addr;
+
+	dev_dbg(&mhi_dev->dev, "%s: status: %d xfer_len: %zu\n", __func__,
+		mhi_result->transaction_status, mhi_result->bytes_xferd);
+
+	/* MHI core has done with the buffer, release it */
+	consume_skb(skb);
+
+	spin_lock_bh(&mhiwwan->tx_lock);
+	if (!mhi_queue_is_full(mhiwwan->mhi_dev, DMA_TO_DEVICE))
+		wwan_port_txon(port);
+	spin_unlock_bh(&mhiwwan->tx_lock);
+}
+
+static void mhi_dl_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct mhi_wwan_dev *mhiwwan = dev_get_drvdata(&mhi_dev->dev);
+	struct wwan_port *port = mhiwwan->wwan_port;
+	struct sk_buff *skb = mhi_result->buf_addr;
+
+	dev_dbg(&mhi_dev->dev, "%s: status: %d receive_len: %zu\n", __func__,
+		mhi_result->transaction_status, mhi_result->bytes_xferd);
+
+	if (mhi_result->transaction_status &&
+	    mhi_result->transaction_status != -EOVERFLOW) {
+		kfree_skb(skb);
+		return;
+	}
+
+	/* MHI core does not update skb->len, do it before forward */
+	skb_put(skb, mhi_result->bytes_xferd);
+	wwan_port_rx(port, skb);
+}
+
+static int mhi_wwan_ctrl_probe(struct mhi_device *mhi_dev,
+			       const struct mhi_device_id *id)
+{
+	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_wwan_dev *mhiwwan;
+
+	mhiwwan = kzalloc(sizeof(*mhiwwan), GFP_KERNEL);
+	if (!mhiwwan)
+		return -ENOMEM;
+
+	mhiwwan->mhi_dev = mhi_dev;
+	mhiwwan->mtu = MHI_WWAN_MAX_MTU;
+	INIT_WORK(&mhiwwan->rx_refill, mhi_wwan_ctrl_refill_work);
+	spin_lock_init(&mhiwwan->tx_lock);
+
+	if (mhi_dev->dl_chan)
+		set_bit(MHI_WWAN_DL_CAP, &mhiwwan->flags);
+	if (mhi_dev->ul_chan)
+		set_bit(MHI_WWAN_UL_CAP, &mhiwwan->flags);
+
+	dev_set_drvdata(&mhi_dev->dev, mhiwwan);
+
+	/* Register as a wwan port, id->driver_data contains wwan port type */
+	mhiwwan->wwan_port = wwan_create_port(&cntrl->mhi_dev->dev,
+					      id->driver_data,
+					      &wwan_pops, mhiwwan);
+	if (IS_ERR(mhiwwan->wwan_port)) {
+		kfree(mhiwwan);
+		return PTR_ERR(mhiwwan->wwan_port);
+	}
+
+	return 0;
+};
+
+static void mhi_wwan_ctrl_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_wwan_dev *mhiwwan = dev_get_drvdata(&mhi_dev->dev);
+
+	wwan_remove_port(mhiwwan->wwan_port);
+	cancel_work_sync(&mhiwwan->rx_refill);
+	kfree(mhiwwan);
+}
+
+static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
+	{ .chan = "DUN", .driver_data = WWAN_PORT_AT },
+	{ .chan = "MBIM", .driver_data = WWAN_PORT_MBIM },
+	{ .chan = "QMI", .driver_data = WWAN_PORT_QMI },
+	{ .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
+	{ .chan = "FIREHOSE", .driver_data = WWAN_PORT_FIREHOSE },
+	{},
+};
+MODULE_DEVICE_TABLE(mhi, mhi_wwan_ctrl_match_table);
+
+static struct mhi_driver mhi_wwan_ctrl_driver = {
+	.id_table = mhi_wwan_ctrl_match_table,
+	.remove = mhi_wwan_ctrl_remove,
+	.probe = mhi_wwan_ctrl_probe,
+	.ul_xfer_cb = mhi_ul_xfer_cb,
+	.dl_xfer_cb = mhi_dl_xfer_cb,
+	.driver = {
+		.name = "mhi_wwan_ctrl",
+	},
+};
+
+module_mhi_driver(mhi_wwan_ctrl_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MHI WWAN CTRL Driver");
+MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
-- 
2.7.4

