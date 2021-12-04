Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB6D468501
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385034AbhLDNVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:21:51 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:39375 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbhLDNVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 08:21:50 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MGhds-1moWqx0tko-00DmMC; Sat, 04 Dec 2021 14:18:09 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC V2 4/4] net: vertexcom: Add MSE102x SPI support
Date:   Sat,  4 Dec 2021 14:17:51 +0100
Message-Id: <1638623871-21805-5-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
References: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:6htyUyXuvJl3Ba68mGFYOtO2ELIBlmPh5pBftft3GnHgSLK7hqE
 QIe5J8wNKvDraH9yTaWquyYFnQ6hNa/WZepy6ZnKsVBIHAjW/SeHuS/n/hIF1eAom12i2fz
 L7cjW7DYk6nRXnJiRXNH2in9La2Y4bqFOOXzYi9YrhuysETkYgQxSVpFQcpOUb3AODFbrQ4
 zvDYwRbFifgfWsdfxrdsA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y3nuYvzshdE=:HANetDv+ScmjJ0DgnGiv52
 ZjBxxTLpw4Nts/dbupACeFbDw12btZm9xBJ28h9ZqAHkuqdtSiildzZxNAgreBmYhCVZFnIed
 WKKnelViK/1QdqIWXKsm8ltDcXyBGcLZSVYpxO9/9Ubi58+CPf8F3AAiTDIzxW16d/3vKZAjE
 CJALhvHOSoImYu/MixfG5a159X8y6mH6q4pWftpY/TC6903zOX9fR+gmrOBYIZ/jqdWGS4ZJP
 5aGPTGxuWYSTQmavl8aXsl9HPgouFg0D8Ia6H1LpBSfdmJbJ+PWlzIPMVKRQG1Crsxbc+rZBN
 lLNSY8Xk5LxVKWz1Z5dIFhaG+8Q2lp3sGnwnx/Xn2yzRDp1H2ghm/MpXRBMiF3TIIQcAIfvs+
 nWZM0HYn4oplY6Rjl/yxxL65OzRdvGnsKLqhEvovNU7m3VA+zR0xG1yapAqI69CadtKwLUmbZ
 qHUfRjc42dqQTaGdPRzXj/3hdCyErL4UjMRFT3a1IWIbfqHtLGA3ixzXf7haNZSDj6D5H/JB4
 BW8yJQ14vELzuYe7/Xc8yJ5XFawiZxppjzS4a8K/uZokbzsctKmcpomYuVoyd7+4qMYDEtX7N
 +WEEq56HjwpDGpYsJxXH0wUwvTEKufT+kqccEMqyBTsubqx6kvphTU9nkE+FO77DE7c5Gu0Fv
 skz0B/JMqo3sHeWaZYmDKtam0yXgIaRK6I8Y60fWuoSyiqQ/nWeDkQUSaH6nxCW+oUmE3gxCB
 gVowJC/Fmp2nEqe8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements an SPI protocol driver for Vertexcom MSE102x
Homeplug GreenPHY chip.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/net/ethernet/Kconfig             |   1 +
 drivers/net/ethernet/Makefile            |   1 +
 drivers/net/ethernet/vertexcom/Kconfig   |  25 +
 drivers/net/ethernet/vertexcom/Makefile  |   6 +
 drivers/net/ethernet/vertexcom/mse102x.c | 770 +++++++++++++++++++++++++++++++
 5 files changed, 803 insertions(+)
 create mode 100644 drivers/net/ethernet/vertexcom/Kconfig
 create mode 100644 drivers/net/ethernet/vertexcom/Makefile
 create mode 100644 drivers/net/ethernet/vertexcom/mse102x.c

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 027cbac..db3ec47 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -183,6 +183,7 @@ source "drivers/net/ethernet/tehuti/Kconfig"
 source "drivers/net/ethernet/ti/Kconfig"
 source "drivers/net/ethernet/toshiba/Kconfig"
 source "drivers/net/ethernet/tundra/Kconfig"
+source "drivers/net/ethernet/vertexcom/Kconfig"
 source "drivers/net/ethernet/via/Kconfig"
 source "drivers/net/ethernet/wiznet/Kconfig"
 source "drivers/net/ethernet/xilinx/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 33d30b6..8a87c10 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_NET_VENDOR_TEHUTI) += tehuti/
 obj-$(CONFIG_NET_VENDOR_TI) += ti/
 obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
 obj-$(CONFIG_NET_VENDOR_TUNDRA) += tundra/
+obj-$(CONFIG_NET_VENDOR_VERTEXCOM) += vertexcom/
 obj-$(CONFIG_NET_VENDOR_VIA) += via/
 obj-$(CONFIG_NET_VENDOR_WIZNET) += wiznet/
 obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
diff --git a/drivers/net/ethernet/vertexcom/Kconfig b/drivers/net/ethernet/vertexcom/Kconfig
new file mode 100644
index 0000000..4184a63
--- /dev/null
+++ b/drivers/net/ethernet/vertexcom/Kconfig
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Vertexcom network device configuration
+#
+
+config NET_VENDOR_VERTEXCOM
+	bool "Vertexcom devices"
+	default y
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Vertexcom cards. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_VERTEXCOM
+
+config MSE102X
+	tristate "Vertexcom MSE102x SPI"
+	depends on SPI
+	help
+	  SPI driver for Vertexcom MSE102x SPI attached network chip.
+
+endif # NET_VENDOR_VERTEXCOM
diff --git a/drivers/net/ethernet/vertexcom/Makefile b/drivers/net/ethernet/vertexcom/Makefile
new file mode 100644
index 0000000..f8b12e3
--- /dev/null
+++ b/drivers/net/ethernet/vertexcom/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Vertexcom network device drivers.
+#
+
+obj-$(CONFIG_MSE102X) += mse102x.o
diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
new file mode 100644
index 0000000..242fe85
--- /dev/null
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -0,0 +1,770 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2021 in-tech smart charging GmbH
+ *
+ * driver is based on micrel/ks8851_spi.c
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/cache.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include <linux/spi/spi.h>
+#include <linux/of_net.h>
+
+#define MSG_DEFAULT	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK | \
+			 NETIF_MSG_TIMER)
+
+#define DRV_NAME	"mse102x"
+
+#define DET_CMD		0x0001
+#define DET_SOF		0x0002
+#define DET_DFT		0x55AA
+
+#define CMD_SHIFT	12
+#define CMD_RTS		(0x1 << CMD_SHIFT)
+#define CMD_CTR		(0x2 << CMD_SHIFT)
+
+#define CMD_MASK	GENMASK(15, CMD_SHIFT)
+#define LEN_MASK	GENMASK(CMD_SHIFT - 1, 0)
+
+#define DET_CMD_LEN	4
+#define DET_SOF_LEN	2
+#define DET_DFT_LEN	2
+
+#define MIN_FREQ_HZ	6000000
+#define MAX_FREQ_HZ	7142857
+
+struct mse102x_stats {
+	u64 xfer_err;
+	u64 invalid_cmd;
+	u64 invalid_ctr;
+	u64 invalid_dft;
+	u64 invalid_len;
+	u64 invalid_rts;
+	u64 invalid_sof;
+	u64 tx_timeout;
+};
+
+static const char mse102x_gstrings_stats[][ETH_GSTRING_LEN] = {
+	"SPI transfer errors",
+	"Invalid command",
+	"Invalid CTR",
+	"Invalid DFT",
+	"Invalid frame length",
+	"Invalid RTS",
+	"Invalid SOF",
+	"TX timeout",
+};
+
+struct mse102x_net {
+	struct net_device	*ndev;
+
+	u8			rxd[8];
+	u8			txd[8];
+
+	u32			msg_enable ____cacheline_aligned;
+
+	struct sk_buff_head	txq;
+	struct mse102x_stats	stats;
+};
+
+struct mse102x_net_spi {
+	struct mse102x_net	mse102x;
+	struct mutex		lock;		/* Protect SPI frame transfer */
+	struct work_struct	tx_work;
+	struct spi_device	*spidev;
+	struct spi_message	spi_msg;
+	struct spi_transfer	spi_xfer;
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry		*device_root;
+#endif
+};
+
+#define to_mse102x_spi(mse) container_of((mse), struct mse102x_net_spi, mse102x)
+
+#ifdef CONFIG_DEBUG_FS
+
+static int mse102x_info_show(struct seq_file *s, void *what)
+{
+	struct mse102x_net_spi *mses = s->private;
+
+	seq_printf(s, "TX ring size        : %u\n",
+		   skb_queue_len(&mses->mse102x.txq));
+
+	seq_printf(s, "IRQ                 : %d\n",
+		   mses->spidev->irq);
+
+	seq_printf(s, "SPI effective speed : %lu\n",
+		   (unsigned long)mses->spi_xfer.effective_speed_hz);
+	seq_printf(s, "SPI mode            : %x\n",
+		   mses->spidev->mode);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(mse102x_info);
+
+static void mse102x_init_device_debugfs(struct mse102x_net_spi *mses)
+{
+	mses->device_root = debugfs_create_dir(dev_name(&mses->mse102x.ndev->dev),
+					       NULL);
+
+	debugfs_create_file("info", S_IFREG | 0444, mses->device_root, mses,
+			    &mse102x_info_fops);
+}
+
+static void mse102x_remove_device_debugfs(struct mse102x_net_spi *mses)
+{
+	debugfs_remove_recursive(mses->device_root);
+}
+
+#else /* CONFIG_DEBUG_FS */
+
+static void mse102x_init_device_debugfs(struct mse102x_net_spi *mses)
+{
+}
+
+static void mse102x_remove_device_debugfs(struct mse102x_net_spi *mses)
+{
+}
+
+#endif
+
+/* SPI register read/write calls.
+ *
+ * All these calls issue SPI transactions to access the chip's registers. They
+ * all require that the necessary lock is held to prevent accesses when the
+ * chip is busy transferring packet data.
+ */
+
+static void mse102x_tx_cmd_spi(struct mse102x_net *mse, u16 cmd)
+{
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+	struct spi_transfer *xfer = &mses->spi_xfer;
+	struct spi_message *msg = &mses->spi_msg;
+	__be16 txb[2];
+	int ret;
+
+	txb[0] = cpu_to_be16(DET_CMD);
+	txb[1] = cpu_to_be16(cmd);
+
+	xfer->tx_buf = txb;
+	xfer->rx_buf = NULL;
+	xfer->len = DET_CMD_LEN;
+
+	ret = spi_sync(mses->spidev, msg);
+	if (ret < 0) {
+		netdev_err(mse->ndev, "%s: spi_sync() failed: %d\n",
+			   __func__, ret);
+		mse->stats.xfer_err++;
+	}
+}
+
+static int mse102x_rx_cmd_spi(struct mse102x_net *mse, u8 *rxb)
+{
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+	struct spi_transfer *xfer = &mses->spi_xfer;
+	struct spi_message *msg = &mses->spi_msg;
+	__be16 *txb = (__be16 *)mse->txd;
+	__be16 *cmd = (__be16 *)mse->rxd;
+	u8 *trx = mse->rxd;
+	int ret;
+
+	txb[0] = 0;
+	txb[1] = 0;
+
+	xfer->tx_buf = txb;
+	xfer->rx_buf = trx;
+	xfer->len = DET_CMD_LEN;
+
+	ret = spi_sync(mses->spidev, msg);
+	if (ret < 0) {
+		netdev_err(mse->ndev, "%s: spi_sync() failed: %d\n",
+			   __func__, ret);
+		mse->stats.xfer_err++;
+	} else if (*cmd != cpu_to_be16(DET_CMD)) {
+		net_dbg_ratelimited("%s: Unexpected response (0x%04x)\n",
+				    __func__, *cmd);
+		mse->stats.invalid_cmd++;
+		ret = -EIO;
+	} else {
+		memcpy(rxb, trx + 2, 2);
+	}
+
+	return ret;
+}
+
+static inline void mse102x_push_header(struct sk_buff *skb)
+{
+	__be16 *header = skb_push(skb, DET_SOF_LEN);
+
+	*header = cpu_to_be16(DET_SOF);
+}
+
+static inline void mse102x_put_footer(struct sk_buff *skb)
+{
+	__be16 *footer = skb_put(skb, DET_DFT_LEN);
+
+	*footer = cpu_to_be16(DET_DFT);
+}
+
+static int mse102x_tx_frame_spi(struct mse102x_net *mse, struct sk_buff *txp,
+				unsigned int pad)
+{
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+	struct spi_transfer *xfer = &mses->spi_xfer;
+	struct spi_message *msg = &mses->spi_msg;
+	struct sk_buff *tskb;
+	int ret;
+
+	netif_dbg(mse, tx_queued, mse->ndev, "%s: skb %p, %d@%p\n",
+		  __func__, txp, txp->len, txp->data);
+
+	if ((skb_headroom(txp) < DET_SOF_LEN) ||
+	    (skb_tailroom(txp) < DET_DFT_LEN + pad)) {
+		tskb = skb_copy_expand(txp, DET_SOF_LEN, DET_DFT_LEN + pad,
+				       GFP_KERNEL);
+		if (!tskb)
+			return -ENOMEM;
+
+		dev_kfree_skb(txp);
+		txp = tskb;
+	}
+
+	mse102x_push_header(txp);
+
+	if (pad)
+		skb_put_zero(txp, pad);
+
+	mse102x_put_footer(txp);
+
+	xfer->tx_buf = txp->data;
+	xfer->rx_buf = NULL;
+	xfer->len = txp->len;
+
+	ret = spi_sync(mses->spidev, msg);
+	if (ret < 0) {
+		netdev_err(mse->ndev, "%s: spi_sync() failed: %d\n",
+			   __func__, ret);
+		mse->stats.xfer_err++;
+	}
+
+	return ret;
+}
+
+static int mse102x_rx_frame_spi(struct mse102x_net *mse, u8 *buff,
+				unsigned int frame_len)
+{
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+	struct spi_transfer *xfer = &mses->spi_xfer;
+	struct spi_message *msg = &mses->spi_msg;
+	__be16 *sof = (__be16 *)buff;
+	__be16 *dft = (__be16 *)(buff + DET_SOF_LEN + frame_len);
+	int ret;
+
+	xfer->rx_buf = buff;
+	xfer->tx_buf = NULL;
+	xfer->len = DET_SOF_LEN + frame_len + DET_DFT_LEN;
+
+	ret = spi_sync(mses->spidev, msg);
+	if (ret < 0) {
+		netdev_err(mse->ndev, "%s: spi_sync() failed: %d\n",
+			   __func__, ret);
+		mse->stats.xfer_err++;
+	} else if (*sof != cpu_to_be16(DET_SOF)) {
+		netdev_dbg(mse->ndev, "%s: SPI start of frame is invalid (0x%04x)\n",
+			   __func__, *sof);
+		mse->stats.invalid_sof++;
+		ret = -EIO;
+	} else if (*dft != cpu_to_be16(DET_DFT)) {
+		netdev_dbg(mse->ndev, "%s: SPI frame tail is invalid (0x%04x)\n",
+			   __func__, *dft);
+		mse->stats.invalid_dft++;
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
+static void mse102x_dump_packet(const char *msg, int len, const char *data)
+{
+	printk(KERN_DEBUG ": %s - packet len:%d\n", msg, len);
+	print_hex_dump(KERN_DEBUG, "pk data: ", DUMP_PREFIX_OFFSET, 16, 1,
+		       data, len, true);
+}
+
+static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
+{
+	struct sk_buff *skb;
+	unsigned int rxalign;
+	unsigned int rxlen;
+	__be16 rx = 0;
+	u16 cmd_resp;
+	u8 *rxpkt;
+	int ret;
+
+	mse102x_tx_cmd_spi(mse, CMD_CTR);
+	ret = mse102x_rx_cmd_spi(mse, (u8 *)&rx);
+	cmd_resp = be16_to_cpu(rx);
+
+	if (ret || ((cmd_resp & CMD_MASK) != CMD_RTS)) {
+		usleep_range(50, 100);
+
+		mse102x_tx_cmd_spi(mse, CMD_CTR);
+		ret = mse102x_rx_cmd_spi(mse, (u8 *)&rx);
+		if (ret)
+			return;
+
+		cmd_resp = be16_to_cpu(rx);
+		if ((cmd_resp & CMD_MASK) != CMD_RTS) {
+			net_dbg_ratelimited("%s: Unexpected response (0x%04x)\n",
+					    __func__, cmd_resp);
+			mse->stats.invalid_rts++;
+			return;
+		}
+
+		net_dbg_ratelimited("%s: Unexpected response to first CMD\n",
+				    __func__);
+	}
+
+	rxlen = cmd_resp & LEN_MASK;
+	if (!rxlen) {
+		net_dbg_ratelimited("%s: No frame length defined\n", __func__);
+		mse->stats.invalid_len++;
+		return;
+	}
+
+	rxalign = ALIGN(rxlen + DET_SOF_LEN + DET_DFT_LEN, 4);
+	skb = netdev_alloc_skb_ip_align(mse->ndev, rxalign);
+	if (!skb)
+		return;
+
+	/* 2 bytes Start of frame (before ethernet header)
+	 * 2 bytes Data frame tail (after ethernet frame)
+	 * They are copied, but ignored.
+	 */
+	rxpkt = skb_put(skb, rxlen) - DET_SOF_LEN;
+	if (mse102x_rx_frame_spi(mse, rxpkt, rxlen)) {
+		mse->ndev->stats.rx_errors++;
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	if (netif_msg_pktdata(mse))
+		mse102x_dump_packet(__func__, skb->len, skb->data);
+
+	skb->protocol = eth_type_trans(skb, mse->ndev);
+	netif_rx_ni(skb);
+
+	mse->ndev->stats.rx_packets++;
+	mse->ndev->stats.rx_bytes += rxlen;
+}
+
+static int mse102x_tx_pkt_spi(struct mse102x_net *mse, struct sk_buff *txb,
+			      unsigned long work_timeout)
+{
+	unsigned int pad = 0;
+	__be16 rx = 0;
+	u16 cmd_resp;
+	int ret;
+	bool first = true;
+
+	if (txb->len < 60)
+		pad = 60 - txb->len;
+
+	while (1) {
+		mse102x_tx_cmd_spi(mse, CMD_RTS | (txb->len + pad));
+		ret = mse102x_rx_cmd_spi(mse, (u8 *)&rx);
+		cmd_resp = be16_to_cpu(rx);
+
+		if (!ret) {
+			/* ready to send frame ? */
+			if (cmd_resp == CMD_CTR)
+				break;
+
+			net_dbg_ratelimited("%s: Unexpected response (0x%04x)\n",
+					    __func__, cmd_resp);
+			mse->stats.invalid_ctr++;
+		}
+
+		/* It's not predictable how long / many retries it takes to
+		 * send at least one packet, so TX timeouts are possible.
+		 * That's the reason why the netdev watchdog is not used here.
+		 */
+		if (time_after(jiffies, work_timeout))
+			return -ETIMEDOUT;
+
+		if (first) {
+			/* throttle at first issue */
+			netif_stop_queue(mse->ndev);
+			/* fast retry */
+			usleep_range(50, 100);
+			first = false;
+		} else {
+			msleep(20);
+		}
+	};
+
+	ret = mse102x_tx_frame_spi(mse, txb, pad);
+	if (ret)
+		net_dbg_ratelimited("%s: Failed to send (%d), drop frame\n",
+				    __func__, ret);
+
+	return ret;
+}
+
+#define TX_QUEUE_MAX 10
+
+static void mse102x_tx_work(struct work_struct *work)
+{
+	/* Make sure timeout is sufficient to transfer TX_QUEUE_MAX frames */
+	unsigned long work_timeout = jiffies + msecs_to_jiffies(1000);
+	struct mse102x_net_spi *mses;
+	struct mse102x_net *mse;
+	struct sk_buff *txb;
+	int ret = 0;
+
+	mses = container_of(work, struct mse102x_net_spi, tx_work);
+	mse = &mses->mse102x;
+
+	while ((txb = skb_dequeue(&mse->txq))) {
+		mutex_lock(&mses->lock);
+		ret = mse102x_tx_pkt_spi(mse, txb, work_timeout);
+		mutex_unlock(&mses->lock);
+		if (ret) {
+			mse->ndev->stats.tx_dropped++;
+		} else {
+			mse->ndev->stats.tx_bytes += txb->len;
+			mse->ndev->stats.tx_packets++;
+		}
+
+		dev_kfree_skb(txb);
+	}
+
+	if (ret == -ETIMEDOUT) {
+		if (netif_msg_timer(mse))
+			netdev_err(mse->ndev, "tx work timeout\n");
+
+		mse->stats.tx_timeout++;
+	}
+
+	netif_wake_queue(mse->ndev);
+}
+
+static netdev_tx_t mse102x_start_xmit_spi(struct sk_buff *skb,
+					  struct net_device *ndev)
+{
+	struct mse102x_net *mse = netdev_priv(ndev);
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+
+	netif_dbg(mse, tx_queued, ndev,
+		  "%s: skb %p, %d@%p\n", __func__, skb, skb->len, skb->data);
+
+	skb_queue_tail(&mse->txq, skb);
+
+	if (skb_queue_len(&mse->txq) >= TX_QUEUE_MAX)
+		netif_stop_queue(ndev);
+
+	schedule_work(&mses->tx_work);
+
+	return NETDEV_TX_OK;
+}
+
+static void mse102x_init_mac(struct mse102x_net *mse, struct device_node *np)
+{
+	struct net_device *ndev = mse->ndev;
+	int ret = of_get_ethdev_address(np, ndev);
+
+	if (ret) {
+		eth_hw_addr_random(ndev);
+		netdev_err(ndev, "Using random MAC address: %pM\n",
+			   ndev->dev_addr);
+	}
+}
+
+/* Assumption: this is called for every incoming packet */
+static irqreturn_t mse102x_irq(int irq, void *_mse)
+{
+	struct mse102x_net *mse = _mse;
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+
+	mutex_lock(&mses->lock);
+	mse102x_rx_pkt_spi(mse);
+	mutex_unlock(&mses->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int mse102x_net_open(struct net_device *ndev)
+{
+	struct mse102x_net *mse = netdev_priv(ndev);
+	int ret;
+
+	ret = request_threaded_irq(ndev->irq, NULL, mse102x_irq, IRQF_ONESHOT,
+				   ndev->name, mse);
+	if (ret < 0) {
+		netdev_err(ndev, "Failed to get irq: %d\n", ret);
+		return ret;
+	}
+
+	netif_dbg(mse, ifup, ndev, "opening\n");
+
+	netif_start_queue(ndev);
+
+	netif_carrier_on(ndev);
+
+	netif_dbg(mse, ifup, ndev, "network device up\n");
+
+	return 0;
+}
+
+static int mse102x_net_stop(struct net_device *ndev)
+{
+	struct mse102x_net *mse = netdev_priv(ndev);
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+
+	netif_info(mse, ifdown, ndev, "shutting down\n");
+
+	netif_carrier_off(mse->ndev);
+
+	/* stop any outstanding work */
+	flush_work(&mses->tx_work);
+
+	netif_stop_queue(ndev);
+
+	skb_queue_purge(&mse->txq);
+
+	free_irq(ndev->irq, mse);
+
+	return 0;
+}
+
+static const struct net_device_ops mse102x_netdev_ops = {
+	.ndo_open		= mse102x_net_open,
+	.ndo_stop		= mse102x_net_stop,
+	.ndo_start_xmit		= mse102x_start_xmit_spi,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
+/* ethtool support */
+
+static void mse102x_get_drvinfo(struct net_device *ndev,
+				struct ethtool_drvinfo *di)
+{
+	strscpy(di->driver, DRV_NAME, sizeof(di->driver));
+	strscpy(di->bus_info, dev_name(ndev->dev.parent), sizeof(di->bus_info));
+}
+
+static u32 mse102x_get_msglevel(struct net_device *ndev)
+{
+	struct mse102x_net *mse = netdev_priv(ndev);
+
+	return mse->msg_enable;
+}
+
+static void mse102x_set_msglevel(struct net_device *ndev, u32 to)
+{
+	struct mse102x_net *mse = netdev_priv(ndev);
+
+	mse->msg_enable = to;
+}
+
+static void mse102x_get_ethtool_stats(struct net_device *ndev,
+				      struct ethtool_stats *estats, u64 *data)
+{
+	struct mse102x_net *mse = netdev_priv(ndev);
+	struct mse102x_stats *st = &mse->stats;
+
+	memcpy(data, st, ARRAY_SIZE(mse102x_gstrings_stats) * sizeof(u64));
+}
+
+static void mse102x_get_strings(struct net_device *ndev, u32 stringset, u8 *buf)
+{
+	switch (stringset) {
+	case ETH_SS_STATS:
+		memcpy(buf, &mse102x_gstrings_stats,
+		       sizeof(mse102x_gstrings_stats));
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+}
+
+static int mse102x_get_sset_count(struct net_device *ndev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return ARRAY_SIZE(mse102x_gstrings_stats);
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct ethtool_ops mse102x_ethtool_ops = {
+	.get_drvinfo		= mse102x_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_msglevel		= mse102x_get_msglevel,
+	.set_msglevel		= mse102x_set_msglevel,
+	.get_ethtool_stats	= mse102x_get_ethtool_stats,
+	.get_strings		= mse102x_get_strings,
+	.get_sset_count		= mse102x_get_sset_count,
+};
+
+/* driver bus management functions */
+
+#ifdef CONFIG_PM_SLEEP
+
+static int mse102x_suspend(struct device *dev)
+{
+	struct mse102x_net *mse = dev_get_drvdata(dev);
+	struct net_device *ndev = mse->ndev;
+
+	if (netif_running(ndev)) {
+		netif_device_detach(ndev);
+		mse102x_net_stop(ndev);
+	}
+
+	return 0;
+}
+
+static int mse102x_resume(struct device *dev)
+{
+	struct mse102x_net *mse = dev_get_drvdata(dev);
+	struct net_device *ndev = mse->ndev;
+
+	if (netif_running(ndev)) {
+		mse102x_net_open(ndev);
+		netif_device_attach(ndev);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(mse102x_pm_ops, mse102x_suspend, mse102x_resume);
+
+static int mse102x_probe_spi(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct mse102x_net_spi *mses;
+	struct net_device *ndev;
+	struct mse102x_net *mse;
+	int ret;
+
+	spi->bits_per_word = 8;
+	spi->mode |= SPI_MODE_3;
+	/* enforce minimum speed to ensure device functionality */
+	spi->master->min_speed_hz = MIN_FREQ_HZ;
+
+	if (!spi->max_speed_hz)
+		spi->max_speed_hz = MAX_FREQ_HZ;
+
+	if (spi->max_speed_hz < MIN_FREQ_HZ ||
+	    spi->max_speed_hz > MAX_FREQ_HZ) {
+		dev_err(&spi->dev, "SPI max frequency out of range (min: %u, max: %u)\n",
+			MIN_FREQ_HZ, MAX_FREQ_HZ);
+		return -EINVAL;
+	}
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		dev_err(&spi->dev, "Unable to setup SPI device: %d\n", ret);
+		return ret;
+	}
+
+	ndev = devm_alloc_etherdev(dev, sizeof(struct mse102x_net_spi));
+	if (!ndev)
+		return -ENOMEM;
+
+	ndev->needed_tailroom += ALIGN(DET_DFT_LEN, 4);
+	ndev->needed_headroom += ALIGN(DET_SOF_LEN, 4);
+	ndev->priv_flags &= ~IFF_TX_SKB_SHARING;
+	ndev->tx_queue_len = 100;
+
+	mse = netdev_priv(ndev);
+	mses = to_mse102x_spi(mse);
+
+	mses->spidev = spi;
+	mutex_init(&mses->lock);
+	INIT_WORK(&mses->tx_work, mse102x_tx_work);
+
+	/* initialise pre-made spi transfer messages */
+	spi_message_init(&mses->spi_msg);
+	spi_message_add_tail(&mses->spi_xfer, &mses->spi_msg);
+
+	ndev->irq = spi->irq;
+	mse->ndev = ndev;
+
+	/* set the default message enable */
+	mse->msg_enable = netif_msg_init(-1, MSG_DEFAULT);
+
+	skb_queue_head_init(&mse->txq);
+
+	SET_NETDEV_DEV(ndev, dev);
+
+	dev_set_drvdata(dev, mse);
+
+	netif_carrier_off(mse->ndev);
+	ndev->if_port = IF_PORT_HOMEPLUG;
+	ndev->netdev_ops = &mse102x_netdev_ops;
+	ndev->ethtool_ops = &mse102x_ethtool_ops;
+
+	mse102x_init_mac(mse, dev->of_node);
+
+	ret = register_netdev(ndev);
+	if (ret) {
+		dev_err(dev, "failed to register network device: %d\n", ret);
+		return ret;
+	}
+
+	mse102x_init_device_debugfs(mses);
+
+	return 0;
+}
+
+static int mse102x_remove_spi(struct spi_device *spi)
+{
+	struct mse102x_net *mse = dev_get_drvdata(&spi->dev);
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+
+	if (netif_msg_drv(mse))
+		dev_info(&spi->dev, "remove\n");
+
+	mse102x_remove_device_debugfs(mses);
+	unregister_netdev(mse->ndev);
+
+	return 0;
+}
+
+static const struct of_device_id mse102x_match_table[] = {
+	{ .compatible = "vertexcom,mse1021" },
+	{ .compatible = "vertexcom,mse1022" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, mse102x_match_table);
+
+static struct spi_driver mse102x_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = mse102x_match_table,
+		.pm = &mse102x_pm_ops,
+	},
+	.probe = mse102x_probe_spi,
+	.remove = mse102x_remove_spi,
+};
+module_spi_driver(mse102x_driver);
+
+MODULE_DESCRIPTION("MSE102x Network driver");
+MODULE_AUTHOR("Stefan Wahren <stefan.wahren@in-tech.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:" DRV_NAME);
-- 
2.7.4

