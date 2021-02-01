Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BEA30B1C9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhBAU6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhBAU6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:58:46 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C85C0613D6
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 12:58:05 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m1so471951wml.2
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 12:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=htzqG19itchr0FC+l5UAplmrUGBTQ6p8V+c9XdRZqME=;
        b=mJgdG6a/T1rI5s53QYkbeBYy1ERT7fUHP8dkofXv+ookyfeLPAED9hlD4GaR0qyLLf
         VVz6smXyTIpxmpiDkL30Dm2/HXSaKDdePJxzm1XKLXHZg1zrgzAttFUBiU8sFPAOReXx
         Aof3Qt1K2E69FpRHgCoM3F2JlEgcKKYPst795KnZAsknH93QRgZacy/CjSt9Dmya6VZr
         InItjYPUpiqRObVT3cQ1hSsUK3mlopoItNd2irwvVYGFK9aGcsLH6XXcwIn9WEGA5luv
         i1Lvt2W4szCzmK6ocJ/kQ2g0hu35VrNGwqjPqpTW76APaqmQOA4ndz/S2A/9cLo0fk3M
         9DxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=htzqG19itchr0FC+l5UAplmrUGBTQ6p8V+c9XdRZqME=;
        b=rz1cwVTCCQs0if1N6Do6aP9j6mCPSrQ/a8ZojKsp88OsGrAwslsZB2mQ7uYP0gKkmv
         orh2Cgh33ofYx7teC54HCNNLb9ANd8H9WqDU7xZWKBw7uSq1j5L7tAls6Y9sVIdmzV7T
         XewrOEBrOcLrecqRMqDOmL8D8kjZZ19aGY8DJRQv/UTc/Y38UefxBSPp/BrMZlHP1yGk
         +0gjxpPQtf5qZQwGwSjnlDmVz01P8fTOl8vC72ePus6Zem1m/yztNMfrSaSK9HI5mGFp
         zSB7ySgIfnsv8UxujY8rtBucgsNDccKwYxX45b6CGF/scVZpLoN56XWwom1yjO+GXsic
         3H3w==
X-Gm-Message-State: AOAM532+UOI5atQX0FEdcnrYAgDLJtJY/maWi9rUj5zZE0AWaMFR3FOi
        nTxMF1PQEQKkwB7iFPbQSN+RWw==
X-Google-Smtp-Source: ABdhPJxbXvVPC7HRu6zRyRESuGes2HXXgOZ4QArUe0ZwCB/SVpZx+vbeDNZNmAlQbU7QIO6W5AxAOw==
X-Received: by 2002:a1c:4c07:: with SMTP id z7mr591327wmf.129.1612213084493;
        Mon, 01 Feb 2021 12:58:04 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id b7sm27894226wru.33.2021.02.01.12.58.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 12:58:04 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     bjorn@mork.no, dcbw@redhat.com, netdev@vger.kernel.org,
        carl.yin@quectel.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 3/3] net: mhi: Add mbim proto
Date:   Mon,  1 Feb 2021 22:05:42 +0100
Message-Id: <1612213542-17257-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612213542-17257-1-git-send-email-loic.poulain@linaro.org>
References: <1612213542-17257-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=kuba@kernel.org davem@davemloft.net
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MBIM has initially been specified by USB-IF for transporting data (IP)
between a modem and a host over USB. However some modern modems also
support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet), it
allows to aggregate IP packets and to perform context multiplexing.

This change adds minimal MBIM data transport support to MHI, allowing
to support MBIM only modems. MBIM being based on USB NCM, it reuses
and copy some helpers/functions from the USB stack (cdc-ncm, cdc-mbim).

Note that is a subset of the CDC-MBIM specification, supporting only
transport of network data (IP), there is no support for DSS. Moreover
the multi-session (for multi-pdn) is not supported in this initial
version, but will be added latter, and aligned with the cdc-mbim
solution (VLAN tags).

This code has been inspired from the mhi_mbim downstream implementation
(Carl Yin <carl.yin@quectel.com>).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: - Check nth size/sequence in nth16_verify
     - Add netif_dbg message for verbose error
     - Add inline comment for MHI MBIM limitation (no DSS)
     - Fix copyright issue
     - Reword commit message

 drivers/net/mhi/Makefile     |   2 +-
 drivers/net/mhi/mhi.h        |  39 +++++++
 drivers/net/mhi/net.c        |  40 ++-----
 drivers/net/mhi/proto_mbim.c | 270 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 320 insertions(+), 31 deletions(-)
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
index 0000000..94797b5
--- /dev/null
+++ b/drivers/net/mhi/mhi.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
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
+	int msg_enable;
+	struct delayed_work rx_refill;
+	struct mhi_net_stats stats;
+	u32 rx_queue_sz;
+};
+
+struct mhi_net_proto {
+	int (*init)(struct mhi_net_dev *mhi_netdev);
+	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+	int (*rx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+};
+
+extern const struct mhi_net_proto proto_mbim;
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 34d4bcf..33643572 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -12,39 +12,12 @@
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
-	int (*init)(struct mhi_net_dev *mhi_netdev);
-	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
-	int (*rx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
-};
-
 struct mhi_device_info {
 	const char *netname;
 	const struct mhi_net_proto *proto;
@@ -348,12 +321,19 @@ static const struct mhi_device_info mhi_swip0 = {
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
index 0000000..a8499aa
--- /dev/null
+++ b/drivers/net/mhi/proto_mbim.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* MHI Network driver - Network over MHI bus
+ *
+ * Copyright (C) 2021 Linaro Ltd <loic.poulain@linaro.org>
+ *
+ * This driver copy some code from cdc_ncm, which is:
+ * Copyright (C) ST-Ericsson 2010-2012
+ * and cdc_mbim, which is:
+ * Copyright (c) 2012  Smith Micro Software, Inc.
+ * Copyright (c) 2012  Bjørn Mork <bjorn@mork.no>
+ *
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
+#define MHI_MBIM_MAX_BLOCK_SZ (31 * 1024)
+
+struct mbim_context {
+	u16 rx_seq;
+	u16 tx_seq;
+};
+
+static int mbim_rx_verify_nth16(struct sk_buff *skb)
+{
+	struct mhi_net_dev *dev = netdev_priv(skb->dev);
+	struct mbim_context *ctx = dev->proto_data;
+	struct usb_cdc_ncm_nth16 *nth16;
+	int ret = -EINVAL;
+	int len;
+
+	if (skb->len < (sizeof(struct usb_cdc_ncm_nth16) +
+			sizeof(struct usb_cdc_ncm_ndp16))) {
+		netif_dbg(dev, rx_err, dev->ndev, "frame too short\n");
+		goto error;
+	}
+
+	nth16 = (struct usb_cdc_ncm_nth16 *)skb->data;
+
+	if (nth16->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN)) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "invalid NTH16 signature <%#010x>\n",
+			  le32_to_cpu(nth16->dwSignature));
+		goto error;
+	}
+
+	/* No limit on the block length, except the size of the data pkt */
+	len = le16_to_cpu(nth16->wBlockLength);
+	if (len > skb->len) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "NTB does not fit into the skb %u/%u\n", len,
+			  skb->len);
+		goto error;
+	}
+
+	if ((ctx->rx_seq + 1) != le16_to_cpu(nth16->wSequence) &&
+	    (ctx->rx_seq || le16_to_cpu(nth16->wSequence)) &&
+	    !((ctx->rx_seq == 0xffff) && !le16_to_cpu(nth16->wSequence))) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "sequence number glitch prev=%d curr=%d\n",
+			  ctx->rx_seq, le16_to_cpu(nth16->wSequence));
+	}
+	ctx->rx_seq = le16_to_cpu(nth16->wSequence);
+
+	ret = le16_to_cpu(nth16->wNdpIndex);
+error:
+	return ret;
+}
+
+static int mbim_rx_verify_ndp16(struct sk_buff *skb, int ndpoffset)
+{
+	struct mhi_net_dev *dev = netdev_priv(skb->dev);
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	int ret = -EINVAL;
+
+	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb->len) {
+		netif_dbg(dev, rx_err, dev->ndev, "invalid NDP offset  <%u>\n",
+			  ndpoffset);
+		goto error;
+	}
+
+	ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
+
+	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN) {
+		netif_dbg(dev, rx_err, dev->ndev, "invalid DPT16 length <%u>\n",
+			  le16_to_cpu(ndp16->wLength));
+		goto error;
+	}
+
+	ret = ((le16_to_cpu(ndp16->wLength) -
+					sizeof(struct usb_cdc_ncm_ndp16)) /
+					sizeof(struct usb_cdc_ncm_dpe16));
+	ret--; /* Last entry is always a NULL terminator */
+
+	if ((sizeof(struct usb_cdc_ncm_ndp16) +
+	     ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb->len) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "Invalid nframes = %d\n", ret);
+		ret = -EINVAL;
+	}
+
+error:
+	return ret;
+}
+
+static int mbim_rx_fixup(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
+{
+	struct net_device *ndev = mhi_netdev->ndev;
+	int ndpoffset;
+
+	/* Check NTB header and retrieve first NDP offset */
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
+		/* Only support the IPS session 0 for now (only one PDN context)
+		 * There is no Data Service Stream (DSS) in MHI context.
+		 */
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
+static struct sk_buff *mbim_tx_fixup(struct mhi_net_dev *mhi_netdev,
+				     struct sk_buff *skb)
+{
+	struct mbim_context *ctx = mhi_netdev->proto_data;
+	unsigned int dgram_size = skb->len;
+	struct usb_cdc_ncm_nth16 *nth16;
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	struct mbim_tx_hdr *mbim_hdr;
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
+	nth16->wSequence = cpu_to_le16(ctx->tx_seq++);
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

