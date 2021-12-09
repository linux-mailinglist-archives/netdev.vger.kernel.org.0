Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3FF46E644
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhLIKLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhLIKLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:11:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA2EC061353;
        Thu,  9 Dec 2021 02:07:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k4so3498938plx.8;
        Thu, 09 Dec 2021 02:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h98J9Ln5ETn4Rv2Qq3ekMhVxei3B/rKgnji5fjNcP3o=;
        b=RSU/SUeep00ZNNlk7MzQguo1fRuCKVaaxN3LAUvXLaJs6HxbvxY0q+a+wxYIvJSeo5
         kOZOYZGnxaUwY6/Y/ooUNcFExnnUoDrfLlljIrt7cLzqlsUj3IwWT8qHTJa8kEOPsPoa
         nXBY1AqSteziL+eVdGmTQBjm1oVY3I7EwAxTjfYF1mM2S3LPSdrVpUf//LS1LZvEIsMg
         CmERlIRbHu+FuDu8RDGvMGrhWFxf/4wERhtOTlI47+T2ZZY68MNb1CXpL6iQWVQtXrbQ
         YFntTuLonsLEkXJOWNHbqDeICZ56XsFLpIbPS+qDppB35AVfy1Ef/EzWNT0vH1g2Ye9z
         FASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h98J9Ln5ETn4Rv2Qq3ekMhVxei3B/rKgnji5fjNcP3o=;
        b=a5u7ER2htoAC9EqlXBzsRq5rcH+tJMvFHXGUB/XXbGj18ih62/4SEy5chCFQWSBXZA
         JIBn3ZSjyfg6qGEuUdARkEF5P7S6Ug1zJ5MyjdpUu/4EPVm06jmzP42QK56rcEalHZ/M
         qD/rFyXh35lBoeCx4Eic32gMJxC3+Zy3buySJEu2RM8yi4eFGZkiecdNcJAO7JKTlGRM
         Q73cg+xQe7gNecMJaUrp917cCs0hS2Q3qnxnF83Rd4Ju9ELa2/nUShHnzU38PNx6kcH1
         GcJmc7kNi0/ayffvN69Gl40Cq1D4Qi+bda1KO5vtk885wXYwwsi28+Ab13ma76o5FBDy
         Wrlg==
X-Gm-Message-State: AOAM530XhRLHLnjnggGab9mxG16GHhsA7v3M7AWpCWgCgjxJoJ/ROq5Q
        M16DInTyY+K2qCSAqf2ScUA=
X-Google-Smtp-Source: ABdhPJytZ5nciHOJTYFUglhTyaU/2cIYlc7FCcBQG7KO0wLPdf0Q6xWrMfz/pWIrvBrYIPTmcchv0w==
X-Received: by 2002:a17:90b:3b48:: with SMTP id ot8mr14723378pjb.78.1639044461700;
        Thu, 09 Dec 2021 02:07:41 -0800 (PST)
Received: from localhost.localdomain (61-231-106-143.dynamic-ip.hinet.net. [61.231.106.143])
        by smtp.gmail.com with ESMTPSA id i2sm6932409pfg.90.2021.12.09.02.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:07:41 -0800 (PST)
From:   JosephCHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2, 2/2] net: Add DM9051 driver
Date:   Thu,  9 Dec 2021 18:07:02 +0800
Message-Id: <20211209100702.5609-3-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209100702.5609-1-josright123@gmail.com>
References: <20211209100702.5609-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add davicom dm9051 SPI ethernet driver. The driver work with dts
for:

     - spi bus number
     - spi chip select
     - spi clock frequency
     - interrupt gpio pin
     - interrupt polarity fixed as low

    Test OK with Rpi 2 and Rpi 4. Max spi speed is 31200000.

Signed-off-by: JosephCHANG <josright123@gmail.com>
[Submit v1 has Reported-by: kernel test robot <lkp@intel.com>]
---
 drivers/net/ethernet/davicom/Kconfig  |  30 +
 drivers/net/ethernet/davicom/Makefile |   1 +
 drivers/net/ethernet/davicom/dm9051.c | 967 ++++++++++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h | 248 +++++++
 4 files changed, 1246 insertions(+)
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h

diff --git a/drivers/net/ethernet/davicom/Kconfig b/drivers/net/ethernet/davicom/Kconfig
index 7af86b6d4150..9c00328f6e05 100644
--- a/drivers/net/ethernet/davicom/Kconfig
+++ b/drivers/net/ethernet/davicom/Kconfig
@@ -3,6 +3,20 @@
 # Davicom device configuration
 #
 
+config NET_VENDOR_DAVICOM
+	bool "Davicom devices"
+	depends on ARM || MIPS || COLDFIRE || NIOS2 || COMPILE_TEST || SPI
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
@@ -22,3 +36,19 @@ config DM9000_FORCE_SIMPLE_PHY_POLL
 	  bit to determine if the link is up or down instead of the more
 	  costly MII PHY reads. Note, this will not work if the chip is
 	  operating with an external PHY.
+
+config DM9051
+	tristate "DM9051 SPI support"
+	depends on SPI
+	select CRC32
+	select MII
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
index 000000000000..cdcf9d37ed7f
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -0,0 +1,967 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *	Ethernet driver for the Davicom DM9051 chip.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version 2
+ *	of the License, or (at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	Copyright 2021 Davicom Semiconductor,Inc.
+ *	http://www.davicom.com.tw/
+ *	Joseph CHANG <joseph_chang@davicom.com.tw>
+ *	20211110b, Total 933 lines
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/interrupt.h>
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
+#define	DRV_PRODUCT_NAME	"dm9051"
+#define	DRV_VERSION_CODE	DM_VERSION(5, 0, 5)			//(VER5.0.0= 0x050000)
+#define	DRV_VERSION_DATE	"20211209"				//(update)"
+
+/* spi-spi_sync, low level code */
+static int burst_xfer(struct board_info *db, u8 cmdphase, u8 *txb, u8 *rxb, unsigned int len)
+{
+	struct device *dev = &db->spidev->dev;
+	int ret = 0;
+
+	db->cmd[0] = cmdphase;
+	db->spi_xfer2[0].tx_buf = &db->cmd[0];
+	db->spi_xfer2[0].rx_buf = NULL;
+	db->spi_xfer2[0].len = 1;
+	if (!rxb) { //write
+		db->spi_xfer2[1].tx_buf = txb;
+		db->spi_xfer2[1].rx_buf = NULL;
+		db->spi_xfer2[1].len = len;
+	} else { //read
+		db->spi_xfer2[1].tx_buf = txb;
+		db->spi_xfer2[1].rx_buf = rxb;
+		db->spi_xfer2[1].len = len;
+	}
+	ret = spi_sync(db->spidev, &db->spi_msg2);
+	if (ret < 0)
+		dev_err(dev, "dm9Err spi burst cmd 0x%02x, ret=%d\n", cmdphase, ret);
+	return ret;
+}
+
+static u8 std_spi_read_reg(struct board_info *db, unsigned int reg)
+{
+	u8 rxb[1];
+
+	burst_xfer(db, DM_SPI_RD | reg, NULL, rxb, 1);
+	return rxb[0];
+}
+
+/* chip ID display */
+static u8 disp_spi_read_reg(struct device *dev, struct board_info *db,
+			    unsigned int reg)
+{
+	u8 rxdata;
+
+	rxdata = std_spi_read_reg(db, reg);
+	if (reg == DM9051_PIDL || reg == DM9051_PIDH)
+		dev_info(dev, "dm905.MOSI.p.[%02x][..]\n", reg);
+	if (reg == DM9051_PIDL || reg == DM9051_PIDH)
+		dev_info(dev, "dm905.MISO.e.[..][%02x]\n", rxdata);
+	return rxdata;
+}
+
+static void std_spi_write_reg(struct board_info *db, unsigned int reg, unsigned int val)
+{
+	u8 txb[1];
+
+	txb[0] = val;
+	burst_xfer(db, DM_SPI_WR | reg, txb, NULL, 1);
+}
+
+static void std_read_rx_buf_ncpy(struct board_info *db, u8 *buff, unsigned int len)
+{
+	u8 txb[1];
+
+	burst_xfer(db, DM_SPI_RD | DM_SPI_MRCMD, txb, buff, len);
+}
+
+static int std_write_tx_buf(struct board_info *db, u8 *buff, unsigned int len)
+{
+	burst_xfer(db, DM_SPI_WR | DM_SPI_MWCMD, buff, NULL, len);
+	return 0;
+}
+
+/* basic read/write to phy
+ */
+static int dm_phy_read_func(struct board_info *db, int reg)
+{
+	int ret;
+	u8 check_val;
+
+	iow(db, DM9051_EPAR, DM9051_PHY | reg);
+	iow(db, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
+	read_poll_timeout(ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+			  true, db, DM9051_EPCR);
+	iow(db, DM9051_EPCR, 0x0);
+	ret = (ior(db, DM9051_EPDRH) << 8) | ior(db, DM9051_EPDRL);
+	return ret;
+}
+
+static void dm_phy_write_func(struct board_info *db, int reg, int value)
+{
+	u8 check_val;
+
+	iow(db, DM9051_EPAR, DM9051_PHY | reg);
+	iow(db, DM9051_EPDRL, value);
+	iow(db, DM9051_EPDRH, value >> 8);
+	iow(db, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
+	read_poll_timeout(ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+			  true, db, DM9051_EPCR);
+	iow(db, DM9051_EPCR, 0x0);
+}
+
+/* Read a word data from SROM
+ */
+static void dm_read_eeprom_func(struct board_info *db, int offset, u8 *to)
+{
+	u8 check_val;
+
+	mutex_lock(&db->addr_lock);
+	iow(db, DM9051_EPAR, offset);
+	iow(db, DM9051_EPCR, EPCR_ERPRR);
+	read_poll_timeout(ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+			  true, db, DM9051_EPCR);
+	iow(db, DM9051_EPCR, 0x0);
+	to[0] = ior(db, DM9051_EPDRL);
+	to[1] = ior(db, DM9051_EPDRH);
+	mutex_unlock(&db->addr_lock);
+}
+
+/* Write a word data to SROM
+ */
+static void dm_write_eeprom_func(struct board_info *db, int offset, u8 *data)
+{
+	u8 check_val;
+
+	mutex_lock(&db->addr_lock);
+	iow(db, DM9051_EPAR, offset);
+	iow(db, DM9051_EPDRH, data[1]);
+	iow(db, DM9051_EPDRL, data[0]);
+	iow(db, DM9051_EPCR, EPCR_WEP | EPCR_ERPRW);
+	read_poll_timeout(ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
+			  true, db, DM9051_EPCR);
+	iow(db, DM9051_EPCR, 0);
+	mutex_unlock(&db->addr_lock);
+}
+
+static int dm9051_phy_read_lock(struct net_device *dev, int phy_reg_unused, int reg)
+{
+	int val;
+	struct board_info *db = netdev_priv(dev);
+
+	mutex_lock(&db->addr_lock);
+	val = dm_phy_read_func(db, reg);
+	mutex_unlock(&db->addr_lock);
+	return val;
+}
+
+static void dm9051_phy_write_lock(struct net_device *dev, int phyaddr_unused, int reg, int value)
+{
+	struct board_info *db = netdev_priv(dev);
+
+	mutex_lock(&db->addr_lock);
+	dm_phy_write_func(db, reg, value);
+	mutex_unlock(&db->addr_lock);
+}
+
+/* read chip id
+ */
+static unsigned int dm9051_chipid(struct device *dev, struct board_info *db)
+{
+	unsigned int chipid;
+
+	chipid = iior(dev, db, DM9051_PIDL);
+	chipid |= (unsigned int)iior(dev, db, DM9051_PIDH) << 8;
+	if (chipid == DM9051_ID)
+		return chipid;
+	chipid = iior(dev, db, DM9051_PIDL);
+	chipid |= (unsigned int)iior(dev, db, DM9051_PIDH) << 8;
+	if (chipid == DM9051_ID)
+		return chipid;
+	dev_dbg(dev, "Read [DM9051_PID] = %04x\n", chipid);
+	dev_dbg(dev, "Read [DM9051_PID] error!\n");
+	return chipid;
+}
+
+static void dm9051_reset(struct board_info *db)
+{
+	mdelay(2); //need before NCR_RST
+	ncr_reg_reset(db);
+	mdelay(1);
+	mbd_reg_byte(db);
+	mdelay(1);
+	dm_phy_write_func(db, MII_ADVERTISE, ADVERTISE_PAUSE_CAP |
+			  ADVERTISE_ALL | ADVERTISE_CSMA); //for fcr, essential
+	fcr_reg_enable(db);
+	ppcr_reg_seeting(db);
+	ledcr_reg_setting(db, db->lcr_all);
+	intcr_reg_setval(db);
+}
+
+/* ESSENTIAL, ensure rxFifoPoint control, disable/enable the interrupt mask
+ */
+static void dm_imr_disable_lock_essential(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock);
+	imr_reg_stop(db);
+	mutex_unlock(&db->addr_lock);
+}
+
+static void dm_imr_enable_lock_essential(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock);
+	imr_reg_start(db, db->imr_all); //exactly ncr-rst then rxp to 0xc00
+	//rcr_reg_start(db, db->rcr_all); //rx enable later
+	mutex_unlock(&db->addr_lock);
+}
+
+/* functions process mac address is major from EEPROM
+ */
+static void dm9051_read_mac_to_dev(struct device *dev, struct net_device *ndev,
+				   struct board_info *db)
+{
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		ndev->dev_addr[i] = ior(db, DM9051_PAR + i);
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		eth_hw_addr_random(ndev);
+		dev_dbg(dev, "dm9 [reg_netdev][%s][chip MAC: %pM (%s)]\n",
+			ndev->name, ndev->dev_addr, "FIX-1");
+	}
+}
+
+/* mac, hash, and rx enable temporarily
+ */
+static void dm_set_multicast_list_lock(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+
+	if (db->enter_hash) {
+		u8 rcr = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
+		int i, oft;
+		u32 hash_val;
+		u16 hash_table[4];
+		struct netdev_hw_addr *ha;
+
+		db->enter_hash = 0;
+		mutex_lock(&db->addr_lock);
+		for (i = 0, oft = DM9051_PAR; i < ETH_ALEN; i++, oft++)
+			iow(db, oft, ndev->dev_addr[i]);
+
+		/* Clear Hash Table */
+		for (i = 0; i < 4; i++)
+			hash_table[i] = 0x0;
+
+		/* broadcast address */
+		hash_table[3] = 0x8000;
+
+		if (ndev->flags & IFF_PROMISC) {
+			rcr |= RCR_PRMSC;
+			netdev_dbg(ndev, "set_multicast rcr |= RCR_PRMSC, rcr= %02x\n", rcr);
+		}
+
+		if (ndev->flags & IFF_ALLMULTI) {
+			rcr |= RCR_ALL;
+			netdev_dbg(ndev, "set_multicast rcr |= RCR_ALLMULTI, rcr= %02x\n", rcr);
+		}
+
+		/* the multicast address in Hash Table : 64 bits */
+		netdev_for_each_mc_addr(ha, ndev) {
+			hash_val = ether_crc_le(6, ha->addr) & 0x3f;
+			hash_table[hash_val / 16] |= (u16)1 << (hash_val % 16);
+		}
+		/* Write the hash table */
+		for (i = 0, oft = DM9051_MAR; i < 4; i++) {
+			iow(db, oft++, hash_table[i]);
+			iow(db, oft++, hash_table[i] >> 8);
+		}
+		db->rcr_all = rcr;
+		rcr_reg_start(db, db->rcr_all);
+		mutex_unlock(&db->addr_lock);
+	}
+}
+
+/* set mac permanently
+ */
+static void dm_set_mac_lock(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+
+	if (db->enter_setmac) {
+		int i, oft;
+
+		db->enter_setmac = 0;
+		netdev_dbg(ndev, "set_mac_address %pM\n", ndev->dev_addr);
+
+		/* write to net device and chip */
+		mutex_lock(&db->addr_lock);
+		for (i = 0, oft = DM9051_PAR; i < ETH_ALEN; i++, oft++)
+			iow(db, oft, ndev->dev_addr[i]);
+		mutex_unlock(&db->addr_lock);
+
+		/* write to EEPROM */
+		for (i = 0; i < ETH_ALEN; i += 2)
+			dm_write_eeprom_func(db, i / 2, (u8 *)&ndev->dev_addr[i]);
+	}
+}
+
+/* tables, netdev-ops
+ */
+static const struct of_device_id dm9051_match_table[] = {
+	{ .compatible = "davicom,dm9051", },
+	{}
+};
+
+struct spi_device_id dm9051_spi_id_table = {
+	"dm9051",
+	0
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
+/* table, ethtool-ops
+ */
+static void dm9051_get_drvinfo(struct net_device *dev,
+			       struct ethtool_drvinfo *info)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+
+	strscpy(info->driver, DRVNAME_9051, sizeof(info->driver));
+	strscpy(info->version, dm->DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, dev_name(dev->dev.parent), sizeof(info->bus_info));
+}
+
+static void dm9051_set_msglevel(struct net_device *dev, u32 value)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+
+	dm->msg_enable = value;
+}
+
+static u32 dm9051_get_msglevel(struct net_device *dev)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+
+	return dm->msg_enable;
+}
+
+static int dm9051_get_link_ksettings(struct net_device *dev,
+				     struct ethtool_link_ksettings *cmd)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+
+	mii_ethtool_get_link_ksettings(&dm->mii, cmd);
+	return 0;
+}
+
+static int dm9051_set_link_ksettings(struct net_device *dev,
+				     const struct ethtool_link_ksettings *cmd)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+
+	return mii_ethtool_set_link_ksettings(&dm->mii, cmd);
+}
+
+static int dm9051_nway_reset(struct net_device *dev)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+
+	return mii_nway_restart(&dm->mii);
+}
+
+static u32 dm9051_get_link(struct net_device *dev)
+{
+	struct board_info *db = to_dm9051_board(dev);
+
+	return mii_link_ok(&db->mii);
+}
+
+static int dm9051_get_eeprom_len(struct net_device *dev)
+{
+	return 128;
+}
+
+static int dm9051_get_eeprom(struct net_device *dev,
+			     struct ethtool_eeprom *ee, u8 *data)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+	int offset = ee->offset;
+	int len = ee->len;
+	int i;
+
+	if ((len & 1) != 0 || (offset & 1) != 0)
+		return -EINVAL;
+
+	ee->magic = DM_EEPROM_MAGIC;
+
+	for (i = 0; i < len; i += 2)
+		dm_read_eeprom_func(dm, (offset + i) / 2, data + i);
+	return 0;
+}
+
+static int dm9051_set_eeprom(struct net_device *dev,
+			     struct ethtool_eeprom *ee, u8 *data)
+{
+	struct board_info *dm = to_dm9051_board(dev);
+	int offset = ee->offset;
+	int len = ee->len;
+	int i;
+
+	if ((len & 1) != 0 || (offset & 1) != 0)
+		return -EINVAL;
+
+	if (ee->magic != DM_EEPROM_MAGIC)
+		return -EINVAL;
+
+	for (i = 0; i < len; i += 2)
+		dm_write_eeprom_func(dm, (offset + i) / 2, data + i);
+	return 0;
+}
+
+static
+const struct ethtool_ops dm9051_ethtool_ops = {
+	.get_drvinfo = dm9051_get_drvinfo,
+	.get_link_ksettings = dm9051_get_link_ksettings,
+	.set_link_ksettings = dm9051_set_link_ksettings,
+	.get_msglevel = dm9051_get_msglevel,
+	.set_msglevel = dm9051_set_msglevel,
+	.nway_reset = dm9051_nway_reset,
+	.get_link = dm9051_get_link,
+	.get_eeprom_len = dm9051_get_eeprom_len,
+	.get_eeprom = dm9051_get_eeprom,
+	.set_eeprom = dm9051_set_eeprom,
+};
+
+static void dm_operation_clear(struct board_info *db)
+{
+	db->bc.mac_ovrsft_counter = 0;
+	db->bc.large_err_counter = 0;
+	db->bc.DO_FIFO_RST_counter = 0;
+	db->enter_hash = 0;
+	db->enter_setmac = 0;
+}
+
+/* reset and increase the RST counter
+ */
+static void dm9051_fifo_reset(u8 state, u8 *hstr, struct board_info *db)
+{
+	db->bc.DO_FIFO_RST_counter++;
+	dm9051_reset(db);
+}
+
+static void dm9051_reset_dm9051(struct board_info *db, int rxlen)
+{
+	struct net_device *ndev = db->ndev;
+	char *sbuff = (char *)db->prxhdr;
+	char hstr[72];
+
+	netdev_dbg(ndev, "dm9-pkt-Wrong RxLen over-range (%x= %d > %x= %d)\n",
+		   rxlen, rxlen, DM9051_PKT_MAX, DM9051_PKT_MAX);
+
+	db->bc.large_err_counter++;
+	db->bc.mac_ovrsft_counter++; //increase the MAC over_shift counter
+	dm9051_fifo_reset(11, hstr, db);
+	sprintf(hstr, "dmfifo_reset( 11 RxLenErr ) rxhdr %02x %02x %02x %02x (quick)",
+		sbuff[0], sbuff[1], sbuff[2], sbuff[3]);
+	netdev_dbg(ndev, "%s\n", hstr);
+	netdev_dbg(ndev, " RxLenErr&MacOvrSft_Er %d, RST_c %d\n",
+		   db->bc.mac_ovrsft_counter, db->bc.DO_FIFO_RST_counter);
+}
+
+/* loop rx
+ */
+static int dm9051_lrx(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+	u8 rxbyte;
+	int rxlen;
+	char sbuff[DM_RXHDR_SIZE];
+	struct sk_buff *skb;
+	u8 *rdptr;
+	int scanrr = 0;
+
+	while (1) {
+		rxbyte = ior(db, DM_SPI_MRCMDX); //Dummy read
+		rxbyte = ior(db, DM_SPI_MRCMDX); //Dummy read
+		if (rxbyte != DM9051_PKT_RDY) {
+			isr_reg_clear_to_stop_mrcmd(db);
+			break; //exhaust-empty
+		}
+		dm9inblk(db, sbuff, DM_RXHDR_SIZE);
+		isr_reg_clear_to_stop_mrcmd(db);
+
+		db->prxhdr = (struct dm9051_rxhdr *)sbuff;
+		if (db->prxhdr->rxstatus & 0xbf) {
+			netdev_dbg(ndev, "warn : rxhdr.status 0x%02x\n",
+				   db->prxhdr->rxstatus);
+		}
+		if (db->prxhdr->rxlen > DM9051_PKT_MAX) {
+			dm9051_reset_dm9051(db, rxlen);
+			return scanrr;
+		}
+
+		rxlen = db->prxhdr->rxlen;
+		skb = dev_alloc_skb(rxlen + 4);
+		if (!skb) {
+			netdev_dbg(ndev, "alloc skb size %d fail\n", rxlen + 4);
+			return scanrr;
+		}
+		skb_reserve(skb, 2);
+		rdptr = (u8 *)skb_put(skb, rxlen - 4);
+
+		dm9inblk(db, rdptr, rxlen);
+		isr_reg_clear_to_stop_mrcmd(db);
+
+		skb->protocol = eth_type_trans(skb, db->ndev); //JJ found: skb->len -= 14
+		if (db->ndev->features & NETIF_F_RXCSUM)
+			skb_checksum_none_assert(skb);
+		if (in_interrupt())
+			netif_rx(skb);
+		else
+			netif_rx_ni(skb);
+		db->ndev->stats.rx_bytes += rxlen;
+		db->ndev->stats.rx_packets++;
+		scanrr++;
+	}
+	return scanrr;
+}
+
+/* single tx
+ */
+static int dm9051_stx(struct board_info *db, u8 *buff, unsigned int len)
+{
+	int ret;
+	u8 check_val;
+
+	/* shorter waiting time with tx-end check JJ20210617 */
+	ret = read_poll_timeout(ior, check_val, check_val & (NSR_TX2END | NSR_TX1END),
+				1, 20, false, db, DM9051_NSR);
+	dm9outblk(db, buff, len);
+	iow(db, DM9051_TXPLL, len);
+	iow(db, DM9051_TXPLH, len >> 8);
+	iow(db, DM9051_TCR, TCR_TXREQ);
+	return ret;
+}
+
+static int dm9051_send(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+	int ntx = 0;
+
+	while (!skb_queue_empty(&db->txq)) { //when !empty, JJ20140225
+		struct sk_buff *skb;
+
+		skb = dm_sk_buff_get(db);
+		if (skb) {
+			ntx++;
+			if (dm9051_stx(db, skb->data, skb->len))
+				netdev_dbg(ndev, "timeout %d--- WARNING---do-ntx\n", ntx);
+			ndev->stats.tx_bytes += skb->len;
+			ndev->stats.tx_packets++;
+			dev_kfree_skb(skb); //done
+		}
+	}
+	return ntx;
+}
+
+static void dm_msg_open(struct net_device *ndev)
+{
+	struct board_info *db = netdev_priv(ndev);
+	struct device *dev = &db->spidev->dev;
+
+	snprintf(db->DRV_VERSION, sizeof(db->DRV_VERSION), "%s_V%d.%d.%d_date_%s",
+		 DRV_PRODUCT_NAME, (DRV_VERSION_CODE >> 16 & 0xff),
+		 (DRV_VERSION_CODE >> 8 & 0xff),
+		 (DRV_VERSION_CODE & 0xff),
+		 DRV_VERSION_DATE);
+	dev_info(dev, "version: %s\n", db->DRV_VERSION);
+}
+
+/* end with enable the interrupt mask
+ */
+static irqreturn_t dm9051_rx_threaded_irq(int irq, void *pw)
+{
+	struct board_info *db = pw;
+	int nrx;
+
+	mutex_lock(&db->spi_lock); //dlywork essential
+	dm_imr_disable_lock_essential(db); //set imr disable
+	if (netif_carrier_ok(db->ndev)) {
+		mutex_lock(&db->addr_lock);
+		do {
+			nrx = dm9051_lrx(db);
+			dm9051_send(db); //+ more performance (yes)
+		} while (nrx);
+		mutex_unlock(&db->addr_lock);
+	}
+	dm_imr_enable_lock_essential(db); //set imr enable
+	mutex_unlock(&db->spi_lock); //dlywork essential
+	return IRQ_HANDLED;
+}
+
+/* end with enable the interrupt mask
+ */
+static int dm_opencode_receiving(struct net_device *ndev, struct board_info *db)
+{
+	int ret;
+	struct spi_device *spi = db->spidev;
+
+	ndev->irq = spi->irq; //by dts
+	ret = request_threaded_irq(spi->irq, NULL, dm9051_rx_threaded_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   ndev->name, db);
+	if (ret < 0) {
+		netdev_err(ndev, "failed to get irq\n");
+		return ret;
+	}
+	dm_imr_enable_lock_essential(db);
+	schedule_delayed_work(&db->phy_poll, HZ * 1); //sched_start
+	netdev_info(ndev, "[dm_open] %pM irq_no %d ACTIVE_LOW\n", ndev->dev_addr, ndev->irq);
+	return 0;
+}
+
+static void int_tx_delay(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct board_info *db = container_of(dw, struct board_info, tx_work);
+
+	mutex_lock(&db->spi_lock); //dlywork essential
+	mutex_lock(&db->addr_lock);
+	dm9051_send(db);
+	mutex_unlock(&db->addr_lock);
+	mutex_unlock(&db->spi_lock); //dlywork essential
+}
+
+static void int_rxctl_delay(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct board_info *db = container_of(dw, struct board_info, rxctrl_work);
+
+	dm_set_multicast_list_lock(db);
+}
+
+static void int_setmac_delay(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct board_info *db = container_of(dw, struct board_info, setmac_work);
+
+	dm_set_mac_lock(db);
+}
+
+static void int_phy_poll(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct board_info *db = container_of(dw, struct board_info, phy_poll);
+
+	dm_carrier_poll(db);
+	schedule_delayed_work(&db->phy_poll, HZ * 1);
+}
+
+/* Irq free and schedule delays cancel
+ */
+static void dm_stopcode_release(struct board_info *db)
+{
+	free_irq(db->spidev->irq, db);
+	cancel_delayed_work_sync(&db->phy_poll);
+	cancel_delayed_work_sync(&db->rxctrl_work);
+	cancel_delayed_work_sync(&db->setmac_work);
+	cancel_delayed_work_sync(&db->tx_work);
+}
+
+static void dm_control_objects_init(struct board_info *db)
+{
+	mutex_init(&db->spi_lock);
+	mutex_init(&db->addr_lock);
+	INIT_DELAYED_WORK(&db->phy_poll, int_phy_poll);
+	INIT_DELAYED_WORK(&db->rxctrl_work, int_rxctl_delay);
+	INIT_DELAYED_WORK(&db->setmac_work, int_setmac_delay);
+	INIT_DELAYED_WORK(&db->tx_work, int_tx_delay);
+}
+
+static void dm9051_init_dm9051(struct net_device *dev)
+{
+	struct board_info *db = netdev_priv(dev);
+
+	dm9051_fifo_reset(1, NULL, db);
+	imr_reg_stop(db);
+}
+
+static void dm9051_init_display(struct board_info *db)
+{
+	ledcr_wr_disp(db); //empty.hook
+	//ledcr_reg_disp(db); //empty.hook
+	dbg_spibcr_peek(db); //empty.hook
+}
+
+static void dm_opencode_lock(struct net_device *dev, struct board_info *db)
+{
+	mutex_lock(&db->addr_lock); //Note: must
+	iow(db, DM9051_GPR, 0); //Note: Reg 1F is not set by reset, REG_1F bit0 activate phyxcer
+	mdelay(1); //delay needs for activate phyxcer
+	db->imr_all = IMR_PAR | IMR_PRM;
+	db->rcr_all = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
+	db->lcr_all = LMCR_MODE1;
+	dm9051_init_dm9051(dev);
+	dm9051_init_display(db);
+	mutex_unlock(&db->addr_lock);
+}
+
+static void dm_stopcode_lock(struct board_info *db)
+{
+	mutex_lock(&db->addr_lock);
+	dm_phy_write_func(db, MII_BMCR, BMCR_RESET); //PHY RESET
+	iow(db, DM9051_GPR, 0x01); //Power-Down PHY
+	rcr_reg_stop(db); //Disable RX
+	mutex_unlock(&db->addr_lock);
+}
+
+static void dm_opencode_net(struct net_device *ndev, struct board_info *db)
+{
+	dm_sk_buff_head_init(db); //skb_queue_head_init
+	netif_start_queue(ndev);
+	netif_wake_queue(ndev);
+	dm_carrier_init(db); //mii_check_
+}
+
+static void dm_stopcode_net(struct net_device *ndev)
+{
+	netif_stop_queue(ndev);
+	dm_carrier_off(ndev); //_carrier_off
+}
+
+/* Open network device
+ * Called when the network device is marked active, such as a user executing
+ * 'ifconfig up' on the device.
+ */
+static int dm9051_open(struct net_device *ndev)
+{
+	struct board_info *db = netdev_priv(ndev);
+
+	dm_msg_open(ndev);
+	dm_opencode_lock(ndev, db);
+	dm_opencode_net(ndev, db);
+	return dm_opencode_receiving(ndev, db);
+}
+
+/* Close network device
+ * Called to close down a network device which has been active. Cancell any
+ * work, shutdown the RX and TX process and then place the chip into a low
+ * power state while it is not being used.
+ */
+static int dm9051_stop(struct net_device *ndev)
+{
+	struct board_info *db = netdev_priv(ndev);
+
+	dm_stopcode_release(db);
+	dm_stopcode_net(ndev);
+	dm_stopcode_lock(db);
+	return 0;
+}
+
+/* event: play a schedule starter in condition
+ */
+static netdev_tx_t dm9051_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct board_info *db = netdev_priv(dev);
+
+	dm_sk_buff_set(db, skb); //JJ: a skb add
+	schedule_delayed_work(&db->tx_work, 0);
+	return NETDEV_TX_OK;
+}
+
+/* event: play with a schedule starter
+ */
+static void dm9051_set_multicast_list_schedule(struct net_device *ndev)
+{
+	struct board_info *db = netdev_priv(ndev);
+
+	db->enter_hash = 1;
+	schedule_delayed_work(&db->rxctrl_work, 0);
+}
+
+/* event: NOT play with a schedule starter! will iow() directly.
+ */
+static int dm9051_set_mac_address(struct net_device *ndev, void *p)
+{
+	struct board_info *db = netdev_priv(ndev);
+	int ret = eth_mac_addr(ndev, p);
+
+	if (ret < 0)
+		return ret;
+	db->enter_setmac = 1;
+	schedule_delayed_work(&db->setmac_work, 0);
+	return 0;
+}
+
+/* probe subs
+ */
+static void dm_netdev_and_db(struct net_device *ndev, struct board_info *db)
+{
+	ndev->mtu = 1500;
+	ndev->if_port = IF_PORT_100BASET;
+	ndev->netdev_ops = &dm9051_netdev_ops;
+	ndev->ethtool_ops = &dm9051_ethtool_ops;
+	db->mii.dev = ndev;
+	db->mii.phy_id = 1;
+	db->mii.phy_id_mask = 1;
+	db->mii.reg_num_mask = 0x1f;
+	db->mii.mdio_read = dm9051_phy_read_lock;
+	db->mii.mdio_write = dm9051_phy_write_lock;
+}
+
+static void dm_spimsg_addtail(struct board_info *db)
+{
+	memset(&db->spi_xfer2, 0, sizeof(struct spi_transfer) * 2);
+	spi_message_init(&db->spi_msg2);
+	spi_message_add_tail(&db->spi_xfer2[0], &db->spi_msg2);
+	spi_message_add_tail(&db->spi_xfer2[1], &db->spi_msg2);
+}
+
+static int dm_chipid_detect(struct device *dev, struct board_info *db)
+{
+	if (dm9051_chipid(dev, db) == DM9051_ID)
+		return 0;
+	return -ENODEV;
+}
+
+static int dm9051_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct net_device *ndev;
+	struct board_info *db;
+	int ret = 0;
+
+	ndev = alloc_etherdev(sizeof(struct board_info));
+	if (!ndev)
+		return -ENOMEM;
+	SET_NETDEV_DEV(ndev, dev);
+	dev_set_drvdata(dev, ndev);
+	db = netdev_priv(ndev);
+	memset(db, 0, sizeof(struct board_info));
+	db->msg_enable = 0;
+	db->spidev = spi;
+	db->ndev = ndev;
+	dm_netdev_and_db(ndev, db);
+
+	dm_spimsg_addtail(db);
+	dm_control_objects_init(db); //init_delayed_works
+	ret = dm_chipid_detect(dev, db); //access to dm9051
+	if (ret) {
+		dev_err(dev, "chip id error\n");
+		goto err_netdev;
+	}
+	dm9051_read_mac_to_dev(dev, ndev, db);
+	ret = register_netdev(ndev);
+	if (ret) {
+		dev_err(dev, "failed to register network device\n");
+		goto err_netdev;
+	}
+	dm_operation_clear(db); //only in probe
+	dm_carrier_off(ndev); //_carrier_off
+	return 0;
+err_netdev:
+	free_netdev(ndev);
+	return ret;
+}
+
+static int dm9051_drv_remove(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct board_info *db = netdev_priv(ndev);
+
+	unregister_netdev(db->ndev);
+	free_netdev(db->ndev);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+//[User must config KConfig to PM_SLEEP for the power-down function!!]
+static int dm9051_drv_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct board_info *db = netdev_priv(ndev);
+
+	if (netif_running(ndev)) {
+		netif_carrier_off(ndev);
+		netif_device_detach(ndev);
+
+		dm_stopcode_lock(db);
+	}
+	return 0;
+}
+
+static int dm9051_drv_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct board_info *db = netdev_priv(ndev);
+
+	if (netif_running(ndev)) {
+		dm_opencode_lock(ndev, db);
+		dm_imr_enable_lock_essential(db);
+
+		netif_device_attach(ndev);
+		netif_carrier_on(ndev);
+	}
+	return 0;
+}
+#endif //DM_PM_SLEEP
+
+static SIMPLE_DEV_PM_OPS(dm9051_drv_pm_ops, dm9051_drv_suspend, dm9051_drv_resume); //DM_PM_SLEEP
+
+static struct spi_driver dm9051_driver = {
+	.driver = {
+		.name = DRVNAME_9051,
+		.owner = THIS_MODULE,
+		.pm = &dm9051_drv_pm_ops, //DM_PM_SLEEP
+		.of_match_table = dm9051_match_table,
+		.bus = &spi_bus_type,
+	},
+	.probe = dm9051_probe,
+	.remove = dm9051_drv_remove,
+	.id_table = &dm9051_spi_id_table,
+};
+module_spi_driver(dm9051_driver);
+
+MODULE_AUTHOR("Joseph CHANG <joseph_chang@davicom.com.tw>");
+MODULE_DESCRIPTION("Davicom DM9051 network SPI driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/davicom/dm9051.h b/drivers/net/ethernet/davicom/dm9051.h
new file mode 100644
index 000000000000..ecf102d3f0af
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.h
@@ -0,0 +1,248 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2021 Davicom Semiconductor,Inc.
+ *	http://www.davicom.com.tw
+ *	2014/03/11  Joseph CHANG  v1.0  Create
+ *	2021/10/26  Joseph CHANG  v5.0.1  Update
+ *	2021/12/09  Joseph CHANG  v5.0.5  Update
+ *
+ * DM9051 register definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
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
+//0x00
+#define NCR_WAKEEN		BIT(6)
+#define NCR_FDX			BIT(3)
+#define NCR_RST			BIT(0)
+//0x02
+#define TCR_DIS_JABBER_TIMER	BIT(6) /* for Jabber Packet support */
+#define TCR_TXREQ		BIT(0)
+//0x01
+#define NSR_SPEED		BIT(7)
+#define NSR_LINKST		BIT(6)
+#define NSR_WAKEST		BIT(5)
+#define NSR_TX2END		BIT(3)
+#define NSR_TX1END		BIT(2)
+//0x05
+#define RCR_DIS_WATCHDOG_TIMER	BIT(6)  /* for Jabber Packet support */
+#define RCR_DIS_LONG		BIT(5)
+#define RCR_DIS_CRC		BIT(4)
+#define RCR_ALL			BIT(3)
+#define RCR_PRMSC		BIT(1)
+#define RCR_RXEN		BIT(0)
+#define RCR_RX_DISABLE		(RCR_DIS_LONG | RCR_DIS_CRC)
+//0x06
+#define RSR_RF			BIT(7)
+#define RSR_MF			BIT(6)
+#define RSR_LCS			BIT(5)
+#define RSR_RWTO		BIT(4)
+#define RSR_PLE			BIT(3)
+#define RSR_AE			BIT(2)
+#define RSR_CE			BIT(1)
+#define RSR_FOE			BIT(0)
+//0x0A
+#define FCR_TXPEN		BIT(5)
+#define FCR_BKPM		BIT(3)
+#define FCR_FLCE		BIT(0)
+#define FCR_FLOW_ENABLE		(FCR_TXPEN | FCR_BKPM | FCR_FLCE)
+//0x0B
+#define EPCR_WEP		BIT(4)
+#define EPCR_EPOS		BIT(3)
+#define EPCR_ERPRR		BIT(2)
+#define EPCR_ERPRW		BIT(1)
+#define EPCR_ERRE		BIT(0)
+//0x1E
+#define GPCR_GEP_CNTL		BIT(0)
+//0x30
+#define	ATCR_AUTO_TX		BIT(7)
+//0x39
+#define INTCR_POL_LOW		BIT(0)
+#define INTCR_POL_HIGH		(0 << 0)
+//0x3D
+// Pause Packet Control Register - default = 1
+#define PPCR_PAUSE_COUNT	0x08
+//0x55
+#define MPCR_RSTTX		BIT(1)
+#define MPCR_RSTRX		BIT(0)
+//0x57
+// LEDMode Control Register - LEDMode1
+// Value 0x81 : bit[7] = 1, bit[2] = 0, bit[1:0] = 01b
+#define LMCR_NEWMOD		BIT(7)
+#define LMCR_TYPED1		BIT(1)
+#define LMCR_TYPED0		BIT(0)
+#define LMCR_MODE1		(LMCR_NEWMOD | LMCR_TYPED0)
+//0x5E
+#define MBNDRY_BYTE		BIT(7)
+//0xFE
+#define ISR_MBS			BIT(7)
+#define ISR_ROOS		BIT(3)
+#define ISR_ROS			BIT(2)
+#define ISR_PTS			BIT(1)
+#define ISR_PRS			BIT(0)
+#define ISR_CLR_STATUS		(ISR_ROOS | ISR_ROS | ISR_PTS | ISR_PRS)
+//0xFF
+#define IMR_PAR			BIT(7)
+#define IMR_LNKCHGI		BIT(5)
+#define IMR_PTM			BIT(1)
+#define IMR_PRM			BIT(0)
+
+/* Const
+ */
+#define DM9051_PHY		0x40	/* PHY address 0x01 */
+#define DM9051_PKT_RDY		0x01	/* Packet ready to receive */
+#define DM9051_PKT_MAX		1536	/* Received packet max size */
+#define DM_EEPROM_MAGIC		(0x9051)
+
+/* netdev_ops
+ */
+static int dm9051_open(struct net_device *dev);
+static int dm9051_stop(struct net_device *dev);
+static netdev_tx_t dm9051_start_xmit(struct sk_buff *skb, struct net_device *dev);
+static void dm9051_set_multicast_list_schedule(struct net_device *dev);
+static int dm9051_set_mac_address(struct net_device *dev, void *p);
+
+static inline struct board_info *to_dm9051_board(struct net_device *dev)
+{
+	return netdev_priv(dev);
+}
+
+/* Driver information
+ */
+#define DM_VERSION(a, b, c)			\
+	(((a) << 16) + ((b) << 8) + (c))
+
+/* carrier
+ */
+#define	dm_carrier_init(db)			mii_check_link(&(db)->mii)
+#define	dm_carrier_poll(db)			mii_check_link(&(db)->mii)
+#define	dm_carrier_off(dev)			netif_carrier_off(dev)
+
+/* xmit support
+ */
+#define	dm_sk_buff_head_init(db)		skb_queue_head_init(&(db)->txq)
+#define	dm_sk_buff_get(db)			skb_dequeue(&(db)->txq)
+#define	dm_sk_buff_set(db, skb)			skb_queue_tail(&(db)->txq, skb)
+
+/* spi transfers
+ */
+#define ior					std_spi_read_reg			//info.ior
+#define iior					disp_spi_read_reg			//info.iior
+#define iow					std_spi_write_reg			//info.iow
+#define dm9inblk				std_read_rx_buf_ncpy			//dm.inblk
+#define dm9outblk				std_write_tx_buf			//dm.outblk
+
+#define	ncr_reg_reset(db)			iow(db, DM9051_NCR, NCR_RST)		// reset
+#define	mbd_reg_byte(db)			iow(db, DM9051_MBNDRY, MBNDRY_BYTE)	// MemBound
+#define	fcr_reg_enable(db)			iow(db, DM9051_FCR, FCR_FLOW_ENABLE)	// FlowCtrl
+#define	ppcr_reg_seeting(db)			iow(db, DM9051_PPCR, PPCR_PAUSE_COUNT)	// PauPktCn
+#define	isr_reg_clear_to_stop_mrcmd(db)		iow(db, DM9051_ISR, 0xff)		// ClearISR
+#define rcr_reg_stop(db)			iow(db, DM9051_RCR, RCR_RX_DISABLE)	// DisabRX
+#define imr_reg_stop(db)			iow(db, DM9051_IMR, IMR_PAR)		// DisabAll
+#define rcr_reg_start(db, rcr_all)		iow(db, DM9051_RCR, rcr_all)		// EnabRX
+#define imr_reg_start(db, imr_all)		iow(db, DM9051_IMR, imr_all)		// Re-enab
+#define	intcr_reg_setval(db)			iow(db, DM9051_INTCR, INTCR_POL_LOW)	// INTCR
+#define	ledcr_reg_setting(db, lcr_all)		iow(db, DM9051_LMCR, lcr_all)		// LEDMode1
+
+/* display functions skelton
+ */
+#define ledcr_wr_disp(db)
+#define	ledcr_reg_disp(db)
+#define dbg_spibcr_peek(db)
+
+/* structure definitions
+ */
+struct rx_ctl_mach {
+	u16				large_err_counter;  /* The error of 'Large Err' */
+	u16				mac_ovrsft_counter;  /* The error of 'MacOvrSft_Er' */
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
+	u8				cmd[2] ____cacheline_aligned;
+	struct spi_transfer		spi_xfer2[2] ____cacheline_aligned;
+	struct spi_message		spi_msg2 ____cacheline_aligned;
+	struct rx_ctl_mach		bc ____cacheline_aligned;
+	struct dm9051_rxhdr		*prxhdr ____cacheline_aligned;
+	struct spi_device		*spidev;
+	struct net_device		*ndev;
+	struct mii_if_info		mii;
+	struct sk_buff_head		txq;
+	struct mutex			spi_lock;	// delayed_work's lock
+	struct mutex			addr_lock;	// dm9051's REG lock
+	struct delayed_work		phy_poll;
+	struct delayed_work		rxctrl_work;
+	struct delayed_work		setmac_work;
+	struct delayed_work		tx_work;
+	struct delayed_work		rx_work;
+	u32				msg_enable ____cacheline_aligned;
+	u8				imr_all;
+	u8				rcr_all;
+	u8				lcr_all;
+	u16				enter_hash;
+	u16				enter_setmac;
+	char				DRV_VERSION[50];
+};
+
+#define	DM_RXHDR_SIZE			sizeof(struct dm9051_rxhdr)
+
+#endif /* _DM9051_H_ */
-- 
2.20.1

