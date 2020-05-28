Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239F01E659E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403787AbgE1PNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:13:49 -0400
Received: from mail-eopbgr30115.outbound.protection.outlook.com ([40.107.3.115]:18196
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404070AbgE1PNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:13:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rjo60GL2P7i84PZOCCwrrbNckLzzeVKvj+lr7mlVODxAbtb/BfG511SN9VQDw1uWK8gDs1wEZnWCC1uXcVJBHKlYuvagxM3FKEf1fo/0Qhsec99+RCtX6uzq5SISsMBKv/1mrLVg1zVIk+U8N/u8+hGNrEiDBaw61Yk5CHn1n5hbBYGZvRKeoNRLyK7hF/P6ZnBCyQAcV5jKWX4QZPmC9vy05dvfgZvypJWaeqsIOPNsRZNgjYqPvn9QO1vi51OdnqfN6efaLHNuBH4szXB5pU14h/KsJoVsiWgIPEb5FAJf1n496BMDpj/BlJgLpjaBunu/6aqEq/6k3dME+Bxzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4LE7mtk7z9D1hJKLax5bWIzQVJ2v384wPYkHKEn5mk=;
 b=AMUgOG4jImLjrwAvS2ptt6mjAgJMjxN0XBhu7iFzRWcyHODaGqjCDZm6PWqHSg0OWNT2BcX7VgVWa9Y+8/dQwwWKhOI8gHk+YiRqk0/jcVQ7OHeitIgSvdoIhccDsJL1df3ofbVWZEESOKgxvT954os/q0smPWjYqBrPWDnVuHC7/iOCEflsre+12Kt1TFLPjkW0gvaCPnxwruMKIORNV1+Pd3FluHFkWzFp7yxVHeouWEwoEDyk3jnI6pvZyI3Tf3KCC8zXVyZ4SvVp+OnpfmrZV01g6mvQfVKgEISeSMoxvFJnwD/iEd5gSkpsUMjoKUtQ/zd5GcqyhwE7VOu6DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4LE7mtk7z9D1hJKLax5bWIzQVJ2v384wPYkHKEn5mk=;
 b=ADM+OKjfJlLUEak8BPs5CWseby2dRFKMv/08LDZR+BnmLC/WDfgu4be3XYhH3qMr2KWyaiXXh/4lljD5NGPvVvgh7gj8SDVF44JOKtY4hnIj2pwTefvVbnuxGtuLzLBMeW/9qQ29ejMjVfLYzwKuGmcuYeTWCEOvgQ/InwTFG94=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0224.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 15:13:06 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 15:13:06 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [net-next 1/6] net: marvell: prestera: Add driver for Prestera family ASIC devices
Date:   Thu, 28 May 2020 18:12:40 +0300
Message-Id: <20200528151245.7592-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528151245.7592-1-vadym.kochan@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0094.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::35) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0094.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Thu, 28 May 2020 15:13:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4354a593-d79a-4f98-3257-08d803199f72
X-MS-TrafficTypeDiagnostic: VI1P190MB0224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB022494B742BD2670AC6107FE958E0@VI1P190MB0224.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBtcfAIEJQRZQx/o8biMaCzRBVbjwPidJt+k7PxrkI0x90cdQqY4gBdyh/9gFPkPv1YVIPwAC2JS2dOpOT8C6TUlo/3QRGdL9tch8W9Jpkk5+lGPlu6OLrU7Hvp/aEcRl7mOs2E/+9Zw/0gl+Z5+E8egLo9rQ+w3MXPL+nVI2vd6CpJ8sOr+/d3nKC870Ex1/RDV1056oJAlmsdLfvENglhPpfCCexHXyYHPtPNo8GBUTAbHxzG27h/pnuBD8OIvEH8qn+2q7IioswrzMFZImxRKjOHt53HKlMmhkkJmNe6imwqvfL05mq8ex9E5hGfVJDKb949Nl5TP/QpMpTrVKxdGtEehRHBEpS4x9haMFyM77ZxKiVYMgRSxW6kWkmx+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(346002)(396003)(66476007)(316002)(66556008)(107886003)(5660300002)(6512007)(2616005)(508600001)(186003)(956004)(4326008)(1076003)(2906002)(16526019)(52116002)(26005)(6486002)(44832011)(54906003)(30864003)(6506007)(66946007)(8936002)(8676002)(110136005)(86362001)(83380400001)(36756003)(6666004)(921003)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZX84AyX5XO8SygxFmS8kA5bMEcIt/u/bZKkCKvwVjT1GwOHMDjQIJF6HGAhuiNLb7j5m/tQFAQ0sr3ORBnx721Q1pPrQUq7RfNOQBo2HJmStbe52UFfZP12xl7sMrEb0g+B38vlyqVG/zD+xcl7vSYida0nD874BZp6lC5ZoDWBCXF/tQbFknstDycIR0WXscADcztJwKZbZMHDuEcXUQU0bLYiMnGOdCB5y3rCy8ECQAJjiGVmVW2uN5I8Fc6LVQS6s0OEcBoH2cBXA7F0htenxwc1X92FE/HoMAitbUhwc3s44whVF7hkzSrxioecEirF4A4PdFEz9teF/j50Z+rc5gumgwz/oCKIXLAMxY6dr2bd8cCJ21pmRL81q40brBRbdWa/BbqwBqiFBqcRpajhUW7+KIdHXFX1z+W09FUc3BHthRm+2CxULs3RjJ3ibOB5eLXb9au3AT7Hx9B3vazWUsRB669aB6y3w1MjOirc=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4354a593-d79a-4f98-3257-08d803199f72
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:13:06.1069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWU1APLYOZw6rzzHOpsobcUBXcx3WzX8P5wchCSYW23kaRsg+EXs6hHjfKZe+9uI6MiSpU6HgvsWOBJW+iZhK5aL+UyQOeRynpjugPCs2kE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
wireless SMB deployment.

The current implementation supports only boards designed for the Marvell
Switchdev solution and requires special firmware.

The core Prestera switching logic is implemented in prestera_main.c,
there is an intermediate hw layer between core logic and firmware. It is
implemented in prestera_hw.c, the purpose of it is to encapsulate hw
related logic, in future there is a plan to support more devices with
different HW related configurations.

This patch contains only basic switch initialization and RX/TX support
over SDMA mechanism.

Currently supported devices have DMA access range <= 32bit and require
ZONE_DMA to be enabled, for such cases SDMA driver checks if the skb
allocated in proper range supported by the Prestera device.

Also meanwhile there is no TX interrupt support in current firmware
version so recycling work is scheduled on each xmit.

Port's mac address is generated from the switch base mac which may be
provided via device-tree (static one or as nvme cell), or randomly
generated.

Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/Makefile         |   1 +
 drivers/net/ethernet/marvell/prestera/Kconfig |  13 +
 .../net/ethernet/marvell/prestera/Makefile    |   4 +
 .../net/ethernet/marvell/prestera/prestera.h  | 172 ++++
 .../ethernet/marvell/prestera/prestera_dsa.c  | 134 +++
 .../ethernet/marvell/prestera/prestera_dsa.h  |  37 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 610 +++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  71 ++
 .../ethernet/marvell/prestera/prestera_main.c | 506 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c | 860 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |  21 +
 12 files changed, 2430 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index 3d5caea096fb..74313d9e1fc0 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -171,5 +171,6 @@ config SKY2_DEBUG
 
 
 source "drivers/net/ethernet/marvell/octeontx2/Kconfig"
+source "drivers/net/ethernet/marvell/prestera/Kconfig"
 
 endif # NET_VENDOR_MARVELL
diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/ethernet/marvell/Makefile
index 89dea7284d5b..9f88fe822555 100644
--- a/drivers/net/ethernet/marvell/Makefile
+++ b/drivers/net/ethernet/marvell/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_PXA168_ETH) += pxa168_eth.o
 obj-$(CONFIG_SKGE) += skge.o
 obj-$(CONFIG_SKY2) += sky2.o
 obj-y		+= octeontx2/
+obj-y		+= prestera/
diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
new file mode 100644
index 000000000000..76b68613ea7a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Marvell Prestera drivers configuration
+#
+
+config PRESTERA
+	tristate "Marvell Prestera Switch ASICs support"
+	depends on NET_SWITCHDEV && VLAN_8021Q
+	help
+	  This driver supports Marvell Prestera Switch ASICs family.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called prestera.
diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
new file mode 100644
index 000000000000..610d75032b78
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_PRESTERA)	+= prestera.o
+prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
+			   prestera_rxtx.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
new file mode 100644
index 000000000000..5079d872e18a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -0,0 +1,172 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+
+#ifndef _PRESTERA_H_
+#define _PRESTERA_H_
+
+#include <linux/skbuff.h>
+#include <linux/notifier.h>
+#include <uapi/linux/if_ether.h>
+#include <linux/workqueue.h>
+
+struct prestera_fw_rev {
+	u16 maj;
+	u16 min;
+	u16 sub;
+};
+
+struct prestera_port_stats {
+	u64 good_octets_received;
+	u64 bad_octets_received;
+	u64 mac_trans_error;
+	u64 broadcast_frames_received;
+	u64 multicast_frames_received;
+	u64 frames_64_octets;
+	u64 frames_65_to_127_octets;
+	u64 frames_128_to_255_octets;
+	u64 frames_256_to_511_octets;
+	u64 frames_512_to_1023_octets;
+	u64 frames_1024_to_max_octets;
+	u64 excessive_collision;
+	u64 multicast_frames_sent;
+	u64 broadcast_frames_sent;
+	u64 fc_sent;
+	u64 fc_received;
+	u64 buffer_overrun;
+	u64 undersize;
+	u64 fragments;
+	u64 oversize;
+	u64 jabber;
+	u64 rx_error_frame_received;
+	u64 bad_crc;
+	u64 collisions;
+	u64 late_collision;
+	u64 unicast_frames_received;
+	u64 unicast_frames_sent;
+	u64 sent_multiple;
+	u64 sent_deferred;
+	u64 frames_1024_to_1518_octets;
+	u64 frames_1519_to_max_octets;
+	u64 good_octets_sent;
+};
+
+struct prestera_port_caps {
+	u64 supp_link_modes;
+	u8 supp_fec;
+	u8 type;
+	u8 transceiver;
+};
+
+struct prestera_port {
+	struct net_device *dev;
+	struct prestera_switch *sw;
+	u32 id;
+	u32 hw_id;
+	u32 dev_id;
+	u16 fp_id;
+	bool autoneg;
+	u64 adver_link_modes;
+	u8 adver_fec;
+	struct prestera_port_caps caps;
+	struct list_head list;
+	struct {
+		struct prestera_port_stats stats;
+		struct delayed_work caching_dw;
+	} cached_hw_stats;
+};
+
+struct prestera_device {
+	struct device *dev;
+	u8 __iomem *ctl_regs;
+	u8 __iomem *pp_regs;
+	struct prestera_fw_rev fw_rev;
+	void *priv;
+
+	/* called by device driver to handle received packets */
+	void (*recv_pkt)(struct prestera_device *dev);
+
+	/* called by device driver to pass event up to the higher layer */
+	int (*recv_msg)(struct prestera_device *dev, u8 *msg, size_t size);
+
+	/* called by higher layer to send request to the firmware */
+	int (*send_req)(struct prestera_device *dev, u8 *in_msg,
+			size_t in_size, u8 *out_msg, size_t out_size,
+			unsigned int wait);
+};
+
+enum prestera_event_type {
+	PRESTERA_EVENT_TYPE_UNSPEC,
+
+	PRESTERA_EVENT_TYPE_PORT,
+	PRESTERA_EVENT_TYPE_RXTX,
+
+	PRESTERA_EVENT_TYPE_MAX,
+};
+
+enum prestera_rxtx_event_id {
+	PRESTERA_RXTX_EVENT_UNSPEC,
+	PRESTERA_RXTX_EVENT_RCV_PKT,
+};
+
+enum prestera_port_event_id {
+	PRESTERA_PORT_EVENT_UNSPEC,
+	PRESTERA_PORT_EVENT_STATE_CHANGED,
+};
+
+struct prestera_port_event {
+	u32 port_id;
+	union {
+		u32 oper_state;
+	} data;
+};
+
+struct prestera_event {
+	u16 id;
+	union {
+		struct prestera_port_event port_evt;
+	};
+};
+
+struct prestera_rxtx;
+
+struct prestera_switch {
+	struct prestera_device *dev;
+	struct prestera_rxtx *rxtx;
+	struct list_head event_handlers;
+	char base_mac[ETH_ALEN];
+	struct list_head port_list;
+	u32 port_count;
+	u32 mtu_min;
+	u32 mtu_max;
+	u8 id;
+};
+
+struct prestera_rxtx_params {
+	bool use_sdma;
+	u32 map_addr;
+};
+
+#define prestera_dev(sw)		((sw)->dev->dev)
+
+static inline void prestera_write(const struct prestera_switch *sw,
+				  unsigned int reg, u32 val)
+{
+	writel(val, sw->dev->pp_regs + reg);
+}
+
+static inline u32 prestera_read(const struct prestera_switch *sw,
+				unsigned int reg)
+{
+	return readl(sw->dev->pp_regs + reg);
+}
+
+int prestera_device_register(struct prestera_device *dev);
+void prestera_device_unregister(struct prestera_device *dev);
+
+struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
+						 u32 dev_id, u32 hw_id);
+
+#endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.c b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
new file mode 100644
index 000000000000..1d95604507a1
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+
+#include "prestera_dsa.h"
+
+#include <linux/string.h>
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+#include <linux/errno.h>
+
+#define PRESTERA_W0_IS_TAGGED	BIT(29)
+
+/* TrgDev[4:0] = {Word0[28:24]} */
+#define PRESTERA_W0_HW_DEV_NUM	GENMASK(28, 24)
+
+/* SrcPort/TrgPort extended to 8b
+ * SrcPort/TrgPort[7:0] = {Word2[20], Word1[11:10], Word0[23:19]}
+ */
+#define PRESTERA_W0_IFACE_PORT_NUM	GENMASK(23, 19)
+
+/* bits 30:31 - TagCommand 1 = FROM_CPU */
+#define PRESTERA_W0_DSA_CMD		GENMASK(31, 30)
+
+/* bits 13:15 -- UP */
+#define PRESTERA_W0_VPT		GENMASK(15, 13)
+
+#define PRESTERA_W0_EXT_BIT		BIT(12)
+
+/* bits 0:11 -- VID */
+#define PRESTERA_W0_VID		GENMASK(11, 0)
+
+/* SrcPort/TrgPort extended to 8b
+ * SrcPort/TrgPort[7:0] = {Word2[20], Word1[11:10], Word0[23:19]}
+ */
+#define PRESTERA_W1_IFACE_PORT_NUM	GENMASK(11, 10)
+
+#define PRESTERA_W1_EXT_BIT		BIT(31)
+#define PRESTERA_W1_CFI_BIT		BIT(30)
+
+/* SrcPort/TrgPort extended to 8b
+ * SrcPort/TrgPort[7:0] = {Word2[20], Word1[11:10], Word0[23:19]}
+ */
+#define PRESTERA_W2_IFACE_PORT_NUM	BIT(20)
+
+#define PRESTERA_W2_EXT_BIT		BIT(31)
+
+/* trgHwDev and trgPort
+ * TrgDev[11:5] = {Word3[6:0]}
+ */
+#define PRESTERA_W3_HW_DEV_NUM	GENMASK(6, 0)
+
+/* VID 16b [15:0] = {Word3[30:27], Word0[11:0]} */
+#define PRESTERA_W3_VID		GENMASK(30, 27)
+
+/* TRGePort[16:0] = {Word3[23:7]} */
+#define PRESTERA_W3_DST_EPORT	GENMASK(23, 7)
+
+#define PRESTERA_DEV_NUM_MASK		GENMASK(11, 5)
+#define PRESTERA_VID_MASK		GENMASK(15, 12)
+
+int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf)
+{
+	u32 *dsa_words = (u32 *)dsa_buf;
+	enum prestera_dsa_cmd cmd;
+	u32 words[4] = { 0 };
+	u32 field;
+
+	words[0] = ntohl((__force __be32)dsa_words[0]);
+	words[1] = ntohl((__force __be32)dsa_words[1]);
+	words[2] = ntohl((__force __be32)dsa_words[2]);
+	words[3] = ntohl((__force __be32)dsa_words[3]);
+
+	/* set the common parameters */
+	cmd = (enum prestera_dsa_cmd)FIELD_GET(PRESTERA_W0_DSA_CMD, words[0]);
+
+	/* only to CPU is supported */
+	if (unlikely(cmd != PRESTERA_DSA_CMD_TO_CPU))
+		return -EINVAL;
+
+	if (FIELD_GET(PRESTERA_W0_EXT_BIT, words[0]) == 0)
+		return -EINVAL;
+	if (FIELD_GET(PRESTERA_W1_EXT_BIT, words[1]) == 0)
+		return -EINVAL;
+	if (FIELD_GET(PRESTERA_W2_EXT_BIT, words[2]) == 0)
+		return -EINVAL;
+
+	field = FIELD_GET(PRESTERA_W3_VID, words[3]);
+
+	dsa->vlan.is_tagged = (bool)FIELD_GET(PRESTERA_W0_IS_TAGGED, words[0]);
+	dsa->vlan.cfi_bit = (u8)FIELD_GET(PRESTERA_W1_CFI_BIT, words[1]);
+	dsa->vlan.vpt = (u8)FIELD_GET(PRESTERA_W0_VPT, words[0]);
+	dsa->vlan.vid = (u16)FIELD_GET(PRESTERA_W0_VID, words[0]);
+	dsa->vlan.vid &= ~PRESTERA_VID_MASK;
+	dsa->vlan.vid |= FIELD_PREP(PRESTERA_VID_MASK, field);
+
+	field = FIELD_GET(PRESTERA_W3_HW_DEV_NUM, words[3]);
+
+	dsa->hw_dev_num = FIELD_GET(PRESTERA_W0_HW_DEV_NUM, words[0]);
+	dsa->hw_dev_num &= PRESTERA_W3_HW_DEV_NUM;
+	dsa->hw_dev_num |= FIELD_PREP(PRESTERA_DEV_NUM_MASK, field);
+
+	dsa->port_num = (FIELD_GET(PRESTERA_W0_IFACE_PORT_NUM, words[0]) << 0) |
+			(FIELD_GET(PRESTERA_W1_IFACE_PORT_NUM, words[1]) << 5) |
+			(FIELD_GET(PRESTERA_W2_IFACE_PORT_NUM, words[2]) << 7);
+	return 0;
+}
+
+int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf)
+{
+	__be32 *dsa_words = (__be32 *)dsa_buf;
+	u32 words[4] = { 0 };
+
+	if (dsa->hw_dev_num >= BIT(12))
+		return -EINVAL;
+	if (dsa->port_num >= BIT(17))
+		return -EINVAL;
+
+	words[0] |= FIELD_PREP(PRESTERA_W0_DSA_CMD, PRESTERA_DSA_CMD_FROM_CPU);
+
+	words[0] |= FIELD_PREP(PRESTERA_W0_HW_DEV_NUM, dsa->hw_dev_num);
+	words[3] |= FIELD_PREP(PRESTERA_W3_HW_DEV_NUM, (dsa->hw_dev_num >> 5));
+	words[3] |= FIELD_PREP(PRESTERA_W3_DST_EPORT, dsa->port_num);
+
+	words[0] |= FIELD_PREP(PRESTERA_W0_EXT_BIT, 1);
+	words[1] |= FIELD_PREP(PRESTERA_W1_EXT_BIT, 1);
+	words[2] |= FIELD_PREP(PRESTERA_W2_EXT_BIT, 1);
+
+	dsa_words[0] = htonl(words[0]);
+	dsa_words[1] = htonl(words[1]);
+	dsa_words[2] = htonl(words[2]);
+	dsa_words[3] = htonl(words[3]);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.h b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
new file mode 100644
index 000000000000..d653e426dd71
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+#ifndef __PRESTERA_DSA_H_
+#define __PRESTERA_DSA_H_
+
+#include <linux/types.h>
+
+#define PRESTERA_DSA_HLEN	16
+
+enum prestera_dsa_cmd {
+	/* DSA command is "To CPU" */
+	PRESTERA_DSA_CMD_TO_CPU = 0,
+
+	/* DSA command is "FROM CPU" */
+	PRESTERA_DSA_CMD_FROM_CPU,
+};
+
+struct prestera_dsa_vlan {
+	u16 vid;
+	u8 vpt;
+	u8 cfi_bit;
+	bool is_tagged;
+};
+
+struct prestera_dsa {
+	struct prestera_dsa_vlan vlan;
+	u32 hw_dev_num;
+	u32 port_num;
+};
+
+int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf);
+int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf);
+
+#endif /* _PRESTERA_DSA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
new file mode 100644
index 000000000000..3aa3974f957a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -0,0 +1,610 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+#include <linux/list.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+
+#define PRESTERA_SWITCH_INIT_TIMEOUT 30000000	/* 30sec */
+#define PRESTERA_MIN_MTU 64
+
+enum prestera_cmd_type_t {
+	PRESTERA_CMD_TYPE_SWITCH_INIT = 0x1,
+	PRESTERA_CMD_TYPE_SWITCH_ATTR_SET = 0x2,
+
+	PRESTERA_CMD_TYPE_PORT_ATTR_SET = 0x100,
+	PRESTERA_CMD_TYPE_PORT_ATTR_GET = 0x101,
+	PRESTERA_CMD_TYPE_PORT_INFO_GET = 0x110,
+
+	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
+	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
+
+	PRESTERA_CMD_TYPE_ACK = 0x10000,
+	PRESTERA_CMD_TYPE_MAX
+};
+
+enum {
+	PRESTERA_CMD_PORT_ATTR_ADMIN_STATE = 1,
+	PRESTERA_CMD_PORT_ATTR_MTU = 3,
+	PRESTERA_CMD_PORT_ATTR_MAC = 4,
+	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
+	PRESTERA_CMD_PORT_ATTR_AUTONEG = 15,
+	PRESTERA_CMD_PORT_ATTR_STATS = 17,
+};
+
+enum {
+	PRESTERA_CMD_SWITCH_ATTR_MAC = 1,
+};
+
+enum {
+	PRESTERA_CMD_ACK_OK,
+	PRESTERA_CMD_ACK_FAILED,
+
+	PRESTERA_CMD_ACK_MAX
+};
+
+enum {
+	PRESTERA_PORT_GOOD_OCTETS_RCV_CNT,
+	PRESTERA_PORT_BAD_OCTETS_RCV_CNT,
+	PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT,
+	PRESTERA_PORT_BRDC_PKTS_RCV_CNT,
+	PRESTERA_PORT_MC_PKTS_RCV_CNT,
+	PRESTERA_PORT_PKTS_64L_CNT,
+	PRESTERA_PORT_PKTS_65TO127L_CNT,
+	PRESTERA_PORT_PKTS_128TO255L_CNT,
+	PRESTERA_PORT_PKTS_256TO511L_CNT,
+	PRESTERA_PORT_PKTS_512TO1023L_CNT,
+	PRESTERA_PORT_PKTS_1024TOMAXL_CNT,
+	PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT,
+	PRESTERA_PORT_MC_PKTS_SENT_CNT,
+	PRESTERA_PORT_BRDC_PKTS_SENT_CNT,
+	PRESTERA_PORT_FC_SENT_CNT,
+	PRESTERA_PORT_GOOD_FC_RCV_CNT,
+	PRESTERA_PORT_DROP_EVENTS_CNT,
+	PRESTERA_PORT_UNDERSIZE_PKTS_CNT,
+	PRESTERA_PORT_FRAGMENTS_PKTS_CNT,
+	PRESTERA_PORT_OVERSIZE_PKTS_CNT,
+	PRESTERA_PORT_JABBER_PKTS_CNT,
+	PRESTERA_PORT_MAC_RCV_ERROR_CNT,
+	PRESTERA_PORT_BAD_CRC_CNT,
+	PRESTERA_PORT_COLLISIONS_CNT,
+	PRESTERA_PORT_LATE_COLLISIONS_CNT,
+	PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT,
+	PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT,
+	PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT,
+	PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT,
+	PRESTERA_PORT_GOOD_OCTETS_SENT_CNT,
+
+	PRESTERA_PORT_CNT_MAX,
+};
+
+struct prestera_fw_event_handler {
+	struct list_head list;
+	enum prestera_event_type type;
+	prestera_event_cb_t func;
+	void *arg;
+};
+
+struct prestera_msg_cmd {
+	u32 type;
+} __packed __aligned(4);
+
+struct prestera_msg_ret {
+	struct prestera_msg_cmd cmd;
+	u32 status;
+} __packed __aligned(4);
+
+struct prestera_msg_common_req {
+	struct prestera_msg_cmd cmd;
+} __packed __aligned(4);
+
+struct prestera_msg_common_resp {
+	struct prestera_msg_ret ret;
+} __packed __aligned(4);
+
+union prestera_msg_switch_param {
+	u8 mac[ETH_ALEN];
+};
+
+struct prestera_msg_switch_attr_req {
+	struct prestera_msg_cmd cmd;
+	u32 attr;
+	union prestera_msg_switch_param param;
+} __packed __aligned(4);
+
+struct prestera_msg_switch_init_resp {
+	struct prestera_msg_ret ret;
+	u32 port_count;
+	u32 mtu_max;
+	u8  switch_id;
+} __packed __aligned(4);
+
+struct prestera_msg_port_autoneg_param {
+	u64 link_mode;
+	u8  enable;
+	u8  fec;
+};
+
+struct prestera_msg_port_cap_param {
+	u64 link_mode;
+	u8  type;
+	u8  fec;
+	u8  transceiver;
+};
+
+union prestera_msg_port_param {
+	u8  admin_state;
+	u8  oper_state;
+	u32 mtu;
+	u8  mac[ETH_ALEN];
+	struct prestera_msg_port_autoneg_param autoneg;
+	struct prestera_msg_port_cap_param cap;
+};
+
+struct prestera_msg_port_attr_req {
+	struct prestera_msg_cmd cmd;
+	u32 attr;
+	u32 port;
+	u32 dev;
+	union prestera_msg_port_param param;
+} __packed __aligned(4);
+
+struct prestera_msg_port_attr_resp {
+	struct prestera_msg_ret ret;
+	union prestera_msg_port_param param;
+} __packed __aligned(4);
+
+struct prestera_msg_port_stats_resp {
+	struct prestera_msg_ret ret;
+	u64 stats[PRESTERA_PORT_CNT_MAX];
+} __packed __aligned(4);
+
+struct prestera_msg_port_info_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+} __packed __aligned(4);
+
+struct prestera_msg_port_info_resp {
+	struct prestera_msg_ret ret;
+	u32 hw_id;
+	u32 dev_id;
+	u16 fp_id;
+} __packed __aligned(4);
+
+struct prestera_msg_rxtx_req {
+	struct prestera_msg_cmd cmd;
+	u8 use_sdma;
+} __packed __aligned(4);
+
+struct prestera_msg_rxtx_resp {
+	struct prestera_msg_ret ret;
+	u32 map_addr;
+} __packed __aligned(4);
+
+struct prestera_msg_rxtx_port_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+} __packed __aligned(4);
+
+struct prestera_msg_event {
+	u16 type;
+	u16 id;
+} __packed __aligned(4);
+
+union prestera_msg_event_port_param {
+	u32 oper_state;
+};
+
+struct prestera_msg_event_port {
+	struct prestera_msg_event id;
+	u32 port_id;
+	union prestera_msg_event_port_param param;
+} __packed __aligned(4);
+
+static int __prestera_cmd_ret(struct prestera_switch *sw,
+			      enum prestera_cmd_type_t type,
+			      struct prestera_msg_cmd *cmd, size_t clen,
+			      struct prestera_msg_ret *ret, size_t rlen,
+			      int wait)
+{
+	struct prestera_device *dev = sw->dev;
+	int err;
+
+	cmd->type = type;
+
+	err = dev->send_req(dev, (u8 *)cmd, clen, (u8 *)ret, rlen, wait);
+	if (err)
+		return err;
+
+	if (ret->cmd.type != PRESTERA_CMD_TYPE_ACK)
+		return -EBADE;
+	if (ret->status != PRESTERA_CMD_ACK_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int prestera_cmd_ret(struct prestera_switch *sw,
+			    enum prestera_cmd_type_t type,
+			    struct prestera_msg_cmd *cmd, size_t clen,
+			    struct prestera_msg_ret *ret, size_t rlen)
+{
+	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, 0);
+}
+
+static int prestera_cmd_ret_wait(struct prestera_switch *sw,
+				 enum prestera_cmd_type_t type,
+				 struct prestera_msg_cmd *cmd, size_t clen,
+				 struct prestera_msg_ret *ret, size_t rlen,
+				 int wait)
+{
+	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, wait);
+}
+
+static int prestera_cmd(struct prestera_switch *sw,
+			enum prestera_cmd_type_t type,
+			struct prestera_msg_cmd *cmd, size_t clen)
+{
+	struct prestera_msg_common_resp resp;
+
+	return prestera_cmd_ret(sw, type, cmd, clen, &resp.ret, sizeof(resp));
+}
+
+static int prestera_fw_parse_port_evt(u8 *msg, struct prestera_event *evt)
+{
+	struct prestera_msg_event_port *hw_evt;
+
+	hw_evt = (struct prestera_msg_event_port *)msg;
+
+	evt->port_evt.port_id = hw_evt->port_id;
+
+	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED)
+		evt->port_evt.data.oper_state = hw_evt->param.oper_state;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct prestera_fw_evt_parser {
+	int (*func)(u8 *msg, struct prestera_event *evt);
+} fw_event_parsers[PRESTERA_EVENT_TYPE_MAX] = {
+	[PRESTERA_EVENT_TYPE_PORT] = {.func = prestera_fw_parse_port_evt},
+};
+
+static struct prestera_fw_event_handler *
+__find_event_handler(const struct prestera_switch *sw,
+		     enum prestera_event_type type)
+{
+	struct prestera_fw_event_handler *eh;
+
+	list_for_each_entry_rcu(eh, &sw->event_handlers, list) {
+		if (eh->type == type)
+			return eh;
+	}
+
+	return NULL;
+}
+
+static int prestera_find_event_handler(const struct prestera_switch *sw,
+				       enum prestera_event_type type,
+				       struct prestera_fw_event_handler *eh)
+{
+	struct prestera_fw_event_handler *tmp;
+	int err = 0;
+
+	rcu_read_lock();
+	tmp = __find_event_handler(sw, type);
+	if (tmp)
+		*eh = *tmp;
+	else
+		err = -EEXIST;
+	rcu_read_unlock();
+
+	return err;
+}
+
+static int prestera_evt_recv(struct prestera_device *dev, u8 *buf, size_t size)
+{
+	struct prestera_msg_event *msg = (struct prestera_msg_event *)buf;
+	struct prestera_switch *sw = dev->priv;
+	struct prestera_fw_event_handler eh;
+	struct prestera_event evt;
+	int err;
+
+	if (msg->type >= PRESTERA_EVENT_TYPE_MAX)
+		return -EINVAL;
+
+	err = prestera_find_event_handler(sw, msg->type, &eh);
+
+	if (err || !fw_event_parsers[msg->type].func)
+		return 0;
+
+	evt.id = msg->id;
+
+	err = fw_event_parsers[msg->type].func(buf, &evt);
+	if (!err)
+		eh.func(sw, &evt, eh.arg);
+
+	return err;
+}
+
+static void prestera_pkt_recv(struct prestera_device *dev)
+{
+	struct prestera_switch *sw = dev->priv;
+	struct prestera_fw_event_handler eh;
+	struct prestera_event ev;
+	int err;
+
+	ev.id = PRESTERA_RXTX_EVENT_RCV_PKT;
+
+	err = prestera_find_event_handler(sw, PRESTERA_EVENT_TYPE_RXTX, &eh);
+	if (err)
+		return;
+
+	eh.func(sw, &ev, eh.arg);
+}
+
+int prestera_hw_port_info_get(const struct prestera_port *port,
+			      u16 *fp_id, u32 *hw_id, u32 *dev_id)
+{
+	struct prestera_msg_port_info_resp resp;
+	struct prestera_msg_port_info_req req = {
+		.port = port->id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_INFO_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*hw_id = resp.hw_id;
+	*dev_id = resp.dev_id;
+	*fp_id = resp.fp_id;
+
+	return 0;
+}
+
+int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac)
+{
+	struct prestera_msg_switch_attr_req req = {
+		.attr = PRESTERA_CMD_SWITCH_ATTR_MAC,
+	};
+
+	memcpy(req.param.mac, mac, sizeof(req.param.mac));
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_switch_init(struct prestera_switch *sw)
+{
+	struct prestera_msg_switch_init_resp resp;
+	struct prestera_msg_common_req req;
+	int err;
+
+	INIT_LIST_HEAD(&sw->event_handlers);
+
+	err = prestera_cmd_ret_wait(sw, PRESTERA_CMD_TYPE_SWITCH_INIT,
+				    &req.cmd, sizeof(req),
+				    &resp.ret, sizeof(resp),
+				    PRESTERA_SWITCH_INIT_TIMEOUT);
+	if (err)
+		return err;
+
+	sw->id = resp.switch_id;
+	sw->port_count = resp.port_count;
+	sw->mtu_min = PRESTERA_MIN_MTU;
+	sw->mtu_max = resp.mtu_max;
+	sw->dev->recv_msg = prestera_evt_recv;
+	sw->dev->recv_pkt = prestera_pkt_recv;
+
+	return 0;
+}
+
+int prestera_hw_port_state_set(const struct prestera_port *port,
+			       bool admin_state)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.admin_state = admin_state}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MTU,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.mtu = mtu}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MAC,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	memcpy(&req.param.mac, mac, sizeof(req.param.mac));
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_cap_get(const struct prestera_port *port,
+			     struct prestera_port_caps *caps)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	caps->supp_link_modes = resp.param.cap.link_mode;
+	caps->supp_fec = resp.param.cap.fec;
+	caps->type = resp.param.cap.type;
+	caps->transceiver = resp.param.cap.transceiver;
+
+	return err;
+}
+
+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
+				 bool autoneg, u64 link_modes, u8 fec)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.autoneg = {.link_mode = link_modes,
+				      .enable = autoneg,
+				      .fec = fec}
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_stats_get(const struct prestera_port *port,
+			       struct prestera_port_stats *st)
+{
+	struct prestera_msg_port_stats_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_STATS,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	u64 *hw = resp.stats;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	st->good_octets_received = hw[PRESTERA_PORT_GOOD_OCTETS_RCV_CNT];
+	st->bad_octets_received = hw[PRESTERA_PORT_BAD_OCTETS_RCV_CNT];
+	st->mac_trans_error = hw[PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT];
+	st->broadcast_frames_received = hw[PRESTERA_PORT_BRDC_PKTS_RCV_CNT];
+	st->multicast_frames_received = hw[PRESTERA_PORT_MC_PKTS_RCV_CNT];
+	st->frames_64_octets = hw[PRESTERA_PORT_PKTS_64L_CNT];
+	st->frames_65_to_127_octets = hw[PRESTERA_PORT_PKTS_65TO127L_CNT];
+	st->frames_128_to_255_octets = hw[PRESTERA_PORT_PKTS_128TO255L_CNT];
+	st->frames_256_to_511_octets = hw[PRESTERA_PORT_PKTS_256TO511L_CNT];
+	st->frames_512_to_1023_octets = hw[PRESTERA_PORT_PKTS_512TO1023L_CNT];
+	st->frames_1024_to_max_octets = hw[PRESTERA_PORT_PKTS_1024TOMAXL_CNT];
+	st->excessive_collision = hw[PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT];
+	st->multicast_frames_sent = hw[PRESTERA_PORT_MC_PKTS_SENT_CNT];
+	st->broadcast_frames_sent = hw[PRESTERA_PORT_BRDC_PKTS_SENT_CNT];
+	st->fc_sent = hw[PRESTERA_PORT_FC_SENT_CNT];
+	st->fc_received = hw[PRESTERA_PORT_GOOD_FC_RCV_CNT];
+	st->buffer_overrun = hw[PRESTERA_PORT_DROP_EVENTS_CNT];
+	st->undersize = hw[PRESTERA_PORT_UNDERSIZE_PKTS_CNT];
+	st->fragments = hw[PRESTERA_PORT_FRAGMENTS_PKTS_CNT];
+	st->oversize = hw[PRESTERA_PORT_OVERSIZE_PKTS_CNT];
+	st->jabber = hw[PRESTERA_PORT_JABBER_PKTS_CNT];
+	st->rx_error_frame_received = hw[PRESTERA_PORT_MAC_RCV_ERROR_CNT];
+	st->bad_crc = hw[PRESTERA_PORT_BAD_CRC_CNT];
+	st->collisions = hw[PRESTERA_PORT_COLLISIONS_CNT];
+	st->late_collision = hw[PRESTERA_PORT_LATE_COLLISIONS_CNT];
+	st->unicast_frames_received = hw[PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT];
+	st->unicast_frames_sent = hw[PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT];
+	st->sent_multiple = hw[PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT];
+	st->sent_deferred = hw[PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT];
+	st->good_octets_sent = hw[PRESTERA_PORT_GOOD_OCTETS_SENT_CNT];
+
+	return 0;
+}
+
+int prestera_hw_rxtx_init(struct prestera_switch *sw,
+			  struct prestera_rxtx_params *params)
+{
+	struct prestera_msg_rxtx_resp resp;
+	struct prestera_msg_rxtx_req req;
+	int err;
+
+	req.use_sdma = params->use_sdma;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_RXTX_INIT,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	params->map_addr = resp.map_addr;
+	return 0;
+}
+
+int prestera_hw_rxtx_port_init(struct prestera_port *port)
+{
+	struct prestera_msg_rxtx_port_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_RXTX_PORT_INIT,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_event_handler_register(struct prestera_switch *sw,
+				       enum prestera_event_type type,
+				       prestera_event_cb_t fn,
+				       void *arg)
+{
+	struct prestera_fw_event_handler *eh;
+
+	eh = __find_event_handler(sw, type);
+	if (eh)
+		return -EEXIST;
+	eh = kmalloc(sizeof(*eh), GFP_KERNEL);
+	if (!eh)
+		return -ENOMEM;
+
+	eh->type = type;
+	eh->func = fn;
+	eh->arg = arg;
+
+	INIT_LIST_HEAD(&eh->list);
+
+	list_add_rcu(&eh->list, &sw->event_handlers);
+
+	return 0;
+}
+
+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
+					  enum prestera_event_type type,
+					  prestera_event_cb_t fn)
+{
+	struct prestera_fw_event_handler *eh;
+
+	eh = __find_event_handler(sw, type);
+	if (!eh)
+		return;
+
+	list_del_rcu(&eh->list);
+	synchronize_rcu();
+	kfree(eh);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
new file mode 100644
index 000000000000..acb0e31d6684
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+
+#ifndef _PRESTERA_HW_H_
+#define _PRESTERA_HW_H_
+
+#include <linux/types.h>
+
+enum {
+	PRESTERA_PORT_TYPE_NONE,
+	PRESTERA_PORT_TYPE_TP,
+
+	PRESTERA_PORT_TYPE_MAX,
+};
+
+enum {
+	PRESTERA_PORT_FEC_OFF,
+
+	PRESTERA_PORT_FEC_MAX,
+};
+
+struct prestera_switch;
+struct prestera_port;
+struct prestera_port_stats;
+struct prestera_port_caps;
+enum prestera_event_type;
+struct prestera_event;
+
+typedef void (*prestera_event_cb_t)
+	(struct prestera_switch *sw, struct prestera_event *evt, void *arg);
+
+struct prestera_rxtx_params;
+
+/* Switch API */
+int prestera_hw_switch_init(struct prestera_switch *sw);
+int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac);
+
+/* Port API */
+int prestera_hw_port_info_get(const struct prestera_port *port,
+			      u16 *fp_id, u32 *hw_id, u32 *dev_id);
+int prestera_hw_port_state_set(const struct prestera_port *port,
+			       bool admin_state);
+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu);
+int prestera_hw_port_mtu_get(const struct prestera_port *port, u32 *mtu);
+int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac);
+int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
+int prestera_hw_port_cap_get(const struct prestera_port *port,
+			     struct prestera_port_caps *caps);
+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
+				 bool autoneg, u64 link_modes, u8 fec);
+int prestera_hw_port_stats_get(const struct prestera_port *port,
+			       struct prestera_port_stats *stats);
+
+/* Event handlers */
+int prestera_hw_event_handler_register(struct prestera_switch *sw,
+				       enum prestera_event_type type,
+				       prestera_event_cb_t fn,
+				       void *arg);
+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
+					  enum prestera_event_type type,
+					  prestera_event_cb_t fn);
+
+/* RX/TX */
+int prestera_hw_rxtx_init(struct prestera_switch *sw,
+			  struct prestera_rxtx_params *params);
+int prestera_hw_rxtx_port_init(struct prestera_port *port);
+
+#endif /* _PRESTERA_HW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
new file mode 100644
index 000000000000..b5241e9b784a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -0,0 +1,506 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/netdev_features.h>
+#include <linux/etherdevice.h>
+#include <linux/jiffies.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_rxtx.h"
+
+#define PRESTERA_MTU_DEFAULT 1536
+
+#define PRESTERA_STATS_DELAY_MS	msecs_to_jiffies(1000)
+
+static struct workqueue_struct *prestera_wq;
+
+struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
+						 u32 dev_id, u32 hw_id)
+{
+	struct prestera_port *port;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(port, &sw->port_list, list) {
+		if (port->dev_id == dev_id && port->hw_id == hw_id) {
+			rcu_read_unlock();
+			return port;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return NULL;
+}
+
+static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
+						u32 port_id)
+{
+	struct prestera_port *port;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(port, &sw->port_list, list) {
+		if (port->id == port_id)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return port;
+}
+
+static int prestera_port_state_set(struct net_device *dev, bool is_up)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	int err;
+
+	if (!is_up)
+		netif_stop_queue(dev);
+
+	err = prestera_hw_port_state_set(port, is_up);
+
+	if (is_up && !err)
+		netif_start_queue(dev);
+
+	return err;
+}
+
+static int prestera_port_open(struct net_device *dev)
+{
+	return prestera_port_state_set(dev, true);
+}
+
+static int prestera_port_close(struct net_device *dev)
+{
+	return prestera_port_state_set(dev, false);
+}
+
+static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	return prestera_rxtx_xmit(netdev_priv(dev), skb);
+}
+
+static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
+{
+	if (!is_valid_ether_addr(addr))
+		return -EADDRNOTAVAIL;
+
+	if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int prestera_port_set_mac_address(struct net_device *dev, void *p)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct sockaddr *addr = p;
+	int err;
+
+	err = prestera_is_valid_mac_addr(port, addr->sa_data);
+	if (err)
+		return err;
+
+	err = prestera_hw_port_mac_set(port, addr->sa_data);
+	if (err)
+		return err;
+
+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	return 0;
+}
+
+static int prestera_port_change_mtu(struct net_device *dev, int mtu)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	int err;
+
+	err = prestera_hw_port_mtu_set(port, mtu);
+	if (err)
+		return err;
+
+	dev->mtu = mtu;
+	return 0;
+}
+
+static void prestera_port_get_stats64(struct net_device *dev,
+				      struct rtnl_link_stats64 *stats)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_stats *port_stats = &port->cached_hw_stats.stats;
+
+	stats->rx_packets = port_stats->broadcast_frames_received +
+				port_stats->multicast_frames_received +
+				port_stats->unicast_frames_received;
+
+	stats->tx_packets = port_stats->broadcast_frames_sent +
+				port_stats->multicast_frames_sent +
+				port_stats->unicast_frames_sent;
+
+	stats->rx_bytes = port_stats->good_octets_received;
+
+	stats->tx_bytes = port_stats->good_octets_sent;
+
+	stats->rx_errors = port_stats->rx_error_frame_received;
+	stats->tx_errors = port_stats->mac_trans_error;
+
+	stats->rx_dropped = port_stats->buffer_overrun;
+	stats->tx_dropped = 0;
+
+	stats->multicast = port_stats->multicast_frames_received;
+	stats->collisions = port_stats->excessive_collision;
+
+	stats->rx_crc_errors = port_stats->bad_crc;
+}
+
+static void prestera_port_get_hw_stats(struct prestera_port *port)
+{
+	prestera_hw_port_stats_get(port, &port->cached_hw_stats.stats);
+}
+
+static void prestera_port_stats_update(struct work_struct *work)
+{
+	struct prestera_port *port =
+		container_of(work, struct prestera_port,
+			     cached_hw_stats.caching_dw.work);
+
+	prestera_port_get_hw_stats(port);
+
+	queue_delayed_work(prestera_wq, &port->cached_hw_stats.caching_dw,
+			   PRESTERA_STATS_DELAY_MS);
+}
+
+static const struct net_device_ops netdev_ops = {
+	.ndo_open = prestera_port_open,
+	.ndo_stop = prestera_port_close,
+	.ndo_start_xmit = prestera_port_xmit,
+	.ndo_change_mtu = prestera_port_change_mtu,
+	.ndo_get_stats64 = prestera_port_get_stats64,
+	.ndo_set_mac_address = prestera_port_set_mac_address,
+};
+
+static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
+				     u64 link_modes, u8 fec)
+{
+	bool refresh = false;
+	int err = 0;
+
+	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
+		return enable ? -EINVAL : 0;
+
+	if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
+		port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
+		port->adver_link_modes = link_modes;
+		refresh = true;
+	}
+
+	if (port->autoneg == enable && !(port->autoneg && refresh))
+		return 0;
+
+	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
+					   port->adver_fec);
+	if (err)
+		return -EINVAL;
+
+	port->autoneg = enable;
+	return 0;
+}
+
+static int prestera_port_create(struct prestera_switch *sw, u32 id)
+{
+	struct prestera_port *port;
+	struct net_device *dev;
+	int err;
+
+	dev = alloc_etherdev(sizeof(*port));
+	if (!dev)
+		return -ENOMEM;
+
+	port = netdev_priv(dev);
+
+	port->dev = dev;
+	port->id = id;
+	port->sw = sw;
+
+	err = prestera_hw_port_info_get(port, &port->fp_id,
+					&port->hw_id, &port->dev_id);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
+		goto err_port_init;
+	}
+
+	dev->features |= NETIF_F_NETNS_LOCAL;
+	dev->netdev_ops = &netdev_ops;
+
+	netif_carrier_off(dev);
+
+	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
+	dev->min_mtu = sw->mtu_min;
+	dev->max_mtu = sw->mtu_max;
+
+	err = prestera_hw_port_mtu_set(port, dev->mtu);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to set port(%u) mtu(%d)\n",
+			id, dev->mtu);
+		goto err_port_init;
+	}
+
+	/* Only 0xFF mac addrs are supported */
+	if (port->fp_id >= 0xFF)
+		goto err_port_init;
+
+	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
+	dev->dev_addr[dev->addr_len - 1] = (char)port->fp_id;
+
+	err = prestera_hw_port_mac_set(port, dev->dev_addr);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to set port(%u) mac addr\n", id);
+		goto err_port_init;
+	}
+
+	err = prestera_hw_port_cap_get(port, &port->caps);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to get port(%u) caps\n", id);
+		goto err_port_init;
+	}
+
+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
+	prestera_port_autoneg_set(port, true, port->caps.supp_link_modes,
+				  port->caps.supp_fec);
+
+	err = prestera_hw_port_state_set(port, false);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to set port(%u) down\n", id);
+		goto err_port_init;
+	}
+
+	err = prestera_rxtx_port_init(port);
+	if (err)
+		goto err_port_init;
+
+	INIT_DELAYED_WORK(&port->cached_hw_stats.caching_dw,
+			  &prestera_port_stats_update);
+
+	list_add_rcu(&port->list, &sw->port_list);
+
+	err = register_netdev(dev);
+	if (err)
+		goto err_register_netdev;
+
+	return 0;
+
+err_register_netdev:
+	list_del_rcu(&port->list);
+err_port_init:
+	free_netdev(dev);
+	return err;
+}
+
+static void prestera_port_destroy(struct prestera_port *port)
+{
+	struct net_device *dev = port->dev;
+
+	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+	unregister_netdev(dev);
+
+	list_del_rcu(&port->list);
+
+	free_netdev(dev);
+}
+
+static void prestera_destroy_ports(struct prestera_switch *sw)
+{
+	struct prestera_port *port, *tmp;
+	struct list_head remove_list;
+
+	INIT_LIST_HEAD(&remove_list);
+
+	list_splice_init(&sw->port_list, &remove_list);
+
+	list_for_each_entry_safe(port, tmp, &remove_list, list)
+		prestera_port_destroy(port);
+}
+
+static int prestera_create_ports(struct prestera_switch *sw)
+{
+	u32 port;
+	int err;
+
+	for (port = 0; port < sw->port_count; port++) {
+		err = prestera_port_create(sw, port);
+		if (err)
+			goto err_ports_init;
+	}
+
+	return 0;
+
+err_ports_init:
+	prestera_destroy_ports(sw);
+	return err;
+}
+
+static void prestera_port_handle_event(struct prestera_switch *sw,
+				       struct prestera_event *evt, void *arg)
+{
+	struct delayed_work *caching_dw;
+	struct prestera_port *port;
+
+	port = prestera_find_port(sw, evt->port_evt.port_id);
+	if (!port)
+		return;
+
+	caching_dw = &port->cached_hw_stats.caching_dw;
+
+	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED) {
+		if (evt->port_evt.data.oper_state) {
+			netif_carrier_on(port->dev);
+			if (!delayed_work_pending(caching_dw))
+				queue_delayed_work(prestera_wq, caching_dw, 0);
+		} else {
+			netif_carrier_off(port->dev);
+			if (delayed_work_pending(caching_dw))
+				cancel_delayed_work(caching_dw);
+		}
+	}
+}
+
+static void prestera_event_handlers_unregister(struct prestera_switch *sw)
+{
+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_PORT,
+					     prestera_port_handle_event);
+}
+
+static int prestera_event_handlers_register(struct prestera_switch *sw)
+{
+	return prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_PORT,
+						  prestera_port_handle_event,
+						  NULL);
+}
+
+static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
+{
+	struct device_node *base_mac_np;
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
+	if (np) {
+		base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
+		if (base_mac_np) {
+			const char *base_mac;
+
+			base_mac = of_get_mac_address(base_mac_np);
+			of_node_put(base_mac_np);
+			if (!IS_ERR(base_mac))
+				ether_addr_copy(sw->base_mac, base_mac);
+		}
+	}
+
+	if (!is_valid_ether_addr(sw->base_mac)) {
+		eth_random_addr(sw->base_mac);
+		dev_info(sw->dev->dev, "using random base mac address\n");
+	}
+
+	return prestera_hw_switch_mac_set(sw, sw->base_mac);
+}
+
+static int prestera_switch_init(struct prestera_switch *sw)
+{
+	int err;
+
+	err = prestera_hw_switch_init(sw);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
+		return err;
+	}
+
+	INIT_LIST_HEAD(&sw->port_list);
+
+	err = prestera_switch_set_base_mac_addr(sw);
+	if (err)
+		return err;
+
+	err = prestera_rxtx_switch_init(sw);
+	if (err)
+		return err;
+
+	err = prestera_event_handlers_register(sw);
+	if (err)
+		return err;
+
+	err = prestera_create_ports(sw);
+	if (err)
+		goto err_ports_create;
+
+	return 0;
+
+err_ports_create:
+	prestera_event_handlers_unregister(sw);
+
+	return err;
+}
+
+static void prestera_switch_fini(struct prestera_switch *sw)
+{
+	prestera_destroy_ports(sw);
+	prestera_event_handlers_unregister(sw);
+	prestera_rxtx_switch_fini(sw);
+}
+
+int prestera_device_register(struct prestera_device *dev)
+{
+	struct prestera_switch *sw;
+	int err;
+
+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	if (!sw)
+		return -ENOMEM;
+
+	dev->priv = sw;
+	sw->dev = dev;
+
+	err = prestera_switch_init(sw);
+	if (err) {
+		kfree(sw);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(prestera_device_register);
+
+void prestera_device_unregister(struct prestera_device *dev)
+{
+	struct prestera_switch *sw = dev->priv;
+
+	prestera_switch_fini(sw);
+	kfree(sw);
+}
+EXPORT_SYMBOL(prestera_device_unregister);
+
+static int __init prestera_module_init(void)
+{
+	prestera_wq = alloc_workqueue("prestera", 0, 0);
+	if (!prestera_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit prestera_module_exit(void)
+{
+	destroy_workqueue(prestera_wq);
+}
+
+module_init(prestera_module_init);
+module_exit(prestera_module_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("Marvell Prestera switch driver");
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
new file mode 100644
index 000000000000..78f1b7dfdc2e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -0,0 +1,860 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/dmapool.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_dsa.h"
+#include "prestera_rxtx.h"
+
+struct prestera_sdma_desc {
+	__le32 word1;
+	__le32 word2;
+	__le32 buff;
+	__le32 next;
+} __packed __aligned(16);
+
+#define PRESTERA_SDMA_BUFF_SIZE_MAX	1544
+
+#define PRESTERA_SDMA_RX_DESC_PKT_LEN(desc) \
+	((le32_to_cpu((desc)->word2) >> 16) & 0x3FFF)
+
+#define PRESTERA_SDMA_RX_DESC_OWNER(desc) \
+	((le32_to_cpu((desc)->word1) & BIT(31)) >> 31)
+
+#define PRESTERA_SDMA_RX_DESC_IS_RCVD(desc) \
+	(PRESTERA_SDMA_RX_DESC_OWNER((desc)) == PRESTERA_SDMA_RX_DESC_CPU_OWN)
+
+#define PRESTERA_SDMA_RX_DESC_CPU_OWN	0
+#define PRESTERA_SDMA_RX_DESC_DMA_OWN	1
+
+#define PRESTERA_SDMA_RX_QUEUE_NUM	8
+
+#define PRESTERA_SDMA_RX_DESC_PER_Q	1000
+
+#define PRESTERA_SDMA_TX_DESC_PER_Q	1000
+#define PRESTERA_SDMA_TX_MAX_BURST	64
+
+#define PRESTERA_SDMA_TX_DESC_OWNER(desc) \
+	((le32_to_cpu((desc)->word1) & BIT(31)) >> 31)
+
+#define PRESTERA_SDMA_TX_DESC_CPU_OWN	0
+#define PRESTERA_SDMA_TX_DESC_DMA_OWN	1
+
+#define PRESTERA_SDMA_TX_DESC_IS_SENT(desc) \
+	(PRESTERA_SDMA_TX_DESC_OWNER(desc) == PRESTERA_SDMA_TX_DESC_CPU_OWN)
+
+#define PRESTERA_SDMA_TX_DESC_LAST	BIT(20)
+#define PRESTERA_SDMA_TX_DESC_FIRST	BIT(21)
+#define PRESTERA_SDMA_TX_DESC_CALC_CRC	BIT(12)
+
+#define PRESTERA_SDMA_TX_DESC_SINGLE	\
+	(PRESTERA_SDMA_TX_DESC_FIRST | PRESTERA_SDMA_TX_DESC_LAST)
+
+#define PRESTERA_SDMA_TX_DESC_INIT	\
+	(PRESTERA_SDMA_TX_DESC_SINGLE | PRESTERA_SDMA_TX_DESC_CALC_CRC)
+
+#define PRESTERA_SDMA_RX_INTR_MASK_REG		0x2814
+#define PRESTERA_SDMA_RX_QUEUE_STATUS_REG	0x2680
+#define PRESTERA_SDMA_RX_QUEUE_DESC_REG(n)	(0x260C + (n) * 16)
+
+#define PRESTERA_SDMA_TX_QUEUE_DESC_REG		0x26C0
+#define PRESTERA_SDMA_TX_QUEUE_START_REG		0x2868
+
+struct prestera_sdma_buf {
+	struct prestera_sdma_desc *desc;
+	dma_addr_t desc_dma;
+	struct sk_buff *skb;
+	dma_addr_t buf_dma;
+	bool is_used;
+};
+
+struct prestera_rx_ring {
+	struct prestera_sdma_buf *bufs;
+	int next_rx;
+};
+
+struct prestera_tx_ring {
+	struct prestera_sdma_buf *bufs;
+	int next_tx;
+	int max_burst;
+	int burst;
+};
+
+struct prestera_sdma {
+	struct prestera_rx_ring rx_ring[PRESTERA_SDMA_RX_QUEUE_NUM];
+	struct prestera_tx_ring tx_ring;
+	struct prestera_switch *sw;
+	struct dma_pool *desc_pool;
+	struct work_struct tx_work;
+	struct napi_struct rx_napi;
+	struct net_device napi_dev;
+	u32 map_addr;
+	u64 dma_mask;
+	/* protect SDMA with concurrrent access from multiple CPUs */
+	spinlock_t tx_lock;
+};
+
+struct prestera_rxtx {
+	struct prestera_sdma sdma;
+};
+
+static int prestera_sdma_buf_init(struct prestera_sdma *sdma,
+				  struct prestera_sdma_buf *buf)
+{
+	struct device *dma_dev = sdma->sw->dev->dev;
+	struct prestera_sdma_desc *desc;
+	dma_addr_t dma;
+
+	desc = dma_pool_alloc(sdma->desc_pool, GFP_DMA | GFP_KERNEL, &dma);
+	if (!desc)
+		return -ENOMEM;
+
+	if (dma + sizeof(struct prestera_sdma_desc) > sdma->dma_mask) {
+		dev_err(dma_dev, "failed to alloc desc\n");
+		dma_pool_free(sdma->desc_pool, desc, dma);
+		return -ENOMEM;
+	}
+
+	buf->buf_dma = DMA_MAPPING_ERROR;
+	buf->desc_dma = dma;
+	buf->desc = desc;
+	buf->skb = NULL;
+
+	return 0;
+}
+
+static u32 prestera_sdma_map(struct prestera_sdma *sdma, dma_addr_t pa)
+{
+	return sdma->map_addr + pa;
+}
+
+static void prestera_sdma_rx_desc_set_len(struct prestera_sdma_desc *desc,
+					  size_t val)
+{
+	u32 word = le32_to_cpu(desc->word2);
+
+	word = (word & ~GENMASK(15, 0)) | val;
+	desc->word2 = cpu_to_le32(word);
+}
+
+static void prestera_sdma_rx_desc_init(struct prestera_sdma *sdma,
+				       struct prestera_sdma_desc *desc,
+				       dma_addr_t buf)
+{
+	prestera_sdma_rx_desc_set_len(desc, PRESTERA_SDMA_BUFF_SIZE_MAX);
+	desc->buff = cpu_to_le32(prestera_sdma_map(sdma, buf));
+
+	/* make sure buffer is set before reset the descriptor */
+	wmb();
+
+	desc->word1 = cpu_to_le32(0xA0000000);
+}
+
+static void prestera_sdma_rx_desc_set_next(struct prestera_sdma *sdma,
+					   struct prestera_sdma_desc *desc,
+					   dma_addr_t next)
+{
+	desc->next = cpu_to_le32(prestera_sdma_map(sdma, next));
+}
+
+static int prestera_sdma_rx_skb_alloc(struct prestera_sdma *sdma,
+				      struct prestera_sdma_buf *buf)
+{
+	struct device *dev = sdma->sw->dev->dev;
+	struct sk_buff *skb;
+	dma_addr_t dma;
+
+	skb = alloc_skb(PRESTERA_SDMA_BUFF_SIZE_MAX, GFP_DMA | GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	dma = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
+
+	if (dma_mapping_error(dev, dma))
+		goto err_dma_map;
+	if (dma + skb->len > sdma->dma_mask)
+		goto err_dma_range;
+
+	if (buf->skb)
+		dma_unmap_single(dev, buf->buf_dma, buf->skb->len,
+				 DMA_FROM_DEVICE);
+
+	buf->buf_dma = dma;
+	buf->skb = skb;
+	return 0;
+
+err_dma_range:
+	dma_unmap_single(dev, dma, skb->len, DMA_FROM_DEVICE);
+err_dma_map:
+	kfree_skb(skb);
+
+	return -ENOMEM;
+}
+
+static struct sk_buff *prestera_sdma_rx_skb_get(struct prestera_sdma *sdma,
+						struct prestera_sdma_buf *buf)
+{
+	dma_addr_t buf_dma = buf->buf_dma;
+	struct sk_buff *skb = buf->skb;
+	u32 len = skb->len;
+	int err;
+
+	err = prestera_sdma_rx_skb_alloc(sdma, buf);
+	if (err) {
+		buf->buf_dma = buf_dma;
+		buf->skb = skb;
+
+		skb = alloc_skb(skb->len, GFP_ATOMIC);
+		if (skb) {
+			skb_put(skb, len);
+			skb_copy_from_linear_data(buf->skb, skb->data, len);
+		}
+	}
+
+	prestera_sdma_rx_desc_init(sdma, buf->desc, buf->buf_dma);
+
+	return skb;
+}
+
+static int prestera_rxtx_process_skb(struct prestera_sdma *sdma,
+				     struct sk_buff *skb)
+{
+	const struct prestera_port *port;
+	struct prestera_dsa dsa;
+	u32 hw_port, hw_id;
+	int err;
+
+	skb_pull(skb, ETH_HLEN);
+
+	/* ethertype field is part of the dsa header */
+	err = prestera_dsa_parse(&dsa, skb->data - ETH_TLEN);
+	if (err)
+		return err;
+
+	hw_port = dsa.port_num;
+	hw_id = dsa.hw_dev_num;
+
+	port = prestera_port_find_by_hwid(sdma->sw, hw_id, hw_port);
+	if (unlikely(!port)) {
+		pr_warn_ratelimited("prestera: received pkt for non-existent port(%u, %u)\n",
+				    hw_id, hw_port);
+		return -EEXIST;
+	}
+
+	if (unlikely(!pskb_may_pull(skb, PRESTERA_DSA_HLEN)))
+		return -EINVAL;
+
+	/* remove DSA tag and update checksum */
+	skb_pull_rcsum(skb, PRESTERA_DSA_HLEN);
+
+	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - PRESTERA_DSA_HLEN,
+		ETH_ALEN * 2);
+
+	skb_push(skb, ETH_HLEN);
+
+	skb->protocol = eth_type_trans(skb, port->dev);
+
+	if (dsa.vlan.is_tagged) {
+		u16 tci = dsa.vlan.vid & VLAN_VID_MASK;
+
+		tci |= dsa.vlan.vpt << VLAN_PRIO_SHIFT;
+		if (dsa.vlan.cfi_bit)
+			tci |= VLAN_CFI_MASK;
+
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tci);
+	}
+
+	return 0;
+}
+
+static int prestera_sdma_next_rx_buf_idx(int buf_idx)
+{
+	return (buf_idx + 1) % PRESTERA_SDMA_RX_DESC_PER_Q;
+}
+
+static int prestera_sdma_rx_poll(struct napi_struct *napi, int budget)
+{
+	int qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	unsigned int rxq_done_map = 0;
+	struct prestera_sdma *sdma;
+	struct list_head rx_list;
+	unsigned int qmask;
+	int pkts_done = 0;
+	int q;
+
+	qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	qmask = GENMASK(qnum - 1, 0);
+
+	INIT_LIST_HEAD(&rx_list);
+
+	sdma = container_of(napi, struct prestera_sdma, rx_napi);
+
+	while (pkts_done < budget && rxq_done_map != qmask) {
+		for (q = 0; q < qnum && pkts_done < budget; q++) {
+			struct prestera_rx_ring *ring = &sdma->rx_ring[q];
+			struct prestera_sdma_desc *desc;
+			struct prestera_sdma_buf *buf;
+			int buf_idx = ring->next_rx;
+			struct sk_buff *skb;
+
+			buf = &ring->bufs[buf_idx];
+			desc = buf->desc;
+
+			if (PRESTERA_SDMA_RX_DESC_IS_RCVD(desc)) {
+				rxq_done_map &= ~BIT(q);
+			} else {
+				rxq_done_map |= BIT(q);
+				continue;
+			}
+
+			pkts_done++;
+
+			__skb_trim(buf->skb, PRESTERA_SDMA_RX_DESC_PKT_LEN(desc));
+
+			skb = prestera_sdma_rx_skb_get(sdma, buf);
+			if (!skb)
+				goto rx_next_buf;
+
+			if (unlikely(prestera_rxtx_process_skb(sdma, skb)))
+				goto rx_next_buf;
+
+			list_add_tail(&skb->list, &rx_list);
+rx_next_buf:
+			ring->next_rx = prestera_sdma_next_rx_buf_idx(buf_idx);
+		}
+	}
+
+	if (pkts_done < budget && napi_complete_done(napi, pkts_done))
+		prestera_write(sdma->sw, PRESTERA_SDMA_RX_INTR_MASK_REG,
+			       0xff << 2);
+
+	netif_receive_skb_list(&rx_list);
+
+	return pkts_done;
+}
+
+static void prestera_sdma_rx_fini(struct prestera_sdma *sdma)
+{
+	int qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	int q, b;
+
+	/* disable all rx queues */
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_STATUS_REG, 0xff00);
+
+	for (q = 0; q < qnum; q++) {
+		struct prestera_rx_ring *ring = &sdma->rx_ring[q];
+
+		if (!ring->bufs)
+			break;
+
+		for (b = 0; b < PRESTERA_SDMA_RX_DESC_PER_Q; b++) {
+			struct prestera_sdma_buf *buf = &ring->bufs[b];
+
+			if (buf->desc_dma)
+				dma_pool_free(sdma->desc_pool, buf->desc,
+					      buf->desc_dma);
+
+			if (!buf->skb)
+				continue;
+
+			if (buf->buf_dma != DMA_MAPPING_ERROR)
+				dma_unmap_single(sdma->sw->dev->dev,
+						 buf->buf_dma, buf->skb->len,
+						 DMA_FROM_DEVICE);
+			kfree_skb(buf->skb);
+		}
+	}
+}
+
+static int prestera_sdma_rx_init(struct prestera_sdma *sdma)
+{
+	int bnum = PRESTERA_SDMA_RX_DESC_PER_Q;
+	int qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	int q, b;
+	int err;
+
+	/* disable all rx queues */
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_STATUS_REG, 0xff00);
+
+	for (q = 0; q < qnum; q++) {
+		struct prestera_rx_ring *ring = &sdma->rx_ring[q];
+		struct prestera_sdma_buf *head;
+
+		ring->bufs = kmalloc_array(bnum, sizeof(*head), GFP_KERNEL);
+		if (!ring->bufs)
+			return -ENOMEM;
+
+		head = &ring->bufs[0];
+		ring->next_rx = 0;
+
+		for (b = 0; b < bnum; b++) {
+			struct prestera_sdma_buf *buf = &ring->bufs[b];
+
+			err = prestera_sdma_buf_init(sdma, buf);
+			if (err)
+				return err;
+
+			err = prestera_sdma_rx_skb_alloc(sdma, buf);
+			if (err)
+				return err;
+
+			prestera_sdma_rx_desc_init(sdma, buf->desc,
+						   buf->buf_dma);
+
+			if (b == 0)
+				continue;
+
+			prestera_sdma_rx_desc_set_next(sdma,
+						       ring->bufs[b - 1].desc,
+						       buf->desc_dma);
+
+			if (b == PRESTERA_SDMA_RX_DESC_PER_Q - 1)
+				prestera_sdma_rx_desc_set_next(sdma, buf->desc,
+							       head->desc_dma);
+		}
+
+		prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_DESC_REG(q),
+			       prestera_sdma_map(sdma, head->desc_dma));
+	}
+
+	/* make sure all rx descs are filled before enabling all rx queues */
+	wmb();
+
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_STATUS_REG, 0xff);
+
+	return 0;
+}
+
+static void prestera_sdma_tx_desc_init(struct prestera_sdma *sdma,
+				       struct prestera_sdma_desc *desc)
+{
+	desc->word1 = cpu_to_le32(PRESTERA_SDMA_TX_DESC_INIT);
+	desc->word2 = 0;
+}
+
+static void prestera_sdma_tx_desc_set_next(struct prestera_sdma *sdma,
+					   struct prestera_sdma_desc *desc,
+					   dma_addr_t next)
+{
+	desc->next = cpu_to_le32(prestera_sdma_map(sdma, next));
+}
+
+static void prestera_sdma_tx_desc_set_buf(struct prestera_sdma *sdma,
+					  struct prestera_sdma_desc *desc,
+					  dma_addr_t buf, size_t len)
+{
+	u32 word = le32_to_cpu(desc->word2);
+
+	word = (word & ~GENMASK(30, 16)) | ((len + ETH_FCS_LEN) << 16);
+
+	desc->buff = cpu_to_le32(prestera_sdma_map(sdma, buf));
+	desc->word2 = cpu_to_le32(word);
+}
+
+static void prestera_sdma_tx_desc_xmit(struct prestera_sdma_desc *desc)
+{
+	u32 word = le32_to_cpu(desc->word1);
+
+	word |= PRESTERA_SDMA_TX_DESC_DMA_OWN << 31;
+
+	/* make sure everything is written before enable xmit */
+	wmb();
+
+	desc->word1 = cpu_to_le32(word);
+}
+
+static int prestera_sdma_tx_buf_map(struct prestera_sdma *sdma,
+				    struct prestera_sdma_buf *buf,
+				    struct sk_buff *skb)
+{
+	struct device *dma_dev = sdma->sw->dev->dev;
+	struct sk_buff *new_skb;
+	size_t len = skb->len;
+	dma_addr_t dma;
+
+	dma = dma_map_single(dma_dev, skb->data, len, DMA_TO_DEVICE);
+	if (!dma_mapping_error(dma_dev, dma) && dma + len <= sdma->dma_mask) {
+		buf->buf_dma = dma;
+		buf->skb = skb;
+		return 0;
+	}
+
+	if (!dma_mapping_error(dma_dev, dma))
+		dma_unmap_single(dma_dev, dma, len, DMA_TO_DEVICE);
+
+	new_skb = alloc_skb(len, GFP_ATOMIC | GFP_DMA);
+	if (!new_skb)
+		goto err_alloc_skb;
+
+	dma = dma_map_single(dma_dev, new_skb->data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dma_dev, dma))
+		goto err_dma_map;
+	if (dma + len > sdma->dma_mask)
+		goto err_dma_range;
+
+	skb_copy_from_linear_data(skb, skb_put(new_skb, len), len);
+
+	dev_consume_skb_any(skb);
+
+	buf->skb = new_skb;
+	buf->buf_dma = dma;
+
+	return 0;
+
+err_dma_range:
+	dma_unmap_single(dma_dev, dma, len, DMA_TO_DEVICE);
+err_dma_map:
+	dev_kfree_skb(new_skb);
+err_alloc_skb:
+	dev_kfree_skb(skb);
+
+	return -ENOMEM;
+}
+
+static void prestera_sdma_tx_buf_unmap(struct prestera_sdma *sdma,
+				       struct prestera_sdma_buf *buf)
+{
+	struct device *dma_dev = sdma->sw->dev->dev;
+
+	dma_unmap_single(dma_dev, buf->buf_dma, buf->skb->len, DMA_TO_DEVICE);
+}
+
+static void prestera_sdma_tx_recycle_work_fn(struct work_struct *work)
+{
+	int bnum = PRESTERA_SDMA_TX_DESC_PER_Q;
+	struct prestera_tx_ring *tx_ring;
+	struct prestera_sdma *sdma;
+	int b;
+
+	sdma = container_of(work, struct prestera_sdma, tx_work);
+
+	tx_ring = &sdma->tx_ring;
+
+	for (b = 0; b < bnum; b++) {
+		struct prestera_sdma_buf *buf = &tx_ring->bufs[b];
+
+		if (!buf->is_used)
+			continue;
+
+		if (!PRESTERA_SDMA_TX_DESC_IS_SENT(buf->desc))
+			continue;
+
+		prestera_sdma_tx_buf_unmap(sdma, buf);
+		dev_consume_skb_any(buf->skb);
+		buf->skb = NULL;
+
+		/* make sure everything is cleaned up */
+		wmb();
+
+		buf->is_used = false;
+	}
+}
+
+static int prestera_sdma_tx_init(struct prestera_sdma *sdma)
+{
+	struct prestera_tx_ring *tx_ring = &sdma->tx_ring;
+	int bnum = PRESTERA_SDMA_TX_DESC_PER_Q;
+	struct prestera_sdma_buf *head;
+	int err;
+	int b;
+
+	INIT_WORK(&sdma->tx_work, prestera_sdma_tx_recycle_work_fn);
+	spin_lock_init(&sdma->tx_lock);
+
+	tx_ring->bufs = kmalloc_array(bnum, sizeof(*head), GFP_KERNEL);
+	if (!tx_ring->bufs)
+		return -ENOMEM;
+
+	head = &tx_ring->bufs[0];
+
+	tx_ring->max_burst = PRESTERA_SDMA_TX_MAX_BURST;
+	tx_ring->burst = tx_ring->max_burst;
+	tx_ring->next_tx = 0;
+
+	for (b = 0; b < bnum; b++) {
+		struct prestera_sdma_buf *buf = &tx_ring->bufs[b];
+
+		err = prestera_sdma_buf_init(sdma, buf);
+		if (err)
+			return err;
+
+		prestera_sdma_tx_desc_init(sdma, buf->desc);
+
+		buf->is_used = false;
+
+		if (b == 0)
+			continue;
+
+		prestera_sdma_tx_desc_set_next(sdma, tx_ring->bufs[b - 1].desc,
+					       buf->desc_dma);
+
+		if (b == PRESTERA_SDMA_TX_DESC_PER_Q - 1)
+			prestera_sdma_tx_desc_set_next(sdma, buf->desc,
+						       head->desc_dma);
+	}
+
+	/* make sure descriptors are written */
+	wmb();
+
+	prestera_write(sdma->sw, PRESTERA_SDMA_TX_QUEUE_DESC_REG,
+		       prestera_sdma_map(sdma, head->desc_dma));
+
+	return 0;
+}
+
+static void prestera_sdma_tx_fini(struct prestera_sdma *sdma)
+{
+	struct prestera_tx_ring *ring = &sdma->tx_ring;
+	int bnum = PRESTERA_SDMA_TX_DESC_PER_Q;
+	int b;
+
+	cancel_work_sync(&sdma->tx_work);
+
+	if (!ring->bufs)
+		return;
+
+	for (b = 0; b < bnum; b++) {
+		struct prestera_sdma_buf *buf = &ring->bufs[b];
+
+		if (buf->desc)
+			dma_pool_free(sdma->desc_pool, buf->desc,
+				      buf->desc_dma);
+
+		if (!buf->skb)
+			continue;
+
+		dma_unmap_single(sdma->sw->dev->dev, buf->buf_dma,
+				 buf->skb->len, DMA_TO_DEVICE);
+
+		dev_consume_skb_any(buf->skb);
+	}
+}
+
+static void prestera_rxtx_handle_event(struct prestera_switch *sw,
+				       struct prestera_event *evt,
+				       void *arg)
+{
+	struct prestera_sdma *sdma = arg;
+
+	if (evt->id != PRESTERA_RXTX_EVENT_RCV_PKT)
+		return;
+
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_INTR_MASK_REG, 0);
+	napi_schedule(&sdma->rx_napi);
+}
+
+static int prestera_sdma_switch_init(struct prestera_switch *sw)
+{
+	struct prestera_sdma *sdma = &sw->rxtx->sdma;
+	struct device *dev = sw->dev->dev;
+	struct prestera_rxtx_params p;
+	int err;
+
+	p.use_sdma = true;
+
+	err = prestera_hw_rxtx_init(sw, &p);
+	if (err) {
+		dev_err(dev, "failed to init rxtx by hw\n");
+		return err;
+	}
+
+	sdma->dma_mask = dma_get_mask(dev);
+	sdma->map_addr = p.map_addr;
+	sdma->sw = sw;
+
+	sdma->desc_pool = dma_pool_create("desc_pool", dev,
+					  sizeof(struct prestera_sdma_desc),
+					  16, 0);
+	if (!sdma->desc_pool)
+		return -ENOMEM;
+
+	err = prestera_sdma_rx_init(sdma);
+	if (err) {
+		dev_err(dev, "failed to init rx ring\n");
+		goto err_rx_init;
+	}
+
+	err = prestera_sdma_tx_init(sdma);
+	if (err) {
+		dev_err(dev, "failed to init tx ring\n");
+		goto err_tx_init;
+	}
+
+	err = prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_RXTX,
+						 prestera_rxtx_handle_event,
+						 sdma);
+	if (err)
+		goto err_evt_register;
+
+	init_dummy_netdev(&sdma->napi_dev);
+
+	netif_napi_add(&sdma->napi_dev, &sdma->rx_napi, prestera_sdma_rx_poll, 64);
+	napi_enable(&sdma->rx_napi);
+
+	return 0;
+
+err_evt_register:
+err_tx_init:
+	prestera_sdma_tx_fini(sdma);
+err_rx_init:
+	prestera_sdma_rx_fini(sdma);
+
+	dma_pool_destroy(sdma->desc_pool);
+	return err;
+}
+
+static void prestera_sdma_switch_fini(struct prestera_switch *sw)
+{
+	struct prestera_sdma *sdma = &sw->rxtx->sdma;
+
+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_RXTX,
+					     prestera_rxtx_handle_event);
+	napi_disable(&sdma->rx_napi);
+	netif_napi_del(&sdma->rx_napi);
+	prestera_sdma_rx_fini(sdma);
+	prestera_sdma_tx_fini(sdma);
+	dma_pool_destroy(sdma->desc_pool);
+}
+
+static bool prestera_sdma_is_ready(struct prestera_sdma *sdma)
+{
+	return !(prestera_read(sdma->sw, PRESTERA_SDMA_TX_QUEUE_START_REG) & 1);
+}
+
+static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
+				 struct prestera_tx_ring *tx_ring)
+{
+	int tx_retry_num = 10 * tx_ring->max_burst;
+
+	while (--tx_retry_num) {
+		if (prestera_sdma_is_ready(sdma))
+			return 0;
+
+		udelay(1);
+	}
+
+	return -EBUSY;
+}
+
+static void prestera_sdma_tx_start(struct prestera_sdma *sdma)
+{
+	prestera_write(sdma->sw, PRESTERA_SDMA_TX_QUEUE_START_REG, 1);
+	schedule_work(&sdma->tx_work);
+}
+
+static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
+				      struct sk_buff *skb)
+{
+	struct device *dma_dev = sdma->sw->dev->dev;
+	struct net_device *dev = skb->dev;
+	struct prestera_tx_ring *tx_ring;
+	struct prestera_sdma_buf *buf;
+	int err;
+
+	spin_lock(&sdma->tx_lock);
+
+	tx_ring = &sdma->tx_ring;
+
+	buf = &tx_ring->bufs[tx_ring->next_tx];
+	if (buf->is_used) {
+		schedule_work(&sdma->tx_work);
+		goto drop_skb;
+	}
+
+	if (unlikely(eth_skb_pad(skb)))
+		goto drop_skb_nofree;
+
+	err = prestera_sdma_tx_buf_map(sdma, buf, skb);
+	if (err)
+		goto drop_skb;
+
+	prestera_sdma_tx_desc_set_buf(sdma, buf->desc, buf->buf_dma, skb->len);
+
+	dma_sync_single_for_device(dma_dev, buf->buf_dma, skb->len,
+				   DMA_TO_DEVICE);
+
+	if (!tx_ring->burst--) {
+		tx_ring->burst = tx_ring->max_burst;
+
+		err = prestera_sdma_tx_wait(sdma, tx_ring);
+		if (err)
+			goto drop_skb_unmap;
+	}
+
+	tx_ring->next_tx = (tx_ring->next_tx + 1) % PRESTERA_SDMA_TX_DESC_PER_Q;
+	prestera_sdma_tx_desc_xmit(buf->desc);
+	buf->is_used = true;
+
+	prestera_sdma_tx_start(sdma);
+
+	goto tx_done;
+
+drop_skb_unmap:
+	prestera_sdma_tx_buf_unmap(sdma, buf);
+drop_skb:
+	dev_consume_skb_any(skb);
+drop_skb_nofree:
+	dev->stats.tx_dropped++;
+tx_done:
+	spin_unlock(&sdma->tx_lock);
+	return NETDEV_TX_OK;
+}
+
+int prestera_rxtx_switch_init(struct prestera_switch *sw)
+{
+	struct prestera_rxtx *rxtx;
+
+	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
+	if (!rxtx)
+		return -ENOMEM;
+
+	sw->rxtx = rxtx;
+
+	return prestera_sdma_switch_init(sw);
+}
+
+void prestera_rxtx_switch_fini(struct prestera_switch *sw)
+{
+	prestera_sdma_switch_fini(sw);
+	kfree(sw->rxtx);
+}
+
+int prestera_rxtx_port_init(struct prestera_port *port)
+{
+	int err;
+
+	err = prestera_hw_rxtx_port_init(port);
+	if (err)
+		return err;
+
+	port->dev->needed_headroom = PRESTERA_DSA_HLEN + ETH_FCS_LEN;
+	return 0;
+}
+
+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
+{
+	struct prestera_dsa dsa;
+
+	dsa.hw_dev_num = port->dev_id;
+	dsa.port_num = port->hw_id;
+
+	if (skb_cow_head(skb, PRESTERA_DSA_HLEN) < 0)
+		return NET_XMIT_DROP;
+
+	skb_push(skb, PRESTERA_DSA_HLEN);
+	memmove(skb->data, skb->data + PRESTERA_DSA_HLEN, 2 * ETH_ALEN);
+
+	if (prestera_dsa_build(&dsa, skb->data + 2 * ETH_ALEN) != 0)
+		return NET_XMIT_DROP;
+
+	return prestera_sdma_xmit(&port->sw->rxtx->sdma, skb);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
new file mode 100644
index 000000000000..bbbadfa5accf
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+
+#ifndef _PRESTERA_RXTX_H_
+#define _PRESTERA_RXTX_H_
+
+#include <linux/netdevice.h>
+
+#include "prestera.h"
+
+int prestera_rxtx_switch_init(struct prestera_switch *sw);
+void prestera_rxtx_switch_fini(struct prestera_switch *sw);
+
+int prestera_rxtx_port_init(struct prestera_port *port);
+
+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
+
+#endif /* _PRESTERA_RXTX_H_ */
-- 
2.17.1

