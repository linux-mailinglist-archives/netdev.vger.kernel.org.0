Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420A928FF3A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 09:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404717AbgJPHge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 03:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394562AbgJPHge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 03:36:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640A0C061755;
        Fri, 16 Oct 2020 00:36:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k8so992106pfk.2;
        Fri, 16 Oct 2020 00:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=j8LobTIECsdKbB2qN835a4269DMlsHLSz8lYrfc9iIg=;
        b=AeHVGAX6kvEeWf2ri/ODDAsvoW5JyZasi5DBOjOzRZWLEI9HSzjTWfadKtJaeidaBs
         ziEbSuNLrClYmBvFUu9jttNL6BTvQZiS+edOwgIbc8GZ1QuBB0TMfm7h854leN7L3S47
         DxSG1n3A95a13yZyYf3TpRdqhZvLhWggpDBSU1YYzREsOc5i+8n3oXarFF6UoPCK9ysP
         Wh/rU6enC4dImS/ztal8P0utuwkefBHpWH0AUrB+Q6tC6bOhY+fA2mcUBU/LYSvshStM
         mOmf8MThERYZAEtjETJjUbixJzJkcB/DyC2jrHmbqTbSvZF5/roH+RCUOvmPA9gzii/7
         tq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j8LobTIECsdKbB2qN835a4269DMlsHLSz8lYrfc9iIg=;
        b=Q/qt1ljaWbk7WpYgQx4h8zLJ0EyfsGWpCiL59P+uL1cyFNP6KSweg6o8QnSqQE//Je
         J0kAHmqF/T+vhtS3it6yr2lgZYSzaQVJqqf8MMIO9GI3pE4iJqtWAL7wAGsXRQQUuMbP
         sZghTZA+rZ6Dly+UnQ+KVJPuC4TacOAO8Sx3dBldoKP1xPhjWpCGkiV5dBF/ll0ZnYi9
         nd7TfnEVCD996hNn2zq6yEyjsWPGFOOcKNAfdCA6bFie5LDSBojuBZrP5IGSfa+LqwpN
         wAUfu3SgB4UhcDL2FZXCqNUy79lL18LGw9gnPXO53hCkeERIcpc/ti8MucB44o5byXd2
         bDkQ==
X-Gm-Message-State: AOAM530x/NOVbw7GTPkVGvmKgQvmcfz+lao7RahE4IlmJoPivX4guFKL
        xf4RWpK06Yiy5K4Yur6RRIjFYRMjMUzH+c5d
X-Google-Smtp-Source: ABdhPJyfAWQXW3rzOThxZYg6Kb2WjnXKEW1I822fucuCp2tV882iVoteTTTmW8UNxeib4KCs9UDb+g==
X-Received: by 2002:a63:6fca:: with SMTP id k193mr2041239pgc.360.1602833793870;
        Fri, 16 Oct 2020 00:36:33 -0700 (PDT)
Received: from sh09760tmp788.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id 194sm1692845pfz.182.2020.10.16.00.36.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Oct 2020 00:36:33 -0700 (PDT)
From:   Daisy Zhang251 <daisy.zhang251@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Daisy Zhang1 <daisy.zhang1@unisoc.com>
Subject: [PATCH] cfg80211: make wifi driver probe
Date:   Fri, 16 Oct 2020 15:36:27 +0800
Message-Id: <1602833787-4206-1-git-send-email-daisy.zhang251@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daisy Zhang1 <daisy.zhang1@unisoc.com>

Register a WiFi driver of IEEE80211 WLAN for the Unisoc Marlin3
chipsets. The following code is a simple architecture for probing
driver.

Signed-off-by: Daisy Zhang1 <daisy.zhang1@unisoc.com>
---
 drivers/net/wireless/sprd/Kconfig       |  21 +++++
 drivers/net/wireless/sprd/Makefile      |  15 ++++
 drivers/net/wireless/sprd/core_sc2355.c | 113 +++++++++++++++++++++++
 drivers/net/wireless/sprd/core_sc2355.h | 115 ++++++++++++++++++++++++
 drivers/net/wireless/sprd/interface.h   |  33 +++++++
 drivers/net/wireless/sprd/message.h     |  95 ++++++++++++++++++++
 drivers/net/wireless/sprd/wireless.h    |  69 ++++++++++++++
 7 files changed, 461 insertions(+)
 create mode 100644 drivers/net/wireless/sprd/Kconfig
 create mode 100644 drivers/net/wireless/sprd/Makefile
 create mode 100644 drivers/net/wireless/sprd/core_sc2355.c
 create mode 100644 drivers/net/wireless/sprd/core_sc2355.h
 create mode 100644 drivers/net/wireless/sprd/interface.h
 create mode 100644 drivers/net/wireless/sprd/message.h
 create mode 100644 drivers/net/wireless/sprd/wireless.h

diff --git a/drivers/net/wireless/sprd/Kconfig b/drivers/net/wireless/sprd/Kconfig
index 000000000000..b68db761a460
--- /dev/null
+++ b/drivers/net/wireless/sprd/Kconfig
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# config kernel for the Unisoc Wi-Fi driver
+
+config SPRD_WLAN
+	tristate "Unisoc Wireless LAN Support"
+	depends on CFG80211
+	help
+	  This is a driver of IEEE80211 WLAN for the Unisoc WiFi chipsets.
+	  This driver works on Marlin3 chip, which is the 3rd WiFi chipsets
+	  of the Unisoc.
+	  When compiled as a module, it will be called sprdwl_ng.
+
+config SPRD_WLAN_MARLIN3
+	bool "MARLIN3"
+
+	help
+	  Select this to support the Unisoc SC2355 branch, which includes
+	  SDIO and PCIe interfaces to translate data and works on Marlin3
+	  chips. SDIO interface and PCIe interface correspond to different
+	  code logic for different customer projects.
+
+endchoice
diff --git a/drivers/net/wireless/sprd/Makefile b/drivers/net/wireless/sprd/Makefile
index 000000000000..a1eae0b4e302
--- /dev/null
+++ b/drivers/net/wireless/sprd/Makefile
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Makefile for the Unisoc Wi-Fi driver
+
+#####module name ###
+obj-m += sprdwl_ng.o
+
+#######add .o file#####
+sprdwl_ng-objs += core_sc2355.o
+
+modules:
+	$(MAKE) ARCH=$(ARCH) -C $(KDIR) M=$(CURDIR) $@
+clean:
+	$(MAKE) ARCH=$(ARCH) -C $(KDIR) M=$(CURDIR) $@
+kernelrelease:
+	$(MAKE) ARCH=$(ARCH) -C $(KDIR) $@
diff --git a/drivers/net/wireless/sprd/core_sc2355.c b/drivers/net/wireless/sprd/core_sc2355.c
index 000000000000..27e1c5346b4e
--- /dev/null
+++ b/drivers/net/wireless/sprd/core_sc2355.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Wi-Fi driver of the Unisoc for Marlin3 chip:
+// register a Wi-Fi driver of IEEE802.11 WLAN for the Unisoc
+//
+// Copyright(C) 2018 Unisoc,Inc
+
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/utsname.h>
+#include "core_sc2355.h"
+#include "interface.h"
+#include "wireless.h"
+
+static int sprdwl_ini_download_status(void)
+{
+	return 0;
+}
+
+static void sprdwl_force_exit(void *spdev)
+{
+	struct sprdwl_intf *intf = (struct sprdwl_intf *)spdev;
+
+	intf->exit = 1;
+}
+
+static int sprdwl_is_exit(void *spdev)
+{
+	struct sprdwl_intf *intf = (struct sprdwl_intf *)spdev;
+
+	return intf->exit;
+}
+
+static struct sprdwl_if_ops sprdwl_core_ops = {
+	.force_exit = sprdwl_force_exit,
+	.is_exit = sprdwl_is_exit,
+	.ini_download_status = sprdwl_ini_download_status
+};
+
+static int sprdwl_probe(struct platform_device *pdev)
+{
+	struct sprdwl_intf *intf;
+	struct sprdwl_priv *priv;
+	int ret;
+	u8 i;
+
+	intf = kzalloc(sizeof(*intf), GFP_ATOMIC);
+	if (!intf) {
+		ret = -ENOMEM;
+		dev_err(sprdwl_dev, "sc2355 sprd-wlan:%s alloc intf fail: %d\n", __func__, ret);
+		goto out;
+	}
+
+	platform_set_drvdata(pdev, intf);
+	intf->pdev = pdev;
+	sprdwl_dev = &pdev->dev;
+
+	for (i = 0; i < MAX_LUT_NUM; i++)
+		intf->peer_entry[i].ctx_id = 0xff;
+
+	priv = sprdwl_core_create(SPRDWL_HW_SC2355_SDIO,
+				  &sprdwl_core_ops);
+	if (!priv) {
+		dev_err(sprdwl_dev, "sc2355 sprd-wlan:%s core create fail\n", __func__);
+		ret = -ENXIO;
+		goto err;
+	}
+
+	ret = sprdwl_core_init(&pdev->dev, priv);
+	if (ret)
+		goto err;
+
+	return ret;
+
+err:
+	kfree(intf);
+out:
+	return ret;
+}
+
+static int sprdwl_remove(struct platform_device *pdev)
+{
+	struct sprdwl_intf *intf = platform_get_drvdata(pdev);
+	struct sprdwl_priv *priv = intf->priv;
+
+	sprdwl_core_deinit(priv);
+	sprdwl_core_free(priv);
+	kfree(intf);
+
+	return 0;
+}
+
+static const struct of_device_id sprdwl_of_match[] = {
+	{.compatible = "sprd,sc2355-wifi",},
+	{}
+};
+MODULE_DEVICE_TABLE(of, sprdwl_of_match);
+
+static struct platform_driver sprdwl_driver = {
+	.probe = sprdwl_probe,
+	.remove = sprdwl_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "sc2355",
+		.of_match_table = sprdwl_of_match
+	}
+};
+
+module_platform_driver(sprdwl_driver);
+
+MODULE_DESCRIPTION("Unisoc Wireless LAN Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/sprd/core_sc2355.h b/drivers/net/wireless/sprd/core_sc2355.h
index 000000000000..7ff1292dbef0
--- /dev/null
+++ b/drivers/net/wireless/sprd/core_sc2355.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+//
+// Wi-Fi driver of the Unisoc for the Marlin3 chip:
+// register a Wi-Fi driver of IEEE802.11 WLAN for the Unisoc
+//
+// Copyright(C) 2018 Unisoc,Inc
+
+#define SPRDWL_NORMAL_MEM	0
+#define SPRDWL_DEFRAG_MEM	1
+
+#define SPRDWL_TX_CMD_TIMEOUT	3000
+#define SPRDWL_TX_DATA_TIMEOUT	4000
+
+#define SPRDWL_TX_MSG_CMD_NUM	128
+#define SPRDWL_TX_MSG_SPECIAL_DATA_NUM	256
+#define SPRDWL_TX_QOS_POOL_SIZE	20000
+#define SPRDWL_TX_DATA_START_NUM	(SPRDWL_TX_QOS_POOL_SIZE - 3)
+#define SPRDWL_RX_MSG_NUM	20000
+
+#define SPRDWL_MAX_CMD_TXLEN	1596
+#define SPRDWL_MAX_CMD_RXLEN	1092
+#define SPRDWL_MAX_DATA_TXLEN	1672
+#define SPRDWL_MAX_DATA_RXLEN	1676
+
+#define MAX_LUT_NUM	32
+
+/* struct tx_address: the tx mac address of da and sa
+ * @da: destination address
+ * @sa: source address
+ */
+struct tx_address {
+	u8 da[ETH_ALEN];
+	u8 sa[ETH_ALEN];
+};
+
+/* struct rx_address: the rx mac address of da and sa
+ * @sa: source address
+ * @da: destination address
+ */
+struct rx_address {
+	u8 sa[ETH_ALEN];
+	u8 da[ETH_ALEN];
+};
+
+/* struct sprdwl_peer_entry: the information of peer connectted
+ * @rx: rx mac address
+ * @tx: tx mac address
+ * @lut_index: lookup table index of current peer
+ * @ctx_id: wifi context index of stap mode
+ * @ht_enable: indicate current peer high thoughput enabled
+ * @vht_enable: indicate current peer very high thoughput enabled
+ * @ip_acquired: indicate current peer ip address acquired
+ * @ba_tx_done_map: indicate current peer tx ba session enabled
+ * @vowifi_enabled: indicate current peer vowifi scenario enabled
+ */
+struct sprdwl_peer_entry {
+	union {
+		struct rx_address rx;
+		struct tx_address tx;
+	};
+
+	u8 lut_index;
+	u8 ctx_id;
+	u8 cipher_type;
+	u8 pending_num;
+	u8 ht_enable;
+	u8 vht_enable;
+	u8 ip_acquired;
+	unsigned long ba_tx_done_map;
+	u8 vowifi_enabled;
+};
+
+/* struct sprdwl_priv: the information of priv definition
+ */
+struct sprdwl_priv;
+
+/* struct sprdwl_intf: the information of interface
+ * @pdev: platform device
+ * @priv: wifi private struct
+ * @exit: indicate driver exit
+ * @tx_mode: value of tx mode
+ * @rx_mode: value of rx mode
+ * @hw_intf: the hardware interface type
+ * @sprdwl_tx: pointer to tx information struct
+ * @sprdwl_rx: pointer to rx information struct
+ * @peer_entry: the information of peer connectted
+ * @skb_da: destination address of this interface
+ * @hif_offset: data offset of the hardware interface
+ * @rx_cmd_port: cmd port for rx
+ * @rx_data_port: data port for rx
+ * @tx_cmd_port: cmd port for tx
+ * @tx_data_port: data port for tx
+ * @cp_asserted: indicate cp2 asserted
+ */
+struct sprdwl_intf {
+	struct platform_device *pdev;
+	struct sprdwl_priv *priv;
+	int exit;
+	int flag;
+	int tx_mode;
+	int rx_mode;
+	void *hw_intf;
+	void *sprdwl_tx;
+	void *sprdwl_rx;
+	struct sprdwl_peer_entry peer_entry[MAX_LUT_NUM];
+	unsigned char *skb_da;
+	int hif_offset;
+	unsigned char rx_cmd_port;
+	unsigned char rx_data_port;
+	unsigned char tx_cmd_port;
+	unsigned char tx_data_port;
+	u8 cp_asserted;
+};
+
+struct device *sprdwl_dev;
diff --git a/drivers/net/wireless/sprd/interface.h b/drivers/net/wireless/sprd/interface.h
index 000000000000..3ef1351f8d59
--- /dev/null
+++ b/drivers/net/wireless/sprd/interface.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+//
+// Wi-Fi driver of the Unisoc for Marlin3 chip:
+// interface operations
+//
+// Copyright(C) 2018 Unisoc,Inc
+
+#ifndef __SPRDWL_INTF_H__
+#define __SPRDWL_INTF_H__
+
+#include "message.h"
+#include "wireless.h"
+
+/* struct sprdwl_if_ops: interface operations
+ * @get_msg_buf: get a free message buffer from list
+ * @free_msg_buf: free the message buffer to use again
+ * @tx: transmit message buffer to tx thread
+ * @force_exit: force remove driver
+ * @is_exit: indicate driver exit or not
+ * @ini_download_status: indicate ini downloaded or not
+ */
+struct sprdwl_if_ops {
+	struct sprdwl_msg_buf *(*get_msg_buf)(void *sdev,
+					      enum sprdwl_head_type type,
+					      enum sprdwl_mode mode,
+					      u8 ctx_id);
+	void (*free_msg_buf)(void *sdev, struct sprdwl_msg_buf *msg);
+	int (*tx)(void *spdev, struct sprdwl_msg_buf *msg);
+	void (*force_exit)(void *spdev);
+	int (*is_exit)(void *spdev);
+	int (*ini_download_status)(void);
+};
+#endif
diff --git a/drivers/net/wireless/sprd/message.h b/drivers/net/wireless/sprd/message.h
index 000000000000..841ceb626483
--- /dev/null
+++ b/drivers/net/wireless/sprd/message.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+//
+// Wi-Fi driver of the Unisoc for Marlin3 chip:
+// management the message buffer
+//
+// Copyright(C) 2018 Unisoc,Inc.
+
+#ifndef __SPRDWL_MSG_H__
+#define __SPRDWL_MSG_H__
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+enum sprdwl_mode {
+	SPRDWL_MODE_NONE,
+	SPRDWL_MODE_STATION,
+	SPRDWL_MODE_AP,
+
+	SPRDWL_MODE_P2P_DEVICE = 4,
+	SPRDWL_MODE_P2P_CLIENT,
+	SPRDWL_MODE_P2P_GO,
+
+	SPRDWL_MODE_IBSS,
+
+	SPRDWL_MODE_MAX
+};
+
+enum sm_state {
+	SPRDWL_UNKNOWN = 0,
+	SPRDWL_SCANNING,
+	SPRDWL_SCAN_ABORTING,
+	SPRDWL_DISCONNECTING,
+	SPRDWL_DISCONNECTED,
+	SPRDWL_CONNECTING,
+	SPRDWL_CONNECTED
+};
+
+enum sprdwl_head_type {
+	SPRDWL_TYPE_CMD,
+	SPRDWL_TYPE_EVENT,
+	SPRDWL_TYPE_DATA,
+	SPRDWL_TYPE_DATA_SPECIAL
+};
+
+/* struct sprdwl_msg_list: the list for management of command/data
+ * @freelist: list of data to be free
+ * @busylist: list of data in used
+ * @cmd_to_free: list of cmd to be free
+ * @maxnum: max number of list
+ * @ref: reference number of list
+ * @flow: data flow contrl
+ */
+struct sprdwl_msg_list {
+	struct list_head freelist;
+	struct list_head busylist;
+	struct list_head cmd_to_free;
+	int maxnum;
+	atomic_t ref;
+	atomic_t flow;
+};
+
+/* struct sprdwl_msg_buf: to manage socket buffer
+ * @list: list head of this skb belong to
+ * @skb: socket buffer
+ * @data: data of socket buffer
+ * @tran_data: data to be transferred
+ * @type: type of this buffer
+ * @mode: indicate which mode this skb data belong to
+ * @len: socket buffer length
+ * @timeout: value of data time out in list
+ * @fifo_id: identity of fifo
+ * @msglist: indicate which list the socket buffer assign to
+ * @buffer_type: type of this socket buffer
+ * @data_list: type of this socket buffer
+ * @xmit_msg_list: list to manage transmit data list
+ * @msg_type: indicate type of this buffer
+ */
+struct sprdwl_msg_buf {
+	struct list_head list;
+	struct sk_buff *skb;
+	void *data;
+	void *tran_data;
+	u8 type;
+	u8 mode;
+	u16 len;
+	unsigned long timeout;
+	unsigned int fifo_id;
+	struct sprdwl_msg_list *msglist;
+	unsigned char buffer_type;
+	struct peer_list *data_list;
+	struct sprdwl_xmit_msg_list *xmit_msg_list;
+	unsigned char msg_type;
+};
+#endif
diff --git a/drivers/net/wireless/sprd/wireless.h b/drivers/net/wireless/sprd/wireless.h
index 000000000000..152a5c231a7b
--- /dev/null
+++ b/drivers/net/wireless/sprd/wireless.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+//
+// Wi-Fi driver of the Unisoc for Marlin3 chip:
+// Unisoc's private data structure
+//
+// Copyright(C) 2018 Unisoc,Inc.
+
+#ifndef __SPRDWL_H__
+#define __SPRDWL_H__
+
+#include <net/cfg80211.h>
+#include <linux/inetdevice.h>
+#include <linux/spinlock.h>
+#include <linux/wireless.h>
+#include "interface.h"
+
+/* struct sprdwl_vif: describe the wifi virtual interface
+ * @ndev: net device
+ * @wdev: wireless device
+ * @priv: sprdwl private structure
+ * @mode: Wi-Fi working mode
+ * @vif_node: node for virtual interface list
+ * @ref: reference of virtual interface
+ * @ctx_id: wifi context index of stap mode
+ */
+struct sprdwl_vif {
+	struct net_device *ndev;
+	struct wireless_dev wdev;
+	struct sprdwl_priv *priv;
+	enum sprdwl_mode mode;
+	struct list_head vif_node;
+	int ref;
+	u8 ctx_id;
+};
+
+enum sprdwl_hw_type {
+	SPRDWL_HW_SDIO,
+	SPRDWL_HW_SIPC,
+	SPRDWL_HW_SDIO_BA,
+	SPRDWL_HW_SC2355_SDIO,
+	SPRDWL_HW_SC2355_PCIE
+};
+
+/* struct sprdwl_priv: describe the unisoc private structure
+ * @wiphy: wiphy of net device
+ * @vif_list: list of virtual interface
+ * @hw_priv: hardware private structure
+ * @hw_type: hardware type
+ * @ hw_offset: hardware data offset
+ * @if_ops: interface operations
+ */
+struct sprdwl_priv {
+	struct wiphy *wiphy;
+	struct list_head vif_list;
+	void *hw_priv;
+	enum sprdwl_hw_type hw_type;
+	int hw_offset;
+	struct sprdwl_if_ops *if_ops;
+};
+
+extern struct device *sprdwl_dev;
+
+struct sprdwl_priv *sprdwl_core_create(enum sprdwl_hw_type type,
+				       struct sprdwl_if_ops *ops);
+void sprdwl_core_free(struct sprdwl_priv *priv);
+int sprdwl_core_init(struct device *dev, struct sprdwl_priv *priv);
+int sprdwl_core_deinit(struct sprdwl_priv *priv);
+#endif
+
-- 
2.28.0

