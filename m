Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86A730615E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhA0Qy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhA0QyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 11:54:20 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBE5C06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:53:40 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id 7so2663506wrz.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bfdBxnBK5Jy768CPQ2cgYOreRpXRg/jTDJOtLuGW1LI=;
        b=FQZ1FpoQouMAagNKFUvGelvSrToB1Nis1IHxJYOI0K6lHIcrgqCtIoOLMFvickoBIk
         SUWGHersm/xHwzzwFZus0R4Onl6Wsnbam6WY0VPFwF6QwsTnXeOlUkCqZh56xnt2Enhs
         xNAx4ZwAm1mOdO6sS8GY75sxM7npRO0vPLE4HbN80D84D/YIDM906TGUQ1uX3fbU+9jn
         GRSEqOoVZ5XW4z2MjNj6h2i6n6RJhtr+/QQkTDzrp0fKLyEq6ZpOiFIG5GiUDxPk9wPl
         rnIoBjYIVt3X6zNYmkJzJpgWhUDXrgTmT7A+plG5SyuLNvZI3l6txFxQ1wpbbSolajC5
         yGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bfdBxnBK5Jy768CPQ2cgYOreRpXRg/jTDJOtLuGW1LI=;
        b=irEOtYVPYEj93sVzvVt2DIu2jL5UUm0nVAU368ivQD2/n60WwByQKZ4VC7fSCpExis
         VQvzZue+to5PtmqjgtyPu7Hxj0ZrYAmgvTTwY4vo+1ff0I6f2jtBB2ElPrijAcvnOaAz
         C2Z2EwGhjv4eUaTmMnCwRTITyelmUncBetykzq1ZIigyp9FfkguFxfFklXH86LGRbhhi
         8i2WdiWi5Y8SenU4OjRXLgeDsuc0qBf2ZmD9jUQiivVmR74IoGzqCuwPVmeNCIPTj6dI
         VHV++jR7qV4fOanmWkji+lmPd32lpzijYvbx9R2L9rS9G27GDr+HpCc/xnrT0iwslx1G
         iICQ==
X-Gm-Message-State: AOAM530ZDeB7yUmD8HB19PY2FtEMxzNJWuyYwwXaWMQfaPO4UaOvvWIq
        2GWvlPwf+O57dSEE6kDmOBkhnA==
X-Google-Smtp-Source: ABdhPJxhyA7y1eghNbiOTX4pmUF0pI2IzG3UA9/YNUCc8PhDuaxe43hJ9jX1jboHpYMEYs0b5eLqkg==
X-Received: by 2002:a5d:4e92:: with SMTP id e18mr12552625wru.66.1611766418867;
        Wed, 27 Jan 2021 08:53:38 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m82sm3077042wmf.29.2021.01.27.08.53.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Jan 2021 08:53:38 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, carl.yin@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 3/3] net: mhi: Add mbim proto
Date:   Wed, 27 Jan 2021 18:01:17 +0100
Message-Id: <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MBIM has initially been specified by USB-IF for transporting data (IP)
between a modem and a host over USB. However some modern modems also
support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet), it
allows to aggregate IP packets and to perform context multiplexing.

This change adds minimal MBIM support to MHI, allowing to support MBIM
only modems. MBIM being based on USB NCM, it reuses some helpers from
the USB stack, but the cdc-mbim driver is too USB coupled to be reused.

At some point it would be interesting to move on a factorized solution,
having a generic MBIM network lib or dedicated MBIM netlink virtual
interface support.

This code has been highly inspired from the mhi_mbim downstream driver
(Carl Yin <carl.yin@quectel.com>).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi/Makefile     |   2 +-
 drivers/net/mhi/mhi.h        |  39 ++++++++
 drivers/net/mhi/net.c        |  41 ++------
 drivers/net/mhi/proto_mbim.c | 220 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 270 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/mhi/mhi.h
 create mode 100644 drivers/net/mhi/proto_mbim.c

diff --git a/drivers/net/mhi/Makefile b/drivers/net/mhi/Makefile
index 0acf989..f71b9f8 100644
--- a/drivers/net/mhi/Makefile
+++ b/drivers/net/mhi/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_MHI_NET) += mhi_net.o
 
-mhi_net-y := net.o
+mhi_net-y := net.o proto_mbim.o
diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
new file mode 100644
index 0000000..e7f7246
--- /dev/null
+++ b/drivers/net/mhi/mhi.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* MHI Network driver - Network over MHI bus
+ *
+ * Copyright (C) 2021 Linaro Ltd <loic.poulain@linaro.org>
+ */
+
+struct mhi_net_stats {
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	u64_stats_t rx_errors;
+	u64_stats_t rx_dropped;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	u64_stats_t tx_errors;
+	u64_stats_t tx_dropped;
+	atomic_t rx_queued;
+	struct u64_stats_sync tx_syncp;
+	struct u64_stats_sync rx_syncp;
+};
+
+struct mhi_net_dev {
+	struct mhi_device *mdev;
+	struct net_device *ndev;
+	const struct mhi_device_info *info;
+	const struct mhi_net_proto *proto;
+	void *proto_data;
+	struct delayed_work rx_refill;
+	struct mhi_net_stats stats;
+	u32 rx_queue_sz;
+};
+
+struct mhi_net_proto {
+	int (*init)(struct mhi_net_dev *dev);
+	struct sk_buff * (*tx_fixup)(struct net_device *ndev, struct sk_buff *skb);
+	int (*rx_fixup)(struct net_device *ndev, struct sk_buff *skb);
+};
+
+extern const struct mhi_net_proto proto_mbim;
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index aa3a5e0..e8e458f 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -12,40 +12,12 @@
 #include <linux/skbuff.h>
 #include <linux/u64_stats_sync.h>
 
+#include "mhi.h"
+
 #define MHI_NET_MIN_MTU		ETH_MIN_MTU
 #define MHI_NET_MAX_MTU		0xffff
 #define MHI_NET_DEFAULT_MTU	0x4000
 
-struct mhi_net_stats {
-	u64_stats_t rx_packets;
-	u64_stats_t rx_bytes;
-	u64_stats_t rx_errors;
-	u64_stats_t rx_dropped;
-	u64_stats_t tx_packets;
-	u64_stats_t tx_bytes;
-	u64_stats_t tx_errors;
-	u64_stats_t tx_dropped;
-	atomic_t rx_queued;
-	struct u64_stats_sync tx_syncp;
-	struct u64_stats_sync rx_syncp;
-};
-
-struct mhi_net_dev {
-	struct mhi_device *mdev;
-	struct net_device *ndev;
-	const struct mhi_net_proto *proto;
-	void *proto_data;
-	struct delayed_work rx_refill;
-	struct mhi_net_stats stats;
-	u32 rx_queue_sz;
-};
-
-struct mhi_net_proto {
-	int (*init)(struct mhi_net_dev *dev);
-	struct sk_buff * (*tx_fixup)(struct net_device *ndev, struct sk_buff *skb);
-	int (*rx_fixup)(struct net_device *ndev, struct sk_buff *skb);
-};
-
 struct mhi_device_info {
 	const char *netname;
 	const struct mhi_net_proto *proto;
@@ -351,12 +323,19 @@ static const struct mhi_device_info mhi_swip0 = {
 	.netname = "mhi_swip%d",
 };
 
+static const struct mhi_device_info mhi_hwip0_mbim = {
+	.netname = "mhi_mbim%d",
+	.proto = &proto_mbim,
+};
+
 static const struct mhi_device_id mhi_net_id_table[] = {
 	/* Hardware accelerated data PATH (to modem IPA), protocol agnostic */
 	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)&mhi_hwip0 },
 	/* Software data PATH (to modem CPU) */
 	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)&mhi_swip0 },
-	{}
+	/* Hardware accelerated data PATH (to modem IPA), MBIM protocol */
+	{ .chan = "IP_HW0_MBIM", .driver_data = (kernel_ulong_t)&mhi_hwip0_mbim },
+	{ }
 };
 MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
 
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
new file mode 100644
index 0000000..b568078c
--- /dev/null
+++ b/drivers/net/mhi/proto_mbim.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* MHI Network driver - Network over MHI bus
+ *
+ * Copyright (C) 2021 Linaro Ltd <loic.poulain@linaro.org>
+ */
+
+#include <linux/ethtool.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/mii.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+#include <linux/usb/cdc.h>
+#include <linux/usb/usbnet.h>
+#include <linux/usb/cdc_ncm.h>
+
+#include "mhi.h"
+
+struct mbim_context {
+	u16 rx_seq;
+};
+
+static int mbim_rx_verify_nth16(struct sk_buff *skb)
+{
+	struct usb_cdc_ncm_nth16 *nth16;
+	int ret = -EINVAL;
+
+	if (skb->len < (sizeof(struct usb_cdc_ncm_nth16) +
+			sizeof(struct usb_cdc_ncm_ndp16))) {
+		goto error;
+	}
+
+	nth16 = (struct usb_cdc_ncm_nth16 *)skb->data;
+
+	if (nth16->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN))
+		goto error;
+
+	ret = le16_to_cpu(nth16->wNdpIndex);
+error:
+	return ret;
+}
+
+static int mbim_rx_verify_ndp16(struct sk_buff *skb, int ndpoffset)
+{
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	int ret = -EINVAL;
+
+	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb->len)
+		goto error;
+
+	ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
+
+	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN)
+		goto error;
+
+	ret = ((le16_to_cpu(ndp16->wLength) -
+					sizeof(struct usb_cdc_ncm_ndp16)) /
+					sizeof(struct usb_cdc_ncm_dpe16));
+	ret--; /* Last entry is always a NULL terminator */
+
+	if ((sizeof(struct usb_cdc_ncm_ndp16) +
+	     ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb->len) {
+		ret = -EINVAL;
+	}
+error:
+	return ret;
+}
+
+static int mbim_rx_fixup(struct net_device *ndev, struct sk_buff *skb)
+{
+	int ndpoffset;
+
+	/* Check NTB header signature and retrieve first NDP offset */
+	ndpoffset = mbim_rx_verify_nth16(skb);
+	if (ndpoffset < 0) {
+		netdev_err(ndev, "MBIM: Incorrect NTB header\n");
+		goto error;
+	}
+
+	/* Process each NDP */
+	while (1) {
+		struct usb_cdc_ncm_ndp16 *ndp16;
+		struct usb_cdc_ncm_dpe16 *dpe16;
+		int nframes, n;
+
+		/* Check NDP header and retrieve number of datagrams */
+		nframes = mbim_rx_verify_ndp16(skb, ndpoffset);
+		if (nframes < 0) {
+			netdev_err(ndev, "MBIM: Incorrect NDP16\n");
+			goto error;
+		}
+
+		/* Only support the IPS session 0 for now */
+		ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
+		switch (ndp16->dwSignature & cpu_to_le32(0x00ffffff)) {
+		case cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN):
+			break;
+		default:
+			netdev_err(ndev, "MBIM: Unsupported NDP type\n");
+			goto next_ndp;
+		}
+
+		/* de-aggregate and deliver IP packets */
+		dpe16 = ndp16->dpe16;
+		for (n = 0; n < nframes; n++, dpe16++) {
+			u16 dgram_offset = le16_to_cpu(dpe16->wDatagramIndex);
+			u16 dgram_len = le16_to_cpu(dpe16->wDatagramLength);
+			struct sk_buff *skbn;
+
+			if (!dgram_offset || !dgram_len)
+				break; /* null terminator */
+
+			skbn = netdev_alloc_skb(ndev, dgram_len);
+			if (!skbn)
+				continue;
+
+			skb_put(skbn, dgram_len);
+			memcpy(skbn->data, skb->data + dgram_offset, dgram_len);
+
+			switch (skbn->data[0] & 0xf0) {
+			case 0x40:
+				skbn->protocol = htons(ETH_P_IP);
+				break;
+			case 0x60:
+				skbn->protocol = htons(ETH_P_IPV6);
+				break;
+			default:
+				netdev_err(ndev, "MBIM: unknown protocol\n");
+				continue;
+			}
+
+			netif_rx(skbn);
+		}
+next_ndp:
+		/* Other NDP to process? */
+		ndpoffset = le16_to_cpu(ndp16->wNextNdpIndex);
+		if (!ndpoffset)
+			break;
+	}
+
+	/* free skb */
+	dev_consume_skb_any(skb);
+	return 0;
+error:
+	dev_kfree_skb_any(skb);
+	return -EIO;
+}
+
+struct mbim_tx_hdr {
+	struct usb_cdc_ncm_nth16 nth16;
+	struct usb_cdc_ncm_ndp16 ndp16;
+	struct usb_cdc_ncm_dpe16 dpe16[2];
+} __packed;
+
+static struct sk_buff *mbim_tx_fixup(struct net_device *ndev, struct sk_buff *skb)
+{
+	struct mbim_tx_hdr *mbim_hdr;
+	struct usb_cdc_ncm_nth16 *nth16;
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	unsigned int dgram_size = skb->len;
+	static int seq;
+
+	/* For now, this is a partial implementation of CDC MBIM, only one NDP
+	 * is sent, containing the IP packet (no aggregation).
+	 */
+
+	if (skb_headroom(skb) < sizeof(struct mbim_tx_hdr)) {
+		dev_kfree_skb_any(skb);
+		return NULL;
+	}
+
+	mbim_hdr = skb_push(skb, sizeof(struct mbim_tx_hdr));
+
+	/* Fill NTB header */
+	nth16 = &mbim_hdr->nth16;
+	nth16->dwSignature = cpu_to_le32(USB_CDC_NCM_NTH16_SIGN);
+	nth16->wHeaderLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16));
+	nth16->wSequence = cpu_to_le16(seq++);
+	nth16->wBlockLength = cpu_to_le16(skb->len);
+	nth16->wNdpIndex = cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16));
+
+	/* Fill the unique NDP */
+	ndp16 = &mbim_hdr->ndp16;
+	ndp16->dwSignature = cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN);
+	ndp16->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp16)
+					+ sizeof(struct usb_cdc_ncm_dpe16) * 2);
+	ndp16->wNextNdpIndex = 0;
+
+	/* Datagram follows the mbim header */
+	ndp16->dpe16[0].wDatagramIndex = cpu_to_le16(sizeof(struct mbim_tx_hdr));
+	ndp16->dpe16[0].wDatagramLength = cpu_to_le16(dgram_size);
+
+	/* null termination */
+	ndp16->dpe16[1].wDatagramIndex = 0;
+	ndp16->dpe16[1].wDatagramLength = 0;
+
+	return skb;
+}
+
+static int mbim_init(struct mhi_net_dev *mhi_netdev)
+{
+	struct net_device *ndev = mhi_netdev->ndev;
+
+	mhi_netdev->proto_data = devm_kzalloc(&ndev->dev,
+					      sizeof(struct mbim_context),
+					      GFP_KERNEL);
+	if (!mhi_netdev->proto_data)
+		return -ENOMEM;
+
+	ndev->needed_headroom = sizeof(struct mbim_tx_hdr);
+
+	return 0;
+}
+
+const struct mhi_net_proto proto_mbim = {
+	.init = mbim_init,
+	.rx_fixup = mbim_rx_fixup,
+	.tx_fixup = mbim_tx_fixup,
+};
-- 
2.7.4

