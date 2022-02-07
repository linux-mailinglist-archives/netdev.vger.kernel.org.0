Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB344AB79E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 10:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245209AbiBGJTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238892AbiBGJJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:09:45 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C4EC0401C0;
        Mon,  7 Feb 2022 01:09:43 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id e6so11863897pfc.7;
        Mon, 07 Feb 2022 01:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=crU+cZ+rjYaLfVaHloLwSdEllWCcLUhZ/b+bGsU5ilM=;
        b=Uiyw8RFrC96eFlqKHc/h7q2NhDqreJQEqQUot7g8tCLdosA2hGCH85nbcUpZeTFXBB
         snD7vBGFVzkPiUIQGLqo3SuG1IV06G3pfrCgCt3yV6WSEhL/8dgGoTQdCjuzw8+voO4Y
         lkLuEC8yjPeDxcKE8LOSnFbhrRVDDbMKb/ZbP4ekjVJPpukWDuzIVU5iRSpEaIM+SpxA
         sUDfXgY9UEq5oHqul2z/PwZBbRPbJIY7Rq3JkLUjHCrwulcNoVc9nc/3587wKbf+TbM5
         v/D4TJ/zZsXcdfl2ShKtd06+esEswunMHBDIAVe1K+fYVvua8Is3GsESKYbBrupXGlsE
         yBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=crU+cZ+rjYaLfVaHloLwSdEllWCcLUhZ/b+bGsU5ilM=;
        b=ZzPKla3kHfkFnG0TldyQkrmUwYLhrxZe5IhZdqNK5IrV0oIYF5hP/uQXI38hplfron
         I5tjh3+VyjgdI2c6bELqmFsxxWbna17NZyaSY+I73tcO/8Cz85/cYcrKMKps9pudKlXq
         u00iXD6r+mPke+xfAxb6IWrH5aylF+bBvMCPqbQYM/TgUFaFJ5HR+RWa3UItf6iadVz8
         iR98nUG2Ft4tTXYdArQPAk/+bwxepHn6q92tYSrhR54Mt/CamXhBXcqi3f7ntqwOaLs7
         wVQmz9rnSjVyXsDcPPwjtbo7uW+HDKJHCHn8PmnsDwO1sZ9zKRJ/kJfBJjS9fyStmaON
         qUFw==
X-Gm-Message-State: AOAM531jnDk524PXOrf/1SyXHIq3HaDTQp6X14SXSnVDM19NiBKUF370
        taLsm0uBVW5CTXEFO4vFScs=
X-Google-Smtp-Source: ABdhPJwp2HwcOuG+SMnDBQyYfZOVRZtQXRzUjBEZfCjsZFSUJdHzQzPDKF1MygYEdrgRmcAoLBFsPQ==
X-Received: by 2002:a05:6a00:2183:: with SMTP id h3mr14786365pfi.12.1644224982474;
        Mon, 07 Feb 2022 01:09:42 -0800 (PST)
Received: from localhost.localdomain (61-231-109-204.dynamic-ip.hinet.net. [61.231.109.204])
        by smtp.gmail.com with ESMTPSA id x187sm7796724pgx.10.2022.02.07.01.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 01:09:42 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v18, 2/2] net: Add dm9051 driver
Date:   Mon,  7 Feb 2022 17:09:06 +0800
Message-Id: <20220207090906.11156-3-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220207090906.11156-1-josright123@gmail.com>
References: <20220207090906.11156-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add davicom dm9051 spi ethernet driver, The driver work for the
device platform which has the spi master

Signed-off-by: Joseph CHAMG <josright123@gmail.com>
---
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: andy Shevchenko <andy.shevchenko@gmail.com>

v1-v4

Test ok with raspberry pi 2 and pi 4

v5

swapped to phylib for phy connection tasks

v6

remove the redundant code that phylib has support

v7

read/write registers must return error code to the caller

v8

not parmanently set MAC by .ndo_set_mac_address

v9

improve the registers read/write so that error code
return as far as possible up the call stack.

v10

use regmap APIs for SPI and MDIO

v11

use regmap_read_poll_timeout
use corresponding regmap APIs, i.e. SPI, MDIO

v12

use mdiobus API instead of regmap MDIO APIs

v13

Simply all regmap APIs return value checked
Clear the fifo reset report
Eliminate redundant comments

Comment that DM9051_GPR register bit 0 function for power-up
the internal phy, if this bit is updated from 1 to 0, then the
whole dm9051 chip registers could not be accessed within 1 ms,
so that has mdelay(1) to wait 1 ms

v14

To eliminate touching PHY registers, instead take advantage of phy_start
to have it
Make neat to be readable exactly

v15

Process the mac address function to be exactly right
Re-arrange functions for better style
Handle to auto negotiation to be right procedure

v16

Let netif_wake_queue at the bottom of dm9051_open
Add draining tx queue in dm9051_stop

v17

Chnage from kthread_work to work_struct 

v18

Clean the code with suitable macro, correctly using phy_device and
to be a reasonable interrupt service routine

 drivers/net/ethernet/davicom/Kconfig  |   31 +
 drivers/net/ethernet/davicom/Makefile |    1 +
 drivers/net/ethernet/davicom/dm9051.c | 1256 +++++++++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h |  162 ++++
 4 files changed, 1450 insertions(+)
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
index 000000000000..2a356e8a688b
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -0,0 +1,1256 @@
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
+#include <linux/irq.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/regmap.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/spi/spi.h>
+#include <linux/types.h>
+
+#include "dm9051.h"
+
+#define DRVNAME_9051	"dm9051"
+
+/**
+ * struct rx_ctl_mach - rx activities record
+ * @status_err_counter: rx status error counter
+ * @large_err_counter: rx get large packet length error counter
+ * @rx_err_counter: receive packet error counter
+ * @tx_err_counter: transmit packet error counter
+ * @fifo_rst_counter: reset operation counter
+ *
+ * To keep track for the driver operation statistics
+ */
+struct rx_ctl_mach {
+	u16				status_err_counter;
+	u16				large_err_counter;
+	u16				rx_err_counter;
+	u16				tx_err_counter;
+	u16				fifo_rst_counter;
+};
+
+/**
+ * struct dm9051_rxctrl - dm9051 driver rx control
+ * @hash_table: Multicast hash-table data
+ * @rcr_all: KS_RXCR1 register setting
+ *
+ * The settings needs to control the receive filtering
+ * such as the multicast hash-filter and the receive register settings
+ */
+struct dm9051_rxctrl {
+	u16				hash_table[4];
+	u8				rcr_all;
+};
+
+/**
+ * struct dm9051_rxhdr - rx packet data header
+ * @headbyte: lead byte equal to 0x01 notifies a valid packet
+ * @status: status bits for the received packet
+ * @rxlen: packet length
+ *
+ * The Rx packed, entered into the FIFO memory, start with these
+ * four bytes which is the Rx header, followed by the ethernet
+ * packet data and ends with an appended 4-byte CRC data.
+ * Both Rx packet and CRC data are for check purpose and finally
+ * are dropped by this driver
+ */
+struct dm9051_rxhdr {
+	u8				headbyte;
+	u8				status;
+	__le16				rxlen;
+};
+
+/**
+ * struct board_info - maintain the saved data
+ * @spidev: spi device structure
+ * @ndev: net device structure
+ * @mdiobus: mii bus structure
+ * @phydev: phy device structure
+ * @txq: tx queue structure
+ * @regmap_dm: regmap for register read/write
+ * @regmap_dmbulk: extra regmap for bulk read/write
+ * @rxctrl_work: Work queue for updating RX mode and multicast lists
+ * @tx_work: Work queue for tx packets
+ * @pause: ethtool pause parameter structure
+ * @spi_lockm: between threads lock structure
+ * @reg_mutex: regmap access lock structure
+ * @bc: rx control statistics structure
+ * @rxhdr: rx header structure
+ * @rctl: rx control setting structure
+ * @msg_enable: message level value
+ * @imr_all: to store operating imr value for register DM9051_IMR
+ * @lcr_all: to store operating rcr value for register DM9051_LMCR
+ *
+ * The saved data variables, keep up to date for retrieval back to use
+ */
+struct board_info {
+	u32				msg_enable;
+	struct spi_device		*spidev;
+	struct net_device		*ndev;
+	struct mii_bus			*mdiobus;
+	struct phy_device		*phydev;
+	struct sk_buff_head		txq;
+	struct regmap			*regmap_dm;
+	struct regmap			*regmap_dmbulk;
+	struct work_struct		rxctrl_work;
+	struct work_struct		tx_work;
+	struct ethtool_pauseparam	pause;
+	struct mutex			spi_lockm;
+	struct mutex			reg_mutex;
+	struct rx_ctl_mach		bc;
+	struct dm9051_rxhdr		rxhdr;
+	struct dm9051_rxctrl		rctl;
+	u8				imr_all;
+	u8				lcr_all;
+};
+
+/* waiting tx-end rather than tx-req
+ * got faster
+ */
+static int dm9051_map_xmitpoll(struct board_info *db)
+{
+	unsigned int mval;
+	int ret;
+
+	ret = regmap_read_poll_timeout(db->regmap_dm, DM9051_NSR, mval,
+				       mval & (NSR_TX2END | NSR_TX1END), 1, 20);
+	if (ret)
+		netdev_err(db->ndev, "timeout in checking for tx ends\n");
+	return ret;
+}
+
+static int dm9051_map_ee_phypoll(struct board_info *db)
+{
+	unsigned int mval;
+	int ret;
+
+	ret = regmap_read_poll_timeout(db->regmap_dm, DM9051_EPCR, mval,
+				       !(mval & EPCR_ERRE), 100, 10000);
+	if (ret)
+		netdev_err(db->ndev, "eeprom/phy in processing get timeout\n");
+	return ret;
+}
+
+static int dm9051_map_eeread(struct board_info *db, int offset, u8 *to)
+{
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, offset);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_ERPRR);
+	if (ret)
+		return ret;
+
+	ret = dm9051_map_ee_phypoll(db);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, 0);
+	if (ret)
+		return ret;
+
+	return regmap_bulk_read(db->regmap_dmbulk, DM9051_EPDRL, to, 2);
+}
+
+static int dm9051_map_eewrite(struct board_info *db, int offset, u8 *data)
+{
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, offset);
+	if (ret)
+		return ret;
+
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_EPDRL, data, 2);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_WEP | EPCR_ERPRW);
+	if (ret)
+		return ret;
+
+	ret = dm9051_map_ee_phypoll(db);
+	if (ret)
+		return ret;
+
+	return regmap_write(db->regmap_dm, DM9051_EPCR, 0);
+}
+
+static int ctrl_dm9051_phyread(void *context, unsigned int reg, unsigned int *val)
+{
+	struct board_info *db = context;
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, DM9051_PHY | reg);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
+	if (ret)
+		return ret;
+
+	ret = dm9051_map_ee_phypoll(db);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, 0);
+	if (ret)
+		return ret;
+
+	/* this is a 4 bytes data, clear to zero since following regmap_bulk_read
+	 * only fill lower 2 bytes
+	 */
+	*val = 0;
+	return regmap_bulk_read(db->regmap_dmbulk, DM9051_EPDRL, val, 2);
+}
+
+static int ctrl_dm9051_phywrite(void *context, unsigned int reg, unsigned int val)
+{
+	struct board_info *db = context;
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPAR, DM9051_PHY | reg);
+	if (ret)
+		return ret;
+
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_EPDRL, &val, 2);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_write(db->regmap_dm, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
+	if (ret)
+		return ret;
+
+	ret = dm9051_map_ee_phypoll(db);
+	if (ret)
+		return ret;
+
+	return regmap_write(db->regmap_dm, DM9051_EPCR, 0);
+}
+
+static int dm9051_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct board_info *db = bus->priv;
+	unsigned int val = 0xffff;
+	int ret;
+
+	if (addr == DM9051_PHY_ADDR) {
+		ret = ctrl_dm9051_phyread(db, regnum, &val);
+		if (ret)
+			return ret;
+	}
+
+	return val;
+}
+
+static int dm9051_mdiobus_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	struct board_info *db = bus->priv;
+
+	if (addr == DM9051_PHY_ADDR)
+		return ctrl_dm9051_phywrite(db, regnum, val);
+
+	return -ENODEV;
+}
+
+static int dm9051_irq_flag(struct board_info *db)
+{
+	struct spi_device *spi = db->spidev;
+	int irq_type = irq_get_trigger_type(spi->irq);
+
+	if (irq_type)
+		return irq_type;
+
+	return IRQF_TRIGGER_LOW;
+}
+
+static unsigned int dm9051_intcr_value(struct board_info *db)
+{
+	return (dm9051_irq_flag(db) == IRQF_TRIGGER_LOW) ?
+		INTCR_POL_LOW : INTCR_POL_HIGH;
+}
+
+static int dm9051_set_reg(struct board_info *db, unsigned int reg, unsigned int val)
+{
+	int ret;
+
+	ret = regmap_write(db->regmap_dm, reg, val);
+	if (ret)
+		netif_err(db, drv, db->ndev, "%s: error %d set reg %02x\n",
+			  __func__, ret, reg);
+	return ret;
+}
+
+static int dm9051_update_bits(struct board_info *db, unsigned int reg, unsigned int mask,
+			      unsigned int val)
+{
+	int ret;
+
+	ret = regmap_update_bits(db->regmap_dm, reg, mask, val);
+	if (ret)
+		netif_err(db, drv, db->ndev, "%s: error %d update bits reg %02x\n",
+			  __func__, ret, reg);
+	return ret;
+}
+
+static int dm9051_set_intcr(struct board_info *db)
+{
+	return dm9051_set_reg(db, DM9051_INTCR, dm9051_intcr_value(db));
+}
+
+static int dm9051_set_fcr(struct board_info *db)
+{
+	u8 fcr = 0;
+
+	if (db->pause.rx_pause)
+		fcr |= FCR_BKPM | FCR_FLCE;
+	if (db->pause.tx_pause)
+		fcr |= FCR_TXPEN;
+
+	return dm9051_set_reg(db, DM9051_FCR, fcr);
+}
+
+static int dm9051_update_fcr(struct board_info *db)
+{
+	u8 fcr = 0;
+
+	if (db->pause.rx_pause)
+		fcr |= FCR_BKPM | FCR_FLCE;
+	if (db->pause.tx_pause)
+		fcr |= FCR_TXPEN;
+
+	return dm9051_update_bits(db, DM9051_FCR, FCR_RXTX_BITS, fcr);
+}
+
+static int dm9051_set_recv(struct board_info *db)
+{
+	int ret;
+
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_MAR, db->rctl.hash_table,
+				sizeof(db->rctl.hash_table));
+	if (ret) {
+		netif_err(db, drv, db->ndev, "%s: error %d bulk write reg %02x\n",
+			  __func__, ret, DM9051_MAR);
+		return ret;
+	}
+
+	return dm9051_set_reg(db, DM9051_RCR, db->rctl.rcr_all); /* enable rx */
+}
+
+static int dm9051_clear_interrupt(struct board_info *db)
+{
+	return dm9051_update_bits(db, DM9051_ISR, ISR_CLR_INT, ISR_CLR_INT);
+}
+
+static int dm9051_disable_interrupt(struct board_info *db)
+{
+	return dm9051_set_reg(db, DM9051_IMR, IMR_PAR); /* disable int */
+}
+
+static int dm9051_enable_interrupt(struct board_info *db)
+{
+	return dm9051_set_reg(db, DM9051_IMR, db->imr_all); /* enable int */
+}
+
+static int dm9051_stop_mrcmd(struct board_info *db)
+{
+	return dm9051_set_reg(db, DM9051_ISR, ISR_STOP_MRCMD); /* to stop mrcmd */
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
+	.lock = dm9051_reg_lock_mutex,
+	.unlock = dm9051_reg_unlock_mutex,
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
+	.lock = dm9051_reg_lock_mutex,
+	.unlock = dm9051_reg_unlock_mutex,
+	.use_single_read = true,
+	.use_single_write = true,
+};
+
+static int dm9051_map_init(struct spi_device *spi, struct board_info *db)
+{
+	/* create two regmap instances,
+	 * split read/write and bulk_read/bulk_write to individual regmap
+	 * to resolve regmap execution confliction problem
+	 */
+	regconfigdm.lock_arg = db;
+	db->regmap_dm = devm_regmap_init_spi(db->spidev, &regconfigdm);
+	if (IS_ERR(db->regmap_dm))
+		return PTR_ERR(db->regmap_dm);
+
+	regconfigdmbulk.lock_arg = db;
+	db->regmap_dmbulk = devm_regmap_init_spi(db->spidev, &regconfigdmbulk);
+	if (IS_ERR(db->regmap_dmbulk))
+		return PTR_ERR(db->regmap_dmbulk);
+
+	return 0;
+}
+
+static int dm9051_map_chipid(struct board_info *db)
+{
+	struct device *dev = &db->spidev->dev;
+	unsigned int ret;
+	unsigned short wid;
+	u8 buff[6];
+
+	ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_VIDL, buff, sizeof(buff));
+	if (ret < 0) {
+		netif_err(db, drv, db->ndev, "%s: error %d bulk_read reg %02x\n",
+			  __func__, ret, DM9051_VIDL);
+		return ret;
+	}
+
+	wid = get_unaligned_le16(buff + 2);
+	if (wid != DM9051_ID) {
+		dev_err(dev, "chipid error as %04x !\n", wid);
+		return -ENODEV;
+	}
+
+	dev_info(dev, "chip %04x found\n", wid);
+	return 0;
+}
+
+/* Read DM9051_PAR registers which is the mac address loaded from EEPROM while power-on
+ */
+static int dm9051_map_etherdev_par(struct net_device *ndev, struct board_info *db)
+{
+	u8 addr[ETH_ALEN];
+	int ret;
+
+	ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_PAR, addr, sizeof(addr));
+	if (ret < 0)
+		return ret;
+
+	if (!is_valid_ether_addr(addr)) {
+		eth_hw_addr_random(ndev);
+
+		ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr,
+					sizeof(ndev->dev_addr));
+		if (ret < 0)
+			return ret;
+
+		dev_dbg(&db->spidev->dev, "Use random MAC address\n");
+		return 0;
+	}
+
+	eth_hw_addr_set(ndev, addr);
+	return 0;
+}
+
+static int dm9051_mdio_register(struct board_info *db)
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
+	db->mdiobus->phy_mask = (u32)~BIT(1);
+	db->mdiobus->parent = &spi->dev;
+	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
+		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
+
+	ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
+	if (ret)
+		dev_err(&spi->dev, "Could not register MDIO bus\n");
+
+	return ret;
+}
+
+static void dm9051_handle_link_change(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	phy_print_status(db->phydev);
+
+	/* only write pause settings to mac. since mac and phy are integrated
+	 * together, such as link state, speed and duplex are sync already
+	 */
+	if (db->phydev->link) {
+		if (db->phydev->pause) {
+			db->pause.rx_pause = true;
+			db->pause.tx_pause = true;
+		}
+		dm9051_update_fcr(db);
+	}
+}
+
+/* phy connect as poll mode
+ */
+static int dm9051_phy_connect(struct board_info *db)
+{
+	char phy_id[MII_BUS_ID_SIZE + 3];
+
+	snprintf(phy_id, sizeof(phy_id), PHY_ID_FMT,
+		 db->mdiobus->id, DM9051_PHY_ADDR);
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
+		if (ret)
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
+		if (ret)
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
+	*pause = db->pause;
+}
+
+static int dm9051_set_pauseparam(struct net_device *ndev,
+				 struct ethtool_pauseparam *pause)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	db->pause = *pause;
+
+	if (pause->autoneg == AUTONEG_DISABLE)
+		return dm9051_update_fcr(db);
+
+	phy_set_sym_pause(db->phydev, pause->rx_pause, pause->tx_pause,
+			  pause->autoneg);
+	phy_start_aneg(db->phydev);
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
+static int dm9051_direct_reset_code(struct board_info *db)
+{
+	int ret;
+
+	db->bc.fifo_rst_counter++;
+
+	ret = regmap_write(db->regmap_dm, DM9051_NCR, NCR_RST); /* NCR reset */
+	if (ret)
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_MBNDRY, MBNDRY_BYTE); /* MemBound */
+	if (ret)
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_PPCR, PPCR_PAUSE_COUNT); /* Pause Count */
+	if (ret)
+		return ret;
+	ret = regmap_write(db->regmap_dm, DM9051_LMCR, db->lcr_all); /* LEDMode1 */
+	if (ret)
+		return ret;
+
+	return dm9051_set_intcr(db);
+}
+
+static int dm9051_fifo_restart(struct board_info *db)
+{
+	struct net_device *ndev = db->ndev;
+	int ret;
+
+	ret = dm9051_direct_reset_code(db);
+	if (ret)
+		return ret;
+
+	netdev_dbg(ndev, " rxstatus_Er & rxlen_Er %d, RST_c %d\n",
+		   db->bc.status_err_counter + db->bc.large_err_counter,
+		   db->bc.fifo_rst_counter);
+	return 0;
+}
+
+/* fifo reset while rx error found
+ */
+static int dm9051_direct_fifo_reset(struct board_info *db)
+{
+	int ret;
+
+	ret = dm9051_fifo_restart(db);
+	if (ret)
+		return ret;
+
+	ret = dm9051_set_fcr(db);
+	if (ret)
+		return ret;
+
+	ret = dm9051_enable_interrupt(db);
+	if (ret)
+		return ret;
+
+	return dm9051_set_recv(db);
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
+	do {
+		ret = regmap_read(db->regmap_dm, reg, &rb);
+		if (ret) {
+			netif_err(db, drv, ndev, "%s: error %d dumping read reg %02x\n",
+				  __func__, ret, reg);
+			break;
+		}
+	} while (--count);
+
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
+		if (ret) {
+			netif_err(db, drv, ndev, "%s: error %d noinc reading reg %02x, len %d\n",
+				  __func__, ret, DM_SPI_MRCMDX, 2);
+			return ret;
+		}
+
+		if ((rxbyte & GENMASK(7, 0)) != DM9051_PKT_RDY)
+			break; /* exhaust-empty */
+
+		ret = regmap_noinc_read(db->regmap_dm, DM_SPI_MRCMD, &db->rxhdr, DM_RXHDR_SIZE);
+		if (ret)
+			return ret;
+
+		ret = dm9051_stop_mrcmd(db);
+		if (ret)
+			return ret;
+
+		rxlen = le16_to_cpu(db->rxhdr.rxlen);
+		if (db->rxhdr.status & RSR_ERR_BITS || rxlen > DM9051_PKT_MAX) {
+			netdev_dbg(ndev, "rxhdr-byte (%02x)\n",
+				   db->rxhdr.headbyte);
+
+			if (db->rxhdr.status & RSR_ERR_BITS) {
+				db->bc.status_err_counter++;
+				netdev_dbg(ndev, "check rxstatus-eror (%02x)\n",
+					   db->rxhdr.status);
+			} else {
+				db->bc.large_err_counter++;
+				netdev_dbg(ndev, "check rxlen large-eror (%d > %d)\n",
+					   rxlen, DM9051_PKT_MAX);
+			}
+			return dm9051_direct_fifo_reset(db);
+		}
+
+		skb = dev_alloc_skb(rxlen);
+		if (!skb) {
+			ret = dm9051_map_dumpblk(db, DM_SPI_MRCMD, rxlen);
+			if (ret)
+				return ret;
+			return scanrr;
+		}
+
+		rdptr = skb_put(skb, rxlen - 4);
+		ret = regmap_noinc_read(db->regmap_dm, DM_SPI_MRCMD, rdptr, rxlen);
+		if (ret) {
+			db->bc.rx_err_counter++;
+			dev_kfree_skb(skb);
+			return ret;
+		}
+
+		ret = dm9051_stop_mrcmd(db);
+		if (ret)
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
+
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
+		return ret;
+
+	ret = regmap_noinc_write(db->regmap_dm, DM_SPI_MWCMD, buff, len);
+	if (ret)
+		return ret;
+
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_TXPLL, &len, 2);
+	if (ret < 0)
+		return ret;
+
+	return dm9051_set_reg(db, DM9051_TCR, TCR_TXREQ);
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
+			if (ret < 0) {
+				db->bc.tx_err_counter++;
+				return 0;
+			}
+			ndev->stats.tx_bytes += skb->len;
+			ndev->stats.tx_packets++;
+		}
+
+		if (netif_queue_stopped(ndev) &&
+		    (skb_queue_len(&db->txq) < DM9051_TX_QUE_LO_WATER))
+			netif_wake_queue(ndev);
+	}
+
+	return ntx;
+}
+
+static irqreturn_t dm9051_rx_threaded_irq(int irq, void *pw)
+{
+	struct board_info *db = pw;
+	int result, result_tx;
+
+	mutex_lock(&db->spi_lockm);
+
+	result = dm9051_disable_interrupt(db);
+	if (result)
+		goto out_unlock;
+
+	result = dm9051_clear_interrupt(db);
+	if (result)
+		goto out_unlock;
+
+	do {
+		result = dm9051_loop_rx(db); /* threaded irq rx */
+		if (result < 0)
+			goto out_unlock;
+		result_tx = dm9051_loop_tx(db); /* more tx better performance */
+		if (result_tx < 0)
+			goto out_unlock;
+	} while (result > 0);
+
+	dm9051_enable_interrupt(db);
+
+	/* To exit and has mutex unlock while rx or tx error
+	 */
+out_unlock:
+	mutex_unlock(&db->spi_lockm);
+
+	return IRQ_HANDLED;
+}
+
+static void dm9051_tx_delay(struct work_struct *work)
+{
+	struct board_info *db = container_of(work, struct board_info, tx_work);
+	int result;
+
+	mutex_lock(&db->spi_lockm);
+
+	result = dm9051_loop_tx(db);
+	if (result < 0)
+		netdev_err(db->ndev, "transmit packet error\n");
+
+	mutex_unlock(&db->spi_lockm);
+}
+
+static void dm9051_rxctl_delay(struct work_struct *work)
+{
+	struct board_info *db = container_of(work, struct board_info, rxctrl_work);
+	struct net_device *ndev = db->ndev;
+	int result;
+
+	mutex_lock(&db->spi_lockm);
+
+	result = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr,
+				   sizeof(ndev->dev_addr));
+	if (result < 0) {
+		netif_err(db, drv, ndev, "%s: error %d bulk writing reg %02x, len %d\n",
+			  __func__, result, DM9051_PAR, sizeof(ndev->dev_addr));
+		goto out_unlock;
+	}
+
+	dm9051_set_recv(db);
+
+	/* To has mutex unlock and return from this function if regmap function fail
+	 */
+out_unlock:
+	mutex_unlock(&db->spi_lockm);
+}
+
+static int dm9051_all_start(struct board_info *db)
+{
+	int ret;
+
+	/* GPR power on of the internal phy
+	 */
+	ret = dm9051_set_reg(db, DM9051_GPR, 0);
+	if (ret)
+		return ret;
+
+	/* dm9051 chip registers could not be accessed within 1 ms
+	 * after GPR power on, delay 1 ms is essential
+	 */
+	mdelay(1);
+
+	ret = dm9051_direct_reset_code(db);
+	if (ret)
+		return ret;
+
+	return dm9051_enable_interrupt(db);
+}
+
+static int dm9051_all_stop(struct board_info *db)
+{
+	int ret;
+
+	/* GPR power off of the internal phy,
+	 * The internal phy still could be accessed after this GPR power off control
+	 */
+	ret = dm9051_set_reg(db, DM9051_GPR, GPR_PHY_OFF);
+	if (ret)
+		return ret;
+
+	return dm9051_set_reg(db, DM9051_RCR, RCR_RX_DISABLE);
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
+	db->imr_all = IMR_PAR | IMR_PRM;
+	db->lcr_all = LMCR_MODE1;
+	db->rctl.rcr_all = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
+	memset(db->rctl.hash_table, 0, sizeof(db->rctl.hash_table));
+
+	ndev->irq = spi->irq; /* by dts */
+	ret = request_threaded_irq(spi->irq, NULL, dm9051_rx_threaded_irq,
+				   dm9051_irq_flag(db) | IRQF_ONESHOT,
+				   ndev->name, db);
+	if (ret < 0) {
+		netdev_err(ndev, "failed to get irq\n");
+		return ret;
+	}
+
+	phy_support_sym_pause(db->phydev);
+	phy_start(db->phydev);
+
+	/* flow control parameters init */
+	db->pause.rx_pause = true;
+	db->pause.tx_pause = true;
+	db->pause.autoneg = AUTONEG_DISABLE;
+
+	if (db->phydev->autoneg)
+		db->pause.autoneg = AUTONEG_ENABLE;
+
+	ret = dm9051_all_start(db);
+	if (ret) {
+		phy_stop(db->phydev);
+		free_irq(spi->irq, db);
+		return ret;
+	}
+
+	netif_wake_queue(ndev);
+
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
+	ret = dm9051_all_stop(db);
+	if (ret)
+		return ret;
+
+	flush_work(&db->tx_work);
+	flush_work(&db->rxctrl_work);
+
+	phy_stop(db->phydev);
+
+	free_irq(db->spidev->irq, db);
+
+	netif_stop_queue(ndev);
+
+	skb_queue_purge(&db->txq);
+
+	return 0;
+}
+
+/* event: play a schedule starter in condition
+ */
+static netdev_tx_t dm9051_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+
+	skb_queue_tail(&db->txq, skb);
+	if (skb_queue_len(&db->txq) > DM9051_TX_QUE_HI_WATER)
+		netif_stop_queue(ndev); /* enforce limit queue size */
+
+	schedule_work(&db->tx_work);
+
+	return NETDEV_TX_OK;
+}
+
+/* event: play with a schedule starter
+ */
+static void dm9051_set_rx_mode(struct net_device *ndev)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	struct dm9051_rxctrl rxctrl;
+	struct netdev_hw_addr *ha;
+	u8 rcr = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
+	u32 hash_val;
+
+	memset(&rxctrl, 0, sizeof(rxctrl));
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
+	rxctrl.rcr_all = rcr;
+
+	/* broadcast address */
+	rxctrl.hash_table[0] = 0;
+	rxctrl.hash_table[1] = 0;
+	rxctrl.hash_table[2] = 0;
+	rxctrl.hash_table[3] = 0x8000;
+
+	/* the multicast address in Hash Table : 64 bits */
+	netdev_for_each_mc_addr(ha, ndev) {
+		hash_val = ether_crc_le(ETH_ALEN, ha->addr) & GENMASK(5, 0);
+		rxctrl.hash_table[hash_val / 16] |= BIT(0) << (hash_val % 16);
+	}
+
+	/* schedule work to do the actual set of the data if needed */
+
+	if (memcmp(&db->rctl, &rxctrl, sizeof(rxctrl))) {
+		memcpy(&db->rctl, &rxctrl, sizeof(rxctrl));
+		schedule_work(&db->rxctrl_work);
+	}
+}
+
+/* event: write into the mac registers and eeprom directly
+ */
+static int dm9051_set_mac_address(struct net_device *ndev, void *p)
+{
+	struct board_info *db = to_dm9051_board(ndev);
+	int ret;
+
+	ret = eth_prepare_mac_addr_change(ndev, p);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr,
+				sizeof(ndev->dev_addr));
+	if (ret < 0) {
+		netif_err(db, drv, ndev, "%s: error %d bulk writing reg %02x\n",
+			  __func__, ret, DM9051_PAR);
+		return ret;
+	}
+
+	eth_commit_mac_addr_change(ndev, p);
+
+	return 0;
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
+	.ndo_set_rx_mode = dm9051_set_rx_mode,
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
+	db->bc.rx_err_counter = 0;
+	db->bc.tx_err_counter = 0;
+	db->bc.fifo_rst_counter = 0;
+}
+
+static int dm9051_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct net_device *ndev;
+	struct board_info *db;
+	int ret;
+
+	ndev = devm_alloc_etherdev(dev, sizeof(struct board_info));
+	if (!ndev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(ndev, dev);
+	dev_set_drvdata(dev, ndev);
+
+	db = netdev_priv(ndev);
+
+	db->msg_enable = 0;
+	db->spidev = spi;
+	db->ndev = ndev;
+
+	ndev->netdev_ops = &dm9051_netdev_ops;
+	ndev->ethtool_ops = &dm9051_ethtool_ops;
+
+	mutex_init(&db->spi_lockm);
+	mutex_init(&db->reg_mutex);
+
+	INIT_WORK(&db->rxctrl_work, dm9051_rxctl_delay);
+	INIT_WORK(&db->tx_work, dm9051_tx_delay);
+
+	ret = dm9051_map_init(spi, db);
+	if (ret)
+		return ret;
+
+	ret = dm9051_map_chipid(db);
+	if (ret)
+		return ret;
+
+	ret = dm9051_map_etherdev_par(ndev, db);
+	if (ret < 0)
+		return ret;
+
+	ret = dm9051_mdio_register(db);
+	if (ret)
+		return ret;
+
+	ret = dm9051_phy_connect(db);
+	if (ret)
+		return ret;
+
+	dm9051_operation_clear(db);
+	skb_queue_head_init(&db->txq);
+
+	ret = devm_register_netdev(dev, ndev);
+	if (ret) {
+		phy_disconnect(db->phydev);
+		return dev_err_probe(dev, ret, "device register failed");
+	}
+
+	return 0;
+}
+
+static int dm9051_drv_remove(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct board_info *db = to_dm9051_board(ndev);
+
+	phy_disconnect(db->phydev);
+
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
index 000000000000..42303a6407a9
--- /dev/null
+++ b/drivers/net/ethernet/davicom/dm9051.h
@@ -0,0 +1,162 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Davicom Semiconductor,Inc.
+ * Davicom DM9051 SPI Fast Ethernet Linux driver
+ */
+
+#ifndef _DM9051_H_
+#define _DM9051_H_
+
+#include <linux/bits.h>
+#include <linux/netdevice.h>
+#include <linux/types.h>
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
+#define FCR_RXTX_BITS		(FCR_TXPEN | FCR_BKPM | FCR_FLCE)
+/* 0x0B */
+#define EPCR_WEP		BIT(4)
+#define EPCR_EPOS		BIT(3)
+#define EPCR_ERPRR		BIT(2)
+#define EPCR_ERPRW		BIT(1)
+#define EPCR_ERRE		BIT(0)
+/* 0x1E */
+#define GPCR_GEP_CNTL		BIT(0)
+/* 0x1F */
+#define GPR_PHY_OFF		BIT(0)
+/* 0x30 */
+#define	ATCR_AUTO_TX		BIT(7)
+/* 0x39 */
+#define INTCR_POL_LOW		(1 << 0)
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
+#define ISR_LNKCHG		BIT(5)
+#define ISR_ROOS		BIT(3)
+#define ISR_ROS			BIT(2)
+#define ISR_PTS			BIT(1)
+#define ISR_PRS			BIT(0)
+#define ISR_CLR_INT		(ISR_LNKCHG | ISR_ROOS | ISR_ROS | \
+				 ISR_PTS | ISR_PRS)
+#define ISR_STOP_MRCMD		(ISR_MBS)
+/* 0xFF */
+#define IMR_PAR			BIT(7)
+#define IMR_LNKCHGI		BIT(5)
+#define IMR_PTM			BIT(1)
+#define IMR_PRM			BIT(0)
+
+/* Const
+ */
+#define DM9051_PHY_ADDR			1	/* PHY id */
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

