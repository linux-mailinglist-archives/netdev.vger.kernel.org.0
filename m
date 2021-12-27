Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35447FBB8
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 11:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhL0KDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 05:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbhL0KDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 05:03:11 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4097DC061759;
        Mon, 27 Dec 2021 02:03:11 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id j13so11100144plx.4;
        Mon, 27 Dec 2021 02:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WypO7xklaXmLsvwFW0M0BUAgX2yPt0gDJLRMl7/On6w=;
        b=C9smzMl2MNa5PVdsiLrj5/OWCqGSydVgrXjKfk1KTxfssQ/newaOw5JMBoN4HtBs8/
         TeHtDFjSAt0WtKrv7bVvdf0I8hDNHP8G//jSQlGX2AUbxQQThZJVa4jFTqvvh9znfVRE
         cst6c+e02ght4m434bP07nbTXFpi44AWemHsQu0Vtygn4xv1LhiysDJjYcupTaU0UasE
         rDGCEbID3DfQ86Ie9SHWdjzLpCPhYca+vZqLxOrSZc0ldLgoLSS85OxmBX8LfWWmmzvC
         9437xSnoiEbPU/oeyIGsYENlwOzctlir3nzhjbk9NY7c7NioXmH0EZTVfSd7ILdSAGGu
         RGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WypO7xklaXmLsvwFW0M0BUAgX2yPt0gDJLRMl7/On6w=;
        b=IKFVnuUJo/AWvQ9Fttvaxqro44iy7VhNitnlLcV7x+V2N7WU+DaxYX1h3+E8rSwgS9
         7pHXBezja4RgblHmFWUZprku2bajTve1jXZKHnPBOJ0tBLgaoJOyucHQMEvAm8HNG2oU
         Bse5N/Wow2Ovywx8FSr/cWd8rPncfVZ4TfwnnpErEbc/Cbmc1M65yg79brNqwmuaOW0H
         GALeUBvv7RYoVSgHh7GBwHzXvl1U2WzDPygw9e37MyhyOO2taNHdFf/+P8wywfoxRSC2
         wKgDR4zXXD6gmSZ9T7ZxDdf6GZywMHI1VvqoaGjhwo0/WaT2YxCUkdTWhNYqVyWFae2+
         EzRg==
X-Gm-Message-State: AOAM532KU5IRGb9RSq9iTcT8SIDaPxHZw1YDicMPpjmO20Y7kUbt+gFI
        Rny9PIFuxNoJ0V6uHkPY69w=
X-Google-Smtp-Source: ABdhPJxGhXaNNKFOs8ITy7KAx8AqSKvKxaeii/VVcBfX4MmaiScELtHVIUECfKS4rYyU/L0KJ6870A==
X-Received: by 2002:a17:903:228b:b0:149:4f86:c7ee with SMTP id b11-20020a170903228b00b001494f86c7eemr16491714plh.80.1640599390426;
        Mon, 27 Dec 2021 02:03:10 -0800 (PST)
Received: from localhost.localdomain (61-231-124-66.dynamic-ip.hinet.net. [61.231.124.66])
        by smtp.gmail.com with ESMTPSA id k6sm17533671pff.106.2021.12.27.02.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 02:03:10 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH v9, 2/2] net: Add dm9051 driver
Date:   Mon, 27 Dec 2021 18:02:33 +0800
Message-Id: <20211227100233.8037-3-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211227100233.8037-1-josright123@gmail.com>
References: <20211227100233.8037-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1-v4

Add davicom dm9051 spi ethernet driver. The driver work for the
device platform with spi master

Test ok with raspberry pi 2 and pi 4, the spi configure used in
my raspberry pi 4 is spi0.1, spi speed 31200000, and INT by pin 26.

v5

Work to eliminate the wrappers to be clear for read, swapped to
phylib for phy connection tasks.

Tested with raspberry pi 4. Test for netwroking function, CAT5
cable unplug/plug and also ethtool detect for link state, and
all are ok.

v6

remove the redundant code that phylib has support,
adjust to be the reasonable sequence,
fine tune comments, add comments for pause function support

Tested with raspberry pi 4. Test for netwroking function, CAT5
cable unplug/plug and also ethtool detect for link state, and
all are ok.

v7

read/write registers must return error code to the callet,
add to enable pause processing

v8

not parmanently set MAC by .ndo_set_mac_address

correct rx function such as clear ISR,
inblk avoid stack buffer,
simple skb buffer process and
easy use netif_rx_ni.

simplely queue init and wake the queues,
limit the start_xmit function use netif_stop_queue.

descript that schedule delay is essential
for tx_work and rxctrl_work

eliminate ____cacheline_aligned and
add static int msg_enable.

v9

use phylib, no need 'select MII' in Kconfig,
make it clear in dm9051_xfer when using spi_sync,
improve the registers read/write so that error code
return as far as possible up the call stack.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Joseph CHAMG <josright123@gmail.com>
---
 drivers/net/ethernet/davicom/Kconfig  |   29 +
 drivers/net/ethernet/davicom/Makefile |    1 +
 drivers/net/ethernet/davicom/dm9051.c | 1019 +++++++++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h |  189 +++++
 4 files changed, 1238 insertions(+)
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h

diff --git a/drivers/net/ethernet/davicom/Kconfig b/drivers/net/ethernet/davicom/Kconfig
index 7af86b6d4150..887fe6e56d56 100644
--- a/drivers/net/ethernet/davicom/Kconfig
+++ b/drivers/net/ethernet/davicom/Kconfig
@@ -3,6 +3,19 @@
 # Davicom device configuration
 #
 
+config NET_VENDOR_DAVICOM
+	bool "Davicom devices"
+	default y
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Davicom devices. If you say Y, you will be asked
+	  for your specific card in the following selections.
+
+if NET_VENDOR_DAVICOM
+
 config DM9000
 	tristate "DM9000 support"
 	depends on ARM || MIPS || COLDFIRE || NIOS2 || COMPILE_TEST
@@ -22,3 +35,19 @@ config DM9000_FORCE_SIMPLE_PHY_POLL
 	  bit to determine if the link is up or down instead of the more
 	  costly MII PHY reads. Note, this will not work if the chip is
 	  operating with an external PHY.
+
+config DM9051
+	tristate "DM9051 SPI support"
+	select PHYLIB
+	depends on SPI
+	select CRC32
+	help
+	  Support for DM9051 SPI chipset.
+
+	  To compile this driver as a module, choose M here.  The module
+	  will be called dm9051.
+
+	  The SPI mode for the host's SPI master to access DM9051 is mode
+	  0 on the SPI bus.
+
+endif # NET_VENDOR_DAVICOM
diff --git a/drivers/net/ethernet/davicom/Makefile b/drivers/net/ethernet/davicom/Makefile
index 173c87d21076..225f85bc1f53 100644
--- a/drivers/net/ethernet/davicom/Makefile
+++ b/drivers/net/ethernet/davicom/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_DM9000) += dm9000.o
+obj-$(CONFIG_DM9051) += dm9051.o
diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
new file mode 100644
index 000000000000..599e2b0f4696
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -0,0 +1,1019 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 Davicom Semiconductor,Inc.
+ * Davicom DM9051 SPI Fast Ethernet Linux driver
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/interrupt.h>
+#include <linux/phy.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/cache.h>
+#include <linux/crc32.h>
+#include <linux/mii.h>
+#include <linux/ethtool.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/iopoll.h>
+#include <linux/of_gpio.h>
+#include <linux/spi/spi.h>
+
+#include "dm9051.h"
+
+#define	dm9051_inb(db, reg, prxb)	dm9051_xfer(db, DM_SPI_RD | (reg), NULL, prxb, 1)
+#define	dm9051_outb(db, reg, ptxb)	dm9051_xfer(db, DM_SPI_WR | (reg), ptxb, NULL, 1)
+#define	dm9051_inblk(db, buff, len)	dm9051_xfer(db, DM_SPI_RD | DM_SPI_MRCMD, NULL, buff, len)
+#define	dm9051_outblk(db, buff, len)	dm9051_xfer(db, DM_SPI_WR | DM_SPI_MWCMD, buff, NULL, len)
+
+/* spi low level code */
+static int dm9051_xfer(struct board_info *db, u8 cmd, u8 *txb, u8 *rxb, unsigned int len)
+{
+	struct device *dev = &db->spidev->dev;
+	int ret;
+
+	db->cmd[0] = cmd;
+	db->spi_xfer2[0].tx_buf = &db->cmd[0];
+	db->spi_xfer2[0].rx_buf = NULL;
+	db->spi_xfer2[0].len = 1;
+	db->spi_xfer2[1].tx_buf = txb;
+	db->spi_xfer2[1].rx_buf = rxb;
+	db->spi_xfer2[1].len = len;
+	ret = spi_sync(db->spidev, &db->spi_msg);
+	if (ret < 0)
+		dev_err(dev, "spi burst cmd 0x%02x, ret=%d\n", cmd, ret);
+	return ret;
+}
+
+static u8 dm9051_getreg(struct board_info *db, unsigned int reg)
+{
+	int ret;
+	u8 rxb[1];
+
+	ret = dm9051_inb(db, reg, rxb);
+	if (ret < 0) {
+		if (reg == DM9051_NSR)
+			return NSR_TX2END | NSR_TX1END;
+		if (reg == DM9051_EPCR)
+			return (u8)(~EPCR_ERRE);
+		return 0;
+	}
+	return rxb[0];
+}
+
+static int dm9051_ior(struct board_info *db, unsigned int reg, u8 *prxb)
+{
+	return dm9051_inb(db, reg, prxb);
+}
+
+static int dm9051_iow(struct board_info *db, unsigned int reg, unsigned int val)
+{
+	u8 txb = val;
+
+	return dm9051_outb(db, reg, &txb);
+}
+
+static int dm9051_dumpblk(struct board_info *db, unsigned int len)
+{
+	int ret;
+	u8 rxb[1];
+
+	while (len--) {
+		ret = dm9051_inb(db, DM_SPI_MRCMD, rxb);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+
+static int dm9051_phy_read(struct board_info *db, int reg, int *pvalue)
+{
+	int ret;
+	u8 check_val;
+	u8 eph, epl;
+
+	dm9051_iow(db, DM9051_EPAR, DM9051_PHY | reg);
+	dm9051_iow(db, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
+	ret = read_poll_timeout(dm9051_getreg, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+				true, db, DM9051_EPCR);
+	if (ret) {
+		netdev_err(db->ndev, "timeout read phy register\n");
+		return ret;
+	}
+	dm9051_iow(db, DM9051_EPCR, 0x0);
+	dm9051_ior(db, DM9051_EPDRH, &eph);
+	dm9051_ior(db, DM9051_EPDRL, &epl);
+	*pvalue = (eph << 8) | epl;
+	return ret;
+}
+
+static int dm9051_phy_write(struct board_info *db, int reg, int value)
+{
+	int ret;
+	u8 check_val;
+
+	dm9051_iow(db, DM9051_EPAR, DM9051_PHY | reg);
+	dm9051_iow(db, DM9051_EPDRL, value);
+	dm9051_iow(db, DM9051_EPDRH, value >> 8);
+	dm9051_iow(db, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
+	ret = read_poll_timeout(dm9051_getreg, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+				true, db, DM9051_EPCR);
+	if (ret) {
+		netdev_err(db->ndev, "timeout write phy register\n");
+		return ret;
+	}
+	dm9051_iow(db, DM9051_EPCR, 0x0);
+
+	if (reg == MII_BMCR && !(value & 0x0800))
+		mdelay(1); /* need for if activate phyxcer */
+
+	return ret;
+}
+
+/* Read a word data from SROM
+ */
+static int dm9051_read_eeprom(struct board_info *db, int offset, u8 *to)
+{
+	int ret;
+	u8 check_val;
+
+	dm9051_iow(db, DM9051_EPAR, offset);
+	dm9051_iow(db, DM9051_EPCR, EPCR_ERPRR);
+	ret = read_poll_timeout(dm9051_getreg, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+				true, db, DM9051_EPCR);
+	if (ret) {
+		netdev_err(db->ndev, "timeout read eeprom\n");
+		return ret;
+	}
+	dm9051_iow(db, DM9051_EPCR, 0x0);
+	dm9051_ior(db, DM9051_EPDRL, &to[0]);
+	dm9051_ior(db, DM9051_EPDRH, &to[1]);
+	return 0;
+}
+
+/* Write a word data to SROM
+ */
+static int dm9051_write_eeprom(struct board_info *db, int offset, u8 *data)
+{
+	int ret;
+	u8 check_val;
+
+	dm9051_iow(db, DM9051_EPAR, offset);
+	dm9051_iow(db, DM9051_EPDRH, data[1]);
+	dm9051_iow(db, DM9051_EPDRL, data[0]);
+	dm9051_iow(db, DM9051_EPCR, EPCR_WEP | EPCR_ERPRW);
+	ret = read_poll_timeout(dm9051_getreg, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+				true, db, DM9051_EPCR);
+	if (ret) {
+		netdev_err(db->ndev, "timeout write eeprom\n");
+		return ret;
+	}
+	dm9051_iow(db, DM9051_EPCR, 0);
+	return ret;
+}
+
+static int dm9051_mdio_read(struct mii_bus *mdiobus, int phy_id, int reg)
+{
+	struct board_info *db = mdiobus->priv;
+	int val, ret;
+
+	if (phy_id == DM9051_PHY_ID) {
+		mutex_lock(&db->addr_lock);
+		ret = dm9051_phy_read(db, reg, &val);
+		mutex_unlock(&db->addr_lock);
+		if (ret)
+			return ret;
+		return val;
+	}
+
+	return 0xffff;
+}
+
+static int dm9051_mdio_write(struct mii_bus *mdiobus, int phy_id, int reg, u16 val)
+{
+	struct board_info *db = mdiobus->priv;
+	int ret;
+
+	if (phy_id == DM9051_PHY_ID) {
+		mutex_lock(&db->addr_lock);
+		ret = dm9051_phy_write(db, reg, val);
+		mutex_unlock(&db->addr_lock);
+		if (ret)
+			return ret;
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+static unsigned int dm9051_chipid(struct board_info *db)
+{
+	struct device *dev = &db->spidev->dev;
+	u8 pidh, pidl;
+	u16 id;
+
+	dm9051_ior(db, DM9051_PIDH, &pidh);
+	dm9051_ior(db, DM9051_PIDL, &pidl);
+	id = (pidh << 8) | pidl;
+
+	if (id == DM9051_ID) {
+		dev_info(dev, "chip %04x found !\n", id);
+		return id;
+	}
+
+	dev_info(dev, "chipid error as %04x !\n", id);
+	return id;
+}
+
+static void dm9051_reset(struct board_info *db)
+{
+	mdelay(2); /* need before NCR_RST */
+	dm9051_iow(db, DM9051_NCR, NCR_RST); /* NCR reset */
+	mdelay(1);
+	dm9051_iow(db, DM9051_MBNDRY, MBNDRY_BYTE); /* MemBound */
+	mdelay(1);
+}
+
+static void dm9051_reset_control(struct board_info *db)
+{
+	db->bc.DO_FIFO_RST_counter++;
+
+	dm9051_iow(db, DM9051_PPCR, PPCR_PAUSE_COUNT); /* Pause Pkt Count */
+	dm9051_iow(db, DM9051_LMCR, db->lcr_all); /* LEDMode1 */
+	dm9051_iow(db, DM9051_INTCR, INTCR_POL_LOW); /* INTCR */
+}
+
+static void dm9051_handle_link_change(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	int lcl_adv, rmt_adv;
+	u8 nfcr, fcr = 0;
+
+	phy_print_status(ndev->phydev);
+
+	/* only write pause settings to mac. since mac and phy are integrated
+	 * together, such as link state, speed and duplex are sync already
+	 */
+	if (ndev->phydev->link) {
+		if (db->eth_pause.autoneg == AUTONEG_ENABLE) {
+			lcl_adv = linkmode_adv_to_mii_adv_t(db->phydev->advertising);
+			rmt_adv = linkmode_adv_to_mii_adv_t(db->phydev->lp_advertising);
+
+			if (lcl_adv & rmt_adv & ADVERTISE_PAUSE_CAP) {
+				db->eth_pause.rx_pause = true;
+				db->eth_pause.tx_pause = true;
+			}
+		}
+
+		/* while both rx_pause & tx_pause, fcr will result as FCR_RXTX_ENABLE; */
+		if (db->eth_pause.rx_pause)
+			fcr |= FCR_BKPM | FCR_FLCE;
+		if (db->eth_pause.tx_pause)
+			fcr |= FCR_TXPEN;
+
+		/* to change if get new fcr */
+		mutex_lock(&db->addr_lock);
+		dm9051_ior(db, DM9051_FCR, &nfcr);
+		if (nfcr != fcr)
+			dm9051_iow(db, DM9051_FCR, fcr); /* on link change */
+		mutex_unlock(&db->addr_lock);
+	}
+}
+
+static int dm9051_phy_connect(struct board_info *db)
+{
+	char phy_id[MII_BUS_ID_SIZE + 3];
+
+	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
+		 db->mdiobus->id, DM9051_PHY_ID);
+	db->phydev = phy_connect(db->ndev, phy_id, dm9051_handle_link_change,
+				 PHY_INTERFACE_MODE_MII);
+
+	if (IS_ERR(db->phydev))
+		return PTR_ERR(db->phydev);
+
+	return 0;
+}
+
+/* essential, ensure rxFifoPoint control, disable/enable the interrupt mask
+ */
+static void dm9051_imr_disable_lock_essential(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock);
+	dm9051_iow(db, DM9051_IMR, IMR_PAR); /* Disabe All */
+	mutex_unlock(&db->addr_lock);
+}
+
+static void dm9051_imr_enable_lock_essential(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock);
+	dm9051_iow(db, DM9051_IMR, db->imr_all); /* rxp to 0xc00 */
+	mutex_unlock(&db->addr_lock);
+}
+
+/* mac address is major from EEPROM
+ */
+static void dm9051_init_mac_addr(struct net_device *ndev, struct board_info *db)
+{
+	u8 addr[ETH_ALEN];
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		dm9051_ior(db, DM9051_PAR + i, &addr[i]);
+
+	if (is_valid_ether_addr(addr)) {
+		eth_hw_addr_set(ndev, addr);
+		return;
+	}
+
+	eth_hw_addr_random(ndev);
+	dev_dbg(&db->spidev->dev, "Use random MAC address\n");
+}
+
+/* ethtool-ops
+ */
+static void
+dm9051_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
+{
+	strscpy(info->driver, DRVNAME_9051, sizeof(info->driver));
+}
+
+static void dm9051_set_msglevel(struct net_device *ndev, u32 value)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	db->msg_enable = value;
+}
+
+static u32 dm9051_get_msglevel(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	return db->msg_enable;
+}
+
+static int dm9051_get_eeprom_len(struct net_device *dev)
+{
+	return 128;
+}
+
+static int dm9051_get_eeprom(struct net_device *ndev,
+			     struct ethtool_eeprom *ee, u8 *data)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	int offset = ee->offset;
+	int len = ee->len;
+	int i, ret;
+
+	if ((len & 1) != 0 || (offset & 1) != 0)
+		return -EINVAL;
+
+	ee->magic = DM_EEPROM_MAGIC;
+
+	mutex_lock(&db->addr_lock);
+	for (i = 0; i < len; i += 2) {
+		ret = dm9051_read_eeprom(db, (offset + i) / 2, data + i);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&db->addr_lock);
+	return ret;
+}
+
+static int dm9051_set_eeprom(struct net_device *ndev,
+			     struct ethtool_eeprom *ee, u8 *data)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	int offset = ee->offset;
+	int len = ee->len;
+	int i, ret;
+
+	if ((len & 1) != 0 || (offset & 1) != 0)
+		return -EINVAL;
+
+	if (ee->magic != DM_EEPROM_MAGIC)
+		return -EINVAL;
+
+	mutex_lock(&db->addr_lock);
+	for (i = 0; i < len; i += 2) {
+		ret = dm9051_write_eeprom(db, (offset + i) / 2, data + i);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&db->addr_lock);
+	return ret;
+}
+
+static void dm9051_get_pauseparam(struct net_device *ndev,
+				  struct ethtool_pauseparam *pause)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	*pause = db->eth_pause;
+}
+
+static int dm9051_set_pauseparam(struct net_device *ndev,
+				 struct ethtool_pauseparam *pause)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	u8 nfcr, fcr = 0;
+
+	db->eth_pause = *pause;
+
+	if (pause->autoneg)
+		db->phydev->autoneg = AUTONEG_ENABLE;
+	else
+		db->phydev->autoneg = AUTONEG_DISABLE;
+
+	if (pause->rx_pause)
+		fcr |= FCR_BKPM | FCR_FLCE;
+	if (pause->tx_pause)
+		fcr |= FCR_TXPEN;
+
+	mutex_lock(&db->addr_lock);
+	dm9051_ior(db, DM9051_FCR, &nfcr);
+	if (nfcr != fcr)
+		dm9051_iow(db, DM9051_FCR, fcr); /* on set pause param */
+	mutex_unlock(&db->addr_lock);
+
+	return 0;
+}
+
+static const struct ethtool_ops dm9051_ethtool_ops = {
+	.get_drvinfo = dm9051_get_drvinfo,
+	.get_link_ksettings = phy_ethtool_get_link_ksettings,
+	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_msglevel = dm9051_get_msglevel,
+	.set_msglevel = dm9051_set_msglevel,
+	.nway_reset = phy_ethtool_nway_reset,
+	.get_link = ethtool_op_get_link,
+	.get_eeprom_len = dm9051_get_eeprom_len,
+	.get_eeprom = dm9051_get_eeprom,
+	.set_eeprom = dm9051_set_eeprom,
+	.get_pauseparam = dm9051_get_pauseparam,
+	.set_pauseparam = dm9051_set_pauseparam,
+};
+
+static void dm9051_operation_clear(struct board_info *db)
+{
+	db->bc.status_err_counter = 0;
+	db->bc.large_err_counter = 0;
+	db->bc.DO_FIFO_RST_counter = 0;
+}
+
+/* reset while rx error found
+ */
+static void dm9051_fifo_reset(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+	char *sbuff = (char *)&db->eth_rxhdr;
+	int rxlen = le16_to_cpu(db->eth_rxhdr.rxlen);
+	u8 fcr = 0;
+
+	netdev_dbg(ndev, "dm9-rxhdr (rxhdr %02x %02x %02x %02x)\n",
+		   sbuff[0], sbuff[1], sbuff[2], sbuff[3]);
+	netdev_dbg(ndev, "check rxstatus-eror (%02x)\n",
+		   db->eth_rxhdr.rxstatus);
+	netdev_dbg(ndev, "check rxlen large-eror (%d > %d)\n",
+		   rxlen, DM9051_PKT_MAX);
+
+	dm9051_reset(db);
+	dm9051_reset_control(db);
+
+	if (db->eth_pause.rx_pause)
+		fcr |= FCR_BKPM | FCR_FLCE;
+	if (db->eth_pause.tx_pause)
+		fcr |= FCR_TXPEN;
+
+	dm9051_iow(db, DM9051_FCR, fcr); /* om init or saved pause param */
+	dm9051_iow(db, DM9051_IMR, db->imr_all); /* rxp to 0xc00 */
+	dm9051_iow(db, DM9051_RCR, db->rcr_all); /* EnabRX all */
+
+	netdev_dbg(ndev, " rxstatus_Er & rxlen_Er %d, RST_c %d\n",
+		   db->bc.status_err_counter + db->bc.large_err_counter,
+		   db->bc.DO_FIFO_RST_counter);
+}
+
+/* read packets from the fifo memory
+ * return value,
+ *  > 0 - read packet number, caller can repeat the rx operation
+ *    0 - no error, caller need stop further rx operation
+ *  -EBUSY - read data error, caller escape from rx operation
+ */
+static int dm9051_loop_rx(struct board_info *db)
+{
+	u8 rxbyte;
+	int ret, rxlen;
+	struct sk_buff *skb;
+	u8 *rdptr;
+	int scanrr = 0;
+
+	while (1) {
+		dm9051_ior(db, DM_SPI_MRCMDX, &rxbyte); /* dummy read */
+		dm9051_ior(db, DM_SPI_MRCMDX, &rxbyte); /* dummy read */
+		if (rxbyte != DM9051_PKT_RDY)
+			break; /* exhaust-empty */
+
+		ret = dm9051_inblk(db, (u8 *)&db->eth_rxhdr, DM_RXHDR_SIZE);
+		if (ret < 0)
+			return -EBUSY;
+
+		dm9051_iow(db, DM9051_ISR, 0xff); /* ISR clear and to stop mrcmd */
+
+		rxlen = le16_to_cpu(db->eth_rxhdr.rxlen);
+		if (db->eth_rxhdr.rxstatus & 0xbf || rxlen > DM9051_PKT_MAX) {
+			if (db->eth_rxhdr.rxstatus & 0xbf)
+				db->bc.status_err_counter++;
+			else
+				db->bc.large_err_counter++;
+			dm9051_fifo_reset(db);
+			return 0;
+		}
+
+		skb = dev_alloc_skb(rxlen);
+		if (!skb) {
+			ret = dm9051_dumpblk(db, rxlen);
+			if (ret < 0)
+				return -EBUSY;
+			return scanrr;
+		}
+
+		rdptr = (u8 *)skb_put(skb, rxlen - 4);
+		ret = dm9051_inblk(db, rdptr, rxlen);
+		if (ret < 0) {
+			dev_kfree_skb(skb);
+			return -EBUSY;
+		}
+
+		dm9051_iow(db, DM9051_ISR, 0xff); /* ISR clear and to stop mrcmd */
+
+		skb->protocol = eth_type_trans(skb, db->ndev);
+		if (db->ndev->features & NETIF_F_RXCSUM)
+			skb_checksum_none_assert(skb);
+		netif_rx_ni(skb);
+		db->ndev->stats.rx_bytes += rxlen;
+		db->ndev->stats.rx_packets++;
+		scanrr++;
+	}
+	return scanrr;
+}
+
+/* transmit a packet,
+ * return value,
+ *   0 - succeed
+ *  -ETIMEDOUT - timeout error
+ */
+static int dm9051_single_tx(struct board_info *db, u8 *buff, unsigned int len)
+{
+	int ret;
+	u8 check_val;
+
+	/* shorter by waiting tx-end rather than tx-req */
+	ret = read_poll_timeout(dm9051_getreg, check_val, check_val & (NSR_TX2END | NSR_TX1END),
+				1, 20, false, db, DM9051_NSR);
+	if (ret) {
+		netdev_err(db->ndev, "timeout transmit packet\n");
+		return -ETIMEDOUT;
+	}
+
+	ret = dm9051_outblk(db, buff, len);
+	if (ret < 0)
+		return ret;
+	dm9051_iow(db, DM9051_TXPLL, len);
+	dm9051_iow(db, DM9051_TXPLH, len >> 8);
+	dm9051_iow(db, DM9051_TCR, TCR_TXREQ);
+	return 0;
+}
+
+static int dm9051_loop_tx(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+	int ntx = 0;
+	int ret;
+
+	while (!skb_queue_empty(&db->txq)) {
+		struct sk_buff *skb;
+
+		skb = skb_dequeue(&db->txq);
+		if (skb) {
+			ntx++;
+			ret = dm9051_single_tx(db, skb->data, skb->len);
+			dev_kfree_skb(skb);
+			if (ret < 0)
+				return 0;
+			ndev->stats.tx_bytes += skb->len;
+			ndev->stats.tx_packets++;
+		}
+
+		if (netif_queue_stopped(ndev) &&
+		    (skb_queue_len(&db->txq) < DM9051_TX_QUE_LO_WATER))
+			netif_wake_queue(ndev);
+	}
+	return ntx;
+}
+
+/* end with enable the interrupt mask
+ */
+static irqreturn_t dm9051_rx_threaded_irq(int irq, void *pw)
+{
+	struct board_info *db = pw;
+	int ret;
+
+	mutex_lock(&db->spi_lock); /* mutex essential */
+	dm9051_imr_disable_lock_essential(db); /* set imr disable */
+	if (netif_carrier_ok(db->ndev)) {
+		mutex_lock(&db->addr_lock);
+		do {
+			ret = dm9051_loop_rx(db);
+			if (ret >= 0)
+				dm9051_loop_tx(db); /* for more performance */
+		} while (ret > 0);
+		mutex_unlock(&db->addr_lock);
+	}
+	dm9051_imr_enable_lock_essential(db); /* set imr enable */
+	mutex_unlock(&db->spi_lock); /* mutex essential */
+
+	return IRQ_HANDLED;
+}
+
+static void tx_delay(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct board_info *db = container_of(dw, struct board_info, tx_work);
+
+	mutex_lock(&db->spi_lock); /* mutex essential */
+	mutex_lock(&db->addr_lock);
+	dm9051_loop_tx(db);
+	mutex_unlock(&db->addr_lock);
+	mutex_unlock(&db->spi_lock); /* mutex essential */
+}
+
+static void rxctl_delay(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct board_info *db = container_of(dw, struct board_info, rxctrl_work);
+	struct net_device *ndev = db->ndev;
+	int i, oft;
+
+	mutex_lock(&db->addr_lock);
+
+	for (i = 0, oft = DM9051_PAR; i < ETH_ALEN; i++, oft++)
+		dm9051_iow(db, oft, ndev->dev_addr[i]);
+
+	/* Write the hash table */
+	for (i = 0, oft = DM9051_MAR; i < 4; i++) {
+		dm9051_iow(db, oft++, db->hash_table[i]);
+		dm9051_iow(db, oft++, db->hash_table[i] >> 8);
+	}
+
+	dm9051_iow(db, DM9051_RCR, db->rcr_all); /* EnabRX all */
+
+	mutex_unlock(&db->addr_lock);
+}
+
+/* Irq free and schedule delays cancel
+ */
+static void dm9051_stopcode_release(struct board_info *db)
+{
+	free_irq(db->spidev->irq, db);
+	cancel_delayed_work_sync(&db->rxctrl_work);
+	cancel_delayed_work_sync(&db->tx_work);
+}
+
+static void dm9051_control_init(struct board_info *db)
+{
+	mutex_init(&db->spi_lock);
+	mutex_init(&db->addr_lock);
+	INIT_DELAYED_WORK(&db->rxctrl_work, rxctl_delay);
+	INIT_DELAYED_WORK(&db->tx_work, tx_delay);
+}
+
+static inline void dm9051_phyup_lock(struct board_info *db)
+{
+	int val, ret;
+
+	mutex_lock(&db->addr_lock);
+
+	ret = dm9051_phy_read(db, MII_BMCR, &val);
+	if (ret)
+		return;
+
+	/* BMCR Power-up PHY */
+	ret = dm9051_phy_write(db, MII_BMCR, val & ~0x0800);
+	if (ret)
+		return;
+
+	/* GPR Power-up PHY */
+	dm9051_iow(db, DM9051_GPR, 0);
+	mdelay(1); /* need for activate phyxcer */
+
+	mutex_unlock(&db->addr_lock);
+}
+
+static inline void dm9051_phydown_lock(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock);
+	dm9051_iow(db, DM9051_GPR, 0x01); /* Power-Down PHY */
+	mutex_unlock(&db->addr_lock);
+}
+
+static void dm9051_initcode_lock(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock); /* Note: must */
+	dm9051_reset(db);
+	dm9051_reset_control(db);
+	mutex_unlock(&db->addr_lock);
+}
+
+static void dm9051_stopcode_lock(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock);
+	dm9051_iow(db, DM9051_RCR, RCR_RX_DISABLE); /* Disable RX */
+	mutex_unlock(&db->addr_lock);
+}
+
+/* Open network device
+ * Called when the network device is marked active, such as a user executing
+ * 'ifconfig up' on the device
+ */
+static int dm9051_open(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	struct spi_device *spi = db->spidev;
+	int ret;
+
+	netif_wake_queue(ndev);
+
+	ndev->irq = spi->irq; /* by dts */
+	ret = request_threaded_irq(spi->irq, NULL, dm9051_rx_threaded_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   ndev->name, db);
+	if (ret < 0) {
+		netdev_err(ndev, "failed to get irq\n");
+		return ret;
+	}
+
+	db->imr_all = IMR_PAR | IMR_PRM;
+	db->rcr_all = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
+	db->lcr_all = LMCR_MODE1;
+
+	/* init pause param FlowCtrl */
+	db->eth_pause.rx_pause = true;
+	db->eth_pause.tx_pause = true;
+	db->eth_pause.autoneg = AUTONEG_ENABLE;
+
+	/* We may have start with auto negotiation */
+	db->phydev->autoneg = AUTONEG_ENABLE;
+	db->phydev->speed = 0;
+	db->phydev->duplex = 0;
+
+	dm9051_phyup_lock(db);
+	dm9051_initcode_lock(db);
+
+	phy_support_sym_pause(db->phydev); /* Enable support of sym pause */
+	phy_start(db->phydev); /* phy read/write is enclose with mutex_lock/mutex_unlock */
+
+	dm9051_imr_enable_lock_essential(db);
+	return 0;
+}
+
+/* Close network device
+ * Called to close down a network device which has been active. Cancel any
+ * work, shutdown the RX and TX process and then place the chip into a low
+ * power state while it is not being used
+ */
+static int dm9051_stop(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	dm9051_stopcode_release(db);
+	netif_stop_queue(ndev);
+	phy_stop(db->phydev);
+	dm9051_phydown_lock(db);
+	dm9051_stopcode_lock(db);
+	return 0;
+}
+
+/* event: play a schedule starter in condition
+ */
+static netdev_tx_t dm9051_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	skb_queue_tail(&db->txq, skb); /* add to skb */
+	if (skb_queue_len(&db->txq) > DM9051_TX_QUE_HI_WATER) /* enforce limit queue size */
+		netif_stop_queue(ndev);
+	schedule_delayed_work(&db->tx_work, 0); /* spi operation must in delayed work */
+	return NETDEV_TX_OK;
+}
+
+/* event: play with a schedule starter
+ */
+static void dm9051_set_multicast_list_schedule(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	u8 rcr = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
+	struct netdev_hw_addr *ha;
+	u32 hash_val;
+
+	/* rx control */
+	if (ndev->flags & IFF_PROMISC) {
+		rcr |= RCR_PRMSC;
+		netdev_dbg(ndev, "set_multicast rcr |= RCR_PRMSC, rcr= %02x\n", rcr);
+	}
+
+	if (ndev->flags & IFF_ALLMULTI) {
+		rcr |= RCR_ALL;
+		netdev_dbg(ndev, "set_multicast rcr |= RCR_ALLMULTI, rcr= %02x\n", rcr);
+	}
+
+	db->rcr_all = rcr;
+
+	/* broadcast address */
+	db->hash_table[0] = 0;
+	db->hash_table[1] = 0;
+	db->hash_table[2] = 0;
+	db->hash_table[3] = 0x8000;
+
+	/* the multicast address in Hash Table : 64 bits */
+	netdev_for_each_mc_addr(ha, ndev) {
+		hash_val = ether_crc_le(ETH_ALEN, ha->addr) & 0x3f;
+		db->hash_table[hash_val / 16] |= (u16)1 << (hash_val % 16);
+	}
+
+	schedule_delayed_work(&db->rxctrl_work, 0); /* spi operation must in delayed work */
+}
+
+/* event: write into the mac registers and eeprom directly
+ */
+static int dm9051_set_mac_address(struct net_device *ndev, void *p)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	int i, oft, ret;
+
+	ret = eth_mac_addr(ndev, p);
+	if (ret < 0)
+		return ret;
+
+	/* write to chip */
+	mutex_lock(&db->addr_lock);
+	for (i = 0, oft = DM9051_PAR; i < ETH_ALEN; i++, oft++)
+		dm9051_iow(db, oft, ndev->dev_addr[i]);
+	mutex_unlock(&db->addr_lock);
+
+	return 0;
+}
+
+/* netdev-ops
+ */
+static const struct of_device_id dm9051_match_table[] = {
+	{ .compatible = "davicom,dm9051", },
+	{},
+};
+
+static const struct spi_device_id dm9051_id_table[] = {
+	{ "dm9051", 0 },
+	{},
+};
+
+static
+const struct net_device_ops dm9051_netdev_ops = {
+	.ndo_open = dm9051_open,
+	.ndo_stop = dm9051_stop,
+	.ndo_start_xmit = dm9051_start_xmit,
+	.ndo_set_rx_mode = dm9051_set_multicast_list_schedule,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_set_mac_address = dm9051_set_mac_address,
+};
+
+/* probe subs
+ */
+static void dm9051_netdev(struct net_device *ndev)
+{
+	ndev->mtu = 1500;
+	ndev->if_port = IF_PORT_100BASET;
+	ndev->netdev_ops = &dm9051_netdev_ops;
+	ndev->ethtool_ops = &dm9051_ethtool_ops;
+}
+
+static void dm9051_spimsg_addtail(struct board_info *db)
+{
+	memset(&db->spi_xfer2, 0, sizeof(struct spi_transfer) * 2);
+	spi_message_init(&db->spi_msg);
+	spi_message_add_tail(&db->spi_xfer2[0], &db->spi_msg);
+	spi_message_add_tail(&db->spi_xfer2[1], &db->spi_msg);
+}
+
+static int dm9051_register_mdiobus(struct board_info *db)
+{
+	struct spi_device *spi = db->spidev;
+	int ret;
+
+	db->mdiobus = devm_mdiobus_alloc(&spi->dev);
+	if (!db->mdiobus)
+		return -ENOMEM;
+
+	db->mdiobus->priv = db;
+	db->mdiobus->read = dm9051_mdio_read;
+	db->mdiobus->write = dm9051_mdio_write;
+	db->mdiobus->name = "dm9051-mdiobus";
+	db->mdiobus->phy_mask = (u32)~BIT(1);
+	db->mdiobus->parent = &spi->dev;
+	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
+		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
+
+	ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
+	if (ret < 0) {
+		dev_err(&spi->dev, "Could not register MDIO bus\n");
+		return ret;
+	}
+	return 0;
+}
+
+static int dm9051_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct net_device *ndev;
+	struct board_info *db;
+	unsigned int id;
+	int ret = 0;
+
+	ndev = devm_alloc_etherdev(dev, sizeof(struct board_info));
+	if (!ndev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(ndev, dev);
+	dev_set_drvdata(dev, ndev);
+	db = netdev_priv(ndev);
+	db->msg_enable = 0;
+	db->spidev = spi;
+	db->ndev = ndev;
+	dm9051_netdev(ndev);
+
+	dm9051_spimsg_addtail(db);
+	dm9051_control_init(db); /* init delayed works */
+
+	id = dm9051_chipid(db);
+	if (id != DM9051_ID) {
+		dev_err(dev, "chip id error\n");
+		return -ENODEV;
+	}
+	dm9051_init_mac_addr(ndev, db);
+
+	ret = dm9051_register_mdiobus(db); /* init mdiobus */
+	if (ret) {
+		dev_err(dev, "register mdiobus error\n");
+		return ret;
+	}
+
+	ret = dm9051_phy_connect(db); /* phy connect as poll mode */
+	if (ret) {
+		dev_err(dev, "phy connect error\n");
+		return ret;
+	}
+
+	dm9051_operation_clear(db);
+	ret = devm_register_netdev(dev, ndev);
+	if (ret) {
+		dev_err(dev, "failed to register network device\n");
+		goto err_netdev;
+	}
+
+	skb_queue_head_init(&db->txq);
+
+	return 0;
+
+err_netdev:
+	phy_disconnect(db->phydev);
+	return ret;
+}
+
+static int dm9051_drv_remove(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct board_info *db = to_dm9051_board(ndev);
+
+	phy_disconnect(db->phydev);
+	return 0;
+}
+
+static struct spi_driver dm9051_driver = {
+	.driver = {
+		.name = DRVNAME_9051,
+		.of_match_table = dm9051_match_table,
+	},
+	.probe = dm9051_probe,
+	.remove = dm9051_drv_remove,
+	.id_table = dm9051_id_table,
+};
+module_spi_driver(dm9051_driver);
+
+MODULE_AUTHOR("Joseph CHANG <joseph_chang@davicom.com.tw>");
+MODULE_DESCRIPTION("Davicom DM9051 network SPI driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/davicom/dm9051.h b/drivers/net/ethernet/davicom/dm9051.h
new file mode 100644
index 000000000000..99a0e7e4800a
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.h
@@ -0,0 +1,189 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 Davicom Semiconductor,Inc.
+ * Davicom DM9051 SPI Fast Ethernet Linux driver
+ */
+
+#ifndef _DM9051_H_
+#define _DM9051_H_
+
+#define DRVNAME_9051		"dm9051"
+
+#define DM9051_ID		0x9051
+
+#define DM9051_NCR		0x00
+#define DM9051_NSR		0x01
+#define DM9051_TCR		0x02
+#define DM9051_RCR		0x05
+#define DM9051_BPTR		0x08
+#define DM9051_FCR		0x0A
+#define DM9051_EPCR		0x0B
+#define DM9051_EPAR		0x0C
+#define DM9051_EPDRL		0x0D
+#define DM9051_EPDRH		0x0E
+#define DM9051_PAR		0x10
+#define DM9051_MAR		0x16
+#define DM9051_GPCR		0x1E
+#define DM9051_GPR		0x1F
+
+#define DM9051_PIDL		0x2A
+#define DM9051_PIDH		0x2B
+#define DM9051_SMCR		0x2F
+#define	DM9051_ATCR		0x30
+#define	DM9051_SPIBCR		0x38
+#define DM9051_INTCR		0x39
+#define DM9051_PPCR		0x3D
+
+#define DM9051_MPCR		0x55
+#define DM9051_LMCR		0x57
+#define DM9051_MBNDRY		0x5E
+
+#define DM9051_MRRL		0x74
+#define DM9051_MRRH		0x75
+#define DM9051_MWRL		0x7A
+#define DM9051_MWRH		0x7B
+#define DM9051_TXPLL		0x7C
+#define DM9051_TXPLH		0x7D
+#define DM9051_ISR		0x7E
+#define DM9051_IMR		0x7F
+
+#define DM_SPI_MRCMDX		(0x70)
+#define DM_SPI_MRCMD		(0x72)
+#define DM_SPI_MWCMD		(0x78)
+
+#define DM_SPI_RD		(0x00)
+#define DM_SPI_WR		(0x80)
+
+/* dm9051 Ethernet
+ */
+/* 0x00 */
+#define NCR_WAKEEN		BIT(6)
+#define NCR_FDX			BIT(3)
+#define NCR_RST			BIT(0)
+/* 0x02 */
+#define TCR_DIS_JABBER_TIMER	BIT(6) /* for Jabber Packet support */
+#define TCR_TXREQ		BIT(0)
+/* 0x01 */
+#define NSR_SPEED		BIT(7)
+#define NSR_LINKST		BIT(6)
+#define NSR_WAKEST		BIT(5)
+#define NSR_TX2END		BIT(3)
+#define NSR_TX1END		BIT(2)
+/* 0x05 */
+#define RCR_DIS_WATCHDOG_TIMER	BIT(6)  /* for Jabber Packet support */
+#define RCR_DIS_LONG		BIT(5)
+#define RCR_DIS_CRC		BIT(4)
+#define RCR_ALL			BIT(3)
+#define RCR_PRMSC		BIT(1)
+#define RCR_RXEN		BIT(0)
+#define RCR_RX_DISABLE		(RCR_DIS_LONG | RCR_DIS_CRC)
+/* 0x06 */
+#define RSR_RF			BIT(7)
+#define RSR_MF			BIT(6)
+#define RSR_LCS			BIT(5)
+#define RSR_RWTO		BIT(4)
+#define RSR_PLE			BIT(3)
+#define RSR_AE			BIT(2)
+#define RSR_CE			BIT(1)
+#define RSR_FOE			BIT(0)
+/* 0x0A */
+#define FCR_TXPEN		BIT(5)
+#define FCR_BKPM		BIT(3)
+#define FCR_FLCE		BIT(0)
+#define FCR_RXTX_ENABLE		(FCR_TXPEN | FCR_BKPM | FCR_FLCE)
+/* 0x0B */
+#define EPCR_WEP		BIT(4)
+#define EPCR_EPOS		BIT(3)
+#define EPCR_ERPRR		BIT(2)
+#define EPCR_ERPRW		BIT(1)
+#define EPCR_ERRE		BIT(0)
+/* 0x1E */
+#define GPCR_GEP_CNTL		BIT(0)
+/* 0x30 */
+#define	ATCR_AUTO_TX		BIT(7)
+/* 0x39 */
+#define INTCR_POL_LOW		BIT(0)
+#define INTCR_POL_HIGH		(0 << 0)
+/* 0x3D */
+/* Pause Packet Control Register - default = 1 */
+#define PPCR_PAUSE_COUNT	0x08
+/* 0x55 */
+#define MPCR_RSTTX		BIT(1)
+#define MPCR_RSTRX		BIT(0)
+/* 0x57 */
+/* LEDMode Control Register - LEDMode1 */
+/* Value 0x81 : bit[7] = 1, bit[2] = 0, bit[1:0] = 01b */
+#define LMCR_NEWMOD		BIT(7)
+#define LMCR_TYPED1		BIT(1)
+#define LMCR_TYPED0		BIT(0)
+#define LMCR_MODE1		(LMCR_NEWMOD | LMCR_TYPED0)
+/* 0x5E */
+#define MBNDRY_BYTE		BIT(7)
+/* 0xFE */
+#define ISR_MBS			BIT(7)
+#define ISR_ROOS		BIT(3)
+#define ISR_ROS			BIT(2)
+#define ISR_PTS			BIT(1)
+#define ISR_PRS			BIT(0)
+#define ISR_CLR_STATUS		(ISR_ROOS | ISR_ROS | ISR_PTS | ISR_PRS)
+/* 0xFF */
+#define IMR_PAR			BIT(7)
+#define IMR_LNKCHGI		BIT(5)
+#define IMR_PTM			BIT(1)
+#define IMR_PRM			BIT(0)
+
+/* Const
+ */
+#define DM9051_PHY_ID			1	/* PHY id */
+#define DM9051_PHY			0x40	/* PHY address 0x01 */
+#define DM9051_PKT_RDY			0x01	/* Packet ready to receive */
+#define DM9051_PKT_MAX			1536	/* Received packet max size */
+#define DM9051_TX_QUE_HI_WATER		50
+#define DM9051_TX_QUE_LO_WATER		25
+#define DM_EEPROM_MAGIC			(0x9051)
+
+static inline struct board_info *to_dm9051_board(struct net_device *ndev)
+{
+	return netdev_priv(ndev);
+}
+
+/* structure definitions
+ */
+struct rx_ctl_mach {
+	u16				status_err_counter;  /* The error of 'Status Err' */
+	u16				large_err_counter;  /* The error of 'Large Err' */
+	u16				DO_FIFO_RST_counter; /* The counter of 'fifo_reset' */
+};
+
+struct dm9051_rxhdr {
+	u8				rxpktready;
+	u8				rxstatus;
+	__le16				rxlen;
+};
+
+struct board_info {
+	struct spi_message		spi_msg;
+	struct spi_transfer		spi_xfer2[2];
+	u8				cmd[2];
+	struct spi_device		*spidev;
+	struct net_device		*ndev;
+	struct mii_bus			*mdiobus;
+	struct phy_device		*phydev;
+	struct sk_buff_head		txq;
+	struct mutex			spi_lock;	/* delayed_work's lock */
+	struct mutex			addr_lock;	/* dm9051's REG lock */
+	struct delayed_work		rxctrl_work;
+	struct delayed_work		tx_work;
+	struct rx_ctl_mach		bc;
+	struct dm9051_rxhdr		eth_rxhdr;
+	struct ethtool_pauseparam	eth_pause;
+	u32				msg_enable;
+	u16				hash_table[4];
+	u8				imr_all;
+	u8				rcr_all;
+	u8				lcr_all;
+};
+
+#define	DM_RXHDR_SIZE			sizeof(struct dm9051_rxhdr)
+
+#endif /* _DM9051_H_ */
-- 
2.20.1

