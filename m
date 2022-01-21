Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A144B4958DB
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348582AbiAUEPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiAUEPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:15:07 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860F9C06173F;
        Thu, 20 Jan 2022 20:15:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o64so8303553pjo.2;
        Thu, 20 Jan 2022 20:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:signed-off-by:content-transfer-encoding;
        bh=r9WO05u7IBRBajOfCq24MZOY0DW73uYvy4U+0v+7Jk8=;
        b=DjHK3IQOotq0X8/tph9cFedATscAzqqDigsC9I1VNtN1vIhYXnSeici01tacUWEQJi
         txtPWYsJuBMuKrNpV7xdoLU/9HuBAU7BxLl54yR1FXF6Wu0FOMdPyZSdqQfnA37S31C+
         JXEjkyiVcxNN67I8yINjz0EVmTIGRZb4EzFQlT725jBKJKw9uQZxAC7f9MSjwIgZKZMP
         EqaRExnAh2EoEQhHsz99H3ymbBn8Ilh4FIBIdcJEIeSIbeniDoPT7jC53y66pOk5E7O5
         Xb2csBMZk6yDkpEv+3MdcvcbQet7xMaBdG62XXWZP5qeJxqhZLavWLFYzoMmkLtHLcph
         Vo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:signed-off-by:content-transfer-encoding;
        bh=r9WO05u7IBRBajOfCq24MZOY0DW73uYvy4U+0v+7Jk8=;
        b=RsihgDvLV338WoJzpmnvtuIyRL7sDfuHNTpkrlJXaeQdTEEg7GH+sUYebpW2E2BKcJ
         PM2IkxdOWQd0vynAYGvjxf8tz2usGidTUUrBSbUFOG26/yx7GFRH6KeCEoxyr17wGAT+
         OBvooSJCRUvD0Sm9ww+3iW32I8AUE+eTcbXYG0n+x7BF456bG8zsLkKKG7NrnzZms0n/
         wdYwD9sLGpkF1fwAIKbSFoeIN/r98H3U6yKQVTmfTFXq3JJqH4w6AyI7GRSrFRSr78ld
         0/IPtBOoscvJsKyi26IOtwKyblW28pNHHTT7lmrkVhKKfB3Y8J3TygJ5xx66rX+P2BzU
         gyhg==
X-Gm-Message-State: AOAM530XC+t7lT1CNY7+kVB+1VB27kaAlOYL/CvTRF6K+lSdPewcz1EG
        uDtlnLM1QlXvUe+8lgf8lyja2tpcA2E5/w==
X-Google-Smtp-Source: ABdhPJwt6Z8vbVmuWOH/aZ4jMBQPavwreC9JU2yPuC1M1UnX83660FVqwaD5fDNzQRDwtC4KsDu66w==
X-Received: by 2002:a17:90a:de01:: with SMTP id m1mr14676853pjv.215.1642738505570;
        Thu, 20 Jan 2022 20:15:05 -0800 (PST)
Received: from localhost.localdomain (61-231-118-42.dynamic-ip.hinet.net. [61.231.118.42])
        by smtp.gmail.com with ESMTPSA id j1sm4937614pfu.4.2022.01.20.20.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 20:15:05 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, Leon Romanovsky <leon@kernel.org>
Subject: [PATCH v12, 2/2] net: Add dm9051 driver
Date:   Fri, 21 Jan 2022 12:14:28 +0800
Message-Id: <20220121041428.6437-3-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220121041428.6437-1-josright123@gmail.com>
References: <20220121041428.6437-1-josright123@gmail.com>
MIME-Version: 1.0
Signed-off-by: Joseph CHAMG <josright123@gmail.com>
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

v10

use regmap APIs for SPI and MDIO,
modify to correcting such as include header files
and program check styles

v11

eliminate the redundant code for struct regmap_config data
use regmap_read_poll_timeout
use corresponding regmap APIs, i.e. MDIO, SPI
all read/write registers by regmap
all read/write registers with mutex lock by regmap
problem: regmap MDIO and SPI has no .reg_update_bits, I write it
in the driver
problem: this chip can support bulk read/write to rx/tx data, but
can not support bulk read/write to continue registers, so need
read/write register one by one

v12

correctly use regmap bulk read/write/update_bits APIs
use mdiobus to work to phylib and to this driver
fine tune to arrange the source code to better usage

---
 drivers/net/ethernet/davicom/Kconfig  |   31 +
 drivers/net/ethernet/davicom/Makefile |    1 +
 drivers/net/ethernet/davicom/dm9051.c | 1180 +++++++++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h |  159 ++++
 4 files changed, 1371 insertions(+)
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h

diff --git a/drivers/net/ethernet/davicom/Kconfig b/drivers/net/ethernet/davicom/Kconfig
index 7af86b6d4150..02e0caff98e3 100644
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
@@ -22,3 +35,21 @@ config DM9000_FORCE_SIMPLE_PHY_POLL
 	  bit to determine if the link is up or down instead of the more
 	  costly MII PHY reads. Note, this will not work if the chip is
 	  operating with an external PHY.
+
+config DM9051
+	tristate "DM9051 SPI support"
+	depends on SPI
+	select CRC32
+	select MDIO
+	select PHYLIB
+	select REGMAP_SPI
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
index 000000000000..42d383fe84e7
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -0,0 +1,1180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022 Davicom Semiconductor,Inc.
+ * Davicom DM9051 SPI Fast Ethernet Linux driver
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/interrupt.h>
+#include <linux/iopoll.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/regmap.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/spi/spi.h>
+
+#include "dm9051.h"
+
+/**
+ * struct rx_ctl_mach - rx activities record
+ *
+ * @status_err_counter: rx status error counter
+ * @large_err_counter: rx get large packet length error counter
+ * @fifo_rst_counter: reset operation counter
+ *
+ * To keep track for the driver operation statistics
+ */
+struct rx_ctl_mach {
+	u16				status_err_counter;
+	u16				large_err_counter;
+	u16				fifo_rst_counter;
+};
+
+/**
+ * struct dm9051_rxhdr - rx packet data header
+ *
+ * @rxpktready: lead byte is 0x01 tell a valid packet
+ * @rxstatus: status bits for the received packet
+ * @rxlen: packet length
+ *
+ * The rx packet enter into the fifo memory is start with these four
+ * bytes which is the rx header, follow this header is the ethernet
+ * packet data and end with a appended 4-byte CRC data.
+ * Both rx packet and CRC data are for check purpose and finally are
+ * dropped by this driver
+ */
+struct dm9051_rxhdr {
+	u8				rxpktready;
+	u8				rxstatus;
+	__le16				rxlen;
+};
+
+/**
+ * struct board_info - maintain the saved data
+ *
+ * @spidev: spi device structure
+ * @ndev: net device structure
+ * @mdiobus: mii bus structure
+ * @phydev: phy device structure
+ * @txq: tx queue structure
+ * @regmap_dm: regmap for register read/write
+ * @regmap_dmbulk: extra regmap for bulk read/write
+ * @kwr_task_kw: kwr task structure
+ * @kw: kernel thread worker structure
+ * @kw_rxctrl: kernel thread worke structure for rx control
+ * @kw_tx: kernel thread worke structure for transmit
+ * @eth_pause: ethtool pause parameter structure
+ * @spi_lockm: between threads lock structure
+ * @reg_mutex: regmap access lock structure
+ * @bc: rx control statistics structure
+ * @eth_rxhdr: rx header structure
+ * @msg_enable: message level value
+ * @hash_table: hash table
+ * @imr_all: to store operating imr value for register DM9051_IMR
+ * @rcr_all: to store operating rcr value for register DM9051_RCR
+ * @lcr_all: to store operating rcr value for register DM9051_LMCR
+ *
+ * The saved data variables, keep up to date for retrieval back to use
+ */
+struct board_info {
+	struct spi_device		*spidev;
+	struct net_device		*ndev;
+	struct mii_bus			*mdiobus;
+	struct phy_device		*phydev;
+	struct sk_buff_head		txq;
+	struct regmap			*regmap_dm;
+	struct regmap			*regmap_dmbulk;
+	struct task_struct		*kwr_task_kw;
+	struct kthread_worker		kw;
+	struct kthread_work		kw_rxctrl;
+	struct kthread_work		kw_tx;
+	struct ethtool_pauseparam	eth_pause;
+	struct mutex			spi_lockm;
+	struct mutex			reg_mutex;
+	struct rx_ctl_mach		bc;
+	struct dm9051_rxhdr		eth_rxhdr;
+	u32				msg_enable;
+	u16				hash_table[4];
+	u8				imr_all;
+	u8				rcr_all;
+	u8				lcr_all;
+};
+
+/* waiting tx-end rather than tx-req
+ * got faster
+ */
+static int dm9051_map_xmitpoll(struct board_info *db)
+{
+	unsigned int mval;
+	int ret = regmap_read_poll_timeout(db->regmap_dm, DM9051_NSR, mval,
+					   mval & (NSR_TX2END | NSR_TX1END), 1, 20);
+
+	if (unlikely(ret))
+		netdev_err(db->ndev, "timeout in checking for tx ends\n");
+	return ret;
+}
+
+static int dm9051_map_ee_phypoll(struct board_info *db)
+{
+	unsigned int mval;
+	int ret = regmap_read_poll_timeout(db->regmap_dm, DM9051_EPCR, mval,
+					   !(mval & EPCR_ERRE), 100, 10000);
+
+	if (unlikely(ret))
+		netdev_err(db->ndev, "eeprom/phy in processing get timeout\n");
+	return ret;
+}
+
+static int dm9051_map_eeread(struct board_info *db, int offset, u8 *to)
+{
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, offset);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_ERPRR);
+	if (unlikely(ret))
+		return ret;
+	ret = dm9051_map_ee_phypoll(db);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, 0x0);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_EPDRL, to, 2);
+	if (unlikely(ret))
+		return ret;
+	return ret;
+}
+
+static int dm9051_map_eewrite(struct board_info *db, int offset, u8 *data)
+{
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, offset);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_EPDRL, data, 2);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_WEP | EPCR_ERPRW);
+	if (unlikely(ret))
+		return ret;
+	ret = dm9051_map_ee_phypoll(db);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, 0);
+	if (unlikely(ret))
+		return ret;
+	return ret;
+}
+
+static int ctrl_dm9051_phyread(void *context, unsigned int reg, unsigned int *val)
+{
+	struct board_info *db = context;
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, DM9051_PHY | reg);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
+	if (unlikely(ret))
+		return ret;
+	ret = dm9051_map_ee_phypoll(db);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, 0x0);
+	if (unlikely(ret))
+		return ret;
+
+	/* this is a 4 bytes data, clear to zero since following regmap_bulk_read
+	 * only fill lower 2 bytes
+	 */
+	*val = 0;
+	ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_EPDRL, val, 2);
+	if (unlikely(ret))
+		return ret;
+	return ret;
+}
+
+static int ctrl_dm9051_phywrite(void *context, unsigned int reg, unsigned int val)
+{
+	struct board_info *db = context;
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, DM9051_PHY | reg);
+	if (unlikely(ret))
+		return ret;
+
+	/* this is a 2 bytes data written via regmap_bulk_write
+	 */
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_EPDRL, &val, 2);
+	if (unlikely(ret))
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
+	if (unlikely(ret))
+		return ret;
+	ret = dm9051_map_ee_phypoll(db);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, 0x0);
+	if (unlikely(ret))
+		return ret;
+
+	/* chip internal operation need wait 1 ms for if power-up phy
+	 */
+	if (reg == MII_BMCR && !(val & BMCR_PDOWN))
+		mdelay(1);
+	return ret;
+}
+
+static int dm9051_mdiobus_read(struct mii_bus *mdiobus, int phy_id, int reg)
+{
+	struct board_info *db = mdiobus->priv;
+	unsigned int val = 0;
+	int ret;
+
+	if (phy_id == DM9051_PHY_ID) {
+		ret = ctrl_dm9051_phyread(db, reg, &val);
+		if (unlikely(ret))
+			return ret;
+		return val;
+	}
+	return 0xffff;
+}
+
+static int dm9051_mdiobus_write(struct mii_bus *mdiobus, int phy_id, int reg, u16 val)
+{
+	struct board_info *db = mdiobus->priv;
+	int ret;
+
+	if (phy_id == DM9051_PHY_ID) {
+		ret = ctrl_dm9051_phywrite(db, reg, val);
+		if (unlikely(ret))
+			return ret;
+		return 0;
+	}
+	return -ENODEV;
+}
+
+/* skb buffer exhausted, just discard the received data
+ */
+static int dm9051_map_dumpblk(struct board_info *db, u8 reg, size_t count)
+{
+	struct net_device *ndev = db->ndev;
+	unsigned int rb;
+	int ret;
+
+	/* no skb buffer,
+	 * both reg and &rb must be noinc,
+	 * read once one byte via regmap_read
+	 */
+	while (count--) {
+		ret = regmap_read(db->regmap_dm, reg, &rb);
+		if (unlikely(ret)) {
+			netif_err(db, drv, ndev, "%s: error %d dumping read reg %02x\n",
+				  __func__, ret, reg);
+			break;
+		}
+	}
+	return ret;
+}
+
+static void dm9051_reg_lock_mutex(void *dbcontext)
+{
+	struct board_info *db = dbcontext;
+
+	mutex_lock(&db->reg_mutex);
+}
+
+static void dm9051_reg_unlock_mutex(void *dbcontext)
+{
+	struct board_info *db = dbcontext;
+
+	mutex_unlock(&db->reg_mutex);
+}
+
+static struct regmap_config regconfigdm = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = 0xff,
+	.reg_stride = 1,
+	.cache_type = REGCACHE_NONE,
+	.read_flag_mask = 0,
+	.write_flag_mask = DM_SPI_WR,
+	.val_format_endian = REGMAP_ENDIAN_LITTLE,
+	.lock = dm9051_reg_lock_mutex, /* essential, sure for no-conflict read/write */
+	.unlock = dm9051_reg_unlock_mutex, /* essential, sure for no-conflict read/write */
+};
+
+static struct regmap_config regconfigdmbulk = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = 0xff,
+	.reg_stride = 1,
+	.cache_type = REGCACHE_NONE,
+	.read_flag_mask = 0,
+	.write_flag_mask = DM_SPI_WR,
+	.val_format_endian = REGMAP_ENDIAN_LITTLE,
+	.lock = dm9051_reg_lock_mutex, /* essential, sure for no-conflict read/write */
+	.unlock = dm9051_reg_unlock_mutex, /* essential, sure for no-conflict read/write */
+	.use_single_read = true,
+	.use_single_write = true,
+};
+
+static int dm9051_map_chipid(struct board_info *db)
+{
+	struct device *dev = &db->spidev->dev;
+	unsigned int ret;
+	unsigned short wid;
+	u8 buff[6];
+
+	ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_VIDL, buff, 6);
+	if (unlikely(ret)) {
+		netif_err(db, drv, db->ndev, "%s: error %d bulk_read reg %02x\n",
+			  __func__, ret, DM9051_VIDL);
+		return ret;
+	}
+
+	wid = buff[3] << 8 | buff[2];
+	if (wid != DM9051_ID) {
+		dev_err(dev, "chipid error as %04x !\n", wid);
+		return -ENODEV;
+	}
+
+	dev_info(dev, "chip %04x found\n", wid);
+	return 0;
+}
+
+/* mac address is major from EEPROM
+ */
+static int dm9051_map_macaddr_init(struct net_device *ndev, struct board_info *db)
+{
+	u8 addr[ETH_ALEN];
+	int ret;
+
+	ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_PAR, addr, ETH_ALEN);
+	if (unlikely(ret))
+		return ret;
+
+	if (!is_valid_ether_addr(addr)) {
+		eth_hw_addr_random(ndev);
+		dev_dbg(&db->spidev->dev, "Use random MAC address\n");
+		return 0;
+	}
+
+	eth_hw_addr_set(ndev, addr);
+	return 0;
+}
+
+static void dm9051_handle_link_change(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	int lcl_adv, rmt_adv, ret;
+	u8 fcr = 0;
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
+		/* while both rx_pause & tx_pause
+		 * fcr will result idenical as FCR_RXTX_ENABLE
+		 */
+		if (db->eth_pause.rx_pause)
+			fcr |= FCR_BKPM | FCR_FLCE;
+		if (db->eth_pause.tx_pause)
+			fcr |= FCR_TXPEN;
+
+		ret = regmap_update_bits(db->regmap_dm, DM9051_FCR, 0xff, fcr);
+		if (unlikely(ret))
+			netif_err(db, drv, ndev, "%s: error %d update bits reg %02x\n",
+				  __func__, ret, DM9051_FCR);
+	}
+}
+
+/* phy connect as poll mode
+ */
+static int dm9051_phy_connect(struct board_info *db)
+{
+	char phy_id[MII_BUS_ID_SIZE + 3];
+
+	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
+		 db->mdiobus->id, DM9051_PHY_ID);
+
+	db->phydev = phy_connect(db->ndev, phy_id, dm9051_handle_link_change,
+				 PHY_INTERFACE_MODE_MII);
+	if (IS_ERR(db->phydev))
+		return PTR_ERR_OR_ZERO(db->phydev);
+	return 0;
+}
+
+/* ethtool-ops
+ */
+static void dm9051_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
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
+	if ((len | offset) & 1)
+		return -EINVAL;
+
+	ee->magic = DM_EEPROM_MAGIC;
+
+	for (i = 0; i < len; i += 2) {
+		ret = dm9051_map_eeread(db, (offset + i) / 2, data + i);
+		if (unlikely(ret))
+			break;
+	}
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
+	if ((len | offset) & 1)
+		return -EINVAL;
+
+	if (ee->magic != DM_EEPROM_MAGIC)
+		return -EINVAL;
+
+	for (i = 0; i < len; i += 2) {
+		ret = dm9051_map_eewrite(db, (offset + i) / 2, data + i);
+		if (unlikely(ret))
+			break;
+	}
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
+	u8 fcr = 0;
+	int ret;
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
+	ret = regmap_update_bits(db->regmap_dm, DM9051_FCR, 0xff, fcr);
+	if (unlikely(ret))
+		netif_err(db, drv, ndev, "%s: error %d update bits reg %02x\n",
+			  __func__, ret, DM9051_FCR);
+	return ret;
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
+static int dm9051_direct_reset_code(struct board_info *db)
+{
+	int ret;
+
+	db->bc.fifo_rst_counter++;
+
+	ret = regmap_write(db->regmap_dm, DM9051_NCR, NCR_RST); /* NCR reset */
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_MBNDRY, MBNDRY_BYTE); /* MemBound */
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_PPCR, PPCR_PAUSE_COUNT); /* Pause Count */
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_LMCR, db->lcr_all); /* LEDMode1 */
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_INTCR, INTCR_POL_LOW); /* INTCR */
+	if (unlikely(ret))
+		return ret;
+	return ret;
+}
+
+/* reset while rx error found
+ */
+static int dm9051_direct_fifo_reset(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+	int rxlen = le16_to_cpu(db->eth_rxhdr.rxlen);
+	u8 fcr = 0;
+	int ret;
+
+	ret = dm9051_direct_reset_code(db);
+	if (unlikely(ret))
+		return ret;
+
+	if (db->eth_pause.rx_pause)
+		fcr |= FCR_BKPM | FCR_FLCE;
+	if (db->eth_pause.tx_pause)
+		fcr |= FCR_TXPEN;
+
+	ret = regmap_write(db->regmap_dm, DM9051_FCR, fcr);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_IMR, db->imr_all); /* rxp to 0xc00 */
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_RCR, db->rcr_all); /* enable rx all */
+	if (unlikely(ret))
+		return ret;
+
+	netdev_dbg(ndev, "rxhdr-byte (%02x)\n",
+		   db->eth_rxhdr.rxpktready);
+	netdev_dbg(ndev, "check rxstatus-eror (%02x)\n",
+		   db->eth_rxhdr.rxstatus);
+	netdev_dbg(ndev, "check rxlen large-eror (%d > %d)\n",
+		   rxlen, DM9051_PKT_MAX);
+
+	netdev_dbg(ndev, " rxstatus_Er & rxlen_Er %d, RST_c %d\n",
+		   db->bc.status_err_counter + db->bc.large_err_counter,
+		   db->bc.fifo_rst_counter);
+	return ret;
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
+	struct net_device *ndev = db->ndev;
+	unsigned int rxbyte;
+	int ret, rxlen;
+	struct sk_buff *skb;
+	u8 *rdptr;
+	int scanrr = 0;
+
+	do {
+		ret = regmap_noinc_read(db->regmap_dm, DM_SPI_MRCMDX, &rxbyte, 2);
+		if (unlikely(ret)) {
+			netif_err(db, drv, ndev, "%s: error %d noinc reading reg %02x, len %d\n",
+				  __func__, ret, DM_SPI_MRCMDX, 2);
+			return ret;
+		}
+
+		if ((rxbyte & 0xff) != DM9051_PKT_RDY)
+			break; /* exhaust-empty */
+
+		ret = regmap_noinc_read(db->regmap_dm, DM_SPI_MRCMD, &db->eth_rxhdr, DM_RXHDR_SIZE);
+		if (unlikely(ret))
+			return ret;
+
+		ret = regmap_write(db->regmap_dm, DM9051_ISR, 0xff); /* to stop mrcmd */
+		if (unlikely(ret))
+			return ret;
+
+		rxlen = le16_to_cpu(db->eth_rxhdr.rxlen);
+		if (db->eth_rxhdr.rxstatus & RSR_ERR_BITS || rxlen > DM9051_PKT_MAX) {
+			if (db->eth_rxhdr.rxstatus & RSR_ERR_BITS)
+				db->bc.status_err_counter++;
+			else
+				db->bc.large_err_counter++;
+			ret = dm9051_direct_fifo_reset(db);
+			if (unlikely(ret))
+				return ret;
+			return 0;
+		}
+
+		skb = dev_alloc_skb(rxlen);
+		if (!skb) {
+			ret = dm9051_map_dumpblk(db, DM_SPI_MRCMD, rxlen);
+			if (unlikely(ret))
+				return ret;
+			return scanrr;
+		}
+
+		rdptr = skb_put(skb, rxlen - 4);
+		ret = regmap_noinc_read(db->regmap_dm, DM_SPI_MRCMD, rdptr, rxlen);
+		if (unlikely(ret)) {
+			dev_kfree_skb(skb);
+			return ret;
+		}
+
+		ret = regmap_write(db->regmap_dm, DM9051_ISR, 0xff); /* to stop mrcmd */
+		if (unlikely(ret))
+			return ret;
+
+		skb->protocol = eth_type_trans(skb, db->ndev);
+		if (db->ndev->features & NETIF_F_RXCSUM)
+			skb_checksum_none_assert(skb);
+		netif_rx_ni(skb);
+		db->ndev->stats.rx_bytes += rxlen;
+		db->ndev->stats.rx_packets++;
+		scanrr++;
+	} while (!ret);
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
+
+	ret = dm9051_map_xmitpoll(db);
+	if (ret)
+		return -ETIMEDOUT;
+
+	ret = regmap_noinc_write(db->regmap_dm, DM_SPI_MWCMD, buff, len);
+	if (unlikely(ret))
+		return ret;
+
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_TXPLL, &len, 2);
+	if (unlikely(ret))
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_TCR, TCR_TXREQ);
+	if (unlikely(ret))
+		return ret;
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
+static irqreturn_t dm9051_rx_threaded_irq(int irq, void *pw)
+{
+	struct board_info *db = pw;
+	int result, resul_tx;
+
+	mutex_lock(&db->spi_lockm); /* mutex essential */
+	if (netif_carrier_ok(db->ndev)) {
+		result = regmap_write(db->regmap_dm, DM9051_IMR, IMR_PAR); /* disable imr */
+		if (unlikely(result))
+			goto spi_err;
+
+		do {
+			result = dm9051_loop_rx(db); /* threaded irq rx */
+			if (result < 0)
+				goto spi_err;
+			resul_tx = dm9051_loop_tx(db); /* more tx better performance */
+			if (resul_tx < 0)
+				goto spi_err;
+		} while (result > 0);
+
+		result = regmap_write(db->regmap_dm, DM9051_IMR, db->imr_all); /* enable imr */
+		if (unlikely(result))
+			goto spi_err;
+	}
+spi_err:
+	mutex_unlock(&db->spi_lockm); /* mutex essential */
+	return IRQ_HANDLED;
+}
+
+static void dm9051_tx_delay(struct kthread_work *ws)
+{
+	struct board_info *db = container_of(ws, struct board_info, kw_tx);
+	int result;
+
+	mutex_lock(&db->spi_lockm); /* mutex essential */
+	result = dm9051_loop_tx(db);
+	if (result < 0)
+		netdev_err(db->ndev, "transmit packet error\n");
+	mutex_unlock(&db->spi_lockm); /* mutex essential */
+}
+
+static void dm9051_rxctl_delay(struct kthread_work *ws)
+{
+	struct board_info *db = container_of(ws, struct board_info, kw_rxctrl);
+	struct net_device *ndev = db->ndev;
+	int result;
+
+	mutex_lock(&db->spi_lockm); /* mutex essential */
+	result = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr, ETH_ALEN);
+	if (unlikely(result)) {
+		netif_err(db, drv, ndev, "%s: error %d bulk writing reg %02x, len %d\n",
+			  __func__, result, DM9051_PAR, ETH_ALEN);
+		goto spi_err;
+	}
+
+	result = regmap_bulk_write(db->regmap_dmbulk, DM9051_MAR, db->hash_table, 8);
+	if (unlikely(result)) {
+		netif_err(db, drv, ndev, "%s: error %d bulk writing reg %02x, len %d\n",
+			  __func__, result, DM9051_MAR, 8);
+		goto spi_err;
+	}
+	result = regmap_write(db->regmap_dm, DM9051_RCR, db->rcr_all); /* rx enable */
+	if (unlikely(result))
+		netif_err(db, drv, ndev, "%s: error %d write reg %02x\n",
+			  __func__, result, DM9051_RCR);
+spi_err:
+	mutex_unlock(&db->spi_lockm); /* mutex essential */
+}
+
+static int dm9051_map_phyup(struct board_info *db)
+{
+	int ret;
+
+	/* ~BMCR_PDOWN to power-up phyxcer
+	 */
+	ret = mdiobus_modify(db->mdiobus, DM9051_PHY_ID, MII_BMCR, BMCR_PDOWN, 0);
+	if (ret < 0)
+		return ret;
+
+	/* chip internal operation need wait 1 ms for if GPR power-up phy
+	 */
+	ret = regmap_write(db->regmap_dm, DM9051_GPR, 0);
+	if (unlikely(ret))
+		return ret;
+	mdelay(1);
+
+	return 0;
+}
+
+static int dm9051_map_phydown(struct board_info *db)
+{
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_GPR, GPR_PHY_ON); /* Power-Down PHY */
+	if (unlikely(ret))
+		return ret;
+	return ret;
+}
+
+static int dm9051_all_start(struct board_info *db)
+{
+	int ret;
+
+	ret = dm9051_map_phyup(db);
+	if (unlikely(ret))
+		return ret;
+	ret = dm9051_direct_reset_code(db);
+	if (unlikely(ret))
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_IMR, db->imr_all); /* phyup, rxp to 0xc00 */
+	if (unlikely(ret))
+		return ret;
+	return ret;
+}
+
+static int dm9051_all_stop(struct board_info *db)
+{
+	int ret;
+
+	ret = dm9051_map_phydown(db);
+	if (unlikely(ret))
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_RCR, RCR_RX_DISABLE); /* rx disable */
+	if (unlikely(ret))
+		return ret;
+	return ret;
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
+	ret = dm9051_all_start(db);
+	if (unlikely(ret)) {
+		free_irq(spi->irq, db);
+		netif_stop_queue(ndev);
+		return ret;
+	}
+
+	phy_support_sym_pause(db->phydev); /* Enable support of sym pause */
+	phy_start(db->phydev); /* it enclose with mutex_lock/mutex_unlock */
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
+	int ret;
+
+	free_irq(db->spidev->irq, db);
+	netif_stop_queue(ndev);
+
+	phy_stop(db->phydev);
+	ret = dm9051_all_stop(db);
+	return ret;
+}
+
+/* event: play a schedule starter in condition
+ */
+static netdev_tx_t dm9051_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	skb_queue_tail(&db->txq, skb); /* add to skb */
+	if (skb_queue_len(&db->txq) > DM9051_TX_QUE_HI_WATER)
+		netif_stop_queue(ndev); /* enforce limit queue size */
+	kthread_queue_work(&db->kw, &db->kw_tx);
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
+		db->hash_table[hash_val / 16] |= 1U << (hash_val % 16);
+	}
+	kthread_queue_work(&db->kw, &db->kw_rxctrl);
+}
+
+/* event: write into the mac registers and eeprom directly
+ */
+static int dm9051_set_mac_address(struct net_device *ndev, void *p)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	int ret;
+
+	ret = eth_mac_addr(ndev, p);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr, ETH_ALEN);
+	if (unlikely(ret)) {
+		netif_err(db, drv, ndev, "%s: error %d bulk writing reg %02x, len %d\n",
+			  __func__, ret, DM9051_PAR, ETH_ALEN);
+		return ret;
+	}
+	return ret;
+}
+
+/* netdev-ops
+ */
+static const struct of_device_id dm9051_match_table[] = {
+	{ .compatible = "davicom,dm9051", },
+	{}
+};
+
+static const struct spi_device_id dm9051_id_table[] = {
+	{ "dm9051", 0 },
+	{}
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
+static void dm9051_operation_clear(struct board_info *db)
+{
+	db->bc.status_err_counter = 0;
+	db->bc.large_err_counter = 0;
+	db->bc.fifo_rst_counter = 0;
+}
+
+static void dm9051_netdev(struct net_device *ndev)
+{
+	ndev->mtu = 1500;
+	ndev->if_port = IF_PORT_100BASET;
+	ndev->netdev_ops = &dm9051_netdev_ops;
+	ndev->ethtool_ops = &dm9051_ethtool_ops;
+}
+
+static int dm9051_map_init(struct spi_device *spi, struct board_info *db)
+{
+	/* create two regmap instances,
+	 * run read/write and bulk_read/bulk_write individually,
+	 * to resolve regmap execution confliction problem
+	 */
+	regconfigdm.lock_arg = db;
+	db->regmap_dm = devm_regmap_init_spi(db->spidev, &regconfigdm);
+
+	if (IS_ERR(db->regmap_dm))
+		return PTR_ERR_OR_ZERO(db->regmap_dm);
+
+	regconfigdmbulk.lock_arg = db;
+	db->regmap_dmbulk = devm_regmap_init_spi(db->spidev, &regconfigdmbulk);
+
+	if (IS_ERR(db->regmap_dmbulk))
+		return PTR_ERR_OR_ZERO(db->regmap_dmbulk);
+	return 0;
+}
+
+static int dm9051_mdiobus_register(struct board_info *db)
+{
+	struct spi_device *spi = db->spidev;
+	int ret;
+
+	db->mdiobus = devm_mdiobus_alloc(&spi->dev);
+	if (!db->mdiobus)
+		return -ENOMEM;
+
+	db->mdiobus->priv = db;
+	db->mdiobus->read = dm9051_mdiobus_read;
+	db->mdiobus->write = dm9051_mdiobus_write;
+	db->mdiobus->name = "dm9051-mdiobus";
+	db->mdiobus->phy_mask = ~GENMASK(1, 1);
+	db->mdiobus->parent = &spi->dev;
+	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
+		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
+
+	ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
+	if (ret) {
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
+	mutex_init(&db->spi_lockm);
+	mutex_init(&db->reg_mutex);
+
+	kthread_init_worker(&db->kw);
+	kthread_init_work(&db->kw_rxctrl, dm9051_rxctl_delay);
+	kthread_init_work(&db->kw_tx, dm9051_tx_delay);
+
+	db->kwr_task_kw = kthread_run(kthread_worker_fn, &db->kw, "dm9051");
+	if (IS_ERR(db->kwr_task_kw))
+		return PTR_ERR(db->kwr_task_kw);
+
+	ret = dm9051_map_init(spi, db);
+	if (ret)
+		goto err_stopthread;
+
+	ret = dm9051_map_chipid(db);
+	if (ret)
+		goto err_stopthread;
+
+	ret = dm9051_map_macaddr_init(ndev, db);
+	if (ret < 0)
+		goto err_stopthread;
+
+	ret = dm9051_mdiobus_register(db);
+	if (ret)
+		goto err_stopthread;
+
+	ret = dm9051_phy_connect(db);
+	if (ret)
+		goto err_stopthread;
+
+	dm9051_operation_clear(db);
+	ret = devm_register_netdev(dev, ndev);
+	if (ret) {
+		dev_err(dev, "failed to register network device\n");
+		kthread_stop(db->kwr_task_kw);
+		phy_disconnect(db->phydev);
+		return ret;
+	}
+
+	skb_queue_head_init(&db->txq);
+	return 0;
+
+err_stopthread:
+	kthread_stop(db->kwr_task_kw);
+	return ret;
+}
+
+static int dm9051_drv_remove(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct board_info *db = to_dm9051_board(ndev);
+
+	kthread_stop(db->kwr_task_kw);
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
index 000000000000..85eb90dc97e0
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Davicom Semiconductor,Inc.
+ * Davicom DM9051 SPI Fast Ethernet Linux driver
+ */
+
+#ifndef _DM9051_H_
+#define _DM9051_H_
+
+#include <linux/bitfield.h>
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
+#define DM9051_VIDL		0x28
+#define DM9051_VIDH		0x29
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
+#define DM_SPI_MRCMDX		0x70
+#define DM_SPI_MRCMD		0x72
+#define DM_SPI_MWCMD		0x78
+
+#define DM_SPI_WR		0x80
+
+/* dm9051 Ethernet
+ */
+/* 0x00 */
+#define NCR_WAKEEN		BIT(6)
+#define NCR_FDX			BIT(3)
+#define NCR_RST			BIT(0)
+/* 0x01 */
+#define NSR_SPEED		BIT(7)
+#define NSR_LINKST		BIT(6)
+#define NSR_WAKEST		BIT(5)
+#define NSR_TX2END		BIT(3)
+#define NSR_TX1END		BIT(2)
+/* 0x02 */
+#define TCR_DIS_JABBER_TIMER	BIT(6) /* for Jabber Packet support */
+#define TCR_TXREQ		BIT(0)
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
+#define	RSR_ERR_BITS		(RSR_RF | RSR_LCS | RSR_RWTO | RSR_PLE | \
+				 RSR_AE | RSR_CE | RSR_FOE)
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
+/* 0x1F */
+#define GPR_PHY_ON		BIT(0)
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
+#define DM_EEPROM_MAGIC			0x9051
+
+#define	DM_RXHDR_SIZE			sizeof(struct dm9051_rxhdr)
+
+static inline struct board_info *to_dm9051_board(struct net_device *ndev)
+{
+	return netdev_priv(ndev);
+}
+
+#endif /* _DM9051_H_ */
-- 
2.20.1

