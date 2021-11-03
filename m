Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2217444052
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhKCLGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhKCLGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 07:06:21 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18AAC061714;
        Wed,  3 Nov 2021 04:03:44 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j9so2072494pgh.1;
        Wed, 03 Nov 2021 04:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=m/Vu4suyDVv6ckui0T7VVN0vA5Rhii/d7ug9dMW1dTI=;
        b=RMQ0k9JkQJrvhOzEoSnJvOX1G8yj4GS4cEq4iIZMueJTOTJrD8jI5f/wW1Rd8JfZU5
         amNTbOalGaYqwrzqCpWRLcVw8acnIO6FzxfHmMeZm3Qbed/FgRqoKjwHsIN5BwkUo818
         epS6aKztV6yrLEKJTxjkIm+iQgCl1OZAKXJQnTPPbFxgYKuzTrrGkt1djPO9ZCLqwvl0
         jvXKZ7VJEYNS8giI+Cd/gM+MwWlV9olmLKhrBZ1qEM2Buz81XhGSJiMPolxEgf86EmE3
         Z30+AI8lnsToket8alujhCUnAylE5DBGl7LVylegwcrooV14IUJHTHb07UjjjLX4LHmQ
         TISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=m/Vu4suyDVv6ckui0T7VVN0vA5Rhii/d7ug9dMW1dTI=;
        b=zr0XndZdmJgUbBCSMsyY4gN83T1YkUTGQ+wd0VHjXYSnNBORe0l+mMnBVCfmzg68sH
         oMXkQr21btxIeiabvW4iGr+dS+h1kXCb3GTsA20nOUAlcPGSwga68AqeLCiDL6Q2A8ex
         AW+RnkwInt+BN37XMhh8ov/Zj4UaGPdNN+OAijpITGcSwyF7k378XgaaNfVZ7TW5Nr/1
         xtsQemynCmPETAtm6hx+1w7ZHqkK3uXdy3w91HufegpAQwqS5CW31BkRYmOipOu4dJcK
         BwsCFnIhgZDqUwFMvnLMb4PtRttGQSPwOI2s8E6PFHKG+5RRI7+qoVXTwo4j5z/Ho8x4
         pkSg==
X-Gm-Message-State: AOAM533gbQu+bCH1xkk6L4C/57s/WXk3DTQTywk1jSZElqCUb+RLtwCR
        Xgr2iZlGD9trOVy2oB226L5paEpkO799DA==
X-Google-Smtp-Source: ABdhPJy8BAbZSUc++Belh3VemlExa2HajpP9ix7XDoOKFOAnS32/bL5ZxscB9Lx8cRNvYUKK7k0XKw==
X-Received: by 2002:aa7:9f06:0:b0:480:f8b2:c6ff with SMTP id g6-20020aa79f06000000b00480f8b2c6ffmr26556223pfr.62.1635937423528;
        Wed, 03 Nov 2021 04:03:43 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id qe16sm2440222pjb.5.2021.11.03.04.03.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Nov 2021 04:03:43 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
X-Google-Original-From: Wells Lu <wells.lu@sunplus.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     Wells Lu <wells.lu@sunplus.com>
Subject: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Date:   Wed,  3 Nov 2021 19:02:45 +0800
Message-Id: <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1635936610.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
In-Reply-To: <cover.1635936610.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Ethernet driver for Sunplus SP7021.

Signed-off-by: Wells Lu <wells.lu@sunplus.com>
---
 MAINTAINERS                                  |   1 +
 drivers/net/ethernet/Kconfig                 |   1 +
 drivers/net/ethernet/Makefile                |   1 +
 drivers/net/ethernet/sunplus/Kconfig         |  20 +
 drivers/net/ethernet/sunplus/Makefile        |   6 +
 drivers/net/ethernet/sunplus/l2sw_define.h   | 221 ++++++++
 drivers/net/ethernet/sunplus/l2sw_desc.c     | 233 ++++++++
 drivers/net/ethernet/sunplus/l2sw_desc.h     |  21 +
 drivers/net/ethernet/sunplus/l2sw_driver.c   | 779 +++++++++++++++++++++++++++
 drivers/net/ethernet/sunplus/l2sw_driver.h   |  23 +
 drivers/net/ethernet/sunplus/l2sw_hal.c      | 422 +++++++++++++++
 drivers/net/ethernet/sunplus/l2sw_hal.h      |  47 ++
 drivers/net/ethernet/sunplus/l2sw_int.c      | 326 +++++++++++
 drivers/net/ethernet/sunplus/l2sw_int.h      |  16 +
 drivers/net/ethernet/sunplus/l2sw_mac.c      |  68 +++
 drivers/net/ethernet/sunplus/l2sw_mac.h      |  24 +
 drivers/net/ethernet/sunplus/l2sw_mdio.c     | 118 ++++
 drivers/net/ethernet/sunplus/l2sw_mdio.h     |  19 +
 drivers/net/ethernet/sunplus/l2sw_register.h |  99 ++++
 19 files changed, 2445 insertions(+)
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/l2sw_register.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 4669c16..ca676ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18006,6 +18006,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 W:	https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
 F:	Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml
+F:	drivers/net/ethernet/sunplus/
 
 SUPERH
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 412ae3e..0084852 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -176,6 +176,7 @@ source "drivers/net/ethernet/smsc/Kconfig"
 source "drivers/net/ethernet/socionext/Kconfig"
 source "drivers/net/ethernet/stmicro/Kconfig"
 source "drivers/net/ethernet/sun/Kconfig"
+source "drivers/net/ethernet/sunplus/Kconfig"
 source "drivers/net/ethernet/synopsys/Kconfig"
 source "drivers/net/ethernet/tehuti/Kconfig"
 source "drivers/net/ethernet/ti/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index aaa5078..e4ce162 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_NET_VENDOR_SMSC) += smsc/
 obj-$(CONFIG_NET_VENDOR_SOCIONEXT) += socionext/
 obj-$(CONFIG_NET_VENDOR_STMICRO) += stmicro/
 obj-$(CONFIG_NET_VENDOR_SUN) += sun/
+obj-$(CONFIG_NET_VENDOR_SUNPLUS) += sunplus/
 obj-$(CONFIG_NET_VENDOR_TEHUTI) += tehuti/
 obj-$(CONFIG_NET_VENDOR_TI) += ti/
 obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
diff --git a/drivers/net/ethernet/sunplus/Kconfig b/drivers/net/ethernet/sunplus/Kconfig
new file mode 100644
index 0000000..a9e3a4c
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Sunplus Ethernet device configuration
+#
+
+config NET_VENDOR_SUNPLUS
+	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"
+	depends on ETHERNET && SOC_SP7021
+	select PHYLIB
+	select PINCTRL_SPPCTL
+	select COMMON_CLK_SP7021
+	select RESET_SUNPLUS
+	select NVMEM_SUNPLUS_OCOTP
+	help
+	  If you have Sunplus dual 10M/100M Ethernet (with L2 switch)
+	  devices, say Y.
+	  The network device supports dual 10M/100M Ethernet interfaces,
+	  or one 10/100M Ethernet interface with two LAN ports.
+	  To compile this driver as a module, choose M here.  The module
+	  will be called sp_l2sw.
diff --git a/drivers/net/ethernet/sunplus/Makefile b/drivers/net/ethernet/sunplus/Makefile
new file mode 100644
index 0000000..b401cec
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Sunplus network device drivers.
+#
+obj-$(CONFIG_NET_VENDOR_SUNPLUS) += sp_l2sw.o
+sp_l2sw-objs := l2sw_driver.o l2sw_int.o l2sw_hal.o l2sw_desc.o l2sw_mac.o l2sw_mdio.o
diff --git a/drivers/net/ethernet/sunplus/l2sw_define.h b/drivers/net/ethernet/sunplus/l2sw_define.h
new file mode 100644
index 0000000..c1049c5
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_define.h
@@ -0,0 +1,221 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_DEFINE_H__
+#define __L2SW_DEFINE_H__
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/kdev_t.h>
+#include <linux/in.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/skbuff.h>
+#include <linux/ethtool.h>
+#include <linux/platform_device.h>
+#include <linux/phy.h>
+#include <linux/mii.h>
+#include <linux/if_vlan.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/of_address.h>
+#include <linux/of_mdio.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt)     "[L2SW]" fmt
+
+//define MAC interrupt status bit
+#define MAC_INT_DAISY_MODE_CHG          BIT(31)
+#define MAC_INT_IP_CHKSUM_ERR           BIT(23)
+#define MAC_INT_WDOG_TIMER1_EXP         BIT(22)
+#define MAC_INT_WDOG_TIMER0_EXP         BIT(21)
+#define MAC_INT_INTRUDER_ALERT          BIT(20)
+#define MAC_INT_PORT_ST_CHG             BIT(19)
+#define MAC_INT_BC_STORM                BIT(18)
+#define MAC_INT_MUST_DROP_LAN           BIT(17)
+#define MAC_INT_GLOBAL_QUE_FULL         BIT(16)
+#define MAC_INT_TX_SOC_PAUSE_ON         BIT(15)
+#define MAC_INT_RX_SOC_QUE_FULL         BIT(14)
+#define MAC_INT_TX_LAN1_QUE_FULL        BIT(9)
+#define MAC_INT_TX_LAN0_QUE_FULL        BIT(8)
+#define MAC_INT_RX_L_DESCF              BIT(7)
+#define MAC_INT_RX_H_DESCF              BIT(6)
+#define MAC_INT_RX_DONE_L               BIT(5)
+#define MAC_INT_RX_DONE_H               BIT(4)
+#define MAC_INT_TX_DONE_L               BIT(3)
+#define MAC_INT_TX_DONE_H               BIT(2)
+#define MAC_INT_TX_DES_ERR              BIT(1)
+#define MAC_INT_RX_DES_ERR              BIT(0)
+
+#define MAC_INT_RX                      (MAC_INT_RX_DONE_H | MAC_INT_RX_DONE_L | \
+					MAC_INT_RX_DES_ERR)
+#define MAC_INT_TX                      (MAC_INT_TX_DONE_L | MAC_INT_TX_DONE_H | \
+					MAC_INT_TX_DES_ERR)
+#define MAC_INT_MASK_DEF                (MAC_INT_DAISY_MODE_CHG | MAC_INT_IP_CHKSUM_ERR | \
+					MAC_INT_WDOG_TIMER1_EXP | MAC_INT_WDOG_TIMER0_EXP | \
+					MAC_INT_INTRUDER_ALERT | MAC_INT_BC_STORM | \
+					MAC_INT_MUST_DROP_LAN | MAC_INT_GLOBAL_QUE_FULL | \
+					MAC_INT_TX_SOC_PAUSE_ON | MAC_INT_RX_SOC_QUE_FULL | \
+					MAC_INT_TX_LAN1_QUE_FULL | MAC_INT_TX_LAN0_QUE_FULL | \
+					MAC_INT_RX_L_DESCF | MAC_INT_RX_H_DESCF)
+
+/*define port ability*/
+#define PORT_ABILITY_LINK_ST_P1         BIT(25)
+#define PORT_ABILITY_LINK_ST_P0         BIT(24)
+
+/*define PHY command bit*/
+#define PHY_WT_DATA_MASK                0xffff0000
+#define PHY_RD_CMD                      0x00004000
+#define PHY_WT_CMD                      0x00002000
+#define PHY_REG_MASK                    0x00001f00
+#define PHY_ADR_MASK                    0x0000001f
+
+/*define PHY status bit*/
+#define PHY_RD_DATA_MASK                0xffff0000
+#define PHY_RD_RDY                      BIT(1)
+#define PHY_WT_DONE                     BIT(0)
+
+/*define other register bit*/
+#define RX_MAX_LEN_MASK                 0x00011000
+#define ROUTE_MODE_MASK                 0x00000060
+#define POK_INT_THS_MASK                0x000E0000
+#define VLAN_TH_MASK                    0x00000007
+
+/*define tx descriptor bit*/
+#define OWN_BIT                         BIT(31)
+#define FS_BIT                          BIT(25)
+#define LS_BIT                          BIT(24)
+#define LEN_MASK                        0x000007FF
+#define PKTSP_MASK                      0x00007000
+#define PKTSP_PORT1                     0x00001000
+#define TO_VLAN_MASK                    0x0003F000
+#define TO_VLAN_GROUP1                  0x00002000
+
+#define EOR_BIT                         BIT(31)
+
+/*define rx descriptor bit*/
+#define ERR_CODE                        (0xf << 26)
+#define RX_TCP_UDP_CHKSUM_BIT           BIT(23)
+#define RX_IP_CHKSUM_BIT                BIT(18)
+
+#define OWC_BIT                         BIT(31)
+#define TXOK_BIT                        BIT(26)
+#define LNKF_BIT                        BIT(25)
+#define BUR_BIT                         BIT(22)
+#define TWDE_BIT                        BIT(20)
+#define CC_MASK                         0x000f0000
+#define TBE_MASK                        0x00070000
+
+// Address table search
+#define MAC_ADDR_LOOKUP_IDLE            BIT(2)
+#define MAC_SEARCH_NEXT_ADDR            BIT(1)
+#define MAC_BEGIN_SEARCH_ADDR           BIT(0)
+
+// Address table search
+#define MAC_HASK_LOOKUP_ADDR_MASK       (0x3ff << 22)
+#define MAC_AT_TABLE_END                BIT(1)
+#define MAC_AT_DATA_READY               BIT(0)
+
+#define MAC_PHY_ADDR                    0x01	/* define by hardware */
+
+/*config descriptor*/
+#define TX_DESC_NUM                     16
+#define MAC_GUARD_DESC_NUM              2
+#define RX_QUEUE0_DESC_NUM              16
+#define RX_QUEUE1_DESC_NUM              16
+#define TX_DESC_QUEUE_NUM               1
+#define RX_DESC_QUEUE_NUM               2
+
+#define MAC_TX_BUFF_SIZE                1536
+#define MAC_RX_LEN_MAX                  2047
+
+#define DESC_ALIGN_BYTE                 32
+#define RX_OFFSET                       0
+#define TX_OFFSET                       0
+
+#define ETHERNET_MAC_ADDR_LEN           6
+
+struct mac_desc {
+	u32 cmd1;
+	u32 cmd2;
+	u32 addr1;
+	u32 addr2;
+};
+
+struct skb_info {
+	struct sk_buff *skb;
+	u32 mapping;
+	u32 len;
+};
+
+struct l2sw_common {
+	struct net_device *net_dev;
+	struct platform_device *pdev;
+	int dual_nic;
+	int sa_learning;
+
+	void *desc_base;
+	dma_addr_t desc_dma;
+	s32 desc_size;
+	struct clk *clk;
+	struct reset_control *rstc;
+	int irq;
+
+	struct mac_desc *rx_desc[RX_DESC_QUEUE_NUM];
+	struct skb_info *rx_skb_info[RX_DESC_QUEUE_NUM];
+	u32 rx_pos[RX_DESC_QUEUE_NUM];
+	u32 rx_desc_num[RX_DESC_QUEUE_NUM];
+	u32 rx_desc_buff_size;
+
+	struct mac_desc *tx_desc;
+	struct skb_info tx_temp_skb_info[TX_DESC_NUM];
+	u32 tx_done_pos;
+	u32 tx_pos;
+	u32 tx_desc_full;
+
+	struct mii_bus *mii_bus;
+	struct phy_device *phy_dev;
+
+	struct napi_struct rx_napi;
+	struct napi_struct tx_napi;
+
+	spinlock_t rx_lock;      // spinlock for accessing rx buffer
+	spinlock_t tx_lock;      // spinlock for accessing tx buffer
+	spinlock_t ioctl_lock;   // spinlock for ioctl operations
+	struct mutex store_mode; // mutex for dynamic mode change
+
+	struct device_node *phy1_node;
+	struct device_node *phy2_node;
+	u8 phy1_addr;
+	u8 phy2_addr;
+
+	u8 enable;
+};
+
+struct l2sw_mac {
+	struct platform_device *pdev;
+	struct net_device *net_dev;
+	struct l2sw_common *comm;
+	struct net_device *next_netdev;
+
+	struct net_device_stats dev_stats;
+
+	u8 mac_addr[ETHERNET_MAC_ADDR_LEN];
+
+	u8 lan_port;
+	u8 to_vlan;
+	u8 cpu_port;
+	u8 vlan_id;
+};
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/l2sw_desc.c b/drivers/net/ethernet/sunplus/l2sw_desc.c
new file mode 100644
index 0000000..345738f
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_desc.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "l2sw_desc.h"
+#include "l2sw_define.h"
+
+void rx_descs_flush(struct l2sw_common *comm)
+{
+	u32 i, j;
+	struct mac_desc *rx_desc;
+	struct skb_info *rx_skbinfo;
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
+		rx_desc = comm->rx_desc[i];
+		rx_skbinfo = comm->rx_skb_info[i];
+		for (j = 0; j < comm->rx_desc_num[i]; j++) {
+			rx_desc[j].addr1 = rx_skbinfo[j].mapping;
+			rx_desc[j].cmd2 = (j == comm->rx_desc_num[i] - 1) ?
+					  EOR_BIT | comm->rx_desc_buff_size :
+					  comm->rx_desc_buff_size;
+			wmb();	// Set OWN_BIT after other fields are ready.
+			rx_desc[j].cmd1 = OWN_BIT;
+		}
+	}
+}
+
+void tx_descs_clean(struct l2sw_common *comm)
+{
+	u32 i;
+	s32 buflen;
+
+	if (!comm->tx_desc)
+		return;
+
+	for (i = 0; i < TX_DESC_NUM; i++) {
+		comm->tx_desc[i].cmd1 = 0;
+		wmb();		// Clear OWN_BIT and then set other fields.
+		comm->tx_desc[i].cmd2 = 0;
+		comm->tx_desc[i].addr1 = 0;
+		comm->tx_desc[i].addr2 = 0;
+
+		if (comm->tx_temp_skb_info[i].mapping) {
+			buflen = (comm->tx_temp_skb_info[i].skb) ?
+				 comm->tx_temp_skb_info[i].skb->len :
+				 MAC_TX_BUFF_SIZE;
+			dma_unmap_single(&comm->pdev->dev, comm->tx_temp_skb_info[i].mapping,
+					 buflen, DMA_TO_DEVICE);
+			comm->tx_temp_skb_info[i].mapping = 0;
+		}
+
+		if (comm->tx_temp_skb_info[i].skb) {
+			dev_kfree_skb(comm->tx_temp_skb_info[i].skb);
+			comm->tx_temp_skb_info[i].skb = NULL;
+		}
+	}
+}
+
+void rx_descs_clean(struct l2sw_common *comm)
+{
+	u32 i, j;
+	struct mac_desc *rx_desc;
+	struct skb_info *rx_skbinfo;
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
+		if (!comm->rx_skb_info[i])
+			continue;
+
+		rx_desc = comm->rx_desc[i];
+		rx_skbinfo = comm->rx_skb_info[i];
+		for (j = 0; j < comm->rx_desc_num[i]; j++) {
+			rx_desc[j].cmd1 = 0;
+			wmb();	// Clear OWN_BIT and then set other fields.
+			rx_desc[j].cmd2 = 0;
+			rx_desc[j].addr1 = 0;
+
+			if (rx_skbinfo[j].skb) {
+				dma_unmap_single(&comm->pdev->dev, rx_skbinfo[j].mapping,
+						 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
+				dev_kfree_skb(rx_skbinfo[j].skb);
+				rx_skbinfo[j].skb = NULL;
+				rx_skbinfo[j].mapping = 0;
+			}
+		}
+
+		kfree(rx_skbinfo);
+		comm->rx_skb_info[i] = NULL;
+	}
+}
+
+void descs_clean(struct l2sw_common *comm)
+{
+	rx_descs_clean(comm);
+	tx_descs_clean(comm);
+}
+
+void descs_free(struct l2sw_common *comm)
+{
+	u32 i;
+
+	descs_clean(comm);
+	comm->tx_desc = NULL;
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
+		comm->rx_desc[i] = NULL;
+
+	/*  Free descriptor area  */
+	if (comm->desc_base) {
+		dma_free_coherent(&comm->pdev->dev, comm->desc_size, comm->desc_base,
+				  comm->desc_dma);
+		comm->desc_base = NULL;
+		comm->desc_dma = 0;
+		comm->desc_size = 0;
+	}
+}
+
+u32 tx_descs_init(struct l2sw_common *comm)
+{
+	memset(comm->tx_desc, '\0', sizeof(struct mac_desc) * (TX_DESC_NUM + MAC_GUARD_DESC_NUM));
+	return 0;
+}
+
+u32 rx_descs_init(struct l2sw_common *comm)
+{
+	struct sk_buff *skb;
+	u32 i, j;
+	struct mac_desc *rx_desc;
+	struct skb_info *rx_skbinfo;
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
+		comm->rx_skb_info[i] = kmalloc_array(comm->rx_desc_num[i],
+						     sizeof(struct skb_info), GFP_KERNEL);
+		if (!comm->rx_skb_info[i])
+			goto MEM_ALLOC_FAIL;
+
+		rx_skbinfo = comm->rx_skb_info[i];
+		rx_desc = comm->rx_desc[i];
+		for (j = 0; j < comm->rx_desc_num[i]; j++) {
+			skb = __dev_alloc_skb(comm->rx_desc_buff_size + RX_OFFSET,
+					      GFP_ATOMIC | GFP_DMA);
+			if (!skb)
+				goto MEM_ALLOC_FAIL;
+
+			skb->dev = comm->net_dev;
+			skb_reserve(skb, RX_OFFSET);	/* +data +tail */
+
+			rx_skbinfo[j].skb = skb;
+			rx_skbinfo[j].mapping = dma_map_single(&comm->pdev->dev, skb->data,
+							       comm->rx_desc_buff_size,
+							       DMA_FROM_DEVICE);
+			rx_desc[j].addr1 = rx_skbinfo[j].mapping;
+			rx_desc[j].addr2 = 0;
+			rx_desc[j].cmd2 = (j == comm->rx_desc_num[i] - 1) ?
+					  EOR_BIT | comm->rx_desc_buff_size :
+					  comm->rx_desc_buff_size;
+			wmb();	// Set OWN_BIT after other fields are effective.
+			rx_desc[j].cmd1 = OWN_BIT;
+		}
+	}
+
+	return 0;
+
+MEM_ALLOC_FAIL:
+	rx_descs_clean(comm);
+	return -ENOMEM;
+}
+
+u32 descs_alloc(struct l2sw_common *comm)
+{
+	u32 i;
+	s32 desc_size;
+
+	/* Alloc descriptor area  */
+	desc_size = (TX_DESC_NUM + MAC_GUARD_DESC_NUM) * sizeof(struct mac_desc);
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
+		desc_size += comm->rx_desc_num[i] * sizeof(struct mac_desc);
+
+	comm->desc_base = dma_alloc_coherent(&comm->pdev->dev, desc_size, &comm->desc_dma,
+					     GFP_KERNEL);
+	if (!comm->desc_base)
+		return -ENOMEM;
+
+	comm->desc_size = desc_size;
+
+	/* Setup Tx descriptor */
+	comm->tx_desc = (struct mac_desc *)comm->desc_base;
+
+	/* Setup Rx descriptor */
+	comm->rx_desc[0] = &comm->tx_desc[TX_DESC_NUM + MAC_GUARD_DESC_NUM];
+	for (i = 1; i < RX_DESC_QUEUE_NUM; i++)
+		comm->rx_desc[i] = comm->rx_desc[i - 1] + comm->rx_desc_num[i - 1];
+
+	return 0;
+}
+
+u32 descs_init(struct l2sw_common *comm)
+{
+	u32 i, rc;
+
+	// Initialize rx descriptor's data
+	comm->rx_desc_num[0] = RX_QUEUE0_DESC_NUM;
+#if RX_DESC_QUEUE_NUM > 1
+	comm->rx_desc_num[1] = RX_QUEUE1_DESC_NUM;
+#endif
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
+		comm->rx_desc[i] = NULL;
+		comm->rx_skb_info[i] = NULL;
+		comm->rx_pos[i] = 0;
+	}
+	comm->rx_desc_buff_size = MAC_RX_LEN_MAX;
+
+	// Initialize tx descriptor's data
+	comm->tx_done_pos = 0;
+	comm->tx_desc = NULL;
+	comm->tx_pos = 0;
+	comm->tx_desc_full = 0;
+	for (i = 0; i < TX_DESC_NUM; i++)
+		comm->tx_temp_skb_info[i].skb = NULL;
+
+	// Allocate tx & rx descriptors.
+	rc = descs_alloc(comm);
+	if (rc) {
+		pr_err(" Failed to allocate tx & rx descriptors!\n");
+		return rc;
+	}
+
+	rc = tx_descs_init(comm);
+	if (rc)
+		return rc;
+
+	return rx_descs_init(comm);
+}
diff --git a/drivers/net/ethernet/sunplus/l2sw_desc.h b/drivers/net/ethernet/sunplus/l2sw_desc.h
new file mode 100644
index 0000000..d0647cb
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_desc.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_DESC_H__
+#define __L2SW_DESC_H__
+
+#include "l2sw_define.h"
+
+void rx_descs_flush(struct l2sw_common *comm);
+void tx_descs_clean(struct l2sw_common *comm);
+void rx_descs_clean(struct l2sw_common *comm);
+void descs_clean(struct l2sw_common *comm);
+void descs_free(struct l2sw_common *comm);
+u32 tx_descs_init(struct l2sw_common *comm);
+u32 rx_descs_init(struct l2sw_common *comm);
+u32 descs_alloc(struct l2sw_common *comm);
+u32 descs_init(struct l2sw_common *comm);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/l2sw_driver.c b/drivers/net/ethernet/sunplus/l2sw_driver.c
new file mode 100644
index 0000000..3dfd0dd
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_driver.c
@@ -0,0 +1,779 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include <linux/clk.h>
+#include <linux/reset.h>
+#include <linux/nvmem-consumer.h>
+#include "l2sw_driver.h"
+
+static const char def_mac_addr[ETHERNET_MAC_ADDR_LEN] = {
+	0x88, 0x88, 0x88, 0x88, 0x88, 0x80
+};
+
+/*********************************************************************
+ *
+ * net_device_ops
+ *
+ **********************************************************************/
+static int ethernet_open(struct net_device *net_dev)
+{
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+
+	pr_debug(" Open port = %x\n", mac->lan_port);
+
+	mac->comm->enable |= mac->lan_port;
+
+	mac_hw_start(mac);
+	write_sw_int_mask0(read_sw_int_mask0() & ~(MAC_INT_TX | MAC_INT_RX));
+
+	netif_carrier_on(net_dev);
+	if (netif_carrier_ok(net_dev)) {
+		pr_debug(" Open netif_start_queue.\n");
+		netif_start_queue(net_dev);
+	}
+
+	return 0;
+}
+
+static int ethernet_stop(struct net_device *net_dev)
+{
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+
+	netif_stop_queue(net_dev);
+	netif_carrier_off(net_dev);
+
+	mac->comm->enable &= ~mac->lan_port;
+
+	mac_hw_stop(mac);
+
+	return 0;
+}
+
+/* Transmit a packet (called by the kernel) */
+static int ethernet_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
+{
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+	struct l2sw_common *comm = mac->comm;
+	u32 tx_pos;
+	u32 cmd1;
+	u32 cmd2;
+	struct mac_desc *txdesc;
+	struct skb_info *skbinfo;
+	unsigned long flags;
+
+	if (unlikely(comm->tx_desc_full == 1)) {	/* no desc left, wait for tx interrupt */
+		pr_err(" TX descriptor queue full when xmit!\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	/* if skb size shorter than 60, fill it with '\0' */
+	if (unlikely(skb->len < ETH_ZLEN)) {
+		if (skb_tailroom(skb) >= (ETH_ZLEN - skb->len)) {
+			memset(__skb_put(skb, ETH_ZLEN - skb->len), '\0', ETH_ZLEN - skb->len);
+		} else {
+			struct sk_buff *old_skb = skb;
+
+			skb = dev_alloc_skb(ETH_ZLEN + TX_OFFSET);
+			if (skb) {
+				memset(skb->data + old_skb->len, '\0', ETH_ZLEN - old_skb->len);
+				memcpy(skb->data, old_skb->data, old_skb->len);
+				skb_put(skb, ETH_ZLEN);	/* add data to an sk_buff */
+				dev_kfree_skb_irq(old_skb);
+			} else {
+				skb = old_skb;
+			}
+		}
+	}
+
+	spin_lock_irqsave(&mac->comm->tx_lock, flags);
+	tx_pos = comm->tx_pos;
+	txdesc = &comm->tx_desc[tx_pos];
+	skbinfo = &comm->tx_temp_skb_info[tx_pos];
+	skbinfo->len = skb->len;
+	skbinfo->skb = skb;
+	skbinfo->mapping = dma_map_single(&mac->pdev->dev, skb->data, skb->len, DMA_TO_DEVICE);
+	cmd1 = (OWN_BIT | FS_BIT | LS_BIT | (mac->to_vlan << 12) | (skb->len & LEN_MASK));
+	cmd2 = skb->len & LEN_MASK;
+
+	if (tx_pos == (TX_DESC_NUM - 1))
+		cmd2 |= EOR_BIT;
+
+	txdesc->addr1 = skbinfo->mapping;
+	txdesc->cmd2 = cmd2;
+	wmb();			// Set OWN_BIT after other fields of descriptor are effective.
+	txdesc->cmd1 = cmd1;
+
+	NEXT_TX(tx_pos);
+
+	if (unlikely(tx_pos == comm->tx_done_pos)) {
+		netif_stop_queue(net_dev);
+		comm->tx_desc_full = 1;
+		//pr_info(" TX Descriptor Queue Full!\n");
+	}
+	comm->tx_pos = tx_pos;
+	wmb();			// make sure settings are effective.
+
+	/* trigger gmac to transmit */
+	tx_trigger();
+
+	spin_unlock_irqrestore(&mac->comm->tx_lock, flags);
+	return NETDEV_TX_OK;
+}
+
+static void ethernet_set_rx_mode(struct net_device *net_dev)
+{
+	if (net_dev) {
+		struct l2sw_mac *mac = netdev_priv(net_dev);
+		struct l2sw_common *comm = mac->comm;
+		unsigned long flags;
+
+		spin_lock_irqsave(&comm->ioctl_lock, flags);
+		rx_mode_set(net_dev);
+		spin_unlock_irqrestore(&comm->ioctl_lock, flags);
+	}
+}
+
+static int ethernet_set_mac_address(struct net_device *net_dev, void *addr)
+{
+	struct sockaddr *hwaddr = (struct sockaddr *)addr;
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+
+	if (netif_running(net_dev)) {
+		pr_err(" Device %s is busy!\n", net_dev->name);
+		return -EBUSY;
+	}
+
+	memcpy(net_dev->dev_addr, hwaddr->sa_data, net_dev->addr_len);
+
+	/* Delete the old Ethernet MAC address */
+	pr_debug(" HW Addr = %pM\n", mac->mac_addr);
+	if (is_valid_ether_addr(mac->mac_addr))
+		mac_hw_addr_del(mac);
+
+	/* Set the Ethernet MAC address */
+	memcpy(mac->mac_addr, hwaddr->sa_data, net_dev->addr_len);
+	mac_hw_addr_set(mac);
+
+	return 0;
+}
+
+static int ethernet_do_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
+{
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+	struct l2sw_common *comm = mac->comm;
+	struct mii_ioctl_data *data = if_mii(ifr);
+	unsigned long flags;
+
+	pr_debug(" if = %s, cmd = %04x\n", ifr->ifr_ifrn.ifrn_name, cmd);
+	pr_debug(" phy_id = %d, reg_num = %d, val_in = %04x\n", data->phy_id,
+		 data->reg_num, data->val_in);
+
+	// Check parameters' range.
+	if ((cmd == SIOCGMIIREG) || (cmd == SIOCSMIIREG)) {
+		if (data->reg_num > 31) {
+			pr_err(" reg_num (= %d) excesses range!\n", (int)data->reg_num);
+			return -EINVAL;
+		}
+	}
+
+	switch (cmd) {
+	case SIOCGMIIPHY:
+		if (comm->dual_nic && (strcmp(ifr->ifr_ifrn.ifrn_name, "eth1") == 0))
+			return comm->phy2_addr;
+		else
+			return comm->phy1_addr;
+
+	case SIOCGMIIREG:
+		spin_lock_irqsave(&comm->ioctl_lock, flags);
+		data->val_out = mdio_read(data->phy_id, data->reg_num);
+		spin_unlock_irqrestore(&comm->ioctl_lock, flags);
+		pr_debug(" val_out = %04x\n", data->val_out);
+		break;
+
+	case SIOCSMIIREG:
+		spin_lock_irqsave(&comm->ioctl_lock, flags);
+		mdio_write(data->phy_id, data->reg_num, data->val_in);
+		spin_unlock_irqrestore(&comm->ioctl_lock, flags);
+		break;
+
+	default:
+		pr_err(" ioctl #%d has not implemented yet!\n", cmd);
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static int ethernet_change_mtu(struct net_device *ndev, int new_mtu)
+{
+	if (netif_running(ndev))
+		return -EBUSY;
+
+	if (new_mtu < 68 || new_mtu > ETH_DATA_LEN)
+		return -EINVAL;
+
+	ndev->mtu = new_mtu;
+
+	return 0;
+}
+
+static void ethernet_tx_timeout(struct net_device *net_dev, unsigned int txqueue)
+{
+}
+
+static struct net_device_stats *ethernet_get_stats(struct net_device *net_dev)
+{
+	struct l2sw_mac *mac;
+
+	mac = netdev_priv(net_dev);
+	return &mac->dev_stats;
+}
+
+static const struct net_device_ops netdev_ops = {
+	.ndo_open = ethernet_open,
+	.ndo_stop = ethernet_stop,
+	.ndo_start_xmit = ethernet_start_xmit,
+	.ndo_set_rx_mode = ethernet_set_rx_mode,
+	.ndo_set_mac_address = ethernet_set_mac_address,
+	.ndo_do_ioctl = ethernet_do_ioctl,
+	.ndo_change_mtu = ethernet_change_mtu,
+	.ndo_tx_timeout = ethernet_tx_timeout,
+	.ndo_get_stats = ethernet_get_stats,
+};
+
+char *sp7021_otp_read_mac(struct device *_d, ssize_t *_l, char *_name)
+{
+	char *ret = NULL;
+	struct nvmem_cell *c = nvmem_cell_get(_d, _name);
+
+	if (IS_ERR_OR_NULL(c)) {
+		pr_err(" OTP %s read failure: %ld", _name, PTR_ERR(c));
+		return NULL;
+	}
+
+	ret = nvmem_cell_read(c, _l);
+	nvmem_cell_put(c);
+	pr_debug(" %zd bytes are read from OTP %s.", *_l, _name);
+
+	return ret;
+}
+
+static void check_mac_vendor_id_and_convert(char *mac_addr)
+{
+	// Byte order of MAC address of some samples are reversed.
+	// Check vendor id and convert byte order if it is wrong.
+	if ((mac_addr[5] == 0xFC) && (mac_addr[4] == 0x4B) && (mac_addr[3] == 0xBC) &&
+	    ((mac_addr[0] != 0xFC) || (mac_addr[1] != 0x4B) || (mac_addr[2] != 0xBC))) {
+		char tmp;
+
+		// Swap mac_addr[0] and mac_addr[5]
+		tmp = mac_addr[0];
+		mac_addr[0] = mac_addr[5];
+		mac_addr[5] = tmp;
+
+		// Swap mac_addr[1] and mac_addr[4]
+		tmp = mac_addr[1];
+		mac_addr[1] = mac_addr[4];
+		mac_addr[4] = tmp;
+
+		// Swap mac_addr[2] and mac_addr[3]
+		tmp = mac_addr[2];
+		mac_addr[2] = mac_addr[3];
+		mac_addr[3] = tmp;
+	}
+}
+
+/*********************************************************************
+ *
+ * platform_driver
+ *
+ **********************************************************************/
+static u32 init_netdev(struct platform_device *pdev, int eth_no, struct net_device **r_ndev)
+{
+	u32 ret = -ENODEV;
+	struct l2sw_mac *mac;
+	struct net_device *net_dev;
+	char *m_addr_name = (eth_no == 0) ? "mac_addr0" : "mac_addr1";
+	ssize_t otp_l = 0;
+	char *otp_v;
+
+	/* allocate the devices, and also allocate l2sw_mac, we can get it by netdev_priv() */
+	net_dev = alloc_etherdev(sizeof(struct l2sw_mac));
+	if (!net_dev) {
+		*r_ndev = NULL;
+		return -ENOMEM;
+	}
+	SET_NETDEV_DEV(net_dev, &pdev->dev);
+	net_dev->netdev_ops = &netdev_ops;
+
+	mac = netdev_priv(net_dev);
+	mac->net_dev = net_dev;
+	mac->pdev = pdev;
+	mac->next_netdev = NULL;
+
+	// Get property 'mac-addr0' or 'mac-addr1' from dts.
+	otp_v = sp7021_otp_read_mac(&pdev->dev, &otp_l, m_addr_name);
+	if ((otp_l < 6) || IS_ERR_OR_NULL(otp_v)) {
+		pr_info(" OTP mac %s (len = %zd) is invalid, using default!\n",
+			m_addr_name, otp_l);
+		otp_l = 0;
+	} else {
+		// Check if mac-address is valid or not. If not, copy from default.
+		memcpy(mac->mac_addr, otp_v, 6);
+
+		// Byte order of Some samples are reversed. Convert byte order here.
+		check_mac_vendor_id_and_convert(mac->mac_addr);
+
+		if (!is_valid_ether_addr(mac->mac_addr)) {
+			pr_info(" Invalid mac in OTP[%s] = %pM, use default!\n",
+				m_addr_name, mac->mac_addr);
+			otp_l = 0;
+		}
+	}
+	if (otp_l != 6) {
+		memcpy(mac->mac_addr, def_mac_addr, ETHERNET_MAC_ADDR_LEN);
+		mac->mac_addr[5] += eth_no;
+	}
+
+	pr_info(" HW Addr = %pM\n", mac->mac_addr);
+
+	memcpy(net_dev->dev_addr, mac->mac_addr, ETHERNET_MAC_ADDR_LEN);
+
+	ret = register_netdev(net_dev);
+	if (ret != 0) {
+		pr_err(" Failed to register net device \"%s\" (ret = %d)!\n", net_dev->name, ret);
+		free_netdev(net_dev);
+		*r_ndev = NULL;
+		return ret;
+	}
+	pr_info(" Registered net device \"%s\" successfully.\n", net_dev->name);
+
+	*r_ndev = net_dev;
+	return 0;
+}
+
+static ssize_t mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct net_device *net_dev = dev_get_drvdata(dev);
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+
+	return sprintf(buf, "%d\n", (mac->comm->dual_nic) ? 1 : (mac->comm->sa_learning) ? 0 : 2);
+}
+
+static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct net_device *net_dev = dev_get_drvdata(dev);
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+	struct l2sw_common *comm = mac->comm;
+	struct net_device *net_dev2;
+	struct l2sw_mac *mac2;
+
+	if (buf[0] == '1') {
+		// Switch to dual NIC mode.
+		mutex_lock(&comm->store_mode);
+		if (!comm->dual_nic) {
+			mac_hw_stop(mac);
+
+			comm->dual_nic = 1;
+			comm->sa_learning = 0;
+			mac_disable_port_sa_learning();
+			mac_addr_table_del_all();
+			mac_switch_mode(mac);
+			rx_mode_set(net_dev);
+
+			init_netdev(mac->pdev, 1, &net_dev2);	// Initialize the 2nd net device.
+			if (net_dev2) {
+				mac->next_netdev = net_dev2;	// Pointed by previous net device.
+				mac2 = netdev_priv(net_dev2);
+				mac2->comm = comm;
+				net_dev2->irq = comm->irq;
+
+				mac_switch_mode(mac);
+				rx_mode_set(net_dev2);
+				mac_hw_addr_set(mac2);
+			}
+
+			comm->enable &= 0x1;	// Keep lan 0, but always turn off lan 1.
+			mac_hw_start(mac);
+		}
+		mutex_unlock(&comm->store_mode);
+	} else if ((buf[0] == '0') || (buf[0] == '2')) {
+		// Switch to one NIC with daisy-chain mode.
+		mutex_lock(&comm->store_mode);
+
+		if (buf[0] == '2') {
+			if (comm->sa_learning == 1) {
+				comm->sa_learning = 0;
+				mac_disable_port_sa_learning();
+				mac_addr_table_del_all();
+			}
+		} else {
+			if (comm->sa_learning == 0) {
+				comm->sa_learning = 1;
+				mac_enable_port_sa_learning();
+			}
+		}
+
+		if (comm->dual_nic) {
+			struct net_device *net_dev2 = mac->next_netdev;
+
+			if (!netif_running(net_dev2)) {
+				mac_hw_stop(mac);
+
+				mac2 = netdev_priv(net_dev2);
+
+				// unregister and free net device.
+				unregister_netdev(net_dev2);
+				free_netdev(net_dev2);
+				mac->next_netdev = NULL;
+				pr_info(" Unregistered and freed net device \"eth1\"!\n");
+
+				comm->dual_nic = 0;
+				mac_switch_mode(mac);
+				rx_mode_set(net_dev);
+				mac_hw_addr_del(mac2);
+
+				// If eth0 is up, turn on lan 0 and 1 when
+				// switching to daisy-chain mode.
+				if (comm->enable & 0x1)
+					comm->enable = 0x3;
+				else
+					comm->enable = 0;
+
+				mac_hw_start(mac);
+			} else {
+				pr_err(" Error: Net device \"%s\" is running!\n", net_dev2->name);
+			}
+		}
+		mutex_unlock(&comm->store_mode);
+	} else {
+		pr_err(" Error: Unknown mode \"%c\"!\n", buf[0]);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(mode);
+static struct attribute *l2sw_sysfs_entries[] = {
+	&dev_attr_mode.attr,
+	NULL,
+};
+
+static struct attribute_group l2sw_attribute_group = {
+	.attrs = l2sw_sysfs_entries,
+};
+
+static int soc0_open(struct l2sw_mac *mac)
+{
+	struct l2sw_common *comm = mac->comm;
+	u32 rc;
+
+	mac_hw_stop(mac);
+
+	rc = descs_init(comm);
+	if (rc) {
+		pr_err(" Fail to initialize mac descriptors!\n");
+		goto INIT_DESC_FAIL;
+	}
+
+	/*start hardware port, open interrupt, start system tx queue */
+	mac_init(mac);
+	return 0;
+
+INIT_DESC_FAIL:
+	descs_free(comm);
+	return rc;
+}
+
+static int soc0_stop(struct l2sw_mac *mac)
+{
+	mac_hw_stop(mac);
+
+	descs_free(mac->comm);
+	return 0;
+}
+
+static int l2sw_probe(struct platform_device *pdev)
+{
+	struct l2sw_common *comm;
+	struct resource *r_mem;
+	struct net_device *net_dev, *net_dev2;
+	struct l2sw_mac *mac, *mac2;
+	u32 mode;
+	int ret = 0;
+	int rc;
+
+	if (platform_get_drvdata(pdev))
+		return -ENODEV;
+
+	// Allocate memory for l2sw 'common' area.
+	comm = kmalloc(sizeof(*comm), GFP_KERNEL);
+	if (!comm)
+		return -ENOMEM;
+	pr_debug(" comm = %p\n", comm);
+	memset(comm, '\0', sizeof(struct l2sw_common));
+	comm->pdev = pdev;
+
+	spin_lock_init(&comm->rx_lock);
+	spin_lock_init(&comm->tx_lock);
+	spin_lock_init(&comm->ioctl_lock);
+	mutex_init(&comm->store_mode);
+
+	// Get memory resoruce 0 from dts.
+	r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r_mem) {
+		pr_debug(" res->name = \"%s\", r_mem->start = %pa\n", r_mem->name, &r_mem->start);
+		if (l2sw_reg_base_set(devm_ioremap(&pdev->dev, r_mem->start,
+						   (r_mem->end - r_mem->start + 1))) != 0) {
+			pr_err(" ioremap failed!\n");
+			ret = -ENOMEM;
+			goto out_free_comm;
+		}
+	} else {
+		pr_err(" No MEM resource 0 found!\n");
+		ret = -ENXIO;
+		goto out_free_comm;
+	}
+
+	// Get memory resoruce 1 from dts.
+	r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (r_mem) {
+		pr_debug(" res->name = \"%s\", r_mem->start = %pa\n", r_mem->name, &r_mem->start);
+		if (moon5_reg_base_set(devm_ioremap(&pdev->dev, r_mem->start,
+						    (r_mem->end - r_mem->start + 1))) != 0) {
+			pr_err(" ioremap failed!\n");
+			ret = -ENOMEM;
+			goto out_free_comm;
+		}
+	} else {
+		pr_err(" No MEM resource 1 found!\n");
+		ret = -ENXIO;
+		goto out_free_comm;
+	}
+
+	// Get irq resource from dts.
+	if (l2sw_get_irq(pdev, comm) != 0) {
+		ret = -ENXIO;
+		goto out_free_comm;
+	}
+
+	// Get L2-switch mode.
+	ret = of_property_read_u32(pdev->dev.of_node, "mode", &mode);
+	if (ret)
+		mode = 0;
+	pr_info(" L2 switch mode = %u\n", mode);
+	if (mode == 2) {
+		comm->dual_nic = 0;	// daisy-chain mode 2
+		comm->sa_learning = 0;
+	} else if (mode == 1) {
+		comm->dual_nic = 1;	// dual NIC mode
+		comm->sa_learning = 0;
+	} else {
+		comm->dual_nic = 0;	// daisy-chain mode
+		comm->sa_learning = 1;
+	}
+
+	// Get resource of clock controller
+	comm->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(comm->clk)) {
+		dev_err(&pdev->dev, "Failed to retrieve clock controller!\n");
+		ret = PTR_ERR(comm->clk);
+		goto out_free_comm;
+	}
+
+	comm->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(comm->rstc)) {
+		dev_err(&pdev->dev, "Failed to retrieve reset controller!\n");
+		ret = PTR_ERR(comm->rstc);
+		goto out_free_comm;
+	}
+
+	// Enable clock.
+	clk_prepare_enable(comm->clk);
+	udelay(1);
+
+	ret = reset_control_assert(comm->rstc);
+	udelay(1);
+	ret = reset_control_deassert(comm->rstc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to deassert reset line (err = %d)!\n", ret);
+		ret = -ENODEV;
+		goto out_free_comm;
+	}
+	udelay(1);
+
+	ret = init_netdev(pdev, 0, &net_dev);	// Initialize the 1st net device (eth0)
+	if (!net_dev)
+		goto out_free_comm;
+
+	platform_set_drvdata(pdev, net_dev);	// Pointed by drvdata net device.
+
+	net_dev->irq = comm->irq;
+
+	mac = netdev_priv(net_dev);
+	mac->comm = comm;
+	comm->net_dev = net_dev;
+	pr_debug(" net_dev = %p, mac = %p, comm = %p\n", net_dev, mac, mac->comm);
+
+	comm->phy1_node = of_parse_phandle(pdev->dev.of_node, "phy-handle1", 0);
+	comm->phy2_node = of_parse_phandle(pdev->dev.of_node, "phy-handle2", 0);
+
+	// Get address of phy of ethernet from dts.
+	if (of_property_read_u32(comm->phy1_node, "reg", &rc) == 0) {
+		comm->phy1_addr = rc;
+	} else {
+		comm->phy1_addr = 0;
+		pr_info(" Cannot get address of phy of ethernet 1! Set to 0 by default.\n");
+	}
+
+	if (of_property_read_u32(comm->phy2_node, "reg", &rc) == 0) {
+		comm->phy2_addr = rc;
+	} else {
+		comm->phy2_addr = 1;
+		pr_info(" Cannot get address of phy of ethernet 2! Set to 1 by default.\n");
+	}
+
+	l2sw_enable_port(mac);
+
+	if (comm->phy1_node) {
+		ret = mdio_init(pdev, net_dev);
+		if (ret) {
+			pr_err(" Failed to initialize mdio!\n");
+			goto out_unregister_dev;
+		}
+
+		ret = mac_phy_probe(net_dev);
+		if (ret) {
+			pr_err(" Failed to probe phy!\n");
+			goto out_freemdio;
+		}
+	} else {
+		pr_err(" Failed to get phy-handle!\n");
+	}
+
+	phy_cfg(mac);
+
+	// Register irq to system.
+	if (l2sw_request_irq(pdev, comm, net_dev) != 0) {
+		ret = -ENODEV;
+		goto out_freemdio;
+	}
+
+	netif_napi_add(net_dev, &comm->rx_napi, rx_poll, RX_NAPI_WEIGHT);
+	napi_enable(&comm->rx_napi);
+	netif_napi_add(net_dev, &comm->tx_napi, tx_poll, TX_NAPI_WEIGHT);
+	napi_enable(&comm->tx_napi);
+
+	soc0_open(mac);
+
+	// Set MAC address
+	mac_hw_addr_set(mac);
+
+	/* Add the device attributes */
+	rc = sysfs_create_group(&pdev->dev.kobj, &l2sw_attribute_group);
+	if (rc)
+		dev_err(&pdev->dev, "Error creating sysfs files!\n");
+
+	mac_addr_table_del_all();
+	if (comm->sa_learning)
+		mac_enable_port_sa_learning();
+	else
+		mac_disable_port_sa_learning();
+	rx_mode_set(net_dev);
+
+	if (comm->dual_nic) {
+		init_netdev(pdev, 1, &net_dev2);
+		if (!net_dev2)
+			goto fail_to_init_2nd_port;
+		mac->next_netdev = net_dev2;	// Pointed by previous net device.
+
+		net_dev2->irq = comm->irq;
+		mac2 = netdev_priv(net_dev2);
+		mac2->comm = comm;
+		pr_debug(" net_dev = %p, mac = %p, comm = %p\n", net_dev2, mac2, mac2->comm);
+
+		mac_switch_mode(mac);
+		rx_mode_set(net_dev2);
+		mac_hw_addr_set(mac2);	// Set MAC address for the second net device.
+	}
+
+fail_to_init_2nd_port:
+	return 0;
+
+out_freemdio:
+	if (comm->mii_bus)
+		mdio_remove(net_dev);
+
+out_unregister_dev:
+	unregister_netdev(net_dev);
+
+out_free_comm:
+	kfree(comm);
+	return ret;
+}
+
+static int l2sw_remove(struct platform_device *pdev)
+{
+	struct net_device *net_dev;
+	struct net_device *net_dev2;
+	struct l2sw_mac *mac;
+
+	net_dev = platform_get_drvdata(pdev);
+	if (!net_dev)
+		return 0;
+	mac = netdev_priv(net_dev);
+
+	// Unregister and free 2nd net device.
+	net_dev2 = mac->next_netdev;
+	if (net_dev2) {
+		unregister_netdev(net_dev2);
+		free_netdev(net_dev2);
+	}
+
+	sysfs_remove_group(&pdev->dev.kobj, &l2sw_attribute_group);
+
+	mac->comm->enable = 0;
+	soc0_stop(mac);
+
+	napi_disable(&mac->comm->rx_napi);
+	netif_napi_del(&mac->comm->rx_napi);
+	napi_disable(&mac->comm->tx_napi);
+	netif_napi_del(&mac->comm->tx_napi);
+
+	mdio_remove(net_dev);
+
+	// Unregister and free 1st net device.
+	unregister_netdev(net_dev);
+	free_netdev(net_dev);
+
+	clk_disable(mac->comm->clk);
+
+	// Free 'common' area.
+	kfree(mac->comm);
+	return 0;
+}
+
+static const struct of_device_id sp_l2sw_of_match[] = {
+	{.compatible = "sunplus,sp7021-l2sw"},
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, sp_l2sw_of_match);
+
+static struct platform_driver l2sw_driver = {
+	.probe = l2sw_probe,
+	.remove = l2sw_remove,
+	.driver = {
+		.name = "sp_l2sw",
+		.owner = THIS_MODULE,
+		.of_match_table = sp_l2sw_of_match,
+	},
+};
+
+module_platform_driver(l2sw_driver);
+
+MODULE_AUTHOR("Wells Lu <wells.lu@sunplus.com>");
+MODULE_DESCRIPTION("Sunplus 10M/100M Ethernet (with L2 switch) driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/sunplus/l2sw_driver.h b/drivers/net/ethernet/sunplus/l2sw_driver.h
new file mode 100644
index 0000000..a076b33
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_driver.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_DRIVER_H__
+#define __L2SW_DRIVER_H__
+
+#include "l2sw_define.h"
+#include "l2sw_register.h"
+#include "l2sw_hal.h"
+#include "l2sw_int.h"
+#include "l2sw_mdio.h"
+#include "l2sw_mac.h"
+#include "l2sw_desc.h"
+
+#define NEXT_TX(N)              ((N) = (((N) + 1) == TX_DESC_NUM) ? 0 : (N) + 1)
+#define NEXT_RX(QUEUE, N)       ((N) = (((N) + 1) == mac->comm->rx_desc_num[QUEUE]) ? 0 : (N) + 1)
+
+#define RX_NAPI_WEIGHT          16
+#define TX_NAPI_WEIGHT          16
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/l2sw_hal.c b/drivers/net/ethernet/sunplus/l2sw_hal.c
new file mode 100644
index 0000000..2aac817
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_hal.c
@@ -0,0 +1,422 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "l2sw_hal.h"
+
+static struct l2sw_reg *l2sw_reg_base;
+static struct moon5_reg *moon5_reg_base;
+
+int l2sw_reg_base_set(void __iomem *baseaddr)
+{
+	l2sw_reg_base = (struct l2sw_reg *)baseaddr;
+	pr_debug(" l2sw_reg_base = %p\n", l2sw_reg_base);
+
+	if (!l2sw_reg_base)
+		return -1;
+
+	return 0;
+}
+
+int moon5_reg_base_set(void __iomem *baseaddr)
+{
+	moon5_reg_base = (struct moon5_reg *)baseaddr;
+	pr_debug(" moon5_reg_base = %p\n", moon5_reg_base);
+
+	if (!moon5_reg_base)
+		return -1;
+
+	return 0;
+}
+
+void mac_hw_stop(struct l2sw_mac *mac)
+{
+	struct l2sw_common *comm = mac->comm;
+	u32 reg, disable;
+
+	if (comm->enable == 0) {
+		HWREG_W(sw_int_mask_0, 0xffffffff);
+		HWREG_W(sw_int_status_0, 0xffffffff & (~MAC_INT_PORT_ST_CHG));
+
+		reg = HWREG_R(cpu_cntl);
+		HWREG_W(cpu_cntl, (0x3 << 6) | reg);	// Disable cpu 0 and cpu 1.
+	}
+
+	if (comm->dual_nic) {
+		disable = ((~comm->enable) & 0x3) << 24;
+		reg = HWREG_R(port_cntl0);
+		HWREG_W(port_cntl0, disable | reg);	// Disable lan 0 and lan 1.
+		wmb();		// make sure settings are effective.
+	}
+}
+
+void mac_hw_reset(struct l2sw_mac *mac)
+{
+}
+
+void mac_hw_start(struct l2sw_mac *mac)
+{
+	struct l2sw_common *comm = mac->comm;
+	u32 reg;
+
+	//enable cpu port 0 (6) & port 0 crc padding (8)
+	reg = HWREG_R(cpu_cntl);
+	HWREG_W(cpu_cntl, (reg & (~(0x1 << 6))) | (0x1 << 8));
+	wmb();			// make sure settings are effective.
+
+	//enable lan 0 & lan 1
+	reg = HWREG_R(port_cntl0);
+	HWREG_W(port_cntl0, reg & (~(comm->enable << 24)));
+	wmb();			// make sure settings are effective.
+}
+
+void mac_hw_addr_set(struct l2sw_mac *mac)
+{
+	u32 reg;
+
+	HWREG_W(w_mac_15_0, mac->mac_addr[0] + (mac->mac_addr[1] << 8));
+	HWREG_W(w_mac_47_16, mac->mac_addr[2] + (mac->mac_addr[3] << 8) +
+		(mac->mac_addr[4] << 16) + (mac->mac_addr[5] << 24));
+	wmb();			// make sure settings are effective.
+
+	// Set aging=1
+	HWREG_W(wt_mac_ad0, (mac->cpu_port << 10) + (mac->vlan_id << 7) + (1 << 4) + 0x1);
+	wmb();			// make sure settings are effective.
+
+	do {
+		reg = HWREG_R(wt_mac_ad0);
+		ndelay(10);
+		pr_debug(" wt_mac_ad0 = %08x\n", reg);
+	} while ((reg & (0x1 << 1)) == 0x0);
+	pr_debug(" mac_ad0 = %08x, mac_ad = %08x%04x\n", HWREG_R(wt_mac_ad0),
+		 HWREG_R(w_mac_47_16), HWREG_R(w_mac_15_0) & 0xffff);
+}
+
+void mac_hw_addr_del(struct l2sw_mac *mac)
+{
+	u32 reg;
+
+	HWREG_W(w_mac_15_0, mac->mac_addr[0] + (mac->mac_addr[1] << 8));
+	HWREG_W(w_mac_47_16, mac->mac_addr[2] + (mac->mac_addr[3] << 8) +
+		(mac->mac_addr[4] << 16) + (mac->mac_addr[5] << 24));
+	wmb();			// make sure settings are effective.
+
+	HWREG_W(wt_mac_ad0, (0x1 << 12) + (mac->vlan_id << 7) + 0x1);
+	wmb();			// make sure settings are effective.
+	do {
+		reg = HWREG_R(wt_mac_ad0);
+		ndelay(10);
+		pr_debug(" wt_mac_ad0 = %08x\n", reg);
+	} while ((reg & (0x1 << 1)) == 0x0);
+	pr_debug(" mac_ad0 = %08x, mac_ad = %08x%04x\n", HWREG_R(wt_mac_ad0),
+		 HWREG_R(w_mac_47_16), HWREG_R(w_mac_15_0) & 0xffff);
+}
+
+void mac_addr_table_del_all(void)
+{
+	u32 reg;
+
+	// Wait for address table being idle.
+	do {
+		reg = HWREG_R(addr_tbl_srch);
+		ndelay(10);
+	} while (!(reg & MAC_ADDR_LOOKUP_IDLE));
+
+	// Search address table from start.
+	HWREG_W(addr_tbl_srch, HWREG_R(addr_tbl_srch) | MAC_BEGIN_SEARCH_ADDR);
+	mb();			// make sure settings are effective.
+	while (1) {
+		do {
+			reg = HWREG_R(addr_tbl_st);
+			ndelay(10);
+			pr_debug(" addr_tbl_st = %08x\n", reg);
+		} while (!(reg & (MAC_AT_TABLE_END | MAC_AT_DATA_READY)));
+
+		if (reg & MAC_AT_TABLE_END)
+			break;
+
+		pr_debug(" addr_tbl_st = %08x\n", reg);
+		pr_debug(" @AT #%u: port=%01x, cpu=%01x, vid=%u, aging=%u, proxy=%u, mc_ingress=%u\n",
+			 (reg >> 22) & 0x3ff, (reg >> 12) & 0x3, (reg >> 10) & 0x3,
+			 (reg >> 7) & 0x7, (reg >> 4) & 0x7, (reg >> 3) & 0x1,
+			 (reg >> 2) & 0x1);
+
+		// Delete all entries which are learnt from lan ports.
+		if ((reg >> 12) & 0x3) {
+			HWREG_W(w_mac_15_0, HWREG_R(mac_ad_ser0));
+			wmb();	// make sure settings are effective.
+			HWREG_W(w_mac_47_16, HWREG_R(mac_ad_ser1));
+			wmb();	// make sure settings are effective.
+
+			HWREG_W(wt_mac_ad0, (0x1 << 12) + (reg & (0x7 << 7)) + 0x1);
+			wmb();	// make sure settings are effective.
+			do {
+				reg = HWREG_R(wt_mac_ad0);
+				ndelay(10);
+				pr_debug(" wt_mac_ad0 = %08x\n", reg);
+			} while ((reg & (0x1 << 1)) == 0x0);
+			pr_debug(" mac_ad0 = %08x, mac_ad = %08x%04x\n", HWREG_R(wt_mac_ad0),
+				 HWREG_R(w_mac_47_16), HWREG_R(w_mac_15_0) & 0xffff);
+		}
+		// Search next.
+		wmb();		// make sure settings are effective.
+
+		HWREG_W(addr_tbl_srch, HWREG_R(addr_tbl_srch) | MAC_SEARCH_NEXT_ADDR);
+	}
+}
+
+void mac_hw_init(struct l2sw_mac *mac)
+{
+	struct l2sw_common *comm = mac->comm;
+	u32 reg;
+
+	reg = HWREG_R(cpu_cntl);
+	HWREG_W(cpu_cntl, (0x3 << 6) | reg);	// Disable cpu0 and cpu 1.
+	wmb();			// make sure settings are effective.
+
+	/* descriptor base address */
+	HWREG_W(tx_lbase_addr_0, mac->comm->desc_dma);
+	HWREG_W(tx_hbase_addr_0, mac->comm->desc_dma + sizeof(struct mac_desc) * TX_DESC_NUM);
+	HWREG_W(rx_hbase_addr_0, mac->comm->desc_dma +
+		sizeof(struct mac_desc) * (TX_DESC_NUM + MAC_GUARD_DESC_NUM));
+	HWREG_W(rx_lbase_addr_0, mac->comm->desc_dma +
+		sizeof(struct mac_desc) * (TX_DESC_NUM + MAC_GUARD_DESC_NUM + RX_QUEUE0_DESC_NUM));
+	wmb();			// make sure settings are effective.
+
+	// Threshold values
+	HWREG_W(fl_cntl_th, 0x4a3a2d1d);	// Fc_rls_th=0x4a,   Fc_set_th=0x3a,
+						// Drop_rls_th=0x2d, Drop_set_th=0x1d
+	HWREG_W(cpu_fl_cntl_th, 0x4a3a1212);	// Cpu_rls_th=0x4a,  Cpu_set_th=0x3a,
+						// Cpu_th=0x12,      Port_th=0x12
+	HWREG_W(pri_fl_cntl, 0xf6680000);	// mtcc_lmt=0xf,     Pri_th_l=6,
+						// Pri_th_h=6,       weigh_8x_en=1
+
+	// High-active LED
+	reg = HWREG_R(led_port0);
+	HWREG_W(led_port0, reg | (1 << 28));
+
+	/* phy address */
+	reg = HWREG_R(mac_force_mode);
+	reg = (reg & (~(0x1f << 16))) | ((mac->comm->phy1_addr & 0x1f) << 16);
+	reg = (reg & (~(0x1f << 24))) | ((mac->comm->phy2_addr & 0x1f) << 24);
+	HWREG_W(mac_force_mode, reg);
+
+	//disable cpu port0 aging (12)
+	//disable cpu port0 learning (14)
+	//enable UC and MC packets
+	reg = HWREG_R(cpu_cntl);
+	HWREG_W(cpu_cntl, (reg & (~((0x1 << 14) | (0x3c << 0)))) | (0x1 << 12));
+
+	mac_switch_mode(mac);
+
+	if (!comm->dual_nic) {
+		//enable lan 0 & lan 1
+		reg = HWREG_R(port_cntl0);
+		HWREG_W(port_cntl0, reg & (~(0x3 << 24)));
+		wmb();		// make sure settings are effective.
+	}
+
+	wmb();			// make sure settings are effective.
+	HWREG_W(sw_int_mask_0, MAC_INT_MASK_DEF);
+}
+
+void mac_switch_mode(struct l2sw_mac *mac)
+{
+	struct l2sw_common *comm = mac->comm;
+	u32 reg;
+
+	if (comm->dual_nic) {
+		mac->cpu_port = 0x1;	// soc0
+		mac->lan_port = 0x1;	// forward to port 0
+		mac->to_vlan = 0x1;	// vlan group: 0
+		mac->vlan_id = 0x0;	// vlan group: 0
+
+		if (mac->next_netdev) {
+			struct l2sw_mac *mac2 = netdev_priv(mac->next_netdev);
+
+			mac2->cpu_port = 0x1;	// soc0
+			mac2->lan_port = 0x2;	// forward to port 1
+			mac2->to_vlan = 0x2;	// vlan group: 1
+			mac2->vlan_id = 0x1;	// vlan group: 1
+		}
+		//port 0: VLAN group 0
+		//port 1: VLAN group 1
+		HWREG_W(pvid_config0, (1 << 4) + 0);
+
+		//VLAN group 0: cpu0+port0
+		//VLAN group 1: cpu0+port1
+		HWREG_W(vlan_memset_config0, (0xa << 8) + 0x9);
+
+		//RMC forward: to cpu
+		//LED: 60mS
+		//BC storm prev: 31 BC
+		reg = HWREG_R(sw_glb_cntl);
+		HWREG_W(sw_glb_cntl, (reg & (~((0x3 << 25) | (0x3 << 23) | (0x3 << 4)))) |
+			(0x1 << 25) | (0x1 << 23) | (0x1 << 4));
+	} else {
+		mac->cpu_port = 0x1;	// soc0
+		mac->lan_port = 0x3;	// forward to port 0 and 1
+		mac->to_vlan = 0x1;	// vlan group: 0
+		mac->vlan_id = 0x0;	// vlan group: 0
+		comm->enable = 0x3;	// enable lan 0 and 1
+
+		//port 0: VLAN group 0
+		//port 1: VLAN group 0
+		HWREG_W(pvid_config0, (0 << 4) + 0);
+
+		//VLAN group 0: cpu0+port1+port0
+		HWREG_W(vlan_memset_config0, (0x0 << 8) + 0xb);
+
+		//RMC forward: broadcast
+		//LED: 60mS
+		//BC storm prev: 31 BC
+		reg = HWREG_R(sw_glb_cntl);
+		HWREG_W(sw_glb_cntl, (reg & (~((0x3 << 25) | (0x3 << 23) | (0x3 << 4)))) |
+			(0x0 << 25) | (0x1 << 23) | (0x1 << 4));
+	}
+}
+
+void mac_disable_port_sa_learning(void)
+{
+	u32 reg;
+
+	// Disable lan port SA learning.
+	reg = HWREG_R(port_cntl1);
+	HWREG_W(port_cntl1, reg | (0x3 << 8));
+}
+
+void mac_enable_port_sa_learning(void)
+{
+	u32 reg;
+
+	// Disable lan port SA learning.
+	reg = HWREG_R(port_cntl1);
+	HWREG_W(port_cntl1, reg & (~(0x3 << 8)));
+}
+
+void rx_mode_set(struct net_device *net_dev)
+{
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+	u32 mask, reg, rx_mode;
+
+	pr_debug(" net_dev->flags = %08x\n", net_dev->flags);
+
+	mask = (mac->lan_port << 2) | (mac->lan_port << 0);
+	reg = HWREG_R(cpu_cntl);
+
+	if (net_dev->flags & IFF_PROMISC) {	/* Set promiscuous mode */
+		// Allow MC and unknown UC packets
+		rx_mode = (mac->lan_port << 2) | (mac->lan_port << 0);
+	} else if ((!netdev_mc_empty(net_dev) && (net_dev->flags & IFF_MULTICAST)) ||
+		   (net_dev->flags & IFF_ALLMULTI)) {
+		// Allow MC packets
+		rx_mode = (mac->lan_port << 2);
+	} else {
+		// Disable MC and unknown UC packets
+		rx_mode = 0;
+	}
+
+	HWREG_W(cpu_cntl, (reg & (~mask)) | ((~rx_mode) & mask));
+	pr_debug(" cpu_cntl = %08x\n", HWREG_R(cpu_cntl));
+}
+
+static int mdio_access(u8 op_cd, u8 dev_reg_addr, u8 phy_addr, u32 wdata)
+{
+	u32 value, time = 0;
+
+	HWREG_W(phy_cntl_reg0, (wdata << 16) | (op_cd << 13) | (dev_reg_addr << 8) | phy_addr);
+	wmb();			// make sure settings are effective.
+	do {
+		if (++time > MDIO_RW_TIMEOUT_RETRY_NUMBERS) {
+			pr_err(" mdio failed to operate!\n");
+			time = 0;
+		}
+
+		value = HWREG_R(phy_cntl_reg1);
+	} while ((value & 0x3) == 0);
+
+	if (time == 0)
+		return -1;
+
+	return value >> 16;
+}
+
+u32 mdio_read(u32 phy_id, u16 regnum)
+{
+	int ret;
+
+	ret = mdio_access(MDIO_READ_CMD, regnum, phy_id, 0);
+	if (ret < 0)
+		return -EIO;
+
+	return ret;
+}
+
+u32 mdio_write(u32 phy_id, u32 regnum, u16 val)
+{
+	int ret;
+
+	ret = mdio_access(MDIO_WRITE_CMD, regnum, phy_id, val);
+	if (ret < 0)
+		return -EIO;
+
+	return 0;
+}
+
+inline void tx_trigger(void)
+{
+	HWREG_W(cpu_tx_trig, (0x1 << 1));
+}
+
+inline u32 read_sw_int_mask0(void)
+{
+	return HWREG_R(sw_int_mask_0);
+}
+
+inline void write_sw_int_mask0(u32 value)
+{
+	HWREG_W(sw_int_mask_0, value);
+}
+
+inline void write_sw_int_status0(u32 value)
+{
+	HWREG_W(sw_int_status_0, value);
+}
+
+inline u32 read_sw_int_status0(void)
+{
+	return HWREG_R(sw_int_status_0);
+}
+
+inline u32 read_port_ability(void)
+{
+	return HWREG_R(port_ability);
+}
+
+void l2sw_enable_port(struct l2sw_mac *mac)
+{
+	u32 reg;
+
+	//set clock
+	reg = MOON5REG_R(mo4_l2sw_clksw_ctl);
+	MOON5REG_W(mo4_l2sw_clksw_ctl, reg | (0xf << 16) | 0xf);
+
+	//phy address
+	reg = HWREG_R(mac_force_mode);
+	reg = (reg & (~(0x1f << 16))) | ((mac->comm->phy1_addr & 0x1f) << 16);
+	reg = (reg & (~(0x1f << 24))) | ((mac->comm->phy2_addr & 0x1f) << 24);
+	HWREG_W(mac_force_mode, reg);
+	wmb();			// make sure settings are effective.
+}
+
+int phy_cfg(struct l2sw_mac *mac)
+{
+	// Bug workaround:
+	// Flow-control of phy should be enabled. L2SW IP flow-control will refer
+	// to the bit to decide to enable or disable flow-control.
+	mdio_write(mac->comm->phy1_addr, 4, mdio_read(mac->comm->phy1_addr, 4) | (1 << 10));
+	mdio_write(mac->comm->phy2_addr, 4, mdio_read(mac->comm->phy2_addr, 4) | (1 << 10));
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/sunplus/l2sw_hal.h b/drivers/net/ethernet/sunplus/l2sw_hal.h
new file mode 100644
index 0000000..7f04659
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_hal.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_HAL_H__
+#define __L2SW_HAL_H__
+
+#include "l2sw_register.h"
+#include "l2sw_define.h"
+#include "l2sw_desc.h"
+
+#define HWREG_W(M, N)           (l2sw_reg_base->M = N)
+#define HWREG_R(M)              (l2sw_reg_base->M)
+#define MOON5REG_W(M, N)        (moon5_reg_base->M = N)
+#define MOON5REG_R(M)           (moon5_reg_base->M)
+
+#define MDIO_RW_TIMEOUT_RETRY_NUMBERS 500
+#define MDIO_READ_CMD                 0x02
+#define MDIO_WRITE_CMD                0x01
+
+int  l2sw_reg_base_set(void __iomem *baseaddr);
+int  moon5_reg_base_set(void __iomem *baseaddr);
+void mac_hw_stop(struct l2sw_mac *mac);
+void mac_hw_reset(struct l2sw_mac *mac);
+void mac_hw_start(struct l2sw_mac *mac);
+void mac_hw_addr_set(struct l2sw_mac *mac);
+void mac_hw_addr_del(struct l2sw_mac *mac);
+void mac_addr_table_del_all(void);
+void mac_hw_init(struct l2sw_mac *mac);
+void mac_switch_mode(struct l2sw_mac *mac);
+void mac_disable_port_sa_learning(void);
+void mac_enable_port_sa_learning(void);
+void rx_mode_set(struct net_device *net_dev);
+u32  mdio_read(u32 phy_id, u16 regnum);
+u32  mdio_write(u32 phy_id, u32 regnum, u16 val);
+void tx_trigger(void);
+u32  read_sw_int_mask0(void);
+void write_sw_int_mask0(u32 value);
+void write_sw_int_status0(u32 value);
+u32  read_sw_int_status0(void);
+u32  read_port_ability(void);
+int  phy_cfg(struct l2sw_mac *mac);
+void l2sw_enable_port(struct l2sw_mac *mac);
+void regs_print(void);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/l2sw_int.c b/drivers/net/ethernet/sunplus/l2sw_int.c
new file mode 100644
index 0000000..865d2d1
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_int.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "l2sw_define.h"
+#include "l2sw_int.h"
+#include "l2sw_driver.h"
+#include "l2sw_hal.h"
+
+static inline void port_status_change(struct l2sw_mac *mac)
+{
+	u32 reg;
+	struct net_device *net_dev = (struct net_device *)mac->net_dev;
+
+	reg = read_port_ability();
+	if (mac->comm->dual_nic) {
+		if (!netif_carrier_ok(net_dev) && (reg & PORT_ABILITY_LINK_ST_P0)) {
+			netif_carrier_on(net_dev);
+			netif_start_queue(net_dev);
+		} else if (netif_carrier_ok(net_dev) && !(reg & PORT_ABILITY_LINK_ST_P0)) {
+			netif_carrier_off(net_dev);
+			netif_stop_queue(net_dev);
+		}
+
+		if (mac->next_netdev) {
+			struct net_device *ndev2 = mac->next_netdev;
+
+			if (!netif_carrier_ok(ndev2) && (reg & PORT_ABILITY_LINK_ST_P1)) {
+				netif_carrier_on(ndev2);
+				netif_start_queue(ndev2);
+			} else if (netif_carrier_ok(ndev2) && !(reg & PORT_ABILITY_LINK_ST_P1)) {
+				netif_carrier_off(ndev2);
+				netif_stop_queue(ndev2);
+			}
+		}
+	} else {
+		if (!netif_carrier_ok(net_dev) &&
+		    (reg & (PORT_ABILITY_LINK_ST_P1 | PORT_ABILITY_LINK_ST_P0))) {
+			netif_carrier_on(net_dev);
+			netif_start_queue(net_dev);
+		} else if (netif_carrier_ok(net_dev) &&
+		    !(reg & (PORT_ABILITY_LINK_ST_P1 | PORT_ABILITY_LINK_ST_P0))) {
+			netif_carrier_off(net_dev);
+			netif_stop_queue(net_dev);
+		}
+	}
+}
+
+static inline void rx_skb(struct l2sw_mac *mac, struct sk_buff *skb)
+{
+	mac->dev_stats.rx_packets++;
+	mac->dev_stats.rx_bytes += skb->len;
+	netif_receive_skb(skb);
+}
+
+int rx_poll(struct napi_struct *napi, int budget)
+{
+	struct l2sw_common *comm = container_of(napi, struct l2sw_common, rx_napi);
+	struct l2sw_mac *mac = netdev_priv(comm->net_dev);
+	struct sk_buff *skb, *new_skb;
+	struct skb_info *sinfo;
+	struct mac_desc *desc;
+	struct mac_desc *h_desc;
+	u32 rx_pos, pkg_len;
+	u32 cmd;
+	u32 num, rx_count;
+	s32 queue;
+	int ndev2_pkt;
+	struct net_device_stats *dev_stats;
+
+	spin_lock(&comm->rx_lock);
+
+	// Process high-priority queue and then low-priority queue.
+	for (queue = 0; queue < RX_DESC_QUEUE_NUM; queue++) {
+		rx_pos = comm->rx_pos[queue];
+		rx_count = comm->rx_desc_num[queue];
+
+		for (num = 0; num < rx_count; num++) {
+			sinfo = comm->rx_skb_info[queue] + rx_pos;
+			desc = comm->rx_desc[queue] + rx_pos;
+			cmd = desc->cmd1;
+
+			if (cmd & OWN_BIT)
+				break;
+
+			if (comm->dual_nic && ((cmd & PKTSP_MASK) == PKTSP_PORT1)) {
+				struct l2sw_mac *mac2;
+
+				ndev2_pkt = 1;
+				mac2 = (mac->next_netdev) ? netdev_priv(mac->next_netdev) : NULL;
+				dev_stats = (mac2) ? &mac2->dev_stats : &mac->dev_stats;
+			} else {
+				ndev2_pkt = 0;
+				dev_stats = &mac->dev_stats;
+			}
+
+			pkg_len = cmd & LEN_MASK;
+			if (unlikely((cmd & ERR_CODE) || (pkg_len < 64))) {
+				dev_stats->rx_length_errors++;
+				dev_stats->rx_dropped++;
+				goto NEXT;
+			}
+
+			if (unlikely(cmd & RX_IP_CHKSUM_BIT)) {
+				dev_stats->rx_crc_errors++;
+				dev_stats->rx_dropped++;
+				goto NEXT;
+			}
+
+			/* allocate an skbuff for receiving, and it's an inline function */
+			new_skb = __dev_alloc_skb(comm->rx_desc_buff_size + RX_OFFSET,
+						  GFP_ATOMIC | GFP_DMA);
+			if (unlikely(!new_skb)) {
+				dev_stats->rx_dropped++;
+				goto NEXT;
+			}
+			new_skb->dev = mac->net_dev;
+
+			dma_unmap_single(&mac->pdev->dev, sinfo->mapping, comm->rx_desc_buff_size,
+					 DMA_FROM_DEVICE);
+
+			skb = sinfo->skb;
+			skb->ip_summed = CHECKSUM_NONE;
+
+			/*skb_put will judge if tail exceeds end, but __skb_put won't */
+			__skb_put(skb, (pkg_len - 4 > comm->rx_desc_buff_size) ?
+				       comm->rx_desc_buff_size : pkg_len - 4);
+
+			sinfo->mapping = dma_map_single(&mac->pdev->dev, new_skb->data,
+							comm->rx_desc_buff_size,
+							DMA_FROM_DEVICE);
+			sinfo->skb = new_skb;
+
+			if (ndev2_pkt) {
+				struct net_device *netdev2 = mac->next_netdev;
+
+				if (netdev2) {
+					skb->protocol = eth_type_trans(skb, netdev2);
+					rx_skb(netdev_priv(netdev2), skb);
+				}
+			} else {
+				skb->protocol = eth_type_trans(skb, mac->net_dev);
+				rx_skb(mac, skb);
+			}
+
+			desc->addr1 = sinfo->mapping;
+
+NEXT:
+			desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
+				     EOR_BIT | MAC_RX_LEN_MAX : MAC_RX_LEN_MAX;
+			wmb();	// Set OWN_BIT after other fields of descriptor are effective.
+			desc->cmd1 = OWN_BIT | (comm->rx_desc_buff_size & LEN_MASK);
+
+			NEXT_RX(queue, rx_pos);
+
+			// If there are packets in high-priority queue,
+			// stop processing low-priority queue.
+			if ((queue == 1) && ((h_desc->cmd1 & OWN_BIT) == 0))
+				break;
+		}
+
+		comm->rx_pos[queue] = rx_pos;
+
+		// Save pointer to last rx descriptor of high-priority queue.
+		if (queue == 0)
+			h_desc = comm->rx_desc[queue] + rx_pos;
+	}
+
+	spin_unlock(&comm->rx_lock);
+
+	wmb();			// make sure settings are effective.
+	write_sw_int_mask0(read_sw_int_mask0() & ~MAC_INT_RX);
+
+	napi_complete(napi);
+	return 0;
+}
+
+int tx_poll(struct napi_struct *napi, int budget)
+{
+	struct l2sw_common *comm = container_of(napi, struct l2sw_common, tx_napi);
+	struct l2sw_mac *mac = netdev_priv(comm->net_dev);
+	u32 tx_done_pos;
+	u32 cmd;
+	struct skb_info *skbinfo;
+	struct l2sw_mac *smac;
+
+	spin_lock(&comm->tx_lock);
+
+	tx_done_pos = comm->tx_done_pos;
+	while ((tx_done_pos != comm->tx_pos) || (comm->tx_desc_full == 1)) {
+		cmd = comm->tx_desc[tx_done_pos].cmd1;
+		if (cmd & OWN_BIT)
+			break;
+
+		skbinfo = &comm->tx_temp_skb_info[tx_done_pos];
+		if (unlikely(!skbinfo->skb))
+			pr_err(" skb is null!\n");
+
+		smac = mac;
+		if (mac->next_netdev && ((cmd & TO_VLAN_MASK) == TO_VLAN_GROUP1))
+			smac = netdev_priv(mac->next_netdev);
+
+		if (unlikely(cmd & (ERR_CODE))) {
+			smac->dev_stats.tx_errors++;
+		} else {
+			smac->dev_stats.tx_packets++;
+			smac->dev_stats.tx_bytes += skbinfo->len;
+		}
+
+		dma_unmap_single(&mac->pdev->dev, skbinfo->mapping, skbinfo->len, DMA_TO_DEVICE);
+		skbinfo->mapping = 0;
+		dev_kfree_skb_irq(skbinfo->skb);
+		skbinfo->skb = NULL;
+
+		NEXT_TX(tx_done_pos);
+		if (comm->tx_desc_full == 1)
+			comm->tx_desc_full = 0;
+	}
+
+	comm->tx_done_pos = tx_done_pos;
+	if (!comm->tx_desc_full) {
+		if (netif_queue_stopped(mac->net_dev))
+			netif_wake_queue(mac->net_dev);
+
+		if (mac->next_netdev) {
+			if (netif_queue_stopped(mac->next_netdev))
+				netif_wake_queue(mac->next_netdev);
+		}
+	}
+
+	spin_unlock(&comm->tx_lock);
+
+	wmb();			// make sure settings are effective.
+	write_sw_int_mask0(read_sw_int_mask0() & ~MAC_INT_TX);
+
+	napi_complete(napi);
+	return 0;
+}
+
+irqreturn_t ethernet_interrupt(int irq, void *dev_id)
+{
+	struct net_device *net_dev;
+	struct l2sw_mac *mac;
+	struct l2sw_common *comm;
+	u32 status;
+
+	net_dev = (struct net_device *)dev_id;
+	if (unlikely(!net_dev)) {
+		pr_err(" net_dev is null!\n");
+		return -1;
+	}
+
+	mac = netdev_priv(net_dev);
+	comm = mac->comm;
+
+	status = read_sw_int_status0();
+	if (unlikely(status == 0)) {
+		pr_err(" Interrput status is null!\n");
+		goto OUT;
+	}
+	write_sw_int_status0(status);
+
+	if (status & MAC_INT_RX) {
+		// Disable RX interrupts.
+		write_sw_int_mask0(read_sw_int_mask0() | MAC_INT_RX);
+
+		if (unlikely(status & MAC_INT_RX_DES_ERR)) {
+			pr_err(" Illegal RX Descriptor!\n");
+			mac->dev_stats.rx_fifo_errors++;
+		}
+		if (napi_schedule_prep(&comm->rx_napi))
+			__napi_schedule(&comm->rx_napi);
+	}
+
+	if (status & MAC_INT_TX) {
+		// Disable TX interrupts.
+		write_sw_int_mask0(read_sw_int_mask0() | MAC_INT_TX);
+
+		if (unlikely(status & MAC_INT_TX_DES_ERR)) {
+			pr_err(" Illegal TX Descriptor Error\n");
+			mac->dev_stats.tx_fifo_errors++;
+			mac_soft_reset(mac);
+			wmb();			// make sure settings are effective.
+			write_sw_int_mask0(read_sw_int_mask0() & ~MAC_INT_TX);
+		} else {
+			if (napi_schedule_prep(&comm->tx_napi))
+				__napi_schedule(&comm->tx_napi);
+		}
+	}
+
+	if (status & MAC_INT_PORT_ST_CHG)	/* link status changed */
+		port_status_change(mac);
+
+OUT:
+	return IRQ_HANDLED;
+}
+
+int l2sw_get_irq(struct platform_device *pdev, struct l2sw_common *comm)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		pr_err(" No IRQ resource found!\n");
+		return -1;
+	}
+
+	pr_debug(" res->name = \"%s\", res->start = %pa\n", res->name, &res->start);
+	comm->irq = res->start;
+	return 0;
+}
+
+int l2sw_request_irq(struct platform_device *pdev, struct l2sw_common *comm,
+		     struct net_device *net_dev)
+{
+	int rc;
+
+	rc = devm_request_irq(&pdev->dev, comm->irq, ethernet_interrupt, 0,
+			      net_dev->name, net_dev);
+	if (rc != 0) {
+		pr_err(" Failed to request irq #%d for \"%s\" (rc = %d)!\n",
+		       net_dev->irq, net_dev->name, rc);
+	}
+	return rc;
+}
diff --git a/drivers/net/ethernet/sunplus/l2sw_int.h b/drivers/net/ethernet/sunplus/l2sw_int.h
new file mode 100644
index 0000000..b459481
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_int.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_INT_H__
+#define __L2SW_INT_H__
+
+int rx_poll(struct napi_struct *napi, int budget);
+int tx_poll(struct napi_struct *napi, int budget);
+irqreturn_t ethernet_interrupt(int irq, void *dev_id);
+int l2sw_get_irq(struct platform_device *pdev, struct l2sw_common *comm);
+int l2sw_request_irq(struct platform_device *pdev, struct l2sw_common *comm,
+		     struct net_device *net_dev);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/l2sw_mac.c b/drivers/net/ethernet/sunplus/l2sw_mac.c
new file mode 100644
index 0000000..4b5b1d7
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_mac.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "l2sw_mac.h"
+
+bool mac_init(struct l2sw_mac *mac)
+{
+	u32 i;
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
+		mac->comm->rx_pos[i] = 0;
+	mb();			// make sure settings are effective.
+
+	mac_hw_init(mac);
+	mb();			// make sure settings are effective.
+
+	return 1;
+}
+
+void mac_soft_reset(struct l2sw_mac *mac)
+{
+	u32 i;
+	struct net_device *net_dev2;
+
+	if (netif_carrier_ok(mac->net_dev)) {
+		netif_carrier_off(mac->net_dev);
+		netif_stop_queue(mac->net_dev);
+	}
+
+	net_dev2 = mac->next_netdev;
+	if (net_dev2) {
+		if (netif_carrier_ok(net_dev2)) {
+			netif_carrier_off(net_dev2);
+			netif_stop_queue(net_dev2);
+		}
+	}
+
+	mac_hw_reset(mac);
+	mac_hw_stop(mac);
+	mb();			// make sure settings are effective.
+
+	rx_descs_flush(mac->comm);
+	mac->comm->tx_pos = 0;
+	mac->comm->tx_done_pos = 0;
+	mac->comm->tx_desc_full = 0;
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
+		mac->comm->rx_pos[i] = 0;
+	mb();			// make sure settings are effective.
+
+	mac_hw_init(mac);
+	mac_hw_start(mac);
+	mb();			// make sure settings are effective.
+
+	if (!netif_carrier_ok(mac->net_dev)) {
+		netif_carrier_on(mac->net_dev);
+		netif_start_queue(mac->net_dev);
+	}
+
+	if (net_dev2) {
+		if (!netif_carrier_ok(net_dev2)) {
+			netif_carrier_on(net_dev2);
+			netif_start_queue(net_dev2);
+		}
+	}
+}
diff --git a/drivers/net/ethernet/sunplus/l2sw_mac.h b/drivers/net/ethernet/sunplus/l2sw_mac.h
new file mode 100644
index 0000000..a053130
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_mac.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_MAC_H__
+#define __L2SW_MAC_H__
+
+#include "l2sw_define.h"
+#include "l2sw_hal.h"
+
+bool mac_init(struct l2sw_mac *mac);
+
+void mac_soft_reset(struct l2sw_mac *mac);
+
+//calculate the empty tx descriptor number
+#define TX_DESC_AVAIL(mac) \
+	(((mac)->tx_pos != (mac)->tx_done_pos) ? \
+	(((mac)->tx_done_pos < (mac)->tx_pos) ? \
+	(TX_DESC_NUM - ((mac)->tx_pos - (mac)->tx_done_pos)) : \
+	((mac)->tx_done_pos - (mac)->tx_pos)) : \
+	((mac)->tx_desc_full ? 0 : TX_DESC_NUM))
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/l2sw_mdio.c b/drivers/net/ethernet/sunplus/l2sw_mdio.c
new file mode 100644
index 0000000..9008ab9
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_mdio.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "l2sw_mdio.h"
+
+static int mii_read(struct mii_bus *bus, int phy_id, int regnum)
+{
+	return mdio_read(phy_id, regnum);
+}
+
+static int mii_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
+{
+	return mdio_write(phy_id, regnum, val);
+}
+
+u32 mdio_init(struct platform_device *pdev, struct net_device *net_dev)
+{
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+	struct mii_bus *mii_bus;
+	struct device_node *mdio_node;
+	u32 ret;
+
+	mii_bus = mdiobus_alloc();
+	if (!mii_bus) {
+		pr_err(" Failed to allocate mdio_bus memory!\n");
+		return -ENOMEM;
+	}
+
+	mii_bus->name = "sunplus_mii_bus";
+	mii_bus->parent = &pdev->dev;
+	mii_bus->priv = mac;
+	mii_bus->read = mii_read;
+	mii_bus->write = mii_write;
+	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
+
+	mdio_node = of_get_parent(mac->comm->phy1_node);
+	ret = of_mdiobus_register(mii_bus, mdio_node);
+	if (ret) {
+		pr_err(" Failed to register mii bus (ret = %d)!\n", ret);
+		mdiobus_free(mii_bus);
+		return ret;
+	}
+
+	mac->comm->mii_bus = mii_bus;
+	return ret;
+}
+
+void mdio_remove(struct net_device *net_dev)
+{
+	struct l2sw_mac *mac = netdev_priv(net_dev);
+
+	if (mac->comm->mii_bus) {
+		mdiobus_unregister(mac->comm->mii_bus);
+		mdiobus_free(mac->comm->mii_bus);
+		mac->comm->mii_bus = NULL;
+	}
+}
+
+static void mii_linkchange(struct net_device *netdev)
+{
+}
+
+int mac_phy_probe(struct net_device *netdev)
+{
+	struct l2sw_mac *mac = netdev_priv(netdev);
+	struct phy_device *phydev;
+	int i;
+
+	phydev = of_phy_connect(mac->net_dev, mac->comm->phy1_node, mii_linkchange,
+				0, PHY_INTERFACE_MODE_RGMII_ID);
+	if (!phydev) {
+		pr_err(" \"%s\" has no phy found\n", netdev->name);
+		return -1;
+	}
+
+	if (mac->comm->phy2_node) {
+		of_phy_connect(mac->net_dev, mac->comm->phy2_node, mii_linkchange,
+			       0, PHY_INTERFACE_MODE_RGMII_ID);
+	}
+
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->supported);
+
+	for (i = 0; i < sizeof(phydev->supported) / sizeof(long); i++)
+		phydev->advertising[i] = phydev->supported[i];
+
+	phydev->irq = PHY_MAC_INTERRUPT;
+	mac->comm->phy_dev = phydev;
+
+	return 0;
+}
+
+void mac_phy_start(struct net_device *netdev)
+{
+	struct l2sw_mac *mac = netdev_priv(netdev);
+
+	phy_start(mac->comm->phy_dev);
+}
+
+void mac_phy_stop(struct net_device *netdev)
+{
+	struct l2sw_mac *mac = netdev_priv(netdev);
+
+	if (mac->comm->phy_dev)
+		phy_stop(mac->comm->phy_dev);
+}
+
+void mac_phy_remove(struct net_device *netdev)
+{
+	struct l2sw_mac *mac = netdev_priv(netdev);
+
+	if (mac->comm->phy_dev) {
+		phy_disconnect(mac->comm->phy_dev);
+		mac->comm->phy_dev = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/sunplus/l2sw_mdio.h b/drivers/net/ethernet/sunplus/l2sw_mdio.h
new file mode 100644
index 0000000..698fc0b
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_mdio.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_MDIO_H__
+#define __L2SW_MDIO_H__
+
+#include "l2sw_define.h"
+#include "l2sw_hal.h"
+
+u32  mdio_init(struct platform_device *pdev, struct net_device *net_dev);
+void mdio_remove(struct net_device *net_dev);
+int  mac_phy_probe(struct net_device *netdev);
+void mac_phy_start(struct net_device *netdev);
+void mac_phy_stop(struct net_device *netdev);
+void mac_phy_remove(struct net_device *netdev);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/l2sw_register.h b/drivers/net/ethernet/sunplus/l2sw_register.h
new file mode 100644
index 0000000..a54a296
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/l2sw_register.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __L2SW_REGISTER_H__
+#define __L2SW_REGISTER_H__
+
+#include "l2sw_define.h"
+
+/* TYPE: RegisterFile_L2SW */
+struct l2sw_reg {
+	u32 sw_int_status_0;
+	u32 sw_int_mask_0;
+	u32 fl_cntl_th;
+	u32 cpu_fl_cntl_th;
+	u32 pri_fl_cntl;
+	u32 vlan_pri_th;
+	u32 en_tos_bus;
+	u32 tos_map0;
+	u32 tos_map1;
+	u32 tos_map2;
+	u32 tos_map3;
+	u32 tos_map4;
+	u32 tos_map5;
+	u32 tos_map6;
+	u32 tos_map7;
+	u32 global_que_status;
+	u32 addr_tbl_srch;
+	u32 addr_tbl_st;
+	u32 mac_ad_ser0;
+	u32 mac_ad_ser1;
+	u32 wt_mac_ad0;
+	u32 w_mac_15_0;
+	u32 w_mac_47_16;
+	u32 pvid_config0;
+	u32 pvid_config1;
+	u32 vlan_memset_config0;
+	u32 vlan_memset_config1;
+	u32 port_ability;
+	u32 port_st;
+	u32 cpu_cntl;
+	u32 port_cntl0;
+	u32 port_cntl1;
+	u32 port_cntl2;
+	u32 sw_glb_cntl;
+	u32 l2sw_rsv1;
+	u32 led_port0;
+	u32 led_port1;
+	u32 led_port2;
+	u32 led_port3;
+	u32 led_port4;
+	u32 watch_dog_trig_rst;
+	u32 watch_dog_stop_cpu;
+	u32 phy_cntl_reg0;
+	u32 phy_cntl_reg1;
+	u32 mac_force_mode;
+	u32 vlan_group_config0;
+	u32 vlan_group_config1;
+	u32 flow_ctrl_th3;
+	u32 queue_status_0;
+	u32 debug_cntl;
+	u32 l2sw_rsv2;
+	u32 mem_test_info;
+	u32 sw_int_status_1;
+	u32 sw_int_mask_1;
+	u32 l2sw_rsv3[76];
+	u32 cpu_tx_trig;
+	u32 tx_hbase_addr_0;
+	u32 tx_lbase_addr_0;
+	u32 rx_hbase_addr_0;
+	u32 rx_lbase_addr_0;
+	u32 tx_hw_addr_0;
+	u32 tx_lw_addr_0;
+	u32 rx_hw_addr_0;
+	u32 rx_lw_addr_0;
+	u32 cpu_port_cntl_reg_0;
+	u32 tx_hbase_addr_1;
+	u32 tx_lbase_addr_1;
+	u32 rx_hbase_addr_1;
+	u32 rx_lbase_addr_1;
+	u32 tx_hw_addr_1;
+	u32 tx_lw_addr_1;
+	u32 rx_hw_addr_1;
+	u32 rx_lw_addr_1;
+	u32 cpu_port_cntl_reg_1;
+};
+
+/* TYPE: RegisterFile_MOON5 */
+struct moon5_reg {
+	u32 mo5_thermal_ctl_0;
+	u32 mo5_thermal_ctl_1;
+	u32 mo4_thermal_ctl_2;
+	u32 mo4_thermal_ctl_3;
+	u32 mo4_tmds_l2sw_ctl;
+	u32 mo4_l2sw_clksw_ctl;
+};
+
+#endif
-- 
2.7.4

