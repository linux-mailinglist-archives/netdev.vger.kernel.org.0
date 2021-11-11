Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EF244D3BC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhKKJIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbhKKJH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:07:58 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A06C061766;
        Thu, 11 Nov 2021 01:05:09 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso4200048pjb.0;
        Thu, 11 Nov 2021 01:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=bWdFlcyVgowwpoJImVtY0kWC6pF3YogSSCYUoISlTOM=;
        b=fXdP80rfQPZduAfVFAaQLnvguD3YOd9MPWSJ507OZep72AG+N07Y81Puym/yM2/CSy
         ay2s2CUI+5G2yKMgW6g1sLMH5I3HXO/MxphNo8kq+wRdj4sDcwTLKBQZBtxQWGKiyPHm
         qg95uOPb6qDcpckxy2JyVoVFvVWDF4Ql5m8WKC57bNN+NLvDHDic3Ey7MOIutFW8u/XI
         ZN16Gz6sewWNIumbQWmgYwxpVnQ8+VNMvurdo5TN2O1vfsslNq2y6zoXpGsvn2rtR4Do
         yRrL+4C5WdYxgF+oXieaA/DuhjJuDYfAK292Z9OXIqwu9ZYvVI+eD+UnpL4RYDQcuWqA
         oX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=bWdFlcyVgowwpoJImVtY0kWC6pF3YogSSCYUoISlTOM=;
        b=wY865Rl5JN2vncBhg7IRlk1ypvuIeYTjEnGOZ3SkNrPJf8SDHIqN4JOuuRWmP9QUO/
         EhRmLx+ZW6Vph/+RzC2fgY0SIpSdp84vQEv8zonJwbGaCRt6cHW9vI01JqKS02ltUgNl
         g93/lFKEmY75+hriw3k/GroEoDNNAwG4gP+pLoORFdNNB3vjxZdDgydrFRnT25s1cxWo
         IOAEz5MuWKbD/mkWlPzj/84FnY8k8B/tvGNm8sRV41Wfk0vmIa6HwjCDL6ij1EWyrfPb
         9XyWAtM1/7SuLWJ3H/Z8jNquE21bUgc+wqzNOz29AVVH3jK4itRqVHxuq21RQVcEjrsb
         UWag==
X-Gm-Message-State: AOAM5307q7AJlyhoMhOPdOVJKcuRHaZEjozq0JbYplV+m778jQ0clMQE
        JA3JckzyipQf+kMAfB+aGCI=
X-Google-Smtp-Source: ABdhPJyd8mtNTHYj9I+rnidVBoLB2el2gOUFfDEwuULzaz++iGvleRflb1x5byaWuDbmXdG46LM6cg==
X-Received: by 2002:a17:90a:9606:: with SMTP id v6mr24470357pjo.27.1636621508260;
        Thu, 11 Nov 2021 01:05:08 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id cv1sm7626011pjb.48.2021.11.11.01.05.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Nov 2021 01:05:07 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
X-Google-Original-From: Wells Lu <wells.lu@sunplus.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     vincent.shih@sunplus.com, Wells Lu <wells.lu@sunplus.com>
Subject: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Date:   Thu, 11 Nov 2021 17:04:21 +0800
Message-Id: <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1636620754.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
In-Reply-To: <cover.1636620754.git.wells.lu@sunplus.com>
References: <cover.1636620754.git.wells.lu@sunplus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver for Sunplus SP7021.

Signed-off-by: Wells Lu <wells.lu@sunplus.com>
---
Changes in V2
 - Addressed all comments from Mr. Philipp Zabel.
   - Revised probe function.
 - Addressed all comments from Mr. Randy Dunlap.
   - Revised Kconfig
 - Addressed all comments from Mr. Andrew Lunn.
   - Removed daisy-chain (hub) function. Only keep dual NIC mode.
   - Removed dynamic mode-switching function using sysfs.
   - Removed unnecessary wmb().
   - Replaced prefix l2sw_ with sp_ for struct, funciton and file names.
   - Modified ethernet_do_ioctl() function.
   - Removed ethernet_do_change_mtu() function.
   - Revised Kconfig. Added '|| COMPILE_TEST'
   - Others
 - Replaced HWREG_R() and HWREG_W() macro with readl() and writel().
 - Created new file sp_phy.c/sp_phy.h and moved phy-related functions in.
 - Revised function name in sp_hal.c/.h to add hal_ prefix.

 MAINTAINERS                                |   1 +
 drivers/net/ethernet/Kconfig               |   1 +
 drivers/net/ethernet/Makefile              |   1 +
 drivers/net/ethernet/sunplus/Kconfig       |  36 ++
 drivers/net/ethernet/sunplus/Makefile      |   6 +
 drivers/net/ethernet/sunplus/sp_define.h   | 212 ++++++++++
 drivers/net/ethernet/sunplus/sp_desc.c     | 231 +++++++++++
 drivers/net/ethernet/sunplus/sp_desc.h     |  21 +
 drivers/net/ethernet/sunplus/sp_driver.c   | 606 +++++++++++++++++++++++++++++
 drivers/net/ethernet/sunplus/sp_driver.h   |  23 ++
 drivers/net/ethernet/sunplus/sp_hal.c      | 331 ++++++++++++++++
 drivers/net/ethernet/sunplus/sp_hal.h      |  31 ++
 drivers/net/ethernet/sunplus/sp_int.c      | 286 ++++++++++++++
 drivers/net/ethernet/sunplus/sp_int.h      |  13 +
 drivers/net/ethernet/sunplus/sp_mac.c      |  63 +++
 drivers/net/ethernet/sunplus/sp_mac.h      |  23 ++
 drivers/net/ethernet/sunplus/sp_mdio.c     |  90 +++++
 drivers/net/ethernet/sunplus/sp_mdio.h     |  20 +
 drivers/net/ethernet/sunplus/sp_phy.c      |  64 +++
 drivers/net/ethernet/sunplus/sp_phy.h      |  16 +
 drivers/net/ethernet/sunplus/sp_register.h |  96 +++++
 21 files changed, 2171 insertions(+)
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/sp_define.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_driver.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_hal.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_hal.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_int.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_int.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_phy.c
 create mode 100644 drivers/net/ethernet/sunplus/sp_phy.h
 create mode 100644 drivers/net/ethernet/sunplus/sp_register.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 737b9d0..ec1ddb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18006,6 +18006,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 W:	https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
 F:	Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
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
index 0000000..5af2c5b
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/Kconfig
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Sunplus network device configuration
+#
+
+config NET_VENDOR_SUNPLUS
+	bool "Sunplus devices"
+	default y
+	depends on ARCH_SUNPLUS || COMPILE_TEST
+	help
+	  If you have a network (Ethernet) card belonging to this
+	  class, say Y here.
+
+	  Note that the answer to this question doesn't directly
+	  affect the kernel: saying N will just cause the configurator
+	  to skip all the questions about Sunplus cards. If you say Y,
+	  you will be asked for your specific card in the following
+	  questions.
+
+if NET_VENDOR_SUNPLUS
+
+config SP7021_EMAC
+	tristate "Sunplus Dual 10M/100M Ethernet devices"
+	depends on SOC_SP7021 || COMPILE_TEST
+	select PHYLIB
+	select PINCTRL_SPPCTL
+	select COMMON_CLK_SP7021
+	select RESET_SUNPLUS
+	select NVMEM_SUNPLUS_OCOTP
+	help
+	  If you have Sunplus dual 10M/100M Ethernet devices, say Y.
+	  The network device creates two net-device interfaces.
+	  To compile this driver as a module, choose M here. The
+	  module will be called sp7021_emac.
+
+endif # NET_VENDOR_SUNPLUS
diff --git a/drivers/net/ethernet/sunplus/Makefile b/drivers/net/ethernet/sunplus/Makefile
new file mode 100644
index 0000000..963ba1d
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Sunplus network device drivers.
+#
+obj-$(CONFIG_SP7021_EMAC) += sp7021_emac.o
+sp7021_emac-objs := sp_driver.o sp_int.o sp_hal.o sp_desc.o sp_mac.o sp_mdio.o sp_phy.o
diff --git a/drivers/net/ethernet/sunplus/sp_define.h b/drivers/net/ethernet/sunplus/sp_define.h
new file mode 100644
index 0000000..40e15ba
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_define.h
@@ -0,0 +1,212 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_DEFINE_H__
+#define __SP_DEFINE_H__
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
+struct sp_common {
+	void __iomem *sp_reg_base;
+	void __iomem *moon5_reg_base;
+
+	struct net_device *ndev;
+	struct platform_device *pdev;
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
+
+	struct napi_struct rx_napi;
+	struct napi_struct tx_napi;
+
+	spinlock_t rx_lock;      // spinlock for accessing rx buffer
+	spinlock_t tx_lock;      // spinlock for accessing tx buffer
+	spinlock_t ioctl_lock;   // spinlock for ioctl operations
+
+	u8 enable;
+};
+
+struct sp_mac {
+	struct net_device *ndev;
+	struct net_device *next_ndev;
+	struct phy_device *phy_dev;
+	struct sp_common *comm;
+	struct net_device_stats dev_stats;
+	struct device_node *phy_node;
+	phy_interface_t phy_mode;
+	u32 phy_addr;
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
diff --git a/drivers/net/ethernet/sunplus/sp_desc.c b/drivers/net/ethernet/sunplus/sp_desc.c
new file mode 100644
index 0000000..fed91ec
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_desc.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "sp_desc.h"
+#include "sp_define.h"
+
+void rx_descs_flush(struct sp_common *comm)
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
+void tx_descs_clean(struct sp_common *comm)
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
+void rx_descs_clean(struct sp_common *comm)
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
+void descs_clean(struct sp_common *comm)
+{
+	rx_descs_clean(comm);
+	tx_descs_clean(comm);
+}
+
+void descs_free(struct sp_common *comm)
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
+void tx_descs_init(struct sp_common *comm)
+{
+	memset(comm->tx_desc, '\0', sizeof(struct mac_desc) *
+	       (TX_DESC_NUM + MAC_GUARD_DESC_NUM));
+}
+
+int rx_descs_init(struct sp_common *comm)
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
+			skb->dev = comm->ndev;
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
+int descs_alloc(struct sp_common *comm)
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
+int descs_init(struct sp_common *comm)
+{
+	u32 i, ret;
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
+	ret = descs_alloc(comm);
+	if (ret) {
+		netdev_err(comm->ndev, "Failed to allocate tx & rx descriptors!\n");
+		return ret;
+	}
+
+	tx_descs_init(comm);
+
+	return rx_descs_init(comm);
+}
diff --git a/drivers/net/ethernet/sunplus/sp_desc.h b/drivers/net/ethernet/sunplus/sp_desc.h
new file mode 100644
index 0000000..20f7519
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_desc.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_DESC_H__
+#define __SP_DESC_H__
+
+#include "sp_define.h"
+
+void rx_descs_flush(struct sp_common *comm);
+void tx_descs_clean(struct sp_common *comm);
+void rx_descs_clean(struct sp_common *comm);
+void descs_clean(struct sp_common *comm);
+void descs_free(struct sp_common *comm);
+void tx_descs_init(struct sp_common *comm);
+int  rx_descs_init(struct sp_common *comm);
+int  descs_alloc(struct sp_common *comm);
+int  descs_init(struct sp_common *comm);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/sp_driver.c b/drivers/net/ethernet/sunplus/sp_driver.c
new file mode 100644
index 0000000..a1c76b9
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_driver.c
@@ -0,0 +1,606 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include <linux/clk.h>
+#include <linux/reset.h>
+#include <linux/nvmem-consumer.h>
+#include <linux/of_net.h>
+#include "sp_driver.h"
+#include "sp_phy.h"
+
+static const char def_mac_addr[ETHERNET_MAC_ADDR_LEN] = {
+	0xfc, 0x4b, 0xbc, 0x00, 0x00, 0x00
+};
+
+/*********************************************************************
+ *
+ * net_device_ops
+ *
+ **********************************************************************/
+static int ethernet_open(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	netdev_dbg(ndev, "Open port = %x\n", mac->lan_port);
+
+	mac->comm->enable |= mac->lan_port;
+
+	hal_mac_start(mac);
+	write_sw_int_mask0(mac, read_sw_int_mask0(mac) & ~(MAC_INT_TX | MAC_INT_RX));
+
+	netif_carrier_on(ndev);
+	if (netif_carrier_ok(ndev))
+		netif_start_queue(ndev);
+
+	return 0;
+}
+
+static int ethernet_stop(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	netif_stop_queue(ndev);
+	netif_carrier_off(ndev);
+
+	mac->comm->enable &= ~mac->lan_port;
+
+	hal_mac_stop(mac);
+
+	return 0;
+}
+
+/* Transmit a packet (called by the kernel) */
+static int ethernet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+	struct sp_common *comm = mac->comm;
+	u32 tx_pos;
+	u32 cmd1;
+	u32 cmd2;
+	struct mac_desc *txdesc;
+	struct skb_info *skbinfo;
+	unsigned long flags;
+
+	if (unlikely(comm->tx_desc_full == 1)) {
+		// No TX descriptors left. Wait for tx interrupt.
+		netdev_info(ndev, "TX descriptor queue full when xmit!\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	/* if skb size shorter than 60, fill it with '\0' */
+	if (unlikely(skb->len < ETH_ZLEN)) {
+		if (skb_tailroom(skb) >= (ETH_ZLEN - skb->len)) {
+			memset(__skb_put(skb, ETH_ZLEN - skb->len), '\0',
+			       ETH_ZLEN - skb->len);
+		} else {
+			struct sk_buff *old_skb = skb;
+
+			skb = dev_alloc_skb(ETH_ZLEN + TX_OFFSET);
+			if (skb) {
+				memset(skb->data + old_skb->len, '\0',
+				       ETH_ZLEN - old_skb->len);
+				memcpy(skb->data, old_skb->data, old_skb->len);
+				skb_put(skb, ETH_ZLEN);	/* add data to an sk_buff */
+				dev_kfree_skb_irq(old_skb);
+			} else {
+				skb = old_skb;
+			}
+		}
+	}
+
+	spin_lock_irqsave(&comm->tx_lock, flags);
+	tx_pos = comm->tx_pos;
+	txdesc = &comm->tx_desc[tx_pos];
+	skbinfo = &comm->tx_temp_skb_info[tx_pos];
+	skbinfo->len = skb->len;
+	skbinfo->skb = skb;
+	skbinfo->mapping = dma_map_single(&comm->pdev->dev, skb->data,
+					  skb->len, DMA_TO_DEVICE);
+	cmd1 = (OWN_BIT | FS_BIT | LS_BIT | (mac->to_vlan << 12) | (skb->len & LEN_MASK));
+	cmd2 = skb->len & LEN_MASK;
+
+	if (tx_pos == (TX_DESC_NUM - 1))
+		cmd2 |= EOR_BIT;
+
+	txdesc->addr1 = skbinfo->mapping;
+	txdesc->cmd2 = cmd2;
+	wmb();	// Set OWN_BIT after other fields of descriptor are effective.
+	txdesc->cmd1 = cmd1;
+
+	NEXT_TX(tx_pos);
+
+	if (unlikely(tx_pos == comm->tx_done_pos)) {
+		netif_stop_queue(ndev);
+		comm->tx_desc_full = 1;
+	}
+	comm->tx_pos = tx_pos;
+	wmb();			// make sure settings are effective.
+
+	/* trigger gmac to transmit */
+	hal_tx_trigger(mac);
+
+	spin_unlock_irqrestore(&mac->comm->tx_lock, flags);
+	return NETDEV_TX_OK;
+}
+
+static void ethernet_set_rx_mode(struct net_device *ndev)
+{
+	if (ndev) {
+		struct sp_mac *mac = netdev_priv(ndev);
+		struct sp_common *comm = mac->comm;
+		unsigned long flags;
+
+		spin_lock_irqsave(&comm->ioctl_lock, flags);
+		hal_rx_mode_set(ndev);
+		spin_unlock_irqrestore(&comm->ioctl_lock, flags);
+	}
+}
+
+static int ethernet_set_mac_address(struct net_device *ndev, void *addr)
+{
+	struct sockaddr *hwaddr = (struct sockaddr *)addr;
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	if (netif_running(ndev))
+		return -EBUSY;
+
+	memcpy(ndev->dev_addr, hwaddr->sa_data, ndev->addr_len);
+
+	/* Delete the old Ethernet MAC address */
+	netdev_dbg(ndev, "HW Addr = %pM\n", mac->mac_addr);
+	if (is_valid_ether_addr(mac->mac_addr))
+		hal_mac_addr_del(mac);
+
+	/* Set the Ethernet MAC address */
+	memcpy(mac->mac_addr, hwaddr->sa_data, ndev->addr_len);
+	hal_mac_addr_set(mac);
+
+	return 0;
+}
+
+static int ethernet_do_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	switch (cmd) {
+	case SIOCGMIIPHY:
+	case SIOCGMIIREG:
+	case SIOCSMIIREG:
+		return phy_mii_ioctl(mac->phy_dev, ifr, cmd);
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static void ethernet_tx_timeout(struct net_device *ndev, unsigned int txqueue)
+{
+}
+
+static struct net_device_stats *ethernet_get_stats(struct net_device *ndev)
+{
+	struct sp_mac *mac;
+
+	mac = netdev_priv(ndev);
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
+	.ndo_tx_timeout = ethernet_tx_timeout,
+	.ndo_get_stats = ethernet_get_stats,
+};
+
+char *sp7021_otp_read_mac(struct device *dev, ssize_t *len, char *name)
+{
+	char *ret = NULL;
+	struct nvmem_cell *cell = nvmem_cell_get(dev, name);
+
+	if (IS_ERR_OR_NULL(cell)) {
+		dev_err(dev, "OTP %s read failure: %ld", name, PTR_ERR(cell));
+		return NULL;
+	}
+
+	ret = nvmem_cell_read(cell, len);
+	nvmem_cell_put(cell);
+	dev_dbg(dev, "%zd bytes are read from OTP %s.", *len, name);
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
+	struct sp_mac *mac;
+	struct net_device *ndev;
+	char *m_addr_name = (eth_no == 0) ? "mac_addr0" : "mac_addr1";
+	ssize_t otp_l = 0;
+	char *otp_v;
+	int ret;
+
+	// Allocate the devices, and also allocate sp_mac, we can get it by netdev_priv().
+	ndev = alloc_etherdev(sizeof(*mac));
+	if (!ndev) {
+		*r_ndev = NULL;
+		return -ENOMEM;
+	}
+	SET_NETDEV_DEV(ndev, &pdev->dev);
+	ndev->netdev_ops = &netdev_ops;
+
+	mac = netdev_priv(ndev);
+	mac->ndev = ndev;
+	mac->next_ndev = NULL;
+
+	// Get property 'mac-addr0' or 'mac-addr1' from dts.
+	otp_v = sp7021_otp_read_mac(&pdev->dev, &otp_l, m_addr_name);
+	if ((otp_l < 6) || IS_ERR_OR_NULL(otp_v)) {
+		dev_info(&pdev->dev, "OTP mac %s (len = %zd) is invalid, using default!\n",
+			 m_addr_name, otp_l);
+		otp_l = 0;
+	} else {
+		// Check if mac-address is valid or not. If not, copy from default.
+		memcpy(mac->mac_addr, otp_v, 6);
+
+		// Byte order of Some samples are reversed. Convert byte order here.
+		check_mac_vendor_id_and_convert(mac->mac_addr);
+
+		if (!is_valid_ether_addr(mac->mac_addr)) {
+			dev_info(&pdev->dev, "Invalid mac in OTP[%s] = %pM, use default!\n",
+				 m_addr_name, mac->mac_addr);
+			otp_l = 0;
+		}
+	}
+	if (otp_l != 6) {
+		memcpy(mac->mac_addr, def_mac_addr, ETHERNET_MAC_ADDR_LEN);
+		mac->mac_addr[5] += eth_no;
+	}
+
+	dev_info(&pdev->dev, "HW Addr = %pM\n", mac->mac_addr);
+
+	memcpy(ndev->dev_addr, mac->mac_addr, ETHERNET_MAC_ADDR_LEN);
+
+	ret = register_netdev(ndev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register net device \"%s\"!\n",
+			ndev->name);
+		free_netdev(ndev);
+		*r_ndev = NULL;
+		return ret;
+	}
+	netdev_info(ndev, "Registered net device \"%s\" successfully.\n", ndev->name);
+
+	*r_ndev = ndev;
+	return 0;
+}
+
+static int soc0_open(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 ret;
+
+	hal_mac_stop(mac);
+
+	ret = descs_init(comm);
+	if (ret) {
+		netdev_err(mac->ndev, "Fail to initialize mac descriptors!\n");
+		descs_free(comm);
+		return ret;
+	}
+
+	mac_init(mac);
+	return 0;
+}
+
+static int soc0_stop(struct sp_mac *mac)
+{
+	hal_mac_stop(mac);
+
+	descs_free(mac->comm);
+	return 0;
+}
+
+static int sp_probe(struct platform_device *pdev)
+{
+	struct sp_common *comm;
+	struct resource *rc;
+	struct net_device *ndev, *ndev2;
+	struct device_node *np;
+	struct sp_mac *mac, *mac2;
+	int ret;
+
+	if (platform_get_drvdata(pdev))
+		return -ENODEV;
+
+	// Allocate memory for 'sp_common' area.
+	comm = devm_kzalloc(&pdev->dev, sizeof(*comm), GFP_KERNEL);
+	if (!comm)
+		return -ENOMEM;
+	comm->pdev = pdev;
+
+	spin_lock_init(&comm->rx_lock);
+	spin_lock_init(&comm->tx_lock);
+	spin_lock_init(&comm->ioctl_lock);
+
+	// Get memory resoruce "emac" from dts.
+	rc = platform_get_resource_byname(pdev, IORESOURCE_MEM, "emac");
+	if (!rc) {
+		dev_err(&pdev->dev, "No MEM resource \'emac\' found!\n");
+		return -ENXIO;
+	}
+	dev_dbg(&pdev->dev, "name = \"%s\", start = %pa\n", rc->name, &rc->start);
+
+	comm->sp_reg_base = devm_ioremap_resource(&pdev->dev, rc);
+	if (IS_ERR(comm->sp_reg_base)) {
+		dev_err(&pdev->dev, "ioremap failed!\n");
+		return -ENOMEM;
+	}
+
+	// Get memory resoruce "moon5" from dts.
+	rc = platform_get_resource_byname(pdev, IORESOURCE_MEM, "moon5");
+	if (!rc) {
+		dev_err(&pdev->dev, "No MEM resource \'moon5\' found!\n");
+		return -ENXIO;
+	}
+	dev_dbg(&pdev->dev, "name = \"%s\", start = %pa\n", rc->name, &rc->start);
+
+	// Note that moon5 is shared resource. Don't use devm_ioremap_resource().
+	comm->moon5_reg_base = devm_ioremap(&pdev->dev, rc->start, rc->end - rc->start + 1);
+	if (IS_ERR(comm->moon5_reg_base)) {
+		dev_err(&pdev->dev, "ioremap failed!\n");
+		return -ENOMEM;
+	}
+
+	// Get irq resource from dts.
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+	comm->irq = ret;
+
+	// Get clock controller.
+	comm->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(comm->clk)) {
+		dev_err_probe(&pdev->dev, PTR_ERR(comm->clk),
+			      "Failed to retrieve clock controller!\n");
+		return PTR_ERR(comm->clk);
+	}
+
+	// Get reset controller.
+	comm->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
+	if (IS_ERR(comm->rstc)) {
+		dev_err_probe(&pdev->dev, PTR_ERR(comm->rstc),
+			      "Failed to retrieve reset controller!\n");
+		return PTR_ERR(comm->rstc);
+	}
+
+	// Enable clock.
+	clk_prepare_enable(comm->clk);
+	udelay(1);
+
+	reset_control_assert(comm->rstc);
+	udelay(1);
+	reset_control_deassert(comm->rstc);
+	udelay(1);
+
+	// Initialize the 1st net device.
+	ret = init_netdev(pdev, 0, &ndev);
+	if (!ndev)
+		return ret;
+
+	platform_set_drvdata(pdev, ndev);
+
+	ndev->irq = comm->irq;
+	mac = netdev_priv(ndev);
+	mac->comm = comm;
+	comm->ndev = ndev;
+
+	// Get node of phy 1.
+	mac->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle1", 0);
+	if (!mac->phy_node) {
+		netdev_info(ndev, "Cannot get node of phy 1!\n");
+		ret = -ENODEV;
+		goto out_unregister_dev;
+	}
+
+	// Get address of phy from dts.
+	if (of_property_read_u32(mac->phy_node, "reg", &mac->phy_addr)) {
+		mac->phy_addr = 0;
+		netdev_info(ndev, "Cannot get address of phy 1! Set to 0.\n");
+	}
+
+	// Get mode of phy from dts.
+	if (of_get_phy_mode(mac->phy_node, &mac->phy_mode)) {
+		mac->phy_mode = PHY_INTERFACE_MODE_RGMII_ID;
+		netdev_info(ndev, "Missing phy-mode of phy 1! Set to \'rgmii-id\'.\n");
+	}
+
+	// Request irq.
+	ret = devm_request_irq(&pdev->dev, comm->irq, ethernet_interrupt, 0,
+			       ndev->name, ndev);
+	if (ret) {
+		netdev_err(ndev, "Failed to request irq #%d for \"%s\"!\n",
+			   ndev->irq, ndev->name);
+		goto out_unregister_dev;
+	}
+
+	mac->cpu_port = 0x1;	// soc0
+	mac->lan_port = 0x1;	// forward to port 0
+	mac->to_vlan = 0x1;	// vlan group: 0
+	mac->vlan_id = 0x0;	// vlan group: 0
+
+	// Set MAC address
+	hal_mac_addr_set(mac);
+	hal_rx_mode_set(ndev);
+	hal_mac_addr_table_del_all(mac);
+
+	ndev2 = NULL;
+	np = of_parse_phandle(pdev->dev.of_node, "phy-handle2", 0);
+	if (np) {
+		init_netdev(pdev, 1, &ndev2);
+		if (ndev2) {
+			mac->next_ndev = ndev2; // Point to the second net device.
+
+			ndev2->irq = comm->irq;
+			mac2 = netdev_priv(ndev2);
+			mac2->comm = comm;
+			mac2->phy_node = np;
+
+			if (of_property_read_u32(mac2->phy_node, "reg", &mac2->phy_addr)) {
+				mac2->phy_addr = 1;
+				netdev_info(ndev2, "Cannot get address of phy 2! Set to 1.\n");
+			}
+
+			if (of_get_phy_mode(mac2->phy_node, &mac2->phy_mode)) {
+				mac2->phy_mode = PHY_INTERFACE_MODE_RGMII_ID;
+				netdev_info(ndev, "Missing phy-mode phy 2! Set to \'rgmii-id\'.\n");
+			}
+
+			mac2->cpu_port = 0x1;	// soc0
+			mac2->lan_port = 0x2;	// forward to port 1
+			mac2->to_vlan = 0x2;	// vlan group: 1
+			mac2->vlan_id = 0x1;	// vlan group: 1
+
+			hal_mac_addr_set(mac2);	// Set MAC address for the 2nd net device.
+			hal_rx_mode_set(ndev2);
+		}
+	}
+
+	soc0_open(mac);
+	hal_set_rmii_tx_rx_pol(mac);
+	hal_phy_addr(mac);
+
+	ret = mdio_init(pdev, ndev);
+	if (ret) {
+		netdev_err(ndev, "Failed to initialize mdio!\n");
+		goto out_unregister_dev;
+	}
+
+	ret = sp_phy_probe(ndev);
+	if (ret) {
+		netdev_err(ndev, "Failed to probe phy!\n");
+		goto out_freemdio;
+	}
+
+	if (ndev2) {
+		ret = sp_phy_probe(ndev2);
+		if (ret) {
+			netdev_err(ndev2, "Failed to probe phy!\n");
+			unregister_netdev(ndev2);
+			mac->next_ndev = 0;
+		}
+	}
+
+	netif_napi_add(ndev, &comm->rx_napi, rx_poll, RX_NAPI_WEIGHT);
+	napi_enable(&comm->rx_napi);
+	netif_napi_add(ndev, &comm->tx_napi, tx_poll, TX_NAPI_WEIGHT);
+	napi_enable(&comm->tx_napi);
+	return 0;
+
+out_freemdio:
+	if (comm->mii_bus)
+		mdio_remove(ndev);
+
+out_unregister_dev:
+	unregister_netdev(ndev);
+	if (ndev2)
+		unregister_netdev(ndev2);
+
+	return ret;
+}
+
+static int sp_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev, *ndev2;
+	struct sp_mac *mac;
+
+	ndev = platform_get_drvdata(pdev);
+	if (!ndev)
+		return 0;
+
+	mac = netdev_priv(ndev);
+
+	// Unregister and free 2nd net device.
+	ndev2 = mac->next_ndev;
+	if (ndev2) {
+		sp_phy_remove(ndev2);
+		unregister_netdev(ndev2);
+		free_netdev(ndev2);
+	}
+
+	mac->comm->enable = 0;
+	soc0_stop(mac);
+
+	// Disable and delete napi.
+	napi_disable(&mac->comm->rx_napi);
+	netif_napi_del(&mac->comm->rx_napi);
+	napi_disable(&mac->comm->tx_napi);
+	netif_napi_del(&mac->comm->tx_napi);
+
+	sp_phy_remove(ndev);
+	mdio_remove(ndev);
+
+	// Unregister and free 1st net device.
+	unregister_netdev(ndev);
+	free_netdev(ndev);
+
+	clk_disable(mac->comm->clk);
+
+	return 0;
+}
+
+static const struct of_device_id sp_of_match[] = {
+	{.compatible = "sunplus,sp7021-emac"},
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, sp_of_match);
+
+static struct platform_driver sp_driver = {
+	.probe = sp_probe,
+	.remove = sp_remove,
+	.driver = {
+		.name = "sp7021_emac",
+		.owner = THIS_MODULE,
+		.of_match_table = sp_of_match,
+	},
+};
+
+module_platform_driver(sp_driver);
+
+MODULE_AUTHOR("Wells Lu <wells.lu@sunplus.com>");
+MODULE_DESCRIPTION("Sunplus Dual 10M/100M Ethernet driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/sunplus/sp_driver.h b/drivers/net/ethernet/sunplus/sp_driver.h
new file mode 100644
index 0000000..ea80a9e
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_driver.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_DRIVER_H__
+#define __SP_DRIVER_H__
+
+#include "sp_define.h"
+#include "sp_register.h"
+#include "sp_hal.h"
+#include "sp_int.h"
+#include "sp_mdio.h"
+#include "sp_mac.h"
+#include "sp_desc.h"
+
+#define NEXT_TX(N)              ((N) = (((N) + 1) == TX_DESC_NUM) ? 0 : (N) + 1)
+#define NEXT_RX(QUEUE, N)       ((N) = (((N) + 1) == mac->comm->rx_desc_num[QUEUE]) ? 0 : (N) + 1)
+
+#define RX_NAPI_WEIGHT          16
+#define TX_NAPI_WEIGHT          16
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/sp_hal.c b/drivers/net/ethernet/sunplus/sp_hal.c
new file mode 100644
index 0000000..a7f06d7
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_hal.c
@@ -0,0 +1,331 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include <linux/iopoll.h>
+#include "sp_hal.h"
+
+void hal_mac_stop(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg, disable;
+
+	if (comm->enable == 0) {
+		// Mask and clear all interrupts, except PORT_ST_CHG.
+		write_sw_int_mask0(mac, 0xffffffff);
+		writel(0xffffffff & (~MAC_INT_PORT_ST_CHG),
+		       comm->sp_reg_base + SP_SW_INT_STATUS_0);
+
+		// Disable cpu 0 and cpu 1.
+		reg = readl(comm->sp_reg_base + SP_CPU_CNTL);
+		writel((0x3 << 6) | reg, comm->sp_reg_base + SP_CPU_CNTL);
+	}
+
+	// Disable lan 0 and lan 1.
+	disable = ((~comm->enable) & 0x3) << 24;
+	reg = readl(comm->sp_reg_base + SP_PORT_CNTL0);
+	writel(disable | reg, comm->sp_reg_base + SP_PORT_CNTL0);
+}
+
+void hal_mac_reset(struct sp_mac *mac)
+{
+}
+
+void hal_mac_start(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg;
+
+	// Enable cpu port 0 (6) & port 0 crc padding (8)
+	reg = readl(comm->sp_reg_base + SP_CPU_CNTL);
+	writel((reg & (~(0x1 << 6))) | (0x1 << 8), comm->sp_reg_base + SP_CPU_CNTL);
+
+	// Enable lan 0 & lan 1
+	reg = readl(comm->sp_reg_base + SP_PORT_CNTL0);
+	writel(reg & (~(comm->enable << 24)), comm->sp_reg_base + SP_PORT_CNTL0);
+}
+
+void hal_mac_addr_set(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg;
+
+	// Write MAC address.
+	writel(mac->mac_addr[0] + (mac->mac_addr[1] << 8),
+	       comm->sp_reg_base + SP_W_MAC_15_0);
+	writel(mac->mac_addr[2] + (mac->mac_addr[3] << 8) + (mac->mac_addr[4] << 16) +
+	      (mac->mac_addr[5] << 24),	comm->sp_reg_base + SP_W_MAC_47_16);
+
+	// Set aging=1
+	writel((mac->cpu_port << 10) + (mac->vlan_id << 7) + (1 << 4) + 0x1,
+	       comm->sp_reg_base + SP_WT_MAC_AD0);
+
+	// Wait for completing.
+	do {
+		reg = readl(comm->sp_reg_base + SP_WT_MAC_AD0);
+		ndelay(10);
+		netdev_dbg(mac->ndev, "wt_mac_ad0 = %08x\n", reg);
+	} while ((reg & (0x1 << 1)) == 0x0);
+
+	netdev_dbg(mac->ndev, "mac_ad0 = %08x, mac_ad = %08x%04x\n",
+		   readl(comm->sp_reg_base + SP_WT_MAC_AD0),
+		   readl(comm->sp_reg_base + SP_W_MAC_47_16),
+		   readl(comm->sp_reg_base + SP_W_MAC_15_0) & 0xffff);
+}
+
+void hal_mac_addr_del(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg;
+
+	// Write MAC address.
+	writel(mac->mac_addr[0] + (mac->mac_addr[1] << 8),
+	       comm->sp_reg_base + SP_W_MAC_15_0);
+	writel(mac->mac_addr[2] + (mac->mac_addr[3] << 8) + (mac->mac_addr[4] << 16) +
+	       (mac->mac_addr[5] << 24), comm->sp_reg_base + SP_W_MAC_47_16);
+
+	// Wait for completing.
+	writel((0x1 << 12) + (mac->vlan_id << 7) + 0x1,
+	       comm->sp_reg_base + SP_WT_MAC_AD0);
+	do {
+		reg = readl(comm->sp_reg_base + SP_WT_MAC_AD0);
+		ndelay(10);
+		netdev_dbg(mac->ndev, "wt_mac_ad0 = %08x\n", reg);
+	} while ((reg & (0x1 << 1)) == 0x0);
+
+	netdev_dbg(mac->ndev, "mac_ad0 = %08x, mac_ad = %08x%04x\n",
+		   readl(comm->sp_reg_base + SP_WT_MAC_AD0),
+		   readl(comm->sp_reg_base + SP_W_MAC_47_16),
+		   readl(comm->sp_reg_base + SP_W_MAC_15_0) & 0xffff);
+}
+
+void hal_mac_addr_table_del_all(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg;
+
+	// Wait for address table being idle.
+	do {
+		reg = readl(comm->sp_reg_base + SP_ADDR_TBL_SRCH);
+		ndelay(10);
+	} while (!(reg & MAC_ADDR_LOOKUP_IDLE));
+
+	// Search address table from start.
+	writel(readl(comm->sp_reg_base + SP_ADDR_TBL_SRCH) | MAC_BEGIN_SEARCH_ADDR,
+	       comm->sp_reg_base + SP_ADDR_TBL_SRCH);
+	while (1) {
+		do {
+			reg = readl(comm->sp_reg_base + SP_ADDR_TBL_ST);
+			ndelay(10);
+			netdev_dbg(mac->ndev, "addr_tbl_st = %08x\n", reg);
+		} while (!(reg & (MAC_AT_TABLE_END | MAC_AT_DATA_READY)));
+
+		if (reg & MAC_AT_TABLE_END)
+			break;
+
+		netdev_dbg(mac->ndev, "addr_tbl_st = %08x\n", reg);
+		netdev_dbg(mac->ndev, "@AT #%u: port=%01x, cpu=%01x, vid=%u, aging=%u, proxy=%u, mc_ingress=%u\n",
+			   (reg >> 22) & 0x3ff, (reg >> 12) & 0x3, (reg >> 10) & 0x3,
+			   (reg >> 7) & 0x7, (reg >> 4) & 0x7, (reg >> 3) & 0x1,
+			   (reg >> 2) & 0x1);
+
+		// Delete all entries which are learnt from lan ports.
+		if ((reg >> 12) & 0x3) {
+			writel(readl(comm->sp_reg_base + SP_MAC_AD_SER0),
+			       comm->sp_reg_base + SP_W_MAC_15_0);
+			writel(readl(comm->sp_reg_base + SP_MAC_AD_SER1),
+			       comm->sp_reg_base + SP_W_MAC_47_16);
+
+			writel((0x1 << 12) + (reg & (0x7 << 7)) + 0x1,
+			       comm->sp_reg_base + SP_WT_MAC_AD0);
+			do {
+				reg = readl(comm->sp_reg_base + SP_WT_MAC_AD0);
+				ndelay(10);
+				netdev_dbg(mac->ndev, "wt_mac_ad0 = %08x\n", reg);
+			} while ((reg & (0x1 << 1)) == 0x0);
+			netdev_dbg(mac->ndev, "mac_ad0 = %08x, mac_ad = %08x%04x\n",
+				   readl(comm->sp_reg_base + SP_WT_MAC_AD0),
+				   readl(comm->sp_reg_base + SP_W_MAC_47_16),
+				   readl(comm->sp_reg_base + SP_W_MAC_15_0) & 0xffff);
+		}
+
+		// Search next.
+		writel(readl(comm->sp_reg_base + SP_ADDR_TBL_SRCH) | MAC_SEARCH_NEXT_ADDR,
+		       comm->sp_reg_base + SP_ADDR_TBL_SRCH);
+	}
+}
+
+void hal_mac_init(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg;
+
+	// Disable cpu0 and cpu 1.
+	reg = readl(comm->sp_reg_base + SP_CPU_CNTL);
+	writel((0x3 << 6) | reg, comm->sp_reg_base + SP_CPU_CNTL);
+
+	// Descriptor base address
+	writel(mac->comm->desc_dma, comm->sp_reg_base + SP_TX_LBASE_ADDR_0);
+	writel(mac->comm->desc_dma + sizeof(struct mac_desc) * TX_DESC_NUM,
+	       comm->sp_reg_base + SP_TX_HBASE_ADDR_0);
+	writel(mac->comm->desc_dma + sizeof(struct mac_desc) * (TX_DESC_NUM +
+	       MAC_GUARD_DESC_NUM), comm->sp_reg_base + SP_RX_HBASE_ADDR_0);
+	writel(mac->comm->desc_dma + sizeof(struct mac_desc) * (TX_DESC_NUM +
+	       MAC_GUARD_DESC_NUM + RX_QUEUE0_DESC_NUM),
+	       comm->sp_reg_base + SP_RX_LBASE_ADDR_0);
+
+	// Fc_rls_th=0x4a, Fc_set_th=0x3a, Drop_rls_th=0x2d, Drop_set_th=0x1d
+	writel(0x4a3a2d1d, comm->sp_reg_base + SP_FL_CNTL_TH);
+
+	// Cpu_rls_th=0x4a, Cpu_set_th=0x3a, Cpu_th=0x12, Port_th=0x12
+	writel(0x4a3a1212, comm->sp_reg_base + SP_CPU_FL_CNTL_TH);
+
+	// mtcc_lmt=0xf, Pri_th_l=6, Pri_th_h=6, weigh_8x_en=1
+	writel(0xf6680000, comm->sp_reg_base + SP_PRI_FL_CNTL);
+
+	// High-active LED
+	reg = readl(comm->sp_reg_base + SP_LED_PORT0);
+	writel(reg | (1 << 28), comm->sp_reg_base + SP_LED_PORT0);
+
+	// Disable cpu port0 aging (12)
+	// Disable cpu port0 learning (14)
+	// Enable UC and MC packets
+	reg = readl(comm->sp_reg_base + SP_CPU_CNTL);
+	writel((reg & (~((0x1 << 14) | (0x3c << 0)))) | (0x1 << 12),
+	       comm->sp_reg_base + SP_CPU_CNTL);
+
+	// Disable lan port SA learning.
+	reg = readl(comm->sp_reg_base + SP_PORT_CNTL1);
+	writel(reg | (0x3 << 8), comm->sp_reg_base + SP_PORT_CNTL1);
+
+	// Port 0: VLAN group 0
+	// Port 1: VLAN group 1
+	writel((1 << 4) + 0, comm->sp_reg_base + SP_PVID_CONFIG0);
+
+	// VLAN group 0: cpu0+port0
+	// VLAN group 1: cpu0+port1
+	writel((0xa << 8) + 0x9, comm->sp_reg_base + SP_VLAN_MEMSET_CONFIG0);
+
+	// RMC forward: to cpu
+	// LED: 60mS
+	// BC storm prev: 31 BC
+	reg = readl(comm->sp_reg_base + SP_SW_GLB_CNTL);
+	writel((reg & (~((0x3 << 25) | (0x3 << 23) | (0x3 << 4)))) |
+	       (0x1 << 25) | (0x1 << 23) | (0x1 << 4),
+	       comm->sp_reg_base + SP_SW_GLB_CNTL);
+
+	write_sw_int_mask0(mac, MAC_INT_MASK_DEF);
+}
+
+void hal_rx_mode_set(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+	struct sp_common *comm = mac->comm;
+	u32 mask, reg, rx_mode;
+
+	netdev_dbg(ndev, "ndev->flags = %08x\n", ndev->flags);
+
+	mask = (mac->lan_port << 2) | (mac->lan_port << 0);
+	reg = readl(comm->sp_reg_base + SP_CPU_CNTL);
+
+	if (ndev->flags & IFF_PROMISC) {	/* Set promiscuous mode */
+		// Allow MC and unknown UC packets
+		rx_mode = (mac->lan_port << 2) | (mac->lan_port << 0);
+	} else if ((!netdev_mc_empty(ndev) && (ndev->flags & IFF_MULTICAST)) ||
+		   (ndev->flags & IFF_ALLMULTI)) {
+		// Allow MC packets
+		rx_mode = (mac->lan_port << 2);
+	} else {
+		// Disable MC and unknown UC packets
+		rx_mode = 0;
+	}
+
+	writel((reg & (~mask)) | ((~rx_mode) & mask), comm->sp_reg_base + SP_CPU_CNTL);
+	netdev_dbg(ndev, "cpu_cntl = %08x\n", readl(comm->sp_reg_base + SP_CPU_CNTL));
+}
+
+int hal_mdio_access(struct sp_mac *mac, u8 op_cd, u8 phy_addr, u8 reg_addr, u32 wdata)
+{
+	struct sp_common *comm = mac->comm;
+	u32 val, ret;
+
+	writel((wdata << 16) | (op_cd << 13) | (reg_addr << 8) | phy_addr,
+	       comm->sp_reg_base + SP_PHY_CNTL_REG0);
+
+	ret = read_poll_timeout(readl, val, val & op_cd, 10, 1000, 1,
+				comm->sp_reg_base + SP_PHY_CNTL_REG1);
+	if (ret == 0)
+		return val >> 16;
+	else
+		return ret;
+}
+
+void hal_tx_trigger(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+
+	writel((0x1 << 1), comm->sp_reg_base + SP_CPU_TX_TRIG);
+}
+
+void hal_set_rmii_tx_rx_pol(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg;
+
+	// Set polarity of RX and TX of RMII signal.
+	reg = readl(comm->moon5_reg_base + MOON5_MO4_L2SW_CLKSW_CTL);
+	writel(reg | (0xf << 16) | 0xf, comm->moon5_reg_base + MOON5_MO4_L2SW_CLKSW_CTL);
+}
+
+void hal_phy_addr(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+	u32 reg;
+
+	// Set address of phy.
+	reg = readl(comm->sp_reg_base + SP_MAC_FORCE_MODE);
+	reg = (reg & (~(0x1f << 16))) | ((mac->phy_addr & 0x1f) << 16);
+	if (mac->next_ndev) {
+		struct net_device *ndev2 = mac->next_ndev;
+		struct sp_mac *mac2 = netdev_priv(ndev2);
+
+		reg = (reg & (~(0x1f << 24))) | ((mac2->phy_addr & 0x1f) << 24);
+	}
+	writel(reg, comm->sp_reg_base + SP_MAC_FORCE_MODE);
+}
+
+u32 read_sw_int_mask0(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+
+	return readl(comm->sp_reg_base + SP_SW_INT_MASK_0);
+}
+
+void write_sw_int_mask0(struct sp_mac *mac, u32 value)
+{
+	struct sp_common *comm = mac->comm;
+
+	writel(value, comm->sp_reg_base + SP_SW_INT_MASK_0);
+}
+
+void write_sw_int_status0(struct sp_mac *mac, u32 value)
+{
+	struct sp_common *comm = mac->comm;
+
+	writel(value, comm->sp_reg_base + SP_SW_INT_STATUS_0);
+}
+
+u32 read_sw_int_status0(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+
+	return readl(comm->sp_reg_base + SP_SW_INT_STATUS_0);
+}
+
+u32 read_port_ability(struct sp_mac *mac)
+{
+	struct sp_common *comm = mac->comm;
+
+	return readl(comm->sp_reg_base + SP_PORT_ABILITY);
+}
diff --git a/drivers/net/ethernet/sunplus/sp_hal.h b/drivers/net/ethernet/sunplus/sp_hal.h
new file mode 100644
index 0000000..f4b1979
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_hal.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_HAL_H__
+#define __SP_HAL_H__
+
+#include "sp_register.h"
+#include "sp_define.h"
+#include "sp_desc.h"
+
+void hal_mac_stop(struct sp_mac *mac);
+void hal_mac_reset(struct sp_mac *mac);
+void hal_mac_start(struct sp_mac *mac);
+void hal_mac_addr_set(struct sp_mac *mac);
+void hal_mac_addr_del(struct sp_mac *mac);
+void hal_mac_addr_table_del_all(struct sp_mac *mac);
+void hal_mac_init(struct sp_mac *mac);
+void hal_rx_mode_set(struct net_device *ndev);
+int  hal_mdio_access(struct sp_mac *mac, u8 op_cd, u8 phy_addr, u8 reg_addr, u32 wdata);
+void hal_tx_trigger(struct sp_mac *mac);
+void hal_set_rmii_tx_rx_pol(struct sp_mac *mac);
+void hal_phy_addr(struct sp_mac *mac);
+u32  read_sw_int_mask0(struct sp_mac *mac);
+void write_sw_int_mask0(struct sp_mac *mac, u32 value);
+void write_sw_int_status0(struct sp_mac *mac, u32 value);
+u32  read_sw_int_status0(struct sp_mac *mac);
+u32  read_port_ability(struct sp_mac *mac);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/sp_int.c b/drivers/net/ethernet/sunplus/sp_int.c
new file mode 100644
index 0000000..27d81b6
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_int.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "sp_define.h"
+#include "sp_int.h"
+#include "sp_driver.h"
+#include "sp_hal.h"
+
+static void port_status_change(struct sp_mac *mac)
+{
+	u32 reg;
+	struct net_device *ndev = mac->ndev;
+
+	reg = read_port_ability(mac);
+	if (!netif_carrier_ok(ndev) && (reg & PORT_ABILITY_LINK_ST_P0)) {
+		netif_carrier_on(ndev);
+		netif_start_queue(ndev);
+	} else if (netif_carrier_ok(ndev) && !(reg & PORT_ABILITY_LINK_ST_P0)) {
+		netif_carrier_off(ndev);
+		netif_stop_queue(ndev);
+	}
+
+	if (mac->next_ndev) {
+		struct net_device *ndev2 = mac->next_ndev;
+
+		if (!netif_carrier_ok(ndev2) && (reg & PORT_ABILITY_LINK_ST_P1)) {
+			netif_carrier_on(ndev2);
+			netif_start_queue(ndev2);
+		} else if (netif_carrier_ok(ndev2) && !(reg & PORT_ABILITY_LINK_ST_P1)) {
+			netif_carrier_off(ndev2);
+			netif_stop_queue(ndev2);
+		}
+	}
+}
+
+static void rx_skb(struct sp_mac *mac, struct sk_buff *skb)
+{
+	mac->dev_stats.rx_packets++;
+	mac->dev_stats.rx_bytes += skb->len;
+	netif_receive_skb(skb);
+}
+
+int rx_poll(struct napi_struct *napi, int budget)
+{
+	struct sp_common *comm = container_of(napi, struct sp_common, rx_napi);
+	struct sp_mac *mac = netdev_priv(comm->ndev);
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
+			if ((cmd & PKTSP_MASK) == PKTSP_PORT1) {
+				struct sp_mac *mac2;
+
+				ndev2_pkt = 1;
+				mac2 = (mac->next_ndev) ? netdev_priv(mac->next_ndev) : NULL;
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
+			// Allocate an skbuff for receiving.
+			new_skb = __dev_alloc_skb(comm->rx_desc_buff_size + RX_OFFSET,
+						  GFP_ATOMIC | GFP_DMA);
+			if (unlikely(!new_skb)) {
+				dev_stats->rx_dropped++;
+				goto NEXT;
+			}
+			new_skb->dev = mac->ndev;
+
+			dma_unmap_single(&comm->pdev->dev, sinfo->mapping,
+					 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
+
+			skb = sinfo->skb;
+			skb->ip_summed = CHECKSUM_NONE;
+
+			/*skb_put will judge if tail exceeds end, but __skb_put won't */
+			__skb_put(skb, (pkg_len - 4 > comm->rx_desc_buff_size) ?
+				       comm->rx_desc_buff_size : pkg_len - 4);
+
+			sinfo->mapping = dma_map_single(&comm->pdev->dev, new_skb->data,
+							comm->rx_desc_buff_size,
+							DMA_FROM_DEVICE);
+			sinfo->skb = new_skb;
+
+			if (ndev2_pkt) {
+				struct net_device *netdev2 = mac->next_ndev;
+
+				if (netdev2) {
+					skb->protocol = eth_type_trans(skb, netdev2);
+					rx_skb(netdev_priv(netdev2), skb);
+				}
+			} else {
+				skb->protocol = eth_type_trans(skb, mac->ndev);
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
+	write_sw_int_mask0(mac, read_sw_int_mask0(mac) & ~MAC_INT_RX);
+
+	napi_complete(napi);
+	return 0;
+}
+
+int tx_poll(struct napi_struct *napi, int budget)
+{
+	struct sp_common *comm = container_of(napi, struct sp_common, tx_napi);
+	struct sp_mac *mac = netdev_priv(comm->ndev);
+	u32 tx_done_pos;
+	u32 cmd;
+	struct skb_info *skbinfo;
+	struct sp_mac *smac;
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
+			netdev_err(mac->ndev, "skb is null!\n");
+
+		smac = mac;
+		if (mac->next_ndev && ((cmd & TO_VLAN_MASK) == TO_VLAN_GROUP1))
+			smac = netdev_priv(mac->next_ndev);
+
+		if (unlikely(cmd & (ERR_CODE))) {
+			smac->dev_stats.tx_errors++;
+		} else {
+			smac->dev_stats.tx_packets++;
+			smac->dev_stats.tx_bytes += skbinfo->len;
+		}
+
+		dma_unmap_single(&comm->pdev->dev, skbinfo->mapping, skbinfo->len,
+				 DMA_TO_DEVICE);
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
+		if (netif_queue_stopped(mac->ndev))
+			netif_wake_queue(mac->ndev);
+
+		if (mac->next_ndev) {
+			if (netif_queue_stopped(mac->next_ndev))
+				netif_wake_queue(mac->next_ndev);
+		}
+	}
+
+	spin_unlock(&comm->tx_lock);
+
+	wmb();			// make sure settings are effective.
+	write_sw_int_mask0(mac, read_sw_int_mask0(mac) & ~MAC_INT_TX);
+
+	napi_complete(napi);
+	return 0;
+}
+
+irqreturn_t ethernet_interrupt(int irq, void *dev_id)
+{
+	struct net_device *ndev;
+	struct sp_mac *mac;
+	struct sp_common *comm;
+	u32 status;
+
+	ndev = (struct net_device *)dev_id;
+	if (unlikely(!ndev)) {
+		netdev_err(ndev, "ndev is null!\n");
+		goto OUT;
+	}
+
+	mac = netdev_priv(ndev);
+	comm = mac->comm;
+
+	status = read_sw_int_status0(mac);
+	if (unlikely(status == 0)) {
+		netdev_err(ndev, "Interrput status is null!\n");
+		goto OUT;
+	}
+	write_sw_int_status0(mac, status);
+
+	if (status & MAC_INT_RX) {
+		// Disable RX interrupts.
+		write_sw_int_mask0(mac, read_sw_int_mask0(mac) | MAC_INT_RX);
+
+		if (unlikely(status & MAC_INT_RX_DES_ERR)) {
+			netdev_err(ndev, "Illegal RX Descriptor!\n");
+			mac->dev_stats.rx_fifo_errors++;
+		}
+		if (napi_schedule_prep(&comm->rx_napi))
+			__napi_schedule(&comm->rx_napi);
+	}
+
+	if (status & MAC_INT_TX) {
+		// Disable TX interrupts.
+		write_sw_int_mask0(mac, read_sw_int_mask0(mac) | MAC_INT_TX);
+
+		if (unlikely(status & MAC_INT_TX_DES_ERR)) {
+			netdev_err(ndev, "Illegal TX Descriptor Error\n");
+			mac->dev_stats.tx_fifo_errors++;
+			mac_soft_reset(mac);
+			wmb();			// make sure settings are effective.
+			write_sw_int_mask0(mac, read_sw_int_mask0(mac) & ~MAC_INT_TX);
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
diff --git a/drivers/net/ethernet/sunplus/sp_int.h b/drivers/net/ethernet/sunplus/sp_int.h
new file mode 100644
index 0000000..7de8df4
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_int.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_INT_H__
+#define __SP_INT_H__
+
+int rx_poll(struct napi_struct *napi, int budget);
+int tx_poll(struct napi_struct *napi, int budget);
+irqreturn_t ethernet_interrupt(int irq, void *dev_id);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/sp_mac.c b/drivers/net/ethernet/sunplus/sp_mac.c
new file mode 100644
index 0000000..6a3dfb1
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_mac.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "sp_mac.h"
+
+void mac_init(struct sp_mac *mac)
+{
+	u32 i;
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
+		mac->comm->rx_pos[i] = 0;
+	mb();	// make sure settings are effective.
+
+	hal_mac_init(mac);
+}
+
+void mac_soft_reset(struct sp_mac *mac)
+{
+	u32 i;
+	struct net_device *ndev2;
+
+	if (netif_carrier_ok(mac->ndev)) {
+		netif_carrier_off(mac->ndev);
+		netif_stop_queue(mac->ndev);
+	}
+
+	ndev2 = mac->next_ndev;
+	if (ndev2) {
+		if (netif_carrier_ok(ndev2)) {
+			netif_carrier_off(ndev2);
+			netif_stop_queue(ndev2);
+		}
+	}
+
+	hal_mac_reset(mac);
+	hal_mac_stop(mac);
+
+	rx_descs_flush(mac->comm);
+	mac->comm->tx_pos = 0;
+	mac->comm->tx_done_pos = 0;
+	mac->comm->tx_desc_full = 0;
+
+	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
+		mac->comm->rx_pos[i] = 0;
+	mb();	// make sure settings are effective.
+
+	hal_mac_init(mac);
+	hal_mac_start(mac);
+
+	if (!netif_carrier_ok(mac->ndev)) {
+		netif_carrier_on(mac->ndev);
+		netif_start_queue(mac->ndev);
+	}
+
+	if (ndev2) {
+		if (!netif_carrier_ok(ndev2)) {
+			netif_carrier_on(ndev2);
+			netif_start_queue(ndev2);
+		}
+	}
+}
diff --git a/drivers/net/ethernet/sunplus/sp_mac.h b/drivers/net/ethernet/sunplus/sp_mac.h
new file mode 100644
index 0000000..f35f3b7
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_mac.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_MAC_H__
+#define __SP_MAC_H__
+
+#include "sp_define.h"
+#include "sp_hal.h"
+
+void mac_init(struct sp_mac *mac);
+void mac_soft_reset(struct sp_mac *mac);
+
+// Calculate the empty tx descriptor number
+#define TX_DESC_AVAIL(mac) \
+	(((mac)->tx_pos != (mac)->tx_done_pos) ? \
+	(((mac)->tx_done_pos < (mac)->tx_pos) ? \
+	(TX_DESC_NUM - ((mac)->tx_pos - (mac)->tx_done_pos)) : \
+	((mac)->tx_done_pos - (mac)->tx_pos)) : \
+	((mac)->tx_desc_full ? 0 : TX_DESC_NUM))
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/sp_mdio.c b/drivers/net/ethernet/sunplus/sp_mdio.c
new file mode 100644
index 0000000..f6a7e64
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_mdio.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "sp_mdio.h"
+
+u32 mdio_read(struct sp_mac *mac, u32 phy_id, u16 regnum)
+{
+	int ret;
+
+	ret = hal_mdio_access(mac, MDIO_READ_CMD, phy_id, regnum, 0);
+	if (ret < 0)
+		return -EOPNOTSUPP;
+
+	return ret;
+}
+
+u32 mdio_write(struct sp_mac *mac, u32 phy_id, u32 regnum, u16 val)
+{
+	int ret;
+
+	ret = hal_mdio_access(mac, MDIO_WRITE_CMD, phy_id, regnum, val);
+	if (ret < 0)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int mii_read(struct mii_bus *bus, int phy_id, int regnum)
+{
+	struct sp_mac *mac = bus->priv;
+
+	return mdio_read(mac, phy_id, regnum);
+}
+
+static int mii_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
+{
+	struct sp_mac *mac = bus->priv;
+
+	return mdio_write(mac, phy_id, regnum, val);
+}
+
+u32 mdio_init(struct platform_device *pdev, struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+	struct mii_bus *mii_bus;
+	struct device_node *mdio_node;
+	int ret;
+
+	mii_bus = mdiobus_alloc();
+	if (!mii_bus) {
+		netdev_err(ndev, "Failed to allocate mdio_bus memory!\n");
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
+	mdio_node = of_get_parent(mac->phy_node);
+	if (!mdio_node) {
+		netdev_err(ndev, "Failed to get mdio_node!\n");
+		return -ENODATA;
+	}
+
+	ret = of_mdiobus_register(mii_bus, mdio_node);
+	if (ret) {
+		netdev_err(ndev, "Failed to register mii bus!\n");
+		mdiobus_free(mii_bus);
+		return ret;
+	}
+
+	mac->comm->mii_bus = mii_bus;
+	return ret;
+}
+
+void mdio_remove(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	if (mac->comm->mii_bus) {
+		mdiobus_unregister(mac->comm->mii_bus);
+		mdiobus_free(mac->comm->mii_bus);
+		mac->comm->mii_bus = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/sunplus/sp_mdio.h b/drivers/net/ethernet/sunplus/sp_mdio.h
new file mode 100644
index 0000000..d708624
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_mdio.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_MDIO_H__
+#define __SP_MDIO_H__
+
+#include "sp_define.h"
+#include "sp_hal.h"
+
+#define MDIO_READ_CMD           0x02
+#define MDIO_WRITE_CMD          0x01
+
+u32  mdio_read(struct sp_mac *mac, u32 phy_id, u16 regnum);
+u32  mdio_write(struct sp_mac *mac, u32 phy_id, u32 regnum, u16 val);
+u32  mdio_init(struct platform_device *pdev, struct net_device *ndev);
+void mdio_remove(struct net_device *ndev);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/sp_phy.c b/drivers/net/ethernet/sunplus/sp_phy.c
new file mode 100644
index 0000000..df6df3a
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_phy.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#include "sp_phy.h"
+#include "sp_mdio.h"
+
+static void mii_linkchange(struct net_device *netdev)
+{
+}
+
+int sp_phy_probe(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+	struct phy_device *phydev;
+	int i;
+
+	phydev = of_phy_connect(ndev, mac->phy_node, mii_linkchange,
+				0, mac->phy_mode);
+	if (!phydev) {
+		netdev_err(ndev, "\"%s\" failed to connect to phy!\n", ndev->name);
+		return -ENODEV;
+	}
+
+	for (i = 0; i < sizeof(phydev->supported) / sizeof(long); i++)
+		phydev->advertising[i] = phydev->supported[i];
+
+	phydev->irq = PHY_MAC_INTERRUPT;
+	mac->phy_dev = phydev;
+
+	// Bug workaround:
+	// Flow-control of phy should be enabled. MAC flow-control will refer
+	// to the bit to decide to enable or disable flow-control.
+	mdio_write(mac, mac->phy_addr, 4, mdio_read(mac, mac->phy_addr, 4) | (1 << 10));
+
+	return 0;
+}
+
+void sp_phy_start(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	if (mac->phy_dev)
+		phy_start(mac->phy_dev);
+}
+
+void sp_phy_stop(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	if (mac->phy_dev)
+		phy_stop(mac->phy_dev);
+}
+
+void sp_phy_remove(struct net_device *ndev)
+{
+	struct sp_mac *mac = netdev_priv(ndev);
+
+	if (mac->phy_dev) {
+		phy_disconnect(mac->phy_dev);
+		mac->phy_dev = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/sunplus/sp_phy.h b/drivers/net/ethernet/sunplus/sp_phy.h
new file mode 100644
index 0000000..4ae0351
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_phy.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_PHY_H__
+#define __SP_PHY_H__
+
+#include "sp_define.h"
+
+int  sp_phy_probe(struct net_device *netdev);
+void sp_phy_start(struct net_device *netdev);
+void sp_phy_stop(struct net_device *netdev);
+void sp_phy_remove(struct net_device *netdev);
+
+#endif
diff --git a/drivers/net/ethernet/sunplus/sp_register.h b/drivers/net/ethernet/sunplus/sp_register.h
new file mode 100644
index 0000000..690c0dd
--- /dev/null
+++ b/drivers/net/ethernet/sunplus/sp_register.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Sunplus Technology Co., Ltd.
+ *       All rights reserved.
+ */
+
+#ifndef __SP_REGISTER_H__
+#define __SP_REGISTER_H__
+
+#include "sp_define.h"
+
+/* TYPE: RegisterFile_L2SW */
+#define SP_SW_INT_STATUS_0		0x0
+#define SP_SW_INT_MASK_0		0x4
+#define SP_FL_CNTL_TH			0x8
+#define SP_CPU_FL_CNTL_TH		0xc
+#define SP_PRI_FL_CNTL			0x10
+#define SP_VLAN_PRI_TH			0x14
+#define SP_EN_TOS_BUS			0x18
+#define SP_TOS_MAP0			0x1c
+#define SP_TOS_MAP1			0x20
+#define SP_TOS_MAP2			0x24
+#define SP_TOS_MAP3			0x28
+#define SP_TOS_MAP4			0x2c
+#define SP_TOS_MAP5			0x30
+#define SP_TOS_MAP6			0x34
+#define SP_TOS_MAP7			0x38
+#define SP_GLOBAL_QUE_STATUS		0x3c
+#define SP_ADDR_TBL_SRCH		0x40
+#define SP_ADDR_TBL_ST			0x44
+#define SP_MAC_AD_SER0			0x48
+#define SP_MAC_AD_SER1			0x4c
+#define SP_WT_MAC_AD0			0x50
+#define SP_W_MAC_15_0			0x54
+#define SP_W_MAC_47_16			0x58
+#define SP_PVID_CONFIG0			0x5c
+#define SP_PVID_CONFIG1			0x60
+#define SP_VLAN_MEMSET_CONFIG0		0x64
+#define SP_VLAN_MEMSET_CONFIG1		0x68
+#define SP_PORT_ABILITY			0x6c
+#define SP_PORT_ST			0x70
+#define SP_CPU_CNTL			0x74
+#define SP_PORT_CNTL0			0x78
+#define SP_PORT_CNTL1			0x7c
+#define SP_PORT_CNTL2			0x80
+#define SP_SW_GLB_CNTL			0x84
+#define SP_SP_SW_RESET			0x88
+#define SP_LED_PORT0			0x8c
+#define SP_LED_PORT1			0x90
+#define SP_LED_PORT2			0x94
+#define SP_LED_PORT3			0x98
+#define SP_LED_PORT4			0x9c
+#define SP_WATCH_DOG_TRIG_RST		0xa0
+#define SP_WATCH_DOG_STOP_CPU		0xa4
+#define SP_PHY_CNTL_REG0		0xa8
+#define SP_PHY_CNTL_REG1		0xac
+#define SP_MAC_FORCE_MODE		0xb0
+#define SP_VLAN_GROUP_CONFIG0		0xb4
+#define SP_VLAN_GROUP_CONFIG1		0xb8
+#define SP_FLOW_CTRL_TH3		0xbc
+#define SP_QUEUE_STATUS_0		0xc0
+#define SP_DEBUG_CNTL			0xc4
+#define SP_RESERVED_1			0xc8
+#define SP_MEM_TEST_INFO		0xcc
+#define SP_SW_INT_STATUS_1		0xd0
+#define SP_SW_INT_MASK_1		0xd4
+#define SP_SW_GLOBAL_SIGNAL		0xd8
+
+#define SP_CPU_TX_TRIG			0x208
+#define SP_TX_HBASE_ADDR_0		0x20c
+#define SP_TX_LBASE_ADDR_0		0x210
+#define SP_RX_HBASE_ADDR_0		0x214
+#define SP_RX_LBASE_ADDR_0		0x218
+#define SP_TX_HW_ADDR_0			0x21c
+#define SP_TX_LW_ADDR_0			0x220
+#define SP_RX_HW_ADDR_0			0x224
+#define SP_RX_LW_ADDR_0			0x228
+#define SP_CPU_PORT_CNTL_REG_0		0x22c
+#define SP_TX_HBASE_ADDR_1		0x230
+#define SP_TX_LBASE_ADDR_1		0x234
+#define SP_RX_HBASE_ADDR_1		0x238
+#define SP_RX_LBASE_ADDR_1		0x23c
+#define SP_TX_HW_ADDR_1			0x240
+#define SP_TX_LW_ADDR_1			0x244
+#define SP_RX_HW_ADDR_1			0x248
+#define SP_RX_LW_ADDR_1			0x24c
+#define SP_CPU_PORT_CNTL_REG_1		0x250
+
+/* TYPE: RegisterFile_MOON5 */
+#define MOON5_MO5_THERMAL_CTL_0		0x0
+#define MOON5_MO5_THERMAL_CTL_1		0x4
+#define MOON5_MO4_THERMAL_CTL_2		0xc
+#define MOON5_MO4_THERMAL_CTL_3		0x8
+#define MOON5_MO4_TMDS_L2SW_CTL		0x10
+#define MOON5_MO4_L2SW_CLKSW_CTL	0x14
+
+#endif
-- 
2.7.4

