Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B7A312B46
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBHHyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhBHHx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:53:27 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E833C061794
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 23:52:42 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id m13so15877828wro.12
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 23:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pi4MssJ6YJrj36/gkn4Ctiu4FJ86Z6+OUNiagyKuv1Y=;
        b=ll7DOQs7Ff4Y+oejWX3QBILA027sgIzDo6fiR0AaL+khk7CDSYEvvSB+miGIlTmTFU
         Ea9r+rhzJaNcUoY6+TnPPZOuJx8pIOO4qzlgKSMYUW2+uLjRTbjUlI+bv0WjJuQqKmAA
         N8sVl3tMTA8mhPWdWBHskme2DKG9kOuM2KFNJM1eMqzv6ANyZkmuGlB2xCM2fEvuY4yr
         kncUtDNqj4QGTlVVql6u2Ba725+jGAXd91r7lULQgJoOaZqjOkpf0IHAIZV1Fu0brsPc
         ncc8ou/o1WCGjOoqd//A1dffik7kaAW18HFoOi1sOOaujtVf8tGp2oT7tzrUFHk2todE
         08PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pi4MssJ6YJrj36/gkn4Ctiu4FJ86Z6+OUNiagyKuv1Y=;
        b=HZCAy0/S9hCdYLrDB9ZDXe9KIy0IR0GLiWkuPVxLFUc0FBAN3RXOB9GqMErfGHv1Uw
         ywBE97mLvfTRYNzx1kNyt2XqfIseKXGp0HdhSrSeoWiVxLt0j0IYD7xLd/Mn+Ask4GUw
         Ttg+F5rH7teYFYxB1swUqDg74NSfDPzuYY3REHlAiNndarW3rRIXZjNIEsoPbfXVUouY
         rUYuq8eY1OgCvY9ocqDaIJ9oT49eKa1KB6tlbw48rz2nDepTY/FykIO99zuC6nci9wSO
         5E41PLRKB1oPVbvy4C6D3yUIjMvGNc8QvQD7M82KCT+1A9KPQ83BL0Oryw8UkvrlpQSv
         gsUA==
X-Gm-Message-State: AOAM533uaZTYS5Ydu3Zn+BdkRVxmCRZ/p0xqJrDV+/DWbUHGTtEMQcfn
        dBEXXJjJsXgC4alHc1ZoWjqtCy6HaMewgQ==
X-Google-Smtp-Source: ABdhPJyUkcgtCS4i0MCV0ogEOdIoClxLlr3mVFohrwLmmWzwuFVt/yk+of5m7/WPaWFWz6ly6v8C+w==
X-Received: by 2002:adf:ecc1:: with SMTP id s1mr19275307wro.146.1612770760661;
        Sun, 07 Feb 2021 23:52:40 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:2c22:849b:ef6a:c4b9])
        by smtp.gmail.com with ESMTPSA id g16sm18784952wmi.30.2021.02.07.23.52.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Feb 2021 23:52:40 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 5/5] net: mhi: Add mbim proto
Date:   Mon,  8 Feb 2021 09:00:37 +0100
Message-Id: <1612771237-3782-6-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
References: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
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
 drivers/net/mhi/Makefile     |   2 +-
 drivers/net/mhi/mhi.h        |   3 +
 drivers/net/mhi/net.c        |   7 ++
 drivers/net/mhi/proto_mbim.c | 293 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 304 insertions(+), 1 deletion(-)
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
index 82210e0..12e7407 100644
--- a/drivers/net/mhi/mhi.h
+++ b/drivers/net/mhi/mhi.h
@@ -28,6 +28,7 @@ struct mhi_net_dev {
 	struct delayed_work rx_refill;
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
+	int msg_enable;
 };
 
 struct mhi_net_proto {
@@ -35,3 +36,5 @@ struct mhi_net_proto {
 	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
 	void (*rx)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
 };
+
+extern const struct mhi_net_proto proto_mbim;
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 44cbfb3..f599608 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -373,11 +373,18 @@ static const struct mhi_device_info mhi_swip0 = {
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
+	/* Hardware accelerated data PATH (to modem IPA), MBIM protocol */
+	{ .chan = "IP_HW0_MBIM", .driver_data = (kernel_ulong_t)&mhi_hwip0_mbim },
 	{}
 };
 MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
new file mode 100644
index 0000000..fb9a4f1
--- /dev/null
+++ b/drivers/net/mhi/proto_mbim.c
@@ -0,0 +1,293 @@
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
+#define MBIM_NDP16_SIGN_MASK cpu_to_le32(0x00ffffff)
+
+struct mbim_context {
+	u16 rx_seq;
+	u16 tx_seq;
+};
+
+static void __mbim_length_errors_inc(struct mhi_net_dev *dev)
+{
+	u64_stats_update_begin(&dev->stats.rx_syncp);
+	u64_stats_inc(&dev->stats.rx_length_errors);
+	u64_stats_update_end(&dev->stats.rx_syncp);
+}
+
+static void __mbim_errors_inc(struct mhi_net_dev *dev)
+{
+	u64_stats_update_begin(&dev->stats.rx_syncp);
+	u64_stats_inc(&dev->stats.rx_errors);
+	u64_stats_update_end(&dev->stats.rx_syncp);
+}
+
+static int mbim_rx_verify_nth16(struct sk_buff *skb)
+{
+	struct mhi_net_dev *dev = netdev_priv(skb->dev);
+	struct mbim_context *ctx = dev->proto_data;
+	struct usb_cdc_ncm_nth16 *nth16;
+	int len;
+
+	if (skb->len < sizeof(struct usb_cdc_ncm_nth16) +
+			sizeof(struct usb_cdc_ncm_ndp16)) {
+		netif_dbg(dev, rx_err, dev->ndev, "frame too short\n");
+		__mbim_length_errors_inc(dev);
+		return -EINVAL;
+	}
+
+	nth16 = (struct usb_cdc_ncm_nth16 *)skb->data;
+
+	if (nth16->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN)) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "invalid NTH16 signature <%#010x>\n",
+			  le32_to_cpu(nth16->dwSignature));
+		__mbim_errors_inc(dev);
+		return -EINVAL;
+	}
+
+	/* No limit on the block length, except the size of the data pkt */
+	len = le16_to_cpu(nth16->wBlockLength);
+	if (len > skb->len) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "NTB does not fit into the skb %u/%u\n", len,
+			  skb->len);
+		__mbim_length_errors_inc(dev);
+		return -EINVAL;
+	}
+
+	if (ctx->rx_seq + 1 != le16_to_cpu(nth16->wSequence) &&
+	    (ctx->rx_seq || le16_to_cpu(nth16->wSequence)) &&
+	    !(ctx->rx_seq == 0xffff && !le16_to_cpu(nth16->wSequence))) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "sequence number glitch prev=%d curr=%d\n",
+			  ctx->rx_seq, le16_to_cpu(nth16->wSequence));
+	}
+	ctx->rx_seq = le16_to_cpu(nth16->wSequence);
+
+	return le16_to_cpu(nth16->wNdpIndex);
+}
+
+static int mbim_rx_verify_ndp16(struct sk_buff *skb, int ndpoffset)
+{
+	struct mhi_net_dev *dev = netdev_priv(skb->dev);
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	int ret;
+
+	if (ndpoffset + sizeof(struct usb_cdc_ncm_ndp16) > skb->len) {
+		netif_dbg(dev, rx_err, dev->ndev, "invalid NDP offset  <%u>\n",
+			  ndpoffset);
+		return -EINVAL;
+	}
+
+	ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
+
+	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN) {
+		netif_dbg(dev, rx_err, dev->ndev, "invalid DPT16 length <%u>\n",
+			  le16_to_cpu(ndp16->wLength));
+		return -EINVAL;
+	}
+
+	ret = ((le16_to_cpu(ndp16->wLength) - sizeof(struct usb_cdc_ncm_ndp16))
+			/ sizeof(struct usb_cdc_ncm_dpe16));
+	ret--; /* Last entry is always a NULL terminator */
+
+	if (sizeof(struct usb_cdc_ncm_ndp16) +
+	     ret * sizeof(struct usb_cdc_ncm_dpe16) > skb->len) {
+		netif_dbg(dev, rx_err, dev->ndev,
+			  "Invalid nframes = %d\n", ret);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
+{
+	struct net_device *ndev = mhi_netdev->ndev;
+	int ndpoffset;
+
+	if (skb_linearize(skb))
+		goto error;
+
+	/* Check NTB header and retrieve first NDP offset */
+	ndpoffset = mbim_rx_verify_nth16(skb);
+	if (ndpoffset < 0) {
+		net_err_ratelimited("%s: Incorrect NTB header\n", ndev->name);
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
+			net_err_ratelimited("%s: Incorrect NDP16\n", ndev->name);
+			__mbim_length_errors_inc(mhi_netdev);
+			goto error;
+		}
+
+		 /* Only IP data type supported, no DSS in MHI context */
+		ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
+		if ((ndp16->dwSignature & MBIM_NDP16_SIGN_MASK)
+					!= USB_CDC_MBIM_NDP16_IPS_SIGN) {
+			net_err_ratelimited("%s: Unsupported NDP type\n", ndev->name);
+			__mbim_errors_inc(mhi_netdev);
+			goto next_ndp;
+		}
+
+		/* Only primary IP session 0 (0x00) supported for now */
+		if (ndp16->dwSignature & ~MBIM_NDP16_SIGN_MASK) {
+			net_err_ratelimited("%s: bad packet session\n", ndev->name);
+			__mbim_errors_inc(mhi_netdev);
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
+				net_err_ratelimited("%s: unknown protocol\n",
+						    ndev->name);
+				__mbim_errors_inc(mhi_netdev);
+				dev_kfree_skb_any(skbn);
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
+	return;
+error:
+	dev_kfree_skb_any(skb);
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
+	/* Ensure we have enough headroom for crafting MBIM header */
+	if (skb_cow_head(skb, sizeof(struct mbim_tx_hdr))) {
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
+	.rx = mbim_rx,
+	.tx_fixup = mbim_tx_fixup,
+};
-- 
2.7.4

