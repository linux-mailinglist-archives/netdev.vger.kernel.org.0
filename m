Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E39D128B25
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfLUThE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:37:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35228 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfLUThA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:37:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so1662456pfo.2;
        Sat, 21 Dec 2019 11:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B8tQZZIPFBH7o841EDpYEZv9YKodWYIMP2Y+sKpNGnM=;
        b=lAWVj9RH0DlEv0jXE2I6ZBBEJOMzm+eB6jM76QRMuCIFWTSCFgnFkqMJBr9NAliLAm
         dlEU15y6RhjjGn8MZ49a42j+9Sy+VBQw1QqxkocUIJMrSm4Iy1SInHa5wj7DY43JR1Gc
         3rY+UIcqn8uGcDOeYSDHEuta7E5YWDFlDOasuRGxyETCxvt65Q0pUevGW7vq9yXxK60h
         agyrn3cZwfSasQUC+VJv1m4WERbKfE4B9Aon/2CHWA9mtksV8WBnREPaU6gHo2f1jfPw
         ZulmPgwJ+qS++Xr4H8B+M8N09bKqp/tUPIK9Ulc9V3Dk00tJkpYyRVSpSEq3HSMYh7FL
         S91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B8tQZZIPFBH7o841EDpYEZv9YKodWYIMP2Y+sKpNGnM=;
        b=phcKiiuBd1eqoUmadpbutyiXR2M9+5KAATuQvZMyj09+B97mFsqMKRmq/WUCSk+VIu
         JKWrVXEel/at3d7zevmp0j9DoRvNhIc+yAAB+ZSHF/ofjRny6TQYy1rPCzIsXfX0JhJ6
         FepF+ZOvjbB69ds5DvVtnHA7tlHuaj7HfaONa6PSp1Z/2321Pr/j/ktgy6VqP4+pq7lN
         LPrTzfaEfXoSB89Y0m4Qr/ECL15n92Y1uwm1Wl9ZvRjQEjUAVubX1Qah2vyNjDmom4d7
         jCq3IaGea9DromLdqFpmgEcA93ZI2gc8rXnzr669k0NxddxESFvGkiX9obzBciHv9gxA
         TVNg==
X-Gm-Message-State: APjAAAUq2DwERo28R4/9u7rPPO9GIrWziBdXDB2h4GG+RA8tyFZ35E5w
        A4eGfN5QN6Q29cVQ3Mj6ESfzeKRg
X-Google-Smtp-Source: APXvYqyBDSsSwWwJQX/NEsm3pAxLPCfyEHxWokJGgipo1QrJG/jxST4q868vCwGUwaU/977vr+MnsQ==
X-Received: by 2002:a63:d62:: with SMTP id 34mr23300839pgn.268.1576957018739;
        Sat, 21 Dec 2019 11:36:58 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:58 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V8 net-next 12/12] ptp: Add a driver for InES time stamping IP core.
Date:   Sat, 21 Dec 2019 11:36:38 -0800
Message-Id: <db62e2a124c24b0a36682d386b3dbc30c2882e21.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The InES at the ZHAW offers a PTP time stamping IP core.  The FPGA
logic recognizes and time stamps PTP frames on the MII bus.  This
patch adds a driver for the core along with a device tree binding to
allow hooking the driver to MII buses.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/Kconfig    |  10 +
 drivers/ptp/Makefile   |   1 +
 drivers/ptp/ptp_ines.c | 852 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 863 insertions(+)
 create mode 100644 drivers/ptp/ptp_ines.c

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index b45d2b86d8ca..e466b3586754 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -89,6 +89,16 @@ config DP83640_PHY
 	  In order for this to work, your MAC driver must also
 	  implement the skb_tx_timestamp() function.
 
+config PTP_1588_CLOCK_INES
+	tristate "ZHAW InES PTP time stamping IP core"
+	depends on NETWORK_PHY_TIMESTAMPING
+	depends on PHYLIB
+	depends on PTP_1588_CLOCK
+	help
+	  This driver adds support for using the ZHAW InES 1588 IP
+	  core.  This clock is only useful if the MII bus of your MAC
+	  is wired up to the core.
+
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
 	depends on X86_32 || COMPILE_TEST
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 69a06f86a450..3fb91bebbaf7 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -6,6 +6,7 @@
 ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
+obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
 obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
 obj-$(CONFIG_PTP_1588_CLOCK_PCH)	+= ptp_pch.o
 obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
new file mode 100644
index 000000000000..dfda54cbd866
--- /dev/null
+++ b/drivers/ptp/ptp_ines.c
@@ -0,0 +1,852 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Copyright (C) 2018 MOSER-BAER AG
+//
+
+#define pr_fmt(fmt) "InES_PTP: " fmt
+
+#include <linux/ethtool.h>
+#include <linux/export.h>
+#include <linux/if_vlan.h>
+#include <linux/mii_timestamper.h>
+#include <linux/module.h>
+#include <linux/net_tstamp.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/stddef.h>
+
+MODULE_DESCRIPTION("Driver for the ZHAW InES PTP time stamping IP core");
+MODULE_AUTHOR("Richard Cochran <richardcochran@gmail.com>");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL");
+
+/* GLOBAL register */
+#define MCAST_MAC_SELECT_SHIFT	2
+#define MCAST_MAC_SELECT_MASK	0x3
+#define IO_RESET		BIT(1)
+#define PTP_RESET		BIT(0)
+
+/* VERSION register */
+#define IF_MAJOR_VER_SHIFT	12
+#define IF_MAJOR_VER_MASK	0xf
+#define IF_MINOR_VER_SHIFT	8
+#define IF_MINOR_VER_MASK	0xf
+#define FPGA_MAJOR_VER_SHIFT	4
+#define FPGA_MAJOR_VER_MASK	0xf
+#define FPGA_MINOR_VER_SHIFT	0
+#define FPGA_MINOR_VER_MASK	0xf
+
+/* INT_STAT register */
+#define RX_INTR_STATUS_3	BIT(5)
+#define RX_INTR_STATUS_2	BIT(4)
+#define RX_INTR_STATUS_1	BIT(3)
+#define TX_INTR_STATUS_3	BIT(2)
+#define TX_INTR_STATUS_2	BIT(1)
+#define TX_INTR_STATUS_1	BIT(0)
+
+/* INT_MSK register */
+#define RX_INTR_MASK_3		BIT(5)
+#define RX_INTR_MASK_2		BIT(4)
+#define RX_INTR_MASK_1		BIT(3)
+#define TX_INTR_MASK_3		BIT(2)
+#define TX_INTR_MASK_2		BIT(1)
+#define TX_INTR_MASK_1		BIT(0)
+
+/* BUF_STAT register */
+#define RX_FIFO_NE_3		BIT(5)
+#define RX_FIFO_NE_2		BIT(4)
+#define RX_FIFO_NE_1		BIT(3)
+#define TX_FIFO_NE_3		BIT(2)
+#define TX_FIFO_NE_2		BIT(1)
+#define TX_FIFO_NE_1		BIT(0)
+
+/* PORT_CONF register */
+#define CM_ONE_STEP		BIT(6)
+#define PHY_SPEED_SHIFT		4
+#define PHY_SPEED_MASK		0x3
+#define P2P_DELAY_WR_POS_SHIFT	2
+#define P2P_DELAY_WR_POS_MASK	0x3
+#define PTP_MODE_SHIFT		0
+#define PTP_MODE_MASK		0x3
+
+/* TS_STAT_TX register */
+#define TS_ENABLE		BIT(15)
+#define DATA_READ_POS_SHIFT	8
+#define DATA_READ_POS_MASK	0x1f
+#define DISCARDED_EVENTS_SHIFT	4
+#define DISCARDED_EVENTS_MASK	0xf
+
+#define INES_N_PORTS		3
+#define INES_REGISTER_SIZE	0x80
+#define INES_PORT_OFFSET	0x20
+#define INES_PORT_SIZE		0x20
+#define INES_FIFO_DEPTH		90
+#define INES_MAX_EVENTS		100
+
+#define BC_PTP_V1		0
+#define BC_PTP_V2		1
+#define TC_E2E_PTP_V2		2
+#define TC_P2P_PTP_V2		3
+
+#define OFF_PTP_CLOCK_ID	20
+#define OFF_PTP_PORT_NUM	28
+
+#define PHY_SPEED_10		0
+#define PHY_SPEED_100		1
+#define PHY_SPEED_1000		2
+
+#define PORT_CONF \
+	((PHY_SPEED_1000 << PHY_SPEED_SHIFT) | (BC_PTP_V2 << PTP_MODE_SHIFT))
+
+#define ines_read32(s, r)	__raw_readl((void __iomem *)&s->regs->r)
+#define ines_write32(s, v, r)	__raw_writel(v, (void __iomem *)&s->regs->r)
+
+#define MESSAGE_TYPE_SYNC		1
+#define MESSAGE_TYPE_P_DELAY_REQ	2
+#define MESSAGE_TYPE_P_DELAY_RESP	3
+#define MESSAGE_TYPE_DELAY_REQ		4
+
+#define SYNC				0x0
+#define DELAY_REQ			0x1
+#define PDELAY_REQ			0x2
+#define PDELAY_RESP			0x3
+
+static LIST_HEAD(ines_clocks);
+static DEFINE_MUTEX(ines_clocks_lock);
+
+struct ines_global_regs {
+	u32 id;
+	u32 test;
+	u32 global;
+	u32 version;
+	u32 test2;
+	u32 int_stat;
+	u32 int_msk;
+	u32 buf_stat;
+};
+
+struct ines_port_registers {
+	u32 port_conf;
+	u32 p_delay;
+	u32 ts_stat_tx;
+	u32 ts_stat_rx;
+	u32 ts_tx;
+	u32 ts_rx;
+};
+
+struct ines_timestamp {
+	struct list_head list;
+	unsigned long	tmo;
+	u16		tag;
+	u64		sec;
+	u64		nsec;
+	u64		clkid;
+	u16		portnum;
+	u16		seqid;
+};
+
+struct ines_port {
+	struct ines_port_registers	*regs;
+	struct mii_timestamper		mii_ts;
+	struct ines_clock		*clock;
+	bool				rxts_enabled;
+	bool				txts_enabled;
+	unsigned int			index;
+	struct delayed_work		ts_work;
+	/* lock protects event list and tx_skb */
+	spinlock_t			lock;
+	struct sk_buff			*tx_skb;
+	struct list_head		events;
+	struct list_head		pool;
+	struct ines_timestamp		pool_data[INES_MAX_EVENTS];
+};
+
+struct ines_clock {
+	struct ines_port		port[INES_N_PORTS];
+	struct ines_global_regs __iomem	*regs;
+	void __iomem			*base;
+	struct device_node		*node;
+	struct device			*dev;
+	struct list_head		list;
+};
+
+static bool ines_match(struct sk_buff *skb, unsigned int ptp_class,
+		       struct ines_timestamp *ts, struct device *dev);
+static int ines_rxfifo_read(struct ines_port *port);
+static u64 ines_rxts64(struct ines_port *port, unsigned int words);
+static bool ines_timestamp_expired(struct ines_timestamp *ts);
+static u64 ines_txts64(struct ines_port *port, unsigned int words);
+static void ines_txtstamp_work(struct work_struct *work);
+static bool is_sync_pdelay_resp(struct sk_buff *skb, int type);
+static u8 tag_to_msgtype(u8 tag);
+
+static void ines_clock_cleanup(struct ines_clock *clock)
+{
+	struct ines_port *port;
+	int i;
+
+	for (i = 0; i < INES_N_PORTS; i++) {
+		port = &clock->port[i];
+		cancel_delayed_work_sync(&port->ts_work);
+	}
+}
+
+static int ines_clock_init(struct ines_clock *clock, struct device *device,
+			   void __iomem *addr)
+{
+	struct device_node *node = device->of_node;
+	unsigned long port_addr;
+	struct ines_port *port;
+	int i, j;
+
+	INIT_LIST_HEAD(&clock->list);
+	clock->node = node;
+	clock->dev  = device;
+	clock->base = addr;
+	clock->regs = clock->base;
+
+	for (i = 0; i < INES_N_PORTS; i++) {
+		port = &clock->port[i];
+		port_addr = (unsigned long) clock->base +
+			INES_PORT_OFFSET + i * INES_PORT_SIZE;
+		port->regs = (struct ines_port_registers *) port_addr;
+		port->clock = clock;
+		port->index = i;
+		INIT_DELAYED_WORK(&port->ts_work, ines_txtstamp_work);
+		spin_lock_init(&port->lock);
+		INIT_LIST_HEAD(&port->events);
+		INIT_LIST_HEAD(&port->pool);
+		for (j = 0; j < INES_MAX_EVENTS; j++)
+			list_add(&port->pool_data[j].list, &port->pool);
+	}
+
+	ines_write32(clock, 0xBEEF, test);
+	ines_write32(clock, 0xBEEF, test2);
+
+	dev_dbg(device, "ID      0x%x\n", ines_read32(clock, id));
+	dev_dbg(device, "TEST    0x%x\n", ines_read32(clock, test));
+	dev_dbg(device, "VERSION 0x%x\n", ines_read32(clock, version));
+	dev_dbg(device, "TEST2   0x%x\n", ines_read32(clock, test2));
+
+	for (i = 0; i < INES_N_PORTS; i++) {
+		port = &clock->port[i];
+		ines_write32(port, PORT_CONF, port_conf);
+	}
+
+	return 0;
+}
+
+static struct ines_port *ines_find_port(struct device_node *node, u32 index)
+{
+	struct ines_port *port = NULL;
+	struct ines_clock *clock;
+	struct list_head *this;
+
+	mutex_lock(&ines_clocks_lock);
+	list_for_each(this, &ines_clocks) {
+		clock = list_entry(this, struct ines_clock, list);
+		if (clock->node == node) {
+			port = &clock->port[index];
+			break;
+		}
+	}
+	mutex_unlock(&ines_clocks_lock);
+	return port;
+}
+
+static u64 ines_find_rxts(struct ines_port *port, struct sk_buff *skb, int type)
+{
+	struct list_head *this, *next;
+	struct ines_timestamp *ts;
+	unsigned long flags;
+	u64 ns = 0;
+
+	if (type == PTP_CLASS_NONE)
+		return 0;
+
+	spin_lock_irqsave(&port->lock, flags);
+	ines_rxfifo_read(port);
+	list_for_each_safe(this, next, &port->events) {
+		ts = list_entry(this, struct ines_timestamp, list);
+		if (ines_timestamp_expired(ts)) {
+			list_del_init(&ts->list);
+			list_add(&ts->list, &port->pool);
+			continue;
+		}
+		if (ines_match(skb, type, ts, port->clock->dev)) {
+			ns = ts->sec * 1000000000ULL + ts->nsec;
+			list_del_init(&ts->list);
+			list_add(&ts->list, &port->pool);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return ns;
+}
+
+static u64 ines_find_txts(struct ines_port *port, struct sk_buff *skb)
+{
+	unsigned int class = ptp_classify_raw(skb), i;
+	u32 data_rd_pos, buf_stat, mask, ts_stat_tx;
+	struct ines_timestamp ts;
+	unsigned long flags;
+	u64 ns = 0;
+
+	mask = TX_FIFO_NE_1 << port->index;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	for (i = 0; i < INES_FIFO_DEPTH; i++) {
+
+		buf_stat = ines_read32(port->clock, buf_stat);
+		if (!(buf_stat & mask)) {
+			dev_dbg(port->clock->dev,
+				  "Tx timestamp FIFO unexpectedly empty\n");
+			break;
+		}
+		ts_stat_tx = ines_read32(port, ts_stat_tx);
+		data_rd_pos = (ts_stat_tx >> DATA_READ_POS_SHIFT) &
+			DATA_READ_POS_MASK;
+		if (data_rd_pos) {
+			dev_err(port->clock->dev,
+				"unexpected Tx read pos %u\n", data_rd_pos);
+			break;
+		}
+
+		ts.tag     = ines_read32(port, ts_tx);
+		ts.sec     = ines_txts64(port, 3);
+		ts.nsec    = ines_txts64(port, 2);
+		ts.clkid   = ines_txts64(port, 4);
+		ts.portnum = ines_read32(port, ts_tx);
+		ts.seqid   = ines_read32(port, ts_tx);
+
+		if (ines_match(skb, class, &ts, port->clock->dev)) {
+			ns = ts.sec * 1000000000ULL + ts.nsec;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&port->lock, flags);
+	return ns;
+}
+
+static int ines_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
+{
+	struct ines_port *port = container_of(mii_ts, struct ines_port, mii_ts);
+	u32 cm_one_step = 0, port_conf, ts_stat_rx, ts_stat_tx;
+	struct hwtstamp_config cfg;
+	unsigned long flags;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	/* reserved for future extensions */
+	if (cfg.flags)
+		return -EINVAL;
+
+	switch (cfg.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		ts_stat_tx = 0;
+		break;
+	case HWTSTAMP_TX_ON:
+		ts_stat_tx = TS_ENABLE;
+		break;
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		ts_stat_tx = TS_ENABLE;
+		cm_one_step = CM_ONE_STEP;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		ts_stat_rx = 0;
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		return -ERANGE;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		ts_stat_rx = TS_ENABLE;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	port_conf = ines_read32(port, port_conf);
+	port_conf &= ~CM_ONE_STEP;
+	port_conf |= cm_one_step;
+
+	ines_write32(port, port_conf, port_conf);
+	ines_write32(port, ts_stat_rx, ts_stat_rx);
+	ines_write32(port, ts_stat_tx, ts_stat_tx);
+
+	port->rxts_enabled = ts_stat_rx == TS_ENABLE ? true : false;
+	port->txts_enabled = ts_stat_tx == TS_ENABLE ? true : false;
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static void ines_link_state(struct mii_timestamper *mii_ts,
+			    struct phy_device *phydev)
+{
+	struct ines_port *port = container_of(mii_ts, struct ines_port, mii_ts);
+	u32 port_conf, speed_conf;
+	unsigned long flags;
+
+	switch (phydev->speed) {
+	case SPEED_10:
+		speed_conf = PHY_SPEED_10 << PHY_SPEED_SHIFT;
+		break;
+	case SPEED_100:
+		speed_conf = PHY_SPEED_100 << PHY_SPEED_SHIFT;
+		break;
+	case SPEED_1000:
+		speed_conf = PHY_SPEED_1000 << PHY_SPEED_SHIFT;
+		break;
+	default:
+		dev_err(port->clock->dev, "bad speed: %d\n", phydev->speed);
+		return;
+	}
+	spin_lock_irqsave(&port->lock, flags);
+
+	port_conf = ines_read32(port, port_conf);
+	port_conf &= ~(0x3 << PHY_SPEED_SHIFT);
+	port_conf |= speed_conf;
+
+	ines_write32(port, port_conf, port_conf);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static bool ines_match(struct sk_buff *skb, unsigned int ptp_class,
+		       struct ines_timestamp *ts, struct device *dev)
+{
+	u8 *msgtype, *data = skb_mac_header(skb);
+	unsigned int offset = 0;
+	__be16 *portn, *seqid;
+	__be64 *clkid;
+
+	if (unlikely(ptp_class & PTP_CLASS_V1))
+		return false;
+
+	if (ptp_class & PTP_CLASS_VLAN)
+		offset += VLAN_HLEN;
+
+	switch (ptp_class & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
+		break;
+	case PTP_CLASS_IPV6:
+		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
+		break;
+	case PTP_CLASS_L2:
+		offset += ETH_HLEN;
+		break;
+	default:
+		return false;
+	}
+
+	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
+		return false;
+
+	msgtype = data + offset;
+	clkid = (__be64 *)(data + offset + OFF_PTP_CLOCK_ID);
+	portn = (__be16 *)(data + offset + OFF_PTP_PORT_NUM);
+	seqid = (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+
+	if (tag_to_msgtype(ts->tag & 0x7) != (*msgtype & 0xf)) {
+		dev_dbg(dev, "msgtype mismatch ts %hhu != skb %hhu\n",
+			  tag_to_msgtype(ts->tag & 0x7), *msgtype & 0xf);
+		return false;
+	}
+	if (cpu_to_be64(ts->clkid) != *clkid) {
+		dev_dbg(dev, "clkid mismatch ts %llx != skb %llx\n",
+			  cpu_to_be64(ts->clkid), *clkid);
+		return false;
+	}
+	if (ts->portnum != ntohs(*portn)) {
+		dev_dbg(dev, "portn mismatch ts %hu != skb %hu\n",
+			  ts->portnum, ntohs(*portn));
+		return false;
+	}
+	if (ts->seqid != ntohs(*seqid)) {
+		dev_dbg(dev, "seqid mismatch ts %hu != skb %hu\n",
+			  ts->seqid, ntohs(*seqid));
+		return false;
+	}
+
+	return true;
+}
+
+static bool ines_rxtstamp(struct mii_timestamper *mii_ts,
+			  struct sk_buff *skb, int type)
+{
+	struct ines_port *port = container_of(mii_ts, struct ines_port, mii_ts);
+	struct skb_shared_hwtstamps *ssh;
+	u64 ns;
+
+	if (!port->rxts_enabled)
+		return false;
+
+	ns = ines_find_rxts(port, skb, type);
+	if (!ns)
+		return false;
+
+	ssh = skb_hwtstamps(skb);
+	ssh->hwtstamp = ns_to_ktime(ns);
+	netif_rx(skb);
+
+	return true;
+}
+
+static int ines_rxfifo_read(struct ines_port *port)
+{
+	u32 data_rd_pos, buf_stat, mask, ts_stat_rx;
+	struct ines_timestamp *ts;
+	unsigned int i;
+
+	mask = RX_FIFO_NE_1 << port->index;
+
+	for (i = 0; i < INES_FIFO_DEPTH; i++) {
+		if (list_empty(&port->pool)) {
+			dev_err(port->clock->dev, "event pool is empty\n");
+			return -1;
+		}
+		buf_stat = ines_read32(port->clock, buf_stat);
+		if (!(buf_stat & mask))
+			break;
+
+		ts_stat_rx = ines_read32(port, ts_stat_rx);
+		data_rd_pos = (ts_stat_rx >> DATA_READ_POS_SHIFT) &
+			DATA_READ_POS_MASK;
+		if (data_rd_pos) {
+			dev_err(port->clock->dev, "unexpected Rx read pos %u\n",
+				data_rd_pos);
+			break;
+		}
+
+		ts = list_first_entry(&port->pool, struct ines_timestamp, list);
+		ts->tmo     = jiffies + HZ;
+		ts->tag     = ines_read32(port, ts_rx);
+		ts->sec     = ines_rxts64(port, 3);
+		ts->nsec    = ines_rxts64(port, 2);
+		ts->clkid   = ines_rxts64(port, 4);
+		ts->portnum = ines_read32(port, ts_rx);
+		ts->seqid   = ines_read32(port, ts_rx);
+
+		list_del_init(&ts->list);
+		list_add_tail(&ts->list, &port->events);
+	}
+
+	return 0;
+}
+
+static u64 ines_rxts64(struct ines_port *port, unsigned int words)
+{
+	unsigned int i;
+	u64 result;
+	u16 word;
+
+	word = ines_read32(port, ts_rx);
+	result = word;
+	words--;
+	for (i = 0; i < words; i++) {
+		word = ines_read32(port, ts_rx);
+		result <<= 16;
+		result |= word;
+	}
+	return result;
+}
+
+static bool ines_timestamp_expired(struct ines_timestamp *ts)
+{
+	return time_after(jiffies, ts->tmo);
+}
+
+static int ines_ts_info(struct mii_timestamper *mii_ts,
+			struct ethtool_ts_info *info)
+{
+	info->so_timestamping =
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_TX_SOFTWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RX_SOFTWARE |
+		SOF_TIMESTAMPING_SOFTWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->phc_index = -1;
+
+	info->tx_types =
+		(1 << HWTSTAMP_TX_OFF) |
+		(1 << HWTSTAMP_TX_ON) |
+		(1 << HWTSTAMP_TX_ONESTEP_P2P);
+
+	info->rx_filters =
+		(1 << HWTSTAMP_FILTER_NONE) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
+static u64 ines_txts64(struct ines_port *port, unsigned int words)
+{
+	unsigned int i;
+	u64 result;
+	u16 word;
+
+	word = ines_read32(port, ts_tx);
+	result = word;
+	words--;
+	for (i = 0; i < words; i++) {
+		word = ines_read32(port, ts_tx);
+		result <<= 16;
+		result |= word;
+	}
+	return result;
+}
+
+static bool ines_txts_onestep(struct ines_port *port, struct sk_buff *skb, int type)
+{
+	unsigned long flags;
+	u32 port_conf;
+
+	spin_lock_irqsave(&port->lock, flags);
+	port_conf = ines_read32(port, port_conf);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (port_conf & CM_ONE_STEP)
+		return is_sync_pdelay_resp(skb, type);
+
+	return false;
+}
+
+static void ines_txtstamp(struct mii_timestamper *mii_ts,
+			  struct sk_buff *skb, int type)
+{
+	struct ines_port *port = container_of(mii_ts, struct ines_port, mii_ts);
+	struct sk_buff *old_skb = NULL;
+	unsigned long flags;
+
+	if (!port->txts_enabled || ines_txts_onestep(port, skb, type)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (port->tx_skb)
+		old_skb = port->tx_skb;
+
+	port->tx_skb = skb;
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (old_skb)
+		kfree_skb(old_skb);
+
+	schedule_delayed_work(&port->ts_work, 1);
+}
+
+static void ines_txtstamp_work(struct work_struct *work)
+{
+	struct ines_port *port =
+		container_of(work, struct ines_port, ts_work.work);
+	struct skb_shared_hwtstamps ssh;
+	struct sk_buff *skb;
+	unsigned long flags;
+	u64 ns;
+
+	spin_lock_irqsave(&port->lock, flags);
+	skb = port->tx_skb;
+	port->tx_skb = NULL;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	ns = ines_find_txts(port, skb);
+	if (!ns) {
+		kfree_skb(skb);
+		return;
+	}
+	ssh.hwtstamp = ns_to_ktime(ns);
+	skb_complete_tx_timestamp(skb, &ssh);
+}
+
+static bool is_sync_pdelay_resp(struct sk_buff *skb, int type)
+{
+	u8 *data = skb->data, *msgtype;
+	unsigned int offset = 0;
+
+	if (type & PTP_CLASS_VLAN)
+		offset += VLAN_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
+		break;
+	case PTP_CLASS_IPV6:
+		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
+		break;
+	case PTP_CLASS_L2:
+		offset += ETH_HLEN;
+		break;
+	default:
+		return 0;
+	}
+
+	if (type & PTP_CLASS_V1)
+		offset += OFF_PTP_CONTROL;
+
+	if (skb->len < offset + 1)
+		return 0;
+
+	msgtype = data + offset;
+
+	switch ((*msgtype & 0xf)) {
+	case SYNC:
+	case PDELAY_RESP:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static u8 tag_to_msgtype(u8 tag)
+{
+	switch (tag) {
+	case MESSAGE_TYPE_SYNC:
+		return SYNC;
+	case MESSAGE_TYPE_P_DELAY_REQ:
+		return PDELAY_REQ;
+	case MESSAGE_TYPE_P_DELAY_RESP:
+		return PDELAY_RESP;
+	case MESSAGE_TYPE_DELAY_REQ:
+		return DELAY_REQ;
+	}
+	return 0xf;
+}
+
+static struct mii_timestamper *ines_ptp_probe_channel(struct device *device,
+						      unsigned int index)
+{
+	struct device_node *node = device->of_node;
+	struct ines_port *port;
+
+	if (index > INES_N_PORTS - 1) {
+		dev_err(device, "bad port index %u\n", index);
+		return ERR_PTR(-EINVAL);
+	}
+	port = ines_find_port(node, index);
+	if (!port) {
+		dev_err(device, "missing port index %u\n", index);
+		return ERR_PTR(-ENODEV);
+	}
+	port->mii_ts.rxtstamp = ines_rxtstamp;
+	port->mii_ts.txtstamp = ines_txtstamp;
+	port->mii_ts.hwtstamp = ines_hwtstamp;
+	port->mii_ts.link_state = ines_link_state;
+	port->mii_ts.ts_info = ines_ts_info;
+
+	return &port->mii_ts;
+}
+
+static void ines_ptp_release_channel(struct device *device,
+				     struct mii_timestamper *mii_ts)
+{
+}
+
+static struct mii_timestamping_ctrl ines_ctrl = {
+	.probe_channel = ines_ptp_probe_channel,
+	.release_channel = ines_ptp_release_channel,
+};
+
+static int ines_ptp_ctrl_probe(struct platform_device *pld)
+{
+	struct ines_clock *clock;
+	struct resource *res;
+	void __iomem *addr;
+	int err = 0;
+
+	res = platform_get_resource(pld, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pld->dev, "missing memory resource\n");
+		return -EINVAL;
+	}
+	addr = devm_ioremap_resource(&pld->dev, res);
+	if (IS_ERR(addr)) {
+		err = PTR_ERR(addr);
+		goto out;
+	}
+	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
+	if (!clock) {
+		err = -ENOMEM;
+		goto out;
+	}
+	if (ines_clock_init(clock, &pld->dev, addr)) {
+		kfree(clock);
+		err = -ENOMEM;
+		goto out;
+	}
+	err = register_mii_tstamp_controller(&pld->dev, &ines_ctrl);
+	if (err) {
+		kfree(clock);
+		goto out;
+	}
+	mutex_lock(&ines_clocks_lock);
+	list_add_tail(&ines_clocks, &clock->list);
+	mutex_unlock(&ines_clocks_lock);
+
+	dev_set_drvdata(&pld->dev, clock);
+out:
+	return err;
+}
+
+static int ines_ptp_ctrl_remove(struct platform_device *pld)
+{
+	struct ines_clock *clock = dev_get_drvdata(&pld->dev);
+
+	unregister_mii_tstamp_controller(&pld->dev);
+	mutex_lock(&ines_clocks_lock);
+	list_del(&clock->list);
+	mutex_unlock(&ines_clocks_lock);
+	ines_clock_cleanup(clock);
+	kfree(clock);
+	return 0;
+}
+
+static const struct of_device_id ines_ptp_ctrl_of_match[] = {
+	{ .compatible = "ines,ptp-ctrl" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, ines_ptp_ctrl_of_match);
+
+static struct platform_driver ines_ptp_ctrl_driver = {
+	.probe  = ines_ptp_ctrl_probe,
+	.remove = ines_ptp_ctrl_remove,
+	.driver = {
+		.name = "ines_ptp_ctrl",
+		.of_match_table = of_match_ptr(ines_ptp_ctrl_of_match),
+	},
+};
+module_platform_driver(ines_ptp_ctrl_driver);
-- 
2.20.1

